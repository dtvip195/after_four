module Api
  module V1
    class ErrorsController < BaseController
      def not_found
        render_api_error(
          code: "resource_not_found",
          message: "Không tìm thấy dữ liệu yêu cầu.",
          status: :not_found
        )
      end
    end
  end
end
