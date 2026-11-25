# AFTER FOUR — Rails/PostgreSQL Foundation Readiness Review

**Status:** Architecture readiness decision; documentation only  
**Date:** 2026-11-14  
**Decision:** `READY_WITH_CONDITIONS`  
**Next phase:** Rails/PostgreSQL foundation planning and implementation, limited by the gates in Section 3

> **Resolution update — 2026-11-14:** The Payment-axis condition identified by this review is resolved by the [Canonical Payment Model](after_four_payment_model.md) and synchronized canonical documents. Foundation choices are now recorded in [ADRs](adr/) and summarized in [Foundation Decisions](after_four_foundation_decisions.md). ADR-0002 is Accepted after exact-runtime verification; ADR-0006 and ADR-0008 remain Proposed. The findings below preserve the evidence and reasoning at the time of review.
>
> **Terminology resolution:** This historical review used Payment Transaction/`payment_transactions` for an attempt record. Canonical Phase 1 terminology is Payment Attempt, implemented as `PaymentAttempt` and `payment_attempts`; no `PaymentTransaction` model or `payment_transactions` table exists. Historical wording below is retained as evidence, not as a physical-schema claim.

## 1. Executive decision

AFTER FOUR is ready to begin a deliberately small Rails API/PostgreSQL foundation, but it is not ready for an unconstrained production POS implementation.

The recommended foundation remains one API-only Rails modular monolith, one PostgreSQL database, versioned REST/JSON under `/api/v1`, explicit application transactions, Active Job only for justified asynchronous work, and a transactional outbox for reliable post-commit effects. This is the smallest architecture that can protect the confirmed payment-to-preparation invariant while keeping deployment and operations understandable for the current team and scale.

At review time, the decision was conditional for two reasons:

1. the physical schema had to correct the then-known aggregate Payment-status ambiguity before its first Payment migration; this is now resolved; and
2. several implementation-shaping technical choices still require explicit approval before scaffolding or migrations become durable commitments.

Foundation work that does not encode unresolved business policy may proceed after the technical baseline is approved. Electronic payment, production cash acceptance, refunds, split payments, offline operation, tax/accounting outputs, and several later domains remain separately blocked.

### Readiness summary

| Area | Finding | Decision |
|---|---|---|
| Canonical business rules | Organization/Brand/Branch scope, historical snapshots, full payment before preparation, append-only corrections, and idempotency are explicit. | Ready for foundation. |
| Logical data model | Relationships, field types, keys, and integrity split are unusually complete for a pre-implementation system. | Ready with physical-schema review. |
| Payment model | The state-machine document identified separate settlement and attempt activity; the Data Dictionary and API are now synchronized to those axes. | Resolved by the Canonical Payment Model. |
| Rails architecture | The modular-monolith proposal aligns with the canonical domain and current scale. | Ready after version/layout decisions. |
| PostgreSQL | PostgreSQL supports the required FK, unique, check, range/exclusion, row-lock, numeric, and transaction controls. | Ready after migration-level constraint design. |
| Authentication/security | Twenty-eight Owner policies are confirmed, including individual PIN scope/format/online-defense requirements, password/PIN cryptographic boundaries, Branch Manager boundaries, invitation delegation, lifecycle authority, Owner-recovery principles, one-origin production policy, audit classes/access, no numeric MVP session cap, and Owner-led review governance. Exact controls, dependency/profile, procedures, infrastructure, legal/privacy obligations, and executed Owner-review evidence remain unresolved; independent/legal review is not performed. | Foundation seam exists; Milestone 2B/production authentication remain blocked by ADR-0006 and its security checklist. |
| Frontend integration | The React application is a fixture/local-state prototype with browser tests but no API client or authenticated state. | No backend contract can be inferred from UI types. |
| Production payment | Provider, authoritative result contract, webhook details, and reconciliation adapter are unknown. Cash drawer topology is also open. | Blocked; use only a test adapter in the non-production slice. |
| Operations | Logging, health, backup, restore, migration, worker, and secrets expectations are stated but not implemented. | Must be delivered progressively before production. |

## 2. Evidence reviewed

This review treats executable code as implementation and documents as design evidence. The repository currently contains a frontend foundation only (`AGENTS.md:3-13`). The architecture gap analysis likewise finds no backend, database, ORM, authentication, authorization, API client, persistence, worker, or external integration (`docs/research/after_four_architecture_gap_analysis.md:5-23`).

### Canonical architecture set

