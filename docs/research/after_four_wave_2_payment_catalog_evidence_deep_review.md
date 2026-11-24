# AFTER FOUR — Wave 2 Payment & Catalog/Pricing Evidence Deep Review

**Status:** `INTERNAL_EVIDENCE_REVIEW — DEPENDENCIES_REMAIN_BLOCKED — NO_POLICY_OR_IMPLEMENTATION_AUTHORIZATION`

**Evidence cutoff:** 2026-11-24 (Asia/Tokyo)

**Scope:** Read-only evidence review for `P2B-CASH-OD-05`, `P2A-LOY-OD-05`, `P2A-PROMO-OD-05`, and `W2-ORD-OD-01`

## 1. Executive findings

1. Phase 1 implements a narrow exact-balance internal settlement seam for Cash and manually confirmed bank transfer. It proves local locking, replay, mismatch rejection, settlement/Dispatch atomicity, and late-success containment. It does **not** implement provider notification/query reconciliation, Refund, cancellation, partial/split tender, or runtime/public authorization.
2. Catalog Core implements Category, Product, and Variant identity/lifecycle persistence. It contains no Price, Price Version, Branch Price override, Modifier, Order Item sold snapshot, tax, service charge, rounding, or free-item implementation.
3. Owner decisions establish immutable/effective-dated Price Versions, Branch override support, Draft repricing review, locked sold price, append-only method-aware Refund direction, and late-success containment. They deliberately leave Refund methods/allocation, cancellation consequences, commercial components, and calculation order unresolved.
4. External POS/vendor examples establish only product-specific operational context. They do not establish AFTER FOUR policy, authority, calculation order, provider behavior, or accounting/legal treatment.
5. All four named candidates remain `DEPENDENCY_BLOCKED`. Parts of their evidence packages can be prepared independently, but none has enough accepted upstream facts for a policy ballot.

## 2. Evidence methodology and classification

| Class | Meaning in this review |
|---|---|
| `REPOSITORY_FACT` | Directly stated by a current repository artifact, interpreted within that artifact's maturity. |
| `OWNER_DECISION` | Explicitly approved in the canonical [Owner Decision Baseline](../architecture/after_four_owner_decision_baseline.md). |
| `IMPLEMENTED_BEHAVIOR` | Supported by an actual implementation path and relevant test source. This is bounded local/test evidence, not a production claim. |
| `EXTERNAL_VENDOR_EVIDENCE` | A vendor-specific fact retained from the [Vietnam POS evidence](after_four_wave_2_vietnam_pos_comparative_evidence.md); never AFTER FOUR policy. |
| `QUALIFIED_EVIDENCE_REQUIRED` | Requires provider/acquirer, Accounting, Tax, legal, or another qualified source. |
| `UNVERIFIED_ASSUMPTION` | Existing wording/example without current authoritative verification. |
| `OPEN_QUESTION` | A fact or Owner policy choice remains unresolved. |
| `DEPENDENCY` | Another domain or qualified source must establish the fact first. |

`NO_REPOSITORY_EVIDENCE_FOUND` is used where inspection found no supporting artifact. Tests cited below were inspected, not executed. A unit/integration test proves only its narrow setup and assertions; it does not prove production configuration, runtime authorization, provider behavior, or operational readiness.

## 3. Payment source inventory

