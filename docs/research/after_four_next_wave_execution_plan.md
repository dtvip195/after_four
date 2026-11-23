# AFTER FOUR — Next-Wave Documentation and Design Execution Plan

**Plan status:** `AUTHORIZED_FOR_DOCUMENTATION_DESIGN_PREPARATION`

**Authorizing decision:** `NW-OR-01` — 2026-11-23

**Canonical ID:** `ID_PENDING_OWNER_GOVERNANCE`

**Candidate E Gate A:** `DEFER_GATE_A — NOT_GRANTED`

**Physical database design approval:** `NOT_GRANTED`

**Implementation authorization:** `NOT_GRANTED`

**Final Operational Acceptance / Production Authorization:** `NOT_GRANTED`

**Date:** 2026-11-23

## 1. Purpose and authority boundary

This plan translates the portfolio approved by `NW-OR-01` into bounded documentation and design-preparation work packages. The canonical decision and its limits are recorded in the [Owner Decision Baseline — Wave 1 decisions](../architecture/after_four_owner_decision_baseline.md#wave-1-semantic-design-gate-and-portfolio-decisions). The [Wave 1 Owner Review and Next-Wave Plan](after_four_wave_1_owner_review_and_next_wave_plan.md) supplies the reviewed rationale and domain inventory.

`NW-OR-01` authorizes preparation of the named artifacts only. It does not preselect any substantive Owner decision inside a package and does not authorize physical database design, database objects, schema, migrations, application or test code, dependencies, runtime configuration, deployment, FOA, or Production Authorization.

Candidate E is not an active implementation or Gate B preparation package. `E-OR-01` accepts its bounded semantic baseline, while `E-OR-02` is `DEFER_GATE_A`; Candidate E Gate A and Gate B proposal preparation remain `NOT_GRANTED`.

## 2. Global execution rules

Every package must:

1. distinguish Owner-confirmed policy, accepted design, technical proposal, bounded implementation evidence, assumption, and unresolved question;
2. preserve the owning domain and ADR-0011 dependency direction;
3. use explicit contracts for cross-context needs without reaching into another context's persistence;
4. retain historical recommendations separately from actual Owner decisions;
5. avoid physical persistence choices, implementation manifests, executable tests, or dependency adoption unless separately authorized later;
6. identify legal, privacy, accounting, payroll, security, or operational inputs honestly without claiming professional approval;
7. end with a bounded review artifact, explicit open questions, and a decision or next-gate request rather than silently continuing; and
8. preserve all current Gate, milestone, CAT-TRR, ADR, FOA, and Production Authorization statuses.

The previously approved acceleration direction permits parallel logical/domain preparation. It is not approval for domain-specific tables, columns, foreign keys, indexes, constraints, transaction boundaries, locks, isolation levels, migrations, or database creation.

## 3. Coordination and sequencing

| Work package | Authorized mode | May start | Primary dependency | Parallelization | Exit checkpoint |
|---|---|---|---|---|---|
| P1A — Order/Payment policy closure | Decision preparation | Now | Canonical Phase 1 evidence and existing Owner policy | Parallel with P1B and P1C | Owner-ready policy brief with unresolved choices separated from technical design |
| P1B — Catalog current-state reconciliation | Evidence reconciliation and bounded next-scope preparation | Now | Catalog decisions, Package B evidence, CAT-TRR records | Parallel with P1A and P1C | Reconciled status matrix and one bounded next proposal, if evidence supports it |
| P1C — Identity/P1 governance and security | Governance/security decision preparation | Now | Identity decisions, P1 design, ADR-0006, security review records | Parallel with P1A and P1B | Decision-ready governance/security package; no Identity implementation |
| P2A — Loyalty and Promotions policy closure | Two separately owned policy tracks | Now, as bounded discovery/policy preparation | Customer anonymization outcomes and Order/Payment facts | May run alongside P1; must not assume unresolved P1 decisions | Separate Loyalty and Promotion decision briefs plus interface questions |
| P2B — Inventory, Cash, Workforce discovery | Three independent discovery annexes | Now | Existing domain evidence and relevant P1 facts | Annexes may run in parallel without merging ownership | Three separate domain discovery records and prioritized decision backlog |
| P2C — Organization extension | Inactive until demand trigger | Only after a named consumer or administration use case is recorded | A1/I1 boundary and concrete consumer need | No speculative parallel design | Owner-reviewed activation brief for one bounded requirement |
| P3 — Operations and Reporting/Audit | Governance and discovery | Now at governance/discovery level | Source-domain ownership and deferred governance inputs | May run alongside P1/P2 | Separate Operations and Reporting/Audit governance briefs |

### 3.1 Suggested execution sequence

1. Launch P1A, P1B, and P1C as independent priority tracks.
2. Start P2A and the three P2B annexes as bounded discovery, recording rather than assuming unresolved P1 inputs.
3. Run P3 governance/discovery alongside those tracks, using source domains as authoritative fact owners.
4. Keep P2C inactive until an activation trigger is documented and reviewed.
5. Hold a shared evidence checkpoint after each package has a source inventory and issue register; this checkpoint identifies conflicts but creates no shared aggregate or decision.
6. Hold package-specific Owner review only when its decision brief and exclusions are complete.

No calendar dates or completion claims are established by this sequence.

### 3.2 Shared review checkpoints

| Checkpoint | Participants | Required output | Boundary |
|---|---|---|---|
| Source and status reconciliation | Relevant package owners | Canonical-source list, stale/contradictory statements, evidence classification | No policy selection |
| Cross-context interface review | Only packages sharing a demonstrated fact flow | Fact owner, consumer need, proposed contract questions, unresolved authority | No shared persistence or ownership transfer |
| Owner decision readiness | One package at a time unless decisions are independently separable | Options, consequences, recommendation where evidence supports it, exact non-authorization statement | No implied Owner selection |
| Exit-gate review | Package owner and applicable reviewers | Acceptance matrix, remaining blockers, proposed next authorization | No automatic physical-design or implementation gate |

## 4. P1A — Order/Payment policy closure

### Objective and problem

Produce one bounded Owner decision package for unresolved Order and Payment business outcomes that Phase 1 intentionally did not settle. Existing implementation evidence must remain separate from permanent business policy.

### Included scope

- split and partial allocation policy;
- overpayment and amount-mismatch treatment;
- refund and cancellation authority, timing, and lifecycle consequences;
- late successful payment treatment, including held/expired Orders;
- reconciliation and exception ownership;
- optional Customer association boundary without redesigning Customer Management;
- provenance required for policy decisions and later technical design; and
- interaction with the confirmed payment-before-preparation invariant.

### Exclusions and non-goals

- payment-provider selection or integration;
- code, endpoints, migrations, schemas, jobs, or operational credentials;
- treating current exact-balance-only behavior as permanent policy;
- Customer Profile creation or anonymous-Order association design;
- Catalog pricing implementation, KDS, Inventory consumption, or accounting compliance conclusions.

### Deliverables and sources

Deliver a policy-gap matrix, lifecycle/exception scenario set, responsibility map, Owner decision brief, and later-design prerequisite list. Primary sources include the [Payment Model](../architecture/after_four_payment_model.md), [State Machines](../architecture/after_four_state_machines.md), [Data Integrity Rules](../architecture/after_four_data_integrity_rules.md), [API Contract](../architecture/after_four_api_contract.md), and [Phase 1 Implementation Record](../architecture/after_four_order_payment_implementation_phase1.md).

### Dependencies and interfaces

Ordering owns payable intent and confirmed commercial snapshots; Payment owns attempt and settlement truth; Preparation consumes only eligible verified dispatch authority. Customer association, Catalog construction, Cash reconciliation, and Reporting are explicit external seams. P1A may consume P1B/P2A findings but must record unresolved inputs rather than wait or infer.

### Review, decisions, and exit criteria

- Every unresolved business outcome has distinct options and consequences.
- Implemented Phase 1 limitations are not mislabeled as Owner policy.
- Required Owner decisions are recorded only after explicit selection.
- Exit requires a reviewed policy baseline or an explicit blocked list; technical design and implementation remain separate.

## 5. P1B — Catalog current-state reconciliation

### Objective and problem

Reconcile Catalog decisions, technical designs, Package B implementation evidence, CAT-TRR evidence, and stale readiness statements. Identify at most one bounded next operation/design candidate without authorizing it.

### Included scope

- decision-to-design-to-implementation traceability for Organization/Brand/Branch references and Category/Product/Variant foundation;
- Package B schema/integrity evidence within its exact scope;
- CAT-TRR-005 through CAT-TRR-008 current evidence and unchanged statuses;
- Package C/P1/P2/P3 prerequisite relationships;
- lifecycle, default Variant, no-purge, Brand consistency, and runtime-role documentation consistency; and
- one bounded next proposal only if prerequisites and authority can be stated precisely.

### Exclusions and non-goals

- Package C implementation or runtime Catalog DML;
- pricing, modifiers, availability, recipes, real menu data, or Product lifecycle expansion;
- CAT-TRR closure without separately authorized evidence review;
- schema/migration changes, physical redesign, or database-role operations; and
- treating Package B as blanket authorization for new Catalog work.

### Deliverables and sources

Deliver a current-state traceability matrix, contradiction register, evidence-versus-claim audit, prerequisite map, and optional bounded next-scope proposal. Sources include the [Owner Decision Baseline](../architecture/after_four_owner_decision_baseline.md), [Catalog Core Technical Design](../architecture/after_four_catalog_core_technical_design.md), [Package C Technical Design](../architecture/after_four_package_c_technical_design.md), Catalog readiness/review records, CAT-TRR records, and Package B implementation evidence.

### Review, decisions, and exit criteria

- Every status is tied to actual evidence and authority.
- Existing implementation is not generalized beyond its package.
- Any proposed next package names exact prerequisites, exclusions, and required Owner decisions.
- Exit is reconciliation and a reviewable proposal, not implementation readiness unless separately established.

## 6. P1C — Identity/P1 governance and security

### Objective and problem

Prepare unresolved Identity/P1 governance and security decisions needed by future trusted authorization consumers while preserving ADR-0006 and Identity Milestone 2B boundaries.

### Included scope

- P1 trusted identity, AuthorizationContext, capability, ownership, and delegation contracts;
- unresolved P1 Owner decisions and deferred C0 matters where they are dependencies, without reopening them implicitly;
- authentication/session/MFA prerequisites and fail-closed boundaries;
- security-review evidence gaps, operational role separation, and production prerequisites;
- relationship among I1, P1, P2, P3, and future consumers; and
- decision/evidence requirements for any future Devise-versus-custom spike.

### Exclusions and non-goals

- Identity implementation, Milestone 2B, ADR-0006 acceptance, or provider selection;
- Session, credential, MFA, role, delegation, or AuthorizationContext code/schema;
- dependency adoption or installation;
- treating Devise 5 or the curated GitLab Gemfile reference as an approved foundation; and
- P2/P3/Package C implementation.

### Deliverables and sources

Deliver a governance-dependency matrix, security evidence gap register, Owner decision briefs, future spike authorization prerequisites, and consumer contract boundary summary. Sources include the [Identity Decision Register](../architecture/after_four_identity_decision_register.md), [Identity Technical Design](../architecture/after_four_identity_technical_design.md), [P1 Design](../architecture/after_four_p1_trusted_identity_authorization_design.md), [ADR-0006](../architecture/adr/0006-authentication-session-topology.md), Identity security review records, and the Owner-approved-but-no-adoption [GitLab Gemfile research](after_four_gitlab_gemfile_reference_review.md).

### Review, decisions, and exit criteria

- Policy, design proposal, executed evidence, and missing evidence remain distinct.
- No generic role title or client input is treated as authority.
- Required Owner and security/operational reviews are explicit.
- Exit is a decision-ready governance/security package; any spike or implementation requires separate authorization.

## 7. P2A — Loyalty and Promotions policy closure

### Objective and problem

Prepare separate Loyalty and Promotion policy baselines while reconciling their shared Customer-anonymization inputs. Shared review does not create a combined bounded context or ownership model.

### Included scope

| Track | Included questions | Existing fixed boundary |
|---|---|---|
| Loyalty | earning, redemption, expiry, adjustment, reversal, reconciliation, Brand/Organization scope, and source-fact authority | `SDP-CUST-01` preserves balance/ledger/history and freezes redemption after effective anonymization; `SDP-CUST-02` limits downstream identity references |
| Promotions | eligibility, stacking, priority, limits, entitlement lifecycle, redemption, cancellation/refund effects, and cross-Brand questions | `SDP-CUST-17` preserves redeemed history and freezes unused Customer-specific benefits without transfer; public Promotions remain separately governed |

### Exclusions and non-goals

- combining Loyalty and Promotions ownership or schemas;
- inventing transfer, expiry, redemption, stacking, or cross-Brand policy;
- identity reconstruction or unrestricted mapping access;
- pricing engine, Order allocation, physical ledger, entitlement schema, or implementation; and
- legal/privacy compliance or retention-period conclusions.

### Deliverables and sources

Deliver two Owner decision briefs, two concept/lifecycle inventories, a shared anonymization-interface trace, and separate technical-prerequisite lists. Sources include [SDP-CUST-01](../architecture/after_four_sdp_cust_01_owner_decision.md), [SDP-CUST-02](../architecture/after_four_sdp_cust_02_owner_decision.md), [Customer Owner Decisions](../architecture/after_four_customer_management_owner_decisions.md), the [Business Domain Model](../architecture/after_four_business_domain_model.md), and relevant Order/Payment facts.

### Review, decisions, and exit criteria

- Each decision has one primary policy owner and explicit cross-references.
- Customer anonymization constraints are preserved without adding Customer implementation scope.
- Exit requires separate policy outcomes or explicit blockers for each track; physical design remains unauthorized.

## 8. P2B — Inventory, Cash, and Workforce discovery

### Objective and organization

Produce three independent domain annexes under one review cadence. The shared cadence is administrative only and creates no shared lifecycle, aggregate, transaction, schema, or authority boundary.

| Annex | Discovery scope | Key risks and dependencies | Required output |
|---|---|---|---|
| Inventory and procurement | stock movement, units/conversion, receiving, transfer, stocktake, spoilage, reservation, costing, correction, recipe/Preparation seam, and authority | negative stock, provenance, duplicate delivery, costing/accounting inputs, Branch scope | use-case inventory, candidate concepts, policy questions, integration risks, qualified-review needs |
| Cash and expenses | Cash Session, float, movements, expense approval, counts, discrepancies, handover, correction, Payment reconciliation, and evidence | actor accountability, close/reopen, accounting treatment, retention, Payment ownership | separate Cash/Expense boundary brief and Owner/accounting decision backlog |
| Workforce and payroll | employment/assignment, scheduling, attendance, payroll period/run, components, closure, correction, access, and reporting | sensitive data, labor/payroll/legal input, Identity separation, employee accountability without revenue scoring | Workforce/Payroll boundary brief, sensitive-data classification, qualified-review and policy backlog |

### Exclusions and non-goals

- merging the three domains or selecting shared persistence;
- costing, payroll, tax, accounting, or labor-compliance conclusions;
- Inventory ledger, Cash ledger, payroll calculation, schema, or implementation;
- inferring authorization from employment or Branch assignment; and
- direct cross-context record manipulation.

### Review and exit criteria

Each annex must identify authoritative facts, candidate aggregate boundaries, concrete scenarios, unresolved policy, sensitive data, external inputs, and the next smallest decision package. One annex may exit independently; no annex's completion implies another's readiness.

## 9. P2C — Demand-driven Organization extension

### Objective and activation rule

Keep Organization extension inactive until a specific named consumer or administration use case demonstrates that A1/I1 is insufficient. A general desire for reusable infrastructure is not an activation trigger.

Valid activation evidence must identify:

- the named consumer or administration operation;
- the authoritative Organization/Brand/Branch fact required;
- why the existing A1 reference foundation and I1 ancestry contract are insufficient;
- authority, scope, failure, audit, and lifecycle questions;
- proposed Application contract boundary; and
- explicit exclusions and affected packages.

### Exclusions, review, and exit criteria

No broad Organization redesign, production mapping, provisioning platform, cross-context persistence shortcut, or administration implementation is authorized. Activation requires an Owner-reviewed brief for one bounded requirement. Only after activation may a separate design task be requested; no implementation follows automatically.

## 10. P3 — Operations and Reporting/Audit governance

### Objective and problem

Prepare two governance/discovery tracks that clarify ownership and evidence needs without selecting universal schemas or operational mechanisms.

### Operations track

Cover table/session ownership, assets, maintenance, operational checklists, Branch-scoped configuration, actor authority, lifecycle, Ordering integration, concurrency questions, and retention. Produce an Operations boundary/options brief and prioritized business-workflow questions.

### Reporting/Audit track

Cover source-domain fact ownership, audit versus reporting responsibilities, Branch/Brand scope, actor/correlation provenance, daily Telegram reporting versus Owner Dashboard, readers, export, legal hold, redaction, integrity, projections, and delivery/replay questions. Preserve bounded Phase 1 AuditEvent/Outbox evidence and P2/P3 proposals without inferring a universal AuditEvent contract.

### Exclusions and non-goals

- unapproved retention durations, reader/export permissions, legal-hold procedure, or compliance conclusions;
- universal audit/reporting tables, physical storage, projection infrastructure, delivery workers, or production access;
- merging Operations with Ordering or transferring source-domain ownership; and
- P2/P3 implementation, runtime database security changes, or monitoring deployment.

### Review and exit criteria

Exit requires separate Operations and Reporting/Audit governance briefs, explicit source owners, decision-ready questions, qualified-review needs, and bounded next-step options. A shared review checkpoint may reconcile evidence vocabulary but must not merge the tracks.

## 11. Cross-package interface register

| Interface | Fact owner | Consumer need | Coordination rule |
|---|---|---|---|
| Catalog definition → Order snapshot | Catalog / Ordering | Current sellable definition versus immutable confirmed commercial facts | P1A and P1B reconcile terminology; neither selects persistence |
| Payment settlement → Cash evidence | Payment / Cash | Settlement truth versus drawer/session accountability | P1A and P2B Cash exchange questions, not records or ownership |
| Preparation fact → Inventory movement | Preparation / Inventory | Durable source fact for later stock movement | P2B records contract needs; no automatic movement is designed |
| Customer anonymization → Loyalty/Promotions/Ordering | Customer plus receiving contexts | Purpose-limited postconditions and completion evidence | P2A preserves accepted Candidate E semantics; Candidate E Gate B remains excluded |
| Identity authorization → protected operations | Identity plus target-owning context | Trusted actor/session/capability and authoritative target scope | P1C records future contract prerequisites; no runtime integration |
| Source domains → Reporting/Audit | Each source domain | Read/evidence projections and provenance | P3 preserves source ownership and unresolved reader/retention governance |

No interface in this register authorizes a shared database relationship, synchronous transaction, event transport, or API.

## 12. Package acceptance and stop conditions

A package is ready for Owner review only when:

- canonical sources and contradictory evidence are enumerated;
- confirmed policies are quoted or linked without reinterpretation;
- options are materially distinct and do not hide technical choices as business policy;
- dependencies and domain ownership are explicit;
- unresolved legal/security/operational inputs remain visible;
- non-goals and authorization boundaries are testable from the document; and
- the requested next action is a bounded Owner decision or separately authorized design task.

Stop the affected package when:

- a required Owner policy or primary decision owner cannot be determined;
- evidence conflicts and no canonical source resolves it;
- work would require physical persistence, application code, runtime access, a dependency, or production evidence;
- a qualified legal/accounting/payroll/security input is required but unavailable; or
- the requested next step exceeds `NW-OR-01`.

An individual package blocker does not automatically block unrelated packages.

## 13. Decision and authorization summary

| Matter | Current status |
|---|---|
| E-OR-01 Candidate E semantic baseline | `ACCEPT_BOUNDED_SEMANTIC_DESIGN_BASELINE` |
| E-OR-02 Candidate E Gate A | `DEFER_GATE_A — NOT_GRANTED` |
| Candidate E Gate B proposal preparation | `NOT_AUTHORIZED` |
| NW-OR-01 portfolio preparation | `AUTHORIZED` for the named documentation/design scope only |
| Canonical `ODB-*` IDs for E-OR-01/E-OR-02/NW-OR-01 | `ID_PENDING_OWNER_GOVERNANCE` |
| Physical database design | `NOT_GRANTED` |
| Schema/migrations/database operations | `NOT_AUTHORIZED` |
| Code/tests/runtime/dependencies/deployment | `NOT_AUTHORIZED` |
| Gate C / Control Acceptance / residual-risk acceptance | `NOT_GRANTED` |
| FOA / Production Authorization | `NOT_GRANTED` |

Completion of this plan or any package artifact does not change these statuses without a separate explicit Owner decision.
