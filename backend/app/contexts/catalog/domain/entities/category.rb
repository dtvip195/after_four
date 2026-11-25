module Catalog
  module Domain
    module Entities
      class Category
        LIFECYCLE_STATUSES = %w[draft active inactive archived].freeze

        attr_reader :id, :brand_id, :code, :name, :position, :lifecycle_status, :lock_version

        def initialize(id:, brand_id:, code:, name:, position:, lifecycle_status:, lock_version:)
          unless LIFECYCLE_STATUSES.include?(lifecycle_status)
            raise ArgumentError, "Category lifecycle status is invalid"
          end

          @id = id
          @brand_id = brand_id
          @code = ValueObjects::CatalogCode.new(code)
          @name = name
          @position = position
          @lifecycle_status = lifecycle_status
          @lock_version = lock_version
        end
      end
    end
  end
end
