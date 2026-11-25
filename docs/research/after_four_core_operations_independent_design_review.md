# AFTER FOUR — Independent Core Operations Design Review

**Review date:** 2026-11-24 (Asia/Tokyo)

**Repository baseline:** `main` / `origin/main` at `8761a1b1eb6b68514cfc8b9f42d4dfcc5325eb5d`

**Reviewed workstreams:** CORE-01 Core Sale, CORE-02 Preparation and Order Completion, CORE-04 Cash Session and Operating Day

**Review authority:** Documentation-only independent design-readiness review

**Gate or implementation authority created:** `NONE`

## 1. Executive conclusion

None of the three workstreams is ready for Owner Gate A review today.

| Workstream | Recommendation | Principal reason |
|---|---|---|
| CORE-01 | `NOT READY FOR OWNER GATE A REVIEW` | Exact Product/Variant Price transcription and qualified tax/rounding inputs are absent, and the logical lifecycle of the Payment target across Draft edits and confirmation is not closed. |
| CORE-02 | `NOT READY FOR OWNER GATE A REVIEW` | Owner policy is substantially closed, but the design still contains stale statements that reopen confirmed decisions and lacks a complete transition/exception model reconciled with the still-deferred broader Order-closure policy. |
| CORE-04 | `NOT READY FOR OWNER GATE A REVIEW` | Exact cutoff, capability assignments, post-close correction policy and disposition/release authority remain deferred; the design also contains stale policy summaries and an incomplete lifecycle/reconciliation model. |

CORE-01 remains suitable for continued independent design correction. Its eventual Gate A request can be narrow: published/effective Catalog reads, server-authoritative Draft and confirmation, immutable sold snapshots, exact-balance cash, and the existing pending Preparation Dispatch boundary. It must continue to exclude Service Charge, price-changing Modifiers, complimentary/zero-price items, direct sold-price override, manual bank, Refund execution, Inventory, Promotions and Loyalty.

The review verified useful foundations but did not execute them. Phase 1 source implements aggregate-total Draft/Confirm, exact-balance local Payment confirmation and atomic pending Dispatch creation; Catalog Package B supplies Category/Product/Variant integrity only. Neither repository presence nor this review supplies new authority.

## 2. Sources inspected

### 2.1 Governance and architecture

- [`AGENTS.md`](../../AGENTS.md), especially Scope, Project-wide Layered DDD and Verification.
- [`GLOSSARY.md`](../../GLOSSARY.md), especially Order, Order Item, Payment, Payment Attempt, Preparation Dispatch/Ticket, Cash Session and Operating Day.
- [ADR-0011 — Project-wide Layered DDD](../architecture/adr/0011-project-wide-layered-ddd.md), especially Decision and Forward-compliance rule.
- [Owner Decision Baseline](../architecture/after_four_owner_decision_baseline.md), especially Consolidated P1, Wave 2 Cash, Catalog/Pricing and Accelerated Core Operations decisions.
- [Business Domain Model](../architecture/after_four_business_domain_model.md), especially §§7–8, 10 and 16.
- [State Machines](../architecture/after_four_state_machines.md), especially §§3–10 and 13.
- [Data Integrity Rules](../architecture/after_four_data_integrity_rules.md), especially §§5–8, 10–12 and 15–17.
- [Data Dictionary](../architecture/after_four_data_dictionary.md), Order/Payment/Preparation, Catalog/Pricing and Cash entries.
- [ERD](../architecture/after_four_erd.md), especially §§6, 8, 10 and 12–15.

### 2.2 Reviewed package and implementation evidence

