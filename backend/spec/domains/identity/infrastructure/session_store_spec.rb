require "rails_helper"

RSpec.describe Identity::Infrastructure::Adapters::ActiveRecordSessionStore do
  subject(:store) { described_class.new }

  let(:user) { create(:identity_user_record) }
  let(:identity) do
    Identity::Application::Contracts::AuthenticatedIdentity.new(
      user_id: user.id,
      organization_id: user.organization_id
    )
  end
  let(:now) { Time.utc(2026, 11, 26, 1, 0, 0) }

  it "persists only verifiers and derives the actor from the authenticated session" do
    issued = store.issue(identity: identity, now: now)
    record = Identity::Infrastructure::Persistence::AuthenticationSessionRecord.find(issued.actor.session_id)

    expect(record.secret_verifier_digest).not_to be_in(issued.cookie_value)
    expect(record.csrf_verifier_digest).not_to eq(issued.csrf_token)
    expect(store.authenticate(cookie_value: issued.cookie_value, now: now + 10.minutes)).to eq(issued.actor)
    expect(record.reload.idle_expires_at).to eq(now + 40.minutes)
  end

  it "fails closed for a forged secret, expiry, revocation, and suspended account" do
    issued = store.issue(identity: identity, now: now)
    session_id = issued.actor.session_id

    expect(store.authenticate(cookie_value: "#{session_id}.forged", now: now)).to be_nil
    expect(store.authenticate(cookie_value: issued.cookie_value, now: now + 31.minutes)).to be_nil

    fresh = store.issue(identity: identity, now: now)
    expect(store.revoke(cookie_value: fresh.cookie_value, now: now + 1.minute, reason: "test")).to be(true)
    expect(store.authenticate(cookie_value: fresh.cookie_value, now: now + 2.minutes)).to be_nil

    suspended = store.issue(identity: identity, now: now)
    user.update!(status: "suspended")
    expect(store.authenticate(cookie_value: suspended.cookie_value, now: now + 1.minute)).to be_nil
  end

  it "renews idle expiry without extending the immutable absolute lifetime" do
    issued = store.issue(identity: identity, now: now)

    actor = nil
    24.times do |step|
      actor = store.authenticate(
        cookie_value: issued.cookie_value,
        now: now + ((step + 1) * 29).minutes
      )
    end

    expect(actor).to eq(issued.actor)
    record = Identity::Infrastructure::Persistence::AuthenticationSessionRecord.find(actor.session_id)
    expect(record.idle_expires_at).to be <= issued.absolute_expires_at
    expect(store.authenticate(cookie_value: issued.cookie_value, now: issued.absolute_expires_at)).to be_nil
  end

  it "validates CSRF against the server-side verifier" do
    issued = store.issue(identity: identity, now: now)

    expect(store.verify_csrf(actor: issued.actor, token: issued.csrf_token)).to be(true)
    expect(store.verify_csrf(actor: issued.actor, token: "forged")).to be(false)
  end
end
