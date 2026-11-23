# AFTER FOUR — Wave 2 Cross-Domain Evidence Synthesis

**Document status:** `RESEARCH_SYNTHESIS — OWNER_REVIEW_REQUIRED`

**Assessment cutoff:** 2026-11-24

**Authority:** Evidence synthesis only; no Owner decision, readiness reclassification, Gate, implementation, FOA, or Production Authorization

## 1. Executive assessment

The repository contains a complete, unique inventory of 55 active Wave 2 candidate references: Cash 8, Workforce 13, Inventory 9, Loyalty 7, Promotions 17, and Ordering 1. Their canonical reconciliation remains `16 RECORDED + 22 DIRECTION_CONFIRMED_CONDITIONAL + 2 UNRESOLVED_CONDITIONAL + 3 CLARIFICATION_REQUIRED + 12 DEPENDENCY_BLOCKED = 55`. The superseded `P2A-PROMO-OD-07` is not active.

Repository and cited comparative evidence provide useful operational examples, but do not close the five focused evidence gates or the twelve canonical dependency blockers. In particular, vendor examples do not establish AFTER FOUR authority, accounting, legal, lifecycle, timezone, or cross-domain policy. The current commissioning path is also not executable: all nine proposed evidence requests remain `PENDING`/`NOT_SENT`, and recipient discovery found no verified recipient, qualification, disclosure channel, sharing authority, or approved request bundle.

For a next review, this synthesis recommends 16 candidates as `ALREADY_RECORDED`, 23 as `EVIDENCE_INCOMPLETE`, 13 as `DEPENDENCY_BLOCKED`, three as `CLARIFICATION_REQUIRED`, and none as `READY_FOR_OWNER_POLICY_REVIEW`. The recommendation count differs deliberately from the canonical reconciliation: unresolved-conditional `P2B-INV-OD-04A` is practically dependency-blocked by the missing authoritative Preparation workflow. This is an evidence-readiness recommendation, not a status change.

## 2. Source hierarchy and interpretation rules

| Priority | Source class | Use in this synthesis |
| --- | --- | --- |
| 1 | [Owner Decision Baseline](../architecture/after_four_owner_decision_baseline.md) | Controls recorded Owner policy, canonical references, and governance boundaries. |
| 2 | [Wave 2 Owner Review Package](after_four_wave_2_owner_review_package.md) and [Flow A Closure Package](after_four_wave_2_flow_a_closure_package.md) | Controls the exact active candidate inventory, temporary references, questions, and source-grounded dependencies where not superseded by the baseline. |
| 3 | [Cross-Domain Readiness Reassessment](after_four_wave_2_cross_domain_readiness_reassessment.md), [Evidence Closure Readiness](after_four_wave_2_evidence_closure_readiness.md), and [Upstream Commercial Dependency Review](after_four_wave_2_upstream_commercial_dependency_evidence_review.md) | Controls the latest repository assessment of evidence sufficiency, ownership boundaries, and critical path. |
| 4 | [Parallel Evidence Acquisition](after_four_wave_2_parallel_evidence_acquisition.md) | Supplies desk-researched legal/accounting context and explicit limitations. It is not retained qualified-professional evidence and cannot create policy. |
| 5 | [Vietnam POS Comparative Evidence](after_four_wave_2_vietnam_pos_comparative_evidence.md) | Supplies vendor-specific examples graded per subdimension only. It cannot establish AFTER FOUR policy or architecture. |
| 6 | [Evidence Commissioning Package](after_four_wave_2_evidence_commissioning_package.md), [Evidence Acquisition Execution](after_four_wave_2_evidence_acquisition_execution.md), [Owner Commissioning Authorization](after_four_wave_2_owner_commissioning_authorization.md), [Owner Commissioning Review Session](after_four_wave_2_owner_commissioning_review_session.md), and [Recipient Discovery](after_four_wave_2_recipient_prerequisite_discovery.md) | Establish what evidence was requested, the acceptance controls, and whether delivery is currently possible. Drafts and pending ballots are not evidence received. |

Interpretation rule: **fact** means explicitly recorded by a controlling source; **inference** means a cross-source conclusion stated here; **recommendation** is non-authoritative guidance for the next review. A vendor relationship label applies only to the evidenced subdimension, never automatically to the whole candidate.

## 3. Cross-domain synthesis