- [Accelerated Core Operations Design Package](after_four_accelerated_core_operations_design_package.md), complete document.
- [Accelerated Core Operations Readiness Assessment](after_four_accelerated_core_operations_readiness_assessment.md), complete document.
- [Catalog Core Technical Design](../architecture/after_four_catalog_core_technical_design.md), especially §§1–5 and explicit Package B exclusions.
- [P1B Catalog Current-State Reconciliation](after_four_p1b_catalog_current_state_reconciliation.md), especially current-state and exit assessments.
- [Order/Payment Phase 1 implementation record](../architecture/after_four_order_payment_implementation_phase1.md), especially §§2–7.
- `backend/app/domains/orders/application/use_cases/create_draft.rb`, `backend/app/domains/orders/application/use_cases/confirm.rb` and `backend/app/domains/payments/confirm.rb`.
- [P2B Cash Domain Discovery](after_four_p2b_cash_domain_discovery.md), especially §§2–5.
- [P1 Trusted Identity/Authorization Design](../architecture/after_four_p1_trusted_identity_authorization_design.md), especially §§5–8, 11–12 and 14–17.
- [Identity and Authorization](../architecture/after_four_identity_authorization.md), especially §§1, 3–5 and 7.

No Rails command, test, build, migration, database command, service or external system was run. Checked-in specs and implementation records are source evidence, not newly executed verification.

## 3. Method and classification

The review traced each proposed invariant through four independent questions:

1. Is the business policy Owner-confirmed, deferred or outside scope?
2. Is the logical design complete enough to review without selecting physical persistence?
3. Does current implementation support the claim, merely provide reusable evidence, or conflict with the proposal?
4. Which separate authorization is required before design acceptance or implementation?

Finding severities:

| Severity | Meaning |
|---|---|
| `BLOCKER` | A missing policy, evidence set or primary logical contract that prevents submission for Owner Gate A review. |
| `MAJOR` | A material design inconsistency or missing supporting logical contract. Severity alone does not determine readiness: each `MAJOR` finding below states separately whether it blocks Gate A review, Gate A approval or Gate B. |
| `MINOR` | A clarification that may remain open only when it is explicitly recorded as a reviewed exclusion or later-gate condition. |
| `DEPENDENCY` | External policy, evidence or separately governed capability that this design cannot silently solve. A dependency may block review, approval or implementation according to its stated effect. |

Readiness terms are independent of severity:

- **Blocks Gate A review:** the finding must be resolved before submitting a coherent design baseline for Owner review.
- **Required before Gate A approval:** the Owner must not approve the baseline while the finding remains unresolved, even if the package was accepted for review.
- **Required before Gate B:** the item may be an explicit Gate A exclusion or implementation prerequisite, but must close before bounded implementation authorization that depends on it.
- **Separate authorization/dependency:** closure belongs partly or wholly to another governed scope and is not granted by the affected Core workstream.

Every recommendation below remains a design recommendation. It is not approved policy or implementation authority.

## 4. CORE-01 — Core Sale detailed review

### 4.1 Scope and domain assessment

The proposed boundary correctly separates Catalog/Pricing, Ordering and Payment. Catalog/Pricing supplies trusted Product/Variant/sellability/Price facts; Ordering owns Draft Items, calculation and immutable sold snapshots; Payment consumes the confirmed exact target. Presentation is not allowed to author Price or total. These responsibilities align with ADR-0011 and the Business Domain Model.

The initial exclusions also match current Owner policy: exact-balance cash only; no Service Charge, price-changing Modifiers, complimentary/zero-price Items, direct sold-price override or manual bank; Refund remains separate. Inventory, Promotions and Loyalty do not gate the slice.

The logical shape is nevertheless incomplete in four Gate A-critical areas.

### 4.2 Findings

