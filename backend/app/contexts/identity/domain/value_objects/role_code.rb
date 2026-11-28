module Identity
  module Domain
    module ValueObjects
      class RoleCode
        attr_reader :value

        def self.resolve(value)
          return unless value.instance_of?(String)

          BY_VALUE[value]
        end

        def self.all
          ALL
        end

        def self.registered?(candidate)
          ALL.any? { |role| role.equal?(candidate) }
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

        OWNER = new("owner")
        BRANCH_MANAGER = new("branch_manager")
        STAFF = new("staff")

        ALL = [ OWNER, BRANCH_MANAGER, STAFF ].freeze
        BY_VALUE = ALL.to_h { |role| [ role.value, role ] }.freeze

        private_class_method :new, :allocate
      end
    end
  end
end
