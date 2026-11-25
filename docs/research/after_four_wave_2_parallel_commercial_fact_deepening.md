# AFTER FOUR — Wave 2 Parallel Commercial Fact Deepening

**Work package:** `W2-COM-05`

**Status:** `INTERNAL_EVIDENCE_DEEPENED — EVIDENCE_INCOMPLETE — POLICY_AND_IMPLEMENTATION_NOT_AUTHORIZED`

**Evidence cutoff:** 2026-11-24 (Asia/Tokyo)

## 1. Purpose, scope, cutoff and non-authority

This package builds on [W2-COM-04](after_four_wave_2_internal_commercial_fact_closure.md) without repeating or replacing it. It deepens five commercial streams and incrementally reconciles their evidence dependencies. It records no Owner decision, qualified conclusion, approved calculation sequence, technical design, implementation authorization or canonical status change.

`P2B-CASH-OD-05`, `P2A-LOY-OD-05`, `P2A-PROMO-OD-05`, and `W2-ORD-OD-01` remain canonically `DEPENDENCY_BLOCKED`. Ordering is only a proposed coordination candidate; consumption of a fact does not transfer ownership of that fact.

Checked-in specs were inspected, not executed. Missing artifacts are bounded repository findings, not proof that a business policy does not exist. Frontend demo data, logical models and future API contracts are not runtime authority.

## 2. W2-COM-04 baseline and reconciliation

| Local evidence status | W2-COM-04 | W2-COM-05 | Justification |
|---|---:|---:|---|
| `CLOSED_BY_REPOSITORY_EVIDENCE` | 3 | 3 | No new runtime evidence closes another exact gap question. |
| `PARTIALLY_CLOSED` | 5 | 5 | Additional sources clarify maturity but do not complete policy/behavior. |
| `INTERNAL_EVIDENCE_REQUIRED` | 1 | 1 | Sold-component/applied-price provenance remains absent. |
| `OWNER_DECISION_REQUIRED` | 5 | 5 | Internal evidence cannot select business policy. |
| `QUALIFIED_EVIDENCE_REQUIRED` | 3 | 3 | Provider and Vietnamese Tax/Accounting evidence remain external. |
| `DEPENDENCY_BLOCKED` | 10 | 10 | Upstream facts and decisions remain unresolved. |
| `NOT_VERIFIED` | 0 | 0 | No unsupported positive claim is promoted. |

The local closure assessment is unchanged. W2-COM-05 deepens source attribution, minimum facts and closure order.

## 3. Five workstream evidence registers

### 3.1 A — Catalog/Pricing

| Finding | Evidence class | Exact source | Established fact | Limit / next action | Exact candidate impact |
|---|---|---|---|---|---|
| Product/Variant identity is persisted, but Catalog Core has no Price, Branch Price, Price Version or Modifier-price persistence. | `IMPLEMENTED_BEHAVIOR`; `NOT_IMPLEMENTED` | `backend/db/migrate/20261115210000_create_catalog_core_foundation.rb:61-143`; `backend/app/contexts/catalog/infrastructure/persistence/product_variant_record.rb:4-45` | Stable Variant identity and Brand/Product ancestry exist. | Inventory actual commercial inputs; do not infer future shape. | `P2A-LOY-OD-05`, `P2A-PROMO-OD-05`, `W2-ORD-OD-01` |
| Chain default, Branch override, immutable effective versions, revised-quote review and sold-price lock are policy directions. | `OWNER_APPROVED_POLICY` | `docs/architecture/after_four_catalog_pricing_discovery.md:15-40` | Required business boundaries. | No runtime lookup, publication, effective-time selection or snapshot implementation. | `P2A-LOY-OD-05`, `P2A-PROMO-OD-05`, `W2-ORD-OD-01` |
| Actual menu/price/modifier template values remain blank or `TBD`. | `REPOSITORY_FACT`; `OPEN_QUESTION` | `docs/architecture/after_four_real_menu_pricing_specification.md:26-134` | The required input categories are explicit. | Values/examples are not approved business facts. | `P2A-PROMO-OD-05`, `W2-ORD-OD-01`; `P2B-CASH-OD-05` only through later Refund consequences |
| POS demo prices and client subtotal exist only as illustrative UI data. | `REPOSITORY_FACT` | `frontend/src/features/pos/data/pos-demo-data.ts:1-72`; `frontend/src/features/pos/lib/get-demo-order-summary.ts:1-30`; `frontend/src/features/pos/components/menu-product-card.tsx:14-46`; `frontend/src/features/pos/components/product-detail-dialog.tsx:62-82` | Demo display/calculation behavior exists. | It is not authoritative Price, approved menu, server pricing or sold-price provenance. | No gap is closed; context for `W2-ORD-OD-01` only. |

