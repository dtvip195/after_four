# AFTER FOUR — Wave 2 Consolidated Owner Review Session

**Status:** `PREPARED_FOR_OWNER_REVIEW — NO_NEW_OWNER_DECISIONS`

**Authority:** `NW-OR-01` — documentation and Owner-policy review preparation only

**Canonical ODB allocation:** `NOT_REQUESTED — TEMPORARY_REFERENCES_ONLY`

**Implementation and Gate authorization:** `NOT_GRANTED`

**Date:** 2026-11-23

## 1. Purpose and response protocol

This session presents the 24 `CONDITIONALLY_REVIEWABLE` directions and three clarification requests prepared in the [Flow A Closure Package](after_four_wave_2_flow_a_closure_package.md). The twelve blocked candidates appear only as a non-voting roadmap. The sixteen Wave 2 decisions already recorded in the [Owner Decision Baseline](../architecture/after_four_owner_decision_baseline.md#wave-2-cash-owner-decisions) and [consolidated section](../architecture/after_four_owner_decision_baseline.md#wave-2-consolidated-owner-decisions) are unchanged and are not re-balloted.

For each Conditional ballot select one: `APPROVE_DIRECTION`, `SELECT_ALTERNATIVE`, `DEFER`, or `REQUEST_CLARIFICATION`. For each clarification request select one: `REQUEST_SOURCE_OPTIONS`, `SUPPLY_BOUNDED_OPTIONS`, or `DEFER`. Add Owner-supplied conditions/comments where needed.

`APPROVE_DIRECTION` approves only the bounded direction in that row. It does not resolve listed conditions, change readiness automatically, approve another domain's policy, allocate an `ODB-*` ID, or authorize technical design or implementation. `SELECT_ALTERNATIVE` must identify the exact listed alternative.

## 2. Conditional ballots — Cash (2)

**Source:** [Cash discovery §5](after_four_p2b_cash_domain_discovery.md#5-candidate-owner-decisions).

| Ref / owner | Bounded question | Source-supported options | Recommendation and trade-offs | Approved constraints; unresolved conditions / dependencies | Owner response |
|---|---|---|---|---|---|
| `P2B-CASH-OD-07` / Cash | Who may execute an already Owner-approved top-up? | Owner executes; or explicitly authorized executor with actor/source evidence. | Recommend exact executor capability. Delegation improves operations; Owner-only is safer but slower. | Top-up already requires Owner authorization. Generic Staff/Shift/Assignment is not authority. Permitted fund-source classes and accounting treatment still need accounting input. | Selection: ___; alternative/conditions/comments: ___ |
| `P2B-CASH-OD-08` / Cash | What reconciliation cadence direction applies? | Reconcile each Cash Session and Operating Day before authoritative reporting; or defer reconciliation. | Recommend per-Session plus Operating-Day reconciliation. Deferral speeds closure but increases drift risk. | `ODB-CASH-12` controls the Operating Day direction; `ODB-CASH-14` preserves closed evidence. Unresolved-case disposition, reporting hold/release, escalation, and closure consequences remain open. | Selection: ___; alternative/conditions/comments: ___ |

## 3. Conditional ballots — Workforce (2)

**Source:** [Workforce discovery §5](after_four_p2b_workforce_domain_discovery.md#5-candidate-owner-decisions).

| Ref / owner | Bounded question | Source-supported options | Recommendation and trade-offs | Approved constraints; unresolved conditions / dependencies | Owner response |
|---|---|---|---|---|---|
| `P2B-WF-OD-05` / Workforce | What clock and correction direction applies? | Trusted time/device evidence plus a separate reasoned correction path; or self-entry. | Recommend trusted evidence while preserving original/corrected facts. Self-entry is convenient but raises fraud and legal risk. | Employee/Shift facts stay distinct from authorization. Qualified employment/legal input, device/location rules, missed-punch handling, correction authority, and retention remain open. | Selection: ___; alternative/conditions/comments: ___ |
| `P2B-WF-OD-08A` / Workforce | Which minimum Workforce facts may operational consumers receive, and for which approved purposes? | Explicit minimum facts for approved purposes; or broad sharing. | Recommend minimum-purpose disclosure. Broad sharing simplifies consumers but creates privacy, coupling, and authority leakage. | Employee is not User; Branch Assignment/Shift grants no capability. Exact facts, consumers, purposes, scope, retention/review, privacy input, and technical contracts remain open. | Selection: ___; alternative/conditions/comments: ___ |

## 4. Conditional ballots — Inventory (6)

**Source:** [Inventory discovery §5](after_four_p2b_inventory_domain_discovery.md#5-candidate-owner-decisions).

| Ref / owner | Bounded question | Source-supported options | Recommendation and trade-offs | Approved constraints; unresolved conditions / dependencies | Owner response |
|---|---|---|---|---|---|
| `P2B-INV-OD-03` / Inventory | How is lot, expiry, quarantine, and FEFO applicability chosen? | Per item class; universal lots; or no lots. | Recommend item-class policy after qualified food-safety input. Universal tracking adds effort; omission weakens traceability. | Inventory owns stock truth. Item classes, food-safety requirements, disposition, and exact FEFO behavior remain open. | Selection: ___; alternative/conditions/comments: ___ |
| `P2B-INV-OD-04A` / Inventory | When is normal ingredient consumption recognized? | Preparation start, completion, or another authoritative Preparation fact. | `RECOMMENDATION_NOT_ESTABLISHED`; earlier recognition improves availability but complicates recovery, while later recognition delays movement. | Preparation owns work facts; Inventory owns resulting movement. Preparation facts, approved Recipe inputs, failure recovery, and evidence semantics remain open. | Selection: ___; alternative/conditions/comments: ___ |
| `P2B-INV-OD-04B` / Inventory | Are waste, remake, and failed-Preparation deviations distinct from normal consumption? | Separate deviation facts; or treat every deviation as normal consumption. | Recommend separation with reason, quantity, accountable recorder, separately approved authority, and reconciliation evidence. Conflation hides loss. | Preparation owns deviation facts; Inventory owns movement/reconciliation. Exact classes, recorder/approver, operational taxonomy, and accounting consequences remain open. | Selection: ___; alternative/conditions/comments: ___ |
| `P2B-INV-OD-05` / Inventory | Are dispatch and receipt separate custody facts? | Separate dispatch/receipt with explicit discrepancy resolution; or single-step transfer. | Recommend separation. One-step transfer is simpler but erases in-transit custody. | Branch-owned locations are approved by `P2B-INV-OD-01`. Approval, partial receipt, discrepancy outcomes, loss responsibility, and detailed location policy remain open. | Selection: ___; alternative/conditions/comments: ___ |
| `P2B-INV-OD-06` / Inventory | What stocktake-adjustment authority direction applies? | Reason plus capability-specific approval; Owner-only approval; or automatic tolerance. | Recommend capability-specific evidence. Owner-only is slow; automatic tolerance can hide loss. | Counts do not overwrite history. Thresholds, initiator/approver, recount, rejection, correction, and loss-control input remain open. | Selection: ___; alternative/conditions/comments: ___ |
| `P2B-INV-OD-08` / Inventory | What authoritative unit/conversion direction applies? | Canonical units with explicit versioned conversions; or free-form units. | Recommend canonical/versioned units. Free-form units create irreversible quantity ambiguity. | Catalog/Recipe own definition inputs; Inventory owns quantity truth. Unit set, conversion ownership, version effects, and rounding remain open. | Selection: ___; alternative/conditions/comments: ___ |

## 5. Conditional ballots — Loyalty (4)

**Source:** [Loyalty discovery §5](after_four_p2a_loyalty_policy_discovery.md#5-candidate-policy-decisions).

| Ref / owner | Bounded question | Source-supported options | Recommendation and trade-offs | Approved constraints; unresolved conditions / dependencies | Owner response |
|---|---|---|---|---|---|
| `P2A-LOY-OD-01` / Loyalty | When does value become earnable? | Successful settlement; or confirmation-time earning with later recovery. | Recommend authoritative successfully settled eligible value. It is safer but requires durable Order/Payment facts. | Loyalty owns ledger/value; Order and Payment facts cannot be rewritten. Formula, eligible components, Products/Channels, rounding, and reversal remain open. | Selection: ___; alternative/conditions/comments: ___ |
| `P2A-LOY-OD-02` / Loyalty | Must explicit redemption limits, ordering, and rounding precede enablement? | Require minimum/unit/maximum and deterministic rounding first; or flexible redemption. | Recommend complete bounded rules before redemption. Flexibility improves UX but increases allocation/recovery complexity. | Redemption cannot infer Customer authority. Exact limits, points-to-value rate, calculation order, Promotion interaction, and recovery remain open. | Selection: ___; alternative/conditions/comments: ___ |
| `P2A-LOY-OD-04` / Loyalty | What manual-adjustment separation direction applies? | Owner-only; or bounded requester/approver capabilities with thresholds; emergency handling remains separate. | Source recommends separation for material adjustments without self-approval, but this remains proposed. Owner-only is safer/slower; delegation needs scope. | Manual adjustment must be authorized/auditable. Materiality, thresholds, self-approval boundary, emergencies, evidence, and Identity/audit implementation remain open. | Selection: ___; alternative/conditions/comments: ___ |
| `P2A-LOY-OD-06` / Loyalty | What sharing boundary applies within the current operating assumption? | Preserve shared-across-Branches behavior within the initial one-Organization/one-Brand assumption; cross-Brand remains default-denied and unavailable. | `SDP-SCOPE-01` Option D controls. Any Organization-wide cross-Brand sharing is a future amendment requiring a separate Owner decision, not a current alternative. | Balance ownership and precise within-current-scope Branch behavior remain open. Future Brand participation, migration, identity/privacy, and cross-Brand policy are outside this ballot. | Selection: ___; conditions/comments: ___ |

## 6. Conditional ballots — Promotions (10)

**Source:** [Promotions discovery §5](after_four_p2a_promotions_policy_discovery.md#5-candidate-policy-decisions).

| Ref / owner | Bounded question | Source-supported options | Recommendation and trade-offs | Approved constraints; unresolved conditions / dependencies | Owner response |
|---|---|---|---|---|---|
| `P2A-PROMO-OD-02` / Promotions | What applicability must be declared within the current operating assumption? | Explicit Brand/Branch/channel/Catalog applicability within one Organization/one Brand; cross-Brand remains unavailable. | Recommend explicit scope/default deny. Any Organization-wide cross-Brand campaign is a future `SDP-SCOPE-01` amendment, not a current alternative. | Promotions owns applicability but not Customer identity or Catalog facts. Exact current-scope combinations and public/customer-specific behavior remain open. | Selection: ___; conditions/comments: ___ |
| `P2A-PROMO-OD-03` / Promotions | What stacking direction applies? | Explicit stacking/exclusion groups with deterministic priority; best-price; or implicit stack-all. | Recommend explicit groups/priority. Best-price is complex; stack-all risks campaign conflict. | Promotions owns stacking; Ordering owns totals/sequence and Loyalty owns value. Tie-breaking, caps/floors, allocation, and coordination remain open. | Selection: ___; alternative/conditions/comments: ___ |
| `P2A-PROMO-OD-04` / Promotions | Are reservation and successful redemption distinct? | Separate reserve/redeem/release/reverse; or settlement-only redemption. | Recommend distinct outcomes where scarce benefits need reservation. Settlement-only simplifies recovery but may not support scarcity. | Failed/abandoned Orders must not silently consume benefits. Benefit types, timing, expiry, failure outcomes, quantities, and Order/Payment facts remain open. | Selection: ___; alternative/conditions/comments: ___ |
| `P2A-PROMO-OD-07B` / Promotions | Is edit authority separate from create, approve, and publish? | Separate edit capability with changed-field evidence; or broad edit authority. | Recommend separation. Broad editing is flexible but can bypass review intent. | `P2A-PROMO-OD-07A/C/D` remain distinct approved directions. Editable states/fields, lifecycle, scope, escalation, and prohibited changes remain open. | Selection: ___; alternative/conditions/comments: ___ |
| `P2A-PROMO-OD-07E` / Promotions | Is publish/activate authority separate? | Separate publication; or combined approve-and-publish. | Recommend separate scope/effective-time authority. Combination is simpler but weakens control. | Submission and approval do not publish. Lifecycle, scheduled publication, failure handling, assignees, and evidence remain open. | Selection: ___; alternative/conditions/comments: ___ |
| `P2A-PROMO-OD-07F` / Promotions | What pause/suspend authority direction applies? | Separate scoped pause with reason/evidence; or broad emergency pause. | Recommend separate capability. Broad reach responds faster but increases misuse risk. | Emergency intervention remains disabled under `P2A-PROMO-OD-07J`. Brand/Branch reach, triggers, escalation, consequences, and lifecycle remain open. | Selection: ___; alternative/conditions/comments: ___ |
| `P2A-PROMO-OD-07G` / Promotions | What resume/reactivate direction applies? | Separate resume with current-policy revalidation; or automatic resume. | Recommend revalidation. Automatic resume may restore stale or unsafe rules. | Resume authority does not follow from pause authority. Guards, separation, effective time, rejection, and lifecycle remain open. | Selection: ___; alternative/conditions/comments: ___ |
| `P2A-PROMO-OD-07H` / Promotions | What manual-end direction applies? | Separate manual-end authority; or scheduled expiry only. | Recommend distinct manual authority with evidence. Automatic-only is predictable but cannot address exceptions. | Manual end differs from scheduled expiry. Scope, reason, effective time, correction path, lifecycle, and expiry policy remain open. | Selection: ___; alternative/conditions/comments: ___ |
| `P2A-PROMO-OD-07I` / Promotions | How are published corrections treated semantically? | Prospective replacement/linking; or in-place edit. | Recommend prospective linked correction preserving applied history. In-place editing is easier but undermines provenance. | Applied outcomes and history must not be silently rewritten. Materiality, separation, prospective reach, Customer treatment, and escalation remain open. | Selection: ___; alternative/conditions/comments: ___ |
| `P2A-PROMO-OD-08` / Promotions | What eligibility-time convention applies? | One explicit business timezone or Branch-local time; independently select inclusive/exclusive start and end. | `RECOMMENDATION_NOT_ESTABLISHED`; campaign applicability determines the trade-off. | Exact applicability scope, timezone, interval combination, exceptional days, and operating input remain open. No clock/scheduling mechanism is selected. | Selection: ___; alternative/conditions/comments: ___ |

Directional approval of any row above leaves its conditions unresolved and retains `CONDITIONALLY_REVIEWABLE` until a later evidence-based reassessment.

## 7. Clarification requests (3)

| Ref / owner | Why no policy selection is defensible | Minimum missing information and evidence owner | Owner clarification response |
|---|---|---|---|
| `P2B-CASH-OD-03` / Cash | [Cash §5](after_four_p2b_cash_domain_discovery.md#5-candidate-owner-decisions) recommends reason and Owner notification but provides no correction-authority or resolution/evidence options. `ODB-CASH-14` prevents rewriting closed evidence but does not decide discrepancy treatment. | Cash with accounting/Reporting input: discrepancy classes; escalation/notification; linked-correction initiator/approver choices; evidence and reconciliation/reporting outcomes. | `REQUEST_SOURCE_OPTIONS` / `SUPPLY_BOUNDED_OPTIONS` / `DEFER`; supplied options/comments: ___ |
| `P2A-PROMO-OD-01` / Promotions | [Promotions §5](after_four_p2a_promotions_policy_discovery.md#5-candidate-policy-decisions) mentions fixed, percentage, bundle, and free-item only as exploratory concepts; it establishes no complete bounded type set. General expressions are a separate broader alternative. | Promotions: supply or research a bounded candidate type set and keep general expressions separately reviewable. Do not infer a subset. | `REQUEST_SOURCE_OPTIONS` / `SUPPLY_BOUNDED_OPTIONS` / `DEFER`; supplied options/comments: ___ |
| `P2A-PROMO-OD-06` / Promotions | [Promotions §5](after_four_p2a_promotions_policy_discovery.md#5-candidate-policy-decisions) exposes bearer/bound trade-offs but lacks complete issuance, reuse, transfer, limit, fraud, privacy, and recovery choices. | Promotions with Customer/privacy and fraud-policy input: issuance authority; bearer/bound eligibility; reuse/transfer; quantity/time limits; loss/compromise/recovery. | `REQUEST_SOURCE_OPTIONS` / `SUPPLY_BOUNDED_OPTIONS` / `DEFER`; supplied options/comments: ___ |

These responses prepare later ballots; they are not policy approvals.

## 8. NON_VOTING — DEPENDENCY_BLOCKED (12)

| Ref / owner | Upstream dependency and accountable owner | Minimum outcome required | Order / parallel work |
|---|---|---|---|
| `P2B-CASH-OD-05` / Cash | Payment-owned Refund method/allocation | Approved method-specific Refund outcome and rule for Cash outflow | Cash evidence needs may be prepared; decide after Payment policy. |
| `P2B-WF-OD-06A` / Workforce | Qualified employment/legal and Payroll | Break entitlement, timing, recording, interruption/missed-break, correction obligations | Parallel qualified review with attendance facts. |
| `P2B-WF-OD-06B` / Workforce | Qualified employment/legal and attendance definitions | Permitted grace purpose, duration, events, scope, and consequences | Research beside `06A/06C`; separate later ballot. |
| `P2B-WF-OD-06C` / Workforce | Qualified employment/legal and Payroll | Whether rounding is permitted and its constraints while raw facts remain preserved | Parallel review; precedes calculation design. |
| `P2B-WF-OD-06D` / Workforce | Shift/attendance, qualified legal, Payroll/Reporting | Lateness classes, thresholds, excused outcomes, evidence, review, consequences | After attendance semantics; separate from absence. |
| `P2B-WF-OD-06E` / Workforce | Leave outcome, qualified legal, Payroll/Reporting | Absence classes, evidence, review/correction, consequences | After `07A` supplies leave distinctions. |
| `P2B-WF-OD-07A` / Workforce | Qualified employment/legal and Payroll | Leave categories, entitlement/balance, workflow, evidence, effective dates, correction | Qualified work may proceed beside `06A`–`06C`; precedes `06E`. |
| `P2B-WF-OD-07B` / Workforce | Qualified employment/legal, accounting, Payroll | Overtime eligibility, prior authority, evidence, rate/calculation, exceptions, correction | Independent qualified stream; no rate may be guessed. |
| `P2B-INV-OD-07` / Inventory | Qualified accounting | Valuation objective/method and correction treatment, separate from quantity truth | Quantity work may proceed; valuation ballot waits. |
| `P2A-LOY-OD-05` / Loyalty | Payment/Ordering P1A Refund allocation and cancellation outcomes | Authoritative partial Refund/cancellation allocation facts | Alternatives may be documented; proportionality cannot be selected. |
| `P2A-PROMO-OD-05` / Promotions | Payment/Ordering P1A plus Catalog Price/tax/service-charge/rounding | Authoritative discount-allocation inputs and Refund/cancellation outcomes | Coordinate with Loyalty/Ordering without transferring ownership. |
| `W2-ORD-OD-01` / Ordering | Catalog totals, Loyalty `01/02/05`, Promotions `03/05`, P1A | Approved participating component policies sufficient to compare sequences | Process last; `W2-INT-02A`–`02C` coordination may proceed in parallel. |

No Owner response is requested for §8 in this session.

## 9. Cross-domain controls

- Payment owns Refund outcome/method; Cash owns drawer movement. Neither substitutes for the other.
- Workforce owns Employee/Shift facts; those facts never grant Cash or other capabilities.
- Preparation owns work/deviation facts; Inventory owns stock movement and reconciliation.
- Loyalty owns Loyalty value; Customer owns Profile and anonymization.
- Promotions owns Promotion policy; Customer and Loyalty retain identity/value rules.
- Organization/Brand/Branch ancestry supplies reference facts, not ownership or authorization proof.
- `SDP-SCOPE-01` Option D retains the initial one-Organization/one-Brand assumption and default-denies implicit cross-Brand discovery, visibility, Loyalty sharing, and Promotion applicability.
- `ODB-CASH-12` through `ODB-CASH-15` and the other twelve approved Wave 2 outcomes remain unchanged.

## 10. Session reconciliation and governance boundary

| Status | Count | Session treatment |
|---|---:|---|
| `OWNER_DECIDED` | 16 | Preserved; not presented for selection. |
| `CONDITIONALLY_REVIEWABLE` | 24 | Independent directional ballots in §§2–6. |
| `CLARIFICATION_REQUIRED` | 3 | Clarification responses in §7; no approval ballot. |
| `DEPENDENCY_BLOCKED` | 12 | Non-voting roadmap in §8. |
| **Total** | **55** | One-to-one inventory preserved. |

This document records no decision and allocates or reserves no canonical ID. It authorizes no Flow B technical design, physical database design, schema, migration, database creation, transaction/lock/isolation choice, source code, tests, dependencies, API, UI, Identity implementation, runtime grant, deployment, Gate A/B/C, Control Acceptance, FOA, or Production Authorization.
