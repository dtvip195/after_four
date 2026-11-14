# AFTER FOUR Owner-Led Identity Review Protocol

**Status:** Owner-confirmed governance protocol; AF-OWNER-001 is in progress  
**Date:** 2026-11-14  
**Authority:** ID-20 in the [Identity Decision Register](after_four_identity_decision_register.md)  
**Scope:** Technical/security assessment, remediation, retest, and residual-risk acceptance for fifteen prepared review scopes  
**Limit:** Not independent verification, professional certification, legal advice, legal compliance, or implementation authorization  
**Related:** [Technical Design](after_four_identity_technical_design.md) · [Security Review Package](after_four_identity_security_review_package.md) · [Review Results](after_four_identity_security_review_results.md) · [Canonical Checklist](after_four_identity_security_review_checklist.md)

## 1. Governance decision and non-independence

The Owner is also the backend developer and has chosen to perform technical, architectural, and security assessment personally. No external security, infrastructure, cryptography, or legal/privacy reviewer is planned under the current approach.

This creates an unavoidable self-review limitation: the same person may design, implement, assess, remediate, and accept residual technical risk. Every assessment must state that limitation prominently. Evidence quality, reproducibility, and explicit uncertainty are required, but they do not create independence.

The fifteen professional review records remain immutable historical preparation records. They were never executed and retain their current `OPEN`, `BLOCKED`, or `NOT_STARTED` status. Owner-led assessments use separate records created from the [Owner-led Assessment Template](security-reviews/owner-led/owner-led-assessment-template.md).

## 2. Separate status axes

Every Owner-led record has three independent status fields:

1. `owner_review_status` — progress of the Owner's evidence-based assessment;
2. `independent_verification` — always `NOT_PERFORMED` under ID-20 unless governance changes and a real independent review occurs;
3. `legal_review` — always `NOT_PERFORMED` under ID-20 unless qualified legal/privacy advice is actually obtained.

### 2.1 Owner review statuses

| Status | Exact meaning | Minimum evidence to enter | Permitted exits |
|---|---|---|---|
| `NOT_STARTED` | Record may exist, but no scoped evidence inspection or test execution has begun. | Scope/record ID may be prepared; no finding or conclusion implied. | `OWNER_REVIEW_IN_PROGRESS`, `BLOCKED` |
| `OWNER_REVIEW_IN_PROGRESS` | Owner has recorded start date, scope, artifact baseline, and evidence actually being inspected or tests being executed. | Real evidence-manifest entry plus dated activity. Design reading alone must be identified as design review, not control execution. | `OWNER_REVIEW_COMPLETED`, `REMEDIATION_REQUIRED`, `OWNER_ACCEPTED_RESIDUAL_RISK`, `BLOCKED` |
| `OWNER_REVIEW_COMPLETED` | Owner has evaluated every in-scope acceptance criterion, linked executed evidence, resolved/retested findings, and recorded limitations and production conditions. | Criterion-by-criterion result; evidence hashes/commands/results; finding dispositions; explicit non-independence and legal status. | Reopened to `OWNER_REVIEW_IN_PROGRESS`, `REMEDIATION_REQUIRED`, or `BLOCKED` on change/new evidence. |
| `REMEDIATION_REQUIRED` | One or more findings or failed criteria require correction and retest before completion. | Finding IDs, severity, affected requirement, evidence, remediation owner/action, and retest condition. | `OWNER_REVIEW_IN_PROGRESS`, `OWNER_REVIEW_COMPLETED`, `OWNER_ACCEPTED_RESIDUAL_RISK`, `BLOCKED` |
| `OWNER_ACCEPTED_RESIDUAL_RISK` | Owner explicitly accepts a defined unresolved technical/security risk after evidence inspection. It is not a passed criterion, security claim, independent approval, or legal waiver. | Finding/risk IDs, impact/likelihood, scope, rationale, compensating controls, expiry/review trigger, production condition, and Owner acknowledgment. | `OWNER_REVIEW_IN_PROGRESS`, `REMEDIATION_REQUIRED`, `OWNER_REVIEW_COMPLETED`, `BLOCKED` |
| `BLOCKED` | Required policy, implementation, environment, evidence, legal fact, or safe test path is missing. No completion conclusion is possible. | Exact blocker and responsible decision/evidence owner. | `NOT_STARTED` or `OWNER_REVIEW_IN_PROGRESS` after blocker resolution |

Status is never inferred from a document's existence. A completed Owner assessment is not an `ACCEPTED` professional review. Canonical checklist changes, if later evidence supports them, must state `Owner-led review; independent verification not performed` and link the separate assessment record.

