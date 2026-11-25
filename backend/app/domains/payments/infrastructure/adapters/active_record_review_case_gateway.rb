module Payments
  module Infrastructure
    module Adapters
      class ActiveRecordReviewCaseGateway
        include Application::Ports::ReviewCaseGateway

        Snapshot = Application::Ports::ReviewCaseGateway::Snapshot

        def find_by_attempt_id(payment_attempt_id)
          record = Persistence::PaymentReviewCaseRecord.find_by(payment_attempt_id: payment_attempt_id.to_s)
          record && snapshot(record)
        end

        def open_late_success(order_id:, payment_id:, payment_attempt_id:, actor_id:, now:)
          snapshot(
            Persistence::PaymentReviewCaseRecord.create!(
              order_id: order_id.to_s,
              payment_id: payment_id.to_s,
              payment_attempt_id: payment_attempt_id.to_s,
              kind: "late_success",
              status: "open",
              recorded_by_actor_id: actor_id,
              opened_at: now,
              created_at: now,
              updated_at: now
            )
          )
        end

        private

        def snapshot(record)
          Snapshot.new(
            id: record.id,
            order_id: record.order_id,
            payment_id: record.payment_id,
            payment_attempt_id: record.payment_attempt_id,
            kind: record.kind,
            status: record.status
          )
        end
      end
    end
  end
end
