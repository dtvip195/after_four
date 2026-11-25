module Orders
  module Infrastructure
    module Adapters
      class ActiveRecordAuditLog
        include Application::Ports::AuditLog

        def order_created(order:, actor_id:, now:)
          append(
            order: order,
            actor_type: "user",
            actor_id: actor_id,
            event_type: "order.created",
            idempotency_key: "order.created:#{order.creation_idempotency_key}",
            metadata: { channel: order.channel.to_s },
            now: now
          )
        end

        def order_confirmed(order:, actor_id:, now:)
          append(
            order: order,
            actor_type: "user",
            actor_id: actor_id,
            event_type: "order.confirmed",
            idempotency_key: "order.confirmed:#{order.confirmation_idempotency_key}",
            metadata: { payment_expires_at: order.payment_expires_at.iso8601 },
            now: now
          )
        end

        def order_held(order:, actor_id:, reason:, now:)
          append(
            order: order,
            actor_type: "user",
            actor_id: actor_id,
            event_type: "order.held",
            idempotency_key: "order.held:#{order.hold_idempotency_key}",
            metadata: { reason: reason },
            now: now
          )
        end

        def order_expired(order:, now:)
          append(
            order: order,
            actor_type: "system",
            event_type: "order.payment_window_expired",
            idempotency_key: "order.payment_window_expired:#{order.id}",
            metadata: {},
            now: now
          )
        end

        private

        def append(order:, actor_type:, event_type:, idempotency_key:, metadata:, now:, actor_id: nil)
          AuditEvent.create!(
            branch_id: order.branch_id,
            actor_type: actor_type,
            actor_id: actor_id,
            event_type: event_type,
            subject_type: "Order",
            subject_id: order.id.to_s,
            idempotency_key: idempotency_key,
            metadata: metadata,
            occurred_at: now,
            created_at: now
          )
        end
      end
    end
  end
end
