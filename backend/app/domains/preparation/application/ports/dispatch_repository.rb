module Preparation
  module Application
    module Ports
      module DispatchRepository
        class DispatchNotLocked < StandardError; end

        def find_by_order_id(_order_id)
          raise NotImplementedError
        end

        def lock(_dispatch_id)
          raise NotImplementedError
        end

        def add(_dispatch)
          raise NotImplementedError
        end

        def save(_dispatch)
          raise NotImplementedError
        end
      end
    end
  end
end
