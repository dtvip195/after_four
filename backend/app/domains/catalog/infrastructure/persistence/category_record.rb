module Catalog
  module Infrastructure
    module Persistence
      class CategoryRecord < ApplicationRecord
        self.table_name = "categories"

        CODE_PATTERN = /\A[A-Z0-9_-]+\z/
        ASCII_CONTENT_PATTERN = /\A(?=.*[^ \t\n\r\f\v]).*\z/m
        LIFECYCLE_STATUSES = %w[draft active inactive archived].freeze

        has_many :products,
          class_name: "Catalog::Infrastructure::Persistence::ProductRecord",
          foreign_key: :category_id,
          inverse_of: :category,
          dependent: :restrict_with_exception

        validates :brand_id, presence: true
        validates :code, length: { maximum: 64 }, format: { with: CODE_PATTERN }
        validates :name, length: { maximum: 150 }, format: { with: ASCII_CONTENT_PATTERN }
        validates :position, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
        validates :lifecycle_status, inclusion: { in: LIFECYCLE_STATUSES }

        def to_domain
          Domain::Entities::Category.new(
            id: id,
            brand_id: brand_id,
            code: code,
            name: name,
            position: position,
            lifecycle_status: lifecycle_status,
            lock_version: lock_version
          )
        end
      end
    end
  end
end
