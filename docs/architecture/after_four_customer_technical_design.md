# AFTER FOUR — WP-T1 Customer Technical Design

**Work package:** `WP-T1`

**Design scope:** Candidate E — Customer Lifecycle and Phone-Admission Semantic Contract

**Document status:** `TECHNICAL_PROPOSAL — CORRECTIONS_PREPARED_FOR_INDEPENDENT_RE_REVIEW`

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

The boundaries own different authoritative facts; Phone Admission must not become an uncontrolled duplicate Customer Profile:

| Authoritative fact | Logical owner | Contract boundary |
|---|---|---|
| Customer Profile lifecycle | Customer Profile | Phone Admission may evaluate an authoritative lifecycle fact supplied for an operation but does not own or copy lifecycle state as another source of truth. |
| Profile's current-phone relationship | Customer Profile | The Profile owns which canonical phone is current for that Profile. |
| Organization-wide phone-admission decision | Organization Phone Admission | It owns whether a requested canonical phone may be admitted in the authoritative Organization namespace. |
| Former-phone restriction | Organization Phone Admission | It owns the admission block, not the former Customer's identity. |
| Dispute and material Review Case | Customer Review Case | It owns the purpose-limited hold/investigation/decision record, not Profile or admission state. |
| Restricted Identity Evidence | Separate restricted boundary | It is never an ordinary Profile, admission, support, or duplicate-detection source. |

`TECHNICAL_DESIGN_DECISION`: an included operation must compare the authoritative Profile current-phone fact with the applicable Phone Admission claim/restriction facts as one logical consistency check. Phone Admission may retain only the minimum logical claim evidence needed to decide the Organization namespace; this proposal does not select its physical representation. If the two boundaries disagree, the Application must not silently choose either fact, overwrite either owner, expose a possibly affected Customer, or claim success or confirmed preservation. It returns a non-disclosing incomplete/unknown result and requires controlled reconciliation under §§5.6 and 6.6. The physical detection, repair, and reconciliation mechanism remains a later-gate design.

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
| `WP-T1-INV-04` | Successful phone change replaces the current association completely and creates the old-phone restriction. A confirmed-not-applied failure preserves the previous current association. An unknown result proves neither success nor preservation until reconciliation; no partial accepted outcome exists. | `SDP-CUST-12A`, `16` |
| `WP-T1-INV-05` | An Inactive Profile remains Inactive after successful phone change. | `SDP-CUST-16` |
| `WP-T1-INV-06` | Anonymized is terminal for ordinary Profile operations and cannot be restored by a new phone or Profile. | `SDP-CUST-10`, `11`, `22` |
| `WP-T1-INV-07` | Manual release ends only admission blocking; it creates no association, identity restoration, authority, or history/value transfer. | `SDP-CUST-12B`, `13` |
| `WP-T1-INV-08` | Automatic merge, overwrite, reassignment, deletion, and Order/Loyalty/Promotion/value transfer are prohibited. | `SDP-CUST-05`, `12A`, `13` |
| `WP-T1-INV-09` | Material disputes are held pending the applicable decision; routine rejection does not automatically create a Review Case. | `SDP-CUST-13`, `21` |
| `WP-T1-INV-10` | Ordinary audit, support, reporting, or export cannot provide a route to reconstruct anonymized Customer identity. | `SDP-CUST-22` |

### 5.5 Business outcome dimension

| Category | Semantic meaning |
|---|---|
| `Succeeded` | The complete authorized business outcome is authoritative. |
| `Rejected` | Validation, lifecycle, or policy precondition failed without mutation; response remains non-disclosing. |
| `Conflict` | Admission or concurrent-state conflict prevented mutation; no conflicting identity is disclosed. |
| `HeldForReview` | The phone change is confirmed not applied. An applicable controlled hold or review condition is authoritative. |
| `Denied` | Trusted authorization or verification decision is not sufficient. |
| `DependencyUnavailable` | Required trusted scope, authorization, verification, or coordination evidence is unavailable; fail closed. |
| `NotYetDetermined` | No confirmed business success or confirmed business failure can yet be stated because application of the operation is unknown. |

These are logical business meanings, not HTTP status codes, public DTOs, or persisted enum selections.

### 5.6 Business outcome, execution certainty, and recovery status

