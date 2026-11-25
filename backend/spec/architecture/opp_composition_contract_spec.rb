require "rails_helper"

RSpec.describe "Ordering, Payment, and Preparation composition contracts" do
  COMMAND_CONTRACTS = {
    PreparationComposition.method(:request_dispatch) => {
      parameters: [
        [ :keyreq, :order_id ],
        [ :keyreq, :actor_id ],
        [ :keyreq, :idempotency_key ],
        [ :key, :clock ]
      ],
      result_members: %i[preparation_dispatch replayed]
    },
    PreparationComposition.method(:retry_dispatch) => {
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
      expect(command.parameters).to eq(contract.fetch(:parameters)), command.name.to_s
      result_class = if command.name == :request_dispatch
        Preparation::Application::UseCases::RequestDispatch::Result
      else
        Preparation::Application::UseCases::RetryDispatch::Result
      end
      expect(result_class.members).to eq(contract.fetch(:result_members)), command.name.to_s
    end
  end

  it "returns the canonical Payment Application result through the composition root" do
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

    result = PaymentComposition.confirm_cash(
      order_id: order.id,
      actor_id: actor_id,
      amount: order.total_amount,
      currency_code: order.currency_code,
      idempotency_key: "compatibility-payment",
      clock: -> { now + 1.minute }
    )

    expect(result).to be_a(Payments::Application::UseCases::ConfirmSettlement::Result)
    expect(result.to_h.keys).to eq(Payments::Application::UseCases::ConfirmSettlement::Result.members)
  end
end
