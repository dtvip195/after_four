# AFTER FOUR — Wave 2 Owner Review Package

**Status:** `PREPARED_FOR_OWNER_REVIEW — NO_OWNER_DECISIONS_RECORDED`

**Authority:** `NW-OR-01` — documentation, discovery, and logical-design preparation only

**Canonical ODB allocation:** `NOT_REQUESTED — TEMPORARY_REFERENCES_ONLY`

**Candidate E Gate A:** `DEFER_GATE_A — NOT_GRANTED`

**Candidate E Gate B proposal preparation:** `NOT_AUTHORIZED`

**Implementation authorization:** `NOT_GRANTED`

**Date:** 2026-11-23

## 1. Purpose and governance boundary

This package provides one review surface for the 55 active Wave 2 Owner business-policy candidates prepared across Loyalty, Promotions, Inventory, Cash, Workforce, and Ordering. It consolidates evidence and recommendations without replacing the seven source documents or changing accountable domain ownership.

Appearance here is not approval. No Owner selection is recorded, no canonical `ODB-*` ID is allocated or reserved, and no Gate A, Gate B, Gate C, Control Acceptance, FOA, or Production Authorization is granted. The package authorizes no schema, migration, database, constraint, index, transaction, lock, API, code, test, dependency, runtime, UI, deployment, or production operation.

