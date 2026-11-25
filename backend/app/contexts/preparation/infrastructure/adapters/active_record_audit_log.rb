module Preparation
  module Infrastructure
    module Adapters
      class ActiveRecordAuditLog
        include Application::Ports::AuditLog

        def dispatch_requested(dispatch:, actor_id:, command_key:, now:)
          AuditEvent.create!(
            branch_id: dispatch.branch_id,
            actor_type: "user",
            actor_id: actor_id,
            event_type: "preparation.dispatch_requested",
            subject_type: "PreparationDispatch",
            subject_id: dispatch.id.to_s,
            idempotency_key: "preparation.dispatch_requested:#{command_key}",
            metadata: { order_id: dispatch.order_id },
            occurred_at: now,
            created_at: now
          )
        end

        def dispatch_retry_recorded?(dispatch:, command_key:)
          AuditEvent.exists?(
            branch_id: dispatch.branch_id,
            idempotency_key: retry_key(dispatch, command_key),
            event_type: "preparation.dispatch_retry_requested",
            subject_type: "PreparationDispatch",
            subject_id: dispatch.id.to_s
          )
        end

        def dispatch_retry_requested(dispatch:, actor_id:, command_key:, now:)
          AuditEvent.create!(
            branch_id: dispatch.branch_id,
            actor_type: "user",
            actor_id: actor_id,
            event_type: "preparation.dispatch_retry_requested",
            subject_type: "PreparationDispatch",
            subject_id: dispatch.id.to_s,
            idempotency_key: retry_key(dispatch, command_key),
            metadata: {},
            occurred_at: now,
            created_at: now
          )
        end

        private

        def retry_key(dispatch, command_key)
          "preparation.dispatch_retry:#{dispatch.id}:#{command_key}"
        end
      end
    end
  end
end
