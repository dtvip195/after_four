module Catalog
  module Application
    module Contracts
      class BranchReference
        UUID_PATTERN = BrandReference::UUID_PATTERN
        attr_reader :value

        def initialize(value)
          raise ArgumentError, "value must be a canonical UUID" unless value.is_a?(String) && UUID_PATTERN.match?(value)
          @value = value.dup.freeze
          freeze
        end
      end
    end
  end
end
