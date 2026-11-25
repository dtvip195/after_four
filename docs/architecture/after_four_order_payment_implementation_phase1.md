# AFTER FOUR — Order Lifecycle & Payment Safety Implementation

**Status:** Implemented backend command foundation; Ordering Phase 1, Payment Phase 2 and eligible Preparation Phase 3 Dispatch migrations complete; Phase 4 cross-context conformance verified; Ticket/Ticket Item design, public mutation API and frontend integration deferred
**Date:** 2026-11-14; Payment Phase 2, Preparation Phase 3 and cross-context Phase 4 updates 2026-11-26
**Scope:** Order creation/confirmation/hold/expiration, exact-balance cash and manual bank-transfer confirmation, late-success review, payment-gated preparation dispatch, audit evidence, and transactional outbox persistence

**Decision references:** [Owner Decision Baseline](after_four_owner_decision_baseline.md) · [DDD Foundation](after_four_ddd_foundation.md) · [Payment Model](after_four_payment_model.md)

The Owner-confirmed excess-received outcome does not alter this implementation record: Phase 1 still enforces exact-balance settlement. Future excess/refund evidence and Cash/Expense/Reporting workflows require separate design and authorization.

## 1. Scope decision

The repository has no implemented Identity/authorization context and no server-side catalog/pricing workflow. The Owner therefore approved a narrowed seam: implement tested backend commands and PostgreSQL constraints, but do not expose public mutation endpoints or connect the frontend until those trust dependencies exist.

Only `/health/live` and `/health/ready` remain routed. The logical paths in the [API Contract](after_four_api_contract.md) are planned contracts, not active endpoints.

## 2. Implemented records and states

| Record | Implemented states / purpose |
|---|---|
| Order | `draft`, `confirmed`, `held`, `expired`, with reserved `cancelled` and `closed`; optimistic `lock_version`; confirmation/payment deadlines; Branch-scoped creation idempotency key and durable request fingerprint |
| Payment | Independent `funding_status` and `attempt_activity`; exact-balance-only Phase 1 commands |
| Payment Attempt | `initiated`, `pending`, `unknown`, `succeeded`, `failed`, `cancelled`; Phase 1 writes terminal cash/manual-bank evidence |
| Preparation Dispatch | Unique pending/dispatched handoff per Order; Phase 1 creates the durable pending identity only |
| Payment Review Case | Open `late_success` exception for settlement after expiration or while held |
| Outbox Event | Unique durable `preparation.dispatch_requested` event committed with eligible settlement |
| Audit Event | Actor/system-attributed event evidence with command idempotency identity and safe metadata |

Opaque `branch_id` and actor UUIDs intentionally preserve future references without creating Identity/Branch tables. Command callers must supply a trusted actor reference; the commands do not authenticate it. Controller activation is blocked until server-side authentication, branch authorization, and actor derivation exist.

Payment terminology is exact in Phase 1: `Payment`/`payments` is the one-per-Order settlement aggregate; `PaymentAttempt`/`payment_attempts` is one cash or manual-bank attempt and outcome. No `PaymentTransaction` model or `payment_transactions` table exists. That older name is retained only inside explicitly historical proposals for a richer future attempt record and does not identify a parallel implemented concept.

Idempotency is likewise scoped: draft-creation command identity is stored on Order; payment-confirmation command identity is the Payment Attempt's unique `(payment_id, idempotency_key)`; Payment itself has no command idempotency column; Audit and Outbox records use their own derived evidence/delivery identities. These keys are related by one transaction but are not interchangeable.

## 3. Command seams

- `Orders::Application::UseCases::CreateDraft`: atomically creates Draft Order, Unpaid/Idle Payment, and audit evidence. The key is scoped by Branch; same-key/same-fingerprint calls replay the original complete result, while same-key/different-fingerprint calls raise `idempotency_conflict`. A concurrent unique-index loser re-reads the committed winner and applies the same comparison. `total_amount` is a trusted internal input until server-side item pricing exists.
- `Orders::Application::UseCases::Confirm`: Draft → Confirmed with optimistic version guard and configurable payment deadline.
- `Orders::Application::UseCases::ExpirePending`: Confirmed/Unpaid → Expired at the exact deadline; `ExpirePendingOrdersJob` obtains it from `OrderingComposition` every minute in development/production.
- `Orders::Application::UseCases::Hold`: Confirmed/Unpaid → Held with actor, reason, and idempotent audit evidence.
- `Payments::Application::UseCases::ConfirmSettlement`, assembled by `PaymentComposition.confirm_cash` and `PaymentComposition.confirm_bank_transfer`: records explicit exact-balance verification under Order-then-Payment locks and samples authoritative decision time only after both locks are held.
- `Preparation::Application::UseCases::RequestDispatch`: defense-in-depth recovery workflow composed through `PreparationComposition`; it locks Order then Payment before sampling decision time and delegates eligibility decisions to the owning Ordering and Payment adapters.
- `Preparation::Application::UseCases::RetryDispatch`: locks the existing pending Dispatch through the Preparation repository and requeues its existing Outbox Event through the Preparation-owned Outbox port. It clears `published_at` and appends idempotent Audit evidence without charging again, creating another Dispatch/Outbox identity, or inserting a Dispatch Attempt.
- `Preparation::Application::UseCases::RecordSettlementDispatch`: records the unique pending Dispatch and Outbox intent inside the Payment-owned ambient transaction; it does not open an independent transaction.

