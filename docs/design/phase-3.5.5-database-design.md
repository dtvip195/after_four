# Phase 3.5.5 — PostgreSQL Logical Database Design

> **HISTORICAL / SUPERSEDED_FOR_IMPLEMENTATION — not the implementation schema.** Its preparation-before-payment relationships and stale pending labels are superseded by the canonical [Owner Decision Baseline](../architecture/after_four_owner_decision_baseline.md), [ERD](../architecture/after_four_erd.md), [Data Dictionary](../architecture/after_four_data_dictionary.md), and [Data Integrity Rules](../architecture/after_four_data_integrity_rules.md). The current exact-balance Phase 1 schema remains authoritative for implemented behavior; future excess/refund evidence, Cash, Expense, and Reporting structures require separate design. Original proposal text is preserved.

## 1. Status

This is a logical schema proposal. It is not a migration specification and no database has been created. Table/column names may change after owner decisions and Rails conventions are finalized.

Related: [domain model](phase-3.5.3-domain-model.md), [backend architecture](phase-3.5.4-backend-architecture.md), [decisions](../planning/phase-3.5-business-decisions-register.md).

## 2. Global data conventions

### Primary keys

**Recommendation:** UUID primary keys for business records because future multi-device/offline command creation and opaque API IDs are plausible. PostgreSQL has a native UUID type intended for globally unique identifiers: [UUID type](https://www.postgresql.org/docs/current/datatype-uuid.html). This costs larger indexes and less locality than bigint.

**Open:** `BD-ARC-001` must approve UUID versus Rails-default bigint. Human identifiers such as order number, table code and SKU are separate unique business keys and never primary keys.

### Money

- Store monetary amounts as `bigint` integer units plus `currency_code char(3)`.
- For VND, the application policy initially treats one stored unit as one đồng.
- Never use binary floating point or a localized string.
- Do not use PostgreSQL `money`; its display/input behavior is locale-sensitive and it obscures cross-currency policy.
- Add checks such as `amount >= 0` where negative values are not meaningful; use signed deltas only in explicit ledgers.

### Quantities

- Sale item counts: positive integer.
- Ingredient quantities: `numeric(18,6)` in base units, with explicit unit/conversion rules.
- Never use float for inventory movement.

### Time

- Store event instants as `timestamptz` in UTC.
- Keep cafe timezone (for example an IANA identifier) in store configuration.
- Store `business_date` only where an approved operational day boundary needs a stable reporting key.
- Distinguish `occurred_at` from `recorded_at` for delayed/offline/audit events.

### Lifecycle and deletion

- Catalog/configuration/staff: `archived_at` or active flag; no destructive deletion when referenced.
- Orders, payments, shifts, stock movements, tickets and deliveries: lifecycle status plus append-only history/correction; never blanket soft-delete.
- Do not adopt a global `deleted_at` concern; it hides integrity questions and complicates uniqueness.

### Status representation

Do not create PostgreSQL enum types before workflows are approved. Prefer constrained text/smallint mapped by domain code, with database check constraints once the vocabulary is stable. Changes to transitions remain application/domain rules; allowed stored values remain database integrity rules.

### Common columns

- `created_at`, `updated_at` on mutable records.
- `lock_version integer not null default 0` on concurrently edited aggregate roots.
- `created_by_staff_id`/`updated_by_staff_id` only where attribution is meaningful; sensitive actions also produce audit records.

## 3. Relationship map

```text
floors ──< dining_tables
table_sessions ──< table_assignments >── dining_tables
table_sessions ──< orders ──< order_items ──< order_item_modifiers
orders ──< kitchen_tickets ──< kitchen_ticket_items >── order_items
kitchen_ticket_items >──< delivery_items >── deliveries
orders ──< payments ──< payment_transactions ──< refunds
shifts ──< orders / payments / cash_movements

categories ──< products ──< product_variants
products/variants >──< modifier_group_assignments >── modifier_groups ──< modifiers
product_variants ──< recipes ──< recipe_items >── ingredients
ingredients ──< inventories ──< stock_movements
```

`delivery_items` is conditional on owner-approved partial/batched delivery.

## 4. Service and table schema

### `floors`

- `id`, `code`, `name`, `position`, `archived_at`, timestamps.
- Unique active `code` per store/location.

### `dining_tables`

- `id`, `floor_id` FK, `code`, `name`, `capacity`, optional `layout_x/layout_y`, `archived_at`, timestamps.
- Index `floor_id`; unique active code according to approved scope.
- Check `capacity > 0` when present.

### `table_sessions`

- `id`, `shift_id` FK, `status`, `guest_count`, `opened_by_staff_id`, `closed_by_staff_id`, `opened_at`, `closed_at`, `lock_version`, timestamps.
- Checks: guest count positive when present; closed status/time coherence.
- Index `(status, opened_at)` and `shift_id`.

### `table_assignments`

- `id`, `table_session_id` FK, `dining_table_id` FK, `assigned_at`, `released_at`, `assigned_by_staff_id`, `release_reason`, timestamps.
- Indexes on session/time and table/time.
- Partial unique index on `dining_table_id WHERE released_at IS NULL` enforces at most one active assignment per physical table, if approved.
- Partial unique on `(table_session_id, dining_table_id) WHERE released_at IS NULL` avoids duplicate active assignment.

This model supports table moves and combined tables without overwriting `orders.table_id`.

## 5. Catalog schema

### `categories`

- `id`, `code`, `name`, `position`, `archived_at`, timestamps.
- Unique active code; index display order.

### `products`

- `id`, `category_id`, `code`, `name`, `description`, `archived_at`, timestamps.
- Unique stable code/SKU namespace; category index.

### `product_variants`

- `id`, `product_id`, `sku`, `name`, `base_price_amount`, `currency_code`, `is_available`, `archived_at`, timestamps.
- Unique SKU; checks non-negative price and currency format.

### `modifier_groups`, `modifiers`, assignments

- Groups: `id`, name/code, `minimum_selections`, `maximum_selections`, archived state.
- Modifiers: `id`, group FK, name/code, price delta, currency, archived state.
- Assignment join: product or variant scope, group, display order, optional overridden selection rules.
- Checks: non-negative selection bounds and `minimum <= maximum`.

Avoid polymorphic foreign keys if strict referential integrity is more valuable; separate `product_modifier_groups` and `variant_modifier_groups` are clearer.

## 6. Order schema and historical snapshots

### `orders`

- `id`, `order_number`, `table_session_id` nullable only if approved service modes require it, `shift_id`, `created_by_staff_id`.
- `status`, `currency_code`.
- Snapshot totals: `subtotal_amount`, `discount_amount`, `tax_amount`, `service_charge_amount`, `total_amount`.
- `submitted_at`, `closed_at`, `cancelled_at`, `lock_version`, timestamps.
- Unique `order_number`; indexes on table session, shift, status/time.
- Checks all component amounts non-negative and total consistency according to approved formula.

### `order_items`

- `id`, `order_id`, nullable source `product_id`/`product_variant_id` FKs.
- Snapshot fields: `product_code`, `product_name`, `variant_name`, `unit_price_amount`, `currency_code`.
- `quantity`, `note`, `status`, submitted/cancelled quantities, `submitted_at`, `cancelled_at`, cancellation reason/actor, timestamps.
- Index `order_id`; index source IDs for analysis, not historical display.
- Checks positive quantity, non-negative unit price, cancellation quantities within range.

### `order_item_modifiers`

- `id`, `order_item_id`, nullable source modifier/group IDs.
- Snapshot group name, modifier name/code, unit price delta, quantity, timestamps.
- Check quantity positive.

Why both FK and snapshot: the FK supports traceability/reporting when catalog records remain; snapshot fields preserve the sale exactly after rename, archive or price change. Historical rendering never depends on joining current catalog names/prices.

### Adjustments/events

For submitted-item changes, choose one of:

- explicit `order_item_adjustments` containing type, quantity delta, reason, actor, time; or
- immutable replacement/cancellation rows plus an audit event.

Do not overwrite submitted quantity/price without a durable explanation. Exact representation waits on `BD-ORD-003`.

## 7. Kitchen schema

### `preparation_stations`

- `id`, code, name, archived state.

### `kitchen_tickets`

- `id`, `ticket_number`, `order_id`, `preparation_station_id`, sequence, status, queued/started/ready/completed/cancelled times, `lock_version`, timestamps.
- Unique ticket number; unique `(order_id, sequence)`; indexes `(station_id, status, queued_at)` and `order_id`.

### `kitchen_ticket_items`

- `id`, `kitchen_ticket_id`, `order_item_id`, requested/prepared/cancelled quantities, display snapshots, status, timestamps.
- Unique source allocation key as needed to prevent duplicate ticketing.
- Checks quantities are non-negative and do not exceed requested quantity under approved remake rules.

An order can create multiple tickets for additional rounds or stations; ticket status is never a column on `orders`.

## 8. Delivery schema

### `deliveries`

- `id`, `delivery_number`, `order_id`, `table_session_id`, destination `floor_id` and optional active `table_assignment_id`.
- Destination snapshots: floor/table code and display label for operational/history safety.
- `status`, `assigned_staff_id`, `created_at`, `claimed_at`, `dispatched_at`, `delivered_at`, `failed_at`, `failure_reason_code`, notes, `lock_version`, timestamps.
- Unique number; indexes `(status, created_at)`, assigned staff/status and order.

### `delivery_items` (conditional)

- `delivery_id`, `kitchen_ticket_item_id`, quantity.
- Unique pair; check positive quantity.
- A database/application allocation guard must prevent total delivered quantity from exceeding ready quantity.

### `delivery_events`

- Delivery, event type, from/to state, actor, reason/note, occurred/recorded times, command ID.
- Append-only; useful for assignment, failed attempt and SLA history.

If every order is delivered as one inseparable batch, omit `delivery_items` initially and link the Delivery to the order/ticket batch. Owner must decide granularity.

## 9. Payment schema

### `payments`

- `id`, `order_id`, `currency_code`, `target_amount`, `successful_amount`, `refunded_amount`, `status`, `lock_version`, timestamps.
- Index order/status; checks amounts non-negative and currency consistent.
- Multiple payments per order are allowed by design. Do not put `payment_method` or one `paid_amount` field directly on `orders`.

### `payment_transactions`

- `id`, `payment_id`, `kind`, `method`, `status`, `amount`, currency.
- `idempotency_key`, request fingerprint, provider, provider transaction/event reference.
- Cash-specific `cash_received_amount`, `cash_change_amount` nullable.
- Actor/staff, initiated/completed/failed times, sanitized failure code, safe metadata, timestamps.
- Unique scoped idempotency key; partial unique provider reference where present.
- Index payment/time and provider/status.

### `refunds`

- `id`, original successful `payment_transaction_id`, amount/currency, status, reason, actor/approver, idempotency key, provider reference, timestamps.
- Checks positive amount; database/application locking prevents cumulative success over refundable amount.

### Payment allocation (if split checks/items are approved)

Add `payment_allocations` linking successful amounts to order/check/order items. Do not add before allocation semantics are known. Amount-only split can allocate to the order; itemized separate checks require a check/group model.

## 10. Staff, permissions and shifts

### `staff`

- `id`, employee code, name, authentication identity fields/reference, active state, timestamps.
- Unique employee code; never store plaintext PIN/password.

### `roles`, `permissions`, joins

- Stable unique role/permission keys.
- `staff_roles`, `role_permissions` with foreign keys and unique pairs.
- Seed small role templates; authorization remains policy code.

### `shifts`

- `id`, scope/location/register reference, opener/closer, status, opened/closed times, business date.
- Opening/expected/count cash amounts, variance, variance reason/approver, `lock_version`, timestamps.
- A partial unique index for open shift scope is possible only after `BD-SHF-001` defines scope.

### `cash_movements`

- Shift, type, signed amount, currency, source payment/reference, actor, reason, occurred time.
- Append-only; unique source/idempotency key.

## 11. Inventory schema

### `units`

- Code, name, dimension, factor to base unit, precision; unique code.

### `ingredients`

- Code, name, base unit FK, archived state; unique code.

### `recipes` and `recipe_items`

- Recipe: product variant, version, effective interval, yield, status.
- Item: recipe, ingredient, quantity, unit.
- Unique `(variant, version)`; no overlapping effective recipes enforced by application or PostgreSQL exclusion constraint if justified.

### `inventory_locations`

- Code/name; one default stock location initially, extensible without assuming one forever.

### `inventories`

- Location + ingredient unique pair, cached on-hand base quantity, `lock_version`, timestamps.

### `stock_movements`

- Inventory, signed base quantity delta, movement type, source type/ID or explicit source columns, reason, actor, occurred/recorded time, idempotency key, reversal movement reference.
- Append-only; unique idempotency/source key; indexes inventory/time and source.
- Cached balance update and ledger insert occur in one locked transaction.

Prefer explicit nullable source FKs for core sources (kitchen item, purchase receipt, adjustment) when practical. A polymorphic source is flexible but cannot be fully protected by foreign keys.

## 12. Audit and idempotency tables

### `audit_events`

- Actor/approver, action code, target type/ID, reason, safe before/after JSON summaries, request ID, occurred time.
- Append-only indexes on target/time, actor/time and action/time.
- JSON must exclude secrets and unnecessary personal/payment data.

### `idempotency_records`

- Scope, key, staff/device context, request fingerprint, processing/completed status, response resource/status, expiry/retention timestamps.
- Unique `(scope, key)`.
- Use row locking/atomic insert to prevent simultaneous duplicate processing.

This generic table can coexist with domain-specific unique idempotency keys on financial/ledger records.

## 13. Index and constraint strategy

- Every foreign key used for joins/cleanup gets an index; PostgreSQL does not automatically index referencing columns.
- Queue views use composite indexes beginning with selective status/scope and then time, e.g. `(preparation_station_id, status, queued_at)`.
- Partial unique indexes enforce “one active” rules without blocking historical rows.
- Check constraints protect local arithmetic/ranges; foreign keys protect identity; unique indexes protect race-sensitive uniqueness.
- Do not index every status/boolean alone; validate with real query plans and cardinality.
- Constraint names should be explicit and map to stable API error codes.

## 14. Transaction boundaries and lock order

| Use case | Records changed atomically | Lock focus |
|---|---|---|
| Submit items | Order/items, ticket/items, idempotency/outbox | Order version; allocation uniqueness |
| Move table | Session, old/new assignments, audit | Target tables in stable ID order |
| Record cash payment | Payment, transaction, cash movement, idempotency | Payment then shift |
| Apply provider result | Transaction, payment allocation, outbox | Payment transaction then payment |
| Complete delivery | Delivery/event, linked item allocation | Delivery version |
| Post stock | Movement, inventory cached balance | Inventory row |
| Close shift | Shift/reconciliation snapshot | Shift; verify dependent work without long locks |

Acquire multiple locks in a documented consistent order. Never keep transactions open while waiting for a person, elevator, printer or payment provider.

## 15. Reporting and retention

- Operational reports query transactional data/read views using cafe timezone/business date.
- Add materialized views or snapshot tables only after query performance and immutable report needs are measured.
- Historical snapshots on OrderItem/Modifier are permanent financial/service records under the approved retention policy.
- Define retention for provider payloads, audit events, idempotency records and staff identifiers with legal/accounting advice; this document cannot determine Vietnamese fiscal requirements.

## 16. Unresolved schema gates

No migration design should be finalized until owner approval covers:

- UUID versus bigint primary keys.
- Table session cardinality and combined/split table semantics.
- Order submission/cancellation lifecycle.
- Product variants/modifiers and price components.
- Kitchen ticket and delivery granularity.
- Partial/split payment allocation and real methods.
- Shift scope/business-day boundary.
- Inventory launch scope/deduction timing.
- Authentication/audit retention/offline command policy.

These gates are tracked in the [Business Decisions Register](../planning/phase-3.5-business-decisions-register.md).
