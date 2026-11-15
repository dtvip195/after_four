require "rails_helper"

RSpec.describe "Package B Catalog schema" do
  let(:brand_record_class) { Organization::Infrastructure::Persistence::BrandRecord }

  it "defines the exact empty Category, Product, and Variant tables" do
    expect(table_shape("categories")).to include(
      "id" => [ :uuid, nil, false, "gen_random_uuid()" ],
      "brand_id" => [ :uuid, nil, false, nil ],
      "code" => [ :string, 64, false, nil ],
      "name" => [ :string, 150, false, nil ],
      "position" => [ :integer, 4, false, nil ],
      "lifecycle_status" => [ :string, 16, false, nil ],
      "lock_version" => [ :integer, 4, false, nil ],
      "created_at" => [ :datetime, nil, false, nil ],
      "updated_at" => [ :datetime, nil, false, nil ]
    )
    expect(table_shape("products")).to include(
      "id" => [ :uuid, nil, false, "gen_random_uuid()" ],
      "brand_id" => [ :uuid, nil, false, nil ],
      "category_id" => [ :uuid, nil, false, nil ],
      "code" => [ :string, 64, false, nil ],
      "name" => [ :string, 200, false, nil ],
      "description" => [ :text, nil, true, nil ],
      "lifecycle_status" => [ :string, 16, false, nil ],
      "lock_version" => [ :integer, 4, false, nil ],
      "created_at" => [ :datetime, nil, false, nil ],
      "updated_at" => [ :datetime, nil, false, nil ]
    )
    expect(table_shape("product_variants")).to include(
      "id" => [ :uuid, nil, false, "gen_random_uuid()" ],
      "brand_id" => [ :uuid, nil, false, nil ],
      "product_id" => [ :uuid, nil, false, nil ],
      "code" => [ :string, 64, false, nil ],
      "name" => [ :string, 150, false, nil ],
      "position" => [ :integer, 4, false, nil ],
      "lifecycle_status" => [ :string, 16, false, nil ],
      "is_default" => [ :boolean, nil, false, nil ],
      "customer_visible" => [ :boolean, nil, false, nil ],
      "lock_version" => [ :integer, 4, false, nil ],
      "created_at" => [ :datetime, nil, false, nil ],
      "updated_at" => [ :datetime, nil, false, nil ]
    )

    expect(column("categories", "lifecycle_status").default).to eq("draft")
    expect(column("product_variants", "lifecycle_status").default).to eq("draft")
    expect(column("products", "lifecycle_status").default).to be_nil
    expect(column("product_variants", "is_default").default).to eq("false")
    expect(column("product_variants", "customer_visible").default).to eq("false")

    %w[categories products product_variants].each do |table|
      timestamps = ActiveRecord::Base.connection.columns(table).index_by(&:name)
      expect(timestamps.fetch("created_at").sql_type).to eq("timestamp(6) with time zone")
      expect(timestamps.fetch("updated_at").sql_type).to eq("timestamp(6) with time zone")
      expect(ActiveRecord::Base.connection.select_value("SELECT COUNT(*) FROM #{table}")).to eq(0)
    end
  end

  it "installs the named checks, restrictive foreign keys, and indexes" do
    constraints = catalog_constraints

    expected_checks = %w[
      categories_code_canonical
      categories_name_nonblank
      categories_position_nonnegative
      categories_lifecycle_allowed
      categories_lock_version_nonnegative
      products_code_canonical
      products_name_nonblank
      products_lifecycle_allowed
      products_lock_version_nonnegative
      product_variants_code_canonical
      product_variants_name_nonblank
      product_variants_position_nonnegative
      product_variants_lifecycle_allowed
      product_variants_lock_version_nonnegative
    ]
    expect(constraints.slice(*expected_checks).keys).to contain_exactly(*expected_checks)
    expect(expected_checks.map { |name| constraints.fetch(name).fetch("contype") }).to all(eq("c"))

    expected_foreign_keys = %w[
      fk_categories_brand
      fk_products_brand
      fk_products_category_brand
      fk_product_variants_brand
      fk_product_variants_product_brand
    ]
    expect(constraints.slice(*expected_foreign_keys).keys).to contain_exactly(*expected_foreign_keys)
    expected_foreign_keys.each do |name|
      expect(constraints.fetch(name)).to include(
        "contype" => "f", "confdeltype" => "r", "condeferrable" => false
      )
    end

    expect(index_names("categories")).to include(
      "uq_categories_id_brand",
      "uq_categories_brand_code",
      "index_categories_on_brand_status_position"
    )
    expect(index_names("products")).to include(
      "uq_products_id_brand",
      "uq_products_brand_code",
      "index_products_on_category_status"
    )
    expect(index_names("product_variants")).to include(
      "uq_product_variants_brand_code",
      "uq_product_variants_one_default",
      "index_product_variants_on_product_status_id"
    )
    default_index = ActiveRecord::Base.connection.indexes("product_variants").index_by(&:name)
      .fetch("uq_product_variants_one_default")
    expect(default_index.unique).to be(true)
    expect(default_index.where).to eq("is_default")
  end

  it "installs VOLATILE fixed-search-path functions and deferred constraint triggers" do
    functions = ActiveRecord::Base.connection.select_all(<<~SQL).to_a.index_by { |row| row.fetch("proname") }
      SELECT proname, provolatile, proconfig
      FROM pg_proc
      WHERE proname LIKE 'catalog_%'
    SQL
    expected_functions = %w[
      catalog_enforce_category_initial_status
      catalog_enforce_variant_initial_status
      catalog_reject_category_scope_change
      catalog_reject_product_scope_change
      catalog_reject_variant_scope_change
      catalog_enforce_category_transition
      catalog_enforce_variant_transition
      catalog_reject_purge
      catalog_validate_active_product_default
      catalog_validate_active_product_category
    ]
    expect(functions.slice(*expected_functions).keys).to contain_exactly(*expected_functions)
    expected_functions.each do |name|
      expect(functions.fetch(name).fetch("provolatile")).to eq("v")
      expect(functions.fetch(name).fetch("proconfig")).to include("search_path=pg_catalog, public")
    end

    triggers = ActiveRecord::Base.connection.select_all(<<~SQL).to_a.index_by { |row| row.fetch("tgname") }
      SELECT tgname, tgdeferrable, tginitdeferred
      FROM pg_trigger
      WHERE tgname LIKE 'catalog_%' AND NOT tgisinternal
    SQL
    %w[
      catalog_products_default_final_state
      catalog_product_variants_default_final_state
      catalog_categories_product_final_state
      catalog_products_category_final_state
    ].each do |name|
      expect(triggers.fetch(name)).to include("tgdeferrable" => true, "tginitdeferred" => true)
    end
  end

  it "enforces same-Brand ancestry and separate per-type Code namespaces through PostgreSQL" do
    brand = create(:brand_record)
    other_brand = create(:brand_record)

    category_id = insert_category(brand_id: brand.id, code: "COFFEE")
    product_id = insert_product(brand_id: brand.id, category_id: category_id, code: "COFFEE")
    insert_variant(brand_id: brand.id, product_id: product_id, code: "COFFEE")

    expect_constraint("uq_categories_brand_code") do
      insert_category(brand_id: brand.id, code: "COFFEE")
    end
    expect_constraint("fk_products_category_brand") do
      insert_product(brand_id: other_brand.id, category_id: category_id, code: "OTHER")
    end
    expect_constraint("fk_product_variants_product_brand") do
      insert_variant(brand_id: other_brand.id, product_id: product_id, code: "OTHER")
    end
  end

  it "rejects invalid direct-SQL field values with stable check identities" do
    brand = create(:brand_record)

    {
      "categories_code_canonical" => { code: "not canonical" },
      "categories_name_nonblank" => { name: " \t\n\r\f\v" },
      "categories_position_nonnegative" => { position: -1 },
      "categories_lock_version_nonnegative" => { lock_version: -1 }
    }.each do |constraint_name, overrides|
      expect_constraint(constraint_name) { insert_category(brand_id: brand.id, **overrides) }
    end

    category_id = insert_category(brand_id: brand.id)
    expect_constraint("products_lifecycle_allowed") do
      insert_product(
        brand_id: brand.id,
        category_id: category_id,
        code: "INVALID_STATUS_PRODUCT",
        lifecycle_status: "retired"
      )
    end
  end

  def table_shape(table)
    ActiveRecord::Base.connection.columns(table).to_h do |field|
      [ field.name, [ field.type, field.limit, field.null, field.default_function ] ]
    end
  end

  def column(table, name)
    ActiveRecord::Base.connection.columns(table).index_by(&:name).fetch(name)
  end

  def catalog_constraints
    ActiveRecord::Base.connection.select_all(<<~SQL).to_a.index_by { |row| row.fetch("conname") }
      SELECT conname, contype, confdeltype, condeferrable, pg_get_constraintdef(oid) AS definition
      FROM pg_constraint
      WHERE conrelid IN ('categories'::regclass, 'products'::regclass, 'product_variants'::regclass)
    SQL
  end

  def index_names(table)
    ActiveRecord::Base.connection.indexes(table).map(&:name)
  end

  def expect_constraint(name)
    expect do
      ApplicationRecord.transaction(requires_new: true) { yield }
    end.to raise_error(ActiveRecord::StatementInvalid) do |error|
      expect(error.cause.result.error_field(PG::Result::PG_DIAG_CONSTRAINT_NAME)).to eq(name)
    end
  end

  def insert_category(brand_id:, code: "CATEGORY", name: "Category", position: 0,
    lifecycle_status: "draft", lock_version: 0)
    id = SecureRandom.uuid
    execute_insert("categories", {
      id: id,
      brand_id: brand_id,
      code: code,
      name: name,
      position: position,
      lifecycle_status: lifecycle_status,
      lock_version: lock_version
    })
    id
  end

  def insert_product(brand_id:, category_id:, code: "PRODUCT", lifecycle_status: "draft")
    id = SecureRandom.uuid
    execute_insert("products", {
      id: id,
      brand_id: brand_id,
      category_id: category_id,
      code: code,
      name: "Product",
      lifecycle_status: lifecycle_status,
      lock_version: 0
    })
    id
  end

  def insert_variant(brand_id:, product_id:, code: "VARIANT")
    id = SecureRandom.uuid
    execute_insert("product_variants", {
      id: id,
      brand_id: brand_id,
      product_id: product_id,
      code: code,
      name: "Variant",
      position: 0,
      lifecycle_status: "draft",
      is_default: false,
      customer_visible: false,
      lock_version: 0
    })
    id
  end

  def execute_insert(table, attributes)
    attributes = attributes.merge(created_at: Time.current, updated_at: Time.current)
    columns = attributes.keys.map { |name| ActiveRecord::Base.connection.quote_column_name(name) }.join(", ")
    values = attributes.values.map { |value| ActiveRecord::Base.connection.quote(value) }.join(", ")
    ActiveRecord::Base.connection.execute("INSERT INTO #{table} (#{columns}) VALUES (#{values})")
  end
end
