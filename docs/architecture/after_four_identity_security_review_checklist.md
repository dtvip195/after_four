# AFTER FOUR Identity Security Review Checklist

**Status:** Not completed; every item is Open or Blocked  
**Date:** 2026-11-14  
**Purpose:** Control Acceptance evidence gate for eventual acceptance of [ADR-0006](adr/0006-authentication-session-topology.md). This checklist does not provide ADR Design Baseline Approval, Bounded Implementation Authorization, or Final Operational Acceptance.
**Related:** [Owner Decision Register](after_four_identity_decision_register.md) · [Owner-Led Review Protocol](after_four_identity_owner_led_review_protocol.md) · [Identity & Branch Authorization](after_four_identity_authorization.md) · [Threat Model](after_four_security_threat_model.md)

## Status meanings

- `OPEN`: no review evidence has been supplied.
- `IN_REVIEW`: named assessor and evidence are linked, but acceptance criteria are not all satisfied. Under ID-20, the assessor is the Owner and the review is non-independent.
- `ACCEPTED`: assessor, date, evidence, findings/remediation, residual risks, and production conditions are recorded. Any Owner-led acceptance must be labeled non-independent and does not imply legal review.
- `BLOCKED`: a prerequisite policy, environment, or implementation decision is missing.

Nothing in this document is `ACCEPTED` merely because the Owner approved the related operating policy.

### Owner-led status overlay

ID-20 uses separate assessment records with `NOT_STARTED`, `OWNER_REVIEW_IN_PROGRESS`, `OWNER_REVIEW_COMPLETED`, `REMEDIATION_REQUIRED`, `OWNER_ACCEPTED_RESIDUAL_RISK`, or `BLOCKED`. These statuses do not alter a checklist row by themselves. Independent verification and legal review are separate axes and remain `NOT_PERFORMED` unless real qualified review occurs.

## Review checklist

