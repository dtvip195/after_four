module Orders
  module Infrastructure
    module Adapters
      class ActiveRecordOrderSettlementGateway
        include Application::Ports::OrderSettlementGateway

        def initialize(order_repository: Persistence::ActiveRecordOrderRepository.new)
          @order_repository = order_repository
        end

        def lock(order_id)
          order_repository.lock(order_id)
        end

        def save(order)
          order_repository.save(order)
        end

        private

        attr_reader :order_repository
      end
    end
  end
end
