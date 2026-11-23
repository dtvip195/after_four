# AFTER FOUR — P1 Owner Decision Review Package

**Status:** `PREPARED_FOR_OWNER_REVIEW — NO_DECISIONS_RECORDED`

**Authorizing portfolio decision:** `NW-OR-01` — documentation and logical-design preparation only

**Canonical ODB allocation:** `NOT_REQUESTED`

**Candidate E Gate A:** `DEFER_GATE_A — NOT_GRANTED`

**Candidate E Gate B proposal preparation:** `NOT_AUTHORIZED`

**Implementation authorization:** `NOT_GRANTED`

**Date:** 2026-11-23

## 1. Purpose and authority boundary

This package gives the Owner one decision surface for the fourteen temporary questions prepared by P1A, P1B, and P1C. It prioritizes the questions, preserves accountable domain ownership, identifies required consultation, and states what could follow from a future decision. It does not replace the evidence artifacts or decide any option.

The controlling sources are:

- the [Owner Decision Baseline](../architecture/after_four_owner_decision_baseline.md), especially Ordering and Payment §2, Catalog/Pricing §5, Package C0 decisions, Customer decisions, Identity and Authorization §7, and the Wave 1 portfolio decisions;
- [ADR-0011](../architecture/adr/0011-project-wide-layered-ddd.md), which controls inward dependency direction and context ownership;
- [ADR-0006](../architecture/adr/0006-authentication-session-topology.md), which remains `Proposed`;
- the [Next-Wave Execution Plan](after_four_next_wave_execution_plan.md), especially P1A §§4, P1B §5, and P1C §6;
- [P1A Order/Payment Policy Closure](after_four_p1a_order_payment_policy_closure.md), especially §§3–9;
- [P1B Catalog Current-State Reconciliation](after_four_p1b_catalog_current_state_reconciliation.md), especially §§3, 5, 6, 8, and 9;
- [P1C Identity Governance and Security Preparation](after_four_p1c_identity_governance_security_preparation.md), especially §§3–9; and
- the [P1 Parallel Integration and Owner Decision Register](after_four_p1_parallel_integration_decision_register.md), especially §§3–6.

Repository implementation is bounded evidence, not Owner authority. Every `P1A-OD-*`, `P1B-OD-*`, and `P1C-OD-*` reference remains temporary and `PROPOSED_NOT_APPROVED`.

## 2. Executive decision overview

### 2.1 Classification used in this package

| Classification | Meaning |
|---|---|
| `EXISTING_OWNER_POLICY` | Canonical Owner policy that constrains the choice and is not reopened here. |
| `ACCEPTED_BOUNDED_EVIDENCE` | Implemented or reviewed evidence accepted only within its recorded scope. |
| `PROPOSED_OWNER_DECISION` | A temporary question requiring an explicit Owner choice. |
| `TECHNICAL_PROPOSAL` | Reviewable design direction that grants no policy or implementation authority. |
| `UNRESOLVED` | Evidence or policy is insufficient for a responsible choice. |
| `DEFERRED` | Intentionally postponed under existing governance. |

### 2.2 Current decision and evidence baseline

| Layer | Current P1 baseline | Effect on this review |
|---|---|---|
| Existing approved policy | Owner Decision Baseline rules for payment-before-preparation, late success, mismatch/excess, cancellation authority, Catalog invariants, Customer anonymous Orders, and C0 security boundaries. | Constrains every option; none is reopened here. |
| Existing accepted bounded evidence/design baseline | Phase 1 supplies bounded Order/Payment evidence; Package B supplies the empty Catalog schema/integrity foundation; I1 Gate C accepts only Brand-to-Organization ancestry; `E-OR-01` accepts Candidate E's bounded semantic baseline only. | Establishes current maturity without granting broader runtime, Gate, or production authority. |
| Proposed Owner decisions | The fourteen `P1A-OD-*`, `P1B-OD-*`, and `P1C-OD-*` questions in §3. | Require explicit Owner selection; no recommendation is approval. |
| Technical proposals | P1A/P1C logical directions and `P1B-PROP-01` documentation synchronization. | May inform later reviewed work; grant no policy or implementation authority. |
| Unresolved questions | Downstream P1A outcomes, optional Customer association, future Catalog operation detail, `P1-OD-01`–`05`, and authentication-foundation evidence. | Must remain open or be explicitly deferred when prerequisites are missing. |
| Deferred matters | `C0-R05`, `C0-R08`, `C0-R11`, and the decisions recommended for later domain input below. | No replacement policy may be inferred. |

