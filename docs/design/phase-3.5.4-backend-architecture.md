# Phase 3.5.4 — Backend Architecture Proposal

> **HISTORICAL / PARTIALLY SUPERSEDED.** The modular-monolith direction was later formalized by the Accepted architecture ADRs, and a Rails backend now exists. The route examples, old `PaymentTransaction` terminology, scale assumptions, and module names below are not current implementation authority. Use the canonical [Owner Decision Baseline](../architecture/after_four_owner_decision_baseline.md), [DDD Foundation](../architecture/after_four_ddd_foundation.md), [API Contract](../architecture/after_four_api_contract.md), and [Phase 1 implementation record](../architecture/after_four_order_payment_implementation_phase1.md). Original proposal text is preserved.

## 1. Recommendation

Build a **Rails API modular monolith backed by one PostgreSQL database**. Keep module boundaries explicit in code, but deploy one application initially. Do not add Redis, Sidekiq, WebSockets or microservices until a measured requirement justifies their operational cost.

This is architecture research only. No backend has been created.

Related: [domain model](phase-3.5.3-domain-model.md), [database design](phase-3.5.5-database-design.md), [decisions](../planning/phase-3.5-business-decisions-register.md), [roadmap](../planning/phase-3.5-production-roadmap.md).

## 2. Why a modular monolith

Known scale: one cafe, two floors, roughly three initial staff and 70–100 customers at capacity.

Advantages:

- One atomic database transaction can protect order, kitchen ticket, payment and inventory boundaries where appropriate.
- One deployable and one operational data store reduce failure modes for a small team.
- Rails conventions make validation, authorization, logging and tests straightforward.
- Modules can be extracted later only if independent scaling/ownership becomes real.

Microservices would add network partial failure, distributed transaction/idempotency, multiple deployments and observability burden without current evidence of benefit.

## 3. Proposed module layout

Names are illustrative; exact Rails namespaces should be chosen during backend foundation.

```text
app/
├── controllers/api/v1/
├── contexts/
│   ├── identity/
│   ├── catalog/
│   ├── service/
│   ├── fulfillment/
│   ├── billing/
│   ├── inventory/
│   └── reporting/
├── models/                 # Active Record persistence models
├── policies/               # authorization policies
├── serializers/            # versioned response mapping
├── jobs/                   # only justified asynchronous work
└── lib/observability/
```

Boundary rules:

- Controllers parse/validate request shape, authenticate, authorize and call one use case.
- Application services implement named commands and own transaction boundaries.
- Domain policies/value objects express calculations and transitions.
- Active Record models own persistence associations and local invariants, not HTTP response formatting.
- Serializers/presenters produce API DTOs. Never serialize arbitrary Active Record graphs.
- Modules reference stable public interfaces; avoid circular callbacks across domains.

## 4. REST API shape

Use `/api/v1` from the first endpoint. Version changes by compatibility, not release sprint.

Illustrative resources and commands:

```text
GET    /api/v1/catalog/products
GET    /api/v1/floors
GET    /api/v1/table-sessions/:id
POST   /api/v1/table-sessions
POST   /api/v1/table-sessions/:id/moves

POST   /api/v1/orders
GET    /api/v1/orders/:id
PATCH  /api/v1/orders/:id/draft
POST   /api/v1/orders/:id/submissions
POST   /api/v1/order-items/:id/cancellations

GET    /api/v1/kitchen-tickets
POST   /api/v1/kitchen-tickets/:id/start
POST   /api/v1/kitchen-ticket-items/:id/ready

GET    /api/v1/deliveries
POST   /api/v1/deliveries/:id/claim
POST   /api/v1/deliveries/:id/complete
POST   /api/v1/deliveries/:id/fail

POST   /api/v1/orders/:id/payments
POST   /api/v1/payment-transactions/:id/refunds

POST   /api/v1/shifts
POST   /api/v1/shifts/:id/close
```

Use command subresources for meaningful transitions rather than a generic `PATCH status`. Commands carry `expected_version`, a request/idempotency key where retry is possible, and a reason for sensitive actions.

Response conventions:

