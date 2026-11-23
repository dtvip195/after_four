# AFTER FOUR — WP-T1 Customer Technical Design

**Work package:** `WP-T1`

**Design scope:** Candidate E — Customer Lifecycle and Phone-Admission Semantic Contract

**Document status:** `TECHNICAL_PROPOSAL — DESIGN_COMPLETE_FOR_REVIEW`

**Gate A approval:** `NOT_GRANTED`

**Implementation authorization:** `NOT_GRANTED`

**Production authorization:** `NOT_GRANTED`

## 1. Purpose and authority boundary

This document closes the design work identified as `TD-CUST-01` through `TD-CUST-04` at the logical Domain/Application-contract level. The controlling scope is the [WP-G0 Candidate E Scope Charter](after_four_wp_g0_candidate_e_scope_charter.md). Owner-confirmed business policy remains authoritative over every technical proposal here.

The design selects no database schema, index, lock, isolation level, transaction implementation, queue, outbox, saga, retry engine, public endpoint, controller, DTO, provider, cryptography, deployment topology, or runtime authorization integration. It creates no implementation or Gate approval.

`SDP-CUST-18` and `SDP-CUST-19` remain approved repository context only. Shared/family-phone workflows, anonymous-Order association, and Order-domain design are not Candidate E deliverables.

## 2. Sources and classification discipline

### 2.1 Canonical sources

- [Owner Decision Baseline](after_four_owner_decision_baseline.md)
- [Customer Management Owner Decisions](after_four_customer_management_owner_decisions.md)
- [WP-G0 Candidate E Scope Charter](after_four_wp_g0_candidate_e_scope_charter.md)
- [Customer Domain Boundary Design](after_four_customer_domain_boundary_design.md)
- [Customer Lifecycle and Phone Consistency Design](after_four_customer_lifecycle_phone_consistency_design.md)
- [ADR-0011 — Project-wide Layered DDD](adr/0011-project-wide-layered-ddd.md)
- [I1 Organization Scope Contract](after_four_i1_organization_scope_contract_design.md)

### 2.2 Meanings used here

| Classification | Meaning |
|---|---|
| `OWNER_CONFIRMED` | Existing business policy; this document cannot change it. |
| `TECHNICAL_DESIGN_DECISION` | Logical design selected for this proposal and subject to Gate A review; not implemented or Owner-approved merely by being written. |
| `TECHNICAL_PROPOSAL` | A viable later design direction that remains unselected. |
| `UNRESOLVED` | Additional technical, Owner, security, legal/privacy, or operational input is required. |
| `OUT_OF_SCOPE` | Explicitly excluded by WP-G0; absence is intentional. |

## 3. Candidate E scope

### 3.1 Included operations and outcomes

| Included operation or outcome | Authority/policy boundary |
|---|---|
| Ordinary verified phone change for an Active Profile | Appropriately scoped Branch Manager under `SDP-CUST-12A`; requester verification, phone validation, admission, audit, and non-transfer rules apply. |
| Ordinary verified phone change for an Inactive Profile | Same authority boundary; success leaves the Profile Inactive under `SDP-CUST-16`. |
| Disputed, exceptional, or cross-scope phone-change outcome | Owner approval under `SDP-CUST-12A` and `SDP-CUST-13`; material review evidence under `SDP-CUST-21`. |
| Consequential disputed Profile-ownership or phone-association outcome | Owner approval and preserved provenance under `SDP-CUST-13`; no automatic merge, overwrite, deletion, or transfer. |
| Routine validation/admission rejection | Non-disclosing rejection; it does not automatically create a durable Customer Review Case. |
| Anonymization completion semantics | Approved postconditions only, after separately authorized initiation; Candidate E does not authorize or design anonymization approval. |

### 3.2 Deferred operations

Profile creation, ordinary Deactivate, Reactivate, anonymization approval, and ordinary undisputed former-phone release remain outside the Gate A approval boundary. Their state meanings and postconditions may be referenced, but this design supplies no executable use case or inferred authority for them.

### 3.3 Other explicit exclusions

- `SDP-CUST-18` shared/family-phone design and assisted workflow;
- `SDP-CUST-19` anonymous-Order behavior, later association, and Ordering internals;
- multi-Brand Customer behavior;
- Loyalty ledger and Promotion-engine internals;
- Identity, Session, MFA, P1 implementation, or a physical authorization mechanism;
- Restricted Identity Evidence topology, schema, cryptography, retention period, or exceptional-access workflow; and
- public HTTP/API and physical persistence design.

## 4. Layered DDD and context ownership

