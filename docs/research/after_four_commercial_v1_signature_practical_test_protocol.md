# AFTER FOUR — Commercial V1 Signature Product Practical Test Protocol

**Prepared:** 2026-11-24 (Asia/Tokyo)

**Status:** `PLANNED — OWNER_REVIEW_REQUIRED`

**Scope:** Cà phê muối — Một cỡ; Trà đào cam sả — S/M/L. Bơ xay dừa non remains a research gap only.

## 1. Authority and test governance

This protocol converts public source formulations into controlled test records. It approves no Recipe, BOM, Ingredient, serving capacity, yield, waste/remake rate, packaging, supplier, cost, or commercial release.

Allowed test statuses are `PLANNED`, `IN_PROGRESS`, `TESTED`, `OWNER_REVIEW_REQUIRED`, and `REJECTED`. Every run must identify tester, date, equipment, exact Ingredient specification, parent source, and every departure from that source. Different source Recipes and controlled variations remain separate candidates and are never silently averaged. Experimental results are evidence for later review, not Owner approval. No candidate enters the costing BOM until separately reviewed and approved.

| Test identity field | Entry |
|---|---|
| Product |  |
| Approved Commercial V1 Variant |  |
| Candidate/test-run ID |  |
| Parent source/track |  |
| Test status | `PLANNED` / `IN_PROGRESS` / `TESTED` / `OWNER_REVIEW_REQUIRED` / `REJECTED` |
| Tester |  |
| Test date/time |  |
| Branch/test location |  |
| Source formulation URL/reference |  |
| Explicit changes from parent source |  |

### 1.1 Commercial V1 costing execution pack

This protocol is the execution index for the existing canonical data-capture files. It does not replace the source-specific controls in §§2–10.

| Workstream | Canonical capture file | Coverage and use |
|---|---|---|
| MAKE measurement | [Commercial V1 MAKE Recipe/BOM input](../architecture/after_four_commercial_v1_make_recipe_bom_input.csv) | 24 `MAKE_IN_HOUSE` Products / 48 priced combinations. Each row is one exact Product/Variant measurement starting point. Duplicate a row for each actual Ingredient or controlled run, retain its Product/Variant/Price identity, leave `measurement_line_reference` blank until real evidence exists, and then assign a traceable reference. S/M/L rows remain independent; never copy or linearly scale measurements. |
| BUY procurement | [Commercial V1 BUY finished-product procurement input](../architecture/after_four_commercial_v1_buy_finished_procurement_input.csv) | Four `BUY_FINISHED` Products / four combinations. Records exact finished-product specification, purchase unit, supplier documents, quotation versus actual purchase evidence, delivery, handling, saleable portions and measured loss. No listed supplier or public price becomes an approved supplier, quotation or purchase cost. |
| Cost and margin reconciliation | [Commercial V1 costing input](../architecture/after_four_commercial_v1_costing_input.csv) | All 28 Products / 52 priced combinations. The initial row for every combination is a blank reconciliation row. Add separately evidenced direct-cost lines only when the Ingredient/finished-product identity, quantity, unit, source and applicable allocation are known. A blank is never zero or free. |

All actual measurements, purchase evidence, unit costs and margins remain blank. Status values such as `MISSING_INPUT`, `INPUT_CONFIRMATION_REQUIRED`, `NOT_APPLICABLE`, `BLOCKED_INGREDIENT_IDENTITY`, and `NOT_CALCULABLE_MISSING_EVIDENCE` describe evidence state only. They are not measurements or commercial approvals.

### 1.2 Execution order and parallelism

