module Identity
  module Domain
    module Policies
      class PosCapabilityPolicy
        class Outcome
          attr_reader :value

          def initialize(value)
            @value = value.freeze
            freeze
          end

          private_class_method :new
        end

        ALLOW_IN_POLICY = Outcome.__send__(:new, "ALLOW_IN_POLICY")
        DENY = Outcome.__send__(:new, "DENY")
        NOT_IMPLEMENTED = Outcome.__send__(:new, "NOT_IMPLEMENTED")

        ORGANIZATION_SCOPE = :organization
        EXACT_BRANCH_SCOPE = :exact_branch

        STAFF_CAPABILITIES = [
          ValueObjects::PosCapability::CATALOG_MENU_READ,
          ValueObjects::PosCapability::ORDERS_READ,
          ValueObjects::PosCapability::ORDERS_CREATE,
          ValueObjects::PosCapability::ORDERS_CONFIRM,
          ValueObjects::PosCapability::ORDERS_HOLD,
          ValueObjects::PosCapability::PAYMENTS_READ,
          ValueObjects::PosCapability::PAYMENTS_CASH_CONFIRM,
          ValueObjects::PosCapability::PREPARATION_DISPATCH_READ
        ].freeze

        def evaluate(
          capability:,
          role:,
          scope:,
          session_mfa_satisfied:,
          action_level_step_up_required:
        )
          return DENY unless ValueObjects::PosCapability.registered?(capability)
          return DENY unless ValueObjects::RoleCode.registered?(role)
          return DENY unless valid_scope?(scope)
          return DENY unless boolean?(session_mfa_satisfied)
          return DENY unless boolean?(action_level_step_up_required)
          return NOT_IMPLEMENTED if action_level_step_up_required

          if ValueObjects::RoleCode::OWNER.equal?(role) && ORGANIZATION_SCOPE.equal?(scope)
            ALLOW_IN_POLICY
          elsif ValueObjects::RoleCode::BRANCH_MANAGER.equal?(role) &&
              EXACT_BRANCH_SCOPE.equal?(scope) && session_mfa_satisfied
            ALLOW_IN_POLICY
          elsif ValueObjects::RoleCode::STAFF.equal?(role) &&
              EXACT_BRANCH_SCOPE.equal?(scope) && staff_capability?(capability)
            ALLOW_IN_POLICY
          else
            DENY
          end
        end

        def activation_outcome(capability:)
          return DENY unless ValueObjects::PosCapability.registered?(capability)

          NOT_IMPLEMENTED
        end

        private

        def valid_scope?(scope)
          ORGANIZATION_SCOPE.equal?(scope) || EXACT_BRANCH_SCOPE.equal?(scope)
        end

        def boolean?(value)
          true.equal?(value) || false.equal?(value)
        end

        def staff_capability?(candidate)
          STAFF_CAPABILITIES.any? { |capability| capability.equal?(candidate) }
        end
      end
    end
  end
end
