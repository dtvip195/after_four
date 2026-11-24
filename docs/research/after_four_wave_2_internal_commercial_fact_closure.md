# AFTER FOUR — Wave 2 Internal Commercial Fact Closure

**Work package:** `W2-COM-04`

**Status:** `INTERNAL_EVIDENCE_REVIEW_COMPLETE — EVIDENCE_INCOMPLETE — OWNER_REVIEW_REQUIRED — POLICY_AND_IMPLEMENTATION_NOT_AUTHORIZED`

**Evidence cutoff:** 2026-11-24 (Asia/Tokyo)

## 1. Purpose, scope and non-authority statement

This review follows [W2-COM-03](after_four_wave_2_commercial_evidence_gap_closure_review.md) and closes only facts directly verifiable from the current repository. It covers Catalog/Pricing, Promotions, Loyalty, Payment/Refund, and Service Charge/monetary precision. It records no Owner decision, professional conclusion, technical-design approval, implementation authorization, or canonical candidate-status change.

The local gap statuses in this document assess evidence completeness only. `P2B-CASH-OD-05`, `P2A-LOY-OD-05`, `P2A-PROMO-OD-05`, and `W2-ORD-OD-01` remain canonically `DEPENDENCY_BLOCKED`. Ordering remains only a proposed coordination candidate for a future Order-level sequence/allocation decision; it has no authority to decide another domain's policy.

## 2. Sources inspected and evidence limitations

The review inspected the [Owner Decision Baseline](../architecture/after_four_owner_decision_baseline.md), [ADR-0011](../architecture/adr/0011-project-wide-layered-ddd.md), [W2-COM-02](after_four_wave_2_commercial_component_evidence_packages.md), [Payment/Catalog Deep Review](after_four_wave_2_payment_catalog_evidence_deep_review.md), [Internal Fact Manifest](after_four_wave_2_payment_catalog_internal_fact_manifest.md), Catalog/Pricing, Promotions, Loyalty and Payment domain documents, and current backend source, migrations and focused specs.

Line references below identify the reviewed revision. `TESTED_BEHAVIOR` means a checked-in spec asserts the behavior; those specs were inspected but not executed for this documentation task. A repository search finding no matching production artifact is classified `REPOSITORY_FACT` or `NOT_IMPLEMENTED`, not proof that a business policy does not exist. No database, application, test, provider or external-evidence command was executed.

| Classification | Meaning |
|---|---|
| `OWNER_APPROVED_POLICY` | Explicit canonical Owner direction; it is not implementation evidence. |
| `APPROVED_DESIGN_DIRECTION` | Approved design constraint, not necessarily implemented behavior. |
| `IMPLEMENTED_BEHAVIOR` | Current production source implements the narrow stated behavior. |
| `REPOSITORY_FACT` | Current repository structure or artifact supports the statement. |
| `TESTED_BEHAVIOR` | A checked-in spec asserts the behavior; execution is not claimed here. |
| `VENDOR_CONTEXT` | Vendor-specific context only; never AFTER FOUR policy. |
| `QUALIFIED_EXTERNAL_EVIDENCE` | Evidence requiring a qualified/provider source outside this internal review. |
| `OPEN_QUESTION` | Owner or domain policy remains unresolved. |
| `NOT_IMPLEMENTED` | Reviewed production paths do not implement the stated behavior. |
| `NOT_VERIFIED` | Available repository evidence cannot establish the claim. |

## 3. Executive closure summary

| Local closure status | Count | Conclusion |
|---|---:|---|
| `CLOSED_BY_REPOSITORY_EVIDENCE` | 3 | Persisted sellable identity, narrow local Payment confirmation, and current integer amount representation are directly established. |
| `PARTIALLY_CLOSED` | 5 | Repository or approved policy closes only part of the Price, Promotion-administration, late-success and legal-source questions. |
| `INTERNAL_EVIDENCE_REQUIRED` | 1 | Sold-price provenance remains absent from the current Order representation and requires actual internal commercial facts. |
| `OWNER_DECISION_REQUIRED` | 5 | Repository evidence cannot decide business policy. |
| `QUALIFIED_EVIDENCE_REQUIRED` | 3 | Provider, Vietnamese Tax/Accounting or other qualified evidence is required. |
| `DEPENDENCY_BLOCKED` | 10 | Upstream commercial facts or decisions remain unresolved. |
| `NOT_VERIFIED` | 0 | Absences were bounded to inspected paths; no unsupported positive claim is treated as verified. |

