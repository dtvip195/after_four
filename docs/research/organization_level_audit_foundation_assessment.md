# AFTER FOUR — Organization-Level Audit Foundation Assessment

**Assessment date:** 2026-11-26

**Verdict:** `EXTERNAL_INDEPENDENT_REVIEW_REQUIRED`

**Current external-review lifecycle:** `EXTERNAL_REVIEW_NOT_YET_PERFORMED`

**Scope:** Read-only architecture and security assessment. This record does not authorize schema, migration, runtime, API, capability, deployment, Gate, FOA, or Production changes.

> **Current-status note — 2026-11-27.** This assessment predates Owner decisions `AUD-DEC-01`–`06` and the later independent-review remediation rounds. Its comparison of one-store/optional-Branch alternatives is historical analysis, not the current Slice 1 contract. The current Organization-level Slice 1 is a separate empty store with no Branch column, FK, target, validation path, catalog mode, fixture or indirect identity. Existing legacy Branch audit remains unchanged. Round 3 preserves verified `ISR-AUD-001`–`003` and `005/006`, and remediates `ISR-AUD-004` plus `007`–`010` in design pending focused follow-up review. The authoritative function, element-wise catalog grammar, safe error mapping, provisional/committed result boundary, finite-time rule, privilege installation, findings and staged prerequisites are in [Organization-Level Audit Security Design Closure](organization_level_audit_security_design_closure.md).

> **Security remediation round 4 — 2026-11-27.** The current closure supersedes this assessment's abbreviated helper and transaction language for `ISR-AUD-011/012`: helper semantic changes require one write-quiesced atomic release that recreates and fully validates every dependent CHECK, while an embedded append returns only `PendingAppendReceipt`; only the outermost transaction owner may create `CommittedAppendResult` after known commit. Both corrections await focused independent re-review.

> **ISR-AUD-013 remediation — 2026-11-27.** Catalog arrays that represent logical sets reject duplicate elements in both Application validation and PostgreSQL helpers. Comparison is exact and case-sensitive; persistence never trims, folds, deduplicates, sorts or reorders. The reviewed registration manifest fixes one explicit array order, and projection/release hashing compares that ordered representation positionally. This design remediation remains open pending independent review.

> **ISR-AUD-013 remediation round 2 — 2026-11-27.** The logical contract now defines one language-neutral version-1 binary registration projection and exact SHA-256 contract rather than permitting Application, PostgreSQL inspection or release tooling to invent serialization. Audit Evidence remains registration authority; fixture bytes/digests and executable parity remain pending focused review and separately authorized implementation evidence.

> **Authorization-readiness consolidation — 2026-11-27.** Internal parallel protocol, PostgreSQL-security and architecture reviews added `ISR-AUD-014`–`023`; re-review added `ISR-AUD-024`–`030`. The current five-document package closes their documentation findings by defining strict decoder closure, date/comparison/NUL semantics; the exact `Platform::AuditEvidence` module boundary; concurrency-safe rollback and owner assumption; Empty-Slice privilege staging with no runtime appender membership; complete RLS/function/trigger catalog assertions; consistent status/provenance; and a prerequisite that disposes every `ISR-AUD-*` and `AUD-SEC-*` finding. These internal perspectives are not the required external independent review and create no authorization.

> **P0 internal-review remediation — 2026-11-27.** Later zero-cost adversarial review added `ISR-AUD-031`–`039`. The current package design-remediates replay locking/least privilege, deterministic C-collation identity, global default function privileges, all eight PostgreSQL 18 table privileges, migrator attributes, the module-local shared-pool persistence base, static-versus-runtime enforcement claims, structured SQLSTATE/transaction unwind and UTF-8 installation/load/restore acceptance. These findings remain `DESIGN_REMEDIATED_RE_REVIEW_REQUIRED`; this historical assessment is not executable evidence.

