Rails.application.routes.draw do
  devise_for :users,
    class_name: "Identity::Infrastructure::Persistence::UserRecord",
    skip: :all

  get "/health/live", to: "health/live#show"
  get "/health/ready", to: "health/ready#show"

  namespace :api do
    namespace :v1 do
      namespace :auth do
        resource :session, only: %i[create show destroy]
      end

      match "*unmatched", to: "errors#not_found", via: :all
    end
  end
end
