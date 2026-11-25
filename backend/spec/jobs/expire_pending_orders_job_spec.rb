require "rails_helper"

RSpec.describe ExpirePendingOrdersJob do
  it "runs the canonical expiration use case" do
    actor_id = SecureRandom.uuid
    opened_at = Time.current - 10.minutes
    order = create_order_draft_record(
      actor_id: actor_id,
      branch_id: SecureRandom.uuid,
      channel: "takeaway",
      total_amount: 80_000,
      currency_code: "VND",
      idempotency_key: "expiration-job-create",
      now: opened_at
    )
    confirm_order_record(
      order_id: order.id,
      actor_id: actor_id,
      idempotency_key: "expiration-job-confirm",
      expected_version: order.lock_version,
      now: opened_at
    )

    described_class.perform_now

    expect(order.reload).to have_attributes(status: "expired")
    expect(AuditEvent.where(event_type: "order.payment_window_expired", subject_id: order.id).count).to eq(1)
  end
end
