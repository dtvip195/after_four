# AFTER FOUR — CORE-01 Blocker Closure — Sprint 3

**Evidence cutoff:** 2026-11-24

**Verified baseline:** `0423cf3c2f38871f105a82fdce04bfbb7383713b`

**Outcome:** `NOT_READY_FOR_OWNER_GATE_A_REVIEW — COMMERCIAL_AND_QUALIFIED_INPUT_BLOCKED`

**Authority:** evidence reconciliation and logical-design preparation only

## 1. Evidence scope and classification

The repository-wide search covered canonical architecture and governance documents, research and planning documents, backend code/spec fixtures, frontend demo fixtures/tests, and tracked data files. No authoritative spreadsheet, export, seed dataset, persisted menu, exact Price schedule, Branch override schedule, or approved effective-time record exists in the repository.

Evidence is classified as follows:

- `OWNER_APPROVED`: expressly confirmed in the [Owner Decision Baseline](../architecture/after_four_owner_decision_baseline.md) or an incorporated-by-reference artifact.
- `AUTHORITATIVE_SOURCE`: a canonical source that defines a currently controlling business fact without independently creating Owner authority.
- `DRAFT_PROPOSAL`: input template, design proposal, workshop example, research recommendation, or illustrative data.
- `HISTORICAL_OR_SUPERSEDED`: earlier vocabulary or example that cannot override the current baseline.
- `MISSING`: no repository evidence establishes the fact.
- `CONFLICTING`: two controlling sources assert incompatible facts. No such controlling conflict was found.

Primary controlling evidence is [Proposed Launch Menu v3](../architecture/after_four_proposed_launch_menu_v3.md), incorporated by `CORE-OD-01`, together with `ODB-CAT-01`, `ODB-CAT-04`, and `ODB-CAT-07`–`ODB-CAT-10`. The [Real Menu and Pricing Specification](../architecture/after_four_real_menu_pricing_specification.md) is an `OWNER_INPUT_DRAFT`; blank rows and its Latte 350/500 ml example are not approved data. Frontend values, backend spec amounts, workshops, and prototype menus are illustrative only.

## 2. Exact 28-Product evidence matrix

`CORE-OD-01` approves the Product identity/name, grouping, and presented option labels below by reference. Artifact labels are traceability labels, not canonical Product/Variant codes. `Candidate options` records source wording; it does not assert final applicability or persisted Variant identity.

