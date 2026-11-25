module Preparation
  module Application
    module Ports
      module OrderDispatchGateway
        Snapshot = Data.define(:id, :branch_id)

        def lock(_order_id)
          raise NotImplementedError
        end

        def dispatch_eligible?(_order, at:)
          raise NotImplementedError
        end
      end
    end
  end
end