| Finding | Severity | Source evidence | Why it matters | Required resolution | Owner input? |
|---|---|---|---|---|---|
| `CORE01-B01` — Exact sellable Price dataset absent | `BLOCKER` | Design Package §§3.1–3.2 states that the 28-row menu is approved by reference but no Product/Variant-to-Price mapping exists. Catalog Package B §2.2 excludes Price and real menu data. | Approximate VND tiers cannot produce an authoritative quote, Payment target or immutable sold snapshot. | Produce a frozen, reviewable transcription of Product, Variant, exact Price, scope and effective time without reopening the approved 28 menu rows. | Evidence/data input required; no renewed menu decision. |
| `CORE01-B02` — Tax and rounding remain deferred | `BLOCKER` | `CORE-OD-03/04` are `OWNER_DEFERRED — OWNER_INPUT_REQUIRED`; Design Package §§3.2 and 3.6 explicitly leave the calculation incomplete. | A server-authoritative total and snapshot cannot be deterministic if inclusion/display, precision and rounding boundary are unknown. | Obtain qualified Tax/Accounting and commercial input, record the Owner decisions, then update the calculation sequence and examples. | **Yes.** |
| `CORE01-B03` — Payment target lifecycle is unspecified | `BLOCKER` | Design Package §§3.4–3.5 says Draft Items change and confirmation freezes totals, but does not state when the one Payment is created or how its target changes. Current `Orders::Application::UseCases::CreateDraft` creates Payment with caller-supplied total (`create_draft.rb:27-56`); `Orders::Application::UseCases::Confirm` does not update Payment (`confirm.rb:17-37`); `Payments::Confirm` compares against the stored target (`confirm.rb:126-135`). | Draft item edits/requotes can leave Payment target inconsistent with the authoritative confirmed Order. A Gate A baseline needs one owner and atomic semantic boundary for target establishment. | Specify whether Payment is created at Draft or confirmation; if retained at Draft, define allowed target replacement, version coupling, audit/idempotency and the atomic confirmation boundary. Preserve separate Order and Payment lifecycles. | No new business policy identified; technical design review required. |
| `CORE01-B04` — Effective menu/Price resolution is under-specified | `BLOCKER` | Design Package §3.4 lists a resolution result but not the complete selection algorithm. Data Integrity Rules §§5.0 and 5.2 require Active eligibility, half-open effective intervals, Branch override precedence and non-overlap. Catalog Package B has no Pricing Application use case. | Different adapters could choose different Price or sellability outcomes at the same instant. | Define the logical query inputs, authoritative decision time, Active Product/Variant/Category and Branch-availability guards, Branch-override precedence, no-result/ambiguity outcomes and safe cross-Branch failure contract. Leave indexes/locks to Gate B. | No. |
| `CORE01-M01` — Cross-context transaction/port ownership needs one explicit sequence | `MAJOR — BLOCKS_GATE_A_REVIEW` | Design Package §§3.3, 3.5 and 3.7 names correct owners, while ADR-0011 requires Application-owned contracts and prohibits cross-context Infrastructure manipulation. Current Phase 1 Payment directly creates the pending Preparation record (`payments/confirm.rb:177-199`) as legacy evidence. | “Atomic” can otherwise be read as permission for Ordering or Payment to manipulate another context's persistence. The logical ownership and semantic transaction boundary are necessary for a coherent Gate A design; physical transaction, isolation, lock and storage choices are not. | Add a sequence naming the consumer port owner, Application orchestration owner, semantic transaction boundary, trusted DTOs and which existing Phase 1 behavior is legacy versus intended forward-compliant design. Do not choose a new broker or physical transaction mechanism. | No. |
| `CORE01-M02` — Command-level actor/audit evidence is incomplete | `MAJOR — BLOCKS_GATE_A_REVIEW` | Design Package §6 proposes trusted context, but CORE-01 contracts do not enumerate actor/session/Branch/capability/correlation evidence per Draft mutation, quote acceptance, confirmation and cash confirmation. Identity Milestone 2B is unauthorized. | Gate A can and must define the trusted logical command contract without implementing Identity; omission risks client authority or unattributed commercial changes. Actual Identity implementation, assignee mapping and capability grants remain separate. | Define required trusted inputs and audit outcomes for each Application command, explicitly as a port dependency on separately authorized CORE-03/P1. | Logical contract: no. Identity implementation and capability assignment: separate authorization required before Gate B implementation that consumes them. |

### 4.3 Persistence and integrity assessment

The design appropriately stops at logical ownership and rejects selection of tables, indexes, physical foreign keys, locks and isolation. A later physical design must prove, rather than assume:

- one stable Draft line identity and one Price-version binding per accepted line;
- immutable complete confirmed snapshot sets;
- exact consistency among confirmed Order total, Payment target and currency;
- idempotent Draft mutation, re-quote acceptance, confirmation and cash confirmation;
- no mixed Price versions under publication/confirmation races; and
- no cross-Branch Product, Variant, Price, Order or Payment association.

