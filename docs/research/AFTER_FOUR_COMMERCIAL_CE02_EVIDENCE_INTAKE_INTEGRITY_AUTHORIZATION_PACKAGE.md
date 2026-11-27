# AFTER FOUR — CE-02 Evidence Intake Integrity & Authorization Package

**Prepared:** 2026-11-27  
**Workstream:** Commercial Evidence & Unit Economics Foundation  
**Phase:** CE-02  
**Package authority:** Owner-authorized documentation preparation only  
**Repository:** `/Users/tad/project/after_four`  
**Branch / HEAD:** `development` / `7efb60b028de02126e8fc01762203f385005019e`  
**Execution status:** `NOT_AUTHORIZED`

## 1. Purpose and authority

The Owner explicitly authorizes repository inspection, existing-artifact verification, documentation drafting, evidence taxonomy and dependency mapping, authorization-boundary specification, and read-only validation needed to prepare this package. This authority permits creation of this document only. It does not authorize evidence collection, physical inspection, testing, contact, acquisition, professional engagement, independent review, policy selection, implementation, or modification of any controlling artifact.

### 1.1 Permitted work

- Read and checksum existing repository artifacts.
- Reproduce structural counts and current evidence-state invariants.
- Describe accepted evidence, rejected substitutes, destinations, dependencies, gates, and stop conditions.
- Propose separate future Owner ballot items without marking any item approved.
- Validate this document and report the before/after worktree state.

### 1.2 Prohibited work

No supplier contact, RFQ, purchase, material/equipment acquisition, R04/R05 inspection or trial, Recipe/BOM approval, costing-CSV population, assumed conversion/yield/waste/packaging value, unit-cost or margin calculation, professional engagement, independent-review engagement, Owner-decision change, canonical-document change, application/source/schema/migration/security/audit change, commercial application/database, Git staging, commit, push, merge, or branch switch is authorized.

### 1.3 Workstream separation and later authority

CE-02 owns this evidence-governance package only. POS Feature Development retains its source/design scope; POS Security & Organization-Level Audit retains its audit/security scope. Neither workstream's readiness, package, or uncommitted file grants commercial authority. A later activity may start only after the Owner separately approves its exact scope, responsible party, evidence destination, limits, expiry, and stop conditions. Authority never transfers by analogy between lanes.

Package completion is not evidence acceptance, lane activation, Milestone A completion, Gate approval, or implementation authority.

## 2. Revalidated repository baseline

| Invariant | Read-only result |
|---|---:|
| Owner-confirmed Products | 28 |
| Unique Product/Variant costing combinations | 52 |
| MAKE / BUY combinations | 48 / 4 |
| Costing rows with `verification_status = MISSING_INPUT` | 52/52 |
| Costing rows with `calculation_status = NOT_CALCULABLE_MISSING_EVIDENCE` | 52/52 |
| Populated unit-cost / gross-margin results | 0 / 0 |
| MAKE rows with `recipe_approval_status = MISSING_INPUT_NOT_OWNER_APPROVED` | 48/48 |
| BUY rows with `verification_status = MISSING_INPUT` | 4/4 |
| Atomic gaps | 32 |
| R04/R05 trials | Not authorized; not started |
| Milestone A | `MILESTONE_A_NOT_COMPLETE_BUT_ALL_INTERNAL_WORK_CLOSED` |

## 3. Frozen artifact manifest

Hashes freeze the inspected bytes; they do not promote a supporting artifact to canonical authority.

