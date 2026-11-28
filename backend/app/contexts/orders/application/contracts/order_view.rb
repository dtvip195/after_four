module Orders
  module Application
    module Contracts
      OrderView = Data.define(
        :id, :branch_id, :order_number, :channel, :status, :total_amount, :currency_code,
        :lock_version, :created_at, :updated_at
      )
    end
  end
end
