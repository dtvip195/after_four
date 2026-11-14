require "rails_helper"

RSpec.describe Orders::Confirm do
  it "confirms a draft and opens the five-minute payment window" do
    actor_id = SecureRandom.uuid
    now = Time.utc(2026, 11, 14, 10, 0, 0)
    order = Orders::CreateDraft.call(
      actor_id: actor_id,
      branch_id: SecureRandom.uuid,
      channel: "dine_in",
      total_amount: 80_000,
      currency_code: "VND",
      idempotency_key: "create-confirm-spec",
      now: now
    ).order

    result = described_class.call(
      order_id: order.id,
      actor_id: actor_id,
      idempotency_key: "confirm-spec",
      expected_version: order.lock_version,
      now: now
    )

    expect(result.order).to have_attributes(
      status: "confirmed",
      confirmed_at: now,
      payment_expires_at: now + 5.minutes
    )
  end

  it "uses the validated configured payment window exactly" do
    previous_window = Rails.configuration.x.orders.payment_window_seconds
    actor_id = SecureRandom.uuid
    now = Time.utc(2026, 11, 14, 10, 0, 0)
    order = Orders::CreateDraft.call(
      actor_id: actor_id,
      branch_id: SecureRandom.uuid,
      channel: "takeaway",
      total_amount: 80_000,
      currency_code: "VND",
      idempotency_key: "create-custom-window-spec",
      now: now
    ).order
    Rails.configuration.x.orders.payment_window_seconds = 900

    result = described_class.call(
      order_id: order.id,
      actor_id: actor_id,
      idempotency_key: "confirm-custom-window-spec",
      expected_version: order.lock_version,
      now: now
    )

    expect(result.order.payment_expires_at).to eq(now + 15.minutes)
  ensure
    Rails.configuration.x.orders.payment_window_seconds = previous_window
  end
end