### 2.2 Current scope inventory

[AF-OWNER-001](security-reviews/owner-led/af-owner-001-password-pin-security.md) began on 2026-11-14 as a combined assessment of the dependency-linked password and PIN cryptographic sequence. It does not alter the two historical professional records or the canonical checklist.

| Historical professional record | Owner-led scope | Initial Owner status | Independent verification | Legal review |
|---|---|---|---|---|
| AF-SEC-001 | Password hashing | `OWNER_REVIEW_IN_PROGRESS` | `NOT_PERFORMED` | `NOT_PERFORMED` for applicable credential data handling |
| AF-SEC-002 | PIN protection | `OWNER_REVIEW_IN_PROGRESS` | `NOT_PERFORMED` | `NOT_PERFORMED` for applicable device/source monitoring data |
| AF-SEC-003 | MFA and step-up | `NOT_STARTED` | `NOT_PERFORMED` | `NOT_PERFORMED` for factor/recovery data questions |
| AF-SEC-004 | Cookie and CSRF | `NOT_STARTED` | `NOT_PERFORMED` | Not applicable except session metadata |
| AF-SEC-005 | Session policy | `NOT_STARTED` | `NOT_PERFORMED` | `NOT_PERFORMED` for device/network metadata |
| AF-SEC-006 | Login defenses | `NOT_STARTED` | `NOT_PERFORMED` | `NOT_PERFORMED` for source/device monitoring data |
| AF-SEC-007 | Trusted proxy and HTTPS | `NOT_STARTED` | `NOT_PERFORMED` | `NOT_PERFORMED` for provider/location/transfer questions |
| AF-SEC-008 | Audit security | `NOT_STARTED` | `NOT_PERFORMED` | `NOT_PERFORMED`; legal retention/visibility remains unresolved |
| AF-SEC-009 | Owner recovery | `NOT_STARTED` | `NOT_PERFORMED` | `NOT_PERFORMED`; recovery evidence remains unresolved |
| AF-SEC-010 | Offboarding and suspension | `NOT_STARTED` | `NOT_PERFORMED` | `NOT_PERFORMED`; employment/privacy questions remain unresolved |
| AF-PRIV-001 | Payroll/customer visibility facts and risk | `NOT_STARTED` | `NOT_PERFORMED` | `NOT_PERFORMED`; Owner cannot issue legal conclusion |
| AF-PRIV-002 | Pre-employment/offboarding facts and risk | `NOT_STARTED` | `NOT_PERFORMED` | `NOT_PERFORMED`; Owner cannot issue legal conclusion |
| AF-PRIV-003 | Recovery-evidence facts and risk | `NOT_STARTED` | `NOT_PERFORMED` | `NOT_PERFORMED`; Owner cannot issue legal conclusion |
| AF-PRIV-004 | Audit retention/legal-hold facts and risk | `NOT_STARTED` | `NOT_PERFORMED` | `NOT_PERFORMED`; Owner cannot issue legal conclusion |
| AF-PRIV-005 | Export/anonymization facts and risk | `NOT_STARTED` | `NOT_PERFORMED` | `NOT_PERFORMED`; Owner cannot issue legal conclusion |

## 3. Assessment initiation and evidence control

To start a scope, the Owner creates a new record from the reusable template with a unique `AF-OWNER-*` ID and links the historical AF-SEC/AF-PRIV record. The record must contain:

- Owner identity in the project role and explicit statement that Owner is also developer;
- actual start date and assessment scope/exclusions;
- technical-design/version baseline and source commit or immutable artifact hashes;
- environment and configuration under review;
- evidence manifest distinguishing design, implementation, test, staging, operations, and professional/legal evidence;
- current `independent_verification: NOT_PERFORMED` and `legal_review: NOT_PERFORMED` where applicable;
- known blockers and BA-01 through BA-08 dependencies.

Only then may `owner_review_status` move to `OWNER_REVIEW_IN_PROGRESS`.

Evidence records include artifact ID, origin, version/hash, environment, command or inspection method, actual result, date, limitations, and retention location. Screenshots/prose without reproducible source are supporting context only. No live secret or unnecessary personal/payroll/customer data belongs in assessment evidence.

## 4. Owner-led assessment procedure

### 4.1 Evidence inspection

