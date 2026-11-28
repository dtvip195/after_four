module Identity
  module Application
    module UseCases
      class AuthorizeBusinessOperation
        Contracts = Application::Contracts
        Ports = Application::Ports
        Policy = Domain::Policies::PosCapabilityPolicy
        Roles = Domain::ValueObjects::RoleCode
        Result = Contracts::BusinessAuthorizationResult

        def initialize(
          branch_scope:,
          role_assignment_reader:,
          user_employee_link_reader:,
          employee_branch_scope:,
          session_mfa_assurance:,
          clock:,
          policy: Policy.new
        )
          @branch_scope = branch_scope
          @role_assignment_reader = role_assignment_reader
          @user_employee_link_reader = user_employee_link_reader
          @employee_branch_scope = employee_branch_scope
          @session_mfa_assurance = session_mfa_assurance
          @clock = clock
          @policy = policy
        end

        def call(context:, request:)
          return Result.denied(:authority_absent) unless valid_request_context?(context, request)

          evaluated_at = clock.call
          return Result.dependency_unavailable unless evaluated_at.instance_of?(Time)

          branch_evidence = resolve_branch(request, context)
          return branch_evidence if branch_evidence.is_a?(Result)

          role_evidence = resolve_role(context, request, evaluated_at)
          return role_evidence if role_evidence.is_a?(Result)

          authorize_role(
            role_evidence: role_evidence,
            branch_evidence: branch_evidence,
            context: context,
            request: request,
            evaluated_at: evaluated_at
          )
        rescue StandardError, NotImplementedError
          raise Errors::UnexpectedFailure, Errors::UnexpectedFailure::MESSAGE, [], cause: nil
        end

        private

        attr_reader :branch_scope, :role_assignment_reader, :user_employee_link_reader,
          :employee_branch_scope, :session_mfa_assurance, :clock, :policy

        def valid_request_context?(context, request)
          Contracts::TrustedAuthorizationContext.trusted?(context) &&
            request.is_a?(Contracts::BusinessAuthorizationRequest) &&
            request.context.equal?(context)
        end

        def resolve_branch(request, context)
          result = branch_scope.call(request.branch_id)
          return Result.dependency_unavailable if valid_branch_result?(result) && result.unavailable?
          return Result.denied(:organization_scope_denied) unless valid_branch_result?(result) && result.resolved?

          evidence = result.evidence
          return Result.denied(:organization_scope_denied) unless valid_branch_evidence?(evidence, request, context)

          evidence
        end

        def valid_branch_result?(result)
          result.is_a?(Contracts::BranchScopeResult)
        end

        def valid_branch_evidence?(evidence, request, context)
          evidence.is_a?(Contracts::BranchScopeEvidence) &&
            evidence.branch_id == request.branch_id &&
            evidence.organization_id.value == context.organization_id &&
            (request.resource_branch_id.nil? || request.resource_branch_id == evidence.branch_id)
        end

        def resolve_role(context, request, evaluated_at)
          result = role_assignment_reader.call(
            user_id: context.user_id,
            organization_id: context.organization_id,
            branch_id: request.branch_id.value,
            evaluated_at: evaluated_at
          )
          return Result.dependency_unavailable if role_result?(result) && result.unavailable?
          return Result.denied(:authority_absent) unless role_result?(result) && result.found?
          return Result.denied(:authority_absent) unless valid_role_evidence?(result.evidence, context, request, evaluated_at)

          result.evidence
        end

        def role_result?(result)
          result.is_a?(Ports::RoleAssignmentReader::Result)
        end

        def valid_role_evidence?(evidence, context, request, evaluated_at)
          return false unless evidence.is_a?(Contracts::RoleAssignmentEvidence)
          return false unless evidence.user_id == context.user_id
          return false unless evidence.organization_id == context.organization_id
          return false unless evidence.effective_at?(evaluated_at)

          if Roles::OWNER.equal?(evidence.role_code)
            evidence.organization_scoped?
          else
            evidence.branch_scoped? && evidence.branch_id == request.branch_id.value
          end
        end

        def authorize_role(role_evidence:, branch_evidence:, context:, request:, evaluated_at:)
          if Roles::OWNER.equal?(role_evidence.role_code)
            return policy_result(
              role_evidence: role_evidence,
              branch_evidence: branch_evidence,
              context: context,
              request: request,
              evaluated_at: evaluated_at,
              scope: Policy::ORGANIZATION_SCOPE,
              employee_id: nil,
              assurance_reference: nil,
              session_mfa_satisfied: false
            )
          end

          assurance_reference = resolve_manager_assurance(role_evidence, context, request, evaluated_at)
          return assurance_reference if assurance_reference.is_a?(Result)

          employee_id = resolve_employee(context, request, evaluated_at)
          return employee_id if employee_id.is_a?(Result)

          policy_result(
            role_evidence: role_evidence,
            branch_evidence: branch_evidence,
            context: context,
            request: request,
            evaluated_at: evaluated_at,
            scope: Policy::EXACT_BRANCH_SCOPE,
            employee_id: employee_id,
            assurance_reference: assurance_reference,
            session_mfa_satisfied: !assurance_reference.nil?
          )
        end

        def resolve_manager_assurance(role_evidence, context, request, evaluated_at)
          return nil unless Roles::BRANCH_MANAGER.equal?(role_evidence.role_code)

          result = session_mfa_assurance.call(
            user_id: context.user_id,
            session_id: context.session_id,
            organization_id: context.organization_id,
            branch_id: request.branch_id.value,
            evaluated_at: evaluated_at
          )
          return Result.dependency_unavailable if mfa_result?(result) && result.unavailable?
          return Result.denied(:assurance_insufficient) unless mfa_result?(result) && result.satisfied?
          return Result.denied(:assurance_insufficient) unless valid_mfa_evidence?(result.evidence, context)

          result.evidence.assurance_reference
        end

        def mfa_result?(result)
          result.is_a?(Ports::SessionMfaAssurance::Result)
        end

        def valid_mfa_evidence?(evidence, context)
          evidence.is_a?(Contracts::SessionMfaAssuranceEvidence) && evidence.session_id == context.session_id
        end

        def resolve_employee(context, request, evaluated_at)
          link_result = user_employee_link_reader.call(
            user_id: context.user_id,
            organization_id: context.organization_id,
            evaluated_at: evaluated_at
          )
          return Result.dependency_unavailable if link_result?(link_result) && link_result.unavailable?
          return Result.denied(:workforce_ineligible) unless link_result?(link_result) && link_result.found?

          link = link_result.evidence
          return Result.denied(:workforce_ineligible) unless valid_link?(link, context, evaluated_at)

          workforce_result = employee_branch_scope.call(
            employee_id: link.employee_id,
            organization_id: context.organization_id,
            branch_id: request.branch_id.value,
            evaluated_at: evaluated_at
          )
          return Result.dependency_unavailable if workforce_result?(workforce_result) && workforce_result.unavailable?
          unless workforce_result?(workforce_result) && workforce_result.effective? &&
              valid_workforce_evidence?(workforce_result.evidence, link, context, request)
            return Result.denied(:workforce_ineligible)
          end

          link.employee_id
        end

        def link_result?(result)
          result.is_a?(Ports::UserEmployeeLinkReader::Result)
        end

        def valid_link?(link, context, evaluated_at)
          link.is_a?(Contracts::UserEmployeeLinkEvidence) &&
            link.user_id == context.user_id &&
            link.organization_id == context.organization_id &&
            link.effective_at?(evaluated_at)
        end

        def workforce_result?(result)
          result.is_a?(Ports::EmployeeBranchScope::Result)
        end

        def valid_workforce_evidence?(evidence, link, context, request)
          evidence.is_a?(Contracts::EmployeeBranchScopeEvidence) &&
            evidence.employee_id == link.employee_id &&
            evidence.organization_id.value == context.organization_id &&
            evidence.branch_id == request.branch_id
        end

        def policy_result(
          role_evidence:,
          branch_evidence:,
          context:,
          request:,
          evaluated_at:,
          scope:,
          employee_id:,
          assurance_reference:,
          session_mfa_satisfied:
        )
          outcome = policy.evaluate(
            capability: request.capability,
            role: role_evidence.role_code,
            scope: scope,
            session_mfa_satisfied: session_mfa_satisfied,
            action_level_step_up_required: false
          )
          return Result.denied(:unsupported_capability) if outcome.equal?(Policy::DENY)
          return Result.not_implemented if outcome.equal?(Policy::NOT_IMPLEMENTED)
          return Result.denied(:unsupported_capability) unless outcome.equal?(Policy::ALLOW_IN_POLICY)

          authorization = Contracts::BusinessAuthorization.__send__(
            :issue,
            user_id: context.user_id,
            session_id: context.session_id,
            organization_id: branch_evidence.organization_id.value,
            branch_id: branch_evidence.branch_id.value,
            capability: request.capability,
            authority_kind: role_evidence.role_code.value.to_sym,
            role_assignment_id: role_evidence.id,
            employee_id: employee_id,
            evaluated_at: evaluated_at,
            assurance_reference: assurance_reference,
            correlation_reference: request.correlation_reference
          )
          Result.allowed(authorization)
        end
      end
    end
  end
end
