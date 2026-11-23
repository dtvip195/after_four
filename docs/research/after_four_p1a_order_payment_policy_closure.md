# AFTER FOUR — P1A Order/Payment Policy Closure Preparation

**Work package:** `P1A`

**Status:** `DOCUMENTATION_DESIGN_PREPARATION — OWNER_REVIEW_REQUIRED`

**Authorizing decision:** `NW-OR-01` — documentation and logical-design preparation only

**Canonical ODB allocation:** `NOT_REQUESTED`

**Implementation authorization:** `NOT_GRANTED`

**Date:** 2026-11-23

## 1. Purpose and authority boundary

This artifact reconciles current Order, Payment, Payment Attempt, Preparation Dispatch, cancellation, Refund, Customer-association, Cash, and audit policy evidence. It prepares bounded Owner questions without selecting policy for the Owner.

The canonical business terms are **Order**, **Payment**, **Payment Attempt**, **Preparation Dispatch**, and **Refund**. An Order is not a Payment or Preparation state; one Payment is the settlement aggregate for one Order; a Payment Attempt is one method-specific attempt/outcome. Existing Rails namespaces do not change those domain meanings or approve the proposed Sales/Billing vocabulary amendment.

This package does not authorize physical persistence, transaction/lock/isolation choices, schema, migrations, API activation, application or test code, provider integration, dependency adoption, deployment, Final Operational Acceptance, or Production Authorization. Candidate E Gate A remains `DEFER_GATE_A — NOT_GRANTED`, and this package does not prepare Candidate E Gate B.

## 2. Evidence and classification method

### 2.1 Sources inspected

