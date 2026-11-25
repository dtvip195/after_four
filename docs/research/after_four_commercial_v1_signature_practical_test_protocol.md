# AFTER FOUR — Commercial V1 Signature Product Practical Test Protocol

**Prepared:** 2026-11-24; field-readiness synchronization updated 2026-11-25 (Asia/Tokyo)

**Status:** `PLANNED — OWNER_REVIEW_REQUIRED`

**Scope:** Cà phê muối — Một cỡ; Trà đào cam sả — S/M/L; one unassigned-Variant Bơ xay dừa non R36 benchmark. The R36 benchmark does not establish S/M/L applicability.

## 1. Authority and test governance

This protocol converts public source formulations into controlled test records. It approves no Recipe, BOM, Ingredient, serving capacity, yield, waste/remake rate, packaging, supplier, cost, or commercial release.

Allowed test statuses are `PLANNED`, `IN_PROGRESS`, `TESTED`, `OWNER_REVIEW_REQUIRED`, and `REJECTED`. Every run must identify tester, date, equipment, exact Ingredient specification, parent source, and every departure from that source. Different source Recipes and controlled variations remain separate candidates and are never silently averaged. Experimental results are evidence for later review, not Owner approval. No candidate enters the costing BOM until separately reviewed and approved.

Dashboard readiness uses a separate vocabulary: `READY_FOR_OWNER_PREPARATION`, `BLOCKED_BY_MISSING_INPUT`, `READY_FOR_CONTROLLED_TRIAL`, `TRIAL_IN_PROGRESS`, `EVIDENCE_PENDING`, and `READY_FOR_OWNER_REVIEW`. A dashboard readiness value never substitutes for the test status or grants permission to purchase, execute, accept, or approve anything.

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

The costing input records quoted price and actual invoiced/purchased price as separate evidence classes, each with its own evidence type and source reference. A quotation never proves a purchase transaction. When all required inputs and the relevant selling-price basis are valid, `gross_margin_amount_vnd` records the VND difference produced by the stated calculation basis, while `gross_margin_percentage` records the separately identified percentage produced by that basis. `gross_margin_calculation_basis` must identify the exact selling-price and unit-cost inputs used. No amount or percentage may be calculated while either input is incomplete, and no VAT, tax, monetary precision, rounding, or accounting treatment may be inferred by this template.

#### 1.1.1 BUY acceptance field responsibility

The BUY input is the single acceptance and procurement capture artifact for Bánh croissant, Cheesecake, Brownie chocolate, and Muffin. Blank accepted-specification fields are intentional; public listing facts remain in their separately labelled public-evidence fields and never populate an accepted specification automatically.

| BUY field group | Required provider / evidence class | Boundary |
|---|---|---|
| `finished_product_specification`; accepted flavor/formulation, physical size/weight, and saleable portion | Owner input, supported by exact supplier document where applicable | Public identity, flavor, SKU, weight, or portion is a candidate only until the Owner accepts it. |
| Purchase quantity/unit, packaging configuration, pack size, conversion and MOQ | Supplier document; Owner accepts the purchase-to-sale relationship | A public retail pack does not establish an AFTER FOUR purchase unit or saleable portion. |
| Condition on receipt, storage, shelf life, required remaining shelf life, handling/preparation and traceability | Supplier document plus qualified food-safety input where applicability requires it; operator records actual receipt evidence | No threshold, temperature, expiry rule, bake-off workflow, or handling requirement is inferred. |
| Defect/rejection criteria | Owner input after supplier specification and qualified food-safety/operations input where required | No defect threshold or automatic rejection authority is created. |
| Public seller/provider, product identity, listed price/date/URL | `PUBLIC_RETAIL_LISTING_NOT_QUOTATION_OR_TRANSACTION` | The public seller/provider is not a verified supplier; a retail price is not a quote, transaction, wholesale price, or landed cost. |
| Verified supplier identity, accepted quotation, actual purchase price, delivery and landed-cost evidence | Supplier/transaction documents after separate contact and procurement authorization | These fields remain blank; this protocol authorizes no contact, RFQ, selection, acceptance, or purchase. |
| Quantity received, saleable portions, unsaleable quantity/reason and receipt evidence | Operator measurement/observation tied to the actual receipt | No sample receipt or loss value may be entered. |
| `acceptance_specification_status` | Owner records only after reviewing the complete evidence set | Blank does not mean accepted; current `verification_status` remains `MISSING_INPUT`. |

#### 1.1.2 Field-trial to costing evidence handoff

| Evidence class | Field-trial source | Costing destination | Boundary |
|---|---|---|---|
| Measured Ingredient quantity | Dated run/Ingredient line with actual SKU and unit | `preparation_quantity`, `preparation_unit`, Recipe/BOM evidence fields | A measurement is not an approved Recipe/BOM until separately admitted by the Owner. |
| Purchase unit and price | Package label plus quotation/invoice/transaction source | Purchase/package quantity, quoted-price or actual-price fields and their distinct evidence references | A public price or quotation is not an actual purchase. |
| Batch output and saleable portions | Batch/component and finished-output records | `batch_output_quantity`, allocation basis and unit-cost denominator | Retain actual run identity; never infer yield from nominal vessel capacity. |
| Waste, loss, rework or remake | Measured leftover/loss plus reason and repeat/run reference | Waste/remake evidence and allocation fields | Blank is unknown, not zero. A failed run is evidence, not an approved waste rate. |
| Dine-in/takeaway packaging | Exact packaging SKU and quantity recorded by channel | Separate dine-in and takeaway packaging fields | Shared packaging evidence may be referenced only when the exact SKU and quantity apply. |
| Owner selection or approval | Dated disposition record | Recipe/BOM status or accepted finished specification | Owner selection must remain distinct from measured facts and supplier documents. |
| Tax/accounting assumptions | Qualified evidence outside the field run | Tax information and calculation-basis fields | Remains unresolved; no tax, rounding or accounting treatment is inferred here. |

### 1.2 Execution order and parallelism

1. Start with actual Ingredient/SKU, equipment and vessel identification. This can proceed independently for every unblocked Product and does not approve a Recipe or supplier.
2. Run the already bounded Cà phê muối tracks `CM-R04-01` and `CM-R05-01` independently once their actual inputs, equipment and vessel are identified.
3. Run one Owner-prioritized Trà đào cam sả size under `R12`; run its corresponding `R13` record only after the missing tea identity, dose and brewing basis is explicitly recorded. Retain all six S/M/L records for later independent testing.
4. Capture shared Ingredient purchase documents once per exact SKU/package and reference that evidence from each affected Product/Variant. Shared evidence does not create a shared Recipe quantity or allocation.
5. Measure each S/M/L Variant independently. Shared batch preparation may reduce repeated work only when the actual batch, output, allocation and loss are all measured and retained.
6. Run the four BUY procurement evidence rows in parallel. Public listings remain candidate leads; supplier contact, RFQ, quotation acceptance and purchase require separate authority.
7. Prepare one R36 Bơ xay dừa non benchmark only after the actual avocado, frozen young-coconut flesh, dairy, syrup and ice inputs plus blender and vessel are identified. Keep S/M/L mapping blocked until separate measured evidence and Owner review.

