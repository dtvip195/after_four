module Health
  class LiveController < ApplicationController
    def show
      render json: { status: "ok", request_id: request.request_id }
    end
  end
end