> **Final design clarification — 2026-11-27.** Focused re-review found `ISR-AUD-036` and `ISR-AUD-039` only partially remediated. The synchronized package now distinguishes connection specification, pool, checked-out raw connection and database transaction; fails closed on any mismatch; and assigns separate UTF-8 server/client checks to creation, migration, structure load, logical/physical restore, connection establishment, startup and monitoring. Both findings remain open for later authorized executable acceptance evidence.

> **ISR-AUD-036/039/040/041/042 design remediation — 2026-11-27.** The canonical closure requires the outer wrapper to hold the lease, reject ambient transactions, open the outer transaction itself and alone issue the capability; joined scopes reuse it while real savepoints and nested issuers fail closed. Restore acceptance adds a non-reusable attempt, unique invocation, exclusive target-generation ownership and atomic `QUARANTINED -> ACCEPTED` promotion. The subsequent narrow review verified `ISR-AUD-039/040/042` at design level and returned `ISR-AUD-036/041` for the final micro-remediation recorded below; all five still require later authorized executable evidence.

> **Final micro-remediation — 2026-11-27.** The canonical transaction seam is now described only as wrapper-owned participation: the designated outer wrapper proves its adapter is idle, opens and owns the supported boundary, and issues the sole capability; joined inner services may reuse it, while pre-existing ambient or arbitrary caller-owned transactions remain unsupported absent a separately approved protocol. PostgreSQL pre-entry parse/resolution/bind/decode/conversion failures are distinct from the first in-function exact-session encoding guard; only the latter promises `AUE02`, while both paths fail closed and unwind. `ISR-AUD-036/041` remain pending final narrow read-only verification and later executable evidence.

## 1. Verified repository baseline

| Item | Verified value |
|---|---|
| Branch | `development` |
| HEAD | `b49a8827be53797b30ea1d7cb47791e7c74e7231` |
| Upstream | `origin/development` |
| Upstream delta | `+0 / -0` |
| Working tree before assessment | Clean |

The merged Workforce Employee Foundation exists at this baseline. Its migration creates only an Organization-scoped Employee identity, optimistic-lock field, timestamps, Organization FK, index, and lock-version check; it does not create a production Employee workflow or audit integration ([migration](../../backend/db/migrate/20261126120000_create_workforce_employee_foundation.rb)).

## 2. Actual existing audit architecture and schema

