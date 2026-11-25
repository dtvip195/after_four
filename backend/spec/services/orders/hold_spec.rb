require "rails_helper"

RSpec.describe Orders::Hold do
  it "places a confirmed unpaid order on an attributed safety hold" do
    actor_id = SecureRandom.uuid
    now = Time.utc(2026, 11, 14, 13, 0, 0)
    order = Orders::CreateDraft.call(
      actor_id: actor_id,
      branch_id: SecureRandom.uuid,
      channel: "takeaway",
      total_amount: 75_000,
      currency_code: "VND",
      idempotency_key: "create-hold-spec",
      now: now
    ).order
    Orders::Confirm.call(
      order_id: order.id,
      actor_id: actor_id,
      idempotency_key: "confirm-hold-spec",
      expected_version: order.lock_version,
      now: now
    )

    result = described_class.call(
      order_id: order.id,
      actor_id: actor_id,
      reason: "Bank notification requires review",
      idempotency_key: "hold-spec",
      expected_version: order.reload.lock_version,
      now: now + 1.minute
    )

    expect(result.order).to have_attributes(
      status: "held",
      hold_reason: "Bank notification requires review",
      held_at: now + 1.minute
    )
  end

  it "rejects a stale Order version without changing the confirmed Order" do
    actor_id, now, order = create_confirmed_order("stale-hold")
    current_version = order.lock_version

    expect do
      described_class.call(
        order_id: order.id,
        actor_id: actor_id,
        reason: "Stale request",
        idempotency_key: "stale-hold",
        expected_version: current_version - 1,
        now: now + 1.minute
      )
    end.to raise_error(DomainError) { |error|
      expect(error).to have_attributes(code: "concurrent_modification", details: {})
    }

    expect(order.reload).to have_attributes(status: "confirmed", held_at: nil, hold_reason: nil)
  end

  it "replays the original hold without duplicating its audit evidence" do
    actor_id, now, order = create_confirmed_order("hold-replay")
    original_version = order.lock_version
    first = described_class.call(
      order_id: order.id,
      actor_id: actor_id,
      reason: "Original reason",
      idempotency_key: "hold-replay",
      expected_version: original_version,
      now: now + 1.minute
    )

    replay = described_class.call(
      order_id: order.id,
      actor_id: actor_id,
      reason: "Original reason",
      idempotency_key: "hold-replay",
      expected_version: original_version,
      now: now + 2.minutes
    )

    expect(replay).to have_attributes(replayed: true)
    expect(replay.order.id).to eq(first.order.id)
    expect(replay.order).to have_attributes(hold_reason: "Original reason", held_at: now + 1.minute)
    expect(AuditEvent.where(event_type: "order.held", subject_id: order.id).count).to eq(1)
  end

  it "currently replays the original hold when the same key carries a conflicting reason" do
    actor_id, now, order = create_confirmed_order("hold-conflicting-replay")
    original_version = order.lock_version
    described_class.call(
      order_id: order.id,
      actor_id: actor_id,
      reason: "Original reason",
      idempotency_key: "hold-conflicting-replay",
      expected_version: original_version,
      now: now + 1.minute
    )

    replay = described_class.call(
      order_id: order.id,
      actor_id: actor_id,
      reason: "Conflicting reason",
      idempotency_key: "hold-conflicting-replay",
      expected_version: original_version,
      now: now + 2.minutes
    )

    expect(replay).to have_attributes(replayed: true)
    expect(replay.order).to have_attributes(hold_reason: "Original reason", held_at: now + 1.minute)
    expect(AuditEvent.where(event_type: "order.held", subject_id: order.id).count).to eq(1)
  end

  it "preserves whitespace-only idempotency keys accepted by the legacy command" do
    actor_id, now, order = create_confirmed_order("hold-whitespace-key")

    result = described_class.call(
      order_id: order.id,
      actor_id: actor_id,
      reason: "Review",
      idempotency_key: " ",
      expected_version: order.lock_version,
      now: now + 1.minute
    )

    expect(result.order).to have_attributes(status: "held", hold_idempotency_key: " ")
  end

  it "preserves rejection of an empty idempotency key" do
    actor_id, now, order = create_confirmed_order("hold-empty-key")

    expect do
      described_class.call(
        order_id: order.id,
        actor_id: actor_id,
        reason: "Review",
        idempotency_key: "",
        expected_version: order.lock_version,
        now: now + 1.minute
      )
    end.to raise_error(DomainError) { |error|
      expect(error).to have_attributes(code: "idempotency_key_required", details: {})
    }
  end

  def create_confirmed_order(suffix)
    actor_id = SecureRandom.uuid
    now = Time.utc(2026, 11, 14, 13, 0, 0)
    order = Orders::CreateDraft.call(
      actor_id: actor_id,
      branch_id: SecureRandom.uuid,
      channel: "takeaway",
      total_amount: 75_000,
      currency_code: "VND",
      idempotency_key: "create-#{suffix}",
      now: now
    ).order
    Orders::Confirm.call(
      order_id: order.id,
      actor_id: actor_id,
      idempotency_key: "confirm-#{suffix}",
      expected_version: order.lock_version,
      now: now
    )
    [ actor_id, now, order.reload ]
  end
end
