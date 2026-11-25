module Payments
  module Application
    module InputValidation
      UUID_FORMAT = Domain::ValueObjects::PaymentId::UUID_FORMAT

      private

      def validate_command_input!(method:, actor_id:, idempotency_key:)
        unless Domain::Entities::PaymentAttempt::METHODS.include?(method)
          raise Domain::Errors::RuleViolation.new("payment_method_invalid", "Unsupported payment method")
        end
        unless actor_id.to_s.match?(UUID_FORMAT)
          raise Domain::Errors::RuleViolation.new(
            "trusted_actor_required",
            "A trusted actor context is required"
          )
        end
        return unless idempotency_key.to_s.empty?

        raise Domain::Errors::RuleViolation.new(
          "idempotency_key_required",
          "Idempotency key is required"
        )
      end
    end
  end
end