The only changed local closure result from W2-COM-03 is `W2-COM03-CAT-01`: its exact question—whether sellable Product/Variant identity is persisted—is now closed by direct migration, record and spec evidence. This does not close Price, Modifier or selling behavior.

## 4. Workstream A — Catalog/Pricing fact register

| Fact/claim | Classification | Exact source | Proves | Does not prove | Related gaps | Exact candidate impact | Closure / next action |
|---|---|---|---|---|---|---|---|
| Product and Variant identity, Brand ancestry, lifecycle fields and one-default-Variant constraint are persisted. | `IMPLEMENTED_BEHAVIOR`; `TESTED_BEHAVIOR` | `backend/db/migrate/20261115210000_create_catalog_core_foundation.rb:61-143`; `backend/app/domains/catalog/infrastructure/persistence/product_variant_record.rb:4-45`; `backend/spec/domains/catalog/infrastructure/persistence/catalog_records_spec.rb:8-40` | Category→Product→Variant persistence and bounded identity facts. | Price, Modifier price, availability or sellability policy. | `W2-COM03-CAT-01` | `P2A-LOY-OD-05`, `P2A-PROMO-OD-05`, `W2-ORD-OD-01` | `CLOSED_BY_REPOSITORY_EVIDENCE`; retain the stated limits. |
| No Price, Price-version, Branch override or Modifier-price field/table appears in the Catalog Core migration or persistence records. | `REPOSITORY_FACT`; `NOT_IMPLEMENTED` | `backend/db/migrate/20261115210000_create_catalog_core_foundation.rb:25-143`; `backend/app/domains/catalog/infrastructure/persistence/product_record.rb:4-34`; `backend/app/domains/catalog/infrastructure/persistence/product_variant_record.rb:4-45`; production-artifact inventory across `backend/app`, `backend/db/migrate`, and `backend/spec` at cutoff | Current Catalog Core does not implement these commercial objects. | That approved Price policy is invalid or what future representation must be. | `W2-COM03-CAT-02`, `W2-COM03-CAT-03`, `W2-COM03-CAT-06`, `W2-COM03-CAT-07` | `P2A-LOY-OD-05`, `P2A-PROMO-OD-05`, `W2-ORD-OD-01`; `P2B-CASH-OD-05` only where Refund consequences apply | Preserve open/blocked statuses; collect actual commercial facts before design. |
| Draft creation accepts caller-supplied `total_amount`; Order confirmation performs no Catalog lookup or repricing comparison. | `IMPLEMENTED_BEHAVIOR`; `TESTED_BEHAVIOR` | `backend/app/domains/orders/create_draft.rb:7-59`; `backend/app/domains/orders/confirm.rb:5-58`; `backend/spec/services/orders/confirm_spec.rb:3-58` | Current command boundary and absence of repricing enforcement in that flow. | Correct Price, quote authority, Price-version provenance or revised-quote UX. | `W2-COM03-CAT-04` | `P2A-LOY-OD-05`, `P2A-PROMO-OD-05`, `W2-ORD-OD-01` | `DEPENDENCY_BLOCKED`; define facts before a contract. |
| Draft creation accepts caller-supplied `total_amount`; the current Order retains no sold component or Price-version provenance. | `IMPLEMENTED_BEHAVIOR`; `TESTED_BEHAVIOR` | `backend/app/domains/orders/create_draft.rb:7-59`; `backend/app/domains/orders/confirm.rb:5-58`; `backend/spec/services/orders/confirm_spec.rb:3-58` | Current aggregate-total command boundary and absence of sold-price provenance in that flow. | Correct Price, quote authority, Price-version provenance or revised-quote UX. | `W2-COM03-CAT-05` | `P2A-LOY-OD-05`, `P2A-PROMO-OD-05`, `W2-ORD-OD-01`; `P2B-CASH-OD-05` indirectly through Refund | `INTERNAL_EVIDENCE_REQUIRED`; define facts before a contract. |