No bank credentials, bank API tokens, PINs, passwords, or raw banking notification payloads are stored. Manual bank confirmation records only method, amount, currency, trusted actor reference, and time.

### 3.1 Ordering Layered DDD implementation

Ordering Phase 1 now places creation and lifecycle rules in `Orders::Domain::Aggregates::Order` and uses context-local `OrderId`, `OrderNumber`, `Money`, `ServiceChannel`, and `PaymentWindow` Value Objects. Domain construction and reconstitution validate Order, Branch and actor identity shape; required Order number, creation key and SHA-256 fingerprint evidence; nonnegative lock version; required timestamps; channel, Money, status and lifecycle evidence. `OrderNumber.generate` owns the existing `AF-` plus twelve-uppercase-hexadecimal format while injected Infrastructure entropy remains outside Domain. The Domain has no Rails, Active Record, PostgreSQL, Payment, or Preparation dependency. It retains Draft, Confirmed, Held, and Expired behavior; reserved persisted statuses remain readable without adding a new transition.

`Orders::Application::UseCases::{CreateDraft,Confirm,Hold,ExpirePending}` coordinate the Aggregate through Ordering-owned repository, audit, transaction and Payment-fact contracts. `CreateDraft` invokes injected UUID and Order-number-token generators only after it has excluded replay, then asks Domain to create the Draft; its repository port contains no persistence-validation operation. The consumer-owned `Orders::Application::Ports::PaymentGateway` describes only Ordering's current required Payment capabilities: create the existing Phase 1 target, recover its reference and obtain a locked funding-status snapshot. The Payment-owned `Payments::Infrastructure::Adapters::OrderingPaymentGateway` implements that interface without moving Payment rules or records into Ordering. Top-level `OrderingComposition` wires this target-creation seam. The adapter joins the ambient local transaction and opens no independent transaction. This unchanged consumer contract does not resolve `OPP-ARCH-15`.

`Orders::Infrastructure::Persistence::OrderRecord` remains mapped to the existing `orders` table. `OrderMapper`, `ActiveRecordOrderRepository`, and `ActiveRecordUnitOfWork` isolate persistence and preserve PostgreSQL optimistic locking, unique constraints, candidate ordering, Order-before-Payment locking, and rollback behavior. `ActiveRecordOrderRepository#save` accepts only an Aggregate previously obtained through `lock` on that repository instance; it does not fall back to an unlocked record lookup. Database-aligned record validations remain defense in depth; Application does not invoke them as aggregate validation. The redundant top-level `Order` Active Record class and its cross-context associations have been removed. Payment obtains a locked Ordering Aggregate through the Ordering-owned `OrderSettlementGateway`; Preparation obtains only its required locked identity/scope and eligibility answer through the Preparation-owned `OrderDispatchGateway`, implemented by Ordering Infrastructure. These adapters are wired only at top-level composition roots; only Payment invokes the Ordering save operation after an Ordering Domain transition. `OrderRecord` remains the sole Ordering Infrastructure persistence model. No table, column, constraint, trigger or foreign key changed.

The former `Orders::{CreateDraft,Confirm,Hold,ExpirePending}` compatibility facades have been removed. Production callers use the four Application Use Cases assembled by top-level `OrderingComposition`; no legacy result projection or Active Record error translation remains. Hold-reason validity is owned only by the Aggregate, so direct Application callers acquire Order then Payment locks before that rule is evaluated. Architecture enforcement rejects reintroduction of removed Ordering, Payment and Preparation facade files/constants. Preparation's implemented Dispatch workflows are now migrated; future Ticket/Ticket Item work remains separately bounded by `OPP-ARCH-16`.

