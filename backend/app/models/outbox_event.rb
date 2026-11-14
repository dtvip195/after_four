class OutboxEvent < ApplicationRecord
  validates :event_key, :event_type, :aggregate_type, :aggregate_id,
    :occurred_at, :available_at, presence: true
  validates :status, inclusion: { in: %w[pending published] }
end