1. Map each acceptance criterion to Owner decision, technical requirement, threat, and evidence ID.
2. Confirm that an artifact described as implemented or tested actually exists at the recorded version/environment.
3. Inspect dependency versions, configuration, schema/constraints, module interfaces, request paths, database privileges, logs/audit, runbooks, deployment facts, and monitoring appropriate to the scope.
4. Record missing evidence as `NOT_TESTED` or a blocker—never pass by design intent.
5. Preserve raw command output or machine-readable report where safe; summarize without altering the original.

### 4.2 Threat and abuse-case assessment

For each scope, start from the [Threat Model](after_four_security_threat_model.md) and [Review Package](after_four_identity_security_review_package.md). Record:

- protected assets and trust seams;
- threat actor, preconditions, entry point, abused action, and impact;
- cross-Branch/vertical escalation, self-approval, stale privilege, replay, concurrency, partial-failure, denial, privacy, and recovery cases where relevant;
- prevention, detection, containment, recovery, and residual exposure;
- assumptions that require infrastructure, provider, business, or legal facts.

New threats receive stable IDs and remain traceable through findings, tests, remediation, and residual-risk decisions.

### 4.3 Code and configuration review

When implementation is separately authorized and exists, inspect through the deep module interfaces defined by the [Technical Design](after_four_identity_technical_design.md): Authorization, Credentials, Sessions, Authentication Defense, Identity Lifecycle, Audit Append, and Audit Read/Export.

Review request middleware/controllers, policies, transactions/locks, persistence constraints, dependency configuration, cookie/CSRF/origin/Host behavior, rate limits, secret handling, database roles, audit redaction, jobs/outbox, deployment configuration, and failure handling. Search for alternate paths, direct persistence writes, client-trusted scope, broad rescue/fallback, logging of secrets, disabled protections, and environment drift.

Code review is not possible before code exists. A design-only review must remain identified as such and cannot satisfy implementation criteria.

### 4.4 Automated security testing

Execute and retain, as applicable:

- focused and full RSpec suites with recorded random seed;
- role/capability/Branch authorization matrix and IDOR tests;
- credential, MFA, recovery, session, lifecycle, and audit positive/negative/boundary tests;
- independent-connection/process concurrency and failure-injection tests;
- cookie/CSRF/origin/Host/browser tests;
- rate-limit distributed/source-rotation/backend-outage tests;
- database constraint/privilege/immutability tests;
- RuboCop, Brakeman, Bundler Audit, dependency compatibility, and secret/log-redaction checks;
- production-like hashing/load benchmarks;
- deployment/proxy/TLS/network tests in an approved production-parity environment;
- backup/restore, audit checkpoint, recovery/offboarding drill evidence where applicable.

Record commands, versions, environment, raw result artifact, failures, skipped tests, and limitations. A passing scanner is not a complete security conclusion.

### 4.5 Manual negative and boundary testing

Use synthetic identities/data and a controlled environment. Attempt unauthorized role/Branch/resource substitution, self-approval, expired/revoked state, replay, duplicate idempotency, exact timeout/threshold edges, malformed/oversized input, alternate endpoints/methods, concurrent revoke/use, partial failure, foreign Origin/Host, proxy-header spoofing, direct-origin access, secret/log leakage, and recovery/notification failure as relevant.

Record a safe reproduction, expected result, actual result, evidence ID, cleanup, and any test limitation. Testing authorization and safety controls remain required even though the Owner is the reviewer.

### 4.6 Findings and severity

| Severity | Owner-led rule |
|---|---|
| Critical | Credible broad/Owner compromise, cross-Organization exposure, unrecoverable integrity loss, or systematic severe bypass. Block completion and production use; remediate before proceeding. |
| High | Credible privileged compromise, cross-Branch action/data exposure, recovery/session/audit/deployment trust failure with material impact. Remediation and retest are expected; residual acceptance requires exceptional explicit rationale. |
| Medium | Meaningful weakness requiring correction before production or a documented, time-bounded compensating control with retest trigger. |
| Low | Limited-impact weakness or hardening/evidence gap with tracked remediation/condition. |
| Observation | Improvement or uncertainty without demonstrated vulnerability. It cannot hide a failed or untested criterion. |

Each finding records ID, scope, affected decision/requirement, evidence, preconditions/reproduction, impact, severity rationale, remediation, compensating controls, retest plan/result, status, and residual risk. The Owner must not delete or silently downgrade a finding because the Owner authored the affected design/code.

### 4.7 Remediation and retesting

Move to `REMEDIATION_REQUIRED` when a finding or failed criterion needs correction. Link the remediation change and new evidence; rerun the focused reproduction plus relevant regression/full checks. Record whether the finding is resolved, partially resolved, unchanged, superseded, or converted to an explicit residual-risk acceptance. Self-retest is acknowledged as non-independent.

