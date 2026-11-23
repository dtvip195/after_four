# AFTER FOUR — P1C Identity Governance and Security Preparation

**Status:** `PREPARED_FOR_OWNER_REVIEW`

**Prepared under:** `NW-OR-01` documentation/design preparation only

**Date:** 2026-11-23

**Implementation authorization:** `NOT_GRANTED`

**Identity Milestone 2B:** `UNAUTHORIZED`

**ADR-0006:** `Proposed`

## 1. Purpose and authority boundary

This package prepares the Identity/P1 governance and security decisions required by future trusted authorization consumers. It reconciles current policy, design, implementation evidence, and missing evidence without approving an authentication provider, changing a deferred decision, or authorizing implementation.

This package does not:

- accept ADR-0006 or authorize Identity Milestone 2B;
- create or approve Identity, Session, credential, MFA, role, capability, delegation, or `AuthorizationContext` code or persistence;
- authorize P1, P2, P3, Package C, a runtime consumer, a dependency, a spike, or production use;
- change `P1-OD-01` through `P1-OD-05` or `C0-R05`, `C0-R08`, and `C0-R11`;
- close an Identity Security Review Checklist item, accept residual risk, or claim independent, legal, privacy, or professional review; or
- select physical database design, endpoints, providers, cookies, deployment topology, or operational credentials.

## 2. Evidence classification

| Classification | Meaning in this package |
|---|---|
| `OWNER_CONFIRMED` | Explicit Owner policy recorded in a canonical decision source. |
| `DEFERRED` | Intentionally postponed; no replacement policy may be inferred. |
| `IMPLEMENTED_AND_OWNER_ACCEPTED_BOUNDED` | Implemented and accepted only within the exact recorded bounded gate. |
| `NOT_IMPLEMENTED` | The required runtime/control capability was not identified in the inspected repository evidence. |
| `TECHNICAL_PROPOSAL` | Reviewable design direction; not implementation authority or accepted policy. |
| `EXECUTED_OWNER_LED_EVIDENCE` | Evidence was executed and reviewed by the Owner, without independent verification. |
| `MISSING_EVIDENCE` | Required proof has not been executed or retained. |
| `OWNER_DECISION_REQUIRED` | A business/governance choice must be made explicitly by the Owner. |
| `BLOCKED` | A required decision, control, environment, or review is unavailable. |

Repository presence, a design proposal, or successful bounded I1 evidence does not establish a broader Identity control.

## 3. Governance and security inventory

| Area | Current authority/evidence | Classification | P1C consequence |
|---|---|---|---|
| Identity decisions `ID-01`–`ID-28` | Confirmed policy with stated limits in the Identity Decision Register. | `OWNER_CONFIRMED` | Preserve exact scope; none authorizes Identity implementation. |
| Identity directions `ID-29`–`ID-34` | Scoped Argon2 validation/admission directions. | `OWNER_CONFIRMED` directions; not production approval | Do not treat compatibility or capacity evidence as an approved authentication foundation. |
| Authentication/session topology | ADR-0006 proposes opaque, revocable, server-side Sessions and a same-origin cookie topology. | `Proposed` | Provider and topology selection remain outside P1C. |
| Project layering | ADR-0011 establishes project-wide Layered DDD and inward dependency direction. | `Accepted` | Identity contracts must remain framework/provider independent; Infrastructure supplies adapters. |
| P1 trusted identity/authorization | Two-stage trusted identity and target-specific authorization design, exact capability evaluation, fail-closed behavior, and revalidation. | `TECHNICAL_PROPOSAL`; `DESIGN_REVIEW_REQUIRED` | Suitable as a decision baseline, not a runtime control. |
| P1 Owner questions | `P1-OD-01`–`P1-OD-05`. | `OWNER_DECISION_REQUIRED` | Preserve identifiers and fail-closed defaults; do not invent answers. |
| Package C deferred matters | `C0-R05`, `C0-R08`, and `C0-R11`. | `DEFERRED` | Archive/Restore MFA remains unavailable; no audit-governance or retry policy may be inferred. |
| I1 Organization Scope contract | Brand ID to authoritative Organization ID only; implementation checkpoint and `AF-OWNER-002` Gate C approval recorded. | `IMPLEMENTED_AND_OWNER_ACCEPTED_BOUNDED` | Reusable ancestry evidence only. It proves no actor identity, ownership, capability, delegation, or authorization. |
| I1 verification independence | Owner-led evidence exists; independent verification was not performed. FOA and production authorization are not granted. | `EXECUTED_OWNER_LED_EVIDENCE` with explicit limits | Do not generalize I1 acceptance into system security or production readiness. |
| Runtime Identity foundation | No authenticated Session producer, ownership/role/capability/delegation store, `AuthorizationContext` provider, or runtime P1 consumer was identified. | `NOT_IMPLEMENTED` | Future implementation requires separate Gate A/B/C governance and a bounded manifest. |
| P2 Brand-scoped Catalog audit | Required contract and atomicity are designed. | `TECHNICAL_PROPOSAL`; not implemented | P1 may supply trusted authorization evidence later, but cannot claim durable audit completion. |
| P3 runtime database security | Role separation, effective privilege analysis, and operation-specific boundary are designed. | `TECHNICAL_PROPOSAL`; not implemented | Application authorization cannot substitute for database least privilege. |
| Identity Security Review Checklist | Four `OPEN`, six `BLOCKED`; no checklist control accepted. | Open/blocked | Control Acceptance cannot be inferred from documentation. |
| Password/PIN review | AF-OWNER-001 remains Owner review work; no residual risk automatically accepted. | Owner-led, non-independent | Credential implementation remains unauthorized and evidence remains bounded. |
| Professional and legal/privacy review | Prepared engagement records were not executed. | `MISSING_EVIDENCE` | Legal/privacy obligations and applicable production blockers remain unresolved. |
| Curated GitLab Gemfile research | Research accepted under `CAND-E-B01`; dependency adoption not authorized. Devise 5 is a conditional candidate only. | `OWNER_APPROVED` research only | A future comparison spike needs separate authorization and cannot start from this package. |

