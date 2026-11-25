module Orders
  module Infrastructure
    module Persistence
      class OrderMapper
        def to_domain(record)
          Domain::Aggregates::Order.new(
            id: record.id,
            branch_id: record.branch_id,
            created_by_actor_id: record.created_by_actor_id,
            order_number: record.order_number,
            channel: record.channel,
            status: record.status,
            total: Domain::ValueObjects::Money.new(
              amount: record.total_amount,
              currency_code: record.currency_code
            ),
            creation_idempotency_key: record.creation_idempotency_key,
            creation_request_fingerprint: record.creation_request_fingerprint,
            confirmation_idempotency_key: record.confirmation_idempotency_key,
            confirmed_at: record.confirmed_at,
            payment_expires_at: record.payment_expires_at,
            expired_at: record.expired_at,
            held_at: record.held_at,
            hold_reason: record.hold_reason,
            hold_idempotency_key: record.hold_idempotency_key,
            lock_version: record.lock_version,
            created_at: record.created_at,
            updated_at: record.updated_at
          )
        end

        def build_record(order)
          OrderRecord.new(base_attributes(order).merge(id: order.id.to_s))
        end

        def apply(order, record)
          record.assign_attributes(base_attributes(order))
          record
        end

        private

        def base_attributes(order)
          {
            branch_id: order.branch_id,
            created_by_actor_id: order.created_by_actor_id,
            order_number: order.order_number,
            channel: order.channel.to_s,
            status: order.status,
            total_amount: order.total.amount,
            currency_code: order.total.currency_code,
            creation_idempotency_key: order.creation_idempotency_key,
            creation_request_fingerprint: order.creation_request_fingerprint,
            confirmation_idempotency_key: order.confirmation_idempotency_key,
            confirmed_at: order.confirmed_at,
            payment_expires_at: order.payment_expires_at,
            expired_at: order.expired_at,
            held_at: order.held_at,
            hold_reason: order.hold_reason,
            hold_idempotency_key: order.hold_idempotency_key,
            created_at: order.created_at,
            updated_at: order.updated_at
          }
        end
      end
    end
  end
end