The following matrix makes the six required assessment dimensions explicit. “Readiness effect” is a recommendation only and does not mutate the canonical status.

| Topic | Confirmed evidence and source quality | Evidence does not establish | Cross-domain dependencies | Canonical status represented | Readiness effect |
| --- | --- | --- | --- | --- | --- |
| Cash Sessions, Operating Day, handover, discrepancy, Reporting reconciliation | Recorded Cash directions control. Sapo supplies vendor-specific device/session, count, handover, and cancellation examples; these are subdimension evidence only ([comparative evidence](after_four_wave_2_vietnam_pos_comparative_evidence.md)). | AFTER FOUR device boundary, discrepancy authority, accounting treatment, reconciliation cadence, or Reporting hold/release. | Cash facts plus Accounting and Reporting; Payment facts where Refund affects the drawer. | Cash has four `RECORDED`, two `DIRECTION_CONFIRMED_CONDITIONAL`, one `CLARIFICATION_REQUIRED`, and one `DEPENDENCY_BLOCKED` candidate. | No promotion: recorded decisions remain recorded; `CASH-03` needs clarification evidence; `CASH-05` remains blocked; `CASH-07/08` remain incomplete. |
| Payment Refund/cancellation and Cash consequences | The commercial review preserves Payment, Cash, Ordering, Loyalty, and Promotion ownership boundaries; vendor return/cancel examples are context or partial subdimension evidence. | Refund method, original/alternate tender, partial allocation, late/uncertain outcomes, or actual Cash movement. | `EU-W2-PAY-01` precedes Cash, Loyalty, Promotion, and Ordering consequence policy. | `CASH-05`, `LOY-05`, `PROMO-05`, and `W2-ORD-OD-01` are `DEPENDENCY_BLOCKED`. | Unchanged: upstream evidence has not been received or accepted. |
| Catalog pricing, tax, service charge, rounding, and Order totals | Repository sources identify component ownership; vendor pages show that such components exist in products. | Applicable tax/accounting treatment, authoritative component sources, sold-price snapshot, rounding, allocation, or calculation sequence. | `EU-W2-CAT-01`, together with Payment and Loyalty/Promotion policy, precedes Ordering sequence. | `PROMO-05` and Ordering are blocked; related conditional Promotion/Loyalty candidates retain their directions. | Unchanged: examples do not close the commercial critical path. |
| Promotion types, stacking, Voucher lifecycle, and schedules | Vendor evidence directly supports limited type, exclusion, Voucher-category, and schedule-field subdimensions, with conflicting Voucher treatment. | Initial AFTER FOUR catalogue, deterministic global priority, complete Voucher lifecycle/binding/recovery, timezone, inclusivity, DST, or cross-midnight rules. | Catalog/Ordering/accounting for types and stacking; Customer/privacy/fraud for Voucher; Branch/Operations/time expertise for schedules. | `PROMO-01` and `PROMO-06` are `CLARIFICATION_REQUIRED`; `PROMO-08` is `UNRESOLVED_CONDITIONAL`; other directions remain conditional or recorded as listed in §4. | No open priority candidate is ready for a clean policy ballot. |
| Loyalty earning, redemption, and reversal | Confirmed directions require settled eligible value and explicit deterministic redemption rules; product examples provide context only. | Eligible components, rate, limits, rounding, calculation order, or partial Refund/cancellation reversal. | Payment/Catalog/Ordering and Promotion components; `EU-W2-PAY-01` for reversal facts. | Recorded `LOY-03/07`; conditional `LOY-01/02/04/06`; blocked `LOY-05`. | No change: conditional evidence remains incomplete and reversal remains blocked. |
| Inventory BOM, units, consumption, waste, and stocktake | Vendor sources support BOM/unit/conversion, stocktake, and deduction examples; confirmed directions preserve separate deviation evidence and explicit conversions. | Authoritative Preparation consumption event, deviation authority/accounting, item-class food-safety policy, valuation, or adjustment authority. | Actual Preparation workflow; Recipe/Catalog/Ordering facts; qualified food-safety and Accounting evidence. | `INV-01/02` recorded; five conditional directions; `INV-04A` unresolved conditional; `INV-07` blocked. | `INV-04A` is practically blocked for review; other incomplete/blocked recommendations remain unchanged. |
| Workforce, employment law, and Payroll | Recorded Workforce directions and raw/corrected/payable separation remain controlling; public POS permissions are context only. | Vietnamese employment entitlement, break/grace/rounding/leave/overtime policy, Payroll treatment, or qualified authority. | `EU-W2-WF-01` with scoped counsel, Payroll, Operations, and Accounting/Reporting evidence. | Four recorded, two conditional, and seven dependency-blocked candidates. | No change: all seven legal/Payroll-dependent candidates remain blocked. |
| Ordering dependency on Catalog, Payment, Loyalty, and Promotions | Domain ownership and the commercial critical path are explicit in repository evidence. | Proportional allocation, formulas, operation order, rounding, Refund distribution, or cross-context transaction semantics. | Stable Catalog totals, Payment outcomes, and Loyalty/Promotion component policies. | `W2-ORD-OD-01` remains `DEPENDENCY_BLOCKED`. | No change; Ordering remains last on the commercial policy path. |