These are acceptance obligations, not authorization to create database objects.

### 4.4 CORE-01 Gate A recommendation

**Recommendation: `NOT READY FOR OWNER GATE A REVIEW`.**

Minimum entry conditions:

1. exact Product/Variant/Price transcription is frozen and traceable;
2. `CORE-OD-03/04` are resolved with qualified input;
3. Payment target lifecycle and the Order-confirmation consistency boundary are explicit;
4. effective Catalog/Price resolution is deterministic at the logical level;
5. `CORE01-M01/M02` close the logical cross-context ownership, semantic transaction boundary and trusted command/evidence contracts, while physical transaction mechanisms and Identity implementation remain later-gate or separately authorized matters; and
6. independent corrections receive a clean re-review.

No listed blocker requires physical schema selection. CORE-01 should return for Owner Gate A review only after these conditions are met, with all current exclusions attached.

## 5. CORE-02 — Preparation and Order Completion review

### 5.1 Verified direction

Owner policy now fixes Item-level progress, whole-Ticket completion, whole-Ticket handover, stage-specific cancellation consequences, explicit completion and handover evidence, and bounded Order-closure guards. Dispatch business state, Outbox delivery state and Ticket execution state are correctly separated, and duplicate delivery is required to locate the same Ticket rather than create another one.

### 5.2 Findings

| Finding | Severity | Source evidence | Why it matters | Required resolution | Owner input? |
|---|---|---|---|---|---|
| `CORE02-B01` — Current design reopens confirmed policy | `BLOCKER` | Design Package §4.2 still says progress granularity and partial completion/handover “remain Owner decisions”; §4.4 still requests “proposed partial-item schedules”; §4.5 says the Owner must decide completion/handover semantics. The canonical register records `CORE-OD-08A`–`10C` as confirmed. | A Gate A baseline cannot simultaneously call a policy confirmed and unresolved. | Synchronize §§4.2, 4.4 and 4.5 to the 27/7 canonical record without changing the decisions. | No new input; documentation correction. |
| `CORE02-B02` — Ticket/Item transition model is incomplete | `BLOCKER` | Design Package §4.2 shows only `queued → in_progress → completed` plus a combined exception branch. State Machines §9 still contains historical `partially_ready`, quantity progress and cancellation states. | Commands, invalid transitions, cancellation races and completion evidence cannot be reviewed against one authoritative logical model. | Define separate Ticket and Item states, named transitions, guards, derived Ticket completion, whole-Ticket handover, invalid transitions and exception terminality. Explicitly supersede incompatible historical proposal vocabulary for this bounded slice. | No. |
| `CORE02-B03` — Bounded closure guard versus deferred `P1A-OD-07` is ambiguous | `BLOCKER` | `CORE-OD-10C` confirms settled Payment + completed Preparation + handover + no open exception for this review, while the Owner baseline keeps broader `P1A-OD-07` deferred. Design Package §4.3 says closure guards are not approved. | The package risks either reopening a new confirmed decision or silently treating it as universal closure policy. | State precisely that `CORE-OD-10C` is the bounded initial-slice minimum and enumerate which broader settlement/review/Refund/Delivery obligations remain deferred under `P1A-OD-07`; if that interpretation is not authoritative, obtain Owner governance clarification. | Governance clarification may be required. |
| `CORE02-M01` — Exception lifecycle and recovery contract is missing | `MAJOR — BLOCKS_GATE_A_REVIEW` | Design Package §4.5 routes in-progress/completed cancellation to exception handling but defines no exception identity, status, resolution result or relationship to Ticket/Order. | “Route to exception” is not sufficient to review preservation, retry, terminality or protection against accidental closure. | Define the logical exception identity/status, required actor/reason/time/stage/version evidence, idempotency, permitted resolution outcomes and their effect on Ticket and Order; keep Refund policy and authority separate. | Possibly, only if proposed resolution outcomes exceed confirmed policy. |
| `CORE02-M02` — Acceptance versus Dispatch completion evidence needs a named contract | `MAJOR — BLOCKS_GATE_A_REVIEW` | Design Package §§4.1–4.3 requires one Ticket and durable acceptance but leaves the acceptance result unnamed and does not define reconciliation ownership. | Duplicate/out-of-order delivery, response-loss replay and crash recovery cannot be reviewed consistently without an authoritative logical acceptance fact. | Define the logical acceptance result, replay behavior and reconciliation ownership, including duplicate/out-of-order delivery, response-loss replay and Ticket-without-acknowledgement recovery. Do not select physical storage, broker or transport. | No. |
| `CORE02-D01` — Trusted operator capability is external | `DEPENDENCY` | Design Package §§4.3 and 6; P1 design §§6–8. Identity Milestone 2B remains unauthorized. | Start/complete/cancel/handover cannot be operationally authorized. | Keep exact capability/context ports in the design; obtain separate Identity Gate A/B before implementation or operational acceptance. | Separate Owner authorization, not CORE-02 policy. |