```text
Future Customer Presentation
        |
        v
Customer Application ---> Customer Domain
        |                       ^
        v                       |
Customer-owned ports       no outer-layer dependency
        ^
        |
Customer Infrastructure adapters

Composition Root wires approved implementations only.
```

| Layer | Responsibility | Prohibited dependency or behavior |
|---|---|---|
| Domain | Customer Profile lifecycle meaning, phone-association meaning, Organization phone-admission rules, dispute holds, and typed domain decisions. | Rails, Active Record, PostgreSQL, HTTP, provider SDKs, authorization infrastructure, or another context's persistence. |
| Application | Orchestrate included use cases, obtain trusted scope/authorization/verification decisions through ports, revalidate before mutation, coordinate Domain decisions, and return typed outcomes. | Inferring authority, exposing persistence records, or directly manipulating Organization, Identity, Ordering, Loyalty, or Promotions Infrastructure. |
| Infrastructure | Later implement Customer-owned persistence and external adapters behind approved ports. | Creating business authority, weakening invariants, or choosing policy from storage timing. |
| Presentation | Later adapt an authorized transport request and non-disclosing result. | Public endpoint design is outside WP-T1. |

I1 may provide authoritative Brand-to-Organization ancestry through its published Application contract. I1 does not provide Customer authority or prove that a Customer target belongs to a Brand. A future Customer consumer owns its outbound port; no direct Organization Active Record access is permitted.

## 5. TD-CUST-01 — Domain model, use cases, and invariants

### 5.1 Logical boundaries

`TECHNICAL_DESIGN_DECISION`: use three distinct logical boundaries rather than one oversized Customer aggregate:

1. **Customer Profile aggregate** — owns Profile reference, Active/Inactive/Anonymized meaning, and the Profile's current-phone association state.
2. **Organization Phone Admission boundary** — owns the Organization-scoped decision that a canonical phone is either unclaimed, currently associated, or blocked by an unreleased former-phone restriction. This is a logical consistency boundary, not a selected table or service.
3. **Customer Review Case** — a separate business record only for material investigation, held dispute, or authorized manual decision under `SDP-CUST-21`. Routine invalid/duplicate rejection does not create it.

Restricted Identity Evidence is not part of any ordinary Profile or admission aggregate. It is an optional purpose-dependent security/privacy boundary whose physical ownership remains unresolved.

### 5.2 Why not one aggregate

| Alternative | Assessment |
|---|---|
| Profile alone enforces phone uniqueness | Rejected logically: a Profile cannot prove an Organization-wide invariant across other Profiles and former restrictions. |
| One Organization-sized Customer aggregate | Rejected: it would create an unbounded aggregate and conflate master Organization ownership with Customer policy. |
| One cross-context Customer/Order/Loyalty/Promotion aggregate | Rejected: it violates bounded-context ownership and would imply one transaction across independent histories. |
| Profile plus Organization admission boundary | Selected logical model; physical coordination remains for later design. |

### 5.3 Core concepts

| Concept | Meaning |
|---|---|
| Customer Profile | Ordinary Customer record with Active, Inactive, or Anonymized lifecycle meaning. |
| Current Phone Association | The Profile's current relationship to one canonical phone within its authoritative Organization. It is contact/lookup data, not identity proof. |
| Former-phone Restriction | Admission-only fact preventing reuse until documented authorized release; it cannot identify the former Customer. |
| Restricted Identity Evidence | Optional identifying evidence retained for a separately justified purpose; never an ordinary lookup or admission record. |
| Customer Review Case | Purpose-limited material investigation/hold/manual-decision record, distinct from a technical log. |

### 5.4 Invariants

| Ref | Required invariant | Authority |
|---|---|---|
| `WP-T1-INV-01` | Within one Organization, a canonical phone has at most one current association or one unreleased former-phone restriction. | `SDP-CUST-04` |
| `WP-T1-INV-02` | A conflict discloses no other Brand, Customer, Profile, history, or restriction ownership. | `SDP-CUST-04`, `05`, `06` |
| `WP-T1-INV-03` | Phone possession and Customer/Profile identifier possession establish neither identity nor authority. | `SDP-CUST-03`, `06`, `09`, `20` |
| `WP-T1-INV-04` | Successful phone change replaces the current association completely and creates the old-phone restriction; failure preserves the previous current association. No partial accepted outcome exists. | `SDP-CUST-12A`, `16` |
| `WP-T1-INV-05` | An Inactive Profile remains Inactive after successful phone change. | `SDP-CUST-16` |
| `WP-T1-INV-06` | Anonymized is terminal for ordinary Profile operations and cannot be restored by a new phone or Profile. | `SDP-CUST-10`, `11`, `22` |
| `WP-T1-INV-07` | Manual release ends only admission blocking; it creates no association, identity restoration, authority, or history/value transfer. | `SDP-CUST-12B`, `13` |
| `WP-T1-INV-08` | Automatic merge, overwrite, reassignment, deletion, and Order/Loyalty/Promotion/value transfer are prohibited. | `SDP-CUST-05`, `12A`, `13` |
| `WP-T1-INV-09` | Material disputes are held pending the applicable decision; routine rejection does not automatically create a Review Case. | `SDP-CUST-13`, `21` |
| `WP-T1-INV-10` | Ordinary audit, support, reporting, or export cannot provide a route to reconstruct anonymized Customer identity. | `SDP-CUST-22` |

