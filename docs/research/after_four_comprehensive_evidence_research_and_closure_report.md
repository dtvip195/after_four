# AFTER FOUR — Comprehensive Evidence Research and Closure Report

**Assessment date:** 2026-11-24 (Asia/Tokyo)
**Repository baseline:** `fbb8685491da6773ab71539acf9f66975bd6d81d`
**Status:** `EVIDENCE_MAP_COMPLETE — MATERIAL INPUTS REMAIN OPEN — NO AUTHORIZATION GRANTED`

## 1. Executive summary

This report consolidates the evidence currently available for Commercial V1, the Hoi An market, CORE-02 customer custody transfer, CORE-04 Cash/reconciliation/reporting, the six-domain core operating flow, and applicable Vietnamese regulatory review. It is an evidence map, not an approval or readiness declaration.

The principal conclusions are:

- the canonical commercial inventory reconciles exactly to 28 Products and 52 priced combinations: 24 `MAKE_IN_HOUSE` Products/48 combinations and four `BUY_FINISHED` Products/four combinations;
- all 52 canonical costing rows remain `MISSING_INPUT`; evidence-backed unit cost and evidence-backed gross margin are both 0/52;
- public Recipe evidence improves comparison and test planning but supplies zero approved AFTER FOUR Recipes;
- public market evidence establishes a tourism-heavy Hoi An context and some competitor listings, but it does not establish site demand, footfall, conversion, rent, or willingness to pay;
- the current CORE-02/CORE-04 worksheet represents all seven custody-transfer and ten Cash/reporting questions, and every answer field remains blank;
- CORE-02's logical fail-closed/quarantine semantics and CORE-04's confirmed Cash controls are evidence-backed policy, but the operational evidence classes and authority assignments remain unresolved;
- current Vietnamese legal instruments can be identified, but applicability and operational conclusions require actual entity, premises, menu, staffing, data-use, and workflow facts plus qualified Vietnamese professional review; and
- the shortest path is real evidence collection: one Owner input session, bounded field tests, supplier documents after authorization, and parallel qualified professional reviews. Another generic readiness sprint would not close these gaps.

The companion [machine-readable evidence register](after_four_comprehensive_evidence_register.csv) contains 57 material evidence items and is the row-level source for classification, provenance, limitations, provider, next action, and blocking scope.

## 2. Baseline, method, and authority boundary

The review started from synchronized `main` and `origin/main` at `fbb8685491da6773ab71539acf9f66975bd6d81d`. It follows [AGENTS.md](../../AGENTS.md), the [Glossary](../../GLOSSARY.md), the [Owner Decision Baseline](../architecture/after_four_owner_decision_baseline.md), and accepted ADR-0003, ADR-0004, ADR-0010, and [ADR-0011](../architecture/adr/0011-project-wide-layered-ddd.md).

Evidence is classified as `VERIFIED_PRIMARY`, `VERIFIED_SECONDARY`, `PUBLIC_LISTING_ONLY`, `RESEARCH_REFERENCE`, `RESEARCH_DERIVED_PROPOSAL`, `OWNER_INPUT_REQUIRED`, `PHYSICAL_MEASUREMENT_REQUIRED`, `SUPPLIER_DOCUMENT_REQUIRED`, `QUALIFIED_PROFESSIONAL_REQUIRED`, `GOVERNANCE_APPROVAL_REQUIRED`, `UNVERIFIED`, or `NOT_APPLICABLE`. A classification describes the stated evidence item only. Public evidence never upgrades a proposal into Owner policy, and repository presence never grants implementation authority.

No supplier, authority, accountant, lawyer, operator, customer, or other third party was contacted. No Recipe, Ingredient, supplier, cost, margin, role, capability, legal conclusion, Gate, implementation, FOA, or Production Authorization is created here.

## 3. Existing evidence inventory

### 3.1 Commercial V1

The program reused, rather than duplicated:

