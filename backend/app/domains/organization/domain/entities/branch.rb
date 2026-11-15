module Organization
  module Domain
    module Entities
      class Branch
        attr_reader :id, :brand_id, :name, :timezone_name

        def initialize(id:, brand_id:, name:, timezone_name:)
          @id = id
          @brand_id = brand_id
          @name = name
          @timezone_name = timezone_name
        end
      end
    end
  end
end
