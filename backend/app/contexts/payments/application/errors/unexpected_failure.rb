module Payments
  module Application
    module Errors
      class UnexpectedFailure < StandardError
        MESSAGE = "Payment status read failed"
      end
    end
  end
end