The 2026-11-25 public-evidence delta is recorded as `CE-COM-015` through `CE-COM-018` in the [Comprehensive Evidence Register](after_four_comprehensive_evidence_register.csv). Shared dairy, tea, packaging, and BUY-product evidence may be referenced from multiple candidate assessments without copying or altering the original record. A shared source reference does not establish Product applicability, Recipe quantity, packaging assignment, quotation, transaction, or cost.

For the remaining MAKE Products, the first executable action is to record the actual Ingredient specifications and a controlled test basis in the MAKE matrix. Public formulations may guide test planning but do not make a Product costable. No cost calculation may proceed from a reference formulation alone.

### 1.3 Practical-test execution readiness

Every test remains unexecuted. `NOT_READY` below means the record is structurally usable but at least one real input must be supplied before physical execution; it is not a design or implementation status.

| Test ID | Product / Variant | Actual ingredients required | Equipment / vessel / measuring tools | Preparation and measurement procedure | Evidence and observations to retain | Missing-input categories | Earliest start condition / status |
|---|---|---|---|---|---|---|---|
| `CM-R04-01` | Cà phê muối / Một cỡ | Exact coffee, condensed milk, whipping cream, salt, water and ice identities/SKUs; use only retained R04 source quantities/ranges. | Operator-identified coffee and foam-preparation equipment; actual serving vessel; identified mass, volume, temperature and time measurement tools, with available check/calibration evidence recorded rather than assumed. | Record every input; actual water temperature/time; extracted coffee; complete foam output; ice; finished output; loss; preparation time; sensory observations and repeat identity. | Labels/SKUs and provenance; R04 source track; equipment/settings/check evidence; vessel identity/capacity; raw dated measurements; departures; tester and Owner disposition. | Owner: exact inputs and source-range values to test. Operator: equipment/vessel availability and measurement. Ingredient purchase: actual inputs. Supplier: label/package provenance where available. | Start only when all actual ingredients, usable equipment, measurable vessel and measurement tools are physically present and identified — `NOT_READY`. |
| `CM-R05-01` | Cà phê muối / Một cỡ | Exact coffee, condensed milk, cream, fresh milk, salt, water and ice identities/SKUs; optional cocoa excluded unless separately identified; retain R05 independently. | Operator-identified coffee and foam-preparation equipment; actual serving vessel; mass, volume, temperature and time measurement suitable for the recorded fields. | Record extraction and the complete R05 foam system independently; capture inputs, outputs, losses, time, sensory observations and repeat identity. | Same evidence classes as R04, retained under R05 without combining tracks or transferring a salt result. | Owner: exact inputs and source-range values. Operator/equipment: availability and checks. Ingredient purchase and supplier provenance: actual test materials. | Same physical-readiness threshold as R04; no repository evidence proves it is met — `NOT_READY`. |
| `TDCS-S-R12-01` | Trà đào cam sả / S | Exact tea, preserved peach/liquid, orange, syrup, lemongrass, lime, water and ice identities/SKUs; retained R12 quantities only, with no inferred S scaling. | Operator-identified tea/fruit preparation equipment; measured S vessel; mass, volume, temperature and time measurement suitable for the recorded fields. | Preserve R12 benchmark; measure brew inputs/output, each Product input, ice, vessel, finished output/loss, time, sensory result and repeat. | Ingredient/SKU provenance; brew/settings; actual vessel capacity; raw dated measurements; deviations; tester and disposition. | Owner: choose S as first size and identify inputs. Operator: equipment/vessel/tools. Ingredient purchase: actual inputs. Supplier: label/package evidence. | Start after Owner selects S and all inputs/equipment/measured vessel are available — `NOT_READY`. |
| `TDCS-M-R12-01` | Trà đào cam sả / M | Same R12 ingredient classes, exact identities/SKUs and retained source quantities; no S/M/L scaling. | Same functional equipment/tools, with an independently measured M vessel. | Run and record the complete R12 envelope independently for M. | Same R12 evidence classes, tied only to M. | Same categories as S; Owner must select M and operator must identify the M vessel. | Start after M is selected and its independent physical prerequisites are present — `NOT_READY`. |
| `TDCS-L-R12-01` | Trà đào cam sả / L | Same R12 ingredient classes, exact identities/SKUs and retained source quantities; no S/M/L scaling. | Same functional equipment/tools, with an independently measured L vessel. | Run and record the complete R12 envelope independently for L. | Same R12 evidence classes, tied only to L. | Same categories as S; Owner must select L and operator must identify the L vessel. | Start after L is selected and its independent physical prerequisites are present — `NOT_READY`. |
| `TDCS-S-R13-01` | Trà đào cam sả / S | Exact peach/liquid, orange, syrup, lemongrass, water and ice identities/SKUs plus an explicitly recorded R13 tea identity, dry dose, water, temperature, time and method; never import R12. | Operator-identified preparation equipment; measured S vessel; mass, volume, temperature and time measurement suitable for the recorded fields. | Prepare the separately identified R13 tea basis; measure every input/output/loss/time/sensory/repeat fact independently. | Explicit tea-base trial basis plus Ingredient/SKU, equipment, vessel, raw measurement, tester, deviation and disposition evidence. | Owner: select S and explicitly record the trial basis. Operator: equipment/vessel/tools. Ingredient purchase and supplier provenance. R13 tea basis remains missing. | Start only after the R13 tea basis is explicitly recorded and all S physical prerequisites are present — `NOT_READY`. |
| `TDCS-M-R13-01` | Trà đào cam sả / M | Same R13 ingredient and explicit tea-basis requirements; no cross-size scaling. | Same functional equipment/tools, with an independently measured M vessel. | Run and record the complete R13 envelope independently for M. | Same R13 evidence classes, tied only to M. | Same categories as S plus M selection/vessel; R13 tea basis remains missing. | Start only after the explicit R13 basis and M prerequisites exist — `NOT_READY`. |
| `TDCS-L-R13-01` | Trà đào cam sả / L | Same R13 ingredient and explicit tea-basis requirements; no cross-size scaling. | Same functional equipment/tools, with an independently measured L vessel. | Run and record the complete R13 envelope independently for L. | Same R13 evidence classes, tied only to L. | Same categories as S plus L selection/vessel; R13 tea basis remains missing. | Start only after the explicit R13 basis and L prerequisites exist — `NOT_READY`. |
| `BXDN-R36-01` | Bơ xay dừa non / Variant unassigned | Exact avocado, frozen young-coconut flesh, unsweetened fresh milk, condensed milk, sugar syrup and ice identities/SKUs; retain the R36 benchmark exactly. | Operator-identified blender/container, gram scale, volume measures, timer and measured receiving vessel. | Record all source inputs, blend setting/time, finished output, vessel fill, residue/loss, preparation time, sensory observations and repeat identity. | R36 source; labels/SKUs and provenance; equipment/settings; raw dated measurements; departures; tester and Owner disposition. | Owner: actual inputs and permission to run the benchmark without assigning it to S/M/L. Operator: equipment/vessel/tools. Ingredient acquisition remains separately governed. | Start only when the complete physical prerequisite set is present and identified — `BLOCKED_BY_MISSING_INPUT`. |

