class Payment < ApplicationRecord
  FUNDING_STATUSES = %w[unpaid partially_paid fully_paid partially_refunded fully_refunded].freeze
  ATTEMPT_ACTIVITIES = %w[idle processing reconciliation_required].freeze

  belongs_to :order
  has_many :payment_attempts, dependent: :restrict_with_exception
  has_one :preparation_dispatch, dependent: :restrict_with_exception
  has_many :payment_review_cases, dependent: :restrict_with_exception

  validates :funding_status, inclusion: { in: FUNDING_STATUSES }
  validates :attempt_activity, inclusion: { in: ATTEMPT_ACTIVITIES }
  validates :target_amount, numericality: { only_integer: true, greater_than: 0 }
  validates :successful_amount, :refunded_amount,
    numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :currency_code, format: { with: /\A[A-Z]{3}\z/ }
end
