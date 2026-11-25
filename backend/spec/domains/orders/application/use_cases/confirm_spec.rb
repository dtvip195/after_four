require "spec_helper"
require_relative "../support/application_fakes"

RSpec.describe Orders::Application::UseCases::Confirm do
  include OrderingApplicationSpecSupport

  let(:repository) { OrderingApplicationSpecSupport::InMemoryOrderRepository.new }
  let(:audit_log) { OrderingApplicationSpecSupport::AuditLogFake.new }
  let(:unit_of_work) { OrderingApplicationSpecSupport::UnitOfWorkFake.new }

  it "confirms through the Aggregate inside one transaction" do
    order = draft_order
    repository.seed(order)

    result = build_use_case.call(
      order_id: order.id.to_s,
      actor_id: order.created_by_actor_id,
      idempotency_key: "confirm-1",
      expected_version: 0
    )

    expect(result).to have_attributes(replayed: false)
    expect(result.order).to have_attributes(
      status: "confirmed",
      confirmed_at: OrderingApplicationSpecSupport::NOW,
      payment_expires_at: OrderingApplicationSpecSupport::NOW + 300
    )
    expect(repository.saves).to contain_exactly(order)
    expect(audit_log.events.map(&:first)).to eq([ :confirmed ])
    expect(unit_of_work.calls).to eq(1)
  end

  it "samples confirmation decision time after the Order lock" do
    order = draft_order
    repository.seed(order)
    sequence = []
    repository.sequence = sequence
    lock_reached = Queue.new
    release_lock = Queue.new
    repository.before_lock_return = -> { lock_reached << true; release_lock.pop }
    decision_time = OrderingApplicationSpecSupport::NOW + 30
    use_case = build_use_case(clock: -> { sequence << :clock; decision_time })

    worker = Thread.new do
      use_case.call(
        order_id: order.id.to_s,
        actor_id: order.created_by_actor_id,
        idempotency_key: "confirm-after-lock",
        expected_version: 0
      )
    end
    lock_reached.pop
    expect(sequence).to eq([ :order_lock ])
    release_lock << true

    expect(worker.value.order).to have_attributes(
      confirmed_at: decision_time,
      payment_expires_at: decision_time + 300
    )
    expect(sequence).to eq(%i[order_lock clock])
  end

  it "replays the original confirmation before evaluating the old expected version" do
    order = draft_order
    repository.seed(order)
    use_case = build_use_case
    first = use_case.call(
      order_id: order.id.to_s,
      actor_id: OrderingApplicationSpecSupport::ACTOR_ID,
      idempotency_key: "confirm-replay",
      expected_version: 0
    )
    replay = use_case.call(
      order_id: order.id.to_s,
      actor_id: OrderingApplicationSpecSupport::ACTOR_ID,
      idempotency_key: "confirm-replay",
      expected_version: 0
    )

    expect(first).to have_attributes(replayed: false)
    expect(replay).to have_attributes(replayed: true)
    expect(audit_log.events.map(&:first)).to eq([ :confirmed ])
  end

  it "rejects stale versions and new confirmation attempts after confirmation" do
    stale = draft_order
    repository.seed(stale)

    expect do
      build_use_case.call(
        order_id: stale.id.to_s,
        actor_id: OrderingApplicationSpecSupport::ACTOR_ID,
        idempotency_key: "confirm-stale",
        expected_version: 1
      )
    end.to raise_error(Orders::Domain::Errors::RuleViolation) { |error|
      expect(error.code).to eq("concurrent_modification")
      expect(error.details).to eq(current_version: 0)
    }

    build_use_case.call(
      order_id: stale.id.to_s,
      actor_id: OrderingApplicationSpecSupport::ACTOR_ID,
      idempotency_key: "confirm-first",
      expected_version: 0
    )
    expect do
      build_use_case.call(
        order_id: stale.id.to_s,
        actor_id: OrderingApplicationSpecSupport::ACTOR_ID,
        idempotency_key: "confirm-second",
        expected_version: 0
      )
    end.to raise_error(Orders::Domain::Errors::RuleViolation) { |error|
      expect(error.code).to eq("invalid_state_transition")
    }
  end

  it "preserves actor and idempotency input contracts" do
    order = draft_order
    repository.seed(order)

    expect do
      build_use_case.call(
        order_id: order.id.to_s,
        actor_id: "invalid",
        idempotency_key: "confirm-invalid-actor",
        expected_version: 0
      )
    end.to raise_error(Orders::Domain::Errors::RuleViolation) { |error|
      expect(error.code).to eq("trusted_actor_required")
    }

    result = build_use_case.call(
      order_id: order.id.to_s,
      actor_id: OrderingApplicationSpecSupport::ACTOR_ID,
      idempotency_key: " ",
      expected_version: 0
    )
    expect(result.order.confirmation_idempotency_key).to eq(" ")

    other = draft_order(id: "1e7d54a0-9a21-4bec-978f-032df0eb8bb9")
    repository.seed(other)
    expect do
      build_use_case.call(
        order_id: other.id.to_s,
        actor_id: OrderingApplicationSpecSupport::ACTOR_ID,
        idempotency_key: "",
        expected_version: 0
      )
    end.to raise_error(Orders::Domain::Errors::RuleViolation) { |error|
      expect(error.code).to eq("idempotency_key_required")
    }
  end

  it "rejects confirmation after Hold or expiration" do
    held = confirmed_order
    held.hold(
      reason: "Review",
      idempotency_key: "hold-before-confirm",
      expected_version: 0,
      now: OrderingApplicationSpecSupport::NOW + 60,
      payment_unpaid: true
    )
    expired = confirmed_order(id: "1e7d54a0-9a21-4bec-978f-032df0eb8bb9")
    expired.expire(now: OrderingApplicationSpecSupport::NOW + 300, payment_unpaid: true)
    [ held, expired ].each { |order| repository.seed(order) }

    [ held, expired ].each do |order|
      expect do
        build_use_case.call(
          order_id: order.id.to_s,
          actor_id: OrderingApplicationSpecSupport::ACTOR_ID,
          idempotency_key: "new-confirm-#{order.id}",
          expected_version: 0
        )
      end.to raise_error(Orders::Domain::Errors::RuleViolation) { |error|
        expect(error.code).to eq("invalid_state_transition")
      }
    end
  end

  def build_use_case(clock: -> { OrderingApplicationSpecSupport::NOW })
    described_class.new(
      order_repository: repository,
      audit_log: audit_log,
      unit_of_work: unit_of_work,
      payment_window: Orders::Domain::ValueObjects::PaymentWindow.new(300),
      clock: clock
    )
  end
end
