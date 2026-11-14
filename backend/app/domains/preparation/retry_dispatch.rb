module Preparation
  class RetryDispatch
    Result = Data.define(:preparation_dispatch, :replayed)

    def self.call(preparation_dispatch_id:, actor_id:, idempotency_key:, now: Time.current)
      TrustedActor.require_id!(actor_id)
      raise DomainError.new("idempotency_key_required", "Idempotency key is required") if idempotency_key.to_s.empty?

      result = nil
      ApplicationRecord.transaction do
        dispatch = PreparationDispatch.lock.find(preparation_dispatch_id)
        audit_key = "preparation.dispatch_retry:#{dispatch.id}:#{idempotency_key}"
        if AuditEvent.exists?(
          branch_id: dispatch.branch_id,
          idempotency_key: audit_key,
          event_type: "preparation.dispatch_retry_requested",
          subject_type: "PreparationDispatch",
          subject_id: dispatch.id
        )
          result = Result.new(preparation_dispatch: dispatch, replayed: true)
          next
        end
        unless dispatch.status == "pending"
          raise DomainError.new("dispatch_already_completed", "Preparation Dispatch is already complete")
        end

        event = OutboxEvent.lock.find_by!(
          event_key: "preparation.dispatch_requested:#{dispatch.id}"
        )
        event.update!(status: "pending", available_at: now, published_at: nil, updated_at: now)
        AuditEvent.create!(
          branch_id: dispatch.branch_id,
          actor_type: "user",
          actor_id: actor_id,
          event_type: "preparation.dispatch_retry_requested",
          subject_type: "PreparationDispatch",
          subject_id: dispatch.id,
          idempotency_key: audit_key,
          metadata: {},
          occurred_at: now,
          created_at: now
        )
        result = Result.new(preparation_dispatch: dispatch, replayed: false)
      end
      result
    end
  end
end
