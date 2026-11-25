module Identity
  module Application
    module Ports
      module SessionStore
        def issue(identity:, now:)
          raise NotImplementedError
        end

        def authenticate(cookie_value:, now:)
          raise NotImplementedError
        end

        def verify_csrf(actor:, token:)
          raise NotImplementedError
        end

        def revoke(cookie_value:, now:, reason:)
          raise NotImplementedError
        end
      end
    end
  end
end
