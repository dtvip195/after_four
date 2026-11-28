require "rails_helper"

RSpec.describe Payments::Application::Queries::GetPaymentStatus do
  let(:contracts) { Payments::Application::Contracts }
  let(:scope_port) { Payments::Application::Ports::OrderScopeResolver }
  let(:reader_port) { Payments::Application::Ports::PaymentStatusReader }
  let(:branch_id) { "11111111-1111-4111-8111-111111111111" }
  let(:order_id) { "22222222-2222-4222-8222-222222222222" }
  let(:branch) { contracts::BranchReference.new(branch_id) }
  let(:order) { contracts::OrderReference.new(order_id) }
  let(:money) { Payments::Domain::ValueObjects::Money.new(amount: 80_000, currency_code: "VND") }

  it "resolves authoritative Order scope before reading Payment status" do
    sequence = []
    resolver = instance_double(scope_port)
    reader = instance_double(reader_port)
    allow(resolver).to receive(:resolve) { sequence << :scope; scope_port::Result.found }
    fact = reader_port::Fact.new(
      id: "33333333-3333-4333-8333-333333333333", order_id: order_id,
      snapshot: Payments::Domain::ValueObjects::PaymentStatusSnapshot.new(
        funding_status: "unpaid", attempt_activity: "idle", target: money,
        successful_amount: 0, refunded_amount: 0, lock_version: 0
      ),
      fully_settled_at: nil, updated_at: Time.current
    )
    allow(reader).to receive(:find) { sequence << :payment; reader_port::Result.found(fact) }

    result = described_class.new(order_scope_resolver: resolver, reader: reader)
      .call(branch_reference: branch, order_reference: order)

    expect(result).to be_found
    expect(result.payment).to have_attributes(order_id: order_id, funding_status: "unpaid")
    expect(sequence).to eq(%i[scope payment])
  end

  it "does not read Payment data when the Order is outside the Branch" do
    resolver = instance_double(scope_port)
    reader = instance_double(reader_port)
    allow(resolver).to receive(:resolve).and_return(scope_port::Result.not_found)
    allow(reader).to receive(:find)

    result = described_class.new(order_scope_resolver: resolver, reader: reader)
      .call(branch_reference: branch, order_reference: order)

    expect(result).to be_not_found
    expect(reader).not_to have_received(:find)
  end

  it "fails closed on contradictory financial evidence" do
    resolver = instance_double(scope_port, resolve: scope_port::Result.found)
    fact = reader_port::Fact.new(
      id: "33333333-3333-4333-8333-333333333333", order_id: order_id,
      snapshot: Payments::Domain::ValueObjects::PaymentStatusSnapshot.new(
        funding_status: "fully_paid", attempt_activity: "idle", target: money,
        successful_amount: 80_000, refunded_amount: 0, lock_version: 0
      ),
      fully_settled_at: nil, updated_at: Time.current
    )
    reader = instance_double(reader_port, find: reader_port::Result.found(fact))

    expect(
      described_class.new(order_scope_resolver: resolver, reader: reader)
        .call(branch_reference: branch, order_reference: order)
    ).to be_inconsistent
  end

  it "rejects cross-type authority inputs" do
    resolver = instance_double(scope_port)
    reader = instance_double(reader_port)

    expect(
      described_class.new(order_scope_resolver: resolver, reader: reader)
        .call(branch_reference: order, order_reference: branch)
    ).to be_invalid
  end
end
