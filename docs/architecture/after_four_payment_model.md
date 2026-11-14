# AFTER FOUR — Canonical Payment Model

**Status:** Accepted correction for MVP foundation; split/partial allocation remains an `OPEN_DECISION`  
**Date:** 2026-11-14  
**Scope:** Payment settlement, charge-attempt activity, reconciliation, and preparation eligibility

Owner-confirmed business direction is recorded in the [Owner Decision Baseline](after_four_owner_decision_baseline.md). Phase 1 implementation remains exact-balance-only; later excess/refund evidence is not implemented by this documentation correction.

## 1. Decision

A Payment is the settlement aggregate for one Order. It has two independent state dimensions:

- `funding_status`: authoritative funded/refunded value relative to the Order target;
- `attempt_activity`: whether a charge attempt is active or has an unresolved outcome.

`payment_attempts.status` is the physical Phase 1 lifecycle of one Payment Attempt. Preparation Dispatch remains a separate durable record. No one field may substitute for the others.

Terminology: **Payment Attempt** is the canonical domain and implementation term. `PaymentAttempt` is the Rails model and `payment_attempts` is the physical table. Older historical/proposal documents used **Payment Transaction**/`payment_transactions` for a richer version of this same logical attempt record; Phase 1 has no `PaymentTransaction` model or `payment_transactions` table, and the legacy term does not identify a second implemented concept.

For MVP, a charge command accepts only the exact unpaid target. Partial/split tender, check/item allocation, and `payment_allocations` are not implemented. `partially_paid` remains a reserved representational value but is unreachable through MVP production commands until the Owner approves allocation semantics.

Related decisions: [ADR-0001](adr/0001-rails-modular-monolith.md), [ADR-0007](adr/0007-background-jobs-and-outbox.md), [ADR-0009](adr/0009-api-conventions-versioning.md), and [ADR-0010](adr/0010-database-migrations-and-schema.md).

## 2. State vocabularies

### 2.1 Funding status

| Value | Meaning | Arithmetic invariant |
|---|---|---|
| `unpaid` | No successful funded value. | `successful_amount = 0`, `refunded_amount = 0` |
| `partially_paid` | Successful value is positive but below target. Reserved for a future approved partial-payment policy. | `0 < successful_amount < target_amount`, `refunded_amount = 0` |
| `fully_paid` | Successful value exactly equals target. | `successful_amount = target_amount`, `refunded_amount = 0` |
| `partially_refunded` | The fully funded Payment has a positive successful Refund below its successful value. | `successful_amount = target_amount`, `0 < refunded_amount < successful_amount` |
| `fully_refunded` | Successful Refunds equal all successful funded value. | `successful_amount = target_amount`, `refunded_amount = successful_amount` |

Within the implemented exact-balance Payment aggregate, `successful_amount` is the authoritative allocated sum of successful Payment Attempt amounts and cannot exceed `target_amount`. `refunded_amount` is the authoritative sum of successful Refunds allocated to that funded value. `remaining_amount = target_amount - successful_amount` is derived. Amounts are nonnegative, one currency is used throughout, and Refunds cannot exceed successful funded value.

`OWNER_CONFIRMED` Real money received above the Order target is not revenue and must not be discarded merely because Phase 1 rejects a non-exact confirmation. The received amount, excess, method, reason, actor/approver, time, and linked Payment/Order require evidence, and the excess must be refunded through an appropriate method (`ODB-OP-11`). A future excess/refund evidence model requires separate design; this document does not allocate the excess into `successful_amount`, approve a Refund method, or relax Phase 1 database constraints.

`fully_settled_at` records the first authoritative transition to `fully_paid`; a later Refund does not erase it.

### 2.2 Attempt activity

| Value | Meaning |
|---|---|
| `idle` | No charge attempt is actively processing and no charge outcome requires reconciliation. |
| `processing` | A durable `initiated`/`pending` charge attempt is active. |
| `reconciliation_required` | At least one charge attempt has an unknown outcome that could change funded value. |

