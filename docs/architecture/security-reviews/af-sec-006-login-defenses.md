---
review_id: AF-SEC-006
review_type: security
status: open
review_date: null
---

# AF-SEC-006: Login Defenses Review

**Sequence:** 2 — MFA, authentication defenses, and recovery  
**Final status:** `OPEN` — unchanged from the canonical checklist  
**Reviewer identity:** Not provided  
**Reviewer qualification:** Not provided  
**Review date:** Not started; no review date recorded

## Scope and confirmed policy

Review rate-limit keys, thresholds/windows, progressive delay, temporary lock/release, distributed storage, generic responses/timing, alternate-path coverage, trusted source derivation, `Retry-After`, and monitoring. Owner policies: ID-07, ID-11, and ID-15. Failure alone cannot permanently lock an account; email is not a login identifier.

## Evidence record

Available inputs are [review package §4.6](../after_four_identity_security_review_package.md#46-login-defenses), the [Threat Model](../after_four_security_threat_model.md), and [API Error Catalog](../after_four_api_error_catalog.md). No reviewer examination is recorded. Numeric limits, keys/signals, distributed state, proxy-derived source, endpoint inventory, timing measurements, concurrency tests, and operations runbook are absent.

## Findings, remediation, and recommendation

| Item | Record |
|---|---|
| Findings and severity | No professional finding recorded; severity is not assessed. |
| Required remediation | Select threat-based keys/limits/reset rules; cover every authentication/recovery route; execute enumeration/timing, spoofed-source, distributed rotation, exact-window, atomic-counter, and unlock-race evidence from package §4.6. |
| Reviewer recommendation | Not available; no reviewer is assigned and no review has started. |

## Acceptance criteria

A qualified reviewer must approve limits and reset behavior, verify publicly equivalent contracts, distributed atomicity, alternate-route coverage, trusted source derivation, monitoring, residual risks, and production conditions.

## Next action

Prepare the limiter and source-trust design, then assign an independent application-security reviewer. This record remains `OPEN`.
