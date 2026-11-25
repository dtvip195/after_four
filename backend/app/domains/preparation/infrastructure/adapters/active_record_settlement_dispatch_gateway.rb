module Preparation
  module Infrastructure
    module Adapters
      class ActiveRecordSettlementDispatchGateway
        include Application::Ports::SettlementDispatchGateway

        Snapshot = Application::Ports::SettlementDispatchGateway::Snapshot

        def initialize(
          dispatch_repository: Persistence::ActiveRecordDispatchRepository.new,
          outbox: ActiveRecordOutbox.new,
          id_generator: -> { SecureRandom.uuid }
        )
          @dispatch_repository = dispatch_repository
          @use_case = Application::UseCases::RecordSettlementDispatch.new(
            dispatch_repository: dispatch_repository,
            outbox: outbox,
            id_generator: id_generator
          )
        end

        def find_by_order_id(order_id)
          dispatch = dispatch_repository.find_by_order_id(order_id)
          dispatch && snapshot(dispatch)
        end

        def request_for_settlement(order_id:, payment_id:, branch_id:, now:)
          result = use_case.call(
            order_id: order_id.to_s,
            payment_id: payment_id.to_s,
            branch_id: branch_id,
            now: now
          )
          snapshot(result.dispatch)
        end

        private

        attr_reader :dispatch_repository, :use_case

        def snapshot(dispatch)
          Snapshot.new(
            id: dispatch.id.to_s,
            order_id: dispatch.order_id,
            payment_id: dispatch.payment_id,
            branch_id: dispatch.branch_id,
            status: dispatch.status
          )
        end
      end
    end
  end
end
