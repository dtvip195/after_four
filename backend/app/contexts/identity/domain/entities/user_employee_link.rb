module Identity
  module Domain
    module Entities
      class UserEmployeeLink
        UUID_PATTERN = /\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/

        attr_reader :id, :user_id, :employee_id, :organization_id,
          :effective_from, :effective_until

        def initialize(
          id:,
          user_id:,
          employee_id:,
          organization_id:,
          effective_from:,
          effective_until:
        )
          @id = canonical_uuid(id, :id)
          @user_id = canonical_uuid(user_id, :user_id)
          @employee_id = canonical_uuid(employee_id, :employee_id)
          @organization_id = canonical_uuid(organization_id, :organization_id)
          @effective_from = timestamp(effective_from, :effective_from)
          @effective_until = effective_until.nil? ? nil : timestamp(effective_until, :effective_until)

          validate_interval!
          freeze
        end

        def effective_at?(evaluated_at)
          evaluated_at = timestamp(evaluated_at, :evaluated_at)
          effective_from <= evaluated_at && (effective_until.nil? || evaluated_at < effective_until)
        end

        private

        def canonical_uuid(value, name)
          unless value.is_a?(String) && UUID_PATTERN.match?(value)
            raise ArgumentError, "#{name} must be a canonical UUID"
          end

          value.dup.freeze
        end

        def timestamp(value, name)
          raise ArgumentError, "#{name} must be a Time" unless value.instance_of?(Time)

          value.dup.utc.freeze
        end

        def validate_interval!
          return if effective_until.nil? || effective_until > effective_from

          raise ArgumentError, "effective_until must be after effective_from"
        end
      end
    end
  end
end