### 3.1 Current-state reconciliation findings

| Ref | Finding | Evidence-based correction | Required action |
|---|---|---|---|
| `P1C-REC-01` | The P1 design still says no A1 Application contract exists and that Organization has no authorized ancestry seam. | I1 now supplies an implemented, Gate C-approved Brand-to-Organization ancestry contract and Identity adapter. It supplies no ownership query or authorization meaning. | Reconcile the P1 current-state paragraphs in a separately authorized documentation change; retain the absence of ownership/authority resolution. |
| `P1C-REC-02` | The I1 design contains forward-looking historical wording that says some implemented constants/files are only proposals, while its header and gate records preserve the current status. | The I1 gate records and exact bounded manifest are authoritative. Historical sections must not be used to deny or expand the accepted implementation. | Consumers must cite the gate records and checkpoint, not isolated historical wording. No edit is made here. |
| `P1C-REC-03` | Broad historical capability questions such as Catalog administration overlap with narrower C0 Category/Variant lifecycle authority decisions. | C0 decisions govern their exact Package C lifecycle scope; they do not silently resolve broader product, price, recipe, availability, modifier, audit, refund, cash, payroll, or customer-data authority. | Build future capability decisions operation by operation and preserve unresolved BA matters. |

## 4. Authentication, authorization, and scope responsibility matrix

