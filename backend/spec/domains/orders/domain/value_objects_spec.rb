require "spec_helper"
require_relative "../../../../app/domains/orders/domain/value_objects/order_id"
require_relative "../../../../app/domains/orders/domain/value_objects/order_number"
require_relative "../../../../app/domains/orders/domain/value_objects/money"
require_relative "../../../../app/domains/orders/domain/value_objects/service_channel"
require_relative "../../../../app/domains/orders/domain/value_objects/payment_window"

RSpec.describe "Ordering value objects" do
  it "compares Order IDs by canonical UUID value" do
    value = "0d13889c-916c-43e7-8f25-f21e19b6ef71"

    expect(Orders::Domain::ValueObjects::OrderId.new(value))
      .to eq(Orders::Domain::ValueObjects::OrderId.new(value))
    expect { Orders::Domain::ValueObjects::OrderId.new("not-an-id") }.to raise_error(ArgumentError)
  end

  it "owns the existing Order-number format without generating randomness" do
    number = Orders::Domain::ValueObjects::OrderNumber.generate(token: "a1b2c3d4e5f6")

    expect(number.to_s).to eq("AF-A1B2C3D4E5F6")
    expect(Orders::Domain::ValueObjects::OrderNumber.new("AF-LEGACY").to_s).to eq("AF-LEGACY")
    expect { Orders::Domain::ValueObjects::OrderNumber.new(" ") }
      .to raise_error(ArgumentError, "Order number is required")
    expect { Orders::Domain::ValueObjects::OrderNumber.generate(token: "not-hex") }
      .to raise_error(ArgumentError, "Order number token must contain exactly 12 hexadecimal characters")
  end

  it "compares Money only within the same currency" do
    low = Orders::Domain::ValueObjects::Money.new(amount: 23_000, currency_code: "vnd")
    high = Orders::Domain::ValueObjects::Money.new(amount: 43_000, currency_code: "VND")

    expect(low).to be < high
    expect(low.currency_code).to eq("VND")
    expect do
      low < Orders::Domain::ValueObjects::Money.new(amount: 23_000, currency_code: "USD")
    end.to raise_error(ArgumentError, "Money currencies must match")
  end

  it "accepts only existing service channels" do
    expect(Orders::Domain::ValueObjects::ServiceChannel.new("takeaway").to_s).to eq("takeaway")
    expect { Orders::Domain::ValueObjects::ServiceChannel.new("delivery") }.to raise_error(ArgumentError)
  end

  it "derives a deadline from a positive Payment Window" do
    opened_at = Time.utc(2026, 11, 14, 10, 0, 0)
    window = Orders::Domain::ValueObjects::PaymentWindow.new(300)

    expect(window.deadline_from(opened_at)).to eq(opened_at + 300)
    expect { Orders::Domain::ValueObjects::PaymentWindow.new(0) }.to raise_error(ArgumentError)
  end
end
