require "spec_helper"
require_relative "../support/application_fakes"

RSpec.describe Orders::Application::UseCases::Hold do
  include OrderingApplicationSpecSupport

  let(:repository) { OrderingApplicationSpecSupport::InMemoryOrderRepository.new }
  let(:payments) { OrderingApplicationSpecSupport::PaymentGatewayFake.new }
  let(:audit_log) { OrderingApplicationSpecSupport::AuditLogFake.new }
  let(:unit_of_work) { OrderingApplicationSpecSupport::UnitOfWorkFake.new }
  let(:use_case) do
    described_class.new(
      order_repository: repository,
      payment_gateway: payments,
      audit_log: audit_log,
      unit_of_work: unit_of_work
    )
  end

  it "locks Order before Payment and places an unpaid Order on hold" do
    order = confirmed_order
    repository.seed(order)
    sequence = []
    repository.sequence = sequence
    payments.sequence = sequence

    result = use_case.call(
      order_id: order.id.to_s,
      actor_id: OrderingApplicationSpecSupport::ACTOR_ID,
      reason: "Review",
      idempotency_key: "hold-1",
      expected_version: 0,
      now: OrderingApplicationSpecSupport::NOW + 60
    )

    expect(result.order).to have_attributes(status: "held", hold_reason: "Review")
    expect(sequence).to eq(%i[order_lock payment_lock])
    expect(audit_log.events.map(&:first)).to eq([ :held ])
  end

  it "leaves hold-reason validity to the Aggregate after required locks" do
    order = confirmed_order
    repository.seed(order)
    sequence = []
    repository.sequence = sequence
    payments.sequence = sequence

    expect do
      use_case.call(
        order_id: order.id.to_s,
        actor_id: OrderingApplicationSpecSupport::ACTOR_ID,
        reason: " ",
        idempotency_key: "hold-blank-reason",
        expected_version: 0,
        now: OrderingApplicationSpecSupport::NOW + 60
      )
    end.to raise_error(Orders::Domain::Errors::RuleViolation) { |error|
      expect(error.code).to eq("reason_required")
    }
    expect(sequence).to eq(%i[order_lock payment_lock])
    expect(repository.saves).to be_empty
    expect(audit_log.events).to be_empty
  end

  it "rejects a funded Payment without changing the Order" do
    order = confirmed_order
    repository.seed(order)
    payments.statuses[order.id.to_s] = "fully_paid"

    expect do
      use_case.call(
        order_id: order.id.to_s,
        actor_id: OrderingApplicationSpecSupport::ACTOR_ID,
        reason: "Review",
        idempotency_key: "hold-paid",
        expected_version: 0,
        now: OrderingApplicationSpecSupport::NOW + 60
      )
    end.to raise_error(Orders::Domain::Errors::RuleViolation) { |error|
      expect(error.code).to eq("invalid_state_transition")
    }
    expect(order.status).to eq("confirmed")
  end

  it "rejects stale versions" do
    order = confirmed_order
    repository.seed(order)

    expect do
      use_case.call(
        order_id: order.id.to_s,
        actor_id: OrderingApplicationSpecSupport::ACTOR_ID,
        reason: "Review",
        idempotency_key: "hold-stale",
        expected_version: -1,
        now: OrderingApplicationSpecSupport::NOW + 60
      )
    end.to raise_error(Orders::Domain::Errors::RuleViolation) { |error|
      expect(error.code).to eq("concurrent_modification")
    }
    expect(order.status).to eq("confirmed")
  end

  it "replays the original hold even when a repeated key carries another reason" do
    order = confirmed_order
    repository.seed(order)
    first = use_case.call(
      order_id: order.id.to_s,
      actor_id: OrderingApplicationSpecSupport::ACTOR_ID,
      reason: "Original reason",
      idempotency_key: "hold-replay",
      expected_version: 0,
      now: OrderingApplicationSpecSupport::NOW + 60
    )
    replay = use_case.call(
      order_id: order.id.to_s,
      actor_id: OrderingApplicationSpecSupport::ACTOR_ID,
      reason: "Conflicting reason",
      idempotency_key: "hold-replay",
      expected_version: 0,
      now: OrderingApplicationSpecSupport::NOW + 120
    )

    expect(first).to have_attributes(replayed: false)
    expect(replay).to have_attributes(replayed: true)
    expect(replay.order).to have_attributes(hold_reason: "Original reason", held_at: OrderingApplicationSpecSupport::NOW + 60)
    expect(audit_log.events.map(&:first)).to eq([ :held ])
  end

  it "accepts a whitespace key but rejects an empty key" do
    whitespace = confirmed_order
    repository.seed(whitespace)
    result = use_case.call(
      order_id: whitespace.id.to_s,
      actor_id: OrderingApplicationSpecSupport::ACTOR_ID,
      reason: "Review",
      idempotency_key: " ",
      expected_version: 0,
      now: OrderingApplicationSpecSupport::NOW + 60
    )
    expect(result.order.hold_idempotency_key).to eq(" ")

    empty = confirmed_order(id: "1e7d54a0-9a21-4bec-978f-032df0eb8bb9")
    repository.seed(empty)
    expect do
      use_case.call(
        order_id: empty.id.to_s,
        actor_id: OrderingApplicationSpecSupport::ACTOR_ID,
        reason: "Review",
        idempotency_key: "",
        expected_version: 0,
        now: OrderingApplicationSpecSupport::NOW + 60
      )
    end.to raise_error(Orders::Domain::Errors::RuleViolation) { |error|
      expect(error.code).to eq("idempotency_key_required")
    }
  end
end
