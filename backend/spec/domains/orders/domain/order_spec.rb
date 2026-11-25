require "spec_helper"
require_relative "../../../../app/domains/orders/domain/errors/rule_violation"
require_relative "../../../../app/domains/orders/domain/value_objects/order_id"
require_relative "../../../../app/domains/orders/domain/value_objects/order_number"
require_relative "../../../../app/domains/orders/domain/value_objects/money"
require_relative "../../../../app/domains/orders/domain/value_objects/service_channel"
require_relative "../../../../app/domains/orders/domain/value_objects/payment_window"
require_relative "../../../../app/domains/orders/domain/aggregates/order"

RSpec.describe Orders::Domain::Aggregates::Order do
  subject(:order) { build_order }

  let(:now) { Time.utc(2026, 11, 14, 10, 0, 0) }
  let(:window) { Orders::Domain::ValueObjects::PaymentWindow.new(300) }

  it "confirms a Draft Order and derives its payment deadline" do
    outcome = order.confirm(
      idempotency_key: "confirm-1",
      expected_version: 0,
      now: now,
      payment_window: window
    )

    expect(outcome).to eq(:applied)
    expect(order).to have_attributes(
      status: "confirmed",
      confirmation_idempotency_key: "confirm-1",
      confirmed_at: now,
      payment_expires_at: now + 300
    )
  end

  it "replays confirmation before evaluating the supplied version" do
    order.confirm(idempotency_key: "confirm-1", expected_version: 0, now: now, payment_window: window)

    expect(
      order.confirm(
        idempotency_key: "confirm-1",
        expected_version: 999,
        now: now + 60,
        payment_window: window
      )
    ).to eq(:replayed)
    expect(order.confirmed_at).to eq(now)
  end

  it "rejects stale confirmation and invalid lifecycle transitions" do
    expect do
      order.confirm(idempotency_key: "confirm-1", expected_version: 1, now: now, payment_window: window)
    end.to raise_error(Orders::Domain::Errors::RuleViolation) { |error|
      expect(error).to have_attributes(code: "concurrent_modification", details: { current_version: 0 })
    }

    order.confirm(idempotency_key: "confirm-1", expected_version: 0, now: now, payment_window: window)
    expect do
      order.confirm(idempotency_key: "confirm-2", expected_version: 0, now: now, payment_window: window)
    end.to raise_error(Orders::Domain::Errors::RuleViolation) { |error|
      expect(error.code).to eq("invalid_state_transition")
    }
  end

  it "holds only a Confirmed unpaid Order and preserves the original conflicting replay" do
    order.confirm(idempotency_key: "confirm-1", expected_version: 0, now: now, payment_window: window)

    expect(
      order.hold(
        reason: "Original reason",
        idempotency_key: "hold-1",
        expected_version: 0,
        now: now + 60,
        payment_unpaid: true
      )
    ).to eq(:applied)
    expect(
      order.hold(
        reason: "Conflicting reason",
        idempotency_key: "hold-1",
        expected_version: 999,
        now: now + 120,
        payment_unpaid: true
      )
    ).to eq(:replayed)
    expect(order).to have_attributes(hold_reason: "Original reason", held_at: now + 60)
  end

  it "rejects hold when the settlement fact is not unpaid" do
    order.confirm(idempotency_key: "confirm-1", expected_version: 0, now: now, payment_window: window)

    expect do
      order.hold(
        reason: "Review",
        idempotency_key: "hold-1",
        expected_version: 0,
        now: now + 60,
        payment_unpaid: false
      )
    end.to raise_error(Orders::Domain::Errors::RuleViolation) { |error|
      expect(error.code).to eq("invalid_state_transition")
    }
  end

  it "rejects a blank hold reason as an Aggregate invariant" do
    order.confirm(idempotency_key: "confirm-1", expected_version: 0, now: now, payment_window: window)

    expect do
      order.hold(
        reason: " ",
        idempotency_key: "hold-1",
        expected_version: 0,
        now: now + 60,
        payment_unpaid: true
      )
    end.to raise_error(Orders::Domain::Errors::RuleViolation) { |error|
      expect(error.code).to eq("reason_required")
    }
  end

  it "expires at exact deadline only while Confirmed and unpaid" do
    order.confirm(idempotency_key: "confirm-1", expected_version: 0, now: now, payment_window: window)

    expect(order.expire(now: now + 299, payment_unpaid: true)).to eq(:ineligible)
    expect(order.expire(now: now + 300, payment_unpaid: true)).to eq(:applied)
    expect(order).to have_attributes(status: "expired", expired_at: now + 300)
  end

  describe "creation invariants" do
    it "constructs a valid Draft without Rails" do
      draft = described_class.draft(
        id: "0d13889c-916c-43e7-8f25-f21e19b6ef71",
        branch_id: "d4a98431-609d-4b50-92f5-c973aec268db",
        created_by_actor_id: "e75b9410-c367-490b-bb05-fd0bd86a54ba",
        order_number: Orders::Domain::ValueObjects::OrderNumber.generate(token: "a1b2c3d4e5f6"),
        channel: "takeaway",
        total: Orders::Domain::ValueObjects::Money.new(amount: 80_000, currency_code: "VND"),
        creation_idempotency_key: "create-1",
        creation_request_fingerprint: "a" * 64,
        created_at: now
      )

      expect(draft).to have_attributes(
        status: "draft",
        order_number: "AF-A1B2C3D4E5F6",
        lock_version: 0,
        created_at: now,
        updated_at: now
      )
    end

    it "rejects invalid owned and referenced identities during creation and reconstitution" do
      {
        id: "not-an-order-id",
        branch_id: "not-a-branch-id",
        created_by_actor_id: "not-an-actor-id",
        order_number: " ",
        creation_idempotency_key: " ",
        creation_request_fingerprint: "not-a-fingerprint",
        lock_version: -1,
        created_at: nil,
        updated_at: nil
      }.each do |field, invalid|
        expect { build_order(field => invalid) }.to raise_error(ArgumentError), field.to_s
      end
    end

    it "rejects invalid channel and Money through Domain value objects" do
      expect { build_order(channel: "delivery") }.to raise_error(ArgumentError, "Service Channel is invalid")
      expect do
        Orders::Domain::ValueObjects::Money.new(amount: 0, currency_code: "VND")
      end.to raise_error(ArgumentError, "Money amount must be positive")
      expect do
        Orders::Domain::ValueObjects::Money.new(amount: 80_000, currency_code: "VN")
      end.to raise_error(ArgumentError, "Money currency must be a three-letter code")
    end
  end

  describe "lifecycle reconstitution invariants" do
    it "rejects lifecycle evidence on a Draft" do
      expect { build_order(confirmed_at: now) }
        .to raise_error(ArgumentError, /Confirmation evidence contradicts draft status/)
      expect { build_order(held_at: now) }
        .to raise_error(ArgumentError, /Hold evidence contradicts draft status/)
      expect { build_order(expired_at: now) }
        .to raise_error(ArgumentError, /Expiration evidence contradicts draft status/)
    end

    it "requires complete confirmation evidence without later lifecycle evidence" do
      complete = confirmation_evidence

      complete.each_key do |field|
        expect { build_order(**complete.merge(status: "confirmed", field => nil)) }
          .to raise_error(ArgumentError, /Confirmation evidence is incomplete/)
      end
      expect { build_order(**complete.merge(status: "confirmed", held_at: now)) }
        .to raise_error(ArgumentError, /Hold evidence contradicts confirmed status/)
      expect { build_order(**complete.merge(status: "confirmed", expired_at: now)) }
        .to raise_error(ArgumentError, /Expiration evidence contradicts confirmed status/)
    end

    it "requires prior confirmation and complete hold evidence for Held" do
      complete = confirmation_evidence.merge(hold_evidence).merge(status: "held")

      (confirmation_evidence.keys + hold_evidence.keys).each do |field|
        expect { build_order(**complete.merge(field => nil)) }
          .to raise_error(ArgumentError, /evidence is incomplete/)
      end
      expect { build_order(**complete.merge(hold_reason: " ")) }
        .to raise_error(ArgumentError, /Hold evidence is incomplete/)
      expect { build_order(**complete.merge(expired_at: now)) }
        .to raise_error(ArgumentError, /Expiration evidence contradicts held status/)
    end

    it "requires prior confirmation and expiration evidence for Expired" do
      complete = confirmation_evidence.merge(status: "expired", expired_at: now + 300)

      expect { build_order(**complete.merge(confirmation_idempotency_key: nil)) }
        .to raise_error(ArgumentError, /Confirmation evidence is incomplete/)
      expect { build_order(**complete.merge(expired_at: nil)) }
        .to raise_error(ArgumentError, /Expiration evidence is incomplete/)
      expect { build_order(**complete.merge(held_at: now)) }
        .to raise_error(ArgumentError, /Hold evidence contradicts expired status/)
    end
  end

  def build_order(**overrides)
    described_class.new(**{
      id: "0d13889c-916c-43e7-8f25-f21e19b6ef71",
      branch_id: "d4a98431-609d-4b50-92f5-c973aec268db",
      created_by_actor_id: "e75b9410-c367-490b-bb05-fd0bd86a54ba",
      order_number: "AF-TEST",
      channel: "takeaway",
      status: "draft",
      total: Orders::Domain::ValueObjects::Money.new(amount: 80_000, currency_code: "VND"),
      creation_idempotency_key: "create-1",
      creation_request_fingerprint: "a" * 64,
      lock_version: 0,
      created_at: now,
      updated_at: now
    }.merge(overrides))
  end

  def confirmation_evidence
    {
      confirmation_idempotency_key: "confirm-1",
      confirmed_at: now,
      payment_expires_at: now + 300
    }
  end

  def hold_evidence
    {
      hold_idempotency_key: "hold-1",
      hold_reason: "Review",
      held_at: now + 60
    }
  end
end
