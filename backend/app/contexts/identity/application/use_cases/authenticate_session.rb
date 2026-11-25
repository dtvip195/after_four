module Identity
  module Application
    module UseCases
      class AuthenticateSession
        def initialize(session_store:, clock: -> { Time.now.utc })
          @session_store = session_store
          @clock = clock
        end

        def call(cookie_value:)
          actor = session_store.authenticate(cookie_value: cookie_value, now: clock.call)
          return unless actor

          # Construction is deliberately private. Ruby reflection can bypass visibility,
          # so the production trust boundary also depends on this use case receiving only
          # the verified SessionStore result from the composition root.
          Contracts::TrustedAuthorizationContext.__send__(:issue_from_verified_actor, actor)
        end

        private

        attr_reader :session_store, :clock
      end
    end
  end
end
