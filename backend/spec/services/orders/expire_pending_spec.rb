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
end
