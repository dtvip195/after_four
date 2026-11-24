# AFTER FOUR — Wave 2 Parallel Evidence Acquisition

**Status:** `EVIDENCE_ACQUISITION_COMPLETE — NO_READINESS_PROMOTION`

**Authority:** `NW-OR-01` — documentation, evidence assessment, and review preparation only

**Repository baseline:** `fc98d2eacc01aef0bb529d15deecfee885b8e23a`

**Assessment date:** 2026-11-24

**Implementation authorization:** `NOT_GRANTED`

## 1. Executive Review Digest

Five evidence workstreams were researched independently and reconciled. The review added current Vietnamese legal, accounting, invoice, employment, food-safety, measurement, privacy, and trade-promotion provenance and consolidated repository evidence for Payment/Refund, Catalog totals, Workforce, Inventory, Cash, Promotions, Preparation, Loyalty, and Ordering.

- **No dependency is fully resolved.** Authoritative sources establish constraints but do not choose AFTER FOUR's business options, providers, entity-specific treatment, workforce policy above statutory floors, or cross-domain calculations.
- **The inventory remains unchanged:** 55 active references = 16 recorded Owner decisions + 22 confirmed conditional directions + two unresolved Conditional candidates + three clarification requests + twelve dependency-blocked candidates.
- **The five evidence-gate candidates are not promoted.** Their option surfaces are better bounded, but none has complete accepted evidence for a substantive policy ballot.
- **The twelve blocked candidates remain blocked.** Payment/provider, tax/accounting, Payroll/employment-counsel, food-safety, Preparation, and upstream commercial evidence remain absent at acceptance level.
- External evidence requires entity-, person-, product-, location-, contract-, and date-specific qualified review. Finding a statute does not prove compliance or settle policy.

No Owner decision, canonical ID, readiness classification, Gate, implementation authority, FOA, or Production Authorization changes through this package.

## 2. Baseline, scope, and source methodology

The [Owner Decision Baseline](../architecture/after_four_owner_decision_baseline.md) controls policy and status. The [Cross-domain Readiness Reassessment](after_four_wave_2_cross_domain_readiness_reassessment.md) supplies the reconciled 55-candidate baseline. The [Remaining Evidence Closure Package](after_four_wave_2_remaining_evidence_closure_package.md) defines the five evidence-gate packages and twelve blocked dossiers. Other Wave 2, P1, domain, architecture, and ADR documents are supporting evidence only where consistent with the baseline.

| Classification | Meaning |
|---|---|
| `OWNER_APPROVED_BOUNDARY` | Canonical policy preserved, not reopened here. |
| `PRIMARY_SOURCE_FACT` | Direct fact/floor from an identified authoritative source. |
| `SOURCE_INTERPRETATION` | Bounded interpretation requiring applicability confirmation; not policy. |
| `NON_AUTHORITATIVE_RECOMMENDATION` | Review/design advice only. |
| `QUALIFIED_PROVIDER_REQUIRED` | Entity-, product-, location-, contract-, or profession-specific evidence remains required. |
| `OWNER_INPUT_REQUIRED` | A business choice remains after prerequisites are accepted. |

Only government, legislature, regulator, IANA, and ILO/NATLEX material was retained externally. Issuer, jurisdiction, dates, applicability, and limits are recorded in §13. Enacted Vietnamese text controls; translations are navigation aids.

## 3. Workstream A — Payment / Refund / Accounting

### 3.1 Evidence obtained

| Subject | Evidence and classification |
|---|---|
| Refund principle | `P1A-OD-03` is `OWNER_APPROVED_BOUNDARY`: method-aware, append-only Refund policy preparation; authoritative outcome reconciliation; cumulative successful-Refund cap; reason/actor/approval evidence. No provider, method, allocation, or lifecycle is selected. |
| Mismatch/excess | `P1A-OD-02`, `ODB-OP-10`, and `ODB-OP-11` prohibit default mismatch completion and treating excess as revenue; resolution remains open. |
| Cancellation | `P1A-OD-04` remains deferred. Before/after-Preparation authority does not decide financial, Preparation, Inventory, Loyalty, Promotion, remedy, or Reporting consequences. |
| History | Refund outcomes project refunded value; they do not rewrite successful Payment. Cash movement, benefit reversal, invoice correction, accounting, and Reporting are distinct facts. |
| Current invoice regime | Decree 254/2026/NĐ-CP and Circular 91/2026/TT-BTC establish the national invoice/e-document framework from 2026-07-01. Entity-specific effect requires Vietnamese tax review. |
| Provider evidence | No provider, supported rail list, contract, Refund window, callback semantics, settlement report, or SLA is selected. |

The narrowest evidence vocabulary keeps separate: Refund request; approval; execution attempt; provider-reported processing/rejection/failure/success/reversal/unknown; authoritative reconciliation; cumulative successful amount; separate Cash outflow; invoice correction/replacement; accounting/Reporting; and Loyalty/Promotion consequences. This is not an approved lifecycle, API, or schema.

| Question | Evidence result |
|---|---|
| Original versus alternate method | `NOT_ESTABLISHED`; provider contract and accounting/tax input required. |
| Full/partial Refund | Concepts exist; method, window, fees, allocation, and provider support do not. |
| Order/line/component allocation | `NOT_ESTABLISHED`; no proportional or priority rule may be inferred. |
| Unknown/late outcome | Must remain unresolved pending authoritative reconciliation; retry/escalation policy is absent. |
| Cash consequence | Requires an authoritative Refund outcome plus a separate Cash outflow fact. |

