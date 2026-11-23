# AFTER FOUR — Wave 2 Evidence Closure and Owner Review Readiness

**Status:** `EVIDENCE_REASSESSED — NO_READINESS_OR_POLICY_STATUS_CHANGED`

**Authority:** `NW-OR-01` — documentation, evidence assessment, and Owner-review preparation only

**Repository baseline:** `3cf8ecbb942fba4972d399a168a83a2e7a654d74`

**Evidence cutoff:** 2026-11-24 (Asia/Tokyo)

**Canonical ODB allocation:** `NOT_REQUESTED — NO_IDS_PROPOSED_OR_RESERVED`

**Implementation and Gate authorization:** `NOT_GRANTED`

## 1. Purpose and assessment method

This reassessment asks whether the evidence now retained in the repository is sufficient to present each of the five remaining evidence-gate candidates to the Owner for a substantive business-policy decision. Evidence acquisition, evidence sufficiency, Owner-review readiness, a recorded Owner decision, a granted Gate, and implementation authorization are separate states.

The [Owner Decision Baseline](../architecture/after_four_owner_decision_baseline.md#wave-2-conditional-direction-and-clarification-responses) controls existing policy and status. The assessment applies this readiness test independently to each candidate:

1. the business question is unambiguous;
2. materially relevant alternatives have adequate attributable evidence;
3. no unresolved dependency would make the ballot misleading; and
4. no technical, legal, accounting, privacy, fraud, food-safety, or operational conclusion has to be invented.

The repository was inspected at the baseline above. Local `main` and `origin/main` both resolved to that commit before the isolated assessment branch was created, and the working tree was clean. Repository material is the primary evidence. External sources are used only for the proposition they actually support; a cited law, regulation, or standards source is not treated as an attributable professional opinion.

## 2. Executive outcome

None of the five candidates is ready for a substantive Owner policy ballot at the evidence cutoff.

| Candidate | Canonical status preserved | This assessment | Decisive reason |
|---|---|---|---|
| `P2B-CASH-OD-03` | `CLARIFICATION_REQUIRED` | `EVIDENCE_INCOMPLETE` | The no-tolerance and immutable-evidence baseline is clear, but correction operations, authority, accounting outcome, and Reporting treatment lack supported alternatives. |
| `P2A-PROMO-OD-01` | `CLARIFICATION_REQUIRED` | `EVIDENCE_INCOMPLETE` | Four exploratory concepts and a broader expression direction are named, but no bounded, comparable type catalogue is evidenced. |
| `P2A-PROMO-OD-06` | `CLARIFICATION_REQUIRED` | `EVIDENCE_INCOMPLETE` | Bearer versus Customer-bound behavior is a real trade-off, but issuance, reuse, transfer, limits, fraud, and recovery options remain incomplete. |
| `P2B-INV-OD-04A` | unresolved `CONDITIONALLY_REVIEWABLE` | `DEPENDENCY_BLOCKED` | Preparation/Recipe/Ordering have not supplied an authoritative physical event and its failure/correction facts; Accounting evidence cannot choose that operational fact. |
| `P2A-PROMO-OD-08` | unresolved `CONDITIONALLY_REVIEWABLE` | `EVIDENCE_INCOMPLETE` | Named-zone mechanics are evidenced, but timezone ownership, applicability, boundary semantics, and lifecycle interaction remain business inputs without a supported selection. |

Assessment totals: **zero** `READY_FOR_OWNER_POLICY_REVIEW`, **four** `EVIDENCE_INCOMPLETE`, and **one** `DEPENDENCY_BLOCKED`. These are assessment recommendations, not mutations of the canonical classifications in the Owner Decision Baseline.

## 3. Evidence inventory

### 3.1 Repository evidence

| Source | Authority / date | Proposition supported | Limitation |
|---|---|---|---|
| [Owner Decision Baseline](../architecture/after_four_owner_decision_baseline.md) | Canonical Owner register; current at baseline | Existing Cash policies; Wave 2 selections, clarification requests, Conditional candidates, crosswalks, and non-authorizations | Does not supply the missing option evidence or select any of the five candidates. |
| [Wave 2 Owner Review Package](after_four_wave_2_owner_review_package.md) | `NW-OR-01`; pre-decision review package | Original questions, accountable owners, source links, and historical readiness evidence for all 55 candidates | Historical review wording cannot override later canonical outcomes. |
| [Flow A Closure Package](after_four_wave_2_flow_a_closure_package.md) | `NW-OR-01`; 2026-11-23 | Closure surfaces and controlling one-Organization/one-Brand boundary | Prepared review material, not policy approval. |
| [Consolidated Owner Review Session](after_four_wave_2_consolidated_owner_review_session.md) | `NW-OR-01`; 2026-11-23 | Owner-review framing and independently answerable ballots | Does not close the five evidence gates. |
| [Remaining Evidence Closure Package](after_four_wave_2_remaining_evidence_closure_package.md) | `NW-OR-01`; 2026-11-23 | Exact missing evidence, supported dimensions, responsible domains, and canonical `55 = 16 + 22 + 2 + 3 + 12` reconciliation | Option preparation is not evidence acceptance or policy selection. |
| [Upstream Commercial Dependency Evidence Review](after_four_wave_2_upstream_commercial_dependency_evidence_review.md) | `NW-OR-01`; repository evidence review | Separates unresolved Payment/Refund and Catalog/Pricing inputs from downstream policy ownership | Does not resolve Cash discrepancy, Voucher, scheduling, or Preparation recognition policy. |
| [Cross-domain Readiness Reassessment](after_four_wave_2_cross_domain_readiness_reassessment.md) | `NW-OR-01`; 2026-11-24 | Source-verified 55-candidate inventory, dependency ownership, and five evidence-gate questions | Explicitly records no readiness promotion. |
| [Parallel Evidence Acquisition](after_four_wave_2_parallel_evidence_acquisition.md) | `NW-OR-01`; 2026-11-24 | Current legal/regulatory research, candidate-event consequences, source limitations, and required qualified providers | Research summaries are not professional advice or expert acceptance evidence. |
| [Cash discovery](after_four_p2b_cash_domain_discovery.md), [Inventory discovery](after_four_p2b_inventory_domain_discovery.md), and [Promotions discovery](after_four_p2a_promotions_policy_discovery.md) | Domain discovery sources | Candidate meanings, ownership, exploratory concepts, and policy gaps | Discovery recommendations remain `PROPOSED_NOT_APPROVED` unless recorded in the canonical baseline. |
| [Customer decisions](../architecture/after_four_customer_management_owner_decisions.md) and [`SDP-SCOPE-01`](../architecture/after_four_sdp_scope_01_owner_decision.md) | Owner-confirmed Customer and scope policy | Anonymization boundaries, benefit-history constraints, current one-Organization/one-Brand assumption, and cross-Brand default deny | Do not decide Voucher issuance, identity verification, fraud recovery, or Promotion applicability. |
| [Business Domain Model](../architecture/after_four_business_domain_model.md) and [ADR-0011](../architecture/adr/0011-project-wide-layered-ddd.md) | Canonical/proposed domain detail and accepted architecture rule | Context ownership and inward dependency direction | Architecture ownership does not establish business event timing or authorize implementation. |

### 3.2 External evidence actually applicable to these five candidates

| Source | Authority / date | Proposition supported | Limitation for this assessment |
|---|---|---|---|
| [Accounting Law 88/2015/QH13](https://vanban.chinhphu.vn/?classid=1&docid=183198&pageid=27160&typegroupid=3) | National Assembly of Vietnam; issued 2015-11-20, effective 2017-01-01 | General accounting-record and correction constraints | Does not define Cash discrepancy classes, correction operations, initiator/approver authority, journal outcome, or Reporting hold/release. No attributable accountant opinion is retained. |
| [Decree 81/2018/NĐ-CP](https://vanban.chinhphu.vn/?classid=1&docid=193294&pageid=27160&typegroupid=2), as researched with later amendments | Government of Vietnam; current trade-promotion framework must be read with applicable amendments | Promotion activity has a regulatory framework that may affect commercial form and communication | Does not choose AFTER FOUR Promotion types, formulas, eligibility, allocation, or Voucher policy. Qualified applicability review remains absent. |
| [Decree 13/2023/NĐ-CP](https://vanban.chinhphu.vn/?docid=207759&pageid=27160) | Government of Vietnam; issued 2023-04-17, effective 2023-07-01 | Customer-bound Voucher handling may engage personal-data duties | Does not choose bearer/bound behavior, identity evidence, transfer, recovery, fraud controls, or retention. No attributable privacy opinion is retained. |
| [IANA Time Zone Database](https://www.iana.org/time-zones) | IANA; continuously maintained technical reference, inspected by the 2026-11-24 research | Named zones encode offset histories and rule changes | Does not choose a business timezone, Branch/Organization ownership, interval inclusivity, anomaly outcome, or lifecycle interaction. |
| [Food Safety Law 55/2010/QH12](https://vanban.chinhphu.vn/?classid=1&docid=96032&pageid=27160&typegroupid=3) | National Assembly of Vietnam; issued 2010-06-17, effective 2011-07-01 | Relevant food-origin, safety, traceability, recall, and disposal duties may apply | Does not select Preparation start, completion, handoff, or another event as Inventory's normal-consumption recognition point. |

No retained source is treated as evidence of external expert confirmation. Where an entity-, product-, location-, or workflow-specific conclusion is needed, this document names the qualified provider or accountable domain that must supply it.

## 4. `P2B-CASH-OD-03` — Cash discrepancy policy

### 4.1 Existing approved direction

- There is no discrepancy tolerance in the current baseline.
- Every nonzero discrepancy is an exception that must be recorded with a reason and Owner notification.
- Classification may guide investigation, escalation, and resolution, but may not remove recording, reason, or notification.
- Closed evidence remains immutable. A permitted post-close correction is a separately attributable linked fact, never reopening or rewriting the closed evidence.
- Notification is not approval, and recording a discrepancy does not authorize correction.
- Previously approved top-up authorization and Cash Session/Operating Day reconciliation boundaries remain unchanged.

### 4.2 Evidence obtained

The repository now separates classification, notification/escalation, resolution, authority, evidence, Accounting, and Reporting as distinct policy dimensions. It also establishes that an unresolved discrepancy must remain explicitly unresolved and that any departure from the no-tolerance baseline requires a separate explicit policy amendment. Accounting Law 88 supports general record/correction discipline but not the missing Cash-specific choices.

### 4.3 Evidence still unresolved

- supported discrepancy classes and their exact investigation/escalation consequences;
- candidate linked-correction operations;
- who may initiate and who may approve each operation;
- separation, escalation, disagreement, and overdue behavior;
- minimum evidence for each operation and authority boundary;
- Accounting treatment and reconciliation result for corrected and unresolved cases; and
- when authoritative Reporting is held, released, qualified, or continues to expose an unresolved case.

### 4.4 Supported alternatives and excluded assumptions

The evidence supports only the controlling no-tolerance/immutable-evidence baseline and the possibility that future classification affects investigation, escalation, and resolution. It does **not** support Owner-only versus capability-based correction authority, any tolerance or threshold, notification as approval, a particular accounting entry, or a Reporting release rule. Presenting those as selectable alternatives now would invent evidence.

**Recommendation:** `EVIDENCE_INCOMPLETE`

**Exact next action:** Cash must produce a candidate operation/classification matrix. For each operation, Accounting and Reporting must provide attributable input covering initiator/approver responsibility, separation/escalation, required evidence, accounting/reconciliation result, and Reporting treatment. A qualified Vietnamese accountant must identify their identity/qualification, applicable entity and reporting regime, source versions, assumptions, exclusions, and review date. Cash remains the accountable policy owner; Accounting and Reporting are evidence providers, not substitute policy owners.

## 5. `P2A-PROMO-OD-01` — Initial Promotion type catalogue

### 5.1 Existing approved direction

No initial Promotion type catalogue is approved. Fixed, percentage, bundle, and free-item are exploratory concepts. A general-expression capability is a separate broader direction. Choosing a small explicit type set is a proposal, not an existing selection.

### 5.2 Evidence obtained

The repository identifies business dimensions that would make each concept bounded:

- **fixed:** monetary benefit, line-versus-Order basis, floors, allocation, tax/service-charge, Refund and cancellation treatment;
- **percentage:** eligible base, cap/floor, rounding, stacking, allocation, Refund and cancellation treatment;
- **bundle:** required items/quantities, Product/Variant facts, substitutions, partial fulfillment, allocation, and cancellation;
- **free-item:** identified benefit item, zero/free-price treatment, stock/Preparation consequences, substitutions, limits, Refund and cancellation; and
- **general expression:** validation, deterministic evaluation, explainability, auditability, security, and support exposure.

The trade-promotion framework establishes regulatory context but does not define AFTER FOUR's catalogue or its commercial semantics.

### 5.3 Evidence still unresolved

No retained commercial specification defines a complete candidate type, and no comparative matrix covers Customer eligibility, Catalog inputs, Order calculation, invoicing/tax, Refund/cancellation, Reporting, operational support, or exclusions across a bounded selectable set. The unresolved Catalog/Pricing and Payment/Refund inputs prevent formula/execution closure, although the Owner could later choose a bounded business type direction if each alternative were defined without those technical mechanisms.

### 5.4 Supported alternatives and excluded assumptions

Evidence supports further research into the four exploratory concepts, deferral, or separate consideration of a general-expression direction. It does not support silently renaming `fixed` to `fixed-amount`, treating all four as a recommended launch set, or treating general expression as equivalent to an explicit type. No type taxonomy, expression language, formula, stacking sequence, schema, or engine is selected.

**Recommendation:** `EVIDENCE_INCOMPLETE`

**Exact next action:** Promotions must author a bounded business-semantics sheet for each candidate type it wishes to place on the ballot. Catalog/Pricing and Ordering must validate required inputs and applicability; a qualified Vietnamese tax/accounting reviewer must state invoice/tax/refund implications within an identified entity/regime; Reporting and operational support owners must state evidence and explainability needs. The resulting ballot may offer only alternatives supported by those sheets. Promotions remains accountable.

## 6. `P2A-PROMO-OD-06` — Voucher policy

### 6.1 Existing approved direction

Voucher remains optional and no complete Voucher policy is approved. Current operations retain one Organization/one Brand; cross-Brand behavior is unavailable/default-denied. Phone possession is not identity or authority. Customer-specific benefits may not be transferred or used to restore identity automatically. Successful redemption history and frozen unused Customer-specific benefits remain subject to existing Customer anonymization policy.

### 6.2 Evidence obtained

The repository distinguishes issuance authority, bearer versus Customer-bound eligibility, reuse, transfer, quantity/time limits, loss/compromise/recovery, and supporting evidence. It explains the material trade-off: bearer behavior reduces identity friction but increases leakage/fraud exposure; Customer binding increases verification and privacy duties. Decree 13 establishes a personal-data framework relevant to Customer binding but does not select a policy.

### 6.3 Evidence still unresolved

- whether Voucher is in the bounded scope at all;
- source-supported issuance operations, authority, scope, evidence, and revocation;
- authoritative successful use and reversal semantics;
- single-use, bounded multi-use, or reusable-limit behavior;
- transfer boundaries consistent with Customer policy;
- per-Voucher, Customer, Promotion, Branch, and period limits;
- loss, compromise, invalid, disputed, replacement, revocation, and recovery outcomes;
- fraud monitoring, exception authority, Customer support, and incident handling; and
- attributable privacy advice on purpose, lawful processing, minimization, access, retention, anonymization, and identity evidence.

### 6.4 Supported alternatives and excluded assumptions

Bearer, Customer-bound, and no bounded Voucher capability are meaningful directions. The remaining dimensions are option categories, not yet adequately evidenced alternatives. No source supports phone possession as verification, automatic Customer association, transfer of Customer-specific benefits, identity restoration, cross-Brand applicability, a token format, storage mechanism, authorization design, or recovery workflow.

**Recommendation:** `EVIDENCE_INCOMPLETE`

**Exact next action:** Promotions must produce a complete Voucher policy matrix covering inclusion, issuance, binding, reuse, transfer, limits, expiry, revocation, compromise, dispute, and recovery. Customer and qualified Vietnamese privacy counsel must validate Customer/anonymization and personal-data consequences; the named fraud/risk owner must provide misuse and recovery alternatives; tax/accounting and support owners must provide commercial and operational consequences. Each provider must be attributable and scope its assumptions. Promotions remains accountable.

## 7. `P2B-INV-OD-04A` — Preparation consumption recognition

### 7.1 Existing approved direction

No normal-consumption recognition event is selected. `P2B-INV-OD-04B` keeps waste, remake, and failed-Preparation deviations distinct from normal consumption. Preparation owns work/deviation facts; Inventory owns stock movement and reconciliation; Ordering owns cancellation; Accounting supplies valuation consequences.

### 7.2 Evidence obtained

The repository now describes consequences of four possible event families:

| Candidate event | Evidenced consequence | Missing authoritative fact |
|---|---|---|
| Preparation start | Earlier availability change | Whether physical consumption is sufficiently committed; cancellation, abandoned/partial work, duplicate start, remake/waste and correction facts |
| Preparation completion | Avoids premature normal-consumption recognition | Whether availability becomes stale; separate failed, abandoned, waste and partial-completion facts |
| Handoff/dispatch | Possible operational custody boundary | Whether it is too late relative to irreversible consumption; missing, rejected, duplicate and remade outcomes |
| Another explicit event | Could align to ingredient issue/dispense or station confirmation | No approved event, owner contract, RecipeVersion/quantity evidence, or failure/correction semantics |

Accounting and food-safety sources confirm that evidence and traceability matter, but neither source determines when the physical workflow has consumed stock.

### 7.3 Unresolved dependency and excluded assumptions

Preparation/Recipe/Ordering have not supplied retained, attributable workflow evidence defining actual start, physical ingredient use, completion, handoff, cancellation, failure, partial completion, remake, waste, or correction. Without those facts, Accounting cannot assess valuation timing and Inventory cannot compare recognition choices without guessing. UI state, implementation simplicity, a journal convention, or a food-safety obligation may not be substituted for the authoritative business event.

**Recommendation:** `DEPENDENCY_BLOCKED`

**Exact next action:** Preparation must own and provide a reviewed event/failure matrix grounded in the real operating workflow, with RecipeVersion and quantity meaning. Recipe/Catalog must validate inputs; Ordering must define cancellation facts; Inventory must map each event to movement/reconciliation consequences; a qualified accountant must assess valuation implications only after those operational facts exist. The evidence review must state assessor/owner, date, applicable products/locations, assumptions, exceptions, and unresolved conflicts. Inventory remains accountable for the eventual policy ballot.

## 8. `P2A-PROMO-OD-08` — Promotion scheduling semantics

### 8.1 Existing approved direction

No business timezone, Branch/Organization ownership rule, start/end boundary convention, offset-change outcome, or scheduling mechanism is selected. Approved Promotion publication, pause, resume, and manual-end directions remain distinct; scheduled eligibility cannot grant publication authority. The one-Organization/one-Brand and cross-Brand-default-deny boundaries remain controlling.

### 8.2 Evidence obtained

IANA tzdb supports the use of named timezone identifiers and records offset histories/rule changes. The repository identifies independently answerable dimensions: one explicit business timezone versus Branch-local time; inclusive versus exclusive start; inclusive versus exclusive end; named-zone anomaly handling versus restricting affected schedules; and shared versus Branch-local campaign evaluation. It also identifies cross-midnight and exact-boundary cases that must have deterministic business outcomes.

### 8.3 Evidence still unresolved

- which business role owns timezone configuration and at what scope;
- whether a campaign is Branch-specific or shared across applicable Branches;
- customer-facing expectation for cross-midnight and exact-boundary eligibility;
- start/end inclusivity and overlap behavior;
- nonexistent or ambiguous local-time behavior where a selected zone changes offset;
- effect of publication, pause, resume, manual end, and future rescheduling on the eligibility interval; and
- change-control and historical-evidence expectations if timezone configuration changes.

### 8.4 Supported alternatives and excluded assumptions

One explicit business timezone and Branch-local evaluation are genuine directions; inclusive/exclusive boundaries are genuine choices. The evidence does not support a particular combination. UTC, `Asia/Ho_Chi_Minh`, Organization time, Branch time, or half-open intervals may not be silently selected. Named-zone capability is technical evidence, not an Owner policy decision, and no legal source mandates one of these business outcomes.

**Recommendation:** `EVIDENCE_INCOMPLETE`

**Exact next action:** Promotions and Operations must provide an applicability/operating-time matrix for Branch-specific and shared campaigns, including cross-midnight, exact start/end, offset anomaly, publication, pause/resume, manual end, and timezone-change scenarios. Customer support/communication owners must validate externally communicated behavior. Promotions must then prepare independently answerable policy questions; a later technical design may choose clock representation and enforcement only after policy selection.

## 9. Cross-domain consistency findings

1. **Cash:** `P2B-CASH-OD-03` must not reopen approved no-tolerance or immutable-close policy. Correction authority, Accounting outcome, and Reporting release remain separate choices; notification never implies approval.
2. **Promotions and Customer:** `P2A-PROMO-OD-06` must preserve anonymization, benefit-history, non-transfer, identity, and privacy boundaries. Neither Voucher possession nor a phone association establishes Customer identity or authority.
3. **Promotions and scope:** `P2A-PROMO-OD-01`, `06`, and `08` remain within the current one-Organization/one-Brand assumption. None permits cross-Brand discovery, applicability, transfer, or sharing.
4. **Promotions, Catalog, Ordering, Payment/Refund:** type semantics require Catalog inputs and Order consequences, while reversal/allocation still depends on unresolved commercial outcomes. Those dependencies do not authorize Promotions to own Catalog prices, Order calculation, Payment outcomes, or Refund allocation.
5. **Inventory and Preparation:** `P2B-INV-OD-04A` is an integration-policy question between authoritative Preparation facts and Inventory recognition. It must remain separate from deviation policy, valuation method, and implementation transaction boundaries.
6. **Scheduling and lifecycle:** `P2A-PROMO-OD-08` decides eligibility time semantics only. Publication, pause, resume, and manual end remain distinct approved directions and must not be collapsed into a scheduler decision.
7. **Professional evidence:** accounting, privacy, tax, fraud, food-safety, and operational evidence providers inform accountable domain owners; they do not silently become policy owners. Repository research does not represent external professional acceptance.

No contradiction requiring a canonical Owner-decision change was found. The common dependency is evidence quality and attributable scope, not a shared aggregate, shared transaction, or combined ballot.

## 10. Updated candidate reconciliation

The canonical inventory remains unchanged:

| Canonical category | Count | Effect of this reassessment |
|---|---:|---|
| Recorded Owner decisions | 16 | Unchanged; not reopened. |
| Confirmed Conditional directions | 22 | Unchanged; remaining parameters are not re-voted here. |
| Unresolved Conditional candidates | 2 | `P2B-INV-OD-04A` and `P2A-PROMO-OD-08` remain unselected. |
| Clarification requests | 3 | `P2B-CASH-OD-03`, `P2A-PROMO-OD-01`, and `P2A-PROMO-OD-06` remain clarification requests. |
| Dependency-blocked candidates | 12 | Canonical blocked inventory unchanged; this focused assessment identifies the operative dependency block for `P2B-INV-OD-04A` without altering its canonical status. |
| **Active total** | **55** | **`16 + 22 + 2 + 3 + 12 = 55`** |

The focused readiness assessment has a different purpose and therefore a separate tally: `0 READY_FOR_OWNER_POLICY_REVIEW + 4 EVIDENCE_INCOMPLETE + 1 DEPENDENCY_BLOCKED = 5` assessed evidence-gate candidates. It does not replace or rewrite the canonical inventory.

## 11. Explicit non-authorizations

This package:

- records no Owner policy decision and changes no existing decision or rationale;
- allocates, reserves, proposes, or implies no canonical `ODB-*` identifier;
- changes no canonical readiness classification, crosswalk, candidate inventory, or accountable owner;
- accepts no legal, accounting, tax, privacy, fraud, food-safety, or operational opinion;
- selects no Promotion type, Voucher rule, timezone, interval boundary, Cash authority, discrepancy class, accounting treatment, Reporting release rule, or Preparation recognition event;
- authorizes no physical database design, schema, migration, database creation or operation, persistence, API, transaction, lock, isolation choice, source code, test, dependency, runtime behavior, deployment, or production access; and
- grants no Gate A, Gate B, Gate C, Control Acceptance, Final Operational Acceptance, or Production Authorization.

The next permitted step is evidence acquisition and review by the named accountable domains and qualified providers. A later, separately reviewed package may recommend Owner-policy readiness only when the relevant evidence surface satisfies the four-part test in §1.
