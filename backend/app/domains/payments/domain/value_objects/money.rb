module Payments
  module Domain
    module ValueObjects
      class Money
        attr_reader :amount, :currency_code

        def initialize(amount:, currency_code:)
          @amount = Integer(amount)
          @currency_code = currency_code.to_s.upcase
          raise ArgumentError, "Payment amount must be positive" unless @amount.positive?
          raise ArgumentError, "Payment currency must be a three-letter code" unless @currency_code.match?(/\A[A-Z]{3}\z/)
        end

        def ==(other)
          other.is_a?(self.class) && amount == other.amount && currency_code == other.currency_code
        end

        alias eql? ==

        def hash
          [ amount, currency_code ].hash
        end
      end
    end
  end
end
