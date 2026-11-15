# AFTER FOUR — I1 Organization Scope Contract Technical Design

**Document status:** `TECHNICAL_PROPOSAL`

**Readiness:** `GATE_A_DESIGN_BASELINE_APPROVED`

**Implementation authorization:** `GRANTED — I1 BOUNDED SCOPE ONLY`

**Gate A approval:** `APPROVED`

**Gate B approval:** `APPROVED`

**Gate C Control Acceptance:** `NOT GRANTED`

**Final Operational Acceptance:** `NOT GRANTED`

**Production authorization:** `NOT GRANTED`

**Implementation checkpoint:** `dd5b3804a1db55fbc05b3f5f33142462ad29de5e`

**Gate A design evidence baseline:** `main` at `626b872b99a5c2aee4a4e7c84981afd1b5bbd859` on 2026-11-15

## Gate A Owner decision record

| Field | Recorded decision |
|---|---|
| Decision | `APPROVE` |
| Gate | ADR Design Baseline Approval — Gate A |
| Reviewed document | `docs/architecture/after_four_i1_organization_scope_contract_design.md` |
| Reviewed design commit | `5ca7796fa3ea272fd71dd66891f89f69257db029` |
| Decision date | 2026-11-15 |
| Owner identity | Organization Owner (role-based; personal name not recorded) |
| Approved scope | I1 ancestry-only semantic design, limited to resolving `Brand ID -> authoritative Organization ID`. |
| Required amendments | None |

This approval accepts only the reviewed I1 semantic design baseline. It does not authorize I1 implementation, Identity Milestone 2B, production, deployment, database, schema, data, configuration, authentication, authorization, ownership, delegation, Session, MFA, or Catalog capabilities. A separate bounded Gate B authorization remains mandatory before implementation.

ADR-0006 remains `Proposed`; Identity Security Review Checklist statuses remain unchanged; P1-OD-01 through P1-OD-05 remain unresolved; and C0-R05, C0-R08, and C0-R11 remain `DEFERRED`. This decision accepts no security control or residual risk and grants no additional authorization to I2, P1, P2, P3, Package C, C1, C2, or C3.

## Gate B Owner decision record

| Field | Recorded decision |
|---|---|
| Decision | `APPROVE` |
| Gate | Gate B — Bounded Implementation Authorization |
| Decision date | 2026-11-15 |
| Authority | Organization Owner (role-based; personal name not recorded) |
| Approved design baseline | `docs/architecture/after_four_i1_organization_scope_contract_design.md` at `5ca7796fa3ea272fd71dd66891f89f69257db029` |
| Authorized implementation scope | Exact manifest of 17 production files and 4 spec files below; no existing production file modification. |
| Implementation checkpoint | `dd5b3804a1db55fbc05b3f5f33142462ad29de5e` (`feat: implement I1 organization scope contract`) |
| Gate C Control Acceptance | `NOT GRANTED` |
| Final Operational Acceptance | `NOT GRANTED` |
| Production authorization | `NOT GRANTED` |

The authorized production manifest was exactly:

1. `backend/app/domains/identity/application/contracts/identity_brand_reference.rb`
2. `backend/app/domains/identity/application/contracts/identity_organization_reference.rb`
3. `backend/app/domains/identity/application/contracts/organization_scope_evidence.rb`
4. `backend/app/domains/identity/application/contracts/organization_scope_result.rb`
5. `backend/app/domains/identity/application/contracts/safe_failure_reference.rb`
6. `backend/app/domains/identity/application/errors/unexpected_failure.rb`
7. `backend/app/domains/identity/application/ports/organization_scope.rb`
8. `backend/app/domains/identity/infrastructure/adapters/organization_scope_adapter.rb`
9. `backend/app/domains/organization/application/contracts/brand_ancestry.rb`
10. `backend/app/domains/organization/application/contracts/brand_reference.rb`
11. `backend/app/domains/organization/application/contracts/organization_reference.rb`
12. `backend/app/domains/organization/application/contracts/resolve_brand_ancestry_result.rb`
13. `backend/app/domains/organization/application/contracts/safe_failure_reference.rb`
14. `backend/app/domains/organization/application/errors/unexpected_failure.rb`
15. `backend/app/domains/organization/application/ports/brand_ancestry_reader.rb`
16. `backend/app/domains/organization/application/queries/resolve_brand_ancestry.rb`
17. `backend/app/domains/organization/infrastructure/persistence/active_record_brand_ancestry_reader.rb`

The authorized spec manifest was exactly:

1. `backend/spec/architecture/i1_dependency_spec.rb`
2. `backend/spec/domains/identity/infrastructure/adapters/organization_scope_adapter_spec.rb`
3. `backend/spec/domains/organization/application/queries/resolve_brand_ancestry_spec.rb`
4. `backend/spec/domains/organization/infrastructure/persistence/active_record_brand_ancestry_reader_spec.rb`

Gate B authorized only Brand ID → authoritative Brand lookup → Organization ancestry resolution, the five normal outcomes and approved exceptional-termination behavior, the narrow Active Record availability-exception allowlist, one PostgreSQL `LEFT OUTER JOIN` statement, and the reviewed Identity adapter mapping and containment behavior. I1 performs no diagnostic recording. The permitted local/test verification was limited to the four manifest specs, `bin/rails zeitwerk:check`, the reviewed scoped RuboCop command, and `git diff --check`, after confirming the test database and environment.

Gate B did not authorize Composition Root wiring, a runtime consumer, authentication, login, registration, credentials, Session, `AuthorizationContext`, ownership, roles, capabilities, delegation, MFA, Catalog lifecycle, AuditEvent, runtime database security, schema or data changes, development or production database mutation, deployment, release, production configuration, or expansion of the exception allowlist or diagnostic responsibilities. It grants no additional authorization to Identity Milestone 2B, I2, P1, P2, P3, Package C, C1, C2, or C3.

Gate A accepted only the semantic design baseline and did not itself authorize implementation. Gate B was a separate, explicit, bounded authorization. Commit `dd5b3804a1db55fbc05b3f5f33142462ad29de5e` records the completed bounded implementation checkpoint; it does not constitute Gate C acceptance, Final Operational Acceptance, production readiness, or production authorization. Gate C requires separately executed control evidence and explicit Owner acceptance. Final Operational Acceptance remains a separate decision.

Forward-looking Gate B wording retained later in this document records the reviewed Gate A baseline as it existed before the separate Gate B decision. This Gate B decision record is authoritative for current I1 authorization status and supersedes that wording only as to whether the bounded implementation was authorized; it does not rewrite the approved semantic design or accept any control.

## 1. Context, purpose, and decision discipline

I1 defines one ancestry-resolution contract:

```text
Brand ID -> authoritative Organization ID
```

The contract supplies current persisted ancestry evidence to an internal caller. It does not authenticate a person, establish ownership, grant a capability, authorize an operation, or create an `AuthorizationContext`.

This design follows the G1 readiness conclusion that an ancestry-only slice can be reviewed independently from unresolved P1 ownership and delegation decisions. The Organization Owner approved this exact semantic design baseline at Gate A without amendments, as recorded above. That approval is not Bounded Implementation Authorization, Control Acceptance, or Final Operational Acceptance.

