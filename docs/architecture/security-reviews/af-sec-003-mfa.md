---
review_id: AF-SEC-003
review_type: security
status: blocked
review_date: null
---

# AF-SEC-003: MFA and Step-up Review

**Sequence:** 2 — MFA, authentication defenses, and recovery  
**Cross-cutting sequence dependency:** 4 — capability enforcement, Branch scope, and delegation  
**Final status:** `BLOCKED` — unchanged from the canonical checklist  
**Reviewer identity:** Not provided  
**Reviewer qualification:** Not provided  
**Review date:** Not started; no review date recorded

## Scope and confirmed policy

Review explicit capability classification, factor method, enrollment, verification, step-up freshness, replacement/removal, recovery, secret storage, delegation interaction, and Branch authorization. Owner policies: ID-02, ID-13, ID-14, and ID-16. Owner and every Branch Manager require MFA; sensitive Branch Manager capabilities require step-up; MFA cannot widen Branch or delegation scope.

## Evidence record

Available inputs are [review package §4.3](../after_four_identity_security_review_package.md#43-mfa), [Identity & Branch Authorization](../after_four_identity_authorization.md), and the [Threat Model](../after_four_security_threat_model.md). No reviewer examination is recorded. The ordinary/sensitive capability matrix, factor technology, step-up policy, enrollment/recovery design, key custody, device results, implementation, and executed tests are absent. No vendor is selected.

## Findings, remediation, and recommendation

| Item | Record |
|---|---|
| Findings and severity | No professional finding recorded; severity is not assessed. |
| Required remediation | Enumerate capabilities without inventing business authority; select and threat-model factors/step-up/recovery; produce enrollment, replay, downgrade, replacement, Branch-scope, delegation, boundary, and concurrency evidence from package §4.3. |
| Reviewer recommendation | Not available; the prerequisites for starting review are incomplete. |

## Acceptance criteria

A named identity-security reviewer must approve the capability/factor design, examine phishing/replay and secret-custody evidence, verify mandatory enforcement and Branch/delegation boundaries, resolve findings, and record residual risks and production conditions.

## Next action

Complete capability enumeration and a vendor-neutral factor design, then assign an independent identity-security reviewer. This record remains `BLOCKED`.
