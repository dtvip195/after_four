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
    20261126090000
  ].freeze
  A1_MIGRATION_VERSIONS = ALL_MIGRATION_VERSIONS.first(9).freeze

  A1_MIGRATION_VERSION = "20261115200000"
  PACKAGE_B_MIGRATION_VERSION = "20261115210000"
  NON_PACKAGE_B_MIGRATION_VERSIONS = (
    ALL_MIGRATION_VERSIONS - [ PACKAGE_B_MIGRATION_VERSION ]
  ).freeze

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

  EMPTY_PACKAGE_B_RESIDUE = {
    tables: [], constraints: [], indexes: [], functions: [], triggers: []
  }.freeze

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

  def migrate!(target: nil, allow_failure: false)
    command = [ "bin/rails", "db:migrate" ]
    command << "VERSION=#{target}" if target
    result = run_rails(*command)
    return result if allow_failure

    raise_command_failure(result) unless result.success?
    result
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

  def load_structure!
    result = run_rails(
      "bin/rails", "db:schema:load",
      schema_path: Rails.root.join("db/structure.sql").to_s
    )
    raise_command_failure(result) unless result.success?
    result
  end

  def migration_versions
    query_values("SELECT version FROM schema_migrations ORDER BY version")
  end

  def install_package_b_failure_injection!
    execute <<~SQL
      CREATE FUNCTION public.cat_trr_008_inject_package_b_failure()
      RETURNS event_trigger
      LANGUAGE plpgsql
      AS $function$
      DECLARE
        command record;
      BEGIN
        FOR command IN SELECT * FROM pg_event_trigger_ddl_commands()
        LOOP
          IF command.object_identity = 'public.catalog_reject_purge()' THEN
            RAISE EXCEPTION
              'CAT-TRR-008 injected failure [SQLSTATE P0001] after catalog_reject_purge'
              USING ERRCODE = 'P0001';
          END IF;
        END LOOP;
      END;
      $function$;

      CREATE EVENT TRIGGER cat_trr_008_package_b_failure
      ON ddl_command_end
      WHEN TAG IN ('CREATE FUNCTION')
      EXECUTE FUNCTION public.cat_trr_008_inject_package_b_failure();
    SQL
  end

  def remove_package_b_failure_injection!
    execute <<~SQL
      DROP EVENT TRIGGER IF EXISTS cat_trr_008_package_b_failure;
      DROP FUNCTION IF EXISTS public.cat_trr_008_inject_package_b_failure();
    SQL
  end

  def package_b_residue
    tables = %w[categories products product_variants]
    table_names = tables.map { |table| sql_literal(table) }.join(", ")
    {
      tables: query_values(<<~SQL),
        SELECT relname
        FROM pg_class
        WHERE relnamespace = 'public'::regnamespace
          AND relkind IN ('r', 'p')
          AND relname IN (#{table_names})
        ORDER BY relname
      SQL
      constraints: query_values(<<~SQL),
        SELECT constraints.conname
        FROM pg_constraint AS constraints
        JOIN pg_class AS tables ON tables.oid = constraints.conrelid
        WHERE tables.relnamespace = 'public'::regnamespace
          AND tables.relname IN (#{table_names})
        ORDER BY constraints.conname
      SQL
      indexes: query_values(<<~SQL),
        SELECT indexname
        FROM pg_indexes
        WHERE schemaname = 'public'
          AND tablename IN (#{table_names})
        ORDER BY indexname
      SQL
      functions: query_values("SELECT proname FROM pg_proc WHERE proname LIKE 'catalog_%' ORDER BY proname"),
      triggers: query_values(<<~SQL)
        SELECT triggers.tgname
        FROM pg_trigger AS triggers
        JOIN pg_class AS tables ON tables.oid = triggers.tgrelid
        WHERE NOT triggers.tgisinternal
          AND tables.relnamespace = 'public'::regnamespace
          AND tables.relname IN (#{table_names})
        ORDER BY triggers.tgname
      SQL
    }
  end

  def server_version
    query_value("SHOW server_version")
  end

  def semantic_schema
    {
      settings: query_rows(<<~SQL),
        SELECT current_setting('server_version'), pg_encoding_to_char(encoding),
               datlocprovider::text, datcollate, datctype,
               COALESCE(datlocale, ''), COALESCE(daticurules, ''),
               COALESCE(datcollversion, ''),
               current_setting('default_transaction_isolation')
        FROM pg_database
        WHERE datname = current_database()
      SQL
      namespaces: query_rows(<<~SQL),
        SELECT nspname
        FROM pg_namespace
        WHERE nspname = 'public'
        ORDER BY nspname
      SQL
      extensions: query_rows(<<~SQL),
        SELECT extensions.extname, extensions.extversion, namespaces.nspname
        FROM pg_extension AS extensions
        JOIN pg_namespace AS namespaces ON namespaces.oid = extensions.extnamespace
        ORDER BY extensions.extname
      SQL
      tables: query_rows(<<~SQL),
        SELECT classes.relname, classes.relkind::text, classes.relpersistence::text,
               classes.relrowsecurity::text, classes.relforcerowsecurity::text,
               classes.relreplident::text, COALESCE(access_methods.amname, ''),
               COALESCE(array_to_string(classes.reloptions, ','), '')
        FROM pg_class AS classes
        JOIN pg_namespace AS namespaces ON namespaces.oid = classes.relnamespace
        LEFT JOIN pg_am AS access_methods ON access_methods.oid = classes.relam
        WHERE namespaces.nspname = 'public'
          AND classes.relkind IN ('r', 'p', 'v', 'm', 'f')
        ORDER BY classes.relname
      SQL
      columns: query_rows(<<~SQL),
        SELECT classes.relname, attributes.attnum::text, attributes.attname,
               pg_catalog.format_type(attributes.atttypid, attributes.atttypmod),
               attributes.attnotnull::text,
               COALESCE(pg_get_expr(defaults.adbin, defaults.adrelid), ''),
               attributes.attidentity::text, attributes.attgenerated::text,
               COALESCE(collations.collname, ''), attributes.attstorage::text,
               attributes.attcompression::text
        FROM pg_attribute AS attributes
        JOIN pg_class AS classes ON classes.oid = attributes.attrelid
        JOIN pg_namespace AS namespaces ON namespaces.oid = classes.relnamespace
        LEFT JOIN pg_attrdef AS defaults
          ON defaults.adrelid = attributes.attrelid AND defaults.adnum = attributes.attnum
        LEFT JOIN pg_collation AS collations ON collations.oid = attributes.attcollation
        WHERE namespaces.nspname = 'public'
          AND classes.relkind IN ('r', 'p', 'v', 'm', 'f')
          AND attributes.attnum > 0
          AND NOT attributes.attisdropped
        ORDER BY classes.relname, attributes.attnum
      SQL
      constraints: normalize_constraint_rows(query_rows(<<~SQL)),
        SELECT classes.relname, constraints.conname, constraints.contype::text,
               constraints.condeferrable::text, constraints.condeferred::text,
               constraints.convalidated::text, pg_get_constraintdef(constraints.oid, true)
        FROM pg_constraint AS constraints
        JOIN pg_namespace AS namespaces ON namespaces.oid = constraints.connamespace
        LEFT JOIN pg_class AS classes ON classes.oid = constraints.conrelid
        WHERE namespaces.nspname = 'public'
        ORDER BY classes.relname NULLS FIRST, constraints.conname
      SQL
      indexes: query_rows(<<~SQL),
        SELECT tables.relname, indexes.relname, index_data.indisunique::text,
               index_data.indisprimary::text, index_data.indisvalid::text,
               index_data.indisready::text, index_data.indnullsnotdistinct::text,
               index_data.indnkeyatts::text, pg_get_indexdef(indexes.oid)
        FROM pg_index AS index_data
        JOIN pg_class AS indexes ON indexes.oid = index_data.indexrelid
        JOIN pg_class AS tables ON tables.oid = index_data.indrelid
        JOIN pg_namespace AS namespaces ON namespaces.oid = tables.relnamespace
        WHERE namespaces.nspname = 'public'
        ORDER BY tables.relname, indexes.relname
      SQL
      sequences: query_rows(<<~SQL),
        SELECT sequences.relname, pg_catalog.format_type(sequence_data.seqtypid, NULL),
               sequence_data.seqstart::text, sequence_data.seqincrement::text,
               sequence_data.seqmax::text, sequence_data.seqmin::text,
               sequence_data.seqcache::text, sequence_data.seqcycle::text,
               COALESCE(owned_table.relname, ''), COALESCE(owned_attribute.attname, '')
        FROM pg_sequence AS sequence_data
        JOIN pg_class AS sequences ON sequences.oid = sequence_data.seqrelid
        JOIN pg_namespace AS namespaces ON namespaces.oid = sequences.relnamespace
        LEFT JOIN pg_depend AS ownership
          ON ownership.classid = 'pg_class'::regclass
          AND ownership.objid = sequences.oid
          AND ownership.deptype = 'a'
        LEFT JOIN pg_class AS owned_table ON owned_table.oid = ownership.refobjid
        LEFT JOIN pg_attribute AS owned_attribute
          ON owned_attribute.attrelid = ownership.refobjid
          AND owned_attribute.attnum = ownership.refobjsubid
        WHERE namespaces.nspname = 'public'
        ORDER BY sequences.relname
      SQL
      functions: query_rows(<<~SQL),
        SELECT procedures.proname,
               pg_get_function_identity_arguments(procedures.oid),
               pg_get_function_result(procedures.oid), languages.lanname,
               procedures.provolatile::text, procedures.proisstrict::text,
               procedures.prosecdef::text, procedures.proleakproof::text,
               procedures.proparallel::text,
               COALESCE(array_to_string(procedures.proconfig, ','), ''),
               pg_get_functiondef(procedures.oid)
        FROM pg_proc AS procedures
        JOIN pg_namespace AS namespaces ON namespaces.oid = procedures.pronamespace
        JOIN pg_language AS languages ON languages.oid = procedures.prolang
        WHERE namespaces.nspname = 'public'
        ORDER BY procedures.proname, pg_get_function_identity_arguments(procedures.oid)
      SQL
      triggers: query_rows(<<~SQL),
        SELECT tables.relname, triggers.tgname, triggers.tgenabled::text,
               triggers.tgdeferrable::text, triggers.tginitdeferred::text,
               pg_get_triggerdef(triggers.oid, true)
        FROM pg_trigger AS triggers
        JOIN pg_class AS tables ON tables.oid = triggers.tgrelid
        JOIN pg_namespace AS namespaces ON namespaces.oid = tables.relnamespace
        WHERE namespaces.nspname = 'public'
          AND NOT triggers.tgisinternal
        ORDER BY tables.relname, triggers.tgname
      SQL
      types: query_rows(<<~SQL)
        SELECT types.typname, types.typtype::text,
               COALESCE(pg_catalog.format_type(types.typbasetype, types.typtypmod), ''),
               types.typnotnull::text, COALESCE(types.typdefault, '')
        FROM pg_type AS types
        JOIN pg_namespace AS namespaces ON namespaces.oid = types.typnamespace
        WHERE namespaces.nspname = 'public'
          AND types.typtype IN ('d', 'e', 'm', 'r')
        ORDER BY types.typname
      SQL
    }
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
    with_connection do |connection|
      params.empty? ? connection.exec(sql) : connection.exec_params(sql, params)
    end
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
          AND table_name NOT IN (
            'schema_migrations', 'ar_internal_metadata', 'categories', 'products', 'product_variants',
            'users', 'authentication_sessions'
          )
        ORDER BY table_name, ordinal_position
      SQL
      constraints: query_rows(<<~SQL),
        SELECT conrelid::regclass::text, conname, contype::text, pg_get_constraintdef(oid, true)
        FROM pg_constraint
        WHERE connamespace = 'public'::regnamespace
          AND conrelid <> 0
          AND conrelid::regclass::text NOT IN (
            'categories', 'products', 'product_variants', 'users', 'authentication_sessions'
          )
        ORDER BY conrelid::regclass::text, conname
      SQL
      indexes: query_rows(<<~SQL),
        SELECT tablename, indexname, indexdef
        FROM pg_indexes
        WHERE schemaname = 'public'
          AND tablename NOT IN (
            'schema_migrations', 'ar_internal_metadata', 'categories', 'products', 'product_variants',
            'users', 'authentication_sessions'
          )
        ORDER BY tablename, indexname
      SQL
      functions: query_rows(<<~SQL),
        SELECT proname, pg_get_functiondef(oid)
        FROM pg_proc
        WHERE pronamespace = 'public'::regnamespace
          AND proname NOT LIKE 'catalog_%'
          AND proname NOT LIKE 'cat_trr_008_%'
        ORDER BY proname, oid
      SQL
      triggers: query_rows(<<~SQL)
        SELECT tgrelid::regclass::text, tgname, pg_get_triggerdef(oid, true)
        FROM pg_trigger
        WHERE NOT tgisinternal
          AND tgrelid::regclass::text NOT IN (
            'categories', 'products', 'product_variants', 'users', 'authentication_sessions'
          )
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

  def normalize_constraint_rows(rows)
    # PostgreSQL 18 rewrites the same varchar ANY-array check differently after
    # pg_dump/load. Keep every literal and operator while normalizing only the
    # redundant element and array casts introduced by that round trip.
    rows.map do |row|
      definition = row.fetch(6)
        .gsub("::character varying::text", "::character varying")
        .gsub("]::text[]", "]")
      row[0...6] + [ definition ]
    end
  end

  def run_rails!(*command)
    result = run_rails(*command)
    raise_command_failure(result) unless result.success?
    result
  end

  def run_rails(*command, schema_path: nil)
    temporary_schema_path = schema_path.nil?
    schema_dump_path = schema_path || File.join(Dir.tmpdir, "#{name}_structure.sql")
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
    if temporary_schema_path && schema_dump_path && File.exist?(schema_dump_path)
      File.delete(schema_dump_path)
    end
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
