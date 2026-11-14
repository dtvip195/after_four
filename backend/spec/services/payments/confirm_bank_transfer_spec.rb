require "rails_helper"

RSpec.describe Payments::ConfirmBankTransfer do
  it "records the cashier's explicit manual verification without bank credentials" do
    actor_id = SecureRandom.uuid
    now = Time.utc(2026, 11, 14, 10, 0, 0)
    order = Orders::CreateDraft.call(
      actor_id: actor_id,
      branch_id: SecureRandom.uuid,
      channel: "dine_in",
      total_amount: 150_000,
      currency_code: "VND",
      idempotency_key: "create-bank-spec",
      now: now
    ).order
    Orders::Confirm.call(
      order_id: order.id,
      actor_id: actor_id,
      idempotency_key: "confirm-bank-spec",
      expected_version: order.lock_version,
      now: now
    )

    result = described_class.call(
      order_id: order.id,
      actor_id: actor_id,
      amount: 150_000,
      currency_code: "VND",
      idempotency_key: "bank-confirm-1",
      clock: -> { now + 1.minute }
    )

    expect(result.payment_attempt).to have_attributes(
      method: "bank_transfer",
      status: "succeeded",
      confirmed_by_actor_id: actor_id,
      confirmed_at: now + 1.minute
    )
    expect(result.preparation_dispatch).to be_present
    expect(result.payment_attempt.attributes.keys).not_to include("bank_credentials", "bank_notification")
  end
end
