module Preparation
  module Infrastructure
    module Persistence
      class DispatchAttemptRecord < ApplicationRecord
        self.table_name = "preparation_dispatch_attempts"

        belongs_to :dispatch_record,
          class_name: "Preparation::Infrastructure::Persistence::DispatchRecord",
          foreign_key: :preparation_dispatch_id,
          inverse_of: :dispatch_attempt_records

        validates :attempt_number, numericality: { only_integer: true, greater_than: 0 }
        validates :status, inclusion: { in: %w[started succeeded failed] }
        validates :idempotency_key, :actor_id, :started_at, presence: true
      end
    end
  end
end
