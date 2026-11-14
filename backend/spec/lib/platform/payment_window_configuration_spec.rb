require "spec_helper"
require_relative "../../../lib/platform/payment_window_configuration"

RSpec.describe Platform::PaymentWindowConfiguration do
  describe ".load" do
    it "uses 300 seconds when ORDER_PAYMENT_WINDOW_SECONDS is absent" do
      expect(described_class.load(environment: {})).to eq(300)
    end

    it "parses a configured positive integer" do
      environment = { "ORDER_PAYMENT_WINDOW_SECONDS" => "900" }

      expect(described_class.load(environment:)).to eq(900)
    end

    it "rejects zero without falling back to the default" do
      environment = { "ORDER_PAYMENT_WINDOW_SECONDS" => "0" }

      expect { described_class.load(environment:) }
        .to raise_error(
          Platform::PaymentWindowConfiguration::InvalidValue,
          "ORDER_PAYMENT_WINDOW_SECONDS must be a positive integer whose deadline fits PostgreSQL timestamptz"
        )
    end

    it "rejects negative, blank, non-numeric, and decimal values", :aggregate_failures do
      [ "-1", "", "   ", "five-minutes", "300.5" ].each do |raw_value|
        environment = { "ORDER_PAYMENT_WINDOW_SECONDS" => raw_value }

        expect { described_class.load(environment:) }
          .to raise_error(
            Platform::PaymentWindowConfiguration::InvalidValue,
            "ORDER_PAYMENT_WINDOW_SECONDS must be a positive integer whose deadline fits PostgreSQL timestamptz"
          )
      end
    end

    it "rejects a value whose deadline exceeds PostgreSQL timestamptz" do
      environment = { "ORDER_PAYMENT_WINDOW_SECONDS" => (10**100).to_s }

      expect { described_class.load(environment:) }
        .to raise_error(
          Platform::PaymentWindowConfiguration::InvalidValue,
          "ORDER_PAYMENT_WINDOW_SECONDS must be a positive integer whose deadline fits PostgreSQL timestamptz"
        )
    end
  end
end
