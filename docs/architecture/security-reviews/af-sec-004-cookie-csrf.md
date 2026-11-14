---
review_id: AF-SEC-004
review_type: security
status: blocked
review_date: null
---

# AF-SEC-004: Cookie and CSRF Review

**Sequence:** 3 — Cookie, CSRF, session rotation, and revocation  
**Final status:** `BLOCKED` — unchanged from the canonical checklist  
**Reviewer identity:** Not provided  
**Reviewer qualification:** Not provided  
**Review date:** Not started; no review date recorded

## Scope and confirmed policy

Review cookie scope/flags, session-token entropy/verifier storage, Rails cookie/CSRF middleware, origin checks, rotation/revocation, CORS absence, cache controls, logout, and real-browser behavior. Owner policies: ID-03, ID-04, ID-05, ID-17, and ID-19. Production uses one HTTPS origin and private Rails origin; exact implementation is unselected.

## Evidence record

Available inputs are [review package §4.4](../after_four_identity_security_review_package.md#44-cookie-and-csrf), [ADR-0006](../adr/0006-authentication-session-topology.md), and the [API Contract](../after_four_api_contract.md). No reviewer examination is recorded. No exact deployed topology, middleware/configuration, browser harness, token design, implemented rotation, or executed real-path tests exist.

## Findings, remediation, and recommendation

| Item | Record |
|---|---|
| Findings and severity | No professional finding recorded; severity is not assessed. |
| Required remediation | Define middleware/token/cookie/cache behavior and actual topology; if separately authorized, implement and execute same-/foreign-origin, all-unsafe-verb, fixation, old-token, logout, rotation-race, CORS, and browser evidence from package §4.4. |
| Reviewer recommendation | Not available; deployed-path prerequisites are missing. |

## Acceptance criteria

An independent web-security reviewer must verify exact configuration, browser and request evidence through the real edge, raw-token exclusion, CSRF/origin behavior, rotation/revocation races, residual risks, and production conditions.

## Next action

Record the deployment design and proposed middleware controls before assigning review. This record remains `BLOCKED`.
