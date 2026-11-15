# AFTER FOUR — P2 Brand-scoped Catalog AuditEvent Design

**Document status:** `TECHNICAL_PROPOSAL`

**Readiness:** `DESIGN_REVIEW_REQUIRED`

**Implementation authorization:** Not granted

**P2 implementation:** Unauthorized

**Evidence date:** 2026-11-15

## 1. Purpose, scope, and decision discipline

P2 defines the logical Brand-scoped Catalog AuditEvent contract required by future Package C Category and Variant lifecycle operations. It specifies the evidence envelope, Layered DDD ownership, append-only semantics, and the atomic boundary between one successful lifecycle mutation and its required audit append.

P2 is a Catalog lifecycle evidence design, not a general-purpose audit platform or Organization-wide audit-governance program. It does not implement or authorize Package C, P1, P3, Identity Milestone 2B, a database migration, a public API, production data, or production use.

The classifications in this document are normative:

| Classification | Meaning |
|---|---|
| `OWNER_CONFIRMED` | Exact policy confirmed in the canonical Owner Decision Baseline. |
| `TECHNICAL_PROPOSAL` | Reviewable design choice; not implemented or approved merely by appearing here. |
| `DEFERRED` | Owner intentionally postponed the decision; no replacement or default may be inferred. |
| `EXTERNAL_PREREQUISITE` | Separately authorized implementation or operational evidence required by P2 integration. |
| `OWNER_DECISION_REQUIRED` | Business or governance behavior still requires explicit Owner direction. |
| `NOT_IMPLEMENTED` | Repository inspection found no executing Brand-scoped Catalog control. |

