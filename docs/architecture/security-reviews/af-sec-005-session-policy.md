---
review_id: AF-SEC-005
review_type: security
status: open
review_date: null
---

# AF-SEC-005: Session Policy Review

**Sequence:** 3 — Cookie, CSRF, session rotation, and revocation  
**Final status:** `OPEN` — unchanged from the canonical checklist  
**Reviewer identity:** Not provided  
**Reviewer qualification:** Not provided  
**Review date:** Not started; no review date recorded

## Scope and confirmed policy

Review server-enforced idle/absolute expiry, POS lock/reauthentication, multi-device sessions, visibility, anomaly/notification controls, individual and all-session revocation, current authorization, lifecycle invalidation, cleanup, clock behavior, and races. Owner policies: ID-03, ID-04, ID-05, ID-15, and ID-19. No numeric MVP cap is allowed.

## Evidence record

Available inputs are [review package §4.5](../after_four_identity_security_review_package.md#45-session-policy), [State Machines](../after_four_state_machines.md), and [ADR-0006](../adr/0006-authentication-session-topology.md). No reviewer examination is recorded. Storage, token lookup, renewal/activity rules, inventory privacy, notification/anomaly rules, transaction design, implementation, concurrency evidence, cleanup, and revocation drill are absent.

## Findings, remediation, and recommendation

| Item | Record |
|---|---|
| Findings and severity | No professional finding recorded; severity is not assessed. |
| Required remediation | Decide activity/renewal/revocation/privacy rules; execute exact timeout, multi-session, current-scope, all-session, lifecycle, monotonic-update, cleanup, and independent-connection race evidence from package §4.5 after authorization. |
| Reviewer recommendation | Not available; no reviewer is assigned and no review has started. |

## Acceptance criteria

A qualified reviewer must verify exact timeout edges, independent session behavior, secret-free inventory, immediate Owner/lifecycle revocation, deterministic concurrency semantics, cleanup/retention compatibility, residual risks, and production monitoring conditions.

## Next action

Prepare the detailed state/transaction design and assign an independent reviewer. This record remains `OPEN`.
