require "rails_helper"

RSpec.describe "Package B Catalog concurrency", :concurrency do
  self.use_transactional_tests = false

  after do
    ActiveRecord::Base.connection.execute(<<~SQL)
      TRUNCATE TABLE product_variants, products, categories, branches, brands, organizations
    SQL
  end

  it "serializes duplicate Brand/type Codes" do
    brand = create(:brand_record)
    first_inserted = Queue.new
    release_first = Queue.new

    first = Thread.new do
      in_pg_transaction do |connection|
        insert_category(connection, brand.id, "SHARED_CODE")
        first_inserted << connection.backend_pid
        release_first.pop
      end
    end
    first_inserted.pop

    second = Thread.new do
      in_pg_transaction do |connection|
        insert_category(connection, brand.id, "SHARED_CODE")
      end
    end
    wait_for_lock(second)
    release_first << true

    results = [ first.value, second.value ]
    expect(results.count(:committed)).to eq(1)
    expect(results.map { |result| sqlstate(result) }.compact).to contain_exactly("23505")
    expect(category_record_class.where(brand_id: brand.id, code: "SHARED_CODE").count).to eq(1)
  ensure
    release_first << true if first&.alive?
    first&.join
    second&.join
  end

  it "uses a fresh validation snapshot after a Product lock wait" do
    category, product, variant = create_valid_inactive_product
    product_locked = Queue.new
    release_product = Queue.new

    product_transaction = Thread.new do
      in_pg_transaction do |connection|
        connection.exec_params(
          "UPDATE products SET lifecycle_status = 'active' WHERE id = $1",
          [ product.id ]
        )
        product_locked << connection.backend_pid
        release_product.pop
      end
    end
    product_locked.pop

    variant_transaction = Thread.new do
      in_pg_transaction do |connection|
        connection.exec_params(
          "UPDATE product_variants SET lifecycle_status = 'inactive' WHERE id = $1",
          [ variant.id ]
        )
        connection.exec("SET CONSTRAINTS catalog_product_variants_default_final_state IMMEDIATE")
      end
    end
    wait_for_session_lock(variant_transaction)
    release_product << true

    product_result = product_transaction.value
    variant_result = variant_transaction.value

    expect(product_result).to eq(:committed)
    expect(constraint_name(variant_result)).to eq("catalog_active_product_default_valid")
    expect(product_record_class.find(product.id).lifecycle_status).to eq("active")
    expect(variant_record_class.find(variant.id).lifecycle_status).to eq("active")
    expect(category.lifecycle_status).to eq("active")
  ensure
    release_product << true if product_transaction&.alive?
    product_transaction&.join
    variant_transaction&.join
  end

  it "makes a Category UPDATE wait, then rejects it after Product activation commits" do
    category, product, = create_valid_inactive_product
    category_locked = Queue.new
    release_product = Queue.new

    product_transaction = Thread.new do
      in_pg_transaction do |connection|
        connection.exec_params(
          "UPDATE products SET lifecycle_status = 'active' WHERE id = $1",
          [ product.id ]
        )
        connection.exec("SET CONSTRAINTS catalog_products_category_final_state IMMEDIATE")
        category_locked << connection.backend_pid
        release_product.pop
      end
    end
    category_locked.pop

    category_transaction = Thread.new do
      in_pg_transaction do |connection|
        connection.exec_params(
          "/* catalog_schedule_a */ UPDATE categories SET lifecycle_status = 'inactive' WHERE id = $1",
          [ category.id ]
        )
      end
    end
    wait_for_session_lock(category_transaction, query_fragment: "catalog_schedule_a")
    release_product << true

    product_result = product_transaction.value
    category_result = category_transaction.value

    expect(product_result).to eq(:committed)
    expect(constraint_name(category_result)).to eq("catalog_active_product_category_valid")
    expect(category_record_class.find(category.id).lifecycle_status).to eq("active")
    expect(product_record_class.find(product.id).lifecycle_status).to eq("active")
  ensure
    release_product << true if product_transaction&.alive?
    product_transaction&.join
    category_transaction&.join
  end

  it "rolls back one complete transaction on reverse Category/Product lock order" do
    category, product, = create_valid_inactive_product
    category_held = Queue.new
    product_held = Queue.new
    force_product_check = Queue.new
    force_category_check = Queue.new

    category_transaction = Thread.new do
      in_pg_transaction do |connection|
        connection.exec("SET deadlock_timeout = '100ms'")
        connection.exec_params(
          "UPDATE categories SET lifecycle_status = 'inactive' WHERE id = $1",
          [ category.id ]
        )
        category_held << connection.backend_pid
        force_category_check.pop
        connection.exec("SET CONSTRAINTS catalog_categories_product_final_state IMMEDIATE")
      end
    end
    category_held.pop

    product_transaction = Thread.new do
      in_pg_transaction do |connection|
        connection.exec("SET deadlock_timeout = '100ms'")
        connection.exec_params(
          "UPDATE products SET lifecycle_status = 'active' WHERE id = $1",
          [ product.id ]
        )
        product_held << connection.backend_pid
        force_product_check.pop
        connection.exec("SET CONSTRAINTS catalog_products_category_final_state IMMEDIATE")
      end
    end
    product_pid = product_held.pop

    force_product_check << true
    wait_until { session_waiting_on_lock?(product_pid) }
    force_category_check << true

    results = [ category_transaction.value, product_transaction.value ]
    expect(results.count(:committed)).to eq(1)
    expect(results.map { |result| sqlstate(result) }.compact).to contain_exactly("40P01")

    final_category = category_record_class.find(category.id).lifecycle_status
    final_product = product_record_class.find(product.id).lifecycle_status
    expect([ final_category, final_product ]).to satisfy do |states|
      states == [ "active", "active" ] || states == [ "inactive", "inactive" ]
    end
    expect(invalid_active_category_count).to eq(0)
  ensure
    force_product_check << true if product_transaction&.alive?
    force_category_check << true if category_transaction&.alive?
    product_transaction&.join
    category_transaction&.join
  end

  def create_valid_inactive_product
    category = create(:category_record)
    category_record_class.where(id: category.id).update_all(lifecycle_status: "active")
    category.reload
    product = create(:product_record, category: category, lifecycle_status: "inactive")
    variant = create(:product_variant_record, product: product, is_default: true)
    variant_record_class.where(id: variant.id).update_all(lifecycle_status: "active")
    [ category.reload, product.reload, variant.reload ]
  end

  def insert_category(connection, brand_id, code)
    now = Time.current
    connection.exec_params(<<~SQL, [ SecureRandom.uuid, brand_id, code, now ])
      INSERT INTO categories
        (id, brand_id, code, name, position, lifecycle_status, lock_version, created_at, updated_at)
      VALUES ($1, $2, $3, 'Category', 0, 'draft', 0, $4, $4)
    SQL
  end

  def in_pg_transaction
    connection = PG.connect(pg_connection_options)
    connection.exec("SET lock_timeout = '5s'")
    connection.exec("BEGIN ISOLATION LEVEL READ COMMITTED")
    yield connection
    connection.exec("COMMIT")
    :committed
  rescue PG::Error => error
    connection&.exec("ROLLBACK") if connection&.transaction_status != PG::PQTRANS_IDLE
    error
  ensure
    connection&.close
  end

  def pg_connection_options
    config = ActiveRecord::Base.connection_db_config.configuration_hash
    {
      host: config.fetch(:host),
      port: config.fetch(:port),
      user: config.fetch(:username),
      password: config.fetch(:password),
      dbname: config.fetch(:database)
    }
  end

  def wait_for_session_lock(thread, query_fragment: nil)
    wait_until do
      waiting = ActiveRecord::Base.connection.select_value(<<~SQL)
        SELECT EXISTS (
          SELECT 1
          FROM pg_stat_activity
          WHERE datname = current_database()
            AND pid <> pg_backend_pid()
            AND wait_event_type = 'Lock'
            #{"AND query LIKE '%#{query_fragment}%'" if query_fragment}
        )
      SQL
      waiting || !thread.alive?
    end
    raise "transaction completed before the expected lock wait" unless thread.alive?
  end

  def wait_for_lock(thread)
    wait_for_session_lock(thread)
  end

  def session_waiting_on_lock?(pid)
    ActiveRecord::Base.connection.select_value(<<~SQL)
      SELECT EXISTS (
        SELECT 1 FROM pg_stat_activity
        WHERE pid = #{Integer(pid)} AND wait_event_type = 'Lock'
      )
    SQL
  end

  def wait_until(timeout: 5)
    deadline = Process.clock_gettime(Process::CLOCK_MONOTONIC) + timeout
    until yield
      raise "timed out waiting for PostgreSQL lock state" if Process.clock_gettime(Process::CLOCK_MONOTONIC) >= deadline

      sleep 0.01
    end
  end

  def constraint_name(result)
    return unless result.is_a?(PG::Error)

    result.result.error_field(PG::Result::PG_DIAG_CONSTRAINT_NAME)
  end

  def sqlstate(result)
    return unless result.is_a?(PG::Error)

    result.result.error_field(PG::Result::PG_DIAG_SQLSTATE)
  end

  def invalid_active_category_count
    ActiveRecord::Base.connection.select_value(<<~SQL).to_i
      SELECT COUNT(*)
      FROM products
      JOIN categories ON categories.id = products.category_id
      WHERE products.lifecycle_status = 'active'
        AND categories.lifecycle_status <> 'active'
    SQL
  end

  def category_record_class
    Catalog::Infrastructure::Persistence::CategoryRecord
  end

  def product_record_class
    Catalog::Infrastructure::Persistence::ProductRecord
  end

  def variant_record_class
    Catalog::Infrastructure::Persistence::ProductVariantRecord
  end
end