### 1.4 Smallest useful first execution wave

No test can be declared executable from repository evidence alone because actual Ingredient availability, equipment, vessels and measuring tools have not been confirmed. The earliest single run is whichever of `CM-R04-01`, `CM-R05-01`, or `BXDN-R36-01` first satisfies its complete physical prerequisite set; one run produces useful bounded evidence but cannot approve a Recipe or Variant. The smallest salted-coffee comparison wave is both R04 and R05. In parallel, select exactly one actual Trà đào cam sả size and prepare its R12 run; add the matching R13 run only after its independent tea basis is explicitly recorded. The other four tea records remain deferred without implying scaling or rejection. R36 remains an unassigned-Variant benchmark until separate review.

#### 1.4.1 `CM-R04-01` / `CM-R05-01` preparation evidence boundary

The repository has completed the source and record design needed to prepare the first salted-coffee wave. It does not establish physical readiness. The Owner or test operator must confirm each physical fact against the actual item or tool before either run changes from `PLANNED`.

| Prerequisite | Established by repository evidence | Physical confirmation still required | Go/no-go criterion |
|---|---|---|---|
| Stable run and parent-source identity | `CM-R04-01` is bound to R04; `CM-R05-01` is bound to R05. Their quantities and foam systems remain independent. | Blank run sheet is assigned to the actual tester, date, location and repeat number. | Go only when the selected sheet identifies exactly one run and parent source; no hybrid formulation. |
| Source-specific quantities | R04 and R05 quantities/ranges in §§2.1–2.2 are source-verified planning evidence. | Owner identifies the first value inside every published range; actual weighed/measured inputs are recorded during the run. | Go only when every ranged input has an explicit trial value and no missing value has been copied from the other track. |
| Ingredient identity and provenance | Required Ingredient classes are enumerated for each track. | Exact SKU/brand, package label, source/provenance, lot/expiry where present, storage/safe-handling evidence and physical availability. | Go only when every required input is physically present, identifiable and usable; a public listing is insufficient. |
| Equipment and measuring tools | Required functional classes are enumerated: brewer/phin, foam tools, scale, volume tools, thermometer and timer. | Actual make/model or specification, location, condition/readiness and check/calibration evidence. | Go only when each required function is available and its readiness is recorded; absence or failed check blocks the run. |
| Serving vessel | A measured vessel is required; nominal capacity is not accepted as evidence. | Actual vessel identity/SKU, physical availability, capacity method, readings and measured usable capacity. | Go only when the vessel is present and usable capacity is traceably measured for the run. |
| Actual measurement capture | §§5–6 provide blank fields for extraction, foam, ice, output, loss, time, sensory and repeat evidence. | Raw dated measurements, operator observations and departures from the parent source. | Go only with blank records prepared before work starts; completion requires every applicable actual field or an explicit unresolved reason. |

#### 1.4.2 Evidence review criteria after each salted-coffee run

| Review dimension | Evidence required | Fail-closed result when absent or conflicting |
|---|---|---|
| Source fidelity | Parent track, all selected source values, actual quantities and every departure. | Retain as incomplete experimental evidence; do not compare or advance it as the R04/R05 candidate. |
| Identity and provenance | Exact input labels/SKUs, evidence sources, equipment, vessel, tester, date and repeat. | No Recipe/BOM handoff. |
| Input/output balance | Coffee input and extracted output; complete foam inputs/output; ice; finished output; leftover/loss and reason. | Yield, waste and unit-cost denominators remain unknown. |
| Sensory record | Observations recorded against the complete parent formulation; salt is never assessed outside its foam system. | No sensory disposition or cross-track conclusion. |
| Repeatability | A separately identified repeat with retained settings, measurements and observed variance. | One run remains bounded evidence only; it cannot establish repeatability or an approved Recipe. |
| Owner disposition | Explicit dated review identifying retain/repeat/reject/needs-more-evidence without rewriting raw evidence. | Status remains `OWNER_REVIEW_REQUIRED`; no Recipe/BOM approval or costing use. |

#### 1.4.3 First costing-candidate ranking across all 52 combinations

All 52 costing rows remain `NOT_CALCULABLE_MISSING_EVIDENCE`; this ranking identifies acquisition order only. The comparison uses current source coverage, prepared run identity, number and clarity of missing inputs, physical measurability, purchase-evidence availability, yield/output measurability, packaging requirements and unresolved policy dependencies. It is not a cost, margin, Recipe or supplier recommendation.

| Rank | Product / approved Variant | Why it leads on current evidence | Exact remaining gaps | Minimum acquisition sequence |
|---:|---|---|---|---|
| 1 | Cà phê muối / Một cỡ | Two source-verified named-Product tracks have stable run IDs, complete source-specific capture sheets and explicit equipment/output/loss controls. It is the only combination already marked `READY_AFTER_SESSION_INPUT_CONFIRMATION` in the MAKE matrix. | Exact Ingredient SKUs and availability; selected in-range values; equipment/tool checks; measured vessel; actual run and repeat measurements; Owner-reviewed Recipe/BOM; purchase/package evidence; unit conversion; measured yield/waste; dine-in/takeaway packaging and their costs. | Complete independent R04/R05 pre-trial records → execute and retain raw measurements separately → repeat the retained candidate → Owner Recipe/BOM review → collect actual purchase and packaging evidence → populate traceable costing lines → evidence review before any calculation. |
| 2 | Cà phê sữa / Một cỡ | Two direct named-Product formulations provide independently published quantities, the Variant is single-size, and coffee/milk/ice inputs and extraction/output are physically measurable. It has stronger comparable public quantity evidence than Cà phê đen, whose second source is only a phin-method comparator. | Owner selection of a bounded trial basis; exact coffee/condensed-milk/ice SKUs; dedicated run identity and capture sheet; equipment/vessel; actual extraction/output/loss and repeat evidence; Owner-reviewed Recipe/BOM; purchase, conversion, packaging and cost evidence. | Select one parent formulation without averaging → assign a controlled run ID and blank capture record → identify physical inputs/equipment/vessel → measure run and repeat → Owner Recipe/BOM review → acquire purchase/packaging evidence → costing reconciliation. |

