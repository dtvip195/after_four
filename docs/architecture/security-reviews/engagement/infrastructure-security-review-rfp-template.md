# AFTER FOUR Infrastructure Security Review Request Template

**Template status:** Reusable; complete bracketed fields before issue  
**Primary record:** [AF-SEC-007](../af-sec-007-trusted-proxy-https.md)  
**Governing package:** [Professional Review Engagement](../../after_four_identity_professional_review_engagement.md)

## 1. Request identity

- Request ID: `[OWNER-ASSIGNED]`
- Supporting reviews: `[AF-SEC-004 / AF-SEC-006 / OTHER APPROVED IDS]`
- Proposed topology version: `[ARTIFACT ID]`
- Proposal contact/submission method: `[OWNER-DESIGNATED]`
- Reviewer-proposed schedule and fees: `[RESPONDENT TO PROVIDE]`

No provider, domain, edge, or reviewer is selected by this template.

## 2. Scope

Review the actual proposed one-origin architecture: DNS, TLS/certificate lifecycle, managed edge, routing, private Rails origin, proxy-hop order and CIDRs, forwarding-header replacement/trust, client-source derivation, Host Authorization, HTTPS assumptions/HSTS, direct-origin denial, private database/worker access, secret management, health/readiness exposure, monitoring, change/rollback, and incident access.

Explicit exclusions unless separately added:

- vendor/provider selection or procurement recommendation;
- application authentication acceptance beyond topology-dependent evidence;
- legal/privacy conclusions about providers or transfers;
- production-disruptive testing;
- implementation authorization.

## 3. Required evidence and demonstrations

- versioned public/private topology and data-flow diagram;
- asset, DNS, certificate, port, hop, CIDR, Host, header-owner, and network-policy inventory;
- redacted edge/origin/Rails/firewall/security-group/secret/health/monitoring configuration;
- production-parity staging and documented differences;
- direct-origin and HTTP denial demonstration;
- forged, duplicate, and multi-hop forwarding-header tests;
- client-source derivation through every application instance;
- TLS/HSTS/certificate renewal and foreign-Host tests;
- CORS/Origin/CSRF behavior through the edge with AppSec support;
- private database/worker reachability tests;
- safe health output and dependency timeout behavior;
- rolling certificate/CIDR/configuration change and rollback evidence;
- monitoring/alert and incident-access evidence.

The reviewer must identify which claims cannot be evaluated until a real production-parity environment exists.

## 4. Required deliverables

1. Reviewer-validated topology and trust-boundary diagram.
2. Evidence/configuration inventory with versions and limitations.
3. Findings with affected hop/configuration, severity, safe reproduction, impact, remediation, and retest.
4. Real-path test report and explicit staging/production differences.
5. Operational review of ownership, certificate/CIDR/secret changes, monitoring, rollback, and incident access.
6. Acceptance-criterion matrix for AF-SEC-007 and mapped support evidence for AF-SEC-004/006.
7. Final independent recommendation and production conditions.

## 5. Safety and independence

Testing plan requires Owner/operations approval, non-production preference, stop conditions, source addresses, rate limits, monitoring contact, rollback, and incident handling. Never request raw production secrets. Disclose hosting/CDN/security-product commercial relationships and prior topology implementation. A reviewer who built/operates the topology cannot provide sole acceptance.

Submit the [Qualification Questionnaire](reviewer-qualification-questionnaire.md), [Conflict Declaration](conflict-of-interest-declaration.md), and evidence-handling response. Use the shared severity, remediation, disagreement, and completion rules from the engagement package.
