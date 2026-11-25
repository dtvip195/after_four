require "rails_helper"

RSpec.describe "payment database integrity under concurrency", :concurrency do
  self.use_transactional_tests = false

  it "serializes concurrent succeeded totals and rejects the overfunded aggregate" do
    order = create_order
    payment = payment_for(order)
    ready = Queue.new
    start = Queue.new

    threads = 2.times.map do |index|
      Thread.new do
        ActiveRecord::Base.connection_pool.with_connection do
          ready << true
          start.pop
          begin
            Payment.transaction do
              insert_attempt(payment, index)
              Payment.where(id: payment.id).update_all(
                funding_status: "fully_paid",
                successful_amount: payment.target_amount
              )
            end
            :committed
          rescue ActiveRecord::StatementInvalid => error
            error
          end
        end
      end
    end
    2.times { ready.pop }
    2.times { start << true }
    results = threads.map(&:value)

    expect(results.count(:committed)).to eq(1)
    expect(results.count { |result| result.is_a?(ActiveRecord::StatementInvalid) }).to eq(1)
    expect(payment.reload).to have_attributes(funding_status: "fully_paid", successful_amount: 80_000)
    expect(payment.payment_attempts.where(status: "succeeded").count).to eq(1)
  ensure
    threads&.each(&:join)
    cleanup_order(order)
  end

  def create_order
    create_order_draft_record(
      actor_id: SecureRandom.uuid,
      branch_id: SecureRandom.uuid,
      channel: "takeaway",
      total_amount: 80_000,
      currency_code: "VND",
      idempotency_key: "database-integrity-concurrency-#{SecureRandom.uuid}",
      now: Time.utc(2026, 11, 14, 10, 0, 0)
    )
  end

  def insert_attempt(payment, index)
    now = Time.utc(2026, 11, 14, 10, 1, index)
    PaymentAttempt.insert_all!([ {
      id: SecureRandom.uuid,
      payment_id: payment.id,
      method: "cash",
      status: "succeeded",
      requested_amount: payment.target_amount,
      confirmed_amount: payment.target_amount,
      currency_code: payment.currency_code,
      idempotency_key: "database-integrity-concurrent-#{index}",
      confirmed_by_actor_id: SecureRandom.uuid,
      confirmed_at: now,
      failure_code: nil,
      created_at: now,
      updated_at: now
    } ])
  end

  def cleanup_order(order)
    return unless order&.persisted?

    Payment.transaction do
      payment_ids = Payment.where(order_id: order.id).pluck(:id)
      PaymentAttempt.where(payment_id: payment_ids).delete_all
      Payment.where(id: payment_ids).delete_all
      Orders::Infrastructure::Persistence::OrderRecord.where(id: order.id).delete_all
    end
  end
end
