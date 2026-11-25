require "rails_helper"

RSpec.describe Preparation::Application::UseCases::RequestDispatch do
  class PreparationRequestOrderGateway
    include Preparation::Application::Ports::OrderDispatchGateway

    attr_reader :lock_calls, :eligibility_calls

    def initialize(snapshot:, eligible: true)
      @snapshot = snapshot
      @eligible = eligible
      @lock_calls = []
      @eligibility_calls = []
    end

    def lock(order_id)
      lock_calls << order_id
      @snapshot
    end

    def dispatch_eligible?(snapshot, at:)
      eligibility_calls << [ snapshot, at ]
      @eligible
    end
  end

  class PreparationRequestPaymentGateway
    include Preparation::Application::Ports::PaymentSettlementGateway

    attr_reader :lock_calls, :settlement_checks

    def initialize(snapshot:, fully_settled: true)
      @snapshot = snapshot
      @fully_settled = fully_settled
      @lock_calls = []
      @settlement_checks = []
    end

    def lock_snapshot(order_id:)
      lock_calls << order_id
      @snapshot
    end

    def fully_settled?(snapshot)
      settlement_checks << snapshot
      @fully_settled
    end
  end

  class InMemoryPreparationDispatchRepository
    include Preparation::Application::Ports::DispatchRepository

    attr_reader :dispatches

    def initialize(dispatches = [])
      @dispatches = dispatches
    end

    def find_by_order_id(order_id)
      dispatches.find { |dispatch| dispatch.order_id == order_id.to_s }
    end

    def add(dispatch)
      dispatches << dispatch
    end

    def lock(dispatch_id)
      dispatches.find { |dispatch| dispatch.id.to_s == dispatch_id.to_s } || raise(KeyError)
    end

    def save(dispatch)
      dispatch
    end
  end

  class RecordingPreparationOutbox
    include Preparation::Application::Ports::Outbox

    attr_reader :requested_dispatches

    def initialize
      @requested_dispatches = []
    end

    def dispatch_requested(dispatch)
      requested_dispatches << dispatch
    end

    def requeue_dispatch(**)
      raise "not expected"
    end
  end

  class RecordingPreparationAuditLog
    include Preparation::Application::Ports::AuditLog

    attr_reader :requests

    def initialize
      @requests = []
    end

    def dispatch_requested(**attributes)
      requests << attributes
    end

    def dispatch_retry_recorded?(**)
      false
    end

    def dispatch_retry_requested(**)
      raise "not expected"
    end
  end

  class InMemoryPreparationUnitOfWork
    include Preparation::Application::Ports::UnitOfWork

    def call(&block)
      block.call
    end
  end

  let(:now) { Time.utc(2026, 11, 26, 9, 0, 0) }
  let(:order_id) { SecureRandom.uuid }
  let(:payment_id) { SecureRandom.uuid }
  let(:branch_id) { SecureRandom.uuid }
  let(:actor_id) { SecureRandom.uuid }
  let(:order_snapshot) do
    Preparation::Application::Ports::OrderDispatchGateway::Snapshot.new(
      id: order_id,
      branch_id: branch_id
    )
  end
  let(:payment_snapshot) do
    Preparation::Application::Ports::PaymentSettlementGateway::Snapshot.new(reference_id: payment_id)
  end
  let(:order_gateway) { PreparationRequestOrderGateway.new(snapshot: order_snapshot) }
  let(:payment_gateway) { PreparationRequestPaymentGateway.new(snapshot: payment_snapshot) }
  let(:repository) { InMemoryPreparationDispatchRepository.new }
  let(:outbox) { RecordingPreparationOutbox.new }
  let(:audit_log) { RecordingPreparationAuditLog.new }
  let(:use_case) do
    described_class.new(
      order_gateway: order_gateway,
      payment_gateway: payment_gateway,
      dispatch_repository: repository,
      outbox: outbox,
      audit_log: audit_log,
      unit_of_work: InMemoryPreparationUnitOfWork.new,
      id_generator: -> { "00000000-0000-4000-8000-000000000001" },
      clock: -> { now }
    )
  end

  it "locks Ordering then Payment and creates Dispatch, Outbox, and Audit evidence once" do
    result = use_case.call(order_id: order_id, actor_id: actor_id, idempotency_key: "recover-dispatch")

    expect(result.replayed).to be(false)
    expect(result.preparation_dispatch).to be_a(Preparation::Domain::Aggregates::Dispatch)
    expect(result.preparation_dispatch).to have_attributes(
      order_id: order_id,
      payment_id: payment_id,
      branch_id: branch_id,
      status: "pending"
    )
    expect(order_gateway.lock_calls).to eq([ order_id ])
    expect(payment_gateway.lock_calls).to eq([ order_id ])
    expect(order_gateway.eligibility_calls).to eq([ [ order_snapshot, now ] ])
    expect(payment_gateway.settlement_checks).to eq([ payment_snapshot ])
    expect(outbox.requested_dispatches).to eq([ result.preparation_dispatch ])
    expect(audit_log.requests.one?).to be(true)
  end

  it "returns the existing Dispatch without writing duplicate evidence" do
    first = use_case.call(order_id: order_id, actor_id: actor_id, idempotency_key: "recover-dispatch")
    replay = use_case.call(order_id: order_id, actor_id: actor_id, idempotency_key: "another-key")

    expect(replay).to have_attributes(preparation_dispatch: first.preparation_dispatch, replayed: true)
    expect(outbox.requested_dispatches.one?).to be(true)
    expect(audit_log.requests.one?).to be(true)
  end

  it "rejects an invalid actor through Preparation-owned input validation" do
    expect do
      use_case.call(order_id: order_id, actor_id: "invalid", idempotency_key: "recover-dispatch")
    end.to raise_error(DomainError) { |error|
      expect(error).to have_attributes(code: "trusted_actor_required", details: {})
    }

    expect(order_gateway.lock_calls).to be_empty
  end

  it "delegates Order and Payment eligibility to their owning context gateways" do
    ineligible_order = PreparationRequestOrderGateway.new(snapshot: order_snapshot, eligible: false)
    use_case = described_class.new(
      order_gateway: ineligible_order,
      payment_gateway: payment_gateway,
      dispatch_repository: repository,
      outbox: outbox,
      audit_log: audit_log,
      unit_of_work: InMemoryPreparationUnitOfWork.new,
      id_generator: -> { SecureRandom.uuid },
      clock: -> { now }
    )

    expect do
      use_case.call(order_id: order_id, actor_id: actor_id, idempotency_key: "ineligible")
    end.to raise_error(DomainError) { |error| expect(error.code).to eq("order_not_dispatchable") }

    unpaid_gateway = PreparationRequestPaymentGateway.new(snapshot: payment_snapshot, fully_settled: false)
    use_case = described_class.new(
      order_gateway: order_gateway,
      payment_gateway: unpaid_gateway,
      dispatch_repository: repository,
      outbox: outbox,
      audit_log: audit_log,
      unit_of_work: InMemoryPreparationUnitOfWork.new,
      id_generator: -> { SecureRandom.uuid },
      clock: -> { now }
    )
    expect do
      use_case.call(order_id: order_id, actor_id: actor_id, idempotency_key: "unpaid")
    end.to raise_error(DomainError) { |error| expect(error.code).to eq("payment_not_fully_settled") }
  end
end
