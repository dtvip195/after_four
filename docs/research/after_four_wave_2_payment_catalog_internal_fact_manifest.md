# AFTER FOUR — Wave 2 Payment & Catalog/Pricing Internal Fact Manifest

**Status:** `INTERNAL_FACT_RECONCILIATION — EVIDENCE_GAPS_REMAIN — NO_POLICY_OR_IMPLEMENTATION_AUTHORIZATION`

**Research cutoff:** 2026-11-24 (Asia/Tokyo)

**Scope:** Internal facts and evidence dependencies for `P2B-CASH-OD-05`, `P2A-LOY-OD-05`, `P2A-PROMO-OD-05`, and `W2-ORD-OD-01`

## 1. Purpose, evidence classes, and authority boundary

This manifest reconciles current repository evidence about Payment/Refund outcomes and Catalog/Pricing commercial facts. It does not select policy, change candidate readiness, or authorize technical design or implementation.

Evidence classes used below are:

- `REPOSITORY_FACT`: directly supported by a current repository artifact, including an implemented-state statement or a documented design fact within that artifact's stated maturity.
- `OWNER_DECISION`: explicitly approved and recorded in the canonical [Owner Decision Baseline](../architecture/after_four_owner_decision_baseline.md).
- `EXTERNAL_VENDOR_EVIDENCE`: a vendor-specific fact from the comparative evidence register. It is not AFTER FOUR policy.
- `UNVERIFIED_ASSUMPTION`: an assumption or proposed behavior present in repository material but not verified as current fact or approved policy.
- `OPEN_QUESTION`: an unresolved fact or policy question.
- `DEPENDENCY`: a fact that another domain or qualified evidence source must establish before resolution.

`REPOSITORY_FACT` does not mean Owner-approved policy unless the same row cites an `OWNER_DECISION`. Vendor behavior never proves AFTER FOUR policy. Historical or design vocabulary does not prove an implemented workflow.

## 2. Executive reconciliation

### 2.1 Established facts

