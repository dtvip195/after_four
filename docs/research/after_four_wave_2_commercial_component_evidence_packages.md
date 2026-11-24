# AFTER FOUR — Wave 2 Commercial Component Evidence Packages

**Work package:** `W2-COM-02`

**Status:** `INTERNAL_EVIDENCE_PREPARATION — POLICY_AND_IMPLEMENTATION_NOT_AUTHORIZED`

**Evidence cutoff:** 2026-11-24 (Asia/Tokyo)

## 1. Purpose, scope and non-authoritative status

This package reconciles evidence for Catalog Price/Modifier pricing, Promotions, Loyalty, Tax, Service Charge, and rounding/monetary precision. It prepares source facts and questions for the four dependency-blocked candidates `P2B-CASH-OD-05`, `P2A-LOY-OD-05`, `P2A-PROMO-OD-05`, and `W2-ORD-OD-01`. It does not select a formula, calculation order, policy, legal interpretation, database representation, or implementation.

## 2. Executive evidence summary

| Component | Established boundary | Principal unresolved evidence |
|---|---|---|
| Catalog Price / Modifier | Variant identity, chain default with explicit Branch override, immutable/effective-dated Price versions, Draft repricing review, and sold-price lock are Owner decisions. Catalog Core implements no Price or Modifier behavior. | Actual Price facts, Modifier price effects, effective-time semantics, publication authority, and full sold provenance. |
| Promotions | Promotions owns applicability, benefit calculation/allocation, and reserve/redeem/release/reverse consequences. Several bounded governance directions are Owner-confirmed. | Initial type catalogue, formulas, eligibility detail, tie-breaking, allocation, lifecycle timing, Refund/cancellation consequences, and remaining operation authorities. |
| Loyalty | Earn on authoritative successfully settled eligible value and bounded redemption/adjustment/scope directions are confirmed. | Eligible components, rates, limits, deterministic ordering/rounding, and Refund/cancellation reversal allocation. |
| Tax | A current Vietnamese VAT/invoice legal framework exists; AFTER FOUR has no approved tax policy or implementation. | Entity/method/item applicability, rates, inclusive/exclusive treatment, taxable basis, aggregation, invoices, Refund/cancellation, and qualified interpretation. |
| Service Charge | Vendor products expose a separate component; AFTER FOUR treats it only as an unresolved commercial concept. | Whether it exists, scope/model/basis, tax treatment, discounts, historical evidence, and Refund/cancellation allocation. |
| Rounding / precision | Current integer amount storage is narrow implementation evidence; no universal monetary rounding policy exists. | Currency scale, stage, tie mode, allocation residuals, component interactions, historical versioning, and Refund/split-tender precision. |

No inspected vendor feature establishes AFTER FOUR policy. No design artifact establishes implementation without a cited source path and test boundary.

## 3. Evidence classification and source methodology

| Label | Meaning |
|---|---|
| `REPOSITORY_FACT` | A statement supported by a current repository artifact within that artifact's maturity. |
| `IMPLEMENTED_BEHAVIOR` | Actual source plus inspected test evidence for a narrow local/test behavior; not a production claim. |
| `OWNER_DECISION` | Explicitly approved in the canonical Owner Decision Baseline. |
| `EXTERNAL_VENDOR_EVIDENCE` | A vendor-specific feature/example; never AFTER FOUR policy. |
| `LEGAL_OR_PROFESSIONAL_EVIDENCE` | Official legal material or qualified professional evidence; applicability still requires scoped review. |
| `UNVERIFIED_ASSUMPTION` | Existing example or statement without authoritative verification. |
| `OPEN_QUESTION` | Unresolved fact or Owner policy question. |
| `DEPENDENCY` | Another domain or qualified source must establish the input first. |

For every package below, “does not establish” is as important as “establishes.” Tests were inspected but not executed. `NO_REPOSITORY_EVIDENCE_FOUND` means the inspected repository does not support the claim.

## 4. Catalog Price and Modifier evidence package

