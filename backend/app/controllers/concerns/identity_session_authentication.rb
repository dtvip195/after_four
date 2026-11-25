module IdentitySessionAuthentication
  extend ActiveSupport::Concern

  included do
    attr_reader :current_actor
  end

  private

  def authenticate_identity_session!
    @current_actor = IdentityComposition.authenticate_session_use_case.call(
      cookie_value: cookies[identity_session_cookie_name]
    )
    return if current_actor

    render_authentication_failure
  end

  def verify_identity_csrf!
    token = request.headers["X-CSRF-Token"]
    valid = current_actor && IdentityComposition.dependencies.session_store.verify_csrf(
      actor: current_actor,
      token: token
    )
    return if valid

    render_api_error(
      code: "invalid_request",
      message: "Không thể xác minh yêu cầu.",
      status: :unprocessable_content
    )
  end

  def require_same_origin!
    allowed_origin = Rails.configuration.x.identity.browser_origin
    return if request.origin == allowed_origin

    render_api_error(
      code: "invalid_request",
      message: "Không thể xác minh yêu cầu.",
      status: :unprocessable_content
    )
  end

  def render_authentication_failure
    render_api_error(
      code: "authentication_required",
      message: "Không thể xác thực tài khoản hoặc phiên làm việc.",
      status: :unauthorized
    )
  end

  def identity_session_cookie_name
    Rails.configuration.x.identity.session_cookie_name
  end
end
