require "rails_helper"

RSpec.describe Payments::ConfirmCash do
  it "records verified cash settlement and creates one pending preparation dispatch" do
    actor_id = SecureRandom.uuid
    now = Time.utc(2026, 11, 14, 10, 0, 0)
    order = Orders::CreateDraft.call(
      actor_id: actor_id,
      branch_id: SecureRandom.uuid,
      channel: "takeaway",
      total_amount: 120_000,
      currency_code: "VND",
      idempotency_key: "create-cash-spec",
      now: now
    ).order
    Orders::Confirm.call(
      order_id: order.id,
      actor_id: actor_id,
      idempotency_key: "confirm-cash-spec",
      expected_version: order.lock_version,
      now: now
    )

    result = described_class.call(
      order_id: order.id,
      actor_id: actor_id,
      amount: 120_000,
      currency_code: "VND",
      idempotency_key: "cash-confirm-1",
      clock: -> { now + 1.minute }
    )

    expect(result.payment).to have_attributes(
      funding_status: "fully_paid",
      attempt_activity: "idle",
      successful_amount: 120_000,
      fully_settled_at: now + 1.minute
    )
    expect(result.payment_attempt).to have_attributes(method: "cash", status: "succeeded")
    expect(result.preparation_dispatch).to have_attributes(order_id: order.id, status: "pending")
    expect(result.review_case).to be_nil
    expect(OutboxEvent.where(event_type: "preparation.dispatch_requested", aggregate_id: result.preparation_dispatch.id).count).to eq(1)
  end

  it "records and rejects an amount mismatch without settling or dispatching" do
    actor_id = SecureRandom.uuid
    now = Time.utc(2026, 11, 14, 11, 0, 0)
    order = Orders::CreateDraft.call(
      actor_id: actor_id,
      branch_id: SecureRandom.uuid,
      channel: "takeaway",
      total_amount: 120_000,
      currency_code: "VND",
      idempotency_key: "create-mismatch-spec",
      now: now
    ).order
    Orders::Confirm.call(
      order_id: order.id,
      actor_id: actor_id,
      idempotency_key: "confirm-mismatch-spec",
      expected_version: order.lock_version,
      now: now
    )

    expect do
      described_class.call(
        order_id: order.id,
        actor_id: actor_id,
        amount: 110_000,
        currency_code: "VND",
        idempotency_key: "cash-mismatch-1",
        clock: -> { now + 1.minute }
      )
    end.to raise_error(DomainError) { |error| expect(error.code).to eq("payment_amount_invalid") }

    expect(order.payment.reload).to have_attributes(funding_status: "unpaid", successful_amount: 0)
    expect(order.payment.payment_attempts.last).to have_attributes(
      status: "failed",
      failure_code: "amount_mismatch",
      requested_amount: 110_000
    )
    expect(order.preparation_dispatch).to be_nil
  end

  it "replays a recorded amount mismatch as the same domain error" do
    actor_id = SecureRandom.uuid
    now = Time.utc(2026, 11, 14, 12, 0, 0)
    order = Orders::CreateDraft.call(
      actor_id: actor_id,
      branch_id: SecureRandom.uuid,
      channel: "takeaway",
      total_amount: 85_000,
      currency_code: "VND",
      idempotency_key: "create-mismatch-replay-spec",
      now: now
    ).order
    Orders::Confirm.call(
      order_id: order.id,
      actor_id: actor_id,
      idempotency_key: "confirm-mismatch-replay-spec",
      expected_version: order.lock_version,
      now: now
    )
    attributes = {
      order_id: order.id,
      actor_id: actor_id,
      amount: 80_000,
      currency_code: "VND",
      idempotency_key: "cash-mismatch-replay",
      clock: -> { now + 1.minute }
    }

    2.times do
      expect { described_class.call(**attributes) }
        .to raise_error(DomainError) { |error| expect(error.code).to eq("payment_amount_invalid") }
    end

    expect(order.payment.payment_attempts.where(idempotency_key: "cash-mismatch-replay").count).to eq(1)
  end

  it "replays the same confirmation without duplicating payment or dispatch" do
    actor_id = SecureRandom.uuid
    now = Time.utc(2026, 11, 14, 16, 0, 0)
    order = Orders::CreateDraft.call(
      actor_id: actor_id,
      branch_id: SecureRandom.uuid,
      channel: "takeaway",
      total_amount: 50_000,
      currency_code: "VND",
      idempotency_key: "create-replay-spec",
      now: now
    ).order
    Orders::Confirm.call(
      order_id: order.id,
      actor_id: actor_id,
      idempotency_key: "confirm-replay-spec",
      expected_version: order.lock_version,
      now: now
    )
    attributes = {
      order_id: order.id,
      actor_id: actor_id,
      amount: 50_000,
      currency_code: "VND",
      idempotency_key: "cash-replay-1",
      clock: -> { now + 1.minute }
    }

    first = described_class.call(**attributes)
    replay = described_class.call(**attributes)

    expect(replay.replayed).to be(true)
    expect(replay.payment_attempt.id).to eq(first.payment_attempt.id)
    expect(replay.preparation_dispatch.id).to eq(first.preparation_dispatch.id)
    expect(order.payment.payment_attempts.count).to eq(1)
    expect(PreparationDispatch.where(order_id: order.id).count).to eq(1)
    expect(OutboxEvent.where(aggregate_id: first.preparation_dispatch.id).count).to eq(1)
  end

  it "rejects confirmation without a trusted actor context" do
    expect do
      described_class.call(
        order_id: SecureRandom.uuid,
        actor_id: nil,
        amount: 50_000,
        currency_code: "VND",
        idempotency_key: "missing-actor",
        clock: -> { Time.utc(2026, 11, 14, 16, 0, 0) }
      )
    end.to raise_error(DomainError) { |error| expect(error.code).to eq("trusted_actor_required") }
  end
end
