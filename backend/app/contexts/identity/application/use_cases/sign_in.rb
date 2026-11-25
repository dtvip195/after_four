module Identity
  module Application
    module UseCases
      class SignIn
        Result = Data.define(:issued_session)

        def initialize(credential_authenticator:, session_store:, clock: -> { Time.now.utc })
          @credential_authenticator = credential_authenticator
          @session_store = session_store
          @clock = clock
        end

        def call(organization_id:, username:, password:)
          identity = credential_authenticator.call(
            organization_id: organization_id,
            username: username,
            password: password
          )
          return Result.new(issued_session: nil) unless identity

          Result.new(issued_session: session_store.issue(identity: identity, now: clock.call))
        end

        private

        attr_reader :credential_authenticator, :session_store, :clock
      end
    end
  end
end
