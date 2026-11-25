module Orders
  module Domain
    module Aggregates
      class Order
        STATUSES = %w[draft confirmed held expired cancelled closed].freeze
        UUID_FORMAT = /\A[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}\z/i
        FINGERPRINT_FORMAT = /\A[0-9a-f]{64}\z/

        attr_reader :id, :branch_id, :created_by_actor_id, :order_number, :channel, :status,
          :total, :creation_idempotency_key, :creation_request_fingerprint,
          :confirmation_idempotency_key, :confirmed_at, :payment_expires_at, :expired_at,
          :held_at, :hold_reason, :hold_idempotency_key, :lock_version, :created_at, :updated_at

        def self.draft(
          id:,
          branch_id:,
          created_by_actor_id:,
          order_number:,
          channel:,
          total:,
          creation_idempotency_key:,
          creation_request_fingerprint:,
          created_at:
        )
          new(
            id: id,
            branch_id: branch_id,
            created_by_actor_id: created_by_actor_id,
            order_number: order_number,
            channel: channel,
            status: "draft",
            total: total,
            creation_idempotency_key: creation_idempotency_key,
            creation_request_fingerprint: creation_request_fingerprint,
            lock_version: 0,
            created_at: created_at,
            updated_at: created_at
          )
        end

        def initialize(
          id:,
          branch_id:,
          created_by_actor_id:,
          order_number:,
          channel:,
          status:,
          total:,
          creation_idempotency_key:,
          creation_request_fingerprint:,
          lock_version:,
          created_at:,
          updated_at:,
          confirmation_idempotency_key: nil,
          confirmed_at: nil,
          payment_expires_at: nil,
          expired_at: nil,
          held_at: nil,
          hold_reason: nil,
          hold_idempotency_key: nil
        )
          @id = id.is_a?(ValueObjects::OrderId) ? id : ValueObjects::OrderId.new(id)
          @branch_id = canonical_uuid(branch_id, "Branch identity")
          @created_by_actor_id = canonical_uuid(created_by_actor_id, "Actor identity")
          @order_number = ValueObjects::OrderNumber.new(order_number).to_s
          @channel = channel.is_a?(ValueObjects::ServiceChannel) ? channel : ValueObjects::ServiceChannel.new(channel)
          raise ArgumentError, "Order status is invalid" unless STATUSES.include?(status)
          raise ArgumentError, "Order total must be Money" unless total.is_a?(ValueObjects::Money)

          @status = status
          @total = total
          @creation_idempotency_key = required_text(creation_idempotency_key, "Creation idempotency key")
          unless creation_request_fingerprint.to_s.match?(FINGERPRINT_FORMAT)
            raise ArgumentError, "Creation request fingerprint must be a lowercase SHA-256 digest"
          end
          @creation_request_fingerprint = creation_request_fingerprint.to_s
          @confirmation_idempotency_key = confirmation_idempotency_key
          @confirmed_at = confirmed_at
          @payment_expires_at = payment_expires_at
          @expired_at = expired_at
          @held_at = held_at
          @hold_reason = hold_reason
          @hold_idempotency_key = hold_idempotency_key
          @lock_version = Integer(lock_version)
          raise ArgumentError, "Order lock version must be nonnegative" if @lock_version.negative?

          @created_at = required_value(created_at, "Order creation timestamp")
          @updated_at = required_value(updated_at, "Order update timestamp")

          validate_lifecycle_evidence!
        end

        def confirm(idempotency_key:, expected_version:, now:, payment_window:)
          return :replayed if confirmation_idempotency_key == idempotency_key

          ensure_version!(expected_version, include_current_version: true)
          unless status == "draft"
            raise Errors::RuleViolation.new(
              "invalid_state_transition",
              "Only a draft Order can be confirmed"
            )
          end

          @status = "confirmed"
          @confirmation_idempotency_key = idempotency_key
          @confirmed_at = now
          @payment_expires_at = payment_window.deadline_from(now)
          @updated_at = now
          :applied
        end

        def hold(reason:, idempotency_key:, expected_version:, now:, payment_unpaid:)
          if reason.to_s.strip.empty?
            raise Errors::RuleViolation.new("reason_required", "A hold reason is required")
          end
          return :replayed if hold_idempotency_key == idempotency_key

          ensure_version!(expected_version, include_current_version: false)
          unless status == "confirmed" && payment_unpaid
            raise Errors::RuleViolation.new(
              "invalid_state_transition",
              "Only a confirmed unpaid Order can be held"
            )
          end

          @status = "held"
          @held_at = now
          @hold_reason = reason
          @hold_idempotency_key = idempotency_key
          @updated_at = now
          :applied
        end

        def expire(now:, payment_unpaid:)
          return :ineligible unless status == "confirmed"
          return :ineligible unless payment_expires_at && payment_expires_at <= now
          return :ineligible unless payment_unpaid

          @status = "expired"
          @expired_at = now
          @updated_at = now
          :applied
        end

        private

        def canonical_uuid(value, label)
          canonical = value.to_s.downcase
          raise ArgumentError, "#{label} must be a UUID" unless canonical.match?(UUID_FORMAT)

          canonical
        end

        def required_text(value, label)
          text = value.to_s
          raise ArgumentError, "#{label} is required" if text.strip.empty?

          text
        end

        def required_value(value, label)
          raise ArgumentError, "#{label} is required" if value.nil?

          value
        end

        def validate_lifecycle_evidence!
          case status
          when "draft"
            reject_evidence!(:confirmation, confirmation_evidence)
            reject_evidence!(:hold, hold_evidence)
            reject_evidence!(:expiration, expiration_evidence)
          when "confirmed"
            require_evidence!(:confirmation, confirmation_evidence)
            reject_evidence!(:hold, hold_evidence)
            reject_evidence!(:expiration, expiration_evidence)
          when "held"
            require_evidence!(:confirmation, confirmation_evidence)
            require_evidence!(:hold, hold_evidence)
            require_nonblank_hold_reason!
            reject_evidence!(:expiration, expiration_evidence)
          when "expired"
            require_evidence!(:confirmation, confirmation_evidence)
            require_evidence!(:expiration, expiration_evidence)
            reject_evidence!(:hold, hold_evidence)
          end
        end

        def confirmation_evidence
          {
            confirmation_idempotency_key: confirmation_idempotency_key,
            confirmed_at: confirmed_at,
            payment_expires_at: payment_expires_at
          }
        end

        def hold_evidence
          {
            hold_idempotency_key: hold_idempotency_key,
            hold_reason: hold_reason,
            held_at: held_at
          }
        end

        def expiration_evidence
          { expired_at: expired_at }
        end

        def require_nonblank_hold_reason!
          return unless hold_reason.respond_to?(:strip) && hold_reason.strip.empty?

          raise ArgumentError, "Hold evidence is incomplete: hold_reason"
        end

        def require_evidence!(kind, evidence)
          missing = evidence.select do |_field, value|
            value.nil? || value == ""
          end.keys
          return if missing.empty?

          raise ArgumentError, "#{kind.to_s.capitalize} evidence is incomplete: #{missing.join(', ')}"
        end

        def reject_evidence!(kind, evidence)
          contradictory = evidence.reject { |_field, value| value.nil? }.keys
          return if contradictory.empty?

          raise ArgumentError, "#{kind.to_s.capitalize} evidence contradicts #{status} status: #{contradictory.join(', ')}"
        end

        def ensure_version!(expected_version, include_current_version:)
          return if lock_version == expected_version

          details = include_current_version ? { current_version: lock_version } : {}
          raise Errors::RuleViolation.new(
            "concurrent_modification",
            "Order version does not match",
            details: details
          )
        end
      end
    end
  end
end
