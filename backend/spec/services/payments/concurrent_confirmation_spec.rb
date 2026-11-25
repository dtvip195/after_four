require "rails_helper"

RSpec.describe "concurrent payment confirmation", :concurrency do
  self.use_transactional_tests = false

  it "settles and creates preparation dispatch at most once" do
    actor_id = SecureRandom.uuid
    now = Time.utc(2026, 11, 14, 19, 0, 0)
    order = create_order_draft_record(
      actor_id: actor_id,
      branch_id: SecureRandom.uuid,
      channel: "takeaway",
      total_amount: 85_000,
      currency_code: "VND",
      idempotency_key: "create-concurrency-spec",
      now: now
    )
    confirm_order_record(
      order_id: order.id,
      actor_id: actor_id,
      idempotency_key: "confirm-concurrency-spec",
      expected_version: order.lock_version,
      now: now
    )
    ready = Queue.new
    start = Queue.new

    threads = 2.times.map do |index|
      Thread.new do
        ActiveRecord::Base.connection_pool.with_connection do
          ready << true
          start.pop
          begin
            PaymentComposition.confirm_cash(
              order_id: order.id,
              actor_id: actor_id,
              amount: 85_000,
              currency_code: "VND",
              idempotency_key: "concurrent-cash-#{index}",
              clock: -> { now + 1.minute }
            )
          rescue DomainError => error
            error
          end
        end
      end
    end
    2.times { ready.pop }
    2.times { start << true }
    results = threads.map(&:value)

    expect(results.count { |result| result.is_a?(Payments::Application::UseCases::ConfirmSettlement::Result) }).to eq(1)
    expect(results.grep(DomainError).map(&:code)).to contain_exactly("payment_already_fully_settled")
    expect(Payments::Infrastructure::Persistence::PaymentAttemptRecord.where(payment_id: payment_for(order).id, status: "succeeded").count).to eq(1)
    expect(PreparationDispatch.where(order_id: order.id).count).to eq(1)
    expect(OutboxEvent.where(event_type: "preparation.dispatch_requested").count).to eq(1)
  ensure
    if order&.persisted?
      Payments::Infrastructure::Persistence::PaymentRecord.transaction do
        payment_ids = Payments::Infrastructure::Persistence::PaymentRecord.where(order_id: order.id).pluck(:id)
        dispatch_ids = PreparationDispatch.where(order_id: order.id).pluck(:id)
        delete_audit_events_as_database_owner(AuditEvent.where(branch_id: order.branch_id))
        Payments::Infrastructure::Persistence::PaymentReviewCaseRecord.where(order_id: order.id).delete_all
        PreparationDispatchAttempt.where(preparation_dispatch_id: dispatch_ids).delete_all
        OutboxEvent.where(aggregate_type: "PreparationDispatch", aggregate_id: dispatch_ids).delete_all
        PreparationDispatch.where(id: dispatch_ids).delete_all
        Payments::Infrastructure::Persistence::PaymentAttemptRecord.where(payment_id: payment_ids).delete_all
        Payments::Infrastructure::Persistence::PaymentRecord.where(id: payment_ids).delete_all
        Orders::Infrastructure::Persistence::OrderRecord.where(id: order.id).delete_all
      end
    end
  end
end
