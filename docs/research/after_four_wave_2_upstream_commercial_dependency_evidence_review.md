# AFTER FOUR — Wave 2 Upstream Commercial Dependency Evidence Review

**Status:** `EVIDENCE_REVIEW_PREPARED — OWNER_POLICY_REMAINS_UNRESOLVED`
**Authority:** `NW-OR-01` — documentation, evidence organization, and research sequencing only
**Base:** `c7be1d999ac7961f41c24b92bc1a30c44c21c15e`
**Scope:** Payment Refund/cancellation outcomes and Catalog/Pricing Order-total components consumed by four dependency-blocked Wave 2 candidates

## 1. Purpose, authority, and scope

This review consolidates the repository evidence needed before `P2B-CASH-OD-05`, `P2A-LOY-OD-05`, `P2A-PROMO-OD-05`, and `W2-ORD-OD-01` can receive bounded Owner ballots. It separates authoritative policy from design evidence, unresolved Owner policy, and unauthorized technical implementation detail.

This package does not select a Refund method or allocation, a cancellation consequence, a price formula, a calculation sequence, or any downstream reversal rule. It does not change the four candidates' `DEPENDENCY_BLOCKED` classification. Canonical authority remains the [Owner Decision Baseline](../architecture/after_four_owner_decision_baseline.md); the [Remaining Evidence Closure Package §7](after_four_wave_2_remaining_evidence_closure_package.md#7-dependency-dossiers--all-twelve-blocked-candidates) remains the controlling blocked-candidate inventory.

## 2. Verified baseline and source inventory

