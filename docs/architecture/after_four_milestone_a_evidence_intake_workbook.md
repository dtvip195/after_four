# AFTER FOUR — Milestone A Evidence Intake Workbook

**Status:** `ACTIVE INTAKE PREPARATION — NO EVIDENCE OR AUTHORITY IMPLIED`

**Assessment baseline:** 2026-11-25; branch `docs/design-readiness-acceleration`; HEAD `fc95b10bf5a077e37fc440708ea09046bfd3677b`

**Governing analysis:** [Milestone A Comprehensive Evidence and Decision Gap Report](../research/after_four_milestone_a_comprehensive_evidence_and_decision_gap_report.md)

**Canonical decisions:** [Owner Decision Baseline](after_four_owner_decision_baseline.md) and [Owner Decision Worksheet](after_four_core_02_core_04_owner_decision_worksheet.md)

## 1. Purpose and evidence boundary

This workbook routes the 32 atomic Milestone A gaps to practical intake questions and existing authoritative capture artifacts. It is not a new decision baseline, event ledger, Recipe/BOM, procurement record, professional opinion, or independent review. Actual evidence must be retained in the destination named below; this workbook records readiness and routing only.

Allowed response markers are `CONFIRMED_WITH_DOCUMENT`, `OWNER_CONFIRMED_FACT`, `OWNER_CONFIRMED_PLAN`, `OWNER_DEFERRED`, `OWNER_RECOLLECTION`, `OBSERVED_FACT`, `UNKNOWN`, `NOT_YET_DECIDED`, and `NOT_APPLICABLE`. `OWNER_CONFIRMED_FACT` and `OWNER_CONFIRMED_PLAN` record provenance, not independent documentary verification. `OWNER_DEFERRED` preserves a dependency and suspends repeat intake until the Owner resumes it. A marker must not be upgraded without the evidence required by its class. Blank means no response was supplied.

No field in this workbook authorizes external contact, RFQ, purchase, trial, professional engagement, independent review, implementation, capability, Gate, FOA, or Production Authorization.

## 2. Thirty-two-gap intake routing register

The row count and classification must remain exactly reconciled with the governing gap report. One atomic gap may require multiple intake records; those records do not create new gap identities.

| Existing reference / gap | Primary class | Intake section or authoritative destination | Supported provider / attester | Provenance required | Acceptance / rejection boundary | Dependency, next action and closure |
|---|---|---|---|---|---|---|
| `CORE-OD-03` | `QUALIFIED_PROFESSIONAL_INPUT` | §§3, 9; qualified Tax/Accounting output | Owner supplies facts; later qualified Vietnamese reviewer only if explicitly commissioned | Registration/workflow documents, dated opinion, citations, assumptions | Accept scoped applicability analysis; reject generic law as AFTER FOUR classification | Complete §3 fact pack → qualified analysis → Owner policy → canonical sync |
| `CORE-OD-04` | `QUALIFIED_PROFESSIONAL_INPUT` | §9; calculation examples retained with worksheet | Owner supplies scenarios; qualified Accounting reviewer if commissioned | Worked examples, methods compared, dated analysis | Reject framework default or “integer VND” as complete policy | `CORE-OD-03` interactions/examples → analysis → Owner policy |
| `WS-C02-01` | `OWNER_DECISION` | §4.1; worksheet §§3/15 | Owner after Operations and qualified input | Scenario/source inventory, provenance, failure/abuse analysis | Reject login/ack/transport as transfer proof | Collect scenarios → qualified constraints → Owner selects/defers |
| `WS-C02-02` | `OWNER_DECISION` | §4.1; worksheet | Owner after responsibility/control evidence | Actor responsibility, authority basis, conflict/separation scenarios | Reject generic Staff or authentication authority | `WS-C02-01` input → answer authority/sufficiency/separation independently |
| `WS-C02-03` | `OWNER_DECISION` | §4.1; worksheet | Owner after Operations/Privacy/Governance input | Recipient/representative scenario and authorization basis | Reject acknowledgement-only linkage | Collect linkage cases → Owner selects/defers paths |
| `WS-C02-04` | `OWNER_DECISION` | §4.1; worksheet | Owner | Approved-class combinations and false-positive/hold analysis | Reject unspecified or timeout-based threshold | Depends on `WS-C02-01`–`03`; select/defers threshold |
| `WS-C02-05` | `OWNER_DECISION` | §4.2; worksheet scenario matrix | Owner after Operations/customer-service evidence | Negative-case records and consequence analysis | Reject automatic transfer/closure/Refund/new attempt | Complete each scenario consequence or defer |
| `WS-C02-06` | `OWNER_DECISION` | §4.2; worksheet | Owner after conflict/control analysis | Conflict type/materiality, evidence, separation and escalation | Reject replay, silent supersession or self-appointed resolver | Conflict pack → qualified limits → Owner authority decision |
| `WS-C02-07` | `QUALIFIED_PROFESSIONAL_INPUT` | §§4.1, 9 | Operations/records facts; qualified Privacy/Legal/Governance input if commissioned | Data/category/purpose/flow/access/correction/retention inventory | Reject universal period, destructive correction or unnecessary personal data | Inventory → qualified analysis → Owner policy |
| `WS-C04-01` / `CORE-OD-12` | `OWNER_DECISION` | §5.1; worksheet | Owner after Cash/Accounting control input | Operation/responsibility scenarios | Reject title, Shift or Branch Assignment as capability | Inventory each operation → Owner holder policy |
| `WS-C04-02` / `CORE-OD-12` | `OWNER_DECISION` | §5.1; worksheet | Owner | Continuity/delegation/revocation/emergency scenarios | Reject urgency-derived or default delegation | `WS-C04-01` → Owner bounded policy |
| `WS-C04-03` / `CORE-OD-12` | `OWNER_DECISION` | §5.1; worksheet | Owner | Staffing/conflict and control analysis | Reject Expense rule generalized to Cash | `WS-C04-01/02` → explicit separation matrix |
| `WS-C04-04` / `CORE-OD-13` | `OWNER_DECISION` | §5.2; worksheet | Owner after Cash/Accounting/Reporting input | Actual error cases and linked-correction consequences | Reject reopening, rewrite or generic adjustment | Authority inputs → enumerate/exclude operations |
| `WS-C04-05` | `OWNER_DECISION` | §5.2; worksheet | Owner | Cash handover disagreement scenarios and evidence | Reject acknowledgement as approval/Close | Preserve `CORE-OD-14A/B`; decide post-escalation handling |
| `WS-C04-06` | `QUALIFIED_PROFESSIONAL_INPUT` | §5.2 | Cash/Accounting/Reporting facts and qualified input | Discrepancy scenario, investigation and waiting evidence | Reject tolerance, auto correction or disposition-as-resolution | Analyze cases → Owner decides residual policy |
| `WS-C04-07` | `QUALIFIED_PROFESSIONAL_INPUT` | §5.2 | Accounting/Reporting input | Source-lineage completeness, conflict and correction cases | Reject balanced total without complete sources | `WS-C04-04/06` → reconciliation criteria |
| `WS-C04-08` | `QUALIFIED_PROFESSIONAL_INPUT` | §5.2 | Accounting/Reporting input | Report inventory, source completeness and exception cases | Reject disposition/reconciliation as automatic issuance | `WS-C04-07` → Owner issuance preconditions |
| `WS-C04-09` / `CORE-OD-16B` | `QUALIFIED_PROFESSIONAL_INPUT` | §§5.2, 9 | Report owner facts plus Identity/Governance/Privacy input | Report/category/purpose/Branch inventory | Reject generic role or issuance as read/export authority | Inventory → qualified analysis → Owner reader policy |
| `WS-C04-10` / `CORE-OD-16F` | `QUALIFIED_PROFESSIONAL_INPUT` | §§5.2, 9 | Records facts plus Legal/Privacy/Accounting-records input | Category/purpose/legal basis/period/hold inventory | Reject universal period or deletion that rewrites evidence | Inventory → qualified analysis → Owner records policy |
| `WS-RPT-01` | `QUALIFIED_PROFESSIONAL_INPUT` | §6 | Owner/Operations facts plus Accounting/Reporting input | Event, recorded, correction and business dates by fact type | Reject whole-Shift convenience assignment or rewritten time | Scenario pack → analysis → Owner category rule |
| First Branch legal/entity/Product/channel facts | `OWNER_FACT_CONFIRMATION` | §3 | Owner; documents where available | Source name/reference/date and evidence class | Reject inference from menu, public law or memory labelled documentary | Complete fact pack with unknowns explicit |
| `EA1-D01-*` custody events | `OBSERVED_OPERATIONAL_EVIDENCE` | §4 actual-event record; future authoritative operational source | Actual authorized actors after lawful operation | Stable IDs, authority, event/recorded time, raw evidence and lineage | Reject desired process, simulation, template or recollection as event | Applicable policy/authority and operation first; then observed cases |
| `EA1-D03-*` Cash/report events | `OBSERVED_OPERATIONAL_EVIDENCE` | §5 actual-event record; future authoritative operational source | Actual authorized actors/reviewers after lawful operation | Source records, approvals, versions, linked corrections and outcomes | Reject synthetic totals or policy prose | Control baseline and operation first; then observed cases |
| R04/R05 readiness documents | `DOCUMENTARY_EVIDENCE` | §7 routing; [Signature Protocol §§2–3](../research/after_four_commercial_v1_signature_practical_test_protocol.md) | Owner/operator; package/equipment documents | Label/SKU, source/date, equipment check and vessel measurement | Reject public listing as physically present input | Complete separately for each track before go/no-go |
| `CM-R04-01` | `PHYSICAL_TRIAL_EVIDENCE` | Existing Signature Protocol R04 raw run sheets | Actual tester after explicit trial authorization | Dated raw measurements, deviations, repeat identity and attestation | Reject copied/calculated/R05 values or unrecorded claim | Documentary readiness + authority → trial → Owner disposition |
| `CM-R05-01` | `PHYSICAL_TRIAL_EVIDENCE` | Existing Signature Protocol R05 raw run sheet | Actual tester after explicit trial authorization | Same evidence standard, retained under R05 | Reject R04 transfer, hybridization or silent optional cocoa | Documentary readiness + authority → trial → Owner disposition |
| 48 MAKE combinations | `COMMERCIAL_OR_PROCUREMENT_EVIDENCE` | [MAKE input CSV](after_four_commercial_v1_make_recipe_bom_input.csv) and [costing CSV](after_four_commercial_v1_costing_input.csv) | Owner/Recipe reviewer, operator/tester, actual supplier/transaction evidence | Recipe version, quantities/conversions, yield/loss, purchase and packaging evidence | Reject public recipes/listings, estimates or unsupported scaling | Complete row chain → reproducible calculation → independent check |
| Four BUY chains | `COMMERCIAL_OR_PROCUREMENT_EVIDENCE` | [BUY procurement CSV](after_four_commercial_v1_buy_finished_procurement_input.csv) and costing CSV | Owner specification; actual supplier/transaction/receiver after authority | Specification, supplier/SKU, quote vs transaction, delivery/receiving/loss | Reject public seller as supplier or retail price as cost | Specification → contact/acquisition authority → commercial chain |
| Channel packaging | `COMMERCIAL_OR_PROCUREMENT_EVIDENCE` | Costing and MAKE/BUY CSV packaging fields | Owner/operator fit evidence and actual supplier documents | SKU, fit, quantity/sale, pack conversion, transaction/receiving | Reject candidate package assigned without fit/applicability | Channel assignment + fit → commercial evidence → cost |
| Post-decision canonical synchronization | `INTERNAL_DOCUMENTATION_GAP` | Baseline, worksheet, domain/data/integrity/state/API sources | Codex may synchronize only recorded decisions | Decision provenance and reviewed cross-document diff | Reject recommendation or single-file update as policy trace | Triggered after each decision; close with zero current contradictions |
| `CP3-E03` | `INDEPENDENT_REVIEW` | §10 intake manifest and reviewer output | Independent reviewer only after explicit selection/engagement | Exact baseline, conflict disclosure, evidence and finding trace | Reject author/self-review or pre-closure review | CORE-02 closure/sync → independent review → bounded verdict |
| `CP3-E04` | `INDEPENDENT_REVIEW` | §10 intake manifest and reviewer output | Independent reviewer only after explicit selection/engagement | Same standard for CORE-04 | Reject internal adversarial review as independent | CORE-04 closure/sync → independent review → bounded verdict |

