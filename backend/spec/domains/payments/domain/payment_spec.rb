require "rails_helper"

RSpec.describe Payments::Domain::Aggregates::Payment do
  let(:payment_id) { SecureRandom.uuid }
  let(:order_id) { SecureRandom.uuid }
  let(:actor_id) { SecureRandom.uuid }
  let(:now) { Time.utc(2026, 11, 26, 9, 0, 0) }

  it "records exact-balance settlement as one immutable successful Attempt" do
    payment = build_payment

    outcome = payment.confirm(
      attempt_id: SecureRandom.uuid,
      method: "cash",
      amount: 80_000,
      currency_code: "VND",
      idempotency_key: "cash-1",
      actor_id: actor_id,
      now: now
    )

    expect(outcome).to have_attributes(replayed: false, amount_mismatch: false)
    expect(outcome.attempt).to have_attributes(
      method: "cash",
      status: "succeeded",
      requested_amount: 80_000,
      confirmed_amount: 80_000,
      confirmed_by_actor_id: actor_id,
      confirmed_at: now
    )
    expect(payment).to have_attributes(
      funding_status: "fully_paid",
      attempt_activity: "idle",
      successful_amount: 80_000,
      fully_settled_at: now
    )
  end

  it "records amount mismatch evidence without funding the Payment" do
    payment = build_payment

    outcome = payment.confirm(
      attempt_id: SecureRandom.uuid,
      method: "bank_transfer",
      amount: 79_000,
      currency_code: "VND",
      idempotency_key: "bank-mismatch",
      actor_id: actor_id,
      now: now
    )

    expect(outcome).to have_attributes(replayed: false, amount_mismatch: true)
    expect(outcome.attempt).to have_attributes(
      status: "failed",
      failure_code: "amount_mismatch",
      requested_amount: 79_000,
      confirmed_amount: 79_000
    )
    expect(payment).to have_attributes(funding_status: "unpaid", successful_amount: 0)
  end

  it "replays identical Attempt input and rejects conflicting reuse" do
    payment = build_payment
    attributes = {
      attempt_id: SecureRandom.uuid,
      method: "cash",
      amount: 80_000,
      currency_code: "VND",
      idempotency_key: "same-key",
      actor_id: actor_id,
      now: now
    }
    original = payment.confirm(**attributes)

    replay = payment.confirm(**attributes.merge(attempt_id: SecureRandom.uuid, now: now + 60))

    expect(replay).to have_attributes(replayed: true, attempt: original.attempt)
    expect do
      payment.confirm(**attributes.merge(attempt_id: SecureRandom.uuid, method: "bank_transfer"))
    end.to raise_error(Payments::Domain::Errors::RuleViolation) { |error|
      expect(error.code).to eq("idempotency_conflict")
    }
  end

  it "fails closed while prior result evidence requires reconciliation" do
    payment = build_payment(attempt_activity: "reconciliation_required")

    expect do
      payment.confirm(
        attempt_id: SecureRandom.uuid,
        method: "cash",
        amount: 80_000,
        currency_code: "VND",
        idempotency_key: "blocked",
        actor_id: actor_id,
        now: now
      )
    end.to raise_error(Payments::Domain::Errors::RuleViolation) { |error|
      expect(error.code).to eq("payment_result_unknown")
    }
  end

  it "does not permit terminal Attempt evidence to transition again" do
    attempt = Payments::Domain::Entities::PaymentAttempt.succeeded(
      id: SecureRandom.uuid,
      payment_id: payment_id,
      method: "cash",
      amount: 80_000,
      currency_code: "VND",
      idempotency_key: "terminal",
      actor_id: actor_id,
      now: now
    )

    expect do
      attempt.transition_to_terminal(
        status: "failed",
        confirmed_amount: 80_000,
        actor_id: actor_id,
        confirmed_at: now + 60,
        failure_code: "rewritten"
      )
    end.to raise_error(Payments::Domain::Errors::RuleViolation) { |error|
      expect(error.code).to eq("terminal_payment_attempt_immutable")
    }
  end

  it "permits a nonterminal Attempt to receive one valid terminal outcome" do
    attempt = Payments::Domain::Entities::PaymentAttempt.new(
      id: SecureRandom.uuid,
      payment_id: payment_id,
      method: "cash",
      status: "pending",
      requested_amount: 80_000,
      currency_code: "VND",
      idempotency_key: "pending",
      created_at: now,
      updated_at: now
    )

    result = attempt.transition_to_terminal(
      status: "succeeded",
      confirmed_amount: 80_000,
      actor_id: actor_id,
      confirmed_at: now + 60
    )

    expect(result).to equal(attempt)
    expect(attempt).to have_attributes(
      status: "succeeded",
      confirmed_amount: 80_000,
      confirmed_by_actor_id: actor_id,
      confirmed_at: now + 60,
      updated_at: now + 60
    )
  end

  it "keeps a nonterminal Attempt unchanged when terminal evidence is incomplete" do
    attempt = Payments::Domain::Entities::PaymentAttempt.new(
      id: SecureRandom.uuid,
      payment_id: payment_id,
      method: "cash",
      status: "pending",
      requested_amount: 80_000,
      currency_code: "VND",
      idempotency_key: "incomplete",
      created_at: now,
      updated_at: now
    )

    expect do
      attempt.transition_to_terminal(
        status: "succeeded",
        confirmed_amount: 79_000,
        actor_id: actor_id,
        confirmed_at: now + 60
      )
    end.to raise_error(ArgumentError, "Successful Payment Attempt evidence is incomplete")
    expect(attempt).to have_attributes(status: "pending", confirmed_amount: nil, confirmed_at: nil, updated_at: now)
  end

  def build_payment(attempt_activity: "idle")
    described_class.new(
      id: payment_id,
      order_id: order_id,
      funding_status: "unpaid",
      attempt_activity: attempt_activity,
      target: Payments::Domain::ValueObjects::Money.new(amount: 80_000, currency_code: "VND"),
      successful_amount: 0,
      refunded_amount: 0,
      fully_settled_at: nil,
      lock_version: 0,
      attempts: [],
      created_at: now - 60,
      updated_at: now - 60
    )
  end
end
