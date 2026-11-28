module Orders
  module Application
    module Errors
      class UnexpectedFailure < StandardError
        MESSAGE = "Order read failed"
      end
    end
  end
end
