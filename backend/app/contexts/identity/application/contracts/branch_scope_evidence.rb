module Identity
  module Application
    module Contracts
      class BranchScopeEvidence
        attr_reader :branch_id, :brand_id, :organization_id

        def initialize(branch_id:, brand_id:, organization_id:)
          unless branch_id.is_a?(IdentityBranchReference) &&
                 brand_id.is_a?(IdentityBrandReference) &&
                 organization_id.is_a?(IdentityOrganizationReference)
            raise ArgumentError, "scope evidence requires Identity-owned references"
          end

          @branch_id = branch_id
          @brand_id = brand_id
          @organization_id = organization_id
          freeze
        end
      end
    end
  end
end
