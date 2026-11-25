module Preparation
  module Application
    module UseCases
      class RetryDispatch
        include InputValidation

        Result = Data.define(:preparation_dispatch, :replayed)

        def initialize(dispatch_repository:, outbox:, audit_log:, unit_of_work:)
          @dispatch_repository = dispatch_repository
          @outbox = outbox
          @audit_log = audit_log
          @unit_of_work = unit_of_work
        end

        def call(preparation_dispatch_id:, actor_id:, idempotency_key:, now:)
          dispatch_id = require_uuid!(preparation_dispatch_id, "Preparation Dispatch identity")
          normalized_actor_id = require_actor!(actor_id)
          command_key = require_idempotency_key!(idempotency_key)
          result = nil

          unit_of_work.call do
            dispatch = dispatch_repository.lock(dispatch_id)
            if audit_log.dispatch_retry_recorded?(dispatch: dispatch, command_key: command_key)
              result = Result.new(preparation_dispatch: dispatch, replayed: true)
              next
            end

            dispatch.ensure_retryable!
            outbox.requeue_dispatch(dispatch_id: dispatch.id.to_s, now: now)
            audit_log.dispatch_retry_requested(
              dispatch: dispatch,
              actor_id: normalized_actor_id,
              command_key: command_key,
              now: now
            )
            result = Result.new(preparation_dispatch: dispatch, replayed: false)
          end
          result
        rescue Domain::Errors::RuleViolation => error
          raise DomainError.new(error.code, error.message, details: error.details)
        end

        private

        attr_reader :dispatch_repository, :outbox, :audit_log, :unit_of_work
      end
    end
  end
end
