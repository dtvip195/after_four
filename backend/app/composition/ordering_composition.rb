module OrderingComposition
  Dependencies = Data.define(
    :order_repository,
    :payment_gateway,
    :audit_log,
    :unit_of_work
  )

  module_function

  def dependencies
    Dependencies.new(
      order_repository: Orders::Infrastructure::Persistence::ActiveRecordOrderRepository.new,
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
end
