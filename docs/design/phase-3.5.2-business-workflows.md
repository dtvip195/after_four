# Phase 3.5.2 — Business Workflows

> **HISTORICAL / SUPERSEDED_FOR_IMPLEMENTATION.** Any flow below that submits or dispatches preparation before verified full payment is not authoritative. Use the canonical [Owner Decision Baseline](../architecture/after_four_owner_decision_baseline.md), [Business Domain Model](../architecture/after_four_business_domain_model.md), [Payment Model](../architecture/after_four_payment_model.md), and [State Machines](../architecture/after_four_state_machines.md). Held/Expired Orders never auto-dispatch after late settlement. Later decisions also supersede stale guidance on manual bank verification, stage-specific cancellation, daily cash float/top-ups, delegated expenses, and reporting direction; unresolved details remain explicit in the baseline. Original proposal text is preserved as history.

## 1. Status and conventions

This document proposes business workflows for owner review. It does not approve business rules and does not reuse prototype statuses as production facts.

Labels used below:

- **Known:** supplied cafe context or verified prototype behavior.
- **Assumption:** needed to reason, but not confirmed.
- **Recommendation:** preferred starting point, pending owner approval.
- **Open:** recorded in the [Business Decisions Register](../planning/phase-3.5-business-decisions-register.md).

Related: [architecture review](../research/phase-3.5.1-prototype-architecture-review.md), [domain model](phase-3.5.3-domain-model.md), [database design](phase-3.5.5-database-design.md).

## 2. Operating context

**Known:** AFTER FOUR has two floors, approximately 70–100 customers at capacity, drinks for floor 2 travel by elevator, the owner works in the cafe, and the initial team is approximately three people.

**Recommendation:** optimize for one person taking orders/cash, one preparing drinks and one flexing between service/delivery. Permissions should be capability-based so the owner can cover every role without creating a complex organization model.

## 3. End-to-end service flow

```text
Open shift
  → seat/identify visit
  → create draft order
  → add or revise items
  → submit items
  → create kitchen ticket(s)
  → prepare items
  → hand off floor 1 OR create floor 2 delivery work
  → deliver/serve
  → accept one or more payments
  → close order/visit
  → release table
  → reconcile and close shift
```

These lifecycles are related but independent. “Kitchen complete” must not automatically mean “delivered”, and “fully paid” must not silently mean “all items fulfilled”.

## 4. Opening and closing a shift

### Opening flow

1. Authorized staff chooses “Open shift”.
2. System records location, opening staff, opening time and optional opening cash balance.
3. System verifies no conflicting open shift under the approved shift model.
4. Shift becomes available for orders and payments.

Invariants proposed:

- An order created during staffed operation references an open shift.
- Opening cash is required only if cash handling/reconciliation is enabled.
- Staff must not backdate a shift without elevated permission and audit reason.

### Closing flow

1. System lists open orders, incomplete kitchen work, active deliveries and unsettled payment attempts.
2. Staff resolves them or an authorized manager explicitly carries them forward.
3. Cashier enters counted cash; system calculates expected cash from opening balance, cash payments and cash movements.
4. Variance and reason are recorded.
5. Authorized staff confirms closure; report snapshot is generated from committed transactions.

**Open:** whether unfinished orders can cross a shift, who may accept a variance, and whether a shift is per store, register or staff member (`BD-SHF-001`, `BD-SHF-002`).

## 5. Table workflow

### Meaning

- `Floor` is a physical service area.
- `DiningTable` is a stable physical table belonging to one floor at a time.
- `TableSession` is a customer visit/occupancy period. It prevents transient order state from being stored on the physical table.

### Proposed lifecycle

```text
available → occupied → closing → available
                  ↘ temporarily_unavailable
```

These labels are proposals. “Needs attention” is better treated as an operational flag/task than a physical table lifecycle state.

### Normal flow

1. Staff opens a session for a table (optionally with guest count).
2. Orders are associated with the session.
3. Table remains occupied while any order/session obligation is open.
4. After fulfillment and settlement rules pass, staff closes the session.
5. Table becomes available, optionally after a cleanup confirmation.

### Move, merge and split

- **Move:** end the current table assignment and add a new assignment; preserve history.
- **Merge:** associate multiple physical tables with one session, or merge sessions only through an explicit service with conflict checks.
- **Split:** move selected guests/items/checks to a new session or payment group; exact semantics require owner approval.
- **Release:** cannot delete history; closes active assignment/session after approved conditions.

**Recommendation:** MVP supports move-table history but defers merge/split unless the owner confirms they occur frequently. One open session per physical table is a useful invariant, but combined tables require a session-to-table assignment model rather than a single `table_id`.

