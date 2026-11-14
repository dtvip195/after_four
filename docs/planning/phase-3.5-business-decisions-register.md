# Phase 3.5 — Business Decisions Register

> **HISTORICAL / SUPERSEDED_FOR_IMPLEMENTATION.** This register preserves the questions and recommendations known at Phase 3.5; its `pending` labels are not the current decision status. Use the canonical [Owner Decision Baseline](../architecture/after_four_owner_decision_baseline.md) for Owner-confirmed decisions and the [DDD Foundation](../architecture/after_four_ddd_foundation.md) for current proposed context vocabulary. Payment-before-preparation, manual bank verification, stage-specific cancellation, shared daily cash float/top-ups, delegated expense limits, and reporting direction have since been answered as recorded there. Completed-Order exception details, partial/split payment, operating-day boundary, and reporting delivery details remain unresolved. Original historical text below is intentionally preserved.

## 1. How to use this register

No recommendation below is an owner decision. Set `Owner confirmation` to an explicit decision, date and approver after review. P0 blocks implementation of its domain; P1 should be settled before production; P2 can be deferred.

Related: [workflows](../design/phase-3.5.2-business-workflows.md), [domain model](../design/phase-3.5.3-domain-model.md), [backend architecture](../design/phase-3.5.4-backend-architecture.md), [database design](../design/phase-3.5.5-database-design.md).

## 2. P0 — implementation gates

### BD-TBL-001 — Table session and order cardinality

- **Domain:** Table / Order
- **Question:** Is there one active order per table visit, multiple orders, or one order with separate checks?
- **Options/trade-offs:** One order is simplest but needs payment allocation for separate checks; multiple orders are flexible but fragment the table view; checks are cleanest long term but add UI/model scope.
- **Recommendation:** One active Order per TableSession with multiple submission rounds; preserve a later seam for check/payment allocation.
- **Late impact:** Core foreign keys, POS workflow, kitchen batching, payment and reports must be redesigned.
- **Priority:** P0
- **Owner confirmation required:** Yes — pending.

### BD-TBL-002 — Move, combine and split table scope

- **Domain:** Table
- **Question:** Which operations are launch requirements, and what happens to orders/payments/delivery during them?
- **Options/trade-offs:** Move only is safe and simple; combined tables need multi-assignment; split sessions/items is operationally powerful but substantially more complex.
- **Recommendation:** Support move history in MVP; defer combine/split unless owner confirms frequent need.
- **Late impact:** TableSession schema and order/check model may require data migration.
- **Priority:** P0 for move; P1 for combine/split
- **Owner confirmation required:** Yes — pending.

### BD-ORD-001 — Order lifecycle and close rule

- **Domain:** Order
- **Question:** Which states/transitions exist, and must fulfillment and payment both complete before close?
- **Options/trade-offs:** One coarse status is easy but ambiguous; separate order, fulfillment and payment lifecycles are clearer but require composed UI.
- **Recommendation:** Keep lifecycles separate and define an explicit OrderClosurePolicy.
- **Late impact:** Status fields, endpoints, permissions, reporting and tests become incompatible.
- **Priority:** P0
- **Owner confirmation required:** Yes — pending.

### BD-ORD-002 — Save and submit semantics

- **Domain:** Order / Kitchen
- **Question:** When is an order durable, price-locked and sent to preparation?
- **Options/trade-offs:** Save every draft change improves recovery but increases concurrency; save only on submit is simpler but risks loss; draft persistence plus explicit submit balances both.
- **Recommendation:** Persist draft, revalidate price/availability, then explicitly submit a batch to Kitchen.
- **Late impact:** API command model, offline recovery, ticket generation and audit behavior change.
- **Priority:** P0
- **Owner confirmation required:** Yes — pending.

### BD-ORD-003 — Cancellation and correction rules

- **Domain:** Order
- **Question:** Who can cancel items/orders before and after preparation/payment, and which reasons are required?
- **Options/trade-offs:** Free cancellation is fast but weakens control; stage-based permission/reason protects revenue but adds steps.
- **Recommendation:** Draft edits are free; submitted cancellations are recorded; prepared/paid cancellation requires elevated permission and compensation/refund handling.
- **Late impact:** Historical model and financial/inventory corrections become unreliable.
- **Priority:** P0
- **Owner confirmation required:** Yes — pending.

### BD-CAT-001 — Product variants, size and modifiers

