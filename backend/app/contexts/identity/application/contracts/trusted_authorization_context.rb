module Identity
  module Application
    module Contracts
      class TrustedAuthorizationContext
        ISSUANCE_MARKER = Object.new.freeze
        private_constant :ISSUANCE_MARKER

        attr_reader :user_id, :organization_id, :session_id

        def self.trusted?(value)
          value.instance_of?(self) && value.__send__(:issued_with?, ISSUANCE_MARKER)
        end

        def initialize(user_id:, organization_id:, session_id:, issuance_marker:)
          raise ArgumentError, "untrusted authorization context" unless issuance_marker.equal?(ISSUANCE_MARKER)

          @user_id = user_id
          @organization_id = organization_id
          @session_id = session_id
          @issuance_marker = issuance_marker
          freeze
        end

        class << self
          private

          def issue_from_verified_actor(actor)
            return unless actor.instance_of?(AuthenticatedActor)

            new(
              user_id: actor.user_id,
              organization_id: actor.organization_id,
              session_id: actor.session_id,
              issuance_marker: ISSUANCE_MARKER
            )
          end

          private :new
        end

        private

        def issued_with?(marker)
          @issuance_marker.equal?(marker)
        end
      end
    end
  end
end
