# AFTER FOUR Identity Decision Closure Proposals

**Status:** Seven recommendations Owner-confirmed as ID-13 through ID-19; security and legal/privacy reviews remain incomplete  
**Date:** 2026-11-14  
**Scope:** Decision record for seven formerly unresolved Identity and Security topics from Milestone 2A.1. Milestone 2B remains unauthorized.  
**Related:** [Identity Decision Register](after_four_identity_decision_register.md) · [ADR-0006](adr/0006-authentication-session-topology.md) · [Identity & Branch Authorization](after_four_identity_authorization.md) · [Threat Model](after_four_security_threat_model.md) · [Security Review Checklist](after_four_identity_security_review_checklist.md)

## 1. Decision discipline

- `OWNER_CONFIRMED` means an operating policy has explicit Owner approval. The original twelve policies remain unchanged; the seven recommendation-level outcomes in this report are now recorded as ID-13 through ID-19 in the [Identity Decision Register](after_four_identity_decision_register.md).
- `TECHNICAL_PROPOSAL` means an implementation design or detail that is not converted into Owner policy by approval of the recommendation.
- `SECURITY_REVIEW_REQUIRED` means a qualified reviewer must assess the design and evidence before implementation or ADR acceptance.
- `LEGAL_REVIEW_REQUIRED` means retention/privacy obligations must be obtained from qualified current Vietnamese legal/privacy advice; this report does not invent them.

The recommendations preserve these confirmed boundaries: individual PINs; mandatory MFA for Owner and Branch Managers; confirmed session timeouts; multiple device sessions; invitation-only accounts; Owner approval for every Role/Branch Assignment change; Owner/Branch Manager/Staff terminology; username login; and restricted append-only audit. Sections titled “Owner decision record and remaining choices” preserve the questions presented for approval: the recommendation-level policy is confirmed, while named vendors, exact controls, procedures, capability enumeration, retention durations, and professional-review outcomes remain undecided unless ID-13 through ID-19 explicitly say otherwise.

## 2. Recommendations at a glance

| Topic | Recommended option | Decision state |
|---|---|---|
| Sensitive Branch Manager capabilities | One fixed, code-owned Branch Manager matrix; assigned-Branch scope; sensitive actions require MFA/step-up; explicit never-allowed actions. | `OWNER_CONFIRMED` as ID-13; `SECURITY_REVIEW_REQUIRED` |
| Authorized delegate | A separate, purpose-limited invitation delegation, Branch-scoped and time-boxed; no assignment approval or self-administration. | `OWNER_CONFIRMED` as ID-14; `SECURITY_REVIEW_REQUIRED` |
| Account-state authority | Automated temporary authentication lock; Owner-only suspend/reactivate/deactivate; deactivation terminal for ordinary use. | `OWNER_CONFIRMED` as ID-15; `SECURITY_REVIEW_REQUIRED` |
| Owner recovery | Prevention-first with multiple enrolled factors and offline recovery material; lost-all-factor recovery uses dual control and two independent proofs. | `OWNER_CONFIRMED` as ID-16; `SECURITY_REVIEW_REQUIRED` |
| Deployment/proxy | Same-origin frontend and `/api/v1` behind one TLS edge; backend private; exact proxy trust; forwarded headers replaced at edge; no CORS. | `OWNER_CONFIRMED` as ID-17; `SECURITY_REVIEW_REQUIRED` |
| Audit policy | Risk-tiered event categories and least-privilege readers; retention durations chosen only after legal/privacy review. | `OWNER_CONFIRMED` as ID-18; `SECURITY_REVIEW_REQUIRED`, `LEGAL_REVIEW_REQUIRED` |
| Concurrent sessions | No fixed numeric cap for MVP; use visibility, notification, expiry, risk detection, and revocation; revisit only with evidence. | `OWNER_CONFIRMED` as ID-19; `SECURITY_REVIEW_REQUIRED` |

## 3. Sensitive Branch Manager capability matrix

### Problem and threats

A Branch Manager needs enough authority to operate assigned Branches, but the role name must not imply unrestricted access to employee identity, payroll, customer data, audit, cash, refunds, configuration, or other Branches. Primary threats are horizontal cross-Branch access, vertical escalation to Owner, misuse of sensitive operational capabilities, self-approval, and a compromised manager account.

### Alternatives