- Business concepts, provenance, ownership, and the corrected paid-before-preparation rule: `docs/architecture/after_four_business_domain_model.md:1-37,60-79,101-137,232-257,305-339`.
- Logical entities, scope, uniqueness, historical/concurrency risks, and review gates: `docs/architecture/after_four_erd.md:1-45,60-80,350-375,377-434`.
- Candidate PostgreSQL types and fields: `docs/architecture/after_four_data_dictionary.md:13-35,221-263`.
- Constraint/application/operation enforcement split, lock order, append-only rules, and retention: `docs/architecture/after_four_data_integrity_rules.md:7-34,61-83,85-141,156-188,249-329`.
- Versioned REST contract, server-derived scope, idempotency, concurrency, payment commands, and external seams: `docs/architecture/after_four_api_contract.md:7-38,68-128,185-222,355-411`.
- Independent state axes and authoritative payment flow: `docs/architecture/after_four_state_machines.md:7-39,41-76,116-195`.
- Stable error envelope and safe unknown-payment behavior: `docs/architecture/after_four_api_error_catalog.md:7-63,65-99,114-149`.
- Implemented-versus-proposed baseline and risk inventory: `docs/research/after_four_architecture_gap_analysis.md`.

### Existing implementation and proposal evidence

- The frontend uses React/TypeScript/Vite, with npm scripts for typecheck, lint, build, and Playwright (`frontend/package.json:1-42`).
- Playwright runs 13 browser spec files against the Vite development server and configures one desktop Chromium project (`frontend/playwright.config.ts:1-33`; `frontend/tests/e2e/`). These tests do not exercise an API or database.
- POS and upstairs-delivery behavior lives in feature-local fixtures/hooks. No `fetch`, XHR, WebSocket, EventSource, browser-storage integration, backend runtime, migration, deployment manifest, or CI configuration was found.
- The existing backend proposal recommends the same Rails API modular monolith and one PostgreSQL database, and explicitly says no backend exists (`docs/design/phase-3.5.4-backend-architecture.md:1-22`). Its controller/use-case/domain/model/presenter separation, locking, idempotency, outbox, test, security, and operations advice remains sound where the newer canonical documents do not supersede it (`docs/design/phase-3.5.4-backend-architecture.md:24-53,114-183,241-270`).

## 3. Conditions and exact blockers

### 3.1 Conditions before creating the Rails application

Record and approve a short foundation ADR covering all of the following:

1. **Repository layout:** use `backend/` for the Rails application, retaining `frontend/` as the independently buildable Vite application. This avoids moving working frontend files and makes the two runtimes explicit.
2. **Runtime versions:** select an actively maintained Rails release and a supported Ruby and PostgreSQL combination at implementation time. Pin exact versions in runtime/tooling files and CI. This report intentionally does not pretend an exact Rails version has already been approved.
3. **Primary keys:** accept UUID primary keys, matching the Data Dictionary, or deliberately replace that recommendation before any migration. Do not mix strategies incidentally.
4. **Deployment origin and session topology:** approve same-origin browser deployment with secure server session cookies and CSRF protection as the default, or document why a bearer-token adapter is required. CORS and credential storage depend on this choice.
5. **Initial operational topology:** identify the application process, database, optional worker process, secrets source, migration owner, and development/test database provisioning. No production hosting vendor is required yet.

These are technical ownership decisions, not new business policy. Until approved, repository inspection and migration design may continue, but generated Rails files and persistent schema history should not.

### 3.2 Resolved condition before the first Payment migration or payment DTO

The correction in Section 4 is accepted: the aggregate uses `funding_status` and `attempt_activity`, and the canonical documents are synchronized. A migration or public DTO must follow the [Canonical Payment Model](after_four_payment_model.md) and must not reintroduce a single aggregate status.

### 3.3 Blockers by capability

| Capability | Exact blocker | What may proceed |
|---|---|---|
| Rails/PostgreSQL foundation | The five choices in 3.1 are not approved. | Architecture and migration planning only. |
| Payment aggregate | Resolved: the correction is accepted in the Data Dictionary/API representation. | Payment migration/DTO design may proceed after the remaining foundation entry gates. |
| Production electronic payment | Provider/method, signed event format, provider idempotency semantics, safe metadata, authoritative query/reconciliation contract, and credentials ownership are unknown. | Internal port, fake adapter, attempt/state tests. |
| Production cash payment | Physical drawer/register topology and one-open-session scope are unresolved. | Cash-independent payment domain; no real cash acceptance. |
| Split/partial payment | Allocation target, rounding, retry, refund allocation, and whether partial tender is allowed are open. | Exact-balance-only behavior; retain `partially_paid` as reserved vocabulary. |
| Refund/cancellation/remake | Authority, thresholds, allocation, and post-dispatch compensation are open. | Read models and immutable original records only; execution disabled. |
| Production authentication | Owner policies are confirmed; hashing/PIN limits, MFA method, recovery procedures, lifecycle authority, device trust, audit retention, and deployment topology remain unapproved or unreviewed. | No implementation until the [Identity Security Review Checklist](after_four_identity_security_review_checklist.md) and ADR-0006 gates are satisfied. |
| Production finance/tax | Current legal/accounting/provider requirements and retention are unvalidated. | Non-tax foundation/prototype only. |
| Offline operation | Allowed offline commands, local security, ordering, conflict rules, and idempotency lifetime are unapproved. | Online-authoritative API only. |
| Production launch | Hosting, TLS termination, monitoring/alerts, backup schedule, tested restore, incident ownership, migration/rollback procedure, and secrets rotation are absent. | Local/test/staging implementation. |

