module Payments
  module Domain
    module Entities
      class PaymentAttempt
        METHODS = %w[cash bank_transfer].freeze
        STATUSES = %w[initiated pending unknown succeeded failed cancelled].freeze
        TERMINAL_STATUSES = %w[succeeded failed cancelled].freeze

        attr_reader :id, :payment_id, :method, :status, :requested_amount, :confirmed_amount,
          :currency_code, :idempotency_key, :confirmed_by_actor_id, :confirmed_at,
          :failure_code, :created_at, :updated_at

        def self.succeeded(id:, payment_id:, method:, amount:, currency_code:, idempotency_key:, actor_id:, now:)
          new(
            id: id,
            payment_id: payment_id,
            method: method,
            status: "succeeded",
            requested_amount: amount,
            confirmed_amount: amount,
            currency_code: currency_code,
            idempotency_key: idempotency_key,
            confirmed_by_actor_id: actor_id,
            confirmed_at: now,
            failure_code: nil,
            created_at: now,
            updated_at: now
          )
        end

        def self.amount_mismatch(id:, payment_id:, method:, amount:, currency_code:, idempotency_key:, actor_id:, now:)
          new(
            id: id,
            payment_id: payment_id,
            method: method,
            status: "failed",
            requested_amount: amount,
            confirmed_amount: amount,
            currency_code: currency_code,
            idempotency_key: idempotency_key,
            confirmed_by_actor_id: actor_id,
            confirmed_at: now,
            failure_code: "amount_mismatch",
            created_at: now,
            updated_at: now
          )
        end

        def initialize(
          id:,
          payment_id:,
          method:,
          status:,
          requested_amount:,
          currency_code:,
          idempotency_key:,
          created_at:,
          updated_at:,
          confirmed_amount: nil,
          confirmed_by_actor_id: nil,
          confirmed_at: nil,
          failure_code: nil
        )
          @id = ValueObjects::PaymentAttemptId.new(id)
          @payment_id = payment_id.is_a?(ValueObjects::PaymentId) ? payment_id : ValueObjects::PaymentId.new(payment_id)
          raise ArgumentError, "Payment method is invalid" unless METHODS.include?(method)
          raise ArgumentError, "Payment Attempt status is invalid" unless STATUSES.include?(status)

          money = ValueObjects::Money.new(amount: requested_amount, currency_code: currency_code)
          @method = method
          @status = status
          @requested_amount = money.amount
          @confirmed_amount = confirmed_amount.nil? ? nil : Integer(confirmed_amount)
          @currency_code = money.currency_code
          @idempotency_key = required_text(idempotency_key, "Payment Attempt idempotency key")
          @confirmed_by_actor_id = confirmed_by_actor_id.nil? ? nil : canonical_uuid(confirmed_by_actor_id, "Actor identity")
          @confirmed_at = confirmed_at
          @failure_code = failure_code
          @created_at = required_value(created_at, "Payment Attempt creation timestamp")
          @updated_at = required_value(updated_at, "Payment Attempt update timestamp")
          validate_terminal_evidence!
        end

        def terminal?
          TERMINAL_STATUSES.include?(status)
        end

        def semantic_replay?(method:, amount:, currency_code:)
          self.method == method && requested_amount == amount && self.currency_code == currency_code.to_s.upcase
        end

        def transition_to_terminal(status:, confirmed_amount:, actor_id:, confirmed_at:, failure_code: nil)
          if terminal?
            raise Errors::RuleViolation.new(
              "terminal_payment_attempt_immutable",
              "Terminal Payment Attempt evidence is immutable"
            )
          end

          unless TERMINAL_STATUSES.include?(status)
            raise Errors::RuleViolation.new(
              "payment_attempt_terminal_status_invalid",
              "Payment Attempt terminal status is invalid"
            )
          end

          terminal_confirmed_amount = confirmed_amount.nil? ? nil : Integer(confirmed_amount)
          terminal_updated_at = required_value(confirmed_at, "Payment Attempt update timestamp")
          terminal_actor_id = actor_id.nil? ? nil : canonical_uuid(actor_id, "Actor identity")
          validate_succeeded_evidence!(
            status: status,
            confirmed_amount: terminal_confirmed_amount,
            actor_id: terminal_actor_id,
            confirmed_at: confirmed_at,
            failure_code: failure_code
          )
          @status = status
          @confirmed_amount = terminal_confirmed_amount
          @confirmed_by_actor_id = terminal_actor_id
          @confirmed_at = confirmed_at
          @failure_code = failure_code
          @updated_at = terminal_updated_at
          self
        end

        private

        def validate_terminal_evidence!
          validate_succeeded_evidence!(
            status: status,
            confirmed_amount: confirmed_amount,
            actor_id: confirmed_by_actor_id,
            confirmed_at: confirmed_at,
            failure_code: failure_code
          )
        end

        def validate_succeeded_evidence!(status:, confirmed_amount:, actor_id:, confirmed_at:, failure_code:)
          return unless status == "succeeded"

          complete = actor_id && confirmed_at && confirmed_amount == requested_amount && failure_code.nil?
          raise ArgumentError, "Successful Payment Attempt evidence is incomplete" unless complete
        end

        def required_text(value, label)
          text = value.to_s
          raise ArgumentError, "#{label} is required" if text.empty?

          text
        end

        def canonical_uuid(value, label)
          canonical = value.to_s.downcase
          unless canonical.match?(ValueObjects::PaymentId::UUID_FORMAT)
            raise ArgumentError, "#{label} must be a UUID"
          end

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
