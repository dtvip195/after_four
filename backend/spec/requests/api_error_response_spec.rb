require "rails_helper"

RSpec.describe "API error responses", type: :request do
  it "returns the canonical error envelope and correlation ID for an unknown v1 route" do
    get "/api/v1/does-not-exist", headers: { "X-Request-ID" => "req-error-test" }

    expect(response).to have_http_status(:not_found)
    expect(response.headers["X-Request-ID"]).to eq("req-error-test")
    expect(response.parsed_body).to eq(
      "error" => {
        "code" => "resource_not_found",
        "message" => "Không tìm thấy dữ liệu yêu cầu.",
        "request_id" => "req-error-test",
        "retryable" => false,
        "details" => {},
        "field_errors" => []
      }
    )
  end
end
