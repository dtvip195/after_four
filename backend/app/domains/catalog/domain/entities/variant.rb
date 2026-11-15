module Catalog
  module Domain
    module Entities
      class Variant
        LIFECYCLE_STATUSES = %w[draft active inactive archived].freeze

        attr_reader :id, :brand_id, :product_id, :code, :name, :position, :lifecycle_status,
          :is_default, :customer_visible, :lock_version

        def initialize(
          id:,
          brand_id:,
          product_id:,
          code:,
          name:,
          position:,
          lifecycle_status:,
          is_default:,
          customer_visible:,
          lock_version:
        )
          unless LIFECYCLE_STATUSES.include?(lifecycle_status)
            raise ArgumentError, "Variant lifecycle status is invalid"
          end

          @id = id
          @brand_id = brand_id
          @product_id = product_id
          @code = ValueObjects::CatalogCode.new(code)
          @name = name
          @position = position
          @lifecycle_status = lifecycle_status
          @is_default = is_default
          @customer_visible = customer_visible
          @lock_version = lock_version
        end

        def default?
          @is_default
        end

        def customer_visible?
          @customer_visible
        end
      end
    end
  end
end
