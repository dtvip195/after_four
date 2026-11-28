module Identity
  module Application
    module Contracts
      class BusinessAuthorization
        AUTHORITY_KINDS = %i[owner branch_manager staff].freeze

        attr_reader :user_id, :session_id, :organization_id, :branch_id, :capability,
          :authority_kind, :role_assignment_id, :employee_id, :evaluated_at,
          :assurance_reference, :correlation_reference

        class << self
          private

          def issue(**attributes)
            new(**attributes)
          end

          private :new
        end

        private

        def initialize(
          user_id:,
          session_id:,
          organization_id:,
          branch_id:,
          capability:,
          authority_kind:,
          role_assignment_id:,
          employee_id:,
          evaluated_at:,
          assurance_reference:,
          correlation_reference:
        )
          raise ArgumentError, "invalid authority kind" unless AUTHORITY_KINDS.include?(authority_kind)

          @user_id = user_id.dup.freeze
          @session_id = session_id.dup.freeze
          @organization_id = organization_id.dup.freeze
          @branch_id = branch_id.dup.freeze
          @capability = capability
          @authority_kind = authority_kind
          @role_assignment_id = role_assignment_id.dup.freeze
          @employee_id = employee_id&.dup&.freeze
          @evaluated_at = evaluated_at.dup.utc.freeze
          @assurance_reference = assurance_reference
          @correlation_reference = correlation_reference
          freeze
        end
      end
    end
  end
end