The classifications used here are:

| Classification | Meaning |
|---|---|
| `VERIFIED_FACT` | Current repository code, schema, or canonical documentation directly supports the statement. |
| `TECHNICAL_PROPOSAL` | Reviewable design that is neither implemented nor approved merely by appearing here. |
| `UNRESOLVED` | Evidence or a later technical decision is required; no default is authorized. |
| `OUT_OF_SCOPE` | Deliberately excluded from I1 and unavailable through this contract. |

Authoritative sources are the [DDD Foundation](after_four_ddd_foundation.md), [Foundation Decisions](after_four_foundation_decisions.md), [Owner Decision Baseline](after_four_owner_decision_baseline.md), [P1 Trusted Identity / Authorization Design](after_four_p1_trusted_identity_authorization_design.md), [Package C Technical Design](after_four_package_c_technical_design.md), and [ADR-0011](adr/0011-project-wide-layered-ddd.md).

## 2. Problem statement

The implemented A1 Organization foundation persists Organization, Brand, and Branch ancestry, but it intentionally exposes no Organization Application contract. Future Identity and Catalog flows must not query Organization Active Record classes directly or treat a client-provided Organization/Brand identifier as authority.

P1 requires two distinct consumers of authoritative Brand ancestry:

- Identity Application needs an Organization-owned answer behind its own `OrganizationScope` outbound port.
- Catalog Application later needs the Organization Application public contract while constructing a `TrustedCatalogTarget` from separately verified Catalog entity-to-Brand facts.

I1 closes only this cross-context query seam. It does not close either consumer's authorization design.

## 3. Goals and non-goals

### 3.1 Goals

- publish one read-only Organization Application query for Brand-to-Organization ancestry;
- define the focused Organization-owned persistence port needed by that query;
- define the Identity Application-owned `OrganizationScope` outbound port;
- define an Identity Infrastructure adapter that calls the Organization Application contract;
- return immutable identifier values, never persistence records;
- distinguish resolved, not-found, invalid, inconsistent, and unavailable outcomes;
- fail closed without manufacturing partial ancestry;
- preserve inward Layered DDD dependencies and explicit composition wiring;
- define deterministic unit, contract, integration, and architecture evidence for a later implementation milestone.

### 3.2 Non-goals

I1 does not design or implement:

- User, Employee, Session, authentication, credentials, cookies, CSRF, MFA, or recovery;
- Organization Owner or Brand Owner representation;
- ownership, role, capability, delegation, Branch Assignment, or Catalog authority evaluation;
- `TrustedIdentityContext`, `TrustedCatalogTarget`, or `AuthorizationContext` construction;
- Catalog entity lookup or entity-to-Brand verification;
- Category, Product, or Variant behavior;
- P2 AuditEvent or P3 database-operation security;
- a public endpoint, serializer, controller, request body, or frontend contract;
- Organization/Brand/Branch provisioning, mutation, reassignment, or deletion;
- schema, migration, database-role, dependency, or production-configuration changes;
- caching, asynchronous delivery, retry, idempotency, or cross-request evidence reuse.

## 4. Current A1 evidence

### 4.1 Verified source structure

`VERIFIED_FACT`: A1 implements framework-independent entities at:

- `backend/app/domains/organization/domain/entities/organization.rb`
- `backend/app/domains/organization/domain/entities/brand.rb`
- `backend/app/domains/organization/domain/entities/branch.rb`

The Brand entity carries `id` and `organization_id`. The Domain objects do not inherit from Active Record.

`VERIFIED_FACT`: A1 implements persistence records at:

- `backend/app/domains/organization/infrastructure/persistence/organization_record.rb`
- `backend/app/domains/organization/infrastructure/persistence/brand_record.rb`
- `backend/app/domains/organization/infrastructure/persistence/branch_record.rb`

`BrandRecord` belongs to `OrganizationRecord`. These classes own Active Record associations and persistence projection; they are not cross-context contracts.

### 4.2 Verified database ancestry

Migration `backend/db/migrate/20261115200000_create_reference_foundation.rb` establishes:

- UUID primary keys for Organization, Brand, and Branch;
- non-null `brands.organization_id`;
- foreign key `fk_brands_organization` from Brand to Organization;
- primary-key uniqueness for `brands.id`;
- restrictive deletion behavior;
- an index on `brands.organization_id`.

Consequences for I1:

- one committed Brand row identifies at most one Organization ID;
- a committed Brand row cannot have a null Organization parent;
- under enforced foreign keys, a committed Brand cannot reference a missing Organization row;
- an exact Brand primary-key lookup cannot legitimately return multiple Brands.

A missing parent or duplicate exact-Brand result is therefore not ordinary `not_found`; it is inconsistent state and must fail closed.

### 4.3 Verified missing seam

`VERIFIED_FACT`: A1 has no Organization Application layer, published query contract, Identity `OrganizationScope` port, Identity adapter, or Presentation surface. ADR-0011 states that A1 intentionally created no empty Application or Presentation classes because it had no authorized workflow.

I1 is the first demonstrated use case that justifies these focused contracts. It does not justify a generic repository, service locator, command bus, Rails engine, or broad Organization service API.

## 5. Bounded-context responsibilities

### 5.1 Organization Domain

Organization Domain remains framework-independent. Existing entities continue to represent Organization/Brand/Branch identity and relationships.

I1 introduces no new business behavior into the Domain. Brand ancestry is already represented by `Brand#organization_id`; the Application query coordinates retrieval of authoritative persisted facts.

### 5.2 Organization Application

`TECHNICAL_PROPOSAL`: Organization Application owns:

- the published `ResolveBrandAncestry` query contract;
- input validation at the published Application boundary;
- the focused outbound `BrandAncestryReader` persistence port;
- mapping persistence facts into immutable public Application values;
- typed public outcomes;
- fail-closed containment of recognized persistence availability failures at the published boundary.

Organization Application does not decide why a caller wants the ancestry or whether an Actor may access a Brand.

Unexpected programming defects are not normal query outcomes and must not be caught and relabeled as availability failures. They terminate the call exceptionally through a sanitized signal outside the five-outcome union. The concrete Ruby mechanism and any diagnostic boundary remain mandatory unresolved implementation constraints in §13.

### 5.3 Organization Infrastructure

`TECHNICAL_PROPOSAL`: Organization Infrastructure implements only the Organization-owned `BrandAncestryReader` port. It uses existing A1 persistence and returns minimal persistence facts rather than an Active Record object.

The adapter performs an exact Brand lookup that verifies the Organization parent relationship. An implementation may use a join or equivalent database query, but the mechanism must distinguish a missing Brand from an impossible missing parent. The adapter does not implement an Identity-owned port and does not return authorization trust.

### 5.4 Identity Application

`TECHNICAL_PROPOSAL`: Identity Application owns the outbound `OrganizationScope` port required by its future use cases. It depends only on that Identity-owned contract and Identity values.

Identity Application does not depend on the Organization Application implementation, Organization Infrastructure, Active Record, or A1 persistence classes.

### 5.5 Identity Infrastructure

`TECHNICAL_PROPOSAL`: Identity Infrastructure implements the Identity-owned `OrganizationScope` port. Its cross-context adapter:

