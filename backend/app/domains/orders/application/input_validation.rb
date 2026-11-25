module Orders
  module Application
    module InputValidation
      UUID_FORMAT = /\A[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}\z/i

      private

      def require_actor!(actor_id)
        return actor_id.to_s.downcase if actor_id.to_s.match?(UUID_FORMAT)

        raise Domain::Errors::RuleViolation.new(
          "trusted_actor_required",
          "A trusted actor context is required"
        )
      end

      def require_branch!(branch_id)
        return branch_id.to_s.downcase if branch_id.to_s.match?(UUID_FORMAT)

        raise Domain::Errors::RuleViolation.new(
          "branch_context_required",
          "A valid Branch context is required"
        )
      end

      def require_idempotency_key!(idempotency_key, reject_whitespace: true)
        value = idempotency_key.to_s
        invalid = reject_whitespace ? value.strip.empty? : value.empty?
        return idempotency_key unless invalid

        raise Domain::Errors::RuleViolation.new(
          "idempotency_key_required",
          "Idempotency key is required"
        )
      end
    end
  end
end
