# AFTER FOUR — P1 Trusted Identity / Authorization Design

**Document status:** `TECHNICAL_PROPOSAL`

**Readiness:** `DESIGN_REVIEW_REQUIRED`

**Implementation authorization:** Not granted

**Identity Milestone 2B:** Unauthorized

**Evidence date:** 2026-11-15

## 1. Purpose and decision discipline

P1 defines the trusted Identity and Authorization contracts required by future Package C Category/Variant lifecycle operations. It covers server-side identity/Session validation, request-scoped trusted context, exact capability evaluation, Organization/Brand ownership scope, Catalog lifecycle delegation, authorization revalidation, and fail-closed behavior.

P1 is a design prerequisite, not an implementation milestone. It does not create Identity tables, Sessions, authenticators, role/delegation records, endpoints, cookies, MFA factors, migrations, or runtime policy. It does not accept [ADR-0006](adr/0006-authentication-session-topology.md), authorize Identity Milestone 2B, start P2/P3, or authorize Package C.

The following classifications are normative:

| Classification | Meaning |
|---|---|
| `OWNER_CONFIRMED` | Exact policy confirmed in the canonical Owner decisions. |
| `TECHNICAL_PROPOSAL` | Reviewable design choice; neither Owner policy nor implementation approval. |
| `DEFERRED` | Owner intentionally postponed the decision; no replacement may be inferred. |
| `EXTERNAL_PREREQUISITE` | Separately authorized implementation or operational evidence required by P1. |
| `OWNER_DECISION_REQUIRED` | Business/authority behavior is not settled by existing Owner decisions. |
| `NOT_IMPLEMENTED` | Repository inspection found no executing control. |

