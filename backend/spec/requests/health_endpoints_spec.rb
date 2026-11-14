require "rails_helper"

RSpec.describe "Health endpoints", type: :request do
  it "reports liveness without querying the database" do
    sql_events = []
    subscriber = ActiveSupport::Notifications.subscribe("sql.active_record") do |event|
      sql_events << event
    end

    begin
      get "/health/live", headers: { "X-Request-ID" => "req-live-test" }
    ensure
      ActiveSupport::Notifications.unsubscribe(subscriber)
    end

    expect(response).to have_http_status(:ok)
    expect(sql_events).to be_empty
    expect(response.headers["X-Request-ID"]).to eq("req-live-test")
    expect(response.parsed_body).to eq("status" => "ok", "request_id" => "req-live-test")
  end

  it "reports readiness when PostgreSQL responds" do
    get "/health/ready", headers: { "X-Request-ID" => "req-ready-test" }

    expect(response).to have_http_status(:ok)
    expect(response.parsed_body).to eq("status" => "ready", "request_id" => "req-ready-test")
  end

  it "reports unavailable without exposing connection details" do
    allow(ActiveRecord::Base).to receive(:connection_pool).and_raise(
      ActiveRecord::ConnectionNotEstablished,
      "secret-host.example"
    )

    get "/health/ready", headers: { "X-Request-ID" => "req-not-ready-test" }

    expect(response).to have_http_status(:service_unavailable)
    expect(response.parsed_body).to eq(
      "status" => "not_ready",
      "request_id" => "req-not-ready-test"
    )
    expect(response.body).not_to include("secret-host.example")
  end
end
