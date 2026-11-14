module ApiErrorRendering
  private

  def render_api_error(code:, message:, status:, retryable: false, details: {}, field_errors: [])
    render json: {
      error: {
        code: code,
        message: message,
        request_id: request.request_id,
        retryable: retryable,
        details: details,
        field_errors: field_errors
      }
    }, status: status
  end
end