| Artifact | Purpose | Authority / status | Classification | SHA-256 | Permitted future intake role |
|---|---|---|---|---|---|
| [Owner Decision Baseline](../architecture/after_four_owner_decision_baseline.md) | Owner-confirmed business decisions | Highest Owner authority; current | Canonical | `dcff89c0e9d8aafdb7be79925ff698453b9229d03f02a59415f7ab322a2cfed3` | Receive only separately recorded Owner decisions through authorized canonical synchronization. |
| [CORE-02 / CORE-04 Owner Decision Worksheet](../architecture/after_four_core_02_core_04_owner_decision_worksheet.md) | Unresolved decision/scenario and qualified-input routing | Current worksheet; not itself Owner approval | Supporting decision intake | `6f88e7526e1e7cfcaf3d1a695018d3d1f4cb8e5c5cde48450ac20768c8a4fe33` | Retain fact packs, worked examples, qualified outputs, and later Owner dispositions. |
| [Milestone A Evidence Intake Workbook](../architecture/after_four_milestone_a_evidence_intake_workbook.md) | Exact 32-gap intake routing, R04/R05 inspection, commercial and review manifests | `ACTIVE INTAKE PREPARATION — NO EVIDENCE OR AUTHORITY IMPLIED` | Canonical intake routing | `a1e8dcd635e354bbc922d3acb3f2108f39cc13fe324e28c9ce6455ad6d11fc0a` | Future evidence-index and inspection records only after applicable authority. |
| [Milestone A Comprehensive Gap Report](after_four_milestone_a_comprehensive_evidence_and_decision_gap_report.md) | Gap identity, class, status, dependencies, Milestone verdict | Governing 32-gap report; current | Governing supporting report | `42f87d72bc643ff3d664e8c5fd6364a748b60c10714f0b5e80a3acd8d6dbc0f7` | Status reassessment only after accepted evidence/decision triggers. |
| [Real Menu & Pricing Specification](../architecture/after_four_real_menu_pricing_specification.md) | `CORE-OD-18` exact 52-combination selling-price baseline | Owner-confirmed costing baseline; no publication/implementation authority | Canonical commercial baseline | `db4d3db9092d35b1aedc2e3644905cbc0f5c0ffb0c9e952a4f79d4f097c82754` | Frozen selling-price identity for evidence reconciliation; no unsupported amendment. |
| [CE-01 Initialization Report](AFTER_FOUR_COMMERCIAL_WORKSTREAM_03_INITIALIZATION_REPORT.md) | Revalidated commercial inventory, conflicts, dependencies, isolation | Current reconnaissance report; not Owner policy | Supporting | `6c4968ce733ddca0d9a65356b21c9e0cf9d59086e985362f905d5991cfc0b550` | Change-detection and CE-02 trace reference only. |
| [Buy-vs-Make Owner input](../architecture/after_four_commercial_v1_buy_vs_make_owner_input.csv) | 28 Product MAKE/BUY decisions | 24 MAKE / 4 BUY; all Owner-confirmed | Canonical Commercial V1 input | `0a38e636bf204ba29c1b6949318cdb2e604ee5090191f2e596235c7920eeb5e4` | Frozen allocation key; changes require new Owner authority. |
| [MAKE Recipe/BOM input](../architecture/after_four_commercial_v1_make_recipe_bom_input.csv) | 48 MAKE measurement/Recipe rows | All `MISSING_INPUT_NOT_OWNER_APPROVED` | Canonical evidence destination | `ff9c014580bd25b5ad76f8f73e5efa05d8e5fa10a3c218d4ce526a9ef2c20b38` | Attributable quantities, conversions, yield/loss, packaging, source and approval fields after lane authority. |
| [BUY procurement input](../architecture/after_four_commercial_v1_buy_finished_procurement_input.csv) | Four specification-to-receiving chains | All `MISSING_INPUT`; accepted specifications blank | Canonical evidence destination | `96e2d877d00b5671af5881c9da352dda64b552c28ec69703bee1390f7e758588` | Accepted specification, supplier documents, quote/transaction, delivery, receiving and loss after separate authorities. |
| [Commercial V1 costing input](../architecture/after_four_commercial_v1_costing_input.csv) | 52 evidence-to-cost reconciliation rows | All `MISSING_INPUT` / not calculable | Canonical evidence destination | `3685a95253c042f7c156ef50546c5af670f4aeb8f533d0c194bee3aa16f1d827` | Evidence-backed direct-cost lines and results only after complete, independently reproducible chains. |
| [Signature Practical Test Protocol](after_four_commercial_v1_signature_practical_test_protocol.md) | R04/R05 formulations, readiness gates and raw run sheets | `PLANNED — OWNER_REVIEW_REQUIRED`; no trial authority | Supporting execution protocol | Not frozen in controlling ten-file manifest | Separate readiness and raw-run destinations after the exact lane is authorized. |
| [Cost Evidence Collection Gaps](after_four_commercial_v1_cost_evidence_collection_gaps.md) | Minimum defensible cost evidence chain | Research/support only | Supporting | Not required | Acceptance checklist; never a cost source. |
| [Recipe Quantity Research](after_four_commercial_v1_recipe_quantity_research.md) and [External Ingredient/Supplier Research](after_four_commercial_v1_external_ingredient_supplier_research.md) | Candidate formulations, SKUs and market observations | Public research only | Reference-only | Not required | Candidate discovery only; never approved Recipe, supplier, quotation, transaction or cost. |
| [R04/R05 Market Price Research](after_four_r04_r05_market_price_research.md) and its three CSVs | Trial-kit market mapping | `MARKET_REFERENCE_ONLY` | Reference-only | Not required | Planning candidates only; never physical observation, procurement, formulation or trial authority. |

No frozen artifact may be edited under CE-02. A hash change is a stop condition until provenance, authority, and effect on this package are reviewed.

## 4. Thirty-two-gap evidence matrix

The row is the governing counting unit. Umbrella references are not counted twice. “Authorization” states the future gate; it is not approval.

