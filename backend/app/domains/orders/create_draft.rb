require "digest"

module Orders
  class CreateDraft
    Result = Data.define(:order, :payment, :replayed)

    def self.call(actor_id:, branch_id:, channel:, total_amount:, currency_code:, idempotency_key:, now: Time.current)
      new(
        actor_id: actor_id,
        branch_id: branch_id,
        channel: channel,
        total_amount: total_amount,
        currency_code: currency_code,
        idempotency_key: idempotency_key,
        now: now
      ).call
    end

    def initialize(actor_id:, branch_id:, channel:, total_amount:, currency_code:, idempotency_key:, now:)
      @actor_id = actor_id.to_s.downcase
      @branch_id = branch_id
      @channel = channel.to_s
      @total_amount = Integer(total_amount)
      @currency_code = currency_code.to_s.upcase
      @idempotency_key = idempotency_key
      @now = now
      @request_fingerprint = build_request_fingerprint
    end

    def call
      validate_context!

      existing = Order.find_by(branch_id: branch_id, creation_idempotency_key: idempotency_key)
      return replay(existing) if existing

      order = nil
      payment = nil

      ApplicationRecord.transaction do
        order = Order.create!(
          branch_id: branch_id,
          created_by_actor_id: actor_id,
          order_number: "AF-#{SecureRandom.hex(6).upcase}",
          channel: channel,
          status: "draft",
          total_amount: total_amount,
          currency_code: currency_code,
          creation_idempotency_key: idempotency_key,
          creation_request_fingerprint: request_fingerprint,
          created_at: now,
          updated_at: now
        )
        payment = Payment.create!(
          order: order,
          target_amount: total_amount,
          currency_code: currency_code,
          created_at: now,
          updated_at: now
        )
        AuditEvent.create!(
          branch_id: branch_id,
          actor_type: "user",
          actor_id: actor_id,
          event_type: "order.created",
          subject_type: "Order",
          subject_id: order.id,
          idempotency_key: "order.created:#{idempotency_key}",
          metadata: { channel: channel },
          occurred_at: now,
          created_at: now
        )
      end

      Result.new(order: order, payment: payment, replayed: false)
    rescue ActiveRecord::RecordNotUnique => error
      raise unless creation_key_violation?(error)

      replay(Order.find_by!(branch_id: branch_id, creation_idempotency_key: idempotency_key))
    end

    private

    attr_reader :actor_id, :branch_id, :channel, :total_amount, :currency_code,
      :idempotency_key, :now, :request_fingerprint

    def build_request_fingerprint
      canonical_input = [
        "after_four.order.create.v1",
        actor_id,
        channel,
        total_amount.to_s,
        currency_code
      ].join("\n")

      Digest::SHA256.hexdigest(canonical_input)
    end

    def replay(order)
      unless order.creation_request_fingerprint == request_fingerprint
        raise DomainError.new(
          "idempotency_conflict",
          "Idempotency key was already used with different draft creation input"
        )
      end

      Result.new(order: order, payment: order.payment, replayed: true)
    end

    def creation_key_violation?(error)
      result = error.cause&.result
      return false unless result

      result.error_field(PG::Result::PG_DIAG_CONSTRAINT_NAME) ==
        "index_orders_on_branch_and_creation_key"
    end

    def validate_context!
      TrustedActor.require_id!(actor_id)
      unless branch_id.to_s.match?(TrustedActor::UUID_FORMAT)
        raise DomainError.new("branch_context_required", "A valid Branch context is required")
      end
      if idempotency_key.to_s.strip.empty?
        raise DomainError.new("idempotency_key_required", "Idempotency key is required")
      end
    end
  end
end
