require "securerandom"

module Payments
  module Infrastructure
    module Persistence
      class ActiveRecordPaymentStatusReader
        include Application::Ports::PaymentStatusReader

        Port = Application::Ports::PaymentStatusReader
        Result = Port::Result
        Fact = Port::Fact
        StatusSnapshot = Domain::ValueObjects::PaymentStatusSnapshot
        Money = Domain::ValueObjects::Money
        OrderReference = Application::Contracts::OrderReference
        FailureReference = Application::Contracts::SafeFailureReference

        def initialize(
          record_class: PaymentRecord,
          failure_reference_generator: -> { SecureRandom.uuid }
        )
          @record_class = record_class
          @failure_reference_generator = failure_reference_generator
        end

        def find(order_reference:)
          unless order_reference.instance_of?(OrderReference)
            raise ArgumentError, "order_reference must be typed"
          end

          row = record_class.where(order_id: order_reference.value).pick(
            :id, :order_id, :funding_status, :attempt_activity, :target_amount,
            :successful_amount, :refunded_amount, :currency_code, :fully_settled_at,
            :lock_version, :updated_at
          )
          return Result.not_found unless row

          fact = map_fact(row)
          fact ? Result.found(fact) : Result.inconsistent
        rescue ActiveRecord::ConnectionTimeoutError,
          ActiveRecord::ConnectionFailed,
          ActiveRecord::AdapterTimeout,
          ActiveRecord::StatementTimeout
          Result.unavailable(FailureReference.new(failure_reference_generator.call))
        end

        private

        attr_reader :record_class, :failure_reference_generator

        def map_fact(row)
          id, order_id, funding_status, attempt_activity, target_amount,
            successful_amount, refunded_amount, currency_code, fully_settled_at,
            lock_version, updated_at = row
          snapshot = StatusSnapshot.new(
            funding_status: funding_status,
            attempt_activity: attempt_activity,
            target: Money.new(amount: target_amount, currency_code: currency_code),
            successful_amount: successful_amount,
            refunded_amount: refunded_amount,
            lock_version: lock_version
          )
          Fact.new(
            id: id,
            order_id: order_id,
            snapshot: snapshot,
            fully_settled_at: fully_settled_at,
            updated_at: updated_at
          )
        rescue ArgumentError, TypeError
          nil
        end
      end
    end
  end
end