### 3.1 Payment, Refund, Cash, Loyalty, Promotions, and Ordering

- **Fact:** Refund must remain an append-only attributable Payment fact. Existing sources do not settle method, original-versus-alternate tender, partial allocation, timing, or late/uncertain outcomes. A refund does not itself prove a Cash drawer movement.
- **Fact:** Cash owns drawer/session evidence; Loyalty and Promotions own their own reversal consequences; Ordering owns Order cancellation/closure consequences. These outcomes must not be inferred from one another.
- **Inference:** Payment/refund outcome evidence is an upstream prerequisite for `P2B-CASH-OD-05`, `P2A-LOY-OD-05`, `P2A-PROMO-OD-05`, and ultimately `W2-ORD-OD-01`; the downstream domains can prepare consequence matrices in parallel but cannot finalize them first.

### 3.2 Catalog, Pricing, totals, Promotions, Loyalty, and Ordering

- **Fact:** Catalog owns price/version facts; Ordering owns the sold commercial snapshot and calculation sequence; Promotions and Loyalty own their respective components; Payment owns settlement/refund facts.
- **Fact:** Tax, service-charge, rounding, adjustment, and component-accountability evidence remains incomplete.
- **Inference:** `W2-ORD-OD-01` is last on this commercial critical path because an authoritative calculation order requires stable upstream component definitions, not merely vendor examples.

### 3.3 Preparation and Inventory

- **Fact:** Vendor BOM/recipe deduction examples show possible automation, not the authoritative business event at which AFTER FOUR recognizes physical consumption.
- **Fact:** Food-safety and accounting treatment varies by item class, location, regulator, and workflow; no universal FEFO, lot-tracking, or valuation rule is established.
- **Inference:** The actual Preparation workflow must precede policy review of `P2B-INV-OD-04A`; downstream deviation and valuation work may be prepared but cannot substitute for the missing event definition.

### 3.4 Workforce

- **Fact:** Seven Workforce candidates depend on qualified employment/payroll evidence. Public vendor permissions or scheduling fields do not establish legal authority, payroll treatment, approval separation, or exception handling.
- **Inference:** `EU-W2-WF-01` is an independent evidence stream and can proceed in parallel once recipient and disclosure prerequisites are satisfied.

### 3.5 Promotions, Voucher, privacy, and scheduling

- **Fact:** Vendor sources expose promotion forms, voucher-like codes, and schedule fields, but do not select AFTER FOUR's type catalogue, resolve Voucher lifecycle/binding/recovery, or define timezone and interval boundaries.
- **Fact:** Public/customer-specific Promotion and retained Customer-bound evidence remain constrained by existing Customer/privacy governance; comparative evidence creates no cross-Brand authority.
- **Inference:** `P2A-PROMO-OD-01`, `P2A-PROMO-OD-06`, and `P2A-PROMO-OD-08` need separate evidence records; resolving one does not resolve the others.

## 4. Exact 55-candidate reconciliation

The **canonical status** column preserves the current governance record. The **recommendation** column is an evidence-readiness recommendation only.

