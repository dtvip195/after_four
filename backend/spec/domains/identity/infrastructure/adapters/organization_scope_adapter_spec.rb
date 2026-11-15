require "rails_helper"

RSpec.describe Identity::Infrastructure::Adapters::OrganizationScopeAdapter do
  shared_examples "an Identity canonical immutable UUID reference" do |reference_class|
    it "constructs an immutable value with coherent equality and hashing" do
      canonical_value = "aaaaaaaa-aaaa-0000-0000-aaaaaaaaaaaa"
      mutable_source = canonical_value.dup

      reference = reference_class.new(mutable_source)
      equivalent = reference_class.new(canonical_value)
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

      expect { reference_class.new(canonical_value) }.not_to raise_error
      invalid_values.each do |value|
        expect do
          reference_class.new(value)
        end.to raise_error(ArgumentError, "value must be a canonical UUID")
      end
    end
  end

  describe "Identity reference values" do
    {
      "IdentityBrandReference" => Identity::Application::Contracts::IdentityBrandReference,
      "IdentityOrganizationReference" => Identity::Application::Contracts::IdentityOrganizationReference,
      "SafeFailureReference" => Identity::Application::Contracts::SafeFailureReference
    }.each do |name, reference_class|
      describe name do
        include_examples "an Identity canonical immutable UUID reference", reference_class
      end
    end
  end

  let(:identity_brand_reference) do
    Identity::Application::Contracts::IdentityBrandReference.new(
      "11111111-1111-1111-1111-111111111111"
    )
  end
  let(:organization_brand_reference) do
    Organization::Application::Contracts::BrandReference.new(identity_brand_reference.value)
  end
  let(:organization_reference) do
    Organization::Application::Contracts::OrganizationReference.new(
      "22222222-2222-2222-2222-222222222222"
    )
  end

  it "maps a complete Organization result into immutable Identity-owned evidence" do
    ancestry = Organization::Application::Contracts::BrandAncestry.new(
      brand_id: organization_brand_reference,
      organization_id: organization_reference
    )
    organization_result = Organization::Application::Contracts::ResolveBrandAncestryResult.resolved(ancestry)

    result = described_adapter(organization_result).call(identity_brand_reference)

    expect(result).to be_resolved
    expect(result.evidence.brand_id.value).to eq(identity_brand_reference.value)
    expect(result.evidence.organization_id.value).to eq(organization_reference.value)
    expect(result.evidence).to be_frozen
    expect(result.evidence.brand_id).to be_a(Identity::Application::Contracts::IdentityBrandReference)
    expect(result.evidence.organization_id).to be_a(
      Identity::Application::Contracts::IdentityOrganizationReference
    )
  end

  it "maps all non-success normal Organization outcomes" do
    result_class = Organization::Application::Contracts::ResolveBrandAncestryResult

    expect(described_adapter(result_class.not_found).call(identity_brand_reference)).to be_not_found
    expect(described_adapter(result_class.invalid).call(identity_brand_reference)).to be_invalid
    expect(described_adapter(result_class.inconsistent).call(identity_brand_reference)).to be_inconsistent
  end

  it "returns invalid without calling Organization for a wrong internal input type" do
    organization_query = instance_spy(Organization::Application::Queries::ResolveBrandAncestry)

    result = described_class.new(organization_query: organization_query).call(identity_brand_reference.value)

    expect(result).to be_invalid
    expect(organization_query).not_to have_received(:call)
  end

  it "preserves the exact originating availability reference value" do
    organization_failure_reference = Organization::Application::Contracts::SafeFailureReference.new(
      "33333333-3333-3333-3333-333333333333"
    )
    organization_result = Organization::Application::Contracts::ResolveBrandAncestryResult.unavailable(
      organization_failure_reference
    )

    result = described_adapter(organization_result).call(identity_brand_reference)

    expect(result).to be_unavailable
    expect(result.failure_reference.value).to eq(organization_failure_reference.value)
    expect(result.failure_reference).to be_a(Identity::Application::Contracts::SafeFailureReference)
  end

  it "maps a completed Organization result outside its contract to inconsistent" do
    result = described_adapter(Object.new).call(identity_brand_reference)

    expect(result).to be_inconsistent
    expect(result.evidence).to be_nil
  end

  it "rejects completed ancestry for a different Brand without partial evidence" do
    wrong_brand = Organization::Application::Contracts::BrandReference.new(
      "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
    )
    ancestry = Organization::Application::Contracts::BrandAncestry.new(
      brand_id: wrong_brand,
      organization_id: organization_reference
    )
    organization_result = Organization::Application::Contracts::ResolveBrandAncestryResult.resolved(ancestry)

    result = described_adapter(organization_result).call(identity_brand_reference)

    expect(result).to be_inconsistent
    expect(result.evidence).to be_nil
  end

  it "contains the Organization sanitized signal behind an Identity-owned sanitized signal" do
    organization_error = Organization::Application::Errors::UnexpectedFailure.new

    expect do
      organization_query = instance_double(Organization::Application::Queries::ResolveBrandAncestry)
      allow(organization_query).to receive(:call).and_raise(organization_error)
      described_class.new(
        organization_query: organization_query
      ).call(identity_brand_reference)
    end.to raise_error(Identity::Application::Errors::UnexpectedFailure) { |error|
      expect(error.message).to eq("Identity organization scope resolution terminated unexpectedly")
      expect(error.cause).to be_nil
      expect(error.backtrace).to eq([])
      expect(error.backtrace_locations).to be_nil
      expect(error.inspect).not_to include(organization_error.class.name)
    }
  end

  it "sanitizes an unexpected Identity mapping defect instead of returning a normal result" do
    source_message = "protected identity data password=do-not-leak"
    exploding_result_class = Class.new(
      Organization::Application::Contracts::ResolveBrandAncestryResult
    ) do
      define_method(:resolved?) { raise NoMethodError, source_message }
    end
    exploding_result = exploding_result_class.send(:new, status: :resolved)

    expect do
      described_adapter(exploding_result).call(identity_brand_reference)
    end.to raise_error(Identity::Application::Errors::UnexpectedFailure) { |error|
      expect(error.message).to eq("Identity organization scope resolution terminated unexpectedly")
      expect(error.cause).to be_nil
      expect(error.backtrace).to eq([])
      expect(error.backtrace_locations).to be_nil
      expect(error.full_message).not_to include(source_message)
    }
  end

  def described_adapter(organization_result)
    organization_query = instance_double(
      Organization::Application::Queries::ResolveBrandAncestry,
      call: organization_result
    )
    described_class.new(organization_query: organization_query)
  end
end
