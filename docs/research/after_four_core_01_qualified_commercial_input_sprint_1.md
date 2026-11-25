# AFTER FOUR — CORE-01 Qualified Commercial Input — Sprint 1

**Assessment date:** 2026-11-24 (Asia/Tokyo)

**Baseline:** `main` at `ad7e7bf973233e0286c91af2a1b7bbb27d817d25`

**Authority:** documentation and evidence reconciliation only

**Readiness:** `NOT_READY_FOR_FRESH_INDEPENDENT_GATE_A_REVIEW`

> **SUBSEQUENT CURRENT STATUS — 2026-11-25.** Sections 1–2 below preserve the evidence assessment made before `CORE-OD-18`. The later canonical [Owner Decision Baseline](../architecture/after_four_owner_decision_baseline.md) and [Real Menu and Pricing Specification §4](../architecture/after_four_real_menu_pricing_specification.md#4-commercial-baseline-v1-for-cost-calculation) now record 28 Products and 52 exact Product/Variant costing combinations, VND selling-price inputs, equal dine-in/takeaway prices, and First-Branch/first-Price-Version scope. That approval is a costing baseline only; it grants no Price publication or implementation authority. The current CORE-01 qualified blockers remain `CORE-OD-03` tax treatment/display and `CORE-OD-04` monetary precision/rounding, together with the actual seller/item/channel facts those reviews require. The historical missing-price rows below must not be used as the current Commercial V1 status.

> **PUBLIC-SOURCE CLOSURE PASS — 2026-11-25.** Current official Vietnamese tax, invoice, accounting, price-display and record rules have now been researched and indexed in the [canonical Owner worksheet](../architecture/after_four_core_02_core_04_owner_decision_worksheet.md). They establish configurable legal constraints, evidence/record integrity and retention baselines. They do not establish AFTER FOUR's legal seller/tax-registration facts, Product-by-Product tax classification, final tax-inclusive/exclusive presentation, or a universal statutory POS rounding sequence. `CORE-OD-03` therefore remains partly `UNRESOLVED_LEGAL_QUESTION` pending actual applicability facts and then `OWNER_DECISION_REQUIRED`; `CORE-OD-04` remains `OWNER_DECISION_REQUIRED`. No external professional engagement is planned under the current Owner direction.

## 1. Evidence boundary

`OWNER_CONFIRMED` — `CORE-OD-01` approves by reference the 28 Product identities, six groupings and previously presented option labels in the [Proposed Launch Menu v3](../architecture/after_four_proposed_launch_menu_v3.md). It does not make artifact labels canonical identifiers or approve final sellable Variant applicability, exact Price, scope or effective period.

`VERIFIED_REPOSITORY_EVIDENCE` — The prior [28-row reconciliation](after_four_core_01_commercial_evidence_closure_sprint_2.md#2-complete-product-and-option-reconciliation), [Catalog/Pricing discovery](../architecture/after_four_catalog_pricing_discovery.md), [Real Menu and Pricing Specification](../architecture/after_four_real_menu_pricing_specification.md), and current [Core Operations Design Package](after_four_accelerated_core_operations_design_package.md) contain no authoritative executable Price dataset.

`NOT_FOUND_IN_REVIEWED_SOURCES` — No reviewed repository artifact supplies a complete Product→sellable Variant→exact Price→scope→effective-period mapping. This finding does not prove that no external Owner-controlled commercial artifact exists.

## 2. Product-to-commercial-evidence matrix

“Candidate options” below transcribe presented labels only. They are `VERIFIED_REPOSITORY_EVIDENCE`, not confirmed sellable Variants. Currency is expected to be VND by existing monetary direction, but an executable Price row is still missing.

| Group | Artifact label | Owner-approved Product identity | Candidate options previously presented | Confirmed sellable Variant applicability | Exact Price / currency | Channel / Branch scope | Effective period | Exact closure artifact required |
|---|---|---|---|---|---|---|---|---|
| Cà phê | `CF001` | Cà phê đen | Đá / Nóng | `NOT_FOUND_IN_REVIEWED_SOURCES` | `MISSING` / VND | `MISSING` | `MISSING` | Owner-controlled row confirming canonical identity, sellable selections, exact VND Price per selection, channel/Branch scope and effective-from/to. |
| Cà phê | `CF002` | Cà phê sữa | Đá / Nóng | `NOT_FOUND_IN_REVIEWED_SOURCES` | `MISSING` / VND | `MISSING` | `MISSING` | Same complete Owner-controlled commercial row for this Product. |
| Cà phê | `CF003` | Bạc xỉu | Đá / Nóng | `NOT_FOUND_IN_REVIEWED_SOURCES` | `MISSING` / VND | `MISSING` | `MISSING` | Same complete Owner-controlled commercial row for this Product. |
| Cà phê | `CF004` | Cà phê muối | Đá | `NOT_FOUND_IN_REVIEWED_SOURCES` | `MISSING` / VND | `MISSING` | `MISSING` | Same complete Owner-controlled commercial row for this Product. |
| Cà phê | `CF005` | Cà phê dừa | Đá | `NOT_FOUND_IN_REVIEWED_SOURCES` | `MISSING` / VND | `MISSING` | `MISSING` | Same complete Owner-controlled commercial row for this Product. |
| Cà phê | `CF006` | Latte | Đá / Nóng | `NOT_FOUND_IN_REVIEWED_SOURCES` | `MISSING` / VND | `MISSING` | `MISSING` | Same complete Owner-controlled commercial row for this Product. Illustrative Latte values are not acceptable evidence. |
| Trà trái cây | `TR001` | Trà đào cam sả | S / M / L | `NOT_FOUND_IN_REVIEWED_SOURCES` | `MISSING` / VND | `MISSING` | `MISSING` | Same complete Owner-controlled commercial row for this Product. |
| Trà trái cây | `TR002` | Trà vải | S / M / L | `NOT_FOUND_IN_REVIEWED_SOURCES` | `MISSING` / VND | `MISSING` | `MISSING` | Same complete Owner-controlled commercial row for this Product. |
| Trà trái cây | `TR003` | Trà chanh | S / M / L | `NOT_FOUND_IN_REVIEWED_SOURCES` | `MISSING` / VND | `MISSING` | `MISSING` | Same complete Owner-controlled commercial row for this Product. |
| Trà trái cây | `TR004` | Trà tắc mật ong | S / M / L | `NOT_FOUND_IN_REVIEWED_SOURCES` | `MISSING` / VND | `MISSING` | `MISSING` | Same complete Owner-controlled commercial row for this Product. |
| Trà trái cây | `TR005` | Trà chanh dây | S / M / L | `NOT_FOUND_IN_REVIEWED_SOURCES` | `MISSING` / VND | `MISSING` | `MISSING` | Same complete Owner-controlled commercial row for this Product. |
| Nước ép và giải khát | `NG001` | Nước chanh | S / M / L | `NOT_FOUND_IN_REVIEWED_SOURCES` | `MISSING` / VND | `MISSING` | `MISSING` | Same complete Owner-controlled commercial row for this Product. |
| Nước ép và giải khát | `NG002` | Chanh dây đá | S / M / L | `NOT_FOUND_IN_REVIEWED_SOURCES` | `MISSING` / VND | `MISSING` | `MISSING` | Same complete Owner-controlled commercial row for this Product. |
| Nước ép và giải khát | `NG003` | Cam ép | S / M / L | `NOT_FOUND_IN_REVIEWED_SOURCES` | `MISSING` / VND | `MISSING` | `MISSING` | Same complete Owner-controlled commercial row for this Product. |
| Nước ép và giải khát | `NG004` | Soda chanh | S / M / L | `NOT_FOUND_IN_REVIEWED_SOURCES` | `MISSING` / VND | `MISSING` | `MISSING` | Same complete Owner-controlled commercial row for this Product. |
| Sinh tố và đá xay | `SM001` | Bơ xay dừa non | S / M / L | `NOT_FOUND_IN_REVIEWED_SOURCES` | `MISSING` / VND | `MISSING` | `MISSING` | Same complete Owner-controlled commercial row for this Product. |
| Sinh tố và đá xay | `SM002` | Sinh tố xoài | S / M / L | `NOT_FOUND_IN_REVIEWED_SOURCES` | `MISSING` / VND | `MISSING` | `MISSING` | Same complete Owner-controlled commercial row for this Product. |
| Sinh tố và đá xay | `SM003` | Sinh tố dâu | S / M / L | `NOT_FOUND_IN_REVIEWED_SOURCES` | `MISSING` / VND | `MISSING` | `MISSING` | Same complete Owner-controlled commercial row for this Product. |
| Sinh tố và đá xay | `SM004` | Cà phê dừa đá xay | S / M / L | `NOT_FOUND_IN_REVIEWED_SOURCES` | `MISSING` / VND | `MISSING` | `MISSING` | Same complete Owner-controlled commercial row for this Product. |
| Thức uống khác | `KH001` | Matcha latte | Đá / Nóng; size TBD | `NOT_FOUND_IN_REVIEWED_SOURCES` | `MISSING` / VND | `MISSING` | `MISSING` | Owner-controlled row must resolve the size ambiguity as well as all commercial fields. |
| Thức uống khác | `KH002` | Cacao sữa | Đá / Nóng; size TBD | `NOT_FOUND_IN_REVIEWED_SOURCES` | `MISSING` / VND | `MISSING` | `MISSING` | Owner-controlled row must resolve the size ambiguity as well as all commercial fields. |
| Thức uống khác | `KH003` | Sữa chua trái cây | Default; size TBD | `NOT_FOUND_IN_REVIEWED_SOURCES` | `MISSING` / VND | `MISSING` | `MISSING` | Owner-controlled row must resolve default/size applicability as well as all commercial fields. |
| Bánh và đồ ăn nhẹ | `BA001` | Bánh croissant | Một phần | `NOT_FOUND_IN_REVIEWED_SOURCES` | `MISSING` / VND | `MISSING` | `MISSING` | Same complete Owner-controlled commercial row for this Product. |
| Bánh và đồ ăn nhẹ | `BA002` | Cheesecake | Một phần | `NOT_FOUND_IN_REVIEWED_SOURCES` | `MISSING` / VND | `MISSING` | `MISSING` | Same complete Owner-controlled commercial row for this Product. |
| Bánh và đồ ăn nhẹ | `BA003` | Brownie chocolate | Một phần | `NOT_FOUND_IN_REVIEWED_SOURCES` | `MISSING` / VND | `MISSING` | `MISSING` | Same complete Owner-controlled commercial row for this Product. |
| Bánh và đồ ăn nhẹ | `BA004` | Muffin | Một cái | `NOT_FOUND_IN_REVIEWED_SOURCES` | `MISSING` / VND | `MISSING` | `MISSING` | Same complete Owner-controlled commercial row for this Product. |
| Bánh và đồ ăn nhẹ | `BA005` | Sandwich jambon phô mai | Một phần | `NOT_FOUND_IN_REVIEWED_SOURCES` | `MISSING` / VND | `MISSING` | `MISSING` | Same complete Owner-controlled commercial row for this Product. |
| Bánh và đồ ăn nhẹ | `BA006` | Khoai tây chiên | Một phần | `NOT_FOUND_IN_REVIEWED_SOURCES` | `MISSING` / VND | `MISSING` | `MISSING` | Same complete Owner-controlled commercial row for this Product. |

`VERIFIED_REPOSITORY_EVIDENCE` — Reconciliation remains `6 + 5 + 4 + 4 + 3 + 6 = 28`; Product identity coverage is 28/28. Final-Variant evidence, exact Price evidence, scope evidence and effective-period evidence are absent for every row. Demo fixtures, synthetic tests, illustrative values and approximate VND 23,000 / 33,000 / 43,000–49,000 bands cannot fill those fields.

## 3. Qualified-input brief — `CORE-OD-03`

| Field | Qualified-input specification |
|---|---|
| Classification | `QUALIFIED_INPUT_REQUIRED`; subsequent policy remains `OWNER_DECISION_REQUIRED`. |
| Business question | For the actual Vietnamese seller, approved item classes, and dine-in/takeaway channels, what tax treatment applies and how must Price/tax be displayed on menu, quote, receipt and any applicable invoice? |
| Correctness impact | Tax inclusivity/exclusivity and display affect quoted totals, sold snapshots, receipts, reporting and reconciliation. Guessing can create incorrect customer-facing and accounting evidence. |
| Evidence required | Qualified Vietnamese Tax/Accounting memorandum identifying adviser/role, effective date, applicable authoritative sources, seller assumptions, item/channel distinctions, inclusivity/exclusivity, display obligations, invoice/receipt implications, limitations and unresolved facts. |
| Owner-controlled decisions | Final Product Prices, commercial positioning, whether the qualified constraints are accepted as the policy baseline, and any separately permissible business choice. Professional input does not choose Prices or implementation. |
| Consequence if unresolved | CORE-01 remains `NOT_READY_FOR_FRESH_INDEPENDENT_GATE_A_REVIEW`; no executable calculation or display baseline may be asserted. |

## 4. Qualified-input brief — `CORE-OD-04`

| Field | Qualified-input specification |
|---|---|
| Classification | `QUALIFIED_INPUT_REQUIRED`; subsequent policy remains `OWNER_DECISION_REQUIRED`. |
| Business question | What monetary precision, rounding method and rounding boundary apply to item components, Order totals, Payment targets, corrections and later Refund allocation in integer VND? |
| Correctness impact | Different boundaries or calculation order can produce different authoritative totals and break Payment, reconciliation and historical reporting consistency. |
| Evidence required | Qualified Accounting/commercial analysis stating permitted precision, rounding mode, boundary, sequence assumptions, treatment of intermediate values, component/total relationship, examples, effective date and limitations. |
| Owner-controlled decisions | Selection among legally/accountingly permissible business approaches and their scope/effective date. Qualified input does not approve an algorithm, schema or code. |
| Consequence if unresolved | Deterministic totals cannot be approved; CORE-01 remains not ready for fresh independent Gate A review. |

## 5. Closure and exclusions

`OWNER_DECISION_REQUIRED` — The Owner must supply or explicitly validate the complete commercial artifact and later decide `CORE-OD-03/04` after qualified input. `GATE_B_DEFERRED` — identifiers, persistence, constraints, concurrency, APIs and runtime calculation remain later technical design. `VERIFIED_REPOSITORY_EVIDENCE` — no external advice was obtained, no Price or Variant was inferred, and no Gate or implementation authority is granted.
