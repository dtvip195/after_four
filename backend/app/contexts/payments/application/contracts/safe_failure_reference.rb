module Payments
  module Application
    module Contracts
      class SafeFailureReference
        attr_reader :value

        def initialize(value)
          canonical = value.to_s.downcase
          unless BranchReference::UUID_PATTERN.match?(canonical)
            raise ArgumentError, "Safe failure reference must be a UUID"
          end
          @value = canonical.freeze
          freeze
        end
      end
    end
  end
end
