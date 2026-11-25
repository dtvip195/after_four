require "rails_helper"

RSpec.describe "Payment Phase 2 persistence and composition" do
  it "settles through Payment Application composition and returns Domain objects" do
    actor_id, now, order = create_confirmed_order("phase-2-composition")

    result = PaymentComposition.confirm_cash(
      order_id: order.id,
      actor_id: actor_id,
      amount: order.total_amount,
      currency_code: order.currency_code,
      idempotency_key: "phase-2-cash",
      clock: -> { now + 60 }
    )

    expect(result.payment).to be_a(Payments::Domain::Aggregates::Payment)
    expect(result.payment_attempt).to be_a(Payments::Domain::Entities::PaymentAttempt)
    expect(result).to have_attributes(replayed: false)
    expect(result.payment).to have_attributes(funding_status: "fully_paid", successful_amount: 80_000)
    expect(result.preparation_dispatch).to have_attributes(order_id: order.id, status: "pending")
    expect(Payments::Infrastructure::Persistence::PaymentRecord.find_by!(order_id: order.id))
      .to have_attributes(funding_status: "fully_paid", successful_amount: 80_000)
    expect(Payments::Infrastructure::Persistence::PaymentAttemptRecord.where(status: "succeeded").count).to eq(1)
  end

  it "requires a locked Aggregate before repository save" do
    actor_id, now, order = create_confirmed_order("phase-2-lock")
    record = Payments::Infrastructure::Persistence::PaymentRecord.find_by!(order_id: order.id)
    mapper = Payments::Infrastructure::Persistence::PaymentMapper.new
    repository = Payments::Infrastructure::Persistence::ActiveRecordPaymentRepository.new(mapper: mapper)

    expect { repository.save(mapper.to_domain(record)) }
      .to raise_error(Payments::Application::Ports::PaymentRepository::PaymentNotLocked)
  end

  it "persists a valid nonterminal Attempt transition through the locked repository" do
    actor_id, now, order = create_confirmed_order("phase-2-attempt-transition")
    payment_record = Payments::Infrastructure::Persistence::PaymentRecord.find_by!(order_id: order.id)
    attempt_record = payment_record.payment_attempt_records.create!(
      method: "cash",
      status: "pending",
      requested_amount: order.total_amount,
      currency_code: order.currency_code,
      idempotency_key: "phase-2-pending"
    )
    repository = Payments::Infrastructure::Persistence::ActiveRecordPaymentRepository.new

    payment = repository.lock_by_order_id(order.id)
    attempt = payment.attempts.fetch(0)
    attempt.transition_to_terminal(
      status: "failed",
      confirmed_amount: order.total_amount,
      actor_id: actor_id,
      confirmed_at: now + 60,
      failure_code: "declined"
    )
    repository.save(payment)

    expect(attempt_record.reload).to have_attributes(
      status: "failed",
      confirmed_amount: order.total_amount,
      confirmed_by_actor_id: actor_id,
      confirmed_at: now + 60,
      failure_code: "declined"
    )
  end

  it "rolls all settlement evidence back when Preparation Outbox persistence fails" do
    actor_id, now, order = create_confirmed_order("phase-2-rollback")
    connection = ActiveRecord::Base.connection
    connection.execute(<<~SQL)
      CREATE FUNCTION fail_phase_2_outbox_insert() RETURNS trigger AS $$
      BEGIN
        RAISE EXCEPTION 'phase 2 outbox failure';
      END;
      $$ LANGUAGE plpgsql;
      CREATE TRIGGER fail_phase_2_outbox_insert
      BEFORE INSERT ON outbox_events
      FOR EACH ROW EXECUTE FUNCTION fail_phase_2_outbox_insert();
    SQL

    expect do
      PaymentComposition.confirm_cash(
        order_id: order.id,
        actor_id: actor_id,
        amount: order.total_amount,
        currency_code: order.currency_code,
        idempotency_key: "phase-2-rollback",
        clock: -> { now + 60 }
      )
    end.to raise_error(ActiveRecord::StatementInvalid, /phase 2 outbox failure/)

    payment = Payments::Infrastructure::Persistence::PaymentRecord.find_by!(order_id: order.id)
    expect(payment).to have_attributes(funding_status: "unpaid", successful_amount: 0)
    expect(payment.payment_attempt_records).to be_empty
    expect(PreparationDispatch.where(order_id: order.id)).to be_empty
    expect(AuditEvent.where(event_type: "payment.confirmed")).to be_empty
  ensure
    connection&.execute("DROP TRIGGER IF EXISTS fail_phase_2_outbox_insert ON outbox_events")
    connection&.execute("DROP FUNCTION IF EXISTS fail_phase_2_outbox_insert()")
  end

  def create_confirmed_order(suffix)
    actor_id = SecureRandom.uuid
    now = Time.utc(2026, 11, 26, 9, 0, 0)
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
