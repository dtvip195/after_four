require "rails_helper"

RSpec.describe "cash payment confirmation" do
  it "records verified cash settlement and creates one pending preparation dispatch" do
    actor_id = SecureRandom.uuid
    now = Time.utc(2026, 11, 14, 10, 0, 0)
    order = create_order_draft_record(
      actor_id: actor_id,
      branch_id: SecureRandom.uuid,
      channel: "takeaway",
      total_amount: 120_000,
      currency_code: "VND",
      idempotency_key: "create-cash-spec",
      now: now
    )
    confirm_order_record(
      order_id: order.id,
      actor_id: actor_id,
      idempotency_key: "confirm-cash-spec",
      expected_version: order.lock_version,
      now: now
    )

    result = PaymentComposition.confirm_cash(
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
    order = create_order_draft_record(
      actor_id: actor_id,
      branch_id: SecureRandom.uuid,
      channel: "takeaway",
      total_amount: 120_000,
      currency_code: "VND",
      idempotency_key: "create-mismatch-spec",
      now: now
    )
    confirm_order_record(
      order_id: order.id,
      actor_id: actor_id,
      idempotency_key: "confirm-mismatch-spec",
      expected_version: order.lock_version,
      now: now
    )

    expect do
      PaymentComposition.confirm_cash(
        order_id: order.id,
        actor_id: actor_id,
        amount: 110_000,
        currency_code: "VND",
        idempotency_key: "cash-mismatch-1",
        clock: -> { now + 1.minute }
      )
    end.to raise_error(DomainError) { |error| expect(error.code).to eq("payment_amount_invalid") }

    expect(payment_for(order).reload).to have_attributes(funding_status: "unpaid", successful_amount: 0)
    expect(payment_for(order).payment_attempt_records.last).to have_attributes(
      status: "failed",
      failure_code: "amount_mismatch",
      requested_amount: 110_000
    )
    expect(preparation_dispatch_for(order)).to be_nil
  end

  it "records and rejects an overpayment without settling or dispatching" do
    actor_id, now, order = create_confirmed_order("overpayment")

    expect do
      PaymentComposition.confirm_cash(
        order_id: order.id,
        actor_id: actor_id,
        amount: order.total_amount + 1,
        currency_code: order.currency_code,
        idempotency_key: "cash-overpayment",
        clock: -> { now + 1.minute }
      )
    end.to raise_error(DomainError) { |error|
      expect(error).to have_attributes(
        code: "payment_amount_invalid",
        details: { expected_amount: order.total_amount, currency_code: "VND" }
      )
    }

    expect(payment_for(order).reload).to have_attributes(funding_status: "unpaid", successful_amount: 0)
    expect(payment_for(order).payment_attempt_records.last).to have_attributes(
      status: "failed",
      failure_code: "amount_mismatch",
      requested_amount: order.total_amount + 1
    )
    expect(preparation_dispatch_for(order)).to be_nil
  end

  it "records and rejects a currency mismatch without settling or dispatching" do
    actor_id, now, order = create_confirmed_order("currency-mismatch")

    expect do
      PaymentComposition.confirm_cash(
        order_id: order.id,
        actor_id: actor_id,
        amount: order.total_amount,
        currency_code: "USD",
        idempotency_key: "cash-currency-mismatch",
        clock: -> { now + 1.minute }
      )
    end.to raise_error(DomainError) { |error|
      expect(error).to have_attributes(
        code: "payment_amount_invalid",
        details: { expected_amount: order.total_amount, currency_code: "VND" }
      )
    }

    expect(payment_for(order).reload).to have_attributes(funding_status: "unpaid", successful_amount: 0)
    expect(payment_for(order).payment_attempt_records.last).to have_attributes(
      status: "failed",
      failure_code: "amount_mismatch",
      currency_code: "USD"
    )
    expect(preparation_dispatch_for(order)).to be_nil
  end

  it "replays a recorded amount mismatch as the same domain error" do
    actor_id = SecureRandom.uuid
    now = Time.utc(2026, 11, 14, 12, 0, 0)
    order = create_order_draft_record(
      actor_id: actor_id,
      branch_id: SecureRandom.uuid,
      channel: "takeaway",
      total_amount: 85_000,
      currency_code: "VND",
      idempotency_key: "create-mismatch-replay-spec",
      now: now
    )
    confirm_order_record(
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
      expect { PaymentComposition.confirm_cash(**attributes) }
        .to raise_error(DomainError) { |error| expect(error.code).to eq("payment_amount_invalid") }
    end

    expect(payment_for(order).payment_attempt_records.where(idempotency_key: "cash-mismatch-replay").count).to eq(1)
  end

  it "replays the same confirmation without duplicating payment or dispatch" do
    actor_id = SecureRandom.uuid
    now = Time.utc(2026, 11, 14, 16, 0, 0)
    order = create_order_draft_record(
      actor_id: actor_id,
      branch_id: SecureRandom.uuid,
      channel: "takeaway",
      total_amount: 50_000,
      currency_code: "VND",
      idempotency_key: "create-replay-spec",
      now: now
    )
    confirm_order_record(
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

    first = PaymentComposition.confirm_cash(**attributes)
    replay = PaymentComposition.confirm_cash(**attributes)

    expect(replay.replayed).to be(true)
    expect(replay.payment_attempt.id).to eq(first.payment_attempt.id)
    expect(replay.preparation_dispatch.id).to eq(first.preparation_dispatch.id)
    expect(payment_for(order).payment_attempt_records.count).to eq(1)
    expect(PreparationDispatch.where(order_id: order.id).count).to eq(1)
    expect(OutboxEvent.where(aggregate_id: first.preparation_dispatch.id).count).to eq(1)
  end

  it "rejects same-key replay when method, amount, or currency differs" do
    actor_id, now, order = create_confirmed_order("semantic-replay-conflict")
    attributes = {
      order_id: order.id,
      actor_id: actor_id,
      amount: order.total_amount,
      currency_code: order.currency_code,
      idempotency_key: "semantic-replay-conflict",
      clock: -> { now + 1.minute }
    }
    original = PaymentComposition.confirm_cash(**attributes)

    conflicting_calls = [
      -> { PaymentComposition.confirm_bank_transfer(**attributes) },
      -> { PaymentComposition.confirm_cash(**attributes.merge(amount: order.total_amount - 1)) },
      -> { PaymentComposition.confirm_cash(**attributes.merge(currency_code: "USD")) }
    ]

    conflicting_calls.each do |call|
      expect(&call).to raise_error(DomainError) { |error|
        expect(error).to have_attributes(code: "idempotency_conflict", details: {})
      }
    end

    expect(payment_for(order).payment_attempt_records.count).to eq(1)
    expect(payment_for(order).payment_attempt_records.first.id).to eq(original.payment_attempt.id.to_s)
    expect(PreparationDispatch.where(order_id: order.id).count).to eq(1)
    expect(OutboxEvent.where(aggregate_id: original.preparation_dispatch.id).count).to eq(1)
  end

  it "fails closed while a prior Payment result requires reconciliation" do
    actor_id, now, order = create_confirmed_order("reconciliation-required")
    payment_for(order).update!(attempt_activity: "reconciliation_required")

    expect do
      PaymentComposition.confirm_cash(
        order_id: order.id,
        actor_id: actor_id,
        amount: order.total_amount,
        currency_code: order.currency_code,
        idempotency_key: "confirmation-while-reconciliation-required",
        clock: -> { now + 1.minute }
      )
    end.to raise_error(DomainError) { |error|
      expect(error).to have_attributes(code: "payment_result_unknown", details: {})
    }

    expect(payment_for(order).reload).to have_attributes(
      funding_status: "unpaid",
      attempt_activity: "reconciliation_required",
      successful_amount: 0
    )
    expect(payment_for(order).payment_attempt_records).to be_empty
    expect(preparation_dispatch_for(order)).to be_nil
  end

  it "rejects confirmation without a trusted actor context" do
    expect do
      PaymentComposition.confirm_cash(
        order_id: SecureRandom.uuid,
        actor_id: nil,
        amount: 50_000,
        currency_code: "VND",
        idempotency_key: "missing-actor",
        clock: -> { Time.utc(2026, 11, 14, 16, 0, 0) }
      )
    end.to raise_error(DomainError) { |error| expect(error.code).to eq("trusted_actor_required") }
  end

  def create_confirmed_order(suffix)
    actor_id = SecureRandom.uuid
    now = Time.utc(2026, 11, 14, 15, 0, 0)
    order = create_order_draft_record(
      actor_id: actor_id,
      branch_id: SecureRandom.uuid,
      channel: "takeaway",
      total_amount: 80_000,
      currency_code: "VND",
      idempotency_key: "create-#{suffix}",
      now: now
    )
    confirm_order_record(
      order_id: order.id,
      actor_id: actor_id,
      idempotency_key: "confirm-#{suffix}",
      expected_version: order.lock_version,
      now: now
    )
    [ actor_id, now, order.reload ]
  end
end
