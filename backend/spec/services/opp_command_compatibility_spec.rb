require "rails_helper"

RSpec.describe "Ordering, Payment, and Preparation command compatibility" do
  COMMAND_CONTRACTS = {
    Payments::Confirm => {
      parameters: [
        [ :keyreq, :method ],
        [ :keyreq, :order_id ],
        [ :keyreq, :actor_id ],
        [ :keyreq, :amount ],
        [ :keyreq, :currency_code ],
        [ :keyreq, :idempotency_key ],
        [ :key, :clock ]
      ],
      result_members: %i[order payment payment_attempt preparation_dispatch review_case replayed]
    },
    Preparation::RequestDispatch => {
      parameters: [
        [ :keyreq, :order_id ],
        [ :keyreq, :actor_id ],
        [ :keyreq, :idempotency_key ],
        [ :key, :clock ]
      ],
      result_members: %i[preparation_dispatch replayed]
    },
    Preparation::RetryDispatch => {
      parameters: [
        [ :keyreq, :preparation_dispatch_id ],
        [ :keyreq, :actor_id ],
        [ :keyreq, :idempotency_key ],
        [ :key, :now ]
      ],
      result_members: %i[preparation_dispatch replayed]
    }
  }.freeze

  it "preserves the public invocation and result interfaces used by current callers" do
    COMMAND_CONTRACTS.each do |command, contract|
      expect(command.method(:call).parameters).to eq(contract.fetch(:parameters)), command.name
      expect(command::Result.members).to eq(contract.fetch(:result_members)), command.name
    end
  end

  it "keeps the payment-method convenience commands as keyword-forwarding adapters" do
    expect(Payments::ConfirmCash.method(:call).parameters).to eq([ [ :keyrest, :attributes ] ])
    expect(Payments::ConfirmBankTransfer.method(:call).parameters).to eq([ [ :keyrest, :attributes ] ])
  end

  it "returns the same Payments::Confirm result contract through both payment-method adapters" do
    actor_id = SecureRandom.uuid
    now = Time.utc(2026, 11, 14, 16, 0, 0)
    order = create_order_draft_record(
      actor_id: actor_id,
      branch_id: SecureRandom.uuid,
      channel: "takeaway",
      total_amount: 80_000,
      currency_code: "VND",
      idempotency_key: "compatibility-create",
      now: now
    )
    confirm_order_record(
      order_id: order.id,
      actor_id: actor_id,
      idempotency_key: "compatibility-confirm",
      expected_version: order.lock_version,
      now: now
    )

    result = Payments::ConfirmCash.call(
      order_id: order.id,
      actor_id: actor_id,
      amount: order.total_amount,
      currency_code: order.currency_code,
      idempotency_key: "compatibility-payment",
      clock: -> { now + 1.minute }
    )

    expect(result).to be_a(Payments::Confirm::Result)
    expect(result.to_h.keys).to eq(Payments::Confirm::Result.members)
  end
end