| Candidate | Domain | Canonical status | Combined evidence conclusion | Recommendation |
| --- | --- | --- | --- | --- |
| `P2B-CASH-OD-01` | Cash | `RECORDED` | Operating-Day direction is recorded; exact parameters remain outside that decision. | `ALREADY_RECORDED` |
| `P2B-CASH-OD-02` | Cash | `RECORDED` | Operation-specific capabilities are recorded; vendor roles do not assign AFTER FOUR actors. | `ALREADY_RECORDED` |
| `P2B-CASH-OD-03` | Cash | `CLARIFICATION_REQUIRED` | Count/difference examples exist; authority, investigation, accounting, and Reporting treatment do not. | `CLARIFICATION_REQUIRED` |
| `P2B-CASH-OD-04` | Cash | `RECORDED` | Linked correction without rewriting closed evidence is recorded; operations and authority remain open. | `ALREADY_RECORDED` |
| `P2B-CASH-OD-05` | Cash | `DEPENDENCY_BLOCKED` | Requires authoritative Payment/refund/tender and actual Cash-movement outcomes. | `DEPENDENCY_BLOCKED` |
| `P2B-CASH-OD-06` | Cash | `RECORDED` | Handover evidence is recorded; device/session examples add context only. | `ALREADY_RECORDED` |
| `P2B-CASH-OD-07` | Cash | `DIRECTION_CONFIRMED_CONDITIONAL` | Top-up direction exists; withdrawal, authority, and reconciliation evidence remain incomplete. | `EVIDENCE_INCOMPLETE` |
| `P2B-CASH-OD-08` | Cash | `DIRECTION_CONFIRMED_CONDITIONAL` | Session-close examples do not settle cadence, release, or Reporting consequences. | `EVIDENCE_INCOMPLETE` |
| `P2B-WF-OD-01` | Workforce | `RECORDED` | Recorded policy; comparative evidence adds no authority. | `ALREADY_RECORDED` |
| `P2B-WF-OD-02` | Workforce | `RECORDED` | Recorded policy; no reopening is supported. | `ALREADY_RECORDED` |
| `P2B-WF-OD-03` | Workforce | `RECORDED` | Recorded policy; implementation remains unauthorized. | `ALREADY_RECORDED` |
| `P2B-WF-OD-04` | Workforce | `RECORDED` | Recorded policy; vendor practice is not controlling. | `ALREADY_RECORDED` |
| `P2B-WF-OD-05` | Workforce | `DIRECTION_CONFIRMED_CONDITIONAL` | Device/time-correction examples do not settle evidence, authority, or payroll consequences. | `EVIDENCE_INCOMPLETE` |
| `P2B-WF-OD-06A` | Workforce | `DEPENDENCY_BLOCKED` | Qualified employment/payroll input is absent. | `DEPENDENCY_BLOCKED` |
| `P2B-WF-OD-06B` | Workforce | `DEPENDENCY_BLOCKED` | Qualified employment/payroll input is absent. | `DEPENDENCY_BLOCKED` |
| `P2B-WF-OD-06C` | Workforce | `DEPENDENCY_BLOCKED` | Qualified employment/payroll input is absent. | `DEPENDENCY_BLOCKED` |
| `P2B-WF-OD-06D` | Workforce | `DEPENDENCY_BLOCKED` | Qualified employment/payroll input is absent. | `DEPENDENCY_BLOCKED` |
| `P2B-WF-OD-06E` | Workforce | `DEPENDENCY_BLOCKED` | Qualified employment/payroll input is absent. | `DEPENDENCY_BLOCKED` |
| `P2B-WF-OD-07A` | Workforce | `DEPENDENCY_BLOCKED` | Qualified employment/payroll and exception evidence is absent. | `DEPENDENCY_BLOCKED` |
| `P2B-WF-OD-07B` | Workforce | `DEPENDENCY_BLOCKED` | Qualified employment/payroll and exception evidence is absent. | `DEPENDENCY_BLOCKED` |
| `P2B-WF-OD-08A` | Workforce | `DIRECTION_CONFIRMED_CONDITIONAL` | Permission examples do not define required facts, purpose, or authority. | `EVIDENCE_INCOMPLETE` |
| `P2B-INV-OD-01` | Inventory | `RECORDED` | Recorded policy; vendor location examples do not expand it. | `ALREADY_RECORDED` |
| `P2B-INV-OD-02` | Inventory | `RECORDED` | Recorded policy; negative-stock examples are context only. | `ALREADY_RECORDED` |
| `P2B-INV-OD-03` | Inventory | `DIRECTION_CONFIRMED_CONDITIONAL` | No item-class-specific lot/expiry/FEFO evidence closes the policy. | `EVIDENCE_INCOMPLETE` |
| `P2B-INV-OD-04A` | Inventory | `UNRESOLVED_CONDITIONAL` | BOM deductions exist, but the authoritative Preparation recognition event is missing. | `DEPENDENCY_BLOCKED` |
| `P2B-INV-OD-04B` | Inventory | `DIRECTION_CONFIRMED_CONDITIONAL` | Waste/variance examples do not settle deviation authority or accounting consequences. | `EVIDENCE_INCOMPLETE` |
| `P2B-INV-OD-05` | Inventory | `DIRECTION_CONFIRMED_CONDITIONAL` | Transfer examples do not settle custody, refusal, loss, or completion outcomes. | `EVIDENCE_INCOMPLETE` |
| `P2B-INV-OD-06` | Inventory | `DIRECTION_CONFIRMED_CONDITIONAL` | Stocktake support does not establish authority and reconciliation policy. | `EVIDENCE_INCOMPLETE` |
| `P2B-INV-OD-07` | Inventory | `DEPENDENCY_BLOCKED` | Qualified accounting/valuation evidence is absent. | `DEPENDENCY_BLOCKED` |
| `P2B-INV-OD-08` | Inventory | `DIRECTION_CONFIRMED_CONDITIONAL` | Unit support does not settle canonical units, conversion versioning, or rounding. | `EVIDENCE_INCOMPLETE` |
| `P2A-LOY-OD-01` | Loyalty | `DIRECTION_CONFIRMED_CONDITIONAL` | Points examples do not define eligible value or exclusions. | `EVIDENCE_INCOMPLETE` |
| `P2A-LOY-OD-02` | Loyalty | `DIRECTION_CONFIRMED_CONDITIONAL` | No authoritative deterministic earn order/rate evidence closes the policy. | `EVIDENCE_INCOMPLETE` |
| `P2A-LOY-OD-03` | Loyalty | `RECORDED` | No-expiry direction is recorded. | `ALREADY_RECORDED` |
| `P2A-LOY-OD-04` | Loyalty | `DIRECTION_CONFIRMED_CONDITIONAL` | Permission examples do not settle requester, reviewer, approval, or emergency handling. | `EVIDENCE_INCOMPLETE` |
| `P2A-LOY-OD-05` | Loyalty | `DEPENDENCY_BLOCKED` | Requires Payment/refund and Order-cancellation outcomes before reversal policy. | `DEPENDENCY_BLOCKED` |
| `P2A-LOY-OD-06` | Loyalty | `DIRECTION_CONFIRMED_CONDITIONAL` | Promotion Branch examples do not establish Loyalty scope or cross-Brand semantics. | `EVIDENCE_INCOMPLETE` |
| `P2A-LOY-OD-07` | Loyalty | `RECORDED` | Freeze direction is recorded; implementation remains unauthorized. | `ALREADY_RECORDED` |
| `P2A-PROMO-OD-01` | Promotions | `CLARIFICATION_REQUIRED` | Vendor type examples do not establish a bounded initial AFTER FOUR catalogue. | `CLARIFICATION_REQUIRED` |
| `P2A-PROMO-OD-02` | Promotions | `DIRECTION_CONFIRMED_CONDITIONAL` | Applicability examples do not settle the exact current scope; cross-Brand remains default-deny. | `EVIDENCE_INCOMPLETE` |
| `P2A-PROMO-OD-03` | Promotions | `DIRECTION_CONFIRMED_CONDITIONAL` | Exclusion examples support a subdimension, not global priority/stacking policy. | `EVIDENCE_INCOMPLETE` |
| `P2A-PROMO-OD-04` | Promotions | `DIRECTION_CONFIRMED_CONDITIONAL` | Used-code examples do not settle reserve, release, or recovery semantics. | `EVIDENCE_INCOMPLETE` |
| `P2A-PROMO-OD-05` | Promotions | `DEPENDENCY_BLOCKED` | Requires Payment/refund and Order-cancellation outcomes before reversal policy. | `DEPENDENCY_BLOCKED` |
| `P2A-PROMO-OD-06` | Promotions | `CLARIFICATION_REQUIRED` | Vendor evidence conflicts on Voucher semantics and does not establish lifecycle/binding. | `CLARIFICATION_REQUIRED` |
| `P2A-PROMO-OD-07A` | Promotions | `RECORDED` | Creation direction is recorded; vendor capability examples do not expand authority. | `ALREADY_RECORDED` |
| `P2A-PROMO-OD-07B` | Promotions | `DIRECTION_CONFIRMED_CONDITIONAL` | Edit permissions do not settle editable fields, states, or separation. | `EVIDENCE_INCOMPLETE` |
| `P2A-PROMO-OD-07C` | Promotions | `RECORDED` | Submission direction is recorded; submission grants neither approval nor publication. | `ALREADY_RECORDED` |
| `P2A-PROMO-OD-07D` | Promotions | `RECORDED` | Approval direction is recorded within its exact boundary. | `ALREADY_RECORDED` |
| `P2A-PROMO-OD-07E` | Promotions | `DIRECTION_CONFIRMED_CONDITIONAL` | Publication evidence and operation-specific authority remain incomplete. | `EVIDENCE_INCOMPLETE` |
| `P2A-PROMO-OD-07F` | Promotions | `DIRECTION_CONFIRMED_CONDITIONAL` | Pause/stop semantics and authority remain incomplete. | `EVIDENCE_INCOMPLETE` |
| `P2A-PROMO-OD-07G` | Promotions | `DIRECTION_CONFIRMED_CONDITIONAL` | Resume/reactivation semantics and authority remain incomplete. | `EVIDENCE_INCOMPLETE` |
| `P2A-PROMO-OD-07H` | Promotions | `DIRECTION_CONFIRMED_CONDITIONAL` | Vendor patterns evidence only limited subdimensions, not complete policy. | `EVIDENCE_INCOMPLETE` |
| `P2A-PROMO-OD-07I` | Promotions | `DIRECTION_CONFIRMED_CONDITIONAL` | Vendor patterns evidence only limited subdimensions, not complete policy. | `EVIDENCE_INCOMPLETE` |
| `P2A-PROMO-OD-07J` | Promotions | `RECORDED` | Emergency-disable direction is recorded; no runtime mechanism is authorized. | `ALREADY_RECORDED` |
| `P2A-PROMO-OD-08` | Promotions | `UNRESOLVED_CONDITIONAL` | Schedule fields exist, but timezone, inclusivity, DST, and cross-midnight rules do not. | `EVIDENCE_INCOMPLETE` |
| `W2-ORD-OD-01` | Ordering | `DEPENDENCY_BLOCKED` | Requires stable Catalog totals and Loyalty/Promotion component rules before calculation order. | `DEPENDENCY_BLOCKED` |