### 2.3 What blocks what

| Decision group | Current impact | Safe disposition now |
|---|---|---|
| `P1A-OD-02`, `03`, `06` | Blocks coherent mismatch, excess, Refund, and late-success resolution policy. | Review together; decide only bounded business outcomes and authority. |
| `P1A-OD-04`, `05`, `07` | Blocks cancellation, completed exception, and Order closure execution. | Keep deferred until Preparation/Delivery and downstream policy inputs are ready. |
| `P1A-OD-01` | Blocks activation of partial/split tender, but does not block exact-balance operation. | Safely defer; preserve the current exact-balance limitation. |
| `P1A-OD-08` | Blocks optional later Customer association, but does not block anonymous Orders. | Route to Customer policy and defer until its verification/privacy inputs exist. |
| `P1B-OD-01`–`04` | Blocks complete future Catalog create/edit/default-operation policy. | May be reviewed independently as business policy; no runtime work follows. |
| `P1B-OD-05` | Blocks evidence requirements for future non-lifecycle mutations. | Review after or with `P1B-OD-02`–`04`, because the operation set determines consequential evidence. |
| `P1C-OD-01` | Leaves authentication-foundation uncertainty unresolved. It does not block the existing I1 ancestry seam. | Defer execution until an exact spike manifest and security evidence protocol receive separate review. |

### 2.4 Outside this Owner review

This package does not decide partial allocation mechanics, database transactions, locks, schema, indexes, APIs, provider integration, Catalog runtime DML, authentication foundation, Session implementation, authorization implementation, audit storage, retention, legal conclusions, deployment, FOA, or Production Authorization. `P1-OD-01` through `P1-OD-05` remain unresolved. `C0-R05`, `C0-R08`, and `C0-R11` remain `DEFERRED`.

## 3. Consolidated decision register

Each card separates final accountability from consulted domains. A selected option would close only the stated business/governance question; it would not skip the readiness ladder in §6.

### 3.1 P1A — Order and Payment

#### P1A-OD-01 — Partial/split tender scope

| Field | Owner review content |
|---|---|
| Accountable owner | Payment |
| Exact question | Should the next bounded Payment scope support more than one successful tender toward one Order? |
| Evidence and constraints | `partially_paid` is reserved but unreachable. Phase 1 is exact-balance-only; that is an implementation limitation, not a permanent prohibition. Allocation, rounding, cancellation, Refund, reporting, and UX policy are absent. |
| Recommended option | `DEFER_PARTIAL_SPLIT_TENDER`; retain exact-balance activation until the complete policy is reviewed together. |
| Alternatives | Approve split tender under a later complete policy; or reject split tender for the bounded MVP scope. |
| Benefits and trade-offs | Deferral preserves a simple, evidenced settlement seam. Split tender improves customer flexibility but materially increases allocation, recovery, Refund, Cash, and reporting complexity. |
| Consequence of deferral | Exact-balance behavior continues and `partially_paid` remains unreachable. |
| Dependencies / consultation | Ordering, Cash, Reporting, Refund policy, and operator UX. Payment remains accountable. |
| Would authorize | The selected business-scope direction only. |
| Explicit exclusions | Allocation records, schema, API, transaction design, code, and runtime activation. |
| Suggested status | `OWNER_DECISION_REQUIRED — RECOMMEND_DEFER` |

#### P1A-OD-02 — Mismatch and excess operating disposition

| Field | Owner review content |
|---|---|
| Accountable owner | Payment |
| Exact question | Which bounded dispositions may close mismatch or excess evidence? |
| Evidence and constraints | Default rejection/no dispatch is confirmed. Excess is not revenue and requires appropriate Refund treatment. Exact roles, rails, allocation, and operating recovery are unresolved. |
| Recommended option | Hold the exception with explicit evidence and Owner or separately authorized approval; dispatch only after exact target allocation is authoritative; route excess through an approved Refund path. |
| Alternatives | Immediate full reversal/Refund where the method proves it; method-specific manual disposition; or continued external handling. |
| Benefits and trade-offs | A held exception is safest and preserves financial truth, but delays service. Immediate method-specific handling can reduce delay but needs provider/Cash evidence and recovery rules. |
| Consequence of deferral | Rejection/no dispatch continues and cases remain manually handled outside an implemented workflow. |
| Dependencies / consultation | Review with `P1A-OD-03` and `06`; consult Cash, provider operations, Reporting, and qualified accounting input where applicable. |
| Would authorize | The selected Payment exception outcome and authority policy only. |
| Explicit exclusions | Roles implementation, provider calls, Cash writes, Refund workflow, schema, and endpoints. |
| Suggested status | `OWNER_DECISION_REQUIRED — REVIEW_WITH_P1A-OD-03_AND_06` |