| Group | Artifact label | Product identity | Candidate options | Applicability | Exact Price / period / scope | Evidence classification and source | Confidence / conflict | Exact missing input |
|---|---|---|---|---|---|---|---|---|
| Cà phê | `CF001` | Cà phê đen | Đá / Nóng | `UNCONFIRMED` | `MISSING` | `OWNER_APPROVED`; Launch Menu §1 | High; none | Confirm applicable persisted Variants; exact Price, effective time, chain/Branch/channel scope. |
| Cà phê | `CF002` | Cà phê sữa | Đá / Nóng | `UNCONFIRMED` | `MISSING` | `OWNER_APPROVED`; Launch Menu §1 | High; demo 45,000 is non-authoritative, not a controlling conflict | Confirm applicable persisted Variants; exact Price, effective time, chain/Branch/channel scope. |
| Cà phê | `CF003` | Bạc xỉu | Đá / Nóng | `UNCONFIRMED` | `MISSING` | `OWNER_APPROVED`; Launch Menu §1 | High; none | Confirm applicable persisted Variants; exact Price, effective time, chain/Branch/channel scope. |
| Cà phê | `CF004` | Cà phê muối | Đá | `UNCONFIRMED` | `MISSING` | `OWNER_APPROVED`; Launch Menu §1; Signature under `ODB-CAT-13` | High; none | Confirm applicable persisted Variant; exact Price, effective time, chain/Branch/channel scope. |
| Cà phê | `CF005` | Cà phê dừa | Đá | `UNCONFIRMED` | `MISSING` | `OWNER_APPROVED`; Launch Menu §1 | High; none | Confirm applicable persisted Variant; exact Price, effective time, chain/Branch/channel scope. |
| Cà phê | `CF006` | Latte | Đá / Nóng | `UNCONFIRMED` | `MISSING` | `OWNER_APPROVED`; Launch Menu §1 | High; 350/500 ml, 58,000 and demo values are proposals/examples, not conflicts | Confirm applicable persisted Variants/capacities; exact Price, effective time, chain/Branch/channel scope. |
| Trà trái cây | `TR001` | Trà đào cam sả | S / M / L | `UNCONFIRMED` | `MISSING` | `OWNER_APPROVED`; Launch Menu §2; Signature under `ODB-CAT-13` | High; source itself says confirmation required | Confirm size applicability/capacity and persisted Variants; exact Prices, effective time, scope. |
| Trà trái cây | `TR002` | Trà vải | S / M / L | `UNCONFIRMED` | `MISSING` | `OWNER_APPROVED`; Launch Menu §2 | High; source itself says confirmation required | Confirm size applicability/capacity and persisted Variants; exact Prices, effective time, scope. |
| Trà trái cây | `TR003` | Trà chanh | S / M / L | `UNCONFIRMED` | `MISSING` | `OWNER_APPROVED`; Launch Menu §2 | High; source itself says confirmation required | Confirm size applicability/capacity and persisted Variants; exact Prices, effective time, scope. |
| Trà trái cây | `TR004` | Trà tắc mật ong | S / M / L | `UNCONFIRMED` | `MISSING` | `OWNER_APPROVED`; Launch Menu §2 | High; source itself says confirmation required | Confirm size applicability/capacity and persisted Variants; exact Prices, effective time, scope. |
| Trà trái cây | `TR005` | Trà chanh dây | S / M / L | `UNCONFIRMED` | `MISSING` | `OWNER_APPROVED`; Launch Menu §2 | High; source itself says confirmation required | Confirm size applicability/capacity and persisted Variants; exact Prices, effective time, scope. |
| Nước ép và giải khát | `NG001` | Nước chanh | S / M / L | `UNCONFIRMED` | `MISSING` | `OWNER_APPROVED`; Launch Menu §3 | High; source itself says confirmation required | Confirm size applicability/capacity and persisted Variants; exact Prices, effective time, scope. |
| Nước ép và giải khát | `NG002` | Chanh dây đá | S / M / L | `UNCONFIRMED` | `MISSING` | `OWNER_APPROVED`; Launch Menu §3 | High; source itself says confirmation required | Confirm size applicability/capacity and persisted Variants; exact Prices, effective time, scope. |
| Nước ép và giải khát | `NG003` | Cam ép | S / M / L | `UNCONFIRMED` | `MISSING` | `OWNER_APPROVED`; Launch Menu §3 | High; source itself says confirmation required | Confirm size applicability/capacity and persisted Variants; exact Prices, effective time, scope. |
| Nước ép và giải khát | `NG004` | Soda chanh | S / M / L | `UNCONFIRMED` | `MISSING` | `OWNER_APPROVED`; Launch Menu §3 | High; source itself says confirmation required | Confirm size applicability/capacity and persisted Variants; exact Prices, effective time, scope. |
| Sinh tố và đá xay | `SM001` | Bơ xay dừa non | S / M / L | `UNCONFIRMED` | `MISSING` | `OWNER_APPROVED`; Launch Menu §4; Signature under `ODB-CAT-13` | High; source itself says confirmation required | Confirm size applicability/capacity and persisted Variants; exact Prices, effective time, scope. |
| Sinh tố và đá xay | `SM002` | Sinh tố xoài | S / M / L | `UNCONFIRMED` | `MISSING` | `OWNER_APPROVED`; Launch Menu §4 | High; source itself says confirmation required | Confirm size applicability/capacity and persisted Variants; exact Prices, effective time, scope. |
| Sinh tố và đá xay | `SM003` | Sinh tố dâu | S / M / L | `UNCONFIRMED` | `MISSING` | `OWNER_APPROVED`; Launch Menu §4 | High; source itself says confirmation required | Confirm size applicability/capacity and persisted Variants; exact Prices, effective time, scope. |
| Sinh tố và đá xay | `SM004` | Cà phê dừa đá xay | S / M / L | `UNCONFIRMED` | `MISSING` | `OWNER_APPROVED`; Launch Menu §4 | High; source itself says confirmation required | Confirm size applicability/capacity and persisted Variants; exact Prices, effective time, scope. |
| Thức uống khác | `KH001` | Matcha latte | Đá / Nóng; size TBD | `UNCONFIRMED` | `MISSING` | `OWNER_APPROVED`; Launch Menu §5 | High; demo 62,000 is non-authoritative, not a controlling conflict | Confirm temperature/size applicability and capacities; persisted Variants; exact Prices, effective time, scope. |
| Thức uống khác | `KH002` | Cacao sữa | Đá / Nóng; size TBD | `UNCONFIRMED` | `MISSING` | `OWNER_APPROVED`; Launch Menu §5 | High; size is explicitly TBD | Confirm temperature/size applicability and capacities; persisted Variants; exact Prices, effective time, scope. |
| Thức uống khác | `KH003` | Sữa chua trái cây | Default; size TBD | `UNCONFIRMED` | `MISSING` | `OWNER_APPROVED`; Launch Menu §5 | High; size is explicitly TBD | Confirm hidden/default and any size applicability; persisted Variant; exact Price, effective time, scope. |
| Bánh và đồ ăn nhẹ | `BA001` | Bánh croissant | Một phần | `UNCONFIRMED` | `MISSING` | `OWNER_APPROVED`; Launch Menu §6 | High; none | Confirm persisted hidden/default Variant; exact Price, effective time, chain/Branch/channel scope. |
| Bánh và đồ ăn nhẹ | `BA002` | Cheesecake | Một phần | `UNCONFIRMED` | `MISSING` | `OWNER_APPROVED`; Launch Menu §6 | High; none | Confirm persisted hidden/default Variant; exact Price, effective time, chain/Branch/channel scope. |
| Bánh và đồ ăn nhẹ | `BA003` | Brownie chocolate | Một phần | `UNCONFIRMED` | `MISSING` | `OWNER_APPROVED`; Launch Menu §6 | High; none | Confirm persisted hidden/default Variant; exact Price, effective time, chain/Branch/channel scope. |
| Bánh và đồ ăn nhẹ | `BA004` | Muffin | Một cái | `UNCONFIRMED` | `MISSING` | `OWNER_APPROVED`; Launch Menu §6 | High; none | Confirm persisted hidden/default Variant; exact Price, effective time, chain/Branch/channel scope. |
| Bánh và đồ ăn nhẹ | `BA005` | Sandwich jambon phô mai | Một phần | `UNCONFIRMED` | `MISSING` | `OWNER_APPROVED`; Launch Menu §6 | High; none | Confirm persisted hidden/default Variant; exact Price, effective time, chain/Branch/channel scope. |
| Bánh và đồ ăn nhẹ | `BA006` | Khoai tây chiên | Một phần | `UNCONFIRMED` | `MISSING` | `OWNER_APPROVED`; Launch Menu §6 | High; none | Confirm persisted hidden/default Variant; exact Price, effective time, chain/Branch/channel scope. |