| # / gap ID | Current authoritative status | Responsible workstream | Evidence provider | Required prerequisite | Accepted evidence classes | Rejected evidence/substitutes | Owner authorization required | Exact future destination artifact / fields | Closure criteria | Downstream dependencies | Stop conditions |
|---|---|---|---|---|---|---|---|---|---|---|---|
| 1. `CORE-OD-03` | `BLOCKED — NOT_READY_FOR_OWNER` | Commercial / CORE-01 | Owner facts; qualified Vietnamese Tax/Accounting reviewer | Owner voluntarily resumes seller/registration/Product/invoice facts | Source documents; dated scoped opinion with citations/assumptions | Generic law, guessed rate, demo invoice | Separate professional engagement; later Owner policy decision | Workbook §§3/9; Owner worksheet `CORE-OD-03`; later baseline sync | Applicable treatment/display/invoice policy recorded with scope/date | `CORE-OD-04`, authoritative cost/margin/publication, A-03/A-05 | Missing fact pack; uncommissioned reviewer; applicability conflict |
| 2. `CORE-OD-04` | `BLOCKED — NOT_READY_FOR_OWNER` | Commercial / CORE-01 | Business examples; qualified Accounting reviewer | `CORE-OD-03` interactions and actual line/total/Refund/correction examples | Reproducible worked examples; dated method analysis | “Integer VND,” framework default, invented sequence | Separate engagement; later Owner policy decision | Workbook §9; worksheet `CORE-OD-04` examples and disposition; baseline sync | Precision, mode, boundary, sequence and residual policy recorded | Deterministic totals, costs/margins, A-03/A-05 | Missing examples; unresolved tax interaction; uncommissioned reviewer |
| 3. `WS-C02-01` | `BLOCKED — QUALIFIED_INPUT_REQUIRED` | POS custody / CORE-02 | Operations; qualified Privacy/Governance; Owner | Actual evidence-source availability/provenance | Scenario-matched source inventory and abuse/privacy analysis | Login, acknowledgement or transport success as transfer | Qualified engagement; later Owner decision | Workbook §4.1; Owner worksheet §§3/15 | Owner selects/defers admissible classes on adequate evidence | `WS-C02-02..04`, A-01, `CP3-E03` | No actual source facts; privacy/control conflict |
| 4. `WS-C02-02` | `BLOCKED — QUALIFIED_INPUT_REQUIRED` | POS custody / CORE-02 | Operations; Identity/Governance reviewer; Owner | `WS-C02-01` evidence and staffing/responsibility facts | Authority basis and separation/conflict scenarios | Generic Staff status or authentication | Qualified engagement; later Owner decision | Workbook §4.1; Owner worksheet `WS-C02-02` | Authority, sufficiency and separation each decided/deferred | `WS-C02-04`, A-01, E03 | Unsupported actor capability; self-approval conflict |
| 5. `WS-C02-03` | `BLOCKED — QUALIFIED_INPUT_REQUIRED` | POS custody / CORE-02 | Operations/Owner; Privacy/Governance reviewer | Actual recipient/representative authorization basis | Minimum-data linkage/mismatch scenarios and analysis | Acknowledgement-only linkage; invented identity mechanism | Qualified engagement; later Owner decision | Workbook §4.1; worksheet `WS-C02-03` | Recipient paths and mismatch/absence handling decided/deferred | `WS-C02-04`, A-01, E03 | Linkage unavailable; excess-data/privacy conflict |
| 6. `WS-C02-04` | `BLOCKED — NOT_READY_FOR_OWNER` | POS custody / CORE-02 | Qualified control input; Owner | Decided `WS-C02-01..03` outputs | Evidence-supported combinations and false-transfer/hold analysis | Timeout, no objection, unspecified record | Later Owner decision | Workbook §4.1; worksheet threshold field | Explicit minimum positive threshold selected/deferred | Positive transfer rule, A-01, E03 | Upstream open; false-transfer risk unsupported |
| 7. `WS-C02-05` | `BLOCKED — QUALIFIED_INPUT_REQUIRED` | POS custody / CORE-02 | Operations/customer service; qualified input; Owner | Feasible negative-case consequences and communications | Complete absence/refusal/unavailable/mismatch/conflict cases | Automatic transfer, closure, Refund or new attempt | Qualified engagement where applicable; Owner decision | Workbook §4.2; worksheet `WS-C02-05` matrix | Each scenario has supported outcome or explicit deferral | Negative paths, A-01, E03 | Scenario unsupported; outcome creates unapproved financial/customer policy |
| 8. `WS-C02-06` | `BLOCKED — QUALIFIED_INPUT_REQUIRED` | POS custody / CORE-02 | Governance/Privacy/Legal/fraud reviewer; Owner | Conflict taxonomy, materiality and separation facts | Attributable conflict evidence and qualified limits | Replay, silent supersession, self-appointed resolver | Qualified engagement; Owner authority decision | Workbook §4.2; worksheet `WS-C02-06` | Disposition authority/limits decided per conflict class | Conflict release, A-01, E03 | Fraud/privacy/separation unresolved |
| 9. `WS-C02-07` | `BLOCKED — QUALIFIED_INPUT_REQUIRED` | POS custody / records | Records/data owners; Privacy/Legal/Governance reviewer | Populated category/purpose/flow inventory | Scoped opinion on access, correction, retention, disposal, hold | Universal period, destructive correction, unnecessary personal data | Professional engagement; Owner policy decision | Workbook §§4.1/9; worksheet evidence-policy fields | Bounded governance policy recorded | Use of custody evidence, A-01, E03 | Inventory incomplete; unlawful/excess collection risk |
| 10. `WS-C04-01 / CORE-OD-12` | `BLOCKED — QUALIFIED_INPUT_REQUIRED` | POS Cash / CORE-04 | Operations; Cash/Accounting reviewer; Owner | Actual operation/responsibility/staffing facts | Operation-specific holder alternatives and controls | Title, Shift or Branch Assignment as capability | Professional engagement; Owner decision | Workbook §5.1; worksheet authority matrix | Eligible authority source/holder selected per operation | `WS-C04-02..04`, A-02, E04 | No supported holder; incompatible control |
| 11. `WS-C04-02 / CORE-OD-12` | `BLOCKED — QUALIFIED_INPUT_REQUIRED` | POS Cash / CORE-04 | Operations; Governance/Cash-control reviewer; Owner | `WS-C04-01`; actual continuity cases | Delegation/revocation/Branch/time/emergency analysis | Urgency or default delegation | Professional engagement; Owner decision | Workbook §5.1; worksheet delegation fields | Bounded lifecycle policy selected/deferred | Cash continuity, A-02, E04 | Authority absent; emergency inference |
| 12. `WS-C04-03 / CORE-OD-12` | `BLOCKED — QUALIFIED_INPUT_REQUIRED` | POS Cash / CORE-04 | Operations; Accounting/control reviewer; Owner | `WS-C04-01/02`; staffing feasibility | Actor-combination and separation analysis | Expense policy generalized to Cash; generic manager review | Professional engagement; Owner decision | Workbook §5.1; worksheet separation matrix | Required/prohibited combinations selected/deferred | Cash authority, corrections, A-02, E04 | Incompatible roles; infeasible staffing |
| 13. `WS-C04-04 / CORE-OD-13` | `BLOCKED — NOT_READY_FOR_OWNER` | POS Cash / CORE-04 | Operations/Accounting; Cash/Reporting reviewer; Owner | Actual error cases and authority inputs | Immutable linked-correction cases and consequences | Reopening, rewrite, generic adjustment | Professional engagement where scoped; Owner decision | Workbook §5.2; worksheet correction catalogue | Each operation permitted/excluded with actor/evidence/consequence | Reconciliation, A-02, E04 | Unsupported operation; original fact would be rewritten |
| 14. `WS-C04-05` | `BLOCKED — NOT_READY_FOR_OWNER` | POS Cash / CORE-04 | Operations; control reviewer; Owner | Representative post-escalation disagreement/refusal cases | Attributable cases preserving `CORE-OD-14A/B` | Acknowledgement as approval/Close; invented resolver | Owner decision after evidence | Workbook §5.2; worksheet handover-disposition field | Post-escalation handling and consequence recorded | Cash handover closure, A-02, E04 | No supported resolver/consequence |
| 15. `WS-C04-06` | `BLOCKED — QUALIFIED_INPUT_REQUIRED` | POS Cash / CORE-04 | Cash/Accounting facts owner; qualified reviewer; Owner | Discrepancy taxonomy/materiality | Investigation/waiting evidence and qualified consequence analysis | Tolerance, auto correction, disposition-as-resolution | Professional engagement; Owner residual policy | Workbook §§5.2/9; worksheet discrepancy fields | Investigation/consequence policy recorded without changing no-tolerance baseline | `WS-C04-07/08`, A-02, E04 | Missing taxonomy; inferred tolerance |
| 16. `WS-C04-07` | `BLOCKED — QUALIFIED_INPUT_REQUIRED` | POS reporting / CORE-04 | Accounting/Reporting owners and reviewer; Owner | `WS-C04-04/06`; complete source inventory | Source lineage, missing/conflict/correction cases | Balanced total without complete sources | Professional engagement; Owner criteria decision | Workbook §5.2; worksheet reconciliation matrix | Authoritative sufficiency criteria selected | `WS-C04-08`, A-02, E04 | Incomplete lineage; unresolved conflict |
| 17. `WS-C04-08` | `BLOCKED — QUALIFIED_INPUT_REQUIRED` | POS reporting / CORE-04 | Reporting/Accounting and qualified reviewer; Owner | `WS-C04-07`; report/purpose/exception inventory | Reconciliation and exception evidence; qualified controls | Disposition/reconciliation as automatic issuance | Professional engagement; Owner precondition decision | Workbook §5.2; worksheet report-release fields | Owner issuance preconditions/exception handling recorded | Official reports, A-02, E04 | Unreconciled source; unapproved exception |
| 18. `WS-C04-09 / CORE-OD-16B` | `BLOCKED — QUALIFIED_INPUT_REQUIRED` | POS reporting/privacy | Data/report owners; Identity/Governance/Privacy reviewer; Owner | Report/category/purpose/Branch inventory | Least-privilege access analysis | Generic role or issuance as read/export authority | Professional engagement; Owner policy | Workbook §§5.2/9; worksheet access matrix | Reader/Branch/purpose policy per category | Report access, A-02, E04 | Inventory incomplete; cross-Branch/privacy conflict |
| 19. `WS-C04-10 / CORE-OD-16F` | `BLOCKED — QUALIFIED_INPUT_REQUIRED` | POS records/privacy | Record owners; Legal/Privacy/Accounting-records reviewer; Owner | Classified category/purpose/legal-basis inventory | Category-specific periods, triggers, holds and authorities | Universal period; deletion rewriting evidence | Professional engagement; Owner policy | Workbook §§5.2/9; worksheet retention matrix | Retention/disposal/hold policy per category | Records governance, A-02, E04 | Legal basis/hold unresolved; destructive disposal |
| 20. `WS-RPT-01` | `BLOCKED — QUALIFIED_INPUT_REQUIRED` | POS reporting / CORE-04 | Operations; Accounting/Reporting reviewer; Owner | Completed `SCN-RPT-01..10` plus actual/intended facts | Fact-type event/recorded/correction/business-date analysis | Whole-Shift convenience allocation; rewritten time | Professional engagement; Owner category rule | Workbook §6; worksheet cross-midnight matrix | Allocation rule selected per fact category | Reconciliation/reporting, A-02, E04 | Category ambiguity; timestamp rewrite |
| 21. First Branch facts | `OWNER_DEFERRED — PARTIALLY_SUPPLIED` | Commercial / Owner facts | Owner; documents where later available | Owner voluntarily resumes deferred subject | Source-dated plans/facts and documentary registration/site/bank/workflow records | Inference from menu/law; memory labelled documentary | No request now; later Owner fact submission | Workbook §3 fact-intake fields | Known/unknown facts recorded without legal inference | Tax/food-safety/invoice applicability, A-05 | Owner has not resumed; unnecessary personal data |
| 22. `EA1-D01-*` | `BLOCKED — NOT_OPERATING` | Future Operations / CORE-02 | Authorized operators/records owners | Lawful operation and approved custody policy/authority | Attributable raw events, stable IDs, actor authority, times, lineage/outcome | Simulation, template, desired process, recollection as event | Future operational/data authority | Workbook §4 actual-event record plus future authoritative source | Required ordinary/negative real cases accepted and traceable | A-01 effectiveness, E03 | Not operating; policy/authority absent |
| 23. `EA1-D03-*` | `BLOCKED — NOT_OPERATING` | Future Operations / CORE-04 | Authorized Cash/Accounting/Reporting actors | Lawful operation and approved controls | Source records, approvals, versions, linked corrections/outcomes | Synthetic totals, blank forms, policy prose | Future operational/data authority | Workbook §5 actual-event record plus future authoritative source | Required real control cases accepted and traceable | A-02 effectiveness, E04 | Not operating; authority/control absent |
| 24. R04/R05 readiness documents | `READY_FOR_EVIDENCE — NO_TRIAL_AUTHORITY` | Commercial physical readiness | Owner/operator/test custodian | Separately scoped material availability/inspection authority | Actual labels/SKUs, photos/documents, equipment checks, vessel measures, water/ice provenance | Public listing as physical item; copied cross-track check | Separate R04 readiness and R05 readiness authorizations | Workbook §§7.1–7.4 and Signature Protocol pre-trial checklists, separate track fields | Each track reaches documented physical/protocol readiness only | Respective trial authorization request | Missing item/check; identity mismatch; unsafe condition; cross-track copy |
| 25. `CM-R04-01` | `BLOCKED — PHYSICAL_TRIAL_NOT_AUTHORIZED_OR_RUN` | Commercial R04 trial | Authorized actual tester; Owner disposition | R04 readiness accepted and explicit R04 trial authority | Dated raw inputs/outputs/loss/time/sensory/deviation/repeat evidence | Calculated/copied/R05 values; unrecorded claim | Separate bounded R04 trial; later separate Recipe review/approval | Signature Protocol R04 run sheets §§6.1–6.8; MAKE row `test_run_reference` only after admission | Complete R04 evidence, Owner disposition; Recipe admission remains separate | R04 Recipe review, MAKE chain, A-05 | Any readiness failure, authority expiry, deviation outside scope, missing raw evidence |
| 26. `CM-R05-01` | `BLOCKED — PHYSICAL_TRIAL_NOT_AUTHORIZED_OR_RUN` | Commercial R05 trial | Authorized actual tester; Owner disposition | R05-specific selections/readiness and explicit R05 trial authority | Independent R05 raw evidence including complete foam system | R04 transfer, hybrid formula, silent optional cocoa | Separate bounded R05 trial; later separate Recipe review/approval | Signature Protocol R05 run sheets §§6.1–6.8; MAKE row only after admission | Complete independent R05 evidence and Owner disposition | R05 Recipe review, MAKE chain, A-05 | Any R05 readiness failure, authority expiry, cross-track substitution, missing evidence |
| 27. 48 MAKE combinations | `READY_FOR_EVIDENCE — 0/48 CALCULABLE` | Commercial MAKE/costing | Owner/Recipe reviewer; authorized tester; supplier/receiver; costing verifier | Approved Recipe/BOM and authorized measurement/procurement evidence | Versioned recipe, quantities/units/conversions, yield/loss, actual transaction, packaging, dates | Public recipe/listing, estimate, linear scaling, unsupported conversion/yield/waste | Separate trials/acquisition; Recipe review; explicit Recipe/BOM approval | MAKE CSV fields from `measurement_line_reference` through `recipe_approval_status`; costing CSV evidence/cost fields | Every required line supported; reproducible calculation independently checked | 48 unit costs, margin eligibility, A-05 | Any missing line, unit ambiguity, unapproved recipe, unsupported allocation |
| 28. Four BUY chains | `READY_FOR_EVIDENCE — EXTERNAL_ACQUISITION_UNAUTHORIZED` | Commercial BUY/procurement | Owner; authorized procurement/receiver; supplier documents; verifier | Owner-accepted specification before contact/acquisition | Exact specification/SKU, verified supplier, quote distinct from transaction, delivery/receiving/loss | Public seller as supplier; retail price as quote/cost; unverified claim | Separate specification, supplier contact, quotation acceptance, purchase/acquisition authorities | BUY CSV accepted-specification, supplier, quotation, transaction, delivery, receiving and loss fields; costing CSV | All four chains complete, attributable and independently checkable | Four unit costs, margin eligibility, A-05 | Spec absent; supplier unverified; contact/purchase outside scope; receipt mismatch |
| 29. Channel packaging | `READY_FOR_EVIDENCE — NO_FIT_OR_COST_PROVEN` | Commercial packaging/costing | Owner/operator; authorized procurement/receiver | Channel assignment, actual material, fit-test and acquisition authority | Exact SKU, Product/channel fit, quantity/sale, pack conversion, transaction/receiving | Nominal dimensions, candidate package, shared assignment without proof | Separate material/acquisition and fit-test scope | MAKE CSV dine-in/takeaway packaging fields; BUY packaging fields; costing CSV channel packaging identity/quantity/cost evidence | Fit and actual cost supported per applicable channel/combination | Complete direct cost, margin eligibility, A-05 | Fit failure, quantity ambiguity, no transaction/receiving evidence |
| 30. Post-decision synchronization | `CLOSED_CURRENT_BASELINE — REOPENS_ON_TRIGGER` | Documentation governance | Documentation maintainer; Owner remains policy authority | Applicable accepted decision/evidence trigger | Dated authority provenance and reviewed cross-document diff | Recommendation, research, single-file edit as policy | Explicit documentation scope for triggered synchronization | Baseline, worksheet, domain/data/integrity/state/API and applicable commercial artifacts | Zero contradictions; structural/link/count validation passes | Review handoff and milestone reassessment | No authoritative trigger; unresolved contradiction; scope expansion |
| 31. `CP3-E03` | `BLOCKED — NOT_READY_FOR_INDEPENDENT_REVIEW` | Independent CORE-02 review | Genuine independent reviewer | CORE-02 upstream closure and canonical sync | Exact baseline, conflict disclosure, evidence index, findings/dispositions | Author/self-review, internal adversarial review, pre-closure review | Separate reviewer selection/engagement and scope | Workbook §10.1 manifest and authorized reviewer output | Every material finding resolved; one bounded verdict | A-01/A-06 reassessment | Upstream open; conflict of interest; incomplete manifest |
| 32. `CP3-E04` | `BLOCKED — NOT_READY_FOR_INDEPENDENT_REVIEW` | Independent CORE-04 review | Genuine independent reviewer | CORE-04 upstream closure and canonical sync | Same evidence standard for CORE-04 | Internal review, predetermined verdict, pre-closure review | Separate reviewer selection/engagement and scope | Workbook §10.2 manifest and authorized reviewer output | Every material finding resolved; one bounded verdict | A-02/A-06 reassessment | Upstream open; conflict; incomplete manifest |

