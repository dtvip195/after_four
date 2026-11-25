module Identity
  module Application
    module UseCases
      class AuthenticateSession
        def initialize(session_store:, clock: -> { Time.now.utc })
          @session_store = session_store
          @clock = clock
        end

        def call(cookie_value:)
          session_store.authenticate(cookie_value: cookie_value, now: clock.call)
        end

        private

        attr_reader :session_store, :clock
      end
    end
  end
end