1. accepts the Identity port's typed Brand reference;
2. calls the Organization Application published query;
3. maps the Organization-owned public result into Identity-owned immutable values/outcomes; and
4. exposes no Organization persistence type or database exception to Identity Application.

The adapter supplies ancestry evidence only. It never turns a successful lookup into an authorization decision.

### 5.6 Composition Root

The Composition Root selects and wires:

- Organization Infrastructure's `BrandAncestryReader` implementation into Organization Application;
- the Organization Application published query into the Identity Infrastructure cross-context adapter; and
- that Identity Infrastructure adapter into Identity Application's `OrganizationScope` port.

The Composition Root owns no lookup, validation, mapping, or authorization behavior.

## 6. Exact proposed contracts

Names below are exact proposed Ruby constants within the Gate A-approved design baseline and remain `TECHNICAL_PROPOSAL`: Gate A approval does not make them implemented or grant Gate B authorization. A later bounded Gate B decision must name the authorized implementation files and may not silently amend the approved ownership or semantics.

### 6.1 Identifier type

A1 persists identifiers as PostgreSQL UUIDs. I1 therefore uses immutable UUID-backed references:

| Type | Meaning |
|---|---|
| `IdentityBrandReference` | One validated Brand UUID in the Identity Application contract, used only as a lookup identity. |
| `IdentityOrganizationReference` | One validated Organization UUID in the Identity Application result. |
| `BrandReference` | One validated Brand UUID in the Organization Application contract, used only as a lookup identity. |
| `OrganizationReference` | One validated immutable Organization UUID returned from authoritative ancestry. |

Identity Application's `OrganizationScope` port accepts only an `IdentityBrandReference`. Organization Application's published query and its persistence port accept only a `BrandReference`. Neither Application contract accepts a raw string or unvalidated candidate.

Raw textual parsing belongs to the future consumer's untrusted-input boundary, outside I1. That boundary parses and validates once, then constructs an immutable typed reference before calling I1. I1 has no public endpoint, parser, controller, generic input adapter, or HTTP/request parsing contract. The future consumer owns the behavior and tests for malformed raw input; no I1 result is created when that consumer cannot construct a reference.

A successfully constructed I1 reference represents one valid canonical UUID value and is immutable. I1 Application and persistence contracts accept only the appropriate context-owned reference object. They enforce the object/type precondition but never parse or reparse a raw string. Supplying a raw string or another unvalidated value directly to an I1 contract violates that precondition, produces `invalid`, and must not invoke the next Application port or persistence.

`TECHNICAL_PROPOSAL`: the standard 36-character hyphenated hexadecimal UUID representation remains the proposed future external textual convention. A future consumer's parser converts accepted text into a canonical UUID value without assigning UUID-version semantics; the I1 reference constructor validates and stores that canonical value. The exact I1 constructor API, canonical-value representation, Ruby constant, and internal precondition error representation are Gate B implementation details. Parser library and textual-input failure handling belong to the future consumer, not Gate B for I1. Typed-reference construction must remain framework-independent and cannot depend on Rails, Active Record, or a persistence record.

Identity Infrastructure maps an `IdentityBrandReference` to a new `BrandReference` explicitly from the already validated canonical UUID value. This is value mapping, not a second parse of untrusted text. If mapping completes and produces a returned value that violates the target reference contract, the completed result is adapter/result inconsistency. If mapping execution itself raises or otherwise fails unexpectedly, it is an unexpected internal defect and terminates exceptionally; the adapter must not convert it to `inconsistent` or `unavailable`.

### 6.2 Organization Application published query

Conceptual request:

```text
ResolveBrandAncestryRequest
  brand_id: BrandReference
```

No raw candidate, `organization_id`, Actor, Session, role, capability, delegation, or client-asserted scope field is accepted. The query performs a contract precondition guard for the required typed reference but does not parse raw text. A caller that violates the typed contract receives `invalid`; persistence is not invoked.

Conceptual successful value:

```text
BrandAncestry
  brand_id: BrandReference
  organization_id: OrganizationReference
```

The successful value is immutable, contains only scalar identity values, and is detached from Active Record. It does not include names, timestamps, `lock_version`, Branches, owners, capabilities, or authorization conclusions.

Conceptual result union:

```text
ResolveBrandAncestryResult =
  resolved(BrandAncestry)
  | not_found
  | invalid
  | inconsistent
  | unavailable(failure_reference: SafeFailureReference)
```

`SafeFailureReference` is an opaque correlation value required only for an `unavailable` result. It is not an exception, database identifier, audit identifier, or authorization evidence. It must not contain SQL, credentials, connection details, record contents, stack traces, or exceptions.

`unavailable` is reserved for a recognized availability failure: query timeout, lost database connection, unavailable connection pool/database, or another persistence condition explicitly approved as availability-related. The boundary that first records such a failure is responsible for obtaining the reference through an approved internal failure-reporting mechanism:

- Organization Infrastructure obtains the reference when it first records a recognized persistence availability failure and returns it through the Organization-owned persistence port.
- Organization Application preserves an existing reference unchanged.
- Identity Infrastructure preserves the same originating reference when mapping `unavailable` into the Identity-owned result. It must not fabricate or replace a reference and break correlation.

Reference generation, storage, retention, lookup, and telemetry technology remain Gate B implementation details. This design introduces no logging service, event store, telemetry package, or audit dependency. `not_found`, `invalid`, and `inconsistent` carry no `SafeFailureReference`.

An unexpected programming defect, `NoMethodError`, violated internal invariant, exception during internal mapping, or unrecognized adapter exception is not a recognized availability failure. It produces no result-union value and no fabricated `SafeFailureReference`; execution terminates exceptionally through a sanitized signal with no partial ancestry. Only the fact of exceptional termination may cross the Application contract. The underlying exception, message, SQL, stack trace, credentials, connection information, or protected data must not cross it. The concrete Ruby signal, containment point, and diagnostic mechanism remain unresolved implementation constraints in §13 and must be approved before Gate B can authorize implementation.

### 6.3 Organization-owned persistence port

Conceptual request:

```text
ReadBrandAncestry
  brand_id: validated BrandReference
```

Only a previously validated `BrandReference` may reach this port. Organization Infrastructure performs no raw-text parsing.

Conceptual port result:

```text
PersistedBrandAncestryResult =
  found(PersistedBrandAncestryFact)
  | not_found
  | inconsistent
  | unavailable(failure_reference: SafeFailureReference)

PersistedBrandAncestryFact
  brand_id: BrandReference
  organization_id: OrganizationReference
```

The port is query-specific, not a generic repository. It supports no create, update, delete, enumeration, ownership, or authorization operation.

### 6.4 Identity-owned OrganizationScope port

Conceptual request:

```text
ResolveOrganizationScope
  brand_id: IdentityBrandReference
```

Conceptual success value:

```text
OrganizationScopeEvidence
  brand_id: IdentityBrandReference
  organization_id: IdentityOrganizationReference
```

Conceptual result union:

```text
OrganizationScopeResult =
  resolved(OrganizationScopeEvidence)
  | not_found
  | invalid
  | inconsistent
  | unavailable(failure_reference: SafeFailureReference)
```

