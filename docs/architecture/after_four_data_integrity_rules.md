# AFTER FOUR Data Integrity Rules v1.0

**Status:** Logical enforcement contract for review; not executable schema  
**Date:** 2026-11-14  
**Sources:** [Owner Decision Baseline](after_four_owner_decision_baseline.md) · [DDD Foundation](after_four_ddd_foundation.md) · [Business Domain Model](after_four_business_domain_model.md) · [Logical ERD](after_four_erd.md) · [Data Dictionary](after_four_data_dictionary.md) · [Payment Model](after_four_payment_model.md) · [Schema ADR](adr/0010-database-migrations-and-schema.md) · [Background Job ADR](adr/0007-background-jobs-and-outbox.md)

## 1. Enforcement model and provenance

Integrity uses three complementary layers:

1. **Database constraints** protect local identity, nullability, arithmetic, referential, and race-sensitive uniqueness rules.
2. **Application transactions/policies** protect multi-row, lifecycle, authorization, scope, and external-system rules.
3. **Operational controls/tests** detect drift, recover post-commit work, validate backups, and enforce legal retention/access.

Unless explicitly labeled otherwise, the enforcement mechanism is `TECHNICAL_PROPOSAL`. The underlying business invariant retains the provenance shown in the canonical model.

## 2. Referential integrity

| Rule | Database enforcement | Application/transaction enforcement | Provenance |
|---|---|---|---|
| Brand belongs to Organization; Branch belongs to Brand | Non-null FKs, `ON DELETE RESTRICT` | Organization/Brand cannot be changed after dependent operations exist | `WORKSHOP_AGREED` |
| User and Employee are distinct, optional one-to-one | Unique nullable `employees.user_id` FK | Onboarding/offboarding coordinates status without deleting history | `WORKSHOP_AGREED` |
| Branch Assignment links same-Organization Employee and Branch | FKs; optional composite scope FK | Validate ancestry and effective authorization | `WORKSHOP_AGREED` |
| Operational root has immutable Branch | Non-null `branch_id` FK | Reject Branch reassignment after creation/confirmation | `WORKSHOP_AGREED` |
| Child belongs to its aggregate | Non-null parent FK; restrict parent deletion | Aggregate commands are the only write path | `TECHNICAL_PROPOSAL` |
| Order source catalog FKs may coexist with snapshots | Nullable Product/Variant/Modifier FKs; snapshot columns non-null | Historical rendering uses snapshots, never current joins | `WORKSHOP_AGREED` |
| Preparation Item references Order Item and exact RecipeVersion | FKs | Validate same Order/Branch and effective recipe at preparation | `WORKSHOP_AGREED` |
| Refund references original successful Payment Attempt and Order | Non-null FKs | Validate success, currency, refundable balance, and authority under lock | `WORKSHOP_AGREED`; policy `OPEN_DECISION` |
| Stock Movement belongs to Inventory Position and optional Lot | Non-null/nullable FKs | Validate Lot belongs to Position and source is legitimate | `WORKSHOP_AGREED` |
| Transfer source and destination are distinct | FKs plus check IDs differ | Validate both Warehouses belong to same Organization and approved route | `WORKSHOP_AGREED` |
| Cash Transaction belongs to Cash Session | Non-null FK | Validate Session state; post-close entries follow adjustment flow | `WORKSHOP_AGREED` |
| Generic Audit/Approval subject exists | No universal hard FK is possible | Validate target on insert; prohibit deletion of confirmed targets; integrity audit | `TECHNICAL_PROPOSAL` |

Database cascades are limited to unconfirmed, purely dependent configuration rows where deletion is explicitly safe. No cascade may erase Orders, Payment Attempts, Refunds, Payrolls, Stock Movements, Cash Transactions, Audit Logs, or Approval Decisions.

## 3. Unique business identifiers

