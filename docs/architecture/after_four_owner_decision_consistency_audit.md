---
audit_id: AF-DOC-AUDIT-001
document_status: READ_ONLY_AUDIT_COMPLETE
decision_changes_authorized: false
implementation_authorized: false
milestone_2b_status: NOT_AUTHORIZED
independent_verification: NOT_PERFORMED
---

# AFTER FOUR — Owner Decisions and Repository Documentation Consistency Audit

> **HISTORICAL AUDIT SNAPSHOT.** This read-only audit reports repository evidence available at audit time and remains preserved. Its gaps and status counts are not the current decision source. Use the later canonical [Owner Decision Baseline](after_four_owner_decision_baseline.md) for Owner-confirmed business decisions and the [DDD Foundation](after_four_ddd_foundation.md) for proposed architecture alignment. The late-success dispatch gap identified below was subsequently hardened and recorded in the [Phase 1 implementation record](after_four_order_payment_implementation_phase1.md); this notice does not rewrite the original finding.

> **POST-AUDIT CATALOG/PRICING CLOSURE.** After this audit, the Owner explicitly confirmed ten Catalog/Pricing MVP decisions. They are now canonical as `ODB-CAT-01` through `ODB-CAT-10` in [Owner Decision Baseline §5](after_four_owner_decision_baseline.md#5-catalogpricing-mvp) and traced in the [Catalog/Pricing Discovery and Decision Closure](after_four_catalog_pricing_discovery.md). The original audit totals and findings below remain a historical snapshot; conversation-local discovery proposal labels are not canonical IDs.

**Audit date:** 2026-11-14  
**Audit type:** Repository documentation consistency audit; read-only except for this report  
**Decision baseline:** Existing repository records plus the decision directions named in the audit brief  
**Authority boundary:** This report identifies inconsistencies. It does not change a decision, approve a proposal, accept an ADR, authorize implementation, or accept residual risk.

## 1. Executive summary

The repository has a strong canonical architecture layer, especially for Identity decisions ID-01 through ID-34 and the corrected Payment model. Those records preserve scope limitations well: ID-29 through ID-34 approve validation and resource/admission direction only; deployment placeholders ID-35 through ID-39 remain unapproved; ADR-0006 and ADR-0008 remain Proposed; Milestone 2B remains unauthorized.

The main consistency problem is that older planning and design documents remain active-looking even where the canonical architecture explicitly supersedes them. Most importantly, the earlier workflow, domain, database, and roadmap material still sends work to preparation before payment, while the canonical model requires verified full settlement first. The older Phase 3.5 decision register and workshop also present broad table/order/kitchen/payment/identity questions as wholly pending even where later canonical documents record stable outcomes. These files are historically useful, but their current presentation can cause already-answered questions to be asked again or obsolete recommendations to be implemented.

A separate critical gap exists in the canonical Payment model: a late authoritative success obtained by reconciliation creates the pending Preparation Dispatch whenever the Payment first reaches `fully_paid/idle`, but no guard addresses an Order that has expired or been placed on hold. The audit brief states that late success must not automatically dispatch an expired or held Order. That rule is absent from the canonical state vocabulary, API contract, integrity rules, and dispatch eligibility list.

Several business areas described in the audit brief as previously Owner-approved—cash handling/opening float, expense approval, refund, cancellation, and shift handover—have useful canonical structures, but their exact approved scopes and limits are not traceable as `OWNER_CONFIRMED`. The Business Domain Model instead labels much of the content `WORKSHOP_AGREED` and still marks authority, thresholds, and correction behavior `OPEN_DECISION`. The audit does not reinterpret those records or ask the Owner again; the original approval evidence must be transcribed before anyone can determine whether the open labels are stale.

Daily Telegram reporting is not documented anywhere in the repository. The Owner Dashboard is only a route placeholder plus a P2 recommendation/open question. Actor attribution is documented for sensitive actions and cash records, but the repository does not explicitly prohibit treating order revenue as an employee performance score. These are documentation gaps, not permission to invent report content.

### 1.1 Decision audit totals

This audit checked **64** decision or governance records:

| Primary audit disposition | Count | Meaning |
|---|---:|---|
| Correctly documented | 46 | The current authoritative status and boundary are clear, even if implementation evidence remains open. |
| Missing or incomplete | 8 | A known direction or asserted prior approval lacks a complete, traceable repository record. |
| Contradictory | 4 | Current documents make materially incompatible statements or retain obsolete instructions without a sufficient supersession warning. |
| Genuinely unresolved | 6 | The repository truthfully records that an explicit Owner choice is still required. |
| **Total** | **64** | Each matrix row has one primary disposition. |

The counts are document-audit dispositions, not implementation or security-review results. For example, an Identity decision may be correctly documented as `OWNER_CONFIRMED` while its checklist control remains `OPEN` or `BLOCKED`.

## 2. Status interpretation

This audit uses the repository's statuses without broadening them:

| Status | Audit interpretation |
|---|---|
| `OWNER_CONFIRMED` | The exact row boundary was explicitly approved. Unstated implementation details remain unapproved. |
| `OWNER_APPROVED_WITH_SCOPE_LIMITATIONS` | The Owner approved only the named candidate, method, or direction and its explicit exclusions remain binding. |
| `PROPOSED_NOT_APPROVED` | A design direction exists but is not an Owner decision. |
| `NOT_APPROVED` | A proposal is prepared but has no Owner approval. |
| `OPEN` | Evidence, design, remediation, or an applicable decision is incomplete. It is not accepted residual risk. |
| `BLOCKED` | A named prerequisite is absent. It is not a failed or accepted review. |
| `UNKNOWN` | The repository contains no adequate evidence to classify the claimed decision or value. |

`WORKSHOP_AGREED` is preserved where the Business Domain Model uses it, but the [Identity Decision Register § Decision status](after_four_identity_decision_register.md#decision-status) explicitly says it is pre-existing domain provenance and not a substitute for `OWNER_CONFIRMED` or security review. This audit therefore never silently converts it into Owner confirmation.

## 3. Scope and evidence inspected

### 3.1 Repository guidance and vocabulary

- [`AGENTS.md`](../../AGENTS.md), including repository scope and frontend conventions.
- [`GLOSSARY.md`](../../GLOSSARY.md), including User/Employee, role, assignment, lifecycle, delegation, and POS PIN terminology.

### 3.2 Canonical architecture and decisions

- [Business Domain Model](after_four_business_domain_model.md), especially §§1, 4–6, 8, 10, 13–18.
- [Canonical Payment Model](after_four_payment_model.md), especially §§1, 4–6, and 8.
- [State Machines](after_four_state_machines.md), especially §§2–10, 13–17, and 22.
- [ERD](after_four_erd.md), [Data Dictionary](after_four_data_dictionary.md), [Data Integrity Rules](after_four_data_integrity_rules.md), [API Contract](after_four_api_contract.md), and [API Error Catalog](after_four_api_error_catalog.md).
- [Foundation Decisions](after_four_foundation_decisions.md), [Rails/PostgreSQL Readiness Review](after_four_rails_postgresql_readiness.md), and all ADR status headers under [`docs/architecture/adr/`](adr/).
- [Identity Decision Register](after_four_identity_decision_register.md), [Identity & Branch Authorization](after_four_identity_authorization.md), [Identity Technical Design](after_four_identity_technical_design.md), [Identity Security Review Checklist](after_four_identity_security_review_checklist.md), and Owner-led review records.
- [AF-OWNER-001D](security-reviews/owner-led/af-owner-001d-argon2-owner-decision-proposals.md) and [AF-OWNER-001G](security-reviews/owner-led/af-owner-001g-deployment-direction-proposals.md).

### 3.3 Earlier planning/design material checked for conflicts

- [Phase 3.5 Business Decisions Register](../planning/phase-3.5-business-decisions-register.md).
- [Phase 3.6.1 Owner Decision Workshop](../planning/phase-3.6.1-owner-decision-workshop.md).
- [Business Workflows](../design/phase-3.5.2-business-workflows.md), [Domain Model](../design/phase-3.5.3-domain-model.md), [Backend Architecture](../design/phase-3.5.4-backend-architecture.md), and [Database Design](../design/phase-3.5.5-database-design.md).
- [Prototype-to-Production Roadmap](../planning/phase-3.5-production-roadmap.md) and [Architecture Gap Analysis](../research/after_four_architecture_gap_analysis.md).
- Backend and frontend README files and repository-wide Markdown searches for decision statuses, payment/preparation sequencing, cash/float, expenses, refunds, cancellation, handover, reports, Telegram, dashboards, and actor attribution.

The audit did not treat frontend mock behavior, development Docker values, recommendations, or assistant-authored proposals as Owner approval.

## 4. Decision-by-decision traceability matrix

### 4.1 Business, payment, operations, and reporting directions — 22 checks

| Audit ID | Decision or direction checked | Recorded status | Authoritative source and exact section | Primary disposition | Audit conclusion |
|---|---|---|---|---|---|
| B-01 | AFTER FOUR is an internal chain-first café management product. | `WORKSHOP_AGREED` | [Business Domain Model §1.2 Product boundary](after_four_business_domain_model.md#12-product-boundary) | Correct | Recorded as an internal café-chain management system; SaaS/marketplace is outside MVP. Do not ask again whether it is a public SaaS product. |
| B-02 | MVP is one Brand with multiple Branches under the Organization hierarchy. | `WORKSHOP_AGREED` | [Business Domain Model §1.2](after_four_business_domain_model.md#12-product-boundary) | Correct | Organization → Brand → Branch and one-Brand/multi-Branch MVP are explicit. |
| B-03 | Verified full payment precedes preparation for dine-in and takeaway. | `OWNER_CONFIRMED` | [Business Domain Model §§8.1 and 8.4](after_four_business_domain_model.md#84-mandatory-paid-before-preparation-scenarios); [State Machines §3](after_four_state_machines.md#3-mandatory-payment-to-preparation-flow) | Contradictory | Canonical rule is correct and channel-neutral, but older workflow/roadmap/domain/database documents still create tickets on submission before payment. |
| B-04 | Pending, failed, unknown, or unverified payment never triggers preparation. | `OWNER_CONFIRMED` | [Business Domain Model §8.4](after_four_business_domain_model.md#84-mandatory-paid-before-preparation-scenarios); [Payment Model §§2–6](after_four_payment_model.md#6-preparation-dispatch-eligibility) | Correct | Failure is retained; unknown requires reconciliation; dispatch requires `fully_paid/idle` and exact target. |
| B-05 | Late successful notification must not auto-dispatch an expired or held Order. | `UNKNOWN` in repository | No canonical rule; [Payment Model §§4–6](after_four_payment_model.md#4-transitions-and-guards) currently dispatches on first reconciled `fully_paid/idle` | Incomplete | The audit brief names the rule, but Order has no held/expired state or dispatch guard. Current canonical logic would create a pending Dispatch after late reconciliation if other listed guards pass. |
| B-06 | Dine-in and takeaway are supported service channels. | `WORKSHOP_AGREED` | [Business Domain Model §8.1](after_four_business_domain_model.md#81-separate-concepts-and-service-channels) | Correct | Both channels are explicit; the paid-before-preparation rule is not limited to one channel. |
| B-07 | Table Session is distinct from the physical table and retains visit/assignment history. | `WORKSHOP_AGREED`; detailed policy `OPEN` | [Business Domain Model §§2 and 12](after_four_business_domain_model.md#12-other-operational-domains); [ERD § Table and operations](after_four_erd.md) | Correct | The concept and history are settled enough not to reopen broadly. Move/merge/split, deposits, reset/release, and exact cardinality remain narrower open policies. |
| B-08 | Order, Payment, Preparation, Printing, and Delivery have independent lifecycles. | `WORKSHOP_AGREED` | [Business Domain Model §§8.1–8.2](after_four_business_domain_model.md#81-separate-concepts-and-service-channels); [State Machines §2](after_four_state_machines.md#2-core-concepts-and-independent-axes) | Correct | Do not ask again whether a single Order status should represent payment or kitchen progress. Closure and post-dispatch correction guards remain open. |
| B-09 | Additional items/rounds and kitchen work are distinct historical batches rather than silent mutation. | `WORKSHOP_AGREED`; allocation detail `OPEN` | [Business Domain Model §§4.2, 8.5, 14](after_four_business_domain_model.md#85-preparation-lifecycle) | Contradictory | Canonical history/deviation rules are stable, but the old workshop still asks the whole ticket model as if no outcome exists and the old workflow sends batches before payment. Exact same-Order/check policy remains open. |
| B-10 | Preparation Ticket/Dispatch is an exactly-once paid-order handoff. | `OWNER_CONFIRMED` | [Business Domain Model §§4.2, 8.4–8.5](after_four_business_domain_model.md#84-mandatory-paid-before-preparation-scenarios); [ERD § Payment/Preparation](after_four_erd.md) | Contradictory | Canonical documents agree; old workflow, domain model, database design, and roadmap encode submission-to-ticket sequencing. |
| B-11 | Employee work Shift, Cash Session, and actor attribution are separate concepts. | `WORKSHOP_AGREED` | [Business Domain Model §§2 and 10](after_four_business_domain_model.md#10-cash-and-finance) | Correct | One shared drawer can coexist with individual actors and separate attendance shifts. |
| B-12 | Owner-approved cash handling, opening float, close, discrepancy, and correction limits. | `WORKSHOP_AGREED`; thresholds `OPEN`; claimed prior approval not traceable | [Business Domain Model §§10, 13, 17](after_four_business_domain_model.md#10-cash-and-finance); [State Machines §13](after_four_state_machines.md#13-cash-session-state-machine) | Incomplete | Shared drawer, morning close/evening new opening fund, immutable movements, reason, and Branch Manager notification are recorded. Exact approval provenance, threshold/escalation, and handover limits are not `OWNER_CONFIRMED`. |
| B-13 | Owner-approved expense approval policy and limits. | `WORKSHOP_AGREED`; exact policy `OPEN` | [Business Domain Model §§10.2, 13, 17](after_four_business_domain_model.md#102-financial-classification) | Incomplete | Expense structure and generic approvals exist, but approver eligibility, thresholds, evidence, budget periods, self-approval, and correction limits remain marked open despite the audit brief's prior-approval direction. |
| B-14 | Owner-approved refund/void policy and limits. | Refund record `WORKSHOP_AGREED`; authority `OPEN` | [Business Domain Model §§8.4, 13, 17](after_four_business_domain_model.md#17-open-decisions-and-validation-register); [State Machines §10](after_four_state_machines.md#10-refund-state-machine) | Incomplete | Append-only linked Refund behavior is stable. Roles, amount/time thresholds, reasons, original-tender rules, self-approval, and post-dispatch handling are not traceably Owner-confirmed. |
| B-15 | Owner-approved cancellation/correction policy and limits. | History rules `WORKSHOP_AGREED`; authority/compensation `OPEN` | [Business Domain Model §§8.2, 8.5, 13, 17](after_four_business_domain_model.md#17-open-decisions-and-validation-register); [State Machines §§4–5, 9](after_four_state_machines.md#4-order-state-machine) | Incomplete | No-delete/attributed correction behavior is stable, but stage-specific authority, prepared-item treatment, compensation/refund, table release, and limits remain open in canonical documents. |
| B-16 | Owner-approved shift handover/carryover policy and limits. | `UNKNOWN` for exact Owner decision | [Business Domain Model §§10 and 17](after_four_business_domain_model.md#17-open-decisions-and-validation-register); old [Business Workflows §4](../design/phase-3.5.2-business-workflows.md#4-opening-and-closing-a-shift) | Incomplete | Cash morning/evening session separation is documented; treatment of open Orders, deliveries, unknown payments, approvals, and accountable handover is still presented as open/proposed. |
| B-17 | Daily Telegram reporting. | `UNKNOWN` | No repository document contains “Telegram” | Incomplete | No canonical record defines whether the direction is approved, recipients, schedule, Branch scope, metrics, delivery failure, privacy, or authorization. Do not substitute generic scheduled-report recommendations. |
| B-18 | Owner Dashboard reporting details. | `NOT_APPROVED` / pending P2 recommendation | [Business Decisions Register § BD-RPT-002](../planning/phase-3.5-business-decisions-register.md#bd-rpt-002--advanced-analytics); frontend shell route is only a placeholder | Correct | A Dashboard route does not approve report content. Advanced analytics and Owner dashboard details remain unapproved. |
| B-19 | Employee/shift reports preserve actor accountability and do not score a person by Order revenue. | Actor attribution partially established; scoring rule `UNKNOWN` | [Business Domain Model §§5.2, 10](after_four_business_domain_model.md#10-cash-and-finance); old [Business Workflows §13](../design/phase-3.5.2-business-workflows.md#13-reports-and-reconciliation) | Incomplete | Sensitive actions/cash records retain actors, but “sales/actions by staff” is not separated into accountability versus performance, and no canonical prohibition prevents attributing Order revenue as an individual score. |
| B-20 | Business-day/timezone and daily report formulas. | `OPEN` | [Business Decisions Register § BD-RPT-001](../planning/phase-3.5-business-decisions-register.md#bd-rpt-001--business-day-timezone-and-report-definitions); [Business Domain Model §17](after_four_business_domain_model.md#17-open-decisions-and-validation-register) | Genuinely unresolved | No approved cutoff, timezone/formula set, or accounting interpretation exists. This is narrower than whether daily reporting exists. |
| B-21 | MVP payment is exact-balance-only; split/partial allocation is not implemented. | Accepted correction; split/partial `OPEN` | [Payment Model §§1 and 8](after_four_payment_model.md#8-deferred-decisions) | Correct | `partially_paid` is reserved but unreachable through MVP production commands. Do not ask again whether the current MVP silently implements split tender. |
| B-22 | Unknown payment is reconciled using the existing attempt; no blind replacement charge. | `OWNER_CONFIRMED` | [Business Domain Model §§8.4 and 14](after_four_business_domain_model.md#84-mandatory-paid-before-preparation-scenarios); [Payment Model §5](after_four_payment_model.md#5-reconciliation-and-concurrency) | Correct | The provider/method remains open, but unknown is neither failure nor success and never permits blind retry or preparation. |

### 4.2 Identity/security Owner decisions ID-01 through ID-34 — 34 checks

Unless a row says otherwise, the source is [Identity Decision Register § Owner decisions confirmed](after_four_identity_decision_register.md#owner-decisions-confirmed). `SECURITY_REVIEW_REQUIRED` and current `OPEN`/`BLOCKED` evidence states remain in force and do not downgrade the Owner policy.

| ID | Confirmed boundary checked | Repository status | Primary disposition | Audit conclusion |
|---|---|---|---|---|
| ID-01 | Individual POS PIN; no shared store PIN | `OWNER_CONFIRMED` | Correct | Exact cryptographic/online controls remain review work. |
| ID-02 | MFA for Owner and sensitive Branch Manager capabilities | `OWNER_CONFIRMED` | Correct | Capability enumeration and factor design remain open; no unrestricted manager authority follows. |
| ID-03 | Back-office 30-minute idle / 12-hour absolute session | `OWNER_CONFIRMED` | Correct | Enforcement evidence remains open. |
| ID-04 | POS locks after two idle minutes and requires individual reauthentication | `OWNER_CONFIRMED` | Correct | The proof/interaction boundary remains security-review work. |
| ID-05 | Multiple-device sessions; Owner all-session revocation; no approved numeric cap | `OWNER_CONFIRMED` | Correct | Consistent with ID-19. |
| ID-06 | Owner manages employee recovery; Owner recovery is separate | `OWNER_CONFIRMED` | Correct | ID-16 adds principles without pretending the procedure is complete. |
| ID-07 | Rate limiting/progressive delay; failures alone never permanently lock | `OWNER_CONFIRMED` | Correct | Numeric limits and distributed enforcement remain open. |
| ID-08 | Invitation-only accounts; Owner or authorized delegate invites | `OWNER_CONFIRMED` | Correct | ID-14 later narrows delegation; acceptance proof/races remain open. |
| ID-09 | Owner approval for every Role/Employee Branch Assignment change | `OWNER_CONFIRMED` | Correct | No Branch Manager self-approval is inferred. |
| ID-10 | Owner, Branch Manager, Staff active; Regional Manager reserved | `OWNER_CONFIRMED` | Contradictory | Canonical Identity/Glossary is correct, but older workflow uses Owner/Manager, Cashier/Service, and Barista as role templates and grants Owner/Manager all refunds/overrides. |
| ID-11 | Username login; email contact/recovery only | `OWNER_CONFIRMED` | Correct | Normalization/change/recovery protection remains review work. |
| ID-12 | Sensitive audit; restricted read; append-only | `OWNER_CONFIRMED` | Correct | Retention, reader matrix, export, privacy, and database evidence remain open/blocked. |
| ID-13 | Fixed Branch Manager capability matrix, assigned-Branch scope, MFA/step-up, explicit denials | `OWNER_CONFIRMED` | Correct | The role name does not grant unresolved refund/cash/customer/payroll powers. |
| ID-14 | Separate invitation delegation; assigned Branches; ≤90 days; no self-renew/onward delegation | `OWNER_CONFIRMED` | Correct | Race/enforcement evidence remains open. |
| ID-15 | Lock/suspension/reactivation/deactivation distinct; Owner lifecycle authority | `OWNER_CONFIRMED` | Correct | Owner-unavailable process remains separate and cannot imply Branch Manager power. |
| ID-16 | Owner recovery uses independent factors, offline material, two proofs, dual control | `OWNER_CONFIRMED` | Correct | Exact custodians/proofs/provider and drill remain blocked. |
| ID-17 | One HTTPS origin, managed edge, private Rails, no default CORS, trusted proxies/Host Authorization | `OWNER_CONFIRMED` | Correct | No hosting/vendor/network details are approved. |
| ID-18 | Audit event classes, controlled readers/holds/exports/anonymization, integrity/accountability | `OWNER_CONFIRMED` | Correct | No retention period or legal conclusion is approved. |
| ID-19 | No numeric MVP concurrent-session cap; visibility/notification/anomaly/revocation | `OWNER_CONFIRMED` | Correct | A default cap of three remains explicitly unapproved. |
| ID-20 | Owner-led, non-independent review; Owner responsible for explicit residual-risk decisions | `OWNER_CONFIRMED` | Correct | No professional/legal review, compliance claim, or automatic risk acceptance follows. |
| ID-21 | PIN only on enrolled POS; cannot create general Session or satisfy MFA/step-up/recovery/admin | `OWNER_CONFIRMED` | Correct | Device bootstrap/binding implementation remains open. |
| ID-22 | PIN is 6–8 decimal digits; four digits forbidden | `OWNER_CONFIRMED` | Correct | Online defense evidence remains mandatory. |
| ID-23 | Distributed PIN defense, progressive delay, temporary lock, alternate-route protection | `OWNER_CONFIRMED` | Correct | No numeric threshold/delay/lock is approved. |
| ID-24 | Argon2id preferred candidate subject to compatibility, maintenance, benchmark, and capacity evidence | `OWNER_CONFIRMED` | Correct | Compatibility spike does not approve production integration/profile. |
| ID-25 | NFC, bounded lengths, compromised/common password blocklist, no truncation | `OWNER_CONFIRMED` | Correct | Exact limits/source/privacy/outage behavior remain open. |
| ID-26 | Password pepper not mandatory for MVP | `OWNER_CONFIRMED` | Correct | No residual database-compromise risk is accepted. |
| ID-27 | Separate PIN pepper and distinct rotation/compromise/loss/cutoff/reset procedures | `OWNER_CONFIRMED` | Correct | Provider, custody, overlap, and procedures remain open. |
| ID-28 | Credential replacement revokes relevant access/recovery artifacts atomically and audits | `OWNER_CONFIRMED` | Correct | Exact event/session matrix remains open. |
| ID-29 | P64-4 is preferred password candidate for production-parity validation only | `OWNER_CONFIRMED`; package `OWNER_APPROVED_WITH_SCOPE_LIMITATIONS` | Correct | Not a production profile, PIN profile, dependency, or implementation approval. |
| ID-30 | Container-wide HashingAdmission across Puma workers; bounded generic exhaustion behavior | `OWNER_CONFIRMED`; scoped | Correct | No Adapter, concurrency, queue, or deadline approved. |
| ID-31 | Evidence-based memory/CPU/latency/topology resource method | `OWNER_CONFIRMED`; scoped | Correct | No reserve, headroom, budget, or concurrency number approved. |
| ID-32 | Explicit/versioned `p_cost`; compare P64 at one/two/four lanes | `OWNER_CONFIRMED`; scoped | Correct | No production `p_cost` or profile approved. |
| ID-33 | Bounded wait then generic unavailable; no unbounded queue/bypass/cheaper fallback | `OWNER_CONFIRMED`; scoped | Correct | No status, retry, queue, deadline, or rejection budget approved. |
| ID-34 | Production revalidation before first use and after material change | `OWNER_CONFIRMED`; scoped | Correct | Revalidation does not itself approve production use. |

### 4.3 Deployment proposal placeholders ID-35 through ID-39 — 5 checks

Source: [AF-OWNER-001G §2 Proposal summary](security-reviews/owner-led/af-owner-001g-deployment-direction-proposals.md#2-proposal-summary). The identifiers are placeholders and are not canonical Decision Register rows.

| Placeholder | Proposal | Repository status | Primary disposition | Audit conclusion |
|---|---|---|---|---|
| ID-35 | Managed-container/managed-PostgreSQL/managed-edge deployment shape | `NOT_APPROVED` | Genuinely unresolved | No provider, account, region, or platform has been selected. |
| ID-36 | Evidence-first resource/process sizing method | `NOT_APPROVED` | Genuinely unresolved | No topology or numeric limit is approved. |
| ID-37 | Launch forecast plus planning upper bound | `NOT_APPROVED` | Genuinely unresolved | No branch/user/device/traffic forecast is approved. |
| ID-38 | Separate experience/availability objective classes | `NOT_APPROVED` | Genuinely unresolved | No SLO, timeout, retry, or recovery value is approved. |
| ID-39 | Owner/Operations Primary/backup responsibility model | `NOT_APPROVED` | Genuinely unresolved | No assignee, coverage model, or service has been approved. |

### 4.4 ADR and authorization governance — 3 checks

| Audit ID | Direction checked | Repository status | Source and exact section | Primary disposition | Audit conclusion |
|---|---|---|---|---|---|
| G-01 | Authentication/session topology ADR | `PROPOSED_NOT_APPROVED` | [ADR-0006 § Consequences](adr/0006-authentication-session-topology.md#consequences) | Correct | Header and consequences both remain Proposed; Owner policies do not accept the ADR. |
| G-02 | Deployment/environment ADR | `PROPOSED_NOT_APPROVED` | [ADR-0008 § Consequences](adr/0008-deployment-environments.md#consequences) | Correct | Hosting, secrets, ownership, monitoring, backup/recovery, and incident gates remain unsatisfied. |
| G-03 | Milestone 2B authorization | `NOT_AUTHORIZED` | [Foundation Decisions §5](after_four_foundation_decisions.md#5-milestone-2--identity-branch-scope-and-authorization); [ADR-0006 § Consequences](adr/0006-authentication-session-topology.md#consequences) | Correct | No reviewed repository record authorizes Milestone 2B. |

## 5. Correctly documented decision groups

The following areas should be preserved without reopening their approved boundary:

1. **Identity ID-01 through ID-09 and ID-11 through ID-34.** Their exact approvals, limitations, and evidence gates are consistently recorded in the Decision Register, ADR-0006, Identity Authorization, and Technical Design. ID-10 is also canonically clear but has old-document contradictions.
2. **Payment truth.** Funding and attempt activity are separate; MVP is exact-balance-only; unknown outcomes require reconciliation; failure/unknown/unverified activity cannot dispatch; paid-but-undispatched work is recoverable without recharging.
3. **Independent contexts.** Order, Payment, Preparation, Printing, Delivery, Cash Session, and employee Shift are not one status or aggregate.
4. **Product/organization boundary.** AFTER FOUR is internal and chain-oriented, with one-Brand/multi-Branch MVP and no SaaS marketplace scope.
5. **Proposal governance.** ID-35 through ID-39 are unapproved; ADR-0006 and ADR-0008 are Proposed; Milestone 2B is unauthorized.

## 6. Findings: missing or incomplete documentation

| Finding | Severity | Decision | Source file and exact section | Evidence | Recommended documentation correction |
|---|---|---|---|---|---|
| AF-AUD-001 | **Critical** | B-05 | [Payment Model §§4–6](after_four_payment_model.md#6-preparation-dispatch-eligibility); [State Machines §§3, 7–8](after_four_state_machines.md#8-preparation-dispatch-and-attempt-state-machines); [API Contract §6.2](after_four_api_contract.md) | Reconciliation success moves Payment to `fully_paid/idle` and creates Dispatch. No Order `held`/`expired` vocabulary or dispatch eligibility guard prevents late automatic preparation. | Record the exact Owner rule and define Order eligibility at late settlement: funded money remains true, but expired/held Orders enter explicit exception/review/compensation handling and do not auto-dispatch. Synchronize Payment Model, BDM, State Machines, Integrity Rules, API, errors, ERD/dictionary, and tests later. Do not design the missing policy in this audit. |
| AF-AUD-002 | **High** | B-12 through B-16 | [Business Domain Model §§10, 13, 17](after_four_business_domain_model.md#17-open-decisions-and-validation-register) | Repository records structures and some workshop outcomes but marks cash thresholds, expenses, refund/void, cancellation, and handover/carryover limits open. The audit brief says prior Owner-approved policies exist. | Locate the original Owner wording/evidence and transcribe its exact actors, scopes, thresholds, stages, exceptions, and limits into a canonical business decision register. Until then, retain current execution blocks; do not infer details or ask the broad questions again. |
| AF-AUD-003 | **High** | B-17 | Repository-wide documentation search; no source section exists | No `Telegram` reference exists in repository Markdown. | Add a traceable decision record only from the original Owner evidence. Separate approval of daily Telegram delivery from still-open schedule, recipients, fields, Branch scope, privacy, failure/retry, and operational ownership. Do not treat a generic scheduled-report recommendation as approval. |
| AF-AUD-004 | **Medium** | B-19 | [Business Workflows §13](../design/phase-3.5.2-business-workflows.md#13-reports-and-reconciliation); [Business Domain Model §§5.2 and 10](after_four_business_domain_model.md#10-cash-and-finance) | “Sales/actions by staff” is proposed, while actor attribution is canonical. No rule distinguishes action accountability from attributing Order revenue as a performance score. | Add a canonical reporting invariant: retain actors for actions, approvals, handoffs, cash, and shifts; do not infer individual performance ownership from Order revenue. Record any actual performance metrics only after explicit approval. |
| AF-AUD-005 | **Medium** | Business decision provenance | [Business Domain Model §1.1](after_four_business_domain_model.md#11-provenance-labels); [Identity Register § Decision status](after_four_identity_decision_register.md#decision-status) | Many later business policies are `WORKSHOP_AGREED`, but no updated numbered business decision register preserves the actual workshop answer/date/scope. Older register remains entirely pending. | Create a canonical business decision register during the correction phase that preserves `WORKSHOP_AGREED` separately from `OWNER_CONFIRMED`, links source evidence, and records superseded/pending entries without upgrading recommendations. |
| AF-AUD-006 | **Medium** | AF-OWNER-001 findings | [AF-OWNER-001 § Findings](security-reviews/owner-led/af-owner-001-password-pin-security.md); §§ Evidence/closure mapping | Finding titles still say Argon2 compatibility is unproven and PIN role is ambiguous, while later C.2 and IDs 21–24 provide compatibility and policy evidence. The findings remain legitimately `OPEN` for production dependency/implementation evidence. | On a later authorized documentation pass, revise finding wording to distinguish resolved policy/compatibility subclaims from still-open integration, target-image, implementation, and production evidence. Do not close findings merely because wording is updated. |

## 7. Findings: contradictions

| Finding | Severity | Decision | Conflicting sources and exact sections | Conflict | Recommended documentation correction |
|---|---|---|---|---|---|
| AF-AUD-007 | **Critical** | B-03, B-09, B-10 | Canonical [BDM §8.4](after_four_business_domain_model.md#84-mandatory-paid-before-preparation-scenarios), [Payment Model §6](after_four_payment_model.md#6-preparation-dispatch-eligibility), [State Machines §3](after_four_state_machines.md#3-mandatory-payment-to-preparation-flow) versus old [Business Workflows §§3, 6, 8, 10](../design/phase-3.5.2-business-workflows.md), [Domain Model](../design/phase-3.5.3-domain-model.md), [Database Design](../design/phase-3.5.5-database-design.md), and [Roadmap §§6–8](../planning/phase-3.5-production-roadmap.md) | Old sequence creates Kitchen Tickets on order submission and takes payment later; canonical sequence forbids any Preparation Dispatch before full verified payment. | Add prominent superseded notices to old documents and replace normative flow/roadmap statements with links to canonical Payment/Preparation documents. Preserve history, but prevent old sequencing from being implementation input. |
| AF-AUD-008 | **High** | B-07 through B-16 and multiple business decisions | [Phase 3.5 Register §§2–5](../planning/phase-3.5-business-decisions-register.md) and [Owner Workshop §§1, 3–8](../planning/phase-3.6.1-owner-decision-workshop.md) versus [Business Domain Model §§1, 4–18](after_four_business_domain_model.md) | Older files state all P0 choices are pending and say no glossary exists. Canonical BDM, ERD, dictionary, state machines, and root glossary now exist and contain later outcomes. Some narrower details genuinely remain open. | Mark the register/workshop as historical preparation with a dated supersession map. For every old ID, classify: answered, partially answered with named residual, still open, or superseded. Do not delete the workshop record or convert recommendations to approvals. |
| AF-AUD-009 | **High** | ID-10 | Canonical [Identity Register ID-10](after_four_identity_decision_register.md#owner-decisions-confirmed), [`GLOSSARY.md`](../../GLOSSARY.md), and [BDM §5](after_four_business_domain_model.md#5-identity-authorization-and-branch-scope) versus old [Business Workflows §11](../design/phase-3.5.2-business-workflows.md#11-staff-role-and-permission-workflow) | Old role table uses `Owner/Manager`, `Cashier/Service`, and `Barista` and says Owner/Manager has all refunds/overrides. Canonical roles are Owner, Branch Manager, Staff; duties are capabilities, and refund/cash powers remain policy-blocked. | Mark the old table superseded and replace it with a non-normative historical note linking ID-10/ID-13 and the unresolved business-authority matrix. |
| AF-AUD-010 | **Medium** | Repository guidance | [`AGENTS.md` § Scope](../../AGENTS.md#scope) versus [Foundation Decisions §§1 and 4](after_four_foundation_decisions.md#4-milestone-1--rails-application-foundation) and existing `backend/` documentation | Agent guidance says the repository contains only the frontend foundation, but Rails Milestone 1 and backend documentation exist. The scope caveat can cause valid backend documentation work to be rejected or misunderstood. | Update AGENTS.md in a later authorized correction to describe the current frontend and backend foundation while retaining the rule that backend/business/deployment work requires explicit task authorization. |

## 8. Recommendations incorrectly presented as decisions

No deployment proposal ID-35 through ID-39 is presented as confirmed, and no reviewed file marks ADR-0006 or ADR-0008 Accepted. The AF-OWNER-001D package correctly uses `OWNER_APPROVED_WITH_SCOPE_LIMITATIONS` and repeats its exclusions.

No clear case was found where a row explicitly labeled `TECHNICAL_PROPOSAL`, `PROPOSED_NOT_APPROVED`, or `NOT_APPROVED` was relabeled `OWNER_CONFIRMED`. The material risks are subtler:

1. old recommendation documents remain implementation-shaped and are not prominently superseded;
2. `WORKSHOP_AGREED` policies lack a consolidated source/evidence register and can be mistaken for either mere recommendations or explicit Owner confirmation; and
3. frontend routes/placeholders, including Dashboard, can be mistaken for approved reporting scope.

These are provenance and document-lifecycle problems. The correction must preserve the original label rather than upgrading or downgrading it.

## 9. Genuine unresolved Owner decisions

The following questions are supported as genuinely unresolved by current authoritative evidence. They should be asked only at their remaining narrow boundary:

1. **Deployment ID-35 through ID-39:** deployment shape/provider criteria, evidence-based resource/process method, launch demand values, numeric experience/availability objectives, and actual operational assignees.
2. **Payment expansion:** whether split/partial tender will ever be allowed and, if so, allocation, rounding, refund/cancellation, reporting, and operator behavior. MVP exact-balance behavior is already settled.
3. **Electronic payment provider:** method/provider, authoritative result evidence, webhook/query/reconciliation contract, credentials, and operator recovery. Unknown-payment semantics are already settled.
4. **Reporting definitions:** business timezone/day cutoff, revenue/cash/refund formulas, and approved Owner Dashboard/advanced analytics content. This must not reopen actor attribution or the existence of daily reporting as a broad topic.
5. **Commercial policy not claimed as previously approved:** price/tax/service-charge components, loyalty/promotion values, receipt/invoice requirements, and related legal/accounting validation.
6. **Operational/deployment values:** device/printer topology, safe offline scope beyond the existing fail-safe default, and backup/recovery service levels.

The following must **not** be treated as genuinely unresolved until the provenance conflict is reconciled: cash/float, expense approval, refund/void, cancellation, and shift-handover policy. The audit brief says decisions exist, while repository canonical documents mark important details open. The correct next action is evidence reconciliation, not asking the Owner the same broad questions again.

Identity security implementation parameters and the checklist's `OPEN`/`BLOCKED` evidence are also unresolved, but most are technical/security-review gates rather than new business-policy questions. Owner confirmation of IDs 01–34 must not be reopened.

## 10. Questions to retire or narrow

### 10.1 Retire completely

- Is AFTER FOUR a public SaaS/marketplace or an internal café-chain product?
- May preparation begin before full verified payment?
- Do failed, pending, unknown, client-asserted, or unverified payments permit preparation?
- Does timeout mean payment failure?
- Should a new charge be started blindly while an attempt is unknown?
- Should one aggregate status represent Payment settlement and attempt activity?
- Does MVP already support split/partial tender?
- Are User and Employee the same record?
- Are Branch Assignment and Role Assignment interchangeable?
- May POS employees share a store PIN?
- Is email the login identifier?
- Is Regional Manager an active MVP role?
- Is there a default numeric concurrent-session cap?
- Are deployment IDs 35–39 approved?
- Are ADR-0006, ADR-0008, or Milestone 2B accepted/authorized?

### 10.2 Ask only the named residual, not the broad question again

| Topic | Already answered | Residual that may still require evidence/decision |
|---|---|---|
| Table sessions | Visit/assignment history is distinct from a physical table. | Exact active-Order/check cardinality, move/merge/split, reset/release, deposit/no-show policy. |
| Orders | Commercial state is separate; confirmed history is not silently rewritten. | Closure guards and exact post-confirmation/post-dispatch correction authority. |
| Additional items/kitchen | Paid dispatch/tickets and attributed deviations are separate historical work. | Same-Order/check grouping, station/batch routing, remake/cancellation limits. |
| Payment | Full verified exact-balance settlement gates dispatch; unknown is reconciled. | Provider contract, late-success held/expired behavior, future split/partial policy. |
| Cash/float | Shared drawer, individual actors, opening fund, close/count, immutable correction structure are recorded. | Recover the exact prior approval evidence and reconcile any truly unapproved threshold/escalation fields. |
| Refund/cancellation/expense/handover | Structures and safe invariants exist; the audit brief says policies were previously approved. | Recover and transcribe exact actors, thresholds, stages, evidence, exception and correction limits—do not restart with a blank workshop question. |
| Reporting | Committed facts and actor attribution are required; Dashboard details are not approved. | Telegram decision provenance; business-day formulas; privacy/recipient/schedule; approved dashboard metrics; explicit no-revenue-as-personal-score rule. |
| Identity | IDs 01–34 fix policy/scoped validation boundaries. | Executed evidence and exact technical values specifically left open by each row. |

## 11. Prioritized documentation correction plan

No correction is authorized by this audit. After Owner review, use this order:

### Priority 0 — safety and authority

1. Record the late-success expired/held Order rule from explicit Owner evidence and synchronize every canonical Payment/Order/Preparation document. Add no implementation in the documentation pass.
2. Add superseded warnings and canonical links to the old pre-payment preparation workflow, domain model, database design, and roadmap sections.
3. Build a reconciliation table for the old Business Decisions Register and workshop so answered questions are retired and true residuals remain visible.

### Priority 1 — preserve prior Owner scope

4. Recover original evidence for cash/float, expense approval, refund, cancellation, and shift handover. Record exact scope/limits without expanding them. Reconcile BDM §13/§17, State Machines, API, integrity rules, and error catalog only after that evidence is reviewed.
5. Record the daily Telegram reporting decision and separately label all unapproved details. Keep Owner Dashboard/advanced analytics `NOT_APPROVED` until explicit evidence says otherwise.
6. Add the actor-accountability/reporting invariant that revenue belongs to the Order/Branch/business period and is not, by itself, an individual employee performance score.

### Priority 2 — provenance and repository guidance

7. Create a canonical numbered business decision register or equivalent provenance index linking `OWNER_CONFIRMED`, `WORKSHOP_AGREED`, `OPEN`, and legal-validation boundaries.
8. Mark the old role-template table superseded by ID-10/ID-13 and the canonical capability model.
9. Update AGENTS.md's repository-state sentence without widening authorization for backend or deployment work.
10. Refresh AF-OWNER-001 finding wording to reflect later evidence while preserving all truthful `OPEN` statuses.

### Validation after a future correction pass

- Every changed rule must trace to explicit evidence and retain its original status.
- Canonical links and Markdown anchors must resolve.
- A repository-wide search must find no active pre-payment preparation instruction or obsolete active-role table.
- IDs 01–34 must remain byte-for-byte equivalent in decision meaning and scope.
- ID-35 through ID-39 must remain unapproved unless a new explicit Owner record exists.
- ADR-0006/ADR-0008 and Milestone 2B must retain their current statuses unless separately authorized.

## 12. Audit conclusion

The canonical Identity and Payment foundations are mostly disciplined, but document lifecycle and missing business-decision provenance create a real risk of repeating workshops or implementing superseded rules. The immediate review focus should be the late-success hold/expiry safety gap and recovery of exact prior business-policy evidence. This audit intentionally stops before correcting any existing file.

**Governance at exit:** AF-OWNER-001 remains `OWNER_REVIEW_IN_PROGRESS`; its findings remain `OPEN`; applicable checklist items remain `OPEN` or `BLOCKED`; independent verification and legal review remain `NOT_PERFORMED`; ADR-0006 and ADR-0008 remain Proposed; deployment proposals ID-35–ID-39 remain `NOT_APPROVED`; Milestone 2B remains `NOT_AUTHORIZED`.
