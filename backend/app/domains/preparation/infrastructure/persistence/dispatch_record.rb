module Preparation
  module Infrastructure
    module Persistence
      class DispatchRecord < ApplicationRecord
        self.table_name = "preparation_dispatches"

        has_many :dispatch_attempt_records,
          class_name: "Preparation::Infrastructure::Persistence::DispatchAttemptRecord",
          foreign_key: :preparation_dispatch_id,
          inverse_of: :dispatch_record,
          dependent: :restrict_with_exception

        validates :status, inclusion: { in: Domain::Aggregates::Dispatch::STATUSES }
        validates :order_id, :payment_id, :branch_id, :idempotency_key, :requested_at, presence: true
      end
    end
  end
end