| Source | Authority used here | Material boundary |
|---|---|---|
| [Owner Decision Baseline — Consolidated P1 decisions](../architecture/after_four_owner_decision_baseline.md#consolidated-p1-owner-decisions) | `P1A-OD-01`–`08` outcomes and authorization exclusions | Refund principle is approved; exact method/allocation and cancellation consequences are not. |
| [Owner Decision Baseline — Ordering and Payment](../architecture/after_four_owner_decision_baseline.md#2-ordering-and-payment) | `ODB-OP-02`–`16` | Payment gate, mismatch/excess, cancellation authority, and reconciliation limits are authoritative. |
| [P1A closure §§3–5](after_four_p1a_order_payment_policy_closure.md#3-current-policy-inventory) | Reconciled current evidence and gap register | Proposals and state-machine evidence do not close the gaps. |
| [Payment Model](../architecture/after_four_payment_model.md) | Existing implemented exact-balance model plus documented later design | Partial/split and excess/Refund representation remain unresolved. |
| [State Machines §10](../architecture/after_four_state_machines.md#10-refund-state-machine) | Refund lifecycle design evidence | Exact allocation is explicitly `OPEN_DECISION`; states are not implementation authority. |
| [Catalog/Pricing Discovery §§2–4](../architecture/after_four_catalog_pricing_discovery.md#2-original-discovery-conclusions-closed-by-the-owner) | `ODB-CAT-01`–`10` closures and preserved open questions | Price scope/history/sold snapshot are confirmed; total-component policy is not. |
| [Catalog Core Design §§2, 13](../architecture/after_four_catalog_core_technical_design.md#2-package-boundary) and [Package C Design §1](../architecture/after_four_package_c_technical_design.md#1-purpose-and-authority-boundary) | Boundary evidence only | Catalog Core excludes Price and Package C covers Category/Variant lifecycle operations; neither supplies commercial-total or Refund policy. |
| [Business Domain Model §§7–8](../architecture/after_four_business_domain_model.md#7-catalog-prices-recipes-and-historical-snapshots) | Context ownership, snapshots, and policy classifications | Workshop/design statements are not silently promoted to Owner policy. |
| [Data Integrity Rules §§7–8](../architecture/after_four_data_integrity_rules.md#7-reversal-and-adjustment-patterns) | Append-only correction and arithmetic design constraints | Refund implementation is outside Phase 1 and remains unauthorized. |
| [Wave 2 integration register §§4–5](after_four_wave_2_cross_domain_integration_decision_register.md#4-candidate-future-business-eventscontracts) | Context ownership, `W2-INT-02A`–`02C`, and `W2-ORD-OD-01` | Coordination records do not transfer policy ownership or select a sequence. |
| [Cash discovery §§4–5](after_four_p2b_cash_domain_discovery.md#4-integration-discovery) | Cash/Refund boundary and `P2B-CASH-OD-05` | Payment outcome does not itself prove a drawer movement. |
| [Loyalty discovery §§4–5](after_four_p2a_loyalty_policy_discovery.md#4-lifecycle-and-policy-discovery) | Loyalty reversal dependency and `P2A-LOY-OD-05` | Proportionality must not be inferred. |
| [Promotions discovery §§4–5](after_four_p2a_promotions_policy_discovery.md#4-policy-discovery) | Promotion allocation/reversal dependency and `P2A-PROMO-OD-05` | Applied-benefit allocation and cancellation/Refund treatment remain open. |

Repository evidence does not contain accepted provider-specific Refund rules or qualified accounting/tax conclusions sufficient to close these questions. Where a responsible evidence authority is not established, this review uses `OWNER_TO_CONFIRM`.

## 3. Payment Refund evidence review

### 3.1 Evidence matrix

| Business question | Existing authoritative policy/evidence | Source | Current status | Missing evidence or Owner decision | Downstream consumers |
|---|---|---|---|---|---|
| What is a Refund? | It is a new financial record linked to original successful Payment/Order evidence; it never rewrites the original charge. | [Business Domain Model glossary](../architecture/after_four_business_domain_model.md#sales-and-fulfillment); [Integrity Rules §7](../architecture/after_four_data_integrity_rules.md#7-reversal-and-adjustment-patterns) | Append-only principle `OWNER_CONFIRMED` through `P1A-OD-03`; record shape remains design-only | Exact aggregate/record contract and execution are unauthorized. | Payment, Ordering, Cash, Loyalty, Promotions, Reporting |
| Which Refund lifecycle applies? | `requested`, `approval_required`, `approved`, `processing`, `unknown`, `succeeded`, `failed`, `rejected`, and `cancelled` are documented with authoritative reconciliation from `unknown`. | [State Machines §10](../architecture/after_four_state_machines.md#10-refund-state-machine) | `DESIGN_EVIDENCE`; not an approved executable workflow | Owner-approved eligibility, authority thresholds, and method/provider evidence; later technical design | Payment, Cash, Reporting |
| Full versus partial Refund | Payment vocabulary can represent `partially_refunded` and `fully_refunded`; cumulative successful Refunds cannot exceed refundable value. | [Payment Model §§2, 4](../architecture/after_four_payment_model.md#2-state-vocabularies); `P1A-OD-03` in the [baseline](../architecture/after_four_owner_decision_baseline.md#consolidated-p1-owner-decisions) | Cap/principle established; partial allocation `UNRESOLVED` | Whether partial Refund is offered, eligible amount/components, line/Order allocation, rounding, and authority | Cash, Loyalty, Promotions, Reporting |
| Original versus alternate method | Refund policy must be method-aware, but no original-tender rule or alternate-method permission is selected. | [P1A gap `P1A-G03`](after_four_p1a_order_payment_policy_closure.md#5-policy-gap-register); [Payment Model §8](../architecture/after_four_payment_model.md#8-deferred-decisions) | `OWNER_POLICY_UNRESOLVED` | Provider/Cash/accounting evidence and Owner selection of permitted method outcomes | Cash, Payment, Reporting |
| Line-level versus Order-level allocation | No authoritative allocation exists. The repository expressly forbids silently assuming proportionality. | [Loyalty `P2A-LOY-OD-05`](after_four_p2a_loyalty_policy_discovery.md#5-candidate-policy-decisions); [Promotions `P2A-PROMO-OD-05`](after_four_p2a_promotions_policy_discovery.md#5-candidate-policy-decisions) | `OWNER_POLICY_UNRESOLVED` | Refundable component vocabulary; line/Order allocation choices; tax, Promotion, Loyalty, and rounding consequences | Loyalty, Promotions, Ordering, Reporting |
| What happens to pending/processing, failed, rejected, or cancelled Refunds? | `processing` precedes an authoritative result in the design lifecycle; failed, rejected, and cancelled are non-success outcomes, and only success changes refunded totals. Unknown must be reconciled rather than guessed or blindly retried. | [State Machines §10](../architecture/after_four_state_machines.md#10-refund-state-machine); [Payment Model §4](../architecture/after_four_payment_model.md#4-transitions-and-guards) | Lifecycle semantics are `DESIGN_EVIDENCE`; authoritative reconciliation principle established | Provider-specific pending/result authority, retry/recovery operations, customer remedy, and reporting treatment | Payment, Reporting, Cash only where money actually moves |
| Is a Refund reversed or corrected? | Confirmed commercial and financial history is preserved through linked corrective facts rather than editing the original charge. The inspected sources define no approved Refund lifecycle outcome named `reversed` or `corrected`. | [`P1A-OD-03`](../architecture/after_four_owner_decision_baseline.md#consolidated-p1-owner-decisions); [Integrity Rules §7](../architecture/after_four_data_integrity_rules.md#7-reversal-and-adjustment-patterns) | Append-only principle established; exact correction/reversal semantics `UNRESOLVED` | Owner-approved permitted corrective outcomes, linkage, amount effects, authority, and downstream treatment | Payment, Ordering, Cash, Loyalty, Promotions, Reporting |
| How are repeated requests handled? | Retryable intent must not duplicate Refund or downstream effects; original charge remains unchanged. | [P1A §3](after_four_p1a_order_payment_policy_closure.md#3-current-policy-inventory); [Integrity Rules §11](../architecture/after_four_data_integrity_rules.md#11-idempotency-and-external-boundaries) | Semantic/design constraint; no Refund implementation authorized | Exact request identity, retention, provider idempotency, and operating recovery | Payment, Cash, Loyalty, Promotions |
| What is the Cash effect? | A cash Refund requires both an approved authoritative Refund outcome and a separate Cash outflow. Non-cash outcomes do not imply drawer movement. | [Cash §4](after_four_p2b_cash_domain_discovery.md#4-integration-discovery) | Context boundary established; method mapping unresolved | Approved method/allocation facts identifying when and how much Cash must record | Cash, Reporting |
| What is the Loyalty effect? | Loyalty owns reversals; Refund/cancellation facts are inputs and do not authorize an assumed proportional reversal. | [Loyalty §§4.3, 5](after_four_p2a_loyalty_policy_discovery.md#43-adjustment-reversal-expiration-and-reconciliation) | Ownership established; reversal allocation unresolved | Refunded lines/components/value, success timing, partial allocation, cancellation stage | Loyalty, Reporting |
| What is the Promotion effect? | Promotions owns applied-benefit allocation and reversal/release; Refund/cancellation policy and sold components are inputs. | [Promotions §§4.3–4.4](after_four_p2a_promotions_policy_discovery.md#43-calculation-stacking-and-precedence) | Ownership established; allocation/treatment unresolved | Applied Promotion attribution, refundable components, cancellation outcome, tax/service-charge/rounding policy | Promotions, Ordering, Reporting |

### 3.2 Minimum accepted upstream Refund outcome

Before any of the three downstream reversal candidates can be reviewed, Payment/Refund policy must provide an Owner-approved semantic outcome containing at least:

1. the authoritative original Payment/Order reference and successful Refund outcome;
2. the approved Refund amount and currency, with cumulative successful value capped at refundable value;
3. whether the outcome is full or partial;
4. the permitted original or alternate method outcome, including whether it creates a Cash outflow;
5. the authoritative allocation to refundable Order lines/components, or an explicit policy that a particular allocation dimension is not supported;
6. reason, actor, approval evidence, and authoritative reconciliation status; and
7. treatment of pending/unknown/failed/rejected/cancelled and repeated requests without inventing success.

This is an evidence contract, not a schema, event, endpoint, or transaction design. The accountable policy owner is Payment for Refund method/outcome; Ordering owns Order/line commercial allocation; Cash, Loyalty, Promotions, Reporting, and qualified accounting/provider sources supply required evidence. Exact qualified accounting/provider authority is `OWNER_TO_CONFIRM`.

## 4. Cancellation evidence review

| Cancellation stage | Authoritative policy/evidence | Status | Unresolved authoritative outcome |
|---|---|---|---|
| Before Preparation starts | Staff may cancel a paid Order with reason and audit; an atomic stage fence is required in future implementation. | Authority `OWNER_CONFIRMED` under `ODB-OP-12`; implementation absent | Refund amount/method, Promotion/Loyalty consequences, stock/Preparation outcome, compensation, Reporting |
| After Preparation starts | Owner approval is required; prepared work and history are preserved. | Authority `OWNER_CONFIRMED` under `ODB-OP-13`; implementation absent | Stage/quantity-specific Refund, waste/remake/Inventory, benefit reversal, compensation, Reporting |
| Completed Order | Uses a separate exception process and cannot be treated as ordinary cancellation. | Boundary `OWNER_CONFIRMED` under `ODB-OP-14`; `P1A-OD-05` deferred | Exact authority, eligible remedies, Refund, stock/benefit treatment, and closure relationship |
| Held/Expired with late Payment success | Preserve successful financial truth; do not reactivate or automatically dispatch. Only separately approved Refund, replacement/new-Order, or documented no-dispatch dispositions may later be selected. | Direction `OWNER_CONFIRMED` under `P1A-OD-06` | Which separately approved disposition applies, delegated authority, customer remedy, Cash/benefit effects |

`P1A-OD-04` remains `DEFERRED`: cancellation authority is not the same as cancellation consequence policy. The minimum upstream cancellation evidence is an Owner-approved stage-specific matrix identifying the commercial outcome, refundable lines/components/value, Preparation/Inventory consequence, Loyalty/Promotion consequence, customer remedy, and Reporting treatment. The matrix must preserve Payment, Preparation, stock, benefit, and audit history. It must not assume full Refund, proportional allocation, or reversal merely because cancellation was authorized.

## 5. Catalog/Pricing total-component review

| Component/question | Established policy or evidence | Classification | Missing decision/evidence | Accountable policy owner |
|---|---|---|---|---|
| Product/Variant price input | Every sellable selection is a persisted Variant. Chain default Price supports explicit Branch override; Price versions are immutable and effective-dated. | `OWNER_CONFIRMED` (`ODB-CAT-04`, `07`, `08`) | Actual Price facts/publication authority and Modifier price effects | Catalog/Pricing |
| Draft repricing | Authoritative price change requires revised-quote review before confirmation. | `OWNER_CONFIRMED` (`ODB-CAT-09`) | Quote/version-token interaction is technical design, not approved here | Catalog/Pricing supplies price; Ordering owns confirmation |
| Sold price/history | Confirmation freezes sold price in the Order Item snapshot; later Price changes cannot rewrite it. | `OWNER_CONFIRMED` (`ODB-CAT-10`) | Exact snapshot representation and unresolved component provenance | Ordering owns sold snapshot; Catalog owns source Price |
| Promotion discount | Promotions cannot rewrite Catalog Price; confirmed Orders preserve applied Promotion evidence. Explicit stacking/exclusion and deterministic priority are a confirmed bounded direction, but allocation, tie-breaking, caps/floors, and interaction remain unresolved. | Mixed: ownership/snapshot design plus `P2A-PROMO-OD-03` direction | Promotion allocation by line/component and interaction with Loyalty/tax/service charge/rounding | Promotions; Ordering coordinates total sequence |
| Loyalty redemption | Exact limits, points-to-value rate, ordering, and deterministic rounding must be established before redemption. | `P2A-LOY-OD-02` direction confirmed; parameters unresolved | Eligible components, order relative to Promotion/tax/service charge, recovery/allocation | Loyalty; Ordering coordinates total sequence |
| Tax treatment | Tax inclusion/exclusion and invoice/accounting treatment are unresolved. | `OPEN_DECISION` / `LEGAL_VALIDATION` | Qualified tax/accounting evidence and Owner policy | `OWNER_TO_CONFIRM`; qualified legal/accounting evidence required |
| Service charge | No service-charge policy is approved. | `OPEN_DECISION` | Applicability, basis, interaction, reversal, and reporting | `OWNER_TO_CONFIRM` with Ordering/Catalog and accounting input |
| Rounding | No monetary rounding policy, scope, or order is approved. | `OPEN_DECISION` | Unit/precision, per-component/line/Order scope, tie rule, allocation residuals, Refund treatment | `OWNER_TO_CONFIRM`; Ordering plus qualified accounting input |
| Zero-price/free item | No zero-price/free-product policy is approved. A Promotion free-item concept remains exploratory rather than approved. | `OPEN_DECISION`; `P2A-PROMO-OD-01` is `REQUEST_SOURCE_OPTIONS` | Whether allowed; provenance; tax/service/rounding and Refund/cancellation behavior | Catalog/Pricing for sell price; Promotions for benefit; qualified tax/accounting input |
| Line total versus Order total | Ordering owns calculation sequence and line/amount allocation. No sequence is approved. | `W2-ORD-OD-01` `DEPENDENCY_BLOCKED` | Participating component policies and source-supported sequence options | Ordering, consulting each component owner |
| Refund/cancellation implications | Confirmed sold facts remain immutable; later corrections use linked outcomes. Exact Refund/component allocation and cancellation consequences are unresolved. | Preservation established; outcome policy open | Refunded/reversed component allocation and stage-specific cancellation matrix | Payment/Ordering plus component owners |

### 5.1 Ownership boundary

- Catalog/Pricing owns the authoritative current sellable definition, effective Branch Price, and immutable Price version.
- Ordering owns the confirmed Order Item commercial snapshot, Order-level calculation sequence, and line/amount allocation policy.
- Promotions owns eligibility, stacking/priority policy, benefit application, and Promotion discount allocation.
- Loyalty owns eligible earning/redemption value, Loyalty ordering constraints, and Loyalty allocation/reversal.
- Payment owns settlement and Refund outcome truth; it does not redefine sold components.
- Tax, service-charge, and rounding accountability is not fully established by the inspected sources. It remains `OWNER_TO_CONFIRM`, with qualified legal/accounting evidence required where applicable.

`W2-INT-02A`–`02C` are coordination records, not shared aggregates or Owner ballot items. No context may approve another context's policy through `W2-ORD-OD-01`.

## 6. Cross-domain consistency findings

| Finding | Classification | Evidence | Required reconciliation |
|---|---|---|---|
| Refund amount is not automatically a Cash outflow. | Confirmed context boundary; method mapping unresolved | [Cash §4](after_four_p2b_cash_domain_discovery.md#4-integration-discovery); [Integration register §3](after_four_wave_2_cross_domain_integration_decision_register.md#3-shared-terminology-and-ownership) | Refund method/outcome must explicitly identify Cash effect; Cash records its own fact. |
| Refund success does not select a Loyalty reversal amount. | Unresolved question, not a contradiction | [Loyalty §§4.3, 5](after_four_p2a_loyalty_policy_discovery.md#43-adjustment-reversal-expiration-and-reconciliation) | Provide refunded lines/components/value and timing; Loyalty selects its reversal policy. |
| Refund/cancellation does not select Promotion reversal or release. | Unresolved question, not a contradiction | [Promotions §4.4](after_four_p2a_promotions_policy_discovery.md#44-reservation-redemption-cancellation-and-reversal) | Provide applied-benefit attribution and authoritative commercial outcome; Promotions selects treatment. |
| Cancellation authority exists, but financial/Preparation/Inventory/benefit consequences do not. | Confirmed policy gap | [P1A §§3, 5](after_four_p1a_order_payment_policy_closure.md#3-current-policy-inventory); `P1A-OD-04` baseline record | Produce stage-specific consequence choices without reopening authority. |
| Price source and sold snapshot are confirmed, but the complete Order-total component set is not. | Confirmed gap | [Catalog/Pricing §4](../architecture/after_four_catalog_pricing_discovery.md#4-unresolved-decisions-preserved); [Business Domain Model §7](../architecture/after_four_business_domain_model.md#7-catalog-prices-recipes-and-historical-snapshots) | Close tax, service charge, rounding, zero/free, Modifier, Promotion/Loyalty inputs before Ordering sequence. |
| Current Price/policy changes cannot rewrite historical sold facts. | Confirmed invariant | `ODB-CAT-08`–`10`; [Integrity Rules §7](../architecture/after_four_data_integrity_rules.md#7-reversal-and-adjustment-patterns) | Any later correction/refund must retain source snapshot/version and linked corrective provenance. |
| Design documents expose Refund states and intents that are not an implemented or approved workflow. | Maturity mismatch, not semantic conflict | [State Machines §10](../architecture/after_four_state_machines.md#10-refund-state-machine); [P1A reconciliation `P1A-R02`–`03`](after_four_p1a_order_payment_policy_closure.md#4-reconciliation-findings) | Ballots must cite policy authority separately from design vocabulary. |

No confirmed contradiction was found between the canonical Owner decisions and the current context-ownership rules. The material risks are incomplete policies and maturity ambiguity, not two incompatible approved policies.

## 7. Downstream dependency matrix

| Candidate | Exact upstream facts consumed | Established upstream policy | Unresolved upstream policy | Minimum evidence before review | Dependency | Accountable owner / evidence owners |
|---|---|---|---|---|---|---|
| `P2B-CASH-OD-05` | Authoritative Refund result, amount, method, original/alternate status, full/partial allocation, Cash effect | Method-aware append-only principle; success cap; Payment/Cash facts remain separate | Permitted methods, allocation, Cash-outflow mapping, accounting/reporting | Owner-approved Refund method/allocation outcome explicitly identifying when and how much Cash moves | **Hard blocker**: without method/outcome Cash cannot distinguish drawer movement from non-cash value return | Cash accountable for drawer policy; Payment, Accounting, Reporting evidence owners; qualified provider/accounting authority `OWNER_TO_CONFIRM` |
| `P2A-LOY-OD-05` | Successful Refund/cancellation, refunded lines/components/value, full/partial allocation, timing/stage | Loyalty owns reversal; history is linked, not rewritten | Reversal allocation and timing; cancellation consequence matrix | Authoritative allocated Refund/cancellation outcome sufficient to compare proportional, line-based, points-first, or other source-supported Loyalty choices | **Hard blocker**: source explicitly forbids silently inferring proportionality | Loyalty accountable; Payment, Ordering, Promotions, Reporting inputs |
| `P2A-PROMO-OD-05` | Sold price/components, applied Promotion attribution, tax/service/rounding/zero-free facts, Refund allocation, cancellation stage/outcome | Promotions owns allocation/reversal; Catalog Price and sold history remain distinct and immutable | Discount allocation, component interactions, Refund/release/reversal, cancellation treatment | Closed component vocabulary plus authoritative Refund/cancellation outcomes and source-supported Promotion allocation options | **Hard blocker**: candidate recommendation explicitly defers until these policies close | Promotions accountable; Catalog/Pricing, Ordering, Payment, Loyalty, tax/accounting, Reporting inputs |
| `W2-ORD-OD-01` | Catalog Price, Promotion stacking/allocation, Loyalty redemption/earning rules, tax, service charge, rounding, applicable Refund/cancellation outcomes | Ordering owns sequence and line/amount allocation; component contexts retain their policies | Most component parameters and the entire sequence/allocation choice | Participating policy set sufficiently closed to compare deterministic sequences without inventing a component rule | **Hard blocker** for ballot; `W2-INT-02A`–`02C` coordination is parallel input preparation | Ordering accountable; Catalog/Pricing, Promotions, Loyalty, Payment, tax/accounting, Reporting consulted |

The hard-blocker conclusions preserve the [canonical twelve-candidate inventory](../architecture/after_four_owner_decision_baseline.md#wave-2-conditional-direction-and-clarification-responses). Coordination may proceed in parallel but cannot substitute for the missing Owner policy.

## 8. Minimum evidence required for each blocked candidate

### 8.1 Cash

- A bounded Refund-method matrix covering cash, non-cash, original method, and any proposed alternate method.
- For each permitted outcome: authoritative success evidence, amount/allocation, whether a drawer outflow exists, actor/approval, reconciliation, and Reporting/accounting consequence.
- Source-supported options from Payment plus qualified provider/accounting evidence; no method may be invented from workflow convenience.

### 8.2 Loyalty

- Refunded/cancelled lines and commercial components, successful amount, partial/full status, timing, and cancellation stage.
- Loyalty-owned choices for reversal basis and timing, including consequences for value paid with points and earned value.
- Explicit handling of allocation residuals/rounding after the upstream rounding policy exists.

### 8.3 Promotions

- Final sold component provenance: Catalog Price, applied Promotion benefit/discount, Loyalty redemption where relevant, tax, service charge, rounding, and zero/free attribution.
- Authoritative Refund/cancellation allocation and stage outcome.
- Promotions-owned source-supported choices for allocation, release, reversal, and preserved historical redemption evidence.

### 8.4 Ordering

- Closed or explicitly excluded inputs for every component named by `W2-ORD-OD-01`.
- Source-supported calculation-order alternatives with worked semantic examples covering line and Order totals, rounding residuals, zero/free items, partial Refund, and cancellation.
- Impact statements from every component owner; qualified tax/accounting input where required.

## 9. Recommended parallel and sequential closure plan

1. **Parallel evidence preparation:** Payment/provider/accounting prepares Refund method/outcome options; Catalog/Pricing plus qualified tax/accounting prepares total-component options; Preparation/Inventory and benefit contexts prepare cancellation-consequence inputs.
2. **Payment/Refund policy ballot:** close method, partial/full support, original/alternate method, allocation vocabulary, authoritative outcomes, and reconciliation. Preserve `P1A-OD-03`; do not reopen its append-only principle.
3. **Catalog/Pricing component ballots:** close tax treatment, service charge, rounding, zero/free, and relevant Modifier pricing. Confirm accountable owners where sources currently say `OWNER_TO_CONFIRM`.
4. **Cancellation consequence ballot:** close stage-specific commercial, Preparation/Inventory, Loyalty/Promotion, customer-remedy, and Reporting outcomes under the already-approved authority boundaries.
5. **Parallel downstream ballots:** review Cash, Loyalty, and Promotions candidates independently using the accepted upstream outcomes. Their separate ownership must be preserved.
6. **Ordering last:** review `W2-ORD-OD-01` only after participating policies are sufficiently known. Then compare deterministic sequences; do not use Ordering to decide another context's input policy.

This sequence distinguishes prerequisites from coordination: `W2-INT-02A`–`02C` coordination can run throughout, but the four candidate ballots remain blocked until their named minimum evidence exists.

## 10. Unresolved Owner questions

### Payment/Refund

- Are partial Refunds supported, and what amount/components are eligible?
- Must Refund use the original method; if an alternate method is allowed, under what bounded policy and evidence?
- How are Refund value and residuals allocated to lines and commercial components?
- Which eligibility, approval thresholds, time windows, provider outcomes, and recovery treatments apply?
- How are unknown, failed, rejected, cancelled, corrected, and repeated requests resolved and reported?

### Cancellation

- What exact financial, Preparation, Inventory, Loyalty, Promotion, customer-remedy, and Reporting outcomes apply before start, after start, and for completed exceptions?
- Which outcomes vary by prepared/fulfilled quantity or other authoritative stage evidence?

### Catalog/Pricing and Ordering

- What tax treatment, service-charge policy, rounding policy, zero/free policy, and Modifier price behavior apply?
- Which domain is accountable for tax, service charge, and rounding policy where current sources do not establish it (`OWNER_TO_CONFIRM`)?
- After each component policy is known, what Order-owned calculation sequence and line/amount allocation applies?
- How do sold-component provenance and allocation feed later Refund/cancellation without rewriting history?

## 11. Governance and technical boundary

All decision references retain their current status. This review allocates or reserves no `ODB-*` ID, records no Owner decision, and changes no readiness classification. It does not approve a formula, proportional allocation, Refund method, cancellation consequence, calculation sequence, or cross-context transaction.

No physical database design, schema, migration, database operation, persistence mechanism, index, constraint, transaction, lock, isolation level, event transport, API, service, UI, test, dependency, runtime behavior, deployment, Gate A/B/C, Flow B technical design, Control Acceptance, FOA, or Production Authorization is granted or implied.
