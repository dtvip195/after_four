require "spec_helper"
require_relative "../support/application_fakes"

RSpec.describe Orders::Application::UseCases::CreateDraft do
  include OrderingApplicationSpecSupport

  let(:repository) { OrderingApplicationSpecSupport::InMemoryOrderRepository.new }
  let(:payments) { OrderingApplicationSpecSupport::PaymentGatewayFake.new }
  let(:audit_log) { OrderingApplicationSpecSupport::AuditLogFake.new }
  let(:unit_of_work) { OrderingApplicationSpecSupport::UnitOfWorkFake.new }

  it "creates and replays one complete Draft without regenerating its identity" do
    generated_tokens = 0
    use_case = build_use_case(token_generator: -> { generated_tokens += 1; "a1b2c3d4e5f6" })

    first = use_case.call(**draft_attributes)
    replay = use_case.call(**draft_attributes.merge(now: OrderingApplicationSpecSupport::NOW + 60))

    expect(first).to have_attributes(replayed: false, payment_reference: "payment-1")
    expect(first.order.order_number).to eq("AF-A1B2C3D4E5F6")
    expect(replay).to have_attributes(replayed: true, payment_reference: "payment-1")
    expect(repository.additions).to contain_exactly(first.order)
    expect(payments.created_targets).to contain_exactly(
      [ first.order.id.to_s, 80_000, "VND", OrderingApplicationSpecSupport::NOW ]
    )
    expect(audit_log.events.map(&:first)).to eq([ :created ])
    expect(unit_of_work.calls).to eq(1)
    expect(generated_tokens).to eq(1)
  end

  it "scopes creation keys by Branch and fingerprints normalized semantic input" do
    use_case = build_use_case
    first = use_case.call(**draft_attributes)
    replay = use_case.call(
      **draft_attributes.merge(actor_id: OrderingApplicationSpecSupport::ACTOR_ID.upcase, currency_code: "vnd")
    )
    other_branch = use_case.call(**draft_attributes.merge(branch_id: "1e7d54a0-9a21-4bec-978f-032df0eb8bb9"))

    expect(replay).to have_attributes(replayed: true)
    expect(replay.order.id).to eq(first.order.id)
    expect(other_branch).to have_attributes(replayed: false)
    expect(other_branch.order.id).not_to eq(first.order.id)
  end

  it "rejects a replay whose semantic creation input differs" do
    use_case = build_use_case
    use_case.call(**draft_attributes)

    [
      { channel: "dine_in" },
      { total_amount: 81_000 },
      { currency_code: "USD" },
      { actor_id: "1e7d54a0-9a21-4bec-978f-032df0eb8bb9" }
    ].each do |changed_input|
      expect { use_case.call(**draft_attributes.merge(changed_input)) }
        .to raise_error(Orders::Domain::Errors::RuleViolation) { |error|
          expect(error.code).to eq("idempotency_conflict")
        }
    end
  end

  it "creates independent Orders for unrelated keys in the same Branch" do
    use_case = build_use_case
    first = use_case.call(**draft_attributes)
    second = use_case.call(**draft_attributes.merge(idempotency_key: "create-2"))

    expect(first.order.id).not_to eq(second.order.id)
    expect(repository.additions).to contain_exactly(first.order, second.order)
    expect(payments.created_targets.length).to eq(2)
    expect(audit_log.events.map(&:first)).to eq(%i[created created])
  end

  it "validates trusted context before constructing the Draft" do
    use_case = build_use_case

    {
      actor_id: [ "invalid", "trusted_actor_required" ],
      branch_id: [ "invalid", "branch_context_required" ],
      idempotency_key: [ " ", "idempotency_key_required" ]
    }.each do |field, (value, code)|
      expect { use_case.call(**draft_attributes.merge(field => value)) }
        .to raise_error(Orders::Domain::Errors::RuleViolation) { |error|
          expect(error.code).to eq(code)
        }
    end
    expect(repository.additions).to be_empty
    expect(payments.created_targets).to be_empty
  end

  it "reports invalid Draft attributes without exposing Active Record" do
    expect { build_use_case.call(**draft_attributes.merge(channel: "delivery")) }
      .to raise_error(Orders::Application::Errors::InvalidDraft) { |error|
        expect(error.attributes).to include(
          channel: "delivery",
          total_amount: 80_000,
          currency_code: "VND",
          order_number: "AF-A1B2C3D4E5F6"
        )
        expect(error.cause).to be_a(ArgumentError)
      }
  end

  def build_use_case(token_generator: -> { "a1b2c3d4e5f6" })
    described_class.new(
      order_repository: repository,
      payment_gateway: payments,
      audit_log: audit_log,
      unit_of_work: unit_of_work,
      id_generator: -> { SecureRandom.uuid },
      order_number_token_generator: token_generator
    )
  end
end