- Payment and Payment Attempt are distinct. Phase 1 accepts only an exact unpaid target; partial/split tender and `payment_allocations` are not implemented, and `partially_paid` is command-unreachable ([Payment Model §§1–2](../architecture/after_four_payment_model.md#1-decision); `ODB-OP-15`).
- Full verified Payment must precede Preparation Dispatch. Pending, unknown, failed, or unverified Payment cannot dispatch. A late success is preserved but does not reactivate or automatically dispatch a Held/Expired Order (`ODB-OP-02`–`04`).
- The approved Refund direction is method-aware, append-only, authoritatively reconciled, capped at refundable value, and evidenced by reason, actor, and approval. Exact method, allocation, thresholds, and execution remain unresolved (`P1A-OD-03`).
- Catalog owns current effective Price; Ordering owns the confirmed sold snapshot. Chain-default Price supports explicit Branch override, Price versions are immutable/effective-dated, Draft repricing requires review, and sold price is locked at confirmation (`ODB-CAT-07`–`10`).
- Tax, service charge, monetary rounding, zero-price/free-item policy, Modifier price effects, and the complete Order calculation sequence remain unresolved ([Catalog/Pricing Discovery §4](../architecture/after_four_catalog_pricing_discovery.md#4-unresolved-decisions-preserved)).

### 2.2 Why Payment and Catalog/Pricing are upstream

Cash cannot determine drawer movement without an authoritative Refund method and outcome. Loyalty cannot allocate reversal without refunded/cancelled value and component attribution. Promotions cannot define release/reversal without sold discount attribution and Refund/cancellation allocation. Ordering cannot select a deterministic commercial-total sequence while Price components, tax, service charge, rounding, Loyalty, and Promotion inputs remain unsettled. Therefore all four named candidates remain `DEPENDENCY_BLOCKED`; coordination may continue, but vendor examples cannot close these dependencies.

## 3. Payment fact manifest

| Topic | Evidence class | Exact supported fact | Source | Limitation / open question |
|---|---|---|---|---|
| Payment aggregate and tender identity | `OWNER_DECISION` + `REPOSITORY_FACT` | One Payment is the settlement aggregate for one Order; Payment Attempt is separate. Phase 1 exact-balance commands do not implement partial/split tender or allocation records. | [`ODB-OP-15`](../architecture/after_four_owner_decision_baseline.md#2-ordering-and-payment); [Payment Model §§1–2](../architecture/after_four_payment_model.md#1-decision) | `OPEN_QUESTION`: future tender count, tender identity vocabulary, and allocation target. `P1A-OD-01` is deferred. |
| Current MVP bank-transfer method | `OWNER_DECISION` | MVP uses the Owner's bank QR; the speaker is an alert, not proof; cashier comparison and explicit confirmation are required. | `ODB-OP-07`–`09`; [Payment Model §2.4](../architecture/after_four_payment_model.md#24-manual-bank-transfer-evidence) | Does not establish provider/acquirer Refund behavior or other tender methods. |
| Successful funded amount | `REPOSITORY_FACT` | Exact-balance model derives funded value from successful Payment Attempts; successful amount cannot exceed target. | [Payment Model §2.1](../architecture/after_four_payment_model.md#21-funding-status) | This is the documented current model, not approval to activate partial funding. |
| Full Refund | `OWNER_DECISION` + `REPOSITORY_FACT` | Cumulative successful Refunds may equal successful funded value; original charge/history is preserved. | `P1A-OD-03`; [Payment Model §§2.1, 4](../architecture/after_four_payment_model.md#21-funding-status) | Exact eligibility, authority, method, provider result, and reporting remain open. |
| Partial Refund | `OWNER_DECISION` + `REPOSITORY_FACT` | The approved principle caps cumulative successful Refunds at refundable value; the model has `partially_refunded` vocabulary. | `P1A-OD-03`; [Payment Model §2.1](../architecture/after_four_payment_model.md#21-funding-status) | `OPEN_QUESTION`: whether/when partial Refund is offered, eligible components, line/Order allocation, and rounding. Vocabulary is not executable authorization. |
| Multiple-tender Refund allocation | `DEPENDENCY` | No authoritative allocation exists because partial/split tender is deferred. | `P1A-OD-01`; [P1A gap register](after_four_p1a_order_payment_policy_closure.md#5-policy-gap-register) | Requires an approved funding-allocation model before Refund allocation across tenders can be determined. |
| Original versus alternate method | `OPEN_QUESTION` | Refund policy must be method-aware, but neither original-method-only nor alternate-method permission is approved. | `P1A-OD-03`; [Payment Model §8](../architecture/after_four_payment_model.md#8-deferred-decisions) | Requires provider/acquirer, Cash, Accounting, and Reporting evidence. No method is selected here. |
| Mismatch and excess | `OWNER_DECISION` | Mismatch is not confirmed by default. Excess is evidenced and refunded through an appropriate method; it is not revenue. | `ODB-OP-10`–`11`; `P1A-OD-02` | “Appropriate method,” allocation, provider behavior, and exact exception authority remain unresolved. |
| Cancellation before Preparation | `OWNER_DECISION` | Staff may cancel a paid Order with reason and audit before Preparation starts. | `ODB-OP-12` | Refund, stock, benefits, compensation, and Reporting consequences are deferred under `P1A-OD-04`. |
| Cancellation after Preparation starts | `OWNER_DECISION` | Owner approval is required; prepared work and history remain preserved. | `ODB-OP-13` | Stage/quantity-specific Refund, waste/remake, benefits, and remedy remain unresolved. |
| Completed Order | `OWNER_DECISION` | Completed Orders use a separate exception process, not ordinary cancellation. | `ODB-OP-14`; `P1A-OD-05` | Exact authority and outcomes remain deferred. |
| Late/asynchronous success | `OWNER_DECISION` + `REPOSITORY_FACT` | A late success is recorded and reconciled without Order reactivation or automatic dispatch. Separately approved Refund, replacement/new-Order, or documented no-dispatch dispositions are the bounded direction. | `ODB-OP-04`; `P1A-OD-06`; [Payment Model §§4–6](../architecture/after_four_payment_model.md#4-transitions-and-guards) | Which approved disposition applies, delegated authority, and downstream effects remain open. |
| Duplicate provider/result evidence | `REPOSITORY_FACT` | Applying a result verifies unique provider event/reference and replays duplicate evidence idempotently; a repeated semantic command must not duplicate Attempt, Refund, Dispatch, or audit effects. | [Payment Model §5](../architecture/after_four_payment_model.md#5-reconciliation-and-concurrency); [P1A §7](after_four_p1a_order_payment_policy_closure.md#7-semantic-state-and-failure-scenarios) | Provider-specific identity, retention, and supported idempotency are unverified. |
| Delayed/unknown outcome | `OWNER_DECISION` + `REPOSITORY_FACT` | Unknown Payment Attempts require authoritative reconciliation and must not be blindly retried or replaced. | `ODB-OP-16`; [Payment Model §§2.3, 5](../architecture/after_four_payment_model.md#23-payment-attempt-status) | Provider-specific query/signature authority and operational recovery are missing. |
| Failed/cancelled/reversed provider outcome | `REPOSITORY_FACT` | Documented Payment Attempt statuses include failed and cancelled terminal outcomes. The inspected current model does not establish a generic provider `reversed` outcome. | [Payment Model §2.3](../architecture/after_four_payment_model.md#23-payment-attempt-status) | `OPEN_QUESTION`: method-specific reversal/correction taxonomy and downstream treatment. Do not manufacture a reversal state. |
| Refund lifecycle vocabulary | `REPOSITORY_FACT` | State-machine design documents requested/approval/processing/unknown/success/failure/rejection/cancellation and authoritative reconciliation from unknown. | [State Machines §10](../architecture/after_four_state_machines.md#10-refund-state-machine) | Design evidence only; not an approved or implemented workflow. |
| Provider/acquirer evidence | `DEPENDENCY` | Repository contains no accepted provider-specific Refund rule or provider/acquirer fact set sufficient to close method, allocation, retry, or reconciliation policy. | [Upstream Evidence Review §§2–3](after_four_wave_2_upstream_commercial_dependency_evidence_review.md#3-payment-refund-evidence-review) | `EU-W2-PAY-01` remains `PENDING — NOT_SENT — NOT_READY_FOR_OWNER_AUTHORIZATION`. |
| Vendor return/cancel context | `EXTERNAL_VENDOR_EVIDENCE` | Sapo exposes refund/cancel totals; KiotViet retail documents return/refund records and discounted return recalculation; CUKCUK documents manager post-close whole-invoice cancellation. | `SAPO-01`, `KIOT-01`, `KIOT-03`, `CUK-06` in [POS Evidence §4](after_four_wave_2_vietnam_pos_comparative_evidence.md#4-source-register) | Vendor-specific and incomplete. It establishes no common original-tender, allocation, Cash, or AFTER FOUR authority rule. |
| Approval and authority | `OPEN_QUESTION` | Reason/actor/approval evidence is required by approved direction, but thresholds, roles, separation, and recovery authority are not selected. | `P1A-OD-03`; [P1A `P1A-G03`](after_four_p1a_order_payment_policy_closure.md#5-policy-gap-register) | Requires Owner policy after qualified Payment/provider/accounting evidence. |

## 4. Catalog/Pricing fact manifest

| Topic | Evidence class | Exact supported fact | Source | Limitation / open question |
|---|---|---|---|---|
| Product/Variant pricing identity | `OWNER_DECISION` | Every sellable selection has a persisted Variant; chain-default Price may be overridden explicitly by Branch. | `ODB-CAT-04`, `ODB-CAT-07`; [Catalog/Pricing Discovery §§2–3](../architecture/after_four_catalog_pricing_discovery.md#2-original-discovery-conclusions-closed-by-the-owner) | Actual Product/Variant prices and Main Branch overrides are not supplied. |
| Branch-specific overrides | `OWNER_DECISION` | Branch override is supported; absence of an effective override uses chain default. | `ODB-CAT-07`; [Catalog/Pricing Discovery §3](../architecture/after_four_catalog_pricing_discovery.md#3-consequences-for-the-logical-design) | Publication authority and interval conflict prevention are unresolved/technical. |
| Effective Price versions | `OWNER_DECISION` | Price versions are immutable and effective-dated; correction creates a new version rather than rewriting history. | `ODB-CAT-08`; [Glossary — Price Version](../../GLOSSARY.md) | Exact interval boundary semantics, overlap rules, timezone, and publication workflow remain open. |
| Effective Price ownership | `REPOSITORY_FACT` + `OWNER_DECISION` | Catalog/Pricing owns current effective Branch Price; Ordering consumes it and owns confirmation/sold evidence. | [P1A §8](after_four_p1a_order_payment_policy_closure.md#8-domain-responsibilities-and-interfaces); `ODB-CAT-07`–`10` | Cross-context contract and persistence are not authorized. |
| Draft Price changes | `OWNER_DECISION` | If authoritative Price changes while Order is Draft, revised quote review is required before confirmation. | `ODB-CAT-09` | Quote/version token, concurrency, UX, and technical enforcement remain unresolved. |
| Price draft/review/publication | `OPEN_QUESTION` | Published history is version-based, but source material does not establish a complete draft-review-publish workflow or operation-specific authority. | `ODB-CAT-08` boundary; [Catalog/Pricing Discovery §4](../architecture/after_four_catalog_pricing_discovery.md#4-unresolved-decisions-preserved) | Requires Catalog/Pricing policy and later authorization design. |
| Sold Price | `OWNER_DECISION` | Sold price is locked at Order confirmation; later Catalog/Price changes do not rewrite confirmed history. | `ODB-CAT-10`; [Glossary — Sold Price](../../GLOSSARY.md) | Exact snapshot components depend on unresolved commercial policies. |
| Sold-price provenance | `REPOSITORY_FACT` | Ordering owns confirmed Order Item commercial snapshot; Catalog owns source Price. | [Upstream Evidence Review §5.1](after_four_wave_2_upstream_commercial_dependency_evidence_review.md#51-ownership-boundary) | Snapshot representation and source-version contract are not approved here. |
| Modifier pricing | `OPEN_QUESTION` | Modifier cardinality is approved, but whether/how Modifier selections affect Price remains unresolved. | `ODB-CAT-05`; [Real Menu & Pricing §§5–6](../architecture/after_four_real_menu_pricing_specification.md#5-modifier-groups) | Actual options, price deltas, history, calculation basis, tax, and Refund behavior are missing. |
| Tax | `DEPENDENCY` + `OPEN_QUESTION` | Tax inclusion/exclusion, basis, applicability, invoice/accounting treatment, and calculation order are not approved. | [Real Menu & Pricing §10](../architecture/after_four_real_menu_pricing_specification.md#10-các-quyết-định-tài-chính-còn-mở); [Catalog/Pricing Discovery §4](../architecture/after_four_catalog_pricing_discovery.md#4-unresolved-decisions-preserved) | Requires qualified tax/accounting/legal evidence and accountable Owner policy. |
| Service charge | `DEPENDENCY` + `OPEN_QUESTION` | No service-charge policy or basis is approved. | Same sources as Tax | Applicability, rate/basis, interaction, reversal, Reporting, and accountability remain unresolved. |
| Monetary rounding | `DEPENDENCY` + `OPEN_QUESTION` | No monetary rounding unit, precision, stage, tie rule, residual allocation, or Refund treatment is approved. | `ODB-CAT-08` boundary; [Upstream Evidence Review §5](after_four_wave_2_upstream_commercial_dependency_evidence_review.md#5-catalogpricing-total-component-review) | Requires Ordering/component-owner coordination and qualified Accounting input. |
| Calculation stages | `OPEN_QUESTION` | Ordering owns calculation sequence and line/amount allocation, but no sequence is approved. | [Upstream Evidence Review §5.1](after_four_wave_2_upstream_commercial_dependency_evidence_review.md#51-ownership-boundary); `W2-ORD-OD-01` | Cannot be selected until component policies are stable or explicitly excluded. |
| Zero-price/free item | `OPEN_QUESTION` | No zero-price/free-product policy is approved. Promotion free-item is an exploratory concept, not a confirmed Catalog rule. | [Catalog/Pricing Discovery §4](../architecture/after_four_catalog_pricing_discovery.md#4-unresolved-decisions-preserved); [Promotions §4.3](after_four_p2a_promotions_policy_discovery.md#43-calculation-stacking-and-precedence) | Requires provenance, tax/service/rounding, sold snapshot, and Refund/cancellation treatment. |
| Effective dates/boundaries | `OWNER_DECISION` + `OPEN_QUESTION` | Effective dating is approved; exact interval inclusivity, timezone, simultaneous-version selection, and boundary behavior are not. | `ODB-CAT-08`; [Catalog/Pricing Discovery §4](../architecture/after_four_catalog_pricing_discovery.md#4-unresolved-decisions-preserved) | Do not infer `[start,end)` or any timezone from technical convention. |
| Actual menu and Price data | `UNVERIFIED_ASSUMPTION` | The input specification contains blank/`TBD` Product, Variant, Price, Modifier, and financial-policy fields; examples are explicitly non-approved. | [Real Menu & Pricing §§3–10](../architecture/after_four_real_menu_pricing_specification.md#3-danh-sách-product) | No actual launch price fact can be extracted from blank or example rows. |
| Vendor commercial components | `EXTERNAL_VENDOR_EVIDENCE` | Sapo documents separate promotion/manual discount, tax, and service charge; iPOS lists tax, service fee, discount, and channel pricing. | `SAPO-05`, `IPOS-01` in [POS Evidence §4](after_four_wave_2_vietnam_pos_comparative_evidence.md#4-source-register) | These sources show product components only; they do not establish AFTER FOUR ownership, order, basis, rounding, legality, or Refund allocation. |

## 5. Cross-domain dependency matrix

| Candidate | Required upstream facts | Repository-supported facts | Vendor context only | Missing evidence | Why blocked | Next internal action |
|---|---|---|---|---|---|---|
| `P2B-CASH-OD-05` | Authoritative Refund result, amount, method, original/alternate status, full/partial allocation, and actual Cash effect | Append-only method-aware principle, success cap, and Payment/Cash separation | Sapo refund/cancel totals and device context; KiotViet retail return records | Permitted method matrix, provider result authority, tender allocation, drawer-outflow mapping, Accounting/Reporting treatment | Cash cannot infer a drawer movement from a Refund label or a non-cash outcome | Build an internal tender/Refund fact inventory; retain `EU-W2-PAY-01` for later qualified/provider evidence. Do not select policy. |
| `P2A-LOY-OD-05` | Successful Refund/cancellation, lines/components/value, full/partial allocation, timing and stage | Loyalty owns reversal; linked history is preserved; proportionality must not be inferred | KiotViet retail discounted-return recalculation | Payment allocation, cancellation consequence matrix, eligible paid components, points/reversal basis, residual rounding | Different line/proportional/points-first rules produce different balances | Prepare synthetic allocation scenarios after Payment and commercial components are evidenced; Loyalty retains policy ownership. |
| `P2A-PROMO-OD-05` | Sold components, applied Promotion attribution, Refund allocation, cancellation outcome, tax/service/rounding/zero-free facts | Promotions owns allocation/release/reversal; Catalog Price and sold snapshot stay immutable | KiotViet/CUKCUK return/cancel examples; Sapo/iPOS component examples | Discount attribution/allocation, component sequence, Refund/release/reversal and cancellation treatment | No source establishes how an applied benefit maps into a partial Refund or cancellation | Inventory applied-benefit provenance and synthetic component scenarios after Payment/Catalog gaps close. |
| `W2-ORD-OD-01` | Catalog Price, Modifier effects, Promotion, Loyalty, tax, service charge, rounding, zero/free and correction inputs | Ordering owns calculation sequence/sold allocation; Catalog owns Price; component contexts retain their policy | Sapo/iPOS/KiotViet show that components exist | Stable component definitions, accountable tax/service/rounding policy, source-supported sequences and residual rules | A sequence chosen now would silently decide another domain's policy | Complete component fact sheets, explicitly exclude unsupported components only by Owner decision, then compare synthetic deterministic sequences. |

All four candidates remain `DEPENDENCY_BLOCKED`, matching the [Owner Decision Baseline](../architecture/after_four_owner_decision_baseline.md#wave-2-conditional-direction-and-clarification-responses) and [Owner-Managed Evidence Register](after_four_wave_2_owner_managed_evidence_register.md).

## 6. Contradiction and ambiguity register

| Issue | Evidence class | Exact source locations | Ambiguity / conflict | Clarification question |
|---|---|---|---|---|
| Refund vocabulary versus executable maturity | `REPOSITORY_FACT` | [State Machines §10](../architecture/after_four_state_machines.md#10-refund-state-machine); [P1A reconciliation §4](after_four_p1a_order_payment_policy_closure.md#4-reconciliation-findings) | Rich Refund states appear in design while policy/implementation remains incomplete. | Which states are accepted semantic vocabulary for a future ballot, and which are only historical design proposals? |
| `partially_refunded` versus partial allocation | `REPOSITORY_FACT` + `OPEN_QUESTION` | [Payment Model §2.1](../architecture/after_four_payment_model.md#21-funding-status); `P1A-OD-03` | Aggregate vocabulary/cap exists, but eligible components and tender/line allocation do not. | Is partial Refund supported; if so, what is refundable and how is it allocated? |
| Method-aware without method rule | `OWNER_DECISION` + `OPEN_QUESTION` | `P1A-OD-03`; [Payment Model §8](../architecture/after_four_payment_model.md#8-deferred-decisions) | “Method-aware” does not mean original tender or authorize alternate tender. | Which methods may receive Refunds and what evidence authorizes each outcome? |
| Cancellation authority versus consequences | `OWNER_DECISION` + `OPEN_QUESTION` | `ODB-OP-12`–`14`; `P1A-OD-04`–`05` | Actors/stages are bounded, but commercial, stock, benefit, and remedy outcomes are not. | What stage-specific consequence matrix applies without reopening approved authority? |
| Price Version interval semantics | `OWNER_DECISION` + `OPEN_QUESTION` | `ODB-CAT-08`; [Catalog/Pricing Discovery §4](../architecture/after_four_catalog_pricing_discovery.md#4-unresolved-decisions-preserved) | “Effective-dated” does not define timezone, interval boundaries, overlap, or simultaneous selection. | What business-time boundary and interval semantics govern effective Price selection? |
| Sold Price versus full commercial snapshot | `OWNER_DECISION` + `OPEN_QUESTION` | `ODB-CAT-10`; [Owner Baseline §5](../architecture/after_four_owner_decision_baseline.md#5-catalogpricing-mvp) | Base sold Price is frozen, but Modifier, tax, service charge, Promotion, Loyalty and rounding components are unsettled. | Which immutable component/provenance facts comprise the confirmed sold total? |
| “Fixed/free” examples versus approved pricing | `UNVERIFIED_ASSUMPTION` | [Real Menu & Pricing §§4–10](../architecture/after_four_real_menu_pricing_specification.md#4-variant-và-giá-cơ-bản); [Promotions §4.3](after_four_p2a_promotions_policy_discovery.md#43-calculation-stacking-and-precedence) | Examples/TBDs may be mistaken for approved Product or zero-price policy. | Which actual Variant/Modifier Prices and free-item rules does the Owner approve after qualified review? |
| Vendor component order | `EXTERNAL_VENDOR_EVIDENCE` | `SAPO-05`, `IPOS-01`; [POS Evidence §5](after_four_wave_2_vietnam_pos_comparative_evidence.md#5-domain-comparative-matrix) | Vendors expose components but not a portable authoritative order or legal basis. | Which AFTER FOUR sequence options are supported by qualified tax/accounting evidence and domain-owner inputs? |
| Provider “reversal” | `OPEN_QUESTION` | [Payment Model §2.3](../architecture/after_four_payment_model.md#23-payment-attempt-status); [Upstream Evidence Review §3](after_four_wave_2_upstream_commercial_dependency_evidence_review.md#3-payment-refund-evidence-review) | Current canonical Attempt vocabulary has no generic reversed state, while external providers may use method-specific terminology. | What exact provider outcome taxonomy and authoritative evidence apply to the selected methods? |

## 7. Internal evidence acquisition plan

No scenario below uses real Customer, payment, provider, or employee personal data.

| Gap | Internal artifact or synthetic scenario | Evidence class on completion | Boundary |
|---|---|---|---|
| Current Payment model inventory | Trace current documented/implemented fields, statuses, guards, and exact-balance limits to repository paths and commits. | `REPOSITORY_FACT` | Read-only inspection; no runtime/database execution is authorized here. |
| Refund method assumptions | Create a source-indexed matrix of every existing mention of cash, bank transfer, original method, alternate method, excess, and provider outcome. | `REPOSITORY_FACT` / `UNVERIFIED_ASSUMPTION` | Label proposals and historical assumptions; choose no method. |
| Partial Refund allocation | **Synthetic:** one two-line Order, full Refund; partial one-line Refund; amount-only partial Refund; later second Refund; compare unallocated residuals. | `OPEN_QUESTION` input | No formula or allocation is approved by the scenario. |
| Multiple tender | **Synthetic:** exact target funded by two hypothetical tenders, then partial Refund with original method unavailable. | `OPEN_QUESTION` input | Partial/split tender remains deferred; scenario exposes questions only. |
| Late/unknown outcomes | **Synthetic:** pending→unknown→success after expiration; duplicate success; authoritative failure after unknown; inconsistent provider evidence. | `DEPENDENCY` input | Requires provider/acquirer evidence before policy conclusions. |
| Cancellation stages | **Synthetic:** before Preparation, after partial Preparation, after completion, with cash/non-cash and Promotion/Loyalty inputs. | `OPEN_QUESTION` input | Preserve approved authority; compare consequences only. |
| Actual Price inputs | Complete the Owner-input menu/Variant/Modifier/Branch Price facts with provenance and approval status. | Future `OWNER_DECISION` or verified input | Blank/TBD/examples remain non-authoritative until reviewed. |
| Effective Price boundaries | **Synthetic:** version change before/at/after confirmation; chain default plus Branch override; correction version; same-time candidates. | `OPEN_QUESTION` input | No timezone or interval convention is presumed. |
| Commercial components | Source-indexed fact sheets for tax, service charge, Modifier, Promotion, Loyalty, zero/free, and rounding, each with accountable owner and qualified-evidence need. | `DEPENDENCY` | Qualified tax/accounting/legal review remains required. |
| Calculation order | **Synthetic:** same Order components evaluated under multiple explicitly labeled candidate sequences, showing line/Order totals and rounding residuals. | `OPEN_QUESTION` input | Scenarios must not recommend or silently select a sequence. |
| Refund of sold components | **Synthetic:** partial Refund of an Order with Branch Price, Modifier delta, Promotion benefit, Loyalty redemption, tax/service charge, and rounding. | `DEPENDENCY` input | Run only after component definitions exist; no vendor rule is imported. |

The nine evidence requests, including `EU-W2-PAY-01` and `EU-W2-CAT-01`, remain `PENDING — NOT_SENT — NOT_READY_FOR_OWNER_AUTHORIZATION`. This plan prepares no external message, recipient, disclosure, procurement, or engagement.

## 8. Owner review and qualified-evidence boundary

### 8.1 Questions that may require Owner policy

- Whether partial/split tender or partial Refund is supported.
- Permitted Refund methods, original/alternate-method boundaries, eligibility, authority, time windows, and allocation outcomes.
- Stage-specific cancellation consequences and completed-Order remedies, without reopening approved cancellation authority.
- Actual menu/Price/Modifier facts, zero/free behavior, Price publication authority, and effective-time business semantics.
- Service-charge policy and the Ordering-owned calculation sequence after component evidence is available.
- Downstream Cash, Loyalty, and Promotion consequence policies after authoritative upstream facts exist.

### 8.2 Questions requiring qualified or domain evidence before policy closure

- Provider/acquirer outcome taxonomy, signatures/queries, idempotency, late/unknown/reversal behavior, original-tender capability, and Refund limitations.
- Accounting classification of Refunds, alternate methods, mismatch/excess, service charges, tax, rounding residuals, revenue versus cash flow, and reporting.
- Qualified Vietnamese tax/legal treatment for applicable Prices, Promotions/free items, invoices, tax bases, and service charges.
- Catalog/Pricing facts for actual Price versions and Branch overrides; Ordering facts for sold components and allocation; Payment facts for settlement/Refund; component-owner facts from Loyalty and Promotions.

### 8.3 Explicit non-authorization

This manifest records no Owner decision, allocates/reserves no `ODB-*` ID, and changes no candidate status, 55-candidate reconciliation, or six coordinator scopes. It authorizes no Gate A/B/C, Control Acceptance, FOA, Production Authorization, physical schema, migration, database operation, index, constraint, locking, isolation, persistence design, API, code, test, dependency, runtime behavior, deployment, external contact, provider engagement, disclosure, procurement, or evidence-request delivery.

## 9. Canonical and supporting references

- [Owner Decision Baseline](../architecture/after_four_owner_decision_baseline.md)
- [Canonical Payment Model](../architecture/after_four_payment_model.md)
- [Catalog/Pricing Discovery and Decision Closure](../architecture/after_four_catalog_pricing_discovery.md)
- [Real Menu & Pricing Specification](../architecture/after_four_real_menu_pricing_specification.md)
- [P1A Order/Payment Policy Closure](after_four_p1a_order_payment_policy_closure.md)
- [Wave 2 Upstream Commercial Dependency Evidence Review](after_four_wave_2_upstream_commercial_dependency_evidence_review.md)
- [Wave 2 Cross-Domain Evidence Synthesis](after_four_wave_2_cross_domain_evidence_synthesis.md)
- [Wave 2 Owner-Managed Evidence Register](after_four_wave_2_owner_managed_evidence_register.md)
- [Wave 2 Vietnam POS Comparative Evidence](after_four_wave_2_vietnam_pos_comparative_evidence.md)
- [Cash Discovery](after_four_p2b_cash_domain_discovery.md), [Loyalty Discovery](after_four_p2a_loyalty_policy_discovery.md), and [Promotions Discovery](after_four_p2a_promotions_policy_discovery.md)