- **Domain:** Catalog
- **Question:** Are sizes, toppings, required choices or modifier groups launch requirements?
- **Options/trade-offs:** Flat products are quickest; variants/modifiers represent the menu accurately but add catalog, pricing, kitchen and order snapshot complexity.
- **Recommendation:** Owner supplies the real menu; model a default variant and only the modifier rules actually used.
- **Late impact:** OrderItem schema, recipe mapping and pricing API may need redesign.
- **Priority:** P0 before catalog/order API
- **Owner confirmation required:** Yes — pending.

### BD-CAT-002 — Price composition

- **Domain:** Catalog / Order
- **Question:** Do VAT, service charge, discount, promotion, manual price override or scheduled prices apply?
- **Options/trade-offs:** Base-price only is simple; explicit components support operations/accounting but need policy and authorization.
- **Recommendation:** Define authoritative server-side components and snapshot each applied component; do not infer from prototype subtotal.
- **Late impact:** Historical totals, receipts and reports can become irreconcilable.
- **Priority:** P0
- **Owner confirmation required:** Yes — pending, with accounting/legal input.

### BD-KIT-001 — Kitchen ticket lifecycle and routing

- **Domain:** Kitchen
- **Question:** When are tickets created, what states exist, and is there one preparation station?
- **Options/trade-offs:** Ticket per order is simple but fails additional rounds; ticket per submission/station is extensible but needs sequence/routing.
- **Recommendation:** Ticket per submitted batch and station; begin with one active station.
- **Late impact:** Queue behavior, duplicate prevention and delivery linkage change.
- **Priority:** P0
- **Owner confirmation required:** Yes — pending.

### BD-DEL-001 — Delivery queue entry and ownership

- **Domain:** Upstairs Delivery
- **Question:** Does work enter the queue when an item/ticket is ready, who claims it, and where does the UI live?
- **Options/trade-offs:** Automatic queue is reliable but needs clear readiness; manual creation is flexible but can be forgotten. Kitchen-owned versus service-owned UI changes handoff responsibility.
- **Recommendation:** Automatically create ready floor-2 work after commit; service staff claim it; owner chooses navigation placement after observing the real handoff.
- **Late impact:** Kitchen events, navigation, staffing and SLAs must be reworked.
- **Priority:** P0
- **Owner confirmation required:** Yes — pending.

### BD-DEL-002 — Delivery granularity and failure flow

- **Domain:** Upstairs Delivery
- **Question:** Can one order be delivered in partial batches, and what happens on failed delivery?
- **Options/trade-offs:** Whole-order delivery avoids item allocation; partial batches reduce wait but require DeliveryItem tracking. Simple failure note is easy; retry/reassignment history is safer.
- **Recommendation:** Confirm actual batching; if partial delivery occurs, link deliveries to kitchen ticket items and retain attempt events.
- **Late impact:** Delivery schema cannot be safely changed without historical allocation migration.
- **Priority:** P0
- **Owner confirmation required:** Yes — pending.

### BD-PAY-001 — Payment methods, partial and split tender

- **Domain:** Payment
- **Question:** Which methods are real, and can one order use partial/multiple methods or separate checks?
- **Options/trade-offs:** One full payment is simplest; mixed tender and split checks match customer needs but require allocation/reconciliation UI.
- **Recommendation:** Confirm current practice before implementation; always allow multiple transaction attempts in the data model.
- **Late impact:** Payment aggregate, order closure and UI may need fundamental redesign.
- **Priority:** P0
- **Owner confirmation required:** Yes — pending.

### BD-PAY-002 — Electronic provider and failure semantics

- **Domain:** Payment
- **Question:** Is QR a static bank transfer, dynamic provider transaction, or manual confirmation? How are timeout/duplicate/failure handled?
- **Options/trade-offs:** Manual/static is cheap but weakly verifiable; provider integration gives status but adds fees, webhooks and operations.
- **Recommendation:** Select provider/process explicitly; require idempotency and retain all attempts regardless of option.
- **Late impact:** Security, reconciliation and API topology change.
- **Priority:** P0 before electronic payment
- **Owner confirmation required:** Yes — pending.

### BD-SHF-001 — Shift scope and open/close preconditions

- **Domain:** Shift
- **Question:** Is a shift per cafe, register or staff, and can open work carry across closure?
- **Options/trade-offs:** Store-wide is simplest for three staff; per-register gives better cash accountability; per-staff is detailed but operationally heavy.
- **Recommendation:** One store/register shift initially, with individual actors on transactions; block close or require manager-approved carryover.
- **Late impact:** Every order/payment FK and reconciliation report changes.
- **Priority:** P0
- **Owner confirmation required:** Yes — pending.

### BD-SEC-001 — Authentication and minimum permissions

