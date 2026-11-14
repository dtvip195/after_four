class PreparationDispatchAttempt < ApplicationRecord
  belongs_to :preparation_dispatch

  validates :attempt_number, numericality: { only_integer: true, greater_than: 0 }
  validates :status, inclusion: { in: %w[started succeeded failed] }
  validates :idempotency_key, :actor_id, :started_at, presence: true
end