### 5.5 Domain outcomes

| Category | Semantic meaning |
|---|---|
| `Succeeded` | The complete authorized business outcome is authoritative. |
| `Rejected` | Validation, lifecycle, or policy precondition failed without mutation; response remains non-disclosing. |
| `Conflict` | Admission or concurrent-state conflict prevented mutation; no conflicting identity is disclosed. |
| `HeldForReview` | A material disputed/exceptional case requires controlled investigation or decision. |
| `Denied` | Trusted authorization or verification decision is not sufficient. |
| `DependencyUnavailable` | Required trusted scope, authorization, verification, or coordination evidence is unavailable; fail closed. |
| `Incomplete` | A multi-context completion claim cannot yet be made; reconciliation/escalation is required. |

These are logical categories, not HTTP status codes or public DTOs.

## 6. TD-CUST-02 — Phone-admission consistency and recovery

### 6.1 Required serialization behavior

`TECHNICAL_DESIGN_DECISION`: every accepted mutation affecting a canonical phone must behave as if evaluated against one authoritative ordering for the tuple `(Organization, canonical phone)`. The physical serialization mechanism remains unselected.

Required outcomes:

- two concurrent claims cannot both succeed;
- a current association and an unreleased restriction cannot coexist as independent successful claims for the same phone;
- a phone change is complete-or-preserve across old and new phone facts;
- authorization, requester verification, Profile state, and admission facts are revalidated at the later-selected completion boundary;
- a timeout or unknown technical result must not be reported as business success; and
- retries cannot create another accepted mutation.

### 6.2 Conflict and non-disclosure

The Application contract may reveal only that the requested phone is unavailable or that the request requires controlled review. It must not reveal whether the blocker is a current association or former restriction, nor the associated Profile, Brand, Branch, Customer, history, or evidence.

Underlying evidence is available only through a separately authorized review path. A non-disclosing response must not prevent internal provenance sufficient for accountable review.

### 6.3 Concurrency schedules

| Schedule | Required result |
|---|---|
| Two Profiles claim the same unclaimed phone | At most one success; the other receives non-disclosing conflict or approved held-review outcome. |
| Two changes target the same new phone | At most one complete change; every loser preserves its prior current phone. |
| Two changes target different new phones for one Profile | At most one authoritative complete result; no orphan association or duplicate former restriction. |
| Phone change races with a lifecycle change | Only combinations containing an included authorized operation are evaluated; excluded Deactivate/Reactivate/anonymization approval semantics are not invented. The phone change either completes against revalidated state or safely preserves prior state. |
| Dispute hold races with ordinary change | The hold blocks a not-yet-complete ordinary change; an already complete authoritative result becomes evidence for re-evaluation. |
| Duplicate/delayed request | It observes the original outcome or produces safe conflict; never a second mutation. |

### 6.4 Manual release boundary

Candidate E defines only release semantics and disputed release outcomes already covered by `SDP-CUST-13`. Ordinary undisputed release remains excluded because its approving authority is unresolved. Any later included release operation must:

- require documented current authority;
- revalidate the restriction and dispute state;
- end only the named admission block;
- leave identity/history/value untouched; and
- require a later admission request to pass all checks independently.

### 6.5 Failure, idempotency, and recovery

`TECHNICAL_DESIGN_DECISION`: an operation has a stable business request identity at the logical Application boundary. Repeating that identity must recover the same terminal outcome or report an unresolved/incomplete result; it must not execute another business mutation.

The retention, key format, persistence, and replay mechanism remain unresolved. Automatic retry is not approved. After uncertain failure, authority and mutable facts must be revalidated before any later continuation. Recovery may yield success only when the complete authoritative outcome can be proven; otherwise it yields safe failure, `Incomplete`, or controlled escalation.

