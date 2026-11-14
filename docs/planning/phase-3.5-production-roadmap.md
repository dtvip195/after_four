# Phase 3.5 — Prototype-to-Production Roadmap

> **HISTORICAL / SUPERSEDED_FOR_IMPLEMENTATION.** Milestones that place preparation before verified payment are not authoritative. Current decisions and implementation follow the canonical [Owner Decision Baseline](../architecture/after_four_owner_decision_baseline.md), [DDD Foundation](../architecture/after_four_ddd_foundation.md), [Payment Model](../architecture/after_four_payment_model.md), and [Phase 1 implementation record](../architecture/after_four_order_payment_implementation_phase1.md). This roadmap does not authorize a later milestone, including Identity Milestone 2B. Original sequencing is preserved as history.

## 1. Roadmap principles

- Owner decisions precede migrations and production workflows.
- Build a thin vertical slice before broad management features.
- Correctness, idempotency, authorization and audit are acceptance criteria, not later hardening.
- Keep one Rails/PostgreSQL modular monolith until evidence justifies additional infrastructure.
- Prototype statuses and fixtures are discarded or mapped explicitly; they never silently become production data.

References: [architecture review](../research/phase-3.5.1-prototype-architecture-review.md), [workflows](../design/phase-3.5.2-business-workflows.md), [domain model](../design/phase-3.5.3-domain-model.md), [backend architecture](../design/phase-3.5.4-backend-architecture.md), [database design](../design/phase-3.5.5-database-design.md), [decision register](phase-3.5-business-decisions-register.md).

## 2. Phase 3.5.1 — Prototype Architecture Review

- **Goal:** Establish evidence about frontend boundaries, state ownership, quality and backend-integration risk.
- **Deliverables:** Review document; current architecture map; risk/gap register; separation of known facts, assumptions and recommendations.
- **Dependencies:** Completed prototype and design documentation.
- **Risks:** Treating documented prototype behavior as approved business behavior; overlooking local-state isolation.
- **Acceptance criteria:** All application areas and Playwright strategy reviewed; source remains unchanged; findings link to decision/workflow work.
- **Status:** Documentation completed in this research phase; owner review pending.

## 3. Phase 3.5.2 — Business Workflow Definition

- **Goal:** Observe and approve the actual cafe workflow from shift opening through service, fulfillment, payment and close.
- **Deliverables:** Owner workshop notes; approved vocabulary; state/transition diagrams; exception matrix; updated decision register with P0 decisions signed and dated.
- **Dependencies:** Phase 3.5.1 and access to owner/staff; actual menu/payment/device information.
- **Risks:** Designing from the prototype rather than floor observation; resolving edge cases by assumption; scope expanding to all future features.
- **Acceptance criteria:** Owner explicitly resolves every P0 workflow entry or formally defers its domain; no status remains ambiguously shared across order/payment/fulfillment.
- **Gate:** No backend domain implementation before this phase approves the relevant workflow.

## 4. Phase 3.5.3 — Domain Model & Database Design

- **Goal:** Convert approved workflows into stable terminology, aggregate boundaries and an implementable PostgreSQL design.
- **Deliverables:** Approved domain model; ERD; field/constraint/index catalog; transaction/lock matrix; API command sketches; `GLOSSARY.md`; ADRs for modular monolith, keys, money, idempotency and offline scope.
- **Dependencies:** Approved Phase 3.5.2 P0 decisions; accounting/legal input for money/retention where needed.
- **Risks:** Over-modeling deferred functionality; database enums freezing unstable states; missing historical snapshots or race-safe constraints.
- **Acceptance criteria:** Every table/field supports an approved use case; invariants exist at domain/database level; destructive and concurrent scenarios are testable; migration sequence reviewed before execution.

## 5. Phase 3.5.4 — Backend Foundation

- **Goal:** Create the smallest production-ready Rails API foundation without business feature breadth.
- **Deliverables:** Rails API application; PostgreSQL configuration; module conventions; `/api/v1`; authentication/session foundation; authorization policy pattern; structured errors/logging/request IDs; test framework; CI checks; health/readiness; secrets and backup/restore runbook; initial schema only for approved foundation concepts.
- **Dependencies:** Phase 3.5.3 ADRs; deployment topology; `BD-SEC-001`, `BD-ARC-001`, `BD-OFF-001`, device/network inventory.
- **Risks:** Installing infrastructure “for later”; insecure browser/API session design; untested restore; front/back contracts drifting.
- **Acceptance criteria:** Authenticated versioned request works end-to-end in a non-production environment; forbidden actions are denied; errors are structured; database constraints/tests run; deployment and restore are repeatable; no Redis/WebSocket unless an accepted requirement names it.

## 6. Phase 3.5.5 — Core POS API

