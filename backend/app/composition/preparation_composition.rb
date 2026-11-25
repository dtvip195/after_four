module PreparationComposition
  Dependencies = Data.define(
    :order_gateway,
    :payment_gateway,
    :dispatch_repository,
    :outbox,
    :audit_log,
    :unit_of_work
  )

  module_function

  def dependencies
    Dependencies.new(
      order_gateway: Orders::Infrastructure::Adapters::PreparationOrderDispatchGateway.new,
      payment_gateway: Payments::Infrastructure::Adapters::PreparationPaymentSettlementGateway.new,
      dispatch_repository: Preparation::Infrastructure::Persistence::ActiveRecordDispatchRepository.new,
      outbox: Preparation::Infrastructure::Adapters::ActiveRecordOutbox.new,
      audit_log: Preparation::Infrastructure::Adapters::ActiveRecordAuditLog.new,
      unit_of_work: Preparation::Infrastructure::Persistence::ActiveRecordUnitOfWork.new
    )
  end

  def request_dispatch_use_case(clock: -> { Time.current })
    current = dependencies
    Preparation::Application::UseCases::RequestDispatch.new(
      order_gateway: current.order_gateway,
      payment_gateway: current.payment_gateway,
      dispatch_repository: current.dispatch_repository,
      outbox: current.outbox,
      audit_log: current.audit_log,
      unit_of_work: current.unit_of_work,
      id_generator: -> { SecureRandom.uuid },
      clock: clock
    )
  end

  def retry_dispatch_use_case
    current = dependencies
    Preparation::Application::UseCases::RetryDispatch.new(
      dispatch_repository: current.dispatch_repository,
      outbox: current.outbox,
      audit_log: current.audit_log,
      unit_of_work: current.unit_of_work
    )
  end

  def request_dispatch(order_id:, actor_id:, idempotency_key:, clock: -> { Time.current })
    request_dispatch_use_case(clock: clock).call(
      order_id: order_id,
      actor_id: actor_id,
      idempotency_key: idempotency_key
    )
  end

  def retry_dispatch(preparation_dispatch_id:, actor_id:, idempotency_key:, now: Time.current)
    retry_dispatch_use_case.call(
      preparation_dispatch_id: preparation_dispatch_id,
      actor_id: actor_id,
      idempotency_key: idempotency_key,
      now: now
    )
  end

  def settlement_dispatch_gateway
    Preparation::Infrastructure::Adapters::ActiveRecordSettlementDispatchGateway.new
  end
end