The Identity values are owned by Identity Application. The Infrastructure adapter performs explicit mapping from the Organization Application public values; Identity Application does not import Organization Infrastructure types.

The Identity port performs a contract precondition guard for `IdentityBrandReference` but no raw parsing. Identity Infrastructure maps its canonical UUID value into a `BrandReference`, calls Organization Application, and maps the successful Organization references back into Identity-owned immutable values.

Classification depends on whether adapter execution completed. A completed Organization result that is malformed, contradictory, or contains invalid required values maps to public `inconsistent`. An exception or other unexpected failure while the Identity adapter is executing or mapping is an internal defect and terminates exceptionally outside the result union. It is not `inconsistent` merely because it occurred inside an adapter.

`OrganizationScopeEvidence` is not `TrustedIdentityContext`, `TrustedCatalogTarget`, or `AuthorizationContext`. A resolved result does not mean an Actor belongs to, owns, or may act within either identifier.

### 6.5 Outcome mapping

| Organization query outcome | Identity port outcome | Required interpretation |
|---|---|---|
| `resolved` | `resolved` | Current ancestry evidence only. |
| `not_found` | `not_found` | No Brand exists for the valid identifier at the query snapshot. |
| `invalid` | `invalid` | The caller violated the typed-reference precondition; no persistence query occurs. A raw-input construction failure occurs before this mapping table is entered. |
| `inconsistent` | `inconsistent` | Persisted-state or adapter/result facts violate the required ancestry shape; deny and return no partial result. |
| `unavailable(reference)` | `unavailable(same reference)` | A recognized persistence availability failure prevented an authoritative answer; preserve the originating correlation reference and do not substitute cache/client data. |

No outcome is automatically converted into a public HTTP status because I1 has no Presentation surface.

Unexpected internal defects are outside this normal outcome mapping. They terminate the call exceptionally through the sanitized contract defined in §9 and cannot be mapped to any row. Section 13 keeps only the concrete implementation and diagnostic mechanisms unresolved.

## 7. Dependency direction

```text
Identity Application
        |
        +-- owns/depends on --> Identity OrganizationScope port
                                      ^
                                      |
Identity Infrastructure -- implements+
        |
        +-- calls --> Organization Application published query
                              |
                              +-- owns/depends on --> Organization BrandAncestryReader port
                                                            ^
                                                            |
Organization Infrastructure ------------------- implements-+
        |
        +-- uses --> A1 Organization persistence records

Composition Root wires implementations; it owns no behavior.
Domain layers depend on no outer layer.
```

Forbidden dependencies:

- Identity Application or Domain -> Organization Infrastructure;
- Identity Application or Domain -> Active Record;
- Organization Application -> Identity;
- Organization Infrastructure -> Identity-owned port;
- either Domain -> Application/Infrastructure/Rails/PostgreSQL;
- cross-context direct access to `BrandRecord` or `OrganizationRecord`;
- Composition Root -> embedded lookup or authorization policy.

## 8. Request/response sequence

```text
Future untrusted-input boundary
    |
    | parse/validate once; construct IdentityBrandReference
    v
Identity Application
    |
    | ResolveOrganizationScope(identity_brand_reference)
    v
Identity Infrastructure adapter
    |
    | map canonical UUID value to BrandReference
    | ResolveBrandAncestry(brand_reference)
    v
Organization Application
    |
    | enforce typed-reference precondition; no raw parsing
    | ReadBrandAncestry(typed_brand_id)
    v
Organization Infrastructure adapter
    |
    | exact persisted Brand + Organization-parent query
    v
PostgreSQL A1 tables
    |
    | minimal fact / missing / failure
    v
Organization Application
    |
    | immutable BrandAncestry or typed failure
    v
Identity Infrastructure adapter
    |
    | map to Identity-owned values
    v
Identity Application
```

The future untrusted-input boundary shown above is illustrative context and is outside the I1 implementation and test slice. The I1 call begins only after typed-reference construction. It is synchronous, in-process, read-only, and request/operation-scoped. It performs no background work and creates no durable authorization evidence. I1 defines no cross-request cache. A later consumer that needs current ancestry must resolve it at its own required validation/revalidation point.

At PostgreSQL `READ COMMITTED`, the query observes its statement snapshot. I1 does not promise that ancestry remains unchanged after return. If Organization/Brand reassignment is ever authorized, its locking/versioning and consumer revalidation contract require separate design.

## 9. Failure semantics

The public `inconsistent` outcome has two internal classifications. They are contract classifications, not proof that a diagnostic event has been recorded, not additional public outcomes, and not authorization decisions:

- **Persisted-state inconsistency:** persisted facts violate the ancestry invariant, including an impossible null/missing Organization parent, ambiguous/duplicate exact-Brand facts despite the primary key, or another contradictory persisted relationship.
- **Adapter/result inconsistency:** adapter execution completes and returns a Brand ID different from the requested Brand ID, omits the required Organization ID, returns an invalid typed value, or returns a malformed/contradictory result shape.

Both classifications return public `inconsistent`, produce no partial ancestry, and fail closed. Neither is mapped to `not_found` or `unavailable` merely for convenience. An explicitly approved diagnostic boundary may record the classification, but it must not expose protected record data or database details; without such a boundary, no recording is claimed.

An adapter execution defect is categorically different. If execution raises `NoMethodError`, encounters an unexpected exception during mapping, violates an internal invariant before producing a completed result, or otherwise fails unexpectedly, there is no adapter result to classify as inconsistent. The call terminates exceptionally under the contract below.

### 9.1 Exceptional-termination contract

Unexpected internal defects are outside the five-outcome result union. The semantic contract is final for this proposal:

- the call terminates exceptionally rather than returning a normal result;
- no partial ancestry or normal outcome is returned;
- the caller must not interpret termination as authoritative absence, inconsistency, or recognized availability failure;
- no `SafeFailureReference` is fabricated;
- only a sanitized indication that the call terminated exceptionally may cross an Application contract;
- the underlying exception object and its class/message, SQL, credentials, connection information, protected record data, and stack trace must not cross an Application contract.

Diagnostic handling is separate from the Application result contract. A future authorized internal boundary may record sanitized diagnostic evidence, but it must not turn the defect into a normal result. This design assumes no existing logger, telemetry service, outer error boundary, correlation mechanism, storage technology, or particular Ruby exception class. If no diagnostic boundary has been explicitly approved and wired, the design makes no claim that the defect was logged, stored, or correlated.

Before Gate B, a bounded implementation decision must identify the sanitized Ruby termination signal, the boundary that converts underlying defects to that signal without leaking details, and any separately authorized diagnostic boundary. The five normal outcomes do not change when that mechanism is selected.

