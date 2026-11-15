require "rails_helper"

RSpec.describe "Package B Catalog database integrity" do
  it "requires Draft initial state for Category and Variant but does not decide Product initial state" do
    brand = create(:brand_record)

    %w[active inactive archived].each do |status|
      expect_constraint("categories_initial_lifecycle_draft") do
        insert_category(brand_id: brand.id, lifecycle_status: status)
      end
    end

    category_id = insert_category(brand_id: brand.id)
    product_id = insert_product(brand_id: brand.id, category_id: category_id, lifecycle_status: "inactive")
    %w[active inactive archived].each do |status|
      expect_constraint("product_variants_initial_lifecycle_draft") do
        insert_variant(brand_id: brand.id, product_id: product_id, lifecycle_status: status)
      end
    end

    expect(product_id).to be_present

    %w[draft archived].each do |status|
      expect(
        insert_product(brand_id: brand.id, category_id: category_id, lifecycle_status: status)
      ).to be_present
    end

    update_status("categories", category_id, "active")
    active_product_id = insert_product(
      brand_id: brand.id,
      category_id: category_id,
      lifecycle_status: "active"
    )
    active_default_id = insert_variant(
      brand_id: brand.id,
      product_id: active_product_id,
      is_default: true
    )
    update_status("product_variants", active_default_id, "active")
    enforce_deferred_constraints!
    expect(status_of("products", active_product_id)).to eq("active")
  ensure
    defer_constraints!
  end

  it "enforces the Category and Variant lifecycle matrices" do
    brand = create(:brand_record)
    category_id = insert_category(brand_id: brand.id)
    product_id = insert_product(brand_id: brand.id, category_id: category_id)
    variant_id = insert_variant(brand_id: brand.id, product_id: product_id)

    expect_constraint("categories_lifecycle_transition_allowed") do
      update_status("categories", category_id, "inactive")
    end
    expect_constraint("product_variants_lifecycle_transition_allowed") do
      update_status("product_variants", variant_id, "inactive")
    end

    update_status("categories", category_id, "active")
    update_status("categories", category_id, "inactive")
    update_status("categories", category_id, "archived")
    update_status("categories", category_id, "inactive")

    update_status("product_variants", variant_id, "active")
    update_status("product_variants", variant_id, "inactive")
    update_status("product_variants", variant_id, "archived")
    update_status("product_variants", variant_id, "inactive")

    expect(status_of("categories", category_id)).to eq("inactive")
    expect(status_of("product_variants", variant_id)).to eq("inactive")
  end

  it "rejects simultaneous Archive or Restore flag changes" do
    brand = create(:brand_record)
    category_id = insert_category(brand_id: brand.id)
    product_id = insert_product(brand_id: brand.id, category_id: category_id)
    variant_id = insert_variant(
      brand_id: brand.id,
      product_id: product_id,
      is_default: true,
      customer_visible: true
    )

    expect_constraint("product_variants_lifecycle_transition_allowed") do
      execute(<<~SQL)
        UPDATE product_variants
        SET lifecycle_status = 'archived', is_default = false
        WHERE id = #{quote(variant_id)}
      SQL
    end

    update_status("product_variants", variant_id, "archived")
    expect_constraint("product_variants_lifecycle_transition_allowed") do
      execute(<<~SQL)
        UPDATE product_variants
        SET lifecycle_status = 'inactive', customer_visible = false
        WHERE id = #{quote(variant_id)}
      SQL
    end

    row = connection.select_one(<<~SQL)
      SELECT lifecycle_status, is_default, customer_visible
      FROM product_variants
      WHERE id = #{quote(variant_id)}
    SQL
    expect(row).to include(
      "lifecycle_status" => "archived", "is_default" => true, "customer_visible" => true
    )
  end

  it "makes aggregate ownership immutable" do
    brand = create(:brand_record)
    other_brand = create(:brand_record)
    category_id = insert_category(brand_id: brand.id)
    other_category_id = insert_category(brand_id: brand.id, code: "OTHER_CATEGORY")
    product_id = insert_product(brand_id: brand.id, category_id: category_id)
    variant_id = insert_variant(brand_id: brand.id, product_id: product_id)

    expect_constraint("categories_scope_immutable") do
      update_value("categories", category_id, "brand_id", other_brand.id)
    end
    expect_constraint("products_scope_immutable") do
      update_value("products", product_id, "category_id", other_category_id)
    end
    expect_constraint("product_variants_scope_immutable") do
      update_value("product_variants", variant_id, "brand_id", other_brand.id)
    end
  end

  it "prohibits Purge in every Catalog lifecycle state" do
    brand = create(:brand_record)
    %w[draft active inactive archived].each do |status|
      category_id = insert_category(brand_id: brand.id)
      transition_category_to(category_id, status)
      expect_constraint("categories_purge_forbidden") { delete_row("categories", category_id) }

      product_category_id = insert_active_category(brand.id)
      product_id = insert_product(
        brand_id: brand.id,
        category_id: product_category_id,
        lifecycle_status: status == "active" ? "inactive" : status
      )
      if status == "active"
        default_id = insert_variant(brand_id: brand.id, product_id: product_id, is_default: true)
        update_status("product_variants", default_id, "active")
        update_status("products", product_id, "active")
        enforce_deferred_constraints!
        defer_constraints!
      end
      expect_constraint("products_purge_forbidden") { delete_row("products", product_id) }

      variant_product_id = insert_product(
        brand_id: brand.id,
        category_id: product_category_id,
        lifecycle_status: "inactive"
      )
      variant_id = insert_variant(brand_id: brand.id, product_id: variant_product_id)
      transition_variant_to(variant_id, status)
      expect_constraint("product_variants_purge_forbidden") do
        delete_row("product_variants", variant_id)
      end
    end
  end

  it "prevents two designated Defaults for every Product state" do
    brand = create(:brand_record)
    category_id = insert_category(brand_id: brand.id)
    product_id = insert_product(brand_id: brand.id, category_id: category_id)
    insert_variant(brand_id: brand.id, product_id: product_id, is_default: true)

    expect_constraint("uq_product_variants_one_default") do
      insert_variant(brand_id: brand.id, product_id: product_id, is_default: true)
    end
  end

  it "requires an Active Product to have exactly one Active designated Default" do
    brand = create(:brand_record)
    category_id = insert_active_category(brand.id)

    expect_constraint("catalog_active_product_default_valid", deferred: true) do
      insert_product(brand_id: brand.id, category_id: category_id, lifecycle_status: "active")
    end

    product_id = insert_product(brand_id: brand.id, category_id: category_id, lifecycle_status: "inactive")
    variant_id = insert_variant(
      brand_id: brand.id,
      product_id: product_id,
      is_default: true,
      customer_visible: false
    )
    update_status("product_variants", variant_id, "active")
    update_status("products", product_id, "active")
    enforce_deferred_constraints!

    expect(status_of("products", product_id)).to eq("active")
  ensure
    defer_constraints!
  end

  it "rejects Category final state with an assigned Active Product" do
    brand = create(:brand_record)
    category_id = insert_active_category(brand.id)
    product_id = insert_product(brand_id: brand.id, category_id: category_id, lifecycle_status: "inactive")
    variant_id = insert_variant(brand_id: brand.id, product_id: product_id, is_default: true)
    update_status("product_variants", variant_id, "active")
    update_status("products", product_id, "active")
    enforce_deferred_constraints!

    expect_constraint("catalog_active_product_category_valid", deferred: true) do
      update_status("categories", category_id, "inactive")
    end
  ensure
    defer_constraints!
  end

  def insert_active_category(brand_id)
    id = insert_category(brand_id: brand_id)
    update_status("categories", id, "active")
    id
  end

  def transition_category_to(id, status)
    case status
    when "draft" then nil
    when "active" then update_status("categories", id, "active")
    when "inactive"
      update_status("categories", id, "active")
      update_status("categories", id, "inactive")
    when "archived" then update_status("categories", id, "archived")
    end
  end

  def transition_variant_to(id, status)
    case status
    when "draft" then nil
    when "active" then update_status("product_variants", id, "active")
    when "inactive"
      update_status("product_variants", id, "active")
      update_status("product_variants", id, "inactive")
    when "archived" then update_status("product_variants", id, "archived")
    end
  end

  def insert_category(brand_id:, code: "CATEGORY_#{SecureRandom.hex(4).upcase}", lifecycle_status: "draft")
    insert_row("categories", {
      brand_id: brand_id,
      code: code,
      name: "Category",
      position: 0,
      lifecycle_status: lifecycle_status,
      lock_version: 0
    })
  end

  def insert_product(brand_id:, category_id:, lifecycle_status: "draft")
    insert_row("products", {
      brand_id: brand_id,
      category_id: category_id,
      code: "PRODUCT_#{SecureRandom.hex(4).upcase}",
      name: "Product",
      lifecycle_status: lifecycle_status,
      lock_version: 0
    })
  end

  def insert_variant(
    brand_id:,
    product_id:,
    lifecycle_status: "draft",
    is_default: false,
    customer_visible: false
  )
    insert_row("product_variants", {
      brand_id: brand_id,
      product_id: product_id,
      code: "VARIANT_#{SecureRandom.hex(4).upcase}",
      name: "Variant",
      position: 0,
      lifecycle_status: lifecycle_status,
      is_default: is_default,
      customer_visible: customer_visible,
      lock_version: 0
    })
  end

  def insert_row(table, attributes)
    id = SecureRandom.uuid
    attributes = attributes.merge(id: id, created_at: Time.current, updated_at: Time.current)
    columns = attributes.keys.map { |name| connection.quote_column_name(name) }.join(", ")
    values = attributes.values.map { |value| quote(value) }.join(", ")
    execute("INSERT INTO #{table} (#{columns}) VALUES (#{values})")
    id
  end

  def update_status(table, id, status)
    update_value(table, id, "lifecycle_status", status)
  end

  def update_value(table, id, column, value)
    execute("UPDATE #{table} SET #{column} = #{quote(value)}, updated_at = CURRENT_TIMESTAMP WHERE id = #{quote(id)}")
  end

  def delete_row(table, id)
    execute("DELETE FROM #{table} WHERE id = #{quote(id)}")
  end

  def status_of(table, id)
    connection.select_value("SELECT lifecycle_status FROM #{table} WHERE id = #{quote(id)}")
  end

  def expect_constraint(name, deferred: false)
    expect do
      ApplicationRecord.transaction(requires_new: true) do
        yield
        enforce_deferred_constraints! if deferred
      end
    end.to raise_error(ActiveRecord::StatementInvalid) do |error|
      expect(error.cause.result.error_field(PG::Result::PG_DIAG_CONSTRAINT_NAME)).to eq(name)
    end
  end

  def enforce_deferred_constraints!
    execute("SET CONSTRAINTS ALL IMMEDIATE")
  end

  def defer_constraints!
    return unless connection.transaction_open?

    execute("SET CONSTRAINTS ALL DEFERRED")
  end

  def execute(sql)
    connection.execute(sql)
  end

  def quote(value)
    connection.quote(value)
  end

  def connection
    ActiveRecord::Base.connection
  end
end
