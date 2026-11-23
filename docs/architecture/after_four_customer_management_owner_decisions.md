# AFTER FOUR — Customer Management Owner Decisions

**Decision status:** `OWNER_DECIDED` / `OWNER_CONFIRMED`

**Decision dates:** 2026-11-16 (`SDP-CUST-03` through `SDP-CUST-14`, including `SDP-CUST-12A`, `SDP-CUST-12B`, and `SDP-CUST-A2`); 2026-11-23 (`SDP-CUST-15` through `SDP-CUST-17`)

**Authority:** Owner

**Canonical ODB IDs:** `ID_PENDING_OWNER_GOVERNANCE`

**Technical design approval:** `NOT_GRANTED`

**Implementation authorization:** `NOT_GRANTED`

**Control Acceptance:** `NOT_GRANTED`

**Final Operational Acceptance:** `NOT_GRANTED`

**Production Authorization:** `NOT_GRANTED`

## 1. Purpose and provenance

This register preserves the Owner-confirmed Customer Management business policies `SDP-CUST-03` through `SDP-CUST-17`, including separate decisions `SDP-CUST-12A` and `SDP-CUST-12B`, and `SDP-CUST-A2`. It complements the dedicated records for [`SDP-CUST-01`](after_four_sdp_cust_01_owner_decision.md), [`SDP-CUST-02`](after_four_sdp_cust_02_owner_decision.md), and [`SDP-SCOPE-01`](after_four_sdp_scope_01_owner_decision.md).

The local references are stable governance references pending an explicitly approved canonical `ODB-*` allocation. Their absence from an earlier repository record did not make the Owner decisions unapproved. This consolidated register avoids seventeen near-duplicate files while retaining a stable section anchor for every decision.

## SDP-CUST-03

**Vietnam-only mobile normalization.** A Customer Profile accepts only a valid Vietnamese domestic mobile number. Its canonical form is ten digits beginning with `0`; only permitted formatting separators may be removed. Invalid input must not be guessed, repaired, inferred, or fuzzy-matched. Validation must use current official Vietnamese mobile-number allocations rather than regex alone; landlines and foreign numbers are rejected. Phone is mutable contact and lookup data, not permanent Customer identity or proof of identity.

The official allocation source, refresh strategy, failure behavior, verifier, and physical representation remain technical questions.

## SDP-CUST-04

**Option A — Organization-wide phone uniqueness.** Within one Organization, one canonical Vietnamese mobile may have at most one current Customer Profile phone association or one unreleased former-phone restriction, regardless of Brand.

This is an admission-control invariant, not Organization-wide Profile visibility or authorization. It grants no cross-Brand access, Loyalty or Promotion sharing, or automatic Brand participation. A conflict must not disclose another Brand, Customer, Profile, or history. It authorizes no automatic merge, identity link, value transfer, or entitlement transfer. Physical enforcement, schema, indexes, cryptography, migration, API, and implementation remain unapproved. Broader multi-Brand Customer behavior remains deferred under [`SDP-SCOPE-01`](after_four_sdp_scope_01_owner_decision.md).

## SDP-CUST-05

**Strict duplicate prevention and manual resolution.** A second Profile must not claim a phone already held in the Organization-wide namespace. The system must never automatically merge, overwrite, delete, or reassign Profiles. Existing conflicts require documented manual investigation while preserving Orders, originating Branch, Loyalty, Promotion history, and provenance. History, balances, benefits, and entitlements must not be transferred automatically.

The exact investigation workflow and technical enforcement remain unapproved.

## SDP-CUST-06

**Shared Profile and scoped visibility.** A Customer Profile may be shared across Branches within the authorized Brand/Branch scope. A Branch Manager with appropriate scope may discover and view basic Profile information even without a transaction at their own Branch; Purchase History remains Branch-scoped. Basic Profile visibility grants no Profile update, phone change, privacy-management, Loyalty, Promotion, or other capability. Cross-Brand access is default-deny, and knowing a phone or Customer ID grants no authority.

This policy does not approve unrestricted or “system-wide” PII visibility. The exact capability matrix and authorization implementation remain unresolved.

## SDP-CUST-07

