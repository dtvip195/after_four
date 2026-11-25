module Payments
  module Domain
    module ValueObjects
      class PaymentId
        UUID_FORMAT = /\A[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}\z/i

        def initialize(value)
          @value = value.to_s.downcase
          raise ArgumentError, "Payment identity must be a UUID" unless @value.match?(UUID_FORMAT)
        end

        def to_s
          @value
        end

        def ==(other)
          other.is_a?(self.class) && other.to_s == to_s
        end

        alias eql? ==

        def hash
          to_s.hash
        end
      end
    end
  end
end
