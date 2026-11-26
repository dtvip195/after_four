# AFTER FOUR — Organization Audit PostgreSQL Design

**Design date:** 2026-11-26

**Status:** `DESIGN_ONLY`

**Final verdict:** `READY_FOR_NARROW_READ_ONLY_ADVERSARIAL_RE_REVIEW`

**Current external-review lifecycle:** `EXTERNAL_REVIEW_NOT_YET_PERFORMED`

> **Decision closure — 2026-11-27.** The Owner confirmed local decisions `AUD-DEC-01` through `AUD-DEC-06`. Slice 1 is an empty-catalog, no-producer foundation; uses a narrow exact-signature `SECURITY DEFINER` append function; identifies one attempt by **Organization + Producer + Stable Attempt Key**; forbids Branch; enables only the human actor shape; and adopts separated database duties. These local IDs are not ODB allocations. The complete append-function and role-custody specifications are in [Organization-Level Audit Security Design Closure](organization_level_audit_security_design_closure.md). They supersede the abbreviated function body and proposal labels in this earlier design without authorizing implementation.

> **Independent-review remediation — 2026-11-27.** `ISR-AUD-001` removes the previously reserved Branch column/FK/catalog mode and every other Branch representation from the new Slice 1. `ISR-AUD-002` adds catalog-array integrity and delegates the authoritative NULL-safe function predicate to the security closure. `ISR-AUD-003` delegates all prerequisites to the staged matrix in that closure. These findings are design-remediated, not closed, and await focused independent re-review.

> **Security remediation round 2 — 2026-11-27.** The focused re-review verified `ISR-AUD-001/002`, found `ISR-AUD-003` partially remediated and added `ISR-AUD-004`–`006`. The [security closure](organization_level_audit_security_design_closure.md) now authoritatively defines the ASCII identifier grammar, database/parameter privilege coverage, evidence timing and Audit-owned failure-class registration. This physical design is synchronized below; the remediations remain pending independent follow-up review.

> **Security remediation round 3 — 2026-11-27.** `ISR-AUD-007`–`010` are remediated in design by element-wise catalog-array helpers, project SQLSTATE `AUE01`, transaction-local function dispositions with post-commit Application finalization, and finite occurrence-time checks. The decision package's stale Branch/system-test wording is also corrected. These changes await focused independent re-review and authorize no SQL execution or implementation.

> **Security remediation round 4 — 2026-11-27.** `ISR-AUD-011/012` are remediated in design by a mandatory atomic helper-version-change protocol that recreates and fully validates every dependent CHECK under write quiescence, and by distinct `PendingAppendReceipt` and `CommittedAppendResult` contracts owned at the outermost transaction boundary. These corrections await focused independent re-review and authorize no SQL execution.

> **ISR-AUD-013 remediation — 2026-11-27.** The two catalog-array helpers now reject duplicate elements for `allowed_outcomes`, `allowed_metadata_keys` and `required_metadata_keys` using exact, case-sensitive C-collation comparison. They do not trim, fold, normalize, deduplicate, sort or reorder. Each reviewed registration fixes one stable array order; Application projection, catalog fixtures, definition hashing and release comparison preserve and compare that representation positionally. This remains a design-only remediation pending independent review.

