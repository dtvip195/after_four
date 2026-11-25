module Orders
  module Domain
    module ValueObjects
      class OrderNumber
        GENERATED_TOKEN_FORMAT = /\A[0-9A-F]{12}\z/

        attr_reader :value

        def self.generate(token:)
          canonical_token = token.to_s.upcase
          unless canonical_token.match?(GENERATED_TOKEN_FORMAT)
            raise ArgumentError, "Order number token must contain exactly 12 hexadecimal characters"
          end

          new("AF-#{canonical_token}")
        end

        def initialize(value)
          canonical = value.to_s
          raise ArgumentError, "Order number is required" if canonical.strip.empty?

          @value = canonical.freeze
          freeze
        end

        def ==(other)
          other.instance_of?(self.class) && other.value == value
        end
        alias eql? ==

        def hash
          [ self.class, value ].hash
        end

        def to_s
          value
        end
      end
    end
  end
end