#### P1A-OD-03 — Refund policy baseline

| Field | Owner review content |
|---|---|
| Accountable owner | Payment |
| Exact question | What eligibility, authority, method, allocation, reconciliation, and correction rules govern Refunds? |
| Evidence and constraints | Refunds are required by overpayment/cancellation outcomes, but no executable policy exists. Original Payment history must not be rewritten, and cumulative successful Refunds cannot exceed refundable value. |
| Recommended option | Prepare and approve a method-aware, append-only policy with authoritative result reconciliation, cumulative cap, reason, actor, and approval evidence. |
| Alternatives | Original-tender-only; explicitly approved alternate method with stronger accounting evidence; or continued deferral. |
| Benefits and trade-offs | A baseline unlocks later exception/cancellation design and preserves reconciliation. Alternate methods improve recovery flexibility but add fraud and accounting risk. |
| Consequence of deferral | Cancellation, excess, and completed exceptions cannot execute as system workflows. |
| Dependencies / consultation | Cash, Ordering, Loyalty, Promotions, Reporting, provider evidence, and qualified accounting/legal input where applicable. |
| Would authorize | Refund business-policy closure only. |
| Explicit exclusions | Thresholds not selected by the decision, provider choice, schema, API, code, and execution. |
| Suggested status | `OWNER_DECISION_REQUIRED — PRIORITY_POLICY_BASELINE` |

#### P1A-OD-04 — Cancellation consequence matrix

| Field | Owner review content |
|---|---|
| Accountable owner | Ordering |
| Exact question | What financial, prepared-work, stock, benefit, and remedy outcomes apply before and after Preparation starts? |
| Evidence and constraints | Cancellation authority is confirmed, but outcomes are not. Cancellation never erases Payment, Preparation, Inventory, Loyalty/Promotion, or audit history. |
| Recommended option | Do not select a single outcome until Preparation/Inventory and Loyalty/Promotion inputs are available; then review stage-specific options. |
| Alternatives | Full Refund, partial/line allocation, remake/credit, or defined no-Refund treatment for prepared scope. |
| Benefits and trade-offs | Deferral avoids inventing downstream effects. Earlier closure could unblock design but risks inconsistent work, stock, benefit, and accounting outcomes. |
| Consequence of deferral | Cancellation execution remains blocked despite confirmed actor authority. |
| Dependencies / consultation | Payment/Refund, Preparation, Delivery, Inventory, Loyalty, Promotions, Cash, Reporting, and customer-remedy policy. These inputs do not transfer accountability from Ordering. |
| Would authorize | Stage-specific Order cancellation consequence policy only. |
| Explicit exclusions | Stock posting, benefit reversal, compensation mechanism, transaction boundary, and implementation. |
| Suggested status | `OWNER_DECISION_REQUIRED — DEFER_PENDING_DOWNSTREAM_INPUTS` |

#### P1A-OD-05 — Completed-Order exception policy

| Field | Owner review content |
|---|---|
| Accountable owner | Ordering |
| Exact question | Which actors and outcomes are permitted after an Order is completed? |
| Evidence and constraints | Completed Orders use a separate exception process; ordinary cancellation must not reopen or rewrite completed history. Exact authority and outcomes remain unresolved. |
| Recommended option | Keep a separate Owner-reviewed exception package with immutable reason/evidence and explicit financial, work, stock, and benefit treatment. |
| Alternatives | Narrow Refund-only correction; broader remake/credit/compensation remedies; or continued manual external handling. |
| Benefits and trade-offs | Separation protects terminal history. Broader remedies support service recovery but increase fraud, reconciliation, and cross-domain complexity. |
| Consequence of deferral | Completed exceptions remain external/manual and unimplemented. |
| Dependencies / consultation | Review after `P1A-OD-04`; consult Payment, Preparation, Inventory, Loyalty, Promotions, Customer remedy, and Reporting. |
| Would authorize | Completed-Order exception policy only. |
| Explicit exclusions | Reopening an Order, exception endpoint, Refund implementation, stock/benefit mutation, and runtime authority. |
| Suggested status | `OWNER_DECISION_REQUIRED — DEFER_AFTER_P1A-OD-04` |

#### P1A-OD-06 — Late-success review disposition

