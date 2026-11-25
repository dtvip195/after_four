module Payments
  module Infrastructure
    module Persistence
      class PaymentMapper
        def to_domain(record)
          Domain::Aggregates::Payment.new(
            id: record.id,
            order_id: record.order_id,
            funding_status: record.funding_status,
            attempt_activity: record.attempt_activity,
            target: Domain::ValueObjects::Money.new(
              amount: record.target_amount,
              currency_code: record.currency_code
            ),
            successful_amount: record.successful_amount,
            refunded_amount: record.refunded_amount,
            fully_settled_at: record.fully_settled_at,
            lock_version: record.lock_version,
            attempts: record.payment_attempt_records.order(:created_at, :id).map { |attempt| attempt_to_domain(attempt) },
            created_at: record.created_at,
            updated_at: record.updated_at
          )
        end

        def apply(payment, record)
          record.assign_attributes(
            funding_status: payment.funding_status,
            attempt_activity: payment.attempt_activity,
            target_amount: payment.target_amount,
            successful_amount: payment.successful_amount,
            refunded_amount: payment.refunded_amount,
            currency_code: payment.currency_code,
            fully_settled_at: payment.fully_settled_at,
            updated_at: payment.updated_at
          )
          record
        end

        def attempt_attributes(attempt)
          {
            id: attempt.id.to_s,
            payment_id: attempt.payment_id.to_s,
            method: attempt.method,
            status: attempt.status,
            requested_amount: attempt.requested_amount,
            confirmed_amount: attempt.confirmed_amount,
            currency_code: attempt.currency_code,
            idempotency_key: attempt.idempotency_key,
            confirmed_by_actor_id: attempt.confirmed_by_actor_id,
            confirmed_at: attempt.confirmed_at,
            failure_code: attempt.failure_code,
            created_at: attempt.created_at,
            updated_at: attempt.updated_at
          }
        end

        def apply_attempt(attempt, record)
          record.assign_attributes(attempt_attributes(attempt).except(:id, :payment_id, :created_at))
          record
        end

        private

        def attempt_to_domain(record)
          Domain::Entities::PaymentAttempt.new(
            id: record.id,
            payment_id: record.payment_id,
            method: record.method,
            status: record.status,
            requested_amount: record.requested_amount,
            confirmed_amount: record.confirmed_amount,
            currency_code: record.currency_code,
            idempotency_key: record.idempotency_key,
            confirmed_by_actor_id: record.confirmed_by_actor_id,
            confirmed_at: record.confirmed_at,
            failure_code: record.failure_code,
            created_at: record.created_at,
            updated_at: record.updated_at
          )
        end
      end
    end
  end
end
