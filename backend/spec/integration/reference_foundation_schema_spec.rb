require "rails_helper"

whitespace_values = {
  "null" => nil,
  "empty string" => "",
  "ordinary spaces" => "   ",
  "horizontal tabs" => "\t\t",
  "line feeds" => "\n\n",
  "carriage returns" => "\r\r",
  "form feeds" => "\f\f",
  "vertical tabs" => "\v\v",
  "mixed defined whitespace" => " \t\n\r\f\v"
}.freeze

constrained_fields = {
  "Organization name" => [ :organization, :name ],
  "Brand name" => [ :brand, :name ],
  "Branch name" => [ :branch, :name ],
  "Branch timezone_name" => [ :branch, :timezone_name ]
}.freeze

RSpec.describe "A1 reference foundation schema" do
  let(:organization_record_class) { Organization::Infrastructure::Persistence::OrganizationRecord }
  let(:brand_record_class) { Organization::Infrastructure::Persistence::BrandRecord }
  let(:branch_record_class) { Organization::Infrastructure::Persistence::BranchRecord }

  it "defines the exact empty Organization, Brand, and Branch tables" do
    expect(table_shape("organizations")).to include(
      "id" => [ :uuid, nil, false, "gen_random_uuid()" ],
      "name" => [ :string, 200, false, nil ],
      "lock_version" => [ :integer, 4, false, nil ],
      "created_at" => [ :datetime, nil, false, nil ],
      "updated_at" => [ :datetime, nil, false, nil ]
    )
    expect(table_shape("brands")).to include(
      "id" => [ :uuid, nil, false, "gen_random_uuid()" ],
      "organization_id" => [ :uuid, nil, false, nil ],
      "name" => [ :string, 200, false, nil ],
      "lock_version" => [ :integer, 4, false, nil ],
      "created_at" => [ :datetime, nil, false, nil ],
      "updated_at" => [ :datetime, nil, false, nil ]
    )
    expect(table_shape("branches")).to include(
      "id" => [ :uuid, nil, false, "gen_random_uuid()" ],
      "brand_id" => [ :uuid, nil, false, nil ],
      "name" => [ :string, 200, false, nil ],
      "timezone_name" => [ :string, 100, false, nil ],
      "lock_version" => [ :integer, 4, false, nil ],
      "created_at" => [ :datetime, nil, false, nil ],
      "updated_at" => [ :datetime, nil, false, nil ]
    )

    %w[organizations brands branches].each do |table|
      timestamps = ActiveRecord::Base.connection.columns(table).index_by(&:name)
      expect(timestamps.fetch("created_at").sql_type).to eq("timestamp(6) with time zone")
      expect(timestamps.fetch("updated_at").sql_type).to eq("timestamp(6) with time zone")
      expect(timestamps.fetch("lock_version").default).to eq("0")
      expect(ActiveRecord::Base.connection.select_value("SELECT COUNT(*) FROM #{table}")).to eq(0)
    end
  end

  it "uses the approved names and immediate restrictive foreign-key semantics" do
    constraints = reference_constraints

    expect(constraints.fetch("organizations_pkey")).to include("contype" => "p")
    expect(constraints.fetch("brands_pkey")).to include("contype" => "p")
    expect(constraints.fetch("branches_pkey")).to include("contype" => "p")

    expect(constraints.fetch("fk_brands_organization")).to include(
      "contype" => "f", "confdeltype" => "r", "confupdtype" => "a", "condeferrable" => false
    )
    expect(constraints.fetch("fk_branches_brand")).to include(
      "contype" => "f", "confdeltype" => "r", "confupdtype" => "a", "condeferrable" => false
    )

    %w[
      organizations_name_nonblank
      brands_name_nonblank
      branches_name_nonblank
      branches_timezone_name_nonblank
    ].each do |constraint_name|
      definition = constraints.fetch(constraint_name).fetch("definition")
      expect(definition).to include("chr(32)", "chr(9)", "chr(10)", "chr(13)", "chr(12)", "chr(11)")
    end

    expect(index_names("brands")).to include("index_brands_on_organization_id")
    expect(index_names("branches")).to include("index_branches_on_brand_id")
  end

  it "rejects null required parent references at the database boundary" do
    expect_database_rejection { insert_brand(organization_id: nil) }
    expect_database_rejection { insert_branch(brand_id: nil) }
  end

  it "rejects orphan parent references at the database boundary" do
    expect_database_rejection { insert_brand(organization_id: SecureRandom.uuid) }
    expect_database_rejection { insert_branch(brand_id: SecureRandom.uuid) }
  end

  it "prevents deleting referenced parents through PostgreSQL RESTRICT foreign keys" do
    brand = create(:brand_record)
    branch = create(:branch_record, brand: brand)

    expect_database_rejection { organization_record_class.where(id: brand.organization_id).delete_all }
    expect_database_rejection { brand_record_class.where(id: branch.brand_id).delete_all }
  end

  constrained_fields.each do |label, (record_type, field)|
    whitespace_values.each do |whitespace_label, value|
      it "rejects #{whitespace_label} in #{label} through the database check" do
        expect_database_rejection { insert_reference(record_type, field => value) }
      end
    end
  end

  it "accepts content with leading and trailing defined whitespace" do
    organization_id = insert_organization(name: " \tTest Organization\n")
    brand_id = insert_brand(organization_id: organization_id, name: "\rTest Brand\f")

    expect do
      insert_branch(brand_id: brand_id, name: "\vTest Branch ", timezone_name: " UTC\t")
    end.not_to raise_error
  end

  def table_shape(table)
    ActiveRecord::Base.connection.columns(table).to_h do |column|
      [ column.name, [ column.type, column.limit, column.null, column.default_function ] ]
    end
  end

  def reference_constraints
    ActiveRecord::Base.connection.select_all(<<~SQL).to_a.index_by { |row| row.fetch("conname") }
      SELECT conname, contype, confdeltype, confupdtype, condeferrable,
             pg_get_constraintdef(oid) AS definition
      FROM pg_constraint
      WHERE conrelid IN (
        'organizations'::regclass,
        'brands'::regclass,
        'branches'::regclass
      )
    SQL
  end

  def index_names(table)
    ActiveRecord::Base.connection.indexes(table).map(&:name)
  end

  def expect_database_rejection(&)
    expect do
      ApplicationRecord.transaction(requires_new: true, &)
    end.to raise_error(ActiveRecord::StatementInvalid)
  end

  def insert_reference(record_type, overrides)
    case record_type
    when :organization then insert_organization(**overrides)
    when :brand then insert_brand(**overrides)
    when :branch then insert_branch(**overrides)
    end
  end

  def insert_organization(name: "Test Organization")
    id = SecureRandom.uuid
    organization_record_class.insert_all!([ timestamped(id: id, name: name) ])
    id
  end

  def insert_brand(organization_id: insert_organization, name: "Test Brand")
    id = SecureRandom.uuid
    brand_record_class.insert_all!([ timestamped(id: id, organization_id: organization_id, name: name) ])
    id
  end

  def insert_branch(brand_id: insert_brand, name: "Test Branch", timezone_name: "UTC")
    id = SecureRandom.uuid
    branch_record_class.insert_all!([
      timestamped(id: id, brand_id: brand_id, name: name, timezone_name: timezone_name)
    ])
    id
  end

  def timestamped(attributes)
    attributes.merge(created_at: Time.current, updated_at: Time.current)
  end
end
