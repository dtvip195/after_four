# AFTER FOUR — Customer Domain Boundary and Responsibilities

**Work package:** WP4.1

**Document status:** `DOMAIN DESIGN PROPOSAL`

**Owner-approved inputs:** `SDP-CUST-01` through `SDP-CUST-22`, including `SDP-CUST-12A` and `SDP-CUST-12B`; `SDP-CUST-A2`; `SDP-SCOPE-01`

**Technical design approval:** `NOT_GRANTED`

**Implementation authorization:** `NOT_GRANTED`

**Gate A / Gate B / Gate C:** `NOT_GRANTED` for this design

**Control Acceptance:** `NOT_GRANTED`

**Final Operational Acceptance:** `NOT_GRANTED`

**Production Authorization:** `NOT_GRANTED`

## 1. Purpose and status

This document defines a proposed business-responsibility boundary for Customer Management. It separates Customer Profile, broader Customer identity, mutable phone contact, Organization-wide phone admission control, Brand participation, Branch-scoped visibility, and transaction-specific Customer context so later design does not conflate them.

The Owner-approved policies referenced here are authoritative within their recorded scope. The boundary, relationship analysis, candidate consistency boundaries, Layered DDD mapping, and sequencing recommendations in this document are `DOMAIN DESIGN PROPOSAL` or `PROVISIONAL`; they are not additional Owner decisions.

The existing logical label “Customers, Loyalty & Promotions” is not treated as approval of one physical module, aggregate, schema, service, or final Bounded Context topology. WP4.1 defines responsibility ownership while that topology remains subject to later review.

## 2. Scope and explicit exclusions

### 2.1 In scope

- the Customer Domain mission and business responsibilities;
- boundaries between Customer, Organization, Identity, Authorization, Ordering, Loyalty, Promotions, Privacy, and Audit concerns;
- ubiquitous language for Customer Management;
- approved Customer business invariants and their domain-model implications;
- provisional consistency-boundary hypotheses for later design;
- conceptual Layered DDD responsibilities and inward dependency direction; and
- unresolved questions and prerequisites for later WP4 work.

### 2.2 Out of scope

- aggregate-root, entity, Value Object, repository, Domain Service, command, query, controller, DTO, event, or port finalization;
- schema, table, column, index, constraint, lock, transaction, outbox, retry, reconciliation, encryption, hashing, or persistence design;
- API routes, payloads, responses, error codes, frontend behavior, or public contracts;
- authentication, Session, MFA, authorization, capability, or delegation implementation;
- phone-allocation source selection, normalization code, or refresh/failure mechanism;
- Restricted Identity Evidence physical topology;
- legal interpretation, compliance conclusion, retention duration, legal-hold procedure, or disposal mechanism;
- multi-Brand Customer participation or behavior;
- WP4.2 or later implementation; and
- Gate A/B/C, Control Acceptance, Final Operational Acceptance, Production Authorization, or production use.

## 3. Sources, authority, and current-state evidence

### 3.1 Authoritative business-policy sources

