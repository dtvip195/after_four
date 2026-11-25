# AFTER FOUR — Order Lifecycle & Payment Safety Implementation Phase 1

**Status:** Implemented backend command foundation; Ordering Layered DDD migration complete; Payment/Preparation migration, public mutation API and frontend integration deferred
**Date:** 2026-11-14  
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

- `Orders::CreateDraft`: atomically creates Draft Order, Unpaid/Idle Payment, and audit evidence. The key is scoped by Branch; same-key/same-fingerprint calls replay the original complete result, while same-key/different-fingerprint calls raise `idempotency_conflict`. A concurrent unique-index loser re-reads the committed winner and applies the same comparison. `total_amount` is a trusted internal input until server-side item pricing exists.
- `Orders::Confirm`: Draft → Confirmed with optimistic version guard and configurable payment deadline.
- `Orders::ExpirePending`: Confirmed/Unpaid → Expired at the exact deadline; scheduled by `ExpirePendingOrdersJob` every minute in development/production.
- `Orders::Hold`: Confirmed/Unpaid → Held with actor, reason, and idempotent audit evidence.
- `Payments::ConfirmCash` and `Payments::ConfirmBankTransfer`: record explicit exact-balance verification under Order-then-Payment locks and sample authoritative decision time only after both locks are held.
- `Preparation::RequestDispatch`: defense-in-depth recovery command that locks Order then Payment before sampling decision time and rechecking Order eligibility and full verified settlement.
- `Preparation::RetryDispatch`: locks the existing pending Dispatch and its existing Outbox Event, resets that Outbox Event to `pending` with the requested availability time, clears `published_at`, and appends an idempotent Audit Event. It never charges again, creates a new Dispatch/Outbox identity, or inserts a `PreparationDispatchAttempt`.

No bank credentials, bank API tokens, PINs, passwords, or raw banking notification payloads are stored. Manual bank confirmation records only method, amount, currency, trusted actor reference, and time.

### 3.1 Ordering Layered DDD implementation

Ordering Phase 1 now places lifecycle rules in `Orders::Domain::Aggregates::Order` and uses context-local `OrderId`, `Money`, `ServiceChannel`, and `PaymentWindow` Value Objects. The Domain has no Rails, Active Record, PostgreSQL, Payment, or Preparation dependency. It retains Draft, Confirmed, Held, and Expired behavior; reserved persisted statuses remain readable without adding a new transition.

`Orders::Application::UseCases::{CreateDraft,Confirm,Hold,ExpirePending}` coordinate the Aggregate through Ordering-owned repository, audit, transaction and Payment-fact contracts. The Payment-owned `Payments::Infrastructure::Adapters::OrderingPaymentGateway` implements the required target-creation and locked funding-status contract without moving Payment rules into Ordering. It joins the ambient local transaction and opens no independent transaction.

`Orders::Infrastructure::Persistence::OrderRecord` remains mapped to the existing `orders` table. `OrderMapper`, `ActiveRecordOrderRepository`, and `ActiveRecordUnitOfWork` isolate persistence and preserve PostgreSQL optimistic locking, unique constraints, candidate ordering, Order-before-Payment locking, and rollback behavior. The legacy `Order` Active Record class remains available to Payment, Preparation, tests, and compatibility results; no table, column, constraint, trigger, association, or public result type was renamed.

The four existing `Orders::*` commands are compatibility facades. Their keyword interfaces, result members, `DomainError` codes/details, replay semantics, Audit evidence, `ExpirePendingOrdersJob` integration, and legacy Active Record result projections remain unchanged. Architecture enforcement removes Ordering's legacy direct Payment-persistence files from the allowlist while retaining the separately unresolved Payment and Preparation violations.

`Orders::Confirm` intentionally locks only Order before sampling its confirmation decision time. Payment is created with the Draft and confirmation neither reads nor mutates Payment state. Every implemented workflow that can mutate or make a decision from Payment state—Payment confirmation, Hold, expiration, and Preparation dispatch—first acquires the same Order lock and then the Payment lock. The Order lock therefore serializes those workflows against Draft → Confirmed without a second lock in `Orders::Confirm`: a Payment workflow that wins first observes Draft and cannot settle/dispatch it; one that waits observes the committed confirmation evidence. Adding a Payment lock to Order confirmation would protect no additional current invariant. The earlier remediation expectation that every confirmation decision required Order → Payment locks was overly broad; Order → Payment remains mandatory only for workflows that consume or mutate Payment state. This conclusion records verified Phase 1 behavior, not a new business rule or Payment design authorization.

The architecture dependency spec uses Prism AST inspection, normalized constant aliases, known persistence-model identities, and call-receiver chains to reject direct persistence, Infrastructure, framework, and prohibited cross-context dependencies in Domain/Application source. It is a static source guard, not complete Ruby semantic analysis: it cannot prove behavior assembled through `eval`, reflective `const_get`, runtime monkey-patching, dynamically generated method names, or types hidden solely behind arbitrary local variables. Those techniques are not used by the inspected target layers; runtime integration tests and code review remain required alongside the scanner.

This migration does not implement Order Items, sold-price snapshots, Pricing, a public mutation endpoint, Payment/Preparation extraction, an outbox publisher, or Preparation Tickets. It does not resolve `OPP-ARCH-13` through `OPP-ARCH-16` and introduces no schema or migration change.

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

The `preparation_dispatch_attempts` table and `PreparationDispatchAttempt` model exist as reserved physical scaffolding for the deferred delivery worker design. No Phase 1 command writes that record. Attempt numbering, start/success/failure outcome capture, and delivery-error recording remain planned behavior and must not be inferred from `Preparation::RetryDispatch`.

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
| Models | `PreparationDispatchAttempt` model and Dispatch association exist | Model exists; no production writer references it | Retained as reserved scaffolding |
| `Preparation::RetryDispatch` | Requeue command for a pending Dispatch | Locks existing Dispatch and Outbox Event; resets the same Outbox Event to pending/available, clears publication time, and appends one semantic Audit Event | Source of truth for implemented retry behavior; explicitly records zero Dispatch Attempt rows |
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