### 5.3 Next design package

Prepare one bounded CORE-02 correction package containing:

1. synchronized policy traceability;
2. Ticket, Item, acceptance and exception logical state machines;
3. named Application use cases for accept/start/complete/handover/cancel/exception;
4. trusted actor/time/version/audit requirements;
5. duplicate, out-of-order, crash/retry and cancellation-race outcomes;
6. a bounded closure contract reconciled with `P1A-OD-07`; and
7. an acceptance matrix that proves Payment cannot be rewritten and Inventory cannot gate the slice.

Items 2–5 explicitly close `CORE02-M01/M02` at the logical level and are required before a fresh Gate A review. Physical broker, transport, storage, transaction and recovery implementation remain Gate B concerns. Gate A and Gate B remain separate Owner actions.

## 6. CORE-04 — Cash Session and Operating Day review

### 6.1 Verified direction

The first Hoi An Branch uses `Asia/Ho_Chi_Minh`; each Branch is independently configured; exceptional days need explicit effective evidence. Open, Count, Handover and Close are separate Branch-scoped capabilities. Acknowledgement is not approval and does not close the outgoing Session. Every nonzero discrepancy requires reason and Owner notification with no tolerance, and unreconciled data is held from authoritative reporting.

### 6.2 Findings

| Finding | Severity | Source evidence | Why it matters | Required resolution | Owner input? |
|---|---|---|---|---|---|
| `CORE04-B01` — Deferred cutoff blocks the Operating Day model | `BLOCKER` | `CORE-OD-11B` remains deferred. Design Package §5.1 and Reporting §7.2 depend on the boundary. | Session/day assignment, exceptional-day application and report cutoff cannot be evaluated without an exact cutoff. | Obtain the exact Branch cutoff and boundary semantics; do not assume midnight or closing time. | **Yes.** |
| `CORE04-B02` — Capability and correction policy remain deferred | `BLOCKER` | `CORE-OD-12/13` remain deferred; `ODB-CASH-13/14` define only operation separation and linked immutable corrections. | No executable Open/Count/Handover/Close or post-close correction use case can be reviewed without authority and permitted-operation boundaries. | Obtain capability assignment/delegation/separation policy and bounded correction operations, initiator/approver, evidence and consequences. Do not appoint people or infer generic roles. | **Yes.** |
| `CORE04-B03` — Design summary is stale against confirmed decisions | `BLOCKER` | Design Package §5.1 still calls exact timezone, configuration, exceptional days and Session transition unresolved; §5.2 says handover questions remain undecided. Canonical `CORE-OD-11A/C/D` and `14A/B` resolve those bounded directions. | A Gate A baseline cannot be traced reliably to canonical policy. | Correct the design summary only; preserve detailed disagreement resolution and capability assignment as open. | No new input. |
| `CORE04-B04` — Lifecycle does not separate Close, reconciliation and release | `BLOCKER` | Design Package §5.2 proposes `open → handover_pending/close_pending → closed` and a separate Operating Day state, but no transition matrix. State Machines §13 permits DiscrepancyReview→Closed after reason/notification, while `CORE-OD-15B` holds unreconciled facts from authoritative reporting. | “Closed”, “reconciled” and “reportable” may be conflated, allowing an unreconciled close to appear authoritative. | Define Cash Session Close as immutable evidence, Operating Day reconciliation as a separate state/result, unresolved-case disposition separately, and report release as a distinct authority-controlled outcome. Enumerate invalid transitions. | Disposition/release authority still needs Owner input. |
| `CORE04-M01` — Handover disagreement has no durable outcome model | `MAJOR — BLOCKS_GATE_A_REVIEW` | `CORE-OD-14A` sends disagreement/refusal to Owner; Design Package §5.3 preserves it but defines no held state/evidence/resolution contract. | A refused acknowledgement must not disappear, close the Session or transfer accountability silently; the logical held outcome and preservation duties are necessary to review the handover lifecycle. | Define the logical disagreement/hold state, actor/time/reason/evidence, custody/accountability preservation and Owner-escalation/resolution linkage without inventing who may resolve beyond confirmed policy. | Detailed resolution authority remains a separate Owner input. |
| `CORE04-M02` — Cash movement input contracts are not complete | `MAJOR — BLOCKS_GATE_A_REVIEW_FOR_INITIAL_SCOPE` | Design Package §5.2 lists sale, Refund, float/top-up, Expense and correction inputs, all with different source owners; only exact-cash sale exists as current Payment evidence. | The first slice needs a reproducible exact-cash sale source contract. Future movement sources must not become authorized merely because they appear in a source list. | Define source identity, Branch, currency, amount, idempotency and reversal/correction boundaries for the initial exact-cash sale movement. Mark Refund, Expense, float/top-up and post-close correction as excluded/future sources until separately governed; their detailed contracts may remain Gate A exclusions. | Initial cash-sale contract: no. Future source operations and authority: separate decisions/authorization. |
| `CORE04-D01` — Identity and Reporting are separate prerequisites | `DEPENDENCY` | `ODB-CASH-13`, `CORE-OD-12`, `CORE-OD-15B`, `CORE-OD-16B`; Identity Milestone 2B unauthorized. | Cash execution and report release cannot rely on generic Staff status or an unimplemented reader capability. | Preserve exact capability ports and held-report state; obtain separate Identity/Reporting decisions and Gates. | **Yes**, in separately governed scopes. |

