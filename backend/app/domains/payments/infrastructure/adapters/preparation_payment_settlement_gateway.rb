module Payments
  module Infrastructure
    module Adapters
      class PreparationPaymentSettlementGateway
        include Preparation::Application::Ports::PaymentSettlementGateway

        Snapshot = Preparation::Application::Ports::PaymentSettlementGateway::Snapshot

        def lock_snapshot(order_id:)
          payment = Persistence::PaymentRecord.lock.find_by!(order_id: order_id.to_s)
          Snapshot.new(
            reference_id: payment.id,
            funding_status: payment.funding_status,
            attempt_activity: payment.attempt_activity,
            successful_amount: payment.successful_amount,
            target_amount: payment.target_amount
          )
        end
      end
    end
  end
end
