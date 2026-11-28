module Catalog
  module Application
    module Errors
      class UnexpectedFailure < StandardError
        MESSAGE = "Catalog menu resolution terminated unexpectedly".freeze

        def initialize(_message = MESSAGE)
          super(MESSAGE)
        end
      end
    end
  end
end