| Condition | Internal classification | Public outcome | Behavior |
|---|---|---|---|
| Empty, malformed, wrong-shape, or non-UUID Brand candidate at a future consumer's untrusted boundary | Consumer-owned parsing/construction failure | Outside I1; no I1 outcome | The future consumer applies its own failure contract and does not call either I1 Application contract or persistence. |
| Wrong object/type supplied in violation of an internal typed-reference precondition | Contract precondition failure | `invalid` | Reject without parsing raw input and without querying persistence. |
| Valid UUID with no Brand row | Authoritative absence | `not_found` | Return no ancestry and no substitute. |
| Brand row and valid Organization parent | Valid persisted facts | `resolved` | Return exactly the two immutable identifiers. |
| Brand row has null parent | Persisted-state inconsistency | `inconsistent` | Impossible under current non-null constraint; return no partial ancestry. |
| Brand references missing Organization | Persisted-state inconsistency | `inconsistent` | Impossible under the enforced FK for committed state; return no partial ancestry; record diagnostics only through an explicitly approved boundary. |
| Exact lookup yields ambiguous/duplicate facts | Persisted-state inconsistency | `inconsistent` | Impossible under Brand PK; return no partial ancestry and report safely. |
| Returned Brand ID differs from requested Brand ID | Adapter/result inconsistency | `inconsistent` | Reject the complete result; do not substitute the requested ID. |
| Required Organization ID is missing or a returned typed value/result shape is invalid or contradictory | Adapter/result inconsistency | `inconsistent` | Reject the complete result; do not return partial evidence. |
| Query timeout, lost connection, unavailable pool/database, or another explicitly approved persistence availability condition | Recognized availability failure | `unavailable(reference)` | Organization Infrastructure records the failure and obtains the safe reference; never reinterpret as `not_found`. |
| Identity maps an existing Organization `unavailable(reference)` | Propagated unavailable failure | `unavailable(same reference)` | Preserve the original reference; do not generate a replacement. |
| Programming defect, `NoMethodError`, violated internal invariant, exception during internal mapping, or unexpected/unrecognized adapter exception | Unexpected internal defect during execution | No result-union value; sanitized exceptional termination | Abort fail closed, return no partial ancestry, do not return any normal outcome, and do not fabricate a `SafeFailureReference`. Diagnostic recording occurs only if a separately approved internal boundary exists. |

Raw Infrastructure exceptions, SQL text, relation names, credentials, connection addresses, stack traces, protected record data, and other underlying defect details do not cross either Application contract.

The published query must not rescue a defect as a successful empty result or classify it as availability merely because the call failed. `not_found` is reserved for an executed authoritative lookup that found no Brand. `inconsistent` is reserved for contradictory persisted facts or completed adapter results. `unavailable` is reserved for recognized persistence availability conditions. Exceptional termination is reserved for unexpected execution defects. The semantic distinction is fixed; Gate B remains blocked until §13's concrete containment and diagnostic mechanisms are approved.

## 10. Trust and security invariants

1. Client-supplied Organization or Brand values are never trusted authorization context.
2. Brand ID is a lookup key only.
3. The request has no Organization field that could override persisted ancestry.
4. Resolved Brand ancestry establishes neither Organization ownership nor Brand ownership.
5. Resolved ancestry grants no role, capability, delegation, Branch Assignment, Catalog authority, or access.
6. `OrganizationScopeEvidence` is not an `AuthorizationContext`.
7. I1 evaluates no Actor, Owner, Subject, Grantor/authority source, User, Employee, Session, role, capability, delegation, MFA evidence, or assignment.
8. Missing, invalid, ambiguous, inconsistent, or unavailable ancestry fails closed.
9. No partial ancestry value is returned.
10. No Active Record object or lazy association crosses an Application contract.
11. No public endpoint or browser contract is introduced.
12. A caller must independently possess trusted identity/scope and perform its own authorized comparison; I1 never returns `allowed` or `denied`.
13. Single-Organization or single-Brand deployment is never used as an authorization shortcut.
14. A future consumer parses raw input once before I1 typed-reference construction; no I1 Application or persistence contract parses raw text.
15. Identity Infrastructure maps typed values explicitly and does not replay untrusted text into Organization Application.
16. Where an explicitly approved diagnostic mechanism exists, logs and metrics use sanitized normal-outcome categories/references and never serialize persistence objects or underlying exception details. Unexpected defects have no normal outcome category or `SafeFailureReference`; any separately approved defect diagnostics must remain outside the Application result contract.
17. An existing `SafeFailureReference` is propagated unchanged; a new one is obtained only by Organization Infrastructure when first recording a recognized persistence availability failure.

## 11. Test strategy and acceptance criteria

No test is executed by this design milestone. Future tests must follow the repository's RSpec conventions and use real PostgreSQL where persistence semantics matter.

### 11.1 Typed-reference and Organization Application unit tests

- successfully constructed references contain a valid canonical UUID value and are immutable;
- a raw string or unvalidated value supplied directly to either I1 Application contract violates the typed-reference precondition, yields `invalid`, and does not invoke the next port or persistence;
- Identity Application's port accepts only `IdentityBrandReference` and Organization Application's query accepts only `BrandReference`;
- valid typed `BrandReference` input invokes the persistence port once without raw-text parsing;
- a wrong object/type supplied to either internal contract returns `invalid` without calling persistence;
- Identity Infrastructure maps the canonical UUID value from `IdentityBrandReference` into a new `BrandReference` without replaying raw input;
- each persistence outcome maps to the exact public outcome;
- `resolved` returns immutable scalar values only;
- `inconsistent` and `unavailable` never return a partial Organization ID;
- persisted-state inconsistency and a completed malformed/contradictory adapter result both map to public `inconsistent` and never to `not_found` or `unavailable`;
- recognized persistence availability failures alone become `unavailable(reference)` and obtain one reference through the approved Organization Infrastructure failure-reporting boundary;
- an adapter double that returns a malformed or contradictory completed result produces `inconsistent` with no partial ancestry;
- an adapter double that raises `NoMethodError` or another unexpected execution defect causes sanitized exceptional termination and cannot become success, `not_found`, `invalid`, `inconsistent`, or fabricated `unavailable`;
- unexpected internal defects create no `SafeFailureReference` and expose no underlying exception, SQL, stack trace, credential, connection, protected-data, or partial-ancestry detail through either Application contract;
- `not_found`, `invalid`, and `inconsistent` contain no `SafeFailureReference`;
- no outcome expresses ownership, capability, or authorization.

### 11.2 Organization persistence adapter integration tests

- existing Brand resolves to its actual persisted Organization;
- unknown valid Brand UUID returns `not_found`;
- multiple Organizations and Brands resolve independently without default-Organization fallback;
- selected fields do not expose names, timestamps, lock versions, associations, or persistence records;
- recognized database unavailability maps to `unavailable` at the contract boundary;
- current database constraints prove null/missing parent and duplicate Brand identity cannot be created through ordinary test setup;
- focused adapter doubles produce null/missing parent, duplicate/ambiguous facts, wrong requested Brand identity, missing Organization identity, invalid typed values, and contradictory result shapes to prove both internal `inconsistent` classifications without corrupting the database.

Tests must not disable constraints or mutate production data merely to manufacture impossible ancestry.

### 11.3 Identity adapter contract tests

