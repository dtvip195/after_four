require "rails_helper"

RSpec.describe "Ordering Application composition" do
  it "persists a Draft and its exact-balance Payment through the canonical use case" do
    result = OrderingComposition.create_draft_use_case.call(
      actor_id: SecureRandom.uuid,
      branch_id: SecureRandom.uuid,
      channel: "takeaway",
      total_amount: 125_000,
      currency_code: "VND",
      idempotency_key: "application-composition-create",
      now: Time.utc(2026, 11, 14, 10, 0, 0)
    )

    expect(Orders::Infrastructure::Persistence::OrderRecord.find(result.order.id.to_s)).to have_attributes(
      status: "draft",
      order_number: a_string_matching(/\AAF-[0-9A-F]{12}\z/)
    )
    expect(Payment.find(result.payment_reference)).to have_attributes(
      funding_status: "unpaid",
      target_amount: 125_000,
      currency_code: "VND"
    )
  end

  it "uses the validated configured payment window exactly" do
    previous_window = Rails.configuration.x.orders.payment_window_seconds
    actor_id = SecureRandom.uuid
    now = Time.utc(2026, 11, 14, 10, 0, 0)
    order = create_order_draft_record(
      actor_id: actor_id,
      branch_id: SecureRandom.uuid,
      channel: "takeaway",
      total_amount: 80_000,
      currency_code: "VND",
      idempotency_key: "application-composition-window",
      now: now
    )
    Rails.configuration.x.orders.payment_window_seconds = 900

    result = OrderingComposition.confirm_use_case(clock: -> { now }).call(
      order_id: order.id,
      actor_id: actor_id,
      idempotency_key: "application-composition-confirm",
      expected_version: order.lock_version
    )

    expect(result.order.payment_expires_at).to eq(now + 15.minutes)
  ensure
    Rails.configuration.x.orders.payment_window_seconds = previous_window
  end
end
