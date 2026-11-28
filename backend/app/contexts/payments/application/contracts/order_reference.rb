module Payments
  module Application
    module Contracts
      class OrderReference
        attr_reader :value

        def initialize(value)
          canonical = value.to_s.downcase
          raise ArgumentError, "Order reference must be a UUID" unless BranchReference::UUID_PATTERN.match?(canonical)
          @value = canonical.freeze
          freeze
        end
      end
    end
  end
end
