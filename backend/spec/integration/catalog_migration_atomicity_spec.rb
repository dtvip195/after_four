require "rails_helper"
require_relative "../support/disposable_migration_database"

RSpec.describe "Package B migration atomicity and recovery" do
  it "rolls back every Package B object and version after a controlled mid-migration failure" do
    DisposableMigrationDatabase.open do |database|
      database.migrate!(target: DisposableMigrationDatabase::A1_MIGRATION_VERSION)
      database.insert_reference_fixture
      schema_before = database.preexisting_schema_fingerprint
      data_before = database.reference_fixture_rows
      database.install_package_b_failure_injection!

      result = database.migrate!(allow_failure: true)
      failure_output = "#{result.stdout}\n#{result.stderr}"

      expect(result.status.exitstatus).to eq(1)
      expect(failure_output).to include("ActiveRecord::StatementInvalid: PG::RaiseException")
      expect(failure_output).to include(
        "CAT-TRR-008 injected failure [SQLSTATE P0001] after catalog_reject_purge"
      )
      expect(database.package_b_residue).to eq(DisposableMigrationDatabase::EMPTY_PACKAGE_B_RESIDUE)
      expect(database.migration_versions).to eq(DisposableMigrationDatabase::A1_MIGRATION_VERSIONS)
      expect(database.preexisting_schema_fingerprint).to eq(schema_before)
      expect(database.reference_fixture_rows).to eq(data_before)
      expect(database.query_value("SELECT 1")).to eq("1")
    end
  end

  it "recovers by removing only the test hook and rerunning the normal Package B migration" do
    DisposableMigrationDatabase.open do |database|
      database.migrate!(target: DisposableMigrationDatabase::A1_MIGRATION_VERSION)
      database.insert_reference_fixture
      schema_before = database.preexisting_schema_fingerprint
      data_before = database.reference_fixture_rows
      database.install_package_b_failure_injection!

      failed_result = database.migrate!(allow_failure: true)
      failure_output = "#{failed_result.stdout}\n#{failed_result.stderr}"
      expect(failed_result.status.exitstatus).to eq(1)
      expect(failure_output).to include("ActiveRecord::StatementInvalid: PG::RaiseException")
      expect(failure_output).to include(
        "CAT-TRR-008 injected failure [SQLSTATE P0001] after catalog_reject_purge"
      )
      expect(database.package_b_residue).to eq(DisposableMigrationDatabase::EMPTY_PACKAGE_B_RESIDUE)
      expect(database.migration_versions).to eq(DisposableMigrationDatabase::A1_MIGRATION_VERSIONS)

      database.remove_package_b_failure_injection!
      successful_result = database.migrate!

      expect(successful_result).to be_success
      expect(database.migration_versions).to eq(DisposableMigrationDatabase::ALL_MIGRATION_VERSIONS)
      expect(database.migration_versions.count(DisposableMigrationDatabase::PACKAGE_B_MIGRATION_VERSION)).to eq(1)
      expect(database.catalog_objects).to eq(DisposableMigrationDatabase::EXPECTED_CATALOG_OBJECTS)
      expect(database.preexisting_schema_fingerprint).to eq(schema_before)
      expect(database.reference_fixture_rows).to eq(data_before)
    end
  end
end
