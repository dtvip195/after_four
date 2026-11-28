module Identity
  module Application
    module Contracts
      class EmployeeBranchScopeEvidence
        attr_reader :employee_id, :organization_id, :branch_id, :assignment_reference

        def initialize(employee_id:, organization_id:, branch_id:, assignment_reference:)
          @employee_id = uuid(employee_id, :employee_id)
          unless organization_id.is_a?(IdentityOrganizationReference)
            raise ArgumentError, "organization_id must be an IdentityOrganizationReference"
          end
          unless branch_id.is_a?(IdentityBranchReference)
            raise ArgumentError, "branch_id must be an IdentityBranchReference"
          end
          unless assignment_reference.is_a?(SafeFailureReference)
            raise ArgumentError, "assignment_reference must be a SafeFailureReference"
          end

          @organization_id = organization_id
          @branch_id = branch_id
          @assignment_reference = assignment_reference
          freeze
        end

        private

        def uuid(value, name)
          unless value.is_a?(String) && IdentityBranchReference::UUID_PATTERN.match?(value)
            raise ArgumentError, "#{name} must be a canonical UUID"
          end

          value.dup.freeze
        end
      end
    end
  end
end