- IDs are opaque strings to the client.
- Monetary values are integer amounts plus ISO currency, never localized strings.
- Timestamps are ISO 8601 UTC; the client localizes using cafe timezone.
- Include aggregate `version`/`lock_version` where users may edit concurrently.
- Return stable machine error codes and human-safe Vietnamese messages separately.

## 5. Authentication and authorization

Open questions: identity provider, device trust, staff PIN/password and session duration.

Recommended baseline:

- Individual staff identity; no shared anonymous cashier account.
- Secure, expiring server session/token appropriate to the deployment topology.
- Capability-based authorization policies with three role templates: Owner/Manager, Cashier/Service, Barista.
- Re-authentication/manager approval for refunds, manual price changes, shift variance and destructive corrections.
- Record actor, approver and reason on sensitive actions.

Do not implement a configurable enterprise RBAC engine initially. A small role-permission join plus policy classes is sufficient.

## 6. Transactions, locking and concurrency

Rails transactions apply to one database connection and protect all-or-nothing changes across Active Record classes. Keep them short and never wait for user input or an external payment provider inside them. The official Rails transaction documentation also notes that after-commit is the safe boundary for external effects: [Active Record Transactions](https://api.rubyonrails.org/classes/ActiveRecord/Transactions/ClassMethods.html).

Recommended controls:

- Add `lock_version` to mutable aggregates such as Order, TableSession, KitchenTicket, Delivery, Payment and Inventory balance. Rails optimistic locking rejects stale writes: [Active Record locking](https://guides.rubyonrails.org/active_record_querying.html#locking-records-for-update).
- Use targeted `SELECT … FOR UPDATE`/`with_lock` for short, high-contention invariants such as claiming a delivery, allocating a payment or posting inventory. PostgreSQL row locks block competing writers until transaction end and should be acquired in a consistent order to limit deadlocks: [PostgreSQL explicit locking](https://www.postgresql.org/docs/current/explicit-locking.html).
- Rely on unique/check/foreign-key constraints as the final race-safe guard.
- On serialization/deadlock errors, retry the entire transaction with a bounded policy; PostgreSQL requires transaction restart for serialization failures: [transaction isolation](https://www.postgresql.org/docs/current/transaction-iso.html).
- Do not rescue a database statement error and continue inside the same PostgreSQL transaction.

Illustrative atomic boundaries:

- Submit order items + persist price snapshots + create kitchen ticket/items.
- Move table + close prior assignment + open new assignment.
- Record cash transaction + allocate amount + update payment summary.
- Post stock movement + update cached inventory balance.
- Close shift + persist reconciliation snapshot after preconditions pass.

## 7. Idempotency

Idempotency is mandatory for commands that users/devices may retry:

- order creation/submission;
- electronic payment initiation/result webhook;
- cash payment confirmation;
- delivery completion;
- stock movement posting.

Store `(scope, idempotency_key)` with request fingerprint, status and resulting resource/reference. Repeating an identical command returns the original result; reusing a key with different payload is a conflict. Database uniqueness, not only application checks, enforces this.

## 8. External payment pattern

Do not hold a database transaction open during provider communication.

1. In a transaction, validate authoritative balance and create a pending PaymentTransaction with idempotency key.
2. Commit.
3. Call provider or present provider instructions.
4. In a new transaction, apply provider response/webhook idempotently and allocate successful amount.
5. Publish UI notification after commit.

Webhooks require signature verification, replay protection, provider event uniqueness and raw/sanitized audit metadata. Provider secrets never reach the frontend.

## 9. Background jobs and realtime

### Initial recommendation

- Use synchronous requests for core commands that staff must immediately confirm.
- Poll kitchen/delivery lists at a modest interval if multi-device updates are needed in the first production slice.
- Add Active Job only for work that is safely asynchronous: receipt delivery, report generation, outbox delivery or webhook follow-up.
- Rails documents Active Job as a common interface and current Rails defaults to a database-backed Solid Queue; this does not make a worker mandatory before an async use case exists: [Active Job Basics](https://guides.rubyonrails.org/active_job_basics.html).

### Realtime trigger

Adopt Action Cable/WebSockets only if polling latency or request volume measurably harms kitchen/delivery operation. It introduces connection, channel, subscription-adapter and deployment concerns; production adapters must be selected intentionally: [Action Cable Overview](https://guides.rubyonrails.org/action_cable_overview.html).

No Redis or Sidekiq is recommended initially. Re-evaluate when there is sustained job throughput, strict retry scheduling, many realtime clients or operational evidence that the database-backed approach is insufficient.

## 10. Reliable post-commit events

Cross-module notifications should not depend on fragile model callback chains.

Recommended evolution:

1. Begin with explicit application-service calls inside a transaction when strong consistency is required.
2. For asynchronous notifications, write an outbox record in the same transaction.
3. A job delivers outbox events after commit; consumers are idempotent.

Examples: `OrderItemsSubmitted`, `KitchenItemsReady`, `PaymentSettled`, `DeliveryCompleted`. These are internal module events in one app, not a reason to deploy a message broker.

## 11. API error model

Suggested envelope:

```json
{
  "error": {
    "code": "order_version_conflict",
    "message": "Đơn đã được cập nhật trên thiết bị khác.",
    "request_id": "opaque-id",
    "details": { "current_version": 8 }
  }
}
```

Categories:

- `400` malformed request;
- `401` unauthenticated;
- `403` not permitted;
- `404` absent/inaccessible resource;
- `409` lifecycle, uniqueness, stale-version or idempotency conflict;
- `422` valid shape but domain validation failed;
- `429` rate limit where needed;
- `5xx` unexpected/server/provider unavailable with safe message.

Never expose stack traces, SQL, secrets, raw provider payloads or private staff data.

## 12. Logging, audit and observability

Operational logging:

- Structured logs with request ID, staff ID, device/session ID, endpoint, duration, status and safe resource IDs.
- Metrics for request latency/error rate, command conflicts, payment outcome, job age/failure and database pool saturation.
- Traces can be added when external integrations exist.

Audit trail:

- Append-only records for order cancellation, manual price/discount, table move/merge, payment/refund/void, shift closure/variance, permission change and stock adjustment.
- Store actor, approver, action, target, reason, before/after summary and timestamp.
- Avoid duplicating full sensitive payloads; define retention and access policy.

Audit log is not a replacement for domain ledgers such as PaymentTransaction or StockMovement.

## 13. Offline and degraded network

There is no confirmed offline requirement. Until `BD-OFF-001` is approved:

- Show connectivity/stale-data state clearly.
- Do not claim success before server confirmation for payment, submission, delivery completion or stock adjustment.
- Preserve unsent draft form state locally only if explicitly designed; label it unsynced.
- Retry commands with stable idempotency keys.
- On version conflict, fetch current state and ask the operator to reconcile instead of last-write-wins.

Full offline POS adds local persistence, command ordering, catalog snapshots, conflict resolution and security scope; it is a separate product capability, not a request retry setting.

## 14. Testing strategy

- Domain unit tests: transitions, pricing, quantity, closure and permission policies.
- Application-service tests: transaction behavior, idempotency, concurrency and rollback.
- Model/constraint tests: foreign keys, uniqueness, checks and snapshot retention.
- Rails request tests: auth, errors, DTO contract and API version.
- Contract tests shared with TypeScript-generated/manual DTO types.
- Provider adapter/webhook tests with signed fixtures; never call real payments in routine tests.
- Playwright E2E against a seeded test API for a small number of critical workflows; retain component/responsive tests.
- Concurrency tests for two devices editing an order, claiming delivery and paying the same balance.

## 15. Security and operational baseline

- TLS in transit; encrypted credentials/secrets; least-privilege database user.
- CSRF/CORS/session choices depend on frontend/backend origin topology and must be designed together.
- Rate-limit authentication and provider webhook endpoints.
- Backups with tested restore procedure; monitoring and alerting before production.
- Database migrations are backward-compatible across deployment steps.
- Health/readiness endpoints verify application and critical dependencies without exposing internals.

## 16. Architecture decision gates

Before implementation, approve the P0 workflow decisions and then record ADRs for:

1. Rails API modular monolith and module boundaries.
2. Primary key strategy.
3. Authentication/session topology.
4. Command idempotency and concurrency strategy.
5. Background job/realtime choice if a concrete use case exists.
6. Offline product scope.

The [production roadmap](../planning/phase-3.5-production-roadmap.md) sequences these gates before the Core POS API.
