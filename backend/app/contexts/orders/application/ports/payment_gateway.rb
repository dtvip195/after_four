module Orders
  module Application
    module Ports
      module PaymentGateway
        Snapshot = Data.define(:reference_id, :funding_status) do
          def unpaid?
            funding_status == "unpaid"
          end
        end

        def create_target(order_id:, amount:, currency_code:, now:)
          raise NotImplementedError
        end

        def reference_for_order(order_id:)
          raise NotImplementedError
        end

        def lock_snapshot(order_id:)
          raise NotImplementedError
        end
      end
    end
  end
end