1. Start with actual Ingredient/SKU, equipment and vessel identification. This can proceed independently for every unblocked Product and does not approve a Recipe or supplier.
2. Run the already bounded Cà phê muối tracks `CM-R04-01` and `CM-R05-01` independently once their actual inputs, equipment and vessel are identified.
3. Run one Owner-prioritized Trà đào cam sả size under `R12`; run its corresponding `R13` record only after the missing tea identity, dose and brewing basis is explicitly recorded. Retain all six S/M/L records for later independent testing.
4. Capture shared Ingredient purchase documents once per exact SKU/package and reference that evidence from each affected Product/Variant. Shared evidence does not create a shared Recipe quantity or allocation.
5. Measure each S/M/L Variant independently. Shared batch preparation may reduce repeated work only when the actual batch, output, allocation and loss are all measured and retained.
6. Run the four BUY procurement evidence rows in parallel. Public listings remain candidate leads; supplier contact, RFQ, quotation acceptance and purchase require separate authority.
7. Keep Bơ xay dừa non blocked until the actual young-coconut Ingredient identity is resolved. This blocker does not stop unrelated Product measurement.

For the remaining MAKE Products, the first executable action is to record the actual Ingredient specifications and a controlled test basis in the MAKE matrix. Public formulations may guide test planning but do not make a Product costable. No cost calculation may proceed from a reference formulation alone.

## 2. Cà phê muối — independent benchmark tracks