### 3.2 Cancellation consequence matrix

| Stage | Established fact | Consequences still requiring policy |
|---|---|---|
| Before Preparation | `ODB-OP-12` confirms cancellation authority with reason/audit. | Refund method, Cash effect, benefit release, remedy, invoice/accounting, Reporting. |
| After Preparation starts | Authority exists only within previously confirmed boundaries. | Prepared-work outcome, deviation, Inventory, Refund/remedy, benefits, accounting/Reporting. |
| Provider request before authoritative outcome | No completed Refund may be inferred. | Retry, timeout, late success, duplicate, communication, operational hold. |
| Confirmed sold facts | Sold/applied facts remain historical. | Linked Refund/correction/reversal; no rewrite. |

Required evidence: provider method/outcome/idempotency/settlement/fee evidence; qualified entity-specific invoice/accounting mapping; then Owner choices for methods/exceptions, authorities, allocation, stage consequences, and unknown outcomes. `P2B-CASH-OD-05`, `P2A-LOY-OD-05`, `P2A-PROMO-OD-05`, and `W2-ORD-OD-01` remain blocked.

## 4. Workstream B — Catalog / Pricing / Tax / Order totals

`ODB-CAT-07`–`ODB-CAT-10` preserve default/Branch override Price, immutable effective Price versions, Draft review of changed Price, and sold-price locking. They do not settle full totals.

| Commercial component | Owner/evidence state |
|---|---|
| Base PriceVersion and Branch override | Catalog; confirmed boundaries. |
| Modifier price effect | Catalog/Ordering; unresolved. |
| Quantity and sold snapshot | Ordering with Catalog input; partial boundaries. |
| Line-/Order-level Promotion | Promotions; type/formula/allocation unresolved. |
| Loyalty redemption | Loyalty; limits/rate/order/rounding unresolved. |
| Service charge | Ownership/applicability/treatment unresolved. |
| Tax base/category/rate/amount | Qualified tax input plus Owner policy; unresolved. |
| Zero/free/complimentary reason/value | Catalog/Ordering/Promotions/accounting; unresolved. |
| Rounding adjustment | Qualified tax/accounting plus Ordering; unresolved. |
| Final payable, Payment and refundable allocation | Ordering/Payment; unresolved dependencies. |

VAT Law 48/2024/QH15 is the originating national framework. For the assessment date, Consolidated Text 114/VBHN-VPQH dated 2026-05-20 is the primary reading/navigation reference: it incorporates amendments from Laws 90/2025/QH15, 149/2025/QH15, and 09/2026/QH16. It is not a new substantive enactment. The implementing framework also includes Decree 181/2025/NĐ-CP as amended, including by Decree 144/2026/NĐ-CP effective 2026-06-20; the separate 2026 invoice sources supply current invoice constraints. These sources do not establish AFTER FOUR's entity tax method, item rates, inclusive/exclusive display, service charge, discount treatment, mixed-rate allocation, zero/free treatment, or rounding. No calculation sequence is source-supported: proposing one would silently decide these matters.

Qualified review must determine entity/method, categories/rates, tax presentation, service charge, discounts and benefits, mixed-rate/zero/free/remake treatment, rounding, retained snapshots, and partial-Refund allocation. Owner choices follow for Modifier models, complimentary authority, service charge, rounding, snapshot, and Ordering-owned sequence. No dependency for `P2A-LOY-OD-01`, `P2A-LOY-OD-02`, `P2A-PROMO-OD-01`, `P2A-PROMO-OD-03`, `P2A-PROMO-OD-05`, or `W2-ORD-OD-01` closes.

## 5. Workstream C — Workforce / Employment Law / Payroll

### 5.1 Authoritative floors

Labour Code 45/2019/QH14 (effective 2021-01-01) is the originating instrument. Consolidated Text 18/VBHN-VPQH, issued by the Office of the National Assembly on 2026-02-12, is the current reading reference for this assessment and incorporates amendments effective in 2026; it is not a new substantive enactment. That consolidated reference, Decree 145/2020/NĐ-CP (effective 2021-02-01), and Social Insurance Law 41/2024/QH15 (effective 2025-07-01) provide national evidence. The working-time, overtime, rest, leave, wage, and discipline propositions below were rechecked as bounded statutory propositions against the consolidated reference. Applicability still depends on worker class, contract/CBA, internal labour rules, workforce size, schedule, work conditions, and current implementing instruments, and requires employment-counsel confirmation.

| Area | Primary-source fact | Not settled |
|---|---|---|
| Working/night time | Arts. 105–106 set ordinary ceilings and define night work as 22:00–06:00. | Shift model, clock rules, grace, rounding, Payroll mapping. |
| Overtime | Arts. 107–108 ordinarily require consent and impose limits with narrow exceptions. | Cafe eligibility for higher limit; approval; unapproved work; evidence. |
| Break/rest | Arts. 109–111 set break, inter-shift, and weekly-rest floors; additional breaks may be internal policy. | Recording/correction and a particular arrangement's paid treatment. |
| Leave | Arts. 112–115 establish public holiday, annual, seniority, personal, and unpaid-leave floors. | Complete insurance leave, optional categories, balance/workflow, Payroll. |
| Overtime/night pay | Art. 98 sets minimum percentage floors; Decree 145 elaborates. | Entity-specific formulas, favourable policy, correction. |
| Payroll evidence | Arts. 94–95 require direct/full/punctual pay and pay information. | Data model or device method. |
| Discipline | Arts. 117–127 require lawful rules/process and prohibit disciplinary wage fines. | Lateness/absence classes, actual non-worked-time pay, consequences. |