No tie-breaker makes either combination costing-ready today. BUY Products retain a potentially shorter arithmetic path only after an accepted finished specification and authorized procurement evidence exist; current public retail listings do not satisfy that chain. `CORE-OD-03/04` remain required for authoritative tax/rounding treatment but do not prevent collection of raw quantities, purchase documents, packaging facts or trial measurements.

### 1.5 BUY sample evaluation sequence

This sequence applies independently to Bánh croissant, Cheesecake, Brownie chocolate and Muffin. It is usable only after a real sample is lawfully obtained; it authorizes no contact, RFQ, purchase or supplier relationship.

1. Before receipt, record the Owner's blank acceptance specification: exact Product/flavor/formulation, physical size or weight, saleable portion, condition-on-receipt criteria, required remaining shelf life, handling/preparation requirements and defect/rejection criteria. If any criterion lacks evidence, leave it blank rather than importing a public listing claim.
2. On receipt, retain the actual product/SKU, verified supplier and transaction documents if they exist; record lot/batch/expiry evidence, packaging condition, actual received quantity, storage/handling statements and delivery evidence. A public seller/provider remains separate from `supplier_identity`.
3. Measure or count the actual saleable portions and any unsaleable quantity; record the reason without inventing a waste rate or acceptance threshold.
4. Evaluate the sample against only the pre-recorded accepted criteria. Record observations and discrepancies; do not mark acceptance merely because a public listing or sample exists.
5. Owner records `acceptance_specification_status` only after reviewing the complete evidence. Acceptance does not approve the supplier, quotation, purchase terms, cost, tax treatment, Recipe/BOM, Gate or implementation.
6. Keep accepted quotation, actual purchase, delivery/freight and landed-cost evidence separate. Copy values into costing only when the exact evidence and calculation basis are complete; otherwise `verification_status` remains `MISSING_INPUT`.

### 1.6 Owner execution dashboard

No row is `READY_FOR_CONTROLLED_TRIAL` because the repository cannot prove physical availability and completion of every required input/tool check. R04 now has a provisional Owner checkpoint, but that checkpoint does not prove physical readiness or authorize execution. Move a row to `READY_FOR_CONTROLLED_TRIAL` only after its listed prerequisites are recorded.

| Workstream | Product / trial | Readiness status | Missing materials/equipment | Missing Owner input | Evidence required | Next actionable step / blocking dependency |
|---|---|---|---|---|---|---|
| WS01 | Cà phê muối / `CM-R04-01` | `EVIDENCE_BACKED_SELECTION_AWAITING_PHYSICAL_VERIFICATION` | Physically identified packages for provisional coffee `R04M-I01/I02`, condensed milk `R04M-I03`, cream `R04M-I05/I06`, water `R04M-I12`, exact salt and ice; provisional phin `R04M-E01`, scale `R04M-E04`, mixer `R04M-E07`; thermometer, volume tools, timer function and measured vessel | Retailer choice within the paired coffee and cream observations remains open; no further formulation quantity is required because the Owner provisionally selected 1.0 g salt and three independent conforming runs on 2026-11-25 | Package labels/provenance; physical availability; equipment checks; vessel capacity; actual measurements; output/loss; sensory and repeat evidence | Complete the R04 physical verification sheet in §2.5. The provisional checkpoint is not an Ingredient/equipment approval, purchase authorization or permission to execute the trial. |
| WS01 | Cà phê muối / `CM-R05-01` | `READY_FOR_OWNER_PREPARATION` | Actual coffee, condensed milk, cream, fresh milk, salt, water/ice and same measurement capabilities | Exact SKUs and first in-range condensed-milk value; optional cocoa remains excluded unless explicitly selected | Same classes as R04, retained independently | Prepare separately; never hybridize with R04. |
| WS02 | Trà đào cam sả / one selected `TDCS-*-R12-01` | `READY_FOR_OWNER_PREPARATION` | Exact tea, peach, orange, syrup, lemongrass, lime, water/ice; brewer/filter, citrus tools and measured vessel | Select one first Variant/vessel and actual SKUs | Brew inputs/output, Product inputs, ice, vessel, final output/loss, sensory and repeat evidence | Select and measure one vessel; do not scale the 500 ml benchmark. |
| WS02 | Matching `TDCS-*-R13-01` | `BLOCKED_BY_MISSING_INPUT` | Same physical classes as R12 | Explicit independent tea identity, dose, water, temperature, time and method | Full R13 tea-basis record plus independent run evidence | Define the R13 trial basis without copying R12. |
| WS03 | Bơ xay dừa non / `BXDN-R36-01` | `READY_FOR_OWNER_PREPARATION` | Actual avocado, frozen young-coconut flesh, milks, syrup, ice; blender/container, scale, volume tools, timer and vessel | Permit one unassigned-Variant benchmark and identify exact SKUs | Actual inputs, setting/time, output, residue/loss, sensory and repeat evidence | Assemble complete physical set; do not map result to S/M/L automatically. |
| WS04 | Bánh croissant | `BLOCKED_BY_MISSING_INPUT` | No authorized physical sample or verified supplier/transaction evidence | Accepted finished specification, portion, receipt/storage/handling and rejection criteria | Actual SKU, manufacturer/supplier documents, lot/expiry, receipt condition, saleable portions, quotation/transaction and landed cost | Owner defines acceptance specification; supplier contact/purchase remains separately unauthorized. |
| WS04 | Cheesecake | `BLOCKED_BY_MISSING_INPUT` | Same; public listing lacks weight/storage/shelf-life evidence | Exact formulation, weight/portion and acceptance criteria | Same receipt, traceability, saleability and transaction classes | Record specification first; public listing is not supplier acceptance. |
| WS04 | Brownie chocolate | `BLOCKED_BY_MISSING_INPUT` | Same; walnut listing is only a public candidate | Decide whether the listed formulation fits the Product and define acceptance criteria | Same, including actual piece weight, lot/expiry, storage and measured loss | Preserve seller/provider versus supplier distinction. |
| WS04 | Muffin | `BLOCKED_BY_MISSING_INPUT` | Same; flavour and weight are unresolved | Select accepted flavour/formulation, size/portion and criteria | Same receipt, traceability, saleability and transaction classes | Do not infer Vanilla or Chocolate selection from the listing. |
| WS05 | 48 MAKE costing combinations | `EVIDENCE_PENDING` | Actual Recipe/BOM, purchase and packaging evidence | Separate Recipe/BOM and packaging admission after trials | Quantities, units/conversions, prices, yield, waste, batch allocation and channel packaging | Populate only traceable evidence lines; current unit cost remains uncalculable. |
| WS05 | Four BUY costing combinations | `EVIDENCE_PENDING` | Accepted specification, verified supplier, quotation/transaction and receipt evidence | Accepted finished-product specification | Purchase unit, landed cost, saleable portions, measured loss and channel packaging | Keep quoted and actual purchase prices distinct; no margin calculation. |

