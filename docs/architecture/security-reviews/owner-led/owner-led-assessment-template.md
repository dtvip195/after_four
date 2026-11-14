---
assessment_id: null
historical_review_id: null
owner_review_status: NOT_STARTED
independent_verification: NOT_PERFORMED
legal_review: NOT_PERFORMED
assessment_start_date: null
assessment_completion_date: null
---

# AFTER FOUR Owner-Led Identity Assessment Record

**Template status:** Reusable. Copy to a new file per scope; do not overwrite this template.  
**Protocol:** [Owner-Led Identity Review Protocol](../../after_four_identity_owner_led_review_protocol.md)  
**Mandatory limitation:** Owner is also backend developer; this assessment is not independent verification, professional certification, legal advice, or implementation authorization.

## 1. Assessment identity

- Assessment ID: `[AF-OWNER-NNN]`
- Historical professional record: `[AF-SEC-NNN OR AF-PRIV-NNN + LINK]`
- Owner/reviewer project identity: `[ACTUAL OWNER NAME OR CONTROLLED ID]`
- Owner is also developer: `YES`
- Owner review status: `[NOT_STARTED / OWNER_REVIEW_IN_PROGRESS / OWNER_REVIEW_COMPLETED / REMEDIATION_REQUIRED / OWNER_ACCEPTED_RESIDUAL_RISK / BLOCKED]`
- Independent verification: `NOT_PERFORMED`
- Legal review: `[NOT_PERFORMED / NOT_APPLICABLE TO TECHNICAL SUBSCOPE]`
- Actual start/completion dates: `[ACTUAL OR NULL]`
- Scope, exclusions, environment, commit/artifact baseline: `[ACTUAL]`
- BA-01–BA-08 dependencies: `[LIST OR NONE WITH RATIONALE]`

## 2. Requirement and evidence map

| Criterion ID | Owner decision/technical requirement | Threat/abuse case | Evidence required | Evidence ID | Result: PASS/FAIL/NOT_TESTED/NOT_APPLICABLE | Limitation |
|---|---|---|---|---|---|---|
| `[CRIT-NNN]` | `[SOURCE]` | `[THREAT ID]` | `[REQUIREMENT]` | `[ACTUAL OR MISSING]` | `[RESULT]` | `[LIMITATION]` |

## 3. Evidence manifest

| Evidence ID | Type: design/code/config/test/staging/operations | Artifact/version/hash/environment | Inspection or command | Actual result | Date | Storage/classification |
|---|---|---|---|---|---|---|
| `[EVID-NNN]` | `[TYPE]` | `[IDENTIFIER]` | `[METHOD]` | `[RESULT]` | `[ACTUAL]` | `[LOCATION/CLASS]` |

Do not label design as implementation evidence. Record skipped/missing evidence explicitly. Do not include live secrets or unnecessary personal/payroll/customer data.

## 4. Threat and abuse-case assessment

| Threat ID | Actor/preconditions | Entry/abuse path | Asset/impact | Prevent/detect/recover controls | Evidence | Residual exposure |
|---|---|---|---|---|---|---|
| `[THREAT-NNN]` | `[ACTUAL]` | `[ACTUAL]` | `[ACTUAL]` | `[CONTROLS]` | `[EVID IDS]` | `[ASSESSMENT]` |

## 5. Code and configuration review

- Modules/interfaces inspected: `[ACTUAL OR NOT IMPLEMENTED]`
- Request/middleware/policy paths inspected: `[ACTUAL OR NOT IMPLEMENTED]`
- Persistence/transaction/constraint/privilege paths inspected: `[ACTUAL OR NOT IMPLEMENTED]`
- Secret/log/audit handling inspected: `[ACTUAL OR NOT IMPLEMENTED]`
- Deployment/environment drift inspected: `[ACTUAL OR NOT AVAILABLE]`
- Alternate/bypass paths searched: `[METHOD AND RESULT]`

## 6. Automated test execution