Open decisions outside the selected vertical slice—inventory valuation, payroll, loyalty, transfers, generalized approvals, and customer merge/consent—must not be smuggled into foundation abstractions. They do not block the narrow Product → Order → Payment → Preparation slice.

## 4. Mandatory Payment model correction

### 4.1 Problem

The canonical business model originally lists `Unpaid`, `Processing`, `Unknown`, `Partially Paid`, `Fully Paid`, `Partially Refunded`, and `Fully Refunded` as if they formed one lifecycle. They do not. “Partially paid with an unknown later attempt” is a legitimate composite condition. The state-machine review correctly separates:

- `funding_status`: value successfully funded/refunded for the Order; and
- `attempt_activity`: whether a charge attempt is in progress or requires reconciliation.

At the time of review, the Data Dictionary and API payment summary still exposed one aggregate status. That gap is now resolved by the [Canonical Payment Model](after_four_payment_model.md) and synchronized documents; the Owner-confirmed business rule did not change.

### 4.2 Smallest safe correction

The accepted aggregate correction is:

```text
funding_status varchar(40) NOT NULL DEFAULT 'unpaid'
attempt_activity varchar(40) NOT NULL DEFAULT 'idle'
```

Allowed values:

- `funding_status`: `unpaid`, `partially_paid`, `fully_paid`, `partially_refunded`, `fully_refunded`;
- `attempt_activity`: `idle`, `processing`, `reconciliation_required`.

Use named check constraints rather than PostgreSQL enum types so the vocabulary can evolve through normal migrations. Index `funding_status` only where a demonstrated operational query needs it; payment queues will more often need `(attempt_activity, updated_at)` and branch scope through Order.

`payment_transactions.status` remains the attempt outcome vocabulary (`initiated`, `pending`, `unknown`, `succeeded`, `failed`, `cancelled`). It is not replaced by the aggregate axes.

### 4.3 Valid combinations and policy

The physical model has exactly seven valid combinations. “Valid” means representable without conflating facts; it does not authorize a currently disabled business transition.

| Funding | `idle` | `processing` | `reconciliation_required` |
|---|---:|---:|---:|
| `unpaid` | **Valid** — no successful charge and no active blocker | **Valid** — first/exact-balance attempt active | **Valid** — an attempt outcome is unknown |
| `partially_paid` | **Valid** — partial value retained | **Valid** — later tender active | **Valid** — later tender outcome unknown |
| `fully_paid` | **Valid** — unambiguous full settlement; Dispatch may be created | **Invalid** — v1 must not start another charge | **Invalid** — full settlement cannot be declared while overpayment is possible |
| `partially_refunded` | **Valid** — authoritative refund below full amount | **Invalid** — refund activity belongs to Refund | **Invalid** — an ambiguous Refund remains on Refund, not charge activity |
| `fully_refunded` | **Valid** — all successful charge value refunded | **Invalid** | **Invalid** |

The corresponding row-local check is logically:

```sql
CHECK (
  (funding_status IN ('unpaid', 'partially_paid') AND
   attempt_activity IN ('idle', 'processing', 'reconciliation_required'))
  OR
  (funding_status IN ('fully_paid', 'partially_refunded', 'fully_refunded') AND
   attempt_activity = 'idle')
)
```

The conservative v1 rule is deliberate: `fully_paid` is published only when successful charge transactions unambiguously equal the target and no unresolved charge can create overpayment. If a provider contract later proves that an unknown attempt cannot affect the settled balance, that relaxation requires an explicit state-machine change.

