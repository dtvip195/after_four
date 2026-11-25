module Orders
  module Application
    module Ports
      module AuditLog
        def order_created(**)
          raise NotImplementedError
        end

        def order_confirmed(**)
          raise NotImplementedError
        end

        def order_held(**)
          raise NotImplementedError
        end

        def order_expired(**)
          raise NotImplementedError
        end
      end
    end
  end
end