| Question | Classification | Evidence and source | Establishes | Does not establish / affected candidates |
|---|---|---|---|---|
| Sellable identity | `OWNER_DECISION` + bounded `IMPLEMENTED_BEHAVIOR` | `ODB-CAT-04`; [Catalog discovery §2](../architecture/after_four_catalog_pricing_discovery.md#2-original-discovery-conclusions-closed-by-the-owner); [Catalog migration](../../backend/db/migrate/20261115210000_create_catalog_core_foundation.rb) and [record specs](../../backend/spec/domains/catalog/infrastructure/persistence/catalog_records_spec.rb) | A sellable selection uses a persisted Variant; Product/Variant identity/lifecycle persistence exists. | No menu, Price or selling behavior. `PROMO-05`, `LOY-05`, `W2-ORD-OD-01`. |
| Default and Branch Price | `OWNER_DECISION` | `ODB-CAT-07`; [Catalog discovery §3](../architecture/after_four_catalog_pricing_discovery.md#3-consequences-for-the-logical-design) | Chain default with explicit Branch override; absent effective override falls back to default. | No table, actual Price, publication capability, interval selection or runtime lookup. |
| Price version/history | `OWNER_DECISION` | `ODB-CAT-08` | Versions are immutable/effective-dated; corrections create a new version. | No timezone, boundary inclusivity, overlap/tie rule or implementation. |
| Draft repricing | `OWNER_DECISION` | `ODB-CAT-09` | Revised-quote review is required before confirming a Draft after authoritative Price change. | No quote token, review UI/evidence, concurrency or command. |
| Sold Price | `OWNER_DECISION` | `ODB-CAT-10`; [Glossary](../../GLOSSARY.md) | Sold Price is locked at confirmation and later Catalog changes cannot rewrite history. | No implemented Order Item/component snapshot or Price-version provenance. |
| Current implementation | `IMPLEMENTED_BEHAVIOR` | [`Orders::CreateDraft`](../../backend/app/domains/orders/create_draft.rb), [`Orders::Confirm`](../../backend/app/domains/orders/confirm.rb), and their inspected specs | Phase 1 accepts a caller-supplied integer `total_amount`, copies it to Payment target, and confirms lifecycle state. | It proves no server-side Catalog calculation, repricing check, Price version or sold snapshot. |
| Modifier pricing | `OPEN_QUESTION` | `ODB-CAT-05`; [Real Menu §§5–6](../architecture/after_four_real_menu_pricing_specification.md#5-modifier-groups) | Modifier cardinality exists as policy; template mentions possible deltas. | Whether zero/positive/negative deltas exist, combination rules, floors, history, tax and Refund behavior. |
| Free/zero-priced facts | `OPEN_QUESTION` | [Catalog discovery §4](../architecture/after_four_catalog_pricing_discovery.md#4-unresolved-decisions-preserved) | The question is explicitly open. | No permission, provenance, tax or accounting treatment. |
| Actual menu/Price data | `UNVERIFIED_ASSUMPTION` | [Real Menu §§3–10](../architecture/after_four_real_menu_pricing_specification.md#3-danh-sách-product) | Current input document contains blanks/`TBD`/examples. | No approved launch Product, Variant, Modifier or Branch Price facts. |

## 5. Promotions evidence package

| Question | Classification | Established evidence | Remaining boundary |
|---|---|---|---|
| Type surface | `OPEN_QUESTION` | [Promotion discovery §4.3](after_four_p2a_promotions_policy_discovery.md#43-calculation-stacking-and-precedence) lists fixed, percentage, bundle and free-item only as exploratory concepts; vendor `CUK-01`–`04`/`KIOT-01` show finite product-specific forms. | `P2A-PROMO-OD-01` is `REQUEST_SOURCE_OPTIONS`; no catalogue or general expression is approved. |
| Applicability | `OWNER_DECISION` + `OPEN_QUESTION` | `P2A-PROMO-OD-02` requires explicit applicability inside the current one-Organization/one-Brand assumption; cross-Brand remains unavailable/default-deny. | Exact Product/Variant/Branch/channel/Order/public-versus-Customer-specific combinations. |
| Eligibility/exclusions | `REPOSITORY_FACT` + `OPEN_QUESTION` | Promotions owns evaluation against authoritative inputs and must not mutate their sources. | Exact evidence, exclusions, caps/floors and rejected-input behavior. |
| Stacking/priority | `OWNER_DECISION` + `OPEN_QUESTION` | `P2A-PROMO-OD-03` confirms explicit stacking/exclusion groups and deterministic priority. | Tie-breaking, group definitions, caps/floors, allocation and Loyalty interaction. |
| Allocation | `DEPENDENCY` | Promotions owns applied-benefit attribution/allocation; Catalog Price remains separate and sold history immutable. | Line/component allocation, Modifier interaction, tax/service/rounding and Refund/cancellation policy; `P2A-PROMO-OD-05` remains blocked. |
| Benefit outcomes | `OWNER_DECISION` + `OPEN_QUESTION` | `P2A-PROMO-OD-04` distinguishes reserve, redeem, release and reverse. | Types, timing, failure/abandonment, quantities and authoritative Order/Payment inputs. |
| Administration | `OWNER_DECISION` | `07A` Draft creation, `07C` submission, `07D` approval and `07J` disabled emergency intervention are recorded; `07B`, `07E`–`07I` have bounded confirmed directions. | Assignees, full lifecycle, exact scope/evidence, escalation and technical enforcement remain unresolved. Submission, approval and publication stay distinct. |
| Version/correction | `OWNER_DECISION` direction + `OPEN_QUESTION` | `07I` preserves applied history through prospective linked correction/replacement. | Version identity, materiality, reach, requester/approver separation and Customer treatment. |
| Vendor context | `EXTERNAL_VENDOR_EVIDENCE` | `SAPO-05`, `KIOT-01`, `CUK-01`–`04`, `IPOS-01` in [POS evidence §4](after_four_wave_2_vietnam_pos_comparative_evidence.md#4-source-register). | Vendor formulas/features are not AFTER FOUR requirements, authority or calculation order. |

## 6. Loyalty evidence package

| Question | Classification | Established evidence | Remaining boundary |
|---|---|---|---|
| Ledger/history | `REPOSITORY_FACT` / design | [Loyalty discovery §§3–4](after_four_p2a_loyalty_policy_discovery.md#3-domain-language-and-ownership) assigns Loyalty-owned account/ledger/balance concepts and recommends linked history. | No physical ledger, entry taxonomy, balance materialization or implementation. |
| Earning input | `OWNER_DECISION` | `P2A-LOY-OD-01`: earn only on authoritative successfully settled eligible value. | Formula, rate, eligible/excluded components, products/channels, rounding and reversal. |
| Redemption | `OWNER_DECISION` | `P2A-LOY-OD-02`: explicit limits, ordering and deterministic rounding must exist before enablement. | Points-to-value rate, exact limits/order, Promotion interaction and recovery. |
| Adjustments | `OWNER_DECISION` | `P2A-LOY-OD-04`: material adjustments use bounded requester/approver capabilities; emergency handling is separate. | Materiality, self-approval boundary, evidence and emergency cases. |
| Refund/cancellation | `DEPENDENCY` | Loyalty owns reversal; Payment/Ordering must provide authoritative allocated outcome. | No proportionality, timing, residual or negative-balance rule; `P2A-LOY-OD-05` remains blocked. |
| Scope | `OWNER_DECISION` | `P2A-LOY-OD-06`: shared across Branches only within initial one-Organization/one-Brand assumption; cross-Brand unavailable/default-denied. | Exact balance ownership/current-scope Branch behavior and future multi-Brand policy. |
| Anonymization | `OWNER_DECISION` | Customer decisions preserve required ledger/history, freeze redemption/new Customer-specific benefit issue, prohibit transfer/reconstruction, and use pseudonymous references where justified. | Retention period, technical reference, access and disposal mechanisms. |
| Implementation | `NO_REPOSITORY_EVIDENCE_FOUND` | Current discovery/deep review identifies no Loyalty earning/redemption/reversal runtime. | No executable formula, ledger, API or production behavior. |

## 7. Tax evidence package

Repository status is `QUALIFIED_EVIDENCE_REQUIRED` + `OPEN_QUESTION`: no approved tax inclusion/basis, category/rate assignment, calculation level/order, rounding, invoice treatment or implementation exists.

| Official source at cutoff | Date/effect verified | What it establishes | Limitation |
|---|---|---|---|
| [Law 48/2024/QH15 — VAT Law](https://vanban.chinhphu.vn/?docid=212476&orggroupid=1&pageid=27160) | Issued 2024-11-26; effective 2025-07-01 | Primary VAT framework. | Does not classify AFTER FOUR's actual items/components by itself. |
| [Law 149/2025/QH15](https://vanban.chinhphu.vn/?classid=1&docid=216588&pageid=27160) | Issued 2025-12-11; effective 2026-01-01 | Amends the VAT Law. | Qualified review must apply the amended text. |
| [Law 09/2026/QH16](https://vanban.chinhphu.vn/?classid=1&docid=218095&pageid=27160) | Issued/effective 2026-04-24 | Further amends the VAT Law together with other tax laws. | The amendment's applicability to actual AFTER FOUR items and transactions requires qualified review. |
| [Decree 181/2025/NĐ-CP](https://vanban.chinhphu.vn/?docid=214336&lead=merchant-dgmkt&pageid=27160), [359/2025/NĐ-CP](https://vanban.chinhphu.vn/?classid=1&docid=216388&pageid=27160&typegroupid=4), [144/2026/NĐ-CP](https://vanban.chinhphu.vn/?docid=218020&pageid=27160&typegroupid=4) | Effective 2025-07-01, 2026-01-01 and 2026-06-20 respectively | Current implementing/amendment chain at the cutoff. | No software formula or item applicability is inferred. |
| [Circular 69/2025/TT-BTC](https://vanban.chinhphu.vn/?classid=1&docid=214417&orggroupid=4&pageid=27160) | Issued/effective 2025-07-01 | Detailed VAT guidance. | Requires qualified applicability analysis. |
| [Resolution 204/2025/QH15](https://vanban.chinhphu.vn/default.aspx?docid=214209&pageid=27160) and [Decree 174/2025/NĐ-CP](https://vanban.chinhphu.vn/?classid=0&docid=214310&pageid=27160) | Reduction framework effective 2025-07-01 through 2026-12-31 | Temporary reduction exists for covered groups subject to exclusions/method conditions. | Does not prove any AFTER FOUR item is covered or select a stored rate. |
| [Decree 70/2025/NĐ-CP](https://vanban.chinhphu.vn/?classid=1&docid=213179&pageid=27160&typegroupid=4) and [Circular 32/2025/TT-BTC](https://vanban.chinhphu.vn/?classid=1&docid=213855&pageid=27160&typegroupid=6) | Both effective 2025-06-01 | Current invoice/evidence framework amending/guiding Decree 123/2020. | Does not settle AFTER FOUR invoice design or compliance. |

Qualified Vietnamese tax/accounting review must determine actual taxpayer/entity method, item/service classification, applicable rate, inclusive/exclusive presentation, taxable components, line/order aggregation, effective-date transitions, invoice evidence, Refund/cancellation and historical correction. This package provides no legal advice or compliance conclusion.

## 8. Service Charge evidence package

| Question | Classification | Evidence | Boundary |
|---|---|---|---|
| Does it exist? | `OPEN_QUESTION` | Catalog discovery §4 and Real Menu §10 retain Service Charge as unresolved. | No approved requirement, enablement or rate. |
| Vendor examples | `EXTERNAL_VENDOR_EVIDENCE` | `SAPO-05` and `IPOS-01` expose separate service-charge/service-fee components. | No portable model, basis, order, tax or Refund rule. |
| Implementation | `NO_REPOSITORY_EVIDENCE_FOUND` | Current Catalog/Ordering paths cited in the [deep review §§6–7](after_four_wave_2_payment_catalog_evidence_deep_review.md#6-catalogpricing-source-inventory). | No component, calculation or sold snapshot. |
| Price/consumer context | `LEGAL_OR_PROFESSIONAL_EVIDENCE` | [Law on Prices 16/2023/QH15](https://vanban.chinhphu.vn/?classid=1&docid=208367&orggroupid=1&pageid=27160), effective 2024-07-01; [Decree 85/2024/NĐ-CP](https://vanban.chinhphu.vn/?docid=210648&pageid=27160), amended by [128/2026/NĐ-CP](https://vanban.chinhphu.vn/?classid=1&docid=217625&pageid=27160), effective 2026-04-06; [Consumer Protection Law 19/2023/QH15](https://vanban.chinhphu.vn/?classid=1&docid=208363&pageid=27160), effective 2024-07-01. | These establish current price/consumer-law context, not permission, disclosure method, tax status or Refund treatment for a proposed restaurant Service Charge. |

Applicability scope, fixed/percentage/other model, basis, tax, Promotion/Loyalty interaction, Refund/cancellation allocation, historical evidence and distinction from tips/delivery/other fees all remain open and require qualified evidence.

## 9. Rounding and monetary precision evidence package

| Question | Classification | Evidence | Boundary |
|---|---|---|---|
| Stored Phase 1 amounts | `IMPLEMENTED_BEHAVIOR` | [Payment](../../backend/app/models/payment.rb), [`Orders::CreateDraft`](../../backend/app/domains/orders/create_draft.rb), database migration/specs use integer amounts and three-letter currency codes. | Narrow integer storage does not approve universal currency precision, rounding mode or component calculations. |
| Catalog/Order calculations | `OPEN_QUESTION` | `ODB-CAT-08` boundary; [upstream review §5](after_four_wave_2_upstream_commercial_dependency_evidence_review.md#5-catalogpricing-total-component-review) | No line/component/Order rounding stage, scale, tie rule or residual allocation. |
| Promotion allocation | `DEPENDENCY` | Promotion allocation and caps/floors are open. | No deterministic residual allocation or Refund reversal rule. |
| Loyalty | `OWNER_DECISION` + `OPEN_QUESTION` | `P2A-LOY-OD-02` requires deterministic rounding before redemption. | No points unit, rate, minimum, order or residual policy. |
| Tax/Service Charge | `QUALIFIED_EVIDENCE_REQUIRED` | Current legal framework exists; qualified accounting/tax input remains absent. | No aggregation/rounding or invoice policy. |
| Split tender/Refund | `OWNER_DECISION — DEFERRED` + `DEPENDENCY` | `P1A-OD-01`; `P1A-OD-03` cap principle. | No allocation precision, residual owner or deterministic tie rule. |
| Historical reproducibility | `OPEN_QUESTION` | Immutable Price/sold history directions exist. | No versioned calculation/rounding rule provenance. |

Display formatting must not be treated as stored precision. No universal rounding mode or calculation level is selected here.

## 10. Synthetic scenario matrix

Every row is synthetic, non-authoritative, and uses no real Customer, employee, provider or transaction data. “Required evidence” identifies the accountable source; no row defines an expected final amount.

| ID | Component / synthetic input | Known direction / repository behavior | External evidence | Unresolved question and required source | Affected candidates |
|---|---|---|---|---|---|
| S-CAT-01 | Default Price; no Branch override | `ODB-CAT-07` fallback direction | Vendor channel-price context only | Effective Price/version facts — Catalog/Pricing | `PROMO-05`, `LOY-05`, `ORD-01` |
| S-CAT-02 | Effective Branch override | Explicit override direction | Context only | Time/publication/unique selection — Catalog/Pricing | Same |
| S-CAT-03 | Price changes immediately before confirmation | `ODB-CAT-09` requires review | None required | Boundary, quote/review evidence — Catalog/Ordering | Same |
| S-CAT-04 | Price changes after confirmation | `ODB-CAT-10` preserves sold Price | None | Full sold provenance — Ordering/Catalog | Same |
| S-CAT-05 | Draft repricing | Review required; no runtime check | None | Review authority/contract — Catalog/Ordering | `ORD-01` |
| S-CAT-06 | Modifier with positive or negative adjustment | Modifier cardinality only | Vendor modifier context does not select arithmetic | Permission, combination, floor — Catalog/Pricing | `PROMO-05`, `ORD-01` |
| S-CAT-07 | Free item and zero-priced Modifier | No policy | Vendor gifts context only | Provenance/tax/refund — Catalog/Promotions/qualified tax | `PROMO-05`, `ORD-01` |
| S-PRO-01 | Fixed discount concept | Exploratory, not approved | Vendor fixed-amount examples | Type/formula/cap/allocation — Promotions | `PROMO-05`, `ORD-01` |
| S-PRO-02 | Percentage discount concept | Exploratory, not approved | Vendor percentage examples | Basis/cap/rounding — Promotions/Ordering | Same |
| S-PRO-03 | Bundle/free-item concept | Exploratory only | Vendor bundle/gift examples | Qualification/provenance/tax — Promotions/Catalog/tax | Same |
| S-PRO-04 | Promotion plus Modifier Price | Ownership separated | Context only | Eligibility basis and allocation — Promotions/Catalog | Same |
| S-PRO-05 | Two eligible Promotions conflict | Explicit groups/priority direction | Vendor exclusions are subdimension context | Tie/group/cap — Promotions | `ORD-01` |
| S-PRO-06 | Promotion plus Loyalty redemption | Both component owners retain policy | No portable order | Eligibility/order/rounding — Promotions/Loyalty/Ordering | `LOY-05`, `PROMO-05`, `ORD-01` |
| S-PRO-07 | Cancellation/Refund after benefit applied | Reserve/redeem/release/reverse distinct | Return/cancel examples only | Allocation and outcome — Promotions/Payment/Ordering | `PROMO-05`, `CASH-05` |
| S-LOY-01 | Earn after successful settlement | Earn only on settled eligible value | Points examples context only | Formula/components/timing — Loyalty/Payment/Ordering | `LOY-05`, `ORD-01` |
| S-LOY-02 | Earn with Promotion discount | No eligible-value formula | Context only | Gross/net/allocated basis — Loyalty/Promotions | Same |
| S-LOY-03 | Earn with Service Charge or Tax | No inclusion policy | Vendor components only | Eligible components — Loyalty/qualified tax/accounting | Same |
| S-LOY-04 | Partial Refund after earning | Loyalty owns reversal; proportionality not implied | Discounted return example only | Allocated outcome/reversal — Loyalty/Payment/Ordering | `LOY-05` |
| S-LOY-05 | Redemption combined with Promotion | Deterministic order required before enablement | None portable | Order, caps, recovery — Loyalty/Promotions/Ordering | `ORD-01` |
| S-LOY-06 | Fractional redemption residual | Deterministic rounding required | None | Points/value units and residual owner — Loyalty/Accounting | `LOY-05`, `ORD-01` |
| S-TAX-01 | Tax-inclusive versus tax-exclusive alternatives | No approved treatment | Vendor tax fields only | Actual applicability/basis — qualified Vietnamese tax/accounting | `PROMO-05`, `ORD-01` |
| S-TAX-02 | Multiple hypothetical tax categories | No item classification | None sufficient | Item/service classification — qualified tax/accounting | `ORD-01` |
| S-TAX-03 | Rate/effective rule changes between Draft and confirmation | Price review/sold-history directions only | None | Legal effective date and Order evidence — tax/Catalog/Ordering | `ORD-01` |
| S-SVC-01 | Service Charge before/after discount | No policy | Vendor separate component only | Existence, basis, order — Owner + qualified tax/accounting | `PROMO-05`, `ORD-01` |
| S-SVC-02 | Partial cancellation/Refund of charged Order | No allocation policy | Vendor cancel context only | Refund allocation — Payment/Ordering/Accounting | All four |
| S-SVC-03 | Taxable versus non-taxable Service Charge | No treatment | None sufficient | Legal classification/basis — qualified tax/accounting | `PROMO-05`, `ORD-01` |
| S-RND-01 | Fractional line discount | No rounding rule | None portable | Scale/stage/tie — Promotions/Ordering/Accounting | `PROMO-05`, `ORD-01` |
| S-RND-02 | Percentage discount across multiple lines | No allocation residual rule | Context only | Residual allocation — Promotions/Ordering | Same |
| S-RND-03 | Tax per line versus Order | No aggregation rule | None sufficient | Legal/accounting aggregation/rounding — qualified reviewer | `ORD-01` |
| S-RND-04 | Loyalty points from fractional eligible value | Deterministic rounding required | None | Point unit/tie — Loyalty | `LOY-05`, `ORD-01` |
| S-RND-05 | Partial Refund leaves minor-unit residual | Refund cap only | None | Component/tender allocation — Payment/Ordering/Accounting | `CASH-05`, `LOY-05`, `PROMO-05` |
| S-RND-06 | Multiple tenders leave allocation residual | Split tender deferred | None | Tender policy/precision — Payment/Cash/Accounting | `CASH-05`, `ORD-01` |

## 11. Cross-component dependency map

| Edge | Evidence status | Unresolved authority/evidence |
|---|---|---|
| Catalog Price → Modifier → Promotion | Price ownership is an `OWNER_DECISION`; Modifier effect and Promotion basis are `OPEN_QUESTION`/`DEPENDENCY`. | Catalog/Pricing owns source facts; Promotions owns eligibility/application. |
| Promotion → Loyalty eligible value | Separate component ownership is a `REPOSITORY_FACT`; no formula/order exists. | Promotions and Loyalty each own their consequence; Ordering coordinates only after inputs close. |
| Tax → Service Charge tax treatment | `LEGAL_OR_PROFESSIONAL_EVIDENCE` required. | Qualified Vietnamese tax/accounting evidence plus an accountable Owner policy; Ordering must not decide it implicitly. |
| Rounding → all components | Design dependency only. | Each component owner supplies its rounding need; Ordering owns final sequence/allocation after policy closure. |
| Components → Payment tender/Refund | Payment owns settlement/Refund truth; sold components come from Ordering/component owners. | Provider, Payment, Accounting and component allocation evidence. |
| Refund/cancellation → Cash/Loyalty/Promotions | Context ownership established; outcome mapping unresolved. | Cash owns drawer consequence; Loyalty/Promotions own reversals; Ordering owns cancellation commercial history. |
| All components → Ordering contract | Ordering ownership of sequence/allocation is established. | No canonical sequence until every included component is defined or explicitly excluded by Owner decision. |

The apparent cycle is coordination, not shared aggregate ownership: source domains first define authoritative inputs; downstream consequence policy follows; Ordering then compares deterministic sequences. Tax, Service Charge and rounding accountability still require explicit Owner confirmation and qualified input.

## 12. Four-candidate dependency mapping

| Candidate | Exact missing upstream facts and owner | Existing evidence | Sufficient evidence to reconsider readiness |
|---|---|---|---|
| `P2B-CASH-OD-05` | Refund method/result/tender allocation — Payment/provider; actual drawer effect — Cash; classification/reporting — Accounting/Reporting | Append-only method-aware Refund principle; exact-balance local seam; vendor returns context only | Accepted provider/method outcome and allocated Refund facts explicitly identifying whether/how much Cash moves, plus accounting/reporting treatment. |
| `P2A-LOY-OD-05` | Refunded/cancelled sold components — Payment/Ordering; earning/redemption basis and reversal — Loyalty; rounding — Loyalty/Accounting | Loyalty ownership/directions; immutable history; no allocation formula | Authoritative successful allocated outcome and source-supported Loyalty reversal choices covering residual/negative cases. |
| `P2A-PROMO-OD-05` | Applied benefit attribution — Promotions; sold components — Catalog/Ordering; Refund/cancellation — Payment/Ordering; tax/service/rounding — qualified/component owners | Promotion outcome distinctions and stacking direction; vendor examples only contextual | Closed component vocabulary, applied-benefit provenance and authoritative Refund/cancellation inputs sufficient to compare allocation/release/reverse options. |
| `W2-ORD-OD-01` | Price/Modifier — Catalog; Promotion/Loyalty inputs — their domains; Tax/Service Charge/rounding — qualified evidence and Owner policy | Price/version/sold-history directions; current caller-supplied total is narrow implementation only | Every participating component is defined or explicitly excluded, with accountable owners and qualified evidence, enabling deterministic sequence comparison without inventing input policy. |

Each gap is partly preparable through internal source inventories and synthetic scenarios. None is sufficiently closed to change `DEPENDENCY_BLOCKED`.

## 13. Qualified evidence gaps and accountable domains

| Evidence gap | Accountable domain / qualified source | Current state |
|---|---|---|
| Actual Price/Modifier/Branch versions | Catalog/Pricing | Internal facts incomplete; no runtime Price implementation. |
| Promotion formula/allocation/lifecycle consequences | Promotions, consulting Catalog/Ordering/Customer | Policy incomplete; vendor context is not authority. |
| Loyalty eligible value/redemption/reversal | Loyalty, consulting Payment/Ordering/Promotions | Bounded directions only. |
| Tax categories, rates, bases, invoices, effective changes | Qualified Vietnamese tax/accounting/legal reviewer; Owner confirms business policy | Official sources identified; applicability not assessed or commissioned. |
| Service Charge existence/model/tax/refund | Owner/accountable commercial domain plus qualified tax/accounting input | Accountable policy owner not fully established. |
| Rounding/precision/residuals | Component owners + Ordering + qualified Accounting where applicable | No universal rule. |
| Provider/tender/Refund behavior | Payment plus provider/acquirer and Accounting/Reporting | `EU-W2-PAY-01` pending/not sent. |

## 14. Owner review questions — not ballots

1. Which actual Price/Modifier inputs and publication/correction authorities may later enter a bounded design?
2. Which bounded Promotion types, eligibility facts, allocation outcomes and lifecycle consequences should be presented after evidence closure?
3. Which values are Loyalty-eligible, and what rate/limits/order/rounding/reversal choices should be presented after Payment/component evidence?
4. After qualified review, what tax presentation, basis, aggregation, historical evidence and change behavior apply?
5. Does Service Charge exist; if so, what scope/model/basis/disclosure/tax/refund boundaries apply?
6. Which monetary precision, rounding stages, tie rules, residual allocation and versioned provenance apply per component?
7. Which components are included or explicitly excluded before Ordering compares calculation sequences?

These questions preselect no answer and allocate no authority.

## 15. Recommended next evidence work

1. Freeze actual Catalog Price/Modifier/Branch input facts and current implementation absence.
2. Produce separate Promotions and Loyalty component/provenance matrices without formulas.
3. Obtain explicit Owner authorization before commissioning qualified tax/accounting/legal review; send no current request.
4. Prepare Service Charge alternatives only after its accountable policy owner and qualified evidence needs are confirmed.
5. Maintain a synthetic calculation corpus that records divergent outcomes without expected totals or recommendations.
6. Reconcile Payment/provider facts, then prepare downstream Cash/Loyalty/Promotion consequence choices.
7. Prepare Ordering sequence options last.

## 16. Governance and implementation boundary

Canonical status reconciliation remains `16 + 22 + 2 + 3 + 12 = 55`. The twelve dependency-blocked candidates, including the four in this package, remain unchanged. All nine evidence requests remain `PENDING — NOT_SENT — NOT_READY_FOR_OWNER_AUTHORIZATION`; the six coordinator scopes and nine request mappings remain unchanged.

This package records no Owner decision; allocates, reserves or proposes no `ODB-*` ID; and authorizes no external contact, disclosure, procurement, professional engagement, physical schema, migration, database operation, persistence, transaction, locking, isolation, API, source code, test, dependency, runtime behavior, deployment, Gate A/B/C, Control Acceptance, FOA or Production Authorization. Owner-managed coordination confers no professional qualification or disclosure authority.

## 17. Source register

### Canonical and repository sources

- [Owner Decision Baseline](../architecture/after_four_owner_decision_baseline.md)
- [Glossary](../../GLOSSARY.md)
- [Catalog/Pricing Discovery](../architecture/after_four_catalog_pricing_discovery.md)
- [Real Menu & Pricing Specification](../architecture/after_four_real_menu_pricing_specification.md)
- [Promotions Discovery](after_four_p2a_promotions_policy_discovery.md)
- [Loyalty Discovery](after_four_p2a_loyalty_policy_discovery.md)
- [Payment/Catalog Internal Fact Manifest](after_four_wave_2_payment_catalog_internal_fact_manifest.md)
- [Payment/Catalog Evidence Deep Review](after_four_wave_2_payment_catalog_evidence_deep_review.md)
- [Upstream Commercial Dependency Review](after_four_wave_2_upstream_commercial_dependency_evidence_review.md)
- [Owner-Managed Evidence Register](after_four_wave_2_owner_managed_evidence_register.md)
- [Cross-Domain Evidence Synthesis](after_four_wave_2_cross_domain_evidence_synthesis.md)
- [Vietnam POS Comparative Evidence](after_four_wave_2_vietnam_pos_comparative_evidence.md)

### Official legal source metadata

Official URLs and dates are recorded in §§7–8. They establish the legal-source chain only. No professional opinion, scoped applicability determination or compliance assessment has been obtained.