### 5.2 Candidate dossiers

| Candidate | Evidence acquired | Remaining gap and result |
|---|---|---|
| `P2B-WF-OD-05` | Reliable original/corrected facts matter to pay/rest/discipline; no reviewed law mandates device, geolocation, or biometrics. | Privacy, retention, missed punch, correction authority and Payroll remain; conditional direction unchanged. |
| `P2B-WF-OD-06A` | Statutory break/rest floors established. | Applicability, additional policy, recording/exceptions and Payroll; blocked. |
| `P2B-WF-OD-06B` | The reviewed statutory provisions do not establish a general grace-period rule for this use case. | Purpose, events, duration, consequences and safeguards; no numeric option is supported by the reviewed sources; blocked. |
| `P2B-WF-OD-06C` | Correct-pay floors constrain distortion; the reviewed sources do not establish a general rounding authorization for this use case. | Counsel/Payroll alternatives and safeguards; blocked. |
| `P2B-WF-OD-06D` | Internal-rule and discipline guardrails established. | Classes, thresholds, excused evidence, actual-pay versus discipline, consequences; blocked. |
| `P2B-WF-OD-06E` | Leave/insurance absence must remain distinct; dismissal thresholds are not generic classifications. | Depends on `07A`, counsel, Payroll, evidence and outcomes; blocked. |
| `P2B-WF-OD-07A` | Statutory leave floors/categories partially established. | Current insurance mapping, optional categories, balance/workflow/pay; blocked. |
| `P2B-WF-OD-07B` | Consent, caps and pay minima established; internal approval cannot replace consent or erase compensable permitted work. | Applicability, authority/evidence, exceptions, calculations, correction; blocked. |

Required deliverables are a Vietnamese employment-counsel applicability memorandum and a named Payroll-provider input/output matrix separating statutory from more-favourable policy. Only afterward should Owner ballots be prepared. Raw/original/corrected time, Payroll calculation, and discipline remain distinct.

## 6. Workstream D — Inventory / Accounting / Food Safety

### 6.1 Evidence obtained

| Area | Primary-source fact | Limitation |
|---|---|---|
| Food traceability | Food Safety Law 55/2010/QH12 requires relevant origin/safety records, traceability, stopping unsafe food, and recall/disposal cooperation. | No universal system lot, expiry, quarantine, or FEFO rule. |
| Sector traceability | Circular 17/2021/TT-BNNPTNT addresses unsafe-food traceability/recall within its Ministry scope. | Cannot generalize across all items/regulators. |
| Current national food-safety implementation | Decree 46/2026/NĐ-CP was issued/effective 2026-01-26. Resolution 09/2026/NQ-CP, issued/effective 2026-02-04, initially scheduled suspension through 2026-04-15 and resumption on 2026-04-16. Resolution 15/2026/NQ-CP, issued/effective 2026-04-06, replaced Resolution 09 and instead suspended Decree 46 until both the amended Food Safety Law and its implementing decree take effect. That termination condition had not occurred by 2026-11-24, so Decree 46 remained suspended. | Current national status as of 2026-11-24, but it does not select AFTER FOUR's classes, workflow, retention, or universal controls. Product/sector/location applicability requires qualified review. |
| Transition context | Resolution 15 Article 2 states that Decree 15/2018/NĐ-CP and related implementing/guidance instruments continue in force during the suspension. | The continuing transition framework does not establish current item-specific obligations or make Decree 15 the sole relevant source. |
| Valuation regime currency | Circular 99/2025/TT-BTC was issued by the Ministry of Finance on 2025-10-27, takes effect 2026-01-01, and applies to financial years beginning on or after that date. A year beginning before 2026-01-01 may remain under its prior regime for that financial year, subject to qualified confirmation. Circular 200/2014/TT-BTC is retained only as possible prior-regime evidence. | The entity, financial-year start, and applicable accounting regime are not established. This review therefore does not assert that any specific valuation method is currently permitted for AFTER FOUR or select any method. |
| Impairment | Circular 48/2019/TT-BTC, amended by Circular 24/2022/TT-BTC, supports impaired/damaged/obsolete-stock evidence where applicable. | Does not determine taxonomy, authority, or recognition event. |
| Measurement | Measurement Law 04/2011/QH13 supports lawful, accurate, consistent units where applicable. | Does not select units, conversions, versions, or rounding. |

### 6.2 Item-class matrix

| Candidate class | Evidence-supported minimum | Unresolved controls |
|---|---|---|
| Fresh food | Origin/traceability, product-specific storage, applicable animal-origin documents. | Lot/date, quarantine, FEFO, temperature, disposition by qualified classification. |
| Packaged processed food | Origin/label/support; labelled storage/use; unsafe/expired product not ordinarily usable. | Universal lot/FEFO/quarantine not established. |
| Unpackaged ingredient/prepared food | Safe source, contamination prevention, appropriate storage/traceability. | Holding period, batch granularity, disposition, FEFO. |
| Non-food consumables/supplies | Applicable accounting/measurement controls. | Food-law controls cannot be inferred without separate basis. |

