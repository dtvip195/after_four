require "rails_helper"

RSpec.describe "Identity sessions", type: :request do
  let(:organization) { create(:organization_record) }
  let(:password) { "correct horse battery staple" }
  let!(:user) do
    create(
      :identity_user_record,
      organization_id: organization.id,
      username: "branch-owner",
      password: password,
      password_confirmation: password
    )
  end
  let(:origin_headers) { { "Origin" => "http://localhost:5173" } }

  it "logs in with a generic safe response and an opaque protected cookie" do
    post "/api/v1/auth/session",
      params: {
        organization_id: organization.id,
        username: user.username,
        password: password,
        actor_id: SecureRandom.uuid,
        role: "Owner",
        branch_id: SecureRandom.uuid
      },
      headers: origin_headers

    expect(response).to have_http_status(:created)
    expect(response.parsed_body.dig("session", "user_id")).to eq(user.id)
    expect(response.parsed_body.dig("session", "organization_id")).to eq(organization.id)
    expect(response.parsed_body.dig("session", "csrf_token")).to be_present
    expect(response.headers["Set-Cookie"]).to include("after_four_session=")
    expect(response.headers["Set-Cookie"].downcase).to include("httponly", "samesite=lax")
    expect(response.headers["Set-Cookie"]).not_to include(user.id, organization.id, "Owner")
  end

  it "returns the same failure contract for an unknown account and an invalid password" do
    responses = [
      { organization_id: organization.id, username: "unknown", password: password },
      { organization_id: organization.id, username: user.username, password: "wrong password value" }
    ].map do |credentials|
      post "/api/v1/auth/session", params: credentials, headers: origin_headers
      [
        response.status,
        response.parsed_body.dig("error", "code"),
        response.parsed_body.dig("error", "message")
      ]
    end

    expect(responses.uniq.one?).to be(true)
    expect(responses.first.first).to eq(401)
  end

  it "rejects locked, suspended, and cross-organization authentication" do
    other_organization = create(:organization_record)
    failures = [
      -> { user.update!(locked_at: Time.current) },
      -> { user.update!(locked_at: nil, status: "suspended") }
    ]

    failures.each do |prepare|
      prepare.call
      post "/api/v1/auth/session",
        params: { organization_id: organization.id, username: user.username, password: password },
        headers: origin_headers
      expect(response).to have_http_status(:unauthorized)
    end

    user.update!(status: "active")
    post "/api/v1/auth/session",
      params: { organization_id: other_organization.id, username: user.username, password: password },
      headers: origin_headers
    expect(response).to have_http_status(:unauthorized)
  end

  it "requires the approved browser origin" do
    post "/api/v1/auth/session",
      params: { organization_id: organization.id, username: user.username, password: password }

    expect(response).to have_http_status(:unprocessable_content)
  end

  it "derives the current actor from the session and revokes it on CSRF-protected logout" do
    post "/api/v1/auth/session",
      params: { organization_id: organization.id, username: user.username, password: password },
      headers: origin_headers
    csrf_token = response.parsed_body.dig("session", "csrf_token")
    cookie = response.headers["Set-Cookie"].split(";", 2).first

    get "/api/v1/auth/session",
      params: {
        actor_id: SecureRandom.uuid,
        organization_id: SecureRandom.uuid,
        branch_id: SecureRandom.uuid,
        role: "Owner"
      },
      headers: { "Cookie" => cookie }
    expect(response).to have_http_status(:ok)
    expect(response.parsed_body.dig("session", "user_id")).to eq(user.id)
    expect(response.parsed_body.dig("session", "organization_id")).to eq(organization.id)

    delete "/api/v1/auth/session", headers: origin_headers.merge("Cookie" => cookie)
    expect(response).to have_http_status(:unprocessable_content)

    delete "/api/v1/auth/session",
      headers: origin_headers.merge("Cookie" => cookie, "X-CSRF-Token" => csrf_token)
    expect(response).to have_http_status(:no_content)

    get "/api/v1/auth/session", headers: { "Cookie" => cookie }
    expect(response).to have_http_status(:unauthorized)
  end

  it "temporarily locks an account after the configured failed-attempt threshold" do
    Devise.maximum_attempts.times do
      post "/api/v1/auth/session",
        params: {
          organization_id: organization.id,
          username: user.username,
          password: "wrong password value"
        },
        headers: origin_headers
    end

    expect(user.reload).to be_access_locked
    post "/api/v1/auth/session",
      params: { organization_id: organization.id, username: user.username, password: password },
      headers: origin_headers
    expect(response).to have_http_status(:unauthorized)
  end
end