| Option | Benefits | Security/operational cost |
|---|---|---|
| Broad Branch administrator | Simple UI and few policies. | Excess privilege; difficult audit; one compromised account exposes all Branch data/actions. Rejected. |
| Per-User permission editor | Flexible exceptions. | Permission drift, hidden combinations, weak reviewability, and high test/maintenance cost. Rejected for MVP. |
| Fixed role matrix with action guards | Predictable, testable, and compatible with a small modular monolith. | Policy changes require reviewed code/config releases; exceptions need explicit future design. Recommended. |

### Recommendation

This matrix is a `TECHNICAL_PROPOSAL`. Every action remains limited to Branches present in both the effective Role Assignment and Employee Branch Assignment. Resource-specific domain policies and approval thresholds still apply.

#### Proposed capability matrix

| Capability family | Branch Manager recommendation | Authentication/control | Explicit boundary |
|---|---|---|---|
| Branch operational dashboard and queues | Read assigned-Branch operational data needed for the job. | Active session; ordinary authorization. | No other Branch, Organization-wide export, or unrelated sensitive fields. |
| Staff schedule and attendance | Create/publish schedules and handle approved attendance workflows for assigned Staff. | MFA session for corrections; reason and audit. | Cannot change Role or Branch Assignments; cannot view unrelated compensation data. |
| Staff identity invitation | Not inherent in Branch Manager. Available only through a separate active Delegation. | MFA and audited invitation. | Cannot activate directly, invite Owner/Branch Manager, approve assignments, or delegate onward. |
| Catalog availability and local operations | Manage assigned-Branch availability and approved local settings. | MFA/step-up for high-impact changes; audit. | No Organization/Brand master ownership unless a later domain decision grants it. |
| Cash close, discrepancy, inventory adjustment/transfer | Only actions already approved by the relevant domain policy. | MFA/step-up, reason, immutable evidence, thresholds where approved. | Cannot approve own exception or bypass unresolved threshold policy. |
| Refund, void, cancellation, price override | No execution until the separate domain authority/threshold policy is approved. | MFA/step-up and approval when eventually enabled. | Role label alone never grants these actions. |
| Payroll | Preliminary review only for assigned scope, matching existing canonical policy. | MFA, minimized fields, audited sensitive reads. | No final close, compensation authority, or Organization-wide payroll export. |
| Customer information | Minimum fields needed for assigned-Branch service and approved history visibility. | Purpose-limited access; sensitive reads auditable. | No chain-wide browsing/export or unnecessary contact data. |
| Role/Branch Assignment approval | Never. | Owner approval required. | Cannot approve own or another User's assignment change. |
| Owner identity, MFA, or recovery | Never. | Owner recovery procedure only. | No Owner reset, factor removal, session revocation, or impersonation. |
| Audit administration | No mutation; no general read/export by default. | Named audit-reader policy if later approved. | Append-only evidence cannot be altered; ordinary Branch Manager role grants nothing. |
| Organization security/deployment/configuration | Never. | Owner/operations security process. | No secrets, proxy, retention, role-template, or security-policy administration. |

Because normal Branch Manager duties include sensitive staff, cash, inventory, or payroll review, the simplest launch policy is to require MFA for every Branch Manager rather than create two manager variants. Action-level step-up remains appropriate for the highest-impact commands.

### Owner decision record and remaining choices

`OWNER_CONFIRMED` ID-13 approves a fixed code-owned matrix, assigned-Branch scope, MFA for every Branch Manager, step-up for sensitive capabilities, and the explicit prohibitions in the Decision Register. It does not approve the example capabilities in this proposal. Ordinary/sensitive capabilities, domain-specific refund/void/price/approval policy, customer/payroll field visibility, and any scoped audit-reader responsibility must still be explicitly decided and reviewed rather than inferred.

### Professional review

- `SECURITY_REVIEW_REQUIRED`: capability naming, step-up freshness, field-level minimization, policy composition, IDOR controls, and denial/audit behavior.
- `LEGAL_REVIEW_REQUIRED`: payroll/customer field visibility and export/privacy obligations.

### Acceptance criteria and tests

- A table maps every protected identity/administrative command to capability, resource scope, step-up, approval, and audit behavior.
- Default denial applies when a capability or either assignment is absent/expired.
- Cross-Branch list, detail, bulk/export, nested-resource, and guessed-UUID tests return no data leakage.
- Branch Manager cannot grant/revoke roles, approve Branch Assignments, operate on Owner identity, alter audit, approve self, or activate unresolved refund/price powers.
- Revoking a role/Branch scope or session takes effect on the next request, including concurrent requests.
- Sensitive-field serialization tests prove minimization, not merely endpoint denial.

