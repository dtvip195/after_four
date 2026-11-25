module Payments
  module Infrastructure
    module Persistence
      class PaymentAttemptRecord < ApplicationRecord
        self.table_name = "payment_attempts"

        METHODS = Domain::Entities::PaymentAttempt::METHODS
        STATUSES = Domain::Entities::PaymentAttempt::STATUSES
        TERMINAL_STATUSES = Domain::Entities::PaymentAttempt::TERMINAL_STATUSES

        before_update :prevent_terminal_evidence_mutation

        belongs_to :payment_record,
          class_name: "Payments::Infrastructure::Persistence::PaymentRecord",
          foreign_key: :payment_id,
          inverse_of: :payment_attempt_records
        has_one :payment_review_case_record,
          class_name: "Payments::Infrastructure::Persistence::PaymentReviewCaseRecord",
          foreign_key: :payment_attempt_id,
          inverse_of: :payment_attempt_record,
          dependent: :restrict_with_exception

        validates :method, inclusion: { in: METHODS }
        validates :status, inclusion: { in: STATUSES }
        validates :requested_amount, numericality: { only_integer: true, greater_than: 0 }
        validates :currency_code, format: { with: /\A[A-Z]{3}\z/ }
        validates :idempotency_key, presence: true

        private

        def prevent_terminal_evidence_mutation
          return unless TERMINAL_STATUSES.include?(status_in_database)
          fields = %w[
            payment_id status requested_amount confirmed_amount method currency_code
            idempotency_key confirmed_by_actor_id confirmed_at failure_code
          ]
          return unless fields.any? { |field| will_save_change_to_attribute?(field) }

          errors.add(:base, "Terminal payment attempt evidence is immutable")
          throw(:abort)
        end
      end
    end
  end
end
