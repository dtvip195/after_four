# AFTER FOUR — Commercial Workstream 03 Initialization Report

**Assessment date:** 2026-11-27  
**Workstream:** Commercial Evidence & Unit Economics Foundation  
**Phase:** CE-01 — Baseline Reconnaissance  
**Authority:** Read-only repository inspection plus creation of this report only  
**Repository:** `/Users/tad/project/after_four`  

## 1. Executive conclusion

The repository has a coherent, evidence-safe Commercial V1 baseline. The canonical menu and pricing chain records 28 approved launch Products and 52 unique Product/Variant costing combinations. Direct CSV parsing confirms 48 `MAKE_IN_HOUSE` combinations and four `BUY_FINISHED` combinations. All 52 canonical costing rows remain `MISSING_INPUT`; all 48 MAKE Recipe/BOM rows remain `MISSING_INPUT_NOT_OWNER_APPROVED`; all four BUY procurement rows remain `MISSING_INPUT`; and no unit-cost or gross-margin result is populated.

The governing Milestone A report and intake workbook reconcile exactly 32 atomic gaps. Only the conditional internal synchronization row is closed for the current baseline; it reopens on a later applicable decision or evidence change. The other 31 gaps require Owner-supplied facts or decisions, real operations, physical evidence, commercial/procurement evidence, qualified professional input, or genuine independent review. No remaining gap is closable by another Codex-only documentation sprint.

This initialization found no controlling commercial conflict. It did find historical documents whose pre-`CORE-OD-18` missing-price findings must not be treated as current, public market-price and recipe evidence that must not be promoted into procurement or Recipe/BOM evidence, and concurrent POS/security-audit documentation work that must remain isolated.

Milestone A remains **`MILESTONE_A_NOT_COMPLETE_BUT_ALL_INTERNAL_WORK_CLOSED`** as recorded by the governing report. This report does not reopen settled menu decisions, approve a Recipe/BOM, authorize a trial or supplier contact, or claim Milestone A completion.

## 2. Verified repository baseline

### 2.1 Git snapshot before this report

| Item | Verified value |
|---|---|
| Branch | `development` |
| HEAD | `7efb60b028de02126e8fc01762203f385005019e` |
| HEAD subject | `Merge pull request #135 from dtvip195/docs/pos-2a-gate-a-owner-decision` |
| Upstream relation | `development...origin/development`; `0` ahead / `0` behind by `git rev-list --left-right --count` |
| Staged files | None |
| Modified tracked files | `docs/architecture/after_four_pos_business_features_status.md` |
| Untracked files | `docs/architecture/after_four_pos_milestone_2a_gate_b_implementation_authorization_package.md`; `docs/research/organization_level_audit_executable_acceptance_authorization_package.md`; `docs/research/pos_milestone_2a_gate_b_repository_evidence.md` |

The modified/untracked files are concurrent POS Milestone 2A Gate B and Organization-Level Audit documentation. Their contents explicitly preserve non-authorization boundaries. They are evidence that concurrent work has changed the worktree, but not that POS source code, database schema, migrations, or commercial inputs changed. This investigation did not modify or stage them.

### 2.2 Workstream isolation

| Boundary | Result |
|---|---|
| Frontend/backend source | Not modified |
| Database schema, migrations, or `structure.sql` | Not modified |
| Authentication/authorization | Not modified |
| POS business workflows | Not modified |
| POS Gate B concurrent documents | Inspected only; not modified |
| Organization-Level Audit concurrent document | Inspected only; not modified |
| Commercial application/database | Not created |
| Git stage/commit/push/merge/branch switch | Not performed |
| Canonical decision documents | Not modified |

The only authorized repository write in Workstream 03 initialization is this report.

### 2.3 Git status before/after comparison

