module Workforce
  module Domain
    module ValueObjects
      class EmployeeId
        UUID_PATTERN = /\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/

        attr_reader :value

        def initialize(value)
          unless value.is_a?(String) && value.match?(UUID_PATTERN)
            raise ArgumentError, "Employee ID must be a canonical UUID"
          end

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