#### 1.6.1 R04 provisional Owner checkpoint

The Owner supplied the following checkpoint on 2026-11-25. It completes the repository-recording step only. Every entry remains provisional for trial preparation and requires physical identification or verification before use.

| R04 concern | Provisional selection | Preserved boundary |
|---|---|---|
| Coffee | `R04M-I01/I02` | Same named 340 g Product observed at two retailers; retailer, exact physical package, batch, availability and grind suitability remain unverified. |
| Condensed milk | `R04M-I03` | Exact physical package and label must be verified; 20 ml is not converted to grams. |
| Whipping cream | `R04M-I05/I06` | Same named 1 L Anchor Product observed through two retailer sources; retailer, physical package, cold-chain evidence and availability remain unverified. |
| Salt quantity | 1.0 g | Quantity is selected only for R04 trial preparation; exact salt Product remains to be physically identified. |
| Water | `R04M-I12` | Physical bottle/package and suitability for the bounded trial remain to be verified. |
| Phin | `R04M-E01` | Public specification only; physical condition, assembly and suitability remain unverified. |
| Scale/timer | `R04M-E04` | A 0.1 g display division does not establish accuracy or calibration. |
| Foam tool | `R04M-E07` | Physical identity, condition, included beaters and operating settings remain unverified. |
| Repeat design | Three independent conforming runs | No run has occurred. Failed or deviated runs remain evidence but do not count toward the three conforming runs. |

This checkpoint does not select a retailer, approve an Ingredient or tool, prove stock at Hoi An, authorize acquisition or physical execution, or approve a Recipe/BOM or cost.

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
| Salt | 0.75–1.5 g fine sea salt | Preserve the source range. The Owner provisionally selected 1.0 g for `CM-R04-01` preparation on 2026-11-25; this is not a final Recipe or Ingredient approval. |
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

### 2.4 R04 Ingredient evidence reconciliation

All public prices remain `MARKET_REFERENCE_ONLY`. Listing presence is not Hoi An inventory, delivery, quotation, transaction or purchase evidence.

| Input | Provisional evidence | Comparison and confidence | Exact unresolved attribute / physical label check | Trial-critical blocker |
|---|---|---|---|---|
| Coffee | `R04M-I01/I02` | Both identify Trung Nguyên Sáng Tạo 1, 100% Robusta, ground coffee, 340 g. `I01` is a direct WinMart Product page at 95,000 VND with high confidence; `I02` is a direct Co.op Product page at 89,700 VND, includes retailer SKU `3330468`, and also has high confidence. Neither source proves that retailer-specific SKU numbers are a shared manufacturer code. | Record actual manufacturer Product name/code, ingredients/composition, roast/grind statements, net content, lot, expiry, retailer/source and package photographs. Retailer choice remains open; retain the other listing as corroborating market evidence. | Missing physical package, availability, package identity or grind suitability blocks a valid R04 run. |
| Condensed milk | `R04M-I03` | Direct WinMart listing for Vinamilk Ông Thọ green label, sweetened condensed milk, 380 g, 29,700 VND; high confidence. | Verify exact label, net mass, ingredients, lot/expiry, storage statement and physical availability. Record 20 ml by volume and, if useful, measure its actual mass separately; never derive mass from the listing. | Missing exact physical package or inability to measure 20 ml blocks the run. |
| Whipping cream | `R04M-I05/I06` | Both identify Anchor UHT whipping cream, 1 L. `I05` is the stronger primary evidence: direct WinMart Product page, 204,500 VND, high confidence. `I06` is retained as the alternative retailer observation: Annam search listing, 210,000 VND, medium confidence. | Verify actual manufacturer Product identity, fat/composition statement, net volume, lot/expiry, storage/cold-chain instructions, package condition and retailer/source. Retailer choice and Hoi An availability remain open. | Missing physical package, safe storage evidence or ability to measure 60 ml blocks the run. |
| Salt | Quantity fixed provisionally at 1.0 g; `R04M-I10/I11` remain alternatives | `I10` is stronger primary listing evidence (direct Co.op Product page, high confidence); `I11` is a medium-confidence brand listing. They are not assumed sensory-equivalent. | Owner/operator must identify the actual salt Product and record label, grain/type statement, net mass, lot/expiry where present and source. Scale suitability for 1.0 g must pass the proposed check in §2.5. | Unidentified salt or measurement uncertainty that cannot support the selected 1.0 g input blocks the run. |
| Water | `R04M-I12` | Direct WinMart listing for Aquafina 1.5 L, 11,700 VND; high confidence; only a bounded bottled-water comparator. | Verify the physical bottle identity, seal, net volume, lot/expiry where present and actual source. | Missing physical water or inability to measure 100 ml blocks the run. |
| Ice | `R04M-I13` | Evidence gap; no sufficiently specific retained source or price. | Record source, food-handling/storage statement, physical form, package identity/mass where applicable, measurement instrument and actual mass added. | Unidentified/unsafely handled ice or inability to measure its actual mass blocks the run. |

### 2.5 R04 physical equipment verification record

Every observed result below is intentionally blank. `PROPOSED_VALIDATION_TARGET` is an experimental target for Owner review, not proof that a tool is suitable.