This matrix was reassessed against Decree 46's suspended status and the continuing Resolution 15 transition framework as of the assessment date. Its bounded conclusion is unchanged: national requirements, sector-specific instruments, and product-specific duties must be distinguished, and no universal lot, expiry, quarantine, temperature, or FEFO rule may be inferred without qualified classification.

### 6.3 Candidate results

| Candidate | Result |
|---|---|
| `P2B-INV-OD-03` | Item-class direction supported; universal controls are not. Remains conditional pending qualified matrix. |
| `P2B-INV-OD-04A` | No accounting/food-safety source selects start, completion, handoff, or sale as normal-consumption event. Remains `RECOMMENDATION_NOT_ESTABLISHED`. |
| `P2B-INV-OD-04B` | Separation of deviations is consistent with evidence; classes, authority, disposal, and journals remain conditional. |
| `P2B-INV-OD-05` | Location/custody records and transport/storage supported; actors, partial receipt, discrepancy, responsibility and cost snapshot remain conditional. |
| `P2B-INV-OD-06` | Reconciliation and explicit shortage/loss supported; thresholds, approval, recount and fraud escalation remain conditional. |
| `P2B-INV-OD-07` | Circular 99 supersedes an unqualified reliance on Circular 200 for financial years beginning on or after 2026-01-01. The applicable regime and its permitted methods have not been established for AFTER FOUR; none is approved. Remains blocked on financial-year/regime confirmation, qualified-accountant recommendation, and Owner selection. |
| `P2B-INV-OD-08` | Accurate/legal units supported; dictionary, conversion and rounding remain conditional. |

Required providers: a Vietnamese food-safety adviser must classify actual items, regulator/location, traceability, dates, storage, temperature, quarantine, FEFO, recall/disposal and retention; a Vietnamese accountant must identify regime and valuation/cost/recognition/impairment/transfer/stocktake/conversion treatment; Preparation/Recipe/Ordering/Inventory must supply work and failure facts without selecting `INV-04A`.

## 7. Workstream E — Cash / Promotions / Preparation

### 7.1 Cash discrepancy — `P2B-CASH-OD-03`

Every nonzero discrepancy remains an exception requiring recording, reason, and Owner notification. Classification may affect investigation/escalation/resolution but cannot waive these duties. `ODB-CASH-14` keeps closed evidence immutable; correction is a linked fact; unresolved discrepancy stays visible.

Accounting Law 88/2015/QH13 supplies general record/correction constraints but no discrepancy classes, operations, authority, or Reporting hold/release. `RECOMMENDATION_NOT_ESTABLISHED` remains. Cash, Accounting, and Reporting must supply candidate correction operations, responsibilities, separation/escalation, evidence, reconciliation result, and unresolved-case Reporting. Any tolerance requires a separate policy amendment.

### 7.2 Initial Promotion types — `P2A-PROMO-OD-01`

Fixed, percentage, bundle, and free-item are exploratory concepts. General-expression capability is a separate broader alternative. Decree 81/2018/NĐ-CP, as amended by Decrees 128/2024/NĐ-CP and 239/2026/NĐ-CP, supplies a trade-promotion framework but does not select AFTER FOUR's catalogue or calculation semantics.

No exact bounded set is defensibly recommended. Promotions must define commercial behavior and obtain legal/tax/accounting treatment per candidate, including benefit basis, limits, eligibility, invoice/tax effect, Refund/cancellation, and communication. Status remains `CLARIFICATION_REQUIRED`.

### 7.3 Voucher policy — `P2A-PROMO-OD-06`

Bearer and Customer-bound behavior are a trade-off, not an approved choice. Decree 13/2023/NĐ-CP supplies a personal-data framework, so Customer binding may introduce purpose, lawful-processing, minimization, access, retention, and incident duties; qualified privacy review is required. Trade-promotion rules may apply depending on legal/commercial form. No source establishes issuance, reuse, transfer, limits, recovery, or fraud treatment.

Promotions, Customer/privacy counsel, fraud/risk, tax/accounting, and support must provide bounded options for issuance/eligibility, binding, transfer/reuse, limits/expiry, lost/compromised/invalid/disputed recovery, evidence, and anonymization. Phone possession is not identity or authority.

### 7.4 Preparation recognition — `P2B-INV-OD-04A`

| Candidate event | Meaning | Failure/correction risk |
|---|---|---|
| Preparation start | Identified work on quantity/RecipeVersion begins. | Early availability change; cancellation, partial/abandoned work, duplicate, waste/remake. |
| Preparation completion | Defined work completes successfully. | Delayed recognition; failure/abandonment/waste need separate facts. |
| Handoff | Completed item crosses an operational custody boundary. | May follow irreversible consumption; missing/duplicate/rejected/remade item. |
| Another evidenced event | Preparation supplies an authoritative Recipe/quantity-scoped fact. | Must not be invented by Inventory; needs failure/correction/reconciliation. |