### 3.2 B — Promotions

| Finding | Evidence class | Exact source | Established fact | Limit / next action | Exact candidate impact |
|---|---|---|---|---|---|
| Scope, stacking groups, deterministic priority and operation-specific administration are approved directions. | `OWNER_APPROVED_POLICY` | `docs/architecture/after_four_owner_decision_baseline.md` entries `P2A-PROMO-OD-02`, `P2A-PROMO-OD-03`, `P2A-PROMO-OD-07A`, `P2A-PROMO-OD-07B`, `P2A-PROMO-OD-07C`, `P2A-PROMO-OD-07D`, `P2A-PROMO-OD-07E`, `P2A-PROMO-OD-07F`, `P2A-PROMO-OD-07G`, `P2A-PROMO-OD-07H`, `P2A-PROMO-OD-07I`, `P2A-PROMO-OD-07J` | Governance constraints exist. | Types, formulas, eligibility inputs, allocation and runtime enforcement remain open/absent. | `P2A-PROMO-OD-05`, `W2-ORD-OD-01` |
| Future API rows describe pricing and promotion commands but are explicitly inactive contracts. | `APPROVED_DESIGN_DIRECTION`; `NOT_IMPLEMENTED` | `docs/architecture/after_four_api_contract.md:169-186,188-206` | Intended separation of Catalog inputs and server-side evaluation is documented. | No route, DTO, calculator, benefit record or authority is implemented. | `P2A-PROMO-OD-05`, `W2-ORD-OD-01` |
| Current Order stores aggregate total only; no applied-benefit attribution was found. | `IMPLEMENTED_BEHAVIOR`; `NOT_IMPLEMENTED` | `backend/app/contexts/orders/application/use_cases/create_draft.rb:39-59`; `backend/db/migrate/20261114192000_create_order_payment_foundation.rb:5-36` | Current internal seam has no Promotion component. | Define source-domain benefit identity, amount and outcome facts before reversal choices. | `P2A-PROMO-OD-05`, `P2B-CASH-OD-05`, `W2-ORD-OD-01` |

### 3.3 C — Loyalty

| Finding | Evidence class | Exact source | Established fact | Limit / next action | Exact candidate impact |
|---|---|---|---|---|---|
| Earning depends on authoritative settled eligible value; redemption requires explicit limits/order/rounding. | `OWNER_APPROVED_POLICY` | Baseline entries `P2A-LOY-OD-01`, `P2A-LOY-OD-02`; `docs/research/after_four_p2a_loyalty_policy_discovery.md` | Directional prerequisites exist. | No eligible component, rate, point value, limit or rounding rule is established. | `P2A-LOY-OD-05`, `W2-ORD-OD-01` |
| Local Payment supplies aggregate target/success/refund counters only. | `IMPLEMENTED_BEHAVIOR` | `backend/app/models/payment.rb:1-16`; `backend/app/contexts/payments/confirm.rb:60-78` | Exact local settlement aggregate can be observed. | It cannot identify Loyalty-eligible value or provider-authoritative outcome. | `P2A-LOY-OD-05`, `W2-ORD-OD-01` |
| No Loyalty ledger, earn/redeem writer or reversal workflow was found in production/migration/spec paths. | `REPOSITORY_FACT`; `NOT_IMPLEMENTED` | Inventory across `backend/app`, `backend/db/migrate`, `backend/spec` | No local operational behavior closes earning/redemption/reversal questions. | Prepare Owner questions only after component and Refund facts exist. | `P2A-LOY-OD-05`, `W2-ORD-OD-01` |

