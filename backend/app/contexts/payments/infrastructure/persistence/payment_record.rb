module Payments
  module Infrastructure
    module Persistence
      class PaymentRecord < ApplicationRecord
        self.table_name = "payments"

        has_many :payment_attempt_records,
          class_name: "Payments::Infrastructure::Persistence::PaymentAttemptRecord",
          foreign_key: :payment_id,
          inverse_of: :payment_record,
          dependent: :restrict_with_exception
        has_many :payment_review_case_records,
          class_name: "Payments::Infrastructure::Persistence::PaymentReviewCaseRecord",
          foreign_key: :payment_id,
          inverse_of: :payment_record,
          dependent: :restrict_with_exception

        validates :funding_status, inclusion: { in: Domain::Aggregates::Payment::FUNDING_STATUSES }
        validates :order_id, presence: true
        validates :attempt_activity, inclusion: { in: Domain::Aggregates::Payment::ATTEMPT_ACTIVITIES }
        validates :target_amount, numericality: { only_integer: true, greater_than: 0 }
        validates :successful_amount, :refunded_amount,
          numericality: { only_integer: true, greater_than_or_equal_to: 0 }
        validates :currency_code, format: { with: /\A[A-Z]{3}\z/ }
      end
    end
  end
end
