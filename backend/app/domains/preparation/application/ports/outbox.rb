module Preparation
  module Application
    module Ports
      module Outbox
        def dispatch_requested(dispatch)
          raise NotImplementedError
        end

        def requeue_dispatch(dispatch_id:, now:)
          raise NotImplementedError
        end
      end
    end
  end
end
