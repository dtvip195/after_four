# AFTER FOUR — P3 Runtime Database Security Design

**Document status:** `TECHNICAL_PROPOSAL`

**Readiness:** `DESIGN_REVIEW_REQUIRED`

**Implementation authorization:** `Not granted`

**P3 implementation:** `Unauthorized`

**Evidence date:** 2026-11-15

## 1. Purpose and authorization boundary

P3 defines a reviewable PostgreSQL security architecture for separating ordinary application runtime access from migration ownership and exceptional break-glass authority. Its purpose is to prevent database credentials used by ordinary Rails processes from bypassing trusted Catalog lifecycle authorization, Brand isolation, P2 audit atomicity, append-only evidence, no-Purge rules, and Package B integrity mechanisms.

This is design only. It creates no role, membership, grant, revocation, schema, function, trigger, migration, configuration, credential, test, or runtime behavior. It does not implement or authorize P1, P2, Package C, Identity Milestone 2B, production deployment, or production use.

The classifications in this document are normative:

| Classification | Meaning |
|---|---|
| `VERIFIED_CURRENT_STATE` | Directly supported by inspected repository files. It is not automatically production evidence. |
| `TECHNICAL_PROPOSAL` | Reviewable security design; neither implemented nor selected merely by appearing here. |
| `EXTERNAL_PREREQUISITE` | Separately authorized implementation or operational evidence required for integration/acceptance. |
| `NOT_IMPLEMENTED` | The inspected repository contains no executing control or retained production-like evidence. |
| `OWNER_DECISION_REQUIRED` | Governance or business authority requires explicit Owner direction. |
| `DEFERRED` | Owner intentionally postponed the matter; no replacement/default is approved. |

