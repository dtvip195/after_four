module Payments
  module Infrastructure
    module Adapters
      class OrdersOrderScopeResolver
        include Application::Ports::OrderScopeResolver

        Result = Application::Ports::OrderScopeResolver::Result
        FailureReference = Application::Contracts::SafeFailureReference

        def initialize(order_query:)
          @order_query = order_query
        end

        def resolve(branch_reference:, order_reference:)
          result = order_query.call(
            branch_reference: Orders::Application::Contracts::BranchReference.new(branch_reference.value),
            order_reference: Orders::Application::Contracts::OrderReference.new(order_reference.value)
          )
          return Result.found if result.found?
          return Result.not_found if result.not_found? || result.invalid?
          return Result.inconsistent if result.inconsistent?
          if result.unavailable?
            return Result.unavailable(FailureReference.new(result.failure_reference.value))
          end

          Result.inconsistent
        end

        private

        attr_reader :order_query
      end
    end
  end
end