Preparation owns work facts; Inventory owns movement/reconciliation policy. No source selects an event. Candidate remains `RECOMMENDATION_NOT_ESTABLISHED`.

### 7.5 Promotion scheduling — `P2A-PROMO-OD-08`

IANA tzdb supplies named identifiers and offset history, not business policy. It does not select `Asia/Ho_Chi_Minh`, Branch-local/Organization time, endpoint semantics, local-time anomaly behavior, or publication interaction.

| Dimension | Result |
|---|---|
| Timezone owner | One approved business timezone and Branch-local remain alternatives; neither selected. |
| Boundaries | Inclusive/exclusive combinations remain Owner choices. |
| Offset change | Named zones represent changes; ambiguous/nonexistent local-time outcome remains open. |
| Scope | One-Organization/one-Brand and cross-Brand deny remain; exact applicability is separate. |
| Publication | Scheduled eligibility cannot grant publication authority. |

Promotions and Operations must supply campaign scope, customer expectation, cross-Branch behavior, publication interaction, and local-time anomaly treatment. No timezone or interval is recommended.

## 8. Cross-workstream consistency and dependency graph

### 8.1 Ownership and shared vocabulary

| Fact/input | Accountable owner | Consumers; no ownership transfer |
|---|---|---|
| PriceVersion, Branch override, Product/Variant | Catalog | Ordering, Promotions, Loyalty, Reporting |
| Order lines, sold components, calculation/allocation | Ordering | Payment, Loyalty, Promotions, tax/accounting, Reporting |
| Payment settlement and Refund outcome | Payment | Cash, Ordering, benefits, accounting, Reporting |
| Cash movement/reconciliation | Cash | Payment, accounting, Reporting |
| Promotion reserve/redeem/release/reverse | Promotions | Ordering, Payment, Customer, Reporting |
| Loyalty earn/redeem/reversal | Loyalty | Ordering, Payment, Customer, Reporting |
| Preparation work/failure/handoff | Preparation | Inventory, Ordering, Reporting |
| Inventory movement/custody/deviation/valuation input | Inventory | Preparation, Accounting, Reporting |
| Attendance/Leave/Overtime | Workforce | Payroll, Accounting, Reporting |
| Legal/tax/accounting applicability | Qualified provider; Owner chooses within it | Affected domains |

### 8.2 Refund/cancellation consequence ownership

| Domain | Required input | Still-open consequence |
|---|---|---|
| Payment | Settlement, requested scope, provider evidence | Method, outcome, unknown/late handling |
| Cash | Refund outcome plus actual Cash event | Drawer effect, authority, reconciliation |
| Ordering | Lines/components and Preparation stage | Remedy and retained sold/cancelled facts |
| Preparation | Work stage/failure | Stop/complete/remake/waste |
| Inventory | Preparation and RecipeVersion | Consumption/deviation/correction |
| Loyalty | Refunded eligible-value allocation | Earn/redemption reversal |
| Promotions | Applied/reserved benefit allocation | Release/reverse/freeze |
| Accounting/tax | Components and invoice/provider evidence | Journal and invoice correction/replacement |
| Reporting | Authoritative outcomes | Provisional/authoritative projection and holds |

```text
Provider contract + qualified invoice/accounting evidence
  -> Refund method/outcome/allocation
     -> Cash effect + Loyalty reversal + Promotion reversal
        -> Ordering final allocation/sequence

Catalog components + qualified tax/accounting evidence
  -> tax/service-charge/rounding/free-item/Modifier policy
     -> benefit inputs + Refund allocation -> Ordering sequence

Employment counsel + Payroll -> Workforce 06A–07B
Food-safety classes + qualified Accounting -> Inventory 03/07
Preparation/Recipe/Ordering facts -> Inventory 04A
```

Payment/Catalog, Workforce, Inventory, and the evidence-gate packages can acquire evidence in parallel. Commercial policy closure becomes sequential only where inputs genuinely flow downstream. Workforce `07A` precedes the leave-dependent part of `06E`; Preparation evidence precedes `INV-04A`.

No conflicting confirmed policy was found. Material distinctions remain: accounting permission is not Owner approval; exploratory Promotion concepts are not a catalogue; timezone data is not scheduling policy; dismissal thresholds are not absence classes; invoice correction is not Refund success; acknowledgement is not approval; settlement is not Cash movement; Preparation evidence is not Inventory policy.

## 9. Reassessment of affected candidates

### 9.1 Twelve dependency-blocked candidates