## 4. Authorized-delegate lifecycle and scope

### Problem and threats

ID-08 allows the Owner or an Owner-authorized delegate to invite employees. “Delegate” is not an additional role and must not become a back door to role grants, Branch grants, self-approval, Owner recovery, or indefinite standing privilege. Threats include privilege accumulation, stale delegation after transfer/offboarding, inviting a fake identity, self-invitation, delegation chaining, and approving the assignments requested in the same workflow.

### Alternatives

| Option | Benefits | Security/operational cost |
|---|---|---|
| Permanent invitation permission attached to Branch Manager | Low administration. | Stale privilege and unclear revocation; conflates role with delegation. Rejected. |
| One-time delegation per invitation | Strongest control and smallest blast radius. | Owner becomes a bottleneck for routine hiring. |
| Purpose-limited, Branch-scoped, expiring Delegation | Supports routine hiring while keeping scope, history, and revocation explicit. Recommended. | Requires lifecycle records, expiry review, and policy tests. |

### Recommendation

Create a separate logical Delegation—not a Role Assignment or free-form permission—with purpose `invite_staff`, grantor Owner, delegate User, allowed Branches, effective interval, status, reason, and revocation evidence. This is proposed logical design only, not an approved schema.

- Delegate must be an active User with MFA and an effective assignment for every delegated Branch.
- Delegate may invite Staff candidates only for the listed Branches. An invitation may carry proposed employment/Branch details, but the resulting Role Assignment and Employee Branch Assignment remain pending until Owner approval.
- Delegate cannot invite Owner or Branch Manager, invite themselves, approve any assignment, change the invite target after acceptance, delegate onward, recover accounts, or manage MFA/sessions.
- Delegation ends immediately on expiry, revocation, suspension/deactivation, loss of qualifying assignment, or Owner revocation. Previously issued unaccepted invitations are revoked.
- The maximum term is 90 days. Renewal requires the Owner; the delegate cannot renew themself.

### Owner decision record and remaining choices

`OWNER_CONFIRMED` ID-14 limits delegation to active Branch Managers, Staff invitations in assigned Branches, and at most 90 days; forbids assignment approval, onward delegation, and self-renewal; and requires Owner revocation to invalidate outstanding unused invitations. Shorter or one-time terms, representation, revalidation, acceptance, expiry/revocation races, and notification remain technical/security-review choices.

### Professional review

- `SECURITY_REVIEW_REQUIRED`: token expiry/acceptance, delegate revalidation on every invitation, revocation races, anti-enumeration, and audit/notification.
- Privacy/legal review may be needed for personal information collected before employment is accepted.

### Acceptance criteria and tests

- Delegate cannot exceed purpose, Branches, target role, or effective interval.
- Delegate cannot create/approve their own Delegation, Role Assignment, or Branch Assignment.
- Owner revocation, User suspension, Branch transfer, and expiry block the next invitation request.
- Invitation acceptance after delegation expiry/revocation follows the Owner-selected outstanding-invitation policy.
- Duplicate/replayed invitation commands are idempotent and never create multiple active identities.
- All grant, renewal, use, denial, expiry, and revocation events are append-only and contain no invitation secret.

## 5. Suspension, deactivation, unlock, and reactivation authority

### Problem and threats

Authentication defense, an investigation hold, and employment offboarding are different events. Conflating them can permanently deny a legitimate User, let an inactive employee retain access, destroy history, or allow a compromised manager to restore themselves. Threats include attacker-triggered lockout, stale sessions, partial offboarding, unauthorized reactivation, and state changes that silently restore old assignments.

### Alternatives

| Option | Benefits | Security/operational cost |
|---|---|---|
| Branch Manager manages Staff lifecycle | Faster local response. | Manager compromise can disable/restore staff and suppress evidence; conflicts with centralized identity control. |
| Owner controls every state including temporary failed-login lock | Simple authority. | Owner becomes support bottleneck; attacker-triggered lock needs human recovery. |
| Separate automatic lock from Owner-controlled administrative states | Preserves no-permanent-failure lockout while centralizing consequential access changes. Recommended. | Requires precise state/event semantics and escalation procedure. |

