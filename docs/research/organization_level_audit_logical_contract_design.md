# AFTER FOUR — Organization-Level Logical Audit Contract Design

**Design date:** 2026-11-26

**Status:** `DESIGN_ONLY`

**Recommended next-state verdict:** `READY_FOR_NARROW_READ_ONLY_ADVERSARIAL_RE_REVIEW`

**Current external-review lifecycle:** `EXTERNAL_REVIEW_NOT_YET_PERFORMED`

> **Decision closure — 2026-11-27.** The Owner confirmed local decisions `AUD-DEC-01` through `AUD-DEC-06`. For Slice 1, the catalog remains empty, the append seam is a narrow PostgreSQL `SECURITY DEFINER` function, the idempotency identity is **Organization + Producer + Stable Attempt Key**, Branch reference is forbidden, only the human-actor shape is enabled, and database duties are separated. These local references are not canonical ODB allocations. This closure supersedes any proposal wording below for those six decisions; it does not authorize implementation or a production event.

> **Independent-review remediation — 2026-11-27.** `ISR-AUD-001` is remediated in design by prohibiting every Branch column, FK, target, validation path, catalog mode, fixture and indirect Branch identity from the new Slice 1 contract. Existing legacy Branch audit and hypothetical future Branch support may be discussed only as separate context. `ISR-AUD-002` and `ISR-AUD-003`, the authoritative function, privilege installation and staged prerequisites are maintained in the [Security Design Closure](organization_level_audit_security_design_closure.md). All three findings remain open pending focused independent re-review.

