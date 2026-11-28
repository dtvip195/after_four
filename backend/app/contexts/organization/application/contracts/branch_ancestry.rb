module Organization
  module Application
    module Contracts
      class BranchAncestry
        attr_reader :branch_id, :brand_id, :organization_id

        def initialize(branch_id:, brand_id:, organization_id:)
          unless branch_id.is_a?(BranchReference) &&
                 brand_id.is_a?(BrandReference) &&
                 organization_id.is_a?(OrganizationReference)
            raise ArgumentError, "ancestry requires typed references"
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