### 4.1 Arithmetic validation

| Dimension | Counts |
| --- | --- |
| Canonical status | `16 + 22 + 2 + 3 + 12 = 55` |
| Domain | `Cash 8 + Workforce 13 + Inventory 9 + Loyalty 7 + Promotions 17 + Ordering 1 = 55` |
| Evidence-readiness recommendation | `READY 0 + INCOMPLETE 23 + BLOCKED 13 + CLARIFICATION 3 + RECORDED 16 = 55` |

## 5. Dependency graph and critical path

1. **Recipient and disclosure prerequisite:** identify a qualified recipient, verify authority/qualification, approve the minimum disclosure bundle and secure channel, and record sharing rights. No evidence request may be sent before this.
2. **Parallel upstream evidence:** execute `EU-W2-PAY-01`, `EU-W2-CAT-01`, `EU-W2-WF-01`, and `EU-W2-INV-01` independently once authorized.
3. **Commercial consequences:** accepted Payment/refund and Catalog-total evidence enables Cash, Loyalty, and Promotion consequence review.
4. **Order calculation:** stable Catalog, Loyalty, Promotion, tax/service-charge/rounding, and adjustment definitions precede `W2-ORD-OD-01`.
5. **Preparation/Inventory:** actual Preparation workflow evidence precedes `P2B-INV-OD-04A`; qualified item-class/accounting evidence precedes Inventory valuation and safety-dependent policy.
6. **Focused commissions:** `EC-W2-01`, `02`, `03`, and `05` are independent of one another, while `EC-W2-04` depends on access to the actual Preparation workflow. Parallel preparation is permissible; sending remains unauthorized until its own prerequisites pass.

