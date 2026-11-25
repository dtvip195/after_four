require "rails_helper"

RSpec.describe Identity::SessionPolicy do
  let(:actor) do
    Identity::Application::Contracts::AuthenticatedActor.new(
      user_id: SecureRandom.uuid,
      organization_id: SecureRandom.uuid,
      session_id: SecureRandom.uuid
    )
  end
  let(:context) do
    Identity::Application::Contracts::TrustedAuthorizationContext
      .__send__(:issue_from_verified_actor, actor)
  end
  let(:request) do
    Identity::Application::Contracts::AuthorizationRequest.new(
      capability: Identity::Application::Contracts::CapabilityIdentifier::SESSION_READ_SELF,
      organization_id: actor.organization_id,
      branch_id: nil,
      resource_owner_user_id: actor.user_id,
      resource_session_id: actor.session_id
    )
  end

  it "adapts the existing Application decision for the HTTP boundary" do
    expect(described_class.new(context, request)).to be_show
    expect(described_class.new(actor, request)).not_to be_show
  end
end
