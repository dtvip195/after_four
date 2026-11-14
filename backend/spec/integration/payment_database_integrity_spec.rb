require "rails_helper"

RSpec.describe "payment database integrity" do
  it "rejects fully paid without successful Payment Attempt evidence" do
    payment = create_order.payment

    expect do
      Payment.transaction(requires_new: true) do
        payment.update_columns(funding_status: "fully_paid", successful_amount: 0)
        ActiveRecord::Base.connection.execute("SET CONSTRAINTS ALL IMMEDIATE")
      end
    end.to raise_error(ActiveRecord::StatementInvalid)

    expect(payment.reload).to have_attributes(funding_status: "unpaid", successful_amount: 0)
  end

  it "rejects fully paid when succeeded Payment Attempts are below the target" do
    payment = create_order(total_amount: 80_000).payment

    expect do
      Payment.transaction(requires_new: true) do
        insert_attempt(payment, requested_amount: 40_000, confirmed_amount: 40_000)
        payment.update_columns(funding_status: "fully_paid", successful_amount: 40_000)
        enforce_deferred_constraints!
      end
    end.to raise_error(ActiveRecord::StatementInvalid)

    expect(payment.reload).to have_attributes(funding_status: "unpaid", successful_amount: 0)
    expect(payment.payment_attempts).to be_empty
  end

  it "accepts exact fully paid funding with complete succeeded evidence" do
    payment = create_order(total_amount: 80_000).payment

    Payment.transaction(requires_new: true) do
      insert_attempt(payment)
      payment.update_columns(funding_status: "fully_paid", successful_amount: 80_000)
      enforce_deferred_constraints!
    end

    expect(payment.reload).to have_attributes(funding_status: "fully_paid", successful_amount: 80_000)
    expect(payment.payment_attempts.where(status: "succeeded").sum(:confirmed_amount)).to eq(80_000)
  ensure
    defer_constraints!
  end

  it "rejects succeeded Payment Attempts missing required evidence" do
    payment = create_order.payment
    missing_evidence = [
      { method: nil },
      { requested_amount: nil },
      { currency_code: nil },
      { idempotency_key: nil },
      { confirmed_by_actor_id: nil },
      { confirmed_at: nil },
      { confirmed_amount: nil },
      { failure_code: "provider_error" }
    ]

    missing_evidence.each do |override|
      expect do
        PaymentAttempt.transaction(requires_new: true) { insert_attempt(payment, **override) }
      end.to raise_error(ActiveRecord::StatementInvalid), "expected database rejection for #{override.keys.first}"
    end

    expect(payment.payment_attempts).to be_empty
  end

  it "rejects a succeeded Payment Attempt whose confirmed amount differs from requested amount" do
    payment = create_order.payment

    expect do
      PaymentAttempt.transaction(requires_new: true) do
        insert_attempt(payment, requested_amount: 80_000, confirmed_amount: 79_999)
      end
    end.to raise_error(ActiveRecord::StatementInvalid)
  end

  it "rejects a Preparation Dispatch that joins an Order to another Order's Payment" do
    order = create_order
    other_payment = create_order.payment

    expect do
      PreparationDispatch.insert_all!([ dispatch_attributes(order, payment: other_payment) ])
    end.to raise_error(ActiveRecord::StatementInvalid)
  end

  it "rejects a Preparation Dispatch whose Branch differs from its Order" do
    order = create_order

    expect do
      PreparationDispatch.insert_all!([
        dispatch_attributes(order, payment: order.payment, branch_id: SecureRandom.uuid)
      ])
    end.to raise_error(ActiveRecord::StatementInvalid)
  end

  it "rejects a Payment Review Case whose Order differs from its Payment" do
    settled_order = settle_order
    other_order = create_order

    expect do
      PaymentReviewCase.insert_all!([
        review_case_attributes(
          order: other_order,
          payment: settled_order.payment,
          attempt: settled_order.payment.payment_attempts.find_by!(status: "succeeded")
        )
      ])
    end.to raise_error(ActiveRecord::StatementInvalid)
  end

  it "rejects a Payment Review Case whose attempt belongs to another Payment" do
    settled_order = settle_order
    other_settled_order = settle_order

    expect do
      PaymentReviewCase.insert_all!([
        review_case_attributes(
          order: settled_order,
          payment: settled_order.payment,
          attempt: other_settled_order.payment.payment_attempts.find_by!(status: "succeeded")
        )
      ])
    end.to raise_error(ActiveRecord::StatementInvalid)
  end

  it "keeps the current valid settlement and dispatch path working" do
    order = settle_order

    expect(order.payment.reload).to have_attributes(funding_status: "fully_paid", successful_amount: 80_000)
    expect(order.preparation_dispatch).to have_attributes(
      payment_id: order.payment.id,
      branch_id: order.branch_id,
      status: "pending"
    )
  end

  def create_order(branch_id: SecureRandom.uuid, total_amount: 80_000)
    Orders::CreateDraft.call(
      actor_id: SecureRandom.uuid,
      branch_id: branch_id,
      channel: "takeaway",
      total_amount: total_amount,
      currency_code: "VND",
      idempotency_key: "database-integrity-#{SecureRandom.uuid}",
      now: Time.utc(2026, 11, 14, 10, 0, 0)
    ).order
  end

  def settle_order
    actor_id = SecureRandom.uuid
    now = Time.utc(2026, 11, 14, 10, 0, 0)
    order = create_order
    Orders::Confirm.call(
      order_id: order.id,
      actor_id: actor_id,
      idempotency_key: "database-integrity-confirm-#{SecureRandom.uuid}",
      expected_version: order.lock_version,
      now: now
    )
    Payments::ConfirmCash.call(
      order_id: order.id,
      actor_id: actor_id,
      amount: order.total_amount,
      currency_code: order.currency_code,
      idempotency_key: "database-integrity-payment-#{SecureRandom.uuid}",
      clock: -> { now + 1.minute }
    )
    order.reload
  end

  def insert_attempt(payment, **overrides)
    now = Time.utc(2026, 11, 14, 10, 1, 0)
    attributes = {
      id: SecureRandom.uuid,
      payment_id: payment.id,
      method: "cash",
      status: "succeeded",
      requested_amount: payment.target_amount,
      confirmed_amount: payment.target_amount,
      currency_code: payment.currency_code,
      idempotency_key: "database-integrity-attempt-#{SecureRandom.uuid}",
      confirmed_by_actor_id: SecureRandom.uuid,
      confirmed_at: now,
      failure_code: nil,
      created_at: now,
      updated_at: now
    }.merge(overrides)

    PaymentAttempt.insert_all!([ attributes ])
  end

  def dispatch_attributes(order, payment:, branch_id: order.branch_id)
    now = Time.utc(2026, 11, 14, 10, 2, 0)
    {
      id: SecureRandom.uuid,
      order_id: order.id,
      payment_id: payment.id,
      branch_id: branch_id,
      status: "pending",
      idempotency_key: "database-integrity-dispatch-#{SecureRandom.uuid}",
      requested_at: now,
      created_at: now,
      updated_at: now
    }
  end

  def review_case_attributes(order:, payment:, attempt:)
    now = Time.utc(2026, 11, 14, 10, 3, 0)
    {
      id: SecureRandom.uuid,
      order_id: order.id,
      payment_id: payment.id,
      payment_attempt_id: attempt.id,
      kind: "late_success",
      status: "open",
      recorded_by_actor_id: SecureRandom.uuid,
      opened_at: now,
      created_at: now,
      updated_at: now
    }
  end

  def enforce_deferred_constraints!
    ActiveRecord::Base.connection.execute("SET CONSTRAINTS ALL IMMEDIATE")
  end

  def defer_constraints!
    ActiveRecord::Base.connection.execute("SET CONSTRAINTS ALL DEFERRED")
  end
end