## 6. Order workflow

### Proposed lifecycle

```text
draft → submitted → in_preparation → ready/partially_ready → fulfilled → closed
  ↘ cancelled         ↘ partially_cancelled
```

Payment is computed separately using the canonical `funding_status` and `attempt_activity` axes in [the Payment Model](../architecture/after_four_payment_model.md). This earlier proposal's single payment-status vocabulary is superseded.

### Normal flow

1. Staff creates a draft order under a table session, staff member and shift.
2. Products, quantities, notes and approved modifiers are added.
3. Server validates availability and calculates prices.
4. Staff submits new/changed items.
5. Submitted items produce kitchen ticket items; the original order remains the commercial record.
6. Later rounds add items to the same order or a new order according to `BD-TBL-001`.
7. Fulfillment and payment proceed independently.
8. Close occurs only when approved settlement/fulfillment rules pass.

### Edits and cancellation

- Draft items can be edited directly.
- After submission, changes become explicit adjustment/cancellation actions; do not rewrite already prepared history.
- A cancellation records actor, time, quantity and reason.
- If an item was paid or prepared, authorization and compensation/refund rules apply.
- Cancelling an order is not deletion and must not delete payment or inventory history.

### Additional orders and separate checks

Three possible models:

1. One order per table session; new rounds are submitted batches. Simple, but separate checks need payment allocation.
2. Multiple orders per table session. Flexible, but staff can lose the “whole table” view.
3. One order plus bill/check groups. Best long-term separation, more UI and domain work.

**Recommendation:** start with one active order per session and multiple submission rounds, while designing payments so they can allocate to order items later. Owner approval is required before schema implementation.

## 7. Catalog, product and pricing workflow

Catalog hierarchy proposal:

```text
Category → Product → ProductVariant
                     └→ allowed ModifierGroups → Modifiers
ProductVariant → Recipe
```

- `Product` describes what is sold (Latte).
- `ProductVariant` describes a sellable configuration with its own price/SKU (if sizes are used).
- `ModifierGroup` defines choices and cardinality; `Modifier` defines selectable options.
- Availability is explicit per sellable variant and can later consider stock.
- `OrderItem` stores snapshots of names, option labels, prices, tax basis and quantity. Catalog edits never rewrite an old sale.

**Open:** sizes, required/default modifiers, topping price, price scheduling, manual price override and out-of-stock behavior (`BD-CAT-001`, `BD-CAT-002`, `BD-CAT-003`).

## 8. Kitchen workflow

### Why Kitchen Ticket is separate

An order is a commercial aggregate; a kitchen ticket is fulfillment work. One order can create several tickets over time and, later, different preparation stations.

### Proposed flow

1. Submitting order items creates a ticket/batch transactionally.
2. Ticket is routed to a preparation station using configured product rules.
3. Barista accepts/starts items.
4. Items become ready individually or as a ticket.
5. Cancellation/update after start creates a visible change event and requires acknowledgement.
6. Ready work is handed off to floor service or Upstairs Delivery.

Proposed ticket states: `queued`, `in_progress`, `ready`, `completed`, `cancelled`; exact names/transitions remain open (`BD-KIT-001`).

Edge cases:

- Reprint/re-display must not create a second ticket.
- An item amendment after submission must reference the original ticket item.
- A failed preparation/remake is a new fulfillment action, not silent mutation.
- Multiple stations should be supported by a routing field, not separate services initially.

## 9. Upstairs Delivery workflow

### Domain placement

**Recommendation:** Delivery is a separate fulfillment aggregate inside the Fulfillment domain. It belongs neither to payment nor to the physical table and has its own assignment, attempt and completion history.

### Proposed flow

1. Eligible floor-2 kitchen items become ready.
2. System creates or updates a delivery work item after the kitchen transaction commits.
3. Staff claims or is assigned the delivery.
4. Staff takes the batch via elevator.
5. Recipient/table is verified.
6. Staff confirms success, or records a failure reason and next action.

Suggested states: `pending`, `assigned`, `in_transit`, `delivered`, `failed`, `cancelled`; pending owner approval.

Failure examples:

- Guest/table not found: return to handoff point or retry.
- Elevator unavailable: hold with visible delay reason.
- Wrong/incomplete items: return/reprepare; do not mark delivered.
- Device loses network: keep a visible pending confirmation with the same command ID; do not fabricate success.

`DeliveryItem` is needed only if partial batches from one order can be independently delivered. Otherwise a delivery can reference a set of kitchen ticket items through an assignment join.

## 10. Payment workflow

### Separation

