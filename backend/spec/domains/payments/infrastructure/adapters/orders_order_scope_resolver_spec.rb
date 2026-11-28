require "rails_helper"

RSpec.describe Payments::Infrastructure::Adapters::OrdersOrderScopeResolver do
  let(:payments_contracts) { Payments::Application::Contracts }
  let(:orders_contracts) { Orders::Application::Contracts }
  let(:branch_id) { "11111111-1111-4111-8111-111111111111" }
  let(:order_id) { "22222222-2222-4222-8222-222222222222" }

  it "translates typed references through the Orders Application contract" do
    query = instance_double(Orders::Application::Queries::GetOrder)
    allow(query).to receive(:call).and_return(
      orders_contracts::GetOrderResult.found(
        orders_contracts::OrderView.new(
          id: order_id, branch_id: branch_id, order_number: "AF-ORDER", channel: "takeaway",
          status: "draft", total_amount: 80_000, currency_code: "VND", lock_version: 0,
          created_at: Time.current, updated_at: Time.current
        )
      )
    )

    result = described_class.new(order_query: query).resolve(
      branch_reference: payments_contracts::BranchReference.new(branch_id),
      order_reference: payments_contracts::OrderReference.new(order_id)
    )

    expect(result).to be_found
    expect(query).to have_received(:call).with(
      branch_reference: orders_contracts::BranchReference.new(branch_id),
      order_reference: orders_contracts::OrderReference.new(order_id)
    )
  end
end
