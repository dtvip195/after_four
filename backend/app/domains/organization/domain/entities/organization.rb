module Organization
  module Domain
    module Entities
      class Organization
        attr_reader :id, :name, :brands

        def initialize(id:, name:, brands: [])
          @id = id
          @name = name
          @brands = brands
        end
      end
    end
  end
end