## 7. TD-CUST-03 — Anonymization completion across contexts

### 7.1 Ownership boundary

Customer owns the anonymization request lifecycle and Customer Profile postcondition. Ordering owns historical Orders and Branch provenance. Loyalty owns ledger/history and freeze semantics. Promotions owns redemption history and Customer-specific benefit freeze. No context writes another context's Infrastructure records.

Candidate E begins after a separately authorized anonymization initiation. It does not define who approves anonymization.

### 7.2 Completion facts

Anonymization is semantically complete only when all required facts are evidenced:

1. ordinary Customer Profile data no longer identifies the Customer;
2. the ordinary current-phone association is removed;
3. the former phone remains unavailable through an admission restriction until separately authorized release;
4. Orders and originating-Branch provenance remain intact without receiving direct Customer PII merely for convenience;
5. Loyalty preserves required ledger/history, freezes redemption, and issues no new Customer-specific benefits under `SDP-CUST-01`/`02`;
6. Promotions preserves successful redemption history and freezes unredeemed Customer-specific benefits under `SDP-CUST-17`; and
7. retained evidence cannot provide an ordinary re-identification route.

Public/non-Customer-specific Promotion behavior is unchanged by this contract.

### 7.3 Logical progress states

| State | Meaning |
|---|---|
| `Requested` | A separately authorized request exists; no completion claim. |
| `CustomerApplied` | Customer ordinary identifying state and phone association have reached their required postcondition; downstream outcomes are not all evidenced. |
| `ExternalPending` | One or more receiving-context outcomes remain unconfirmed. |
| `ReconciliationRequired` | A failure or contradictory observation requires controlled recovery/escalation. |
| `Completed` | Every required completion fact is evidenced. |
| `RejectedOrCancelled` | The authorized workflow ended before Customer anonymization became effective; exact cancellation policy remains outside this design. |

These are semantic progress meanings, not approved persisted enum values.

### 7.4 Partial failure and retry

- Never claim `Completed` while a required receiving outcome is missing or contradictory.
- Once Customer ordinary identity has been removed effectively, technical recovery must not restore identity merely to retry coordination.
- A former-phone restriction remains fail-safe during incomplete coordination.
- Receiving contexts must treat repeated completion instructions idempotently at the semantic boundary and return their already-authoritative outcome where possible.
- Unknown, unavailable, or failed receiving outcomes move to pending/reconciliation, not silent success.
- Material unresolved completion creates controlled escalation evidence; it does not expose Restricted Identity Evidence to ordinary support.

No one-database transaction, event bus, outbox, saga, polling loop, or retry schedule is selected.

## 8. TD-CUST-04 — Logical Application contract

### 8.1 Trusted inputs

An included use case requires logical inputs equivalent to:

- stable request identity and operation kind;
- trusted actor/session reference from a future approved identity boundary;
- authoritative Customer Profile target;
- authoritative Organization scope, derived through controlled persisted relationships and an approved Organization Application contract;
- exact operation-specific authorization decision for that target/scope;
- requester-verification evidence reference where policy requires it;
- expected Profile lifecycle/current-association facts or version evidence;
- candidate canonical phone where relevant; and
- reason/evidence references required by dispute/manual-decision policy.

Client-supplied actor, role, capability, Organization, Brand, Branch, Customer ownership, or phone-ownership claims are never authority.

### 8.2 Execution sequence

1. Validate request shape without disclosing protected existence.
2. Validate trusted actor/session before protected lookup.
3. Resolve the authoritative target and Organization scope through controlled contracts.
4. Obtain requester-verification result where required.
5. Evaluate exact operation authorization against the persisted target/scope.
6. Load the current Customer and admission facts through Customer-owned ports.
7. Revalidate authorization, verification, lifecycle, dispute hold, and admission facts at the later-selected completion boundary.
8. Ask Domain policy for a typed decision.
9. Commit the complete outcome and required provenance through a future approved mechanism, or preserve the prior authoritative state.
10. Return a non-disclosing typed Application outcome.

The sequence is a logical contract. It approves no runtime port interface, transaction, lock, or persistence design.

### 8.3 Fail-closed matrix