| Concern | Policy/design owner | Trusted input | Required responsibility | Must not do | Current state |
|---|---|---|---|---|---|
| Credential verification | Identity | Server-read credential record and submitted secret at the authentication boundary | Verify by an approved credential control and return a bounded result. | Treat client identity claims as authenticated identity; downgrade Argon2 requirements silently. | Design/evidence incomplete; implementation unauthorized. |
| Session validation | Identity | Opaque server-side Session reference under the eventual accepted topology | Establish current actor/session validity, revocation state, and applicable assurance evidence. | Trust client actor, role, Brand, capability, or expiry claims. | ADR-0006 remains `Proposed`; no producer exists. |
| `TrustedIdentityContext` | Identity Application | Output of trusted server-side identity/session validation | Carry typed actor/session facts and evidence references only for the current operation. | Become durable authority, a client DTO, or a cross-request cache. | P1 `TECHNICAL_PROPOSAL`. |
| Brand ancestry | Organization through I1 | Typed Brand reference | Resolve current persisted Brand-to-Organization ancestry. | Assert ownership, capability, authorization, or entity-to-Brand membership. | Bounded I1 implemented and Gate C approved. |
| Protected target binding | Target-owning Application context | Controlled persisted entity lookup plus authoritative ancestry | Create a trusted target binding only after verifying entity-to-Brand-to-Organization relationships. | Trust a client-supplied Brand/Organization ID as authority; disclose cross-scope existence. | P1/Package C proposal; no runtime consumer. |
| Ownership authority | Identity using an approved Organization contract/evidence source | Current, authoritative ownership relationship | Resolve exact Organization/Brand ownership basis and preserve it as authority-source evidence. | Infer ownership from generic role titles, ancestry, or deployment shape. | Representation unresolved under `P1-OD-01`; not implemented. |
| Capability assignment | Identity | Approved assignment/delegation facts | Evaluate the exact operation capability in the exact persisted scope. | Translate a generic job title into permission. | C0 principles confirmed; representation not implemented. |
| Catalog delegation | Identity | Current grant, actor, authority source, subject, scope, capability, time, and revocation facts | Enforce effective interval, revocation/non-reactivation, no retroactivity, and C0-R03 prohibitions. | Treat `Effective` grant state alone as authorization; allow onward delegation implicitly. | Design-only; `P1-OD-02`–`05` unresolved. |
| Target operation authorization | Target-owning Application through its owned outbound P1 port | Trusted target binding plus current trusted Identity evidence | Request exact P1 authorization, then revalidate after required target locks and before mutation. | Depend on Identity Infrastructure or persistence models; reuse stale authorization. | P1/Package C proposal only. |
| Step-up MFA for Archive/Restore | Identity/P1 consumer contract | Acceptable MFA evidence tied to current actor/session/operation under approved policy | Fail closed when acceptable evidence is unavailable. | Invent freshness, assurance, binding, or invalidation rules. | Requirement confirmed; details `DEFERRED` under `C0-R05`; operation blocked. |
| Catalog lifecycle audit | P2 / target operation | Trusted authorization evidence and before/after lifecycle facts | Append Brand-scoped evidence atomically with the lifecycle mutation. | Put credentials/secrets in payload; claim delegation administration uses the same store. | P2 proposal, not implemented. |
| Delegation administration audit | Identity/P1 administration boundary | Actor, authority source, subject, scope, capability, changed grant facts, effective/expiry/revocation facts, event time | Commit mutation and audit evidence together under a future approved design. | Assume the P2 Catalog AuditEvent schema or physical store. | Technical proposal; no authorized mutation set for change. |
| Database enforcement | P3 / database operations | Approved roles, ownership, grants, and deployment evidence | Separate runtime from migration/ownership authority and verify effective privilege paths. | Give ordinary Rails runtime a path to destructive/schema/platform authority. | P3 proposal; operational evidence missing. |

## 5. Security threat and gap register