Partial/split payment remains an `OPEN_DECISION`. Keep all three `partially_paid` combinations in the data vocabulary so historical or future behavior is representable, but reject every command that would transition into `partially_paid` in the first production command policy. Thus those rows are schema-valid but unreachable through v1 production commands until the policy is approved. The exact-balance MVP error remains `payment_amount_invalid` (`docs/architecture/after_four_api_error_catalog.md:131-140`).

### 4.4 Arithmetic and transition rules

Within a locked Payment transaction:

- `successful_amount` is recomputed from authoritative successful charge transactions;
- `refunded_amount` is recomputed from authoritative successful Refunds and never reduces `successful_amount`;
- `remaining_amount = target_amount - successful_amount` is derived, not independently writable;
- `unpaid` requires `successful_amount = 0` and `refunded_amount = 0`;
- `partially_paid` requires `0 < successful_amount < target_amount` and `refunded_amount = 0`;
- `fully_paid` requires `successful_amount = target_amount` and `refunded_amount = 0`;
- `partially_refunded` requires `successful_amount = target_amount` and `0 < refunded_amount < successful_amount`;
- `fully_refunded` requires `successful_amount = target_amount` and `refunded_amount = successful_amount`;
- overpayment and refund above successful amount are rejected;
- `fully_settled_at` is set on the first authoritative transition to `fully_paid` and is not erased by a refund.

Local nonnegative and ordering checks belong in PostgreSQL. Aggregate sums and cross-row state derivation belong in one application transaction under a Payment row lock. A database check cannot safely query child rows, so do not hide this logic in a fragile cross-row check constraint.

Attempt activity is maintained from nonterminal/unknown attempts in the same locked transaction:

- create an attempt durably, then set `processing` before external I/O;
- verified success/failure returns to `idle` if no other blocker exists;
- timeout or ambiguous response sets the attempt to `unknown` and aggregate activity to `reconciliation_required`;
- reconciliation locks the Attempt and Payment, applies a unique signed event or authoritative query result once, recomputes both axes, and returns to `idle` only when no unknown attempt remains;
- while reconciliation is required, a new charge and Preparation Dispatch are forbidden.

The transaction that first reaches `fully_paid/idle` inserts the unique pending Preparation Dispatch and its outbox event before commit. External provider and printer work occurs outside that transaction (`docs/architecture/after_four_data_integrity_rules.md:167-188,262-288`).

### 4.5 Required canonical document updates

This review does not edit them, but acceptance must result in these focused changes before implementation:

1. **Business Domain Model:** rewrite the Payment lifecycle as the two independent axes; retain Refund as its own lifecycle.
2. **Data Dictionary:** replace the aggregate's former single-status field, default, and index with the two fields/checks; add arithmetic/composite-validity rules.
3. **API Contract:** replace Payment summary `status` with `funding_status` and `attempt_activity`; retain attempt links/statuses.
4. **ERD:** annotate Payment with the two axes; cardinalities do not change.
5. **Data Integrity Rules:** name the two columns in payment arithmetic, dispatch guards, and the database/application matrix.
6. **State Machines:** it already defines the correct axes; add the valid-combination table and conservative `fully_paid` rule if accepted.
7. **Error Catalog:** no new code is required. Existing unknown/reconciliation/full-settlement codes remain appropriate.

## 5. Recommended Rails architecture

### 5.1 Shape

Use an API-only Rails application under `backend/`, deployed as one application against one PostgreSQL database. Organize code as a modular monolith with domain ownership visible in namespaces, while retaining Rails conventions for persistence, routing, jobs, configuration, and tests.

Suggested initial Modules:

```text
backend/app/
  controllers/api/v1/
  contexts/
    identity/
    organization/
    catalog/
    sales/
    billing/
    preparation/
    platform/
  models/
  policies/
  presenters/
  jobs/
```

This is a code organization, not separate services. `platform` should contain narrow technical facilities such as idempotency, outbox delivery, and request context—not business rules or a generic framework.

### 5.2 Module Interfaces and depth

Controllers are a thin HTTP Adapter: authenticate, validate the request shape, load trusted request context, authorize, invoke one named use case, and map its result/error to the canonical envelope. A named use case owns the transaction boundary and presents a small Interface that hides locking, state transitions, idempotency, audit, and persistence details.

Active Record models implement persistence associations, local validation, scopes, and locking support. They should not serialize arbitrary graphs, call external providers, authorize the current user, or coordinate cross-context callbacks. Presenters map explicit DTOs for `/api/v1`.

Use the canonical command nouns—confirmations, payment attempts, reconciliations, dispatch retries—not generic `PATCH status`. Avoid a generic repository layer over Active Record, a command bus, workflow engine, universal event model, or state-machine gem. Those would add shallow Interfaces while the actual business complexity remains in callers.