| State | Branch / HEAD | Staged | Modified tracked | Untracked |
|---|---|---|---|---|
| Before investigation report | `development` / `7efb60b028de02126e8fc01762203f385005019e` | None | `docs/architecture/after_four_pos_business_features_status.md` | Three pre-existing POS/audit documents listed in §2.1 |
| After report creation | `development` / `7efb60b028de02126e8fc01762203f385005019e` | None | Same one pre-existing POS status document | Same three pre-existing POS/audit documents, plus `docs/research/AFTER_FOUR_COMMERCIAL_WORKSTREAM_03_INITIALIZATION_REPORT.md` |

The branch and HEAD did not change. SHA-256 checks of the four pre-existing modified/untracked POS and audit documents were unchanged between snapshots. No independently occurring worktree change appeared during this investigation.

## 3. Commercial artifact inventory

### 3.1 Controlling and operational artifacts

| Role | Artifact | Current authority/status |
|---|---|---|
| Canonical Owner decisions | [Owner Decision Baseline](../architecture/after_four_owner_decision_baseline.md) | Highest repository authority for confirmed Owner decisions. `CORE-OD-01` approves the 28-row draft menu by reference; `CORE-OD-18` approves the 52-combination Commercial V1 costing baseline. |
| Owner decision intake | [CORE-02 / CORE-04 Owner Decision Worksheet](../architecture/after_four_core_02_core_04_owner_decision_worksheet.md) | Governs unresolved questions, evidence taxonomy, milestone rules, R04/R05 checkpoints, and the six deferred references. It is not a substitute for Owner decisions. |
| Evidence intake | [Milestone A Evidence Intake Workbook](../architecture/after_four_milestone_a_evidence_intake_workbook.md) | Active routing workbook for the same 32 gaps. Section 7 is the consolidated R04/R05 inspection/readiness record; section 8 routes costing/procurement evidence. |
| Governing gap register | [Milestone A Comprehensive Evidence and Decision Gap Report](after_four_milestone_a_comprehensive_evidence_and_decision_gap_report.md) | Current 32-gap identity, classification, status, dependencies, execution axes, and Milestone A verdict. |
| Approved menu reference | [Proposed Launch Menu v3](../architecture/after_four_proposed_launch_menu_v3.md) | 28 named Products, six groupings, and presented options approved by reference under `CORE-OD-01`; does not approve Recipe/BOM or implementation. |
| Pricing/costing specification | [Real Menu & Pricing Specification](../architecture/after_four_real_menu_pricing_specification.md) | `CORE-OD-18` source for 52 exact costing combinations and proposed VND selling-price inputs; no publication, tax, rounding, Recipe, cost, margin, or implementation authority. |

### 3.2 Canonical Commercial V1 CSV set

| Artifact | Parsed rows | Verified role and state |
|---|---:|---|
| [Buy-vs-Make Owner input](../architecture/after_four_commercial_v1_buy_vs_make_owner_input.csv) | 28 | 24 `MAKE_IN_HOUSE`, 4 `BUY_FINISHED`, all 28 `OWNER_CONFIRMED`. Buy/Make allocation only. |
| [MAKE Recipe/BOM input](../architecture/after_four_commercial_v1_make_recipe_bom_input.csv) | 48 | One row per MAKE combination; all 48 `MISSING_INPUT_NOT_OWNER_APPROVED`. |
| [BUY finished-product procurement input](../architecture/after_four_commercial_v1_buy_finished_procurement_input.csv) | 4 | Four BUY Products; all four `MISSING_INPUT`; accepted specification fields are blank. |
| [Canonical costing input](../architecture/after_four_commercial_v1_costing_input.csv) | 52 | 52 unique Product/Variant keys across 28 Products; 48 MAKE/4 BUY; all 52 `MISSING_INPUT`; no unit cost or margin populated. |

These are the only CSVs under `docs/architecture/` matching `after_four_commercial_v1_*.csv`. The CSV structures are ready to receive attributable evidence but contain no approved Recipe/BOM, accepted procurement chain, or calculable cost.

### 3.3 MAKE, BUY, signature-test, and R04/R05 supporting evidence