| Area | Issue to review | Risk if misconfigured | Acceptance criteria | Current status |
|---|---|---|---|---|
| Password hashing | Algorithm, maintained library, parameters, salts, input limits, calibration, parameter versioning, and rehash path. Argon2id is only a technical proposal. | Offline cracking, denial of service from excessive cost/input, or hashes that cannot be upgraded safely. | Reviewer records dependency/version; benchmarks production-like hardware; approves cost and maximum input; unique salts and no plaintext/reversible storage; successful-login rehash path and tests are evidenced. | `OPEN` |
| PIN protection | Individual PIN length/format, separate digest, retry budget, progressive delay, device/account/source rate limits, enumeration resistance, and recovery. | Fast online/offline guessing, shared accountability, targeted denial of service, or PIN use outside its allowed boundary. | No shared PIN; PIN cannot perform privileged/recovery actions; reviewer approves hashing and numeric limits; distributed-guess and alternate-endpoint tests pass; logs/audit contain no PIN. | `OPEN` |
| MFA | Sensitive-capability enumeration, factor type, enrollment, verification, step-up, factor replacement/removal, recovery, and secret storage. | Privileged takeover, MFA bypass through recovery, or unrecoverable privileged accounts. | Owner and every Branch Manager capability classified; mandatory enforcement tested; enrollment/replacement require strong proof; factor secrets/recovery codes protected; recovery cannot silently remove evidence. | `BLOCKED` — policy scope is approved, but capability enumeration and factor method are not selected or reviewed |
| Cookie and CSRF | Cookie name/flags/scope, token entropy/verifier storage, origin checks, Rails CSRF behavior, rotation, revocation, cache controls, and logout. | Session theft/fixation, cross-site mutation, stale privilege, or secret leakage. | Host-only `Secure`, `HttpOnly`, approved `SameSite`, `Path=/`; raw token absent from storage/logs; all unsafe methods reject missing/foreign CSRF; rotation and copied-old-token tests pass in deployed topology. | `BLOCKED` — one-origin policy is approved, but exact deployed topology and controls are not selected or reviewed |
| Session policy | Back-office 30-minute idle/12-hour absolute limits, POS 2-minute lock and reauthentication, multiple-device sessions, all-session revocation, server clocks, renewal, and concurrent requests. | Sessions outlive policy, POS remains unattended, race permits revoked use, or users are unexpectedly signed out. | Server-enforced boundary tests cover exact timeout edges and concurrent requests; POS reauthentication proof is approved; session/device views expose no secrets; Owner all-session revocation is immediate and tested. | `OPEN` |
| Login defenses | Rate-limit keys, progressive-delay schedule, distributed storage, generic errors/timing, reset conditions, and no permanent failure-only lock. | Credential/PIN stuffing, account enumeration, proxy bypass, or attacker-triggered permanent denial of service. | Reviewer approves thresholds/windows and reset/unlock; known/unknown/inactive accounts have equivalent public contracts; distributed/source-rotation tests pass; `Retry-After` and monitoring are verified. | `OPEN` |
| Trusted proxy and HTTPS | TLS termination, `force_ssl`, HSTS, forwarded-header trust, client-IP derivation, host authorization, and direct-origin access. | Cookie downgrade, spoofed rate-limit/audit source, Host-header attacks, or bypass of HTTPS controls. | Exact proxy CIDRs/config are documented; untrusted forwarded headers ignored; direct HTTP/origin bypass blocked; host/TLS/HSTS checks pass in staging; source derivation supports limiter/audit safely. | `BLOCKED` — hosting/vendor, proxy chain, CIDRs, and private-connectivity implementation are not selected or reviewed |
| Audit security | Event coverage, restricted readers, append-only database privileges, state-change atomicity, redaction, integrity evidence, exports/backups, retention, and privacy. | Fraud or escalation evidence can be changed, secrets/PII leak, or required evidence expires too early. | Required events mapped to tests; application role cannot update/delete; sensitive mutation and audit commit atomically; read/export access audited; redaction tests pass; retention and legal/privacy policy approved. | `BLOCKED` — retention/legal policy not approved |
| Owner recovery | Separate Owner procedure, identity proofing, emergency contacts, second-person controls, recovery factors, lost-all-factors case, notification, revocation, and drill ownership. | Permanent chain lockout or attacker obtains the highest privilege through support/recovery. | Written runbook names authorized parties and proof; no sole reliance on inaccessible account; recovery revokes sessions/factors, requires strong evidence, alerts affected parties, produces audit, and is exercised in a controlled drill. | `BLOCKED` — policy principles are approved, but exact proofs, custodians, implementation, emergency procedure, and drill evidence are not defined or reviewed |
| Offboarding and suspension | Authority and timing for suspension/deactivation/reactivation; atomic ending of Role/Branch Assignments; session/invite/recovery/PIN/MFA revocation; failure handling. | Former or suspended workers retain access, or history is destroyed. | State authority is approved; access removal fails closed; concurrent-session and future-assignment tests pass; history remains immutable; partial failure is observable and recoverable without reopening access. | `BLOCKED` — lifecycle authority is approved, but enforcement design, lock release, Owner-unavailable procedure, and test evidence are not reviewed |

## Evidence record

For every item moved from `OPEN`/`BLOCKED`, record:

- assessor identity and role, including that the Owner is also developer under ID-20;
- review date and environment;
- configuration, design, test, benchmark, or runbook links;
- acceptance criteria results;
- findings, remediation/retest, residual risks, and compensating controls;
- conditions that must remain true in production;
- follow-up owner and due date.

## ADR acceptance gate

This checklist governs Gate C — Control Acceptance. ADR Design Baseline Approval and Bounded Implementation Authorization are separate upstream gates. They do not change checklist status, constitute executed evidence, accept residual risk, or prove that a control operates correctly.

ADR-0006 may move from Proposed to Accepted only when every applicable row is evidence-backed, every `BLOCKED` prerequisite is resolved, cross-document terminology is consistent, and each record identifies the assessor and executed verification. Owner-led completion must remain explicitly non-independent. Legal/privacy prerequisites cannot be satisfied by Owner technical-risk acceptance. As of 2026-11-14, the checklist has no completed security-review evidence.

Completion of applicable Control Acceptance does not by itself authorize production deployment. Final Operational Acceptance separately requires the applicable deployment, monitoring, incident-response, production-condition, and legal/privacy prerequisites.
