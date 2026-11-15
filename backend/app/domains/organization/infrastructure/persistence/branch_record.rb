module Organization
  module Infrastructure
    module Persistence
      class BranchRecord < ApplicationRecord
        self.table_name = "branches"

        ASCII_CONTENT_PATTERN = /\A(?=.*[^ \t\n\r\f\v]).*\z/m

        belongs_to :brand,
          class_name: "Organization::Infrastructure::Persistence::BrandRecord",
          foreign_key: :brand_id,
          inverse_of: :branches

        validates :name, length: { maximum: 200 }, format: { with: ASCII_CONTENT_PATTERN }
        validates :timezone_name, length: { maximum: 100 }, format: { with: ASCII_CONTENT_PATTERN }

        def to_domain
          Domain::Entities::Branch.new(
            id: id,
            brand_id: brand_id,
            name: name,
            timezone_name: timezone_name
          )
        end
      end
    end
  end
end
