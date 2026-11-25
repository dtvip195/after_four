module Payments
  module Infrastructure
    module Persistence
      class PaymentReviewCaseRecord < ApplicationRecord
        self.table_name = "payment_review_cases"

        belongs_to :payment_record,
          class_name: "Payments::Infrastructure::Persistence::PaymentRecord",
          foreign_key: :payment_id,
          inverse_of: :payment_review_case_records
        belongs_to :payment_attempt_record,
          class_name: "Payments::Infrastructure::Persistence::PaymentAttemptRecord",
          foreign_key: :payment_attempt_id,
          inverse_of: :payment_review_case_record

        validates :kind, inclusion: { in: %w[late_success] }
        validates :order_id, presence: true
        validates :status, inclusion: { in: %w[open resolved] }
        validates :recorded_by_actor_id, :opened_at, presence: true
      end
    end
  end
end
