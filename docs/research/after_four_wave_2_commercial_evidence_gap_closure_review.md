# AFTER FOUR — Wave 2 Commercial Evidence Gap Closure Review

**Work package:** `W2-COM-03`

**Status:** `RESEARCH_COMPLETE — OWNER_REVIEW_REQUIRED — POLICY_AND_IMPLEMENTATION_NOT_AUTHORIZED`

**Evidence cutoff:** 2026-11-24 (Asia/Tokyo)

## 1. Purpose, scope and non-authority statement

This review assesses the remaining factual, professional-evidence and policy gaps after [W2-COM-02](after_four_wave_2_commercial_component_evidence_packages.md). It covers Catalog Price/Modifier, Promotions, Loyalty, Payment/Refund, Tax, and Service Charge/monetary precision. It prepares closure paths for `P2B-CASH-OD-05`, `P2A-LOY-OD-05`, `P2A-PROMO-OD-05`, and `W2-ORD-OD-01`; all four remain `DEPENDENCY_BLOCKED`.

This document records no Owner decision, legal or accounting conclusion, technical design, implementation authorization, or candidate-status change. Ordering is only the proposed accountable coordination candidate for a future Order-level sequence/allocation decision under `W2-ORD-OD-01`; it has no Owner-approved authority over Catalog Price, Promotion or Loyalty formulas, Payment/Refund policy, Tax, Service Charge, or rounding.

## 2. Sources and evidence methodology

Controlling and current sources were cross-checked directly:

- [Owner Decision Baseline](../architecture/after_four_owner_decision_baseline.md), [Glossary](../../GLOSSARY.md), [Catalog/Pricing Discovery](../architecture/after_four_catalog_pricing_discovery.md), [Real Menu & Pricing Specification](../architecture/after_four_real_menu_pricing_specification.md), [Promotions Discovery](after_four_p2a_promotions_policy_discovery.md), and [Loyalty Discovery](after_four_p2a_loyalty_policy_discovery.md).
- [Owner-Managed Evidence Register](after_four_wave_2_owner_managed_evidence_register.md), [Cross-Domain Evidence Synthesis](after_four_wave_2_cross_domain_evidence_synthesis.md), [Integration Decision Register](after_four_wave_2_cross_domain_integration_decision_register.md), [Internal Fact Manifest](after_four_wave_2_payment_catalog_internal_fact_manifest.md), [Payment/Catalog Deep Review](after_four_wave_2_payment_catalog_evidence_deep_review.md), [Upstream Commercial Review](after_four_wave_2_upstream_commercial_dependency_evidence_review.md), [W2-COM-02](after_four_wave_2_commercial_component_evidence_packages.md), and [Vietnam POS Evidence](after_four_wave_2_vietnam_pos_comparative_evidence.md).
- Current implementation symbols: `Orders::CreateDraft`, `Orders::Confirm`, `Payments::Confirm`, `Payments::ConfirmCash`, `Payments::ConfirmBankTransfer`, `Payment`, `PaymentAttempt`, `Catalog::Infrastructure::Persistence::ProductVariantRecord`, Catalog Core migration, and their cited specs.

| Classification | Meaning in this review |
|---|---|
| `REPOSITORY_FACT` | Current artifact supports the statement only within that artifact's maturity. |
| `IMPLEMENTED_BEHAVIOR` | Source and inspected tests support a narrow local/test behavior; no production claim. |
| `OWNER_DECISION` | Explicit canonical Owner direction, independently authoritative from vendor evidence. |
| `EXTERNAL_VENDOR_EVIDENCE` | Vendor-specific fact or example; never proof of AFTER FOUR policy or behavior. |
| `LEGAL_OR_PROFESSIONAL_EVIDENCE` | Official source or qualified evidence; applicability still requires scoped professional review. |
| `UNVERIFIED_ASSUMPTION` | Example or statement without authoritative verification. |
| `OPEN_QUESTION` | Factual or policy matter remains unresolved. |
| `DEPENDENCY` | Another source domain or qualified reviewer must establish an input first. |

Gap statuses in §5 are local research statuses only: `CLOSED_BY_REPOSITORY_EVIDENCE`, `PARTIALLY_CLOSED`, `INTERNAL_EVIDENCE_REQUIRED`, `QUALIFIED_EVIDENCE_REQUIRED`, `OWNER_DECISION_REQUIRED`, and `DEPENDENCY_BLOCKED`. A fact may be closed while its policy or implementation remains open. Tests were inspected, not executed.

