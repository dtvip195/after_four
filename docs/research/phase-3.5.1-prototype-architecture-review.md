# Phase 3.5.1 — Prototype Architecture Review

## 1. Purpose and scope

This document reviews the AFTER FOUR frontend prototype after Phases 3.4.1–3.4.6. It is an evidence-based review, not an implementation plan and not approval of the prototype's demo business rules.

Related documents:

- [Business workflows](../design/phase-3.5.2-business-workflows.md)
- [Domain model](../design/phase-3.5.3-domain-model.md)
- [Backend architecture](../design/phase-3.5.4-backend-architecture.md)
- [Database design](../design/phase-3.5.5-database-design.md)
- [Business decisions register](../planning/phase-3.5-business-decisions-register.md)
- [Production roadmap](../planning/phase-3.5-production-roadmap.md)

## 2. Evidence classification

### Known facts

- The frontend uses React 19, TypeScript, Vite, Tailwind CSS 4, shadcn/ui and Lucide React.
- `/pos` contains table, menu, local order and demo payment interfaces.
- `/upstairs-delivery` is an isolated review route. It is deliberately absent from navigation.
- POS and delivery data are in feature-local fixtures and React state. Reloading resets mutations.
- Payment confirmation sends no API request and does not clear the order, release a table or create a financial transaction.
- Most navigation destinations remain placeholder pages.
- The repository currently has no Rails backend, database schema, `GLOSSARY.md`, ADR directory or agent-specific docs directory.
- The recorded result after Phase 3.4.6 is 112 passing Playwright tests in desktop Chromium, including explicit responsive checks at 390, 768 and 1440 px.

### Assumptions used only for analysis

- The first production release serves one cafe location with two floors and approximately three concurrent staff users.
- A single PostgreSQL database and a single Rails application are operationally sufficient initially.
- VND is the initial settlement currency. This does not decide tax, receipt or fiscal requirements.

### Open questions

- Every lifecycle vocabulary: table, order, kitchen, delivery, payment, shift and inventory.
- Whether a table visit can contain one or multiple customer checks/orders.
- Whether offline order capture is required at launch.
- Which payment methods are real, and whether split/partial payment is required.
- Which navigation surface owns Upstairs Delivery.

### Recommendation

Treat the current UI as a validated interaction prototype. Preserve its component and accessibility strengths, but introduce an explicit API/domain boundary rather than promoting fixture types or UI status strings into production contracts.

## 3. Architecture map

```text
App.tsx
├── /design-system → static component showcase
└── AppShell
    ├── navigation + header + local floor context
    ├── /pos → PosPage
    │   ├── FloorWorkspace → local table filter/selection
    │   ├── MenuWorkspace → local catalog filter/selection
    │   ├── useDemoOrder → local order lines
    │   └── PaymentDialog → local payment simulation
    ├── /upstairs-delivery → isolated local queue
    └── configured routes → placeholder pages
```

Data ownership is currently feature-local. No client cache, API client, authentication state, persistence, cross-tab synchronization or realtime transport exists.

## 4. Findings by area

### 4.1 Application Shell

Strengths:

- `AppShell` owns consistent responsive layout and the floor selector.
- Route components are lazy-loaded.
- The skip link, semantic main region and accessible navigation are strong foundations.
- Floor context is passed through `Outlet`, avoiding prop drilling through the shell.

Risks and debt:

- Route knowledge is split between `App.tsx`, `navigation-config.ts` and `standalonePageTitles` in `app-shell.tsx`.
- Route metadata also controls whether the floor selector is visible by a pathname comparison. More standalone operational routes would multiply special cases.
- `selectedFloor` is presentation context only. It must not be treated as a persisted `Floor` entity or source of authorization.
- No route guard, staff identity, permission or session-expiry behavior exists.

Recommendation: when production routing starts, create one typed route metadata source covering title, navigation placement, required capabilities and shell options. Do not refactor only for theoretical purity before that need appears.

### 4.2 POS feature

Strengths:

- Components are divided by working area rather than kept in one large page.
- Illustrative data is separate from UI, consistently named `Demo`, and visibly disclosed.
- `PosPage` owns shared state, so mobile tabs and desktop workspaces see the same local order.
- Calculation helpers are pure and VND is represented as integer values in the prototype.
- Responsive layouts use `min-w-0`, bounded internal scrolling and accessible controls.

Risks and debt:

- `PosPage` is the orchestration boundary for catalog filters, selected product, payment session and order state. Adding direct API calls here would couple transport, server state and presentation.
- Mobile and desktop render separate workspace trees. They share state today, but API subscriptions, transient dialogs and focus restoration could be duplicated if introduced inside child trees.
- `pos/types/pos.ts` mixes catalog, table, order and payment demo types. These are view models, not domain models or API DTOs.
- `PosDemoOrderLine` stores only `productId`, quantity and note; totals are recomputed from the mutable product fixture. Production history requires immutable product/variant/modifier/price snapshots.
- The selected table and order are independent. The prototype intentionally does not establish table/order ownership.
- Table states `ready`, `serving`, `attention` are presentation proposals, not approved lifecycle states.

Recommendation: keep the visual components, place server access behind feature-level query/command adapters, and map API DTOs to explicit view models. A production order aggregate, not component state, must own invariants and monetary totals.

### 4.3 Payment UI

Strengths:

- The payment flow is explicitly a nested confirmation flow.
- Cash parsing rejects formatted/non-integer input and calculates change through pure helpers.
- Tests verify that no XHR/fetch request is emitted and that a new UI session resets transient state.