- [Proposed Launch Menu v3](../architecture/after_four_proposed_launch_menu_v3.md) and [Real Menu & Pricing Specification](../architecture/after_four_real_menu_pricing_specification.md);
- the 37-column [costing input](../architecture/after_four_commercial_v1_costing_input.csv), [MAKE Recipe/BOM input](../architecture/after_four_commercial_v1_make_recipe_bom_input.csv), [BUY procurement input](../architecture/after_four_commercial_v1_buy_finished_procurement_input.csv), and [Buy-vs-Make Owner input](../architecture/after_four_commercial_v1_buy_vs_make_owner_input.csv);
- [external Ingredient/supplier research](after_four_commercial_v1_external_ingredient_supplier_research.md), [public Recipe research](after_four_commercial_v1_recipe_quantity_research.md), [Signature field-test protocol](after_four_commercial_v1_signature_practical_test_protocol.md), and [cost-evidence gap report](after_four_commercial_v1_cost_evidence_collection_gaps.md).

The existing templates already represent repeated BOM lines, Product/Variant quantity, purchase/preparation units, conversion, yield/waste, channel packaging, quotation/actual cost, landed cost, and evidence dates. No new column is justified by current evidence.

### 3.2 Core operations and architecture

The controlling policy/evidence set includes the [CORE-02/CORE-04 Owner Decision Worksheet](../architecture/after_four_core_02_core_04_owner_decision_worksheet.md), Owner Decision Baseline, Data Dictionary, Data Integrity Rules, ERD, Logical Database Design Inventory, current CORE-01/02/04 designs and remediations, independent reviews, and ADR-0011. Logical entities and Mermaid relationships are design evidence only; they are not an approved physical schema.

### 3.3 Market evidence

No dedicated current Hoi An competitor, customer, location, or pricing research artifact existed in `docs/` at this baseline. Incidental references to the first Hoi An Branch are scope facts, not market proof. This report therefore records a bounded first market evidence set without claiming demand validation.

## 4. Master evidence matrix