Classification remains: 11 `OWNER_DECISION` + 1 `OWNER_FACT_CONFIRMATION` + 2 `OBSERVED_OPERATIONAL_EVIDENCE` + 1 `DOCUMENTARY_EVIDENCE` + 2 `PHYSICAL_TRIAL_EVIDENCE` + 3 `COMMERCIAL_OR_PROCUREMENT_EVIDENCE` + 9 `QUALIFIED_PROFESSIONAL_INPUT` + 1 `INTERNAL_DOCUMENTATION_GAP` + 2 `INDEPENDENT_REVIEW` = **32**. Only row 30 is currently closed; none of the 31 open rows is internally closable.

## 5. Nine independent evidence lanes

Every lane is dormant. Preparation below grants no activation.

### Lane 1 — R04 physical readiness

| Attribute | Specification |
|---|---|
| Purpose / included gap | Establish R04 physical inventory and measurement readiness for gap 24 only. |
| Prerequisites | Separately approved material/inspection scope; identified custodian; R04 expected-item list and blank records. |
| Permitted evidence | Physically observed package labels/SKUs, provenance/date, condition/storage, equipment identity/range/resolution/checks, vessel-capacity measures, water/ice source. |
| Rejected evidence | Public listings as possessed items; R05 records; unchecked specifications; inferred calibration. |
| Provider / authority | Owner/operator/test custodian. Requires separate R04 readiness-inspection authorization. |
| Exact destination | Workbook §§7.1–7.4 R04 rows; Signature Protocol R04 pre-trial checklist. |
| Acceptance / rejection | Accept attributable observations with checks; reject missing identity, unsafe condition, unsuitable measurement or cross-track copy. |
| Stop / downstream | Stop on scope/identity/safety/check failure. Output may support an R04 trial ballot only; it never authorizes a trial. |