`TECHNICAL_DESIGN_DECISION`: every operation result is reasoned about on three independent semantic dimensions. They must not be collapsed into one status:

| Dimension | Logical categories | Meaning |
|---|---|---|
| Business outcome | `Succeeded`, `Rejected`, `Conflict`, `HeldForReview`, `Denied`, `DependencyUnavailable`, or `NotYetDetermined` | What can truthfully be said about the requested business operation. |
| Execution certainty | `ConfirmedApplied`, `ConfirmedNotApplied`, or `Unknown` | Whether the required authoritative facts are proven applied, proven not applied, or cannot yet be established. |
| Recovery status | `NotRequired`, `Pending`, `ReconciliationRequired`, or `Completed` | Whether controlled technical recovery/reconciliation is needed and whether that work has ended. |

Valid relationships are constrained as follows:

| Semantic relationship | Required interpretation |
|---|---|
| `Succeeded` | Requires `ConfirmedApplied` and proof of every required completion postcondition. Recovery is `NotRequired` or `Completed`; recovery completion alone does not establish success. |
| Terminal `Rejected`, `Conflict`, `Denied`, or pre-mutation `DependencyUnavailable` | Requires `ConfirmedNotApplied` for the requested mutation. It must not be used when execution is unknown. |
| `HeldForReview` | Requires `ConfirmedNotApplied` for the requested mutation and an authoritative controlled hold or review condition. Human review status remains distinct from technical recovery status. |
| `NotYetDetermined` | Pairs with `Unknown` and `Pending` or `ReconciliationRequired`; it confirms neither business success nor business failure and does not prove that the original state is intact. |
| Recovery `Completed` | Means reconciliation work ended. It must separately establish `ConfirmedApplied` or `ConfirmedNotApplied` and the resulting business outcome; it never implies the requested operation succeeded. |

`Incomplete` remains the non-disclosing Application communication for `NotYetDetermined` + `Unknown` + pending/reconciliation semantics. It is not itself a confirmed business rejection, failure, or success. Retries and reconciliation retain the original request identity and provenance and revalidate every still-applicable condition.

For a phone-change request, `HeldForReview` is valid only with `ConfirmedNotApplied` and an authoritative controlled hold or review condition. Its recovery status is `NotRequired`, or `Completed` only after reconciliation proved non-application and the authoritative hold. Human review being pending is not technical recovery status; `Pending` or `ReconciliationRequired` cannot establish `HeldForReview`. An uncertain request remains `NotYetDetermined` + `Unknown` and is communicated as `Incomplete`.

The hold/Review Case and phone-change mutations have separate outcomes and evidence. A successfully persisted hold or Review Case is not proof that the phone change was prevented. `HeldForReview` requires separate proof that the phone change was not applied and that the hold condition is authoritative.

## 6. TD-CUST-02 — Phone-admission consistency and recovery

### 6.1 Required serialization behavior

`TECHNICAL_DESIGN_DECISION`: ordering by `(Organization, canonical phone)` is necessary for a phone resource but is not sufficient for a phone change spanning a Profile, an old phone, and a new phone. Every accepted phone change must behave as one semantic atomic operation over:

- the authoritative Customer Profile and its lifecycle;
- its existing current-phone relationship;
- the requested new canonical phone;
- the old and new Organization-wide admission facts;
- any applicable former-phone restriction; and
- any material dispute hold relevant under existing approved policy.

All preconditions and invariants must be evaluated against one logically consistent operation state. The physical transaction, lock, index, isolation, storage, or distributed coordination mechanism remains unselected.

Required outcomes:

- two concurrent claims cannot both succeed;
- a current association and an unreleased restriction cannot coexist as independent successful claims for the same phone;
- two concurrent changes from the same Profile/input state to different new phones cannot both become authoritative successes;
- operations with overlapping old/new phone resources cannot create duplicate current associations, bypass an unreleased former-phone restriction, or leave contradictory Profile/admission facts;
- a phone change is complete-or-confirmed-preserve across Profile, old-phone, new-phone, admission, and restriction facts;
- authorization, requester verification, Profile state, dispute hold, and admission facts are revalidated at the semantic completion boundary in §6.2;
- success requires proof of every required postcondition;
- a confirmed-not-applied outcome proves the prior authoritative relationship was preserved, while an unknown result must report `Incomplete` and cannot assume preservation; and
- retries cannot create another accepted mutation.

