module Payments
  module Domain
    module Aggregates
      class Payment
        ConfirmationOutcome = Data.define(:attempt, :replayed, :amount_mismatch)
        FUNDING_STATUSES = %w[unpaid partially_paid fully_paid partially_refunded fully_refunded].freeze
        ATTEMPT_ACTIVITIES = %w[idle processing reconciliation_required].freeze
        UUID_FORMAT = ValueObjects::PaymentId::UUID_FORMAT

        attr_reader :id, :order_id, :funding_status, :attempt_activity, :target,
          :successful_amount, :refunded_amount, :fully_settled_at, :lock_version,
          :attempts, :created_at, :updated_at

        def initialize(
          id:,
          order_id:,
          funding_status:,
          attempt_activity:,
          target:,
          successful_amount:,
          refunded_amount:,
          lock_version:,
          attempts:,
          created_at:,
          updated_at:,
          fully_settled_at: nil
        )
          @id = id.is_a?(ValueObjects::PaymentId) ? id : ValueObjects::PaymentId.new(id)
          @order_id = canonical_uuid(order_id, "Order identity")
          raise ArgumentError, "Payment funding status is invalid" unless FUNDING_STATUSES.include?(funding_status)
          raise ArgumentError, "Payment attempt activity is invalid" unless ATTEMPT_ACTIVITIES.include?(attempt_activity)
          raise ArgumentError, "Payment target must be Money" unless target.is_a?(ValueObjects::Money)

          @funding_status = funding_status
          @attempt_activity = attempt_activity
          @target = target
          @successful_amount = Integer(successful_amount)
          @refunded_amount = Integer(refunded_amount)
          @fully_settled_at = fully_settled_at
          @lock_version = Integer(lock_version)
          @attempts = attempts.dup
          @created_at = required_value(created_at, "Payment creation timestamp")
          @updated_at = required_value(updated_at, "Payment update timestamp")
          validate_state!
        end

        def target_amount
          target.amount
        end

        def currency_code
          target.currency_code
        end

        def fully_settled?
          funding_status == "fully_paid" &&
            attempt_activity == "idle" &&
            successful_amount == target_amount
        end

        def confirm(attempt_id:, method:, amount:, currency_code:, idempotency_key:, actor_id:, now:)
          validate_confirmation_input!(method, amount, currency_code, idempotency_key, actor_id)
          existing = attempts.find { |attempt| attempt.idempotency_key == idempotency_key }
          return replay(existing, method, amount, currency_code) if existing

          ensure_confirmable!
          if amount == target_amount && currency_code.to_s.upcase == self.currency_code
            attempt = Entities::PaymentAttempt.succeeded(
              id: attempt_id,
              payment_id: id,
              method: method,
              amount: amount,
              currency_code: currency_code,
              idempotency_key: idempotency_key,
              actor_id: actor_id,
              now: now
            )
            @funding_status = "fully_paid"
            @attempt_activity = "idle"
            @successful_amount = amount
            @fully_settled_at = now
            amount_mismatch = false
          else
            attempt = Entities::PaymentAttempt.amount_mismatch(
              id: attempt_id,
              payment_id: id,
              method: method,
              amount: amount,
              currency_code: currency_code,
              idempotency_key: idempotency_key,
              actor_id: actor_id,
              now: now
            )
            amount_mismatch = true
          end
          attempts << attempt
          @updated_at = now
          ConfirmationOutcome.new(attempt: attempt, replayed: false, amount_mismatch: amount_mismatch)
        end

        private

        def validate_confirmation_input!(method, amount, currency_code, idempotency_key, actor_id)
          unless Entities::PaymentAttempt::METHODS.include?(method)
            raise Errors::RuleViolation.new("payment_method_invalid", "Unsupported payment method")
          end
          if idempotency_key.to_s.empty?
            raise Errors::RuleViolation.new("idempotency_key_required", "Idempotency key is required")
          end
          canonical_uuid(actor_id, "Actor identity")
          ValueObjects::Money.new(amount: amount, currency_code: currency_code)
        rescue ArgumentError
          raise Errors::RuleViolation.new(
            "payment_amount_invalid",
            "Confirmed payment amount does not match the exact Order balance",
            details: { expected_amount: target_amount, currency_code: self.currency_code }
          )
        end

        def replay(existing, method, amount, currency_code)
          unless existing.semantic_replay?(method: method, amount: amount, currency_code: currency_code)
            raise Errors::RuleViolation.new(
              "idempotency_conflict",
              "Idempotency key was already used with different input"
            )
          end

          ConfirmationOutcome.new(
            attempt: existing,
            replayed: true,
            amount_mismatch: existing.failure_code == "amount_mismatch"
          )
        end

        def ensure_confirmable!
          if funding_status != "unpaid" || successful_amount != 0
            raise Errors::RuleViolation.new(
              "payment_already_fully_settled",
              "Payment is already settled"
            )
          end
          return if attempt_activity == "idle"

          raise Errors::RuleViolation.new(
            "payment_result_unknown",
            "A payment attempt still requires resolution"
          )
        end

        def validate_state!
          raise ArgumentError, "Payment amounts are invalid" if successful_amount.negative? || refunded_amount.negative?
          raise ArgumentError, "Payment amounts exceed their allowed bounds" if successful_amount > target_amount || refunded_amount > successful_amount
          raise ArgumentError, "Payment lock version must be nonnegative" if lock_version.negative?
          if funding_status == "fully_paid" && successful_amount != target_amount
            raise ArgumentError, "Fully paid Payment must equal its target"
          end
          return unless funding_status == "unpaid" && successful_amount != 0

          raise ArgumentError, "Unpaid Payment cannot contain successful funding"
        end

        def canonical_uuid(value, label)
          canonical = value.to_s.downcase
          raise ArgumentError, "#{label} must be a UUID" unless canonical.match?(UUID_FORMAT)

          canonical
        end

        def required_value(value, label)
          raise ArgumentError, "#{label} is required" if value.nil?

          value
        end
      end
    end
  end
end
