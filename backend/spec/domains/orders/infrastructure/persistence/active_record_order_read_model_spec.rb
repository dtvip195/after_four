require "rails_helper"

RSpec.describe Orders::Infrastructure::Persistence::ActiveRecordOrderReadModel do
  let(:branch_reference_class) { Orders::Application::Contracts::BranchReference }
  let(:branch_id) { "11111111-1111-4111-8111-111111111111" }
  let(:other_branch_id) { "22222222-2222-4222-8222-222222222222" }
  let(:failure_reference_value) { "33333333-3333-4333-8333-333333333333" }

  it "reads only the exact Branch and status with stable pagination and bounded queries" do
    older = create_order(branch_id: branch_id, status: "draft", updated_at: 2.minutes.ago)
    newer = create_order(branch_id: branch_id, status: "draft", updated_at: 1.minute.ago)
    create_order(branch_id: branch_id, status: "cancelled")
    create_order(branch_id: other_branch_id, status: "draft")
    observed_sql = []
    subscriber = lambda do |_name, _started, _finished, _unique_id, payload|
      sql = payload.fetch(:sql).strip
      observed_sql << sql if payload.fetch(:name) != "SCHEMA" && sql.match?(/\ASELECT\b/i)
    end

    result = ActiveSupport::Notifications.subscribed(subscriber, "sql.active_record") do
      described_class.new.list(
        branch_reference: branch_reference_class.new(branch_id), status: "draft", offset: 0, limit: 10
      )
    end

    expect(result).to be_found
    expect(result.total).to eq(2)
    expect(result.facts.map(&:id)).to eq([ newer.id, older.id ])
    expect(result.facts.map(&:branch_id).uniq).to eq([ branch_id ])
    expect(result.facts).to all(be_a(Orders::Application::Ports::OrderReadModel::Fact))
    expect(observed_sql.length).to eq(2)
  end

  it "returns a found empty page for an absent exact Branch" do
    result = described_class.new.list(
      branch_reference: branch_reference_class.new(branch_id), status: nil, offset: 0, limit: 10
    )

    expect(result).to be_found
    expect(result.facts).to eq([])
    expect(result.total).to eq(0)
  end

  it "finds only an exact Order inside the exact Branch" do
    order = create_order(branch_id: branch_id, status: "draft")

    found = described_class.new.find(
      branch_reference: branch_reference_class.new(branch_id),
      order_reference: Orders::Application::Contracts::OrderReference.new(order.id)
    )
    hidden = described_class.new.find(
      branch_reference: branch_reference_class.new(other_branch_id),
      order_reference: Orders::Application::Contracts::OrderReference.new(order.id)
    )

    expect(found).to be_found
    expect(found.fact.id).to eq(order.id)
    expect(hidden).to be_not_found
  end

  it "rejects untyped and structurally invalid inputs before persistence access" do
    reader = described_class.new

    expect do
      reader.list(branch_reference: branch_id, status: nil, offset: 0, limit: 10)
    end.to raise_error(ArgumentError, /branch_reference/)
    expect do
      reader.list(
        branch_reference: branch_reference_class.new(branch_id), status: "unknown", offset: 0, limit: 10
      )
    end.to raise_error(ArgumentError, /status/)
  end

  it "maps only narrow availability failures and lets SQL defects propagate" do
    recognized = ActiveRecord::ConnectionTimeoutError.new("pool unavailable")
    result = reader_raising(recognized).list(
      branch_reference: branch_reference_class.new(branch_id), status: nil, offset: 0, limit: 10
    )

    expect(result).to be_unavailable
    expect(result.failure_reference.value).to eq(failure_reference_value)

    rejected = ActiveRecord::StatementInvalid.new("bad SQL")
    expect do
      reader_raising(rejected).list(
        branch_reference: branch_reference_class.new(branch_id), status: nil, offset: 0, limit: 10
      )
    end.to raise_error(ActiveRecord::StatementInvalid, "bad SQL")
  end

  def create_order(branch_id:, status:, updated_at: Time.current)
    Orders::Infrastructure::Persistence::OrderRecord.create!(
      branch_id: branch_id,
      created_by_actor_id: SecureRandom.uuid,
      order_number: "AF-#{SecureRandom.hex(6).upcase}",
      channel: "takeaway",
      status: status,
      total_amount: 80_000,
      currency_code: "VND",
      creation_idempotency_key: SecureRandom.uuid,
      creation_request_fingerprint: Digest::SHA256.hexdigest(SecureRandom.uuid),
      created_at: updated_at - 1.minute,
      updated_at: updated_at
    )
  end

  def reader_raising(error)
    record_class = class_double(Orders::Infrastructure::Persistence::OrderRecord)
    allow(record_class).to receive(:where).and_raise(error)
    described_class.new(
      record_class: record_class,
      failure_reference_generator: -> { failure_reference_value }
    )
  end
end