`Orders::Application::UseCases::Confirm` intentionally locks only Order before sampling its confirmation decision time. Payment is created with the Draft and confirmation neither reads nor mutates Payment state. Every implemented workflow that can mutate or make a decision from Payment state—Payment confirmation, Hold, expiration, and Preparation dispatch—first acquires the same Order lock and then the Payment lock. The Order lock therefore serializes those workflows against Draft → Confirmed without a second lock in confirmation: a Payment workflow that wins first observes Draft and cannot settle/dispatch it; one that waits observes the committed confirmation evidence. Adding a Payment lock to Order confirmation would protect no additional current invariant. The earlier remediation expectation that every confirmation decision required Order → Payment locks was overly broad; Order → Payment remains mandatory only for workflows that consume or mutate Payment state. This conclusion records verified Phase 1 behavior, not a new business rule or Payment design authorization.

The architecture dependency spec uses Prism AST inspection, normalized constant aliases, known persistence-model identities, call-receiver chains and eager-load/join association symbols to reject direct persistence, Infrastructure, framework, and prohibited cross-context dependencies. Domain/Application source remains framework- and cross-context-independent; Ordering Infrastructure is separately inventoried and may not reference Payment or Preparation Domain/Application/Infrastructure. Top-level composition roots are the only current concrete cross-context wiring points; port implementation and signature checks cover the Payment and Preparation seams. The persistence-call inventory includes chained reads, bulk writes and transaction entry points. This remains static source analysis, not complete Ruby semantic analysis: it cannot prove behavior assembled through `eval`, reflective `const_get`, runtime monkey-patching, dynamically generated method names, or types hidden solely behind arbitrary local variables. Those techniques are not used by the inspected target layers; runtime integration tests and code review remain required alongside the scanner.

This migration does not implement Order Items, sold-price snapshots, Pricing, a public mutation endpoint, an outbox publisher, or Preparation Tickets/Items. It does not resolve `OPP-ARCH-13` through `OPP-ARCH-16` and introduces no schema or migration change.

### 3.2 Payment Layered DDD implementation

Payment Phase 2 places settlement invariants in the pure-Ruby `Payments::Domain::Aggregates::Payment`, with `PaymentAttempt` as its current evidence entity and context-local Payment identifiers and Money. The Aggregate owns exact-balance settlement, Payment state, Attempt replay/conflict handling, reconciliation fail-closed behavior, successful and mismatch evidence, and terminal Attempt immutability. It reconstitutes through invariant-validating constructors and has no Rails, Active Record, Ordering, Preparation, or composition dependency. `Payment Review Case` placement remains deliberately outside the Aggregate pending `OPP-ARCH-14`; the current narrow gateway preserves existing review behavior without deciding that boundary.

`Payments::Application::UseCases::ConfirmSettlement` validates explicit input and coordinates the Order lock, Payment lock, authoritative post-lock time, Domain transition, Preparation-owned Dispatch contract, late-success review contract, audit contract, and one ambient Unit of Work. Ordering retains Dispatch eligibility in its Aggregate; Payment retains full-settlement truth in its Aggregate; Preparation owns Dispatch identity in its Aggregate and Dispatch/Outbox orchestration in its Application use case. Payment Application receives only context-owned contracts and no persistence records. `PaymentComposition` and `PreparationComposition` are the explicit top-level wiring points and preserve the existing result contract for cash and manual-bank confirmation.

`Payments::Infrastructure::Persistence::{PaymentRecord,PaymentAttemptRecord,PaymentReviewCaseRecord}` map the unchanged `payments`, `payment_attempts`, and `payment_review_cases` tables. `PaymentMapper`, `ActiveRecordPaymentRepository`, and `ActiveRecordUnitOfWork` isolate persistence; repository save requires a Payment previously acquired under its lock. Existing PostgreSQL uniqueness, composite foreign keys, optimistic lock, exact-total constraint triggers, and terminal-evidence trigger remain unchanged. `ActiveRecordAuditLog` and `ActiveRecordReviewCaseGateway` preserve existing evidence semantics. The Payment-owned Ordering target adapter and Preparation settlement-snapshot adapter implement consumer-owned contracts without exposing Payment records.

The legacy Payment facades and redundant top-level Payment Active Record classes were removed in Phase 2. Preparation Phase 3 likewise removes `Preparation::{RequestDispatch,RetryDispatch}` and the redundant top-level `PreparationDispatch` and `PreparationDispatchAttempt` Active Record classes after callers and tests moved to composition, Application use cases, Domain objects and namespaced Infrastructure records. Required physical persistence remains through `Preparation::Infrastructure::Persistence::{DispatchRecord,DispatchAttemptRecord}`. Explicit identifiers and contracts carry every cross-context integration. This completion preserves current target creation while leaving `OPP-ARCH-15` open, preserves current review persistence while leaving `OPP-ARCH-14` open, emits no new event-version design under `OPP-ARCH-13`, and does not create or decide Ticket boundaries under `OPP-ARCH-16`.

