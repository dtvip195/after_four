# AFTER FOUR — P2A Loyalty Policy Discovery Annex

**Workstream:** `P2A-Loyalty`

**Status:** `DISCOVERY_PREPARED — OWNER_REVIEW_REQUIRED`

**Authority:** `NW-OR-01` — documentation and policy preparation only

**Canonical ODB allocation:** `NOT_REQUESTED`

**Implementation authorization:** `NOT_GRANTED`

**Date:** 2026-11-23

## 1. Purpose and boundary

This annex separates confirmed Loyalty scope from workshop assumptions and unresolved policy. Loyalty owns Loyalty Account, points balance, ledger, qualification, earning, redemption, adjustment, reversal, expiration, and reconciliation policy. Customer owns Customer Profile lifecycle and identity/privacy behavior; Ordering owns confirmed commercial history; Payment owns funding and Refund truth; Promotions owns Promotion benefits.

No recommendation below is an Owner decision. This annex selects no schema, API, transaction, lock, identifier, event transport, or implementation mechanism.

## 2. Authoritative evidence

| Source | Classification | Loyalty consequence |
|---|---|---|
| [Owner Decision Baseline §5A](../architecture/after_four_owner_decision_baseline.md#5a-production-mvp-customer-loyalty-and-promotions-scope) | `EXISTING_OWNER_POLICY` | Basic Loyalty is a Production MVP `MUST`: persistent ledger/history, authorized adjustment, auditability, reconciliation/reversal evidence, Customer/transaction linkage, and shared-across-Branches direction. Implementation is not authorized. |
| [SDP-CUST-01/02 synchronization](../architecture/after_four_owner_decision_baseline.md#customer-management-decisions) | `EXISTING_OWNER_POLICY` | Effective anonymization preserves balance/ledger/history, freezes redemption and new Customer-specific benefit issue, uses pseudonymous references where justified, and never restores identity. |
| [Business Domain Model §§11, 14–17](../architecture/after_four_business_domain_model.md#11-customers-loyalty-and-promotions) | Mixed | Ledger, paid-value earning, reversal, idempotency, and event directions are workshop/design evidence, not approval of formulas or mechanisms. |
| [P1A policy closure](after_four_p1a_order_payment_policy_closure.md) | Mixed | Payment/Refund facts are context-owned; split tender, cancellation consequences, completed exceptions, and later Customer association remain deferred. |

## 3. Domain language and ownership

| Concept | Accountable owner | Discovery meaning |
|---|---|---|
| Loyalty Account | Loyalty | Customer-linked container for program participation; cardinality and Brand/Organization scope remain undecided. |
| Loyalty Ledger Entry | Loyalty | Historical earning, redemption, adjustment, reversal, expiration, or correction fact. Append-only behavior is recommended, not yet approved as a physical design. |
| Points Balance | Loyalty | Derived business position from accepted ledger facts; negative-balance policy remains open. |
| Eligible Paid Value | Ordering + Payment input; Loyalty rule | Confirmed sold-value and successful funding inputs used by an approved earning formula. Loyalty must not reconstruct mutable Price or Payment state. |
| Loyalty Benefit | Loyalty | Customer-specific value/eligibility distinct from Promotion Benefit and non-transferable by phone/Profile changes. |
| Customer reference | Customer supplies controlled reference | Does not grant Customer visibility or re-identification authority. |

## 4. Lifecycle and policy discovery

### 4.1 Ledger semantics

Current evidence supports preserving history and using linked corrective facts rather than rewriting confirmed entries. It does not decide entry types, posting point, balance materialization, expiration lots, or correction authority.

### 4.2 Earning and redemption

The workshop direction says earning follows successfully paid eligible value and excludes value paid with points. The Owner has not approved earning rate, qualifying Products/Channels, rounding, minimum redemption, maximum redemption, or whether redemption occurs at quote, confirmation, or settlement. Redemption must never make mutable Customer identity or phone equality an authority source.

### 4.3 Adjustment, reversal, expiration, and reconciliation

Manual adjustment is required in MVP scope and must be authorized/auditable, but requester/approver policy is unresolved. Refund/cancellation reversals require an explicit allocation policy; P1A deferrals prevent guessing it. Expiration is undecided, including whether points expire, lot ordering, timezone, notice, and correction. Reconciliation must compare Loyalty-owned facts with authoritative Order/Payment inputs without rewriting either context.

### 4.4 Customer lifecycle and anonymization

Effective anonymization preserves balance, ledger, and necessary history, freezes redemption, and prohibits new Customer-specific Loyalty benefits. No transfer, automatic extinguishment, reassignment, restoration through a new phone/Profile, or ordinary re-identification is allowed. Exceptional adjustment remains a separate policy question.

### 4.5 Scope and provenance

The MVP direction is shared across Branches, while `SDP-SCOPE-01` defers broader Organization-versus-Brand Customer identity semantics. Each Loyalty fact must retain source transaction and originating Branch provenance where applicable. This does not approve cross-Brand redemption or Organization-wide balance ownership.

## 5. Candidate policy decisions

These are temporary review references, not canonical `ODB-*` IDs.

Every row below is `OWNER_DECISION_REQUIRED`. The recommendation is `PROPOSED_NOT_APPROVED`; any later Owner selection would close only the stated business policy. It would not authorize schema, API, transactions, integration transport, code, tests, runtime, deployment, FOA, or production use.

| Ref | Accountable owner | Owner question | Recommendation | Alternatives / trade-offs | Deferral consequence |
|---|---|---|---|---|---|
| `P2A-LOY-OD-01` | Loyalty | What event and value make points earnable? | Earn only from authoritative successfully settled eligible value, with reversals linked to Refund/cancellation facts; separately approve formula and rounding. | Confirmation-time earning is faster but can precede funding; settlement-time is safer but requires durable integration. | No deterministic accrual workflow. |
| `P2A-LOY-OD-02` | Loyalty | What redemption limits, ordering, and rounding apply? | Define minimum/unit/maximum and deterministic rounding before any redemption design. | Flexible redemption improves UX but increases allocation/recovery complexity. | Redemption remains unauthorized. |
| `P2A-LOY-OD-03` | Loyalty | May points expire, and under which notice/timezone policy? | Keep expiration disabled until a complete expiry policy and customer notice obligations are approved. | Expiry limits liability but increases fairness, legal, lot, and support complexity. | Preserved points do not expire automatically. |
| `P2A-LOY-OD-04` | Loyalty | Who may request and approve manual adjustments? | Separate requester and approver for material adjustments; define bounded emergency handling without self-approval. | Owner-only is safer but operationally slow; delegated approval needs capabilities and thresholds. | Manual adjustment remains outside executable scope. |
| `P2A-LOY-OD-05` | Loyalty | How do partial Refunds/cancellations allocate reversals? | Defer until P1A allocation and cancellation outcomes are approved; never infer proportionality silently. | Proportional, line-based, or points-first rules produce different balances and accounting. | Refund/cancellation automation remains blocked. |
| `P2A-LOY-OD-06` | Loyalty | What is the approved Brand/Organization/Branch scope? | Preserve shared-across-Branches direction within the currently authorized business scope; do not infer cross-Brand sharing. | Brand-level is bounded; Organization-wide improves portability but raises identity/privacy/governance questions. | Cross-Brand behavior remains denied/unavailable. |
| `P2A-LOY-OD-07` | Loyalty | What exceptional treatment is allowed after anonymization? | Preserve/freeze by default; require a separately authorized, evidenced exceptional adjustment policy. | Extinguishment or transfer conflicts with current policy unless explicitly reopened. | No post-anonymization redemption or ordinary adjustment. |

## 6. Risks and prerequisites

- Split tender, partial Refund, cancellation, and completed-exception deferrals prevent final allocation rules.
- Tax, service charge, rounding, free-item, and Promotion allocation policy affect eligible value.
- Customer scope and privacy/legal duties constrain linkage and retention.
- Trusted Identity/authorization and audit/runtime security remain implementation prerequisites, not supplied here.

## 7. Exit assessment

Loyalty scope, confirmed Customer constraints, ownership, and seven decision candidates are prepared for Owner review. No formula, technical contract, physical design, implementation, Gate, FOA, or Production Authorization is granted.