Classification reconciliation: 11 `OWNER_DECISION` + 1 `OWNER_FACT_CONFIRMATION` + 2 `OBSERVED_OPERATIONAL_EVIDENCE` + 1 `DOCUMENTARY_EVIDENCE` + 2 `PHYSICAL_TRIAL_EVIDENCE` + 3 `COMMERCIAL_OR_PROCUREMENT_EVIDENCE` + 9 `QUALIFIED_PROFESSIONAL_INPUT` + 1 `INTERNAL_DOCUMENTATION_GAP` + 2 `INDEPENDENT_REVIEW` = **32**.

There is no `CONDITIONAL_SYNCHRONIZATION` primary class in this workbook or the governing report. The report's adjective “conditional” describes when the single `INTERNAL_DOCUMENTATION_GAP` is triggered: after a new decision or evidence changes a canonical representation. It is not a reclassification, duplicate or replacement gap. For the current confirmed-policy baseline that gap is `CLOSED_CURRENT_BASELINE — REOPENS_ON_TRIGGER`; it reopens automatically on the next applicable change.

### 2.1 Readiness axis (separate from Milestone completion)

| Axis | Current boundary |
|---|---|
| Initial software design/build | Exact-balance cash may remain the bounded initial Payment path under `CORE-OD-07`. A future bank account, supplier, opening hours or actual transaction is not required to model the already-approved cash-only slice. No Gate or implementation authority follows. |
| Later configuration / launch | The Owner-confirmed First Branch legal/site plans, actual registration, tax setup, bank/account/QR configuration, operational assignments and launch documents are later configuration/launch inputs. Deferred details remain open where a formal conclusion depends on them. |
| Commercial / physical / operational evidence | R04/R05 measurements, Recipe/BOM results, procurement/receiving, packaging fit/cost and future actual events require real attributable evidence. Templates are not completion. |
| Qualified professional input | The nine §9 packages require the stated fact packs and later explicit commissioning authority. Public sources are not professional conclusions. |
| Independent review | `CP3-E03/E04` require closed upstream traces, a genuine independent reviewer and explicit review authority. Internal validation is not independence. |

## 3. First Branch fact-intake package

The Owner supplied the bounded facts/plans below on 2026-11-25. Deferred details must not be requested again until the Owner resumes them. Do not include personal IDs, home addresses, bank credentials, health data, or other unnecessary personal data.

| Fact question | Why it matters | Acceptable source evidence | Response marker | Owner response | Source reference/date |
|---|---|---|---|---|---|
| What legal entity or individual is intended to be the seller? | Tax, invoice, licensing and contracting applicability. | Registration/tax document or Owner-confirmed plan with documentary status still missing. | `OWNER_CONFIRMED_PLAN`; remaining identity details `OWNER_DEFERRED` | Planned Vietnamese household business (`Hộ kinh doanh`); not registered; future registration planned. Planned name, named owner and registration details are deferred. | Owner confirmation, 2026-11-25; no registration document. |
| What tax registration and calculation method is actually recorded? | `CORE-OD-03` applicability. | Current tax registration/notice; otherwise `UNKNOWN`. | `OWNER_DEFERRED` | No registration yet. Tax registration, method and related documents are deferred pending later Owner update. | Owner confirmation, 2026-11-25; no tax document. |
| What is the First Branch's exact planned/actual operating address and premises status? | Local authority, food-safety and invoice/site applicability. | Lease/title/site record; incomplete planned site remains documentary-unverified. | `OWNER_CONFIRMED_PLAN`; details/documents `OWNER_DEFERRED` | Planned location: Hai Bà Trưng, Hội An; family premises; rent paid to a family member; oral arrangement; no written lease/agreement. Ownership, exact address, recipient, amount and documents are deferred. | Owner confirmation, 2026-11-25; no premises document. |
| Is the First Branch operating, pre-opening, paused, or only planned? | Separates actual events from desired process. | Dated Owner confirmation plus operational documents if any. | `OWNER_CONFIRMED_FACT` | Not operating; future opening remains planned. | Owner confirmation, 2026-11-25; no operational event claimed. |
| Which channels are actually planned at launch: dine-in, takeaway, any delivery platform? | Tax/invoice, packaging and workflow scope. | Owner-confirmed launch scope; platform agreement only if real. | `OWNER_CONFIRMED_FACT` | Dine-in and takeaway are confirmed. No delivery platform is established by the current baseline. | `CORE-OD-01`, `CORE-OD-18`; Owner confirmation dates 2026-11-24/25. |
| Are all 28 Products still planned for both confirmed channels? | Commercial and packaging scope; does not alter current baseline by itself. | Owner confirmation tied to Commercial V1. | `OWNER_CONFIRMED_FACT` | Yes. All 28 Products remain in dine-in and takeaway at the same proposed V1 price. | `CORE-OD-18`, scope reconciled 2026-11-25. |
| What receipt/invoice flow is intended for an ordinary sale? | Tax/e-invoice and source-lineage analysis. | Intended workflow labelled `NOT_YET_IMPLEMENTED`; actual documents only if operation exists. | `OWNER_CONFIRMED_PLAN`; invoice details `OWNER_DEFERRED` | Cash received directly from customers; bank transfer to a separate business-dedicated account. Bank/account/QR/provider/settlement/reconciliation facts and the invoice flow are not established. | Owner confirmation, 2026-11-25; no transaction or invoice evidence. |
| Who are the transaction parties in dine-in and takeaway cases? | Seller/buyer/recipient distinctions and personal-data minimization. | Role descriptions only; do not provide unnecessary customer identity. | `OWNER_CONFIRMED_PLAN` / `UNKNOWN` | Intended seller is the future household business; customer pays cash or bank transfer. Named seller identity and any buyer/recipient distinctions beyond the customer role remain unverified. | Owner confirmation, 2026-11-25; no actual transaction. |
| Which registrations, licences, notifications, leases and tax records already exist? | Establishes documentary facts and gaps. | Document title/issuer/number/date/status; attach via approved internal process only. | `OWNER_CONFIRMED_FACT`; follow-up `OWNER_DEFERRED` | Household business is not registered; no written lease/agreement. Other registration, licence, notification and tax records are not established and the specified entity/premises documents are deferred. | Owner confirmation, 2026-11-25; no documents supplied. |
| Which operational responsibilities are intended for Ordering, Preparation, Cash and Reporting? | Builds scenario packs without granting capabilities. | Owner-attested responsibility description, explicitly not runtime authority. |  |  |  |
| Which facts are known only from recollection? | Prevents recollection becoming documentary/observed evidence. | Explicit `OWNER_RECOLLECTION` list. | `OWNER_CONFIRMED_FACT_OR_PLAN — DOCUMENTARY_STATUS_MISSING` | Planned form/location, family-premises/rent arrangement, non-operation and receipt plan are Owner-supplied only; no independent verification is claimed. | Owner confirmation, 2026-11-25. |
| Which requested facts are unknown, not decided or not applicable? | Avoids forced or fabricated answers. | `UNKNOWN`, `NOT_YET_DECIDED`, `OWNER_DEFERRED`, or `NOT_APPLICABLE` with reason. | `OWNER_DEFERRED` / `UNKNOWN` | All specified premises/rent/entity/registration/tax details and documents are deferred. Bank, account holder/details, QR provider, settlement/reconciliation evidence and invoice flow are unknown and must not be requested in this sprint. | Owner direction, 2026-11-25. |

Completion of this section is fact intake, not legal/tax classification or Owner policy approval.

## 4. CORE-02 Operations scenarios and evidence

### 4.1 Scenario intake record

Create one record per hypothetical scenario now and one separate record per future actual event. Never overwrite `scenario_type`.

| Field | Entry |
|---|---|
| `scenario_type` (`HYPOTHETICAL` / `ACTUAL_EVENT`) |  |
| Scenario name and trigger |  |
| Dine-in / takeaway |  |
| Stable Order, Ticket and custody-attempt references, if actual |  |
| Preparation completion state |  |
| Intended customer / authorized-recipient relationship required |  |
| Delivery actor and attester responsibilities; authority remains unapproved unless cited |  |
| Candidate evidence source/class and availability |  |
| Evidence creator, capture time, event time and timezone |  |
| Provenance, revisions and integrity facts |  |
| Missing, stale, ambiguous, mismatched or conflicting evidence |  |
| Customer communication and operational consequence proposed/observed |  |
| Privacy purpose, minimum data and access need |  |
| Source/attestation and evidence classification |  |
| Related `WS-C02-*` questions |  |

Minimum hypothetical catalogue: ordinary intended-customer collection; authorized representative; absent customer; refusal; evidence unavailable; stale/unverifiable evidence; recipient mismatch; conflicting/disputed assertions; lost response/transport uncertainty; later evidence in the same attempt; attempted replay/new-attempt bypass.

### 4.2 Acceptance and rejection

- Accept an actual record only with stable identity, attributable actor/evidence, event and recorded timestamps, provenance and retained contrary history.
- Keep hypothetical records explicitly hypothetical.
- Reject acknowledgement, login, command success, timeout, transport response or lack of objection as custody transfer.
- Reject Employee Shift Handover or Cash Session Handover evidence as Customer custody evidence.
- Reject silent evidence overwrite, conflict bypass, new attempt or Order/Refund advancement without separate authority.

## 5. CORE-04 Operations scenarios and evidence

### 5.1 Authority and operation intake

Complete one hypothetical scenario per operation before asking for positive authority policy. A future actual record requires lawful operation and the applicable approved capability.

| Operation | Scenario trigger and desired sequence | Intended actors/responsibilities, not authority | Evidence/source records required | Negative/exception cases to supply | Related gaps |
|---|---|---|---|---|---|
| Cash Session Open |  |  | Branch, Operating Day, actor/time, opening evidence | Missing authority/evidence; duplicate/open Session | `WS-C04-01`–`03` |
| Count |  |  | Count source, actor/time, expected/actual, variance/reason | Nonzero variance; recount disagreement | `WS-C04-01`–`03/06` |
| Cash handover |  |  | Approved six evidence elements; acknowledgement/refusal | Incoming absent; refusal/disagreement | `WS-C04-05`; preserve `CORE-OD-14A/B` |
| Separate Close |  |  | Close actor/capability basis, source totals, unresolved cases | Handover acknowledged but not Close; discrepancy open | `CORE-OD-12`; `WS-C04-01`–`03/07` |
| Linked post-close correction |  |  | Original immutable fact, linked candidate correction, reason/evidence | Unsupported operation; conflicting correction | `CORE-OD-13`; `WS-C04-04` |
| Discrepancy investigation/disposition |  |  | Every nonzero value, reason, Owner notice, investigation, Owner outcome | Owner unavailable; evidence incomplete | `WS-C04-06` |
| Reconciliation |  |  | Complete lineage, correction state, unresolved-case treatment | Missing/conflicting source | `WS-C04-07` |

### 5.2 Expense, Refund and official-report intake

| Process | Facts to keep distinct | Required evidence | Confirmed boundary | Still unresolved |
|---|---|---|---|---|
| Operating Expense | Request, prior Owner approval, incurrence/execution, reconciliation | Requester, purpose, amount, recipient, evidence, Owner approval/time, executor/result | Every Expense requires prior Owner approval; no emergency pre-approval exception | Accounting/control application and actual events |
| Refund | Receipt, eligibility/amount assessment, Owner approval, execution, reconciliation | Original Payment/Order, reason, evidence, request/review, Owner approval, executor/result | Owner-only approval; Owner-unavailable request remains pending/unexecuted under `WS-REFUND-01` | Eligibility, method/allocation, reviewer/executor, Accounting treatment |
| Official report | Source lineage, reconciliation/annotation, issuance, read, export, delivery, correction/version | Report identity/version, included sources, unresolved facts, issuer/time, supersession lineage | Owner-only official issuance; issuance grants no read/export/delivery authority | Preconditions, readers, export/delivery/recipients, retention |

Reject any record that collapses request into approval, approval into execution, discrepancy disposition into report issuance, or issuance into read/export/delivery authority.

## 6. Cross-midnight reporting scenario pack

Create one row per fact type and scenario. Hypothetical rows inform `WS-RPT-01`; future actual rows require source provenance.

