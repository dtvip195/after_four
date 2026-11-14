# AFTER FOUR — Architecture Gap Analysis

> **HISTORICAL AUDIT SNAPSHOT.** This report accurately described the repository when inspected, before the Rails/PostgreSQL foundation and Order/Payment Phase 1 were added. Statements below that the repository has no backend, schema, migrations, or background worker are no longer current. Use [AGENTS.md](../../AGENTS.md), the canonical [Owner Decision Baseline](../architecture/after_four_owner_decision_baseline.md), [DDD Foundation](../architecture/after_four_ddd_foundation.md), and [Phase 1 implementation record](../architecture/after_four_order_payment_implementation_phase1.md). Original audit evidence is preserved.

**Audit date:** 2026-11-14  
**Scope:** Read-only inspection of the repository, with this report as the only requested write  
**Evidence rule:** “Implemented” means executable production-oriented code exists. A proposal, navigation link, placeholder, local React state, fixture, or browser-only simulation is not treated as backend or production functionality.

## A. Executive summary

### Current architecture

AFTER FOUR is currently a frontend prototype, not a production POS architecture. The executable application is a React 19/TypeScript/Vite single-page application under `frontend/`. It uses React Router, Tailwind CSS 4 through the Vite plugin, editable shadcn/Radix UI primitives, Lucide icons, and feature-local React state. This repository has no backend application, database schema, ORM, migrations, authentication, authorization, API client, persistence, background worker, realtime transport, or external integration. The repository instructions state this directly (`AGENTS.md:3-13`), and the existing architecture review confirms that there is no client cache, API client, authentication state, persistence, cross-tab synchronization, or realtime transport (`docs/research/phase-3.5.1-prototype-architecture-review.md:47-64`).

The implemented business-facing surface consists of:

- `/pos`: table, catalog, local order, and simulated payment UI (`frontend/src/App.tsx:54-70`; `frontend/src/features/pos/pages/pos-page.tsx:16-51`).
- `/upstairs-delivery`: an isolated, local delivery-queue prototype (`frontend/src/App.tsx:54-62`; `frontend/src/features/upstairs-delivery/pages/upstairs-delivery-page.tsx:20-61`).
- All configured management destinations other than POS resolve to the same placeholder component (`frontend/src/App.tsx:71-76`). This includes Dashboard, Orders, Tables, Kitchen, Menu, Categories, Inventory, Recipes, Staff, Reports, and Settings (`frontend/src/app/navigation/navigation-config.ts:29-122`).

The repository also contains substantial design proposals for a Rails API modular monolith with PostgreSQL, a logical domain model, a logical database design, workflow recommendations, and a production roadmap. These are not implementation. The backend document explicitly says no backend has been created (`docs/design/phase-3.5.4-backend-architecture.md:3-9`), and the database document says no database has been created and the schema is not a migration specification (`docs/design/phase-3.5.5-database-design.md:3-7`). Most domain and workflow documents are still pending Owner approval (`docs/design/phase-3.5.2-business-workflows.md:3-12`; `docs/design/phase-3.5.3-domain-model.md:3-9`).

### Overall implementation maturity

The frontend foundation is mature for prototype evaluation: it has strict TypeScript, reusable UI primitives, responsive layouts, accessibility-conscious controls, and extensive Chromium Playwright coverage. The business system is pre-backend. No requested domain is production-implemented. POS, catalog, tables, payments, and upstairs delivery are either fixture-backed UI or local simulations. The remaining domains have at most route placeholders or proposal documents.

### Most important architectural risks

1. **Critical — preparation/payment sequencing conflict.** The agreed requirement says preparation starts only after successful payment. Existing workflow, domain, database, and roadmap proposals create kitchen tickets when order items are submitted, before the later payment phase (`docs/design/phase-3.5.2-business-workflows.md:112-121`, `docs/design/phase-3.5.3-domain-model.md:262-267`, `docs/planning/phase-3.5-production-roadmap.md:47-69`). Building from those proposals would encode the wrong transaction boundary.
2. **Critical — the proposed model is single-location and cannot enforce the requested branch invariants.** It explicitly targets one cafe location (`docs/design/phase-3.5.3-domain-model.md:3-7`) and has no Organization, Brand, Branch, effective-dated employee assignment, or branch-scoped authorization model.
3. **Critical — payment safety and recovery do not exist.** Payment “success” is local UI state; it makes no request and creates no transaction (`frontend/src/features/pos/components/payment-dialog.tsx:80-101`; `frontend/src/features/pos/components/payment-confirmation-dialog.tsx:71-85`). There is no implemented idempotency, provider recovery, durable paid-but-undispatched state, refund, or reconciliation.
4. **High — inventory requirements exceed even the proposal.** A stock movement ledger and recipe versioning are proposed, but weighted-average cost, warehouses, transfer dispatch/in-transit/receipt, purchasing receipts, and valuation records are absent from the design (`docs/design/phase-3.5.5-database-design.md:254-284`).
5. **High — payroll, attendance, cash-session, expenses, purchasing, and approval domains are not modeled.** The proposal contains workforce shifts and cash movements, but not payroll periods/rates, attendance, immutable payroll closure, register cash sessions, expenses, purchase orders/receipts, or reusable approvals.

