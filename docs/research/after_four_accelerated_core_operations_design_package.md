# AFTER FOUR — Accelerated Core Operations Design Package

**Package status:** `DESIGN_PREPARATION_COMPLETE — OWNER_DECISIONS_AND_GATE_A_REVIEW_REQUIRED`

**Repository baseline:** `main` at `eef71b6753605dd05abdfb17a5dc86e607ebcd07`

**Evidence cutoff:** 2026-11-24 (Asia/Tokyo)

**Implementation authorization:** `NOT_GRANTED`

## 1. Purpose, authority and classifications

This package consolidates five bounded Core Operations workstreams and one Owner review. It follows the [Accelerated Core Operations Readiness Assessment](after_four_accelerated_core_operations_readiness_assessment.md), preserves the canonical [Owner Decision Baseline](../architecture/after_four_owner_decision_baseline.md), and follows accepted [ADR-0011 Layered DDD](../architecture/adr/0011-project-wide-layered-ddd.md).

The current Owner direction is dine-in plus takeaway, approximate selling-price bands of 23,000 VND, 33,000 VND and 43,000–49,000 VND, Inventory deferral, parallel design preparation and consolidated review. These are inputs to this package. The approximate bands are not an approved Product/Variant/Price dataset and do not supersede `ODB-CAT-11`–`ODB-CAT-13`, which approve only launch scale, selective S/M/L and three Signature designations—not individual rows or Prices ([Owner Decision Baseline §5](../architecture/after_four_owner_decision_baseline.md#5-catalogpricing-mvp)).

Classifications used here:

| Classification | Meaning |
|---|---|
| `OWNER_CONFIRMED` | Exact policy recorded in the canonical Owner Decision Baseline. |
| `IMPLEMENTED_BEHAVIOR` | Current executable repository behavior found by source inspection. |
| `TEST_ARTIFACT_EXISTS` | A checked-in spec exists; this package did not execute it. |
| `TECHNICAL_PROPOSAL` | Candidate design requiring review; not approved or implemented. |
| `OWNER_DECISION_REQUIRED` | A business choice remains open and blocks the affected baseline. |
| `IMPLEMENTATION_AUTHORIZATION_REQUIRED` | A separate exact Gate B or equivalent authorization is mandatory. |
| `OUT_OF_SCOPE` | Explicitly excluded from this package. |

Repository presence is not authority. No Gate, implementation, production, external-contact or disclosure authorization follows from this document.

## 2. Verified baseline and Gate status

### 2.1 Implemented foundations

- `Orders::CreateDraft`, `Orders::Confirm`, `Orders::Hold` and `Orders::ExpirePending` implement an aggregate-total Order foundation (`backend/app/domains/orders/`).
- `Payments::ConfirmCash` and `Payments::ConfirmBankTransfer` call the exact-balance local confirmation command; mismatch is recorded/rejected and eligible settlement atomically creates one pending Preparation Dispatch (`backend/app/domains/payments/confirm.rb:34-101,126-234`).
- Late success on Held/Expired Orders records financial truth plus a review case without automatic dispatch or reactivation (`backend/spec/services/payments/late_success_spec.rb`).
- `Preparation::RequestDispatch` and `Preparation::RetryDispatch` create/requeue the durable pending handoff; no ticket worker or kitchen lifecycle exists (`backend/app/domains/preparation/`).
- Category/Product/Variant records and integrity mechanisms exist as the empty Catalog foundation; no Pricing, Availability or runtime Catalog operation follows ([P1B §3 and §11](after_four_p1b_catalog_current_state_reconciliation.md#3-current-state-reconciliation-matrix)).
- Rails has no business routes; only health and API-not-found routes exist (`backend/config/routes.rb:1-9`). POS and delivery pages remain local demos (`frontend/src/features/pos/hooks/use-demo-order.ts`; `frontend/src/features/upstairs-delivery/hooks/use-demo-delivery-queue.ts`).

### 2.2 Gate and authorization baseline

| Workstream | Gate A | Gate B / implementation | Gate C | Consequence |
|---|---|---|---|---|
| I1 Brand → Organization ancestry | `APPROVED` | `APPROVED`; bounded implementation merged | `APPROVED` under `AF-OWNER-002` | Only the ancestry contract is accepted; broader Identity remains unauthorized ([AF-OWNER-002 §4](../architecture/security-reviews/owner-led/af-owner-002-i1-organization-scope-gate-c-decision.md#4-governance-consequences)). |
| Identity Milestone 2B / operator access | No applicable approval | `NOT_AUTHORIZED` | None | ADR-0006 remains Proposed; new operator access cannot be implemented ([Foundation Decisions §5](../architecture/after_four_foundation_decisions.md#5-milestone-2--identity-branch-scope-and-authorization)). |
| Catalog Package B | No A/B/C record governing new Core work | Merged foundation; no new/runtime operation authorization | None | May be reused as evidence only; Pricing and runtime Catalog remain absent. |
| Order/Payment Phase 1 | Historical phase predates current Gate vocabulary | Merged exact-balance foundation; P1A grants no extension | None | New API, Order Item, Refund or provider work requires separate authorization. |
| CORE-01/02/03/04/05 | `NOT_GRANTED` | `NOT_GRANTED` | None | This package is a proposed Gate A review baseline only. |

“No A/B/C record” is an evidence finding, not a new governance status.

## 3. CORE-01 — Core Sale Slice bounded design

### 3.1 Boundary and non-goals

`CORE-01` proposes this single bounded flow:

```text
authoritative menu/effective Price read
  → Draft Order with Order Items
  → server calculation
  → confirmation and immutable sold snapshots
  → exact-balance cash/manual-bank confirmation
  → existing unique pending Preparation Dispatch
```

Inventory, Customer association, Promotions, Loyalty, Refund execution, electronic-provider integration, kitchen execution, Cash Session posting and Reporting projections are excluded. Anonymous/unregistered Orders remain allowed under `SDP-CUST-19`.

### 3.2 Layered DDD responsibilities

| Layer/context | Proposed responsibility | Must not do |
|---|---|---|
| Catalog/Pricing Domain | Express Product/Variant identity and effective Price facts supplied by an approved Application contract. | Own Order state or infer a sale from a read. |
| Catalog/Pricing Application | Resolve a sellable Variant and one authoritative effective Price for Branch and decision instant. | Expose Active Record or trust client Price. |
| Ordering Domain | Own Draft/Confirmed Order and Order Item rules; calculate from trusted commercial facts; freeze confirmed snapshots. | Query Catalog Infrastructure directly or own Payment truth. |
| Ordering Application | Orchestrate menu selection, revalidation, calculation, Draft mutation and confirmation; enforce idempotency/version checks. | Accept client totals as authoritative. |
| Payment Application | Preserve Phase 1 exact-balance confirmation and settlement/dispatch boundary. | Recalculate Order commercial terms or treat bank alerts as proof. |
| Infrastructure | Implement persistence and cross-context adapters; create existing outbox/dispatch facts transactionally where approved. | Supply business authority or bypass Application contracts. |
| Presentation | Adapt authenticated requests/responses and stable errors. | Calculate authoritative totals or accept actor/Branch/Price claims as authority. |

Dependencies point inward under ADR-0011. Cross-context calls use Application-owned consumer ports; no context accesses another context's Active Record models.

### 3.3 Proposed logical contracts

All names and fields below are `TECHNICAL_PROPOSAL`.

**Catalog read result**

- trusted Brand and Branch scope;
- Product ID, Variant ID and approved display descriptions;
- sellability at the resolution instant;
- immutable Price-version reference, scope and effective instant/interval;
- integer VND amount and currency;
- source/evidence version sufficient for revalidation.

**Draft Order Item**

- stable line identity, Product ID, Variant ID and quantity;
- current quote facts and Price-version reference;
- draft descriptions for operator review;
- line amount derived server-side;
- client note, if approved, kept distinct from authoritative commercial facts.

**Confirmed sold snapshot**

- Product and Variant IDs plus immutable sold descriptions;
- authoritative Price-version reference and sold unit Price;
- quantity, line subtotal, approved adjustment components and final line amount;
- Order currency and calculation-version reference;
- confirmation time and provenance sufficient to explain the amount later.

Only sold Price immutability is already `OWNER_CONFIRMED` (`ODB-CAT-10`; [Data Integrity Rules §5](../architecture/after_four_data_integrity_rules.md#50-catalogpricing-mvp-rules)). Exact description/component fields remain proposed pending unresolved commercial policies.

### 3.4 Draft, calculation and confirmation

- Draft permits item add/update/remove against an expected Order version.
- Every mutation resolves current authoritative Catalog/Pricing facts server-side and recalculates the complete Draft.
- The server returns the calculated result and a revalidation token/version; the client displays but does not author it.
- Confirmation locks/revalidates the Order and affected authoritative Price facts using a separately reviewed concurrency protocol.
- If Price changed, confirmation fails with a revised quote requiring explicit review (`ODB-CAT-09`).
- Successful confirmation freezes sold snapshots and opens the existing Payment window atomically.
- Confirmed items and amounts are immutable; later correction/cancellation uses linked facts and approved workflows, never overwrite.

The current `Orders::CreateDraft` accepts `total_amount` from its caller (`backend/app/domains/orders/create_draft.rb:7-27`). `CORE-01` must replace that trust boundary for the public operational flow; it must not silently change the existing command before Gate B approval.

### 3.5 Monetary sequence and precision

Existing Phase 1 uses integer VND fields and exact equality (`backend/app/models/payment.rb:10-15`; `backend/app/domains/payments/confirm.rb:126-135`). The following is the narrow proposed skeleton, not an approved calculation policy:

1. resolve authoritative unit Price for every line;
2. multiply unit Price by positive integer quantity using checked integer arithmetic;
3. apply only separately approved commercial components in an Owner-approved order;
4. apply approved rounding at the approved boundary;
5. sum authoritative line/order components to one exact Payment target;
6. persist component provenance and calculation version before confirmation commits.

Tax treatment, rounding, Modifier effects, complimentary/zero-price behavior, Service Charge, Promotion/Loyalty and component order remain `OWNER_DECISION_REQUIRED`. Until resolved, Gate A cannot approve an executable calculation contract that contains them.

### 3.6 Payment and dispatch boundaries

- Confirm only exact target amount and currency through the existing cash/manual-bank commands.
- Manual bank transfer remains cashier-observed confirmation; an alert/speaker is not authoritative bank evidence ([API Contract §6.2](../architecture/after_four_api_contract.md#62-payment-commands)).
- Reuse current Payment lock, attempt idempotency and mismatch evidence.
- Successful eligible settlement, Payment aggregate update, pending Dispatch, Outbox Event and audit commit together (`backend/app/domains/payments/confirm.rb:40-98,177-234`).
- Dispatch delivery and kitchen ticket creation are `CORE-02`, not `CORE-01`.
- Held/Expired late success records a review case and never automatically dispatches.

### 3.7 Failure, retry and concurrency acceptance matrix

| Scenario | Required outcome | Current evidence / remaining design |
|---|---|---|
| Same command identity and same input | Return original result; no duplicate Order, Payment, item or Dispatch. | Phase 1 covers Order/Payment replay; Order Item/API behavior requires future tests. |
| Same identity, different input | Stable idempotency conflict. | Implemented for draft/payment foundations; extend only after Gate B. |
| Price changes during Draft | Return revised server quote; explicit review required before confirm. | Policy `ODB-CAT-09`; lock/token mechanism unresolved. |
| Concurrent line edits | One accepted version; stale writer receives conflict and safe current version. | `TECHNICAL_PROPOSAL`; deterministic concurrency tests required. |
| Confirmation races Price publication | Either confirmed snapshot binds the old still-effective version valid at the linearization point, or confirmation fails/requotes; never a mixed snapshot. | Transaction/lock protocol unresolved. |
| Audit/snapshot persistence fails | Entire affected mutation rolls back. | Existing commands use transactions; new item/snapshot evidence needs failure injection. |
| Payment mismatch | Record safe mismatch evidence; do not settle or dispatch. | Implemented/test artifacts exist. |
| Commit succeeds, response is lost | Retry returns committed result without duplicate charge/dispatch. | Phase 1 idempotency pattern exists; API evidence required. |
| Outbox delivery fails | Payment stays authoritative; same pending Dispatch remains recoverable without recharging. | Pending dispatch/retry exists; worker outcome is CORE-02. |

## 4. CORE-02 — Preparation lifecycle bounded design

### 4.1 Existing versus proposed

`IMPLEMENTED_BEHAVIOR`: a fully settled eligible Order owns at most one pending `PreparationDispatch`; the transaction also writes an Outbox Event. Retry requeues that same event. `preparation_dispatch_attempts` exists but has no Phase 1 writer ([Order/Payment Phase 1 §§2 and 7](../architecture/after_four_order_payment_implementation_phase1.md#2-implemented-records-and-states)).

`TECHNICAL_PROPOSAL`: a future consumer accepts that dispatch idempotently and creates one Preparation Ticket with immutable Order/sold-item references. It never changes Payment truth.

### 4.2 Candidate state model

The following states are proposed vocabulary, not Owner-approved policy:

```text
Dispatch: pending → accepted | failed/retryable
Ticket: queued → in_progress → completed
                    ↘ cancellation_or_exception_review
```

Rejected ticket semantics, partial-item completion, cancellation after dispatch, remake/deviation, handover and terminal failure remain Owner decisions. A generic mutable status endpoint is prohibited; named commands request transitions.

### 4.3 Proposed responsibilities and invariants

- Preparation owns Ticket/Item execution state; Ordering owns Order commercial state; Payment owns settlement.
- Dispatch acceptance is idempotent by the existing Dispatch identity.
- Ticket creation plus durable acceptance evidence commits atomically; a crash before commit leaves the Dispatch retryable.
- A retry cannot create a second Ticket or duplicate items.
- Ticket Items use confirmed sold-item references and quantities; they do not query current Catalog descriptions/Prices to reconstruct history.
- Start/complete/cancel commands require trusted actor, Branch scope, exact capability, expected version and audit evidence.
- Completion cannot imply Order closure until the separate Ordering closure guards are approved (`P1A-OD-07` remains deferred).
- Preparation failure/cancellation cannot rewrite Payment success.
- Inventory postings are absent; future Inventory consumes separately approved facts asynchronously and cannot gate completion in this milestone.

### 4.4 Required future evidence

- duplicate/out-of-order outbox delivery;
- worker crash before and after Ticket commit;
- concurrent accept/start/complete/cancel;
- multi-item and proposed partial-item schedules;
- cancellation race against start;
- failure/audit rollback;
- cross-Branch non-disclosure;
- Payment remains unchanged under every Preparation failure;
- reconciliation of pending Dispatch without Ticket and Ticket without acknowledged delivery.

## 5. CORE-04 — Cash and Operating Day closure assessment

### 5.1 Preserved Owner-approved policy

| Canonical source | Preserved policy | Still unresolved |
|---|---|---|
| `ODB-CASH-01`–`07` | One shared physical drawer retains individual actor evidence; one 2,000,000 VND Operating Day float carries across shifts without automatic reset/top-up; opening checks sufficiency; close counts/verifies; shortages and discrepancies preserve accountability and notify the Owner. No discrepancy tolerance is approved. | Exact escalation timing, correction flow and operational representation. |
| `ODB-CASH-12` | Operating Day uses explicit Branch timezone and cutoff. | Exact timezone/cutoff, chain vs Branch configuration, exceptional days. |
| `ODB-CASH-13` | Separate Branch-scoped Open, Count, Handover and Close capabilities; generic Staff/Shift/Assignment grants none. | Assignees, delegation/revocation, separation, emergency behavior. |
| `ODB-CASH-14` | Post-close correction is a linked fact; closed evidence is never reopened/rewritten. | Permitted operations, initiator/approver, reason/evidence and reporting consequences. |
| `ODB-CASH-15` | Handover records outgoing/incoming actors, count, variance, reason and acknowledgement; acknowledgement is not approval; prior accountability remains; no new float is allocated. | Approval, disagreement/escalation and Session transition. |
| `P2B-CASH-OD-07` | Owner authorization is mandatory for every top-up; a separately authorized capability holder may execute an approved top-up with actor/source evidence. | Executor assignment, capability/delegation, source classes and accounting. |
| `P2B-CASH-OD-08` | Reconcile every Cash Session and Operating Day before authoritative reporting. | Unresolved-case disposition, hold/release, escalation and consequences. |

Sources: [Owner Decision Baseline Cash decisions](../architecture/after_four_owner_decision_baseline.md#wave-2-cash-owner-decisions) and [conditional directions](../architecture/after_four_owner_decision_baseline.md#wave-2-conditional-direction-and-clarification-responses).

### 5.2 Proposed boundary

Cash owns Operating Day, Cash Session, drawer movements, counts, handover/close evidence, linked corrections and reconciliation status. Payment supplies confirmed cash-settlement/refund facts but does not own the drawer ledger. Reporting consumes reconciled Cash facts and cannot mark them reconciled. Identity supplies trusted actor/capability evidence and does not decide Cash policy.

Candidate lifecycle vocabulary (`TECHNICAL_PROPOSAL` only):

```text
Operating Day: open → reconciliation_pending → reconciled | exception_open
Cash Session: open → handover_pending/close_pending → closed
```

No executable transition matrix can be approved until the handover, discrepancy and reporting-release questions in §9 are decided.

## 6. CORE-03 — Operator Identity and Authorization design

### 6.1 Boundary

This workstream proposes only the operator-access contract needed by CORE-01/02/04/05. It does not implement Identity, choose Devise/custom authentication, accept ADR-0006, implement Workforce scheduling, or authorize Milestone 2B.

### 6.2 Proposed trusted request contract

Presentation receives a server-validated Session and passes an immutable trusted identity reference to Application. Application obtains a context containing:

- actor/person and Session references;
- Organization and effective Branch scope derived server-side;
- exact operation capability and authority-source evidence;
- authentication/session validation time and correlation ID;
- step-up/MFA evidence only where separately approved and applicable.

Client-supplied actor, role, Branch, capability or generic Staff title is never authority. Missing, expired, revoked or contradictory evidence fails closed without disclosing cross-Branch resource existence. Application revalidates Session, Branch and exact capability after required business locks and before mutation. These principles align with the P1 design but do not authorize it ([P1 §§6–8](../architecture/after_four_p1_trusted_identity_authorization_design.md#6-trusted-identity-and-session-validation)).

### 6.3 Proposed capability families

Exact identifiers and assignments are unresolved; the operation separation is the design requirement:

- Catalog/menu read and Price read;
- Order draft/edit/confirm/hold;
- cash/manual-bank confirmation and exception review;
- Preparation dispatch view/accept/start/complete/exception;
- Cash Session open/count/handover/close, top-up execution and linked correction;
- operational-report read/export, separated by report/scope.

No wildcard capability, role-title inference or Branch Assignment alone authorizes these operations. Cash capability assignment must follow `ODB-CASH-13`; manual bank authority/evidence remains an Owner question.

### 6.4 Session and failure boundaries

Existing canonical Identity policy requires server sessions, revocation, Branch-scoped fail-closed authorization, POS idle lock and audit, but executable contracts and security evidence remain Milestone 2 work ([API Contract §§2.7–2.8](../architecture/after_four_api_contract.md#27-authentication-and-session-behavior)). Authentication failure returns generic safe errors; authorization failure is non-disclosing; deactivation/revocation blocks subsequent checks; every sensitive mutation retains actor/session/scope/result/reason/time evidence without credentials or secrets.

## 7. CORE-05 — Reporting source-lineage design

### 7.1 Authoritative facts and ownership

| Fact | Source owner | Available now | Reporting limitation |
|---|---|---|---|
| Order identity, Branch, channel, aggregate amount/status | Ordering | Yes | No items or authoritative calculation components. |
| Sold item/description/Price snapshot | Ordering, supplied by Catalog/Pricing at confirmation | No | Sales-by-item/Product/Variant and Price provenance unsupported. |
| Payment target/success, attempts, mismatch, late-success case | Payment | Yes | No Refund/provider reconciliation; manual-bank source is operator confirmation. |
| Preparation dispatch | Preparation handoff | Pending identity only | No accepted/start/complete/handover facts. |
| Cash movement/Session/Operating Day/reconciliation | Cash | No | Cash reports and authoritative daily close unsupported. |
| Promotion/Loyalty components | Promotions/Loyalty | No | Discount/points metrics unsupported. |
| Corrections and Refund allocation | Owning source domains | No | Net sales and corrected component reporting unsupported. |
| Actor and scope evidence | Identity/owning command | Partial Phase 1 UUID attribution only | No trusted Session/capability runtime. |

### 7.2 Reporting rules

- A report may project source facts but never become their owner or silently repair them.
- Historical reports use immutable sold/correction snapshots, not current Catalog joins.
- Cash-dependent authoritative reporting waits for required Session and Operating Day reconciliation under `P2B-CASH-OD-08`.
- Unresolved cases remain visible and cannot be treated as zero or success.
- Cutoff uses the source domain's approved time boundary; exact Cash Operating Day boundary is unresolved.
- Reprocessing is deterministic and idempotent from versioned source facts.
- Unsupported metrics must be omitted or marked unavailable, never estimated from demo/client data.
- Report read/export authorization, privacy, retention, schedule and recipients require separate decisions and Gate review.

## 8. Integrated flow, ownership and failure boundaries

| Flow | Source owner → consumer | Boundary | Failure/recovery | Unresolved dependency |
|---|---|---|---|---|
| Menu/Price → Draft | Catalog/Pricing → Ordering | Synchronous trusted Application contract proposed; no direct persistence access. | Failed/ambiguous resolution creates no accepted line; retry uses command identity. | Actual menu/Prices, sellability, tax/rounding/Service Charge. |
| Draft → Confirmed snapshots | Ordering | Single Ordering transaction proposed after Price revalidation. | Version/Price race returns conflict/requote; partial snapshots roll back. | Exact snapshot components and lock protocol. |
| Confirmed → Payment | Ordering → Payment | Existing one-Order/one-Payment foundation and exact target. | Mismatch is evidenced; unknown/provider flows remain blocked. | Manual-bank authority/evidence and Refund policy execution. |
| Payment → Dispatch | Payment → Preparation | Existing same-transaction pending Dispatch plus outbox. | Payment remains successful if later delivery fails; retry same Dispatch. | Worker/Ticket lifecycle. |
| Dispatch → Ticket completion | Preparation | Proposed asynchronous consumer under ADR-0007. | Idempotent accept; reconciliation handles missing/duplicate/out-of-order delivery. | State/cancellation/partial/handover policies. |
| Cash Payment → Cash ledger | Payment → Cash | Future explicit integration fact; not implemented. | Duplicate source fact must not duplicate drawer movement. | Session identity, movement taxonomy, Refund/correction. |
| Cash → Reporting | Cash → Reporting | Only reconciled facts authoritative. | Open exception holds affected authoritative reporting according to future policy. | Hold/release authority and cutoff. |
| Source facts → Reporting | Each domain → Reporting | Proposed asynchronous projections or bounded reads; mechanism not selected. | Replay from immutable/versioned facts; projection failure cannot mutate source. | Metrics, retention/access and correction semantics. |

Synchronous/asynchronous labels above follow current patterns only where stated. They do not select a new transport, queue topology, lock or transaction mechanism.

## 9. Consolidated Owner Decision Register

Every reference is local to this review package, `PROPOSED_NOT_APPROVED`, and is not a canonical ODB allocation.

| Reference | Owner question | Source-supported options | Recommendation | Evidence | Dependency / consequence of deferral |
|---|---|---|---|---|---|
| `CORE-OD-01` | What exact initial Product/Variant rows and actual Prices form the first Core Sale menu? | A: approve a bounded explicit launch list and Price versions; B: approve a smaller pilot subset; C: defer. Approximate bands constrain review but are not rows. | `RECOMMENDATION_NOT_ESTABLISHED`; Owner must supply/approve business input. | `ODB-CAT-11`–`13`; `docs/architecture/after_four_owner_decision_baseline.md:313-319`. | Blocks authoritative menu, calculation and CORE-01 Gate A. |
| `CORE-OD-02` | What do the approximate price bands mean? | A: fixed tiers; B: target bands permitting item-specific Prices; C: nonbinding planning examples. | B is operationally flexible but remains `NOT_APPROVED`; evidence does not establish intent. | Owner input for this milestone; no canonical Price dataset found. | Blocks Price validation and menu approval. |
| `CORE-OD-03` | What tax treatment and display apply to the bounded menu? | The repository establishes no defensible option set; qualified Tax/Accounting input must identify applicable choices. Inclusive, exclusive or not-applicable treatment must not be guessed. | `RECOMMENDATION_NOT_ESTABLISHED`. | `docs/architecture/after_four_catalog_pricing_discovery.md:61-77`; `docs/architecture/after_four_data_integrity_rules.md:114`. | Blocks final calculation/snapshot/reporting contract. |
| `CORE-OD-04` | What monetary precision and rounding policy applies, and at which boundary? | The repository establishes integer VND representation but no approved rounding option set or calculation boundary; qualified commercial/Accounting input is required. | `RECOMMENDATION_NOT_ESTABLISHED`; preserve integer VND representation pending policy. | `backend/app/models/payment.rb:10-15`; `docs/architecture/after_four_catalog_pricing_discovery.md:61-77`. | Blocks deterministic calculation and Refund allocation. |
| `CORE-OD-05` | Is Service Charge part of the first Core Sale scope? | A: explicitly exclude; B: include only after rate, basis, applicability, ownership, Tax/Refund/Reporting treatment are approved; C: defer CORE-01. | A is the narrowest acceleration option, `PROPOSED_NOT_APPROVED`. | `docs/architecture/after_four_real_menu_pricing_specification.md:112-134`; `docs/architecture/after_four_catalog_pricing_discovery.md:61-77`. | Inclusion without complete policy blocks calculation. |
| `CORE-OD-06` | What dine-in table/service context is mandatory, and what identifies takeaway? | The logical API proposes an optional `table_session_id` for dine-in and channel identity for takeaway, but no approved Table Session source/ownership or complete alternative set exists. The Owner may bound a first-slice rule or defer pending operational input. | `RECOMMENDATION_NOT_ESTABLISHED`. | `docs/architecture/after_four_api_contract.md:190-206`; `docs/architecture/after_four_business_domain_model.md:326-337`. | Blocks Order creation contract and UI. |
| `CORE-OD-07` | Beyond the confirmed cashier comparison action, what exact Branch-scoped capability assignment and evidence are required for manual bank confirmation? | `ODB-OP-09` already requires cashier comparison and explicit POS confirmation; the repository does not establish a complete assignee/delegation option set. Deferring manual bank and launching a cash-only first slice remains a narrowing option, not a policy recommendation. | Require an exact payment-confirm capability rather than a generic role title; assignees and evidence remain `NOT_APPROVED`. | `ODB-OP-07`–`09`; `docs/architecture/after_four_owner_decision_baseline.md:246-248`. | Blocks manual-bank operational use and CORE-03 mapping. |
| `CORE-OD-08` | Does Preparation permit partial item/quantity progress and partial completion in the first slice? | A: whole-ticket only; B: per-item; C: per-quantity. | A is simplest but evidence does not establish business fit; `RECOMMENDATION_NOT_ESTABLISHED`. | `docs/architecture/after_four_api_contract.md:239-250`; no executable ticket lifecycle exists. | Blocks Ticket/Item state model and UI. |
| `CORE-OD-09` | What happens when a paid Order is cancelled after Dispatch but before/during Preparation? | A: distinguish before-start vs after-start using existing authority direction; exact operational outcomes supplied separately; B: prohibit automatic completion and require exception review. | Preserve existing cancellation authority; downstream outcomes remain `RECOMMENDATION_NOT_ESTABLISHED`. | `ODB-OP-12`–`14`; `docs/architecture/after_four_owner_decision_baseline.md:251-253`. | Blocks cancellation race and reconciliation. |
| `CORE-OD-10` | What Preparation fact constitutes completion/handover, and when may Ordering close? | A: completion plus explicit handover; B: completion alone; C: another bounded fulfillment fact. | `RECOMMENDATION_NOT_ESTABLISHED`; `P1A-OD-07` is deferred. | `docs/architecture/after_four_owner_decision_baseline.md:118`; `docs/architecture/after_four_state_machines.md:128-158`. | Blocks end-to-end completion and reports. |
| `CORE-OD-11` | What exact Branch timezone/cutoff/configuration applies to Operating Day? | A: one chain configuration; B: Branch-specific; both require exceptional-day policy. | `RECOMMENDATION_NOT_ESTABLISHED`; preserve `ODB-CASH-12`. | `docs/architecture/after_four_owner_decision_baseline.md:137`. | Blocks Cash lifecycle and cutoff reporting. |
| `CORE-OD-12` | Who receives each Cash Open/Count/Handover/Close capability and how are delegation/separation handled? | Candidate assignments require Owner/organizational input; generic Staff/Shift/Assignment is invalid. | `RECOMMENDATION_NOT_ESTABLISHED`. | `ODB-CASH-13`; `docs/architecture/after_four_owner_decision_baseline.md:138`. | Blocks Cash execution and CORE-03 mapping. |
| `CORE-OD-13` | Which linked post-close correction operations exist and who initiates/approves them? | Source evidence does not establish a complete option set. | `RECOMMENDATION_NOT_ESTABLISHED`; do not invent authority. | `ODB-CASH-14`; `docs/architecture/after_four_owner_decision_baseline.md:139`. | Blocks Cash correction and Reporting consequences. |
| `CORE-OD-14` | What approval, disagreement and Session transition follows Cash handover? | A: separate close; B: controlled automatic close; C: another reviewed transition; approval authority separate from acknowledgement. | `RECOMMENDATION_NOT_ESTABLISHED`. | `ODB-CASH-15`; `docs/architecture/after_four_owner_decision_baseline.md:140`. | Blocks Cash Session state machine. |
| `CORE-OD-15` | How are nonzero discrepancies resolved, and who holds/releases authoritative reporting? | All remain recorded/reasoned/Owner-notified; candidate classes/authority require Cash/Accounting/Reporting evidence. | `RECOMMENDATION_NOT_ESTABLISHED`. | `ODB-CASH-07`; `P2B-CASH-OD-03`; `P2B-CASH-OD-08`; `docs/architecture/after_four_owner_decision_baseline.md:176,204,269`. | Blocks reconciliation terminal outcomes and reports. |
| `CORE-OD-16` | What minimum operational report set, scope, cutoff and recipients are required first? | A: sales/payment/preparation/cash exception minimum; B: narrower transaction/reconciliation evidence only; C: defer operational reports. | A is useful but source facts are incomplete; `NOT_APPROVED`. | `ODB-RPT-01`–`05`; `docs/architecture/after_four_owner_decision_baseline.md:282-292`. | Defines CORE-05 Gate A scope; Cash-dependent reports remain blocked. |

No question asks the Owner to reapprove existing policy. Choices narrow only the unresolved portions identified in canonical sources.

## 10. Dependency and Gate A readiness matrix

| Workstream | Design completeness | Owner-policy closure | External/qualified input | Gate A readiness | Next gate |
|---|---|---|---|---|---|
| CORE-01 Core Sale | Bounded architecture and failure contract prepared | `CORE-OD-01`–`07` unresolved | Tax/Accounting input needed for tax/rounding; actual menu input needed | `NOT_READY — OWNER_INPUT_REQUIRED` | Resolve inputs, independent review, then request exact Gate A. |
| CORE-02 Preparation | Boundary, candidate lifecycle and evidence plan prepared | `CORE-OD-08`–`10` unresolved; `P1A-OD-07` deferred | Operational Preparation input needed | `NOT_READY — OWNER_POLICY_REQUIRED` | Close policy and review design. |
| CORE-04 Cash | Approved policy reconciled; ownership/lifecycle skeleton prepared | `CORE-OD-11`–`15` unresolved | Cash/Accounting/Reporting input needed | `NOT_READY — POLICY_AND_EVIDENCE_REQUIRED` | Close policy before Gate A. |
| CORE-03 Operator access | Bounded trust/capability contract prepared | Assignments and bank/Cash authority unresolved | Security evidence and ADR-0006/Milestone governance required | `NOT_READY — IDENTITY MILESTONE UNAUTHORIZED` | Separate Identity Gate A and Gate B. |
| CORE-05 Reporting | Source-lineage rules prepared | `CORE-OD-16` unresolved | Upstream source facts and retention/access input needed | `NOT_READY — UPSTREAM_DEPENDENCIES` | Review only the bounded lineage baseline; implementation later. |

No Gate A is granted. A future request must pin an exact reviewed commit/document set and preserve all exclusions. Gate B remains a separate exact manifest and Owner decision.

## 11. Critical path and parallel execution plan

### Critical path

1. Decide `CORE-OD-01`–`07` and obtain actual menu/qualified commercial input.
2. Independently review CORE-01; request bounded Gate A.
3. After Gate A only, prepare an exact Gate B manifest for Catalog/Pricing reads, Order Items/snapshots/calculation, API endpoints and POS integration while preserving Phase 1 Payment/Dispatch.
4. In parallel with step 1–3, close CORE-02 Preparation and CORE-03 operator-access prerequisites; neither implementation may start without its own Gate B.
5. Implement Preparation execution only after its Gate A/B; then close end-to-end Order completion.
6. Close and authorize CORE-04 Cash before claiming usable full-day café operations.
7. Implement CORE-05 Reporting only from stabilized authoritative facts and approved reconciliation rules.

### Parallel preparation

| Lane | Work now | Exit condition before implementation |
|---|---|---|
| A — Core Sale | Menu/Price evidence, Owner ballot, independent design review, Gate A request | Gate A approval plus exact Gate B authorization. |
| B — Preparation | Operational scenarios and `CORE-OD-08`–`10` review | Approved lifecycle/closure policy, Gate A and Gate B. |
| C — Operator access | Exact capability/Session manifest and security review preparation | Applicable Identity Gate A/B; ADR-0006 status unchanged unless separately decided. |
| D — Cash | Cash/Accounting/Reporting evidence and `CORE-OD-11`–`15` review | Policy closure, Gate A and Gate B. |
| E — Reporting | Metric/source lineage and `CORE-OD-16` review | Upstream facts, access/retention policy, Gate A and Gate B. |

Promotion/Loyalty policy closure may continue outside this package but must not enter CORE-01 calculation until its formulas, ordering, allocation and authorization receive separate approval.

## 12. Inventory deferral

This milestone excludes stock management, purchasing/suppliers, transfers, Recipe-based automatic deduction, stocktake/waste, and batch/lot/expiry. No Order, Payment, Dispatch, Ticket completion or report in this package may require Inventory availability, mutation or success.

Future integration remains possible through explicit facts owned by Ordering/Preparation and separately consumed by Inventory. Do not place stock columns, stock guards, Recipe calculations or Inventory callbacks inside Ordering, Payment or Preparation. Future Inventory failure cannot rewrite confirmed sold snapshots or successful Payment.

## 13. Owner Review Package

The recommended consolidated review sequence is:

1. Review `CORE-OD-01`, `02`, `05`, `06`, `07` together to bound the first commercial slice.
2. Obtain qualified input, then review `CORE-OD-03` and `04`; do not approve technical calculation around missing tax/rounding policy.
3. Review `CORE-OD-08`–`10` together for Preparation/Order completion.
4. Review `CORE-OD-11`–`15` together while keeping each answer independently selectable.
5. Review `CORE-OD-16` after the authoritative source set is agreed.

For every row the Owner may `APPROVE` one option, `DEFER`, or `APPROVE_WITH_WRITTEN_CONDITION`. A directional selection records business policy only. It does not accept this technical design, grant Gate A, authorize Gate B preparation where otherwise prohibited, authorize implementation, or grant FOA/Production Authorization.

## 14. Validation and final boundary

This package introduces no canonical ID, Owner decision, schema, migration, constraint, code, test, dependency, API, runtime behavior, database operation, external contact, disclosure, commissioning, Gate, Control Acceptance, FOA or Production Authorization.

Current classifications remain:

- Catalog Package B and Order/Payment Phase 1: merged bounded foundations, not authority for new work;
- Identity I1: Gate A/B/C approved only for ancestry;
- Identity Milestone 2B: unauthorized;
- CORE-01/02/03/04/05: design proposals requiring Owner decisions and applicable Gate A/B;
- Inventory: deferred from this milestone, with future boundaries preserved.

**Final status:** `CONSOLIDATED_DESIGN_PACKAGE_PREPARED — ZERO GATES_GRANTED — ZERO IMPLEMENTATION_AUTHORIZED — OWNER_REVIEW_REQUIRED`.
