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
| Trà đào cam sả | S | `OWNER_INPUT_REQUIRED` | R12 / R13 | `PLANNED` |
| Trà đào cam sả | M | `OWNER_INPUT_REQUIRED` | R12 / R13 | `PLANNED` |
| Trà đào cam sả | L | `OWNER_INPUT_REQUIRED` | R12 / R13 | `PLANNED` |

## 5. Practical measurement worksheet

Duplicate the following rows for every Ingredient and every run. Blank cells must remain blank until measured or supplied; use `TO_BE_MEASURED` or `OWNER_INPUT_REQUIRED` rather than invented values.

### 5.1 Ingredient inputs

| Run ID | Ingredient/component | Function (main/topping/garnish/optional) | Exact specification/SKU | Preparation state | Source quantity/unit | Actual quantity/unit | Evidence/classification | Notes |
|---|---|---|---|---|---|---|---|---|
|  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |

### 5.2 Equipment and settings

| Run ID | Equipment | Make/model or specification | Setting | Temperature | Time | Calibration/check evidence | Notes |
|---|---|---|---|---|---|---|---|
|  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |

### 5.3 Batch/component preparation

| Run ID | Component | Inputs/reference | Start mass/volume | Filtered/usable output | Leftover/loss | Number of intended servings | Allocation basis | Notes |
|---|---|---|---|---|---|---|---|---|
|  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |

### 5.4 Ice, vessel, finished output, and loss

| Run ID | Ice mass | Vessel identity | Vessel capacity | Finished mass | Finished volume | Foam/component output | Leftover/loss | Measurement method |
|---|---|---|---|---|---|---|---|---|
|  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |

### 5.5 Sensory evaluation and acceptance fields

No numerical sensory threshold is approved. Where a target is required, record `OWNER_INPUT_REQUIRED`.

| Run ID | Flavor balance | Coffee/tea strength | Sweetness | Salt perception | Citrus/peach/lemongrass balance | Texture/foam stability | Appearance | Serving consistency | Owner/operator target or observation |
|---|---|---|---|---|---|---|---|---|---|
|  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |

### 5.6 Repeat comparison and operator observations

| Candidate ID | Run IDs compared | Variables held constant | Variables changed | Output variance | Sensory variance | Repeatability observation | Operator notes |
|---|---|---|---|---|---|---|---|
|  |  |  |  |  |  |  |  |

### 5.7 Owner disposition record

| Candidate ID | Current test status | Owner disposition | Decision date | Rationale/conditions | Further evidence/test required | Costing-BOM admission separately approved? |
|---|---|---|---|---|---|---|
|  | `OWNER_REVIEW_REQUIRED` |  |  |  |  | No |

## 6. Ingredient purchasing boundary

Candidate supplier references come only from the existing [external Ingredient/supplier research](after_four_commercial_v1_external_ingredient_supplier_research.md). They are leads, not selected suppliers or SKUs; public prices are not purchase costs.

- Cà phê muối: `SRC-01` and `SRC-17` are generic coffee/dairy category leads. Before testing, select exact coffee, condensed milk, whipping cream, fresh milk where Track B applies, salt, and ice/water specifications.
- Trà đào cam sả: `SRC-03/04/05/06/08/09/10/11` are candidate tea/peach/syrup leads. Before testing, select exact black tea, preserved peach/peach liquid, orange, lemongrass, sugar syrup, lime for R12, and water/ice specifications.

Do not contact suppliers, send RFQs, select a supplier, or treat a public listing as actual cost under this protocol.

## 7. Bơ xay dừa non — research gap blocker

No test Recipe or quantity is authorized. R18 is an avocado/coconut-syrup/ice-cream comparator; R19 is an avocado/strawberry comparator. Neither establishes young-coconut identity or quantity.

Before a future protocol can be designed, evidence must define whether young coconut means flesh, coconut water, both, or a specified purchased preparation; the exact Ingredient specification and availability; and the intended flavor, texture, sweetness, ice, and serving characteristics. These are missing inputs, not decisions made by this document.

## 8. Completion and governance boundary

A test is complete only when its source identity, exact inputs, equipment/settings, actual output/loss, sensory observations, repeat result, and unresolved deviations are recorded. `TESTED` does not mean approved. Owner review and separate Recipe/BOM admission remain mandatory.

This protocol performs no unit-cost or gross-margin calculation and creates no Owner decision, canonical ODB ID, supplier selection, purchase, disclosure, Gate A/B/C, implementation authorization, FOA, or Production Authorization. It changes no Product, Variant, Price, tax, rounding, schema, migration, database, API, code, or runtime behavior.