| Fact type | Scenario type | Event time + timezone | Recorded time + timezone | Source business date / Operating Day | Correction time/version | Confirmed cutoff | Exact Accounting/Reporting question | Source/provenance |
|---|---|---|---|---|---|---|---|---|
| Order / Order Item |  |  |  |  |  | `00:00 Asia/Ho_Chi_Minh` |  |  |
| Payment / Refund |  |  |  |  |  | `00:00 Asia/Ho_Chi_Minh` |  |  |
| Cash movement / Count / Close |  |  |  |  |  | `00:00 Asia/Ho_Chi_Minh` |  |  |
| Expense |  |  |  |  |  | `00:00 Asia/Ho_Chi_Minh` |  |  |
| Preparation / custody transfer |  |  |  |  |  | `00:00 Asia/Ho_Chi_Minh` |  |  |
| Linked correction / report version |  |  |  |  |  | `00:00 Asia/Ho_Chi_Minh` |  |  |

Do not move or rewrite a source timestamp to obtain a desired reporting date. Shift or Session identity does not by itself allocate every contained fact.

## 7. R04/R05 physical-evidence routing

The existing [Signature Practical Test Protocol](../research/after_four_commercial_v1_signature_practical_test_protocol.md) remains the authoritative formulation and run-sheet destination. This section is the consolidated pre-authorization physical-inspection worksheet. All observation fields are intentionally blank or `NOT_RECORDED`; completing a row proves only the stated evidence class and never authorizes a trial.

Status axes are independent:

- `EXPECTED`: required by the canonical source/protocol.
- `PHYSICALLY_OBSERVED`: an actual item was inspected and an attester/date/reference recorded.
- `IDENTITY_VERIFIED`: observed label/specification matches the expected identity; observation alone is insufficient.
- `MEASUREMENT_READY`: the item/tool demonstrably supports the protocol measurement; identity alone is insufficient.

Trial-level states are `PHYSICAL_INVENTORY_INCOMPLETE`, `PHYSICAL_INVENTORY_COMPLETE`, `PROTOCOL_READY`, `OWNER_AUTHORIZATION_PENDING`, `AUTHORIZED_NOT_STARTED`, `TRIAL_IN_PROGRESS`, `TRIAL_COMPLETED_PENDING_ACCEPTANCE`, `ACCEPTED`, and `REJECTED`. A checklist cannot advance a trial beyond `OWNER_AUTHORIZATION_PENDING`; only an explicit later Owner authorization can create `AUTHORIZED_NOT_STARTED`.

### 7.1 Expected physical inventory register

| Item reference | Trial | Recipe role | Expected identity | Provisional candidate | `EXPECTED` | `PHYSICALLY_OBSERVED` | `IDENTITY_VERIFIED` | `MEASUREMENT_READY` | Acceptance status |
|---|---|---|---|---|---|---|---|---|---|
| `R04M-I01/I02` | R04 | Coffee input | Trung Nguyên Sáng Tạo 1; 100% Robusta ground coffee; 340 g | `I01/I02`; retailer/exact physical SKU remains open | `YES` | `NOT_RECORDED` | `NOT_RECORDED` | `NOT_RECORDED` | `PENDING` |
| `R04M-I03` | R04 | Condensed milk in beverage | Vinamilk Ông Thọ green-label sweetened condensed milk; 380 g | `I03` | `YES` | `NOT_RECORDED` | `NOT_RECORDED` | `NOT_RECORDED` | `PENDING` |
| `R04M-I05/I06` | R04 | Whipping-cream foam base | Anchor UHT Whipping Cream; 1 L | `I05/I06`; retailer/exact physical SKU remains open | `YES` | `NOT_RECORDED` | `NOT_RECORDED` | `NOT_RECORDED` | `PENDING` |
| `R04M-I10/I11` | R04 | Salt within complete foam system | Fine salt Product suitable for measured 1.0 g R04 input | `I10` preferred for review; `I11` retained alternative; neither approved | `YES` | `NOT_RECORDED` | `NOT_RECORDED` | `NOT_RECORDED` | `PENDING` |
| `R04M-I12` | R04 | Brew water | Aquafina 1.5 L bounded comparator | `I12`; actual sealed package/source unverified | `YES` | `NOT_RECORDED` | `NOT_RECORDED` | `NOT_RECORDED` | `PENDING` |
| `R04M-I13` | R04 | Ice | Identified, safely handled ice source; actual mass measured | No candidate established | `YES` | `NOT_RECORDED` | `NOT_RECORDED` | `NOT_RECORDED` | `PENDING` |
| `CM-R05-01 / coffee` | R05 | Coffee input | Phin coffee; source quantity 20 g; exact identity unresolved | None selected; R04 public candidates do not transfer | `YES` | `NOT_RECORDED` | `NOT_RECORDED` | `NOT_RECORDED` | `PENDING` |
| `CM-R05-01 / condensed-milk-coffee` | R05 | Condensed milk in coffee | Exact condensed-milk Product; selected source value 15–20 ml still required | None selected | `YES` | `NOT_RECORDED` | `NOT_RECORDED` | `NOT_RECORDED` | `PENDING` |
| `CM-R05-01 / cream` | R05 | Foam cream | Exact cream Product; source quantity 50 ml | None selected | `YES` | `NOT_RECORDED` | `NOT_RECORDED` | `NOT_RECORDED` | `PENDING` |
| `CM-R05-01 / fresh-milk` | R05 | Foam fresh milk | Exact fresh-milk Product; source quantity 20 ml | None selected; sweetened/full-cream comparators are not equivalent | `YES` | `NOT_RECORDED` | `NOT_RECORDED` | `NOT_RECORDED` | `PENDING` |
| `CM-R05-01 / condensed-milk-foam` | R05 | Foam condensed milk | Exact condensed-milk Product; source quantity 10 ml | None selected | `YES` | `NOT_RECORDED` | `NOT_RECORDED` | `NOT_RECORDED` | `PENDING` |
| `CM-R05-01 / salt` | R05 | Salt within complete R05 foam system | Exact salt Product; source quantity approximately 0.5 g | None selected; R04 1.0 g choice does not transfer | `YES` | `NOT_RECORDED` | `NOT_RECORDED` | `NOT_RECORDED` | `PENDING` |
| `CM-R05-01 / water` | R05 | Brew water | Identified water source; source quantity 80 ml | None selected; R04 water candidate does not transfer automatically | `YES` | `NOT_RECORDED` | `NOT_RECORDED` | `NOT_RECORDED` | `PENDING` |
| `CM-R05-01 / ice` | R05 | Ice | Identified, safely handled ice source; actual mass measured | No candidate established | `YES` | `NOT_RECORDED` | `NOT_RECORDED` | `NOT_RECORDED` | `PENDING` |

Optional unquantified cocoa in the R05 source remains excluded. It is not a required inventory row unless the Owner separately establishes a bounded R05 test variation.

### 7.2 Ingredient/package inspection evidence

Complete one row per actual package/source observed. Repeat the item reference when separate packages are inspected. Never enter a public listing as physical observation.

| Item reference | Exact SKU / observed Product variant | Package size/unit | Label evidence: front/back, ingredients, nutrition, storage | Lot/batch | Expiry/best-before | Actual storage/condition | Evidence reference | Attester | Inspection date | Discrepancy/unknown | Acceptance status |
|---|---|---|---|---|---|---|---|---|---|---|---|
|  |  |  |  |  |  |  |  |  |  |  | `PENDING` |
|  |  |  |  |  |  |  |  |  |  |  | `PENDING` |
|  |  |  |  |  |  |  |  |  |  |  | `PENDING` |
|  |  |  |  |  |  |  |  |  |  |  | `PENDING` |

Evidence should capture the full Product name/variant, visible SKU/barcode where present, package mass/volume, ingredients, relevant nutrition/composition, storage/after-opening instruction, lot and expiry. Clear documentary records may substitute for redundant photographs, but the evidence reference must identify what was actually inspected.

### 7.3 Equipment, vessel and measurement inventory

Record R04 and R05 independently even when the same physical tool is proposed for both. Calibration is never inferred from a display or a public specification.

| Tool reference / role | Trial | Expected requirement / candidate | Actual identity/model | Range/capacity | Resolution/graduation | Physical condition | Available | Suitability/check evidence | Calibration/verification evidence | Attester/date | Discrepancy/status |
|---|---|---|---|---|---|---|---|---|---|---|---|
| `R04M-E01` phin | R04 | Clean complete phin accepting 20 g coffee / 100 ml water basis; provisional Vinbar candidate |  |  |  |  |  |  |  |  | `NOT_CHECKED` |
| `R04M-E07` foam mixer | R04 | Bear B02P5 provisional candidate; actual beaters/settings/condition required |  |  |  |  |  |  |  |  | `NOT_CHECKED` |
| `R04M-E04` general scale/timer | R04 | 5 kg / 0.1 g public candidate; suitable general range and timer; not proven for 1.0 g salt |  |  |  |  |  |  |  |  | `NOT_CHECKED` |
| R04 salt-mass instrument | R04 | Must support defensible 1.0 g measurement under recorded check evidence; no approved precision value/instrument |  |  |  |  |  |  |  |  | `INTERNAL_SPECIFICATION_REVIEW_REQUIRED` |
| `R04M-E08/E09` thermometer | R04 | Range covering 90–96°C; actual range/resolution/tolerance evidence required |  |  |  |  |  |  |  |  | `NOT_CHECKED` |
| `R04M-E10/E11/E12` volume tools | R04 | Tools suitable for 20 ml, 60 ml and 100 ml; actual graduations/check evidence required |  |  |  |  |  |  |  |  | `NOT_CHECKED` |
| `R04M-E14` timer function | R04 | Traceable start/end timing; may be E04 timer only after physical verification |  |  |  |  |  |  |  |  | `NOT_CHECKED` |
| `R04M-E15` serving vessel | R04 | Actual vessel identity and three measured usable-capacity observations |  |  |  |  |  |  |  |  | `NOT_CHECKED` |
| R04 cleaning/sanitization set | R04 | Actual cleanable tools, available instructions and safe preparation condition |  |  |  |  |  |  |  |  | `NOT_CHECKED` |
| R05 phin/brewer | R05 | Clean complete equipment supporting 20 g coffee / 80 ml water basis; no candidate selected |  |  |  |  |  |  |  |  | `NOT_CHECKED` |
| R05 foam tool | R05 | Equipment for the complete R05 cream/milk/condensed-milk/salt foam; settings unapproved |  |  |  |  |  |  |  |  | `NOT_CHECKED` |
| R05 mass tools | R05 | Support 20 g coffee, approximately 0.5 g salt, ice, outputs and waste; exact required precision unresolved |  |  |  |  |  |  |  |  | `INTERNAL_SPECIFICATION_REVIEW_REQUIRED` |
| R05 thermometer | R05 | Range covering 92–96°C; actual range/resolution/tolerance evidence required |  |  |  |  |  |  |  |  | `NOT_CHECKED` |
| R05 volume tools | R05 | Support 10 ml, 15–20 ml, 20 ml, 50 ml and 80 ml measurements; required graduations/tolerance unresolved |  |  |  |  |  |  |  |  | `INTERNAL_SPECIFICATION_REVIEW_REQUIRED` |
| R05 timer | R05 | Traceable extraction/foam/preparation timing; exact tool unselected |  |  |  |  |  |  |  |  | `NOT_CHECKED` |
| R05 serving vessel | R05 | Actual vessel identity and measured usable capacity |  |  |  |  |  |  |  |  | `NOT_CHECKED` |
| R05 cleaning/sanitization set | R05 | Actual cleanable tools, available instructions and safe preparation condition |  |  |  |  |  |  |  |  | `NOT_CHECKED` |

The protocol contains proposed experimental check targets for R04 tools. They are not approved calibration standards. R05 lacks approved measurement-precision/tolerance criteria for its approximately 0.5 g salt and several liquid inputs; this is an internal specification gap and must remain explicit rather than importing R04 targets.

### 7.4 Trial-level pre-authorization gates

