require "spec_helper"
require_relative "../../../../app/contexts/identity/application/contracts/capability_identifier"
require_relative "../../../../app/contexts/identity/domain/value_objects/pos_capability"
require_relative "../../../../app/contexts/identity/domain/value_objects/role_code"
require_relative "../../../../app/contexts/identity/domain/policies/pos_capability_policy"

RSpec.describe Identity::Domain::ValueObjects::PosCapability do
  describe ".all" do
    it "contains exactly the eleven approved POS capabilities" do
      expect(described_class.all.map(&:value)).to eq(
        [
          "pos.catalog.menu.read",
          "pos.orders.read",
          "pos.orders.create",
          "pos.orders.confirm",
          "pos.orders.hold",
          "pos.payments.read",
          "pos.payments.cash.confirm",
          "pos.payments.review.read",
          "pos.preparation.dispatch.read",
          "pos.preparation.dispatch.recover",
          "pos.preparation.dispatch.retry"
        ]
      )
    end
  end

  describe ".resolve" do
    it "resolves only exact approved values without parsing or wildcard behavior" do
      expect(described_class.resolve("pos.orders.read"))
        .to equal(described_class::ORDERS_READ)

      [
        "pos.orders",
        "pos.orders.*",
        "pos.orders.read.extra",
        "POS.ORDERS.READ",
        :"pos.orders.read",
        nil
      ].each do |candidate|
        expect(described_class.resolve(candidate)).to be_nil
      end
    end

    it "cannot be directly constructed or mutated" do
      expect { described_class.new("pos.orders.read") }.to raise_error(NoMethodError)
      expect { described_class.allocate }.to raise_error(NoMethodError)
      expect { described_class::ORDERS_READ.dup }.to raise_error(TypeError)
      expect { described_class::ORDERS_READ.clone }.to raise_error(TypeError)
      expect { Class.new(described_class) }.to raise_error(TypeError)
      expect(described_class::ORDERS_READ).to be_frozen
      expect(described_class::ORDERS_READ.value).to be_frozen
      expect(described_class.all).to be_frozen
    end
  end
end

RSpec.describe Identity::Domain::ValueObjects::RoleCode do
  it "contains only Owner, Branch Manager, and Staff" do
    expect(described_class.all.map(&:value)).to eq(%w[owner branch_manager staff])
    expect(described_class.resolve("owner")).to equal(described_class::OWNER)
    expect(described_class.resolve("branch_manager")).to equal(described_class::BRANCH_MANAGER)
    expect(described_class.resolve("staff")).to equal(described_class::STAFF)
  end

  it "rejects unknown, implicit, and directly constructed roles" do
    [ "regional_manager", "manager", "Owner", :owner, nil ].each do |candidate|
      expect(described_class.resolve(candidate)).to be_nil
    end

    expect { described_class.new("owner") }.to raise_error(NoMethodError)
    expect { described_class.allocate }.to raise_error(NoMethodError)
    expect { described_class::OWNER.dup }.to raise_error(TypeError)
    expect { described_class::OWNER.clone }.to raise_error(TypeError)
    expect { Class.new(described_class) }.to raise_error(TypeError)
    expect(described_class.all).to be_frozen
    expect(described_class.all).to all(be_frozen)
  end
end

