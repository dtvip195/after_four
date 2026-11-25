module Api
  module V1
    module Auth
      class SessionsController < BaseController
        include IdentitySessionAuthentication

        before_action :require_same_origin!, only: %i[create destroy]
        before_action :authenticate_identity_session!, only: %i[show destroy]
        before_action :verify_identity_csrf!, only: :destroy

        def create
          result = IdentityComposition.sign_in_use_case.call(
            organization_id: params[:organization_id],
            username: params[:username],
            password: params[:password]
          )
          return render_authentication_failure unless result.issued_session

          issued = result.issued_session
          cookies[identity_session_cookie_name] = cookie_options.merge(value: issued.cookie_value)
          render json: session_payload(issued.actor, issued.csrf_token), status: :created
        end

        def show
          request_record = Identity::Application::Contracts::AuthorizationRequest.new(
            action: Identity::Application::UseCases::Authorize::SELF_SESSION_READ,
            organization_id: current_actor.organization_id,
            branch_id: nil,
            resource_owner_user_id: current_actor.user_id
          )
          return head :forbidden unless IdentityComposition.authorization_use_case.call(
            actor: current_actor,
            request: request_record
          )

          render json: session_payload(current_actor, nil)
        end

        def destroy
          IdentityComposition.sign_out_use_case.call(
            cookie_value: cookies[identity_session_cookie_name]
          )
          cookies.delete(identity_session_cookie_name, cookie_options.except(:value, :expires))
          head :no_content
        end

        private

        def cookie_options
          {
            secure: Rails.env.production?,
            httponly: true,
            same_site: :lax,
            path: "/",
            expires: 12.hours.from_now
          }
        end

        def session_payload(actor, csrf_token)
          payload = {
            session: {
              user_id: actor.user_id,
              organization_id: actor.organization_id
            }
          }
          payload[:session][:csrf_token] = csrf_token if csrf_token
          payload
        end
      end
    end
  end
end