- **Domain:** Staff / Security
- **Question:** How do staff sign in, which actions require owner/manager approval, and may credentials be shared?
- **Options/trade-offs:** Shared PIN is fast but destroys attribution; individual identity with role templates preserves audit at modest cost.
- **Recommendation:** Individual identity, three role templates and capability checks; manager re-auth for refunds, variance and sensitive corrections.
- **Late impact:** Audit data is unusable and retrofitting actor identity is difficult.
- **Priority:** P0
- **Owner confirmation required:** Yes — pending.

### BD-INV-001 — Inventory launch scope and deduction timing

- **Domain:** Inventory
- **Question:** Is inventory in first production scope, and is recipe consumption posted at submit, preparation start or completion?
- **Options/trade-offs:** Submit is early but overstates cancellations; start is balanced but requires kitchen events; completion is late for availability.
- **Recommendation:** If inventory is launch scope, post at kitchen start/accept and use compensating movements for waste/cancellation.
- **Late impact:** Historical stock cannot be reconstructed accurately.
- **Priority:** P0 before inventory implementation; otherwise explicitly deferred
- **Owner confirmation required:** Yes — pending.

### BD-OFF-001 — Offline operating policy

- **Domain:** Cross-cutting
- **Question:** Must staff create/submit orders or payments while disconnected?
- **Options/trade-offs:** Online-required is safe/simple but may stop service; offline draft only aids recovery; full offline commands require local DB, conflict policy and security.
- **Recommendation:** Measure connectivity; launch with clear degraded state and idempotent retry unless owner requires full offline POS.
- **Late impact:** API IDs, command ordering, conflict resolution and frontend storage may need redesign.
- **Priority:** P0 architecture decision
- **Owner confirmation required:** Yes — pending.

### BD-ARC-001 — Primary key strategy

- **Domain:** Architecture / Database
- **Question:** UUID or Rails-default bigint for business records?
- **Options/trade-offs:** Bigint is smaller/faster and simple; UUID supports opaque/distributed client-generated IDs but increases index/storage cost.
- **Recommendation:** UUID if offline/multi-device creation is plausible; otherwise bigint is adequate. Resolve together with `BD-OFF-001`.
- **Late impact:** Changing primary keys after integrations/data exist is expensive.
- **Priority:** P0 before migrations
- **Owner confirmation required:** Yes — pending technical approval.

## 3. P1 — decide before production

### BD-PAY-003 — Refund, void and approval policy

- **Domain:** Payment
- **Question:** Who may refund/void, within what time, and how are cash/electronic refunds reconciled?
- **Options/trade-offs:** Owner-only is controlled but slow; manager capability is practical but needs limits/audit.
- **Recommendation:** Capability + reason + original transaction link; define amount/time thresholds.
- **Late impact:** Financial audit and reconciliation gaps.
- **Priority:** P1
- **Owner confirmation required:** Yes — pending.

### BD-SHF-002 — Cash variance and cash movements

- **Domain:** Shift
- **Question:** Which paid-in/paid-out movements exist and who approves variance?
- **Options/trade-offs:** Only payment totals are simple but cannot reconcile cash drawer activity; explicit ledger improves control.
- **Recommendation:** Append-only cash movement types and manager-approved variance reason.
- **Late impact:** Closing reports cannot explain differences.
- **Priority:** P1
- **Owner confirmation required:** Yes — pending.

### BD-RPT-001 — Business day, timezone and report definitions

- **Domain:** Reporting
- **Question:** What timezone/day cutoff defines daily revenue, and are reports gross, net, paid or ordered sales?
- **Options/trade-offs:** Calendar day is easy; shift/business cutoff may match operations better. Definitions produce different totals.
- **Recommendation:** Configure cafe IANA timezone and explicit business-day cutoff; document every metric formula.
- **Late impact:** Historical reports disagree across releases.
- **Priority:** P1
- **Owner confirmation required:** Yes — pending, with accounting input.

### BD-CAT-003 — Availability and sold-out behavior

- **Domain:** Catalog / Inventory
- **Question:** Is availability manual, schedule-based, stock-derived or a combination?
- **Options/trade-offs:** Manual is reliable/simple; stock-derived automates but depends on recipe accuracy; combined needs precedence rules.
- **Recommendation:** Manual availability at launch, optionally warn from inventory; do not auto-hide until stock quality is proven.
- **Late impact:** POS and kitchen expectations diverge.
- **Priority:** P1
- **Owner confirmation required:** Yes — pending.

### BD-INV-002 — Units, purchases, waste and negative stock