The payment provider is a genuine Seam because production and test Implementations differ. Define a small application-owned `PaymentProvider` Interface for initiate/query/verify behavior and inject a production Adapter and deterministic test Adapter. Printer/PDF integrations receive similar ports only when implemented. PostgreSQL itself does not need a repository Adapter; Active Record already is the chosen persistence boundary.

### 5.3 Transactions, jobs, and outbox

- Keep local transactions short; never wait for provider, printer, email, user input, or a physical process inside one.
- Use optimistic locking (`lock_version`) for editable aggregates and targeted pessimistic locks for payment allocation, refund limits, inventory posting, and work claiming.
- Acquire locks in the canonical order and retry the entire transaction on bounded deadlock/serialization failures.
- Use Active Job only for durable asynchronous work such as outbox delivery or reconciliation follow-up. Choose the database-backed adapter supported by the approved Rails version before introducing Redis/Sidekiq.
- Write `outbox_events` in the same transaction as the business state. Workers claim pending rows safely, append attempts, publish idempotently, and mark delivery. An outbox is not a second business event store.
- Start preparation queue freshness with modest HTTP polling. Add WebSockets only after measured polling latency/load justifies the operational cost.

## 6. PostgreSQL physical-readiness analysis

### 6.1 Keys, foreign keys, and deletion

- Prefer UUID primary keys consistently if approved; business identifiers such as order number remain separately unique.
- Every aggregate child receives a non-null parent FK. Use `ON DELETE RESTRICT`/default restrictive behavior for historical and financial data.
- Do not globally cascade or soft-delete. Draft-only dependent configuration can be deleted only where the domain explicitly allows it.
- Use composite same-scope keys/FKs selectively for high-risk Organization/Branch ancestry. Do not duplicate every ancestor column on every child.
- Operational roots retain immutable `branch_id`; application authorization always derives Organization and effective Branch scope from the trusted session and persisted resource.

### 6.2 Uniqueness and indexing

Minimum race-safe unique constraints for the slice include:

- Organization/Brand/Branch and catalog codes in their documented scopes;
- Product Variant SKU in approved Brand scope;
- `(branch_id, order_number)` after number namespace is approved;
- one Payment per Order;
- `(payment_id, idempotency_key)` and scoped generic idempotency fingerprint;
- `(provider, provider_event_id)` and successful provider reference where applicable;
- one Preparation Dispatch per Order;
- ticket identity/allocation keys documented in the dictionary.

Add indexes for actual access paths: FK columns, effective catalog lookup, `(branch_id, status, created_at, id)` queues, payment reconciliation queues, and undelivered outbox rows. Do not duplicate unique indexes or index every status in isolation. Validate query plans with realistic data before speculative composite indexes.

### 6.3 Precision, time, and effective dates

- Money is `bigint` stored units plus `char(3)` currency; never floating point.
- Quantities use `numeric(18,6)` and rates/cost factors use `numeric(18,8)` with named rounding at domain boundaries.
- Instants use `timestamptz` and are written/read as UTC. Branches hold IANA timezone names; local business dates remain `date` where appropriate.
- Effective intervals are half-open `[from, to)`. Use check constraints for positive ranges and PostgreSQL range/exclusion constraints where practical for non-overlapping Price, RecipeVersion, primary Branch Assignment, and similar histories.
- Status columns use checked `varchar` initially, not database enums, matching the Data Dictionary (`docs/architecture/after_four_data_dictionary.md:23-35`).

### 6.4 Integrity and locking

Database constraints are the final guard for nullability, FK identity, arithmetic, allowed values, and uniqueness. Application transactions own lifecycle, authorization, external truth, aggregate sums, and same-commit cross-context invariants.

For payment completion: verify unique event/attempt identity, lock Payment, recompute amount and axes, insert the unique Dispatch and outbox row, then commit. For Order confirmation: lock/version the Order, re-resolve effective availability and price, freeze snapshots, and commit. A later migration must not weaken either invariant through callback-based eventual consistency.

### 6.5 Append-only and audit data

Terminal Payment Transactions, provider events, successful Refund outcomes, confirmed Order snapshots, dispatch attempts, and audit evidence are append-only. Corrections use linked refunds, reversals, adjustments, or superseding versions. Do not expose generic update/delete endpoints or a global `deleted_at` concern.

Rails validations improve errors but do not replace database constraints. Production application roles should use least privilege; trigger-enforced immutability can be evaluated after the application write paths and operational correction process are understood.

## 7. Security and operational baseline

### 7.1 Authentication and authorization

