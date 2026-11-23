# AFTER FOUR — Wave 2 Cross-Domain Integration and Decision Register

**Package:** `P2A Loyalty + Promotions / P2B Inventory + Cash + Workforce`

**Status:** `DISCOVERY_INTEGRATED — OWNER_REVIEW_REQUIRED`

**Authority:** `NW-OR-01` — documentation/discovery only

**Canonical ODB allocation:** `NOT_REQUESTED`

**Implementation authorization:** `NOT_GRANTED`

**Date:** 2026-11-23

## 1. Purpose and independence rule

This register coordinates five independently owned annexes. Shared cadence does not create a combined aggregate, database, transaction, service, or approval path. Cross-context facts must eventually use explicit consumer/producer contracts; this document does not design those contracts physically.

## 2. Deliverables and accountable ownership

| Annex | Accountable owner | Owns | Does not own |
|---|---|---|---|
| [Loyalty](after_four_p2a_loyalty_policy_discovery.md) | Loyalty | Account, ledger, balance, qualification, earn/redeem/adjust/reverse/expire/reconcile policy | Customer identity, Promotion rules, Order or Payment truth |
| [Promotions](after_four_p2a_promotions_policy_discovery.md) | Promotions | Promotion lifecycle, eligibility, applicability, stacking, benefit use/history | Catalog Price, Loyalty value, Customer identity, Order snapshot |
| [Inventory](after_four_p2b_inventory_domain_discovery.md) | Inventory | Locations, stock movement/position, lots, transfers, counts, reconciliation | Catalog definitions, Preparation work, Ordering sales |
| [Cash](after_four_p2b_cash_domain_discovery.md) | Cash | Drawer, float, Cash Session/Transaction/count/discrepancy/handover | Payment settlement, Order, Employee Shift |
| [Workforce](after_four_p2b_workforce_domain_discovery.md) | Workforce | Employee, Branch Assignment, schedule, duties, attendance/timekeeping | User authentication, Role Assignment, Cash authority |

## 3. Shared terminology and ownership

| Shared concept | Authoritative owner | Consumers / rule |
|---|---|---|
| Customer Profile/anonymization | Customer | Loyalty/Promotions receive only approved references/outcomes; no re-identification. |
| Confirmed Order/sold allocation | Ordering | Loyalty/Promotions consume immutable commercial inputs; Inventory does not reconstruct sales from Catalog. |
| Payment/Refund outcome | Payment | Loyalty reversal and Cash movement consume authoritative outcomes; no consumer rewrites Payment. |
| Catalog/Recipe definition | Catalog/Recipe | Promotions uses applicability facts; Inventory uses approved ingredient/Recipe inputs. |
| Preparation work/deviation | Preparation | Inventory consumes approved consumption/waste/remake facts. |
| Branch/Organization ancestry | Organization | All domains retain scope/provenance without deriving authorization from IDs alone. |
| Employee/Shift | Workforce | Cash and operations may consume accountability facts; Shift never grants capability. |
| Operating Day | Business governance; consumer-specific ownership unresolved | Cash float/Expense and Reporting depend on one approved boundary; Shift is not a substitute. |

## 4. Candidate future business events/contracts

These names describe possible committed facts, not approved payloads or transports.

| Candidate fact | Producer | Potential consumers | Missing decision |
|---|---|---|---|
| `OrderCommercialTermsConfirmed` | Ordering | Loyalty, Promotions, Reporting | Eligible-value and discount allocation policy |
| `PaymentFullySettled` / `RefundSucceeded` | Payment | Loyalty, Cash, Reporting | Refund allocation/method and reversal policy |
| `CustomerAnonymizationEffective` | Customer | Loyalty, Promotions | Delivery contract, retention, exceptional treatment |
| `PromotionBenefitRedeemed/Reversed` | Promotions | Ordering/Reporting | Reservation, redemption, reversal, allocation |
| `PreparationConsumptionConfirmed` | Preparation | Inventory | Recipe/timing/waste/remake policy |
| `StockTransferDispatched/Received` | Inventory | Reporting/operations | Approval and discrepancy policy |
| `CashSessionClosed` | Cash | Reporting | Operating Day and discrepancy resolution |
| `EmployeeBranchAssignmentChanged` | Workforce | Identity projection/scheduling | Assignment authority and consistency contract |

## 5. Conflict and dependency register

