class PreparationDispatch < ApplicationRecord
  belongs_to :order
  belongs_to :payment
  has_many :preparation_dispatch_attempts, dependent: :restrict_with_exception

  validates :status, inclusion: { in: %w[pending dispatched] }
  validates :branch_id, :idempotency_key, :requested_at, presence: true
end