| Field | Owner review content |
|---|---|
| Accountable owner | Payment |
| Exact question | Who may resolve a late-success review and which non-dispatch outcomes may close it? |
| Evidence and constraints | Successful funding is retained. A Held/Expired Order is not reactivated or automatically dispatched. Review authority and closing dispositions are unresolved. |
| Recommended option | Owner or explicitly delegated exception authority selects only from separately approved Refund, replacement/new-Order, or documented no-dispatch dispositions. |
| Alternatives | Owner-only handling; bounded delegated authority; or continued open manual review. |
| Benefits and trade-offs | Owner-only is simpler and safer but slower. Delegation improves operations but needs capability and audit design. |
| Consequence of deferral | Financial truth remains recorded; review stays open; no dispatch follows. |
| Dependencies / consultation | Review with `P1A-OD-02` and `03`; consult Ordering, Cash, Customer remedy, Reporting, and Identity/P1 for later authority enforcement. |
| Would authorize | Allowed Payment review dispositions and business authority only. |
| Explicit exclusions | Delegation implementation, Refund/replacement workflow, automatic dispatch, and Order reactivation. |
| Suggested status | `OWNER_DECISION_REQUIRED — REVIEW_WITH_P1A-OD-02_AND_03` |

#### P1A-OD-07 — Order closure guards

| Field | Owner review content |
|---|---|
| Accountable owner | Ordering |
| Exact question | Which fulfillment, settlement, review, Refund, and delivery facts are necessary to close an Order? |
| Evidence and constraints | Payment success alone cannot close an Order. Phase 1 reserves `closed` but does not expose a closure workflow. |
| Recommended option | Defer the final guard matrix until Preparation and Delivery scope is bounded. |
| Alternatives | Close at Preparation completion, customer handoff/delivery completion, or a channel-specific condition. |
| Benefits and trade-offs | Deferral prevents false completion. Earlier selection may aid reporting but risks ignoring open delivery, review, or Refund obligations. |
| Consequence of deferral | `closed` remains reserved and unreachable. |
| Dependencies / consultation | Preparation, Delivery, Payment/Refund, Customer handoff, and Reporting. Ordering remains accountable. |
| Would authorize | Order closure business semantics only. |
| Explicit exclusions | Closure command, delivery model, reporting implementation, schema, and runtime activation. |
| Suggested status | `OWNER_DECISION_REQUIRED — DEFER_PENDING_PREPARATION_DELIVERY` |

#### P1A-OD-08 — Optional later Customer association

| Field | Owner review content |
|---|---|
| Accountable owner | Customer |
| Exact question | May an anonymous Order later be associated with a Customer Profile, by whom, with what verification/consent, time boundary, and historical effects? |
| Evidence and constraints | Anonymous Orders are confirmed. Phone/payment equality cannot infer Customer identity or rewrite Order provenance. Later association remains unresolved. |
| Recommended option | Route to a Customer-owned policy package; keep association absent until explicit policy protects verification, consent, privacy, and history visibility. |
| Alternatives | No later association; or narrowly verified association without retroactive benefit issuance. |
| Benefits and trade-offs | No association minimizes privacy/fraud risk. Narrow association may help service recovery but adds verification, consent, authorization, and benefit-history complexity. |
| Consequence of deferral | Anonymous Orders remain valid and unassociated. |
| Dependencies / consultation | Ordering supplies Order provenance; consult Loyalty, Promotions, Identity/P1, legal/privacy, and Customer Review Case policy. These inputs do not transfer accountability from Customer. |
| Would authorize | Customer later-association business policy only. |
| Explicit exclusions | Candidate E expansion, Customer implementation, public endpoint, identity inference, automatic merge, and retroactive benefits. |
| Suggested status | `OWNER_DECISION_REQUIRED — DEFER_TO_CUSTOMER_POLICY` |

### 3.2 P1B — Catalog

#### P1B-OD-01 — Initial Product lifecycle state

| Field | Owner review content |
|---|---|
| Accountable owner | Catalog |
| Exact question | Must every successfully created Product begin in Draft? |
| Evidence and constraints | Category and Variant start Draft. Product supports four states, but its universal initial state is unresolved and Package B deliberately has no Product default/insert guard. |
| Recommended option | Require Draft at creation, aligning staged Product construction with Category/Variant while preserving separate activation. |
| Alternatives | Require an explicitly supplied allowed state; or continue deferral and keep Product creation out of scope. |
| Benefits and trade-offs | Draft staging is simple and safe. Caller-selected state adds flexibility but increases authority and invariant complexity. |
| Consequence of deferral | No Product-create use case or public contract can be treated as complete. |
| Dependencies / consultation | Catalog operation design; Identity/P1 only for later enforcement. No other domain owns the lifecycle policy. |
| Would authorize | Initial Product lifecycle meaning only. |
| Explicit exclusions | Column default, trigger, command, API, migration, and implementation. |
| Suggested status | `OWNER_DECISION_REQUIRED — READY_FOR_REVIEW` |

