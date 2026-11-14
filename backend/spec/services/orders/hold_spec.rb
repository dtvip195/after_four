require "rails_helper"

RSpec.describe Orders::Hold do
  it "places a confirmed unpaid order on an attributed safety hold" do
    actor_id = SecureRandom.uuid
    now = Time.utc(2026, 11, 14, 13, 0, 0)
    order = Orders::CreateDraft.call(
      actor_id: actor_id,
      branch_id: SecureRandom.uuid,
      channel: "takeaway",
      total_amount: 75_000,
      currency_code: "VND",
      idempotency_key: "create-hold-spec",
      now: now
    ).order
    Orders::Confirm.call(
      order_id: order.id,
      actor_id: actor_id,
      idempotency_key: "confirm-hold-spec",
      expected_version: order.lock_version,
      now: now
    )

    result = described_class.call(
      order_id: order.id,
      actor_id: actor_id,
      reason: "Bank notification requires review",
      idempotency_key: "hold-spec",
      expected_version: order.reload.lock_version,
      now: now + 1.minute
    )

    expect(result.order).to have_attributes(
      status: "held",
      hold_reason: "Bank notification requires review",
      held_at: now + 1.minute
    )
  end
end
