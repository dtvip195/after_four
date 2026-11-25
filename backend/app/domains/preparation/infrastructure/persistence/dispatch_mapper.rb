module Preparation
  module Infrastructure
    module Persistence
      class DispatchMapper
        def to_domain(record)
          Domain::Aggregates::Dispatch.new(
            id: record.id,
            order_id: record.order_id,
            payment_id: record.payment_id,
            branch_id: record.branch_id,
            status: record.status,
            idempotency_key: record.idempotency_key,
            requested_at: record.requested_at,
            dispatched_at: record.dispatched_at,
            lock_version: record.lock_version,
            created_at: record.created_at,
            updated_at: record.updated_at
          )
        end

        def attributes(dispatch)
          {
            id: dispatch.id.to_s,
            order_id: dispatch.order_id,
            payment_id: dispatch.payment_id,
            branch_id: dispatch.branch_id,
            status: dispatch.status,
            idempotency_key: dispatch.idempotency_key,
            requested_at: dispatch.requested_at,
            dispatched_at: dispatch.dispatched_at,
            created_at: dispatch.created_at,
            updated_at: dispatch.updated_at
          }
        end

        def apply(dispatch, record)
          record.assign_attributes(attributes(dispatch).except(:id, :created_at))
          record
        end
      end
    end
  end
end
