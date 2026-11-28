module Orders
  module Application
    module Queries
      class GetOrder
        Contracts = Application::Contracts
        Port = Application::Ports::OrderReadModel
        Result = Contracts::GetOrderResult

        def initialize(reader:)
          @reader = reader
        end

        def call(branch_reference:, order_reference:)
          return Result.invalid unless branch_reference.instance_of?(Contracts::BranchReference)
          return Result.invalid unless order_reference.instance_of?(Contracts::OrderReference)

          map_result(
            reader.find(branch_reference: branch_reference, order_reference: order_reference),
            branch_reference,
            order_reference
          )
        rescue StandardError, NotImplementedError
          raise Errors::UnexpectedFailure, Errors::UnexpectedFailure::MESSAGE, [], cause: nil
        end

        private

        attr_reader :reader

        def map_result(read_result, branch_reference, order_reference)
          return Result.inconsistent unless read_result.is_a?(Port::FindResult)
          return Result.not_found if read_result.not_found?
          return Result.inconsistent if read_result.inconsistent?
          return unavailable(read_result.failure_reference) if read_result.unavailable?
          return Result.inconsistent unless read_result.found?
          return Result.inconsistent unless valid_fact?(read_result.fact, branch_reference, order_reference)

          Result.found(Contracts::OrderView.new(**read_result.fact.to_h))
        end

        def unavailable(reference)
          return Result.inconsistent unless reference.instance_of?(Contracts::SafeFailureReference)

          Result.unavailable(reference)
        end

        def valid_fact?(fact, branch_reference, order_reference)
          fact.is_a?(Port::Fact) && fact.id == order_reference.value &&
            fact.branch_id == branch_reference.value &&
            Domain::Aggregates::Order::STATUSES.include?(fact.status) &&
            Domain::ValueObjects::ServiceChannel::VALUES.include?(fact.channel) &&
            fact.order_number.is_a?(String) && !fact.order_number.strip.empty? &&
            fact.total_amount.is_a?(Integer) && fact.total_amount.positive? &&
            fact.currency_code.is_a?(String) && fact.currency_code.match?(/\A[A-Z]{3}\z/) &&
            fact.lock_version.is_a?(Integer) && fact.lock_version >= 0 &&
            fact.created_at.respond_to?(:iso8601) && fact.updated_at.respond_to?(:iso8601)
        end
      end
    end
  end
end