### 3.3 Preparation Layered DDD implementation

Preparation Phase 3 places implemented Dispatch identity, lifecycle evidence and retry eligibility in the pure-Ruby `Preparation::Domain::Aggregates::Dispatch`, with a context-local `DispatchId` and explicit `RuleViolation`. Construction and reconstitution validate UUID identities, status, idempotency identity, timestamps, nonnegative lock version and the relationship between `pending`/`dispatched` state and `dispatched_at`. No Ticket, Ticket Item, acceptance-attempt or custody-transfer Aggregate is introduced.

`Preparation::Application::UseCases::{RecordSettlementDispatch,RequestDispatch,RetryDispatch}` coordinate the three existing workflows. `RecordSettlementDispatch` joins the Payment-owned ambient transaction and creates no transaction of its own. The defense-in-depth `RequestDispatch` acquires Order then Payment locks, samples time afterward, and asks Ordering and Payment adapters to evaluate their context-owned eligibility. `RetryDispatch` locks the Dispatch first, requires the Domain's pending-state guard, locks/requeues the existing Outbox identity, and appends exact semantic retry evidence. Preparation-owned ports cover Dispatch persistence, Ordering eligibility, Payment settlement, Outbox, Audit and unit-of-work behavior without exposing records.

`Preparation::Infrastructure::Persistence::{DispatchRecord,DispatchAttemptRecord}` map the unchanged physical tables. `DispatchMapper`, `ActiveRecordDispatchRepository` and `ActiveRecordUnitOfWork` isolate persistence and preserve optimistic locking, unique Order/command identities, lock-first save behavior and rollback. `ActiveRecordOutbox` and `ActiveRecordAuditLog` implement the technical-evidence ports. `ActiveRecordSettlementDispatchGateway` delegates Payment integration to the Preparation Application use case without opening a nested transaction. Ordering and Payment Infrastructure implement the Preparation-owned fact contracts; Preparation Domain/Application load neither context nor its persistence.

The `preparation_dispatch_attempts` record remains reserved and has no writer. Outbox publication, semantic acceptance, Ticket/Ticket Item creation and customer custody transfer have no production caller or implemented workflow in this phase. Their exact aggregate boundary, acceptance identity/evidence and lifecycle orchestration depend on `OPP-ARCH-16` and other recorded policy inputs; the required Owner decision is the future Ticket/Ticket Item aggregate boundary, not a reinterpretation of the current Dispatch Aggregate. Characterization and architecture tests reject reintroduction of the removed facades/models and preserve the deferred boundary.

### 3.4 Phase 4 cross-context conformance

The Phase 4 audit verified the complete implemented dependency direction. Each Domain depends only on its own context. Ordering and Preparation Application depend only on their own Domain and owned ports; Payment Application depends on its own Domain and owned ports while its injected Order and Dispatch collaborators remain abstract operation-specific capabilities rather than concrete context dependencies. Cross-context implementations exist only in Infrastructure: Payment implements Ordering's Payment contract, Ordering implements Preparation's Order eligibility contract, and Payment implements Preparation's settlement contract; Preparation implements its own Dispatch contract supplied to Payment. Top-level composition roots assemble those adapters and use cases. No context loads or mutates another context's Active Record record, no cross-context Active Record association exists, and no removed facade or top-level persistence model is a production entry point.

Architecture enforcement now inventories cross-context references symmetrically for Ordering, Payment and Preparation Infrastructure. An allowlisted adapter may reference only the consumer-owned `Application::Ports` namespace it implements; namespaced persistence, Domain, association, alias and chained-query fixtures prove prohibited paths are rejected for every context pair. Composition verification also compares every wired adapter's public operation shape with its owning port and boots all three composition roots. This audit found overly broad Ordering Audit and Unit-of-Work port declarations; their signatures were narrowed to the already implemented operations without changing runtime behavior.

The implemented transaction graph remains unchanged. Draft creation atomically covers Order, Payment target and Audit. Settlement locks Order then Payment, samples time after both locks, and atomically covers Payment, Payment Attempt, eligible Dispatch, Outbox, Review Case where applicable, and Audit. Preparation recovery locks Order then Payment and atomically covers Dispatch, Outbox and Audit; retry locks Dispatch then the existing Outbox and atomically records the requeue and Audit. Existing PostgreSQL failure-injection, concurrent creation/confirmation/retry, deadline-race and stale-write tests verify rollback, uniqueness and optimistic locking. No adapter opens an independent transaction inside a coordinating ambient transaction.

