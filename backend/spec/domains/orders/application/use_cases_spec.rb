require "rails_helper"

RSpec.describe "Ordering Application use cases" do
  let(:now) { Time.utc(2026, 11, 14, 10, 0, 0) }
  let(:repository) { InMemoryOrderRepository.new }
  let(:payments) { PaymentGatewayFake.new }
  let(:audit_log) { AuditLogFake.new }
  let(:unit_of_work) { UnitOfWorkFake.new }

  it "creates and replays a complete Draft without exposing persistence" do
    use_case = Orders::Application::UseCases::CreateDraft.new(
      order_repository: repository,
      payment_gateway: payments,
      audit_log: audit_log,
      unit_of_work: unit_of_work,
      id_generator: -> { "0d13889c-916c-43e7-8f25-f21e19b6ef71" },
      order_number_generator: -> { "AF-TEST" }
    )
    attributes = draft_attributes

    first = use_case.call(**attributes)
    replay = use_case.call(**attributes.merge(now: now + 60))

    expect(first).to have_attributes(replayed: false, payment_reference: "payment-1")
    expect(first.order).to be_a(Orders::Domain::Aggregates::Order)
    expect(replay).to have_attributes(replayed: true, payment_reference: "payment-1")
    expect(repository.additions).to contain_exactly(first.order)
    expect(payments.created_targets).to contain_exactly(
      [ first.order.id.to_s, 80_000, "VND", now ]
    )
    expect(audit_log.events.map(&:first)).to eq([ :created ])
    expect(unit_of_work.calls).to eq(1)
  end

  it "rejects a replay whose semantic creation input differs" do
    use_case = create_draft_use_case
    use_case.call(**draft_attributes)

    expect do
      use_case.call(**draft_attributes.merge(channel: "dine_in"))
    end.to raise_error(Orders::Domain::Errors::RuleViolation) { |error|
      expect(error.code).to eq("idempotency_conflict")
    }
  end

  it "confirms through the Aggregate inside one transaction" do
    order = persisted_draft
    repository.seed(order)
    use_case = Orders::Application::UseCases::Confirm.new(
      order_repository: repository,
      audit_log: audit_log,
      unit_of_work: unit_of_work,
      payment_window: Orders::Domain::ValueObjects::PaymentWindow.new(300),
      clock: -> { now }
    )

    result = use_case.call(
      order_id: order.id.to_s,
      actor_id: order.created_by_actor_id,
      idempotency_key: "confirm-1",
      expected_version: 0
    )

    expect(result).to have_attributes(replayed: false)
    expect(result.order.status).to eq("confirmed")
    expect(repository.saves).to contain_exactly(order)
    expect(audit_log.events.map(&:first)).to eq([ :confirmed ])
    expect(unit_of_work.calls).to eq(1)
  end

  it "samples confirmation decision time after the Order lock" do
    order = persisted_draft
    repository.seed(order)
    sequence = []
    repository.sequence = sequence
    lock_reached = Queue.new
    release_lock = Queue.new
    repository.before_lock_return = -> do
      lock_reached << true
      release_lock.pop
    end
    decision_time = now + 30
    use_case = Orders::Application::UseCases::Confirm.new(
      order_repository: repository,
      audit_log: audit_log,
      unit_of_work: unit_of_work,
      payment_window: Orders::Domain::ValueObjects::PaymentWindow.new(300),
      clock: -> { sequence << :clock; decision_time }
    )

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
    result = worker.value

    expect(sequence).to eq(%i[order_lock clock])
    expect(result.order).to have_attributes(
      confirmed_at: decision_time,
      payment_expires_at: decision_time + 300
    )
    expect(audit_log.events.last.last.fetch(:now)).to eq(decision_time)
  end

  it "locks Order before obtaining the Payment fact for Hold" do
    order = persisted_draft
    order.confirm(
      idempotency_key: "confirm-1",
      expected_version: 0,
      now: now,
      payment_window: Orders::Domain::ValueObjects::PaymentWindow.new(300)
    )
    repository.seed(order)
    sequence = []
    repository.sequence = sequence
    payments.sequence = sequence
    use_case = Orders::Application::UseCases::Hold.new(
      order_repository: repository,
      payment_gateway: payments,
      audit_log: audit_log,
      unit_of_work: unit_of_work
    )

    result = use_case.call(
      order_id: order.id.to_s,
      actor_id: order.created_by_actor_id,
      reason: "Review",
      idempotency_key: "hold-1",
      expected_version: 0,
      now: now + 60
    )

    expect(result.order.status).to eq("held")
    expect(sequence).to eq(%i[order_lock payment_lock])
    expect(audit_log.events.map(&:first)).to eq([ :held ])
  end

  it "expires eligible candidates in repository order and filters paid Orders" do
    first = confirmed_order("0d13889c-916c-43e7-8f25-f21e19b6ef71")
    paid = confirmed_order("1e7d54a0-9a21-4bec-978f-032df0eb8bb9")
    repository.seed(first)
    repository.seed(paid)
    repository.candidates = [ first.id.to_s, paid.id.to_s ]
    payments.statuses[paid.id.to_s] = "fully_paid"
    use_case = Orders::Application::UseCases::ExpirePending.new(
      order_repository: repository,
      payment_gateway: payments,
      audit_log: audit_log,
      unit_of_work: unit_of_work
    )

    result = use_case.call(now: now + 300)

    expect(result.expired_order_ids).to eq([ first.id.to_s ])
    expect(first.status).to eq("expired")
    expect(paid.status).to eq("confirmed")
    expect(audit_log.events.map(&:first)).to eq([ :expired ])
  end

  it "keeps each explicit fake adapter complete against its Application port" do
    {
      Orders::Application::Ports::OrderRepository => InMemoryOrderRepository,
      Orders::Application::Ports::PaymentGateway => PaymentGatewayFake,
      Orders::Application::Ports::AuditLog => AuditLogFake,
      Orders::Application::Ports::UnitOfWork => UnitOfWorkFake
    }.each do |port, fake|
      expect(fake.instance_methods(false)).to include(*port.instance_methods(false)),
        "#{fake} must explicitly implement every #{port} operation"
      expect(port_contract_violations(port, fake)).to be_empty
    end
  end

  it "detects a same-name fake operation with an incompatible signature" do
    incompatible = Class.new(PaymentGatewayFake) do
      def create_target(order_id:)
        order_id
      end
    end

    expect(port_contract_violations(Orders::Application::Ports::PaymentGateway, incompatible))
      .to include(/create_target signature/)
  end

  def create_draft_use_case
    Orders::Application::UseCases::CreateDraft.new(
      order_repository: repository,
      payment_gateway: payments,
      audit_log: audit_log,
      unit_of_work: unit_of_work,
      id_generator: -> { "0d13889c-916c-43e7-8f25-f21e19b6ef71" },
      order_number_generator: -> { "AF-TEST" }
    )
  end

  def port_contract_violations(port, adapter)
    port.public_instance_methods(false).filter_map do |operation|
      unless adapter.public_method_defined?(operation)
        next "#{operation} must be public"
      end

      expected = normalized_parameters(port.instance_method(operation))
      actual = normalized_parameters(adapter.instance_method(operation))
      "#{operation} signature expected #{expected.inspect}, got #{actual.inspect}" unless actual == expected
    end
  end

  def normalized_parameters(method)
    method.parameters.map do |kind, name|
      %i[req opt rest keyrest block].include?(kind) ? [ kind ] : [ kind, name ]
    end
  end

  def draft_attributes
    {
      actor_id: "e75b9410-c367-490b-bb05-fd0bd86a54ba",
      branch_id: "d4a98431-609d-4b50-92f5-c973aec268db",
      channel: "takeaway",
      total_amount: 80_000,
      currency_code: "VND",
      idempotency_key: "create-1",
      now: now
    }
  end

  def persisted_draft(id = "0d13889c-916c-43e7-8f25-f21e19b6ef71")
    Orders::Domain::Aggregates::Order.new(
      id: id,
      branch_id: draft_attributes.fetch(:branch_id),
      created_by_actor_id: draft_attributes.fetch(:actor_id),
      order_number: "AF-TEST",
      channel: "takeaway",
      status: "draft",
      total: Orders::Domain::ValueObjects::Money.new(amount: 80_000, currency_code: "VND"),
      creation_idempotency_key: "create-1",
      creation_request_fingerprint: "a" * 64,
      lock_version: 0,
      created_at: now,
      updated_at: now
    )
  end

  def confirmed_order(id)
    order = persisted_draft(id)
    order.confirm(
      idempotency_key: "confirm-#{id}",
      expected_version: 0,
      now: now,
      payment_window: Orders::Domain::ValueObjects::PaymentWindow.new(300)
    )
    order
  end

  class InMemoryOrderRepository
    include Orders::Application::Ports::OrderRepository
    attr_accessor :before_lock_return, :candidates, :sequence
    attr_reader :additions, :saves

    def initialize
      @orders = {}
      @additions = []
      @saves = []
      @candidates = []
    end

    def seed(order)
      @orders[order.id.to_s] = order
    end

    def find_by_creation_key(branch_id:, idempotency_key:)
      @orders.values.find do |order|
        order.branch_id == branch_id && order.creation_idempotency_key == idempotency_key
      end
    end

    def add(order)
      seed(order)
      additions << order
    end

    def validate_draft_attributes!(**attributes)
      @validated_draft_attributes = attributes
    end

    def lock(order_id)
      sequence&.push(:order_lock)
      before_lock_return&.call
      @orders.fetch(order_id)
    end

    def save(order)
      seed(order)
      saves << order
    end

    def expiration_candidate_ids(now:)
      candidates
    end
  end

  class PaymentGatewayFake
    include Orders::Application::Ports::PaymentGateway
    Snapshot = Data.define(:reference_id, :funding_status) do
      def unpaid?
        funding_status == "unpaid"
      end
    end

    attr_accessor :sequence
    attr_reader :created_targets, :statuses

    def initialize
      @created_targets = []
      @statuses = Hash.new("unpaid")
    end

    def create_target(order_id:, amount:, currency_code:, now:)
      created_targets << [ order_id, amount, currency_code, now ]
      "payment-1"
    end

    def reference_for_order(order_id:)
      "payment-1"
    end

    def lock_snapshot(order_id:)
      sequence&.push(:payment_lock)
      Snapshot.new(reference_id: "payment-1", funding_status: statuses[order_id])
    end
  end

  class AuditLogFake
    include Orders::Application::Ports::AuditLog
    attr_reader :events

    def initialize
      @events = []
    end

    %i[created confirmed held expired].each do |event|
      define_method("order_#{event}") { |**attributes| events << [ event, attributes ] }
    end
  end

  class UnitOfWorkFake
    include Orders::Application::Ports::UnitOfWork
    attr_reader :calls

    def initialize
      @calls = 0
    end

    def call
      @calls += 1
      yield
    end
  end
end
