module Health
  class ReadyController < ApplicationController
    def show
      Platform::DatabaseReadiness.call
      render json: { status: "ready", request_id: request.request_id }
    rescue ActiveRecord::ActiveRecordError, PG::Error
      render json: { status: "not_ready", request_id: request.request_id }, status: :service_unavailable
    end
  end
end