| Candidate | New evidence | Result and exact remaining condition |
|---|---|---|
| `P2B-CASH-OD-05` | Refund/Cash vocabulary and invoice framework. | `NOT_RESOLVED`: provider method/outcome, allocation, accounting mapping identifying Cash effect. |
| `P2B-WF-OD-06A` | Statutory break/rest floors. | `NOT_RESOLVED`: applicability, policy options, recording/exceptions, Payroll. |
| `P2B-WF-OD-06B` | Reviewed statutory provisions do not establish a general grace-period rule for this use case. | `NOT_RESOLVED`: counsel-supported purpose/options and safeguards. |
| `P2B-WF-OD-06C` | Correct-pay constraints identified; reviewed sources do not establish a general rounding authorization for this use case. | `NOT_RESOLVED`: counsel/Payroll alternatives and safeguards. |
| `P2B-WF-OD-06D` | Discipline guardrails. | `NOT_RESOLVED`: classes/evidence/thresholds, pay versus discipline, outcomes. |
| `P2B-WF-OD-06E` | Leave/absence distinction and dismissal limits. | `NOT_RESOLVED`: `07A`, counsel/Payroll classifications and outcomes. |
| `P2B-WF-OD-07A` | Labour Code leave floors. | `NOT_RESOLVED`: insurance mapping, optional categories, balances/workflow/Payroll. |
| `P2B-WF-OD-07B` | Overtime consent/caps/pay floors. | `NOT_RESOLVED`: applicability, authority/evidence, exceptions, calculation/correction. |
| `P2B-INV-OD-07` | Multiple methods under one possible regime. | `NOT_RESOLVED`: applicable regime, qualified recommendation, Owner selection by class. |
| `P2A-LOY-OD-05` | Refund evidence vocabulary. | `NOT_RESOLVED`: approved line/component allocation and cancellation matrix. |
| `P2A-PROMO-OD-05` | Regulatory and commercial gaps. | `NOT_RESOLVED`: sold components, allocation, Refund/cancellation, Promotion consequences. |
| `W2-ORD-OD-01` | Component inventory. | `NOT_RESOLVED`: participating policies sufficiently closed to compare sequences. |

### 9.2 Five evidence-gate candidates

| Candidate | Evidence-gate conclusion | Future readiness |
|---|---|---|
| `P2B-CASH-OD-03` | Baseline clear; correction operations/authority and Reporting unsupported. | Not ready for policy selection. |
| `P2A-PROMO-OD-01` | Regulatory framework found; no bounded type set/comparison. | Not ready. |
| `P2A-PROMO-OD-06` | Privacy/regulatory dimensions found; complete Voucher options absent. | Not ready. |
| `P2B-INV-OD-04A` | Candidate consequences clarified; no event selected/recommended. | Not ready. |
| `P2A-PROMO-OD-08` | Named-zone technical evidence found; policy inputs open. | Not ready. |

Readiness classes remain exactly three `CLARIFICATION_REQUIRED`, two unresolved `CONDITIONALLY_REVIEWABLE`, and twelve `DEPENDENCY_BLOCKED`.

## 10. Evidence still requiring external qualified providers

| Provider | Required retained deliverable |
|---|---|
| Selected Payment provider/acquirer | Method/outcome/identifier/limit/retry/late-event/fee/reconciliation/retention contract matrix. |
| Vietnamese tax adviser/accountant | Attributable entity-specific VAT/invoice, commercial component, Refund, journal, valuation, impairment, and retention opinion. |
| Vietnamese employment counsel | Current-law applicability by worker/schedule, including breaks, grace/rounding, leave, discipline, overtime, privacy, special classes. |
| Payroll provider | Ordinary/night/overtime/break/leave/absence input/output matrix, separating statutory and favourable rules. |
| Vietnamese food-safety adviser | Item/location/regulator classification, traceability, dates, storage, temperature, quarantine, FEFO, recall/disposal, retention. |
| Privacy counsel and fraud/risk owner | Voucher purpose/binding/data, identity evidence, transfer/reuse/recovery, misuse, incident, anonymization. |
| Preparation/Recipe/Ordering owners | Attributable event, RecipeVersion/quantity, failure/cancellation/remake, correction and reconciliation facts. |

Each opinion must identify assessor identity/qualification, organization, jurisdiction, date/time, source versions, applicable entity/location/product/employee/provider scope, assumptions, exclusions, conflicts, and review trigger. Repository research cannot fabricate these facts.

## 11. Proposed next Owner Review preparation plan

1. Acquire in parallel: provider + tax/accounting; employment counsel + Payroll; Inventory accounting; food safety; Voucher privacy/fraud; Preparation evidence; Promotion operating-time/applicability.
2. Review provenance, applicability, conflicts, and completeness separately. Evidence acceptance is not policy selection.
3. Close Payment/Refund/cancellation and Catalog commercial inputs in accountable upstream domains.
4. Then review Cash Refund effect, Loyalty reversal, and Promotion allocation/reversal in parallel.
5. Review Ordering sequence last.
6. For Workforce, establish legal floors first, then answer breaks, grace, rounding, leave/overtime, lateness, and absence without collapsing Payroll and discipline.
7. For Inventory, keep item safety, valuation, and Preparation recognition separate.
8. Review the five evidence-gate surfaces for completeness only; do not force policy selection.

## 12. Explicit non-authorizations and limitations

This package records no Owner decision; allocates or reserves no `ODB-*` ID; changes no approved policy, status, readiness, or crosswalk; and grants no Gate A/B/C, Flow B, Control Acceptance, FOA, or Production Authorization.

It selects or authorizes no physical database design, schema, migration, index, constraint, foreign key, database operation, API, authorization, transaction, lock, isolation, event transport, code, test, dependency, configuration, deployment, provider, formula, calculation sequence, timezone, interval, Refund method, allocation, legal conclusion, accounting method, workforce threshold/rate, item class, FEFO rule, or Preparation recognition event.

Legal/professional summaries are research, not advice or compliance certification. Logical observations remain non-authoritative.

## 13. Source references

### 13.1 Repository

