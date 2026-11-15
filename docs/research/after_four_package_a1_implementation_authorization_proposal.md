# AFTER FOUR — Package A1 Reference Foundation Implementation Authorization Proposal

**Proposal date:** 2026-11-15

**Package:** A1 — Empty Organization/Brand/Branch Reference Schema

**Proposal status:** `READY_FOR_SEPARATE_AUTHORIZATION_REVIEW`

**Implementation authorization:** Not granted

## 1. Executive proposal

Package A1 is a deliberately empty reference-schema foundation. It proposes three UUID-keyed tables—Organization, Brand, and Branch—with only the structural fields needed to represent Organization→Brand→Branch ownership. It proposes no production records, mappings, operational foreign keys, runtime administration commands, API, or Identity work.

A1 is technically isolated from `CAT-TRR-001` because it does not attach existing Branch-bearing data to the new Branch table. That finding remains open and continues to block Package A2 mapping/integration. A1 is also isolated from the Identity and Brand-scoped AuditEvent dependency because it exposes no business mutation operation.

The proposal narrows the broader logical [Data Dictionary](../architecture/after_four_data_dictionary.md) shape. Organization/Brand/Branch `code`, lifecycle/status, archive, legal/currency, address, and opening/closing fields are excluded because their business semantics are not Owner-confirmed for A1. The narrower shape follows the [Catalog Core Technical Design §12](../architecture/after_four_catalog_core_technical_design.md#12-recommended-persistence-model). This is scope deferral, not a claim that the broader logical fields are invalid.

This document is ready to be reviewed as the basis of a separate implementation-authorization request. It is not that request and grants no authority to implement.

## 2. Authority and design boundary

### 2.1 Owner-confirmed authority

- `ODB-CAT-14` confirms that the initial deployment starts with one Organization and one Brand, while the schema permits multiple Organizations and multiple Brands and imposes no permanent singleton constraint.
- `ODB-CAT-01` confirms Brand-global Product identity but does not authorize Catalog tables in A1.
- `ODB-CAT-39` and `ODB-CAT-41` keep Product lifecycle commands and Product Category reassignment outside the MVP scope.
- No Owner Decision defines Organization, Brand, or Branch Code normalization, lifecycle, production identity, or initial production row values.

The Organization→Brand and Brand→Branch relationships are current logical and technical design, not a new Owner Decision created by this proposal.

### 2.2 Existing architecture contracts

- [ADR-0003](../architecture/adr/0003-postgresql-version-baseline.md): PostgreSQL 18.
- [ADR-0004](../architecture/adr/0004-uuid-primary-keys.md): UUID primary keys; business codes are separate identifiers and are not invented here.
- [ADR-0005](../architecture/adr/0005-backend-repository-structure.md): conventional Rails models remain acceptable for reference records.
- [ADR-0010](../architecture/adr/0010-database-migrations-and-schema.md): Rails migrations, explicit constraints/FKs/indexes, PostgreSQL `structure.sql`, and expand/migrate/contract sequencing.
- [ADR-0006](../architecture/adr/0006-authentication-session-topology.md) remains Proposed; Identity Milestone 2B remains unauthorized.

### 2.3 Verified repository evidence versus proposal

| Topic | Verified repository evidence | A1 technical proposal / unavailable evidence |
|---|---|---|
| UUIDs | `backend/config/application.rb` configures Active Record generators with UUID primary keys; existing application tables use `gen_random_uuid()`. | Apply the same convention to all three A1 primary keys. |
| Timestamps | `backend/config/initializers/postgresql.rb` sets `PostgreSQLAdapter.datetime_type = :timestamptz`; existing application migrations use `t.timestamps`; `structure.sql` records `timestamp(6) with time zone`. | Use the same Rails migration convention; do not introduce raw A1-specific timestamp SQL. |
| Foreign keys | Existing application FKs are immediate/non-deferrable unless explicitly designed otherwise. Solid Queue alone uses upstream cascade FKs; application-owned aggregate FKs do not establish cascade as an A1 convention. | Use explicitly named, nondeferrable A1 FKs with `ON DELETE RESTRICT` and default `ON UPDATE NO ACTION`. |
| Checks/indexes | Existing migrations use `add_check_constraint` and explicitly named business-critical indexes/FKs. | Use stable A1 check/FK/index names shown below. |
| Tests | RSpec is configured with transactional fixtures and FactoryBot syntax. Existing database integrity specs exercise PostgreSQL rather than relying only on model validation. | Add synthetic factories and focused model/integration specs only after authorization. No factory files currently exist. |
| Roles/grants | Development/test Compose and `database.yml` use the single `postgres` principal. Production is an opaque `DATABASE_URL`. No repository `GRANT`, `REVOKE`, role creation, or default-privilege policy was found. | Production migration owner, runtime role, reader role, grants, and default privileges are `UNVERIFIED`; do not invent names or permissions. |
| Commands | `backend/README.md`, testing standards, `bin/setup`, `bin/ci`, and `config/ci.rb` document database preparation, schema dump/load, RSpec, seed replant, and CI. | No project-specific rollback/reapply command or schema-drift target is documented. |

The repository root and `backend/` contain no Makefile. Command guidance therefore comes from the files listed above, not an assumed Make target.

## 3. Exact proposed A1 schema

All tables use Rails/PostgreSQL UUID primary keys with `gen_random_uuid()`. Migrations use the existing `t.timestamps` convention; because the repository initializer maps Rails datetime to PostgreSQL `timestamptz`, `structure.sql` must record `created_at` and `updated_at` as `timestamp(6) with time zone NOT NULL`. A1 creates no rows.

### 3.1 `organizations`

| Column | PostgreSQL shape | Null/default | Purpose |
|---|---|---|---|
| `id` | `uuid` | PK, default `gen_random_uuid()` | Stable Organization identity. |
| `name` | `varchar(200)` | `NOT NULL` | Human-readable reference name; not a unique business identifier. |
| `lock_version` | `integer` | `NOT NULL DEFAULT 0` | Optimistic-lock seam for later authorized master-data operations. |
| `created_at` | `timestamptz(6)` | `NOT NULL` | Rails creation timestamp. |
| `updated_at` | `timestamptz(6)` | `NOT NULL` | Rails update timestamp. |

Proposed constraints:

- Primary key: `organizations_pkey (id)`.
- Check: `organizations_name_nonblank`, enforcing the exact expression in §3.4.
- No singleton constraint.
- No unique name constraint; name equality/renaming is not an approved identity policy.

### 3.2 `brands`

| Column | PostgreSQL shape | Null/default | Purpose |
|---|---|---|---|
| `id` | `uuid` | PK, default `gen_random_uuid()` | Stable Brand identity. |
| `organization_id` | `uuid` | `NOT NULL` | Owning Organization. |
| `name` | `varchar(200)` | `NOT NULL` | Human-readable reference name; not a unique business identifier. |
| `lock_version` | `integer` | `NOT NULL DEFAULT 0` | Optimistic-lock seam for later authorized operations. |
| `created_at` | `timestamptz(6)` | `NOT NULL` | Rails creation timestamp. |
| `updated_at` | `timestamptz(6)` | `NOT NULL` | Rails update timestamp. |

Proposed constraints and indexes:

- Primary key: `brands_pkey (id)`.
- Foreign key: `fk_brands_organization`, with the exact semantics in §3.5.
- Check: `brands_name_nonblank`, enforcing the exact expression in §3.4.
- Index: `index_brands_on_organization_id`.
- No `(organization_id, name)` uniqueness: Brand names are not approved business keys.

### 3.3 `branches`

| Column | PostgreSQL shape | Null/default | Purpose |
|---|---|---|---|
| `id` | `uuid` | PK, default `gen_random_uuid()` | Stable Branch identity; future A2 may preserve an approved existing Branch UUID. |
| `brand_id` | `uuid` | `NOT NULL` | Owning Brand. |
| `name` | `varchar(200)` | `NOT NULL` | Human-readable reference name; not a unique business identifier. |
| `timezone_name` | `varchar(100)` | `NOT NULL` | IANA timezone identifier required for future Branch-local operations. |
| `lock_version` | `integer` | `NOT NULL DEFAULT 0` | Optimistic-lock seam for later authorized operations. |
| `created_at` | `timestamptz(6)` | `NOT NULL` | Rails creation timestamp. |
| `updated_at` | `timestamptz(6)` | `NOT NULL` | Rails update timestamp. |

Proposed constraints and indexes:

- Primary key: `branches_pkey (id)`.
- Foreign key: `fk_branches_brand`, with the exact semantics in §3.5.
- Check: `branches_name_nonblank`, enforcing the exact expression in §3.4.
- Check: `branches_timezone_name_nonblank`, enforcing the exact expression in §3.4.
- Index: `index_branches_on_brand_id`.
- No `(brand_id, name)` uniqueness: Branch names are not approved business keys.
- PostgreSQL only enforces nonblank timezone storage in A1. IANA membership validation requires a maintained application/library boundary and is not represented as a static database list.

### 3.4 Exact nonblank policy

Plain `btrim(value) <> ''` removes ordinary spaces only and therefore does not meet the intended A1 rule for strings containing only common ASCII whitespace. A1 defines its database whitespace set precisely as:

- ordinary space, U+0020;
- horizontal tab, U+0009;
- line feed, U+000A;
- carriage return, U+000D;
- form feed, U+000C; and
- vertical tab, U+000B.

Each A1 nonblank constraint uses this predicate, substituting the relevant column:

```sql
length(translate(value, E' \t\n\r\f' || chr(11), '')) > 0
```

`translate` removes every occurrence of the defined characters, so empty strings and any mixture containing only those characters fail. Strings containing at least one other character pass; the constraint does not trim stored values, normalize case, establish uniqueness, or create a business identity rule.

Unicode no-break space and other Unicode space characters are not silently added to this finite A1 definition. A broader Unicode normalization/rejection policy would require explicit design rather than locale-dependent inference.

This predicate applies identically to:

- `organizations.name` → `organizations_name_nonblank`;
- `brands.name` → `brands_name_nonblank`;
- `branches.name` → `branches_name_nonblank`; and
- `branches.timezone_name` → `branches_timezone_name_nonblank`.

### 3.5 Exact foreign-key semantics

| Constraint | Reference | Delete | Update | Timing |
|---|---|---|---|---|
| `fk_brands_organization` | `brands.organization_id → organizations.id` | `ON DELETE RESTRICT` | `ON UPDATE NO ACTION` | `NOT DEFERRABLE`; immediate |
| `fk_branches_brand` | `branches.brand_id → brands.id` | `ON DELETE RESTRICT` | `ON UPDATE NO ACTION` | `NOT DEFERRABLE`; immediate |

The proposed Rails migration uses explicitly named `add_foreign_key` calls with `on_delete: :restrict`. It omits cascade behavior, `on_update`, and `deferrable`; PostgreSQL therefore uses `ON UPDATE NO ACTION` and a nondeferrable constraint. No A1 transaction requires a temporarily orphaned Brand or Branch, so there is no evidence supporting deferred FKs.

`RESTRICT` prevents deletion of a referenced parent and performs no cascading mutation. UUID parent-key updates have no approved use case; `NO ACTION` rejects a referenced-key update rather than cascading it.

### 3.6 Timestamp compatibility and migration syntax

The verified repository convention is:

```ruby
create_table :organizations, id: :uuid do |t|
  # A1 fields
  t.timestamps
end
```

The same `t.timestamps` call applies to Brand and Branch. `backend/config/initializers/postgresql.rb` maps Rails datetime columns to `:timestamptz`; Rails 8.1 emits microsecond precision and the current `structure.sql` records application timestamps as:

```sql
created_at timestamp(6) with time zone NOT NULL,
updated_at timestamp(6) with time zone NOT NULL
```

This is compatible with existing application-owned tables and UTC application persistence. A1 must not declare `timestamp without time zone`, raw A1-only timestamp SQL, or a different precision. Framework-owned Solid Queue timestamps do not override the application-owned convention.

### 3.7 Explicitly absent fields and constraints

A1 does not include:

- Organization, Brand, or Branch `code` fields or Code uniqueness.
- `status`, `archived_at`, lifecycle transitions, or Soft Delete.
- Organization `legal_name` or `default_currency`.
- Branch address, open/close dates, availability, or operational configuration.
- Singleton checks or seeds enforcing “one Organization/Brand.”
- Production identifiers, names, timezones, or mappings.

Adding any of these requires later business/technical closure and separate authorization.

## 4. Relationship and deletion behavior

```text
Organization 1 ── 0..* Brand 1 ── 0..* Branch
```

- Every Brand references exactly one Organization.
- Every Branch references exactly one Brand.
- A new empty Organization or Brand may temporarily have no children.
- Foreign keys use the exact §3.5 semantics; no cascade or deferral is permitted.
- A1 exposes no runtime delete command. It does not invent a permanent retention/lifecycle policy for empty reference records.
- Once A2 or later packages reference these rows, destructive rollback/deletion is replaced by reviewed roll-forward remediation.

## 5. Existing-table impact

### 5.1 Branch-bearing tables observed

| Existing table | Current Branch representation | A1 impact |
|---|---|---|
| `orders` | `branch_id uuid NOT NULL`; no Branch FK | None. |
| `audit_events` | `branch_id uuid NOT NULL`; no Branch FK; append-only update/delete trigger | None. |
| `preparation_dispatches` | `branch_id uuid NOT NULL`; same-Branch composite relationship to Order | None. |

A1 must not:

- add, validate, rename, rewrite, or remove any column or constraint on these tables;
- create Branch rows from their UUIDs;
- assume every UUID means Main Branch;
- repair or delete orphan references;
- change application writers to require persisted Branches; or
- expand AuditEvent scope.

Those actions belong to A2 or later authorized work. `CAT-TRR-001` remains open.

### 5.2 Other existing schema

Solid Queue, Payment, PaymentAttempt, PreparationDispatchAttempt, OutboxEvent, PaymentReviewCase, and all other tables remain unchanged. A1 introduces no Catalog, Identity, authorization, session, API, or frontend dependency.

## 6. Proposed implementation surface after separate authorization

A later A1 authorization may permit only:

1. One reviewed Rails migration creating `organizations`, `brands`, and `branches` in parent-first order.
2. Minimal `Organization`, `Brand`, and `Branch` Active Record models with associations, presence/length validation mirroring—never replacing—the database constraints, and restrictive dependency declarations.
3. Synthetic FactoryBot factories under test support.
4. Model/database integration specs and schema reproducibility checks.
5. The resulting `structure.sql` update.

It must not permit controllers, routes, serializers, commands, seeds, jobs, production provisioning, operational FKs, or changes to existing writers.

## 7. Migration ordering and rollback

### 7.1 Forward order

Within one atomic migration unless PostgreSQL review identifies a reason to split:

1. Create `organizations` with local checks.
2. Create `brands` and its parent index, then add `fk_brands_organization` with `ON DELETE RESTRICT`, `ON UPDATE NO ACTION`, and nondeferrable timing.
3. Create `branches` and its parent index, then add `fk_branches_brand` with the same action/timing policy.
4. Dump and review `structure.sql`.

There is no data backfill, `NOT VALID` operational FK, concurrent index, trigger, extension, or AuditEvent change in A1.

### 7.2 Rollback

- Before dependent data exists, Rails may reverse in child-first order: Branch→Brand→Organization.
- The down path must fail rather than cascade if unexpected dependent objects/data exist.
- After any later A2/reference data or dependent schema exists, destructive rollback is no longer safe. Use roll-forward correction and retain stable UUID identities.
- Production deployment/rollback is outside A1 and requires a separate runbook and authorization.

## 8. Fresh database setup and executable verification guidance

After separately authorized implementation, a fresh test/development database must demonstrate:

- existing PostgreSQL UUID generation remains available; A1 enables no new extension;
- migrations create all three empty tables in dependency order;
- `structure.sql` contains the exact columns, checks, indexes, and FKs;
- normal database preparation creates zero Organization/Brand/Branch business rows;
- `db:seed:replant` or equivalent CI setup does not invent reference records;
- the full migration set loads from a clean PostgreSQL 18 database; and
- rollback/reapply works only in the empty A1 boundary.

### 8.1 Verified existing commands

Run from `backend/` in the documented Docker environment only after implementation is separately authorized:

| Purpose | Verified command | Repository source / limitation |
|---|---|---|
| Start PostgreSQL 18 | `docker compose up -d database` | `backend/README.md`; Compose pins PostgreSQL 18.7. |
| Prepare/create and migrate the configured development database | `docker compose run --rm backend bin/rails db:prepare` | `backend/README.md` and `bin/setup`. This creates a missing database or applies pending migrations; it does not itself prove the target was freshly empty. |
| Dump SQL schema | `docker compose run --rm backend bin/rails db:schema:dump` | `backend/README.md`; output is `db/structure.sql`. |
| Load SQL schema | `docker compose run --rm backend bin/rails db:schema:load` | `backend/README.md`. Use only with an explicitly disposable/empty database selected for the verification. |
| Prepare schema before specs | `docker compose run --rm backend bin/rails db:prepare` | Testing standards document this before RSpec; `spec/rails_helper.rb` also calls `ActiveRecord::Migration.maintain_test_schema!` for the configured test database. |
| Run complete RSpec suite | `docker compose run --rm backend bundle exec rspec` | `backend/README.md` and testing standards. |
| Run an existing database-connection spec | `docker compose run --rm backend bundle exec rspec spec/integration/database_connection_spec.rb` | Existing repository path plus the documented single-spec runner. This verifies the current connection only; it is not A1 integrity evidence. |
| Run an individual spec | `docker compose run --rm backend bundle exec rspec spec/PATH_spec.rb` | Testing standards verify the runner pattern. A1 spec paths do not exist yet and must be named by a later authorized implementation. |
| Run full project checks | `docker compose run --rm backend bin/ci` | `backend/README.md`, `bin/ci`, and `config/ci.rb`; includes setup, RuboCop, Bundler Audit, Brakeman, RSpec, and test seed replant. Bundler Audit update requires network access. |
| Seed-empty verification | `docker compose run --rm -e RAILS_ENV=test backend bin/rails db:seed:replant` | `config/ci.rb`; A1 expects zero reference business rows afterward. |
| Documentation/worktree whitespace check | `git diff --check` | Required task/repository review convention; does not run application code. |

There is no repository Makefile, project-specific schema-drift command, or documented non-destructive command dedicated to creating an isolated throwaway database. The existing development reset command (`docker compose run --rm -e RAILS_ENV=development backend bin/setup --reset --skip-server`) is documented but destructive to the named development database and is not part of this proposal's verification guidance.

### 8.2 Guidance not yet executable

- Exact A1 model/integration spec paths cannot be run because the files do not exist and this task does not authorize creating them. A later implementation request must name them before execution.
- No project-specific rollback/reapply command is documented. The later implementation request must specify the exact reviewed Rails migration version/direction and disposable database before any rollback command is authorized; this proposal does not invent or execute one.
- A true fresh-database proof requires a separately identified disposable database/volume. `db:prepare` against an existing database is migration-path evidence, not proof of a fresh create.
- `structure.sql` reproducibility currently has dump/load commands but no automated drift target. A later authorized implementation must define the comparison procedure and review the resulting diff.

## 9. Synthetic-only test strategy

### 9.1 Factory rules

- Factories use conspicuously synthetic names such as `Test Organization`, `Test Brand`, and `Test Branch`.
- Branch factory uses a valid synthetic IANA timezone such as `UTC`; it does not use or imply Main Branch production data.
- Child factories create/reuse their required parent explicitly.
- No fixed production UUID, real address, menu, Price, Employee, User, Order, or operational mapping appears in a factory.
- Factories are test-only and never loaded by seeds.

### 9.2 Required positive and negative tests

| Area | Required evidence after authorization |
|---|---|
| Organization | Valid record; blank/whitespace-only name rejected by PostgreSQL independently of Rails. |
| Brand | Valid parent succeeds; null/missing Organization and direct-SQL orphan fail; referenced Organization deletion fails. |
| Branch | Valid parent/timezone succeeds; null/missing Brand and direct-SQL orphan fail; blank timezone fails; referenced Brand deletion fails. |
| Multiplicity | Multiple Organizations, multiple Brands per Organization, and multiple Branches per Brand can coexist; no singleton assumption. |
| Names | Duplicate names are allowed because they are not approved identifiers. |
| Schema | Fresh migration, rollback/reapply while empty, and `structure.sql` load reproduce named objects. |
| Isolation | Existing Order/Payment/Audit/Preparation specs remain unchanged and passing; no test requires production mapping. |

No test may assert unapproved Code, lifecycle, production mapping, or authorization behavior.

For each of the four nonblank columns, direct-SQL inserts/updates must reject these exact value expressions:

| Case | SQL value expression | Expected result |
|---|---|---|
| Empty | `''` | Named nonblank check violation |
| Ordinary space | `'   '` | Named nonblank check violation |
| Horizontal tab | `E'\t\t'` | Named nonblank check violation |
| Line feed | `E'\n\n'` | Named nonblank check violation |
| Carriage return | `E'\r\r'` | Named nonblank check violation |
| Form feed | `E'\f\f'` | Named nonblank check violation |
| Vertical tab | `chr(11) || chr(11)` | Named nonblank check violation |
| Mixed defined whitespace | `E' \t\n\r\f' || chr(11)` | Named nonblank check violation |
| Includes content | `E' \tA\n'` | Accepted by the nonblank check |

Direct SQL must accept a value containing at least one non-whitespace character, including a value with allowed leading/trailing whitespace, because A1 does not add trimming or normalization.

## 10. Database roles and direct-SQL boundary

### 10.1 Verified repository state

- Development/test Compose supplies `POSTGRES_USER=postgres`; `config/database.yml` defaults to the same principal. Current local development/test therefore does not demonstrate migration/runtime separation.
- The existing Integrity Rules record that this development/test principal is superuser, table owner, migration role, and runtime role for current evidence.
- Production configuration supplies only opaque `DATABASE_URL`; the repository does not reveal its role name, ownership, membership, or privileges.
- No repository `CREATE ROLE`, `GRANT`, `REVOKE`, `ALTER DEFAULT PRIVILEGES`, infrastructure role definition, or production privilege export was found.
- `structure.sql` uses `Owner: -` metadata and cannot identify the real production table owner.

Therefore the production migration/table-owner role, application runtime role, reader role, role memberships, schema privileges, table grants, and default privileges are all `UNVERIFIED`. A1 does not assign invented role names.

### 10.2 Proposed privilege boundary

- The separately identified migration owner creates A1 objects under ADR-0010 conventions.
- A1 defines no runtime operation. The production-like runtime role should receive no `INSERT`, `UPDATE`, `DELETE`, `TRUNCATE`, `TRIGGER`, `REFERENCES`, ownership, or schema-`CREATE` privilege on A1 objects.
- Runtime `SELECT` is also unnecessary before a separately authorized consumer exists; any later grant must be explicit.
- Development/test credentials may perform factory/spec DML only in those environments; their broad local power is not production evidence.
- Migration-owner and break-glass access remains exceptional, separately controlled, monitored, and outside A1 runtime behavior.

### 10.3 Required production-like verification

The later authorized evidence run must record `current_user`/`session_user`, table owners, role memberships, explicit grants, and default privileges. At minimum it must inspect:

```sql
SELECT current_user, session_user;

SELECT c.relname, r.rolname AS owner
FROM pg_class c
JOIN pg_roles r ON r.oid = c.relowner
WHERE c.relnamespace = 'public'::regnamespace
  AND c.relname IN ('organizations', 'brands', 'branches');

SELECT *
FROM information_schema.role_table_grants
WHERE table_schema = 'public'
  AND table_name IN ('organizations', 'brands', 'branches');

SELECT defaclrole::regrole, defaclnamespace::regnamespace,
       defaclobjtype, defaclacl
FROM pg_default_acl;
```

After supplying the named bind placeholders from role names discovered in the target environment—not names invented by A1—the verification must also run:

```sql
SELECT privilege,
       has_table_privilege(:runtime_role, table_name, privilege) AS allowed
FROM unnest(ARRAY['SELECT', 'INSERT', 'UPDATE', 'DELETE',
                  'TRUNCATE', 'TRIGGER', 'REFERENCES']) AS privileges(privilege)
CROSS JOIN unnest(ARRAY['public.organizations',
                        'public.brands',
                        'public.branches']) AS tables(table_name);

SELECT has_schema_privilege(:runtime_role, 'public', 'CREATE') AS can_create;

SELECT pg_has_role(:runtime_role, :table_owner_role, 'MEMBER') AS owns_via_membership;

SELECT rolname, rolsuper, rolinherit, rolcreaterole, rolcreatedb
FROM pg_roles
WHERE rolname = :runtime_role;
```

The result must be false for `INSERT`, `UPDATE`, `DELETE`, `TRUNCATE`, `TRIGGER`, and `REFERENCES`, and false for `SELECT` unless a later authorized consumer explicitly needs it. Schema `CREATE` and membership in the table-owner role must be false. Because ownership and superuser status can bypass ordinary grants, the evidence must additionally record `rolsuper`, `rolinherit`, `rolcreaterole`, and `rolcreatedb` from `pg_roles` for the discovered runtime role.

As that runtime principal, negative operations in an explicit transaction must prove it cannot insert/update/delete/truncate A1 rows, create or disable triggers, alter/drop constraints, or change table ownership. The verification must roll back its transaction and retain the exact statement, SQLSTATE, and server error. These checks run only in a disposable production-like environment; this proposal does not run them against production.

A1 does not claim to close `CAT-TRR-007`; this evidence remains unavailable.

## 11. Audit and authorization boundary

A1 schema installation is a migration operation, not an Organization/Brand/Branch business mutation command. Because A1 creates no business rows and exposes no runtime operation:

- it emits no AuditEvent;
- it does not change the AuditEvent schema or append-only trigger;
- it does not require Identity Milestone 2B; and
- it does not accept actor, role, Brand, Branch, or delegation input.

This isolation does not waive future requirements. Provisioning production reference rows, changing reference master data, or exposing administration operations requires explicit authorization, trusted identity/capability checks, an approved audit taxonomy/scope, atomic audit persistence where required, and negative tests. A migration log is not a substitute for business audit once business data operations enter scope.

## 12. CAT-TRR finding impact matrix

| Finding | A1 effect | Preserved status | Minimum evidence / boundary |
|---|---|---|---|
| `CAT-TRR-001` authoritative mapping | Does not block empty A1 schema; blocks A2 records, mappings, writer changes, and operational FKs. | `BLOCKER`; unchanged | Per-target inventory, Owner-approved mapping/orphan disposition, checksum/review record before A2. |
| `CAT-TRR-003` Identity/Brand audit | Isolated because A1 exposes no runtime business operation. | `BLOCKER`; unchanged | Trusted authorization/delegation plus Brand-scoped audit before any later administration or lifecycle command. |
| `CAT-TRR-004` AuditEvent migration | Not in A1; AuditEvent is unchanged. | `HIGH`; unchanged | No-row-update migration proof remains required before Brand-scoped audit work. |
| `CAT-TRR-005` Catalog no-Purge | Not applicable to the three reference tables; A1 creates no Category/Product/Variant. | `HIGH`; unchanged | Catalog delete guards/runtime grants remain Package B/C work. |
| `CAT-TRR-006` Catalog concurrency | Not applicable to A1 local FK/check invariants. | `HIGH`; unchanged | Default/lifecycle multi-connection evidence remains Package B/C work. |
| `CAT-TRR-007` database roles | Applies to A1 migration ownership and future runtime access; not closed by schema design. | `HIGH`; unchanged | Document grants; prove runtime cannot mutate A1 before authorization; preserve controlled migration/break-glass access. |
| `CAT-TRR-008` migration/error mapping | Applies to A1 migration reproducibility; domain error mapping does not apply because A1 exposes no command. | `MEDIUM`; unchanged | Fresh/rollback/reapply/`structure.sql` evidence and named constraint identity after authorized implementation. |

This proposal closes no CAT-TRR finding and does not alter finding history.

## 13. Explicit exclusions

A1 excludes all of the following:

- Production Organization, Brand, or Branch rows, identifiers, names, timezones, or mappings.
- Inventory execution against a target database without separate authority.
- Migration or remediation of existing operational Branch data.
- Foreign keys from Orders, AuditEvents, PreparationDispatches, or any existing table to Branch.
- Changes to existing Branch-bearing writers, factories, records, or constraints.
- Category, Product, Product Variant, Modifier, Price, availability, Recipe, inventory, Order Item, or menu data.
- Catalog runtime read/create/update/delete and Default designation operations.
- Category/Variant lifecycle commands.
- Product lifecycle commands and Product Category reassignment.
- Identity Milestone 2B, authentication, authorization, delegation, sessions, and account models.
- AuditEvent redesign or Brand-scoped audit implementation.
- API, frontend, jobs, seeds, deployment, production provisioning, or vendor selection.

## 14. Preconditions before a separate authorization request

The following proposal evidence must be accepted before an implementation-authorization request is appropriate:

1. Owner/reviewer confirms the exact A1 boundary and that omitted logical fields are deferred rather than silently approved or rejected.
2. The exact schema in §3, including deliberate absence of Code/status fields and name uniqueness, receives technical review.
3. The implementation request names the exact migration, minimal model, factory, spec, and `structure.sql` files permitted to change.
4. The migration review confirms no existing table, row, writer, seed, or operational FK changes.
5. The database-role plan identifies the real production-like owner/runtime roles and default privileges, then records evidence for the absence of runtime DML/DDL authority described in §10. This evidence is currently `UNVERIFIED`.
6. The test plan includes database-bypass, multiplicity, fresh-load, rollback/reapply, and no-seed assertions.
7. The request defines successful exit evidence and states that failure of any check leaves A1 incomplete.
8. Working-tree ownership is reviewed so implementation does not overwrite or bundle unrelated documentation changes.

Target-environment mapping is not an A1 authorization precondition because A1 creates no production records or operational FKs. It remains a mandatory A2 precondition and `CAT-TRR-001` remains open.

## 15. Authorization-readiness verdict

### `READY_FOR_SEPARATE_AUTHORIZATION_REVIEW`

A1 has a precise schema, migration boundary, test strategy, existing-table non-impact rule, audit/Identity isolation, and finding classification. It can be presented in a later task for an explicit, narrowly bounded implementation decision once the preconditions in §14 are accepted.

This verdict means only that the proposal is reviewable. It does not mean implementation-ready evidence already exists, does not authorize implementation, and does not authorize A2, Package B, Package C, production records, operational FKs, or deployment.