| Evidence family | Artifacts | Boundary |
|---|---|---|
| MAKE research inputs | [Public recipe and quantity research](after_four_commercial_v1_recipe_quantity_research.md); [external ingredient and supplier research](after_four_commercial_v1_external_ingredient_supplier_research.md) | Research/reference evidence only. Public formulations, SKUs, and prices do not establish an AFTER FOUR Recipe, BOM, supplier, transaction, yield, waste, or packaging allocation. |
| BUY/procurement gap definition | [Commercial V1 Cost Evidence Collection Gaps](after_four_commercial_v1_cost_evidence_collection_gaps.md) | Defines the smallest acceptable evidence chain; does not supply the evidence. |
| Signature testing | [Commercial V1 Signature Practical Test Protocol](after_four_commercial_v1_signature_practical_test_protocol.md) | Authoritative source formulations, independent R04/R05 run identities, blank raw run sheets, readiness checks, and evidence handoff. No trial authority or completed result. |
| Consolidated inspection/readiness | [Evidence Intake Workbook §7](../architecture/after_four_milestone_a_evidence_intake_workbook.md#7-r04r05-physical-evidence-routing) | Authoritative pre-authorization physical inventory and inspection routing. All applicable inspection/check fields remain pending/not recorded/not checked. |
| R04/R05 public market research | [R04/R05 Market Price Research](after_four_r04_r05_market_price_research.md) | `MARKET_REFERENCE_ONLY`; no listing is procurement, physical identity, cost, formulation, tolerance, or trial authorization. |
| R04/R05 structured ingredient observations | [Ingredient market prices CSV](after_four_r04_r05_ingredient_market_prices.csv) | Public observations only. |
| R04/R05 structured equipment observations | [Equipment market prices CSV](after_four_r04_r05_equipment_market_prices.csv) | Public observations only; specifications do not prove actual instrument capability. |
| R04/R05 kit mapping | [Trial-kit market mapping CSV](after_four_r04_r05_trial_kit_market_mapping.csv) | Maps candidates to trial needs while preserving evidence gaps and non-authorization. |
| Broader evidence inventory | [Comprehensive Evidence Research and Closure Report](after_four_comprehensive_evidence_research_and_closure_report.md); [machine-readable evidence register](after_four_comprehensive_evidence_register.csv) | Historical/supporting evidence map. Current Owner authority and 32-gap state remain in the baseline, worksheet, workbook, and governing gap report. |

The complete CSV inventory for this foundation is therefore eight files: the four canonical Commercial V1 inputs in §3.2, the comprehensive evidence register, and the three R04/R05 market-reference CSVs above. Only the four Commercial V1 inputs are canonical costing/evidence-intake destinations; the other four are research evidence indexes or market-reference datasets.

### 3.4 Duplicate, historical, superseded, and conflicting material

| Finding | Assessment and handling |
|---|---|
| Repeated 28/52/48/4 and 0/52 summaries | Deliberate reconciliation across the pricing specification, CSVs, workbook, cost-gap report, comprehensive evidence report, and governing gap report. Counts agree; these are duplicate assertions, not competing authorities. |
| [CORE-01 Commercial Evidence Closure — Sprint 2](after_four_core_01_commercial_evidence_closure_sprint_2.md) | Historical pre-`CORE-OD-18` assessment, superseded for exact-price/commercial-baseline status by the later canonical decision and pricing specification. Its old missing-price finding is not a controlling conflict. |
| [CORE-01 Qualified Commercial Input — Sprint 1](after_four_core_01_qualified_commercial_input_sprint_1.md) | Contains an explicit subsequent-current-status notice: early missing-price rows are superseded/historical and must not be used as current Commercial V1 status. Its current `CORE-OD-03/04` blockers remain consistent, so it is not a controlling conflict. |
| Public recipe/market/supplier documents | They intentionally contain alternative or conflicting public candidates (for example recipe quantities and one public price). Each is labelled reference-only or unverified. The conflicts are evidence limitations, not canonical decision conflicts. |
| R04 and R05 records | Similar fields are intentional duplication for independent tracks. Values, checks, and results must not be copied or merged across tracks. |
| Controlling commercial chain | No incompatible assertion found among the Owner Decision Baseline, pricing specification, four canonical CSVs, workbook, and governing 32-gap report. |

## 4. Evidence integrity assessment

### 4.1 Reproduced counts

The four canonical CSVs were parsed as CSV rather than counted as text lines.

| Check | Result |
|---|---:|
| Owner-confirmed Product rows | 28 |
| Unique Products in canonical costing input | 28 |
| Unique Product/Variant keys | 52 |
| MAKE Products | 24 |
| MAKE combinations | 48 |
| BUY Products/combinations | 4 / 4 |
| Canonical rows with `verification_status = MISSING_INPUT` | 52/52 |
| MAKE rows with `recipe_approval_status = MISSING_INPUT_NOT_OWNER_APPROVED` | 48/48 |
| BUY rows with `verification_status = MISSING_INPUT` | 4/4 |
| Nonblank unit-cost results | 0/52 |
| Nonblank gross-margin amounts | 0/52 |
| Nonblank gross-margin percentages | 0/52 |

The known commercial baseline is therefore verified without assumptions. Public listed prices remain outside actual quotation, purchase, landed-cost, unit-cost, and margin fields.

### 4.2 Existing Owner decisions versus unresolved decisions

**Existing Owner decisions preserved:** the 28 named Product baseline and menu groupings/options under `CORE-OD-01`; the exact 52 costing combinations and proposed selling-price inputs, equal dine-in/takeaway prices, First-Branch/first-Price-Version scope, and no active chain-default/Branch override under `CORE-OD-18`; 24 MAKE Products and four BUY Products confirmed in the Owner-input CSV; and the provisional R04 preparation checkpoint, which is not a Recipe, Ingredient, supplier, purchase, or trial approval.

**Unresolved or deferred:** `CORE-OD-03` tax/display/invoice applicability; `CORE-OD-04` calculation precision and rounding; First Branch documentary facts voluntarily deferred by the Owner; all 11 residual `WS-C02`/`WS-C04` Owner decisions; exact R05 inputs and applicable instrument requirements; R04/R05 physical readiness and separate trial authorizations; every Recipe/BOM and procurement evidence chain; channel packaging fit/cost; supplier/RFQ/acquisition authority; and independent reviews.

## 5. Current 32-gap status

The 32 rows below are the **full cross-domain Milestone A register**, not 32 exclusively commercial gaps. Workstream 03 must retain the full register because commercial readiness depends on tax/rounding, First Branch facts, synchronization, and final milestone review, while the governing report also tracks CORE-02 custody and CORE-04 Cash/reporting gaps owned by other workstreams.

The direct commercial subset is nine rows: `CORE-OD-03`, `CORE-OD-04`, First Branch legal/entity/Product/channel facts, R04/R05 readiness documents, `CM-R04-01`, `CM-R05-01`, 48 MAKE combinations, four BUY chains, and channel packaging. Post-decision synchronization and the final independent-review/milestone path are cross-cutting dependencies. The CORE-02, CORE-04, operational-event, and their independent-review rows remain visible for Milestone A integrity but do not transfer ownership to Workstream 03.

The table preserves the governing report's counting unit. Umbrella references are not counted again. Classification reconciles as 11 `OWNER_DECISION`, 1 `OWNER_FACT_CONFIRMATION`, 2 `OBSERVED_OPERATIONAL_EVIDENCE`, 1 `DOCUMENTARY_EVIDENCE`, 2 `PHYSICAL_TRIAL_EVIDENCE`, 3 `COMMERCIAL_OR_PROCUREMENT_EVIDENCE`, 9 `QUALIFIED_PROFESSIONAL_INPUT`, 1 `INTERNAL_DOCUMENTATION_GAP`, and 2 `INDEPENDENT_REVIEW`.

| # | Atomic gap | Current status | Closure dependency |
|---:|---|---|---|
| 1 | `CORE-OD-03` | `BLOCKED — NOT_READY_FOR_OWNER` | Deferred seller/registration/premises and Product/invoice facts; qualified Vietnamese Tax/Accounting analysis; Owner decision. |
| 2 | `CORE-OD-04` | `BLOCKED — NOT_READY_FOR_OWNER` | Actual calculation examples and qualified analysis including `CORE-OD-03` interactions; Owner decision. |
| 3 | `WS-C02-01` | `BLOCKED — QUALIFIED_INPUT_REQUIRED` | Actual evidence-source facts, privacy/governance analysis, Owner decision. |
| 4 | `WS-C02-02` | `BLOCKED — QUALIFIED_INPUT_REQUIRED` | Actual responsibility/separation facts, qualified controls, Owner decision. |
| 5 | `WS-C02-03` | `BLOCKED — QUALIFIED_INPUT_REQUIRED` | Recipient/linkage facts, privacy/governance constraints, Owner decision. |
| 6 | `WS-C02-04` | `BLOCKED — NOT_READY_FOR_OWNER` | Completed `WS-C02-01`–`03`, supported threshold analysis, Owner decision. |
| 7 | `WS-C02-05` | `BLOCKED — QUALIFIED_INPUT_REQUIRED` | Operational/customer consequence evidence, qualified constraints, Owner decision. |
| 8 | `WS-C02-06` | `BLOCKED — QUALIFIED_INPUT_REQUIRED` | Conflict/materiality/fraud/separation analysis, Owner authority decision. |
| 9 | `WS-C02-07` | `BLOCKED — QUALIFIED_INPUT_REQUIRED` | Populated data-category/flow inventory and authorized qualified Privacy/Legal/Governance input. |
| 10 | `WS-C04-01` / `CORE-OD-12` | `BLOCKED — QUALIFIED_INPUT_REQUIRED` | Actual responsibility facts, Cash/Accounting control input, Owner holder policy. |
| 11 | `WS-C04-02` / `CORE-OD-12` | `BLOCKED — QUALIFIED_INPUT_REQUIRED` | Continuity cases, governance/control analysis, Owner delegation/revocation policy. |
| 12 | `WS-C04-03` / `CORE-OD-12` | `BLOCKED — QUALIFIED_INPUT_REQUIRED` | Staffing/conflict feasibility, Accounting controls, Owner separation matrix. |
| 13 | `WS-C04-04` / `CORE-OD-13` | `BLOCKED — NOT_READY_FOR_OWNER` | Actual error cases, correction/authority analysis, Owner decision. |
| 14 | `WS-C04-05` | `BLOCKED — NOT_READY_FOR_OWNER` | Post-escalation disagreement cases, supported consequences, Owner decision. |
| 15 | `WS-C04-06` | `BLOCKED — QUALIFIED_INPUT_REQUIRED` | Discrepancy taxonomy/materiality and qualified investigation/consequence analysis. |
| 16 | `WS-C04-07` | `BLOCKED — QUALIFIED_INPUT_REQUIRED` | Complete source inventory, conflict/correction cases, qualified Accounting/Reporting analysis. |
| 17 | `WS-C04-08` | `BLOCKED — QUALIFIED_INPUT_REQUIRED` | Report inventory, reconciliation/exception evidence, qualified analysis, Owner preconditions. |
| 18 | `WS-C04-09` / `CORE-OD-16B` | `BLOCKED — QUALIFIED_INPUT_REQUIRED` | Report/category/purpose/Branch inventory and qualified Identity/Governance/Privacy input. |
| 19 | `WS-C04-10` / `CORE-OD-16F` | `BLOCKED — QUALIFIED_INPUT_REQUIRED` | Classified record inventory and qualified Legal/Privacy/Accounting-records opinion. |
| 20 | `WS-RPT-01` | `BLOCKED — QUALIFIED_INPUT_REQUIRED` | Qualified Accounting/Reporting analysis of completed scenarios; Owner category choices. |
| 21 | First Branch legal/entity/Product/channel facts | `OWNER_DEFERRED — PARTIALLY_SUPPLIED` | Voluntary Owner resumption, documentary facts, later qualified mapping. Do not repeat deferred requests. |
| 22 | `EA1-D01-*` custody events | `BLOCKED — NOT_OPERATING` | Lawful future operation, applicable policy/authority, real attributable events. |
| 23 | `EA1-D03-*` Cash/report events | `BLOCKED — NOT_OPERATING` | Lawful future operation, applicable controls, real attributable events. |
| 24 | R04/R05 readiness documents | `READY_FOR_EVIDENCE — NO_TRIAL_AUTHORITY` | Actual materials, labels/SKUs, equipment checks, vessels, ice/water, and measurement capability. |
| 25 | `CM-R04-01` | `BLOCKED — PHYSICAL_TRIAL_NOT_AUTHORIZED_OR_RUN` | R04-specific physical readiness, explicit bounded trial authorization, actual raw run evidence. |
| 26 | `CM-R05-01` | `BLOCKED — PHYSICAL_TRIAL_NOT_AUTHORIZED_OR_RUN` | R05-specific selection/readiness, explicit bounded trial authorization, independent raw evidence. |
| 27 | 48 MAKE combinations | `READY_FOR_EVIDENCE — 0/48 CALCULABLE` | Approved Recipe/BOM, measurements, conversions, yield/loss, transaction, packaging, and independent calculation review. |
| 28 | Four BUY chains | `READY_FOR_EVIDENCE — EXTERNAL_ACQUISITION_UNAUTHORIZED` | Owner-accepted specification, authorized supplier contact/acquisition, quotation, transaction, delivery/receiving, and loss evidence. |
| 29 | Channel packaging | `READY_FOR_EVIDENCE — NO_FIT_OR_COST_PROVEN` | Physical fit, quantity/sale, pack conversion, actual transaction and receiving evidence. |
| 30 | Post-decision canonical synchronization | `CLOSED_CURRENT_BASELINE — REOPENS_ON_TRIGGER` | Reopens only after an applicable Owner decision or accepted evidence change. |
| 31 | `CP3-E03` | `BLOCKED — NOT_READY_FOR_INDEPENDENT_REVIEW` | Closed/synchronized CORE-02 inputs, explicit review authority, genuine independent reviewer. |
| 32 | `CP3-E04` | `BLOCKED — NOT_READY_FOR_INDEPENDENT_REVIEW` | Closed/synchronized CORE-04 inputs, explicit review authority, genuine independent reviewer. |

## 6. Dependency graph

```text
Owner voluntarily resumes deferred seller/site facts
  -> documentary fact pack
  -> authorized qualified Tax/Accounting analysis
  -> CORE-OD-03
  -> actual worked examples + authorized qualified analysis
  -> CORE-OD-04
  -> canonical synchronization

Actual CORE-02 source/staffing/category facts
  -> authorized qualified input
  -> WS-C02-01..03/05..07
  -> WS-C02-04
  -> canonical synchronization
  -> authorized CP3-E03 independent review

Actual CORE-04 responsibility/source/report/record facts
  -> authorized qualified input
  -> WS-C04 / WS-RPT decisions in dependency order
  -> canonical synchronization
  -> authorized CP3-E04 independent review

Explicit material/contact/acquisition scope
  -> actual R04 readiness ----> separate R04 trial authorization -> raw R04 evidence --+
  -> actual R05 readiness ----> separate R05 trial authorization -> raw R05 evidence --+-> Recipe review
  -> accepted BUY specifications -> bounded supplier authority -> transaction/receiving evidence

Approved Recipe/BOM or BUY chain
  + actual purchase/conversion/yield/loss evidence
  + channel-specific packaging fit and cost
  + qualified tax/rounding boundary where applicable
  -> independently reproducible Product/Variant cost
  -> eligible gross-margin calculation

All applicable decisions + real evidence + synchronization + CP3-E03/E04
  -> six-criterion Milestone A reassessment
```

## 7. Dependency analysis by evidence provider

| Dependency class | Gaps/work | Can current internal documentation close it? | Required provider/event |
|---|---|---|---|
| Existing internal documentation | Preserve current trace; rerun validations after a real trigger; prepare exact existing artifacts for later evidence intake. | Current trace is already closed. No additional prose closes another gap. | Documentation maintainer only after an authorized decision/evidence trigger. |
| Physical evidence | R04/R05 readiness and `CM-R04-01`/`CM-R05-01`; measured Recipe/yield/loss. | No. Templates and public listings are not physical evidence. | Actual materials/equipment, Owner-designated operator/tester, separate trial authorization, raw measurements. |
| Supplier/commercial evidence | Four BUY chains, MAKE purchase inputs, channel packaging, landed costs. | No. Public sellers/prices are candidate market evidence only. | Owner-approved specifications, separately authorized contact/acquisition, supplier documents, transaction and receiving evidence. |
| Owner facts/decisions | First Branch fact pack; 11 residual Owner decisions; trial/contact/acquisition scopes; later Recipe/specification dispositions. | No. Existing settled menu/price/Buy-Make decisions must not be reopened. | Owner, after prerequisite evidence and qualified constraints exist. |
| Qualified professional input | Nine packages: `CORE-OD-03/04`, `WS-C02-07`, `WS-C04-06..10`, `WS-RPT-01`. | No. Public sources define constraints but not project-specific conclusions. | Explicitly commissioned qualified Vietnamese Tax/Accounting, Privacy/Governance/Legal/records, Cash/Reporting, or applicable professional reviewers. |
| Real operational evidence | `EA1-D01-*`, `EA1-D03-*`. | No. Simulations and templates are rejected substitutes. | Lawful future operation and attributable events under approved policy/authority. |
| Independent review | `CP3-E03`, `CP3-E04`. | No. Internal adversarial/self-review is not independence. | Explicit Owner authorization and genuinely independent reviewers after upstream closure. |

## 8. Internal work that can proceed without new authorization

Within the present read-only CE-01 boundary, the following non-closure work is safe:

1. Preserve and periodically re-verify the four canonical CSV invariants without populating evidence fields.
2. Maintain an inventory of already-existing artifacts and detect later repository changes without changing canonical policy.
3. Validate Markdown links, CSV parseability, row uniqueness, required blank fields, and cross-document counts.
4. Prepare a bounded future execution package that names prerequisites, permitted evidence classes, rejection rules, files to receive evidence, authorization gates, and stop conditions.
5. Re-run canonical synchronization only after an applicable, authorized Owner decision or accepted evidence change actually occurs.

These actions may protect evidence integrity, but they do not close any of the 31 open external/Owner/event/review gaps. The governing report's conclusion remains controlling: there is no further Codex-only documentation task that can truthfully produce Milestone A closure.

## 9. Work blocked pending Owner authorization or external state

The following must not start under CE-01:

- physical acquisition, inspection, or execution of R04/R05;
- supplier identification represented as acceptance, supplier contact, RFQ, disclosure, quotation acceptance, purchase, delivery, or receiving;
- Recipe/BOM approval, scaling, density conversion, yield/waste assumption, packaging assignment, or cost/margin calculation with unsupported input;
- professional engagement or reliance on public research as a professional conclusion;
- independent review commissioning;
- changes to canonical decisions, source code, schemas, migrations, authentication/authorization, or POS workflows.

Before later execution, the Owner must authorize each materially distinct lane separately: material/contact/acquisition scope, R04 readiness and trial, R05 readiness and trial, BUY specification/contact/acquisition, professional engagement, and independent review. One authorization must not be treated as authority for another lane.

## 10. Risks and workstream conflicts

| Risk | Control |
|---|---|
| Concurrent POS Gate B and audit documents are uncommitted | Treat them as owned by other workstreams; do not edit, stage, discard, or cite their readiness as commercial authority. |
| Historical commercial reports retain once-current missing-price findings | Apply the canonical authority order. `CORE-OD-18` and current CSVs control; retain historical reports only as evidence history. |
| Public prices appear numeric and may be mistaken for cost | Keep them in market-reference fields only. Actual quotation, transaction, freight/tax treatment, conversions, yield, waste, and receiving remain required. |
| Public recipes appear measurable and may be mistaken for BOMs | Keep them as independent candidate formulations. No Recipe/BOM or cross-size scaling without approved, attributable evidence. |
| R04 provisional choices may be mistaken for approval | Preserve their preparation-only status. Physical identity, suitability, trial authority, results, Recipe review, and procurement evidence remain absent. |
| R04/R05 similarity may encourage copied evidence | Preserve independent run IDs, readiness records, formulations, and raw evidence; do not hybridize tracks. |
| `READY_FOR_EVIDENCE` may be mistaken for execution authority | It means only that a structure can accept evidence. It grants no contact, purchase, trial, engagement, or approval. |
| More documentation may be mistaken for closure | Enforce the evidence class for each gap. Templates, simulation, self-review, or prose cannot replace facts, events, physical evidence, qualified judgment, or independence. |
| POS/security work may absorb commercial scope | Keep commercial evidence in the existing documents/CSVs; create no commercial application, database, runtime producer, or cross-context integration under CE-01. |

## 11. Recommended CE-01 exit criteria

CE-01 may exit when all of the following are true:

1. Branch, HEAD, staged/modified/untracked state, and concurrent-work ownership are recorded and rechecked.
2. The artifact inventory identifies the authority order, current operational intake artifacts, canonical CSV destinations, and historical/reference-only documents.
3. Automated read-only checks reproduce 28 Products, 52 unique combinations, 48 MAKE, 4 BUY, 52/52 `MISSING_INPUT`, 0/52 cost/margin results, and the exact 32-gap classification reconciliation.
4. Every one of the 32 gaps has one current status, dependency, evidence provider, authorization boundary, and rejection rule traceable to the governing report/workbook.
5. Settled menu, pricing-scope, and Buy/Make decisions are explicitly frozen against reopening in CE-01.
6. R04 and R05 remain independent and `NOT_STARTED`, with inspection/readiness distinguished from trial authority.
7. Workstream isolation is documented: no POS source, database, migration, security/audit, or canonical decision change.
8. A next execution package is bounded by lane, prerequisite, evidence class, exact destination, authorization gate, and stop condition.
9. Git status after report creation differs from the before snapshot only by this untracked report plus any independently occurring concurrent-work changes, all of which are disclosed.

## 12. Recommended next execution package

Prepare **CE-02 — Evidence Intake Integrity & Authorization Package** as a documentation-only proposal. It should not collect evidence or authorize execution. Its manifest should contain:

1. a frozen input manifest for the six controlling artifacts and four canonical CSVs;
2. read-only validation commands and expected invariants;
3. one lane card each for R04 readiness, R04 trial, R05 readiness, R05 trial, MAKE commercial evidence, BUY specification/contact/acquisition, channel packaging, qualified-input packages, and independent reviews;
4. for each lane: prerequisite facts, permitted evidence classes, rejected substitutes, exact destination fields/files, responsible provider, authorization required, stop conditions, and downstream dependency;
5. a change-detection protocol for concurrent POS/security/audit work;
6. an Owner ballot only for whether to activate a particular evidence lane—not for settled menu decisions, Recipe/BOM approval, fabricated assumptions, or bundled authority;
7. an explicit statement that CE-02 preparation does not authorize supplier contact, purchase, trial, professional engagement, or implementation.

## 13. Validation performed

Read-only commands used during this investigation included `git branch --show-current`, `git rev-parse HEAD`, `git status`, `git diff`, `git log`, `git ls-files --others --exclude-standard`, `rg`, `find`, `sed`, and Ruby's standard-library CSV parser. No application, database, migration, frontend, backend, or network command was run. No application tests were claimed.

## 14. Final verdict

**`READY_WITH_BLOCKERS`**

CE-01 reconnaissance has a verified, internally consistent repository baseline and can proceed as an isolated evidence-governance workstream. Execution and gap closure remain blocked by the exact Owner, physical, supplier, qualified-input, operational-event, and independent-review dependencies documented above.