| Identifier | Recommended database constraint | Notes |
|---|---|---|
| Organization code | UQ `organizations(code)` | Human code is not PK. |
| Brand code | UQ `(organization_id, code)` | Organization scope. |
| Branch code | UQ `(brand_id, code)` | Brand scope. |
| Employee code | UQ `(organization_id, employee_code)` | Never recycled while retained. |
| Role key | UQ `(organization_id, key)` | Stable capability template. |
| Category/Product/Modifier codes | UQ within documented Brand/parent scope | Product move/rename does not alter Order snapshots. |
| Variant SKU | UQ in Brand scope | May require denormalized Brand FK or indexed ancestry strategy. |
| Order number | UQ `(branch_id, order_number)` | Exact numbering is `OPEN_DECISION`. |
| Preparation dispatch | UQ `order_id` | One paid-order dispatch identity (`OWNER_CONFIRMED`). |
| Ticket/delivery number | UQ `(branch_id, number)` | Operational display identity. |
| Provider event | UQ `(provider, provider_event_id)` | Replay protection. |
| Provider successful reference | Partial UQ where present/successful | Provider contract dependent. |
| Inventory position | UQ `(warehouse_id, ingredient_id)` | Lock target and cached balance. |
| Transfer/PO/receipt/stocktake number | UQ in Organization/Warehouse/Branch scope as documented | Never reused after cancellation. |
| Cash session number | UQ `(branch_id, session_number)` | Drawer scope additionally controls open session. |
| Payroll | UQ `(payroll_period_id, employee_id)` | One frozen calculation per Employee/Period. |
| Loyalty account | UQ `customer_id` | Organization-shared Customer. |
| Idempotency | UQ `(organization_id, scope, key)` plus request fingerprint | Same key/different payload is conflict. |

`TECHNICAL_PROPOSAL` Prefer named constraints with stable error mapping. Uniqueness involving archived master data should normally retain old codes; allowing reuse is an explicit policy, not a default partial index.

## 4. Organization and Branch isolation

### 4.1 Database rules

- Required scope FKs are non-null on operational roots.
- Child scope derives through a parent unless a repeated scope key is needed for a same-scope composite FK.
- Warehouse has `organization_id`; Branch Warehouse also has `branch_id`; Central Warehouse must not have a Branch.
- Cross-Organization FKs are prevented using composite keys where practical or checked inside the same transaction.
- Historical operational `branch_id` is never updated.

### 4.2 Application authorization rules

`WORKSHOP_AGREED` Every read and command resolves the authenticated User's effective Role Assignments and Employee Branch Assignments at the event time. A request-supplied Branch is a target to validate, not authority. `TECHNICAL_PROPOSAL`: except for an approved Organization-scoped Owner rule, a Branch operation requires the intersection of the effective Role scope and the linked Employee's effective Branch Assignment; neither alone grants access.

Application policy must:

1. authenticate an unexpired, unrevoked server Session and require the User lifecycle to permit access;
2. establish Organization from the trusted Session/User;
3. scope lookup by Organization and authorized Branches, then load the target resource's immutable scope;
4. require an effective Role Assignment/capability and, where applicable, an effective Employee Branch Assignment for that scope;
5. apply role-specific approval and self-approval rules;
6. record actor, effective role/capability, Branch, reason, approver, and request ID on sensitive actions.

Collections are pre-scoped before serialization. UUID unpredictability, a selected Branch, a Device, or a Shift is never authorization. Out-of-scope and nonexistent object lookups use indistinguishable public responses where existence would leak data.

`TECHNICAL_PROPOSAL` PostgreSQL row-level security is not required for v1 and must not be treated as a substitute for application policies. It may be evaluated later as defense in depth.

`OWNER_CONFIRMED` Every Role Assignment and Employee Branch Assignment create/change/end requires Owner approval. Approval evidence and the effective-dated assignment commit atomically; a Branch Manager's Branch scope does not confer approval authority.

`OWNER_CONFIRMED` Invitation Delegation is not a Role Assignment or Branch Assignment. Only an active Branch Manager may use a current delegation to invite Staff within their effective Branch scope, for no more than 90 days. A transaction must revalidate delegate lifecycle, Branch scope, delegation expiry/revocation, invite target role, and self/onward-delegation prohibitions before issuing an invitation. Owner revocation and invalidation of all outstanding unused invitations commit atomically or fail closed; exact race controls require security review.

