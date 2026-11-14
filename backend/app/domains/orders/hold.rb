module Orders
  class Hold
    Result = Data.define(:order, :replayed)

    def self.call(order_id:, actor_id:, reason:, idempotency_key:, expected_version:, now: Time.current)
      TrustedActor.require_id!(actor_id)
      raise DomainError.new("reason_required", "A hold reason is required") if reason.to_s.strip.empty?
      raise DomainError.new("idempotency_key_required", "Idempotency key is required") if idempotency_key.to_s.empty?

      order = nil
      replayed = false
      ApplicationRecord.transaction do
        order = Order.lock.find(order_id)
        payment = order.payment.lock!
        if order.hold_idempotency_key == idempotency_key
          replayed = true
          next
        end
        unless order.lock_version == expected_version
          raise DomainError.new("concurrent_modification", "Order version does not match")
        end
        unless order.status == "confirmed" && payment.funding_status == "unpaid"
          raise DomainError.new("invalid_state_transition", "Only a confirmed unpaid Order can be held")
        end

        order.update!(
          status: "held",
          held_at: now,
          hold_reason: reason,
          hold_idempotency_key: idempotency_key,
          updated_at: now
        )
        AuditEvent.create!(
          branch_id: order.branch_id,
          actor_type: "user",
          actor_id: actor_id,
          event_type: "order.held",
          subject_type: "Order",
          subject_id: order.id,
          idempotency_key: "order.held:#{idempotency_key}",
          metadata: { reason: reason },
          occurred_at: now,
          created_at: now
        )
      end

      Result.new(order: order, replayed: replayed)
    end
  end
end