### 3.4 D — Payment/Refund

| Finding | Evidence class | Exact source | Established fact | Limit / next action | Exact candidate impact |
|---|---|---|---|---|---|
| Local confirmation locks Order then Payment, validates exact amount/currency, records an Attempt and updates settlement atomically. | `IMPLEMENTED_BEHAVIOR`; `TESTED_BEHAVIOR` | `backend/app/contexts/payments/confirm.rb:34-102,114-164`; `backend/spec/services/payments/confirm_cash_spec.rb:3-158`; `backend/spec/services/payments/concurrent_confirmation_spec.rb:3-72` | Narrow local exact-balance, replay and contention behavior. | Not a provider adapter or provider-event deduplication mechanism. | `P2B-CASH-OD-05`, `P2A-LOY-OD-05`, `P2A-PROMO-OD-05`, `W2-ORD-OD-01` |
| Terminal Attempt evidence and aggregate totals have database constraints/triggers. | `IMPLEMENTED_BEHAVIOR` | `backend/db/migrate/20261114200000_protect_terminal_payment_attempt_evidence.rb:1-42`; `backend/db/migrate/20261114202000_enforce_payment_aggregate_integrity.rb:1-180` | Terminal fields are immutable and succeeded Attempt totals constrain Payment aggregate. | Does not establish provider authenticity, Refund method or downstream allocation. | `P2B-CASH-OD-05`, `P2A-LOY-OD-05`, `P2A-PROMO-OD-05` |
| Local Held/Expired late success opens a review case without dispatch. | `IMPLEMENTED_BEHAVIOR`; `TESTED_BEHAVIOR` | `backend/app/contexts/payments/confirm.rb:167-234`; `backend/spec/services/payments/late_success_spec.rb:3-82` | Bounded containment exists. | Provider notification/query reconciliation and review resolution are not implemented. | `P2B-CASH-OD-05`, `P2A-LOY-OD-05`, `P2A-PROMO-OD-05`, `W2-ORD-OD-01`, each indirectly through Payment outcome. |
| Refund counters/status vocabulary exists, but no Refund command, rail, allocation or authority was found. | `REPOSITORY_FACT`; `NOT_IMPLEMENTED` | `backend/db/migrate/20261114192000_create_order_payment_foundation.rb:38-73`; `backend/app/models/payment.rb:1-16` | Aggregate bounds reserve Refund vocabulary. | No business workflow or provider evidence follows from fields alone. | `P2B-CASH-OD-05`, `P2A-LOY-OD-05`, `P2A-PROMO-OD-05`, `W2-ORD-OD-01` |

### 3.5 E — Service Charge and precision

| Finding | Evidence class | Exact source | Established fact | Limit / next action | Exact candidate impact |
|---|---|---|---|---|---|
| Service Charge is still `TBD`; no production component was found. | `OPEN_QUESTION`; `NOT_IMPLEMENTED` | `docs/architecture/after_four_real_menu_pricing_specification.md:123-134`; inventory across backend production/migration/spec paths | Existence and ownership remain unresolved. | Do not infer a rate, basis, Tax or Refund treatment. | `P2A-LOY-OD-05`, `P2A-PROMO-OD-05`, `W2-ORD-OD-01` |
| Order, Payment and Attempt amounts are integer-backed with three-character uppercase currency codes. | `IMPLEMENTED_BEHAVIOR` | `backend/db/migrate/20261114192000_create_order_payment_foundation.rb:5-73`; `backend/app/contexts/orders/infrastructure/persistence/order_record.rb:1-15`; `backend/app/models/payment.rb:1-15` | Current storage/validation representation. | No currency scale, fractional precision, rounding stage/tie mode or residual policy. | `P2B-CASH-OD-05`, `P2A-LOY-OD-05`, `P2A-PROMO-OD-05`, `W2-ORD-OD-01` |
| Current local calculation is aggregate integer equality, not component calculation. | `IMPLEMENTED_BEHAVIOR`; `NOT_IMPLEMENTED` | `backend/app/contexts/orders/application/use_cases/create_draft.rb:7-59`; `backend/app/contexts/payments/confirm.rb:126-135` | Exact Payment amount must equal aggregate target locally. | No calculation sequence, allocation, rounding or historical rule version. | `P2B-CASH-OD-05`, `P2A-LOY-OD-05`, `P2A-PROMO-OD-05`, `W2-ORD-OD-01` |