`OWNER_CONFIRMED` Authentication lock, suspension/reactivation, and deactivation are distinct. Automated lock release follows an approved policy; suspension/reactivation and deactivation require Owner authority; reactivation is explicitly authorized and audited; deactivation never automatically restores access. Session/authenticator/grant revocation and lifecycle audit must commit atomically where possible and fail closed otherwise, without deleting Employee, audit, or business history.

## 5. Historical snapshots and effective dates

### 5.1 Required snapshots

| Historical record | Required immutable snapshot |
|---|---|
| Order Item | Product/Variant codes and labels, Modifier labels, quantity, unit price, price components, currency |
| Promotion Usage | Rule/benefit snapshot and applied discount |
| Preparation Item | Display name, requested quantity, exact RecipeVersion |
| Reservation | Guest/contact details allowed by consent/retention policy |
| Delivery | Destination/table/floor display at dispatch |
| Payroll | Effective compensation and approved input calculation snapshot |
| Stock Transfer Item | Dispatched quantity, lots/cost basis, unit/currency |
| Goods Receipt | Supplier document, accepted/quarantined/rejected quantities, lot/expiry and cost |
| Audit/Approval | Policy version, actor/role/scope, reason, safe before/after summary |

Snapshot fields are not updated when source master data changes. Source FKs support traceability but are not used to reconstruct old financial/service displays.

### 5.2 Effective-dated records

Price, RecipeVersion, Branch Assignment, Role Assignment, Compensation Agreement, Branch Availability, Promotion, Checklist version, and Configuration Version use half-open intervals `[effective_from, effective_to)`.

| Rule | Database | Application |
|---|---|---|
| `effective_to > effective_from` | Check constraint | — |
| No overlapping active price for Variant/Branch scope | Exclusion constraint where practical | Lock scope and validate during change |
| No overlapping RecipeVersion for Recipe | Exclusion constraint | Validate publication/effective status |
| At most one primary Branch Assignment | Partial/exclusion constraint | Validate temporary/primary business policy |
| Compensation history does not overlap | Exclusion constraint | Legal/payroll validation before activation |
| Change does not rewrite past transaction | Permissions/triggers optional | Commands create new version and end prior interval |

## 6. Immutable confirmed transactions

### 6.1 Append-only records

The following are append-only after their business outcome is recorded:

- terminal Payment Attempt outcomes and all provider events;
- terminal Refund outcomes;
- confirmed Order Item snapshots;
- Preparation Deviations and Delivery Events;
- Stock Movements, transfer receipts, and posted goods receipts;
- Loyalty Transactions;
- closed Payroll calculations, Payroll Adjustments, and Payroll Payments;
- Cash Transactions and closed Cash Session close evidence;
- Approval Decisions and Audit Logs;
- Print Attempts.

`WORKSHOP_AGREED` Mistakes are corrected by a linked reversal, refund, adjustment, superseding version, or new decision. They are never corrected through deletion or in-place rewriting of confirmed facts.

### 6.2 Enforcement split

- **Database:** restrict deletion; require reversal FK/source; checks for nonzero adjustment; immutable-row permissions or triggers may be evaluated.
- **Application:** expose no generic update/delete endpoint; verify authorization/reason; create compensating records transactionally.
- **Tests/operations:** mutation tests assert confirmed rows cannot change; periodic reconciliation detects ledger/cache drift.

`TECHNICAL_PROPOSAL` Application roles should not own tables with unrestricted update/delete privileges in production. Exact trigger use is deferred to physical-schema review.

## 7. Reversal and adjustment patterns

