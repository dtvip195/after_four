require "rails_helper"

RSpec.describe Orders::Confirm do
  it "confirms a draft and opens the five-minute payment window" do
    actor_id = SecureRandom.uuid
    now = Time.utc(2026, 11, 14, 10, 0, 0)
    order = Orders::CreateDraft.call(
      actor_id: actor_id,
      branch_id: SecureRandom.uuid,
      channel: "dine_in",
      total_amount: 80_000,
      currency_code: "VND",
      idempotency_key: "create-confirm-spec",
      now: now
    ).order

    result = described_class.call(
      order_id: order.id,
      actor_id: actor_id,
      idempotency_key: "confirm-spec",
      expected_version: order.lock_version,
      now: now
    )

    expect(result.order).to have_attributes(
      status: "confirmed",
      confirmed_at: now,
      payment_expires_at: now + 5.minutes
    )
  end

  it "uses the validated configured payment window exactly" do
    previous_window = Rails.configuration.x.orders.payment_window_seconds
    actor_id = SecureRandom.uuid
    now = Time.utc(2026, 11, 14, 10, 0, 0)
    order = Orders::CreateDraft.call(
      actor_id: actor_id,
      branch_id: SecureRandom.uuid,
      channel: "takeaway",
      total_amount: 80_000,
      currency_code: "VND",
      idempotency_key: "create-custom-window-spec",
      now: now
    ).order
    Rails.configuration.x.orders.payment_window_seconds = 900

    result = described_class.call(
      order_id: order.id,
      actor_id: actor_id,
      idempotency_key: "confirm-custom-window-spec",
      expected_version: order.lock_version,
      now: now
    )

    expect(result.order.payment_expires_at).to eq(now + 15.minutes)
  ensure
    Rails.configuration.x.orders.payment_window_seconds = previous_window
  end

  it "rejects a stale Order version with the current version in the error details" do
    order, actor_id, now = create_draft("stale-version")

    expect do
      described_class.call(
        order_id: order.id,
        actor_id: actor_id,
        idempotency_key: "confirm-stale-version",
        expected_version: order.lock_version + 1,
        now: now
      )
    end.to raise_error(DomainError) { |error|
      expect(error).to have_attributes(
        code: "concurrent_modification",
        details: { current_version: order.lock_version }
      )
    }

    expect(order.reload).to have_attributes(status: "draft", confirmed_at: nil, payment_expires_at: nil)
  end

  it "replays the original confirmation before evaluating a stale expected version" do
    order, actor_id, now = create_draft("confirmation-replay")
    original_version = order.lock_version
    first = described_class.call(
      order_id: order.id,
      actor_id: actor_id,
      idempotency_key: "confirm-replay",
      expected_version: original_version,
      now: now
    )

    replay = described_class.call(
      order_id: order.id,
      actor_id: actor_id,
      idempotency_key: "confirm-replay",
      expected_version: original_version,
      now: now + 1.minute
    )

    expect(replay).to have_attributes(replayed: true)
    expect(replay.order.id).to eq(first.order.id)
    expect(replay.order).to have_attributes(confirmed_at: now, payment_expires_at: now + 5.minutes)
    expect(AuditEvent.where(event_type: "order.confirmed", subject_id: order.id).count).to eq(1)
  end

  it "rejects a new confirmation command for an already Confirmed Order" do
    order, actor_id, now = create_draft("already-confirmed")
    confirm(order, actor_id, now, "first-confirmation")

    expect_invalid_transition(order, actor_id, now + 1.minute, "second-confirmation")
  end

  it "rejects confirmation of a Held Order" do
    order, actor_id, now = create_draft("held")
    confirm(order, actor_id, now, "confirm-before-hold")
    Orders::Hold.call(
      order_id: order.id,
      actor_id: actor_id,
      reason: "Characterization hold",
      idempotency_key: "hold-before-confirmation-retry",
      expected_version: order.reload.lock_version,
      now: now + 1.minute
    )

    expect_invalid_transition(order.reload, actor_id, now + 2.minutes, "confirm-held")
  end

  it "rejects confirmation of an Expired Order" do
    order, actor_id, now = create_draft("expired")
    confirm(order, actor_id, now, "confirm-before-expiry")
    Orders::ExpirePending.call(now: order.reload.payment_expires_at)

    expect_invalid_transition(order.reload, actor_id, now + 6.minutes, "confirm-expired")
  end

  it "preserves whitespace-only idempotency keys accepted by the legacy command" do
    order, actor_id, now = create_draft("whitespace-key")

    result = described_class.call(
      order_id: order.id,
      actor_id: actor_id,
      idempotency_key: " ",
      expected_version: order.lock_version,
      now: now
    )

    expect(result.order).to have_attributes(status: "confirmed", confirmation_idempotency_key: " ")
  end

  it "preserves rejection of an empty idempotency key" do
    order, actor_id, now = create_draft("empty-key")

    expect do
      described_class.call(
        order_id: order.id,
        actor_id: actor_id,
        idempotency_key: "",
        expected_version: order.lock_version,
        now: now
      )
    end.to raise_error(DomainError) { |error|
      expect(error).to have_attributes(code: "idempotency_key_required", details: {})
    }
  end

  def create_draft(suffix)
    actor_id = SecureRandom.uuid
    now = Time.utc(2026, 11, 14, 10, 0, 0)
    order = Orders::CreateDraft.call(
      actor_id: actor_id,
      branch_id: SecureRandom.uuid,
      channel: "takeaway",
      total_amount: 80_000,
      currency_code: "VND",
      idempotency_key: "create-#{suffix}",
      now: now
    ).order
    [ order, actor_id, now ]
  end

  def confirm(order, actor_id, now, key)
    described_class.call(
      order_id: order.id,
      actor_id: actor_id,
      idempotency_key: key,
      expected_version: order.lock_version,
      now: now
    )
    order.reload
  end

  def expect_invalid_transition(order, actor_id, now, key)
    expect do
      described_class.call(
        order_id: order.id,
        actor_id: actor_id,
        idempotency_key: key,
        expected_version: order.lock_version,
        now: now
      )
    end.to raise_error(DomainError) { |error|
      expect(error).to have_attributes(code: "invalid_state_transition", details: {})
    }
  end
end
