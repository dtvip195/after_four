---
status: proposed
date: 2026-11-14
---

# ADR-0006: Server-side authentication and session topology

**Status:** Proposed

## Context

AFTER FOUR is a first-party browser application for an internal, multi-Branch cafe chain. It needs individual accountability, immediate revocation, server-side Branch authorization, and protection against credential and session leakage. The Rails application is API-only and currently has no cookie/session middleware, authentication, authorization, credential storage, or persisted audit log. Production HTTPS and sensitive-parameter filtering are configured, while CORS is disabled. Production origin and implementation controls are not yet security-approved.

The canonical model distinguishes a User authentication identity from an Employee employment record and distinguishes effective Role Assignments from Employee Branch Assignments. Authorized delegation is a third, separate concept and does not grant a role or Branch assignment. On 2026-11-14 the Owner confirmed the twenty-eight policies recorded in the [Identity Decision Register](../after_four_identity_decision_register.md). ID-01 through ID-19 cover active role vocabulary Owner/Branch Manager/Staff, individual POS PINs, privileged MFA, session policies, invitation-only accounts, Owner approval for every role/Branch change, username login, Branch Manager capability boundaries, invitation delegation, account lifecycle authority, Owner recovery principles, production topology, audit classes and access, and the absence of a numeric MVP session cap. ID-20 selects Owner-led technical/security review with explicit residual-risk acceptance and no planned external professional/legal review. IDs 21–28 close password/PIN policy boundaries while retaining compatibility, benchmark, exact online-control, secret-custody, transaction, and executed-evidence gates. IDs 29–34 separately approve the P64-4 production-parity password candidate and scoped hashing-admission, resource-method, parallelism-validation, capacity-exhaustion, and revalidation directions; they do not approve a production/PIN profile, a numeric limit, implementation, production use, or residual risk. The later [Package C0 decisions](../after_four_owner_decision_baseline.md#package-c0-lifecycle-authority-and-prerequisite-decisions) separately confirm Brand-scoped, capability-specific Catalog lifecycle delegation and a trusted fail-closed AuthorizationContext without expanding ID-14 invitation delegation. Regional Manager remains reserved and inactive.

## Decision

Production uses one HTTPS origin, with the frontend and `/api/v1` routed through one managed edge and the Rails origin kept private. CORS is absent by default, trusted proxies are explicit, Host Authorization remains enabled and configured, and health responses reveal no sensitive infrastructure detail. The hosting, domain, DNS, edge vendor, exact proxy chain, network/private-connectivity design, operational ownership, and health monitoring remain unselected and subject to deployment or security review.

Subject to the approval gates below, use opaque, revocable server-side sessions carried only in a host-only `Secure`, `HttpOnly`, `SameSite=Lax` cookie. Prefer a `__Host-` cookie name, set `Path=/`, omit `Domain`, and never place identity, role, Branch, or secret material in the cookie. Persist only a one-way verifier for the random session secret. Rotate the secret on login, recovery, credential change, MFA change, and privilege-sensitive change.

Enforce idle and absolute expiration on the server. Logout revokes the current session. Suspension, deactivation, confirmed compromise, or credential recovery revokes every session for that User in the same transaction or by a fail-closed revocation boundary. Concurrent sessions are represented independently and can be listed and revoked without exposing their raw secrets.

Unsafe cookie-authenticated requests require Rails CSRF verification plus same-origin checks. CORS remains absent for same-site deployment. A future cross-origin deployment requires an explicit origin allowlist, credential policy, and security review; wildcard credentialed CORS is forbidden.

Passwords are salted and processed by a maintained adaptive password-hashing implementation. Argon2id is the technical proposal; the algorithm, library, parameters, input limits, and operational calibration require security review. Passwords are never reversibly encrypted or logged. Every POS employee has an individual PIN; shared PINs are forbidden. A PIN is a constrained quick-authentication mechanism for an existing individual User and does not replace password/recovery/MFA for back-office or privileged actions. PIN hashing, length, retry limits, rate limiting, device controls, and recovery remain security-review details.

Authorization is deny-by-default and server-side. Policies evaluate the active authenticated User, effective Role Assignment, effective Employee Branch Assignment where required, immutable resource Organization/Branch ownership, requested capability, and any step-up requirement. The selected or actual working Branch must be within the effective scope. A client Branch ID, role label, route, or hidden control is never authority. Resource lookup is scoped before authorization to prevent IDOR and cross-Branch leakage.

The initial permission model uses Owner, Branch Manager, and Staff templates mapped to a small code-owned capability catalog. Regional Manager is reserved and inactive. It has no per-User allow/deny overrides or user-editable policy language. Role Assignment grants a capability scope; Branch Assignment proves the Employee may work at that Branch. Except for the Organization-scoped Owner rule, neither record alone grants Branch operation access. Every Role Assignment and Employee Branch Assignment change requires Owner approval.

A Branch Manager is limited to assigned Branches, uses MFA, and completes step-up authentication for sensitive capabilities. Ordinary permissions must be explicitly enumerated rather than inferred. A Branch Manager cannot elevate or assign themself, approve their own Role Assignment or Branch Assignment changes, access an unassigned Branch, perform Owner-only account or security administration, set company-wide payroll policy, or perform final payroll close. The exact ordinary/sensitive capability enumeration and authentication controls remain subject to review and cannot expand the canonical business model.

Accounts are invitation-only; only the Owner or an Owner-authorized delegate may invite an employee. Delegation is separate from Role Assignment. Only an active Branch Manager may receive authority to invite Staff, only for assigned Branches, and for no more than 90 days. A delegate cannot approve Role Assignment or Branch Assignment changes, delegate onward, or renew their own delegation. The Owner may revoke delegation at any time, which also revokes its outstanding unused invitations. Race handling and enforcement details require security review. Username is the unique login identifier; email is contact/recovery data and is not a login identifier. MFA is mandatory for the Owner and all Branch Managers. Factor technology, enrollment, verification, recovery, step-up controls, and invitation acceptance controls require security review.

Catalog lifecycle delegation is a separate confirmed authority from Staff-invitation delegation. Category and Variant authority is recorded separately in `C0-CAT-01` and `C0-CAT-02`; delegation is Brand-scoped and capability-specific under `C0-CAT-03`. Role/capability assignment, Organization/Brand Owner administration scope, self-delegation/self-approval prohibition, and effective/expiry/revocation behavior are recorded in `C0-R01`–`C0-R04`. Package C must receive the trusted server-side AuthorizationContext in `C0-R09` and fail closed when identity or delegation is missing, invalid, expired, or revoked. Archive and Restore require step-up MFA under `C0-CAT-05`, while exact freshness, assurance, session-binding, and invalidation details remain deferred under `C0-R05`. These decisions do not implement Identity, accept this ADR, or authorize Milestone 2B.

Back-office sessions enforce a 30-minute idle timeout and a 12-hour absolute lifetime. POS sessions lock after 2 minutes without activity and require individual reauthentication. A User may have sessions on multiple devices; MVP has no numeric cap. Provide session visibility, new-device notifications where appropriate, anomaly detection and revocation, and Owner-controlled all-session revocation. Reconsider a numeric cap only when operational or security-incident evidence justifies one. Session renewal, device-summary privacy, notification, anomaly detection, POS reauthentication proof, and distributed expiry/revocation behavior require security review.

Authentication failures use rate limiting and progressive delay; repeated failures alone never permanently lock the account. Authentication lock is a temporary automated control released only under an approved policy. Suspension and reactivation are Owner-controlled; reactivation requires explicit Owner authorization and audit. Deactivation is Owner-controlled, has no automatic return, and preserves Employee history, audit data, and business records. Re-employment requires explicit Owner rehire/reactivation. Owner-unavailable escalation is a separate reviewed operational procedure and does not implicitly grant a Branch Manager Owner authority.

The Owner manages employee recovery. Owner recovery is separate and must establish at least two independent factors in advance, prefer passkeys or hardware security keys where appropriate, include offline recovery material, and require two independent proofs plus dual control. A Branch Manager cannot independently recover the Owner account. Exact proofs, assurance, custodians, storage/rotation, delays/escalation, technology or provider, monitoring, audit controls, and the Owner-unavailable emergency procedure require security review. No provider is selected.

Audit policy covers Security, Account lifecycle, Authorization and assignment, Financial, HR/payroll, and Operational event classes. Read access requires explicit authorization; a User cannot modify or delete audit records of their own actions. Holds, exports, and anonymization are controlled, and the implementation must preserve integrity and accountability. No numeric retention period is approved. Database privileges and integrity evidence require security review; retention durations, visibility, recovery evidence, holds/exports, and anonymization timing require professional legal/privacy review.

## Alternatives considered

- Browser-stored bearer tokens: rejected as the default because revocation and script-access exposure are worse for a same-site browser application.
- Stateless JWT access tokens: rejected for the first slice because immediate deactivation/revocation still needs server state.
- Rails encrypted CookieStore containing authorization state: rejected because stale roles and Branch scopes would survive until cookie expiry unless every request also consulted server state.
- External identity provider: viable if Owner requirements demand federation, MFA, or managed recovery; no provider is selected.
- Role-only checks without resource scope: rejected because a role name cannot prevent cross-Branch access.
- A full authentication/RBAC suite or per-User permissions: deferred until requirements exceed Rails primitives, fixed capability codes, and explicit policy objects.

## Trade-offs

Server sessions require durable storage, cleanup, CSRF protection, and an indexed lookup on authenticated requests. They provide straightforward revocation, centralized expiration, and current authorization evaluation. Same-site deployment simplifies browser security but constrains routing. Fixed role templates are easier to audit than arbitrary grants but require a release when capability definitions change.

## Security implications

Production requires TLS, trusted-proxy configuration, cookie and CSRF controls, login/recovery/PIN rate limiting, generic public authentication errors, breached-password screening, approved MFA/recovery implementation, secure secret management, append-only audit, and tests proving offboarding and cross-Branch denial. Session and recovery tokens must have high entropy and be stored only as verifiers. Raw passwords, PINs, MFA seeds, recovery codes, session secrets, and CSRF tokens must never enter logs or audit metadata.

Development may use explicit test identities or adapters only when they cannot be enabled in production. Seeded shared production credentials are forbidden.

## Operational implications

Operators need self-service and authorized administrative session revocation, credential recovery, suspicious-login visibility, account lock/unlock procedures, security-event retention, and an incident runbook. Expiration and rate limits must use server time and work across all application processes. Background cleanup may remove expired session rows only after the audit/retention policy permits it.

## Consequences

This ADR remains **Proposed**. The Owner has confirmed all twenty-eight policies in the Identity Decision Register, including the policy boundaries for Branch Manager capabilities, invitation delegation, account lifecycle authority, Owner recovery, production topology, audit classes/access, concurrent sessions, Owner-led review governance, and password/PIN security. IDs 29–34 add six scoped Argon2 validation/admission directions. Package C0 separately confirms the scoped Catalog lifecycle authority and trusted-context requirements stated above. These decisions do not approve production parameters, exact MFA details deferred by `C0-R05`, a PIN profile, numeric resource/admission values, dependency integration, implementation, executed controls, residual risks, or legal/privacy conclusions.

The Owner must execute and record the [Owner-Led Review Protocol](../after_four_identity_owner_led_review_protocol.md) against the [Identity Security Review Checklist](../after_four_identity_security_review_checklist.md), including password/PIN controls, MFA/recovery, cookie/session/CSRF behavior, rate limiting, trusted proxies/HTTPS, audit protection, offboarding, and test evidence. Every result must state that independent verification was not performed. Owner technical-risk acceptance cannot resolve legal/privacy obligations; relevant production processing remains blocked where those obligations are unverified. The ADR cannot become Accepted until required evidence, findings/remediation or explicit permissible residual-risk decisions, production conditions, and unresolved legal blockers are truthfully recorded.

A separately recorded ADR Design Baseline Approval may support consideration of a bounded implementation while this ADR remains **Proposed**. A separate Bounded Implementation Authorization is still required before implementation begins. Neither approval changes checklist status, proves a control, accepts residual risk, authorizes production, or changes this ADR's status. Only executed Control Acceptance evidence satisfying the checklist and the conditions above can support a later ADR status review. Final Operational Acceptance remains separate.

Milestone 2B is not authorized by this ADR. The proposed model and sequencing are detailed in [Identity & Branch Authorization](../after_four_identity_authorization.md) and the [Security Threat Model](../after_four_security_threat_model.md).

## References

- [Rails Security Guide](https://guides.rubyonrails.org/security.html)
- [OWASP Authentication Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Authentication_Cheat_Sheet.html)
- [OWASP Session Management Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Session_Management_Cheat_Sheet.html)
- [OWASP Password Storage Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html)
- [NIST SP 800-63B-4: Authenticators](https://pages.nist.gov/800-63-4/sp800-63b/authenticators/)