| Original fact | Correction record | Required link/rule |
|---|---|---|
| Successful Payment Attempt | Refund | Original remains successful; cumulative successful Refund ≤ refundable amount. |
| Stock Movement | Reversing Stock Movement | Same Position/currency/cost basis; explicit `reverses_movement_id`; no double reversal. |
| Loyalty Transaction | Reversal/adjustment Loyalty Transaction | Signed opposite/approved delta; original remains. |
| Cash Transaction | Reversal/adjustment Cash Transaction | Link original; actor/reason; post-close rule applies. |
| Closed Payroll | Payroll Adjustment | Original calculation/close stays frozen; adjustment approval/payment tracked. |
| Confirmed Expense | Reversing Expense or adjustment transaction | Preserve original evidence and approval. Exact accounting treatment `LEGAL_VALIDATION`. |
| Published Price/Recipe/Config | New effective version | End prior interval; past Orders/Preparation retain snapshots/version. |
| Attendance correction | Corrected Attendance plus audit/original snapshot | Never erase original punch evidence. |

## 8. Payment and preparation integrity

### 8.1 Payment arithmetic

- **Payment Attempt** is the canonical attempt record. Phase 1 implements model `PaymentAttempt` and table `payment_attempts`; the older `Payment Transaction`/`payment_transactions` wording survives only in explicitly historical proposal documents and does not name another implemented record.
- Money uses integer stored units plus one currency per Order/Payment.
- `successful_amount` is the sum of successful allocatable transactions, not a client-supplied total.
- `refunded_amount` is the sum of successful Refunds.
- `funding_status` and `attempt_activity` are independent Payment axes; allowed values, seven valid combinations, arithmetic mapping, and transitions follow the [Payment Model](after_four_payment_model.md).
- PostgreSQL enforces allowed values and row-local valid combinations. For the implemented Phase 1 Attempt schema, deferred constraint triggers serialize on the Payment row and require `successful_amount` to equal the succeeded Attempt total at commit; `fully_paid` additionally requires exact equality with `target_amount`. A check constraint cannot aggregate child rows, so the trigger complements—not replaces—the locked application transaction. Refund arithmetic remains deferred because Refund is outside Phase 1.
- Target/success/refund amounts are nonnegative; Refund amount is positive.
- A provider/cash attempt is never overwritten from unknown to an invented result; an authoritative result is applied idempotently.
- MVP accepts only an exact-balance attempt. `partially_paid` is reserved but unreachable through production commands; split/partial allocation remains `OPEN_DECISION` and no `payment_allocations` schema is authorized.
- `OWNER_CONFIRMED` Money actually received above target must be evidenced and its excess refunded; excess is not revenue. This requirement does not permit `successful_amount > target_amount` in the implemented aggregate. A future design must preserve received/excess amount, method, reason, actor/approver, time, and linked Payment/Order without weakening Phase 1 exact-target constraints.
- For manual MVP bank transfer, the Owner bank QR and speaker amount alert do not provide authoritative proof. Cashier comparison/confirmation is explicit; mismatch/excess cannot dispatch by default and requires resolution or appropriate Refund with audited approval where applicable.

### 8.2 Owner-confirmed dispatch boundary

`OWNER_CONFIRMED` Preparation dispatch is forbidden until full successful Payment is persisted.

The application transaction that applies the result making an Order fully settled must:

1. lock the Order and then Payment in a documented order;
2. verify the attempt/provider result and idempotency fingerprint;
3. persist attempt outcome and recompute successful amount;
4. transition Payment to `funding_status=fully_paid` and `attempt_activity=idle` only when authoritative amount equals payable target and no unknown attempt can overpay;
5. recheck that the Order is Confirmed, not Held/Expired, and strictly before its payment deadline;
6. for an eligible Order, insert the unique pending Preparation Dispatch and outbox event in the same commit;
7. for an ineligible late success, preserve full settlement and insert an open review case without Dispatch/outbox or automatic reactivation;
8. commit before any printer or external dispatch communication.

The deadline decision time is sampled only after the Order and Payment locks in step 1 are held. A timestamp captured before waiting for either lock is not authoritative. Equality is late: `decision_time >= payment_expires_at` records settlement/review evidence without Dispatch or automatic reactivation.

Database guards in the implemented Phase 1 schema: unique `preparation_dispatches.order_id`; composite FKs requiring Dispatch `(payment_id, order_id)` to identify one Payment and `(order_id, branch_id)` to identify one Order/Branch pair; composite FKs requiring each review case's Payment/Order and Attempt/Payment pairs to match; scoped idempotency uniqueness; a succeeded-Attempt evidence check; and deferred Payment-row-serialized aggregate triggers. Application/service tests still prove state-transition eligibility, unknown-attempt policy, deadlines, and atomic side effects that these relational guards do not encode.

