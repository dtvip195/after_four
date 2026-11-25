require_relative "../../../../../app/contexts/orders/domain/errors/rule_violation"
require_relative "../../../../../app/contexts/orders/domain/value_objects/order_id"
require_relative "../../../../../app/contexts/orders/domain/value_objects/order_number"
require_relative "../../../../../app/contexts/orders/domain/value_objects/money"
require_relative "../../../../../app/contexts/orders/domain/value_objects/service_channel"
require_relative "../../../../../app/contexts/orders/domain/value_objects/payment_window"
require_relative "../../../../../app/contexts/orders/domain/aggregates/order"
require_relative "../../../../../app/contexts/orders/application/errors/invalid_draft"
require_relative "../../../../../app/contexts/orders/application/input_validation"
require_relative "../../../../../app/contexts/orders/application/ports/audit_log"
require_relative "../../../../../app/contexts/orders/application/ports/order_repository"
require_relative "../../../../../app/contexts/orders/application/ports/payment_gateway"
require_relative "../../../../../app/contexts/orders/application/ports/unit_of_work"
require_relative "../../../../../app/contexts/orders/application/use_cases/create_draft"
require_relative "../../../../../app/contexts/orders/application/use_cases/confirm"
require_relative "../../../../../app/contexts/orders/application/use_cases/hold"
require_relative "../../../../../app/contexts/orders/application/use_cases/expire_pending"

module OrderingApplicationSpecSupport
  NOW = Time.utc(2026, 11, 14, 10, 0, 0)
  ACTOR_ID = "e75b9410-c367-490b-bb05-fd0bd86a54ba"
  BRANCH_ID = "d4a98431-609d-4b50-92f5-c973aec268db"
  ORDER_ID = "0d13889c-916c-43e7-8f25-f21e19b6ef71"

  def draft_attributes
    {
      actor_id: ACTOR_ID,
      branch_id: BRANCH_ID,
      channel: "takeaway",
      total_amount: 80_000,
      currency_code: "VND",
      idempotency_key: "create-1",
      now: NOW
    }
  end

  def draft_order(id: ORDER_ID, branch_id: BRANCH_ID, key: "create-1")
    Orders::Domain::Aggregates::Order.draft(
      id: id,
      branch_id: branch_id,
      created_by_actor_id: ACTOR_ID,
      order_number: "AF-TEST",
      channel: "takeaway",
      total: Orders::Domain::ValueObjects::Money.new(amount: 80_000, currency_code: "VND"),
      creation_idempotency_key: key,
      creation_request_fingerprint: "a" * 64,
      created_at: NOW
    )
  end

  def confirmed_order(id: ORDER_ID)
    order = draft_order(id: id)
    order.confirm(
      idempotency_key: "confirm-#{id}",
      expected_version: 0,
      now: NOW,
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

    def order_created(order:, actor_id:, now:)
      events << [ :created, { order: order, actor_id: actor_id, now: now } ]
    end

    def order_confirmed(order:, actor_id:, now:)
      events << [ :confirmed, { order: order, actor_id: actor_id, now: now } ]
    end

    def order_held(order:, actor_id:, reason:, now:)
      events << [ :held, { order: order, actor_id: actor_id, reason: reason, now: now } ]
    end

    def order_expired(order:, now:)
      events << [ :expired, { order: order, now: now } ]
    end
  end

  class UnitOfWorkFake
    include Orders::Application::Ports::UnitOfWork
    attr_reader :calls

    def initialize
      @calls = 0
    end

    def call(&block)
      @calls += 1
      block.call
    end
  end
end
