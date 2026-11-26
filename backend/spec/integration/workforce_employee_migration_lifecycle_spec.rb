require "rails_helper"
require_relative "../support/disposable_migration_database"

RSpec.describe "Workforce Employee Foundation migration lifecycle" do
  WORKFORCE_EMPLOYEE_MIGRATION_VERSION = "20261126120000"
  EMPLOYEE_TABLE_CATEGORIES = %i[tables columns constraints indexes triggers].freeze

  it "rolls back only Employee schema objects and restores them on reapply" do
    DisposableMigrationDatabase.open do |database|
      database.migrate!
      expect(database.server_version).to start_with("18.7")

      schema_before = database.semantic_schema
      employee_schema_before = employee_schema(schema_before)
      unrelated_schema_before = without_employee_schema(schema_before)

      expect(employee_schema_before.fetch(:tables)).not_to be_empty
      expect(database.migration_versions).to include(WORKFORCE_EMPLOYEE_MIGRATION_VERSION)

      database.migrate_down!(version: WORKFORCE_EMPLOYEE_MIGRATION_VERSION)

      schema_after_rollback = database.semantic_schema
      expect(employee_schema(schema_after_rollback).values).to all(be_empty)
      expect(without_employee_schema(schema_after_rollback)).to eq(unrelated_schema_before)
      expect(database.migration_versions).not_to include(WORKFORCE_EMPLOYEE_MIGRATION_VERSION)

      database.migrate_up!(version: WORKFORCE_EMPLOYEE_MIGRATION_VERSION)

      expect(database.semantic_schema).to eq(schema_before)
      expect(database.migration_versions).to include(WORKFORCE_EMPLOYEE_MIGRATION_VERSION)
    end
  end

  def employee_schema(schema)
    EMPLOYEE_TABLE_CATEGORIES.to_h do |category|
      [ category, schema.fetch(category).select { |row| row.first == "employees" } ]
    end
  end

  def without_employee_schema(schema)
    schema.to_h do |category, rows|
      next [ category, rows ] unless EMPLOYEE_TABLE_CATEGORIES.include?(category)

      [ category, rows.reject { |row| row.first == "employees" } ]
    end
  end
end