| Gate | R04 | R05 |
|---|---|---|
| Source formulation preserved | `YES`; 1.0 g salt is the provisional R04 preparation choice within the complete R04 foam. | `YES`; R05 quantities/ranges remain independent and optional cocoa remains excluded. |
| Every Ingredient physically observed and identity verified | `NO_EVIDENCE` | `NO_EVIDENCE` |
| Package/lot/expiry/storage evidence complete | `NO_EVIDENCE` | `NO_EVIDENCE` |
| Equipment/vessel present, suitable and checked | `NO_EVIDENCE` | `NO_EVIDENCE` |
| Measurement tools support every required field | `NO_EVIDENCE`; salt-measurement suitability unresolved. | `NO_EVIDENCE`; salt/liquid precision criteria unresolved. |
| Water/ice and cleaning prerequisites established | `NO_EVIDENCE` | `NO_EVIDENCE` |
| Discrepancies resolved or explicitly accepted by authorized decision-maker | `NO` | `NO` |
| Evidence references, attester and inspection date complete | `NO` | `NO` |
| Protocol ready | `YES — CAPTURE STRUCTURE ONLY` | `YES — CAPTURE STRUCTURE WITH INPUT/PRECISION GAPS` |
| Current trial state | `PHYSICAL_INVENTORY_INCOMPLETE` | `PHYSICAL_INVENTORY_INCOMPLETE` |
| Separate Owner trial authorization | `NOT_GRANTED` | `NOT_GRANTED` |

Physical readiness is not authorization. Only after every applicable evidence row is complete and reviewed may the Owner separately decide whether to move that trial from `OWNER_AUTHORIZATION_PENDING` to `AUTHORIZED_NOT_STARTED`.

### 7.5 Recipe/BOM and costing trace

| Trial/input | Product / Variant | Recipe/BOM use | Costing destination | Physical evidence contribution | Additional commercial evidence still required |
|---|---|---|---|---|---|
| R04 coffee, condensed milk, cream, salt, water, ice | Cà phê muối / Một cỡ | Candidate R04 Recipe/BOM lines only after an accepted trial and Owner review | Cà phê muối row in [MAKE input](after_four_commercial_v1_make_recipe_bom_input.csv) and [costing input](after_four_commercial_v1_costing_input.csv) | Confirms actual identity/package and permits measured run attribution. | Approved Recipe/BOM, actual purchase/receiving evidence, purchase-to-preparation conversion, yield/loss, allocation and channel packaging. |
| R05 coffee, condensed milk in coffee, cream, fresh milk, condensed milk in foam, salt, water, ice | Cà phê muối / Một cỡ | Separate candidate R05 Recipe/BOM lines only after independent accepted evidence | Same canonical Product/Variant costing row; R04 and R05 evidence must not be merged | Confirms actual R05 identities and measured quantities independently. | Same commercial chain; no public price or candidate identity is purchase cost. |

Physical identification can support Recipe evidence provenance; it cannot establish supplier acceptance, quotation, transaction price, freight, landed cost, channel packaging cost, unit cost or margin. All costing fields remain `MISSING_INPUT` until their own evidence is complete.

### 7.6 Owner inspection sequence

1. Locate the actual Ingredient package/source for one trial at a time.
2. Compare it with the expected identity and provisional candidate without treating the candidate as observed.
3. Record exact Product/SKU, package size, front/back label content, lot, expiry, storage/condition, evidence reference, attester and date.
4. Locate each required equipment item and serving vessel; record identity/model, range/capacity, resolution/graduation, condition and availability.
5. Record check/verification evidence without calling a displayed value calibration.
6. Record water, ice and cleaning/sanitization prerequisites.
7. Record every mismatch or unknown and leave acceptance `PENDING` unless an authorized decision-maker explicitly resolves it.
8. Review the trial-level gate; do not infer completeness from the checklist's existence.
9. Leave authorization, run measurements, result and Recipe/BOM disposition fields untouched.
10. Report missing items without purchasing or contacting a supplier.

Run observations, actual input quantities, outputs, yield, waste, time, sensory notes and disposition must be entered only in the existing run sheets after separate authorization. This worksheet approves no Ingredient, supplier, equipment, Recipe/BOM, cost or margin.

## 8. Costing and procurement intake

### 8.1 Reconciliation against actual CSVs

| Population | Verified rows/products | Current status | Authoritative destination |
|---|---:|---|---|
| Commercial V1 costing | 52 rows / 28 Products | 52 `MISSING_INPUT`; 0 unit costs; 0 margins | [Costing CSV](after_four_commercial_v1_costing_input.csv) |
| MAKE | 48 combinations / 24 Products | Recipe/BOM and cost chains incomplete | [MAKE CSV](after_four_commercial_v1_make_recipe_bom_input.csv) |
| BUY | 4 combinations / 4 Products | No accepted supplier/quotation/transaction chain | [BUY CSV](after_four_commercial_v1_buy_finished_procurement_input.csv) |

Every costing combination requires approved Recipe or accepted finished specification; actual quantities/units; supported conversion; yield/loss; actual purchase/receiving evidence; channel packaging; evidence/effective dates; and reproducible calculation. Keep unit cost and margin blank until the complete applicable chain exists.

### 8.2 Four BUY evidence checklists

Complete one row per Product in the existing BUY CSV. The checklist below defines sufficiency without populating evidence.

| Product | Accepted specification | Verified supplier + exact SKU | Quotation evidence | Actual transaction | Delivery/landed evidence | Receiving/quantity/lot/expiry | Saleable portions + waste/rejection | Status |
|---|---|---|---|---|---|---|---|---|
| Bánh croissant |  |  |  |  |  |  |  | `MISSING_INPUT` |
| Cheesecake |  |  |  |  |  |  |  | `MISSING_INPUT` |
| Brownie chocolate |  |  |  |  |  |  |  | `MISSING_INPUT` |
| Muffin |  |  |  |  |  |  |  | `MISSING_INPUT` |

Quotation must identify provider, Product/SKU, unit/pack, price/currency/tax statement, validity and terms. Actual transaction requires an attributable order/invoice/payment/receiving chain. Public listing seller/provider, price or package remains market evidence only and cannot populate supplier, quotation or transaction fields.

## 9. Nine qualified-input packages

No provider is selected or commissioned. The existing [Qualified Professional Review RFQ](after_four_qualified_professional_review_rfq.md) remains a dormant contingency under the current no-contact direction.

| Gap | Discipline | Prerequisite facts/documents | Exact requested written output | Exclusions and Owner-reserved decision |
|---|---|---|---|---|
| `CORE-OD-03` | Vietnamese Tax/Accounting | §3 seller, registration, site, Product/channel and invoice/Refund/correction flows | Applicability matrix, citations/effective dates, assumptions, alternatives and limitations | No Price publication or policy selection; Owner decides presentation. |
| `CORE-OD-04` | Accounting/commercial calculation | Calculation examples, `CORE-OD-03` interactions, Payment/correction/Refund cases | Comparison of precision/rounding/sequence/residual approaches and consequences | No framework default; Owner selects business policy. |
| `WS-C02-07` | Privacy/Legal/Governance/records | Evidence categories, purposes, flows, actors, access, corrections, disputes and holds | Data-minimization, access, correction, retention/disposal/hold constraints | No evidence class, attester or resolver selected for Owner. |
| `WS-C04-06` | Cash/Accounting/Reporting control | Actual/intended discrepancy classes, investigation and waiting cases | Risk/control analysis of investigation, evidence and consequences around Owner-only disposition | No tolerance, delegate or automatic outcome. |
| `WS-C04-07` | Accounting/Reporting lineage | Complete source inventory, missing/conflicting facts and correction states | Reconciliation sufficiency alternatives and limitations | No report issuance/read/export authority. |
| `WS-C04-08` | Accounting/Reporting control | Report inventory, reconciliation evidence, waiting/exception cases | Issuance-precondition and exception-control analysis | Owner remains issuer; no reader/export/delivery grant. |
| `WS-C04-09` | Identity/Governance/Privacy | Report/data category, Branch, purpose and recipient inventory | Least-privilege reader/delegation constraints | No role assignment; Owner selects reader policy. |
| `WS-C04-10` | Legal/Privacy/Accounting records | Record-category/purpose/legal-basis/start-event/hold inventory | Category-specific retention/disposal/hold analysis | No universal period or disposal authority; Owner selects within constraints. |
| `WS-RPT-01` | Accounting/Reporting | Completed §6 scenarios with event/record/correction times | Category-specific allocation/version alternatives and consequences | No cutoff change or source-time rewrite; Owner decides allocation. |

Public sources constrain these questions but cannot supply missing project facts or the requested professional judgment. An opinion must state reliance limits and may not be represented as an Owner decision or implementation authorization.

## 10. Independent review intake manifests

### 10.1 `CP3-E03` — CORE-02

Required manifest: exact commit/diff baseline; Owner decision/deferral provenance for `WS-C02-01`–`07`; completed qualified/operational evidence; synchronized baseline/domain/data/integrity/ERD/inventory/state/API documents; prior findings; structural/link/reference validation; and explicit unresolved out-of-scope matters.

Review questions: stable attempt/retry identity; Candidate Ticket quarantine; positive evidence/linkage/sufficiency; negative and conflict handling; append-only provenance; access/correction/retention/privacy; Ordering/Payment/Preparation consistency; and absence of inferred physical mechanism or Gate.

### 10.2 `CP3-E04` — CORE-04

Required manifest: exact baseline; provenance for `CORE-OD-12/13/16B/16F`, residual `WS-C04` and `WS-RPT-01`; completed control/operational evidence; preserved `CORE-OD-14A/B`, no tolerance and Owner-only boundaries; synchronized canonical documents; prior findings; and validation evidence.

Review questions: authority/delegation/separation; immutable correction; handover disagreement; discrepancy investigation/disposition; reconciliation truth; report issuance/read/export/delivery; cross-midnight allocation; records governance; and absence of inferred capability or implementation.

For both reviews, the reviewer must be independent of authoring/remediation, disclose organizational/financial/referral/self-review conflicts, cite exact evidence, classify each prior/current finding `RESOLVED`, `PARTIALLY_RESOLVED`, or `OPEN`, assign severity to new findings, and issue exactly one bounded readiness verdict. Internal adversarial review is insufficient. No review grants Gate A.

## 11. Canonical final execution register

