module Identity
  module Infrastructure
    module Adapters
      class OrganizationBranchScopeAdapter
        include Application::Ports::BranchScope

        IdentityContracts = Application::Contracts
        OrganizationContracts = Organization::Application::Contracts
        Result = IdentityContracts::BranchScopeResult

        def initialize(organization_query:)
          @organization_query = organization_query
        end

        def call(identity_branch_reference)
          return Result.invalid unless identity_branch_reference.is_a?(IdentityContracts::IdentityBranchReference)

          organization_branch_reference = OrganizationContracts::BranchReference.new(identity_branch_reference.value)
          organization_result = organization_query.call(organization_branch_reference)
          map_result(organization_result, identity_branch_reference)
        rescue StandardError
          raise Application::Errors::UnexpectedFailure,
            Application::Errors::UnexpectedFailure::MESSAGE,
            [],
            cause: nil
        end

        private

        attr_reader :organization_query

        def map_result(organization_result, requested_branch)
          unless organization_result.is_a?(OrganizationContracts::ResolveBranchAncestryResult)
            return Result.inconsistent
          end

          return map_resolved(organization_result.ancestry, requested_branch) if organization_result.resolved?
          return Result.not_found if organization_result.not_found?
          return Result.invalid if organization_result.invalid?
          return Result.inconsistent if organization_result.inconsistent?
          return map_unavailable(organization_result.failure_reference) if organization_result.unavailable?

          Result.inconsistent
        end

        def map_resolved(ancestry, requested_branch)
          return Result.inconsistent unless ancestry.is_a?(OrganizationContracts::BranchAncestry)
          return Result.inconsistent unless valid_organization_ancestry?(ancestry, requested_branch)

          evidence = IdentityContracts::BranchScopeEvidence.new(
            branch_id: IdentityContracts::IdentityBranchReference.new(ancestry.branch_id.value),
            brand_id: IdentityContracts::IdentityBrandReference.new(ancestry.brand_id.value),
            organization_id: IdentityContracts::IdentityOrganizationReference.new(ancestry.organization_id.value)
          )
          Result.resolved(evidence)
        end

        def valid_organization_ancestry?(ancestry, requested_branch)
          ancestry.branch_id.is_a?(OrganizationContracts::BranchReference) &&
            ancestry.branch_id.value == requested_branch.value &&
            ancestry.brand_id.is_a?(OrganizationContracts::BrandReference) &&
            IdentityContracts::IdentityBrandReference.valid_value?(ancestry.brand_id.value) &&
            ancestry.organization_id.is_a?(OrganizationContracts::OrganizationReference) &&
            IdentityContracts::IdentityOrganizationReference.valid_value?(ancestry.organization_id.value)
        end

        def map_unavailable(failure_reference)
          return Result.inconsistent unless failure_reference.is_a?(OrganizationContracts::SafeFailureReference)
          return Result.inconsistent unless IdentityContracts::SafeFailureReference.valid_value?(failure_reference.value)

          identity_reference = IdentityContracts::SafeFailureReference.new(failure_reference.value)
          Result.unavailable(identity_reference)
        end
      end
    end
  end
end
