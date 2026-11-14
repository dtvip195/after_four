# Phase 3.5.3 — Logical Domain Model

> **HISTORICAL / SUPERSEDED_FOR_IMPLEMENTATION.** Order submission must not create preparation work before verified full settlement. Use the canonical [Owner Decision Baseline](../architecture/after_four_owner_decision_baseline.md), [DDD Foundation](../architecture/after_four_ddd_foundation.md), [Business Domain Model](../architecture/after_four_business_domain_model.md), [ERD](../architecture/after_four_erd.md), and [Payment Model](../architecture/after_four_payment_model.md). The bounded-module names and pending decisions below are historical proposals, not current authority; original text is preserved.

## 1. Design stance

This is a pragmatic domain model for one cafe location, not a mandate for full tactical DDD. The recommended deployment is a modular monolith. Aggregates protect transactional invariants; application services coordinate use cases; database constraints protect data integrity.

Status: **proposal pending owner approval**. Prototype fixture types and status strings are not production contracts.

Related: [workflows](phase-3.5.2-business-workflows.md), [backend architecture](phase-3.5.4-backend-architecture.md), [database design](phase-3.5.5-database-design.md), [decisions](../planning/phase-3.5-business-decisions-register.md).

## 2. Vocabulary

- **Entity:** has identity and continuity over time.
- **Value Object:** immutable descriptive value compared by content, such as `Money` or `Quantity`.
- **Aggregate Root:** transaction boundary through which members are changed.
- **Domain Service:** stateless domain rule spanning entities when no entity naturally owns it.
- **Application Service:** orchestrates authorization, repositories/records, transactions and side effects for a use case.

## 3. Bounded modules

```text
Identity & Workforce
  Staff, Role, Permission, Shift

Catalog
  Category, Product, ProductVariant, ModifierGroup, Modifier

Service
  Floor, DiningTable, TableSession, Order, OrderItem

Fulfillment
  PreparationStation, KitchenTicket, KitchenTicketItem, Delivery

Billing
  Payment, PaymentTransaction, Refund

Inventory
  Ingredient, Unit, Recipe, RecipeItem, Inventory, StockMovement

Reporting
  Read models derived from committed records
```

Module boundaries are code ownership boundaries, not separate services or databases.

## 4. Aggregate overview

| Aggregate root | Members/value objects | Core responsibility |
|---|---|---|
| Floor | DiningTable references | Physical floor identity and ordering |
| TableSession | TableAssignment, guest count, session events | Preserve one customer visit and table history |
| Order | OrderItem, OrderItemModifier, Money totals | Commercial intent, immutable sale snapshots and order lifecycle |
| KitchenTicket | KitchenTicketItem | Preparation work created from submitted order items |
| Delivery | DeliveryAssignment/attempt events, optional item links | Upstairs fulfillment lifecycle and history |
| Payment | PaymentTransaction, Refund references, Money allocations | Settlement lifecycle independent of order lifecycle |
| Shift | CashMovement/reconciliation | Staffed operating and cash reconciliation period |
| Product | ProductVariant and catalog configuration | Sellable catalog definition, not historical sales |
| Recipe | RecipeItem | Expected ingredient consumption for a variant |
| Inventory | StockMovement ledger association | Stock state per ingredient/location |

## 5. Service and table entities

### Floor — entity/aggregate root

- Attributes: `id`, `code`, `name`, `position`, active/archive state.
- Relations: has many physical dining tables.
- Invariants: code unique per location; archived floor cannot receive new sessions.
- Lifecycle: active → archived; historical references remain.

### DiningTable — entity

- Attributes: `id`, `floor_id`, `code`, display name, capacity, position metadata, active/archive state.
- Relations: belongs to Floor; participates in TableAssignments.
- Invariants: active code unique per location/floor according to owner choice; no two active sessions may claim the same table unless an explicit combined-table rule allows it.
- Note: use `DiningTable`/`dining_tables` to avoid ambiguity with SQL tables and UI table components.

### TableSession — aggregate root

- Attributes: `id`, `opened_at`, `closed_at`, `opened_by_staff_id`, `guest_count`, lifecycle/version.
- Members: time-bounded `TableAssignment` records.
- Relations: contains one or more Orders; belongs to opening Shift.
- Invariants: a closed session has no active assignment; movement closes the old assignment before opening the new one; close conditions follow owner-approved payment/fulfillment rules.
- Value: separates physical furniture from a guest visit and preserves table movement history.

## 6. Catalog entities

### Category — entity

