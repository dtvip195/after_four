# AFTER FOUR — Wave 2 Flow A Closure Package

**Status:** `OWNER_CLOSURE_DOCKET_PREPARED — NO_NEW_OWNER_DECISIONS`

**Authority:** `NW-OR-01` — documentation and policy-decision preparation only

**Canonical ODB allocation:** `NOT_REQUESTED — TEMPORARY_REFERENCES_ONLY`

**Implementation and Gate authorization:** `NOT_GRANTED`

**Date:** 2026-11-23

## 1. Purpose and controlling baseline

This package reconciles the 39 Wave 2 candidates not decided in the consolidated Owner session and prepares the smallest source-grounded next review surfaces. It does not reopen the sixteen decisions recorded in the [Owner Decision Baseline](../architecture/after_four_owner_decision_baseline.md#wave-2-cash-owner-decisions) and [Wave 2 consolidated decisions](../architecture/after_four_owner_decision_baseline.md#wave-2-consolidated-owner-decisions).

Controlling evidence is the [Wave 2 Owner Review Package](after_four_wave_2_owner_review_package.md), [cross-domain register](after_four_wave_2_cross_domain_integration_decision_register.md), the Cash, Workforce, Inventory, Loyalty, and Promotions discovery annexes, the Owner Decision Baseline, [ADR-0011](../architecture/adr/0011-project-wide-layered-ddd.md), and the repository glossary. Recommendations remain `PROPOSED_NOT_APPROVED`; temporary references are not canonical IDs.

The Owner Review Package §2 contains a stale sentence saying no candidate is `CLARIFICATION_REQUIRED`. Its candidate index and §8 arithmetic establish three such candidates. This package uses the verified index: 24 Conditional, 12 Dependency-blocked, and 3 Clarification-required.

## 2. Authoritative remaining-candidate inventory

| Domain | Conditional | Dependency-blocked | Clarification | Remaining | Already decided | Active total |
|---|---:|---:|---:|---:|---:|---:|
| Cash | 2 | 1 | 1 | 4 | 4 | 8 |
| Workforce | 2 | 7 | 0 | 9 | 4 | 13 |
| Inventory | 6 | 1 | 0 | 7 | 2 | 9 |
| Loyalty | 4 | 1 | 0 | 5 | 2 | 7 |
| Promotions | 10 | 1 | 2 | 13 | 4 | 17 |
| Ordering | 0 | 1 | 0 | 1 | 0 | 1 |
| **Total** | **24** | **12** | **3** | **39** | **16** | **55** |

### 2.1 Exact inventory and dependency classification

| Ref | Owner | Current class | Source | Approved constraints / exact missing input |
|---|---|---|---|---|
| `P2B-CASH-OD-03` | Cash | `CLARIFICATION_REQUIRED` | [Cash §5](after_four_p2b_cash_domain_discovery.md#5-candidate-owner-decisions) | Closed evidence remains immutable under `ODB-CASH-14`; correction-authority and evidence options are absent. |
| `P2B-CASH-OD-05` | Cash | `DEPENDENCY_BLOCKED` | [Cash §5](after_four_p2b_cash_domain_discovery.md#5-candidate-owner-decisions) | Needs approved Payment Refund method/allocation policy; non-cash Refund never implies drawer outflow. |
| `P2B-CASH-OD-07`, `08` | Cash | `CONDITIONALLY_REVIEWABLE` | [Cash §5](after_four_p2b_cash_domain_discovery.md#5-candidate-owner-decisions) | Top-up executor direction is separable from source classes; reconciliation cadence is separable from unresolved-case outcomes. |
| `P2B-WF-OD-05`, `08A` | Workforce | `CONDITIONALLY_REVIEWABLE` | [Workforce §5](after_four_p2b_workforce_domain_discovery.md#5-candidate-owner-decisions) | Need qualified time/evidence input and privacy/retention plus consumer-purpose input respectively. |
| `P2B-WF-OD-06A`–`06E`, `07A`, `07B` | Workforce | `DEPENDENCY_BLOCKED` | [Workforce §5](after_four_p2b_workforce_domain_discovery.md#5-candidate-owner-decisions) | Qualified employment/legal input is mandatory; Payroll, Reporting, accounting, leave, Shift, and attendance inputs vary by row. |
| `P2B-INV-OD-03`, `04A`, `04B`, `05`, `06`, `08` | Inventory | `CONDITIONALLY_REVIEWABLE` | [Inventory §5](after_four_p2b_inventory_domain_discovery.md#5-candidate-owner-decisions) | Need food-safety/item-class, Preparation/Recipe, operations, custody, loss-control, or Catalog quantity input as named per row. |
| `P2B-INV-OD-07` | Inventory | `DEPENDENCY_BLOCKED` | [Inventory §5](after_four_p2b_inventory_domain_discovery.md#5-candidate-owner-decisions) | Qualified accounting input must precede valuation selection. |
| `P2A-LOY-OD-01`, `02`, `04`, `06` | Loyalty | `CONDITIONALLY_REVIEWABLE` | [Loyalty §5](after_four_p2a_loyalty_policy_discovery.md#5-candidate-policy-decisions) | Need Order/Payment values, Ordering/Promotion sequence, adjustment thresholds/emergency policy, or scope/privacy input. |
| `P2A-LOY-OD-05` | Loyalty | `DEPENDENCY_BLOCKED` | [Loyalty §5](after_four_p2a_loyalty_policy_discovery.md#5-candidate-policy-decisions) | P1A Refund allocation and cancellation consequences remain deferred. |
| `P2A-PROMO-OD-01`, `06` | Promotions | `CLARIFICATION_REQUIRED` | [Promotions §5](after_four_p2a_promotions_policy_discovery.md#5-candidate-policy-decisions) | No bounded initial type-selection set; no complete Voucher issuance/reuse/transfer/limit options. |
| `P2A-PROMO-OD-02`, `03`, `04`, `07B`, `07E`–`07I`, `08` | Promotions | `CONDITIONALLY_REVIEWABLE` | [Promotions §5](after_four_p2a_promotions_policy_discovery.md#5-candidate-policy-decisions) | Need applicability, Ordering/Loyalty sequence, lifecycle, escalation, correction, or operating-time input as named per row. |
| `P2A-PROMO-OD-05` | Promotions | `DEPENDENCY_BLOCKED` | [Promotions §5](after_four_p2a_promotions_policy_discovery.md#5-candidate-policy-decisions) | Needs P1A Refund/cancellation and authoritative Price/tax/service-charge/rounding policy. |
| `W2-ORD-OD-01` | Ordering | `DEPENDENCY_BLOCKED` | [Integration register §5.1](after_four_wave_2_cross_domain_integration_decision_register.md#51-ordering-owned-allocation-candidate) | Needs Catalog total components, Loyalty/Promotion policies, and applicable P1A outcomes. |

## 3. Workstream A — clarification closure

None of the three clarification candidates is ready for a substantive policy selection. The next Owner action is to supply the minimum decision surface; no option below is silently selected.

| Ref | Exact unresolved question | Why no defensible choice exists | Minimum clarification / possible split | Recommendation |
|---|---|---|---|---|
| `P2B-CASH-OD-03` | How are nonzero discrepancies classified, escalated, investigated, and resolved? | The source recommends reason and Owner notification but supplies neither correction-authority alternatives nor evidence/outcome categories. `ODB-CASH-14` prevents reopening closed evidence but does not decide discrepancy resolution. | Separately clarify: (a) discrepancy classes and escalation/notification; (b) who may initiate and approve linked corrections; (c) minimum evidence and reconciliation/reporting outcome. | `RECOMMENDATION_NOT_ESTABLISHED`; obtain Cash plus accounting/Reporting options. |
| `P2A-PROMO-OD-01` | Which Promotion types form the first bounded policy scope? | Fixed, percentage, bundle, and free-item are exploratory concepts, not an approved or complete selection set; general-expression capability is a separate broader alternative. | Owner must provide or approve a bounded candidate type set before type-by-type selection. Keep general expressions separately reviewable and unsupported types rejected. | `RECOMMENDATION_NOT_ESTABLISHED`; do not infer a subset. |
| `P2A-PROMO-OD-06` | What Voucher issuance, reuse, transfer, binding, and usage-limit policy applies? | Sources expose bearer-versus-bound trade-offs but do not define complete issuance, reuse, transfer, limit, fraud, privacy, or recovery choices. | Split only after evidence exists: issuance authority; bearer/bound eligibility; reuse/transfer; quantity/time limits; loss/compromise/recovery. | `RECOMMENDATION_NOT_ESTABLISHED`; obtain Promotions, Customer/privacy, and fraud-policy input. |

### Part A — Owner clarification response

For each row the Owner may select `REQUEST_SOURCE_OPTIONS`, `SUPPLY_BOUNDED_OPTIONS`, or `DEFER`. Supplying options prepares a later ballot; it is not approval of those options and grants no implementation authority.

## 4. Workstream B — conditional closure docket

The following bounded directional ballots preserve every named condition. A directional approval closes only the stated principle; parameters in the last column remain unresolved.

| Ref | Accountable owner and bounded question | Source-supported choices | Recommendation / trade-off | Conditions and unresolved parameters | Owner response |
|---|---|---|---|---|---|
| `P2B-CASH-OD-07` | Cash: who may execute an already Owner-approved top-up? | Owner executes; or explicitly authorized executor with actor/source evidence. | Bounded delegation improves operations; Owner-only is safer/slower. Recommend exact executor capability, not generic Staff. | Permitted fund-source classes and accounting treatment still require accounting input. | `APPROVE_DIRECTION` / `ALTERNATIVE` / `DEFER`: ___ |
| `P2B-CASH-OD-08` | Cash: what reconciliation cadence applies? | Reconcile each Session and Operating Day before authoritative reporting; or defer reconciliation. | Recommend per-Session plus Operating-Day reconciliation; deferral raises drift risk. | Unresolved-case disposition, reporting hold/release, escalation, and closure consequences remain open. | ___ |
| `P2B-WF-OD-05` | Workforce: what clock and correction direction applies? | Trusted time/device evidence plus separate reasoned correction; or self-entry. | Recommend trusted evidence and preserved original/corrected facts; self-entry is convenient but higher fraud/legal risk. | Qualified employment/legal input, device/location rules, correction authority, missed punches, and retention remain open. | ___ |
| `P2B-WF-OD-08A` | Workforce: what may operational consumers receive? | Explicit minimum facts for approved purposes; or broad sharing. | Recommend minimum-purpose disclosure; broad sharing creates privacy and authority leakage. | Exact facts, consumers, purposes, scope, retention/review, and privacy approval remain open; no API/event is approved. | ___ |
| `P2B-INV-OD-03` | Inventory: how is lot/expiry/quarantine/FEFO applicability chosen? | Per item class; universal lots; or no lots. | Recommend item-class policy after food-safety input; universal tracking costs more, omission weakens traceability. | Item classes, qualified food-safety rules, disposition and exact FEFO requirements remain open. | ___ |
| `P2B-INV-OD-04A` | Inventory: when is normal consumption recognized? | Preparation start, completion, or another authoritative Preparation fact. | `RECOMMENDATION_NOT_ESTABLISHED`; earlier truth improves availability but complicates recovery, later truth delays movement. | Preparation facts, approved Recipe inputs, failure recovery, and evidence semantics remain open. | ___ |
| `P2B-INV-OD-04B` | Inventory: are deviations distinct from normal consumption? | Separate waste/remake/failed-Preparation facts; or treat all as normal consumption. | Recommend separation with reason, quantity, recorder, separately approved authority, and reconciliation evidence; conflation hides loss. | Exact classes, recorder/approver, Preparation taxonomy, and accounting consequences remain open. | ___ |
| `P2B-INV-OD-05` | Inventory: are dispatch and receipt separate custody facts? | Separate dispatch/receipt with explicit discrepancy resolution; or single-step transfer. | Recommend separation; one step is simpler but erases in-transit custody. | Approval, partial receipt, discrepancy outcomes, loss responsibility, and location policy remain open. | ___ |
| `P2B-INV-OD-06` | Inventory: what stocktake adjustment authority direction applies? | Reason plus capability-specific approval; Owner-only; or automatic tolerance. | Recommend capability-specific evidence; Owner-only is slow, automatic tolerance may hide loss. | Thresholds, initiator/approver, recount, rejection, correction, and loss-control input remain open. | ___ |
| `P2B-INV-OD-08` | Inventory: what quantity-language direction applies? | Canonical units with explicit versioned conversions; or free-form units. | Recommend canonical/versioned units; free form creates irreversible ambiguity. | Catalog/Recipe item model, unit set, conversion ownership, version effects, and rounding remain open. | ___ |
| `P2A-LOY-OD-01` | Loyalty: when does value become earnable? | Successful settlement; or confirmation-time earning with later recovery. | Recommend authoritative settled eligible value; safer funding truth but requires durable integration. | Formula, eligible components, Products/Channels, rounding, and Refund/cancellation reversal remain open. | ___ |
| `P2A-LOY-OD-02` | Loyalty: must redemption have explicit limits/order/rounding before enablement? | Require minimum/unit/maximum and deterministic rounding first; or flexible redemption. | Recommend complete bounded rules before enablement; flexibility increases allocation/recovery complexity. | Exact limits, points-to-value rate, calculation order, Promotion interaction, and recovery remain open. | ___ |
| `P2A-LOY-OD-04` | Loyalty: what manual-adjustment separation direction applies? | Owner-only; or bounded requester/approver capabilities with thresholds; emergency handling remains separate. | Source recommends separation for material adjustments without self-approval, but that remains proposed. | Materiality, thresholds, self-approval boundary, emergency cases, evidence, and Identity/audit implementation remain open. | ___ |
| `P2A-LOY-OD-06` | Loyalty: what sharing boundary is allowed within the current approved operating assumption? | Preserve shared-across-Branches behavior within the initial one-Organization/one-Brand assumption, with cross-Brand behavior default-denied and unavailable. | `SDP-SCOPE-01` Option D is controlling: multi-Brand semantics remain deferred, so this package cannot select Organization-wide or Brand-scoped Customer identity semantics. Any future Organization-wide cross-Brand Loyalty sharing is a policy amendment requiring a separate Owner decision. | Balance ownership and the precise within-current-scope Branch behavior remain open. Future participating-Brand, migration, identity/privacy, and cross-Brand policy are outside this ballot. | ___ |
| `P2A-PROMO-OD-02` | Promotions: what applicability must be declared within the current approved operating assumption? | Require explicit Brand/Branch/channel/Catalog applicability within the initial one-Organization/one-Brand assumption; cross-Brand Promotion applicability remains default-denied and unavailable. | `SDP-SCOPE-01` Option D is controlling and this package cannot amend it. Any future Organization-wide campaign with cross-Brand applicability requires a separate Owner policy amendment; it is not an ordinary current alternative. | Exact within-current-scope combinations, public/customer-specific behavior, and Catalog facts remain open. Future multi-Brand participation, consent, visibility, benefits, and authorization stay deferred. | ___ |
| `P2A-PROMO-OD-03` | Promotions: what stacking direction applies? | Explicit stacking/exclusion groups and deterministic priority; best-price; or implicit stack-all. | Recommend explicit groups/priority; best-price is complex, stack-all risks campaign conflict. | Ordering sequence, Loyalty coordination, tie-breaking, caps/floors, and allocation remain open. | ___ |
| `P2A-PROMO-OD-04` | Promotions: are reservation and redemption distinct? | Separate reserve/redeem/release/reverse; or settlement-only redemption. | Recommend distinct outcomes where scarce benefits require reservation; settlement-only simplifies recovery. | Benefit types, Order/Payment facts, timing, expiry, failure/abandonment, and quantities remain open. | ___ |
| `P2A-PROMO-OD-07B` | Promotions: is edit authority separate from create/approve/publish? | Separate capability with changed-field evidence; or broad edit authority. | Recommend separation; broad editing can bypass review intent. | Editable states/fields, lifecycle, scope, escalation, and prohibited changes remain open. | ___ |
| `P2A-PROMO-OD-07E` | Promotions: is publish/activate authority separate? | Separate publication; or combined approve-and-publish. | Recommend separate scope/effective-time authority; combination is simpler but weakens control. | Lifecycle, scheduled publication, failure handling, assignees, and evidence remain open. | ___ |
| `P2A-PROMO-OD-07F` | Promotions: what pause authority direction applies? | Separate scoped pause with reason/evidence; or broad emergency pause. | Recommend separate capability; broad reach responds faster but raises misuse risk. | Brand/Branch reach, triggers, escalation, consequences, and lifecycle remain open. | ___ |
| `P2A-PROMO-OD-07G` | Promotions: what resume direction applies? | Separate resume with current-policy revalidation; or automatic resume. | Recommend revalidation; automatic resume may restore stale rules. | Guards, approver/separation, effective time, rejection, and lifecycle remain open. | ___ |
| `P2A-PROMO-OD-07H` | Promotions: what manual-end direction applies? | Separate manual-end authority; or scheduled expiry only. | Recommend distinct manual authority with evidence; automatic-only is predictable but cannot handle exceptions. | Scope, reason, effective time, correction path, lifecycle, and expiry policy remain open. | ___ |
| `P2A-PROMO-OD-07I` | Promotions: how are published corrections represented semantically? | Prospective replacement/linking; or in-place edit. | Recommend prospective linked correction preserving applied history; in-place editing weakens provenance. | Materiality, requester/approver separation, prospective reach, customer treatment, and escalation remain open. | ___ |
| `P2A-PROMO-OD-08` | Promotions: what eligibility-time convention applies? | One approved business timezone or Branch-local time; independently choose inclusive/exclusive start and end. | `RECOMMENDATION_NOT_ESTABLISHED`; trade-offs depend on campaign applicability. | Applicability scope, exact timezone, boundary combination, exceptional days, and operating input remain open. | ___ |

Directional approval does not change the current `CONDITIONALLY_REVIEWABLE` classification until its named conditions are resolved and the complete policy is reviewed.

## 5. Workstream C — dependency roadmap

| Blocked ref | Accountable owner | Exact upstream dependency and owner | Minimum unblocking outcome | Parallel work / processing order |
|---|---|---|---|---|
| `P2B-CASH-OD-05` | Cash | Payment-owned Refund method/allocation; P1A remains incomplete | Approved method-specific Refund outcome and rule for when a Cash outflow exists | Cash can enumerate evidence needs; decide after Payment Refund policy. |
| `P2B-WF-OD-06A` | Workforce | Qualified employment/legal plus Payroll | Break entitlement, timing, recording, interruption/missed-break, correction obligations | Gather qualified review with attendance facts; then ballot independently. |
| `P2B-WF-OD-06B` | Workforce | Qualified employment/legal plus attendance-event definitions | Permitted purpose, duration, events, scope, and consequences of grace | Can research alongside `06A/06C`; separate Owner ballot. |
| `P2B-WF-OD-06C` | Workforce | Qualified employment/legal and Payroll | Whether rounding is permitted and bounded calculation constraints while preserving raw facts | Parallel qualified review; decide before payroll calculation design. |
| `P2B-WF-OD-06D` | Workforce | Shift/attendance facts, qualified legal, Payroll/Reporting | Lateness classes, thresholds, excused outcomes, evidence, review, and consequences | After attendance semantics; coordinate, do not bundle with absence. |
| `P2B-WF-OD-06E` | Workforce | Leave outcome, qualified legal, Payroll/Reporting | Absence categories, evidence, review/correction, and consequences | After `07A` supplies leave distinctions; then independent ballot. |
| `P2B-WF-OD-07A` | Workforce | Qualified employment/legal and Payroll | Leave categories, entitlements/balances, workflow, evidence, dates, correction | Qualified policy work can proceed in parallel with `06A`–`06C`; precedes `06E`. |
| `P2B-WF-OD-07B` | Workforce | Qualified employment/legal, accounting, and Payroll | Overtime eligibility, prior authority, evidence, rate/calculation, exceptions, correction | Independent qualified stream; no rate may be guessed. |
| `P2B-INV-OD-07` | Inventory | Qualified accounting | Approved valuation objective/method and correction treatment, separate from quantity truth | Quantity design can proceed conceptually; valuation ballot waits. |
| `P2A-LOY-OD-05` | Loyalty | Payment/Ordering: P1A Refund allocation and cancellation outcomes | Authoritative partial Refund/cancellation allocation facts | Loyalty may enumerate alternatives but cannot select proportionality. |
| `P2A-PROMO-OD-05` | Promotions | Payment/Ordering P1A plus Catalog Price/tax/service-charge/rounding | Authoritative discount allocation inputs and Refund/cancellation outcomes | Coordinate with Loyalty and Ordering; Promotions retains policy ownership. |
| `W2-ORD-OD-01` | Ordering | Catalog totals, Loyalty `01/02/05`, Promotions `03/05`, and P1A outcomes | Approved participating component policies sufficient to compare exact sequences | Process last; coordination records `W2-INT-02A`–`02C` may advance in parallel. |

Recommended sequence: qualified Workforce and accounting/food-safety inputs in parallel; close Payment Refund/cancellation and Catalog total components; close conditional Loyalty/Promotion policies; then review their reversal/allocation decisions; review the Ordering-owned sequence only after its inputs are authoritative.

## 6. Cross-domain ownership and circularity controls

| Interaction | Accountable decisions | Non-overridable boundary |
|---|---|---|
| Cash ↔ Payment/Refund | Payment owns Refund outcome/method; Cash owns drawer movement | Neither fact substitutes for the other; non-cash Refund never creates Cash movement by inference. |
| Cash ↔ Workforce | Cash owns Cash capabilities; Workforce owns Employee/Shift facts | Branch Assignment and Employee Shift never grant Cash authority. |
| Inventory ↔ Preparation/Ordering | Preparation owns work/deviation facts; Inventory owns stock movement/reconciliation | No direct cross-context write or reconstructed Order/Preparation fact. |
| Loyalty ↔ Customer | Loyalty owns ledger/value; Customer owns Profile/anonymization | Preserve/freeze, no transfer/restoration/re-identification remain fixed. |
| Promotions ↔ Customer/Loyalty | Promotions owns Promotion policy; Customer and Loyalty retain their own identity/value rules | Public and Customer-specific behavior stay distinct; no phone-based identity inference. |
| Workforce ↔ Identity | Workforce owns employment/eligibility; Identity owns authentication/authorization | Employee is not User; no capability follows from assignment. |
| Organization/Brand/Branch scope | Organization supplies authoritative ancestry/reference facts | IDs or ancestry alone do not prove ownership or authorization; cross-Brand remains default-deny. |

There is no policy cycle that authorizes guessing. The commercial chain is deliberately ordered: component owners close their policies, then Ordering selects calculation/allocation sequence. Refund-dependent Cash/Loyalty/Promotion rows wait for Payment/Ordering outcomes. Workforce legal dependencies require qualified input rather than another domain's approval.

## 7. Consolidated Owner docket and response protocol

- **Part A — clarification:** three clarification requests in §3; no substantive option is pre-approved.
- **Part B — conditional:** twenty-four independently attributable directional ballots in §4. Owner may approve the bounded direction, select a listed supported alternative, defer, or request clarification. Conditions remain open after directional approval.
- **Part C — dependency roadmap:** twelve rows in §5 are not immediate approval ballots. Their normal response is defer or request the named upstream work until minimum evidence exists.

Every response must retain the exact temporary reference, Owner-supplied selection/condition/date/identity, and `ID_PENDING_OWNER_GOVERNANCE` unless an exact full ID is separately approved through the canonical allocation procedure. One domain's choice does not approve a linked domain's policy.

## 8. Final readiness assessment

| Classification after preparation | Count | Treatment |
|---|---:|---|
| `OWNER_DECIDED` | 16 | Preserved unchanged; not re-balloted. |
| `CONDITIONALLY_REVIEWABLE` | 24 | Directional ballots prepared; classification unchanged pending conditions. |
| `DEPENDENCY_BLOCKED` | 12 | Roadmap prepared; blockers unchanged. |
| `CLARIFICATION_REQUIRED` | 3 | Minimum clarification requests prepared; no supported selection invented. |
| **Active total** | **55** | One-to-one reconciliation complete. |

No readiness classification changes in this package. The next Owner session may review the 24 bounded directions and the three clarification requests independently. The 12 blocked candidates remain outside an immediate approval ballot.

## 9. Governance boundary and exit

This package records no new Owner decision and allocates or reserves no canonical ID. It authorizes no Flow B technical-design approval, physical database design, schema, migration, database creation, transaction/lock/isolation choice, application code, test, dependency, API, UI, Identity implementation, runtime grant, deployment, Gate A/B/C, Control Acceptance, FOA, or Production Authorization.

The sixteen previously approved Wave 2 decisions remain unchanged. Candidate E Gate A remains `DEFER_GATE_A — NOT_GRANTED`; Candidate E Gate B proposal preparation remains `NOT_AUTHORIZED`. ADR-0011 continues to govern any separately authorized future implementation without turning this documentation package into implementation authority.
