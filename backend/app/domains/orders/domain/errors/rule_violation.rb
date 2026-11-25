module Orders
  module Domain
    module Errors
      class RuleViolation < StandardError
        attr_reader :code, :details

        def initialize(code, message, details: {})
          @code = code
          @details = details.freeze
          super(message)
        end
      end
    end
  end
end
