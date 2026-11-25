module PaymentComposition
  module_function

  def confirm_settlement(
    method:,
    order_id:,
    actor_id:,
    amount:,
    currency_code:,
    idempotency_key:,
    clock: -> { Time.current }
  )
    Payments::Application::UseCases::ConfirmSettlement.new(
      order_gateway: Orders::Infrastructure::Adapters::ActiveRecordOrderSettlementGateway.new,
      payment_repository: Payments::Infrastructure::Persistence::ActiveRecordPaymentRepository.new,
      preparation_gateway: Preparation::Infrastructure::Adapters::ActiveRecordSettlementDispatchGateway.new,
      review_case_gateway: Payments::Infrastructure::Adapters::ActiveRecordReviewCaseGateway.new,
      audit_log: Payments::Infrastructure::Adapters::ActiveRecordAuditLog.new,
      unit_of_work: Payments::Infrastructure::Persistence::ActiveRecordUnitOfWork.new,
      id_generator: -> { SecureRandom.uuid },
      clock: clock
    ).call(
      method: method,
      order_id: order_id,
      actor_id: actor_id,
      amount: amount,
      currency_code: currency_code,
      idempotency_key: idempotency_key
    )
  end

  def confirm_cash(**attributes)
    confirm_settlement(method: "cash", **attributes)
  end

  def confirm_bank_transfer(**attributes)
    confirm_settlement(method: "bank_transfer", **attributes)
  end
end