This conformance result covers only implemented workflows. It does not implement an Outbox publisher, delivery-attempt writer, Preparation Ticket, semantic acceptance or custody-transfer workflow, and it does not resolve `OPP-ARCH-13` through `OPP-ARCH-16`. The architecture scanner is static source evidence rather than proof against arbitrary runtime reflection; reflective constant lookup, `eval` and runtime monkey-patching are absent from the inspected contexts and remain prohibited review risks.

### 3.5 Phase 5 final legacy cleanup

The final backend-wide inventory found no remaining obsolete Ordering, Payment, or Preparation service implementation, command facade, top-level Domain Active Record model, duplicate repository, callback, job, or production caller. Phase 5 removed only two proven leftovers: the unused `OrderSettlementGateway` exposure from `OrderingComposition::Dependencies` (the required adapter remains wired by `PaymentComposition`) and the global `TrustedActor` helper after Preparation adopted context-owned input validation with unchanged error semantics. Architecture guards reject either dependency from returning.

`ApplicationRecord`, `AuditEvent`, and `OutboxEvent` remain shared Rails technical persistence records. Namespaced Ordering, Payment, and Preparation records remain required Infrastructure. `DispatchAttemptRecord` remains reserved physical scaffolding with no production writer; deleting or activating it would exceed this cleanup and the deferred worker/Ticket boundaries. Existing payment integration specs under `spec/services/payments` and persistence specs under `spec/models` remain test-only regression evidence that invokes canonical composition/Application entry points rather than removed production services.

## 4. Atomic safety boundary

For an eligible settlement, one PostgreSQL transaction:

1. locks Order then Payment;
2. rejects or replays the scoped idempotency identity;
3. validates exact target and currency;
4. records the successful Payment Attempt and `fully_paid/idle` Payment;
5. samples authoritative decision time after both locks are held and rechecks that Order is Confirmed and `decision_time < payment_expires_at`;
6. creates the unique pending Preparation Dispatch, outbox event, and audit event;
7. commits before any external delivery.

Unique constraints on payment attempt identity, one Dispatch per Order, scoped dispatch identity, audit identity, and outbox event key provide database backstops. Composite foreign keys additionally require each Dispatch to use the Payment belonging to its Order and the Branch recorded by that Order, and require each Payment Review Case to use a mutually consistent Order, Payment, and Payment Attempt. Concurrent confirmation tests exercise real PostgreSQL row locking.

At or after the deadline, or while Held/Expired, verified success is retained as financial truth and an open late-success review case is created. No Dispatch/outbox is created and the Order is not reactivated.

For settlement and dispatch decisions, authoritative decision time means the time sampled inside the transaction after the required Order→Payment locks have been acquired. For Order confirmation, it means the time sampled after its required Order lock as recorded in §3.1. Command-start time is never confirmation or dispatch authority. Production callers use the default system clock; injected clocks exist for deterministic command-seam tests and must not be populated from client input.

Draft creation fingerprint version `after_four.order.create.v1` includes the trusted actor UUID lowercased, the validated lowercase channel, integer stored-unit total, and uppercase currency. `branch_id` scopes the key instead of being repeated in the digest. Request time, generated Order UUID, and generated Order number are excluded. SHA-256 stores only the 64-character digest, not a raw request payload. The unique `(branch_id, creation_idempotency_key)` index remains the final concurrency backstop.

Once a Payment Attempt is already `succeeded`, `failed`, or `cancelled`, its payment identity, status, amounts, method, currency, idempotency identity, confirming actor/time, and failure evidence are immutable. Rails callbacks reject normal mutations and a PostgreSQL trigger rejects callback-bypassing or direct SQL updates. The trigger protects ordinary database sessions but does not claim protection from a database superuser or an owner that disables/drops enforcement.

A `succeeded` Payment Attempt is also subject to a row-local PostgreSQL check requiring confirming actor, confirmation time, confirmed amount equal to requested amount, and no failure code. Deferred constraint triggers serialize on the Payment row at transaction end and require `payments.successful_amount` to equal the sum of succeeded Attempt amounts; `fully_paid` additionally requires that sum to equal `target_amount`. Deferral permits the Attempt and Payment aggregate to change atomically while preventing either write order from committing a mismatched state. This is an exact-balance Phase 1 integrity mechanism, not approval of partial/split payment behavior.