If post-commit ticket creation fails, the pending dispatch remains retryable. A retry uses the same dispatch identity, never a new charge. Print Job failure has no write path to either Payment axis.

In implemented Phase 1, `Preparation::RetryDispatch` requeues the existing Outbox Event and appends an Audit Event for the operator command; it does not append `preparation_dispatch_attempts`. The attempt table/model exist as reserved physical scaffolding. Appending numbered delivery-attempt start/success/failure outcomes remains a `TECHNICAL_PROPOSAL` for the deferred outbox consumer/ticket-delivery implementation. If authorized later, that technical state must remain separate from Payment and must not replace the business Dispatch identity.

Terminal Payment Attempts (`succeeded`, `failed`, `cancelled`) preserve their financial and confirmation evidence. Normal Rails mutation is rejected by the model and callback-bypassing/direct SQL mutation is rejected by a PostgreSQL trigger. Transition from a stored non-terminal state into a legitimate terminal state remains allowed. Trigger enforcement does not protect against a database superuser or owner that deliberately disables or drops it.

### 8.3 Refund concurrency

Lock original Payment Attempt and Payment before applying a successful Refund. Recompute already-refunded amount under lock; reject excess; insert outcome and downstream loyalty/revenue/cash intents in the atomic local transaction. Provider communication occurs outside the open transaction.

“Reject excess” here means a Refund cannot exceed the approved refundable obligation. It does not mean an already received overpayment may be discarded. The excess-evidence/Refund obligation model, allocation, original-tender behavior, and provider process remain unresolved.

## 9. Inventory and weighted-average integrity

### 9.1 Authoritative ledger and cached position

`WORKSHOP_AGREED` Stock Movement is authoritative. Every Inventory Position or Lot quantity/cost update and its Stock Movement commit together under a locked Position row.

For a qualifying receipt:

`new_average = (old_valued_quantity × old_average + received_quantity × receipt_unit_cost) ÷ new_valued_quantity`

Use decimal/numeric arithmetic with a documented rounding scale. Issues use current average and do not recompute the average except for zero-balance/reset policy, which requires accounting validation.

### 9.2 Stock rules

- `available_quantity >= 0` is a database check and an under-lock application precondition.
- Quarantine/rejected Lots contribute no available quantity.
- FEFO selection orders eligible Lots by non-null earliest expiry then receipt time; exact no-expiry precedence is application policy.
- Movement source/idempotency uniqueness prevents duplicate receipt, consumption, waste, or transfer posting.
- Position/Lot cached balances are reconciled against Movement sums; drift is an incident, not a manual balance edit.

### 9.3 Transfer dispatch and receipt

Dispatch transaction:

1. lock source Positions/Lots in stable identifier order;
2. verify available stock and approved state;
3. post source issue movements and capture transfer cost/lot snapshots;
4. update Transfer Items/in-transit state and commit.

Receipt transaction (independent and possibly partial):

1. lock Transfer and destination Positions in stable order;
2. ensure cumulative accepted/quarantined/rejected quantity does not exceed dispatched remainder;
3. insert unique Transfer Receipt/Items;
4. post destination receipt/quarantine movements and recompute weighted average for accepted stock;
5. reduce in-transit remainder and transition lifecycle.

Receipt never edits dispatch movements. Cancelled dispatched stock requires return/reversal/exception movements. Exact central-cost snapshot timing is `LEGAL_VALIDATION` plus accepted engineering policy.

## 10. Cash and payroll integrity

### 10.1 Cash Session