## 4. Cross-domain dependency and ownership matrix

| Relationship | Required upstream fact/decision | Accountable source domain | Downstream consumer | Current evidence / missing evidence | Dependency | Exact candidate impact | Confidence / class | Next closure action |
|---|---|---|---|---|---|---|---|---|
| Price → Promotion | Applied Price/version and eligible components | Catalog/Pricing | Promotions | Policy direction; runtime facts absent | Direct | `P2A-PROMO-OD-05`, `W2-ORD-OD-01` | High / `OWNER_APPROVED_POLICY`, `NOT_IMPLEMENTED` | Complete actual Price facts and provenance. |
| Price → Loyalty | Sold eligible components/value | Catalog/Pricing | Loyalty | Aggregate Order total only | Direct | `P2A-LOY-OD-05`, `W2-ORD-OD-01` | High / `IMPLEMENTED_BEHAVIOR`, gap remains | Define minimum sold-component facts. |
| Promotion → Loyalty | Applied benefit and eligible post-Promotion basis | Promotions; Loyalty decides eligibility | Loyalty | No applied-benefit record or eligible-basis decision | Direct if Owner includes Promotion effects | `P2A-LOY-OD-05`, `P2A-PROMO-OD-05`, `W2-ORD-OD-01` | Medium / `OPEN_QUESTION` | Owner must decide eligible components after facts exist. |
| Loyalty → Payment | Redemption amount included in authoritative payable total | Loyalty supplies outcome; Payment consumes target | Payment | No redemption outcome; Payment only has aggregate target | Direct | `P2A-LOY-OD-05`, `W2-ORD-OD-01` | High / missing upstream fact | Establish redemption outcome contract later. |
| Payment → Refund | Authoritative settlement/attempt and provider method outcome | Payment | Refund workflow | Local settlement exists; provider/Refund path absent | Direct | `P2B-CASH-OD-05`, `P2A-LOY-OD-05`, `P2A-PROMO-OD-05`, `W2-ORD-OD-01` | High / `IMPLEMENTED_BEHAVIOR`, `QUALIFIED_EXTERNAL_EVIDENCE` missing | Obtain authorized provider evidence, then Owner policy. |
| Refund → Cash | Allocated successful Refund method and drawer consequence | Payment supplies Refund truth; Cash owns drawer consequence | Cash | No Refund workflow/allocation | Conditional direct | `P2B-CASH-OD-05` | High / `DEPENDENCY_BLOCKED` | Define method/outcome before Cash policy. |
| Refund → Promotion/Loyalty | Allocated returned components and successful outcome | Payment plus confirmed sold evidence | Promotions; Loyalty | Neither allocation nor provenance exists | Direct | `P2A-PROMO-OD-05`, `P2A-LOY-OD-05` | High / `DEPENDENCY_BLOCKED` | Close provenance and Refund outcome first. |
| Components → Tax | Actual item/component classification, basis and timing | Business source domains; qualified reviewer interprets | Tax/Accounting; Reporting | Official framework only; actual facts incomplete | Direct | `P2A-LOY-OD-05`, `P2A-PROMO-OD-05`, `W2-ORD-OD-01`; `P2B-CASH-OD-05` indirectly where Refund treatment applies | High / `QUALIFIED_EXTERNAL_EVIDENCE` required | Assemble facts before qualified review. |
| Commercial outcomes → Reporting | Immutable sold, benefit, payment and Refund evidence | Each source domain | Reporting | Payment Attempt evidence only; other provenance absent | Direct | `P2B-CASH-OD-05`, `P2A-LOY-OD-05`, `P2A-PROMO-OD-05`, `W2-ORD-OD-01` | High / partial repository evidence | Define source evidence without transferring ownership. |

