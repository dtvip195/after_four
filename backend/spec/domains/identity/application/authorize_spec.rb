require "rails_helper"

RSpec.describe Identity::Application::UseCases::Authorize do
  subject(:authorize) { described_class.new }

  let(:organization_id) { SecureRandom.uuid }
  let(:user_id) { SecureRandom.uuid }
  let(:session_id) { SecureRandom.uuid }
  let(:actor) do
    Identity::Application::Contracts::AuthenticatedActor.new(
      user_id: user_id,
      organization_id: organization_id,
      session_id: session_id
    )
  end
  let(:context) do
    Identity::Application::Contracts::TrustedAuthorizationContext
      .__send__(:issue_from_verified_actor, actor)
  end

  it "allows only the authenticated user's own organization-scoped session read" do
    request = Identity::Application::Contracts::AuthorizationRequest.new(
      capability: Identity::Application::Contracts::CapabilityIdentifier::SESSION_READ_SELF,
      organization_id: organization_id,
      branch_id: nil,
      resource_owner_user_id: user_id,
      resource_session_id: session_id
    )

    expect(authorize.call(context: context, request: request)).to be(true)
  end

  it "denies cross-organization, cross-user, cross-session, Branch-scoped, and unknown capabilities" do
    capability = Identity::Application::Contracts::CapabilityIdentifier::SESSION_READ_SELF
    requests = [
      [ capability, SecureRandom.uuid, nil, user_id, session_id ],
      [ capability, organization_id, nil, SecureRandom.uuid, session_id ],
      [ capability, organization_id, nil, user_id, SecureRandom.uuid ],
      [ capability, organization_id, SecureRandom.uuid, user_id, session_id ],
      [ "orders.read", organization_id, nil, user_id, session_id ]
    ].map do |requested_capability, organization, branch, owner, requested_session|
      Identity::Application::Contracts::AuthorizationRequest.new(
        capability: requested_capability,
        organization_id: organization,
        branch_id: branch,
        resource_owner_user_id: owner,
        resource_session_id: requested_session
      )
    end

    expect(requests).to all(satisfy { |request| !authorize.call(context: context, request: request) })
  end

  it "rejects missing, client-shaped, and unissued contexts" do
    request = Identity::Application::Contracts::AuthorizationRequest.new(
      capability: Identity::Application::Contracts::CapabilityIdentifier::SESSION_READ_SELF,
      organization_id: organization_id,
      branch_id: nil,
      resource_owner_user_id: user_id,
      resource_session_id: session_id
    )

    plausible_context = Data.define(:user_id, :organization_id, :session_id).new(
      user_id: user_id,
      organization_id: organization_id,
      session_id: session_id
    )
    unissued_context = Identity::Application::Contracts::TrustedAuthorizationContext.allocate

    expect(authorize.call(context: nil, request: request)).to be(false)
    expect(authorize.call(context: plausible_context, request: request)).to be(false)
    expect(authorize.call(context: unissued_context, request: request)).to be(false)
    expect(authorize.call(context: { user_id: user_id, role: "Owner" }, request: request)).to be(false)
  end

  it "resolves only the single registered capability identifier" do
    capability_class = Identity::Application::Contracts::CapabilityIdentifier

    expect(capability_class.resolve("identity.session.read_self"))
      .to equal(capability_class::SESSION_READ_SELF)
    expect(capability_class.resolve("orders.read")).to be_nil
    expect { capability_class.new("orders.read") }.to raise_error(NoMethodError)
  end

  it "rejects every POS capability object and duck-typed POS lookalike" do
    pos_capabilities = Identity::Domain::ValueObjects::PosCapability.all
    duck_typed_capability = Data.define(:value).new("pos.orders.read")

    requests = (pos_capabilities + [ duck_typed_capability ]).map do |capability|
      Identity::Application::Contracts::AuthorizationRequest.new(
        capability: capability,
        organization_id: organization_id,
        branch_id: nil,
        resource_owner_user_id: user_id,
        resource_session_id: session_id
      )
    end

    expect(requests).to all(satisfy { |request| !authorize.call(context: context, request: request) })
  end
end