### Recommendation

| Transition/control | Recommended authority and effect |
|---|---|
| Progressive authentication delay | System-controlled; expires automatically under reviewed limits; never changes employment or assignments. |
| Temporary authentication lock | System-controlled only when reviewed thresholds require it; automatically expires. Owner may clear it after identity/risk checks. |
| Active → Suspended | Owner only. Immediately revoke sessions, block all authentication, preserve credentials and effective assignments for investigation. |
| Suspended → Active | Owner only after recorded reason, risk review, and required credential/MFA reset. Re-evaluate rather than silently restore expired assignments. |
| Any operational state → Deactivated | Owner only as offboarding/final access termination. Revoke sessions, invitations, recovery challenges, PIN/MFA, and end current/future Role/Branch Assignments while preserving history. |
| Deactivated → Active | Forbidden in ordinary operation. Rehire uses a reviewed new invitation/access grant linked to preserved employment history; exceptional data-error correction requires a separate Owner/security procedure. |

Branch Managers may submit an urgent suspension request and contact the Owner, but receive no suspension/reactivation authority in the recommended MVP. If Owner availability cannot meet incident needs, the Owner must explicitly approve a narrowly scoped emergency security delegate rather than silently giving Branch Manager this power.

### Owner decision record and remaining choices

`OWNER_CONFIRMED` ID-15 separates temporary automated authentication lock from Owner-controlled suspension/reactivation and deactivation, requires explicit audited Owner reactivation, forbids automatic return after deactivation, and requires explicit Owner rehire/reactivation while preserving history. Lock release, whether suspension preserves grants, atomic enforcement, and the separate reviewed Owner-unavailable escalation procedure remain unresolved. No emergency Branch Manager authority is implied.

### Professional review

- `SECURITY_REVIEW_REQUIRED`: lock thresholds/duration, compromise recovery, session revocation races, state transition atomicity, and emergency procedure.
- Legal/HR review: employment suspension/offboarding records, privacy, notice, and retention; the User security state must not decide employment law.

### Acceptance criteria and tests

- Wrong credentials alone never produce permanent deactivation or permanent lock.
- Every non-active state blocks new and existing sessions; revocation wins against concurrent requests.
- Suspension preserves history and does not silently edit Employee status or assignments.
- Deactivation atomically fails closed across sessions, authenticators, invitations/recovery, and current/future grants.
- Only Owner-authorized commands can suspend/reactivate/deactivate; Branch Manager requests cannot execute transitions.
- Reactivation rechecks MFA, credentials, assignments, and effective dates; deactivated ordinary login cannot be restored by field edit.

## 6. Separate Owner account recovery

### Problem and threats

The Owner is the highest-impact identity and the authority for employee recovery and assignment approval. Email-only or single-admin recovery creates a takeover path; no recovery path can permanently lock the chain out. Threats include mailbox compromise, social engineering, malicious delegate recovery, lost-all-factor lockout, recovery-code theft, and unaudited database intervention.

### Alternatives

| Option | Benefits | Security/operational cost |
|---|---|---|
| Email-only reset | Familiar and cheap. | One mailbox becomes the Owner account; inadequate for highest privilege. Rejected. |
| External IdP-managed recovery | Mature controls and less custom recovery code. | Provider dependency, cost, topology change, and separate ADR/security review. Viable future option. |
| Prevention-first local recovery with dual control | Fits current first-party design; avoids a single recovery actor. | Requires offline custody, named people, drills, and careful runbook. Recommended if local auth remains. |

### Recommendation

First prevent lost-all-factor events: enroll at least two independent MFA authenticators for the Owner and issue offline, single-use recovery material stored separately. Replacing a lost factor while another approved factor remains is factor replacement, not full account recovery.

For lost-all-factor recovery, require two independent proofs and dual control—for example, a saved offline recovery code plus approval by a pre-registered recovery custodian through a verified out-of-band channel. No employee recovery delegate or Branch Manager may recover the Owner. The process must notify all Owner recovery contacts, revoke all sessions and old factors, rotate recovery material, require new MFA enrollment, and create immutable audit evidence. Manual database editing is not a recovery method.

