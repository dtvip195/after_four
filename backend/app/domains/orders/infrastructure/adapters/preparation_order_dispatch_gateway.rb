module Orders
  module Infrastructure
    module Adapters
      class PreparationOrderDispatchGateway
        include Preparation::Application::Ports::OrderDispatchGateway

        Snapshot = Preparation::Application::Ports::OrderDispatchGateway::Snapshot

        def initialize(order_repository: Persistence::ActiveRecordOrderRepository.new)
          @order_repository = order_repository
          @locked_orders = {}
        end

        def lock(order_id)
          order = order_repository.lock(order_id)
          locked_orders[order.id.to_s] = order
          Snapshot.new(id: order.id.to_s, branch_id: order.branch_id)
        end

        def dispatch_eligible?(snapshot, at:)
          locked_orders.fetch(snapshot.id).preparation_dispatch_eligible?(at: at)
        end

        private

        attr_reader :order_repository, :locked_orders
      end
    end
  end
end