### 4.8 Explicit residual-risk acceptance

`OWNER_ACCEPTED_RESIDUAL_RISK` requires a signed/equivalent Owner statement containing:

- risk/finding IDs and exact unresolved condition;
- affected assets, users, Branches, data, environments, and operations;
- evidence examined and evidence missing;
- likelihood/impact rationale and uncertainty;
- compensating controls and monitoring;
- why remediation is deferred or rejected;
- production restrictions, expiry/review trigger, and action owner;
- explicit acknowledgment that Owner is developer/reviewer/risk acceptor;
- explicit acknowledgment of no independent verification;
- confirmation that acceptance is technical/security risk only and is not legal advice, compliance, or waiver.

Critical risks, missing legal authority, unknown statutory obligations, and business permissions not granted by BA-01 through BA-08 cannot be made safe or authorized merely by residual-risk acceptance.

## 5. Completion criteria and canonical checklist interaction

An Owner-led scope may reach `OWNER_REVIEW_COMPLETED` only when every criterion is `PASS` or explicitly `NOT_APPLICABLE` with evidence/rationale, every finding is remediated/retested, all limitations are recorded, and no blocker remains. A scope with accepted unresolved risk uses `OWNER_ACCEPTED_RESIDUAL_RISK`, not `OWNER_REVIEW_COMPLETED`, unless the record clearly distinguishes which criteria passed and which risk remains.

The canonical checklist remains the evidence gate. Any later row update must link the Owner-led record, identify it as non-independent, preserve legal limitations, and not use “professionally reviewed,” “certified,” or “independently verified.” ADR-0006 remains Proposed until its separate acceptance conditions are genuinely satisfied and recorded.

## 6. Legal and privacy limitation

ID-20 changes who performs technical/security review; it does not create legal competence or legal conclusions. Owner residual-risk acceptance:

- cannot waive statutory, regulatory, contractual, employment, tax/accounting, privacy, incident, evidence-preservation, or data-subject obligations;
- cannot establish that processing is lawful, compliant, necessary, proportionate, or adequately disclosed;
- cannot set a legally valid retention period, legal-hold rule, export basis, cross-border transfer condition, or anonymization standard by itself;
- cannot authorize production processing that otherwise lacks required legal/business authority.

The following remain unverified and should be resolved before production processing of relevant personal, candidate, employee, payroll, customer, recovery, device/network, or audit data:

1. applicable current Vietnamese privacy/data-protection, employment, payroll/accounting/tax, dispute, security-incident, and evidence-preservation obligations;
2. purposes, lawful grounds, notices, transparency, minimization, access/correction and other applicable rights;
3. payroll/customer field visibility and self-investigation rules;
4. candidate/pre-employment, suspension, offboarding, rehire, and historical-record handling;
5. recovery proof/custodian data collection, access, storage, disclosure, incident, and disposition;
6. session/device/network/anomaly monitoring proportionality, notice, access, and retention;
7. class-specific audit retention bounds and deletion/anonymization action;
8. legal/investigation hold authority, scope, release, and conflict with disposition;
9. export purpose, recipient, approval, protection, onward disclosure, expiry/destruction, and transfer rules;
10. anonymization sufficiency and re-identification risk;
11. provider/processor contracts, data location, cross-border transfer, subcontractor, breach, and deletion obligations;
12. food-service, financial, customer, or other regulated-data duties implicated by future scope.

Under the current no-legal-review approach, these questions remain `NOT_PERFORMED` and are blockers for any production use that depends on their resolution. The Owner may reconsider qualified legal advice later without changing ID-20's record of the current approach.

## 7. Business authority boundary

BA-01 through BA-08 in the [Professional Review Engagement Package](after_four_identity_professional_review_engagement.md#7-outstanding-owner-business-authority-decisions) remain unresolved. Owner-led security assessment may identify threats or recommend controls, but it does not silently grant inventory/procurement, refund/cash, catalog, audit-read/export, or payroll/customer visibility permissions. Each requires a separate explicit Owner business decision and canonical synchronization.

## 8. Completion boundary

This protocol governs current and future Owner-led review. AF-OWNER-001 has begun and records design/repository inspection, attempted checks, findings, and missing evidence; it is not complete and accepts no residual risk. No professional/legal review has occurred, no canonical checklist status changed, and no implementation was authorized. Milestone 2B remains unauthorized.