Risks and debt:

- “Success” is only a local visual state; it does not model payment attempt, authorization, capture, cash tender or reconciliation.
- The client subtotal is not authoritative and omits tax, discount, service charge and promotion rules.
- No idempotency, provider reference, failure recovery, refund, void, partial payment or mixed tender exists.
- Order and payment lifecycle are not connected—which is correct for a prototype but must remain distinct in production.

Recommendation: the server calculates payable balance and records each payment transaction. Client confirmation must carry an idempotency key and expected order version; success must reflect an authoritative response.

### 4.4 Upstairs Delivery

Strengths:

- Delivery is isolated as a feature rather than hidden inside POS state.
- Queue, filters, detail and responsive presentation are focused components.
- Tests prove mutations remain local, reset on reload and do not affect POS state.
- A desktop complementary panel and mobile/tablet dialog offer appropriate responsive behavior.

Risks and debt:

- Fixture items duplicate product name and quantity without references to order or kitchen items.
- Any status can be selected directly; no transition rule, assignment, attempt, failure reason or event history exists.
- Queue entry conditions and ownership by POS versus Kitchen remain undefined.
- `waiting`, `delivering`, `delivered` are evaluation vocabulary only.

Recommendation: model delivery as a fulfillment aggregate linked to an order/table session and, if partial batches are required, specific kitchen ticket items. Navigation placement should follow the owner-approved workflow, not precede it.

### 4.5 Design system

Strengths:

- Brand tokens, typography, spacing, status primitives and responsive conventions are centralized.
- shadcn/ui primitives remain directly editable and business-agnostic.
- The visual language is consistently Modern Specialty with Warm Minimal restraint and operational density.
- Focus states and minimum touch targets are established.

Risks and debt:

- Semantic UI colors do not define business status semantics. A `success` token must not imply an approved “paid”, “delivered” or “completed” transition.
- Exact brand color approval and additional accessibility checks remain documented limitations.
- Generated UI primitives are implementation assets; they should not absorb order, payment or delivery logic.

### 4.6 Testing

Strengths:

- Tests select by accessible role/name and verify keyboard-visible interaction patterns indirectly through real components.
- Regression coverage spans shell, tables, menu, orders, payment, delivery and responsive overflow.
- Tests explicitly assert isolation and absence of network requests for demo operations.
- Chromium is automatically launched through Playwright's Vite web server configuration.

Gaps before production:

- No unit tests for domain rules, API contract tests, Rails request/service/model tests or database constraint tests.
- Helper flows such as `addProductToOrder` are duplicated across E2E files; shared test drivers/builders will be useful once API setup becomes expensive.
- Only Chromium is configured. There is no Safari/WebKit, Firefox, hardware touch, screen reader or 200% zoom coverage.
- Screenshots are artifacts, not baseline visual-regression tests.
- One retry can recover transient failures; CI should still expose retry counts and traces rather than treating a retried pass as invisible.

## 5. Backend-integration risk register

| Risk | Evidence | Production consequence | Recommended control |
|---|---|---|---|
| UI statuses become DB enums | All current statuses are marked demo/proposed | Locks unapproved workflows into migrations and APIs | Approve lifecycle first; use named transition policies |
| Mutable catalog changes old totals | Demo lines reference only `productId` | Historical receipts and reports change retroactively | Snapshot product label, variant, modifiers and unit price on order items |
| Concurrent staff overwrite changes | State is single-browser local | Lost quantities, duplicate payment or stale table state | `lock_version`, expected-version commands, idempotency keys |
| Client becomes money authority | Subtotal is calculated from fixtures | Incorrect settlement and reconciliation | Server-calculated totals; immutable payment records |
| Long-running transaction waits on staff | Prototype interactions are modal/local | Locks and deadlocks under real use | Short transactions; never wait for user/provider inside DB transaction |
| Delivery drifts from kitchen/order | Feature is intentionally isolated | Missing/duplicate upstairs fulfillment | Explicit links and event-driven-after-commit queue creation |
| Route special cases grow | Metadata split across three locations | Inconsistent header/navigation/permissions | Unified typed route metadata when auth/routes are implemented |
| Offline is improvised late | No network state exists | Duplicate commands or lost orders | Owner decision, command IDs, visible connectivity and recovery policy |

## 6. Abstraction assessment

Keep now:

- Feature-local components and fixtures.
- Pure calculation/format helpers.
- Shared business-agnostic UI primitives.
- Centralized page-level state for the demo.

Do not introduce yet:

- Microservices, event sourcing, CQRS infrastructure or a generic repository layer.
- A universal frontend state manager before server-state and cross-feature requirements exist.
- Generic workflow engines for a handful of explicit transitions.
- Redis, Sidekiq or WebSockets without measured operational need.

Introduce at the production seam:

- DTO-to-view-model mappers.
- Versioned command endpoints and idempotency.
- Domain-specific application services for multi-record workflows.
- Authorization policies and audit events.
- Contract, domain and database integrity tests.

## 7. Review conclusion

The prototype is a strong visual and interaction foundation. Its best qualities are explicit demo labeling, focused components, responsive/accessibility discipline and regression coverage. Its local state separation is intentionally not a production domain model. The next safe step is owner approval of P0 workflows and terminology, followed by domain/database decisions. The [decision register](../planning/phase-3.5-business-decisions-register.md) is the gate for backend implementation.