### Lane 2 — R04 physical trial

| Attribute | Specification |
|---|---|
| Purpose / included gap | Produce independent raw evidence for `CM-R04-01` (gap 25). |
| Prerequisites | Lane 1 accepted; protocol/formulation frozen; explicit R04 trial authority, tester, location, run limits and validity window. |
| Permitted evidence | Raw dated input/output/loss/time/temperature/vessel/sensory/deviation/repeat records and attestation. |
| Rejected evidence | Calculated values, R05 results, undocumented substitution, public recipe as result. |
| Provider / authority | Authorized tester; Owner later records disposition. Requires separate R04 trial authorization. Recipe review/approval remains separate. |
| Exact destination | Signature Protocol R04 fields §§6.1–6.8; admitted trace may later reference MAKE CSV `test_run_reference`. |
| Acceptance / rejection | Complete raw lineage and departures required; any missing critical measurement fails closed. |
| Stop / downstream | Stop on expired authority, readiness regression, unsafe condition or out-of-scope deviation. Supports separate R04 Recipe review, not approval. |

### Lane 3 — R05 physical readiness

| Attribute | Specification |
|---|---|
| Purpose / included gap | Establish R05-specific readiness for gap 24 without borrowing R04. |
| Prerequisites | Separate R05 inspection scope; exact source-range selections; R05 expected list and blank records. |
| Permitted evidence | R05 coffee, both condensed-milk roles, cream, fresh milk, salt, water/ice, tools, vessel and measurement checks. |
| Rejected evidence | R04 identity/quantity/check transfer, silent cocoa, assumed suitability. |
| Provider / authority | Owner/operator/test custodian. Requires separate R05 readiness-inspection authorization. |
| Exact destination | Workbook §§7.1–7.4 R05 rows; Signature Protocol R05 pre-trial checklist. |
| Acceptance / rejection | Every R05-specific required identity and measurement capability must be attributable and accepted. |
| Stop / downstream | Stop on unresolved range/SKU, missing complete foam-system input, safety/check failure. Supports an R05 trial ballot only. |

