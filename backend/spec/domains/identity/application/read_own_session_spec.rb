require "rails_helper"

RSpec.describe Identity::Application::UseCases::ReadOwnSession do
  subject(:use_case) { described_class.new }

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
  let(:capability) { Identity::Application::Contracts::CapabilityIdentifier::SESSION_READ_SELF }

  def request_for(capability:, organization_id:, user_id:, session_id:, branch_id: nil)
    Identity::Application::Contracts::AuthorizationRequest.new(
      capability: capability,
      organization_id: organization_id,
      branch_id: branch_id,
      resource_owner_user_id: user_id,
      resource_session_id: session_id
    )
  end

  it "returns the existing session response values for the trusted session owner" do
    request = request_for(
      capability: capability,
      organization_id: context.organization_id,
      user_id: context.user_id,
      session_id: context.session_id
    )

    expect(use_case.call(context: context, request: request)).to have_attributes(
      user_id: context.user_id,
      organization_id: context.organization_id
    )
  end

  it "denies direct invocation with missing, forged, mismatched, unsupported, or Branch-scoped input" do
    valid_attributes = {
      capability: capability,
      organization_id: context.organization_id,
      user_id: context.user_id,
      session_id: context.session_id
    }
    requests = [
      request_for(**valid_attributes.merge(organization_id: SecureRandom.uuid)),
      request_for(**valid_attributes.merge(user_id: SecureRandom.uuid)),
      request_for(**valid_attributes.merge(session_id: SecureRandom.uuid)),
      request_for(**valid_attributes.merge(capability: "payments.refund.approve")),
      request_for(**valid_attributes.merge(branch_id: SecureRandom.uuid))
    ]

    expect(use_case.call(context: nil, request: request_for(**valid_attributes))).to be_nil
    expect(use_case.call(context: actor, request: request_for(**valid_attributes))).to be_nil
    expect(requests).to all(satisfy { |request| use_case.call(context: context, request: request).nil? })
  end
end
