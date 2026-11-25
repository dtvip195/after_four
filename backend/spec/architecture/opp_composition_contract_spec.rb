require "rails_helper"

RSpec.describe "Ordering, Payment, and Preparation composition contracts" do
  PORT_IMPLEMENTATIONS = {
    Orders::Application::Ports::OrderRepository =>
      Orders::Infrastructure::Persistence::ActiveRecordOrderRepository,
    Orders::Application::Ports::OrderSettlementGateway =>
      Orders::Infrastructure::Adapters::ActiveRecordOrderSettlementGateway,
    Orders::Application::Ports::PaymentGateway =>
      Payments::Infrastructure::Adapters::OrderingPaymentGateway,
    Orders::Application::Ports::AuditLog =>
      Orders::Infrastructure::Adapters::ActiveRecordAuditLog,
    Orders::Application::Ports::UnitOfWork =>
      Orders::Infrastructure::Persistence::ActiveRecordUnitOfWork,
    Payments::Application::Ports::PaymentRepository =>
      Payments::Infrastructure::Persistence::ActiveRecordPaymentRepository,
    Payments::Application::Ports::ReviewCaseGateway =>
      Payments::Infrastructure::Adapters::ActiveRecordReviewCaseGateway,
    Payments::Application::Ports::AuditLog =>
      Payments::Infrastructure::Adapters::ActiveRecordAuditLog,
    Payments::Application::Ports::UnitOfWork =>
      Payments::Infrastructure::Persistence::ActiveRecordUnitOfWork,
    Preparation::Application::Ports::DispatchRepository =>
      Preparation::Infrastructure::Persistence::ActiveRecordDispatchRepository,
    Preparation::Application::Ports::OrderDispatchGateway =>
      Orders::Infrastructure::Adapters::PreparationOrderDispatchGateway,
    Preparation::Application::Ports::PaymentSettlementGateway =>
      Payments::Infrastructure::Adapters::PreparationPaymentSettlementGateway,
    Preparation::Application::Ports::SettlementDispatchGateway =>
      Preparation::Infrastructure::Adapters::ActiveRecordSettlementDispatchGateway,
    Preparation::Application::Ports::Outbox =>
      Preparation::Infrastructure::Adapters::ActiveRecordOutbox,
    Preparation::Application::Ports::AuditLog =>
      Preparation::Infrastructure::Adapters::ActiveRecordAuditLog,
    Preparation::Application::Ports::UnitOfWork =>
      Preparation::Infrastructure::Persistence::ActiveRecordUnitOfWork
  }.freeze

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

  it "keeps every wired adapter interface compatible with its owning Application port" do
    PORT_IMPLEMENTATIONS.each do |port, implementation|
      expect(implementation.ancestors).to include(port)
      port.public_instance_methods(false).each do |operation|
        expect(implementation.public_method_defined?(operation)).to be(true),
          "#{implementation} must publicly implement #{port}##{operation}"
        expect(normalized_parameters(implementation.instance_method(operation))).to eq(
          normalized_parameters(port.instance_method(operation))
        ), "#{implementation}##{operation} must match #{port}##{operation}"
      end
    end
  end

  it "builds all three composition roots without circular initialization or persistence leakage" do
    ordering = OrderingComposition.dependencies
    preparation = PreparationComposition.dependencies

    expect(OrderingComposition::Dependencies.members).to eq(
      %i[order_repository payment_gateway audit_log unit_of_work]
    )
    expect(ordering).to have_attributes(
      order_repository: an_instance_of(Orders::Infrastructure::Persistence::ActiveRecordOrderRepository),
      payment_gateway: an_instance_of(Payments::Infrastructure::Adapters::OrderingPaymentGateway)
    )
    expect(preparation).to have_attributes(
      order_gateway: an_instance_of(Orders::Infrastructure::Adapters::PreparationOrderDispatchGateway),
      payment_gateway: an_instance_of(Payments::Infrastructure::Adapters::PreparationPaymentSettlementGateway),
      dispatch_repository: an_instance_of(Preparation::Infrastructure::Persistence::ActiveRecordDispatchRepository)
    )
    expect(PreparationComposition.settlement_dispatch_gateway)
      .to be_a(Preparation::Infrastructure::Adapters::ActiveRecordSettlementDispatchGateway)
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

  def normalized_parameters(method)
    method.parameters.map do |kind, name|
      %i[req opt rest keyrest block].include?(kind) ? [ kind ] : [ kind, name ]
    end
  end
end
