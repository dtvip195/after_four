module Identity
  module Application
    module Contracts
      class UserEmployeeLinkEvidence
        attr_reader :id, :user_id, :employee_id, :organization_id,
          :effective_from, :effective_until

        def initialize(link:)
          unless link.instance_of?(Domain::Entities::UserEmployeeLink)
            raise ArgumentError, "link must be a UserEmployeeLink"
          end

          @id = link.id
          @user_id = link.user_id
          @employee_id = link.employee_id
          @organization_id = link.organization_id
          @effective_from = link.effective_from
          @effective_until = link.effective_until
          freeze
        end

        def effective_at?(evaluated_at)
          effective_from <= evaluated_at && (effective_until.nil? || evaluated_at < effective_until)
        end
      end
    end
  end
end