- Attributes: name, code/slug, display order, active/archive state.
- Relations: contains Products.
- Invariants: archived categories remain referenceable historically; ordering is deterministic.

### Product — aggregate root

- Attributes: name, internal code, description, category, active/archive state, availability policy.
- Members: ProductVariants; assignments to ModifierGroups.
- Invariants: product cannot be sold without an active sellable variant; archive does not alter order snapshots.

### ProductVariant — entity

- Attributes: SKU/code, label, current base price, availability, optional recipe reference.
- Invariants: SKU unique; price non-negative; currency consistent with store configuration.
- Open: a default variant may represent products without size (`BD-CAT-001`).

### ModifierGroup / Modifier — entities

- Group attributes: name, minimum/maximum selections, required flag, display order.
- Modifier attributes: name, price delta, active state.
- Relations: groups are allowed for products/variants; modifiers belong to a group.
- Invariants: `0 ≤ min ≤ max`; selected modifiers must have been allowed at order time.

## 7. Order aggregate

### Order — aggregate root

- Attributes: public order number, table session, shift, creator, lifecycle, payment summary, totals, timestamps, `lock_version`.
- Members: OrderItems and their snapshot modifiers.
- Relations: source for kitchen tickets and payments, but does not own their lifecycle.
- Invariants:
  - Quantity is positive.
  - Monetary totals use server-side `Money` rules and equal the sum of persisted line components.
  - Submitted items cannot be silently rewritten; changes are traceable adjustments/cancellations.
  - Closed/cancelled orders reject ordinary edits.
  - Every command checks expected version to detect stale clients.

### OrderItem — entity inside Order

- Attributes: catalog IDs plus snapshot SKU/name/variant label, unit price, quantity, note, status, submitted/cancelled quantities, timestamps.
- Members: OrderItemModifier snapshots.
- Invariants: historical snapshots are immutable after submission except explicit correction records; cancelled quantity cannot exceed ordered quantity.

### OrderItemModifier — value-like entity

- Attributes: source modifier ID (nullable for retained history), group/name snapshots, unit price delta, quantity.
- Invariant: it preserves the exact sold configuration even if catalog configuration changes.

### Suggested value objects

- `Money(amount_minor, currency)`; VND initially uses whole đồng as integer minor amount by policy.
- `Quantity(value, unit)`; count quantity is a positive integer for sale items.
- `OrderNumber`; human-readable, unique and not used as the primary key.
- `OrderTotals`; subtotal, discounts, tax/service charges and payable total with named components.

## 8. Fulfillment aggregates

### PreparationStation — entity/configuration

- Attributes: code, name, active state, routing priority.
- Purpose: supports one bar initially without forcing all future preparation into one queue.

### KitchenTicket — aggregate root

- Attributes: order ID, station ID, sequence/batch, lifecycle, queued/started/ready/completed times, version.
- Members: KitchenTicketItems referencing immutable OrderItem identity and submitted quantity.
- Invariants: one submitted item quantity is not accidentally ticketed twice; state changes follow explicit transitions; cancellation/amendment is recorded.

### KitchenTicketItem — entity

- Attributes: order item ID, display snapshots, requested quantity, prepared/cancelled quantity, lifecycle and notes.
- Invariants: fulfillment quantities cannot exceed ticketed quantity without an explicit remake record.

### Delivery — aggregate root

- Attributes: order/table session references, destination floor/table snapshots, lifecycle, assigned staff, created/claimed/dispatched/delivered times, failure reason, version.
- Relations: references eligible KitchenTicketItems through a join when partial delivery matters.
- Invariants: only ready, undelivered work enters a delivery; successful delivery requires actor/time; failed delivery remains actionable; state transitions are auditable.
- Decision: retain as an independent aggregate because assignment/failure/history differ from Order. `DeliveryItem` becomes a distinct entity only for partial batches.

## 9. Billing aggregates

### Payment — aggregate root

- Attributes: order ID, currency, target amount, allocated/successful/refunded totals, lifecycle, version.
- Members: PaymentTransactions; references Refunds.
- Invariants: successful allocations never exceed approved balance unless overpayment is explicitly supported; state is derived from immutable transaction outcomes, not copied from order status.

### PaymentTransaction — entity

- Attributes: payment ID, method, kind (`charge`, `cash_tender`, `void`), amount, status, idempotency key, provider reference, cash received/change, initiated/completed time, actor, sanitized failure code.
- Invariants: idempotency key unique in its scope; successful external reference is unique where provided; cash change is server-calculated; failed attempts remain historical.

### Refund — aggregate root or controlled transaction entity