## 5. Workstream B — Promotions fact register

| Fact/claim | Classification | Exact source | Proves | Does not prove | Related gaps | Exact candidate impact | Closure / next action |
|---|---|---|---|---|---|---|---|
| Promotion scope, stacking-group/priority and lifecycle-administration directions exist only as Owner policy/document evidence. | `OWNER_APPROVED_POLICY` | `docs/architecture/after_four_owner_decision_baseline.md` entries `P2A-PROMO-OD-02`, `P2A-PROMO-OD-03`, `P2A-PROMO-OD-07A`, `P2A-PROMO-OD-07B`, `P2A-PROMO-OD-07C`, `P2A-PROMO-OD-07D`, `P2A-PROMO-OD-07E`, `P2A-PROMO-OD-07F`, `P2A-PROMO-OD-07G`, `P2A-PROMO-OD-07H`, `P2A-PROMO-OD-07I`, `P2A-PROMO-OD-07J`; `docs/research/after_four_p2a_promotions_policy_discovery.md` | Approved boundaries and unresolved policy vocabulary. | Runtime eligibility, formula, allocation, provenance or authority enforcement. | `W2-COM03-PRO-01`, `W2-COM03-PRO-02`, `W2-COM03-PRO-04` | `P2A-PROMO-OD-05`, `W2-ORD-OD-01` | Keep `OWNER_DECISION_REQUIRED`/`PARTIALLY_CLOSED`; no formula inference. |
| No Promotion production model, command, migration or focused spec was found in the inspected backend paths. | `REPOSITORY_FACT`; `NOT_IMPLEMENTED` | Repository inventory of `backend/app`, `backend/db/migrate`, and `backend/spec` at the cutoff | No current internal implementation evidence for Promotion evaluation or applied benefit. | Absence of business need or which future implementation is correct. | `W2-COM03-PRO-01`, `W2-COM03-PRO-02`, `W2-COM03-PRO-03`, `W2-COM03-PRO-04` | `P2A-PROMO-OD-05`, `W2-ORD-OD-01`; `P2B-CASH-OD-05` where Refund applies | Applied-benefit provenance and reversal remain `DEPENDENCY_BLOCKED`. |
| Current Order records only an aggregate caller-supplied total, not Promotion attribution. | `IMPLEMENTED_BEHAVIOR` | `backend/app/domains/orders/create_draft.rb:39-59`; `backend/db/migrate/20261114192000_create_order_payment_foundation.rb:5-36` | No Promotion provenance is recorded by this command/schema. | Whether another future boundary should own or retain Promotion evidence. | `W2-COM03-PRO-03` | `P2A-PROMO-OD-05`, `P2B-CASH-OD-05`, `W2-ORD-OD-01` | Remains `DEPENDENCY_BLOCKED`; first define source-domain provenance. |

## 6. Workstream C — Loyalty fact register

| Fact/claim | Classification | Exact source | Proves | Does not prove | Related gaps | Exact candidate impact | Closure / next action |
|---|---|---|---|---|---|---|---|
| Loyalty earning requires authoritative successfully settled eligible value; redemption requires bounded value/order/rounding policy. | `OWNER_APPROVED_POLICY` | Baseline entries `P2A-LOY-OD-01`, `P2A-LOY-OD-02`; `docs/research/after_four_p2a_loyalty_policy_discovery.md` | Directional prerequisites. | Eligible components, rate, point unit, limits, tie mode or residual rule. | `W2-COM03-LOY-01`, `W2-COM03-LOY-02` | `P2A-LOY-OD-05`, `W2-ORD-OD-01` | Remains blocked/Owner-required pending component facts. |
| Local Payment exposes aggregate successful settlement only; it does not identify Loyalty-eligible components. | `IMPLEMENTED_BEHAVIOR` | `backend/app/models/payment.rb:1-16`; `backend/app/domains/payments/confirm.rb:60-78` | Aggregate target/success/refund counters and local full settlement. | Earnable basis, points value, ledger or provider-authoritative settlement. | `W2-COM03-LOY-01` | `P2A-LOY-OD-05`, `W2-ORD-OD-01` | `DEPENDENCY_BLOCKED`; sold components and qualified Payment outcome are prerequisites. |
| No Loyalty ledger, earn/redeem command, reversal workflow or focused spec was found in inspected backend paths. | `REPOSITORY_FACT`; `NOT_IMPLEMENTED` | Repository inventory of `backend/app`, `backend/db/migrate`, and `backend/spec` | No internal behavior supports earning, redemption, negative balance or reversal. | Future Loyalty policy or architecture. | `W2-COM03-LOY-01`, `W2-COM03-LOY-02`, `W2-COM03-LOY-03` | `P2A-LOY-OD-05`, `W2-ORD-OD-01` | Owner decisions and upstream Refund/component evidence remain required. |