Reconciliation is `6 + 5 + 4 + 4 + 3 + 6 = 28`. Product/grouping evidence coverage is `28/28`; confirmed final Variant applicability is `0/28`; exact Price/effective-period/scope coverage is `0/28`. The Variant denominator cannot be frozen because applicability and capacities are unresolved.

## 3. Exhausted evidence and non-authoritative values

The exhaustive repository search found no new controlling evidence beyond the sources already reconciled in Sprint 2. Specifically:

- `frontend/src/features/pos/data/pos-demo-data.ts`, `frontend/src/app/design-system/showcase-data.ts`, and related UI/E2E specs contain explicit demo values and behavior. They are not server authority, Price Versions, Owner decisions, or commercial records.
- Backend specs use synthetic Order/Payment amounts to test behavior; they do not identify Products or Prices.
- Planning/design examples such as a 58,000 VND Latte, generic Espresso/Americano/Cappuccino menus, and Peach Tea are historical workshop/prototype inputs and conflict with no controlling decision because they were never approved commercial facts.
- The Real Menu template contains blank identifiers/Prices and an explicitly illustrative Latte 350/500 ml example.
- No tracked spreadsheet, CSV/export, seed menu, approved invoice/receipt, or actual Branch Price record was found.

Further repetition over these sources cannot close the gap. The Owner must provide a bounded canonical dataset containing each sellable Product, final Variant applicability/capacity, exact VND Price, chain-default or Branch override scope, applicable channel if differentiated, effective start, optional end, source/approval identity, and revision. Approximate 23,000 / 33,000 / 43,000–49,000 VND bands remain direction only.

## 4. Variant and Price logical contract established by existing decisions

The following can be designed without choosing missing commercial data:

1. Product identity is Brand-global; Branch availability and Price may vary (`ODB-CAT-01`, `ODB-CAT-06`, `ODB-CAT-07`).
2. Every sellable selection references a persisted Variant. A Product is therefore not sold without a Variant; a hidden/default Variant represents a selection with no customer-visible choice (`ODB-CAT-04`).
3. Presented Nóng/Đá, S/M/L, Default, Một phần, and Một cái labels are approved baseline inputs, but final Variant applicability, capacity and persisted identity remain Owner input. `ODB-CAT-12` only says S/M/L applies to suitable Products.
4. Catalog/Pricing owns immutable, effective-dated chain-default and explicit Branch-override Price versions (`ODB-CAT-07`, `ODB-CAT-08`). No channel-specific Price policy is established; channel scope must be explicit if the Owner intends differentiation.
5. A sale resolves one currently applicable published Price Version for the exact Product/Variant and Branch at the relevant effective time. Absence, overlap, ambiguity, stale evidence, or missing scope fails closed. Exact publication authority and overlap/concurrency enforcement remain unresolved design/authorization.
6. A Draft line binds its quoted Price Version. An authoritative Price change requires explicit re-quote/revalidation and operator review before confirmation (`ODB-CAT-09`); unrelated Draft mutation cannot silently reprice an existing line.
7. Confirmation locks the Product/Variant identity, commercial labels, Price Version reference, unit sold Price and required calculation evidence as the historical Order Item snapshot (`ODB-CAT-10`). Later Catalog/Price changes cannot rewrite it.
8. The Payment target derives only from the confirmed authoritative Order total. Client/demo prices and client-provided aggregate amounts are not the future authoritative calculation boundary.

No storage model, numeric type, query, transaction, lock, constraint, API or runtime mechanism is selected here.

## 5. Qualified Vietnamese Tax/Accounting input brief

### 5.1 Known project requirements

- Dine-in and takeaway are in the bounded slice.
- Integer VND representation is preserved; no rounding behavior is inferred.
- Service Charge, price-changing Modifiers and complimentary/zero-price Items are excluded from the initial slice under confirmed Core decisions.
- Direct operator-entered sold-price override is prohibited; published Price Versions and Branch scope remain authoritative.
- Payment must reconcile to the confirmed Order total.

### 5.2 Questions for qualified review

For the actual seller/entity, locations, Product classes, channels, transaction dates, and invoice/receipt context, qualified Vietnamese Tax/Accounting input must identify authoritative sources, effective dates, assumptions and limitations and address:

1. applicable tax category/rate/base per relevant Product class and effective date;
2. whether displayed/contract Prices must be tax-inclusive or tax-exclusive and what customer disclosure is required;
3. required receipt/invoice presentation of gross, net, rate and tax amount;
4. whether dine-in/takeaway materially changes treatment;
5. legally/accountingly acceptable VND precision and rounding modes;
6. component, line, subtotal, tax, or Order rounding boundary and reconciliation requirements;
7. required calculation sequence and treatment of residuals; and
8. evidence/retention requirements relevant to the sold-price and calculation snapshot.

This brief does not state a tax conclusion or assume applicability from generic legal material.

### 5.3 Owner commercial decisions after qualified input

The Owner must decide `CORE-OD-03` tax/display policy and `CORE-OD-04` precision/rounding policy within qualified constraints. The Owner separately supplies exact Product/Variant Prices, effective periods and scopes. Qualified input does not choose commercial Prices or implementation.

### 5.4 Gate B-only representation questions

Physical numeric types, storage, effective-interval enforcement, uniqueness/overlap control, transaction/isolation, locking, quote tokens, snapshot columns, APIs and error mapping remain later Gate B design concerns. None can compensate for absent policy or commercial evidence.

## 6. Closure plan and readiness

| Blocker | Closure condition | Responsible authority category |
|---|---|---|
| Final Variant set absent | Owner confirms applicable persisted Variant choices/capacities for all 28 Products. | Owner commercial input |
| Exact Price dataset absent | Owner supplies exact VND Price for every confirmed sellable Variant, with scope and effective period. | Owner commercial input |
| Tax treatment/display unresolved | Qualified opinion is recorded for actual facts; Owner decides `CORE-OD-03`. | Qualified Tax/Accounting input, then Owner |
| Precision/rounding unresolved | Qualified constraints are recorded; Owner decides `CORE-OD-04`. | Qualified Tax/Accounting input, then Owner |
| Canonical transcription not frozen | Approved Product/Variant/Price dataset is reconciled without treating artifact labels as canonical codes. | Owner plus later technical design |

**Readiness conclusion:** `NOT_READY_FOR_OWNER_GATE_A_REVIEW — COMMERCIAL_AND_QUALIFIED_INPUT_BLOCKED`.

The repository search is exhausted for the present baseline. No approved menu selection is reopened, no Price is invented, and no Gate or implementation authority is granted.
