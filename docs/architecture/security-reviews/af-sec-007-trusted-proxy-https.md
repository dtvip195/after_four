---
review_id: AF-SEC-007
review_type: security
status: blocked
review_date: null
---

# AF-SEC-007: Trusted Proxy and HTTPS Review

**Sequence:** 6 — Production HTTPS and trusted-proxy topology  
**Final status:** `BLOCKED` — unchanged from the canonical checklist  
**Reviewer identity:** Not provided  
**Reviewer qualification:** Not provided  
**Review date:** Not started; no review date recorded

## Scope and confirmed policy

Review TLS termination, edge/origin path, trusted proxy set, forwarding-header ownership, client-IP derivation, `force_ssl`/HSTS, Host Authorization, direct-origin denial, private connectivity, safe health exposure, monitoring, and change control. Owner policies: ID-07 and ID-17. No hosting, CDN, edge, domain, or authentication vendor is selected.

## Evidence record

Available inputs are [review package §4.7](../after_four_identity_security_review_package.md#47-trusted-proxy-and-https), [ADR-0006](../adr/0006-authentication-session-topology.md), and the [Threat Model](../after_four_security_threat_model.md). No reviewer examination is recorded. Hosting/domain/DNS, actual hops/CIDRs, network controls, infrastructure configuration, production-parity staging, external tests, monitoring, ownership, and rollback evidence are absent.

## Findings, remediation, and recommendation

| Item | Record |
|---|---|
| Findings and severity | No professional finding recorded; severity is not assessed. |
| Required remediation | Obtain Owner-approved deployment choices; document every hop/trust boundary; execute TLS/Host/header/source/direct-origin/health tests and rolling-change failure evidence from package §4.7. |
| Reviewer recommendation | Not available; the real topology does not exist for review. |

## Acceptance criteria

An external infrastructure/application-security reviewer must examine the real production-parity path, exact configuration and firewall evidence, executed adversarial header/Host/TLS tests, monitoring and rollback, findings, residual risks, and production conditions.

## Next action

Owner/operations must select deployment facts before a review can start. This record remains `BLOCKED`.
