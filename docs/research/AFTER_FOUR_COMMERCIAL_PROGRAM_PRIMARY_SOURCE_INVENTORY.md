# AFTER FOUR — Commercial Program Primary-Source Inventory

**Prepared:** 2026-11-27  
**Scope:** Commercial Foundation and Validation Program, repository-only reconnaissance  
**Repository:** `/Users/tad/project/after_four`  
**Branch / HEAD inspected:** `development` / `7efb60b028de02126e8fc01762203f385005019e`  
**Authority:** Documentation research only; no evidence collection, commercial execution, canonical write, external contact, purchase, trial, professional engagement, independent review, or other-workstream change

## 1. Current-state conclusion

The current repository supports the established commercial baseline without numerical conflict:

- 28 Owner-confirmed Products;
- 52 unique Product/Variant costing combinations;
- 48 `MAKE_IN_HOUSE` combinations across 24 Products;
- four `BUY_FINISHED` Products/combinations;
- 52/52 costing rows at `MISSING_INPUT` and `NOT_CALCULABLE_MISSING_EVIDENCE`;
- 48/48 MAKE rows at `MISSING_INPUT_NOT_OWNER_APPROVED`;
- four/four BUY rows at `MISSING_INPUT`;
- zero populated evidence-backed unit-cost or gross-margin results; and
- 32 atomic Milestone A gaps, with only post-decision synchronization closed on the current baseline.

The commercial documentation foundation is extensive and internally aligned, but it is not evidence-backed commercial completion. The governing Milestone verdict remains `MILESTONE_A_NOT_COMPLETE_BUT_ALL_INTERNAL_WORK_CLOSED`. The remaining 31 gaps require Owner facts/decisions, actual physical or operational evidence, supplier/procurement evidence, qualified professional input, or genuine independent review. Sources: [Owner Decision Baseline](../architecture/after_four_owner_decision_baseline.md), [Milestone A gap report](after_four_milestone_a_comprehensive_evidence_and_decision_gap_report.md), [Evidence Intake Workbook](../architecture/after_four_milestone_a_evidence_intake_workbook.md), and the four canonical CSVs listed in §3.

## 2. Repository and authority baseline

The inspection started on `development` at `7efb60b028de02126e8fc01762203f385005019e`, with nothing staged. The worktree already contained concurrent POS, Identity source/spec, and Organization-Level Audit changes. They are outside this program and were not modified by this inventory.

The commercial authority order is:

1. [Owner Decision Baseline](../architecture/after_four_owner_decision_baseline.md) for confirmed Owner decisions.
2. [Real Menu & Pricing Specification](../architecture/after_four_real_menu_pricing_specification.md) for the exact `CORE-OD-18` 52-combination Commercial V1 baseline.
3. [CORE-02 / CORE-04 Owner Decision Worksheet](../architecture/after_four_core_02_core_04_owner_decision_worksheet.md) for unresolved inputs and decision routing; it is not an Owner approval.
4. [Milestone A Evidence Intake Workbook](../architecture/after_four_milestone_a_evidence_intake_workbook.md) for the operational intake route across the same 32 gaps.
5. [Milestone A comprehensive gap report](after_four_milestone_a_comprehensive_evidence_and_decision_gap_report.md) for the current 32-gap identities, classifications, dependencies, and Milestone verdict.
6. The four canonical Commercial V1 CSVs for current Product/Variant, MAKE/BUY, Recipe/BOM, procurement, and costing state.

Repository presence does not create authority. Research, templates, blank capture records, market listings, recommendations, and ballot definitions remain subordinate to explicit Owner decisions and accepted attributable evidence.

## 3. Canonical commercial artifacts

| Artifact | Current parsed state | Authority and use |
|---|---|---|
| [Buy-vs-Make Owner input](../architecture/after_four_commercial_v1_buy_vs_make_owner_input.csv) | 28 rows: 24 `MAKE_IN_HOUSE`, four `BUY_FINISHED`; all 28 `OWNER_CONFIRMED` | Canonical Product-level MAKE/BUY allocation. |
| [MAKE Recipe/BOM input](../architecture/after_four_commercial_v1_make_recipe_bom_input.csv) | 48 rows / 24 Products / 48 unique Product-Variant keys; 48 unapproved | Canonical MAKE evidence destination after separately authorized evidence acceptance and recording. |
| [BUY procurement input](../architecture/after_four_commercial_v1_buy_finished_procurement_input.csv) | Four Products: Bánh croissant, Cheesecake, Brownie chocolate, Muffin; four `MISSING_INPUT` | Canonical BUY specification-to-receiving destination after Product-scoped authority. |
| [Commercial V1 costing input](../architecture/after_four_commercial_v1_costing_input.csv) | 52 rows / 28 Products / 52 unique keys; 48 MAKE and four BUY; 52 `MISSING_INPUT`; zero unit costs/margins | Canonical costing evidence and result destination. Unsupported results remain blank. |
| [Proposed Launch Menu v3](../architecture/after_four_proposed_launch_menu_v3.md) | 28 named Product rows and six menu groups | Approved by reference under `CORE-OD-01`; no Recipe/BOM, implementation, or publication authority. |
| [Real Menu & Pricing Specification](../architecture/after_four_real_menu_pricing_specification.md) | Exact 52 Product/Variant combinations and proposed selling-price inputs | Approved by `CORE-OD-18` for costing inputs only; not final publication, tax, rounding, Recipe, cost, margin, schema, API, or runtime authority. |