- The initial operating model has one shared drawer and permits at most one open/counting Cash Session for it. A partial unique index is the proposed enforcement; any future multi-drawer topology requires separate approval and design.
- Cash Session expected amount is derived from opening fund and Cash Transactions; it is not freely editable.
- Closing locks the Session, blocks ordinary transactions, stores expected/actual/variance/reason, and commits immutable close evidence.
- Post-close correction uses a linked adjustment Cash Transaction in an authorized correction flow; it never changes close values.
- Cash Payment Attempt and corresponding Cash Transaction commit atomically in the local database.
- `OWNER_CONFIRMED` The shared 2,000,000 VND float belongs to one Operating Day and carries across shift Cash Sessions. A Session opening count is not another float allocation; no automatic mid-day reset/top-up is permitted.
- Float top-up requires Owner authorization and amount/source/executor/approver/time evidence; Staff may request it. It is a Cash Transaction/funding movement, not revenue, and no fixed frequency limit is approved.
- Shift close and handover preserve actual count, actor/session accountability, discrepancy reason, and Owner notification. No discrepancy tolerance is approved.
- Delegated Expenses require positive amount and purpose/recipient/executor evidence plus receipt or explanation. A single amount above 200,000 VND or cumulative delegated amount above 500,000 VND per Operating Day requires Owner approval. Self-approval and splitting to evade limits are forbidden. Values are configurable; the Operating Day boundary and database enforcement shape remain unresolved.

### 10.2 Payroll

- UQ Payroll per Employee/Period.
- Draft calculation references effective Compensation Agreement and approved inputs.
- `OWNER_CONFIRMED` Owner identity/time is required for closed status.
- Closing a Payroll Period locks the Period/Payrolls, validates Branch Manager review according to accepted workflow, freezes calculation snapshots, and writes Audit Log/outbox evidence atomically.
- Payslip PDF generation occurs after close and cannot change the calculation.
- Payment history is append-only and independent from calculation/close state.
- Post-close corrections use Payroll Adjustment. Reopening policy is `OPEN_DECISION`; silent recalculation is prohibited.

## 11. Idempotency and external boundaries

### 11.1 Key rules

Idempotency keys are opaque, stable per user intent, and scoped to the command/aggregate. Store a canonical request fingerprint. Behavior:

- same key + same fingerprint + completed command → return original result;
- same key + same fingerprint + processing → report/await in-progress result;
- same key + different fingerprint → conflict;
- new key for a provider retry is allowed only after authoritative policy determines it is safe.

Domain-specific UQ keys remain the final guard even when a generic `idempotency_records` row exists.

For `Orders::CreateDraft`, the scope is `(branch_id, creation_idempotency_key)`. Fingerprint version `after_four.order.create.v1` hashes the normalized trusted actor UUID, channel, integer total amount, and uppercase currency with SHA-256. Branch is represented by the key scope; command time and generated identifiers are excluded. Same fingerprint returns the original Order, Payment, and replay marker without duplicate audit evidence. A different fingerprint raises `idempotency_conflict`. Concurrent uniqueness losers recover only from the named Branch/key index violation, then compare against the committed winner; unrelated database errors are not swallowed.

### 11.2 External provider and printer boundaries

Never keep a database transaction open while waiting for a payment provider, printer, PDF renderer, email service, or physical process.

| Workflow | Before external call | After result |
|---|---|---|
| Electronic payment | Commit pending Payment Attempt/idempotency identity | Apply verified provider event in new locked transaction |
| Refund | Commit intent if provider requires it | Apply result idempotently; never edit original charge |
| Print | Commit Print Job | Append Print Attempt outcome; Payment/Preparation untouched |
| Payslip PDF | Close/freeze Payroll | Store versioned artifact reference/hash |
| Preparation downstream notification | Commit paid Payment + pending Dispatch + outbox | Idempotently create/locate unique ticket |

## 12. Concurrency and lock order

