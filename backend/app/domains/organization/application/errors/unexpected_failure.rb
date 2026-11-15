module Organization
  module Application
    module Errors
      class UnexpectedFailure < StandardError
        MESSAGE = "Organization scope resolution terminated unexpectedly".freeze

        def initialize(_message = MESSAGE)
          super(MESSAGE)
        end
      end
    end
  end
end