## 7. Workstream D — Payment/Refund fact register

| Fact/claim | Classification | Exact source | Proves | Does not prove | Related gaps | Exact candidate impact | Closure / next action |
|---|---|---|---|---|---|---|---|
| Local cash/bank-transfer confirmation locks Order and Payment, enforces exact amount/currency, records one attempt, and updates aggregate settlement atomically. | `IMPLEMENTED_BEHAVIOR`; `TESTED_BEHAVIOR` | `backend/app/domains/payments/confirm.rb:12-102,114-164`; `backend/app/domains/payments/confirm_cash.rb:1-6`; `backend/app/domains/payments/confirm_bank_transfer.rb:1-6`; `backend/spec/services/payments/confirm_cash_spec.rb:3-158` | Narrow local command behavior and checked-in expectations. | Provider-originated authority, public API, split tender or Refund behavior. | `W2-COM03-PAY-01` | `P2B-CASH-OD-05`, `P2A-LOY-OD-05`, `P2A-PROMO-OD-05`, `W2-ORD-OD-01` | `CLOSED_BY_REPOSITORY_EVIDENCE`; do not broaden the seam. |
| Same-key replay is verified; competing confirmations serialize and only one succeeds in the checked-in concurrency spec. | `IMPLEMENTED_BEHAVIOR`; `TESTED_BEHAVIOR` | `backend/app/domains/payments/confirm.rb:40-58,237-253`; `backend/spec/services/payments/confirm_cash_spec.rb:85-158`; `backend/spec/services/payments/concurrent_confirmation_spec.rb:3-72` | Local request idempotency and row-lock containment. | Provider-event identity, signature, deduplication or conflicting provider outcomes. | `W2-COM03-PAY-01`, `W2-COM03-PAY-02` | `P2B-CASH-OD-05`, `P2A-LOY-OD-05`, `P2A-PROMO-OD-05` | Provider evidence remains `QUALIFIED_EVIDENCE_REQUIRED`. |
| A local late confirmation for Held/Expired Order records settlement, opens `late_success` review, and creates no dispatch. | `IMPLEMENTED_BEHAVIOR`; `TESTED_BEHAVIOR` | `backend/app/domains/payments/confirm.rb:80-97,167-214`; `backend/spec/services/payments/late_success_spec.rb:3-82` | Bounded local containment. | Provider notification/query handling or authoritative provider reconciliation. | `W2-COM03-PAY-03` | `P2B-CASH-OD-05`, `P2A-LOY-OD-05`, `P2A-PROMO-OD-05`, `W2-ORD-OD-01` indirectly | `PARTIALLY_CLOSED`; provider scenarios remain hypothetical. |
| Funding vocabulary includes refunded counters/statuses, but no executable Refund workflow or allocation record was found. | `REPOSITORY_FACT`; `NOT_IMPLEMENTED` | `backend/db/migrate/20261114192000_create_order_payment_foundation.rb:38-73`; `backend/app/models/payment.rb:1-16`; production-artifact inventory across `backend/app`, `backend/db/migrate`, and `backend/spec` | Storage vocabulary and integrity bounds only. | Refund eligibility, method, authority, rail, allocation or drawer consequence. | `W2-COM03-PAY-04`, `W2-COM03-PAY-05`, `W2-COM03-PAY-06` | `P2B-CASH-OD-05`, `P2A-LOY-OD-05`, `P2A-PROMO-OD-05`, `W2-ORD-OD-01` | Remain `DEPENDENCY_BLOCKED`; provider and Owner evidence required. |