### Lane 4 — R05 physical trial

| Attribute | Specification |
|---|---|
| Purpose / included gap | Produce independent raw evidence for `CM-R05-01` (gap 26). |
| Prerequisites | Lane 3 accepted; R05 formulation frozen; separate R05 trial authority and bounded run plan. |
| Permitted evidence | Complete independent R05 extraction and foam-system measurements, losses, time, sensory, deviations and repeats. |
| Rejected evidence | R04 values, hybridization, silent optional cocoa, unrecorded/calculated result. |
| Provider / authority | Authorized tester; later Owner disposition. Separate R05 trial authority; Recipe review/approval separate. |
| Exact destination | Signature Protocol R05 fields §§6.1–6.8; admitted trace may later reference MAKE CSV. |
| Acceptance / rejection | Complete R05 lineage and raw evidence; no cross-track substitution. |
| Stop / downstream | Stop on authority/readiness/safety/deviation failure. Supports separate R05 Recipe review only. |

### Lane 5 — MAKE Recipe/BOM and costing evidence

| Attribute | Specification |
|---|---|
| Purpose / included gap | Close gap 27 for 48 MAKE combinations through evidence-backed Recipe/BOM-to-cost chains. |
| Prerequisites | Applicable trials/acquisition authorized; candidate reviewed; explicit Recipe/BOM approval separate from Recipe review; exact purchase/packaging evidence. |
| Permitted evidence | Versioned approved Recipe, line quantities/units/conversions, batch output, yield/loss, actual transaction/receiving, packaging and reproducible calculation basis. |
| Rejected evidence | Public recipe, estimate, S/M/L scaling, blank-as-zero, unsupported density/conversion/yield/waste or price. |
| Provider / authority | Owner/Recipe approver, authorized tester, supplier/receiver, independent costing verifier. Each trial/acquisition and approval separately authorized. |
| Exact destination | MAKE CSV measurement through approval fields; costing CSV purchase, preparation, yield/waste, packaging, evidence, result and verification fields. |
| Acceptance / rejection | Every required line must be attributable, unit-compatible, approved and independently reproducible; one complete row does not close another. |
| Stop / downstream | Stop on any missing/unapproved line or allocation ambiguity. Complete rows support unit-cost/margin eligibility and A-05 only. |

### Lane 6 — BUY specification, supplier contact and acquisition evidence

| Attribute | Specification |
|---|---|
| Purpose / included gap | Close gap 28 for four BUY chains. |
| Prerequisites | Owner accepts exact finished specification first; supplier contact ballot follows; quotation acceptance and purchase/acquisition are later separate ballots. |
| Permitted evidence | Exact supplier/SKU documents, quote distinct from transaction, purchase unit/conversion, delivery/landed evidence, lot/expiry/storage, receiving, saleable portions and loss. |
| Rejected evidence | Public seller as verified supplier; retail listing as quote/transaction/cost; unsupported supplier claim. |
| Provider / authority | Owner, separately authorized procurement contact/acquirer/receiver, supplier records and verifier. Contact never implies purchase. |
| Exact destination | BUY CSV accepted-specification, supplier, quote, transaction, delivery, receiving/loss and status fields; costing CSV corresponding evidence lines. |
| Acceptance / rejection | Identity, document provenance and scope must match; quotation never proves purchase; receipt mismatch fails closed. |
| Stop / downstream | Stop at each authority boundary or on unverifiable supplier/spec/receipt. Complete chain supports unit cost and A-05. |

### Lane 7 — Channel packaging fit and cost

| Attribute | Specification |
|---|---|
| Purpose / included gap | Close gap 29 for applicable dine-in/takeaway packaging. |
| Prerequisites | Product/channel assignment, authorized material acquisition and bounded fit test. |
| Permitted evidence | Exact SKU, physical fit, quantity per sale, pack conversion, actual transaction/receiving and loss. |
| Rejected evidence | Nominal size alone, candidate mapped to every Product, public price as actual cost, unsupported quantity. |
| Provider / authority | Owner/operator and separately authorized procurement/receiver. Fit and acquisition scopes must be explicit. |
| Exact destination | MAKE CSV dine-in/takeaway packaging measurement fields; BUY packaging fields; costing CSV packaging identity/quantity/unit/cost/evidence fields. |
| Acceptance / rejection | Fit and quantity must match exact Product/Variant/channel; actual cost needs transaction and receiving evidence. |
| Stop / downstream | Stop on fit failure, ambiguity or missing commercial evidence. Supports complete direct cost and A-05. |

### Lane 8 — Qualified professional input

