require "rails_helper"

RSpec.describe "preparation dispatch transaction recovery" do
  it "rolls back a new Dispatch when Outbox persistence fails and permits a complete retry" do
    actor_id, now, order = create_dispatchable_order("outbox-insert-failure")
    attributes = dispatch_attributes(order:, actor_id:, key: "outbox-insert-failure", now: now + 1.minute)
    install_failure!(table: "outbox_events", operation: "INSERT", name: "outbox_insert")

    expect { Preparation::RequestDispatch.call(**attributes) }
      .to raise_error(ActiveRecord::StatementInvalid, /m03 injected outbox_insert failure/)

    expect(preparation_dispatch_for(order)).to be_nil
    expect(OutboxEvent.where(event_type: "preparation.dispatch_requested")).to be_empty
    expect(AuditEvent.where(event_type: "preparation.dispatch_requested")).to be_empty
    expect(payment_for(order).reload).to have_attributes(
      funding_status: "fully_paid",
      successful_amount: order.total_amount
    )
    expect(payment_for(order).payment_attempts.where(status: "succeeded").count).to eq(1)

    remove_failure!(table: "outbox_events", name: "outbox_insert")
    result = Preparation::RequestDispatch.call(**attributes)

    expect(result.replayed).to be(false)
    expect(PreparationDispatch.where(order_id: order.id).count).to eq(1)
    expect(OutboxEvent.where(aggregate_id: result.preparation_dispatch.id).count).to eq(1)
    expect(AuditEvent.where(event_type: "preparation.dispatch_requested", subject_id: result.preparation_dispatch.id).count).to eq(1)
  ensure
    remove_failure!(table: "outbox_events", name: "outbox_insert")
  end

  it "rolls back a new Dispatch and Outbox event when Audit persistence fails" do
    actor_id, now, order = create_dispatchable_order("audit-insert-failure")
    attributes = dispatch_attributes(order:, actor_id:, key: "audit-insert-failure", now: now + 1.minute)
    install_failure!(table: "audit_events", operation: "INSERT", name: "audit_insert")

    expect { Preparation::RequestDispatch.call(**attributes) }
      .to raise_error(ActiveRecord::StatementInvalid, /m03 injected audit_insert failure/)

    expect(preparation_dispatch_for(order)).to be_nil
    expect(OutboxEvent.where(event_type: "preparation.dispatch_requested")).to be_empty
    expect(AuditEvent.where(event_type: "preparation.dispatch_requested")).to be_empty
    expect(payment_for(order).reload).to have_attributes(
      funding_status: "fully_paid",
      successful_amount: order.total_amount
    )
    expect(payment_for(order).payment_attempts.where(status: "succeeded").count).to eq(1)

    remove_failure!(table: "audit_events", name: "audit_insert")
    result = Preparation::RequestDispatch.call(**attributes)

    expect(result.replayed).to be(false)
    expect(PreparationDispatch.where(order_id: order.id).count).to eq(1)
    expect(OutboxEvent.where(aggregate_id: result.preparation_dispatch.id).count).to eq(1)
    expect(AuditEvent.where(event_type: "preparation.dispatch_requested", subject_id: result.preparation_dispatch.id).count).to eq(1)
  ensure
    remove_failure!(table: "audit_events", name: "audit_insert")
  end

  it "rolls back the Outbox update when retry Audit persistence fails" do
    actor_id, now, order, dispatch, event = create_pending_dispatch("retry-audit-failure")
    mark_published(event, now + 2.minutes)
    attributes = retry_attributes(dispatch:, actor_id:, key: "retry-audit-failure", now: now + 3.minutes)
    install_failure!(table: "audit_events", operation: "INSERT", name: "retry_audit_insert")

    expect { Preparation::RetryDispatch.call(**attributes) }
      .to raise_error(ActiveRecord::StatementInvalid, /m03 injected retry_audit_insert failure/)

    expect(event.reload).to have_attributes(status: "published", published_at: now + 2.minutes)
    expect(AuditEvent.where(event_type: "preparation.dispatch_retry_requested", subject_id: dispatch.id)).to be_empty
    expect(payment_for(order).reload).to have_attributes(
      funding_status: "fully_paid",
      successful_amount: order.total_amount
    )
    expect(payment_for(order).payment_attempts.where(status: "succeeded").count).to eq(1)

    remove_failure!(table: "audit_events", name: "retry_audit_insert")
    result = Preparation::RetryDispatch.call(**attributes)

    expect(result.replayed).to be(false)
    expect(event.reload).to have_attributes(status: "pending", published_at: nil)
    expect(AuditEvent.where(event_type: "preparation.dispatch_retry_requested", subject_id: dispatch.id).count).to eq(1)
  ensure
    remove_failure!(table: "audit_events", name: "retry_audit_insert")
  end

  it "does not swallow an Outbox update failure during retry" do
    actor_id, now, order, dispatch, event = create_pending_dispatch("retry-outbox-failure")
    mark_published(event, now + 2.minutes)
    attributes = retry_attributes(dispatch:, actor_id:, key: "retry-outbox-failure", now: now + 3.minutes)
    install_failure!(table: "outbox_events", operation: "UPDATE", name: "retry_outbox_update")

    expect { Preparation::RetryDispatch.call(**attributes) }
      .to raise_error(ActiveRecord::StatementInvalid, /m03 injected retry_outbox_update failure/)

    expect(event.reload).to have_attributes(status: "published", published_at: now + 2.minutes)
    expect(AuditEvent.where(event_type: "preparation.dispatch_retry_requested", subject_id: dispatch.id)).to be_empty
    expect(payment_for(order).reload).to have_attributes(
      funding_status: "fully_paid",
      successful_amount: order.total_amount
    )
    expect(payment_for(order).payment_attempts.where(status: "succeeded").count).to eq(1)

    remove_failure!(table: "outbox_events", name: "retry_outbox_update")
    result = Preparation::RetryDispatch.call(**attributes)

    expect(result.replayed).to be(false)
    expect(event.reload).to have_attributes(status: "pending", published_at: nil)
    expect(AuditEvent.where(event_type: "preparation.dispatch_retry_requested", subject_id: dispatch.id).count).to eq(1)
  ensure
    remove_failure!(table: "outbox_events", name: "retry_outbox_update")
  end

  def create_dispatchable_order(suffix)
    actor_id = SecureRandom.uuid
    now = Time.utc(2026, 11, 14, 12, 0, 0)
    order = create_order_draft_record(
      actor_id: actor_id,
      branch_id: SecureRandom.uuid,
      channel: "takeaway",
      total_amount: 80_000,
      currency_code: "VND",
      idempotency_key: "create-#{suffix}",
      now: now
    )
    confirm_order_record(
      order_id: order.id,
      actor_id: actor_id,
      idempotency_key: "confirm-#{suffix}",
      expected_version: order.lock_version,
      now: now
    )
    record_valid_settlement(order, actor_id, now + 30.seconds)
    [ actor_id, now, order.reload ]
  end

  def create_pending_dispatch(suffix)
    actor_id = SecureRandom.uuid
    now = Time.utc(2026, 11, 14, 14, 0, 0)
    order = create_order_draft_record(
      actor_id: actor_id,
      branch_id: SecureRandom.uuid,
      channel: "takeaway",
      total_amount: 80_000,
      currency_code: "VND",
      idempotency_key: "create-#{suffix}",
      now: now
    )
    confirm_order_record(
      order_id: order.id,
      actor_id: actor_id,
      idempotency_key: "confirm-#{suffix}",
      expected_version: order.lock_version,
      now: now
    )
    dispatch = Payments::ConfirmCash.call(
      order_id: order.id,
      actor_id: actor_id,
      amount: order.total_amount,
      currency_code: order.currency_code,
      idempotency_key: "payment-#{suffix}",
      clock: -> { now + 1.minute }
    ).preparation_dispatch
    event = OutboxEvent.find_by!(event_key: "preparation.dispatch_requested:#{dispatch.id}")
    [ actor_id, now, order, dispatch, event ]
  end

  def record_valid_settlement(order, actor_id, settled_at)
    Payment.transaction do
      payment_for(order).payment_attempts.create!(
        method: "cash",
        status: "succeeded",
        requested_amount: order.total_amount,
        confirmed_amount: order.total_amount,
        currency_code: order.currency_code,
        idempotency_key: "recovery-fixture-#{order.id}",
        confirmed_by_actor_id: actor_id,
        confirmed_at: settled_at,
        created_at: settled_at,
        updated_at: settled_at
      )
      payment_for(order).update!(
        funding_status: "fully_paid",
        successful_amount: order.total_amount,
        fully_settled_at: settled_at,
        updated_at: settled_at
      )
    end
  end

  def dispatch_attributes(order:, actor_id:, key:, now:)
    {
      order_id: order.id,
      actor_id: actor_id,
      idempotency_key: key,
      clock: -> { now }
    }
  end

  def retry_attributes(dispatch:, actor_id:, key:, now:)
    {
      preparation_dispatch_id: dispatch.id,
      actor_id: actor_id,
      idempotency_key: key,
      now: now
    }
  end

  def mark_published(event, published_at)
    event.update!(status: "published", published_at: published_at, updated_at: published_at)
  end

  def install_failure!(table:, operation:, name:)
    connection.execute(<<~SQL)
      CREATE FUNCTION fail_m03_#{name}() RETURNS trigger AS $$
      BEGIN
        RAISE EXCEPTION 'm03 injected #{name} failure';
      END;
      $$ LANGUAGE plpgsql;
      CREATE TRIGGER fail_m03_#{name}
      BEFORE #{operation} ON #{table}
      FOR EACH ROW EXECUTE FUNCTION fail_m03_#{name}();
    SQL
  end

  def remove_failure!(table:, name:)
    connection.execute("DROP TRIGGER IF EXISTS fail_m03_#{name} ON #{table}")
    connection.execute("DROP FUNCTION IF EXISTS fail_m03_#{name}()")
  end

  def connection
    ActiveRecord::Base.connection
  end
end
