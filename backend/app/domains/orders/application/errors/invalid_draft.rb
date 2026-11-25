module Orders
  module Application
    module Errors
      class InvalidDraft < StandardError
        attr_reader :attributes

        def initialize(attributes:, message: "Draft Order attributes are invalid")
          @attributes = attributes.freeze
          super(message)
        end
      end
    end
  end
end