## B. Technology inventory

| Area | Verified repository technology | Status / evidence |
|---|---|---|
| Frontend runtime | React `^19.3.1`, React DOM, React Router `^8.5.1` | Implemented; `frontend/package.json:16-30` |
| Language/build | TypeScript `~7.0.2`, Vite `^8.3.6`, React Vite plugin | Implemented; `frontend/package.json:32-41`; strict/no-emit settings at `frontend/tsconfig.app.json:3-29` |
| Styling | Tailwind CSS `^4.3.5` via `@tailwindcss/vite` | Implemented; `frontend/package.json:19,28`; `frontend/vite.config.ts:1-13` |
| UI | shadcn source components, Radix via `radix-ui`, CVA, cmdk, Vaul | Implemented; `frontend/package.json:20-30`; reusable primitives under `frontend/src/components/ui/` |
| Icons | Lucide React | Implemented; `frontend/package.json:23`; required by `AGENTS.md:34-42` |
| Fonts | Be Vietnam Pro and Geist Mono fontsource packages | Implemented; `frontend/package.json:17-18` |
| State/data | Component/page `useState` and `useMemo`; feature-local fixtures | Prototype only; `frontend/src/features/pos/hooks/use-demo-order.ts:1-70`; `frontend/src/features/upstairs-delivery/hooks/use-demo-delivery-queue.ts:1-20` |
| API/client cache | None found | The prior audit confirms none at `docs/research/phase-3.5.1-prototype-architecture-review.md:63`; no `fetch`, XHR, WebSocket, EventSource, or storage use was found in `frontend/src/` |
| Backend framework | Rails API modular monolith is proposed | Not implemented; `docs/design/phase-3.5.4-backend-architecture.md:3-9,24-53` |
| Database | PostgreSQL is proposed | Not implemented; `docs/design/phase-3.5.5-database-design.md:1-7` |
| ORM | Active Record is proposed with Rails | Not implemented; `docs/design/phase-3.5.4-backend-architecture.md:39-52` |
| Schema/migrations | Logical table proposal only | No schema or migrations; `docs/design/phase-3.5.5-database-design.md:3-7` |
| Authentication | Individual identity/session is recommended, provider/topology open | Not implemented; `docs/design/phase-3.5.4-backend-architecture.md:100-112` |
| Authorization | Capability policies and three templates are proposed | Not implemented; same evidence; no route guards (`docs/research/phase-3.5.1-prototype-architecture-review.md:76-83`) |
| API | `/api/v1` REST command endpoints are illustrative | Not implemented; `docs/design/phase-3.5.4-backend-architecture.md:55-98` |
| Unit/integration tests | No production domain, API, or database tests | Gap acknowledged at `docs/research/phase-3.5.1-prototype-architecture-review.md:156-170` |
| Browser tests | Playwright `^1.65.0`, Chromium project, Vite web server | Implemented for UI; `frontend/package.json:12-14,33`; `frontend/playwright.config.ts:3-32` |
| Development commands | `dev`, `typecheck`, `build`, `lint`, `preview`, Playwright commands | `frontend/package.json:6-14` |
| Jobs/realtime | Active Job, polling, outbox, and later WebSockets are proposals | Not implemented; `docs/design/phase-3.5.4-backend-architecture.md:158-183` |
| Deployment/CI/infrastructure | None found | Backend foundation, CI, health checks, backups, and restore are future roadmap deliverables (`docs/planning/phase-3.5-production-roadmap.md:39-45`) |

## C. Domain implementation matrix

