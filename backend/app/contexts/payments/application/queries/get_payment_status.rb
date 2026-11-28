module Payments
  module Application
    module Queries
      class GetPaymentStatus
        Contracts = Application::Contracts
        ScopePort = Application::Ports::OrderScopeResolver
        ReaderPort = Application::Ports::PaymentStatusReader
        Result = Contracts::GetPaymentStatusResult

        def initialize(order_scope_resolver:, reader:)
          @order_scope_resolver = order_scope_resolver
          @reader = reader
        end

        def call(branch_reference:, order_reference:)
          return Result.invalid unless branch_reference.instance_of?(Contracts::BranchReference)
          return Result.invalid unless order_reference.instance_of?(Contracts::OrderReference)

          scope = order_scope_resolver.resolve(
            branch_reference: branch_reference,
            order_reference: order_reference
          )
          scope_result = map_scope(scope)
          return scope_result unless scope_result == :continue

          map_payment(reader.find(order_reference: order_reference), order_reference)
        rescue StandardError, NotImplementedError
          raise Errors::UnexpectedFailure, Errors::UnexpectedFailure::MESSAGE, [], cause: nil
        end

        private

        attr_reader :order_scope_resolver, :reader

        def map_scope(scope)
          return Result.inconsistent unless scope.is_a?(ScopePort::Result)
          return :continue if scope.found?
          return Result.not_found if scope.not_found?
          return Result.inconsistent if scope.inconsistent?
          return unavailable(scope.failure_reference) if scope.unavailable?

          Result.inconsistent
        end

        def map_payment(read_result, order_reference)
          return Result.inconsistent unless read_result.is_a?(ReaderPort::Result)
          return Result.not_found if read_result.not_found?
          return Result.inconsistent if read_result.inconsistent?
          return unavailable(read_result.failure_reference) if read_result.unavailable?
          return Result.inconsistent unless read_result.found?
          return Result.inconsistent unless valid_fact?(read_result.fact, order_reference)

          fact = read_result.fact
          snapshot = fact.snapshot
          Result.found(
            Contracts::PaymentStatusView.new(
              id: fact.id,
              order_id: fact.order_id,
              funding_status: snapshot.funding_status,
              attempt_activity: snapshot.attempt_activity,
              target_amount: snapshot.target_amount,
              successful_amount: snapshot.successful_amount,
              refunded_amount: snapshot.refunded_amount,
              currency_code: snapshot.currency_code,
              fully_settled_at: fact.fully_settled_at,
              lock_version: snapshot.lock_version,
              updated_at: fact.updated_at
            )
          )
        end

        def unavailable(reference)
          return Result.inconsistent unless reference.instance_of?(Contracts::SafeFailureReference)
          Result.unavailable(reference)
        end

        def valid_fact?(fact, order_reference)
          fact.is_a?(ReaderPort::Fact) && uuid?(fact.id) && fact.order_id == order_reference.value &&
            fact.snapshot.instance_of?(Domain::ValueObjects::PaymentStatusSnapshot) &&
            settlement_consistent?(fact) &&
            fact.updated_at.respond_to?(:iso8601)
        end

        def settlement_consistent?(fact)
          fully_paid = %w[fully_paid partially_refunded fully_refunded].include?(fact.snapshot.funding_status)
          fully_paid == !fact.fully_settled_at.nil?
        end

        def uuid?(value) = value.is_a?(String) && Contracts::BranchReference::UUID_PATTERN.match?(value)
      end
    end
  end
end
