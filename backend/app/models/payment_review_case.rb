class PaymentReviewCase < ApplicationRecord
  belongs_to :payment
  belongs_to :payment_attempt

  validates :kind, inclusion: { in: %w[late_success] }
  validates :order_id, presence: true
  validates :status, inclusion: { in: %w[open resolved] }
  validates :recorded_by_actor_id, :opened_at, presence: true
end