## 3. Executive findings

| Closure group | Findings |
|---|---|
| Factually closed, narrowly | Persisted Product/Variant identity exists; Payment and Payment Attempt are distinct; local exact-balance confirmation, local idempotency/concurrency protection and terminal evidence behavior exist; current amount storage is integer-based. |
| Partially closed | Default/Branch Price, immutable effective Price versions, Draft repricing review, sold-price preservation, Promotion governance directions, Loyalty settlement/redemption prerequisites, Refund principles, and late-success containment are Owner directions without complete source facts or implementation. |
| Internal evidence needed | Actual menu/Price/Modifier/Branch facts, sold-component provenance, applied Promotion attribution, eligible Loyalty components, Cash drawer consequences, and current display/API precision assumptions. |
| Qualified evidence needed | Provider/acquirer outcomes; Vietnamese Tax/Accounting applicability, calculation and rounding; Service Charge legal/accounting treatment. Official legal-source existence is not an applicability conclusion. |
| Owner decisions needed | Modifier arithmetic, zero/free treatment, Promotion types/formulas/allocation, Loyalty formulas/reversals, Refund methods/allocation, Service Charge existence/model, and component-specific precision/rounding. |
| Still dependency-blocked | The four exact candidates named in §1. No reviewed evidence justifies readiness promotion. |

## 4. Six component assessments

### 4.1 Catalog Price and Modifier

`ODB-CAT-04`, `07`–`10` establish persisted Variant identity, chain default Price with explicit Branch override, immutable/effective-dated Price versions, Draft repricing review, and sold-price preservation. The Catalog migration and `ProductVariantRecord` specs show Product/Variant persistence only. `Orders::CreateDraft` accepts caller-supplied integer `total_amount`; `Orders::Confirm` has no Catalog Price lookup, repricing comparison or sold-component snapshot. `ODB-CAT-05` approves Modifier cardinality, not pricing semantics. Actual menu/Price fields remain blank, `TBD`, or illustrative. Free/zero price, Modifier deltas, effective-time boundaries, publication authority and runtime selection remain open.

### 4.2 Promotions

The baseline confirms bounded governance directions for applicability, stacking/exclusion and deterministic priority, reserve/redeem/release/reverse distinctions, and operation-specific administration. `P2A-PROMO-OD-07J` keeps emergency intervention disabled. Fixed, percentage, bundle and free-item are exploratory source concepts, not approved types; general-expression capability is a separate broader alternative. Eligibility details, formulas, caps/floors, tie rules, applied-benefit provenance, allocation, Refund/cancellation consequences, and remaining lifecycle parameters are unresolved. Vendor examples are contextual only.

### 4.3 Loyalty

`P2A-LOY-OD-01` requires earning from authoritative successfully settled eligible value. `P2A-LOY-OD-02` requires limits, deterministic order and rounding before redemption. Adjustment authority directions and within-one-Organization/one-Brand Branch sharing are bounded Owner directions. No earning rate, eligible-component formula, points/value unit, residual rule, executable ledger, or Refund/cancellation reversal allocation exists. Proportional reversal must not be inferred.

### 4.4 Payment and Refund

`Payments::Confirm` and focused specs support exact-balance local cash/bank-transfer confirmation, local idempotency, row-lock/concurrency containment, mismatch failure evidence, and bounded late-confirmation behavior. They are not provider adapters. Provider notification/query ingestion, signature verification, provider-event identity/deduplication and conflicting-result reconciliation are not implemented. `P1A-OD-03` establishes an append-only, method-aware, authoritatively reconciled Refund direction, cumulative cap and evidence principle; no Refund model, workflow, original/alternate-method rule, partial allocation or multi-tender allocation exists. Cancellation authority does not settle commercial consequences.

### 4.5 Tax

The official-source chain current at the cutoff includes:

| Source | Verified metadata in repository research | Limited conclusion |
|---|---|---|
| [Law 48/2024/QH15](https://vanban.chinhphu.vn/?docid=212476&orggroupid=1&pageid=27160) | Issued 2024-11-26; effective 2025-07-01 | Primary VAT framework. |
| [Law 90/2025/QH15](https://vanban.chinhphu.vn/?classid=1&docid=214558&pageid=27160) | Issued 2025-06-25; effective 2025-07-01 | Amendment in the VAT legal chain; not an AFTER FOUR tax conclusion. |
| [Law 149/2025/QH15](https://vanban.chinhphu.vn/?classid=1&docid=216588&pageid=27160) | Issued 2025-12-11; effective 2026-01-01 | Further VAT amendment. |
| [Law 09/2026/QH16](https://vanban.chinhphu.vn/?classid=1&docid=218095&pageid=27160) | Issued/effective 2026-04-24 | Further tax-law amendment. |
| [Decree 181/2025/NĐ-CP](https://vanban.chinhphu.vn/?docid=214336&lead=merchant-dgmkt&pageid=27160), [359/2025/NĐ-CP](https://vanban.chinhphu.vn/?classid=1&docid=216388&pageid=27160&typegroupid=4), [144/2026/NĐ-CP](https://vanban.chinhphu.vn/?docid=218020&pageid=27160&typegroupid=4) | Effective 2025-07-01, 2026-01-01 and 2026-06-20 | Implementing/amendment chain only. |

These sources do not determine AFTER FOUR's taxpayer method, item/service classification, rate, inclusive/exclusive presentation, taxable basis, line/order aggregation, effective transition, invoice evidence, Refund/cancellation treatment or rounding. Qualified Vietnamese Tax/Accounting review remains required; this document gives no legal advice.

### 4.6 Service Charge and monetary precision

Service Charge remains an unresolved business concept. Vendor systems expose separate components, but that does not approve existence, rate, basis, timing, disclosure, tax, discount interaction, Refund treatment or historical evidence for AFTER FOUR. Current Order/Payment amounts use integers and three-character currency codes; this is narrow implementation evidence, not a universal currency/minor-unit policy. Scale, fractional calculation precision, rounding stage, tie mode, residual allocation and rule-version provenance remain open.

## 5. Gap-level closure register

| Gap ID | Component | Question | Current classification | Existing evidence | Evidence conclusion | Remaining gap | Closure path | Accountable domain | Affected candidates | Recommended next action | Closure status |
|---|---|---|---|---|---|---|---|---|---|---|---|
| `W2-COM03-CAT-01` | Catalog Price/Modifier | Is sellable identity persisted? | `OWNER_DECISION` + `IMPLEMENTED_BEHAVIOR` | `ODB-CAT-04`; Catalog Core migration; `ProductVariantRecord`; record specs | Product/Variant identity and lifecycle persistence exist. | No menu, Price, Modifier price or selling behavior. | Repository inspection complete; downstream facts remain. | Catalog/Pricing | `P2A-PROMO-OD-05`, `P2A-LOY-OD-05`, `W2-ORD-OD-01` | Preserve as bounded fact; inventory actual sellable commercial facts. | `PARTIALLY_CLOSED` |
| `W2-COM03-CAT-02` | Catalog Price/Modifier | What Price scope applies? | `OWNER_DECISION` | `ODB-CAT-07`; Catalog discovery §3 | Chain default with explicit Branch override and fallback direction are approved. | Actual values, publication, effective lookup and runtime behavior. | Internal facts, then design/authorization. | Catalog/Pricing | Same three | Produce actual default/override fact sheet. | `PARTIALLY_CLOSED` |
| `W2-COM03-CAT-03` | Catalog Price/Modifier | What makes a Price version effective? | `OWNER_DECISION` + `OPEN_QUESTION` | `ODB-CAT-08`; Glossary; Catalog discovery §4 | Immutable/effective-dated and correction-by-new-version direction is approved. | Timezone, inclusivity, overlap, tie selection and publication workflow. | Owner policy plus later technical design. | Catalog/Pricing | Same three | Prepare bounded business-time semantics ballot; do not infer `[start,end)`. | `OWNER_DECISION_REQUIRED` |
| `W2-COM03-CAT-04` | Catalog Price/Modifier | Is Draft repricing enforced? | `OWNER_DECISION` + `REPOSITORY_FACT` | `ODB-CAT-09`; `Orders::Confirm`; confirm specs | Revised-quote review is required; repository inspection found that the current command does not enforce it. | Quote/version evidence, concurrency, UX and command contract. | Upstream Price facts, then technical design. | Catalog/Pricing and Ordering | Same three | Define evidence contract only after CAT-03 closes. | `DEPENDENCY_BLOCKED` |
| `W2-COM03-CAT-05` | Catalog Price/Modifier | Is sold-price provenance retained? | `OWNER_DECISION` + `REPOSITORY_FACT` | `ODB-CAT-10`; `Orders::CreateDraft`; create-draft specs | Later changes must not rewrite sold Price; repository inspection found that the current caller total is not provenance. | Order Item/component snapshot and Price-version reference. | Internal fact model then Owner/design review. | Catalog/Pricing supplies Price; Ordering retains confirmed evidence | All four, Cash indirectly | Inventory minimum sold provenance facts without selecting schema. | `INTERNAL_EVIDENCE_REQUIRED` |
| `W2-COM03-CAT-06` | Catalog Price/Modifier | How do Modifiers affect Price? | `OPEN_QUESTION` | `ODB-CAT-05`; Real Menu §§5–6 | Cardinality only is approved. | Delta permission, combination, floor, history, Tax and Refund behavior. | Actual menu evidence and Owner decision. | Catalog/Pricing; Promotions/Tax consulted | `P2A-PROMO-OD-05`, `W2-ORD-OD-01` | Obtain actual Modifier requirements, then ballot bounded alternatives. | `OWNER_DECISION_REQUIRED` |
| `W2-COM03-CAT-07` | Catalog Price/Modifier | Are free/zero items permitted and how treated? | `OPEN_QUESTION` + `DEPENDENCY` | Catalog discovery §4; W2-COM-02 scenarios `S-CAT-07` | Question exists; vendor gift examples are contextual only. | Provenance, eligibility, Tax, Refund and reporting. | Internal examples, qualified evidence, Owner decision. | Catalog/Pricing, Promotions, qualified Tax/Accounting | `P2A-PROMO-OD-05`, `W2-ORD-OD-01`, `P2B-CASH-OD-05` | Collect actual use cases before professional review. | `DEPENDENCY_BLOCKED` |
| `W2-COM03-PRO-01` | Promotions | Which Promotion types are supported? | `OPEN_QUESTION` | Promotions discovery §4.3; W2-COM-02 §5 | Four concepts are exploratory; general expression is a separate alternative. | Approved catalogue, formulas, caps, allocation and evidence. | Owner decision after source options are prepared. | Promotions | `P2A-PROMO-OD-05`, `W2-ORD-OD-01` | Present source-faithful type alternatives without selecting a subset. | `OWNER_DECISION_REQUIRED` |
| `W2-COM03-PRO-02` | Promotions | What eligibility/stacking facts are authoritative? | `OWNER_DECISION` + `OPEN_QUESTION` | `P2A-PROMO-OD-02/03`; Promotions discovery | Scope, explicit groups and deterministic priority directions exist. | Exact evidence, exclusions, ties, caps/floors and allocation. | Promotions facts and Owner decisions. | Promotions; Catalog/Ordering consulted | Same two | Build an eligibility/provenance matrix with no formula. | `PARTIALLY_CLOSED` |
| `W2-COM03-PRO-03` | Promotions | What applied-benefit provenance and reversal rules exist? | `OWNER_DECISION` + `DEPENDENCY` | `P2A-PROMO-OD-04/05`; W2-COM-02 §§5, 12 | Outcome distinctions and Promotions ownership exist. | Attribution, partial Refund/cancellation allocation, timing and rounding. | Payment/Catalog inputs then Owner policy. | Promotions | `P2A-PROMO-OD-05`, `P2B-CASH-OD-05`, `W2-ORD-OD-01` | Define provenance fields and synthetic outcomes after upstream closure. | `DEPENDENCY_BLOCKED` |
| `W2-COM03-PRO-04` | Promotions | Are administration boundaries established? | `OWNER_DECISION` + `OPEN_QUESTION` | Baseline `07A`–`07J` | Operation separation directions exist; `07J` disables emergency intervention. | Assignees, lifecycle details, scope/evidence and enforcement. | Owner policy and later P1/technical work. | Promotions; Identity consulted | `P2A-PROMO-OD-05` | Preserve boundaries; do not infer operational authority. | `PARTIALLY_CLOSED` |
| `W2-COM03-LOY-01` | Loyalty | What settled value earns Loyalty? | `OWNER_DECISION` + `OPEN_QUESTION` | `P2A-LOY-OD-01`; Loyalty discovery | Only authoritative successfully settled eligible value may earn. | Eligible components, formula, rate, timing and rounding. | Internal component facts and Owner decision. | Loyalty; Payment/Ordering consulted | `P2A-LOY-OD-05`, `W2-ORD-OD-01` | Prepare eligible-component alternatives after sold provenance closes. | `DEPENDENCY_BLOCKED` |
| `W2-COM03-LOY-02` | Loyalty | What redemption precision/order applies? | `OWNER_DECISION` + `OPEN_QUESTION` | `P2A-LOY-OD-02`; W2-COM-02 §§6, 9 | Limits, order and deterministic rounding are prerequisites. | Rate, exact limits, point unit, ordering and residual rule. | Loyalty Owner decision; Accounting consultation. | Loyalty | Same two | Prepare separate value, order and rounding questions. | `OWNER_DECISION_REQUIRED` |
| `W2-COM03-LOY-03` | Loyalty | How are Refund/cancellation reversals allocated? | `DEPENDENCY` | `P2A-LOY-OD-05`; Internal Fact Manifest §4 | Loyalty owns reversal; proportionality is not established. | Allocated successful outcome, eligible basis, timing, residual and negative balance. | Payment/Ordering facts then Loyalty decision. | Loyalty | `P2A-LOY-OD-05` | Build scenarios only after Refund/component facts close. | `DEPENDENCY_BLOCKED` |
| `W2-COM03-PAY-01` | Payment/Refund | What local confirmation behavior exists? | `OWNER_DECISION` + `IMPLEMENTED_BEHAVIOR` | `ODB-OP-10`, `15`; `Payments::Confirm`; cash/bank specs; concurrency specs | Exact-balance local confirmation, mismatch rejection, local idempotency/concurrency and immutable terminal evidence are bounded facts. | Provider behavior, Refunds, split tender and public API. | Repository inspection complete. | Payment | All four | Carry forward only the narrow local seam. | `CLOSED_BY_REPOSITORY_EVIDENCE` |
| `W2-COM03-PAY-02` | Payment/Refund | Is provider reconciliation implemented? | `OWNER_DECISION` + `REPOSITORY_FACT` | `ODB-OP-16`; Deep Review §§4–5 | Authoritative reconciliation/no blind retry is policy; repository inspection found no provider path. | Notification/query, signatures, event identity, dedupe and conflicts. | Qualified provider/acquirer evidence and later design. | Payment; provider/acquirer evidence provider | `P2B-CASH-OD-05`, `P2A-LOY-OD-05`, `P2A-PROMO-OD-05` | Retain `EU-W2-PAY-01`; no contact without authorization. | `QUALIFIED_EVIDENCE_REQUIRED` |
| `W2-COM03-PAY-03` | Payment/Refund | What does late-success evidence prove? | `OWNER_DECISION` + bounded `IMPLEMENTED_BEHAVIOR` | Late-success baseline; `Payments::Confirm`; late-success specs | Containment direction exists; local command behavior is demonstrated. | Provider-originated authoritative success and reconciliation path. | PAY-02 evidence first. | Payment; Ordering consulted | All four indirectly | Keep provider scenarios hypothetical. | `PARTIALLY_CLOSED` |
| `W2-COM03-PAY-04` | Payment/Refund | What Refund workflow and methods apply? | `OWNER_DECISION` + `REPOSITORY_FACT` | `P1A-OD-03`; Payment Model; Internal Fact Manifest §4 | Append-only/method-aware direction, cap and evidence principle exist; repository inspection found no executable workflow. | Executable workflow, eligibility, original/alternate method, provider result and authority. | Qualified evidence and Owner decisions. | Payment; Cash/Accounting/Reporting consulted | All four | Produce method/outcome matrix only after qualified input. | `DEPENDENCY_BLOCKED` |
| `W2-COM03-PAY-05` | Payment/Refund | How are partial/multiple-tender Refunds allocated? | `OWNER_DECISION` + `DEPENDENCY` | Deferred `P1A-OD-01`; approved `P1A-OD-03`; no allocation records | Split tender is deferred; funding vocabulary is not executable behavior. | Tender allocation, components, precision and residual owner. | Owner must first reopen funding-allocation policy. | Payment | All four | No allocation recommendation while upstream policy is deferred. | `DEPENDENCY_BLOCKED` |
| `W2-COM03-PAY-06` | Payment/Refund | What follows cancellation after settlement? | `OWNER_DECISION` + `OPEN_QUESTION` | `ODB-OP-12`–`14`; `P1A-OD-04/05` | Authority/stage boundaries exist. | Refund, stock, Loyalty, Promotion, remedy and reporting consequences. | Cross-domain consequence matrix and Owner decisions. | Ordering coordinates cancellation; source domains own consequences | All four | Prepare stage-specific consequences without reopening authority. | `DEPENDENCY_BLOCKED` |
| `W2-COM03-TAX-01` | Tax | Is the legal-source chain current? | `LEGAL_OR_PROFESSIONAL_EVIDENCE` | Official sources in §4.5, including Law 90/2025 | Source existence and repository-recorded metadata are established. | Applicability and interpretation. | Qualified Vietnamese Tax/Accounting review. | Qualified reviewer | `P2A-PROMO-OD-05`, `P2A-LOY-OD-05`, `W2-ORD-OD-01`, Cash where Refund applies | Preserve official chain in a scoped review brief. | `PARTIALLY_CLOSED` |
| `W2-COM03-TAX-02` | Tax | What Tax treatment applies to actual items/components? | `OPEN_QUESTION` + `LEGAL_OR_PROFESSIONAL_EVIDENCE` | W2-COM-02 §7; no item classification | No AFTER FOUR applicability conclusion exists. | Entity method, classification, rates, bases, presentation, aggregation, dates, invoices and corrections. | Qualified review then Owner policy. | Qualified Tax/Accounting; relevant business owner | Same four | Commission only after explicit authorization and actual item facts. | `QUALIFIED_EVIDENCE_REQUIRED` |
| `W2-COM03-SVC-01` | Service Charge/precision | Does Service Charge exist? | `OPEN_QUESTION` | Catalog discovery §4; Real Menu §10; vendor context | It is unresolved; vendor components do not establish policy. | Accountable policy owner, existence, scope/model/basis. | Owner decision after internal need is established. | Accountable owner not yet established; Tax/Accounting consulted | `P2A-PROMO-OD-05`, `P2A-LOY-OD-05`, `W2-ORD-OD-01` | Establish whether there is an actual business need before alternatives. | `OWNER_DECISION_REQUIRED` |
| `W2-COM03-SVC-02` | Service Charge/precision | How would Service Charge be taxed/refunded? | `DEPENDENCY` + `LEGAL_OR_PROFESSIONAL_EVIDENCE` | W2-COM-02 §§8, 12 | No treatment is established. | Disclosure, Tax, discounts, history and Refund allocation. | SVC-01 plus qualified evidence and Owner policy. | Future accountable owner; qualified Tax/Accounting; Payment | All four | Do not investigate formulas until existence is decided. | `DEPENDENCY_BLOCKED` |
| `W2-COM03-RND-01` | Service Charge/precision | What does integer storage establish? | `IMPLEMENTED_BEHAVIOR` | Order/Payment migrations/models; `Orders::CreateDraft` | Current amounts are integers with three-character currency codes. | Currency scale, calculation precision and rounding policy. | Repository fact closed; policy remains separate. | Payment/Ordering for current representation | All four | Record as narrow fact only. | `CLOSED_BY_REPOSITORY_EVIDENCE` |
| `W2-COM03-RND-02` | Service Charge/precision | What scale/stage/tie rules apply? | `OPEN_QUESTION` + `DEPENDENCY` | W2-COM-02 §9 and `S-RND-01`–`04` | No universal rule exists; Loyalty requires deterministic rounding. | Minor unit, stage, tie mode, aggregation and component variation. | Component Owner decisions and qualified Accounting/Tax input. | Component owners; qualified Accounting/Tax | All four | Prepare component-specific questions, not one assumed global rule. | `QUALIFIED_EVIDENCE_REQUIRED` |
| `W2-COM03-RND-03` | Service Charge/precision | Who owns residual allocation and historical rule provenance? | `OPEN_QUESTION` + `DEPENDENCY` | W2-COM-02 `S-RND-02/05/06`; `ODB-CAT-08/10` | Immutable Price/sold history does not version calculation rules or allocate residuals. | Discount, points, Tax, Refund/tender residuals and rule provenance. | Upstream component policies then Owner decision. | Source component domains; Ordering only proposed coordinator | All four | Compare deterministic strategies only after inputs close. | `DEPENDENCY_BLOCKED` |

## 6. Four blocked candidate assessments

| Candidate | Existing upstream evidence | Missing source-domain and qualified evidence | Owner decisions still required / why blocked | Minimum package for readiness reconsideration |
|---|---|---|---|---|
| `P2B-CASH-OD-05` | Refund is append-only/method-aware; Payment/Cash truth remains separate; exact-balance local seam exists. | Payment/provider authoritative outcome, amount, method and allocation; Cash drawer effect; Accounting/Reporting treatment. | Permitted method, alternate rail, correction/reconciliation consequences and authority remain unresolved. A Refund label cannot imply drawer movement. | Accepted method/outcome evidence plus allocated successful Refund facts and explicit Cash/Accounting/Reporting consequences. |
| `P2A-LOY-OD-05` | Loyalty owns reversal; linked history is preserved; earn uses settled eligible value. | Successful allocated Refund/cancellation, sold components, eligible basis, timing and residual evidence. | Reversal basis, proportionality, negative balance and rounding remain unresolved. | Authoritative allocated outcome and source-supported Loyalty reversal alternatives covering residual/negative cases. |
| `P2A-PROMO-OD-05` | Promotions owns benefit allocation/release/reversal; sold history remains immutable; lifecycle outcome distinctions exist. | Applied-benefit provenance, sold components, Refund/cancellation allocation, Tax/Service Charge/rounding. | Formula and partial-outcome consequences remain unresolved. | Stable component vocabulary, applied-benefit provenance, authoritative outcome inputs and comparable allocation/release/reverse choices. |
| `W2-ORD-OD-01` | Catalog Price/version/sold-history directions exist; component ownership is separated; current caller total is narrow evidence only. | Defined Price/Modifier, Promotion/Loyalty inputs, Payment/Refund, qualified Tax, Service Charge and precision evidence. | The calculation sequence/allocation policy is unresolved. Ordering is a proposed coordination candidate, not approved authority over inputs. | Every component defined or explicitly excluded, qualified evidence available, and required Owner policies decided so sequences can be compared without inventing source-domain policy. |

## 7. Cross-component dependency graph

| Upstream → downstream | Dependency conclusion |
|---|---|
| Catalog Price/Modifier → Promotion/Loyalty eligibility | Catalog supplies authoritative sold components; Promotion and Loyalty retain their own eligibility/formula policy. |
| Promotion/Loyalty → Order calculation | Their policies must be stable before sequence comparison. Ordering cannot select them. |
| Tax/Service Charge → component totals | Qualified evidence and Owner policy must precede inclusion, basis, order and rounding decisions. |
| Payment/provider → Refund → Cash/Loyalty/Promotions | Payment owns settlement/Refund truth; Cash owns drawer consequences; Loyalty and Promotions own their reversals. |
| Component precision → Order allocation | Each source domain supplies precision needs. `W2-ORD-OD-01` may later coordinate comparison but remains unresolved and blocked. |
| All commercial components → confirmed sold evidence | Ordering may retain confirmed evidence only through a later approved contract; no shared aggregate or cross-domain policy transfer is implied. |

The apparent cycle is coordination, not shared ownership. Catalog/Pricing, Promotions, Loyalty and Payment remain accountable for their source facts and policies. Qualified Tax/Accounting sources provide professional evidence. No row grants Ordering final authority.

## 8. Parallel work package recommendations

| Work package | Can proceed now? | Inputs and bounded deliverable | Dependency order |
|---|---|---|---|
| `W2-COM03-A` Catalog facts | Yes, internally | Actual Product/Variant/Modifier/default/Branch Price inventory and absent-runtime evidence; no schema. | Parallel first wave. |
| `W2-COM03-B` Promotion provenance | Yes, internally | Eligibility and applied-benefit fact matrix; no formula or allocation choice. | Parallel first wave. |
| `W2-COM03-C` Loyalty components | Partly | Candidate eligible components and current absence; no rate/reversal choice. | Parallel first wave; final work waits for Payment/components. |
| `W2-COM03-D` Payment/provider/Refund | Internal portion only | Local seam inventory and provider evidence questions. External/provider work requires authorization. | Parallel first wave; provider result precedes downstream reversals. |
| `W2-COM03-E` Tax/Accounting | Preparation only | Scoped item/component fact pack and review questions. No commissioning/contact without authorization. | After actual component facts; before Tax/rounding policy. |
| `W2-COM03-F` Service Charge/precision | Service Charge need and current-state precision only | Determine actual need; inventory current representation. | Service Charge policy precedes its Tax/Refund research; component policies precede residual comparison. |
| `W2-COM03-G` Ordering sequence comparison | No | Deterministic alternatives preserving provenance. | Last, after A–F inputs and required Owner decisions. |

## 9. Owner decisions still required

1. Catalog effective-time semantics, Modifier pricing behavior, and free/zero treatment.
2. Promotion type catalogue, formulas, eligibility detail, caps/floors, tie/allocation and Refund/cancellation consequences.
3. Loyalty eligible components, rates, redemption order/limits/rounding and reversal outcomes.
4. Refund eligibility, method matrix, partial allocation, authority and cancellation consequences; split tender stays deferred unless separately reopened.
5. Actual Tax business treatment only after qualified evidence.
6. Whether Service Charge exists and, if so, its accountable policy owner, scope/model/basis and downstream treatment.
7. Component-specific precision, rounding and residual rules.
8. Only after those inputs close: whether to approve an Order-level calculation sequence/allocation policy under `W2-ORD-OD-01`.

These are review questions, not ballots or implied selections.

## 10. Qualified professional evidence still required

| Evidence | Required source | Prerequisite and limitation |
|---|---|---|
| Provider notification/query/result and Refund rails | Provider/acquirer evidence through Payment | Requires separate authorization; no current contact or request delivery. |
| VAT/item/component applicability, rates, basis, aggregation, invoice, effective transitions and corrections | Qualified Vietnamese Tax/Accounting reviewer | Requires actual entity, item and workflow facts; official-source existence is insufficient. |
| Service Charge disclosure, Tax and accounting treatment | Qualified Vietnamese legal/Tax/Accounting reviewer | Only after the Owner establishes whether the concept exists and its scope. |
| Monetary scale, statutory/accounting rounding and residual treatment | Qualified Accounting/Tax reviewer plus component owners | Must distinguish legal/accounting requirements from Owner business choices and technical representation. |

No reviewer, recipient, qualification, engagement, expenditure or disclosure is selected or authorized.

## 11. Explicit exclusions and governance boundaries

The canonical reconciliation remains `16 + 22 + 2 + 3 + 12 = 55`. The four assessed candidates remain `DEPENDENCY_BLOCKED`. All nine external evidence requests remain `PENDING — NOT_SENT — NOT_READY_FOR_OWNER_AUTHORIZATION`; the six coordination scopes and nine request mappings are unchanged.

This review allocates, reserves or proposes no `ODB-*` ID; changes no Owner decision or readiness; and authorizes no external contact, disclosure, procurement, professional engagement, physical database design, schema, migration, database operation, persistence, transaction/locking/isolation mechanism, API, source code, test, dependency, runtime behavior, deployment, Gate A/B/C, Control Acceptance, FOA or Production Authorization. Vendor evidence remains contextual and never establishes AFTER FOUR policy. No implementation, test or database command was executed for this review.

## 12. Validation and reconciliation

Document-level reconciliation:

- Six commercial components are assessed independently.
- All four exact blocked candidates are assessed without status change.
- Stable gap IDs are unique within this document and use only the permitted local closure statuses.
- Owner decisions, repository behavior, vendor evidence and qualified professional evidence are attributed separately.
- The VAT chain includes Law 90/2025/QH15 in its correct position between Law 48/2024/QH15 and later amendments; no rate/applicability conclusion is inferred.
- Ordering remains only a proposed coordination candidate under unresolved `W2-ORD-OD-01`.
- No factual closure is represented as policy approval or implementation authorization.
- Markdown links, tables, headings and fences require repository validation at the commit gate; this research step does not claim application or database verification.

Remaining ambiguity is explicit rather than guessed: Service Charge policy ownership is not yet established; provider and qualified professional evidence has not been commissioned; actual menu/Price/Modifier facts are incomplete; and no component calculation sequence can yet be compared authoritatively.