| Ref | Threat or gap | Scenario | Existing boundary | Evidence gap / blocker | Smallest next milestone |
|---|---|---|---|---|---|
| `P1C-SEC-01` | Credential stuffing and password compromise | Automated login attempts reuse leaked credentials. | Password policy and Argon2 research exist; login defenses checklist item remains open. | No accepted authenticator, rate-limit evidence, breach-password decision, or production capacity proof. | Separate authentication-control design and evidence authorization after provider decision preparation. |
| `P1C-SEC-02` | Employee PIN guessing | An attacker repeatedly attempts a short shared/device-adjacent secret. | PIN decisions require independent hashing and throttling semantics. | No implemented PIN verifier, rate limiting, lock behavior, or executed abuse evidence. | Bounded PIN-control implementation proposal only after applicable gates. |
| `P1C-SEC-03` | Session theft or stale revocation | A stolen or revoked Session continues authorizing protected work. | ADR-0006 proposes opaque revocable Sessions; P1 requires current validation. | ADR remains Proposed; producer, invalidation propagation, fixation/rotation, and operational evidence absent. | ADR-0006 design-baseline review package; no acceptance by implication. |
| `P1C-SEC-04` | CSRF, cookie, proxy, and HTTPS boundary failure | A browser or spoofed proxy metadata causes an authenticated state-changing request. | Checklist and threat model identify the boundary. | Cookie attributes, CSRF contract, trusted proxy chain, and deployed HTTPS evidence remain blocked/open. | Environment-specific security design and later production-like verification. |
| `P1C-SEC-05` | Client-forged authority | A caller supplies actor, Brand, role, or capability claims. | C0-R09 and P1 require trusted server-side context and fail closed. | No runtime middleware/provider or consumer integration. | Provider-neutral trusted-context implementation proposal after authentication/session baseline. |
| `P1C-SEC-06` | IDOR and cross-Brand disclosure | A user probes an entity in another Brand and learns whether it exists. | Target-owning context must resolve persisted scope before P1 evaluation and normalize denial. | No Package C runtime entry point or non-disclosure evidence. | Later consumer-specific Gate A design and adversarial contract tests. |
| `P1C-SEC-07` | Generic-role privilege escalation | A job title is interpreted as broad authority. | Capability-specific, Brand-scoped, exact-operation evaluation is confirmed/proposed. | Capability assignment representation and several business authority decisions remain unresolved. | Owner capability decisions followed by bounded logical design. |
| `P1C-SEC-08` | Delegation escalation or self-approval | An Actor grants themselves authority, delegates onward, or relies on an unverified authority source. | C0-R02/R03/R04 fail closed; semantic Actor/authority-source/Subject distinction exists. | `P1-OD-01`–`05`, especially management assignment and approval semantics, remain unresolved. | Owner decision closure package preserving current deny defaults. |
| `P1C-SEC-09` | Expiry/revocation race | A grant expires or is revoked between initial authorization and mutation. | P1 requires revalidation after target locks and before mutation. | Clock/concurrency proof and C0-R11 retry/idempotency policy are absent. | Deterministic design review after C0-R11 is explicitly addressed or bounded out. |
| `P1C-SEC-10` | MFA evidence ambiguity | Archive/Restore proceeds with stale, weak, or unrelated evidence. | Step-up required by C0-CAT-05. | `C0-R05` deliberately defers freshness, assurance, binding, and invalidation. | Keep operations unavailable until an explicit Owner decision and evidence plan. |
| `P1C-SEC-11` | Audit loss or tampering | A lifecycle/delegation mutation commits without required evidence, or evidence is altered. | C0-R04/R07 and C0-CAT-07 require audit/atomicity; P2/P3 propose controls. | P2/P3 not implemented; readers, exports, retention, and legal hold deferred under C0-R08. | Separate P2/P3 gates plus later operational-role evidence; no retention claim. |
| `P1C-SEC-12` | Runtime database privilege escalation | Rails runtime assumes owner/migration/platform authority or bypasses controls. | P3 explicitly prohibits direct/indirect administration paths. | Roles, grants, ownership, default privileges, and production-like negative evidence absent. | Authorized P3 operational design/evidence phase, not P1C. |
| `P1C-SEC-13` | Recovery takeover | Weak owner recovery bypasses normal authentication and MFA. | Checklist identifies Owner recovery as blocked. | Recovery identity proof, cooling-off, notification, revocation, and audit policy absent. | Dedicated Owner recovery decision/design package. |
| `P1C-SEC-14` | Offboarding leaves access active | Suspended/terminated personnel retain Sessions, assignments, or delegations. | Threat model/checklist require revocation and fail-closed behavior. | Source-of-truth, propagation timing, Session invalidation, and evidence absent. | Separate offboarding/suspension governance package tied to Workforce ownership. |
| `P1C-SEC-15` | Legal/privacy overclaim | Identity/audit data is retained or exposed without approved purpose and governance. | ID-20 preserves legal/privacy obligations; C0-R08 remains deferred. | No executed qualified legal/privacy review and no approved retention/export policy. | Qualified review or explicit Owner governance decision where legally appropriate; do not infer compliance. |

## 6. Bounded logical design proposals

Everything in this section is `TECHNICAL_PROPOSAL`. It selects no provider, schema, endpoint, physical store, dependency, or deployment mechanism.

### 6.1 Preserve a two-stage trust model

1. Identity validates server-side actor and Session facts and creates a request/operation-scoped `TrustedIdentityContext`.
2. The target-owning Application context resolves the protected entity from persistence, establishes entity-to-Brand binding, and obtains authoritative Organization ancestry through the approved Organization contract.
3. The target-owning Application context creates the trusted target binding. Infrastructure supplies facts but does not grant authorization trust.
4. The target-owning Application calls its own outbound authorization port; an adapter invokes the Identity Application public contract.
5. Identity evaluates the exact capability against the exact persisted scope and current authority/delegation evidence.
6. The target-owning Application reacquires/revalidates current Identity authorization after required target locks and immediately before mutation.
7. Missing, stale, malformed, revoked, cross-scope, or unavailable evidence fails closed without disclosing protected target existence.

