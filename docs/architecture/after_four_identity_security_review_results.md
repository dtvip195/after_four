# AFTER FOUR Identity Security & Privacy Review Results

**Status:** Professional review records preserved as unexecuted history; AF-OWNER-001 is in progress  
**Date:** 2026-11-14  
**Scope:** Milestone 2A.5 security and legal/privacy review record  
**Authority:** This document does not authorize implementation. ADR-0006 remains Proposed and Milestone 2B remains unauthorized.  
**Related:** [Owner-Led Review Protocol](after_four_identity_owner_led_review_protocol.md) · [Review Package](after_four_identity_security_review_package.md) · [Security Review Checklist](after_four_identity_security_review_checklist.md) · [Decision Register](after_four_identity_decision_register.md) · [ADR-0006](adr/0006-authentication-session-topology.md)

## 1. Result summary

Controlled professional records have been created for all ten security checklist areas and all five requested legal/privacy topics. No professional reviewer identity, qualification, review date, executed implementation evidence, professional finding, legal opinion, recommendation, or approval was supplied. Under the evidence rules, none of those professional reviews can be represented as started and none of their statuses can change.

ID-20 subsequently selected Owner-led technical/security review and no external professional engagement. These fifteen records remain unchanged historical records of professional reviews that were prepared but never executed. Owner assessments are separate records and do not advance, overwrite, or repurpose these professional records. [AF-OWNER-001](security-reviews/owner-led/af-owner-001-password-pin-security.md) began on 2026-11-14 for the linked AF-SEC-001/002 password and PIN sequence and remains `OWNER_REVIEW_IN_PROGRESS`. IDs 29–34 record scoped approval of AF-OWNER-001D's Argon2 validation/admission direction; they do not complete the assessment, close a finding, approve production parameters or implementation, or accept residual risk.

| Result | Count |
|---|---:|
| Security records established | 10 |
| Security reviews actually started | 0 |
| Security reviews accepted | 0 |
| Legal/privacy records established | 5 |
| Legal/privacy reviews actually started | 0 |
| Legal/privacy reviews accepted | 0 |
| Canonical checklist status changes | 0 |
| Owner-led assessment records in progress | 1, covering AF-SEC-001 and AF-SEC-002 |
| Owner-led assessments completed or residual risk accepted | 0 |

The canonical security checklist remains four `OPEN`, six `BLOCKED`, zero `IN_REVIEW`, and zero `ACCEPTED`. “Record established” means a controlled location, scope, policy trace, evidence gap, acceptance criteria, and next action now exist. It is not review evidence.

## 2. Security review records

| Sequence | Review ID and record | Scope | Reviewer/evidence result | Final status |
|---:|---|---|---|---|
| 1 | [AF-SEC-001](security-reviews/af-sec-001-password-hashing.md) | Password hashing | Reviewer not provided; design/benchmark/executed evidence absent | `OPEN` |
| 1 | [AF-SEC-002](security-reviews/af-sec-002-pin-protection.md) | PIN protection | Reviewer not provided; format/digest/limits/attack evidence absent | `OPEN` |
| 2/4 | [AF-SEC-003](security-reviews/af-sec-003-mfa.md) | MFA, step-up, capability/Branch/delegation boundary | Reviewer not provided; capability matrix and factor design absent | `BLOCKED` |
| 2 | [AF-SEC-006](security-reviews/af-sec-006-login-defenses.md) | Authentication/login defenses | Reviewer not provided; limits/distributed/source evidence absent | `OPEN` |
| 2 | [AF-SEC-009](security-reviews/af-sec-009-owner-recovery.md) | Owner recovery | Reviewer not provided; proofs/custodians/runbook/drill absent | `BLOCKED` |
| 3 | [AF-SEC-004](security-reviews/af-sec-004-cookie-csrf.md) | Cookie and CSRF | Reviewer not provided; middleware/topology/browser evidence absent | `BLOCKED` |
| 3 | [AF-SEC-005](security-reviews/af-sec-005-session-policy.md) | Session rotation, expiry, visibility, revocation | Reviewer not provided; state/race/drill evidence absent | `OPEN` |
| 4/7 | [AF-SEC-008](security-reviews/af-sec-008-audit-security.md) | Capability denials, Branch/delegation evidence, audit integrity/access/privacy | Reviewer not provided; privilege/integrity/legal evidence absent | `BLOCKED` |
| 4/5 | [AF-SEC-010](security-reviews/af-sec-010-offboarding-suspension.md) | Lifecycle, authorization revocation, delegation/offboarding | Reviewer not provided; procedure/implementation/failure evidence absent | `BLOCKED` |
| 6 | [AF-SEC-007](security-reviews/af-sec-007-trusted-proxy-https.md) | HTTPS and trusted-proxy topology | Reviewer not provided; deployment topology and real-path evidence absent | `BLOCKED` |

No findings or severities are reported because no professional assessment occurred. Each record distinguishes absent findings from a finding of “no issue.”

## 3. Legal and privacy review records

| Review ID and record | Scope | Reviewer/evidence result | Final status |
|---|---|---|---|
| [AF-PRIV-001](security-reviews/af-priv-001-payroll-customer-visibility.md) | Payroll/customer visibility and reader boundaries | Qualified reviewer and legal/privacy opinion absent | `NOT_STARTED` |
| [AF-PRIV-002](security-reviews/af-priv-002-preemployment-offboarding.md) | Pre-employment, suspension, offboarding, rehire records | Qualified reviewer and legal/privacy opinion absent | `NOT_STARTED` |
| [AF-PRIV-003](security-reviews/af-priv-003-recovery-evidence.md) | Recovery proof/custodian evidence | Qualified reviewer, final data flow, and opinion absent | `NOT_STARTED` |
| [AF-PRIV-004](security-reviews/af-priv-004-audit-retention-legal-holds.md) | Class retention and legal/investigation holds | Qualified reviewer, opinion, and schedule absent | `NOT_STARTED` |
| [AF-PRIV-005](security-reviews/af-priv-005-exports-anonymization.md) | Exports, recipient controls, anonymization | Qualified reviewer, workflows, and opinion absent | `NOT_STARTED` |

