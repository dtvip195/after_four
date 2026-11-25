module Payments
  module Infrastructure
    module Adapters
      class OrderingPaymentGateway
        include Orders::Application::Ports::PaymentGateway

        Snapshot = Orders::Application::Ports::PaymentGateway::Snapshot

        def create_target(order_id:, amount:, currency_code:, now:)
          Payment.create!(
            order_id: order_id,
            target_amount: amount,
            currency_code: currency_code,
            created_at: now,
            updated_at: now
          ).id
        end

        def reference_for_order(order_id:)
          Payment.find_by!(order_id: order_id).id
        end

        def lock_snapshot(order_id:)
          payment = Payment.lock.find_by!(order_id: order_id)
          Snapshot.new(reference_id: payment.id, funding_status: payment.funding_status)
        end

        def compatibility_record(reference_id)
          Payment.find(reference_id)
        end
      end
    end
  end
end
