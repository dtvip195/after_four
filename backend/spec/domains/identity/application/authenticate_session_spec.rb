require "rails_helper"

RSpec.describe Identity::Application::UseCases::AuthenticateSession do
  let(:actor) do
    Identity::Application::Contracts::AuthenticatedActor.new(
      user_id: SecureRandom.uuid,
      organization_id: SecureRandom.uuid,
      session_id: SecureRandom.uuid
    )
  end

  it "issues a trusted context only from the configured verified-session port" do
    session_store = instance_double(Identity::Application::Ports::SessionStore)
    allow(session_store).to receive(:authenticate).and_return(actor)

    context = described_class.new(session_store: session_store).call(cookie_value: "opaque-cookie")

    expect(context).to have_attributes(
      user_id: actor.user_id,
      organization_id: actor.organization_id,
      session_id: actor.session_id
    )
    expect(Identity::Application::Contracts::TrustedAuthorizationContext.trusted?(context)).to be(true)
  end

  it "does not expose ordinary construction and rejects a non-actor session result" do
    context_class = Identity::Application::Contracts::TrustedAuthorizationContext
    session_store = instance_double(Identity::Application::Ports::SessionStore)
    allow(session_store).to receive(:authenticate).and_return(
      { user_id: actor.user_id, organization_id: actor.organization_id, session_id: actor.session_id }
    )

    expect { context_class.new }.to raise_error(NoMethodError)
    expect(described_class.new(session_store: session_store).call(cookie_value: "opaque-cookie")).to be_nil
  end
end
