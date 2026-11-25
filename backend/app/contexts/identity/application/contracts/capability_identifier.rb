module Identity
  module Application
    module Contracts
      class CapabilityIdentifier
        SESSION_READ_SELF_VALUE = "identity.session.read_self"

        attr_reader :value

        def self.resolve(value)
          SESSION_READ_SELF if value == SESSION_READ_SELF_VALUE
        end

        def initialize(value)
          @value = value.freeze
          freeze
        end

        SESSION_READ_SELF = new(SESSION_READ_SELF_VALUE)

        private_class_method :new
      end
    end
  end
end
