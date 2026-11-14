---
review_id: AF-SEC-010
review_type: security
status: blocked
review_date: null
---

# AF-SEC-010: Offboarding and Suspension Review

**Sequence:** 5 — Account lifecycle and offboarding  
**Cross-cutting sequence dependency:** 4 — capability enforcement, Branch scope, and delegation  
**Final status:** `BLOCKED` — unchanged from the canonical checklist  
**Reviewer identity:** Not provided  
**Reviewer qualification:** Not provided  
**Review date:** Not started; no review date recorded

## Scope and confirmed policy

Review authentication-lock release, Owner-controlled suspension/reactivation/deactivation, explicit rehire, Role/Branch Assignment ending, session/PIN/MFA/recovery/device/delegation/invitation revocation, history preservation, failure/retry behavior, Owner-unavailable procedure, and races. Owner policies: ID-05, ID-09, ID-14, ID-15, and ID-19.

## Evidence record

Available inputs are [review package §4.10](../after_four_identity_security_review_package.md#410-offboarding-and-suspension), [State Machines](../after_four_state_machines.md), and [Data Integrity Rules](../after_four_data_integrity_rules.md). No reviewer examination is recorded. Exact transaction/failure design, suspension assignment policy, lock release, Owner-unavailable procedure, implementation, complete access inventory, failure injection, concurrency tests, monitoring, and HR/legal/privacy input are absent.

## Findings, remediation, and recommendation

| Item | Record |
|---|---|
| Findings and severity | No professional finding recorded; severity is not assessed. |
| Required remediation | Approve exact lifecycle/failure/Owner-unavailable procedures; if authorized, implement and execute authority denial, full revocation, future-grant, delegation/invitation, history, explicit reactivation/rehire, concurrent mutation, and injected-partial-failure evidence from package §4.10. |
| Reviewer recommendation | Not available; operational and implementation prerequisites are missing. |

## Acceptance criteria

An independent security reviewer must verify Owner-only authority, complete fail-closed access removal, deterministic races/retries, explicit audited restoration, preservation of history, monitoring/recovery, findings, residual risks, and production conditions. Relevant HR/legal/privacy conclusions must be recorded.

## Next action

Approve lifecycle and Owner-unavailable procedures and obtain HR/legal/privacy input before starting review. This record remains `BLOCKED`.
