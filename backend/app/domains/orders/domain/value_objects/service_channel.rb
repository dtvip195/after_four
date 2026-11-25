module Orders
  module Domain
    module ValueObjects
      class ServiceChannel
        VALUES = %w[dine_in takeaway].freeze

        attr_reader :value

        def initialize(value)
          canonical = value.to_s
          raise ArgumentError, "Service Channel is invalid" unless VALUES.include?(canonical)

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