The Composition Root wires implementations only. Domain and Application code must not depend on Active Record, provider SDKs, or another context's Infrastructure records.

### 6.2 Use I1 only for ancestry

I1 may satisfy the Brand-to-Organization ancestry input once a future consumer is authorized and wired. The successful I1 result must never be promoted into ownership, actor identity, capability, delegation, or authorization evidence. A separate approved Organization Application contract is still required for any ownership facts consumed by P1.

### 6.3 Keep authority-source evidence explicit

Actor, Grantor/authority source, and Subject are distinct semantic roles. Actor and the human exercising an authority source may be the same only when the independent basis of authority is currently verified. A role title or Actor ID alone is not an authority source. Subject remains the delegation recipient, and C0-R03 continues to prohibit self-delegation/self-approval. This proposal does not answer `P1-OD-05`.

### 6.4 Separate lifecycle audit from delegation audit

P2 governs future Catalog lifecycle audit evidence. Identity delegation administration requires its own reviewed operation boundary and audit contract. Either may later share infrastructure only after explicit design review; P1C does not select a common table, event transport, or retention policy.

### 6.5 Keep the authorization contract provider-neutral

The P1 Application contract should consume typed trusted facts and return bounded outcomes, not Devise objects, controller state, cookies, Active Record records, or provider exceptions. This permits authentication/session implementation evidence to evolve without moving authorization policy into Presentation or Infrastructure.

## 7. Cross-domain Identity interfaces

| Producer / owner | Consumer | Minimum logical contract | Prohibited inference | Dependency/status |
|---|---|---|---|---|
| Organization Application (I1) | Identity Application adapter | Brand ID to authoritative Organization ID, bounded outcomes | Ownership, role, capability, or permission | Implemented/accepted bounded; runtime consumer absent. |
| Organization Application (future ownership seam) | Identity Application | Current Organization/Brand ownership evidence and stable authority-source reference | Ownership from ancestry or role title | Not designed/authorized; depends on `P1-OD-01`. |
| Identity Application | Target-owning Application adapter | Current trusted identity and exact target-specific authorization result | Durable/cached authority or client claims | P1 proposal; no implementation. |
| Catalog Application | Identity/P1 | Trusted entity-to-Brand-to-Organization target binding and exact lifecycle capability | Brand ID alone proving entity membership | Package C/P1 proposal; not implemented. |
| Identity delegation administration | Audit boundary | Atomic grant/change/revoke evidence with Actor, authority source, Subject, scope, capability, facts, and time | P2 Catalog AuditEvent schema or approved retention | Proposal; `P1-OD-02`–`05` and C0-R08 dependencies. |
| Catalog lifecycle Application | P2 audit append boundary | Brand-scoped operation, authorization evidence, entity, before/after, reason, MFA reference where applicable | Credential/secret payload or delegation-admin semantics | P2 proposal; C0-R05/R08 dependencies. |
| Deployment/database security (P3) | Identity and protected consumers | Least-privilege runtime boundary and operation-specific database access | Application authorization compensating for owner/admin privileges | P3 proposal; operational evidence absent. |
| Future Customer, Order/Payment, Cash, Workforce, Reporting consumers | Identity Application | Consumer-owned outbound port for exact protected operation and authoritative target scope | Shared Identity ownership of domain policy or broad generic role authority | Consumer-specific decisions/design required; none authorized here. |

No row authorizes shared persistence, direct cross-context record access, a synchronous transaction, an event transport, or a public API.

## 8. Owner decisions and prerequisites

### 8.1 Existing Owner decisions still required

| Decision | Exact unresolved matter | Safe state until decided | Dependency |
|---|---|---|---|
| `P1-OD-01` | Representation of Brand Owner authority versus Organization ownership scoped to a Brand. | No Brand Owner authority is materialized without approved evidence. | Ownership seam and all owner-based authorization. |
| `P1-OD-02` | Who grants/revokes delegation-management capability and whether it can be granted onward. | Direct verified owners only; onward management grant denied. | Delegation administration. |
| `P1-OD-03` | Mutable facts of a live/future Catalog Delegation Grant. | `ChangeCatalogDelegation` has no executable mutation set. | Change use case and audit contract. |
| `P1-OD-04` | Maximum Catalog delegation duration. | Infer neither unlimited duration nor an invitation-derived limit. | Grant validation and expiry policy. |
| `P1-OD-05` | Separate approver requirement and exact self-approval semantics. | Deny self-delegation/self-approval; invent no workflow. | Delegation approval design. |