No circular ownership is required: each domain supplies its facts and owns only its downstream consequence policy. Coordination is not shared aggregate ownership or a cross-domain transaction decision.

## 6. Consolidated readiness recommendation

| Category | Candidates | Meaning |
| --- | --- | --- |
| `READY_FOR_OWNER_POLICY_REVIEW` | None | No open candidate has complete accepted evidence at the cutoff. |
| `ALREADY_RECORDED` | 16 recorded candidates in §4 | Preserve; do not reopen or treat as implementation authority. |
| `CLARIFICATION_REQUIRED` | `P2B-CASH-OD-03`, `P2A-PROMO-OD-01`, `P2A-PROMO-OD-06` | Owner question remains, but current evidence does not support a clean policy ballot. |
| `DEPENDENCY_BLOCKED` | Twelve canonical blockers plus `P2B-INV-OD-04A` for practical review readiness | Await the named upstream domain/professional/workflow evidence. The extra practical blocker does not alter canonical status. |
| `EVIDENCE_INCOMPLETE` | Remaining 23 conditional candidates | Direction or question exists, but evidence is insufficient for a final policy or implementation baseline. |

## 7. Remaining evidence requests and recipient availability

| Request | Purpose | Required provider/owner evidence | Availability at cutoff |
| --- | --- | --- | --- |
| `EC-W2-01` | Cash discrepancy | Cash, Accounting, and Reporting evidence for operations, authority, escalation, and reconciliation. | `NOT_READY`; no verified recipient or approved delivery. |
| `EC-W2-02` | Promotion type catalogue | Promotions, Catalog/Pricing, Ordering, operations/Reporting, and qualified tax/accounting/trade-promotion evidence for bounded types and consequences. | `NOT_READY`; no verified recipient or approved delivery. |
| `EC-W2-03` | Voucher policy | Promotions, Customer, privacy counsel, fraud/risk, tax/accounting, and support evidence for semantics, binding, recovery, and controls. | `NOT_READY`; no verified recipient or approved delivery. |
| `EC-W2-04` | Preparation recognition | Actual Preparation, Recipe/Catalog, Ordering, and Inventory workflow evidence, followed by scoped Accounting evidence where applicable. | `NOT_READY`; actual workflow authority and recipient are absent. |
| `EC-W2-05` | Promotion scheduling | Promotions, Branch/Operations time ownership, communications/support, and technical timezone evidence for applicability and interval scenarios. | `NOT_READY`; no verified recipient or approved delivery. |
| `EU-W2-PAY-01` | Payment/refund | Provider/acquirer, Payment/Ordering, and Accounting/Reporting evidence for outcome taxonomy and refund consequences. | `NOT_READY`; provider/recipient and sharing authority unverified. |
| `EU-W2-CAT-01` | Catalog/pricing/totals | Catalog/Pricing, Ordering, qualified tax/accounting, and Reporting evidence for price snapshots, tax, service charge, rounding, and components. | `NOT_READY`; accountable evidence providers unverified. |
| `EU-W2-WF-01` | Workforce/payroll | Qualified Vietnamese employment/payroll counsel and accountable Workforce owner. | `NOT_READY`; no verified qualified recipient. |
| `EU-W2-INV-01` | Inventory/safety/accounting | Qualified item-class food-safety and accounting evidence plus accountable Inventory owner. | `NOT_READY`; scope and qualified recipients unverified. |

