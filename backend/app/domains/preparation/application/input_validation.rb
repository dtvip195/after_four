module Preparation
  module Application
    module InputValidation
      UUID_FORMAT = Domain::ValueObjects::DispatchId::UUID_FORMAT

      private

      def require_uuid!(value, label)
        canonical = value.to_s.downcase
        unless canonical.match?(UUID_FORMAT)
          raise DomainError.new("#{label.downcase.tr(' ', '_')}_invalid", "#{label} must be a UUID")
        end

        canonical
      end

      def require_actor!(actor_id)
        TrustedActor.require_id!(actor_id).to_s.downcase
      end

      def require_idempotency_key!(idempotency_key)
        key = idempotency_key.to_s
        raise DomainError.new("idempotency_key_required", "Idempotency key is required") if key.empty?

        key
      end
    end
  end
end
