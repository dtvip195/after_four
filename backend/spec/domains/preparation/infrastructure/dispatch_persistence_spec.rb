require "rails_helper"

RSpec.describe "Preparation Dispatch persistence" do
  it "reconstitutes a valid namespaced persistence record as a Domain Aggregate" do
    actor_id, now, order = create_confirmed_order("reconstitution")
    dispatch = PaymentComposition.confirm_cash(
      order_id: order.id,
      actor_id: actor_id,
      amount: order.total_amount,
      currency_code: order.currency_code,
      idempotency_key: "preparation-reconstitution",
      clock: -> { now + 60 }
    ).preparation_dispatch
    record = Preparation::Infrastructure::Persistence::DispatchRecord.find(dispatch.id)

    aggregate = Preparation::Infrastructure::Persistence::DispatchMapper.new.to_domain(record)

    expect(aggregate).to be_a(Preparation::Domain::Aggregates::Dispatch)
    expect(aggregate).to have_attributes(
      id: Preparation::Domain::ValueObjects::DispatchId.new(record.id),
      order_id: order.id,
      payment_id: payment_for(order).id,
      branch_id: order.branch_id,
      status: "pending",
      lock_version: 0
    )
  end

  it "rejects malformed persisted lifecycle evidence during reconstitution" do
    record = Preparation::Infrastructure::Persistence::DispatchRecord.new(
      id: SecureRandom.uuid,
      order_id: SecureRandom.uuid,
      payment_id: SecureRandom.uuid,
      branch_id: SecureRandom.uuid,
      status: "dispatched",
      idempotency_key: "malformed-reconstitution",
      requested_at: Time.current,
      dispatched_at: nil,
      lock_version: 0,
      created_at: Time.current,
      updated_at: Time.current
    )

    expect do
      Preparation::Infrastructure::Persistence::DispatchMapper.new.to_domain(record)
    end.to raise_error(ArgumentError, "Dispatched Preparation Dispatch requires dispatched evidence")
  end

  it "requires repository locking before save" do
    actor_id, now, order = create_confirmed_order("repository-lock")
    dispatch = PaymentComposition.confirm_cash(
      order_id: order.id,
      actor_id: actor_id,
      amount: order.total_amount,
      currency_code: order.currency_code,
      idempotency_key: "preparation-repository-lock",
      clock: -> { now + 60 }
    ).preparation_dispatch
    record = Preparation::Infrastructure::Persistence::DispatchRecord.find(dispatch.id)
    aggregate = Preparation::Infrastructure::Persistence::DispatchMapper.new.to_domain(record)

    expect do
      Preparation::Infrastructure::Persistence::ActiveRecordDispatchRepository.new.save(aggregate)
    end.to raise_error(Preparation::Application::Ports::DispatchRepository::DispatchNotLocked)
  end

  it "preserves Active Record optimistic-lock stale-update protection" do
    actor_id, now, order = create_confirmed_order("optimistic-lock")
    dispatch = PaymentComposition.confirm_cash(
      order_id: order.id,
      actor_id: actor_id,
      amount: order.total_amount,
      currency_code: order.currency_code,
      idempotency_key: "preparation-optimistic-lock",
      clock: -> { now + 60 }
    ).preparation_dispatch
    first = Preparation::Infrastructure::Persistence::DispatchRecord.find(dispatch.id)
    stale = Preparation::Infrastructure::Persistence::DispatchRecord.find(dispatch.id)

    first.update!(updated_at: now + 120)

    expect { stale.update!(updated_at: now + 180) }.to raise_error(ActiveRecord::StaleObjectError)
  end

  def create_confirmed_order(suffix)
    actor_id = SecureRandom.uuid
    now = Time.utc(2026, 11, 26, 12, 0, 0)
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