These identifiers and statuses remain unchanged.

### 8.2 Deferred decisions that remain deferred

| Decision | Deferred matter | Current effect |
|---|---|---|
| `C0-R05` | MFA freshness, assurance, Session binding, and invalidation | Archive/Restore remains unavailable. |
| `C0-R08` | Audit retention, legal hold, reader authorization, and export governance | No production audit-governance or compliance conclusion. |
| `C0-R11` | Advanced retry and idempotency policy | No automatic retry/backoff/replay behavior may be selected. |

P1C does not request implicit reopening. The Owner must explicitly authorize any later decision process.

### 8.3 Temporary P1C proposal reference

| Temporary ref | Decision for later Owner review | Options | Recommendation | Status |
|---|---|---|---|---|
| `P1C-OD-01` | Whether to authorize a bounded Devise-versus-custom authentication compatibility/design spike after its manifest and evidence protocol are reviewed. | A — authorize the bounded spike; B — defer pending ADR-0006/security inputs; C — stop Devise evaluation and prepare a custom-only proposal. | A is supportable only as an evidence-gathering step after the prerequisites in §9 are approved. It selects neither candidate. | `PROPOSED_FOR_OWNER_DECISION`; not a canonical ODB ID; no authorization granted. |

### 8.4 Other prerequisites

| Prerequisite | Type | Required before | Current state |
|---|---|---|---|
| Reconcile P1 current-state text with bounded I1 implementation | Documentation | P1 Gate A request | Not done by this package. |
| ADR-0006 design-baseline review scoped to the intended authentication/session slice | Governance/design | Authentication implementation proposal | `Proposed`; not accepted. |
| Exact bounded authentication foundation scope and file/evidence manifest | Governance | Any spike or Gate B request | Missing. |
| Authentication/session threat-control acceptance criteria | Security design | Spike execution and later implementation review | Checklist remains open/blocked. |
| P1 Owner decisions applicable to the requested consumer | Owner policy | P1 implementation | Unresolved. |
| Consumer-specific target, capability, non-disclosure, and revalidation contract | Technical design | Consumer implementation | Package C proposal exists; no runtime authorization. |
| P2/P3 bounded designs and implementation gates | Technical/operational | Catalog lifecycle production readiness | Designs only. |
| Independent security verification plan | Security governance | Any claim requiring independence | Not performed/authorized. |
| Qualified legal/privacy review or documented applicable governance | Legal/privacy | Production handling of Identity/audit data | Not performed. |
| FOA and Production Authorization | Governance | Production use | `NOT_GRANTED`. |

## 9. Devise-versus-custom spike recommendation

### 9.1 Is a future spike justified?

**Recommendation:** a future bounded spike is justified as an evidence-gathering option, but it must not be initiated or treated as a provider selection now.

The research establishes a real uncertainty: Devise 5 may supply maintained authentication primitives, but its standard database authentication depends on bcrypt while AFTER FOUR's reviewed credential direction is Argon2id. It also does not solve opaque server-side Session topology, P1 authorization, capability/scope evaluation, delegation, PIN security, MFA policy, or revocation semantics. A code-free comparison cannot determine whether required overrides would preserve enough value to justify adoption.

### 9.2 Minimum authorization package for a later spike

A later authorization should name:

- the exact isolated files/environment and confirmation that no project dependency file or production code is modified;
- exact Ruby 3.4.12, Rails 8.1.x, PostgreSQL, and API-only runtime assumptions;
- candidate versions and native/runtime dependencies;
- JSON/API behavior, cookie/CSRF behavior, opaque server-side Session compatibility, logout/revocation, and failure mapping;
- Argon2id integration proof, including proof that credential verification cannot silently fall back to bcrypt;
- recovery, confirmation, mailer, redirect, and generated-route behavior relevant to an API-only application;
- override count and maintenance surface rather than a feature-count comparison;
- bounded security tests and raw retained evidence, with no claim of production readiness;
- a custom baseline implementing only the same approved semantic surface for fair comparison; and
- cleanup, stop conditions, and an explicit no-adoption/no-implementation statement.