Sources and limitations are documented in [Recipe Research §3.3](after_four_commercial_v1_recipe_quantity_research.md#33-cà-phê-muối--một-cỡ). Track A and Track B have different foam denominators and must not be merged.

### 2.1 Track A — R04 benchmark

| Source-supported input or method | Benchmark value | Test treatment |
|---|---|---|
| Coffee | 20 g Vietnamese robusta | Preserve; exact SKU/roast/grind remains `OWNER_INPUT_REQUIRED`. |
| Brew water | 100 ml at 90–96°C | Preserve source range; record actual temperature. |
| Measured coffee output | Source reports about 80 ml | Measure every run; source value is not actual AFTER FOUR yield. |
| Condensed milk | 20 ml | Preserve; exact Ingredient specification required. |
| Foam whipping cream | 60 ml | Preserve as the salt denominator. |
| Salt | 0.75–1.5 g fine sea salt | Each selected mass is a controlled variant of R04, not a new source Recipe; do not select a final value here. |
| Ice | Glass two-thirds full | Source has no mass; record actual ice mass and vessel capacity. |
| Extraction time | Not established in retained source evidence | `TO_BE_MEASURED`; do not invent. |

### 2.2 Track B — R05 benchmark

| Source-supported input or method | Benchmark value | Test treatment |
|---|---|---|
| Coffee | 20 g phin coffee | Preserve; exact SKU/roast/grind remains `OWNER_INPUT_REQUIRED`. |
| Brew water | 80 ml at 92–96°C | Preserve source range; record actual temperature. |
| Condensed milk in coffee | 15–20 ml | Each selected quantity is a controlled R05 variant; do not select a final value here. |
| Foam cream | 50 ml | Preserve independently. |
| Foam fresh milk | 20 ml | Preserve independently. |
| Foam condensed milk | 10 ml | Preserve independently. |
| Foam salt | Approximately 0.5 g | Preserve as approximate source evidence and record actual weighed mass. |
| Ice | Full glass | Source has no mass; record actual ice mass and vessel capacity. |
| Optional cocoa | Pinch | Optional and unquantified; exclude unless separately recorded as `OWNER_INPUT_REQUIRED`. |
| Extraction time and coffee output | Not established in retained source evidence | `TO_BE_MEASURED`; do not invent. |

### 2.3 Cà phê muối required measurements

For every run record coffee specification/dose, brew-water input, actual temperature and extraction time, measured coffee output, condensed milk, every foam Ingredient, salt mass, ice mass, vessel capacity, foam output/leftover, finished mass/volume, sensory result, and repeatability. R04 and R05 salt results must always be interpreted with their parent foam composition.

## 3. Trà đào cam sả — independent benchmark tracks

Sources and limitations are documented in [Recipe Research §3.2](after_four_commercial_v1_recipe_quantity_research.md#32-trà-đào-cam-sả--sml). Source formulation quantities remain unchanged below.

### 3.1 Track A — R12 benchmark

| Source-supported input or method | Benchmark value | Test treatment |
|---|---|---|
| Tea-base preparation | 4 g black tea; 250 ml water; 95°C; 5 minutes; source says enough for two glasses | Preserve batch inputs. Measure actual filtered output. `4 g ÷ 2 = 2 g/glass` is only `RESEARCH_DERIVED_PROPOSAL`, not measured extraction yield. |
| Tea base used | 120 ml per stated 500 ml glass | Preserve for the source benchmark. |
| Orange juice | 40 ml | Record input fruit/specification and actual juice used separately. |
| Peach-preserving liquid | 30 ml | Keep separate from peach pieces. |
| Peach pieces | 2–3 pieces | Source gives no mass; record count and measured mass. |
| Sugar syrup | 15–20 ml | Each selected amount is a controlled R12 variant. |
| Lemongrass | One bruised stalk | Source gives no mass; record actual mass and preparation. |
| Lime juice | 5 ml | Preserve. |
| Ice | Glass full | Source gives no mass; measure actual ice. |

### 3.2 Track B — R13 benchmark

| Source-supported input or method | Benchmark value | Test treatment |
|---|---|---|
| Tea type/dry mass/base preparation | Missing from source | `OWNER_INPUT_REQUIRED` / `TO_BE_MEASURED`; do not invent a dose or import R12's base silently. |
| Tea base used | 150 ml per stated 500 ml glass | Preserve for the source benchmark once a separately recorded test base exists. |
| Peach liquid | 20 ml | Keep separate from peach slices. |
| Orange juice | 25–30 ml | Each selected amount is a controlled R13 variant. |
| Sugar syrup | 15–20 ml | Each selected amount is a controlled R13 variant. |
| Peach slices | 2–3 slices | Source gives no mass; record count and measured mass. |
| Lemongrass | One bruised stalk | Source gives no mass; record actual mass and preparation. |
| Ice | Full glass | Source gives no mass; measure actual ice. |
| Lime juice | Not specified by R13 | Do not add unless recorded as an explicit test variation. |

R14 remains batch-comparison evidence only: its stated batch inputs must not be divided by three or treated as measured per-serving quantities because finished batch yield and allocation are unverified.

### 3.3 Trà đào cam sả required measurements

For every run record exact tea SKU/type and dry mass; brewing water, temperature and time; filtered tea-base output; orange input and juice output; peach fruit and preserving liquid separately; lemongrass mass/preparation; syrup; R12 lime juice where applicable; ice mass; vessel capacity; finished mass/volume; leftover base and losses; sensory result; and repeatability. Any changed quantity creates an explicitly named test variant.

## 4. Variant and vessel boundary

Commercial V1 retains S/M/L for Trà đào cam sả, but no approved vessel capacity or scaling rule exists. Do not linearly scale either 500 ml benchmark. Create a separate blank test record for each intended S, M, and L run; keep vessel capacity `OWNER_INPUT_REQUIRED` until supplied and approved. Cà phê muối remains `Một cỡ`; this protocol creates no new sellable Variant.

| Product | Intended Variant | Vessel identity/capacity | Parent source track | Status |
|---|---|---|---|---|
| Cà phê muối | Một cỡ | `OWNER_INPUT_REQUIRED` | R04 / R05 | `PLANNED` |
| Trà đào cam sả | S | `OWNER_INPUT_REQUIRED` | R12 | `PLANNED` |
| Trà đào cam sả | S | `OWNER_INPUT_REQUIRED` | R13 | `PLANNED` |
| Trà đào cam sả | M | `OWNER_INPUT_REQUIRED` | R12 | `PLANNED` |
| Trà đào cam sả | M | `OWNER_INPUT_REQUIRED` | R13 | `PLANNED` |
| Trà đào cam sả | L | `OWNER_INPUT_REQUIRED` | R12 | `PLANNED` |
| Trà đào cam sả | L | `OWNER_INPUT_REQUIRED` | R13 | `PLANNED` |

## 5. Field execution records

These records are for physical data capture. Source formulations remain benchmarks, not approved AFTER FOUR Recipes. All cells under actual measurement, test identity, sensory observation, and Owner disposition are intentionally blank until the field session. A completed record must retain its Run ID and parent track; never combine R04 with R05 or R12 with R13.

### 5.1 Cà phê muối — independent R04 and R05 records

Salt must be evaluated only with its complete parent foam composition. Do not compare or transfer a salt result independently of the R04 or R05 foam system.

| Run ID | Parent track | Exact source formulation retained | Ingredient identity and actual SKU/brand | Actual weighed/measured quantities | Equipment and preparation settings | Coffee input and extracted output | Foam composition and foam output | Ice quantity | Vessel identity and measured capacity | Final serving output | Preparation time | Waste/loss | Sensory observations | Tester / date / repeat number | Owner disposition |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| `CM-R04-01` | R04 | 20 g Vietnamese robusta; 100 ml water at 90–96°C; about 80 ml reported brew output; 20 ml condensed milk; foam of 60 ml whipping cream plus 0.75–1.5 g fine sea salt; glass two-thirds full of ice. |  |  |  |  |  |  |  |  |  |  |  |  |  |
| `CM-R05-01` | R05 | 20 g phin coffee; 80 ml water at 92–96°C; 15–20 ml condensed milk; foam of 50 ml cream, 20 ml fresh milk, 10 ml condensed milk and approximately 0.5 g salt; full glass ice; optional unquantified cocoa pinch. |  |  |  |  |  |  |  |  |  |  |  |  |  |

If another salt or condensed-milk value inside a published range is tested, assign a distinct repeat/candidate identifier and record the selected source-range value. Do not overwrite the parent record.

### 5.2 Trà đào cam sả — six independent size/source records

The six records remain available for staged testing. The Owner may prioritize one actual serving size for the first session; testing all six records in that session is not required. Deferring the other sizes does not approve scaling. Each later size remains an independent record with `OWNER_INPUT_REQUIRED` vessel capacity.

| Run ID | Intended Variant | Parent track | Exact source formulation retained | First-round selection | Tea identity/SKU, dose and brewing parameters | Actual filtered tea output | Peach liquid and peach Ingredient specification/quantity | Orange quantity | Lime quantity | Lemongrass identity/quantity | Syrup identity/quantity | Ice mass | Vessel identity/measured capacity | Final output/loss | Preparation time | Sensory observations | Tester/date/repeat number | Owner disposition |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| `TDCS-S-R12-01` | S | R12 | Source 500 ml benchmark: tea base from 4 g black tea in 250 ml water at 95°C for 5 minutes, stated as enough for two glasses; 120 ml tea base; 40 ml orange juice; 30 ml peach-preserving liquid; 2–3 peach pieces; 15–20 ml sugar syrup; one bruised lemongrass stalk; 5 ml lime juice; glass full of ice. No S scaling is implied. |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| `TDCS-S-R13-01` | S | R13 | Source 500 ml benchmark: 150 ml tea base; 20 ml peach liquid; 25–30 ml orange juice; 15–20 ml sugar syrup; 2–3 peach slices; one bruised lemongrass stalk; full glass ice. Tea identity, dry dose and brewing method are absent from the source and remain blank pending explicit input; no R12 value or S scaling is implied. |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| `TDCS-M-R12-01` | M | R12 | Source 500 ml benchmark: tea base from 4 g black tea in 250 ml water at 95°C for 5 minutes, stated as enough for two glasses; 120 ml tea base; 40 ml orange juice; 30 ml peach-preserving liquid; 2–3 peach pieces; 15–20 ml sugar syrup; one bruised lemongrass stalk; 5 ml lime juice; glass full of ice. No M scaling is implied. |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| `TDCS-M-R13-01` | M | R13 | Source 500 ml benchmark: 150 ml tea base; 20 ml peach liquid; 25–30 ml orange juice; 15–20 ml sugar syrup; 2–3 peach slices; one bruised lemongrass stalk; full glass ice. Tea identity, dry dose and brewing method are absent from the source and remain blank pending explicit input; no R12 value or M scaling is implied. |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| `TDCS-L-R12-01` | L | R12 | Source 500 ml benchmark: tea base from 4 g black tea in 250 ml water at 95°C for 5 minutes, stated as enough for two glasses; 120 ml tea base; 40 ml orange juice; 30 ml peach-preserving liquid; 2–3 peach pieces; 15–20 ml sugar syrup; one bruised lemongrass stalk; 5 ml lime juice; glass full of ice. No L scaling is implied. |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| `TDCS-L-R13-01` | L | R13 | Source 500 ml benchmark: 150 ml tea base; 20 ml peach liquid; 25–30 ml orange juice; 15–20 ml sugar syrup; 2–3 peach slices; one bruised lemongrass stalk; full glass ice. Tea identity, dry dose and brewing method are absent from the source and remain blank pending explicit input; no R12 value or L scaling is implied. |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |

For every R13 record, the tea identity, dry dose, water, temperature, time, and preparation method remain blank until measured under an explicitly identified trial basis or separately decided. R12 values must never be copied into R13 silently.

## 6. Supplementary practical measurement worksheet

Duplicate the following rows for every Ingredient and every run. Blank cells must remain blank until measured or supplied; use `TO_BE_MEASURED` or `OWNER_INPUT_REQUIRED` rather than invented values.

### 6.1 Ingredient inputs

| Run ID | Ingredient/component | Function (main/topping/garnish/optional) | Exact specification/SKU | Preparation state | Source quantity/unit | Actual quantity/unit | Evidence/classification | Notes |
|---|---|---|---|---|---|---|---|---|
|  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |

### 6.2 Equipment and settings

| Run ID | Equipment | Make/model or specification | Setting | Temperature | Time | Calibration/check evidence | Notes |
|---|---|---|---|---|---|---|---|
|  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |

### 6.3 Batch/component preparation

| Run ID | Component | Inputs/reference | Start mass/volume | Filtered/usable output | Leftover/loss | Number of intended servings | Allocation basis | Notes |
|---|---|---|---|---|---|---|---|---|
|  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |

### 6.4 Ice, vessel, finished output, and loss

| Run ID | Ice mass | Vessel identity | Vessel capacity | Finished mass | Finished volume | Foam/component output | Leftover/loss | Measurement method |
|---|---|---|---|---|---|---|---|---|
|  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |

### 6.5 Sensory evaluation and acceptance fields

No numerical sensory threshold is approved. Where a target is required, record `OWNER_INPUT_REQUIRED`.

| Run ID | Flavor balance | Coffee/tea strength | Sweetness | Salt perception | Citrus/peach/lemongrass balance | Texture/foam stability | Appearance | Serving consistency | Owner/operator target or observation |
|---|---|---|---|---|---|---|---|---|---|
|  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |

### 6.6 Repeat comparison and operator observations

| Candidate ID | Run IDs compared | Variables held constant | Variables changed | Output variance | Sensory variance | Repeatability observation | Operator notes |
|---|---|---|---|---|---|---|---|
|  |  |  |  |  |  |  |  |

### 6.7 Owner disposition record

| Candidate ID | Current test status | Owner disposition | Decision date | Rationale/conditions | Further evidence/test required | Costing-BOM admission separately approved? |
|---|---|---|---|---|---|---|
|  | `OWNER_REVIEW_REQUIRED` |  |  |  |  | No |

## 7. First-round input readiness

| Input class | Required for the first practical round | Boundary |
|---|---|---|
| Owner must identify or approve | Actual Ingredient identities/SKUs to test; available equipment; the actual serving vessel for Cà phê muối; one prioritized Trà đào cam sả serving size and its actual vessel; whether an R13 tea-base trial may proceed and, if so, its explicitly recorded trial basis; which values inside published source ranges will be run first. | This selects test inputs only. It does not approve an Ingredient, Recipe, BOM, supplier, or commercial standard. |
| Physically measurable during the test | Ingredient masses/volumes; water temperature and time; extracted/filtered output; foam output; fruit/peach/lemongrass mass; ice mass; measured vessel capacity; finished output; preparation time; leftovers/loss; repeatability and sensory observations. | Measurements are test evidence, not approved Recipe or costing inputs. |
| Supplier/document evidence required | SKU label/specification, package/unit evidence, lot or best-before information where available, and provenance for each actual Ingredient used. | Accepted quotation, invoice, landed cost, supplier approval, tax evidence, and purchase terms are not prerequisites for a bounded sensory/yield test, but remain required before evidence-backed costing or procurement approval. |
| Not yet needed for the first practical round | Remaining Trà đào cam sả sizes not selected for the first session; approved S/M/L scaling; Dine-in/Takeaway packaging allocation; waste/remake policy; purchase price; unit cost; gross margin; tax and rounding treatment. | Deferral must not be interpreted as approval or as permission to copy the first-size result to another Variant. |

Practical testing remains blocked only where the selected first-round run lacks an identifiable Ingredient, usable equipment, a measurable vessel, safe handling information, or an explicit trial basis for a source gap such as R13 tea preparation. Future S/M/L work does not block R04/R05 or one accurately bounded first-size R12/R13 comparison.

## 8. Minimum first-round execution sequence

1. Confirm the actual Ingredient SKUs/specifications and equipment available for the session; record documentary labels and unresolved substitutions.
2. Identify and measure the actual vessels, including the one Owner-prioritized Trà đào cam sả serving size. Do not infer capacities from S/M/L labels.
3. Run R04 and R05 independently with their complete parent formulations and separate records; do not compare salt outside its foam system.
4. Run R12 and R13 independently at the Owner-selected first serving size. R13 may proceed only with its tea-base trial basis explicitly recorded; do not import R12's tea dose or brewing method.
5. Record outputs, losses, preparation times, sensory observations, and repeat identity; identify which candidates merit a controlled repeat without selecting a winner.
6. Defer the remaining tea sizes until the first-round evidence has been reviewed. No scaling or cross-size adoption follows automatically.

## 9. Ingredient purchasing boundary

Candidate supplier references come only from the existing [external Ingredient/supplier research](after_four_commercial_v1_external_ingredient_supplier_research.md). They are leads, not selected suppliers or SKUs; public prices are not purchase costs.

- Cà phê muối: `SRC-01` and `SRC-17` are generic coffee/dairy category leads. Before testing, select exact coffee, condensed milk, whipping cream, fresh milk where Track B applies, salt, and ice/water specifications.
- Trà đào cam sả: `SRC-03/04/05/06/08/09/10/11` are candidate tea/peach/syrup leads. Before testing, select exact black tea, preserved peach/peach liquid, orange, lemongrass, sugar syrup, lime for R12, and water/ice specifications.

Do not contact suppliers, send RFQs, select a supplier, or treat a public listing as actual cost under this protocol.

## 10. Bơ xay dừa non — research gap blocker

Bơ xay dừa non is excluded from this protocol's test execution. No test worksheet, Recipe, or quantity is authorized for it. R18 is an avocado/coconut-syrup/ice-cream comparator; R19 is an avocado/strawberry comparator. Neither establishes young-coconut identity or quantity.

Before a future protocol can be designed, evidence must define whether young coconut means flesh, coconut water, both, or a specified purchased preparation; the exact Ingredient specification and availability; and the intended flavor, texture, sweetness, ice, and serving characteristics. These are missing inputs, not decisions made by this document.

## 11. Completion and governance boundary

A test is complete only when its source identity, exact inputs, equipment/settings, actual output/loss, sensory observations, repeat result, and unresolved deviations are recorded. `TESTED` does not mean approved. Owner review and separate Recipe/BOM admission remain mandatory.

This protocol performs no unit-cost or gross-margin calculation and creates no Owner decision, canonical ODB ID, supplier selection, purchase, disclosure, Gate A/B/C, implementation authorization, FOA, or Production Authorization. It changes no Product, Variant, Price, tax, rounding, schema, migration, database, API, code, or runtime behavior.
