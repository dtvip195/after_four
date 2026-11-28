module Catalog
  module Application
    module Contracts
      class SafeFailureReference
        UUID_PATTERN = BrandReference::UUID_PATTERN
        attr_reader :value

        def initialize(value)
          raise ArgumentError, "value must be a canonical UUID" unless value.is_a?(String) && UUID_PATTERN.match?(value)

          @value = value.dup.freeze
          freeze
        end

        def ==(other) = other.instance_of?(self.class) && other.value == value
        alias eql? ==
        def hash = [ self.class, value ].hash
        def to_s = value
      end
    end
  end
end
