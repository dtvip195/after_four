module Preparation
  module Infrastructure
    module Adapters
      class ActiveRecordOutbox
        include Application::Ports::Outbox

        def dispatch_requested(dispatch)
          OutboxEvent.create!(
            event_key: event_key(dispatch.id),
            event_type: "preparation.dispatch_requested",
            aggregate_type: "PreparationDispatch",
            aggregate_id: dispatch.id.to_s,
            payload: {
              order_id: dispatch.order_id,
              payment_id: dispatch.payment_id,
              branch_id: dispatch.branch_id
            },
            occurred_at: dispatch.requested_at,
            available_at: dispatch.requested_at,
            created_at: dispatch.requested_at,
            updated_at: dispatch.requested_at
          )
        end

        def requeue_dispatch(dispatch_id:, now:)
          event = OutboxEvent.lock.find_by!(event_key: event_key(dispatch_id))
          event.update!(status: "pending", available_at: now, published_at: nil, updated_at: now)
        end

        private

        def event_key(dispatch_id)
          "preparation.dispatch_requested:#{dispatch_id}"
        end
      end
    end
  end
end
