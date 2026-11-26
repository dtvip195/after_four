# AFTER FOUR — Organization-Level Audit Security Design Closure

**Closure date:** 2026-11-27

**Status:** `DESIGN_REMEDIATED_RE_REVIEW_REQUIRED — NO_IMPLEMENTATION_AUTHORIZATION`

**Review verdict:** `READY_FOR_NARROW_READ_ONLY_ADVERSARIAL_RE_REVIEW`

**External-review lifecycle:** `EXTERNAL_REVIEW_NOT_YET_PERFORMED`

This document consolidates the Organization-level Audit Foundation security design after the Owner confirmed local decisions `AUD-DEC-01` through `AUD-DEC-06`. Those identifiers are review references, not canonical ODB allocations. Nothing here creates a migration, schema object, role, grant, event, producer, reader, runtime capability, Gate approval, FOA, or Production Authorization.

The self-contained external mandate, snapshot requirements, reviewer qualifications/independence declaration, per-finding response template and remediation ledger are authoritative in [Decision Package §14](organization_level_audit_foundation_decision_package.md#14-external-independent-review-handoff-package). No external reviewer or report has yet been supplied.

> **Independent-review remediation — 2026-11-27.** `ISR-AUD-001`–`003` are remediated in design only: the Slice 1 schema/function/contract has no Branch representation; catalog arrays and outcome validation are NULL-safe and fail-closed; §6.4 now defines privilege installation/handoff and negative evidence; and §8.8 is the authoritative staged prerequisite matrix. The findings remain open pending focused independent re-review. No SQL or implementation was executed.

> **Security remediation round 2 — 2026-11-27.** The focused re-review verified `ISR-AUD-001` and `ISR-AUD-002`, found `ISR-AUD-003` only partially remediated, and added `ISR-AUD-004`–`006`. This revision makes the ASCII identifier grammar explicit, completes database/parameter privilege coverage, separates pre-authorization plans from post-authorization disposable evidence and pre-deployment operational evidence, and makes the Audit-owned immutable registration—not a producer request—the failure-class authority. These are design remediations pending independent follow-up review, not closed findings or implementation authority.

> **Security remediation round 3 — 2026-11-27.** The follow-up review verified `ISR-AUD-001`–`003`, found `ISR-AUD-004` partially remediated, verified `ISR-AUD-005/006`, and added `ISR-AUD-007`–`010`. This revision replaces delimiter-joined catalog checks with element-wise helpers, reserves project SQLSTATE `AUE01` for registration denial, separates transaction-local function dispositions from post-commit Application results, and requires finite occurrence time while leaving event-specific age/skew policy unresolved. These are design remediations pending another focused independent review.

> **Security remediation round 4 — 2026-11-27.** The Round 3 re-review verified most prior controls, found `ISR-AUD-007/009` partial, and added `ISR-AUD-011/012`. This revision makes helper replacement an atomic, write-quiesced drop/recreate/full-validation release and separates `PendingAppendReceipt` from `CommittedAppendResult` at the outermost transaction boundary. These design remediations remain open pending focused independent re-review and create no implementation authority.

> **ISR-AUD-013 remediation — 2026-11-27.** Catalog arrays reject exact duplicate elements in Application validation and PostgreSQL helpers. No layer trims, case-folds, normalizes, deduplicates, sorts or reorders. The immutable registration manifest fixes one stable ordered representation; projection, definition hashing and release comparison preserve and compare it positionally. The finding is design-remediated only and remains open pending focused independent review.

> **ISR-AUD-013 remediation round 2 — 2026-11-27.** The [logical contract §10.1.1–10.1.5](organization_level_audit_logical_contract_design.md#1011-authoritative-registration-projection-identity) now defines the canonical `after-four.audit-registration-projection` version-1 binary record, complete 21-field framing, scalar/array encoding, SHA-256 input/digest representation, Audit-owned projection authority and language-neutral fixture schema. No implementation mechanism, catalog row or producer is authorized; expected fixture bytes/digests remain pending independent review and later authorized generation.

> **Authorization-readiness consolidation — 2026-11-27.** Three internal parallel perspectives reviewed protocol determinism, PostgreSQL security and architecture/cross-document consistency and added `ISR-AUD-014`–`023`; re-review added `ISR-AUD-024`–`030`. This revision remediates those documentation findings. Internal review is not external independent assurance: every current `ISR-AUD-001`–`042` and `AUD-SEC-01`–`14` finding requires the review/disposition applicable to its current status before Owner implementation authorization may be considered.

> **P0 internal-review remediation — 2026-11-27.** Zero-cost internal adversarial review added `ISR-AUD-031`–`039`. The exact design now removes the replay row lock that required an ungranted mutation privilege; fixes deterministic C-collation identity and policy comparisons; distinguishes global, per-schema and object function privileges; enumerates the complete PostgreSQL 18 table-privilege surface; constrains the migrator role; fixes the Platform persistence-base and architecture-enforcement claims; defines structured SQLSTATE/transaction handling; and makes UTF-8 an installation and restore invariant. These are documentation-only design remediations requiring subsequent review and executable evidence. They do not close any finding, satisfy the external-review gate, or authorize implementation.

> **Final design clarification — 2026-11-27.** The focused adversarial re-review left `ISR-AUD-036` and `ISR-AUD-039` partially remediated. That revision introduced a Rails connection/transaction participation predicate and separate UTF-8 lifecycle requirements; the later five-finding remediation below supersedes its narrower identity and session wording. Both findings remain open for focused re-review and later authorized executable acceptance evidence; no test or database operation was performed.

> **ISR-AUD-036/039/040/041/042 design remediation — 2026-11-27.** The latest internal adversarial review kept `ISR-AUD-036` and `ISR-AUD-039` open and added `ISR-AUD-040`–`042`. This revision specifies an opaque, one-attempt transaction-participation capability; rejects real nested/savepoint append; checks the exact executing PostgreSQL session inside the append function; binds restore acceptance to target/source/invocation evidence; quarantines partial or unproven restores; and separates read-only monitoring from readiness/traffic enforcement. These are future implementation requirements, not executable evidence, external review, Owner decisions or implementation authorization.

> **Focused documentation remediation — 2026-11-27.** The outer owner must now acquire and hold the `with_connection` lease, prove the adapter has no active transaction, open the supported outer transaction itself, and issue the sole capability from the transaction object yielded by that newly opened boundary. Ambient transactions and nested issuers fail closed; joined scopes reuse the outer capability, while real savepoints remain prohibited. Restore acceptance now additionally requires a non-reusable attempt ID, unique invocation, target-generation fencing, exclusive attempt ownership, attempt-scoped evidence and an atomic one-way `QUARANTINED -> ACCEPTED` transition. `ISR-AUD-036/039/040/042` remain open for narrow read-only adversarial re-review and later authorized executable evidence.

> **Final micro-remediation — 2026-11-27.** `ISR-AUD-036` now uses **wrapper-owned transaction participation** exclusively: the designated outer wrapper verifies its selected adapter is idle, opens and owns the supported transaction, and issues the sole capability; joined inner services may reuse it, but arbitrary caller-owned or pre-existing ambient transactions remain unsupported. `ISR-AUD-041` now separates PostgreSQL parse/resolution/bind/decode/type-conversion failures that occur before function entry from the in-function exact-session `AUE02` guard. Both paths fail closed and unwind the whole transaction. These corrections remain pending final narrow read-only verification and executable evidence; they do not close either finding or authorize implementation.

## 1. Baseline and authority

| Item | Verified value |
|---|---|
| Repository branch | `development` |
| HEAD | `b49a8827be53797b30ea1d7cb47791e7c74e7231` |
| Upstream | `origin/development`, delta `0 / 0` when inspected |
| Existing work | Five untracked audit research documents at remediation start; preserved in place, not staged or committed |
| Canonical architecture | [ADR-0011](../architecture/adr/0011-project-wide-layered-ddd.md), [DDD Foundation](../architecture/after_four_ddd_foundation.md), [Business Domain Model](../architecture/after_four_business_domain_model.md) |
| Prior audit work | [Assessment](organization_level_audit_foundation_assessment.md), [logical contract](organization_level_audit_logical_contract_design.md), [PostgreSQL design](organization_level_audit_postgresql_design.md), [decision package](organization_level_audit_foundation_decision_package.md) |

### 1.1 Owner-confirmed design decisions

| ID | Owner-confirmed outcome on 2026-11-27 | Boundary retained |
|---|---|---|
| `AUD-DEC-01` | Slice 1 has an empty catalog and no production producer. | Test fixtures do not become approved events. |
| `AUD-DEC-02` | Use one narrow PostgreSQL `SECURITY DEFINER` append function, exact-signature `EXECUTE`, and no runtime table privileges. | Independent security review precedes implementation authorization. |
| `AUD-DEC-03` | Attempt identity is Organization + Producer + Stable Attempt Key. Type/version changes under the same identity conflict. | Event type/version remain immutable comparison facts. |
| `AUD-DEC-04` | Branch is forbidden in Slice 1. | Future Branch support requires a separate decision and design. |
| `AUD-DEC-05` | Slice 1 exposes only the human actor shape. System producer input is disabled. | System provenance requires a later decision and custody model. |
| `AUD-DEC-06` | Separate schema/table ownership, function ownership, migration, runtime append, reader, break-glass, and backup/restore duties. | Actual custodians, provisioning, rotation, and runbooks remain review evidence, not appointments made here. |

`AUD-DEC-07` through `AUD-DEC-11` remain required before any production event. `AUD-DEC-12` through `AUD-DEC-14` remain deferred to reader/export/retention and production-data governance. `AUD-REV-01` remains mandatory before Slice 1 implementation authorization.

### 1.2 Unapproved and deferred decisions

| ID | Decision still required | Current status / blocking point |
|---|---|---|
| `AUD-DEC-07` | Exact first producer/event type/version tuple | Unapproved; blocks first catalog row and production append. |
| `AUD-DEC-08` | Exact failure class for the first event | Unapproved; blocks first production append. |
| `AUD-DEC-09` | Exact human Session evidence requirement | Unapproved; blocks first production append. |
| `AUD-DEC-10` | Event-specific metadata schema, semantic types, and byte limit | Unapproved; blocks first catalog row and production append. |
| `AUD-DEC-11` | Accept Model A residual runtime trust or select a stronger trust model | Unapproved; blocks first production append, not empty infrastructure review. |
| `AUD-DEC-12` | Reader/search roles, scope, and capabilities | Deferred; no reader grant or feature in Slice 1. |
| `AUD-DEC-13` | Export approval, recipients, delivery, and custody | Deferred; no export capability in Slice 1. |
| `AUD-DEC-14` | Retention, legal hold/release, correction/dispute, anonymization/deletion, and backup expiry | Deferred for empty infrastructure; qualified input required before production data. |

## 2. Closed logical boundary

The Audit Evidence module is exactly `backend/app/contexts/platform/audit_evidence/`, namespace `Platform::AuditEvidence`, inside the existing strict Platform package. It is a deep technical platform module, not a new Bounded Context or Packwerk package. Domain owns framework-independent values/invariants; Application owns the append use case, validation contract, idempotency outcome and safe error mapping; Infrastructure owns persistence records, mapping, repository, PostgreSQL adapter and wrapper-owned transaction participation. Only the Application interface may cross the module seam. Domain/Application do not depend on Rails, Active Record or PostgreSQL. Empty Slice 1 adds no producer dependency, composition wiring, controller, job, callback or caller. Wrapper-owned participation supports only the transaction boundary that the designated outer wrapper opens after proving its selected adapter is idle. Joined inner services may reuse the outer-issued capability, but Infrastructure must reject a pre-existing ambient or arbitrary caller-owned transaction; supporting a caller-owned boundary would require a separately designed, reviewed and approved protocol.

Audit Infrastructure uses one module-local abstract persistence base, `Platform::AuditEvidence::Infrastructure::Persistence::Record`, inheriting directly from `ActiveRecord::Base`. It must not call `establish_connection`, declare `connects_to`, invoke `connected_to`/`connected_to_many`, define another connection specification, or depend on root `ApplicationRecord`. Subclassing `ActiveRecord::Base`, sharing a specification name, or resolving the same pool is necessary but not by itself proof of atomicity. Audit may join a business transaction only under the exact connection policy below.

Presentation and producer code **must not** call Audit Infrastructure, persistence records, the PostgreSQL adapter, or the database function directly. Ruby constants and Packwerk are static architecture controls, not runtime security boundaries and cannot make such a call technically impossible. Packwerk dependency checks plus custom source guards cover direct, absolute, aliased, chained and composition-root references that static analysis can detect; code review covers dynamic object flow. In Empty Slice 1, the authoritative runtime control is that `af_runtime` has no appender membership, exact function EXECUTE, relation access, owner-assumption path or configuration bypass. A later producer still carries the explicit Model A residual trust addressed by `AUD-DEC-11`.

```text
Producer Application
  -> producer-owned audit port
  -> composition with trusted Identity/Organization evidence
  -> Audit Application append use case
  -> Audit Infrastructure PostgreSQL adapter
  -> exact-signature SECURITY DEFINER function
  -> empty catalog + Organization audit event store
```

The transaction-participating interface is `append_within_owned_transaction(AppendRequest) -> PendingAppendReceipt`. The designated wrapper-owned outer transaction may expose `CommittedAppendResult` only after its commit is known successful; Audit cannot return that committed type while embedded in the open supported wrapper-owned transaction. This wording does not admit an arbitrary caller-owned or pre-existing transaction. Neither interface exposes an Active Record object, database handle, table, reader, exporter, or runtime catalog-registration operation.

### Authoritative Rails connection and transaction participation policy

The Application service that opens the supported outer business transaction is the **outer transaction owner**. It must obtain and continuously hold one `with_connection` lease for the entire business/Audit transaction. Before opening the transaction, the wrapper must prove on that selected adapter that no transaction is active: the owning root has no open current transaction, the adapter reports no open transaction, and the raw PostgreSQL connection is not already `INTRANS` or `INERROR`. A missing, contradictory or unobservable predicate fails closed. A transaction that existed before entry to this wrapper is an unsupported ambient transaction; the wrapper must not join it, infer ownership from it or issue a capability inside it.

Only after that precondition passes may the wrapper open the outer transaction itself. Capability issuance is permitted exactly once, only by this outer wrapper, and only from the transaction object yielded by that newly opened outer transaction after it is also observed as the owning root's exact current transaction. The wrapper supplies the already checked-out adapter and private `TransactionParticipationCapability` directly to Audit Infrastructure. A joined inner service reuses that existing capability; it must not issue, replace or wrap a second capability. Any nested issuer fails closed before Audit SQL. Audit must not call `connection`, `lease_connection`, `with_connection`, `connection_pool.checkout`, `connected_to`, `connected_to_many` or another connection-establishment/switching API. Producers receive neither the capability nor any Rails/database object.

The capability is an opaque, non-serializable, non-copyable object whose authority derives from object identity and its issuing lexical scope, not from producer-supplied fields. It records references/values captured after the outer transaction is open:

1. **Connection specification identity:** exact `connection_specification_name` of the owning business root and the Audit persistence root. Equal text is necessary but insufficient.
2. **Role/shard-specific pool identity:** exact `ConnectionPool` object plus captured `current_role` and `current_shard`; the only supported values are writing/default.
3. **Checked-out connection identity:** exact supplied adapter object and exact underlying `PG::Connection` object. Capturing the raw connection may materialize Rails' lazy transaction; that materialization occurs before capability issuance.
4. **Outer transaction identity:** exact public `ActiveRecord::Transaction` object returned by the owning root's `current_transaction`, together with that object's non-null `uuid`. The UUID is generated by the Rails wrapper, not by PostgreSQL; `transaction_open?`, open-transaction count or a UUID without the same transaction object is insufficient.
5. **Issuing execution-context identity:** exact `Thread.current` and `Fiber.current` object identities. Cross-thread or cross-fiber use is unsupported even if an Active Support isolated-execution state happens to be propagated.
6. **Whole-transaction attempt identity:** a fresh, unguessable in-memory generation object owned only by the wrapper for this outer transaction invocation. It is never derived from a business idempotency key and is never reused by whole-transaction retry.

The wrapper marks the capability active only while its held lease, supplied adapter, newly opened outer transaction and lexical block are active. It invalidates the capability in `ensure` after the owning transaction invocation returns or raises, and immediately on rollback, retry replacement, connection release/check-in, reconnect/raw replacement, execution-context change, connection failure or unknown commit. Every whole-transaction retry repeats the no-active-transaction precondition, opens a new Rails transaction and creates a new generation/capability; the prior capability remains invalid. No marshal/dump representation, public constructor, equality-by-value or producer-facing accessor is permitted.

Rails 8.1.4.1 publicly exposes inherited `connection_specification_name`, role/shard-resolved `connection_pool`, `current_role`, `current_shard`, the checked-out adapter/raw connection, and `current_transaction.open?`/`uuid`. It does not expose a supported public parent-chain API proving that a savepoint transaction descends from a particular outer transaction. Therefore this design does **not** traverse Rails' private transaction stack and makes the following bounded choice:

- the wrapper's pre-entry no-active-transaction proof and its transaction block's yielded object establish the supported outer-ownership construction; merely observing `transaction_open?`, an open-transaction count, `PG::PQTRANS_INTRANS`, or a `current_transaction` UUID after entry does not establish who opened the transaction;
- an ordinary joined `transaction` scope is supported only when the owning root still returns the exact same public transaction object and UUID captured by the capability;
- any `requires_new` scope, real savepoint, restarted-parent transaction, or other current transaction object/UUID is unsupported and fails closed before Audit SQL; and
- completion or rollback of an inner Ruby block is never outer commit evidence. A joined block provides no independent rollback boundary; callers must not describe it as one.

Immediately before invoking the append function, the future Audit adapter must validate in this order without leasing or switching a connection:

1. the supplied object is the sole authentic, active, unexpired capability issued by the outer wrapper from its newly opened transaction's yielded object; no ambient or nested issuer participated;
2. `Thread.current` and `Fiber.current` are the captured objects and the attempt-generation object is the captured generation;
3. current role/shard remain writing/default and both roots still resolve the captured specification name and exact pool object;
4. that pool's public, non-leasing `active_connection?` result is the supplied/captured adapter, and the owning root's active `current_transaction` is the captured transaction object with the captured non-null UUID and `open? = true`;
5. the supplied adapter exposes the captured raw `PG::Connection` without replacement/reconnection, `adapter.transaction_open?` is true, and `PG::Connection#transaction_status` is `PG::PQTRANS_INTRANS`; none of those observations is sufficient alone;
6. the wrapper still owns and holds the original lease, no real nested/savepoint or restarted/replaced-parent transaction is current, and no second capability has been issued; and
7. only then may the adapter invoke the exact append function on that same connection.

A context-construction exception, missing public observation, checked-in connection, reconnection/raw replacement, role/shard or pool switch, closed/replaced transaction, stale/retried capability, unsupported nested transaction, execution-context transfer or validation exception is `audit_transaction_context_mismatch`. It fails before Audit SQL, returns no receipt/result, performs no fallback lookup or transaction, and forces the owning transaction to unwind according to its registered failure class. The validation path itself must not rescue and continue inside an aborted transaction.

Rails 8.1.4.1 public APIs expose the observations required by this proposed lexical outer/joined policy under the stated topology, but the package has not executed the acceptance matrix. `ActiveRecord::Transaction#uuid` identifies a Rails transaction wrapper only; it neither proves PostgreSQL transaction identity nor proves outer ownership. Likewise, `transaction_open?` and `PG::PQTRANS_INTRANS` describe state, not the issuer or owner. Rails does not expose a supported public parent-lineage API for arbitrary savepoints or establish safe capability transfer. If future workflows need caller-owned outer transactions, Audit append inside real nested/savepoint scopes, or a boundary that cannot maintain one lexical supplied-adapter lease, they require a separately specified and reviewed protocol or outbox/distributed design—not silent ambient joining, Rails private parent traversal or weakened atomicity.

Future multi-database, replica or sharding configuration is unsupported until a reviewed change proves all six identities for every allowed path. Adding a specification, connection root or `connects_to` declaration triggers architecture review and executable re-acceptance.

Transaction ownership remains with the service that opened the outermost supported transaction. Audit never commits it and returns only `PendingAppendReceipt`. Only the owner may construct `CommittedAppendResult` after known successful outer commit; rollback, mismatch, connection loss or unknown commit produces no committed result.

#### Rails 8.1.4.1 capability validation matrix

| Scenario | Required observation | Required result |
|---|---|---|
| Normal outer transaction | Wrapper held lease; no active transaction before entry; wrapper opened boundary; yielded/current transaction and all six captured identities match | Append may execute on supplied adapter; receipt remains pending |
| Ambient/pre-existing transaction | Any transaction was active before the wrapper attempted to open its boundary | Fail before capability issuance and before Audit SQL; no implicit join |
| Joined transaction | `current_transaction` object and UUID remain exactly the captured outer values | Same as outer; inner block completion is not commit |
| Joined inner issuer attempt | Inner service attempts to construct or replace a capability | Fail before Audit SQL; reuse the outer-issued capability only |
| `requires_new` / real savepoint | Current transaction object or UUID differs | Fail before Audit SQL; no receipt |
| `SavepointTransaction` / `RestartParentTransaction` | A real nested wrapper or restarted/replaced parent is current | Fail before Audit SQL; no receipt and no fallback |
| Nested rollback | Real nested append is unsupported; joined block has no independent database rollback proof | Fail real nested append; never promote from inner outcome |
| Outer commit | Owner observes known successful return after capability is no longer usable | Owner alone may create committed result |
| Outer rollback / unknown commit | Capability invalidated; transaction closed or outcome unknown | No committed result; Audit row rolls back with business write where outcome is known |
| Whole-transaction retry | New Rails transaction, UUID and attempt-generation object | New capability mandatory; prior capability rejected |
| Stale-context reuse | Capability inactive/expired or transaction object closed/replaced | Fail before Audit SQL |
| Cross-thread/fiber transfer | Thread or Fiber object differs | Fail before Audit SQL even if other configuration matches |
| Check-in/recheckout | Active transaction/adapter/raw identity absent or changed | Fail before Audit SQL |
| Reconnection/raw replacement | Raw `PG::Connection` identity differs or original transaction is no longer open | Fail before Audit SQL |
| Role/shard switch | Role, shard or pool differs | Fail before Audit SQL |
| Construction failure | Any identity cannot be captured after transaction opens | No capability and no Audit call |
| Validation failure | Any ordered predicate raises or is not exactly true | Unwind outer transaction; no fallback or success receipt |

The future acceptance suite must reproduce every row, verify that no private Rails transaction-stack API is used, and prove atomic business/Audit commit and rollback from a separate observing connection. These are requirements, not current evidence. `ISR-AUD-036` and `ISR-AUD-040` remain open until focused re-review and authorized executable acceptance against Rails 8.1.4.1 and the exact application topology.

### 2.1 Slice 1 append request

| Field | Slice 1 rule |
|---|---|
| `event_id` | Required canonical UUID assigned by Audit Application; excluded from replay equality. |
| `organization_id` | Required trusted scope evidence; FK confirms existence but not Identity issuance. |
| `registration_id` | Required internal UUID selected by Audit Application from an immutable approved registration; not accepted from the producer contract. |
| `producer_key` | Required reviewed producer identity; no production producer exists in Slice 1. |
| `stable_attempt_key` | Required, nonblank, stable across retries. |
| `event_type`, `event_version` | Required catalog tuple; empty catalog denies every tuple. |
| `occurred_at` | Required finite authoritative server-side producer time; exact replay-comparison fact. Empty Slice 1 imposes no arbitrary finite range; every future producer requires an approved age/skew/source policy. |
| `actor_user_id` | Required trusted human User reference. |
| `actor_session_id` | Catalog-governed forbidden/optional/required human-session reference. |
| `target_type`, `target_id` | Catalog-governed pair. |
| `correlation_id`, `causation_id` | Catalog-governed; never authorization evidence. |
| `outcome` | Required member of the catalog allowlist. |
| `metadata` | Required JSON object; exact keys, scalar shape, and byte maximum are catalog/application governed. |
| Branch/system/failure-class inputs | Not present in the producer contract. Branch and system inputs are absent from the function; failure class is resolved from the Audit-owned registration. |

## 3. Idempotency and replay reconciliation

### 3.1 Identity and equality

The single uniqueness identity is:

```text
(organization_id, producer_key, stable_attempt_key)
```

Every collatable machine identity and policy value is stored and compared with deterministic PostgreSQL `COLLATE "C"` semantics. This includes scalar `producer_key`, `event_type`, `target_type`, `outcome`, `failure_class` and `idempotency_key`, the three catalog arrays, their primary/unique constraints and indexes, catalog lookup, array membership/subset/duplicate checks, replay predicates and release comparisons. A column/index may not inherit the database-default collation. Application equality compares the validated UTF-8 byte sequence exactly: no locale comparison, case folding, punctuation elision, trimming or Unicode normalization. Registration projection already encodes exact UTF-8 bytes and remains the cross-language authority. UUID and numeric fields retain type equality rather than textual collation.

The equality comparison after an identity collision includes:

- registration identity;
- event type and version;
- occurred-at instant;
- human actor User and optional Session;
- correlation and causation identifiers;
- target type and identifier;
- outcome; and
- canonical PostgreSQL JSONB metadata equality.

`event_id` and database-assigned `recorded_at` are excluded. A retry may propose a different generated event UUID; a matching replay returns the original ID and timestamp. Any changed comparison fact—including type or version—is a conflict and never creates a second row.

### 3.2 Outcomes

| Condition | Result | Write |
|---|---|---|
| No existing identity; all validation passes | Function returns provisional `inserted_in_current_transaction` with new ID/time | One row visible in the current transaction; not durable until the owning outer transaction commits |
| Existing identity; all comparison facts match | Function returns provisional `matched_existing_in_current_snapshot` with original ID/time | None; Application may call it `idempotent_replay` only after the owning outer transaction commits |
| Existing identity; any comparison fact differs | Safe `conflicting_replay` error | None; original remains |
| Missing/unapproved catalog or invalid envelope | Safe validation/authorization error | None |
| Serialization/deadlock/storage failure | Infrastructure error; caller retries whole transaction only under approved retry policy | No success inference |

The replay read is an ordinary `SELECT`; it has no `FOR UPDATE`, `FOR NO KEY UPDATE`, `FOR SHARE` or `FOR KEY SHARE` clause and therefore requires no `UPDATE` privilege. A row lock is unnecessary because event rows are append-only: after `INSERT ... ON CONFLICT DO NOTHING`, the named unique constraint has already resolved the competing insertion before the next PL/pgSQL statement. Under PostgreSQL `READ COMMITTED`, the losing insert waits for the winner; the following statement receives a new command snapshot and reads the committed immutable original. Two identical requests therefore yield one insert and one matching replay; two conflicting requests yield one insert and one conflict. If the winner rolls back, the loser may insert and becomes the sole row. Under `REPEATABLE READ` or `SERIALIZABLE`, PostgreSQL may return `40001`; `40P01` may also occur. The adapter must unwind and, only under an approved bounded policy, retry the entire owning transaction with the same identity. Neither state may be converted into replay success.

### 3.3 Key custody and lifecycle

- The producing Application derives the Stable Attempt Key from an already stable command/attempt identity. It must not accept an arbitrary client key as authority or generate a new random key on retry.
- The key is opaque, bounded, non-secret, and contains no personal/business values. Logs may record a one-way diagnostic fingerprint only under an approved logging rule; the raw key is not an authorization token.
- The Organization dimension prevents the same key in two Organizations from colliding. The producer dimension prevents two approved producer contracts from sharing an identity accidentally.
- `producer_key` is a stable logical producer identity, not a deployment version. Deployment/version changes preserve it. A semantic ownership change requires a new producer identity and cannot replay an old producer's attempt.
- A retired/revoked producer remains represented in immutable catalog/history. Revocation prevents new Application issuance; it does not rewrite evidence. Whether a retired producer may perform lookup-only replay requires the future producer lifecycle decision and is irrelevant while Slice 1 has no producer.
- An event-version change under the same attempt key conflicts. The producer must finish or reconcile the original attempt; it cannot version-bump around a conflict.
- A conflict response returns no stored semantic fields and no alternative success. Resolution is operational investigation, not an automatic new key or second append.

### 3.4 Transaction-local versus committed results

The PostgreSQL function reports only what is visible inside the current database transaction:

- `inserted_in_current_transaction` means the row was inserted in the current transaction. It is not yet a durable or externally successful append.
- `matched_existing_in_current_snapshot` means the identity and immutable facts match a row visible to the current statement. The row may have committed earlier or may have been inserted earlier in the same still-open transaction; the function does not claim which.

`PendingAppendReceipt` is the only result an embedded Audit append may return while an outer transaction is open. It carries Organization + Producer + Stable Attempt Key, registration/type/version identity, event ID, database-assigned `recorded_at`, and one provisional disposition. It is internal transaction-coordination evidence, not proof of durability and not an externally publishable success.

`CommittedAppendResult` carries the same stable event identity and exactly one final disposition, `appended` or `idempotent_replay`. Only the service that owns the **outermost transaction that owns the append** may construct it, and only after that service positively knows its commit completed. A Rails transaction block may join an existing outer transaction, but return from that joined block does not prove outer commit. Audit append in a `requires_new` savepoint is unsupported; even outside Audit, savepoint release is not outer-commit evidence. Function success, callback registration, or an inner callback therefore cannot produce `CommittedAppendResult`.

The transaction owner has these logical obligations, without selecting a Rails or persistence mechanism:

1. If another service owns the outermost transaction, Audit returns `PendingAppendReceipt`; the Audit method cannot synchronously claim committed success.
2. If an authorized Audit use case owns the outermost transaction, it may return `CommittedAppendResult` only after the transaction boundary itself has completed successfully. If synchronous commit knowledge is unavailable, the safe result is pending/reconciliation-required.
3. An ordinary joined scope may reuse only the outer-issued capability and produces a receipt owned by that outer transaction; joined-scope return or rollback intent is not an independent database outcome. A real savepoint, `requires_new`, `SavepointTransaction`, `RestartParentTransaction`, nested issuer or replaced parent fails before any Audit SQL, so no savepoint-local receipt exists to discard or promote. Known outer rollback discards every receipt issued by the supported outer transaction and produces no committed result.
4. Connection loss around commit produces commit-outcome-unknown. Process termination after commit but before publication also leaves publication unresolved. Neither permits inferred success.
5. Reconciliation or retry always uses the same Organization + Producer + Stable Attempt Key. It resolves to a new transaction-local insert, a matching event, or conflict; it never generates a replacement key.
6. HTTP success, downstream messages, notifications and every other external success effect occur only after commit is known. An `after_commit` callback is not proof that the original synchronous caller can return success; callback timing/failure and reliable publication require a later authorized implementation contract.

No outbox, callback, transaction record or unit-of-work implementation is selected here. The logical requirement is one finalization after known outer commit, no finalization after rollback, and safe reconciliation whenever durability or publication is uncertain.

## 4. Complete `SECURITY DEFINER` append specification

This is the complete review candidate for Slice 1. It is documentation, not an executable migration. The final migration must preserve the exact reviewed signature and behavior or return for review.

### 4.1 Signature and full body

```sql
CREATE FUNCTION public.audit_evidence_append_organization_event(
  p_event_id uuid,
  p_organization_id uuid,
  p_registration_id uuid,
  p_registration_failure_class varchar,
  p_producer_key varchar,
  p_stable_attempt_key varchar,
  p_event_type varchar,
  p_event_version smallint,
  p_occurred_at timestamptz,
  p_actor_user_id uuid,
  p_actor_session_id uuid,
  p_correlation_id uuid,
  p_causation_id uuid,
  p_target_type varchar,
  p_target_id uuid,
  p_outcome varchar,
  p_metadata jsonb
)
RETURNS TABLE(event_id uuid, recorded_at timestamptz, disposition varchar)
LANGUAGE plpgsql
SECURITY DEFINER
VOLATILE
PARALLEL UNSAFE
SET search_path TO pg_catalog, pg_temp
AS $function$
DECLARE
  v_catalog public.organization_audit_event_catalog%ROWTYPE;
  v_existing public.organization_audit_events%ROWTYPE;
  v_inserted_id uuid;
  v_inserted_recorded_at timestamptz;
  v_metadata_keys text[];
BEGIN
  IF pg_catalog.current_setting('server_encoding') COLLATE "C"
       IS DISTINCT FROM 'UTF8' COLLATE "C"
     OR pg_catalog.current_setting('client_encoding') COLLATE "C"
       IS DISTINCT FROM 'UTF8' COLLATE "C" THEN
    RAISE EXCEPTION USING
      ERRCODE = 'AUE02',
      MESSAGE = 'organization audit encoding invariant failed';
  END IF;

  IF p_event_id IS NULL
     OR p_organization_id IS NULL
     OR p_registration_id IS NULL
     OR p_registration_failure_class IS NULL OR char_length(p_registration_failure_class) > 40
     OR p_registration_failure_class COLLATE "C" !~ '^[a-z][a-z0-9]*(?:[._-][a-z0-9]+)*$'
     OR p_producer_key IS NULL OR char_length(p_producer_key) > 100
     OR p_producer_key COLLATE "C" !~ '^[a-z][a-z0-9]*(?:[._-][a-z0-9]+)*$'
     OR p_stable_attempt_key IS NULL OR char_length(p_stable_attempt_key) > 255
     OR p_stable_attempt_key COLLATE "C" !~ '^[A-Za-z0-9][A-Za-z0-9._:/-]*$'
     OR p_event_type IS NULL OR char_length(p_event_type) > 160
     OR p_event_type COLLATE "C" !~ '^[a-z][a-z0-9]*(?:[._-][a-z0-9]+)*$'
     OR p_event_version IS NULL OR p_event_version <= 0
     OR p_occurred_at IS NULL OR NOT isfinite(p_occurred_at)
     OR p_actor_user_id IS NULL
     OR p_outcome IS NULL OR char_length(p_outcome) > 24
     OR p_outcome COLLATE "C" !~ '^[a-z][a-z0-9]*(?:[._-][a-z0-9]+)*$'
     OR p_metadata IS NULL THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = 'invalid organization audit append request';
  END IF;

  SELECT c.*
    INTO v_catalog
    FROM public.organization_audit_event_catalog AS c
   WHERE c.registration_id = p_registration_id
     AND c.failure_class = p_registration_failure_class COLLATE "C"
     AND c.producer_key = p_producer_key COLLATE "C"
     AND c.event_type = p_event_type COLLATE "C"
     AND c.event_version = p_event_version;

  IF NOT FOUND THEN
    RAISE EXCEPTION USING
      ERRCODE = 'AUE01',
      MESSAGE = 'organization audit event is not approved';
  END IF;

  IF public.audit_evidence_outcomes_well_formed(
       v_catalog.allowed_outcomes::text[]
     ) IS DISTINCT FROM TRUE
     OR public.audit_evidence_metadata_keys_well_formed(
       v_catalog.allowed_metadata_keys::text[]
     ) IS DISTINCT FROM TRUE
     OR public.audit_evidence_metadata_keys_well_formed(
       v_catalog.required_metadata_keys::text[]
     ) IS DISTINCT FROM TRUE
     OR NOT (
       v_catalog.required_metadata_keys::text[] COLLATE "C"
         <@ v_catalog.allowed_metadata_keys::text[] COLLATE "C"
     ) THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = 'invalid organization audit catalog projection';
  END IF;

  IF v_catalog.actor_type COLLATE "C" <> 'human' COLLATE "C"
     OR v_catalog.system_invocation_mode COLLATE "C" <> 'forbidden' COLLATE "C"
     OR v_catalog.idempotency_mode COLLATE "C" <> 'required' COLLATE "C"
     OR v_catalog.system_producer_key IS NOT NULL
     OR v_catalog.system_producer_version IS NOT NULL THEN
    RAISE EXCEPTION USING
      ERRCODE = 'AUE01',
      MESSAGE = 'organization audit catalog entry is outside slice 1';
  END IF;

  IF (v_catalog.session_reference_mode COLLATE "C" = 'forbidden' COLLATE "C" AND p_actor_session_id IS NOT NULL)
     OR (v_catalog.session_reference_mode COLLATE "C" = 'required' COLLATE "C" AND p_actor_session_id IS NULL) THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = 'invalid organization audit session reference';
  END IF;

  IF (v_catalog.target_reference_mode COLLATE "C" = 'forbidden' COLLATE "C"
        AND (p_target_type IS NOT NULL OR p_target_id IS NOT NULL))
     OR (v_catalog.target_reference_mode COLLATE "C" = 'required' COLLATE "C"
        AND (p_target_type IS NULL OR p_target_id IS NULL))
     OR (v_catalog.target_reference_mode COLLATE "C" = 'optional' COLLATE "C"
        AND ((p_target_type IS NULL) <> (p_target_id IS NULL)))
     OR (p_target_type IS NOT NULL
        AND (char_length(p_target_type) > 120
          OR p_target_type COLLATE "C" !~ '^[a-z][a-z0-9]*(?:[._-][a-z0-9]+)*$'
          OR p_target_type COLLATE "C"
               IS DISTINCT FROM v_catalog.target_type COLLATE "C")) THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = 'invalid organization audit target reference';
  END IF;

  IF (v_catalog.correlation_mode COLLATE "C" = 'forbidden' COLLATE "C" AND p_correlation_id IS NOT NULL)
     OR (v_catalog.correlation_mode COLLATE "C" = 'required' COLLATE "C" AND p_correlation_id IS NULL)
     OR (v_catalog.causation_mode COLLATE "C" = 'forbidden' COLLATE "C" AND p_causation_id IS NOT NULL)
     OR (v_catalog.causation_mode COLLATE "C" = 'required' COLLATE "C" AND p_causation_id IS NULL) THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = 'invalid organization audit trace reference';
  END IF;

  IF (p_outcome COLLATE "C"
        = ANY (v_catalog.allowed_outcomes COLLATE "C")) IS DISTINCT FROM TRUE THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = 'invalid organization audit outcome';
  END IF;

  IF jsonb_typeof(p_metadata) COLLATE "C" <> 'object' COLLATE "C"
     OR pg_column_size(p_metadata) > v_catalog.metadata_max_bytes THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = 'invalid organization audit metadata';
  END IF;

  SELECT COALESCE(array_agg(k ORDER BY k COLLATE "C"), ARRAY[]::text[])
    INTO v_metadata_keys
    FROM jsonb_object_keys(p_metadata) AS keys(k);

  IF NOT (v_metadata_keys COLLATE "C"
            <@ v_catalog.allowed_metadata_keys::text[] COLLATE "C")
     OR NOT (v_catalog.required_metadata_keys::text[] COLLATE "C"
               <@ v_metadata_keys COLLATE "C")
     OR EXISTS (
       SELECT 1
         FROM jsonb_each(p_metadata) AS entry(k, value)
        WHERE jsonb_typeof(entry.value) COLLATE "C"
                NOT IN ('string' COLLATE "C", 'number' COLLATE "C", 'boolean' COLLATE "C")
     ) THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = 'invalid organization audit metadata';
  END IF;

  INSERT INTO public.organization_audit_events (
    id, organization_id, registration_id,
    producer_key, event_type, event_version,
    occurred_at,
    actor_type, actor_user_id, actor_session_id,
    system_producer_key, system_producer_version, system_invocation_id,
    correlation_id, causation_id,
    target_type, target_id,
    outcome, idempotency_key, metadata
  ) VALUES (
    p_event_id, p_organization_id, p_registration_id,
    p_producer_key, p_event_type, p_event_version,
    p_occurred_at,
    'human', p_actor_user_id, p_actor_session_id,
    NULL, NULL, NULL,
    p_correlation_id, p_causation_id,
    p_target_type, p_target_id,
    p_outcome, p_stable_attempt_key, p_metadata
  )
  ON CONFLICT ON CONSTRAINT organization_audit_events_attempt_identity_unique
  DO NOTHING
  RETURNING id, organization_audit_events.recorded_at
       INTO v_inserted_id, v_inserted_recorded_at;

  IF v_inserted_id IS NOT NULL THEN
    RETURN QUERY
      SELECT v_inserted_id, v_inserted_recorded_at,
             'inserted_in_current_transaction'::varchar;
    RETURN;
  END IF;

  SELECT e.*
    INTO STRICT v_existing
    FROM public.organization_audit_events AS e
   WHERE e.organization_id = p_organization_id
     AND e.producer_key = p_producer_key COLLATE "C"
     AND e.idempotency_key = p_stable_attempt_key COLLATE "C";

  IF v_existing.event_type COLLATE "C"
       IS NOT DISTINCT FROM p_event_type COLLATE "C"
     AND v_existing.registration_id IS NOT DISTINCT FROM p_registration_id
     AND v_existing.event_version IS NOT DISTINCT FROM p_event_version
     AND v_existing.occurred_at IS NOT DISTINCT FROM p_occurred_at
     AND v_existing.actor_type COLLATE "C" = 'human' COLLATE "C"
     AND v_existing.actor_user_id IS NOT DISTINCT FROM p_actor_user_id
     AND v_existing.actor_session_id IS NOT DISTINCT FROM p_actor_session_id
     AND v_existing.system_producer_key IS NULL
     AND v_existing.system_producer_version IS NULL
     AND v_existing.system_invocation_id IS NULL
     AND v_existing.correlation_id IS NOT DISTINCT FROM p_correlation_id
     AND v_existing.causation_id IS NOT DISTINCT FROM p_causation_id
     AND v_existing.target_type COLLATE "C"
           IS NOT DISTINCT FROM p_target_type COLLATE "C"
     AND v_existing.target_id IS NOT DISTINCT FROM p_target_id
     AND v_existing.outcome COLLATE "C"
           IS NOT DISTINCT FROM p_outcome COLLATE "C"
     AND v_existing.metadata IS NOT DISTINCT FROM p_metadata THEN
    RETURN QUERY
      SELECT v_existing.id, v_existing.recorded_at,
             'matched_existing_in_current_snapshot'::varchar;
    RETURN;
  END IF;

  RAISE EXCEPTION USING
    ERRCODE = '23505',
    MESSAGE = 'organization audit replay conflict',
    CONSTRAINT = 'organization_audit_events_attempt_identity_unique';
END;
$function$;

ALTER FUNCTION public.audit_evidence_append_organization_event(
  uuid, uuid, uuid, varchar, varchar, varchar, varchar, smallint, timestamptz,
  uuid, uuid, uuid, uuid, varchar, uuid, varchar, jsonb
) OWNER TO af_audit_function_owner;

REVOKE ALL ON FUNCTION public.audit_evidence_append_organization_event(
  uuid, uuid, uuid, varchar, varchar, varchar, varchar, smallint, timestamptz,
  uuid, uuid, uuid, uuid, varchar, uuid, varchar, jsonb
) FROM PUBLIC;

GRANT EXECUTE ON FUNCTION public.audit_evidence_append_organization_event(
  uuid, uuid, uuid, varchar, varchar, varchar, varchar, smallint, timestamptz,
  uuid, uuid, uuid, uuid, varchar, uuid, varchar, jsonb
) TO af_audit_appender;

GRANT SELECT ON public.organization_audit_event_catalog
  TO af_audit_function_owner;
GRANT SELECT, INSERT ON public.organization_audit_events
  TO af_audit_function_owner;
```

### 4.2 Required surrounding DDL and ACL properties

- `organization_audit_events.idempotency_key` is `NOT NULL`, nonblank, and protected by named unique constraint `organization_audit_events_attempt_identity_unique (organization_id, producer_key, idempotency_key)`.
- A composite foreign key binds `(registration_id, producer_key, event_type, event_version)` to one immutable catalog row; separate independent FKs are insufficient because they could accept a registration UUID and tuple from different rows.
- Slice 1 catalog and event constraints require `actor_type = 'human'`, null system provenance, and `system_invocation_mode = 'forbidden'`. Slice 1 has no Branch column, foreign key, target, catalog mode, function input, insert field, replay comparison, index, fixture, or indirect Branch identity.
- The Slice 1 function contains no Branch, actor-type, or system-producer parameter and always writes system columns as null and actor type as `human`.
- `recorded_at` remains database-assigned with `clock_timestamp()`; callers cannot supply it.
- Both event timestamps are finite. The function rejects non-finite `occurred_at`; relation checks reject non-finite `occurred_at` or `recorded_at`. Empty Slice 1 accepts ordinary and extreme finite values structurally because no event-specific age/skew policy is approved. A future producer must apply its approved temporal policy in Audit Application before this adapter is called.
- PostgreSQL `server_encoding` must be exactly `UTF8` at every acceptance boundary defined in the lifecycle matrix below. Rails/PostgreSQL `client_encoding` must also resolve to `UTF8` for an accepted application connection. Server and client encoding are separate facts: a UTF-8 client cannot make a non-UTF-8 database acceptable, and a UTF-8 database does not excuse a mismatched client. Application encoder/decoder fixtures must round-trip non-ASCII UTF-8 values exactly and reject malformed byte sequences and U+0000 before binding.
- Every collatable identity/policy column and array uses explicit deterministic `COLLATE "C"`; its primary/unique/index collation OIDs and every policy equality/membership/subset comparison are acceptance evidence. Database-default locale or nondeterministic ICU collation is never an identity authority.
- The function is `VOLATILE` because it reads mutable transaction-visible catalog/event state, inserts a row, observes uniqueness races, and returns database-assigned time. `STABLE` or `IMMUTABLE` would be false.
- The catalog is migration-managed and empty. It contains no runtime mutation interface.
- All application relations are schema-qualified; no dynamic SQL is used. `search_path` contains only `pg_catalog, pg_temp`.
- `pg_catalog` precedes explicit `pg_temp`; temporary relations cannot replace the schema-qualified application relations, and exact typed operands resolve built-in operators/functions from the fixed catalog path. Dedicated tests must still attempt temp-object, overload, and cast shadowing.
- Global default privileges, per-schema default privileges and object ACLs are three separate controls. For each function-creating role, the provisioning transaction must establish the **global** owner-specific default `ALTER DEFAULT PRIVILEGES FOR ROLE <owner> REVOKE EXECUTE ON FUNCTIONS FROM PUBLIC` without `IN SCHEMA`; a per-schema revoke cannot cancel PostgreSQL's global default. Any per-schema default ACL is inspected separately and may only add or reverse a prior per-schema grant. Every created helper, trigger function and append function is also explicitly revoked from `PUBLIC` at object level in the same transaction before selective exact-signature grants. Overloads receive no grant. Future fixture-function ACLs and `pg_default_acl` must prove both layers.
- Runtime/appender receives schema `USAGE` only where required to resolve the function and receives no schema `CREATE`; default privileges are explicitly installed and inspected rather than assumed safe. The authoritative installation sequence is §6.4.
- The function returns only event ID, recorded time, and disposition. No stored envelope or metadata is returned.
- The runtime cannot manipulate the catalog. Only a separately reviewed migration may add a row; catalog update/delete/truncate triggers and ACLs are defense in depth.
- Slice 1 does not rely on Row-Level Security. Both Audit relations require `relrowsecurity = false`, `relforcerowsecurity = false` and zero `pg_policy` rows. Any enabled/forced RLS state or policy is unreviewed drift and fails acceptance.
- Catalog inspection must prove the append function's exact signature/result, owner and ACL plus `prosecdef = true`, `provolatile = 'v'`, `proparallel = 'u'`, `proleakproof = false`, and `proconfig` exactly equal to the reviewed fixed search path. The helpers must be non-definer, immutable, parallel-safe, non-leakproof, with reviewed signatures/results, owners, ACLs and fixed `proconfig`. The append-only trigger function must also have its exact no-argument trigger signature/result, schema-owner ownership, no `PUBLIC` execute, `prosecdef = false`, `provolatile = 'v'`, `proparallel = 'u'`, `proleakproof = false`, exact `proconfig` and normalized definition hash; `pg_trigger` must prove all four reviewed bindings are enabled on the intended relations.
- Event update/delete/truncate triggers and lack of runtime table privilege protect append-only behavior. Function owner receives `SELECT, INSERT` only; the ordinary replay read has no locking clause and needs no `UPDATE`. It receives no `UPDATE`, `DELETE`, `TRUNCATE`, `REFERENCES`, `TRIGGER` or `MAINTAIN`. Table owner, superuser, break glass, provider control plane and restore remain acknowledged bypasses.
- With no string-built statement or dynamic SQL, input cannot alter statement structure. Malformed/oversized JSONB is rejected before insert and never included in an error.
- PostgreSQL cannot recognize secrets or prove that a User/Organization pair came from Identity. Audit Application must validate schema semantics and trusted scope before calling the adapter.

The surrounding catalog DDL uses two schema-owner-owned, non-`SECURITY DEFINER`, `IMMUTABLE`, `PARALLEL SAFE` SQL helpers. `audit_evidence_outcomes_well_formed(text[])` requires a nonempty one-dimensional array with lower bound 1, no SQL-NULL element, applies the outcome regex to every `unnest`ed element, and rejects exact duplicate values. `audit_evidence_metadata_keys_well_formed(text[])` permits the canonical empty array; otherwise it requires one dimension with lower bound 1, no SQL-NULL element, applies the metadata-key regex to every element, and rejects exact duplicate values. Duplicate comparison is case-sensitive under `COLLATE "C"`; the lower-case identifier grammar independently rejects case-different invalid spellings. Both return false for a SQL-NULL array. The catalog columns also remain `NOT NULL`, and required keys remain a subset of allowed keys. PostgreSQL does not permit a subquery directly in a `CHECK` expression, so the documented `CHECK` constraints call these immutable helpers. The helpers are created and owned with the catalog objects, receive no `PUBLIC` execution, and grant execution only to the controlled schema-owner installation path and the append function owner for defensive catalog validation. Changing either helper requires the same reviewed migration, definition-hash evidence and restore reconciliation as changing the append function or constraints. Neither helper repairs input by normalization, deduplication, sorting or reordering.

### 4.2.1 Fail-closed validation order and NULL reasoning

This in-function order begins only after PostgreSQL has successfully parsed and resolved the call and bound, protocol-decoded and converted/coerced every typed argument. A failure during any of those pre-entry stages occurs before the PL/pgSQL body starts, so the encoding assertion has not run and the SQLSTATE is not guaranteed to be `AUE02`. Such a native protocol/bind/type failure is nevertheless a permanent fail-closed database/security-control failure: no receipt or successful Application result may be constructed, no further Audit or business statement may run in that failed transaction, the whole transaction must unwind, and the adapter must not retry on another connection or continue with a partially valid transaction.

1. On the exact PostgreSQL session executing the function, require `pg_catalog.current_setting('server_encoding') = 'UTF8'` and `pg_catalog.current_setting('client_encoding') = 'UTF8'` before argument, catalog or event access. Mismatch raises project SQLSTATE `AUE02`; the function performs no append/replay query and returns no row.
2. Reject null or blank mandatory arguments and invalid event versions before any catalog or event access.
3. Treat the supplied Organization and producer values as typed candidate identities. The function does not reveal Organization existence before catalog denial: the Organization FK is checked only on an approved insert, while trusted Organization derivation remains an Application responsibility.
4. Resolve an exact migration-approved `(producer_key, event_type, event_version)` catalog row. Slice 1 has an empty catalog, so missing, inactive, mismatched and unapproved tuples all produce the same project-defined `AUE01` denial. There is no mutable `active` flag; adding producer/catalog lifecycle is a later decision. Native PostgreSQL `42501` is never this policy result.
5. Revalidate the selected catalog arrays through the element-wise immutable helpers, then validate catalog modes and event-specific envelope rules. Outcome membership is accepted only when `(p_outcome COLLATE "C" = ANY (allowed_outcomes COLLATE "C")) IS TRUE`; required/allowed array containment also uses explicit `COLLATE "C"`; `IS DISTINCT FROM TRUE` rejects false and SQL null. Catalog constraints and the defensive function call reject SQL-NULL arrays/elements, multidimensional arrays, noncanonical lower bounds, empty outcome arrays, every invalid individual element and exact duplicate elements. No invalid array is silently normalized, deduplicated or reordered.
6. Validate metadata root, size, allowed/required keys, and scalar values.
7. Only after every mandatory validation succeeds may the function attempt insert or replay resolution. A replay never bypasses current mandatory validation.

Nullable optional fields use explicit paired/mode predicates or `IS [NOT] DISTINCT FROM`: Session, target, correlation, and causation checks reject forbidden/required mismatches; replay equality treats null as an exact value. Catalog mode columns and arrays are `NOT NULL` and constrained. `jsonb_typeof` is evaluated only after SQL-null metadata rejection. No remaining `NOT (...)`, `ANY`, array-containment, or optional-field predicate is permitted to convert SQL null into acceptance.

### UTF-8 lifecycle enforcement matrix

No database is accepted for application service until the database actually serving the application reports `server_encoding = 'UTF8'` and each participating PostgreSQL session reports `client_encoding = 'UTF8'`. A check against a maintenance database, template database, archive, configuration string or representative connection is not proof for another target/session. The append function's first executable control is the exact-session assertion shown in §4.1; connection/startup/monitoring controls are defense in depth and cannot replace it.

The named principals below are logical responsibilities, not appointed humans, provider products or credentials. Every load/restore stage emits a retained acceptance record bound to one non-reusable attempt ID, one unique invocation, one source artifact and one target generation, in addition to its target-attestation tuple, principal/session, check time, exact server/client results, tool result where applicable and reconciliation disposition. Missing, stale, duplicated, mixed, mismatched or unverifiable evidence is failure.

| Lifecycle stage | Enforcing principal and timing | Exact target and assertions | Retained evidence | Failure and isolation effect |
|---|---|---|---|---|
| Database creation | Controlled provisioning principal specifies UTF-8, then acceptance principal connects before migration or application use | Newly created database identified by the environment-approved target-attestation tuple; server `UTF8`, acceptance-session client `UTF8` | Provisioning invocation, target tuple, database name/observed OID, session principal, values and timestamps | Drop or quarantine empty target; do not migrate, issue runtime credentials, enable readiness or route traffic |
| Rails migration | Controlled migrator checks at the first statement of the authorized migration transaction | Exact migration target and session; server/client `UTF8` | Migration/release id, target tuple, session principal, pre-DDL values and transaction outcome | Raise and roll back before Audit DDL; deployment/readiness remain blocked |
| `structure.sql` load | Load orchestrator preflights before loader invocation and reconciles after loader completion | Exact pre-created load target generation; preflight and loader session client plus server `UTF8` | Non-reusable attempt ID, unique invocation, structure hash/version, target-generation observations, tool/version, pre/post target checks, aggregate exit status, stderr/error summary and normalized inventory result | Failed preflight prevents load; nonzero/ambiguous exit, partial load, generation change or failed reconciliation quarantines target; no in-place promotion |
| Logical restore without `--create` | Restore orchestrator preflights before any restore command and accepts only after tool completion/reconciliation | Exact existing quarantined target generation; server and every observed restore-session client `UTF8` | Non-reusable attempt ID, unique invocation, archive digest, tool/version/options, target tuple/generation, principals, start/end, aggregate process status, exposed worker/tool evidence, errors/warnings and reconciliation | Preflight failure prevents restore. Any error, interruption, nonzero/unknown aggregate status, incomplete worker/tool evidence, generation change or failed reconciliation leaves target quarantined; rebuild from a clean target before promotion |
| Logical restore with `--create` | Restore orchestrator validates archive policy before the one-shot command; acceptance principal connects to the database created from the archive before handoff | Actual created target generation, never only the maintenance database used for `CREATE DATABASE`; created-target server and observed restore/acceptance clients `UTF8` | Non-reusable attempt ID, unique invocation, distinct maintenance/created-target attestations and generations, archive digest/name, tool/options, aggregate process status, exposed worker/tool evidence and post-restore reconciliation | One-shot restore may load data before target validation; the only guarantee is quarantine-before-service. A staged create/preflight/restore flow is required if pre-data validation is mandatory. Any uncertainty, mixed evidence or generation mismatch discards/quarantines target |
| Physical restore | Backup/restore principal restores offline; acceptance principal starts the restored cluster only in isolated maintenance mode | Restored cluster/data-directory target generation and every application-serving database; each server `UTF8`, local acceptance client `UTF8`, then intended application client `UTF8` | Non-reusable attempt ID, unique invocation, backup identity/digest where available, restored-target generation observations, isolation evidence, PostgreSQL/tool version, timings, database inventory and reconciliation | Runtime credentials, readiness, external network service and traffic remain disabled; mismatch, target replacement or incomplete evidence stops/quarantines restored instance |
| Rails/PostgreSQL connection establishment | Connection hook validates each newly established physical application connection before checkout for work | That exact database/session; server/client `UTF8` and approved target attestation | Pool/specification/role/shard, target tuple, raw-session identity reference, check time/result | Reject/disconnect physical connection and keep readiness false; no business/Audit work through it |
| Audit append boundary | After successful parse, function resolution, parameter binding, protocol decoding and argument conversion, the exact `SECURITY DEFINER` function checks before function-body argument/catalog/event access | Exact PostgreSQL session executing append; `current_setting('server_encoding') = 'UTF8'` and `current_setting('client_encoding') = 'UTF8'` | Structured native pre-entry failure, in-function `AUE02`, or successful function result within the same transaction; never a separate check connection | Either failure path causes whole-transaction unwind, no receipt/result, no later statement or partially valid continuation, no alternate connection and no fallback retry merely to obtain another encoding |
| Startup and post-restore acceptance | Deployment/startup acceptance principal evaluates every target plus connection-hook and restore/load evidence before publishing readiness | Every application-serving primary target; no representative connection substitutes for per-connection hook | Release/restore correlation, fresh target attestations, required inventory/ACL/function/trigger results and evidence age | Readiness remains false; runtime credential activation and traffic/service return remain blocked |
| Ongoing drift monitoring | Read-only monitor samples every serving target and representative sessions on an approved interval; exact append check remains authoritative | Attested targets and observed sessions; server/client `UTF8`, evidence freshness | Target tuple, check id/time, expiry/TTL, values and monitor health | Monitor only reports. Missing/stale/failing evidence is sent to the separate enforcement component; monitor itself does not claim traffic authority |

#### Exact-session append enforcement

PostgreSQL may reject a call before function entry while parsing, resolving the function, binding or protocol-decoding parameters, or converting/coercing argument types. The PL/pgSQL body and its encoding guard have not run on that path, so the resulting native error is not guaranteed to be `AUE02`. After successful resolution and argument conversion, `public.audit_evidence_append_organization_event` begins execution and its first control executes the two `pg_catalog.current_setting` assertions before function-body argument validation, catalog lookup, replay lookup or insert. `SECURITY DEFINER` changes effective function privileges, not the physical PostgreSQL session or its current server/client encoding; therefore this guard observes the same session that would perform the append. An encoding mismatch reached after function entry raises `AUE02`, maps to `security_control_failure`, aborts the transaction and emits no function result. Both the pre-entry native-failure path and the in-function `AUE02` path prohibit a receipt or successful Application result, further Audit or business statements in the failed transaction, continuation with a partially valid transaction, and retry on another connection as a fallback. A prior connection hook, startup check, pool sample or monitor success cannot satisfy the in-function assertion. Future tests separately prove pre-entry bind/decode/type failures fail closed and that changing `client_encoding` after an accepted checkout reaches the exact-session guard, raises `AUE02`, and performs no catalog/event access.

#### Restore target attestation and evidence model

PostgreSQL exposes no one universal identifier that, by itself, proves a logical database, physical cluster, provider instance and intended deployment target are all the same. Each environment must approve a **target-attestation tuple** before implementing a restore path. The tuple combines all reliably available binding evidence and records unavailable/provider-specific components explicitly:

| Evidence class | Required content | Binding status | Authority/limitation |
|---|---|---|---|
| Intended target binding | Environment-owned opaque target reference and expected database name/role | Required intent-side binding; immutability depends on the future environment authority | Orchestration input; never inferred from a URL alone |
| Observed database | `current_database()`, observed database OID, server address/port where meaningful, server version and encoding | Descriptive observation only | PostgreSQL-generated; database OID, name and address can be reused or changed and are not universal immutable identity |
| Cluster/instance binding | PostgreSQL system identifier when safely available plus provider/orchestrator instance identity when one is later selected | Required target-side binding; no individual field is universally immutable or globally unique | A physical clone may carry the source system identifier, while endpoints may move; missing approved composite binding blocks promotion |
| Session identity | Authenticated connection target, `session_user`, `current_user`, client encoding and restore/acceptance role | Descriptive session evidence correlated to the target binding | PostgreSQL/tool evidence; proves the observing session, not target intent by itself |
| Restore source | Archive/backup identifier, cryptographic digest where the artifact format permits it, source database metadata and backup timestamp | Artifact digest is immutable binding evidence only when the archive format and custody preserve it; other fields are descriptive | Orchestration/artifact evidence; source identity is distinct from target identity |
| Invocation | Non-reusable restore-attempt ID plus a unique invocation identity, tool and exact version/options, start/end timestamps, configured worker count, aggregate process exit status, exposed worker/tool evidence, errors and warnings | Exact binding for one attempt invocation; timestamps/status are descriptive outcomes | Trusted-orchestrator/tool evidence; unknown, incomplete, duplicated or mixed status is failure |
| Reconciliation | Expected database/module version and normalized pass/fail inventory for schema/objects, owners, ACLs/grants, function owner/EXECUTE, all table privileges, constraints/indexes, triggers/state, encoding and collations | Acceptance evidence bound through the target/source/invocation correlation; not an identity by itself | PostgreSQL catalog evidence interpreted by the acceptance mechanism |

No listed PostgreSQL field is treated as a universal immutable target or generation identifier. Database name, OID, endpoint, system identifier, timestamp and principal—alone or merely concatenated—cannot universally establish target generation. A future environment must define a provider-neutral logical `target_generation` value issued by a trusted fencing authority and bind it to the strongest provider/orchestrator observations available. Provider-specific generation identity and isolation mechanisms remain unresolved until a provider/deployment topology is selected; absence of a reviewed binding blocks promotion rather than inviting inference.

The trusted orchestrator issues a non-reusable restore-attempt ID and a unique invocation identity before mutation. An attempt ID is consumed forever after success, failure, cancellation, timeout or interruption and can never authorize a later invocation. Every evidence item is bound to exactly one attempt ID, source artifact, target generation and invocation; evidence across attempts or invocations is never combined. The target generation is captured and compared at four mandatory points: preflight before mutation, after restore completion, immediately before promotion, and inside the atomic promotion decision. Replacement or mismatch at any point invalidates the attempt, its ownership and all accumulated evidence.

A trusted fencing authority permits at most one active attempt to own a target generation. A concurrent attempt against that generation is serialized or rejected fail closed; a cancelled, failed, timed-out, interrupted or superseded attempt cannot regain ownership. This is a logical requirement, not a selected lock, lease, provider API or database mechanism. Promotion requires the approved composite of intent-side binding, target-generation binding, source artifact binding and attempt/invocation evidence; descriptive metadata cannot substitute for a missing binding.

#### Restore quarantine and promotion protocol

1. A restore target begins in logical state `QUARANTINED`: no runtime credentials, readiness, application service, external traffic or Audit participation. The accepted-state transition is one-way for a specific target generation; a replacement begins as a new quarantined generation.
2. Before mutation, the trusted orchestrator obtains a new non-reusable attempt ID, unique invocation and exclusive fenced ownership of the captured target generation. Reused IDs, concurrent ownership, already superseded ownership or an unprovable generation fail before restore mutation.
3. Preflight validates the intended target tuple/generation and encoding before load where the mode permits. `pg_restore` defaults to continuing after errors; `--exit-on-error` stops later commands but does not promise whole-restore rollback. `--single-transaction` may be selected only where the exact tool/mode supports it and does not replace quarantine.
4. Tool evidence is bound to the exact attempt, source, generation and invocation. For `pg_restore`, the aggregate process exit status is authoritative only for what that execution mode exposes. If the tool exposes no independent per-worker completion status, the record must say so and must not invent or claim `all worker statuses`; configured worker count, aggregate status and available logs remain distinct. Lost, incomplete, ambiguous or mixed worker/tool evidence fails the attempt.
5. One-shot `--create` keeps maintenance and created-target attestations/generations separate. If the tool cannot pause after creation, data may load before encoding validation; the created target nevertheless remains unreachable and unaccepted. Staged create/preflight/restore is required when the stronger pre-data guarantee is required.
6. After tool completion, the orchestrator revalidates the exact target generation. Post-restore reconciliation covers expected schema/object inventory, database/module version, ownership, grants/ACLs, exact function ownership/EXECUTE, all table privileges, constraints/indexes, triggers/state, encoding and collations. Missing or unexpected objects, failed checks or stale/duplicated/different-attempt, source, generation or invocation evidence reject promotion.
7. Immediately before promotion, the enforcement component revalidates current fenced ownership, target generation and complete evidence. The promotion decision then atomically rechecks those facts and performs exactly one one-way transition `QUARANTINED -> ACCEPTED`. It rejects stale, replayed, duplicated, mixed or superseded evidence and a prior successful promotion record; target replacement between final reconciliation and this transition invalidates the attempt. If the selected provider/orchestrator cannot guarantee this atomic check-and-transition, the target remains quarantined.
8. A partial, failed, cancelled, timed-out, interrupted, superseded or ambiguously completed logical restore is not repaired in place for promotion; recreate a clean quarantined target generation and start a new attempt with a new ID/invocation. A failed physical restore remains isolated and is discarded or rerun under the approved runbook.
9. Only the separately authorized enforcement component may activate credentials/readiness/traffic after the atomic accepted transition. It retains the immutable acceptance record and consumed attempt ID; replay of that record cannot promote a replacement generation.

#### Monitoring and readiness/traffic enforcement boundary

The read-only monitor produces an attested status message containing target reference, observation tuple, result, check time, expiry/TTL and monitor health. It has no database mutation, credential, readiness or traffic authority. A separate logical **readiness/traffic enforcement component** consumes those results. Its provider-neutral interface must:

- reject missing, stale, mismatched-target or failed evidence;
- reject reused/duplicated attempt IDs, mixed attempts or invocations, lost exclusive ownership, superseded attempts and changed target generations;
- keep or move service readiness to false;
- prevent new Audit participation and request traffic through the environment's later-selected control plane;
- treat monitor outage or expired evidence as failure, not last-known-good success; and
- restore service only after fresh full revalidation and an authorized release procedure.

The actual provider, product, operator, credentials, TTL, traffic mechanism and recovery authority are unresolved environment/Owner decisions. Until selected, the design states an interface and fail-closed outcome only; it does not claim an operating control exists.

The future suite covers accepted UTF-8 and rejected `SQL_ASCII`/other encodings; separate pre-entry parse/resolution/bind/decode/conversion failure and post-entry exact-session drift after checkout; malformed UTF-8/U+0000; non-ASCII and normalization-different scalar/array round trips; `structure.sql`; logical restore with/without `--create`; injected partial/parallel/interrupted restore; wrong maintenance-versus-created target; isolated physical restore; stale/missing monitor evidence; and actual enforcement-component denial. The latest narrow review verified `ISR-AUD-039/042` at design level and returned `ISR-AUD-041` for this micro-remediation; `ISR-AUD-041` remains pending final narrow read-only verification and later authorized executable acceptance evidence.

### 4.2.2 Authoritative identifier grammar and normalization policy

The following grammar is authoritative for Slice 1. Application validation, function validation and relation/catalog constraints must use the same ASCII rules. Invalid values are rejected; no layer trims, lowercases, Unicode-normalizes, replaces characters or otherwise converts one input into another idempotency identity.

| Field family | Type / nullability | Length | Allowed form | Case / normalization | Semantics |
|---|---|---:|---|---|---|
| Event, Organization, registration, actor User/Session, correlation, causation and target identifiers | PostgreSQL `uuid`; required/conditional as specified in §2.1 | Fixed UUID value | Application accepts canonical lower-case hyphenated ASCII UUID text; adapter binds typed UUID; PostgreSQL `uuid` rejects non-UUID values | UUID equality is value equality; no text normalization is performed by Audit | Opaque; never semantically parsed or used as authority by itself |
| `event_version` | `smallint NOT NULL` | Numeric `1..32767` | Positive integer | Not textual | Immutable registration version |
| `producer_key`, `event_type`, non-null `target_type`, `outcome`, internal `failure_class` | bounded `varchar COLLATE "C"`, required except conditional target | `1..100`, `1..160`, `1..120`, `1..24`, `1..40` respectively | C-collation regex `^[a-z][a-z0-9]*(?:[._-][a-z0-9]+)*$` | Lower-case, deterministic and case-sensitive in columns, indexes and comparisons; no folding | Machine identifier, not display text |
| `stable_attempt_key` | `varchar(255) COLLATE "C" NOT NULL` | `1..255` | C-collation regex `^[A-Za-z0-9][A-Za-z0-9._:/-]*$` | Deterministic and case-sensitive in column, unique index and comparison; no trimming or folding | Opaque stable logical-attempt identity; separators carry no Audit semantics |
| Metadata keys | catalog arrays of bounded ASCII `varchar` with array collation `"C"` | `1..120` per key | C-collation regex `^[a-z][a-z0-9_]*$` | Deterministic lower-case and case-sensitive membership, subset and duplicate equality | Event-schema field names |
| Human-readable metadata values | JSON scalar governed by the approved event schema | Event-specific plus catalog byte maximum | Not covered by machine-identifier grammar | Event-specific; no implicit normalization | Human/business evidence only when approved and minimized |

PostgreSQL `text`/`varchar` cannot contain a zero byte, so a NUL-bearing protocol value is rejected before it can become a function argument. That database behavior does not replace Application validation or safe error mapping. ASCII allowlists deliberately reject tabs, LF, CR, CRLF, vertical tab, form feed, DEL, every other ASCII control character, non-breaking space, Unicode whitespace and visually similar Unicode letters. Regex evaluation is explicitly under `COLLATE "C"`; the design does not rely on locale-dependent `\s` semantics. The function receives UUIDs as typed values and therefore cannot reconstruct or police their original textual spelling; canonical UUID text is enforced at the Application boundary, while PostgreSQL type/non-null/FK checks enforce the value. An alternate PostgreSQL-accepted UUID spelling denotes the same opaque UUID value and does not normalize the string-based Stable Attempt Key.

The relation constraints protect against a privileged path that bypasses the append function: scalar machine identifiers and the stable attempt key carry the same regex checks, and catalog outcome/metadata-key arrays call immutable helpers that `unnest` and validate every element. No comma-joined serialization is used: `ARRAY['valid_one,valid_two']` is rejected while `ARRAY['valid_one', 'valid_two']` is accepted for metadata keys. A table owner/superuser can still remove or alter constraints or helpers; that remains `AUD-SEC-14`, not a claim of absolute protection.

#### Required identifier negative cases

Every case below must produce the safe `invalid_event` category, insert no row and return neither `appended` nor `idempotent_replay`. An approved-catalog fixture containing the same invalid value must itself fail its catalog constraint.

| Input case | Expected result / enforcing layer |
|---|---|
| Empty string; spaces only; leading/trailing space | Reject in Application, function regex and scalar/table/catalog constraint |
| Tab, LF, CR, CRLF, vertical tab or form feed | Reject at all three validation layers |
| DEL or any embedded ASCII control character | Reject at all three validation layers |
| NUL | Reject in Application/protocol binding; PostgreSQL character types cannot store it |
| Non-breaking space or other Unicode whitespace | Reject because it is outside the explicit ASCII allowlist |
| Mixed otherwise-valid text with an embedded control | Reject; no partial trimming or replacement |
| Overlength value | Reject in Application/function; typmod or explicit relation constraint provides database defense |
| Visually similar Unicode identifier | Reject; no Unicode normalization to an ASCII identity |
| Differently cased stable attempt keys | Remain distinct values; no case-folding. Producer tests must prove it preserves the same canonical key on retry |
| `ARRAY['valid_one,valid_two']` or any single element containing a comma/delimiter | Reject that individual element; never treat its serialization as two valid elements |
| Empty, SQL-NULL-bearing, multidimensional or non-1-lower-bound catalog array | Reject, except canonical empty allowed/required metadata-key arrays remain permitted |
| Required metadata key absent from the allowed-key array | Reject through the subset constraint |

Mandatory validation, including this grammar, still precedes catalog lookup, insert and replay. A malformed retry therefore receives validation failure, not replay success. A same-identity retry whose inputs are otherwise valid and approved but whose semantic comparison facts differ receives `conflicting_replay`.

### 4.2.3 Failure-class authority and registration binding

Audit Evidence owns the immutable event registration. A producer-owned convenience port selects a reviewed operation; it does not accept `failure_class`, `registration_id`, producer identity or event identity from an HTTP/client command. Audit Application resolves that operation to an internal registered definition containing the registration UUID, producer/type/version tuple, exact failure class and event-schema rules.

The version-controlled Audit registration definition is the authoritative source. The migration-owned database catalog is its enforcement projection. One reviewed release change must create both; the catalog stores the same `registration_id`, tuple and failure class. Audit Infrastructure supplies the internal registration UUID and resolved failure class to the append function; neither originates in the producer request. The function resolves the exact catalog row by registration UUID, failure class and tuple before any append or replay. A missing, unknown, unapproved or mismatched projection receives `event_not_approved`; it never falls back to a producer-provided class.

The failure class controls Audit Application orchestration and is never a producer request field. Its internal function parameter exists only to verify that the Application registration and database projection agree; the function does not let it override catalog policy. Database failure cannot cause the producer to select a weaker response: Application already holds the resolved registered definition and applies its class to the participating transaction. A registration row is append-only. After any event uses it, changing meaning, failure class, metadata schema or other semantic policy requires a new event version and new registration UUID; update-in-place is prohibited.

Release verification must compare the Application registration manifest with normalized catalog fixtures before enabling a producer. It proves a one-to-one match of registration UUID, producer/type/version, failure class and schema policy. Unknown/missing/extra/mismatched rows abort installation or producer activation. This synchronization evidence is generated only after an authorized implementation; no current registration or catalog row exists.

The phrase “normalized catalog fixtures” refers only to presentation of catalog-introspection evidence and does not define or alter registration bytes. Canonical registration projection is exclusively the version-1 binary contract in [Logical Contract §10.1.1–10.1.5](organization_level_audit_logical_contract_design.md#1011-authoritative-registration-projection-identity): fixed header; 21 tagged, typed, presence-marked and length-framed fields; exact UTF-8/UUID/integer/date/array encoding; and SHA-256 over every canonical byte. `allowed_outcomes`, `allowed_metadata_keys` and `required_metadata_keys` retain one explicit order fixed by the reviewed immutable registration. Application validation rejects duplicates before projection. Arrays with identical members in a different order remain membership-equivalent but have different canonical bytes and digests. Required-key subset semantics remain unchanged.

Audit Evidence Application registration authority is the single logical projection/comparison boundary already established by this design. The eventual class, packaging and invocation mechanism require separately authorized implementation design. PostgreSQL inspection returns typed fields only; catalog-fixture generation, release tooling and drift checks must invoke the Audit-owned versioned encoder or consume its exact canonical-byte artifact. They must not hash Ruby objects, JSON, PostgreSQL array text or delimiter-joined strings independently. Version/byte/digest mismatch, unsupported version, invalid framing or invalid registration fails closed and aborts release or producer activation.

Required negative tests cover producer-supplied failure-class rejection, attempts to select a weaker class, manifest/catalog disagreement, unknown registration, changed registration after use, uncertain-commit retry under the same attempt identity and the separately approved transaction behavior of every enabled failure class. Exact semantics for the first class remain `AUD-DEC-08` and cannot be inferred here.

### 4.3 Safe error mapping

| SQLSTATE/source | Application category | Disclosure rule |
|---|---|---|
| Native PostgreSQL parse, function-resolution, parameter-bind, protocol-decode or argument-conversion/coercion failure before function entry | `security_control_failure` or `audit_storage_failure` according to the structured native SQLSTATE; never `event_not_approved` or success | The in-function guard has not run and `AUE02` is not guaranteed. Disclose no value or topology detail; construct no receipt/result, issue no later Audit or business statement in the failed transaction, unwind the whole transaction, and do not retry on another connection or continue a partially valid transaction. |
| `22023` | `invalid_event` | Do not echo values, metadata, or catalog details. |
| Project-defined `AUE01` raised only by the exact registration lookup | `event_not_approved` | Do not reveal whether registration, producer, type, version, or failure class was individually present or mismatched. `AUE01` is a valid five-character, uppercase-alphanumeric PostgreSQL SQLSTATE, is outside the standard classes used here, and does not end in category code `000`. |
| Project-defined `AUE02` raised only by the first in-function server/client encoding assertion | `security_control_failure` | Treat a non-UTF8 exact executing session or server as environment-integrity failure, disclose no encoding or topology detail to a producer, issue no later statement in the aborted transaction and never retry on another connection. |
| Native `42501` from function invocation or object access | `security_control_failure` | Treat missing exact `EXECUTE`, schema `USAGE`, function-owner `SELECT`/`INSERT`, or other permission drift as integrity/security-control failure; never translate it to ordinary policy denial. Do not disclose the missing privilege to a producer. |
| `23505` named attempt constraint | `conflicting_replay` | Return safe correlation/error reference only. |
| `23503` Organization/catalog FK | `invalid_scope_or_catalog` | Do not distinguish tenant existence to untrusted callers. |
| `40001`, `40P01` | `retryable_infrastructure_failure` | Retry the whole transaction under bounded policy; never claim append success. |
| Other recognized storage error | `audit_storage_failure` | Fail according to the registered failure class; log without payload. |
| Unknown, malformed, or unmapped SQLSTATE | `audit_storage_failure` plus security alert | Fail closed; never infer policy denial, replay, or success. Preserve only a safe diagnostic reference. |

The adapter maps `event_not_approved` only from exact `AUE01`. Registration absence and tuple/failure-class mismatch intentionally share that category and disclosure. Exact `AUE02` is a permanent security-control failure only for the path that successfully entered the function and reached its first encoding assertion; it is not a policy denial or a reason to retry on another connection. A parse, resolution, bind, protocol-decode or type-conversion/coercion error can occur before function entry and therefore need not carry `AUE02`; its structured native SQLSTATE must still fail closed as a security-control/storage failure. Native privilege errors are also operational control failures even when they occur before the function body runs. A valid policy denial, pre-entry database/protocol failure, in-function encoding mismatch, missing function-owner catalog `SELECT`, missing event `INSERT`, missing schema `USAGE`, runtime without exact function `EXECUTE`, unexpected native `42501`, and unknown/malformed state each require separate disposable negative evidence after implementation authorization.

Infrastructure obtains SQLSTATE only from structured PostgreSQL diagnostic data: the wrapped `PG::Error`/result field `PG_DIAG_SQLSTATE`. It never searches exception-message text, localized detail, constraint text or backtraces. A missing database cause, missing result, blank/non-five-character state, unexpected function result row/count/disposition, or unmapped state is an `audit_storage_failure` plus alert. The adapter validates the exact result column types and the allowed provisional dispositions before constructing a `PendingAppendReceipt`.

Any PostgreSQL error represented by `ActiveRecord::StatementInvalid`, whether it occurs before or after function entry, invalidates the current PostgreSQL transaction. The adapter may classify the error for the outer owner, but must construct no successful receipt or Application result, re-raise/unwind to that owner, and must not issue another Audit or business query, log write, reconciliation lookup or retry inside the failed transaction. It must not switch connections as a fallback or continue using a partially valid transaction. `40001` and `40P01` permit only a bounded retry of the **entire outermost transaction**, using the same stable attempt identity, when a separately approved retry policy exists. `23505` is mapped to `conflicting_replay` only when raised deliberately by the reviewed function with the exact named attempt constraint after its ordinary post-conflict comparison; an unexpected database uniqueness error is storage/integrity failure. No error produces `CommittedAppendResult`; only known successful outer commit can do so.

## 5. Trust-boundary alternatives

| Model | Boundary and protection | Residual risk / cost | Slice 1 conclusion |
|---|---|---|---|
| A — trusted modular-monolith composition | Only Audit Application/adapter receives a private trusted Identity/Organization context; Packwerk/interface tests prohibit direct calls. | Compromised in-process code or stolen runtime credential can still supply forged typed values to the function. PostgreSQL cannot prove Identity issuance. | Design-compatible for an empty catalog. `AUD-DEC-11` remains required before the first production event. |
| B — signed database-verifiable assertion | Audit Application signs Organization/actor/attempt claims; function verifies signature, expiry, nonce, and key version. | Secret/key custody moves into database/function; rotation, replay, canonical encoding, clock, and revocation become new high-risk mechanisms. | Not approved; requires separate cryptographic design and review. |
| C — isolated audit service/credential | A separate process validates producer credentials and owns append access. | Stronger isolation but breaks the current local atomic transaction or requires an outbox/distributed consistency design. Availability and producer authentication expand scope. | Not approved and unsuitable as an incidental Slice 1 change. |

The empty foundation can use Model A for characterization tests because there is no approved catalog row and therefore no successful production append. A production event cannot rely on that fact; the Owner must decide `AUD-DEC-11` with independent security advice.

### 5.1 Comparative threat analysis

| Dimension | Model A | Model B | Model C |
|---|---|---|---|
| Protects against | Untrusted HTTP/client actor, Organization, role, Branch, and producer parameters when all entry points use private trusted contracts | Model A threats plus some arbitrary database callers lacking a valid assertion | In-process producer compromise that lacks the separate service credential |
| Does not protect against | Compromised application process/runtime credential or bypass of Audit Application | Compromised signer/key, database verifier/function owner, canonicalization defects | Compromised audit service/credential, privileged DB roles, false input accepted by service |
| Attacker assumption | Client controls request; ordinary app modules are constrained by architecture | Attacker may call DB function but cannot mint protected assertion | Producer process may be compromised independently of audit service |
| Credential custody | Existing runtime credential; private Ruby constructors/contracts | Signing and verification keys, rotation/revocation, clock/nonces | Separate service identity, mTLS/token/DB credential and rotation |
| Transaction effect | Preserves the designated wrapper-owned local transaction; arbitrary ambient/caller-owned entry remains unsupported | Can preserve a separately designed transaction but adds verification/key availability | Usually loses local atomicity or requires outbox/distributed protocol |
| Failure behavior | Audit failure follows catalog failure class | Verification/key failure must fail closed for authoritative events | Network/service ambiguity requires reconciliation; no success inference |
| Testability | Interface/Packwerk/adversarial integration plus role tests | Cryptographic vectors, expiry/replay/rotation and DB verifier tests | Contract, network failure, duplicate, outbox/atomicity and credential tests |
| Residual risk | PostgreSQL trusts typed claims supplied by compromised runtime | Key compromise or verifier defect forges claims | Service/credential/operations become new critical trust domain |

### 5.2 Identity distinctions and future system extension

- User is the authenticated security principal. Employee is a Workforce identity and is neither required nor inferred for Slice 1 actor attribution.
- Session is optional/required only by an approved event catalog entry; it is not a User or Employee substitute.
- Organization scope comes from trusted authorization/resource ancestry, not request parameters. Role Assignment and Employee Branch Assignment may authorize a business action but are not copied into the audit actor unless an event-specific schema is later approved.
- The producer key is selected by reviewed code/composition, never by an HTTP caller. Audit actor attribution does not prove employment or Branch eligibility.
- A future system extension must define a registered producer identity, privately issued producer context, execution/run identity, environment/deployment provenance, key/credential rotation and revocation, replay behavior, and accountable operational custody. None exists or is enabled here.

## 6. Database roles and custody design

| Role | Login | Owns | Required privileges | Explicitly prohibited |
|---|---|---|---|---|
| `af_schema_owner` | No | Audit tables, constraints, triggers and immutable array-validation helpers | DDL ownership only | Runtime membership, application login, routine use |
| `af_migrator` | Environment-managed login | Nothing | Recorded, time-bounded `SET TRUE, INHERIT FALSE, ADMIN FALSE` membership in both schema owner and function owner during one approved install/rollback window | `SUPERUSER`, `CREATEROLE`, `CREATEDB`, `REPLICATION`, `BYPASSRLS`, runtime use, standing developer/owner membership or inherited owner rights |
| `af_audit_function_owner` | No | Exact append function only | `SELECT` catalog; `SELECT, INSERT` event table; schema usage; `EXECUTE` on the two exact non-definer array-validation helpers | Table/schema/helper ownership, login, runtime membership, update/delete/truncate, role administration |
| `af_runtime` | Yes, managed | Nothing | Normal application privileges outside this audit grant | Audit base-table/catalog privileges, object creation, ownership, role assumption |
| `af_audit_appender` | No grant role | Nothing | Exact-signature append `EXECUTE` only; no Empty-Slice runtime member | Table/catalog access, overload execute, role administration |
| `af_audit_reader` | No grant role | Nothing | None in Slice 1 | Read/search/export until `AUD-DEC-12/13` approval |
| `af_audit_break_glass` | Controlled issuance only | Nothing | No standing grant; time-bound reviewed incident access later | Runtime inheritance, silent use |
| Backup/restore operator | Infrastructure-controlled | N/A | Offline backup/restore duties under runbook | Application use; claim of trigger-enforced immutability |

### 6.1 Custody and provisioning requirements

1. Production role creation is infrastructure provisioning, not Rails migration behavior.
2. `NOLOGIN` owners have no credentials. Runtime, developers, ordinary deploy jobs and appender roles cannot `SET ROLE` to them. Only the controlled `af_migrator` identity may receive recorded, time-bounded `SET`-only memberships in both `af_schema_owner` and `af_audit_function_owner` during one approved installation or empty rollback window; neither membership has `INHERIT` or `ADMIN OPTION`, and both are revoked at handoff.
3. Runtime, migrator, break-glass, and backup credentials are separately generated, stored, rotated, revoked, and monitored. No named person or system is appointed by this design.
4. The deployment record captures role memberships, ACLs, owners, function definition hash, default privileges, and exact granted signature.
5. Migration authority may replace the function only through an approved release. Function-definition drift is monitored.
6. Break-glass issuance requires external access evidence and post-use review. Exact approvers and retention remain operational/security decisions.
7. Backup/restore can bypass database append-only controls. Restore boundaries and reconciliation must be recorded; no “tamper-proof” claim is permitted.

### 6.2 Credential operations matrix

| Role | Custody | Rotation/revocation | Monitoring | Recovery |
|---|---|---|---|---|
| Schema owner | No credential; controlled assumption path held by deployment system | Revoke migrator assumption immediately on deployment compromise | Owner/membership/default-privilege drift | Recreate controlled assumption after dual-reviewed incident procedure |
| Migrator | Deployment secret store/identity; unavailable to runtime | Rotate per platform policy and after suspected exposure; disable between releases where supported | Every assumption, DDL and ownership change | Break-glass deployment procedure; never grant runtime fallback |
| Function owner | `NOLOGIN`; no credential or ordinary assumption | Revoke any unexpected membership immediately | Function owner/definition/hash/ACL drift | Approved migration restores reviewed definition and ownership |
| Runtime/appender | Application secret manager and workload identity | Bounded rotation; immediate revoke on compromise | Successful/failed append categories, grant/membership drift, anomalous rates | Issue replacement runtime identity; do not grant table access as recovery |
| Future reader | No Slice 1 credential/grant | Not applicable until separately designed | Any unexpected reader privilege is an incident | Revoke drift; no emergency read grant without approved process |
| Break glass | Time-bound, dual-reviewed issuance; no standing app membership | Expires automatically; revoke after use | External access log, database session/statement evidence, post-use review | Separate incident runbook and evidence reconciliation |
| Backup/restore | Infrastructure secret/HSM/managed backup custody | Platform rotation and immediate compromise response | Backup access, restore initiation/completion, boundary reconciliation | Tested restore runbook; reconciliation before returning service |

### 6.3 Effective privilege matrix

| Operation | Schema owner | Migrator (during approved assumption) | Function owner | Runtime/appender | Reader | Break glass / restore |
|---|---:|---:|---:|---:|---:|---:|
| Database `CONNECT` | No login; no independent connection | Controlled deployment connection | No login; function uses caller connection | Runtime yes; appender no login | No Slice 1 login/grant | Controlled |
| Database `CREATE` / `TEMPORARY` | No standing grant | `CREATE` only if deployment topology requires it; no routine `TEMPORARY` | No | No | No | Controlled exception only |
| Own/alter audit relations | Yes | Controlled | No | No | No | Privileged exception only |
| Replace append function | No unless approved ownership assumption | Controlled release | Owns exact function | No | No | Privileged exception only |
| Read catalog | Owner capability | Controlled | Yes | No direct read | No | Privileged exception only |
| Event `SELECT` | Owner capability | Controlled | Yes, only for function execution | No direct access | No | Privileged exception only |
| Event `INSERT` | Owner capability | Controlled | Yes, only for function execution | No direct access | No | Privileged exception only |
| Event/catalog `UPDATE`, `DELETE`, `TRUNCATE`, `REFERENCES`, `TRIGGER`, `MAINTAIN` | Owner bypass possible | Controlled but prohibited by release policy | No | No | No | Privileged bypass possible |
| Execute exact append signature | Not a runtime duty | Test/deploy only | Owner implicit | Appender yes; runtime no in Empty Slice | No | Possible but externally governed |
| Create in application/public schema | Owner-only as designed | Controlled | No | No | No | Privileged bypass possible |
| Grant roles/privileges | No role-admin by default | Only separately controlled provisioning identity | No | No | No | Infrastructure exception only |
| `SET session_replication_role` / `ALTER SYSTEM` | No | No routine need | No | No | No | Explicit incident/platform procedure only |

### 6.4 Authoritative privilege-installation specification

This section is the authoritative Slice 1 installation design. It is proposed SQL/operational specification only; nothing here has been executed. The role names are review identifiers. A deployment authorization must bind them to environment-specific principals without changing their effective privilege properties.

#### 6.4.1 Role and membership invariants

| Principal | Required attributes and membership |
|---|---|
| `af_schema_owner` | `NOLOGIN`, `NOSUPERUSER`, `NOCREATEDB`, `NOCREATEROLE`, `NOREPLICATION`, `NOBYPASSRLS`; owns only the two Audit relations, their constraints/indexes, the two immutable array-validation helpers, and the append-only trigger function/triggers. It does not own the shared `public` schema. No runtime membership. |
| `af_migrator` | Controlled deployment login/identity with `NOSUPERUSER`, `NOCREATEROLE`, `NOCREATEDB`, `NOREPLICATION`, `NOBYPASSRLS`. Its role attribute may remain `INHERIT`, but every owner membership is explicitly `INHERIT FALSE`; no standing inherited owner rights are permitted. A provisioning authority may grant `SET TRUE, INHERIT FALSE, ADMIN FALSE` membership in an owner role for one approved deployment and must revoke it after handoff. It receives no runtime traffic. Database `CREATE`, `TEMPORARY`, parameter `SET` and `ALTER SYSTEM` remain absent unless a separately reviewed deployment/platform procedure proves a narrower temporary need. Provider superuser/control-plane authority is a separate privileged boundary and is not constrained by this PostgreSQL role. |
| `af_audit_function_owner` | Same non-login/non-administrative attributes; owns only the exact append function. It receives `USAGE` on `public`, catalog `SELECT`, event `SELECT, INSERT`, and `EXECUTE` on the two exact non-definer array-validation helpers; no schema/table/helper ownership or other DML. |
| `af_runtime` | Managed login with database `CONNECT`; no database `CREATE`/`TEMPORARY`, parameter `SET`, `ALTER SYSTEM`, owner/migrator/function-owner/break-glass membership or equivalent control-plane path. Empty Slice 1 grants no `af_audit_appender` membership. A separately authorized first-producer activation may later grant reviewed membership. |
| `af_audit_appender` | `NOLOGIN` grant role; exact function `EXECUTE` only plus the minimum schema `USAGE` needed to resolve that function. It has no table/catalog privileges, role-administration path or Empty-Slice runtime member. |
| `af_audit_reader` | `NOLOGIN`; no membership or object grant in Slice 1. |
| `af_audit_break_glass` | No standing application membership or Slice 1 object grant. Any later time-bound issuance is external to this migration and requires approved incident governance. |
| Backup/restore principal | Infrastructure-controlled and absent from application role membership. Restore is followed by ownership/ACL reconciliation before service return. |

Every owner/appender grant is evaluated through direct grants, `PUBLIC`, nested membership, `INHERIT`, `SET ROLE`, `ADMIN OPTION`, ownership, default privileges, database/schema privileges, `pg_parameter_acl`, role/database settings and external control-plane authority. A direct-grant-only inspection is insufficient.

#### 6.4.2 Effective privilege target

Database and parameter privilege targets are explicit per principal; “absent” includes direct, `PUBLIC`, inherited, role-setting, ownership, role/database setting and control-plane-equivalent paths.

| Principal | `CONNECT` | Database `CREATE` | `TEMPORARY` | Parameter/configuration authority |
|---|---|---|---|---|
| `af_schema_owner` | No login; no independent connection | Absent | Absent | No `SET session_replication_role`; no `ALTER SYSTEM` |
| `af_migrator` | Deployment connection only | Absent unless a separately reviewed temporary deployment need is proven | Absent | No routine parameter `SET` or `ALTER SYSTEM`; any incident exception is external and separately approved |
| `af_audit_function_owner` | No login; function executes in caller session | Absent | Absent | No parameter/configuration authority |
| `af_runtime` | Required for the reviewed application database only | Absent | Absent | No direct, `PUBLIC`, inherited or role-setting `SET` on `session_replication_role`; no `ALTER SYSTEM` or equivalent control-plane path |
| `af_audit_appender` | No login; no runtime membership in Empty Slice | Absent | Absent | No parameter/configuration authority |
| `af_audit_reader` | No login or database grant in Slice 1 | Absent | Absent | No parameter/configuration authority |
| `af_audit_break_glass` | No standing grant; time-bound connection only under future incident procedure | Absent unless that procedure expressly authorizes it | Absent unless expressly authorized | Explicit incident-only scope, external evidence and expiry; no standing authority |
| Backup/restore principal | Infrastructure-controlled connection or offline mechanism only | Platform/runbook-specific | Platform/runbook-specific | Controlled restore/configuration authority; absent from application memberships and reconciled before service return |

| Capability | Schema/table owner | Migrator outside deployment | Function owner | Runtime/appender | Reader | Break glass / restore |
|---|---:|---:|---:|---:|---:|---:|
| Database `CONNECT` | No login | Deployment baseline only | No login | Runtime yes; appender NOLOGIN and unassigned | No Slice 1 login/grant | Controlled |
| Database `CREATE` / `TEMPORARY` | No standing grant | No outside separately approved deployment need | No | No | No | Controlled exception only |
| Schema `USAGE` on `public` | Yes | Ordinary deployment need only | Yes | Yes, resolution only | No Slice 1 grant | Controlled |
| Schema `CREATE` on `public` | No standing need beyond controlled owner/provisioner path | No | No | No | No | Controlled |
| Catalog `SELECT` | Owner implicit | No | Yes | No | No | Controlled |
| Event `SELECT` | Owner implicit | No | Yes | No | No | Controlled |
| Event `INSERT` | Owner implicit | No | Yes | No | No | Controlled |
| Event/catalog `UPDATE` | Owner can bypass by definition but release policy prohibits routine use | No | No | No | No | Controlled bypass |
| Event/catalog `DELETE` | Owner can bypass by definition but release policy prohibits routine use | No | No | No | No | Controlled bypass |
| Event/catalog `TRUNCATE` | Owner can bypass by definition but release policy prohibits routine use | No | No | No | No | Controlled bypass |
| Event/catalog `REFERENCES` | Owner implicit | No | No | No | No | Controlled bypass |
| Event/catalog `TRIGGER` | Owner implicit | No | No | No | No | Controlled bypass |
| Event/catalog `MAINTAIN` | Owner implicit | No | No | No | No | Controlled bypass |
| Sequences | None; UUIDs require no sequence | None | None | None | None | Controlled if platform requires |
| Exact append `EXECUTE` | No runtime duty | No outside verification | Owner implicit | Appender yes; runtime cannot assume it | No | Controlled |
| Array-helper `EXECUTE` | Owner implicit | No outside verification | Exact two helpers only | No | No | Controlled |
| Other/overload function `EXECUTE` | No grant by this design | No | No | No | No | Controlled |
| Assume schema/function owner | N/A | Temporary `SET`-only path during approved deployment, then revoked | N/A | No direct or nested path | No | Controlled |
| Replace function/trigger or alter owner | Schema owner controls trigger objects; function owner controls its function | Only during approved temporary assumption | Function owner by definition | No | No | Controlled bypass |
| Parameter `SET` for `session_replication_role` | No | No routine grant | No | No direct, inherited, `PUBLIC` or role-setting path | No | Explicit incident-only if separately approved |
| `ALTER SYSTEM` / configuration-file or control-plane equivalent | No | No routine authority | No | No | No | Platform-controlled exception only |

#### 6.4.3 Ordered installation and handoff

1. The external provisioning authority creates or verifies the role identities and attributes above. It records `rolsuper`, `rolcreaterole`, `rolcreatedb`, `rolcanlogin`, `rolinherit`, `rolreplication`, and `rolbypassrls` without recording secrets. It also inventories database ACLs (`CONNECT`, `CREATE`, `TEMPORARY`), role/database configuration, `pg_parameter_acl`, `ALTER SYSTEM`/configuration custody and equivalent provider control-plane authority.
2. It verifies that runtime has no direct or nested membership with `INHERIT`, `SET`, or `ADMIN OPTION` in schema owner, migrator, function owner, break-glass, or infrastructure roles. Any temporary migrator membership is approved, time-bounded, and recorded.
3. Before creating Audit objects, require `current_setting('server_encoding') = 'UTF8'`; a non-UTF-8 or `SQL_ASCII` database aborts installation. Inspect database and `public` schema ownership/ACLs. `PUBLIC` and runtime must not have database `CREATE`/`TEMPORARY` or schema `CREATE`; runtime requires only its existing reviewed `CONNECT`. Runtime/appender must have no effective parameter `SET` privilege for `session_replication_role`, no role/database default changing it away from `origin`, and no `ALTER SYSTEM`, configuration-file or provider-control-plane path that can change session replication behavior. If the existing application requires broader privileges, remediation requires separate impact review; the Audit migration must not silently proceed under that baseline. Because the proposed objects are in the shared `public` schema, the controlled provisioning path may grant the relevant non-login owner temporary schema `CREATE` only inside the reviewed installation transaction; it must revoke that privilege before handoff/commit and retain the grant/revoke evidence.
4. Configure and inspect default privileges separately for every object-creating role. PostgreSQL's default `PUBLIC EXECUTE` for functions is global: use owner-specific `ALTER DEFAULT PRIVILEGES FOR ROLE ... REVOKE EXECUTE ON FUNCTIONS FROM PUBLIC` **without** `IN SCHEMA` for both function-creating owners. Inspect per-schema defaults separately; they may add privileges or reverse a prior per-schema grant but cannot remove the global default. Table/sequence defaults must grant nothing to `PUBLIC`, appender, runtime or reader. Object-level same-transaction revokes remain mandatory for every created function.
5. In the single installation transaction, retain `session_user = af_migrator`, execute `SET ROLE af_schema_owner`, and under the temporary schema-`CREATE` window create the two immutable element-wise array-validation helpers, empty catalog and event tables, constraints, indexes, append-only trigger function, and triggers. Set relation/helper/trigger-function ownership explicitly to `af_schema_owner`; revoke every helper/trigger-function `PUBLIC EXECUTE`. Grant the function owner only exact helper `EXECUTE`. Initial installation and every later helper semantic change must satisfy §6.4.4; `CREATE OR REPLACE FUNCTION` alone never revalidates dependent CHECK constraints. Record `session_user/current_user`, then `RESET ROLE` without committing.
6. Still in that transaction, execute `SET ROLE af_audit_function_owner`, create the exact append function with fixed `pg_catalog, pg_temp` search path, and revoke its default `PUBLIC EXECUTE` before granting anything. Record `session_user/current_user`, `RESET ROLE`, revoke both owners' temporary schema-`CREATE` paths, and do not commit until all handoff assertions pass.
7. Revoke all Audit relation privileges from `PUBLIC`, runtime, appender, and reader. Grant `USAGE` on `public` to the function owner/appender only where it is not already an intentionally reviewed effective privilege. Grant catalog `SELECT` and event `SELECT, INSERT` only to the function owner. Grant exact-signature function `EXECUTE` only to appender.
8. Do **not** grant appender membership to runtime in Empty Slice 1. Verify there is no direct, inherited or `SET ROLE` path from any application principal to appender. A later separately authorized first-producer activation may grant reviewed runtime membership without `SET`, `ADMIN OPTION` or owner paths. No reader membership/grant is installed.
9. Set final owners explicitly. After the installation transaction commits, the provisioning authority revokes both temporary migrator owner-role memberships and verifies failed `SET ROLE` to both owners plus no remaining effective table/function/runtime capability outside the ordinary deployment baseline. The before/during/after role graph and `session_user/current_user` transcript are retained.
10. Inspect normalized PostgreSQL catalogs for `server_encoding`; database/schema/relation/function owners and ACLs; global and per-schema default privileges; all eight table privileges; column/index collations; helper volatility/security/search path/hash; append-function security mode/search path/signature; trigger enablement; constraint validation; role memberships/grant options; every role's special attributes; `pg_parameter_acl`; role/database settings; and replication-related role attributes. A mismatch aborts deployment; it is not repaired by granting runtime ownership or table access.
11. Apply the authoritative UTF-8 lifecycle matrix to the exact load/restore path: preflight an existing `structure.sql`/logical-restore target; inspect the database created by logical restore with `--create`, not its maintenance connection; and inspect a physical restore after isolated startup but before traffic. Then repeat collation, role, privilege and object reconciliation before accepting the database. Incorrect server/client encoding, collation, owner, `PUBLIC`/inherited EXECUTE, runtime table access, missing trigger, or assumable owner is a failed restore/deployment and blocks service return.
12. Retain the approved migration identifier, normalized privilege report, role graph, function-definition hash, trigger/constraint/index inventory, denial-test output, and restoration reconciliation as installation evidence.

Illustrative statements such as `REVOKE CREATE ON SCHEMA public FROM PUBLIC`, global per-owner `ALTER DEFAULT PRIVILEGES FOR ROLE ... REVOKE EXECUTE ON FUNCTIONS FROM PUBLIC`, exact object revokes, and exact-signature function grants must be emitted by the authorized provisioning/migration mechanism appropriate to the environment. They are not asserted to have run merely because they appear in this design.

#### 6.4.4 Mandatory helper version-change and CHECK revalidation

The outcomes helper directly supports `organization_audit_event_catalog_outcomes_nonempty`. The metadata-key helper directly supports `organization_audit_event_catalog_allowed_keys_well_formed` and `organization_audit_event_catalog_required_keys_well_formed`. The required-subset constraint does not call either helper but remains in the release integrity set.

Every helper semantic change is a version-controlled release with reviewed source identity and normalized definition hash. The controlled migration authority, acting through the `af_schema_owner` path, must perform the following inside one database transaction:

1. Quiesce all catalog release writers and acquire `ACCESS EXCLUSIVE` on `public.organization_audit_event_catalog`. Retain the lock through commit or rollback. Runtime has no catalog-write grant, but the lock is still mandatory protection against a concurrent privileged migration.
2. Verify expected old helper hashes, owner, ACL, volatility, search path and the complete dependency set. Unexpected state aborts the transaction.
3. Drop all three directly dependent CHECK constraints without committing or releasing the lock.
4. Replace the helper definition with the reviewed version and verify its new normalized hash.
5. Recreate the three constraints with reviewed expressions as `NOT VALID`, then `VALIDATE CONSTRAINT` each of them under the same helper definition and lock. This is the required forced scan of every existing catalog row; merely observing a previously true `convalidated` flag is insufficient.
6. Inspect all dependent constraint identities/expressions/dependencies, require `convalidated = true`, verify the unchanged subset constraint, and execute a direct zero-violation predicate check over all catalog rows.
7. Record expected and observed hashes, constraint identities and validation states, zero-violation count, release identity and approval. Commit only when every item matches; release quiescence only after commit.

Failure at any step rolls back the helper and constraint changes atomically. A row that violates the new grammar blocks validation and release; it is not grandfathered, deleted, mutated or silently repaired. Resolution requires correcting the proposed helper or a separately authorized forward treatment consistent with immutable registration rules.

Disposable post-authorization evidence must exercise a successful change, a deliberately failing row, a concurrent privileged-writer attempt, rollback restoration, unexpected dependency/hash rejection, and dump/restore. Restore acceptance verifies the reviewed helper hash and performs the same constraint/dependency/zero-violation checks; historical `convalidated` metadata under another helper hash is never sufficient. Runtime, appender, function owner and reader cannot replace helpers or constraints.

#### 6.4.5 Empty-Slice rollback protocol

The authoritative rollback is [PostgreSQL Design §10.2](organization_level_audit_postgresql_design.md#102-rollback). In summary: externally quiesce all invocations; in one transaction acquire `ACCESS EXCLUSIVE` on catalog then events; check both empty only after both locks; abort on any row or unexpected dependency; revoke/drop only reviewed Slice 1 grants and objects in dependency order; preserve roles, unrelated objects and legacy Branch audit; and commit only after exact post-drop inventory. Any error rolls the whole operation back. Disposable post-authorization evidence must include concurrent invocation/privileged writer blocking, nonempty abort, rollback/reapply, structure parity and unrelated-object invariance.

The controlled rollback principal is `af_migrator` with the same temporary `SET TRUE, INHERIT FALSE, ADMIN FALSE` memberships in both owners and the same non-privileged special attributes. Inside the one rollback transaction it uses `SET ROLE af_schema_owner` to acquire locks and perform under-lock emptiness/dependency checks, then `RESET ROLE`; it uses `SET ROLE af_audit_function_owner` to revoke/drop the append function, resets again, then returns to schema owner to drop the four triggers and trigger function, event relation, catalog relation and finally helpers in the reviewed dependency order. It does not commit between role transitions. After the final inventory and commit, provisioning revokes both memberships and proves both owner assumptions fail. Any inability to perform the reviewed sequence atomically blocks rollback rather than broadening ownership.

#### 6.4.6 Negative privilege evidence

| Attempt under tested principal | Expected result | Evidence retained |
|---|---|---|
| Runtime/appender direct catalog or event `SELECT` | Denied | Principal, SQLSTATE, effective privilege snapshot |
| Runtime/appender database `CREATE` or `TEMPORARY`; prohibited principal `CONNECT` | Denied | Database ACL, role graph, principal and SQLSTATE |
| Runtime/appender direct event `INSERT` | Denied | Same; no row |
| Runtime/appender table `UPDATE`, `DELETE`, `TRUNCATE`, `REFERENCES`, `TRIGGER`, or `MAINTAIN` | Denied | `has_table_privilege` for all eight privileges, failed representative statements and unchanged row/table/object inventory |
| Runtime/appender `CREATE DATABASE` or role creation/grant administration | Denied | Role attributes, failed statements and unchanged role/database inventory |
| Runtime/appender `CREATE` in `public` or another searched schema | Denied | Schema ACL and failed statement |
| Runtime/appender sequence access where a future object introduces a sequence | Denied unless an exact reviewed sequence privilege exists; Slice 1 UUID objects use none | Sequence inventory, ACL and failed statement |
| Runtime/appender changes `session_replication_role`, receives parameter `SET`, or uses `ALTER SYSTEM`/equivalent configuration authority | Denied; safe session value remains `origin` | `pg_parameter_acl`, role/database settings, role attributes, control-plane inventory and failed statements |
| Runtime/appender `CREATE OR REPLACE FUNCTION`, owner change, trigger disable/drop | Denied | Function/trigger hash and owner unchanged |
| Runtime/appender `SET ROLE` to schema/function owner or migrator | Denied across direct and nested memberships | Role graph plus failed `SET ROLE` |
| Unapproved role or `PUBLIC` invokes exact function or overload | Denied | Function ACL/default privilege catalog and failed calls |
| Runtime obtains inherited EXECUTE from an unintended role | No effective path | Recursive membership/effective privilege report |
| New object inherits unintended default privileges | No `PUBLIC`/runtime access; future function has no `PUBLIC EXECUTE` under the global owner default | Global and per-schema `pg_default_acl` plus created-fixture ACL inspection for each object-creating owner |
| Migrator retains superuser, role-admin, database-create, replication, RLS-bypass or inherited owner power | Denied; all five special attributes false and owner memberships non-inheriting, SET-only and non-admin | `pg_roles`, recursive membership graph and failed privileged statements before/during/after handoff |
| Migrator after privilege handoff accesses Audit objects or assumes owner | Denied except a newly approved deployment window | Membership-revocation and failed-access evidence |
| Restored database has non-UTF-8 encoding, wrong C collation, owner/grant/trigger/function definition | Reconciliation fails closed; service is not returned | Encoding/collation/catalog restore report, mismatch evidence and corrected re-verification |

These are required future tests, not reported passes.

## 7. Findings remediation register

No finding is marked closed by documentation alone.

| Finding | Design status | Evidence now available | Remaining evidence / blocking point |
|---|---|---|---|
| `AUD-SEC-01` | `DESIGN_REMEDIATED_RE_REVIEW_REQUIRED` | Full typed function and validation/replay branches specified in §4; catalog arrays are element-wise; §6.4.4 forces helper-dependent CHECK recreation/full validation; §3.4 separates pending from committed results; occurrence time is finite. | Focused independent follow-up review before authorization; after authorization, adversarial disposable PostgreSQL tests block implementation acceptance. |
| `AUD-SEC-02` | `DESIGN_RESOLVED_PLAN_REVIEW_REQUIRED` | Separate roles/custody, complete privilege classes and installation sequence in §6. | Provisioning/verification plan blocks authorization; actual disposable ACL evidence blocks implementation acceptance; environment evidence blocks deployment. |
| `AUD-SEC-03` | `OWNER_DECISION_REQUIRED_BEFORE_PRODUCTION_EVENT` | Models A/B/C and residual risks in §5. | `AUD-DEC-11`; does not block empty catalog implementation review. |
| `AUD-SEC-04` | `DESIGN_RESOLVED_IMPLEMENTATION_EVIDENCE_REQUIRED` | Unique identity excludes type/version; cross-type/version mismatch conflicts. | Test plan and design review precede authorization; constraint/concurrency results block implementation acceptance. |
| `AUD-SEC-05` | `DESIGN_REMEDIATED_RE_REVIEW_REQUIRED` | Exact effective-privilege target now covers database, schema, object, default and parameter privileges plus installation/handoff and negative evidence in §6.4. | Focused independent re-review, then authorized disposable effective-privilege tests; production evidence remains a deployment prerequisite. |
| `AUD-SEC-06` | `DESIGN_REMEDIATED_RE_REVIEW_REQUIRED` | Function owner is `NOLOGIN`, non-assumable by runtime, function-only; temporary deployment assumption and revocation are explicit. | Focused independent design review precedes authorization; authorized disposable provisioning/replacement-denial evidence precedes acceptance. |
| `AUD-SEC-07` | `RESIDUAL_PRIVILEGED_COMPONENT_RISK` | Function-owner privilege minimized and output bounded. | Independent assessment; definition/ACL drift monitoring. |
| `AUD-SEC-08` | `DESIGN_RESOLVED_IMPLEMENTATION_EVIDENCE_REQUIRED` | Fixed search path, qualification, typed signature, no dynamic SQL; `AUE01` is reserved for explicit policy denial while native privilege failure remains distinct. | Temp/overload/cast, exact-dispatch and error-source tests. |
| `AUD-SEC-09` | `SHARED_CONTROL_REVIEW_REQUIRED` | DB validates element-wise keys, root/scalars/size; Application owns semantic/secret validation. | Event-specific schemas and prohibited-value tests before catalog entry. |
| `AUD-SEC-10` | `RELEASE_GOVERNANCE_EVIDENCE_REQUIRED` | Catalog is migration-only with Owner provenance. | Reviewed release evidence and catalog drift monitoring. |
| `AUD-SEC-11` | `DESIGN_REMEDIATED_RE_REVIEW_REQUIRED` | Branch is absent from Slice 1 table/catalog columns, FKs, indexes, function, contracts and fixtures. | Static schema/contract checks plus focused independent re-review; separate future Branch design. |
| `AUD-SEC-12` | `OWNER_DECISION_REQUIRED_BEFORE_PRODUCTION_EVENT` | Trusted composition boundary and limitation documented. | `AUD-DEC-11`, adversarial actor/Organization tests. |
| `AUD-SEC-13` | `DESIGN_RESOLVED_IMPLEMENTATION_EVIDENCE_REQUIRED` | `occurred_at` is a finite exact server-side replay fact; client time prohibited; no empty-slice business window is invented. | Producer-specific age/skew/source/delay contract and tests before event activation. |
| `AUD-SEC-14` | `ACCEPTED_INHERENT_LIMITATION` | Owner/superuser/break-glass/restore bypass is explicit. | Operational custody, monitoring, restore rehearsal; never fully closed by DB design. |

### 7.1 Detailed closure evidence

| ID / severity | Attack or failure scenario | Design remediation | Implementation control and negative test | Operational control / evidence to close | Review and gates | Residual risk |
|---|---|---|---|---|---|---|
| `AUD-SEC-01` / `BLOCKER` | Abbreviated validation lets malformed/unapproved evidence append or replay incorrectly. | Exact signature/body, NULL-safe validation, ASCII identifier grammar, equality, errors, and transaction behavior in §4. | After authorization, implement without semantic drift; test every NULL/whitespace/control/catalog/reference/metadata/replay branch, rollback, and safe errors. | Reviewed function hash and drift alert. Evidence: migration, catalog assertions, test output, line review. | Independent design acceptance precedes authorization; passing disposable tests precede implementation acceptance and first append. | PL/pgSQL/design defect may remain until adversarial review. |
| `AUD-SEC-02` / `BLOCKER` | Superuser/shared runtime bypasses every ACL/trigger. | Separated roles/custody and complete privilege inventory in §6. | After authorization, provision disposable distinct roles and prove denial; production roles are provisioned only at the deployment stage. | Secret custody, rotation/revocation, deployment and incident runbooks. | Plan review precedes authorization; disposable evidence precedes implementation acceptance; operational evidence precedes deployment. | Privileged infrastructure still bypasses controls. |
| `AUD-SEC-03` / `HIGH` | Code with function access forges Organization/actor/producer/target values. | Private Audit Application seam; models A/B/C explicit. | No direct adapter/function call outside Audit Infrastructure; interface and adversarial cross-org tests. | Monitor call origins/rates; decide `AUD-DEC-11`. | Independent review required; does not block empty catalog but blocks first append. | Model A trusts uncompromised runtime/composition. |
| `AUD-SEC-04` / `HIGH` | Type/version-expanded uniqueness permits semantic duplicate. | Identity fixed to Organization + Producer + Stable Attempt Key. | Named unique constraint; cross-type/version and concurrency negative tests after authorization. | Stable producer/key lifecycle review. | Design review precedes authorization; passing disposable tests precede implementation acceptance and first append. | Bad key derivation can split one business attempt. |
| `AUD-SEC-05` / `HIGH` | PUBLIC, inherited/default/database/parameter grants or overload EXECUTE permit unauthorized use or replication-trigger bypass. | Exact-signature grant, explicit revokes and complete database/schema/object/default/parameter privilege target. | Effective ACL/membership/default/parameter tests; PUBLIC/overload/direct access/`session_replication_role` denial. | Continuous privilege and configuration drift monitoring. | Design review precedes authorization; disposable tests precede acceptance; production evidence precedes deployment. | Future grant/configuration drift remains possible. |
| `AUD-SEC-06` / `HIGH` | Assumable function owner replaces body with privileged SQL. | Dedicated non-assumable `NOLOGIN` function owner. | Replacement, ownership transfer and `SET ROLE` denial tests after authorization. | Definition hash, membership drift, controlled release. | Design review precedes authorization; disposable denial evidence precedes acceptance and first append. | Provisioning authority can still replace through approved path. |
| `AUD-SEC-07` / `HIGH` | Function-owner compromise abuses its event `SELECT/INSERT`. | Minimal function-only ownership, minimal output, no login/membership. | After authorization, verify no update/delete/truncate/schema/role privilege and run malicious-call surface tests. | Definition/ACL monitoring and incident revocation. | Privilege-bounding design review precedes authorization; evidence precedes acceptance. | Compromised function definition can read/insert within grants. |
| `AUD-SEC-08` / `MEDIUM` | Search path, temp object, overload, cast/operator or dynamic SQL hijacks execution. | Fixed `pg_catalog, pg_temp`; qualified relations; exact typed signature; no dynamic SQL. | Temp relation/type/function, overload, implicit-cast and search-path manipulation tests after authorization. | Definition drift monitoring. | Design review precedes authorization; passing disposable tests precede acceptance. | PostgreSQL upgrade changes require re-review. |
| `AUD-SEC-09` / `MEDIUM` | Structurally valid metadata leaks secrets or misstates semantics. | DB key/scalar/size checks plus Application event schema and prohibited-value rules. | Unknown/missing/nested/null/array/oversize and secret fixture tests; safe logging. | Privacy/security review per event. | Blocks first catalog/append, not empty Slice 1. | Semantic leakage cannot be eliminated by generic DB checks. |
| `AUD-SEC-10` / `MEDIUM` | Compromised migration inserts false catalog approval provenance. | Empty migration-only catalog with decision fields. | Runtime catalog mutation denial; migration fixture and drift tests. | Reviewed release tied to Owner evidence. | Blocks first catalog/append, not empty Slice 1. | Authorized migration authority can still create false rows. |
| `AUD-SEC-11` / `MEDIUM` | A Branch field/FK or indirect identity creates prohibited scope/coupling. | Branch removed from every Slice 1 physical and logical shape. | PostgreSQL catalog, function-source, contract and fixture assertions prove complete absence. | Separate future design/decision. | Design-remediated pending independent re-review; blocks future Branch event. | None if the absence checks hold; future ancestry risk remains. |
| `AUD-SEC-12` / `MEDIUM` | User UUID/Organization claim is invented or cross-tenant. | Trusted Identity composition; explicit database trust limit. | Raw request actor/org rejection, trusted-context construction and cross-org tests. | `AUD-DEC-11` and monitoring. | Independent review required; blocks first append. | Model A cannot independently prove Identity issuance in PostgreSQL. |
| `AUD-SEC-13` / `LOW` | Producer supplies client/backdated/future occurrence time. | Server-side producer clock contract; exact replay fact. | Client timestamp rejection, skew/precision and replay tests. | Event-specific time monitoring. | Blocks first affected event, not empty Slice 1. | Server clock/producer logic can still be wrong. |
| `AUD-SEC-14` / `INFORMATIONAL` | Owner, superuser, break-glass or restore rewrites/removes evidence. | Explicit non-tamper-proof limitation and separated custody. | Demonstrate bypass only in isolated test; verify ordinary roles remain denied. | External privileged-access log, dual review, restore rehearsal/reconciliation. | Operational acceptance required before production; never technically closed. | Privileged bypass is inherent and must remain disclosed. |

Severity is preserved from the original register. “Design resolved” never means closed: implementation, test, independent-review, and where applicable operational evidence remain mandatory.

### 7.2 Independent-review remediation register

The 2026-11-27 independent review added the following local findings. They are remediated in design only and remain open pending focused independent verification; no implementation evidence exists.

| Finding | Independent severity | Design remediation | Required verification | Status |
|---|---|---|---|---|
| `ISR-AUD-001` | `BLOCKER` | Removed every Branch column, FK, catalog mode, function input/insert/comparison, target, index and fixture from Slice 1; added explicit static absence criteria. Existing legacy Branch audit remains separately documented. | Preserve the verified design remediation; search the future migration/function/package/test diff and inspect PostgreSQL catalogs only after implementation is authorized. | `VERIFIED_REMEDIATED` |
| `ISR-AUD-002` | `HIGH` | Outcome validation accepts only a predicate that is exactly true; catalog arrays reject null elements and multidimensional shapes; validation order and all nullable predicates are documented. | Preserve the verified design remediation; after authorization, execute null/unknown/valid outcome, malformed catalog, metadata and no-row/no-replay tests. | `VERIFIED_REMEDIATED` |
| `ISR-AUD-003` | `MEDIUM` | §8.7–8.8 separate pre-authorization plans, post-authorization disposable implementation evidence, first-producer decisions and pre-deployment operational evidence. Empty Slice 1 does not depend on first-event policy or evidence created by unauthorized work. | Round 3 verified this design remediation; preserve it and obtain executable evidence only after authorization. | `VERIFIED_REMEDIATED` |
| `ISR-AUD-004` | `MEDIUM` | §4.2.2 defines typed UUIDs, narrow ASCII machine-code and stable-key grammars, no normalization, matching function/relation/catalog enforcement and exhaustive control/Unicode negative cases. | Round 3 found this partial; Round 4's “most prior controls verified” left only `007/009` partial, establishing design verification of `004`. Preserve it and later execute negative tests. | `VERIFIED_REMEDIATED` |
| `ISR-AUD-005` | `MEDIUM` | §6.3–6.4 covers database `CONNECT/CREATE/TEMPORARY`, schema/object/default privileges, `pg_parameter_acl`, `session_replication_role`, `ALTER SYSTEM`, control-plane authority and staged evidence. | Round 3 verified this design remediation; preserve it, then obtain disposable and environment evidence at their authorized stages. | `VERIFIED_REMEDIATED` |
| `ISR-AUD-006` | `MEDIUM` | §4.2.3 removes caller-supplied failure class, assigns immutable registration authority to Audit Evidence and binds Application registration to the database projection with internal registration identity and release verification. | Round 3 verified this design remediation; preserve it; first-producer registration tests and `AUD-DEC-08` remain later-stage requirements. | `VERIFIED_REMEDIATED` |
| `ISR-AUD-007` | `HIGH` | Catalog arrays are now checked by immutable element-wise helpers using `unnest`; comma-joined serialization is prohibited; canonical dimensionality/lower-bound/null/empty/subset rules and defensive function revalidation are explicit. | Focused SQL-semantics re-review; after authorization, malformed-element, delimiter, lower-bound, NULL, dimensionality and subset tests. | `DESIGN_REMEDIATED_RE_REVIEW_REQUIRED` |
| `ISR-AUD-008` | `MEDIUM` | Explicit registration denial now uses project SQLSTATE `AUE01`; native `42501` and unknown states map to security-control/storage failure, never policy denial. | Focused error-mapping re-review; after authorization, policy-denial and privilege-drift tests at every invocation/object boundary. | `DESIGN_REMEDIATED_RE_REVIEW_REQUIRED` |
| `ISR-AUD-009` | `MEDIUM` | Function dispositions remain transaction-local in `PendingAppendReceipt`; only the known-committed wrapper-opened outer owner may create `CommittedAppendResult`; joined reuse, prohibited nested scopes, rollback and uncertain commit are explicit. | Focused transaction-contract re-review with `ISR-AUD-012`; after authorization, outer/joined commit/rollback, ambient/nested rejection and uncertain-commit tests. | `DESIGN_REMEDIATED_RE_REVIEW_REQUIRED` |
| `ISR-AUD-010` | `LOW` | Finite occurrence time is enforced by Application, function and relation; event-specific age/skew/source policy remains a first-producer prerequisite rather than an invented empty-slice window. | Focused temporal-policy re-review; after authorization, NULL/infinity/finite/extreme/skew/replay tests. | `DESIGN_REMEDIATED_RE_REVIEW_REQUIRED` |
| `ISR-AUD-011` | `MEDIUM` | §6.4.4 now requires one write-quiesced transaction, `ACCESS EXCLUSIVE`, drop/recreate as `NOT VALID`, full `VALIDATE`, catalog inspection, zero-violation evidence and atomic rollback for every helper semantic change. | Focused helper-lifecycle re-review; after authorization, successful/failing/concurrent/rollback/restore tests. | `DESIGN_REMEDIATED_RE_REVIEW_REQUIRED` |
| `ISR-AUD-012` | `MEDIUM` | §3.4 and the logical contract separate internal `PendingAppendReceipt` from outer-owner-only `CommittedAppendResult`; joined scope reuses the outer receipt context, while real nested scopes fail before SQL and produce no receipt. | Focused transaction-contract re-review; after authorization, outer/joined outcomes, ambient/nested rejection, uncertain-commit and publication tests. | `DESIGN_REMEDIATED_RE_REVIEW_REQUIRED` |
| `ISR-AUD-013` | `LOW` | Catalog arrays reject duplicates without normalization; the version-1 binary contract now fixes header/version/algorithm, 21 tagged fields, scalar/array framing, exact SHA-256 bytes, digest display, authority boundary and language-neutral fixture schema. | Focused byte-contract re-review; after authorization, independently generate/check fixture hex/digests and execute duplicate/order/NULL/empty/helper/CHECK/projection/hash/version/drift tests. | `DESIGN_REMEDIATED_RE_REVIEW_REQUIRED` |
| `ISR-AUD-014` | `MEDIUM` | Logical contract requires exact fixed widths, checked length arithmetic, tags `1..21` once/in order, exact array consumption, truncation rejection and no trailing bytes. | External protocol review; later independent decoder vectors and fuzz/property evidence. | `DESIGN_REMEDIATED_EXTERNAL_REVIEW_REQUIRED` |
| `ISR-AUD-015` | `LOW` | `DATE_DAYS` fixes the proleptic-Gregorian algorithm, range `0001-01-01`–`9999-12-31` and accepted count limits. | External protocol review; later boundary/leap/date parity fixtures. | `DESIGN_REMEDIATED_EXTERNAL_REVIEW_REQUIRED` |
| `ISR-AUD-016` | `LOW` | Comparison outcomes now have one deterministic precedence and fixtures for multi-fault inputs. | External protocol review; later cross-language result-parity fixtures. | `DESIGN_REMEDIATED_EXTERNAL_REVIEW_REQUIRED` |
| `ISR-AUD-017` | `MEDIUM` | Exact module is `backend/app/contexts/platform/audit_evidence/`, namespace `Platform::AuditEvidence`, inside the existing strict Platform package with only Application exposed and no Empty-Slice producer dependency. | External architecture review; later Packwerk and custom dependency guards. | `DESIGN_REMEDIATED_EXTERNAL_REVIEW_REQUIRED` |
| `ISR-AUD-018` | `MEDIUM` | All five documents distinguish confirmed `AUD-DEC-01`–`06`, staged `07`–`14`, internal design closure and the still-required external review. | External cross-document status review. | `DESIGN_REMEDIATED_EXTERNAL_REVIEW_REQUIRED` |
| `ISR-AUD-019` | `HIGH` | Stage 1 requires external disposition of every current `ISR-AUD-001`–`042` and `AUD-SEC-01`–`14`, not a selected subset. | External reviewer supplies a complete signed/traceable disposition register. | `DESIGN_REMEDIATED_EXTERNAL_REVIEW_REQUIRED` |
| `ISR-AUD-020` | `MEDIUM` | Rollback now requires quiescence, one transaction, fixed lock order, under-lock emptiness, exact dependency order, unrelated-object preservation and rollback/reapply evidence. | External database review; later concurrency/nonempty/reapply tests. | `DESIGN_REMEDIATED_EXTERNAL_REVIEW_REQUIRED` |
| `ISR-AUD-021` | `MEDIUM` | Empty Slice installs the NOLOGIN appender grant but grants no runtime membership; first-producer activation is separately authorized. | External privilege review; later effective-membership denial evidence. | `DESIGN_REMEDIATED_EXTERNAL_REVIEW_REQUIRED` |
| `ISR-AUD-022` | `LOW` | Acceptance asserts RLS disabled/no policies and exact `pg_proc` security, volatility, parallel, leakproof, owner, ACL, signature/result and configuration facts. | External PostgreSQL review; later normalized catalog evidence. | `DESIGN_REMEDIATED_EXTERNAL_REVIEW_REQUIRED` |
| `ISR-AUD-023` | `MEDIUM` | Historical provenance is reconciled: `001`–`006` are verified remediated in design; later findings retain their explicit review state. | External reviewer confirms provenance and dispositions without treating design verification as executable evidence. | `DESIGN_REMEDIATED_EXTERNAL_REVIEW_REQUIRED` |
| `ISR-AUD-024` | `LOW` | Every scalar and array-element `UTF8_TEXT` rejects U+0000 before projection, matching PostgreSQL `text`/`varchar`; `REGP1-15A/B` covers both shapes. | External protocol review; later cross-language invalid-NUL parity fixtures. | `DESIGN_REMEDIATED_EXTERNAL_REVIEW_REQUIRED` |
| `ISR-AUD-025` | `MEDIUM` | The decision-package header now reflects completed Owner review and the actual next gate: `EXTERNAL_INDEPENDENT_REVIEW_REQUIRED`. | External reviewer confirms all five status headers and terminal verdicts agree. | `DESIGN_REMEDIATED_EXTERNAL_REVIEW_REQUIRED` |
| `ISR-AUD-026` | `LOW` | Branch-removal references now match the authoritative provenance: verified design remediation, while external whole-package review and executable evidence remain outstanding. | External reviewer confirms provenance without converting design verification into implementation evidence. | `DESIGN_REMEDIATED_EXTERNAL_REVIEW_REQUIRED` |
| `ISR-AUD-027` | `MEDIUM` | EXECUTE claims distinguish inherent function-owner authority from the sole non-owner explicit grantee; runtime can assume neither. | External privilege review; later `proowner`/ACL/effective-privilege/membership/failed-invocation evidence. | `DESIGN_REMEDIATED_EXTERNAL_REVIEW_REQUIRED` |
| `ISR-AUD-028` | `MEDIUM` | Installation and rollback identify `af_migrator` as the temporary `SET`-only principal for both owners, prescribe in-transaction role order and revoke/prove both paths absent at handoff. | External database/custody review; later before/during/after role graph, current-user transcript and atomic rollback evidence. | `DESIGN_REMEDIATED_EXTERNAL_REVIEW_REQUIRED` |
| `ISR-AUD-029` | `LOW` | Function catalog assertions include the append-only trigger function and all four trigger bindings/enabled states, in addition to append/helpers/RLS. | External PostgreSQL review; later normalized `pg_proc`/`pg_trigger` evidence and drift-negative test. | `DESIGN_REMEDIATED_EXTERNAL_REVIEW_REQUIRED` |
| `ISR-AUD-030` | `LOW` | Trigger DDL and catalog assertions explicitly require invoker mode, volatile, parallel-unsafe and non-leakproof values rather than relying on unnamed defaults. | External PostgreSQL review; later exact `pg_proc` parity evidence. | `DESIGN_REMEDIATED_EXTERNAL_REVIEW_REQUIRED` |
| `ISR-AUD-031` | `HIGH` | Replay now performs an ordinary post-conflict `SELECT`; the unjustified `FOR SHARE` and its ungranted `UPDATE` requirement are removed. Unique insertion serialization plus append-only rows determine insert/replay/conflict. | Focused PostgreSQL concurrency re-review; later identical/conflicting races, winner rollback and stronger-isolation evidence as exact function owner. | `DESIGN_REMEDIATED_RE_REVIEW_REQUIRED` |
| `ISR-AUD-032` | `HIGH` | Every collatable identity/policy column, array, constraint/index and comparison now uses deterministic `COLLATE "C"`; Application/projection compare exact UTF-8 bytes. | Focused collation re-review; later catalog/index collation inspection and adversarial tests under a nondeterministic database default. | `DESIGN_REMEDIATED_RE_REVIEW_REQUIRED` |
| `ISR-AUD-033` | `MEDIUM` | Global owner default-function revocation is distinguished from per-schema defaults and same-transaction object revocation. | Focused privilege re-review; later `pg_default_acl` plus created-fixture ACL evidence for both function-creating owners. | `DESIGN_REMEDIATED_RE_REVIEW_REQUIRED` |
| `ISR-AUD-034` | `MEDIUM` | Effective privilege targets and negative evidence enumerate all eight PostgreSQL 18 table privileges. | Focused privilege re-review; later direct, PUBLIC, inherited and SET-role `has_table_privilege` plus representative denial tests. | `DESIGN_REMEDIATED_RE_REVIEW_REQUIRED` |
| `ISR-AUD-035` | `MEDIUM` | Migrator attributes are explicitly non-superuser/non-administrative/non-replication/non-RLS-bypass; owner memberships are SET-only, non-inheriting and non-admin. Provider control plane remains a separate bypass. | Focused custody re-review; later before/during/after `pg_roles` and recursive membership evidence. | `DESIGN_REMEDIATED_RE_REVIEW_REQUIRED` |
| `ISR-AUD-036` | `MEDIUM` | The wrapper now holds the lease, proves no ambient transaction, opens the outer boundary itself and alone issues the capability from its yielded transaction object; primary-writing/default-shard remains the only supported baseline. | Narrow read-only re-review plus Rails 8.1.4.1 outer-ownership/identity/atomicity evidence remains mandatory. | `DESIGN_REMEDIATED_RE_REVIEW_REQUIRED` |
| `ISR-AUD-037` | `MEDIUM` | Architecture wording now says callers must not bypass Application; Packwerk/custom guards are static controls and database privileges remain the runtime enforcement. | Focused architecture re-review; later Packwerk and direct/aliased/chained/composition guard tests. | `DESIGN_REMEDIATED_RE_REVIEW_REQUIRED` |
| `ISR-AUD-038` | `MEDIUM` | SQLSTATE comes only from structured PostgreSQL diagnostics; every database error unwinds the failed transaction; only exact states/results receive narrow mappings. | Focused Rails/PostgreSQL re-review; later `AUE01`, `42501`, `23505`, `40001`, `40P01`, missing/malformed result and unknown-state tests. | `DESIGN_REMEDIATED_RE_REVIEW_REQUIRED` |
| `ISR-AUD-039` | `MEDIUM` | Stage-specific gates now bind evidence to a non-reusable attempt, unique invocation and target generation; generation is checked at preflight, completion, pre-promotion and atomic promotion. | Narrow read-only re-review plus lifecycle-specific restore/load/connection evidence remains mandatory. | `DESIGN_REMEDIATED_RE_REVIEW_REQUIRED` |
| `ISR-AUD-040` | `MEDIUM` | The sole outer-issued capability is opaque and non-transferable; joined scopes reuse it, while ambient transactions, nested issuers, real savepoints, restarted parents and every lifetime/identity mismatch fail before Audit SQL. | Narrow Rails API re-review and the complete capability matrix must pass later authorized executable acceptance. | `DESIGN_REMEDIATED_RE_REVIEW_REQUIRED` |
| `ISR-AUD-041` | `HIGH` | Pre-entry parse/resolution/bind/decode/conversion failures are now distinct from the function's first exact-session encoding control. Only a successfully entered function promises `AUE02` on mismatch; both paths forbid success and unwind the whole transaction. | Final narrow read-only verification plus later authorized pre-entry failure, post-checkout client-encoding-change and error-path executable evidence remain mandatory. | `DESIGN_REMEDIATED_RE_REVIEW_REQUIRED` |
| `ISR-AUD-042` | `HIGH` | Restore acceptance now requires non-reusable attempt/invocation identity, exclusive generation ownership, exact evidence scope, aggregate-versus-worker truth and an atomic one-way `QUARANTINED -> ACCEPTED` transition; a separate component owns readiness/traffic enforcement. | Narrow restore/operations re-review and later race/replay/partial/interrupted/parallel/target-replacement executable evidence remain mandatory. | `DESIGN_REMEDIATED_RE_REVIEW_REQUIRED` |

### 7.3 P0 internal adversarial remediation analysis

| Finding | Original defect | Root cause | Corrected design | Attack/failure scenario | Why the correction prevents it | Residual risk | Future executable acceptance tests |
|---|---|---|---|---|---|---|---|
| `ISR-AUD-031` | Replay used `FOR SHARE`, while the function owner had no `UPDATE` privilege. | Defensive locking was added without reconciling privilege requirements or proving the unique-index race model. | Ordinary read after `ON CONFLICT DO NOTHING`; function owner remains `SELECT, INSERT` only. | Identical or conflicting callers race on the same key; the first may commit or roll back. | The unique index makes the loser wait. After winner commit, a new `READ COMMITTED` command snapshot reads the immutable row and returns match or conflict; after winner rollback, only the loser inserts. No pre-commit match is returned. | Stronger isolation can raise `40001`; deadlock can raise `40P01`; whole-transaction retry remains policy-bound. | Two-session identical/conflicting races, winner commit/rollback, repeated retry, `READ COMMITTED`, `REPEATABLE READ`, `SERIALIZABLE`, exact-owner privilege execution and one-row proof. |
| `ISR-AUD-032` | Regex checks used C collation, but storage/index/equality inherited the database default. | The design treated lexical validation as sufficient and did not bind persistence identity to deterministic collation. | Explicit C collation across every collatable policy/identity storage and operation; exact UTF-8 bytes in Application/projection. | A nondeterministic locale equates case or punctuation variants in a unique key, catalog policy or replay comparison. | Column/index/operator C collation gives deterministic byte-oriented comparison and prevents the database default from becoming identity authority. | PostgreSQL upgrades/collation definition drift still require catalog comparison; JSONB metadata equality has separate canonical semantics. | Run in a database whose default is nondeterministic; test case/punctuation variants, array membership/subset, catalog lookup, replay and inspected index/column collation OIDs. |
| `ISR-AUD-033` | “In public” could be implemented as an ineffective per-schema revoke of a global function default. | Global defaults, per-schema defaults and object ACLs were conflated. | Global per-owner function default revoke, separately inspected per-schema defaults, and same-transaction object revoke/grant. | A newly created helper or append function silently receives `PUBLIC EXECUTE`. | The creator's global default prevents inheritance and the immediate object revoke closes the individual creation window; per-schema ACLs are separately checked. | A different creator role or later default-ACL drift can reintroduce access. | Inspect global/per-schema `pg_default_acl`; create disposable functions as each owner; prove no PUBLIC/runtime execute before and after selective grant. |
| `ISR-AUD-034` | The design said `REVOKE ALL`, but evidence enumerated only common DML privileges. | The abstract revoke was not translated into a complete PostgreSQL 18 effective-privilege proof. | All eight PG18 table privileges are explicit for each role and every effective path. | A role retains `TRIGGER`, `REFERENCES` or `MAINTAIN` while common DML checks pass. | Direct, `PUBLIC`, inherited and `SET ROLE` matrices cannot omit a table privilege, so the hidden capability fails acceptance. | Owner/superuser/provider control plane retains acknowledged bypass. | `has_table_privilege` matrix for eight privileges plus failed trigger, FK-reference and representative maintenance operations. |
| `ISR-AUD-035` | Temporary owner-membership cleanup could appear sufficient while migrator retained independent special powers. | Review focused on grants and not the role's own attributes or external provider authority. | Migrator is non-superuser/non-admin/non-database-create/non-replication/non-RLS-bypass; owner membership is SET-only, non-inheriting, non-admin and revoked. | After memberships are revoked, the migrator recreates roles, bypasses RLS or reaches owner-equivalent control through its own attributes. | Exact role attributes remove those PostgreSQL paths, while before/during/after membership evidence proves the temporary owner path is gone. | Hosting provider superuser/control plane cannot be constrained by database role design and remains an operational trust boundary. | Exact `pg_roles`; recursive membership/option report; failed privileged statements before/after; documented separate provider-principal inventory. |
| `ISR-AUD-036` | “Dependency-free Platform” did not define how Active Record records avoid root `ApplicationRecord` or another pool. | The design named layers but not the concrete persistence superclass or proof that the claimed owner opened the outer transaction. | Module-local base plus wrapper-held lease; pre-entry no-active-transaction proof; wrapper-opened boundary; sole capability issued from yielded transaction; no Audit connection lookup/lease. | An ambient transaction is mistaken for a wrapper-owned boundary and Audit writes escape the intended orchestration. | Ambient entry and nested issuance fail; same adapter/raw session and exact yielded/current transaction object/UUID are required before SQL. | Rails behavior/topology remains version-sensitive and requires re-acceptance. | Full capability matrix, pre-entry ambient negatives, atomic commit/rollback and topology tests. |
| `ISR-AUD-037` | “Cannot call” overstated what Packwerk and Ruby conventions enforce. | Static dependency checks were confused with runtime security. | “Must not” architecture rule; Packwerk/custom source guards; database ACL is runtime control. | A caller uses an alias, chain, composition object or dynamic Ruby path to bypass Audit Application. | Detectable direct/aliased/chained/composition forms fail static tests; in Empty Slice, even an undetected dynamic call lacks runtime membership/EXECUTE. | Once a producer receives appender membership, compromised runtime remains Model A residual risk. | Packwerk plus fixtures for absolute, aliased, chained and composition references; runtime denied invocation as actual principal. |
| `ISR-AUD-038` | Error categories lacked structured extraction and a failed-transaction rule. | Framework exception handling did not explicitly preserve PostgreSQL diagnostics or transaction-abort semantics. | Read `PG_DIAG_SQLSTATE`; never parse messages; unwind every database error; retry only the complete transaction for approved states. | Crafted/localized text is misclassified as policy denial, or the adapter queries/logs/retries inside an aborted transaction. | Structured state has narrow mappings and mandatory unwind prevents any further statement or provisional-to-committed promotion in the failed transaction. | Driver/wrapper changes can hide diagnostics and must fail closed; commit-outcome-unknown still requires reconciliation. | Exact-state injections, missing cause/result, malformed function result, unknown state, aborted-transaction proof and full-transaction retry trace. |
| `ISR-AUD-039` | The protocol specified UTF-8, but environment acceptance did not. | Stage checks could still be replayed against a replaced target generation or mixed across attempts. | Stage-specific gates bind exact target/session evidence to one non-reusable attempt, source, generation and invocation; generation is rechecked through atomic promotion. | Wrong/stale generation or encoding passes an unrelated/earlier check. | No stage or attempt substitutes for another; exact-session append assertion remains authoritative and stale evidence cannot promote. | Provider-specific generation/fencing mechanisms remain unresolved and no operating control is claimed. | Full lifecycle, wrong-target/generation, attempt-replay and byte-parity tests. |
| `ISR-AUD-040` | A context could be stale, retried, transferred or issued inside an ambient transaction while specification/pool/connection appeared equal. | Prior design stored transaction-open state but did not prove who opened the outer boundary. | Outer wrapper holds lease, rejects pre-existing transaction, opens the boundary itself and alone issues the capability; joined scopes reuse it and real nested scopes are prohibited. | Prior-attempt or ambient context is reused on the same pooled connection, or nested scope self-issues. | Pre-entry state, issuer identity, object identity, expiry and ordered validation reject use before SQL. | Public Rails APIs do not prove arbitrary savepoint ancestry; caller-owned outer transactions require a separate protocol. | Ambient, nested-issuer, retry, stale, savepoint, cross-thread/fiber, check-in and reconnect tests. |
| `ISR-AUD-041` | Client encoding can change after connection acceptance, while protocol decoding or argument conversion can also fail before the function starts. | Connection/startup/monitor checks were treated as protection for a later exact session, and the earlier wording implied every encoding-related failure would reach the function and raise `AUE02`. | Pre-entry parse/resolution/bind/decode/conversion errors retain their structured native SQLSTATE and fail closed; after successful entry, the function checks exact-session server/client encoding first and raises `AUE02` on mismatch. | Exercise malformed/unconvertible input before entry, then separately execute `SET client_encoding` on an accepted connection with arguments that reach the function. | Neither path yields a receipt/result or permits another statement; the whole transaction unwinds, while only the in-function mismatch is promised as `AUE02`. | Requires exact function implementation, driver diagnostics and error-mapping evidence. | Prove pre-entry failure never masquerades as `AUE02` or success; separately prove post-entry mismatch performs no catalog query/row/receipt and causes whole-transaction unwind. |
| `ISR-AUD-042` | A partial restore or check against a maintenance/unrelated or replaced database could be promoted. | Attempt reuse, concurrent ownership, mixed evidence and promotion replay were not fenced. | Non-reusable attempt/unique invocation, exclusive target-generation ownership, exact evidence scope, truthful aggregate/worker status and atomic one-way promotion. | Superseded attempt regains authority, target changes after reconciliation, or prior success record promotes a replacement. | Any ownership/generation/evidence mismatch keeps the target quarantined; promotion atomically rechecks and consumes authority. | Provider-specific generation/isolation/atomic-transition mechanisms and responsible authorities remain unresolved. | Race/reuse/supersession/target-replacement/mixed-evidence/partial/physical restore tests. |

## 8. Independent security review package

### 8.1 Reviewer evidence set

The reviewer should use this closure plus the four linked audit documents, canonical ADRs, P3 runtime database security design, current Identity trusted-context contracts, current PostgreSQL version baseline, and the future exact migration/test diff. Historical recommendations do not override the 2026-11-27 Owner decisions recorded here.

### 8.2 Mandatory adversarial review questions

1. Can any runtime role access the tables/catalog directly, assume an owner, replace the function, disable triggers, or execute an overload?
2. Does the exact signature eliminate Branch/system spoofing and reject every empty-catalog call?
3. Can two concurrent calls produce more than one row for Organization + Producer + Stable Attempt Key?
4. Does a changed type/version, actor/session, time, target, trace, outcome, or metadata reliably conflict?
5. Can `search_path`, `pg_temp`, implicit cast, operator/function overload, or dynamic object resolution alter behavior?
6. Are errors stable and payload-free, including catalog denial and metadata failure, and are PostgreSQL/Rails/APM bind-parameter logging controls separately verified before any producer?
7. Does function-owner compromise expose more privilege than the documented residual risk?
8. Are migration/structure-load ownership, ACLs, and default privileges reproducible?
9. Can a runtime credential forge actor/Organization evidence under Model A, and is that residual risk acceptable only for the empty catalog?
10. Do backup/restore and break-glass procedures avoid false immutability claims and retain external evidence?

### 8.3 Adversarial and negative-test matrix

| Attack | Expected control | Required negative evidence |
|---|---|---|
| Direct runtime table/catalog access | No grants | All eight PG18 table privileges—`SELECT/INSERT/UPDATE/DELETE/TRUNCATE/REFERENCES/TRIGGER/MAINTAIN`—denied under real runtime role |
| Database/parameter privilege bypass | Runtime has `CONNECT` only; no database `CREATE`/`TEMPORARY`, parameter `SET`, `ALTER SYSTEM` or equivalent control-plane authority | Database create/temp operations, `CREATE DATABASE`, `SET session_replication_role`, parameter grant and configuration changes denied; normalized ACL/settings evidence retained |
| PUBLIC/inherited/overload execution | Explicit revoke; exact signature only | Anonymous/unintended role and overload invocation denied; membership graph inspected |
| Function/trigger replacement or disabling | Runtime lacks ownership/DDL/role assumption | `CREATE OR REPLACE`, owner change, trigger disable/drop, `SET ROLE` denied |
| Schema/temp shadowing and casts | Fixed search path, qualified relations, exact types, no dynamic SQL | Malicious temp objects, caller search path, overloads and cast-shaped calls cannot redirect execution |
| Catalog bypass | Empty catalog and no runtime mutation | Every tuple denied; runtime cannot insert/update/delete catalog |
| Cross-Organization replay | Organization included in unique identity and trusted Application scope | Same producer/key in two Organizations remains separate; forged scope never reaches trusted interface |
| Producer spoofing | Producer selected by reviewed port/composition | Request-supplied/unknown producer rejected; no production producer in Slice 1 |
| Actor spoofing | Trusted Identity context; human-only signature | Raw actor/Organization/session inputs at Presentation rejected; cross-org trusted-context mismatch fails |
| Metadata abuse | Object/key/scalar/size checks plus Application schema | Null/nesting/array/unknown/missing/oversize/secret fixtures rejected without payload echo |
| Identifier/control-character abuse | ASCII allowlist and no normalization at Application/function/constraint/catalog layers | Empty/space/tab/LF/CR/CRLF/VT/FF/DEL/control/Unicode-space/confusable/overlength inputs rejected before row/replay |
| Catalog array serialization abuse | Element-wise immutable helpers plus defensive function revalidation | Single comma/delimiter-bearing element rejected; valid separate elements accepted; empty/null/multidimensional/noncanonical-bound/subset cases match policy |
| Duplicate or reordered catalog array | Application/helper uniqueness plus version-1 canonical binary projection | Duplicate outcome/allowed-key/required-key arrays are rejected before bytes exist; no silent repair occurs; same members in a different order produce different bytes/digests and fail exact release comparison |
| Failure-class downgrade or registry drift | Audit-owned immutable registration; database projection bound by internal registration identity | Producer-supplied/weaker class rejected; missing/extra/mismatched registration aborts activation; used registration cannot be mutated |
| Error-category confusion | Dedicated `AUE01` only for policy denial; native `42501` is security-control failure | Under a disposable post-authorization principal, remove function-owner SELECT/INSERT, schema USAGE and exact EXECUTE separately; each fails closed without becoming `event_not_approved` |
| Ambient/nested transaction confusion | Outer wrapper must prove no active transaction, open the transaction itself and issue the sole capability; real savepoints are prohibited | Ambient transaction and nested issuer fail before Audit SQL; joined scope reuses the outer capability; `requires_new`/`SavepointTransaction`/`RestartParentTransaction` creates no Audit receipt |
| Helper replacement leaves stale CHECK truth | Locked atomic drop/recreate/`VALIDATE` protocol in §6.4.4 | Replacement cannot commit without full-row validation, dependency/hash evidence and zero violations; concurrent privileged write blocks |
| Concurrent replay | Named unique constraint and post-conflict comparison | Matching calls yield one row plus replay; differing calls yield one row plus conflict |
| Locale-dependent identity collision | Explicit deterministic C collation on columns, arrays, indexes and comparisons | Case/punctuation variants remain distinct under a deliberately nondeterministic database default; inspected collation OIDs match |
| Encoding lifecycle mismatch | Stage-specific server/client UTF-8 gates | Non-UTF-8/`SQL_ASCII` creation/migration/load/restore targets and mismatched clients fail; logical restore with/without `--create` inspects the correct target; physical restore remains isolated until acceptance; non-ASCII/normalization-different values round-trip distinctly and malformed bytes/NUL fail consistently |
| Error-message spoofing or aborted-transaction continuation | Structured SQLSTATE and mandatory unwind | Message variants cannot change category; no query executes after `StatementInvalid`; bounded whole-transaction retries only for approved states |
| Restore attempt/generation replay | Non-reusable attempt ID, unique invocation, exclusive target-generation fencing and atomic one-way promotion | Reused/mixed/stale/superseded evidence, concurrent ownership, target replacement and replayed promotion record all keep the target quarantined |
| Privileged restore | Outside ordinary DB enforcement | Restore boundary logged and reconciliation detects/records discontinuity; no absolute-immutability assertion |

#### Authorization evidence matrix

This is a plan, not executed evidence. Each artifact is generated only after bounded implementation authorization.

| Evidence area | Setup | Action | Required result | Retained artifact |
|---|---|---|---|---|
| Canonical projection/parity | Two independent version-1 encoders/decoders and reviewed vectors | Generate/parse all valid, boundary and multi-fault fixtures | Identical bytes/digests/results; strict truncation/order/length/trailing rejection | Tool identities, fixture hex, digests, result ledger |
| Catalog grammar/registration drift | Isolated approved test registration only | Exercise NULL, duplicate, reordered, malformed, unsupported-version and identity/hash mismatch cases | Exact deterministic disposition; no unauthorized row | SQLSTATE/result and row-count transcript |
| Idempotency/concurrency | Two sessions, same and conflicting attempt identities | Race inserts, retry after commit/rollback and reconcile unknown commit | One immutable row; replay or conflict exactly as specified | Session timeline, IDs, SQLSTATE/results |
| Transaction boundary | No active transaction before the wrapper; wrapper-opened outer transaction, joined scope and prohibited real nested scopes | Commit, outer rollback, ambient-entry rejection, joined reuse, nested-issuer rejection, `requires_new`/savepoint/restarted-parent rejection and connection-loss simulations | Only known wrapper-owned outer commit yields committed result; prohibited paths execute no Audit SQL and create no receipt | Lease/transaction trace and durable row query |
| Restore fencing/promotion | Trusted attempt issuer, target-generation fence and quarantined target | Race attempts, reuse/supersession, source/generation/invocation mismatch, target replacement, incomplete aggregate/worker evidence and promotion replay | One active owner per generation; exactly one atomic `QUARANTINED -> ACCEPTED`, or target remains quarantined | Attempt ledger, generation observations, tool artifacts, reconciliation and promotion record |
| Function/error security | Disposable exact roles, deliberate privilege drift and distinct pre-entry/in-function encoding cases | Invoke valid/invalid calls; force parse/resolution/bind/decode/conversion failure before entry; reach the function after client-encoding drift; remove each required grant; try overload/temp/cast paths | Policy denial remains `AUE01`; pre-entry native failure never claims `AUE02` or success; post-entry mismatch is `AUE02`; every security/storage failure unwinds without receipt or later statement | Principal, query, function-entry evidence, SQLSTATE and privilege snapshot |
| Role/object privilege | Provision reviewed role graph with no runtime appender membership | Test direct/inherited/`SET ROLE`, object, schema, database, default and parameter privileges | Function owner retains inherent owner EXECUTE; appender is the sole non-owner explicit grantee; runtime can assume neither and cannot call append or touch objects | Normalized role/ACL/config report, `has_function_privilege` matrix and denial output |
| Function/RLS catalog | Installed empty Slice 1 | Inspect `pg_proc`, `pg_trigger`, relations and `pg_policy` | Append, helpers and trigger function match exact signature/result/owner/ACL/proconfig/security/volatility/parallel/leakproof and definition hashes; four trigger bindings enabled; RLS off and zero policies | Normalized catalog extract and definition hashes |
| Migration/rollback | Fresh isolated PostgreSQL 18.7 database plus unrelated sentinel objects | Up, concurrent/nonempty down attempts, empty down, reapply and structure load | Unsafe down aborts atomically; safe down removes only Slice 1; reapply/structure match | Before/after inventory, lock/session trace and schema diff |
| Helper lifecycle/catalog immutability | Reviewed old/new helpers and deliberate bad row in disposable DB | Replace under protocol; attempt concurrent privileged write and runtime catalog mutation | Bad/concurrent release fails atomically; runtime mutation denied | Helper hashes, constraint validation, zero-violation and denial evidence |
| Fail-closed integration | Authorized test caller with failure injection | Force catalog, function, database and outer-transaction failures | Covered business mutation and evidence do not partially commit; no false success | Integration trace, row counts and result classification |

#### Mandatory argument/catalog NULL and approval cases

Every invalid case below must raise the stated safe category, insert no event, and never return `appended` or `idempotent_replay`.

| Case | Expected category / result |
|---|---|
| SQL `NULL` outcome | `invalid_event`; no row/replay |
| Empty or whitespace-only outcome | `invalid_event`; no row/replay |
| Any machine identifier or Stable Attempt Key with leading/trailing space, ASCII control, Unicode whitespace or non-ASCII confusable | `invalid_event`; no catalog lookup success or replay |
| Unknown outcome against a valid allowlist | `invalid_event`; no row/replay |
| Valid outcome against a valid approved fixture | Continue to remaining validation; success is permitted only in isolated test fixture, never production Slice 1 |
| Allowed-outcome array contains SQL `NULL` or is multidimensional | Catalog constraint rejection; fixture cannot become active |
| Duplicate values in `allowed_outcomes`, `allowed_metadata_keys` or `required_metadata_keys` | Application rejection before projection and PostgreSQL helper/CHECK rejection; no silent deduplication, sorting or row activation |
| Case-different array values | Apply the existing lower-case case-sensitive grammar exactly; invalid case is rejected rather than folded or treated as a duplicate |
| Same valid elements in a different order | Membership/subset result may be unchanged, but positional projection and definition hash differ; release comparison rejects mismatch with the reviewed manifest order |
| Empty metadata-key arrays versus empty outcome array | Canonical empty allowed/required metadata-key arrays remain accepted; empty allowed-outcome array remains rejected |
| SQL `NULL` event type | `invalid_event`; no catalog lookup success or replay |
| SQL `NULL`/nonpositive event version | `invalid_event`; no row/replay |
| SQL `NULL` Organization | `invalid_event`; no tenant existence disclosure |
| SQL `NULL`/unknown registration UUID or NULL/mismatched internal failure class | `invalid_event` for NULL; otherwise `event_not_approved`; no row/replay |
| SQL `NULL`/blank producer | `invalid_event`; no row/replay |
| SQL `NULL`/blank stable attempt key | `invalid_event`; no row/replay |
| Malformed metadata root, nested/array/null value, unknown/missing key, or excessive size | `invalid_event`; payload omitted from error/log |
| Catalog element `valid_one,valid_two`, another delimiter-bearing element, empty element, SQL NULL element, multidimensional array or non-1 lower bound | Catalog constraint rejection and function defensive rejection; no row/replay |
| Separate valid elements `valid_one`, `valid_two` | Accepted by element grammar; still subject to event-specific approval and subset rules |
| Required metadata key absent from allowed keys | Catalog constraint rejection and defensive function rejection |
| SQL `NULL`, positive infinity or negative infinity occurrence time | `invalid_event`; no row/replay |
| Ordinary or extreme finite occurrence time in empty foundation fixture | Passes generic finite invariant; a producer still cannot activate without an approved age/skew/source policy |
| Missing catalog tuple | `event_not_approved`; indistinguishable tuple detail |
| Inactive tuple | No active flag exists in Slice 1; an inactive tuple is absent and receives the same `event_not_approved` result |
| Unapproved tuple | Absent from migration-owned catalog; same `event_not_approved` result |

### 8.4 Transaction and failure matrix

| Situation | Database behavior | Application behavior | Evidence claim |
|---|---|---|---|
| Valid first append in wrapper-opened outer transaction | The wrapper proved no active transaction, opened the outer transaction and supplied its yielded transaction object/capability | Function may return `inserted_in_current_transaction`; Audit returns `PendingAppendReceipt` | `CommittedAppendResult(appended)` only after that outer owner knows commit succeeded |
| Ambient transaction exists before wrapper entry | No Audit SQL executes; wrapper must not join or infer ownership | `audit_transaction_context_mismatch`; no capability/receipt/fallback | No event or committed result |
| Function insert followed by transaction rollback | Event insert rolls back with business writes | Discard `PendingAppendReceipt`; no producer-visible success | No durable event |
| Joined scope followed by outer rollback | Joined service reuses the sole outer-issued capability and same transaction object; outer rollback removes event | Joined return is not commit; discard outer receipt | No durable event |
| Joined scope followed by outer commit | Joined service reuses the sole outer-issued capability; event becomes durable only at outer commit | Outer owner finalizes receipt once after known commit | `CommittedAppendResult(appended or idempotent_replay)` |
| Nested issuer in an otherwise joined scope | No Audit SQL executes; only the outer wrapper may issue a capability | Reject second capability issuance before append | No receipt or event |
| `requires_new`, `SavepointTransaction` or real savepoint | No Audit SQL executes because the current transaction object/UUID differs | `audit_transaction_context_mismatch`; no savepoint-local receipt and no fallback | No Audit result from the nested scope |
| `RestartParentTransaction` or replaced/restarted parent | No Audit SQL executes; prior capability is invalid | Fail closed; replacement/retry requires a new wrapper invocation after a fresh precondition check | No receipt or inferred continuation |
| Catalog/validation denial | Function raises before insert | Map safe category; apply approved event failure class | No event |
| Matching retry after committed append | Unique conflict/read original | Function returns `matched_existing_in_current_snapshot`; finalize after current outer transaction commits | Original event only; Application may then report `idempotent_replay` |
| Conflicting retry | Unique conflict/read/compare then `23505` | Fail closed and reconcile; never auto-new-key | Original event only; conflict is not success |
| Two concurrent first matching calls | One insert wins; other waits then matches | One append result, one replay result | One row |
| Two concurrent first conflicting calls | One insert wins; other waits then conflicts | Conflict caller receives safe failure | One row; winner not overwritten |
| Serialization/deadlock | PostgreSQL `40001`/`40P01` | Bounded whole-transaction retry if separately approved | No inferred append result |
| Known rollback then retry | Original insert is absent | Retry same identity; may insert in the new current transaction | No replacement key or false replay claim |
| Connection failure around commit | Commit state may be unknown | Return unknown/reconciliation result; lookup/retry only with same identity | Reconcile to insert/match/conflict; never infer success |
| Process terminates after commit but before publication | Event may be durable while response/effect is absent | Retry/reconcile with same identity; do not generate replacement key | Matching event may become committed replay after a later known commit |
| Fail-open event class | Not available until exact event approval | Must be cataloged and independently reviewed | Not part of empty Slice 1 |

### 8.5 Metadata/privacy and deployment boundaries

The database validates only structure: JSON object, approved/required keys, scalar primitive values, and catalog byte limit. Audit Application owns event-specific types, semantic relationships, minimization, and prohibitions on passwords, PINs, tokens, MFA/recovery data, payment credentials, request bodies/headers, exception dumps, raw personal data, and unrestricted reasons. Application-generated errors omit payloads. That does **not** prove payload-free PostgreSQL, Rails or APM logs: before any producer, parameter capture must be disabled or safely bounded for this path, log access/retention must be approved, and a canary-secret rejection must verify every configured sink. Retention, reader, export, correction, hold, anonymization, and deletion remain undecided.

Deployment assumes PostgreSQL 18.x compatibility, separately provisioned roles, a controlled migration identity, reproducible `structure.sql`, and a production-parity disposable privilege test. None is verified by current superuser-based ordinary CI. Exact credentials, custodians, secret manager, rotation interval, break-glass approvers, monitoring system, and restore runbook remain operational evidence to be supplied without inventing appointments here.

### 8.6 Explicit non-goals and residual risks

- no production event/catalog row, producer migration, Branch support, system actor, reader, export, retention, legal hold, correction, anonymization, frontend, or public API;
- no proof that PostgreSQL can authenticate an in-process Identity object;
- no absolute immutability, tamper-proof, legal compliance, or production-readiness claim;
- no global order or atomicity between existing Branch audit evidence and the new Organization store;
- no mitigation of a malicious schema owner, superuser, controlled break-glass actor, restore operator, or compromised approved migration beyond custody, monitoring, and reconciliation; and
- no acceptance of Model A for production until `AUD-DEC-11` is decided.

### 8.7 Staged verification evidence

Before implementation authorization, the Owner receives a complete design, focused independent review, exact proposed diff scope, disposable PostgreSQL 18.7 test plan, privilege-verification plan, migration/rollback/restore plan and explicit proof-by-scope that no catalog row or producer is proposed. Executed migration, function and role tests are not required before authority to create that implementation; claiming otherwise would make authorization depend on unauthorized work.

After bounded implementation authorization and before implementation acceptance, the authorized change must generate disposable-environment evidence for:

- actual fixture-role creation, installation handoff and post-handoff denial;
- database/schema/table/sequence/function/default/parameter ACLs and effective membership;
- empty-catalog denial and no-row proof;
- every NULL, identifier/control-character, catalog-array-element, duplicate/order and finite-time validation branch plus version-1 field framing, projection bytes, SHA-256 digest, unsupported-version and drift comparison; fixture hex/digests require two independent reproductions;
- matching, conflicting, cross-type/version, registration-mismatch and concurrent replay;
- direct table/catalog/trigger/function replacement and `session_replication_role` denial;
- `PUBLIC`, inherited role, default privilege, overload, temp-object, `SET ROLE` and `ALTER SYSTEM` denial;
- wrapper-held lease, pre-entry ambient rejection, wrapper-opened outer commit/rollback, joined capability reuse, nested-issuer and real-savepoint/restarted-parent rejection before SQL, uncertain-commit reconciliation and stronger-isolation behavior;
- restore attempt-ID reuse/race/supersession, target-generation replacement, mixed/duplicated evidence, aggregate-versus-exposed-worker status, and atomic promotion replay rejection;
- migration up/down on empty tables, structure-load parity and normalized catalog assertions; and
- existing Branch audit regression.

This disposable evidence is implementation acceptance evidence, not production provisioning evidence. Before production deployment, environment-specific principals, credentials, owners, ACLs, parameter privileges, monitoring, incident response and backup/restore reconciliation require separate operational verification and approval. No such implementation or production evidence was generated in this documentation-only task.

### 8.8 Authoritative prerequisite matrix

This matrix supersedes stage-ambiguous prerequisite wording in the other four Audit research documents. “Satisfied” means design input exists, not that implementation, operational evidence, or authorization exists.

| Stage | Prerequisite | Status | Evidence required | Responsible approval | Blocking scope |
|---|---|---|---|---|---|
| 1 — Before empty-Slice implementation authorization | `AUD-DEC-01`–`06` preserved; complete Branch-free/NULL-safe/exact-collation/UTF-8/element-grammar/duplicate-free ordered-registration/privilege/error/transaction/finite-time/helper-lifecycle design; exact `Platform::AuditEvidence` module/migration/function/role/test diff scope; no runtime appender membership; disposable test, rollback and recovery plans; explicit no-producer scope | `EXTERNAL_INDEPENDENT_REVIEW_REQUIRED` | Corrected five-document package and external independent disposition of every `ISR-AUD-001`–`042` and `AUD-SEC-01`–`14`; plans only, not unauthorized test output | External independent reviewer, then Owner for bounded implementation authority | Slice 1 implementation authorization |
| 2 — After authorization, before implementation acceptance | Implement only the authorized empty package/store/catalog/function/roles/tests; no event, producer, Branch, system actor, reader or production data | `OWNER_AUTHORIZATION_REQUIRED_THEN_EVIDENCE_PENDING` | Disposable PostgreSQL role installation/handoff, effective ACL/parameter tests, identifier/NULL/replay/concurrency/transaction tests, migration up/down, structure-load parity and legacy Branch regression | Owner-defined implementation acceptance plus independent security review | Slice 1 implementation acceptance |
| 3 — Before first human producer | Exact producer/event/version and immutable registration; failure class, Session evidence and metadata schema/limit (`AUD-DEC-07`–`10`); trust model (`AUD-DEC-11`); finite-time source, acceptable past age/future skew and delayed/replay policy; trusted actor/Organization derivation; privacy/security review and producer activation scope | `OWNER_DECISION_AND_QUALIFIED_REVIEW_REQUIRED` | Decision provenance, one-to-one Application/catalog registration evidence, temporal-policy evidence, adversarial scope/privacy tests and separately accepted producer implementation | Owner plus qualified Security/Privacy input and independent reviewer | First catalog row and production human append |
| 4 — Before system producer | System remains disabled; exact producer identity, invocation evidence, credential/key custody, rotation/revocation, accountable operations owner, retry/failure semantics and trust model | `OWNER_DECISION_REQUIRED` | Separate Owner decision, provenance/custody design and independent security review | Owner plus qualified Security/Operations input | Any system event |
| 5 — Before reader/export/retention | Reader/search scope (`AUD-DEC-12`), export approval/custody (`AUD-DEC-13`), retention/hold/correction/anonymization/backup expiry (`AUD-DEC-14`) | `DEFERRED` | Qualified Security/Privacy/Legal/Accounting-records input and Owner decisions | Owner after applicable qualified reviews | Reader/export/production-data governance; not empty Slice 1 |
| 6 — Before production deployment | Actual environment principals, role provisioning, credential custody, effective database/schema/object/default/parameter privileges, approved migration process, monitoring, drift alerts, incident/break-glass and backup/restore reconciliation | `PENDING_OPERATIONAL_EVIDENCE` | Environment-specific normalized ACL/role/parameter report, runbooks, denial tests, restore rehearsal and independent operational review | Authorized deployment authority and Owner; no authority created here | Production deployment |

No Stage 3–5 decision is a prerequisite to authorizing or implementing the empty Stage 2 infrastructure. Stage 1 requires plans and review, not evidence generated by unauthorized implementation. Stage 2 disposable evidence does not authorize a producer or production deployment.

## 9. Slice 1 authorization gate

The Owner-confirmed design is **not** implementation authorization. A future authorization must name only the empty infrastructure slice and must require all of the following:

1. external independent security/architecture review accepts, rejects or explicitly conditions every `ISR-AUD-001` through `ISR-AUD-042` and `AUD-SEC-01` through `AUD-SEC-14`;
2. exact role provisioning/custody and production-parity verification plan are approved;
3. migration, function, constraints, grants, tests, and rollback are reviewed as one change;
4. the catalog remains empty and no production producer/writer is wired;
5. no reader, export, retention, hold, correction, system actor, Branch support, or legacy migration is added; and
6. no Gate, FOA, deployment, or Production Authorization is inferred.

Before the first production event, `AUD-DEC-07` through `AUD-DEC-11`, event-specific privacy/security input, exact catalog schema/failure class, and a separate producer activation authorization are mandatory. Before production personal/security evidence, qualified legal/privacy and operational review cannot be deferred.

## 10. Consistency and unresolved points

| Topic | Current status |
|---|---|
| Owner decisions `AUD-DEC-01`–`06` | Confirmed and synchronized; no ODB allocation. |
| Empty catalog/no producer | Preserved. |
| Idempotency | Synchronized to Organization + Producer + Stable Attempt Key. |
| Branch | Forbidden and absent from every Slice 1 logical/physical shape; existing legacy Branch audit remains separate. |
| Actor | Human shape only; system disabled. |
| Function | Full review specification supplied; low-level results remain provisional until outer commit; no implementation exists. |
| Application result boundary | Embedded append returns only `PendingAppendReceipt`; only the outermost owner may create `CommittedAppendResult` after known commit. Unknown durability remains reconciliation-required. |
| Identifier/catalog grammar | Explicit ASCII/no-normalization policy and element-wise Application/function/relation/catalog enforcement specified; follow-up review and later tests required. |
| Catalog-array duplicate/order semantics | Exact duplicates are invalid in Application and PostgreSQL; no normalization or reordering occurs; one reviewed stable order is encoded by the exact version-1 binary contract and SHA-256 comparison; subset semantics are unchanged. Fixture bytes/digests remain pending. |
| Replay concurrency/least privilege | Ordinary read after unique-conflict serialization; no row lock or `UPDATE`; identical/conflicting/winner-rollback and stronger-isolation behavior specified, pending re-review/tests. |
| Exact comparison and encoding | All collatable identity/policy storage/index/operations use deterministic C collation; exact UTF-8 Application/projection semantics; stage-specific gates; native fail-closed errors for pre-entry parse/resolution/bind/decode/conversion failures; and `AUE02` only when a successfully entered function's first exact-session guard detects mismatch. No earlier/representative check substitutes for the executing session. |
| Privilege/custody completeness | Global/per-schema/object function ACL layers, all eight PG18 table privileges, migrator special attributes and provider-control-plane residual boundary are explicit. |
| Rails/module enforcement | Module-local `ActiveRecord::Base` persistence does not prove atomicity. The outer wrapper holds one lease, rejects an ambient transaction, opens the boundary itself and alone issues the capability from its yielded transaction object. Joined scopes reuse it; nested issuers, real savepoints/restarted parents, retries, stale or transferred contexts fail before SQL. Packwerk/source guards remain static and database ACLs remain runtime enforcement. |
| Restore/monitor enforcement | A non-reusable attempt and unique invocation own one fenced target generation; evidence is scoped to that attempt/source/generation/invocation; generation is rechecked through one atomic `QUARANTINED -> ACCEPTED` transition. A read-only monitor reports only, while a separately selected enforcement component controls readiness/traffic. Provider-specific fencing/atomicity mechanisms remain unresolved. |
| Helper lifecycle | Semantic changes require locked atomic constraint recreation and forced full validation; prior validation metadata alone is insufficient. |
| Error classification | `AUE01` is the sole registration-denial state. A native parse/resolution/bind/decode/conversion failure before function entry is not guaranteed to be `AUE02`; after successful entry, `AUE02` is the exact-session encoding-guard failure. Both paths, native `42501` and unknown states fail as security-control/storage errors; structured SQLSTATE and complete failed-transaction unwind without receipt, later statement, alternate-connection fallback or partial continuation are mandatory. |
| Occurrence time | Generic finite invariant is specified; event-specific age/skew/source/delay policy remains a first-producer prerequisite. |
| Role separation | Database/schema/object/default/parameter privilege design complete; disposable and production evidence remain stage-specific. |
| Failure class | Audit-owned immutable registration is authoritative; producer request cannot supply it; Application/catalog projection binding specified. |
| First event, failure class, actor/session, metadata, trust model | `AUD-DEC-07`–`11` remain open. |
| Read/export/retention/hold/correction | `AUD-DEC-12`–`14` remain deferred and unimplemented. |
| Absolute immutability/compliance | Explicitly not claimed. |

## 11. Validation scope

Only documentation-aware, non-mutating validation is authorized: Markdown structure, links/anchors, cross-document decision/reference consistency, prohibited stale idempotency claims, and `git diff --check`. Application tests, PostgreSQL commands, migrations, services, builds, and security tests are outside this task.

## Final status

`ORGANIZATION_AUDIT_EMPTY_SLICE_1_IMPLEMENTATION_AUTHORIZATION_READINESS_REPORT`

`EXTERNAL_REVIEW_NOT_YET_PERFORMED`

Documentation remediation now covers `ISR-AUD-036`, `ISR-AUD-039` and new `ISR-AUD-040`–`042`: wrapper-owned capability issuance, ambient/nested rejection, no-savepoint append, the pre-entry native-error versus in-function `AUE02` boundary, restore attempt/generation fencing and atomic promotion are specified. `ISR-AUD-036/041` remain `DESIGN_REMEDIATED_RE_REVIEW_REQUIRED` pending final narrow read-only verification; `ISR-AUD-039/040/042` retain their design-level verification from the latest narrow review, and all five still require their authorized executable evidence. This work does not substitute for an external independent reviewer. Expected fixture bytes/digests, Rails/PostgreSQL parity and all operational evidence remain pending their authorized stages. The package grants no implementation, producer, runtime appender membership, deployment or production authority.