- `Payment` represents settlement intent/allocation for an order.
- `PaymentTransaction` is an attempt or cash recording event for one method.
- `Refund` reverses a captured/recorded amount with authorization and reference.
- Order state, payment state and fulfillment state must remain distinct.

### Proposed flow

1. Server returns authoritative order balance and version.
2. Staff selects one or more tenders.
3. Each submission includes an idempotency key.
4. Cash: record tendered amount and server-calculated change.
5. Electronic: create attempt, wait for provider outcome outside a long DB transaction, then record result idempotently.
6. Allocate successful amount to the payment/order.
7. When paid amount equals payable balance, payment becomes settled; order closure still follows the approved fulfillment rule.

### Failure, void and refund

- Failure is retained as an attempt with a safe error category; retry uses a new attempt but the same user intent can remain idempotent.
- Void cancels an unsettled/authorized transaction when supported.
- Refund references the original successful transaction and never edits it.
- Cash refund and electronic refund have different reconciliation behavior.

**Open:** mixed tender, partial/split checks, tips, discount/tax policy, receipt/fiscal needs and provider integration (`BD-PAY-*`).

## 11. Staff, role and permission workflow

Minimum role templates proposed:

| Role template | Normal capabilities |
|---|---|
| Owner/Manager | All operations, configuration, overrides, refunds, reports and shift approval |
| Cashier/Service | Tables, orders, approved discounts, payments and delivery |
| Barista | Kitchen queue, preparation changes and handoff |

“Delivery staff” should initially be a capability that service/barista staff can hold, not a mandatory fourth role. Record the acting staff on sensitive commands. Manager override requires the manager's identity and a reason; never share a generic PIN without audit attribution.

## 12. Inventory and recipe workflow

Core concepts:

- `Ingredient` and `Unit` define stockable material and measurement.
- `Recipe`/`RecipeItem` specify expected consumption for a sellable variant.
- `StockMovement` is the append-only ledger for purchase, sale consumption, waste, adjustment, return and transfer.
- Current inventory balance may be derived or cached, but the ledger is authoritative.

Deduction timing choices:

| Timing | Advantages | Disadvantages |
|---|---|---|
| Order submitted | Early availability signal | Overstates consumption for cancelled/unprepared items |
| Kitchen accepted/started | Closest to commitment; supports cancellation before work | Requires kitchen events to be reliable |
| Item completed | Reflects completed preparation | Too late to prevent overselling; remakes/waste need extra events |

**Recommendation:** post expected consumption when kitchen preparation starts/accepts, then post compensating movements for cancellation, remake or waste. Owner must confirm actual practice and whether inventory is launch scope (`BD-INV-001`).

Purchases, suppliers, receiving and unit conversion are separate workflows and may be deferred without collapsing `StockMovement` into an editable quantity field.

## 13. Reports and reconciliation

Daily reporting should derive from committed records, with the cafe's business timezone and day boundary explicitly configured.

Minimum proposed outputs:

- Gross/net sales and refunds by business day.
- Successful payments by method and reconciliation variance.
- Sales quantity/value by product snapshot.
- Sales/actions by staff.
- Sales by floor/table session.
- Open/voided/cancelled orders and reasons.
- Kitchen and delivery timing once event quality is sufficient.

Reports are not a second source of truth. Start with SQL/read models in the modular monolith; add snapshots/materialized projections only when measured query load requires them.

## 14. Cross-cutting edge cases

| Situation | Safe proposed behavior | Owner decision needed |
|---|---|---|
| Guest changes item before submit | Edit draft | Whether price/availability is revalidated on submit |
| Guest changes item after submit | Cancel/adjust with reason; notify kitchen | Who may do it and whether prepared items are charged |
| Guest orders more | New submission batch | Same order or separate order/check |
| Guest moves table | Change table assignment; retain history | Restrictions during payment/delivery |
| Separate payment | Allocate tenders/check groups explicitly | Item split vs amount split |
| Payment fails | Preserve order, record failed attempt, allow safe retry | Provider-specific timeout policy |
| Refund | New refund linked to original transaction | Approval and time window |
| Open work at shift close | Block or manager-approved carryover | Which work may carry over |
| Delivery fails | Record reason, keep work actionable, retry/reassign | Retry ownership and escalation |
| Mistaken action | Explicit correction/void with actor and reason | Approval thresholds |
| Network loss | Display offline/stale state; queue only approved safe commands | Whether offline order capture is launch scope |

## 15. Workflow approval gate

Backend implementation should not start until the owner approves at least: table/session/order cardinality, order and kitchen submission semantics, delivery queue entry/ownership, payment methods and split rules, shift model, inventory deduction timing, minimum permissions and offline policy. These are the P0 entries in the [decision register](../planning/phase-3.5-business-decisions-register.md).
