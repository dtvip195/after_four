Rails.application.routes.draw do
  get "/health/live", to: "health/live#show"
  get "/health/ready", to: "health/ready#show"

  namespace :api do
    namespace :v1 do
      match "*unmatched", to: "errors#not_found", via: :all
    end
  end
end