| Use case | Lock order / concurrency guard |
|---|---|
| Confirm/update Order | Order aggregate/version, then its mutable items; expected `lock_version` |
| Apply Phase 1 payment result | Order, then Payment; Payment Attempt uniqueness; then Review Case or Dispatch/Outbox insert inside the same transaction |
| Retry Preparation Dispatch | Preparation Dispatch, then its Outbox Event; semantic Audit idempotency evidence in the same transaction |
| Refund | Original Payment Attempt, Payment, then Refund uniqueness |
| Cancel paid Order | Order, then authoritative Preparation work/dispatch state in the approved deterministic order; decide Staff-before-start versus Owner-after-start authority under the same fence |
| Post stock | Inventory Positions in stable ID order, then Lots; movement uniqueness |
| Dispatch transfer | Transfer, source Positions/Lots sorted by ID |
| Receive transfer | Transfer, Transfer Items, destination Positions/Lots sorted by ID |
| Close Cash Session | Cash Session; verify no unposted local cash commands |
| Record delegated Expense | Operating Day/approved policy scope, then Expense identity; serialize cumulative delegated total before commit |
| Close Payroll Period | Period, Payroll rows sorted by Employee ID |
| Claim Delivery | Delivery row/version and assignment transition |

Deadlock/serialization failure retries restart the whole transaction with bounded retry. A statement error is not rescued and continued inside the same PostgreSQL transaction.

## 13. Soft deletion, deactivation, and retention

| Data class | Lifecycle treatment |
|---|---|
| Organization/Brand/Branch, User, Employee, Catalog, Supplier, Warehouse, Device/Printer | status plus archive/deactivation date; no deletion when referenced |
| Effective policy/version rows | end effective interval or supersede; retain old version |
| Orders, Payments, Refunds, Payroll, Stock, Cash, Loyalty, Approval/Audit | never soft-delete as correction; use lifecycle/reversal/adjustment |
| Draft records with no external effect | May be cancellable; physical deletion only under explicit retention policy and no references |
| Personal/contact data | Minimize and protect; anonymization/retention must preserve legally required transaction evidence (`LEGAL_VALIDATION`) |

No global `deleted_at` concern is recommended. It hides domain-specific integrity and can break uniqueness unexpectedly.

Retention periods for payment metadata, payroll/payslips, audit, customer consent/contact, feedback, food safety, tax invoice, and supplier evidence are `LEGAL_VALIDATION`. Outbox/idempotency technical retention must exceed the maximum retry/replay window and must never remove the underlying business ledger.

## 14. Database versus application rule matrix

| Rule | DB constraint | Application transaction/policy | Test/operation |
|---|---:|---:|---:|
| Required identity/FK | Yes | — | Schema tests |
| Local amount/quantity range | Yes | Revalidate friendly error | Boundary tests |
| Unique code/idempotency/provider event | Yes | Conflict mapping | Concurrent request tests |
| Same Organization/Branch ancestry | Composite FK where practical | Yes | Authorization/isolation tests |
| Effective-date non-overlap | Exclusion where practical | Yes under lock | Concurrent publish tests |
| Lifecycle transition | Allowed stored values only | Yes; named state machine | Transition tests |
| Full payment before dispatch | Unique/FK support only | Yes, atomic service | Failure/rollback/concurrency tests |
| Refund cumulative limit | Local positive checks | Yes under lock | Competing-refund test |
| Overpayment evidence/excess Refund | Phase 1 exact-target checks remain | Future evidence/allocation and Refund transaction | Mismatch/excess/replay/reporting tests after design |
| Weighted-average calculation | Precision/check support | Yes under lock | Property/reconciliation tests |
| Transfer in-transit accounting | FK/check support | Yes across dispatch/receipt transactions | Partial/concurrent receipt tests |
| Branch authorization | Scope FKs | Yes, server-side | Cross-Branch denial tests |
| Closed cash/payroll immutability | Restrict permissions/check status | Yes; adjustment-only commands | Mutation tests |
| Delegated Expense limits | Typed/config-version support | Per-item and Operating-Day cumulative check; Owner approval; no self-approval | Boundary, concurrent cumulative, split-evasion tests |
| Cancellation stage authority | State values/FKs only | Atomic Preparation-state fence and authorization | Start/cancel concurrency and rollback tests |
| Audit append-only rows | PostgreSQL UPDATE/DELETE rejection trigger in Phase 1 | Rails update/destroy callbacks; append correction events instead of rewriting history | Direct SQL/bulk mutation tests; production role-separation verification still required |
| Audit/approval target existence | Limited generic FK ability | Yes | Orphan scan/retention tests |
| External outcome truth | Uniqueness/digests | Yes, signature/provider reconciliation | Replay/timeout tests |

