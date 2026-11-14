require "rails_helper"

RSpec.describe "Phase 1 Audit Event failure atomicity" do
  it "rolls back draft creation and permits a complete retry" do
    branch_id = SecureRandom.uuid
    attributes = draft_attributes(branch_id:, idempotency_key: "audit-failure-draft")
    install_audit_failure!

    expect { Orders::CreateDraft.call(**attributes) }
      .to raise_error(ActiveRecord::StatementInvalid, /m03 injected audit failure/)

    expect(Order.where(branch_id: branch_id)).to be_empty
    expect(Payment.joins(:order).where(orders: { branch_id: branch_id })).to be_empty
    expect(AuditEvent.where(branch_id: branch_id)).to be_empty

    remove_audit_failure!
    result = Orders::CreateDraft.call(**attributes)

    expect(result.replayed).to be(false)
    expect(result.order).to be_persisted
    expect(result.payment).to be_persisted
    expect(AuditEvent.where(branch_id: branch_id, event_type: "order.created").count).to eq(1)
  ensure
    remove_audit_failure!
  end

  it "rolls back settlement, dispatch, and outbox evidence and permits a complete retry" do
    actor_id, now, order = create_confirmed_order("audit-failure-settlement")
    attributes = payment_attributes(order:, actor_id:, key: "audit-failure-settlement", now: now + 1.minute)
    install_audit_failure!

    expect { Payments::ConfirmCash.call(**attributes) }
      .to raise_error(ActiveRecord::StatementInvalid, /m03 injected audit failure/)

    expect(order.payment.reload).to have_attributes(funding_status: "unpaid", successful_amount: 0)
    expect(order.payment.payment_attempts).to be_empty
    expect(order.preparation_dispatch).to be_nil
    expect(OutboxEvent.where(event_type: "preparation.dispatch_requested")).to be_empty
    expect(AuditEvent.where(event_type: "payment.confirmed", subject_type: "PaymentAttempt")).to be_empty

    remove_audit_failure!
    result = Payments::ConfirmCash.call(**attributes.merge(clock: -> { now + 2.minutes }))

    expect(result.payment).to have_attributes(funding_status: "fully_paid", successful_amount: 80_000)
    expect(result.preparation_dispatch).to be_present
    expect(order.payment.payment_attempts.where(status: "succeeded").count).to eq(1)
    expect(OutboxEvent.where(aggregate_id: result.preparation_dispatch.id).count).to eq(1)
    expect(AuditEvent.where(event_type: "payment.confirmed", subject_id: result.payment_attempt.id).count).to eq(1)
  ensure
    remove_audit_failure!
  end

  it "rolls back late-success settlement and review evidence and permits a complete retry" do
    actor_id, now, order = create_confirmed_order("audit-failure-late-success")
    Orders::ExpirePending.call(now: order.payment_expires_at)
    attributes = payment_attributes(
      order: order,
      actor_id: actor_id,
      key: "audit-failure-late-success",
      now: order.payment_expires_at + 1.minute
    )
    install_audit_failure!

    expect { Payments::ConfirmBankTransfer.call(**attributes) }
      .to raise_error(ActiveRecord::StatementInvalid, /m03 injected audit failure/)

    expect(order.reload).to have_attributes(status: "expired")
    expect(order.payment.reload).to have_attributes(funding_status: "unpaid", successful_amount: 0)
    expect(order.payment.payment_attempts).to be_empty
    expect(PaymentReviewCase.where(order_id: order.id)).to be_empty
    expect(order.preparation_dispatch).to be_nil

    remove_audit_failure!
    result = Payments::ConfirmBankTransfer.call(**attributes)

    expect(result.payment).to have_attributes(funding_status: "fully_paid", successful_amount: 80_000)
    expect(result.review_case).to have_attributes(kind: "late_success", status: "open")
    expect(order.payment.payment_attempts.where(status: "succeeded").count).to eq(1)
    expect(PaymentReviewCase.where(order_id: order.id).count).to eq(1)
    expect(AuditEvent.where(event_type: "payment.late_success_recorded").count).to eq(1)
  ensure
    remove_audit_failure!
  end

  it "rolls back expiration and permits a complete retry" do
    _actor_id, _now, order = create_confirmed_order("audit-failure-expiration")
    deadline = order.payment_expires_at
    install_audit_failure!

    expect { Orders::ExpirePending.call(now: deadline) }
      .to raise_error(ActiveRecord::StatementInvalid, /m03 injected audit failure/)

    expect(order.reload).to have_attributes(status: "confirmed", expired_at: nil)
    expect(AuditEvent.where(event_type: "order.payment_window_expired", subject_id: order.id)).to be_empty

    remove_audit_failure!
    result = Orders::ExpirePending.call(now: deadline)

    expect(result.expired_order_ids).to contain_exactly(order.id)
    expect(order.reload).to have_attributes(status: "expired", expired_at: deadline)
    expect(AuditEvent.where(event_type: "order.payment_window_expired", subject_id: order.id).count).to eq(1)
  ensure
    remove_audit_failure!
  end

  it "rolls back a hold and permits a complete retry" do
    actor_id, now, order = create_confirmed_order("audit-failure-hold")
    expected_version = order.lock_version
    attributes = {
      order_id: order.id,
      actor_id: actor_id,
      reason: "Bank notification requires review",
      idempotency_key: "audit-failure-hold",
      expected_version: expected_version,
      now: now + 1.minute
    }
    install_audit_failure!

    expect { Orders::Hold.call(**attributes) }
      .to raise_error(ActiveRecord::StatementInvalid, /m03 injected audit failure/)

    expect(order.reload).to have_attributes(
      status: "confirmed",
      held_at: nil,
      hold_reason: nil,
      hold_idempotency_key: nil,
      lock_version: expected_version
    )
    expect(AuditEvent.where(event_type: "order.held", subject_id: order.id)).to be_empty

    remove_audit_failure!
    result = Orders::Hold.call(**attributes)

    expect(result.replayed).to be(false)
    expect(result.order).to have_attributes(status: "held", hold_reason: "Bank notification requires review")
    expect(AuditEvent.where(event_type: "order.held", subject_id: order.id).count).to eq(1)
  ensure
    remove_audit_failure!
  end

  def create_confirmed_order(suffix)
    actor_id = SecureRandom.uuid
    now = Time.utc(2026, 11, 14, 10, 0, 0)
    order = Orders::CreateDraft.call(
      **draft_attributes(branch_id: SecureRandom.uuid, idempotency_key: "create-#{suffix}", actor_id: actor_id)
    ).order
    Orders::Confirm.call(
      order_id: order.id,
      actor_id: actor_id,
      idempotency_key: "confirm-#{suffix}",
      expected_version: order.lock_version,
      now: now
    )
    [ actor_id, now, order.reload ]
  end

  def draft_attributes(branch_id:, idempotency_key:, actor_id: SecureRandom.uuid)
    {
      actor_id: actor_id,
      branch_id: branch_id,
      channel: "takeaway",
      total_amount: 80_000,
      currency_code: "VND",
      idempotency_key: idempotency_key,
      now: Time.utc(2026, 11, 14, 10, 0, 0)
    }
  end

  def payment_attributes(order:, actor_id:, key:, now:)
    {
      order_id: order.id,
      actor_id: actor_id,
      amount: order.total_amount,
      currency_code: order.currency_code,
      idempotency_key: key,
      clock: -> { now }
    }
  end

  def install_audit_failure!
    connection.execute(<<~SQL)
      CREATE FUNCTION fail_m03_audit_insert() RETURNS trigger AS $$
      BEGIN
        RAISE EXCEPTION 'm03 injected audit failure';
      END;
      $$ LANGUAGE plpgsql;
      CREATE TRIGGER fail_m03_audit_insert
      BEFORE INSERT ON audit_events
      FOR EACH ROW EXECUTE FUNCTION fail_m03_audit_insert();
    SQL
  end

  def remove_audit_failure!
    connection.execute("DROP TRIGGER IF EXISTS fail_m03_audit_insert ON audit_events")
    connection.execute("DROP FUNCTION IF EXISTS fail_m03_audit_insert()")
  end

  def connection
    ActiveRecord::Base.connection
  end
end