> **ISR-AUD-013 remediation round 2 — 2026-11-27.** Projection and hashing now defer to the exact language-neutral `after-four.audit-registration-projection` version-1 binary contract in the [logical contract §10.1.1–10.1.5](organization_level_audit_logical_contract_design.md#1011-authoritative-registration-projection-identity). PostgreSQL values are validated and mapped to typed logical fields; PostgreSQL array text, JSON or ad hoc release serialization is never canonical. This remains documentation-only and pending focused independent review.

> **Authorization-readiness consolidation — 2026-11-27.** Internal parallel review added `ISR-AUD-014`–`023`; re-review added `ISR-AUD-024`–`030`. This design now makes Empty-Slice runtime isolation, owner/function EXECUTE distinction, RLS/function/trigger-catalog assertions, exact concurrency-safe rollback/owner assumption, the `Platform::AuditEvidence` module boundary and PostgreSQL-compatible text-domain requirements explicit. Internal review is not the required external independent security review.

> **P0 internal-review remediation — 2026-11-27.** `ISR-AUD-031`–`039` are remediated in design by removing the replay `FOR SHARE`; applying explicit deterministic C collation to all collatable identity/policy storage, indexes and comparisons; correcting global default-function privileges; enumerating all PostgreSQL 18 table privileges; constraining the migrator; defining the module-local shared-pool Active Record base and static/runtime enforcement split; requiring structured SQLSTATE/transaction unwind; and making UTF-8 an install/load/restore invariant. These changes are documentation-only, remain pending review and executable evidence, and create no implementation authority.

> **Final design clarification — 2026-11-27.** The preceding clarification introduced Rails/transaction identity checks and separate server/client encoding lifecycle requirements for `ISR-AUD-036/039`; the later five-finding remediation below supersedes its narrower identity and session wording. Both remain open for focused re-review and later authorized executable evidence.

> **ISR-AUD-036/039/040/041/042 design remediation — 2026-11-27.** The canonical security design requires a lease-holding outer wrapper to reject ambient transactions, open the boundary itself and alone issue the supplied-adapter capability; joined scopes reuse it while real savepoints/nested issuers fail closed. Restore acceptance uses a non-reusable attempt, unique invocation, exclusive target-generation fence and atomic `QUARANTINED -> ACCEPTED` transition. The subsequent narrow review verified `ISR-AUD-039/040/042` at design level and returned `ISR-AUD-036/041` for the final micro-remediation recorded below; all five still require later authorized executable evidence.

> **Final micro-remediation — 2026-11-27.** The shared transaction seam is wrapper-owned participation only: the designated outer wrapper proves its adapter is idle, opens and owns the transaction, and issues the sole capability; joined inner services may reuse it, while pre-existing ambient or arbitrary caller-owned transactions remain unsupported absent a separately approved protocol. PostgreSQL parse/resolution/bind/decode/conversion failures before function entry are now distinct from the first in-function exact-session guard; only the latter promises `AUE02`, while both paths fail closed and unwind. `ISR-AUD-036/041` remain pending final narrow read-only verification and later executable evidence.

This document translates the approved [Organization-level Logical Audit Contract](organization_level_audit_logical_contract_design.md) into a PostgreSQL design. It is documentation only. It creates no migration, relation, role, grant, function, trigger, package, catalog entry, event writer, reader, or implementation authority.

## 1. Executive recommendation

Create a separate `public.organization_audit_events` store and a migration-managed, initially empty `public.organization_audit_event_catalog`. The existing Branch-level `public.audit_events` table, data, writers, and trigger remain unchanged. There is no backfill and no ordering relationship between the stores.

Keep the Audit Evidence module deep: callers learn one append interface, while PostgreSQL enforcement, approved-catalog lookup, server persistence time, idempotent replay, conflict detection, metadata shape checks, and append-only protections remain inside the implementation.

Use a narrowly scoped `SECURITY DEFINER` append function rather than granting direct table `INSERT`. Among non-owner principals, Empty Slice 1 grants explicit exact-signature `EXECUTE` only to the NOLOGIN `af_audit_appender`; the non-login function owner retains inherent owner execution rights. `af_runtime` can assume neither role, so no production caller can invoke the function. A later separately authorized first producer may grant reviewed appender membership. Neither appender nor runtime receives base-table `SELECT`, `INSERT`, `UPDATE`, `DELETE`, `TRUNCATE`, ownership, schema creation, trigger-control, or function-replacement privilege. The function owner receives only the table/catalog privileges needed by the function and owns no tables or schemas.

The proposed database catalog is not runtime registration. It is an empty deny-by-default allowlist whose future rows may be added only by an approved migration carrying exact Owner decision provenance. With no approved catalog rows, every append is rejected.

For the Owner-confirmed empty Slice 1, a first catalog entry, event failure class, and system-producer provenance are intentionally excluded rather than implementation prerequisites. Its remaining design-to-implementation gate is independent security review of the complete function/role package, a production-parity disposable-role provisioning and verification plan, and separate written Slice 1 authorization. Actual disposable role/test evidence follows authorization and precedes implementation acceptance; environment-specific provisioning evidence precedes production deployment. Event-specific metadata, failure, trust, privacy, and producer decisions remain prerequisites to a later first production append.

## 2. Status legend and verified baseline

| Label | Meaning |
|---|---|
| `OWNER_CONFIRMED` | Explicit decision supplied for this work or recorded canonically |
| `VERIFIED_EXISTING` | Present in the inspected repository at the stated baseline |
| `TECHNICAL_RECOMMENDATION` | Reviewable design choice; not implemented or Owner-approved merely by inclusion |
| `PROPOSED_NOT_APPROVED` | Requires a later Owner/security/operational decision before implementation/use |

Repository baseline inspected:

| Item | Value |
|---|---|
| Branch | `development` |
| HEAD | `b49a8827be53797b30ea1d7cb47791e7c74e7231` |
| Upstream | `origin/development` |
| Upstream delta | `0 / 0` |
| Existing user changes | Original design began with two untracked inputs; remediation baseline has all five audit research documents untracked and preserved |

### 2.1 Confirmed constraints

- `OWNER_CONFIRMED`: Audit Evidence is a deep platform module/package, not a business Bounded Context.
- `OWNER_CONFIRMED`: initial Organization audit uses a separate physical store; existing Branch `audit_events` remains unchanged, with no backfill or global ordering claim.
- `OWNER_CONFIRMED`: failure semantics are class-specific and only Owner-approved event types may be recorded.
- `OWNER_CONFIRMED`: human actors originate from trusted Identity evidence; system events require verifiable producer provenance and never fabricate a User.
- `VERIFIED_EXISTING`: PostgreSQL is the schema baseline and Rails uses `structure.sql` ([database ADR](../architecture/adr/0003-postgresql-version-baseline.md), [application configuration](../../backend/config/application.rb)).
- `VERIFIED_EXISTING`: project UUID records use `gen_random_uuid()` and Organization/Brand/Branch use restrictive foreign keys ([reference migration](../../backend/db/migrate/20261115200000_create_reference_foundation.rb)).
- `VERIFIED_EXISTING`: existing Branch audit uses callbacks plus a `BEFORE UPDATE OR DELETE` trigger, but current development/test ownership can bypass it ([audit trigger](../../backend/db/migrate/20261114203000_protect_audit_events_append_only.rb), [cleanup bypass](../../backend/spec/support/audit_event_cleanup.rb)).

## 3. Logical-to-physical mapping

### 3.1 Proposed relations

| Relation | Purpose | Initial contents |
|---|---|---|
| `organization_audit_event_catalog` | Migration-owned deny-by-default allowlist and physical enforcement inputs for approved `(producer, event type, version)` tuples | Empty until exact Owner approvals are implemented by a separately authorized migration |
| `organization_audit_events` | Immutable Organization-scoped evidence rows | Empty |

No general registration table is writable by the runtime. Catalog history is append-only: changed semantics require a new event version; an approved entry is not edited in place.

### 3.2 Event columns

| Column | PostgreSQL representation | Why / logical invariant | Enforcement and remaining bypass | Test |
|---|---|---|---|---|
| `id` | `uuid NOT NULL PRIMARY KEY` | Immutable event identity assigned by Audit Application | Database PK; supplied to append function. Schema owner can bypass | Duplicate ID rejection; returned ID matches insert |
| `organization_id` | `uuid NOT NULL` | Exactly one tenant scope | FK to `organizations(id)` with `ON DELETE RESTRICT`; function/application trust still required against client spoofing | Missing/nonexistent Organization rejection; cross-Organization contract tests |
| `registration_id` | `uuid NOT NULL` | Internal identity of the immutable Audit-owned approved registration | Exact catalog FK and function lookup; producer cannot supply it | Unknown/mismatched registration rejected |
| `producer_key` | `varchar(100) NOT NULL` | Event-meaning owner and catalog namespace | Composite catalog FK and function lookup; exact values require Owner approval | Unknown producer rejected |
| `event_type` | `varchar(160) NOT NULL` | Stable namespaced event meaning | Composite catalog FK and function lookup | Unknown type/version rejected |
| `event_version` | `smallint NOT NULL` | Stable envelope/metadata interpretation | Check `> 0`; composite catalog FK | Zero/negative/unregistered version rejected |
| `occurred_at` | `timestamptz NOT NULL` | Finite authoritative producer decision/occurrence time | Application and function reject non-finite values; relation uses `isfinite`; database cannot prove it was server-derived or apply an unapproved event-specific skew window | NULL/infinity/finite/extreme/skew/replay tests |
| `recorded_at` | `timestamptz NOT NULL DEFAULT clock_timestamp()` | Database persistence time distinct from occurrence time | Database assigns; function does not accept caller value | Caller cannot set through interface; replay returns original |
| `actor_type` | `varchar(16) NOT NULL` | Human actor only in Slice 1 | Table/catalog checks require exact `human`; function does not accept actor type | Non-human rejected |
| `actor_user_id` | `uuid NULL` | Trusted authenticated User for human event | Required for human, forbidden for system. No User FK initially to avoid unapproved retention/deletion coupling and false Organization guarantee | Shape rejection; trusted-context integration later |
| `actor_session_id` | `uuid NULL` | Safe Session lookup provenance where catalog requires it | Human-only; function checks catalog requirement. No Session FK due retention/lifecycle coupling | Required/forbidden catalog cases |
| `system_producer_key` | `varchar(120) NULL` | Reserved future provenance shape | Must be null in Slice 1; not accepted by function | Non-null storage rejected |
| `system_producer_version` | `smallint NULL` | Reserved future provenance version | Must be null in Slice 1; not accepted by function | Non-null storage rejected |
| `system_invocation_id` | `uuid NULL` | Reserved future invocation shape | Must be null in Slice 1; not accepted by function | Non-null storage rejected |
| `correlation_id` | `uuid NULL` | Groups one workflow without granting authority | Catalog decides requiredness; not unique and not authorization evidence | Requiredness and round-trip |
| `causation_id` | `uuid NULL` | Immediate durable cause when one exists | Catalog decides requiredness; no FK because cause may be a command or event in another store | Requiredness; no ordering inference |
| `target_type` | `varchar(120) NULL` | Catalog-owned resource semantics | Paired with target ID; function checks exact catalog target type/requiredness | Pair/type/requiredness rejection |
| `target_id` | `uuid NULL` | Opaque target identity | Paired check; no polymorphic FK or producer Infrastructure access | Pair/requiredness rejection |
| `outcome` | `varchar(24) NOT NULL` | Known operation result | Function checks membership in catalog-approved outcomes; generic format check only at table | Disallowed outcome rejection |
| `idempotency_key` | `varchar(255) NOT NULL` | Owner-confirmed Stable Attempt Key | Unique with Organization + Producer only; value must be nonblank. Type/version are replay-comparison fields, not identity fields. | Matching/conflicting/concurrent and cross-type/version replay tests |
| `metadata` | `jsonb NOT NULL DEFAULT '{}'::jsonb` | Versioned minimal event facts | Object check; function checks approved/required keys and byte limit; Audit Application enforces types/semantics/secrets | Unknown/missing key, size, nesting/type, secret tests |

The length limits are `TECHNICAL_RECOMMENDATION` security and operability parameters, not business policy. They must be verified against the first approved catalog before implementation. `recorded_at` uses PostgreSQL server time; no constraint asserts `recorded_at >= occurred_at`, because clock skew, late evidence, and imported authoritative occurrence time can make that assertion false.

### 3.3 Catalog columns

| Column group | Purpose |
|---|---|
| `registration_id` | Internal UUID binding the Audit-owned immutable registration to this database enforcement projection; never producer-controlled |
| `producer_key`, `event_type`, `event_version` | Primary key and approved event identity |
| `actor_type` | Fixed to `human` in Slice 1; system activation requires a reviewed migration and separate decision |
| `system_producer_key`, `system_producer_version` | Null in Slice 1; reserved only as a future schema shape |
| `session_reference_mode`, `target_reference_mode`, `correlation_mode`, `causation_mode`, `idempotency_mode`, `system_invocation_mode` | Closed `forbidden`/`optional`/`required` requirements enforced by append function |
| `target_type` | Exact target type when target is optional/required |
| `allowed_outcomes` | Nonempty closed outcome list for this event version |
| `allowed_metadata_keys`, `required_metadata_keys` | Closed metadata key allowlist and required subset |
| `metadata_max_bytes` | Per-version upper bound approved during security review |
| `failure_class` | Projection of the immutable class owned by the Audit Application registration; callers cannot supply or choose it |
| `owner_decision_reference`, `owner_decision_date` | Approval provenance; no catalog row without it |

The database catalog enforces identity, actor/provenance shape, reference modes, allowed outcomes, allowed metadata keys, and size. Event-specific value types and semantic relationships remain Audit Application validation because native PostgreSQL has no built-in JSON Schema facility and no new extension is authorized.

The version-controlled Audit registration definition is authoritative. The catalog is a migration-owned enforcement projection installed by the same reviewed release. The adapter supplies the internal `registration_id` and resolved failure class; neither is producer-controlled. The function requires both to match the tuple and catalog projection. The event relation's composite FK binds registration UUID and tuple against direct-write mismatch. Release verification compares registration UUID, producer/type/version, failure class and schema policy one-to-one. Missing, extra or mismatched projections abort installation or producer activation. Registration mutation after use is forbidden; semantic or failure-class change requires a new event version and registration UUID. See [Security Design Closure §4.2.3](organization_level_audit_security_design_closure.md#423-failure-class-authority-and-registration-binding).

The three catalog arrays represent logical sets through one explicit ordered representation selected in the reviewed registration manifest. The canonical version-1 binary contract, exact 21-field order, type/presence/length framing, scalar/array encoding, SHA-256 bytes and conformance-fixture schema are authoritative in [Logical Contract §10.1.1–10.1.5](organization_level_audit_logical_contract_design.md#1011-authoritative-registration-projection-identity). PostgreSQL inspection supplies validated typed values in that field order; it does not hash PostgreSQL array text or invent JSON/delimiter serialization. Duplicate-bearing arrays are invalid, and differently ordered arrays do not match the existing registration's bytes or digest. Membership and required-key subset semantics remain order-independent and unchanged.

## 4. Proposed DDL — documentation only

The following is a review candidate, not an executable migration. Role names, limits, first catalog rows, and exact function body require approval and environment-specific review. The exact target database must report `server_encoding = 'UTF8'`, and every migration/load/restore/application session must report `client_encoding = 'UTF8'`. Creation, migration, `structure.sql`, logical restore with/without `--create`, physical restore, Rails connection, service acceptance and monitoring use distinct gates in the [Security Design Closure UTF-8 lifecycle matrix](organization_level_audit_security_design_closure.md#utf-8-lifecycle-enforcement-matrix); no check substitutes for another path. PostgreSQL may fail during parse, function resolution, parameter binding/protocol decoding or argument conversion before the PL/pgSQL body begins; that native failure is not guaranteed to be `AUE02` and must fail closed. After successful function entry, the append function's first control checks `pg_catalog.current_setting('server_encoding')` and `pg_catalog.current_setting('client_encoding')` on the exact executing session and raises project SQLSTATE `AUE02` before function-body argument validation or catalog/event access on mismatch. Both paths produce no successful receipt/result and require whole-transaction unwind without later statements, partially valid continuation or alternate-connection fallback. PostgreSQL does not permit a subquery directly in a `CHECK` constraint, so immutable element-wise helper functions perform the required `unnest` checks. Their definitions, ownership, grants and hashes are part of the same reviewed migration surface as the tables and append function.

### 4.1 Catalog and event tables

```sql
CREATE FUNCTION public.audit_evidence_outcomes_well_formed(p_values text[])
RETURNS boolean
LANGUAGE sql
IMMUTABLE
PARALLEL SAFE
SET search_path TO pg_catalog, pg_temp
AS $function$
  SELECT p_values IS NOT NULL
     AND array_ndims(p_values) = 1
     AND array_lower(p_values, 1) = 1
     AND cardinality(p_values) > 0
     AND array_position(p_values, NULL) IS NULL
     AND NOT EXISTS (
       SELECT 1
         FROM unnest(p_values) AS element(value)
        WHERE value COLLATE "C"
          !~ '^[a-z][a-z0-9]*(?:[._-][a-z0-9]+)*$'
     )
     AND NOT EXISTS (
       SELECT 1
         FROM unnest(p_values) AS element(value)
        GROUP BY element.value COLLATE "C"
       HAVING count(*) > 1
     );
$function$;

CREATE FUNCTION public.audit_evidence_metadata_keys_well_formed(p_values text[])
RETURNS boolean
LANGUAGE sql
IMMUTABLE
PARALLEL SAFE
SET search_path TO pg_catalog, pg_temp
AS $function$
  SELECT p_values IS NOT NULL
     AND (
       (cardinality(p_values) = 0 AND array_ndims(p_values) IS NULL)
       OR (
         cardinality(p_values) > 0
         AND array_ndims(p_values) = 1
         AND array_lower(p_values, 1) = 1
       )
     )
     AND array_position(p_values, NULL) IS NULL
     AND NOT EXISTS (
       SELECT 1
         FROM unnest(p_values) AS element(value)
        WHERE value COLLATE "C" !~ '^[a-z][a-z0-9_]*$'
     )
     AND NOT EXISTS (
       SELECT 1
         FROM unnest(p_values) AS element(value)
        GROUP BY element.value COLLATE "C"
       HAVING count(*) > 1
     );
$function$;

ALTER FUNCTION public.audit_evidence_outcomes_well_formed(text[])
  OWNER TO af_schema_owner;
REVOKE ALL ON FUNCTION public.audit_evidence_outcomes_well_formed(text[])
  FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.audit_evidence_outcomes_well_formed(text[])
  TO af_audit_function_owner;

ALTER FUNCTION public.audit_evidence_metadata_keys_well_formed(text[])
  OWNER TO af_schema_owner;
REVOKE ALL ON FUNCTION public.audit_evidence_metadata_keys_well_formed(text[])
  FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.audit_evidence_metadata_keys_well_formed(text[])
  TO af_audit_function_owner;

CREATE TABLE public.organization_audit_event_catalog (
  registration_id uuid NOT NULL,
  producer_key varchar(100) COLLATE "C" NOT NULL,
  event_type varchar(160) COLLATE "C" NOT NULL,
  event_version smallint NOT NULL,
  actor_type varchar(16) COLLATE "C" NOT NULL,
  system_producer_key varchar(120) COLLATE "C",
  system_producer_version smallint,
  session_reference_mode varchar(12) COLLATE "C" NOT NULL,
  target_reference_mode varchar(12) COLLATE "C" NOT NULL,
  target_type varchar(120) COLLATE "C",
  correlation_mode varchar(12) COLLATE "C" NOT NULL,
  causation_mode varchar(12) COLLATE "C" NOT NULL,
  idempotency_mode varchar(12) COLLATE "C" NOT NULL,
  system_invocation_mode varchar(12) COLLATE "C" NOT NULL,
  allowed_outcomes varchar(24)[] COLLATE "C" NOT NULL,
  allowed_metadata_keys varchar(120)[] COLLATE "C" NOT NULL DEFAULT '{}',
  required_metadata_keys varchar(120)[] COLLATE "C" NOT NULL DEFAULT '{}',
  metadata_max_bytes integer NOT NULL,
  failure_class varchar(40) COLLATE "C" NOT NULL,
  owner_decision_reference varchar(200) COLLATE "C" NOT NULL,
  owner_decision_date date NOT NULL,
  CONSTRAINT organization_audit_event_catalog_registration_unique
    UNIQUE (registration_id),
  CONSTRAINT organization_audit_event_catalog_registration_tuple_unique
    UNIQUE (registration_id, producer_key, event_type, event_version),
  CONSTRAINT organization_audit_event_catalog_pkey
    PRIMARY KEY (producer_key, event_type, event_version),
  CONSTRAINT organization_audit_event_catalog_version_positive
    CHECK (event_version > 0),
  CONSTRAINT organization_audit_event_catalog_machine_identifiers
    CHECK (
      producer_key COLLATE "C" ~ '^[a-z][a-z0-9]*(?:[._-][a-z0-9]+)*$'
      AND event_type COLLATE "C" ~ '^[a-z][a-z0-9]*(?:[._-][a-z0-9]+)*$'
      AND failure_class COLLATE "C" ~ '^[a-z][a-z0-9]*(?:[._-][a-z0-9]+)*$'
      AND (
        target_type IS NULL
        OR target_type COLLATE "C" ~ '^[a-z][a-z0-9]*(?:[._-][a-z0-9]+)*$'
      )
    ),
  CONSTRAINT organization_audit_event_catalog_actor_allowed
    CHECK (actor_type = 'human'),
  CONSTRAINT organization_audit_event_catalog_system_shape
    CHECK (
      actor_type = 'human'
      AND system_producer_key IS NULL
      AND system_producer_version IS NULL
      AND system_invocation_mode = 'forbidden'
    ),
  CONSTRAINT organization_audit_event_catalog_modes_allowed
    CHECK (
      session_reference_mode IN ('forbidden', 'optional', 'required')
      AND target_reference_mode IN ('forbidden', 'optional', 'required')
      AND correlation_mode IN ('forbidden', 'optional', 'required')
      AND causation_mode IN ('forbidden', 'optional', 'required')
      AND idempotency_mode = 'required'
      AND system_invocation_mode = 'forbidden'
    ),
  CONSTRAINT organization_audit_event_catalog_target_shape
    CHECK (
      (target_reference_mode = 'forbidden' AND target_type IS NULL)
      OR
      (target_reference_mode IN ('optional', 'required') AND target_type IS NOT NULL)
    ),
  CONSTRAINT organization_audit_event_catalog_outcomes_nonempty
    CHECK (public.audit_evidence_outcomes_well_formed(allowed_outcomes::text[])),
  CONSTRAINT organization_audit_event_catalog_allowed_keys_well_formed
    CHECK (
      public.audit_evidence_metadata_keys_well_formed(
        allowed_metadata_keys::text[]
      )
    ),
  CONSTRAINT organization_audit_event_catalog_required_keys_well_formed
    CHECK (
      public.audit_evidence_metadata_keys_well_formed(
        required_metadata_keys::text[]
      )
    ),
  CONSTRAINT organization_audit_event_catalog_required_keys_allowed
    CHECK (required_metadata_keys COLLATE "C" <@ allowed_metadata_keys COLLATE "C"),
  CONSTRAINT organization_audit_event_catalog_metadata_limit_positive
    CHECK (metadata_max_bytes > 0)
);

CREATE TABLE public.organization_audit_events (
  id uuid NOT NULL,
  organization_id uuid NOT NULL,
  registration_id uuid NOT NULL,
  producer_key varchar(100) COLLATE "C" NOT NULL,
  event_type varchar(160) COLLATE "C" NOT NULL,
  event_version smallint NOT NULL,
  occurred_at timestamptz NOT NULL,
  recorded_at timestamptz NOT NULL DEFAULT clock_timestamp(),
  actor_type varchar(16) COLLATE "C" NOT NULL,
  actor_user_id uuid,
  actor_session_id uuid,
  system_producer_key varchar(120) COLLATE "C",
  system_producer_version smallint,
  system_invocation_id uuid,
  correlation_id uuid,
  causation_id uuid,
  target_type varchar(120) COLLATE "C",
  target_id uuid,
  outcome varchar(24) COLLATE "C" NOT NULL,
  idempotency_key varchar(255) COLLATE "C" NOT NULL,
  metadata jsonb NOT NULL DEFAULT '{}'::jsonb,
  CONSTRAINT organization_audit_events_pkey PRIMARY KEY (id),
  CONSTRAINT organization_audit_events_registration_catalog_fk
    FOREIGN KEY (registration_id, producer_key, event_type, event_version)
    REFERENCES public.organization_audit_event_catalog
      (registration_id, producer_key, event_type, event_version)
    ON DELETE RESTRICT,
  CONSTRAINT organization_audit_events_organization_fk
    FOREIGN KEY (organization_id)
    REFERENCES public.organizations(id)
    ON DELETE RESTRICT,
  CONSTRAINT organization_audit_events_version_positive
    CHECK (event_version > 0),
  CONSTRAINT organization_audit_events_occurred_at_finite
    CHECK (isfinite(occurred_at)),
  CONSTRAINT organization_audit_events_recorded_at_finite
    CHECK (isfinite(recorded_at)),
  CONSTRAINT organization_audit_events_machine_identifiers
    CHECK (
      producer_key COLLATE "C" ~ '^[a-z][a-z0-9]*(?:[._-][a-z0-9]+)*$'
      AND event_type COLLATE "C" ~ '^[a-z][a-z0-9]*(?:[._-][a-z0-9]+)*$'
      AND outcome COLLATE "C" ~ '^[a-z][a-z0-9]*(?:[._-][a-z0-9]+)*$'
      AND (
        target_type IS NULL
        OR target_type COLLATE "C" ~ '^[a-z][a-z0-9]*(?:[._-][a-z0-9]+)*$'
      )
    ),
  CONSTRAINT organization_audit_events_actor_shape
    CHECK (
      actor_type = 'human'
      AND actor_user_id IS NOT NULL
      AND system_producer_key IS NULL
      AND system_producer_version IS NULL
      AND system_invocation_id IS NULL
    ),
  CONSTRAINT organization_audit_events_target_pair
    CHECK ((target_type IS NULL) = (target_id IS NULL)),
  CONSTRAINT organization_audit_events_idempotency_nonblank
    CHECK (
      idempotency_key COLLATE "C"
        ~ '^[A-Za-z0-9][A-Za-z0-9._:/-]*$'
    ),
  CONSTRAINT organization_audit_events_metadata_object
    CHECK (jsonb_typeof(metadata) = 'object')
);
```

The catalog table is initially empty. The proposed DDL intentionally has no `updated_at`, mutable status, or runtime registration path. Event IDs have no database default because the logical contract assigns them in Audit Application; `recorded_at` has a database default because persistence time is database-owned. Every collatable identity and policy scalar/array is declared `COLLATE "C"`, so primary keys, unique constraints, composite FKs, indexes, equality, membership and subset operations inherit deterministic byte-oriented comparison rather than database-default locale behavior. Function predicates still use explicit C collation where an argument could otherwise carry the default. Normalized catalog acceptance must inspect the column/index collation identities.

The helper predicates validate each array element independently: a single `valid_one,valid_two` element is rejected and cannot masquerade as two valid elements. They also group exact element values under `COLLATE "C"` and reject any count greater than one. Empty metadata-key arrays are canonical and permitted; allowed outcomes are nonempty. Nonempty arrays must be one-dimensional with lower bound 1; SQL-NULL arrays are also prevented by column `NOT NULL`, and SQL-NULL elements are rejected explicitly. Required keys remain a C-collated subset of allowed keys. No helper repairs invalid input by deduplicating or reordering it.

#### 4.1.1 Helper dependency and version-change protocol

The direct dependency set is closed and reviewable:

| Helper | Direct dependent CHECK constraints |
|---|---|
| `public.audit_evidence_outcomes_well_formed(text[])` | `organization_audit_event_catalog_outcomes_nonempty` |
| `public.audit_evidence_metadata_keys_well_formed(text[])` | `organization_audit_event_catalog_allowed_keys_well_formed`; `organization_audit_event_catalog_required_keys_well_formed` |

`organization_audit_event_catalog_required_keys_allowed` does not call a helper, but remains part of the catalog-integrity acceptance set. No helper semantic change may be deployed as an unreviewed `CREATE OR REPLACE FUNCTION`. The mandatory version-change release is one database transaction and follows this logical order:

1. Quiesce every catalog migration/release writer. Acquire and retain an `ACCESS EXCLUSIVE` lock on `public.organization_audit_event_catalog` before changing either helper or dependent constraint. Runtime already has no catalog-write privilege, but that fact does not replace the lock.
2. Verify the expected prior helper definition hashes, owners, ACLs, volatility, search path and complete PostgreSQL dependency set. An unexpected dependent constraint or prior hash aborts the release.
3. Drop the three direct dependent CHECK constraints while the lock and transaction remain active. Do not expose or commit this intermediate state.
4. Replace the reviewed helper definition through the controlled schema-owner release path. Record a new version-controlled source/release identity and normalized definition hash; semantic changes are never treated as operational drift repair.
5. Recreate each direct dependent CHECK with its reviewed expression as `NOT VALID`, then run `VALIDATE CONSTRAINT` for each while the same lock, transaction and helper definition remain in force. This forced validation must scan every existing catalog row. Also inspect the unchanged required-subset constraint as valid.
6. Inspect `pg_constraint` and function catalogs before commit: all expected constraints exist, every expected `convalidated` value is true, dependency identities point to the reviewed helpers, owner/ACL/search-path/volatility match, the helper hashes match the reviewed release, and a direct predicate scan reports zero violating catalog rows.
7. Accept and commit the release only after all evidence matches. Release write quiescence only after commit. Any helper/constraint/validation/evidence failure aborts the transaction, restoring the prior helper and constraints atomically.

No catalog row is silently repaired, updated, deleted or grandfathered. If an existing row fails the new grammar, validation fails and the release rolls back. Investigation must determine whether the proposed grammar is wrong or a separately authorized forward remediation/new immutable registration is required; an already-used registration is never mutated to make validation pass.

Restore acceptance repeats definition-hash, dependency, constraint-expression, `convalidated` and zero-violation checks after restore and includes a disposable dump/restore rehearsal. Historical validation metadata from a different helper hash is insufficient. The restore must install the reviewed helper before dependent constraints are recreated and must establish the same full-row invariant.

Only the controlled migration authority acting through the non-login `af_schema_owner` path may replace helpers or dependent constraints. Runtime, appender, function owner and future reader receive no ownership, schema `CREATE`, or replacement authority. These are required operations and post-authorization test expectations, not executed SQL evidence.

### 4.2 Indexes

```sql
ALTER TABLE public.organization_audit_events
  ADD CONSTRAINT organization_audit_events_attempt_identity_unique
  UNIQUE (organization_id, producer_key, idempotency_key);

CREATE INDEX index_organization_audit_events_on_organization_recorded
  ON public.organization_audit_events
    (organization_id, recorded_at DESC, id DESC);

```

The PK supports event lookup and causation references without asserting a causation FK. The unique constraint serializes one stable attempt per Organization and Producer, including attempts whose replay changes type/version. The Organization/time index supports bounded integrity/reconciliation work; it does not grant a reader capability. Slice 1 has no Branch column, foreign key, target, index, constraint, validation path, or indirect Branch identity. Target, correlation, outcome, metadata GIN, and unrestricted JSONB indexes are deliberately omitted until approved query patterns exist.

### 4.3 Append-only trigger functions

```sql
CREATE FUNCTION public.audit_evidence_reject_row_mutation()
RETURNS trigger
LANGUAGE plpgsql
VOLATILE
PARALLEL UNSAFE
SET search_path TO pg_catalog, pg_temp
AS $$
BEGIN
  RAISE EXCEPTION 'Organization audit evidence is append-only'
    USING ERRCODE = '23514';
END;
$$;

CREATE TRIGGER organization_audit_events_reject_update_delete
BEFORE UPDATE OR DELETE ON public.organization_audit_events
FOR EACH ROW
EXECUTE FUNCTION public.audit_evidence_reject_row_mutation();

CREATE TRIGGER organization_audit_events_reject_truncate
BEFORE TRUNCATE ON public.organization_audit_events
FOR EACH STATEMENT
EXECUTE FUNCTION public.audit_evidence_reject_row_mutation();

CREATE TRIGGER organization_audit_catalog_reject_update_delete
BEFORE UPDATE OR DELETE ON public.organization_audit_event_catalog
FOR EACH ROW
EXECUTE FUNCTION public.audit_evidence_reject_row_mutation();

CREATE TRIGGER organization_audit_catalog_reject_truncate
BEFORE TRUNCATE ON public.organization_audit_event_catalog
FOR EACH STATEMENT
EXECUTE FUNCTION public.audit_evidence_reject_row_mutation();
```

The trigger is defense in depth. Runtime privileges remain the primary control. A table owner, function owner with replacement rights, superuser, or restore operator can bypass it; the design makes no absolute immutability claim.

### 4.4 Append function shape

The earlier abbreviated body is withdrawn because it exposed Branch/system inputs and used the superseded type/version-expanded conflict target. The complete review candidate—exact signature, element-wise defensive catalog validation, finite-time validation, insert/replay algorithm, project SQLSTATE `AUE01`, transaction-local dispositions, safe error mapping, concurrency behavior, and grant surface—is specified in [Security Design Closure §4](organization_level_audit_security_design_closure.md#4-complete-security-definer-append-specification). That specification is the only current function design for Slice 1. It is still design evidence, not executable migration authority.

## 5. Constraints and index rationale

| Mechanism | Database invariant | Application invariant still required | Privileged bypass |
|---|---|---|---|
| Organization FK | Organization exists and cannot be deleted while evidence references it | Trusted event scope and actor/resource Organization agreement | Owner/superuser/restore can alter/drop/disable constraints |
| Catalog composite FK | Event tuple existed in migration-owned allowlist | Catalog semantics and Owner provenance were correctly reviewed | Schema owner can alter catalog/constraint |
| Actor shape check | Slice 1 permits human shape only and null system fields | Human evidence was Identity-issued | Direct privileged DDL/restore |
| Target-pair check | Type and ID appear together | Target was scoped and semantics match producer | Same |
| Catalog array helper checks | Every outcome/key element satisfies its scalar grammar; dimensions/lower bound/null/empty policy is canonical | Exact event schema and Owner approval | Helper owner/superuser can replace or bypass |
| Finite-time checks | `occurred_at` and database-owned `recorded_at` cannot be PostgreSQL infinity values | Event-specific source, acceptable past age/future skew, clock and delayed-event policy | Same |
| JSON object check | Metadata is an object | Exact types, safe values, and secret/PII absence | Same |
| Attempt-identity unique constraint | One row per Organization/producer/stable attempt key | Stable key represents one logical attempt; distinct attempts are not collapsed | Constraint owner/superuser |
| Organization/time index | Efficient bounded reconciliation ordering | No total order or reader authority | Not an integrity control |
| Mutation/truncate triggers | Ordinary SQL cannot rewrite/remove rows | Privilege topology, monitoring, backups/restores | Owner/superuser can bypass |

No check compares `occurred_at` with `recorded_at`. No FK links actor User, Session, target, correlation, or causation because those relationships cross lifecycle/retention domains or may refer to non-audit commands. Adding such FKs would silently decide preservation/deletion coupling that remains unapproved.

## 6. Branch boundary

The existing legacy `audit_events` relation remains Branch-scoped and unchanged. It is not part of the new Organization-level Slice 1 contract.

The new Slice 1 design contains no Branch reference. A Slice 1 implementation must not introduce a Branch column, Branch foreign key, Branch target reference, Branch validation path, test fixture containing Branch identity, or indirect Branch identity. Static verification must inspect PostgreSQL columns, constraints, indexes, function signatures/bodies, catalog columns, package contracts, and fixtures for accidental Branch references. Any future Organization-store use of Branch requires a separate Owner decision, a new ancestry/integrity design, and independent review; no future shape is reserved in Slice 1.

## 7. Append-only enforcement and privilege model

### 7.1 Direct INSERT versus `SECURITY DEFINER`

| Option | Benefits | Risks | Assessment |
|---|---|---|---|
| Direct `INSERT` grant to runtime appender | Simple; transaction participation is natural; fewer privileged functions | Runtime can bypass catalog/metadata/provenance validation, cannot safely inspect replay without broader `SELECT`, and can insert arbitrary rows if application code is compromised | Rejected for this store |
| Narrow `SECURITY DEFINER` append function | Runtime has no table rights; function atomically validates catalog, appends, compares replay, and returns only minimal result | Function becomes a privileged attack surface; unsafe owner/search path/default EXECUTE/dynamic SQL/casts can bypass controls | Recommended with strict controls |

### 7.2 Proposed roles

Role names are candidates, not approved production identifiers.

| Role | Login/ownership | Required privileges | Explicitly absent |
|---|---|---|---|
| `af_schema_owner` | `NOLOGIN`; owns Audit tables, indexes, trigger functions, and constraints | DDL ownership only through controlled migration process | Runtime membership; ordinary application credential |
| `af_migrator` | Controlled deployment login; `NOSUPERUSER NOCREATEROLE NOCREATEDB NOREPLICATION NOBYPASSRLS`; its own `INHERIT` setting grants no owner access because owner memberships are recorded `SET TRUE, INHERIT FALSE, ADMIN FALSE`, time-bounded and revoked at handoff | Create/alter/drop only approved objects while explicitly assuming the required owner; install/reconcile grants | Runtime traffic; standing/inherited/admin owner membership; retained schema `CREATE`; provider-control-plane power |
| `af_audit_function_owner` | `NOLOGIN`; owns only exact append function(s), not schema/tables | `INSERT` and narrowly required `SELECT` on event table; `SELECT` on catalog; sequence privileges none | Table/schema ownership; `UPDATE`, `DELETE`, `TRUNCATE`, `REFERENCES`, `TRIGGER`, `MAINTAIN`, alter; assumable runtime membership |
| `af_audit_appender` | `NOLOGIN`; not granted to application runtime in Empty Slice 1 | Exact-signature `EXECUTE` on append function only | Table/catalog privileges; function ownership/replacement; role administration; Empty-Slice runtime membership |
| `af_audit_reader` | `NOLOGIN`; no grants in this phase | Reserved design identity only | Base-table SELECT, export, hold, delivery; no read policy is approved |
| `af_audit_break_glass` | No standing application membership; time-bound operational issuance | Separately approved diagnostic access with external access logging | Automatic mutation/trigger-disable/schema ownership; no routine use |
| Backup/restore operator | Infrastructure-controlled, separate credential | Physical backup/restore under approved runbook | Application availability; claim that restore cannot rewrite evidence |

Role creation is cluster-level infrastructure provisioning, not reliably represented by `structure.sql`. The Rails migration should fail safely if required roles/ownership prerequisites are absent rather than silently leaving the runtime as table owner. Development/test may use dedicated fixtures, but superuser-based local success is not production privilege evidence.

### 7.3 Required grants and revocations

The authoritative effective-privilege target, per-owner default-privilege treatment, ordered role/object installation and handoff, restore reconciliation, and negative privilege matrix are in [Security Design Closure §6.4](organization_level_audit_security_design_closure.md#64-authoritative-privilege-installation-specification). This document does not reproduce a shorter grant fragment because it could be mistaken for a complete installation.

The function owner must not inherit schema/table ownership and runtime must have no direct or nested `SET ROLE` path to it. Runtime has database `CONNECT` but no Empty-Slice membership in appender. Runtime/appender has no database `CREATE`/`TEMPORARY`, parameter `SET` for `session_replication_role`, `ALTER SYSTEM` or equivalent configuration/control-plane path. Appender has only the minimum schema `USAGE` needed for exact function resolution, never schema `CREATE` or table/catalog access. For each relation and relevant principal, evidence must enumerate all PostgreSQL 18 table privileges—`SELECT`, `INSERT`, `UPDATE`, `DELETE`, `TRUNCATE`, `REFERENCES`, `TRIGGER`, `MAINTAIN`—through direct, `PUBLIC`, inherited-membership and `SET ROLE` paths. `PUBLIC`, inherited rights, database/schema/object/default/parameter privileges, overloads, ownership and restore-time drift are all part of the required effective-privilege proof. PostgreSQL role design cannot constrain a hosting-provider superuser/control plane; that is a separate acknowledged operational trust boundary. Exact production hardening must also align with the canonical runtime database security design ([P3 design](../architecture/after_four_p3_runtime_database_security_design.md)).

## 8. Idempotency, replay, and concurrency

1. Physical uniqueness is exactly `(organization_id, producer_key, idempotency_key)` and the key is non-null and nonblank.
2. Every Slice 1 append request requires the Stable Attempt Key. The catalog cannot weaken it to optional or forbidden.
3. The same logical operation preserves Organization, Producer, and Stable Attempt Key across retries. A changed type/version under that identity is a conflicting replay, never a second event.
4. `INSERT ... ON CONFLICT DO NOTHING` serializes concurrent attempts on the unique index. The losing call performs an ordinary post-conflict `SELECT`—no row-lock clause and no `UPDATE` privilege—and compares every immutable semantic field. Under `READ COMMITTED`, the insert waits for the winner and the next PL/pgSQL statement receives a fresh command snapshot.
5. Exact match returns provisional `matched_existing_in_current_snapshot` within a `PendingAppendReceipt` carrying the stable reconciliation identity and original event evidence; no new row is written. Only the outermost transaction owner may construct `CommittedAppendResult(idempotent_replay)` after known commit.
6. Any semantic mismatch raises a safe replay conflict. It never updates the original or appends a disguised duplicate.
7. Distinct attempts require distinct keys. Correlation, target, actor, or occurrence time alone never defines idempotency.
8. Under default PostgreSQL `READ COMMITTED`, two identical racers yield one insert and one matching replay; conflicting racers yield one insert and one conflict. If the winner rolls back, the loser may insert and becomes the sole row. No race returns a match before the winning row commits. Under stronger isolation, `40001` may occur; `40P01` may also occur. Both unwind the failed transaction and may be retried only as the complete owning transaction under an approved bounded policy with the same stable key; neither becomes success.
9. The function participates only in the wrapper-opened supported outer transaction and reports transaction-local disposition for `PendingAppendReceipt`. The wrapper must hold the lease, prove no active transaction before entry, open the boundary itself and alone issue the capability from its yielded transaction object. Joined inner scopes reuse it; an ambient transaction, nested issuer, `requires_new`, real savepoint or restarted parent fails before Audit SQL with no receipt. For `atomic_fail_closed` events, business writes and audit append commit/rollback together. Only that outer owner finalizes `CommittedAppendResult` after known commit. Separate denial/failure evidence uses a separately approved transaction path and does not claim a rolled-back business success.
10. Neither `recorded_at`, event UUID, nor index ordering is a global sequence. No global order exists across Organization and Branch stores.

No Slice 1 catalog entry may make idempotency optional or forbidden. A future relaxation would require a separate Owner decision and revised security review.

## 9. Metadata storage strategy

### 9.1 JSONB choice

| Option | Assessment |
|---|---|
| Dedicated columns for every event fact | Strong typing but forces unrelated sparse columns and couples table migration to every event version |
| Key/value child rows | Adds joins, ordering/type ambiguity, and a shallow generic data model |
| Versioned JSONB object | Best fit for event-specific, immutable, bounded metadata when paired with a strict catalog/application schema |

Use JSONB for metadata only. Organization, actor/provenance, target, outcome, time, catalog identity, correlation, causation, and idempotency remain typed columns because they drive integrity and security. Branch is excluded entirely from the Slice 1 relation and contract.

### 9.2 Enforcement split

| Rule | PostgreSQL | Audit Application |
|---|---|---|
| JSON root is object | Check constraint | Also validate before adapter |
| Allowed/required keys | Append function against catalog arrays | Compile-time/reviewed event schema |
| Maximum bytes | Append function using catalog `metadata_max_bytes` | Preflight validation; exact approved value |
| Value types/nesting/cardinality | Coarse rejection may be added; no native JSON Schema extension | Exact versioned schema and scalar/container rules |
| Secret/PII semantics | Cannot reliably detect values; function must not echo payload on error | Prohibited-field/key/value rules, minimization, redaction tests |
| Unknown keys | Function rejects | Application rejects |

No GIN or unrestricted JSON-path index is proposed. Approved queries should first scope by Organization and typed columns. Metadata search requires a later reader/privacy design and specific expression indexes if justified.

Passwords, PINs, raw Session/recovery/invitation/CSRF/bearer tokens, MFA secrets/codes, payment credentials, authorization/cookie headers, unrestricted bodies, database records, exception dumps, and unnecessary personal data remain prohibited. A payload-size bound is a technical security parameter, not a retention or legal decision.

## 10. Migration, rollback, and schema-dump plan

### 10.1 Deployment sequence

1. Provision reviewed non-login/login roles and memberships outside the Rails schema migration; verify `af_migrator` special attributes and that it can assume only the intended owner through time-bounded `SET TRUE, INHERIT FALSE, ADMIN FALSE` membership. Hosting-provider control-plane authority is inventoried separately.
2. In one migration, create the empty catalog, event table, constraints, minimal indexes, append-only trigger function/triggers, and append function.
3. For every function-creating owner, execute the **global** `ALTER DEFAULT PRIVILEGES FOR ROLE <owner> REVOKE EXECUTE ON FUNCTIONS FROM PUBLIC` without `IN SCHEMA`; inspect any separate per-schema defaults as a distinct layer. In the same object-creation transaction, revoke object-level `PUBLIC EXECUTE` before selective grants. Assign the two immutable array helpers to the schema owner and grant helper `EXECUTE` only to the function owner for defensive catalog revalidation. Set final owners explicitly.
4. Verify the exact migration target reports server and migration-session client encoding `UTF8`; then verify deterministic C collations; ownership, constraints, indexes, trigger enabled state, function security mode/search path/signature; global/per-schema default ACLs and object ACLs; all eight table privileges; role attributes; and effective recursive membership/`SET ROLE` paths.
5. Dump `structure.sql` with PostgreSQL 18 tooling and compare migration-from-empty with structure-load semantics. Every load/restore follows the canonical fencing/quarantine protocol: a trusted orchestrator issues a non-reusable attempt ID and unique invocation, binds evidence to one source artifact and exclusively owned target generation, and rechecks that generation at preflight, completion, immediately before promotion and during atomic promotion. Retain aggregate tool status and only worker evidence the selected mode actually exposes; never invent independent worker completion. Reject partial, interrupted, mixed, stale, superseded, nonzero/unknown or generation-mismatched results. Logical restore with `--create` keeps maintenance and created-target generations separate; physical restore remains isolated before credentials/readiness/traffic. Anything short of one atomic `QUARANTINED -> ACCEPTED` transition leaves the target quarantined.
6. Keep the catalog empty. A later separately authorized migration may add exact Owner-approved rows and corresponding Audit Application schemas.

Existing `audit_events` is never renamed, altered, read, copied, or backfilled by this migration.

### 10.2 Rollback

- Rollback begins with externally enforced writer quiescence. Empty Slice 1 has no runtime appender membership, but the authorized rollback test must still prevent a concurrent privileged migration/function invocation.
- One transaction acquires `ACCESS EXCLUSIVE` in the fixed order `organization_audit_event_catalog`, then `organization_audit_events`, matching the append path's catalog-before-event access. Only after both locks are held may it test both relations for emptiness. Any row, lock failure or unexpected object/dependency aborts the whole transaction; a pre-lock observation is never sufficient.
- Under those locks, verify the complete reviewed dependency inventory. Revoke the exact appender function `EXECUTE` and only the Audit-specific schema usage if that usage is not shared; drop the exact append function; drop the four Audit mutation/truncate triggers and then their trigger function; drop the event relation before the catalog relation; and drop the two array helpers only after their dependent constraints/relations are gone. Preserve cluster roles and every unrelated schema object, privilege and existing Branch audit object.
- The controlled `af_migrator` holds temporary non-inheriting, no-admin `SET`-only membership in both owners. In the same transaction it acts as schema owner for locks/checks, resets; acts as function owner to revoke/drop the append function, resets; and acts as schema owner for the remaining dependency-ordered drops. No commit occurs between role transitions. After commit, provisioning revokes both temporary memberships and proves both `SET ROLE` paths fail.
- Commit only after a post-drop inventory proves that exactly the Slice 1 objects are absent and unrelated objects are unchanged. Any failure rolls back every revoke/drop. The authorized evidence suite must cover a concurrent invocation or privileged writer, nonempty-table abort, rollback/reapply, structure-load parity and unrelated-object invariance.
- After production evidence exists, destructive rollback is unsafe and prohibited. Use forward repair, disable future producer activation outside evidence rows, or deploy a superseding version; preserve existing evidence.
- Cluster roles may be shared with later objects and must not be automatically dropped by a Rails down migration. Role retirement is a separate operational action after dependency inspection.
- Restore can replace database history and bypass triggers. Backup/restore runbooks must record restore boundaries and reconcile protected evidence; this design does not prevent a privileged restore.

### 10.3 RLS and function-catalog assertions

Slice 1 does not rely on Row-Level Security. Both Audit relations must have `relrowsecurity = false`, `relforcerowsecurity = false`, and zero `pg_policy` rows; any policy or enabled/forced RLS state is unreviewed drift and fails acceptance. Isolation is supplied by denied relation privileges, exact function access and the function's Organization-bound contract.

Catalog evidence must verify the exact append signature/result and owner/ACL; `prosecdef = true`, `provolatile = 'v'`, `proparallel = 'u'`, `proleakproof = false`; and `proconfig` contains exactly the reviewed fixed search path. The two helpers must be non-definer, immutable, parallel-safe, non-leakproof, have the reviewed owners/ACLs/signatures/results and fixed `proconfig`. The append-only trigger function must have its exact no-argument trigger signature/result, schema-owner ownership, no `PUBLIC` execute, `prosecdef = false`, `provolatile = 'v'`, `proparallel = 'u'`, `proleakproof = false`, exact `proconfig` and normalized definition hash; `pg_trigger` must show the four reviewed bindings enabled on the correct relations. No assertion may rely on Active Record metadata alone.

### 10.4 Fresh setup and reproducibility

- Fresh migration and load into a pre-existing target must preflight that exact attested target generation's `server_encoding = 'UTF8'` and the participating session's `client_encoding = 'UTF8'`. Logical restore with `--create` authoritatively checks the created database/generation, not only the maintenance database; physical restore checks the restored cluster/databases after isolated startup but before credentials/readiness/traffic. A successful aggregate tool exit plus complete attempt/source/generation/invocation evidence, exclusive ownership and catalog reconciliation are mandatory; `--exit-on-error` alone is not atomic rollback. `SQL_ASCII`, other server encodings, client mismatch, partial/ambiguous/mixed/superseded restore, generation change or failed reconciliation remains quarantined under the [UTF-8 lifecycle matrix](organization_level_audit_security_design_closure.md#utf-8-lifecycle-enforcement-matrix).
- Because PostgreSQL roles are cluster objects and dumps may reference them without creating them, CI must provision deterministic role fixtures before migration/structure load.
- `structure.sql` remains source-controlled and generated with the pinned PostgreSQL major. Schema dump must contain stable function definitions, fixed search paths, triggers, and constraints without environment-specific owners or credentials.
- CI should compare normalized PostgreSQL catalog facts rather than fragile dump ordering alone.

## 11. Security and operational test matrix

### 11.1 Normal PostgreSQL-backed CI

| Test | Expected evidence |
|---|---|
| Empty catalog denial | Every event tuple rejected; no row |
| Approved catalog tuple fixture | Only fixture tuple/version/actor/outcome accepted in isolated test DB |
| Catalog array element grammar | Reject one element `valid_one,valid_two`, any comma/delimiter-bearing element, empty element, SQL-NULL element, multidimensional/non-1-lower-bound array, malformed outcome and required-not-allowed key; accept two separate valid elements and canonical empty metadata-key arrays |
| Catalog array duplicate parity | Application validation and both PostgreSQL helpers reject duplicate `allowed_outcomes`, duplicate `allowed_metadata_keys` and duplicate `required_metadata_keys` using exact C-collation equality; no layer trims, folds, normalizes, deduplicates, sorts or reorders. Case-different values are tested against the existing lower-case grammar rather than treated as equal duplicates. |
| Catalog ordered projection and release | Apply the exact version-1 binary contract and SHA-256 fixture schema in Logical Contract §10.1.1–10.1.5. Two duplicate-free arrays with the same elements in different orders remain membership-equivalent but produce different canonical bytes and digests. Only the exact reviewed manifest order matches; unsupported version, framing/byte/hash mismatch and helper-definition drift abort activation or release. Expected fixture hex/digests remain pending authorized generation and independent checking. |
| Catalog NULL and empty boundaries | SQL-NULL arrays and SQL-NULL elements are rejected; empty `allowed_outcomes` is rejected; canonical empty `allowed_metadata_keys` and `required_metadata_keys` remain accepted; required-key subset behavior is unchanged. |
| Encoding and deterministic identity | Separately test UTF-8 database acceptance; non-UTF-8/`SQL_ASCII` rejection at each lifecycle gate; native fail-closed parse/resolution/bind/decode/conversion failure before function entry; exact-session `AUE02` after successful entry with changed client encoding on an accepted connection; no receipt/later statement/alternate-connection fallback for either path; non-ASCII scalar/array round trips; malformed bytes/U+0000; normalization-different bytes; structure load; partial/interrupted/parallel logical restore with/without `--create`; isolated physical restore; stale monitoring evidence and C-collation identity |
| Unknown type/version/producer | Stable denial; no fallback generic event |
| Organization existence/isolation | Invalid Organization rejected; app contract cannot append under another trusted Organization |
| Slice 1 Branch prohibition | PostgreSQL catalogs and function definition contain no Branch column, FK, target, input, comparison, index, fixture, or indirect identity; existing legacy Branch audit remains unchanged |
| Human provenance | Only Audit-owned evidence mapped from trusted Identity context reaches adapter; user/system shape checks hold |
| Slice 1 system-interface absence | Function signature, Application contract, catalog fixtures, inserts and event relation checks expose no system-producer argument or enabled system shape; system fields remain forced null |
| Target/reference modes | Forbidden/optional/required combinations enforced |
| Metadata | Object, allowed/required keys, size, type/nesting application schema, and prohibited-secret fixtures rejected safely |
| Idempotent replay | Same immutable event returns original ID/time and one row |
| Conflicting replay | Same key with any changed immutable fact fails and original remains |
| Concurrent append | Two-session identical and conflicting requests with the same Organization/Producer/Stable Attempt Key prove one row only; identical loser matches committed winner, conflicting loser rejects, winner rollback permits the loser to become sole insert; stronger-isolation/deadlock states unwind the full transaction |
| Transaction and durability | Pre-entry ambient rejection; wrapper-opened outer commit; insert then rollback; joined capability reuse plus outer rollback/commit; nested-issuer and real-savepoint/restarted-parent rejection before SQL; matching/conflicting retry; connection loss around commit; known-rollback and uncertain-commit retry all preserve provisional-versus-committed semantics |
| Structured database failures | Read only `PG_DIAG_SQLSTATE`; verify native pre-entry parse/resolution/bind/decode/conversion failures without assuming `AUE02`, then separately verify in-function exact-session `AUE02`, `AUE01`, `42501`, exact-constraint `23505`, `40001`, `40P01`, missing/malformed result and unknown state. No message parsing, successful receipt/result, query/log/reconciliation/retry inside an aborted transaction or alternate-connection fallback |
| Shared Rails transaction | Module-local record never switches/establishes a connection or uses root `ApplicationRecord`; outer wrapper holds the lease, proves no active transaction, opens the boundary itself and alone supplies one adapter/capability from its yielded transaction object. Prove exact specification, role/shard pool, adapter/raw connection, yielded/current transaction object/UUID, Thread/Fiber and attempt generation; normal/joined reuse works; ambient entry, nested issuer, `requires_new`, `SavepointTransaction`, `RestartParentTransaction`, retry, stale/transfer/check-in/reconnect/switch and construction/validation failure all fail before SQL; business/Audit writes commit/rollback together |
| Occurrence time | Reject NULL and positive/negative infinity; accept ordinary and extreme finite fixture values generically; producer tests later enforce approved past-age/future-skew/source/delay policy |
| Mutation protection | Instance, bulk, and direct SQL update/delete rejected |
| Truncate protection | Ordinary role cannot truncate; trigger defense also rejects privileged-but-nonowner attempt with privilege where test fixture permits |
| Catalog immutability | Runtime cannot insert/update/delete/truncate catalog; changed semantics require new migration/version |
| Schema equivalence | Migration-from-empty and `structure.sql` load expose same normalized catalog facts |
| Existing Branch store | Schema, rows, trigger, and characterization tests unchanged |

Actual system-provenance rejection tests are not Slice 1 tests because the current function and Application contract have no system-producer arguments. They belong only to a separately approved future system-producer design and must then cover producer identity, invocation evidence, custody, rotation/revocation and actor-shape rejection without inventing a User.

### 11.2 Dedicated role/security environment

| Test | Required setup and assertion |
|---|---|
| Effective Empty-Slice privileges | Function owner retains inherent owner EXECUTE; appender is the only non-owner explicit EXECUTE grantee; for runtime/appender/reader/migrator and every inherited/`PUBLIC`/`SET ROLE` path, enumerate all eight table privileges (`SELECT`, `INSERT`, `UPDATE`, `DELETE`, `TRUNCATE`, `REFERENCES`, `TRIGGER`, `MAINTAIN`) and prove the exact target; real runtime can assume neither owner nor appender and cannot execute the function or access either table |
| Database and parameter privileges | Runtime has only reviewed `CONNECT`; database `CREATE`/`TEMPORARY`, `CREATE DATABASE`, parameter `SET`, `ALTER SYSTEM` and `session_replication_role` changes are denied and inspected through database ACLs, role attributes/settings and `pg_parameter_acl` |
| Reader denial | Reserved reader has no access until separately granted |
| Trigger/function tampering | Runtime/appender cannot disable/drop trigger, replace function, alter function owner/search path, alter table/schema, or grant itself rights |
| Ownership/membership | Runtime cannot `SET ROLE` to schema/function owner; function owner owns no table/schema and has only required grants |
| Migrator attributes and owner custody | `af_migrator` is `NOSUPERUSER NOCREATEROLE NOCREATEDB NOREPLICATION NOBYPASSRLS`; owner grants are time-bounded `SET TRUE, INHERIT FALSE, ADMIN FALSE`, evidenced before/during/after and revoked. Provider-control-plane power is inventoried separately, not claimed constrained |
| `PUBLIC` exposure and default privileges | No effective table privilege or function EXECUTE through `PUBLIC`, inheritance, or nested membership; inspect global and per-schema `pg_default_acl`, and create disposable functions as each owner to prove global default plus same-transaction object revocation prevents exposure |
| Search-path attacks | Runtime-created temporary/public objects, operators, casts, and names cannot shadow function references |
| Function input attacks | Oversized strings/JSON, malformed Unicode/JSON, arrays/nesting, catalog mismatches, and crafted error content fail safely |
| Error classification | `AUE01` maps only explicit registration denial. Native pre-entry parse/resolution/bind/decode/conversion failures keep their structured PostgreSQL state and are not promised as `AUE02`; after successful entry, `AUE02` maps only the exact-session encoding-guard mismatch. Both paths, missing function-owner `SELECT`/`INSERT`, schema `USAGE`, runtime exact `EXECUTE`, unexpected native `42501` and unknown state fail as security-control/storage errors without topology disclosure or success construction |
| Failure injection | Connection/constraint/catalog/insert failures return correct safe category and preserve transaction semantics |
| Backup/restore exercise | Bind one non-reusable attempt/source/target-generation/invocation, race concurrent attempts, inject reuse/supersession/target replacement/mixed evidence/partial/interrupted/parallel cases, distinguish aggregate from actually exposed worker status, keep failed targets quarantined, reconcile full inventory, and prove only one atomic `QUARANTINED -> ACCEPTED` transition can authorize the separate enforcement component |

No test can prove resistance to a database superuser, table owner, compromised backup administrator, or malicious infrastructure restore. Those remain privileged trust and operational-monitoring risks.

## 12. Operational limitations

- The initial store cannot record any event until an Owner-approved catalog migration exists.
- Slice 1 contains no Branch concept. Future Branch support is outside this design and requires a separate Owner decision and review.
- The database proves actor/provenance shape and catalog match, not that Identity authentication or business authorization was correct. That evidence comes through trusted composition and producer tests.
- The function reports only `inserted_in_current_transaction` or `matched_existing_in_current_snapshot` inside `PendingAppendReceipt`. Neither proves outer commit. Only the lease-holding wrapper that rejected ambient state and opened the outer transaction may create `CommittedAppendResult(appended or idempotent_replay)` after known commit. A joined inner return cannot emit external success; joined services reuse the capability, while nested issuers and real nested/savepoint/restarted-parent scopes fail before SQL and create no receipt.
- Empty Slice 1 enforces finite occurrence time but intentionally chooses no arbitrary finite range. Every producer needs an approved past-age, future-skew, clock-source, retry and delayed-event policy before activation.
- Event-specific metadata semantics remain Application-enforced; PostgreSQL provides defense-in-depth shape/key/size checks only.
- No reader, export, hold, retention scheduler, deletion, correction, anonymization, or investigation workflow exists.
- No cross-store total order, atomic transaction, sequence, or unified idempotency exists between Organization and Branch stores.
- Function-owner compromise can append structurally valid evidence and read replay fields; it cannot update/delete via granted privileges but remains a sensitive principal.
- Schema owner, superuser, backup/restore operator, and sufficiently privileged break-glass access can bypass controls.
- Monitoring, alerting, reconciliation checkpoints, incident runbooks, and role credential custody are not implemented by DDL alone.
- Organization FK retention can block parent deletion; this is consistent with evidence preservation direction but exact retention/legal treatment still requires review.

## 13. Owner decisions still required

1. Approve each initial Organization event tuple: producer, type, version, actor mode, system provenance where applicable, target/reference modes, outcomes, metadata schema/limit, idempotency mode, sensitive-data class, and failure class.
2. Approve exact system-producer keys, versions, accountable operation owners, and invocation-evidence requirements.
3. Before any future Branch-bearing event, separately approve a new Branch ancestry/integrity design; this is not a Slice 1 prerequisite or reserved schema shape.
4. Approve production role ownership and operational custody: migrator, schema owner, function owner, runtime appender, future reader, break-glass, and backup/restore responsibilities.
5. Approve class-specific fail-closed versus separately durable denial/failure behavior for the first events.
6. Decide future audit read/search/export/hold/correction capabilities; no reader role grant follows automatically.
7. After qualified legal/privacy/accounting input, approve retention, hold/release, backup expiry, employee visibility/correction, anonymization/deletion conflict, and export rules.

No existing Orders, Payments, Preparation, Identity, Organization, or Employee event is approved merely because it appears in code or prior design inventory.

## 14. Explicit implementation prerequisites

The authoritative staged prerequisites are [Security Design Closure §8.8](organization_level_audit_security_design_closure.md#88-authoritative-prerequisite-matrix). In summary, an empty Slice 1 requires corrected-design independent review, a separate bounded implementation authorization, reviewed migration/function/role/test scope, and production-parity security evidence planning. It does **not** require a first catalog row, failure class, producer, event-specific metadata schema, trust-model acceptance for production, reader policy, or retention policy.

In particular, `ISR-AUD-031`–`042` remain at their recorded review/evidence stages. `ISR-AUD-036/041` require final narrow read-only verification of wrapper-owned participation and the pre-entry native-error versus in-function `AUE02` boundary; `ISR-AUD-039/040/042` retain their latest design-level verification; and all five require later executable evidence. None is executable-accepted.

Those additional inputs remain mandatory at their actual stages: `AUD-DEC-07`–`11`, event-specific security/privacy evidence and an explicit temporal policy before the first human producer; a separate provenance/custody decision and future-gated system-provenance test plan before any system producer; `AUD-DEC-12`–`14` before reader/export/production-data governance; and real role provisioning, credential custody, monitoring, restore reconciliation and independent operational evidence before production deployment. Existing legacy Branch audit regression remains required, but no Branch concept may enter the new Slice 1 schema or contract.

Qualified security review remains required. Audit retention/hold/export/privacy records remain incomplete ([AF-SEC-008](../architecture/security-reviews/af-sec-008-audit-security.md), [AF-PRIV-004](../architecture/security-reviews/af-priv-004-audit-retention-legal-holds.md), [AF-PRIV-005](../architecture/security-reviews/af-priv-005-exports-anonymization.md)). ID-12 and ID-18 restrict audit mutation/read but approve no concrete production privilege or retention schedule ([Identity Decision Register](../architecture/after_four_identity_decision_register.md#owner-decisions-confirmed)).

## 15. Explicit exclusions

This design does not create or modify migrations, `structure.sql`, schemas, tables, roles, grants, functions, triggers, packages, manifests, architecture guards, source code, tests, event types, runtime writers, readers, APIs, exports, retention, legal holds, Employee creation, or existing Branch audit data/behavior.

No DDL, migration, database, build, service, application test, or security test was executed. No Gate, implementation, deployment, FOA, compliance, or Production Authorization is granted.

## Final verdict

`EXTERNAL_INDEPENDENT_REVIEW_REQUIRED`

The Owner selected an empty catalog and no producer, so a catalog entry, failure class and system provenance are not prerequisites to reviewing the empty infrastructure slice. The reconciled package is ready only for genuinely external independent review of all findings. Implementation remains unauthorized pending that disposition and separate written Owner authorization. Disposable implementation evidence can exist only after authorization; production provisioning evidence remains a later deployment prerequisite.
