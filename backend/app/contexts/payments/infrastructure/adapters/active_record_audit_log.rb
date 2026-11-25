module Payments
  module Infrastructure
    module Adapters
      class ActiveRecordAuditLog
        include Application::Ports::AuditLog

        def amount_mismatch(order:, attempt:, actor_id:, now:)
          AuditEvent.create!(
            branch_id: order.branch_id,
            actor_type: "user",
            actor_id: actor_id,
            event_type: "payment.amount_mismatch",
            subject_type: "PaymentAttempt",
            subject_id: attempt.id.to_s,
            idempotency_key: "payment.amount_mismatch:#{order.id}:#{attempt.idempotency_key}",
            metadata: {
              method: attempt.method,
              received_amount: attempt.requested_amount,
              currency_code: attempt.currency_code
            },
            occurred_at: now,
            created_at: now
          )
        end

        def payment_confirmed(order:, attempt:, dispatch:, review_case:, actor_id:, now:)
          AuditEvent.create!(
            branch_id: order.branch_id,
            actor_type: "user",
            actor_id: actor_id,
            event_type: review_case ? "payment.late_success_recorded" : "payment.confirmed",
            subject_type: "PaymentAttempt",
            subject_id: attempt.id.to_s,
            idempotency_key: "payment.confirmed:#{order.id}:#{attempt.idempotency_key}",
            metadata: {
              method: attempt.method,
              amount: attempt.requested_amount,
              currency_code: attempt.currency_code,
              preparation_dispatch_id: dispatch&.id,
              review_case_id: review_case&.id
            }.compact,
            occurred_at: now,
            created_at: now
          )
        end
      end
    end
  end
end