## 8. Workstream E — Service Charge and monetary precision fact register

| Fact/claim | Classification | Exact source | Proves | Does not prove | Related gaps | Exact candidate impact | Closure / next action |
|---|---|---|---|---|---|---|---|
| Order, Payment and PaymentAttempt amounts are integer-backed; currency code is constrained to three uppercase characters. | `IMPLEMENTED_BEHAVIOR`; `TESTED_BEHAVIOR` | `backend/db/migrate/20261114192000_create_order_payment_foundation.rb:5-73`; `backend/app/models/payment.rb:10-15`; `backend/app/models/payment_attempt.rb:15-19`; `backend/spec/services/orders/create_draft_spec.rb:3-110` | Current representation and input normalization/validation. | ISO currency support, minor-unit scale, fractional calculation precision or rounding policy. | `W2-COM03-RND-01` | `P2B-CASH-OD-05`, `P2A-LOY-OD-05`, `P2A-PROMO-OD-05`, `W2-ORD-OD-01` | `CLOSED_BY_REPOSITORY_EVIDENCE`; preserve narrow scope. |
| No Service Charge production artifact or calculation stage was found. | `REPOSITORY_FACT`; `NOT_IMPLEMENTED` | Production-artifact inventory across `backend/app`, `backend/db/migrate`, and `backend/spec`; aggregate-only Order total at `backend/app/domains/orders/create_draft.rb:39-59` | Current flow does not identify a Service Charge component. | Whether Service Charge should exist, its owner or basis. | `W2-COM03-SVC-01` | `P2A-LOY-OD-05`, `P2A-PROMO-OD-05`, `W2-ORD-OD-01` | Owner decision remains prerequisite. |
| No Service Charge Tax, discount or Refund treatment was found. | `REPOSITORY_FACT`; `NOT_IMPLEMENTED` | Production-artifact inventory across `backend/app`, `backend/db/migrate`, and `backend/spec`; aggregate-only Order total at `backend/app/domains/orders/create_draft.rb:39-59` | Current flow does not identify downstream Service Charge treatment. | Service Charge Tax, discount, history or Refund treatment. | `W2-COM03-SVC-02` | `P2A-LOY-OD-05`, `P2A-PROMO-OD-05`, `W2-ORD-OD-01`; `P2B-CASH-OD-05` indirectly through Refund | Owner decision remains prerequisite. |
| No calculation-stage, rounding-mode, residual-allocation or rule-version implementation was found in the commercial flow. | `REPOSITORY_FACT`; `NOT_IMPLEMENTED` | `backend/app/domains/orders/create_draft.rb:7-59`; `backend/app/domains/payments/confirm.rb:12-102`; inspected migrations/models | Only aggregate integer equality is enforced locally. | Global or component-specific precision, tie mode, sequence or provenance. | `W2-COM03-RND-02`, `W2-COM03-RND-03` | `P2B-CASH-OD-05`, `P2A-LOY-OD-05`, `P2A-PROMO-OD-05`, `W2-ORD-OD-01` | Qualified input and Owner decisions remain required. |

## 9. Twenty-seven-gap reconciliation

