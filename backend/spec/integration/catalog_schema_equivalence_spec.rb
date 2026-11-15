require "rails_helper"
require_relative "../support/disposable_migration_database"

RSpec.describe "Migration and structure.sql semantic equivalence" do
  it "builds the same PostgreSQL schema through migrations and the checked-in structure dump" do
    DisposableMigrationDatabase.open do |migration_database|
      DisposableMigrationDatabase.open do |structure_database|
        migration_database.migrate!
        structure_database.load_structure!

        expect(structure_database.server_version).to eq(migration_database.server_version)
        expect(structure_database.migration_versions).to eq(DisposableMigrationDatabase::ALL_MIGRATION_VERSIONS)
        migration_schema = migration_database.semantic_schema
        structure_schema = structure_database.semantic_schema
        migration_schema.each do |category, expected_rows|
          actual_rows = structure_schema.fetch(category)
          expect(actual_rows).to eq(expected_rows), schema_difference(category, expected_rows, actual_rows)
        end
        expect(structure_database.reference_objects).to eq(DisposableMigrationDatabase::EXPECTED_REFERENCE_OBJECTS)
        expect(structure_database.catalog_objects).to eq(DisposableMigrationDatabase::EXPECTED_CATALOG_OBJECTS)
      end
    end
  end

  def schema_difference(category, expected_rows, actual_rows)
    missing = expected_rows - actual_rows
    extra = actual_rows - expected_rows
    "Semantic schema mismatch in #{category}: missing=#{missing.first.inspect} extra=#{extra.first.inspect}"
  end
end