#### P1B-OD-02 — Catalog master-data creation authority

| Field | Owner review content |
|---|---|
| Accountable owner | Catalog |
| Exact question | Who may create Category, Product, and Variant records within an authoritative Brand scope? |
| Evidence and constraints | Table existence and lifecycle roles do not grant creation authority. Generic role titles and Branch assignment are not authority. |
| Recommended option | Organization/Brand Owner or personnel explicitly granted the exact entity-specific, Brand-scoped creation capability. |
| Alternatives | Owner-only creation; one broad Catalog-editor capability; or continued deferral. |
| Benefits and trade-offs | Exact capabilities preserve least privilege. Owner-only is safer but can bottleneck operations; a broad editor is simpler but overgrants. |
| Consequence of deferral | No create Application use case, delegation, or Presentation operation is authorized. |
| Dependencies / consultation | Identity/P1 and Organization supply later trusted authority/scope contracts; Catalog owns the operation policy. |
| Would authorize | Selected Catalog creation-authority policy only. |
| Explicit exclusions | P1 implementation, delegation persistence, Catalog persistence changes, audit mechanism, endpoint, and runtime operation. |
| Suggested status | `OWNER_DECISION_REQUIRED — READY_FOR_REVIEW` |

#### P1B-OD-03 — Non-lifecycle editing authority and field boundary

| Field | Owner review content |
|---|---|
| Accountable owner | Catalog |
| Exact question | Who may edit names, descriptions, positions, visibility, and Codes, and which fields become immutable after activation or use? |
| Evidence and constraints | Generic CRUD is unsupported. Code correction differs from ordinary label/position edits; Product reassignment and Product lifecycle commands are excluded. |
| Recommended option | Decide capability and editable fields per operation/entity, with Code correction separated from routine edits. |
| Alternatives | One general edit capability; Owner-only editing; stronger Code immutability plus a separate correction process. |
| Benefits and trade-offs | Operation-specific policy preserves least privilege and history. General edit is simpler but broad; Owner-only impedes daily administration. |
| Consequence of deferral | Package B remains a persistence backstop without an authorized edit contract. |
| Dependencies / consultation | Identity/P1 and P2 audit are later enforcement/evidence dependencies; Ordering consumes sold snapshots but does not own Catalog edits. |
| Would authorize | Selected Catalog field and authority semantics only. |
| Explicit exclusions | Reassignment, Product lifecycle commands, Pricing, Availability, code, API, and runtime DML. |
| Suggested status | `OWNER_DECISION_REQUIRED — READY_FOR_REVIEW` |

#### P1B-OD-04 — Default Variant designation authority

| Field | Owner review content |
|---|---|
| Accountable owner | Catalog |
| Exact question | Who may designate or replace a Product's Default Variant, and in which Product lifecycle states? |
| Evidence and constraints | Default designation, Variant lifecycle, and customer visibility are independent. `C0-CAT-08` keeps switching outside Package C. Final aggregate validity remains mandatory. |
| Recommended option | Define a distinct Brand-scoped, capability-specific operation that preserves final Product validity. |
| Alternatives | Owner-only operation; delegation with a separate capability; or continued exclusion. Do not conflate switching with lifecycle authority. |
| Benefits and trade-offs | A distinct capability avoids unintended switches. Owner-only is strongest but restrictive; continued exclusion blocks complete maintenance. |
| Consequence of deferral | Package C cannot switch Default and must continue rejecting invalid outcomes. |
| Dependencies / consultation | Identity/P1 for later authority, P2 for evidence, and Product invariant design. Catalog remains accountable. |
| Would authorize | Default-designation business policy only. |
| Explicit exclusions | Index, lock, transaction, Package C expansion, code, API, and implementation. |
| Suggested status | `OWNER_DECISION_REQUIRED — READY_FOR_REVIEW` |

#### P1B-OD-05 — Audit policy for non-lifecycle mutations

