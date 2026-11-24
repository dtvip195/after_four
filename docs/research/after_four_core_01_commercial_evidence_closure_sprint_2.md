# AFTER FOUR — CORE-01 Commercial Evidence Closure — Sprint 2

**Assessment date:** 2026-11-24

**Baseline:** `main` at `7bf418159565a24bfe7589230eedb281b3804ccf`

**Status:** `NOT_READY_FOR_OWNER_GATE_A_REVIEW — INPUT_BLOCKED`

**Authority:** documentation and logical-design assessment only

## 1. Scope and evidence rules

This report reconciles the approved-by-reference menu baseline without creating Product, Variant, Price, tax or rounding policy. The authoritative sources are the [Owner Decision Baseline](../architecture/after_four_owner_decision_baseline.md), [Proposed Launch Menu v3](../architecture/after_four_proposed_launch_menu_v3.md), [Real Menu and Pricing Specification](../architecture/after_four_real_menu_pricing_specification.md), [Catalog/Pricing discovery](../architecture/after_four_catalog_pricing_discovery.md), [Core Operations Design Package](after_four_accelerated_core_operations_design_package.md), and [Core Operations Design Remediation](after_four_accelerated_core_operations_design_remediation.md).

`CORE-OD-01` approves the 28 names, six groupings and presented option labels by reference. Artifact labels are not canonical codes. Presented options are not proof of final persisted Variant applicability or capacity. Approximate VND 23,000, VND 33,000 and VND 43,000–49,000 bands are not exact Prices and are not mapped to any Product or Variant.

## 2. Complete Product and option reconciliation

| Group | Source artifact label | Approved-by-reference Product identity | Presented option evidence | Final Variant applicability | Exact Price | Scope/effective evidence |
|---|---|---|---|---|---|---|
| Cà phê | `CF001` | Cà phê đen | Đá / Nóng | `UNCONFIRMED` | `MISSING` | `MISSING` |
| Cà phê | `CF002` | Cà phê sữa | Đá / Nóng | `UNCONFIRMED` | `MISSING` | `MISSING` |
| Cà phê | `CF003` | Bạc xỉu | Đá / Nóng | `UNCONFIRMED` | `MISSING` | `MISSING` |
| Cà phê | `CF004` | Cà phê muối | Đá | `UNCONFIRMED` | `MISSING` | `MISSING` |
| Cà phê | `CF005` | Cà phê dừa | Đá | `UNCONFIRMED` | `MISSING` | `MISSING` |
| Cà phê | `CF006` | Latte | Đá / Nóng | `UNCONFIRMED` | `MISSING` | `MISSING` |
| Trà trái cây | `TR001` | Trà đào cam sả | S / M / L | `UNCONFIRMED` | `MISSING` | `MISSING` |
| Trà trái cây | `TR002` | Trà vải | S / M / L | `UNCONFIRMED` | `MISSING` | `MISSING` |
| Trà trái cây | `TR003` | Trà chanh | S / M / L | `UNCONFIRMED` | `MISSING` | `MISSING` |
| Trà trái cây | `TR004` | Trà tắc mật ong | S / M / L | `UNCONFIRMED` | `MISSING` | `MISSING` |
| Trà trái cây | `TR005` | Trà chanh dây | S / M / L | `UNCONFIRMED` | `MISSING` | `MISSING` |
| Nước ép và giải khát | `NG001` | Nước chanh | S / M / L | `UNCONFIRMED` | `MISSING` | `MISSING` |
| Nước ép và giải khát | `NG002` | Chanh dây đá | S / M / L | `UNCONFIRMED` | `MISSING` | `MISSING` |
| Nước ép và giải khát | `NG003` | Cam ép | S / M / L | `UNCONFIRMED` | `MISSING` | `MISSING` |
| Nước ép và giải khát | `NG004` | Soda chanh | S / M / L | `UNCONFIRMED` | `MISSING` | `MISSING` |
| Sinh tố và đá xay | `SM001` | Bơ xay dừa non | S / M / L | `UNCONFIRMED` | `MISSING` | `MISSING` |
| Sinh tố và đá xay | `SM002` | Sinh tố xoài | S / M / L | `UNCONFIRMED` | `MISSING` | `MISSING` |
| Sinh tố và đá xay | `SM003` | Sinh tố dâu | S / M / L | `UNCONFIRMED` | `MISSING` | `MISSING` |
| Sinh tố và đá xay | `SM004` | Cà phê dừa đá xay | S / M / L | `UNCONFIRMED` | `MISSING` | `MISSING` |
| Thức uống khác | `KH001` | Matcha latte | Đá / Nóng; size TBD | `UNCONFIRMED` | `MISSING` | `MISSING` |
| Thức uống khác | `KH002` | Cacao sữa | Đá / Nóng; size TBD | `UNCONFIRMED` | `MISSING` | `MISSING` |
| Thức uống khác | `KH003` | Sữa chua trái cây | Default; size TBD | `UNCONFIRMED` | `MISSING` | `MISSING` |
| Bánh và đồ ăn nhẹ | `BA001` | Bánh croissant | Một phần | `UNCONFIRMED` | `MISSING` | `MISSING` |
| Bánh và đồ ăn nhẹ | `BA002` | Cheesecake | Một phần | `UNCONFIRMED` | `MISSING` | `MISSING` |
| Bánh và đồ ăn nhẹ | `BA003` | Brownie chocolate | Một phần | `UNCONFIRMED` | `MISSING` | `MISSING` |
| Bánh và đồ ăn nhẹ | `BA004` | Muffin | Một cái | `UNCONFIRMED` | `MISSING` | `MISSING` |
| Bánh và đồ ăn nhẹ | `BA005` | Sandwich jambon phô mai | Một phần | `UNCONFIRMED` | `MISSING` | `MISSING` |
| Bánh và đồ ăn nhẹ | `BA006` | Khoai tây chiên | Một phần | `UNCONFIRMED` | `MISSING` | `MISSING` |

