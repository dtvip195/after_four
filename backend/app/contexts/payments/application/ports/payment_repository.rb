module Payments
  module Application
    module Ports
      module PaymentRepository
        class PaymentNotLocked < StandardError; end

        def lock_by_order_id(_order_id)
          raise NotImplementedError
        end

        def save(_payment)
          raise NotImplementedError
        end
      end
    end
  end
end