### 6.3 Next design package

CORE-04 should not return for Gate A review until it has:

1. exact cutoff policy;
2. capability/separation and post-close correction policy;
3. a synchronized Operating Day/Cash Session lifecycle and invalid-transition matrix;
4. immutable count/handover/close/discrepancy evidence contracts;
5. disagreement and unresolved-reconciliation case models;
6. distinct Close, reconciliation, disposition and report-release outcomes; and
7. logical source-fact/idempotency contracts for the included exact-cash sale movement, with Refund, Expense, float/top-up and post-close correction explicitly excluded until separately governed.

Items 4–7 close the Gate A logical portions of `CORE04-M01/M02`. Physical persistence and concurrency remain Gate B matters; detailed disagreement resolution authority and future movement-source authority remain separate Owner dependencies.

## 7. Cross-workstream dependency matrix

| Upstream | Downstream consumer | Current state | Design effect | Blocks |
|---|---|---|---|---|
| Exact Catalog Product/Variant/Price transcription | CORE-01 Ordering | Missing; menu only approved by reference | No executable authoritative quote or snapshot dataset | CORE-01 Owner Gate A review |
| Tax and rounding policy | CORE-01 calculation, Payment target, Reporting | Owner-deferred | Calculation cannot be deterministic | CORE-01 Owner Gate A review |
| Ordering confirmed total and snapshots | Payment | Proposed; Payment target lifecycle incomplete | Payment must consume one immutable exact target without recalculating | CORE-01 Owner Gate A review |
| Fully settled eligible Payment | Preparation Dispatch | Implemented Phase 1 boundary | Creates one pending Dispatch/outbox; does not prove ticket or completion | CORE-02 implementation; reusable design evidence |
| Confirmed sold Items | Preparation Ticket Items | Proposed; no Order Items exist | Ticket must use historical sold facts, not current Catalog | CORE-02 implementation and acceptance evidence |
| Preparation completion + handover + no open exception | Ordering closure | Bounded Owner direction; broader `P1A-OD-07` deferred | Must not close from Payment or Preparation alone | CORE-02 Gate A until scope reconciled |
| Cancellation stage | Ordering, Preparation, Refund | Stage policy confirmed; Refund separate | Cancellation preserves facts and never authorizes Refund | CORE-02 exception design; Refund future scope |
| Exact-cash Payment fact | Cash movement | Payment fact implemented; Cash consumer absent | Cash owns drawer movement; duplicate source cannot duplicate movement | CORE-04 implementation |
| Branch timezone + cutoff | Cash Session, Operating Day, Reporting | Hoi An timezone confirmed; cutoff deferred | No authoritative day/report boundary yet | CORE-04 Gate A |
| Cash Session close/reconciliation | Reporting | Close semantics proposed; reconciliation/report release incomplete | Unreconciled facts must remain non-authoritative | CORE-04 Gate A and Reporting implementation |
| Trusted identity/session/exact capability | CORE-01/02/04 commands | Design exists; Milestone 2B unauthorized | Must fail closed and retain actor/scope evidence | All implementation and operational acceptance |
| Inventory | CORE-01/02 | Explicitly deferred | Cannot gate Order, Payment or Preparation | Neither design Gate A; future integration only |