| Domain | Existing implementation | Maturity | Missing requirements | Risk |
|---|---|---|---|---|
| Organization, brands and branches | App branding and two local floor options exist, but no business entity, persistence, ownership hierarchy, or branch boundary. The proposed model assumes one location. | Not implemented | Organization/Brand/Branch entities; branch settings/timezone; ownership; cross-branch data isolation; branch lifecycle | Critical |
| Users, employees, roles and permissions | `/staff` is a placeholder. Staff/Role/Permission and three role templates are proposed only. | Not implemented | User/account vs employee identity; Owner/Manager/Staff mapping; scoped role assignments; temporary branch assignments; backend policy enforcement; credential/session model | Critical |
| Products, categories, variants and modifiers | Fixture categories and products with a single price are displayed and filtered (`pos-demo-data.ts`). No variants/modifiers or persistence. | Mock data | Production catalog APIs/entities; branch availability/pricing; variants; modifier groups/cardinality; archival; historical snapshots | High |
| Recipes, recipe versions and ingredients | `/recipes` placeholder; versioned recipe/ingredient/unit schema proposed only. | Not implemented | Implemented ingredients, units, effective-dated recipe versions, approvals, immutable history, actual recipe validation | High |
| Orders and order items | Local session-only order lines support add/remove/quantity/note and client subtotal. Lines store only `productId`, quantity, note. | Mock data | Persistent aggregate; lifecycle; table/branch/shift ownership; server pricing; immutable name/options/price snapshots; submission/correction history; locking/idempotency | Critical |
| Payments and refunds | Simulated cash/bank-transfer/QR selection and change calculation. Confirmation only changes local UI state and sends no request. | UI only | Payment/transaction/refund records; independent lifecycle; provider integration; idempotency; allocation; recovery; refund/void; cash/bank reconciliation | Critical |
| Inventory, warehouses and stock movements | `/inventory` placeholder; stock ledger and one extensible inventory-location proposal only. | Not implemented | Warehouses; movement posting; weighted-average cost; costed receipts/issues; dispatch/in-transit/receipt transfers; reversals; stocktake; branch ownership | Critical |
| Shifts, attendance and payroll | Workforce Shift is proposed for operating/cash reconciliation; no executable code. Attendance and payroll are absent. | Not implemented | Attendance/time records; actual branch on shift; temporary assignment validation; monthly/hourly/per-shift compensation; payroll calculations, periods, closure and adjustments | Critical |
| Cash sessions and cash transactions | Opening/closing shift and append-only cash movement are proposed. No distinct register cash session or implementation. | Not implemented | Register/terminal cash sessions; denomination/counts if required; immutable close snapshot; cash movements; separation from employee shift; bank settlement tracking | High |
| Expenses and purchasing | Purchasing is explicitly described as separable/deferable; no expense or purchasing model/screen. | Not implemented | Suppliers, purchase orders, receipts, invoices, expenses, payment source, stock/cost integration, approvals, corrections | High |
| Audit logs and approvals | Append-only `audit_events` and sensitive-action attribution are proposed only. No approval entity/workflow. | Not implemented | Durable audit events; approver identity; approval requests/decisions; before/after summaries; retention/access; domain-ledger links | Critical |
| Reports and dashboards | Dashboard and Reports routes are placeholders. Report outputs/read models are proposed only. | Not implemented | Transaction-backed reports, business-day rules, branch scope, reconciliation, immutable closed-period reporting, exports | High |
| External integrations, printing and background jobs | No integration code. Payment provider, receipt delivery, printers, jobs, polling/outbox and realtime are future decisions/proposals. | Not implemented | Provider adapters/webhooks; printer jobs/status/retry; durable outbox/job execution; integration credentials; observability; failure recovery | High |

### UI/mock evidence notes

- Product/category prices are explicitly illustrative and unapproved (`frontend/src/features/pos/data/pos-demo-data.ts:9-73`).
- Order state exists only in React memory (`frontend/src/features/pos/hooks/use-demo-order.ts:5-70`), and the UI says it is not saved (`frontend/src/features/pos/components/order-panel.tsx:41-57`).
- The subtotal joins current product fixtures at render/calculation time (`frontend/src/features/pos/lib/get-demo-order-summary.ts:9-27`), so it is not a historical sales snapshot.
- Payment methods explicitly say they do not use a real bank account, QR code, or gateway (`frontend/src/features/pos/data/payment-demo-data.ts:3-18`).
- Payment success is explicitly described as non-financial UI state and does not clear the order, release the table, or print (`frontend/src/features/pos/components/payment-dialog.tsx:92-123`).
- Delivery orders are static fixtures (`frontend/src/features/upstairs-delivery/data/delivery-demo-data.ts:24-97`); status changes are array updates in React memory (`frontend/src/features/upstairs-delivery/hooks/use-demo-delivery-queue.ts:9-20`). The page states that all order/table/time/product values are fixtures and it is not connected to POS/Kitchen (`frontend/src/features/upstairs-delivery/pages/upstairs-delivery-page.tsx:64-85`).

## D. Data architecture review

### Existing executable entities and relationships

There are no persisted entities or database relationships. The executable data shapes are view-model/fixture types:

