# AFTER FOUR — P2B Inventory Domain Discovery Annex

**Workstream:** `P2B-Inventory`

**Status:** `DISCOVERY_PREPARED — OWNER_REVIEW_REQUIRED`

**Authority:** `NW-OR-01` — discovery only

**Implementation authorization:** `NOT_GRANTED`

**Date:** 2026-11-23

## 1. Purpose and authority

Inventory owns stock locations, positions, lots where applicable, movements, counts, transfers, receiving/issuing, availability, and reconciliation. Catalog owns Product/Variant and future Recipe definitions; Preparation owns work/deviation facts; Ordering owns sold quantities; neither may directly edit Inventory state.

Existing Inventory material is predominantly `WORKSHOP_AGREED` or `TECHNICAL_PROPOSAL`. This annex does not approve its physical ledger, costing formula, API, schema, locks, or transaction boundaries.

## 2. Evidence and maturity

| Evidence | Status | Discovery consequence |
|---|---|---|
| [Business Domain Model §9](../architecture/after_four_business_domain_model.md#9-inventory-and-procurement) | Workshop/design | Proposes movement-led stock, lots, weighted average, staged transfers, and procurement; requires Owner policy closure. |
| [Data Integrity Rules §9](../architecture/after_four_data_integrity_rules.md#9-inventory-and-weighted-average-integrity) | Technical proposal | Useful integrity hypotheses, not database authorization. |
| [State Machines §§11–12](../architecture/after_four_state_machines.md#11-stock-transfer-state-machine) | Technical proposal | Transfer/receipt lifecycles need business review. |
| [P1A deferred decisions](after_four_p1a_order_payment_policy_closure.md) | Owner-deferred | Cancellation, Refund, prepared-work, waste/remake, and benefit consequences remain open. |

## 3. Candidate domain model

| Concept | Meaning | Unresolved boundary |
|---|---|---|
| Stock Location | Accountable physical holding point associated with authoritative Organization/Brand/Branch scope. | Warehouse/store-room/bar topology and central location scope. |
| Stock Item | Inventory-tracked ingredient/material identity. | Relationship to Catalog ingredient/Recipe and units of measure. |
| Stock Movement | Provenance-bearing receipt, issue, transfer, adjustment, waste, return, quarantine, or correction fact. | Approved movement types and posting authority. |
| Stock Position | Current quantity projection for an item/location/disposition. | Whether authoritative or derived; physical implementation unapproved. |
| Lot | Receipt batch with optional expiry/disposition evidence. | Which items require lot/expiry/FEFO. |
| Stock Transfer | Source-to-destination business process with dispatch and receipt evidence. | Approval thresholds, partial receipt, discrepancy outcomes. |
| Stocktake | Count process comparing observed quantity with expected position. | Freeze behavior, counters, approval and variance thresholds. |

## 4. Operational discovery

- **Receiving:** requires source, item, quantity, unit, disposition, actor, location, time, and evidence. Supplier/procurement and costing remain separate policy areas.
- **Issuing/consumption:** must originate from an authorized operational fact. Exact Preparation timing and RecipeVersion linkage are unresolved.
- **Transfers:** dispatch and receipt are separate accountable facts; in-transit treatment and discrepancy resolution require approval.
- **Counting/adjustment:** counts do not silently overwrite history. Variance, reason, approval, and correction policy remain open.
- **Reconciliation:** compare movements, positions, lots, transfers, and physical counts; drift is an exception requiring evidence.
- **Quantity consistency:** units, conversions, negative-stock policy, quarantine/rejection availability, and rounding require decisions.

## 5. Candidate Owner decisions

Every row below is `OWNER_DECISION_REQUIRED` and `PROPOSED_NOT_APPROVED`. A later selection would decide only the stated business boundary; it would not authorize tables, ledgers, constraints, indexes, transactions, locks, APIs, code, tests, deployment, or production use.

| Ref | Owner | Question | Recommendation | Alternatives / consequence |
|---|---|---|---|---|
| `P2B-INV-OD-01` | Inventory | What stock locations exist in the bounded MVP and who owns them? | Start with explicit Branch-owned locations; add central/shared locations only through separate policy. | Implicit Branch stock is simpler but weakens physical accountability. |
| `P2B-INV-OD-02` | Inventory | Is negative available stock ever allowed? | Default prohibit; define controlled exception/reconciliation rather than silent negative posting. | Allowing negative supports continuity but obscures shortages and valuation. |
| `P2B-INV-OD-03` | Inventory | Which items require lot, expiry, quarantine, and FEFO? | Decide per item class with food-safety input; do not universalize or omit silently. | Universal lots increase effort; no lots weaken traceability. |
| `P2B-INV-OD-04` | Inventory | When does Preparation consume stock and how are waste/remake facts handled? | Require Preparation-owned committed facts and separately approved Recipe inputs. | Start-time versus completion-time posting changes recovery and variance. |
| `P2B-INV-OD-05` | Inventory | What transfer approval, partial receipt, and discrepancy rules apply? | Preserve separate dispatch/receipt and require explicit discrepancy resolution. | Single-step transfer is simpler but erases custody and in-transit truth. |
| `P2B-INV-OD-06` | Inventory | What stocktake variance and adjustment authority applies? | Require reason and capability-specific approval; decide thresholds explicitly. | Owner-only is safe/slow; automatic tolerance risks hiding loss. |
| `P2B-INV-OD-07` | Inventory | Is weighted-average costing the approved valuation policy? | Obtain qualified accounting input before approval; keep valuation separate from quantity truth. | FIFO/standard/weighted average affect COGS and corrections differently. |
| `P2B-INV-OD-08` | Inventory | Which units/conversions and rounding rules are authoritative? | Approve canonical units and explicit versioned conversions before Recipe/stock automation. | Free-form units cause irreversible quantity ambiguity. |

## 6. Risks, dependencies, and exit

Catalog/Recipe, Preparation deviations, P1A cancellation, procurement, accounting, food safety, authorization, and audit are prerequisites. Inventory decisions do not authorize direct cross-context writes. The annex is ready for domain review only; all physical and runtime work remains unauthorized.
