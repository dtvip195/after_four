require "rails_helper"

RSpec.describe Identity::Application::UseCases::Authorize do
  subject(:authorize) { described_class.new }

  let(:organization_id) { SecureRandom.uuid }
  let(:user_id) { SecureRandom.uuid }
  let(:actor) do
    Identity::Application::Contracts::AuthenticatedActor.new(
      user_id: user_id,
      organization_id: organization_id,
      session_id: SecureRandom.uuid
    )
  end

  it "allows only the authenticated user's own organization-scoped session read" do
    request = Identity::Application::Contracts::AuthorizationRequest.new(
      action: described_class::SELF_SESSION_READ,
      organization_id: organization_id,
      branch_id: nil,
      resource_owner_user_id: user_id
    )

    expect(authorize.call(actor: actor, request: request)).to be(true)
  end

  it "denies cross-organization, cross-user, Branch-scoped, and unknown actions by default" do
    requests = [
      [ described_class::SELF_SESSION_READ, SecureRandom.uuid, nil, user_id ],
      [ described_class::SELF_SESSION_READ, organization_id, nil, SecureRandom.uuid ],
      [ described_class::SELF_SESSION_READ, organization_id, SecureRandom.uuid, user_id ],
      [ "orders.read", organization_id, nil, user_id ]
    ].map do |action, organization, branch, owner|
      Identity::Application::Contracts::AuthorizationRequest.new(
        action: action,
        organization_id: organization,
        branch_id: branch,
        resource_owner_user_id: owner
      )
    end

    expect(requests).to all(satisfy { |request| !authorize.call(actor: actor, request: request) })
  end

  it "rejects missing and client-shaped actors" do
    request = Identity::Application::Contracts::AuthorizationRequest.new(
      action: described_class::SELF_SESSION_READ,
      organization_id: organization_id,
      branch_id: nil,
      resource_owner_user_id: user_id
    )

    expect(authorize.call(actor: nil, request: request)).to be(false)
    expect(authorize.call(actor: { user_id: user_id, role: "Owner" }, request: request)).to be(false)
  end
end
