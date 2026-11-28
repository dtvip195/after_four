require "rails_helper"

RSpec.describe Preparation::Application::Queries::GetPreparationStatus do
  let(:contracts) { Preparation::Application::Contracts }
  let(:port) { Preparation::Application::Ports::PreparationStatusReader }
  let(:branch_id) { "11111111-1111-4111-8111-111111111111" }
  let(:order_id) { "22222222-2222-4222-8222-222222222222" }
  let(:branch) { contracts::BranchReference.new(branch_id) }
  let(:order) { contracts::OrderReference.new(order_id) }
  let(:now) { Time.current }

  it "returns immutable exact Branch and Order preparation evidence" do
    fact = port::Fact.new(
      id: "33333333-3333-4333-8333-333333333333",
      order_id: order_id,
      payment_id: "44444444-4444-4444-8444-444444444444",
      branch_id: branch_id,
      status: "pending",
      requested_at: now,
      dispatched_at: nil,
      lock_version: 0,
      updated_at: now
    )
    reader = reader_returning(port::Result.found(fact))

    result = described_class.new(reader: reader).call(branch_reference: branch, order_reference: order)

    expect(result).to be_found
    expect(result.preparation).to have_attributes(order_id: order_id, branch_id: branch_id, status: "pending")
    expect(result.preparation).to be_frozen
  end

  it "preserves not-found non-disclosure and rejects cross-type values" do
    query = described_class.new(reader: reader_returning(port::Result.not_found))

    expect(query.call(branch_reference: branch, order_reference: order)).to be_not_found
    expect(query.call(branch_reference: order, order_reference: branch)).to be_invalid
  end

  it "fails closed on contradictory or cross-scope completed evidence" do
    contradictory = port::Fact.new(
      id: "33333333-3333-4333-8333-333333333333",
      order_id: order_id,
      payment_id: "44444444-4444-4444-8444-444444444444",
      branch_id: branch_id,
      status: "pending",
      requested_at: now,
      dispatched_at: now,
      lock_version: 0,
      updated_at: now
    )

    result = described_class.new(reader: reader_returning(port::Result.found(contradictory)))
      .call(branch_reference: branch, order_reference: order)

    expect(result).to be_inconsistent
  end

  it "sanitizes unexpected defects" do
    expect do
      described_class.new(reader: reader_raising(StandardError.new("secret SQL")))
        .call(branch_reference: branch, order_reference: order)
    end.to raise_error(Preparation::Application::Errors::UnexpectedFailure, "Preparation status read failed")
  end

  def reader_returning(result)
    instance_double(port).tap { |reader| allow(reader).to receive(:find).and_return(result) }
  end

  def reader_raising(error)
    instance_double(port).tap { |reader| allow(reader).to receive(:find).and_raise(error) }
  end
end
