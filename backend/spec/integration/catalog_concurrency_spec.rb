require "rails_helper"

RSpec.describe "Package B Catalog concurrency", :concurrency do
  self.use_transactional_tests = false

  WAIT_TIMEOUT_SECONDS = 5
  WAIT_POLL_SECONDS = 0.05
  ConcurrencyWaitTimeout = Class.new(StandardError)

  after do
    ActiveRecord::Base.connection.execute(<<~SQL)
      TRUNCATE TABLE product_variants, products, categories, branches, brands, organizations
    SQL
  end

  it "serializes duplicate Brand/type Codes" do
    brand = create(:brand_record)
    first_inserted = Queue.new
    release_first = Queue.new

    first = start_worker("first duplicate Code insert") do
      in_pg_transaction do |connection|
        insert_category(connection, brand.id, "SHARED_CODE")
        first_inserted << connection.backend_pid
        await_barrier!(release_first, label: "release first duplicate Code insert")
      end
    end
    await_barrier!(first_inserted, label: "first duplicate Code insert", worker: first)

    second = start_worker("second duplicate Code insert") do
      in_pg_transaction do |connection|
        insert_category(connection, brand.id, "SHARED_CODE")
      end
    end
    wait_for_lock(second, label: "second duplicate Code insert")
    release_first << true

    results = [
      thread_result!(first, label: "first duplicate Code insert"),
      thread_result!(second, label: "second duplicate Code insert")
    ]
    rejected_result = results.find { |result| sqlstate(result) == "23505" }
    expect(results.count(:committed)).to eq(1)
    expect(results.map { |result| sqlstate(result) }.compact).to contain_exactly("23505")
    expect(constraint_name(rejected_result)).to eq("uq_categories_brand_code")
    expect(category_record_class.where(brand_id: brand.id, code: "SHARED_CODE").count).to eq(1)
  ensure
    cleanup_schedule!(
      threads: { "first duplicate Code insert" => first, "second duplicate Code insert" => second },
      release_queues: [ release_first ]
    )
  end

  it "uses a fresh validation snapshot after a Product lock wait" do
    category, product, variant = create_valid_inactive_product
    product_locked = Queue.new
    release_product = Queue.new

    product_transaction = start_worker("Product activation") do
      in_pg_transaction do |connection|
        connection.exec_params(
          "UPDATE products SET lifecycle_status = 'active' WHERE id = $1",
          [ product.id ]
        )
        product_locked << connection.backend_pid
        await_barrier!(release_product, label: "release Product activation")
      end
    end
    await_barrier!(product_locked, label: "Product activation lock", worker: product_transaction)

    variant_transaction = start_worker("Variant deferred check") do
      in_pg_transaction do |connection|
        connection.exec_params(
          "UPDATE product_variants SET lifecycle_status = 'inactive' WHERE id = $1",
          [ variant.id ]
        )
        connection.exec("SET CONSTRAINTS catalog_product_variants_default_final_state IMMEDIATE")
      end
    end
    wait_for_session_lock(variant_transaction, label: "Variant deferred check waits on Product")
    release_product << true

    product_result = thread_result!(product_transaction, label: "Product activation")
    variant_result = thread_result!(variant_transaction, label: "Variant deferred check")

    expect(product_result).to eq(:committed)
    expect(constraint_name(variant_result)).to eq("catalog_active_product_default_valid")
    expect(product_record_class.find(product.id).lifecycle_status).to eq("active")
    expect(variant_record_class.find(variant.id).lifecycle_status).to eq("active")
    expect(category.lifecycle_status).to eq("active")
  ensure
    cleanup_schedule!(
      threads: {
        "Product activation" => product_transaction,
        "Variant deferred check" => variant_transaction
      },
      release_queues: [ release_product ]
    )
  end

  it "makes a Category UPDATE wait, then rejects it after Product activation commits" do
    category, product, = create_valid_inactive_product
    category_locked = Queue.new
    release_product = Queue.new

    product_transaction = start_worker("Schedule A Product activation") do
      in_pg_transaction do |connection|
        connection.exec_params(
          "UPDATE products SET lifecycle_status = 'active' WHERE id = $1",
          [ product.id ]
        )
        connection.exec("SET CONSTRAINTS catalog_products_category_final_state IMMEDIATE")
        category_locked << connection.backend_pid
        await_barrier!(release_product, label: "release Schedule A Product activation")
      end
    end
    await_barrier!(category_locked, label: "Schedule A Category lock", worker: product_transaction)

    category_transaction = start_worker("Schedule A Category UPDATE") do
      in_pg_transaction do |connection|
        connection.exec_params(
          "/* catalog_schedule_a */ UPDATE categories SET lifecycle_status = 'inactive' WHERE id = $1",
          [ category.id ]
        )
      end
    end
    wait_for_session_lock(
      category_transaction,
      label: "Schedule A Category UPDATE",
      query_fragment: "catalog_schedule_a"
    )
    release_product << true

    product_result = thread_result!(product_transaction, label: "Schedule A Product activation")
    category_result = thread_result!(category_transaction, label: "Schedule A Category UPDATE")

    expect(product_result).to eq(:committed)
    expect(sqlstate(category_result)).to eq("23514")
    expect(constraint_name(category_result)).to eq("catalog_active_product_category_valid")
    expect(category_record_class.find(category.id).lifecycle_status).to eq("active")
    expect(product_record_class.find(product.id).lifecycle_status).to eq("active")
  ensure
    cleanup_schedule!(
      threads: {
        "Schedule A Product activation" => product_transaction,
        "Schedule A Category UPDATE" => category_transaction
      },
      release_queues: [ release_product ]
    )
  end

  it "rolls back one complete transaction on reverse Category/Product lock order" do
    category, product, = create_valid_inactive_product
    marker_schema = create_marker_harness
    category_marker_id = SecureRandom.uuid
    product_marker_id = SecureRandom.uuid
    category_held = Queue.new
    product_held = Queue.new
    force_product_check = Queue.new
    force_category_check = Queue.new

    category_transaction = start_worker("Schedule B Category transaction") do
      in_pg_transaction do |connection|
        connection.exec("SET deadlock_timeout = '100ms'")
        insert_marker(connection, marker_schema, category_marker_id, "Category transaction marker")
        connection.exec_params(
          "UPDATE categories SET lifecycle_status = 'inactive' WHERE id = $1",
          [ category.id ]
        )
        category_held << connection.backend_pid
        await_barrier!(force_category_check, label: "force Schedule B Category check")
        connection.exec("SET CONSTRAINTS catalog_categories_product_final_state IMMEDIATE")
      end
    end
    await_barrier!(category_held, label: "Schedule B Category lock", worker: category_transaction)

    product_transaction = start_worker("Schedule B Product transaction") do
      in_pg_transaction do |connection|
        connection.exec("SET deadlock_timeout = '100ms'")
        insert_marker(connection, marker_schema, product_marker_id, "Product transaction marker")
        connection.exec_params(
          "UPDATE products SET lifecycle_status = 'active' WHERE id = $1",
          [ product.id ]
        )
        product_held << connection.backend_pid
        await_barrier!(force_product_check, label: "force Schedule B Product check")
        connection.exec("SET CONSTRAINTS catalog_products_category_final_state IMMEDIATE")
      end
    end
    product_pid = await_barrier!(product_held, label: "Schedule B Product lock", worker: product_transaction)

    force_product_check << true
    wait_until(label: "Schedule B Product waits on Category", worker: product_transaction) do
      session_waiting_on_lock?(product_pid)
    end
    force_category_check << true

    results = [
      thread_result!(category_transaction, label: "Schedule B Category transaction"),
      thread_result!(product_transaction, label: "Schedule B Product transaction")
    ]
    victim_index = results.index { |result| sqlstate(result) == "40P01" }
    survivor_index = 1 - victim_index

    expect(results.count(:committed)).to eq(1)
    expect(results.map { |result| sqlstate(result) }.compact).to contain_exactly("40P01")
    expect(marker_exists?(marker_schema, [ category_marker_id, product_marker_id ][victim_index])).to be(false)
    expect(marker_exists?(marker_schema, [ category_marker_id, product_marker_id ][survivor_index])).to be(true)

    final_category = category_record_class.find(category.id).lifecycle_status
    final_product = product_record_class.find(product.id).lifecycle_status
    expected_states = survivor_index.zero? ? [ "inactive", "inactive" ] : [ "active", "active" ]
    expect([ final_category, final_product ]).to eq(expected_states)
    expect(invalid_active_category_count).to eq(0)
  ensure
    cleanup_schedule!(
      threads: {
        "Schedule B Product transaction" => product_transaction,
        "Schedule B Category transaction" => category_transaction
      },
      release_queues: [ force_product_check, force_category_check ],
      schemas: [ marker_schema ]
    )
  end

  it "rolls back every victim write on reverse Product/Variant lock order" do
    _category, product, default_variant, replacement_variant = create_valid_active_product
    marker_schema = create_marker_harness
    parent_marker_id = SecureRandom.uuid
    child_marker_id = SecureRandom.uuid
    product_held = Queue.new
    variants_held = Queue.new
    request_variant = Queue.new
    force_child_check = Queue.new

    parent_transaction = start_worker("Product/Variant parent transaction") do
      in_pg_transaction do |connection|
        connection.exec("SET deadlock_timeout = '100ms'")
        insert_marker(connection, marker_schema, parent_marker_id, "Product parent marker")
        connection.exec_params("SELECT id FROM products WHERE id = $1 FOR UPDATE", [ product.id ])
        product_held << connection.backend_pid
        await_barrier!(request_variant, label: "request Product/Variant parent Variant lock")
        connection.exec_params(<<~SQL, [ default_variant.id ])
          UPDATE product_variants
          SET customer_visible = NOT customer_visible, updated_at = CURRENT_TIMESTAMP
          WHERE id = $1
        SQL
      end
    end
    parent_pid = await_barrier!(product_held, label: "Product/Variant Product lock", worker: parent_transaction)

    child_transaction = start_worker("Product/Variant child transaction") do
      in_pg_transaction do |connection|
        connection.exec("SET deadlock_timeout = '100ms'")
        insert_marker(connection, marker_schema, child_marker_id, "Variant child marker")
        connection.exec_params(
          "UPDATE product_variants SET is_default = false WHERE id = $1",
          [ default_variant.id ]
        )
        connection.exec_params(
          "UPDATE product_variants SET is_default = true WHERE id = $1",
          [ replacement_variant.id ]
        )
        variants_held << connection.backend_pid
        await_barrier!(force_child_check, label: "force Product/Variant child check")
        connection.exec("SET CONSTRAINTS catalog_product_variants_default_final_state IMMEDIATE")
      end
    end
    await_barrier!(variants_held, label: "Product/Variant Variant locks", worker: child_transaction)

    request_variant << true
    wait_until(label: "Product/Variant parent waits on Variant", worker: parent_transaction) do
      session_waiting_on_lock?(parent_pid)
    end
    force_child_check << true

    results = [
      thread_result!(parent_transaction, label: "Product/Variant parent transaction"),
      thread_result!(child_transaction, label: "Product/Variant child transaction")
    ]
    victim_index = results.index { |result| sqlstate(result) == "40P01" }
    survivor_index = 1 - victim_index

    expect(results.count(:committed)).to eq(1)
    expect(results.map { |result| sqlstate(result) }.compact).to contain_exactly("40P01")
    expect(marker_exists?(marker_schema, [ parent_marker_id, child_marker_id ][victim_index])).to be(false)
    expect(marker_exists?(marker_schema, [ parent_marker_id, child_marker_id ][survivor_index])).to be(true)

    default_variant.reload
    replacement_variant.reload
    if survivor_index.zero?
      expect(default_variant).to have_attributes(is_default: true, customer_visible: true)
      expect(replacement_variant.is_default).to be(false)
    else
      expect(default_variant).to have_attributes(is_default: false, customer_visible: false)
      expect(replacement_variant.is_default).to be(true)
    end
    expect(invalid_active_default_count).to eq(0)
  ensure
    cleanup_schedule!(
      threads: {
        "Product/Variant parent transaction" => parent_transaction,
        "Product/Variant child transaction" => child_transaction
      },
      release_queues: [ request_variant, force_child_check ],
      schemas: [ marker_schema ]
    )
  end

  it "rolls back every write after a lock timeout" do
    category = create(:category_record)
    marker_schema = create_marker_harness
    marker_id = SecureRandom.uuid
    category_held = Queue.new
    release_category = Queue.new

    holder = start_worker("lock-timeout Category holder") do
      in_pg_transaction do |connection|
        connection.exec_params("SELECT id FROM categories WHERE id = $1 FOR UPDATE", [ category.id ])
        category_held << connection.backend_pid
        await_barrier!(release_category, label: "release lock-timeout Category holder")
      end
    end
    await_barrier!(category_held, label: "lock-timeout Category lock", worker: holder)

    result = in_pg_transaction do |connection|
      insert_marker(connection, marker_schema, marker_id, "Lock timeout marker")
      connection.exec("SET LOCAL lock_timeout = '100ms'")
      connection.exec_params(
        "UPDATE categories SET lifecycle_status = 'active' WHERE id = $1",
        [ category.id ]
      )
    end

    expect(sqlstate(result)).to eq("55P03")
    expect(marker_exists?(marker_schema, marker_id)).to be(false)
    expect(category_record_class.find(category.id).lifecycle_status).to eq("draft")
  ensure
    cleanup_schedule!(
      threads: { "lock-timeout Category holder" => holder },
      release_queues: [ release_category ],
      schemas: [ marker_schema ]
    )
  end

  it "demonstrates the stale snapshot hidden by a defective combined lock and check" do
    harness_schema = "catalog_stale_snapshot_#{SecureRandom.hex(6)}"
    create_stale_snapshot_harness(harness_schema)
    parent_changed = Queue.new
    release_parent = Queue.new

    writer = start_worker("stale-snapshot writer") do
      in_pg_transaction do |connection|
        connection.exec("UPDATE #{harness_schema}.parents SET lock_version = lock_version + 1 WHERE id = 1")
        connection.exec("UPDATE #{harness_schema}.children SET enabled = false WHERE parent_id = 1")
        parent_changed << {
          pid: connection.backend_pid,
          xid: connection.exec("SELECT pg_current_xact_id()::text").getvalue(0, 0),
          snapshot: connection.exec("SELECT pg_current_snapshot()::text").getvalue(0, 0)
        }
        await_barrier!(release_parent, label: "release stale-snapshot writer")
      end
    end
    writer_trace = await_barrier!(parent_changed, label: "stale-snapshot writer change", worker: writer)

    reader = start_worker("stale-snapshot reader") do
      observation = nil
      result = in_pg_transaction do |connection|
        stale_result = connection.exec_params(<<~SQL, [ writer_trace.fetch(:xid) ]).first
          /* catalog_stale_snapshot_harness */
          WITH snapshot_trace AS MATERIALIZED (
            SELECT
              pg_current_xact_id()::text AS reader_xid,
              pg_current_snapshot() AS snapshot
          ),
          child_state AS MATERIALIZED (
            SELECT COUNT(*) FILTER (WHERE enabled) AS enabled_count
            FROM #{harness_schema}.children
            WHERE parent_id = 1
          )
          SELECT
            snapshot_trace.reader_xid,
            snapshot_trace.snapshot::text AS snapshot,
            pg_visible_in_snapshot($1::xid8, snapshot_trace.snapshot)::text AS writer_visible,
            child_state.enabled_count
          FROM #{harness_schema}.parents AS parents
          CROSS JOIN snapshot_trace
          CROSS JOIN child_state
          WHERE parents.id = 1
          FOR UPDATE OF parents
        SQL
        fresh_result = connection.exec_params(<<~SQL, [ writer_trace.fetch(:xid) ]).first
          WITH snapshot_trace AS MATERIALIZED (
            SELECT
              pg_current_xact_id()::text AS reader_xid,
              pg_current_snapshot() AS snapshot
          )
          SELECT
            snapshot_trace.reader_xid,
            snapshot_trace.snapshot::text AS snapshot,
            pg_visible_in_snapshot($1::xid8, snapshot_trace.snapshot)::text AS writer_visible,
            (
              SELECT COUNT(*) FILTER (WHERE children.enabled)
              FROM #{harness_schema}.children AS children
              WHERE children.parent_id = 1
            ) AS enabled_count
          FROM snapshot_trace
        SQL
        observation = { stale: stale_result, fresh: fresh_result }
      end
      [ result, observation ]
    end
    wait_for_session_lock(
      reader,
      label: "defective stale-snapshot reader",
      query_fragment: "catalog_stale_snapshot_harness"
    )
    release_parent << true

    writer_result = thread_result!(writer, label: "stale-snapshot writer")
    reader_result, observation = thread_result!(reader, label: "stale-snapshot reader")

    expect(writer_result).to eq(:committed)
    expect(reader_result).to eq(:committed)
    stale_trace = observation.fetch(:stale)
    fresh_trace = observation.fetch(:fresh)
    expect(writer_trace.fetch(:xid)).not_to eq(stale_trace.fetch("reader_xid"))
    expect(stale_trace.fetch("reader_xid")).to eq(fresh_trace.fetch("reader_xid"))
    expect(stale_trace.fetch("snapshot")).not_to eq(fresh_trace.fetch("snapshot"))
    expect(stale_trace.fetch("writer_visible")).to eq("false")
    expect(fresh_trace.fetch("writer_visible")).to eq("true")
    expect([ stale_trace.fetch("enabled_count").to_i, fresh_trace.fetch("enabled_count").to_i ]).to eq([ 1, 0 ])

    if ENV["CATALOG_CONCURRENCY_TRACE"] == "1"
      RSpec.configuration.reporter.message(
        "stale snapshot trace: writer=#{writer_trace.inspect} stale=#{stale_trace.inspect} " \
        "fresh=#{fresh_trace.inspect}"
      )
    end
  ensure
    cleanup_schedule!(
      threads: { "stale-snapshot writer" => writer, "stale-snapshot reader" => reader },
      release_queues: [ release_parent ],
      schemas: [ harness_schema ]
    )
  end

  it "commits a repaired deferred Default state and rejects the unrepaired equivalent" do
    _category, product, original_default, replacement_default = create_valid_active_product

    repaired_result = in_pg_transaction do |connection|
      connection.exec_params(
        "UPDATE product_variants SET is_default = false WHERE id = $1",
        [ original_default.id ]
      )
      connection.exec_params(
        "UPDATE product_variants SET is_default = true WHERE id = $1",
        [ replacement_default.id ]
      )
      connection.exec("SET CONSTRAINTS catalog_product_variants_default_final_state IMMEDIATE")
    end

    expect(repaired_result).to eq(:committed)
    expect(default_variant_ids(product.id)).to contain_exactly(replacement_default.id)
    expect(invalid_active_default_count).to eq(0)

    unrepaired_result = in_pg_transaction do |connection|
      connection.exec_params(
        "UPDATE product_variants SET is_default = false WHERE id = $1",
        [ replacement_default.id ]
      )
      connection.exec("SET CONSTRAINTS catalog_product_variants_default_final_state IMMEDIATE")
    end

    expect(sqlstate(unrepaired_result)).to eq("23514")
    expect(constraint_name(unrepaired_result)).to eq("catalog_active_product_default_valid")
    expect(default_variant_ids(product.id)).to contain_exactly(replacement_default.id)
    expect(invalid_active_default_count).to eq(0)
  end

  it "propagates a worker failure before its expected barrier" do
    barrier = Queue.new
    worker = start_worker("intentional failed worker") { raise "intentional barrier worker failure" }

    expect do
      await_barrier!(barrier, label: "intentional failed worker", worker: worker)
    end.to raise_error(RuntimeError, "intentional barrier worker failure")
  ensure
    cleanup_schedule!(threads: { "intentional failed worker" => worker })
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

  def create_valid_active_product
    category, product, default_variant = create_valid_inactive_product
    replacement_variant = create(:product_variant_record, product: product)
    variant_record_class.where(id: replacement_variant.id).update_all(lifecycle_status: "active")
    product_record_class.where(id: product.id).update_all(lifecycle_status: "active")
    [ category.reload, product.reload, default_variant.reload, replacement_variant.reload ]
  end

  def insert_category(connection, brand_id, code)
    now = Time.current
    connection.exec_params(<<~SQL, [ SecureRandom.uuid, brand_id, code, now ])
      INSERT INTO categories
        (id, brand_id, code, name, position, lifecycle_status, lock_version, created_at, updated_at)
      VALUES ($1, $2, $3, 'Category', 0, 'draft', 0, $4, $4)
    SQL
  end

  def create_marker_harness
    schema = "catalog_markers_#{SecureRandom.hex(6)}"
    ActiveRecord::Base.connection.execute(<<~SQL)
      CREATE SCHEMA #{schema};
      CREATE TABLE #{schema}.markers (
        id uuid PRIMARY KEY,
        name text NOT NULL
      );
    SQL
    schema
  end

  def insert_marker(connection, schema, id, name)
    connection.exec_params(<<~SQL, [ id, name ])
      INSERT INTO #{schema}.markers (id, name)
      VALUES ($1, $2)
    SQL
  end

  def create_stale_snapshot_harness(schema)
    ActiveRecord::Base.connection.execute(<<~SQL)
      CREATE SCHEMA #{schema};
      CREATE TABLE #{schema}.parents (
        id integer PRIMARY KEY,
        lock_version integer NOT NULL
      );
      CREATE TABLE #{schema}.children (
        id integer PRIMARY KEY,
        parent_id integer NOT NULL REFERENCES #{schema}.parents(id),
        enabled boolean NOT NULL
      );
      INSERT INTO #{schema}.parents (id, lock_version) VALUES (1, 0);
      INSERT INTO #{schema}.children (id, parent_id, enabled) VALUES (1, 1, true);
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

  def start_worker(label, &block)
    Thread.new do
      { value: block.call, error: nil }
    rescue Exception => error # rubocop:disable Lint/RescueException -- test worker must report every failure
      { value: nil, error: error }
    end.tap do |thread|
      thread.name = "catalog-spec: #{label}"
      thread.report_on_exception = false
    end
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

  def await_barrier!(queue, label:, worker: nil, timeout: WAIT_TIMEOUT_SECONDS)
    deadline = monotonic_deadline(timeout)

    loop do
      begin
        return queue.pop(true)
      rescue ThreadError
        raise_finished_worker!(worker, label) if worker && !worker.alive?
      end

      remaining = remaining_seconds(deadline)
      raise ConcurrencyWaitTimeout, "timed out waiting for barrier: #{label}" if remaining <= 0

      value = queue.pop(timeout: [ remaining, WAIT_POLL_SECONDS ].min)
      return value unless value.nil?
    end
  end

  def thread_result!(thread, label:, timeout: WAIT_TIMEOUT_SECONDS)
    raise ConcurrencyWaitTimeout, "worker was not started: #{label}" unless thread

    deadline = monotonic_deadline(timeout)
    joined = thread.join(remaining_seconds(deadline))
    raise ConcurrencyWaitTimeout, "timed out waiting for worker: #{label}" unless joined

    outcome = thread.value
    thread[:catalog_result_observed] = true
    raise outcome.fetch(:error) if outcome.fetch(:error)

    outcome.fetch(:value)
  end

  def wait_for_session_lock(thread, label:, query_fragment: nil)
    wait_until(label: label, worker: thread) do
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
    raise_finished_worker!(thread, label) unless thread.alive?
  end

  def wait_for_lock(thread, label:)
    wait_for_session_lock(thread, label: label)
  end

  def session_waiting_on_lock?(pid)
    ActiveRecord::Base.connection.select_value(<<~SQL)
      SELECT EXISTS (
        SELECT 1 FROM pg_stat_activity
        WHERE pid = #{Integer(pid)} AND wait_event_type = 'Lock'
      )
    SQL
  end

  def wait_until(label:, timeout: WAIT_TIMEOUT_SECONDS, worker: nil)
    deadline = monotonic_deadline(timeout)
    until yield
      raise_finished_worker!(worker, label) if worker && !worker.alive?
      if remaining_seconds(deadline) <= 0
        raise ConcurrencyWaitTimeout, "timed out waiting for PostgreSQL state: #{label}"
      end

      sleep [ WAIT_POLL_SECONDS, remaining_seconds(deadline) ].min
    end
  end

  def cleanup_schedule!(threads:, release_queues: [], schemas: [])
    original_error = $!
    cleanup_errors = []

    release_queues.compact.each { |queue| queue << true }
    threads.each do |label, thread|
      cleanup_worker!(thread, label: label)
    rescue StandardError => error
      cleanup_errors << error
    end
    schemas.compact.each do |schema|
      drop_test_schema!(schema)
    rescue StandardError => error
      cleanup_errors << error
    end

    return if cleanup_errors.empty?

    details = cleanup_errors.map { |error| "#{error.class}: #{error.message}" }.join("; ")
    details = "original=#{original_error.class}: #{original_error.message}; cleanup=#{details}" if original_error
    raise ConcurrencyWaitTimeout, details
  end

  def cleanup_worker!(thread, label:)
    return unless thread

    deadline = monotonic_deadline(WAIT_TIMEOUT_SECONDS)
    joined = thread.join(remaining_seconds(deadline))
    unless joined
      thread.kill
      kill_deadline = monotonic_deadline(WAIT_TIMEOUT_SECONDS)
      killed = thread.join(remaining_seconds(kill_deadline))
      raise ConcurrencyWaitTimeout, "worker cleanup timed out after kill: #{label}" unless killed

      raise ConcurrencyWaitTimeout, "worker exceeded cleanup deadline and was killed: #{label}"
    end

    return if thread[:catalog_result_observed]

    outcome = thread.value
    raise outcome.fetch(:error) if outcome.fetch(:error)

    result = outcome.fetch(:value)
    raise result if result.is_a?(Exception)
  end

  def raise_finished_worker!(worker, label)
    result = thread_result!(worker, label: label, timeout: 0)
    raise result if result.is_a?(Exception)

    raise ConcurrencyWaitTimeout, "worker completed before expected schedule stage: #{label}; result=#{result.inspect}"
  end

  def drop_test_schema!(schema)
    ActiveRecord::Base.transaction(requires_new: true) do
      ActiveRecord::Base.connection.execute("SET LOCAL lock_timeout = '5s'")
      ActiveRecord::Base.connection.execute("SET LOCAL statement_timeout = '5s'")
      ActiveRecord::Base.connection.execute("DROP SCHEMA IF EXISTS #{schema} CASCADE")
    end
  end

  def monotonic_deadline(timeout)
    Process.clock_gettime(Process::CLOCK_MONOTONIC) + timeout
  end

  def remaining_seconds(deadline)
    [ deadline - Process.clock_gettime(Process::CLOCK_MONOTONIC), 0 ].max
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

  def invalid_active_default_count
    ActiveRecord::Base.connection.select_value(<<~SQL).to_i
      SELECT COUNT(*)
      FROM products
      WHERE lifecycle_status = 'active'
        AND (
          SELECT COUNT(*)
          FROM product_variants
          WHERE product_id = products.id
            AND is_default
            AND lifecycle_status = 'active'
        ) <> 1
    SQL
  end

  def marker_exists?(schema, id)
    ActiveRecord::Base.connection.select_value(<<~SQL)
      SELECT EXISTS (
        SELECT 1
        FROM #{schema}.markers
        WHERE id = #{ActiveRecord::Base.connection.quote(id)}
      )
    SQL
  end

  def default_variant_ids(product_id)
    variant_record_class.where(product_id: product_id, is_default: true).pluck(:id)
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
