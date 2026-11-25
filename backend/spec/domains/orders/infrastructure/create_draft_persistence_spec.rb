require "rails_helper"

RSpec.describe "CreateDraft PostgreSQL persistence" do
  it "retains the database uniqueness backstop for a Branch creation key" do
    result = OrderingComposition.create_draft_use_case.call(
      actor_id: SecureRandom.uuid,
      branch_id: SecureRandom.uuid,
      channel: "takeaway",
      total_amount: 125_000,
      currency_code: "VND",
      idempotency_key: "order-database-uniqueness",
      now: Time.utc(2026, 11, 14, 10, 0, 0)
    )
    record = Orders::Infrastructure::Persistence::OrderRecord.find(result.order.id.to_s)
    duplicate_attributes = record.attributes.slice(
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
      Orders::Infrastructure::Persistence::OrderRecord.transaction(requires_new: true) do
        Orders::Infrastructure::Persistence::OrderRecord.create!(duplicate_attributes)
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
      Orders::Infrastructure::Persistence::OrderRecord.transaction(requires_new: true) do
        OrderingComposition.create_draft_use_case.call(
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

    expect(Orders::Infrastructure::Persistence::OrderRecord.where(branch_id: branch_id)).to be_empty
    expect(AuditEvent.where(branch_id: branch_id).count).to eq(1)
  end
end
