class PreparationDispatch < ApplicationRecord
  belongs_to :payment
  has_many :preparation_dispatch_attempts, dependent: :restrict_with_exception

  validates :status, inclusion: { in: %w[pending dispatched] }
  validates :order_id, :branch_id, :idempotency_key, :requested_at, presence: true
end
