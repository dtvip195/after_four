module Preparation
  module Application
    module Errors
      class UnexpectedFailure < StandardError
        MESSAGE = "Preparation status read failed"
      end
    end
  end
end