- Every staff action uses an individual User identity. User and Employee remain distinct.
- Prefer a secure, HTTP-only, `Secure`, appropriately `SameSite`, expiring server session cookie for a same-origin browser deployment, with session rotation at login and CSRF protection on unsafe methods.
- Individual POS PINs are Owner-confirmed; password hashing and all PIN implementation controls still require security review. Store only approved adaptive digests; never encrypt or log recoverable credentials. PIN entry needs reviewed rate limiting, progressive delay, monitoring, and recovery.
- Server policy classes evaluate effective Role Assignments and Branch Assignments for every read and command. UI visibility is not authorization.
- Return `404` where revealing cross-Branch resource existence would leak data; audit explicit scope violations and sensitive actions without storing secret payloads.
- Do not add a configurable RBAC engine or authentication suite before the topology and credential requirements show that Rails primitives plus small policy classes are insufficient.

### 7.2 Application and API security

- TLS is mandatory outside local development. Define trusted proxy/host configuration and do not trust identity/role/branch request headers.
- CORS should be absent for same-origin deployment; if separate origins are approved, use a narrow allowlist with explicit credential behavior.
- Validate content type, body size, pagination limits, allowlisted filters/sorts, and safe method/route behavior.
- Rate-limit login, credential recovery, reconciliation, and provider webhook endpoints at an appropriate edge/application layer.
- Verify webhook signatures before applying events; enforce replay uniqueness and store only allowlisted safe metadata/digests. Never store raw card/bank secrets.
- Keep Rails secret material and provider credentials outside source control in the approved secrets facility; establish rotation and access ownership.

### 7.3 Logs, metrics, health, and recovery

Emit structured logs with timestamp, severity, environment, service/version, request ID, route, status, duration, authenticated User/session/device identifiers when safe, Branch scope, stable error code, job ID, and safe aggregate IDs. Redact cookies, authorization/CSRF headers, credentials, provider payloads, customer contact data, payroll details, and free-form fields by default.

Before staging/production, provide:

- liveness and readiness endpoints that reveal no secrets;
- request/error latency, DB pool, job age/failure, outbox backlog, payment unknown/reconciliation, and dispatch-pending metrics;
- alerts with an owner and actionable threshold;
- encrypted automated PostgreSQL backups, retention policy, and a documented restore drill into an isolated environment;
- backward-compatible expand/migrate/contract migrations, deployment ownership, pre-deploy backup criteria, and tested rollback/roll-forward procedures;
- separate least-privilege runtime and migration credentials where operationally practical;
- incident runbooks for unknown payment, paid-but-undispatched order, worker backlog, restore, and leaked credential.

## 8. Technology and dependency decisions

Dependencies should be added only when the approved slice exercises them.

| Choice | Purpose | Initial decision and simpler alternative | Cost / trigger to reconsider |
|---|---|---|---|
| Rails API mode | HTTP, Active Record, migrations, jobs, security conventions | Accept after supported version pair is pinned. Simpler custom Rack app would recreate solved infrastructure. | Framework upgrades and conventions; remain on maintained releases. |
| PostgreSQL + `pg` | Transactional system of record with strong constraints/locking | Accept. SQLite is useful for tiny demos but would not exercise required PostgreSQL ranges, exclusion, locking, and concurrency. | Operating/backups/pooling; one DB only initially. |
| Rails sessions + adaptive hash support | Staff authentication if local credentials are selected | Preferred over Devise initially; exact credential method remains a gate. | Add an auth suite/IdP Adapter only for proven recovery/MFA/federation requirements. |
| Plain policy classes | Capability and Branch authorization | Preferred over Pundit/CanCan initially because scope/approval rules are domain-specific and small. | Add a library only if repetition and test burden become material. |
| Explicit presenters | Stable `/api/v1` DTOs | Plain Ruby presenters first; do not serialize Active Record graphs. | Add a serializer library only after repeated measured boilerplate and compatibility review. |
| Active Job + database-backed queue | Outbox/reconciliation follow-up | Use the adapter supported by the approved Rails version when async work starts; synchronous execution is simpler before then. | Requires worker supervision and queue monitoring; add Redis/Sidekiq only for measured throughput/scheduling needs. |
| Transactional outbox | Reliable paid-to-dispatch post-commit work | Required when the slice creates Dispatch asynchronously; direct callbacks are simpler but unsafe across process failure. | Cleanup/retry/monitoring burden; still no broker needed. |
| RSpec Rails | Model, request, service, and job specs | Standardized in Milestone 1.1 as the only supported backend test framework. | Avoid dual frameworks; use Rails transactions rather than DatabaseCleaner. |
| Test payment Adapter | Exercise authoritative/unknown/reconciliation flow without money | Required in test and non-production only. No production no-op/fake route. | Must be impossible to enable accidentally in production. |
| JSON structured log formatter | Machine-readable operations | Implement with Rails/Ruby capabilities first. | Add a logging/telemetry SDK when a selected backend requires it. |
| HTTP polling | Preparation queue freshness | Start with modest conditional polling. | Introduce Action Cable/WebSockets only when measured UX/load requires it. |
| No generic state-machine gem | Domain transitions | Explicit named use cases and policy objects are clearer for these independent axes. | Reconsider only after several genuinely uniform state machines emerge. |
| No command bus/repository/microservices | Avoid shallow indirection and distributed failure | Direct Module Interfaces in one process/database. | Reconsider only with independent ownership/scaling evidence. |