| Field | Owner review content |
|---|---|
| Accountable owner | Catalog |
| Exact question | Which create, edit, and Default-designation operations require durable audit, reason, approval, or step-up evidence? |
| Evidence and constraints | Confirmed C0 reason/MFA/audit policies cover lifecycle operations only. Audit retention/read/export governance remains deferred under `C0-R08`. |
| Recommended option | Require append-only Brand-scoped evidence for creation, Code correction, Default changes, and other consequential edits; decide routine edit evidence separately. |
| Alternatives | Audit every edit; audit only a precise consequential-operation set; or continue deferral. |
| Benefits and trade-offs | Consequential-only evidence reduces noise but needs exact classification. Audit-all maximizes traceability but increases privacy, volume, and operating cost. |
| Consequence of deferral | Non-lifecycle mutation operations remain unauthorized even if their actor policy is later selected. |
| Dependencies / consultation | Review after or with `P1B-OD-02`–`04`; consult P2/P3, Identity/P1, privacy/legal, and operations. Catalog owns which operations require evidence. |
| Would authorize | Chosen Catalog evidence policy only. |
| Explicit exclusions | AuditEvent schema, shared audit store, retention/read/export rules, step-up mechanics, implementation, and compliance conclusion. |
| Suggested status | `OWNER_DECISION_REQUIRED — REVIEW_AFTER_OPERATION_SET` |

### 3.3 P1C — Identity governance and security

#### P1C-OD-01 — Future Devise-versus-custom compatibility/design spike

| Field | Owner review content |
|---|---|
| Accountable owner | Identity |
| Exact question | Should the Owner later authorize a bounded Devise-versus-custom compatibility/design spike after reviewing its exact manifest and evidence protocol? |
| Evidence and constraints | Devise 5 is a candidate only. No dependency or authentication foundation is selected. Argon2id, API-only behavior, opaque server-side Session fit, revocation, and override/maintenance surface require executable evidence. ADR-0006 remains `Proposed`; Milestone 2B is unauthorized. |
| Recommended option | Support preparation of a separately reviewable spike authorization only after the §3.3 prerequisites below are satisfied; select neither Devise nor custom now. |
| Alternatives | Defer pending ADR/security inputs; or stop Devise evaluation and later prepare a custom-only proposal. |
| Benefits and trade-offs | A bounded spike reduces provider-selection uncertainty with evidence. It consumes engineering/security review effort and can create accidental momentum toward adoption unless the no-adoption boundary is enforced. Deferral avoids that cost but leaves foundation uncertainty open. |
| Consequence of deferral | No authentication foundation is selected; P1 runtime remains absent; I1 ancestry remains independently usable only within its accepted bounded seam. |
| Dependencies / consultation | Exact isolated manifest, Ruby/Rails/PostgreSQL assumptions, candidate versions, Argon2id and Session criteria, threat/control acceptance criteria, cleanup/stop conditions, Identity security review, and ADR-0006 review. |
| Would authorize | At most a later exact evidence-gathering spike if separately and explicitly authorized after manifest review. |
| Explicit exclusions | Dependency adoption, Gemfile change, authentication/authorization implementation, provider selection, runtime wiring, ADR acceptance, Milestone 2B, and production use. |
| Suggested status | `OWNER_DECISION_REQUIRED — DEFER_PENDING_EXACT_SPIKE_AUTHORIZATION_PACKAGE` |

Existing `P1-OD-01` through `P1-OD-05` remain unresolved and are not answered by `P1C-OD-01`. `C0-R05`, `C0-R08`, and `C0-R11` remain `DEFERRED`.

## 4. Decision dependencies and recommended order

### 4.1 Dependency matrix

| Decision(s) | May be reviewed independently? | Review together / prerequisite | Recommended timing |
|---|---|---|---|
| `P1A-OD-01` | Yes | Full split-tender policy is prerequisite to enabling it, not to choosing deferral. | Review now only to confirm defer/reject/prepare-later direction. |
| `P1A-OD-02`, `03`, `06` | Individually meaningful, but outcomes interact. | Review together so mismatch/excess, Refund, and late-success dispositions do not conflict. | Highest P1A policy-closure priority. |
| `P1A-OD-04` | No responsible final outcome yet. | Preparation/Inventory and Loyalty/Promotion inputs; Payment/Refund baseline. | Defer to a later cross-domain policy review. |
| `P1A-OD-05` | Separate policy, but depends on the cancellation/remedy vocabulary. | Review after `P1A-OD-04` inputs and completed-service scenarios exist. | Defer. |
| `P1A-OD-07` | Closure remains Ordering-owned. | Preparation/Delivery completion and open review/Refund obligations. | Defer until those domains are bounded. |
| `P1A-OD-08` | Customer may review it independently of other P1A questions. | Customer verification/privacy/authority and Loyalty/Promotion historical-effect inputs. | Route to Customer; do not bundle with Payment. |
| `P1B-OD-01` | Yes | No prerequisite business decision. | Review independently. |
| `P1B-OD-02`, `03`, `04` | Yes, and may be reviewed in parallel. | Share Identity/P1 and audit implementation prerequisites only. | Review as one Catalog operations session without bundling approval. |
| `P1B-OD-05` | Partly | Needs the consequential operation set from `P1B-OD-02`–`04`. | Review immediately after those three. |
| `P1C-OD-01` | Yes as a governance direction. | Exact spike manifest/evidence protocol is required before any execution authorization. | Defer execution; optionally direct preparation of the later package. |

