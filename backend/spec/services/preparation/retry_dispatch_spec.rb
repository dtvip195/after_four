require "rails_helper"

RSpec.describe Preparation::RetryDispatch do
  it "requeues the existing dispatch without creating duplicate dispatch or outbox records" do
    actor_id = SecureRandom.uuid
    now = Time.utc(2026, 11, 14, 17, 0, 0)
    order = Orders::CreateDraft.call(
      actor_id: actor_id,
      branch_id: SecureRandom.uuid,
      channel: "takeaway",
      total_amount: 55_000,
      currency_code: "VND",
      idempotency_key: "create-retry-spec",
      now: now
    ).order
    Orders::Confirm.call(
      order_id: order.id,
      actor_id: actor_id,
      idempotency_key: "confirm-retry-spec",
      expected_version: order.lock_version,
      now: now
    )
    dispatch = Payments::ConfirmCash.call(
      order_id: order.id,
      actor_id: actor_id,
      amount: 55_000,
      currency_code: "VND",
      idempotency_key: "cash-retry-spec",
      clock: -> { now + 1.minute }
    ).preparation_dispatch

    first = described_class.call(
      preparation_dispatch_id: dispatch.id,
      actor_id: actor_id,
      idempotency_key: "retry-dispatch-1",
      now: now + 2.minutes
    )
    replay = described_class.call(
      preparation_dispatch_id: dispatch.id,
      actor_id: actor_id,
      idempotency_key: "retry-dispatch-1",
      now: now + 3.minutes
    )

    expect(first.preparation_dispatch.id).to eq(dispatch.id)
    expect(replay.replayed).to be(true)
    expect(PreparationDispatch.where(order_id: order.id).count).to eq(1)
    expect(OutboxEvent.where(aggregate_id: dispatch.id).count).to eq(1)
  end
end
