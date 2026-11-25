module Identity
  module Application
    module Contracts
      class OrganizationScopeEvidence
        attr_reader :brand_id, :organization_id

        def initialize(brand_id:, organization_id:)
          unless brand_id.is_a?(IdentityBrandReference) && organization_id.is_a?(IdentityOrganizationReference)
            raise ArgumentError, "scope evidence requires Identity-owned references"
          end

          @brand_id = brand_id
          @organization_id = organization_id
          freeze
        end
      end
    end
  end
end
