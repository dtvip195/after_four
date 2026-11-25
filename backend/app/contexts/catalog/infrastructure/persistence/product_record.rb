module Catalog
  module Infrastructure
    module Persistence
      class ProductRecord < ApplicationRecord
        self.table_name = "products"

        CODE_PATTERN = /\A[A-Z0-9_-]+\z/
        ASCII_CONTENT_PATTERN = /\A(?=.*[^ \t\n\r\f\v]).*\z/m
        LIFECYCLE_STATUSES = %w[draft active inactive archived].freeze

        belongs_to :category,
          class_name: "Catalog::Infrastructure::Persistence::CategoryRecord",
          foreign_key: :category_id,
          inverse_of: :products
        has_many :product_variants,
          class_name: "Catalog::Infrastructure::Persistence::ProductVariantRecord",
          foreign_key: :product_id,
          inverse_of: :product,
          dependent: :restrict_with_exception

        validates :brand_id, presence: true
        validates :code, length: { maximum: 64 }, format: { with: CODE_PATTERN }
        validates :name, length: { maximum: 200 }, format: { with: ASCII_CONTENT_PATTERN }
        validates :lifecycle_status, inclusion: { in: LIFECYCLE_STATUSES }

        validate :category_has_same_brand

        private

        def category_has_same_brand
          return if category.nil? || category.brand_id == brand_id

          errors.add(:category_id, "must belong to the same Brand")
        end
      end
    end
  end
end