Current SHA-256 values for the four CSVs are:

- Buy-vs-Make: `0a38e636bf204ba29c1b6949318cdb2e604ee5090191f2e596235c7920eeb5e4`
- MAKE: `ff9c014580bd25b5ad76f8f73e5efa05d8e5fa10a3c218d4ce526a9ef2c20b38`
- BUY: `96e2d877d00b5671af5881c9da352dda64b552c28ec69703bee1390f7e758588`
- Costing: `3685a95253c042f7c156ef50546c5af670f4aeb8f533d0c194bee3aa16f1d827`

These match the CE-02 frozen manifest.

## 4. CE-01, CE-02, and CE-03 status

### 4.1 CE-01

[CE-01 Initialization Report](AFTER_FOUR_COMMERCIAL_WORKSTREAM_03_INITIALIZATION_REPORT.md) correctly reconciles 28/52/48/4, 32 gaps, 52 missing costing rows, 48 unapproved MAKE rows, four incomplete BUY chains, and zero supported results. Its Git snapshot is historical and must not be treated as the current worktree state.

### 4.2 CE-02

[CE-02 Evidence Intake Integrity & Authorization Package](AFTER_FOUR_COMMERCIAL_CE02_EVIDENCE_INTAKE_INTEGRITY_AUTHORIZATION_PACKAGE.md) defines:

- a required evidence envelope with identity, provider/attester, authority basis, dates, source, digest, class, exact scope, version, supersession, limitations/conflicts, review, disposition, and destination;
- immutable originals, linked normalized extracts, append-only corrections, scoped supersession, duplicate/conflict handling, reproducibility, and rejection rules;
- nine dormant evidence lanes covering R04, R05, MAKE, BUY, packaging, qualified input, and independent review; and
- a fail-closed Commercial V1 integrity contract preserving 28/52/48/4 and blank unsupported results.

The package is operationally usable as an intake protocol. Its own verdict is `READY_FOR_OWNER_CE02_PACKAGE_REVIEW`; the CE-03 register records that the Owner later accepted CE-02 as `ACCEPT_DOCUMENTATION_ONLY`. That acceptance authorizes documentation preparation only and does not activate any lane.

Current CE-02 SHA-256: `fd48325dc3e89fcc34bb0c633f230bafca268dfc955d2f411ad8b7c41e8127fe`.

### 4.3 CE-03

[CE-03 Owner Authorization Ballot Register](AFTER_FOUR_COMMERCIAL_CE03_OWNER_AUTHORIZATION_BALLOT_REGISTER.md) currently contains 69 stable ballot definitions and matching execution-control records. Every ballot remains `NOT_AUTHORIZED` and `PENDING_OWNER_DECISION`.

The register separates:

- R04 and R05 procurement, receipt, readiness, trial, review, Recipe/BOM approval, and recording;
- each BUY Product's specification decision, RFQ/contact, quotation decision, purchase, receiving, evidence acceptance, and Product-scoped recording;
- operational activity dependencies from recording branches (`-04` does not depend on `-03R`; `-05` does not depend on `-04R`);
- packaging acquisition, fit evidence, commercial acceptance, and any future exact-manifest canonical recording;
- professional engagement from independent review; and
- `CP3-E03`, `CP3-E04`, and one-trigger/one-baseline synchronization authority.

Current post-remediation CE-03 SHA-256: `e12f3566a03987d628f2998b0150d48cddd53e04cb7a937e6e44eeca647ea1e8`.

The Phase 1 remediation resolved the remaining `CE03-PKG-01` ambiguity: PKG-01 now captures and retains original acquisition evidence independently under CE-02, authorizes no Workbook or CSV write, and defers any canonical recording to a separate exact-manifest Owner-authorized ballot. It is not a recording prerequisite for PKG-02.

## 5. Supporting execution and evidence artifacts

