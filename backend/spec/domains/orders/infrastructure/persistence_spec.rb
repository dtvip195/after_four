require "rails_helper"

RSpec.describe "Ordering persistence and Payment contract adapters" do
  let(:now) { Time.utc(2026, 11, 14, 10, 0, 0) }
  let(:mapper) { Orders::Infrastructure::Persistence::OrderMapper.new }
  let(:repository) { Orders::Infrastructure::Persistence::ActiveRecordOrderRepository.new(mapper: mapper) }

  it "maps OrderRecord to the Aggregate and applies Aggregate transitions back" do
    record = create_order_record
    aggregate = mapper.to_domain(record)

    aggregate.confirm(
      idempotency_key: "confirm-map",
      expected_version: record.lock_version,
      now: now,
      payment_window: Orders::Domain::ValueObjects::PaymentWindow.new(300)
    )
    mapper.apply(aggregate, record)
    record.save!

    expect(aggregate).to be_a(Orders::Domain::Aggregates::Order)
    expect(record.reload).to have_attributes(
      status: "confirmed",
      confirmation_idempotency_key: "confirm-map",
      confirmed_at: now,
      payment_expires_at: now + 300
    )
  end

  it "persists new Aggregates without changing the existing orders table" do
    aggregate = build_aggregate

    repository.add(aggregate)

    expect(Orders::Infrastructure::Persistence::OrderRecord.find(aggregate.id.to_s)).to have_attributes(
      order_number: "AF-INFRA",
      status: "draft",
      total_amount: 80_000,
      currency_code: "VND"
    )
  end

  it "refuses to save an Aggregate that was not obtained through the repository lock" do
    record = create_order_record
    aggregate = mapper.to_domain(record)

    expect { repository.save(aggregate) }
      .to raise_error(Orders::Application::Ports::OrderRepository::OrderNotLocked)
  end

  it "propagates not-found lookup through the Ordering settlement gateway" do
    gateway = Orders::Infrastructure::Adapters::ActiveRecordOrderSettlementGateway.new(
      order_repository: repository
    )

    expect { gateway.lock(SecureRandom.uuid) }.to raise_error(ActiveRecord::RecordNotFound)
  end

  it "keeps settlement gateway writes inside the caller's transaction" do
    record = create_order_record
    gateway = Orders::Infrastructure::Adapters::ActiveRecordOrderSettlementGateway.new(
      order_repository: repository
    )

    ApplicationRecord.transaction do
      aggregate = gateway.lock(record.id)
      aggregate.confirm(
        idempotency_key: "gateway-ambient-transaction",
        expected_version: record.lock_version,
        now: now,
        payment_window: Orders::Domain::ValueObjects::PaymentWindow.new(300)
      )
      gateway.save(aggregate)
      raise ActiveRecord::Rollback
    end

    expect(record.reload).to have_attributes(status: "draft", confirmation_idempotency_key: nil)
  end

  it "implements the Ordering-owned Payment contract under the ambient transaction" do
    aggregate = build_aggregate
    repository.add(aggregate)
    adapter = Payments::Infrastructure::Adapters::OrderingPaymentGateway.new

    reference = adapter.create_target(
      order_id: aggregate.id.to_s,
      amount: 80_000,
      currency_code: "VND",
      now: now
    )
    snapshot = adapter.lock_snapshot(order_id: aggregate.id.to_s)

    expect(reference).to eq(Payment.find_by!(order_id: aggregate.id.to_s).id)
    expect(snapshot).to have_attributes(reference_id: reference, funding_status: "unpaid")
    expect(snapshot).to be_unpaid
  end

  it "round-trips every lifecycle and nullable history field in both directions" do
    lifecycle_rows = {
      "draft" => {},
      "confirmed" => confirmation_attributes,
      "held" => confirmation_attributes.merge(hold_attributes),
      "expired" => confirmation_attributes.merge(expired_at: now + 300)
    }

    lifecycle_rows.each do |status, history|
      record = create_order_record
      record.update_columns(status: status, **history)

      aggregate = mapper.to_domain(record.reload)
      rebuilt = mapper.build_record(aggregate)

      expect(aggregate.status).to eq(status)
      expect(rebuilt.attributes.slice(*history_field_names)).to eq(
        record.attributes.slice(*history_field_names)
      )
    end
  end

  it "rejects malformed persisted lifecycle rows instead of normalizing them" do
    malformed_rows = [
      [ { confirmed_at: now }, /Confirmation evidence contradicts draft status/ ],
      [ { status: "confirmed", confirmed_at: now }, /Confirmation evidence is incomplete/ ],
      [ { status: "held", **confirmation_attributes, held_at: now + 60, hold_reason: "Review" }, /Hold evidence is incomplete/ ],
      [ { status: "expired", **confirmation_attributes }, /Expiration evidence is incomplete/ ]
    ]

    malformed_rows.each do |attributes, expected_error|
      record = create_order_record
      record.update_columns(**attributes)

      expect { mapper.to_domain(record.reload) }.to raise_error(ArgumentError, expected_error)
      expect(record.reload.attributes).to include(attributes.stringify_keys)
    end
  end

  it "persists, reloads, and replays a legacy whitespace-only Hold key" do
    actor_id = SecureRandom.uuid
    created = create_order_draft_record(
      actor_id: actor_id,
      branch_id: SecureRandom.uuid,
      channel: "takeaway",
      total_amount: 80_000,
      currency_code: "VND",
      idempotency_key: "whitespace-hold-create",
      now: now
    )
    confirm_order_record(
      order_id: created.id,
      actor_id: actor_id,
      idempotency_key: "whitespace-hold-confirm",
      expected_version: created.lock_version,
      now: now
    )
    held = hold_order_record(
      order_id: created.id,
      actor_id: actor_id,
      reason: "Review",
      idempotency_key: " ",
      expected_version: created.reload.lock_version,
      now: now + 60
    )

    reconstituted = repository.lock(held.id)
    replay = OrderingComposition.hold_use_case.call(
      order_id: held.id,
      actor_id: actor_id,
      reason: "Review",
      idempotency_key: " ",
      expected_version: held.lock_version,
      now: now + 120
    )

    expect(reconstituted).to have_attributes(status: "held", hold_idempotency_key: " ")
    expect(replay).to have_attributes(replayed: true)
    expect(replay.order).to have_attributes(status: "held", hold_idempotency_key: " ")
    expect(AuditEvent.where(event_type: "order.held", subject_id: held.id).count).to eq(1)
  end

  it "does not overwrite the persistence-owned lock_version while applying an Aggregate" do
    record = create_order_record
    record.update_columns(lock_version: 7)
    aggregate = mapper.to_domain(record.reload)
    record.update_columns(lock_version: 8)

    mapper.apply(aggregate, record.reload)

    expect(record.lock_version).to eq(8)
  end

  it "raises the PostgreSQL-backed optimistic-locking error for a stale OrderRecord" do
    first = create_order_record
    stale = Orders::Infrastructure::Persistence::OrderRecord.find(first.id)
    first.update!(order_number: "AF-CURRENT")

    expect { stale.update!(order_number: "AF-STALE") }
      .to raise_error(ActiveRecord::StaleObjectError)
    expect(first.reload.order_number).to eq("AF-CURRENT")
  end

  it "does not persist partial changes when mapper attribute extraction fails" do
    record = create_order_record
    aggregate = build_aggregate
    allow(aggregate).to receive(:hold_reason).and_raise("mapper failure")

    expect { mapper.apply(aggregate, record) }.to raise_error("mapper failure")
    expect(record.reload).to have_attributes(order_number: "AF-MAPPER", status: "draft")
  end

  it "rolls repository and Audit adapter writes back with the ambient UnitOfWork" do
    aggregate = build_aggregate
    unit_of_work = Orders::Infrastructure::Persistence::ActiveRecordUnitOfWork.new
    audit_log = Orders::Infrastructure::Adapters::ActiveRecordAuditLog.new

    expect do
      unit_of_work.call do
        repository.add(aggregate)
        audit_log.order_created(order: aggregate, actor_id: aggregate.created_by_actor_id, now: now)
        raise ActiveRecord::Rollback
      end
    end.not_to change(Orders::Infrastructure::Persistence::OrderRecord, :count)

    expect(AuditEvent.where(subject_id: aggregate.id.to_s)).to be_empty
  end

  it "rolls Ordering writes back when the Payment adapter fails in the ambient UnitOfWork" do
    aggregate = build_aggregate
    unit_of_work = Orders::Infrastructure::Persistence::ActiveRecordUnitOfWork.new
    adapter = Payments::Infrastructure::Adapters::OrderingPaymentGateway.new

    expect do
      expect do
        unit_of_work.call do
          repository.add(aggregate)
          adapter.create_target(
            order_id: aggregate.id.to_s,
            amount: 0,
            currency_code: "VND",
            now: now
          )
        end
      end.to raise_error(ActiveRecord::RecordInvalid)
    end.not_to change(Orders::Infrastructure::Persistence::OrderRecord, :count)

    expect(Payment.where(order_id: aggregate.id.to_s)).to be_empty
  end

  it "rolls a successful Payment and Audit write back after a later outer failure" do
    aggregate = build_aggregate
    unit_of_work = Orders::Infrastructure::Persistence::ActiveRecordUnitOfWork.new
    payment_adapter = Payments::Infrastructure::Adapters::OrderingPaymentGateway.new
    audit_log = Orders::Infrastructure::Adapters::ActiveRecordAuditLog.new

    expect do
      unit_of_work.call do
        repository.add(aggregate)
        payment_reference = payment_adapter.create_target(
          order_id: aggregate.id.to_s,
          amount: aggregate.total.amount,
          currency_code: aggregate.total.currency_code,
          now: now
        )
        audit_log.order_created(order: aggregate, actor_id: aggregate.created_by_actor_id, now: now)

        expect(Payment.find(payment_reference)).to have_attributes(order_id: aggregate.id.to_s)
        expect(AuditEvent.where(subject_id: aggregate.id.to_s, event_type: "order.created")).to exist
        raise "later covered operation failed"
      end
    end.to raise_error("later covered operation failed")

    expect(Orders::Infrastructure::Persistence::OrderRecord.where(id: aggregate.id.to_s)).to be_empty
    expect(Payment.where(order_id: aggregate.id.to_s)).to be_empty
    expect(AuditEvent.where(subject_id: aggregate.id.to_s)).to be_empty
    expect(OutboxEvent.where(aggregate_id: aggregate.id.to_s)).to be_empty
  end

  def create_order_record
    Orders::Infrastructure::Persistence::OrderRecord.create!(
      id: SecureRandom.uuid,
      branch_id: SecureRandom.uuid,
      created_by_actor_id: SecureRandom.uuid,
      order_number: "AF-MAPPER",
      channel: "takeaway",
      status: "draft",
      total_amount: 80_000,
      currency_code: "VND",
      creation_idempotency_key: "mapper-create",
      creation_request_fingerprint: "a" * 64,
      created_at: now,
      updated_at: now
    )
  end

  def build_aggregate
    Orders::Domain::Aggregates::Order.new(
      id: SecureRandom.uuid,
      branch_id: SecureRandom.uuid,
      created_by_actor_id: SecureRandom.uuid,
      order_number: "AF-INFRA",
      channel: "takeaway",
      status: "draft",
      total: Orders::Domain::ValueObjects::Money.new(amount: 80_000, currency_code: "VND"),
      creation_idempotency_key: "infra-create-#{SecureRandom.hex(4)}",
      creation_request_fingerprint: "b" * 64,
      lock_version: 0,
      created_at: now,
      updated_at: now
    )
  end

  def confirmation_attributes
    {
      confirmation_idempotency_key: "confirm-map",
      confirmed_at: now,
      payment_expires_at: now + 300
    }
  end

  def hold_attributes
    {
      hold_idempotency_key: "hold-map",
      hold_reason: "Review",
      held_at: now + 60
    }
  end

  def history_field_names
    %w[
      confirmation_idempotency_key confirmed_at payment_expires_at expired_at
      held_at hold_reason hold_idempotency_key
    ]
  end
end
