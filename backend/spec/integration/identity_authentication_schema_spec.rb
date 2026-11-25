require "rails_helper"

RSpec.describe "Identity authentication database integrity" do
  let(:user_record_class) { Identity::Infrastructure::Persistence::UserRecord }
  let(:session_record_class) do
    Identity::Infrastructure::Persistence::AuthenticationSessionRecord
  end

  it "enforces normalized username uniqueness within an Organization only" do
    organization = create(:organization_record)
    create(:identity_user_record, organization_id: organization.id, username: "Cafe.Owner")

    expect do
      create(:identity_user_record, organization_id: organization.id, username: "cafe.owner")
    end.to raise_error(ActiveRecord::RecordNotUnique)

    other_organization = create(:organization_record)
    expect do
      create(:identity_user_record, organization_id: other_organization.id, username: "CAFE.OWNER")
    end.not_to raise_error
  end

  it "restricts User deletion while authentication evidence exists" do
    user = create(:identity_user_record)
    identity = Identity::Application::Contracts::AuthenticatedIdentity.new(
      user_id: user.id,
      organization_id: user.organization_id
    )
    Identity::Infrastructure::Adapters::ActiveRecordSessionStore.new.issue(
      identity: identity,
      now: Time.current
    )

    expect { user.delete }.to raise_error(ActiveRecord::StatementInvalid) do |error|
      expect(error.cause).to be_a(PG::RestrictViolation)
    end
  end

  it "rejects invalid lifecycle and session verifier data at the database boundary" do
    user = create(:identity_user_record)

    expect do
      user_record_class.where(id: user.id).update_all(status: "unknown")
    end.to raise_error(ActiveRecord::StatementInvalid)

    expect do
      session_record_class.insert_all!([ {
        id: SecureRandom.uuid,
        user_id: user.id,
        secret_verifier_digest: "plaintext-secret",
        csrf_verifier_digest: "plaintext-csrf",
        authenticated_at: Time.current,
        last_seen_at: Time.current,
        idle_expires_at: 1.hour.from_now,
        absolute_expires_at: 12.hours.from_now,
        lock_version: 0,
        created_at: Time.current,
        updated_at: Time.current
      } ])
    end.to raise_error(ActiveRecord::StatementInvalid)
  end
end
