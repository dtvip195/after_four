module Orders
  module Application
    module UseCases
      class Confirm
        include InputValidation

        Result = Data.define(:order, :replayed)

        def initialize(order_repository:, audit_log:, unit_of_work:, payment_window:, clock:)
          @order_repository = order_repository
          @audit_log = audit_log
          @unit_of_work = unit_of_work
          @payment_window = payment_window
          @clock = clock
        end

        def call(order_id:, actor_id:, idempotency_key:, expected_version:)
          actor_id = require_actor!(actor_id)
          require_idempotency_key!(idempotency_key, reject_whitespace: false)
          order = nil
          outcome = nil
          unit_of_work.call do
            order = order_repository.lock(order_id)
            now = clock.call
            outcome = order.confirm(
              idempotency_key: idempotency_key,
              expected_version: expected_version,
              now: now,
              payment_window: payment_window
            )
            if outcome == :applied
              order_repository.save(order)
              audit_log.order_confirmed(order: order, actor_id: actor_id, now: now)
            end
          end
          Result.new(order: order, replayed: outcome == :replayed)
        end

        private

        attr_reader :order_repository, :audit_log, :unit_of_work, :payment_window, :clock
      end
    end
  end
end
