require "rails_helper"

RSpec.describe "Organization Application branch ancestry resolution" do
  describe "BranchReference" do
    it "constructs an immutable canonical UUID value with coherent equality and hashing" do
      canonical_value = "aaaaaaaa-aaaa-0000-0000-aaaaaaaaaaaa"
      mutable_source = canonical_value.dup

      reference = Organization::Application::Contracts::BranchReference.new(mutable_source)
      equivalent = Organization::Application::Contracts::BranchReference.new(canonical_value)
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

      expect { Organization::Application::Contracts::BranchReference.new(canonical_value) }.not_to raise_error
      invalid_values.each do |value|
        expect do
          Organization::Application::Contracts::BranchReference.new(value)
        end.to raise_error(ArgumentError, "value must be a canonical UUID")
      end
    end

    it "cannot be subclassed to impersonate a Branch reference" do
      expect do
        Class.new(Organization::Application::Contracts::BranchReference)
      end.to raise_error(TypeError, "Organization::Application::Contracts::BranchReference cannot be subclassed")
    end
  end

  describe "the published query" do
    let(:branch_reference) { described_reference("11111111-1111-1111-1111-111111111111") }
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

    it "resolves a complete persisted ancestry fact" do
      fact = Organization::Application::Ports::BranchAncestryReader::PersistedBranchAncestryFact.new(
        branch_id: branch_reference,
        brand_id: brand_reference,
        organization_id: organization_reference
      )
      reader = instance_spy(
        Organization::Application::Ports::BranchAncestryReader,
        read: Organization::Application::Ports::BranchAncestryReader::Result.found(fact)
      )

      result = described_query(reader).call(branch_reference)

      expect(result).to be_resolved
      expect(result.ancestry.branch_id).to eq(branch_reference)
      expect(result.ancestry.brand_id).to eq(brand_reference)
      expect(result.ancestry.organization_id).to eq(organization_reference)
      expect(reader).to have_received(:read).with(branch_reference)
    end

    it "rejects an invalid internal argument without invoking persistence" do
      reader = instance_spy(Organization::Application::Ports::BranchAncestryReader)

      result = described_query(reader).call(branch_reference.value)

      expect(result).to be_invalid
      expect(reader).not_to have_received(:read)
    end

    it "maps missing and inconsistent persisted results without partial ancestry" do
      missing = described_query(
        reader_returning(Organization::Application::Ports::BranchAncestryReader::Result.not_found)
      ).call(branch_reference)
      inconsistent = described_query(
        reader_returning(Organization::Application::Ports::BranchAncestryReader::Result.inconsistent)
      ).call(branch_reference)

      expect(missing).to be_not_found
      expect(missing.ancestry).to be_nil
      expect(inconsistent).to be_inconsistent
      expect(inconsistent.ancestry).to be_nil
    end

    it "rejects incomplete, mistyped, and mismatched persisted facts" do
      facts = [
        Object.new,
        Organization::Application::Ports::BranchAncestryReader::PersistedBranchAncestryFact.new(
          branch_id: described_reference("44444444-4444-4444-4444-444444444444"),
          brand_id: brand_reference,
          organization_id: organization_reference
        ),
        Organization::Application::Ports::BranchAncestryReader::PersistedBranchAncestryFact.new(
          branch_id: branch_reference,
          brand_id: brand_reference.value,
          organization_id: organization_reference
        )
      ]

      facts.each do |fact|
        result = described_query(
          reader_returning(Organization::Application::Ports::BranchAncestryReader::Result.found(fact))
        ).call(branch_reference)

        expect(result).to be_inconsistent
        expect(result.ancestry).to be_nil
      end
    end

    it "preserves the originating SafeFailureReference" do
      failure_reference = Organization::Application::Contracts::SafeFailureReference.new(
        "55555555-5555-5555-5555-555555555555"
      )
      reader_result = Organization::Application::Ports::BranchAncestryReader::Result.unavailable(failure_reference)

      result = described_query(reader_returning(reader_result)).call(branch_reference)

      expect(result).to be_unavailable
      expect(result.failure_reference).to equal(failure_reference)
      expect(result.ancestry).to be_nil
    end

    it "classifies values outside the persistence contract as inconsistent" do
      result = described_query(reader_returning(Object.new)).call(branch_reference)

      expect(result).to be_inconsistent
      expect(result.ancestry).to be_nil
    end

    it "terminates with a sanitized Organization-owned signal for an unexpected defect" do
      source_message = "SELECT secret FROM protected password=do-not-leak"
      reader = instance_double(Organization::Application::Ports::BranchAncestryReader)
      allow(reader).to receive(:read).and_raise(NoMethodError, source_message)

      expect do
        described_query(reader).call(branch_reference)
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
    Organization::Application::Contracts::BranchReference.new(value)
  end

  def described_query(reader)
    Organization::Application::Queries::ResolveBranchAncestry.new(reader: reader)
  end

  def reader_returning(result)
    instance_double(Organization::Application::Ports::BranchAncestryReader, read: result)
  end
end
