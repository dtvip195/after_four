module Preparation
  module Application
    module UseCases
      class RecordSettlementDispatch
        Result = Data.define(:dispatch, :replayed)

        def initialize(dispatch_repository:, outbox:, id_generator:)
          @dispatch_repository = dispatch_repository
          @outbox = outbox
          @id_generator = id_generator
        end

        def call(order_id:, payment_id:, branch_id:, now:)
          existing = dispatch_repository.find_by_order_id(order_id)
          return Result.new(dispatch: existing, replayed: true) if existing

          dispatch = Domain::Aggregates::Dispatch.pending(
            id: id_generator.call,
            order_id: order_id,
            payment_id: payment_id,
            branch_id: branch_id,
            idempotency_key: "payment-settlement:#{payment_id}",
            requested_at: now
          )
          dispatch_repository.add(dispatch)
          outbox.dispatch_requested(dispatch)
          Result.new(dispatch: dispatch, replayed: false)
        end

        private

        attr_reader :dispatch_repository, :outbox, :id_generator
      end
    end
  end
end