NIST treats account recovery as distinct from normal authentication, recognizes saved/issued recovery codes, recovery contacts, and repeated identity proofing, and requires recovery notification. The exact AFTER FOUR assurance level is not asserted here. [NIST SP 800-63B-4 authenticator event management](https://pages.nist.gov/800-63-4/sp800-63b/events/)

### Owner decision record and remaining choices

`OWNER_CONFIRMED` ID-16 requires at least two pre-established independent factors, preference for passkeys/hardware keys where appropriate, offline recovery material, two independent proofs, dual control, and an Owner-unavailable emergency procedure; a Branch Manager cannot independently recover the Owner. Authentication provider, exact proofs/assurance, custodians, storage/rotation, delay/escalation, notification, monitoring/audit, and drill ownership remain unresolved and `SECURITY_REVIEW_REQUIRED`.

### Professional review

- `SECURITY_REVIEW_REQUIRED`: recovery assurance, code entropy/storage, custodian verification, phishing resistance, notification, cooling-off/emergency handling, session/factor revocation, and drill evidence.
- Legal/privacy review for identity evidence collected or retained during manual proofing.

### Acceptance criteria and tests

- No single mailbox, delegate, Branch Manager, database operator, recovery code, or unavailable Owner session can complete lost-all-factor recovery alone.
- Recovery secrets are one-way stored where applicable, single-use, throttled, never logged, and rotated after use.
- Completion revokes every prior session/factor and requires fresh MFA enrollment.
- Every initiation, approval, denial, expiry, completion, and custodian change is notified and audited.
- Runbook tabletop test covers Owner unavailable, one custodian unavailable, stolen recovery material, disputed request, and partial failure.

## 7. Production deployment and trusted-proxy topology

### Problem and threats

Cookie security, CSRF, client-IP rate limiting, HTTPS redirects, Host validation, and audit attribution depend on the real routing path. Trusting arbitrary forwarded headers permits source spoofing and rate-limit bypass; exposing Rails directly can bypass edge TLS and header normalization. Threats include session-cookie downgrade, Host-header/DNS rebinding, forged `X-Forwarded-For`, origin bypass, broad credentialed CORS, and inconsistent health routing.

### Alternatives

| Option | Benefits | Security/operational cost |
|---|---|---|
| Separate cross-origin frontend/API | Independent hosting. | Credentialed CORS and CSRF/origin complexity; more failure modes. Not recommended without a proven constraint. |
| Same-site subdomains | Some deployment independence. | Cookie/domain and CORS/origin details remain more complex than one origin. |
| Same origin through one managed TLS edge | Simplest cookie/CSRF model; one public authority. Recommended. | Requires path routing and an accurately documented proxy chain. |

### Recommendation

Use one public HTTPS origin: serve the frontend at `/` and route `/api/v1` plus required health paths through one managed load balancer/reverse proxy to private Rails instances. Keep PostgreSQL, workers, Rails origin, and administrative interfaces off the public Internet. Do not enable CORS.

The edge terminates TLS, replaces rather than appends untrusted forwarding headers, sets a canonical Host, and connects only to the private origin. Rails keeps `force_ssl`/`assume_ssl`, enables an exact production Host allowlist, and trusts only the actual proxy addresses/CIDRs. Direct origin access is denied. If there are multiple proxy hops, document their order and test the actual header chain. Rails 8.1 `ActionDispatch::RemoteIp` derives client IP by removing configured trusted proxies; Rails warns that incorrect/no-proxy assumptions permit IP spoofing. [Rails RemoteIp API](https://api.rubyonrails.org/v8.1/classes/ActionDispatch/RemoteIp.html) Rails also recommends production Host Authorization against DNS rebinding/Host-header attacks. [Rails Security Guide](https://guides.rubyonrails.org/security.html)

### Owner decision record and remaining choices

`OWNER_CONFIRMED` ID-17 approves one HTTPS origin, frontend and `/api/v1` through one managed edge, a private Rails origin, no default CORS, explicit trusted proxies, enabled/configured Host Authorization, and health responses without sensitive infrastructure detail. Hosting provider, domain, DNS, CDN/WAF or edge vendor, exact proxy/network/private-connectivity design, operational ownership, administrative access, and health monitoring remain unresolved. No vendor is selected.

### Professional review

- `SECURITY_REVIEW_REQUIRED`: threat model of the chosen provider, exact trusted proxy set, header normalization, direct-origin blocking, TLS/HSTS, Host Authorization, CSRF/cookies, rate limiting, WAF/CDN behavior, and log source integrity.
- Operations review: availability, certificate renewal, observability, rollback, and proxy/CIDR change process.

### Acceptance criteria and tests

- A topology diagram names every public/private hop, protocol, port, header owner, trust boundary, and health route.
- Only the edge reaches Rails; only application/worker identities reach PostgreSQL.
- Rails accepts only approved hosts and HTTPS context; HTTP/direct-origin/foreign-Host requests fail safely.
- Spoofed and duplicate forwarding headers cannot change the derived client IP; real multi-hop requests derive the expected IP.
- Rate limits and audit source summaries behave correctly through the real staging proxy chain.
- Same-origin unsafe requests require CSRF; foreign-origin requests fail; credentialed wildcard CORS is absent.

## 8. Audit retention, privacy, and access policy

### Problem and threats

Audit evidence must survive long enough for investigations without becoming an indefinite store of staff/customer personal data. A guessed retention number may violate actual obligations; broad read access can enable surveillance or expose sensitive business data. Threats include tampering, premature deletion, indefinite retention, secret/PII leakage, unauthorized export, and audit readers investigating themselves without oversight.

### Alternatives

| Option | Benefits | Security/privacy/maintenance cost |
|---|---|---|
| Retain everything indefinitely | Maximum historical availability. | Unbounded privacy, breach, storage, and legal risk. Rejected. |
| One duration for every event | Easy cleanup. | Ignores different investigative, employment, financial, and privacy needs. |
| Risk-tiered event classes with legally validated durations | Minimizes data while preserving high-value evidence. Recommended. | Requires classification, scheduled deletion/archive, holds, and periodic review. |

### Recommendation

Adopt a policy structure now, but do not approve numeric durations until current legal/privacy review. Define at least these classes:

1. authentication/rate-limit/session events;
2. identity, MFA, recovery, delegation, role, and Branch-assignment events;
3. privileged business/financial approvals that also have domain-ledger evidence;
4. audit-read/export and integrity-administration events;
5. transient security telemetry not needed as authoritative evidence.

For each class, legal/privacy review supplies required minimums, maximums, erasure/anonymization constraints, litigation/investigation hold behavior, and cross-system requirements. The Owner then approves operational online/archive durations within those bounds. Retention expiry deletes or irreversibly anonymizes only what the approved policy permits; it never mutates retained event content or deletes the underlying business ledger.

Recommended access model:

- application runtime can append but cannot update/delete or perform general reads;
- Owner can request scoped review/export through an audited interface but cannot alter evidence;
- no Branch Manager general audit access by default;
- a separately named Audit Reviewer may receive time-limited, purpose-bound, read-only scope that cannot include their own investigation without second review;
- database/operations access is break-glass, time-bound, and audited outside the application log it can affect;
- exports are minimized, encrypted, expiring, and themselves audited.

OWASP notes that both too little and too much logging are security weaknesses and recommends consistent authorization-event logging and testing. [OWASP Authorization Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Authorization_Cheat_Sheet.html)

### Owner decision record and remaining choices

`OWNER_CONFIRMED` ID-18 approves Security, Account lifecycle, Authorization and assignment, Financial, HR/payroll, and Operational classes; explicit reader authorization; prohibition on a User modifying/deleting their own audit evidence; controlled holds/exports/anonymization; and integrity/accountability. It approves no numeric duration. Eligible readers and self-review rules, legal retention bounds, visibility, pre-employment/offboarding and recovery-evidence treatment, hold/release authority, export controls, and anonymization timing remain unresolved pending security and legal/privacy review.

### Professional review

- `LEGAL_REVIEW_REQUIRED`: current Vietnamese employment, privacy, accounting/tax, security-incident, and dispute obligations; no duration in this report is a legal requirement.
- `SECURITY_REVIEW_REQUIRED`: append-only DB privileges, integrity monitoring, encryption/backups, reader segregation, break-glass, exports, holds, deletion/anonymization jobs, and coverage/redaction tests.

### Acceptance criteria and tests

- A versioned retention schedule names every event class, legal basis/review, online/archive duration, hold behavior, deletion/anonymization action, and accountable owner.
- Runtime role cannot update/delete audit rows or read them generally; read/export/break-glass actions are themselves evidenced outside the affected trust boundary where necessary.
- Redaction tests prohibit credentials, raw tokens, MFA/recovery secrets, unapproved network identifiers, unrestricted bodies, and unnecessary personal data.
- Retention jobs respect holds, are idempotent, produce safe deletion summaries, and never delete domain ledgers.
- Reader tests cover self-investigation, Branch/cross-Branch scope, exports, expired access, and direct database privilege denial.

## 9. Numeric concurrent-session cap

### Problem and threats

Multiple device sessions are Owner-confirmed. A low fixed cap can interrupt legitimate POS/back-office work and create support pressure without stopping stolen sessions; unlimited invisible sessions can let compromise persist. Threats include stolen-session persistence, credential sharing, session accumulation, unattended devices, denial of service through forced eviction, and privacy-invasive device monitoring.

### Alternatives

| Option | Benefits | Security/operational cost |
|---|---|---|
| Small global cap such as three | Simple bound. | No repository evidence supports the number; can evict legitimate devices and does not identify a stolen session. |
| Role/device-specific cap | Better operational fit. | More policy, edge cases, and support complexity before device inventory exists. |
| No fixed cap plus visibility, expiry, detection, and revocation | Honors confirmed multi-device use without inventing a number; controls actual risk signals. Recommended for MVP. | Requires usable session inventory and monitoring; storage cleanup still needed. |

### Recommendation

Do not set a numeric cap at launch. Independently enforce the confirmed idle/absolute limits and POS lock; show safe active-session/device summaries; notify on new sessions; let Users revoke individual sessions and the Owner revoke all; rotate/revoke after recovery or compromise; and alert on risk signals such as implausible concurrency or excessive new sessions. Do not use IP/User-Agent as sole proof, and include collection in privacy review.

Define evidence that would reopen the decision: repeated credential sharing, material session-table growth despite expiry cleanup, license/device constraints, incident findings, or support data showing abnormal simultaneous use. Any later cap needs per-role/device justification, deterministic eviction behavior, notification, and tests.

NIST states that timeout choices depend on assurance, environment, endpoint, device management, and application risk rather than one universal number. [NIST SP 800-63B-4 session management](https://pages.nist.gov/800-63-4/sp800-63b/session/) OWASP recommends active-session visibility and remote termination. [OWASP Session Management Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Session_Management_Cheat_Sheet.html)

### Owner decision record and remaining choices

`OWNER_CONFIRMED` ID-19 sets no numeric MVP cap and requires session visibility, appropriate new-device notifications, existing expiry controls, anomaly detection/revocation, and Owner all-session revocation. User self-revocation, exact inventory exposure, signals/thresholds, investigator ownership, privacy treatment, and shared-terminal handling remain technical/security-review choices. A cap is reconsidered only with operational or security-incident evidence; three is not a default.

### Professional review

- `SECURITY_REVIEW_REQUIRED`: session inventory exposure, notification, anomaly thresholds, revocation races, expiry cleanup, device summaries, and recovery behavior.
- Privacy review for retained IP/device/User-Agent summaries and notification channels.

### Acceptance criteria and tests

- No hard-coded cap exists without a superseding approved decision.
- Multiple legitimate sessions remain independent; logout/revocation of one does not affect others unless all-session revocation is requested.
- Owner all-session revocation, recovery, suspension, and deactivation invalidate all concurrent sessions, including race tests.
- Session inventory exposes no token and is scoped to self/authorized Owner action.
- Expired/revoked records are cleaned under an approved retention policy; active-session counts remain observable.
- New-session notification and abnormal-concurrency detection avoid raw secrets and pass privacy/redaction review.

## 10. Decision record outcome

The Owner confirmed all seven recommendation-level policies on 2026-11-14. The canonical outcomes are ID-13 through ID-19 in the [Identity Decision Register](after_four_identity_decision_register.md); that register controls if an example or unselected detail in this proposal is broader than the confirmed wording. No exception, vendor, new capability, numeric retention duration, or completed professional review was supplied.

ADR-0006 remains Proposed. Do not change it to Accepted until the [Security Review Checklist](after_four_identity_security_review_checklist.md) has named-reviewer evidence for every applicable item and required legal/privacy review is recorded. Milestone 2B remains unauthorized.

## 11. Outstanding professional review

Owner approval of every recommendation does not complete professional review. Review remains for capability enforcement and field minimization; delegation/revocation; lifecycle/session races; Owner recovery assurance; proxy/TLS/header trust; audit privacy/retention/integrity; and session monitoring. The confirmed recommendations are policy inputs, not evidence that these reviews passed.
