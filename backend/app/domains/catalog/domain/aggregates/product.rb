module Catalog
  module Domain
    module Aggregates
      class Product
        LIFECYCLE_STATUSES = %w[draft active inactive archived].freeze

        attr_reader :id, :brand_id, :category_id, :code, :name, :description, :lifecycle_status,
          :lock_version, :variants

        def initialize(
          id:,
          brand_id:,
          category_id:,
          code:,
          name:,
          description:,
          lifecycle_status:,
          lock_version:,
          variants:
        )
          unless LIFECYCLE_STATUSES.include?(lifecycle_status)
            raise ArgumentError, "Product lifecycle status is invalid"
          end

          @id = id
          @brand_id = brand_id
          @category_id = category_id
          @code = ValueObjects::CatalogCode.new(code)
          @name = name
          @description = description
          @lifecycle_status = lifecycle_status
          @lock_version = lock_version
          @variants = variants.freeze

          validate_variant_membership!
          validate_default_variant!
        end

        def default_variant
          variants.find(&:default?)
        end

        private

        def validate_variant_membership!
          return if variants.all? { |variant| variant.product_id == id && variant.brand_id == brand_id }

          raise ArgumentError, "Variant must belong to the Product and Brand"
        end

        def validate_default_variant!
          defaults = variants.select(&:default?)
          raise ArgumentError, "Product may have at most one Default Variant" if defaults.length > 1

          return unless lifecycle_status == "active"
          return if defaults.one? && defaults.first.lifecycle_status == "active"

          raise ArgumentError, "Active Product requires one Active Default Variant"
        end
      end
    end
  end
end