- `PosDemoCategory` → `PosDemoProduct` by `categoryId`.
- `PosDemoOrderLine` → current fixture product by `productId`; the line contains only product ID, quantity, and note (`frontend/src/features/pos/types/pos.ts:4-31`).
- `PosDemoTable` is grouped by a UI `FloorId`, but selection has no relationship to an order (`frontend/src/features/pos/data/pos-demo-data.ts:79-104`; `docs/research/phase-3.5.1-prototype-architecture-review.md:95-104`).
- `DeliveryDemoOrder` embeds copied item names/quantities and a table code, with no order-item, kitchen-ticket, actor, branch, or event relationship (`frontend/src/features/upstairs-delivery/types/upstairs-delivery.ts:4-19`).

These types must not become API/database contracts. The proposal itself warns that prototype types/status strings are not production contracts (`docs/design/phase-3.5.3-domain-model.md:3-9`).

### Proposed—but unimplemented—entities

The logical proposal covers Floor, DiningTable, TableSession/Assignment; Category, Product, ProductVariant, ModifierGroup/Modifier; Order/Item/Modifier; KitchenTicket/Item; Delivery/Event; Payment/Transaction/Refund; Staff/Role/Permission; Shift/CashMovement; Unit, Ingredient, Recipe/Item, Inventory/StockMovement; AuditEvent and IdempotencyRecord (`docs/design/phase-3.5.5-database-design.md:54-69,73-300`). Its strongest aspects are:

- separate order, payment, kitchen, and delivery lifecycles;
- order-item name/variant/price snapshots (`docs/design/phase-3.5.5-database-design.md:127-152`);
- append-only payment attempts, refunds, cash movements, stock movements, and audit events;
- explicit transaction/lock boundaries (`docs/design/phase-3.5.5-database-design.md:311-323`);
- effective recipe versions (`docs/design/phase-3.5.5-database-design.md:264-268`).

None is implemented or Owner-approved.

### Missing entities for the agreed scope

The proposed logical model is materially narrower than the audit requirements. At minimum, it lacks:

- `organizations`, `brands`, `branches` (or equivalent location tenant root), and effective branch configuration;
- user/login account separated from employee/person record, employment history, scoped role assignments, and effective-dated temporary branch assignments;
- attendance/time-entry records and immutable shift branch attribution;
- compensation agreements/rates, payroll periods, payroll calculations/lines, closures, adjustments/reversals, and payroll payment records;
- register/terminal and cash session distinct from workforce shift, counts/reconciliation, and bank settlement/deposit records;
- warehouse/stock-location ownership by branch, inventory transfer/header/lines/events with dispatch/in-transit/receipt states;
- inventory valuation/cost layers or weighted-average state/history;
- supplier, purchase order, goods receipt, supplier invoice, expense, and expense/payment allocation;
- reusable approval request/decision records if approvals span refunds, stock adjustments, expenses, payroll, and cash variance;
- durable outbox/job/integration attempt, print job, and provider webhook-event records;
- effective-dated branch/catalog/configuration versions beyond recipes.

### Problematic relationships or assumptions

1. **Single-location root.** The domain model says it is for one cafe location (`docs/design/phase-3.5.3-domain-model.md:3-7`). Existing proposed uniqueness, authorization, shift, floor, table, inventory, order, and report rules therefore lack a consistent `branch_id` ownership boundary.
2. **Preparation trigger contradicts the agreed invariant.** The proposal makes submission + kitchen ticket creation one strong transaction (`docs/design/phase-3.5.3-domain-model.md:262-266`; `docs/design/phase-3.5.5-database-design.md:313-320`). The agreed rule requires payment success before preparation starts. The design must distinguish paid order from reliable preparation dispatch and make paid-but-not-dispatched recoverable.
3. **Order history is mutable in the prototype.** `PosDemoOrderLine` contains no snapshot, and subtotal reads the current fixture price. Production rendering would change after a product rename/price change unless the proposed snapshot model is implemented.
4. **Shift conflates concerns.** The proposal combines staffed operating period and cash reconciliation (`docs/design/phase-3.5.3-domain-model.md:202-206`). Workforce shift, attendance record, and register cash session have different actors, scopes, open/close rules, and historical requirements.
5. **Inventory location is insufficient for transfers/costing.** A generic location and signed movement can support a ledger, but transfer state and weighted-average valuation require explicit transaction semantics and cost preservation across dispatch/receipt.
6. **Approval is only audit metadata.** Fields such as approver/reason on refund or variance do not by themselves represent a pending/approved/rejected workflow, authorization snapshot, or segregation of duties.

### Data ownership and branch scoping

No executable branch scoping exists. The selected “floor” is application presentation state passed through the shell and must not be treated as authorization (`docs/research/phase-3.5.1-prototype-architecture-review.md:67-83`). A production design should select one consistent ownership rule before migrations:

