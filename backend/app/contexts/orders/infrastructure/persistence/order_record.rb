module Orders
  module Infrastructure
    module Persistence
      class OrderRecord < ApplicationRecord
        self.table_name = "orders"

        validates :branch_id, :created_by_actor_id, :order_number, :channel, :status,
          :currency_code, :creation_idempotency_key, :creation_request_fingerprint, presence: true
        validates :channel, inclusion: { in: Domain::ValueObjects::ServiceChannel::VALUES }
        validates :status, inclusion: { in: Domain::Aggregates::Order::STATUSES }
        validates :total_amount, numericality: { only_integer: true, greater_than: 0 }
        validates :currency_code, format: { with: /\A[A-Z]{3}\z/ }
        validates :creation_request_fingerprint, format: { with: /\A[0-9a-f]{64}\z/ }
      end
    end
  end
end
