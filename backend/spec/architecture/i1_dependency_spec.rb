require "rails_helper"
require "yaml"

RSpec.describe "I1 layered dependency boundaries" do
  let(:backend_root) { Rails.root }
  let(:workforce_non_application_reference) do
    /Workforce::(?!Application(?:::|\b))/
  end

  it "keeps Organization and Identity Application code framework-independent" do
    application_files = Dir[
      backend_root.join("app/contexts/{organization,identity}/application/**/*.rb")
    ]

    expect(application_files).not_to be_empty
    application_files.each do |path|
      source = File.read(path)

      expect(source).not_to match(/\b(?:ActiveRecord|ApplicationRecord|Devise|Rails|PG::)/), path
    end
  end

  it "has Infrastructure implement the inward-owned ports" do
    expect(
      Organization::Infrastructure::Persistence::ActiveRecordBrandAncestryReader.ancestors
    ).to include(Organization::Application::Ports::BrandAncestryReader)
    expect(
      Identity::Infrastructure::Adapters::OrganizationScopeAdapter.ancestors
    ).to include(Identity::Application::Ports::OrganizationScope)
    expect(
      Identity::Infrastructure::Adapters::DeviseCredentialAuthenticator.ancestors
    ).to include(Identity::Application::Ports::CredentialAuthenticator)
    expect(
      Identity::Infrastructure::Adapters::ActiveRecordSessionStore.ancestors
    ).to include(Identity::Application::Ports::SessionStore)
  end

  it "prevents cross-context persistence access" do
    identity_adapter = File.read(
      backend_root.join("app/contexts/identity/infrastructure/adapters/organization_scope_adapter.rb")
    )
    organization_reader = File.read(
      backend_root.join(
        "app/contexts/organization/infrastructure/persistence/active_record_brand_ancestry_reader.rb"
      )
    )

    expect(identity_adapter).not_to match(/Organization::Infrastructure|BrandRecord|OrganizationRecord/)
    expect(organization_reader).not_to include("Identity::")
  end

  it "keeps Identity behind future Workforce Application contracts" do
    identity_files = Dir[backend_root.join("app/contexts/identity/**/*.rb")]
    organization_files = Dir[backend_root.join("app/contexts/organization/**/*.rb")]

    identity_files.each do |path|
      expect(File.read(path)).not_to match(workforce_non_application_reference), path
    end
    organization_files.each do |path|
      expect(File.read(path)).not_to match(/\b(?:Identity|Workforce)::/), path
    end
  end

  it "keeps Workforce Domain and Application framework-independent" do
    workforce_domain_and_application = Dir[
      backend_root.join("app/contexts/workforce/{domain,application}/**/*.rb")
    ]

    expect(workforce_domain_and_application).not_to be_empty
    workforce_domain_and_application.each do |path|
      source = File.read(path)

      expect(source).not_to match(/\b(?:ActiveRecord|ApplicationRecord|Devise|Pundit|Rails|PG::)/), path
    end
  end

  it "keeps Workforce independent of Identity and Organization internals" do
    workforce_files = Dir[backend_root.join("app/contexts/workforce/**/*.rb")]

    workforce_files.each do |path|
      source = File.read(path)

      expect(source).not_to match(/\bIdentity::/), path
      expect(source).not_to match(/\bOrganization::(?!Application(?:::|\b))/), path
    end

    employee_record = File.read(
      backend_root.join("app/contexts/workforce/infrastructure/persistence/employee_record.rb")
    )
    expect(employee_record).not_to match(/\bbelongs_to\b|Organization::/)
  end

  it "keeps the schema-only Workforce package strict and root-only" do
    package = YAML.safe_load_file(backend_root.join("app/contexts/workforce/package.yml"))

    expect(package).to eq(
      "enforce_dependencies" => "strict",
      "dependencies" => [ "." ]
    )
  end

  it "adds no Membership or production Employee write entry point" do
    workforce_files = Dir[backend_root.join("app/contexts/workforce/**/*")].select { |path| File.file?(path) }
    migration_files = Dir[backend_root.join("db/migrate/*.rb")]
    composition_files = Dir[backend_root.join("app/composition/**/*.rb")]

    (workforce_files + migration_files).each do |path|
      expect(File.read(path)).not_to match(/\bMembership\b|create_table\s+:memberships/), path
    end
    composition_files.each do |path|
      expect(File.read(path)).not_to match(/Workforce::.*(?:EmployeeRepository|EmployeeRecord)/), path
    end
  end

  it "detects representative future Workforce persistence bypasses" do
    fixtures = [
      "Workforce::Infrastructure::Persistence::EmployeeRecord.find(employee_id)",
      "WorkforceAssignment = Workforce::Persistence::EmployeeBranchAssignmentRecord",
      "Workforce::Domain::EmployeeBranchAssignment.new"
    ]

    fixtures.each do |source|
      expect(source).to match(workforce_non_application_reference)
    end
  end

  it "keeps Pundit at the HTTP policy boundary" do
    identity_domain_and_application = Dir[
      backend_root.join("app/contexts/identity/{domain,application}/**/*.rb")
    ]
    policy_files = Dir[backend_root.join("app/policies/**/*.rb")]

    expect(policy_files).not_to be_empty
    identity_domain_and_application.each do |path|
      expect(File.read(path)).not_to include("Pundit"), path
    end
    policy_files.each do |path|
      source = File.read(path)

      expect(source).not_to match(/::Infrastructure|ApplicationRecord|ActiveRecord/), path
    end
  end
end
