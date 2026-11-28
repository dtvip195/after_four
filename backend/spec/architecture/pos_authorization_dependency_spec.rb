require "rails_helper"

RSpec.describe "POS authorization dependency and activation boundaries" do
  let(:backend_root) { Rails.root }
  let(:production_files) do
    Dir[backend_root.join("{app,config,lib}/**/*.rb")].sort
  end

  it "keeps the new Domain and Application files framework-independent" do
    domain_files = Dir[backend_root.join("app/contexts/identity/domain/**/*.rb")]
    new_application_files = Dir[backend_root.join("app/contexts/{identity,organization}/application/**/*.rb")]

    domain_files.each do |path|
      source = File.read(path)
      expect(source).not_to match(/\b(?:ActiveRecord|ActionController|Pundit|Rails|Infrastructure)::?\b/), path
    end

    new_application_files.each do |path|
      source = File.read(path)
      expect(source).not_to match(/\b(?:ActiveRecord|ActionController|Pundit|Rails|Infrastructure)::?\b/), path
    end
  end

  it "keeps cross-context access on the Organization Application contract" do
    adapter_path = backend_root.join(
      "app/contexts/identity/infrastructure/adapters/organization_branch_scope_adapter.rb"
    )
    source = File.read(adapter_path)

    expect(source).to include("Organization::Application::Contracts")
    expect(source).not_to include("Organization::Infrastructure")
  end

  it "has no production caller or composition registration for business authorization" do
    references = references_to("AuthorizeBusinessOperation")
    expected_definition = backend_root.join(
      "app/contexts/identity/application/use_cases/authorize_business_operation.rb"
    ).to_s

    expect(references.keys).to eq([ expected_definition ])
    expect(File.read(backend_root.join("app/composition/identity_composition.rb")))
      .not_to match(/BusinessAuthorization|BranchScope|PosCapability/)
  end

  it "keeps the remaining deferred evidence Interfaces test-only" do
    deferred_ports = %w[
      RoleAssignmentReader
      UserEmployeeLinkReader
      EmployeeBranchScope
      SessionMfaAssurance
    ]

    deferred_ports.each do |constant_name|
      adapter_references = references_to(constant_name).select do |path, _lines|
        path.include?("/infrastructure/")
      end
      expect(adapter_references).to be_empty, "#{constant_name}: #{adapter_references.keys.join(', ')}"
    end
  end

  it "has no route, controller, policy, job, callback, initializer, or feature-flag activation" do
    activation_files = production_files.select do |path|
      path.include?("/app/controllers/") ||
        path.include?("/app/policies/") ||
        path.include?("/app/jobs/") ||
        path.include?("/config/initializers/") ||
        path.end_with?("/config/routes.rb")
    end
    forbidden = /AuthorizeBusinessOperation|BusinessAuthorizationResult|PosCapability|BranchScope/

    activation_files.each do |path|
      expect(File.read(path)).not_to match(forbidden), path
    end
  end

  it "does not expose a production consumer of policy allow evidence" do
    references = references_to("ALLOW_IN_POLICY")
    expected_policy = backend_root.join(
      "app/contexts/identity/domain/policies/pos_capability_policy.rb"
    ).to_s
    expected_use_case = backend_root.join(
      "app/contexts/identity/application/use_cases/authorize_business_operation.rb"
    ).to_s

    expect(references.keys.sort).to eq([ expected_policy, expected_use_case ].sort)
  end

  it "eager-loads without activating the module" do
    expect { Rails.application.eager_load! }.not_to raise_error
    expect(references_to("AuthorizeBusinessOperation").keys.length).to eq(1)
  end

  def references_to(text)
    production_files.each_with_object({}) do |path, found|
      source_lines = File.readlines(path)
      lines = source_lines.each_index.select { |index| source_lines[index].include?(text) }
      found[path] = lines.map { |index| index + 1 } unless lines.empty?
    end
  end
end
