module Identity
  module Application
    module UseCases
      class Authorize
        def call(context:, request:)
          return false unless Contracts::TrustedAuthorizationContext.trusted?(context)
          return false unless request.is_a?(Contracts::AuthorizationRequest)
          return false unless request.capability.equal?(Contracts::CapabilityIdentifier::SESSION_READ_SELF)
          return false unless context.organization_id == request.organization_id

          request.branch_id.nil? &&
            context.user_id == request.resource_owner_user_id &&
            context.session_id == request.resource_session_id
        end
      end
    end
  end
end