- [Owner Decision Baseline](../architecture/after_four_owner_decision_baseline.md)
- [Cross-domain Readiness Reassessment](after_four_wave_2_cross_domain_readiness_reassessment.md)
- [Remaining Evidence Closure Package](after_four_wave_2_remaining_evidence_closure_package.md)
- [Upstream Commercial Dependency Evidence Review](after_four_wave_2_upstream_commercial_dependency_evidence_review.md)
- [Owner Review Package](after_four_wave_2_owner_review_package.md)
- [Cross-domain Integration Register](after_four_wave_2_cross_domain_integration_decision_register.md)
- [P1A Order/Payment](after_four_p1a_order_payment_policy_closure.md) and [P1B Catalog](after_four_p1b_catalog_current_state_reconciliation.md)
- [Catalog Pricing](../architecture/after_four_catalog_pricing_discovery.md) and [Payment Model](../architecture/after_four_payment_model.md)
- [Cash](after_four_p2b_cash_domain_discovery.md), [Workforce](after_four_p2b_workforce_domain_discovery.md), [Inventory](after_four_p2b_inventory_domain_discovery.md), [Loyalty](after_four_p2a_loyalty_policy_discovery.md), and [Promotions](after_four_p2a_promotions_policy_discovery.md)
- [Business Domain Model](../architecture/after_four_business_domain_model.md), [Data Integrity Rules](../architecture/after_four_data_integrity_rules.md), [State Machines](../architecture/after_four_state_machines.md), and [ADR-0011](../architecture/adr/0011-project-wide-layered-ddd.md)

### 13.2 External primary/authoritative sources

