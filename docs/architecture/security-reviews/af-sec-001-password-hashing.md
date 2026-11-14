---
review_id: AF-SEC-001
review_type: security
status: open
review_date: null
---

# AF-SEC-001: Password Hashing Review

**Sequence:** 1 — Password and PIN cryptographic design  
**Final status:** `OPEN` — unchanged from the canonical checklist  
**Reviewer identity:** Not provided  
**Reviewer qualification:** Not provided  
**Review date:** Not started; no review date recorded

## Scope and confirmed policy

Review algorithm/library selection, parameters, salts, input bounds, calibration, compromised-password handling, parameter versioning, rehash, reset, and secret exclusion. Owner policies: ID-06, ID-07, ID-11, and ID-15 in the [Decision Register](../after_four_identity_decision_register.md). Argon2id and the proposed password rules are technical proposals, not confirmed selections.

## Evidence record

Available design inputs are [review package §4.1](../after_four_identity_security_review_package.md#41-password-hashing), [ADR-0006](../adr/0006-authentication-session-topology.md), the [Threat Model](../after_four_security_threat_model.md), and [Testing Standards](../../development/after_four_testing_standards.md). No reviewer has recorded examining them. No selected dependency, production-like benchmark, implemented storage, executed identity tests, log inspection, or operational runbook exists.

## Findings, remediation, and recommendation

| Item | Record |
|---|---|
| Findings and severity | No professional finding recorded; severity is not assessed. |
| Required remediation | Select a maintained design; benchmark production-like hardware; implement only after separate authorization; execute positive, negative, boundary, rehash/reset-race, storage, and redaction evidence from package §4.1. |
| Reviewer recommendation | Not available; no reviewer is assigned and no review has started. |

## Acceptance criteria

A named qualified reviewer must record the selected dependency/version and benchmark, approve parameters and input limits, verify salted digest-only storage and upgrade behavior, examine executed reset/session/redaction tests, resolve or explicitly accept findings, state residual risks and production conditions, and recommend acceptance.

## Next action

Assign an independent application-security reviewer and supply the selected design plus executed evidence. This record must remain `OPEN` until then.