| Tool / provisional ID | Identity and condition to record | Check procedure and blank observations | Go/no-go boundary |
|---|---|---|---|
| Scale/timer — `R04M-E04` | Actual make/model/serial or distinguishing ID; maximum load; displayed division; pan condition; power/battery; level/stable placement; timer availability | Warm/stabilize as instructed; record unloaded zero; tare the actual container; apply a documented check weight at least three times, removing it between readings; record nominal check-weight value/source and every reading; repeat the tare/return-to-zero check. Observed readings: ___ / ___ / ___. Zero returns: ___ / ___ / ___. | Readability is not accuracy or calibration. For the 1.0 g salt input, proposed maximum uncertainty is 0.05 g (`PROPOSED_VALIDATION_TARGET`). A 0.1 g display division alone cannot demonstrate that target; if documented check evidence cannot support the input, use a separately verified suitable instrument or stop. |
| Thermometer — candidate not selected (`R04M-E08/E09`) | Actual make/model/ID; probe condition; stated range, resolution and tolerance from its own evidence | Confirm the stated range covers 90–96°C. Record a comparison against a separately identified reference at a relevant hot-water point, the reference evidence, both readings and difference; repeat at least three times without calling the comparison formal calibration. Results: ___ / ___ / ___. | Proposed requirements: range includes 90–96°C, resolution no coarser than 1°C and verified uncertainty/tolerance no greater than ±1°C. Missing specifications or unacceptable comparison evidence blocks the run. |
| Volume tools — `R04M-E10/E11/E12` candidates | Actual tool ID, nominal capacity, marked graduation interval, condition and readable markings | Select tools appropriate to 20 ml, 60 ml and 100 ml. At each target, fill/read using a consistent meniscus method and compare three repeats using a separately identified reference or gravimetric procedure whose assumptions are documented. Record actual readings; do not infer tolerance from photos. | Proposed requirements: 20 ml and 60 ml measurements use graduations no coarser than 1 ml with proposed verified tolerance ±1 ml; 100 ml must have a documented suitable graduation/tolerance. Missing evidence blocks the affected input. |
| Phin — `R04M-E01` | Actual item identity, parts, cleanliness, damage, filter fit and stated/observed capacity | Dry-assemble all parts; inspect holes/filter/press/lid; verify it physically accepts the 20 g coffee and 100 ml water basis without overflow under a non-product dry/water fit check; record observations only. | Missing/damaged parts, contamination or inability to accommodate the bounded inputs blocks the run. No brew duration or yield is pre-approved. |
| Mixer — `R04M-E07` | Actual model/ID, voltage/power evidence, beaters, cleanliness, damage and operating state | Inspect and dry-run each intended setting only as permitted by the manufacturer; record setting used, abnormal sound/vibration and beater identity. Manual-whisk evidence cannot substitute for this electric-tool selection. | Unsafe/inoperative equipment or an unrecorded setting blocks the run. No speed or mixing duration is selected by this protocol. |
| Serving vessel — `R04M-E15` | Actual vessel ID/photo, material, condition and nominal marking if any | Define usable fill line before measuring. Fill to that line with a verified graduated method three times; empty between observations; record ___ ml / ___ ml / ___ ml and method. Retain all readings and state the chosen recorded usable capacity only after review. | Nominal catalogue capacity is not usable capacity. Missing vessel or three traceable observations blocks the run. |
| Ice / finished-output measurement | Actual scale/container/volume-tool IDs and usable ranges | Tare the receiving container; record actual ice mass. After assembly, record finished mass and, where measured, volume plus method; record residual foam, coffee or beverage separately. | Instrument range must cover the full item/container. Missing actual ice mass or finished-output evidence makes the run nonconforming. |

### 2.6 `CM-R04-01` controlled execution procedure

1. **Open the run record.** Assign repeat `01`, `02` or `03`; record date/time, operator, location and the immutable parent identity `CM-R04-01` / R04. Do not count an earlier failed/deviated run by relabelling it.
2. **Confirm readiness.** Check physical Ingredient packages, safe handling/storage evidence, equipment condition, measurement checks, actual vessel identity and blank capture fields. Stop if any trial-critical item in §2.4 or §2.5 fails.
3. **Record Ingredient identity.** Capture each exact Product/SKU, package, lot/batch and expiry where available, label evidence, acquisition/source evidence and storage condition. Public IDs remain cross-references, not physical identity proof.
4. **Prepare measuring tools.** Record instrument IDs, zero/tare state and the completed check results. Do not proceed with 1.0 g salt unless the measurement is defensible under the recorded check evidence.
5. **Measure coffee and water.** Record actual coffee mass against the 20 g target and water volume against the 100 ml target. Heat water and record the actual temperature used; it must remain within the retained 90–96°C source range unless the run is explicitly marked deviated.
6. **Prepare the phin.** Record coffee distribution, actual water additions and start/end timestamps. The retained evidence does not prescribe bloom volume/time, tamp force or extraction duration; any operator choice must be recorded as `PROPOSED — OWNER REVIEW REQUIRED`, not silently treated as the Recipe.
7. **Measure extraction.** Record actual extracted coffee mass and/or volume, measurement method, residual water/coffee where observable and deviations. The source's approximately 80 ml is a comparator, not an assumed output.
8. **Measure condensed milk.** Record 20 ml with the verified volume tool. If mass is also observed, record it as a direct measurement tied to this package/run; do not apply it as a general density.
9. **Prepare the complete R04 foam.** Measure 60 ml cream and 1.0 g of the physically identified salt. Record mixer/beater ID, setting, start/end time, input temperature if observed, foam output and leftover. Evaluate salt only within this complete foam system.
10. **Assemble and add ice.** Record pre-weighed ice mass, assembly order, vessel ID and every added amount. The source phrase “two-thirds full” is not a mass or approved fill rule; record the observed fill without inventing a target capacity.
11. **Measure finished output.** Record final mass and/or volume, temperature if measured, preparation duration, remaining coffee/foam, spill/residue and calculated loss only when the measurement basis is complete and shown.
12. **Record observations.** Capture appearance, aroma, coffee intensity, sweetness, salt perception, texture, temperature and overall free-text observations without applying invented pass thresholds.
13. **Close the run.** Record deviations/reasons, completeness status, operator sign-off and Owner-review field. Clean equipment following available manufacturer and food-handling instructions. Preserve raw data even if the run fails or is rejected.

### 2.7 Blank R04 records — three planned independent runs

The following reusable records intentionally contain no actual results. A run counts toward the three-run plan only when it is independently executed and later classified conforming from complete evidence.

| Field | `CM-R04-01-R01` | `CM-R04-01-R02` | `CM-R04-01-R03` |
|---|---|---|---|
| Date/time; operator; location |  |  |  |
| Parent source and run ID | R04 / `CM-R04-01` | R04 / `CM-R04-01` | R04 / `CM-R04-01` |
| Coffee public ID; exact package/SKU; lot/expiry |  |  |  |
| Condensed-milk ID; package/SKU; lot/expiry |  |  |  |
| Cream public ID; package/SKU; lot/expiry |  |  |  |
| Salt Product/package; lot/expiry where present |  |  |  |
| Water and ice identity/source |  |  |  |
| Phin; scale; thermometer; volume tool; mixer; timer; vessel IDs |  |  |  |
| Instrument check references/results |  |  |  |
| Coffee target 20 g / actual g |  |  |  |
| Water target 100 ml / actual ml / actual °C |  |  |  |
| Brew start/end; proposed operator choices |  |  |  |
| Extracted coffee output and unit/method |  |  |  |
| Condensed milk target 20 ml / actual ml; directly measured mass if taken |  |  |  |
| Cream target 60 ml / actual ml |  |  |  |
| Salt target 1.0 g / actual g |  |  |  |
| Mixer setting/time; foam output/leftover |  |  |  |
| Ice actual mass |  |  |  |
| Vessel usable-capacity evidence reference |  |  |  |
| Finished output mass/volume; method |  |  |  |
| Total preparation time; residue/spill/loss and basis |  |  |  |
| Process and sensory observations |  |  |  |
| Deviations and reasons |  |  |  |
| Status: conforming / deviated / failed / incomplete |  |  |  |
| Operator sign-off; Owner review/disposition/date |  |  |  |