## 15. Audit, approval, and retention requirements

Sensitive actions include role/assignment changes, attendance corrections, leave/overtime decisions, payroll close/adjustment/payment, Order cancellation, price override, Payment/refund/void, Preparation deviation, stock adjustment/transfer, cash close/variance/correction, expense/purchase decision, loyalty adjustment, promotion publication, and configuration change.

`OWNER_CONFIRMED` Audit Logs are append-only and audit read access is restricted. They must contain safe metadata only and do not replace domain ledgers. Approval Request/Decision records do not replace final domain state. Access to audit, payroll, payment, and customer evidence is separately authorized and itself auditable.

For the implemented Phase 1 `audit_events` table, Rails callbacks reject ordinary update/destroy operations and a PostgreSQL `BEFORE UPDATE OR DELETE` trigger rejects callback-bypassing, bulk, and direct SQL row mutation. Inserts and reads remain permitted by the current connection role, and inserts participate normally in business transaction rollback. The trigger is defense in depth, not an absolute guarantee: the current development/test `postgres` principal is simultaneously superuser, table owner, migration role, and runtime role and can deliberately alter/disable/drop enforcement or truncate the table. Production requires a distinct least-privilege runtime role that cannot own the table, alter triggers/functions/ownership, or truncate it. Exact grants, reader roles, integrity verification, and retention remain security/deployment/legal work.

`LEGAL_VALIDATION` Final retention, export, correction, and erasure rules require current Vietnamese legal/accounting/privacy/food-safety review.

## 16. Integrity risks and unresolved decisions

| Risk/open decision | Integrity impact | Required resolution |
|---|---|---|
| Partial/split payments | Payment aggregate/allocation and full-settlement trigger | Approve semantics before API/state machine and physical schema |
| Partial refund allocation | Revenue, tax, promotion, loyalty, inventory corrections | Approve allocation and authority |
| Cancellation outcomes | Staff-before-start and Owner-after-start authority are confirmed, but completed Order, Refund, stock, remake, and compensation outcomes remain | Approve remaining exception/compensation details and atomic fence design |
| Overpayment evidence/refund | Phase 1 exact-target aggregate cannot represent received excess | Design evidence, allocation, Refund method, authority, and reporting without relaxing current constraints |
| Drawer/device topology | One-open-session constraint scope | Confirm physical drawer identity and concurrency |
| Transfer valuation timing | Central/Branch cost agreement | Accounting validation and stable snapshot event |
| Remaining approval thresholds/self-approval | Generic approval cardinality and authorization | Preserve confirmed Expense limits/no-self-approval; approve only other policy areas |
| Operating Day/reporting cutoff | Daily float, Expense accumulation, and report totals may disagree | Approve timezone/cutoff and formula versions |
| Phone identity/merge/consent | Customer uniqueness and privacy | Legal/privacy validation and merge workflow |
| Payroll/leave/overtime details | Calculation and closed-period correction | Owner decision plus legal validation |
| Tax invoice/provider | Required entities, numbering, retention, correction | Legal/provider validation |
| Offline commands | Idempotency lifetime, ordering, device security | Approve beyond safe online-authoritative default |

## 17. Acceptance checklist for the next review

Before Rails/PostgreSQL foundation work, reviewers should confirm:

- every operational root has an unambiguous Organization/Brand/Branch/Warehouse owner;
- every historical display/calculation has a snapshot or exact version reference;
- every confirmed mistake has a reversal/adjustment path;
- payment settlement and Preparation Dispatch are one reliable local commit followed by retryable downstream work;
- stock/cost updates always pair Movement and Position/Lot updates under lock;
- closed Cash/Payroll facts cannot be overwritten;
- open policy/legal decisions are not encoded as final constraints;
- API contracts and state machines can express unknown, pending, failed, retryable, and corrected states without overloading one status.

The next phase is an **API Contract and State Machine review**. Rails/PostgreSQL implementation begins only after these three documents are accepted.