| Condition | Required Application outcome |
|---|---|
| Missing/invalid/revoked actor or Session | `Denied`; no protected lookup disclosure. |
| Organization ancestry unavailable or contradictory | `DependencyUnavailable`; no mutation. |
| Missing/invalid/unavailable/out-of-scope authorization | `Denied` or `DependencyUnavailable`; no mutation. |
| Required requester verification absent/invalid | `Denied` or controlled hold according to existing policy; no mutation. |
| Profile absent, out of scope, or cross-Brand | Uniform non-disclosing result appropriate to the approved Presentation contract; exact external mapping remains later design. |
| Phone unavailable due to any admission blocker | Non-disclosing `Conflict` or material `HeldForReview`; never blocker identity. |
| Facts changed after initial authorization | Revalidate; reject/conflict/hold unless the current facts independently permit the operation. |
| Persistence/coordination result unknown | `Incomplete`/safe failure; never invented success. |

### 8.4 Provenance obligations

Successful, denied, held, failed, and incomplete sensitive operations require purpose-limited evidence sufficient to link request, trusted actor/requester, scope, authorization/verification decisions, affected target, before/after semantic facts, reason, outcome, time, and correlation. Raw secrets and unnecessary PII are prohibited. Exact audit schema, atomic append, readers, redaction, retention, and database protection remain later security/legal/technical design.

## 9. Traceability

| Design area | Owner decisions | Design refs |
|---|---|---|
| Phone validation/admission | `SDP-CUST-03`–`05` | `WP-T1-INV-01`–`04` |
| Visibility/non-disclosure | `SDP-CUST-06`, `08`, `20` | `WP-T1-INV-02`, §§6.2, 8.3 |
| Lifecycle/anonymization | `SDP-CUST-10`, `SDP-CUST-11`, `SDP-CUST-15`, `SDP-CUST-22`, `SDP-CUST-A2` | `WP-T1-INV-06`, §7 |
| Phone change | `SDP-CUST-12A`, `16` | `WP-T1-INV-04`, `05`, §§3.1, 6 |
| Release/dispute | `SDP-CUST-12B`, `13`, `21` | `WP-T1-INV-07`, `09`, §§6.4, 8.4 |
| Loyalty/Promotion postconditions | `SDP-CUST-01`, `02`, `17` | §7 only; internals excluded |
| Authority boundary | `SDP-CUST-09`, `12A`, `13`, `20` | §§3, 8 |
| Context-only policies | `SDP-CUST-18`, `19` | Explicit exclusion; no Candidate E design |

## 10. Acceptance criteria and review evidence

Gate A reviewers must be able to verify from this document that:

- every included use case maps to an Owner-confirmed outcome and authority precondition;
- every deferred operation is visibly excluded;
- all ten invariants are explicit and mutually consistent;
- Profile, admission restriction, Review Case, and Restricted Identity Evidence are not conflated;
- concurrency schedules state required outcomes without choosing a physical mechanism;
- anonymization completion preserves receiving-context ownership and never assumes one transaction;
- Application outcomes are typed, non-disclosing, and fail closed;
- Layered DDD dependencies point inward;
- CUST-18/19 remain context only; and
- no public API, schema, code, implementation, or Gate approval is implied.

## 11. Unresolved decisions and later gates

| Unresolved item | Authority / later gate | Candidate E impact |
|---|---|---|
| Authority for Profile creation, ordinary Deactivate, Reactivate, anonymization approval, ordinary undisputed release | Owner decision | Operations remain excluded. |
| Exact requester-verification evidence/assurance | Owner/security/legal review | Required before implementation; semantic fail-closed boundary is defined. |
| Runtime authorization and Session contract | P1/Identity review and separate authorization | Semantic dependency only. |
| Official phone allocation source and outage/staleness behavior | Technical/operational review; Owner if business fallback is proposed | Implementation blocker, not semantic Gate A ambiguity. |
| Physical aggregate persistence, constraints, transaction, lock, idempotency, recovery | Gate B technical design | Not selected here. |
| Review Case persistence/workflow/access/retention | Technical/security/legal review | Business trigger only is defined. |
| Restricted Identity Evidence need/topology/controls/retention | Owner/legal/security/technical review | Kept outside ordinary design. |
| Exceptional evidence access/export workflow | Owner plus qualified legal/privacy review | Explicitly outside Candidate E. |
| Cross-context transport/retry/reconciliation mechanism | Later technical design | Semantic completion contract only. |
| Canonical ODB allocation for SDP references | Separate Owner governance process | No effect on policy validity; no ID allocated here. |

## 12. Design closure verdict

`WP-T1` is `DESIGN_COMPLETE_FOR_REVIEW` for `TD-CUST-01` through `TD-CUST-04`. This means the bounded semantic design is available for technical and Owner Gate A review. It does not mean `TECHNICAL_DESIGN_APPROVED`, `GATE_A_APPROVED`, implementation-ready, operationally accepted, or production-ready.

The separate Candidate E Gate A readiness package determines whether the evidence set is ready to submit.
