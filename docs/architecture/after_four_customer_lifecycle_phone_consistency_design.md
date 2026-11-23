# AFTER FOUR — Customer Profile Lifecycle and Phone Admission Consistency Model

**Work package:** WP4.2

**Document status:** `DOMAIN DESIGN PROPOSAL`

**Owner-approved inputs:** `SDP-CUST-01` through `SDP-CUST-22`, including `SDP-CUST-12A` and `SDP-CUST-12B`; `SDP-CUST-A2`; `SDP-SCOPE-01`

**Technical design approval:** `NOT_GRANTED`

**Implementation authorization:** `NOT_GRANTED`

**Gate A / Gate B / Gate C:** `NOT_GRANTED` for this design

**Control Acceptance:** `NOT_GRANTED`

**Final Operational Acceptance:** `NOT_GRANTED`

**Production Authorization:** `NOT_GRANTED`

## 1. Purpose, status, and governance

This document analyzes Customer Profile lifecycle, phone association lifecycle, Organization-wide phone admission, former-phone restriction, duplicate conflict, controlled phone change, anonymization, concurrency, and business-level recovery. It follows the responsibility boundary in [WP4.1](after_four_customer_domain_boundary_design.md).

Owner-approved policies are authoritative only within their recorded scope. Lifecycle interpretations, candidate consistency outcomes, sequencing, and evidence expectations introduced here are `DOMAIN DESIGN PROPOSAL`, `PROVISIONAL`, or `REQUIRES TECHNICAL DESIGN`; they are not new Owner decisions or implementation approval.

The following lifecycle models remain separate:

1. Customer Profile lifecycle;
2. phone association/restriction lifecycle;
3. Loyalty lifecycle;
4. Promotion lifecycle; and
5. Order and Purchase History lifecycle.

No transition in one model silently causes an unapproved transition in another.

## 2. Scope and exclusions

### 2.1 In scope

- Profile creation and lifecycle transition semantics;
- conceptual phone association and former-phone restriction states;
- controlled phone change and manual release business outcomes;
- controlled anonymization interactions;
- precise Organization-wide phone admission invariants;
- concurrency scenarios and acceptable/forbidden business outcomes;
- business failure, recovery, audit, and provenance requirements; and
- conceptual Layered DDD responsibilities.

### 2.2 Out of scope

- final aggregate roots, entities, Value Objects, Domain Services, commands, queries, ports, repositories, or events;
- API, controller, DTO, response, error-code, or frontend design;
- table, column, index, constraint, trigger, lock, isolation level, transaction, queue, outbox, saga, retry, idempotency, encryption, or physical persistence mechanism;
- authorization, requester-verification, Session, MFA, capability, or delegation implementation;
- official phone-allocation source selection or refresh/outage implementation;
- Restricted Identity Evidence physical ownership/topology;
- legal conclusions, retention periods, legal holds, or disposal procedures;
- multi-Brand behavior; and
- WP4.3, implementation, Gate/Control Acceptance, Final Operational Acceptance, or production use.

## 3. Canonical sources and decision references

### 3.1 Business-policy sources

