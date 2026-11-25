module Orders
  module Application
    module UseCases
      class Hold
        include InputValidation

        Result = Data.define(:order, :replayed)

        def initialize(order_repository:, payment_gateway:, audit_log:, unit_of_work:)
          @order_repository = order_repository
          @payment_gateway = payment_gateway
          @audit_log = audit_log
          @unit_of_work = unit_of_work
        end

        def call(order_id:, actor_id:, reason:, idempotency_key:, expected_version:, now:)
          actor_id = require_actor!(actor_id)
          raise Domain::Errors::RuleViolation.new("reason_required", "A hold reason is required") if reason.to_s.strip.empty?
          require_idempotency_key!(idempotency_key, reject_whitespace: false)
          order = nil
          outcome = nil
          unit_of_work.call do
            order = order_repository.lock(order_id)
            payment = payment_gateway.lock_snapshot(order_id: order.id.to_s)
            outcome = order.hold(
              reason: reason,
              idempotency_key: idempotency_key,
              expected_version: expected_version,
              now: now,
              payment_unpaid: payment.unpaid?
            )
            if outcome == :applied
              order_repository.save(order)
              audit_log.order_held(order: order, actor_id: actor_id, reason: reason, now: now)
            end
          end
          Result.new(order: order, replayed: outcome == :replayed)
        end

        private

        attr_reader :order_repository, :payment_gateway, :audit_log, :unit_of_work
      end
    end
  end
end
