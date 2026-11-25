module Api
  module V1
    module Auth
      class SessionsController < BaseController
        include IdentitySessionAuthentication
        include Pundit::Authorization

        before_action :require_same_origin!, only: %i[create destroy]
        before_action :authenticate_identity_session!, only: %i[show destroy]
        before_action :verify_identity_csrf!, only: :destroy
        after_action :verify_authorized, only: :show, if: :current_authorization_context

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
            capability: Identity::Application::Contracts::CapabilityIdentifier::SESSION_READ_SELF,
            organization_id: current_authorization_context.organization_id,
            branch_id: nil,
            resource_owner_user_id: current_authorization_context.user_id,
            resource_session_id: current_authorization_context.session_id
          )
          authorize request_record, :show?, policy_class: Identity::SessionPolicy
          details = IdentityComposition.read_own_session_use_case.call(
            context: current_authorization_context,
            request: request_record
          )
          return head :forbidden unless details

          render json: session_payload(details, nil)
        rescue Pundit::NotAuthorizedError
          head :forbidden
        end

        def destroy
          IdentityComposition.sign_out_use_case.call(
            cookie_value: cookies[identity_session_cookie_name]
          )
          cookies.delete(identity_session_cookie_name, cookie_options.except(:value, :expires))
          head :no_content
        end

        private

        def pundit_user
          current_authorization_context
        end

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
