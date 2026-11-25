module Organization
  module Infrastructure
    module Persistence
      class OrganizationRecord < ApplicationRecord
        self.table_name = "organizations"

        ASCII_CONTENT_PATTERN = /\A(?=.*[^ \t\n\r\f\v]).*\z/m

        has_many :brands,
          class_name: "Organization::Infrastructure::Persistence::BrandRecord",
          foreign_key: :organization_id,
          inverse_of: :organization,
          dependent: :restrict_with_exception

        validates :name, length: { maximum: 200 }, format: { with: ASCII_CONTENT_PATTERN }

        def to_domain
          Domain::Entities::Organization.new(
            id: id,
            name: name,
            brands: brands.map(&:to_domain)
          )
        end
      end
    end
  end
end
