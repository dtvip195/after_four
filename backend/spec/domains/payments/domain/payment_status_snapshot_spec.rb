require "rails_helper"

RSpec.describe Payments::Domain::ValueObjects::PaymentStatusSnapshot do
  let(:money) { Payments::Domain::ValueObjects::Money.new(amount: 80_000, currency_code: "VND") }

  it "accepts the same canonical state invariants as the Payment Aggregate" do
    snapshot = described_class.new(
      funding_status: "unpaid",
      attempt_activity: "idle",
      target: money,
      successful_amount: 0,
      refunded_amount: 0,
      lock_version: 0
    )

    expect(snapshot).to have_attributes(
      funding_status: "unpaid",
      attempt_activity: "idle",
      target_amount: 80_000,
      currency_code: "VND",
      successful_amount: 0,
      refunded_amount: 0,
      lock_version: 0
    )
    expect(snapshot).to be_frozen
  end

  it "rejects exactly the Aggregate's existing invalid state combinations" do
    base = {
      funding_status: "unpaid", attempt_activity: "idle", target: money,
      successful_amount: 0, refunded_amount: 0, lock_version: 0
    }

    expect { described_class.new(**base.merge(funding_status: "unknown")) }
      .to raise_error(ArgumentError, "Payment funding status is invalid")
    expect { described_class.new(**base.merge(attempt_activity: "unknown")) }
      .to raise_error(ArgumentError, "Payment attempt activity is invalid")
    expect { described_class.new(**base.merge(successful_amount: -1)) }
      .to raise_error(ArgumentError, "Payment amounts are invalid")
    expect { described_class.new(**base.merge(successful_amount: 80_001)) }
      .to raise_error(ArgumentError, "Payment amounts exceed their allowed bounds")
    expect { described_class.new(**base.merge(lock_version: -1)) }
      .to raise_error(ArgumentError, "Payment lock version must be nonnegative")
    expect { described_class.new(**base.merge(funding_status: "fully_paid", successful_amount: 79_999)) }
      .to raise_error(ArgumentError, "Fully paid Payment must equal its target")
    expect { described_class.new(**base.merge(successful_amount: 1)) }
      .to raise_error(ArgumentError, "Unpaid Payment cannot contain successful funding")
  end

  it "preserves the Aggregate's exact invariant failures after extraction" do
    invalid_states = [
      { funding_status: "unknown" },
      { attempt_activity: "unknown" },
      { successful_amount: -1 },
      { successful_amount: 80_001 },
      { lock_version: -1 },
      { funding_status: "fully_paid", successful_amount: 79_999 },
      { successful_amount: 1 }
    ]

    invalid_states.each do |override|
      snapshot_error = captured_error { described_class.new(**snapshot_attributes.merge(override)) }
      aggregate_error = captured_error { build_payment(**override) }

      expect(aggregate_error.class).to eq(snapshot_error.class)
      expect(aggregate_error.message).to eq(snapshot_error.message)
    end
  end

  it "preserves the Aggregate's existing validation precedence for multiply invalid input" do
    expect { build_payment(funding_status: "unknown", created_at: nil) }
      .to raise_error(ArgumentError, "Payment funding status is invalid")
    expect { build_payment(successful_amount: -1, created_at: nil) }
      .to raise_error(ArgumentError, "Payment creation timestamp is required")
  end

  def snapshot_attributes
    {
      funding_status: "unpaid", attempt_activity: "idle", target: money,
      successful_amount: 0, refunded_amount: 0, lock_version: 0
    }
  end

  def build_payment(created_at: Time.utc(2026, 11, 28), **override)
    Payments::Domain::Aggregates::Payment.new(
      **{
        id: SecureRandom.uuid,
        order_id: SecureRandom.uuid,
        attempts: [],
        created_at: created_at,
        updated_at: Time.utc(2026, 11, 28)
      }.merge(snapshot_attributes).merge(override)
    )
  end

  def captured_error
    yield
  rescue ArgumentError => error
    error
  end
end
