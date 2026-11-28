require "rails_helper"

RSpec.describe Catalog::Application::Queries::ResolveEffectiveVariantPrice do
  let(:contracts) { Catalog::Application::Contracts }
  let(:port) { Catalog::Application::Ports::EffectiveVariantPriceReader }
  let(:branch_id) { "11111111-1111-1111-1111-111111111111" }
  let(:variant_id) { "22222222-2222-2222-2222-222222222222" }
  let(:price_version_id) { "33333333-3333-3333-3333-333333333333" }
  let(:at) { Time.utc(2026, 11, 28, 10, 0, 0) }
  let(:branch) { contracts::BranchReference.new(branch_id) }
  let(:variant) { contracts::VariantReference.new(variant_id) }

  it "maps one authoritative effective price-version fact" do
    fact = port::Fact.new(
      variant_id: variant_id,
      branch_id: branch_id,
      price_version_id: price_version_id,
      amount: 80_000,
      currency_code: "VND",
      effective_from: at - 60,
      resolved_at: at
    )
    reader = instance_double(port, resolve: port::Result.found(fact))

    result = described_class.new(reader: reader).call(
      branch_reference: branch, variant_reference: variant, at: at
    )

    expect(result).to be_found
    expect(result.price).to have_attributes(
      variant_id: variant_id, branch_id: branch_id, price_version_id: price_version_id,
      amount: 80_000, currency_code: "VND"
    )
    expect(result.price).to be_frozen
  end

  it "represents missing approved price data without fabricating a value" do
    reader = instance_double(port, resolve: port::Result.price_unavailable)

    result = described_class.new(reader: reader).call(
      branch_reference: branch, variant_reference: variant, at: at
    )

    expect(result).to be_price_unavailable
    expect(result.price).to be_nil
  end

  it "rejects cross-type references and ambiguous time values" do
    reader = instance_double(port)
    query = described_class.new(reader: reader)

    expect(query.call(branch_reference: variant, variant_reference: branch, at: at)).to be_invalid
    expect(query.call(branch_reference: branch, variant_reference: variant, at: at.to_s)).to be_invalid
  end

  it "separates unresolved zero-price policy from malformed or stale evidence" do
    zero_price = port::Fact.new(
      variant_id: variant_id, branch_id: branch_id, price_version_id: price_version_id,
      amount: 0, currency_code: "VND", effective_from: at - 60, resolved_at: at
    )
    zero_result = described_class.new(
      reader: instance_double(port, resolve: port::Result.found(zero_price))
    ).call(branch_reference: branch, variant_reference: variant, at: at)

    expect(zero_result).to be_commercial_policy_unresolved
    expect(zero_result.price).to be_nil

    invalid_facts = [
      port::Fact.new(
        variant_id: variant_id, branch_id: "44444444-4444-4444-4444-444444444444",
        price_version_id: price_version_id, amount: 80_000, currency_code: "VND",
        effective_from: at - 60, resolved_at: at
      ),
      port::Fact.new(
        variant_id: variant_id, branch_id: branch_id, price_version_id: price_version_id,
        amount: -1, currency_code: "VND", effective_from: at - 60, resolved_at: at
      ),
      port::Fact.new(
        variant_id: variant_id, branch_id: branch_id, price_version_id: price_version_id,
        amount: 80_000, currency_code: "VND", effective_from: at - 60, resolved_at: at - 1
      )
    ]

    invalid_facts.each do |fact|
      reader = instance_double(port, resolve: port::Result.found(fact))
      result = described_class.new(reader: reader).call(
        branch_reference: branch, variant_reference: variant, at: at
      )
      expect(result).to be_inconsistent
    end
  end
end
