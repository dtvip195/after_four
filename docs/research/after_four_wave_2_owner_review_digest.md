# AFTER FOUR — Wave 2 Owner Review Digest

**Portfolio:** `P2A Loyalty/Promotions + P2B Inventory/Cash/Workforce`

**Status:** `CORRECTIONS_PREPARED — INDEPENDENT_RE_REVIEW_REQUIRED — NO_NEW_DECISIONS_RECORDED`

**Authority:** `NW-OR-01` — documentation/discovery only

**Implementation authorization:** `NOT_GRANTED`

**Date:** 2026-11-23

## 1. Executive summary

Wave 2 confirms five independent ownership areas and exposes policy dependencies that must close before technical design. Loyalty and Promotions are Production MVP `MUST` capabilities, but most calculation and operating policy remains undecided. Cash has the strongest Owner-confirmed operating baseline. Inventory and Workforce contain useful workshop/design evidence but require business and, in places, accounting/legal closure.

No Wave 2 recommendation is approved merely by appearing here. The annexes select no physical database topology, API, transaction, lock, isolation, dependency, or implementation.

## 2. What is already decided

| Area | Existing Owner-confirmed boundary |
|---|---|
| Loyalty | Production MVP `MUST`; persistent ledger/history, Customer/transaction linkage, authorized adjustment, audit/reconciliation/reversal evidence, and shared-across-Branches direction. Anonymization preserves/freeze behavior is fixed. |
| Promotions | Advanced Promotions is Production MVP `MUST`; effective anonymization preserves redeemed history and freezes unredeemed Customer-specific benefits without changing public Promotion rules. |
| Cash | One shared drawer; 2,000,000 VND Operating Day float carried across shifts; no automatic reset/top-up; Owner-authorized evidenced top-ups; accountable open/close/handover/discrepancy; delegated Expense limits and no self-approval/splitting. |
| Inventory | No complete Owner-approved operating policy was found. Retention and cross-domain ownership constraints apply; workshop proposals are not decisions. |
| Workforce | Employee/User/role/assignment vocabulary and planning assumptions are fixed; detailed lifecycle, scheduling, attendance, and timekeeping policy remains open. |

## 3. What was discovered

| Domain | Principal discovery | Highest risk if guessed |
|---|---|---|
| Loyalty | Ledger and Customer anonymization boundaries are clear; formulas, redemption, expiry, adjustments, Refund allocation, and scope are not. | Incorrect financial/customer value and impermissible post-anonymization use. |
| Promotions | Capability is mandatory, but lifecycle, types, eligibility, stacking, allocation, Voucher, timing, and administration are unapproved. | Non-deterministic totals, fraud, and historical inconsistency. |
| Inventory | Movement/lot/transfer/count concepts exist as proposals; location, units, negative stock, consumption, approvals, and valuation require decisions. | Untraceable stock, unsafe availability, and accounting distortion. |
| Cash | Owner policy is substantial, but Operating Day, actors, discrepancy/correction, handover, Refund, and reconciliation details remain open. | Drawer/accountability drift and revenue misclassification. |
| Workforce | Employment, access, assignments, shifts, duties, and attendance must remain distinct. | Authority leakage, inaccurate time/payroll, and lost history. |

## 4. Recommended Owner-review batches

### Batch A — independent foundations

- Loyalty: earning basis, redemption limits, expiration, and adjustment authority.
- Promotions: first bounded types, applicability scope, stacking/priority, and the operation-specific administration authority matrix.
- Inventory: locations, negative-stock rule, and lot/expiry applicability.
- Cash: Operating Day, Session actors, discrepancy, and correction policy.
- Workforce: Employee lifecycle, Branch Assignment, scheduling, swaps, and attendance authority.

These questions are independently accountable and may be reviewed in parallel.

### Batch B — coordinated commercial consequences

- Loyalty and Promotion ordering/allocation against authoritative Order totals.
- Promotion discount allocation and Loyalty eligible-value treatment.
- Refund/cancellation reversal behavior across Loyalty, Promotions, and Cash.
- Catalog Price/tax/service-charge/rounding prerequisites.

Coordination is required; one domain's decision does not transfer accountability to another.

### Batch C — evidence-dependent operations

- Inventory normal consumption recognition, waste/remake deviations, and costing after Recipe/Preparation/accounting input.
- Cash Refund/reconciliation after P1A Refund method/allocation closure.
- Workforce break/rounding/leave/overtime after qualified employment/legal review.

