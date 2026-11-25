module Preparation
  module Application
    module Ports
      module PaymentSettlementGateway
        Snapshot = Data.define(
          :reference_id,
          :funding_status,
          :attempt_activity,
          :successful_amount,
          :target_amount
        ) do
          def fully_settled?
            funding_status == "fully_paid" &&
              attempt_activity == "idle" &&
              successful_amount == target_amount
          end
        end

        def lock_snapshot(order_id:)
          raise NotImplementedError
        end
      end
    end
  end
end
