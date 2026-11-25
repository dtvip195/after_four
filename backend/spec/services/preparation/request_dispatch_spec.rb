require "rails_helper"

RSpec.describe Preparation::RequestDispatch do
  it "rejects dispatch while payment is pending" do
    actor_id = SecureRandom.uuid
    now = Time.utc(2026, 11, 14, 14, 0, 0)
    order = create_order_draft_record(
      actor_id: actor_id,
      branch_id: SecureRandom.uuid,
      channel: "takeaway",
      total_amount: 65_000,
      currency_code: "VND",
      idempotency_key: "create-pending-dispatch-spec",
      now: now
    )
    confirm_order_record(
      order_id: order.id,
      actor_id: actor_id,
      idempotency_key: "confirm-pending-dispatch-spec",
      expected_version: order.lock_version,
      now: now
    )
    payment_for(order).update!(attempt_activity: "processing")

    expect do
      described_class.call(
        order_id: order.id,
        actor_id: actor_id,
        idempotency_key: "pending-dispatch-request",
        clock: -> { now + 1.minute }
      )
    end.to raise_error(DomainError) { |error| expect(error.code).to eq("payment_not_fully_settled") }

    expect(preparation_dispatch_for(order)).to be_nil
  end

  it "rejects dispatch after an authoritative payment failure" do
    actor_id, now, order = create_confirmed_order("failed")
    payment_for(order).payment_attempt_records.create!(
      method: "cash",
      status: "failed",
      requested_amount: order.total_amount,
      currency_code: order.currency_code,
      idempotency_key: "failed-attempt"
    )

    expect do
      described_class.call(
        order_id: order.id,
        actor_id: actor_id,
        idempotency_key: "failed-dispatch",
        clock: -> { now }
      )
    end.to raise_error(DomainError) { |error| expect(error.code).to eq("payment_not_fully_settled") }
    expect(preparation_dispatch_for(order)).to be_nil
  end

  it "rejects dispatch while an unknown payment requires reconciliation" do
    actor_id, now, order = create_confirmed_order("unknown")
    payment_for(order).update!(attempt_activity: "reconciliation_required")

    expect do
      described_class.call(
        order_id: order.id,
        actor_id: actor_id,
        idempotency_key: "unknown-dispatch",
        clock: -> { now }
      )
    end.to raise_error(DomainError) { |error| expect(error.code).to eq("payment_not_fully_settled") }
    expect(preparation_dispatch_for(order)).to be_nil
  end

  it "rejects dispatch for an expired order" do
    actor_id, now, order = create_confirmed_order("expired")
    expire_pending_orders(now: now + 5.minutes)

    expect do
      described_class.call(
        order_id: order.id,
        actor_id: actor_id,
        idempotency_key: "expired-dispatch",
        clock: -> { now + 6.minutes }
      )
    end.to raise_error(DomainError) { |error| expect(error.code).to eq("order_not_dispatchable") }
    expect(preparation_dispatch_for(order)).to be_nil
  end

  def create_confirmed_order(suffix)
    actor_id = SecureRandom.uuid
    now = Time.utc(2026, 11, 14, 15, 0, 0)
    order = create_order_draft_record(
      actor_id: actor_id,
      branch_id: SecureRandom.uuid,
      channel: "takeaway",
      total_amount: 65_000,
      currency_code: "VND",
      idempotency_key: "create-#{suffix}-dispatch-spec",
      now: now
    )
    confirm_order_record(
      order_id: order.id,
      actor_id: actor_id,
      idempotency_key: "confirm-#{suffix}-dispatch-spec",
      expected_version: order.lock_version,
      now: now
    )
    [ actor_id, now, order ]
  end
end
