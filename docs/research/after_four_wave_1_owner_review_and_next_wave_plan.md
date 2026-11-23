# AFTER FOUR — Wave 1 Owner Review and Next-Wave Plan

**Package status:** `READY_FOR_OWNER_REVIEW — DECISIONS_UNSELECTED`

**Verified base main:** `cd397884db32d94a49df45cf79f235251d28e461`

**Candidate E:** `NOT_READY`

**Candidate E Gate A:** `NOT_GRANTED`

**Physical database design approval:** `NOT_GRANTED`

**Implementation authorization:** `NOT_GRANTED`

**Final Operational Acceptance / Production Authorization:** `NOT_GRANTED`

**Date:** 2026-11-23

## 1. Executive decision summary

Acceleration Wave 1 established two decision-preparation artifacts: the [Candidate E Owner Review Dossier](after_four_candidate_e_owner_review_dossier.md) and the [Project-wide Logical Database Design Inventory](../architecture/after_four_logical_database_design_inventory.md). It did not make an Owner decision or grant a Gate.

| Evidence or governance layer | Current result | Meaning and boundary |
|---|---|---|
| Owner-approved policy | Customer `SDP-*` decisions, scope decisions, existing domain decisions, and accepted ADR foundations remain authoritative within their exact scopes. | Policy approval does not select physical persistence or authorize implementation. |
| B01 supporting research | `OWNER_APPROVED — RESEARCH ACCEPTED; DEPENDENCY ADOPTION NOT AUTHORIZED` | The Owner accepted the curated GitLab Gemfile research and its §15 dependency-management principles. No gem or authentication foundation was selected. B01 is supplementary post-freeze governance evidence, not part of the Candidate E Frozen Manifest. |
| Candidate E semantic design | Frozen and independently reviewed `TECHNICAL_PROPOSAL`; `T1-IR-01` through `T1-IR-04` are resolved. | Owner semantic-design acceptance remains undecided. Review completion is not acceptance, Gate approval, runtime evidence, or production proof. |
| Bounded implementation evidence | A1/I1, Catalog Package B, and Order/Payment/Preparation Phase 1 have evidence only within their recorded scopes. | No bounded implementation proves unrestricted runtime, cross-domain, operational, or production readiness. |
| Logical database inventory | Fourteen domain areas are classified by policy, design, proposal, implementation evidence, and unresolved requirements. | It is preparation for future bounded design, not a physical schema baseline. |
| Deferred matters | Physical persistence, cross-context completion, runtime authorization, legal/privacy details, operational controls, and domain-specific open policies remain deferred as recorded. | No missing mechanism or policy may be inferred from an ERD, dictionary, role name, phone, identifier, or existing implementation. |

The next decisions are deliberately separate:

1. `E-OR-01`: whether to accept the frozen bounded Candidate E semantic-design baseline.
2. `E-OR-02`: whether to grant Candidate E Gate A after `E-OR-01`.
3. `NW-OR-01`: which documentation/design work packages the Owner wants prepared next.

`E-OR-01`, `E-OR-02`, and `NW-OR-01` are temporary review references, not canonical `ODB-*` IDs. None is selected by this package.

## 2. Candidate E — E-OR-01 bounded semantic-design acceptance

### 2.1 Exact decision subject

The decision subject is the immutable evidence identified by the [Frozen Reviewed Baseline Manifest](after_four_candidate_e_frozen_reviewed_baseline_manifest.md), with frozen baseline `8d406314acbd390d431d75799b1f66499439f117`. B01 was approved afterward and is supplementary governance evidence; it does not alter WP-T1 or a pinned manifest blob.

