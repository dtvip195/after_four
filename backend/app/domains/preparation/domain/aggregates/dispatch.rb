module Preparation
  module Domain
    module Aggregates
      class Dispatch
        STATUSES = %w[pending dispatched].freeze
        UUID_FORMAT = ValueObjects::DispatchId::UUID_FORMAT

        attr_reader :id, :order_id, :payment_id, :branch_id, :status, :idempotency_key,
          :requested_at, :dispatched_at, :lock_version, :created_at, :updated_at

        def self.pending(
          id:,
          order_id:,
          payment_id:,
          branch_id:,
          idempotency_key:,
          requested_at:
        )
          new(
            id: id,
            order_id: order_id,
            payment_id: payment_id,
            branch_id: branch_id,
            status: "pending",
            idempotency_key: idempotency_key,
            requested_at: requested_at,
            dispatched_at: nil,
            lock_version: 0,
            created_at: requested_at,
            updated_at: requested_at
          )
        end

        def initialize(
          id:,
          order_id:,
          payment_id:,
          branch_id:,
          status:,
          idempotency_key:,
          requested_at:,
          lock_version:,
          created_at:,
          updated_at:,
          dispatched_at: nil
        )
          @id = id.is_a?(ValueObjects::DispatchId) ? id : ValueObjects::DispatchId.new(id)
          @order_id = canonical_uuid(order_id, "Order identity")
          @payment_id = canonical_uuid(payment_id, "Payment identity")
          @branch_id = canonical_uuid(branch_id, "Branch identity")
          raise ArgumentError, "Preparation Dispatch status is invalid" unless STATUSES.include?(status)

          @status = status
          @idempotency_key = required_text(idempotency_key, "Preparation Dispatch idempotency key")
          @requested_at = required_value(requested_at, "Preparation Dispatch request timestamp")
          @dispatched_at = dispatched_at
          @lock_version = Integer(lock_version)
          raise ArgumentError, "Preparation Dispatch lock version must be nonnegative" if @lock_version.negative?

          @created_at = required_value(created_at, "Preparation Dispatch creation timestamp")
          @updated_at = required_value(updated_at, "Preparation Dispatch update timestamp")
          validate_lifecycle_evidence!
        end

        def ensure_retryable!
          return self if status == "pending"

          raise Errors::RuleViolation.new(
            "dispatch_already_completed",
            "Preparation Dispatch is already complete"
          )
        end

        private

        def canonical_uuid(value, label)
          canonical = value.to_s.downcase
          raise ArgumentError, "#{label} must be a UUID" unless canonical.match?(UUID_FORMAT)

          canonical
        end

        def required_text(value, label)
          text = value.to_s
          raise ArgumentError, "#{label} is required" if text.empty?

          text
        end

        def required_value(value, label)
          raise ArgumentError, "#{label} is required" if value.nil?

          value
        end

        def validate_lifecycle_evidence!
          if status == "pending" && dispatched_at
            raise ArgumentError, "Pending Preparation Dispatch cannot have dispatched evidence"
          end
          return unless status == "dispatched" && dispatched_at.nil?

          raise ArgumentError, "Dispatched Preparation Dispatch requires dispatched evidence"
        end
      end
    end
  end
end
