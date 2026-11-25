module Payments
  module Application
    module Ports
      module AuditLog
        def amount_mismatch(order:, attempt:, actor_id:, now:)
          raise NotImplementedError
        end

        def payment_confirmed(order:, attempt:, dispatch:, review_case:, actor_id:, now:)
          raise NotImplementedError
        end
      end
    end
  end
end