Authoritative sources are the [Owner Decision Baseline](after_four_owner_decision_baseline.md#package-c0-lifecycle-authority-and-prerequisite-decisions), [Identity Decision Register](after_four_identity_decision_register.md), [DDD Foundation](after_four_ddd_foundation.md), [ADR-0011](adr/0011-project-wide-layered-ddd.md), [Identity Technical Design](after_four_identity_technical_design.md), and [Package C Technical Design](after_four_package_c_technical_design.md).

## 2. Scope and non-goals

### 2.1 In scope

- a provider-neutral trusted identity and Session-validation contract;
- a two-stage `TrustedIdentityContext` and operation-specific `AuthorizationContext` design;
- Organization/Brand ownership and exact Catalog capability evaluation;
- conceptual Catalog delegation lifecycle and administration controls;
- separation of Actor, Grantor/authority source, and Subject;
- revalidation and authorization/revocation race requirements;
- Layered DDD responsibilities and cross-context contracts;
- fail-closed, cross-Brand non-disclosure behavior;
- prerequisite, security, acceptance, and evidence requirements.

### 2.2 Non-goals

- authentication endpoints, credentials, cookies, CSRF, account recovery, PIN, or MFA implementation;
- selection of an authentication/MFA vendor, factor, or provider;
- physical Identity, Session, Role Assignment, ownership, or delegation schema;
- changing the active role vocabulary or treating Brand Owner as a new role without an Owner decision;
- Staff-invitation delegation under Identity decision ID-14;
- P2 Brand-scoped Catalog AuditEvent design or P3 runtime database security;
- Package C lifecycle use cases, Catalog DML, public API, or Presentation contract;
- retry, idempotency, audit retention/reader/export, or exact MFA policy;
- CAT-TRR status changes or production approval.

## 3. Current-state evidence

### 3.1 Implemented repository facts

| Evidence | Verified current state |
|---|---|
| Organization reference foundation | Framework-independent Organization/Brand/Branch entities and Active Record persistence records exist under `backend/app/domains/organization/`. |
| Catalog foundation | Package B Domain and Infrastructure exist under `backend/app/domains/catalog/`; no Catalog Application or Presentation lifecycle implementation exists. |
| HTTP surface | `backend/config/routes.rb` exposes health endpoints and an unmatched `/api/v1` fallback only. |
| Identity runtime | No User, Session, Role Assignment, Branch Assignment, Catalog delegation, authentication middleware, AuthorizationContext, or authorization provider was found under `backend/app`. |
| A1 application contract | None exists. A1 intentionally has no Organization Application layer because no workflow was authorized. |
| Audit | The Phase 1 AuditEvent implementation is Branch-scoped and does not satisfy P2 or define P1 delegation-administration storage. |

Repository presence proves reference persistence only. It supplies neither authenticated identity nor ownership/capability authority.

### 3.2 Documented but not implemented

- ADR-0006 proposes opaque, revocable, server-side Sessions and remains `Proposed`.
- The Identity Technical Design proposes authorization/session interfaces and a capability catalog but explicitly leaves Milestone 2B unauthorized.
- Existing Identity capability row `catalog.change` is `BLOCKED`; it predates the later C0 decision that separately confirms Category and Variant lifecycle authority. It must not be treated as the Package C capability contract.
- The Package C design proposes eight operation-specific capability identifiers and requires a trusted AuthorizationContext, but P1 has no implementation provider.
- Organization owns Brand and Branch in the implemented A1 hierarchy. User ownership relationships and Organization/Brand Owner assignment are not implemented.

### 3.3 Terminology boundary

`Invitation Delegation` in the [Glossary](../../GLOSSARY.md) is the ID-14 Staff-invitation authority. `Catalog lifecycle delegation` is a distinct C0 concept. Neither implies the other, and their duration, subject eligibility, capabilities, and consequences must not be shared by analogy.

Within P1:

- **Actor** is the trusted person and Session actually performing an operation.
- **Grantor / authority source** is the verified basis under which a delegation is issued or administered, such as an ownership relationship or a separately granted delegation-management capability; it is not merely a role title or Actor identifier.
- **Subject** is the person receiving the delegation.

Actor, Grantor/authority source, and Subject are distinct semantic roles. Actor and Grantor/authority source may nevertheless relate to the same human when that Actor directly exercises their own verified ownership authority; the authority-source reference still identifies the ownership relationship or other verified basis, not just the human. Subject remains distinct as the delegation recipient. Nothing here resolves the separate-approver question in P1-OD-05, and all C0-R03 self-delegation/self-approval prohibitions continue to apply.

## 4. Canonical C0 traceability

### 4.1 C0-CAT decisions

| Decision | P1 obligation |
|---|---|
| `C0-CAT-01` | Authorize each Category lifecycle operation only for an Organization/Brand Owner or personnel explicitly delegated for that exact operation. |
| `C0-CAT-02` | Evaluate Variant lifecycle authority separately from Category authority. |
| `C0-CAT-03` | Bind every Catalog lifecycle delegation to one Brand and exact capability; no cross-scope inference. |
| `C0-CAT-04` | Preserve the reason-required signal for Deactivate/Archive/Restore; Package C owns reason validation. |
| `C0-CAT-05` | Require step-up MFA evidence for Archive/Restore; P1 cannot supply final acceptance semantics while C0-R05 is deferred. |
| `C0-CAT-06` | Default-deny cross-Brand access and avoid existence disclosure. |
| `C0-CAT-07` | Preserve Package C/P2 audit-failure rollback; P1 cannot weaken or bypass the consuming transaction. |
| `C0-CAT-08` | P1 grants no Default Variant switching capability through Package C. |

### 4.2 C0-R decisions

| Decision | Status | P1 obligation or boundary |
|---|---|---|
| `C0-R01` | `OWNER_CONFIRMED` | Resolve role/capability authority under the confirmed Organization/Brand ownership scope; do not invent assignment authority. |
| `C0-R02` | `OWNER_CONFIRMED` | Organization Owner administers within the Organization; Brand Owner within that Brand; onward administration requires a separately granted management capability; generic role titles grant nothing. |
| `C0-R03` | `OWNER_CONFIRMED` | Reject self-delegation and self-approval across every administration route. |
| `C0-R04` | `OWNER_CONFIRMED` | Enforce effective/expiry/revocation/non-reactivation/no-retroactivity and audit grant/change/revoke. |
| `C0-R05` | `DEFERRED` | Do not choose MFA freshness, assurance, Session binding, or invalidation semantics. Archive/Restore remains blocked, not exempt. |
| `C0-R06` | `OWNER_CONFIRMED` | P1 conveys trusted identity/authorization evidence; Package C owns the confirmed reason rules and technical canonicalization. |
| `C0-R07` | `OWNER_CONFIRMED` | P1 supplies safe authorization/delegation evidence references to P2/Package C; it does not implement the Catalog AuditEvent. |
| `C0-R08` | `DEFERRED` | Do not decide retention, legal hold, readers, or exports for P1 or P2 audit evidence. |
| `C0-R09` | `OWNER_CONFIRMED` | Produce server-trusted, fail-closed AuthorizationContext; never trust client actor/Brand/role/capability/delegation claims. |
| `C0-R10` | `OWNER_CONFIRMED` | P1 cannot substitute for P3 runtime/migration separation or the operation-specific database boundary. |
| `C0-R11` | `DEFERRED` | Do not choose retries, backoff, or command idempotency for P1/Package C races. |

## 5. Layered DDD architecture

### 5.1 Context and dependency map

Identity/Authorization owns User identity, Session validity, capability/ownership evaluation, and Catalog delegation. Organization owns Organization→Brand→Branch hierarchy and publishes the approved Application query contract for ownership and Brand ancestry. Catalog owns Category/Product/Variant, resolves a target's persisted Brand, and verifies its Organization ancestry through that published contract. These contexts communicate through explicit Application contracts; none reads another context's Active Record classes directly.

```text
Future Presentation
       |
       v
Identity Application --------------------------> Identity Domain
       |
       +---- owns/depends on --> Identity Application ports/contracts
                                  |
                                  +-- OrganizationScope port

Identity Infrastructure ----------------------> Identity Domain
Identity Infrastructure -- implements --------> Identity Application ports/contracts
Identity OrganizationScope adapter -- calls --> Organization Application published contract

Composition Root ---- wires ----> Identity Application
Composition Root ---- wires ----> Identity Infrastructure implementations

Catalog Application -- owns P1 consumer port --> P1 authorization contract
Catalog Infrastructure adapter -- implements -> Catalog-owned P1 consumer port
Catalog Infrastructure adapter -- invokes ----> Identity Application public contract
Composition Root -- wires --------------------> Catalog port + adapter implementation
Catalog Application -- calls -----------------> Organization Application published contract

Organization Application -- depends on -------> Organization Domain + Organization-owned ports
Organization Infrastructure -- implements ----> Organization-owned persistence ports
Catalog Infrastructure ------ implements -----> Catalog-owned persistence port
```

Identity Application owns the OrganizationScope port it requires and depends only on Identity Domain and Identity Application ports. Identity Infrastructure implements the OrganizationScope adapter by calling the published Organization Application contract; Organization Infrastructure does not implement an Identity-owned port. Organization Application owns its public ownership/Brand-ancestry query contract and depends on Organization Domain plus Organization-owned ports, while Organization Infrastructure implements only those Organization-owned persistence ports.

Catalog Application owns the outbound P1 authorization consumer port used by the Catalog lifecycle flow for trusted identity/Session validation, authorization, and revalidation. A Catalog Infrastructure adapter, or an explicitly defined composition-boundary adapter owned on the Catalog side, implements that port and invokes the Identity Application public contract. Identity Application publishes that contract but neither implements nor depends on the Catalog-owned port. The composition root only selects and wires implementations to ports; it does not own application behavior. Future delegation-administration use cases do not enter through the Catalog lifecycle consumer port: they require a separate Presentation/Application entry point that remains unauthorized.

Infrastructure may depend inward on Domain and the Application contracts it implements; Application and Domain never depend on Active Record, provider SDKs, or Infrastructure implementations. This is a logical in-process design inside the Rails modular monolith and does not require services, engines, a generic repository, a command bus, or empty layer classes.

### 5.2 Domain responsibilities

`TECHNICAL_PROPOSAL`: framework-independent Identity/Authorization Domain concepts own:

- stable identity references and lifecycle eligibility predicates;
- exact capability identity as a value, without role-title authorization;
- Organization/Brand authorization scope values;
- Catalog Delegation Grant invariants: exact Brand/capability/Subject/authority source, effective interval, terminal revocation, no reactivation, and replacement by a new grant;
- administration eligibility and self-delegation/self-approval rejection;
- derived delegation states such as future-effective, effective, expired, and revoked.

Domain does not parse cookies, verify token digests, query Active Record, load Catalog records, start transactions, append audit rows, know HTTP, or select MFA technology.

### 5.3 Application responsibilities

Identity Application owns real P1 use cases and orchestration:

- `ValidateSession` creates a trusted identity context from server-side Session evidence;
- `AuthorizeCatalogOperation` evaluates one exact capability against a TrustedCatalogTarget produced by Catalog's controlled persisted lookup;
- `RevalidateCatalogAuthorization` re-evaluates current identity, Session, ownership/capability, and delegation at Package C's pre-mutation point;
- `GrantCatalogDelegation`, `ChangeCatalogDelegation`, and `RevokeCatalogDelegation` coordinate policy, locking, persistence, and required administration audit evidence once separately authorized;
- safe semantic outcomes and non-disclosing denial categories.

Identity Application depends on Domain and narrow Identity-owned contracts for current time, Session/identity state, Organization ownership ancestry, assignments/ownership, delegation persistence, and administration audit append. The OrganizationScope port belongs to Identity Application; Identity Application neither knows which adapter fulfills it nor accesses Organization Active Record. It does not expose persistence records or raw authentication secrets.

### 5.4 Infrastructure responsibilities

Future Identity Infrastructure may implement:

- opaque Session verifier lookup, expiry/revocation persistence, and User lifecycle loading;
- User/ownership/assignment and Catalog delegation persistence;
- the Identity-owned OrganizationScope adapter, which calls the approved Organization Application ownership/Brand-ancestry contract and maps its result into P1 values;
- authoritative clock and transaction/locking behavior;
- delegation administration audit adapter;
- mapping to immutable Domain/Application values and safe database error translation.

Organization Application supplies the published cross-context query contract; Organization Infrastructure implements only persistence ports owned by Organization Application and never directly implements the Identity-owned OrganizationScope port. Active Record, PostgreSQL locks, cookie/session token verification, and provider SDKs remain Infrastructure. Identity never reads Organization Active Record directly. No adapter or table is authorized by this document.

Future Catalog Infrastructure, or an explicitly defined Catalog-side composition-boundary adapter, may implement the Catalog Application-owned outbound P1 authorization consumer port and invoke the Identity Application public contract. Identity Application does not implement or depend on that Catalog-owned port, and the composition root only wires the selected adapter. This adapter serves trusted identity/Session validation, authorization, and revalidation for the Catalog lifecycle flow only; future delegation-administration use cases require their own separately authorized Presentation/Application entry point.

### 5.5 Presentation responsibilities

Future Presentation may extract the opaque Session credential from the approved channel, supply request/correlation metadata, and invoke Identity Application. It treats actor, Organization, Brand, role, capability, delegation, authority source, and MFA assertions from headers/body/query as untrusted input. It returns generic authentication/non-disclosure outcomes and never constructs AuthorizationContext itself.

Presentation implementation is outside P1 design authorization.

## 6. Trusted identity and Session validation

### 6.1 Two-stage context model

P1 separates authentication from target-specific authorization:

1. `TrustedIdentityContext` proves the currently authenticated Actor/Session and Organization before protected Catalog lookup.
2. `AuthorizationContext` proves one exact operation capability for one TrustedCatalogTarget, including its persisted entity→Brand→Organization relationship, after controlled target resolution.

This separation prevents a client Brand claim from becoming authority and prevents a Session from carrying a stale, universal capability snapshot.

### 6.2 TrustedIdentityContext contract

`TECHNICAL_PROPOSAL` minimum immutable values:

| Value | Meaning |
|---|---|
| Actor reference | Stable server-resolved User identity. |
| Session reference | Stable non-secret reference; never the raw token/verifier. |
| Organization reference | Derived from current server-side User/ownership state, never request input. |
| Identity/Session decision | Active/allowed result and safe decision reference. |
| Validated time | Authoritative server time used for current checks. |
| Authentication evidence reference | Authentication method/assurance reference without credentials or factor material. |
| Correlation reference | Server-controlled request/operation correlation ID. |

It deliberately contains no durable list of roles, Branches, Brands, or capabilities. It is immutable, request/operation-scoped, non-serializable as a client token, and invalid after the operation ends.

### 6.3 Validation requirements

Before any Catalog lookup that could disclose protected information, the trusted Session provider must:

1. accept the opaque credential only from an approved server-side Presentation/transport boundary;
2. resolve and verify its server-side verifier without logging raw material;
3. require an existing, unexpired, unrevoked Session;
4. require a current User whose lifecycle permits access;
5. derive the User's Organization and stable Actor reference from authoritative state;
6. enforce the approved idle/absolute expiry and revocation rules applicable to that Session; and
7. return either a TrustedIdentityContext or a generic fail-closed rejection.

ADR-0006's opaque cookie/session topology remains `TECHNICAL_PROPOSAL`, not an accepted implementation choice. P1's consumer contract is provider-neutral, but an implementation cannot begin until the authentication/session mechanism and required security evidence are separately authorized.

### 6.4 Invalidity and lifecycle

Trusted context creation fails for a missing/malformed credential, unknown Session, verifier mismatch, expired/revoked Session, disallowed User lifecycle, missing Organization ancestry, provider/configuration error, or unavailable authoritative state. No partial context is returned.

Context does not outlive the request/operation, cannot be refreshed from client claims, and is never used as a positive authorization cache. Session rotation or revocation invalidates subsequent validation; Package C still performs revalidation before mutation.

## 7. Organization/Brand scope and capabilities

### 7.1 Controlled target resolution

Package C first receives a valid TrustedIdentityContext. Creation of a TrustedCatalogTarget follows this fixed trust-building sequence:

1. Catalog Application invokes its controlled Catalog persistence port with the untrusted target identifier plus trusted Organization scope.
2. Catalog Infrastructure performs the persisted lookup and returns minimal `PersistedCatalogTargetFacts`: entity identity/type, persisted Brand identity, and the authoritative Catalog relationship evidence needed to show entity→Brand. These facts are not authorization and Catalog Infrastructure does not create TrustedCatalogTarget.
3. Catalog Application calls the approved Organization Application contract to resolve and verify Brand→Organization ancestry. It does not query Organization Active Record or accept client ancestry claims.
4. Catalog Application verifies the complete entity→Brand→Organization relationship against TrustedIdentityContext and is the only component permitted to construct the minimal opaque TrustedCatalogTarget binding.
5. Catalog Application passes that binding to P1 only through the defined P1 consumer-port flow.

Neither Catalog Infrastructure nor Organization Infrastructure confers authorization trust. P1 does not accept free-standing client-supplied Organization/Brand UUIDs, and a Brand ID alone is never evidence that a Category or Variant belongs to that Brand. Missing, out-of-scope, relationship-mismatched, and cross-Brand targets share a non-disclosing outcome.

After Catalog locks, Catalog Infrastructure reloads the same entity and returns fresh persisted target facts. Catalog Application re-resolves Organization ancestry through the Organization Application contract, re-verifies the relationship, and constructs the reloaded target binding. Revalidation requires the entity identity, entity type, Organization, Brand, and persisted relationship to match the originally authorized binding. A changed or unverifiable binding fails closed before mutation.

### 7.2 Ownership scopes

`OWNER_CONFIRMED` policy:

- Organization Owner authority may administer Catalog delegation only within the owned Organization.
- Brand Owner authority may administer only within the owned Brand.
- lifecycle delegation supplies only its exact Brand/capability authority.
- delegated personnel need a separately granted delegation-management capability to administer grants.
- generic Owner, Manager, or other role labels do not independently prove ownership/capability.

`TECHNICAL_PROPOSAL`: an ownership resolver returns a typed authority source with stable Actor-independent reference, scope kind (`organization` or `brand`), scope identifier, and current validity. It must verify Brand→Organization ancestry through the Organization context contract. P1 cannot infer ownership from initial single-Organization/single-Brand deployment.

### 7.3 Capability evaluation

Each Package C operation supplies one exact code-owned capability proposed by the Package C design:

- `catalog.category.activate`
- `catalog.category.deactivate`
- `catalog.category.archive`
- `catalog.category.restore`
- `catalog.variant.activate`
- `catalog.variant.deactivate`
- `catalog.variant.archive`
- `catalog.variant.restore`

These identifiers remain `TECHNICAL_PROPOSAL`; the separate Category/Variant and operation authority is `OWNER_CONFIRMED`. No wildcard `catalog.change`, role-title check, prefix match, or implied administrative capability may authorize an operation. Default switching remains outside Package C.

An allow decision requires all applicable predicates:

1. valid TrustedIdentityContext;
2. a TrustedCatalogTarget produced by controlled persisted Catalog lookup, with intact entity→Brand→Organization relationship;
3. exact capability is supported by canonical policy;
4. current direct ownership authority or a delegation whose derived state is Effective and whose Actor, Subject, authority source, exact Brand, and exact capability all satisfy the current authorization request;
5. applicable self/administration/step-up guards; and
6. no revocation, expiry, mismatch, or provider uncertainty.

Any absent predicate denies.

The derived state Effective is only one predicate. It means the grant is inside its time interval and not revoked; it is not an authorization decision, cache entry, bearer proof, or authority for a later request. Every evaluation still verifies all predicates above against current trusted state.

## 8. AuthorizationContext contract

### 8.1 Proposed immutable values

`AuthorizationContext` is created server-side for one operation and target scope:

| Value | Meaning |
|---|---|
| Decision reference | Unique safe reference for this evaluation, not an idempotency key. |
| Actor reference | From TrustedIdentityContext. |
| Session reference | Non-secret server reference. |
| Trusted target binding | Opaque Catalog Application-produced binding to the exact entity identity/type and its verified persisted entity→Brand→Organization relationship. Infrastructure facts or a Brand UUID alone are insufficient. |
| Organization / Brand | Exact scope copied from the trusted target binding, never independent client input. |
| Capability | Exact operation capability. |
| Authority kind | Direct Organization ownership, direct Brand ownership, or Catalog delegation. |
| Grantor / authority source | Stable reference to the actual verified basis of authority, such as an ownership relationship or separately granted management capability; never merely a role title or Actor ID. |
| Subject | Delegation recipient when delegation applies; it must equal the Actor for use of that grant. |
| Delegation evidence | Grant reference, effective/expiry/revocation facts or version/reference when applicable. |
| Evaluated time | Authoritative time of the decision. |
| MFA evidence reference | Opaque reference when available; exact Package C acceptance semantics remain deferred. |
| Correlation reference | Server-controlled operation correlation. |

No raw cookie, token, MFA factor/response, password/PIN, unrestricted request data, persistence record, or client role/Brand claim is allowed.

Actor, Grantor/authority source, and Subject remain distinct semantic roles in this context even when Actor and the human exercising the authority source are the same person. That same-human case is valid only when the authority basis is independently verified, such as the Actor's current ownership relationship. It does not collapse the authority-source reference into the Actor reference, make Subject interchangeable with either role, or resolve P1-OD-05.

### 8.2 Lifecycle and transport

The context is immutable and operation-scoped. Identity Application returns it through an in-process Application contract; it is not a browser token, Session replacement, database authority, or serializable permission cache. Catalog Application may retain it only for the transaction and must request revalidation after acquiring required Catalog locks. The original Catalog Application-created TrustedCatalogTarget identity and ancestry remain bound to the decision; neither Presentation, Infrastructure, nor another context may construct or replace it with free-standing UUIDs.

P1's contract is a real cross-context seam:

```text
validate_session(session_proof, request_evidence) -> TrustedIdentityContext | AuthenticationRejection

authorize_catalog_operation(
  identity_context,
  trusted_catalog_target,
  exact_capability,
  operation_evidence
) -> AuthorizationContext | AuthorizationRejection

revalidate_catalog_authorization(
  authorization_context,
  reloaded_trusted_catalog_target,
  exact_capability
) -> RevalidatedAuthorization | AuthorizationRejection
```

Names and language shape are illustrative; trust and dependency semantics are the proposal. Trusted identity/Session validation, authorization, and revalidation for the Catalog lifecycle flow are consumed only through the outbound P1 consumer port owned by Catalog Application, not through a public/client contract. A Catalog Infrastructure adapter, or explicitly defined Catalog-side composition-boundary adapter, implements that port and invokes the Identity Application public contract. Identity Application neither implements nor depends on the Catalog-owned port, Catalog Domain never depends on it, and the composition root only wires the selected implementation. Future delegation-administration use cases require a separate, not-yet-authorized Presentation/Application entry point.

### 8.3 Safe outcomes

| Condition | Semantic outcome |
|---|---|
| Missing/invalid/expired/revoked Session or disallowed User | `authentication_rejected`; no resource existence disclosure. |
| Missing target, invalid Catalog entity→Brand relationship, Organization/Brand mismatch, or cross-Brand target | non-disclosing `resource_unavailable`. A bare Brand UUID cannot turn the target into a trusted binding. |
| Missing capability or authority | `authorization_denied` only when scope is already safe to reveal; otherwise `resource_unavailable`. |
| Future-effective, expired, revoked, mismatched, or merely Effective-without-the-other-required-predicates delegation | `authorization_denied` or non-disclosing equivalent. |
| MFA required but acceptable evidence unavailable | `step_up_required`; Archive/Restore remains blocked pending C0-R05. |
| Provider/state uncertainty | `authorization_unavailable`; fail closed. |

These are Application categories, not public API codes or HTTP statuses.

## 9. Catalog delegation lifecycle

### 9.1 Conceptual grant

`TECHNICAL_PROPOSAL`: a Catalog Delegation Grant requires stable references for the grant, Organization, Brand, exact capability, Grantor/authority source, Subject, creating Actor/Session, `effective_at`, `expires_at`, current revocation facts, and audit/correlation evidence. This is a logical contract, not a table definition.

The exact Brand must belong to the Organization. `effective_at` cannot precede the authoritative grant time. `expires_at` must be later than `effective_at`. A grant supplies authority only on the half-open interval `[effective_at, expires_at)` and only while not revoked. The authoritative time source must be consistent across evaluation and evidence.

No maximum duration is inferred from ID-14's 90-day Invitation Delegation. Catalog delegation is a distinct concept.

### 9.2 Derived states and replacement

| Derived state | Predicate | Authorization significance |
|---|---|---|
| Future-effective | current time < `effective_at` | The grant is not a candidate for authorization. |
| Effective | `effective_at` ≤ current time < `expires_at`, not revoked | The time/revocation predicate passes; the grant is only a candidate for full authorization. |
| Expired | current time ≥ `expires_at` | The grant is not a candidate; terminal for authorization. |
| Revoked | revocation is effective | The grant is not a candidate; terminal. |

Expired/revoked grants cannot be reactivated. Any replacement is a new grant with a new identity and independently audited authority decision. No operation rewrites history to make a former grant effective.

Future-effective, Effective, Expired, and Revoked are derived facts, not stored authorization decisions. Effective never grants authority by itself. Each use must freshly validate Actor and Session, require Subject=Actor for delegated use, verify the current Grantor/authority source, exact persisted target Brand and entity relationship, exact capability, and every applicable guard. Derived state is not cached or accepted as proof for another request, transaction, target, Brand, capability, or later time.

### 9.3 Grant administration

Before grant creation, Identity Application must:

1. validate Actor/Session;
2. resolve the actual Grantor/authority source basis and its current Organization/Brand administration scope, rather than substituting a role title or Actor ID;
3. require direct ownership or a separately granted delegation-management capability for the exact Brand;
4. ensure the administration authority does not come from the lifecycle grant being created;
5. reject Actor/Grantor/Subject combinations that constitute self-delegation or self-approval;
6. validate exact Brand/capability and non-retroactive effective/expiry facts;
7. lock/recheck conflicting grant/administration state under a reviewed concurrency protocol; and
8. commit the new grant and required administration audit evidence atomically under §10.

Actor and Grantor/authority source remain semantically distinct in this evaluation, but the Actor may be the same human who directly exercises the verified ownership relationship identified by the authority-source reference. That does not permit Actor=Subject self-delegation, erase the Subject distinction, or select an answer to P1-OD-05. An ordinary Catalog lifecycle delegation never includes onward-delegation authority. Separately granted delegation-management authority is evaluated as its own exact capability and scope.

### 9.4 Change administration

C0-R04 requires changes to be audited but does not identify which grant facts may change. Until the Owner confirms an allowed change matrix, `ChangeCatalogDelegation` has no executable mutation set and is `OWNER_DECISION_REQUIRED`/fail-closed.

Any future approved change must revalidate the same administration authority and self-approval rules, preserve history, and commit mutation plus before/after audit evidence atomically. Subject, authority source, Brand, and capability must not be assumed mutable. Replacement of an expired/revoked grant always uses a new grant regardless of a future change policy.

### 9.5 Revocation administration

Revocation may target a future-effective or currently effective grant. The operation validates current administration authority, locks the grant, rechecks terminal state, records authoritative revocation facts, and commits audit evidence atomically. Every authorization check after committed revocation denies the grant.

Duplicate-revoke/idempotency behavior is not selected because C0-R11 is deferred. Revoking an already expired/revoked grant therefore requires an explicit later outcome contract; it must never reactivate or extend authority.

### 9.6 Self-delegation, self-approval, and chain bypass

P1 rejects at least these cases:

- Actor and Subject are the same for a grant/change that confers the Actor authority;
- Subject acts as the administering or approving human for their own grant, or an unverified Subject/Actor/role-title claim is substituted for the required authority-source evidence;
- Actor attempts to use the target grant itself to prove delegation-management authority;
- ordinary lifecycle capability is treated as delegation-management capability;
- a management grant for one Brand/capability administers another scope;
- a revoked, expired, or future-effective grant is used anywhere in an authority chain;
- a generic Owner/Branch Manager/Staff label replaces proof of current ownership or exact management capability.

An Actor directly exercising their own independently verified ownership authority may be the same human associated with the Grantor/authority source; that fact alone is not a self-delegation exception and does not allow the Actor to become the Subject of the grant. The exact separate-approver semantics remain unresolved under P1-OD-05. Whether separately delegated management authority may itself grant delegation-management authority onward is not confirmed. P1 defaults to deny that action pending an Owner decision.

## 10. Delegation administration audit and atomicity

### 10.1 Required evidence

C0-R04 requires grant, change, and revoke events to be audited. Minimum evidence preserves:

- operation and authoritative event time;
- Actor identity and non-secret Session reference;
- distinct Grantor/authority-source and Subject references;
- Organization and exact Brand;
- exact affected capability;
- allowlisted before/after grant facts;
- effective/expiry facts;
- revocation facts when applicable; and
- correlation and safe authorization-decision references.

The audit representation belongs to future P1 Identity/delegation design. It is not required to use the P2 Catalog AuditEvent, current Phase 1 `audit_events`, or any particular table/event schema. Credentials, raw Session/MFA material, and unrestricted request bodies are prohibited.

### 10.2 Proposed atomic boundary

`TECHNICAL_PROPOSAL`: for each grant, approved change, and revoke:

1. audit persistence failure rolls back the corresponding delegation mutation;
2. delegation mutation failure leaves no separately committed success audit event; and
3. successful mutation and its audit evidence commit together.

The exact transaction/storage mechanism is not selected. If Identity persistence and its audit sink cannot provide this boundary, delegation administration remains unavailable. Denied-attempt security evidence is governed by the future Identity audit/security design and does not convert denial into a successful grant event.

## 11. Revalidation, time, and concurrency

### 11.1 Package C revalidation sequence

The P1/Package C sequence is:

1. validate identity/Session before protected Catalog lookup;
2. Catalog Infrastructure returns persisted entity→Brand facts, Catalog Application resolves Brand→Organization through the Organization Application contract, verifies the complete relationship, and only then creates TrustedCatalogTarget;
3. P1 evaluates exact capability against that complete trusted target binding, not a free-standing Brand ID;
4. Package C acquires its documented Category→Product→Variant locks and reloads the same entity through Catalog persistence;
5. Catalog Application produces a reloaded binding, and P1 revalidates identity, Session, ownership/capability, Actor/Subject/authority source, exact Brand/capability, delegation effective/expiry/revocation state, and required guards;
6. Package C rejects if entity identity/type, persisted relationship, scope, or authorization changed or cannot be proved;
7. only then may future Package C invoke Domain behavior and P2 audit orchestration.

No client claim participates in authority. Missing target, cross-Brand mismatch, and unauthorized target remain externally non-distinguishable.

### 11.2 Revocation linearization

P1 must define a transaction-compatible linearization point. A revocation committed before Package C's pre-mutation revalidation must be observed and deny. If lifecycle authorization linearizes first, its evidence must identify that decision; the exact locking/lease mechanism and whether revocation waits require implementation review and deterministic two-connection proof.

This document does not select delegation row locks, transaction isolation, distributed leases, cache invalidation, or automatic retries. If the selected persistence topology cannot prove current revocation visibility, revalidation fails closed.

### 11.3 Time semantics

`TECHNICAL_PROPOSAL`: all effective/expiry/revocation comparisons for one decision use one authoritative server-side time sample and record it as `evaluated_at`. The storage and evaluator must share a documented clock source and timezone-independent instant representation. Client clocks never participate.

Clock source, skew tolerance across processes, and operational clock monitoring require implementation/operational design. No grace period is inferred at `effective_at` or `expires_at`.

## 12. Trust boundaries and failure behavior

| Threat/failure | Required behavior |
|---|---|
| Client actor/Brand/role/capability/delegation claim | Ignore/reject as authority; derive server-side. |
| Session theft/revocation/expiry | Validate current server state; fail closed; never expose raw verifier. |
| Cross-Brand UUID probing | Controlled scoped lookup and non-disclosing outcome; no list/detail timing/log leakage accepted without review. |
| Generic role escalation | Require exact ownership or capability evidence. |
| Confused deputy | Bind decision to Actor, Session, exact entity identity/type and persisted ancestry, Brand, capability, target operation, and correlation reference. |
| Stale context/cache | Operation-scoped contexts; mandatory pre-mutation revalidation; uncertainty denies. |
| Future/expired/revoked delegation | Supplies no authority. |
| Self/onward delegation bypass | Separate management capability plus Actor/Grantor/Subject checks; no target-grant bootstrap. |
| Concurrent revocation | Defined linearization and deterministic proof; committed earlier revocation must win subsequent check. |
| Identity/Organization provider unavailable | `authorization_unavailable`; no Catalog mutation. |
| Audit persistence failure during delegation administration | Roll back delegation mutation. |
| Delegation mutation failure | Do not commit success audit evidence. |
| MFA evidence absent/ambiguous for Archive/Restore | Fail closed; C0-R05 remains deferred. |

Security-sensitive logs contain safe decision/category/reference data only. They never contain credentials, raw cookies/tokens, MFA material, unrestricted context serialization, or protected cross-Brand resource data.

## 13. P1 contracts consumed by Package C

Package C needs only three capabilities from P1:

1. validate a server-side Session into a TrustedIdentityContext;
2. authorize one exact Catalog operation against a TrustedCatalogTarget created only by Catalog Application after persisted Catalog lookup plus Organization Application ancestry verification; and
3. revalidate that decision after Catalog locks and immediately before mutation.

The consuming contract returns immutable values and semantic rejection categories. It does not expose User, Session, Role Assignment, ownership, or delegation persistence records. Catalog Domain remains framework- and Identity-independent. Catalog Application owns and depends on its outbound P1 authorization consumer port. A Catalog Infrastructure adapter, or explicitly defined Catalog-side composition-boundary adapter, implements that port and invokes the Identity Application public contract; Identity Application neither implements nor depends on the Catalog-owned port, and the composition root only wires the implementation.

This port is the entry point for trusted identity/Session validation, authorization, and revalidation within the Catalog lifecycle flow only. Future delegation grant/change/revoke administration requires a separate Presentation/Application entry point and remains unauthorized; it is not exposed through the Catalog lifecycle consumer port.

P1 does not append the C0-R07 Catalog lifecycle event, mutate Catalog state, acquire Catalog locks, or satisfy P3 database privileges. P1 only supplies safe evidence references required by the future P2 envelope.

## 14. Dependency and prerequisite matrix

| Item | Classification | Can design now | Required before implementation/integration |
|---|---|---|---|
| Trusted identity/Session consumer contract | `TECHNICAL_PROPOSAL` | Yes | Accepted scoped authentication mechanism; separate implementation authorization; session security evidence. |
| AuthorizationContext values and lifecycle | `TECHNICAL_PROPOSAL` | Yes | P1 implementation authorization and provider tests. |
| Organization/Brand ancestry contracts | `TECHNICAL_PROPOSAL` | Yes | Identity owns its OrganizationScope port and an Infrastructure adapter calls the published Organization Application contract; Catalog Application also uses that published contract to build target ancestry. Organization Infrastructure implements only Organization-owned persistence ports; no direct A1 Active Record access. |
| Organization Owner / Brand Owner representation | `OWNER_DECISION_REQUIRED` plus technical design | Partly | Resolve active-role/ownership ambiguity and authorize physical representation. |
| Package C capability identifiers | `TECHNICAL_PROPOSAL` under confirmed operation authority | Yes | Final design review and code-owned catalog implementation authorization. |
| Catalog delegation lifecycle | Confirmed policy plus `TECHNICAL_PROPOSAL` | Yes | Decisions in §15; persistence/transaction/audit design; authorization. |
| Archive/Restore MFA evidence | `DEFERRED` C0-R05 | Contract placeholder only | Explicit Owner decision and reviewed P1 evidence. |
| Delegation administration audit | Confirmed requirement plus `TECHNICAL_PROPOSAL` | Yes | P1 audit representation and atomicity evidence; not dependent on P2 schema. |
| P2 Catalog AuditEvent | `EXTERNAL_PREREQUISITE` | In parallel | Separate P2 authorization/design/implementation; integration uses P1 evidence references. |
| P3 runtime database security | `EXTERNAL_PREREQUISITE` | In parallel | Separate P3 mechanism/role authorization and production-like negative evidence. |
| Package C use cases | `EXTERNAL_PREREQUISITE` | Contract alignment only | P1+P2+P3 evidence, final design review, separate Package C authorization. |
| Audit retention/read/export | `DEFERRED` C0-R08 | No final policy | Owner/legal/privacy resolution before production governance claims. |
| Retry/idempotency | `DEFERRED` C0-R11 | Failure categories only | Explicit Owner decision before retry/replay behavior. |

### 14.1 Dependency graph

```text
C0 decisions (merged)
       |
       +--> P1 design (this document)
       |       |
       |       +--> Owner decisions in §15
       |       +--> scoped authentication/session approval
       |       +--> separate P1 implementation authorization
       |
       +--> P2 design/implementation ------------------+
       |                                                |
       +--> P3 design/implementation ------------------+|
                                                        ||
P1 implementation + security evidence -----------------+|
                                                         v
                                           Package C integration review
                                                         |
                                                         v
                              separate Package C implementation authorization
```

P1 and P2 design can proceed in parallel. P2's lifecycle-event envelope needs P1's evidence-reference semantics for integration, while P1 delegation-administration audit does not assume P2 storage. P3 is independently designed but required to prevent runtime SQL bypass of the future Package C Application boundary.

## 15. Open Owner decisions and technical blockers

### 15.1 Owner decisions required

| ID | Question that existing policy does not answer | Default until decided |
|---|---|---|
| `P1-OD-01` | Is Brand Owner a distinct active role/assignment, or an Organization Owner/ownership relationship scoped to a Brand under the existing Owner role vocabulary? | No Brand Owner authority is materialized; only authority proven by an approved representation may be used. |
| `P1-OD-02` | Who may grant and revoke the separate delegation-management capability, and may a holder ever grant delegation-management authority onward? | Organization/Brand direct owner administration only; onward grant of management authority denied. |
| `P1-OD-03` | Which facts of a live/future Catalog Delegation Grant may be changed instead of creating a replacement grant? | `ChangeCatalogDelegation` has no executable mutation set. Grant and revoke remain design-only. |
| `P1-OD-04` | Is a maximum Catalog delegation duration required, and if so what is it? | No duration is inferred from Invitation Delegation; implementation remains blocked from inventing a limit or unlimited policy. |
| `P1-OD-05` | Does Catalog delegation require a separate approver beyond an authorized Actor/authority source, and what exactly constitutes self-approval when Actor, Grantor, and approver differ? | Self-delegation/self-approval is denied; no approval workflow is invented. |
| `C0-R05` | Exact Package C MFA freshness, assurance, Session binding, and invalidation. | Archive/Restore authorization unavailable. |

These identifiers are local design questions, not new Owner Decision Baseline IDs.

### 15.2 Technical and operational blockers

- ADR-0006 remains Proposed; no authenticated Session producer exists.
- No User/Session/ownership/assignment/delegation persistence or Application contract exists.
- Organization A1 has no authorized Application seam for ownership/ancestry queries.
- No P1 audit representation or mutation-plus-audit transaction evidence exists.
- Revocation linearization, concurrency, clock, and cache invalidation are unproved.
- MFA evidence semantics are deferred.
- Identity security checklist items remain evidence-gated; Owner-led review is not independent verification or legal advice.
- P3 role/bypass controls and production-like topology are absent.

## 16. Verification and acceptance criteria

### 16.1 Design acceptance

P1 design may be considered ready for Owner review only when:

- all C0-CAT-01–08 and C0-R01–11 are traceable without changing status;
- Actor, Grantor/authority source, and Subject remain distinct;
- two-stage trusted identity/operation authorization is internally consistent with Package C;
- Organization/Brand ownership ambiguity and all deferred decisions remain explicit;
- Layered DDD dependencies point inward and cross-context persistence access is prohibited;
- delegation lifecycle, audit atomicity, non-disclosure, and revalidation races have testable contracts;
- no schema, provider, MFA policy, retry policy, or public API is silently selected.

### 16.2 Prerequisites before implementation authorization

- explicit Owner decisions in §15.1;
- scoped decision on the authentication/Session mechanism without accepting ADR-0006 by implication;
- approved P1 physical design for identity, ownership, capability, delegation, and administration-audit persistence;
- security review of Session validation, authorization/IDOR, delegation, step-up, audit redaction, and concurrency;
- deterministic contract and two-connection test plan;
- development/test adapters that cannot boot in production configuration;
- operational clock, secret, Session revocation, monitoring, and incident requirements;
- separate implementation authorization with exact files/schema/migrations/tests in scope.

### 16.3 Future executable evidence

Future P1 implementation evidence must include:

- valid, malformed, unknown, expired, revoked, rotated Session and disallowed User cases;
- Organization/Brand ancestry, entity→Brand relationship substitution, bare-Brand-ID rejection, and cross-Brand guessed-UUID non-disclosure;
- exact capability matrix with no role-title/wildcard fallback;
- direct Organization/Brand ownership and exact delegated authority cases;
- future-effective/effective/expiry-boundary/revoked/replacement delegation cases;
- self-delegation, self-approval, target-grant bootstrap, wrong-Brand, wrong-capability, and onward-chain denials;
- grant/change/revoke audit evidence with Actor/Grantor/Subject distinction;
- for each administration operation: audit failure rolls back mutation, mutation failure leaves no success audit, and success commits both;
- concurrent revocation versus Package C revalidation in both linearization orders;
- stale-context/provider-outage fail-closed behavior;
- absence of credentials, raw Session/MFA material, and protected target data from context, logs, errors, and audit;
- proof that Archive/Restore remains unavailable until acceptable C0-R05 evidence exists.

## 17. Risks and design verdict

### 17.1 Principal risks

- treating the existing Organization-scoped Owner role as proof of unmodeled Brand Owner authority;
- reusing ID-14 Invitation Delegation fields, 90-day limit, or subject rules for Catalog delegation;
- caching a positive AuthorizationContext across revocation or requests;
- permitting a generic `catalog.change` or role title to authorize Package C;
- allowing Catalog to query Identity/Organization Active Record records directly;
- confusing delegation administration audit with P2 Catalog lifecycle AuditEvent;
- choosing an MFA or retry policy while C0-R05/C0-R11 is deferred;
- leaking cross-Brand existence through lookup outcomes, timing, logs, or metrics;
- recording Actor as Grantor when authority actually comes from a different source;
- committing delegation mutation without its required audit evidence.

### 17.2 Verdict

`DESIGN_REVIEW_REQUIRED`

P1 now has a proposed trust model, Layered DDD allocation, two-stage context contract, capability/delegation evaluation rules, fail-closed behavior, revalidation boundary, administration audit contract, and prerequisite map. It is not implementation-ready because the Owner decisions in §15.1, scoped Session/authentication approval, physical design, security evidence, and separate implementation authorization are absent.

This document does not change ADR-0006, C0 decisions, deferred statuses, CAT-TRR findings, Identity Milestone 2B authorization, P2/P3 status, or Package C authorization.