- **Domain:** Inventory
- **Question:** Which base units, conversions, receiving/waste flows and negative-stock rules are needed?
- **Options/trade-offs:** Fixed base units simplify integrity; flexible conversion supports purchasing but needs controlled factors. Blocking negatives improves accuracy but can halt service.
- **Recommendation:** Define base unit per ingredient, append-only movements and warning-first negative policy until data quality is proven.
- **Late impact:** Recipe/stock history becomes incomparable.
- **Priority:** P1
- **Owner confirmation required:** Yes — pending.

### BD-AUD-001 — Audit and retention policy

- **Domain:** Security / Compliance
- **Question:** Which actions/data are retained, for how long, and who may view/export them?
- **Options/trade-offs:** Broad retention aids investigation but increases privacy/security cost; narrow retention reduces exposure but may fail accounting needs.
- **Recommendation:** Retain financial/domain ledgers per professional advice; audit only sensitive actions with minimized payloads and restricted access.
- **Late impact:** Missing history cannot be recreated; excess data is costly to purge safely.
- **Priority:** P1
- **Owner confirmation required:** Yes — pending, with legal/accounting input.

### BD-RCP-001 — Receipt/invoice requirements

- **Domain:** Payment / Reporting
- **Question:** Are printed receipts, electronic receipts or fiscal invoices required, and what fields/numbering apply?
- **Options/trade-offs:** No integration is quickest; printing/e-invoice affects hardware, compliance, numbering and failure recovery.
- **Recommendation:** Confirm before payment production scope; treat printing/invoicing as idempotent post-payment workflows.
- **Late impact:** Payment completion and deployment hardware may change.
- **Priority:** P1
- **Owner confirmation required:** Yes — pending, with accounting/legal input.

### BD-OPS-001 — Device, printer and network topology

- **Domain:** Operations
- **Question:** How many POS/kitchen devices, which browsers/tablets, printers and network reliability?
- **Options/trade-offs:** Browser-only reduces hardware integration; receipt/kitchen printers and multiple devices introduce drivers, discovery and realtime needs.
- **Recommendation:** Inventory actual devices/network and run an on-site operational test before finalizing realtime/offline/printing architecture.
- **Late impact:** Production environment may invalidate assumptions.
- **Priority:** P1
- **Owner confirmation required:** Yes — pending.

## 4. P2 — safely deferrable

### BD-DEL-003 — Delivery SLA and escalation

- **Domain:** Upstairs Delivery
- **Question:** Are target delivery times, alerts and escalation needed?
- **Options/trade-offs:** No SLA keeps MVP simple; timers improve service but can create noise without staffing rules.
- **Recommendation:** Capture timestamps first; set SLA only after observing operations.
- **Late impact:** Low if timestamps/events are already retained.
- **Priority:** P2
- **Owner confirmation required:** Yes — pending later.

### BD-RPT-002 — Advanced analytics

- **Domain:** Reporting
- **Question:** Which trends, exports, scheduled reports or owner dashboards are valuable?
- **Options/trade-offs:** Broad dashboard scope delays core reliability; transactional exports/basic totals enable learning.
- **Recommendation:** Start with daily reconciliation and CSV/export needs; prioritize later from real questions.
- **Late impact:** Low if transactional facts and snapshots are correct.
- **Priority:** P2
- **Owner confirmation required:** Yes — pending later.

### BD-ARC-002 — Realtime transport

- **Domain:** Architecture
- **Question:** Polling or WebSocket/Action Cable for kitchen and delivery updates?
- **Options/trade-offs:** Polling is simple and sufficient at low scale; WebSockets reduce latency but add connection/deployment operations.
- **Recommendation:** Start with polling, measure, then adopt realtime if operational latency requires it.
- **Late impact:** Low if API resources and versioning are transport-neutral.
- **Priority:** P2
- **Owner confirmation required:** Yes — technical decision after measurement.

## 5. First owner review agenda

Resolve these together because they shape the entire backend:

1. `BD-TBL-001`, `BD-ORD-001`, `BD-ORD-002`: what a table visit/order is and when preparation begins.
2. `BD-KIT-001`, `BD-DEL-001`, `BD-DEL-002`: physical handoff from bar to floors.
3. `BD-PAY-001`, `BD-PAY-002`, `BD-CAT-002`: real settlement and price composition.
4. `BD-SHF-001`, `BD-SEC-001`: accountability during operation and close.
5. `BD-OFF-001`, `BD-ARC-001`, `BD-OPS-001`: device/network reality before technical foundation.
6. Decide explicitly whether `BD-INV-001` is launch scope or a later milestone.
