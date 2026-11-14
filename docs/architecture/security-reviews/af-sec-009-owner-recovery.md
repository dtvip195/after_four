---
review_id: AF-SEC-009
review_type: security
status: blocked
review_date: null
---

# AF-SEC-009: Owner Recovery Review

**Sequence:** 2 — MFA, authentication defenses, and recovery  
**Final status:** `BLOCKED` — unchanged from the canonical checklist  
**Reviewer identity:** Not provided  
**Reviewer qualification:** Not provided  
**Review date:** Not started; no review date recorded

## Scope and confirmed policy

Review factors/proofs, assurance, dual control, custodians, offline material custody/rotation, normal and Owner-unavailable emergency paths, delays/escalation, implementation/provider, notifications, session/factor revocation, monitoring/audit, drills, and privacy. Owner policies: ID-06 and ID-16. A Branch Manager cannot independently recover Owner; no provider is selected.

## Evidence record

Available inputs are [review package §4.9](../after_four_identity_security_review_package.md#49-owner-recovery), [ADR-0006](../adr/0006-authentication-session-topology.md), and the [Threat Model](../after_four_security_threat_model.md). No reviewer examination is recorded. Proof types, custodians, storage/rotation, implementation, emergency procedure, notification, monitoring, runbooks, tabletop/drill, executed tests, and privacy opinion are absent.

## Findings, remediation, and recommendation

| Item | Record |
|---|---|
| Findings and severity | No professional finding recorded; severity is not assessed. |
| Required remediation | Approve exact assurance/proof/custody and emergency design without selecting a vendor here; complete recovery-evidence privacy review; execute single-actor denial, replay, custodian, parallel-recovery, revocation, notification, partial-failure, tabletop, and drill evidence from package §4.9. |
| Reviewer recommendation | Not available; the recovery procedure is not defined. |

## Acceptance criteria

An external identity-security specialist must verify independent proofs/factors and dual control, custody and rotation, fail-closed behavior, complete revocation/notification/audit, controlled drill evidence, findings, residual risks, and production conditions. Qualified legal/privacy review of recovery evidence is required.

## Next action

Name authorized custodians and reviewers and prepare the exact procedure and privacy input. This record remains `BLOCKED`.
