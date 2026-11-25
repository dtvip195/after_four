require "rails_helper"

RSpec.describe "payment deadline decision time" do
  it "dispatches normal settlement when the locked decision is before the deadline" do
    actor_id = SecureRandom.uuid
    confirmed_at = Time.utc(2026, 11, 14, 9, 0, 0)
    order = create_confirmed_order(actor_id:, confirmed_at:, suffix: "before-deadline")

    result = Payments::ConfirmCash.call(
      order_id: order.id,
      actor_id: actor_id,
      amount: order.total_amount,
      currency_code: order.currency_code,
      idempotency_key: "cash-before-deadline",
      clock: -> { order.payment_expires_at - 1.second }
    )

    expect(result.order).to have_attributes(status: "confirmed")
    expect(result.review_case).to be_nil
    expect(result.preparation_dispatch).to have_attributes(status: "pending")
  end

  it "treats confirmation exactly at the deadline as late success" do
    actor_id = SecureRandom.uuid
    confirmed_at = Time.utc(2026, 11, 14, 10, 0, 0)
    order = create_confirmed_order(actor_id:, confirmed_at:, suffix: "at-deadline")

    result = Payments::ConfirmCash.call(
      order_id: order.id,
      actor_id: actor_id,
      amount: order.total_amount,
      currency_code: order.currency_code,
      idempotency_key: "cash-at-deadline",
      clock: -> { order.payment_expires_at }
    )

    expect(result.order).to have_attributes(status: "expired", expired_at: order.payment_expires_at)
    expect(result.payment).to have_attributes(funding_status: "fully_paid")
    expect(result.review_case).to have_attributes(kind: "late_success", status: "open")
    expect(result.preparation_dispatch).to be_nil
    expect(OutboxEvent.where(event_type: "preparation.dispatch_requested")).to be_empty
  end

  it "treats confirmation after the deadline as late success" do
    actor_id = SecureRandom.uuid
    confirmed_at = Time.utc(2026, 11, 14, 10, 30, 0)
    order = create_confirmed_order(actor_id:, confirmed_at:, suffix: "after-deadline")

    result = Payments::ConfirmBankTransfer.call(
      order_id: order.id,
      actor_id: actor_id,
      amount: order.total_amount,
      currency_code: order.currency_code,
      idempotency_key: "bank-after-deadline",
      clock: -> { order.payment_expires_at + 1.second }
    )

    expect(result.order).to have_attributes(
      status: "expired",
      expired_at: order.payment_expires_at + 1.second
    )
    expect(result.payment).to have_attributes(funding_status: "fully_paid")
    expect(result.review_case).to have_attributes(kind: "late_success", status: "open")
    expect(result.preparation_dispatch).to be_nil
  end

  def create_confirmed_order(actor_id:, confirmed_at:, suffix:)
    order = create_order_draft_record(
      actor_id: actor_id,
      branch_id: SecureRandom.uuid,
      channel: "takeaway",
      total_amount: 80_000,
      currency_code: "VND",
      idempotency_key: "create-#{suffix}",
      now: confirmed_at
    )
    confirm_order_record(
      order_id: order.id,
      actor_id: actor_id,
      idempotency_key: "confirm-#{suffix}",
      expected_version: order.lock_version,
      now: confirmed_at
    )
    order.reload
  end
end