- Organization owns brands and branches.
- Operational records (orders, payments, cash sessions, employee shifts, inventory, purchases, expenses) belong immutably to a branch.
- Shared catalog/configuration must explicitly define whether it is organization-, brand-, or branch-owned, including override behavior.
- Backend policies derive accessible branch IDs from current effective assignments/role grants; client-selected branch/floor is never trusted as authorization.
- Temporary branch assignments need effective intervals. Historical shift/order/audit records retain their recorded branch even after assignment changes.

### Transaction boundaries needed

The proposed boundaries are a useful starting point, but the agreed sequencing requires revision:

1. Record a payment attempt/intention idempotently; provider I/O remains outside a DB transaction.
2. Apply successful payment idempotently and mark settlement in a short transaction.
3. In that same transaction, create a durable preparation-dispatch/outbox record, or create the kitchen ticket if fully local and atomic.
4. Dispatch after commit. If dispatch fails, the paid order and pending outbox remain visible/retryable; retry cannot create a duplicate ticket.
5. Preparation start verifies successful settlement and consumes the dispatch once.

Additional atomic boundaries are required for weighted-average receipt + valuation + stock movement, transfer dispatch/receipt, payroll close snapshots, cash session close snapshots, and confirmed transaction reversals.

### Historical data strategy

The proposal correctly recommends lifecycle records instead of deletion, snapshots on order items/modifiers, effective recipe versions, append-only ledgers, and explicit corrections (`docs/design/phase-3.5.5-database-design.md:38-52,127-161,264-300`). This is design intent only. The broader scope needs the same strategy for:

- organization/branch/configuration changes with effective dates;
- employee assignments and compensation agreements;
- attendance and actual shift branch;
- payroll period closure and post-close adjustment entries;
- cash session closure and correction entries;
- inventory valuation, transfer, purchase receipt, and expense corrections;
- approval and audit retention.

## E. Business invariant assessment

Classification below assesses implementation, not whether a proposal mentions the rule.

| Agreed invariant | Assessment | Evidence / gap |
|---|---|---|
| Payment state is independent of order and preparation states | Not implemented | No production states exist. Separation is documented (`docs/design/phase-3.5.2-business-workflows.md:209-227`) but unimplemented. |
| Preparation starts only after successful payment | Not implemented | The current proposal conflicts: submission creates kitchen tickets before payment (`docs/design/phase-3.5.2-business-workflows.md:112-121,165-172`; roadmap sequences kitchen before payment at `docs/planning/phase-3.5-production-roadmap.md:47-69`). |
| Payment retries do not create duplicate charges | Not implemented | Local confirmation only toggles React state (`frontend/src/features/pos/components/payment-dialog.tsx:71-83`). Idempotency is proposal only (`docs/design/phase-3.5.4-backend-architecture.md:134-156`). |
| Paid order with failed preparation dispatch is recoverable | Not implemented | No durable payment, dispatch, outbox, kitchen ticket, retry state, or recovery operator view exists. A reliable outbox is only proposed (`docs/design/phase-3.5.4-backend-architecture.md:173-183`). |
| Order items preserve historical names, options, and prices | Not implemented | Current line stores only product ID/quantity/note (`frontend/src/features/pos/types/pos.ts:27-31`) and total reads current fixtures (`frontend/src/features/pos/lib/get-demo-order-summary.ts:9-27`). Snapshot schema is proposal only. |
| Every stock change originates from a stock movement | Not implemented | No inventory implementation. Proposed ledger says every balance change has a movement (`docs/design/phase-3.5.3-domain-model.md:230-239`). |
| Direct stock editing cannot bypass history | Not implemented | No stock command/API/policy/database constraint exists. |
| Inventory costing supports weighted average | Not implemented | No costing fields, valuation ledger, receipt cost, or average-cost calculation appears in implementation or logical schema. |
| Transfers distinguish dispatch, in-transit, and receipt | Not implemented | No transfer entity/lifecycle. The generic proposal only names transfer as a stock movement reason (`docs/design/phase-3.5.2-business-workflows.md:249-268`). |
| Historical inventory transactions remain traceable | Not implemented | Append-only source-linked stock movements are proposed (`docs/design/phase-3.5.5-database-design.md:278-284`) but absent. |
| Owner, Manager, and Staff roles exist | Not implemented | Existing proposal uses Owner/Manager, Cashier/Service, Barista templates rather than the exact agreed three roles (`docs/design/phase-3.5.2-business-workflows.md:237-247`); no roles are implemented. |
| Backend enforces branch-scoped authorization | Not implemented | No backend, Branch entity, authentication, or authorization exists. |
| Employees may have temporary branch assignments | Not implemented | No branch assignment/effective-date model exists. |
| Historical shifts retain actual branch | Not implemented | Proposed Shift has only a generic location/register scope (`docs/design/phase-3.5.3-domain-model.md:202-206`); no implemented immutable branch attribution. |
| Sensitive actions are auditable | Not implemented | Audit event structure and actions are proposed only (`docs/design/phase-3.5.4-backend-architecture.md:213-227`). |
| Payroll supports monthly, hourly, and per-shift compensation | Not implemented | Payroll and compensation are absent from code and logical schema. |
| Closed payroll periods cannot silently change | Not implemented | No payroll period, close snapshot, adjustment, or lock exists. |
| Cash and bank payments are tracked separately | Not implemented | UI offers cash and bank transfer choices, but creates no records (`frontend/src/features/pos/data/payment-demo-data.ts:3-18`; `frontend/src/features/pos/components/payment-confirmation-dialog.tsx:71-85`). |
| Closed cash sessions cannot be directly overwritten | Not implemented | No cash-session entity. Proposed Shift/CashMovement does not implement this invariant. |
| Confirmed transactions are corrected without deletion | Not implemented | Lifecycle/correction strategy is proposed (`docs/design/phase-3.5.5-database-design.md:38-42,154-161`) but no transaction records exist. |
| Important changes produce audit records | Not implemented | No audit persistence or hooks/use cases exist. |
| Retryable operations are idempotent | Not implemented | Required commands and generic idempotency records are documented (`docs/design/phase-3.5.4-backend-architecture.md:134-145`; `docs/design/phase-3.5.5-database-design.md:294-300`) but absent. |
| Important configuration and recipe changes preserve history/effective dates | Not implemented | Recipe effective intervals are proposed (`docs/design/phase-3.5.5-database-design.md:264-268`); broader configuration history is not modeled and none is implemented. |

