module Payments
  module Application
    module Contracts
      PaymentStatusView = Data.define(
        :id, :order_id, :funding_status, :attempt_activity, :target_amount,
        :successful_amount, :refunded_amount, :currency_code, :fully_settled_at,
        :lock_version, :updated_at
      )
    end
  end
end