- Attributes: original transaction, amount, method/status, reason, actor/approver, provider reference, timestamps.
- Invariants: cumulative successful refund cannot exceed refundable amount; original success is never edited; required permission/reason is enforced.
- Recommendation: make Refund independently addressable if asynchronous provider outcomes or approval flow exist; otherwise a controlled Payment child is sufficient for MVP.

## 10. Workforce and shift

### Staff — entity/aggregate root

- Attributes: employee code, display name, active state, authentication identity reference.
- Relations: roles/permissions; acts on shifts, orders, tickets, deliveries and payments.
- Invariant: deactivation prevents new sessions/actions but retains history.

### Role and Permission — entities/configuration

- Role groups capabilities; Permission is a stable capability key such as `payments.refund`.
- Start with three role templates, not a policy-builder UI.
- Authorization policies evaluate current staff, capability and resource context.

### Shift — aggregate root

- Attributes: location/register scope, opener/closer, opening/closing cash, times, status, variance/reason.
- Members or related ledger: cash movements.
- Invariants: closure is explicit and auditable; expected cash derives from movements; unresolved work follows the approved close policy.

## 11. Inventory aggregates

### Unit — value/config entity

- Attributes: code, label, measurement dimension and precision.
- Invariant: conversions only within the same dimension and are explicit.

### Ingredient — entity

- Attributes: code, name, base unit, active/archive state.
- Historical stock movement remains after archive.

### Recipe — aggregate root

- Attributes: product variant, version/effective dates, yield.
- Members: RecipeItems.
- Invariants: at most one effective recipe version for a variant/time; quantity is positive; unit is convertible to ingredient base unit.

### RecipeItem — value-like entity

- Attributes: ingredient, quantity, unit, waste factor if approved.

### Inventory — aggregate root per stock location/ingredient

- Attributes: stock location, ingredient, cached on-hand quantity, version.
- Relations: StockMovement ledger.
- Invariants: every balance change has a movement; negative stock policy is explicit; concurrent posting uses locking/versioning.

### StockMovement — immutable ledger entity

- Attributes: quantity delta, unit/base quantity, reason type, source type/ID, actor, occurred/recorded times, correction reference.
- Invariants: immutable after posting; correction uses a reversing movement; source command is idempotent.

## 12. Domain and application services

Domain services, only where a single aggregate cannot naturally decide:

- `PricingPolicy`: calculates validated price components from catalog and approved promotions/tax policy.
- `TableAvailabilityPolicy`: evaluates assignments and combined-table rules.
- `InventoryConsumptionPolicy`: turns preparation actions and recipe version into movements.
- `OrderClosurePolicy`: evaluates settlement and fulfillment conditions without merging their lifecycles.

Application services/use cases:

- `OpenShift`, `CloseShift`
- `OpenTableSession`, `MoveTable`, `CloseTableSession`
- `CreateOrder`, `ChangeDraftOrder`, `SubmitOrderItems`, `CancelOrderItem`
- `StartKitchenTicket`, `MarkItemsReady`
- `CreateDelivery`, `ClaimDelivery`, `CompleteDelivery`, `FailDelivery`
- `RecordCashPayment`, `InitiateElectronicPayment`, `ApplyPaymentResult`, `RefundPayment`
- `PostStockMovement`

Each use case owns authorization, one explicit transaction boundary, locking/idempotency and response mapping. Avoid a generic `OrderService` containing every operation.

## 13. Cross-aggregate consistency

- Strong consistency inside one database transaction for: order submission + ticket creation; cash payment + payment allocation; table move assignment history; stock movement + cached balance.
- External provider calls occur outside DB transactions. Persist intent first, call provider, then apply result idempotently.
- Realtime broadcasts and background jobs occur after commit. They are notification mechanisms, not the source of truth.
- Reporting may be eventually consistent, while order/payment correctness remains transactional.

## 14. Model exclusions for MVP

Do not add until a confirmed workflow needs them:

- Microservice-specific integration events as separate infrastructure.
- Customer/loyalty profile.
- Reservation, delivery-to-address or multi-store tenancy.
- Promotion rule engine.
- Dedicated `DeliveryStaff` entity.
- Supplier/purchase-order aggregates if inventory purchasing is out of initial scope.
- General workflow/state-machine engine.

## 15. Approval needs

The model cannot be finalized until P0 decisions define table/order cardinality, lifecycle transitions, kitchen submission, delivery granularity, payment allocation, shift scope, inventory timing, permissions and offline behavior. After approval, create a project glossary and ADRs for durable terminology and architectural choices; none are created in this phase because recommendations are not owner decisions.