### 2.8 R04 evaluation framework

| Dimension | Review question | Advancement rule |
|---|---|---|
| Data completeness | Are identities, instrument checks, all actual inputs, outputs, loss, time, observations and deviations present? | Any mandatory blank remains `INCOMPLETE_EVIDENCE`; it is not a conforming repeat. |
| Instrument readiness | Did every used instrument have suitable range/readability and recorded check evidence? | Missing or conflicting check evidence fails closed. Accuracy is never inferred from display resolution. |
| Process conformity | Did the run retain R04 quantities/range and the provisional 1.0 g salt choice, with every proposed operator parameter recorded? | Unexplained departure is deviated; it remains evidence but cannot count as conforming. |
| Repeatability | Do three independent conforming records permit direct comparison of inputs, process settings and outputs? | No numerical tolerance is approved. Owner must decide acceptable variance after seeing evidence; three runs do not automatically approve repeatability. |
| Output/yield | Are extraction, foam, final output and denominators directly measured? | Missing denominator prevents yield conclusion and Recipe/BOM handoff. |
| Loss/waste | Are leftovers, spills and discarded material measured with reasons? | Blank means unknown, not zero. No waste rate may be inferred. |
| Sensory review | Are observations recorded for the complete R04 formulation? | No numerical acceptance threshold exists. Owner must explicitly retain, repeat, change or reject after review. |
| Packaging/serving | Is the actual vessel measured and is any dine-in/takeaway packaging evidence explicit? | Trial vessel evidence does not establish commercial channel packaging; missing packaging remains downstream evidence. |

### 2.9 R04 downstream evidence handoff and remaining actions

R04 remains **not** a Recipe/BOM candidate and the project remains **0/52 evidence-backed unit costs and margins**. After successful physical work, later admission requires actual acquisition transaction evidence, exact package/net contents, defensible purchase-to-preparation conversions, measured usage, output/yield and loss, dine-in/takeaway packaging and cost evidence, and qualified/approved tax and rounding treatment.

| Critical-path order | Action | Responsible evidence source | Current status |
|---:|---|---|---|
| 1 | Identify the exact physical coffee retailer/package within `I01/I02`, exact cream retailer/package within `I05/I06`, actual salt Product, ice source and every package/lot/expiry. | Owner/operator physical inspection | `AWAITING_PHYSICAL_VERIFICATION`; do not repeat the already supplied provisional selections. |
| 2 | Identify thermometer, volume tools, timer function and serving vessel; execute and record all §2.5 checks. | Owner/operator physical inspection and tool documentation | `AWAITING_PHYSICAL_VERIFICATION`. |
| 3 | Decide whether the proposed scale uncertainty, thermometer, liquid-measurement and three-observation vessel targets are acceptable for this experiment. | Owner review | `OWNER_DECISION_REQUIRED`; no equipment approval follows automatically. |
| 4 | Confirm physical availability and separately authorize acquisition or trial execution if desired. | Owner | `NOT_AUTHORIZED_BY_THIS_PROTOCOL`. |
| 5 | Execute and preserve the three independent run records, retaining all failures/deviations. | Designated physical operator | `AWAITING_PHYSICAL_EXECUTION`; no run has occurred. |
| 6 | Review the evidence and decide retain/repeat/change/reject. | Owner | `AWAITING_EVIDENCE`; not Recipe/BOM approval. |

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

### 5.3 Bơ xay dừa non — R36 unassigned-Variant benchmark

R36 is a public beverage-training benchmark, not an approved AFTER FOUR Recipe or S/M/L formulation. Execute it only as one complete source formulation. Do not scale or assign its result to S, M or L without separate measured trials and Owner review.

| Run ID | Parent track | Exact source formulation retained | Ingredient identity and actual SKU/brand | Actual weighed/measured quantities | Blender/container and settings | Vessel identity/measured capacity | Final serving mass/volume | Preparation time | Residue/loss | Sensory observations | Tester/date/repeat number | Owner disposition | Variant mapping disposition |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| `BXDN-R36-01` | R36 | 80 g avocado flesh; 60 g frozen young-coconut flesh; 50 ml unsweetened fresh milk; 50 ml condensed milk; 20 ml sugar syrup; 180 g ice; high-speed blend about 30 seconds. |  |  |  |  |  |  |  |  |  |  | `UNASSIGNED — NO_S_M_L_INFERENCE` |

## 6. Supplementary practical measurement worksheet

Duplicate the following rows for every Ingredient and every run. Blank cells must remain blank until measured or supplied; use `TO_BE_MEASURED` or `OWNER_INPUT_REQUIRED` rather than invented values.

### 6.1 Ingredient inputs

Record the entity shown on the package or document only in the evidence field supported by that source. A public seller/provider is not a verified supplier, and physical possession does not establish an approved supplier relationship or purchase cost.

| Run ID | Ingredient/component | Function (main/topping/garnish/optional) | Exact specification/SKU/brand | Public seller, supplier or other source identity as evidenced | Package label, lot/expiry and source reference | Physically available for this run? | Preparation state | Source quantity/unit | Actual quantity/unit | Evidence/classification | Notes |
|---|---|---|---|---|---|---|---|---|---|---|---|
|  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |  |

### 6.2 Equipment and settings

| Run ID | Equipment/tool | Make/model or specification | Physical availability and location | Condition/readiness check | Setting | Temperature | Time | Calibration/check evidence | Checked by/date | Notes |
|---|---|---|---|---|---|---|---|---|---|---|
|  |  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |

### 6.3 Batch/component preparation

| Run ID | Component | Inputs/reference | Start mass/volume | Filtered/usable output | Leftover/loss | Number of intended servings | Allocation basis | Notes |
|---|---|---|---|---|---|---|---|---|
|  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |

### 6.4 Ice, vessel, finished output, and loss

Nominal size labels are not measured capacity. Record the actual vessel and the method and repeat evidence used to establish its usable capacity; do not transfer a capacity between S/M/L or between source tracks.

| Run ID | Ice mass | Vessel identity/SKU | Vessel physically available? | Capacity measurement method | Capacity readings / evidence reference | Measured usable capacity | Finished mass | Finished volume | Foam/component output | Leftover/loss | Measurement method / notes |
|---|---|---|---|---|---|---|---|---|---|---|---|
|  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |  |

### 6.5 Sensory evaluation and acceptance fields

No numerical sensory threshold is approved. Where a target is required, record `OWNER_INPUT_REQUIRED`.