## 9. First vertical slice: Product → Order → Payment → Preparation

The first slice proves the Owner-confirmed invariant and recovery behavior. It deliberately excludes inventory consumption, loyalty, promotions, refunds, cash drawers, printing, delivery, payroll, generalized approvals, offline support, and real provider money movement.

### Slice API surface

Implement only the canonical endpoints needed to prove this path:

- identity/scope: `GET /api/v1/me`;
- catalog: `GET /api/v1/branches/{branch_id}/menu` and `GET /api/v1/branches/{branch_id}/products/{variant_id}`;
- Order: `POST /api/v1/branches/{branch_id}/orders`, `GET /api/v1/orders/{id}`, `POST /api/v1/orders/{id}/items`, `PATCH /api/v1/order-items/{id}`, `POST /api/v1/order-items/{id}/removals`, `POST /api/v1/orders/{id}/pricing`, and `POST /api/v1/orders/{id}/confirmations`;
- Payment: `POST /api/v1/orders/{id}/payment-attempts`, `GET /api/v1/orders/{id}/payment`, `GET /api/v1/payment-attempts/{id}`, `POST /api/v1/payment-attempts/{id}/reconciliations`, and `POST /api/v1/payment-attempts/{id}/retry-assessments`;
- Preparation: `GET /api/v1/orders/{id}/preparation`, `POST /api/v1/orders/{id}/preparation-dispatch-retries`, `GET /api/v1/branches/{branch_id}/preparation-tickets`, `GET /api/v1/preparation-tickets/{id}`, `POST /api/v1/preparation-items/{id}/starts`, `POST /api/v1/preparation-items/{id}/ready-confirmations`, and `POST /api/v1/preparation-items/{id}/completions`.

The provider-event webhook is part of the production payment Adapter, not the test-only first slice. Refund, cancellation, promotion, customer-association, catalog administration, and cash-session endpoints remain outside this slice.

### Milestone 0 — accepted foundation decisions

Deliverables:

- foundation ADR for layout, versions, UUIDs, session topology, and process/database topology;
- accepted Payment-axis correction and focused canonical-document update plan;
- traceable contract-test scenarios for the slice.

Acceptance: no unresolved choice is silently encoded in generated files or migrations.

### Milestone 1 — executable foundation

Deliverables:

- API-only Rails app under `backend/`, PostgreSQL development/test configuration, pinned runtime versions;
- CI commands for backend test, lint/security checks selected by the team, migration/schema verification, and existing frontend checks;
- `/health/live` and `/health/ready`, request IDs, canonical error envelope, structured redacted logging;
- migration and test database reset/seed conventions.

Acceptance: clean database creation/migration and full backend test run succeed from documented commands; readiness fails safely when PostgreSQL is unavailable.

### Milestone 2 — Organization, Branch, test identity, and authorization

Deliverables:

- Organization, Brand, Branch, User, Employee, Branch Assignment, Role, and Role Assignment minimum schema;
- trusted request context and policy Interface;
- test-only authentication Adapter, `/api/v1/me`, cross-Branch denial behavior, audit actor/request context.

Acceptance: requests cannot select Organization/User/role through headers; effective assignment allows the intended Branch and hides/denies another Branch.

### Milestone 3 — effective Catalog read

Deliverables:

- Category, Product, Variant, Branch Availability, and Price minimum schema;
- effective-date non-overlap controls and Branch-scoped menu/product endpoints;
- immutable test fixtures/seeds with VND integer money and UTC instants.

Acceptance: effective Branch override/default price and availability resolve deterministically; overlapping publication races are rejected.

### Milestone 4 — Draft and Confirmed Order

Deliverables:

- Order/Order Item/Modifier snapshot schema and named create/item/confirmation commands;
- authoritative total calculation, idempotency, `lock_version`/ETag behavior;
- confirmation revalidates price/availability and freezes snapshots.