| Gap ID | Repository conclusion | Exact candidate impact | W2-COM-04 local closure status | Next action |
|---|---|---|---|---|
| `W2-COM03-CAT-01` | Product/Variant identity persistence is directly established; Price/Modifier behavior is excluded. | `P2A-LOY-OD-05`, `P2A-PROMO-OD-05`, `W2-ORD-OD-01` | `CLOSED_BY_REPOSITORY_EVIDENCE` | Carry forward bounded identity facts. |
| `W2-COM03-CAT-02` | Approved scope/fallback direction exists; no runtime Price representation or lookup exists. | `P2A-LOY-OD-05`, `P2A-PROMO-OD-05`, `W2-ORD-OD-01` | `PARTIALLY_CLOSED` | Inventory actual default/override facts. |
| `W2-COM03-CAT-03` | No effective-time representation or selection behavior exists. | `P2A-LOY-OD-05`, `P2A-PROMO-OD-05`, `W2-ORD-OD-01` | `OWNER_DECISION_REQUIRED` | Decide bounded business-time semantics before design. |
| `W2-COM03-CAT-04` | `Orders::Confirm` does not enforce repricing/revised quote. | `P2A-LOY-OD-05`, `P2A-PROMO-OD-05`, `W2-ORD-OD-01` | `DEPENDENCY_BLOCKED` | Close Price facts and semantics first. |
| `W2-COM03-CAT-05` | Current Order keeps aggregate total, not sold component/Price-version provenance. | `P2A-LOY-OD-05`, `P2A-PROMO-OD-05`, `W2-ORD-OD-01`; `P2B-CASH-OD-05` indirectly | `INTERNAL_EVIDENCE_REQUIRED` | Define minimum factual provenance without selecting schema. |
| `W2-COM03-CAT-06` | No Modifier pricing behavior exists; cardinality policy is not pricing evidence. | `P2A-PROMO-OD-05`, `W2-ORD-OD-01` | `OWNER_DECISION_REQUIRED` | Gather actual Modifier use cases and ballot policy. |
| `W2-COM03-CAT-07` | No free/zero-item representation or treatment is established. | `P2A-PROMO-OD-05`, `W2-ORD-OD-01`; `P2B-CASH-OD-05` indirectly | `DEPENDENCY_BLOCKED` | Gather use cases, then qualified and Owner review. |
| `W2-COM03-PRO-01` | No implemented type catalogue/formula exists. | `P2A-PROMO-OD-05`, `W2-ORD-OD-01` | `OWNER_DECISION_REQUIRED` | Present source-faithful alternatives. |
| `W2-COM03-PRO-02` | Approved directions exist; runtime eligibility/stacking facts do not. | `P2A-PROMO-OD-05`, `W2-ORD-OD-01` | `PARTIALLY_CLOSED` | Produce eligibility/provenance fact matrix. |
| `W2-COM03-PRO-03` | No applied-benefit provenance or reversal workflow exists. | `P2A-PROMO-OD-05`, `P2B-CASH-OD-05`, `W2-ORD-OD-01` | `DEPENDENCY_BLOCKED` | Close sold-component and Refund outcome inputs. |
| `W2-COM03-PRO-04` | Owner administration directions exist; runtime enforcement does not. | `P2A-PROMO-OD-05` | `PARTIALLY_CLOSED` | Preserve policy/implementation distinction. |
| `W2-COM03-LOY-01` | Aggregate local settlement exists; eligible earning components do not. | `P2A-LOY-OD-05`, `W2-ORD-OD-01` | `DEPENDENCY_BLOCKED` | Close sold components and authoritative Payment input. |
| `W2-COM03-LOY-02` | No redemption rate, limits, point unit or rounding implementation exists. | `P2A-LOY-OD-05`, `W2-ORD-OD-01` | `OWNER_DECISION_REQUIRED` | Separate value/order/rounding ballots. |
| `W2-COM03-LOY-03` | No ledger or Refund/cancellation reversal exists. | `P2A-LOY-OD-05` | `DEPENDENCY_BLOCKED` | Close authoritative allocated outcome first. |
| `W2-COM03-PAY-01` | Narrow local exact-balance/idempotent/concurrent confirmation is implemented and specified. | `P2B-CASH-OD-05`, `P2A-LOY-OD-05`, `P2A-PROMO-OD-05`, `W2-ORD-OD-01` | `CLOSED_BY_REPOSITORY_EVIDENCE` | Do not broaden to provider behavior. |
| `W2-COM03-PAY-02` | No provider notification/query/signature/event-deduplication path exists. | `P2B-CASH-OD-05`, `P2A-LOY-OD-05`, `P2A-PROMO-OD-05` | `QUALIFIED_EVIDENCE_REQUIRED` | Keep `EU-W2-PAY-01` pending and unsent. |
| `W2-COM03-PAY-03` | Bounded local late-success containment exists; provider-originated handling does not. | `P2B-CASH-OD-05`, `P2A-LOY-OD-05`, `P2A-PROMO-OD-05`, `W2-ORD-OD-01` indirectly | `PARTIALLY_CLOSED` | Keep provider scenarios hypothetical. |
| `W2-COM03-PAY-04` | Refund vocabulary exists; executable workflow/method authority does not. | `P2B-CASH-OD-05`, `P2A-LOY-OD-05`, `P2A-PROMO-OD-05`, `W2-ORD-OD-01` | `DEPENDENCY_BLOCKED` | Obtain qualified method/outcome evidence and Owner policy. |
| `W2-COM03-PAY-05` | No partial/multiple-tender allocation exists; split tender remains deferred. | `P2B-CASH-OD-05`, `P2A-LOY-OD-05`, `P2A-PROMO-OD-05`, `W2-ORD-OD-01` | `DEPENDENCY_BLOCKED` | Do not recommend allocation while upstream policy is deferred. |
| `W2-COM03-PAY-06` | Cancellation commands do not establish post-settlement commercial consequences. | `P2B-CASH-OD-05`, `P2A-LOY-OD-05`, `P2A-PROMO-OD-05`, `W2-ORD-OD-01` | `DEPENDENCY_BLOCKED` | Prepare cross-domain consequence evidence. |
| `W2-COM03-TAX-01` | Official source metadata exists; applicability is not internally provable. | `P2A-LOY-OD-05`, `P2A-PROMO-OD-05`, `W2-ORD-OD-01`; `P2B-CASH-OD-05` indirectly | `PARTIALLY_CLOSED` | Preserve current source chain for qualified review. |
| `W2-COM03-TAX-02` | No actual item classification or qualified treatment exists. | `P2B-CASH-OD-05` indirectly, `P2A-LOY-OD-05`, `P2A-PROMO-OD-05`, `W2-ORD-OD-01` | `QUALIFIED_EVIDENCE_REQUIRED` | Commission only after actual facts and authorization. |
| `W2-COM03-SVC-01` | No business/repository Service Charge fact establishes existence or ownership. | `P2A-LOY-OD-05`, `P2A-PROMO-OD-05`, `W2-ORD-OD-01` | `OWNER_DECISION_REQUIRED` | Establish business need and accountable owner. |
| `W2-COM03-SVC-02` | No Tax/discount/Refund treatment exists. | `P2B-CASH-OD-05` indirectly, `P2A-LOY-OD-05`, `P2A-PROMO-OD-05`, `W2-ORD-OD-01` | `DEPENDENCY_BLOCKED` | Decide existence, then seek qualified evidence. |
| `W2-COM03-RND-01` | Current Order/Payment amounts are integer-backed with three-character currency codes. | `P2B-CASH-OD-05`, `P2A-LOY-OD-05`, `P2A-PROMO-OD-05`, `W2-ORD-OD-01` | `CLOSED_BY_REPOSITORY_EVIDENCE` | Do not infer scale or rounding. |
| `W2-COM03-RND-02` | No scale, stage or tie rule is implemented or professionally established. | `P2B-CASH-OD-05`, `P2A-LOY-OD-05`, `P2A-PROMO-OD-05`, `W2-ORD-OD-01` | `QUALIFIED_EVIDENCE_REQUIRED` | Prepare component-specific questions. |
| `W2-COM03-RND-03` | No residual allocation or calculation-rule provenance exists. | `P2B-CASH-OD-05`, `P2A-LOY-OD-05`, `P2A-PROMO-OD-05`, `W2-ORD-OD-01` | `DEPENDENCY_BLOCKED` | Close upstream component policy first. |

