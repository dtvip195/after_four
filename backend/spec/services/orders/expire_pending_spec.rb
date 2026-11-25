require "rails_helper"

RSpec.describe Orders::ExpirePending do
  it "expires a confirmed unpaid order after its configured payment window" do
    actor_id = SecureRandom.uuid
    opened_at = Time.utc(2026, 11, 14, 10, 0, 0)
    order = Orders::CreateDraft.call(
      actor_id: actor_id,
      branch_id: SecureRandom.uuid,
      channel: "takeaway",
      total_amount: 95_000,
      currency_code: "VND",
      idempotency_key: "create-expiry-spec",
      now: opened_at
    ).order
    Orders::Confirm.call(
      order_id: order.id,
      actor_id: actor_id,
      idempotency_key: "confirm-expiry-spec",
      expected_version: order.lock_version,
      now: opened_at
    )

    result = described_class.call(now: opened_at + 5.minutes)

    expect(result.expired_order_ids).to contain_exactly(order.id)
    expect(order.reload).to have_attributes(status: "expired", expired_at: opened_at + 5.minutes)
  end

  it "returns expiration candidates in deadline then Order ID order" do
    actor_id = SecureRandom.uuid
    base_time = Time.utc(2026, 11, 14, 10, 0, 0)
    later = create_confirmed_order(actor_id:, now: base_time + 1.minute, suffix: "later")
    same_deadline_a = create_confirmed_order(actor_id:, now: base_time, suffix: "same-a")
    same_deadline_b = create_confirmed_order(actor_id:, now: base_time, suffix: "same-b")

    result = described_class.call(now: base_time + 6.minutes)

    expected_same_deadline = [ same_deadline_a.id, same_deadline_b.id ].sort
    expect(result.expired_order_ids).to eq(expected_same_deadline + [ later.id ])
    expect([ same_deadline_a, same_deadline_b, later ].map { |order| order.reload.status }).to all(eq("expired"))
  end

  def create_confirmed_order(actor_id:, now:, suffix:)
    order = Orders::CreateDraft.call(
      actor_id: actor_id,
      branch_id: SecureRandom.uuid,
      channel: "takeaway",
      total_amount: 95_000,
      currency_code: "VND",
      idempotency_key: "create-expiration-ordering-#{suffix}",
      now: now
    ).order
    Orders::Confirm.call(
      order_id: order.id,
      actor_id: actor_id,
      idempotency_key: "confirm-expiration-ordering-#{suffix}",
      expected_version: order.lock_version,
      now: now
    )
    order.reload
  end
end
