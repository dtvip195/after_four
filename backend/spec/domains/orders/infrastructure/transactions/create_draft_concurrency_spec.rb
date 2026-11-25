require "rails_helper"

RSpec.describe "concurrent draft creation idempotency", :concurrency do
  self.use_transactional_tests = false

  it "returns the same Order to concurrent same-key same-payload callers" do
    branch_id = SecureRandom.uuid
    attributes = creation_attributes(branch_id:, idempotency_key: "concurrent-same-payload")

    results = race_creations([ attributes, attributes ])

    expect(results).to all(be_a(Orders::Application::UseCases::CreateDraft::Result))
    expect(results.map { |result| result.order.id }.uniq.one?).to be(true)
    expect(results.map(&:payment_reference).uniq.one?).to be(true)
    expect(results.map(&:replayed)).to contain_exactly(false, true)
    expect(Orders::Infrastructure::Persistence::OrderRecord.where(branch_id: branch_id, creation_idempotency_key: "concurrent-same-payload").count).to eq(1)
    expect(Payment.where(order_id: results.first.order.id.to_s).count).to eq(1)
    expect(AuditEvent.where(branch_id: branch_id, event_type: "order.created").count).to eq(1)
  ensure
    cleanup_branch(branch_id)
  end

  it "allows one concurrent payload to win and rejects the other as a conflict" do
    branch_id = SecureRandom.uuid
    original = creation_attributes(branch_id:, idempotency_key: "concurrent-different-payload")
    changed = original.merge(channel: "dine_in", total_amount: 135_000)

    results = race_creations([ original, changed ])
    winner = results.find { |result| result.is_a?(Orders::Application::UseCases::CreateDraft::Result) }
    conflict = results.find { |result| result.is_a?(Orders::Domain::Errors::RuleViolation) }

    expect(winner).to be_present
    expect(conflict&.code).to eq("idempotency_conflict")
    expect(Orders::Infrastructure::Persistence::OrderRecord.where(branch_id: branch_id, creation_idempotency_key: "concurrent-different-payload").count).to eq(1)
    winning_order = Orders::Infrastructure::Persistence::OrderRecord.find(winner.order.id.to_s)
    winning_payment = Payment.find(winner.payment_reference)
    expect([ [ "takeaway", 125_000 ], [ "dine_in", 135_000 ] ])
      .to include([ winning_order.channel, winning_order.total_amount ])
    expect(winning_payment).to have_attributes(target_amount: winning_order.total_amount)
    expect(Payment.where(order_id: winning_order.id).count).to eq(1)
    expect(AuditEvent.where(branch_id: branch_id, event_type: "order.created").count).to eq(1)
  ensure
    cleanup_branch(branch_id)
  end

  it "creates independent complete aggregates for concurrent unrelated keys" do
    branch_id = SecureRandom.uuid
    first = creation_attributes(branch_id:, idempotency_key: "concurrent-unrelated-one")
    second = creation_attributes(branch_id:, idempotency_key: "concurrent-unrelated-two")

    results = race_creations([ first, second ])

    expect(results).to all(be_a(Orders::Application::UseCases::CreateDraft::Result))
    expect(results.map(&:replayed)).to contain_exactly(false, false)
    expect(results.map { |result| result.order.id }.uniq.length).to eq(2)
    expect(results.map(&:payment_reference).uniq.length).to eq(2)
    expect(Orders::Infrastructure::Persistence::OrderRecord.where(branch_id: branch_id).count).to eq(2)
    expect(Payment.where(order_id: results.map { |result| result.order.id }).count).to eq(2)
    expect(AuditEvent.where(branch_id: branch_id, event_type: "order.created").count).to eq(2)
  ensure
    cleanup_branch(branch_id)
  end

  def creation_attributes(branch_id:, idempotency_key:)
    {
      actor_id: SecureRandom.uuid,
      branch_id: branch_id,
      channel: "takeaway",
      total_amount: 125_000,
      currency_code: "VND",
      idempotency_key: idempotency_key,
      now: Time.utc(2026, 11, 14, 10, 0, 0)
    }
  end

  def race_creations(attribute_sets)
    lock_ready = Queue.new
    release_lock = Queue.new
    start = Queue.new
    application_names = attribute_sets.each_index.map { |index| "draft_creation_racer_#{index}_#{SecureRandom.hex(4)}" }
    holder = hold_orders_table(lock_ready, release_lock)
    lock_ready.pop

    racers = attribute_sets.each_with_index.map do |attributes, index|
      Thread.new do
        ActiveRecord::Base.connection_pool.with_connection do |connection|
          connection.execute("SET application_name = #{connection.quote(application_names[index])}")
          start.pop
          begin
            OrderingComposition.create_draft_use_case.call(**attributes)
          rescue StandardError => error
            error
          ensure
            connection.execute("RESET application_name")
          end
        end
      end
    end
    attribute_sets.length.times { start << true }
    wait_until_insertions_are_blocked(application_names)
    release_lock << true
    results = racers.map(&:value)
    holder.join
    results
  ensure
    release_lock << true if holder&.alive?
    holder&.join
    racers&.each(&:join)
  end

  def hold_orders_table(lock_ready, release_lock)
    Thread.new do
      ActiveRecord::Base.connection_pool.with_connection do |connection|
        Orders::Infrastructure::Persistence::OrderRecord.transaction do
          connection.execute("LOCK TABLE orders IN SHARE MODE")
          lock_ready << true
          release_lock.pop
        end
      end
    end
  end

  def wait_until_insertions_are_blocked(application_names)
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

      raise "Concurrent draft inserts did not reach the database lock" if Process.clock_gettime(Process::CLOCK_MONOTONIC) >= deadline

      Thread.pass
    end
  end

  def cleanup_branch(branch_id)
    return unless branch_id

    order_ids = Orders::Infrastructure::Persistence::OrderRecord.where(branch_id: branch_id).pluck(:id)
    payment_ids = Payment.where(order_id: order_ids).pluck(:id)
    delete_audit_events_as_database_owner(AuditEvent.where(branch_id: branch_id))
    PaymentAttempt.where(payment_id: payment_ids).delete_all
    Payment.where(id: payment_ids).delete_all
    Orders::Infrastructure::Persistence::OrderRecord.where(id: order_ids).delete_all
  end
end