Owner-confirmed requirements remain authoritative even when their implementation is `NOT_IMPLEMENTED`. No classification here changes the [Owner Decision Baseline](after_four_owner_decision_baseline.md#package-c0-lifecycle-authority-and-prerequisite-decisions), ADR status, or CAT-TRR status.

### 1.1 In scope

- PostgreSQL principal, ownership, membership, inheritance, and `SET ROLE` topology;
- least-privilege matrices across database, schema, table, sequence, and function scopes;
- operation-specific Catalog lifecycle database-boundary alternatives;
- protection of P2 and Phase 1 append-only audit records;
- preservation of Package B Catalog invariants and lock/transaction assumptions;
- migration, deployment, connection-pool, worker, and credential-rotation requirements;
- break-glass governance proposals and unresolved Owner decisions;
- production-like negative/positive verification requirements.

### 1.2 Non-goals

- choosing or implementing the final operation-specific mechanism;
- creating database roles or modifying grants/default privileges;
- moving P1 authorization or Package C Domain behavior into PostgreSQL;
- P2 persistence representation or migration selection;
- a general enterprise database-security framework for unrelated contexts;
- public API, authentication, MFA, audit reader/export/retention, retry, or idempotency policy;
- changing existing Package B constraints, triggers, migrations, or Phase 1 AuditEvent behavior.

## 2. Current-state repository evidence

### 2.1 Connection and principal assumptions

| Evidence | Classification | Finding |
|---|---|---|
| `backend/config/database.yml` | `VERIFIED_CURRENT_STATE` | Development/test default to one environment-provided principal whose fallback name is `postgres`. Production uses one opaque `DATABASE_URL`; no separate runtime/migration URL is defined. |
| `backend/compose.yml` | `VERIFIED_CURRENT_STATE` | Development backend and PostgreSQL service use the same local `postgres` principal. PostgreSQL is pinned to 18.7. |
| `.github/workflows/quality.yml` | `VERIFIED_CURRENT_STATE` | CI prepares, dumps, migrates, and tests with one `postgres` service principal. It is not a production-like non-owner role topology. |
| `backend/.env.example` | `VERIFIED_CURRENT_STATE` | Defines one set of PostgreSQL connection variables; no runtime/migration/break-glass separation. |
| `backend/README.md` | `VERIFIED_CURRENT_STATE` | Documents local `postgres` defaults and an opaque production `DATABASE_URL`; explicitly describes Compose as development-only. |
| Repository role/grant search | `VERIFIED_CURRENT_STATE` | No `CREATE ROLE`, application-role `GRANT`/`REVOKE`, `ALTER DEFAULT PRIVILEGES`, role-membership topology, or production privilege export exists. |
| Production principals/ownership | `NOT_IMPLEMENTED` | Repository evidence cannot identify production role names, memberships, table/function owners, grants, default privileges, or connection-pool identity. |

No credential values were inspected or recorded beyond repository-safe local examples. P3 must never require secrets in source or evidence output.

### 2.2 Package B Catalog controls

`backend/db/migrate/20261115210000_create_catalog_core_foundation.rb` and `backend/db/structure.sql` verify these current mechanisms:

| Control | Classification | Verified behavior and limit |
|---|---|---|
| Same-Brand ancestry | `VERIFIED_CURRENT_STATE` | Composite foreign keys enforce Product→Category and Variant→Product Brand agreement; this is data integrity, not Actor authorization. |
| Codes/default cardinality | `VERIFIED_CURRENT_STATE` | Brand-scoped unique indexes and a partial unique Default index protect direct SQL races. |
| Lifecycle value/transition checks | `VERIFIED_CURRENT_STATE` | CHECK constraints plus Category/Variant initial-state and transition triggers reject invalid statement-level states. |
| Scope immutability | `VERIFIED_CURRENT_STATE` | Triggers reject Category Brand, Product Brand/Category, and Variant Brand/Product changes. |
| No-Purge | `VERIFIED_CURRENT_STATE` | `BEFORE DELETE` triggers reject Category/Product/Variant DELETE with named `23514` identities. They do not prevent TRUNCATE or privileged trigger removal/disablement. |
| Final-state invariants | `VERIFIED_CURRENT_STATE` | Deferred constraint triggers enforce Active Product/Active Category and Active Product/Active Default Variant under `READ COMMITTED`. |
| Function definitions | `VERIFIED_CURRENT_STATE` | Catalog trigger functions are `VOLATILE`, use fixed `search_path = pg_catalog, public`, contain no inspected dynamic SQL, and are installed in `public`. They are not Package C operation functions. |
| Package C writes | `NOT_IMPLEMENTED` | No Catalog Application lifecycle use case or authorized runtime Catalog DML exists. |

Catalog persistence records exist under `backend/app/contexts/catalog/infrastructure/persistence/`, but repository application search found no Catalog runtime transaction/use case or raw Catalog write path. Their presence is not permission to grant runtime DML.

### 2.3 Audit controls

| Evidence | Classification | Finding |
|---|---|---|
| `backend/app/models/audit_event.rb` | `VERIFIED_CURRENT_STATE` | Phase 1 Branch-scoped model rejects instance update/destroy through callbacks. |
| `20261114203000_protect_audit_events_append_only.rb` | `VERIFIED_CURRENT_STATE` | Row-level `BEFORE UPDATE OR DELETE` trigger raises `23514`. It does not cover TRUNCATE. |
| `backend/spec/integration/audit_event_database_protection_spec.rb` | `VERIFIED_CURRENT_STATE` | Local tests cover model, bulk, and direct-SQL UPDATE/DELETE rejection and transaction rollback. They do not use a production-like runtime role. |
| `backend/spec/support/audit_event_cleanup.rb` | `VERIFIED_CURRENT_STATE` | Test cleanup disables the audit trigger as the database owner and deletes rows, proving privileged bypass remains possible. |
| P2 Brand-scoped persistence | `NOT_IMPLEMENTED` | P2 defines a logical contract and compatibility alternatives but selects no table/migration. |

Phase 1 `audit_events.branch_id NOT NULL` must not be repurposed as Brand scope. P3 protects whichever separately approved P2 representation is later selected without weakening existing Branch-scoped behavior.

### 2.4 Evidence status for CAT-TRR

Canonical statuses remain unchanged:

| Finding | Current canonical status | Relevant merged/local evidence | P3 gap |
|---|---|---|---|
| `CAT-TRR-006` | `HIGH` / `VALIDATION_EVIDENCE_REQUIRED` | Deterministic real-PostgreSQL Package B concurrency specs cover fresh snapshots, lock waits, reverse-order deadlocks, victim rollback, lock timeout, stale-snapshot harness, and deferred repair. | Package C/P1/P2/P3 integrated authorization, audit atomicity, and role-aware concurrency are unproved. |
| `CAT-TRR-007` | `HIGH` / `OPERATIONAL_EVIDENCE_REQUIRED` | Design constraints exist. | No production-like principals, ownership, grants/default privileges, role memberships, safe EXECUTE policy, or negative evidence. |
| `CAT-TRR-008` | `MEDIUM` / `VALIDATION_EVIDENCE_REQUIRED` | Fresh migration, A1 upgrade, rollback/refusal, injected failure/recovery, and semantic schema-equivalence specs exist for Package B. | P2/P3 role-aware provisioning, grants, rollback/roll-forward, and selected operation boundary are absent. |

This document neither edits nor closes these findings.

## 3. Owner-decision traceability

### 3.1 C0-R09 — trusted authorization remains outside PostgreSQL

`OWNER_CONFIRMED` policy, with implementation `NOT_IMPLEMENTED`:

- P1 creates trusted server-side identity, Session, target binding, and AuthorizationContext.
- Client-supplied Actor, Organization, Brand, role, capability, delegation, or MFA claims are never authority.
- Missing, invalid, expired, or revoked identity/delegation fails closed.
- P3 must not turn a role name, SQL parameter, session variable, row predicate, or database login into an alternative authorization authority.

Database controls may verify structural consistency and restrict executable operations. They do not independently decide whether a human Actor is authorized for a Brand lifecycle operation.

### 3.2 C0-R10 — required database security boundary

Every C0-R10 requirement is carried forward:

| Requirement | P3 design consequence | Current implementation |
|---|---|---|
| Separate runtime from migration ownership | Ordinary Rails credentials have no membership path to application-object-owner/migration/optional-operation-function-owner/break-glass authority. | `NOT_IMPLEMENTED` |
| Runtime owns no Catalog/Audit objects | A non-login ownership role or equivalent controlled owner holds schema/table/function ownership. | `NOT_IMPLEMENTED` |
| No unrestricted `ALTER`/`DROP` | Runtime has no ownership, schema CREATE, or privileged function replacement path. | `NOT_IMPLEMENTED` |
| No `TRUNCATE` | Runtime lacks table TRUNCATE; protected audit/Catalog relations additionally receive operation-specific controls where required. | `NOT_IMPLEMENTED` |
| No trigger disablement/replacement | Runtime lacks ownership/TRIGGER/DDL paths and cannot become a role that has them. | `NOT_IMPLEMENTED` |
| No `session_replication_role` modification | Runtime is neither superuser nor granted parameter `SET` privilege for it. | `NOT_IMPLEMENTED` |
| No direct DELETE | Runtime receives no DELETE on Catalog/P2 audit relations; Phase 1 permissions require separate compatibility review. | `NOT_IMPLEMENTED` |
| No function replacement | Runtime lacks function ownership, schema CREATE, and migration-owner membership; future privileged function owner is separated. | `NOT_IMPLEMENTED` |
| No role grants | Runtime lacks `CREATEROLE`, membership `ADMIN` options, and a path to administrative roles. | `NOT_IMPLEMENTED` |
| Prevent unrestricted Catalog DML bypass | Runtime cannot directly update lifecycle/base tables outside an approved operation-specific interface. | Mechanism unselected; `NOT_IMPLEMENTED` |
| Mechanism not preselected | Compare alternatives and require evidence before selection. | Preserved by §7. |

### 3.3 C0-R07, C0-CAT-07, C0-CAT-06, and Package B

- Lifecycle mutation and required P2 Brand-scoped AuditEvent append commit or roll back in the same transaction.
- Audit validation/persistence failure rolls back the complete lifecycle mutation.
- No after-commit, background, outbox, or best-effort substitute satisfies required success evidence.
- Brand scope comes from P1's revalidated persisted target relationship, never client input.
- Package B constraints, triggers, deferred checks, `READ COMMITTED` requirement, and lock-order design remain active defense in depth.
- No operation-specific boundary may weaken constraints or suppress their failures to make privileged execution appear successful.

### 3.4 Deferred decisions preserved

| Decision | P3 boundary |
|---|---|
| `C0-R05` | MFA freshness, assurance, Session binding, and invalidation remain `DEFERRED`; P3 cannot infer them. |
| `C0-R08` | Retention, legal hold, reader authorization, export, and related audit governance remain `DEFERRED`; P3 chooses no duration or reader/export role. |
| `C0-R11` | Retry, backoff, replay, and idempotency remain `DEFERRED`; P3 chooses no automatic retry or operation token replay policy. |

## 4. Threat model and trust boundaries

### 4.1 Protected assets

- Catalog lifecycle state and Brand ancestry;
- Active Product/Category and Default Variant final-state invariants;
- no-Purge retention guarantees;
- P2 Brand-scoped and existing Phase 1 audit history;
- lifecycle mutation/audit atomicity;
- migration/schema/function/trigger integrity;
- database credentials and role-membership paths.

### 4.2 Threat and abuse-case matrix

| Threat/abuse case | Required control/result |
|---|---|
| SQL injection or arbitrary SQL using ordinary runtime connection | Runtime privileges alone cannot update lifecycle columns, delete/truncate protected rows, disable/replace triggers/functions, or assume owner roles. Allowed operation interface still validates exact inputs and preserves atomicity. |
| Direct Active Record/bulk/raw SQL bypass | Catalog base-table DML is unavailable except through the selected operation-specific seam; constraints remain defense in depth. |
| Forged Actor/Brand/capability/session setting | Database never treats caller-provided values or freely settable GUCs as P1 authority. Missing verifiable P1 binding fails closed. |
| Role inheritance or `SET ROLE` escalation | Runtime has no `INHERIT`/`SET` membership chain to migration, application-object-owner, optional operation-function-owner, or break-glass roles. |
| Database/platform administration escalation | Runtime cannot assume, inherit, administer, obtain credentials for, or otherwise access Database/Platform Owner or equivalent database administration authority. Discovery of any PostgreSQL or external control-plane privilege path is a fail-closed deployment/readiness failure. |
| Table/function owner in runtime pool | Prohibited; owners can regrant privileges or alter/drop protection. |
| Trigger/function replacement | Runtime lacks ownership/schema CREATE/DDL and cannot assume a capable role. Future function owners and PUBLIC EXECUTE are tightly controlled. |
| `session_replication_role = replica` bypass | Runtime lacks superuser and parameter SET privilege; negative test required. |
| Audit append skipped or fails | Operation boundary cannot commit lifecycle mutation without the required event. Failure aborts the transaction. |
| Cross-Brand target substitution | P1/Package C revalidation binds entity→Brand→Organization; operation interface cannot accept a free-standing Brand as authority. |
| Privileged migration/break-glass misuse | Separate credentials, explicit activation, audit/monitoring, post-use review, and no ordinary pool access; superuser limits remain explicit. |
| Partial role/grant deployment | Fail deployment and prevent application start/cutover until catalog inspection proves the exact privilege baseline. |

### 4.3 Security limit

PostgreSQL superusers and unrestricted infrastructure administrators can ultimately bypass database permissions, replace objects, or alter evidence. P3 provides least privilege, separation, detection, and governed exceptional access; it does not claim cryptographic immutability or tamper-proof storage against those authorities.

## 5. PostgreSQL principal and ownership topology

All names below are logical roles, not authorized SQL identifiers.

### 5.1 Proposed principals

| Principal | Classification | Responsibility |
|---|---|---|
| Database/platform owner | `TECHNICAL_PROPOSAL` | Own/create database-level resources where the managed platform requires it; not used by Rails runtime or routine migrations. |
| Application object owner | `TECHNICAL_PROPOSAL` | Non-login owner for ordinary application schemas, tables, sequences, constraints, triggers, and ordinary database functions. It does not own any separately selected privileged operation function and is never an application credential. |
| Migration executor | `TECHNICAL_PROPOSAL` | Separate deployment credential allowed to assume/use object-owner authority only for reviewed migrations and grant reconciliation. Never available to runtime pools/workers. |
| Ordinary runtime login | `TECHNICAL_PROPOSAL` | Rails web/job connection identity; non-owner, non-superuser, non-replication, no role administration or owner/migration/operation-function-owner/break-glass membership. Receives only reviewed ordinary access plus the selected Catalog operation interface. |
| Optional operation-function owner | `TECHNICAL_PROPOSAL` only if Alternative B is selected | Separate non-login owner only for narrowly scoped privileged operation functions. It owns no Catalog/Audit table or application schema, holds only the minimum table/audit privileges required by the selected implementation, and has no general migration, schema DDL, role-administration, or break-glass authority. No login credential for this role is available to Rails web or job processes. |
| Break-glass authority | `TECHNICAL_PROPOSAL` plus `OWNER_DECISION_REQUIRED` governance | Exceptional recovery/incident authority, unavailable to ordinary processes and activated only through an approved procedure. |
| Test/setup/cleanup principal | `VERIFIED_CURRENT_STATE` locally; production prohibition proposed | Local/CI currently use `postgres` for migrations, tests, trigger disablement, and cleanup. This principal is not a production runtime model. |

The optional operation-function owner does not exist unless Alternative B is separately selected and authorized. It is not the separate command-executor principal considered by Alternative E; that alternative would require its own reviewed topology.

### 5.2 Ownership, membership, and role-switching rules

`TECHNICAL_PROPOSAL`:

1. Ordinary runtime is `NOSUPERUSER`, `NOCREATEDB`, `NOCREATEROLE`, `NOBYPASSRLS`, and `NOREPLICATION`, and owns no application object.
2. Runtime has no direct or indirect membership, inherited privilege, `SET ROLE`, `ADMIN OPTION`, grant option, or equivalent administrative path to the Database/Platform Owner, application-object-owner, migration, optional operation-function-owner, or break-glass authority.
3. When database/platform administration exists outside PostgreSQL roles, its credentials, tokens, instance identity, provider permissions, and control-plane access are separated from and unavailable to Rails web/job processes and their runtime environment.
4. Object ownership is held by a non-login role or an equivalently isolated managed-platform principal.
5. Migration credentials are absent from application/web/job environments and connection pools.
6. If a deployment login must `SET ROLE` to the application object owner or a separately selected operation-function owner, that membership is limited to the deployment identity and operationally protected; granting either path to runtime would defeat separation.
7. No runtime membership carries `ADMIN OPTION`; runtime cannot grant roles.
8. `session_user`, `current_user`, memberships, role attributes (including `rolbypassrls` and `rolreplication`), owners, and any external database-administration identity are recorded in production-like evidence without recording secrets.

PostgreSQL membership can expose privileges through inheritance or permit `SET ROLE`; both paths require inspection. Object owners retain grant options and can regrant privileges even after revoking ordinary access. These are PostgreSQL properties, not optional conventions ([Role Membership](https://www.postgresql.org/docs/18/role-membership.html), [Privileges](https://www.postgresql.org/docs/18/ddl-priv.html)).

### 5.3 Principal responsibility matrix

| Capability | Database/platform owner | Application object owner | Migration executor | Runtime | Optional operation-function owner | Break-glass | Test/setup |
|---|---:|---:|---:|---:|---:|---:|---:|
| Own database | Controlled | No | No | No | No | Exceptional only | Yes locally today |
| Own application schema/table/sequence/constraint/trigger/ordinary function | No routine use | Yes, non-login | No persistent ownership; may assume owner during deployment | No | No | Exceptional only | Yes locally today |
| Own privileged operation function | No routine use | No | No persistent ownership; may deploy as the separately approved owner | No | Yes, only if Alternative B is selected | Exceptional only | Not implemented |
| Create/alter/drop ordinary schema objects | Platform-specific | Owner can by definition; no login | Reviewed migration only through controlled owner path | No | No | Exceptional | Yes locally |
| Apply Rails migrations/`structure.sql` | Platform-specific | No login execution | Yes | No | No | Recovery only | Yes locally/CI |
| Ordinary application reads/writes | Not routine | Owner can by definition; no login | Verification only | Explicit reviewed grants | No general application access | Exceptional | Yes locally |
| Direct Catalog lifecycle base-table DML | Not routine | Owner can bypass by definition; no login | Migration/data-repair only if separately approved | No | Minimum table rights only if Alternative B is selected | Exceptional | Yes locally |
| Append P2 event | Not routine | Owner can bypass by definition; no login | Migration verification only | Only through selected operation seam | Minimum audit INSERT/operation rights only if selected | Exceptional | Not implemented |
| Disable/drop/replace ordinary triggers/functions | Platform-specific | Owner can by definition; no login | Reviewed migration only | No | No | Exceptional | Yes locally |
| Replace privileged operation functions | Platform-specific | No | Reviewed deployment only as optional function owner | No | Owner can by definition but has no login | Exceptional | Not implemented |
| TRUNCATE protected tables | Platform-specific | Owner can by definition; no login | Only separately approved migration/recovery | No | No | Exceptional | Yes locally |
| Change `session_replication_role` | Superuser or explicit parameter privilege | No routine need | No routine need | No | No | Only if incident procedure explicitly permits | Possible locally |
| Grant roles/privileges | Administrative control | Object grants only as governed | Grant reconciliation only | No | No role administration | Exceptional | Possible locally |

## 6. Least-privilege privilege matrix

The matrix is a `TECHNICAL_PROPOSAL`; no grant exists because it is written here. “No” includes effective access through `PUBLIC`, direct grants, ownership, grant options, role attributes, and direct or indirect membership paths—not merely the absence of a named direct grant.

### 6.1 Object-scope matrix

| Privilege/capability | Migration/application-object-owner path | Ordinary runtime | Optional operation-function owner | Break-glass |
|---|---|---|---|---|
| Database `CONNECT` | Yes | Yes | No login; function execution uses caller connection | Controlled |
| Database `CREATE` / `TEMPORARY` | Deployment-specific; no routine TEMP need | No unless separately justified; default deny | No | Controlled |
| Schema `USAGE` | Yes | Only required schemas | Required schemas only | Controlled |
| Schema `CREATE` | Yes during reviewed migration | No | No | Controlled |
| Table `SELECT` | Migration verification | Only tables/columns required by authorized use cases | Minimum internal reads required by operation implementation | Controlled |
| Table `INSERT` | Migration/data repair only | Ordinary tables only when authorized; no direct P2/Catalog lifecycle bypass | Minimum P2 append/operation rights if selected | Controlled |
| Table/column `UPDATE` | Migration/data repair only | No direct Catalog lifecycle columns/base-table path | Minimum operation implementation rights if selected | Controlled |
| Table `DELETE` | Migration/data repair only under separate scope | No on Catalog/P2 audit; Phase 1 policy reviewed separately | No on Catalog/P2 audit | Controlled |
| Table `TRUNCATE` | Not routine; only explicit recovery/migration | No | No | Controlled |
| Table `REFERENCES` | Migration only | No | No | Controlled |
| Table `TRIGGER` | Migration only | No | No | Controlled |
| Sequence `USAGE`/`SELECT`/`UPDATE` | Migration as needed | Only sequences actually required; UUID-backed current app tables need none | Only if selected representation requires it | Controlled |
| Function/procedure `EXECUTE` | Migration verification | Only exact approved signatures; never broad schema/PUBLIC/inherited access | Execution is ownership behavior, not a runtime grant | Controlled |
| Function replacement/ownership | Ordinary functions through application owner; privileged operation functions through their separate owner if selected | No | Owns only approved privileged operation functions; no application-schema/table ownership | Controlled |
| Role membership / `SET ROLE` | Deployment identity to an owner only if required | No direct/indirect path to privileged roles | Non-login and not runtime-assumable | Controlled activation only |
| `SET` on `session_replication_role` | No routine migration need | No | No | Explicit incident-only if ever approved |

`SELECT`, `INSERT`, `UPDATE`, `DELETE`, `TRUNCATE`, `REFERENCES`, and `TRIGGER` are distinct table privileges; schema `CREATE`, function `EXECUTE`, ownership, and role membership are separate mechanisms. Revoking one table privilege does not remove ownership, inherited privileges, function-mediated access, schema object creation, or `SET ROLE` paths ([PostgreSQL privileges](https://www.postgresql.org/docs/18/ddl-priv.html)).

Acceptance requires computing the effective privileges of every actual Rails web and background-job connection identity. The calculation includes `PUBLIC`, direct and indirect memberships, membership `INHERIT`/`SET`/`ADMIN OPTION`, current effective role, role attributes, ownership/grant options, default privileges for every object-creating owner, and database/schema/table/column/sequence/function ACLs. Checking only direct grants—or observing `NOINHERIT` while ignoring `SET ROLE`, `PUBLIC`, ownership, and other membership paths—is insufficient.

### 6.2 Default privileges and function exposure

`TECHNICAL_PROPOSAL`:

- default privileges are configured and inventoried for every actual object-creating owner role, not assumed global;
- future privileged operation functions are owned by the separate optional non-login owner, which owns no application schema or Catalog/Audit table and holds only the minimum required table/audit privileges;
- a fixed `search_path` contains only explicitly trusted schemas, with `pg_temp` explicitly last and no schema writable by runtime or another untrusted principal;
- security-sensitive tables, functions, types, and other referenced objects are schema-qualified, while operator, type, cast, and other resolution/shadowing risks are reviewed separately;
- schema qualification does not replace the fixed trusted `search_path` requirement or the broader name-resolution review;
- dynamic SQL is avoided; if unavoidable, its constrained construction strategy receives a separate security review before selection;
- default `PUBLIC EXECUTE` is revoked and only exact approved function signatures are granted atomically with function creation/deployment;
- runtime receives no schema wildcard EXECUTE policy that would expose future functions accidentally;
- every new table/function/sequence is checked after migration for owner, grant options, `PUBLIC`, direct/inherited ACL exposure, and intended effective privileges.

PostgreSQL grants `PUBLIC` EXECUTE on new functions by default. Safe `SECURITY DEFINER` functions require a fixed trusted `search_path`, selective exact-signature EXECUTE, careful ownership, and name-resolution review ([CREATE FUNCTION](https://www.postgresql.org/docs/18/sql-createfunction.html)). Existing Catalog trigger functions are not operation functions and their fixed `pg_catalog, public` search path is evidence only; it is not approval of that path for a privileged operation function.

## 7. Operation-specific database-boundary alternatives

C0-R10 requires an operation-specific database seam but deliberately does not select its implementation. Every option must preserve P1 as the authorization authority, Package C as the use-case/Domain orchestrator, P2 atomicity, and Package B locks/constraints.

### 7.1 Evaluation criteria

- ordinary runtime cannot issue arbitrary Catalog lifecycle DML;
- target Brand/Actor/capability cannot be forged from client input or freely settable session state;
- lifecycle mutation and P2 event append share one transaction;
- Package C acquires Category→Product→Variant locks and revalidates P1 evidence at the required point;
- deferred triggers execute under `READ COMMITTED` and errors abort the whole transaction;
- SQL injection on the ordinary runtime connection cannot widen the interface;
- function/role ownership, membership, `search_path`, EXECUTE, and replacement paths are inspectable/testable;
- no second copy of Domain or authorization policy silently diverges.

### 7.2 Alternative A — application-only authorization with narrow table/column DML

| Aspect | Assessment |
|---|---|
| Interface | Rails adapters update allowed lifecycle columns and append audit within one transaction. |
| Benefit | Fits current Active Record topology and keeps Domain/Application behavior in Ruby. |
| Bypass risk | A runtime SQL injection or raw/bulk write with UPDATE can skip P1/Package C and may perform individually valid multi-statement changes without P2 evidence. Column grants cannot express “authorized operation plus audit in one transaction.” |
| Atomicity | Easy for conforming Application calls, not mandatory against arbitrary direct SQL. |
| Verdict | **Insufficient by itself** for C0-R10. Additional mandatory database seam would still be required. |

### 7.3 Alternative B — operation-specific `SECURITY DEFINER` functions/procedures

| Aspect | Assessment |
|---|---|
| Interface | Runtime receives EXECUTE on exact lifecycle operation signatures and no base-table lifecycle DML. Function owner holds only the minimum table/audit rights. |
| Benefit | PostgreSQL can force locks, mutation, and P2 append in one transaction and make arbitrary direct DML unavailable. |
| Trust gap | A function that accepts Actor/Brand/capability as ordinary parameters cannot know they came from P1. SQL injection with EXECUTE can call the same function with forged values unless a separate verifiable trusted-context seam exists. |
| Security requirements | A separate optional non-login function owner owns no Catalog/Audit table or application schema, has only minimum required table/audit privileges, and is unavailable to Rails credentials. Each function uses a fixed `search_path` containing only explicitly trusted schemas with `pg_temp` last; schema-qualifies security-sensitive objects; reviews operator/type/cast and other shadowing risks; avoids dynamic SQL or receives separate review for a constrained construction strategy; validates exact inputs; and atomically revokes default `PUBLIC EXECUTE` while granting only exact approved signatures. Runtime has no replacement or membership path to the owner. |
| DDD risk | Reimplementing Domain transitions/authorization in PL/pgSQL creates divergence. Function should enforce a narrow persistence protocol, not become the Domain or P1. |
| Verdict | Strong bypass/atomicity candidate, but **not selectable** until trusted-context provenance and Domain-duplication risks are resolved and tested. |

### 7.4 Alternative C — dedicated operation role with runtime `SET ROLE`

| Aspect | Assessment |
|---|---|
| Interface | Runtime switches to a narrow operation role for approved commands. |
| Benefit | Can separate ordinary reads from Catalog writes. |
| Bypass risk | If the runtime login has a membership chain with `SET TRUE` or inherited privileges, arbitrary SQL on that connection can exercise the same role. `SET LOCAL ROLE` scopes time, not caller legitimacy. |
| Atomicity | Can share one transaction, but does not itself bind trusted P1 evidence. |
| Verdict | **Insufficient as a security boundary by itself**. Membership may be useful operational plumbing only behind another trusted seam. |

### 7.5 Alternative D — updatable views plus INSTEAD OF triggers/rules

| Aspect | Assessment |
|---|---|
| Interface | Runtime writes narrow operation-shaped views; base tables are denied. |
| Benefit | Can limit visible columns/shapes and centralize mutation/audit behavior. |
| Risks | Trigger/rule ownership, view privileges, trusted-context provenance, cross-row locks, deferred checks, and semantic duplication remain. Misconfigured view/function paths become privileged bypasses. |
| Verdict | No clear leverage over operation functions for current requirements; **not selected**. |

### 7.6 Alternative E — separate command executor/principal

| Aspect | Assessment |
|---|---|
| Interface | Web runtime lacks Catalog DML and sends an authenticated command to a separately credentialed executor that owns the operation transaction. |
| Benefit | SQL injection on the web runtime connection cannot directly obtain executor DML. |
| Risks | Adds process/credential/transport topology, command authenticity, availability, observability, and deferred retry/idempotency questions. P1 context must cross the seam safely. |
| Atomicity | Executor can own one local PostgreSQL transaction if it performs both mutation and P2 append. |
| Verdict | Potentially strong but operationally expansive and not currently authorized. |

### 7.7 Alternative F — database policy/session context/RLS combination

| Aspect | Assessment |
|---|---|
| Interface | Policies/triggers consult transaction/session context for Actor/Brand/capability. |
| Benefit | Could add row-scope defense in depth. |
| Bypass risk | Caller-settable GUCs are not trusted provenance. Table owners/superusers and roles with `BYPASSRLS` can bypass RLS; policy still does not prove P1 authorization/audit coupling. |
| Verdict | Defense-in-depth candidate only after provenance design; **not an independent C0-R10 solution**. |

### 7.8 Design conclusion

No mechanism has sufficient repository evidence for final selection. The smallest candidates worth a separately authorized prototype/review are:

1. an operation-specific privileged function seam with runtime base-table lifecycle DML denied, provided P1 evidence provenance can be verified without copying authorization/Domain policy; and
2. a separate operation executor if the function provenance problem cannot be solved safely within one Rails/database connection topology.

This prioritization is `TECHNICAL_PROPOSAL`, not implementation authorization. Application-only DML and runtime `SET ROLE` alone fail the SQL-injection/direct-DML acceptance criterion.

## 8. Append-only and Catalog invariant protection

### 8.1 Phase 1 and P2 audit

| Layer | Required future behavior |
|---|---|
| Application interface | Phase 1 behavior remains intact; P2 exposes append only and no mutation/delete interface. |
| Database trigger/constraint | UPDATE/DELETE rejected for protected audit relations; P2 representation includes reviewed enforcement. |
| Runtime privileges | No UPDATE, DELETE, or TRUNCATE; INSERT only through the selected operation seam where atomicity requires it. |
| Ownership | Runtime owns no audit table, trigger, or protection function and cannot replace/disable them. |
| P3 operation seam | Lifecycle mutation cannot succeed unless required P2 append succeeds in the same transaction. |
| Exceptional authority | Migration/break-glass limitations are explicit; no tamper-proof claim against owner/superuser. |

TRUNCATE requires its own privilege/control because row-level DELETE triggers do not cover it. Existing Phase 1 `branch_id` semantics and history remain unchanged. P3 cannot select the P2 persistence alternative.

### 8.2 Package B integrity

Runtime access must preserve:

- composite same-Brand foreign keys and immutable ancestry triggers;
- Category/Variant lifecycle value, initial-state, and transition guards;
- Variant Archive/Restore same-statement flag protection;
- Product/Variant Default unique and deferred final-state checks;
- Active Product/Active Category deferred final-state checks;
- `READ COMMITTED` fail-closed guard;
- Category→Product→Variant Application lock order and acknowledged direct-SQL deadlock behavior;
- no-Purge DELETE triggers and runtime DELETE/TRUNCATE denial.

An operation interface may invoke these controls but cannot disable constraints, defer/force them contrary to the approved protocol, change isolation, suppress SQLSTATEs, continue an aborted transaction, or retry automatically while C0-R11 is deferred.

### 8.3 Direct-SQL and privileged limitations

Package B triggers prevent many invalid states even for direct SQL, but they do not prove human authorization or required P2 evidence. Multi-statement privileged Archive/Restore flag changes can be individually valid. Therefore ordinary runtime must lack an unrestricted Catalog base-table write path until an approved operation seam provides the complete semantic operation.

Migration/table owners and superusers can bypass protections by design. P3 limits and observes their use; it cannot make such bypass cryptographically impossible inside the same PostgreSQL administration boundary.

## 9. Migration and deployment lifecycle

The following is a future `TECHNICAL_PROPOSAL`, not authorization to provision or deploy.

### 9.1 Safe sequence

1. Inventory the target database and its administration plane: PostgreSQL version; Database/Platform Owner and equivalent administrative principals; actual web/job/migration `session_user` and `current_user`; role attributes; direct/indirect memberships with `INHERIT`, `SET`, and `ADMIN OPTION`; owners and grant options; `PUBLIC` plus database/schema/table/column/sequence/function ACLs; default privileges for every object-creating owner; extensions; current connections; and any external provider/control-plane identities, credentials, instance roles, or permissions capable of administering the database.
2. Create or verify platform owner, non-login application object owner, migration executor, runtime login, and only the separately approved optional operation-function-owner/break-glass principals through the authorized infrastructure channel. Database/platform administration credentials and control-plane access remain outside Rails web/job environments.
3. Compute and prove the effective privileges of every actual Rails web and background-job connection identity, including checkout/reconnect behavior. Direct-grant inspection or `NOINHERIT` alone is insufficient; runtime must have no inherited, `SET ROLE`, `ADMIN OPTION`, grant-option, credential, instance-identity, provider-permission, or equivalent path to Database/Platform Owner or any other privileged authority, and no access introduced through `PUBLIC`, ownership, role attributes, default privileges, or indirect membership.
4. Establish schema/object ownership and trusted schema CREATE policy without transferring ownership to runtime.
5. Apply reviewed Rails migrations as the migration/object-owner path, including P2/operation objects only if separately authorized.
6. In the same deployment change where possible, revoke unsafe defaults (including function `PUBLIC EXECUTE`) and apply exact schema/table/sequence/function grants after objects exist.
7. Run catalog inspection and negative privilege checks before enabling new runtime traffic.
8. Run positive lifecycle/P2 atomicity verification through the intended Application seam and connection pool.
9. Dump `structure.sql`, compare semantic objects/ACL expectations through the approved policy, and verify the complete migration chain.
10. Cut over only after grants, owners, pool identities, workers, migrations, and rollback/recovery evidence match the reviewed baseline.

### 9.2 Fresh provisioning and existing upgrade

Fresh databases require principal/ownership bootstrap before application migrations. Existing databases require an owner/membership/ACL inventory and an explicit transition plan; assumptions based on local `postgres` ownership are unsafe.

Role/grant changes must be repeatable and inspectable. If setup partially fails, application rollout remains stopped, connections using unexpected privileges are drained, and the approved roll-forward or rollback procedure restores the last verified ACL/ownership baseline. Destructive recovery or owner transfer is never improvised by the application.

### 9.3 Rollback and irreversible boundaries

- Schema rollback must not silently restore broad runtime privileges.
- Removing an operation interface requires revoking EXECUTE/access before or atomically with object removal.
- A migration that writes immutable audit history or changes ownership/ACL semantics requires an explicit rollback/refusal strategy.
- Non-empty Catalog rollback protections remain intact.
- Break-glass recovery is not a substitute for a tested roll-forward/rollback procedure.

### 9.4 Credentials, pools, workers, and rotation

- Runtime and migration use separate secret references and deployment scopes; secrets never enter Git, logs, command output, or audit payloads.
- Web and background-job pools use the ordinary runtime identity unless a separately reviewed worker interface genuinely requires different privileges.
- Every checkout verifies expected database/session identity through safe startup/health evidence without exposing credentials.
- Rotation drains/recycles pools so old credentials cannot remain indefinitely; migration/break-glass credentials are never loaded into long-lived runtime processes.
- A role mismatch or unexpected inherited privilege is a fail-closed deployment/readiness condition.

### 9.5 Local, CI, and production-like environments

Current local/CI superuser workflows may remain for schema construction and cleanup, but they cannot satisfy P3. A separately authorized CI/integration job must provision a production-like non-owner runtime role and run the negative/positive matrix. Test-only trigger disablement must be impossible under that runtime credential and clearly isolated from production configuration.

## 10. Break-glass governance

### 10.1 Confirmed boundary and proposals

C0-R10 confirms separation from ordinary runtime but does not define who approves, activates, monitors, or reviews break-glass access. The following are `TECHNICAL_PROPOSAL` pending explicit governance decisions:

- no break-glass credential or membership in web/job/migration default environments;
- explicit case-bound authorization before activation, except a separately defined emergency path;
- least privilege and time-bounded membership/credential where platform capabilities permit;
- independent recording of requester, approver/authority, operator, scope, reason, activation, commands/actions, result, and revocation;
- immediate credential/membership revocation after use, rotation when exposure is possible, and post-use verification of owners/ACLs/data/audit protections;
- no silent use for routine migrations, cleanup, tests, data fixes, or application retries.

### 10.2 Owner decisions and deferred governance

| Question | Classification |
|---|---|
| Who may approve and activate break-glass access? | `OWNER_DECISION_REQUIRED` |
| Whether dual control is mandatory and what constitutes an emergency exception? | `OWNER_DECISION_REQUIRED` |
| Maximum activation duration and renewal/escalation rules? | `OWNER_DECISION_REQUIRED` |
| Notification recipients, response timing, and post-use review authority? | `OWNER_DECISION_REQUIRED` |
| Retention, legal hold, readers, and export of break-glass evidence? | `DEFERRED` under C0-R08; legal/privacy input may still be required. |

Owner/superuser actions cannot be made impossible through ordinary grants. Break-glass assurance depends on credential custody, infrastructure controls, database/audit logs, monitoring, and human governance that are outside this design's implementation authority.

## 11. P1/P2/Package C integration

| Milestone | Owns | P3 dependency/boundary |
|---|---|---|
| P1 | Trusted identity/Session, TrustedCatalogTarget, exact authorization, authority/delegation/MFA evidence. | P3 consumes no client claims and creates no second authorization model. P1 implementation remains unauthorized. |
| P2 | Brand-scoped lifecycle event contract, append port, safe envelope, and same-transaction requirement. | P3 protects the selected persistence/operation seam but does not select or implement P2 storage. |
| Package C | Eight Application use cases, target resolution, P1 revalidation, locks, Domain invocation, lifecycle mutation, and P2 orchestration. | P3 constrains Infrastructure access without moving lifecycle policy into PostgreSQL. Package C remains unauthorized. |
| Package B | Existing schema, constraints, triggers, lock/snapshot behavior, and no-Purge backstops. | P3 preserves them and prevents runtime bypass. |

```text
Presentation -> Package C Application -> Catalog Domain
                       |
                       +-- P1 trusted authorization interface
                       +-- Catalog persistence interface
                       +-- P2 append interface
                                      |
                                      v
                         P3-controlled Infrastructure seam
                                      |
                                      v
                           PostgreSQL protected objects
```

Composition wires adapters. Catalog Domain/Application do not depend on PostgreSQL roles, Active Record, privileged functions, or Identity Infrastructure. An operation-specific database implementation is an Infrastructure adapter at a Catalog Application-owned seam, not a new Domain or authorization authority.

## 12. Verification strategy and acceptance criteria

No test or database command is executed by this design milestone. Future evidence uses real PostgreSQL 18.x because mocks/SQLite cannot prove ACLs, ownership, membership, `SET ROLE`, trigger/function behavior, deferred constraints, SQLSTATEs, or transaction atomicity.

### 12.1 Required inventory evidence

- `session_user` and `current_user` for web, job, migration, and test pools;
- role attributes (`rolsuper`, `rolcreaterole`, `rolcreatedb`, `rolinherit`, `rolbypassrls`, `rolreplication`, login state), with ordinary runtime proving `NOSUPERUSER`, `NOCREATEDB`, `NOCREATEROLE`, `NOBYPASSRLS`, and `NOREPLICATION`;
- direct/indirect memberships and membership `INHERIT`, `SET`, and `ADMIN` options;
- effective `session_user`/`current_user` and privileges for every actual Rails web/background-job identity after initial connection, checkout, reconnect, and credential rotation;
- database/schema/table/column/sequence/function owners, grant options, `PUBLIC` grants, direct ACLs, and access inherited through every membership path;
- default privileges for every object-creating owner role;
- exact function security mode, owner, fixed trusted `search_path`, language, signature, and effective PUBLIC/direct/inherited EXECUTE exposure;
- trigger definitions/enabled state and protected-object ownership;
- parameter SET privilege relevant to `session_replication_role`.

### 12.2 Negative runtime tests

Using the actual production-like non-owner runtime login, assert permission denial or the reviewed protected failure for:

1. UPDATE and DELETE of Phase 1 and future P2 audit rows.
2. TRUNCATE of protected audit/Catalog relations.
3. disabling, dropping, renaming, or replacing append-only/Catalog triggers.
4. altering/dropping protected tables, constraints, indexes, schemas, or functions.
5. creating objects in trusted schemas or shadowing privileged function dependencies.
6. replacing security-sensitive functions or invoking unapproved signatures.
7. setting `session_replication_role` away from `origin`, acquiring replication privileges, altering a role to `REPLICATION`, or otherwise enabling replication-related bypass behavior; inventory must also prove `rolreplication = false`.
8. assuming Database/Platform Owner, migration-owner, application-object-owner, optional operation-function-owner, or break-glass roles through direct/indirect membership, inheritance, `SET ROLE`, `ADMIN OPTION`, grant options, or equivalent PostgreSQL administration paths.
9. obtaining or using external database/platform administration credentials, tokens, instance identity, provider permissions, or control-plane operations available in the deployment environment; absence of such access is verified from the actual Rails web/job runtime identity and environment without exposing secrets.
10. granting roles/privileges or creating roles.
11. direct Catalog DELETE and arbitrary lifecycle UPDATE/INSERT that bypasses the selected operation seam.
12. multi-statement Variant flag/status bypass through ordinary runtime SQL.
13. cross-Brand target substitution or forged Actor/Brand/capability/session context.
14. bypassing Package B CHECK/FK/unique/deferred/no-Purge integrity controls.

Each test records expected SQLSTATE, authenticated/current role, committed state, and absence of unauthorized audit/mutation effects. It must not log credentials or sensitive target data.

### 12.3 Positive and atomicity tests

- permitted ordinary non-Catalog application operations retain only their documented access;
- each authorized Package C lifecycle use case succeeds through the selected seam for valid P1 evidence;
- exact Category→Product→Variant locking and deferred checks remain effective;
- the required P2 event and lifecycle mutation commit together on one connection/transaction;
- injected P2 validation/serialization/constraint/insert failure rolls back lifecycle state;
- Domain/mutation/constraint failure leaves no committed success event;
- connection/commit failure is never reported as success;
- existing Phase 1 AuditEvent insert and UPDATE/DELETE protection behavior remains intact;
- fresh migration, A1/Package B/P2/P3 upgrade, rollback/refusal, injected partial failure/recovery, and `structure.sql` equivalence remain valid;
- web and every background-job pool retain the expected runtime identity after checkout/reconnect/rotation;
- migration succeeds only with the migration path and cannot be performed by runtime.

### 12.4 Operation-alternative-specific evidence

If privileged functions are selected, tests also prove that the optional non-login owner owns only the approved operation functions and no application schema or Catalog/Audit table; has only minimum table/audit privileges; and is not assumable by Rails. Tests verify a fixed `search_path` containing only explicitly trusted schemas with `pg_temp` last, schema-qualified security-sensitive objects, operator/type/cast and other shadowing resistance, absence of unreviewed dynamic SQL, exact-signature grants, atomic revocation of default `PUBLIC EXECUTE`, effective EXECUTE denial through direct/indirect/PUBLIC paths, no function replacement, P1 provenance binding, lock order, and atomic audit failure. If constrained dynamic SQL is unavoidable, its construction strategy requires separate review and adversarial tests. If a separate executor is selected, tests prove command authenticity, credential isolation, transaction ownership, failure propagation, and no deferred retry/idempotency assumption.

### 12.5 Design acceptance

P3 design review can pass only when:

- every C0-R09/R10 requirement maps to a principal, privilege, seam, threat, and future test;
- C0-R07/C0-CAT-07 atomicity and C0-CAT-06 Brand isolation remain intact;
- P1 remains the sole authorization authority;
- Package B invariants and Package C lock/transaction contracts are not weakened;
- the selected mechanism, if any, resolves trusted-context provenance and SQL-injection bypass risk;
- runtime has no direct or indirect membership, inherited privilege, `SET ROLE`, `ADMIN OPTION`, grant-option, credential, control-plane, or equivalent administrative path to Database/Platform Owner, application-object-owner, migration, optional-operation-function-owner, or break-glass authority;
- P2/Phase 1 compatibility is explicit;
- C0-R05/R08/R11 remain deferred;
- implementation and production-readiness claims remain absent.

## 13. Open decisions, prerequisites, and risks

### 13.1 Owner decisions required

- break-glass approval, activation, dual-control/emergency, duration, notification, and post-use review policy in §10.2;
- any future production audit reader/export/retention governance remains deferred under C0-R08 rather than decided here.

No new Owner decision is required to preserve the mandatory C0-R10 prohibitions. Selecting the technical operation mechanism requires technical/Owner design approval and explicit implementation authorization, not invention of business policy.

### 13.2 External prerequisites

- implemented/reviewed P1 trusted authorization provider and target binding;
- selected/implemented P2 persistence representation and append adapter;
- reviewed Package C Application operations and unit-of-work seam;
- production/platform ability to provision separate principals, ownership, memberships, parameter privileges, and evidence;
- explicit persistence/operation mechanism prototype or proof addressing provenance/SQL injection;
- migration, credential-management, monitoring, incident, backup/restore, and pool-rotation design;
- production-like PostgreSQL role/ACL/negative/atomicity evidence;
- separate implementation authorization with exact SQL/migrations/config/tests/files.

### 13.3 Principal risks

- treating local/CI `postgres` success as least-privilege evidence;
- granting runtime membership that silently inherits or can `SET ROLE` to privileged authority;
- leaving runtime as table/function owner;
- broad schema CREATE or PUBLIC EXECUTE exposing current/future functions;
- trusting session GUCs or function parameters as P1 evidence;
- using a privileged function that duplicates or diverges from Domain/authorization logic;
- granting table UPDATE alongside a function seam, recreating direct-DML bypass;
- allowing after-commit/best-effort audit or separate transaction commits;
- breaking Phase 1 Branch-scoped audit while adding P2;
- disabling Package B triggers/constraints or changing isolation to simplify an operation;
- loading migration/break-glass credentials into runtime pools/workers;
- inventing retry/idempotency or audit-governance defaults;
- claiming protection against superusers/infrastructure administrators that PostgreSQL privileges cannot provide.

## 14. PostgreSQL behavior references

The technical proposals above were checked against PostgreSQL 18 primary documentation:

- [Privileges](https://www.postgresql.org/docs/18/ddl-priv.html): table/schema/function privileges, ownership, grant options, and default PUBLIC behavior.
- [Role Membership](https://www.postgresql.org/docs/18/role-membership.html) and [SET ROLE](https://www.postgresql.org/docs/18/sql-set-role.html): `INHERIT`, `SET`, membership chains, and effective role identity.
- [CREATE FUNCTION](https://www.postgresql.org/docs/18/sql-createfunction.html): `SECURITY DEFINER`, fixed trusted `search_path`, and revoking default PUBLIC EXECUTE.
- [Client Connection Defaults](https://www.postgresql.org/docs/18/runtime-config-client.html): `session_replication_role` requires superuser or appropriate parameter SET privilege and can suppress ordinary triggers/rules in replica mode.
- [Function Security](https://www.postgresql.org/docs/18/perm-functions.html): untrusted schema/name-resolution risks.

These references support PostgreSQL behavior only. They do not prove AFTER FOUR roles, grants, topology, or controls exist.

## 15. Verdict and implementation authorization boundary

### `DESIGN_REVIEW_REQUIRED`

P3 now defines the threat model, proposed principal/ownership topology, explicit least-privilege matrix, operation-specific seam alternatives, append-only/Catalog protection requirements, deployment lifecycle, break-glass governance questions, cross-milestone interfaces, and future evidence contract.

P3 is **not implementation-ready or authorized**. No final operation-specific mechanism is selected because trusted P1 provenance under SQL injection and the DDD/atomicity trade-offs require a separately authorized prototype/review. Production principal capabilities and operational governance remain unverified.

No source code, migration, schema, trigger, function, role, grant, revocation, database, test, runtime configuration, credential, P1/P2/Package C implementation, Identity Milestone 2B work, public API, deployment, or production use is authorized by this document. Separate Owner/design review and explicit implementation authorization with exact scope are required.

This document changes no Owner decision, deferred status, ADR status, CAT-TRR status, or existing Phase 1/Package B behavior.
