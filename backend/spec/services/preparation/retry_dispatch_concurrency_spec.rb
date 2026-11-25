require "rails_helper"

RSpec.describe "concurrent preparation dispatch retry", :concurrency do
  self.use_transactional_tests = false

  it "serializes same-command retries without duplicating Dispatch, Outbox, Attempt, or Audit evidence" do
    actor_id, now, order, dispatch, event = create_pending_dispatch("concurrent-same-command")
    mark_published(event, now + 2.minutes)
    attributes = retry_attributes(dispatch:, actor_id:, key: "concurrent-same-command", now: now + 3.minutes)
    lock_ready = Queue.new
    release_lock = Queue.new
    start = Queue.new
    application_names = 2.times.map { |index| "dispatch_retry_racer_#{index}_#{SecureRandom.hex(4)}" }
    holder = hold_dispatch(dispatch, lock_ready, release_lock)
    lock_ready.pop

    racers = application_names.map do |application_name|
      Thread.new do
        ActiveRecord::Base.connection_pool.with_connection do |connection|
          connection.execute("SET application_name = #{connection.quote(application_name)}")
          start.pop
          Preparation::RetryDispatch.call(**attributes)
        ensure
          connection.execute("RESET application_name")
        end
      end
    end
    2.times { start << true }
    wait_until_retries_are_blocked(application_names)
    release_lock << true
    results = racers.map(&:value)
    holder.join

    expect(results).to all(be_a(Preparation::RetryDispatch::Result))
    expect(results.map(&:replayed)).to contain_exactly(false, true)
    expect(results.map { |result| result.preparation_dispatch.id }.uniq).to eq([ dispatch.id ])
    expect(PreparationDispatch.where(order_id: order.id).count).to eq(1)
    expect(OutboxEvent.where(event_key: event.event_key).count).to eq(1)
    expect(event.reload).to have_attributes(status: "pending", published_at: nil)
    expect(Payments::Infrastructure::Persistence::PaymentAttemptRecord.where(payment_id: payment_for(order).id, status: "succeeded").count).to eq(1)
    expect(AuditEvent.where(event_type: "preparation.dispatch_retry_requested", subject_id: dispatch.id).count).to eq(1)
  ensure
    release_lock << true if holder&.alive?
    holder&.join
    racers&.each(&:join)
    cleanup_order(order)
  end

  it "does not treat unrelated Audit uniqueness as a successful replay" do
    actor_id, now, order, dispatch, event = create_pending_dispatch("unrelated-audit-identity")
    mark_published(event, now + 2.minutes)
    key = "unrelated-audit-identity"
    AuditEvent.create!(
      branch_id: dispatch.branch_id,
      actor_type: "system",
      event_type: "test.reserved_audit_identity",
      subject_type: "Order",
      subject_id: order.id,
      idempotency_key: "preparation.dispatch_retry:#{dispatch.id}:#{key}",
      metadata: {},
      occurred_at: now + 2.minutes,
      created_at: now + 2.minutes
    )

    expect do
      Preparation::RetryDispatch.call(
        **retry_attributes(dispatch:, actor_id:, key: key, now: now + 3.minutes)
      )
    end.to raise_error(ActiveRecord::RecordNotUnique)

    expect(event.reload).to have_attributes(status: "published", published_at: now + 2.minutes)
    expect(AuditEvent.where(branch_id: dispatch.branch_id).count).to eq(4)
    expect(AuditEvent.where(event_type: "preparation.dispatch_retry_requested")).to be_empty
  ensure
    cleanup_order(order)
  end

  def create_pending_dispatch(suffix)
    actor_id = SecureRandom.uuid
    now = Time.utc(2026, 11, 14, 16, 0, 0)
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
    dispatch = PaymentComposition.confirm_cash(
      order_id: order.id,
      actor_id: actor_id,
      amount: order.total_amount,
      currency_code: order.currency_code,
      idempotency_key: "payment-#{suffix}",
      clock: -> { now + 1.minute }
    ).preparation_dispatch
    event = OutboxEvent.find_by!(event_key: "preparation.dispatch_requested:#{dispatch.id}")
    [ actor_id, now, order, dispatch, event ]
  end

  def retry_attributes(dispatch:, actor_id:, key:, now:)
    {
      preparation_dispatch_id: dispatch.id,
      actor_id: actor_id,
      idempotency_key: key,
      now: now
    }
  end

  def mark_published(event, published_at)
    event.update!(status: "published", published_at: published_at, updated_at: published_at)
  end

  def hold_dispatch(dispatch, lock_ready, release_lock)
    Thread.new do
      ActiveRecord::Base.connection_pool.with_connection do
        PreparationDispatch.transaction do
          PreparationDispatch.lock.find(dispatch.id)
          lock_ready << true
          release_lock.pop
        end
      end
    end
  end

  def wait_until_retries_are_blocked(application_names)
    deadline = Process.clock_gettime(Process::CLOCK_MONOTONIC) + 5
    quoted_names = application_names.map { |name| ActiveRecord::Base.connection.quote(name) }.join(", ")

    loop do
      blocked = ActiveRecord::Base.connection.select_value(<<~SQL).to_i
        SELECT count(*)
        FROM pg_stat_activity
        WHERE application_name IN (#{quoted_names})
          AND wait_event_type = 'Lock'
      SQL
      return if blocked == application_names.length

      raise "Concurrent Dispatch retries did not reach the database lock" if Process.clock_gettime(Process::CLOCK_MONOTONIC) >= deadline

      Thread.pass
    end
  end

  def cleanup_order(order)
    return unless order&.persisted?

    Payments::Infrastructure::Persistence::PaymentRecord.transaction do
      payment_ids = Payments::Infrastructure::Persistence::PaymentRecord.where(order_id: order.id).pluck(:id)
      dispatch_ids = PreparationDispatch.where(order_id: order.id).pluck(:id)
      delete_audit_events_as_database_owner(AuditEvent.where(branch_id: order.branch_id))
      Payments::Infrastructure::Persistence::PaymentReviewCaseRecord.where(order_id: order.id).delete_all
      PreparationDispatchAttempt.where(preparation_dispatch_id: dispatch_ids).delete_all
      OutboxEvent.where(aggregate_type: "PreparationDispatch", aggregate_id: dispatch_ids).delete_all
      PreparationDispatch.where(id: dispatch_ids).delete_all
      Payments::Infrastructure::Persistence::PaymentAttemptRecord.where(payment_id: payment_ids).delete_all
      Payments::Infrastructure::Persistence::PaymentRecord.where(id: payment_ids).delete_all
      Orders::Infrastructure::Persistence::OrderRecord.where(id: order.id).delete_all
    end
  end
end
