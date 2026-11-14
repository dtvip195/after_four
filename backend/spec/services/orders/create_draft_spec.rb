require "rails_helper"

RSpec.describe Orders::CreateDraft do
  describe ".call" do
    it "persists a draft order and its unpaid exact-balance payment" do
      result = described_class.call(
        actor_id: SecureRandom.uuid,
        branch_id: SecureRandom.uuid,
        channel: "takeaway",
        total_amount: 125_000,
        currency_code: "VND",
        idempotency_key: "order-create-1",
        now: Time.utc(2026, 11, 14, 10, 0, 0)
      )

      expect(result.order).to be_persisted
      expect(result.order).to have_attributes(
        status: "draft",
        channel: "takeaway",
        total_amount: 125_000,
        currency_code: "VND"
      )
      expect(result.order.creation_request_fingerprint).to match(/\A[0-9a-f]{64}\z/)
      expect(result.payment).to have_attributes(
        funding_status: "unpaid",
        attempt_activity: "idle",
        target_amount: 125_000,
        successful_amount: 0
      )
    end

    it "rejects the same Branch key when the channel differs" do
      actor_id = SecureRandom.uuid
      branch_id = SecureRandom.uuid
      attributes = {
        actor_id: actor_id,
        branch_id: branch_id,
        channel: "takeaway",
        total_amount: 125_000,
        currency_code: "VND",
        idempotency_key: "order-channel-conflict",
        now: Time.utc(2026, 11, 14, 10, 0, 0)
      }
      original = described_class.call(**attributes)

      expect do
        described_class.call(**attributes.merge(channel: "dine_in"))
      end.to raise_error(DomainError) { |error| expect(error.code).to eq("idempotency_conflict") }

      expect(original.order.reload).to have_attributes(channel: "takeaway")
      expect(Order.where(branch_id: branch_id, creation_idempotency_key: "order-channel-conflict").count).to eq(1)
    end

    it "replays the original complete result for the same normalized payload" do
      actor_id = SecureRandom.uuid
      branch_id = SecureRandom.uuid
      attributes = {
        actor_id: actor_id,
        branch_id: branch_id,
        channel: "takeaway",
        total_amount: 125_000,
        currency_code: "vnd",
        idempotency_key: "order-replay",
        now: Time.utc(2026, 11, 14, 10, 0, 0)
      }

      original = described_class.call(**attributes)
      replay = described_class.call(
        **attributes.merge(
          actor_id: actor_id.upcase,
          total_amount: "125000",
          currency_code: "VND",
          now: Time.utc(2026, 11, 14, 10, 5, 0)
        )
      )

      expect(replay.replayed).to be(true)
      expect(replay.order.id).to eq(original.order.id)
      expect(replay.payment.id).to eq(original.payment.id)
      expect(Order.where(branch_id: branch_id, creation_idempotency_key: "order-replay").count).to eq(1)
      expect(Payment.where(order_id: original.order.id).count).to eq(1)
      expect(AuditEvent.where(branch_id: branch_id, event_type: "order.created").count).to eq(1)
    end

    it "rejects amount, currency, and trusted actor changes for the same Branch key" do
      actor_id = SecureRandom.uuid
      branch_id = SecureRandom.uuid
      attributes = {
        actor_id: actor_id,
        branch_id: branch_id,
        channel: "takeaway",
        total_amount: 125_000,
        currency_code: "VND",
        idempotency_key: "order-payload-conflict",
        now: Time.utc(2026, 11, 14, 10, 0, 0)
      }
      original = described_class.call(**attributes)

      [
        { total_amount: 126_000 },
        { currency_code: "USD" },
        { actor_id: SecureRandom.uuid }
      ].each do |changed_input|
        expect do
          described_class.call(**attributes.merge(changed_input))
        end.to raise_error(DomainError) { |error| expect(error.code).to eq("idempotency_conflict") }
      end

      expect(original.order.reload).to have_attributes(
        total_amount: 125_000,
        currency_code: "VND",
        created_by_actor_id: actor_id
      )
      expect(Order.where(branch_id: branch_id, creation_idempotency_key: "order-payload-conflict").count).to eq(1)
    end

    it "allows unrelated creation keys within the same Branch" do
      actor_id = SecureRandom.uuid
      branch_id = SecureRandom.uuid
      common = {
        actor_id: actor_id,
        branch_id: branch_id,
        channel: "takeaway",
        total_amount: 125_000,
        currency_code: "VND",
        now: Time.utc(2026, 11, 14, 10, 0, 0)
      }

      first = described_class.call(**common, idempotency_key: "order-key-one")
      second = described_class.call(**common, idempotency_key: "order-key-two")

      expect(first.order.id).not_to eq(second.order.id)
      expect(Order.where(branch_id: branch_id).count).to eq(2)
    end

    it "scopes the same creation key independently by Branch" do
      actor_id = SecureRandom.uuid
      common = {
        actor_id: actor_id,
        channel: "takeaway",
        total_amount: 125_000,
        currency_code: "VND",
        idempotency_key: "branch-scoped-order-key",
        now: Time.utc(2026, 11, 14, 10, 0, 0)
      }

      first = described_class.call(**common, branch_id: SecureRandom.uuid)
      second = described_class.call(**common, branch_id: SecureRandom.uuid)

      expect(first.order.id).not_to eq(second.order.id)
      expect(first.replayed).to be(false)
      expect(second.replayed).to be(false)
    end

    it "retains the database uniqueness backstop for a Branch creation key" do
      result = described_class.call(
        actor_id: SecureRandom.uuid,
        branch_id: SecureRandom.uuid,
        channel: "takeaway",
        total_amount: 125_000,
        currency_code: "VND",
        idempotency_key: "order-database-uniqueness",
        now: Time.utc(2026, 11, 14, 10, 0, 0)
      )
      duplicate_attributes = result.order.attributes.slice(
        "branch_id",
        "created_by_actor_id",
        "channel",
        "status",
        "total_amount",
        "currency_code",
        "creation_idempotency_key",
        "creation_request_fingerprint"
      ).merge("order_number" => "AF-DUPLICATE")

      expect do
        Order.transaction(requires_new: true) do
          Order.create!(duplicate_attributes)
        end
      end.to raise_error(ActiveRecord::RecordNotUnique)
    end

    it "does not swallow an unrelated unique-constraint failure" do
      branch_id = SecureRandom.uuid
      key = "order-unrelated-constraint"
      AuditEvent.create!(
        branch_id: branch_id,
        actor_type: "system",
        event_type: "test.reserved_audit_identity",
        subject_type: "Order",
        subject_id: SecureRandom.uuid,
        idempotency_key: "order.created:#{key}",
        occurred_at: Time.utc(2026, 11, 14, 9, 0, 0)
      )

      expect do
        Order.transaction(requires_new: true) do
          described_class.call(
            actor_id: SecureRandom.uuid,
            branch_id: branch_id,
            channel: "takeaway",
            total_amount: 125_000,
            currency_code: "VND",
            idempotency_key: key,
            now: Time.utc(2026, 11, 14, 10, 0, 0)
          )
        end
      end.to raise_error(ActiveRecord::RecordNotUnique)

      expect(Order.where(branch_id: branch_id)).to be_empty
      expect(AuditEvent.where(branch_id: branch_id).count).to eq(1)
    end
  end
end
