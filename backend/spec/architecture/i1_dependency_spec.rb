require "rails_helper"

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
