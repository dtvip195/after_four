require "rails_helper"

RSpec.describe Payments::Infrastructure::Persistence::ActiveRecordPaymentStatusReader do
  let(:contracts) { Payments::Application::Contracts }

  it "reads one Payment by exact Order without leaking Active Record" do
    order = create_order
    payment = Payments::Infrastructure::Persistence::PaymentRecord.create!(
      order_id: order.id,
      funding_status: "unpaid",
      attempt_activity: "idle",
      target_amount: 80_000,
      successful_amount: 0,
      refunded_amount: 0,
      currency_code: "VND"
    )

    result = described_class.new.find(order_reference: contracts::OrderReference.new(order.id))

    expect(result).to be_found
    expect(result.fact.id).to eq(payment.id)
    expect(result.fact.snapshot).to have_attributes(
      funding_status: "unpaid",
      target_amount: 80_000,
      successful_amount: 0,
      currency_code: "VND"
    )
    expect(result.fact).not_to be_a(ActiveRecord::Base)
  end

  it "returns not_found for an absent Order" do
    result = described_class.new.find(
      order_reference: contracts::OrderReference.new("22222222-2222-4222-8222-222222222222")
    )
    expect(result).to be_not_found
  end

  it "preserves typed input enforcement at the port boundary" do
    expect { described_class.new.find(order_reference: "order") }
      .to raise_error(ArgumentError, "order_reference must be typed")
  end

  it "maps persisted state that violates Payment invariants to inconsistent" do
    relation = instance_double(ActiveRecord::Relation)
    record_class = class_double(Payments::Infrastructure::Persistence::PaymentRecord)
    allow(record_class).to receive(:where).and_return(relation)
    allow(relation).to receive(:pick).and_return(
      [
        SecureRandom.uuid, SecureRandom.uuid, "fully_paid", "idle", 80_000,
        79_999, 0, "VND", Time.current, 0, Time.current
      ]
    )

    result = described_class.new(record_class: record_class).find(
      order_reference: contracts::OrderReference.new("22222222-2222-4222-8222-222222222222")
    )

    expect(result).to be_inconsistent
  end

  def create_order
    Orders::Infrastructure::Persistence::OrderRecord.create!(
      branch_id: SecureRandom.uuid,
      created_by_actor_id: SecureRandom.uuid,
      order_number: "AF-#{SecureRandom.hex(6).upcase}",
      channel: "takeaway",
      status: "draft",
      total_amount: 80_000,
      currency_code: "VND",
      creation_idempotency_key: SecureRandom.uuid,
      creation_request_fingerprint: Digest::SHA256.hexdigest(SecureRandom.uuid)
    )
  end
end
