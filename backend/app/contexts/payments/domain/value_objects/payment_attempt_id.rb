module Payments
  module Domain
    module ValueObjects
      class PaymentAttemptId < PaymentId
        def initialize(value)
          super
        rescue ArgumentError
          raise ArgumentError, "Payment Attempt identity must be a UUID"
        end
      end
    end
  end
end
