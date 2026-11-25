require "spec_helper"
require_relative "../../../../app/domains/preparation/domain/errors/rule_violation"
require_relative "../../../../app/domains/preparation/domain/value_objects/dispatch_id"
require_relative "../../../../app/domains/preparation/domain/aggregates/dispatch"

RSpec.describe Preparation::Domain::Aggregates::Dispatch do
  let(:now) { Time.utc(2026, 11, 26, 9, 0, 0) }
  let(:attributes) do
    {
      id: SecureRandom.uuid,
      order_id: SecureRandom.uuid,
      payment_id: SecureRandom.uuid,
      branch_id: SecureRandom.uuid,
      idempotency_key: "payment-settlement:#{SecureRandom.uuid}",
      requested_at: now
    }
  end

  it "creates a retryable pending Dispatch with complete lifecycle evidence" do
    dispatch = described_class.pending(**attributes)

    expect(dispatch).to have_attributes(
      status: "pending",
      dispatched_at: nil,
      lock_version: 0,
      requested_at: now,
      created_at: now,
      updated_at: now
    )
    expect(dispatch.ensure_retryable!).to be(dispatch)
  end

  it "rejects malformed identifiers and missing required evidence" do
    expect { described_class.pending(**attributes.merge(order_id: "not-a-uuid")) }
      .to raise_error(ArgumentError, "Order identity must be a UUID")
    expect { described_class.pending(**attributes.merge(idempotency_key: "")) }
      .to raise_error(ArgumentError, "Preparation Dispatch idempotency key is required")
  end

  it "rejects contradictory reconstituted lifecycle evidence" do
    expect do
      reconstitute(status: "pending", dispatched_at: now)
    end.to raise_error(ArgumentError, "Pending Preparation Dispatch cannot have dispatched evidence")

    expect do
      reconstitute(status: "dispatched", dispatched_at: nil)
    end.to raise_error(ArgumentError, "Dispatched Preparation Dispatch requires dispatched evidence")
  end

  it "rejects retry after Dispatch completion" do
    dispatch = reconstitute(status: "dispatched", dispatched_at: now)

    expect { dispatch.ensure_retryable! }
      .to raise_error(Preparation::Domain::Errors::RuleViolation) { |error|
        expect(error.code).to eq("dispatch_already_completed")
      }
  end

  def reconstitute(status:, dispatched_at:)
    described_class.new(
      **attributes,
      status: status,
      dispatched_at: dispatched_at,
      lock_version: 1,
      created_at: now,
      updated_at: now
    )
  end
end
