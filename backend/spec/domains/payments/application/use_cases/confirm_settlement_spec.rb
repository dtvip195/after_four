require "rails_helper"

RSpec.describe Payments::Application::UseCases::ConfirmSettlement do
  class InMemoryPaymentRepository
    include Payments::Application::Ports::PaymentRepository

    attr_reader :payment, :saved_payment

    def initialize(payment)
      @payment = payment
    end

    def lock_by_order_id(order_id)
      raise "wrong order" unless order_id == payment.order_id

      payment
    end

    def save(payment)
      @saved_payment = payment
    end
  end

  class InMemoryOrderGateway
    attr_reader :order

    def initialize(order)
      @order = order
    end

    def lock(order_id)
      raise "wrong order" unless order_id.to_s == order.id.to_s

      order
    end

    def save(order)
      @order = order
    end
  end

  class InMemoryPreparationGateway
    include Preparation::Application::Ports::SettlementDispatchGateway

    attr_reader :dispatch

    def find_by_order_id(order_id)
      dispatch if dispatch&.order_id == order_id
    end

    def request_for_settlement(order_id:, payment_id:, branch_id:, now:)
      @dispatch = Snapshot.new(
        id: SecureRandom.uuid,
        order_id: order_id,
        payment_id: payment_id,
        branch_id: branch_id,
        status: "pending"
      )
    end
  end

  class InMemoryReviewCaseGateway
    include Payments::Application::Ports::ReviewCaseGateway

    def find_by_attempt_id(_payment_attempt_id)
      nil
    end

    def open_late_success(**)
      raise "late-success route was not expected"
    end
  end

  class RecordingPaymentAuditLog
    include Payments::Application::Ports::AuditLog

    attr_reader :confirmed_attempt

    def amount_mismatch(**)
      raise "amount-mismatch route was not expected"
    end

    def payment_confirmed(attempt:, **)
      @confirmed_attempt = attempt
    end
  end

  class InMemoryPaymentUnitOfWork
    include Payments::Application::Ports::UnitOfWork

    def call(&block)
      block.call
    end
  end

  it "coordinates an eligible settlement through context-owned ports and returns Domain objects" do
    now = Time.utc(2026, 11, 26, 9, 0, 0)
    order = confirmed_order(now: now)
    payment = unpaid_payment(order: order, now: now)
    payment_repository = InMemoryPaymentRepository.new(payment)
    preparation_gateway = InMemoryPreparationGateway.new
    audit_log = RecordingPaymentAuditLog.new
    attempt_id = SecureRandom.uuid

    result = described_class.new(
      order_gateway: InMemoryOrderGateway.new(order),
      payment_repository: payment_repository,
      preparation_gateway: preparation_gateway,
      review_case_gateway: InMemoryReviewCaseGateway.new,
      audit_log: audit_log,
      unit_of_work: InMemoryPaymentUnitOfWork.new,
      id_generator: -> { attempt_id },
      clock: -> { now + 60 }
    ).call(
      method: "cash",
      order_id: order.id.to_s,
      actor_id: order.created_by_actor_id,
      amount: 80_000,
      currency_code: "VND",
      idempotency_key: "application-cash"
    )

    expect(result.payment).to equal(payment_repository.saved_payment)
    expect(result.payment_attempt).to equal(audit_log.confirmed_attempt)
    expect(result.payment_attempt).to have_attributes(id: Payments::Domain::ValueObjects::PaymentAttemptId.new(attempt_id))
    expect(result.payment).to have_attributes(funding_status: "fully_paid", successful_amount: 80_000)
    expect(result.preparation_dispatch).to equal(preparation_gateway.dispatch)
    expect(result).to have_attributes(review_case: nil, replayed: false)
  end

  def confirmed_order(now:)
    Orders::Domain::Aggregates::Order.new(
      id: SecureRandom.uuid,
      branch_id: SecureRandom.uuid,
      created_by_actor_id: SecureRandom.uuid,
      order_number: "AF-1234567890AB",
      channel: "takeaway",
      status: "confirmed",
      total: Orders::Domain::ValueObjects::Money.new(amount: 80_000, currency_code: "VND"),
      creation_idempotency_key: "create-application-payment",
      creation_request_fingerprint: "a" * 64,
      confirmation_idempotency_key: "confirm-application-payment",
      confirmed_at: now,
      payment_expires_at: now + 300,
      lock_version: 1,
      created_at: now - 60,
      updated_at: now
    )
  end

  def unpaid_payment(order:, now:)
    Payments::Domain::Aggregates::Payment.new(
      id: SecureRandom.uuid,
      order_id: order.id.to_s,
      funding_status: "unpaid",
      attempt_activity: "idle",
      target: Payments::Domain::ValueObjects::Money.new(amount: 80_000, currency_code: "VND"),
      successful_amount: 0,
      refunded_amount: 0,
      fully_settled_at: nil,
      lock_version: 0,
      attempts: [],
      created_at: now - 60,
      updated_at: now - 60
    )
  end
end