**Mandatory phone at Profile creation.** Every new Customer Profile requires a valid phone under [`SDP-CUST-03`](#sdp-cust-03). Display name is optional. No Profile may be created without a valid phone. This does not require every visitor to register or every Order to have a Customer association; anonymous or unregistered Order behavior remains unresolved.

## SDP-CUST-08

**Purpose limitation.** Every use of Customer data requires a defined legitimate purpose. A purchase does not imply marketing consent. Consent, where required, is purpose-specific, and withdrawing marketing consent does not automatically delete records retained for another legitimate purpose. Exact lawful bases and consent requirements require qualified legal/privacy review.

This decision does not claim legal or regulatory compliance.

## SDP-CUST-09

**Privacy requests.** Privacy requests require controlled processing and requester verification; knowledge of a phone alone is insufficient proof of identity or authority. The request and processing status must be recorded. Orders, Loyalty ledgers, and Promotion history must not be deleted automatically. Requests outside ordinary processing require appropriate authority or legal review.

Verification evidence, workflows, legal duties, and technical mechanisms remain unresolved.

## SDP-CUST-10

**Controlled anonymization.** Anonymization is an explicit controlled operation performed only after request and authority verification; inactivity never triggers it. Once effective, ordinary Profile operations must no longer identify the Customer. Downstream pseudonymous references follow [`SDP-CUST-02`](after_four_sdp_cust_02_owner_decision.md), and Loyalty is preserved and frozen under [`SDP-CUST-01`](after_four_sdp_cust_01_owner_decision.md). A new phone association or Profile must not automatically restore identity.

The trigger, field treatment, propagation, and implementation remain unapproved.

## SDP-CUST-11

**Customer lifecycle.** Active and Inactive transitions are controlled operations. Inactive may be reactivated after authorized review. Anonymized is terminal for ordinary business operations; only controlled anonymization may transition Active or Inactive to Anonymized. Ordinary operations, a new phone, or a new Profile cannot restore an Anonymized Profile. Customer lifecycle transitions do not silently alter Loyalty or Promotion state.

The command, authorization, state-persistence, and concurrency designs remain unresolved.

## SDP-CUST-12A

**Controlled phone changes.** A Branch Manager with appropriate authorized scope may approve an ordinary verified phone change; the Owner approves disputed, exceptional, or cross-scope cases. The Customer must be verified, the new phone validated under [`SDP-CUST-03`](#sdp-cust-03), and Organization-wide uniqueness enforced under [`SDP-CUST-04`](#sdp-cust-04). The operation must preserve audit evidence and must not silently transfer phone ownership, merge Profiles, or transfer Orders, Loyalty, or Promotion history or value.

Exact verification evidence, capability representation, workflow, and implementation remain unresolved.

## SDP-CUST-12B

**Option B — Manual former-phone release.** A former phone remains unavailable across the Organization until a documented, authorized manual release. There is no automatic release and no approved fixed quarantine period. Disputed ownership or carrier reassignment must be escalated. Retention and disposal follow [`SDP-CUST-14`](#sdp-cust-14) and applicable legal/privacy requirements. Release neither restores an old identity nor transfers historical value.

The release workflow, authority evidence, storage, and technical mechanism remain unresolved.

## SDP-CUST-13

**Dispute resolution.** A Branch Manager investigates within authorized scope, gathers evidence, and proposes an outcome. The Owner approves consequential changes to Profile ownership, phone association, or value relationships. Disputed actions remain on hold; provenance and audit evidence are preserved. There is no automatic merge, deletion, overwrite, or value transfer. Permitted outcomes include keeping records separate, correcting an erroneous phone association, authorizing release, rejecting the request, or escalation. Cross-Brand evidence is not automatically visible to a Branch Manager.

The exact evidence, capability matrix, escalation workflow, and technical design remain unresolved.

## SDP-CUST-14

**Purpose-based retention.** No universal Customer retention duration is approved. Data must be classified by type, purpose, and domain ownership, distinguishing at least ordinary Customer Profile data, Order and Purchase History, Loyalty ledger, Promotion history, audit evidence, Restricted Identity Evidence, and phone-use restriction/admission-control data. Disposal is reviewed when a purpose expires, subject to applicable law and approved policy. Inactive or Anonymized status does not itself trigger purge, and identity mappings must not be retained indefinitely for convenience.

Exact periods, lawful bases, legal holds, disposal requirements, and mechanisms remain unapproved and require qualified legal/privacy review where applicable.

## SDP-CUST-A2

**Option A2 — Restricted phone retention after anonymization.** Once anonymization becomes effective, the phone association is removed from the ordinary Customer Profile. The phone may be retained separately only for a legitimate, documented purpose. Any retained evidence belongs to a restricted identity-evidence boundary with controlled authorization, purpose limitation, access audit, and retention/disposal under [`SDP-CUST-14`](#sdp-cust-14).

Restricted Identity Evidence must not support ordinary lookup, duplicate matching, marketing, identity restoration, or re-identification and is not a second ordinary Customer Profile. Retention is optional and purpose-dependent. Its physical storage topology, schema, API, authorization implementation, retention period, and legal-compliance conclusions remain unapproved.

## SDP-CUST-15

**Initial Customer Profile Lifecycle State — Active.** After all applicable Profile-creation preconditions succeed and a Customer Profile is successfully created, its initial lifecycle state is `Active`.

`Active` records only the Profile lifecycle state. It does not mean phone ownership is verified, identity is verified, marketing consent exists, the actor or Customer has authorization, or Brand/Branch visibility expands. Phone validation, Organization-wide admission control, strict duplicate prevention, and scoped visibility remain governed by [`SDP-CUST-03`](#sdp-cust-03) through [`SDP-CUST-07`](#sdp-cust-07). Loyalty, Promotion, and Order lifecycles remain independently governed. Later Inactive and Anonymized transitions continue to follow [`SDP-CUST-10`](#sdp-cust-10) and [`SDP-CUST-11`](#sdp-cust-11), and Anonymized remains terminal for ordinary operations.

This decision selects no verification mechanism, persistence representation, command, API, transaction, concurrency control, authorization rule, or implementation. Its canonical `ODB-*` ID remains `ID_PENDING_OWNER_GOVERNANCE`, and implementation authorization remains `NOT_GRANTED`.

## SDP-CUST-16

**Phone Change While Customer Profile Is Inactive — Option A.** An Inactive Customer Profile may undergo a controlled phone change. Existing Customer-verification and authority requirements under [`SDP-CUST-12A`](#sdp-cust-12a) continue to apply, and the proposed new phone must satisfy validation under [`SDP-CUST-03`](#sdp-cust-03) and Organization-wide admission control under [`SDP-CUST-04`](#sdp-cust-04).

On successful completion, the new phone becomes the current phone association, the old phone becomes a former phone under unreleased restriction governed by [`SDP-CUST-12B`](#sdp-cust-12b), and the Profile remains `Inactive`. The phone change must not automatically reactivate the Profile. If the change fails, the previous phone association remains current and no partial accepted business outcome is permitted. Disputed or exceptional cases continue to follow [`SDP-CUST-12A`](#sdp-cust-12a) and [`SDP-CUST-13`](#sdp-cust-13).

This operation does not merge Profiles, transfer Orders, Loyalty balances, Promotion entitlements, or expand Brand/Branch visibility. `Inactive` continues to restrict ordinary Profile operations under existing policy; this decision permits only the controlled phone-change operation. It selects no new verification or authorization mechanism, persistence representation, transaction, lock, index, concurrency/recovery mechanism, API, or implementation. Its canonical `ODB-*` ID remains `ID_PENDING_OWNER_GOVERNANCE`, and implementation authorization remains `NOT_GRANTED`.

## SDP-CUST-17

**Promotion Behavior After Customer Anonymization — Option A: Preserve History, Freeze Unused Benefits.** When Customer anonymization becomes effective, Promotions preserves successfully redeemed Promotion benefits as historical events and retains only the Promotion history and provenance necessary for legitimate audit, reconciliation, and historical purposes, subject to [`SDP-CUST-14`](#sdp-cust-14). Successful redemption history is not reversed or erased solely because of anonymization, and Promotion history is not automatically deleted.

Customer-specific Promotion benefits that were granted but not redeemed at the effective anonymization point become frozen and cannot be redeemed afterward. Unused benefits must not be transferred to another Customer, Profile, phone number, or identity, and Customer identity must not be restored or reconstructed to enable redemption. Public or non-Customer-specific Promotions are not automatically affected; their general eligibility rules remain independently governed.

Retained Promotion data remains subject to purpose limitation, access control, and retention/disposal requirements under [`SDP-CUST-14`](#sdp-cust-14) and [`SDP-CUST-A2`](#sdp-cust-a2). Any legally required or contractually exceptional treatment requires separate assessment and is not an automatic exception to this policy. This decision does not approve general Promotion eligibility, cross-Brand applicability, storage, transaction, concurrency, recovery, or other implementation mechanisms; its canonical `ODB-*` ID remains `ID_PENDING_OWNER_GOVERNANCE`, and implementation authorization remains `NOT_GRANTED`.

## 2. Cross-domain ownership boundaries

- Customer Management owns Customer Profile and controlled Customer anonymization.
- Ordering owns Orders and Purchase History.
- Loyalty owns Loyalty balance, ledger, redemption eligibility, and Loyalty policy.
- Promotions owns Promotion eligibility, usage, and Promotion policy.

The Customer decisions do not authorize one domain to rewrite another domain's history. [`SDP-CUST-01`](after_four_sdp_cust_01_owner_decision.md) governs Loyalty preserve/freeze semantics, while [`SDP-CUST-17`](#sdp-cust-17) separately governs Promotion treatment after anonymization; neither policy may be generalized into the other.

## 3. Continuing unresolved matters

Anonymous or unregistered Orders; shared/family phone experience; exact requester-verification evidence; the exact Customer capability matrix; future multi-Brand participation and UX; cross-Brand Loyalty and Promotion benefits; general Promotion eligibility and applicability; re-identification workflow; lawful basis and purpose-specific consent detail; exact retention periods, legal holds, and disposal requirements; Restricted Identity Evidence storage; phone verifier/cryptography; official allocation-source refresh/failure behavior; and schema, index, API, transaction, outbox, retry, reconciliation, and production-security designs remain unresolved or unapproved.

These Owner-confirmed policies approve no technical design, schema, API, physical topology, implementation, Gate A/B/C, Control Acceptance, Final Operational Acceptance, Production Authorization, or production use.
