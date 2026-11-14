require "rails_helper"

RSpec.describe "payment deadline concurrency", :concurrency do
  self.use_transactional_tests = false

  MutableClock = Struct.new(:value) do
    def call
      value
    end
  end

  it "evaluates payment confirmation after waiting for the Order lock" do
    actor_id = SecureRandom.uuid
    confirmed_at = Time.utc(2026, 11, 14, 10, 30, 0)
    order = create_confirmed_order(actor_id:, confirmed_at:, suffix: "payment-lock-wait")
    clock = MutableClock.new(order.payment_expires_at - 1.second)
    lock_acquired = Queue.new
    release_lock = Queue.new
    command_started = Queue.new

    holder = hold_order_lock(order, lock_acquired, release_lock)
    lock_acquired.pop
    confirmer = Thread.new do
      ActiveRecord::Base.connection_pool.with_connection do
        command_started << true
        Payments::ConfirmCash.call(
          order_id: order.id,
          actor_id: actor_id,
          amount: order.total_amount,
          currency_code: order.currency_code,
          idempotency_key: "cash-after-lock-wait",
          clock: clock
        )
      end
    end
    command_started.pop
    clock.value = order.payment_expires_at
    release_lock << true
    result = confirmer.value
    holder.join

    expect(result.order).to have_attributes(status: "expired")
    expect(result.payment).to have_attributes(funding_status: "fully_paid")
    expect(result.review_case).to have_attributes(kind: "late_success", status: "open")
    expect(result.preparation_dispatch).to be_nil
  ensure
    release_lock << true if holder&.alive?
    holder&.join
    confirmer&.join
    cleanup_order(order)
  end

  it "evaluates dispatch eligibility after waiting for the Order lock" do
    actor_id = SecureRandom.uuid
    confirmed_at = Time.utc(2026, 11, 14, 11, 0, 0)
    order = create_confirmed_order(actor_id:, confirmed_at:, suffix: "dispatch-lock-wait")
    record_valid_settlement(order, confirmed_at + 1.minute)
    clock = MutableClock.new(order.payment_expires_at - 1.second)
    lock_acquired = Queue.new
    release_lock = Queue.new
    command_started = Queue.new

    holder = hold_order_lock(order, lock_acquired, release_lock)
    lock_acquired.pop

    requester = Thread.new do
      ActiveRecord::Base.connection_pool.with_connection do
        command_started << true
        begin
          Preparation::RequestDispatch.call(
            order_id: order.id,
            actor_id: actor_id,
            idempotency_key: "dispatch-after-lock-wait",
            clock: clock
          )
        rescue DomainError => error
          error
        end
      end
    end
    command_started.pop
    clock.value = order.payment_expires_at
    release_lock << true
    result = requester.value
    holder.join

    expect(result).to be_a(DomainError)
    expect(result.code).to eq("order_not_dispatchable")
    expect(order.reload).to have_attributes(status: "confirmed")
    expect(order.preparation_dispatch).to be_nil
  ensure
    release_lock << true if holder&.alive?
    holder&.join
    requester&.join
    cleanup_order(order)
  end


  it "serializes expiration racing with confirmation without dispatching at the deadline" do
    actor_id = SecureRandom.uuid
    confirmed_at = Time.utc(2026, 11, 14, 12, 0, 0)
    order = create_confirmed_order(actor_id:, confirmed_at:, suffix: "expiration-race")
    deadline = order.payment_expires_at
    ready = Queue.new
    start = Queue.new

    confirmer = Thread.new do
      ActiveRecord::Base.connection_pool.with_connection do
        ready << true
        start.pop
        Payments::ConfirmBankTransfer.call(
          order_id: order.id,
          actor_id: actor_id,
          amount: order.total_amount,
          currency_code: order.currency_code,
          idempotency_key: "bank-expiration-race",
          clock: -> { deadline }
        )
      end
    end
    expirer = Thread.new do
      ActiveRecord::Base.connection_pool.with_connection do
        ready << true
        start.pop
        Orders::ExpirePending.call(now: deadline)
      end
    end
    2.times { ready.pop }
    2.times { start << true }
    confirmation = confirmer.value
    expirer.value

    expect(confirmation.order.reload).to have_attributes(status: "expired")
    expect(confirmation.payment.reload).to have_attributes(funding_status: "fully_paid")
    expect(confirmation.review_case).to have_attributes(kind: "late_success", status: "open")
    expect(PreparationDispatch.where(order_id: order.id)).to be_empty
    expect(OutboxEvent.where(event_type: "preparation.dispatch_requested")).to be_empty
  ensure
    confirmer&.join
    expirer&.join
    cleanup_order(order)
  end

  def create_confirmed_order(actor_id:, confirmed_at:, suffix:)
    order = Orders::CreateDraft.call(
      actor_id: actor_id,
      branch_id: SecureRandom.uuid,
      channel: "takeaway",
      total_amount: 80_000,
      currency_code: "VND",
      idempotency_key: "create-#{suffix}",
      now: confirmed_at
    ).order
    Orders::Confirm.call(
      order_id: order.id,
      actor_id: actor_id,
      idempotency_key: "confirm-#{suffix}",
      expected_version: order.lock_version,
      now: confirmed_at
    )
    order.reload
  end

  def hold_order_lock(order, lock_acquired, release_lock)
    Thread.new do
      ActiveRecord::Base.connection_pool.with_connection do
        Order.transaction do
          Order.lock.find(order.id)
          lock_acquired << true
          release_lock.pop
        end
      end
    end
  end

  def cleanup_order(order)
    return unless order&.persisted?

    Payment.transaction do
      payment_ids = Payment.where(order_id: order.id).pluck(:id)
      dispatch_ids = PreparationDispatch.where(order_id: order.id).pluck(:id)
      delete_audit_events_as_database_owner(AuditEvent.where(branch_id: order.branch_id))
      PaymentReviewCase.where(order_id: order.id).delete_all
      PreparationDispatchAttempt.where(preparation_dispatch_id: dispatch_ids).delete_all
      OutboxEvent.where(aggregate_type: "PreparationDispatch", aggregate_id: dispatch_ids).delete_all
      PreparationDispatch.where(id: dispatch_ids).delete_all
      PaymentAttempt.where(payment_id: payment_ids).delete_all
      Payment.where(id: payment_ids).delete_all
      Order.where(id: order.id).delete_all
    end
  end

  def record_valid_settlement(order, settled_at)
    Payment.transaction do
      order.payment.payment_attempts.create!(
        method: "cash",
        status: "succeeded",
        requested_amount: order.total_amount,
        confirmed_amount: order.total_amount,
        currency_code: order.currency_code,
        idempotency_key: "deadline-dispatch-fixture",
        confirmed_by_actor_id: SecureRandom.uuid,
        confirmed_at: settled_at,
        created_at: settled_at,
        updated_at: settled_at
      )
      order.payment.update!(
        funding_status: "fully_paid",
        successful_amount: order.total_amount,
        fully_settled_at: settled_at
      )
    end
  end
end
