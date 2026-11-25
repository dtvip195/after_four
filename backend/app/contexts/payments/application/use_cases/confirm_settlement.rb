module Payments
  module Application
    module UseCases
      class ConfirmSettlement
        include InputValidation
        Result = Data.define(
          :order,
          :payment,
          :payment_attempt,
          :preparation_dispatch,
          :review_case,
          :replayed
        )

        def initialize(
          order_gateway:,
          payment_repository:,
          preparation_gateway:,
          review_case_gateway:,
          audit_log:,
          unit_of_work:,
          id_generator:,
          clock:
        )
          @order_gateway = order_gateway
          @payment_repository = payment_repository
          @preparation_gateway = preparation_gateway
          @review_case_gateway = review_case_gateway
          @audit_log = audit_log
          @unit_of_work = unit_of_work
          @id_generator = id_generator
          @clock = clock
        end

        def call(method:, order_id:, actor_id:, amount:, currency_code:, idempotency_key:)
          validate_command_input!(method: method, actor_id: actor_id, idempotency_key: idempotency_key)
          result = nil
          deferred_error = nil
          unit_of_work.call do
            order = order_gateway.lock(order_id)
            unless order.payment_settlement_eligible?
              raise DomainError.new("order_not_payable", "Order is not payable in its current state")
            end

            payment = payment_repository.lock_by_order_id(order.id.to_s)
            decision_time = clock.call
            outcome = payment.confirm(
              attempt_id: id_generator.call,
              method: method,
              amount: amount,
              currency_code: currency_code,
              idempotency_key: idempotency_key,
              actor_id: actor_id,
              now: decision_time
            )
            if outcome.replayed
              deferred_error = amount_mismatch_error(payment) if outcome.amount_mismatch
              result = replay_result(order, payment, outcome.attempt)
              next
            end

            payment_repository.save(payment)
            if outcome.amount_mismatch
              audit_log.amount_mismatch(
                order: order,
                attempt: outcome.attempt,
                actor_id: actor_id,
                now: decision_time
              )
              deferred_error = amount_mismatch_error(payment)
              result = Result.new(
                order: order,
                payment: payment,
                payment_attempt: outcome.attempt,
                preparation_dispatch: nil,
                review_case: nil,
                replayed: false
              )
              next
            end

            dispatch, review_case = route_success(order, payment, outcome.attempt, actor_id, decision_time)
            audit_log.payment_confirmed(
              order: order,
              attempt: outcome.attempt,
              dispatch: dispatch,
              review_case: review_case,
              actor_id: actor_id,
              now: decision_time
            )
            result = Result.new(
              order: order,
              payment: payment,
              payment_attempt: outcome.attempt,
              preparation_dispatch: dispatch,
              review_case: review_case,
              replayed: false
            )
          end
          raise deferred_error if deferred_error

          result
        rescue Domain::Errors::RuleViolation => error
          raise DomainError.new(error.code, error.message, details: error.details)
        end

        private

        attr_reader :order_gateway, :payment_repository, :preparation_gateway,
          :review_case_gateway, :audit_log, :unit_of_work, :id_generator, :clock

        def route_success(order, payment, attempt, actor_id, decision_time)
          if order.preparation_dispatch_eligible?(at: decision_time)
            dispatch = preparation_gateway.request_for_settlement(
              order_id: order.id.to_s,
              payment_id: payment.id.to_s,
              branch_id: order.branch_id,
              now: decision_time
            )
            [ dispatch, nil ]
          else
            if order.expire(now: decision_time, payment_unpaid: true) == :applied
              order_gateway.save(order)
            end
            review_case = review_case_gateway.open_late_success(
              order_id: order.id.to_s,
              payment_id: payment.id.to_s,
              payment_attempt_id: attempt.id.to_s,
              actor_id: actor_id,
              now: decision_time
            )
            [ nil, review_case ]
          end
        end

        def replay_result(order, payment, attempt)
          Result.new(
            order: order,
            payment: payment,
            payment_attempt: attempt,
            preparation_dispatch: preparation_gateway.find_by_order_id(order.id.to_s),
            review_case: review_case_gateway.find_by_attempt_id(attempt.id.to_s),
            replayed: true
          )
        end

        def amount_mismatch_error(payment)
          DomainError.new(
            "payment_amount_invalid",
            "Confirmed payment amount does not match the exact Order balance",
            details: { expected_amount: payment.target_amount, currency_code: payment.currency_code }
          )
        end
      end
    end
  end
end
