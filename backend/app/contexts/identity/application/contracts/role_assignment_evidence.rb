module Identity
  module Application
    module Contracts
      class RoleAssignmentEvidence
        attr_reader :id, :user_id, :organization_id, :branch_id, :role_code,
          :effective_from, :effective_until

        def initialize(assignment:)
          unless assignment.instance_of?(Domain::Entities::RoleAssignment)
            raise ArgumentError, "assignment must be a RoleAssignment"
          end

          @id = assignment.id
          @user_id = assignment.user_id
          @organization_id = assignment.organization_id
          @branch_id = assignment.branch_id
          @role_code = assignment.role_code
          @effective_from = assignment.effective_from
          @effective_until = assignment.effective_until
          freeze
        end

        def effective_at?(evaluated_at)
          effective_from <= evaluated_at && (effective_until.nil? || evaluated_at < effective_until)
        end

        def organization_scoped?
          branch_id.nil?
        end

        def branch_scoped?
          !branch_id.nil?
        end
      end
    end
  end
end
