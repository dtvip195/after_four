require "securerandom"

module Preparation
  module Infrastructure
    module Persistence
      class ActiveRecordPreparationStatusReader
        include Application::Ports::PreparationStatusReader

        Port = Application::Ports::PreparationStatusReader
        Result = Port::Result
        Fact = Port::Fact
        BranchReference = Application::Contracts::BranchReference
        OrderReference = Application::Contracts::OrderReference
        SafeFailureReference = Application::Contracts::SafeFailureReference

        def initialize(
          record_class: DispatchRecord,
          failure_reference_generator: -> { SecureRandom.uuid }
        )
          @record_class = record_class
          @failure_reference_generator = failure_reference_generator
        end

        def find(branch_reference:, order_reference:)
          validate_input!(branch_reference, order_reference)
          row = record_class.where(
            branch_id: branch_reference.value,
            order_id: order_reference.value
          ).pick(
            :id, :order_id, :payment_id, :branch_id, :status, :requested_at, :dispatched_at,
            :lock_version, :updated_at
          )
          row ? Result.found(Fact.new(*row)) : Result.not_found
        rescue ActiveRecord::ConnectionTimeoutError,
          ActiveRecord::ConnectionFailed,
          ActiveRecord::AdapterTimeout,
          ActiveRecord::StatementTimeout
          Result.unavailable(SafeFailureReference.new(failure_reference_generator.call))
        end

        private

        attr_reader :record_class, :failure_reference_generator

        def validate_input!(branch_reference, order_reference)
          unless branch_reference.instance_of?(BranchReference)
            raise ArgumentError, "branch_reference must be typed"
          end
          unless order_reference.instance_of?(OrderReference)
            raise ArgumentError, "order_reference must be typed"
          end
        end
      end
    end
  end
end