Reconciliation is `6 + 5 + 4 + 4 + 3 + 6 = 28`. Product-name coverage is `28/28`; exact Price coverage is `0/28 Product rows`. A Variant denominator cannot be stated responsibly because the final applicable persisted Variant set is unresolved. The six approved groupings are Cà phê, Trà trái cây, Nước ép và giải khát, Sinh tố và đá xay, Thức uống khác, and Bánh và đồ ăn nhẹ.

## 3. Exact evidence-gap register

| Gap | Owner or qualified input required | Why it blocks |
|---|---|---|
| `CORE01-S2-E01` | Confirm final sellable Variant applicability and actual capacities for every Product. | The set of Price-bearing selections cannot be frozen. |
| `CORE01-S2-E02` | Supply one exact Price for every confirmed sellable Variant. | Approximate bands cannot produce an authoritative quote or Payment target. |
| `CORE01-S2-E03` | Supply Price scope: chain default and any first-Branch override. | `ODB-CAT-07` allows scope but does not provide actual values. |
| `CORE01-S2-E04` | Supply effective date/time for each Price Version. | `ODB-CAT-08` requires immutable effective-dated versions; no dataset exists. |
| `CORE01-S2-E05` | Confirm exact canonical Product/Variant transcription and identifiers separately from artifact labels. | The source explicitly withholds canonical codes and persisted records. |
| `CORE01-S2-E06` | Qualified Vietnamese Tax/Accounting analysis for the actual seller, item classes and dine-in/takeaway contexts. | `CORE-OD-03` remains deferred; the repository cannot establish applicability or presentation. |
| `CORE01-S2-E07` | Qualified constraints and later Owner decision for VND precision, rounding mode, boundary and calculation sequence. | `CORE-OD-04` remains deferred; deterministic totals cannot be asserted. |

The input must not infer tax advice from generic legal material. It must identify authoritative sources, effective dates, assumptions and limitations, and address tax applicability, inclusive/exclusive treatment, receipt/invoice presentation, calculation boundary, VND precision, rounding mode/boundary, calculation sequence and any material dine-in/takeaway distinction. Qualified advice constrains later Owner policy; it does not choose Prices or implementation mechanisms.

## 4. Payment-target consistency check

The current [Core Operations logical design](after_four_accelerated_core_operations_design_package.md) remains internally consistent with the commercial gap:

- Ordering owns the confirmation-attempt lifecycle and terminal fence.
- A Payment Target created provisionally remains non-payable until trusted evidence proves the same attempt confirmed.
- Timeout, transport failure, absent observation or caller assertion cannot cancel a provisional target.
- Cancellation requires trusted Ordering evidence for the same Order and attempt with terminal `aborted_terminal` plus its terminal evidence revision.
- Missing, stale, conflicting or mismatched evidence fails closed for reconciliation; a cancelled target is never reused or reactivated.
- Draft lines remain bound to their quoted Price Version; unrelated Draft mutation cannot silently reprice them. Explicit re-quote/review is required by `ODB-CAT-09`, and sold Price locks at confirmation under `ODB-CAT-10`.

These are logical-design statements, not implemented commercial behavior or Gate B mechanism selection.

## 5. Readiness conclusion

**Outcome:** `NOT_READY_FOR_OWNER_GATE_A_REVIEW — INPUT_BLOCKED`.

The approved menu identity baseline is complete, but the commercial baseline is not coherent enough for Owner Gate A review until the final Variant set, exact Prices, scope/effective evidence, qualified tax constraints and qualified rounding constraints exist and `CORE-OD-03`/`CORE-OD-04` can be decided. No approved menu selection is reopened. No Gate or implementation authority follows from this report.
