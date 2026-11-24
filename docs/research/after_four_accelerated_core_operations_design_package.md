# AFTER FOUR — Accelerated Core Operations Design Package

**Package status:** `OWNER_REVIEW_RECORDED — CORE_01_READY_FOR_INDEPENDENT_GATE_A_REVIEW — NOT_READY_FOR_GATE_A_APPROVAL`

**Repository baseline:** `main` / `origin/main` at `d1d8807faa1234fc7924bd522fa26363d1e3a414`

**Evidence cutoff:** 2026-11-24 (Asia/Tokyo)

**Implementation authorization:** `NOT_GRANTED`

## 1. Purpose, authority and classifications

This package consolidates five bounded Core Operations workstreams and the Owner review recorded on 2026-11-24. It follows the [Accelerated Core Operations Readiness Assessment](after_four_accelerated_core_operations_readiness_assessment.md), preserves the canonical [Owner Decision Baseline](../architecture/after_four_owner_decision_baseline.md), and follows accepted [ADR-0011 Layered DDD](../architecture/adr/0011-project-wide-layered-ddd.md).

The Owner confirmed `CORE-OD-01` on 2026-11-24: dine-in plus takeaway, the detailed draft menu/options approved by reference to [Proposed Launch Menu v3](../architecture/after_four_proposed_launch_menu_v3.md), and approximate selling-price directions of VND 23,000, VND 33,000 and VND 43,000–49,000. The repository does not contain an exact Product/Variant-to-Price mapping, so the bands are not exact SKU Prices and must not be used as one. `CORE-OD-01` is recorded with `ID_PENDING_OWNER_GOVERNANCE`; it does not rewrite the narrower scopes of `ODB-CAT-11`–`ODB-CAT-13` ([Owner Decision Baseline §5](../architecture/after_four_owner_decision_baseline.md#5-catalogpricing-mvp)). Inventory deferral, parallel design preparation and consolidated review remain task boundaries.

Classifications used here:

| Classification | Meaning |
|---|---|
| `OWNER_CONFIRMED` | Exact policy recorded in the canonical Owner Decision Baseline. |
| `OWNER_CONFIRMED_BY_REFERENCE` | Owner-approved content identified by an exact repository artifact, with missing transcription/data gaps stated explicitly. |
| `OWNER_DEFERRED — OWNER_INPUT_REQUIRED` | Owner explicitly left the policy unresolved; no recommendation or implementation exclusion converts it into approved policy. |
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
  → exact-balance cash confirmation
  → existing unique pending Preparation Dispatch
```

Exact-balance cash is the Owner-confirmed bounded first-slice payment path under `CORE-OD-07`. The merged Phase 1 manual-bank command remains historical implementation evidence, but manual-bank confirmation is excluded from the initial implementation scope. This is not a permanent rejection: reconsideration requires separate closure of the Branch-scoped capability and evidence prerequisites and their applicable authorization.

Inventory, Customer association, Promotions, Loyalty, Refund execution, electronic-provider integration, kitchen execution, Cash Session posting and Reporting projections are excluded. Anonymous/unregistered Orders remain allowed under `SDP-CUST-19`.

### 3.2 Commercial baseline and evidence boundary

| Fact | Classification | Exact scope | Remaining gap |
|---|---|---|---|
| Product/Variant/Price rules | `OWNER_CONFIRMED` | `ODB-CAT-01`–`10`: Brand-global Product, persisted Variant, Branch availability/Price scope, immutable effective-dated Prices, explicit revised-quote review and immutable sold Price. | Runtime Pricing and Order Items do not exist. |
| Launch scale, selective sizes and Signature designations | `OWNER_CONFIRMED` | `ODB-CAT-11`–`13`. | These older decisions do not themselves approve individual rows or Prices. |
| Draft launch menu and channels | `OWNER_CONFIRMED_BY_REFERENCE` | `CORE-OD-01` accepts the 28 named rows, six menu groupings, presented option labels, and dine-in/takeaway scope in [Proposed Launch Menu v3](../architecture/after_four_proposed_launch_menu_v3.md). | Canonical codes, exact persisted records, final Variant applicability/capacity and operational table/service contract remain unresolved. |
| Pricing direction | `OWNER_CONFIRMED_BY_REFERENCE` | Approximate entry/mid/premium directions: VND 23,000 / 33,000 / 43,000–49,000. | No repository artifact maps an individual Product/Variant to an exact amount or tier. POS demo fixtures are not authority. |
| Commercial components | Mixed: `OWNER_CONFIRMED` / `OWNER_DEFERRED — OWNER_INPUT_REQUIRED` | `CORE-OD-05` excludes Service Charge, `CORE-OD-17A/B` exclude price-changing Modifiers and complimentary/zero-price items, and `CORE-OD-17C` prohibits direct operator sold-price override in the initial slice. Tax and rounding remain deferred under `CORE-OD-03/04`. | Qualified tax/rounding input and exact Product/Variant Price transcription still block Gate A approval of an executable calculation baseline. |

The located menu artifact is sufficient to review domain boundaries, but not to create Price rows or an implementation manifest containing seed data. A frozen transcription of exact Product/Variant records and Prices is required before Gate B; this is an evidence gap, not a request to reapprove the menu.

### 3.3 Layered DDD responsibilities

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

### 3.4 Proposed logical contracts and data ownership

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

The logical chain is intentionally not a physical schema:

```text
Catalog/Pricing-owned Product + Variant + effective Price Version
  → ResolvedMenuItem / ResolvedPrice fact
  → Ordering-owned DraftOrderItem quote binding
  → Ordering-owned ConfirmedOrderItemSnapshot
  → Payment-owned exact target amount
```

Catalog/Pricing owns current sellability and Price history. Ordering owns Draft bindings, calculation and sold snapshots. Payment consumes only the confirmed target and never re-resolves commercial terms. Infrastructure may later persist these facts only under Gate B; no table, index or lock is selected here.

Candidate Application/API operations are `ResolveEffectiveMenu`, `AddDraftItem`, `ChangeDraftItemSelection`, `ChangeDraftItemQuantity`, `RemoveDraftItem`, `RequoteDraft`, `AcceptRevisedQuote`, and `ConfirmOrder`. Presentation supplies identifiers, quantities, notes, expected versions and idempotency identities; it never supplies an authoritative Price, component amount or total. Exact routes, DTO names and error codes remain Gate B candidates.

CORE-01 invariants are:

- every accepted Draft line names one persisted Variant and one bound Price Version;
- all accepted amounts are calculated server-side from trusted facts;
- unrelated Draft mutation cannot silently replace a Price binding;
- revised commercial terms require explicit review before confirmation;
- confirmation creates a complete immutable sold snapshot set or creates none;
- confirmed totals alone establish the Payment target; Payment never edits Order calculation;
- Branch/Brand mismatch fails closed without cross-scope disclosure; and
- Inventory, Promotion and Loyalty availability cannot gate, reverse or rewrite this initial sale slice.

### 3.5 Draft, calculation and confirmation

- Draft permits item add/update/remove against an expected Order version.
- Adding a line resolves one authoritative Price version and binds the Draft line to that exact Price-version reference, unit Price, scope and resolution instant. The binding is Draft quote evidence, not yet the immutable sold snapshot.
- Quantity, note or another unrelated Draft mutation recalculates from the line's existing bound Price version. It must not silently replace that binding merely because a newer Price is now effective.
- Changing the selected Product/Variant is a new commercial selection and resolves a new authoritative Price binding for that line.
- An explicit re-quote/revalidation operation resolves current authoritative facts for all affected lines. If any Price differs, it returns a revised quote identifying changed lines and marks that quote as requiring explicit review; it does not silently confirm or overwrite sold history.
- The server returns the calculated result, every bound Price-version reference and a Draft/revalidation version; the client displays but does not author them.
- Confirmation locks/revalidates the Order and affected authoritative Price facts using a separately reviewed concurrency protocol.
- If a bound Price is no longer the authoritative Price at confirmation, confirmation does not succeed. It returns or creates a revised quote, and a separate explicit operator review/acceptance of that revision is required before a later confirmation attempt (`ODB-CAT-09`).
- Successful confirmation freezes sold snapshots and opens the existing Payment window atomically.
- Confirmed items and amounts are immutable; later correction/cancellation uses linked facts and approved workflows, never overwrite.

The exact re-quote command shape, review token, lock order, database isolation and Price-publication race mechanism remain `TECHNICAL_PROPOSAL` pending Gate A review and Gate B authorization. The semantic requirement is stable: unrelated Draft edits never silently reprice, explicit revalidation exposes every changed commercial term, and confirmation cannot bypass the required review.

The current `Orders::CreateDraft` accepts `total_amount` from its caller (`backend/app/domains/orders/create_draft.rb:7-27`). `CORE-01` must replace that trust boundary for the public operational flow; it must not silently change the existing command before Gate B approval.

```text
Operator selects Product/Variant and Branch
  → Ordering Application asks Catalog/Pricing Application for an authoritative quote
  → Draft line binds the returned Price Version
  → unrelated edits retain that binding
  → explicit re-quote returns changed lines, if any
  → operator explicitly accepts the revised quote
  → confirmation revalidates sellability, Branch and Price
  → Ordering atomically freezes sold snapshots and confirmed total
  → existing Payment flow receives that exact target
```

### 3.6 Monetary sequence and precision

Existing Phase 1 uses integer VND fields and exact equality (`backend/app/models/payment.rb:10-15`; `backend/app/domains/payments/confirm.rb:126-135`). The following is the narrow proposed skeleton, not an approved calculation policy:

1. resolve authoritative unit Price for every line;
2. multiply unit Price by positive integer quantity using checked integer arithmetic;
3. apply only separately approved commercial components in an Owner-approved order;
4. apply approved rounding at the approved boundary;
5. sum authoritative line/order components to one exact Payment target;
6. persist component provenance and calculation version before confirmation commits.

Tax treatment and rounding remain `OWNER_DEFERRED — OWNER_INPUT_REQUIRED`. Service Charge, price-changing Modifiers and complimentary/zero-price behavior are excluded from the initial slice; direct operator-entered sold-price override is prohibited. Promotion/Loyalty and any future component order remain outside this slice. Gate A cannot approve an executable calculation contract until the applicable deferred inputs and exact Price transcription are resolved.

### 3.7 Payment and dispatch boundaries

- The bounded first slice confirms only exact target amount and currency through the existing cash command.
- The existing manual-bank command and evidence remain unchanged, but `CORE-OD-07` excludes manual bank from the initial scope. Reconsideration requires separately governed Branch-scoped capability and evidence prerequisites; an alert/speaker is not authoritative bank evidence ([API Contract §6.2](../architecture/after_four_api_contract.md#62-payment-commands)).
- Reuse current Payment lock, attempt idempotency and mismatch evidence.
- Successful eligible settlement, Payment aggregate update, pending Dispatch, Outbox Event and audit commit together (`backend/app/domains/payments/confirm.rb:40-98,177-234`).
- Dispatch delivery and kitchen ticket creation are `CORE-02`, not `CORE-01`.
- Held/Expired late success records a review case and never automatically dispatches.

### 3.8 Failure, retry and concurrency acceptance matrix

| Scenario | Required outcome | Current evidence / remaining design |
|---|---|---|
| Same command identity and same input | Return original result; no duplicate Order, Payment, item or Dispatch. | Phase 1 covers Order/Payment replay; Order Item/API behavior requires future tests. |
| Same identity, different input | Stable idempotency conflict. | Implemented for draft/payment foundations; extend only after Gate B. |
| Price changes while unrelated Draft fields are edited | Preserve the line's bound Price version; do not silently reprice. Explicit re-quote may propose a replacement binding. | Policy `ODB-CAT-09`; re-quote/review and lock/token mechanisms unresolved. |
| Confirmation finds a newer authoritative Price | Do not confirm. Return/create the revised quote, identify changed lines and require explicit review before a later confirmation attempt. | `ODB-CAT-09`; concurrency mechanism remains proposed. |
| Product/Variant becomes unsellable or is deactivated while Draft | Retain historical Draft evidence, fail confirmation closed and return a safe affected-line result requiring removal or another explicit operator choice; never substitute a Product/Variant. | Catalog lifecycle is authoritative; exact error/recovery UX remains proposed. |
| Explicit re-quote after Price change | Return one internally consistent revised quote and changed-line set; acceptance is a separate versioned action. | Review requirement is `ODB-CAT-09`; command/token design remains proposed. |
| Request Branch differs from the persisted Order or resolved Catalog target | Reject without mutation and without disclosing out-of-scope Catalog facts. | Trusted target and cross-Brand/Branch authorization depend on separately governed Identity/Application contracts. |
| Concurrent line edits | One accepted version; stale writer receives conflict and safe current version. | `TECHNICAL_PROPOSAL`; deterministic concurrency tests required. |
| Confirmation races Price publication | Either confirmed snapshot binds the old still-effective version valid at the linearization point, or confirmation fails/requotes; never a mixed snapshot. | Transaction/lock protocol unresolved. |
| Any calculated component or sold snapshot fails to persist | No partial confirmation, Payment target or mixed snapshot survives; the complete confirmation mutation rolls back. | Existing commands use transactions; new item/snapshot evidence needs failure injection. |
| Payment mismatch | Record safe mismatch evidence; do not settle or dispatch. | Implemented/test artifacts exist. |
| Payment result is ambiguous or provider-originated | Do not treat it as success, retry blindly or dispatch. Preserve the local attempt outcome and route through separately approved reconciliation. | Provider notification/query handling is absent and excluded; current local exact-balance commands are not provider adapters. |
| Commit succeeds, response is lost | Retry returns committed result without duplicate charge/dispatch. | Phase 1 idempotency pattern exists; API evidence required. |
| Successful Payment followed by dispatch/outbox delivery failure | Payment stays authoritative; the same pending Dispatch/Outbox identity remains recoverable without recharging or creating a second Dispatch. | Pending dispatch/retry exists; worker acceptance is CORE-02. |

### 3.9 Gate B candidate manifest and acceptance evidence

This is a candidate manifest for later review, not Gate B authorization:

| Area | Candidate future scope | Required acceptance evidence |
|---|---|---|
| Catalog/Pricing Application | Authoritative menu/effective-Price query contract and Infrastructure adapter; no lifecycle write expansion. | Effective-date/scope resolution, Branch mismatch, unsellable/deactivated Variant and no Active Record leakage tests. |
| Ordering Domain/Application | Order Items, Draft quote binding, server calculation, explicit re-quote/review and confirmed sold snapshots. | Unit/state tests, idempotency conflicts, no-silent-repricing, atomic rollback and Price-publication race tests. |
| Presentation/API | Bounded menu read, Draft item mutation, re-quote review and confirm endpoints with stable errors. | Request trust-boundary, concurrency token, non-disclosure and response-loss/retry contract tests. |
| Logical persistence | Price-version binding, Order Item and immutable snapshot facts required by the approved logical model. | Fresh/upgrade/rollback design, constraints, transaction/concurrency proof and schema diff review; exact objects require Gate B. |
| Payment/Dispatch integration | Adapt the confirmed authoritative total into the existing Phase 1 exact-cash boundary without changing financial truth. Under confirmed `CORE-OD-07`, manual-bank integration is excluded pending separate Branch-scoped capability/evidence prerequisites. | Exact-cash target, mismatch, replay, late-success, dispatch uniqueness and failure-injection evidence; separate manual-bank evidence only if later authorized. |
| POS integration | Replace demo/client-authoritative totals only after the backend contract exists. | Type/lint/build plus focused interaction/error/re-quote tests under a separately approved manifest. |

Candidate future source areas include `backend/app/domains/catalog/`, `backend/app/domains/orders/`, bounded Presentation adapters/routes, focused specs under `backend/spec/`, and the corresponding POS feature integration. Exact files, migrations and database objects must be enumerated in a later Gate B request; this package authorizes none of them.

## 4. CORE-02 — Preparation lifecycle bounded design

### 4.1 Existing versus proposed

`IMPLEMENTED_BEHAVIOR`: a fully settled eligible Order owns at most one `PreparationDispatch`, currently with business states `pending` and `dispatched`. The settlement transaction also writes one Outbox Event, whose delivery states are independently `pending` and `published`. Retry requeues that same Outbox Event. `preparation_dispatch_attempts` exists but has no Phase 1 writer ([Order/Payment Phase 1 §§2 and 7](../architecture/after_four_order_payment_implementation_phase1.md#2-implemented-records-and-states); `backend/app/models/outbox_event.rb:1-5`; `backend/app/models/preparation_dispatch.rb:1-8`).

`TECHNICAL_PROPOSAL`: a future consumer accepts that Dispatch idempotently and establishes one Preparation Ticket with immutable Order/sold-item references. It never changes Payment truth. Outbox `published` means only that delivery publication completed; it is not Ticket acceptance, Preparation start or business completion.

### 4.2 Candidate state model

The three state axes remain distinct:

```text
PreparationDispatch business state: pending → dispatched
Outbox delivery state: pending → published
Preparation Ticket execution state (proposal): queued → in_progress → completed
                                                    ↘ cancellation_or_exception_review
```

Outbox delivery never substitutes for Dispatch or Ticket state. `PreparationDispatch.dispatched` may be recorded only after the idempotent acceptance outcome has established or located the one Ticket for that Dispatch; the exact persistence/transport mechanism remains unselected. Rejected ticket semantics, progress granularity, partial completion/handover, cancellation after dispatch, remake/deviation and terminal failure remain Owner decisions. A generic mutable status endpoint is prohibited; named commands request transitions.

```text
delivery carries existing Dispatch identity
  → consumer checks prior acceptance result
  → if absent, establish Ticket + Items + durable acceptance as one semantic outcome
  → if already accepted, return the same Ticket identity
  → response loss retries the same Dispatch identity
  → reconciliation detects pending Dispatch/no Ticket or Ticket/missing acceptance evidence
```

This sequence states semantic recovery only. It selects no broker, worker, lease, index, transaction isolation, storage object or deployment topology.

### 4.3 Proposed responsibilities and invariants

- Preparation owns Ticket/Item execution state; Ordering owns Order commercial state; Payment owns settlement.
- Dispatch acceptance is idempotent by the existing Dispatch identity. The first accepted delivery establishes the single Ticket identity; duplicate or out-of-order deliveries return/locate that same acceptance result.
- Ticket establishment and durable Dispatch-acceptance evidence form one semantic success boundary. A failure before that boundary leaves the Dispatch pending/retryable; a response loss after success is recovered by locating the existing result.
- A retry or redelivery cannot create a second Ticket or duplicate Ticket Items. This is an acceptance invariant, not a selected index, transaction, worker or transport implementation.
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

### 4.5 Cancellation and completion decision axes

Cancellation policy evaluates each operational stage without collapsing request authority, approval authority, Preparation consequence, Ordering consequence/closure, Refund consequence or required evidence. Existing authority is preserved: Staff may cancel with reason before Preparation starts; after Preparation starts, Owner approval is required; completed Orders use a separate exception process (`ODB-OP-12`–`14`). `CORE-OD-09A`–`09D` confirm the consequences below; they authorize neither a cancellation implementation nor Refund execution.

| Observed stage | Request / authorization boundary | Preparation consequence | Ordering / closure consequence | Refund consequence | Required evidence |
|---|---|---|---|---|---|
| Paid, Dispatch not created | Staff may cancel with reason only while a race-safe check proves Preparation has not started. | Block future Dispatch; exact fence remains technical. | Record a paid-Order cancellation fact; never infer closure. | Cancellation neither authorizes nor executes Refund; amount/method/authority remain separate. | Actor, Branch, reason, Order/Payment state, authoritative absence of Dispatch/start, idempotency and audit identity. |
| Dispatched, Ticket not started | Staff authority applies only if an atomic Preparation-state fence proves no start. | Record Ticket cancellation and preserve Dispatch/Ticket evidence; exact mechanics remain technical. | Record cancellation or exception outcome; never infer closure. | Cancellation neither authorizes nor executes Refund. | Above evidence plus Dispatch/Ticket identity and fenced no-start version. |
| Ticket in progress | Owner approval is mandatory; requester identity remains separately governed. | Preserve work and route to exception handling; do not silently delete it. | Preserve confirmed history and record linked cancellation/exception facts; never infer closure. | Amount, allocation, method and authority remain separate. | Requester, approver, reason, stage/version, completed/remaining work and immutable audit evidence. |
| Preparation completed, not handed over | After-start Owner approval applies; completed-Order exception authority may additionally apply depending on Ordering state. | Preserve completion and custody evidence and route to exception handling. | Completion does not prove handover or terminal closure. | Cancellation neither authorizes nor executes Refund. | Completion evidence, absence of handover, requester/approval/reason and linked exception evidence. |
| Handed over | If terminally completed, `ODB-OP-14` requires the separate exception process; otherwise after-start Owner approval still cannot be bypassed. | Preserve immutable completion/handover evidence. | No reopening or automatic closure follows from cancellation. | Post-fulfillment Refund/remedy remains separately governed. | Completion/handover facts, current Order state, requester/approval/reason and linked exception evidence. |

Preparation completion, customer handover and terminal Order closure are three separate facts. The Owner must decide the completion and handover semantics; Ordering closure remains separately governed and cannot be derived automatically from either one.

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

Expected Cash and counted Cash are separate facts. The proposed expected balance is derived from the approved Opening/Daily Float evidence plus immutable Cash movements and separately authorized linked corrections; actual Cash is independently counted. Closing records expected amount, actual amount, variance, actor and evidence without rewriting any source movement.

The following movement taxonomy is source-grounded design vocabulary, not approved operations or posting contracts:

| Candidate movement | Source owner / input | Boundary |
|---|---|---|
| Cash sale inflow | Payment supplies an authoritative cash-settlement fact; Cash owns the drawer movement. | Payment success is not itself a mutable drawer balance. |
| Cash Refund outflow | Payment/Refund supplies a separately authorized Refund fact. | No Refund implementation or authority is approved here. |
| Float/top-up funding | Cash owns the linked funding movement. | Top-up is never revenue and requires prior Owner authorization under existing policy. |
| Expense outflow | Expense supplies an approved/executed Expense fact; Cash owns the movement. | Expense policy and Cash posting remain distinct. |
| Linked correction | Cash owns a separately attributable correction fact under `ODB-CASH-14`. | Closed evidence is never reopened; exact operations and authority remain unresolved. |

### 5.3 Independent Cash decision dimensions

- **Handover evidence and acknowledgement:** `ODB-CASH-15` already requires outgoing actor, incoming actor, count, variance, reason and acknowledgement. Acknowledgement confirms receipt/participation evidence only and is never approval.
- **Approval/disagreement:** disagreement/refusal escalates to Owner under `CORE-OD-14A`; detailed resolution remains unresolved. Authority must not be inferred from acknowledgement or generic Staff status.
- **Cash Session transition:** acknowledgement does not close the outgoing Session. `CORE-OD-14B` requires a separate Close action with its corresponding capability; capability assignment remains deferred under `CORE-OD-12`.
- **Discrepancy investigation/resolution:** every nonzero discrepancy remains recorded, reasoned and Owner-notified with no tolerance. Investigation classes, linked-correction operations and resolution authority remain unresolved.
- **Reporting hold/release:** `P2B-CASH-OD-08` already makes reconciliation a prerequisite, so unreconciled facts are not eligible for authoritative reporting. Unresolved-case disposition, escalation, any exception treatment and release authority remain separate Reporting/Cash policy questions. Resolution does not automatically grant report-release authority.

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
- exact-cash confirmation and exception review; manual-bank capability remains conditional on `CORE-OD-07` and separate Identity authorization;
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

### 7.3 Independent Reporting review dimensions

The first report review must answer independently:

1. metrics and authoritative source facts;
2. report-read capability and Branch/Organization scope;
3. whether export exists and its separate export capability/evidence;
4. delivery recipients/channel/schedule;
5. reporting cutoff and relationship to Cash Operating Day reconciliation; and
6. retention, disposal and any legal hold.

Approval of metrics does not grant read, export or recipient authority. Approval of read access does not authorize export or automatic delivery. No current CORE decision supplies these permissions.

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

`CORE-OD-01` remains approved by reference and `CORE-OD-02` remains retired without allocation. The Owner completed the consolidated review on 2026-11-24: 27 of the 34 local references below are `OWNER_CONFIRMED`, while seven are `OWNER_DEFERRED — OWNER_INPUT_REQUIRED`. Every reference remains local with `ID_PENDING_OWNER_GOVERNANCE`; no canonical `ODB-*` ID is allocated or reserved. Recorded business-policy outcomes do not approve this technical design or grant any Gate or implementation authority.

| Reference | Owner question | Recorded policy / remaining boundary | Owner status | Evidence | Dependency / consequence |
|---|---|---|---|---|---|
| `CORE-OD-03` | What tax treatment and display apply to the bounded menu? | Tax treatment/display remains unresolved pending qualified Tax/Accounting input; no treatment may be guessed. | `OWNER_DEFERRED — OWNER_INPUT_REQUIRED` | `docs/architecture/after_four_catalog_pricing_discovery.md:61-77`; `docs/architecture/after_four_data_integrity_rules.md:114`. | Blocks final calculation/snapshot/reporting contract. |
| `CORE-OD-04` | What monetary precision and rounding policy applies, and at which boundary? | Precision/rounding policy and boundary remain unresolved pending qualified commercial/Accounting input. Preserve integer VND representation; do not invent rounding. | `OWNER_DEFERRED — OWNER_INPUT_REQUIRED` | `backend/app/models/payment.rb:10-15`; `docs/architecture/after_four_catalog_pricing_discovery.md:61-77`. | Blocks deterministic calculation and Refund allocation. |
| `CORE-OD-05` | Is Service Charge part of the first Core Sale scope? | Exclude Service Charge from the initial Core Sale slice; future Service Charge policy remains separate. | `OWNER_CONFIRMED` | `docs/architecture/after_four_real_menu_pricing_specification.md:112-134`; `docs/architecture/after_four_catalog_pricing_discovery.md:61-77`. | Nonblocking for the initial slice because it is excluded. |
| `CORE-OD-06` | What dine-in table/service context is mandatory, and what identifies takeaway? | Require explicit `dine_in` or `takeaway` channel identity. Table Session is not mandatory for initial Order creation and remains separately scoped. | `OWNER_CONFIRMED` | `docs/architecture/after_four_api_contract.md:190-206`; `docs/architecture/after_four_business_domain_model.md:326-337`. | Closes the initial channel contract without approving Table Session behavior. |
| `CORE-OD-07` | What is the initial payment path, and when may manual bank be reconsidered? | Initial implementation is exact-balance cash only. Manual bank is excluded, not permanently rejected; reconsider only after separate Branch-scoped capability and evidence prerequisites resolve. | `OWNER_CONFIRMED` | `ODB-OP-07`–`09`; `docs/architecture/after_four_owner_decision_baseline.md`. | Does not block cash-only review; manual bank and CORE-03/Identity authority remain outside scope. |
| `CORE-OD-17A` | May a Modifier change Price in the first Core Sale slice? | Exclude price-changing Modifiers from the initial slice; displayed menu options are not thereby approved as price-neutral. | `OWNER_CONFIRMED` | `ODB-CAT-05`; Proposed Launch Menu v3 §8; Catalog/Pricing discovery. | Nonblocking for the initial slice; future Modifier pricing remains separate. |
| `CORE-OD-17B` | Are complimentary or zero-price Order Items allowed in the first slice? | Exclude complimentary and zero-price Order Items from the initial slice. | `OWNER_CONFIRMED` | Owner baseline unresolved-policy boundary. | Nonblocking for the initial slice; future policy remains separate. |
| `CORE-OD-17C` | May an operator manually override the authoritative sold Price? | Prohibit direct operator-entered sold-price override; use published Price Versions and preserve Branch Price Version policy. | `OWNER_CONFIRMED` | `ODB-CAT-07`–`10`. | Closes the initial override boundary without selecting implementation controls. |
| `CORE-OD-08A` | At what granularity is Preparation progress recorded? | Record progress at Order Item level; quantity-level progress is excluded from the initial slice. | `OWNER_CONFIRMED` | `docs/architecture/after_four_api_contract.md:239-250`; no executable ticket lifecycle exists. | Defines semantic granularity; no implementation follows. |
| `CORE-OD-08B` | May a Ticket become partially complete? | No partial Ticket completion; every required item must complete. | `OWNER_CONFIRMED` | Same Preparation sources; no current implementation evidence. | Defines completion policy at the approved granularity. |
| `CORE-OD-08C` | May completed work be partially handed over to the customer? | No partial Ticket handover; handover follows whole-Ticket completion. | `OWNER_CONFIRMED` | `docs/architecture/after_four_business_domain_model.md:324-352`. | Defines handover policy without implementation authority. |
| `CORE-OD-09A` | What cancellation authority applies across Preparation stages? | Preserve `ODB-OP-12`–`14`: Staff authority before Preparation starts, Owner approval after start, and separate completed-Order exception handling. No automatic cancellation. | `OWNER_CONFIRMED` | §4.5; `docs/architecture/after_four_owner_decision_baseline.md`. | Preserves authority; does not implement cancellation. |
| `CORE-OD-09B` | What Preparation consequence applies at each cancellation stage? | Before Dispatch, block Dispatch; dispatched-not-started records Ticket cancellation; in progress preserves work and routes to exception handling; completed or handed-over preserves evidence. | `OWNER_CONFIRMED` | §4.5; `docs/architecture/after_four_api_contract.md:229-250`. | Defines stage consequences without selecting workflow mechanics. |
| `CORE-OD-09C` | What Ordering state or exception fact applies at each cancellation stage? | Cancellation, hold/exception and Order completion remain distinct; cancellation does not automatically close an Order. | `OWNER_CONFIRMED` | §4.5; `P1A-OD-04`, `05`, `07` in the Owner baseline. | Technical state machine and exception handling still need review. |
| `CORE-OD-09D` | What Refund consequence and authority follows cancellation? | Cancellation neither authorizes nor executes Refund. Refund amount, allocation, method, authority and workflow remain separately governed. | `OWNER_CONFIRMED` | §4.5; `P1A-OD-03`; no Refund runtime exists. | Refund remains outside this closure. |
| `CORE-OD-10A` | What exact evidence makes Preparation complete? | Every required item must be complete at Order Item granularity, with actor, time and version evidence. | `OWNER_CONFIRMED` | `docs/architecture/after_four_state_machines.md:91-126`; worker/Ticket behavior is proposed. | Closes semantic evidence; technical design/Gates remain. |
| `CORE-OD-10B` | What constitutes customer handover? | Handover is an explicit event after completion and is separate from Preparation completion. | `OWNER_CONFIRMED` | `docs/architecture/after_four_business_domain_model.md:324-352`. | Closes semantic ordering; technical evidence design remains. |
| `CORE-OD-10C` | What guards permit terminal Order closure? | Require settled Payment, completed Preparation, handover evidence and no open exception. | `OWNER_CONFIRMED` | `docs/architecture/after_four_owner_decision_baseline.md`; `docs/architecture/after_four_state_machines.md:128-158`. | No automatic closure or implementation authority follows; Refund remains separate. |
| `CORE-OD-11A` | What actual timezone applies to each Branch Operating Day? | First Hoi An Branch: `Asia/Ho_Chi_Minh`. Every Branch retains its own explicit actual timezone. | `OWNER_CONFIRMED` | `ODB-CASH-12`; Owner review recorded in the baseline. | Exact timezone for later Branches remains Branch-specific input. |
| `CORE-OD-11B` | What explicit local cutoff applies to each Branch Operating Day? | Exact cutoff remains unresolved; do not assume midnight, closing time or another value. | `OWNER_DEFERRED — OWNER_INPUT_REQUIRED` | `ODB-CASH-12`; Owner review recorded in the baseline. | Blocks Session/day assignment and reporting cutoff. |
| `CORE-OD-11C` | How are Branch timezone and cutoff configured and inherited? | No inheritance in MVP; configure every Branch independently. | `OWNER_CONFIRMED` | `ODB-CASH-12`; Owner review recorded in the baseline. | Exact configuration mechanism remains technical design. |
| `CORE-OD-11D` | How do exceptional days change or preserve the Branch cutoff? | Exceptional days require explicit effective evidence and never silently rewrite a closed Operating Day. | `OWNER_CONFIRMED` | `ODB-CASH-12`; Owner review recorded in the baseline. | Exact exceptional-day workflow remains technical design. |
| `CORE-OD-12` | Who receives each Cash Open/Count/Handover/Close capability and how are delegation/separation handled? | Assignments, delegation and separation remain unresolved; no human appointment or generic-role inference. | `OWNER_DEFERRED — OWNER_INPUT_REQUIRED` | `ODB-CASH-13`; Owner review recorded in the baseline. | Blocks Cash execution and CORE-03 mapping. |
| `CORE-OD-13` | Which linked post-close correction operations exist and who initiates/approves them? | Post-close correction policy and authority remain unresolved; no correction feature is authorized. | `OWNER_DEFERRED — OWNER_INPUT_REQUIRED` | `ODB-CASH-14`; Owner review recorded in the baseline. | Blocks Cash correction and Reporting consequences. |
| `CORE-OD-14A` | Who may decide a handover disagreement/refusal and what escalation applies? | Escalate disagreement/refusal to Owner. Acknowledgement is not approval; detailed resolution remains unresolved. | `OWNER_CONFIRMED` | `ODB-CASH-15`; Owner review recorded in the baseline. | Resolution workflow remains open; no approval authority is inferred from acknowledgement. |
| `CORE-OD-14B` | After handover acknowledgement, what controlled transition applies to the outgoing Cash Session? | Acknowledgement does not automatically close the Session; require a separate Close action with its corresponding capability. | `OWNER_CONFIRMED` | `ODB-CASH-13`, `15`. | Close capability assignment remains deferred under `CORE-OD-12`. |
| `CORE-OD-15A` | How is every nonzero Cash discrepancy investigated and resolved? | Record every nonzero discrepancy with reason and Owner notification; no tolerance. Classes, linked correction, escalation and resolution authority remain open. | `OWNER_CONFIRMED` | `ODB-CASH-07`; `P2B-CASH-OD-03`; Owner review recorded in the baseline. | Remaining evidence/policy detail blocks reconciliation terminal outcomes. |
| `CORE-OD-15B` | Who may disposition an unresolved reconciliation case and release affected facts for authoritative reporting? | Hold unreconciled data from authoritative reporting. Disposition/release authority remains separate and unresolved; discrepancy resolution grants no report-release authority. | `OWNER_CONFIRMED` | `P2B-CASH-OD-08`; Owner review recorded in the baseline. | Disposition and release authority still block authoritative reporting. |
| `CORE-OD-16A` | What first operational metric/source baseline is reviewed? | Limit initial lineage to authoritative Order, Payment and pending Preparation Dispatch facts. Exclude Product/Variant sales, Preparation progress/handover, Cash/reconciliation, Refund/net sales, Expenses/float/top-ups, Promotions and Loyalty. | `OWNER_CONFIRMED` | `ODB-RPT-01`–`05`; current source inventory in §7. | Source-lineage design only; integrated reporting remains upstream-blocked. |
| `CORE-OD-16B` | Who may read each report, at what Organization/Branch scope? | Report-read capability matrix and Organization/Branch assignments remain unresolved; Identity authorization is separate. | `OWNER_DEFERRED — OWNER_INPUT_REQUIRED` | `ODB-RPT-01`–`05`; Identity/Branch authorization remains separate. | Blocks report-read contract. |
| `CORE-OD-16C` | Does export exist in this scope? | Excel export remains deferred and excluded. No export behavior or authority is approved. | `OWNER_CONFIRMED` | `ODB-RPT-03`; Owner review recorded in the baseline. | Future export requires separate policy and authorization. |
| `CORE-OD-16D` | What automatic external delivery exists? | Telegram and other external delivery remain deferred pending approved recipients, schedule, privacy and failure escalation. | `OWNER_CONFIRMED` | `ODB-RPT-01`, `05`; Owner review recorded in the baseline. | No recipient, schedule or delivery authority is granted. |
| `CORE-OD-16E` | What reporting cutoff applies and how does it depend on reconciled Operating Day? | Reporting cutoff follows the approved Operating Day; Cash-dependent facts are authoritative only after reconciliation. Exact cutoff remains dependent on deferred `CORE-OD-11B`. | `OWNER_CONFIRMED` | `ODB-RPT-02`, `04`; `P2B-CASH-OD-08`. | Exact daily boundary remains unresolved until cutoff is supplied. |
| `CORE-OD-16F` | What retention, disposal and legal-hold policy applies to reports and delivery history? | Retention, disposal and legal hold remain unresolved pending governance/privacy input. | `OWNER_DEFERRED — OWNER_INPUT_REQUIRED` | `ODB-RPT-05`; unresolved retention/privacy in Owner baseline. | Blocks production reporting governance, not source-fact design. |

The register contains 34 unique local references: 27 `OWNER_CONFIRMED` and seven `OWNER_DEFERRED — OWNER_INPUT_REQUIRED` (`CORE-OD-03`, `04`, `11B`, `12`, `13`, `16B`, `16F`). Partial decisions preserve every remaining boundary stated above. `CORE-OD-01` remains approved by reference and `CORE-OD-02` remains retired.

## 10. Dependency and Gate A readiness matrix

| Workstream | Design completeness | Owner-policy closure | External/qualified input | Gate A readiness | Next gate |
|---|---|---|---|---|---|
| CORE-01 Core Sale | Commercial baseline, cash-only payment baseline, logical contracts, sequence/failure model and Gate B candidate manifest prepared | `CORE-OD-05`–`07` and `17A`–`17C` confirmed; `CORE-OD-03/04` deferred; `CORE-OD-01` remains confirmed | Qualified tax/rounding input and exact Product/Variant Price transcription remain needed | `READY_FOR_INDEPENDENT_GATE_A_REVIEW — NOT_READY_FOR_GATE_A_APPROVAL` | Independent review now; close review findings and blocking input before requesting Gate A. |
| CORE-02 Preparation | Boundary, separate Dispatch/Outbox/Ticket states, scenario matrix and evidence plan prepared | `CORE-OD-08A`–`10C` confirmed; Refund amount/allocation/method/authority and exception mechanics remain separate | Technical review and exact implementation design remain needed | `POLICY_DIRECTION_SUBSTANTIALLY_CLOSED — NO_GATE_GRANTED` | Review bounded design; separate Gate A/B mandatory. |
| CORE-04 Cash | Approved policy reconciled; acknowledgement, approval, transition, discrepancy and reporting dimensions separated | `CORE-OD-11A/C/D`, `14A/B`, `15A/B` confirmed; `11B`, `12`, `13` deferred; discrepancy/release detail remains open | Cash/Accounting/Reporting input needed | `NOT_READY — POLICY_AND_EVIDENCE_REQUIRED` | Resolve cutoff, authority, correction and remaining discrepancy/release detail before Gate A. |
| CORE-03 Operator access | Bounded trust/capability contract prepared | Assignments and bank/Cash authority unresolved | Security evidence and ADR-0006/Milestone governance required | `NOT_READY — IDENTITY MILESTONE UNAUTHORIZED` | Separate Identity Gate A and Gate B. |
| CORE-05 Reporting | Staged source-lineage is approved only for authoritative Order, Payment and pending-Dispatch facts; integrated reporting awaits Order Item, Preparation, Cash and reconciliation facts | `CORE-OD-16A/C/D/E` confirmed; `16B/F` deferred; no read, export, delivery, recipient, schedule, retention or legal-hold authority is granted | Authoritative upstream facts and governance/privacy input remain required | `NOT_READY — UPSTREAM_DEPENDENCIES` | Review bounded lineage only; no reporting implementation or authority follows. |

No Gate A is granted. A future request must pin an exact reviewed commit/document set and preserve all exclusions. Gate B remains a separate exact manifest and Owner decision.

## 11. Critical path and parallel execution plan

### Critical path

1. Preserve the approved-by-reference `CORE-OD-01` menu baseline and the confirmed initial-slice exclusions; obtain the missing exact Product/Variant Price transcription and qualified input for deferred `CORE-OD-03/04`.
2. Independently review CORE-01 now; request bounded Gate A only after review findings and blocking inputs are closed.
3. After Gate A only, prepare an exact Gate B manifest for Catalog/Pricing reads, Order Items/snapshots/calculation, API endpoints, exact-cash settlement and POS integration while preserving Phase 1 Payment/Dispatch. Manual bank remains excluded unless its two prerequisites have closed.
4. In parallel with step 1–3, close CORE-02 Preparation. Preserve CORE-03 as an external prerequisite without expanding Identity scope; neither implementation may start without its separately applicable Gate B.
5. Implement Preparation execution only after its Gate A/B; then close end-to-end Order completion.
6. Close and authorize CORE-04 Cash before claiming usable full-day café operations.
7. Implement CORE-05 Reporting only from stabilized authoritative facts and approved reconciliation rules.

### Parallel preparation

| Lane | Work now | Exit condition before implementation |
|---|---|---|
| A — Core Sale | Freeze exact menu/Price transcription, obtain tax/rounding input and independently review the cash-only first-slice baseline | Blocking evidence and review findings closed, then Gate A approval plus exact Gate B authorization; manual bank requires separate prerequisite closure. |
| B — Preparation | Reconcile the confirmed `CORE-OD-08A`–`10C` policy into the bounded technical baseline | Independent review, Gate A and Gate B; Refund and exception mechanics remain separately governed. |
| C — Operator access | No new work in this closure; preserve the existing trust/capability dependency and I1 ancestry boundary | Separate Identity authorization and applicable Gate A/B; ADR-0006 and Milestone 2B status unchanged. |
| D — Cash | Obtain cutoff/authority/correction and discrepancy-release evidence for deferred/open boundaries | Remaining policy closure, Gate A and Gate B. |
| E — Reporting | Reconcile confirmed staged lineage while obtaining read-scope and retention/legal-hold input | Upstream facts, deferred policy closure, Gate A and Gate B. |

Promotion/Loyalty policy closure may continue outside this package but must not enter CORE-01 calculation until its formulas, ordering, allocation and authorization receive separate approval.

## 12. Inventory deferral

This milestone excludes stock management, purchasing/suppliers, transfers, Recipe-based automatic deduction, stocktake/waste, and batch/lot/expiry. No Order, Payment, Dispatch, Ticket completion or report in this package may require Inventory availability, mutation or success.

Future integration remains possible through explicit facts owned by Ordering/Preparation and separately consumed by Inventory. Do not place stock columns, stock guards, Recipe calculations or Inventory callbacks inside Ordering, Payment or Preparation. Future Inventory failure cannot rewrite confirmed sold snapshots or successful Payment.

## 13. Owner Review Package

The consolidated Owner review is complete. The resulting follow-up sequence is:

1. Do not reopen `CORE-OD-01` or ask for the menu again. Freeze its exact Product/Variant/Price transcription as evidence, not a new decision.
2. Preserve the confirmed cash-only, channel and commercial-exclusion boundary; manual bank remains outside the initial slice pending its separate prerequisites.
3. Obtain qualified input for deferred `CORE-OD-03/04`; do not approve technical calculation around missing tax/rounding policy.
4. Reconcile confirmed `CORE-OD-08A`–`10C` into independent technical review while keeping Refund and exception mechanics separately governed.
5. Obtain Owner/evidence input for deferred `CORE-OD-11B`, `12`, `13` and the remaining discrepancy/disposition/release details preserved by `CORE-OD-15A/B`.
6. Preserve confirmed staged lineage and deferrals under `CORE-OD-16A`–`F`; source scope never implies read, export, delivery or retention authority.

| Review group | References | Blocking effect |
|---|---|---|
| CORE-01 calculation | `CORE-OD-03`, `04` | Blocks Gate A approval of an executable calculation baseline; qualified evidence required. |
| CORE-01 bounded exclusions | `CORE-OD-05`, `17A`–`17C` | Confirmed exclusions remove these components from the initial slice; no future policy is inferred. |
| CORE-01 channel/access | `CORE-OD-06`, `07` | Channel and cash-only direction are confirmed; manual bank still requires separately authorized capability/evidence support. CORE-03 remains unauthorized. |
| CORE-02 progress/fulfillment | `CORE-OD-08A`–`08C`, `10A`–`10B` | Policy is confirmed; technical review and Gate A/B remain mandatory. |
| CORE-02 cancellation/closure | `CORE-OD-09A`–`09D`, `10C` | Policy is confirmed within stated bounds; Refund and exception mechanics remain separate and no implementation follows. |
| CORE-04 Cash | `CORE-OD-11A`–`15B` | Confirmed directions coexist with deferred cutoff/authority/correction and open discrepancy/release details; CORE-04 remains not ready for Gate A approval. |
| CORE-05 Reporting | `CORE-OD-16A`–`16F` | Staged lineage and exclusions are confirmed; implementation remains blocked by upstream facts and read/retention authority. |

The Owner's selections record business policy only. They do not accept this technical design, grant Gate A, authorize Gate B preparation where otherwise prohibited, authorize implementation, or grant FOA/Production Authorization.

## 14. Validation and final boundary

This package records the 2026-11-24 consolidated Owner review alongside `CORE-OD-01`. All local references remain `ID_PENDING_OWNER_GOVERNANCE`; no canonical ID is allocated. It introduces no schema, migration, constraint, code, test, dependency, API, runtime behavior, database operation, external contact, disclosure, commissioning, Gate, Control Acceptance, FOA or Production Authorization.

Current classifications remain:

- Catalog Package B and Order/Payment Phase 1: merged bounded foundations, not authority for new work;
- Identity I1: Gate A/B/C approved only for ancestry;
- Identity Milestone 2B: unauthorized;
- CORE-01: ready for independent Gate A review, but not Gate A approval; blocking policy/evidence remains;
- CORE-02: policy direction substantially closed, but design review and applicable Gate A/B remain mandatory;
- CORE-04: confirmed directions coexist with deferred cutoff, capability and correction policy plus open discrepancy/release details;
- CORE-05: staged lineage direction only; read, export, retention, recipient and delivery authority remain absent;
- CORE-03: remains outside this closure and unauthorized for implementation;
- Inventory: deferred from this milestone, with future boundaries preserved.

**Final status:** `OWNER_REVIEW_RECORDED — CORE_01_INDEPENDENT_GATE_A_REVIEW_CANDIDATE_PREPARED — CORE_02_POLICY_DIRECTION_SUBSTANTIALLY_CLOSED — CORE_04_05_DEPENDENCIES_REMAIN — ZERO_GATES_GRANTED — ZERO_IMPLEMENTATION_AUTHORIZED`.