| Evidence range | Domain | Available evidence | Missing evidence / conflict | Classification | Provider and next action | Blocks |
|---|---|---|---|---|---|---|
| `CE-COM-001..003` | Commercial baseline/costing | 28/52 identity coverage; 24 MAKE/48; four BUY/four; quantified public comparison for 22/24 MAKE | Approved Recipe/specification, measured yield/loss, supplier documents and packaging; only 4/24 have two independent comparable named-Product publishers | `VERIFIED_PRIMARY`; `RESEARCH_REFERENCE`; cost `UNVERIFIED` | Owner, operator/tester, supplier | Costing and commercial Gate review |
| `CE-COM-004..006` | Bơ xay dừa non | Public evidence distinguishes coconut water, frozen young flesh, mature flesh and processed water-with-pulp | Intended Product/Ingredient form, texture and specification | `VERIFIED_PRIMARY`; `VERIFIED_SECONDARY`; `PUBLIC_LISTING_ONLY` | Owner selects bounded identity; supplier documents; later physical test | Practical test and costing for three combinations |
| `CE-COM-007..008` | Cam ép / Khoai tây chiên | Orange-yield and frozen-fries comparators | Local fruit/SKU, portion, equipment, actual yield/waste/oil | `RESEARCH_REFERENCE` | Owner plus operator measurement and supplier instructions | Six Cam combinations and one fries combination |
| `CE-COM-009..014` | Four BUY Products | Public retail/category/supplier-capability leads | Accepted finished specification, exact SKU/package, quotation, delivery, VAT document, storage/shelf life | `PUBLIC_LISTING_ONLY`; limited `VERIFIED_PRIMARY` capability | Owner specification; supplier documents after authorization | Four BUY costs |
| `EV-B-TOUR-01..03` | Hoi An tourism | Official city/heritage statistics show large international visitor context | Scope conflict among citywide and managed/ticketed venue measures; no Branch catchment | `VERIFIED_PRIMARY` | Define exact measure and site before use | Market interpretation only |
| `EV-B-MKT-01..03` | Competitor pricing | First-party public menu comparators | Transaction evidence, true comparability, demand, site radius | `PUBLIC_LISTING_ONLY` | Preserve access date; add matched competitors after site selection | Price-positioning confidence |
| `EV-B-GAP-01..03` | Site economics/demand | Gap is explicitly identified | Exact site, footfall/daypart/channel observations, lease/utilities | `OWNER_INPUT_REQUIRED`; `PHYSICAL_MEASUREMENT_REQUIRED`; `SUPPLIER_DOCUMENT_REQUIRED` | Owner, operator, landlord documents | Location viability |
| `EV-C02-001..003` | CORE-02 confirmed semantics | Stable attempts, fail-closed unresolved evidence, immutable acceptance outcomes, Candidate Ticket quarantine | Physical enforcement remains later Gate work | `VERIFIED_PRIMARY` | Preserve policy; independent design review after input closure | Gate A submission, not current research |
| `EV-C02-004..010` | CORE-02 policy gaps | Seven exact worksheet questions and scenario catalogue | Evidence classes, attestation, recipient linkage, threshold, scenario consequences, resolver, provenance/retention | `OWNER_INPUT_REQUIRED`; some `QUALIFIED_PROFESSIONAL_REQUIRED` | Operations + Privacy/Legal/Governance evidence, then Owner | CORE-02 Owner decision/Gate A review |
| `EV-C04-001` | CORE-04 confirmed policy | Acknowledgement ≠ approval/Close; Owner escalation; immutable linked corrections; zero discrepancy tolerance; unreconciled reporting hold | No authority assignment follows | `VERIFIED_PRIMARY` | Preserve policy | None by itself |
| `EV-C04-002..007` | CORE-04 policy gaps | Ten worksheet questions cover authority through retention | Capability/delegation/separation, corrections, discrepancy, reconciliation/release, readers, retention | `OWNER_INPUT_REQUIRED`; `QUALIFIED_PROFESSIONAL_REQUIRED` | Cash/Accounting/Reporting/Identity/Privacy input then Owner | CORE-04 Gate A review and reporting |
| `EV-E-001..007` | Core operational flow | Confirmed boundaries across Catalog, Ordering, Payment, Preparation, Cash, Reporting and ADR-0011 | Price-scope conflict; Refund/cancellation; custody/Cash authority; reporting authority; physical mechanisms | `VERIFIED_PRIMARY` plus stated open matters | Owner/professional inputs; later Gate reviews | Domain-specific Gates |
| `EV-F-BIZ-01..RET-01` | Vietnam regulation | Current official registration, VAT/tax, accounting, food-safety, privacy and labor sources | Applicability facts and professional interpretation | `VERIFIED_PRIMARY`; conclusions `QUALIFIED_PROFESSIONAL_REQUIRED` | Qualified Vietnamese professionals after Owner supplies facts | Operational policy, FOA/Production later |

## 5. Workstream A — Commercial V1 findings

### 5.1 Coverage and costing threshold

All 28 Products and 52 priced combinations reconcile. The costing CSV has 52 rows and 37 columns; every row is `MISSING_INPUT`. The MAKE template covers 24 Products/48 combinations and every Recipe state remains missing/not Owner-approved. The BUY template covers four Products/four combinations and every verification state remains missing. Therefore:

- evidence-backed unit cost: **0/52**;
- evidence-backed gross margin: **0/52**;
- approved AFTER FOUR Recipes: **0**; and
- public Recipe coverage: 22/24 MAKE Products have some quantified comparison evidence, but only four have two independent, reasonably comparable named-Product publisher families.

Admission to evidence-backed costing requires the complete applicable path: accepted Product/Ingredient or finished-product specification; approved Recipe/BOM quantity for the exact Variant; documentary purchase unit/conversion and actual/accepted cost; measured or explicitly classified yield/waste/batch allocation; channel packaging; delivery/landed-cost evidence; and applicable documentary dates. A planning estimate must remain labelled `ESTIMATE` and cannot be presented as actual cost or margin.

