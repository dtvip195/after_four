module Identity
  module Domain
    module ValueObjects
      class PosCapability
        attr_reader :value

        def self.resolve(value)
          return unless value.instance_of?(String)

          BY_VALUE[value]
        end

        def self.all
          ALL
        end

        def self.registered?(candidate)
          ALL.any? { |capability| capability.equal?(candidate) }
        end

        def self.inherited(_subclass)
          raise TypeError, "#{name} cannot be subclassed"
        end

        def initialize(value)
          @value = value.freeze
          freeze
        end

        def initialize_copy(_source)
          raise TypeError, "#{self.class.name} values cannot be copied"
        end

        CATALOG_MENU_READ = new("pos.catalog.menu.read")
        ORDERS_READ = new("pos.orders.read")
        ORDERS_CREATE = new("pos.orders.create")
        ORDERS_CONFIRM = new("pos.orders.confirm")
        ORDERS_HOLD = new("pos.orders.hold")
        PAYMENTS_READ = new("pos.payments.read")
        PAYMENTS_CASH_CONFIRM = new("pos.payments.cash.confirm")
        PAYMENTS_REVIEW_READ = new("pos.payments.review.read")
        PREPARATION_DISPATCH_READ = new("pos.preparation.dispatch.read")
        PREPARATION_DISPATCH_RECOVER = new("pos.preparation.dispatch.recover")
        PREPARATION_DISPATCH_RETRY = new("pos.preparation.dispatch.retry")

        ALL = [
          CATALOG_MENU_READ,
          ORDERS_READ,
          ORDERS_CREATE,
          ORDERS_CONFIRM,
          ORDERS_HOLD,
          PAYMENTS_READ,
          PAYMENTS_CASH_CONFIRM,
          PAYMENTS_REVIEW_READ,
          PREPARATION_DISPATCH_READ,
          PREPARATION_DISPATCH_RECOVER,
          PREPARATION_DISPATCH_RETRY
        ].freeze

        BY_VALUE = ALL.to_h { |capability| [ capability.value, capability ] }.freeze

        private_class_method :new, :allocate
      end
    end
  end
end
