module Identity
  module Application
    module Errors
      class UnexpectedFailure < StandardError
        MESSAGE = "Identity organization scope resolution terminated unexpectedly".freeze

        def initialize(_message = MESSAGE)
          super(MESSAGE)
        end
      end
    end
  end
end