- [Owner Decision Baseline — Ordering and Payment](../architecture/after_four_owner_decision_baseline.md#2-ordering-and-payment), `ODB-OP-01` through `ODB-OP-16`;
- [Canonical Payment Model](../architecture/after_four_payment_model.md);
- [Business State Machines §§3–10](../architecture/after_four_state_machines.md#3-mandatory-payment-to-preparation-flow);
- [Data Integrity Rules §§6–8 and 11](../architecture/after_four_data_integrity_rules.md#6-immutable-confirmed-transactions);
- [API Contract §§6, 13–16](../architecture/after_four_api_contract.md#6-pos-and-sales-contracts);
- [Business Domain Model §§8, 10, 14–17](../architecture/after_four_business_domain_model.md#8-sales-payment-preparation-printing-and-delivery);
- [Phase 1 Implementation Record](../architecture/after_four_order_payment_implementation_phase1.md);
- [Customer Owner Decisions](../architecture/after_four_customer_management_owner_decisions.md), especially `SDP-CUST-19`; and
- inspected Phase 1 Order, Payment, Preparation command/model/spec file inventory under `backend/app/domains`, `backend/app/models`, and `backend/spec` without executing it.

### 2.2 Classification

| Classification | Meaning in this package |
|---|---|
| `ALREADY_DECIDED` | Explicit Owner policy exists; this package preserves it. |
| `RECONCILIATION_REQUIRED` | Sources describe different maturity or proposal/implementation layers and must not be collapsed. |
| `OWNER_DECISION_PROPOSED` | A precise policy choice is needed before later technical design or execution. |
| `DISCOVERY_REQUIRED` | Evidence is insufficient for a responsible Owner choice or depends on another owning domain/qualified input. |
| `BOUNDED_IMPLEMENTED_EVIDENCE` | Phase 1 executable evidence exists only within its recorded seam; it is not general policy or production authorization. |

## 3. Current-policy inventory

| Area | Current policy | Authority / evidence | Classification | Remaining boundary |
|---|---|---|---|---|
| Channel | Dine-in or takeaway requires no reason. | `ODB-OP-01` | `ALREADY_DECIDED` | Table/session behavior remains separately governed. |
| Payment gate | Full verified Payment must persist before Preparation Dispatch; pending, unknown, failed, mismatched, partial, held, expired, or otherwise unverified outcomes cannot dispatch. | `ODB-OP-02`–`03`; Payment Model §6 | `ALREADY_DECIDED`; Phase 1 has `BOUNDED_IMPLEMENTED_EVIDENCE` | No public runtime endpoint or KDS delivery is authorized. |
| Late success | A late verified success is retained as financial truth and reviewed; it does not dispatch or reactivate a Held/Expired Order. | `ODB-OP-04`; Payment Model §§4–6 | `ALREADY_DECIDED`; Phase 1 evidence exists | Review resolution authority/outcomes remain open. |
| Paid dispatch retry | Retry reuses the same Dispatch/outbox identity and never charges again. | `ODB-OP-05`; Phase 1 §§3, 6.3 | `ALREADY_DECIDED`; bounded retry evidence exists | Delivery worker, tickets, and Dispatch Attempt outcomes remain deferred. |
| Payment window | Pending Orders use a configurable timeout with five-minute default. | `ODB-OP-06` | `ALREADY_DECIDED`; implemented configuration | Five minutes is a default, not immutable permanent policy. |
| Manual bank transfer | MVP uses Owner QR; speaker is an alert only; authorized operator explicitly compares and confirms; no automatic bank matching. | `ODB-OP-07`–`09` | `ALREADY_DECIDED`; command seam only | Secure QR operations, trusted actor derivation, UI, and runtime authorization remain absent. |
| Mismatch | Mismatch is rejected by default; resolution/refund is required; any exception needs explicit authority, reason, and audit. | `ODB-OP-10` | `ALREADY_DECIDED` outcome | Resolution method, exception authority set, and orchestration remain open. |
| Overpayment | Excess is evidenced, refunded appropriately, and is not revenue. | `ODB-OP-11` | `ALREADY_DECIDED` outcome | Refund rail, allocation, provider/Cash interaction, and recovery remain open. |
| Cancellation authority | Staff may cancel a paid Order before Preparation starts with reason/audit; after start requires Owner approval; completed Orders use a separate exception process. | `ODB-OP-12`–`14` | `ALREADY_DECIDED` authority boundary | Financial, Preparation, stock, Loyalty/Promotion, and completed-exception outcomes remain open. |
| Payment concepts | Payment and Payment Attempt are distinct. | `ODB-OP-15`; glossary | `ALREADY_DECIDED`; implemented distinction | Historical `Payment Transaction` wording is not a second implemented concept. |
| Unknown attempts | Authoritative reconciliation is required; no blind retry or replacement charge. | `ODB-OP-16` | `ALREADY_DECIDED`; state model and bounded evidence | Provider/method authority and operating procedure remain open. |
| Anonymous Order | Order may be created/completed without Customer Profile; phone does not infer Customer association. | `SDP-CUST-19` | `ALREADY_DECIDED` context | Optional later association policy/contract remains open and outside Candidate E. |
| Confirmed history | Confirmed sold snapshots and business evidence are preserved rather than rewritten. | State Machines §§4–5; Integrity Rules §§5–7 | Approved Catalog/Order constraints plus documented design | Catalog quote/version inputs and correction outcomes still need their owning policies. |
| Idempotency | Retryable business intent must not duplicate Attempt, Dispatch, audit, or external effect; Unknown is reconciled using the same attempt identity. | Payment Model §5; Phase 1 §§2–4 | Semantic expectation plus bounded evidence | Retention periods and provider-wide keys remain later design/operations. |

## 4. Reconciliation findings

| Ref | Sources / observed state | Reconciled current statement | Impact |
|---|---|---|---|
| `P1A-R01` | Phase 1 accepts exact balance only, while Payment vocabulary reserves `partially_paid` and the API/Payment Model call partial/split an open decision. | Exact balance is an implementation limitation for the current command seam, not a permanent Owner prohibition on partial/split tender. | Future partial/split behavior requires Owner policy before design or activation. |
| `P1A-R02` | Order and Refund state machines describe target transitions; Phase 1 reserves `cancelled`/`closed` but implements no cancellation/refund workflow. | State-machine entries are design evidence, not implemented behavior or approval of unresolved outcomes. | Do not activate cancellation/refund endpoints from documentation alone. |
| `P1A-R03` | API Contract lists logical Payment/refund/cancellation paths; Phase 1 routes only health endpoints. | API paths are proposed contracts; no public mutation surface or runtime authority exists. | Later endpoint work requires separate design/authorization. |
| `P1A-R04` | Phase 1 creates durable pending Dispatch/outbox and RetryDispatch requeues it; state-machine worker/tickets/Dispatch Attempts are future proposals. | Pending intent exists; delivery completion and attempt-outcome recording are not implemented. | Paid-but-pending operations need later delivery/operations design without changing Payment truth. |
| `P1A-R05` | Phase 1 stores opaque actor and Branch UUIDs but does not authenticate or authorize them. | Actor/Branch references are trusted-call prerequisites, not authentication or authorization evidence. | Public/runtime use is blocked on P1/Identity and authoritative Branch scope. |
| `P1A-R06` | Payment Model permits full financial truth with a late-success review case, while the Order remains Held/Expired. | Payment funding and Order lifecycle remain independent; review cannot silently reactivate or dispatch. | Review-case resolution needs its own policy. |
| `P1A-R07` | API and state documents describe Cash/refund/revenue correction intents; Cash policy owns drawer/session evidence. | A cash Payment Attempt proves settlement only; it is not a Cash Transaction or drawer balance. | Cash integration contract is discovery/design work owned with Cash, not a Payment aggregate expansion. |
| `P1A-R08` | Anonymous Order is approved, while optional later Customer association remains unresolved and the earlier endpoint is superseded. | Customer association is optional, explicit, authorized, validated, and never inferred from phone equality; no replacement API is approved. | P1A must not invent association timing, consent, verification, or history scope. |

No inspected evidence contradicts the confirmed payment-before-preparation invariant. The material gaps are downstream outcome and authority policy, not permission to weaken that gate.

## 5. Policy-gap register

| Ref | Gap | Classification | Why it matters | Next authority |
|---|---|---|---|---|
| `P1A-G01` | Whether partial/split tender is supported in the next bounded production scope, and if so its allocation/rounding/cancellation/refund rules | `OWNER_DECISION_PROPOSED` | `partially_paid` cannot be safely activated without deterministic commercial and recovery behavior. | Owner, with Order/Payment/Cash/Reporting inputs. |
| `P1A-G02` | Overpayment and mismatch resolution rail, original-tender expectations, approval path, and unreconciled/unknown handling | `OWNER_DECISION_PROPOSED` plus technical discovery | Existing policy fixes the outcome but not the permitted operating choices. | Owner; provider/Cash/accounting evidence may constrain options. |
| `P1A-G03` | Refund eligibility, approval thresholds, partial allocation, original-tender behavior, Unknown reconciliation, and reporting effects | `OWNER_DECISION_PROPOSED` | Cancellation and excess outcomes cannot execute without a Refund policy. | Owner; Payment, Cash, Loyalty/Promotion and accounting inputs. |
| `P1A-G04` | Exact business outcomes for cancellation before/after Preparation start | `OWNER_DECISION_PROPOSED` | Authority is confirmed, but refund, prepared work, waste/remake, stock and benefits are not. | Owner, with Preparation/Inventory/Loyalty/Promotion inputs. |
| `P1A-G05` | Completed-Order exception authority and allowed outcomes | `OWNER_DECISION_PROPOSED` | `ODB-OP-14` deliberately separates completed exceptions from ordinary cancellation. | Owner. |
| `P1A-G06` | Late-success review authority, allowed dispositions, evidence, and closure | `OWNER_DECISION_PROPOSED` | Financial truth is recorded, but held/expired Order and customer remedy remain unresolved. | Owner; Payment/Ordering/Cash/reporting inputs. |
| `P1A-G07` | Order `Closed` guards and relation to fulfillment, settlement, open Refund/review, and delivery | `OWNER_DECISION_PROPOSED` | Payment success alone is expressly insufficient to close an Order. | Owner, after Preparation/Delivery scope is clear. |
| `P1A-G08` | Optional later Customer association timing, authority, verification, consent/legal basis, and eligible historical scope | `DISCOVERY_REQUIRED` | `SDP-CUST-19` permits anonymous Orders but does not approve association behavior. | Customer-owned policy package; P1A is consumer only. |
| `P1A-G09` | Payment provider/method authority contract, webhook/query evidence, credentials, and operational reconciliation | `DISCOVERY_REQUIRED` | Electronic Payment cannot use a generic assumed authority. | Separate provider/operations/security authorization. |
| `P1A-G10` | Tax, invoice, service charge, rounding and accounting classification | `DISCOVERY_REQUIRED` | These affect payable total/refunds/reporting but require qualified input. | Owner plus qualified legal/accounting review. |

## 6. Bounded semantic proposals

These are `TECHNICAL_PROPOSAL`/decision-preparation statements, not Owner decisions or implementation mechanisms.

1. **Preserve independent truths.** Order lifecycle, Payment funding/activity, Preparation Dispatch, Refund, Cash evidence, and Customer association remain separate. A cross-context outcome is coordinated through an explicit Application contract owned by the consumer/producer contexts, never by direct access to another context's persistence.
2. **Use complete-or-confirmed-preserve command outcomes.** A request reports success only when its approved business outcome is durably established; an unknown external result remains unresolved and uses reconciliation rather than replacement action.
3. **Preserve append-only correction semantics.** Confirmed commercial, Payment Attempt, Refund, audit, and reconciliation history is not rewritten to simulate cancellation or correction.
4. **Treat dispatch as an independent durable handoff.** Settlement makes an eligible unique Dispatch pending; delivery retry cannot charge again. Delivery failure does not undo financial truth.
5. **Keep Customer association optional and non-authoritative for payment.** An Order without Customer remains valid. A later association, if approved, cannot be inferred from phone/payment facts or rewrite the originating Branch/commercial history.
6. **Separate settlement from Cash accountability.** Cash settlement and drawer movement may need coordinated evidence, but neither record substitutes for the other and their authority/lifecycle remain context-owned.

## 7. Semantic state and failure scenarios

| Scenario | Required current outcome | Evidence status | Open policy |
|---|---|---|---|
| Verified exact payment before deadline on Confirmed Order | Payment becomes fully paid; unique Dispatch intent is eligible; no duplicate charge/Dispatch on replay. | Owner-confirmed; Phase 1 bounded evidence | Delivery execution remains separate. |
| Pending/failed/unknown/unverified result | No Dispatch; Unknown retains same Attempt and blocks blind replacement until reconciled. | Owner-confirmed/documented; bounded evidence | Provider/method operational contract. |
| Exact success at/after deadline or while Held/Expired | Preserve successful funding; open review; no dispatch/reactivation. | Owner-confirmed; bounded evidence | `P1A-OD-06`. |
| Observed mismatch | Do not confirm/dispatch by default; preserve safe evidence; resolve or refund under authorized exception. | Owner-confirmed outcome | `P1A-OD-02`/`03`. |
| Observed excess | Do not treat excess as revenue or dispatch from ambiguous allocation; evidence and appropriate refund required. | Owner-confirmed outcome | `P1A-OD-02`/`03`. |
| Duplicate command/provider evidence | Return/reconcile the original semantic result; do not duplicate Attempt, Refund, Dispatch, or audit effect. | Semantic rule and bounded Phase 1 evidence | Provider-wide retention/identity design. |
| Dispatch delivery failure after paid commit | Payment remains paid; same pending Dispatch/outbox is retried; no second charge. | Owner-confirmed/bounded evidence | Worker/ticket/attempt operations. |
| Paid cancellation before Preparation starts | Authorized Staff decision with reason/audit; history preserved. | Authority confirmed; execution absent | Refund and downstream outcomes: `P1A-OD-04`. |
| Cancellation after Preparation starts | Owner approval, reason/audit, preserved work/history. | Authority confirmed; execution absent | Refund, waste/stock/benefits/compensation: `P1A-OD-04`. |
| Completed Order correction | No ordinary cancellation transition. | Owner-confirmed separation | Authority/outcomes: `P1A-OD-05`. |
| Anonymous Order | May create/complete without Customer; no phone-based identity inference. | Owner-confirmed | Optional later association remains Customer-owned discovery. |

## 8. Domain responsibilities and interfaces

| Boundary | Authoritative responsibility | P1A dependency / non-ownership rule | Classification |
|---|---|---|---|
| Ordering ↔ Catalog/Pricing | Catalog owns current sellable definition/Price; Ordering owns confirmed sold snapshot and payable intent. | P1A consumes an authoritative quote/snapshot contract but does not define Catalog persistence or pricing policy. | Confirmed ownership; interface design incomplete. |
| Ordering ↔ Payment | Ordering owns Order lifecycle/eligibility; Payment owns target, Attempts, funding and reconciliation. | Neither encodes the other's state; dispatch eligibility consumes both authoritative facts. | Confirmed. |
| Payment ↔ Preparation | Payment supplies verified full-settlement fact; Preparation owns durable Dispatch/tickets/work. | A failed handoff never starts a new Payment Attempt. | Confirmed; delivery incomplete. |
| Ordering ↔ Customer | Customer owns Profile/association/verification policy; Ordering owns optional association reference and transaction history. | Anonymous Order is valid; no automatic association or identity inference. | Confirmed boundary; optional association unresolved. |
| Payment ↔ Cash | Payment owns settlement truth; Cash owns drawer/session movement and accountability. | A Cash Transaction is not a Payment Attempt; later coordination needs explicit contracts. | Confirmed separation; integration unresolved. |
| Order/Payment ↔ Loyalty/Promotions | Those contexts own earning/redemption/entitlement policy; Ordering owns commercial facts. | No benefit reversal/allocation policy is inferred from cancellation/refund. | Ownership confirmed; policies unresolved. |
| Preparation ↔ Inventory | Preparation owns work facts; Inventory owns stock movement/cost. | Cancellation/remake does not directly mutate Inventory persistence. | Proposed interface; Inventory discovery required. |
| Source contexts ↔ Reporting/Audit | Source context owns business truth; Reporting projects it; audit preserves attributable evidence. | Reporting cannot redefine revenue, settlement, cancellation, Refund, or Cash truth. | Confirmed direction; formulas/retention unresolved. |
| Protected operations ↔ Identity/P1 | Target context owns operation; P1 supplies trusted actor/session/capability/scope decision. | Opaque actor UUID or role title alone is not authority. | Security prerequisite; runtime absent. |

## 9. Proposed Owner decision register

These are temporary review references only. They are not canonical `ODB-*` IDs, are not allocated/reserved, and are not Owner-approved.

### P1A-OD-01 — Partial/split tender scope

- **Question:** Should the next bounded production Payment scope support more than one successful tender toward an Order?
- **Recommended option:** `DEFER_PARTIAL_SPLIT_TENDER`; preserve exact-balance-only activation until allocation, rounding, cancellation/refund, reporting, and UX policy is approved together.
- **Alternative:** allow split tender under a separately reviewed complete policy; greater customer flexibility, substantially more allocation/recovery complexity.
- **Deferral consequence:** current exact-balance limitation continues; `partially_paid` remains unreachable.
- **Would not authorize:** schema, allocation records, endpoint changes, or implementation.

### P1A-OD-02 — Mismatch and excess operating disposition

- **Question:** Which bounded dispositions may an authorized operator select for mismatch/excess evidence before the case is closed?
- **Recommended option:** require a held exception with explicit evidence and Owner or separately authorized approval; no dispatch until exact target allocation is authoritative; excess follows an approved Refund path.
- **Alternatives:** immediate full reversal/refund where a method can prove it, or method-specific handling; these reduce delay but require provider/Cash evidence and recovery policy.
- **Deferral consequence:** default rejection/no dispatch remains; cases require manual external handling.
- **Would not authorize:** exception roles, provider calls, Cash writes, or Refund implementation.

### P1A-OD-03 — Refund policy baseline

- **Question:** What eligibility, authority, method, allocation, reconciliation, and correction rules govern Refunds?
- **Recommended option:** approve a later method-aware policy that preserves the original charge, uses append-only Refund outcomes, requires authoritative result reconciliation, caps cumulative successful Refunds at refundable value, and records reason/actor/approval.
- **Alternatives:** original-tender-only versus explicitly approved alternate method; the latter needs stronger evidence and accounting controls.
- **Deferral consequence:** cancellation, overpayment, and completed exceptions cannot execute as system workflows.
- **Would not authorize:** thresholds, provider choice, schema, API, or execution.

### P1A-OD-04 — Cancellation consequence matrix

- **Question:** For before-start and after-start cancellation, what refund, prepared-work, Inventory, Loyalty/Promotion, and customer-remedy outcomes are required?
- **Recommendation:** no single option is responsibly preferred until Preparation/Inventory and Loyalty/Promotion inputs are available; preserve the confirmed authority boundary and prepare stage-specific options.
- **Alternatives:** full refund, partial/line allocation, remake/credit, or no refund for defined prepared scope; each has materially different operational/accounting consequences.
- **Deferral consequence:** cancellation execution remains blocked despite confirmed actors.
- **Would not authorize:** stock posting, benefit reversal, compensation, or implementation.

### P1A-OD-05 — Completed-Order exception policy

- **Question:** Which actors and outcomes are permitted after an Order is completed?
- **Recommendation:** keep this separate from ordinary cancellation and require an Owner-reviewed exception package with immutable reason/evidence and explicit financial/stock/benefit treatment.
- **Alternatives:** narrow Refund-only correction or broader remedy set; broader scope increases fraud, evidence, and reconciliation risk.
- **Deferral consequence:** completed exceptions remain external/manual and unimplemented.
- **Would not authorize:** any exception endpoint or ordinary reopening of a completed Order.

### P1A-OD-06 — Late-success review disposition

- **Question:** Who may resolve a late-success review and which outcomes may close it without reactivating or automatically dispatching the Order?
- **Recommended option:** Owner or explicitly delegated exception authority chooses from separately approved Refund, replacement/new-Order, or documented no-dispatch resolution; original Order/Payment history remains unchanged.
- **Alternatives:** Owner-only handling is simpler/safer but slower; bounded delegation improves operations but needs capability/audit design.
- **Deferral consequence:** financial truth remains recorded and the review stays open; no dispatch follows.
- **Would not authorize:** delegation, Refund, replacement Order, or review workflow implementation.

### P1A-OD-07 — Order closure guards

- **Question:** Which fulfillment, settlement, review, Refund, and delivery conditions are necessary to close an Order?
- **Recommendation:** defer the final matrix until Preparation/Delivery scope is bounded; preserve the invariant that Payment success alone never closes the Order.
- **Alternatives:** close at preparation completion, customer handoff/delivery completion, or a channel-specific condition; each affects operations and reporting.
- **Deferral consequence:** Phase 1 `closed` remains reserved/unreachable.
- **Would not authorize:** closure command, delivery model, or reporting implementation.

### P1A-OD-08 — Optional later Customer association

- **Question:** May an anonymous Order later be associated with a Customer Profile, by whom, with what verification/consent, time boundary, and historical effects?
- **Recommendation:** route this to Customer-owned policy preparation; keep association absent until explicit policy prohibits phone-based inference, automatic merge, and unauthorized history exposure.
- **Alternatives:** no later association, or narrowly verified association with no retroactive benefit issuance; trade-offs involve service recovery, privacy, fraud, and Loyalty/Promotion behavior.
- **Deferral consequence:** anonymous Orders remain valid and unassociated.
- **Would not authorize:** Customer implementation, Candidate E work, public endpoint, or retroactive Loyalty/Promotion effects.

## 10. Prerequisites and exit assessment

| Prerequisite | Current status | Required before later design/implementation |
|---|---|---|
| P1A Owner decisions | `PROPOSED_NOT_APPROVED` | Explicit selections, exact scope, and canonical recording where applicable. |
| Identity/P1 | Design/governance preparation only | Trusted actor/session/capability/Branch scope and fail-closed runtime prerequisite. |
| Catalog/Pricing | Package B bounded evidence; pricing/publication incomplete | Authoritative quote/snapshot contract and confirmed commercial inputs. |
| Customer association | Anonymous Order policy confirmed; later association unresolved | Customer-owned policy and authorization/privacy contract. |
| Loyalty/Promotions | Anonymization outcomes only; general policies incomplete | Refund/cancellation/reversal and benefit-allocation decisions. |
| Cash | Owner cash policies exist; Payment/Cash integration incomplete | Settlement-to-drawer evidence and reconciliation boundary. |
| Preparation/Inventory | Dispatch foundation exists; worker/stock workflows incomplete | Stage facts and downstream cancellation/remake/stock outcomes. |
| Provider/accounting/legal | Not selected/verified | Method authority, reconciliation, tax/invoice/accounting obligations where applicable. |

P1A is ready for Owner review as a policy-closure brief, not as a technical-design gate or implementation package. Its safe next action is independent review of the eight temporary decision proposals and reconciliation findings. No proposal is approved merely because it appears here.