Acceptance: stale concurrent edit is rejected, replay returns the original semantic result, and later catalog changes do not alter a confirmed Order.

### Milestone 5 — Payment and reconciliation without real money

Deliverables:

- corrected Payment axes, Payment Transaction, provider event, idempotency, and test-provider port/Adapter;
- exact-balance-only initiation, authoritative success/failure, timeout → unknown, and reconciliation commands;
- unique Dispatch and outbox inserted in the same commit as first `fully_paid/idle` settlement.

Acceptance: no browser assertion marks payment successful; unknown blocks retry and dispatch; event replay cannot double-allocate; competing attempts cannot overpay; rollback creates neither full settlement nor Dispatch; one Order has at most one Dispatch.

### Milestone 6 — durable Preparation dispatch

Deliverables:

- database-backed job/outbox processor, Dispatch attempts, Preparation Station/Ticket/Item minimum schema;
- idempotent ticket creation and retry; preparation queue read endpoint;
- operational view/metric for paid-but-pending dispatch.

Acceptance: simulated worker failure leaves Payment fully paid and Dispatch pending; retry creates/locates exactly one ticket; printing/provider behavior cannot mutate Preparation truth.

### Milestone 7 — end-to-end hardening

Deliverables:

- Rails request, domain, database-constraint, job, replay, rollback, and concurrency tests;
- frontend API/view-model Adapter for only this slice plus one Playwright happy path and recovery path against a seeded test API;
- restore drill, migration rehearsal, dashboards/alerts, and paid-but-undispatched/unknown-payment runbooks.

Acceptance: the full slice survives duplicate requests, two-device payment race, provider timeout/reconciliation, worker restart, and database restore rehearsal without violating payment-before-preparation.

Production activation then requires replacing the test payment Adapter with an approved real provider Adapter or implementing the separately approved cash-session path. The test Adapter must be rejected at boot in production.

## 10. Implementation acceptance criteria and verification

The narrow implementation is accepted only when all of the following are true:

1. a new environment can create and migrate PostgreSQL and run the documented backend checks without manual database edits;
2. every route above authenticates server-side, derives Branch scope from trusted session/resource data, and returns the canonical error envelope;
3. PostgreSQL constraints and application transactions jointly enforce scope, amount, state, uniqueness, and append-only rules under concurrent requests;
4. Payment exposes both accepted axes, exact-balance v1 commands cannot reach `partially_paid`, and an unknown attempt blocks a new charge and dispatch until authoritative reconciliation;
5. the first `fully_paid/idle` transition, unique pending Preparation Dispatch, and outbox event commit atomically, while provider I/O remains outside the transaction;
6. duplicate commands/events, a two-device payment race, provider timeout, worker crash/restart, and dispatch retry cannot overpay or create duplicate preparation work;
7. the existing frontend checks still pass, and the real-API Playwright happy and recovery paths no longer depend on production fixture logic;
8. staging demonstrates redacted structured logs, actionable health/queue/payment signals, a migration rehearsal, and a successful isolated restore drill.

The backend foundation is not complete with model unit tests alone. Required layers are:

- pure domain tests for pricing, transitions, guards, and permission decisions;
- use-case tests for transaction rollback, idempotency, locking, and audit/outbox writes;
- database tests for FK, check, unique, exclusion, append-only, and concurrent race behavior;
- request tests for session/CSRF, Branch isolation, envelopes, errors, pagination, ETag, and API versioning;
- Adapter contract tests for success, authoritative failure, timeout, invalid response, replay, and reconciliation;
- job tests for claim/retry/backoff/idempotent delivery;
- a small set of Playwright workflows against the real API.

Run concurrency tests against PostgreSQL, not an in-memory substitute. Keep the existing frontend commands (`npm run typecheck`, `npm run lint`, `npm run build`, and relevant Playwright specs) as independent checks; backend work must not weaken the current frontend foundation.

## 11. Final recommendation

Approve `READY_WITH_CONDITIONS` and begin the Rails/PostgreSQL foundation only after the Section 3.1 ADR choices and Section 4 Payment correction are accepted. Start with Milestones 0–2, then implement the narrow vertical slice in order. Do not select a real payment provider, cash topology, refund policy, or offline architecture by assumption.

This sequencing allows the team to build the durable Module Interfaces, database controls, security context, and operational skeleton now, while keeping unresolved business decisions visible and reversible. The foundation becomes ready for production feature expansion only when its selected payment method, authentication method, deployment operations, legal/accounting obligations, and recovery procedures have each passed their separate gates.
