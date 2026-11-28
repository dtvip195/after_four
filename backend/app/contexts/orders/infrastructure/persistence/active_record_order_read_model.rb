require "securerandom"

module Orders
  module Infrastructure
    module Persistence
      class ActiveRecordOrderReadModel
        include Application::Ports::OrderReadModel

        Port = Application::Ports::OrderReadModel
        Result = Port::ListResult
        FindResult = Port::FindResult
        Fact = Port::Fact
        BranchReference = Application::Contracts::BranchReference
        OrderReference = Application::Contracts::OrderReference
        SafeFailureReference = Application::Contracts::SafeFailureReference

        def initialize(
          record_class: OrderRecord,
          failure_reference_generator: -> { SecureRandom.uuid }
        )
          @record_class = record_class
          @failure_reference_generator = failure_reference_generator
        end

        def list(branch_reference:, status:, offset:, limit:)
          validate_input!(branch_reference, status, offset, limit)
          relation = record_class.where(branch_id: branch_reference.value)
          relation = relation.where(status: status) if status
          total = relation.count
          rows = relation
            .order(updated_at: :desc, id: :asc)
            .offset(offset)
            .limit(limit)
            .pluck(
              :id, :branch_id, :order_number, :channel, :status, :total_amount, :currency_code,
              :lock_version, :created_at, :updated_at
            )

          Result.found(facts: rows.map { |row| Fact.new(*row) }.freeze, total: total)
        rescue ActiveRecord::ConnectionTimeoutError,
          ActiveRecord::ConnectionFailed,
          ActiveRecord::AdapterTimeout,
          ActiveRecord::StatementTimeout
          Result.unavailable(SafeFailureReference.new(failure_reference_generator.call))
        end

        def find(branch_reference:, order_reference:)
          unless branch_reference.instance_of?(BranchReference)
            raise ArgumentError, "branch_reference must be typed"
          end
          unless order_reference.instance_of?(OrderReference)
            raise ArgumentError, "order_reference must be typed"
          end

          row = record_class.where(id: order_reference.value, branch_id: branch_reference.value).pick(
            :id, :branch_id, :order_number, :channel, :status, :total_amount, :currency_code,
            :lock_version, :created_at, :updated_at
          )
          row ? FindResult.found(Fact.new(*row)) : FindResult.not_found
        rescue ActiveRecord::ConnectionTimeoutError,
          ActiveRecord::ConnectionFailed,
          ActiveRecord::AdapterTimeout,
          ActiveRecord::StatementTimeout
          FindResult.unavailable(SafeFailureReference.new(failure_reference_generator.call))
        end

        private

        attr_reader :record_class, :failure_reference_generator

        def validate_input!(branch_reference, status, offset, limit)
          unless branch_reference.instance_of?(BranchReference)
            raise ArgumentError, "branch_reference must be typed"
          end
          unless status.nil? || Domain::Aggregates::Order::STATUSES.include?(status)
            raise ArgumentError, "status is invalid"
          end
          raise ArgumentError, "offset must be nonnegative" unless offset.is_a?(Integer) && offset >= 0
          raise ArgumentError, "limit must be positive" unless limit.is_a?(Integer) && limit.positive?
        end
      end
    end
  end
end
