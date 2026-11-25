require "rails_helper"

RSpec.describe "payment settlement transaction recovery" do
  it "rolls back settlement when outbox persistence fails and succeeds on safe retry" do
    actor_id = SecureRandom.uuid
    now = Time.utc(2026, 11, 14, 18, 0, 0)
    order = create_order_draft_record(
      actor_id: actor_id,
      branch_id: SecureRandom.uuid,
      channel: "takeaway",
      total_amount: 45_000,
      currency_code: "VND",
      idempotency_key: "create-rollback-spec",
      now: now
    )
    confirm_order_record(
      order_id: order.id,
      actor_id: actor_id,
      idempotency_key: "confirm-rollback-spec",
      expected_version: order.lock_version,
      now: now
    )
    connection = ActiveRecord::Base.connection
    connection.execute(<<~SQL)
      CREATE FUNCTION fail_phase1_outbox_insert() RETURNS trigger AS $$
      BEGIN
        RAISE EXCEPTION 'phase1 injected outbox failure';
      END;
      $$ LANGUAGE plpgsql;
      CREATE TRIGGER fail_phase1_outbox_insert
      BEFORE INSERT ON outbox_events
      FOR EACH ROW EXECUTE FUNCTION fail_phase1_outbox_insert();
    SQL

    expect do
      Payments::ConfirmCash.call(
        order_id: order.id,
        actor_id: actor_id,
        amount: 45_000,
        currency_code: "VND",
        idempotency_key: "cash-rollback-spec",
        clock: -> { now + 1.minute }
      )
    end.to raise_error(ActiveRecord::StatementInvalid, /phase1 injected outbox failure/)

    expect(payment_for(order).reload).to have_attributes(funding_status: "unpaid", successful_amount: 0)
    expect(payment_for(order).payment_attempts).to be_empty
    expect(preparation_dispatch_for(order)).to be_nil
    expect(OutboxEvent.where(event_type: "preparation.dispatch_requested")).to be_empty
    expect(AuditEvent.where(event_type: "payment.confirmed")).to be_empty

    connection.execute("DROP TRIGGER fail_phase1_outbox_insert ON outbox_events")
    result = Payments::ConfirmCash.call(
      order_id: order.id,
      actor_id: actor_id,
      amount: 45_000,
      currency_code: "VND",
      idempotency_key: "cash-rollback-spec",
      clock: -> { now + 2.minutes }
    )
    expect(result.payment).to have_attributes(funding_status: "fully_paid")
    expect(result.preparation_dispatch).to be_present
    expect(payment_for(order).payment_attempts.where(status: "succeeded").count).to eq(1)
    expect(OutboxEvent.where(aggregate_id: result.preparation_dispatch.id).count).to eq(1)
    expect(AuditEvent.where(event_type: "payment.confirmed", subject_id: result.payment_attempt.id).count).to eq(1)
  ensure
    connection&.execute("DROP TRIGGER IF EXISTS fail_phase1_outbox_insert ON outbox_events")
    connection&.execute("DROP FUNCTION IF EXISTS fail_phase1_outbox_insert()")
  end
end
