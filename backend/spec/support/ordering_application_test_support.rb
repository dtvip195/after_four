module OrderingApplicationTestSupport
  def create_order_draft_record(**attributes)
    result = OrderingComposition.create_draft_use_case.call(**attributes)
    order_record(result.order.id)
  end

  def confirm_order_record(now:, **attributes)
    result = OrderingComposition.confirm_use_case(clock: -> { now }).call(**attributes)
    order_record(result.order.id)
  end

  def hold_order_record(**attributes)
    result = OrderingComposition.hold_use_case.call(**attributes)
    order_record(result.order.id)
  end

  def expire_pending_orders(now:)
    OrderingComposition.expire_pending_use_case.call(now: now)
  end

  def order_record(order_id)
    Orders::Infrastructure::Persistence::OrderRecord.find(order_id.to_s)
  end

  def payment_for(order)
    Payments::Infrastructure::Persistence::PaymentRecord.find_by!(order_id: order.id)
  end

  def preparation_dispatch_for(order)
    Preparation::Infrastructure::Persistence::DispatchRecord.find_by(order_id: order.id)
  end
end