- adapter maps Organization `resolved` into Identity-owned immutable evidence;
- unknown, invalid, inconsistent, and unavailable remain distinct typed outcomes;
- an existing Organization `unavailable(reference)` maps to Identity `unavailable` with the exact same reference;
- a completed Organization result with a wrong Brand, missing Organization, invalid typed value, or malformed/contradictory shape maps to Identity `inconsistent` with no partial evidence;
- an exception during Identity adapter execution or value mapping causes sanitized exceptional termination, not `inconsistent` or `unavailable`, and cannot manufacture a failure reference;
- planned tests assert only the contract behavior; they do not assume or test an unapproved logger, telemetry library, exception class, correlation mechanism, or diagnostic store;
- client-provided Organization data has no input field and cannot override the result;
- Organization public values are copied/mapped rather than leaked as persistence or mutable objects;
- a resolved result still carries no `allowed`, role, capability, ownership, or delegation state.

### 11.4 Architecture and dependency tests

- Identity Application references only its owned `OrganizationScope` contract;
- Identity Application and Domain do not reference Organization Infrastructure, Active Record, or A1 record constants;
- Identity Infrastructure implements the Identity-owned port and may depend on the Organization Application public contract only;
- Organization Infrastructure implements only Organization-owned ports;
- Organization Application does not depend on Identity;
- Domain namespaces remain framework-independent;
- Composition Root performs wiring only;
- Zeitwerk/eager-load checks cover any future authorized constants;
- no controller, route, serializer, job, migration, or schema object is added by the I1 implementation slice unless a later authorization explicitly expands scope.

### 11.5 Contract acceptance criteria

I1 implementation evidence would be acceptable for later Control Acceptance only when:

- every outcome above is deterministic and tested;
- real PostgreSQL proves the existing Brand→Organization relationship is used;
- no direct cross-context persistence access exists;
- no Active Record object crosses the public contract;
- I1 rejects raw strings/unvalidated objects supplied in violation of its typed-reference preconditions, while raw textual parsing behavior remains the future consumer's responsibility and acceptance scope;
- database failures remain distinguishable from absence without leaking details;
- recognized persistence availability failures obtain one safe correlation reference and every downstream mapping preserves it unchanged;
- completed invalid adapter results produce `inconsistent`, while adapter execution defects produce sanitized exceptional termination with no normal result, partial ancestry, protected diagnostic detail, or fabricated availability failure;
- Gate B remains blocked until the concrete sanitized termination/containment mechanism and any diagnostic boundary are explicitly approved;
- both internal inconsistency classifications produce the same fail-closed public `inconsistent` outcome without partial ancestry;
- multiple Organization/Brand fixtures prove there is no single-tenant fallback;
- architecture tests prove port ownership and dependency direction;
- full relevant RSpec, lint, security, and eager-load checks actually pass under the later authorized milestone;
- evidence records the commit, environment, command, result, reviewer, findings, and residual limitations.

Planned tests and this design are not executed evidence.

## 12. Explicit exclusions

The following remain unavailable through I1:

- User/Session and all authentication behavior;
- credentials, password, PIN, cookie, CSRF, MFA, and recovery;
- Organization/Brand Owner representation and authority;
- role, capability, assignment, delegation, approval, or self-approval logic;
- Catalog target identity, Catalog entity→Brand proof, and `TrustedCatalogTarget`;
- Category/Variant lifecycle, Package C commands, reason validation, and Default handling;
- P2 AuditEvent representation or append;
- P3 database roles or operation boundary;
- public endpoints, frontend behavior, schema/migrations, provisioning/mutation, production configuration, deployment, or data changes.

P1-OD-01 through P1-OD-05 remain `OWNER_DECISION_REQUIRED`. `C0-R05`, `C0-R08`, and `C0-R11` remain `DEFERRED`. CAT-TRR statuses and every Identity Security Review Checklist status remain unchanged.

## 13. Unresolved questions and assumptions

| Item | Classification | Current boundary |
|---|---|---|
| Exact Ruby constant and file names listed in §14 | `TECHNICAL_PROPOSAL` | They are part of the Gate A-approved design baseline and the proposed bounded scope for a later Gate B authorization; no implementation file exists or is authorized yet. |
| Sanitized exceptional-termination implementation mechanism | `UNRESOLVED` mandatory Gate B implementation constraint | The semantic contract is fixed in §9.1: unexpected defects terminate exceptionally outside the five outcomes with no partial ancestry or leaked detail. Gate B must name the concrete sanitized Ruby signal and the containment boundary that prevents underlying defect details from crossing an Application contract. |
| Unexpected-defect diagnostic boundary | `UNRESOLVED` mandatory Gate B implementation constraint | No logger, telemetry service, outer error boundary, correlation mechanism, storage technology, or exception class is assumed. Gate B must either authorize and name a sanitized internal diagnostic boundary or explicitly record that I1 provides no diagnostic recording; neither choice may convert a defect into a normal result. |
| Typed-reference constructor API | `UNRESOLVED` implementation constraint | I1 types represent valid canonical UUID values and are immutable. Gate B must select the framework-independent constructor/value mechanism; the future consumer separately owns any raw-input parser and its tests. |
| Raw UUID textual forms beyond standard hyphenated form | `TECHNICAL_PROPOSAL` | Standard hyphenated text remains the proposed external convention, but parsing occurs before I1 and no public API format is established. |
| Safe internal failure-reporting/reference mechanism | `UNRESOLVED` implementation detail | Organization Infrastructure must obtain one opaque reference when it first records a recognized persistence availability failure, and downstream adapters preserve it; generation, storage, retention, lookup, and telemetry technology remain unselected. |
| Future caching | `OUT_OF_SCOPE` | No cache is authorized; later caching requires staleness/invalidation review. |
| Brand reassignment or Organization lifecycle | `OUT_OF_SCOPE` and not authorized | I1 reports the current statement snapshot only. |
| Transaction/locking across a future authorization operation | `OUT_OF_SCOPE` | P1/Package C must re-resolve at their required validation point. |
| External service/API transport | `OUT_OF_SCOPE` | Contract is in-process inside the Rails modular monolith. |
| Result versioning for future consumers | `UNRESOLVED` | Initial internal contract has one minimal shape; compatibility rules require review before expansion. |

Assumptions supported by current evidence:

- PostgreSQL foreign keys and primary keys remain enabled;
- Organization, Brand, and Branch continue to use UUID identity;
- current A1 ancestry is read-only for this scope;
- the modular monolith uses in-process Application contracts rather than network calls.

If any assumption changes, I1 requires design revalidation rather than silently widening the contract.

## 14. Concrete future implementation plan

This section is a `TECHNICAL_PROPOSAL`, not an implementation authorization. Paths follow the accepted project-wide layered layout already used by A1. The repository currently has no Organization/Identity Application implementation and no dependency-injection container; the plan therefore adds only the seams required by this use case and does not invent a service locator, initializer registry, or generic repository.

### 14.1 Exact proposed production files

