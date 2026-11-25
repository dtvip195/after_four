module Preparation
  module Application
    module Ports
      module SettlementDispatchGateway
        Snapshot = Data.define(:id, :order_id, :payment_id, :branch_id, :status)

        def find_by_order_id(_order_id)
          raise NotImplementedError
        end

        def request_for_settlement(order_id:, payment_id:, branch_id:, now:)
          raise NotImplementedError
        end
      end
    end
  end
end
