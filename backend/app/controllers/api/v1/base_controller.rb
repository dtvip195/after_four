module Api
  module V1
    class BaseController < ApplicationController
      include ApiErrorRendering
    end
  end
end
