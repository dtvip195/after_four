require "rails_helper"

RSpec.describe "I1 layered dependency boundaries" do
  let(:backend_root) { Rails.root }

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
end