Dispatch retry replay requires an Audit Event with the retry event type, `PreparationDispatch` subject type, matching Dispatch subject, Branch, and idempotency identity. An unrelated Audit Event that collides on the unique Branch/idempotency key is not treated as success: PostgreSQL raises the uniqueness error and the Outbox update rolls back.

Audit Events are append-only through two implemented layers. The `AuditEvent` model rejects ordinary instance update/destruction, while PostgreSQL trigger `audit_events_append_only` rejects every row-level `UPDATE` or `DELETE` with an error, including bulk and direct SQL paths. `INSERT` and `SELECT` remain available, and an inserted event still rolls back with its parent business transaction. This is not absolute immutability: a table owner or superuser can disable/drop the trigger, alter the function, truncate the table, or change privileges.

## 5. Configuration and operations

`ORDER_PAYMENT_WINDOW_SECONDS` controls the payment window and defaults to `300`. Rails reads and validates it once while each process loads application configuration. An explicit value must parse as a base-10 positive integer; zero, negative, blank/whitespace-only, decimal, non-numeric, and values whose boot-time deadline exceeds PostgreSQL's `timestamptz` range raise a configuration error and stop boot. An invalid explicit value never falls back to `300`. This representability guard follows the PostgreSQL 18 timestamp range and is not a business-policy upper bound. Times are stored as `timestamptz` and handled in UTC. Money uses integer stored units plus a three-character currency code.

Solid Queue schedules expiration scans. The outbox delivery consumer and preparation-ticket/KDS creation are deliberately not implemented; pending events remain durable for a later authorized phase.

The `preparation_dispatch_attempts` table and namespaced `DispatchAttemptRecord` exist as reserved physical scaffolding for the deferred delivery worker design. No implemented command writes that record. Attempt numbering, start/success/failure outcome capture, and delivery-error recording remain planned behavior and must not be inferred from `Preparation::Application::UseCases::RetryDispatch`.

## 6. Verification map

RSpec covers draft creation replay, normalized fingerprinting, payload conflicts, real concurrent same/different-payload races, database uniqueness, cash and bank-transfer success, incorrect amount and replay, pending/failed/unknown guards, before/equal/after-deadline decisions, lock waits across the deadline, expiration racing with confirmation, Held/Expired late success, no automatic reactivation, missing actor, idempotent and concurrent confirmation, retry identity, outbox rollback/recovery, legitimate non-terminal Attempt transition, terminal-evidence rejection through Rails/callback-bypassing updates/direct SQL, succeeded-evidence checks, aggregate composite foreign keys, deferred settlement-total rollback, and concurrent aggregate rejection. Tests use PostgreSQL records and constraints rather than mocks of internal domain behavior.

### 6.1 M-03 concurrency and failure evidence

The matrix records the state found before M-03 changes and the closing evidence. `Partially covered` means implementation appeared atomic but one or more required failure/race paths had no executable evidence.

| Scenario | Initial classification | Existing evidence inspected | Gap and closing evidence | Final result |
|---|---|---|---|---|
| M-03.1 expiration racing with confirmation | Covered | `deadline_concurrency_spec.rb` uses independent connections and barriers; both commands lock Order then Payment. The committed outcome is Expired Order plus recorded late settlement/review, with no Dispatch/Outbox. | No new implementation or test required. | Covered |
| M-03.2 lock contention crossing deadline | Covered | H-01 tests hold the Order lock, move the injected clock across the deadline, then release it for payment confirmation and dispatch request. | No new implementation or test required; decision time remains sampled after required locks. | Covered |
| M-03.3 Audit Event insertion failure | Partially covered | Draft creation already proved rollback for an Audit unique collision; settlement proved Outbox failure rollback. | PostgreSQL failure injection now proves rollback and clean retry for draft creation, eligible settlement, late success, expiration, and hold. Assertions cover Order, Payment, Attempt, Review Case, Dispatch, Outbox, Audit, and idempotent retry cardinality. | Covered |
| M-03.4 Outbox/Audit failure during dispatch | Partially covered | Eligible settlement already tested an Outbox insert failure and retry. | Added complete evidence assertions plus failure injection for Request Dispatch Outbox insert, Request Dispatch Audit insert, Retry Dispatch Outbox update, and Retry Dispatch Audit insert. Every failure propagates and rolls back prior writes. | Covered |
| M-03.5 concurrent dispatch retries | Partially covered; defect found while closing | Sequential same-key retry preserved one Dispatch/Outbox. | Independent connections are deterministically blocked on the Dispatch row; one caller performs the retry and the other replays it. A red test found that unrelated Audit key collisions were incorrectly accepted as replay; semantic replay matching now lets the unique violation propagate and rolls back the Outbox change. | Covered |
| M-03.6 concurrent draft creation | Partially covered | M-01 already covered same key/same payload and same key/different payload, including one Order/Payment/Audit aggregate. Unrelated keys were only sequential. | Added a deterministic two-connection race proving two unrelated keys create two complete, independent Order/Payment/Audit aggregates. | Covered |

