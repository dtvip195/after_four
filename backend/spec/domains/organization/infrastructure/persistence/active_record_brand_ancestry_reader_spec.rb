require "rails_helper"

RSpec.describe Organization::Infrastructure::Persistence::ActiveRecordBrandAncestryReader do
  let(:brand_reference_class) { Organization::Application::Contracts::BrandReference }
  let(:failure_reference_value) { "33333333-3333-3333-3333-333333333333" }

  it "resolves authoritative Brand ancestry through real PostgreSQL records" do
    brand = create(:brand_record)
    reader = described_class.new
    observed_sql = []

    subscriber = lambda do |_name, _started, _finished, _unique_id, payload|
      sql = payload.fetch(:sql).strip
      observed_sql << sql if payload.fetch(:name) != "SCHEMA" && sql.match?(/\ASELECT\b/i)
    end
    result = ActiveSupport::Notifications.subscribed(subscriber, "sql.active_record") do
      reader.read(brand_reference_class.new(brand.id))
    end

    expect(result).to be_found
    expect(result.fact.brand_id.value).to eq(brand.id)
    expect(result.fact.organization_id.value).to eq(brand.organization_id)
    expect(result.fact).not_to be_a(ActiveRecord::Base)
    expect(observed_sql.length).to eq(1)
    expect(observed_sql.fetch(0)).to match(/FROM\s+"brands"/i)
    expect(observed_sql.fetch(0)).to match(/LEFT\s+OUTER\s+JOIN\s+"organizations"/i)
  end

  it "returns not_found for an absent Brand" do
    reference = brand_reference_class.new("11111111-1111-1111-1111-111111111111")

    expect(described_class.new.read(reference)).to be_not_found
  end

  it "does not fall back to a Brand or Organization other than the exact requested Brand" do
    first_brand = create(:brand_record)
    second_brand = create(:brand_record)

    result = described_class.new.read(brand_reference_class.new(second_brand.id))

    expect(result).to be_found
    expect(result.fact.brand_id.value).to eq(second_brand.id)
    expect(result.fact.organization_id.value).to eq(second_brand.organization_id)
    expect(result.fact.organization_id.value).not_to eq(first_brand.organization_id)
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

      result = reader.read(brand_reference_class.new("11111111-1111-1111-1111-111111111111"))

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
        reader.read(brand_reference_class.new("11111111-1111-1111-1111-111111111111"))
      end.to raise_error(error.class, error.message)
    end
  end

  it "observes PostgreSQL statement_timeout as ambiguous QueryCanceled rather than StatementTimeout" do
    timeout_error = nil

    begin
      ActiveRecord::Base.transaction(requires_new: true) do
        ActiveRecord::Base.connection.execute("SET LOCAL statement_timeout = '5ms'")
        ActiveRecord::Base.connection.execute("SELECT pg_sleep(0.05)")
      end
    rescue ActiveRecord::QueryCanceled => error
      timeout_error = error
    end

    expect(timeout_error).to be_a(ActiveRecord::QueryCanceled)
    expect(timeout_error).not_to be_a(ActiveRecord::StatementTimeout)
    expect do
      reader_raising(timeout_error).read(
        brand_reference_class.new("11111111-1111-1111-1111-111111111111")
      )
    end.to raise_error(ActiveRecord::QueryCanceled)
  end

  it "maps completed malformed scalar facts to inconsistent without hiding programming defects" do
    reference = brand_reference_class.new("11111111-1111-1111-1111-111111111111")

    expect(reader_returning([ reference.value, nil, nil ]).read(reference)).to be_inconsistent
    expect(
      reader_returning(
        [ reference.value, "22222222-2222-2222-2222-222222222222", "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa" ]
      ).read(reference)
    ).to be_inconsistent

    expect do
      reader_raising(ArgumentError.new("unexpected implementation defect")).read(reference)
    end.to raise_error(ArgumentError, "unexpected implementation defect")
  end

  def reader_raising(error)
    failing_record_class = class_double(Organization::Infrastructure::Persistence::BrandRecord)
    allow(failing_record_class).to receive(:left_outer_joins).with(:organization).and_raise(error)

    described_class.new(
      record_class: failing_record_class,
      failure_reference_generator: -> { failure_reference_value }
    )
  end

  def reader_returning(row)
    relation = instance_double(ActiveRecord::Relation)
    allow(relation).to receive(:where).and_return(relation)
    allow(relation).to receive(:pick).and_return(row)

    record_class = class_double(Organization::Infrastructure::Persistence::BrandRecord)
    allow(record_class).to receive(:left_outer_joins).with(:organization).and_return(relation)

    described_class.new(record_class: record_class)
  end
end
