module Preparation
  class RequestDispatch
    Result = Data.define(:preparation_dispatch, :replayed)

    def self.call(order_id:, actor_id:, idempotency_key:, clock: -> { Time.current })
      PreparationComposition.request_dispatch(
        order_id: order_id,
        actor_id: actor_id,
        idempotency_key: idempotency_key,
        clock: clock
      )
    end

    def initialize(order_gateway:, payment_gateway:, order_id:, actor_id:, idempotency_key:, clock:)
      @order_gateway = order_gateway
      @payment_gateway = payment_gateway
      @order_id = order_id
      @actor_id = actor_id
      @idempotency_key = idempotency_key
      @clock = clock
    end

    def call
      TrustedActor.require_id!(actor_id)
      raise DomainError.new("idempotency_key_required", "Idempotency key is required") if idempotency_key.to_s.empty?

      result = nil
      ApplicationRecord.transaction do
        order = order_gateway.lock(order_id)
        payment = payment_gateway.lock_snapshot(order_id: order.id.to_s)
        decision_time = clock.call
        existing = PreparationDispatch.find_by(order_id: order.id.to_s)
        if existing
          result = Result.new(preparation_dispatch: existing, replayed: true)
          next
        end

        unless order.status == "confirmed" &&
            order.payment_expires_at &&
            decision_time < order.payment_expires_at
          raise DomainError.new("order_not_dispatchable", "Order is expired, held, or otherwise not dispatchable")
        end
        unless payment.fully_settled?
          raise DomainError.new("payment_not_fully_settled", "Full verified payment is required before preparation")
        end

        dispatch = PreparationDispatch.create!(
          order_id: order.id.to_s,
          payment_id: payment.reference_id,
          branch_id: order.branch_id,
          status: "pending",
          idempotency_key: "dispatch-request:#{idempotency_key}",
          requested_at: decision_time,
          created_at: decision_time,
          updated_at: decision_time
        )
        OutboxEvent.create!(
          event_key: "preparation.dispatch_requested:#{dispatch.id}",
          event_type: "preparation.dispatch_requested",
          aggregate_type: "PreparationDispatch",
          aggregate_id: dispatch.id,
          payload: { order_id: order.id, payment_id: payment.reference_id, branch_id: order.branch_id },
          occurred_at: decision_time,
          available_at: decision_time,
          created_at: decision_time,
          updated_at: decision_time
        )
        AuditEvent.create!(
          branch_id: order.branch_id,
          actor_type: "user",
          actor_id: actor_id,
          event_type: "preparation.dispatch_requested",
          subject_type: "PreparationDispatch",
          subject_id: dispatch.id,
          idempotency_key: "preparation.dispatch_requested:#{idempotency_key}",
          metadata: { order_id: order.id },
          occurred_at: decision_time,
          created_at: decision_time
        )
        result = Result.new(preparation_dispatch: dispatch, replayed: false)
      end
      result
    end

    private

    attr_reader :order_gateway, :payment_gateway, :order_id, :actor_id, :idempotency_key, :clock
  end
end
