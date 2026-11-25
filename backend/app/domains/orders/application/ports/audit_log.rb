module Orders
  module Application
    module Ports
      module AuditLog
        def order_created(order:, actor_id:, now:)
          raise NotImplementedError
        end

        def order_confirmed(order:, actor_id:, now:)
          raise NotImplementedError
        end

        def order_held(order:, actor_id:, reason:, now:)
          raise NotImplementedError
        end

        def order_expired(order:, now:)
          raise NotImplementedError
        end
      end
    end
  end
end
