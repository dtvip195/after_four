module Orders
  module Application
    module Ports
      module OrderSettlementGateway
        def lock(_order_id)
          raise NotImplementedError
        end

        def save(_order)
          raise NotImplementedError
        end
      end
    end
  end
end
