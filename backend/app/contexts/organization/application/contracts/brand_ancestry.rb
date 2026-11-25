module Organization
  module Application
    module Contracts
      class BrandAncestry
        attr_reader :brand_id, :organization_id

        def initialize(brand_id:, organization_id:)
          unless brand_id.is_a?(BrandReference) && organization_id.is_a?(OrganizationReference)
            raise ArgumentError, "ancestry requires typed references"
          end

          @brand_id = brand_id
          @organization_id = organization_id
          freeze
        end
      end
    end
  end
end