## 5. Sold-component provenance minimum-facts checklist

| Minimum fact | Source owner | Current evidence | Status |
|---|---|---|---|
| Order/Order Item identity and quantity | Ordering | No Order Item persistence in current Phase 1 aggregate | `MISSING` |
| Persisted Variant identity and Brand/Product ancestry | Catalog/Pricing | Implemented Catalog Core | `AVAILABLE` |
| Applied Price scope, version identity, value, currency and effective instant | Catalog/Pricing | Policy only | `MISSING` |
| Selected Modifier identities, quantities and applied price effects | Catalog/Pricing | Cardinality policy only | `MISSING` |
| Applied Promotion identity, rule/version and allocated benefit | Promotions | Policy vocabulary only | `MISSING` |
| Loyalty redemption identity/value and eligible-basis attribution | Loyalty | No implementation/facts | `MISSING` |
| Tax/Service Charge components and qualified treatment basis | Source domain plus qualified reviewer | Service Charge unresolved; Tax facts incomplete | `MISSING` |
| Confirmed immutable snapshot time/version and aggregate reconciliation | Ordering consumes source facts | Aggregate total only | `PARTIAL` |

This checklist is logical evidence preparation, not a schema or shared aggregate design.

## 6. Tax/Accounting fact-pack readiness checklist

| Input | Readiness | Blocking evidence |
|---|---|---|
| Actual approved menu/items and Variant mapping | `NOT_READY` | Menu rows and Variant data remain pending. |
| Applied chain/Branch Price and Price version | `NOT_READY` | No runtime representation or actual values. |
| Modifier, Promotion and Loyalty components | `NOT_READY` | No approved formulas or applied attribution. |
| Payment/Refund method and allocated outcome | `NOT_READY` | Local settlement only; provider/Refund absent. |
| Service Charge existence/basis | `NOT_READY` | Owner policy and accountable owner unresolved. |
| Currency scale, rounding and residual scenarios | `NOT_READY` | Integer storage does not establish rules. |

Preparation of questions may continue. Substantive qualified review, contact, disclosure, engagement and expenditure remain unauthorized.

## 7. Provider evidence requirements brief

| Required evidence | Unresolved question | Repository boundary |
|---|---|---|
| Notification and query contracts, authentication/signature and replay rules | What result becomes authoritative and when? | No provider adapter exists. |
| Provider event/transaction identity and duplicate/conflict semantics | How are duplicate, delayed and conflicting outcomes resolved? | Local command idempotency is not provider-event deduplication. |
| Success/failure/pending/unknown/cancelled terminality | Which outcomes are final or require reconciliation? | Local Attempt vocabulary is not provider evidence. |
| Refund rails, original/alternate method support, partial/multiple allocation | What operations and amounts are supported? | Refund counters are not a workflow. |
| Settlement/reconciliation reports and evidence retention | What evidence supports Accounting/Reporting? | Local Audit/Attempt evidence covers only local commands. |

`EU-W2-PAY-01` remains pending. No provider was contacted and no request or evidence was sent.

## 8. Consolidated future Owner-review questions

Evidence is sufficient to frame—but not answer—these independent questions:

1. Catalog/Pricing: actual Modifier price effects and free/zero treatment, after actual use cases are supplied.
2. Promotions: type/formula/eligibility/allocation choices, after applied-benefit facts are defined.
3. Loyalty: eligible earning components and redemption value/order/rounding, after sold components are defined.
4. Payment/Refund: permitted Refund operations, method and authority, after provider evidence exists.
5. Service Charge: whether it exists and who owns its policy, before downstream treatment.
6. Precision: component-specific scale/rounding/residual policy after qualified inputs.

These are future review candidates, not ballots, recommendations or approvals.

## 9. Updated twenty-seven-gap reconciliation

