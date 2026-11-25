module Orders
  module Application
    module UseCases
      class ExpirePending
        Result = Data.define(:expired_order_ids)

        def initialize(order_repository:, payment_gateway:, audit_log:, unit_of_work:)
          @order_repository = order_repository
          @payment_gateway = payment_gateway
          @audit_log = audit_log
          @unit_of_work = unit_of_work
        end

        def call(now:)
          expired_ids = order_repository.expiration_candidate_ids(now: now).filter_map do |order_id|
            expire_one(order_id, now)
          end
          Result.new(expired_order_ids: expired_ids)
        end

        private

        attr_reader :order_repository, :payment_gateway, :audit_log, :unit_of_work

        def expire_one(order_id, now)
          expired = false
          unit_of_work.call do
            order = order_repository.lock(order_id)
            payment = payment_gateway.lock_snapshot(order_id: order.id.to_s)
            next unless order.expire(now: now, payment_unpaid: payment.unpaid?) == :applied

            order_repository.save(order)
            audit_log.order_expired(order: order, now: now)
            expired = true
          end
          order_id if expired
        end
      end
    end
  end
end