The required lifecycle race semantics include an already-authorized phone change overlapping Customer-side anonymization completion. Candidate E begins only after separately authorized anonymization initiation and does not define anonymization approval authority. The authoritative ordering and outcomes are specified in §6.4 and §7.4.

Canonical phone validation remains a business precondition under `SDP-CUST-03`: it uses current official Vietnamese mobile allocation evidence and never guesses, repairs, infers, or fuzzy-matches invalid input.

### 6.2 Semantic completion boundary

`TECHNICAL_DESIGN_DECISION`: the completion boundary is a logical proof boundary, not a selected database commit point or coordination mechanism.

- **Before the completion boundary:** the phone change is not yet a successful or authoritative completed operation. Initial authorization, validation, or partial work supplies no success claim. A dispute hold becoming applicable before this boundary blocks ordinary completion and produces the applicable held or incomplete semantics.
- **At the completion boundary:** the operation proves against one logically consistent state that the actor/scope/verification remain valid; the Profile lifecycle still permits the operation; no applicable dispute hold blocks it; the proposed phone remains valid and admissible; the Profile's new current-phone relationship, the new-phone admission fact, the old-phone restriction, and required provenance agree; and every invariant in §5.4 holds. Only then may the business outcome become `Succeeded` with `ConfirmedApplied`.
- **After the completion boundary:** the successful outcome is authoritative under this semantic contract. A retry with the same request identity returns or recovers that outcome and must not apply the logical operation twice or create a competing result. A later dispute may review the authoritative result under existing policy but does not retroactively make an in-flight competing change successful.

If completion cannot be proven, the result is either confirmed not applied with prior authoritative state proven preserved, or `NotYetDetermined`/`Unknown` with `Incomplete` communication and reconciliation required. Complete-or-preserve is therefore an authoritative invariant, not permission for a caller to assume preservation during uncertainty.

### 6.3 Conflict and non-disclosure

The Application contract may reveal only that the requested phone is unavailable or that the request requires controlled review. It must not reveal whether the blocker is a current association or former restriction, nor the associated Profile, Brand, Branch, Customer, history, or evidence.

Underlying evidence is available only through a separately authorized review path. A non-disclosing response must not prevent internal provenance sufficient for accountable review.

### 6.4 Concurrency schedules

| Schedule | Required result |
|---|---|
| Two Profiles claim the same unclaimed phone | At most one success; the other receives non-disclosing conflict or approved held-review outcome. |
| Two changes target the same new phone | At most one complete change; every other operation is confirmed not applied with preservation proven or remains unknown/incomplete until reconciliation. |
| Two changes target different new phones for one Profile from the same input association | At most one authoritative complete result. The other is confirmed not applied or reported unknown pending reconciliation; no orphan association, duplicate former restriction, or second current phone may result. |
| Profile A changes `old-a → new-c` while Profile B changes `old-b → old-a` | Both cannot bypass the fact that `old-a` is either A's current phone or A's unreleased former phone. At most policy-consistent non-overlapping outcomes may complete; no swap, duplicate association, or restriction bypass is inferred. |
| Two Profiles submit any changes whose old/new phone resource sets overlap | Each operation is evaluated across its complete resource set. A winner must prove all postconditions; a loser is confirmed not applied or remains unknown/incomplete until reconciliation. |
| Phone change races with Customer-side anonymization completion | If Customer-side anonymization becomes authoritative first, the ordinary phone change cannot complete, the ordinary current-phone association is removed, and every applicable former-phone restriction remains effective. If the phone change reaches §6.2 first, its new phone becomes current and its old phone becomes restricted; subsequent anonymization removes the then-current ordinary association and preserves every required restriction. If ordering or application cannot be proven, report `NotYetDetermined` + `Unknown` through `Incomplete`, require controlled reconciliation, assume neither preservation nor success, and never restore ordinary Profile PII after anonymization is effective. Candidate E begins after separately authorized anonymization initiation and does not define approval authority. |
| Phone change races with another lifecycle change | Only combinations containing an included authorized operation are evaluated; excluded Deactivate/Reactivate semantics are not invented. The phone change completes only against lifecycle state revalidated at §6.2; otherwise it is confirmed not applied or unknown/incomplete. |
| Dispute hold races with ordinary change | A hold authoritative before the completion boundary blocks the not-yet-complete ordinary change. A change already proven complete remains authoritative evidence for controlled re-evaluation; an outcome whose ordering cannot be proven is incomplete and requires reconciliation. |
| Duplicate/delayed request | It observes the original outcome or produces safe conflict; never a second mutation. |

