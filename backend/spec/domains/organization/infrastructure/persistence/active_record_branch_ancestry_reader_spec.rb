require "rails_helper"

RSpec.describe Organization::Infrastructure::Persistence::ActiveRecordBranchAncestryReader do
  let(:branch_reference_class) { Organization::Application::Contracts::BranchReference }
  let(:failure_reference_value) { "55555555-5555-5555-5555-555555555555" }

  it "resolves authoritative Branch ancestry through one real PostgreSQL query" do
    branch = create(:branch_record)
    reader = described_class.new
    observed_sql = []

    subscriber = lambda do |_name, _started, _finished, _unique_id, payload|
      sql = payload.fetch(:sql).strip
      observed_sql << sql if payload.fetch(:name) != "SCHEMA" && sql.match?(/\ASELECT\b/i)
    end
    result = ActiveSupport::Notifications.subscribed(subscriber, "sql.active_record") do
      reader.read(branch_reference_class.new(branch.id))
    end

    expect(result).to be_found
    expect(result.fact.branch_id.value).to eq(branch.id)
    expect(result.fact.brand_id.value).to eq(branch.brand_id)
    expect(result.fact.organization_id.value).to eq(branch.brand.organization_id)
    expect(result.fact).not_to be_a(ActiveRecord::Base)
    expect(observed_sql.length).to eq(1)
    expect(observed_sql.fetch(0)).to match(/FROM\s+"branches"/i)
    expect(observed_sql.fetch(0)).to match(/LEFT\s+OUTER\s+JOIN\s+"brands"/i)
    expect(observed_sql.fetch(0)).to match(/LEFT\s+OUTER\s+JOIN\s+"organizations"/i)
  end

  it "returns not_found for an absent Branch" do
    reference = branch_reference_class.new("11111111-1111-1111-1111-111111111111")

    expect(described_class.new.read(reference)).to be_not_found
  end

  it "does not fall back to ancestry other than the exact requested Branch" do
    first_branch = create(:branch_record)
    second_branch = create(:branch_record)

    result = described_class.new.read(branch_reference_class.new(second_branch.id))

    expect(result).to be_found
    expect(result.fact.branch_id.value).to eq(second_branch.id)
    expect(result.fact.brand_id.value).to eq(second_branch.brand_id)
    expect(result.fact.organization_id.value).to eq(second_branch.brand.organization_id)
    expect(result.fact.branch_id.value).not_to eq(first_branch.id)
  end

  it "maps only the narrow availability exception allowlist" do
    recognized_errors = [
      ActiveRecord::ConnectionTimeoutError.new("pool unavailable"),
      ActiveRecord::ExclusiveConnectionTimeoutError.new("exclusive pool unavailable"),
      ActiveRecord::ConnectionFailed.new("connection lost"),
      ActiveRecord::AdapterTimeout.new("adapter timeout"),
      ActiveRecord::StatementTimeout.new("statement timeout")
    ]

    recognized_errors.each do |error|
      reader = reader_raising(error)

      result = reader.read(branch_reference_class.new("11111111-1111-1111-1111-111111111111"))

      expect(result).to be_unavailable
      expect(result.failure_reference.value).to eq(failure_reference_value)
    end
  end

  it "does not classify configuration, authentication-ambiguous, SQL, or raw PG failures as unavailable" do
    rejected_errors = [
      ActiveRecord::DatabaseConnectionError.new("ambiguous connection setup"),
      ActiveRecord::ConnectionNotEstablished.new("unclassified connection failure"),
      ActiveRecord::ConnectionNotDefined.new("missing pool"),
      ActiveRecord::ConfigurationError.new("bad configuration"),
      ActiveRecord::StatementInvalid.new("bad SQL"),
      ActiveRecord::QueryCanceled.new("ambiguous cancellation"),
      PG::ConnectionBad.new("raw connection failure")
    ]

    rejected_errors.each do |error|
      reader = reader_raising(error)

      expect do
        reader.read(branch_reference_class.new("11111111-1111-1111-1111-111111111111"))
      end.to raise_error(error.class, error.message)
    end
  end

  it "maps completed malformed scalar facts to inconsistent without hiding programming defects" do
    reference = branch_reference_class.new("11111111-1111-1111-1111-111111111111")

    expect(reader_returning([ reference.value, nil, nil, nil, nil ]).read(reference)).to be_inconsistent
    expect(
      reader_returning(
        [
          reference.value,
          "22222222-2222-2222-2222-222222222222",
          "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
          "33333333-3333-3333-3333-333333333333",
          "bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb"
        ]
      ).read(reference)
    ).to be_inconsistent

    expect do
      reader_raising(ArgumentError.new("unexpected implementation defect")).read(reference)
    end.to raise_error(ArgumentError, "unexpected implementation defect")
  end

  def reader_raising(error)
    failing_record_class = class_double(Organization::Infrastructure::Persistence::BranchRecord)
    allow(failing_record_class).to receive(:left_outer_joins).with(brand: :organization).and_raise(error)

    described_class.new(
      record_class: failing_record_class,
      failure_reference_generator: -> { failure_reference_value }
    )
  end

  def reader_returning(row)
    relation = instance_double(ActiveRecord::Relation)
    allow(relation).to receive(:where).and_return(relation)
    allow(relation).to receive(:pick).and_return(row)

    record_class = class_double(Organization::Infrastructure::Persistence::BranchRecord)
    allow(record_class).to receive(:left_outer_joins).with(brand: :organization).and_return(relation)

    described_class.new(record_class: record_class)
  end
end