| Ref | Conflict/dependency | Required treatment | Status |
|---|---|---|---|
| `W2-INT-01` | P1A split tender/Refund/cancellation deferrals affect Loyalty and Promotions allocation and Cash corrections. | Preserve deferral; do not choose proportional or method rules here. | `BLOCKED_BY_OWNER_POLICY` |
| `W2-INT-02A` | Ordering owns Order-level calculation sequence and line/amount allocation; P1A does not currently decide the ordering of Loyalty redemption and Promotion discounts. | Review `W2-ORD-OD-01` as an Ordering-owned policy while consulting Loyalty, Promotions, Payment, Catalog, tax/accounting, and Reporting. | `COORDINATION_REQUIRED` |
| `W2-INT-02B` | Loyalty owns eligible earning/redemption value and Loyalty allocation, but consumes authoritative Order/Payment and Promotion allocation facts. | Coordinate `P2A-LOY-OD-01`, `P2A-LOY-OD-02`, and `P2A-LOY-OD-05` with Ordering/Promotions without transferring Loyalty accountability. | `COORDINATION_REQUIRED` |
| `W2-INT-02C` | Promotions owns eligibility, priority/stacking, and Promotion discount allocation, but does not own Order totals or Loyalty value. | Coordinate `P2A-PROMO-OD-03` and `P2A-PROMO-OD-05` with Ordering/Loyalty without transferring Promotions accountability. | `COORDINATION_REQUIRED` |
| `W2-INT-03` | Catalog Price/tax/service-charge/rounding remain unresolved. | Close authoritative total components before calculation design. | `OWNER_DECISION_REQUIRED` |
| `W2-INT-04` | Preparation timing/waste/remake affects Inventory. | Preparation owns work facts; Inventory owns movements; approve timing/outcomes. | `OWNER_DECISION_REQUIRED` |
| `W2-INT-05` | Employee Shift, Cash Session, and Operating Day are distinct but overlap operationally. | Preserve separate identities and approve explicit relationships/cutoff. | `OWNER_DECISION_REQUIRED` |
| `W2-INT-06` | Branch scope is known structurally but cross-Brand Loyalty/Promotion behavior is unresolved. | Default deny/unavailable; do not infer Organization-wide sharing. | `OWNER_DECISION_REQUIRED` |
| `W2-INT-07` | Historical docs propose APIs/transactions before policy closure. | Treat as non-authoritative design evidence; no physical adoption. | `DOCUMENTATION_MATURITY_GAP` |

`W2-INT-02` is superseded by `W2-INT-02A`–`02C` and is not an active decision or coordination record. Coordination does not create shared domain ownership or permit one domain to approve another domain's policy.

### 5.1 Ordering-owned allocation candidate

| Ref | Accountable owner | Owner question | Recommendation | Alternatives / trade-offs | Dependencies / boundary |
|---|---|---|---|---|---|
| `W2-ORD-OD-01` | Ordering | What Order-level calculation sequence and line/amount allocation policy applies when Catalog Price, Promotions, Loyalty redemption, tax, service charge, and rounding interact? | Approve a deterministic business sequence and preservation of component provenance only after the participating policies are known. | Different orderings change payable value, eligible Loyalty value, allocation, Refunds, and reporting; leaving it undefined prevents authoritative totals. | Consult Catalog, Promotions, Loyalty, Payment, tax/accounting, and Reporting. P1A Refund/cancellation/split-tender deferrals remain controlling. This decides business calculation policy only, not algorithms, schema, or runtime orchestration. |

`W2-ORD-OD-01` is a temporary `OWNER_DECISION_REQUIRED` reference because no existing P1A decision establishes this Order-level calculation/allocation policy. It is counted once as an Ordering candidate; the three `W2-INT-02*` rows are dependency records and are not Owner ballot items.

## 6. Consolidated Owner-review ordering

1. Review independent foundation questions in parallel: `P2A-LOY-OD-01`–`04`, `P2A-PROMO-OD-01`–`03`, `P2B-INV-OD-01`–`03`, `P2B-CASH-OD-01`–`04`, and `P2B-WF-OD-01`–`05`.
2. Coordinate, but do not bundle, shared commercial questions: Loyalty eligible value/redemption, Promotion allocation/stacking, Catalog total components, and P1A Refund/cancellation.
3. Review `W2-ORD-OD-01` only after the applicable Catalog total-component, Promotion, and Loyalty policy inputs are known; its Ordering owner does not approve those inputs.
4. Review downstream operational questions only after their prerequisites: Inventory consumption/valuation, Cash Refund reconciliation, Workforce payroll/legal inputs.
5. Retain anonymization policies as fixed constraints; no Wave 2 question reopens them.

## 7. Governance boundary and exit

All `P2A-*`, `P2B-*`, and `W2-*` references are temporary review references. None is an allocated or reserved canonical ID. Recommendations are `PROPOSED_NOT_APPROVED`. Candidate E Gate A/B, P1 decisions, Identity Milestone 2B, ADR status, CAT-TRR status, schema, migrations, database operations, code/tests, runtime, deployment, FOA, and Production Authorization remain unchanged and unauthorized.
