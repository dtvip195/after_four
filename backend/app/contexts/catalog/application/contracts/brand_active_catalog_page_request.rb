module Catalog
  module Application
    module Contracts
      class BrandActiveCatalogPageRequest
        MAX_LIMIT = 100
        attr_reader :page, :limit, :category_reference

        def initialize(page:, limit:, category_reference:)
          raise ArgumentError, "page must be a positive integer" unless page.is_a?(Integer) && page.positive?
          unless limit.is_a?(Integer) && limit.between?(1, MAX_LIMIT)
            raise ArgumentError, "limit must be between 1 and #{MAX_LIMIT}"
          end
          unless category_reference.nil? || category_reference.instance_of?(CategoryReference)
            raise ArgumentError, "category_reference must be typed or nil"
          end

          @page = page
          @limit = limit
          @category_reference = category_reference
          freeze
        end

        def offset = (page - 1) * limit
      end
    end
  end
end
