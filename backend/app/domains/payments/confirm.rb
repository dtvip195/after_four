module Payments
  class Confirm
    Result = Data.define(
      :order,
      :payment,
      :payment_attempt,
      :preparation_dispatch,
      :review_case,
      :replayed
    )

    def self.call(method:, order_id:, actor_id:, amount:, currency_code:, idempotency_key:, clock: -> { Time.current })
      new(
        method: method,
        order_id: order_id,
        actor_id: actor_id,
        amount: amount,
        currency_code: currency_code,
        idempotency_key: idempotency_key,
        clock: clock
      ).call
    end

    def initialize(method:, order_id:, actor_id:, amount:, currency_code:, idempotency_key:, clock:)
      @method = method
      @order_id = order_id
      @actor_id = actor_id
      @amount = amount
      @currency_code = currency_code.to_s.upcase
      @idempotency_key = idempotency_key
      @clock = clock
    end

    def call
      TrustedActor.require_id!(actor_id)
      validate_input!

      result = nil
      deferred_error = nil
      ApplicationRecord.transaction do
        order = Order.lock.find(order_id)
        payment = order.payment.lock!
        decision_time = clock.call
        existing = payment.payment_attempts.find_by(idempotency_key: idempotency_key)
        if existing
          verify_replay!(existing)
          deferred_error = amount_mismatch_error(payment) if existing.failure_code == "amount_mismatch"
          result = build_result(order, payment, existing, true)
          next
        end

        validate_order!(order, payment)
        unless amount_matches?(payment)
          attempt = record_amount_mismatch!(order, payment, decision_time)
          deferred_error = amount_mismatch_error(payment)
          result = build_result(order, payment, attempt, false)
          next
        end

        attempt = payment.payment_attempts.create!(
          method: method,
          status: "succeeded",
          requested_amount: amount,
          confirmed_amount: amount,
          currency_code: currency_code,
          idempotency_key: idempotency_key,
          confirmed_by_actor_id: actor_id,
          confirmed_at: decision_time,
          created_at: decision_time,
          updated_at: decision_time
        )
        payment.update!(
          funding_status: "fully_paid",
          attempt_activity: "idle",
          successful_amount: amount,
          fully_settled_at: decision_time,
          updated_at: decision_time
        )

        if eligible_for_dispatch?(order, decision_time)
          dispatch = create_dispatch!(order, payment, decision_time)
          review_case = nil
        else
          expire_if_deadline_passed!(order, decision_time)
          dispatch = nil
          review_case = create_review_case!(order, payment, attempt, decision_time)
        end

        create_audit!(order, attempt, dispatch, review_case, decision_time)
        result = Result.new(
          order: order,
          payment: payment,
          payment_attempt: attempt,
          preparation_dispatch: dispatch,
          review_case: review_case,
          replayed: false
        )
      end
      raise deferred_error if deferred_error

      result
    end

    private

    attr_reader :method, :order_id, :actor_id, :amount, :currency_code,
      :idempotency_key, :clock

    def validate_input!
      raise DomainError.new("payment_method_invalid", "Unsupported payment method") unless PaymentAttempt::METHODS.include?(method)
      raise DomainError.new("idempotency_key_required", "Idempotency key is required") if idempotency_key.to_s.empty?
    end

    def validate_order!(order, payment)
      unless %w[confirmed held expired].include?(order.status)
        raise DomainError.new("order_not_payable", "Order is not payable in its current state")
      end
      if payment.funding_status != "unpaid" || payment.successful_amount != 0
        raise DomainError.new("payment_already_fully_settled", "Payment is already settled")
      end
      unless payment.attempt_activity == "idle"
        raise DomainError.new("payment_result_unknown", "A payment attempt still requires resolution")
      end
    end

    def amount_matches?(payment)
      amount == payment.target_amount && currency_code == payment.currency_code
    end

    def amount_mismatch_error(payment)
      DomainError.new(
        "payment_amount_invalid",
        "Confirmed payment amount does not match the exact Order balance",
        details: { expected_amount: payment.target_amount, currency_code: payment.currency_code }
      )
    end

    def record_amount_mismatch!(order, payment, decision_time)
      attempt = payment.payment_attempts.create!(
        method: method,
        status: "failed",
        requested_amount: amount,
        confirmed_amount: amount,
        currency_code: currency_code,
        idempotency_key: idempotency_key,
        confirmed_by_actor_id: actor_id,
        confirmed_at: decision_time,
        failure_code: "amount_mismatch",
        created_at: decision_time,
        updated_at: decision_time
      )
      AuditEvent.create!(
        branch_id: order.branch_id,
        actor_type: "user",
        actor_id: actor_id,
        event_type: "payment.amount_mismatch",
        subject_type: "PaymentAttempt",
        subject_id: attempt.id,
        idempotency_key: "payment.amount_mismatch:#{order.id}:#{idempotency_key}",
        metadata: { method: method, received_amount: amount, currency_code: currency_code },
        occurred_at: decision_time,
        created_at: decision_time
      )
      attempt
    end

    def eligible_for_dispatch?(order, decision_time)
      order.status == "confirmed" && order.payment_expires_at && decision_time < order.payment_expires_at
    end

    def expire_if_deadline_passed!(order, decision_time)
      return unless order.status == "confirmed" && order.payment_expires_at && decision_time >= order.payment_expires_at

      order.update!(status: "expired", expired_at: decision_time, updated_at: decision_time)
    end

    def create_dispatch!(order, payment, decision_time)
      dispatch = PreparationDispatch.create!(
        order: order,
        payment: payment,
        branch_id: order.branch_id,
        status: "pending",
        idempotency_key: "payment-settlement:#{payment.id}",
        requested_at: decision_time,
        created_at: decision_time,
        updated_at: decision_time
      )
      OutboxEvent.create!(
        event_key: "preparation.dispatch_requested:#{dispatch.id}",
        event_type: "preparation.dispatch_requested",
        aggregate_type: "PreparationDispatch",
        aggregate_id: dispatch.id,
        payload: { order_id: order.id, payment_id: payment.id, branch_id: order.branch_id },
        occurred_at: decision_time,
        available_at: decision_time,
        created_at: decision_time,
        updated_at: decision_time
      )
      dispatch
    end

    def create_review_case!(order, payment, attempt, decision_time)
      PaymentReviewCase.create!(
        order: order,
        payment: payment,
        payment_attempt: attempt,
        kind: "late_success",
        status: "open",
        recorded_by_actor_id: actor_id,
        opened_at: decision_time,
        created_at: decision_time,
        updated_at: decision_time
      )
    end

    def create_audit!(order, attempt, dispatch, review_case, decision_time)
      AuditEvent.create!(
        branch_id: order.branch_id,
        actor_type: "user",
        actor_id: actor_id,
        event_type: review_case ? "payment.late_success_recorded" : "payment.confirmed",
        subject_type: "PaymentAttempt",
        subject_id: attempt.id,
        idempotency_key: "payment.confirmed:#{order.id}:#{idempotency_key}",
        metadata: {
          method: method,
          amount: amount,
          currency_code: currency_code,
          preparation_dispatch_id: dispatch&.id,
          review_case_id: review_case&.id
        }.compact,
        occurred_at: decision_time,
        created_at: decision_time
      )
    end

    def verify_replay!(existing)
      return if existing.method == method &&
        existing.requested_amount == amount &&
        existing.currency_code == currency_code

      raise DomainError.new("idempotency_conflict", "Idempotency key was already used with different input")
    end

    def build_result(order, payment, attempt, replayed)
      Result.new(
        order: order,
        payment: payment,
        payment_attempt: attempt,
        preparation_dispatch: order.preparation_dispatch,
        review_case: attempt.payment_review_case,
        replayed: replayed
      )
    end
  end
end
