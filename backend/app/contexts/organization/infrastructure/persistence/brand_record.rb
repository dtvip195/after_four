module Organization
  module Infrastructure
    module Persistence
      class BrandRecord < ApplicationRecord
        self.table_name = "brands"

        ASCII_CONTENT_PATTERN = /\A(?=.*[^ \t\n\r\f\v]).*\z/m

        belongs_to :organization,
          class_name: "Organization::Infrastructure::Persistence::OrganizationRecord",
          foreign_key: :organization_id,
          inverse_of: :brands
        has_many :branches,
          class_name: "Organization::Infrastructure::Persistence::BranchRecord",
          foreign_key: :brand_id,
          inverse_of: :brand,
          dependent: :restrict_with_exception

        validates :name, length: { maximum: 200 }, format: { with: ASCII_CONTENT_PATTERN }

        def to_domain
          Domain::Entities::Brand.new(
            id: id,
            organization_id: organization_id,
            name: name,
            branches: branches.map(&:to_domain)
          )
        end
      end
    end
  end
end