| Family | Primary artifact(s) | Current evidentiary boundary |
|---|---|---|
| R04/R05 physical evidence | [Signature Practical Test Protocol](after_four_commercial_v1_signature_practical_test_protocol.md); [Workbook §7](../architecture/after_four_milestone_a_evidence_intake_workbook.md#7-r04r05-physical-evidence-routing) | Stable independent run identities, readiness checks, and blank capture records exist. No trial is authorized or completed. |
| MAKE research | [Recipe quantity research](after_four_commercial_v1_recipe_quantity_research.md); [external Ingredient/supplier research](after_four_commercial_v1_external_ingredient_supplier_research.md) | Public reference material only; supplies no approved Recipe/BOM, actual Ingredient, yield, waste, conversion, supplier, transaction, or packaging allocation. |
| BUY/procurement evidence definition | [Cost Evidence Collection Gaps](after_four_commercial_v1_cost_evidence_collection_gaps.md) | Defines minimum defensible evidence; supplies no accepted specification, supplier, quote, purchase, delivery, or receiving evidence. |
| Market candidates | [R04/R05 market research](after_four_r04_r05_market_price_research.md), [Ingredient observations](after_four_r04_r05_ingredient_market_prices.csv), [equipment observations](after_four_r04_r05_equipment_market_prices.csv), [trial-kit mapping](after_four_r04_r05_trial_kit_market_mapping.csv) | `MARKET_REFERENCE_ONLY`; candidate planning, never procurement, physical identity, actual cost, Recipe, tolerance, or trial authority. |
| Broader evidence map | [Comprehensive evidence report](after_four_comprehensive_evidence_research_and_closure_report.md); [evidence register](after_four_comprehensive_evidence_register.csv) | Supporting cross-domain research index. Current authority and gap state remain in the baseline, workbook, and governing gap report. |

Protocol SHA-256 is `52849ed07bd4d5c4ba72162919ac2fde8cc829258a09b0adb5a36f7edf9806aa`. The Workbook SHA-256 is `a1e8dcd635e354bbc922d3acb3f2108f39cc13fe324e28c9ce6455ad6d11fc0a`; both match CE-02.

## 6. Accepted Owner decisions and unresolved decisions

### Accepted and preserved

- `CORE-OD-01`: the 28 named Products, six menu groupings, presented Variant labels, and presented Modifier lists form the draft launch-menu baseline. It does not approve Recipes, prices by SKU, tax, rounding, availability, or implementation.
- `CORE-OD-18`: the exact 52 combinations and proposed VND selling-price inputs are approved for Commercial V1 costing; dine-in and takeaway share the proposed price; scope is the First Branch's first Price Version with no active chain default or Branch override. It does not approve final publication, Recipe, cost, margin, tax, rounding, schema, API, or runtime behavior.
- The Buy-vs-Make CSV records 24 MAKE Products and four BUY Products as Owner-confirmed.
- The R04 provisional checkpoint is retained only as trial-preparation evidence; it is not an Ingredient, supplier, acquisition, Recipe, or trial approval.
- First Branch non-operation, intended dine-in/takeaway scope, and limited receipt plans are recorded as Owner facts/plans, not verified legal/tax/bank/transaction evidence.

### Unresolved or deferred

- `CORE-OD-03`: tax treatment/display/invoice applicability.
- `CORE-OD-04`: calculation precision, rounding mode, boundary, sequence, and residual treatment.
- Deferred First Branch seller/entity/registration/premises/rent/tax documentary facts until the Owner voluntarily resumes them.
- All 11 residual CORE-02/CORE-04 Owner-decision gaps and nine qualified-input gaps tracked by the 32-gap register.
- R04/R05 physical readiness, separate trial authorizations, real run evidence, Recipe review, Recipe/BOM approval, and canonical recording.
- All 48 MAKE evidence chains, all four BUY specifications/procurement chains, and channel-specific packaging fit/cost evidence.
- `CP3-E03` and `CP3-E04` independent review authorization, reviewer selection, performance, and acceptance.

## 7. Current 32-gap disposition

The governing [gap report](after_four_milestone_a_comprehensive_evidence_and_decision_gap_report.md) classifies the 32 rows as 11 Owner decisions, one Owner fact confirmation, two observed operational-evidence gaps, one documentary-evidence gap, two physical-trial gaps, three commercial/procurement gaps, nine qualified-professional-input gaps, one internal-documentation gap, and two independent reviews.

| Disposition | Rows | Current implication |
|---|---:|---|
| Closed current baseline | 1 | Post-decision synchronization only; reopens on an applicable accepted decision/evidence trigger. |
| Open and not Codex-only closable | 31 | Require external facts, attributable events/evidence, Owner decisions, professional judgment, or genuine independent review. |

The commercial subset is R04/R05 readiness and trials, 48 MAKE combinations, four BUY chains, channel packaging, `CORE-OD-03/04`, applicable First Branch facts, later synchronization, and the relevant review path. Preparation of a procedure or template does not close any external evidence row.

## 8. Internal work versus external dependency

### Internally resolvable now

- Revalidate the remediated PKG-01 authorization boundary after any later CE-03 edit.
- Consolidate overlapping commercial roadmap/status material while retaining historical provenance.
- Produce consistent execution packages, status matrices, 52-combination readiness mapping, and reproducible synthetic-only costing validation specifications.
- Validate links, CSV structure, stable IDs, §3/§4 parity, dependency acyclicity, destination fields, hashes, and missing-input propagation.
- Document exact canonical-field gaps and separately scoped recommendations without changing canonical CSV headers.

These actions improve execution readiness but do not close an evidence gap.

### Requires external or Owner action

- Owner selection/authorization for every CE-03 ballot actually used.
- Physical identification/acquisition, readiness inspection, and separately authorized R04/R05 trials.
- Accepted Recipes/BOMs, measurements, yield/loss, actual purchase/receiving, and packaging evidence.
- BUY specifications, supplier contact, quotations, purchases, deliveries, receiving, and loss evidence.
- Qualified Vietnamese Tax/Accounting/Privacy/Legal/Governance or other scoped professional input.
- Actual operational events after lawful operation.
- Genuine independent reviews `CP3-E03` and `CP3-E04` after upstream closure and synchronization.

## 9. Duplicate, superseded, stale, and conflicting material

No controlling conflict was found among the Owner Decision Baseline, Real Menu & Pricing Specification, canonical CSVs, Workbook, and governing gap report.

The following material requires classification rather than deletion:

- [CORE-01 Qualified Commercial Input — Sprint 1](after_four_core_01_qualified_commercial_input_sprint_1.md) explicitly marks its pre-`CORE-OD-18` missing-price assessment as historical. Its remaining `CORE-OD-03/04` blockers are still current.
- [CORE-01 Commercial Evidence Closure — Sprint 2](after_four_core_01_commercial_evidence_closure_sprint_2.md) predates the final Commercial V1 reconciliation and is supporting history, not current commercial authority.
- Public Recipe, supplier, packaging, and market documents deliberately retain alternative candidates. These are evidence limitations, not canonical decision conflicts.
- R04 and R05 repeat similar fields intentionally. Their evidence must remain independent and must not be copied, averaged, or hybridized.
- The [Comprehensive Evidence Research and Closure Report](after_four_comprehensive_evidence_research_and_closure_report.md) has been reconciled to the current [machine-readable register](after_four_comprehensive_evidence_register.csv): 77 current rows, with its earlier 61-item count explicitly classified as historical. This does not change the canonical 32-gap register.
- CE-01, CE-02, and CE-03 Git-status narratives are accurate historical snapshots, not the current worktree state.

## 10. Integrity snapshot

| Artifact | SHA-256 |
|---|---|
| Owner Decision Baseline | `dcff89c0e9d8aafdb7be79925ff698453b9229d03f02a59415f7ab322a2cfed3` |
| Owner Decision Worksheet | `6f88e7526e1e7cfcaf3d1a695018d3d1f4cb8e5c5cde48450ac20768c8a4fe33` |
| Evidence Intake Workbook | `a1e8dcd635e354bbc922d3acb3f2108f39cc13fe324e28c9ce6455ad6d11fc0a` |
| Governing 32-gap report | `42f87d72bc643ff3d664e8c5fd6364a748b60c10714f0b5e80a3acd8d6dbc0f7` |
| Signature Practical Test Protocol | `52849ed07bd4d5c4ba72162919ac2fde8cc829258a09b0adb5a36f7edf9806aa` |
| CE-02 | `fd48325dc3e89fcc34bb0c633f230bafca268dfc955d2f411ad8b7c41e8127fe` |
| CE-03 | `e12f3566a03987d628f2998b0150d48cddd53e04cb7a937e6e44eeca647ea1e8` |
| Comprehensive evidence register | `8c1306cb976e72b9fcd4de9bfc17f0b79a5c42ffffd01f2c0818a580cd5c29de` |

## 11. Research verdict

`PRIMARY_SOURCE_BASELINE_VERIFIED`

The repository contains a coherent and usable commercial governance foundation. It does not contain the real-world evidence required for evidence-backed Recipe/BOM approval, procurement completion, unit-cost calculation, gross-margin calculation, independent review, Phase 2 completion, or Milestone A completion.
