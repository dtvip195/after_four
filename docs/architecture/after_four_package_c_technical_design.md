# AFTER FOUR — Package C Technical Design

**Document status:** `TECHNICAL_PROPOSAL`

**Readiness:** `DESIGN_REVIEW_REQUIRED`

**Implementation authorization:** Not granted

**Evidence date:** 2026-11-15

## 1. Purpose and authority boundary

This document defines a reviewable design for the Category and Variant lifecycle operations in Package C. It translates the merged Package C0 Owner decisions into proposed Domain, Application, Infrastructure, and future Presentation responsibilities. It does not implement or authorize P1, P2, P3, Package C, Identity Milestone 2B, a public API, or production use.

The authoritative business policy is the [Owner Decision Baseline](after_four_owner_decision_baseline.md#package-c0-lifecycle-authority-and-prerequisite-decisions). The [Catalog Core Technical Design](after_four_catalog_core_technical_design.md) remains the source for the implemented Package B schema and PostgreSQL integrity mechanisms. [ADR-0011](adr/0011-project-wide-layered-ddd.md) controls dependency direction. [ADR-0006](adr/0006-authentication-session-topology.md) remains Proposed, and this design does not accept it or authorize Identity implementation.

Classification labels in this document mean:

| Label | Meaning |
|---|---|
| `OWNER_CONFIRMED` | Exact business/scope policy explicitly confirmed by the Owner. |
| `DEFERRED` | Intentionally postponed Owner decision; no replacement policy may be inferred. |
| `TECHNICAL_PROPOSAL` | Reviewable implementation design that is neither implemented nor Owner-approved merely by appearing here. |
| `EXTERNAL_PREREQUISITE` | Separately authorized implementation or operational evidence required before Package C can run. |
| `UNRESOLVED_OWNER_DECISION` | Business policy that still needs explicit Owner direction. |

### 1.1 Repository state and current evidence

At preparation time the repository was on `main` at `2b180298c82ba0c0b88fd89d920b6ebe320ddb2d` (`Merge pull request #8 from dtvip195/docs/after-four-package-c0-decisions`) with a clean working tree. That merge contains the canonical Package C0 decision register.

Current implementation evidence is deliberately narrower than this design:

- Package B has framework-independent Category, Product, and Variant Domain objects and Active Record persistence records under `backend/app/contexts/catalog/`.
- Package B has PostgreSQL lifecycle checks/triggers, immutable ancestry, no-Purge triggers, Default uniqueness, deferred Product/Variant and Category/Product final-state checks, and a fail-closed `READ COMMITTED` guard.
- Package B has local PostgreSQL integrity, concurrency, migration-lifecycle, failure-atomicity, and schema-equivalence specs. These do not prove production roles or Package C behavior.
- There are no Catalog Application lifecycle use cases or Presentation adapters.
- The current Phase 1 `AuditEvent` is Branch-scoped and does not satisfy the Brand-scoped C0-R07 envelope.
- There is no implemented trusted Identity/delegation producer, Package C AuthorizationContext, operational runtime-role topology, or operation-specific database boundary.

## 2. Canonical traceability

### 2.1 Owner-confirmed requirements

| Decision | Requirement carried into Package C | Design consequence |
|---|---|---|
| `C0-CAT-01` | Category lifecycle authority belongs to Organization/Brand Owners and explicitly delegated personnel for the applicable operation. | Category operations require distinct server-evaluated capabilities; a role title alone is insufficient. |
| `C0-CAT-02` | Variant lifecycle authority is separate from Category authority. | Variant capabilities are evaluated independently from Category capabilities. |
| `C0-CAT-03` | Delegation is capability-specific and Brand-scoped. | Authorization must bind the exact operation and target Brand. |
| `C0-CAT-04`, `C0-R06` | Deactivate, Archive, and Restore require a nonblank reason of at most 500 characters; secrets are prohibited. | Application validation occurs before mutation and the accepted reason enters the audit envelope. Activate has no confirmed reason requirement. |
| `C0-CAT-05` | Archive and Restore require successful step-up MFA. | These operations fail closed until P1 can provide acceptable MFA evidence under a later resolution of C0-R05. |
| `C0-CAT-06` | Cross-Brand access is default-deny. | Target Brand comes from authoritative persisted state and must equal an authorized server-derived scope. |
| `C0-CAT-07` | Audit failure rolls back the entire lifecycle mutation. | Mutation and audit append share one database transaction; no after-commit audit is acceptable. |
| `C0-CAT-08` | Default Variant switching is outside Package C. | A lifecycle operation may reject a transition but never designates, transfers, or replaces the Default Variant. |
| `C0-R01` | Role/capability assignment follows Organization/Brand ownership scope. | The authorization provider returns an evaluated capability, not a client role label. |
| `C0-R02` | Organization Owner and Brand Owner have their confirmed administration scopes; onward delegation requires separate delegation-management authority. | Package C consumes evidence only; it does not create or administer delegation. Generic roles grant nothing implicitly. |
| `C0-R03` | Self-delegation and self-approval are prohibited. | P1 must reject these administration paths; Package C rejects evidence that is not valid under that rule. |
| `C0-R04` | Delegation has effective/expiry/revocation semantics, cannot be reactivated, and grant/change/revoke events are audited. | Authorization is revalidated against authoritative time and current grant state inside the operation boundary. P1 must also retain evidence for every delegation grant, change, and revoke operation as specified in §6.5. |
| `C0-R07` | Brand-scoped Catalog AuditEvent has the confirmed envelope, is append-only, and is atomic with mutation. | P2 must provide a Brand-scoped append port and database representation before lifecycle implementation. |
| `C0-R09` | Trusted server-side AuthorizationContext is mandatory and fails closed. | Client actor, session, Brand, role, capability, delegation, and MFA claims never become authority. |
| `C0-R10` | Runtime and migration ownership are separate; runtime destructive/schema authority is restricted; an operation-specific database boundary is required. | P3 must choose and prove a least-privilege boundary separately; this design compares but does not select mechanisms. |

The lifecycle policy also preserves `ODB-CAT-25`, `ODB-CAT-28`–`ODB-CAT-32`, `ODB-CAT-38`, and `ODB-CAT-40`: exact Category/Variant transitions, Category/Product guards, Product-owned Default eligibility, at-most-one Default designation, and Variant Archive/Restore flag preservation.

### 2.2 Deferred decisions

| Decision | Deferred matter | Package C impact |
|---|---|---|
| `C0-R05` | MFA freshness, assurance, session binding, and invalidation. | Archive and Restore remain required to use step-up MFA but are blocked from implementation until acceptable evidence semantics are decided. No default time window or assurance level is inferred. |
| `C0-R08` | Audit retention, legal hold, reader authorization, and export governance. | Does not waive append-only/atomic write requirements. It blocks production governance for retained events, not the definition of the write envelope. |
| `C0-R11` | Advanced retry and idempotency policy. | No automatic retry, retry count/backoff, or idempotency key contract is selected. Deadlock/timeout returns a stable failure outcome for a caller-controlled later policy. |

No additional Owner business decision is needed to describe the eight lifecycle operations. Their implementation remains blocked by the deferred and external prerequisites above. Product lifecycle commands, Product reassignment, Default switching, create/edit operations, pricing, availability, and public endpoints are outside this design.

## 3. Lifecycle contract shared by all operations

### 3.1 Confirmed transition matrix

Category and Variant use the exact `OWNER_CONFIRMED` matrix from `ODB-CAT-32`:

| Source | Destination | Result |
|---|---|---|
| Draft | Active | Allowed after validation. |
| Draft | Inactive | Prohibited. |
| Draft | Archived | Allowed through Archive and applicable guards. |
| Active | Inactive | Allowed through Deactivate and applicable guards. |
| Active | Archived | Allowed through Archive and applicable guards. |
| Inactive | Active | Allowed through Activate after validation. |
| Inactive | Archived | Allowed through Archive and applicable guards. |
| Archived | Inactive | Allowed only through Restore and validation. |
| Archived | Active | Prohibited directly. |

An operation with the same source and destination is not a successful lifecycle transition. Package C does not define generic status setters or Product lifecycle commands.

### 3.2 Proposed stable capability codes

The following names are `TECHNICAL_PROPOSAL` identifiers for the separately confirmed capabilities, not new Owner permissions:

- `catalog.category.activate`
- `catalog.category.deactivate`
- `catalog.category.archive`
- `catalog.category.restore`
- `catalog.variant.activate`
- `catalog.variant.deactivate`
- `catalog.variant.archive`
- `catalog.variant.restore`

Possession of one supplies no authority for another. Assignment and delegation-management capabilities are outside the eight operations and require P1 design consistent with C0-R01 through C0-R04.

### 3.3 Common execution contract

Every use case is proposed to:

1. accept a target identifier, operation-specific input, correlation ID, and an opaque trusted-context reference from server composition;
2. validate the trusted provenance and current validity of the actor identity and Session before any Catalog lookup that could disclose protected information; fail closed with a non-disclosing outcome when this check fails;
3. begin one `READ COMMITTED` database transaction;
4. resolve only the target identity and authoritative persisted Brand through a controlled Infrastructure lookup; never accept client-supplied Brand scope as authority and do not disclose the target's existence or data before authorization succeeds;
5. evaluate the exact operation capability against that persisted Brand, returning a non-disclosing denial for a missing target, Brand mismatch, or insufficient authority;
6. acquire the operation's Catalog locks in the order in §8 and reload authoritative state;
7. revalidate identity/Session, exact capability, persisted Brand, and delegation effectiveness/revocation after the required locks and before mutation; validate the reason and MFA evidence as applicable;
8. fail closed if the locked/reloaded target no longer matches the authorized target or Brand;
9. invoke framework-independent Domain transition behavior;
10. persist only the lifecycle change allowed by that operation;
11. append the C0-R07 AuditEvent in the same transaction; and
12. commit, or roll back the complete transaction on any rejection or persistence failure.

The operation never continues an aborted PostgreSQL transaction. No retry occurs inside this contract while C0-R11 is deferred.

## 4. Eight operation specifications

All audit events use the envelope in §7. “Database backstop” describes Package B protection already present; it does not mean the Package C use case exists.

### 4.1 Category Activate

- **Transition:** Draft→Active or Inactive→Active.
- **Capability:** `catalog.category.activate`; target Brand must match authorized scope.
- **Reason / MFA:** neither is required by current Owner decisions.
- **Domain preconditions:** source state is eligible and Category data remains valid.
- **Aggregate/dependency invariant:** activation itself does not activate Products. Existing Active Products under a non-Active Category should be impossible under the database final-state invariant.
- **Locks:** target Category first; discover/lock any integrity-relevant assigned Products in UUID order if final-state validation requires them.
- **Audit:** Category before/after lifecycle state plus evaluated authorization evidence.
- **Business rejections:** invalid source state, missing capability, cross-Brand scope, ineffective/revoked delegation, or invalid Category state.
- **Database backstop:** `categories_lifecycle_transition_allowed`; `catalog_active_product_category_valid`; `catalog_integrity_requires_read_committed`.
- **Tests:** both allowed sources; prohibited Archived→Active and Active→Active; owner/delegate/cross-Brand cases; audit rollback; concurrency with Product changes.
- **Blockers:** P1, P2, P3 and final Package C authorization.

### 4.2 Category Deactivate

- **Transition:** Active→Inactive only.
- **Capability:** `catalog.category.deactivate` within target Brand.
- **Reason / MFA:** nonblank ≤500-character secret-free reason required; no step-up requirement is confirmed.
- **Domain preconditions:** Category is Active.
- **Aggregate/dependency invariant:** no Active Product may remain assigned (`ODB-CAT-29`).
- **Locks:** Category, then all assigned Products in deterministic UUID order; reload and reject if any is Active.
- **Audit:** includes the accepted reason and final dependency decision.
- **Business rejections:** invalid source, invalid reason, Active assigned Product, or any common authorization denial.
- **Database backstop:** lifecycle transition trigger and `catalog_active_product_category_valid` deferred final-state check.
- **Tests:** zero/many non-Active Products; one/many Active Products; Product activation race; blank/whitespace/501-character/secret-bearing reason; audit failure rollback.
- **Blockers:** P1, P2, P3 and final Package C authorization.

### 4.3 Category Archive

- **Transition:** Draft→Archived, Active→Archived, or Inactive→Archived.
- **Capability:** `catalog.category.archive` within target Brand.
- **Reason / MFA:** valid reason and successful step-up MFA required.
- **Domain preconditions:** eligible source state.
- **Aggregate/dependency invariant:** no Active Product may remain assigned (`ODB-CAT-25`). Archive retains the Category; it is not Purge.
- **Locks:** Category, then assigned Products in UUID order; revalidate after locks.
- **Audit:** includes reason and MFA evidence reference, never the authenticator or secret.
- **Business rejections:** Active assigned Product, invalid reason, missing/invalid MFA evidence, or common authorization denial.
- **Database backstop:** lifecycle trigger, Category/Product deferred check, and `categories_purge_forbidden`.
- **Tests:** all three sources; Active Product guard and race; MFA/reason boundaries; retained identifier and no-Purge evidence; atomic audit failure.
- **Blockers:** P1 and resolution of C0-R05, P2, P3, and final authorization.

### 4.4 Category Restore

- **Transition:** Archived→Inactive only; activation remains separate.
- **Capability:** `catalog.category.restore` within target Brand.
- **Reason / MFA:** valid reason and successful step-up MFA required.
- **Domain preconditions:** Category is Archived and retained identity/data remain valid.
- **Aggregate/dependency invariant:** Restore never activates Products or makes the Category Active.
- **Locks:** Category first; dependency locks only when required by final-state validation.
- **Audit:** Archived→Inactive before/after, reason, MFA reference, and authorization evidence.
- **Business rejections:** non-Archived source, invalid reason/MFA, identifier/integrity failure, or common authorization denial.
- **Database backstop:** lifecycle trigger; direct Archived→Active remains prohibited.
- **Tests:** exact Restore target; direct Active target rejection; separate later activation; reason/MFA and audit rollback cases.
- **Blockers:** P1 and C0-R05, P2, P3, and final authorization.

### 4.5 Variant Activate

- **Transition:** Draft→Active or Inactive→Active.
- **Capability:** `catalog.variant.activate` within the Variant's persisted Brand.
- **Reason / MFA:** neither is required by current Owner decisions.
- **Domain preconditions:** eligible source and Variant belongs to the loaded Product aggregate.
- **Product-owned invariant:** after the change, an Active Product still has exactly one Active designated Default; visibility is irrelevant. The operation never changes `is_default` or `customer_visible`.
- **Locks:** Product, then affected Variants in UUID order. A Category lock is not added when Category/Product compatibility is unaffected.
- **Audit:** Variant lifecycle before/after and unchanged configuration flags.
- **Business rejections:** invalid source, aggregate membership failure, Default invariant failure, or common authorization denial.
- **Database backstop:** Variant lifecycle trigger, one-Default unique index, and `catalog_active_product_default_valid`.
- **Tests:** both allowed sources; Archived→Active rejection; hidden/default combinations; concurrent lifecycle change on another Variant.
- **Blockers:** P1, P2, P3 and final authorization.

### 4.6 Variant Deactivate

- **Transition:** Active→Inactive only.
- **Capability:** `catalog.variant.deactivate` within target Brand.
- **Reason / MFA:** valid reason required; no confirmed step-up requirement.
- **Domain preconditions:** source is Active and Product aggregate is loaded authoritatively.
- **Product-owned invariant:** reject if the final state would leave an Active Product without exactly one Active designated Default. No Default transfer is permitted.
- **Locks:** Product, then affected Variants in UUID order; reload all Variant state needed for the invariant.
- **Audit:** lifecycle before/after, reason, and unchanged `is_default`/`customer_visible` values.
- **Business rejections:** invalid source/reason, Default invariant violation, or common authorization denial.
- **Database backstop:** lifecycle trigger and deferred active-Default final-state check.
- **Tests:** non-Default success; Default rejection for Active Product; eligible cases under non-Active Product; competing Variant operation; audit rollback.
- **Blockers:** P1, P2, P3 and final authorization.

### 4.7 Variant Archive

- **Transition:** Draft→Archived, Active→Archived, or Inactive→Archived.
- **Capability:** `catalog.variant.archive` within target Brand.
- **Reason / MFA:** valid reason and successful step-up MFA required.
- **Domain preconditions:** eligible source and aggregate membership.
- **Product-owned invariant:** preserve `is_default` and `customer_visible`; reject if an Active Product would lose its valid Default. Never transfer Default designation.
- **Locks:** Product, then affected Variants in UUID order.
- **Audit:** lifecycle before/after, unchanged flags, reason, and MFA evidence reference.
- **Business rejections:** invariant violation, attempted flag mutation, invalid reason/MFA, or common authorization denial.
- **Database backstop:** lifecycle/flag statement guard, deferred Default check, at-most-one index, and no-Purge trigger. The statement guard cannot prove semantic preservation across arbitrary multi-statement SQL; P3 must deny such bypass.
- **Tests:** all sources; flag preservation; Default/non-Default cases; multi-statement direct-SQL denial under runtime role; failure rollback.
- **Blockers:** P1 and C0-R05, P2, P3, and final authorization.

### 4.8 Variant Restore

- **Transition:** Archived→Inactive only; activation remains separate.
- **Capability:** `catalog.variant.restore` within target Brand.
- **Reason / MFA:** valid reason and successful step-up MFA required.
- **Domain preconditions:** source is Archived and membership/retained identity remain valid.
- **Product-owned invariant:** preserve `is_default` and `customer_visible`; never activate, designate, transfer, or replace a Default.
- **Locks:** Product, then affected Variants in UUID order.
- **Audit:** Archived→Inactive before/after, unchanged flags, reason, and MFA reference.
- **Business rejections:** invalid source, attempted flag mutation, aggregate invariant failure, invalid reason/MFA, or common authorization denial.
- **Database backstop:** lifecycle/flag trigger and deferred Default check.
- **Tests:** exact target; flags preserved for all combinations; direct Archived→Active rejected; separate activation; audit atomicity.
- **Blockers:** P1 and C0-R05, P2, P3, and final authorization.

## 5. Layered DDD design

### 5.1 Domain

`TECHNICAL_PROPOSAL`: extend the existing framework-independent Catalog Domain only when Package C implementation is separately authorized.

- Category owns explicit transition eligibility for Activate, Deactivate, Archive, and Restore and returns typed Domain rejections for invalid source/destination semantics.
- Product remains the aggregate boundary for Variant lifecycle consistency. It evaluates a proposed Variant transition against all authoritative aggregate members and the Active Product Default invariant.
- Variant Archive/Restore Domain behavior changes lifecycle status only and preserves `is_default` and `customer_visible`.
- Domain accepts already-trusted operation intent and business values; it does not authenticate, query delegation, parse sessions, start transactions, acquire PostgreSQL locks, append audit rows, or know Rails/Active Record/HTTP.
- Cross-aggregate Category/Product dependency discovery is not hidden inside Category. Application coordinates the relevant state and Infrastructure supplies authoritative persistence.

Typed Domain outcomes should distinguish invalid transition, active-product dependency, and Default invariant failure without embedding SQL constraint names or HTTP status codes.

### 5.2 Application

`TECHNICAL_PROPOSAL`: eight explicit use cases correspond one-to-one with §4. A generic “update lifecycle status” command is rejected because it obscures different capability, reason, MFA, audit, and invariant requirements.

Each use case owns orchestration: trusted-context acquisition, target resolution, capability/Brand validation, transaction boundary, authorization revalidation, reason/MFA checks, deterministic lock request, Domain invocation, persistence, atomic audit append, and semantic error mapping. Application depends inward on Domain and on narrow contracts required by these real use cases.

Application does not expose persistence records, infer permissions from role labels, accept actor/scope authority from Presentation, switch Default Variant, or implement automatic retries.

### 5.3 Infrastructure

The following seams are justified by actual Package C requirements, but their concrete implementation is not authorized:

| Contract/adapter | Responsibility | Boundary |
|---|---|---|
| Trusted AuthorizationContext provider | Produce server-origin identity/session/scope references. | P1; must not expose raw session secrets. |
| Authorization/delegation evaluator | Evaluate exact capability, ownership, effective time, expiry, revocation, and non-self rules; support transaction-compatible revalidation. | P1; schema and Identity implementation are not selected here. |
| Catalog persistence adapter | Load aggregates, lock Category/Product/Variant rows, persist allowed lifecycle changes, translate known database failures. | Package C implementation; Active Record remains Infrastructure. |
| Transaction coordinator | Run mutation and audit append in one `READ COMMITTED` transaction. | Must compose Catalog and P2 audit persistence on the same database transaction/connection boundary. |
| Catalog AuditEvent adapter | Append the C0-R07 Brand-scoped envelope. | P2; current Branch-scoped table is insufficient. |
| Operation-specific database boundary | Prevent unrestricted runtime DML and direct authorization/audit bypass. | P3; mechanism remains unselected. |
| Database error translator | Map only known SQLSTATE plus named constraint/trigger identities to stable Application outcomes. | Unknown failures remain unexpected and roll back. |

PostgreSQL triggers and constraints are defense in depth, not substitutes for trusted authorization, Domain behavior, or atomic audit orchestration.

### 5.4 Presentation

Presentation is outside Package C closure. No route, controller, request schema, serializer, or HTTP status is selected. A future adapter may parse untrusted input and correlation metadata, then call exactly one Application use case. It must not construct authority claims, access Active Record records directly, mutate lifecycle columns, append its own audit event, or bypass Domain/Application checks.

## 6. AuthorizationContext and delegation contract

### 6.1 Minimum conceptual context

`OWNER_CONFIRMED` requirements from C0-R09 and `TECHNICAL_PROPOSAL` shape:

| Field/evidence | Required meaning |
|---|---|
| Actor identity | Stable server-resolved User/actor reference; never request-supplied authority. |
| Session | Opaque stable session reference and server-verified active status; no raw session token. |
| Organization scope | Server-resolved ownership scope applicable to the target Brand. |
| Brand scope | Exact target Brand derived from persistence and authorized by current policy. |
| Capability | Exact operation capability evaluated by the provider. |
| Authorization decision | Allow decision plus decision/evaluation reference and evaluated-at time. |
| Delegation evidence | Grant reference, distinct Grantor/authority-source and Subject references, Brand, capability, effective/expiry/revocation facts when delegation supplies authority; the Actor remains the person/Session performing the current operation. |
| MFA evidence | Opaque verification reference when required; exact assurance/freshness semantics remain C0-R05. |

The context is immutable to the use case but is not a timeless permission cache. Identity/Session validity is checked before protected Catalog lookup. The target Brand is then derived through controlled Infrastructure lookup, the exact capability is evaluated against that persisted Brand, and authoritative authorization/delegation state is revalidated after Catalog locks and before mutation.

### 6.2 Lookup and authorization sequence

The sequence in §3.3 is mandatory for every operation:

1. validate trusted actor identity and Session before any lookup that could disclose Catalog information;
2. use a controlled, minimal Infrastructure lookup to obtain the target's persisted Brand without returning target details to an unauthorized caller;
3. evaluate the exact capability against that persisted Brand, never a client-supplied Brand claim;
4. acquire the required Catalog locks and reload the authoritative target;
5. revalidate identity/Session, Brand scope, capability, and delegation effectiveness/revocation before mutation; and
6. return a fail-closed, non-disclosing denial when the target is absent, unauthorized, cross-Brand, or changed while locks were acquired.

The controlled lookup is an Infrastructure responsibility, not an authorization bypass. Logs, metrics, timing behavior, and Application outcomes must not reveal whether a protected cross-Brand identifier exists. The exact external response remains a future Presentation decision.

### 6.3 Fail-closed matrix

| Condition | Required outcome |
|---|---|
| Missing, invalid, expired, revoked, or deactivated identity/session | Authentication rejection; no mutation/audit-success event. Security-denial audit ownership belongs to P1 policy. |
| Target missing, or persisted Brand missing or mismatched | Non-disclosing denial; do not reveal whether a protected cross-Brand target exists. |
| Required capability missing | Authorization denial. |
| Delegation is future-effective | Deny until `effective_at`; no retroactive authority. |
| Delegation is expired or revoked | Deny; it cannot be reactivated. |
| Delegation Brand/capability does not exactly match | Deny. |
| Evidence arose through prohibited self-delegation/self-approval | Deny and surface invalid authorization evidence to the trusted provider. |
| MFA evidence absent/invalid for Archive/Restore | Deny; exact “fresh enough” decision is blocked by C0-R05. |
| Client supplies actor, Brand, role, capability, delegation, or MFA claims | Treat as untrusted input and ignore/reject as authority. |

### 6.4 Revocation race

`TECHNICAL_PROPOSAL`: P1 must expose a transaction-compatible evaluation/lease contract with a documented authorization linearization point. A lifecycle operation revalidates after Catalog locks. A revocation committed before that revalidation must be observed and deny the operation. If the adapter cannot serialize or prove this behavior across its storage boundary, Package C fails closed.

The exact delegation row locks, schema, or cross-context transaction mechanism are intentionally not invented. Deterministic two-connection evidence must show both orderings: revocation wins and denies; lifecycle authorization linearizes first and records the exact evidence used. This proposal does not weaken C0-R04 or authorize Identity Milestone 2B.

### 6.5 Delegation administration audit traceability

`OWNER_CONFIRMED`: C0-R04 requires every Catalog delegation grant, change, and revoke operation to be audited. These are delegation-administration operations, not any of the eight Category/Variant lifecycle operations.

`TECHNICAL_PROPOSAL`: the minimum audit evidence for each operation is:

| Evidence | Required content |
|---|---|
| Operation and event time | Grant, change, or revoke; authoritative occurrence time. |
| Actor | The trusted person and Session that actually performs the grant, change, or revoke operation. |
| Grantor / authority source | The Owner or separately authorized authority source under which the delegation is issued or administered. Preserve its stable reference and authority basis independently from the Actor. |
| Subject | The person receiving the delegation. Preserve a stable subject reference independently from the Actor and Grantor. |
| Scope | Organization and exact Brand scope. |
| Capability | Exact capability-specific authority affected. |
| Changed grant facts | Allowlisted before/after facts sufficient to show what changed; no credentials or secrets. |
| Effective/expiry facts | `effective_at` and `expires_at`, including changes to either value. |
| Revocation facts | Revocation time, actor, and safe reason/reference when applicable; no reactivation semantics. |

Actor, Grantor/authority source, and Subject are separate audit roles and may identify different people. Evidence must preserve who performed the operation separately from whose authority permitted it and who received the delegation. This distinction does not select database columns, an event schema, or an authorization representation.

The audit representation belongs to the separately authorized Identity/delegation design. This document does not require those events to use the Catalog AuditEvent table, the P2 schema, or any unapproved audit schema. Whatever representation is chosen must preserve C0-R04 traceability and must not silently convert a revoked/expired grant into an active one.

Because C0-R04 requires the administration event to be audited, P1 design must define a fail-closed persistence boundary. For each of grant, change, and revoke, acceptance evidence must prove all three outcomes: audit persistence failure rolls back the corresponding delegation mutation; delegation mutation failure does not leave a separately committed success audit event; and a successful mutation plus its audit evidence commit together. This atomicity requirement is a `TECHNICAL_PROPOSAL` for P1 review; it does not alter C0-R04 or select a table, event envelope, transaction mechanism, or storage technology.

## 7. Catalog AuditEvent contract

### 7.1 Required envelope

P2 must represent every successful lifecycle mutation with this C0-R07 envelope:

| Element | Technical requirement |
|---|---|
| Event ID | Globally unique immutable event identifier. |
| Correlation ID | Trusted request/operation correlation reference; not an idempotency policy. |
| Actor / trusted identity / Session | Stable references only; no credentials, raw tokens, or authenticators. |
| Organization / Brand | Exact authoritative scope; Brand is mandatory for Catalog lifecycle. |
| Capability / authorization / delegation | Exact capability and immutable evidence references/facts supporting the decision. |
| Entity / operation | Category or Variant identifier and one of the eight explicit operations. |
| Before / after state | Allowlisted lifecycle snapshot; Variant includes unchanged `is_default` and `customer_visible` for proof. |
| Reason | Accepted reason for Deactivate/Archive/Restore; absent for Activate unless a future decision changes policy. |
| MFA evidence | Opaque reference for Archive/Restore; no factor secret or response. |
| Timestamp | Authoritative server/database occurrence time with timezone. |
| Schema version | Explicit event-envelope schema version. |

The payload must prohibit passwords, PINs, session secrets, CSRF tokens, MFA seeds/responses, recovery material, authorization bearer material, database credentials, and other secrets.

### 7.2 Serialization and redaction

`TECHNICAL_PROPOSAL`: use an allowlist serializer owned by the P2 adapter, bounded strings, stable identifiers, canonical lifecycle values, and no arbitrary object serialization. Before/after state contains only fields needed to prove the lifecycle decision.

For reason validation, use this `TECHNICAL_PROPOSAL` convention across Application, persistence, and tests:

1. require valid UTF-8;
2. use the Unicode 15.1.0 `White_Space` property, pinned until an explicit design revision;
3. remove leading and trailing code points in the exact set below to produce the persisted reason;
4. reject the result when it is empty;
5. count Unicode code points, not bytes or extended grapheme clusters, in that persisted value;
6. accept at most 500 code points after trimming; and
7. apply no Unicode normalization or case folding.

The normative trim set is exactly these 25 code points:

```text
U+0009–U+000D
U+0020
U+0085
U+00A0
U+1680
U+2000–U+200A
U+2028
U+2029
U+202F
U+205F
U+3000
```

The explicit set is authoritative for this proposal even if an Application runtime, regular-expression engine, PostgreSQL collation, or operating-system Unicode table differs. PostgreSQL `btrim()` and regex `\s` are not assumed to implement this set.

Application canonicalization must validate UTF-8, trim by explicit code-point membership in this frozen set, and count code points on the resulting value. Persistence must require PostgreSQL database encoding `UTF8`; store only the canonical value; reject empty values, values whose first or last code point belongs to the frozen set, and values for which `char_length` exceeds 500. Any future database check/helper must encode the same explicit set rather than delegate its meaning to locale, collation, `btrim()`, or regex `\s`. `char_length` supplies the required code-point count in PostgreSQL UTF-8 but does not perform the required trimming.

Cross-layer fixtures must run through both Application canonicalization and the persistence backstop. They include:

- a parameterized leading/trailing case for every code point in U+0009–U+000D and U+2000–U+200A;
- leading/trailing U+0020, U+0085, U+00A0, U+1680, U+2028, U+2029, U+202F, U+205F, and U+3000;
- values made entirely from one or several members of the set, which canonicalize to empty and are rejected;
- the same code points inside nonblank text, where internal whitespace is preserved;
- U+200B as a nearby non-member, proving the implementation does not trim by an over-broad whitespace rule; and
- 500/501-code-point boundaries using ASCII, multibyte characters, combining sequences, and emoji.

Application and persistence must produce the same canonical value and acceptance result for every shared fixture. Only the 500-character maximum and blank/whitespace rejection are `OWNER_CONFIRMED` under C0-R06; Unicode 15.1.0, the frozen set, trimming, code-point counting, UTF-8 enforcement details, and test mechanics remain `TECHNICAL_PROPOSAL`.

C0-R06 prohibits intentionally including secrets in a reason. Arbitrary human free text cannot be reliably scanned for every possible secret, so the design must not claim complete secret detection. Input adapters must allowlist the reason string and reject detectable structured credential/secret fields rather than serializing them into the reason. Logs, errors, metrics, and traces must omit or safely redact reason content. High-confidence detection may reject recognized structured secret formats, but operational guidance, restricted audit access, and incident handling remain necessary for secrets a person nevertheless enters.

### 7.3 Atomicity and append-only protection

- Lifecycle persistence and AuditEvent append occur on the same transaction boundary.
- A simulated validation, constraint, connection, or adapter failure during audit append rolls back lifecycle state and any other writes.
- Append-only protection must cover runtime UPDATE, DELETE, and TRUNCATE through privileges and database mechanisms appropriate to P3.
- The runtime role must not own or disable the protection. Migration/break-glass authority remains separately controlled.
- Reusing an event identity after a failed transaction is an unresolved idempotency matter under C0-R11; this design selects no behavior.

The existing Phase 1 `audit_events` table is Branch-scoped and has a generic metadata payload. Its UPDATE/DELETE trigger is useful evidence of an append-only pattern but does not implement Brand scope, the complete envelope, TRUNCATE denial under a non-owner runtime role, or Catalog mutation/audit atomicity.

### 7.4 P2 evidence

Required evidence includes exact envelope persistence, Brand/Organization FK/scope validation, secret-redaction cases, append-only direct-SQL negative tests, non-owner runtime-role tests, forced audit-insert failure with unchanged lifecycle state, transaction-commit proof, and schema migration evidence that preserves historical Branch-scoped events without mutating append-only rows. C0-R08 governance remains deferred.

## 8. Transactions, locks, and concurrency

### 8.1 Isolation and sequence

Package B final-state triggers explicitly require PostgreSQL `READ COMMITTED`; other isolation levels fail closed through `catalog_integrity_requires_read_committed`. Package C therefore proposes `READ COMMITTED` unless a later PostgreSQL-specific design proves another level.

The common sequence is the twelve-step contract in §3.3 and the lookup boundary in §6.2. Trusted identity and Session are validated before any lookup that could disclose protected Catalog information. Infrastructure then resolves only the target's authoritative persisted Brand through a controlled, non-disclosing lookup; the exact capability is evaluated against that Brand, never a client claim. After required Catalog locks, the operation reloads the target and revalidates identity/Session, Brand, capability, and delegation immediately before mutation. The Domain decision uses this locked state. Audit append precedes commit. Any missing/mismatched target, authorization change, Domain rejection, SQL error, lock timeout, deadlock, or audit failure aborts the whole transaction and must not create cross-Brand disclosure.

### 8.2 Catalog lock order

For conforming Application operations:

1. lock affected Categories in ascending UUID order when Category/Product compatibility is relevant;
2. lock affected Products in ascending UUID order; and
3. lock affected Variants in ascending UUID order.

Category Deactivate/Archive uses Category→assigned Products. Variant operations use Product→affected Variants and do not acquire an unrelated Category lock. Multi-record sets are always UUID-sorted. Authorization/delegation serialization belongs to the P1 adapter and must publish a compatible ordering before integration; Package C must not improvise cross-context locks.

This Application order differs from arbitrary direct SQL and deferred-trigger physical order. Product DML already owns its Product row before a Product-event deferred trigger requests Category; Variant DML may similarly hold a child before requesting Product. Direct child-first SQL can therefore deadlock. P3 minimizes that path; database triggers retain fail-safe final-state validation.

### 8.3 Race analysis

| Race | Proposed serialization and required outcome |
|---|---|
| Category Deactivate/Archive vs Product activation | Conforming path locks Category before Product. Deferred Category/Product checks use fresh `READ COMMITTED` commands. Invalid combined state cannot commit. Direct inverted SQL may deadlock and one full transaction aborts. |
| Variant lifecycle vs another Variant lifecycle | Both lock Product, then UUID-sorted Variants. Product aggregate validates the final Default state; unique index/deferred trigger backstop it. |
| Active Product Default invariant | No lifecycle operation switches Default. Any transition leaving an Active Product without exactly one Active designated Default is rejected. Temporary invalid states may exist only inside a transaction that repairs them before deferred checking. |
| Delegation revocation vs lifecycle use | P1 transaction-compatible revalidation provides the linearization point described in §6.3. Missing proof blocks integration. |
| Audit failure | Same transaction rolls back Catalog mutation and audit insert. No compensating after-commit write is accepted. |
| Lock timeout | Abort/roll back; map supported `55P03` evidence to lock-unavailable. Do not continue or retry automatically. |
| Deadlock | PostgreSQL aborts one complete transaction with `40P01`; do not predict the victim. Survivor still passes final-state checks. No automatic retry while C0-R11 is deferred. |

### 8.4 Database-enforced versus Application-enforced

| Guarantee | Database backstop now | Package C Application responsibility |
|---|---|---|
| Allowed lifecycle pairs | Named BEFORE UPDATE triggers. | Invoke only the named operation and map invalid transition. |
| Category/Product compatibility | Deferred final-state triggers and fresh-snapshot protocol. | Parent-first locks, authoritative discovery, Domain rejection. |
| Active Product Default | Partial unique index plus deferred Product/Variant checks. | Load Product aggregate, preserve flags, reject violating transition. |
| Archive/Restore flag preservation | Same-statement trigger guard only. | Persist lifecycle only; P3 denies independent multi-statement bypass. |
| No Purge | BEFORE DELETE triggers. | Expose no delete operation; P3 denies DELETE/TRUNCATE. |
| Brand authorization | Same-Brand FKs protect ancestry, not actor authority. | Trusted context, exact scope/capability evaluation, fail closed. |
| Audit atomicity | Not implemented for Catalog C0 contract. | P2 adapter and one transaction; P3 prevents bypass. |

## 9. Operation-specific database boundary options

C0-R10 requires a boundary but deliberately leaves its mechanism open. The runtime principal must not own Catalog/Audit objects and must have no unrestricted `ALTER`, `DROP`, `TRUNCATE`, trigger disablement, `session_replication_role` modification, direct `DELETE`, function replacement, role grants, or Catalog DML that bypasses authorization/audit.

| Option | Least privilege / bypass resistance | Atomicity and Brand scope | DDD / operations / testability |
|---|---|---|---|
| Security-definer functions per operation | Can expose EXECUTE only and keep table DML denied; strong when owner, `search_path`, qualification, input validation, and function replacement are tightly controlled. A vulnerable function becomes a privileged bypass. | Can encapsulate mutation/audit, but duplicating authorization or Domain policy in SQL risks divergence. Trusted context transport must be proved. | PostgreSQL-heavy Infrastructure adapter; operational ownership and function tests are substantial. **Not selected.** |
| Restricted table/column grants plus Application transaction | Simple Rails persistence, but UPDATE on lifecycle columns can bypass Application authorization/audit unless additional mandatory database enforcement exists. Column grants do not express all operation semantics. | Atomic append is easy in one Rails transaction but not mandatory against direct SQL. | Fits existing adapters but currently fails the bypass-resistance requirement alone. **Not sufficient by itself.** |
| Updatable views with INSTEAD OF triggers/rules | Can hide base tables and expose narrow shapes; trigger code and ownership must still be secured. | Could enforce operation/audit coupling, but trusted authorization context and semantic duplication remain difficult. | More database indirection and high test/migration cost. **Not selected.** |
| Dedicated command executor with a separate database principal | Web runtime can lack Catalog DML; a narrow executor owns operation access. Credential/process separation can reduce bypass. | Requires a trustworthy command transport, transaction-local authorization revalidation, and audit in executor. Deferred idempotency/retry policy complicates delivery. | Adds deployment boundary and operational service complexity not yet approved. **Not selected.** |
| Database policy/trigger-enforced operation context combined with restricted DML | Can require transaction-scoped signed/verified context and matching audit, but unsafe session settings or forgeable context create bypass. | Potentially strong if database can verify provenance and exact Brand/capability. | Complex custom security protocol; hard key/session management and negative tests. **Not selected.** |

P3 must choose or refine a mechanism through a separate authorization. Acceptance requires ownership/grant inspection, safe function `search_path` and EXECUTE policy where relevant, direct-SQL negative tests, Brand-scope bypass tests, forced audit failure, and proof that the normal runtime credential cannot replace/disable the boundary.

## 10. Stable Application error contract

These are `TECHNICAL_PROPOSAL` semantic outcomes, not public API codes or HTTP statuses:

| Application category | Meaning | Supported database evidence where applicable |
|---|---|---|
| `authentication_required` | Trusted identity/session missing or invalid. | P1 outcome, not SQL mapping. |
| `authorization_denied` | Capability/ownership decision denies. | P1 outcome. |
| `brand_scope_denied` | Target Brand is outside trusted scope. | Application/P1 outcome; same-Brand FK is not actor authorization. |
| `delegation_not_effective` | Future, expired, revoked, mismatched, or invalid delegation. | P1 outcome. |
| `step_up_mfa_required` | Required MFA evidence absent/invalid. | P1 outcome; exact semantics deferred. |
| `reason_invalid` | Missing, blank/whitespace, too long, or rejected secret-bearing reason. | Application validation. |
| `lifecycle_transition_invalid` | Source/destination pair prohibited. | `23514` plus `categories_lifecycle_transition_allowed` or `product_variants_lifecycle_transition_allowed`. |
| `category_dependency_conflict` | Category transition conflicts with Active Product. | `23514` plus `catalog_active_product_category_valid`. |
| `default_variant_invariant_conflict` | Variant transition would violate Active Product Default rule. | `23514` plus `catalog_active_product_default_valid`; duplicate designation remains `23505` plus `uq_product_variants_one_default`. |
| `lock_unavailable` | Bounded lock wait failed. | Executed repository evidence supports `55P03` for the configured lock-timeout path. |
| `transaction_deadlock` | PostgreSQL selected this transaction as deadlock victim. | `40P01`; full rollback required. |
| `audit_persistence_failed` | Required event could not append. | P2 typed outcome or known constraint; full rollback required. |
| `database_integrity_rejected` | A known named integrity backstop rejected the final state. | Known `23503`, `23505`, or `23514` plus exact object identity. |
| `transaction_failed` | Unexpected database/infrastructure failure. | Preserve cause internally, redact externally, roll back, and do not misclassify. |

No outcome implies automatic retry. Unknown constraint names or SQLSTATEs must not be silently converted into a known business rejection.

## 11. Verification strategy

No tests are executed by this design milestone. The matrix specifies future evidence only.

| Test family | Required cases | Dependency |
|---|---|---|
| Eight use-case contracts | Success for every allowed source; rejection for every prohibited source/destination; no generic setter; stable semantic outcomes. | P1+P2+P3+Package C implementation. |
| Category dependency | Deactivate/Archive with zero, non-Active, and Active Products; Product-activation races; committed final-state query. | Package C plus Package B DB; authorization cases also P1. |
| Variant aggregate | Default/non-Default, visible/hidden, all Product states; flags preserved; no Default transfer; concurrent Variant changes. | Package C plus Package B DB. |
| Authorization | Organization Owner, Brand Owner, explicitly delegated personnel, missing capability, cross-Brand, generic-role-only denial. | P1. |
| Delegation lifecycle | Future-effective, exact boundary at effective/expiry time, early revocation, non-reactivation, replacement grant, self-delegation/self-approval denial, revocation race. | P1; no invented schema. |
| Delegation administration audit | Grant/change/revoke each distinguishes Actor, Grantor/authority source, and Subject and records Organization/Brand, capability, changed facts, effective/expiry facts, applicable revocation facts, and event time. For each operation: audit failure rolls back mutation; mutation failure leaves no committed success audit; success commits mutation and evidence together. | P1; representation is not assumed to be Catalog AuditEvent or P2. |
| Reason | Shared Application/persistence fixtures use Unicode 15.1.0 and the frozen 25-code-point `White_Space` set: every listed edge code point, whitespace-only combinations, preserved internal whitespace, non-member U+200B, 500/501 code points, multibyte/combining/emoji boundaries, detectable structured secret fields, and no reason content in logs/errors/metrics/traces. | Package C+P2; UTF-8 trimming/counting convention is `TECHNICAL_PROPOSAL`. |
| MFA | Archive/Restore absent/invalid/valid evidence; Activate/Deactivate do not acquire an unapproved MFA requirement. | P1 and **blocked by C0-R05** for final acceptance. |
| Audit envelope | Every required field, Brand scope, before/after, reason, MFA reference, correlation/event IDs, schema version, allowlist serialization, secret redaction. | P2. |
| Atomicity/failure injection | Audit validation/constraint/adapter failure leaves lifecycle and audit unchanged; successful transaction persists both exactly once according to later idempotency policy. | P2+P3+Package C; replay semantics **blocked by C0-R11**. |
| Concurrency | Deterministic Category/Product and Product/Variant schedules, delegation revocation race, `40P01` full rollback, `55P03` rollback, survivor invariant. | P1+Package C+PostgreSQL; retries **blocked by C0-R11**. |
| Runtime role | Runtime cannot DELETE/TRUNCATE/DDL/disable triggers/change replication role/replace functions/grant roles or bypass operations with direct DML; migration role can apply approved migrations. | P3 and production-like role environment. |
| Database backstops | Direct SQL transition pairs, Default uniqueness/finality, Category finality, flags, no-Purge, unsupported isolation. | Package B evidence exists locally; rerun against Package C migration/role topology. |
| Audit governance | Retention, holds, readers, exports. | **Blocked by C0-R08** and any required legal/privacy review; not a lifecycle-write test. |

Every concurrency test uses real PostgreSQL connections, deterministic barriers/lock observation, bounded timeouts, full transaction outcomes, and committed-state assertions. Mocks cannot prove locking, SQLSTATE, privileges, or atomicity.

## 12. Dependency and authorization gates

```text
C0 Owner decisions (COMPLETED + MERGED)
        |
        +--> P1 trusted Identity / AuthorizationContext / delegation ----+
        |          |                                                     |
        |          +-- C0-R05 resolution for Archive/Restore MFA         |
        |                                                                v
        +--> P2 Brand-scoped Catalog AuditEvent -----------------> integration design
        |                                                                |
        +--> P3 runtime roles + operation-specific DB boundary ----------+
                                                                         |
                                                                         v
                                           production-like negative and atomicity evidence
                                                                         |
                                                                         v
                                                   final technical design review
                                                                         |
                                                                         v
                                        separate explicit Package C implementation authorization
```

- **C0:** completed and merged; policy only.
- **P1:** requires separate authorization. Its context/delegation design and P2 envelope/schema design may proceed in parallel, but runtime integration cannot succeed without trusted Identity evidence.
- **P2:** requires separate authorization and must distinguish current Branch-scoped Phase 1 events from Brand-scoped Catalog events.
- **P3:** requires separate authorization after mechanism review; role/configuration evidence must be production-like rather than superuser-only local evidence.
- **C0-R08:** must be resolved before production audit governance can be claimed.
- **C0-R11:** must be resolved before any automatic retry/idempotency behavior is approved.
- **Package C:** remains unauthorized until prerequisites, executable evidence, final review, and a separate Owner authorization exist.

## 13. CAT-TRR-005 through CAT-TRR-008

Canonical statuses remain unchanged in the [Technical Readiness Reassessment](../research/after_four_catalog_core_technical_readiness_reassessment.md). This document neither edits nor closes them.

| Finding | Canonical severity/status | Merged evidence now present | Remaining Package C/operational gap |
|---|---|---|---|
| `CAT-TRR-005` | `HIGH` / `TECHNICAL_DESIGN_CHANGE_REQUIRED` | Package B no-Purge triggers and direct-SQL integrity tests exist locally/CI. | Runtime-role DELETE/TRUNCATE denial, operation boundary, owner/superuser limitations, and production-like privilege evidence remain. Description is a reconciliation candidate, not a status change here. |
| `CAT-TRR-006` | `HIGH` / `VALIDATION_EVIDENCE_REQUIRED` | Deterministic Package B PostgreSQL concurrency evidence includes fresh snapshots, wait/deadlock schedules, victim rollback, lock timeout, stale-snapshot negative harness, and deferred repair. | Package C Application lock protocol, authorization-revocation race, audit atomicity under concurrency, and any later retry/idempotency evidence remain. |
| `CAT-TRR-007` | `HIGH` / `OPERATIONAL_EVIDENCE_REQUIRED` | Design states role separation and restrictions. | No implemented runtime/migration/break-glass topology, grants/default privileges, ownership, safe EXECUTE/search path, or production-like negative tests. |
| `CAT-TRR-008` | `MEDIUM` / `VALIDATION_EVIDENCE_REQUIRED` | Merged Package B migration lifecycle, failure atomicity/recovery, and semantic schema-equivalence evidence exists. | Package C/P2/P3 migration path, Brand audit expansion, database error translation, role-aware rollback/roll-forward, and production-like operations remain. |

Successful Package B evidence does not prove Package C production readiness. Any stale finding prose should be reconciled only in a separately authorized status/documentation milestone with retained evidence references.

## 14. Failure modes and review questions

Design review must reject or resolve these failure modes before implementation authorization:

- stale AuthorizationContext treated as a permission cache;
- Brand accepted from request data rather than authoritative target state;
- generic Owner/Manager role title used instead of exact capability and scope;
- delegation revocation commits without the operation observing it at the defined linearization point;
- Archive/Restore implemented before C0-R05 supplies testable MFA evidence semantics;
- reason logged, echoed, or serialized with secrets/arbitrary fields;
- Variant transition mutates Default/visibility or performs an implicit switch;
- Application lock ordering diverges across the eight use cases;
- after-commit or best-effort audit allows mutation without event;
- current Branch-scoped AuditEvent incorrectly represented as satisfying C0-R07;
- runtime table/function ownership permits disabling triggers or replacing privileged code;
- security-definer function uses unsafe `search_path`, broad PUBLIC EXECUTE, or caller-controlled SQL;
- database error translator maps by message text or hides unknown failures;
- code retries a partial/aborted transaction or selects retry/idempotency policy before C0-R11;
- production claims rely only on local superuser tests.

No new `UNRESOLVED_OWNER_DECISION` was discovered for the eight-operation business contract. The known deferred Owner decisions C0-R05, C0-R08, and C0-R11 remain explicit. The concrete P1/P2/P3 mechanisms are technical decisions requiring separate design review/authorization, not business policy to invent here.

## 15. Design closure verdict

### `DESIGN_REVIEW_REQUIRED`

The eight lifecycle operation contracts, Layered DDD responsibilities, trusted-context boundary, Brand-scoped audit envelope, transaction/lock protocol, error categories, database-boundary alternatives, verification plan, and prerequisite graph are now specified at design level.

Package C is **not implementation-ready or authorized**. P1, P2, and P3 are absent; C0-R05 prevents testable Archive/Restore MFA acceptance; C0-R08 leaves production audit governance unresolved; C0-R11 leaves retry/idempotency intentionally unselected; operational database-role evidence is missing; and a final review must select a coherent operation-specific boundary without weakening existing Package B constraints.

Completing this document changes no Owner decision, ADR status, CAT-TRR status, source code, schema, runtime behavior, or authorization boundary.