### 4.2 Efficient Owner review sequence

1. Confirm that deferred matters remain deferred: `P1A-OD-01`, `04`, `05`, `07`, `08`, and `P1C-OD-01` execution.
2. Review the coherent Payment exception cluster: `P1A-OD-03`, then `P1A-OD-02` and `P1A-OD-06` against that baseline.
3. Review independent Catalog semantics: `P1B-OD-01` through `04`, without granting implementation.
4. Review `P1B-OD-05` against the operation set selected or retained as proposed in step 3.
5. Route `P1A-OD-08` to Customer and the remaining P1A deferred matters to their named domain-input packages.
6. If authentication evidence is still desired, request an exact `P1C-OD-01` spike authorization package; do not execute a spike from this review.

This sequence is efficient, not mandatory. Independent decisions may proceed in parallel, and rejection/correction of one workstream does not block unrelated decisions.

## 5. Cross-domain impact and consultation map

| Domain | Accountable P1 questions | Consulted / affected by | Boundary preserved |
|---|---|---|---|
| Ordering | `P1A-OD-04`, `05`, `07` | Payment exceptions, Customer association, Preparation/Delivery, Inventory, benefits, Reporting | Owns Order intent/lifecycle and confirmed history; does not own Payment, Customer, stock, or benefits. |
| Payment | `P1A-OD-01`, `02`, `03`, `06` | Ordering eligibility, Cash/provider evidence, Customer remedies, Reporting | Owns settlement, Attempts, reconciliation, Refund and financial exception truth; does not own Order closure. |
| Preparation | None in this package | `P1A-OD-04`, `05`, `07`; Catalog configuration | Supplies authoritative work-stage facts; does not decide cancellation policy or Payment truth. |
| Delivery | None in this package | `P1A-OD-05`, `07` | Supplies fulfillment/handoff facts; no delivery model is selected here. |
| Inventory | None in this package | `P1A-OD-04`, `05`; future Catalog/Recipe integration | Owns stock movement and costing; no automatic stock effect is inferred. |
| Cash | None in this package | `P1A-OD-01`–`04`, `06` | Owns drawer/session accountability; Cash Transaction is not Payment Attempt. |
| Loyalty | None in this package | `P1A-OD-01`, `03`–`05`, `08`; Catalog commercial facts | Owns benefit ledger/policy; P1 does not invent reversal or retroactive earning. |
| Promotions | None in this package | `P1A-OD-01`, `03`–`05`, `08`; Catalog commercial facts | Owns entitlement/discount policy; P1 does not invent transfer, stacking, or reversal. |
| Customer | `P1A-OD-08` | Payment/Ordering remedies and later Identity enforcement | Owns Profile association, verification/privacy policy, and history visibility; anonymous Orders remain valid. |
| Catalog | `P1B-OD-01`–`05` | Ordering snapshots, Identity scope, P2 audit, Organization ancestry | Owns Category/Product/Variant operations; does not own sold history, Identity, or Organization facts. |
| Identity | `P1C-OD-01` | Every later protected operation | Owns authentication/authorization evidence and foundation evaluation; does not own target-domain business policy. |
| Organization | None in this package | Catalog/Identity authoritative Brand ancestry and future ownership facts | I1 supplies ancestry only; ownership and permission are not inferred. |

No row creates a shared aggregate, shared persistence model, shared transaction, direct cross-context record access, or public API.

## 6. Technical readiness after an Owner decision

An Owner choice advances only one step unless a later authorization explicitly advances another:

