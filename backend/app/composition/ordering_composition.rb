module OrderingComposition
  Dependencies = Data.define(
    :order_repository,
    :order_settlement_gateway,
    :payment_gateway,
    :audit_log,
    :unit_of_work
  )

  module_function

  def dependencies
    Dependencies.new(
      order_repository: Orders::Infrastructure::Persistence::ActiveRecordOrderRepository.new,
      order_settlement_gateway: Orders::Infrastructure::Adapters::ActiveRecordOrderSettlementGateway.new,
      payment_gateway: Payments::Infrastructure::Adapters::OrderingPaymentGateway.new,
      audit_log: Orders::Infrastructure::Adapters::ActiveRecordAuditLog.new,
      unit_of_work: Orders::Infrastructure::Persistence::ActiveRecordUnitOfWork.new
    )
  end

  def create_draft_use_case
    current = dependencies
    Orders::Application::UseCases::CreateDraft.new(
      order_repository: current.order_repository,
      payment_gateway: current.payment_gateway,
      audit_log: current.audit_log,
      unit_of_work: current.unit_of_work,
      id_generator: -> { SecureRandom.uuid },
      order_number_token_generator: -> { SecureRandom.hex(6) }
    )
  end

  def confirm_use_case(clock: -> { Time.current })
    current = dependencies
    Orders::Application::UseCases::Confirm.new(
      order_repository: current.order_repository,
      audit_log: current.audit_log,
      unit_of_work: current.unit_of_work,
      payment_window: Orders::Domain::ValueObjects::PaymentWindow.new(
        Rails.configuration.x.orders.payment_window_seconds
      ),
      clock: clock
    )
  end

  def hold_use_case
    current = dependencies
    Orders::Application::UseCases::Hold.new(
      order_repository: current.order_repository,
      payment_gateway: current.payment_gateway,
      audit_log: current.audit_log,
      unit_of_work: current.unit_of_work
    )
  end

  def expire_pending_use_case
    current = dependencies
    Orders::Application::UseCases::ExpirePending.new(
      order_repository: current.order_repository,
      payment_gateway: current.payment_gateway,
      audit_log: current.audit_log,
      unit_of_work: current.unit_of_work
    )
  end

  def confirm_payment(method:, order_id:, actor_id:, amount:, currency_code:, idempotency_key:, clock:)
    Payments::Confirm.new(
      order_gateway: dependencies.order_settlement_gateway,
      method: method,
      order_id: order_id,
      actor_id: actor_id,
      amount: amount,
      currency_code: currency_code,
      idempotency_key: idempotency_key,
      clock: clock
    ).call
  end

  def request_preparation_dispatch(order_id:, actor_id:, idempotency_key:, clock:)
    Preparation::RequestDispatch.new(
      order_gateway: dependencies.order_settlement_gateway,
      order_id: order_id,
      actor_id: actor_id,
      idempotency_key: idempotency_key,
      clock: clock
    ).call
  end
end
