module Preparation
  module Domain
    module ValueObjects
      class DispatchId
        UUID_FORMAT = /\A[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}\z/i

        attr_reader :value

        def initialize(value)
          canonical = value.to_s.downcase
          raise ArgumentError, "Preparation Dispatch ID must be a UUID" unless canonical.match?(UUID_FORMAT)

          @value = canonical.freeze
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