- [Owner Decision Baseline §5A](after_four_owner_decision_baseline.md#5a-production-mvp-customer-loyalty-and-promotions-scope)
- [Customer Management Owner Decisions](after_four_customer_management_owner_decisions.md)
- [SDP-CUST-01 — Preserve & Freeze Loyalty](after_four_sdp_cust_01_owner_decision.md)
- [SDP-CUST-02 — Pseudonymize](after_four_sdp_cust_02_owner_decision.md)
- [SDP-SCOPE-01 — Multi-Brand deferral](after_four_sdp_scope_01_owner_decision.md)
- [Business Domain Model §11](after_four_business_domain_model.md#11-customers-loyalty-and-promotions)
- [WP4.1 Customer Domain Boundary](after_four_customer_domain_boundary_design.md)
- [WP-G0 Candidate E Scope Charter](after_four_wp_g0_candidate_e_scope_charter.md)

### 3.2 Architecture and supporting sources

- [ADR-0011 — Project-wide Layered DDD](adr/0011-project-wide-layered-ddd.md)
- [DDD Foundation](after_four_ddd_foundation.md)
- [Foundation Decisions](after_four_foundation_decisions.md)
- [Data Dictionary §6](after_four_data_dictionary.md#6-customers-loyalty-and-promotions)
- [Data Integrity Rules](after_four_data_integrity_rules.md)
- [ERD §7](after_four_erd.md#7-customer-and-loyalty-erd)
- [I1 Organization Scope Contract](after_four_i1_organization_scope_contract_design.md)
- [Identity Decision Register](after_four_identity_decision_register.md)
- [Identity Security Review Checklist](after_four_identity_security_review_checklist.md)
- [ADR-0006](adr/0006-authentication-session-topology.md) and [ADR-0008](adr/0008-deployment-environments.md), both still Proposed
- relevant [Catalog Core](after_four_catalog_core_technical_design.md) and [Package C](after_four_package_c_technical_design.md) patterns for Layered DDD and explicit authorization boundaries, without importing Catalog lifecycle policy into Customer.

No source conflict requiring a canonical correction was identified. Existing physical Customer examples remain superseded/unapproved as recorded by WP3.5; this document does not revive them.

## 4. Domain concepts and lifecycle separation

| Model | Owns | Does not own or imply |
|---|---|---|
| Customer Profile lifecycle | Existence of the ordinary Profile and Active/Inactive/Anonymized business state. | Phone availability by itself; Loyalty/Promotion/Order state; authorization. |
| Phone association lifecycle | Whether one canonical phone is a candidate, current association, unreleased former restriction, or released/eligible within one Organization. | Permanent identity, Profile visibility, Brand participation, or entitlement. |
| Dispute hold | A control condition preventing a consequential disputed action while evidence and approval are pending. | Automatic Profile/phone state correction, merge, deletion, or transfer. |
| Loyalty lifecycle | Balance, ledger, accrual, redemption, adjustment, and freeze. | Customer Profile lifecycle ownership. Anonymization only invokes the approved preserve/freeze boundary. |
| Promotion lifecycle | Promotion eligibility, usage, benefits, and history, including the approved post-anonymization preserve/freeze outcome under `SDP-CUST-17`. | Loyalty freeze semantics; general Promotion eligibility, public Promotion rules, or cross-Brand applicability. |
| Order/history lifecycle | Orders, originating Branch, Purchase History, and commercial records. | Deletion or rewrite caused by Profile lifecycle changes. |

`DOMAIN DESIGN PROPOSAL`: a dispute hold is best treated as an orthogonal control condition rather than a new Profile or phone lifecycle state. A phone can be currently associated or formerly restricted while a proposed change/release is held. Whether that condition is persisted is unresolved.

## 5. Customer Profile lifecycle model

### 5.1 States

| State | Classification | Meaning |
|---|---|---|
| Not yet created | `DOMAIN DESIGN PROPOSAL` | No admitted Profile exists. A request may be evaluated without implying a durable record. |
| Active | `OWNER-APPROVED BUSINESS POLICY` | Initial state after successful Profile creation under `SDP-CUST-15`; Profile is available for ordinary authorized Customer operations. The state itself grants no capability. |
| Inactive | `OWNER-APPROVED BUSINESS POLICY` | Profile is unavailable for ordinary active use but may undergo the controlled phone-change operation under `SDP-CUST-16` without reactivation. It may be reactivated only after authorized review and is neither deleted nor anonymized. |
| Anonymized | `OWNER-APPROVED BUSINESS POLICY` | Terminal for ordinary Profile operations. Ordinary Profile data no longer identifies the Customer; no ordinary restoration exists. |

`OWNER-APPROVED BUSINESS POLICY`: under `SDP-CUST-15`, every successfully created Customer Profile starts in `Active`. This lifecycle state does not establish phone ownership or identity verification, marketing consent, authorization, or broader Brand/Branch visibility.

### 5.2 Transition matrix

| Source | Requested action | Preconditions | Business-policy authority | Target | Profile-data effect | Phone effect | Downstream effect | Must not happen | Provenance | Unresolved |
|---|---|---|---|---|---|---|---|---|---|---|
| Not yet created | Create Profile | Valid phone; Organization-wide admission succeeds; required trusted scope | Exact create capability/authority unresolved | Active (`SDP-CUST-15`) | Create allowed basic data; display name optional | Establish one current association | No automatic Order/Loyalty/Promotion creation or transfer | Duplicate Profile, disclosure of conflicting record, merge, value transfer | Creation actor/scope, validation/admission outcome | Failed-attempt record, exact authority/evidence |
| Active | Deactivate | Controlled request and authorization | Exact role/capability unresolved | Inactive | Preserve Profile/history; mark lifecycle outcome | Current phone remains associated; no release | No silent Loyalty/Promotion/Order transition | Purge, anonymize, release phone, freeze/transfer value by implication | Actor, authority, reason/evidence where later required, before/after | Reason rule, capability, effects on ordinary reads |
| Inactive | Reactivate | Authorized review succeeds | Exact role/capability unresolved | Active | Restore ordinary active state without recreating identity | Existing association/restriction remains unchanged unless separately changed | No silent downstream state change | New Profile identity, phone reassignment, restoration of anonymized identity | Reviewer, evidence, decision, before/after | Review standard and authority |
| Inactive | Controlled phone change | Customer verification succeeds; new phone is valid; Organization-wide admission succeeds; required authority is current | `SDP-CUST-12A` and `SDP-CUST-16`; disputed/exceptional cases also follow `SDP-CUST-13` | Inactive | Preserve Profile data and lifecycle state | New phone becomes current; old phone becomes formerly restricted under `SDP-CUST-12B` | No silent Loyalty/Promotion/Order transition or transfer | Automatic reactivation, merge, history/value transfer, expanded visibility, or partial accepted outcome | Actor, verifier, authority, scope, validation/admission, before/after association, outcome | Verification evidence, capability representation, atomicity, concurrency, recovery |
| Active | Controlled anonymization | Verified request and authority; required legal/privacy conditions; coordinated completion | Exact authority/capability unresolved | Anonymized | Ordinary Profile becomes nonidentifying | Remove ordinary association; retain former-phone restriction until manual release | Preserve Orders/history; preserve/freeze Loyalty; preserve redeemed Promotion history and freeze unredeemed Customer-specific Promotion benefits under `SDP-CUST-17`; pseudonymous references only for legitimate purpose | Automatic phone release, downstream deletion/transfer, identity restoration, Promotion redemption/transfer through the anonymized Customer | Request, verification/authority, purpose, outcome, before/after, downstream coordination evidence | Atomicity, partial failure, exact field treatment, Promotion coordination, legal requirements |
| Inactive | Controlled anonymization | Same as above | Exact authority/capability unresolved | Anonymized | Same as above | Same as above | Same as above | Same as above | Same as above | Same as above |
| Anonymized | Reactivate/restore ordinary Profile | Never permitted by ordinary operations | None | Anonymized | No ordinary restoration | New phone/Profile cannot restore old identity | No downstream restoration/value transfer | Re-identification or revival by convenience | Rejected attempt evidence subject to later policy | Exceptional legal conflict/re-identification remains separate review |
| Any existing state | Physical delete/purge | No approved ordinary transition | None | Unchanged | Preserve according to purpose/retention policy | No implicit release | Preserve domain-owned histories | Status-driven purge | Rejection if an operation was attempted | Legal disposal rules remain unresolved |

Profile lifecycle, phone association, former-phone restriction, Loyalty, Promotions, and Orders remain separate even when one business operation coordinates more than one model.

## 6. Profile creation rules

### 6.1 Approved rules

1. `OWNER-APPROVED BUSINESS POLICY`: a new Profile requires a valid canonical Vietnamese mobile under `SDP-CUST-03` and `SDP-CUST-07`.
2. `OWNER-APPROVED BUSINESS POLICY`: after successful creation, the Profile starts in `Active` under `SDP-CUST-15`; this state grants no verification, consent, authorization, or visibility by itself.
3. Display name is optional.
4. Admission is evaluated in the Organization-wide phone namespace, regardless of Brand.
5. A current association or unreleased former-phone restriction blocks admission.
6. The conflict response must not reveal another Brand, Customer, Profile, or history.
7. Failure never authorizes merge, overwrite, reassignment, or value/entitlement transfer.
8. Mandatory phone for Profile creation does not require every visitor or Order to register.

### 6.2 Originating scope and disclosure

`DOMAIN DESIGN PROPOSAL`: the creation evaluation requires authoritative Organization plus originating Brand/Branch context so admission uses the Organization namespace while disclosure and authorization remain scoped. I1 may later provide Brand-to-Organization ancestry to an approved Customer consumer, but I1 is non-authorizing and no consumer is authorized here.

An allowed result may state only that creation was accepted. A rejected conflict may state that the phone cannot be admitted or that manual review is required, subject to later API/error design. It must not identify the holding Profile, Brand, Branch, Customer, history, or whether the blocker is a current association versus former restriction unless an independently authorized investigation permits that evidence.

`OWNER-APPROVED BUSINESS POLICY`: under `SDP-CUST-21`, a material conflict creates a durable Customer Review Case when investigation is required, a disputed association is held, or an authorized manual decision is needed. The case retains purpose, scope, status, responsible reviewer, decision, and only necessary provenance. Routine validation failures and ordinary duplicate rejections do not automatically create a durable case. Persistence, workflow, and technical audit representation remain unselected; a technical log is not automatically a business record.

## 7. Phone association lifecycle

### 7.1 Conceptual states

| Phone condition in one Organization | Meaning | Admission consequence |
|---|---|---|
| Available / not associated | No current association and no unreleased former-phone restriction is known under authoritative state. | May become a candidate; validity and all other preconditions still apply. |
| Candidate | One business request is evaluating the phone for a new/current association. | `PROVISIONAL` conceptual condition only; it does not reserve the phone unless later design proves such semantics. |
| Currently associated | Phone is the current ordinary contact/lookup association of one Profile. | Blocks every second Profile claim in the Organization. |
| Former phone under unreleased restriction | Phone is no longer the ordinary Profile association but remains unavailable under `SDP-CUST-12B`. | Blocks every new Profile/current association until authorized manual release. |
| Released / eligible for future independent admission | A documented authorized release ended the former-phone restriction. | May be evaluated like Available; release itself does not create a new association. |
| Disputed/held | A proposed consequential action is paused while evidence and approval are pending. | No disputed change/release/transfer may complete. The underlying current/former condition remains authoritative. |

The states describe business meaning, not a table, enumeration, lock, reservation, or persisted workflow.

The former-phone restriction is an Organization-scoped admission-control concern. Its only approved business effect here is to keep the phone unavailable for admission while the restriction remains unreleased. The restriction does not grant authority to identify, discover, view, or retrieve the formerly associated Customer/Profile, and it must not become a source for ordinary lookup, duplicate identity matching, identity restoration, or re-identification.

Restricted Identity Evidence is a separate, optional, purpose-dependent concept governed by `SDP-CUST-A2`; it is not assumed to store or enforce the former-phone restriction. The minimum information and technical mechanism needed to enforce admission blocking remain `REQUIRES TECHNICAL DESIGN`, `REQUIRES SECURITY REVIEW`, and `REQUIRES LEGAL/PRIVACY REVIEW`. WP4.2 selects no identifier, hashing, encryption, index, physical store, or persistence topology for either concept.

### 7.2 Proposed transitions

| From | Business action | To | Classification and condition |
|---|---|---|---|
| Available | Begin admission evaluation | Candidate | `PROVISIONAL`; may be transient and creates no guaranteed reservation. |
| Candidate | Successful creation/change admission | Currently associated | `DOMAIN DESIGN PROPOSAL`; only one accepted association may result. |
| Candidate | Validation/conflict/authority failure | Available or prior authoritative condition | No association or release occurs. Durable failure record remains unresolved. |
| Currently associated | Successful controlled phone change | Former phone under unreleased restriction | `OWNER-APPROVED BUSINESS POLICY` for the Inactive case under `SDP-CUST-16`: old phone becomes former, new phone becomes current, and Profile lifecycle remains Inactive. Exact technical coordination remains `REQUIRES TECHNICAL DESIGN`. |
| Currently associated | Effective controlled anonymization | Former phone under unreleased restriction | `OWNER-APPROVED BUSINESS POLICY`: the ordinary phone association is removed and the phone remains unavailable for new admission until documented authorized manual release. The restriction's representation/persistence and the transition's coordination, atomicity, concurrency, recovery, and consistency mechanisms remain `REQUIRES TECHNICAL DESIGN`. |
| Currently associated | Profile becomes Inactive | Currently associated | Inactivation does not release or reassign phone. |
| Former restriction | Complete documented authorized manual release | Released / eligible | Investigation, a hold, or Owner review alone does not change eligibility. Completed release ends admission blocking only; it does not restore identity, create a Profile, or transfer history/value. |
| Released / eligible | Later independent admission succeeds | Currently associated | A new association is evaluated under all then-current rules; it does not restore the former identity. |
| Any condition | Dispute raised about a consequential action | Underlying condition plus held control | No automatic state correction; evidence and approval determine a later outcome. |

`OWNER-APPROVED BUSINESS POLICY`: effective anonymization removes the ordinary phone association, does not automatically release the former phone, and leaves that phone unavailable for new admission until documented authorized manual release. Manual release ends admission blocking only; it does not restore identity or create a new association. These boundaries follow `SDP-CUST-04`, `SDP-CUST-10`, `SDP-CUST-12B`, and `SDP-CUST-A2` and do not require another Owner approval.

`DOMAIN DESIGN PROPOSAL` / `REQUIRES TECHNICAL DESIGN`: “Former phone under unreleased restriction” is a conceptual outcome, not an approved persistence representation. How successful phone change or effective anonymization establishes and enforces that outcome—including representation, persistence, storage relationship, coordination, atomicity, concurrency, recovery, and consistency mechanisms—remains unapproved.

## 8. Controlled phone change

### 8.1 Business process

1. receive a phone-change request without treating possession of either phone as identity proof;
2. verify the Customer/requester using separately approved evidence;
3. normalize and validate the proposed new phone under `SDP-CUST-03`;
4. evaluate Organization-wide admission against current associations and unreleased former restrictions;
5. obtain the `SDP-CUST-12A` decision: appropriately scoped Branch Manager for ordinary verified cases; Owner for disputed, exceptional, or cross-scope cases;
6. revalidate all business preconditions at the completion point;
7. complete one business outcome in which the old phone becomes formerly restricted and the new phone becomes current;
8. preserve only the minimum audit/provenance necessary for the documented legitimate purpose, including accountable actor, verifier, authority, scope, decision, and outcome evidence, without treating audit as an ordinary phone lookup or unrestricted reversible Profile-to-phone mapping; and
9. on failure or dispute, keep the authoritative prior association/restriction unchanged and hold/escalate as required.

Steps express business sequencing, not an API, command, transaction, lock, or storage design.

`OWNER-APPROVED BUSINESS POLICY`: this process may run for an Inactive Profile under `SDP-CUST-16`. Success leaves the Profile Inactive; it is not reactivation. Failure leaves the previous phone association current and permits no partial accepted business outcome.

### 8.2 Outcome matrix

| Condition | Business outcome | Must remain true |
|---|---|---|
| New phone invalid | Reject change. | Old phone remains current; no new association/restriction is created from the failed change. |
| New phone already associated | Reject or hold for manual investigation using non-disclosing outcome. | Existing holder is unchanged and undisclosed; old phone remains current. |
| New phone has unreleased former restriction | Reject or hold for authorized investigation. A hold is not permission to bypass the restriction, and investigation or Owner review alone does not make the phone eligible. | The documented authorized manual-release process under `SDP-CUST-12B` must first complete. Release only ends admission blocking; a subsequent phone-change request must independently satisfy every applicable validation, verification, authorization, and Organization-wide admission requirement. The old phone remains current unless that later request succeeds. |
| Verification insufficient | Reject/hold pending permitted evidence. | No phone state changes; phone knowledge alone proves nothing. |
| Disputed ownership/carrier reassignment | Hold and escalate under `SDP-CUST-13`. | No automatic transfer, release, merge, deletion, or value movement. |
| Owner approval required but absent | Do not complete. | Prior authoritative state remains. |
| Profile becomes Anonymized before completion | Ordinary phone-change request cannot complete; controlled anonymization outcome governs. | No new phone association restores or survives as ordinary identity data. |
| Profile is or becomes Inactive before completion | Revalidate verification, authority, phone validation, admission, and all other current preconditions. The change may complete under `SDP-CUST-16` only if they still hold. | Success changes the phone association while the Profile remains Inactive. Failure leaves the previous phone current; no automatic reactivation or partial accepted outcome occurs. |
| Concurrent request targets same new phone | At most one request may produce the accepted current association. | Other request receives a non-disclosing conflict/hold outcome. |
| Failure before full business outcome | No half-completed accepted outcome is allowed as the intended domain result. | Exact rollback/recovery/reconciliation mechanism remains technical design. |

`UNRESOLVED`: which evidence expires while a request is pending and whether an interrupted approval must be resubmitted.

## 9. Former-phone restriction and manual release

### 9.1 Purpose and beginning

The restriction is an Organization-scoped admission-control concern whose purpose is to prevent premature phone reuse and duplicate admission after a phone leaves the ordinary Profile. It begins when an approved business operation removes a current association—proposed here for successful phone change and required for effective anonymization—and continues until documented authorized manual release.

It is not Customer identity evidence, Profile visibility, or authorization. It prevents a phone from being admitted again while unreleased, but supplies no authority to identify, discover, view, or retrieve a formerly associated Customer/Profile. It must not support ordinary lookup, duplicate identity matching, identity restoration, or re-identification.

Restricted Identity Evidence is a separate concept governed by `SDP-CUST-A2`. When legitimately retained, it remains purpose-limited and must not support ordinary phone lookup, duplicate matching, marketing, identity restoration, or re-identification. WP4.2 does not assume that Restricted Identity Evidence stores or enforces the former-phone restriction. The minimum information and technical mechanism needed for admission blocking, and whether either concept needs separate physical storage, remain later technical/security/privacy design; no identifier, hashing, encryption, index, or persistence topology is selected here.

### 9.2 Investigation and release

| Concern | Business boundary |
|---|---|
| Investigator | Branch Manager may investigate only within authorized scope, gather evidence, and propose an outcome. Cross-Brand evidence is not automatically visible. |
| Consequential approval | Owner approves release or other consequential phone-association outcome under `SDP-CUST-13`. No generic role title or phone possession suffices. |
| Evidence | Preserve only the minimum request, investigator, scope, evidence provenance, proposed outcome, Owner decision, reason, time, and result facts required by a documented legitimate purpose. A protected subject or phone reference may be retained only when separately justified and governed; it must not make ordinary provenance a reversible Customer/Profile-to-phone mapping. |
| Dispute/carrier reassignment | Hold and escalate. Carrier reassignment alone does not automatically release, transfer, or establish Customer identity. |
| Rejection | Restriction remains; record the decision/provenance under later approved audit policy. |
| Investigation or Owner review | May support a later authorized release decision, but does not by itself end the restriction or make the phone eligible. A hold never bypasses admission control. |
| Release | Complete the documented authorized manual-release process and end admission blocking. Do not create a Profile, associate the phone, restore identity, or transfer Orders/Loyalty/Promotions. Any later creation or phone-change request is a separate admission and must pass all then-applicable validation, verification, authorization, and Organization-wide admission rules. |
| Retention/disposal | Governed by purpose, data class, legal/privacy review, and `SDP-CUST-14`; no fixed duration or status-triggered purge. |

There is no fixed quarantine period, elapsed-time release, automatic release, or transfer to another Profile.

## 10. Anonymization interactions

### 10.1 Business outcome

Anonymization is an explicit controlled transition after request and authority verification. Once effective:

- the Profile is Anonymized and terminal for ordinary operations;
- ordinary Profile data no longer identifies the Customer;
- the phone association is removed from the ordinary Profile;
- the phone remains unavailable through an unreleased former-phone restriction until manual release;
- Orders and Purchase History remain owned by Ordering and are not automatically deleted;
- Loyalty balance/ledger are preserved and redemption/new Customer-specific benefits are frozen under `SDP-CUST-01`;
- successfully redeemed Promotion benefits remain historical events; necessary Promotion history/provenance is preserved, while unredeemed Customer-specific Promotion benefits are frozen and cannot be redeemed, transferred, or enabled through identity restoration under `SDP-CUST-17`;
- public or non-Customer-specific Promotions are not automatically affected by anonymization, and their general eligibility rules remain independently governed;
- legally required or contractually exceptional Promotion treatment requires separate assessment and is not an automatic exception;
- downstream non-PII pseudonymous references may remain only for a documented legitimate audit, reconciliation, or historical purpose under `SDP-CUST-02`; and
- Restricted Identity Evidence is retained only when a documented legitimate purpose requires it, under controlled authorization/audit/retention, and never for ordinary lookup, duplicate matching, marketing, restoration, or re-identification.

Audit/provenance requirements do not authorize retaining an unrestricted or reversible mapping between the Anonymized Profile and its former phone. Business accountability must use only information necessary for a documented legitimate purpose. Any retained information capable of identifying or reconnecting the anonymized Customer requires separate justification and governance consistent with `SDP-CUST-A2` and `SDP-CUST-14`, including controlled authorization, purpose limitation, access audit, and retention/disposal review. This boundary does not alter the approved preservation of legitimate Order, Loyalty, or Promotion history.

### 10.2 Consistency and failure boundary

`DOMAIN DESIGN PROPOSAL`: the accepted business result must not claim completion while leaving the ordinary Profile identifying, the current ordinary phone association active, required Loyalty freeze coordination absent, or unredeemed Customer-specific Promotion benefits redeemable. Conversely, failure must not silently erase identity data, release the phone, reverse a successful Promotion redemption, transfer a Promotion benefit, or partially rewrite downstream histories.

Evidence of completion must preserve accountability without turning ordinary audit records into a Customer lookup, duplicate-matching, identity-restoration, or re-identification facility. Provenance does not override the Anonymized state or independently justify a reversible Profile-to-former-phone mapping.

`REQUIRES TECHNICAL DESIGN`: whether the operation is one local atomic boundary, coordinated boundaries with durable pending/reconciliation states, or another mechanism. The design must define what “effective” means, the completion/linearization point, partial-failure detection, safe recovery, and truthful operator-visible status. WP4.2 selects no mechanism.

### 10.3 Promotion outcome invariants

The following `OWNER-APPROVED BUSINESS POLICY` invariants under `SDP-CUST-17` apply when anonymization becomes effective:

1. Successful Promotion redemptions remain historical events and are not reversed or erased solely because of anonymization.
2. Unredeemed Customer-specific Promotion benefits are frozen, cannot be redeemed afterward, and cannot be transferred to another Customer, Profile, phone, or identity.
3. Customer identity is not restored or reconstructed to enable Promotion redemption.
4. Public or non-Customer-specific Promotions are not automatically changed; their general eligibility rules remain independently governed.
5. Retained Promotion history and provenance remain purpose-limited and subject to access control and retention/disposal governance under `SDP-CUST-14` and `SDP-CUST-A2`.

These invariants approve no persistence representation, transaction boundary, concurrency, recovery, or cross-context coordination mechanism.

## 11. Organization-wide phone admission invariants

| # | Invariant and business meaning | Conditions/scope | Allowed exception | Violation consequence | Compliance evidence | Source |
|---:|---|---|---|---|---|---|
| 1 | One canonical Vietnamese mobile cannot have more than one current Profile association in one Organization. | Creation and phone change; all Brands in the Organization. | None approved. | Reject/hold later claimant; do not mutate holder. | Concurrent admission evidence and final authoritative state. | `SDP-CUST-03`, `04`, `05` |
| 2 | A phone cannot be admitted while its former-phone restriction is unreleased in that Organization. | Creation/change after prior removal. | Completed documented authorized manual release first; investigation, hold, or Owner review alone is not an exception. | Reject/hold without release or disclosure. | Restriction/release provenance plus the separately evaluated admission result. | `SDP-CUST-04`, `12B` |
| 3 | Brand does not partition the admission namespace. | Same or different Brand under one Organization. | None approved. | One request cannot be accepted merely because Brand differs. | Cross-Brand race scenarios with non-disclosing outcomes. | `SDP-CUST-04` |
| 4 | Organization-wide uniqueness and former-phone admission blocking grant no Organization-wide Profile visibility, identity evidence, or authority. | Every lookup/conflict/investigation. | Independently authorized scoped investigation only. | Fail closed/non-disclosing; record prohibited access as later policy requires. | Authorization/non-disclosure evidence. | `SDP-CUST-04`, `06`, `SCOPE-01` |
| 5 | Failed admission creates no second current association. | Validation, conflict, authorization, interruption, duplicate request. | None. | Preserve prior authoritative state; reconcile any incomplete attempt. | Final-state and failure evidence. | `SDP-CUST-04`, `05` |
| 6 | Admission/conflict never automatically merges, overwrites, reassigns, or transfers history/value/entitlement. | All duplicate and dispute outcomes. | No automatic exception approved. | Hold/reject/manual case; preserve provenance. | Before/after domain state and absence of transfer. | `SDP-CUST-04`, `05`, `13` |
| 7 | Effective anonymization does not automatically release the removed phone or authorize a reversible ordinary identity mapping. | Active/Inactive to Anonymized. | Later documented manual release affects admission blocking only; any identifying evidence requires separate `SDP-CUST-A2`/`14` justification and governance. | Former restriction remains; reject new admission; ordinary audit/evidence must not become a re-identification path. | Anonymization and proportionate restriction/release evidence. | `SDP-CUST-10`, `12B`, `14`, `A2` |
| 8 | Inactivation does not automatically release or reassign the current phone. A later controlled phone change may replace it while preserving Inactive state. | Active to Inactive; later Inactive phone change under `SDP-CUST-16`. | Separately authorized controlled phone change or release only. | Association continues to block a second claim unless an approved operation completes; phone change never reactivates the Profile. | Lifecycle/association state and controlled-change evidence. | `SDP-CUST-11`, `12A`, `12B`, `16` |
| 9 | Manual release must complete under documented authorization before a formerly restricted phone is eligible for a later independent admission. | Former restriction to Released/eligible. | None; a hold, investigation, Owner review, elapsed time, or carrier reassignment is not release. | Restriction remains until release completes; release itself creates no association. | Investigator/proposal/Owner decision/release result provenance plus separate later admission evidence. | `SDP-CUST-12B`, `13` |
| 10 | Conflict handling does not disclose another Brand, Customer, Profile, or history. | Creation, change, retry, investigation entry. | Only independently authorized scoped investigation may access allowed evidence. | Non-disclosing reject/hold; no cross-Brand read. | Safe outcome and access-control evidence. | `SDP-CUST-04`, `06`, `13`, `SCOPE-01` |

The table restates approved policies and required WP4.2 consequences. It does not approve a database constraint, lock, response code, or evidence schema.

## 12. Concurrency scenario matrix

| Scenario | Initial state and concurrent actions | Forbidden final outcomes | Acceptable final outcomes | Required invariant / business conflict | Provenance expectation | Deferred technical question |
|---|---|---|---|---|---|---|
| Two creations, same phone | Phone Available; requests A and B create Profiles concurrently. | Two accepted Profiles/current associations; cross-request disclosure. | Exactly one accepted; other safely rejected/held, or both rejected if safe failure prevents deciding. | Invariants 1, 5, 10. | Correlate both attempts/results without exposing winner to unauthorized caller. | Serialization, idempotency, rollback, durable failed attempt. |
| Different Brands, same phone | Same Organization; Brand A and Brand B request admission. | Both accepted because Brand differs; Brand/customer disclosure. | At most one accepted Organization-wide; other non-disclosing conflict/hold. | Invariants 3, 4, 10. | Preserve authoritative Organization and requesting scopes. | Ancestry resolution point and authorization contract. |
| Two phone changes target same phone | Profiles P1/P2 each retain old current phones; same new phone Available. | Both new associations; either old phone restricted when its change did not succeed. | One complete change wins and its old phone becomes restricted; loser remains unchanged; both may fail safely. | Invariants 1, 5, 6. | Each approval/precondition and final outcome. | Atomic multi-fact update, conflict detection, request identity. |
| Phone change vs anonymization | One Profile current phone X; change proposes Y while anonymization runs. | Anonymized Profile with Y current; claimed successful change plus incomplete anonymization; X/Y released silently. | Anonymization wins and no ordinary association remains, with required former restriction; or complete phone change linearizes first and anonymization then removes/restricts Y, subject to proven ordering; safe failure is allowed. | Invariants 5, 7; terminal Profile rule. | Record authoritative ordering and both outcomes. | Linearization point, coordination, recovery. |
| Phone change vs inactivation | Active Profile changes X→Y while deactivation runs. | Half-change; phone release; stale approval blindly applied after state changed; successful change reactivates the Profile. | Complete change then Inactive with Y current/X restricted; or Inactive first, followed by revalidation and either a complete `SDP-CUST-16` change that leaves the Profile Inactive or a safe failure preserving X as current. | Invariants 5, 8. | Lifecycle and change ordering, revalidation result, final Inactive state when deactivation wins first. | Consistency, atomicity, and recovery mechanism. |
| Manual release vs new creation | Phone X formerly restricted; release and creation race. | Creation succeeds before completed authorized release; a hold/review bypasses the restriction; release transfers identity/history. | Completed release linearizes first and a separately evaluated creation may then succeed, or creation sees the restriction and fails; release may fail and the restriction remains. | Invariants 2, 6, 9. | Release authority/completion time and separate admission evaluation ordering. | Atomicity/visibility and request retry. |
| Dispute resolution vs phone change | Current/disputed association; Owner resolution and ordinary change overlap. | Ordinary change bypasses hold; contradictory final associations; value transfer. | Hold blocks change until resolution, or earlier complete change is authoritative and resolution re-evaluates; no automatic merge/transfer. | Invariant 6 plus dispute hold. | Evidence, proposal, Owner decision, ordering. | Hold representation and revalidation. |
| Retry/delayed duplicate admission | Original request outcome uncertain; same or equivalent request repeats. | Second Profile/association; old phone restricted twice; contradictory success. | Replay observes original business outcome or safely conflicts without another mutation. | Invariants 1, 5, 6. | Stable request/outcome correlation if later approved. | Business request identity and idempotency retention. |
| Failure after approval | Approval recorded but change/release/anonymization not fully completed. | Approval represented as completed mutation; partial accepted final state; silent auto-retry with stale authority. | Explicit incomplete/failed outcome requiring safe recovery/revalidation, or no mutation if all-or-nothing mechanism later selected. | Invariants 5, 9 and truthful status. | Approval distinct from execution/result; failure evidence. | Atomicity, pending state, reconciliation, expiry of approval. |
| Repeated conflicting requests | Multiple requests seek same change/release with different evidence. | Last-write-wins overwrite; duplicate consequential outcomes; hidden provenance. | One authoritative outcome; later requests observe it or require a new reviewed decision. | Invariants 5, 6, 9. | Preserve each request/decision relationship subject to retention. | Deduplication semantics and correction workflow. |

WP4.2 does not select serializable transactions, row/advisory locks, unique indexes, queues, outbox, sagas, or distributed coordination. Those are mechanism categories for later comparison only.

## 13. Failure, recovery, audit, and provenance

### 13.1 Business outcomes versus technical recovery

| Condition | Business outcome | Provenance requirement | Technical work deferred |
|---|---|---|---|
| Invalid phone | Reject without changing Profile/phone state. | Safe validation outcome; raw sensitive input handling subject to security design. | Validator/source/outage implementation. |
| Authorization/approval failure | Deny or hold; prior authoritative state remains. | Actor/scope/decision reference as permitted; no protected-data disclosure. | P1/capability/session integration. |
| Duplicate/current/restricted conflict | Non-disclosing reject or manual-review hold. | Request scope and safe conflict classification; ordinary provenance must not expose an identity mapping, and access to underlying evidence remains restricted. | Conflict representation and secure investigation view. |
| Interrupted workflow | Do not claim a completed business outcome unless all required facts are consistent. | Record truthful incomplete/failure/result evidence if a durable workflow is later approved. | Atomicity, pending states, recovery/reconciliation. |
| Repeated request | Return/recover the same business outcome or safe conflict; never duplicate mutation. | Request/outcome relationship if business idempotency is approved. | Idempotency key/fingerprint/retention mechanism. |
| Dispute | Hold consequential action pending evidence and approval. | Evidence provenance, investigator, scope, proposal, Owner decision, result. | Case model, access, retention, workflow. |
| Manual correction | Use a controlled attributable correction; preserve original provenance. | Before/after, reason, authority, linked dispute/request. | Correction operations and atomic boundaries. |
| Retention/disposal review | Classify by purpose/data owner; no status-driven purge. | Purpose, authority, hold/disposition decision. | Legal periods, holds, deletion/anonymization mechanism. |

Business recovery determines what state is acceptable and what human decision is required. Technical recovery determines how storage/processes reach or prove that state after timeouts, failures, or retries. This document defines the former only and leaves the latter to later authorized design.

### 13.2 Minimum domain-level evidence categories

`DOMAIN DESIGN PROPOSAL`: later audit/provenance design should be able to distinguish:

- request identity and operation type;
- trusted actor/requester, verifier, decision-maker, and scope references where applicable;
- affected Profile reference and/or protected phone reference only to the extent separately justified by the documented purpose, without automatically preserving a reversible link between them or exposing unnecessary raw PII;
- relevant prior and resulting lifecycle/association conditions;
- validation, admission, verification, approval, conflict, hold, release, and completion outcomes;
- reason/evidence provenance appropriate to the operation;
- authoritative business time and correlation; and
- failure, rejection, incomplete, correction, and reconciliation outcomes.

Exact fields, redaction, storage, append-only controls, readers, retention, and atomic persistence remain `REQUIRES SECURITY REVIEW`, `REQUIRES LEGAL/PRIVACY REVIEW`, and `REQUIRES TECHNICAL DESIGN`.

These categories authorize neither a reversible mapping between an Anonymized Profile and former phone nor use of ordinary audit records for Customer lookup, duplicate matching, identity restoration, or re-identification. Retain only what a documented legitimate purpose requires. Any evidence capable of identifying or reconnecting the anonymized Customer must be separately justified and governed under `SDP-CUST-A2` and `SDP-CUST-14`; legitimate retention requires controlled authorization, purpose limitation, access audit, and retention/disposal governance. WP4.2 selects no period, legal basis, audit schema, storage mechanism, encryption requirement, or access-control implementation.

Promotion redemption history and provenance retained under `SDP-CUST-17` must remain sufficient for the documented legitimate audit, reconciliation, or historical purpose without becoming an identity-restoration path. Evidence must distinguish historical successful redemption from frozen unredeemed Customer-specific benefits, but this policy does not approve a data model, identifier, mapping, storage boundary, or audit mechanism.

## 14. Layered DDD implications

| Layer | Conceptual responsibility | Boundary |
|---|---|---|
| Presentation | Adapt a future authorized request, validate transport form, and return non-disclosing outcomes. | No domain transition decisions, direct persistence, client authority, or cross-Brand disclosure. |
| Application | Orchestrate creation/lifecycle/change/release/anonymization use cases; obtain trusted scope/authorization; coordinate Domain decisions and adjacent contexts; revalidate at a later-designed completion point; map typed outcomes. | No business invariant in controllers; no direct use of another context's Infrastructure; no mechanism selected here. |
| Domain | Express framework-independent lifecycle rules, phone admission invariants, dispute/hold rules, and acceptable/forbidden business outcomes after later model approval. | No Rails, Active Record, PostgreSQL, HTTP, locks, transaction library, provider SDK, or outer-layer dependency. |
| Infrastructure | Later implement Customer-owned persistence, official allocation source, audit and approved cross-context adapters behind demonstrated contracts. | No authority creation, business-policy invention, cross-context Active Record access, or persistence type leakage. |

Dependency direction follows ADR-0011:

```text
Customer Presentation ──> Customer Application ──> Customer Domain
                                  │
                                  └──> Customer-owned required contracts

Customer Infrastructure ──> Customer Domain
Customer Infrastructure ──> contracts it implements
Composition Root ──> wiring only
```

I1 may supply authoritative Brand ancestry through its approved Application contract to a future authorized adapter/consumer. It supplies neither Customer policy nor authorization.

## 15. Approved policies, proposals, and technical hypotheses

| Statement | Classification |
|---|---|
| Valid phone is mandatory for new Profile; phone is mutable contact/lookup data. | `OWNER-APPROVED BUSINESS POLICY` |
| Organization-wide admission covers current associations and unreleased former restrictions, regardless of Brand. | `OWNER-APPROVED BUSINESS POLICY` |
| Inactive may reactivate after review; Anonymized is terminal for ordinary operations. | `OWNER-APPROVED BUSINESS POLICY` |
| Inactivation does not release the phone; effective anonymization removes the ordinary phone association, does not automatically release the former phone, and leaves it unavailable for new admission until documented authorized manual release. Release ends admission blocking only and creates no new association. | `OWNER-APPROVED BUSINESS POLICY` under `SDP-CUST-04`, `10`, `11`, `12B`, and `A2`; representation and enforcement remain unapproved. |
| Manual release requires documented authorization and never restores identity/transfers history or value. | `OWNER-APPROVED BUSINESS POLICY` |
| A successful controlled phone change for an Inactive Profile makes the new phone current, makes the old phone formerly restricted, and leaves the Profile Inactive; failure preserves the previous current association with no partial accepted outcome. | `OWNER-APPROVED BUSINESS POLICY` under `SDP-CUST-16`; atomicity, concurrency, and recovery mechanisms remain `REQUIRES TECHNICAL DESIGN` |
| Every successfully created Customer Profile initially becomes Active; Active alone establishes no phone ownership/identity verification, marketing consent, authorization, or expanded Brand/Branch visibility. | `OWNER-APPROVED BUSINESS POLICY` under `SDP-CUST-15`; technical representation and implementation remain unapproved |
| Effective anonymization preserves successful Promotion redemption history, freezes unredeemed Customer-specific Promotion benefits, prohibits their later redemption or transfer, and does not restore identity to enable redemption. Public or non-Customer-specific Promotion rules remain independently governed. | `OWNER-APPROVED BUSINESS POLICY` under `SDP-CUST-17`; Promotion representation, coordination, retention mechanisms, and implementation remain unapproved |
| Shared/family use preserves one current Profile association per canonical phone in an Organization; phone sharing does not establish shared identity or permit duplicate Profiles. | `OWNER-APPROVED BUSINESS POLICY` under `SDP-CUST-18`; context only outside Candidate E, and any assisted shared-phone process remains separately unapproved |
| Orders may be created/completed without a Customer Profile; transaction phone data does not infer identity or create/retroactively attach a Customer association. | `OWNER-APPROVED BUSINESS POLICY` under `SDP-CUST-19`; context only outside Candidate E, while later optional association remains unresolved and outside WP4.2 |
| Customer-operation authority is operation-specific, scope-bound, least-privilege, and fail-closed; requester verification is distinct from operator authorization. | `OWNER-APPROVED BUSINESS POLICY` under `SDP-CUST-20`; no complete role assignment or runtime mechanism approved |
| A material held/investigative/manual-decision conflict requires a purpose-limited Customer Review Case; routine validation/duplicate rejection does not automatically create one. | `OWNER-APPROVED BUSINESS POLICY` under `SDP-CUST-21`; persistence/workflow remains unapproved |
| Ordinary Customer operations cannot restore/reconstruct an anonymized identity; exceptional evidence access/export remains separately authorized and legally/privacy reviewed. | `OWNER-APPROVED BUSINESS POLICY` under `SDP-CUST-22`; no exceptional workflow or legal conclusion approved |
| Candidate and held are persisted states. | `UNRESOLVED`; conceptual conditions only |
| Phone admission is a separate Organization-scoped consistency concern. | `DOMAIN DESIGN PROPOSAL`; concrete model/mechanism unselected |
| Former-phone restriction supplies admission blocking only; it supplies no Customer/Profile lookup, identity evidence, visibility, or authorization. | `OWNER-APPROVED BUSINESS POLICY` boundary from `SDP-CUST-04`, `12B`, and `A2`; concrete enforcement unselected |
| Restricted Identity Evidence is separate from former-phone restriction and is not assumed to store or enforce it. | `OWNER-APPROVED BUSINESS POLICY` conceptual boundary from `SDP-CUST-14` and `A2`; physical relationship and topology `UNRESOLVED` |
| Audit/provenance automatically justifies a reversible Anonymized-Profile-to-former-phone mapping. | `NOT APPROVED`; purpose-specific retention remains governed by `SDP-CUST-A2` and `14` |
| Representation/persistence of the former-phone restriction, its physical relationship to Restricted Identity Evidence, and transition coordination, atomicity, concurrency, recovery, and consistency mechanisms. | `UNRESOLVED` / `REQUIRES TECHNICAL DESIGN`; no storage topology, identifier, hashing, encryption, index, or consistency mechanism approved |
| Every failed admission creates a durable Customer Review Case. | `NOT APPROVED`; `SDP-CUST-21` requires a case only for material investigation, held dispute, or authorized manual decision |
| A specific lock, transaction, index, queue, outbox, saga, or retry mechanism is required. | `OUT OF SCOPE`; later technical comparison required |

## 16. Open decisions and dependencies

| Open matter | Classification |
|---|---|
| Assisted shared/family phone process | Core one-association policy resolved by `SDP-CUST-18`; the policy is context only outside Candidate E, and the assisted process remains `REQUIRES OWNER DECISION` and design |
| Optional later Customer association for anonymous Orders | Anonymous purchasing resolved by `SDP-CUST-19`; the policy is context only outside Candidate E, while later association remains `REQUIRES OWNER DECISION`/design and `OUT OF SCOPE` for WP4.2 |
| Exact requester/Customer verification evidence and assurance | `REQUIRES OWNER DECISION`, `REQUIRES SECURITY REVIEW`, `REQUIRES LEGAL/PRIVACY REVIEW` |
| Exact role-to-operation assignments for Profile creation, ordinary Deactivate, Reactivate, anonymization approval, and ordinary undisputed release | Deferred prerequisite under `SDP-CUST-20`; excluded from Candidate E Gate A boundary until Owner-confirmed |
| Exact field-level visibility, capability representation, and runtime authorization contract | `REQUIRES OWNER DECISION` where policy is absent, `REQUIRES SECURITY REVIEW`, `REQUIRES TECHNICAL DESIGN` |
| Existing duplicate/conflicting data remediation | `REQUIRES OWNER DECISION`, later domain/operational design |
| Official phone-allocation source, refresh cadence, stale/outage behavior | `REQUIRES TECHNICAL DESIGN`, operational/security review; failure policy may require Owner decision |
| Disputed ownership/carrier reassignment evidence | `REQUIRES OWNER DECISION`, `REQUIRES LEGAL/PRIVACY REVIEW` |
| Customer Review Case states, persistence, workflow, evidence access, and retention | Business trigger resolved by `SDP-CUST-21`; `REQUIRES LEGAL/PRIVACY REVIEW`, `REQUIRES TECHNICAL DESIGN` |
| Exceptional identity-evidence access/export | Ordinary re-identification prohibited by `SDP-CUST-22`; exception purpose, authority, legal basis, fields, recipient, and controls remain separately unresolved |
| Audit envelope, redaction, readers, atomicity, and retention | `REQUIRES SECURITY REVIEW`, `REQUIRES LEGAL/PRIVACY REVIEW`, `REQUIRES TECHNICAL DESIGN` |
| Legal basis, purpose-specific consent, periods, holds, privacy, disposal | `REQUIRES LEGAL/PRIVACY REVIEW`; some outcomes require Owner decision |
| Restricted Identity Evidence need, ownership, controls, and physical topology | `REQUIRES OWNER DECISION` where purpose is optional; `REQUIRES LEGAL/PRIVACY REVIEW`, `REQUIRES SECURITY REVIEW`, `REQUIRES TECHNICAL DESIGN` |
| Multi-Brand participation/visibility/Loyalty/Promotion semantics | Deferred by `SDP-SCOPE-01`; `REQUIRES OWNER DECISION`; `OUT OF SCOPE` |
| Required consistency/atomicity guarantees and concurrency mechanism | Later domain refinement plus `REQUIRES TECHNICAL DESIGN` |
| Partial-completion states, recovery, reconciliation, retry/idempotency | `REQUIRES TECHNICAL DESIGN`; business-policy choices may require Owner decision |
| Customer aggregate/case/phone-admission model | Later domain design; all candidates remain `PROVISIONAL` |

ADR-0006, ADR-0008, Identity Security Review Checklist statuses, Identity Milestone 2B, P1/P2/P3, Package C, and every existing Gate/operational authorization status remain unchanged.

## 17. Impact and prerequisites for subsequent WP4 work

`OWNER-SELECTED PREPARATION SCOPE`: Candidate E is the next Gate A preparation target under the [WP-G0 Scope Charter](after_four_wp_g0_candidate_e_scope_charter.md), but remains `NOT_READY` and not Gate A-approved. Initial Profile state, Inactive phone-change eligibility, Promotion treatment after anonymization, operation-specific authority principles, material Review Cases, and the re-identification/export boundary are resolved by `SDP-CUST-15` through `SDP-CUST-17` and `SDP-CUST-20` through `SDP-CUST-22`. The approved shared-phone policy in `SDP-CUST-18` and anonymous-Order policy in `SDP-CUST-19` are context only and are not being designed, validated, or submitted through Candidate E. General Promotion eligibility, optional later anonymous-Order association, assisted shared-phone handling, exceptional identity-evidence access, and multi-Brand applicability remain independently governed and unresolved where recorded.

After those decisions, a later bounded work package may compare aggregate/case boundaries and technical consistency mechanisms. Its prerequisites are:

- Owner-reviewed WP4.1 and WP4.2 vocabulary/boundaries;
- scenario evidence for every race in §12;
- approved requester verification/capability prerequisites or explicit design gates;
- explicit exclusion of Profile creation, ordinary Deactivate, Reactivate, anonymization approval, and ordinary undisputed former-phone release from Candidate E's approval boundary until their authority policies are Owner-confirmed;
- legal/privacy/security review inputs for evidence, retention, Restricted Identity Evidence, and phone allocation; and
- explicit authorization before selecting schema, API, transaction, concurrency, audit, or recovery mechanisms.

WP4.2 does not name or authorize WP4.3, implementation, or any Gate.

## 18. Review checklist and change history

### 18.1 WP4.2 review checklist

- [x] Profile lifecycle and phone association lifecycle are independent.
- [x] Former-phone restriction and Restricted Identity Evidence remain distinct.
- [x] Inactive and Anonymized do not automatically release a phone.
- [x] Anonymization does not delete/rewrite Orders, Loyalty, or Promotion history.
- [x] Loyalty preserve/freeze is not generalized to Promotions; Promotion treatment follows the separate `SDP-CUST-17` policy.
- [x] Organization-wide admission does not grant cross-Brand visibility or authority.
- [x] All ten required phone-admission invariants are explicit.
- [x] All required concurrency scenarios identify forbidden and acceptable outcomes.
- [x] Business recovery is separated from technical recovery.
- [x] No concurrency, persistence, API, or infrastructure mechanism is selected.
- [x] Layer responsibilities follow ADR-0011.
- [x] Open Owner/legal/privacy/security/technical decisions remain open.
- [x] `SDP-CUST-18` and `SDP-CUST-19` are reflected as approved context outside Candidate E; `SDP-CUST-20` through `SDP-CUST-22` are reflected within its semantic scope without selecting implementation mechanisms or inventing role assignments.
- [x] No implementation or Gate/operational authorization is claimed.

### 18.2 Change history

| Date | Change | Classification |
|---|---|---|
| 2026-11-16 | Initial WP4.2 lifecycle and phone-admission consistency proposal. | `DOMAIN DESIGN PROPOSAL`; Owner review required. |
| 2026-11-23 | Synchronized the Owner-confirmed post-anonymization Promotion preserve/freeze policy under `SDP-CUST-17`. | `OWNER-APPROVED BUSINESS POLICY`; technical design and implementation remain unapproved. |
| 2026-11-23 | Synchronized `SDP-CUST-18` through `SDP-CUST-22` and corrected the WP-G0 Candidate E boundary so `SDP-CUST-18`/`19` remain context only. | Documentation synchronization; WP4.2 remains a proposal and Candidate E remains `NOT_READY`. |
