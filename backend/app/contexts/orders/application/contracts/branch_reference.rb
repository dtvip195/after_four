module Orders
  module Application
    module Contracts
      class BranchReference
        UUID_PATTERN = /\A[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}\z/i
        attr_reader :value

        def initialize(value)
          canonical = value.to_s.downcase
          raise ArgumentError, "Branch reference must be a UUID" unless UUID_PATTERN.match?(canonical)

          @value = canonical.freeze
          freeze
        end

        def ==(other) = other.instance_of?(self.class) && other.value == value
        alias eql? ==
        def hash = [ self.class, value ].hash
      end
    end
  end
end
