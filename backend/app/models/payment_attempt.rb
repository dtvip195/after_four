class PaymentAttempt < ApplicationRecord
  METHODS = %w[cash bank_transfer].freeze
  STATUSES = %w[initiated pending unknown succeeded failed cancelled].freeze
  TERMINAL_STATUSES = %w[succeeded failed cancelled].freeze
  TERMINAL_EVIDENCE_FIELDS = %w[
    payment_id status requested_amount confirmed_amount method currency_code
    idempotency_key confirmed_by_actor_id confirmed_at failure_code
  ].freeze

  before_update :prevent_terminal_evidence_mutation

  belongs_to :payment
  has_one :payment_review_case, dependent: :restrict_with_exception

  validates :method, inclusion: { in: METHODS }
  validates :status, inclusion: { in: STATUSES }
  validates :requested_amount, numericality: { only_integer: true, greater_than: 0 }
  validates :currency_code, format: { with: /\A[A-Z]{3}\z/ }
  validates :idempotency_key, presence: true

  private

  def prevent_terminal_evidence_mutation
    return unless TERMINAL_STATUSES.include?(status_in_database)
    return unless TERMINAL_EVIDENCE_FIELDS.any? { |field| will_save_change_to_attribute?(field) }

    errors.add(:base, "Terminal payment attempt evidence is immutable")
    throw(:abort)
  end
end
