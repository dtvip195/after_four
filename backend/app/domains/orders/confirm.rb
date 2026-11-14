module Orders
  class Confirm
    Result = Data.define(:order, :replayed)

    def self.call(order_id:, actor_id:, idempotency_key:, expected_version:, now: Time.current)
      TrustedActor.require_id!(actor_id)
      raise DomainError.new("idempotency_key_required", "Idempotency key is required") if idempotency_key.to_s.empty?

      order = nil
      replayed = false

      ApplicationRecord.transaction do
        order = Order.lock.find(order_id)

        if order.confirmation_idempotency_key == idempotency_key
          replayed = true
          next
        end

        unless order.lock_version == expected_version
          raise DomainError.new(
            "concurrent_modification",
            "Order version does not match",
            details: { current_version: order.lock_version }
          )
        end
        unless order.status == "draft"
          raise DomainError.new("invalid_state_transition", "Only a draft Order can be confirmed")
        end

        order.update!(
          status: "confirmed",
          confirmation_idempotency_key: idempotency_key,
          confirmed_at: now,
          payment_expires_at: now + Rails.configuration.x.orders.payment_window_seconds.seconds,
          updated_at: now
        )
        AuditEvent.create!(
          branch_id: order.branch_id,
          actor_type: "user",
          actor_id: actor_id,
          event_type: "order.confirmed",
          subject_type: "Order",
          subject_id: order.id,
          idempotency_key: "order.confirmed:#{idempotency_key}",
          metadata: { payment_expires_at: order.payment_expires_at.iso8601 },
          occurred_at: now,
          created_at: now
        )
      end

      Result.new(order: order, replayed: replayed)
    end
  end
end