## 5. Decisions requiring Owner input

| Domain | Temporary refs | Count | Current status |
|---|---:|---:|---|
| Loyalty | `P2A-LOY-OD-01`–`07` | 7 | `OWNER_DECISION_REQUIRED` |
| Promotions | `P2A-PROMO-OD-01`–`06`, `07A`–`07J`, `08` | 17 | `OWNER_DECISION_REQUIRED` |
| Inventory | `P2B-INV-OD-01`–`03`, `04A`–`04B`, `05`–`08` | 9 | `OWNER_DECISION_REQUIRED` |
| Cash | `P2B-CASH-OD-01`–`08` | 8 | `OWNER_DECISION_REQUIRED` |
| Workforce | `P2B-WF-OD-01`–`05`, `06A`–`06E`, `07A`–`07B`, `08A` | 13 | `OWNER_DECISION_REQUIRED` |
| Ordering | `W2-ORD-OD-01` | 1 | `OWNER_DECISION_REQUIRED — DEPENDENT` |
| **Total active Owner policy candidates** |  | **55** | Superseded and technical follow-up references excluded |

These references are navigation aids only. No canonical `ODB-*` ID is allocated, requested, or reserved.

Superseded, non-active references are `P2A-PROMO-OD-07`, `P2B-INV-OD-04`, `P2B-WF-OD-06`, `P2B-WF-OD-07`, `P2B-WF-OD-08`, and `W2-INT-02`. The `W2-INT-02A`–`02C` rows are coordination/dependency records, not additional ballot candidates. Workforce integration mechanisms associated with `P2B-WF-OD-08A` are a later technical-design follow-up and are not counted.

## 6. Explicitly preserved deferrals and gaps

- P1A partial/split tender, cancellation consequences, completed exceptions, Order closure, and later Customer association remain deferred.
- P1C authentication spike remains deferred; Identity Milestone 2B remains unauthorized.
- Customer multi-Brand semantics, optional later Order association, exceptional identity evidence, and legal/privacy details remain under existing governance.
- `C0-R05`, `C0-R08`, and `C0-R11` remain deferred.
- Tax, service charge, rounding, zero/free items, Modifier pricing, and Price publication details remain unresolved.
- No cross-Brand Loyalty or Promotion sharing is inferred.

## 7. Recommended next work packages

1. Owner review of Batch A as five independently accountable decision sets, using separate selections for each Promotions administration operation and each Workforce policy.
2. A coordinated commercial-allocation brief only after Batch A identifies supported Loyalty/Promotion behavior.
3. Separate Inventory normal-consumption, deviation, and valuation briefs with qualified operational/accounting input.
4. Cash Operating Day/discrepancy/Refund brief aligned with P1A policy.
5. Workforce timekeeping/legal brief before payroll or attendance technical design.
6. Ordering review of `W2-ORD-OD-01` after the applicable component policies are available; coordination does not combine ownership.

No domain-specific technical Gate A request or implementation proposal may proceed for a scope whose required Owner policies and dependencies remain unresolved.

This restriction does not suspend the Owner-approved parallel preparation of logical database design documentation under NW-OR-01. Such preparation remains documentation/design only and does not authorize physical schema, migrations, database creation, persistence implementation, transaction or locking mechanisms, or runtime behavior. Any domain-specific technical baseline remains subject to its applicable Owner decisions and governance gates.

## 8. Deliverable index and boundary

- [Loyalty annex](after_four_p2a_loyalty_policy_discovery.md)
- [Promotions annex](after_four_p2a_promotions_policy_discovery.md)
- [Inventory annex](after_four_p2b_inventory_domain_discovery.md)
- [Cash annex](after_four_p2b_cash_domain_discovery.md)
- [Workforce annex](after_four_p2b_workforce_domain_discovery.md)
- [Cross-domain register](after_four_wave_2_cross_domain_integration_decision_register.md)

This digest records discovery, not Owner selections. The 55 active candidates require independent re-review before the package may claim consolidated Owner-review readiness. Candidate E Gate A remains `DEFER_GATE_A — NOT_GRANTED`; Candidate E Gate B preparation remains `NOT_AUTHORIZED`. No schema, migration, database, API, code, test, dependency, runtime, deployment, Control Acceptance, FOA, or Production Authorization is granted.
