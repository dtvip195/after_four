class Order < ApplicationRecord
  CHANNELS = %w[dine_in takeaway].freeze
  STATUSES = %w[draft confirmed held expired cancelled closed].freeze

  has_one :payment, dependent: :restrict_with_exception
  has_one :preparation_dispatch, dependent: :restrict_with_exception
  has_many :payment_review_cases, dependent: :restrict_with_exception

  validates :branch_id, :created_by_actor_id, :order_number, :channel, :status,
    :currency_code, :creation_idempotency_key, :creation_request_fingerprint, presence: true
  validates :channel, inclusion: { in: CHANNELS }
  validates :status, inclusion: { in: STATUSES }
  validates :total_amount, numericality: { only_integer: true, greater_than: 0 }
  validates :currency_code, format: { with: /\A[A-Z]{3}\z/ }
  validates :creation_request_fingerprint, format: { with: /\A[0-9a-f]{64}\z/ }
end
