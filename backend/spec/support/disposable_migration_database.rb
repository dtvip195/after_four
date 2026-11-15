require "open3"
require "pg"
require "securerandom"
require "tmpdir"

class DisposableMigrationDatabase
  COMMAND_TIMEOUT_SECONDS = 60
  DATABASE_PREFIX = "after_four_migration_evidence_test_"

  ALL_MIGRATION_VERSIONS = %w[
    20261114044646
    20261114192000
    20261114193000
    20261114194000
    20261114200000
    20261114201000
    20261114202000
    20261114203000
    20261115200000
    20261115210000
  ].freeze
  A1_MIGRATION_VERSIONS = ALL_MIGRATION_VERSIONS.first(9).freeze

  A1_MIGRATION_VERSION = "20261115200000"
  PACKAGE_B_MIGRATION_VERSION = "20261115210000"

  EXPECTED_CATALOG_OBJECTS = {
    tables: %w[categories product_variants products],
    constraints: %w[
      categories_code_canonical categories_lifecycle_allowed categories_lock_version_nonnegative
      categories_name_nonblank categories_pkey categories_position_nonnegative fk_categories_brand
      fk_product_variants_brand fk_product_variants_product_brand fk_products_brand
      fk_products_category_brand product_variants_code_canonical product_variants_lifecycle_allowed
      product_variants_lock_version_nonnegative product_variants_name_nonblank product_variants_pkey
      product_variants_position_nonnegative products_code_canonical products_lifecycle_allowed
      products_lock_version_nonnegative products_name_nonblank products_pkey
    ],
    indexes: %w[
      index_categories_on_brand_status_position index_product_variants_on_product_status_id
      index_products_on_category_status uq_categories_brand_code uq_categories_id_brand
      uq_product_variants_brand_code uq_product_variants_one_default uq_products_brand_code
      uq_products_id_brand
    ],
    functions: %w[
      catalog_enforce_category_initial_status catalog_enforce_category_transition
      catalog_enforce_variant_initial_status catalog_enforce_variant_transition
      catalog_reject_category_scope_change catalog_reject_product_scope_change catalog_reject_purge
      catalog_reject_variant_scope_change catalog_validate_active_product_category
      catalog_validate_active_product_default
    ],
    triggers: %w[
      catalog_categories_product_final_state catalog_product_variants_default_final_state
      catalog_products_category_final_state catalog_products_default_final_state
      categories_initial_lifecycle_draft categories_lifecycle_transition_allowed
      categories_purge_forbidden categories_scope_immutable product_variants_initial_lifecycle_draft
      product_variants_lifecycle_transition_allowed product_variants_purge_forbidden
      product_variants_scope_immutable products_purge_forbidden products_scope_immutable
    ]
  }.transform_values { |values| values.sort.freeze }.freeze

  EXPECTED_REFERENCE_OBJECTS = {
    tables: %w[branches brands organizations],
    constraints: %w[
      branches_name_nonblank branches_pkey branches_timezone_name_nonblank brands_name_nonblank
      brands_pkey fk_branches_brand fk_brands_organization organizations_name_nonblank
      organizations_pkey
    ],
    indexes: %w[index_branches_on_brand_id index_brands_on_organization_id]
  }.transform_values { |values| values.sort.freeze }.freeze

  CommandResult = Data.define(:command, :stdout, :stderr, :status) do
    def success?
      status.success?
    end
  end

  def self.open
    database = new
    database.create!
    yield database
  ensure
    database&.drop!
  end

  attr_reader :name

  def initialize
    @name = "#{DATABASE_PREFIX}#{Process.pid}_#{SecureRandom.hex(6)}"
  end

  def create!
    with_admin_connection do |connection|
      connection.exec("CREATE DATABASE #{quoted_name}")
    end
  end

  def drop!
    validate_name!
    with_admin_connection do |connection|
      connection.exec("DROP DATABASE IF EXISTS #{quoted_name} WITH (FORCE)")
    end
  end

  def migrate!(target: nil)
    command = [ "bin/rails", "db:migrate" ]
    command << "VERSION=#{target}" if target
    run_rails!(*command)
  end

  def migrate_down!(version: PACKAGE_B_MIGRATION_VERSION, allow_failure: false)
    result = run_rails("bin/rails", "db:migrate:down", "VERSION=#{version}")
    return result if allow_failure

    raise_command_failure(result) unless result.success?
    result
  end

  def migrate_up!(version: PACKAGE_B_MIGRATION_VERSION)
    run_rails!("bin/rails", "db:migrate:up", "VERSION=#{version}")
  end

  def migration_versions
    query_values("SELECT version FROM schema_migrations ORDER BY version")
  end

  def server_version
    query_value("SHOW server_version")
  end

  def catalog_objects
    {
      tables: existing_tables(%w[categories product_variants products]),
      constraints: named_constraints(%w[categories product_variants products]),
      indexes: named_indexes(%w[categories product_variants products], %w[categories_pkey products_pkey product_variants_pkey]),
      functions: query_values("SELECT proname FROM pg_proc WHERE proname LIKE 'catalog_%' ORDER BY proname"),
      triggers: query_values(<<~SQL)
        SELECT tgname
        FROM pg_trigger
        WHERE NOT tgisinternal
          AND tgrelid IN ('categories'::regclass, 'products'::regclass, 'product_variants'::regclass)
        ORDER BY tgname
      SQL
    }
  end

  def reference_objects
    {
      tables: existing_tables(%w[branches brands organizations]),
      constraints: named_constraints(%w[branches brands organizations]),
      indexes: named_indexes(%w[branches brands organizations], %w[branches_pkey brands_pkey organizations_pkey])
    }
  end

  def catalog_absent?
    catalog_table_count = query_value(<<~SQL).to_i
      SELECT COUNT(*)
      FROM pg_class
      WHERE relnamespace = 'public'::regnamespace
        AND relname IN ('categories', 'products', 'product_variants')
    SQL
    function_count = query_value("SELECT COUNT(*) FROM pg_proc WHERE proname LIKE 'catalog_%'").to_i
    catalog_table_count.zero? && function_count.zero?
  end

  def execute(sql, params = [])
    with_connection { |connection| connection.exec_params(sql, params) }
  end

  def query_rows(sql)
    with_connection { |connection| connection.exec(sql).values }
  end

  def preexisting_schema_fingerprint
    {
      columns: query_rows(<<~SQL),
        SELECT table_name, column_name, data_type, udt_name, is_nullable, COALESCE(column_default, '')
        FROM information_schema.columns
        WHERE table_schema = 'public'
          AND table_name NOT IN ('schema_migrations', 'ar_internal_metadata', 'categories', 'products', 'product_variants')
        ORDER BY table_name, ordinal_position
      SQL
      constraints: query_rows(<<~SQL),
        SELECT conrelid::regclass::text, conname, contype::text, pg_get_constraintdef(oid, true)
        FROM pg_constraint
        WHERE connamespace = 'public'::regnamespace
          AND conrelid <> 0
          AND conrelid::regclass::text NOT IN ('categories', 'products', 'product_variants')
        ORDER BY conrelid::regclass::text, conname
      SQL
      indexes: query_rows(<<~SQL),
        SELECT tablename, indexname, indexdef
        FROM pg_indexes
        WHERE schemaname = 'public'
          AND tablename NOT IN ('schema_migrations', 'ar_internal_metadata', 'categories', 'products', 'product_variants')
        ORDER BY tablename, indexname
      SQL
      functions: query_rows(<<~SQL),
        SELECT proname, pg_get_functiondef(oid)
        FROM pg_proc
        WHERE pronamespace = 'public'::regnamespace
          AND proname NOT LIKE 'catalog_%'
        ORDER BY proname, oid
      SQL
      triggers: query_rows(<<~SQL)
        SELECT tgrelid::regclass::text, tgname, pg_get_triggerdef(oid, true)
        FROM pg_trigger
        WHERE NOT tgisinternal
          AND tgrelid::regclass::text NOT IN ('categories', 'products', 'product_variants')
        ORDER BY tgrelid::regclass::text, tgname
      SQL
    }
  end

  def insert_reference_fixture
    organization_id = SecureRandom.uuid
    brand_id = SecureRandom.uuid
    branch_id = SecureRandom.uuid
    execute(
      "INSERT INTO organizations (id, name, lock_version, created_at, updated_at) " \
      "VALUES ($1, 'Migration Evidence Organization', 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)",
      [ organization_id ]
    )
    execute(
      "INSERT INTO brands (id, organization_id, name, lock_version, created_at, updated_at) " \
      "VALUES ($1, $2, 'Migration Evidence Brand', 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)",
      [ brand_id, organization_id ]
    )
    execute(
      "INSERT INTO branches (id, brand_id, name, timezone_name, lock_version, created_at, updated_at) " \
      "VALUES ($1, $2, 'Migration Evidence Branch', 'UTC', 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)",
      [ branch_id, brand_id ]
    )
    { organization_id: organization_id, brand_id: brand_id, branch_id: branch_id }
  end

  def insert_catalog_fixture(brand_id:)
    category_id = SecureRandom.uuid
    product_id = SecureRandom.uuid
    variant_id = SecureRandom.uuid
    execute(
      "INSERT INTO categories (id, brand_id, code, name, created_at, updated_at) " \
      "VALUES ($1, $2, 'ROLLBACK_CATEGORY', 'Rollback Category', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)",
      [ category_id, brand_id ]
    )
    execute(
      "INSERT INTO products (id, brand_id, category_id, code, name, lifecycle_status, created_at, updated_at) " \
      "VALUES ($1, $2, $3, 'ROLLBACK_PRODUCT', 'Rollback Product', 'draft', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)",
      [ product_id, brand_id, category_id ]
    )
    execute(
      "INSERT INTO product_variants " \
      "(id, brand_id, product_id, code, name, is_default, customer_visible, created_at, updated_at) " \
      "VALUES ($1, $2, $3, 'ROLLBACK_VARIANT', 'Rollback Variant', true, false, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)",
      [ variant_id, brand_id, product_id ]
    )
    { category_id: category_id, product_id: product_id, variant_id: variant_id }
  end

  def reference_fixture_rows
    {
      organizations: query_rows("SELECT * FROM organizations ORDER BY id"),
      brands: query_rows("SELECT * FROM brands ORDER BY id"),
      branches: query_rows("SELECT * FROM branches ORDER BY id")
    }
  end

  def catalog_fixture_rows
    {
      categories: query_rows("SELECT * FROM categories ORDER BY id"),
      products: query_rows("SELECT * FROM products ORDER BY id"),
      product_variants: query_rows("SELECT * FROM product_variants ORDER BY id")
    }
  end

  def query_value(sql)
    with_connection { |connection| connection.exec(sql).getvalue(0, 0) }
  end

  def query_values(sql)
    with_connection { |connection| connection.exec(sql).column_values(0) }
  end

  private

  def run_rails!(*command)
    result = run_rails(*command)
    raise_command_failure(result) unless result.success?
    result
  end

  def run_rails(*command)
    schema_dump_path = File.join(Dir.tmpdir, "#{name}_structure.sql")
    environment = {
      "RAILS_ENV" => "test",
      "POSTGRES_TEST_DATABASE" => name,
      "SCHEMA" => schema_dump_path
    }
    stdout = +""
    stderr = +""
    status = nil

    Open3.popen3(environment, *command, chdir: Rails.root.to_s, pgroup: true) do |stdin, child_stdout, child_stderr, wait_thread|
      stdin.close
      stdout_reader = Thread.new { child_stdout.read }
      stderr_reader = Thread.new { child_stderr.read }

      unless wait_thread.join(COMMAND_TIMEOUT_SECONDS)
        terminate_process_group(wait_thread.pid)
        wait_thread.join(5)
        raise "Timed out after #{COMMAND_TIMEOUT_SECONDS}s: #{command.join(' ')}"
      end

      status = wait_thread.value
      stdout = stdout_reader.value
      stderr = stderr_reader.value
    ensure
      stdout_reader&.kill if stdout_reader&.alive?
      stderr_reader&.kill if stderr_reader&.alive?
    end

    CommandResult.new(command: command.freeze, stdout: stdout, stderr: stderr, status: status)
  ensure
    File.delete(schema_dump_path) if schema_dump_path && File.exist?(schema_dump_path)
  end

  def terminate_process_group(pid)
    Process.kill("TERM", -pid)
    sleep 0.1
    Process.kill("KILL", -pid)
  rescue Errno::ESRCH
    nil
  end

  def raise_command_failure(result)
    raise <<~MESSAGE
      Command failed (#{result.status.exitstatus}): #{result.command.join(' ')}
      stdout:
      #{result.stdout}
      stderr:
      #{result.stderr}
    MESSAGE
  end

  def existing_tables(names)
    quoted_names = names.map { |table| sql_literal(table) }.join(", ")
    query_values(<<~SQL)
      SELECT relname
      FROM pg_class
      WHERE relnamespace = 'public'::regnamespace
        AND relkind = 'r'
        AND relname IN (#{quoted_names})
      ORDER BY relname
    SQL
  end

  def named_constraints(tables)
    relations = tables.map { |table| "'#{table}'::regclass" }.join(", ")
    query_values(<<~SQL)
      SELECT conname
      FROM pg_constraint
      WHERE conrelid IN (#{relations})
        AND contype IN ('c', 'f', 'p', 'u', 'x')
      ORDER BY conname
    SQL
  end

  def named_indexes(tables, excluded)
    table_names = tables.map { |table| sql_literal(table) }.join(", ")
    excluded_names = excluded.map { |index| sql_literal(index) }.join(", ")
    query_values(<<~SQL)
      SELECT indexname
      FROM pg_indexes
      WHERE schemaname = 'public'
        AND tablename IN (#{table_names})
        AND indexname NOT IN (#{excluded_names})
      ORDER BY indexname
    SQL
  end

  def with_connection
    connection = PG.connect(**connection_options.merge(dbname: name, connect_timeout: 5))
    connection.exec("SET statement_timeout = '10s'")
    yield connection
  ensure
    connection&.close
  end

  def with_admin_connection
    connection = PG.connect(**connection_options.merge(dbname: "postgres", connect_timeout: 5))
    connection.exec("SET statement_timeout = '10s'")
    yield connection
  ensure
    connection&.close
  end

  def connection_options
    configuration = ActiveRecord::Base.connection_db_config.configuration_hash
    {
      host: configuration.fetch(:host),
      port: configuration.fetch(:port),
      user: configuration.fetch(:username),
      password: configuration.fetch(:password)
    }
  end

  def quoted_name
    validate_name!
    PG::Connection.quote_ident(name)
  end

  def sql_literal(value)
    raise "Unsafe catalog identifier: #{value.inspect}" unless value.match?(/\A[a-z0-9_]+\z/)

    "'#{value}'"
  end

  def validate_name!
    return if name.match?(/\A#{DATABASE_PREFIX}[a-zA-Z0-9_]+\z/)

    raise "Refusing disposable database operation for unsafe name: #{name.inspect}"
  end
end
