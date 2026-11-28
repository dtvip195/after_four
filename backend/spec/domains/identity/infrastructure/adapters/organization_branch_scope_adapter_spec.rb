require "rails_helper"

RSpec.describe Identity::Infrastructure::Adapters::OrganizationBranchScopeAdapter do
  describe "IdentityBranchReference" do
    it "constructs an immutable canonical UUID value with coherent equality and hashing" do
      canonical_value = "aaaaaaaa-aaaa-0000-0000-aaaaaaaaaaaa"
      mutable_source = canonical_value.dup

      reference = Identity::Application::Contracts::IdentityBranchReference.new(mutable_source)
      equivalent = Identity::Application::Contracts::IdentityBranchReference.new(canonical_value)
      mutable_source.replace("bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb")

      expect(reference.value).to eq(canonical_value)
      expect(reference.value).not_to equal(mutable_source)
      expect(reference.value).to be_frozen
      expect(reference).to be_frozen
      expect(reference).to eq(equivalent)
      expect(reference).to eql(equivalent)
      expect(reference.hash).to eq(equivalent.hash)
    end

    it "rejects noncanonical values without imposing UUID version semantics" do
      canonical_value = "aaaaaaaa-aaaa-0000-0000-aaaaaaaaaaaa"
      invalid_values = [ nil, 123, "", canonical_value.upcase, "aaaaaaaa-aaaa-0000-0000-aaaaaaaaaaa" ]

      expect { Identity::Application::Contracts::IdentityBranchReference.new(canonical_value) }.not_to raise_error
      invalid_values.each do |value|
        expect do
          Identity::Application::Contracts::IdentityBranchReference.new(value)
        end.to raise_error(ArgumentError, "value must be a canonical UUID")
      end
    end

    it "cannot be subclassed to impersonate an Identity Branch reference" do
      expect do
        Class.new(Identity::Application::Contracts::IdentityBranchReference)
      end.to raise_error(TypeError, "Identity::Application::Contracts::IdentityBranchReference cannot be subclassed")
    end
  end

  let(:identity_branch_reference) do
    Identity::Application::Contracts::IdentityBranchReference.new(
      "11111111-1111-1111-1111-111111111111"
    )
  end
  let(:organization_branch_reference) do
    Organization::Application::Contracts::BranchReference.new(identity_branch_reference.value)
  end
  let(:brand_reference) do
    Organization::Application::Contracts::BrandReference.new(
      "22222222-2222-2222-2222-222222222222"
    )
  end
  let(:organization_reference) do
    Organization::Application::Contracts::OrganizationReference.new(
      "33333333-3333-3333-3333-333333333333"
    )
  end

  it "maps a complete Organization result into immutable Identity-owned evidence" do
    ancestry = Organization::Application::Contracts::BranchAncestry.new(
      branch_id: organization_branch_reference,
      brand_id: brand_reference,
      organization_id: organization_reference
    )
    organization_result = Organization::Application::Contracts::ResolveBranchAncestryResult.resolved(ancestry)

    result = described_adapter(organization_result).call(identity_branch_reference)

    expect(result).to be_resolved
    expect(result.evidence.branch_id.value).to eq(identity_branch_reference.value)
    expect(result.evidence.brand_id.value).to eq(brand_reference.value)
    expect(result.evidence.organization_id.value).to eq(organization_reference.value)
    expect(result.evidence).to be_frozen
    expect(result.evidence.branch_id).to be_a(Identity::Application::Contracts::IdentityBranchReference)
    expect(result.evidence.brand_id).to be_a(Identity::Application::Contracts::IdentityBrandReference)
    expect(result.evidence.organization_id).to be_a(
      Identity::Application::Contracts::IdentityOrganizationReference
    )
  end

  it "maps all non-success normal Organization outcomes" do
    result_class = Organization::Application::Contracts::ResolveBranchAncestryResult

    expect(described_adapter(result_class.not_found).call(identity_branch_reference)).to be_not_found
    expect(described_adapter(result_class.invalid).call(identity_branch_reference)).to be_invalid
    expect(described_adapter(result_class.inconsistent).call(identity_branch_reference)).to be_inconsistent
  end

  it "returns invalid without calling Organization for a wrong internal input type" do
    organization_query = instance_spy(Organization::Application::Queries::ResolveBranchAncestry)

    result = described_class.new(organization_query: organization_query).call(identity_branch_reference.value)

    expect(result).to be_invalid
    expect(organization_query).not_to have_received(:call)
  end

  it "preserves the exact originating availability reference value" do
    organization_failure_reference = Organization::Application::Contracts::SafeFailureReference.new(
      "44444444-4444-4444-4444-444444444444"
    )
    organization_result = Organization::Application::Contracts::ResolveBranchAncestryResult.unavailable(
      organization_failure_reference
    )

    result = described_adapter(organization_result).call(identity_branch_reference)

    expect(result).to be_unavailable
    expect(result.failure_reference.value).to eq(organization_failure_reference.value)
    expect(result.failure_reference).to be_a(Identity::Application::Contracts::SafeFailureReference)
  end

  it "maps a completed Organization result outside its contract to inconsistent" do
    result = described_adapter(Object.new).call(identity_branch_reference)

    expect(result).to be_inconsistent
    expect(result.evidence).to be_nil
  end

  it "rejects completed ancestry for a different Branch without partial evidence" do
    wrong_branch = Organization::Application::Contracts::BranchReference.new(
      "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
    )
    ancestry = Organization::Application::Contracts::BranchAncestry.new(
      branch_id: wrong_branch,
      brand_id: brand_reference,
      organization_id: organization_reference
    )
    organization_result = Organization::Application::Contracts::ResolveBranchAncestryResult.resolved(ancestry)

    result = described_adapter(organization_result).call(identity_branch_reference)

    expect(result).to be_inconsistent
    expect(result.evidence).to be_nil
  end

  it "contains the Organization sanitized signal behind an Identity-owned sanitized signal" do
    organization_error = Organization::Application::Errors::UnexpectedFailure.new

    expect do
      organization_query = instance_double(Organization::Application::Queries::ResolveBranchAncestry)
      allow(organization_query).to receive(:call).and_raise(organization_error)
      described_class.new(organization_query: organization_query).call(identity_branch_reference)
    end.to raise_error(Identity::Application::Errors::UnexpectedFailure) { |error|
      expect(error.message).to eq("Identity organization scope resolution terminated unexpectedly")
      expect(error.cause).to be_nil
      expect(error.backtrace).to eq([])
      expect(error.backtrace_locations).to be_nil
      expect(error.inspect).not_to include(organization_error.class.name)
    }
  end

  def described_adapter(organization_result)
    organization_query = instance_double(
      Organization::Application::Queries::ResolveBranchAncestry,
      call: organization_result
    )
    described_class.new(organization_query: organization_query)
  end
end
