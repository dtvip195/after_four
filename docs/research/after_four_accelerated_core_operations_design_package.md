# AFTER FOUR — Accelerated Core Operations Design Package

**Package status:** `CORE_01_READY_FOR_INDEPENDENT_GATE_A_REVIEW — OWNER_DECISIONS_REQUIRED_BEFORE_GATE_A_APPROVAL`

**Repository baseline:** `main` / `origin/main` at `d1d8807faa1234fc7924bd522fa26363d1e3a414`

**Evidence cutoff:** 2026-11-24 (Asia/Tokyo)

**Implementation authorization:** `NOT_GRANTED`

## 1. Purpose, authority and classifications

This package consolidates five bounded Core Operations workstreams and one Owner review. It follows the [Accelerated Core Operations Readiness Assessment](after_four_accelerated_core_operations_readiness_assessment.md), preserves the canonical [Owner Decision Baseline](../architecture/after_four_owner_decision_baseline.md), and follows accepted [ADR-0011 Layered DDD](../architecture/adr/0011-project-wide-layered-ddd.md).

The Owner confirmed `CORE-OD-01` on 2026-11-24: dine-in plus takeaway, the detailed draft menu/options approved by reference to [Proposed Launch Menu v3](../architecture/after_four_proposed_launch_menu_v3.md), and approximate selling-price directions of VND 23,000, VND 33,000 and VND 43,000–49,000. The repository does not contain an exact Product/Variant-to-Price mapping, so the bands are not exact SKU Prices and must not be used as one. `CORE-OD-01` is recorded with `ID_PENDING_OWNER_GOVERNANCE`; it does not rewrite the narrower scopes of `ODB-CAT-11`–`ODB-CAT-13` ([Owner Decision Baseline §5](../architecture/after_four_owner_decision_baseline.md#5-catalogpricing-mvp)). Inventory deferral, parallel design preparation and consolidated review remain task boundaries.

Classifications used here:

| Classification | Meaning |
|---|---|
| `OWNER_CONFIRMED` | Exact policy recorded in the canonical Owner Decision Baseline. |
| `OWNER_CONFIRMED_BY_REFERENCE` | Owner-approved content identified by an exact repository artifact, with missing transcription/data gaps stated explicitly. |
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

Exact-balance cash is the bounded first-slice payment path. The merged Phase 1 manual-bank command remains historical implementation evidence, but manual-bank confirmation is excluded from the initial implementation scope unless `CORE-OD-07` is explicitly closed and the separately governed trusted operator/capability prerequisite is authorized and available. This conditional exclusion is a scope fence, not a permanent business-policy decision.

Inventory, Customer association, Promotions, Loyalty, Refund execution, electronic-provider integration, kitchen execution, Cash Session posting and Reporting projections are excluded. Anonymous/unregistered Orders remain allowed under `SDP-CUST-19`.

### 3.2 Commercial baseline and evidence boundary

| Fact | Classification | Exact scope | Remaining gap |
|---|---|---|---|
| Product/Variant/Price rules | `OWNER_CONFIRMED` | `ODB-CAT-01`–`10`: Brand-global Product, persisted Variant, Branch availability/Price scope, immutable effective-dated Prices, explicit revised-quote review and immutable sold Price. | Runtime Pricing and Order Items do not exist. |
| Launch scale, selective sizes and Signature designations | `OWNER_CONFIRMED` | `ODB-CAT-11`–`13`. | These older decisions do not themselves approve individual rows or Prices. |
| Draft launch menu and channels | `OWNER_CONFIRMED_BY_REFERENCE` | `CORE-OD-01` accepts the 28 named rows, six menu groupings, presented option labels, and dine-in/takeaway scope in [Proposed Launch Menu v3](../architecture/after_four_proposed_launch_menu_v3.md). | Canonical codes, exact persisted records, final Variant applicability/capacity and operational table/service contract remain unresolved. |
| Pricing direction | `OWNER_CONFIRMED_BY_REFERENCE` | Approximate entry/mid/premium directions: VND 23,000 / 33,000 / 43,000–49,000. | No repository artifact maps an individual Product/Variant to an exact amount or tier. POS demo fixtures are not authority. |
| Commercial components | `OWNER_DECISION_REQUIRED` | Tax, rounding, Service Charge, Modifier price effects, complimentary/zero-price items and manual sold-price overrides are independently answerable. | The included components must be closed before Gate A approval of an executable calculation baseline. |

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

Tax treatment, rounding, Modifier effects, complimentary/zero-price behavior, Service Charge, Promotion/Loyalty and component order remain `OWNER_DECISION_REQUIRED`. Until resolved, Gate A cannot approve an executable calculation contract that contains them.

### 3.7 Payment and dispatch boundaries

- The bounded first slice confirms only exact target amount and currency through the existing cash command.
- The existing manual-bank command and evidence remain unchanged, but are outside the initial implementation scope until `CORE-OD-07` and the separately governed trusted operator/capability prerequisite close. Manual bank remains cashier-observed confirmation; an alert/speaker is not authoritative bank evidence ([API Contract §6.2](../architecture/after_four_api_contract.md#62-payment-commands)).
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
| Payment/Dispatch integration | Adapt the confirmed authoritative total into the existing Phase 1 exact-cash boundary without changing financial truth. Manual-bank integration is excluded until `CORE-OD-07` and the trusted operator/capability prerequisite close. | Exact-cash target, mismatch, replay, late-success, dispatch uniqueness and failure-injection evidence; separate manual-bank evidence only if later authorized. |
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

Cancellation review must evaluate each operational stage without collapsing request authority, approval authority, Preparation consequence, Ordering consequence/closure, Refund consequence or required evidence. Existing authority is preserved: Staff may cancel with reason before Preparation starts; after Preparation starts, Owner approval is required; completed Orders use a separate unresolved exception process (`ODB-OP-12`–`14`). The repository does not establish the requester for after-start cancellation. No row below authorizes cancellation or Refund execution.

| Observed stage | Request / authorization boundary | Preparation consequence | Ordering / closure consequence | Refund consequence | Required evidence |
|---|---|---|---|---|---|
| Paid, Dispatch not created | Staff may cancel with reason only while a race-safe check proves Preparation has not started. | Prevent future Dispatch; exact fence remains technical. | Record a paid-Order cancellation fact; never infer closure. | Obligation, method and execution authority unresolved. | Actor, Branch, reason, Order/Payment state, authoritative absence of Dispatch/start, idempotency and audit identity. |
| Dispatched, Ticket not started | Staff authority applies only if an atomic Preparation-state fence proves no start. | Cancel/reject queued work and reconcile Dispatch/Ticket; exact behavior unresolved. | Preserve Dispatch evidence and record cancellation or exception outcome. | Exact consequence unresolved. | Above evidence plus Dispatch/Ticket identity and fenced no-start version. |
| Ticket in progress | Owner approval is mandatory; requester identity is unresolved. | Stop/continue, partial work, deviation/remake and custody remain unresolved. | Preserve confirmed history and record linked cancellation/exception facts. | Amount, allocation, method and authority unresolved. | Requester, approver, reason, stage/version, completed/remaining work and immutable audit evidence. |
| Preparation completed, not handed over | At minimum after-start Owner approval applies; completed-Order exception authority may additionally apply depending on Ordering state. | Preserve completion and custody evidence; exact exception outcome unresolved. | Completion does not prove handover or terminal closure. | Exact consequence unresolved. | Completion evidence, absence of handover, requester/approval/reason and linked exception evidence. |
| Handed over | If terminally completed, `ODB-OP-14` requires the separate unresolved exception process; otherwise after-start Owner approval still cannot be bypassed. | Preserve immutable completion/handover evidence. | `P1A-OD-07` remains deferred; no reopening or automatic closure. | Post-fulfillment Refund/remedy remains unresolved. | Completion/handover facts, current Order state, requester/approval/reason and linked exception evidence. |

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
- **Approval/disagreement:** approval authority, refusal, disagreement and escalation remain unresolved. They must not be inferred from acknowledgement or generic Staff status.
- **Cash Session transition:** whether handover closes the outgoing Session, requires a separate close, or uses another controlled transition remains unresolved independently of acknowledgement/approval.
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

`CORE-OD-01` is no longer a ballot item: its approved-by-reference menu/channel/price-direction scope is recorded in the Owner Decision Baseline with `ID_PENDING_OWNER_GOVERNANCE`. `CORE-OD-02` is retired without allocation because the Owner has clarified that the three price bands are approximate directions; it is not a separate unresolved policy. Every reference in the table below remains local, `PROPOSED_NOT_APPROVED`, independently answerable, and not a canonical ODB allocation.

| Reference | Owner question | Source-supported options | Recommendation | Evidence | Dependency / consequence of deferral |
|---|---|---|---|---|---|
| `CORE-OD-03` | What tax treatment and display apply to the bounded menu? | The repository establishes no defensible option set; qualified Tax/Accounting input must identify applicable choices. Inclusive, exclusive or not-applicable treatment must not be guessed. | `RECOMMENDATION_NOT_ESTABLISHED`. | `docs/architecture/after_four_catalog_pricing_discovery.md:61-77`; `docs/architecture/after_four_data_integrity_rules.md:114`. | Blocks final calculation/snapshot/reporting contract. |
| `CORE-OD-04` | What monetary precision and rounding policy applies, and at which boundary? | The repository establishes integer VND representation but no approved rounding option set or calculation boundary; qualified commercial/Accounting input is required. | `RECOMMENDATION_NOT_ESTABLISHED`; preserve integer VND representation pending policy. | `backend/app/models/payment.rb:10-15`; `docs/architecture/after_four_catalog_pricing_discovery.md:61-77`. | Blocks deterministic calculation and Refund allocation. |
| `CORE-OD-05` | Is Service Charge part of the first Core Sale scope? | A: explicitly exclude; B: include only after rate, basis, applicability, ownership, Tax/Refund/Reporting treatment are approved; C: defer CORE-01. | A is the narrowest acceleration option, `PROPOSED_NOT_APPROVED`. | `docs/architecture/after_four_real_menu_pricing_specification.md:112-134`; `docs/architecture/after_four_catalog_pricing_discovery.md:61-77`. | Inclusion without complete policy blocks calculation. |
| `CORE-OD-06` | What dine-in table/service context is mandatory, and what identifies takeaway? | The logical API proposes an optional `table_session_id` for dine-in and channel identity for takeaway, but no approved Table Session source/ownership or complete alternative set exists. The Owner may bound a first-slice rule or defer pending operational input. | `RECOMMENDATION_NOT_ESTABLISHED`. | `docs/architecture/after_four_api_contract.md:190-206`; `docs/architecture/after_four_business_domain_model.md:326-337`. | Blocks Order creation contract and UI. |
| `CORE-OD-07` | Beyond the confirmed cashier comparison action, what exact Branch-scoped capability assignment and evidence are required for manual bank confirmation? | `ODB-OP-09` already requires cashier comparison and explicit POS confirmation; the repository does not establish a complete assignee/delegation option set. Until this decision and the trusted operator/capability prerequisite close, the bounded implementation scope is cash-only. This does not permanently exclude manual bank. | Require an exact payment-confirm capability rather than a generic role title; assignees and evidence remain `NOT_APPROVED`. | `ODB-OP-07`–`09`; `docs/architecture/after_four_owner_decision_baseline.md:246-248`. | Does not block the cash-only first slice; blocks manual-bank inclusion and depends on separately governed CORE-03/Identity authority. |
| `CORE-OD-17A` | May a Modifier change Price in the first Core Sale slice? | A: exclude price-affecting Modifiers; B: include only an approved applicability/effect/Price-version matrix; C: defer affected Products. | A is the bounded MVP default, `PROPOSED_NOT_APPROVED`; displayed menu options are not thereby price-neutral. | `ODB-CAT-05`; Proposed Launch Menu v3 §8; Catalog/Pricing discovery. | Nonblocking if explicitly excluded; otherwise blocks calculation and affected Products. |
| `CORE-OD-17B` | Are complimentary or zero-price Order Items allowed in the first slice? | A: exclude; B: permit only with separately approved eligibility, reason, authority and reporting evidence; C: defer. | A is the bounded MVP default, `PROPOSED_NOT_APPROVED`. | Owner baseline lists zero-price/free-product policy unresolved. | Nonblocking if excluded; otherwise blocks calculation/authorization/reporting. |
| `CORE-OD-17C` | May an operator manually override the authoritative sold Price? | A: prohibit direct override and use only published Price Versions; B: permit only under separately approved reason/capability/limit/audit policy; C: defer. | A is the bounded MVP default, `PROPOSED_NOT_APPROVED`; Branch Price Versions remain separately allowed. | `ODB-CAT-07`–`10`; manual override remains unresolved. | Nonblocking if prohibited; otherwise blocks authorization and snapshot design. |
| `CORE-OD-08A` | At what granularity is Preparation progress recorded? | A: Ticket-level; B: Item-level; C: quantity-level; combinations require exact semantics. | B is the bounded initial-slice default, `PROPOSED_NOT_APPROVED`; quantity progress remains deferred unless operational evidence requires it. | `docs/architecture/after_four_api_contract.md:239-250`; no executable ticket lifecycle exists. | Blocks Ticket/Item state model, commands and UI. |
| `CORE-OD-08B` | May a Ticket become partially complete, and what does that mean at the chosen progress granularity? | A: no partial completion; B: partial completion under exact item/quantity guards; C: defer. | A is the bounded initial-slice default, `PROPOSED_NOT_APPROVED`; answer depends on `CORE-OD-08A`. | Same Preparation sources; no current implementation evidence. | Blocks completion guards and reconciliation. |
| `CORE-OD-08C` | May completed work be partially handed over to the customer? | A: no partial handover; B: partial handover with exact custody/evidence rules; C: defer. | A is the bounded initial-slice default, `PROPOSED_NOT_APPROVED`; do not infer it from partial progress/completion. | `docs/architecture/after_four_business_domain_model.md:324-352`; handover policy is not settled. | Blocks handover and Order fulfillment evidence. |
| `CORE-OD-09A` | Across paid-undispatched, dispatched-not-started, in-progress, completed-not-handed-over and handed-over stages, what cancellation outcome is permitted within the already-approved authority boundaries? | Preserve `ODB-OP-12`–`14`: Staff-before-start, Owner approval after start, separate completed-Order exception. Stage-specific outcome details remain selectable; no automatic cancellation is an option. | Preserve existing authority; `RECOMMENDATION_NOT_ESTABLISHED` for outcomes. | §4.5; `docs/architecture/after_four_owner_decision_baseline.md:251-253`. | Blocks cancellation command and race fence. |
| `CORE-OD-09B` | What Preparation consequence applies at each cancellation stage? | For each stage decide prevent Dispatch, cancel/reject queued work, stop/continue in-progress work, or preserve completed/handover evidence; exact options depend on observed stage. | `RECOMMENDATION_NOT_ESTABLISHED`. | §4.5; `docs/architecture/after_four_api_contract.md:229-250`. | Blocks Ticket cancellation/deviation/reconciliation. |
| `CORE-OD-09C` | What Ordering state or exception fact applies at each cancellation stage? | Cancellation, held/exception and completed-Order treatment must remain distinct; no stage automatically closes the Order. | `RECOMMENDATION_NOT_ESTABLISHED`; coordinate with `CORE-OD-10C`. | §4.5; `P1A-OD-04`, `05`, `07` in the Owner baseline. | Blocks Order terminal-state handling. |
| `CORE-OD-09D` | What Refund consequence and authority applies at each cancellation stage? | The repository establishes no complete amount/allocation/method/authority option set. No cancellation automatically authorizes or executes a Refund. | `RECOMMENDATION_NOT_ESTABLISHED`; qualified Payment/Accounting input required. | §4.5; `P1A-OD-03` policy principle; no Refund runtime exists. | Blocks financial consequence and reporting. |
| `CORE-OD-10A` | What exact evidence makes Preparation complete? | Candidate evidence depends on `CORE-OD-08A/B`; completion is a Preparation fact only. | Require every required item at the approved granularity to be complete with actor/time/version evidence; `PROPOSED_NOT_APPROVED`. | `docs/architecture/after_four_state_machines.md:91-126`; worker/Ticket behavior is proposed. | Blocks Preparation terminal guards. |
| `CORE-OD-10B` | What exact evidence constitutes customer handover, and may it occur separately from Preparation completion? | A: explicit handover after completion; B: another separately evidenced fulfillment rule; no source supports silently equating handover with completion. | A is the bounded default, `PROPOSED_NOT_APPROVED`; depends on `CORE-OD-08C`. | `docs/architecture/after_four_business_domain_model.md:324-352`. | Blocks fulfillment provenance. |
| `CORE-OD-10C` | What settlement, Preparation, handover and exception guards permit terminal Order closure? | The source establishes only that Payment success alone is insufficient; `P1A-OD-07` remains deferred. | `RECOMMENDATION_NOT_ESTABLISHED`; no automatic closure from completion/handover. | `docs/architecture/after_four_owner_decision_baseline.md:118`; `docs/architecture/after_four_state_machines.md:128-158`. | Blocks end-to-end terminal closure and reports. |
| `CORE-OD-11A` | What actual timezone applies to each Branch Operating Day? | Supply an explicit IANA-style Branch timezone or another reviewed exact representation. A chain-wide timezone cannot substitute for the required Branch timezone. | `RECOMMENDATION_NOT_ESTABLISHED`; preserve `ODB-CASH-12`. | `docs/architecture/after_four_owner_decision_baseline.md:137`. | Blocks Operating Day calculation. |
| `CORE-OD-11B` | What explicit local cutoff applies to each Branch Operating Day? | Supply the exact cutoff and boundary semantics; no value is approved yet. | `RECOMMENDATION_NOT_ESTABLISHED`; preserve `ODB-CASH-12`. | Same canonical row. | Blocks Session/day assignment and reporting cutoff. |
| `CORE-OD-11C` | How are Branch timezone and cutoff configured and inherited without replacing Branch semantics? | A: no inheritance—each Branch is configured independently; B: an inherited default is resolved into an effective value for each Branch with an explicit controlled Branch override. Both retain actual Branch values. | A is the bounded MVP default, `PROPOSED_NOT_APPROVED`; B reduces repetition but needs provenance/effective-date/override rules. | `ODB-CASH-12` leaves configuration/inheritance unresolved. | Blocks configuration and effective-change design. |
| `CORE-OD-11D` | How do exceptional days change or preserve the Branch cutoff? | Source evidence does not establish an option set; exceptions require explicit effective evidence and must not silently rewrite closed days. | `RECOMMENDATION_NOT_ESTABLISHED`. | `ODB-CASH-12` remaining boundary. | Blocks exceptional-day operations and reconciliation. |
| `CORE-OD-12` | Who receives each Cash Open/Count/Handover/Close capability and how are delegation/separation handled? | Candidate assignments require Owner/organizational input; generic Staff/Shift/Assignment is invalid. | `RECOMMENDATION_NOT_ESTABLISHED`. | `ODB-CASH-13`; `docs/architecture/after_four_owner_decision_baseline.md:138`. | Blocks Cash execution and CORE-03 mapping. |
| `CORE-OD-13` | Which linked post-close correction operations exist and who initiates/approves them? | Source evidence does not establish a complete option set. | `RECOMMENDATION_NOT_ESTABLISHED`; do not invent authority. | `ODB-CASH-14`; `docs/architecture/after_four_owner_decision_baseline.md:139`. | Blocks Cash correction and Reporting consequences. |
| `CORE-OD-14A` | Who may decide a handover disagreement/refusal and what escalation applies? | Acknowledgement remains required evidence but is not approval. The repository establishes no complete approval/escalation option set. | `RECOMMENDATION_NOT_ESTABLISHED`; do not derive authority from either actor's acknowledgement. | `ODB-CASH-15`; `docs/architecture/after_four_owner_decision_baseline.md:140`. | Blocks disagreement/escalation workflow. |
| `CORE-OD-14B` | After handover acknowledgement, what controlled transition applies to the outgoing Cash Session? | A: separate close action; B: controlled automatic close; C: another reviewed transition. None is approved. | A is a bounded proposal because `ODB-CASH-13` separates Handover and Close capabilities; it remains `PROPOSED_NOT_APPROVED` and independent of `CORE-OD-14A`. | `ODB-CASH-13`, `15`. | Blocks Cash Session state machine. |
| `CORE-OD-15A` | How is every nonzero Cash discrepancy investigated and resolved? | Preserve mandatory recording, reason and Owner notification with no tolerance. Classes, linked correction, escalation and resolution authority need Cash/Accounting/Reporting evidence. | `RECOMMENDATION_NOT_ESTABLISHED`; no automatic tolerance or correction authority. | `ODB-CASH-07`; `P2B-CASH-OD-03`; `docs/architecture/after_four_owner_decision_baseline.md:204,269`. | Blocks reconciliation terminal outcomes. |
| `CORE-OD-15B` | Who may disposition an unresolved reconciliation case and release affected facts for authoritative reporting? | `P2B-CASH-OD-08` already makes reconciliation a prerequisite, so unreconciled facts are held. Exception disposition, escalation, any override and release authority remain unresolved and separate from correction. | `RECOMMENDATION_NOT_ESTABLISHED`; resolution alone grants no release authority. | `P2B-CASH-OD-08`; `docs/architecture/after_four_owner_decision_baseline.md:176`. | Blocks authoritative daily reporting. |
| `CORE-OD-16A` | What first operational metric/source baseline is reviewed? | A: staged currently-authoritative Order/Payment/pending-Dispatch facts only, explicitly excluding Product/Variant sales, Preparation progress/handover, Cash balance/discrepancy/reconciliation, Refund/net sales, Expenses/float/top-ups and Promotion/Loyalty; B: integrated sales/Payment/Preparation/Cash-exception baseline after those authoritative facts exist; C: defer. | A is recommended for source-lineage design only, `PROPOSED_NOT_APPROVED`; it does not narrow `ODB-RPT-04`, and B remains the later operational target. | `ODB-RPT-01`–`05`; current source inventory in §7. | Defines staged report design; B remains upstream-blocked. |
| `CORE-OD-16B` | Who may read each report, at what Organization/Branch scope? | Source evidence does not establish a complete capability/assignee matrix. | `RECOMMENDATION_NOT_ESTABLISHED`; no generic report authority. | `ODB-RPT-01`–`05`; Identity/Branch authorization remains separate. | Blocks report-read contract. |
| `CORE-OD-16C` | Does export exist in this scope, and who may export what? | `ODB-RPT-03` defers Excel export; no other export is authorized by this package. Owner may preserve deferral or separately scope a future review. | Preserve deferral; `NOT_APPROVED` for export. | `docs/architecture/after_four_owner_decision_baseline.md:288`. | No export endpoint/evidence may be designed as approved behavior. |
| `CORE-OD-16D` | What recipients, channel, schedule and delivery-failure escalation apply? | Telegram direction exists, but exact recipients/time/privacy/failure escalation remain unresolved. | `RECOMMENDATION_NOT_ESTABLISHED`; no delivery authority granted. | `ODB-RPT-01`, `05`; `docs/architecture/after_four_owner_decision_baseline.md:286,290-292`. | Blocks automatic delivery design. |
| `CORE-OD-16E` | What reporting cutoff applies and how does it depend on reconciled Operating Day? | Cash-dependent authoritative reporting must await reconciliation; exact cutoff depends on `CORE-OD-11A`–`D`. | `RECOMMENDATION_NOT_ESTABLISHED`. | `ODB-RPT-02`, `04`; `P2B-CASH-OD-08`. | Blocks daily/period boundaries. |
| `CORE-OD-16F` | What retention, disposal and legal-hold policy applies to reports and delivery history? | Source evidence does not establish durations/readers/hold procedures; qualified governance input is required. | `RECOMMENDATION_NOT_ESTABLISHED`; no retention/export authority inferred. | `ODB-RPT-05`; unresolved retention/privacy in Owner baseline. | Blocks production reporting governance, not source-fact design. |

The open register contains 34 unique, independently answerable local references. No question asks the Owner to repeat `CORE-OD-01` or reapprove existing policy. Choices narrow only the unresolved portions identified in canonical sources.

## 10. Dependency and Gate A readiness matrix

| Workstream | Design completeness | Owner-policy closure | External/qualified input | Gate A readiness | Next gate |
|---|---|---|---|---|---|
| CORE-01 Core Sale | Commercial baseline, cash-only payment baseline, logical contracts, sequence/failure model and Gate B candidate manifest prepared | `CORE-OD-03`–`07` and `17A`–`17C` unresolved; `CORE-OD-01` confirmed; unresolved `CORE-OD-07` excludes manual bank without blocking cash-only review | Tax/Accounting input and exact Product/Variant Price transcription remain needed | `READY_FOR_INDEPENDENT_GATE_A_REVIEW — NOT_READY_FOR_GATE_A_APPROVAL` | Independent review now; resolve blocking policy/data before requesting exact Gate A. |
| CORE-02 Preparation | Boundary, separate Dispatch/Outbox/Ticket states, scenario matrix and evidence plan prepared | `CORE-OD-08A`–`10C` unresolved; `P1A-OD-07` deferred | Operational Preparation input needed | `NOT_READY — OWNER_POLICY_REQUIRED` | Close policy and review design. |
| CORE-04 Cash | Approved policy reconciled; acknowledgement, approval, transition, discrepancy and reporting dimensions separated | `CORE-OD-11A`–`D`, `12`, `13`, `14A`–`B` and `15A`–`B` unresolved | Cash/Accounting/Reporting input needed | `NOT_READY — POLICY_AND_EVIDENCE_REQUIRED` | Close policy before Gate A. |
| CORE-03 Operator access | Bounded trust/capability contract prepared | Assignments and bank/Cash authority unresolved | Security evidence and ADR-0006/Milestone governance required | `NOT_READY — IDENTITY MILESTONE UNAUTHORIZED` | Separate Identity Gate A and Gate B. |
| CORE-05 Reporting | Staged source-lineage design may use only currently authoritative Order, Payment and pending-Dispatch facts; integrated reporting awaits Order Item, Preparation, Cash and reconciliation facts | `CORE-OD-16A`–`F` remain open; no report-read, export, delivery, recipient, schedule, retention or legal-hold authority is granted | Authoritative upstream facts and governance input remain required | `NOT_READY — UPSTREAM_DEPENDENCIES` | Review the bounded lineage baseline only; no reporting implementation or authority follows. |

No Gate A is granted. A future request must pin an exact reviewed commit/document set and preserve all exclusions. Gate B remains a separate exact manifest and Owner decision.

## 11. Critical path and parallel execution plan

### Critical path

1. Preserve the approved-by-reference `CORE-OD-01` menu baseline; obtain the missing exact Product/Variant Price transcription and close `CORE-OD-03`–`07` plus `CORE-OD-17A`–`17C` as applicable.
2. Independently review CORE-01 now; request bounded Gate A only after review findings and blocking inputs are closed.
3. After Gate A only, prepare an exact Gate B manifest for Catalog/Pricing reads, Order Items/snapshots/calculation, API endpoints, exact-cash settlement and POS integration while preserving Phase 1 Payment/Dispatch. Manual bank remains excluded unless its two prerequisites have closed.
4. In parallel with step 1–3, close CORE-02 Preparation. Preserve CORE-03 as an external prerequisite without expanding Identity scope; neither implementation may start without its separately applicable Gate B.
5. Implement Preparation execution only after its Gate A/B; then close end-to-end Order completion.
6. Close and authorize CORE-04 Cash before claiming usable full-day café operations.
7. Implement CORE-05 Reporting only from stabilized authoritative facts and approved reconciliation rules.

### Parallel preparation

| Lane | Work now | Exit condition before implementation |
|---|---|---|
| A — Core Sale | Freeze exact menu/Price transcription, close the bounded commercial ballot and independently review the cash-only first-slice baseline | Blocking policy/evidence closed, then Gate A approval plus exact Gate B authorization; manual bank requires separate prerequisite closure. |
| B — Preparation | Operational scenarios and `CORE-OD-08A`–`10C` review | Approved lifecycle/closure policy, Gate A and Gate B. |
| C — Operator access | No new work in this closure; preserve the existing trust/capability dependency and I1 ancestry boundary | Separate Identity authorization and applicable Gate A/B; ADR-0006 and Milestone 2B status unchanged. |
| D — Cash | Cash/Accounting/Reporting evidence and review of `CORE-OD-11A`–`D`, `CORE-OD-12`, `CORE-OD-13`, `CORE-OD-14A`–`B` and `CORE-OD-15A`–`B` | Policy closure, Gate A and Gate B. |
| E — Reporting | Metric/source lineage and `CORE-OD-16A`–`F` review | Upstream facts, access/retention policy, Gate A and Gate B. |

Promotion/Loyalty policy closure may continue outside this package but must not enter CORE-01 calculation until its formulas, ordering, allocation and authorization receive separate approval.

## 12. Inventory deferral

This milestone excludes stock management, purchasing/suppliers, transfers, Recipe-based automatic deduction, stocktake/waste, and batch/lot/expiry. No Order, Payment, Dispatch, Ticket completion or report in this package may require Inventory availability, mutation or success.

Future integration remains possible through explicit facts owned by Ordering/Preparation and separately consumed by Inventory. Do not place stock columns, stock guards, Recipe calculations or Inventory callbacks inside Ordering, Payment or Preparation. Future Inventory failure cannot rewrite confirmed sold snapshots or successful Payment.

## 13. Owner Review Package

The recommended consolidated review sequence is:

1. Do not reopen `CORE-OD-01` or ask for the menu again. Freeze its exact Product/Variant/Price transcription as evidence, not a new decision.
2. Review `CORE-OD-05`, `06`, `07` and `17A`–`17C` together to bound the first commercial slice. Service Charge, priced Modifiers, complimentary items and overrides require explicit decisions; manual bank remains conditionally outside the cash-only initial scope until its prerequisites close.
3. Obtain qualified input, then review `CORE-OD-03` and `04`; do not approve technical calculation around missing tax/rounding policy.
4. Review `CORE-OD-08A`–`10C` in the scenario groups in §4.5 while keeping progress, completion, handover, cancellation consequences, Refund and Order closure independently selectable.
5. Review `CORE-OD-11A`–`D`, `CORE-OD-12`, `CORE-OD-13`, `CORE-OD-14A`–`B` and `CORE-OD-15A`–`B` in dependency order while keeping Cash configuration, capabilities, corrections, handover decisions, discrepancy resolution and report release independently selectable.
6. Review `CORE-OD-16A`–`F` after the authoritative source set is agreed; metrics approval must not imply read, export, delivery or retention authority.

| Review group | References | Blocking effect |
|---|---|---|
| CORE-01 calculation | `CORE-OD-03`, `04` | Blocks Gate A approval of an executable calculation baseline; qualified evidence required. |
| CORE-01 bounded exclusions | `CORE-OD-05`, `17A`–`17C` | Each becomes nonblocking if explicitly excluded from the first slice; inclusion blocks until its policy is complete. |
| CORE-01 channel/access | `CORE-OD-06`, `07` | Channel contract blocks the full dine-in/takeaway API. `CORE-OD-07` does not block the cash-only first slice, but manual-bank inclusion requires that decision plus separately authorized trusted operator/capability support. CORE-03 remains unauthorized. |
| CORE-02 progress/fulfillment | `CORE-OD-08A`–`08C`, `10A`–`10B` | Blocks CORE-02 lifecycle Gate A; does not block CORE-01 sale/settlement. |
| CORE-02 cancellation/closure | `CORE-OD-09A`–`09D`, `10C` | May defer cancellation execution and terminal closure; `P1A-OD-07` remains deferred. |
| CORE-04 Cash | `CORE-OD-11A`–`15B` | Blocks CORE-04 Gate A and full-day Cash operations; does not block a bounded sale/settlement design review. |
| CORE-05 Reporting | `CORE-OD-16A`–`16F` | `16A` permits staged source-lineage design; implementation remains blocked by upstream facts and all authority/retention decisions. |

For every row the Owner may `APPROVE` one option, `DEFER`, or `APPROVE_WITH_WRITTEN_CONDITION`. A directional selection records business policy only. It does not accept this technical design, grant Gate A, authorize Gate B preparation where otherwise prohibited, authorize implementation, or grant FOA/Production Authorization.

## 14. Validation and final boundary

This package records the Owner-confirmed `CORE-OD-01` menu baseline by reference with `ID_PENDING_OWNER_GOVERNANCE`. It introduces no canonical ID or other Owner decision and no schema, migration, constraint, code, test, dependency, API, runtime behavior, database operation, external contact, disclosure, commissioning, Gate, Control Acceptance, FOA or Production Authorization.

Current classifications remain:

- Catalog Package B and Order/Payment Phase 1: merged bounded foundations, not authority for new work;
- Identity I1: Gate A/B/C approved only for ancestry;
- Identity Milestone 2B: unauthorized;
- CORE-01: ready for independent Gate A review, but not Gate A approval; blocking policy/evidence remains;
- CORE-02/04/05: design proposals requiring Owner decisions and applicable Gate A/B;
- CORE-03: remains outside this closure and unauthorized for implementation;
- Inventory: deferred from this milestone, with future boundaries preserved.

**Final status:** `CORE_01_INDEPENDENT_GATE_A_REVIEW_CANDIDATE_PREPARED — CORE_02_04_05_OWNER_REVIEW_PREPARED — ZERO_GATES_GRANTED — ZERO_IMPLEMENTATION_AUTHORIZED`.