| Attribute | Specification |
|---|---|
| Purpose / included gaps | Nine packages: `CORE-OD-03/04`, `WS-C02-07`, `WS-C04-06..10`, and `WS-RPT-01`. |
| Prerequisites | Package-specific fact/category/scenario inventory complete; competence/independence/conflicts assessed; explicit engagement scope. |
| Permitted evidence | Dated written opinion with citations, assumptions, limitations, alternatives, conflicts and exact questions answered. |
| Rejected evidence | Public research as professional conclusion; generic advice; opinion outside scope; internally authored “external” output. |
| Provider / authority | Qualified discipline-specific professional selected by Owner. Package preparation never implies engagement; each engagement separately authorized. |
| Exact destination | Workbook §9 package manifests; worksheet matching decision/evidence fields; later canonical decision record only after Owner disposition. |
| Acceptance / rejection | Scope, competence, source currency, assumptions and residual questions must be reviewable; conclusion does not itself choose policy. |
| Stop / downstream | Stop on missing facts, conflict, scope drift or unauthorized contact. Supports later Owner decisions and synchronization. |

### Lane 9 — Independent reviews

| Attribute | Specification |
|---|---|
| Purpose / included gaps | `CP3-E03` and `CP3-E04` (gaps 31–32), separately. |
| Prerequisites | Respective CORE-02 or CORE-04 upstream baseline closed and synchronized; exact manifest; independent reviewer and explicit scope. |
| Permitted evidence | Conflict disclosure, evidence index, prior/current findings, severity, disposition and one bounded verdict. |
| Rejected evidence | Author/remediator self-review, internal adversarial review, pre-closure review, predetermined verdict. |
| Provider / authority | Genuine independent reviewer. E03 and E04 require separately approved reviewer selection/engagement and scope. |
| Exact destination | Workbook §§10.1 and 10.2 manifests plus separately retained reviewer outputs. |
| Acceptance / rejection | Reviewer independence and exact baseline must be proven; every material finding must be resolved for closure. |
| Stop / downstream | Stop on upstream change, incomplete manifest or conflict. Supports A-01/A-02/A-06 reassessment; grants no Gate. |

## 6. Evidence acceptance protocol

### 6.1 Required evidence envelope

Every submitted item must carry a stable evidence ID; gap/lane and exact claim; original provider/attester and authority basis; collection/event and receipt dates with timezone where material; original source/location; unaltered original or cryptographic digest; evidence class; Product/Variant/channel/Branch/run/transaction scope; version; supersedes/superseded-by linkage; limitations/unknowns/conflicts; reviewer and review date; acceptance/rejection disposition with rationale; and exact destination reference.

Originals remain immutable. Normalized extracts link back to originals and record the transformation. A correction appends a linked version; it never overwrites the prior record. A newer item supersedes only the exact claim/scope stated, not unrelated evidence.

### 6.2 Intake sequence

1. Confirm lane authority is active and the item is inside its scope and validity window.
2. Assign evidence identity and calculate a digest where practical.
3. Preserve the original before transcription or normalization.
4. Verify provider, date, scope, source authenticity and required fields.
5. Search stable IDs, digests, transaction/run references and content for duplicates.
6. Compare against existing evidence; quarantine missing, uncertain, stale or conflicting items.
7. Reproduce conversions/calculations from cited inputs without hidden defaults.
8. Obtain the lane-specific independent verification where required.
9. Record acceptance or rejection with reviewer, date, reason and downstream effect.
10. Update a canonical destination only under separate write authority; otherwise retain the item in intake pending state.

Missing is never zero or not applicable. Uncertainty remains explicit. Conflicting evidence is preserved and blocks the affected claim until an authorized resolver disposes it. Duplicate evidence does not increase confidence or quantity. Reproducibility requires exact inputs, units, conversions, method, version and result. Audit history is append-only and must expose submission, review, rejection, correction, acceptance and supersession.

### 6.3 Mandatory rejection rules

Reject:

- public market listings presented as quotations, transactions, actual purchase or landed cost;
- public recipes presented as approved AFTER FOUR Recipe/BOM;
- simulated, templated or recollected operational scenarios presented as actual events;
- supplier identities, capabilities, SKUs or commercial terms that cannot be verified from an attributable source;
- any R04 result copied into R05, any R05 result copied into R04, or a hybrid result without separately authorized identity;
- conversions, density, scaling, yield, waste/remake, packaging fit/quantity or allocation without source-matched evidence;
- internally generated, author/remediator, or conflict-affected work presented as independent review;
- blank fields interpreted as zero/free/not applicable;
- evidence collected outside an active authorization or after its stop/expiry condition;
- a quotation represented as purchase, contact represented as supplier approval, or supplier contact represented as purchasing authority.

## 7. Proposed Owner authorization ballot architecture

Every ballot item defaults to `NOT_AUTHORIZED`. It must contain: unique ballot ID; lane/activity; exact scope and exclusions; prerequisite evidence; named responsible party; permitted actions; prohibited actions; destinations; start/expiry; quantity/run/contact limits; confidentiality/data limits; stop conditions; required output; downstream effect; and one selection: `AUTHORIZE_AS_WRITTEN`, `AUTHORIZE_WITH_RECORDED_CONDITIONS`, `DEFER`, or `REJECT`. This document records no selection.

Minimum separate ballot items:

| Proposed item | Must remain separate from |
|---|---|
| R04 material acquisition/contact, if needed | R04 inspection and trial |
| R04 readiness inspection | R04 trial; R05 anything |
| R04 bounded trial | Recipe review; Recipe/BOM approval |
| R04 Recipe candidate review | Recipe/BOM approval and costing admission |
| R04 Recipe/BOM approval | Trial execution and procurement |
| R05 material acquisition/contact, if needed | R05 inspection and trial |
| R05 readiness inspection | R05 trial; R04 anything |
| R05 bounded trial | Recipe review; Recipe/BOM approval |
| R05 Recipe candidate review | Recipe/BOM approval and costing admission |
| R05 Recipe/BOM approval | Trial execution and procurement |
| Each BUY Product specification | Supplier contact |
| Bounded supplier contact / RFQ | Quotation acceptance and purchase |
| Quotation acceptance | Purchase/acquisition |
| Purchase/acquisition | Receiving acceptance |
| Packaging material acquisition | Packaging fit test and cost acceptance |
| Packaging fit test | Packaging cost/procurement acceptance |
| Each qualified-professional engagement | Independent review and Owner policy choice |
| `CP3-E03` independent review | `CP3-E04`; professional advice |
| `CP3-E04` independent review | `CP3-E03`; professional advice |
| Recipe review | Recipe/BOM approval |
| Canonical synchronization | Any underlying policy/evidence decision |

