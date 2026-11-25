module Preparation
  module Application
    module Ports
      module PaymentSettlementGateway
        Snapshot = Data.define(:reference_id)

        def lock_snapshot(order_id:)
          raise NotImplementedError
        end

        def fully_settled?(_snapshot)
          raise NotImplementedError
        end
      end
    end
  end
end
