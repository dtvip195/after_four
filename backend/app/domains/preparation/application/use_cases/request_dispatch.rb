module Preparation
  module Application
    module UseCases
      class RequestDispatch
        include InputValidation

        Result = Data.define(:preparation_dispatch, :replayed)

        def initialize(
          order_gateway:,
          payment_gateway:,
          dispatch_repository:,
          outbox:,
          audit_log:,
          unit_of_work:,
          id_generator:,
          clock:
        )
          @order_gateway = order_gateway
          @payment_gateway = payment_gateway
          @dispatch_repository = dispatch_repository
          @outbox = outbox
          @audit_log = audit_log
          @unit_of_work = unit_of_work
          @id_generator = id_generator
          @clock = clock
        end

        def call(order_id:, actor_id:, idempotency_key:)
          normalized_order_id = require_uuid!(order_id, "Order identity")
          normalized_actor_id = require_actor!(actor_id)
          command_key = require_idempotency_key!(idempotency_key)
          result = nil

          unit_of_work.call do
            order = order_gateway.lock(normalized_order_id)
            payment = payment_gateway.lock_snapshot(order_id: order.id)
            decision_time = clock.call
            existing = dispatch_repository.find_by_order_id(order.id)
            if existing
              result = Result.new(preparation_dispatch: existing, replayed: true)
              next
            end

            unless order_gateway.dispatch_eligible?(order, at: decision_time)
              raise DomainError.new(
                "order_not_dispatchable",
                "Order is expired, held, or otherwise not dispatchable"
              )
            end
            unless payment_gateway.fully_settled?(payment)
              raise DomainError.new(
                "payment_not_fully_settled",
                "Full verified payment is required before preparation"
              )
            end

            dispatch = Domain::Aggregates::Dispatch.pending(
              id: id_generator.call,
              order_id: order.id,
              payment_id: payment.reference_id,
              branch_id: order.branch_id,
              idempotency_key: "dispatch-request:#{command_key}",
              requested_at: decision_time
            )
            dispatch_repository.add(dispatch)
            outbox.dispatch_requested(dispatch)
            audit_log.dispatch_requested(
              dispatch: dispatch,
              actor_id: normalized_actor_id,
              command_key: command_key,
              now: decision_time
            )
            result = Result.new(preparation_dispatch: dispatch, replayed: false)
          end
          result
        end

        private

        attr_reader :order_gateway, :payment_gateway, :dispatch_repository, :outbox,
          :audit_log, :unit_of_work, :id_generator, :clock
      end
    end
  end
end
