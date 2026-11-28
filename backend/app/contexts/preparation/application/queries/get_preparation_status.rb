module Preparation
  module Application
    module Queries
      class GetPreparationStatus
        Contracts = Application::Contracts
        Port = Application::Ports::PreparationStatusReader
        Result = Contracts::GetPreparationStatusResult

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
          return Result.inconsistent unless read_result.is_a?(Port::Result)
          return Result.not_found if read_result.not_found?
          return Result.inconsistent if read_result.inconsistent?
          return unavailable(read_result.failure_reference) if read_result.unavailable?
          return Result.inconsistent unless read_result.found?
          return Result.inconsistent unless valid_fact?(read_result.fact, branch_reference, order_reference)

          Result.found(Contracts::PreparationStatusView.new(**read_result.fact.to_h))
        end

        def unavailable(reference)
          return Result.inconsistent unless reference.instance_of?(Contracts::SafeFailureReference)

          Result.unavailable(reference)
        end

        def valid_fact?(fact, branch_reference, order_reference)
          fact.is_a?(Port::Fact) && uuid?(fact.id) && uuid?(fact.payment_id) &&
            fact.order_id == order_reference.value && fact.branch_id == branch_reference.value &&
            Domain::Aggregates::Dispatch::STATUSES.include?(fact.status) &&
            fact.requested_at.respond_to?(:iso8601) && optional_time?(fact.dispatched_at) &&
            dispatch_evidence_consistent?(fact) &&
            fact.lock_version.is_a?(Integer) && fact.lock_version >= 0 &&
            fact.updated_at.respond_to?(:iso8601)
        end

        def dispatch_evidence_consistent?(fact)
          (fact.status == "pending" && fact.dispatched_at.nil?) ||
            (fact.status == "dispatched" && !fact.dispatched_at.nil?)
        end

        def uuid?(value)
          value.is_a?(String) && Contracts::BranchReference::UUID_PATTERN.match?(value)
        end

        def optional_time?(value) = value.nil? || value.respond_to?(:iso8601)
      end
    end
  end
end