### 6.5 Manual release boundary

Candidate E defines only release semantics and disputed release outcomes already covered by `SDP-CUST-13`. Ordinary undisputed release remains excluded because its approving authority is unresolved. Any later included release operation must:

- require documented current authority;
- revalidate the restriction and dispute state;
- end only the named admission block;
- leave identity/history/value untouched; and
- require a later admission request to pass validation, authorization, Organization-wide admission, restriction, and dispute checks independently.

Release ends only the named restriction. It never creates a current association, authorizes admission, restores identity, or bypasses normal checks.

### 6.6 Failure, idempotency, and recovery

`TECHNICAL_DESIGN_DECISION`: an operation has a stable business request identity at the logical Application boundary. Repeating that identity must recover the same terminal outcome or report an unresolved/incomplete result; it must not execute another business mutation.

The retention, key format, persistence, and replay mechanism remain unresolved. Automatic retry is not approved. A business rejection or denial is reported only with `ConfirmedNotApplied`; it must not disguise an unknown execution result. After uncertain failure, the operation reports `NotYetDetermined`/`Unknown` through `Incomplete`, retains original identity/provenance, and revalidates authority and every mutable fact before any continuation. It must not assert that the prior state is intact unless preservation is proven.

Recovery may determine `Succeeded` only when the complete authoritative outcome is proven. It may determine a confirmed failure only when non-application and required preservation are proven. Recovery completion by itself states neither. Contradictory Profile/admission observations remain non-disclosing and require controlled reconciliation; they must not become an ordinary identity lookup.

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
- An unresolved cross-context result has `NotYetDetermined` business meaning and `Unknown` execution certainty. Recovery completion must separately establish whether anonymization completed or did not complete; it does not itself imply business success.
- Retry/reconciliation retains the original anonymization request identity and provenance and revalidates applicable authority and mutable conditions. Once ordinary Customer identity removal is authoritative, no recovery path may restore Profile PII or an ordinary identity association.

Phone-change interaction follows the same authoritative-ordering rule:

- if Customer-side anonymization becomes effective before phone-change completion, the ordinary change cannot complete, the ordinary current-phone association is removed, and applicable former-phone restrictions remain effective;
- if phone change reaches its authoritative completion boundary first, its new phone becomes current and its old phone becomes restricted; later anonymization removes that then-current ordinary association and preserves every required restriction; and
- if ordering or application cannot be proven, the result is `NotYetDetermined` + `Unknown`, communicated as `Incomplete`, with controlled reconciliation. Neither preservation nor success is assumed, and effective anonymization is never reversed to restore ordinary Profile PII.

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
7. Revalidate authorization, verification, lifecycle, dispute hold, and admission facts at the semantic completion boundary defined in §6.2.
8. Ask Domain policy for a typed decision.
9. Through a future approved mechanism, establish the complete authoritative outcome and required provenance or prove that the requested mutation was not applied; if neither can be proven, record unknown execution certainty and require reconciliation.
10. Return a non-disclosing result carrying the business outcome, execution certainty, and recovery status semantics in §5.6.

The sequence is a logical contract. It approves no runtime port interface, transaction, lock, or persistence design.

### 8.3 Fail-closed matrix