Refund activity is owned by Refund records and does not set charge `attempt_activity`.

### 2.3 Payment attempt status

One Payment Attempt (`payment_attempts`) uses `initiated`, `pending`, `unknown`, `succeeded`, `failed`, or `cancelled`. `succeeded`, `failed`, and `cancelled` are terminal. `unknown` may move only to `succeeded` or `failed` through signed provider evidence or an authoritative query.

### 2.4 Manual bank-transfer evidence

`OWNER_CONFIRMED` MVP bank transfer uses the Owner's bank QR. A bank notification speaker is an amount alert only and never proves Payment. The cashier manually compares the announced/observed amount with the pending Order and explicitly confirms it in POS; no automatic bank API matching is approved for MVP (`ODB-OP-07`–`ODB-OP-09`).

An amount mismatch is not confirmed by default. It requires resolution or an appropriate Refund; any exception requires Owner or explicitly authorized approval, reason, and audit. Exact exception roles, Refund method, and excess-evidence representation remain unresolved.

## 3. Valid and invalid combinations

Exactly seven aggregate combinations are representable:

| `funding_status` | `idle` | `processing` | `reconciliation_required` |
|---|---|---|---|
| `unpaid` | Valid | Valid | Valid |
| `partially_paid` | Valid but MVP-command unreachable | Valid but MVP-command unreachable | Valid but MVP-command unreachable |
| `fully_paid` | Valid | Invalid | Invalid |
| `partially_refunded` | Valid | Invalid | Invalid |
| `fully_refunded` | Valid | Invalid | Invalid |

The invalid combinations are prohibited because a Payment cannot be declared fully funded while an unresolved charge could overpay it, and refund processing/uncertainty belongs to the Refund lifecycle rather than charge activity.

The row-local PostgreSQL check is logically:

```sql
CHECK (
  (funding_status IN ('unpaid', 'partially_paid')
    AND attempt_activity IN ('idle', 'processing', 'reconciliation_required'))
  OR
  (funding_status IN ('fully_paid', 'partially_refunded', 'fully_refunded')
    AND attempt_activity = 'idle')
)
```

## 4. Transitions and guards

| From | Event/command | To | Mandatory guard/effect |
|---|---|---|---|
| `unpaid/idle` | Create exact-balance charge attempt | `unpaid/processing` | Confirmed payable Order; no blocking attempt; amount equals target; durable idempotency identity. |
| `unpaid/processing` | Authoritative failure/cancellation | `unpaid/idle` | Append terminal attempt outcome; preserve history. |
| `unpaid/processing` | Timeout/ambiguous result | `unpaid/reconciliation_required` | Mark attempt `unknown`; forbid new charge and dispatch. |
| `unpaid/processing` | Authoritative exact-balance success while Order is Confirmed and within its active payment window | `fully_paid/idle` | Under Order then Payment lock, apply outcome once and atomically insert unique pending Preparation Dispatch plus outbox event. |
| `unpaid/*` | Authoritative exact-balance success after expiration or while Order is Held/Expired | `fully_paid/idle` | Preserve financial truth and open a late-success review case; do not create Dispatch/outbox or reactivate the Order. |
| `unpaid/reconciliation_required` | Authority proves failure | `unpaid/idle` | Apply evidence once; clear only when no unknown charge attempt remains. |
| `unpaid/reconciliation_required` | Authority proves exact-balance success | `fully_paid/idle` | Same atomic settlement/dispatch boundary as direct success. |
| `unpaid/*` | Observed/received amount differs from target | No automatic settlement transition | Preserve mismatch/excess evidence as later design permits; do not dispatch; resolve or appropriately Refund; audited exception approval where applicable. |
| `partially_paid/*` | Future approved tender event | Defined only by a future policy | Forbidden through MVP production commands. |
| `fully_paid/idle` | Successful approved partial Refund | `partially_refunded/idle` | Lock Payment/original successful Payment Attempt; append Refund; recompute under lock. |
| `fully_paid/idle` or `partially_refunded/idle` | Successful approved remaining Refund | `fully_refunded/idle` | Cumulative successful Refunds equal successful funded value. |