No invariant can be classified **Verified** because the repository contains no production backend/data implementation. “Unable to verify” is not used here: the absence is directly verifiable from repository contents and the explicit no-backend/no-database statements.

## F. Architecture risks

### Critical

#### C1. Payment-before-preparation invariant conflicts with the proposed architecture

**Impact:** unpaid items could be prepared, and backend transaction boundaries/API sequencing would be costly to reverse after real data and kitchen workflows exist.  
**Evidence:** submission creates ticket work in the proposed workflow and transaction model (`docs/design/phase-3.5.2-business-workflows.md:112-121,165-172`; `docs/design/phase-3.5.3-domain-model.md:262-267`). Payment is scheduled after core POS and kitchen/delivery (`docs/planning/phase-3.5-production-roadmap.md:47-69`).  
**Required response:** revise the approved workflow, aggregate events, roadmap, and transaction/outbox boundaries before migrations or API implementation.

#### C2. Branch tenancy and authorization boundary are absent

**Impact:** branch data leakage, incorrect permissions, ambiguous uniqueness, cross-branch stock/cash/payroll corruption, and migration churn.  
**Evidence:** the proposal targets one cafe location (`docs/design/phase-3.5.3-domain-model.md:3-7`) and has no Organization/Brand/Branch or scoped assignment records.  
**Required response:** approve organizational ownership and branch scope before schema design.

#### C3. No durable transaction system exists

**Impact:** the prototype cannot safely accept money, persist orders, recover failures, or provide audit/accounting evidence. Browser refresh loses state.  
**Evidence:** order is session-local (`frontend/src/features/pos/components/order-panel.tsx:51-57`); payment performs no financial transaction (`frontend/src/features/pos/components/payment-confirmation-dialog.tsx:71-85`).

#### C4. Paid-but-undispatched recovery is undefined

**Impact:** a customer can be charged without preparation receiving work, with no reliable recovery path or duplicate prevention.  
**Evidence:** an outbox is only a general proposal (`docs/design/phase-3.5.4-backend-architecture.md:173-183`); no state model links settlement to preparation dispatch under the newly agreed sequencing.

#### C5. Payroll/cash/inventory financial histories are absent

**Impact:** silent retroactive changes, inaccurate wages/cash/stock valuation, weak reconciliation, and insufficient audit evidence.  
**Evidence:** no payroll, cash-session, valuation, or transfer lifecycle exists even in the proposed schema.

### High

#### H1. Historical sales are not preserved by the executable prototype

Current order lines resolve names and prices from mutable fixtures. Promoting them to DTOs would make old totals/display dependent on current catalog state (`frontend/src/features/pos/types/pos.ts:27-31`; `frontend/src/features/pos/lib/get-demo-order-summary.ts:13-24`).

