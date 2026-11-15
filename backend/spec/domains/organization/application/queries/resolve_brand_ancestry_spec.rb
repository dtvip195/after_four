require "rails_helper"

RSpec.describe "Organization Application ancestry resolution" do
  shared_examples "a canonical immutable UUID reference" do |reference_class|
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

  describe "typed references" do
    {
      "BrandReference" => Organization::Application::Contracts::BrandReference,
      "OrganizationReference" => Organization::Application::Contracts::OrganizationReference,
      "SafeFailureReference" => Organization::Application::Contracts::SafeFailureReference
    }.each do |name, reference_class|
      describe name do
        include_examples "a canonical immutable UUID reference", reference_class
      end
    end
  end

  describe "the published query" do
    let(:brand_reference) { described_reference("11111111-1111-1111-1111-111111111111") }
    let(:organization_reference) do
      Organization::Application::Contracts::OrganizationReference.new(
        "22222222-2222-2222-2222-222222222222"
      )
    end

    it "resolves a complete persisted ancestry fact" do
      fact = Organization::Application::Ports::BrandAncestryReader::PersistedBrandAncestryFact.new(
        brand_id: brand_reference,
        organization_id: organization_reference
      )
      reader = instance_spy(
        Organization::Application::Ports::BrandAncestryReader,
        read: Organization::Application::Ports::BrandAncestryReader::Result.found(fact)
      )

      result = described_query(reader).call(brand_reference)

      expect(result).to be_resolved
      expect(result.ancestry.brand_id).to eq(brand_reference)
      expect(result.ancestry.organization_id).to eq(organization_reference)
      expect(reader).to have_received(:read).with(brand_reference)
    end

    it "rejects an invalid internal argument without invoking persistence" do
      reader = instance_spy(Organization::Application::Ports::BrandAncestryReader)

      result = described_query(reader).call(brand_reference.value)

      expect(result).to be_invalid
      expect(reader).not_to have_received(:read)
    end

    it "maps missing and inconsistent persisted results without partial ancestry" do
      missing = described_query(
        reader_returning(Organization::Application::Ports::BrandAncestryReader::Result.not_found)
      ).call(brand_reference)
      inconsistent = described_query(
        reader_returning(Organization::Application::Ports::BrandAncestryReader::Result.inconsistent)
      ).call(brand_reference)

      expect(missing).to be_not_found
      expect(missing.ancestry).to be_nil
      expect(inconsistent).to be_inconsistent
      expect(inconsistent.ancestry).to be_nil
    end

    it "preserves the originating SafeFailureReference" do
      failure_reference = Organization::Application::Contracts::SafeFailureReference.new(
        "33333333-3333-3333-3333-333333333333"
      )
      reader_result = Organization::Application::Ports::BrandAncestryReader::Result.unavailable(failure_reference)

      result = described_query(reader_returning(reader_result)).call(brand_reference)

      expect(result).to be_unavailable
      expect(result.failure_reference).to equal(failure_reference)
      expect(result.ancestry).to be_nil
    end

    it "classifies a completed value outside the persistence contract as inconsistent" do
      result = described_query(reader_returning(Object.new)).call(brand_reference)

      expect(result).to be_inconsistent
      expect(result.ancestry).to be_nil
    end

    it "terminates with a sanitized Organization-owned signal for an unexpected defect" do
      source_message = "SELECT secret FROM protected password=do-not-leak"
      reader = instance_double(Organization::Application::Ports::BrandAncestryReader)
      allow(reader).to receive(:read).and_raise(NoMethodError, source_message)

      expect do
        described_query(reader).call(brand_reference)
      end.to raise_error(Organization::Application::Errors::UnexpectedFailure) { |error|
        expect(error.message).to eq("Organization scope resolution terminated unexpectedly")
        expect(error.cause).to be_nil
        expect(error.backtrace).to eq([])
        expect(error.backtrace_locations).to be_nil
        expect(error.inspect).not_to include(source_message)
        expect(error.full_message).not_to include(source_message)
      }
    end
  end

  def described_reference(value)
    Organization::Application::Contracts::BrandReference.new(value)
  end

  def described_query(reader)
    Organization::Application::Queries::ResolveBrandAncestry.new(reader: reader)
  end

  def reader_returning(result)
    instance_double(Organization::Application::Ports::BrandAncestryReader, read: result)
  end
end
