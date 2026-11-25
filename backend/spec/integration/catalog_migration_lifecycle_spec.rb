require "rails_helper"
require_relative "../support/disposable_migration_database"

RSpec.describe "Package B migration lifecycle" do
  it "runs the complete migration chain in a genuinely empty database" do
    DisposableMigrationDatabase.open do |database|
      database.migrate!

      expect(database.server_version).to start_with("18.7")
      expect(database.migration_versions).to eq(DisposableMigrationDatabase::ALL_MIGRATION_VERSIONS)
      expect(database.reference_objects).to eq(DisposableMigrationDatabase::EXPECTED_REFERENCE_OBJECTS)
      expect(database.catalog_objects).to eq(DisposableMigrationDatabase::EXPECTED_CATALOG_OBJECTS)
    end
  end

  it "upgrades the A1 baseline without changing its schema or synthetic data" do
    DisposableMigrationDatabase.open do |database|
      database.migrate!(target: DisposableMigrationDatabase::A1_MIGRATION_VERSION)
      expect(database.migration_versions).to eq(DisposableMigrationDatabase::A1_MIGRATION_VERSIONS)
      expect(database.reference_objects).to eq(DisposableMigrationDatabase::EXPECTED_REFERENCE_OBJECTS)
      expect(database.catalog_absent?).to be(true)

      database.insert_reference_fixture
      schema_before = database.preexisting_schema_fingerprint
      data_before = database.reference_fixture_rows

      database.migrate!

      expect(database.migration_versions).to eq(DisposableMigrationDatabase::ALL_MIGRATION_VERSIONS)
      expect(database.preexisting_schema_fingerprint).to eq(schema_before)
      expect(database.reference_fixture_rows).to eq(data_before)
      expect(database.catalog_objects).to eq(DisposableMigrationDatabase::EXPECTED_CATALOG_OBJECTS)
    end
  end

  it "rolls back an empty Package B schema, preserves A1, and reapplies Package B" do
    DisposableMigrationDatabase.open do |database|
      database.migrate!
      reference_objects = database.reference_objects

      database.migrate_down!

      expect(database.catalog_absent?).to be(true)
      expect(database.reference_objects).to eq(reference_objects)
      expect(database.migration_versions).to eq(
        DisposableMigrationDatabase::NON_PACKAGE_B_MIGRATION_VERSIONS
      )

      database.migrate_up!

      expect(database.migration_versions).to eq(DisposableMigrationDatabase::ALL_MIGRATION_VERSIONS)
      expect(database.catalog_objects).to eq(DisposableMigrationDatabase::EXPECTED_CATALOG_OBJECTS)
    end
  end

  it "refuses a non-empty Package B rollback without changing data, schema, or version tracking" do
    DisposableMigrationDatabase.open do |database|
      database.migrate!
      reference_ids = database.insert_reference_fixture
      database.insert_catalog_fixture(brand_id: reference_ids.fetch(:brand_id))
      rows_before = database.catalog_fixture_rows
      objects_before = database.catalog_objects

      result = database.migrate_down!(allow_failure: true)

      expect(result).not_to be_success
      expect(result.status.exitstatus).to eq(1)
      expect("#{result.stdout}\n#{result.stderr}").to include(
        "Package B rollback refused because product_variants contains data"
      )
      expect(database.catalog_fixture_rows).to eq(rows_before)
      expect(database.catalog_objects).to eq(objects_before)
      expect(database.migration_versions).to eq(DisposableMigrationDatabase::ALL_MIGRATION_VERSIONS)
    end
  end
end
