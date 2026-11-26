require "rails_helper"

RSpec.describe "Workforce Employee PostgreSQL schema" do
  let(:connection) { ActiveRecord::Base.connection }

  it "uses a database-generated UUID primary key" do
    id_column = employee_columns.fetch("id")
    primary_key = employee_constraints.fetch("employees_pkey")

    expect(id_column).to include(
      "data_type" => "uuid",
      "not_null" => true,
      "default_expression" => "gen_random_uuid()"
    )
    expect(primary_key).to include(
      "constraint_type" => "p",
      "key_columns" => "id"
    )

    organization = create(:organization_record)
    generated_id = connection.select_value(<<~SQL)
      INSERT INTO employees (organization_id, created_at, updated_at)
      VALUES (#{connection.quote(organization.id)}, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
      RETURNING id::text
    SQL

    expect(generated_id).to match(
      /\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/
    )
  end

  it "uses required timestamp-with-time-zone columns" do
    expect(employee_columns.fetch("created_at")).to include(
      "data_type" => "timestamp(6) with time zone",
      "not_null" => true,
      "default_expression" => ""
    )
    expect(employee_columns.fetch("updated_at")).to include(
      "data_type" => "timestamp(6) with time zone",
      "not_null" => true,
      "default_expression" => ""
    )
  end

  it "uses the named restrictive Organization foreign key" do
    organization_column = employee_columns.fetch("organization_id")
    foreign_key = employee_constraints.fetch("fk_employees_organization")

    expect(organization_column).to include(
      "data_type" => "uuid",
      "not_null" => true,
      "default_expression" => ""
    )
    expect(foreign_key).to include(
      "constraint_type" => "f",
      "referenced_table" => "organizations",
      "delete_action" => "r",
      "key_columns" => "organization_id",
      "referenced_columns" => "id"
    )
  end

  it "uses the named lock-version check and rejects negative values" do
    lock_column = employee_columns.fetch("lock_version")
    lock_check = employee_constraints.fetch("employees_lock_version_nonnegative")

    expect(lock_column).to include(
      "data_type" => "integer",
      "not_null" => true,
      "default_expression" => "0"
    )
    expect(lock_check).to include(
      "constraint_type" => "c",
      "definition" => "CHECK (lock_version >= 0)"
    )

    organization = create(:organization_record)
    expect do
      connection.execute(<<~SQL)
        INSERT INTO employees (organization_id, lock_version, created_at, updated_at)
        VALUES (#{connection.quote(organization.id)}, -1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
      SQL
    end.to raise_error(ActiveRecord::StatementInvalid) do |error|
      expect(error.cause).to be_a(PG::CheckViolation)
      expect(
        error.cause.result.error_field(PG::Result::PG_DIAG_CONSTRAINT_NAME)
      ).to eq("employees_lock_version_nonnegative")
    end
  end

  it "uses the named non-unique Organization index" do
    index = employee_indexes.fetch("index_employees_on_organization_id")

    expect(index).to include(
      "is_unique" => false,
      "is_primary" => false,
      "key_columns" => "organization_id"
    )
  end

  def employee_columns
    connection.exec_query(<<~SQL).to_a.index_by { |row| row.fetch("column_name") }
      SELECT attributes.attname AS column_name,
             pg_catalog.format_type(attributes.atttypid, attributes.atttypmod) AS data_type,
             attributes.attnotnull AS not_null,
             COALESCE(pg_get_expr(defaults.adbin, defaults.adrelid), '') AS default_expression
      FROM pg_attribute AS attributes
      JOIN pg_class AS tables ON tables.oid = attributes.attrelid
      JOIN pg_namespace AS namespaces ON namespaces.oid = tables.relnamespace
      LEFT JOIN pg_attrdef AS defaults
        ON defaults.adrelid = attributes.attrelid
        AND defaults.adnum = attributes.attnum
      WHERE namespaces.nspname = 'public'
        AND tables.relname = 'employees'
        AND attributes.attnum > 0
        AND NOT attributes.attisdropped
      ORDER BY attributes.attnum
    SQL
  end

  def employee_constraints
    connection.exec_query(<<~SQL).to_a.index_by { |row| row.fetch("constraint_name") }
      SELECT constraints.conname AS constraint_name,
             constraints.contype::text AS constraint_type,
             COALESCE(referenced_tables.relname, '') AS referenced_table,
             constraints.confdeltype::text AS delete_action,
             pg_get_constraintdef(constraints.oid, true) AS definition,
             COALESCE((
               SELECT string_agg(attributes.attname, ',' ORDER BY keys.ordinality)
               FROM unnest(constraints.conkey) WITH ORDINALITY AS keys(attnum, ordinality)
               JOIN pg_attribute AS attributes
                 ON attributes.attrelid = constraints.conrelid
                AND attributes.attnum = keys.attnum
             ), '') AS key_columns,
             COALESCE((
               SELECT string_agg(attributes.attname, ',' ORDER BY keys.ordinality)
               FROM unnest(constraints.confkey) WITH ORDINALITY AS keys(attnum, ordinality)
               JOIN pg_attribute AS attributes
                 ON attributes.attrelid = constraints.confrelid
                AND attributes.attnum = keys.attnum
             ), '') AS referenced_columns
      FROM pg_constraint AS constraints
      JOIN pg_class AS tables ON tables.oid = constraints.conrelid
      JOIN pg_namespace AS namespaces ON namespaces.oid = tables.relnamespace
      LEFT JOIN pg_class AS referenced_tables ON referenced_tables.oid = constraints.confrelid
      WHERE namespaces.nspname = 'public'
        AND tables.relname = 'employees'
      ORDER BY constraints.conname
    SQL
  end

  def employee_indexes
    connection.exec_query(<<~SQL).to_a.index_by { |row| row.fetch("index_name") }
      SELECT indexes.relname AS index_name,
             index_data.indisunique AS is_unique,
             index_data.indisprimary AS is_primary,
             (
               SELECT string_agg(attributes.attname, ',' ORDER BY keys.ordinality)
               FROM unnest(index_data.indkey) WITH ORDINALITY AS keys(attnum, ordinality)
               JOIN pg_attribute AS attributes
                 ON attributes.attrelid = index_data.indrelid
                AND attributes.attnum = keys.attnum
             ) AS key_columns
      FROM pg_index AS index_data
      JOIN pg_class AS indexes ON indexes.oid = index_data.indexrelid
      JOIN pg_class AS tables ON tables.oid = index_data.indrelid
      JOIN pg_namespace AS namespaces ON namespaces.oid = tables.relnamespace
      WHERE namespaces.nspname = 'public'
        AND tables.relname = 'employees'
      ORDER BY indexes.relname
    SQL
  end
end