No legal requirement, lawful basis, retention duration, export rule, hold authority, anonymization standard, or vendor conclusion has been invented. Each record requires qualified current input before it may advance.

## 4. Dependency-ordered review plan

The records are organized in the required dependency order:

1. **Password and PIN cryptographic design:** AF-SEC-001 and AF-SEC-002 establish primitives and benchmark/limit evidence.
2. **MFA, authentication defenses, and recovery:** AF-SEC-003, AF-SEC-006, and AF-SEC-009 depend on the credential design and capability/recovery choices.
3. **Cookie, CSRF, session rotation, and revocation:** AF-SEC-004 and AF-SEC-005 depend on session topology and feed lifecycle/recovery evidence.
4. **Capability enforcement, Branch scope, and delegation:** cross-cutting evidence is reviewed in AF-SEC-003, AF-SEC-008, and AF-SEC-010 against ID-09, ID-13, and ID-14. No additional checklist row or invented permission is created.
5. **Account lifecycle and offboarding:** AF-SEC-010 depends on session, authenticator, assignment, delegation, and audit revocation boundaries; AF-PRIV-002 supplies required legal/privacy input.
6. **Production HTTPS and trusted-proxy topology:** AF-SEC-007 requires actual Owner-approved deployment facts and production-parity staging evidence.
7. **Audit integrity, access, retention, and privacy:** AF-SEC-008 depends on all earlier event/control definitions and on AF-PRIV-001 through AF-PRIV-005.

A later-stage review may begin design assessment before every earlier record is accepted, but it cannot be accepted while evidence from a stated dependency remains missing.

## 5. Status discipline

No checklist row was updated. A future update must link the exact review record and immutable evidence that justify it:

- Professional records remain in their historical state while ID-20 is active; Owner-led activity is recorded separately under the six Owner statuses.
- Move an Owner-led record to `OWNER_REVIEW_IN_PROGRESS` only after actual scope, date, baseline, and evidence inspection/test activity are recorded.
- Owner completion or residual-risk acceptance never marks a professional record independently reviewed or legally reviewed.
- Keep `OPEN` or `BLOCKED` when evidence or prerequisites are missing.
- Do not interpret `NOT_STARTED` legal/privacy records as legal approval or absence of obligations.

## 6. Unresolved blockers

### People and authority

- No independent security reviewer, qualification, or engagement exists; ID-20 accepts this non-independence as the current governance limitation.
- No qualified legal/privacy reviewer or jurisdiction-specific engagement exists; legal/privacy questions remain unverified and cannot be closed by Owner risk acceptance.
- AF-OWNER-001 records Owner-led findings, but the Owner has not accepted any residual risk. No professional finding exists.
- Owner approval is still required for deployment/vendor decisions and operational choices left open by the twenty-eight policies and the explicit limitations in IDs 29–34.

### Design and implementation evidence

- IDs 21–28 fix the password/PIN policy boundaries, and IDs 29–34 fix only the P64-4 validation candidate and resource/admission direction. AF-OWNER-001C.2/C.3 provide isolated compatibility/capacity evidence; production dependency/profile selection, numeric input/rate-limit/resource/admission values, Rails production-parity benchmarks, device/source mechanisms, pepper operations, credential-change/reset matrices, implementation, and executed-control evidence remain absent.
- Ordinary/sensitive capability enumeration, MFA factor/step-up/recovery design, and secret custody are absent.
- Cookie/CSRF/session storage, rotation, activity, inventory, notification, anomaly, revocation, and race designs are absent.
- Login thresholds/windows/keys, distributed limiter state, and trusted client-source design are absent.
- Lifecycle transaction/failure semantics, lock release, Owner-unavailable escalation, and complete revocation inventory are absent.
- Audit event catalog, database privileges, integrity verification, readers, exports, holds, anonymization, reconciliation, and backup evidence are absent.
- There is no authorized Identity implementation from which request, policy, database, browser, multi-process, or failure-injection evidence can be collected.

### Deployment and operations

- Hosting, domain/DNS, edge/CDN, exact proxy chain/CIDRs, network/private connectivity, TLS/Host/health configuration, monitoring, ownership, and production-parity staging are unselected.
- Owner-recovery proofs, custodians, offline custody/rotation, delay/escalation, implementation/provider, notifications, runbooks, and controlled drills are undefined.
- No real-path browser/proxy test, production-like cryptographic benchmark, recovery drill, offboarding drill, or external adversarial assessment exists.

### Legal and privacy

- Payroll/customer reader scope, self-investigation, notices, rights, and field minimization are unresolved.
- Candidate, suspension, offboarding, rehire, and historical-record handling are unresolved.
- Recovery-proof and custodian evidence handling is unresolved.
- Audit class retention and legal/investigation hold authority/release are unresolved.
- Export recipients/purpose/protection/disposition and anonymization standards/timing are unresolved.
- No numeric retention period is approved or recorded.

## 7. Completion boundary

Milestone 2A.5 established controlled professional records and truthfully recorded that no actual professional review occurred. ID-20 does not alter that history. AF-OWNER-001 now records an in-progress, non-independent Owner assessment with findings and missing evidence; it is not completed and accepts no residual risk. Nothing here authorizes or begins Milestone 2B.