Authoritative sources are the [Owner Decision Baseline](after_four_owner_decision_baseline.md#package-c0-lifecycle-authority-and-prerequisite-decisions), [DDD Foundation](after_four_ddd_foundation.md), [ADR-0011](adr/0011-project-wide-layered-ddd.md), [Catalog Core Technical Design](after_four_catalog_core_technical_design.md), [Package C Technical Design](after_four_package_c_technical_design.md), and merged [P1 Trusted Identity / Authorization Design](after_four_p1_trusted_identity_authorization_design.md).

### 1.1 In scope

- the Brand-scoped logical event and evidence contract for Category/Variant lifecycle mutations;
- required, conditionally required, and prohibited event data;
- stable before/after lifecycle evidence;
- Catalog-owned construction, validation, append port, and transaction orchestration responsibilities;
- Infrastructure serialization, persistence, and append-only enforcement responsibilities;
- compatibility analysis for the existing Branch-scoped Phase 1 AuditEvent;
- atomicity, concurrency, failure, security, and future verification contracts;
- P1/P2/P3/Package C integration boundaries.

### 1.2 Non-goals

- Package C, P1, P3, or Identity implementation;
- changing the existing Phase 1 AuditEvent model, schema, behavior, or historical rows;
- selecting or executing a migration, backfill, dual-write, or production cutover;
- a universal event-sourcing, logging, analytics, or event-delivery framework;
- audit retention periods, legal holds, reader authorization, export, anonymization, or legal conclusions;
- automatic retry, backoff, replay, or command/event idempotency policy;
- public API, webhook, queue, outbox, stream, or external audit vendor;
- Product lifecycle, Default Variant switching, pricing, availability, or other Package C exclusions.

## 2. Current-state repository evidence

### 2.1 Verified Phase 1 implementation

The existing implementation predates project-wide Layered DDD adoption and remains a Branch-scoped Phase 1 mechanism:

| Evidence | Verified fact | P2 boundary |
|---|---|---|
| `backend/app/models/audit_event.rb` | Top-level Active Record model; validates mandatory `branch_id`, actor/event/subject identities, idempotency key, and occurrence time. `before_update` and `before_destroy` callbacks reject instance mutation. | Not a Catalog Domain/Application contract and not Brand-scoped. |
| `backend/db/migrate/20261114192000_create_order_payment_foundation.rb` | Creates `audit_events` with mandatory `branch_id`, actor fields, event/subject fields, `idempotency_key`, optional `request_id`, generic JSONB `metadata`, `occurred_at`, and `created_at`. | No `organization_id`, `brand_id`, Session reference, authorization/delegation evidence, before/after contract, MFA reference, or schema version. |
| Same migration | Unique index is `(branch_id, idempotency_key)`; actor check permits `user` with `actor_id` or `system` without it. | The unique key is a Phase 1 Branch/idempotency rule. C0-R11 does not authorize reusing it as a Package C policy. |
| `backend/db/migrate/20261114203000_protect_audit_events_append_only.rb` | PostgreSQL `BEFORE UPDATE OR DELETE` trigger raises SQLSTATE `23514`. | It does not cover `TRUNCATE`; an owner/superuser can bypass or replace protections. |
| `backend/db/structure.sql` | Records the table, actor check, indexes, trigger function, and UPDATE/DELETE trigger. | Schema evidence matches the migrations but does not implement C0-R07. |
| `backend/spec/models/audit_event_spec.rb` | Exercises model-level update/destroy rejection. | Application callback evidence only. |
| `backend/spec/integration/audit_event_database_protection_spec.rb` | Exercises instance, bulk, and direct-SQL UPDATE/DELETE rejection, permits insert/select, and verifies insert rollback with a parent transaction. | Local/test evidence for the current table; no runtime-role, TRUNCATE, Brand-envelope, or Package C evidence. |
| `backend/spec/support/audit_event_cleanup.rb` | Test cleanup disables the append-only trigger as database owner, deletes rows, then re-enables it. | Positive evidence that owner-level authority can bypass the trigger; P3 must control that authority. |
| Phase 1 Orders/Payments/Preparation commands | Several commands append AuditEvent inside the same `ApplicationRecord.transaction` as their business writes. | Useful transaction pattern only; these are legacy contexts and not Package C/P2 implementation. |
| Transaction-recovery specs | Inject AuditEvent insert failures and assert rollback for Order, Payment, Dispatch, Outbox, review, expiration, and hold writes. | Executed evidence may exist in earlier milestone reports, but this design task did not rerun tests and makes no new execution claim. |

The existing `branch_id` is mandatory in the schema and model. The inspected creation migration does not add a Branch foreign key to `audit_events`; mandatory presence is not equivalent to a database-enforced Branch relationship. A Branch UUID also cannot substitute for the exact Brand scope required by C0-R07.

### 2.2 Existing protection layers

| Layer | Present behavior | Limitation |
|---|---|---|
| Application/model | Instance callbacks reject update/destroy. | Bulk/direct SQL bypasses callbacks. |
| Database trigger | Row-level UPDATE and DELETE raise `23514`. | No TRUNCATE event; privileged owners/superusers can disable/drop/replace it. |
| Runtime privileges | No production-like non-owner runtime-role evidence establishes least privilege for this table. | P3 remains an external prerequisite. |
| Transaction examples | Commands append inside a surrounding transaction and failure-injection specs assert rollback. | Not the P2 Brand envelope or Package C transaction boundary. |

### 2.3 Gap to C0-R07

The current Phase 1 contract lacks required P2 semantics: Organization and exact Brand, trusted Session reference, exact capability, authorization decision, applicable delegation/authority evidence, structured before/after lifecycle snapshots, conditionally required reason/MFA reference, explicit schema version, and an event/correlation contract independent of the deferred C0-R11 idempotency policy.

Therefore the existing Phase 1 `audit_events` table and `AuditEvent` model are `NOT_IMPLEMENTED` evidence for P2. Their behavior must remain intact unless a separate migration and compatibility plan is explicitly authorized.

## 3. Canonical Owner-decision traceability

### 3.1 Owner-confirmed obligations

| Decision | P2 obligation |
|---|---|
| `C0-CAT-01`, `C0-CAT-02` | Record the exact authorized Category or Variant lifecycle operation; never infer authority from the event itself. |
| `C0-CAT-03` | Preserve exact Brand and capability scope and applicable delegation evidence. |
| `C0-CAT-04` | Deactivate, Archive, and Restore events require the accepted reason; Activate has no confirmed reason requirement. |
| `C0-CAT-05` | Archive/Restore events require an opaque MFA evidence reference from P1 once acceptable semantics exist. |
| `C0-CAT-06` | Cross-Brand scope is default-deny; event Brand derives from the trusted persisted target relationship. |
| `C0-CAT-07` | Audit persistence failure rolls back the complete lifecycle mutation. |
| `C0-CAT-08` | P2 records no Default Variant switching through Package C. Variant evidence may prove flags were preserved. |
| `C0-R01`–`C0-R04` | Preserve evaluated ownership/capability/delegation evidence without implementing delegation administration or merging its audit stream into P2. |
| `C0-R06` | Preserve the validated reason where required: nonblank, no more than 500 characters, with no intentional secrets. |
| `C0-R07` | Supply the complete Brand-scoped, append-only event contract and atomic append described below. |
| `C0-R09` | Consume P1 trusted identity, Session, authorization, and safe evidence references; never accept client authority claims. |
| `C0-R10` | Leave runtime role separation and bypass prevention to P3; do not claim application-only append security. |

### 3.2 C0-R07 canonical checklist

P2 must preserve all of the following `OWNER_CONFIRMED` requirements:

- Actor and trusted identity evidence;
- non-secret Session reference;
- Organization and exact Brand scope;
- exact capability and authorization-decision evidence;
- delegation/authority evidence when applicable;
- entity type, identity, and lifecycle operation;
- stable before and after state;
- validated reason when required;
- opaque MFA evidence reference when applicable;
- Event ID and correlation ID;
- authoritative event timestamp;
- schema version;
- no credentials, secrets, raw Session tokens, or raw MFA material;
- append-only persistence;
- lifecycle mutation and AuditEvent append in one transaction;
- audit failure rolls back the entire lifecycle mutation.

`C0-R07` defines the complete contract and atomic append. `C0-CAT-07` independently requires complete lifecycle rollback when audit persistence fails.

### 3.3 Deferred decisions preserved

| Decision | Preserved boundary |
|---|---|
| `C0-R05` | Exact MFA freshness, assurance, Session binding, and invalidation remain `DEFERRED`. Archive/Restore still require step-up; P2 stores only a safe reference that P1 has accepted under a future approved policy. |
| `C0-R08` | Retention, legal hold, reader authorization, export, and related legal/privacy governance remain `DEFERRED`. No duration, access entitlement, export format, or deletion/anonymization rule is proposed here. |
| `C0-R11` | Retry, backoff, replay, and idempotency remain `DEFERRED`. Event ID and correlation ID are not command idempotency keys. |

No Owner decision or CAT-TRR status is changed by this document.

## 4. Layered DDD ownership and dependency direction

P2 is a capability within the Catalog bounded context for Catalog lifecycle evidence. It does not create a general Audit bounded context or move Phase 1 Ordering/Payment/Preparation audit ownership.

### 4.1 Responsibility allocation

| Layer/context | Proposed responsibility |
|---|---|
| Catalog Domain | Own lifecycle state vocabulary, transition result facts, and the business invariants that determine valid before/after state. It knows no Session, authorization provider, audit table, Rails, Active Record, PostgreSQL, or JSON. |
| Catalog Application | Own Package C use-case orchestration; consume P1 through the Catalog-owned outbound port; validate required trusted evidence; construct and validate the logical CatalogLifecycleAuditEvent from trusted P1 references plus Domain transition facts; own the append port; coordinate mutation and append in one unit of work. |
| Catalog Infrastructure | Implement Catalog persistence, transaction/unit-of-work, allowlist serialization, P2 append-port, persistence mapping, database constraints/triggers, and safe error translation. It may depend on Catalog Domain and Catalog Application contracts it implements. |
| Presentation | Parse untrusted lifecycle input and correlation metadata and invoke one Package C use case. It cannot construct Actor/Brand/capability evidence, before/after snapshots, or AuditEvents. No Presentation implementation is authorized. |
| P1 Identity/Authorization | Supply trusted Actor, non-secret Session, target-bound Organization/Brand, exact capability, authorization decision, applicable authority/delegation, MFA, and correlation evidence references through its merged contract. |
| P3 database security | Define runtime/migration/break-glass roles, ownership, grants, TRUNCATE/DDL/function/trigger protection, and operation-specific bypass prevention. |

### 4.2 Dependency map

```text
Future Presentation
        |
        v
Catalog Application --------------------------> Catalog Domain
        |
        +-- owns --> Catalog lifecycle audit contract
        +-- owns --> CatalogAuditAppendPort
        +-- owns --> Transaction/UnitOfWork contract
        +-- owns --> outbound P1 consumer port

Catalog Infrastructure -- implements ---------> Catalog Application ports
Catalog Infrastructure -- maps ---------------> Catalog Domain/Application values
Catalog P1 adapter ------ invokes -------------> Identity Application public contract

Composition Root -------- wires --------------> ports and implementations
```

Catalog Domain and Application do not depend on Active Record, PostgreSQL, Identity Infrastructure, Organization Infrastructure, or the P2 persistence representation. Catalog never reads Identity or Organization Active Record records directly. P1's TrustedCatalogTarget and AuthorizationContext semantics remain the sole trust model; P2 introduces no second Actor, Brand, or authorization authority.

### 4.3 Event construction and validation ownership

`TECHNICAL_PROPOSAL`: Catalog Domain returns immutable transition facts or equivalent values sufficient to prove the lifecycle decision. Catalog Application combines those facts with the locked trusted target and P1 evidence references to construct one logical event. Framework-independent event validation rejects an incomplete or internally inconsistent envelope before persistence.

The persistence adapter revalidates representation-level constraints and serializes only allowlisted fields. It does not infer missing authority, reconstruct before state from mutable records after the fact, or authorize the lifecycle operation.

## 5. Brand-scoped logical event contract

### 5.1 Event identity and type

`TECHNICAL_PROPOSAL`: each successful Package C mutation produces one immutable logical `CatalogLifecycleAuditEvent` with:

- a globally unique opaque Event ID generated server-side;
- one exact operation-specific event type for Category/Variant Activate, Deactivate, Archive, or Restore;
- a positive explicit schema version;
- one server-controlled correlation reference shared with the lifecycle operation; and
- one authoritative occurrence timestamp representing the successful operation within its transaction.

Exact storage types, event-type strings, identifier generation mechanism, and schema-version numbering require implementation design review. Event ID uniqueness does not define retry/replay/idempotency behavior under C0-R11.

### 5.2 Required and conditional fields

| Logical element | Requirement | Trusted source |
|---|---|---|
| Event ID | Required; immutable and unique. | Server-side event construction. |
| Event type | Required; exact entity type plus lifecycle operation. | Package C use case. |
| Schema version | Required; explicit and positive. | Code-owned serializer contract. |
| Actor reference | Required; stable trusted person/actor reference. | P1 AuthorizationContext. |
| Session reference | Required; stable non-secret reference, never token/verifier material. | P1 AuthorizationContext. |
| Trusted identity/Session validation evidence | Required; opaque safe decision/evidence reference proving the Actor and Session came from P1's trusted validation flow. | P1 TrustedIdentityContext/AuthorizationContext. |
| Organization reference | Required; must match target ancestry. | P1 trusted target binding. |
| Brand reference | Required; exact persisted target Brand. | Catalog persisted target plus P1 revalidation. |
| Entity type | Required; `Category` or `Variant` only for Package C. | Locked Catalog target. |
| Entity identity | Required; exact locked target identity. | Locked Catalog target. |
| Lifecycle operation | Required; Activate, Deactivate, Archive, or Restore. | Explicit Package C use case. |
| Capability | Required; exact operation-specific capability. | P1 AuthorizationContext. |
| Authorization decision reference | Required; opaque safe decision reference. | P1 AuthorizationContext/revalidation. |
| Authority-source/delegation evidence | Required safe authority reference; delegation reference/facts conditionally required when delegated authority supplies access. | P1 AuthorizationContext. |
| Before state | Required immutable allowlisted snapshot. | Locked pre-transition Domain/persistence state. |
| After state | Required immutable allowlisted snapshot. | Accepted Domain transition result persisted in the transaction. |
| Reason | Required for Deactivate, Archive, Restore; absent for Activate unless a future Owner decision changes policy. | Package C validated canonical reason. |
| MFA evidence reference | Required for Archive/Restore; absent for operations without a confirmed MFA requirement. | P1 accepted evidence; final semantics blocked by C0-R05. |
| Correlation reference | Required; server-controlled operation reference. | Trusted request/application context. |
| Occurred-at timestamp | Required; authoritative timezone-aware instant. | Approved transaction clock. |

The event records references and allowlisted facts, not an unrestricted serialization of AuthorizationContext, Domain entities, Active Record objects, HTTP requests, or provider responses.

### 5.3 Brand derivation and scope integrity

The Brand is not request input. Package C first validates trusted identity/Session, then Catalog Infrastructure loads minimal persisted entity→Brand facts, Catalog Application resolves and verifies Brand→Organization through the approved Organization Application contract, and Catalog Application creates TrustedCatalogTarget as specified by P1. After Catalog locks, the same relationship is reloaded and revalidated before mutation.

P2 copies Organization and Brand only from the revalidated target binding. The event entity identity/type, Organization, Brand, capability, and authorization decision must refer to the same operation. Missing, changed, or cross-Brand scope fails closed before mutation or append.

A client-supplied Brand UUID, a free-standing Brand ID, or a Branch ID never establishes audit scope. P2 does not invent a Branch for a Brand-level lifecycle operation.

### 5.4 Prohibited data

The event, persistence representation, logs, errors, metrics, and traces must not contain:

- passwords, PINs, password/PIN digests, or peppers;
- raw Session tokens, token verifiers, cookies, CSRF material, or authorization bearer material;
- MFA seeds, responses, recovery codes, or raw factor/provider payloads;
- API/database credentials, encryption keys, provider secrets, or signatures;
- unrestricted HTTP bodies/headers, Active Record attributes, or arbitrary object serialization;
- protected cross-Brand entity details beyond the authorized event allowlist;
- arbitrary exception/stack data inside the event payload.

### 5.5 Compatibility with Phase 1 AuditEvent

The current `audit_events.branch_id NOT NULL` contract cannot represent a Brand-level operation without fabricating a Branch. P2 must not make `branch_id` nullable, reinterpret it as a Brand, or weaken existing indexes/callbacks/triggers as an incidental design consequence.

Persistence alternatives requiring separate review are:

| Alternative | Benefits | Risks/boundaries |
|---|---|---|
| Separate Catalog lifecycle audit relation/store | Preserves Phase 1 contract unchanged; allows exact Brand envelope and focused constraints. | New representation, migration, naming, query/governance integration, and P3 grants require authorization. |
| Extend current table with explicit scope discriminator and scope-specific constraints | One physical event collection. | High compatibility risk: mandatory Branch semantics, existing unique key/model/tests, nullability, historical rows, and trigger/privilege changes become coupled. |
| Existing event header plus Catalog-specific immutable detail relation | Can preserve some shared identity fields. | Atomic two-row append, FK lifecycle, query complexity, append-only enforcement across both relations, and incomplete-header risk. |

This design does not select or authorize any alternative. A later persistence/migration review must prove that historical Phase 1 rows and behavior remain intact and that no fake Branch or silent semantic rewrite is introduced.

## 6. Before/after lifecycle evidence

### 6.1 Snapshot purpose

Before/after evidence proves the exact lifecycle change evaluated and committed. It is not a universal entity snapshot, recovery image, change-data-capture record, or substitute for current Catalog state.

`TECHNICAL_PROPOSAL` allowlists:

| Entity | Before/after evidence |
|---|---|
| Category | Exact entity identity plus lifecycle status before and after. Organization/Brand remain envelope scope rather than duplicated mutable snapshot fields. |
| Variant | Exact entity identity plus lifecycle status, `is_default`, and `customer_visible` before and after, proving Archive/Restore preserve flags and no operation silently switches Default. |

Immutable ancestry and other fields may be referenced only when a reviewed acceptance requirement demonstrates they are necessary; arbitrary names, descriptions, prices, timestamps, or full-record dumps are excluded.

### 6.2 Stability and null/absence

- Snapshots are immutable serialized values captured from the locked pre-transition state and accepted Domain result, not references to mutable objects or later queries.
- Keys and lifecycle values are deterministic and schema-versioned.
- Required keys are never omitted. A JSON/null-like value is allowed only if the field's semantics explicitly permit null in that schema version; lifecycle status and Variant flags are non-null.
- Conditional envelope fields are absent when not applicable rather than populated with invented values.
- Key order or physical JSON formatting is not business meaning; the logical allowlist and values are.
- Serialization failure or a mismatch between Domain result and persistence input aborts the operation.

### 6.3 Correspondence to committed state

The before snapshot comes from the locked authoritative state used by Domain validation. The after snapshot comes from the exact accepted transition result passed to persistence. The Application use case appends the event after requesting the mutation and before transaction commit. Database constraints and deferred final-state checks must accept the resulting state at commit.

Future tests query committed state after the transaction and compare the allowlisted event after snapshot with that state. No event may claim a successful after state that rolled back or was superseded before commit.

## 7. Append-only semantics and enforcement layers

### 7.1 Contract-level semantics

An accepted CatalogLifecycleAuditEvent can only be appended. P2 exposes no update, replace, delete, truncate, or in-place correction operation. Corrections, if later approved, must be new linked evidence rather than mutation of historical events; no correction workflow is selected here.

### 7.2 Application and adapter boundaries

- Catalog Application owns an append-only port with no mutation/deletion methods.
- The adapter accepts only a validated logical event and returns success or a typed failure; it cannot convert a failure into best-effort success.
- No after-commit callback, background job, outbox delivery, or rescue-and-continue path satisfies C0-R07.
- Ordinary Application code never receives persistence records or generic table-update access through the port.

These controls improve API discipline but cannot prevent direct SQL or privileged bypass.

### 7.3 Database and P3 boundaries

Database-level defense must reject unauthorized UPDATE and DELETE and address TRUNCATE. Viable mechanisms include reviewed triggers, grants/revokes, ownership separation, and an operation-specific boundary, but P3—not this design—selects and proves the runtime topology.

Evidence must distinguish:

- ordinary runtime-role enforcement;
- migration-owner authority needed for reviewed schema change;
- tightly controlled break-glass authority; and
- PostgreSQL owner/superuser capabilities that can bypass triggers or privileges.

P2 cannot claim tamper-proof or fully secured append-only storage against table owners or superusers. The existing test cleanup helper demonstrates privileged trigger disablement in local/test; production runtime must not possess equivalent authority under C0-R10/P3.

## 8. Atomic transaction contract

### 8.1 Required semantic sequence

For one authorized Package C lifecycle operation:

1. Catalog Application receives a valid TrustedIdentityContext through its P1 consumer port.
2. It begins one Package C unit of work using the approved transaction boundary before the controlled target lookup.
3. Within that transaction, it resolves and initially authorizes the exact persisted target and operation as specified by P1/Package C, without disclosing protected target details.
4. It acquires Category→Product→Variant locks as applicable, reloads state, and revalidates P1 evidence.
5. Catalog Domain validates and returns the exact transition result.
6. Catalog persistence writes only that lifecycle mutation.
7. Catalog Application constructs and validates the corresponding P2 event from trusted evidence and transition facts.
8. The P2 append adapter persists the event in the same database transaction and connection context as the mutation.
9. The transaction commits only when mutation, event append, constraints, and deferred final-state checks all succeed.
10. Any rejection or failure aborts the complete transaction.

Required outcomes:

- audit validation, serialization, constraint, adapter, or persistence failure rolls back the lifecycle mutation;
- mutation/Domain/database failure leaves no committed success event;
- transaction/commit failure leaves neither a committed mutation nor a committed success event;
- successful mutation and its one required event commit together;
- no success event describes state that did not commit.

### 8.2 Transaction ownership and participating ports

Catalog Application's explicit lifecycle use case owns orchestration. Its unit-of-work contract must encompass the Catalog persistence port and P2 append port. Infrastructure must prove both adapters join the caller's same transaction/connection rather than opening an independent or `requires_new` commit boundary.

`TECHNICAL_PROPOSAL`: the accepted Rails modular monolith and one PostgreSQL database make a shared local transaction feasible, but this is not executable evidence. A separately committing audit store, external service, background append, or after-commit mechanism cannot satisfy C0-R07 without a separately proven atomic mechanism and is not selected here.

### 8.3 Mechanism alternatives and rejection criteria

| Boundary option | Design assessment |
|---|---|
| Application-owned unit of work with both Infrastructure adapters on one PostgreSQL transaction/connection | Coherent proposal under current topology; requires adapter-composition and failure-injection proof. |
| Operation-specific database function/procedure coordinating mutation and append | Could centralize database atomicity, but P3 has not selected stored procedures or another boundary; security-definer/search-path/grant risks require separate review. |
| Independent audit transaction or `requires_new` append | Rejected: can commit evidence without mutation or mutation without evidence. |
| After-commit/background/outbox append | Rejected for required C0-R07 success evidence: append can fail after mutation commits. |
| Separate database/service with best-effort delivery | Rejected absent a proven atomic transaction mechanism; eventual consistency does not meet C0-R07. |

No implementation mechanism is authorized by this comparison.

### 8.4 Separation from P1 delegation-administration audit

P1 grant/change/revoke evidence has its own Identity/delegation ownership and atomicity proposal. It is not a Category/Variant lifecycle mutation and is not required to use P2's contract or persistence. P2 may record only the safe authority/delegation reference used by a successful Catalog lifecycle decision.

## 9. Concurrency and consistency

P2 preserves Package C's `READ COMMITTED` proposal and Category→Product→Variant Application lock order. It does not modify Package B constraints, deferred final-state triggers, or lock protocols.

The locked pre-state used for Domain validation is the event before state. The accepted Domain result is the event after state. After locks, Package C revalidates target ancestry, identity/Session, exact Brand/capability, authority/delegation, and applicable MFA evidence before mutation and event construction.

Concurrent operations must serialize or fail according to PostgreSQL and Package B/Package C invariants. A deadlock, lock timeout, constraint rejection, revocation race loss, or transaction failure rolls back both mutation and event. The survivor's event must match its own committed before/after transition.

C0-R11 remains `DEFERRED`. P2 selects no automatic retry, event-ID reuse, duplicate suppression, replay result, backoff, or command idempotency key. If a caller later retries under an approved policy, it must restart the entire use case and transaction; it cannot continue an aborted transaction or append an event for a mutation whose outcome is uncertain.

## 10. Failure and security behavior

### 10.1 Fail-closed matrix

| Condition | Required behavior |
|---|---|
| Missing/invalid Actor or Session evidence | Reject before protected target disclosure; no mutation or success event. |
| Missing/changed Organization or Brand relationship | Non-disclosing rejection; no event with client or stale scope. |
| Missing/invalid capability or authorization decision | Reject; no mutation or success event. |
| Missing/invalid authority or delegation evidence when applicable | Reject or authorization unavailable; no mutation or success event. |
| Missing/invalid reason for Deactivate/Archive/Restore | Reject before mutation; no success event. |
| Missing/unacceptable MFA evidence for Archive/Restore | Fail closed; exact acceptance remains blocked by C0-R05. |
| Invalid/incomplete before or after snapshot | Reject and roll back. |
| Event schema-version incompatibility | Reject and roll back; never silently downgrade or store an unknown shape. |
| Serialization/redaction validation failure | Reject and roll back; do not log the unsafe payload. |
| Audit constraint or persistence failure | Propagate failure and roll back the complete lifecycle mutation. |
| Mutation/constraint failure | Roll back and leave no committed success event. |
| Transaction/connection/commit uncertainty | Treat as failure/unknown, disclose no protected data, and do not claim success. No retry policy is inferred. |
| P1/P2/P3 provider unavailable or uncertain | Fail closed; no Catalog mutation. |

### 10.2 Error and logging discipline

Application outcomes are semantic and non-disclosing. Infrastructure may translate only reviewed SQLSTATE plus named constraint/trigger identities; unknown failures remain unexpected and roll back. Public HTTP status/error mapping is outside this design.

Logs and errors contain only safe event/decision/correlation references and coarse failure categories. They never serialize event payloads wholesale, reasons, raw before/after objects, credentials, Session/MFA material, or protected cross-Brand details.

### 10.3 Reason and secret handling

C0-R06 prohibits intentional secrets and confirms nonblank/whitespace rejection plus the 500-character maximum. P2 stores only the canonical reason accepted by Package C's reviewed validation contract. Arbitrary free text cannot be proven free of every possible secret; the system must avoid structured secret inputs, use allowlists, redact logs/errors, and never claim perfect secret detection.

The Unicode trimming/counting convention remains the `TECHNICAL_PROPOSAL` in Package C §7.2. P2 does not reclassify it as Owner-confirmed or invent another convention.

## 11. P1/P2/P3/Package C integration

| Component | Owns | Does not own |
|---|---|---|
| P1 | Trusted identity/Session validation, TrustedCatalogTarget, exact authorization, ownership/delegation/authority evaluation, MFA and safe evidence references. | Catalog mutation, P2 lifecycle event construction/persistence, P3 database privileges. |
| P2 | Catalog lifecycle event semantics, safe envelope validation, append port, persistence contract, and mutation-plus-event atomicity requirements. | Identity/delegation administration audit, authentication, lifecycle authorization, runtime role topology, retention/read/export policy. |
| P3 | Runtime/migration/break-glass roles, object ownership, destructive/DDL privilege restrictions, and operation-specific database boundary/bypass prevention. | Business lifecycle rules or trusted Actor decisions. |
| Package C | Eight explicit lifecycle use cases, target resolution, locks, P1 revalidation, reason/MFA guards, Domain invocation, mutation orchestration, and invoking P2 within the transaction. | Identity/delegation administration, audit governance, automatic retries, Default switching. |

```text
P1 trusted evidence -----------+
                               v
Package C Application --> Catalog Domain transition facts
          |                    |
          +--> Catalog persistence adapter --------+
          +--> P2 append port/adapter --------------+--> one transaction/commit
                                                    |
P3 runtime/operation boundary ----------------------+--> bypass prevention
```

P2 is necessary but independently insufficient for Package C. Package C also requires implemented/reviewed P1, P3, C0-R05 resolution for Archive/Restore acceptance, executable integration evidence, and separate authorization.

## 12. Open decisions and prerequisites

### 12.1 Owner decisions still required or deferred

| Decision | Impact |
|---|---|
| `C0-R05` `DEFERRED` | Archive/Restore cannot have final executable MFA acceptance criteria. P2 defines only the opaque reference slot. |
| `C0-R08` `DEFERRED` | Production retention, legal hold, readers, exports, anonymization, and related legal/privacy claims remain blocked. |
| `C0-R11` `DEFERRED` | No retry, replay, event-ID reuse, duplicate, or idempotency behavior may be selected. |

No new Owner business decision is required to describe the C0-R07 write envelope. Any broader correction, retention, read/export, or external-delivery behavior would require separate scope and possibly explicit Owner decisions.

### 12.2 Technical decisions available for review now

- logical event envelope and allowlists;
- Catalog Application ownership of construction, validation, append port, and orchestration;
- same-transaction semantic boundary;
- required failure propagation and append-only layers;
- compatibility alternatives for existing Branch-scoped events;
- future test and evidence contract.

### 12.3 Prerequisites before implementation authorization

- explicit selection/review of the persistence representation and migration/rollback/compatibility plan;
- reviewed schema types, constraints, indexes, event-type vocabulary, schema-version policy, and error identities;
- implemented and reviewed P1 contract/provider for the required safe references;
- P3 design and production-like role/privilege/bypass evidence plan;
- reviewed Package C Application unit-of-work and adapter composition proving one connection/transaction;
- failure-injection, concurrency, migration, and append-only test plan;
- explicit file/schema/migration/test scope and separate Owner implementation authorization;
- C0-R05 resolution before Archive/Restore implementation acceptance;
- C0-R08 resolution and any required legal/privacy work before production governance claims.

## 13. Verification and acceptance criteria

### 13.1 Design acceptance

This design is ready for Owner/technical review only when:

- every C0-R07 field and atomicity rule is traceable;
- C0-CAT-04/05/07/08 and C0-R06 remain intact;
- C0-R05/R08/R11 remain deferred without inferred defaults;
- Phase 1 Branch-scoped AuditEvent is described accurately and not silently repurposed;
- Layered DDD ownership and dependency direction remain inward;
- P1 supplies the only trusted identity/authorization semantics;
- P3 responsibilities are not falsely claimed by P2;
- persistence alternatives and unresolved implementation choices remain explicit;
- no implementation authorization is implied.

### 13.2 Future executable evidence

Future P2/Package C/P3 implementation must prove with real PostgreSQL where applicable:

1. Brand is derived from the locked persisted target relationship and verified Organization ancestry, never client input.
2. A cross-Brand, missing, or relationship-mismatched target cannot produce a valid event or disclose existence.
3. Every required field is present and internally consistent for all eight operations.
4. Reason and MFA fields are present only as required; Activate does not acquire an unapproved requirement.
5. Credentials, secrets, raw Session tokens/verifiers, and raw MFA material are absent from event, logs, errors, metrics, and traces.
6. Category before/after evidence matches the committed lifecycle transition.
7. Variant before/after evidence matches the committed transition and proves `is_default` and `customer_visible` preservation where required.
8. Snapshots are immutable values; later entity changes do not rewrite historical evidence.
9. Application/adapter APIs expose append only; direct UPDATE/DELETE/TRUNCATE behavior is tested at every claimed database/role layer.
10. Owner/superuser bypass limitations are documented, not misrepresented as impossible.
11. Successful mutation and required AuditEvent commit together on one transaction/connection.
12. Forced audit validation, serialization, constraint, adapter, and insert failures roll back the lifecycle mutation.
13. Domain/mutation/constraint failure leaves no committed success AuditEvent.
14. Transaction/connection/commit failure leaves neither a committed mutation nor success event where PostgreSQL reports rollback; uncertain outcomes are not reported as success.
15. Concurrency tests use deterministic barriers and committed-state assertions; each survivor event matches its own committed transition.
16. Existing Branch-scoped Phase 1 AuditEvent behavior, historical rows, mandatory Branch semantics, indexes, and protections remain intact unless a separately approved migration explicitly changes them.
17. Fresh migration, upgrade, rollback/refusal, injected failure/recovery, `structure.sql`, and semantic schema-equivalence evidence cover the selected P2 representation.
18. Runtime-role and bypass negative tests are attributed to P3 and run in a production-like non-owner role environment.

No test is represented as executed by this design milestone.

## 14. Risks, verdict, and authorization boundary

### 14.1 Principal risks

- fabricating a Branch or treating Branch scope as Brand scope;
- making existing `branch_id` optional and weakening Phase 1 behavior without an approved migration;
- trusting a client Brand, Actor, capability, delegation, or MFA claim;
- serializing an entire AuthorizationContext, entity, request, or exception into the event;
- reconstructing before state after mutation or storing mutable references instead of snapshots;
- using after-commit, background, outbox, or separate transaction persistence for required success evidence;
- swallowing audit failure and committing lifecycle state;
- claiming trigger/API discipline prevents owner/superuser modification;
- merging P1 delegation-administration audit into P2;
- inventing retention, retry, replay, or idempotency policy while C0-R08/C0-R11 remain deferred;
- treating P2 completion as Package C or production readiness.

### 14.2 Verdict

`DESIGN_REVIEW_REQUIRED`

The logical Brand-scoped event, evidence allowlists, Layered DDD ownership, before/after semantics, append-only layers, atomic transaction contract, failure behavior, compatibility alternatives, and future evidence requirements are specified for review. The persistence representation, migration path, P3 database boundary, P1 runtime provider, Package C unit of work, and executable evidence remain absent.

P2 is **not implementation-ready or authorized**. No source code, migration, schema, database, runtime configuration, test, P1/P3/Package C implementation, Identity Milestone 2B work, public API, or production use is authorized by this milestone. A separate Owner/design review and explicit implementation authorization with exact scope are required.

This document changes no Owner decision, deferred status, ADR status, CAT-TRR status, or existing Phase 1 AuditEvent contract.