| Source | Evidence established | Limitation |
|---|---|---|
| [Owner Decision Baseline §§2 and Consolidated P1](../architecture/after_four_owner_decision_baseline.md#2-ordering-and-payment) | `ODB-OP-02`–`16`, `P1A-OD-01`–`08`: payment gate, late success, mismatch/excess, cancellation authority, Refund direction and deferrals | Policy authority only; each row preserves its implementation exclusions. |
| [Canonical Payment Model](../architecture/after_four_payment_model.md) | Separate Payment/funding and Payment Attempt/activity vocabularies; exact-balance boundary; target reconciliation design | Sections describing provider and Refund flow exceed current implementation. |
| [P1A closure](after_four_p1a_order_payment_policy_closure.md) | Reconciles policy, implemented evidence, design proposals, and gaps `P1A-G01`–`10` | Recommendations/design evidence do not approve missing policy. |
| [Payment](../../backend/app/models/payment.rb) and [Payment Attempt](../../backend/app/models/payment_attempt.rb) | Persisted aggregate/attempt distinctions, allowed statuses/methods, validations, terminal mutation callback | Models do not create provider or Refund workflows. |
| [`Payments::Confirm`](../../backend/app/domains/payments/confirm.rb) | Exact-balance internal command, Order→Payment lock order, local replay, mismatch failure, settlement/Dispatch or late-success review | Directly creates success or mismatch failure; it is not a provider-result adapter. |
| [Cash confirmation spec](../../backend/spec/services/payments/confirm_cash_spec.rb), [bank-transfer spec](../../backend/spec/services/payments/confirm_bank_transfer_spec.rb), [late-success spec](../../backend/spec/services/payments/late_success_spec.rb) | Narrow exact-balance, replay, mismatch, manual actor evidence, and late-success examples | Source-inspected only; no Refund/provider query/runtime authorization proof. |
| [Payment DB integrity specs](../../backend/spec/integration/payment_database_integrity_spec.rb), [terminal evidence specs](../../backend/spec/models/payment_attempt_spec.rb), [concurrency specs](../../backend/spec/services/payments/concurrent_confirmation_spec.rb) | Exact succeeded evidence, aggregate consistency, terminal immutability, and at-most-one local settlement/Dispatch | PostgreSQL/local-test evidence, not provider or production evidence. |
| [State Machines §§6–10](../architecture/after_four_state_machines.md#6-payment-attempt-state-machine) | Target Attempt, settlement and Refund vocabulary | Refund/cancellation states are design evidence; Phase 1 has no Refund implementation. |

## 4. Payment lifecycle and Refund distinctions

| Topic | Classification | Evidence proves | Evidence does not prove |
|---|---|---|---|
| Payment vs Payment Attempt | `OWNER_DECISION` + `IMPLEMENTED_BEHAVIOR` | `ODB-OP-15`; separate `payments` and `payment_attempts` records/models exist. | No provider adapter, Refund aggregate, or public endpoint. |
| Attempt outcomes | `REPOSITORY_FACT`; partial `IMPLEMENTED_BEHAVIOR` | Vocabulary is `initiated`, `pending`, `unknown`, `succeeded`, `failed`, `cancelled`; terminal rows are protected. | Production command does not implement provider-driven pending/unknown reconciliation. |
| Notification vs authoritative evidence | `OWNER_DECISION` + design `REPOSITORY_FACT` | Speaker/browser assertions are not proof; unknown requires signed/query authority and no blind replacement (`ODB-OP-08`, `16`). | Provider signature, query precedence, webhook identity, and credentials are absent. |
| Duplicate/local replay | `IMPLEMENTED_BEHAVIOR` | Same local idempotency key replays; concurrent exact confirmation creates at most one success/Dispatch. | Cross-key/provider-event dedupe and retention are not proven. |
| Late success | `OWNER_DECISION` + `IMPLEMENTED_BEHAVIOR` | Held/Expired or equality/late exact success is retained; review opens; no Dispatch/reactivation. | Review disposition and customer remedy remain open. |
| Conflicting/out-of-order evidence | `OPEN_QUESTION` | Terminal evidence is immutable and authoritative reconciliation is required. | No precedence/correction taxonomy exists for notification/query conflict. |
| Full/partial Refund | `OWNER_DECISION` principle + design `REPOSITORY_FACT` | Append-only, method-aware, authoritatively reconciled, cumulative success capped at refundable value; partial/full vocabulary exists. | Whether partial Refund is offered, eligible components, formula, method, threshold, and execution. |
| Refund lifecycle | Design `REPOSITORY_FACT` | Proposed states: requested, approval-required, approved, processing, unknown, succeeded, failed, rejected, cancelled. | `NO_REPOSITORY_EVIDENCE_FOUND` for a Refund model/table/use case/test. |
| Original/alternate method | `OPEN_QUESTION` + `QUALIFIED_EVIDENCE_REQUIRED` | “Method-aware” requires an explicit outcome. | Neither original-only nor alternate-method permission is approved. |
| Multi-tender allocation | `OWNER_DECISION — DEFERRED` + `DEPENDENCY` | `P1A-OD-01` keeps exact balance and `partially_paid` command-unreachable. | No allocation record, target, rounding, cancellation or Refund allocation exists. |
| Repeated Refund commands/results | Design `REPOSITORY_FACT` | Semantic intent is apply once and preserve original evidence. | No Refund idempotency/provider-event uniqueness implementation. |
| Mismatch/excess | `OWNER_DECISION`; narrow `IMPLEMENTED_BEHAVIOR` | Non-exact local confirmation is failed/no-dispatch; excess is not revenue and needs evidence/refund. | Excess record/refund path, authority and provider/Cash effect are absent. |
| Cancellation stages | `OWNER_DECISION`; `NO_REPOSITORY_EVIDENCE_FOUND` for implementation | Staff-before-start, Owner-after-start, separate completed exception. | Refund, stock, benefits, compensation and Reporting consequences are deferred. |
| Cash effect | `OPEN_QUESTION` | Payment truth and Cash drawer truth are separate. | A Refund label does not establish actual drawer outflow. |
| Generic `reversed` state | `NO_REPOSITORY_EVIDENCE_FOUND` | Canonical Attempt status list has no `reversed`. | A provider-specific correction/reversal state must not be invented. |

## 5. Synthetic Payment scenarios

All people, identifiers, amounts, methods and events below are synthetic. They expose questions; they do not select policy.

| # | Synthetic facts and sequence | Known authoritative facts | Competing possible outcomes / unresolved facts | Evidence needed and downstream effects |
|---|---|---|---|---|
| P1 | One Cash tender funds 100,000 VND; request full Refund. | Append-only, capped, preserve original settlement. | Success/failure/rejection/cancellation/unknown; actual drawer outflow unresolved. | Method/authority/provider or Cash evidence; Loyalty/Promotion/Reporting treatment. |
| P2 | One 100,000 tender; successful 30,000 Refund then 20,000 request. | Cumulative success ≤ refundable value. | Eligibility, residual allocation, repeated identity and rounding. | Line/component allocation and authoritative outcomes. |
| P3 | Hypothetical 60,000 Cash + 40,000 bank funding. | Split tender is deferred. | Priority/proportional/other allocation cannot be assumed. | Owner tender policy plus Payment/Cash/Accounting evidence. |
| P4 | Original method is unavailable at Refund time. | Refund direction is method-aware. | Original-only failure, alternate method, or held resolution are unresolved. | Provider/acquirer capability and Owner method policy. |
| P5 | Provider call times out; later notification says success. | Timeout is not failure; unknown blocks blind replacement. | Whether notification is authoritative; query precedence. | Signature/query authority and event identity. |
| P6 | Exact success arrives after Order expiration. | Preserve funding, open review, no Dispatch/reactivation; narrow path implemented. | Separately approved Refund, replacement/new Order, or no-dispatch disposition. | Review authority and downstream remedy. |
| P7 | Same provider success notification arrives twice. | Apply semantic result once; local same-key replay is implemented narrowly. | Provider event identity, cross-key duplicate and retention. | Provider contract; prevent duplicate Cash/Loyalty/Promotion effects. |
| P8 | Notification says success; authoritative query says failed, or vice versa. | Reconciliation required; terminal evidence not silently rewritten. | Authority precedence, dispute, linked correction. | Provider evidence hierarchy and Accounting/Reporting treatment. |
| P9 | Approved Refund remains unknown, later becomes successful. | Design allows reconciliation; success cap/append-only principles apply. | No implemented Refund flow or downstream timing rule. | Provider result contract and allocation. |
| P10 | Refund fails; a separately authorized retry is requested. | Failure is not success; original evidence remains. | Same/new intent, approval reuse, method change, retry limits. | Owner retry/authority and provider idempotency evidence. |
| P11 | Paid cancellation before Preparation. | Staff authority with reason/audit. | Refund, stock, benefits, compensation and Reporting. | `P1A-OD-04` consequence matrix and affected-domain facts. |
| P12 | Paid cancellation after partial Preparation. | Owner approval; work/history preserved. | Full/partial/no Refund; waste/remake/stock/benefits/remedy. | Preparation/Inventory, Payment, Loyalty/Promotions, Accounting. |
| P13 | Completed Order exception requested. | Separate from ordinary cancellation. | Authority, remedy and Refund eligibility are deferred. | `P1A-OD-05` plus affected-domain evidence. |

## 6. Catalog/Pricing source inventory

| Source | Evidence established | Limitation |
|---|---|---|
| [Owner Decision Baseline §5](../architecture/after_four_owner_decision_baseline.md#5-catalogpricing-mvp) | `ODB-CAT-04`, `07`–`10`: persisted Variant, Branch override, immutable/effective Price Version, Draft review, sold-price lock | Commercial component and implementation exclusions remain controlling. |
| [Catalog/Pricing Discovery](../architecture/after_four_catalog_pricing_discovery.md) | Owner closures, ownership and explicit unresolved list | Logical consequences are not physical/runtime implementation. |
| [Real Menu & Pricing Specification](../architecture/after_four_real_menu_pricing_specification.md) | Owner-input template and `TBD` inventory | Blank/TBD/example rows are not approved data. |
| [P1B reconciliation](after_four_p1b_catalog_current_state_reconciliation.md) | Precisely separates Package B Catalog Core evidence from absent Price/Availability/Modifier/menu runtime | No Price implementation authorization. |
| [Catalog foundation migration](../../backend/db/migrate/20261115210000_create_catalog_core_foundation.rb), [Variant record](../../backend/app/domains/catalog/infrastructure/persistence/product_variant_record.rb), [record specs](../../backend/spec/domains/catalog/infrastructure/persistence/catalog_records_spec.rb) | Product/Variant identity, relationships and lifecycle persistence | No Price, Modifier, tax, service charge, rounding or sold snapshot. Tests were inspected, not executed. |
| [Order draft](../../backend/app/domains/orders/create_draft.rb) and [Order confirm](../../backend/app/domains/orders/confirm.rb) | Current command accepts `total_amount` and confirms it | No Order Items, Catalog lookup, Price Version, quote-review, component calculation or sold provenance. |
| [Vietnam POS evidence](after_four_wave_2_vietnam_pos_comparative_evidence.md) | Vendor examples of discounts/tax/service fees/channel pricing | Context only; not a portable formula, authority, or legal basis. |

## 7. Commercial component gaps

| Topic | Classification | Established fact | Missing fact/policy |
|---|---|---|---|
| Product/sellable Variant | `OWNER_DECISION` + bounded `IMPLEMENTED_BEHAVIOR` | Every sellable selection uses persisted Variant; Product/Variant tables exist. | No selling/menu operation or real Price data. |
| Chain default/Branch override | `OWNER_DECISION` | Explicit Branch override, otherwise chain default. | No Price table/runtime, actual override, publication authority, or conflict rule. |
| Effective Price Version | `OWNER_DECISION` | Immutable/effective-dated; correction creates a new version. | No interval inclusivity, timezone, overlap/tie selection, persistence or test. |
| Draft repricing | `OWNER_DECISION` | Revised quote review before confirmation. | Current `Orders::Confirm` does no Catalog lookup/version check; UX/contract/concurrency unresolved. |
| Sold Price | `OWNER_DECISION` | Locked at confirmation; later Catalog changes cannot rewrite it. | No Order Items/component snapshot or source-version provenance implemented. |
| Actual menu/Price | `UNVERIFIED_ASSUMPTION` | Template contains blanks/TBDs; individual proposal rows are not approved. | Actual launch Variant, Modifier and Branch Price facts. |
| Modifier price | `OPEN_QUESTION` | Modifier cardinality is approved. | Whether/how modifiers affect Price, negative/zero delta, history and Refund treatment. |
| Promotion attribution | `DEPENDENCY` | Promotions owns benefit attribution/allocation; Catalog Price remains separate. | Applied line/component provenance, caps/floors, interaction and reversal. |
| Loyalty attribution | `DEPENDENCY` | Loyalty owns redemption/earning facts. | Eligible components, rate/limits, order, rounding and Refund allocation. |
| Tax | `QUALIFIED_EVIDENCE_REQUIRED` + `OPEN_QUESTION` | No approved inclusion/exclusion/basis/order. | Applicable law/tax evidence, accountable policy and invoice treatment. |
| Service charge | `QUALIFIED_EVIDENCE_REQUIRED` + `OPEN_QUESTION` | No approved policy or basis. | Applicability, base, interaction, reversal and Reporting. |
| Precision/rounding | `QUALIFIED_EVIDENCE_REQUIRED` + `OPEN_QUESTION` | No approved unit, precision, stage, tie rule or residual allocation. | Line/Order/component and Refund treatment. |
| Zero/free item | `OPEN_QUESTION` | Free item is exploratory; no zero-price Catalog rule. | Provenance, tax/service/rounding, sold snapshot and Refund/cancellation behavior. |
| Calculation order | `DEPENDENCY` + `OPEN_QUESTION` | Ordering owns sequence/allocation; component domains retain policy. | Entire deterministic sequence and residual rules. |

## 8. Synthetic Catalog/Pricing scenarios

All numerical examples are hypothetical illustrations only. They do not recommend a formula or represent approved menu data.

| # | Synthetic input | Competing interpretation / differing result | Required evidence; must remain undecided |
|---|---|---|---|
| C1 | Chain Price 50,000; no Branch override. | Owner direction implies chain version supplies input. | Effective version selection implementation and actual Price remain absent. |
| C2 | Chain 50,000; Branch override 55,000 effective before confirmation. | Branch input would be 55,000 if its version is uniquely effective. | Interval/timezone/publication facts. |
| C3 | Override changes 50,000→55,000 immediately before confirmation. | Old/new quote depends on authoritative boundary and review timing. | Interval semantics, quote/version token, concurrency; no boundary selected. |
| C4 | Price changes 50,000→55,000 immediately after confirmation. | Confirmed sale stays 50,000; current Catalog becomes 55,000. | Snapshot representation/provenance; no rewrite. |
| C5 | Draft quote 50,000; current Price becomes 55,000. | Owner policy requires revised-quote review, not silent confirmation. | Review UX/authority/version contract. |
| C6 | Published 55,000 was wrong; corrected Price is 53,000. | New immutable version, not rewrite; past sold evidence unchanged. | Effective boundary and correction authority. |
| C7 | Base 50,000; Modifier delta 0, +5,000, or −5,000. | Illustrative totals 50,000/55,000/45,000 only under simple-add assumption. | Whether deltas exist, eligibility, floor, tax and history; simple addition remains unapproved. |
| C8 | Two lines 50,000 and 30,000; hypothetical 10,000 Promotion. | Line-specific, proportional or Order-level attribution differ. | Promotion allocation policy; no method selected. |
| C9 | Subtotal 100,000; hypothetical 10,000 Promotion and 20,000 Loyalty redemption. | Promotion-first gives an illustrative 70,000; Loyalty-first may affect eligibility/caps differently. | Component policies and Ordering sequence. |
| C10 | Displayed 110,000 with hypothetical 10% tax. | Tax-inclusive base could be 100,000; tax-exclusive 100,000 could total 110,000. | Qualified tax basis/applicability/invoice evidence; neither alternative selected. |
| C11 | Subtotal 100,000; hypothetical 5% service charge. | Basis before/after a 10,000 discount yields illustrative 5,000 vs 4,500. | Applicability, basis and order remain open. |
| C12 | Three hypothetical line results 33.335 each. | Line rounding may total 100.02/100.01 depending rule; Order rounding of 100.005 may differ. | Currency precision, tie rule, stage and residual allocation. |
| C13 | Free item list Price 40,000 with other components. | Zero sold Price, Promotion benefit, or complimentary adjustment have different tax/provenance/refund effects. | Zero/free taxonomy and qualified tax/accounting evidence. |
| C14 | Version A ends exactly when B starts. | Boundary instant could select A, B, neither, or conflict absent approved interval semantics. | Timezone, inclusivity and overlap/tie policy; do not infer `[start,end)`. |

## 9. Cross-domain dependency matrix

| Candidate | Owner-established facts | Design facts | Implemented facts | Vendor context | Missing qualified evidence / Owner policy | Partial progress and next internal action |
|---|---|---|---|---|---|---|
| `P2B-CASH-OD-05` | Refund direction is append-only/method-aware; Payment and Cash truth remain separate. | Refund lifecycle and method-aware outcome vocabulary. | Exact Cash/Bank settlement only; no Refund/drawer effect. | Sapo/KiotViet return/cancel examples only. | Provider result/method, original/alternate rail, allocation, actual Cash movement, Accounting/Reporting. | Inventory tender assumptions and synthetic outcomes; candidate remains blocked. |
| `P2A-LOY-OD-05` | Loyalty owns reversal; proportionality is not implied. | Linked-history/reversal inputs. | No Loyalty or Refund implementation. | Discounted-return recalculation example only. | Allocated successful Refund/cancellation, eligible paid components, points basis, timing, residual rounding. | Prepare consequence matrix after Payment/component evidence; remain blocked. |
| `P2A-PROMO-OD-05` | Promotions owns benefit allocation/release/reversal; sold history remains immutable. | Applied-benefit provenance needed. | No Promotion/Refund/Order Item implementation. | Vendor return/cancel and component examples only. | Applied discount attribution, commercial component sequence, Refund/cancellation allocation, tax/service/rounding. | Inventory provenance fields/scenarios without selecting formula; remain blocked. |
| `W2-ORD-OD-01` | Catalog owns Price; Ordering owns sold snapshot and calculation sequence; component domains retain policy. | Candidate component inventory and coordination contracts. | Draft accepts caller-supplied total; no Catalog-backed calculation/snapshot. | Vendors show components exist. | Actual Price/Modifier, Promotion/Loyalty, tax, service charge, rounding, zero/free, correction inputs and qualified options. | Produce source-indexed component sheets; compare sequences only after inputs close; remain blocked. |

Dependency trace: `Payment/Refund → Cash`; `Payment/Refund + sold allocation → Loyalty`; `Payment/Refund + applied Promotion attribution → Promotions`; `Catalog Price + Modifier + Promotion + Loyalty + Tax + Service Charge + Rounding → Ordering`.

There is no necessary circular ownership: each component domain supplies its facts and owns its consequence policy; Ordering coordinates a sequence after inputs exist. A circularity appears only if Ordering is incorrectly asked to define missing Payment, Promotion, Loyalty, Tax, or Catalog policy.

## 10. Contradictions and ownership ambiguities

| Issue | Exact evidence | Ambiguity / clarification question |
|---|---|---|
| Rich Refund states vs no implementation | [State Machines §10](../architecture/after_four_state_machines.md#10-refund-state-machine); [P1A §4](after_four_p1a_order_payment_policy_closure.md#4-reconciliation-findings) | Which vocabulary will be retained for a later ballot versus treated only as design history? |
| `partially_refunded` field vs no allocation | [Payment Model §2.1](../architecture/after_four_payment_model.md#21-funding-status); `P1A-OD-03` | Does Owner permit partial Refund, and what is its allocation object? |
| Provider-result design vs direct local success command | [Payment Model §5](../architecture/after_four_payment_model.md#5-reconciliation-and-concurrency); [`Payments::Confirm`](../../backend/app/domains/payments/confirm.rb) | Which method/provider evidence contract is authoritative before electronic reconciliation can be designed? |
| Cancellation authority vs consequence | `ODB-OP-12`–`14`; `P1A-OD-04/05` | What stage-specific outcomes apply without reopening authority? |
| Effective-dated Price vs undefined boundary | `ODB-CAT-08`; [Catalog discovery §4](../architecture/after_four_catalog_pricing_discovery.md#4-unresolved-decisions-preserved) | Which business timezone, inclusivity, overlap and tie semantics apply? |
| Sold Price vs full commercial snapshot | `ODB-CAT-10`; [P1B §4](after_four_p1b_catalog_current_state_reconciliation.md#4-canonical-terminology-and-ownership) | Which immutable component/provenance facts comprise the sold total? |
| Caller-supplied Order total vs future authoritative Catalog calculation | [`Orders::CreateDraft`](../../backend/app/domains/orders/create_draft.rb) | Current bounded implementation is not proof of a future Price authority contract; what replaces caller-supplied totals after policy/design approval? |
| Tax/service/rounding ownership | [Upstream evidence §5.1](after_four_wave_2_upstream_commercial_dependency_evidence_review.md#51-ownership-boundary) | Accountable policy owner is not fully established; qualified evidence and Owner confirmation are required. |

## 11. Qualified evidence still required

- Provider/acquirer: supported methods, notification/query authority, event identity, delayed/conflicting outcomes, original-tender Refund capability, unknown/retry behavior and limitations.
- Payment/Accounting/Reporting: full/partial eligibility, alternate rail, multi-tender/line/component allocation, mismatch/excess, reconciliation and reporting classifications.
- Catalog/Pricing: actual Price Versions, Branch overrides, Modifier effects, publication facts and effective-time requirements.
- Qualified Vietnamese Tax/Accounting/legal review: tax inclusion/basis/invoice treatment, service charge, rounding/residuals, free items, discounts/Loyalty and Refund/cancellation consequences.
- Component domains: Promotion attribution/reversal and Loyalty earning/redemption/reversal facts.

`EU-W2-PAY-01` and `EU-W2-CAT-01` remain `PENDING — NOT_SENT — NOT_READY_FOR_OWNER_AUTHORIZATION`. No recipient, message, disclosure or engagement is prepared here.

## 12. Precisely framed future Owner questions

1. Is partial Refund supported, for which eligible value/components, and under what evidence/authority boundary?
2. Which Refund methods are permitted when the original method is available or unavailable, after provider/accounting constraints are known?
3. If partial/split tender is later reconsidered, what allocation object and deterministic Refund/cancellation rules are required?
4. Which stage-specific cancellation and completed-exception commercial outcomes are permitted after affected-domain evidence is assembled?
5. What actual Variant, Modifier and Branch Price facts are approved, and who may publish/correct Price Versions?
6. What business timezone and effective-interval semantics govern Price selection?
7. Are Modifier deltas, zero-price and complimentary/free items permitted, and what provenance is required?
8. After qualified evidence, which tax/service-charge/rounding policies and deterministic Ordering calculation sequence are approved?
9. After upstream closure, what Cash, Loyalty and Promotion consequences follow each authoritative Refund/cancellation outcome?

These questions are preparation only. They are not ballots and do not preselect answers.

## 13. Recommended next internal work packages

1. **Payment implementation-evidence appendix:** freeze the exact current command/model/constraint/test inventory and explicitly mark absent provider/Refund/cancellation capabilities.
2. **Provider evidence question set:** factual fields and synthetic outcomes only; retain `NOT_SENT` until separate commissioning authorization.
3. **Commercial component fact sheets:** one bounded sheet each for Price/Modifier, Promotion, Loyalty, Tax, service charge and rounding, with accountable domain and qualified-evidence gap.
4. **Synthetic calculation corpus:** preserve all alternative outcomes and residuals without recommendation; use no real data.
5. **Cross-domain consequence matrices:** prepare Cash, Loyalty and Promotions inputs in parallel, but do not promote candidates until upstream authoritative facts exist.
6. **Ordering sequence package last:** compare deterministic sequences only after component policies are stable or explicitly excluded by Owner decision.

## 14. Explicit non-authorization and source index

This review records no Owner decision; allocates, reserves or proposes no `ODB-*` ID; and changes no canonical status, 55-candidate reconciliation, six coordinator scopes or nine request mappings. All four candidates remain `DEPENDENCY_BLOCKED`; all nine external evidence requests remain `PENDING — NOT_SENT — NOT_READY_FOR_OWNER_AUTHORIZATION`.

It authorizes no external contact, disclosure, provider/professional engagement, procurement, physical schema, migration, database operation, persistence, transaction, locking, isolation, API, source code, test, dependency, runtime behavior, deployment, Gate A/B/C, Control Acceptance, FOA or Production Authorization.

Primary repository index:

- [Owner Decision Baseline](../architecture/after_four_owner_decision_baseline.md)
- [Payment Model](../architecture/after_four_payment_model.md)
- [Catalog/Pricing Discovery](../architecture/after_four_catalog_pricing_discovery.md)
- [Real Menu & Pricing Specification](../architecture/after_four_real_menu_pricing_specification.md)
- [P1A Order/Payment Closure](after_four_p1a_order_payment_policy_closure.md)
- [P1B Catalog Reconciliation](after_four_p1b_catalog_current_state_reconciliation.md)
- [Payment/Catalog Internal Fact Manifest](after_four_wave_2_payment_catalog_internal_fact_manifest.md)
- [Upstream Commercial Dependency Review](after_four_wave_2_upstream_commercial_dependency_evidence_review.md)
- [Cross-Domain Evidence Synthesis](after_four_wave_2_cross_domain_evidence_synthesis.md)
- [Owner-Managed Evidence Register](after_four_wave_2_owner_managed_evidence_register.md)
- [Vietnam POS Comparative Evidence](after_four_wave_2_vietnam_pos_comparative_evidence.md)
- [Cash Discovery](after_four_p2b_cash_domain_discovery.md), [Loyalty Discovery](after_four_p2a_loyalty_policy_discovery.md), and [Promotions Discovery](after_four_p2a_promotions_policy_discovery.md)