| Condition | Required Application outcome |
|---|---|
| Missing/invalid/revoked actor or Session | `Denied`; no protected lookup disclosure. |
| Organization ancestry unavailable or contradictory | `DependencyUnavailable`; no mutation. |
| Missing/invalid/unavailable/out-of-scope authorization | `Denied` or `DependencyUnavailable`; no mutation. |
| Required requester verification absent/invalid | `Denied` or controlled hold according to existing policy; no mutation. |
| Profile absent, out of scope, or cross-Brand | Uniform non-disclosing result appropriate to the approved Presentation contract; exact external mapping remains later design. |
| Phone unavailable due to any admission blocker | Non-disclosing `Conflict`, or `HeldForReview` only when the next row's certainty and hold conditions are proven; never blocker identity. |
| Applicable controlled hold/review condition is authoritative and phone change is proven not applied | `HeldForReview` + `ConfirmedNotApplied`; recovery is `NotRequired`, or `Completed` only after reconciliation separately proved both non-application and the authoritative hold. |
| Hold/Review Case persists but phone-change non-application is not proven | `NotYetDetermined` + `Unknown` + pending/reconciliation, communicated as `Incomplete`; the hold outcome is not proof of the phone-change outcome. |
| Facts changed after initial authorization | Revalidate; reject/conflict/hold unless the current facts independently permit the operation. |
| Profile current-phone and Phone Admission facts disagree | `NotYetDetermined` + `Unknown` + `ReconciliationRequired`, communicated as `Incomplete`; no further mutation, silent source selection, or identity disclosure. |
| Persistence/coordination result unknown | `NotYetDetermined` + `Unknown` + pending/reconciliation, communicated as `Incomplete`; never invented success, confirmed failure, or assumed preservation. |

### 8.4 Provenance obligations

Successful, denied, held, failed, and incomplete sensitive operations require purpose-limited evidence sufficient to link the original request identity, trusted actor/requester, scope, authorization/verification decisions, affected target, before/after semantic facts, business outcome, execution certainty, recovery status, reason, time, and correlation. Where a hold/Review Case and phone change both occur, their outcomes and evidence remain separately attributable: evidence that the hold persisted does not prove the phone change was not applied. Recovery evidence preserves that provenance and cannot become an ordinary identity-reconstruction route. Raw secrets and unnecessary PII are prohibited. Exact audit schema, atomic append, readers, redaction, retention, and database protection remain later security/legal/technical design.

## 9. Traceability

| Design area | Owner decisions | Design refs |
|---|---|---|
| Phone validation/admission | `SDP-CUST-03`–`05` | `WP-T1-INV-01`–`04` |
| Visibility/non-disclosure | `SDP-CUST-06`, `08`, `20` | `WP-T1-INV-02`, §§6.3, 8.3 |
| Lifecycle/anonymization | `SDP-CUST-10`, `SDP-CUST-11`, `SDP-CUST-15`, `SDP-CUST-22`, `SDP-CUST-A2` | `WP-T1-INV-06`, §7 |
| Phone change | `SDP-CUST-12A`, `16` | `WP-T1-INV-04`, `05`, §§3.1, 6 |
| Release/dispute | `SDP-CUST-12B`, `13`, `21` | `WP-T1-INV-07`, `09`, §§6.5, 8.4 |
| Loyalty/Promotion postconditions | `SDP-CUST-01`, `02`, `17` | §7 only; internals excluded |
| Authority boundary | `SDP-CUST-09`, `12A`, `13`, `20` | §§3, 8 |
| Context-only policies | `SDP-CUST-18`, `19` | Explicit exclusion; no Candidate E design |

## 10. Acceptance criteria and review evidence

Gate A reviewers must be able to verify from this document that:

- every included use case maps to an Owner-confirmed outcome and authority precondition;
- every deferred operation is visibly excluded;
- all ten invariants are explicit and mutually consistent;
- authoritative fact ownership prevents Customer Profile and Phone Admission from becoming competing sources of truth;
- Profile, admission restriction, Review Case, and Restricted Identity Evidence are not conflated;
- phone-change semantic atomicity, the completion boundary, and concurrency schedules state required outcomes without choosing a physical mechanism;
- business outcome, execution certainty, and recovery status remain distinct, including during unknown results;
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

`WP-T1` remains `CORRECTIONS_PREPARED_FOR_INDEPENDENT_RE_REVIEW` for `TD-CUST-01` through `TD-CUST-04`. Independent re-review resolved `T1-IR-02` and `T1-IR-03`. The final semantic corrections for `T1-IR-01` and `T1-IR-04` are prepared and remain pending independent re-review; this document does not independently accept its own corrections. This does not mean `TECHNICAL_DESIGN_APPROVED`, `GATE_A_APPROVED`, implementation-ready, operationally accepted, or production-ready.

The separate Candidate E Gate A readiness package determines whether the evidence set is ready to submit.
