# AFTER FOUR — Wave 2 Remaining Evidence Closure Package

**Status:** `EVIDENCE_CLOSURE_PACKAGE_PREPARED — NO_NEW_OWNER_DECISIONS`

**Authority:** `NW-OR-01` — documentation, research coordination, and evidence planning only

**Canonical ODB allocation:** `NOT_REQUESTED — NO_IDS_PROPOSED_OR_RESERVED`

**Implementation and Gate authorization:** `NOT_GRANTED`

**Date:** 2026-11-23

## 1. Verified baseline and governance status

The [Owner Decision Baseline](../architecture/after_four_owner_decision_baseline.md#wave-2-conditional-direction-and-clarification-responses) records sixteen earlier Wave 2 decisions, twenty-two subsequently confirmed bounded directions, two unresolved Conditional candidates, three Owner clarification requests, and twelve Dependency-blocked candidates. This package preserves those statuses and uses the [Consolidated Owner Review Session](after_four_wave_2_consolidated_owner_review_session.md), [Flow A Closure Package](after_four_wave_2_flow_a_closure_package.md), [Owner Review Package](after_four_wave_2_owner_review_package.md), domain annexes, P1 decisions, and approved Customer policy as evidence.

| Classification | Count | Treatment here |
|---|---:|---|
| Previously recorded Owner decisions | 16 | Unchanged; not reopened. |
| Confirmed directions, still Conditional | 22 | Unchanged; conditions remain open. |
| Unresolved Conditional | 2 | Evidence alternatives prepared; no selection. |
| Clarification requests | 3 | Source-option packages prepared; no policy approval. |
| Dependency-blocked | 12 | Dependency dossiers prepared; none unblocked. |
| **Active total** | **55** | `16 + 22 + 2 + 3 + 12 = 55`. |

`SDP-SCOPE-01` Option D remains controlling: current operations retain the initial one-Organization/one-Brand assumption, multi-Brand semantics remain deferred, and cross-Brand discovery, visibility, Loyalty sharing, Promotion applicability, and benefits remain default-denied.

## 2. Clarification evidence package A1 — Cash discrepancy policy

**Reference:** `P2B-CASH-OD-03` — `REQUEST_SOURCE_OPTIONS` / `CLARIFICATION_REQUIRED`

**Sources:** [Cash discovery §§4–5](after_four_p2b_cash_domain_discovery.md#4-integration-discovery), [`ODB-CASH-14`](../architecture/after_four_owner_decision_baseline.md#wave-2-cash-owner-decisions), [Reporting decisions](../architecture/after_four_owner_decision_baseline.md#4-reporting).

Current evidence establishes a no-tolerance baseline: every nonzero discrepancy is an exception requiring recording, a reason, and Owner notification. Classification may determine investigation, escalation, and resolution, but cannot silently exempt a discrepancy from recording, reason, or notification. Closed evidence is immutable; any authorized correction is a linked fact rather than a rewrite, and an unresolved discrepancy remains an explicitly unresolved case. `ODB-CASH-14` does not establish correction authority, resolution details, or when unresolved discrepancies hold authoritative reporting.

| Policy dimension | Source-grounded option surface | Consequence / evidence gap |
|---|---|---|
| Classification | Every nonzero discrepancy remains an exception. Classification may determine investigation, escalation, and resolution only. | No discrepancy classes or thresholds are approved. Changing the no-tolerance baseline requires a separate explicit policy amendment; no classification may remove mandatory recording, reason, or Owner notification. |
| Notification/escalation | Every nonzero discrepancy requires Owner notification; a future classification model may add escalation without removing that notification. | Escalation recipients, timing, acknowledgement, and overdue treatment remain absent. |
| Resolution | Preserve the immutable closed evidence. An unresolved discrepancy remains explicitly unresolved; if a future authorized correction occurs, record it as a linked fact. | Linked correction is not an alternative to immutability. Permitted correction actions and unresolved-case treatment remain unresolved under `ODB-CASH-14`. |
| Authority | `RECOMMENDATION_NOT_ESTABLISHED`. | Cash, Accounting, and Reporting must provide candidate correction operations, candidate initiator and approver responsibilities, required separation or escalation, and evidence supporting each proposed authority boundary. |
| Evidence | Recording, reason, Owner notification, and preservation of the original closed evidence remain mandatory. | Cash, Accounting, and Reporting must provide the evidence required for each candidate correction operation and authority boundary. No AuditEvent schema is approved. |
| Reporting | `RECOMMENDATION_NOT_ESTABLISHED`. | Reporting hold/release and authoritative treatment of explicitly unresolved cases remain unresolved Owner policy; Cash and Reporting must provide supported options. |

**Evidence required before an Owner ballot:** Cash, Accounting, and Reporting must provide supported classification semantics that preserve the no-tolerance baseline; candidate correction operations and initiator/approver responsibilities; required separation or escalation; evidence for each proposed authority boundary; and reporting hold/release and unresolved-case treatment. Cash is accountable; Accounting and Reporting are required evidence owners. No recommendation is established for correction authority or reporting treatment.

## 3. Clarification evidence package A2 — bounded Promotion types

**Reference:** `P2A-PROMO-OD-01` — `REQUEST_SOURCE_OPTIONS` / `CLARIFICATION_REQUIRED`

**Sources:** [Promotions discovery §§4.2–5](after_four_p2a_promotions_policy_discovery.md#42-applicability-and-eligibility), [Catalog/Pricing unresolved matters](../architecture/after_four_owner_decision_baseline.md#5-catalogpricing-mvp).

Fixed, percentage, bundle, and free-item are exploratory concepts, not an approved catalogue. A general-expression capability is a separate broader alternative. Current evidence supports choosing a small explicit set before considering a general engine, but does not support a particular set.

| Exploratory direction | Business meaning to define before selection | Principal trade-offs and dependencies |
|---|---|---|
| Fixed | Reduce a line or Order by an explicit monetary amount. | Needs currency, floor/zero-price, line-versus-Order allocation, tax/service-charge, and Refund treatment. “Fixed” is not silently narrowed to a particular allocation model. |
| Percentage | Apply a rate to an explicitly defined eligible base. | Needs eligible base, cap/floor, rounding, stacking order, allocation, and Refund treatment. |
| Bundle | Define eligibility and benefit from a required composition of items/quantities. | Needs Product/Variant facts, substitutions, partial fulfillment, line allocation, and cancellation treatment. |
| Free item | Grant a separately identified benefit item under explicit eligibility. | Needs zero/free-price policy, stock/Preparation consequences, substitutions, limits, and Refund/cancellation behavior. |
| General expression | Permit a broader rule/evaluation language rather than only explicit types. | Maximizes flexibility but greatly expands validation, explainability, auditability, security, support, and deterministic-evaluation risk. |

**Option surface:** Owner supplies a bounded subset from researched explicit types; requests further type research; or separately considers a general-expression direction. `RECOMMENDATION_NOT_ESTABLISHED` for the exact initial set. Ordering, Catalog/Pricing, tax/accounting, Customer eligibility, and Reporting inputs are required before formulas or execution semantics can close.

## 4. Clarification evidence package A3 — Voucher policy

**Reference:** `P2A-PROMO-OD-06` — `REQUEST_SOURCE_OPTIONS` / `CLARIFICATION_REQUIRED`

**Sources:** [Promotions discovery §§4.2, 4.5, and 5](after_four_p2a_promotions_policy_discovery.md#42-applicability-and-eligibility), [Customer decisions](../architecture/after_four_customer_management_owner_decisions.md), [`SDP-SCOPE-01`](../architecture/after_four_sdp_scope_01_owner_decision.md).

| Policy dimension | Source-grounded alternatives | Consequences / required evidence |
|---|---|---|
| Issuance authority | Owner-only issuance; or exact scope-bounded issuance capability. | Exact assignees, scope, reason/campaign basis, quantity, evidence, revocation, and review are absent. |
| Eligibility binding | Bearer Voucher; Customer-bound Voucher; or no Voucher capability in the bounded scope. | Bearer improves access but raises leakage/fraud. Customer-bound increases privacy and verification duties and cannot infer identity from phone possession. |
| Reuse | Single successful use; bounded multiple use; or reusable until an explicit limit. | Requires authoritative success/reversal semantics, idempotency policy later, usage evidence, and Customer/public distinction. No default exists. |
| Transfer | Non-transferable; transferable bearer behavior; or separately controlled transfer. | Customer-specific benefits cannot be transferred merely because identity/phone changes. Any controlled transfer needs new authority, evidence, privacy, and fraud policy. |
| Quantity/time limits | Per Voucher, Customer, Promotion, Branch, or period limits; or no Voucher launch until limits are selected. | Exact dimensions, timezone, period boundaries, counters, reversal effects, and support policy are absent. |
| Loss/compromise/recovery | No replacement; revoke-and-reissue; or evidenced exceptional recovery. | No recovery or reassignment right is approved. Needs fraud review, identity/eligibility verification, authority, evidence, and historical linkage. |

**Owner questions required:** whether Voucher is in bounded scope; bearer versus Customer-bound behavior; issuance authority; reuse/transfer; limits; compromise/recovery. Promotions is accountable; Customer/privacy and fraud-policy evidence owners must validate affected options. Cross-Brand applicability remains unavailable under `SDP-SCOPE-01`.

## 5. Unresolved Conditional package B1 — Preparation recognition

**Reference:** `P2B-INV-OD-04A` — `RECOMMENDATION_NOT_ESTABLISHED` / `CONDITIONALLY_REVIEWABLE`

**Sources:** [Inventory discovery §§4–5](after_four_p2b_inventory_domain_discovery.md#4-operational-discovery), [Business Domain Model inventory rules](../architecture/after_four_business_domain_model.md#9-inventory-and-procurement), [P1A Order/Payment closure](after_four_p1a_order_payment_policy_closure.md).

| Alternative | Event meaning that must be authoritative | Consequences and unresolved evidence |
|---|---|---|
| Preparation start | Work on a defined item/quantity has actually begun using a known RecipeVersion. | Stock availability changes early. Cancellation, abandoned work, partial work, remake/waste, duplicate starts, and correction require explicit facts. |
| Preparation completion | Defined preparation work completed successfully. | Avoids premature normal consumption but delays availability truth and requires separate failed/abandoned/waste recognition. |
| Another operational event | A separately named committed fact such as ingredient issue/dispense or station-confirmed consumption. | May align physical custody better, but no such authoritative event or owner contract is approved. It must not be invented from UI state. |

Preparation owns work/deviation facts; Inventory owns stock movement and reconciliation; Ordering owns cancellation; Accounting supplies valuation consequences. `P2B-INV-OD-04B` already requires deviations to remain distinct from normal consumption. The exact next Owner decision is which business event recognizes normal consumption and what minimum failure/correction facts accompany it. No recommendation is established.

## 6. Unresolved Conditional package B2 — Promotion scheduling semantics

**Reference:** `P2A-PROMO-OD-08` — `RECOMMENDATION_NOT_ESTABLISHED` / `CONDITIONALLY_REVIEWABLE`

**Sources:** [Promotions discovery §§4.1–5](after_four_p2a_promotions_policy_discovery.md#41-lifecycle-and-publication), [Data Integrity Rules effective intervals](../architecture/after_four_data_integrity_rules.md#5-historical-snapshots-and-effective-dates), [`SDP-SCOPE-01`](../architecture/after_four_sdp_scope_01_owner_decision.md).

| Dimension | Bounded alternatives | Boundary example / risk |
|---|---|---|
| Timezone owner | One explicitly approved business timezone; or Branch-local timezone. | At the same instant, Branch-local campaigns may cross a boundary at different times. One timezone is simpler but may misalign local operations. |
| Start boundary | Inclusive; or exclusive. | At exactly `start_at`, eligibility differs. Clients, quotes, confirmation, and support wording must agree. |
| End boundary | Inclusive; or exclusive. | At exactly `end_at`, an inclusive end can overlap a successor unless another rule prevents it; exclusive end enables half-open intervals. |
| Daylight-saving/offset change | Follow named timezone rules; or restrict affected scheduling until a policy exists. | This matters only where the selected timezone changes offset. Ambiguous/nonexistent local times require an explicit business outcome rather than a guessed conversion. |
| Cross-Branch consistency | Shared campaign uses one business timezone; or each applicable Branch evaluates local time. | `SDP-SCOPE-01` permits no cross-Brand expansion; Branch behavior still needs an applicability decision within the current one-Brand assumption. |

The existing half-open-interval material is technical/design evidence, not an Owner selection for Promotions. Owner decisions are required independently for timezone ownership, start boundary, end boundary, and offset-change behavior. No scheduler, clock representation, query, or enforcement mechanism is selected.

## 7. Dependency dossiers — all twelve blocked candidates

| Candidate / owner | Upstream dependency and exact missing evidence | Minimum unblocking outcome / acceptance evidence | Parallel work and sequence | Source |
|---|---|---|---|---|
| `P2B-CASH-OD-05` / Cash | Payment Refund method/allocation: original versus alternate method, partial allocation, authoritative outcome, Cash effect, accounting/reporting. `P1A-OD-03` approves only a method-aware append-only principle. | Owner-approved method/allocation policy identifies when an authoritative Refund creates Cash outflow and preserves Payment/Cash evidence separately. | Cash evidence fields may be prepared; decide after Payment and Accounting inputs. | [Cash §5](after_four_p2b_cash_domain_discovery.md#5-candidate-owner-decisions), [P1A policy closure](after_four_p1a_order_payment_policy_closure.md) |
| `P2B-WF-OD-06A` / Workforce | Qualified employment/legal and Payroll evidence for break entitlement, timing, missed/interrupted breaks, evidence, correction. | Qualified source identifies applicable obligations and policy choices; Payroll confirms consequence inputs. | Research with attendance facts; independent later ballot. | [Workforce §5](after_four_p2b_workforce_domain_discovery.md#5-candidate-owner-decisions) |
| `P2B-WF-OD-06B` / Workforce | Qualified employment/legal input and exact attendance-event definitions for grace periods. | Approved purpose, duration, applicable events, scope, and consequences; raw attendance remains preserved. | Research beside `06A/06C`; no numerical value may be guessed. | [Workforce §5](after_four_p2b_workforce_domain_discovery.md#5-candidate-owner-decisions) |
| `P2B-WF-OD-06C` / Workforce | Qualified employment/legal and Payroll input for time rounding. | Decision whether rounding is permitted plus bounded calculation constraints; raw/corrected facts remain authoritative. | Parallel qualified review; precedes Payroll calculation design. | [Workforce §5](after_four_p2b_workforce_domain_discovery.md#5-candidate-owner-decisions) |
| `P2B-WF-OD-06D` / Workforce | Shift/attendance semantics, qualified legal, Payroll/Reporting input for lateness. | Approved classes, thresholds, excused outcomes, evidence, review, and consequences. | After attendance semantics; separate from absence. | [Workforce §5](after_four_p2b_workforce_domain_discovery.md#5-candidate-owner-decisions) |
| `P2B-WF-OD-06E` / Workforce | Leave outcome, qualified legal, Payroll/Reporting input for absence. | Approved absence classes, evidence, review/correction, and consequences that do not conflate leave. | After `07A` supplies leave distinctions. | [Workforce §5](after_four_p2b_workforce_domain_discovery.md#5-candidate-owner-decisions) |
| `P2B-WF-OD-07A` / Workforce | Qualified employment/legal and Payroll evidence for leave categories, entitlement/balance, workflow, dates, correction. | Qualified obligations and Owner-approved leave policy surface with affected Payroll facts. | Can run beside `06A`–`06C`; precedes `06E`. | [Workforce §5](after_four_p2b_workforce_domain_discovery.md#5-candidate-owner-decisions) |
| `P2B-WF-OD-07B` / Workforce | Qualified employment/legal, Accounting, and Payroll evidence for overtime eligibility, prior authority, recording, rate/calculation, exceptions, correction. | Qualified obligations and Owner-approved option surface; no rate inferred. | Independent qualified stream; coordinate attendance evidence. | [Workforce §5](after_four_p2b_workforce_domain_discovery.md#5-candidate-owner-decisions) |
| `P2B-INV-OD-07` / Inventory | Qualified Accounting decision on valuation objective/method, cost-flow assumptions, valuation events, correction/discrepancy treatment. Existing weighted-average text is design evidence only. | Accounting-approved option surface and Owner selection, separately preserving Inventory quantity truth. | Quantity/evidence analysis may proceed; valuation decision waits. | [Inventory §5](after_four_p2b_inventory_domain_discovery.md#5-candidate-owner-decisions), [Integrity Rules §9](../architecture/after_four_data_integrity_rules.md#9-inventory-and-weighted-average-integrity) |
| `P2A-LOY-OD-05` / Loyalty | Payment/Ordering Refund allocation and cancellation: refunded lines/value, successful outcome, partial allocation, timing, cancellation stage. | Approved authoritative inputs allow Loyalty to decide reversal amount/timing without silently assuming proportionality. | Enumerate Loyalty consequences; wait for P1A and cancellation matrix. | [Loyalty §5](after_four_p2a_loyalty_policy_discovery.md#5-candidate-policy-decisions), [P1A gaps](after_four_p1a_order_payment_policy_closure.md#5-policy-gap-register) |
| `P2A-PROMO-OD-05` / Promotions | Payment/Ordering Refund/cancellation plus Catalog Price, tax, service charge, rounding, zero/free-item and discount-allocation inputs. | Authoritative sold components and downstream outcomes permit a Promotions-owned allocation/reversal choice. | Coordinate with Loyalty and Ordering; do not transfer ownership. | [Promotions §5](after_four_p2a_promotions_policy_discovery.md#5-candidate-policy-decisions), [Catalog open decisions](../architecture/after_four_owner_decision_baseline.md#5-catalogpricing-mvp) |
| `W2-ORD-OD-01` / Ordering | Catalog total components; Loyalty earning/redemption/reversal; Promotion stacking/allocation; applicable P1 Refund/cancellation outcomes. | Participating policies are approved sufficiently to compare exact Order-owned calculation and line/amount allocation sequences. | Process last; `W2-INT-02A`–`02C` coordination may proceed in parallel. | [Integration register §5.1](after_four_wave_2_cross_domain_integration_decision_register.md#51-ordering-owned-allocation-candidate) |

Qualified employment/legal, Accounting, food-safety, Payroll, privacy, and fraud evidence is not present in the repository at an acceptance level sufficient to close the named policies. The accountable business domain remains the candidate owner; the named qualified party is the evidence owner, not a substitute policy owner.

## 8. Cross-domain dependency graph and critical path

```text
Qualified employment/legal + Payroll ──> WF-06A..06E, WF-07A..07B

Food-safety/item classes ──────────────> INV-03 conditions
Preparation/Recipe/Ordering ───────────> INV-04A ──> cancellation/stock inputs
Qualified Accounting ─────────────────> INV-07 and Cash discrepancy/source policy

Payment Refund + cancellation ─────────> CASH-05, LOY-05, PROMO-05
Catalog totals/tax/rounding ───────────> PROMO-05 ─┐
Loyalty/Promotion component policies ─────────────┼─> W2-ORD-OD-01
P1 outcomes ──────────────────────────────────────┘

Cash evidence research ────────────────> CASH-03 future clarification ballot
Promotion type research ───────────────> PROMO-01 future clarification ballot
Voucher/privacy/fraud research ────────> PROMO-06 future clarification ballot
Promotion applicability input ─────────> PROMO-08 future scheduling ballot
```

Independent parallel streams are: Workforce qualified review; Inventory food-safety and Accounting evidence; Payment Refund/cancellation; Catalog total components; Cash discrepancy options; Promotion type/Voucher research; Inventory recognition semantics; and Promotion scheduling semantics. Shared Payment/Catalog evidence should be gathered once and referenced by Cash, Loyalty, Promotions, and Ordering.

The critical commercial path is Payment Refund/cancellation plus Catalog total components, followed by Loyalty/Promotion reversal and allocation, followed by the Ordering calculation sequence. Workforce qualified evidence is a separate critical path for Workforce closure. Starting research does not satisfy or unblock a dependency; accepted evidence and any required Owner decision do.

## 9. Future Owner review preparation

| Readiness for next session | References | Required next Owner action |
|---|---|---|
| Clarification option surface prepared, evidence still incomplete | `P2B-CASH-OD-03`, `P2A-PROMO-OD-01`, `P2A-PROMO-OD-06` | Review the option dimensions, request missing qualified evidence, then approve a bounded ballot surface; do not treat this package as policy selection. |
| Bounded alternatives prepared; no recommendation established | `P2B-INV-OD-04A`, `P2A-PROMO-OD-08` | Select only after Preparation/Inventory/Accounting evidence or Promotion applicability/operating-time evidence is accepted. |
| `DEPENDENCY_BLOCKED` | Twelve rows in §7 | No downstream vote yet; first accept the minimum upstream outcome named in the dossier. |

For `P2B-INV-OD-04A`, the eventual question is which authoritative business event recognizes normal consumption and which failure/correction facts accompany it. For `P2A-PROMO-OD-08`, timezone, start inclusion, end inclusion, and offset-change behavior are independently answerable. Both remain `RECOMMENDATION_NOT_ESTABLISHED`.

## 10. Logical design observations — non-authoritative

- Cash discrepancy, correction, resolution, and reporting status are distinct logical facts; their physical representation is unselected.
- Promotion Type and Voucher are candidate policy concepts. No type hierarchy, rule language, token model, or persistence boundary is approved.
- Preparation work/deviation facts and Inventory movement/reconciliation facts remain context-owned and require a future explicit integration contract.
- Scheduling needs an explicit timezone and interval convention before a deterministic logical eligibility rule can be finalized.
- Refund outcome, Cash movement, Loyalty reversal, Promotion reversal/allocation, and Order totals remain independent authoritative facts coordinated through future contracts.
- Workforce raw attendance, corrected attendance, policy classification, and Payroll consequence should remain conceptually distinguishable; exact model and interfaces remain unapproved.

These observations select no table, column, identifier, index, constraint, foreign key, transaction, lock, isolation level, API, event transport, service, or implementation mechanism.

## 11. Evidence-gap ownership and final reconciliation

| Evidence gap | Accountable policy owner | Required evidence owner / consultation |
|---|---|---|
| Cash discrepancy and top-up source/accounting treatment | Cash | Accounting and Reporting |
| Employment time, breaks, grace, rounding, lateness, absence, leave, overtime | Workforce | Qualified employment/legal, Payroll, Accounting/Reporting as applicable |
| Lot/FEFO and Preparation recognition | Inventory | Food safety, Preparation, Recipe/Catalog, Ordering |
| Inventory valuation | Inventory | Qualified Accounting |
| Refund/cancellation allocation | Payment/Ordering for upstream facts; consumer domain for its policy | Cash, Loyalty, Promotions, Accounting/Reporting consultation |
| Promotion types, Voucher, and scheduling | Promotions | Catalog/Pricing, Ordering, Customer/privacy, fraud policy, operating owners |
| Order calculation sequence | Ordering | Catalog, Promotions, Loyalty, Payment, tax/accounting, Reporting |

Final reconciliation remains unchanged: 16 previously recorded decisions + 22 confirmed Conditional directions + 2 unresolved Conditional candidates + 3 clarification requests + 12 Dependency-blocked candidates = 55 active candidates.

## 12. Governance and technical boundary

This package records no Owner decision, changes no readiness classification, and allocates, reserves, or proposes no canonical ID. It does not authorize Flow B technical design, physical database design, schema, migrations, database creation, indexes, constraints, transactions, locks, isolation choices, code, tests, dependencies, APIs, UI, Identity implementation, runtime grants, deployment, Gate A/B/C, Control Acceptance, FOA, or Production Authorization.

Logical-design preparation remains limited to non-authoritative concepts and ownership observations. Every legal, accounting, food-safety, privacy, fraud, or operational conclusion absent from accepted repository evidence remains an explicit gap.
