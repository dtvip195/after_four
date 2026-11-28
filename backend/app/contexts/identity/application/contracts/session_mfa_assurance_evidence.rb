module Identity
  module Application
    module Contracts
      class SessionMfaAssuranceEvidence
        UUID_PATTERN = IdentityBranchReference::UUID_PATTERN

        attr_reader :session_id, :assurance_reference

        def initialize(session_id:, assurance_reference:)
          unless session_id.is_a?(String) && UUID_PATTERN.match?(session_id)
            raise ArgumentError, "session_id must be a canonical UUID"
          end
          unless assurance_reference.is_a?(SafeFailureReference)
            raise ArgumentError, "assurance_reference must be a SafeFailureReference"
          end

          @session_id = session_id.dup.freeze
          @assurance_reference = assurance_reference
          freeze
        end
      end
    end
  end
end
