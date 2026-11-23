# AFTER FOUR — P1 Parallel Integration and Owner Decision Register

**Package:** `P1A + P1B + P1C`

**Status:** `OWNER_REVIEW_COMPLETED — GOVERNANCE_SYNCHRONIZED`

**Authorizing decision:** `NW-OR-01` — documentation and logical-design preparation only

**Canonical ODB allocation:** `ID_PENDING_OWNER_GOVERNANCE — NO EXACT FULL ID APPROVED`

**Candidate E Gate A:** `DEFER_GATE_A — NOT_GRANTED`

**Candidate E Gate B proposal preparation:** `NOT_AUTHORIZED`

**Implementation authorization:** `NOT_GRANTED`

**Date:** 2026-11-23

## 1. Purpose and authority boundary

This register integrates the three independently owned P1 preparation artifacts without merging their policies, aggregates, persistence, transactions, or approval paths:

- [P1A Order/Payment Policy Closure](after_four_p1a_order_payment_policy_closure.md);
- [P1B Catalog Current-State Reconciliation](after_four_p1b_catalog_current_state_reconciliation.md); and
- [P1C Identity Governance and Security Preparation](after_four_p1c_identity_governance_security_preparation.md).

The [Next-Wave Execution Plan](after_four_next_wave_execution_plan.md) and `NW-OR-01` authorized these review artifacts only. The Owner's later consolidated selections are recorded in §5 and the [Owner Decision Baseline](../architecture/after_four_owner_decision_baseline.md#consolidated-p1-owner-decisions). This package does not allocate a canonical `ODB-*` ID, approve a dependency or authentication foundation, change a CAT-TRR status, accept ADR-0006, authorize Identity Milestone 2B, or authorize physical database design, schema, migrations, database operations, code, tests, runtime configuration, deployment, Final Operational Acceptance, or Production Authorization.

## 2. Independent workstream results

| Workstream | Accountable domain ownership | Result | Reviewable next action | Boundary |
|---|---|---|---|---|
| P1A | Ordering owns commercial intent/snapshots; Payment owns settlement, Attempts, and reconciliation; Preparation owns durable handoff/work. | Current policy inventory, reconciliation findings, semantic failure scenarios, cross-domain responsibility map, three approved policy principles, and five deferred questions. | Preserve the approved boundaries; route `P1A-OD-08` and other deferred questions to their named future policy inputs without reopening them implicitly. | Exact-balance remains a Phase 1 limitation, not permanent policy; no Refund/cancellation/runtime implementation follows. |
| P1B | Catalog owns Category/Product/Variant behavior and current commercial definitions; Organization owns Brand ancestry; Ordering owns confirmed sold history. | Package B evidence inventory, current-state reconciliation, nine documented gaps, unchanged CAT-TRR matrix, one bounded documentation-sync proposal, and five approved future-operation policy principles. | Keep `P1B-PROP-01` separate; any later technical-design or implementation package requires its own review and authorization. | Package B is not blanket runtime authority; Package C, Pricing, Availability, and Catalog DML remain unauthorized. |
| P1C | Identity owns trusted identity/session and authorization evaluation; target contexts own protected targets and business operations; Organization owns ancestry/ownership facts. | Governance/security inventory, responsibility matrix, fifteen threat/gap scenarios, bounded provider-neutral proposals, existing P1/C0 decision dependencies, and one deferred spike question. | Preserve `P1-OD-01` through `P1-OD-05`; do not prepare or execute a spike unless `P1C-OD-01` is explicitly reopened through later governance. | ADR-0006 remains Proposed; Identity Milestone 2B and all Identity/P1 implementation remain unauthorized. |

One workstream's readiness or blocker does not change another's status. Shared review is coordination, not shared domain ownership.

## 3. Cross-workstream interface classification