| Source | Authority / jurisdiction | Publication/effect and limitation |
|---|---|---|
| [Accounting Law 88/2015/QH13](https://vanban.chinhphu.vn/?classid=1&docid=183198&pageid=27160&typegroupid=3) | National Assembly / Vietnam | Issued 2015-11-20; effective 2017-01-01. Records/corrections; no Cash authority. |
| [VAT Law 48/2024/QH15](https://vanban.chinhphu.vn/?docid=212476&orggroupid=1&pageid=27160) | National Assembly / Vietnam | Originating instrument issued 2024-11-26; effective 2025-07-01. Read with later amendments and consolidated reference; entity/rate review required. |
| [Law 90/2025/QH15](https://vanban.chinhphu.vn/?docid=214558&pageid=27160) | National Assembly / Vietnam | Issued 2025-06-25; VAT amendments effective 2025-07-01; incorporated in Consolidated Text 114. |
| [Law 149/2025/QH15](https://congbao.chinhphu.vn/van-ban/luat-so-149-2025-qh15-468709.htm) | National Assembly / Vietnam | Issued 2025-12-11; effective 2026-01-01; VAT amendment incorporated in Consolidated Text 114. |
| [Law 09/2026/QH16](https://vanban.chinhphu.vn/?docid=218095&pageid=27160) | National Assembly / Vietnam | Issued/effective 2026-04-24; VAT amendment incorporated in Consolidated Text 114. |
| [Consolidated VAT Text 114/VBHN-VPQH](https://xdcs.cdnchinhphu.vn/446259493575335936/2026/6/5/2026-305-114-vbhn-vpqh-17806273642891917566820.pdf) | Office of the National Assembly / Vietnam | Certified 2026-05-20 and published in Official Gazette No. 305 on 2026-06-03. Current reading/navigation reference combining Laws 48, 90, 149, and 09; not a new enactment and not entity-specific tax advice. |
| [Decree 144/2026/NĐ-CP](https://vanban.chinhphu.vn/?classid=1&docid=218020&pageid=27160) | Government / Vietnam | Issued 2026-05-05; effective 2026-06-20. Amends VAT implementation Decree 181/2025/NĐ-CP as previously amended; applicability still requires tax review. |
| [Decree 254/2026/NĐ-CP](https://vanban.chinhphu.vn/?docid=218689&orggroupid=2&pageid=27160) | Government / Vietnam | Issued 2026-06-30; effective 2026-07-01. Current invoice framework; mapping required. |
| [Circular 91/2026/TT-BTC](https://vanban.chinhphu.vn/?classid=1&docid=219006&orggroupid=4&pageid=27160) | Ministry of Finance / Vietnam | Issued 2026-06-30; effective 2026-07-01. No POS formula selected. |
| [Labour Code 45/2019/QH14](https://vanban.chinhphu.vn/?docid=198540&pageid=27160) | National Assembly / Vietnam | Issued 2019-11-20; effective 2021-01-01. Counsel applicability required. |
| [Consolidated Labour Code Text 18/VBHN-VPQH](https://vanban.chinhphu.vn/?classid=2629&docid=217002&pageid=27160) | Office of the National Assembly / Vietnam | Issued 2026-02-12. Current reading reference incorporating amendments effective in 2026; not a new enactment. Counsel applicability remains required. |
| [ILO NATLEX Labour Code record](https://natlex.ilo.org/dyn/natlex2/r/natlex/fe/details?p3_isn=110469) | ILO repository / Vietnam instrument | Translation/navigation aid; enacted Vietnamese controls. |
| [Decree 145/2020/NĐ-CP](https://vanban.chinhphu.vn/?classid=1&docid=201967&pageid=27160) | Government / Vietnam | Issued 2020-12-14; effective 2021-02-01. Applicability needs counsel. |
| [Social Insurance Law 41/2024/QH15](https://vanban.chinhphu.vn/?classid=1&docid=211199&pageid=27160&typegroupid=3) | National Assembly / Vietnam | Issued 2024-06-29; effective 2025-07-01. Provider/counsel mapping required. |
| [Food Safety Law 55/2010/QH12](https://vanban.chinhphu.vn/?classid=1&docid=96032&pageid=27160&typegroupid=3) | National Assembly / Vietnam | Issued 2010-06-17; effective 2011-07-01. No universal FEFO/lot policy. |
| [Decree 46/2026/NĐ-CP](https://vanban.chinhphu.vn/?docid=216827&orggroupid=2&pageid=27160) | Government / Vietnam | Issued/effective 2026-01-26; remained suspended at the 2026-11-24 cutoff under Resolution 15. Product/sector/location applicability still requires qualified review. |
| [Resolution 09/2026/NQ-CP](https://vanban.chinhphu.vn/?docid=216891&pageid=27160) | Government / Vietnam | Issued/effective 2026-02-04. Historically scheduled suspension through 2026-04-15 and resumption on 2026-04-16, but was replaced before that date by Resolution 15. |
| [Government explanation of Resolution 09's original schedule](https://baochinhphu.vn/tam-ngung-hieu-luc-va-dieu-chinh-thoi-han-ap-dung-nghi-dinh-so-46-2026-nd-cp-102260205184324295.htm) | Government News / Vietnam | Published 2026-02-05. Historical explanation of Resolution 09's original transition schedule, not the status at the assessment cutoff and not a separate enactment. |
| [Resolution 15/2026/NQ-CP](https://chinhphu.vn/?docid=217667&pageid=27160) | Government / Vietnam | Issued/effective 2026-04-06. Replaced Resolution 09; suspends Decree 46 until both the amended Food Safety Law and its implementing decree take effect; continues Decree 15/2018 and related instruments during the suspension. |
| [Decree 15/2018/NĐ-CP](https://vanban.chinhphu.vn/?docid=192829&pageid=27160) | Government / Vietnam | Issued/effective 2018-02-02. Continues during the Resolution 15 suspension under Resolution 15 Article 2; not the sole relevant source and not an AFTER FOUR-specific applicability conclusion. |
| [Circular 17/2021/TT-BNNPTNT](https://vanban.chinhphu.vn/?classid=1&docid=204774&pageid=27160&typegroupid=6) | MARD / Vietnam | Issued 2021-12-20; effective 2022-02-02. Sector-scoped only. |
| [Circular 99/2025/TT-BTC](https://congbao.chinhphu.vn/van-ban/thong-tu-so-99-2025-tt-btc-46529/59649.htm) | Ministry of Finance / Vietnam | Issued 2025-10-27; effective 2026-01-01 and applies to financial years beginning on or after that date. Applicable regime and valuation methods require qualified confirmation. |
| [Ministry of Finance application guidance for Circular 99](https://portal.mof.gov.vn/hoidapcstc/home/cthoidap/159102) | Accounting and Auditing Policy Department, Ministry of Finance / Vietnam | Response dated 2026-01-14. Confirms a financial year beginning before 2026-01-01 remains under the prior regime for that year and applies Circular 99 from the next qualifying financial year; entity-specific confirmation remains required. |
| [Circular 200/2014/TT-BTC](https://vbpl.vn/FileData/TW/Lists/vbpq/Attachments/66801/VanBanGoc_200-2014-TT-BTC_200-2014-TT-BTC.pdf) | Ministry of Finance / Vietnam | Issued 2014-12-22; effective 2015-02-05; amended. Retained as possible prior-financial-year regime evidence only, subject to qualified confirmation; not an unqualified current 2026 regime. |
| [Circular 48/2019/TT-BTC as amended](https://vanban.chinhphu.vn/?classid=1&docid=205610&pageid=27160) | Ministry of Finance / Vietnam | Base issued 2019-08-08; amendment effective 2022-05-25. No workflow selected. |
| [Measurement Law 04/2011/QH13](https://vanban.chinhphu.vn/default.aspx?docid=162349&pageid=27160) | National Assembly / Vietnam | Issued 2011-11-11; effective 2012-07-01. No internal unit policy selected. |
| [Decree 13/2023/NĐ-CP](https://vanban.chinhphu.vn/default.aspx?docid=207759&pageid=27160) | Government / Vietnam | Issued 2023-04-17; effective 2023-07-01. Voucher applicability needs counsel. |
| [Decree 81/2018/NĐ-CP](https://vanban.chinhphu.vn/?docid=193772&pageid=27160) | Government / Vietnam | Issued 2018-05-22; effective 2018-07-15. No internal type catalogue selected. |
| [Decree 128/2024/NĐ-CP](https://vanban.chinhphu.vn/?docid=211405&pageid=27160) | Government / Vietnam | Issued 2024-10-10; effective 2024-12-01. Amends Decree 81. |
| [Decree 239/2026/NĐ-CP](https://vanban.chinhphu.vn/?docid=218591&orggroupid=2&pageid=27160) | Government / Vietnam | Issued/effective 2026-06-26. Latest identified amendment on review date. |
| [IANA Time Zone Database](https://www.iana.org/time-zones) | IANA / international technical reference | Continuously maintained; accessed 2026-11-24. Technical data, not policy. |
