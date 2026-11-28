require "rails_helper"

RSpec.describe Preparation::Infrastructure::Persistence::ActiveRecordPreparationStatusReader do
  let(:contracts) { Preparation::Application::Contracts }
  let(:branch_id) { "11111111-1111-4111-8111-111111111111" }
  let(:order_id) { "22222222-2222-4222-8222-222222222222" }
  let(:other_branch_id) { "55555555-5555-4555-8555-555555555555" }

  it "reads only the exact Order inside the exact Branch with one query" do
    dispatch = create_dispatch(branch_id: branch_id, order_id: order_id)
    observed_sql = []
    subscriber = lambda do |_name, _started, _finished, _unique_id, payload|
      sql = payload.fetch(:sql).strip
      observed_sql << sql if payload.fetch(:name) != "SCHEMA" && sql.match?(/\ASELECT\b/i)
    end

    result = ActiveSupport::Notifications.subscribed(subscriber, "sql.active_record") do
      described_class.new.find(
        branch_reference: contracts::BranchReference.new(branch_id),
        order_reference: contracts::OrderReference.new(order_id)
      )
    end

    expect(result).to be_found
    expect(result.fact.id).to eq(dispatch.id)
    expect(result.fact).not_to be_a(ActiveRecord::Base)
    expect(observed_sql.length).to eq(1)
  end

  it "returns not_found rather than leaking an Order from another Branch" do
    create_dispatch(branch_id: branch_id, order_id: order_id)

    result = described_class.new.find(
      branch_reference: contracts::BranchReference.new(other_branch_id),
      order_reference: contracts::OrderReference.new(order_id)
    )

    expect(result).to be_not_found
  end

  it "rejects cross-type input before persistence" do
    expect do
      described_class.new.find(
        branch_reference: contracts::OrderReference.new(order_id),
        order_reference: contracts::BranchReference.new(branch_id)
      )
    end.to raise_error(ArgumentError, /branch_reference/)
  end

  def create_dispatch(branch_id:, order_id:)
    payment_id = SecureRandom.uuid
    Orders::Infrastructure::Persistence::OrderRecord.create!(
      id: order_id,
      branch_id: branch_id,
      created_by_actor_id: SecureRandom.uuid,
      order_number: "AF-#{SecureRandom.hex(6).upcase}",
      channel: "takeaway",
      status: "draft",
      total_amount: 80_000,
      currency_code: "VND",
      creation_idempotency_key: SecureRandom.uuid,
      creation_request_fingerprint: Digest::SHA256.hexdigest(SecureRandom.uuid)
    )
    Payments::Infrastructure::Persistence::PaymentRecord.create!(
      id: payment_id,
      order_id: order_id,
      funding_status: "unpaid",
      attempt_activity: "idle",
      target_amount: 80_000,
      successful_amount: 0,
      refunded_amount: 0,
      currency_code: "VND"
    )
    Preparation::Infrastructure::Persistence::DispatchRecord.create!(
      order_id: order_id,
      payment_id: payment_id,
      branch_id: branch_id,
      status: "pending",
      idempotency_key: SecureRandom.uuid,
      requested_at: Time.current
    )
  end
end