### 9.3 Decision rule after evidence

Devise should remain a candidate only if the spike shows that AFTER FOUR can retain its approved credential/session/security contracts without extensive framework overrides or hidden bcrypt behavior. A custom foundation should remain a candidate only if the same evidence shows a smaller, auditable surface with acceptable maintenance and security ownership. The Owner must select, defer, or reject candidates in a later decision. P1C selects none.

## 10. Recommended sequence

1. Review and either accept or correct this inventory and the reconciliation findings.
2. Decide whether to prepare explicit Owner closure for `P1-OD-01` through `P1-OD-05`; do not bundle unrelated answers.
3. Decide whether and when to reopen the deferred C0 matters through their own governance process.
4. Reconcile the P1 current-state description with I1 without changing I1's ancestry-only meaning.
5. Prepare an ADR-0006 design-baseline review and bounded threat/control acceptance criteria.
6. If the Owner selects `P1C-OD-01` Option A, prepare a separate exact spike authorization; do not execute the spike from this package.
7. Use spike evidence, not library reputation, to prepare the authentication-foundation Owner decision.
8. Prepare consumer-specific Gate A designs and later bounded Gate B manifests independently.
9. Require applicable Control Acceptance, independent/operational evidence, FOA, and Production Authorization before production use.

## 11. Review and exit criteria

P1C is ready for Owner review when:

- confirmed policy, deferred policy, design proposal, implementation evidence, and missing evidence remain distinguishable;
- I1 is represented as implemented/accepted ancestry evidence without being promoted to ownership or authorization;
- every protected operation evaluates an exact capability against authoritative persisted scope;
- generic roles and client claims are never authority;
- all `P1-OD` and deferred C0 matters retain their current statuses;
- the spike recommendation remains a recommendation requiring a separate authorization; and
- no statement implies ADR acceptance, Milestone 2B, implementation, residual-risk acceptance, FOA, or Production Authorization.

Completion of this document is a governance/security preparation checkpoint only.

## 12. Sources

### Canonical governance and architecture

- [Owner Decision Baseline](../architecture/after_four_owner_decision_baseline.md)
- [Identity Decision Register](../architecture/after_four_identity_decision_register.md)
- [Foundation Decisions](../architecture/after_four_foundation_decisions.md)
- [DDD Foundation](../architecture/after_four_ddd_foundation.md)
- [ADR-0006 — Authentication and Session Topology](../architecture/adr/0006-authentication-session-topology.md)
- [ADR-0011 — Project-wide Layered DDD](../architecture/adr/0011-project-wide-layered-ddd.md)
- [Next-Wave Execution Plan](after_four_next_wave_execution_plan.md)

### Identity, authorization, and security

- [Identity Technical Design](../architecture/after_four_identity_technical_design.md)
- [Identity and Branch Authorization](../architecture/after_four_identity_authorization.md)
- [P1 Trusted Identity / Authorization Design](../architecture/after_four_p1_trusted_identity_authorization_design.md)
- [Identity Security Review Checklist](../architecture/after_four_identity_security_review_checklist.md)
- [Identity Security Review Results](../architecture/after_four_identity_security_review_results.md)
- [Security Threat Model](../architecture/after_four_security_threat_model.md)
- [P2 Brand-scoped Catalog AuditEvent Design](../architecture/after_four_p2_brand_scoped_catalog_audit_event_design.md)
- [P3 Runtime Database Security Design](../architecture/after_four_p3_runtime_database_security_design.md)

### Bounded evidence and research

- [I1 Organization Scope Contract Design and gate records](../architecture/after_four_i1_organization_scope_contract_design.md)
- [AF-OWNER-002 I1 Gate C Evidence](../architecture/security-reviews/owner-led/af-owner-002-i1-organization-scope-gate-c-evidence.md)
- [AF-OWNER-002 I1 Gate C Decision](../architecture/security-reviews/owner-led/af-owner-002-i1-organization-scope-gate-c-decision.md)
- [Curated GitLab Gemfile Reference Review](after_four_gitlab_gemfile_reference_review.md)

The bounded implementation evidence was also inspected under `backend/app/domains/identity/` and `backend/app/domains/organization/` only to determine current seam availability. No application or database command was executed.