Production MVP `MUST` means Loyalty and Advanced Promotions are required product capabilities under the [Owner Decision Baseline §5A](../architecture/after_four_owner_decision_baseline.md#5a-production-mvp-customer-loyalty-and-promotions-scope). It is not implementation authorization and does not settle formulas, operating policy, workflow, or technical design.

Controlling sources are the [Owner Decision Baseline](../architecture/after_four_owner_decision_baseline.md), [ADR-0011](../architecture/adr/0011-project-wide-layered-ddd.md), the [Wave 2 digest](after_four_wave_2_owner_review_digest.md), five domain annexes, and the [cross-domain register](after_four_wave_2_cross_domain_integration_decision_register.md). Existing P1 decisions and deferrals, Customer decisions `SDP-CUST-01`–`22`, `SDP-CUST-A2`, `SDP-SCOPE-01`, and Candidate E governance remain controlling.

## 2. Review classifications

| Classification | Meaning |
|---|---|
| `READY_FOR_OWNER_REVIEW` | The source provides a bounded business question, supported options, and sufficient evidence for an Owner choice now. |
| `CONDITIONALLY_REVIEWABLE` | The Owner may review direction, but final selection must account for named domain or qualified external input. |
| `DEPENDENCY_BLOCKED` | A responsible selection should wait for a named unresolved policy or qualified input. |
| `CLARIFICATION_REQUIRED` | Source evidence is insufficient even to present bounded supported options. None is currently classified here. |

“Independent” below means independently answerable; it does not remove consultation or later technical gates. “Wait” means do not select until the named dependency is available.

## 3. Consolidated decision index

### 3.1 Cash — 8 candidates

| Ref | Concise question | Accountable owner | Source | Dependencies | Readiness / review mode |
|---|---|---|---|---|---|
| `P2B-CASH-OD-01` | Define Operating Day timezone and cutoff. | Cash | [Cash §5](after_four_p2b_cash_domain_discovery.md#5-candidate-owner-decisions) | Business governance, Expense, and Reporting consultation | `READY_FOR_OWNER_REVIEW` / independent |
| `P2B-CASH-OD-02` | Assign open, count, handover, and close authority. | Cash | [Cash §5](after_four_p2b_cash_domain_discovery.md#5-candidate-owner-decisions) | Identity implementation later | `READY_FOR_OWNER_REVIEW` / independent policy matrix |
| `P2B-CASH-OD-03` | Define discrepancy escalation and resolution. | Cash | [Cash §5](after_four_p2b_cash_domain_discovery.md#5-candidate-owner-decisions) | Accounting/Reporting consultation | `READY_FOR_OWNER_REVIEW` / independent |
| `P2B-CASH-OD-04` | Define permitted post-close corrections. | Cash | [Cash §5](after_four_p2b_cash_domain_discovery.md#5-candidate-owner-decisions) | Reconciliation/audit consultation | `READY_FOR_OWNER_REVIEW` / independent |
| `P2B-CASH-OD-05` | Define drawer effect of cash and alternate-method Refunds. | Cash | [Cash §5](after_four_p2b_cash_domain_discovery.md#5-candidate-owner-decisions) | P1A Refund method/allocation policy | `DEPENDENCY_BLOCKED` / wait |
| `P2B-CASH-OD-06` | Define handover evidence and approval. | Cash | [Cash §5](after_four_p2b_cash_domain_discovery.md#5-candidate-owner-decisions) | Session actor policy | `READY_FOR_OWNER_REVIEW` / coordinate with `CASH-02` |
| `P2B-CASH-OD-07` | Define top-up executor and permitted fund sources. | Cash | [Cash §5](after_four_p2b_cash_domain_discovery.md#5-candidate-owner-decisions) | Existing Owner-approval policy; accounting input | `READY_FOR_OWNER_REVIEW` / independent |
| `P2B-CASH-OD-08` | Define reconciliation cadence and closure dependencies. | Cash | [Cash §5](after_four_p2b_cash_domain_discovery.md#5-candidate-owner-decisions) | Operating Day and Reporting | `READY_FOR_OWNER_REVIEW` / coordinate with `CASH-01` |

### 3.2 Workforce — 13 candidates

| Ref | Concise question | Accountable owner | Source | Dependencies | Readiness / review mode |
|---|---|---|---|---|---|
| `P2B-WF-OD-01` | Define Employee lifecycle and rehire semantics. | Workforce | [Workforce §5](after_four_p2b_workforce_domain_discovery.md#5-candidate-owner-decisions) | Identity access coordination | `READY_FOR_OWNER_REVIEW` / independent |
| `P2B-WF-OD-02` | Define Branch Assignment authority and temporary scope. | Workforce | [Workforce §5](after_four_p2b_workforce_domain_discovery.md#5-candidate-owner-decisions) | Organization facts; Identity remains separate | `READY_FOR_OWNER_REVIEW` / independent |
| `P2B-WF-OD-03` | Assign shift draft, publish, change, and cancel authority. | Workforce | [Workforce §5](after_four_p2b_workforce_domain_discovery.md#5-candidate-owner-decisions) | Branch eligibility | `READY_FOR_OWNER_REVIEW` / operation matrix |
| `P2B-WF-OD-04` | Define shift-swap policy. | Workforce | [Workforce §5](after_four_p2b_workforce_domain_discovery.md#5-candidate-owner-decisions) | Employee acknowledgement; Branch eligibility | `READY_FOR_OWNER_REVIEW` / independent |
| `P2B-WF-OD-05` | Define clock authority, device/location, and correction policy. | Workforce | [Workforce §5](after_four_p2b_workforce_domain_discovery.md#5-candidate-owner-decisions) | Legal/employment and device/time evidence | `CONDITIONALLY_REVIEWABLE` / qualified input |
| `P2B-WF-OD-06A` | Define break entitlement and recording. | Workforce | [Workforce §5](after_four_p2b_workforce_domain_discovery.md#5-candidate-owner-decisions) | Qualified employment/legal and Payroll input | `DEPENDENCY_BLOCKED` / wait |
| `P2B-WF-OD-06B` | Define grace periods. | Workforce | [Workforce §5](after_four_p2b_workforce_domain_discovery.md#5-candidate-owner-decisions) | Qualified employment/legal input | `DEPENDENCY_BLOCKED` / wait |
| `P2B-WF-OD-06C` | Define time rounding. | Workforce | [Workforce §5](after_four_p2b_workforce_domain_discovery.md#5-candidate-owner-decisions) | Qualified employment/legal and Payroll input | `DEPENDENCY_BLOCKED` / wait |
| `P2B-WF-OD-06D` | Define lateness classification and consequences. | Workforce | [Workforce §5](after_four_p2b_workforce_domain_discovery.md#5-candidate-owner-decisions) | Qualified employment/legal and Payroll/Reporting input | `DEPENDENCY_BLOCKED` / wait |
| `P2B-WF-OD-06E` | Define absence classification and consequences. | Workforce | [Workforce §5](after_four_p2b_workforce_domain_discovery.md#5-candidate-owner-decisions) | Leave outcomes; qualified employment/legal input | `DEPENDENCY_BLOCKED` / wait |
| `P2B-WF-OD-07A` | Define leave categories, entitlement, balance, and workflow. | Workforce | [Workforce §5](after_four_p2b_workforce_domain_discovery.md#5-candidate-owner-decisions) | Qualified employment/legal and Payroll input | `DEPENDENCY_BLOCKED` / wait |
| `P2B-WF-OD-07B` | Define overtime eligibility, authority, recording, and calculation. | Workforce | [Workforce §5](after_four_p2b_workforce_domain_discovery.md#5-candidate-owner-decisions) | Qualified employment/legal, accounting, and Payroll input | `DEPENDENCY_BLOCKED` / wait |
| `P2B-WF-OD-08A` | Define facts and legitimate purposes exposed to operational domains. | Workforce | [Workforce §5](after_four_p2b_workforce_domain_discovery.md#5-candidate-owner-decisions) | Privacy/retention and consumer-domain input | `CONDITIONALLY_REVIEWABLE` / business policy only |

### 3.3 Inventory — 9 candidates

| Ref | Concise question | Accountable owner | Source | Dependencies | Readiness / review mode |
|---|---|---|---|---|---|
| `P2B-INV-OD-01` | Define bounded stock locations and ownership. | Inventory | [Inventory §5](after_four_p2b_inventory_domain_discovery.md#5-candidate-owner-decisions) | Organization/Branch reference facts | `READY_FOR_OWNER_REVIEW` / independent |
| `P2B-INV-OD-02` | Decide negative-stock policy. | Inventory | [Inventory §5](after_four_p2b_inventory_domain_discovery.md#5-candidate-owner-decisions) | Operations/reconciliation consultation | `READY_FOR_OWNER_REVIEW` / independent |
| `P2B-INV-OD-03` | Define lot, expiry, quarantine, and FEFO applicability. | Inventory | [Inventory §5](after_four_p2b_inventory_domain_discovery.md#5-candidate-owner-decisions) | Item classes and food-safety input | `CONDITIONALLY_REVIEWABLE` / qualified input |
| `P2B-INV-OD-04A` | Define normal consumption recognition point/evidence. | Inventory | [Inventory §5](after_four_p2b_inventory_domain_discovery.md#5-candidate-owner-decisions) | Preparation facts and approved Recipe inputs | `CONDITIONALLY_REVIEWABLE` / coordinated |
| `P2B-INV-OD-04B` | Define waste/remake/failed-preparation deviation policy. | Inventory | [Inventory §5](after_four_p2b_inventory_domain_discovery.md#5-candidate-owner-decisions) | Preparation deviation taxonomy and operations input | `CONDITIONALLY_REVIEWABLE` / coordinated |
| `P2B-INV-OD-05` | Define transfer approval, partial receipt, and discrepancy. | Inventory | [Inventory §5](after_four_p2b_inventory_domain_discovery.md#5-candidate-owner-decisions) | Location/custody policy | `READY_FOR_OWNER_REVIEW` / independent |
| `P2B-INV-OD-06` | Define stocktake variance and adjustment authority. | Inventory | [Inventory §5](after_four_p2b_inventory_domain_discovery.md#5-candidate-owner-decisions) | Audit and loss-control consultation | `READY_FOR_OWNER_REVIEW` / independent |
| `P2B-INV-OD-07` | Select valuation/costing policy. | Inventory | [Inventory §5](after_four_p2b_inventory_domain_discovery.md#5-candidate-owner-decisions) | Qualified accounting input | `DEPENDENCY_BLOCKED` / wait |
| `P2B-INV-OD-08` | Define authoritative units, conversions, and rounding. | Inventory | [Inventory §5](after_four_p2b_inventory_domain_discovery.md#5-candidate-owner-decisions) | Catalog/Recipe item and quantity model | `CONDITIONALLY_REVIEWABLE` / coordinated |

### 3.4 Loyalty — 7 candidates

| Ref | Concise question | Accountable owner | Source | Dependencies | Readiness / review mode |
|---|---|---|---|---|---|
| `P2A-LOY-OD-01` | Define earning event and eligible value. | Loyalty | [Loyalty §5](after_four_p2a_loyalty_policy_discovery.md#5-candidate-policy-decisions) | Order/Payment truth; total components | `CONDITIONALLY_REVIEWABLE` / coordinated |
| `P2A-LOY-OD-02` | Define redemption limits, ordering, and rounding. | Loyalty | [Loyalty §5](after_four_p2a_loyalty_policy_discovery.md#5-candidate-policy-decisions) | Ordering sequence; Promotions interaction | `CONDITIONALLY_REVIEWABLE` / coordinated |
| `P2A-LOY-OD-03` | Decide whether and how points expire. | Loyalty | [Loyalty §5](after_four_p2a_loyalty_policy_discovery.md#5-candidate-policy-decisions) | Notice/legal/timezone consultation | `READY_FOR_OWNER_REVIEW` / independent direction |
| `P2A-LOY-OD-04` | Assign manual-adjustment request/approval authority. | Loyalty | [Loyalty §5](after_four_p2a_loyalty_policy_discovery.md#5-candidate-policy-decisions) | Identity/audit implementation later | `READY_FOR_OWNER_REVIEW` / independent |
| `P2A-LOY-OD-05` | Define partial Refund/cancellation reversal allocation. | Loyalty | [Loyalty §5](after_four_p2a_loyalty_policy_discovery.md#5-candidate-policy-decisions) | P1A Refund allocation and cancellation outcomes | `DEPENDENCY_BLOCKED` / wait |
| `P2A-LOY-OD-06` | Define Brand/Organization/Branch benefit scope. | Loyalty | [Loyalty §5](after_four_p2a_loyalty_policy_discovery.md#5-candidate-policy-decisions) | `SDP-SCOPE-01`; cross-Brand remains denied | `CONDITIONALLY_REVIEWABLE` / bounded direction only |
| `P2A-LOY-OD-07` | Define exceptional post-anonymization treatment. | Loyalty | [Loyalty §5](after_four_p2a_loyalty_policy_discovery.md#5-candidate-policy-decisions) | Fixed preserve/freeze/no-restoration policy | `READY_FOR_OWNER_REVIEW` / independent exception boundary |

### 3.5 Promotions — 17 candidates

| Ref | Concise question | Accountable owner | Source | Dependencies | Readiness / review mode |
|---|---|---|---|---|---|
| `P2A-PROMO-OD-01` | Select initial supported Promotion types. | Promotions | [Promotions §5](after_four_p2a_promotions_policy_discovery.md#5-candidate-policy-decisions) | Product scope and operating needs | `READY_FOR_OWNER_REVIEW` / independent |
| `P2A-PROMO-OD-02` | Define Brand/Branch/channel/Catalog applicability. | Promotions | [Promotions §5](after_four_p2a_promotions_policy_discovery.md#5-candidate-policy-decisions) | Catalog facts; `SDP-SCOPE-01` | `CONDITIONALLY_REVIEWABLE` / bounded direction |
| `P2A-PROMO-OD-03` | Define stacking, exclusion, and priority. | Promotions | [Promotions §5](after_four_p2a_promotions_policy_discovery.md#5-candidate-policy-decisions) | Ordering calculation sequence; Loyalty coordination | `CONDITIONALLY_REVIEWABLE` / coordinated |
| `P2A-PROMO-OD-04` | Define reserve, redeem, release, and reverse points. | Promotions | [Promotions §5](after_four_p2a_promotions_policy_discovery.md#5-candidate-policy-decisions) | Order/Payment lifecycle and supported benefit types | `CONDITIONALLY_REVIEWABLE` / coordinated |
| `P2A-PROMO-OD-05` | Define discount allocation and Refund/cancellation treatment. | Promotions | [Promotions §5](after_four_p2a_promotions_policy_discovery.md#5-candidate-policy-decisions) | P1A; Price/tax/service-charge/rounding | `DEPENDENCY_BLOCKED` / wait |
| `P2A-PROMO-OD-06` | Define Voucher issuance, reuse, transfer, and limits. | Promotions | [Promotions §5](after_four_p2a_promotions_policy_discovery.md#5-candidate-policy-decisions) | Customer/privacy/fraud consultation | `READY_FOR_OWNER_REVIEW` / independent scope choice |
| `P2A-PROMO-OD-07A` | Assign Draft/create authority. | Promotions | [Promotions §5](after_four_p2a_promotions_policy_discovery.md#5-candidate-policy-decisions) | Approved scope model | `READY_FOR_OWNER_REVIEW` / independent operation |
| `P2A-PROMO-OD-07B` | Assign edit authority and permitted states. | Promotions | [Promotions §5](after_four_p2a_promotions_policy_discovery.md#5-candidate-policy-decisions) | Lifecycle-state policy | `READY_FOR_OWNER_REVIEW` / authority direction now, states later |
| `P2A-PROMO-OD-07C` | Decide submission step and authority. | Promotions | [Promotions §5](after_four_p2a_promotions_policy_discovery.md#5-candidate-policy-decisions) | Approval workflow choice | `READY_FOR_OWNER_REVIEW` / independent workflow direction |
| `P2A-PROMO-OD-07D` | Assign approval authority. | Promotions | [Promotions §5](after_four_p2a_promotions_policy_discovery.md#5-candidate-policy-decisions) | Scope/delegation policy | `READY_FOR_OWNER_REVIEW` / independent operation |
| `P2A-PROMO-OD-07E` | Assign publish/activate authority. | Promotions | [Promotions §5](after_four_p2a_promotions_policy_discovery.md#5-candidate-policy-decisions) | Approval and lifecycle policy | `CONDITIONALLY_REVIEWABLE` / coordinated |
| `P2A-PROMO-OD-07F` | Assign pause/suspend authority. | Promotions | [Promotions §5](after_four_p2a_promotions_policy_discovery.md#5-candidate-policy-decisions) | Lifecycle and escalation policy | `CONDITIONALLY_REVIEWABLE` / coordinated |
| `P2A-PROMO-OD-07G` | Assign resume/reactivate authority. | Promotions | [Promotions §5](after_four_p2a_promotions_policy_discovery.md#5-candidate-policy-decisions) | Reactivation/lifecycle validation | `CONDITIONALLY_REVIEWABLE` / coordinated |
| `P2A-PROMO-OD-07H` | Assign manual end/expire authority. | Promotions | [Promotions §5](after_four_p2a_promotions_policy_discovery.md#5-candidate-policy-decisions) | Lifecycle and scheduled-expiry policy | `CONDITIONALLY_REVIEWABLE` / coordinated |
| `P2A-PROMO-OD-07I` | Assign published-Promotion correction authority/outcomes. | Promotions | [Promotions §5](after_four_p2a_promotions_policy_discovery.md#5-candidate-policy-decisions) | Version/correction and applied-history policy | `CONDITIONALLY_REVIEWABLE` / coordinated |
| `P2A-PROMO-OD-07J` | Decide emergency intervention and authority. | Promotions | [Promotions §5](after_four_p2a_promotions_policy_discovery.md#5-candidate-policy-decisions) | Escalation/after-action policy | `READY_FOR_OWNER_REVIEW` / independent enable/disable choice |
| `P2A-PROMO-OD-08` | Define eligibility timezone and interval boundary. | Promotions | [Promotions §5](after_four_p2a_promotions_policy_discovery.md#5-candidate-policy-decisions) | Branch/Brand applicability | `READY_FOR_OWNER_REVIEW` / independent direction |

`P2A-PROMO-OD-07` is superseded and is not an active candidate. The ten operation-specific replacements above are counted independently.

### 3.6 Ordering — 1 candidate

| Ref | Concise question | Accountable owner | Source | Dependencies | Readiness / review mode |
|---|---|---|---|---|---|
| `W2-ORD-OD-01` | Define Order calculation sequence and line/amount allocation across Price, Promotions, Loyalty, tax, service charge, and rounding. | Ordering | [Integration register §5.1](after_four_wave_2_cross_domain_integration_decision_register.md#51-ordering-owned-allocation-candidate) | Catalog totals; Loyalty and Promotions policy; P1A deferrals | `DEPENDENCY_BLOCKED` / wait |

`W2-INT-02A`–`02C` remain coordination records, not ballot candidates. The technical follow-up for Workforce events/APIs/DTOs/contracts also remains excluded.

## 4. Decision briefs

Each row is a complete compact brief. “Outside” applies even if the Owner selects an option: no physical or runtime mechanism follows without later review and authorization.

### 4.1 Cash briefs

| Ref | Policy need and why | Supported options / recommendation | Benefits, trade-offs, and deferral | Unresolved / outside boundary | Prerequisites |
|---|---|---|---|---|---|
| `P2B-CASH-OD-01` | Daily float, Expense, and reporting need one business boundary. | Branch timezone/cutoff recommended; calendar day is the supported simpler alternative. | Explicit cutoff handles overnight operations; calendar day is simpler but may split them. Deferral blocks daily closure. | Exact mechanism, jobs, schema, and clocks remain outside. | Reporting and Expense consultation. |
| `P2B-CASH-OD-02` | Shared-drawer operations need individually accountable authority. | Operation-specific Branch-scoped capabilities recommended; generic Staff authority is the alternative. | Specific capabilities strengthen accountability; generic authority is simpler but broad. Deferral leaves operations unauthorized. | Role names, RBAC, endpoints, and Identity implementation remain outside. | Later trusted Identity/authorization. |
| `P2B-CASH-OD-03` | Every nonzero discrepancy needs an approved disposition. | Reason and Owner notification for every discrepancy; a tolerance is the alternative but none is approved. | Zero tolerance maximizes visibility but adds review load. Deferral preserves unresolved discrepancies. | Threshold implementation, accounting entries, and workflow remain outside. | Accounting/Reporting input. |
| `P2B-CASH-OD-04` | Closed evidence needs correction without rewriting history. | Linked correction movements recommended; reopening is the alternative. | Linked correction preserves provenance; reopening is simpler but weakens finality. Deferral leaves external correction. | Ledger/schema/transaction mechanics remain outside. | Reconciliation and audit policy. |
| `P2B-CASH-OD-05` | Refund method determines whether the drawer moves. | Follow approved Payment Refund method/allocation; never infer cash outflow for non-cash Refund. Alternate substitution is possible only if later approved. | Correct method preserves financial truth; substitution improves recovery but adds fraud/accounting risk. | Refund execution and Cash postings remain outside. | Blocked by P1A Refund method/allocation. |
| `P2B-CASH-OD-06` | Handover needs custody evidence distinct from close. | Outgoing/incoming actors, count, variance, reason, acknowledgement recommended; one shared Session is the alternative. | Separate evidence preserves custody; shared Session is simpler but blurs it. | DTO/schema/signature mechanism remains outside. | Coordinate with `CASH-02`. |
| `P2B-CASH-OD-07` | Owner-approved top-ups still need executor/source policy. | Require executor and source evidence; Owner-only execution is the supported stricter alternative. | Delegated execution improves operations but needs boundaries. Deferral leaves top-up execution undefined. | Source taxonomy implementation and accounting postings remain outside. | Accounting input; existing Owner approval is fixed. |
| `P2B-CASH-OD-08` | Authoritative reporting needs closure/reconciliation cadence. | Reconcile every Session and Operating Day; deferred reconciliation is the alternative. | Immediate reconciliation limits drift but can delay close. | Jobs, locks, reports, and recovery implementation remain outside. | `CASH-01`, Reporting, unresolved-case policy. |

### 4.2 Workforce briefs

| Ref | Policy need and why | Supported options / recommendation | Benefits, trade-offs, and deferral | Unresolved / outside boundary | Prerequisites |
|---|---|---|---|---|---|
| `P2B-WF-OD-01` | Employment history needs explicit lifecycle/rehire meaning. | Preserve history with explicit states; reuse prior Employee or create a new employment episode are supported alternatives. | Reuse supports continuity; a new episode clarifies tenure. Deferral blocks deterministic lifecycle. | State machine, schema, and User access automation remain outside. | Identity access coordination. |
| `P2B-WF-OD-02` | Work eligibility needs accountable, effective-dated Branch Assignment. | Scoped authority with dates/reason recommended; informal assignment is the alternative. | Formal assignment protects payroll provenance; informal handling is flexible but weak. | Authorization grants and persistence remain outside. | Organization/Branch facts. |
| `P2B-WF-OD-03` | Shift publication/change requires accountable authority. | Separate draft from publication and preserve changes; manager-only or bounded delegation are supported alternatives. | Delegation improves speed but needs scope. | Scheduling UI, RBAC, schema, and notifications remain outside. | Branch eligibility. |
| `P2B-WF-OD-04` | A swap changes two Employees’ obligations. | Employee acceptance plus authorized Branch decision recommended; direct swap is the alternative. | Direct swaps reduce administration but risk eligibility/accountability. | Workflow/notification/transaction design remains outside. | Shift and assignment facts. |
| `P2B-WF-OD-05` | Attendance truth requires trusted source and correction policy. | Trusted time/device evidence plus reasoned correction; self-entry is the alternative. | Self-entry is convenient but raises fraud/legal risk. | Device choice, geolocation, schema, and enforcement remain outside. | Qualified legal/employment and device input. |
| `P2B-WF-OD-06A` | Break entitlement and evidence affect time/pay. | No defensible substantive recommendation until qualified input; informal recording is the visible alternative. | Premature choice risks wage/timekeeping error. | Entitlement values and technical recording remain unresolved/outside. | Employment/legal and Payroll input. `RECOMMENDATION_NOT_ESTABLISHED`. |
| `P2B-WF-OD-06B` | Grace changes classification of attendance events. | Keep disabled until purpose/duration/scope are supported; configured grace is the alternative. | Grace reduces noise but may hide facts. | Exact limits and calculation remain unresolved/outside. | Employment/legal input. |
| `P2B-WF-OD-06C` | Rounding changes paid/reported time. | Preserve raw facts and defer rule selection; rounding is the alternative only after qualified review. | Rounding simplifies calculation but can systematically distort time. | Formula, precision, and implementation remain outside. | Employment/legal and Payroll input. |
| `P2B-WF-OD-06D` | Lateness needs categories, evidence, and consequences. | No substantive consequence recommended before qualified input; automatic threshold is an alternative. | Automation is simple but may mishandle legitimate exceptions. | Thresholds, remedies, and enforcement remain unresolved/outside. | Shift facts; employment/legal and Payroll/Reporting input. `RECOMMENDATION_NOT_ESTABLISHED`. |
| `P2B-WF-OD-06E` | Absence must be distinguished from leave and exceptions. | No substantive consequence recommended before qualified input; one missed-Shift rule is an alternative. | A generic rule is simple but misclassifies leave/exceptions. | Categories and consequences remain unresolved/outside. | Leave outcome; employment/legal and Payroll input. `RECOMMENDATION_NOT_ESTABLISHED`. |
| `P2B-WF-OD-07A` | Leave needs categories, entitlement, balance, approval, and correction. | No policy option is sufficiently supported beyond separate legal review. | Guessing may create legal/operational error; deferral preserves uncertainty. | Categories, amounts, workflow, schema, and calculations remain unresolved/outside. | Employment/legal and Payroll input. `RECOMMENDATION_NOT_ESTABLISHED`. |
| `P2B-WF-OD-07B` | Overtime needs eligibility, prior authority, facts, rates, and correction. | No rate or substantive eligibility recommendation before qualified input. | Premature approval risks cost/compliance error. | Rates, formulas, exceptions, and mechanisms remain unresolved/outside. | Employment/legal, accounting, and Payroll input. `RECOMMENDATION_NOT_ESTABLISHED`. |
| `P2B-WF-OD-08A` | Consumer domains need a lawful minimum fact/purpose boundary. | Explicit minimum facts/purposes recommended; broad sharing is the alternative. | Minimum disclosure limits privacy and authority leakage; broad sharing is convenient but coupled. | Events, APIs, DTOs, contracts, delivery, and adapters are technical follow-up. | Privacy/retention and consumer-domain purpose input. |

### 4.3 Inventory briefs

| Ref | Policy need and why | Supported options / recommendation | Benefits, trade-offs, and deferral | Unresolved / outside boundary | Prerequisites |
|---|---|---|---|---|---|
| `P2B-INV-OD-01` | Physical accountability requires named stock locations/owners. | Start with Branch-owned locations; central/shared locations are the later alternative. | Branch scope is bounded; implicit stock is simpler but weak. | Physical topology/schema remain outside. | Organization/Branch facts. |
| `P2B-INV-OD-02` | Availability and reconciliation need a negative-stock rule. | Prohibit by default with controlled exception; silent negative posting is the alternative. | Prohibition exposes shortage; allowance aids continuity but hides drift. | Constraint/lock/recovery implementation remains outside. | Operations/reconciliation input. |
| `P2B-INV-OD-03` | Food safety/traceability may require lots and FEFO. | Decide by item class; universal lots or no lots are alternatives. | Universal tracking costs effort; omission weakens traceability. | Item classes and physical design remain unresolved/outside. | Food-safety and Catalog item input. |
| `P2B-INV-OD-04A` | Stock availability needs a normal-consumption recognition point. | Start, completion, or another authoritative Preparation fact are supported; no trigger is selected. | Earlier recognition improves availability truth but complicates recovery; later recognition delays movement. | Events, postings, transactions, and deductions remain outside. | Preparation/Recipe inputs. `RECOMMENDATION_NOT_ESTABLISHED` for exact point. |
| `P2B-INV-OD-04B` | Waste/remake/failure must not disappear into normal consumption. | Separate reasoned deviation facts recommended; treating all as normal is the alternative. | Separation improves loss/reconciliation evidence but adds operational recording. | Taxonomy, authority thresholds, and postings remain outside. | Preparation deviation and operations input. |
| `P2B-INV-OD-05` | Transfers need custody and discrepancy outcomes. | Separate dispatch/receipt with explicit resolution; single-step transfer is the alternative. | Separate facts preserve in-transit custody; single-step is simpler but erases it. | Workflow/schema/transaction design remains outside. | Location/custody policy. |
| `P2B-INV-OD-06` | Counts need variance and adjustment authority. | Reason plus capability-specific approval; Owner-only or automatic tolerance are alternatives. | Delegation improves speed; tolerance may hide loss. | Threshold values and implementation remain outside. | Audit/loss-control consultation. |
| `P2B-INV-OD-07` | Financial reporting needs a costing policy distinct from quantity truth. | Weighted average, FIFO, and standard cost are identified; no recommendation before accounting review. | Methods change COGS and corrections materially. | Formula, historical layers, postings, and schema remain outside. | Qualified accounting input. `RECOMMENDATION_NOT_ESTABLISHED`. |
| `P2B-INV-OD-08` | Recipe and movement quantities need authoritative units/conversions. | Canonical units and versioned conversions recommended; free-form units are the alternative. | Explicit conversions prevent ambiguity but require item/Recipe design. | Precision, conversion values, schema, and rounding mechanism remain outside. | Catalog/Recipe quantity model. |

### 4.4 Loyalty briefs

| Ref | Policy need and why | Supported options / recommendation | Benefits, trade-offs, and deferral | Unresolved / outside boundary | Prerequisites |
|---|---|---|---|---|---|
| `P2A-LOY-OD-01` | Ledger accrual needs an authoritative trigger/value. | Successfully settled eligible value recommended; confirmation-time or settlement-time are supported alternatives. | Settlement is financially safer but needs durable integration; confirmation is faster but precedes funding. | Formula, rate, rounding, events, and schema remain outside. | Ordering/Payment truth and total components. |
| `P2A-LOY-OD-02` | Redemption needs deterministic limits/order/rounding. | Approve minimum/unit/maximum and rounding; flexible redemption is the alternative. | Flexibility improves UX but complicates allocation/recovery. | Exact values and implementation remain unresolved/outside. | Ordering sequence and Promotions interaction. |
| `P2A-LOY-OD-03` | Expiration affects Customer value and liability. | Keep disabled until complete policy; expiry is the alternative. | No expiry is simple/fair; expiry limits liability but adds notice, lot, timezone, and support complexity. | Exact period/notice/legal obligations and mechanisms remain outside. | Legal/notice/timezone consultation. |
| `P2A-LOY-OD-04` | Required manual adjustment needs authority. | Separate requester/approver for material changes; Owner-only or bounded delegation are alternatives. | Owner-only is safe/slow; delegation improves operations but needs thresholds. | Thresholds, emergency path, RBAC, and audit implementation remain outside. | Identity/audit later. |
| `P2A-LOY-OD-05` | Refund/cancellation must allocate reversals deterministically. | Proportional, line-based, and points-first are known alternatives; source recommends deferral. | Each yields different balances/accounting. | Exact allocation and automation remain unresolved/outside. | P1A Refund allocation/cancellation. `RECOMMENDATION_NOT_ESTABLISHED` pending dependency. |
| `P2A-LOY-OD-06` | Shared-Branch direction needs exact Brand/Organization boundary. | Preserve shared Branch scope and deny cross-Brand inference; Brand-level or Organization-wide are alternatives. | Organization-wide improves portability but increases identity/privacy governance. | Cross-Brand sharing and technical scope enforcement remain outside. | `SDP-SCOPE-01`. |
| `P2A-LOY-OD-07` | Preserve/freeze policy needs a bounded exceptional path, if any. | Default preserve/freeze with separately authorized evidenced adjustment; extinguishment/transfer conflict with current policy. | Strict freeze protects identity/value history but may require controlled exceptions. | Exact exceptions, authority, and implementation remain unresolved/outside. | Existing anonymization policy is fixed. |

### 4.5 Promotions briefs

| Ref | Policy need and why | Supported options / recommendation | Benefits, trade-offs, and deferral | Unresolved / outside boundary | Prerequisites |
|---|---|---|---|---|---|
| `P2A-PROMO-OD-01` | A bounded first scope is needed before rule design. | Select a small explicit type set; general expressions are the alternative. | Bounded types reduce risk; expressions maximize flexibility but amplify validation/support. | Actual types and all technical design remain unresolved/outside. | Product/operating input. |
| `P2A-PROMO-OD-02` | Every Promotion needs authoritative applicability. | Explicit Brand/Branch/channel/Catalog scope and cross-Brand deny; Organization-wide is the alternative. | Explicit scope is safe; Organization-wide simplifies campaigns but conflicts with unresolved semantics. | Exact scopes and enforcement remain unresolved/outside. | Catalog and `SDP-SCOPE-01`. |
| `P2A-PROMO-OD-03` | Multiple eligible Promotions need deterministic outcome. | Explicit groups/priority and no implicit stack-all; best-price is the alternative. | Priority is predictable; best-price helps customers but adds complexity/campaign conflict. | Values, algorithm, and runtime remain outside. | Ordering sequence and Loyalty coordination. |
| `P2A-PROMO-OD-04` | Benefits need lifecycle points that avoid silent consumption. | Separate reservation from redemption with explicit release/reversal; settlement-only is the alternative. | Separation supports scarce benefits but adds recovery; settlement-only is simpler. | Exact timing and mechanisms remain unresolved/outside. | Order/Payment lifecycle and supported benefit types. |
| `P2A-PROMO-OD-05` | Refund/cancellation needs discount allocation. | Line-proportional, rule-attributed, and item-first are alternatives; defer selection. | Each changes Refund/reporting results. | Allocation and automation remain unresolved/outside. | P1A and Price/tax/rounding. `RECOMMENDATION_NOT_ESTABLISHED` pending dependency. |
| `P2A-PROMO-OD-06` | Voucher capability needs explicit issuance/use/transfer policy. | Treat as optional separate capability; bearer or identity-bound are alternatives. | Bearer is simple but leak/fraud prone; bound use raises privacy/verification duties. | Whether Voucher is included and its limits remain unresolved; mechanisms outside. | Customer/privacy/fraud input. |
| `P2A-PROMO-OD-07A` | Draft creation needs bounded preparation authority. | Scoped preparation capability; Owner-only drafting is the alternative. | Delegation improves speed but must not imply approval/publication. | Exact scope/escalation and RBAC remain outside. | Promotion scope model. |
| `P2A-PROMO-OD-07B` | Editing can bypass review unless states/authority are explicit. | Separate edit authority; broad edit is the alternative. | Separation protects review; broad authority is flexible. | Permitted states/fields and implementation remain unresolved/outside. | Lifecycle-state policy. |
| `P2A-PROMO-OD-07C` | Approval workflow may need a submission boundary. | Adopt scoped submitter/requester separation if approval is required; direct approval is the alternative. | Submission improves separation but adds workflow. | Whether submission exists and rejection/withdrawal remain unresolved/outside. | Approval workflow choice. |
| `P2A-PROMO-OD-07D` | Approval is sensitive and must not follow from title/draft authority. | Exact scoped approval capability; Owner-only or explicit delegation are alternatives. | Owner-only is safe/slow; delegation needs evidence/scope. | Delegation/RBAC and escalation remain outside. | Scope policy. |
| `P2A-PROMO-OD-07E` | Publication changes customer-visible commercial behavior. | Separate publication from draft/approval; combined approve/publish is the alternative. | Separation strengthens control but adds steps. | Lifecycle/effective-time and runtime remain unresolved/outside. | Approval and lifecycle policy. |
| `P2A-PROMO-OD-07F` | Pause needs bounded urgent authority. | Separate scoped pause with reason/evidence; broad emergency pause is the alternative. | Broad authority limits harm quickly but raises misuse risk. | Branch/Brand reach and escalation remain unresolved/outside. | Lifecycle/escalation policy. |
| `P2A-PROMO-OD-07G` | Resume must not inherit pause authority automatically. | Separate resume with current-policy revalidation; automatic resume is the alternative. | Revalidation prevents stale restoration but adds review. | Reactivation guards and runtime remain unresolved/outside. | Lifecycle validation. |
| `P2A-PROMO-OD-07H` | Manual termination differs from scheduled expiry. | Separate manual end authority; automatic-only expiry is the alternative. | Manual control handles exceptions; automatic-only is predictable. | Scope, reason, correction path, and mechanism remain unresolved/outside. | Lifecycle/expiry policy. |
| `P2A-PROMO-OD-07I` | Published corrections must preserve applied history. | Prospective replacement/linking recommended; in-place edit is the alternative. | Linking protects provenance; in-place edit is easier but unsafe historically. | Materiality, approval/escalation, version mechanism remain unresolved/outside. | Correction and applied-history policy. |
| `P2A-PROMO-OD-07J` | Emergency intervention is a powerful optional bypass. | Disabled by default until bounded authority/review; enabled emergency path is the alternative. | Disabled is safer; enabled path can limit harm but risks abuse. | Exact triggers, reviewer, and implementation remain unresolved/outside. | Escalation/after-action policy. |
| `P2A-PROMO-OD-08` | Scheduled eligibility needs deterministic time semantics. | Explicit business timezone and interval convention; Branch-local time is the alternative. | One timezone is simpler; Branch-local supports geography but complicates shared campaigns. | Exact timezone/bounds and implementation remain unresolved/outside. | Applicability scope. |

### 4.6 Ordering brief

| Ref | Policy need and why | Supported options / recommendation | Benefits, trade-offs, and deferral | Unresolved / outside boundary | Prerequisites |
|---|---|---|---|---|---|
| `W2-ORD-OD-01` | Authoritative totals require an Order-owned sequence/allocation across independent component policies. | Preserve deterministic sequence and component provenance; no exact sequence is supportable yet. Different sequences are alternatives once inputs close. | A selected sequence enables stable totals/refunds/reporting; premature selection overrides domain inputs. | Exact order, allocation, algorithms, schema, and orchestration remain unresolved/outside. | Catalog totals; Loyalty/Promotions policy; P1A deferrals. `RECOMMENDATION_NOT_ESTABLISHED` for exact sequence. |

## 5. Proposed domain review sequence

| Sequence | Group | Why here | Review now | Defer / required input |
|---:|---|---|---|---|
| 1 | Cash | Strongest Owner-confirmed operating baseline; most questions are independently bounded. | `CASH-01`–`04`, `06`–`08` | `CASH-05`: P1A Refund method/allocation |
| 2 | Workforce | Foundational employment/assignment decisions can close while qualified policy is gathered. | `WF-01`–`04`; directional review of `05`, `08A` | `06A`–`07B`: employment/legal/Payroll; final `05`/`08A` needs named input |
| 3 | Inventory | Location, shortage, custody, and count policy can precede technical design. | `INV-01`, `02`, `05`, `06`; directional `03`, `04A/B`, `08` | `INV-07`: accounting; other conditional items need food-safety/Preparation/Recipe |
| 4 | Loyalty | Anonymization and MVP boundaries are fixed, while calculation depends on commercial inputs. | `LOY-03`, `04`, `07`; directional `01`, `02`, `06` | `LOY-05`: P1A; calculation inputs for conditional rows |
| 5 | Promotions | MVP priority is fixed, but commercial and lifecycle choices need coordination. | `PROMO-01`, `06`, `07A`–`07D`, `07J`, `08`; directional remaining conditional rows | `PROMO-05`: P1A/total components |
| 6 | Ordering | It must integrate approved component policies without owning them. | None for exact sequence yet | `W2-ORD-OD-01`: Catalog, Loyalty, Promotions, and P1A inputs |

This sequence is a review recommendation only. It does not transfer ownership, bypass prerequisites, or authorize work.

## 6. Cross-domain dependency map

| Producer / authority | Consumer candidates | Constraint |
|---|---|---|
| Ordering and Payment truth | Loyalty `01`, `05`; Promotions `04`, `05`; Cash `05` | Consumers cannot rewrite Order/Payment facts. Split tender, cancellation consequences, completed exceptions, Order closure, and later Customer association retain their P1A deferrals. |
| Catalog Price/total components | Loyalty `01`–`02`; Promotions `02`–`05`; Ordering `W2-ORD-OD-01` | Tax, service charge, rounding, zero/free items, and detailed Price publication remain unresolved. |
| Customer policy | Loyalty `06`–`07`; Promotions `02`, `06` | Preserve/freeze, no transfer/restoration/re-identification, controlled scope, and cross-Brand default deny remain fixed. |
| Preparation/Recipe | Inventory `03`, `04A`, `04B`, `08` | Preparation owns work/deviation facts; Inventory owns stock movements/reconciliation; no direct cross-context write is authorized. |
| Food safety/accounting | Inventory `03`, `07`; Cash `03`, `07`, `08` | External qualified input is not presumed received. |
| Workforce/legal/Payroll | Workforce `05`, `06A`–`07B` | No labor-law rule, rate, entitlement, or calculation is invented here. |
| Workforce facts | Workforce `08A`; Cash/operations consumers | Owner policy may approve minimum facts/purposes; events/APIs/DTOs/contracts remain technical follow-up. |
| Loyalty and Promotions | Ordering `W2-ORD-OD-01` | Coordination records `W2-INT-02A`–`02C` preserve independent ownership; they are not ballot items. |

Cash Session remains distinct from Employee Shift and Payment settlement. Branch Assignment never grants authorization. I1 proves only Brand-to-Organization ancestry, not ownership or capability. ADR-0006 remains `Proposed`; Identity Milestone 2B remains unauthorized.

Candidate E Gate A remains `DEFER_GATE_A — NOT_GRANTED`; Gate B proposal preparation remains `NOT_AUTHORIZED`. Logical database design documentation may proceed only within `NW-OR-01`; it does not authorize physical schema, migrations, database creation, persistence, transactions, locks, or runtime behavior.

## 7. Owner decision recording instructions

For each candidate, record one independently attributable response:

| Field | Owner entry |
|---|---|
| Temporary reference | Exact reference from §3; never replace it with an invented `ODB-*` ID. |
| Selection | `APPROVE_RECOMMENDED_OPTION`, `APPROVE_SUPPORTED_ALTERNATIVE`, `DEFER`, `REJECT` where governance permits, or `REQUEST_CLARIFICATION`. |
| Selected option | Required when selecting an alternative; quote or precisely identify the supported option. |
| Conditions / clarification | Owner-supplied only; never inferred by the preparer. |
| Decision date | Owner-supplied. |
| Owner identity | Owner-supplied under existing governance convention. |
| Canonical ODB ID | Remains `ID_PENDING_OWNER_GOVERNANCE` unless separately allocated through the approved ODB procedure. |
| Authorization effect | Business-policy decision only; implementation remains `NOT_GRANTED`. |

Dependency-blocked candidates should normally be `DEFER` or `REQUEST_CLARIFICATION` until the named input exists. This guidance is not a preselected outcome. Rejecting or deferring one candidate does not silently decide another.

## 8. Readiness summary

| Domain | Active | Ready | Conditional | Blocked | Clarification required |
|---|---:|---:|---:|---:|---:|
| Cash | 8 | 7 | 0 | 1 | 0 |
| Workforce | 13 | 4 | 2 | 7 | 0 |
| Inventory | 9 | 4 | 4 | 1 | 0 |
| Loyalty | 7 | 3 | 3 | 1 | 0 |
| Promotions | 17 | 8 | 8 | 1 | 0 |
| Ordering | 1 | 0 | 0 | 1 | 0 |
| **Total** | **55** | **26** | **17** | **12** | **0** |

The counts classify readiness to make the stated business choice, not product priority or implementation maturity. Conditional candidates may receive directional review, but their named prerequisites remain controlling. Blocked candidates must not be made to appear complete through guessed policy.

## 9. Reconciliation and exclusions

- Active inventory: 7 Loyalty, 17 Promotions, 9 Inventory, 8 Cash, 13 Workforce, and 1 Ordering candidate.
- Superseded and excluded: `P2A-PROMO-OD-07`, `P2B-INV-OD-04`, `P2B-WF-OD-06`, `P2B-WF-OD-07`, `P2B-WF-OD-08`, and `W2-INT-02`.
- Coordination-only: `W2-INT-02A`–`02C`.
- Technical follow-up excluded: Workforce events, APIs, DTOs, contracts, adapter placement, and delivery semantics arising after `P2B-WF-OD-08A` policy closure.
- No source inconsistency requiring silent correction was identified while preparing this package. The exact options for several blocked candidates remain deliberately unestablished and are labeled accordingly.

This package records no Owner outcome. All existing Owner decisions, P1 deferrals, Customer policies, ODB governance, Candidate E status, ADR status, Gate status, and implementation/production boundaries remain unchanged.
