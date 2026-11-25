module Identity
  module Application
    module UseCases
      class Authorize
        SELF_SESSION_READ = "identity.session.read_self"

        def call(actor:, request:)
          return false unless actor.is_a?(Contracts::AuthenticatedActor)
          return false unless request.is_a?(Contracts::AuthorizationRequest)
          return false unless actor.organization_id == request.organization_id

          request.action == SELF_SESSION_READ &&
            request.branch_id.nil? &&
            actor.user_id == request.resource_owner_user_id
        end
      end
    end
  end
end