## 8. Ranked blocking findings

| Rank | Finding | Workstream | Resolution class |
|---|---|---|---|
| 1 | `CORE01-B01` exact Product/Variant/Price transcription | CORE-01 | Evidence/data closure |
| 2 | `CORE01-B02` tax and rounding decisions | CORE-01 | Qualified input + Owner decision |
| 3 | `CORE01-B03` Payment target lifecycle | CORE-01 | Technical design closure |
| 4 | `CORE01-B04` deterministic effective menu/Price resolution | CORE-01 | Technical design closure |
| 5 | `CORE02-B01` stale policy statements | CORE-02 | Documentation consistency correction |
| 6 | `CORE02-B02/B03` transition model and closure-scope reconciliation | CORE-02 | Technical design + possible governance clarification |
| 7 | `CORE04-B01/B02` cutoff, capability and correction policy | CORE-04 | Owner input |
| 8 | `CORE04-B03/B04` stale summary and lifecycle/reconciliation separation | CORE-04 | Documentation + technical design closure |
| 9 | `CORE01-M01/M02` logical ownership and trusted-command contracts | CORE-01 | Gate A logical design closure; physical/Identity implementation later or separate |
| 10 | `CORE02-M01/M02` exception and Dispatch-acceptance contracts | CORE-02 | Gate A logical design closure; physical recovery mechanism later |
| 11 | `CORE04-M01/M02` disagreement and initial cash-source contracts | CORE-04 | Gate A logical design closure; detailed authority and future sources separate |

## 9. Finding readiness classification and deferred inputs

### 9.1 Classification matrix

| Finding ID | Severity | Blocks Gate A review? | Required before Gate A approval? | Required before Gate B? | Separate authorization/dependency? | Rationale |
|---|---|---:|---:|---:|---|---|
| `CORE01-M01` | `MAJOR` | Yes | Yes | Yes | No | Gate A needs context/port ownership, Application orchestration and the semantic transaction boundary; physical transaction, locks, isolation and storage wait for Gate B. |
| `CORE01-M02` | `MAJOR` | Yes | Yes | Yes | Identity implementation and capability assignment | Gate A needs the trusted command/evidence dependency, but does not implement Identity or grant capabilities. |
| `CORE02-M01` | `MAJOR` | Yes | Yes | Yes | Only for resolution policy beyond confirmed bounds | Ticket/Order transitions cannot be reviewed coherently without a logical exception lifecycle; Refund remains separate. |
| `CORE02-M02` | `MAJOR` | Yes | Yes | Yes | No | Gate A needs logical acceptance, replay and reconciliation outcomes; broker, transport and storage remain later choices. |
| `CORE04-M01` | `MAJOR` | Yes | Yes | Yes | Detailed resolution authority | Confirmed disagreement escalation requires a durable logical hold/evidence/accountability outcome before lifecycle review. |
| `CORE04-M02` | `MAJOR` | Yes, for the included exact-cash source | Yes, for the included exact-cash source | Yes | Future Refund, Expense, float/top-up and correction sources | The initial slice needs an exact-cash source contract. Future source contracts may remain explicit Gate A exclusions until separately governed. |