| Proposed file | Proposed constant and responsibility |
|---|---|
| `backend/app/domains/organization/application/contracts/brand_reference.rb` | `Organization::Application::Contracts::BrandReference`: immutable, framework-independent validated UUID value used by the Organization contract. |
| `backend/app/domains/organization/application/contracts/organization_reference.rb` | `Organization::Application::Contracts::OrganizationReference`: immutable validated Organization UUID value. |
| `backend/app/domains/organization/application/contracts/safe_failure_reference.rb` | `Organization::Application::Contracts::SafeFailureReference`: immutable opaque correlation value; validates only the approved internal representation and contains no diagnostic payload. |
| `backend/app/domains/organization/application/contracts/brand_ancestry.rb` | `Organization::Application::Contracts::BrandAncestry`: immutable success value containing exactly `BrandReference` and `OrganizationReference`. |
| `backend/app/domains/organization/application/contracts/resolve_brand_ancestry_result.rb` | `Organization::Application::Contracts::ResolveBrandAncestryResult`: closed constructors/predicates for `resolved`, `not_found`, `invalid`, `inconsistent`, and `unavailable`; only `unavailable` carries `SafeFailureReference`. |
| `backend/app/domains/organization/application/ports/brand_ancestry_reader.rb` | `Organization::Application::Ports::BrandAncestryReader`: query-specific persistence protocol and its minimal found/not-found/inconsistent/unavailable result contract. It exposes no CRUD or Active Record type. |
| `backend/app/domains/organization/application/queries/resolve_brand_ancestry.rb` | `Organization::Application::Queries::ResolveBrandAncestry`: injected-reader query boundary; enforces the typed precondition, maps persistence facts/completed results, preserves recognized availability references, and returns only the published result union. It must convert unexpected underlying execution defects only through the later-approved sanitized termination mechanism, never into a normal result. |
| `backend/app/domains/organization/infrastructure/persistence/active_record_brand_ancestry_reader.rb` | `Organization::Infrastructure::Persistence::ActiveRecordBrandAncestryReader`: implements the Organization-owned reader with an exact `BrandRecord`/Organization-parent query and minimal scalar projection. It records recognized availability failures through the later-approved internal failure mechanism and returns no record object. |
| `backend/app/domains/identity/application/contracts/identity_brand_reference.rb` | `Identity::Application::Contracts::IdentityBrandReference`: immutable, framework-independent validated Brand UUID value owned by Identity. |
| `backend/app/domains/identity/application/contracts/identity_organization_reference.rb` | `Identity::Application::Contracts::IdentityOrganizationReference`: immutable validated Organization UUID value owned by Identity. |
| `backend/app/domains/identity/application/contracts/safe_failure_reference.rb` | `Identity::Application::Contracts::SafeFailureReference`: Identity-owned immutable wrapper for the unchanged opaque correlation value received from Organization for a recognized persistence availability failure. |
| `backend/app/domains/identity/application/contracts/organization_scope_evidence.rb` | `Identity::Application::Contracts::OrganizationScopeEvidence`: immutable success value containing exactly the Identity Brand and Organization references. |
| `backend/app/domains/identity/application/contracts/organization_scope_result.rb` | `Identity::Application::Contracts::OrganizationScopeResult`: Identity-owned five-outcome result union with the same semantics as §6.4. |
| `backend/app/domains/identity/application/ports/organization_scope.rb` | `Identity::Application::Ports::OrganizationScope`: Identity-owned outbound protocol accepting only `IdentityBrandReference`. It does not define authentication or authorization. |
| `backend/app/domains/identity/infrastructure/adapters/organization_scope_adapter.rb` | `Identity::Infrastructure::Adapters::OrganizationScopeAdapter`: implements the Identity-owned port, maps typed UUID values explicitly, calls the Organization Application query, preserves unavailable reference content unchanged, maps completed invalid Organization results to `inconsistent`, and propagates sanitized exceptional termination without converting it to a normal outcome. |

Each file has one primary constant, matching current repository naming practice. The exact method shape proposed for callable query/adapter objects is an injected constructor plus `#call`; result construction uses named constructors matching the five outcome names. No class method, global singleton, Rails concern, ActiveSupport dependency, or shared cross-context value-object package is required.

The typed-reference constructor/value mechanism, sanitized exceptional-termination implementation mechanism, any diagnostic boundary, and internal availability-failure reporting/reference mechanism must be resolved and named before Gate B can authorize coding. They are deliberately not represented as extra files above because current canonical documents and repository code do not establish approved implementations. Gate B may add only narrowly necessary context-owned helper/port/adapter files after recording their exact paths; it may not silently introduce a telemetry framework or a raw-input Presentation adapter. A future consumer—not I1—must separately authorize and test any raw UUID parser.

### 14.2 Dependency and wiring changes

The ordered dependency construction is:

1. construct `ActiveRecordBrandAncestryReader` with the approved internal failure-reporting boundary;
2. inject that reader into `ResolveBrandAncestry`;
3. inject the published query into `OrganizationScopeAdapter`; the adapter preserves recognized availability references but does not translate its own defects into availability;
4. expose the adapter only as the `Identity::Application::Ports::OrganizationScope` implementation to a future authorized Identity consumer.

This wiring list assumes no diagnostic component. Gate B must separately identify the sanitized exceptional-termination containment point and state whether an approved internal diagnostic boundary is wired. Absence of such a boundary means no diagnostic recording may be claimed; it does not alter exceptional termination semantics.

I1 has no authorized runtime consumer, controller, job, or public endpoint. Consequently, this bounded slice proposes no production Composition Root file or initializer. Contract and integration specs compose the object graph explicitly. A later P1/Identity implementation authorization must name its real Composition Root and wire this adapter there; wiring must not be hidden in either Application layer or in Active Record models.

No existing A1 entity or persistence record needs modification. `BrandRecord` remains an Infrastructure detail used only by the new Organization reader. The existing global `TrustedActor` helper is not reused: it carries actor semantics, accepts a narrower UUID-version pattern, and is not a context-owned ancestry reference.

### 14.3 Exact proposed test files

| Proposed test file | Planned evidence |
|---|---|
| `backend/spec/domains/organization/application/queries/resolve_brand_ancestry_spec.rb` | Typed-reference preconditions, immutability, all five normal mappings, both inconsistency classifications through focused doubles, no partial values, availability-reference preservation, and proof that unexpected defects are not converted into normal results. |
| `backend/spec/domains/organization/infrastructure/persistence/active_record_brand_ancestry_reader_spec.rb` | Real PostgreSQL Brand→Organization lookup, unknown Brand, multiple Organization/Brand isolation, minimal scalar projection, recognized unavailability, and proof from existing constraints without disabling them. |
| `backend/spec/domains/identity/infrastructure/adapters/organization_scope_adapter_spec.rb` | Explicit Identity↔Organization typed-value mapping, all five normal outcomes, unchanged unavailable-reference content, proof that adapter defects do not manufacture availability results, and absence of authorization/Active Record leakage. |
| `backend/spec/architecture/i1_dependency_spec.rb` | Constant/source dependency checks for inward direction, port ownership, prohibited Active Record/cross-context record references, framework-independent Application contracts, and absence of new Presentation/schema surfaces. |

The existing `backend/spec/factories/reference_foundation.rb` factories are sufficient for PostgreSQL integration scenarios and are not proposed for modification. Tests create multiple Organizations and Brands explicitly so a single-tenant fallback cannot pass accidentally. No test disables a foreign key, non-null constraint, or primary-key uniqueness rule.

### 14.4 Ordered implementation steps for a later Gate B authorization

