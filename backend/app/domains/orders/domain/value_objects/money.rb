module Orders
  module Domain
    module ValueObjects
      class Money
        include Comparable

        attr_reader :amount, :currency_code

        def initialize(amount:, currency_code:)
          @amount = Integer(amount)
          @currency_code = currency_code.to_s.upcase.freeze
          raise ArgumentError, "Money amount must be positive" unless @amount.positive?
          raise ArgumentError, "Money currency must be a three-letter code" unless @currency_code.match?(/\A[A-Z]{3}\z/)

          freeze
        end

        def <=>(other)
          raise ArgumentError, "Money currencies must match" unless other.is_a?(self.class) && other.currency_code == currency_code

          amount <=> other.amount
        end

        def ==(other)
          other.instance_of?(self.class) && other.amount == amount && other.currency_code == currency_code
        end
        alias eql? ==

        def hash
          [ self.class, amount, currency_code ].hash
        end
      end
    end
  end
end
