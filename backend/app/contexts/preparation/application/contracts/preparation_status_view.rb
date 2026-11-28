module Preparation
  module Application
    module Contracts
      PreparationStatusView = Data.define(
        :id, :order_id, :payment_id, :branch_id, :status, :requested_at, :dispatched_at,
        :lock_version, :updated_at
      )
    end
  end
end