#### H2. Inventory proposal does not meet costing and transfer requirements

Signed stock movements and cached quantity are useful but insufficient for weighted-average valuation and staged inter-warehouse transfers (`docs/design/phase-3.5.5-database-design.md:270-284`).

#### H3. Workforce shift is overloaded

Using one Shift aggregate for employee attendance, operating period, and cash reconciliation would make temporary branch assignments, actual worked branch, register handoff, and payroll closure ambiguous.

#### H4. Approval semantics are underspecified

Actor/approver columns do not define who requested, which policy applied, when approval expired, whether self-approval is allowed, or how a rejected/pending action behaves.

#### H5. Proposed role vocabulary differs from the agreed vocabulary

Documents propose Owner/Manager, Cashier/Service, and Barista (`docs/design/phase-3.5.2-business-workflows.md:239-247`), while the agreed requirement states Owner, Manager, and Staff. Mapping and capability policy must be resolved before seeding roles or writing policy tests.

#### H6. External integration and printing failure handling is not designed to domain depth

Provider calls, webhooks, receipt/invoice delivery, and printers require durable attempts, status, retries, idempotency, observability, and operator recovery—not only asynchronous execution. Current material is preliminary (`docs/design/phase-3.5.4-backend-architecture.md:146-183`).

### Medium

#### M1. Route metadata and authorization are not centralized

Routes and navigation are separate, and no route guard exists. The prior review identifies this seam (`docs/research/phase-3.5.1-prototype-architecture-review.md:76-83`). Address it when production auth/routes are introduced, not as isolated cleanup.

#### M2. Browser E2E coverage can create false confidence about business correctness

The Playwright suite is valuable for prototype interaction/responsiveness, but it does not test domain transitions, API contracts, database constraints, concurrency, rollback, or authorization (`docs/research/phase-3.5.1-prototype-architecture-review.md:156-170`).

#### M3. Duplicate responsive component trees may complicate server state

Mobile and desktop POS layouts render separate child trees. When subscriptions, mutations, or focus recovery arrive, state ownership must remain above them (`docs/research/phase-3.5.1-prototype-architecture-review.md:95-104`).

#### M4. No durable glossary or approved ADRs

The domain vocabulary remains proposed and pending approval (`docs/design/phase-3.5.3-domain-model.md:281-283`). Terms such as shift, cash session, branch, staff, transaction, transfer, and confirmed must be made unambiguous before implementation.

### Low

#### L1. Test scope is Chromium-only

The Playwright configuration has a single desktop Chromium project (`frontend/playwright.config.ts:18-26`). This is acceptable for the current foundation but should be reassessed against actual POS/tablet hardware.

#### L2. Generated artifacts exist locally

`frontend/dist/`, `frontend/test-results/`, and `frontend/playwright-report/` are present in the workspace. Documentation says test/report artifacts should be ignored (`docs/testing/playwright-setup.md:42-49`). They are not architecture inputs and should remain excluded from source control.

## G. Recommended implementation sequence

This sequence preserves working frontend components and introduces production seams only when needed.

1. **Resolve business gates and reconcile documentation.** Confirm the payment-before-preparation rule; Organization/Brand/Branch model; exact roles/capabilities; branch assignments; order/payment/refund rules; inventory costing/transfers; payroll/cash-session rules; purchasing/expenses; correction/approval thresholds; business day/retention. Update workflows, domain model, roadmap, glossary, and ADRs before migrations.
2. **Design the expanded logical data model.** Add organizational/branch ownership, identity/employment/effective assignments, immutable transactional history, cash session, attendance/payroll, valuation/transfers, purchasing/expenses, approval, outbox/jobs, and integration attempts. Define branch foreign keys, uniqueness scopes, effective dates, lock/idempotency rules, and correction patterns.
3. **Build the backend foundation.** Implement the proposed Rails API/PostgreSQL modular monolith only after ADR approval: `/api/v1`, authentication, backend authorization, branch context, structured errors/logging, audit and idempotency primitives, migrations/tests, health, CI, backup/restore. The framework choice is sensible and need not be rewritten without contrary evidence.
4. **Deliver a paid-order vertical slice.** Catalog read → table/session if required → draft order → server authoritative totals/snapshots → successful cash payment → durable preparation dispatch/ticket → visible recoverable dispatch state. Include expected versions, idempotency, rollback, authorization, audit, and concurrent-device tests. Adapt the existing POS components through DTO/view-model mappers rather than replacing them.
5. **Add kitchen and upstairs delivery.** Consume paid dispatch exactly once; implement ticket transitions, assignment, failure/retry, floor/table destination snapshots, and polling initially. Reuse the existing delivery UI presentation after mapping real DTOs; discard demo status contracts.
6. **Add electronic payments/refunds and cash sessions.** Implement provider intent/webhook recovery, bank vs cash transaction categories, refunds/voids, register cash-session open/close, append-only movements, immutable reconciliation snapshots, printing/receipt jobs if approved.
7. **Add inventory, purchasing, and expenses.** Start with units/ingredients/effective recipes, then costed purchase receipt and weighted-average movement posting, consumption/reversal, warehouse transfers with dispatch/in-transit/receipt, stocktake/adjustments, supplier/expense approvals.
8. **Add attendance and payroll.** Effective compensation agreements, attendance/actual branch, monthly/hourly/per-shift calculations, review/approval, close snapshot, post-close adjustments/reversals, payments and reports.
9. **Add reconciled reports and dashboards.** Build from committed records and branch/business-day rules. Add materialization only after measured query needs. Preserve closed payroll/cash/report definitions where required.
10. **Production hardening.** On-site hardware/network test, browser/device matrix, printer/provider recovery drills, concurrency/failure tests, monitoring/alerts, security review, retention/access review, and restore rehearsal.

