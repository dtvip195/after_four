require "rails_helper"

RSpec.describe Identity::Infrastructure::Persistence::UserRecord do
  it "uses only the approved Devise credential modules" do
    expect(described_class.devise_modules).to contain_exactly(
      :database_authenticatable,
      :recoverable,
      :lockable,
      :timeoutable
    )
  end

  it "allows a reset token exactly once" do
    user = create(:identity_user_record)
    raw_token = user.send(:set_reset_password_token)

    reset = described_class.reset_password_by_token(
      reset_password_token: raw_token,
      password: "a newly approved secure password",
      password_confirmation: "a newly approved secure password"
    )
    replay = described_class.reset_password_by_token(
      reset_password_token: raw_token,
      password: "another secure password value",
      password_confirmation: "another secure password value"
    )

    expect(reset.errors).to be_empty
    expect(replay.errors[:reset_password_token]).to be_present
  end

  it "normalizes password input consistently and revokes existing sessions on change" do
    decomposed_password = "a secure cafe\u0301 password value"
    user = create(
      :identity_user_record,
      password: decomposed_password,
      password_confirmation: decomposed_password
    )
    identity = Identity::Application::Contracts::AuthenticatedIdentity.new(
      user_id: user.id,
      organization_id: user.organization_id
    )
    issued = Identity::Infrastructure::Adapters::ActiveRecordSessionStore.new.issue(
      identity: identity,
      now: Time.current
    )

    expect(user.valid_password?(decomposed_password.unicode_normalize(:nfc))).to be(true)

    user.update!(
      password: "a replacement secure password value",
      password_confirmation: "a replacement secure password value"
    )

    session = Identity::Infrastructure::Persistence::AuthenticationSessionRecord.find(
      issued.actor.session_id
    )
    expect(session).to have_attributes(
      revocation_reason: "credential_changed",
      revoked_at: be_present
    )
  end

  it "rejects expired reset tokens" do
    user = create(:identity_user_record)
    raw_token = user.send(:set_reset_password_token)
    user.update_column(:reset_password_sent_at, 2.hours.ago)

    result = described_class.reset_password_by_token(
      reset_password_token: raw_token,
      password: "a newly approved secure password",
      password_confirmation: "a newly approved secure password"
    )

    expect(result.errors[:reset_password_token]).to be_present
  end
end
