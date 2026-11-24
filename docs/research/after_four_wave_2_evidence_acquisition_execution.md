# AFTER FOUR — Wave 2 Evidence Acquisition Execution

**Status:** `REQUEST_DRAFTS_READY — NO_REQUEST_SENT — NO_EVIDENCE_RECEIVED`

**Authority:** `NW-OR-01` — documentation, evidence-request drafting, and acquisition tracking only

**Repository baseline:** `075407e6f84b84843e374cc313ee67cb90b973cf`

**Preparation date:** 2026-11-24 (Asia/Tokyo)

**Canonical ODB allocation:** `NOT_REQUESTED — NO_IDS_PROPOSED_OR_RESERVED`

**Implementation and Gate authorization:** `NOT_GRANTED`

## 1. Purpose and control boundary

This document turns the merged [Wave 2 Evidence Commissioning Package](after_four_wave_2_evidence_commissioning_package.md) into role-addressed request drafts and a controlled execution tracker. It does not claim that a request was delivered, acknowledged, answered, reviewed, or accepted.

The [Owner Decision Baseline](../architecture/after_four_owner_decision_baseline.md#wave-2-conditional-direction-and-clarification-responses) remains canonical. The commissioning package controls the question scope, reviewers, artifacts, provenance, and closure criteria. This execution document may track acquisition activity but cannot select policy, change readiness, delegate Owner authority, or substitute generic research for qualified or operational evidence.

## 2. Canonical reconciliation and tracker rules

| Canonical classification | Count | Execution treatment |
|---|---:|---|
| Recorded Owner decisions | 16 | Preserved; not reopened. |
| Confirmed Conditional directions | 22 | Preserved; outstanding conditions are not re-voted here. |
| Unresolved Conditional candidates | 2 | Request drafts prepared for `P2B-INV-OD-04A` and `P2A-PROMO-OD-08`; no selection. |
| Clarification candidates | 3 | Request drafts prepared for `P2B-CASH-OD-03`, `P2A-PROMO-OD-01`, and `P2A-PROMO-OD-06`; no policy response inferred. |
| Dependency-blocked candidates | 12 | Tracked against four shared upstream requests; none unblocked. |
| **Active total** | **55** | **`16 + 22 + 2 + 3 + 12 = 55`** |

Allowed tracker statuses are `NOT_PREPARED`, `DRAFT_READY`, `REQUESTED`, `EVIDENCE_RECEIVED`, `UNDER_REVIEW`, `GAP_CLOSED`, `GAP_REMAINS`, and `DEFERRED`.

- `DRAFT_READY` means a usable role-based request exists in this document; it does not mean delivery.
- `REQUESTED` requires retained delivery or acknowledgement evidence and an actual request date.
- `EVIDENCE_RECEIVED` requires a stable retained artifact reference and actual response date.
- `UNDER_REVIEW` requires an identified reviewer and review start evidence.
- `GAP_CLOSED` requires the commissioning-package closure criteria and a retained sufficiency review; it is not an Owner decision.
- Empty dates and artifact references are represented by `—`, not guessed values.

## 3. Execution tracker

### 3.1 Five evidence commissions

| Commission / candidate | Accountable request owner | Required recipients/reviewers | Status | Request date | Response date | Artifact reference | Provenance | Review | Outstanding questions | Next action / responsible role |
|---|---|---|---|---|---|---|---|---|---|---|
| `EC-W2-01` / `P2B-CASH-OD-03` | Cash | Cash operations; qualified Vietnamese accountant; Reporting owner; authority/governance input | `DRAFT_READY` | — | — | — | Not assessed | Not started | Classification, linked operations, initiator/reviewer/approver, accounting, reconciliation, Reporting hold/release | Owner authorizes delivery to role-based recipients; Cash request owner records delivery evidence |
| `EC-W2-02` / `P2A-PROMO-OD-01` | Promotions | Promotions; Catalog/Pricing; Ordering; operations/Reporting; qualified tax/accounting/trade-promotion review as applicable | `DRAFT_READY` | — | — | — | Not assessed | Not started | Finite catalogue, exact semantics, applicability, stacking/allocation, cancellation/Refund, legal/tax/operations consequences | Owner authorizes delivery; Promotions request owner records recipient scope and delivery evidence |
| `EC-W2-03` / `P2A-PROMO-OD-06` | Promotions | Promotions; Customer; qualified Vietnamese privacy counsel; fraud/risk; tax/accounting; support | `DRAFT_READY` | — | — | — | Not assessed | Not started | Inclusion, issuance, bearer/bound, reuse/transfer, limits/expiry, compromise/recovery, privacy/fraud | Owner authorizes delivery; Promotions request owner records delivery evidence and confidentiality route |
| `EC-W2-04` / `P2B-INV-OD-04A` | Inventory | Preparation; Recipe/Catalog; Ordering; Inventory; qualified accountant after operational facts | `DRAFT_READY` | — | — | — | Not assessed | Not started | Actual lifecycle facts, quantities, failure/cancellation/remake/waste, event candidates and later valuation consequences | Owner authorizes operational evidence request; Inventory coordinates role responses without selecting an event |
| `EC-W2-05` / `P2A-PROMO-OD-08` | Promotions | Promotions; Operations/Branch owners; customer communications/support; technical timezone reviewer | `DRAFT_READY` | — | — | — | Not assessed | Not started | Timezone ownership/scope, boundaries, offset anomalies, cross-midnight, publication/pause/resume/end interaction | Owner authorizes delivery; Promotions request owner records delivery evidence |

### 3.2 Twelve dependency blockers

| Candidate | Shared request | Accountable downstream owner | Required upstream recipients | Status | Dates / artifact | Outstanding dependency | Next action / responsible role |
|---|---|---|---|---|---|---|---|
| `P2B-CASH-OD-05` | `EU-W2-PAY-01` | Cash | Payment/Ordering; selected provider; Accounting/Reporting | `DRAFT_READY` | — / — | Refund method/allocation, settlement outcome, Cash effect | Payment request owner seeks Owner authorization to send shared request |
| `P2B-WF-OD-06A` | `EU-W2-WF-01` | Workforce | Vietnamese employment counsel; Payroll; Workforce operations | `DRAFT_READY` | — / — | Break entitlement/timing/interruption/correction/Payroll consequence | Workforce request owner scopes worker/schedule/entity facts before delivery |
| `P2B-WF-OD-06B` | `EU-W2-WF-01` | Workforce | Vietnamese employment counsel; Payroll; Workforce operations | `DRAFT_READY` | — / — | Grace-period legality/purpose/events/consequences | Same shared request; no duration may be guessed |
| `P2B-WF-OD-06C` | `EU-W2-WF-01` | Workforce | Vietnamese employment counsel; Payroll | `DRAFT_READY` | — / — | Whether rounding is permitted and bounded calculation consequences | Same shared request; raw time remains separate |
| `P2B-WF-OD-06D` | `EU-W2-WF-01` | Workforce | Vietnamese employment counsel; Payroll/Reporting; operations | `DRAFT_READY` | — / — | Lateness classes/evidence/review/consequences | Same shared request; no discipline inference |
| `P2B-WF-OD-06E` | `EU-W2-WF-01` | Workforce | Vietnamese employment counsel; Payroll/Reporting; operations | `DRAFT_READY` | — / — | Absence treatment depends on leave outcome from `P2B-WF-OD-07A` | Acquire leave evidence first; keep absence separately answerable |
| `P2B-WF-OD-07A` | `EU-W2-WF-01` | Workforce | Vietnamese employment counsel; Payroll; operations | `DRAFT_READY` | — / — | Leave categories/entitlement/workflow/dates/correction/Payroll effects | Same shared request; this response precedes `06E` readiness |
| `P2B-WF-OD-07B` | `EU-W2-WF-01` | Workforce | Vietnamese employment counsel; Payroll/Accounting; operations | `DRAFT_READY` | — / — | Overtime eligibility/authority/evidence/rate/exceptions/correction | Same shared request; no rate or approval rule inferred |
| `P2B-INV-OD-07` | `EU-W2-INV-01` | Inventory | Qualified Vietnamese accountant; Inventory | `DRAFT_READY` | — / — | Applicable regime, valuation objective/method/events/corrections | Inventory request owner supplies entity/financial-year facts before delivery |
| `P2A-LOY-OD-05` | `EU-W2-PAY-01` | Loyalty | Payment/Ordering; selected provider; Loyalty consulted | `DRAFT_READY` | — / — | Authoritative Refund/cancellation outcome and line/value/time allocation | Reuse retained shared evidence; Loyalty later owns reversal policy |
| `P2A-PROMO-OD-05` | `EU-W2-PAY-01` + `EU-W2-CAT-01` | Promotions | Payment/Ordering/provider; Catalog/Pricing; tax/accounting | `DRAFT_READY` | — / — | Refund/cancellation and total-component/allocation inputs | Send both bounded shared requests; Promotions later owns reversal/allocation policy |
| `W2-ORD-OD-01` | `EU-W2-PAY-01` + `EU-W2-CAT-01` | Ordering | Payment, Catalog, Loyalty, Promotions | `DRAFT_READY` | — / — | Participating policies and semantic inputs for Order calculation sequence | Collect shared upstream evidence; sequence decision remains last |

All twelve rows remain `DEPENDENCY_BLOCKED` canonically. `DRAFT_READY` describes only the acquisition request, not the candidate.

### 3.3 Shared upstream request tracker

| Request | Scope / downstream consumers | Request owner | Recipient profiles | Status | Request/response dates | Artifact / review | Next action |
|---|---|---|---|---|---|---|---|
| `EU-W2-PAY-01` | Provider Refund/cancellation evidence for `P2B-CASH-OD-05`, `P2A-LOY-OD-05`, `P2A-PROMO-OD-05`, `W2-ORD-OD-01` | Payment/Ordering | Selected Payment provider/acquirer; Payment/Ordering; Accounting/Reporting | `DRAFT_READY` | — / — | — / not started | Owner authorizes delivery after provider and environment scope are supplied |
| `EU-W2-CAT-01` | Catalog/Pricing/commercial totals for `P2A-PROMO-OD-05`, `W2-ORD-OD-01`; input to `EC-W2-02` | Catalog/Pricing | Catalog/Pricing; Ordering; qualified tax/accounting; Reporting | `DRAFT_READY` | — / — | — / not started | Owner authorizes delivery after entity/channel/catalogue scope is supplied |
| `EU-W2-WF-01` | Employment/Payroll evidence for seven blocked Workforce candidates | Workforce | Vietnamese employment counsel; Payroll provider/owner; operations; Accounting/Reporting as applicable | `DRAFT_READY` | — / — | — / not started | Owner authorizes delivery after worker/entity/schedule scope is supplied |
| `EU-W2-INV-01` | Item/Branch food-safety and Inventory accounting evidence for `P2B-INV-OD-07`; operational inputs may inform but cannot decide `EC-W2-04` | Inventory | Food-safety adviser; qualified accountant; Inventory/Branch/Preparation owners | `DRAFT_READY` | — / — | — / not started | Owner authorizes separated food-safety, accounting, and workflow annex requests |

## 4. Five usable evidence-request drafts

Each draft below may be copied into an email or internal request only after the Owner authorizes delivery and the role placeholders are replaced with actual approved recipients. Sending is outside this task.

### 4.1 Draft EC-W2-01 — Cash discrepancy

**To:** `[Cash operations owner]`; `[qualified Vietnamese accountant for the applicable entity/regime]`; `[Reporting owner]`

**Subject:** Evidence request EC-W2-01 — Cash discrepancy classification, correction, accounting, and Reporting

**Purpose and bounded question:** Please provide attributable evidence needed to compare Cash discrepancy policy alternatives under `P2B-CASH-OD-03`. The controlling baseline has no tolerance: every nonzero discrepancy is recorded with reason and Owner notification. `ODB-CASH-14` confirms separately attributable linked correction facts without reopening or rewriting closed evidence; it does not authorize a specific post-close operation or its initiator, reviewer, or approver.

**Questions:**

1. What actual discrepancy cases occur, and what classification facts affect investigation, escalation, and resolution without waiving recording, reason, or Owner notification?
2. Which linked post-close actions are operationally meaningful, and what evidence precedes/follows each action?
3. Who could initiate, independently review, approve, reject, or escalate each candidate action, and what supports that responsibility boundary?
4. For the identified entity/regime, what journal, period-close, reconciliation, and unresolved-case consequences apply?
5. When may authoritative Reporting continue, be qualified, be held, or be released, and how must the original and linked facts remain visible?

**Required artifact and provenance:** Return a discrepancy/operation/authority/accounting/Reporting matrix plus attributable accounting advice and relevant approved operating evidence. State authors, roles, qualifications, organizations, entity/regime/report scope, assessment date/timezone, source versions, assumptions, exclusions, conflicts, and review trigger.

**Not requested:** Do not introduce tolerance, select Owner policy, treat notification as approval, rewrite closed evidence, design schema/workflow, or authorize implementation.

**Expected response:** Executive limitations; case taxonomy; operation/authority matrix; accounting and Reporting consequences; evidence list; conflicts; unresolved questions; signed/traceable references.

**References:** `EC-W2-01`; `P2B-CASH-OD-03`; `ODB-CASH-14`.

### 4.2 Draft EC-W2-02 — Promotion type catalogue

**To:** `[Promotions owner]`; `[Catalog/Pricing owner]`; `[Ordering owner]`; `[operations/Reporting owner]`; `[qualified Vietnamese tax/accounting/trade-promotion reviewer as applicable]`

**Subject:** Evidence request EC-W2-02 — bounded initial Promotion type alternatives

**Purpose and bounded question:** Please prepare comparable business-semantics evidence for only the finite Promotion types that should be considered for an initial Owner ballot under `P2A-PROMO-OD-01`. `fixed`, `percentage`, `bundle`, and `free-item` are exploratory concepts, not an approved catalogue. General-expression capability is a separate broader direction.

**Questions:** For every proposed type, define benefit, eligibility, applicability, exclusions, limits, authoritative Product/Variant and price inputs, stacking, allocation, redemption/reservation where relevant, fulfillment, cancellation, Refund, zero/free outcomes, customer/staff communication, Reporting, and support consequences. Identify invoice, tax, accounting, and trade-promotion applicability constraints for the specified entity/form/channel. Explain why the type is needed and which facts remain unresolved. Evaluate general expression separately rather than using it to fill missing semantics.

**Required artifact and provenance:** Return one versioned semantics sheet per type and a same-dimension comparison matrix, with attributable affected-domain review and professional advice where required. State authors, qualifications, entity, Promotion form, channel, location, period, source/amendment versions, assessment date, assumptions, exclusions, conflicts, and review trigger.

**Not requested:** Do not select the initial set, rename `fixed` to a more specific type without evidence, approve an expression language, decide formulas/calculation order, or design persistence/implementation.

**Expected response:** Scope and limitations; type sheets; comparison; cross-domain inputs; professional constraints; operational scenarios; evidence references; unresolved questions.

**References:** `EC-W2-02`; `P2A-PROMO-OD-01`; current trade-promotion chain cited in the commissioning package.

### 4.3 Draft EC-W2-03 — Voucher policy

**To:** `[Promotions owner]`; `[Customer owner]`; `[qualified Vietnamese privacy counsel]`; `[fraud/risk owner]`; `[tax/accounting reviewer]`; `[customer support owner]`

**Subject:** Evidence request EC-W2-03 — bounded Voucher policy alternatives

**Purpose and bounded question:** Please provide complete alternatives for whether Voucher enters the bounded scope and, if so, its issuance, bearer/Customer binding, use, transfer, limits, expiry, compromise, recovery, fraud, privacy, and exception treatment under `P2A-PROMO-OD-06`.

**Questions:**

1. What commercial purpose and scope justify Voucher, and who may request, issue, revoke, or evidence issuance?
2. What are complete bearer, Customer-bound, and no-Voucher directions? What personal data and identity evidence are actually necessary?
3. What constitutes successful use/reversal, single/multiple use, transfer, per-scope limits, expiry, loss, theft, copying, compromise, invalid/disputed use, revoke/reissue, replacement, and recovery?
4. What fraud controls, support/escalation outcomes, invoice/tax/liability effects, privacy duties, and residual risks accompany each direction?
5. How does each direction preserve Customer anonymization, benefit-history/non-transfer policy, one-Organization/one-Brand, and cross-Brand default deny?

**Required artifact and provenance:** Return a complete Voucher option matrix, attributable Vietnamese privacy advice under [Law 91/2025/QH15](https://vanban.chinhphu.vn/?classid=1&docid=214590&orggroupid=1&pageid=27160) and [Decree 356/2025/NĐ-CP](https://datafiles.chinhphu.vn/cpp/files/vbpq/2026/01/356-nd.signed.pdf), fraud scenario assessment, support evidence, tax/accounting advice, and Customer compatibility review. State reviewer identity/qualification, organization, entity/data-subject/Voucher/channel/location scope, legal versions, threat assumptions, dates, limitations, conflicts, and review trigger.

**Not requested:** Do not infer identity or authority from phone possession, transfer Customer-specific benefits, restore identity, select cross-Brand behavior, decide token/storage/authorization mechanisms, select policy, or authorize implementation.

**Expected response:** Scope; complete alternatives by dimension; privacy/fraud/tax/support analysis; compatibility matrix; residual risks; evidence references; unresolved questions.

**References:** `EC-W2-03`; `P2A-PROMO-OD-06`; applicable Customer decisions and `SDP-SCOPE-01`.

### 4.4 Draft EC-W2-04 — Preparation consumption recognition

**To:** `[Preparation process owner]`; `[Recipe/Catalog owner]`; `[Ordering owner]`; `[Inventory owner]`; `[qualified accountant after workflow evidence exists]`

**Subject:** Evidence request EC-W2-04 — actual Preparation lifecycle and Inventory recognition candidates

**Purpose and bounded question:** Please document the actual Preparation workflow and authoritative facts required to compare start, completion, handoff/dispatch, or another evidenced event as the normal-consumption recognition point under `P2B-INV-OD-04A`.

**Questions:** When are ingredients issued, transformed, irreversibly used, completed, handed off, rejected, abandoned, partially completed, remade, wasted, spoiled, cancelled, quantity-changed, or corrected? Which actor/system evidence, RecipeVersion, quantities, substitutions, yields, and unit conversions exist at each point? Which facts belong to Preparation, Recipe/Catalog, Ordering, and Inventory? What availability/reconciliation and later valuation implications arise for each evidenced candidate?

**Required artifact and provenance:** Return an approved actual-workflow map, observed Branch procedure, event/failure/correction matrix, RecipeVersion/quantity examples, exception records, and semantic responsibility map. State process owners/observers, Branch/product/station scope, observation/approval dates, workflow versions, sample basis, exceptions, disagreements, assumptions, and review trigger. Accounting assessment follows operational evidence.

**Not requested:** Do not select a recognition event, infer it from UI convenience, merge normal consumption with waste/remake/spoilage/deviation, decide valuation, journal, schema, event/API, transaction, lock, recovery, or implementation.

**Expected response:** Actual workflow; event/evidence matrix; failure/correction scenarios; ownership map; candidate consequences; limitations/conflicts; artifact references.

**References:** `EC-W2-04`; `P2B-INV-OD-04A`; controlling `P2B-INV-OD-04B` distinction.

### 4.5 Draft EC-W2-05 — Promotion timezone and interval semantics

**To:** `[Promotions owner]`; `[Operations/Branch operating-time owner]`; `[customer communications/support owner]`; `[technical timezone reviewer]`

**Subject:** Evidence request EC-W2-05 — Promotion timezone, boundaries, and lifecycle scenarios

**Purpose and bounded question:** Please provide business-scope and scenario evidence to compare Promotion timezone ownership, start/end boundaries, offset anomalies, cross-midnight behavior, and lifecycle interactions under `P2A-PROMO-OD-08`.

**Questions:** Is each campaign Branch-specific or shared within the current Brand? Which role owns the authoritative timezone at each scope? What customer promise applies exactly at start/end and across midnight? How should ambiguous/nonexistent local times be handled where relevant? What occurs on publication, pause, resume, manual end, rescheduling, exceptional days, and timezone-configuration change? How are disputes communicated and supported?

**Required artifact and provenance:** Return a campaign applicability matrix, approved operating-time evidence, exact-instant/local-time scenario table, customer wording/support cases, and IANA timezone source/version. State owners, applicable Branches/campaign classes, assessment date, assumptions, exclusions, conflicts, and review trigger.

**Not requested:** Do not silently choose UTC, `Asia/Ho_Chi_Minh`, Branch/Organization time, inclusivity, half-open intervals, storage/clock representation, scheduling jobs, queries, publication authority, cross-Brand applicability, or implementation.

**Expected response:** Scope/ownership facts; scenario matrix; lifecycle interactions; communications/support outcomes; technical examples separated from policy recommendations; limitations and evidence references.

**References:** `EC-W2-05`; `P2A-PROMO-OD-08`; approved Promotion lifecycle directions; `SDP-SCOPE-01`.

## 5. Shared upstream request drafts

### 5.1 Draft EU-W2-PAY-01 — Payment / Refund

**To:** `[selected Payment provider/acquirer representative]`; `[Payment/Ordering owner]`; `[Accounting/Reporting owner]`

**Bounded purpose:** Establish provider-specific and business-authoritative Refund/cancellation facts consumed by Cash, Loyalty, Promotions, and Ordering. Please answer: supported original/alternate methods; partial Refund and per-payment/line/value allocation; success/pending/failure/late/duplicate/reversal outcomes; settlement identifiers/timing; fees; Cash movement; reconciliation/reporting; limits; retry/idempotency facts; retention; and provider/environment/version limitations.

**Artifact/provenance:** Official provider documentation or attributable provider response, method/outcome matrix, sample sanitized lifecycle records, Accounting/Reporting interpretation, provider/product/environment/version and assessment dates, assumptions and gaps.

**Exclusions:** Do not select consumer-domain reversal policy, Order calculation sequence, schema/API/implementation, or infer production behavior from generic documentation.

**Response structure:** Provider scope; method matrix; lifecycle/outcomes; allocations; settlement/reconciliation; downstream authoritative facts; limitations; references.

**Downstream references:** `P2B-CASH-OD-05`, `P2A-LOY-OD-05`, `P2A-PROMO-OD-05`, `W2-ORD-OD-01`.

### 5.2 Draft EU-W2-CAT-01 — Catalog / Pricing / commercial totals

**To:** `[Catalog/Pricing owner]`; `[Ordering owner]`; `[qualified Vietnamese tax/accounting reviewer]`; `[Reporting owner]`

**Bounded purpose:** Establish authoritative commercial components and evidence required by Promotion allocation/reversal and Ordering sequence decisions. Please identify base/sold price sources; Variant/Modifier components; tax/service-charge applicability and presentation; discounts/benefits; free/zero/remake treatment; mixed-rate cases; rounding points; versioned price and sold-price history; Refund/cancellation allocation; and unresolved components.

**Artifact/provenance:** Versioned commercial-component dictionary, worked scenarios, authoritative-source/owner matrix, qualified entity-specific tax/accounting advice, Reporting treatment, dates, source/amendment versions, assumptions, conflicts and gaps.

**Exclusions:** Do not select a Promotion type, stacking/allocation policy, Loyalty formula, Order sequence, physical schema, calculation implementation, or universal legal conclusion.

**Response structure:** Entity/channel/catalogue scope; component dictionary; source ownership; scenario calculations as evidence rather than policy; professional constraints; unresolved inputs; references.

**Downstream references:** `P2A-PROMO-OD-05`, `W2-ORD-OD-01`; input to `EC-W2-02`.

### 5.3 Draft EU-W2-WF-01 — Workforce / employment law / Payroll

**To:** `[qualified Vietnamese employment counsel]`; `[Payroll provider/owner]`; `[Workforce operations owner]`; `[Accounting/Reporting owner as applicable]`

**Bounded purpose:** Establish current, scoped legal floors and Payroll consequences for breaks, grace periods, rounding, lateness, absence, leave, and overtime while preserving raw attendance separately from corrected and payable facts.

**Questions:** For the identified entity, worker classes, locations and schedules: what obligations/options apply to break entitlement/timing/interruption; grace purposes/events; time rounding; lateness/absence classifications; leave categories/entitlement/dates/corrections; overtime eligibility/prior authority/evidence/rates/exceptions? Which facts feed Payroll, and how do corrections affect payable outcomes? Identify propositions requiring legal advice versus provider mapping versus Owner policy.

**Artifact/provenance:** Signed/attributable counsel advice, Payroll input/output matrix, operational attendance-event dictionary, worked sanitized scenarios, source/amendment/effective-date record, applicability scope, assumptions, conflicts and review trigger.

**Exclusions:** Do not invent durations, thresholds, rates, entitlement, discipline, approval, schema, timekeeping implementation, or treat Payroll output as legal advice.

**Response structure:** Scope; legal floors/options; raw/corrected/payable fact map; candidate-specific annexes `06A`–`06E`, `07A`, `07B`; Payroll mapping; limitations and references.

**Downstream references:** `P2B-WF-OD-06A`, `06B`, `06C`, `06D`, `06E`, `07A`, `07B`.

### 5.4 Draft EU-W2-INV-01 — Inventory / food safety / Accounting

**To:** `[Inventory owner]`; `[Branch/Preparation process owner]`; `[qualified Vietnamese food-safety adviser]`; `[qualified Vietnamese accountant]`

**Bounded purpose:** Obtain separate, scoped food-safety, operational-item, and accounting evidence without collapsing Preparation recognition into valuation. Identify actual item classes, Branch/location/workflow, regulator, traceability, date/lot/expiry/quarantine/FEFO/recall/disposal needs, units/conversions, accounting regime, valuation objective/options/events, impairment, transfers, stocktake, correction and retention.

**Artifact/provenance:** Item/location/regulator applicability matrix; approved Branch workflow; attributable food-safety advice under current sources; attributable accounting regime/valuation advice; entity/financial-year/item scope; reviewer qualifications; dates; source/effective/transition versions; assumptions, exclusions and conflicts.

**Exclusions:** Do not infer universal FEFO/lot tracking, applicability to every item/Branch, a Preparation recognition event, valuation selection, journal, Inventory policy, schema, ledger or implementation. The evidence response must reflect that [Decree 46/2026/NĐ-CP](https://vanban.chinhphu.vn/?docid=216827&orggroupid=2&pageid=27160) remained suspended at the 2026-11-24 cutoff: [Resolution 09/2026/NQ-CP](https://vanban.chinhphu.vn/?docid=216891&pageid=27160) originally scheduled a 2026-04-16 resumption, but [Resolution 15/2026/NQ-CP](https://chinhphu.vn/?docid=217667&pageid=27160), effective 2026-04-06, replaced Resolution 09 and suspended Decree 46 until both the amended Food Safety Law and its implementing decree take effect. Resolution 15 Article 2 continues [Decree 15/2018/NĐ-CP](https://vanban.chinhphu.vn/?docid=192829&pageid=27160) and related implementing/guidance instruments during the suspension. This timeline does not establish AFTER FOUR-specific applicability or controls.

**Response structure:** Separate food-safety, actual-workflow and accounting annexes; applicability matrices; candidate options; unresolved questions; evidence references.

**Downstream references:** `P2B-INV-OD-07`; relevant operational evidence may inform but cannot decide `EC-W2-04` / `P2B-INV-OD-04A`.

## 6. Evidence intake protocol

### 6.1 Intake record

For each actually received artifact, create a non-sensitive intake record containing:

| Field | Requirement |
|---|---|
| Artifact ID | Stable repository-governed identifier assigned at intake; does not create an ODB ID |
| Scope references | Commission/shared request and every affected candidate |
| Source identity | Original filename or source identifier; author; organization; role and qualification where relevant |
| Dates | Actual received date; author assessment date and timezone; review date only when review occurs |
| Applicability | Entity, jurisdiction, Branch/location, provider/environment, product/item, worker class, channel, workflow and period as applicable |
| Source control | Document/provider versions; legal amendments, effective dates and transition status; immutable or controlled reference |
| Analysis boundary | Facts, professional interpretation, business recommendation and unresolved Owner choice separated explicitly |
| Limitations | Assumptions, exclusions, conflicts, uncertainty, residual risk and review/expiry trigger |
| Review | Reviewer identity/role; review status/outcome; unanswered commission questions |
| Handling | Permission to retain; classification; confidentiality; approved repository or controlled external location |

No tracker row advances to `EVIDENCE_RECEIVED` until an artifact ID and retained reference exist. No row advances to `UNDER_REVIEW` until reviewer and review-start evidence exist. No row advances to `GAP_CLOSED` without a retained sufficiency review against the commissioning-package closure criteria.

### 6.2 Sensitive and restricted evidence

Do not commit confidential personal data, Customer data, employee records, credentials, secrets, contracts, privileged legal advice, or proprietary provider documents without explicit authorization and an approved handling location. When an artifact cannot be committed, retain only a controlled reference plus a non-sensitive summary that records provenance, scope, conclusions at the authorized level, limitations, access owner, and review outcome. Do not copy restricted text into issues, commits, logs, or this tracker.

## 7. Parallel execution and dependency plan

| Independent acquisition stream | Can proceed now after delivery authorization | Downstream dependency preserved |
|---|---|---|
| Cash operations + Accounting + Reporting | EC-W2-01 responses may be gathered independently and reconciled | Does not close `P2B-CASH-OD-03` until all authority/accounting/Reporting gaps pass review |
| Promotion semantics | EC-W2-02 commercial/type sheets | Catalog/Ordering/professional inputs still required |
| Voucher/privacy/fraud/support | EC-W2-03 annexes against one question matrix | No Voucher policy until complete alternatives reviewed |
| Preparation actual workflow | EC-W2-04 operational observation, Recipe and Ordering facts | Operational facts precede Inventory consequence and Accounting review |
| Promotion scheduling | EC-W2-05 campaigns, Branch time, communications and technical scenarios | Named-zone mechanics do not choose policy |
| Payment provider | EU-W2-PAY-01 once provider/environment known | Shared by Cash, Loyalty, Promotions, Ordering; consumer policies remain separate |
| Catalog commercial inputs | EU-W2-CAT-01 | Precedes Promotion allocation and Ordering sequence |
| Workforce counsel + Payroll | EU-W2-WF-01 with candidate-specific annexes | `07A` leave evidence precedes `06E`; no threshold/rate inferred |
| Inventory Accounting + food safety | Separate EU-W2-INV-01 annexes | Valuation and item safety remain separate from Preparation event recognition |

Evidence may be acquired in parallel; acceptance and policy sequencing remain unchanged. Shared artifacts must retain their original provenance and limitations when referenced downstream.

## 8. Governance and execution safeguards

This document:

- preserves exactly 55 candidates: 16 recorded decisions, 22 confirmed Conditional directions, two unresolved Conditional, three clarification, and twelve dependency-blocked;
- records no Owner decision and allocates, proposes, reserves, or records no canonical `ODB-*` identifier;
- changes no candidate classification, accountable owner, approved direction, rationale, or crosswalk;
- marks no request `REQUESTED` and no evidence `EVIDENCE_RECEIVED`, `UNDER_REVIEW`, or `GAP_CLOSED`;
- contacts no external party and sends no email or request;
- delegates no Owner authority to a request owner, recipient, expert, provider, reviewer, or evidence custodian;
- preserves one Organization/one Brand and cross-Brand default deny, with no inferred multi-Brand behavior;
- selects no Cash operation, Promotion type, Voucher rule, Preparation event, timezone, interval, Refund allocation, valuation method, Workforce rule, or Order calculation sequence;
- authorizes no technical design, schema, migration, database creation or operation, API, persistence, transaction, locking, isolation, event transport, source code, test, dependency, runtime behavior, deployment, or production access; and
- grants no Gate A, Gate B, Gate C, Control Acceptance, Final Operational Acceptance, or Production Authorization.

## 9. Source references

- [Owner Decision Baseline](../architecture/after_four_owner_decision_baseline.md)
- [Wave 2 Evidence Commissioning Package](after_four_wave_2_evidence_commissioning_package.md)
- [Wave 2 Evidence Closure Readiness](after_four_wave_2_evidence_closure_readiness.md)
- [Wave 2 Remaining Evidence Closure Package](after_four_wave_2_remaining_evidence_closure_package.md)
- [Wave 2 Cross-domain Readiness Reassessment](after_four_wave_2_cross_domain_readiness_reassessment.md)
- [Wave 2 Parallel Evidence Acquisition](after_four_wave_2_parallel_evidence_acquisition.md)
- [Wave 2 Upstream Commercial Dependency Evidence Review](after_four_wave_2_upstream_commercial_dependency_evidence_review.md)
- [Cash discovery](after_four_p2b_cash_domain_discovery.md), [Workforce discovery](after_four_p2b_workforce_domain_discovery.md), [Inventory discovery](after_four_p2b_inventory_domain_discovery.md), [Loyalty discovery](after_four_p2a_loyalty_policy_discovery.md), and [Promotions discovery](after_four_p2a_promotions_policy_discovery.md)
- [P1A Order/Payment closure](after_four_p1a_order_payment_policy_closure.md), [P1B Catalog reconciliation](after_four_p1b_catalog_current_state_reconciliation.md), and [Cross-domain Integration Register](after_four_wave_2_cross_domain_integration_decision_register.md)
- [Customer Owner Decisions](../architecture/after_four_customer_management_owner_decisions.md), [`SDP-SCOPE-01`](../architecture/after_four_sdp_scope_01_owner_decision.md), [Business Domain Model](../architecture/after_four_business_domain_model.md), and [ADR-0011](../architecture/adr/0011-project-wide-layered-ddd.md)

This execution setup must be rechecked against canonical sources before any request is actually sent. Recipient approval, confidentiality handling, and delivery authorization remain outside this commit.
