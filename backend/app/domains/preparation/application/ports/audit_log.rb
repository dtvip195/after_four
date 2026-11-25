module Preparation
  module Application
    module Ports
      module AuditLog
        def dispatch_requested(dispatch:, actor_id:, command_key:, now:)
          raise NotImplementedError
        end

        def dispatch_retry_recorded?(dispatch:, command_key:)
          raise NotImplementedError
        end

        def dispatch_retry_requested(dispatch:, actor_id:, command_key:, now:)
          raise NotImplementedError
        end
      end
    end
  end
end
