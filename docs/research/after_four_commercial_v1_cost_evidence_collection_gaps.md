# AFTER FOUR — Commercial V1 Cost Evidence Collection Gaps

**Assessment date:** 2026-11-24 (Asia/Tokyo)

**Baseline:** 28 approved Products, 52 priced Product/Variant combinations, and confirmed 24 MAKE / 4 BUY allocation.

**Purpose:** Smallest evidence set required for defensible unit costing; not a readiness or implementation authorization report.

## 1. Verified coverage

| Artifact | Coverage | Current evidence result |
|---|---|---|
| [Buy-vs-Make input](../architecture/after_four_commercial_v1_buy_vs_make_owner_input.csv) | 28 Products: 24 `MAKE_IN_HOUSE`, 4 `BUY_FINISHED`, 0 deferred | Allocation is Owner-confirmed; Recipe, supplier, and cost inputs remain blank. |
| [MAKE Recipe/BOM input](../architecture/after_four_commercial_v1_make_recipe_bom_input.csv) | 24 Products / 48 approved combinations | All Recipe approval states are `MISSING_INPUT_NOT_OWNER_APPROVED`. |
| [BUY procurement input](../architecture/after_four_commercial_v1_buy_finished_procurement_input.csv) | 4 Products / 4 combinations | All rows are `MISSING_INPUT`. Public leads are not finished-product procurement proof. |
| [Canonical costing input](../architecture/after_four_commercial_v1_costing_input.csv) | 28 Products / 52 unique priced combinations | All 52 are `MISSING_INPUT`; 0/52 have calculable unit cost or gross margin. |

The current templates already support repeated ingredient lines, per-Variant quantities, purchase/preparation unit conversion, yield/waste, channel packaging, procurement evidence, landed cost, and source dates. No CSV column change is required.

## 2. Smallest missing evidence — MAKE_IN_HOUSE

For each of the 48 MAKE combinations, evidence is sufficient only when all applicable rows below are closed.

| Evidence required | Owner can provide/approve directly | Supplier/document response required |
|---|---|---|
| Approved Recipe/BOM | Exact ingredient or approved substitute; quantity and preparation unit per Variant; reusable component allocation | None unless the Recipe relies on a supplier specification. |
| Purchase identity and price | Accept or reject the exact commercial ingredient specification | Exact SKU/package, purchase quantity/unit, accepted quotation or invoice/actual price, currency, stated tax, discount, delivery, and effective date. |
| Unit conversion | Approve operational preparation unit and Recipe usage | Package/net-content evidence needed to support purchase-to-preparation conversion. |
| Yield and batch allocation | Owner may approve a clearly labelled planning assumption for planning-only costing; it is not a measured operational result. Actual batch size, measured usable output, measured waste/remake, and allocation basis must retain their evidence class. | Supplier-provided yield/specification may be recorded as supplier evidence only; it is not an AFTER FOUR measured result. |
| Packaging | Dine-in and Takeaway packaging identity, quantity, and allocation per Variant | Accepted packaging quote/invoice, pack size, delivery and actual price. |

Existing public research supplies candidate leads only. It establishes no Owner-approved BOM, accepted quotation, invoice, actual purchase cost, approved yield/waste, or approved packaging allocation. See [External Research §§2.1, 8 and 10](after_four_commercial_v1_external_ingredient_supplier_research.md#21-evidence-classifications).

## 3. Smallest missing evidence — BUY_FINISHED

This applies independently to Bánh croissant, Cheesecake, Brownie chocolate, and Muffin.

| Evidence required | Owner can provide/approve directly | Supplier response/document required |
|---|---|---|
| Finished-product specification | Acceptance specification and whether the item is procured finished; no bake-off inference | Exact offered product/SKU and conformance evidence. |
| Commercial unit | Accept purchase/serving relationship | Purchase unit, pack size, unit conversion and MOQ. |
| Price and landed cost | Accept quotation | Supplier, accepted quotation or invoice, actual purchase price, discount, delivery to first Branch, currency and effective date. |
| Tax and handling | Approve operational handling after evidence; no tax/accounting treatment is inferred. | Record VAT/tax information exactly as shown by quotation/invoice, plus storage, shelf life and delivery conditions. Documentary VAT text does not establish applicability or accounting treatment. |
| Waste and packaging | Approved waste assumption and Dine-in/Takeaway packaging allocation | Supplier shelf-life/packaging facts and packaging quote where applicable. |

The retained source IDs are component/category leads only and do not establish a finished-product supplier, accepted terms, or actual purchase cost.

## 4. Evidence classifications and calculation threshold

- `OWNER_APPROVED_PLANNING_ASSUMPTION`: an explicit Owner-approved value usable only for the stated planning purpose. It is not an observed yield, waste, remake, or actual cost.
- `MEASURED_OPERATIONAL_RESULT`: a dated, traceable result measured from AFTER FOUR preparation/handling under a stated Product/Variant, batch, and method.
- `SUPPLIER_SPECIFICATION`: a supplier-stated property retained with its source/date. It is not an AFTER FOUR measured result.

### Planning cost estimate

An `OWNER_APPROVED_PLANNING_ASSUMPTION` may support only the purpose explicitly approved by the Owner. Any resulting calculation must be labelled `ESTIMATE`, state every assumption and missing evidence, and state its permitted use. It is not actual purchase cost, a measured operational result, or an evidence-backed unit cost. A planning estimate alone does not establish a commercially authoritative margin.

### Evidence-backed unit cost

Evidence-backed unit cost may be recorded only when the complete required cost path has: evidenced ingredient identity and purchase SKU/package; documentary purchase-to-preparation conversion; Owner-approved Recipe/BOM quantity for the exact Product/Variant; properly classified and supported yield/waste/remake evidence; explicit shared/batch allocation basis; channel-correct packaging identity, quantity, and allocation; and supported purchase/landed cost. A BUY_FINISHED row additionally requires an approved finished-product specification and actual purchase/landed-cost evidence. Planning assumptions do not automatically replace any of these required evidence elements.

### Gross margin

Gross margin may be calculated only from a cost basis suitable for the stated margin purpose. No authoritative or evidence-backed gross margin may be recorded while a required cost component is missing. A planning cost estimate cannot be presented as actual gross margin. Any future planning margin estimate must be separately labelled `ESTIMATE`, identify its Owner-approved purpose and basis, disclose assumptions and gaps, and must not replace actual margin.

Public listing prices, unapproved planning assumptions, supplier specifications presented as operational results, and missing components are not actual cost.

VAT/tax information may be copied exactly from a quotation, invoice, or other source as documentary evidence. It does not decide tax applicability, tax treatment, accounting treatment, monetary precision, or rounding. `CORE-OD-03` and `CORE-OD-04` remain deferred, and qualified Accounting/Tax input remains required for professional conclusions.

## 5. Collection sequence

1. Owner/culinary closes Product/Variant Recipe or finished-product specification first.
2. Owner records ingredient/substitute, serving/batch, correctly classified yield/waste/remake evidence, and channel-packaging choices in the existing MAKE/BUY templates.
3. Only after explicit authorization, obtain supplier evidence for the exact approved specifications; public listing prices remain separate from accepted quotations and actual purchase costs.
4. Record conversions and effective dates from documentary evidence.
5. Copy evidence-backed lines into the canonical 52-combination costing CSV and calculate unit cost only when every required component is supported.

No supplier was contacted, no RFQ was sent, and no cost or margin was fabricated. Approved selling prices, Product/Variant identities, `CORE-OD-18`, `ODB-CAT-07`, tax/rounding deferrals, and all Gate/implementation boundaries remain unchanged.