RSpec.describe Identity::Domain::Policies::PosCapabilityPolicy do
  subject(:policy) { described_class.new }

  let(:capability_class) { Identity::Domain::ValueObjects::PosCapability }
  let(:role_class) { Identity::Domain::ValueObjects::RoleCode }

  it "matches every approved role, capability, scope, and Session-MFA matrix scenario" do
    staff_expected = {
      "pos.catalog.menu.read" => described_class::ALLOW_IN_POLICY,
      "pos.orders.read" => described_class::ALLOW_IN_POLICY,
      "pos.orders.create" => described_class::ALLOW_IN_POLICY,
      "pos.orders.confirm" => described_class::ALLOW_IN_POLICY,
      "pos.orders.hold" => described_class::ALLOW_IN_POLICY,
      "pos.payments.read" => described_class::ALLOW_IN_POLICY,
      "pos.payments.cash.confirm" => described_class::ALLOW_IN_POLICY,
      "pos.payments.review.read" => described_class::DENY,
      "pos.preparation.dispatch.read" => described_class::ALLOW_IN_POLICY,
      "pos.preparation.dispatch.recover" => described_class::DENY,
      "pos.preparation.dispatch.retry" => described_class::DENY
    }
    scenarios = [
      [ "owner organization without MFA", role_class::OWNER, described_class::ORGANIZATION_SCOPE, false, :all ],
      [ "owner organization with MFA", role_class::OWNER, described_class::ORGANIZATION_SCOPE, true, :all ],
      [ "owner exact Branch without MFA", role_class::OWNER, described_class::EXACT_BRANCH_SCOPE, false, :none ],
      [ "owner exact Branch with MFA", role_class::OWNER, described_class::EXACT_BRANCH_SCOPE, true, :none ],
      [ "owner wrong Branch without MFA", role_class::OWNER, :wrong_branch, false, :none ],
      [ "owner wrong Branch with MFA", role_class::OWNER, :wrong_branch, true, :none ],
      [ "owner missing scope without MFA", role_class::OWNER, nil, false, :none ],
      [ "owner missing scope with MFA", role_class::OWNER, nil, true, :none ],
      [
        "manager exact Branch without MFA", role_class::BRANCH_MANAGER,
        described_class::EXACT_BRANCH_SCOPE, false, :none
      ],
      [ "manager exact Branch with MFA", role_class::BRANCH_MANAGER, described_class::EXACT_BRANCH_SCOPE, true, :all ],
      [
        "manager organization without MFA", role_class::BRANCH_MANAGER,
        described_class::ORGANIZATION_SCOPE, false, :none
      ],
      [ "manager organization with MFA", role_class::BRANCH_MANAGER, described_class::ORGANIZATION_SCOPE, true, :none ],
      [ "manager wrong Branch without MFA", role_class::BRANCH_MANAGER, :wrong_branch, false, :none ],
      [ "manager wrong Branch with MFA", role_class::BRANCH_MANAGER, :wrong_branch, true, :none ],
      [ "manager missing scope without MFA", role_class::BRANCH_MANAGER, nil, false, :none ],
      [ "manager missing scope with MFA", role_class::BRANCH_MANAGER, nil, true, :none ],
      [ "staff exact Branch without MFA", role_class::STAFF, described_class::EXACT_BRANCH_SCOPE, false, :staff ],
      [ "staff exact Branch with MFA", role_class::STAFF, described_class::EXACT_BRANCH_SCOPE, true, :staff ],
      [ "staff organization without MFA", role_class::STAFF, described_class::ORGANIZATION_SCOPE, false, :none ],
      [ "staff organization with MFA", role_class::STAFF, described_class::ORGANIZATION_SCOPE, true, :none ],
      [ "staff wrong Branch without MFA", role_class::STAFF, :wrong_branch, false, :none ],
      [ "staff wrong Branch with MFA", role_class::STAFF, :wrong_branch, true, :none ],
      [ "staff missing scope without MFA", role_class::STAFF, nil, false, :none ],
      [ "staff missing scope with MFA", role_class::STAFF, nil, true, :none ]
    ]

    scenarios.each do |name, role, scope, session_mfa_satisfied, permission_set|
      capability_class.all.each do |capability|
        expected = case permission_set
        when :all then described_class::ALLOW_IN_POLICY
        when :staff then staff_expected.fetch(capability.value)
        else described_class::DENY
        end
        actual = policy.evaluate(
          capability: capability,
          role: role,
          scope: scope,
          session_mfa_satisfied: session_mfa_satisfied,
          action_level_step_up_required: false
        )

        expect(actual).to equal(expected), "#{name}: #{capability.value}"
      end
    end
  end

  it "keeps every valid-scope action-level step-up scenario and production activation not implemented" do
    valid_scenarios = [
      [ role_class::OWNER, described_class::ORGANIZATION_SCOPE, false ],
      [ role_class::OWNER, described_class::ORGANIZATION_SCOPE, true ],
      [ role_class::OWNER, described_class::EXACT_BRANCH_SCOPE, false ],
      [ role_class::OWNER, described_class::EXACT_BRANCH_SCOPE, true ],
      [ role_class::BRANCH_MANAGER, described_class::ORGANIZATION_SCOPE, false ],
      [ role_class::BRANCH_MANAGER, described_class::ORGANIZATION_SCOPE, true ],
      [ role_class::BRANCH_MANAGER, described_class::EXACT_BRANCH_SCOPE, false ],
      [ role_class::BRANCH_MANAGER, described_class::EXACT_BRANCH_SCOPE, true ],
      [ role_class::STAFF, described_class::ORGANIZATION_SCOPE, false ],
      [ role_class::STAFF, described_class::ORGANIZATION_SCOPE, true ],
      [ role_class::STAFF, described_class::EXACT_BRANCH_SCOPE, false ],
      [ role_class::STAFF, described_class::EXACT_BRANCH_SCOPE, true ]
    ]
    step_up_outcomes = valid_scenarios.product(capability_class.all).map do |scenario, capability|
      role, scope, session_mfa_satisfied = scenario
      policy.evaluate(
        capability: capability,
        role: role,
        scope: scope,
        session_mfa_satisfied: session_mfa_satisfied,
        action_level_step_up_required: true
      )
    end
    activation_outcomes = capability_class.all.map do |capability|
      policy.activation_outcome(capability: capability)
    end

    expect(step_up_outcomes).to all(equal(described_class::NOT_IMPLEMENTED))
    expect(activation_outcomes).to all(equal(described_class::NOT_IMPLEMENTED))
    expect(described_class::ALLOW_IN_POLICY.value).to eq("ALLOW_IN_POLICY")
    expect(described_class::DENY.value).to eq("DENY")
    expect(described_class::NOT_IMPLEMENTED.value).to eq("NOT_IMPLEMENTED")
    expect { described_class::Outcome.new("ALLOW_IN_POLICY") }.to raise_error(NoMethodError)
  end

  it "denies forged, copied, subclassed, and equality-impersonating authority evidence" do
    forged_capability = capability_class.__send__(:allocate)
    forged_role = role_class.__send__(:allocate)
    equality_impostor = Object.new
    equality_impostor.define_singleton_method(:==) { |_other| true }
    equality_impostor.define_singleton_method(:equal?) { |_other| true }

    defaults = {
      capability: capability_class::ORDERS_READ,
      role: role_class::OWNER,
      scope: described_class::ORGANIZATION_SCOPE,
      session_mfa_satisfied: false,
      action_level_step_up_required: false
    }
    invalid_inputs = [
      { capability: forged_capability },
      { role: forged_role },
      { scope: equality_impostor },
      { session_mfa_satisfied: equality_impostor },
      { action_level_step_up_required: equality_impostor }
    ]

    expect(invalid_inputs.map { |input| policy.evaluate(**defaults.merge(input)) })
      .to all(equal(described_class::DENY))
    expect(policy.activation_outcome(capability: forged_capability))
      .to equal(described_class::DENY)
  end

  it "fails closed for cross-type, unknown, missing, and unavailable inputs" do
    self_session_capability =
      Identity::Application::Contracts::CapabilityIdentifier::SESSION_READ_SELF
    duck_typed_capability = Data.define(:value).new("pos.orders.read")

    invalid_inputs = [
      { capability: "pos.orders.read" },
      { capability: self_session_capability },
      { capability: duck_typed_capability },
      { capability: nil },
      { role: "owner" },
      { role: nil },
      { scope: nil },
      { scope: :wrong_branch },
      { scope: :ambiguous },
      { scope: :inconsistent },
      { scope: :unavailable },
      { scope: nil, action_level_step_up_required: true },
      { session_mfa_satisfied: nil },
      { session_mfa_satisfied: :unavailable },
      { action_level_step_up_required: nil }
    ]

    defaults = {
      capability: capability_class::ORDERS_READ,
      role: role_class::OWNER,
      scope: described_class::ORGANIZATION_SCOPE,
      session_mfa_satisfied: false,
      action_level_step_up_required: false
    }

    outcomes = invalid_inputs.map do |invalid_input|
      policy.evaluate(**defaults.merge(invalid_input))
    end

    expect(outcomes).to all(equal(described_class::DENY))
    expect(policy.activation_outcome(capability: "pos.orders.read"))
      .to equal(described_class::DENY)
  end
end