- [Owner Decision Baseline](after_four_owner_decision_baseline.md#5a-production-mvp-customer-loyalty-and-promotions-scope)
- [Customer Management Owner Decisions](after_four_customer_management_owner_decisions.md)
- [SDP-CUST-01 Owner Decision](after_four_sdp_cust_01_owner_decision.md)
- [SDP-CUST-02 Owner Decision](after_four_sdp_cust_02_owner_decision.md)
- [SDP-SCOPE-01 Owner Decision](after_four_sdp_scope_01_owner_decision.md)
- [WP-G0 Candidate E Scope Charter](after_four_wp_g0_candidate_e_scope_charter.md)
- [Business Domain Model §11](after_four_business_domain_model.md#11-customers-loyalty-and-promotions)

### 3.2 Architecture and governance sources

- [ADR-0011 — Project-wide Layered DDD](adr/0011-project-wide-layered-ddd.md)
- [DDD Foundation](after_four_ddd_foundation.md)
- [Foundation Decisions](after_four_foundation_decisions.md)
- [Catalog Core Technical Design](after_four_catalog_core_technical_design.md)
- [Package C Technical Design](after_four_package_c_technical_design.md)
- [I1 Organization Scope Contract Technical Design](after_four_i1_organization_scope_contract_design.md)
- [Identity Decision Register](after_four_identity_decision_register.md)
- [Identity Security Review Checklist](after_four_identity_security_review_checklist.md)
- [ADR-0006 — Authentication and Session Topology](adr/0006-authentication-session-topology.md)
- [ADR-0008 — Deployment Environments](adr/0008-deployment-environments.md)

### 3.3 Current-state facts and qualifications

- `OWNER-APPROVED BUSINESS POLICY`: Customer Profile, Customer phone handling, lifecycle, privacy coordination, anonymization, and the boundaries in the SDP decisions are confirmed.
- `OWNER-APPROVED BUSINESS POLICY`: `SDP-CUST-18` through `SDP-CUST-22` additionally confirm one Profile association for shared phones, anonymous Orders, operation-specific authority principles, durable material Customer Review Cases, and no ordinary re-identification.
- `OWNER-SELECTED PREPARATION SCOPE`: Candidate E is the next Gate A preparation target under the WP-G0 charter. It remains `NOT_READY` and not Gate A-approved. `SDP-CUST-18` and `SDP-CUST-19` are approved context only and remain outside Candidate E's design and approval scope.
- `VERIFIED FACT`: I1 implements only `Brand ID -> authoritative Organization ID` ancestry resolution. It is explicitly non-authorizing and has no Customer runtime consumer.
- `VERIFIED FACT`: ADR-0011 is Accepted and requires inward Layered DDD dependencies for new or modified source.
- `VERIFIED FACT`: ADR-0006 and ADR-0008 remain Proposed; Identity Milestone 2B remains unauthorized.
- `DOMAIN DESIGN PROPOSAL`: Customer Management is treated here as a distinct business-responsibility boundary even though the canonical Business Domain Model still illustrates a combined logical “Customers, Loyalty & Promotions” context.
- `UNRESOLVED`: whether the responsibility boundary becomes a separately named Bounded Context/module or remains within a larger logical context. This document does not decide that topology.

No material conflict requiring correction to another canonical document was found. Several earlier physical/API examples are already explicitly classified as superseded or unapproved by WP3.5.

## 4. Customer Domain mission

### 4.1 Mission

`DOMAIN DESIGN PROPOSAL`: Customer Management maintains the business-managed Customer Profile and the controlled business processes by which AFTER FOUR records, corrects, restricts, anonymizes, and purpose-limits Customer-related information. It protects the integrity of phone admission and Customer provenance while supplying only the minimum appropriate Customer context or reference to adjacent domains.

Customer Management does not own every fact associated with a Customer. Orders, Loyalty value, Promotion outcomes, authentication, authorization, Organization structure, and audit-platform mechanics remain owned elsewhere.

### 4.2 Required conceptual distinctions

| Concept | Meaning in this boundary | Must not be interpreted as |
|---|---|---|
| Customer | The person or business party concept about whom AFTER FOUR may hold purpose-limited records. | A User account, phone number, Loyalty Account, or Order. |
| Customer Profile | The business-managed Customer record with basic information and lifecycle state. | Permanent real-world identity proof or a container that owns all related domain history. |
| Customer identity | The broader conceptual question of continuity and identity across time, Brands, and records. | A decided multi-Brand model or synonym for Profile ID/phone. |
| Phone | Mutable contact and lookup data normalized under `SDP-CUST-03`. | Permanent identity, requester proof, authorization, or an entitlement key. |
| Phone admission control | The Organization-wide rule preventing a second current association or conflict with an unreleased former-phone restriction. | Organization-wide Profile visibility, cross-Brand participation, or identity linkage. |
| Brand participation | A possible future explicit relationship between a canonical Customer concept and a Brand. | Current approved behavior; `SDP-SCOPE-01` defers it. |
| Transactional Customer context | The reference and snapshot/context Ordering needs for one transaction while preserving its originating Branch. | Customer ownership of the Order or unrestricted access to Purchase History. |

## 5. Responsibilities owned by Customer Management

The ownership below is a domain-responsibility proposal derived from Owner-approved policy. It does not by itself select aggregates, services, storage, or integration mechanisms.

| Responsibility | Classification and rationale | Limit |
|---|---|---|
| Customer Profile lifecycle | `OWNER-APPROVED BUSINESS POLICY`: Customer owns Active, Inactive, and terminal-for-ordinary-operations Anonymized semantics under `SDP-CUST-10` and `SDP-CUST-11`. | It does not alter Loyalty, Promotion, Order, or Payment state silently. |
| Profile creation policy | `OWNER-APPROVED BUSINESS POLICY`: Customer requires a valid phone at creation; display name is optional under `SDP-CUST-07`. | It does not require every visitor or Order to have a Profile; `SDP-CUST-19` separately permits anonymous Orders and remains outside Candidate E. |
| Basic Profile information and correction | `DOMAIN DESIGN PROPOSAL`: Customer owns the meaning and controlled correction of basic Profile information because it owns the Profile and privacy coordination. | Exact editable fields, evidence, authority, and API remain unresolved. |
| Phone association | `OWNER-APPROVED BUSINESS POLICY`: Customer owns the business meaning of a current Profile phone association and treats phone as mutable contact/lookup data. | Phone is not identity proof, authorization, or an ownership credential. |
| Phone validation and controlled change policy | `OWNER-APPROVED BUSINESS POLICY`: Customer applies `SDP-CUST-03` validation and `SDP-CUST-12A` verification/authority/audit requirements to ordinary changes. | Official allocation integration, verification evidence, and capability enforcement remain later technical/security work. |
| Organization-wide phone admission | `OWNER-APPROVED BUSINESS POLICY`: Customer prevents a second claim when the canonical phone has a current association or unreleased former-phone restriction under `SDP-CUST-04`. | It must not disclose another Brand/Profile or imply Organization-wide visibility or participation. |
| Duplicate conflict and dispute handling | `OWNER-APPROVED BUSINESS POLICY`: Customer holds disputed actions, preserves provenance, supports scoped investigation/proposal, and requires Owner approval for consequential outcomes under `SDP-CUST-05` and `SDP-CUST-13`. | It never automatically merges, deletes, overwrites, reassigns, or transfers history/value. |
| Former-phone restriction and release policy | `OWNER-APPROVED BUSINESS POLICY`: Customer keeps a former phone unavailable until documented authorized manual release under `SDP-CUST-12B`. | No automatic release, fixed quarantine, identity restoration, or value transfer is approved. |
| Controlled anonymization | `OWNER-APPROVED BUSINESS POLICY`: Customer coordinates explicit verified/authorized anonymization and makes ordinary Profile operations nonidentifying under `SDP-CUST-10`. | It does not delete or rewrite downstream histories and does not determine Promotion treatment. |
| Customer privacy request coordination | `OWNER-APPROVED BUSINESS POLICY`: Customer records and coordinates controlled view, correction, processing, and anonymization requests under `SDP-CUST-09`. | Customer does not decide legal obligations or treat phone possession as requester verification. |
| Purpose limitation and retention classification | `OWNER-APPROVED BUSINESS POLICY`: Customer classifies Customer-owned data by purpose/type and participates in cross-domain classification under `SDP-CUST-08` and `SDP-CUST-14`. | It does not set universal periods or control disposal of another domain's records. |
| Customer provenance requirements | `OWNER-APPROVED BUSINESS POLICY`: controlled changes, privacy actions, disputes, release, and anonymization preserve accountable evidence. | The audit platform, immutable storage, retention, and security controls are not owned or designed here. |
| Restricted Identity Evidence boundary | `OWNER-APPROVED BUSINESS POLICY`: Customer recognizes optional purpose-dependent restricted evidence after anonymization under `SDP-CUST-A2`. | It is not an ordinary Profile, lookup source, duplicate-matching source, marketing source, restoration mechanism, or approved physical store. |
| Controlled Customer references | `DOMAIN DESIGN PROPOSAL`: Customer defines the business meaning and minimum disclosure rules of references it supplies to adjacent domains. | Receiving domains own their records and rules; integration shape and reference mechanism remain unresolved. |

## 6. Explicit non-responsibilities

| Responsibility owned elsewhere | Owning domain or concern | Customer participation without ownership |
|---|---|---|
| Order lifecycle, Order Items, confirmed commercial history, originating Branch, Payment, Refund, Preparation, and fulfillment | Ordering, Payment, Preparation, and their established contexts | Customer may supply a controlled reference or context; it cannot rewrite transaction history through Profile changes or anonymization. |
| Branch sales records and Purchase History | Ordering | Customer policy constrains Profile visibility; Ordering retains Branch provenance and enforces Purchase History scope. |
| Loyalty balance, ledger entries, accrual, redemption, adjustment, reversal, and reconciliation | Loyalty | Customer supplies reference/anonymization facts; Loyalty preserves and freezes value under `SDP-CUST-01`. Customer never edits the ledger. |
| Promotion definitions, eligibility, campaigns, benefit application, usage, or history | Promotions | Customer may supply allowed context/reference. `SDP-CUST-17` preserves redemption history and freezes unused Customer-specific benefits after effective anonymization; general Promotion eligibility and public Promotion rules remain independently governed. |
| Employee/User credentials, authentication, Sessions, MFA, recovery, or account security | Identity / Authentication | Customer Profile is not a User. A future verified requester or actor may be represented through an approved Identity boundary. |
| Organization, Brand, and Branch master data and ancestry | Organization | Customer consumes authoritative scope facts when a real use case is approved. I1 ancestry evidence is non-authorizing. |
| System-wide authorization and capability enforcement | Identity / Authorization and consuming Application boundaries | Customer states operation-specific business requirements and resource facts; trusted server-side authorization evaluates the actor and scope. |
| Legal interpretation and final legal/privacy approval | Qualified legal/privacy governance | Customer exposes data classes, purposes, requests, and proposed actions for review and obeys approved outcomes. |
| Audit platform integrity, database roles, infrastructure, persistence, encryption, and deployment | Audit/security/platform/infrastructure concerns | Customer identifies required business evidence and atomicity needs only after later approved design. |

## 7. Domain relationship analysis

### 7.1 Organization / Brand / Branch

| Question | Boundary |
|---|---|
| Customer owns | Profile policy, Customer lifecycle, phone admission and the Customer-side meaning of scoped visibility. |
| Organization owns | Organization/Brand/Branch identity, hierarchy, and authoritative ancestry. |
| May cross | Opaque Organization/Brand/Branch references and authoritative ancestry evidence through an approved Application contract. I1 currently provides Brand-to-Organization ancestry only. |
| Must not cross or be inferred | Organization persistence records, client-supplied scope as authority, Organization-wide Profile visibility from phone admission, or Brand participation from ancestry. |
| Unresolved | Exact field-level disclosure rules and capability matrix; authoritative scope resolution and enforcement contract; future multi-Brand participation and visibility semantics; and any Customer consumer of I1. |

### 7.2 Identity / Authentication

| Question | Boundary |
|---|---|
| Customer owns | Customer Profile and business handling of Customer information. |
| Identity owns | Employee/User authentication identity, credentials, Session, MFA, recovery, and trusted actor context. |
| May cross | A future trusted actor/requester reference and verification outcome required by an authorized Customer operation. |
| Must not cross or be inferred | A Profile as login identity, phone as authentication proof, Customer ID as authority, or employee Identity records as Profile data. |
| Unresolved | Whether Customers ever authenticate, requester-verification evidence, and the contract for Customer privacy requests. ADR-0006 remains Proposed. |

### 7.3 Authorization / Access Control

| Question | Boundary |
|---|---|
| Customer owns | Resource facts and business requirements: operation type, Profile scope, dispute state, and which operations require Branch Manager or Owner involvement. |
| Authorization owns | Trusted actor/session construction, role/capability/delegation evaluation, effective scope, fail-closed behavior, and non-disclosing denial. |
| May cross | An operation-specific authorization request and result containing only approved trusted references/evidence. |
| Must not cross or be inferred | Generic role title as sufficient authority, client actor/Brand/Branch claims, phone/Profile possession as authority, or cached permission from a previous request. |
| Unresolved | Exact Customer capability matrix, cross-scope semantics, verification/step-up requirements, and integration contract. |

### 7.4 Ordering

| Question | Boundary |
|---|---|
| Customer owns | The controlled Customer reference and Profile-side disclosure/lifecycle rules. |
| Ordering owns | Orders, Order Items, transaction Customer context, originating Branch, Purchase History, and historical commercial snapshots. |
| May cross | A controlled Customer or pseudonymous reference and only the minimum allowed transaction context. |
| Must not cross or be inferred | Customer ownership of an Order, Profile mutation rewriting confirmed history, anonymization deleting Orders, or basic Profile access granting cross-Branch Purchase History. |
| Unresolved | Exact optional association timing, historical access, snapshots, correction behavior, and integration contract. Anonymous Orders themselves are permitted by `SDP-CUST-19`, outside Candidate E. |

### 7.5 Loyalty

| Question | Boundary |
|---|---|
| Customer owns | Profile lifecycle and the fact that controlled anonymization became effective. |
| Loyalty owns | Loyalty Account, balance, ledger, qualification, accrual, redemption, adjustment, reversal, and reconciliation. |
| May cross | A non-PII pseudonymous reference where legitimate and an approved anonymization/freeze coordination fact. |
| Must not cross or be inferred | Customer editing Loyalty value; automatic deletion, transfer, extinguishment, reassignment, restoration, or new Customer-specific benefit after anonymization. |
| Unresolved | Integration timing/mechanism, exceptional adjustment policy, detailed cross-Brand Loyalty, and later consistency/failure handling. |

### 7.6 Promotions

| Question | Boundary |
|---|---|
| Customer owns | Allowed Profile context and disclosure/purpose constraints. |
| Promotions owns | Promotion definitions, eligibility, campaigns, benefits, usage, and Promotion history. |
| May cross | A controlled or pseudonymous Customer reference only for a documented legitimate requirement. |
| Must not cross or be inferred | Original identity for convenience, Customer control of Promotion outcomes, Loyalty freeze semantics applied to Promotions, or Organization-wide benefits from phone admission. |
| Unresolved | Promotion behavior after anonymization, participation/applicability, cross-Brand benefits, retention, and integration semantics. |

### 7.7 Privacy / Audit

| Question | Boundary |
|---|---|
| Customer owns | Customer-facing request coordination, Customer-owned data classification, business provenance requirements, and controlled anonymization policy. |
| Other concerns own | Qualified legal/privacy interpretation; each domain's retained business records; security/audit infrastructure and access controls. |
| May cross | Verified request/authority evidence, purpose and disposition decisions, allowlisted audit facts, and domain-specific actions/results. |
| Must not cross or be inferred | Raw restricted evidence into ordinary Profile reads, automatic downstream deletion, arbitrary re-identification, unbounded audit payloads, or a claim of legal compliance. |
| Unresolved | Requester verification, exact legal basis, consent, periods, holds, exports, disposal, evidence access, audit representation, and physical topology. |

The mechanisms for all boundary interactions—direct Application contract, domain fact, integration event, shared transaction, or another pattern—remain intentionally unselected.

## 8. Ubiquitous language

| Term | Definition | Owner | Important distinction / prohibited interpretation |
|---|---|---|---|
| Customer | The person or business party about whom AFTER FOUR may manage purpose-limited Customer records. | Customer Management concept | Not a User, phone, Profile ID, Loyalty Account, or Order. |
| Customer Profile | The ordinary business-managed record containing allowed basic Customer information and lifecycle state. | Customer | Not permanent identity proof and does not own downstream histories. |
| Customer lifecycle | Controlled states Active, Inactive, and Anonymized plus their approved transition semantics. | Customer | Does not silently change Loyalty or Promotions. |
| Active | Profile state available for ordinary authorized Customer operations. | Customer | Does not itself grant visibility or authority. |
| Inactive | Reversible Profile state requiring authorized review before reactivation. | Customer | Not Anonymized, deleted, or automatically eligible for purge. |
| Anonymized | Terminal Profile state for ordinary business operations after controlled anonymization. | Customer | Not proof that every downstream record is deleted, irreversible, or outside privacy law. |
| Customer phone association | Current relationship between one Profile and one canonical phone. | Customer | Phone is mutable contact/lookup data, not identity or authority. |
| Canonical Vietnamese mobile | Valid domestic mobile represented as ten digits beginning with `0` after removal of only permitted separators and official-allocation validation. | Customer policy; external allocation facts required | Not landline, foreign number, guessed repair, or regex-only validity. |
| Organization-wide phone admission control | Rule allowing at most one current Profile association or unreleased former-phone restriction for a canonical phone in one Organization. | Customer | Not Organization-wide visibility, participation, authorization, or identity linkage. |
| Former-phone restriction | Business restriction keeping a former phone unavailable until documented authorized manual release. | Customer | Distinct from Restricted Identity Evidence; not automatic quarantine or identity restoration. |
| Restricted Identity Evidence | Optional, purpose-dependent evidence retained separately after anonymization under controlled access/audit/retention. | Customer policy boundary; physical ownership unresolved | Not an ordinary Profile, lookup/duplicate-matching source, marketing source, or restoration/re-identification facility. |
| Brand participation | Potential explicit relationship governing a Customer's participation in one Brand. | `UNRESOLVED` | Future concept preserved by `SDP-SCOPE-01`; not approved current behavior or inferred from phone admission. |
| Branch-scoped visibility | Authorized access limited by operation, Brand/Branch scope, capability, and purpose; Purchase History remains Branch-scoped. | Customer policy plus Authorization/Ordering enforcement | Not unrestricted Profile access or extra update/privacy/Loyalty/Promotion capability. |
| Customer reference | Controlled opaque reference to the relevant Customer/Profile concept used at an approved boundary. | Customer defines meaning; receiving domain stores its own reference | Not identity proof, authority, or necessarily a pseudonymous reference. |
| Pseudonymous reference | Non-PII downstream reference retained only for a legitimate audit, reconciliation, or historical purpose. | Customer policy; receiving domain owns its records | Not automatically irreversible, outside privacy law, or permission to re-identify. |
| Privacy request | Controlled request to view, correct, restrict/process, or anonymize Customer data. | Customer coordinates | Phone knowledge alone is not requester verification; fulfillment is subject to domain and legal boundaries. |
| Controlled anonymization | Explicit verified and authorized operation that makes ordinary Profile operations nonidentifying. | Customer | Not inactivity automation, universal downstream deletion, phone release, or identity restoration path. |
| Customer dispute | Held conflict concerning Profile ownership, phone association, or value relationship requiring evidence, scoped investigation, and consequential Owner approval. | Customer coordinates | Not automatic merge, overwrite, deletion, or transfer. |
| Customer Review Case | Durable case for a material conflict, held disputed association, or authorized manual decision, containing purpose-limited decision provenance. | Customer policy; physical workflow ownership unresolved | Not created automatically for routine validation/duplicate rejection and not an unrestricted identity lookup. |
| Anonymous Order | Order created and completed without a Customer Profile or inferred Customer identity. | Ordering | A transaction phone does not automatically create Customer association or rewrite historical Orders. |
| Operation-specific authority | Requirement that each Customer operation has an explicit, scope-bound authorization precondition independent of generic role title or identifier possession. | Authorization policy consumed by Customer Application | Not authentication implementation, a complete role matrix, or permission inferred from Branch Manager/Owner labels. |
| Re-identification | Reconstruction or restoration of an anonymized Customer identity. | Prohibited in ordinary Customer operations | Exceptional evidence access/export requires separate authority and legal/privacy assessment; it is not an ordinary restoration path. |

These definitions are scoped to WP4.1. Updating the repository-wide `GLOSSARY.md` requires a separately reviewed canonical vocabulary synchronization after this domain proposal is accepted.

## 9. Provisional aggregate and consistency-boundary analysis

### 9.1 Customer Profile candidate

`PROVISIONAL`: Customer Profile is a candidate consistency boundary for basic information and lifecycle transitions.

- **Approved invariants it may protect:** mandatory valid phone at creation; controlled Active/Inactive/Anonymized transitions; no ordinary restoration from Anonymized; ordinary Profile is nonidentifying after anonymization.
- **Why the boundary may matter:** lifecycle and ordinary Profile state must not contradict each other after a successful operation.
- **Competing interpretation:** phone association and privacy request cases may have independent lifecycle/evidence needs and may not belong wholly inside one Profile aggregate.
- **Unresolved:** fields, identity continuity, command set, concurrency, persistence, and how anonymization coordinates with other domains.

### 9.2 Organization-wide phone admission candidate

`PROVISIONAL`: Phone admission is a separate Organization-scoped consistency concern rather than a rule safely enforceable inside one Profile alone.

- **Approved invariant it must protect:** one canonical phone has at most one current Profile association or unreleased former-phone restriction in an Organization.
- **Why the boundary may matter:** two different Profiles or a Profile and former-phone restriction can race for the same namespace entry.
- **Competing interpretations:** a dedicated claim concept, policy service, database-enforced namespace, or another model could express it; none is selected.
- **Unresolved:** consistency boundary, concurrency/serialization, conflict non-disclosure, release atomicity, allocation refresh failure, and direct-database protection.

### 9.3 Customer dispute / privacy-request candidates

`OWNER-APPROVED BUSINESS POLICY` / `PROVISIONAL DESIGN`: `SDP-CUST-21` requires a durable Customer Review Case when a conflict needs investigation, a disputed association is held, or an authorized manual decision is required. A privacy request already requires its request and status to be recorded under `SDP-CUST-09`. The aggregate, workflow, persistence, and cross-context ownership remain provisional.

- **Approved invariants they may protect:** disputed actions remain held; request status is recorded; consequential outcomes require proper authority; no automatic merge/deletion/value transfer.
- **Why the boundary may matter:** investigation and legal/authority review can outlive one request and coordinate multiple domain-owned records.
- **Competing interpretation:** these could be case records owned by a cross-cutting workflow rather than Customer aggregates.
- **Approved boundary:** routine validation failures and ordinary duplicate rejections do not automatically create durable Customer dispute cases; cases must not disclose another Customer/Brand or become unrestricted identity lookup/re-identification facilities.
- **Unresolved:** exact states, physical ownership, evidence access, retention, legal escalation, atomicity, and domain integrations.

### 9.4 Restricted Identity Evidence candidate

`PROVISIONAL`: Restricted Identity Evidence is a distinct conceptual security/privacy boundary.

- **Approved invariant it must protect:** retained evidence cannot become ordinary Profile data or support ordinary lookup, duplicate matching, marketing, restoration, or re-identification.
- **Why the boundary may matter:** its purpose, access, audit, and disposal controls differ from ordinary Profile operations.
- **Competing interpretation:** physical ownership may sit in Customer, a specialized privacy boundary, or approved infrastructure while Customer retains the policy responsibility.
- **Unresolved:** whether evidence is retained at all for each purpose, physical owner/topology, authorization, cryptography, audit, periods, legal hold, and disposal.

No candidate above is an approved aggregate root, table, repository, transaction boundary, or implementation plan.

## 10. Layered DDD responsibility mapping

| Layer | Conceptual Customer responsibility | Prohibited dependency/behavior |
|---|---|---|
| Presentation | Adapt an authorized future inbound interaction, validate transport shape, and present non-disclosing outcomes. | No domain decisions, direct persistence, client-supplied authority, or exposure of restricted/cross-Brand facts. |
| Application | Orchestrate a real Customer use case, acquire trusted scope/authorization through approved contracts, coordinate Domain behavior and adjacent contexts, define the transaction boundary after later design, and map typed outcomes. | No core business rules in controllers, no direct access to another context's Infrastructure, and no speculative command/query surface. |
| Domain | Express Customer Profile lifecycle, phone admission and dispute/privacy/anonymization business rules through framework-independent concepts once later approved design fixes the model. | No Rails, Active Record, PostgreSQL, HTTP, provider SDK, Identity Infrastructure, or outer-layer dependency. |
| Infrastructure | Implement Customer-owned persistence/external contracts, official phone-allocation adapter, audit/pseudonymization/other technical boundaries only when a demonstrated authorized use case requires them. | No creation of business authority, no cross-context Active Record access, and no leaking persistence records through Application contracts. |

Dependency direction follows ADR-0011:

```text
Customer Presentation ──> Customer Application ──> Customer Domain
                                  │
                                  └──> Customer-owned required contracts

Customer Infrastructure ──> Customer Domain
Customer Infrastructure ──> contracts it implements
Composition Root ──> wiring only
```

For a cross-context query, the consuming Application owns its required outbound port, an adapter at its Infrastructure/composition boundary invokes the provider context's public Application contract, and neither Domain depends on the other context's Infrastructure. I1 is evidence for Organization ancestry semantics, not a generic integration service and not authorization.

## 11. Approved invariants versus design hypotheses

| Statement | Classification | Consequence for later work |
|---|---|---|
| New Profile requires a valid Vietnamese mobile; display name is optional. | `OWNER-APPROVED BUSINESS POLICY` | Later design must preserve the rule without requiring all visitors to register. |
| One Organization-wide namespace covers current association and unreleased former-phone restriction. | `OWNER-APPROVED BUSINESS POLICY` | Later technical design must prove atomic admission and non-disclosing conflict handling. |
| Phone is mutable contact/lookup data, not identity or authority. | `OWNER-APPROVED BUSINESS POLICY` | Models and contracts must not key identity/permission semantics solely to phone. |
| Profile visibility and Purchase History visibility are separately scoped. | `OWNER-APPROVED BUSINESS POLICY` | Later read/capability design must not infer one from the other. |
| No automatic merge, transfer, release, restoration, or inactivity anonymization. | `OWNER-APPROVED BUSINESS POLICY` | Convenience automation cannot silently close conflict/privacy workflows. |
| Anonymized is terminal for ordinary Profile operations; Loyalty is preserved/frozen. | `OWNER-APPROVED BUSINESS POLICY` | Cross-domain design must preserve Customer and Loyalty ownership separately. |
| Customer Profile is a candidate consistency boundary. | `PROVISIONAL` | Validate through later scenarios before selecting an aggregate. |
| Phone admission needs an Organization-scoped consistency boundary separate from one Profile. | `DOMAIN-MODEL IMPLICATION` / `PROVISIONAL` | Later design must compare models and concurrency proofs; no mechanism is approved. |
| Privacy requests and disputes may be durable business cases. | `PROVISIONAL` | Later work must determine ownership, lifecycle, evidence, and authority. |
| Whether Restricted Identity Evidence requires a separate physical store. | `UNRESOLVED`; no topology approved | Do not create a store/table/module from WP4.1. |
| Customer Management is a separate deployed service or database. | `OUT OF SCOPE` and not approved | Preserve the Rails modular monolith and shared PostgreSQL baseline unless separately changed. |

## 12. Open questions and deferred work

| Open matter | Classification | Required next authority/evidence |
|---|---|---|
| Optional later Customer association for an anonymous/unregistered Order | Owner permits anonymous Orders under `SDP-CUST-19`; later association remains unresolved | Ordering/Customer authority, validation, provenance, privacy, and non-retroactive-association design. |
| Assisted shared/family phone process | Owner preserves one phone association under `SDP-CUST-18`; assisted access remains separately unapproved | Verification, accessibility, authority, non-linking, and dispute scenarios. |
| Customer/requester verification evidence | Requires later domain design plus security/legal review | Approved evidence types, assurance, failure behavior, and retention. |
| Deferred Candidate E authority operations | `SDP-CUST-20` confirms operation-specific/fail-closed principles but no invented role assignments | Explicit authority for Profile creation, ordinary Deactivate, Reactivate, anonymization approval, and ordinary undisputed release before any is included in the Gate A boundary. |
| Customer authority/verification technical contract | Requires later domain design plus P1/security review | External trusted decision, exact capability/evidence representation, non-disclosure, and fail-closed tests; no role-title inference. |
| General Promotion behavior beyond anonymization | `SDP-CUST-17` resolves only the anonymization outcome | Promotions-owned eligibility/rule/refund policy; do not derive from Loyalty freeze. |
| Exceptional identity-evidence access/export | Ordinary re-identification prohibited by `SDP-CUST-22`; exception remains separate | Qualified legal/privacy review, explicit authority, purpose, recipient, scope, controls, audit, and disposal. |
| Legal basis, consent, retention periods, legal holds, and disposal | Requires qualified legal/privacy review | Data-class and purpose-specific advice; no universal period. |
| Restricted Identity Evidence controls and physical ownership | Requires legal/privacy/security review and technical design | Purpose, need, access, audit, cryptography, retention, disposal, topology. |
| Official phone allocation source, refresh, and validation failure | Requires technical design and operational review | Authoritative source, update ownership, outage/staleness/fail-closed policy. |
| Multi-Brand participation, visibility, Loyalty, and Promotions | Deferred by `SDP-SCOPE-01`; requires separate Owner decision | Future scenarios; preserve Option C evolution without implementing it. |
| Phone admission consistency and concurrency | Requires technical/database design | Compare candidate boundaries; prove races, release/change/anonymization coordination, and rollback. |
| Customer audit representation and atomicity | Requires domain/security/technical design | Evidence taxonomy, redaction, append boundary, failure behavior, retention, reader authorization. |
| Customer Domain topology and module name | Requires later architecture review | Decide whether the responsibility boundary becomes its own Bounded Context/module. |
| Customer-facing login/account | Out of WP4.1 and unapproved | Separate product/Identity Owner decision; do not infer from Profile. |

ADR-0006, Identity Security Review Checklist statuses, Identity Milestone 2B, P1/P2/P3, Package C, and all existing Gate/operational authorization states remain unchanged.

## 13. Impact on subsequent WP4 work packages

### 13.1 Recommended next work package

`DOMAIN DESIGN PROPOSAL`: the next bounded design milestone should be **WP4.2 — Customer Profile Lifecycle and Phone Admission Consistency Model**. It should compare candidate domain/consistency boundaries and operation semantics for creation, ordinary phone change, former-phone restriction/release, lifecycle changes, and controlled anonymization without implementing them.

### 13.2 Prerequisites for WP4.2

- Owner review of this responsibility boundary and vocabulary;
- preservation of `SDP-CUST-18` one-association shared-phone policy and `SDP-CUST-19` anonymous-Order/non-inference policy as approved context outside Candidate E, without designing assisted access, later association, or Order-domain behavior;
- scenario coverage for concurrent creation/change/release/anonymization and non-disclosing cross-Brand conflicts;
- clear separation of ordinary phone admission data from optional Restricted Identity Evidence;
- continued treatment of exact capabilities, requester verification, legal duties, and physical mechanisms as prerequisites rather than assumptions; and
- a separate review gate before any aggregate, schema, API, or implementation authorization.

Later work packages may cover privacy/dispute case design, cross-domain contracts, and physical/security design, but WP4.1 does not define their numbering, approve their scope, or authorize them.

## 14. Review checklist and change history

### 14.1 WP4.1 review checklist

- [x] Customer Profile, broader identity, phone, admission control, Brand participation, visibility, and transaction context are distinct.
- [x] `SDP-CUST-01` through `SDP-CUST-22`, `SDP-CUST-A2`, and `SDP-SCOPE-01` retain their approved meaning.
- [x] Customer responsibilities and explicit non-responsibilities are documented.
- [x] Organization, Identity, Authorization, Ordering, Loyalty, Promotions, Privacy, and Audit boundaries are addressed.
- [x] Loyalty policy is not generalized to Promotions.
- [x] Phone admission is not represented as Organization-wide Profile visibility or identity proof.
- [x] Candidate aggregate/consistency boundaries are visibly provisional.
- [x] Layer responsibilities and inward dependencies follow ADR-0011.
- [x] No integration, physical topology, API, schema, or implementation mechanism is selected.
- [x] Open Owner, legal/privacy/security, and technical decisions remain open.
- [x] No Gate, Control Acceptance, operational acceptance, or production authority is claimed.

### 14.2 Change history

| Date | Change | Classification |
|---|---|---|
| 2026-11-16 | Initial WP4.1 Customer Domain boundary and responsibility proposal. | `DOMAIN DESIGN PROPOSAL`; Owner review required. |
| 2026-11-23 | Synchronized `SDP-CUST-15` through `SDP-CUST-22` and the Owner-selected WP-G0 Candidate E preparation boundary; no design/Gate approval. | Documentation synchronization; proposal status unchanged. |