The implemented `audit_events` table is a Branch-only record. It requires `branch_id`; stores actor type and optional actor UUID, event/subject identifiers, idempotency key, optional request ID, JSON metadata, occurrence time, and creation time; and has a subject/time index plus a Branch/idempotency unique index ([foundation migration, lines 74–93](../../backend/db/migrate/20261114192000_create_order_payment_foundation.rb#L74)). It has no `organization_id`, event version, explicit outcome, causation identifier, or separately named persistence timestamp. Fabricating a Branch for an Organization-only event would create false evidence and is not acceptable.

The actor check permits only `user` with a non-null actor UUID or `system` with a null actor UUID. This avoids a fabricated human for current system events, but the schema cannot prove how a user UUID was obtained or identify the producing system process ([foundation migration, lines 91–93](../../backend/db/migrate/20261114192000_create_order_payment_foundation.rb#L91)).

The only production writers found are context-specific adapters in Orders, Payments, and Preparation. Each context owns a narrow Application audit port, but each Infrastructure adapter directly invokes the root `AuditEvent` Active Record model:

- Orders writes order creation, confirmation, hold, and payment-window expiry ([adapter](../../backend/app/contexts/orders/infrastructure/adapters/active_record_audit_log.rb)).
- Payments writes amount mismatch and confirmation/late-success evidence ([adapter](../../backend/app/contexts/payments/infrastructure/adapters/active_record_audit_log.rb)).
- Preparation writes and queries dispatch/retry evidence ([adapter](../../backend/app/contexts/preparation/infrastructure/adapters/active_record_audit_log.rb)).

This is a known architecture seam, not a suitable ownership model to copy into Identity, Workforce, or Organization. The strict Packwerk packages currently depend on the root package, which is where `AuditEvent` lives; there is no dedicated audit package ([package manifests](../../backend/app/contexts)). No general production audit reader, search endpoint, export path, controller, or policy was found. Preparation's existence query is workflow idempotency evidence, not human audit access.

Identity now produces a privately issued `TrustedAuthorizationContext` from a verified `AuthenticatedActor`, containing User, Organization, and Session identifiers; client actor/Organization assertions do not construct it ([trusted context](../../backend/app/contexts/identity/application/contracts/trusted_authorization_context.rb), [authentication concern](../../backend/app/controllers/concerns/identity_session_authentication.rb)). Current Orders/Payments/Preparation audit ports instead receive a raw `actor_id`; their audit rows do not prove derivation from that trusted Identity contract.

## 3. Existing append-only protections and limits

| Layer | Implemented protection | Proven limit |
|---|---|---|
| Application | `AuditEvent` aborts ordinary update and destroy callbacks ([model](../../backend/app/models/audit_event.rb)). | Bulk SQL and privileged code bypass callbacks. There is no controlled append-only repository interface at the root. |
| Database | A `BEFORE UPDATE OR DELETE` trigger raises SQLSTATE `23514` ([migration](../../backend/db/migrate/20261114203000_protect_audit_events_append_only.rb)). Tests cover instance, bulk, and direct-SQL update/delete rejection, insert/select, and transaction rollback ([spec](../../backend/spec/integration/audit_event_database_protection_spec.rb)). | The trigger does not cover `TRUNCATE`. No production runtime grants, owner separation, or negative privilege evidence exists. |
| Privileged administration | None claimed. | Test cleanup deliberately disables the trigger as database owner and deletes rows, demonstrating the owner bypass ([cleanup helper](../../backend/spec/support/audit_event_cleanup.rb)). A table owner or superuser can alter/drop/disable enforcement, change ownership, truncate, or rewrite through restore. |
| Transaction | Current audited success writes share `ApplicationRecord.transaction` with the covered business changes. Failure-injection tests demonstrate rollback for existing Ordering/Payment/Preparation workflows ([ordering failure evidence](../../backend/spec/integration/ordering_transaction_failure_evidence_spec.rb), [Preparation recovery spec](../../backend/spec/domains/preparation/infrastructure/transaction_recovery_spec.rb)). | Coverage is limited to current event families. A rolled-back transaction cannot also preserve a durable rejection/failure event in that same transaction. |

Therefore the current behavior is append-only for ordinary application operations and trigger-protected against ordinary row update/delete. It is not absolute immutability, role-enforced production append-only, tamper evidence against a privileged administrator, or a complete audit operating control. The canonical integrity rules state the same limitation ([Data Integrity Rules §15](../architecture/after_four_data_integrity_rules.md#15-audit-approval-and-retention-requirements)).

## 4. Recommended ownership and dependency direction

The smallest coherent target is a dedicated **Audit Evidence module/package**, not a generic shared kernel and not Organization-owned persistence:

| Responsibility | Recommended owner |
|---|---|
| Decide that a domain event occurred, its domain meaning, safe event type, target, outcome, and domain-safe metadata | Producing context: Identity, Workforce, Organization, Orders, Payments, Preparation, and later contexts |
| Organization identity and ancestry facts for the new Slice 1 | Organization context, exposed through narrow Application contracts; Audit must not query Organization Infrastructure. Existing legacy Branch evidence remains outside this contract. |
| Trusted human actor/session derivation | Identity context; composition passes server-derived evidence, never request-supplied actor UUIDs |
| Envelope validation, append/idempotency contract, persistence mapping, append-only database controls | Audit Evidence module |
| Search/read/export/hold interfaces | Audit Evidence Application boundary, separately authorized through Identity policy; no general root-model access |
| Reporting projections | Reporting as a consumer of an approved audit read/projection contract, not owner of authoritative evidence |

Dependency direction should be:

`Presentation → producing Application use case → producing domain decision → producing audit port → composition adapter → Audit Evidence Application append contract → Audit Infrastructure`.

Audit Evidence must not call producer Infrastructure or infer business events from tables. For the new Slice 1 it treats Organization, actor, target, correlation, and causation references as validated opaque references; Branch is not part of the contract. Where Organization ancestry must be checked, composition should supply Organization-owned Application evidence without exposing records. Audit must not become a shared Domain model imported everywhere; only narrow Application contracts cross the seam.

Creating a new package and choosing whether it is a bounded context or a platform evidence module is an architecture decision requiring Owner acceptance. Until then, no fourth direct writer to the root `AuditEvent` model should be added.

## 5. One store versus separate Organization and Branch stores

| Option | Benefits | Costs/risks |
|---|---|---|
| One physical store with required Organization and optional Branch | One integrity policy, one event identity/idempotency regime, unified Organization investigation, simpler correlation and future class-specific retention. Branch events remain naturally Organization-scoped. | Existing rows need a trustworthy Branch→Organization backfill and verification. Nullable Branch needs a rule that, when present, it belongs to Organization. Migration/rollback and mixed retention/read policies require care. |
| Separate Organization store plus existing Branch store | Lowest-risk incremental addition; no immediate backfill; clear separation while policy is immature. | Duplicate envelope/protection/read code; two ordering/idempotency spaces; cross-store investigation/export complexity; greater risk of policy drift. |
| Physically partitioned unified model | Could support class/tenant operations later. | Premature physical complexity; partition keys, retention, privileges, and operational ownership are not approved. |

**Technical preference:** converge on one logical event envelope and one authoritative store if the same integrity and retention class can be approved. **Safe first slice:** a separate Organization-level table may be justified if avoiding an unverified backfill is the primary constraint, provided both stores use the same Application contract and no false claim of globally ordered evidence is made. Owner/security/legal decisions below must precede the irreversible choice.

## 6. Minimum event envelope

| Field | Need and status | Sensitive-data boundary |
|---|---|---|
| `event_id` | Technically required immutable UUID for reference/deduplication. | Not personal by itself; do not encode meaning. |
| `organization_id` | Technically required tenant scope for every event. It must come from trusted server context or authoritative resource ancestry. | Security-sensitive tenant identifier; every query must scope it before lookup. |
| Historical `branch_id` alternative | **Superseded for Slice 1.** This was evaluated only for a rejected one-store/future-Branch alternative. The new Organization store contains no Branch representation. | Existing legacy Branch rows remain separate; any future Organization-store Branch support requires a new Owner decision and review. |
| `event_type` | Technically required, namespaced and source-context-owned. Exact catalog is policy/design work. | Names can reveal sensitive action; avoid embedding IDs or personal data. |
| `event_version` | Technically required positive schema version so evidence can be interpreted after evolution. Encoding/version policy remains technical design. | None by itself. |
| `occurred_at` | Technically required finite server-authoritative decision/occurrence time. Empty infrastructure rejects PostgreSQL infinity but selects no arbitrary finite range; each future event requires an approved age/skew/source/delay policy. | May reveal employee activity. Client time may be separate untrusted metadata only if justified. |
| `recorded_at` | Technically required database/server persistence time, distinct from occurrence time. | May reveal activity; supports delay/gap monitoring. |
| `actor_type` | Technically required distinction among authenticated human and system initiation. The exact closed vocabulary is a security decision. | Do not equate a system process with a person. |
| `actor_id` | Required for an authenticated human and derived from trusted Identity evidence; null for unauthenticated/system events. | Personal/security identifier. No invented system UUID. |
| `correlation_id` | Recommended technical field for one request/workflow; whether mandatory by event class is design policy. | Use an opaque server identifier, never a token or credential. |
| `causation_id` | Optional unless an event was caused by another durable event/command; supports traceability without claiming temporal ordering. | Opaque reference only. |
| `target_type` and `target_id` | Technically required when a durable target exists. Producer owns semantics; no polymorphic cross-context FK is implied. | Employee/User/session/payment targets are sensitive and reader-scoped. |
| `outcome` | Technically required for security-sensitive attempts (`succeeded`, `failed`, `denied` are already proposed canonically); exact per-event outcomes need a catalog. | Reason details must not leak credentials or unnecessary personal data. |
| `idempotency_key` | Required for retryable append paths; scope and generation require design and concurrency tests. | Must be opaque or composed only from safe identifiers. |
| `metadata` | Optional, versioned, allowlisted, minimal structured facts only. | Never store passwords, PINs, raw session/recovery/CSRF tokens, MFA secrets/codes, payment credentials, authorization headers, unrestricted bodies, or unnecessary PII. |

Effective role/capability, reason codes, safe before/after summaries, and source/device/session lookup references are already proposed for relevant classes, but should be class-specific fields or allowlisted metadata rather than universally mandatory ([Identity Authorization §6](../architecture/after_four_identity_authorization.md#6-audit-event-design)).

## 7. Append-only and database privilege design

Minimum production design requirements, without selecting exact SQL in this assessment:

1. A schema/migration owner owns the table, function, and trigger; the application runtime is not owner and is not superuser.
2. The runtime audit writer receives only the minimum append privilege or a narrowly reviewed append function. It receives no `UPDATE`, `DELETE`, `TRUNCATE`, `ALTER`, trigger-disable, ownership, or function-replacement authority.
3. Ordinary application roles receive no direct general `SELECT`; a separate reader path/role exposes only policy-scoped queries. Export and hold administration are separate capabilities.
4. Keep update/delete trigger protection as defense in depth. Explicitly test `TRUNCATE` denial and runtime inability to disable/drop the trigger or alter ownership.
5. Prefer a direct INSERT grant unless a `SECURITY DEFINER` function demonstrably reduces exposure. Any such function needs a fixed `search_path`, exact ownership/grants, input validation, and adversarial tests; it is not automatically safer.
6. Backups, restore, migration, and break-glass operators remain privileged bypasses. Record and reconcile those operations; do not call the store absolutely immutable.
7. External checkpoints, signatures, or a secondary sink can improve privileged-tamper detection later. A row hash stored beside rewritable rows is insufficient by itself and is not an MVP substitute for least privilege.

The authoritative design supersedes this early shorthand: the function owner has only required `SELECT`/`INSERT`, replay performs no row lock, and effective evidence enumerates all eight PostgreSQL 18 table privileges (`SELECT`, `INSERT`, `UPDATE`, `DELETE`, `TRUNCATE`, `REFERENCES`, `TRIGGER`, `MAINTAIN`) across direct, `PUBLIC`, inherited and `SET ROLE` paths. Global default-function revocation is distinct from per-schema defaults and same-transaction object revocation. `af_migrator` is non-superuser/non-role-admin/non-database-create/non-replication/non-RLS-bypass; provider control-plane privilege remains outside PostgreSQL's ability to constrain.

## 8. Transaction, retry, and failure semantics

| Category | Required behavior |
|---|---|
| Successful security-sensitive or financially material mutation | Business state and authoritative local audit append share the same owning outer transaction and fail closed if append fails. An embedded append returns only `PendingAppendReceipt`; function return, inner transaction return, savepoint release or callback registration is not commit. Only the outermost transaction owner may create `CommittedAppendResult` after known commit. Existing use cases demonstrate the atomic pattern, not this future result contract. |
| Rejected/denied request before state change | Preserve safe durable evidence through a separately designed failure-evidence path after the rejected transaction, because rollback cannot preserve an event in that transaction. It must use trusted server facts and must not leak whether an out-of-scope target exists. |
| Failed/ambiguous mutation | Record only what is known: attempt, failure/unknown outcome, correlation, and safe reason. Never claim success or unchanged state without evidence. Exact independent-write policy is event-class specific. |
| Retry/duplicate | Same logical evidence uses a stable idempotency key; uniqueness is Organization-scoped and must not collapse distinct attempts. Known rollback and uncertain commit both reuse the same identity; conflicting replay fails closed and is observable. |
| Concurrency/order | `occurred_at` is not a total-order guarantee. `recorded_at`, stable IDs, causation, domain revision where approved, and transaction evidence provide traceability. Do not invent a global sequence requirement. |
| Asynchronous handling | Acceptable for downstream delivery, telemetry, or projection only where loss/delay is explicitly tolerated. It must not be the sole authoritative record of a sensitive state change. |

An outbox is not needed merely to append authoritative local audit evidence. If an external audit sink is later approved, append the local event and its delivery intent atomically, then publish after commit. Keep that delivery outbox distinct from domain/integration events and do not reuse Preparation's outbox semantics without design.

The current exact replay design uses `INSERT ... ON CONFLICT DO NOTHING` followed by an ordinary read. Under `READ COMMITTED`, the unique index serializes identical/conflicting racers; the loser observes the committed immutable winner, returns match only for exact facts, and otherwise conflicts. Winner rollback permits the loser to become the sole insert. No `FOR SHARE` or `UPDATE` grant is required. `40001`/`40P01` and every database error unwind the entire owning transaction; structured `PG_DIAG_SQLSTATE`, never message text, controls the narrow mapping and any approved whole-transaction retry.

## 9. Write and read authorization

**Write boundary.** Humans do not receive table-write permission. A protected Application use case decides the event, and a composition-wired adapter supplies trusted actor/scope evidence to the Audit append contract. The contract must reject client-supplied actor/Organization authority, Organization mismatches, unregistered producer/event types, unsafe metadata, and conflicting idempotent replay. System initiation uses `actor_type=system`, null human actor, and approved producer provenance; it never fabricates a User.

**Read boundary.** ID-12 and ID-18 establish restricted, explicitly authorized audit readers; they do not establish that every Owner, Branch Manager, or Staff member can search or export every row ([Identity Decision Register](../architecture/after_four_identity_decision_register.md#owner-decisions-confirmed)). Queries must pre-scope Organization, then Branch where policy permits, before resource lookup. Unknown/out-of-scope IDs must not enable IDOR discovery. Read, search, export, legal-hold, release, and exceptional investigation are separate capabilities; no capability catalog is approved here.

Audit access itself should be audited for sensitive searches, row views, exports, hold/release, redaction/anonymization actions, and break-glass use. The design must avoid recursion: inability to record a sensitive audit-access event should fail that access closed, while operational monitoring of the audit writer remains a separate channel.

## 10. Future Employee creation example

This example tests the design; it does not authorize Employee creation or decide who may create/approve it.

For a successful future `Workforce::CreateEmployee` use case:

1. Presentation authenticates; Identity supplies the trusted User/Organization/Session context.
2. Workforce validates its own command and Employee identity. Organization scope is never inferred from a Branch or request body.
3. Historical candidate only: in one transaction, Workforce would insert the Employee and ask its audit port to append `workforce.employee_created` version 1 with the same Organization, the trusted User actor, Employee target ID, `succeeded` outcome, server occurrence time, persistence time, correlation ID, and stable idempotency key. No event or producer is approved, and the Slice 1 envelope has no Branch field.
4. Audit failure rolls back Employee creation. Audit Evidence does not access `EmployeeRecord`; Workforce supplies the opaque target and safe event facts.

For a rejected attempt, no created Employee may be asserted. A safe denial event may reference a separately approved request/candidate correlation, with null target where no durable target exists. Whether such evidence may include attempted subject correlation, and its retention/access, requires security and legal/privacy decisions. The current absence of a production Employee write path remains unchanged.

## 11. Privacy, retention, export, and operations

### MVP foundation requirements

- Enforce Organization isolation on append and future read; test cross-Organization denial before lookup. Cross-Branch checks apply only to the separate legacy store or a separately approved future Branch design, never Slice 1.
- Use allowlisted metadata and redaction tests; monitor failed/suspicious audit appends without logging the sensitive payload.
- Separate runtime writer, reader, migration owner, and operational break-glass authority.
- Reconcile counts/idempotency and alert on append failures, trigger/privilege drift, unexpected gaps, and external-delivery lag where applicable.
- Include audit integrity in backup/restore exercises. Restore can change database history; record the restore boundary and reconcile against protected checkpoints when those exist.
- Preserve append evidence without treating it as the domain ledger or authorization source.

### Decisions and qualified input still required

- Class-specific retention minimums/maximums, disposition, legal holds, hold release, deletion/anonymization interaction, backup expiry, and restored-data handling.
- Visibility for security, HR/payroll, financial, customer-linked, and pre-employment/offboarding evidence.
- Search/export fields, recipients, purpose, format, redaction/pseudonymization, approval, delivery, and export retention.
- Employee notice/access/correction rights and treatment of disputed evidence without rewriting history.
- Exceptional/break-glass access and independent review/self-investigation controls.

The audit security review remains `BLOCKED`, while audit retention/legal-hold and export/anonymization privacy reviews have no qualified conclusions ([AF-SEC-008](../architecture/security-reviews/af-sec-008-audit-security.md), [AF-PRIV-004](../architecture/security-reviews/af-priv-004-audit-retention-legal-holds.md), [AF-PRIV-005](../architecture/security-reviews/af-priv-005-exports-anonymization.md)). `ODB-DATA-01` preserves important audit/history but approves no duration or purge mechanism ([Owner Decision Baseline §6](../architecture/after_four_owner_decision_baseline.md#6-global-data-retention-and-deletion)). No compliance or production-readiness claim follows from this assessment.

## 12. Decision staging after Owner confirmation

`AUD-DEC-01`–`AUD-DEC-06` were Owner-confirmed on 2026-11-27 and are not reopened. They are sufficient business/design direction for an external reviewer to assess the bounded Empty Slice; no additional Owner policy decision is required before that review. The unresolved decisions below are staged by the capability they govern rather than treated as blockers to the empty infrastructure:

1. **Before first human producer — `AUD-DEC-07`–`11`:** exact event/version and immutable registration; failure class; actor/session evidence; metadata schema/limit; finite-time policy; and acceptance of the trusted-composition residual risk. These do not block the empty store.
2. **Before any system producer:** approve the producer identity, invocation evidence, credential custody, rotation/revocation, accountable operations owner, retry/failure semantics and trust model. System production remains disabled.
3. **Before reader/export/production-data governance — `AUD-DEC-12`–`14`:** reader scope, export approval/custody, retention, legal hold, correction/dispute, anonymization and backup expiry after applicable qualified input.
4. **Before future Employee operations:** separately decide who may request, approve and execute Employee creation; the audit foundation supplies no such authority.

## 13. Technical recommendations that do not create business policy

- Define a framework-independent immutable envelope, return transaction-local facts only in `PendingAppendReceipt`, and reserve `CommittedAppendResult` for the known-committed outermost transaction owner; keep Active Record and PostgreSQL in Audit Infrastructure.
- Use the module-local `ActiveRecord::Base` persistence root without root `ApplicationRecord` or connection switching. The outer wrapper holds `with_connection`, proves no transaction is active, opens the boundary itself and alone issues one opaque capability from its yielded transaction object. Joined scope reuses it; ambient entry, nested issuance, real savepoints/restarted parents, retries, stale/transferred contexts and any unprovable identity fail before SQL. See the [Rails policy](organization_level_audit_security_design_closure.md#authoritative-rails-connection-and-transaction-participation-policy).
- Require exact target `server_encoding = UTF8` and session `client_encoding = UTF8` at each lifecycle stage. A native parse/resolution/bind/decode/conversion failure before function entry fails closed under its structured PostgreSQL state and is not guaranteed to be `AUE02`; after successful entry, the append function's first control checks the exact executing session and raises `AUE02` on mismatch. Both paths construct no receipt/success, permit no later statement or partial continuation, and unwind without alternate-connection fallback. Restore promotion additionally requires one non-reusable attempt/unique invocation, source binding, exclusive target-generation fencing, truthful aggregate/worker evidence, complete catalog reconciliation and an atomic one-way `QUARANTINED -> ACCEPTED` transition; monitoring reports to a separate enforcement component rather than claiming traffic authority. See the [UTF-8 lifecycle matrix](organization_level_audit_security_design_closure.md#utf-8-lifecycle-enforcement-matrix).
- Preserve source-context-specific audit ports so Domain code does not depend on Audit or Rails.
- Use server time, trusted Identity context, opaque IDs, strict UUID/value validation, and exact Organization matching.
- Version and allowlist each event type's metadata; reject unknown keys and unsafe scalar sizes.
- Treat `allowed_outcomes`, `allowed_metadata_keys` and `required_metadata_keys` as duplicate-free logical sets with one reviewed stable order: reject exact duplicates in Application and PostgreSQL, encode the complete registration only through the version-1 binary contract in Logical Contract §10.1.1–10.1.5, compare SHA-256 over those exact bytes, and test duplicate, case, reordered, NULL, permitted-empty, framing, version and drift fixtures without normalization.
- Add idempotency/conflict, atomic rollback, malformed reconstitution, cross-tenant, direct-SQL, `TRUNCATE`, grants, owner-bypass documentation, and backup/restore reconciliation tests.
- Replace producer adapters' direct root-model access only within an authorized migration slice; do not perform a wholesale rewrite incidentally.
- Keep read/search/export interfaces absent until their policies and capabilities are approved.

## 14. Suggested bounded implementation sequence

1. **Final narrow verification, then external independent review:** first verify the micro-remediation for `ISR-AUD-036/041`; preserve the latest design-level verification of `ISR-AUD-039/040/042`. The later external review must disposition every `ISR-AUD-001`–`042` and `AUD-SEC-01`–`14` finding against the exact package. No schema yet.
2. **Owner authorization decision:** only after accepted or explicitly conditioned external review, consider a manifest limited to `Platform::AuditEvidence`, the empty store/catalog/function/roles and disposable tests, with no production caller or runtime appender membership.
3. **Organization-level foundation slice:** only under that separate authorization, implement the empty Audit module/store/catalog and its tests. No catalog fixture, projection encoder for an approved registration, production producer or Employee operation is included.
5. **Identity/Workforce producer slice:** only after relevant event and authority decisions, connect trusted Identity actor context and approved workflows through narrow contracts.
6. **Existing producer migration:** move Orders/Payments/Preparation adapters from the root model incrementally with regression and transaction evidence; preserve current behavior.
7. **Reader/export/retention slices:** only after capability and qualified legal/privacy decisions; audit the access itself and provide operational runbooks.

## 15. Exclusions and unresolved risks

No schema, migration, application code, Employee write path, capability, package, database role, retention period, export facility, external sink, or production control was created. No application tests, database commands, migrations, builds, or services were run.

Material unresolved risks are cross-Organization access, raw actor spoofing in existing audit ports, direct cross-package persistence access, privileged database tampering, `TRUNCATE`, unsafe metadata/PII leakage, missing durable denial evidence, unclear event ordering, unapproved reader/export authority, retention/erasure conflicts, and restore-induced evidence discontinuity.

## Final recommendation

`EXTERNAL_INDEPENDENT_REVIEW_REQUIRED`

The documentation package contains the remediation candidate for a bounded Empty Slice review, but an internal Codex perspective is not external independent assurance. After focused re-review of the newest corrections, a qualified independent reviewer must disposition all `ISR-AUD-001`–`042` and `AUD-SEC-01`–`14` findings against the exact five-document package before the Owner can consider implementation authorization. No first catalog, producer, reader, export, retention feature, runtime appender membership, deployment, Gate, FOA or Production Authorization follows.

The repository contains enough verified behavior, confirmed Owner direction and reconciled logical/physical design for external review of the empty infrastructure. First-producer, reader/export and production-data policies remain deliberately staged and cannot be inferred from Empty Slice review. This verdict grants no implementation authority.