| Interface | Fact/policy owner | Consumer need | Classification | Coordination rule |
|---|---|---|---|---|
| Catalog definition and effective Price → Order quote/snapshot | Catalog/Pricing owns current sellable definitions and Price; Ordering owns accepted Draft quote and immutable confirmed snapshot. | P1A needs authoritative commercial input without reconstructing history from mutable Catalog state. | `CONFIRMED_OWNERSHIP — RUNTIME_CONTRACT_UNRESOLVED` | P1A and P1B may reconcile terms; neither selects persistence, Price implementation, or a cross-context transaction. |
| Order eligibility/payable intent → Payment | Ordering owns Order lifecycle and payable intent; Payment owns target, Attempts, funding, and reconciliation. | Payment must decide settlement without becoming the Order lifecycle. | `CONFIRMED` | Preserve independent states and explicit Application contracts; no status field substitutes for another aggregate. |
| Verified settlement → Preparation Dispatch | Payment owns settlement truth; Preparation owns Dispatch and work. | Preparation needs an eligible, fully paid handoff exactly once. | `OWNER_CONFIRMED — BOUNDED_IMPLEMENTED_EVIDENCE` | Retry the same Dispatch identity; never create a replacement charge. Delivery/ticket operations remain outside Phase 1 evidence. |
| Anonymous Order / optional Customer association | Customer owns association/verification/privacy policy; Ordering owns the optional reference and transaction history. | Ordering may operate without a Profile and needs a future decision before later association. | `ANONYMOUS_ORDER_CONFIRMED — LATER_ASSOCIATION_UNRESOLVED` | Never infer identity from phone or Payment. `P1A-OD-08` is Customer-owned and does not reopen Candidate E. |
| Trusted identity/scope → protected Order, Payment, or Catalog operation | Identity owns trusted actor/session and authorization evaluation; the target context owns lookup, target binding, and operation policy. | Each protected operation needs exact capability and authoritative persisted scope. | `TECHNICAL_PROPOSAL — RUNTIME_ABSENT` | Consumer Application owns its outbound P1 port; generic role labels, opaque actor UUIDs, and client Brand IDs are not authority. |
| Organization ancestry → Identity/target scope | Organization owns Brand-to-Organization ancestry; I1 exposes only that bounded fact. | Identity and target contexts need authoritative ancestry without direct Organization Infrastructure access. | `IMPLEMENTED_AND_OWNER_ACCEPTED_BOUNDED` | I1 evidence proves no ownership, capability, delegation, or authorization. A separate approved ownership seam is still needed where applicable. |
| Payment settlement ↔ Cash accountability | Payment owns settlement; Cash owns drawer/session movements and accountable evidence. | Cash settlement needs later reconciliation without conflating a Payment Attempt and Cash Transaction. | `CONFIRMED_SEPARATION — INTEGRATION_UNRESOLVED` | P1A records questions; P2B Cash owns later discovery. Neither context directly writes the other's persistence. |
| Catalog/Order facts → Loyalty and Promotions | Catalog/Pricing owns base definition/Price; Ordering owns confirmed commercial facts; Loyalty/Promotions own benefits/rules. | Later earning, redemption, discount, cancellation, and Refund handling need authoritative source facts. | `OWNERSHIP_CONFIRMED — POLICY_UNRESOLVED` | P2A owns policy closure. P1 packages must not invent benefit transfer, reversal, stacking, or eligibility rules. |
| Preparation work → Inventory | Preparation owns work/deviation facts; Inventory owns stock movements, quantity, and costing. | Cancellation/remake may later require stock outcomes. | `DOCUMENTED_PROPOSAL — DISCOVERY_REQUIRED` | P2B Inventory owns discovery; no shared aggregate or automatic stock write is approved. |
| Source domains → Reporting/Audit | Each source domain owns business truth; Reporting projects facts; audit preserves attributable evidence under its approved scope. | Reconciliation and governance need provenance without redefining settlement, Catalog, or authorization facts. | `CONFIRMED_DIRECTION — GOVERNANCE_INCOMPLETE` | P3 owns readers, retention, export, legal hold, formulas, and delivery/replay questions. P1 does not select a universal audit store. |

## 4. Shared terminology and conflict controls

| Term or distinction | Canonical use | Conflict prevented |
|---|---|---|
| Payment / Payment Attempt | Payment is one Order's settlement aggregate; Payment Attempt is one method/provider attempt with its own outcome. | Treating “transaction” or one successful attempt as the complete aggregate. |
| Order / Preparation Dispatch | Order is the commercial record; Dispatch is a durable paid-order handoff. | Encoding preparation or delivery state in Order/Payment. |
| Product / Variant / Sold Price | Product is Brand-global identity; Variant is persisted sellable selection; Sold Price is Ordering-owned confirmed history. | Reconstructing historical Orders from current Catalog state. |
| Branch Availability / lifecycle | Availability is a Branch override; lifecycle is Brand-global Catalog state. | Using lifecycle as Branch sellability. |
| User / Employee / Customer | User authenticates staff; Employee records employment; Customer is a separate business party. | Using employment or Customer identity as authentication/authorization. |
| Authentication / authorization / business scope | Authentication establishes the actor; authorization evaluates the exact operation; target context establishes authoritative scope. | Treating role titles, identifiers, or ancestry as permission. |
| I1 ancestry / ownership authority | I1 resolves Brand to Organization only; ownership is a separate authority fact. | Promoting an implemented ancestry lookup into authorization. |

