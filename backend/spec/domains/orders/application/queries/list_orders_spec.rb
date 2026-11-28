require "rails_helper"

RSpec.describe Orders::Application::Queries::ListOrders do
  let(:contracts) { Orders::Application::Contracts }
  let(:port) { Orders::Application::Ports::OrderReadModel }
  let(:branch_id) { "11111111-1111-4111-8111-111111111111" }
  let(:order_id) { "22222222-2222-4222-8222-222222222222" }
  let(:now) { Time.utc(2026, 11, 28, 10, 0, 0) }

  it "maps exact Branch facts into an immutable page" do
    fact = port::Fact.new(
      id: order_id,
      branch_id: branch_id,
      order_number: "AF-ORDER-1",
      channel: "takeaway",
      status: "confirmed",
      total_amount: 80_000,
      currency_code: "VND",
      lock_version: 3,
      created_at: now,
      updated_at: now
    )
    reader = reader_returning(port::ListResult.found(facts: [ fact ], total: 1))
    request = contracts::OrderPageRequest.new(page: 1, limit: 20, status: "confirmed")

    result = described_class.new(reader: reader).call(
      branch_reference: contracts::BranchReference.new(branch_id), page_request: request
    )

    expect(result).to be_found
    expect(result.page).to have_attributes(page: 1, limit: 20, total: 1, total_pages: 1)
    expect(result.page.orders.first).to have_attributes(
      id: order_id, branch_id: branch_id, status: "confirmed", total_amount: 80_000,
      currency_code: "VND", lock_version: 3
    )
    expect(result.page).to be_frozen
    expect(result.page.orders).to be_frozen
    expect(reader).to have_received(:list).with(
      branch_reference: contracts::BranchReference.new(branch_id),
      status: "confirmed",
      offset: 0,
      limit: 20
    )
  end

  it "rejects arbitrary Branch and page values without invoking persistence" do
    reader = instance_double(port)
    allow(reader).to receive(:list)
    query = described_class.new(reader: reader)
    page = contracts::OrderPageRequest.new(page: 1, limit: 20, status: nil)

    expect(query.call(branch_reference: branch_id, page_request: page)).to be_invalid
    expect(query.call(branch_reference: contracts::BranchReference.new(branch_id), page_request: {})).to be_invalid
    expect(reader).not_to have_received(:list)
  end

  it "fails closed for malformed, cross-Branch, or inconsistent completed evidence" do
    request = contracts::OrderPageRequest.new(page: 1, limit: 20, status: nil)
    branch = contracts::BranchReference.new(branch_id)
    malformed = port::Fact.new(
      id: order_id,
      branch_id: "33333333-3333-4333-8333-333333333333",
      order_number: "AF-ORDER-1",
      channel: "takeaway",
      status: "confirmed",
      total_amount: 80_000,
      currency_code: "VND",
      lock_version: 0,
      created_at: now,
      updated_at: now
    )

    result = described_class.new(
      reader: reader_returning(port::ListResult.found(facts: [ malformed ], total: 1))
    ).call(branch_reference: branch, page_request: request)

    expect(result).to be_inconsistent
    expect(
      described_class.new(reader: reader_returning(Object.new))
        .call(branch_reference: branch, page_request: request)
    ).to be_inconsistent
  end

  it "preserves safe unavailability references and sanitizes unexpected defects" do
    request = contracts::OrderPageRequest.new(page: 1, limit: 20, status: nil)
    branch = contracts::BranchReference.new(branch_id)
    reference = contracts::SafeFailureReference.new("44444444-4444-4444-8444-444444444444")
    unavailable = described_class.new(
      reader: reader_returning(port::ListResult.unavailable(reference))
    ).call(branch_reference: branch, page_request: request)

    expect(unavailable).to be_unavailable
    expect(unavailable.failure_reference).to equal(reference)
    expect do
      described_class.new(reader: reader_raising(StandardError.new("secret SQL")))
        .call(branch_reference: branch, page_request: request)
    end.to raise_error(Orders::Application::Errors::UnexpectedFailure, "Order read failed")
  end

  def reader_returning(result)
    instance_double(port).tap { |reader| allow(reader).to receive(:list).and_return(result) }
  end

  def reader_raising(error)
    instance_double(port).tap { |reader| allow(reader).to receive(:list).and_raise(error) }
  end
end
