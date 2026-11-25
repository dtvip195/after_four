module Preparation
  module Infrastructure
    module Adapters
      class ActiveRecordSettlementDispatchGateway
        include Application::Ports::SettlementDispatchGateway

        Snapshot = Application::Ports::SettlementDispatchGateway::Snapshot

        def find_by_order_id(order_id)
          record = PreparationDispatch.find_by(order_id: order_id.to_s)
          record && snapshot(record)
        end

        def request_for_settlement(order_id:, payment_id:, branch_id:, now:)
          dispatch = PreparationDispatch.create!(
            order_id: order_id.to_s,
            payment_id: payment_id.to_s,
            branch_id: branch_id,
            status: "pending",
            idempotency_key: "payment-settlement:#{payment_id}",
            requested_at: now,
            created_at: now,
            updated_at: now
          )
          OutboxEvent.create!(
            event_key: "preparation.dispatch_requested:#{dispatch.id}",
            event_type: "preparation.dispatch_requested",
            aggregate_type: "PreparationDispatch",
            aggregate_id: dispatch.id,
            payload: { order_id: order_id.to_s, payment_id: payment_id.to_s, branch_id: branch_id },
            occurred_at: now,
            available_at: now,
            created_at: now,
            updated_at: now
          )
          snapshot(dispatch)
        end

        private

        def snapshot(record)
          Snapshot.new(
            id: record.id,
            order_id: record.order_id,
            payment_id: record.payment_id,
            branch_id: record.branch_id,
            status: record.status
          )
        end
      end
    end
  end
end
