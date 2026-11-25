module Organization
  module Domain
    module Entities
      class Brand
        attr_reader :id, :organization_id, :name, :branches

        def initialize(id:, organization_id:, name:, branches: [])
          @id = id
          @organization_id = organization_id
          @name = name
          @branches = branches
        end
      end
    end
  end
end
