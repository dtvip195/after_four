require "rails_helper"

RSpec.describe Identity::Application::UseCases::AuthorizeBusinessOperation do
  TestReader = Struct.new(:result, :calls) do
    def initialize(result)
      super(result, [])
    end
  end

  TestCallRecorder = Module.new do
    def call(*positional, **keywords)
      calls << { positional: positional, keywords: keywords }
      result
    end
  end

  TestRoleAssignmentReader = Class.new(TestReader) do
    include Identity::Application::Ports::RoleAssignmentReader
    include TestCallRecorder
  end
  TestUserEmployeeLinkReader = Class.new(TestReader) do
    include Identity::Application::Ports::UserEmployeeLinkReader
    include TestCallRecorder
  end
  TestEmployeeBranchScope = Class.new(TestReader) do
    include Identity::Application::Ports::EmployeeBranchScope
    include TestCallRecorder
  end
  TestSessionMfaAssurance = Class.new(TestReader) do
    include Identity::Application::Ports::SessionMfaAssurance
    include TestCallRecorder
  end
  TestBranchScope = Class.new(TestReader) do
    include Identity::Application::Ports::BranchScope
    include TestCallRecorder
  end

  let(:user_id) { uuid(1) }
  let(:session_id) { uuid(2) }
  let(:organization_id) { uuid(3) }
  let(:branch_id) { uuid(4) }
  let(:employee_id) { uuid(5) }
  let(:assignment_id) { uuid(6) }
  let(:link_id) { uuid(7) }
  let(:evaluation_time) { Time.utc(2026, 11, 28, 8, 0, 0) }
  let(:actor) do
    Identity::Application::Contracts::AuthenticatedActor.new(
      user_id: user_id,
      organization_id: organization_id,
      session_id: session_id
    )
  end
  let(:context) do
    Identity::Application::Contracts::TrustedAuthorizationContext
      .__send__(:issue_from_verified_actor, actor)
  end
  let(:request) do
    Identity::Application::Contracts::BusinessAuthorizationRequest.new(
      context: context,
      capability: capability,
      branch_id: Identity::Application::Contracts::IdentityBranchReference.new(branch_id),
      resource_branch_id: nil,
      correlation_reference: safe_reference(20)
    )
  end
  let(:capability) { Identity::Domain::ValueObjects::PosCapability::ORDERS_CREATE }
  let(:branch_result) { resolved_branch_scope }
  let(:role_result) { role_result_for(Identity::Domain::ValueObjects::RoleCode::OWNER) }
  let(:link_result) { user_link_result }
  let(:workforce_result) { employee_scope_result }
  let(:mfa_result) { session_mfa_result }
  let(:branch_reader) { TestBranchScope.new(branch_result) }
  let(:role_reader) { TestRoleAssignmentReader.new(role_result) }
  let(:link_reader) { TestUserEmployeeLinkReader.new(link_result) }
  let(:workforce_reader) { TestEmployeeBranchScope.new(workforce_result) }
  let(:mfa_reader) { TestSessionMfaAssurance.new(mfa_result) }
  let(:use_case) do
    described_class.new(
      branch_scope: branch_reader,
      role_assignment_reader: role_reader,
      user_employee_link_reader: link_reader,
      employee_branch_scope: workforce_reader,
      session_mfa_assurance: mfa_reader,
      clock: -> { evaluation_time }
    )
  end

  it "allows effective Organization Owner authority without Employee or MFA evidence" do
    result = use_case.call(context: context, request: request)

    expect(result).to be_allowed
    expect(result.authorization.user_id).to eq(user_id)
    expect(result.authorization.session_id).to eq(session_id)
    expect(result.authorization.organization_id).to eq(organization_id)
    expect(result.authorization.branch_id).to eq(branch_id)
    expect(result.authorization.capability).to equal(capability)
    expect(result.authorization.authority_kind).to eq(:owner)
    expect(result.authorization.evaluated_at).to eq(evaluation_time)
    expect(result.authorization).to be_frozen
    expect(link_reader.calls).to be_empty
    expect(workforce_reader.calls).to be_empty
    expect(mfa_reader.calls).to be_empty
  end

  it "allows Staff only with effective link and exact-Branch Workforce evidence" do
    allow(self).to receive(:role_result).and_return(
      role_result_for(Identity::Domain::ValueObjects::RoleCode::STAFF)
    )

    result = use_case.call(context: context, request: request)

    expect(result).to be_allowed
    expect(result.authorization.authority_kind).to eq(:staff)
    expect(result.authorization.employee_id).to eq(employee_id)
    expect(result.authorization.assurance_reference).to be_nil
    expect(mfa_reader.calls).to be_empty
    expect(link_reader.calls.length).to eq(1)
    expect(workforce_reader.calls.length).to eq(1)
  end

  it "requires Session MFA for Branch Manager and preserves its safe evidence reference" do
    allow(self).to receive(:role_result).and_return(
      role_result_for(Identity::Domain::ValueObjects::RoleCode::BRANCH_MANAGER)
    )

    result = use_case.call(context: context, request: request)

    expect(result).to be_allowed
    expect(result.authorization.authority_kind).to eq(:branch_manager)
    expect(result.authorization.assurance_reference).to eq(safe_reference(13))
    expect(mfa_reader.calls.length).to eq(1)

    mfa_reader.result = Identity::Application::Ports::SessionMfaAssurance::Result.insufficient
    denied = use_case.call(context: context, request: request)

    expect(denied).to be_denied
    expect(denied.reason).to eq(:assurance_insufficient)
  end

  it "denies Staff access to manager-only capabilities" do
    allow(self).to receive(:role_result).and_return(
      role_result_for(Identity::Domain::ValueObjects::RoleCode::STAFF)
    )
    allow(self).to receive(:capability).and_return(
      Identity::Domain::ValueObjects::PosCapability::PAYMENTS_REVIEW_READ
    )

    result = use_case.call(context: context, request: request)

    expect(result).to be_denied
    expect(result.reason).to eq(:unsupported_capability)
    expect(result.authorization).to be_nil
  end

  it "fails closed for wrong Organization, wrong resource Branch, and absent authority" do
    wrong_organization = Identity::Application::Contracts::BranchScopeEvidence.new(
      branch_id: Identity::Application::Contracts::IdentityBranchReference.new(branch_id),
      brand_id: Identity::Application::Contracts::IdentityBrandReference.new(uuid(30)),
      organization_id: Identity::Application::Contracts::IdentityOrganizationReference.new(uuid(31))
    )
    allow(self).to receive(:branch_result).and_return(
      Identity::Application::Contracts::BranchScopeResult.resolved(wrong_organization)
    )

    wrong_org_result = use_case.call(context: context, request: request)
    expect(wrong_org_result).to be_denied
    expect(wrong_org_result.reason).to eq(:organization_scope_denied)

    branch_reader.result = resolved_branch_scope
    mismatched_request = Identity::Application::Contracts::BusinessAuthorizationRequest.new(
      context: context,
      capability: capability,
      branch_id: Identity::Application::Contracts::IdentityBranchReference.new(branch_id),
      resource_branch_id: Identity::Application::Contracts::IdentityBranchReference.new(uuid(32)),
      correlation_reference: safe_reference(20)
    )
    wrong_resource = use_case.call(context: context, request: mismatched_request)
    expect(wrong_resource).to be_denied
    expect(wrong_resource.reason).to eq(:organization_scope_denied)

    role_reader.result = Identity::Application::Ports::RoleAssignmentReader::Result.absent
    absent = use_case.call(context: context, request: request)
    expect(absent).to be_denied
    expect(absent.reason).to eq(:authority_absent)
  end

  it "fails closed when link or exact-Branch Workforce eligibility is absent" do
    allow(self).to receive(:role_result).and_return(
      role_result_for(Identity::Domain::ValueObjects::RoleCode::STAFF)
    )
    allow(self).to receive(:link_result).and_return(
      Identity::Application::Ports::UserEmployeeLinkReader::Result.absent
    )

    missing_link = use_case.call(context: context, request: request)
    expect(missing_link).to be_denied
    expect(missing_link.reason).to eq(:workforce_ineligible)

    link_reader.result = user_link_result
    workforce_reader.result = Identity::Application::Ports::EmployeeBranchScope::Result.not_effective
    missing_assignment = use_case.call(context: context, request: request)
    expect(missing_assignment).to be_denied
    expect(missing_assignment.reason).to eq(:workforce_ineligible)
  end

  it "returns a non-disclosing dependency result for unavailable evidence" do
    branch_reader.result = Identity::Application::Contracts::BranchScopeResult.unavailable(safe_reference(40))
    branch_unavailable = use_case.call(context: context, request: request)

    expect(branch_unavailable).to be_dependency_unavailable
    expect(branch_unavailable.reason).to eq(:dependency_unavailable)
    expect(branch_unavailable.authorization).to be_nil

    branch_reader.result = resolved_branch_scope
    role_reader.result = Identity::Application::Ports::RoleAssignmentReader::Result.unavailable(safe_reference(41))
    role_unavailable = use_case.call(context: context, request: request)

    expect(role_unavailable).to be_dependency_unavailable
    expect(role_unavailable.reason).to eq(:dependency_unavailable)
    expect(role_unavailable.authorization).to be_nil
  end

  it "maps every deferred evidence outage to dependency_unavailable" do
    role_reader.result = role_result_for(Identity::Domain::ValueObjects::RoleCode::BRANCH_MANAGER)
    mfa_reader.result = Identity::Application::Ports::SessionMfaAssurance::Result.unavailable(safe_reference(42))
    expect(use_case.call(context: context, request: request)).to be_dependency_unavailable

    role_reader.result = role_result_for(Identity::Domain::ValueObjects::RoleCode::STAFF)
    mfa_reader.result = session_mfa_result
    link_reader.result = Identity::Application::Ports::UserEmployeeLinkReader::Result.unavailable(safe_reference(43))
    expect(use_case.call(context: context, request: request)).to be_dependency_unavailable

    link_reader.result = user_link_result
    workforce_reader.result = Identity::Application::Ports::EmployeeBranchScope::Result.unavailable(safe_reference(44))
    expect(use_case.call(context: context, request: request)).to be_dependency_unavailable
  end

  it "denies inconsistent, expired, mismatched, and unknown completed evidence" do
    role_reader.result = Identity::Application::Ports::RoleAssignmentReader::Result.inconsistent
    expect(use_case.call(context: context, request: request).reason).to eq(:authority_absent)

    expired_assignment = Identity::Domain::Entities::RoleAssignment.new(
      id: assignment_id,
      user_id: user_id,
      organization_id: organization_id,
      branch_id: branch_id,
      role_code: Identity::Domain::ValueObjects::RoleCode::STAFF,
      effective_from: evaluation_time - 120,
      effective_until: evaluation_time - 60
    )
    role_reader.result = Identity::Application::Ports::RoleAssignmentReader::Result.found(
      Identity::Application::Contracts::RoleAssignmentEvidence.new(assignment: expired_assignment)
    )
    expect(use_case.call(context: context, request: request).reason).to eq(:authority_absent)

    role_reader.result = role_result_for(Identity::Domain::ValueObjects::RoleCode::STAFF)
    link_reader.result = Object.new
    expect(use_case.call(context: context, request: request).reason).to eq(:workforce_ineligible)

    link_reader.result = user_link_result
    workforce_reader.result = Identity::Application::Ports::EmployeeBranchScope::Result.inconsistent
    expect(use_case.call(context: context, request: request).reason).to eq(:workforce_ineligible)
  end

  it "denies future, cross-Branch, cross-Organization, and malformed positive evidence" do
    future_assignment = Identity::Domain::Entities::RoleAssignment.new(
      id: assignment_id,
      user_id: user_id,
      organization_id: organization_id,
      branch_id: branch_id,
      role_code: Identity::Domain::ValueObjects::RoleCode::STAFF,
      effective_from: evaluation_time + 60,
      effective_until: evaluation_time + 120
    )
    role_reader.result = Identity::Application::Ports::RoleAssignmentReader::Result.found(
      Identity::Application::Contracts::RoleAssignmentEvidence.new(assignment: future_assignment)
    )
    expect(use_case.call(context: context, request: request).reason).to eq(:authority_absent)

    cross_branch_assignment = Identity::Domain::Entities::RoleAssignment.new(
      id: assignment_id,
      user_id: user_id,
      organization_id: organization_id,
      branch_id: uuid(50),
      role_code: Identity::Domain::ValueObjects::RoleCode::STAFF,
      effective_from: evaluation_time - 60,
      effective_until: evaluation_time + 60
    )
    role_reader.result = Identity::Application::Ports::RoleAssignmentReader::Result.found(
      Identity::Application::Contracts::RoleAssignmentEvidence.new(assignment: cross_branch_assignment)
    )
    expect(use_case.call(context: context, request: request).reason).to eq(:authority_absent)

    role_reader.result = role_result_for(Identity::Domain::ValueObjects::RoleCode::STAFF)
    cross_organization_link = Identity::Domain::Entities::UserEmployeeLink.new(
      id: link_id,
      user_id: user_id,
      employee_id: employee_id,
      organization_id: uuid(51),
      effective_from: evaluation_time - 60,
      effective_until: evaluation_time + 60
    )
    link_reader.result = Identity::Application::Ports::UserEmployeeLinkReader::Result.found(
      Identity::Application::Contracts::UserEmployeeLinkEvidence.new(link: cross_organization_link)
    )
    expect(use_case.call(context: context, request: request).reason).to eq(:workforce_ineligible)

    link_reader.result = user_link_result
    mismatched_scope = Identity::Application::Contracts::EmployeeBranchScopeEvidence.new(
      employee_id: employee_id,
      organization_id: Identity::Application::Contracts::IdentityOrganizationReference.new(organization_id),
      branch_id: Identity::Application::Contracts::IdentityBranchReference.new(uuid(52)),
      assignment_reference: safe_reference(53)
    )
    workforce_reader.result = Identity::Application::Ports::EmployeeBranchScope::Result.effective(mismatched_scope)
    expect(use_case.call(context: context, request: request).reason).to eq(:workforce_ineligible)
  end

  it "sanitizes unexpected Adapter defects instead of treating them as normal denials" do
    source_message = "protected authorization evidence password=do-not-leak"
    allow(branch_reader).to receive(:call).and_raise(NoMethodError, source_message)

    expect do
      use_case.call(context: context, request: request)
    end.to raise_error(Identity::Application::Errors::UnexpectedFailure) { |error|
      expect(error.message).to eq("Identity organization scope resolution terminated unexpectedly")
      expect(error.cause).to be_nil
      expect(error.backtrace).to eq([])
      expect(error.full_message).not_to include(source_message)
    }
  end

  it "rejects untrusted, mismatched, and client-shaped contexts before evidence lookup" do
    plausible_context = Data.define(:user_id, :organization_id, :session_id).new(
      user_id: user_id, organization_id: organization_id, session_id: session_id
    )

    expect(use_case.call(context: plausible_context, request: request)).to be_denied

    other_context = Identity::Application::Contracts::TrustedAuthorizationContext.__send__(
      :issue_from_verified_actor,
      Identity::Application::Contracts::AuthenticatedActor.new(
        user_id: user_id, organization_id: organization_id, session_id: session_id
      )
    )
    expect(use_case.call(context: other_context, request: request)).to be_denied
    expect(branch_reader.calls).to be_empty
  end

  it "keeps authorization construction private and request inputs strongly typed" do
    authorization_class = Identity::Application::Contracts::BusinessAuthorization

    expect { authorization_class.new }.to raise_error(NoMethodError)
    expect do
      Identity::Application::Contracts::BusinessAuthorizationRequest.new(
        context: context,
        capability: capability.value,
        branch_id: branch_id,
        resource_branch_id: nil,
        correlation_reference: safe_reference(20)
      )
    end.to raise_error(ArgumentError)

    expect do
      Identity::Application::Contracts::EmployeeBranchScopeEvidence.new(
        employee_id: employee_id,
        organization_id: organization_id,
        branch_id: branch_id,
        assignment_reference: safe_reference(21)
      )
    end.to raise_error(ArgumentError, "organization_id must be an IdentityOrganizationReference")
  end

  def resolved_branch_scope
    evidence = Identity::Application::Contracts::BranchScopeEvidence.new(
      branch_id: Identity::Application::Contracts::IdentityBranchReference.new(branch_id),
      brand_id: Identity::Application::Contracts::IdentityBrandReference.new(uuid(8)),
      organization_id: Identity::Application::Contracts::IdentityOrganizationReference.new(organization_id)
    )
    Identity::Application::Contracts::BranchScopeResult.resolved(evidence)
  end

  def role_result_for(role_code)
    branch = role_code.equal?(Identity::Domain::ValueObjects::RoleCode::OWNER) ? nil : branch_id
    assignment = Identity::Domain::Entities::RoleAssignment.new(
      id: assignment_id,
      user_id: user_id,
      organization_id: organization_id,
      branch_id: branch,
      role_code: role_code,
      effective_from: evaluation_time - 60,
      effective_until: evaluation_time + 60
    )
    evidence = Identity::Application::Contracts::RoleAssignmentEvidence.new(assignment: assignment)
    Identity::Application::Ports::RoleAssignmentReader::Result.found(evidence)
  end

  def user_link_result
    link = Identity::Domain::Entities::UserEmployeeLink.new(
      id: link_id,
      user_id: user_id,
      employee_id: employee_id,
      organization_id: organization_id,
      effective_from: evaluation_time - 60,
      effective_until: evaluation_time + 60
    )
    evidence = Identity::Application::Contracts::UserEmployeeLinkEvidence.new(link: link)
    Identity::Application::Ports::UserEmployeeLinkReader::Result.found(evidence)
  end

  def employee_scope_result
    evidence = Identity::Application::Contracts::EmployeeBranchScopeEvidence.new(
      employee_id: employee_id,
      organization_id: Identity::Application::Contracts::IdentityOrganizationReference.new(organization_id),
      branch_id: Identity::Application::Contracts::IdentityBranchReference.new(branch_id),
      assignment_reference: safe_reference(12)
    )
    Identity::Application::Ports::EmployeeBranchScope::Result.effective(evidence)
  end

  def session_mfa_result
    evidence = Identity::Application::Contracts::SessionMfaAssuranceEvidence.new(
      session_id: session_id,
      assurance_reference: safe_reference(13)
    )
    Identity::Application::Ports::SessionMfaAssurance::Result.satisfied(evidence)
  end

  def safe_reference(number)
    Identity::Application::Contracts::SafeFailureReference.new(uuid(number))
  end

  def uuid(number)
    format("%08d-0000-0000-0000-%012d", number, number)
  end
end