The bounded proposal includes the semantic outcomes in [WP-G0 §§2–3](../architecture/after_four_wp_g0_candidate_e_scope_charter.md#2-included-semantic-subject-areas) and [WP-T1 §§3–8](../architecture/after_four_customer_technical_design.md#3-candidate-e-scope), including:

- ordinary verified phone change and the approved Inactive-Profile outcome;
- approved disputed/exception authority paths already inside the charter;
- non-disclosing duplicate/admission outcomes;
- Customer Profile lifecycle and the conceptual distinction among current association, former-phone restriction, Customer Review Case, and Restricted Identity Evidence;
- logical completion, failure-certainty, retry-identity, and concurrency-required outcomes; and
- Customer-side anonymization completion postconditions after anonymization was validly initiated through a separately authorized process.

The reviewed concurrency scope includes same-Profile changes, overlapping old/new phone resources, relevant lifecycle races, and the Customer-side anonymization-completion race. It selects no persistence topology, transaction, lock, isolation level, idempotency mechanism, retry schedule, reconciliation implementation, API, or runtime authorization mechanism.

### 2.2 Preserved exclusions

The five authority-dependent operations remain outside Candidate E:

1. Customer Profile creation.
2. Ordinary Deactivate.
3. Reactivate.
4. Anonymization approval.
5. Ordinary undisputed former-phone release.

Existing policy may constrain relevant semantics, but complete use cases, authority assignments, execution flows, and implementation postconditions for these operations are not approved.

`SDP-CUST-18` and `SDP-CUST-19` remain Owner-approved context only. Candidate E neither reviews nor approves an assisted shared/family-phone workflow, anonymous-Order association, or Order-domain implementation. See [Dossier §§2.2–3](after_four_candidate_e_owner_review_dossier.md#22-five-authority-operations-excluded).

### 2.3 Decision options

| Option | Meaning | Material trade-off |
|---|---|---|
| `ACCEPT_BOUNDED_SEMANTIC_DESIGN_BASELINE` | Accept the frozen semantic proposal within its exact scope and exclusions. | Creates a stable baseline for a separate Gate A decision and later bounded proposal; downstream physical design must preserve it. |
| `ACCEPT_WITH_EXPLICIT_CONDITIONS` | Available only if applicable existing governance explicitly permits conditional semantic-design acceptance; any conditions must be explicit, bounded, objectively verifiable, and must not silently rewrite the frozen baseline. | This E-OR-01 outcome is distinct from Gate A. If permitted and selected, every condition must be resolved and verified before E-OR-02 can be considered; a condition that changes scope or semantics requires an amended/re-reviewed baseline. |
| `DEFER` | Make no design-acceptance decision. | Preserves flexibility but leaves Candidate E and Gate A blocked. |
| `REJECT` | Reject the bounded semantic baseline. | Requires a new design direction and another evidence/review cycle. |

**Recommendation:** `ACCEPT_BOUNDED_SEMANTIC_DESIGN_BASELINE`. Independent review resolved all four technical findings, the evidence is immutable, and unresolved physical, authorization, legal/privacy, and operational matters are explicitly excluded. This recommendation assumes the Owner agrees with the exact frozen semantic outcomes and does not want to add any excluded operation. The principal trade-off is that later design must conform to these semantics; acceptance still grants no Gate or implementation authority.

Owner decision: __________________________________________

Conditions or rationale: ________________________________________________________________

Decision date and Owner identity/role: __________________________________________________

## 3. Candidate E — E-OR-02 Gate A

### 3.1 Separate decision boundary

`E-OR-01` acceptance does not automatically grant Gate A. Gate A may be considered only after the Owner records a valid semantic-design acceptance outcome.

The canonical Owner Decision Baseline, Foundation Decisions, and accepted ADRs do not establish a conditional Gate A approval mechanism. Earlier research packages mention conditional Gate A only as a contingent option if existing governance permits it; those preparation artifacts do not create that authority. Accordingly, E-OR-02 offers no conditional-approval outcome: if a prerequisite or requested condition is unresolved, the truthful outcome is `DEFER_GATE_A` or `NOT_GRANTED` until it is resolved and the Owner can make a separate explicit Gate A decision.

E-OR-02 has no conditional-approval outcome. An unresolved prerequisite or condition requires `DEFER_GATE_A` or `NOT_GRANTED`; it cannot be converted into conditional Gate A approval.

| Option | Meaning | Material trade-off |
|---|---|---|
| `APPROVE_GATE_A` | Approve only the frozen bounded semantic baseline and permit preparation of a separately reviewed bounded Gate B proposal. | Fastest controlled continuation; grants no physical design or coding authorization. |
| `DEFER_GATE_A` | Leave Gate A pending. | Avoids premature approval but blocks Candidate E Gate B preparation. |
| `NOT_GRANTED` | Record that Gate A is not granted. | No downstream Candidate E authorization follows. |

**Recommendation:** `APPROVE_GATE_A`, but only after an explicit `E-OR-01` acceptance and only for the frozen scope. The evidence is sufficient for semantic governance review, while every physical and runtime concern is visibly assigned to later gates. If the Owner requires a semantic or scope change, the safer option is `DEFER_GATE_A` until an amended baseline is reviewed.

Gate A does not grant Gate B; authorize schema, migrations, database creation, application/test code, API/UI, runtime authorization, deployment, or production use; or bring any of the five excluded operations into scope.

Owner decision: __________________________________________

Rationale or prerequisite blocker: ______________________________________________________

Decision date and Owner identity/role: __________________________________________________

## 4. Logical database design — fourteen-domain review

The canonical source is the [Logical Database Design Inventory §§2–7](../architecture/after_four_logical_database_design_inventory.md#2-domain-inventory). The classifications below remain distinct:

- `OWNER_APPROVED_BUSINESS_INVARIANT`;
- `ACCEPTED_DESIGN_LEVEL_INVARIANT`;
- `INDEPENDENTLY_REVIEWED_TECHNICAL_PROPOSAL`;
- `PROPOSED_TECHNICAL_ENFORCEMENT`;
- `BOUNDED_IMPLEMENTED_EVIDENCE`; and
- `UNRESOLVED_REQUIREMENT`.

Conceptual ERDs, dictionaries, accepted platform ADRs, and bounded implementation evidence do not establish domain-wide physical-schema readiness.

### 4.1 Domain assessment matrix

| Domain | Evidence, maturity, and Owner-policy readiness | Logical gaps, dependencies, and concerns | Bounded work that may proceed now | Must remain deferred / prohibited inference | Next deliverable and Owner input |
|---|---|---|---|---|---|
| 1. Organization | Organization → Brand → Branch is established; A1 reference persistence and I1 ancestry have `BOUNDED_IMPLEMENTED_EVIDENCE`. | Administration, lifecycle, production mapping, remapping, and wider consumers remain undesigned. Identity/Catalog consume ancestry through contracts; they do not own it. | A bounded extension-design brief for one identified consumer or administration use case. | No unrestricted Organization administration, production mapping, or inferred cross-context FK. | Reconcile the exact extension scope; Owner decision is needed only when administration/mapping authority or a new bounded operation is proposed. |
| 2. Identity | Owner policies exist; I1 ancestry is implemented; P1 is design-only and ADR-0006 remains `Proposed`. | P1 open decisions, Session/MFA policy under deferred `C0-R05`, retry/idempotency under deferred `C0-R11`, runtime wiring, secrets, and operational roles remain. | P1 governance/security decision preparation and evidence planning. | No authentication, Session, AuthorizationContext, delegation, capability, Devise, or Milestone 2B implementation. Workforce assignment is not authorization. | P1 Owner-decision closure package plus bounded security/operational evidence plan. Explicit Owner decisions remain required. |
| 3. Catalog | Owner lifecycle/integrity policies and Package B `BOUNDED_IMPLEMENTED_EVIDENCE` exist; Package C/P2/P3 remain proposals. | Current-state documentation reconciliation, operation authority, P1/P2/P3, CAT-TRR operational evidence, pricing/menu/availability, and lifecycle runtime are incomplete. | Reconcile Package B evidence and prepare one operation-specific logical-design proposal. | Package B does not authorize Package C, runtime lifecycle DML, pricing, menu publication, or new schema. | Catalog current-state reconciliation and a separately bounded operation-design candidate; Owner selects any later operation/scope. |
| 4. Customer | `SDP-*` policies are approved; Candidate E is an independently reviewed proposal, not yet Owner-accepted. | E-OR-01/E-OR-02, five excluded authorities, physical representation, runtime authorization, retention/legal details, and receiving-context mechanisms remain. | Conduct the two Owner decisions in §§2–3. | No WP4.3, WP-T2, physical Customer schema, runtime flow, shared-phone workflow, or anonymous-Order design. | Record E-OR-01, then E-OR-02 separately; only an approved Gate A may lead to a separately authorized Gate B proposal. |
| 5. Loyalty | Production MVP scope and `SDP-CUST-01/02` preserve/freeze and pseudonymous-provenance boundaries are Owner-approved. Core model is not implementation-ready. | Earning/redemption formulas, expiry, reversal, adjustment, negative balance, scope, refunds, aggregate/ledger, legal/privacy, and Customer integration remain. | Consolidated Loyalty policy discovery and decision brief. | No ledger/schema, balance calculation, cross-Brand sharing, identity reconstruction, or redemption implementation. | Loyalty policy-closure package. Owner decisions are required for calculation, scope, correction, and authority policies. |
| 6. Promotions | Production MVP advanced-engine scope and `SDP-CUST-17/02` anonymization boundaries are approved; general rule design is not. | Eligibility, stacking, precedence, issuance/reuse, limits, allocation, tax/refund effects, cross-Brand applicability, authority, retention, and entitlement lifecycle remain. | Consolidated Promotions policy discovery, preferably alongside Loyalty but with separate ownership. | No rule engine, entitlement schema, cross-Brand behavior, or inference that anonymization policy defines general eligibility. | Promotions policy-closure package with Owner-selectable business options. |
| 7. Ordering | Owner policies and Phase 1 bounded command/constraint evidence exist. Anonymous Orders are permitted; later association is unresolved. | Catalog-backed construction, pricing/tax/discount snapshots, tables/additional items, cancellation/refund outcomes, Customer association, API, and authorization remain. | Combined Order/Payment policy-closure package and bounded logical gap analysis. | No public API, item/pricing implementation, Customer auto-association, or automatic expansion beyond Phase 1. | Decision briefs for cancellation/refund, Customer association, commercial snapshot inputs, and remaining lifecycle exceptions. |
| 8. Payment | Canonical Payment Model has accepted design-level invariants; Phase 1 exact-balance cash/manual-bank flow has bounded evidence. | Split/partial/overpayment/mismatch policy, refund authority/method, provider/reconciliation, retention, chargebacks, and production idempotency remain. | Consolidate Payment policy decisions with Ordering. | Exact-balance is an implementation limitation, not permanent policy; evidence cannot be generalized to all providers/refunds. | Order/Payment policy-closure package with Owner options for allocation, mismatch, refund, and late-success review authority. |
| 9. Preparation | Phase 1 PreparationDispatch/outbox/audit has bounded evidence. | KDS/publisher, ticket workflow, delivery/retry, cancellation after dispatch, handoff, Inventory consumption, and monitoring remain. | Document Preparation integration dependencies after Order/Payment policy boundaries are stable. | No publisher/KDS/runtime retry, new attempt records, or automatic Inventory movement. | Preparation/fulfillment integration brief; Owner decisions only for business workflow or exception authority not already established. |
| 10. Inventory | Business Domain Model, dictionary, ERD, and integrity rules are conceptual; policy/model readiness is low. | Aggregate boundaries, UoM/conversion, costing, negative stock, reservation, correction, stocktake, transfer/receipt, recipe seam, authority, and concurrency are open. | Inventory domain discovery and Owner decision preparation. | No physical stock ledger, FK, index, lock, costing algorithm, or recipe integration. | Inventory policy and aggregate-boundary brief; Owner decisions for negative-stock, costing, correction, and operational authority. |
| 11. Cash | Confirmed float/expense/approval/handover policies exist; physical accounting model is unresolved. | Cash Session/ledger boundary, Payment reconciliation, denomination/counting, discrepancies, corrections, close/reopen, retention, and accounting/legal review remain. | Cash/Expense domain foundation review as a distinct sub-track. | Do not merge Cash ownership with Payment settlement or infer accounting compliance. | Cash/Expense logical-boundary and policy-gap brief; Owner/accounting decisions for exceptions and corrections. |
| 12. Workforce | Conceptual model and partial policies exist; employment/payroll/attendance data is highly sensitive. | Employment/Branch assignment, scheduling/time, payroll calculation/closure/correction, authorization seam, access, retention, and legal/payroll requirements remain. | Workforce/Payroll discovery and risk classification. | No payroll schema/calculation, Identity authority inference, employee revenue scoring, or compliance claim. | Workforce/Payroll boundary and qualified-review prerequisite package; Owner decisions follow domain/legal discovery. |
| 13. Operations | Tables, assets, maintenance, and operational tasks are conceptual; context ownership is not implementation-ready. | Ownership, lifecycle, authority, Branch scope, Ordering/table-session integration, concurrency, and retention remain. | Bounded-context and workflow discovery. | No shared aggregate with Ordering, inferred FK topology, table-session implementation, or asset workflow. | Operations boundary/options brief; Owner chooses priority and business workflow before technical design. |
| 14. Reporting/Audit | Phase 1 has bounded Branch-scoped AuditEvent/Outbox evidence; P2/P3 are proposed; `C0-R08` is deferred. | Project-wide taxonomy, readers, retention, legal hold, export, redaction, integrity, projections, delivery/replay, privacy, and production operations remain. | Audit/reporting governance preparation and source-domain ownership reconciliation. | No universal AuditEvent/reporting schema, project-wide atomicity inference, reader/export grant, or compliance claim. | Reporting/Audit governance brief and qualified retention/privacy review; Owner decisions for readers, export, hold, and reporting priorities. |

## 5. Recommended next-wave prioritization

The optimal plan keeps the two Candidate E decisions sequential while allowing unrelated discovery/design preparation to run in parallel. It avoids treating every domain as one delivery stream or inventing a shared aggregate.

| Priority / package | Rationale and deliverable | Dependencies and parallelism | Owner decisions | Must not authorize | Exit criteria |
|---|---|---|---|---|---|
| P0 — Candidate E Owner decisions | Record E-OR-01 and then E-OR-02 against the frozen evidence. | E-OR-02 depends on a valid E-OR-01 outcome. Other documentation tracks may run in parallel. | E-OR-01 and E-OR-02. | Physical design, Gate B, implementation, or excluded operations. | Both decisions are truthfully recorded with their exact scope, or blockers are explicitly retained. |
| P1A — Order/Payment policy closure | One consolidated decision package for allocation, refund/cancellation, mismatch/overpayment, late success, and Customer association boundaries. | Uses Phase 1 evidence and Catalog/Customer policies; can run beside P1B/P1C. | Multiple business-policy choices must be presented, not inferred. | Changes to Phase 1 code, schema, API, or provider integration. | Owner decisions and remaining technical questions are separated and traceable. |
| P1B — Catalog current-state reconciliation | Align design/readiness records with Package B evidence and identify one bounded next operation/design candidate. | Independent of Candidate E; P1/P2/P3 remain prerequisites for runtime operations. | Owner selects any new operation or later scope. | Package C implementation, lifecycle DML, pricing, or CAT-TRR closure. | Current-state contradictions removed; one bounded proposal has explicit prerequisites. |
| P1C — Identity/P1 governance and security | Resolve P1 Owner questions and define evidence prerequisites for trusted authorization consumers. | Can run in parallel; runtime consumers wait for later authorization. | P1-specific decisions; deferred C0 matters remain deferred unless explicitly reopened. | Identity Milestone 2B, Devise adoption, Session/MFA implementation, or ADR-0006 acceptance. | Decision-ready P1 package and explicit security/operational evidence gaps. |
| P2A — Loyalty and Promotions policy closure | One governance package with two separately owned policy tracks and shared anonymization traceability. | May start now; physical design waits for Owner policy closure. | Loyalty calculation/scope/correction and Promotion eligibility/stacking/authority decisions. | A combined bounded context, shared schema, or identity reconstruction. | Each domain has an approved policy baseline or explicit blockers and separate ownership. |
| P2B — Inventory/Cash/Workforce discovery | One administrative umbrella with three independent domain annexes to reduce review overhead without merging ownership. | Can run concurrently by annex; accounting/payroll/legal inputs may block individual conclusions. | Domain-specific business policies after discovery. | Shared aggregates, physical schema, accounting/payroll compliance claims, or Identity authority inference. | Each annex identifies aggregate candidates, policy gaps, sensitive data, qualified-review needs, and next decision package. |
| P2C — Organization bounded extension design | Prepare only when a named consumer or administration use case requires more than A1/I1. | Depends on a concrete scope; otherwise defer to avoid speculative infrastructure. | Owner approves the specific operation/authority boundary. | General administration platform, production mapping, or cross-context persistence shortcuts. | One bounded requirement, contract boundary, evidence plan, and explicit exclusions. |
| P3 — Operations and Reporting/Audit governance | Clarify Operations ownership and project-wide audit/reporting governance after higher-risk policy gaps are visible. | Can begin discovery in parallel; final reader/retention/export conclusions need qualified inputs and source-domain boundaries. | Operations priority/workflow; audit readers/export/hold/report priorities. | Universal schemas, production access, or legal/privacy conclusions. | Context ownership, governance questions, and prerequisites are decision-ready. |

### 5.1 Sequencing trade-offs

- Running P1A, P1B, and P1C in parallel shortens the critical path because their primary decisions differ, while their dependencies can be recorded rather than implemented.
- Combining Loyalty and Promotions into one governance review reduces repeated anonymization review, but their decisions and ownership must remain separate.
- Inventory, Cash, and Workforce may share one review cadence, not one model; separate annexes prevent artificial coupling.
- Organization extension work is intentionally demand-driven because A1/I1 already serves its bounded purpose and speculative administration design would create premature abstractions.
- Candidate E Gate B preparation must wait for E-OR-01 and E-OR-02; unrelated domain discovery need not wait.

## 6. Cross-domain dependency and conflict review

| Dependency | Classification | Confirmed boundary | Proposed/unresolved dependency and invalidating risk |
|---|---|---|---|
| Organization/Brand/Branch scope → consumers | Confirmed hierarchy; bounded I1 evidence | Organization owns authoritative ancestry; client scope is not authority. | Each consumer still needs an approved contract and authorization path. Direct persistence access would violate ADR-0011 and could invalidate scope checks. |
| Identity → operation-specific authorization | Owner policy confirmed; runtime proposed/unimplemented | Role title, phone, Customer ID, Employee assignment, or target ID alone grants no authority; cross-Brand defaults to deny. | Missing P1/Session/capability/delegation runtime blocks protected operations and physical workflow proof. |
| Customer identity ↔ phone admission | Owner policy confirmed; Candidate E proposal reviewed | Phone admission is Organization-scoped; phone equality is not identity; Profile, admission, review case, and restricted evidence remain distinct. | A shared identifier/store or automatic match could create unauthorized identity reconstruction and cross-Brand disclosure. |
| Customer anonymization → Loyalty/Promotions/Ordering | Business postconditions confirmed; completion proposed | Loyalty preserves/freezes; Promotions preserves history/freezes unused benefits; downstream references are purpose-proportionate and pseudonymous where needed. | Receiving-context acknowledgement, recovery, retention, and legal treatment remain unselected; no single transaction or universal store is implied. |
| Catalog evolution → Order commercial snapshot | Ownership boundary confirmed; integration incomplete | Catalog owns current definitions; Ordering owns confirmed historical snapshots. | Missing quote/version/reprice contracts could make old Orders mutable or totals non-authoritative. |
| Payment confirmation → Preparation dispatch | Owner invariant and bounded Phase 1 evidence | Only verified eligible payment dispatches; late/held/expired outcomes do not automatically dispatch. | Provider, refund, split/partial, reconciliation, and KDS extensions require separate policies and proof. |
| Preparation → Inventory movement | Contextual/proposed | Preparation execution and Inventory stock facts retain separate ownership. | Recipe version, units, delivery duplication, and reversal semantics are unresolved; direct shared writes would blur provenance. |
| Payment settlement ↔ Cash/expense accounting | Ownership separation confirmed; integration unresolved | Payment owns settlement truth; Cash owns drawer/session evidence. | Reconciliation, excess/refund, correction, and accounting treatment could conflict if either context rewrites the other. |
| Workforce/payroll → Identity/operations | Conceptual and unresolved | Employment/assignment facts are not authorization grants. | Legal/retention rules and assignment-to-capability policy are missing; direct inference could overgrant access. |
| Source contexts → Reporting/Audit | Ownership separation confirmed; broader design unresolved | Source contexts retain authority; audit/reporting preserve evidence and references. | Reader/export authority, retention, legal hold, redaction, replay, and pseudonymous provenance could invalidate a universal reporting/audit model. |

## 7. Consolidated Owner decision register

No option is selected below. B01 is not reopened: it remains `OWNER_APPROVED — RESEARCH ACCEPTED; DEPENDENCY ADOPTION NOT AUTHORIZED`. No gem was selected or installed; Devise 5 remains only a future candidate, and a Devise-versus-custom spike requires a separate Owner decision after review of ADR-0006 and applicable authentication requirements.

| Temporary review reference | Decision question and evidence | Recommended option | Alternatives and trade-offs | Dependencies and scope impact | Does not authorize | Owner decision |
|---|---|---|---|---|---|---|
| `E-OR-01` | Accept the frozen bounded Candidate E semantic design? Evidence: Frozen Manifest, WP-G0, WP-T1, resolved independent review. | `ACCEPT_BOUNDED_SEMANTIC_DESIGN_BASELINE` for the exact scope. | Conditional semantic-design acceptance is distinct from conditional Gate A approval and is available only if applicable existing governance explicitly supports it. If permitted and selected, every condition must be resolved and verified before E-OR-02 can be considered; defer/reject avoids unsupported or premature acceptance. | Required before E-OR-02; stabilizes semantics only. E-OR-02 has no conditional-approval outcome. | Gate A, physical design, Gate B, implementation, excluded operations, legal/privacy approval. | ____________________ |
| `E-OR-02` | Grant Candidate E Gate A after a valid E-OR-01 outcome? | `APPROVE_GATE_A` for the frozen scope only. | `DEFER_GATE_A` or `NOT_GRANTED` applies while any prerequisite or E-OR-01 condition remains unresolved; E-OR-02 has no conditional-approval outcome. | Depends on a valid E-OR-01 outcome and, where applicable, verified resolution of every permitted E-OR-01 condition; permits only a separately reviewed Gate B proposal. | Schema, migrations, database creation, code, runtime authorization, Gate B/C, FOA, production. | ____________________ |
| `NW-OR-01` | Which next-wave documentation/design portfolio should be authorized for preparation? Evidence: §4 inventory and §5 dependency plan. | Authorize P1A, P1B, and P1C in parallel; authorize P2A/P2B discovery; keep P2C demand-driven and P3 at governance/discovery level. | A narrower portfolio reduces review load but lengthens the critical path; a broader portfolio raises coordination and premature-design risk. | Does not depend on Candidate E Gate A except for Candidate E Gate B work; each package retains its own exit gate. | Any package's substantive Owner decisions, physical design, implementation, dependency adoption, or production activity. | ____________________ |

Domain-specific unresolved questions in §4 are decision-preparation backlog, not pre-approved decisions and not silently allocated temporary or canonical IDs by this package.

## 8. Gate and authorization roadmap

| Stage | Required evidence | Required explicit approval | What completion permits | What remains prohibited |
|---|---|---|---|---|
| Current documentation/design preparation | Canonical policy traceability, reviewed evidence, truthful readiness/gap inventory | Authorization for the named documentation task | Owner review and bounded proposal preparation only | Owner decision inference, schema, code, runtime/database changes |
| Candidate E semantic acceptance | Frozen baseline/manifest, WP-G0 boundary, WP-T1, independent-review evidence | E-OR-01 | Records accepted semantic baseline only | Gate A/B, physical design, implementation |
| Candidate E Gate A | Valid E-OR-01 result, explicit scope/exclusions, and verified resolution of every permitted E-OR-01 condition | E-OR-02 | Preparation of a separately reviewed bounded Gate B proposal | Physical/schema work, migrations, code, excluded operations |
| Future bounded Gate B proposal preparation | Approved Gate A baseline, exact proposed scope, physical/runtime alternatives, threat/failure analysis, migration/test/evidence plan, and prerequisites | Gate A's recorded proposal-preparation boundary plus any separately required documentation-task authorization | A reviewable Gate B authorization proposal only | Schema/migrations, implementation, database mutation, or treating the proposal as approved |
| Gate B implementation authorization | Frozen Gate B proposal/manifest, exact files/operations, test environment, rollback, threat/failure evidence, and unresolved risks | Explicit Owner Gate B decision for that exact bounded manifest | Only the specifically authorized implementation and verification scope | Unlisted files/operations, production, broader domains, automatic Gate C |
| Implementation and verification | Gate B authorization, controlled environment, exact diff, executed evidence, and unresolved findings | Existing Gate B boundary plus any separately required environment/data authority | Produces implementation evidence for review | Acceptance, deployment, production use, silent residual-risk acceptance |
| Gate C / Control Acceptance | Actual implementation evidence, security/control tests, remediation/retest, truthful limitations | Explicit Owner Gate C/Control Acceptance decision | Accepts only the named implemented control within recorded limits | FOA, legal compliance claim, production authorization |
| Final Operational Acceptance | Operational runbooks, role separation, monitoring, recovery, backup/restore, incident and dependency evidence, required legal/privacy inputs | Explicit FOA decision | Operational acceptance within the named environment/scope | Production use unless separately authorized |
| Production Authorization | FOA plus deployment/environment/data safeguards and all required business/security/legal prerequisites | Explicit Production Authorization | Only the approved production release and scope | Any unapproved domain, data use, dependency, or expansion |

No stage is granted automatically because the preceding artifact or stage is complete.

## 9. Recommended Owner review order

1. Decide E-OR-01 bounded semantic-design acceptance.
2. Decide E-OR-02 Gate A separately, only after the E-OR-01 outcome is recorded.
3. Review and prioritize the fourteen-domain logical database inventory without treating it as a physical schema.
4. Select the next-wave documentation/design packages and their true dependencies through NW-OR-01.
5. Record selected Owner decisions and preserve every unresolved matter explicitly.

This order first establishes what Candidate E means, then whether it passes its design gate, and only afterward chooses broader work. It prevents semantic acceptance from being mistaken for Gate approval, prevents Gate A from being mistaken for implementation authorization, and avoids physical design rework against an unstable policy baseline.

## 10. Explicit non-authorization statement

This package does not authorize:

- physical database schema or domain-specific migrations;
- database creation, mutation, or data changes;
- tables, columns, foreign-key topology, indexes, constraints, transaction boundaries, locks, isolation, or concurrency mechanisms;
- application, API, controller, UI, test, or runtime implementation;
- authentication, authorization, security-role, credential, or operational changes;
- new or expanded implementation scope;
- dependency installation/adoption or selection of Devise 5;
- WP-T2, WP4.3, or any Candidate E excluded operation;
- Gate A, Gate B, Gate C, Control Acceptance, residual-risk acceptance, FOA, or Production Authorization; or
- legal/privacy compliance conclusions.

Parallel preparation is limited to logical/domain analysis, evidence reconciliation, and decision-ready documentation. It is not permission to create schema, migrations, database objects, or application code.

## 11. Source and immutability index

- [Candidate E Owner Review Dossier](after_four_candidate_e_owner_review_dossier.md)
- [Candidate E Gate A Readiness Package](after_four_candidate_e_gate_a_readiness.md)
- [Candidate E Frozen Reviewed Baseline Manifest](after_four_candidate_e_frozen_reviewed_baseline_manifest.md)
- [Candidate E Owner Governance Review Package](after_four_candidate_e_owner_governance_review_package.md)
- [WP-G0 Candidate E Scope Charter](../architecture/after_four_wp_g0_candidate_e_scope_charter.md)
- [WP-T1 Customer Technical Design](../architecture/after_four_customer_technical_design.md)
- [Customer Management Owner Decisions](../architecture/after_four_customer_management_owner_decisions.md)
- [Owner Decision Baseline](../architecture/after_four_owner_decision_baseline.md)
- [Logical Database Design Inventory](../architecture/after_four_logical_database_design_inventory.md)
- [Business Domain Model](../architecture/after_four_business_domain_model.md)
- [DDD Foundation](../architecture/after_four_ddd_foundation.md)
- [ERD](../architecture/after_four_erd.md)
- [Data Dictionary](../architecture/after_four_data_dictionary.md)
- [Data Integrity Rules](../architecture/after_four_data_integrity_rules.md)
- [State Machines](../architecture/after_four_state_machines.md)
- [API Contract](../architecture/after_four_api_contract.md)
- [Phase 1 Implementation Record](../architecture/after_four_order_payment_implementation_phase1.md)
- [ADR-0003 — PostgreSQL Version Baseline](../architecture/adr/0003-postgresql-version-baseline.md)
- [ADR-0004 — UUID Primary Keys](../architecture/adr/0004-uuid-primary-keys.md)
- [ADR-0006 — Authentication and Session Topology (`Proposed`)](../architecture/adr/0006-authentication-session-topology.md)
- [ADR-0007 — Background Jobs and Outbox](../architecture/adr/0007-background-jobs-and-outbox.md)
- [ADR-0010 — Database Migrations and Schema](../architecture/adr/0010-database-migrations-and-schema.md)
- [ADR-0011 — Project-wide Layered DDD](../architecture/adr/0011-project-wide-layered-ddd.md)

The Frozen Manifest and its pinned evidence remain unchanged. This package records no decision by itself.