A run may advance to `READY_FOR_OWNER_REVIEW` only when source fidelity/departures, every actual input, equipment/settings, finished output, loss, preparation time, sensory observations and repeat identity are recorded. This is evidence-completeness criteria, not sensory acceptance. Only the Owner may record a formulation disposition, and that disposition does not by itself approve Recipe/BOM admission or costing use.

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

### 6.8 Pre-trial preparation checklist

Complete this checklist independently for each planned run. A checked preparation item confirms only that the identified evidence or physical input is available for that run; it does not approve an Ingredient, supplier, Recipe, BOM, Variant mapping or formulation. `CM-R04-01` and `CM-R05-01` require separate checklists even when they use the same physical equipment or exact Ingredient SKU.

| Run ID | Preparation checkpoint | Evidence/reference | Confirmed by/date | Status | Unresolved note |
|---|---|---|---|---|---|
|  | Parent source and immutable run identity recorded |  |  |  |  |
|  | Every required Ingredient physically present and exact label/SKU recorded |  |  |  |  |
|  | Source-range values selected and recorded without changing the parent formulation |  |  |  |  |
|  | Equipment and measuring tools physically present and readiness/check evidence recorded |  |  |  |  |
|  | Actual serving vessel identified and usable capacity measured |  |  |  |  |
|  | Safe handling information available for the actual inputs |  |  |  |  |
|  | Blank run sheet and evidence references prepared before measurement starts |  |  |  |  |
|  | R13 independent tea identity, dose, water, temperature, time and method recorded, if applicable |  |  |  |  |
|  | No S/M/L scaling, cross-track substitution or prior result has been assumed |  |  |  |  |

## 7. First-round input readiness

| Input class | Required for the first practical round | Boundary |
|---|---|---|
| Owner must identify or approve | Actual Ingredient identities/SKUs to test; available equipment; the actual serving vessel for Cà phê muối; one prioritized Trà đào cam sả serving size and its actual vessel; whether an R13 tea-base trial may proceed and, if so, its explicitly recorded trial basis; whether the R36 benchmark may be run without Variant assignment; which values inside published source ranges will be run first. | This selects test inputs only. It does not approve an Ingredient, Recipe, BOM, Variant mapping, supplier, or commercial standard. |
| Physically measurable during the test | Ingredient masses/volumes; water temperature and time; extracted/filtered output; foam output; fruit/peach/lemongrass mass; ice mass; measured vessel capacity; finished output; preparation time; leftovers/loss; repeatability and sensory observations. | Measurements are test evidence, not approved Recipe or costing inputs. |
| Supplier/document evidence required | SKU label/specification, package/unit evidence, lot or best-before information where available, and provenance for each actual Ingredient used. | Accepted quotation, invoice, landed cost, supplier approval, tax evidence, and purchase terms are not prerequisites for a bounded sensory/yield test, but remain required before evidence-backed costing or procurement approval. |
| Not yet needed for the first practical round | Remaining Trà đào cam sả sizes not selected for the first session; approved S/M/L scaling; Dine-in/Takeaway packaging allocation; waste/remake policy; purchase price; unit cost; gross margin; tax and rounding treatment. | Deferral must not be interpreted as approval or as permission to copy the first-size result to another Variant. |

Practical testing remains blocked only where the selected first-round run lacks an identifiable Ingredient, usable equipment, a measurable vessel, safe handling information, or an explicit trial basis for a source gap such as R13 tea preparation. Future S/M/L work does not block R04/R05 or one accurately bounded first-size R12/R13 comparison.

## 8. Minimum first-round execution sequence

1. Confirm the actual Ingredient SKUs/specifications and equipment available for the session; record documentary labels and unresolved substitutions.
2. Identify and measure the actual vessels, including the one Owner-prioritized Trà đào cam sả serving size. Do not infer capacities from S/M/L labels.
3. Run R04 and R05 independently with their complete parent formulations and separate records; do not compare salt outside its foam system.
4. Run R12 and R13 independently at the Owner-selected first serving size. R13 may proceed only with its tea-base trial basis explicitly recorded; do not import R12's tea dose or brewing method.
5. If separately prepared, run R36 exactly as retained under `BXDN-R36-01`; record it as an unassigned-Variant benchmark and do not infer S/M/L applicability.
6. Record outputs, losses, preparation times, sensory observations, and repeat identity; identify which candidates merit a controlled repeat without selecting a winner.
7. Defer the remaining tea and Bơ xay dừa non Variant work until first-round evidence has been reviewed. No scaling or cross-size adoption follows automatically.

## 9. Ingredient purchasing boundary

Candidate supplier references come only from the existing [external Ingredient/supplier research](after_four_commercial_v1_external_ingredient_supplier_research.md). They are leads, not selected suppliers or SKUs; public prices are not purchase costs.

- Cà phê muối: `SRC-01` and `SRC-17` are generic coffee/dairy category leads. Before testing, select exact coffee, condensed milk, whipping cream, fresh milk where Track B applies, salt, and ice/water specifications.
- Trà đào cam sả: `SRC-03/04/05/06/08/09/10/11` are candidate tea/peach/syrup leads. Before testing, select exact black tea, preserved peach/peach liquid, orange, lemongrass, sugar syrup, lime for R12, and water/ice specifications.
- Bơ xay dừa non: R36 supplies an external formulation only. Before testing, identify exact avocado maturity/specification, frozen young-coconut flesh, unsweetened fresh milk, condensed milk, sugar syrup, ice and their actual provenance. Coconut syrup, coconut milk and young-coconut flesh are not interchangeable.

Do not contact suppliers, send RFQs, select a supplier, or treat a public listing as actual cost under this protocol.

## 10. Bơ xay dừa non — bounded R36 benchmark

R36 establishes one external benchmark using frozen young-coconut flesh and the quantities retained in §5.3. R18 remains an avocado/coconut-syrup/ice-cream comparator and R19 remains an avocado/strawberry comparator; neither is merged into R36.

The benchmark may enter physical execution only after its actual Ingredient SKUs/provenance, blender/container, measuring tools and vessel are identified. It establishes no approved Ingredient, Recipe, output, loss, sensory threshold or Variant applicability. Fresh versus frozen young coconut, any substitution, intended S/M/L mapping and commercial standard remain separate Owner-review matters.

## 11. Completion and governance boundary

A test is complete only when its source identity, exact inputs, equipment/settings, actual output/loss, sensory observations, repeat result, and unresolved deviations are recorded. `TESTED` does not mean approved. Owner review and separate Recipe/BOM admission remain mandatory.

This protocol performs no unit-cost or gross-margin calculation and creates no Owner decision, canonical ODB ID, supplier selection, purchase, disclosure, Gate A/B/C, implementation authorization, FOA, or Production Authorization. It changes no Product, Variant, Price, tax, rounding, schema, migration, database, API, code, or runtime behavior.