No ballot may bundle R04/R05, readiness/trial, contact/acquisition, professional engagement/independent review, or Recipe review/Recipe approval. Expiry or a stop condition returns the activity to `NOT_AUTHORIZED`; it does not create implied renewal.

## 8. Commercial V1 data-integrity contract

Until legitimately accepted evidence and separate write authority exist:

1. Preserve exactly 28 Products and 52 unique Product/Variant keys.
2. Preserve exactly 48 `MAKE_IN_HOUSE` and four `BUY_FINISHED` combinations.
3. Preserve `verification_status = MISSING_INPUT` for all unsupported costing rows.
4. Preserve all 48 MAKE rows as unapproved; no Recipe admission without explicit approval provenance.
5. Preserve all four BUY chains as incomplete until specification, supplier, quotation/transaction, delivery/receiving and loss evidence satisfy their chain.
6. Keep unit-cost and gross-margin result fields blank whenever any required component or applicable tax/rounding boundary is unsupported.
7. Never change `CORE-OD-01` or `CORE-OD-18` through evidence intake.
8. Keep Product/Variant/price/channel/Branch identity aligned across the four canonical CSVs and pricing specification.
9. Treat one Product/Variant/channel chain as independent unless an approved versioned shared component and allocation basis proves reuse.
10. Reject duplicate keys, orphan evidence references, mismatched units, unsupported conversion, overlapping effective evidence without disposition, and blank-as-zero.

Future read-only validation must parse CSV structurally; assert row/key/method/status counts; compare Product/Variant/price identities; validate required enum states and evidence references; check that each nonblank result has a complete provenance chain and reproducible basis; verify R04/R05 isolation; and fail closed on any unexplained hash or canonical decision change. This contract specifies validation only; it implements no code.

## 9. Concurrent-workstream isolation

### 9.1 Frozen before snapshot

| Item | State before CE-02 file creation |
|---|---|
| Branch / HEAD | `development` / `7efb60b028de02126e8fc01762203f385005019e` |
| Upstream | `development...origin/development` |
| Staged | None |
| Modified tracked | `docs/architecture/after_four_pos_business_features_status.md` |
| Pre-existing untracked | POS Gate B authorization package; CE-01 report; Organization-Level Audit executable-acceptance package; POS Gate B repository evidence |

Controls:

- Capture branch, HEAD, staged/modified/untracked state and hashes before and after work.
- Treat every pre-existing change as another workstream's property; do not edit, stage, discard, rename or normalize it.
- Re-read and re-hash a controlling commercial artifact before later intake; stop on an unexplained change.
- Never infer commercial authority from POS Gate B or Audit package status.
- Keep future commercial evidence inside the existing authorized intake artifacts; create no source, schema, migration, producer, integration, application or database.
- If `development` HEAD, canonical commercial files, or the 32-gap governing baseline changes, pause package use and perform scoped reconciliation before relying on it.

## 10. CE-02 acceptance criteria

CE-02 package preparation is complete only when:

1. Authority and prohibited-action boundaries are explicit.
2. The controlling artifacts and canonical CSV destinations have path, purpose, authority/status, classification, hash where practical, and permitted role.
3. Exactly 32 gap rows retain the governing identity/count/class and include all twelve required intake dimensions.
4. The matrix states that row 30 alone is closed and the other 31 are not internally closable.
5. Exactly nine independent lanes include purpose, gaps, prerequisites, accepted/rejected evidence, provider, authority, destinations, acceptance/rejection, stop conditions and downstream dependencies.
6. R04/R05, readiness/trial, contact/acquisition, professional engagement/independent review and Recipe review/approval are unbundled.
7. The evidence protocol preserves provenance, originals, versions, conflicts, duplicates, reproducibility, independent verification and audit history.
8. The ballot architecture pre-approves nothing.
9. The Commercial V1 contract reproduces 28/52/48/4, 52/52 missing, 48 unapproved MAKE, four incomplete BUY, and zero unsupported results without changing `CORE-OD-01/18`.
10. Concurrent files remain untouched; only this package is added; nothing is staged.
11. Local links, CSV parseability, whitespace, exact gap/lane counts and single-verdict checks pass.

Meeting these criteria does not complete Milestone A, accept evidence, activate a lane, authorize implementation, or alter any Owner decision.

## 11. Validation and Git after snapshot

Documentation-only validation must record the actual post-write state. No application, database, migration, frontend, backend or network command is required or authorized.

| Comparison | Before | After |
|---|---|---|
| Branch / HEAD | `development` / `7efb60b028de02126e8fc01762203f385005019e` | Unchanged: `development` / `7efb60b028de02126e8fc01762203f385005019e` |
| Staged | None | None |
| Existing modified/untracked files | One modified POS status file; four untracked CE-01/POS/audit files | Same five paths preserved; three independently created untracked POS B1 review-assignment files appeared during CE-02 preparation |
| CE-02 package | Absent | This untracked file only |

The concurrent additions are `docs/research/pos_2a_b1_architecture_ddd_independent_review_assignment.md`, `docs/research/pos_2a_b1_identity_security_independent_review_assignment.md`, and `docs/research/pos_2a_b1_organization_contract_independent_review_assignment.md`. CE-02 did not create, inspect for modification, edit, stage, or rely on them. The exact CE-02 file set is one created file: this package; no existing file was modified by this task.

## 12. Unresolved ambiguity and conflict

No controlling baseline conflict was found at preparation time. Historical pre-`CORE-OD-18` missing-price findings and public recipe/market candidates remain non-controlling by their own status notices and evidence labels. The substantive unknowns are the same open evidence/authority dependencies in §4, not a documentation contradiction. Any later mismatch in hashes, counts, Owner authority, gap identity, or R04/R05 isolation is a stop condition requiring scoped Owner review.

## 13. Final verdict

**`READY_FOR_OWNER_CE02_PACKAGE_REVIEW`**

This verdict means the documentation package is ready for Owner review only. No evidence was collected, no lane was activated, and no execution authority follows.
