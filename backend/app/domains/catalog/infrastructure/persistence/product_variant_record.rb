module Catalog
  module Infrastructure
    module Persistence
      class ProductVariantRecord < ApplicationRecord
        self.table_name = "product_variants"

        CODE_PATTERN = /\A[A-Z0-9_-]+\z/
        ASCII_CONTENT_PATTERN = /\A(?=.*[^ \t\n\r\f\v]).*\z/m
        LIFECYCLE_STATUSES = %w[draft active inactive archived].freeze

        belongs_to :product,
          class_name: "Catalog::Infrastructure::Persistence::ProductRecord",
          foreign_key: :product_id,
          inverse_of: :product_variants

        validates :brand_id, presence: true
        validates :code, length: { maximum: 64 }, format: { with: CODE_PATTERN }
        validates :name, length: { maximum: 150 }, format: { with: ASCII_CONTENT_PATTERN }
        validates :position, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
        validates :lifecycle_status, inclusion: { in: LIFECYCLE_STATUSES }

        validate :product_has_same_brand

        def to_domain
          Domain::Entities::Variant.new(
            id: id,
            brand_id: brand_id,
            product_id: product_id,
            code: code,
            name: name,
            position: position,
            lifecycle_status: lifecycle_status,
            is_default: is_default,
            customer_visible: customer_visible,
            lock_version: lock_version
          )
        end

        private

        def product_has_same_brand
          return if product.nil? || product.brand_id == brand_id

          errors.add(:product_id, "must belong to the same Brand")
        end
      end
    end
  end
end