All six findings happen to block review in this package because §§4.4, 5.3 and 6.3 require their logical contracts for a coherent baseline. That result follows from each finding's evidence; it is not a rule that every `MAJOR` finding always blocks Gate A review.

Physical concurrency, locks, storage, indexes, broker and transport mechanisms remain Gate B matters. Actual Identity implementation, capability assignment, detailed Cash disagreement authority and excluded Cash movement sources require their own decisions or authorization. None is approved by defining its logical dependency at Gate A.

### 9.2 Deferred Owner or professional input

- `CORE-OD-03`: tax treatment/display.
- `CORE-OD-04`: monetary precision and rounding policy/boundary.
- `CORE-OD-11B`: exact Branch Operating Day cutoff.
- `CORE-OD-12`: Cash capability assignments, delegation and separation of duties.
- `CORE-OD-13`: permitted post-close correction operations and authority.
- `CORE-OD-16B`: Reporting reader capability/scope.
- `CORE-OD-16F`: retention, disposal and legal hold.
- Detailed Cash discrepancy classes, linked corrections, escalation, resolution, disposition and release authority remain open within the confirmed `CORE-OD-15A/B` boundary.
- Refund amount, allocation, method, approval and execution remain outside CORE-01/02/04.

## 10. Recommended next work packages

1. **CORE-01 commercial evidence closure:** exact menu transcription plus qualified tax/rounding Owner package.
2. **CORE-01 design correction:** Payment target lifecycle, deterministic Price resolution, cross-context port/Application ownership, semantic transaction boundary and trusted command/evidence contracts; then independent re-review. Physical transaction and Identity implementation remain excluded.
3. **CORE-02 design synchronization:** align the document with confirmed policy, define Ticket/Item/acceptance/exception state machines, replay/reconciliation outcomes and reconcile bounded closure with `P1A-OD-07`.
4. **CORE-04 Owner-input package:** exact cutoff, capabilities/separation, post-close correction and remaining disposition/release authority.
5. **CORE-04 lifecycle correction:** separate handover, disagreement hold, Close, reconciliation, unresolved disposition and report release; define immutable evidence and the initial exact-cash source-fact contract. Keep future Cash movement sources excluded.
6. **Separate CORE-03 prerequisite:** only under its own authorization; do not fold Identity Milestone 2B into any Core Operations Gate.
7. **Gate A requests:** submit CORE-01, CORE-02 and CORE-04 separately only after their respective blockers receive independent closure evidence.

Parallelism is safe between packages 1, 3 and 4. Package 2 depends on the business inputs from package 1 for a complete executable calculation baseline. Package 5 depends on package 4. No implementation package may begin from this sequence.

## 11. Authorization boundary

This review preserves exactly:

- `CORE-OD-01` approved by reference and `CORE-OD-02` retired;
- 27 Owner-confirmed and seven Owner-deferred local references, all with `ID_PENDING_OWNER_GOVERNANCE`;
- the approved approximate price directions without inventing exact SKU Prices;
- manual bank exclusion from the initial slice pending separate prerequisites;
- Refund separation and Inventory deferral;
- CORE-03 and Identity Milestone 2B as unauthorized;
- no Reporting read, export, recipient, schedule or external-delivery authority;
- no Gate A approval, Gate B authorization or Gate C/Control Acceptance;
- no implementation, source, test, dependency, API, schema, migration, database or runtime authorization; and
- no external contact/disclosure, FOA or Production Authorization.

**Final review status:** `CORE_01_NOT_READY_FOR_OWNER_GATE_A_REVIEW — CORE_02_NOT_READY_FOR_OWNER_GATE_A_REVIEW — CORE_04_NOT_READY_FOR_OWNER_GATE_A_REVIEW — ZERO_GATES_GRANTED — ZERO_IMPLEMENTATION_AUTHORIZED`.