The detailed one-to-one execution axes for all 32 gaps are maintained in the [governing gap report §4.2](../research/after_four_milestone_a_comprehensive_evidence_and_decision_gap_report.md#42-final-execution-axes-for-every-atomic-gap). This workbook is the operational intake view. It removes two obsolete actions: the 14 CORE-02, 21 CORE-04 and ten cross-midnight hypothetical scenarios are complete, so no further generic scenario writing is pending; and the Owner has confirmed that AFTER FOUR has no Ingredients or equipment and has purchased nothing, so no physical inventory inspection is currently possible or required merely to obtain a Milestone status.

| Category | Exact action | Responsible party | Prerequisite | Required authorization | Evidence artifact | Acceptance condition | Dependencies | Owner timing |
|---|---|---|---|---|---|---|---|---|
| A. Codex-executable now | None. Preserve current synchronization; re-run it only after an applicable accepted decision/evidence trigger. | Documentation maintainer after trigger. | Dated authoritative trigger and task scope. | Explicit documentation scope; no policy inference. | Reviewed canonical diff and static-validation record. | Zero contradictions for the triggered confirmed baseline. | Post-decision synchronization gap. | No Owner action now. |
| B. Owner decisions genuinely ready now | None. Do not present a positive ballot before its prerequisite fact/qualified-input pack is complete. | Owner only after prerequisite review. | The exact inputs in §4–§9 and the governing gap register. | Decision-session scope; no implementation authority follows. | Dated answer tied to stable reference, conditions and provenance. | Each decision is accepted only when every prerequisite is attributable and the Owner explicitly selects or defers every independent dimension without granting implementation authority. | Eleven Owner-decision gaps plus decisions dependent on the nine qualified-input gaps. | No decision requested now. `DEFER` remains possible later but does not close the criterion. |
| C. Owner/Operations facts required, excluding deferred topics | When operational planning actually exists, supply evidence-source availability, staffing/responsibility feasibility, Cash error/disagreement/source/report inventories and BUY finished-product acceptance specifications. Do not repeat premises/entity/registration/tax requests. | Owner and future Operations/Cash/Accounting/Reporting records owners. | A real intended staffing/workflow/specification context. | None to describe facts; any disclosure to an external reviewer requires separate authority. | Dated fact inventory with source, limits and `UNKNOWN` values retained. | Accepted only when fact, plan, assumption and unknown are separated; source, date, scope and limitations are explicit; and no desired process is represented as an event. | `WS-C02-01`–`06`, `WS-C04-01`–`10`, four BUY chains. | Only when operational/commercial planning resumes; not needed now. |
| D. Qualified professional input | Complete and hand off the nine bounded packages only after their listed fact packs exist. | Qualified professionals selected later by Owner. | Package-specific facts, conflicts, assumptions and current official sources. | Explicit provider selection, disclosure, commercial engagement and work authorization. | Dated written opinion with citations, assumptions, limitations, alternatives, conflicts and acceptance review. | Accepted only when provider competence, independence/conflicts, scope, assumptions, source currency, alternatives, limitations and residual Owner questions satisfy the package-specific criteria. | `CORE-OD-03/04`, `WS-C02-07`, `WS-C04-06`–`10`, `WS-RPT-01`. | Later; current no-contact/no-commissioning direction controls. |
| E. Actual operational evidence | Capture `EA1-D01-*` and `EA1-D03-*` events without simulation or retrospective invention. | Authorized future operators and records owners. | Lawful operation plus applicable policy, capability and evidence capture. | Operational and data-processing authority applicable at that time. | Attributable raw events, provenance, times, authority basis, outcomes, conflicts and corrections. | Evidence is accepted only when source-dated, scope-matched and non-destructive. | A-01/A-02 effectiveness and `CP3-E03/E04`. | During real operation only; impossible now. |
| F. Physical evidence/trials | Acquire/identify actual inputs and equipment only under later scope; inspect readiness; then separately authorize and execute R04 and R05. Keep tracks independent. | Owner, authorized acquirer, operator/tester and evidence custodian. | Materials/equipment/vessels/ice/water exist; measurement capability is attributable. | Separate contact/acquisition authority, then separate R04 and R05 trial authorization. | Physical inspection records and raw run sheets; blank until real action. | Accepted when identity, measurement basis, deviations and disposition are complete without invented tolerance/result. | `CM-R04-01`, `CM-R05-01`, Recipe/BOM review and A-05. | Only when the Owner chooses to prepare physical trials; no purchase is required now. |
| G. Commercial/procurement evidence | Complete 48 MAKE chains, four BUY chains and channel packaging from actual approved specifications, transactions, receiving and measurements. | Owner, authorized procurement/receiver, Recipe reviewer, tester and costing reviewer. | Approved Recipe/BOM or BUY specification; bounded supplier/material scope. | Supplier contact/disclosure, quotation acceptance and purchase each require separate authority. | Recipe/BOM versions, quotations distinguished from transactions, invoices/receiving, conversions, yield/loss, packaging fit and reproducible calculation. | Combination closes only when every required input is supported; unit cost/margin remain blank otherwise. | A-05 and any later commercial review. | Later commercial execution; no action now. |
| H. Independent reviews | Hand off exact synchronized baselines to `CP3-E03` and `CP3-E04`; resolve every material finding. | Genuine independent reviewers selected by Owner. | All applicable upstream decisions/evidence/qualified input and canonical synchronization complete. | Explicit review scope, reviewer selection and authorization. | Conflict disclosure, evidence index, finding register, severity, disposition and one bounded verdict. | No material blocker remains; review indicates readiness only and grants no Gate. | A-01/A-02/A-06. | Last formal Milestone step; manifests are ready but not handoff-ready. |

### 11.1 Lifecycle boundary

| Stage | Required evidence | Current implication |
|---|---|---|
| Before any positive CORE-02/CORE-04 implementation | Applicable Owner policy, qualified constraints, synchronized logical design and independent review readiness. | Still blocked. Documentation completeness alone does not authorize implementation. |
| Before first operation | Lawful registration/site/tax/food-safety applicability, configured actors/capabilities, trained operations, physical/commercial readiness and applicable reviews. | Deferred project facts and real evidence remain absent; no launch claim is possible. |
| During actual operation | `EA1-D01-*` and `EA1-D03-*` attributable events plus control-effectiveness evidence. | These formal Milestone inputs cannot exist pre-operation and must not be simulated. |
| Formal Milestone A acceptance | All six criteria, including real evidence and `CP3-E03/E04`, satisfy their existing closure conditions. | The formal definition is post-evidence and partly post-operation. A truthful pre-operation design-readiness checkpoint may be considered separately by the Owner, but this workbook does not change Milestone A. |
| Deferrable without false approval | Deferred premises/entity facts until voluntarily resumed; physical/commercial lanes until preparation begins; positive policy remains fail-closed when deferred. | Deferral preserves boundaries but does not convert the affected formal criterion to PASS. |

### 11.2 Exact remaining Owner actions

There is **no Owner action required immediately** merely to complete another documentation pass. Excluding the explicitly deferred entity/premises/registration/tax topics, the next Owner actions arise only when the corresponding lane is intentionally resumed:

1. approve the scope and disclosure for any qualified professional engagement after its fact pack is ready;
2. define four BUY finished-product acceptance specifications before any supplier contact, then separately authorize any contact/acquisition;
3. authorize material/equipment acquisition only if physical testing is intentionally prepared, followed by separate R04 and R05 trial decisions after readiness;
4. decide CORE-02/CORE-04/Reporting questions only after their prerequisite facts and qualified constraints exist; and
5. authorize/select `CP3-E03/E04` independent reviewers only after upstream closure and synchronization.

## 12. Completion control

Every intake item closes only when its authoritative destination contains accepted evidence, provenance and scope, dependencies are satisfied, and the governing gap register is updated without changing the 32-gap identity/count. A template, hypothetical scenario, public source, manifest or blank capture field is not the missing real evidence.

The shortest remaining path is execution-triggered, not documentation-triggered: later fact readiness → separately authorized qualified/physical/commercial evidence lanes → evidence-dependent Owner decisions → canonical synchronization → `CP3-E03/E04` → six-criterion reassessment. Actual operational events are captured only when lawful operation exists.

`NO_FURTHER_CODEX_ONLY_SPRINT_REQUIRED`

**Current Milestone A verdict: `MILESTONE_A_NOT_COMPLETE_BUT_ALL_INTERNAL_WORK_CLOSED`.**

**Separate design-readiness boundary:** CORE-02 and CORE-04 remain `NOT_DESIGN_READY`; this workbook grants no Gate or implementation authority.

## 13. Research-supported proposed operating procedures

The local `AF-SOP-*` identifiers below are procedure-design references, not canonical decisions, ODB IDs, runtime permissions or evidence that an operation occurred. Every positive actor assignment is conditional on later Owner policy and capability authorization. Vietnamese law and qualified review remain governing; `EV-BP-*` sources are supplemental benchmarks. A checklist records evidence but never proves effectiveness by itself.

### 13.1 `AF-SOP-OPS-01` — Branch opening, shift routine, interruption and closing

1. **SOP ID:** `AF-SOP-OPS-01`.
2. **Purpose:** Establish a repeatable, fail-closed daily operating envelope for a small dine-in/takeaway café.
3. **Scope:** Premises readiness, attendance, station handover, service readiness, equipment/POS/power/network interruption and physical close; excludes Cash actions governed by `AF-SOP-C04-01`.
4. **Trigger:** Planned opening, actor/shift change, material interruption, or planned closing.
5. **Actors and responsibilities:** Owner-defined opening/closing actor; station custodian; food handler; incident recorder. No role is assigned by this design.
6. **Required authority:** Applicable future operation/capability assignment; no title, Shift or Branch Assignment is authority by itself.
7. **Preconditions:** Lawful Branch operation; trained actors; approved food-safety controls; safe premises; required utilities/equipment; explicit Cash procedure if Cash opens.
8. **Required inputs:** Opening/closing checklist version; prior unresolved log; equipment/utility status; cleaning records; Product availability/hold list; staff/authority record.
9. **Step-by-step procedure:** (a) identify actor, Branch, Operating Day and checklist version; (b) inspect access, hazards, utilities, water/ice, pests and cleaning status; (c) verify equipment condition without inventing calibration; (d) review held/nonconforming Products and unresolved incidents; (e) confirm station custody and permitted Products/channels; (f) during service record failures, complaints and holds; (g) at closing stop new work, complete source records, isolate unresolved items, clean/secure, perform separate Cash close if authorized and hand over/hold custody explicitly.
10. **Decision points:** Unsafe premises, unavailable water/ice, failed equipment, missing custodian, incomplete sanitation, unresolved food hold or unavailable system causes affected work to remain closed/held; no improvised bypass.
11. **Expected outputs:** Dated opening/closing disposition per area, available/unavailable Products/stations, custody state and unresolved-action list.
12. **Evidence and records:** Checklist revision, actor/authority basis, event and recorded times, observations, equipment identifiers, deviations, photographs/documents where legitimately available and linked incident/correction records.
13. **Exceptions and failure handling:** Power/network/POS failure preserves Orders/Payments and evidence already known; manual workaround requires separately approved procedure; unsafe equipment/food is isolated.
14. **Escalation path:** Safety issue, missing custodian or unresolved control escalates to Owner; emergency services/authority contact is outside this design and must follow applicable law and later policy.
15. **Reconciliation and audit requirements:** Opening state reconciles to prior close/hold; closing explains every unresolved station, Order, custody item and exception without destructive edit.
16. **Relevant risks and controls:** Missed hazard, unauthorized opening, stale checklist, silent workaround; controls are named actor, versioned checklist, fail-closed holds and later review.
17. **Related policies and canonical artifacts:** Owner Decision Baseline; worksheet `WS-OPS-01`; `AF-SOP-C02-01`, `AF-SOP-FS-01/02`, `AF-SOP-C04-01`.
18. **Dependencies:** Actual premises/equipment facts, Vietnamese food-safety applicability, Owner capability decisions and training evidence.
19. **Acceptance criteria:** Every station has explicit open/closed/held status, named evidence source and unresolved item; no checklist completion grants authority or proves effectiveness.
20. **Source references:** `EV-BP-001`–`005`, `009`, `011`, `013`.
21. **Classification:** `RESEARCH_SUPPORTED_DESIGN`; `PROPOSED_OWNER_APPROVAL_REQUIRED`; food-safety portions `QUALIFIED_REVIEW_REQUIRED`; actual execution `ACTUAL_OPERATIONAL_EVIDENCE_REQUIRED`.

### 13.2 `AF-SOP-C02-01` — Goods custody and Employee Shift Handover

1. **SOP ID:** `AF-SOP-C02-01`.
2. **Purpose:** Preserve accountable custody of accepted goods and operational items without conflating Employee Shift Handover, customer custody transfer or Cash Session Handover.
3. **Scope:** Receiving custody, station/shift custody, interim custodian, absent incoming actor, controlled hold, discrepancy, loss/damage, conflicting/missing/duplicate records, correction and reconstruction.
4. **Trigger:** Accepted receiving event, planned Employee Shift Handover, actor absence, custody discrepancy, incident or later correction.
5. **Actors and responsibilities:** Authorized receiver; outgoing and incoming employees; Owner-assigned interim custodian; evidence recorder. Customer/Cash actors remain separate.
6. **Required authority:** Confirmed dual employee confirmation and Owner interim assignment policy; exact capabilities/evidence remain unresolved and are not granted here.
7. **Preconditions:** Identified custody envelope/items; prior custodian; applicable receiving acceptance; attributable actors; critical/high-shrinkage scope when later defined.
8. **Required inputs:** Item/specification/quantity/condition/lot-expiry evidence where applicable; prior custody record; discrepancy/hold evidence; actor/authority references.
9. **Step-by-step procedure:** (a) identify custody scope and prior record; (b) outgoing actor counts/inspects applicable items and records variance/damage; (c) incoming actor independently checks and confirms or disagrees; (d) transfer custody only after both confirmations; (e) if incoming actor absent, keep handover pending and current recorded custody explicit; (f) Owner may assign named interim custodian; otherwise place custody-changing operations on controlled hold; (g) isolate lost/damaged/disputed items; (h) append later evidence/correction to the same history.
10. **Decision points:** Match/dual confirmation; disagreement; absence; missing evidence; duplicate/replay; conflict; unauthorized action; damage/loss.
11. **Expected outputs:** Confirmed handover, pending handover, interim assignment, controlled hold or incident record—never silent transfer.
12. **Evidence and records:** Actors, scope, counts/checks, condition, variance/reason, confirmations/refusal, event/recorded times, provenance, revisions, authority and linked incident/correction.
13. **Exceptions and failure handling:** Duplicate returns known state; late evidence appends; conflict remains held; missing record cannot be reconstructed as fact; unauthorized attempt is denied and logged.
14. **Escalation path:** Pending/failed employee handover escalates to Owner under confirmed policy; exact dispute consequences remain proposed and do not borrow Cash/customer rules.
15. **Reconciliation and audit requirements:** Reconstruct continuous custody from receiving through each handover/hold/incident; original evidence is immutable and corrections are linked.
16. **Relevant risks and controls:** Silent transfer, theft/loss, collusion, false count, missing evidence; controls are dual confirmation, named custody, targeted checks, hold and Owner assignment/review.
17. **Related policies and canonical artifacts:** `WS-OPS-01`; worksheet `SCN-C02-03`–`06`; Inventory discovery; Owner Decision Baseline.
18. **Dependencies:** Critical/high-shrinkage item definition, detailed evidence/capability policy, staffing feasibility, Labor/Operations and Inventory input.
19. **Acceptance criteria:** Custody is always attributable or explicitly held; customer custody and Cash handover states are never used as substitutes.
20. **Source references:** `EV-BP-005`–`009`, `011`, `013`.
21. **Classification:** `RESEARCH_SUPPORTED_DESIGN`; `PROPOSED_OWNER_APPROVAL_REQUIRED`; actual effectiveness `ACTUAL_OPERATIONAL_EVIDENCE_REQUIRED`.

### 13.3 `AF-SOP-ORD-01` — Order, service error and customer complaint

1. **SOP ID:** `AF-SOP-ORD-01`.
2. **Purpose:** Produce attributable dine-in/takeaway Orders and bounded customer recovery without silently changing Payment, Refund, Preparation or custody facts.
3. **Scope:** Product selection, quoted scope, Order confirmation, channel, Preparation dispatch, handover readiness, errors, complaints, cancellation request and service interruption.
4. **Trigger:** Customer request or later report of wrong, missing, damaged, delayed or unsuitable Product.
5. **Actors and responsibilities:** Authorized order taker; Preparation actor; customer-service recorder; Owner for decisions reserved to Owner. No capability is assigned here.
6. **Required authority:** Ordering/Preparation actions require later authorized capabilities; Refund remains Owner-only approval and separate execution.
7. **Preconditions:** Current approved menu/Price scope; Product availability; channel; allergen information if applicable; functioning evidence path or approved interruption procedure.
8. **Required inputs:** Customer selection; Product/Variant/options; channel; quoted amount/version; allergen declaration where volunteered; Order/Payment/Preparation state and complaint evidence.
9. **Step-by-step procedure:** (a) repeat Product/Variant/channel and current amount; (b) disclose unavailable/held Products and relevant allergen-information limitation; (c) confirm Order against explicit version; (d) route through separately governed Payment and Preparation; (e) preserve lifecycle facts; (f) on error/complaint record requested remedy, evidence and customer communication; (g) hold affected transition; (h) route remake, cancellation or Refund through its own authority and record outcome separately.
10. **Decision points:** Pre-confirmation correction; post-confirmation change; paid-undispatched; dispatched/not-started; in progress; complete/not handed over; handed over; missing/conflicting evidence.
11. **Expected outputs:** Attributable Order state plus separate issue/request/remedy records; no implicit Refund or custody outcome.
12. **Evidence and records:** Order/Price version, channel, actor/time, requested change, customer communication, Preparation/Payment evidence, complaint category, photographs only when legitimately supplied and linked resolution.
13. **Exceptions and failure handling:** System/transport uncertainty keeps state unknown/held; lookup uses same stable identity; customer assertion is evidence, not automatic lifecycle mutation.
14. **Escalation path:** Food-safety complaint immediately isolates implicated Product/lot and escalates to Owner; financial remedy follows `AF-SOP-REF-01`.
15. **Reconciliation and audit requirements:** Order, Payment, Preparation, custody, cancellation and Refund remain separately reconstructable; late correction produces new linked version.
16. **Relevant risks and controls:** Wrong item/price/channel, duplicate Order, unauthorized remedy, allergen misinformation; controls are read-back, version binding, state separation and evidence-first escalation.
17. **Related policies and canonical artifacts:** Ordering/Payment/Preparation state machines; `CORE-OD-03/04`; custody worksheet; `AF-SOP-FS-02`, `AF-SOP-REF-01`.
18. **Dependencies:** Tax/rounding policy, cancellation/remedy authority, customer custody evidence decisions, actual allergen/Recipe data.
19. **Acceptance criteria:** Every confirmed Order and exception is attributable; no error path silently closes, refunds, transfers custody or overwrites history.
20. **Source references:** `EV-BP-009`, `011`–`014`, plus current Ordering/Payment canonical sources.
21. **Classification:** `RESEARCH_SUPPORTED_DESIGN`; `PROPOSED_OWNER_APPROVAL_REQUIRED`; custody/qualified portions retain existing gap classifications.

### 13.4 `AF-SOP-C04-01` — Cash Session lifecycle, deposit and reconciliation

1. **SOP ID:** `AF-SOP-C04-01`.
2. **Purpose:** Safeguard cash from Open through receipt, count, handover, Close, deposit and bank reconciliation while preserving Owner-only discrepancy disposition.
3. **Scope:** Opening float, receipts, restricted access/storage, count, handover, close, discrepancy, investigation, Owner disposition, deposit evidence and bank reconciliation design.
4. **Trigger:** Authorized Cash Open, cash receipt, count/handover/close, discrepancy, deposit or bank evidence arrival.
5. **Actors and responsibilities:** Future authorized operator/custodian/counter/depositor/reconciler; Owner dispositions discrepancies. Exact holders and combinations remain unresolved.
6. **Required authority:** `CORE-OD-12`/`13` decisions and later capabilities; this SOP grants none. Owner-only disposition and no-tolerance/notification rules remain fixed.
7. **Preconditions:** Branch/Operating Day, explicit Cash Session, approved opening evidence, secure storage, receipt evidence and separately authorized actor.
8. **Required inputs:** Opening float evidence; sequential transaction receipts; movements; expected/observed counts; variance/reason; handover evidence; close request; deposit/bank statements.
9. **Step-by-step procedure:** (a) authorized actor independently counts proposed float and records source; (b) open Session only after guard; (c) issue/retain receipt for each cash sale and place cash only in restricted storage; (d) record every movement separately; (e) count without altering expected amount; (f) every nonzero discrepancy gets reason and Owner notification; (g) handover records outgoing/incoming/count/variance/reason/acknowledgement or disagreement; (h) Close is separate and immutable; (i) prepare deposit from closed evidence; (j) later reconcile deposit and bank evidence independently where staffing permits.
10. **Decision points:** Float mismatch, unauthorized access, missing receipt, nonzero variance, disagreement, missing deposit, bank mismatch or unknown result.
11. **Expected outputs:** Session/movement/count/handover/close/deposit/reconciliation facts with explicit unresolved cases.
12. **Evidence and records:** Actors/authority, Branch/Day, amounts, denominations if later required, receipt IDs, event/recorded times, reasons, Owner notifications/dispositions, deposit proof, bank match and linked corrections.
13. **Exceptions and failure handling:** No tolerance; no balancing entry; unknown system response is looked up; closed evidence never reopens; correction operation requires `CORE-OD-13`.
14. **Escalation path:** Every nonzero variance and handover disagreement to Owner; suspected loss/fraud is preserved as an incident without accusation or automatic disposition.
15. **Reconciliation and audit requirements:** Compare source receipts/movements/count/close to deposit and bank evidence; unresolved facts hold authoritative reporting.
16. **Relevant risks and controls:** Skimming, cash theft, false count, collusion, missing deposit, duplicate receipt; controls include named custody, restricted access, receipt completeness, independent/compensating review, immutable exception log and trend review.
17. **Related policies and canonical artifacts:** `ODB-CASH-12`–`15`, `CORE-OD-12`–`15`, `WS-C04-01`–`08`, worksheet scenarios.
18. **Dependencies:** Capability/separation/delegation, correction catalogue, deposit/bank facts, qualified Cash/Accounting/Reporting analysis.
19. **Acceptance criteria:** No action occurs without established authority; every source-to-bank difference remains visible; discrepancy disposition never implies correction, reconciliation or report release.
20. **Source references:** `EV-BP-005`–`007`, `009`, `011`; official accounting sources already in register.
21. **Classification:** `RESEARCH_SUPPORTED_DESIGN`; `PROPOSED_OWNER_APPROVAL_REQUIRED`; `QUALIFIED_REVIEW_REQUIRED`; future effectiveness `ACTUAL_OPERATIONAL_EVIDENCE_REQUIRED`.

### 13.5 `AF-SOP-EXP-01` — Operating Expense request through reconciliation

1. **SOP ID:** `AF-SOP-EXP-01`.
2. **Purpose:** Ensure every Operating Expense is requested, evidenced and Owner-approved before incurrence/execution.
3. **Scope:** Request, evidence, approval/rejection, purchase execution, receiving, recording, correction and unauthorized-expense incident.
4. **Trigger:** Identified operating need or discovery of an unapproved/incorrect expense.
5. **Actors and responsibilities:** Employee may record/submit; Owner approves/rejects; future authorized purchaser/receiver/recorder; exact execution/separation remains open.
6. **Required authority:** Owner prior approval is mandatory; thresholds are control flags, not exemptions; no emergency exception.
7. **Preconditions:** Business purpose, Product/service specification, proposed amount/vendor evidence, threshold results and requested execution scope.
8. **Required inputs:** Request ID/version, purpose, amount/currency, recipient/vendor, quotation or evidence type, proposed purchaser, receiving requirement and Operating Day.
9. **Step-by-step procedure:** (a) employee records request/evidence; (b) system/manual control flags thresholds without approving; (c) Owner approves exact version/scope or rejects; (d) only after approval may separately authorized actor execute; (e) receiver verifies actual goods/service; (f) recorder links transaction/receipt and variance to request/approval; (g) unresolved mismatch remains held; (h) correction is linked, never rewrite.
10. **Decision points:** Missing evidence, amount/spec change, rejection, approval expiry/condition, receiving mismatch, unauthorized execution or duplicate transaction.
11. **Expected outputs:** Pending, approved, rejected, executed, received, reconciled or incident states as distinct evidence.
12. **Evidence and records:** Request/approval versions, quotation vs transaction, invoice/receipt, purchaser/receiver, goods/service evidence, amount/time, threshold results and linked corrections.
13. **Exceptions and failure handling:** Emergency does not create authority; unapproved expense is recorded as incident and not relabelled approved; materially changed request requires new/linked approval.
14. **Escalation path:** Missing approval, out-of-scope execution or receiving mismatch escalates to Owner; Accounting consequence remains qualified/open.
15. **Reconciliation and audit requirements:** Three-way match where applicable: approved request/order, receiving evidence and actual invoice/transaction; exceptions remain explicit.
16. **Relevant risks and controls:** Fictitious vendor, split request, approval bypass, duplicate invoice, self-approval; controls are version-specific Owner approval, source matching, anomaly review and separation/compensating review.
17. **Related policies and canonical artifacts:** `ODB-EXP-01`–`04`, `EXP-OWNER-DECISION-01`–`03`, worksheet Expense scenarios.
18. **Dependencies:** Execution actor/control design, actual procurement/receiving facts and qualified Accounting/Governance review.
19. **Acceptance criteria:** Every executed expense cites prior Owner approval for the same scope and actual receiving/transaction evidence; exceptions are not normalized away.
20. **Source references:** `EV-BP-005/006/008`; current Expense decisions.
21. **Classification:** `RESEARCH_SUPPORTED_DESIGN`; confirmed approval boundaries preserved; remaining execution/control details `PROPOSED_OWNER_APPROVAL_REQUIRED` and `QUALIFIED_REVIEW_REQUIRED`.

### 13.6 `AF-SOP-REF-01` — Refund request, approval, execution and reconciliation

1. **SOP ID:** `AF-SOP-REF-01`.
2. **Purpose:** Handle customer Refund requests responsively while preserving Owner-only approval and separation from execution.
3. **Scope:** Receipt, eligibility evidence, communication, Owner approval/rejection, execution attempt/result, reconciliation, exception and audit handling.
4. **Trigger:** Customer Refund request or discovery that an approved Refund result is missing/conflicting.
5. **Actors and responsibilities:** Request receiver/recorder; future reviewer/executor; Owner approves/rejects. Eligibility and execution authority remain unresolved.
6. **Required authority:** Only Owner approves; approval does not execute; no urgent or Owner-unavailable delegate exists.
7. **Preconditions:** Original Order/Payment evidence, request reason, proposed obligation/amount/method, customer communication channel and no conflicting prior execution.
8. **Required inputs:** Request ID/version, Order/Payment, amount/allocation basis, reason/evidence, requested method, customer communication and prior attempts/results.
9. **Step-by-step procedure:** (a) record and acknowledge request; (b) preserve eligibility/amount evidence without deciding unsupported policy; (c) if Owner unavailable, keep pending/unexecuted, escalate and communicate pending status; (d) Owner approves exact request/conditions or rejects; (e) separately authorized executor submits one stable execution attempt; (f) lookup unknown result before retry; (g) record result and reconcile to source Payment/financial evidence; (h) preserve corrections as linked facts.
10. **Decision points:** Ineligible/uncertain, partial amount, method mismatch, Owner unavailable, rejection, execution failure/unknown, duplicate or conflicting provider result.
11. **Expected outputs:** Pending, approved/rejected, execution success/failure/unknown and reconciled/unreconciled records remain distinct.
12. **Evidence and records:** Customer request/communication, eligibility/amount basis, Owner decision/time, executor authority, attempt/result identity, provider evidence if any and reconciliation.
13. **Exceptions and failure handling:** Timeout is not success/failure; no new attempt before authoritative lookup/resolution; no Payment rewrite; no customer acknowledgement as approval.
14. **Escalation path:** All approvals to Owner; conflicting/unknown execution and customer dispute remain held for separately governed resolution.
15. **Reconciliation and audit requirements:** One-to-one trace from source Payment through request, approval, attempt/result and financial reconciliation; duplicates and late results remain visible.
16. **Relevant risks and controls:** Duplicate Refund, false eligibility, unauthorized approval/execution, lost response; controls are Owner approval, stable identity, version binding, lookup-before-retry and independent/compensating review.
17. **Related policies and canonical artifacts:** `WS-REFUND-01`, Payment/Refund design, worksheet `SCN-C04-13`–`16`.
18. **Dependencies:** Eligibility/method/allocation/executor policy, qualified Accounting/control input and actual provider/payment evidence.
19. **Acceptance criteria:** No Refund execution lacks exact Owner approval and authority; unknown/conflicting outcomes remain unresolved; reconciliation never rewrites original Payment.
20. **Source references:** `EV-BP-005/006/014`; current Owner decisions.
21. **Classification:** `RESEARCH_SUPPORTED_DESIGN`; confirmed Owner-only approval retained; residual policy `PROPOSED_OWNER_APPROVAL_REQUIRED` and `QUALIFIED_REVIEW_REQUIRED`.

### 13.7 `AF-SOP-RPT-01` — Daily reconciliation and official reporting

1. **SOP ID:** `AF-SOP-RPT-01`.
2. **Purpose:** Produce traceable daily operational information without treating incomplete totals as authoritative reports.
3. **Scope:** Sales, cash/bank, Expense, Refund, discrepancy, close, cross-midnight allocation, report version, issuance, access/export/delivery and correction.
4. **Trigger:** Operating Day cutoff, source evidence update, late/conflicting fact, correction or report request.
5. **Actors and responsibilities:** Future preparer/reconciler/reviewer; Owner alone issues official reports; readers/exporters/recipients remain unassigned.
6. **Required authority:** Preparation/reconciliation capability unresolved; issuance Owner-only; issuance grants no read/export/delivery authority.
7. **Preconditions:** Defined report purpose/scope; source inventory; cutoff `00:00 Asia/Ho_Chi_Minh`; source event and recorded times; discrepancy/correction states.
8. **Required inputs:** Order/Payment/Refund, Cash Session/movement/count/close, Expense, custody/Preparation where relevant, bank/deposit, corrections and unresolved holds.
9. **Step-by-step procedure:** (a) freeze a source-version set without rewriting it; (b) allocate each fact under future category rule while retaining event/recorded/correction times; (c) reconcile completeness and conflicts; (d) hold unresolved scope; (e) prepare draft with exceptions; (f) Owner issues exact version only after future preconditions; (g) separately authorize read/export/delivery; (h) late correction creates new linked version.
10. **Decision points:** Missing source, nonzero discrepancy, unreconciled bank/deposit, cross-midnight ambiguity, late/conflicting evidence, exception release or access request.
11. **Expected outputs:** Draft/held/issued/superseded report versions and explicit source/reconciliation status.
12. **Evidence and records:** Report ID/version/scope, source manifest, allocation basis, preparer/reviewer, exceptions, Owner issue decision, access/export/delivery events and supersession links.
13. **Exceptions and failure handling:** Balanced arithmetic alone is insufficient; issue time cannot reassign source events; unresolved fact remains held; no silent report edit.
14. **Escalation path:** Missing/conflicting source to relevant fact owner; issuance decision to Owner; legal/privacy/access exception to qualified/Owner route.
15. **Reconciliation and audit requirements:** Reproduce each report value from immutable source versions; preserve prior issued report and linked correction/supersession.
16. **Relevant risks and controls:** Omitted sales, false balance, period shifting, unauthorized access/export; controls are source manifest, dual-time model, default hold, Owner issuance and separate access authority.
17. **Related policies and canonical artifacts:** `CORE-OD-11B`, `15B`, `16B/F`; `WS-C04-07`–`10`; `WS-RPT-01`.
18. **Dependencies:** Qualified Accounting/Reporting allocation/sufficiency input, reader/retention policy, actual operational records and E04.
19. **Acceptance criteria:** Every figure traces to source/version; unresolved evidence is disclosed/held; issue/access/export/delivery remain separate attributable decisions.
20. **Source references:** `EV-BP-005`–`007`, `009`, plus current accounting sources.
21. **Classification:** `RESEARCH_SUPPORTED_DESIGN`; `PROPOSED_OWNER_APPROVAL_REQUIRED`; `QUALIFIED_REVIEW_REQUIRED`; actual effectiveness `ACTUAL_OPERATIONAL_EVIDENCE_REQUIRED`.

### 13.8 `AF-SOP-INV-01` — Procurement, receiving and inventory control

1. **SOP ID:** `AF-SOP-INV-01`.
2. **Purpose:** Control goods from request through receiving, storage, movement, count, waste and supplier review without assuming Inventory implementation.
3. **Scope:** Purchase request/authorization, supplier/Specification evidence, receiving, rejection/return, storage, FIFO/FEFO where Product-appropriate, movement, counts, variance, spoilage/waste and supplier performance.
4. **Trigger:** Replenishment need, authorized delivery, stock movement/count, nonconformance, expiry/spoilage or supplier review.
5. **Actors and responsibilities:** Requester, Owner approver, authorized purchaser, receiver/custodian, recorder/reviewer; exact combinations remain proposed.
6. **Required authority:** Prior Owner Expense/procurement approval; contact/purchase authorization separately bounded; Inventory capability not granted.
7. **Preconditions:** Approved item specification, quantity/unit, supplier evidence, acceptance/rejection criteria, storage capability and authorized request.
8. **Required inputs:** Request/order/approval; supplier/SKU; package/purchase unit; delivery document; lot/expiry where applicable; quantity/condition/temperature evidence; storage and traceability requirements.
9. **Step-by-step procedure:** (a) raise versioned request; (b) obtain Owner approval before commitment; (c) execute only within scope; (d) receiver matches request/order/delivery; (e) inspect identity, quantity, condition, packaging, lot/expiry and applicable temperature; (f) accept into named custody or isolate/reject; (g) label/store under approved Product rule; (h) record movements; (i) perform proposed targeted critical/high-shrinkage counts and broader counts only after Owner policy; (j) record waste/spoilage/reason; (k) reconcile and review supplier exceptions.
10. **Decision points:** Unauthorized delivery, mismatch, damage, unsafe temperature, missing trace, expired/short-dated item, storage failure, variance or repeated supplier defect.
11. **Expected outputs:** Accepted custody, quarantined/rejected/returned goods, movements, counts, discrepancy/waste evidence and supplier exception history.
12. **Evidence and records:** Request/approval/order, delivery/receiving, actor/time, lot/expiry, quantity/unit/conversion, condition/temperature, photos/documents, rejection/return, storage location, movement/count/waste and correction.
13. **Exceptions and failure handling:** Do not accept by convenience; isolate uncertain items; duplicate delivery/record does not increase stock; late evidence links to same receipt; power/storage failure creates affected-item hold.
14. **Escalation path:** Safety/nonconformance to Owner and food-safety route; financial mismatch to Expense/procurement reconciliation; suspected loss remains evidence-based investigation.
15. **Reconciliation and audit requirements:** Three-way match and custody trace; expected versus observed stock variance remains explicit; periodic trend review after actual operation.
16. **Relevant risks and controls:** Over-order, substitution, short delivery, theft, expiry, fictitious supplier, self-receiving; controls are specification, prior approval, source matching, named custody, targeted counts and compensating Owner review.
17. **Related policies and canonical artifacts:** Expense decisions; Inventory discovery; Commercial MAKE/BUY CSVs; `AF-SOP-C02-01`, `FS-02` and `EXP-01`.
18. **Dependencies:** Inventory Owner policies, actual item classes/storage/premises, qualified food-safety input, supplier/contact authority and physical evidence.
19. **Acceptance criteria:** Every accepted item has authorized source and receiving evidence; rejected/held goods cannot be used; FIFO/FEFO is applied only where item evidence supports it.
20. **Source references:** `EV-BP-001`–`004`, `006`, `008/009/011/013`.
21. **Classification:** `RESEARCH_SUPPORTED_DESIGN`; `PROPOSED_OWNER_APPROVAL_REQUIRED`; food-safety aspects `QUALIFIED_REVIEW_REQUIRED`; receiving/count effectiveness `ACTUAL_OPERATIONAL_EVIDENCE_REQUIRED`.

### 13.9 `AF-SOP-FS-01` — Personal hygiene, cleaning, water/ice and pest/waste controls

1. **SOP ID:** `AF-SOP-FS-01`.
2. **Purpose:** Establish simple prerequisite hygiene controls suitable for a small café.
3. **Scope:** Employee health reporting, handwashing, personal hygiene, cleaning/sanitizing, food-contact equipment, chemicals, water/ice, pests and waste.
4. **Trigger:** Actor starts food work; task/contamination change; scheduled cleaning; spill/illness/pest event; opening/closing.
5. **Actors and responsibilities:** Trained food handler; later designated person-in-charge/verifier; Owner for unresolved closure/escalation policy.
6. **Required authority:** Training and task assignment; chemical/equipment use only per manufacturer and approved safety procedure.
7. **Preconditions:** Approved potable-water/ice source evidence; accessible handwashing/cleaning facilities; identified chemicals and food-contact equipment; task-specific training.
8. **Required inputs:** Area/equipment inventory, soil/hazard, cleaning method, chemical label/concentration/contact time where applicable, schedule, water/ice source, health/pest/waste records.
9. **Step-by-step procedure:** (a) actor reports relevant health/hygiene issue under later qualified policy; (b) wash hands at required task transitions; (c) separate cleaning tools/zones; (d) remove soil, wash/rinse/sanitize/air-dry where applicable under manufacturer directions; (e) verify before release; (f) protect water/ice and scoops/containers; (g) segregate chemicals; (h) remove waste without contaminating food areas; (i) record pest evidence and isolate affected area/Product; (j) append corrective action.
10. **Decision points:** Illness/symptom, unavailable handwashing, unknown chemical, failed sanitation verification, unsafe water/ice, pest evidence or waste contamination.
11. **Expected outputs:** Clean/released or held area/equipment, restricted actor/work, isolated Product and complete corrective-action record.
12. **Evidence and records:** Training/sign-off, schedule/version, actor/time, method/chemical, source/lot where applicable, observation/result, deviation, hold/release and verifier.
13. **Exceptions and failure handling:** No use of unknown chemical or unsafe source; cleaning completion without verification does not release a failed surface; contaminated Product remains isolated.
14. **Escalation path:** Food-safety risk to Owner and later qualified route; serious incident follows applicable authority procedure not invented here.
15. **Reconciliation and audit requirements:** Schedule completeness, missed-task log, repeated deviation/CAPA and source trace; records do not claim legal compliance.
16. **Relevant risks and controls:** Ill worker, cross-contamination, wrong dilution, contaminated ice/water, pest/waste transfer; controls are training, task-change hygiene, labeled chemicals, separation, verification and hold.
17. **Related policies and canonical artifacts:** Vietnamese food-safety baseline; Signature protocol; `AF-SOP-OPS-01`, `FS-02`, `GOV-01`.
18. **Dependencies:** Premises/process facts, manufacturer directions, qualified Vietnamese food-safety review and actual training/verification.
19. **Acceptance criteria:** Every required area/equipment has actor/frequency/method/record/verifier; any failed prerequisite prevents affected food activity.
20. **Source references:** `EV-BP-001`–`004`, `009`–`013`, `016`.
21. **Classification:** `RESEARCH_SUPPORTED_DESIGN`; `QUALIFIED_REVIEW_REQUIRED`; physical readiness `PHYSICAL_VALIDATION_REQUIRED`; execution `ACTUAL_OPERATIONAL_EVIDENCE_REQUIRED`.

### 13.10 `AF-SOP-FS-02` — Storage, temperature, allergens and nonconforming Product

1. **SOP ID:** `AF-SOP-FS-02`.
2. **Purpose:** Prevent use or release of unsafe, expired, cross-contacted or otherwise nonconforming ingredients/Products.
3. **Scope:** Chilled/dry storage, temperature monitoring, labeling, expiry, cross-contamination, allergen communication, isolation, complaint/incident and withdrawal readiness.
4. **Trigger:** Receiving/storage/preparation/service, temperature excursion, allergen declaration, label/expiry issue, complaint or incident.
5. **Actors and responsibilities:** Authorized receiver/custodian/food handler; trained customer-facing actor; later verifier/Owner; no role assigned here.
6. **Required authority:** Product release/hold/disposal and allergen-response authority require approved policy; disposal never inferred from hold.
7. **Preconditions:** Accepted item/specification, known label/lot/expiry, storage/equipment capability, current Ingredient/Recipe/allergen data and manufacturer/qualified limits.
8. **Required inputs:** Product/lot, received/opened/prepared dates, storage condition, actual readings/instrument evidence, allergen matrix/source, equipment status and complaint details.
9. **Step-by-step procedure:** (a) label and segregate accepted items; (b) apply FIFO or FEFO only when Product/expiry evidence supports it; (c) monitor actual storage under approved limits; (d) prevent raw/ready-to-eat and allergen cross-contact through zoning/tools/cleaning; (e) on allergen declaration use current written data and explain limitations; (f) hold any missing/failed/ambiguous item; (g) trace implicated lot/Product and stop release; (h) record complaint, affected sales and corrective action; (i) release, return, dispose or withdraw only under authorized disposition.
10. **Decision points:** Missing/expired label, excursion, unknown reading/device, cross-contact, severe allergy concern, damaged packaging, complaint cluster or traceability gap.
11. **Expected outputs:** Released, restricted, held, returned, disposed or withdrawal-candidate item with evidence and authority.
12. **Evidence and records:** Lot/expiry, storage/readings, instrument ID/check, label/Recipe version, allergen information supplied, customer communication, hold/disposition, affected Orders and CAPA.
13. **Exceptions and failure handling:** Unknown is not safe; no invented temperature threshold; shared equipment limitation is disclosed; late evidence cannot erase exposure/hold history.
14. **Escalation path:** Potential food-safety/allergen incident immediately to Owner and later qualified/emergency path as applicable; no compliance conclusion here.
15. **Reconciliation and audit requirements:** Trace held/affected quantities to receiving, movement, sale, waste/return and correction; conduct later mock withdrawal only under separate authorization.
16. **Relevant risks and controls:** Pathogen growth, expiry, allergen cross-contact, false assurance, untraceable complaint; controls are traceability, verified limits, separation, current data, hold and CAPA.
17. **Related policies and canonical artifacts:** Food-safety legal baseline; Inventory/Commercial artifacts; `AF-SOP-INV-01`, `ORD-01`, `FS-01`.
18. **Dependencies:** Qualified Vietnamese food-safety/allergen analysis, actual Product/Recipe/Ingredient/premises data, instrument capability and disposition authority.
19. **Acceptance criteria:** No item is used/released with unresolved identity, expiry, storage or cross-contact evidence; customer information matches current source version and limitations.
20. **Source references:** `EV-BP-001`–`004`, `008`–`013`, `016`.
21. **Classification:** `RESEARCH_SUPPORTED_DESIGN`; `QUALIFIED_REVIEW_REQUIRED`; `PHYSICAL_VALIDATION_REQUIRED`; actual controls `ACTUAL_OPERATIONAL_EVIDENCE_REQUIRED`.

### 13.11 `AF-SOP-COM-01` — Recipe, portion, yield, packaging and Product release

1. **SOP ID:** `AF-SOP-COM-01`.
2. **Purpose:** Standardize Product output and costing evidence without inventing Recipe quantities, tolerances or costs.
3. **Scope:** Ingredient specification, Recipe candidate/version, portion, batch, yield/loss, waste/remake, packaging fit, quality inspection, release and change control; R04/R05 remain independent.
4. **Trigger:** New Recipe candidate, authorized trial, repeat, Product release evaluation, packaging test or proposed change.
5. **Actors and responsibilities:** Owner/Recipe reviewer, authorized tester/preparer, evidence custodian and later costing reviewer; no approval is inferred.
6. **Required authority:** Separate material/acquisition and trial authorization; Owner disposition of Recipe candidate; later implementation/publication authority remains separate.
7. **Preconditions:** Identified Ingredient/SKU and source formulation, physical equipment/vessel, verified measurement capability, safe handling basis and independent run ID.
8. **Required inputs:** Product/Variant, Recipe/source version, Ingredient specification, actual quantities/units, settings, vessel/packaging, batch/output, loss/waste, time and observations.
9. **Step-by-step procedure:** (a) freeze candidate/source version; (b) verify actual instrument range/resolution/accuracy/check evidence; (c) identify Ingredients/equipment/vessel; (d) execute only authorized run; (e) record raw inputs/settings/outputs/time/loss; (f) inspect sensory/physical quality without invented threshold; (g) record packaging fit by channel; (h) Owner disposes candidate as repeat/reject/future approval; (i) calculate cost only after approved Recipe and actual purchase/conversion evidence; (j) change creates new linked version and retest scope.
10. **Decision points:** Missing SKU, unsupported conversion, device below minimum, departure, unsafe condition, output/fit failure, repeat need or proposed substitution/change.
11. **Expected outputs:** Raw trial evidence, reviewable Recipe candidate, rejected/held candidate, measured yield/loss and packaging-fit evidence; never automatic approval.
12. **Evidence and records:** Immutable run/repeat ID, actor/date/location, source and actual quantities, device/check, deviations, outputs, loss/waste, observations, disposition and version links.
13. **Exceptions and failure handling:** Do not borrow R04/R05 values, infer density/scaling, hide departure, average incompatible trials or calculate unsupported margin.
14. **Escalation path:** Safety/measurement issue holds run; specification/substitution/Recipe decision to Owner; qualified food-safety/costing questions remain separate.
15. **Reconciliation and audit requirements:** Each approved future Recipe must trace to raw trials, Ingredient specification, yield/loss and change history; costing traces separately to transactions.
16. **Relevant risks and controls:** Variation, wrong scale, unapproved substitution, biased repeat, false yield/cost; controls are versioning, instrument check, independent tracks, raw evidence and fail-closed calculations.
17. **Related policies and canonical artifacts:** Commercial V1 specification; MAKE/costing CSVs; Signature protocol; `CORE-OD-18`; R04/R05 evidence.
18. **Dependencies:** Physical materials/equipment, actual trials, Owner Recipe decisions, purchase/packaging evidence, tax/rounding review.
19. **Acceptance criteria:** Candidate is reproducible and traceable; all measurements are supported; no cost/margin exists until every required evidence class passes.
20. **Source references:** `EV-BP-001/004/009/011/013/015/016`; current Commercial evidence sources.
21. **Classification:** `RESEARCH_SUPPORTED_DESIGN`; `PROPOSED_OWNER_APPROVAL_REQUIRED`; `PHYSICAL_VALIDATION_REQUIRED`; commercial closure `COMMERCIAL_OR_PROCUREMENT_EVIDENCE`.

### 13.12 `AF-SOP-GOV-01` — Authority, compensating controls, incidents and audit

1. **SOP ID:** `AF-SOP-GOV-01`.
2. **Purpose:** Provide one consistent control envelope for small-team authority, evidence, exceptions, fraud indicators and management review.
3. **Scope:** Role/permission proposal, approval matrix, segregation/compensating controls, evidence retention design, audit trail, exception/CAPA, incident escalation and management review.
4. **Trigger:** New/changed process, authority request, prohibited combination, exception, suspected loss/fraud, repeated deviation or scheduled review.
5. **Actors and responsibilities:** Owner as business-policy authority; future authorized operators/reviewers; qualified professionals/independent reviewers only after separate engagement.
6. **Required authority:** No capability, delegation, data access, disposal, professional engagement or review is granted by this SOP.
7. **Preconditions:** Defined operation, risk, evidence category, desired actor combinations and governing confirmed policy.
8. **Required inputs:** Operation/decision ID, requester/actor/reviewer/approver/executor roles, Branch/time scope, evidence, conflicts, exception history, qualified constraints and expiry/revocation need.
9. **Step-by-step procedure:** (a) identify owning domain and confirmed boundary; (b) enumerate initiation/approval/execution/reconciliation/access actions; (c) separate incompatible duties where feasible; (d) when infeasible, document risk and use Owner pre-approval, source matching, independent after-review, exception log and trend monitoring; (e) deny undefined authority; (f) record incident without accusation; (g) investigate from immutable evidence; (h) authorize corrective/preventive action separately; (i) verify closure/effectiveness; (j) periodically review authority and exceptions after operation begins.
10. **Decision points:** Authority absent/expired/revoked, incompatible combination, emergency claim, evidence conflict, repeated anomaly, privacy/retention issue or suspected fraud.
11. **Expected outputs:** Approved/deferred authority policy proposal, denied action, compensating-control plan, incident record, CAPA and review finding; none exists until accepted by proper authority.
12. **Evidence and records:** Policy/version, authority source/scope, actor/time, approval/execution/review, exception, source evidence, investigation, CAPA owner/due status and verification.
13. **Exceptions and failure handling:** Urgency creates no authority; employee self-review cannot substitute for Owner/independent review where prohibited; conflict remains held; correction is linked.
14. **Escalation path:** Financial/custody/control incidents to Owner; legal/privacy/food-safety questions to qualified route only after authority; independent review remains separate.
15. **Reconciliation and audit requirements:** Reconstruct request-to-outcome chain; periodically compare permissions/assignments to approved policy and review anomaly trends once data exists.
16. **Relevant risks and controls:** Override, collusion, privilege creep, fabricated evidence, retaliation/false accusation, checklist theatre; controls are least privilege, provenance, separation/compensation, monitoring and independent review.
17. **Related policies and canonical artifacts:** Owner Decision Baseline; worksheet; ADR-0011; evidence/gap registers; `CP3-E03/E04` manifests.
18. **Dependencies:** `CORE-OD-12/13/16B/F`, qualified Identity/Governance/Privacy/Accounting input, actual staffing and operational evidence.
19. **Acceptance criteria:** Every positive action cites explicit authority and immutable evidence; compensating control is documented and reviewed; unresolved authority fails closed.
20. **Source references:** `EV-BP-005`–`007`, `009`, `011`, `013`; canonical Owner decisions.
21. **Classification:** `RESEARCH_SUPPORTED_DESIGN`; `PROPOSED_OWNER_APPROVAL_REQUIRED`; `QUALIFIED_REVIEW_REQUIRED`; effectiveness `ACTUAL_OPERATIONAL_EVIDENCE_REQUIRED`.

## 14. Benchmark decision readiness and non-authorization

The benchmark materially improves procedure completeness but makes **no unresolved Owner decision immediately ready** because the missing project facts, qualified analysis and authority evidence remain absent. It narrows future review to testing the twelve proposed SOPs against actual Products, premises, staffing, evidence sources and Vietnamese requirements instead of designing workflows from scratch.

No SOP above authorizes operation, purchasing, contact, physical testing, Inventory implementation, data access, Refund, Expense, Cash, Reporting, professional engagement, independent review, Gate, FOA or Production Authorization.