### 5.2 Material new public evidence

- **Bơ xay dừa non:** a Wonderfarm product declaration documents a processed coconut-water-with-pulp form, while HTK and Viet Thien Phu listings distinguish frozen young-coconut flesh formats. These sources prove that materially different Ingredient forms exist; they do not identify the intended AFTER FOUR Product. Bơ xay dừa non remains blocked before practical testing. Sources: [Wonderfarm declaration](https://www.wonderfarmonline.com/storage/hstcb-nuoc-dua-tuoi-wonderfarm-co-com-dua-181125-04122025.pdf), [HTK young coconut meat](https://htk.com.vn/san-pham/young-coconut-meat-iqf/), [Viet Thien Phu frozen coconut meat](https://vtpindustrial.com/product/frozen-coconut-meat/), and [BBC Good Food coconut-water explanation](https://www.bbcgoodfood.com/health/nutrition/health-benefits-coconut-water).
- **Cam ép:** a public orange-yield comparator gives approximately six navel oranges for two cups of juice, but does not establish local Vietnamese fruit grade, mass, equipment yield, S/M/L allocation, or waste. It remains insufficient for costing. Source: [Food Network Garibaldi recipe](https://www.foodnetwork.com/recipes/garibaldi-7524952).
- **Khoai tây chiên:** Potatoes USA references document multiple frozen formats and a 1 kg/six-serving loaded-fries comparator, not an AFTER FOUR plain-fries portion or yield. Owner selection, supplier instructions, and physical measurement remain required. Sources: [Frozen Potato Reference Guide](https://potatoesusa.com/wp-content/uploads/Frozen-Potato-Reference-Guide.pdf) and [2020 cookbook](https://potatoesusa.com/wp-content/uploads/2020/04/WORLD%E2%80%99s-BEST-POTATOES-2020-EN-Version.pdf).
- **BUY_FINISHED:** croissant, cheesecake, brownie, and muffin sources provide retail or supplier-capability leads only. They do not establish an accepted finished specification, wholesale price, Hoi An delivery, landed cost, VAT evidence, or actual purchase. See the CSV items `CE-COM-009..014` for source-level limitations.

The current source leads do not justify changing any canonical commercial input template.

## 6. Workstream B — Hoi An market evidence

Official sources support a large, international-heavy tourism context. The Hoi An heritage authority reports more than 4.4 million visitors in 2024 and 2.8 million in the first half of 2025; a defined set of Center-managed sites reports 1,296,796 visits in 2025. A separate heritage review reports approximately 1,695,000 ticketed heritage-site visitors for 2025. These figures have different scopes and must not be merged or averaged. Sources: [Hoi An overview](https://www.hoianworldheritage.org.vn/vi/news/Dat-va-nguoi-Hoi-An/hoi-an-diem-sang-giu-gin-va-phat-huy-gia-tri-di-san-2920.hwh), [Center-managed venues](https://hoianheritage.danang.gov.vn/vi/news/Tin-tuc-su-kien/tinh-hinh-khach-tham-quan-cac-diem-bao-tang-di-tich-do-trung-tam-bao-ton-di-san-van-hoa-the-gioi-hoi-an-quan-ly-nam-2025-1703.html), and [2026 heritage review](https://hoianheritage.danang.gov.vn/en/specialised-exchanges/research-exchange/key-priorities-in-the-conservation-and-promotion-of-the-cultural-heritage-values-of-hoi-an-ancient-town-in-2026-16.html).

Hoi An Roastery's first-party menu supplies premium Old Town comparators, including phin đen at VND 55,000, phin sữa at VND 60,000, and food comparators. These are public listings, not proof of transactions or AFTER FOUR demand. SEN Village is a hospitality comparator whose price/tax presentation cannot be imported into AFTER FOUR policy. Sources: [Hoi An Roastery menu](https://hoianroastery.com/menu/), [Vietnamese menu](https://hoianroastery.com/vi/menu/), and [SEN Village menu](https://www.senvillagehoian.com/wp-content/uploads/sites/127/2026/03/Menu-ALC-SENTA.pdf).

No responsible site-level conclusion is possible until the Owner supplies the actual address/premises, intended hours and capacity. Operator counts must then measure pedestrian flow, daypart, weekday/weekend, weather, and channel signals. Actual landlord/lease and utility documents are required for viability; online asking rents are not accepted cost evidence.

## 7. Workstream C — CORE-02 customer custody transfer

Confirmed semantics remain fixed: Model A retains `transfer_evidence_unresolved` nonterminal within the same stable attempt; conflict/dispute stays fail-closed and append-only; `transferred` requires sufficient approved evidence plus authorized disposition of every conflict; Candidate Ticket/Items remain quarantined without exact accepted binding; and Preparation completion, acknowledgement, custody transfer, Order closure, Cash handover, Payment settlement, and Refund are separate facts.

The unresolved evidence set exactly matches `WS-C02-01..07`:

1. accepted evidence classes;
2. attestation authority, sufficiency, and separation;
3. intended-recipient or authorized-recipient linkage;
4. minimum positive evidence threshold;
5. refusal, absence, unavailable, ambiguous, mismatch, and conflict consequences;
6. conflict-disposition authority; and
7. provenance, revision, access, retention, correction, and legal-hold envelope.

Public research cannot appoint an attester, resolver, or recipient-linkage mechanism. Operations must supply real dine-in/takeaway scenarios and abuse/error constraints; the Owner must select policy; qualified Privacy/Legal review is required before selecting personal-data-heavy evidence such as photographs, signatures, phone linkage, or recordings.

## 8. Workstream D — CORE-04 Cash, reconciliation, and reporting

Confirmed policy remains: Cash acknowledgement is not approval; acknowledgement does not Close the outgoing Session; refusal/disagreement escalates to Owner; Close is separate; closed evidence is immutable and corrections are linked facts; every nonzero discrepancy requires a reason and Owner notification; unreconciled Cash facts are withheld from authoritative reporting; discrepancy disposition does not grant report release; and report release does not grant read, export, or delivery authority.

The worksheet's `WS-C04-01..10` correctly separates authority source, delegation, separation, post-close correction, handover disagreement consequence, discrepancy investigation/disposition, reconciliation evidence, report release, report readers, and retention/legal hold. No holder, delegate, resolver, reporter, correction operation, or retention period can be inferred.

One canonical synchronization defect remains: the older `ODB-CASH-15` wording says escalation is unresolved, while later confirmed `CORE-OD-14A` states refusal/disagreement escalates to Owner. The current worksheet correctly preserves Owner as escalation destination while leaving disposition authority unresolved. This is a documentation consistency issue, not an open policy choice and not corrected in this evidence-only package.

## 9. Workstream E — end-to-end core operational evidence

| Domain | Confirmed conclusion | Material unresolved evidence |
|---|---|---|
| Catalog/Pricing | Catalog owns current definitions; Ordering owns confirmed snapshots; Price Versions are immutable | `CORE-OD-18` first-Branch/no-default costing scope remains unreconciled with `ODB-CAT-07` chain-default/Branch overrides; tax/rounding remain deferred |
| Ordering/POS | Dine-in/takeaway supported; no mandatory Table Session, zero-price Item, direct sold-price override, price-changing Modifier, or automatic cancellation in initial slice | Catalog-backed construction, cancellation authority/consequences, runtime authorization and public API |
| Payment | Initial exact-balance cash only; manual bank excluded; settlement does not close Order; cancellation is not Refund | Refund authority/allocation, overpayment, provider reconciliation, split/partial payment |
| Preparation | Item-level progress; no quantity-level progress, partial Ticket completion or partial handover; explicit custody transfer after completion | Dispatch acceptance/custody evidence, resolver authority, actual KDS/consumer and Gate B enforcement |
| Cash | Cash is distinct from Payment, custody transfer and Reporting | Capability/delegation, corrections, discrepancy, reconciliation and report release |
| Reporting | Initial source lineage is bounded; Cash-dependent facts remain held; Excel and external delivery deferred | Reader, release, export/delivery, metrics and retention authority; no physical reporting store selected |

ADR-0011 requires explicit cross-context contracts and preserves source-domain ownership. It does not authorize shared aggregates, cross-context database transactions, FKs, locks, persistence, worker topology, or implementation.

## 10. Workstream F — Vietnamese regulatory and professional evidence

The current official-source set is:

- enterprise registration: [Decree 168/2025/NĐ-CP](https://vanban.chinhphu.vn/?classid=1&docid=214334&pageid=27160&typegroupid=4), issued 2025-06-30 and effective 2025-07-01, amended by [Decree 296/2026/NĐ-CP](https://vanban.chinhphu.vn/?classid=1&docid=218986&pageid=27160), issued/effective 2026-07-23;
- VAT: [Law 48/2024/QH15](https://vanban.chinhphu.vn/?docid=212476&orggroupid=1&pageid=27160), issued 2024-11-26 and effective 2025-07-01, and the current implementation/amendment chain including [Decree 144/2026/NĐ-CP](https://vanban.chinhphu.vn/?docid=218020&pageid=27160), issued 2026-05-05 and effective 2026-06-20;
- tax administration and e-invoices: [Law 108/2025/QH15](https://vanban.chinhphu.vn/?docid=216541&orggroupid=1&pageid=27160), issued 2025-12-10 and effective 2026-07-01, plus [Decree 254/2026/NĐ-CP](https://vanban.chinhphu.vn/?docid=218689&orggroupid=2&pageid=27160) and [Circular 91/2026/TT-BTC](https://vanban.chinhphu.vn/?docid=219006&pageid=27160), issued 2026-06-30 and effective 2026-07-01;
- accounting: [Accounting Law 88/2015/QH13](https://vanban.chinhphu.vn/?classid=1&docid=183198&pageid=27160&typegroupid=3), issued 2015-11-20 and effective 2017-01-01, and [Decree 174/2016/NĐ-CP](https://vanban.chinhphu.vn/?docid=187897&pageid=27160), issued 2016-12-30 and effective 2017-01-01;
- food safety: [Law 55/2010/QH12](https://vanban.chinhphu.vn/?classid=1&docid=96032&pageid=27160&typegroupid=3), issued 2010-06-17 and effective 2011-07-01, remains the primary statute identified here. [Decree 46/2026/NĐ-CP](https://vanban.chinhphu.vn/?docid=216827&orggroupid=2&pageid=27160), issued/effective 2026-01-26, was initially suspended through 2026-04-15 by [Resolution 09/2026/NQ-CP](https://vanban.chinhphu.vn/?docid=216891&pageid=27160), issued/effective 2026-02-04. That scheduled 2026-04-16 resumption did not occur: [Resolution 15/2026/NQ-CP](https://chinhphu.vn/?docid=217667&pageid=27160), issued/effective 2026-04-06, replaced Resolution 09 and suspended Decree 46 until both the amended Food Safety Law and its implementing decree take effect. Resolution 15 Article 2 states that [Decree 15/2018/NĐ-CP](https://vanban.chinhphu.vn/?docid=192829&pageid=27160) and its implementing/guidance instruments continue in force during that suspension; Article 5(1) makes Resolution 15 effective on signature and replaces Resolution 09. Official National Assembly records show the amended-law bill was [presented and discussed on 2026-10-24](https://quochoi.vn/tintuc/Pages/su-kien-noi-bat.aspx?ItemID=102467) and considered for explanation/revision by the Standing Committee on [2026-11-17](https://media.quochoi.vn/Home/AlbumDetails/51113). The [Second Session results published on 2026-11-21](https://quochoi.vn/tintuc/Pages/tin-hoat-dong-cua-quoc-hoi.aspx?ItemID=103162) do not list it among enacted laws, while the [official legislative schedule](https://quochoi.vn/tintuc/Pages/tin-hoat-dong-cua-quoc-hoi.aspx?ItemID=101723) proposed consideration for passage at the Third Session in May 2027. That schedule is not enactment or an effective date. At the 2026-11-24 cutoff, the bill therefore had not taken effect, Decree 46 remained suspended, and the stated termination condition had not occurred;
- personal data: [Law 91/2025/QH15](https://vanban.chinhphu.vn/?classid=1&docid=214590&pageid=27160&typegroup=), issued 2025-06-26 and effective 2026-01-01, and [Decree 356/2025/NĐ-CP](https://vanban.chinhphu.vn/?classid=1&docid=216387&orggroupid=2&pageid=27160), issued 2025-12-31 and effective 2026-01-01;
- labor: the [2026 consolidated Labor Code](https://vanban.chinhphu.vn/?classid=0&docid=217002&pageid=27160), consolidated 2026-02-12 without a new effective date, whose underlying Law 45/2019/QH14 was issued 2019-11-20 and effective 2021-01-01; and [Decree 293/2025/NĐ-CP](https://vanban.chinhphu.vn/?docid=215832&pageid=27160), issued 2025-11-10 and effective 2026-01-01, which remains the current minimum-wage instrument at this cutoff; and
- future minimum wage: [Decree 399/2026/NĐ-CP](https://vanban.chinhphu.vn/?docid=220166&pageid=27160&typegroupid=4) is issued but does not take effect until 2027-01-01.

These instruments establish the current research baseline, not AFTER FOUR's exact obligations. Legal form, taxpayer status, Branch ward/premises, products/processes, invoice flow, workers, personal-data fields/purposes/recipients, and record classes are required applicability facts. Decree 13/2023 and Decree 70/2025 must not be cited alone as the current privacy or invoice baseline. Decree 15/2018 continues during the Resolution 15 suspension, but it likewise cannot by itself determine AFTER FOUR's premises-, Product-, process-, licensing-, or exemption-specific obligations.

## 11. Workstream G — non-public collection register

| Collection group | Exact evidence required | Provider | Unlocks | Blocks all work? |
|---|---|---|---|---|
| Signature tests | R04/R05 and selected first-size R12/R13 records; Ingredient SKUs; vessels; ice; time; output/loss; sensory/repeats | Owner + operator/tester | Candidate Recipe review and measured yield | No; only affected Recipes/costing |
| Remaining MAKE | Exact Recipe/BOM, Ingredient/substitute, per-Variant quantities, reusable component allocation | Owner/culinary | Supplier matching and test plan | Only affected combinations |
| Fruit/fries | Local orange input/output/waste; fries SKU/portion/pre/post-cook/oil/waste | Operator/tester + supplier docs | Cam/fries Recipe and cost | Only those Products |
| BUY Products | Accepted finished specification, SKU/pack, quote/invoice, delivery, VAT statement, storage/shelf life/traceability | Owner + supplier | Four BUY costs | Only four BUY rows |
| Packaging | Dine-in/takeaway identity, fit, quantity, pack conversion and accepted price | Owner/operator + supplier | Channel-correct cost | Costing, not Recipe research |
| CORE-02 operations | Real refusal/absence/mismatch/conflict cases, attester responsibilities, linkage needs | Operations + Owner | Seven custody decisions | CORE-02 Gate A review |
| CORE-04 operations | Per-operation responsibilities, correction/discrepancy cases, reconciliation/report consequences | Cash/Accounting/Reporting + Owner | Ten Cash/reporting decisions | CORE-04 Gate A review |
| Professional opinions | Tax/invoice/accounting, food safety, privacy/custody evidence, labor, retention by record class | Qualified Vietnamese professionals | Owner policy and later operational acceptance | Relevant policy/FOA only |
| Market/site | Actual address, hours/capacity, footfall/daypart/channel observations, lease/utilities | Owner/operator/landlord documents | Viability and matched competitor radius | Location decision only |

## 12. Conflicts, stale evidence, and unsupported claims

1. `CORE-OD-18` and `ODB-CAT-07` remain an explicit pricing-scope conflict before publication or implementation.
2. `ODB-CASH-15` contains stale escalation wording relative to confirmed `CORE-OD-14A`.
3. Hoi An tourism figures use different citywide, managed-site, and ticketed-heritage scopes; they cannot be summed or averaged.
4. Public Recipes, manufacturer formulations, competitor menus, public supplier listings, and retail prices remain illustrative/reference evidence.
5. A retail listing is not an accepted quotation, actual purchase cost, delivery evidence, or VAT conclusion.
6. Resolution 09's scheduled 2026-04-16 resumption is stale if presented as the current food-safety timeline: Resolution 15 replaced Resolution 09 on 2026-04-06, keeps Decree 46 suspended until its stated two-instrument termination condition occurs, and continues Decree 15/2018 plus related implementing/guidance instruments during the suspension. Older privacy and invoice instruments are likewise stale if presented alone as current at 2026-11-24.
7. Logical ERD/Data Dictionary records are not physical schema approval or implementation evidence.
8. Long-term Owner Dashboard/Telegram direction and initial-slice reporting deferrals must retain their temporal distinction.

No confirmed Owner decision is reopened by these conflicts.

## 13. Ranked critical path and parallel execution

### 13.1 Immediate and parallel

1. **Owner consolidated input session:** identify first Branch site facts; select Bơ xay dừa non Ingredient form; define Cam/fries and four BUY acceptance specifications; identify actual Signature-test Ingredients/equipment/vessels; supply CORE-02/04 operational responsibility facts without answering unsupported policy prematurely.
2. **Operator field work:** run R04/R05 and one selected-size R12/R13 comparison; measure vessels/ice/output/loss/time; conduct site/daypart counts after a site exists. These streams are independent.
3. **Supplier document preparation:** after explicit contact authorization, request exact SKU/specification, pack/unit/conversion, handling/shelf life/traceability, quotation/invoice, delivery/landed cost, and VAT statement for Owner-approved specifications.
4. **Qualified reviews:** tax/accounting/e-invoice, food safety, privacy/custody evidence, labor, and retention may proceed in parallel once entity/site/workflow/data facts and engagement authority exist.
5. **CORE policy sessions:** review `WS-C02-01/02/03/07` in parallel, then `04`, then `05/06`; review `WS-C04-01/02/03`, then `04/06`, then `07` before `08`; keep `09/10` separate.

### 13.2 Later gates

Only after the applicable Owner policies and evidence are closed should independent design review determine bounded Gate A submission. Physical schema, transactions, locks, persistence, APIs, runtime authorization, workers, and deployment remain later Gate B/C matters. Research completion itself grants nothing.

## 14. Explicit limitations and current readiness

Genuinely ready now:

- Owner/operator use of the existing Signature field-test protocol;
- a consolidated Owner input session using the existing CORE-02/04 worksheet;
- site-specific observation planning once the site is supplied; and
- scoped professional-review preparation once actual applicability facts and engagement authority exist.

Blocked:

- all 52 evidence-backed costs/margins;
- Bơ xay dừa non practical testing;
- Cam/fries costing;
- all four BUY procurement costs;
- CORE-02 and CORE-04 Owner policy closure/Gate A review;
- site viability conclusions; and
- legal, tax, accounting, privacy, food-safety, labor, retention, FOA, and Production conclusions.

This package changes no Owner Decision Baseline row, worksheet answer, input template, architecture, code, schema, migration, API, database, runtime, Gate, implementation authorization, FOA, or Production Authorization.
