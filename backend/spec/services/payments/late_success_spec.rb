require "rails_helper"

RSpec.describe "late payment success" do
  it "records settlement for an expired order but opens review and never dispatches" do
    actor_id = SecureRandom.uuid
    opened_at = Time.utc(2026, 11, 14, 12, 0, 0)
    order = create_order_draft_record(
      actor_id: actor_id,
      branch_id: SecureRandom.uuid,
      channel: "dine_in",
      total_amount: 90_000,
      currency_code: "VND",
      idempotency_key: "create-late-spec",
      now: opened_at
    )
    confirm_order_record(
      order_id: order.id,
      actor_id: actor_id,
      idempotency_key: "confirm-late-spec",
      expected_version: order.lock_version,
      now: opened_at
    )
    expire_pending_orders(now: opened_at + 5.minutes)

    result = PaymentComposition.confirm_bank_transfer(
      order_id: order.id,
      actor_id: actor_id,
      amount: 90_000,
      currency_code: "VND",
      idempotency_key: "late-bank-confirmation",
      clock: -> { opened_at + 6.minutes }
    )

    expect(result.payment).to have_attributes(funding_status: "fully_paid", successful_amount: 90_000)
    expect(result.order).to have_attributes(status: "expired")
    expect(result.preparation_dispatch).to be_nil
    expect(result.review_case).to have_attributes(kind: "late_success", status: "open")
    expect(OutboxEvent.where(event_type: "preparation.dispatch_requested")).to be_empty
  end

  it "records settlement for a held order but never reactivates or dispatches it" do
    actor_id = SecureRandom.uuid
    now = Time.utc(2026, 11, 14, 13, 0, 0)
    order = create_order_draft_record(
      actor_id: actor_id,
      branch_id: SecureRandom.uuid,
      channel: "takeaway",
      total_amount: 70_000,
      currency_code: "VND",
      idempotency_key: "create-held-late-spec",
      now: now
    )
    confirm_order_record(
      order_id: order.id,
      actor_id: actor_id,
      idempotency_key: "confirm-held-late-spec",
      expected_version: order.lock_version,
      now: now
    )
    hold_order_record(
      order_id: order.id,
      actor_id: actor_id,
      reason: "Operator review",
      idempotency_key: "hold-late-spec",
      expected_version: order.reload.lock_version,
      now: now + 1.minute
    )

    result = PaymentComposition.confirm_bank_transfer(
      order_id: order.id,
      actor_id: actor_id,
      amount: 70_000,
      currency_code: "VND",
      idempotency_key: "held-bank-confirmation",
      clock: -> { now + 2.minutes }
    )

    expect(result.order).to have_attributes(status: "held")
    expect(result.payment).to have_attributes(funding_status: "fully_paid")
    expect(result.preparation_dispatch).to be_nil
    expect(result.review_case).to have_attributes(kind: "late_success", status: "open")
  end
end