| Stage | Meaning | Does this package grant it? |
|---|---|---|
| 1. Business policy closure | Record the selected outcome, scope, accountable owner, alternatives rejected/deferred, and unresolved limits. | `NO`; this package only prepares choices. |
| 2. Logical technical design | Define framework-independent Application/Domain contracts, outcomes, invariants, trust boundaries, and failure behavior. | `NO`; may be proposed later after policy closure. |
| 3. Physical database design | Select tables, columns, constraints, indexes, locks, transactions, migration and rollback strategy. | `NO`; separately reviewed and authorized. |
| 4. Bounded implementation proposal | Name exact files, manifest, environment, tests, evidence, exclusions, and stop conditions. | `NO`. |
| 5. Implementation authorization | Explicit Owner Gate/authorization for the exact bounded manifest. | `NO`. |
| 6. Verification and acceptance | Execute authorized evidence, independently review where required, record Control Acceptance/FOA separately. | `NO`. |

Approval of a business policy does not authorize the next stage automatically. Deferral leaves current safe behavior and existing authorization boundaries unchanged.

## 7. Owner decision worksheet

Complete one outcome per row. Blank cells are intentional; no decision is pre-populated.

| Temporary ref | Accountable owner | Approve recommended option | Approve alternative (identify) | Defer | Reject / revise | Conditions or comments |
|---|---|---|---|---|---|---|
| `P1A-OD-01` | Payment | ☐ | ☐ | ☐ | ☐ | |
| `P1A-OD-02` | Payment | ☐ | ☐ | ☐ | ☐ | |
| `P1A-OD-03` | Payment | ☐ | ☐ | ☐ | ☐ | |
| `P1A-OD-04` | Ordering | ☐ | ☐ | ☐ | ☐ | |
| `P1A-OD-05` | Ordering | ☐ | ☐ | ☐ | ☐ | |
| `P1A-OD-06` | Payment | ☐ | ☐ | ☐ | ☐ | |
| `P1A-OD-07` | Ordering | ☐ | ☐ | ☐ | ☐ | |
| `P1A-OD-08` | Customer | ☐ | ☐ | ☐ | ☐ | |
| `P1B-OD-01` | Catalog | ☐ | ☐ | ☐ | ☐ | |
| `P1B-OD-02` | Catalog | ☐ | ☐ | ☐ | ☐ | |
| `P1B-OD-03` | Catalog | ☐ | ☐ | ☐ | ☐ | |
| `P1B-OD-04` | Catalog | ☐ | ☐ | ☐ | ☐ | |
| `P1B-OD-05` | Catalog | ☐ | ☐ | ☐ | ☐ | |
| `P1C-OD-01` | Identity | ☐ | ☐ | ☐ | ☐ | |

Any selected outcome must be recorded later through the applicable canonical governance procedure. A checked worksheet alone is not a canonical `ODB-*` allocation, implementation authorization, or production approval.

## 8. Governance and stop conditions

- All fourteen temporary references remain `PROPOSED_NOT_APPROVED` until the Owner explicitly decides them.
- No canonical `ODB-*` identifier is allocated, reserved, or implied.
- Existing Owner-approved policy remains authoritative and is not reopened by a recommendation.
- `P1B-PROP-01` remains a separate `TECHNICAL_PROPOSAL — DOCUMENTATION_ONLY`, not an Owner decision in this worksheet.
- Existing `P1-OD-01` through `P1-OD-05` remain `OWNER_DECISION_REQUIRED`.
- `C0-R05`, `C0-R08`, and `C0-R11` remain `DEFERRED`.
- ADR-0006 remains `Proposed`; ADR-0011 remains controlling.
- Identity Milestone 2B remains unauthorized.
- Candidate E remains `DEFER_GATE_A — NOT_GRANTED`; Candidate E Gate B proposal preparation remains `NOT_AUTHORIZED`.
- Physical database design, schema, migrations, database operations, application/tests, dependency adoption, runtime changes, deployment, FOA, and Production Authorization remain unauthorized.

If a proposed choice lacks the named prerequisite or qualified input, record `Defer` or `Reject / revise`; do not manufacture an answer.

## 9. Review completion criteria

This review package has served its purpose when the Owner has:

1. reviewed each of the fourteen questions independently;
2. recorded an explicit choice, deferral, rejection, or revision request for each question considered;
3. preserved accountable ownership and identified required consulted domains;
4. avoided bundling unrelated decisions or inferring implementation authority; and
5. directed any approved policy to a separate canonical-recording task before later design or implementation preparation.

Completion of Owner review does not itself change any decision status in the repository. A separate documentation task must record explicit Owner decisions with their exact scope and exclusions.