Failure triggers used by these specs exist only inside test transactions and are removed in `ensure`; no production trigger or migration was added. Concurrency tests use queues, PostgreSQL row/table locks, and `pg_stat_activity` wait evidence rather than timing sleeps.

### 6.2 M-04 Audit Event append-only enforcement

| Layer/principal | Verified state | Permitted | Rejected or limitation |
|---|---|---|---|
| Rails model | `before_update` and `before_destroy` remain active | Create and query | Instance `update!`/`destroy!` are rejected before SQL mutation |
| PostgreSQL table enforcement | `BEFORE UPDATE OR DELETE` trigger raises SQLSTATE `23514` | Insert, select, multi-row transaction insert, transaction rollback | `update_columns`, `update_all`, `delete_all`, and direct SQL UPDATE/DELETE are rejected |
| Current development/test role | One `postgres` role is session user, superuser, and `audit_events` owner; it has SELECT/INSERT/UPDATE/DELETE/TRUNCATE/TRIGGER | Schema migration and runtime development operations | It can deliberately disable/drop enforcement and therefore is not production least-privilege evidence |
| Required production topology | Not implemented by Phase 1 | Runtime role should retain only required connection/schema usage plus Audit Event INSERT/SELECT | Runtime role must be distinct from schema owner/migration administration and unable to alter triggers/functions/ownership or truncate the table; exact grants require approved deployment design and verification |

No Phase 1 workflow depended on Audit Event mutation or deletion. Full command regression covers draft creation, confirmation, expiration, hold, eligible/late settlement, preparation dispatch, and dispatch retry under the database trigger. Nontransactional test cleanup uses an explicitly named test-owner helper to exercise the current privileged development role; it is not application code or a production cleanup design.

### 6.3 L-01 Dispatch retry documentation reconciliation

| Source | Prior/current statement | Actual Phase 1 implementation | Correction/classification |
|---|---|---|---|
| Migration and `structure.sql` | `preparation_dispatch_attempts` table, FK, status check, and unique indexes exist | Physical schema exists | Retained as reserved scaffolding; schema existence does not prove runtime writes |
| Persistence | Namespaced `DispatchAttemptRecord` and Dispatch association exist | Record exists; no production writer references it | Retained as reserved scaffolding without implying delivery-attempt behavior |
| `Preparation::Application::UseCases::RetryDispatch` | Requeue use case for a pending Dispatch | Locks existing Dispatch and Outbox Event; resets the same Outbox Event to pending/available, clears publication time, and appends one semantic Audit Event | Source of truth for implemented retry behavior; explicitly records zero Dispatch Attempt rows |
| Retry specs | Assert one Dispatch, one Outbox identity, one successful Payment Attempt, and idempotent Audit evidence | No assertion or setup creates a Dispatch Attempt; references are cleanup only | Implemented behavior evidence; no artificial attempt test added |
| Data Integrity Rules | Previously said retry/error state “is appended” to Dispatch Attempts | No such append occurs | Corrected to Phase 1 Outbox/Audit behavior; attempt outcomes marked deferred `TECHNICAL_PROPOSAL` |
| Data Dictionary and ERD | Attempt record labeled `TECHNICAL_PROPOSAL`; physical/writer status was implicit | Table/model exist but are unused by Phase 1 commands | Added explicit reserved-schema/no-writer note while preserving proposal history |
| State Machines | Target worker flow appends failed/numbered attempt outcomes | Worker, tickets, and attempt outcome capture are not implemented | Target transitions remain historical/planned design and are explicitly separated from current Retry Dispatch |
| Rails/PostgreSQL readiness material | Proposed attempts/worker as later implementation inputs | Planning evidence, not Phase 1 completion evidence | Retained as historical proposal; no status promoted |

No implementation defect requiring a new writer was found. L-01 is resolved as documentation-only: no model, table, migration, event, counter, idempotency rule, or business behavior was added.

### 6.4 L-02 payment terminology reconciliation

