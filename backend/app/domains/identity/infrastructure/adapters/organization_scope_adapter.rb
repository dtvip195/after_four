module Identity
  module Infrastructure
    module Adapters
      class OrganizationScopeAdapter
        include Application::Ports::OrganizationScope

        IdentityContracts = Application::Contracts
        OrganizationContracts = Organization::Application::Contracts
        Result = IdentityContracts::OrganizationScopeResult

        def initialize(organization_query:)
          @organization_query = organization_query
        end

        def call(identity_brand_reference)
          return Result.invalid unless identity_brand_reference.is_a?(IdentityContracts::IdentityBrandReference)

          organization_brand_reference = OrganizationContracts::BrandReference.new(identity_brand_reference.value)
          organization_result = organization_query.call(organization_brand_reference)
          map_result(organization_result, identity_brand_reference)
        rescue StandardError
          raise Application::Errors::UnexpectedFailure,
            Application::Errors::UnexpectedFailure::MESSAGE,
            [],
            cause: nil
        end

        private

        attr_reader :organization_query

        def map_result(organization_result, requested_brand)
          unless organization_result.is_a?(OrganizationContracts::ResolveBrandAncestryResult)
            return Result.inconsistent
          end

          return map_resolved(organization_result.ancestry, requested_brand) if organization_result.resolved?
          return Result.not_found if organization_result.not_found?
          return Result.invalid if organization_result.invalid?
          return Result.inconsistent if organization_result.inconsistent?
          return map_unavailable(organization_result.failure_reference) if organization_result.unavailable?

          Result.inconsistent
        end

        def map_resolved(ancestry, requested_brand)
          return Result.inconsistent unless ancestry.is_a?(OrganizationContracts::BrandAncestry)
          return Result.inconsistent unless valid_organization_ancestry?(ancestry, requested_brand)

          evidence = IdentityContracts::OrganizationScopeEvidence.new(
            brand_id: IdentityContracts::IdentityBrandReference.new(ancestry.brand_id.value),
            organization_id: IdentityContracts::IdentityOrganizationReference.new(ancestry.organization_id.value)
          )
          Result.resolved(evidence)
        end

        def valid_organization_ancestry?(ancestry, requested_brand)
          ancestry.brand_id.is_a?(OrganizationContracts::BrandReference) &&
            ancestry.brand_id.value == requested_brand.value &&
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
