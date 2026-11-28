module Orders
  module Application
    module Queries
      class ListOrders
        Contracts = Application::Contracts
        Port = Application::Ports::OrderReadModel
        Result = Contracts::ListOrdersResult

        def initialize(reader:)
          @reader = reader
        end

        def call(branch_reference:, page_request:)
          return Result.invalid unless branch_reference.instance_of?(Contracts::BranchReference)
          return Result.invalid unless page_request.instance_of?(Contracts::OrderPageRequest)

          read_result = reader.list(
            branch_reference: branch_reference,
            status: page_request.status,
            offset: page_request.offset,
            limit: page_request.limit
          )
          map_result(read_result, branch_reference, page_request)
        rescue StandardError, NotImplementedError
          raise Errors::UnexpectedFailure, Errors::UnexpectedFailure::MESSAGE, [], cause: nil
        end

        private

        attr_reader :reader

        def map_result(read_result, branch_reference, request)
          return Result.inconsistent unless read_result.is_a?(Port::ListResult)
          return Result.inconsistent if read_result.inconsistent?
          return unavailable(read_result.failure_reference) if read_result.unavailable?
          return Result.inconsistent unless read_result.found?
          return Result.inconsistent unless valid_collection?(read_result.facts, read_result.total, request)

          views = read_result.facts.map do |fact|
            return Result.inconsistent unless valid_fact?(fact, branch_reference, request.status)

            Contracts::OrderView.new(**fact.to_h)
          end
          page = Contracts::OrderPage.new(
            orders: views,
            page: request.page,
            limit: request.limit,
            total: read_result.total,
            total_pages: read_result.total.zero? ? 0 : (read_result.total.to_f / request.limit).ceil
          )
          Result.found(page)
        end

        def unavailable(reference)
          return Result.inconsistent unless reference.instance_of?(Contracts::SafeFailureReference)

          Result.unavailable(reference)
        end

        def valid_collection?(facts, total, request)
          facts.is_a?(Array) && facts.length <= request.limit &&
            total.is_a?(Integer) && total >= facts.length && total >= 0 &&
            facts.map { |fact| fact.id if fact.is_a?(Port::Fact) }.uniq.length == facts.length
        end

        def valid_fact?(fact, branch_reference, requested_status)
          fact.is_a?(Port::Fact) && uuid?(fact.id) && fact.branch_id == branch_reference.value &&
            nonempty?(fact.order_number) && Domain::ValueObjects::ServiceChannel::VALUES.include?(fact.channel) &&
            Domain::Aggregates::Order::STATUSES.include?(fact.status) &&
            (requested_status.nil? || fact.status == requested_status) &&
            fact.total_amount.is_a?(Integer) && fact.total_amount.positive? &&
            fact.currency_code.is_a?(String) && fact.currency_code.match?(/\A[A-Z]{3}\z/) &&
            fact.lock_version.is_a?(Integer) && fact.lock_version >= 0 &&
            fact.created_at.respond_to?(:iso8601) && fact.updated_at.respond_to?(:iso8601)
        end

        def uuid?(value) = value.is_a?(String) && Contracts::BranchReference::UUID_PATTERN.match?(value)
        def nonempty?(value) = value.is_a?(String) && !value.strip.empty?
      end
    end
  end
end
