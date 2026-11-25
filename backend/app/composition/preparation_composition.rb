module PreparationComposition
  module_function

  def request_dispatch(order_id:, actor_id:, idempotency_key:, clock: -> { Time.current })
    Preparation::RequestDispatch.new(
      order_gateway: Orders::Infrastructure::Adapters::ActiveRecordOrderSettlementGateway.new,
      payment_gateway: Payments::Infrastructure::Adapters::PreparationPaymentSettlementGateway.new,
      order_id: order_id,
      actor_id: actor_id,
      idempotency_key: idempotency_key,
      clock: clock
    ).call
  end
end
