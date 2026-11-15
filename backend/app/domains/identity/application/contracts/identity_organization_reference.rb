module Identity
  module Application
    module Contracts
      class IdentityOrganizationReference
        UUID_PATTERN = /\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/

        attr_reader :value

        def self.valid_value?(value)
          value.is_a?(String) && value.match?(UUID_PATTERN)
        end

        def initialize(value)
          raise ArgumentError, "value must be a canonical UUID" unless self.class.valid_value?(value)

          @value = value.dup.freeze
          freeze
        end

        def ==(other)
          other.instance_of?(self.class) && other.value == value
        end
        alias eql? ==

        def hash
          [ self.class, value ].hash
        end

        def to_s
          value
        end
      end
    end
  end
end