> **Security remediation round 2 — 2026-11-27.** The focused re-review verified `ISR-AUD-001/002`, found `ISR-AUD-003` partially remediated and added `ISR-AUD-004`–`006`. The [security closure §4.2.2–4.2.3](organization_level_audit_security_design_closure.md#422-authoritative-identifier-grammar-and-normalization-policy) now authoritatively defines identifier grammar and Audit-owned failure-class registration; §8.8 defines evidence timing. These design remediations await independent follow-up review.

> **Security remediation round 3 — 2026-11-27.** The follow-up review added `ISR-AUD-007`–`010`. The current design validates catalog arrays element-by-element, reserves `AUE01` for registration denial, treats database-function dispositions as provisional until the owning outer transaction commits, and requires finite occurrence time plus a future event-specific temporal policy. These remediations remain pending focused independent re-review.

> **Security remediation round 4 — 2026-11-27.** The Round 3 re-review found `ISR-AUD-011/012`. The current contract now requires an atomic, write-quiesced helper-replacement and dependent-CHECK revalidation protocol, and separates an embedded `PendingAppendReceipt` from a post-commit `CommittedAppendResult`. These design corrections remain pending focused independent re-review and grant no implementation authority.

> **ISR-AUD-013 remediation — 2026-11-27.** `allowed_outcomes`, `allowed_metadata_keys` and `required_metadata_keys` are duplicate-free ordered representations of logical sets. Application and PostgreSQL reject duplicates exactly and case-sensitively; neither layer normalizes, deduplicates, sorts or reorders. The representation and its order are fixed by the reviewed registration and included positionally in projection/hash comparison. This remains design-remediated pending independent review.

> **ISR-AUD-013 remediation round 2 — 2026-11-27.** The remaining projection/hash ambiguity is addressed by the language-neutral `after-four.audit-registration-projection` format version 1 defined in §10.1.1–10.1.5. It fixes the complete field sequence, binary type/presence/length framing, scalar and array encodings, SHA-256 input and comparison behavior. Audit Evidence remains the logical registration authority; no implementation class, catalog row or producer is authorized. The correction remains pending focused independent review and executable conformance evidence.

> **Authorization-readiness consolidation — 2026-11-27.** Internal protocol, PostgreSQL-security and architecture review added `ISR-AUD-014`–`023`; re-review added `ISR-AUD-024`–`030`. This contract closes the protocol and module-boundary findings, including PostgreSQL-compatible U+0000 rejection; the security closure records the full register and database/status remediations. Internal review does not replace the external independent review required before Owner implementation authorization may be considered.

> **P0 internal-review remediation — 2026-11-27.** `ISR-AUD-031`–`039` are remediated in design across replay concurrency, exact identity comparison, PostgreSQL privilege lifecycle, migrator custody, the Rails persistence base, architecture-enforcement claims, structured SQLSTATE handling and UTF-8 installation invariants. Every finding remains `DESIGN_REMEDIATED_RE_REVIEW_REQUIRED`; no executable evidence or external review is claimed.

> **Final design clarification — 2026-11-27.** The preceding clarification introduced transaction-participation and stage-specific encoding requirements for `ISR-AUD-036/039`; the later five-finding remediation below supersedes its narrower identity and session wording. Both findings remain `DESIGN_REMEDIATED_RE_REVIEW_REQUIRED` until focused re-review and later authorized executable acceptance evidence exist.

> **ISR-AUD-036/039/040/041/042 design remediation — 2026-11-27.** The contract defers to the canonical outer-wrapper-issued, supplied-adapter capability; rejects ambient transactions, nested issuers and real nested/savepoint append; requires exact-session UTF8 checks inside the append function; and requires non-reusable restore attempts, target-generation fencing and atomic quarantined-target promotion. The subsequent narrow review verified `ISR-AUD-039/040/042` at design level and returned `ISR-AUD-036/041` for the final micro-remediation recorded below; all five still require later authorized executable evidence.

> **Final micro-remediation — 2026-11-27.** The transaction seam is wrapper-owned participation only: the designated outer wrapper proves its adapter is idle, opens and owns the boundary, and issues the capability; joined inner services may reuse it, while pre-existing ambient or arbitrary caller-owned transactions remain unsupported absent a separately approved protocol. The error contract now separates native parse/resolution/bind/decode/conversion failures before function entry from `AUE02` raised by the first exact-session guard after successful entry. Both paths fail closed, construct no success and unwind the whole transaction. `ISR-AUD-036/041` remain pending final narrow read-only verification and later executable evidence.

This document defines a framework-independent logical interface for the independently approved Audit Evidence platform module. It creates no package, event registration, schema, migration, database role, runtime writer, reader, capability, retention rule, or implementation authorization.

## 1. Executive recommendation

Use one deep Audit Evidence module with one narrow external append interface. Producing contexts continue to own the meaning of an event and decide when their approved business operation requires evidence. Composition converts trusted Identity and Organization evidence into Audit-owned logical values. Audit Application validates the immutable envelope, approved catalog registration, provenance, metadata shape, and idempotency semantics. Audit Infrastructure persists the accepted event and implements append-only controls.

The approved first physical direction is a separate Organization-level store. Existing Branch-level `audit_events` and its Orders, Payments, and Preparation writers remain unchanged in this phase. The two stores have no global ordering, shared sequence, automatic backfill, or inferred equivalence.

The external seam should remain small:

```text
append_within_owned_transaction(AppendRequest) -> PendingAppendReceipt

outermost transaction owner, after known commit:
PendingAppendReceipt -> CommittedAppendResult
```

Its interface includes the immutable envelope rules, approved-catalog requirement, idempotency outcomes, transaction participation, and safe error categories specified below. It exposes no Rails, Active Record, PostgreSQL, producer persistence record, reader, search, export, or generic event-registration interface.

## 2. Confirmed decisions and scope boundaries

### 2.1 Owner-confirmed for this design

| Decision | Consequence for the logical contract |
|---|---|
| Audit Evidence is an independent platform module/package, not a business Bounded Context. | It owns the common evidence interface and implementation, not producer business rules. It must not become a generic shared kernel. |
| Initial storage is a separate Organization-level store. | The new logical contract does not migrate or reinterpret existing Branch evidence. No immediate backfill or cross-store global order exists. |
| Failure semantics are class-specific. | The interface carries a registered failure class; it does not impose one universal fail-open/fail-closed rule. Exact event-to-class assignments remain approval work. |
| Only explicitly Owner-approved event types may be recorded. | Unknown, merely inventoried, or proposed event types are rejected. There is no unrestricted runtime registration. |
| System events require verifiable producer provenance. | `system` is an actor kind, not a substitute identity. No fabricated User UUID is permitted. |

These decisions were supplied explicitly for this task. They authorize logical design only and do not alter canonical policy files.

### 2.2 Verified existing repository facts

- ADR-0011 requires framework-independent Domain behavior, Application orchestration, Infrastructure-owned persistence, and narrow contracts at real seams ([ADR-0011](../architecture/adr/0011-project-wide-layered-ddd.md)).
- ADR-0012 preserves current Orders/Payments/Preparation transaction atomicity and context ownership; audit failure rolls back covered settlement/dispatch work ([ADR-0012](../architecture/adr/0012-ordering-payment-preparation-ddd-boundaries.md)).
- Existing `audit_events` requires a Branch, lacks Organization/event-version/outcome fields, and uses Branch-scoped idempotency ([migration](../../backend/db/migrate/20261114192000_create_order_payment_foundation.rb#L74)).
- Its model callback and PostgreSQL trigger reject ordinary update/delete, but privileged owners remain capable of disabling enforcement; production role separation is not established ([model](../../backend/app/models/audit_event.rb), [trigger migration](../../backend/db/migrate/20261114203000_protect_audit_events_append_only.rb), [Data Integrity Rules §15](../architecture/after_four_data_integrity_rules.md#15-audit-approval-and-retention-requirements)).
- Orders, Payments, and Preparation each own a narrow audit port, but their adapters directly access the root `AuditEvent` persistence record ([Orders](../../backend/app/contexts/orders/infrastructure/adapters/active_record_audit_log.rb), [Payments](../../backend/app/contexts/payments/infrastructure/adapters/active_record_audit_log.rb), [Preparation](../../backend/app/contexts/preparation/infrastructure/adapters/active_record_audit_log.rb)).
- Identity exposes verified `AuthenticatedActor` evidence and a privately issued `TrustedAuthorizationContext` containing User, Organization, and Session identifiers ([authenticated actor](../../backend/app/contexts/identity/application/contracts/authenticated_actor.rb), [trusted context](../../backend/app/contexts/identity/application/contracts/trusted_authorization_context.rb)).
- Organization has a narrow Application query for Brand ancestry, but no Branch-to-Organization ancestry contract yet ([Organization contracts](../../backend/app/contexts/organization/application/contracts), [query](../../backend/app/contexts/organization/application/queries/resolve_brand_ancestry.rb)).
- Workforce owns an Organization-scoped Employee identity and repository but has no authorized production Employee creation use case ([Employee migration](../../backend/db/migrate/20261126120000_create_workforce_employee_foundation.rb), [Workforce package](../../backend/app/contexts/workforce/package.yml)).
- Packwerk enforcement is strict within context packages, while the root package currently does not enforce dependencies ([context packages](../../backend/app/contexts), [root package](../../backend/package.yml)).

### 2.3 Still unresolved

The concrete event catalog, event-to-failure-class assignments, system-producer registry, reader/export capabilities, retention, legal holds, correction/dispute handling, privacy treatment, and production database privileges are not approved by this design. Existing event names are implementation inventory, not policy approval.

## 3. Logical envelope specification

### 3.1 Envelope shape

The logical envelope is an immutable value. Logical fields do not imply one database column per field.

| Logical field | Requirement | Assigned by | Validation and ownership | Sensitivity |
|---|---|---|---|---|
| `event_id` | Required | Audit Application using an injected identifier source, unless an approved stable producer event ID is explicitly supported later | Canonical UUID; immutable; never derived from business or personal values | Low alone; correlatable |
| `organization_reference` | Required | Trusted composition from authenticated scope or authoritative resource ancestry | Typed canonical UUID; exactly one Organization; must agree with actor and target scope evidence | Tenant-security identifier |
| `registration_reference` | Required internally; absent from producer draft | Audit Application from the immutable reviewed operation registration | Typed UUID binding producer/type/version, failure class and schema policy to the database projection | Low alone; security-sensitive configuration identity |
| `event_type` | Required | Producer Application from a compile-time/reviewed producer port operation | Stable namespaced code; must match an Owner-approved catalog entry for that producer and version | Can reveal sensitive activity |
| `event_version` | Required | Producer contract, checked by Audit Application | Positive registered version; version identifies envelope interpretation and event-specific metadata schema | Low |
| `occurred_at` | Required | Producer Application from its authoritative server clock/decision point | Finite offset-aware instant; cannot be accepted solely from a client. Empty Slice 1 rejects infinity but sets no arbitrary finite range. Every producer must define acceptable past age, future skew, clock assumptions, retry and delayed-event treatment. | Employee/activity timing |
| `recorded_at` | Required in persisted envelope, absent from producer draft | Persistence adapter from database/server persistence time | Set once when append becomes durable; distinct from occurrence time; replay returns original value | Activity timing |
| `actor` | Required; human only in Slice 1 | Trusted composition | Trusted User and Organization evidence; never a free-form client map. System actor input is not exposed by Slice 1. | Security/personal data |
| `system_producer_provenance` | Disabled in Slice 1 | Not accepted by the Slice 1 append interface | A future system-actor slice requires separately approved producer identity, custody, rotation, and provenance | Operational/security evidence |
| `correlation_id` | Optional unless catalog entry requires it | Trusted request/workflow composition | Opaque stable identifier for one workflow; never a token or credential | Correlatable |
| `causation_id` | Optional unless caused by a durable command/event | Producer Application | Opaque reference to the immediate causal item; absence must not be interpreted as no cause | Correlatable |
| `target_type` | Conditional | Producer Application | Required when an approved target exists; fixed by catalog entry; no arbitrary class name | May disclose resource class |
| `target_id` | Conditional with target type | Producer Application after scoped lookup/creation | Typed opaque identifier; no cross-context polymorphic FK is implied; absent when no durable target exists | Often personal/business sensitive |
| `outcome` | Required | Producer Application from known operation result | Must be one of the catalog entry's approved outcomes; no success claim for ambiguous execution | Security/business evidence |
| `stable_attempt_key` | Required in Slice 1 | Producer Application from stable logical operation identity | Non-secret, bounded, stable across retries; uniqueness is scoped only by Organization + Producer + this key. Event type/version are compared replay facts, not uniqueness dimensions. | Correlatable |
| `metadata` | Optional | Producer Application | Immutable, versioned, event-specific allowlist; unknown keys and invalid types rejected | Highest leakage risk |

### 3.2 Required envelope invariants

1. The envelope belongs to exactly one Organization.
2. Slice 1 has no Branch field or concept to accept: no column, FK, target reference, validation path, catalog mode, fixture or indirect identity may be introduced.
3. The `(event_type, event_version, producer)` combination is an explicitly approved catalog entry.
4. Slice 1 accepts trusted human actor evidence only. System provenance is disabled.
5. A human actor's Organization equals the event Organization. A human actor identifier is never taken from request parameters as authority.
6. A system event has no fabricated human actor ID and has registered producer provenance.
7. Target presence, type, outcome, metadata, correlation, causation, and idempotency requirements match the catalog entry.
8. `occurred_at` is finite authoritative server evidence. `recorded_at` is finite, database-assigned only when persisted, and never caller-controlled. Event-specific age/skew policy remains required before producer activation.
9. The accepted envelope and metadata are immutable. A later correction or dispute is a new approved event, not a rewrite.
10. Validation failure produces no audit row and must not be silently downgraded to a different event type.

### 3.3 Conditional versus optional data

- **Absent from Slice 1:** every Branch representation, including an optional/null field or indirect identity.
- **Forbidden in Slice 1:** system provenance.
- **Conditional:** target, human Session reference, correlation, and causation are required when their approved catalog entry says so.
- **Required in Slice 1:** a stable attempt key for every append request, even while the empty catalog causes all requests to be denied.
- **Optional tracing:** correlation and causation remain absent when no trustworthy identifier exists; Audit must not generate misleading links.
- **Event-specific only:** role/capability, safe reason code, safe before/after semantic summary, source/device lookup reference, monetary summary, and domain revision belong only in approved metadata schemas.
- **Not accepted:** persistence records, request objects, exceptions, raw headers/bodies, arbitrary nested hashes, and client timestamps presented as authoritative evidence.

All machine identifiers use the explicit ASCII, case-sensitive, no-normalization grammar in [Security Design Closure §4.2.2](organization_level_audit_security_design_closure.md#422-authoritative-identifier-grammar-and-normalization-policy). UUID references are opaque typed values. The Stable Attempt Key is never trimmed, folded or Unicode-normalized; invalid whitespace/control-bearing values are rejected before catalog lookup or replay so two inputs cannot silently collapse into one identity.

Every collatable identity and policy value is compared as its exact validated UTF-8 byte sequence. PostgreSQL storage, indexes, unique constraints, lookups, replay predicates and catalog array equality/membership/subset operations use explicit deterministic `COLLATE "C"`; Application and registration-projection comparisons perform no locale comparison, case folding, punctuation elision, trimming or Unicode normalization. The target database requires `server_encoding = UTF8`, while every Rails/restore/migration session requires `client_encoding = UTF8`. Creation, migration, `structure.sql` load, logical restore with/without `--create`, isolated physical-restore acceptance, connection establishment, startup/service return and monitoring have separate fail-closed gates in the [authoritative UTF-8 lifecycle matrix](organization_level_audit_security_design_closure.md#utf-8-lifecycle-enforcement-matrix). PostgreSQL can fail during parse, function resolution, parameter bind/protocol decoding or argument conversion before the function body starts; that path is not guaranteed to carry `AUE02`. After successful function entry, the append function independently checks the exact executing session as its first control and raises `AUE02` on mismatch. Both paths fail closed and unwind without a receipt, later statement or alternate-connection fallback. A migration, startup or representative-session check is not evidence for another lifecycle stage or append session.

## 4. Append Application contract proposal

### 4.1 Transaction-participating interface

Conceptual framework-independent interface:

```text
AppendRequest
  organization_scope_evidence
  actor_evidence
  producer_operation
  event_draft

append_within_owned_transaction(AppendRequest) -> PendingAppendReceipt
```

`producer_operation` is a reviewed producer-owned port operation, not a caller-supplied producer key or registration. Audit Application maps it to an immutable Audit-owned registration containing registration UUID, producer/type/version, failure class and event-schema policy. `event_draft` contains occurrence time, target, outcome, idempotency, correlation/causation and metadata. It does not contain `registration_id`, `producer_key`, `event_type`, `event_version`, `failure_class`, `recorded_at`, persistence state, Active Record objects, table names or SQL transaction handles.

The Audit Application append seam has one transaction-participating operation because catalog validation, provenance, scoping, replay, and persistence semantics provide the leverage. Its return type is deliberately provisional. Event-specific convenience methods remain producer-owned ports; they must not inflate the Audit interface or translate a pending receipt into success.

Audit Evidence is the sole authority for event registration and failure-class selection. The producer cannot provide or downgrade a failure class. The database catalog is an enforcement projection of the same immutable registration; the exact registration binding and release synchronization are specified in the [security closure §4.2.3](organization_level_audit_security_design_closure.md#423-failure-class-authority-and-registration-binding).

### 4.2 Provisional and committed result contracts

`PendingAppendReceipt` is an internal, non-durable value returned only after the append function has produced a transaction-local disposition. It contains the Organization, producer and Stable Attempt Key identity required for reconciliation; the registration/type/version identity; the event ID and database-assigned `recorded_at`; and exactly one provisional disposition: `inserted_in_current_transaction` or `matched_existing_in_current_snapshot`. It is not proof of commit, is not an HTTP or producer success result, and must not be published outside the owning transaction coordination boundary.

`CommittedAppendResult` is a post-commit Application value containing the event ID, canonical `recorded_at`, registration/type/version identity and exactly one committed disposition: `appended` or `idempotent_replay`. It may be constructed only by the service that owns the outermost transaction, after that service has positive evidence that its commit completed. Function return, an inner transaction return, savepoint release, or callback registration is insufficient.

| Result | Meaning | Required returned evidence |
|---|---|---|
| Internal `inserted_in_current_transaction` | The function inserted a row visible in the current transaction | `PendingAppendReceipt`; explicitly not a durable/external success |
| Internal `matched_existing_in_current_snapshot` | The function found an identical row visible to the current statement | `PendingAppendReceipt`; it does not claim whether the row committed earlier or was inserted earlier in the same open transaction |
| Committed `appended` | The inserted row survived successful commit of the owning outermost transaction | `CommittedAppendResult` with canonical event evidence |
| Committed `idempotent_replay` | The matched event is durable after successful commit of the current owning outer transaction | `CommittedAppendResult` carrying the original event evidence; no second row |
| Rolled back | The supported outer transaction containing the append did not survive | Discard the affected receipt; no committed result; Audit append in a real savepoint is unsupported |
| Commit outcome unknown | The connection/process lost authoritative commit knowledge | Reconciliation-required outcome, never a committed result |
| Conflicting replay | Same identity resolves to different immutable facts | Integrity error; neither pending nor committed success |

An idempotent replay is a successful post-commit Application result, not a newly recorded event. A caller must not infer that the current business operation ran again. Neither low-level function disposition is producer-visible success before commit.

### 4.3 Error categories

| Error category | Examples | Safe handling |
|---|---|---|
| `invalid_envelope` | Malformed UUID/time, missing conditional field, unknown metadata key, invalid scalar/size, target mismatch | Reject without persistence; expose a stable internal category, not sensitive detail to clients |
| `event_not_approved` | Unknown type/version, wrong producer, retired/unapproved or registration-mismatched catalog entry; mapped only from project SQLSTATE `AUE01` | Reject fail closed; never fall back to a generic event and never disclose which registration fact differed |
| `security_control_failure` | Native parse/resolution/bind/decode/conversion failure occurs before function entry; or, after successful entry, the exact append session has non-UTF8 server/client encoding (`AUE02`); or another native privilege/security boundary fails | Unwind the whole transaction; no receipt or successful result, later Audit/business statement, partially valid continuation, alternate connection or fallback retry merely to bypass the failed control |
| `untrusted_actor_or_producer` | Client actor UUID, unissued actor evidence, unregistered system producer, missing provenance | Reject; treat repeated attempts as a security signal outside the rejected payload |
| `scope_mismatch_or_unavailable` | Actor/Organization mismatch or missing/stale/unavailable trusted scope evidence | Fail closed; use indistinguishable public behavior where resource visibility is sensitive |
| `conflicting_replay` | Same idempotency identity but different type, version, actor, target, outcome, occurrence facts, or metadata | Reject as integrity conflict; never overwrite or append a disguised duplicate |
| `storage_unavailable` | Connection/timeout/resource failure before durable append | Apply registered failure-class behavior; never claim append success |
| `integrity_failure` | Database constraint, uniqueness race with nonmatching row, trigger/privilege drift—including native PostgreSQL `42501`—or malformed persisted replay | Fail closed for authoritative paths, alert operations, preserve safe failure reference; never mislabel native permission failure as policy denial |

These are logical categories, not exception class names or HTTP responses. Public responses remain the producing use case's responsibility and must not reveal cross-Organization resource existence.

The PostgreSQL adapter derives categories only from the driver's structured `PG_DIAG_SQLSTATE` field. It never parses exception messages. Project state `AUE01` maps only to `event_not_approved`; `AUE02` maps only to permanent security-control failure after successful function entry reaches the exact-session guard. A native parse/resolution/bind/decode/conversion failure before entry keeps its structured PostgreSQL state and is never reclassified as `AUE02`, policy denial or success. `42501` is a privilege/security-control failure; `23505` is handled as an idempotency race only for the exact reviewed unique constraint and only after the append function's comparison semantics; `40001` and `40P01` require the entire owning transaction to unwind and may be retried only under a separately approved bounded whole-transaction policy with the same stable identity. Every pre-entry or in-function database failure constructs no receipt or successful Application result, permits no later Audit/business statement or partially valid continuation, unwinds the whole transaction and forbids alternate-connection fallback. A missing cause/result, malformed function result or unknown SQLSTATE is `storage_unavailable`/`integrity_failure` plus operational alert, never success.

### 4.4 Transaction participation

- The supported outer owner obtains and holds one `with_connection` lease, proves that the selected adapter/root has no active or failed transaction, and then opens the outer transaction itself. An ambient transaction that predates entry fails closed; Audit Evidence does not infer ownership from call depth, `transaction_open?`, `PG::PQTRANS_INTRANS` or a Rails transaction UUID.
- Only that outer wrapper may issue one opaque `TransactionParticipationCapability`, and only from the transaction object yielded by the transaction it just opened after exact current-transaction identity is confirmed. A joined inner service reuses the existing capability; a nested issuer fails closed. Audit performs no connection lookup, lease, switch or independent transaction and returns only `PendingAppendReceipt`.
- If a future authorized Audit use case owns the outermost transaction itself, it may return `CommittedAppendResult` only after the transaction API has returned with commit known successful. If that boundary cannot prove commit synchronously, it returns a pending/reconciliation outcome instead.
- Capability identity/lifetime is defined by [Security Design Closure — Rails connection policy](organization_level_audit_security_design_closure.md#authoritative-rails-connection-and-transaction-participation-policy): held lease, specification, role/shard pool, adapter/raw connection, exact yielded/current outer transaction object/UUID, Thread/Fiber and fresh attempt generation must all match immediately before SQL. Transaction exit, rollback, retry replacement, connection release/reconnect or execution-context change invalidates it.
- For an approved `atomic_fail_closed` event, business state and audit append commit or roll back together.
- For approved durable denial/failure evidence, the producing Application may invoke a separate evidence transaction only after the business transaction has not committed and only with facts known to be true.
- The public producer contract exposes no capability, adapter or transaction object. Private Application/Infrastructure composition supplies them only inside the lexical owner boundary.
- A joined scope is supported only when Rails returns the exact same public transaction object and UUID and it reuses the sole outer-issued capability. Audit append inside `requires_new`, `SavepointTransaction`, `RestartParentTransaction`, a real savepoint/restarted-parent scope or another current transaction object is unsupported and fails before SQL; no receipt is created and no private Rails parent-stack traversal is allowed. An inner block outcome never proves outer commit.
- Registering or running an `after_commit` callback does not by itself let the original synchronous caller claim a committed result. Callback timing, process termination and callback failure must be treated as publication/reconciliation concerns unless a later authorized implementation contract proves otherwise.
- No HTTP success, downstream notification, or other external success effect may be emitted before the outermost commit is known successful. Post-commit message delivery may require a separately approved reliable mechanism; none is selected here.
- Known outer rollback discards the receipt. Connection loss around commit, process termination before result publication, or any other uncertain commit produces reconciliation-required, never success. Lookup/retry uses the same Organization + Producer + Stable Attempt Key and resolves to insert, committed match, or conflict without generating a replacement key.
- A storage failure never becomes `appended` or `idempotent_replay`. Retry behavior is determined from the business outcome and stable idempotency evidence, not from an optimistic assumption.
- Any database error invalidates the current PostgreSQL transaction for further work. The adapter must propagate/unwind to the outer transaction owner; it must not issue another query, append, reconciliation lookup, log write or retry inside the failed transaction. A provisional receipt is discarded on rollback. Only a fresh whole transaction may retry an approved transient state, and no retry can manufacture a committed result.

The same fail-closed identity discipline applies to load/restore acceptance. A trusted orchestrator issues one non-reusable restore-attempt ID and unique invocation, binds all evidence to one source artifact and one fenced target generation, and permits at most one active attempt to own that generation. Generation identity is revalidated before mutation, after restore, immediately before promotion and inside the atomic one-way `QUARANTINED -> ACCEPTED` decision. Reused, stale, duplicated, mixed, incomplete, superseded or generation-mismatched evidence cannot be combined or promoted. If a selected provider/orchestrator cannot guarantee exclusive ownership and atomic check-and-transition, the target remains quarantined; provider-specific generation and fencing mechanisms remain unresolved.

## 5. Actor and provenance model

### 5.1 Human actor

Logical human evidence contains a trusted User reference and Organization reference, plus a Session lookup reference only where the approved catalog requires it. It originates from verified Identity authentication evidence. The composition adapter maps `Identity::Application::Contracts::TrustedAuthorizationContext` into an Audit-owned immutable value; Audit does not import Identity Infrastructure, query Users/Sessions, or accept a request `actor_id`.

Ruby constructor visibility is not an absolute trust boundary. Trust also depends on composition wiring, Packwerk dependency enforcement, the absence of public generic constructors, and tests proving request parameters cannot issue trusted evidence. Exact issuance mechanics belong to later implementation design.

Human actor evidence establishes authentication provenance, not permission by itself. The producer Application remains responsible for authorization and records only the approved capability/decision evidence required by its event catalog.

### 5.2 Future system actor and producer provenance — disabled in Slice 1

Slice 1 does not accept a system actor. In a separately approved future slice, `actor_type=system` would mean no authenticated human directly initiated the recorded action; by itself it would not identify which job, scheduler, process, or operational authority acted.

System producer provenance is therefore a separate required value. Proposed logical content is:

- a stable allowlisted producer key owned by the module that performs the operation;
- the registered event types/versions it may emit;
- an accountable invocation/correlation reference when the catalog requires one; and
- a provenance version so changes remain interpretable.

This registration model is `PROPOSED_NOT_OWNER_APPROVED`. It does not create a system UUID, service account, scheduler identity, background-job identity, or general registration endpoint. Registration must be code-owned, reviewed, deny-by-default, and changed only with Owner event-catalog approval and security review.

### 5.3 Composition seam

Composition is the only place that sees both producer dependencies and trusted cross-module evidence. It:

1. receives the verified Identity context or approved system invocation evidence;
2. obtains Organization-owned ancestry evidence through an Organization Application contract when required;
3. maps both into Audit-owned values;
4. supplies the Audit adapter to the producer-owned audit port; and
5. never exposes Identity, Organization, Workforce, or producer persistence records to Audit.

## 6. Organization scope and separate legacy/future Branch context

1. Every accepted event has exactly one `organization_reference`.
2. Organization scope comes from trusted Identity context, an already scoped authoritative resource, or an Organization-owned Application contract—not solely from a client header/body/path.
3. Slice 1 has no Branch input or storage shape. A Slice 1 implementation must not introduce a Branch column, Branch FK, Branch target, Branch validation path, Branch catalog mode, Branch fixture or indirect Branch identity.
4. Future Branch support is outside this contract. It would require a separate Owner decision, ancestry/integrity design and independent review; Slice 1 reserves no physical or logical Branch shape.
5. In that future slice, missing, invalid, stale, inconsistent, unavailable, or Organization-mismatched ancestry would fail closed for an append that requires it.
6. Scope validation precedes target lookup or any result that could distinguish an out-of-scope resource.
7. Audit does not add Membership, authorize Organization access, infer employment, or infer Employee Branch Assignment.
8. The initial Organization-level store is not a route for duplicating existing Branch events. Catalog approval must explicitly identify which store receives an event.

## 7. Proposed event catalog and approval status

### 7.1 Catalog record structure

Each reviewed catalog entry should contain:

| Catalog attribute | Purpose |
|---|---|
| Event type and version | Stable interpretation identity |
| Owning producer module | Sole owner of event meaning |
| Intended store | Initial Organization store or existing Branch store; never both by accident |
| Target semantics | Required/optional target type and meaning |
| Allowed outcomes | Prevent unapproved success/failure claims |
| Required/optional metadata schema | Strict allowlist and sensitivity classification |
| Actor/provenance rule | Human, system, or explicitly approved alternatives |
| Correlation/causation/idempotency rule | Replay and traceability requirements |
| Failure class | Approved transaction/failure handling |
| Sensitive-data class | Reader, redaction, and review input; not a retention duration |
| Approval status and provenance | Owner decision reference/date; no runtime activation without it |

There is no public or runtime `register_event_type` operation. A catalog change is a reviewed code/design change with Owner approval of event meaning and failure class, plus security/privacy review where data changes.

### 7.2 Existing runtime inventory

The following names describe current Branch-store implementation only. No explicit Owner approval of these concrete catalog entries was found, so every row remains `PROPOSED_NOT_OWNER_APPROVED` for catalog purposes.

| Existing event type | Producer | Existing target | Existing metadata evidence | Existing idempotency evidence | Proposed failure class | Approval status |
|---|---|---|---|---|---|---|
| `order.created` | Orders | Order | `channel` | Creation command key embedded in event key | Current transaction evidence suggests atomic fail-closed; requires approval | `PROPOSED_NOT_OWNER_APPROVED` |
| `order.confirmed` | Orders | Order | `payment_expires_at` | Confirmation key | Current transaction evidence suggests atomic fail-closed; requires approval | `PROPOSED_NOT_OWNER_APPROVED` |
| `order.held` | Orders | Order | `reason` | Hold key | Current transaction evidence suggests atomic fail-closed; requires approval | `PROPOSED_NOT_OWNER_APPROVED` |
| `order.payment_window_expired` | Orders | Order | None | Order identity | Current transaction evidence suggests atomic fail-closed; requires approval | `PROPOSED_NOT_OWNER_APPROVED` |
| `payment.amount_mismatch` | Payments | Payment Attempt | Method, received amount, currency | Order plus Attempt command identity | Exact business failure class requires approval | `PROPOSED_NOT_OWNER_APPROVED` |
| `payment.confirmed` | Payments | Payment Attempt | Method, amount, currency, optional Dispatch | Order plus Attempt command identity | Current settlement evidence suggests atomic fail-closed; requires approval | `PROPOSED_NOT_OWNER_APPROVED` |
| `payment.late_success_recorded` | Payments | Payment Attempt | Method, amount, currency, Review Case | Shares current confirmation key shape | Current settlement evidence suggests atomic fail-closed; requires approval | `PROPOSED_NOT_OWNER_APPROVED` |
| `preparation.dispatch_requested` | Preparation | Preparation Dispatch | Order ID | Dispatch command key | Current transaction evidence suggests atomic fail-closed; requires approval | `PROPOSED_NOT_OWNER_APPROVED` |
| `preparation.dispatch_retry_requested` | Preparation | Preparation Dispatch | None | Dispatch plus retry command key | Current transaction evidence suggests atomic fail-closed; requires approval | `PROPOSED_NOT_OWNER_APPROVED` |

The current names, metadata, and key shapes are verified inventory from the three adapters; they are not automatically valid future schema or approved event policy. No Employee, Identity, Organization, audit-read, export, or hold event is proposed or authorized here.

## 8. Failure semantics matrix

The matrix defines candidate logical classes. Assignment of any concrete event type to a class is `OWNER_DECISION_REQUIRED` unless already explicitly approved.

| Operation category | Authoritative evidence expectation | Append failure effect | Separate durable evidence transaction | Never claim |
|---|---|---|---|---|
| Successful financially material or security-sensitive mutation | Required under confirmed audit policy where its event type is approved | Candidate `atomic_fail_closed`: roll back the mutation | Not a substitute for the atomic success event | Success if append did not commit; a rolled-back mutation as completed |
| Successful ordinary mutation | Event-specific; approval required | Either atomic fail-closed or operationally recoverable behavior must be approved per event | Only if approved and the business outcome is independently known | That all ordinary mutations are safely fail-open |
| Denied request before state change | Often required for sensitive denial, but concrete type/data remain unapproved | Denial remains denial; inability to record evidence must not grant access | Candidate separate transaction using trusted, minimized facts | Target existence, authenticated actor, or reason not actually known |
| Rejected validation attempt | Event-specific; avoid noisy or sensitive evidence by default | Business rejection remains effective | Only for an approved security/abuse event | A durable target or business mutation |
| Failed mutation | Event-specific, based on known execution result | Do not convert failure into success; fail closed where evidence is mandatory | Permitted only after rollback and only with facts known after failure | That state is unchanged unless rollback/preservation is proven |
| Ambiguous outcome | Evidence should record uncertainty where an approved event exists | Hold/reconcile; no success inference | May preserve an `unknown` outcome if approved | Success, failure, or safe retry without authoritative evidence |
| Duplicate/idempotent replay | Return original matching event | No new business outcome or event | No | That the business operation executed again |
| Conflicting replay | Integrity error and operational signal | Fail closed; preserve original event | A separately approved conflict event may be recorded without rewriting original | That conflict is an idempotent success |
| System-generated operation | Same class-specific rules as the underlying operation plus system provenance | Missing/untrusted provenance fails closed where evidence is required | Event-specific | A human actor or unregistered producer |

The final event catalog must name the failure class; callers may not select a weaker class at runtime.

## 9. Idempotency and consistency rules

1. The idempotency identity is exactly Organization + Producer + Stable Attempt Key. Event type and event version are immutable replay-comparison fields and never expand the uniqueness identity.
2. The producer creates a stable key from the logical command/attempt identity. Random keys generated on every retry do not provide idempotency.
3. A matching replay returns the original `event_id` and `recorded_at`; it inserts nothing and changes nothing.
4. Replay equality covers event type/version, finite authoritative occurrence time, human actor/session, correlation, causation, target, outcome, and metadata. Organization, producer, and stable attempt key locate the original. `event_id` and database-assigned `recorded_at` are excluded from equality. Any other mismatch is a conflict.
5. Concurrent attempts resolve to one append plus matching replay, or one append plus conflict. Both cannot create distinct authoritative events for the same logical key.
6. Distinct attempts must have distinct logical keys even if they share correlation, target, and outcome. Duplicate suppression must not erase repeat abuse, retry attempts, or separate business actions.
7. `occurred_at` records the producer's authoritative business/security decision time. `recorded_at` records durable persistence time. Neither creates a total order across transactions.
8. `correlation_id` groups a workflow; `causation_id` identifies immediate cause. Neither participates in authorization and neither proves completion.
9. No global sequence or ordering exists across the separate Organization and Branch stores. Cross-store views must state this limitation and order only by explicit timestamps/causal evidence with uncertainty preserved.

## 10. Metadata and privacy rules

### 10.1 Allowlist model

Every approved `(event_type, event_version)` owns a closed metadata schema specifying keys, scalar/container types, requiredness, semantic meaning, maximum cardinality, and sensitivity. Unknown keys, unexpected nesting, unsupported types, and over-limit values are rejected before persistence. Catalog outcome and metadata-key arrays use element-wise validation; delimiter-joined serialization is forbidden because one comma-bearing element must never masquerade as two valid elements.

`allowed_outcomes`, `allowed_metadata_keys` and `required_metadata_keys` are logical sets with one reviewed ordered representation per immutable registration. Duplicate elements are invalid. Equality for duplicate detection and registration projection is exact, case-sensitive and C-collation-compatible under the existing lower-case grammar. Application validation must reject duplicates before projection; persistence must not trim, fold, normalize, deduplicate, sort or reorder. Array order does not change membership semantics, but it is part of the reviewed physical representation: arrays containing the same elements in a different order are not projection/hash-equal and require the manifest's exact order. Required-key subset semantics are unchanged.

#### 10.1.1 Authoritative registration projection identity

The canonical format identifier is `after-four.audit-registration-projection`; its byte magic is the ten ASCII octets `AF-AUD-REG` (`41 46 2d 41 55 44 2d 52 45 47`). The only defined format version is unsigned 16-bit big-endian `1`. Hash algorithm identifier `0x01` means SHA-256 as defined by FIPS 180-4. The canonical header is exactly:

```text
magic[10] | format_version:u16be | hash_algorithm:u8 | field_count:u16be
```

For version 1, `field_count` is unsigned 16-bit big-endian `21` (`00 15`). The fifteen-byte header is therefore `41 46 2d 41 55 44 2d 52 45 47 00 01 01 00 15`. The header, including format and hash-algorithm identifiers, is part of the hashed bytes.

A future field, field order, field encoding, projection format or hash algorithm requires a new projection-format version and separate review. It never re-encodes an existing immutable registration silently. Existing registrations retain their original format version, exact canonical bytes and digest; a verifier must support that version exactly or fail closed. A projection-version mismatch is not drift repair and cannot activate a producer.

#### 10.1.2 Record and field framing

The header is followed by exactly 21 fields. Every field uses this eight-byte frame followed by its payload:

```text
field_tag:u16be | type_tag:u8 | presence:u8 | payload_length:u32be | payload[payload_length]
```

Tags are the decimal values below encoded unsigned big-endian. Type tags are `0x01 UTF8_TEXT`, `0x02 UUID`, `0x03 UINT16`, `0x04 UINT32`, `0x05 DATE_DAYS`, and `0x06 UTF8_TEXT_ARRAY`. `0x07 BOOLEAN` is reserved with a one-byte payload (`00` false, `01` true), but version 1 has no Boolean field; its appearance is invalid. Presence is exactly `0x00` for SQL/logical null or `0x01` for present. A null field has its declared type tag, zero payload length and no payload. A present empty text has presence `0x01` and zero payload length, so it cannot equal null. Other presence values are invalid.

The version-1 decoder is strict and consumes one finite input buffer. It requires the exact magic, version, algorithm and field count; tags `1..21` exactly once and in ascending order; the declared type for every tag; and the permitted presence for that field. Fixed-width present payload lengths are exactly 16 for `UUID`, 2 for `UINT16`, 4 for `UINT32`, 4 for `DATE_DAYS`, and 1 for any future versioned `BOOLEAN`. A null field must have length zero. Missing, repeated, unknown or out-of-order tags; wrong type/presence/length; truncated headers, frames or payloads; and any byte after the fully consumed field-21 payload are invalid. There is no extension/trailing-data area in version 1.

All length/count arithmetic is checked before slicing or allocating. Encoders reject a field payload or complete record whose lengths cannot be represented by the specified unsigned widths. Decoders compare each `u32` length/count with the bytes remaining, use checked arithmetic at least 64 bits wide for `offset + length` and cumulative element frames, and never allocate from `element_count` until the payload proves that count can fit. Overflow, underflow or a sum beyond the actual input is `invalid_projection`, never truncation, wraparound or partial acceptance.

| Tag | Field | Type | Version-1 null rule |
|---:|---|---|---|
| 1 | `registration_id` | `UUID` | Forbidden |
| 2 | `producer_key` | `UTF8_TEXT` | Forbidden |
| 3 | `event_type` | `UTF8_TEXT` | Forbidden |
| 4 | `event_version` | `UINT16` | Forbidden |
| 5 | `actor_type` | `UTF8_TEXT` | Forbidden |
| 6 | `system_producer_key` | `UTF8_TEXT` | Required null in Slice 1 |
| 7 | `system_producer_version` | `UINT16` | Required null in Slice 1 |
| 8 | `session_reference_mode` | `UTF8_TEXT` | Forbidden |
| 9 | `target_reference_mode` | `UTF8_TEXT` | Forbidden |
| 10 | `target_type` | `UTF8_TEXT` | Required null when target mode forbids a target; null forbidden otherwise |
| 11 | `correlation_mode` | `UTF8_TEXT` | Forbidden |
| 12 | `causation_mode` | `UTF8_TEXT` | Forbidden |
| 13 | `idempotency_mode` | `UTF8_TEXT` | Forbidden |
| 14 | `system_invocation_mode` | `UTF8_TEXT` | Forbidden |
| 15 | `allowed_outcomes` | `UTF8_TEXT_ARRAY` | Forbidden; array must be nonempty |
| 16 | `allowed_metadata_keys` | `UTF8_TEXT_ARRAY` | Forbidden; empty array permitted |
| 17 | `required_metadata_keys` | `UTF8_TEXT_ARRAY` | Forbidden; empty array permitted |
| 18 | `metadata_max_bytes` | `UINT32` | Forbidden |
| 19 | `failure_class` | `UTF8_TEXT` | Forbidden |
| 20 | `owner_decision_reference` | `UTF8_TEXT` | Forbidden |
| 21 | `owner_decision_date` | `DATE_DAYS` | Forbidden |

No field outside this existing registration/catalog contract is projected. Source-file paths, comments, reviewer identity, release timestamp, display formatting and the lower-case hexadecimal rendering of the digest are excluded because they are release metadata rather than registration semantics. Exclusion does not relax the separately required Owner-decision provenance fields 20 and 21.

#### 10.1.3 Scalar encoding and validation

- `UTF8_TEXT` is the exact Unicode scalar sequence encoded as shortest-form UTF-8 with no BOM. Invalid UTF-8, surrogate code points, non-shortest encodings and U+0000 are rejected before projection; the rule also applies to every array element. U+0000 is excluded because PostgreSQL `text`/`varchar` cannot represent it, so no Application-only projection may accept a value that persistence cannot reproduce. No Unicode normalization, trimming, case folding or character replacement occurs. Machine identifiers must first pass the existing ASCII grammar. A zero-length present value is encoded distinctly but is valid only if the existing field contract permits it; projection never makes an otherwise invalid empty value valid.
- `UUID` is exactly 16 octets in RFC 4122/network byte order corresponding to canonical text groups `8-4-4-4-12`; no textual UUID bytes or braces enter the projection.
- `UINT16` and `UINT32` are respectively two and four octets, unsigned big-endian. Version-1 field validation still requires positive values and existing field-specific ranges before projection.
- `DATE_DAYS` is a signed 32-bit two's-complement big-endian count of proleptic-Gregorian calendar days from `1970-01-01`, where that date is zero. Version 1 accepts only civil dates `0001-01-01` through `9999-12-31`, with no year zero or BC notation. Define `ordinal(0001-01-01) = 1` under the proleptic-Gregorian leap-year rule; the encoded count is `ordinal(date) - 719163`. The inclusive accepted counts are therefore `-719162` through `2932896`. PostgreSQL extraction and Application validation must reject any date outside this common range before projection. It encodes a date only, with no time zone or time of day.
- Version 1 contains no Boolean field. If a future reviewed format uses `BOOLEAN`, only one payload octet `00` or `01` is valid; adding such a field requires a new format version.
- Missing required values, disallowed nulls, invalid types, invalid grammar, out-of-range numbers and values inconsistent with mode/shape constraints are rejected before canonical bytes exist.

#### 10.1.4 Array encoding and order

For each `UTF8_TEXT_ARRAY`, the field payload is:

```text
element_count:u32be | repeated(element_length:u32be | element_utf8[element_length])
```

The outer field's `payload_length` covers the count and every element frame. Each element uses the exact `UTF8_TEXT` rules. Order is preserved exactly. A present empty array is `presence=01`, `payload_length=4`, payload `00 00 00 00`; it is distinct from null, which is not valid for any version-1 array. Null elements are unrepresentable and rejected before projection. Duplicate elements are rejected using exact byte equality after the existing grammar has accepted each value; no sorting, deduplication, trimming, normalization or reordering occurs.

The array decoder requires `payload_length >= 4`, reads exactly `element_count` frames, and requires the last element byte to end exactly at the outer payload boundary. A count that cannot fit the remaining payload, a truncated element frame/value, cumulative length overflow, fewer or more elements than declared, or unconsumed bytes inside the outer payload is `invalid_projection`.

Application input must be a one-dimensional, zero-based logical sequence. PostgreSQL extraction must first prove the existing database rule: a nonempty array has one dimension and lower bound 1, while its canonical empty metadata array has cardinality zero and no dimensions. Only then is it mapped element-for-element to the logical sequence. A multidimensional, non-1-lower-bound nonempty, SQL-NULL or SQL-NULL-bearing array is invalid and never projected. Membership and required-key subset checks remain order-independent; immutable registration identity remains positional.

#### 10.1.5 Hash, authority, comparison and conformance fixtures

The SHA-256 input is every canonical byte from the first magic octet through the final byte of field 21, with no prefix, suffix, newline or external field. The authoritative digest is the 32 raw SHA-256 octets. Documentation and release evidence render those octets as exactly 64 lower-case hexadecimal ASCII characters; that display string is not re-hashed. A reviewer can independently reproduce the digest by constructing the header and 21 frames exactly as above and applying SHA-256 once.

Audit Evidence already owns immutable registration and failure-class authority. Its Application registration boundary is therefore the single logical projection authority. The future authorized implementation must provide one versioned encoder at that boundary; the exact class, build packaging and invocation mechanism remain unresolved implementation design and are not selected here. Application registration, catalog-fixture generation, release tooling and drift inspection must invoke that authority or consume its exact canonical-byte artifact. PostgreSQL array text, Ruby object serialization, arbitrary JSON and delimiter-joined text are never canonical and must not be independently hashed.

The five distinct artifacts are:

1. logical registration data validated against the registration contract;
2. canonical projection bytes emitted once by the Audit-owned authority;
3. immutable reviewed release evidence retaining format ID/version, algorithm ID, canonical bytes and digest alongside the catalog field projection;
4. the raw digest plus its lower-case hexadecimal display; and
5. an exact comparison result: `match`, `invalid_registration`, `projection_version_mismatch`, `hash_algorithm_mismatch`, `invalid_projection`, `digest_mismatch`, `registration_identity_mismatch`, or `projection_bytes_mismatch`.

Release verification uses this normative precedence so one input has one result even when several faults coexist:

1. reject invalid logical/Application or typed catalog values as `invalid_registration` before encoding;
2. reject wrong magic, unsupported/different format version, or field count as `projection_version_mismatch`;
3. reject an unsupported/different algorithm identifier as `hash_algorithm_mismatch`;
4. strictly decode both projections; framing, type, presence, length, order, truncation, overflow or trailing-byte failure is `invalid_projection`;
5. recompute SHA-256 over each complete canonical byte string and compare it with that artifact's supplied raw digest; any failure is `digest_mismatch`;
6. compare `registration_id`, `producer_key`, `event_type` and `event_version`; a difference is `registration_identity_mismatch`;
7. compare the complete canonical byte strings positionally; a difference is `projection_bytes_mismatch`; otherwise return `match`.

Hash equality alone never substitutes for byte or identity comparison. A reordered but otherwise valid registration carries its correctly recomputed digest and therefore reaches step 7. Unsupported versions are never decoded as version 1. Every non-`match` result fails closed and aborts installation or producer activation. No path repairs or re-encodes an existing registration.

The future conformance-fixture manifest is language-neutral. Every fixture contains `fixture_id`, all 21 logical fields (or an explicit invalid input), the expected tag sequence `1..21`, expected projection format/version and hash algorithm, `expected_projection_hex`, `expected_sha256_hex`, expected comparison result and rejection stage. The base valid fixture is explicitly test-only and cannot become a catalog approval: UUID `00000000-0000-4000-8000-000000000001`; producer `fixture.audit`; event type `fixture.event`; version `1`; actor `human`; null system fields; session/correlation/causation modes `optional`; target mode `forbidden` with null target type; idempotency `required`; system invocation `forbidden`; outcomes `[accepted, rejected]`; allowed metadata keys `[reason_code, source]`; empty required keys; metadata maximum `2048`; failure class `atomic_fail_closed`; decision reference `TEST_ONLY_NOT_OWNER_DECISION`; decision date `2026-11-27`.

| Fixture | Logical input relative to the base | Expected result | Projection hex / digest evidence |
|---|---|---|---|
| `REGP1-01` | Base, same order, repeated independently | Same bytes, same digest, `match` | `PENDING_AUTHORIZED_GENERATION_AND_INDEPENDENT_CHECK` |
| `REGP1-02` | Outcomes `[rejected, accepted]` | Valid membership; different bytes/digest; `projection_bytes_mismatch` against base | `PENDING_AUTHORIZED_GENERATION_AND_INDEPENDENT_CHECK` |
| `REGP1-03` | Both metadata arrays empty | Present count-zero array frames; deterministic bytes/digest | `PENDING_AUTHORIZED_GENERATION_AND_INDEPENDENT_CHECK` |
| `REGP1-04A/B` | A uses producer `a.bc`, event `d`; B uses producer `a`, event `bc.d`; all else equal | Distinct length-framed bytes/digests; never delimiter-equivalent | `PENDING_AUTHORIZED_GENERATION_AND_INDEPENDENT_CHECK` |
| `REGP1-05A/B` | A has null `target_type` under forbidden mode; B supplies empty target text | A projects; B is `invalid_registration` before projection; null never equals empty | A pending; B has no bytes/digest |
| `REGP1-06` | Base UUID and integer fields | UUID is 16 bytes; version is `00 01`; metadata maximum is `00 00 08 00` | `PENDING_AUTHORIZED_GENERATION_AND_INDEPENDENT_CHECK` |
| `REGP1-07` | Duplicate one value in each array in three independent cases | `invalid_registration` before projection | No bytes/digest |
| `REGP1-08` | Format version `2` presented to a version-1-only verifier | `projection_version_mismatch`; fail closed | No version-1 re-encoding |
| `REGP1-09A/B` | Invalid UTF-8; uppercase/non-grammar machine identifier | `invalid_registration` before projection | No bytes/digest |
| `REGP1-10` | Valid base bytes with altered supplied digest | `digest_mismatch`; drift detected; no activation | Base bytes pending; altered digest fixture pending |
| `REGP1-11A-F` | Wrong fixed-width length; truncated frame; missing/duplicate/out-of-order tag; bytes after field 21 | `invalid_projection` under strict full-buffer consumption | No accepted bytes/digest |
| `REGP1-12A-C` | `u32` payload/count overflow attempt; truncated array element; unconsumed bytes inside array payload | `invalid_projection`; checked arithmetic; no count-based premature allocation | No accepted bytes/digest |
| `REGP1-13A-E` | Dates `1970-01-01`, `1969-12-31`, `0001-01-01`, `9999-12-31`, and one value outside the accepted civil range | Counts `0`, `-1`, `-719162`, `2932896`; outside value is `invalid_registration` | Valid vectors pending; invalid case has no bytes/digest |
| `REGP1-14A-D` | Identity mismatch with valid digests; reordered bytes with valid digests; malformed bytes plus bad digest; unsupported version plus malformed body | Precedence yields `registration_identity_mismatch`, `projection_bytes_mismatch`, `invalid_projection`, `projection_version_mismatch` respectively | `PENDING_AUTHORIZED_GENERATION_AND_INDEPENDENT_CHECK` |
| `REGP1-15A/B` | U+0000 in scalar `owner_decision_reference`; U+0000 in one array element | `invalid_registration` before projection in both cases; other valid Unicode scalars retain their exact UTF-8 bytes | No bytes/digest |

Expected hex and digests remain explicitly pending because this task authorizes no encoder, executable fixture generator or test. They may be filled only after the byte contract is independently reviewed, an implementation is separately authorized, and two independent reproductions agree. No pending fixture is evidence that a test passed or that a production registration exists.

Size/depth/string limits are security design parameters to be justified and tested during implementation design; this document does not approve arbitrary numbers. Metadata evolution requires a new event version when interpretation or required fields change.

### 10.2 Prohibited content

Metadata and safe failure logging must never contain:

- passwords or password verifier inputs;
- PINs;
- raw Session, recovery, invitation, CSRF, or bearer tokens;
- MFA secrets, seeds, recovery codes, or verification codes;
- raw payment credentials;
- authorization/cookie headers;
- unrestricted request or response bodies;
- database records or exception dumps; or
- personal data not necessary for the approved evidence purpose.

### 10.3 Failures, redaction, and correction

- Validation and storage errors use stable safe categories and opaque failure references. Rejected metadata must not be echoed to ordinary logs.
- Redaction at presentation/export time does not rewrite authoritative event rows.
- A factual correction, dispute, or later resolution requires a separately approved append event linked by causation/target evidence. No correction event is defined by this design.
- Retention, legal hold, export recipient, anonymization timing, and erasure conflict are outside this contract and remain qualified legal/privacy decisions.

## 11. Dependency architecture

```text
Producer Domain
      ↑
Producer Application use case
      ↓
Producer-owned audit port
      ↓
Composition adapter
   ├── trusted Identity actor evidence
   ├── trusted Organization scope evidence
   └── Audit Evidence Application append interface
                         ↓
                 Audit Infrastructure
```

- **Producer context:** owns event meaning, when it occurs, target semantics, outcome, safe metadata, and producer-specific port methods. Domain code does not import Audit.
- **Audit Evidence module:** owns the immutable envelope, catalog enforcement, provenance validation, replay semantics, persistence interface, and append-only implementation.
- **Identity:** owns authentication/session evidence. It does not write Audit persistence or expose Identity Infrastructure.
- **Organization:** owns Organization/Brand/Branch ancestry facts. It supplies a narrow Application result; Audit never queries Organization records.
- **Workforce:** owns Employee meaning. A future use case may produce an approved event through its own port, but no Employee write or event exists now.
- **Composition:** maps trusted cross-module evidence and wires adapters. It does not become a neutral business-rule coordinator.

Packwerk should eventually add explicit dependencies only where a real interface is used: producer Infrastructure/composition may depend on Audit Application contracts; producer Domain remains independent. Identity and Organization contracts are consumed through composition adapters rather than Audit depending on their Infrastructure. Exact package manifest edges and architecture guards belong to an authorized implementation design. Packwerk and custom source guards are static architecture controls: they can detect reviewed direct, absolute, aliased, chained and composition references, but they do not make a Ruby call technically impossible at runtime. The architecture rule is therefore **must not bypass Audit Application**; PostgreSQL role/function privileges remain the runtime enforcement boundary.

For Empty Slice 1, the exact module boundary is `backend/app/contexts/platform/audit_evidence/` with namespace `Platform::AuditEvidence`, inside the existing strict `backend/app/contexts/platform/package.yml` technical platform package. It is an independent deep platform module, not a new business Bounded Context and not a new Packwerk package. Its framework-independent Domain area owns Audit values/invariants; its Application area owns only the append contract, validation/orchestration and provisional result types; its Infrastructure area owns persistence records, mapper/repository, PostgreSQL adapter and transaction integration. Only the Application contract is a cross-module interface. Domain and Application do not depend on Rails, Active Record or PostgreSQL; Infrastructure depends inward.

The existing platform package retains no package dependencies. Empty Slice 1 adds no producer-context dependency edge, production composition wiring, controller, job, callback or runtime caller. Its Infrastructure persistence base is a module-local abstract `Platform::AuditEvidence::Infrastructure::Persistence::Record < ActiveRecord::Base`; it does not inherit root `ApplicationRecord` or establish/switch connections. That superclass alone does not guarantee atomicity. The outer wrapper must hold the primary-writing/default-shard lease, reject any pre-existing transaction, open the supported outer transaction itself and alone issue the capability from its yielded transaction object. Exact specification, pool/role/shard, adapter/raw connection, yielded/current transaction object/UUID, Thread/Fiber and attempt generation must match. Joined scopes reuse the outer capability; ambient transactions, nested issuers, real savepoints/restarted parents, context transfer/retry/reuse, another root/topology or any unprovable identity fail before Audit SQL with no receipt or fallback. The authoritative policy and future Rails 8.1.4.1 matrix are in [Security Design Closure — Rails connection policy](organization_level_audit_security_design_closure.md#authoritative-rails-connection-and-transaction-participation-policy).

Architecture guards must fail any direct reference to Audit Infrastructure/persistence/function adapters outside this module, any Rails/Active Record dependency in its Domain/Application areas, any root `ApplicationRecord` dependency or connection-switching API in Audit persistence, and any producer Domain dependency on Audit. A future separately authorized producer may add an explicit dependency from its Infrastructure/composition integration to `app/contexts/platform` and call only the Audit Application contract; that future edge is not part of Empty Slice 1. The existing `Platform::DatabaseReadiness` behavior remains unchanged.

Existing Orders/Payments/Preparation root `AuditEvent` access should be removed incrementally only after the new module exists and each event is Owner-approved for a target store. Characterization and transaction tests must remain. This task does not modify those writers or imply that Branch events move into the Organization store.

## 12. Staged unresolved Owner decisions

`AUD-DEC-01`–`06` are already Owner-confirmed and are not reopened. The following first-producer and later-feature questions do not block external review of the empty infrastructure:

1. Approve the initial concrete Organization-level event types, versions, producer ownership, targets, outcomes, metadata schemas, and finite-time policy: authoritative clock/source, acceptable past age and future skew, delayed-event and retry treatment.
2. Assign each approved event to a failure class; specifically decide which ordinary successful events fail closed and which denied/rejected/failed attempts merit separate durable evidence.
3. Approve the system-producer registry entries and accountability/provenance evidence for each producer. The registry mechanism proposed here is not yet approved.
4. Decide whether Session reference, effective role/capability, reason code, before/after summary, and source/device references are required for each event class.
5. Decide future reader, search, investigation, export, hold/release, correction/dispute, and break-glass capabilities. None are part of this append contract.
6. Decide which existing Branch event types, if any, are formally approved later; current runtime presence is insufficient.

No Employee creation authority, Employee event, Identity event, Organization administration event, or system identity is approved here.

## 13. Security, legal, privacy, and operational review requirements

Before any Slice 1 implementation authorization:

- Security review must validate the design and proposed tests for trusted evidence issuance, catalog denial, actor spoofing resistance, Organization isolation, static absence of every Branch representation, idempotency conflicts, concurrency, metadata limits, append failure monitoring, and database privileges.
- Catalog-array review must verify Application and PostgreSQL parity for duplicate outcomes, duplicate allowed keys, duplicate required keys, case-different values under the existing grammar, same members in different orders, SQL-NULL arrays/elements, permitted empty metadata-key arrays, prohibited empty outcomes, positional registration projection, definition-hash stability and release drift detection. These are future evidence requirements, not executed tests.
- Projection/hash review must verify every version-1 header and field byte, null-versus-empty distinction, UUID/integer/date/array framing, unsupported-version failure, SHA-256 reproduction and release comparison using the `REGP1-*` fixture schema. Expected hex/digests require two independent reproductions only after authorization; none is claimed here.
- PostgreSQL design must distinguish runtime writer, reader, migration/schema owner, and break-glass privileges and specify denial tests for database/schema/object/default/parameter privileges, mutation, trigger/function replacement and role assumption. Executed disposable evidence follows authorization and precedes implementation acceptance. Absolute immutability must not be claimed.
- The exact empty-slice migration/function/role/test scope requires separate Owner authorization after focused independent re-review. A first event, producer, event metadata/failure class, reader, export, retention policy or production data is not a prerequisite and must not be added.

Before a first production event or production deployment, event-specific legal/privacy review must define retention, employee visibility/access/correction, holds, anonymization/deletion conflicts, backups/restores, export boundaries and minimization as applicable. Operational evidence must cover integrity reconciliation, failed-append alerts, privilege/trigger drift, backup/restore discontinuity, incident investigation and producer/catalog deployment compatibility. The authoritative stage allocation is [Security Design Closure §8.8](organization_level_audit_security_design_closure.md#88-authoritative-prerequisite-matrix).

Canonical review records remain incomplete: [AF-SEC-008](../architecture/security-reviews/af-sec-008-audit-security.md), [AF-PRIV-004](../architecture/security-reviews/af-priv-004-audit-retention-legal-holds.md), and [AF-PRIV-005](../architecture/security-reviews/af-priv-005-exports-anonymization.md). ID-12 and ID-18 approve append-only/restricted audit policy but not concrete privileges, retention, or exports ([Identity Decision Register](../architecture/after_four_identity_decision_register.md#owner-decisions-confirmed)).

## 14. Recommended next bounded design step

Proceed to a **PostgreSQL design-only package** for the separate Organization-level store. It should:

1. map this logical envelope to candidate relational shapes without assuming every field is a column;
2. design constraints, Organization FK strategy, idempotency uniqueness, recorded-time authority, metadata validation division, indexes, and migration rollback;
3. design separate schema-owner, runtime-writer, and future-reader privileges plus trigger defense in depth;
4. specify concurrency, replay, rollback, truncate-denial, privilege, and malformed-row tests;
5. preserve the existing legacy Branch store unchanged, prove that the new Slice 1 has no Branch representation, and state that cross-store ordering is unavailable; and
6. leave all runtime event catalog entries disabled/unimplemented until their Owner approvals exist.

The current package contains the resulting design candidate. `ISR-AUD-031`–`042` remain at their recorded review/evidence stages. In particular, `ISR-AUD-036/041` require final narrow read-only verification of wrapper-owned participation and the pre-entry native-error versus in-function `AUE02` boundary; `ISR-AUD-039/040/042` retain their latest design-level verification; and all five still require later executable evidence. None is executable-accepted, and this status does not authorize implementation.

This next step is design only. It must not create a migration, role, package, event type, or production writer without separate authorization.

## 15. Explicit exclusions

This design does not:

- implement or modify a package, manifest, architecture guard, source file, test, migration, schema, database role, model, repository, port, composition root, controller, route, reader, search, export, or event writer;
- approve any concrete event type or failure-class assignment;
- alter existing Branch audit behavior, backfill rows, or claim cross-store ordering;
- add Employee creation or any Identity/Organization/Workforce business capability;
- decide retention, legal hold, redaction, correction, reader/export authority, or legal/privacy compliance;
- grant Gate, implementation, FOA, deployment, or Production Authorization; or
- represent application, database, security, or production verification.

## Final verdict

`EXTERNAL_INDEPENDENT_REVIEW_REQUIRED`

The logical contract and PostgreSQL design are now synchronized for Empty Slice 1. The remaining pre-authorization condition is independent review of the complete current design/finding register; first-event, reader, retention and legal/privacy decisions remain correctly staged later. No implementation authorization follows from this verdict.
