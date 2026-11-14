module Orders
  class ExpirePending
    Result = Data.define(:expired_order_ids)

    def self.call(now: Time.current)
      candidate_ids = Order.joins(:payment)
        .where(status: "confirmed", payments: { funding_status: "unpaid" })
        .where(payment_expires_at: ..now)
        .order(:payment_expires_at, :id)
        .pluck(:id)

      expired_ids = candidate_ids.filter_map do |order_id|
        expire_one(order_id, now)
      end

      Result.new(expired_order_ids: expired_ids)
    end

    def self.expire_one(order_id, now)
      expired = false

      ApplicationRecord.transaction do
        order = Order.lock.find(order_id)
        payment = order.payment.lock!
        next unless order.status == "confirmed"
        next unless order.payment_expires_at && order.payment_expires_at <= now
        next unless payment.funding_status == "unpaid"

        order.update!(status: "expired", expired_at: now, updated_at: now)
        AuditEvent.create!(
          branch_id: order.branch_id,
          actor_type: "system",
          event_type: "order.payment_window_expired",
          subject_type: "Order",
          subject_id: order.id,
          idempotency_key: "order.payment_window_expired:#{order.id}",
          metadata: {},
          occurred_at: now,
          created_at: now
        )
        expired = true
      end

      order_id if expired
    end
    private_class_method :expire_one
  end
end