No ordinary command returns a confirmed Payment to `unpaid` or reduces `successful_amount`. Corrections are append-only Refunds or future approved reversal records.

## 5. Reconciliation and concurrency

Provider communication occurs outside a database transaction. Applying a result starts a new local transaction that:

1. verifies provider signature/query authority and unique event/reference;
2. locks the Payment and target Payment Attempt in the documented order;
3. rejects or replays duplicate evidence idempotently;
4. appends/applies the attempt outcome;
5. recomputes authoritative amounts, `funding_status`, and `attempt_activity`;
6. if the first `fully_paid/idle` state is reached, rechecks Order status and the payment deadline under lock; only a Confirmed, unexpired Order receives the unique pending Preparation Dispatch and outbox event;
7. otherwise records the full settlement and an exception review case without dispatch or automatic reactivation;
8. commits before external dispatch, printing, or further provider work.

Deadline decision time is sampled after the Order and Payment locks are held. Command-start time is not authoritative. A decision exactly at the deadline follows the late-success path.

At most one nonterminal or unknown charge attempt may block a Payment in MVP. Enforce this with an application guard under the Payment lock and a partial unique constraint over blocking attempt states where the physical design supports it. Reconciliation uses the existing attempt and idempotency identity; it never starts a replacement charge.

## 6. Preparation dispatch eligibility

Preparation is eligible only when all conditions hold:

- Order is Confirmed and its sold snapshots/target are frozen;
- the payment deadline has not been reached and the Order is neither Held nor Expired;
- `funding_status = 'fully_paid'`;
- `attempt_activity = 'idle'`;
- authoritative successful amount exactly equals target;
- the unique Order Preparation Dispatch is absent or is the same idempotent replay.

Payment success and pending dispatch commit together. A worker failure leaves Payment fully paid and the same Dispatch pending. Retrying dispatch never creates a Payment Attempt and never duplicates Preparation Tickets. Print failure cannot mutate Payment or Preparation truth.

A late successful notification is not lost: it may make Payment `fully_paid/idle`, but an Expired/Held Order receives a review case instead of Dispatch. The review path is deliberately separate from payment truth and cannot silently reactivate an Order.

Observed excess or mismatched evidence does not satisfy this gate. A future excess-refund workflow must preserve exact target allocation and cannot dispatch from ambiguous evidence.

## 7. Enforcement split

| Layer | Responsibilities |
|---|---|
| PostgreSQL | Non-null fields; allowed values; seven-combination check; nonnegative/local amount checks; one Payment per Order; attempt/event/idempotency uniqueness; one Dispatch per Order; FKs; trigger enforcement preventing stored terminal Attempt evidence from being rewritten by ordinary sessions. |
| Rails use case | Authorization; exact-balance MVP policy; lock order; cross-row sums; state transitions; reconciliation authority; same-commit settlement/Dispatch/outbox. |
| Adapter | Initiate/query/verify provider-specific behavior without owning Payment truth. |
| Tests/operations | Request, constraint, concurrency, replay, timeout, reconciliation, rollback, paid-but-undispatched recovery, and queue/backlog visibility. |

## 8. Deferred decisions

The correction does not decide whether partial/split tender will ever be allowed. Before enabling `partially_paid`, the Owner must approve tender count, allocation target, rounding, check/item allocation, cancellation/refund allocation, retry behavior, reporting, and operator UX. No `payment_allocations` table or API field is authorized by this document.

The Owner-confirmed overpayment outcome does not select a physical model. Before implementation, approve or explicitly defer the excess-evidence record shape, authority, Refund method/original-tender behavior, allocation, provider interaction, reconciliation, reporting, and operator recovery. Until then, Phase 1 exact-balance commands and database constraints remain unchanged.