| Gap IDs | Count | W2-COM-05 status | Deepened conclusion |
|---|---:|---|---|
| `W2-COM03-CAT-01`, `W2-COM03-PAY-01`, `W2-COM03-RND-01` | 3 | `CLOSED_BY_REPOSITORY_EVIDENCE` | Exact narrow questions remain closed; no downstream policy follows. |
| `W2-COM03-CAT-02`, `W2-COM03-PRO-02`, `W2-COM03-PRO-04`, `W2-COM03-PAY-03`, `W2-COM03-TAX-01` | 5 | `PARTIALLY_CLOSED` | Maturity/absence evidence is clearer; missing portions remain. |
| `W2-COM03-CAT-05` | 1 | `INTERNAL_EVIDENCE_REQUIRED` | Minimum sold provenance facts are now enumerated, not supplied. |
| `W2-COM03-CAT-03`, `W2-COM03-CAT-06`, `W2-COM03-PRO-01`, `W2-COM03-LOY-02`, `W2-COM03-SVC-01` | 5 | `OWNER_DECISION_REQUIRED` | Repository evidence cannot select policy. |
| `W2-COM03-PAY-02`, `W2-COM03-TAX-02`, `W2-COM03-RND-02` | 3 | `QUALIFIED_EVIDENCE_REQUIRED` | Provider or qualified Tax/Accounting evidence remains unavailable. |
| `W2-COM03-CAT-04`, `W2-COM03-CAT-07`, `W2-COM03-PRO-03`, `W2-COM03-LOY-01`, `W2-COM03-LOY-03`, `W2-COM03-PAY-04`, `W2-COM03-PAY-05`, `W2-COM03-PAY-06`, `W2-COM03-SVC-02`, `W2-COM03-RND-03` | 10 | `DEPENDENCY_BLOCKED` | Critical upstream facts/decisions remain unresolved. |

All 27 stable gap IDs appear exactly once above; no local assessment changed from W2-COM-04.

## 10. Critical-path execution plan

| Priority | Parallel action | Shared dependency unlocked |
|---:|---|---|
| 1 | Complete actual menu/Variant/Price/Modifier facts and minimum sold provenance vocabulary. | Promotions, Loyalty, Tax and Ordering inputs. |
| 1 | Prepare a provider evidence-request draft and requirements checklist for future Owner authorization; do not send or disclose anything. | Refund, Cash, Loyalty and Promotion outcome evidence. |
| 1 | Collect available internal evidence and prepare a bounded Owner question on whether Service Charge is required and who owns its policy. | Tax/Refund/rounding scope. |
| 2 | Define Promotion applied-benefit and Loyalty eligible-component factual matrices. | Reversal and allocation questions. |
| 2 | Assemble Tax/Accounting fact pack after actual components exist. | Qualified applicability/rounding evidence. |
| 3 | Prepare bounded Owner ballots from source-supported alternatives. | Policy closure without implementation. |
| 4 | Compare Order-level sequence/allocation alternatives only after upstream closure. | `W2-ORD-OD-01` readiness reconsideration. |

## 11. Governance and authorization reconciliation

The canonical reconciliation remains `16 + 22 + 2 + 3 + 12 = 55`. The four candidates remain `DEPENDENCY_BLOCKED`. All nine external evidence requests remain `PENDING — NOT_SENT — NOT_READY_FOR_OWNER_AUTHORIZATION`; the six coordination scopes and nine request mappings are unchanged.

This package changes no Owner Decision Baseline entry, ODB ID, candidate readiness, Candidate E Gate, Gate A/B/C, Control Acceptance, FOA or Production Authorization. It authorizes no external contact, disclosure, commissioning, expenditure, schema, migration, database object, physical design, code, test, dependency, API, runtime behavior or deployment.

## 12. Final recommendation

**Recommendation:** `EVIDENCE_DEEPENED — INTERNAL_PARALLEL_CLOSURE_MAY_CONTINUE — SUBSTANTIVE_TAX_PROVIDER_AND_ORDER_SEQUENCE_WORK_REMAINS_BLOCKED`.

Begin the three priority-1 internal preparations in parallel. Do not promote any candidate or begin calculation-sequence selection until the upstream source facts, Owner decisions and separately authorized qualified evidence exist.
