module Orders
  module Domain
    module ValueObjects
      class PaymentWindow
        attr_reader :duration_seconds

        def initialize(duration_seconds)
          @duration_seconds = Integer(duration_seconds)
          raise ArgumentError, "Payment Window must be positive" unless @duration_seconds.positive?

          freeze
        end

        def deadline_from(opened_at)
          opened_at + duration_seconds
        end

        def ==(other)
          other.instance_of?(self.class) && other.duration_seconds == duration_seconds
        end
        alias eql? ==

        def hash
          [ self.class, duration_seconds ].hash
        end
      end
    end
  end
end
