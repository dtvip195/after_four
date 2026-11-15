require "rails_helper"

RSpec.describe "Package B Catalog isolation guard" do
  self.use_transactional_tests = false

  after do
    ActiveRecord::Base.connection.execute(<<~SQL)
      TRUNCATE TABLE product_variants, products, categories, branches, brands, organizations
    SQL
  end

  it "fails closed outside READ COMMITTED" do
    brand = create(:brand_record)
    category_id = insert_category(brand.id)

    expect do
      ApplicationRecord.transaction(isolation: :repeatable_read) do
        insert_product(brand.id, category_id)
        ActiveRecord::Base.connection.execute("SET CONSTRAINTS ALL IMMEDIATE")
      end
    end.to raise_error(ActiveRecord::StatementInvalid) do |error|
      constraint = error.cause.result.error_field(PG::Result::PG_DIAG_CONSTRAINT_NAME)
      expect(constraint).to eq("catalog_integrity_requires_read_committed")
    end

    expect(ActiveRecord::Base.connection.select_value("SELECT COUNT(*) FROM products")).to eq(0)
  end

  def insert_category(brand_id)
    id = SecureRandom.uuid
    now = Time.current
    ActiveRecord::Base.connection.execute(<<~SQL)
      INSERT INTO categories
        (id, brand_id, code, name, position, lifecycle_status, lock_version, created_at, updated_at)
      VALUES
        (#{quote(id)}, #{quote(brand_id)}, 'CATEGORY', 'Category', 0, 'draft', 0, #{quote(now)}, #{quote(now)})
    SQL
    id
  end

  def insert_product(brand_id, category_id)
    now = Time.current
    ActiveRecord::Base.connection.execute(<<~SQL)
      INSERT INTO products
        (id, brand_id, category_id, code, name, lifecycle_status, lock_version, created_at, updated_at)
      VALUES
        (#{quote(SecureRandom.uuid)}, #{quote(brand_id)}, #{quote(category_id)},
         'PRODUCT', 'Product', 'draft', 0, #{quote(now)}, #{quote(now)})
    SQL
  end

  def quote(value)
    ActiveRecord::Base.connection.quote(value)
  end
end