1. Use the recorded Gate A approval above as the immutable semantic baseline for a separate bounded implementation request.
2. Record Gate B only after it names the sanitized exceptional-termination signal and containment point, states whether an authorized diagnostic boundary exists, and fixes the exact files above, typed-reference constructor/value mechanism, availability-failure reporting/reference mechanism, implementer/reviewer, environment, exclusions, and evidence destination. Raw-input parsing remains outside I1.
3. Add Organization and Identity immutable contract values and their focused unit examples.
4. Add the Organization persistence port and query, then its unit examples.
5. Add the Active Record reader and real-PostgreSQL integration examples using existing A1 factories.
6. Add the Identity-owned port and Infrastructure adapter, then adapter contract examples.
7. Add architecture/dependency examples and run Zeitwerk eager-load validation.
8. Run the focused suite, full backend verification, and record actual evidence; do not change governance status from planned checks alone.

### 14.5 Commands for the later authorized implementation

Run from `backend/` only after Gate B authorization:

```bash
bundle exec rspec \
  spec/domains/organization/application/queries/resolve_brand_ancestry_spec.rb \
  spec/domains/organization/infrastructure/persistence/active_record_brand_ancestry_reader_spec.rb \
  spec/domains/identity/infrastructure/adapters/organization_scope_adapter_spec.rb \
  spec/architecture/i1_dependency_spec.rb
bin/rails zeitwerk:check
bin/rubocop
bundle exec brakeman --quiet --no-pager --exit-on-warn --exit-on-error
bundle exec rspec
bin/ci
```

`bin/ci` also performs setup, dependency audit, seed verification, and the full RSpec suite under the repository's current CI definition. The later implementation report must record commands actually executed, PostgreSQL/runtime versions, example/failure counts, lint/security results, and any network/environment limitation. This design task executes none of these commands.

### 14.6 Expected observable acceptance evidence

- a known persisted Brand resolves to the exact persisted parent Organization and an unknown valid Brand resolves only to `not_found`;
- raw strings/unvalidated objects supplied directly to I1 violate typed-reference preconditions and reach neither the next port nor database; future consumer parsing is not I1 acceptance evidence;
- all five normal results are distinguishable and exhaustive for represented conditions at both Application boundaries;
- unavailable correlation content is generated once by Organization Infrastructure when it first records a recognized persistence availability failure and remains byte-for-byte unchanged through downstream mapping;
- an adapter that completes with a malformed or contradictory result produces `inconsistent` with no partial ancestry;
- an adapter execution defect terminates exceptionally with no normal result, partial ancestry, leaked underlying details, or fabricated `SafeFailureReference`;
- evidence does not claim logging, telemetry, storage, or correlation for unexpected defects unless Gate B explicitly authorized and named that diagnostic boundary;
- both inconsistency categories fail closed with no partial Organization value;
- multiple Organization/Brand records prove no default, first-record, or single-tenant fallback;
- returned objects are immutable context-owned values and no Active Record instance/association crosses the boundary;
- architecture evidence demonstrates the dependency graph in §7 and no new controller, route, job, migration, schema object, or runtime wiring;
- full backend tests, RuboCop, Brakeman, Bundler Audit when available, Zeitwerk, and CI results are retained with commit/environment/reviewer metadata.

### 14.7 Files and subsystems that remain untouched

A bounded I1 implementation must not modify:

- existing Organization Domain entities or A1 persistence records except through a separately reviewed necessity finding;
- `backend/db/migrate/`, `backend/db/structure.sql`, database contents, roles, grants, or production configuration;
- controllers, routes, serializers, jobs, frontend files, API contracts, authentication, Session, MFA, recovery, authorization, ownership, capability, delegation, or Branch Assignment code;
- Catalog Domain/Application/Infrastructure, Package C lifecycle behavior, P2 AuditEvent, P3 database security, Orders, Payments, Preparation, pricing, availability, or outbox behavior;
- dependency manifests, factories, seeds, canonical Owner decisions, ADR statuses, CAT-TRR statuses, or Identity Security Review Checklist statuses.

Any demonstrated need to touch an excluded file stops the bounded slice and requires an explicit scope amendment; it is not incidental cleanup.

## 15. ADR and governance relationships

- [ADR-0011](adr/0011-project-wide-layered-ddd.md) is Accepted and controls layer ownership and dependency direction.
- [ADR-0006](adr/0006-authentication-session-topology.md) remains Proposed. I1 contains no Session or authentication implementation and neither accepts nor depends on accepting ADR-0006.
- [Foundation Decisions §5](after_four_foundation_decisions.md#5-milestone-2--identity-branch-scope-and-authorization) defines four separate gates. The Gate A decision record above approves this exact semantic design baseline; the Gate B decision record separately authorizes only its exact bounded manifest.
- Recorded Gate A approval does not itself change ADR/checklist status, prove a control, accept residual risk, or authorize implementation or production.
- Gate B was separately approved by the Owner with exact files, tests, environment, constraints, exclusions, and prohibited actions. Its implementation checkpoint is `dd5b3804a1db55fbc05b3f5f33142462ad29de5e`.
- Gate C requires separately executed control evidence and explicit Owner acceptance; the implementation checkpoint does not grant it.
- Final Operational Acceptance remains separate and is not implied.
- No implementation beyond the exact bounded I1 Gate B manifest is authorized. I2, P1, P2, P3, C1, C2, C3, Package C, Identity Milestone 2B, public API, and production implementation remain unauthorized.

## 16. Gate A review checklist

The Owner approved this Gate A review checklist without amendments on 2026-11-15:

- [x] ancestry-only scope is exact and sufficiently narrow;
- [x] Organization Application owns the published query and persistence port;
- [x] Organization Infrastructure implements only the Organization-owned persistence port;
- [x] Identity Application owns `OrganizationScope`;
- [x] Identity Infrastructure, not Organization Infrastructure, implements the Identity-owned cross-context adapter;
- [x] Composition Root performs wiring only;
- [x] request and all five outcome semantics are accepted for design purposes;
- [x] typed-reference construction boundary and proposed external UUID textual convention are accepted without amendment;
- [x] raw-input parsing and its tests remain owned by a future consumer rather than the I1 implementation slice;
- [x] immutable success values contain only Brand and Organization references;
- [x] `not_found`, `invalid`, `inconsistent`, and `unavailable` remain distinct;
- [x] persisted-state and adapter/result inconsistency both map to public `inconsistent` without partial ancestry;
- [x] `SafeFailureReference` ownership and unchanged propagation are accepted without selecting telemetry technology;
- [x] the §9.1 exceptional-termination semantics are accepted, and Gate B remains blocked until its concrete sanitized signal, containment point, and diagnostic-boundary decision are named;
- [x] database exceptions and persistence records cannot cross Application contracts;
- [x] Brand ancestry is explicitly non-authorizing;
- [x] all ownership, delegation, Session, Catalog, P2, P3, API, schema, mutation, and production behavior remains excluded;
- [x] unresolved questions remain visible rather than silently defaulted;
- [x] test responsibilities and evidence ownership are sufficient for a later Gate B request;
- [x] ADR-0006, checklist, P1-OD, C0 deferred, CAT-TRR, and implementation-authorization statuses remain unchanged.

Gate A and the separate bounded Gate B are recorded as `APPROVED`. Gate C Control Acceptance, Final Operational Acceptance, and production authorization remain `NOT GRANTED`.