No glossary change is required by this preparation package. Where canonical documents have stale maturity statements, the applicable reconciliation artifact identifies them without silently rewriting history.

## 5. Consolidated provisional Owner decision register

Every reference below remains provisional and is not a canonical `ODB-*` ID. On 2026-11-23, the Owner approved eight recommendations and deferred six questions, with no comments or conditions. Exact outcomes and boundaries are canonical in the [Owner Decision Baseline](../architecture/after_four_owner_decision_baseline.md#consolidated-p1-owner-decisions). Full evidence, alternatives, and trade-offs remain in the owning workstream artifacts.

`Accountable owner` identifies the context that owns the final business or governance decision. Consulted contexts may constrain the decision or supply evidence, but their input does not transfer accountability.

### 5.0 Owner outcome crosswalk

| Temporary reference | Accountable owner | Owner selection | Recorded status | Canonical ID |
|---|---|---|---|---|
| `P1A-OD-01` | Payment | Defer per recommendation | `OWNER_DECIDED — DEFERRED` | `ID_PENDING_OWNER_GOVERNANCE` |
| `P1A-OD-02` | Payment | Approve recommendation | `OWNER_DECIDED — OWNER_CONFIRMED` | `ID_PENDING_OWNER_GOVERNANCE` |
| `P1A-OD-03` | Payment | Approve recommendation | `OWNER_DECIDED — OWNER_CONFIRMED` | `ID_PENDING_OWNER_GOVERNANCE` |
| `P1A-OD-04` | Ordering | Defer per recommendation | `OWNER_DECIDED — DEFERRED` | `ID_PENDING_OWNER_GOVERNANCE` |
| `P1A-OD-05` | Ordering | Defer per recommendation | `OWNER_DECIDED — DEFERRED` | `ID_PENDING_OWNER_GOVERNANCE` |
| `P1A-OD-06` | Payment | Approve recommendation | `OWNER_DECIDED — OWNER_CONFIRMED` | `ID_PENDING_OWNER_GOVERNANCE` |
| `P1A-OD-07` | Ordering | Defer per recommendation | `OWNER_DECIDED — DEFERRED` | `ID_PENDING_OWNER_GOVERNANCE` |
| `P1A-OD-08` | Customer | Defer per recommendation | `OWNER_DECIDED — DEFERRED` | `ID_PENDING_OWNER_GOVERNANCE` |
| `P1B-OD-01` | Catalog | Approve recommendation | `OWNER_DECIDED — OWNER_CONFIRMED` | `ID_PENDING_OWNER_GOVERNANCE` |
| `P1B-OD-02` | Catalog | Approve recommendation | `OWNER_DECIDED — OWNER_CONFIRMED` | `ID_PENDING_OWNER_GOVERNANCE` |
| `P1B-OD-03` | Catalog | Approve recommendation | `OWNER_DECIDED — OWNER_CONFIRMED` | `ID_PENDING_OWNER_GOVERNANCE` |
| `P1B-OD-04` | Catalog | Approve recommendation | `OWNER_DECIDED — OWNER_CONFIRMED` | `ID_PENDING_OWNER_GOVERNANCE` |
| `P1B-OD-05` | Catalog | Approve recommendation at the policy-principle level | `OWNER_DECIDED — OWNER_CONFIRMED` | `ID_PENDING_OWNER_GOVERNANCE` |
| `P1C-OD-01` | Identity | Defer per recommendation | `OWNER_DECIDED — DEFERRED` | `ID_PENDING_OWNER_GOVERNANCE` |

### 5.1 P1A — Ordering and Payment

| Ref | Accountable owner | Precise decision question | Why / existing constraints | Recommendation | Alternatives and deferral consequence | Would / would not authorize |
|---|---|---|---|---|---|---|
| `P1A-OD-01` | Payment | Should the next bounded Payment scope support multiple successful tenders for one Order? | `partially_paid` is reserved but unreachable; allocation/rounding/refund policy is absent. | Defer partial/split tender until the complete policy is approved. | A separately reviewed split policy adds flexibility and substantial recovery complexity; deferral preserves exact-balance commands. | Business scope only; no allocation schema/API/code. |
| `P1A-OD-02` | Payment | Which dispositions may close mismatch/excess evidence? | Default rejection/no dispatch and excess-refund outcome are confirmed; operating choices are not. | Held exception with explicit evidence/authority; dispatch only after authoritative exact allocation. | Method-specific reversal/refund may reduce delay but needs provider/Cash proof; deferral leaves manual handling. | Policy only; no role, provider, Cash, or Refund implementation. |
| `P1A-OD-03` | Payment | What eligibility, authority, method, allocation, and reconciliation rules govern Refunds? | Refund behavior is required by excess/cancellation but no executable policy exists. | Later method-aware, append-only Refund policy with authoritative reconciliation and cumulative cap. | Original-tender-only versus approved alternate methods; deferral blocks system Refund/cancellation workflows. | Policy only; no provider/schema/API. |
| `P1A-OD-04` | Ordering | What are the stage-specific cancellation consequences? | Before/after Preparation authority is confirmed; financial, work, stock, benefit, and remedy outcomes are open. | No preferred outcome until Preparation/Inventory and Loyalty/Promotion inputs exist. | Full/partial refund, remake/credit, or defined no-refund have distinct consequences; deferral blocks execution. | Outcome policy only; no stock/benefit/compensation implementation. |
| `P1A-OD-05` | Ordering | Which actors and outcomes are permitted after Order completion? | Completed exceptions are explicitly separate from cancellation. | Owner-reviewed exception package with immutable evidence and explicit downstream treatment. | Narrow Refund-only or broader remedies; deferral keeps exceptions external/manual. | Exception policy only; no endpoint or reopening behavior. |
| `P1A-OD-06` | Payment | Who resolves late-success review and which non-dispatch outcomes may close it? | Funding truth is preserved; reactivation/automatic dispatch is prohibited. | Owner or explicitly delegated exception authority chooses from separately approved dispositions. | Owner-only is safer/slower; delegation needs capability/audit; deferral leaves the review open. | Policy only; no delegation, Refund, replacement Order, or workflow implementation. |
| `P1A-OD-07` | Ordering | Which fulfillment, settlement, review, Refund, and delivery facts permit Order closure? | Payment success alone cannot close an Order. | Defer final matrix until Preparation/Delivery scope is bounded. | Preparation-complete, handoff-complete, or channel-specific closure; deferral keeps `closed` unreachable. | Closure semantics only; no command/reporting implementation. |
| `P1A-OD-08` | Customer | May an anonymous Order later be associated with a Customer, and under what authority/effects? | Anonymous Orders are confirmed; later association, consent, verification, and history scope are unresolved. | Route to Customer-owned policy; prohibit inference, automatic merge, and unauthorized history exposure. | No association or narrow verified association; deferral leaves Orders unassociated. | Customer policy only; no Candidate E, endpoint, or retroactive benefits. |

### 5.2 P1B — Catalog

| Ref | Accountable owner | Precise decision question | Why / existing constraints | Recommendation | Alternatives and deferral consequence | Would / would not authorize |
|---|---|---|---|---|---|---|
| `P1B-OD-01` | Catalog | Must every successfully created Product start in Draft? | Category/Variant start Draft; Product initial Draft state is Owner-approved, while Package B deliberately has no default/guard and technical enforcement remains unauthorized. | Require Draft at creation to preserve staged activation. | Explicit caller state adds flexibility/complexity; deferral keeps Product creation out of scope. | Business meaning only; no default/trigger/command/API. |
| `P1B-OD-02` | Catalog | Who may create Category, Product, and Variant within a Brand? | No creation authority follows from lifecycle roles or Package B tables. | Exact entity-specific Brand-scoped capability for verified owners/delegates. | Owner-only bottlenecks; broad editor weakens least privilege; deferral blocks creation use cases. | Authority policy only; no P1/persistence/audit/endpoint. |
| `P1B-OD-03` | Catalog | Who may edit non-lifecycle fields, and which fields become immutable? | Generic CRUD is unsupported; Code correction differs from ordinary label/position edits. | Decide capability and editable fields per operation/entity. | Broad edit versus Owner-only; deferral leaves persistence backstops without CRUD authority. | Edit policy only; no reassignment, lifecycle, Pricing, API, or code. |
| `P1B-OD-04` | Catalog | Who may designate/replace Default Variant and in which Product states? | Default is independent from lifecycle/visibility; Package C excludes switching. | Distinct capability-specific operation preserving final aggregate validity. | Owner-only, unsafe conflation with lifecycle, or continued exclusion; deferral preserves `C0-CAT-08`. | Default policy only; no locks/index/API or Package C expansion. |
| `P1B-OD-05` | Catalog | Which non-lifecycle mutations require audit, reason, approval, or step-up? | C0 audit/reason/MFA decisions cover lifecycle only. | Durable Brand-scoped audit for consequential operations; separately decide routine edit evidence. | Audit-all versus classified consequential changes; deferral blocks mutation operations. | Evidence policy only; no audit schema/retention/implementation. |

`P1B-PROP-01` is separately a `TECHNICAL_PROPOSAL — DOCUMENTATION_ONLY`: synchronize Catalog maturity/evidence wording while preserving CAT-TRR and every runtime/physical boundary. It is not an Owner decision or implementation authorization.

### 5.3 P1C — Identity governance and security

The existing `P1-OD-01` through `P1-OD-05` remain `OWNER_DECISION_REQUIRED`: Brand Owner authority representation, delegation-management grant/revoke authority, mutable delegation facts, maximum delegation duration, and separate-approver/self-approval semantics. P1C neither renumbers nor answers them. Until decided, the fail-closed states in the [P1C artifact §8.1](after_four_p1c_identity_governance_security_preparation.md#81-existing-owner-decisions-still-required) remain controlling.

| Ref | Accountable owner | Precise decision question | Why / existing constraints | Recommendation | Alternatives and deferral consequence | Would / would not authorize |
|---|---|---|---|---|---|---|
| `P1C-OD-01` | Identity | Should the Owner authorize a later bounded Devise-versus-custom compatibility/design spike after its manifest and evidence protocol are reviewed? | Research cannot prove Argon2id/session/API-only fit; no candidate or dependency is approved. | Option A is supportable only as bounded evidence gathering after §9 prerequisites; it selects neither candidate. | Defer pending ADR/security inputs, or stop Devise evaluation and prepare a custom-only proposal; deferral leaves foundation selection open. | Only a later exact spike if separately authorized; no dependency adoption, provider selection, production code, or ADR acceptance. |

`C0-R05`, `C0-R08`, and `C0-R11` remain `DEFERRED`. P1C does not reopen them or infer MFA, audit-governance, retry, or idempotency values.

## 6. Dependencies and post-decision sequence

1. Preserve each workstream's independent accountability; one outcome does not authorize unrelated work.
2. Review P1B's documentation-only synchronization proposal separately before any Catalog runtime package.
3. Route deferred P1A questions and their Customer, Loyalty/Promotion, Cash, Inventory, and qualified accounting/legal inputs to their owning future packages without silently reopening them.
4. Review `P1-OD-01` through `P1-OD-05` without bundling them with authentication-foundation selection; they remain unresolved.
5. `P1C-OD-01` is deferred. Do not prepare or execute a spike unless a later explicit Owner action reopens it and separately authorizes an exact manifest.
6. Keep Candidate E Gate A deferred and do not prepare its Gate B proposal.
7. Require separately approved technical design, bounded implementation authorization, evidence review, applicable Control Acceptance, FOA, and Production Authorization before any production use.

## 7. Package review and exit criteria

| Criterion | Result |
|---|---|
| Three independent evidence-backed workstream artifacts | `SATISFIED — OWNER_REVIEW_COMPLETED` |
| Confirmed policy separated from implementation/proposal | `SATISFIED — OWNER_REVIEW_COMPLETED` |
| Material implementation claims sourced and bounded | `SATISFIED — OWNER_REVIEW_COMPLETED / CODE_INSPECTION_ONLY_WHERE_STATED` |
| Cross-domain ownership and interfaces explicit | `SATISFIED — OWNER_REVIEW_COMPLETED` |
| Owner outcomes synchronized without changing accountable ownership | `SATISFIED — 8 APPROVED / 6 DEFERRED` |
| Authentication dependency selection remains open | `SATISFIED` |
| Candidate E Gate A/B boundary preserved | `SATISFIED` |
| CAT-TRR statuses preserved | `SATISFIED` |
| Physical database design or implementation authority introduced | `NO` |

Owner review and governance synchronization are complete for the fourteen provisional references. The package is not a Gate decision, technical-design approval, implementation manifest, executed control assessment, or production-readiness claim.