## 10. Tax/Accounting prerequisite register

| Required factual input | Current state | Source owner | Readiness for qualified review |
|---|---|---|---|
| Actual sellable items, Variant identity and Modifier usage | Identity exists; Price/Modifier facts incomplete | Catalog/Pricing | `NOT_READY` |
| Chain/Branch Price and effective version actually applied | Not represented | Catalog/Pricing | `NOT_READY` |
| Applied Promotion and Loyalty component attribution | Not implemented | Promotions; Loyalty | `NOT_READY` |
| Confirmed sold-component and calculation provenance | Aggregate total only | Ordering as evidence consumer; source domains supply facts | `NOT_READY` |
| Authoritative Payment/Refund method and allocated outcome | Local confirmation only; Refund/provider path absent | Payment | `NOT_READY` |
| Service Charge existence, scope and basis | Not established | Accountable owner unresolved | `NOT_READY` |
| Currency scale, calculation precision and residual scenarios | Integer representation only | Component owners; Payment/Ordering current representation | `NOT_READY` |

Qualified Vietnamese Tax/Accounting review is therefore not ready for substantive treatment conclusions. Preparing a scoped fact pack may continue internally; commissioning, contact, disclosure, engagement and expenditure remain unauthorized.

## 11. Ordering sequence/allocation dependency register

