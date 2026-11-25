module Payments
  module Infrastructure
    module Adapters
      class PreparationPaymentSettlementGateway
        include Preparation::Application::Ports::PaymentSettlementGateway

        Snapshot = Preparation::Application::Ports::PaymentSettlementGateway::Snapshot

        def initialize(
          mapper: Persistence::PaymentMapper.new
        )
          @mapper = mapper
          @locked_payments = {}
        end

        def lock_snapshot(order_id:)
          record = Persistence::PaymentRecord.lock.find_by!(order_id: order_id.to_s)
          payment = mapper.to_domain(record)
          locked_payments[payment.id.to_s] = payment
          Snapshot.new(reference_id: payment.id.to_s)
        end

        def fully_settled?(snapshot)
          locked_payments.fetch(snapshot.reference_id).fully_settled?
        end

        private

        attr_reader :mapper, :locked_payments
      end
    end
  end
end
