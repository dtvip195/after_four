# AFTER FOUR — P2A Promotions Policy Discovery Annex

**Workstream:** `P2A-Promotions`

**Status:** `DISCOVERY_PREPARED — OWNER_REVIEW_REQUIRED`

**Authority:** `NW-OR-01` — documentation and policy preparation only

**Canonical ODB allocation:** `NOT_REQUESTED`

**Implementation authorization:** `NOT_GRANTED`

**Date:** 2026-11-23

## 1. Purpose and boundary

Promotions owns Promotion definition, lifecycle, eligibility, applicability, priority/stacking, usage limits, reservation/redemption, and Promotion Benefit history. It does not own Catalog base Price, confirmed Order snapshots, Payment/Refund truth, Loyalty value, Customer identity, or tax/accounting policy.

Advanced Promotions is a Production MVP `MUST`; its individual capabilities remain proposals until explicitly approved. This annex grants no rule-engine, schema, API, or implementation authority.

## 2. Authoritative evidence

| Source | Classification | Promotion consequence |
|---|---|---|
| [Owner Decision Baseline §5A](../architecture/after_four_owner_decision_baseline.md#5a-production-mvp-customer-loyalty-and-promotions-scope) | `EXISTING_OWNER_POLICY` | Advanced Promotions cannot be downgraded or wholly deferred; formulas, eligibility, stacking, priority, Voucher, limits, timing, allocation, administration, and audit remain undecided. |
| `SDP-CUST-17` in the [Customer decision register](../architecture/after_four_customer_management_owner_decisions.md#sdp-cust-17) | `EXISTING_OWNER_POLICY` | On effective anonymization, redeemed history is preserved and unredeemed Customer-specific benefits freeze; they are not transferred or used to reconstruct identity. Public Promotions are unaffected unless their own rules say otherwise. |
| `SDP-CUST-02/14/A2` | `EXISTING_OWNER_POLICY` | Retained relationships require purpose limitation, controlled access, retention/disposal governance, and pseudonymous references where sufficient. |
| [Business Domain Model §11](../architecture/after_four_business_domain_model.md#11-customers-loyalty-and-promotions) | Mixed | Candidate definitions and integration directions are design evidence, not approved formulas or topology. |

## 3. Concepts and independent state

| Concept | Owner | Discovery boundary |
|---|---|---|
| Promotion | Promotions | Versioned commercial rule definition; lifecycle states and publication authority remain undecided. |
| Eligibility | Promotions using authoritative inputs | Determination against Customer/public, Order, Catalog, channel, Branch, and time facts. It must not mutate those sources. |
| Promotion Benefit | Promotions | Customer-specific entitlement or public outcome; distinct from Loyalty Benefit. |
| Voucher | Promotions | Optional issued/redeemable instrument; issuance, transfer, reuse, and identity binding remain undecided. |
| Discount Allocation | Promotions + Ordering contract | Historical allocation across confirmed Order Items; formula and downstream Refund treatment remain open. |
| Redemption/Usage | Promotions | Durable use of an eligible benefit; reservation and release semantics remain open. |

## 4. Policy discovery

### 4.1 Lifecycle and publication

A useful lifecycle may distinguish Draft, scheduled/published, active, paused, ended, and archived states, but no lifecycle is Owner-approved. Effective time, timezone, correction/version behavior, and publish/pause/end authority require decisions.

### 4.2 Applicability and eligibility

Candidate inputs include Brand/Branch, Product/Variant/Category, channel, time, quantity/value, Customer segment, Voucher, and usage history. Exact scope and whether a Promotion is public or Customer-specific must be explicit. Client claims are never authoritative eligibility evidence.

### 4.3 Calculation, stacking, and precedence

Fixed/percentage/bundle/free-item concepts, caps, floors, order-versus-line allocation, stacking/exclusion groups, and deterministic precedence are unresolved. Promotions cannot rewrite Catalog Price; confirmed Orders must preserve applied Promotion evidence and sold totals.

### 4.4 Reservation, redemption, cancellation, and reversal

The repository does not establish whether benefits reserve before Order confirmation, at confirmation, or only at successful settlement. Cancellation and Refund effects depend on deferred P1A outcomes and discount allocation. A failed/abandoned Order must not silently consume a benefit, but release timing/mechanism remains technical design after policy closure.

### 4.5 Customer-specific versus public behavior

Customer-specific benefits require an authorized Customer association and never arise from phone/payment equality. Public Promotions may apply without a Customer Profile. Effective anonymization freezes unredeemed Customer-specific benefits while preserving successful redemption history; it does not alter general public rules.

## 5. Candidate policy decisions

Temporary review references below are not canonical IDs.

Every row below is `OWNER_DECISION_REQUIRED`. The recommendation is `PROPOSED_NOT_APPROVED`; any later Owner selection would close only the stated business policy. It would not authorize a rule engine, schema, API, transaction design, code, tests, runtime, deployment, FOA, or production use.

| Ref | Accountable owner | Owner question | Recommendation | Alternatives / trade-offs | Deferral consequence |
|---|---|---|---|---|---|
| `P2A-PROMO-OD-01` | Promotions | Which Promotion types are in the first bounded policy scope? | Select a small explicit type set before designing a general engine; keep unsupported types rejected. | General expressions maximize flexibility but amplify validation, audit, and support risk. | No deterministic calculation contract. |
| `P2A-PROMO-OD-02` | Promotions | What Brand/Branch/channel/Catalog scopes are allowed? | Require every Promotion to declare authoritative applicability scope; default cross-Brand deny. | Organization-wide applicability is simpler for campaigns but conflicts with unresolved multi-Brand semantics. | Scope remains unavailable, not inferred. |
| `P2A-PROMO-OD-03` | Promotions | How do stacking, exclusion, and priority work? | Use explicit exclusion/stacking groups and deterministic priority; prohibit implicit stack-all. | Best-price selection aids customers but is complex and may conflict with campaign intent. | Multiple eligible Promotions cannot be applied safely. |
| `P2A-PROMO-OD-04` | Promotions | When are benefits reserved, redeemed, released, or reversed? | Separate reservation from successful redemption and require explicit release/reversal outcomes. | Settlement-only redemption reduces recovery but may not support scarce benefits. | Scarce/limited benefits remain out of executable scope. |
| `P2A-PROMO-OD-05` | Promotions | How are discounts allocated and treated on Refund/cancellation? | Defer exact allocation until Price/tax/rounding and P1A Refund/cancellation policies close. | Line-proportional, rule-attributed, and item-first allocations produce different refunds/reporting. | Refund/cancellation Promotion automation remains blocked. |
| `P2A-PROMO-OD-06` | Promotions | What Voucher issuance, reuse, transfer, and usage limits apply? | Treat Voucher as optional separate policy; do not infer identity or transferability. | Bearer codes simplify use but increase leakage/fraud; bound identity increases privacy/verification duties. | Voucher capability remains unavailable. |
| `P2A-PROMO-OD-07` | Promotions | Who may draft, approve, publish, pause, end, and correct Promotions? | Separate preparation from sensitive publication/correction authority and retain durable evidence. | Owner-only is safe but slow; delegation needs capability-specific scope and approval policy. | Administration remains unauthorized. |
| `P2A-PROMO-OD-08` | Promotions | What time boundary and timezone govern eligibility? | Use an explicit approved business timezone and inclusive/exclusive interval convention. | Branch-local time supports geography but complicates shared campaigns. | Scheduled eligibility cannot be deterministic. |

## 6. Risks and prerequisites

- Unresolved tax/service-charge/rounding and Price rules can change discount arithmetic.
- Refund, cancellation, split-tender, and completed-exception deferrals block downstream correction policy.
- Customer-specific eligibility requires Customer authority/privacy contracts; public eligibility must remain distinct.
- Administration depends on trusted Identity/authorization, audit evidence, and runtime database controls.

## 7. Exit assessment

Promotions ownership, confirmed anonymization constraints, proposed capability boundaries, and eight Owner questions are prepared. No Promotion type, formula, lifecycle, technical design, dependency, implementation, Gate, FOA, or Production Authorization is approved.