| Test ID | Command/tool/version | Environment/seed | Expected property | Actual result | Artifact link | Limitations |
|---|---|---|---|---|---|---|
| `[TEST-NNN]` | `[ACTUAL]` | `[ACTUAL]` | `[PROPERTY]` | `[PASS/FAIL/SKIP]` | `[EVID ID]` | `[LIMITATION]` |

## 7. Manual negative, boundary, and concurrency tests

| Test ID | Scenario and authorization | Expected safe result | Actual result | Evidence | Cleanup/safety | Finding ID |
|---|---|---|---|---|---|---|
| `[MAN-NNN]` | `[ACTUAL]` | `[EXPECTED]` | `[ACTUAL]` | `[EVID ID]` | `[ACTUAL]` | `[IF ANY]` |

## 8. Findings, remediation, and retest

| Finding ID | Severity | Requirement/evidence | Reproduction/impact | Remediation | Retest evidence/result | Status | Residual risk |
|---|---|---|---|---|---|---|---|
| `[FIND-NNN]` | `[CRITICAL/HIGH/MEDIUM/LOW/OBSERVATION]` | `[SOURCE]` | `[ACTUAL]` | `[ACTION]` | `[EVID/RESULT]` | `[OPEN/RESOLVED/ACCEPTED RISK]` | `[ASSESSMENT]` |

## 9. Explicit residual-risk acceptance

Complete only for `OWNER_ACCEPTED_RESIDUAL_RISK`:

- Risk/finding IDs and unresolved condition: `[ACTUAL]`
- Assets/users/Branches/data/environments affected: `[ACTUAL]`
- Evidence examined and missing: `[ACTUAL]`
- Likelihood, impact, and uncertainty: `[ACTUAL]`
- Compensating controls/monitoring: `[ACTUAL]`
- Deferral/rejection rationale: `[ACTUAL]`
- Production restrictions and expiry/review trigger: `[ACTUAL]`
- Owner acknowledgment as developer/reviewer/risk acceptor: `[SIGNED/EQUIVALENT ACTUAL RECORD]`
- Independent verification: `NOT_PERFORMED`
- Legal statement: `This acceptance is not legal advice, compliance, or waiver.`

## 10. Scope-specific requirements

Use exactly one subsection below as the primary scope. Delete none from the template; in a copied record mark other subsections `NOT_APPLICABLE — different historical scope`.

### 10.1 AF-SEC-001 Password hashing

Inspect dependency maintenance/compatibility, target-hardware benchmark, algorithm/parameters/salts/input bounds, blocklist privacy, encoded metadata, rehash/reset races, digest-only storage, and log/audit redaction. Execute positive/negative/boundary/concurrency evidence from review-package §4.1. Legal review is not a substitute; independent cryptographic verification remains `NOT_PERFORMED`.

### 10.2 AF-SEC-002 PIN protection

Inspect PIN format, separate digest/pepper/key lifecycle, device and assigned-Branch guards, all verification paths, progressive defense, temporary lock/reset, privilege/recovery denial, benchmark, distributed guessing, race, and redaction evidence.

### 10.3 AF-SEC-003 MFA and step-up

Inspect final capability matrix/BA blockers, factor selection and custody, enrollment/verification/replay, step-up binding/freshness, replacement/removal, recovery/downgrade, Branch/delegation enforcement, notifications, and concurrent ceremonies. Legal handling of factor/recovery data remains unverified.

### 10.4 AF-SEC-004 Cookie and CSRF

Inspect token entropy/verifier, exact cookie flags/scope, Rails middleware, CSRF synchronizer/Origin/Host/CORS/cache behavior, login/logout/rotation, copied-old-token and concurrent mutation through supported browsers and actual edge path.

### 10.5 AF-SEC-005 Session policy

Inspect exact back-office/POS time edges, meaningful activity, multi-device independence/visibility, safe metadata, anomaly/notification, single/all/lifecycle revocation, current authorization, monotonic updates, cleanup, independent-connection races, and operational revocation evidence. Device/network privacy remains unverified.

### 10.6 AF-SEC-006 Login defenses

