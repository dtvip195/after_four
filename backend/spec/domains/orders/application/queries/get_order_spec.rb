require "rails_helper"

RSpec.describe Orders::Application::Queries::GetOrder do
  let(:contracts) { Orders::Application::Contracts }
  let(:port) { Orders::Application::Ports::OrderReadModel }
  let(:branch_id) { "11111111-1111-4111-8111-111111111111" }
  let(:order_id) { "22222222-2222-4222-8222-222222222222" }
  let(:branch) { contracts::BranchReference.new(branch_id) }
  let(:order) { contracts::OrderReference.new(order_id) }

  it "returns an exact Branch-scoped Order view" do
    fact = port::Fact.new(
      id: order_id, branch_id: branch_id, order_number: "AF-ORDER", channel: "takeaway",
      status: "draft", total_amount: 80_000, currency_code: "VND", lock_version: 0,
      created_at: Time.current, updated_at: Time.current
    )
    reader = instance_double(port)
    allow(reader).to receive(:find).and_return(port::FindResult.found(fact))

    result = described_class.new(reader: reader).call(branch_reference: branch, order_reference: order)

    expect(result).to be_found
    expect(result.order).to have_attributes(id: order_id, branch_id: branch_id, status: "draft")
  end

  it "preserves not-found non-disclosure and rejects cross-type values" do
    reader = instance_double(port)
    allow(reader).to receive(:find).and_return(port::FindResult.not_found)
    query = described_class.new(reader: reader)

    expect(query.call(branch_reference: branch, order_reference: order)).to be_not_found
    expect(query.call(branch_reference: order, order_reference: branch)).to be_invalid
  end

  it "fails closed when completed evidence names another Order or Branch" do
    fact = port::Fact.new(
      id: "33333333-3333-4333-8333-333333333333", branch_id: branch_id,
      order_number: "AF-OTHER", channel: "takeaway", status: "draft", total_amount: 80_000,
      currency_code: "VND", lock_version: 0, created_at: Time.current, updated_at: Time.current
    )
    reader = instance_double(port)
    allow(reader).to receive(:find).and_return(port::FindResult.found(fact))

    expect(
      described_class.new(reader: reader).call(branch_reference: branch, order_reference: order)
    ).to be_inconsistent
  end
end