| Dependency | Current readiness | Why Ordering cannot decide it | Required closure |
|---|---|---|---|
| Catalog Price/Modifier | `NOT_READY` | Catalog owns its source facts and pricing policy. | Actual Price/Modifier facts and Owner decisions. |
| Promotions | `NOT_READY` | Promotions owns eligibility, formula and benefit outcomes. | Type/formula/provenance and reversal policy. |
| Loyalty | `NOT_READY` | Loyalty owns earn/redeem/reversal semantics. | Eligible basis, value/order/rounding and reversal policy. |
| Payment/Refund | `NOT_READY` | Payment owns settlement and Refund truth. | Provider evidence, Refund method and allocation policy. |
| Tax/Service Charge | `NOT_READY` | Qualified evidence and accountable business owners supply these inputs. | Actual facts, qualified review and Owner policy. |
| Precision/residuals | `NOT_READY` | Each source component supplies its precision requirements. | Component-specific rules before sequence comparison. |

`W2-ORD-OD-01` remains `DEPENDENCY_BLOCKED`. No calculation sequence can be compared authoritatively without inventing upstream policy.

## 12. Remaining blockers and next closure paths

| Candidate | Concrete remaining dependency | Minimum next closure path |
|---|---|---|
| `P2B-CASH-OD-05` | Authoritative Refund operation/method/allocation plus Cash drawer and Accounting/Reporting consequences. | Payment internal fact pack, authorized provider evidence, then bounded Owner decisions. |
| `P2A-LOY-OD-05` | Sold eligible components and allocated authoritative Refund/cancellation outcome. | Catalog/Ordering provenance, Payment outcome, then Loyalty reversal ballot. |
| `P2A-PROMO-OD-05` | Applied-benefit provenance and allocated Refund/cancellation outcome with precision/Tax inputs. | Promotion provenance facts, Payment outcome, qualified inputs, then policy alternatives. |
| `W2-ORD-OD-01` | Every commercial component remains undefined or incomplete. | Close source-domain facts and decisions before sequence comparison. |

## 13. External evidence request status

All nine evidence requests remain `PENDING — NOT_SENT — NOT_READY_FOR_OWNER_AUTHORIZATION`. The six coordination scopes and nine request mappings are unchanged. No recipient, human coordinator, qualification, engagement, disclosure, procurement or expenditure is selected or authorized.

## 14. Governance reconciliation

The canonical reconciliation remains `16 + 22 + 2 + 3 + 12 = 55`. This document changes no Owner Decision Baseline entry, ODB ID, canonical candidate status, Candidate E Gate A/B status, Gate A/B/C, Control Acceptance, FOA or Production Authorization. It creates no schema, migration, database object, physical database design, source code, test, dependency, API, runtime behavior or deployment artifact.

Facts, policy, checked-in test evidence, vendor context and qualified external evidence remain distinct. Finding a field or status vocabulary does not establish a workflow; finding no artifact does not decide policy.

## 15. Final recommendation

**Recommendation:** `EVIDENCE_INCOMPLETE — PARALLEL_INTERNAL_FACT_PREPARATION_MAY_CONTINUE — FOUR CANDIDATES_REMAIN_DEPENDENCY_BLOCKED`.

Proceed internally with actual Price/Modifier inventory, minimum sold-component provenance, Promotion/Loyalty factual input matrices, and a bounded Payment/Refund evidence pack. Do not begin Order calculation-sequence selection or substantive Tax/Accounting conclusions. Owner review remains necessary for business policy, and qualified/provider evidence remains separately gated.
