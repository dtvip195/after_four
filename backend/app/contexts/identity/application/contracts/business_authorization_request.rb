module Identity
  module Application
    module Contracts
      class BusinessAuthorizationRequest
        attr_reader :context, :capability, :branch_id, :resource_branch_id, :correlation_reference

        def initialize(context:, capability:, branch_id:, resource_branch_id:, correlation_reference:)
          unless TrustedAuthorizationContext.trusted?(context)
            raise ArgumentError, "context must be a trusted authorization context"
          end
          unless Domain::ValueObjects::PosCapability.registered?(capability)
            raise ArgumentError, "capability must be a registered PosCapability"
          end
          unless branch_id.is_a?(IdentityBranchReference)
            raise ArgumentError, "branch_id must be an IdentityBranchReference"
          end
          unless resource_branch_id.nil? || resource_branch_id.is_a?(IdentityBranchReference)
            raise ArgumentError, "resource_branch_id must be an IdentityBranchReference or nil"
          end
          unless correlation_reference.is_a?(SafeFailureReference)
            raise ArgumentError, "correlation_reference must be a SafeFailureReference"
          end

          @context = context
          @capability = capability
          @branch_id = branch_id
          @resource_branch_id = resource_branch_id
          @correlation_reference = correlation_reference
          freeze
        end
      end
    end
  end
end