Across all nine requests, the repository records zero approved Owner ballot outcomes, zero sent deliveries, zero verified recipient qualifications, zero approved channels/bundles, and no evidence of permission to share the proposed materials. Recipient discovery therefore requires information outside the repository before commissioning can proceed.

## 8. Explicit non-decisions and limitations

This synthesis does **not**:

- record, amend, allocate, reserve, or propose an `ODB-*` identifier or Owner decision;
- change any of the 55 candidate statuses, classifications, accountable owners, or crosswalks;
- treat comparative vendor behavior, legal context, drafts, or recommendations as approved AFTER FOUR policy;
- choose Promotion types, Voucher semantics, discrepancy authority, Preparation recognition, timezone rules, refund behavior, calculation order, Workforce policy, Inventory accounting, or food-safety applicability;
- authorize recipient contact, disclosure, commissioning, professional engagement, procurement, expenditure, or reliance on professional advice;
- select schema, persistence, API, transaction, locking, concurrency, recovery, integration, role, capability-enforcement, or runtime mechanisms;
- grant technical-design approval, Gate A/B/C, implementation, dependency adoption, deployment, Control Acceptance, FOA, or Production Authorization; or
- alter Candidate E, Identity Milestone 2B, Package C, P1–P3, or any other governance boundary outside this evidence synthesis.

The next permissible milestone is an Owner review of recipient/commissioning prerequisites or newly accepted evidence—not implementation.
