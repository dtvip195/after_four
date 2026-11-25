require "rails_helper"

RSpec.describe Payments::Infrastructure::Persistence::PaymentAttemptRecord do
  TERMINAL_EVIDENCE_CHANGES = {
    status: "failed",
    requested_amount: 81_000,
    confirmed_amount: 79_000,
    method: "bank_transfer",
    currency_code: "USD",
    confirmed_by_actor_id: SecureRandom.uuid,
    confirmed_at: Time.utc(2026, 11, 14, 13, 0, 0),
    failure_code: "rewritten",
    idempotency_key: "rewritten-attempt-key"
  }.freeze

  it "allows a non-terminal attempt to transition to a terminal state" do
    attempt = create_attempt(status: "pending")

    expect do
      attempt.update!(
        status: "succeeded",
        confirmed_amount: attempt.requested_amount,
        confirmed_by_actor_id: SecureRandom.uuid,
        confirmed_at: Time.utc(2026, 11, 14, 12, 0, 0)
      )
    end.not_to raise_error

    expect(attempt.reload).to have_attributes(status: "succeeded", confirmed_amount: 80_000)
  end

  it "rejects ordinary Rails changes to terminal financial evidence" do
    attempt = create_attempt(status: "succeeded")

    TERMINAL_EVIDENCE_CHANGES.each do |attribute, changed_value|
      attempt.reload

      expect(attempt.update(attribute => changed_value)).to be(false),
        "expected terminal #{attribute} to be immutable"
      expect(attempt.errors[:base]).to include("Terminal payment attempt evidence is immutable")
    end
  end

  it "treats succeeded, failed, and cancelled as terminal states" do
    described_class::TERMINAL_STATUSES.each do |terminal_status|
      attempt = create_attempt(status: terminal_status)

      expect(attempt.update(requested_amount: 81_000)).to be(false)
      expect(attempt.errors[:base]).to include("Terminal payment attempt evidence is immutable")
    end
  end

  it "rejects callback-bypassing ActiveRecord updates to terminal evidence" do
    attempt = create_attempt(status: "succeeded")
    original_evidence = attempt.attributes.slice(*TERMINAL_EVIDENCE_CHANGES.keys.map(&:to_s))

    TERMINAL_EVIDENCE_CHANGES.each do |attribute, changed_value|
      expect do
        Payments::Infrastructure::Persistence::PaymentAttemptRecord.transaction(requires_new: true) do
          attempt.update_columns(attribute => changed_value)
        end
      end.to raise_error(ActiveRecord::StatementInvalid, /terminal payment attempt evidence is immutable/i)

      expect(attempt.reload.attributes.slice(*original_evidence.keys)).to eq(original_evidence)
    end
  end

  it "rejects direct SQL updates to terminal evidence" do
    attempt = create_attempt(status: "succeeded")
    connection = ActiveRecord::Base.connection

    expect do
      Payments::Infrastructure::Persistence::PaymentAttemptRecord.transaction(requires_new: true) do
        connection.execute(<<~SQL)
          UPDATE payment_attempts
          SET method = 'bank_transfer'
          WHERE id = #{connection.quote(attempt.id)}
        SQL
      end
    end.to raise_error(ActiveRecord::StatementInvalid, /terminal payment attempt evidence is immutable/i)

    expect(attempt.reload).to have_attributes(method: "cash")
  end

  it "rolls back other transaction changes when PostgreSQL rejects terminal evidence mutation" do
    attempt = create_attempt(status: "succeeded")
    payment = attempt.payment_record

    expect do
      Payments::Infrastructure::Persistence::PaymentAttemptRecord.transaction(requires_new: true) do
        payment.update!(updated_at: Time.utc(2026, 11, 14, 14, 0, 0))
        attempt.update_columns(confirmed_amount: 79_000)
      end
    end.to raise_error(ActiveRecord::StatementInvalid, /terminal payment attempt evidence is immutable/i)

    expect(payment.reload.updated_at).not_to eq(Time.utc(2026, 11, 14, 14, 0, 0))
    expect(attempt.reload).to have_attributes(confirmed_amount: 80_000)
  end

  def create_attempt(status:)
    actor_id = SecureRandom.uuid
    order = create_order_draft_record(
      actor_id: actor_id,
      branch_id: SecureRandom.uuid,
      channel: "takeaway",
      total_amount: 80_000,
      currency_code: "VND",
      idempotency_key: "create-attempt-#{SecureRandom.uuid}",
      now: Time.utc(2026, 11, 14, 11, 0, 0)
    )
    payment_for(order).payment_attempt_records.create!(
      method: "cash",
      status: status,
      requested_amount: 80_000,
      confirmed_amount: status == "succeeded" ? 80_000 : nil,
      currency_code: "VND",
      idempotency_key: "attempt-#{SecureRandom.uuid}",
      confirmed_by_actor_id: status == "succeeded" ? actor_id : nil,
      confirmed_at: status == "succeeded" ? Time.utc(2026, 11, 14, 11, 1, 0) : nil
    )
  end
end
