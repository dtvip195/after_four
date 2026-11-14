require "rails_helper"

RSpec.describe AuditEvent do
  it "rejects updates and destruction through the application model" do
    event = described_class.create!(
      branch_id: SecureRandom.uuid,
      actor_type: "system",
      event_type: "test.recorded",
      subject_type: "Order",
      subject_id: SecureRandom.uuid,
      idempotency_key: "audit-append-only-#{SecureRandom.uuid}",
      occurred_at: Time.current
    )

    expect(event.update(event_type: "test.rewritten")).to be(false)
    expect(event.errors[:base]).to include("Audit events are append-only")
    expect(event.destroy).to be(false)
    expect(described_class.find(event.id).event_type).to eq("test.recorded")
  end
end