Inspect account/source/device/global keys, trusted source, thresholds/windows/delay/reset, generic status/body/timing, dummy verification, alternate routes, distributed atomicity, source rotation, backend outage, `Retry-After`, monitoring, and collateral-denial risk.

### 10.7 AF-SEC-007 Trusted proxy and HTTPS

Inspect approved domain/DNS/TLS/edge/origin/hop/CIDR inventory, forwarding-header replacement, source derivation, Host Authorization, HSTS/HTTPS, direct-origin/network denial, database/worker/secret isolation, health output, monitoring, and rolling change/rollback in production-parity staging. No independent infrastructure verification is performed.

### 10.8 AF-SEC-008 Audit security

Inspect taxonomy/coverage, actor/target/correlation, same-transaction append, runtime DB privileges, redaction allowlists, readers/self-investigation, integrity/checkpoint/sink, reconciliation, backup/restore, holds/exports/anonymization enforcement, and cleanup failure. Legal retention/visibility/hold/export conclusions remain `NOT_PERFORMED`.

### 10.9 AF-SEC-009 Owner recovery

Inspect Owner-approved proofs/custodians/timing, independent-factor/dual-control enforcement, offline custody/rotation, normal/emergency state machine, no Branch Manager/database-operator bypass, replay/concurrency/partial failure, session/factor/material revocation, notification/audit, tabletop and controlled drill. Recovery-evidence legal review remains `NOT_PERFORMED`.

### 10.10 AF-SEC-010 Offboarding and suspension

Inspect Owner-only authority, authentication lock separation, assignment/delegation/invitation/session/credential/factor/recovery revocation, future grants, explicit audited reactivation/rehire, history preservation, transaction/fail-closed behavior, failure injection, concurrency, monitoring, and drill. Employment/privacy conclusions remain `NOT_PERFORMED`.

### 10.11 AF-PRIV-001 Payroll and customer visibility

Owner may inventory facts, purposes, fields, readers, self-investigation, notices, rights, and risks, but cannot issue a legal conclusion. `legal_review` remains `NOT_PERFORMED`; relevant production processing remains `BLOCKED` until obligations and permitted visibility are established.

### 10.12 AF-PRIV-002 Pre-employment and offboarding

Owner may inventory candidate/invitation, suspension/offboarding, history, rehire, notice, access/correction, retention, and disposition facts. Statutory/employment/privacy conclusions remain unverified and cannot be risk-accepted into compliance.

### 10.13 AF-PRIV-003 Recovery evidence

Owner may inventory proof/custodian data, purposes, access, location, disclosure, incident, retention, and disposition. Lawful collection/handling/transfer obligations remain unverified before production recovery processing.

### 10.14 AF-PRIV-004 Audit retention and legal holds

Owner may inventory event classes, systems/backups, candidate operational needs, hold/release workflow, and conflicts, but must not invent legal periods or hold authority. Production retention/disposition remains blocked where legal requirements are unknown.

### 10.15 AF-PRIV-005 Exports and anonymization

Owner may inventory export purposes/recipients/fields/protection/disposition and candidate anonymization methods/re-identification risks. Legal basis, transfer conditions, anonymization sufficiency, hold exceptions, and timing remain unverified.

## 11. Completion and limitation statement

- Final Owner review status: `[ACTUAL]`
- Acceptance-criterion summary: `[PASS/FAIL/NOT_TESTED/NOT_APPLICABLE COUNTS]`
- Open findings/blockers: `[LIST]`
- Production conditions/restrictions: `[LIST]`
- Independent verification: `NOT_PERFORMED`
- Legal review: `[NOT_PERFORMED / NOT_APPLICABLE TO TECHNICAL SUBSCOPE]`
- Owner conclusion: `[TECHNICAL/SECURITY CONCLUSION ONLY; DO NOT CLAIM SECURE OR COMPLIANT]`
- Owner signed/equivalent acknowledgment and actual date: `[NOT YET PROVIDED]`

This record does not authorize implementation or Milestone 2B. Any canonical checklist update must link this assessment and state that review was Owner-led and non-independent.