| Source | Previous/current term | Intended meaning | Physical implementation | Resolution |
|---|---|---|---|---|
| Business Domain Model, API Contract, State Machines | Payment / Payment Attempt | Settlement aggregate versus one attempt/outcome | `Payment` and `PaymentAttempt` | Canonical terminology retained |
| Rails models and associations | `Payment`, `PaymentAttempt`, `payment_attempts` | One Payment per Order; many Attempts per Payment | Implemented | Physical source of truth |
| PostgreSQL | `payments`, `payment_attempts` | Aggregate and attempt rows | Implemented; no `payment_transactions` relation | Physical names stated explicitly |
| Payment Model | Payment Attempt annotated as `payment_transactions` | One attempt lifecycle | Annotation could be mistaken for a physical table | Corrected to `payment_attempts`; legacy mapping documented |
| Data Dictionary and ERD | `payment_transactions` | Older richer logical attempt proposal | No matching table/model | Canonicalized to Payment Attempt; deferred enrichment preserved separately |
| Data Integrity Rules | Mixed Payment Transaction/Payment Attempt wording | Attempt outcome/history | Phase 1 protects Payment Attempt rows | Canonicalized to Payment Attempt |
| Historical design, planning, and readiness findings | PaymentTransaction/`payment_transactions` | Earlier proposal vocabulary | Not implementation evidence | Preserved under existing historical/proposal labels; readiness receives a resolution note |

`Payment Transaction` is not a second aggregate, abstraction, model, association, or table. `Cash Transaction` remains a separate future cash-ledger concept and is not renamed. No runtime identifier or schema object changed for L-02.

### 6.5 L-03 payment-window configuration validation

| Audit question | Prior behavior | Corrected behavior |
|---|---|---|
| Read location and time | `config/application.rb` read `ORDER_PAYMENT_WINDOW_SECONDS` while the Rails application class loaded | The same boot-time seam remains; parsing and validation are localized in `Platform::PaymentWindowConfiguration` |
| Missing variable | `ENV.fetch` supplied `300` | Default remains exactly `300` seconds |
| Parsing | Ruby `Integer(...)` rejected malformed/decimal input but accepted zero, negative values, and arbitrary-size integers | Explicit values must be base-10 positive integers |
| Invalid explicit value | Some malformed values stopped boot, but zero/negative/oversized values could reach deadline calculation | Every invalid class raises a named configuration error containing the variable name but not its raw value; no fallback occurs |
| Runtime changes | Value was captured in Rails configuration at process load | Still captured once; changing the process environment after boot does not reconfigure a running process |
| Upper limit | No declared business or technical upper bound | No business-policy duration cap was invented; only PostgreSQL `timestamptz` deadline representability is checked at boot |

RSpec covers absent/default, a valid configured value, zero, negative, blank/whitespace-only, non-numeric, decimal, an unrepresentable integer, real process boot success/failure, and exact application of a configured window to Order confirmation. Existing deadline-decision and lock-contention specs continue to prove that settlement/dispatch decision time is sampled after the Order→Payment locks and that equality remains late; L-03 does not modify H-01 semantics.

## 7. Deferred dependencies and exclusions

- Identity authentication, server-side capabilities, Branch assignment enforcement, and session context (Milestone 2B remains separately governed).
- Catalog items and server-authoritative pricing remain unimplemented. The later Owner-confirmed Catalog/Pricing MVP decisions are recorded in [Owner Decision Baseline §5](after_four_owner_decision_baseline.md#5-catalogpricing-mvp); they do not retroactively change this Phase 1 implementation.
- Amendments, cancellation, refund, partial/split payment, and review-case resolution.
- Provider/bank API matching, outbox publisher, Preparation Ticket/KDS, table sessions, inventory, shifts, reports, and frontend integration.
- Production separation of runtime, migration/schema-owner, and administrative database roles; the Phase 1 trigger is implemented, but least-privilege grants and proof that the runtime role cannot change enforcement remain deployment prerequisites.

No new Owner business decision is inferred here. The five-minute duration remains a configurable MVP default. Review-case resolution authority and outcomes require a later explicit policy/implementation phase.

Phase 1 continues to create the Payment atomically with Draft creation. Whether Payment should instead be created at Order confirmation is a separate, unresolved design question; the Catalog/Pricing decision closure neither approves nor implements that change.

## 8. Canonical references

- [Business Domain Model](after_four_business_domain_model.md)
- [Payment Model](after_four_payment_model.md)
- [State Machines](after_four_state_machines.md)
- [Data Integrity Rules](after_four_data_integrity_rules.md)
- [API Contract](after_four_api_contract.md)
- [ADR-0007: Background jobs and outbox](adr/0007-background-jobs-and-outbox.md)
- [ADR-0009: API conventions](adr/0009-api-conventions-versioning.md)
- [ADR-0010: Database migrations and schema](adr/0010-database-migrations-and-schema.md)