- **Goal:** Deliver one reliable vertical workflow: catalog → table session → draft order → submit → authoritative totals.
- **Deliverables:** Floor/table/catalog read APIs; session and order commands; immutable item snapshots; submission/kitchen-ticket creation boundary; optimistic locking/idempotency; frontend DTO adapters; critical Rails/request/Playwright tests.
- **Dependencies:** Foundation; approved table/order/catalog/kitchen decisions (`BD-TBL-*`, `BD-ORD-*`, `BD-CAT-*`, `BD-KIT-001`).
- **Risks:** Client totals treated as authoritative; stale-device overwrites; duplicate submit; premature table merge/split scope.
- **Acceptance criteria:** Two concurrent clients cannot silently overwrite one order; retrying create/submit is idempotent; catalog rename does not alter historical order; rollback leaves no partial ticket; prototype fixtures are not used in production flow.

## 7. Phase 3.5.6 — Kitchen & Delivery Integration

- **Goal:** Connect submitted order items to preparation and verified floor handoff.
- **Deliverables:** Kitchen queue/ticket transitions; station routing baseline; upstairs delivery creation/claim/success/failure history; navigation placement; post-commit update approach (polling initially); operational timing/audit data; responsive E2E coverage.
- **Dependencies:** Core order submission; `BD-KIT-001`, `BD-DEL-001`, `BD-DEL-002`; actual bar-to-elevator observation.
- **Risks:** Duplicate/lost fulfillment, status coupling to Order, missing partial-batch semantics, staff handoff ambiguity.
- **Acceptance criteria:** Every ready floor-2 unit is traceably undelivered or delivered exactly once under approved granularity; failure remains actionable; repeated commands are safe; Order/payment state is not incorrectly changed by delivery.

## 8. Phase 3.5.7 — Payment Integration

- **Goal:** Settle orders safely with real approved methods and shift reconciliation.
- **Deliverables:** Server totals/balance; Payment and PaymentTransaction APIs; cash tender/change; selected electronic method integration; signed idempotent webhook handling if applicable; refund/void rules; receipts/invoice integration if required; shift cash ledger and reconciliation; security/audit tests.
- **Dependencies:** Stable order totals; approved `BD-PAY-*`, `BD-CAT-002`, `BD-SHF-*`, `BD-RCP-001`; provider and accounting requirements.
- **Risks:** Duplicate charge, ambiguous provider timeout, incorrect split allocation, secrets/PII leakage, fiscal non-compliance.
- **Acceptance criteria:** Duplicate/replayed requests cannot double-charge; failures do not close an order; payment/order states remain separate; reconciliation explains every successful/cancelled/refunded amount; provider recovery runbook tested.

## 9. Phase 3.5.8 — Inventory & Reports

- **Goal:** Add trustworthy ingredient movement and owner-facing operational reporting after transaction data is reliable.
- **Deliverables:** Ingredients/units/recipe versions; stock movement ledger; approved consumption trigger and corrections; purchase/adjustment scope as approved; daily/payment/product/staff/floor reports; exports; performance baselines.
- **Dependencies:** Stable catalog, kitchen and payment events; `BD-INV-*`, `BD-RPT-*`; verified recipes and units.
- **Risks:** Garbage-in recipes, unit conversion errors, retroactive report-definition changes, expensive queries and untraceable manual adjustments.
- **Acceptance criteria:** Every stock balance is reconstructible from movements; corrections are reversing entries; historical recipe/order snapshots remain stable; report totals reconcile to orders/payments/refunds for the approved business day.

## 10. Cross-phase quality gates

Every implementation phase must include:

- Type/lint/build and existing full Playwright suite remain green.
- Rails domain/application/request/database tests proportional to risk.
- Authorization and audit tests for sensitive commands.
- Idempotency/concurrency/rollback tests for state-changing workflows.
- Responsive checks at 390 × 844, 768 × 1024 and 1440 × 900 for affected UI.
- No document-level horizontal overflow and no accessibility regression.
- Migration rollback/forward and backup/restore consideration.
- Documentation updated with verified behavior, not planned behavior.

## 11. Suggested release slices

Avoid releasing all domains at once:

1. **Internal alpha:** staff identity, catalog read, table session and persisted draft order.
2. **Operational alpha:** submit to kitchen and floor-1 fulfillment, still without real electronic payment if needed.
3. **Upstairs pilot:** floor-2 delivery with observed staff handoff.
4. **Settlement pilot:** approved cash/electronic method plus reconciliation.
5. **Production readiness:** recovery, monitoring, permission/audit review, on-site device/network test and trained fallback procedure.
6. **Inventory/reporting:** only after transactional data and recipes are trusted.

Feature flags may isolate incomplete flows, but must not bypass domain constraints or create two incompatible sources of truth.

## 12. Owner checkpoints

- **Checkpoint A — workflow:** approve P0 business decisions.
- **Checkpoint B — data:** approve glossary, ERD, lifecycle and historical retention.
- **Checkpoint C — foundation:** approve device/network/auth/deployment topology.
- **Checkpoint D — each pilot:** observe real staff use and accept exception handling before expanding scope.
- **Checkpoint E — production:** sign off on payment/reconciliation, recovery, backups, permissions and support runbook.

## 13. Immediate next action after this phase

Do not start Phase 3.5.4 backend implementation. First hold the Phase 3.5.2 owner workflow review using the ordered agenda in the [decision register](phase-3.5-business-decisions-register.md). Record explicit decisions; then revise the proposed model and create glossary/ADRs from approved facts.