The immediate next phase should therefore be **requirements and domain-model reconciliation for the expanded multi-branch scope, followed by backend foundation**, not implementation of the existing Phase 3.5.5 submission-to-kitchen plan.

## H. Decisions requiring Owner approval

### Genuine business decisions

| Decision | Why Owner approval is required |
|---|---|
| Organization, brand, and branch hierarchy | Determines operational ownership, shared vs branch-specific catalog/configuration, and reporting scope. |
| Resolve the preparation trigger conflict | Confirm that successful payment is the mandatory trigger, and define exceptions such as complimentary/remake/owner-authorized work. |
| Order/payment rules | Real payment methods, partial/split tender, bank/QR verification, overpayment, timeout, refund/void windows, cancellation and correction policy. |
| Role/capability policy | Exact meaning of Owner, Manager, Staff; who can work at which branch; temporary assignment approval; re-authentication and self-approval restrictions. |
| Inventory operating policy | Warehouses/stock locations, weighted-average costing inputs, negative stock, deduction timing, transfer ownership, dispatch/receipt confirmation, waste/remake. |
| Purchasing and expenses | Launch scope, supplier workflow, purchase/receipt/invoice matching, expense categories, payment sources, approval thresholds. |
| Attendance and payroll | Monthly/hourly/per-shift eligibility, overtime/break rules if applicable, cutoff, rounding, approval, close/reopen/correction rules, and legal/accounting obligations. |
| Cash operations | Whether cash session is per register/device/branch, who opens/closes, counted cash process, variance threshold/approval, bank deposits/transfers. |
| Historical correction and approval policy | Which confirmed actions require reversal vs adjustment, mandatory reasons, approval thresholds, retention and access. |
| Business day and reports | Timezone/day boundary, branch consolidation, required KPIs/exports, and which closed reports must be immutable. |
| Receipt/invoice/printing and hardware | Fiscal/receipt requirements, printers/cash drawer/scanner, device topology, operational fallback. |
| Offline/degraded operation | Whether orders/payments may be captured offline, permitted commands, staff expectations, and conflict behavior. |

Existing documents already identify many narrower pending decisions, but they were written for a one-location scope (`docs/planning/phase-3.5-business-decisions-register.md:3-5`; `docs/design/phase-3.5.5-database-design.md:332-346`). The expanded requirements need the additional decisions above.

### Engineering decisions that do not require Owner product approval

Engineering should document and review these technically, while explaining cost/risk where they affect budget or operations:

- Rails modular monolith code organization and Active Record conventions.
- REST resource/command naming and `/api/v1` DTO mapping.
- UUID versus bigint primary keys, once offline/distributed ID requirements are known.
- Database constraint/index implementation, lock order, isolation, and optimistic locking.
- Idempotency-record schema, request fingerprinting, and outbox implementation.
- Exact audit event serialization and redaction mechanics within approved retention/access policy.
- Polling implementation and thresholds for later realtime adoption.
- Background job adapter/queue technology once a concrete job workload exists.
- Test architecture, builders/fixtures, CI commands, observability libraries, and deployment mechanics.
- Frontend server-state library choice, if one becomes useful; the current prototype does not justify one yet.

Owner input is still required for deployment budget, supported hardware, downtime tolerance, and operational service levels, but implementation details should not be turned into business votes.

## Verification note

This report was checked against repository source, configuration, tests, and the existing proposal documents. No UI fixture, local state transition, navigation entry, or design proposal is claimed as production logic. No source code, dependency, migration, or configuration was changed, and no destructive command was run. The requested report is the sole file created by this audit.
