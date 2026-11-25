module Payments
  module Application
    module Ports
      module ReviewCaseGateway
        Snapshot = Data.define(:id, :order_id, :payment_id, :payment_attempt_id, :kind, :status)

        def find_by_attempt_id(_payment_attempt_id)
          raise NotImplementedError
        end

        def open_late_success(order_id:, payment_id:, payment_attempt_id:, actor_id:, now:)
          raise NotImplementedError
        end
      end
    end
  end
end
