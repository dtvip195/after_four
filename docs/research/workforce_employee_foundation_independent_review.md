# AFTER FOUR — Workforce Employee Foundation Independent Review

**Review date:** 2026-11-26

**Status:** `INDEPENDENT_REVIEW_PASS_WITH_FOLLOW_UPS`

**Branch:** `feat/workforce-employee-foundation`

**Base and current HEAD:** `17863521259eab1f5e768cce0b4acec70d707785`

**Review mode:** Independent read-only inspection of implementation changes. The only repository write made by this review is this explicitly requested review artifact; no pre-existing file was modified.

## 1. Findings

### 1.1 Non-blocking — direct PostgreSQL contract evidence is incomplete

The implementation matches the authorized physical schema, but the checked-in Workforce persistence spec does not directly assert every database contract named in the implementation authorization.

[`employee_persistence_spec.rb`](../../backend/spec/domains/workforce/infrastructure/employee_persistence_spec.rb) lines 116–167 exercises real foreign-key failure, restrictive Organization deletion, non-unique Organization index, lock-version default/check, and optimistic locking. It does not directly:

- insert an Employee without an `id` and prove the PostgreSQL UUID default;
- inspect the Employee primary key;
- inspect timestamp SQL types and nullability;
- assert the exact names `fk_employees_organization` and `employees_lock_version_nonnegative`;
- perform a Workforce-specific migration down/up cycle and prove rollback removes only `employees`.

Generic migration accounting includes `20261126120000` in [`disposable_migration_database.rb`](../../backend/spec/support/disposable_migration_database.rb) lines 10–23, and static inspection of the migration plus `structure.sql` confirms the intended definitions. The existing helper's down/up methods remain Catalog-specific at lines 26–30 and do not independently establish Workforce rollback behavior. This is an evidence-hardening follow-up, not a schema or runtime blocker.

### 1.2 Informational — readiness-report preservation has no Git baseline object

The readiness report is untracked at the fixed point, so Git cannot prove byte-for-byte preservation against an earlier repository object. Its SHA-256 at both the start and end of this review is:

`afaf6050209cd78cc6f810ba5e95a6870a02d553a08e573cda0e50fba2f48609`

The review did not modify it.

### 1.3 Blockers

None found.

## 2. Git baseline and exact diff inventory

`HEAD` resolves exactly to the supplied base commit. There are no implementation commits after the base; the implementation is intentionally held in the working tree.

Five tracked existing files are modified:

1. `backend/db/structure.sql`
2. `backend/spec/architecture/i1_dependency_spec.rb`
3. `backend/spec/integration/catalog_concurrency_spec.rb`
4. `backend/spec/integration/catalog_isolation_spec.rb`
5. `backend/spec/support/disposable_migration_database.rb`

Twelve implementation files are added:

1. `backend/app/contexts/workforce/package.yml`
2. `backend/app/contexts/workforce/domain/value_objects/employee_id.rb`
3. `backend/app/contexts/workforce/domain/value_objects/organization_reference.rb`
4. `backend/app/contexts/workforce/domain/aggregates/employee.rb`
5. `backend/app/contexts/workforce/application/ports/employee_repository.rb`
6. `backend/app/contexts/workforce/infrastructure/persistence/employee_record.rb`
7. `backend/app/contexts/workforce/infrastructure/persistence/employee_mapper.rb`
8. `backend/app/contexts/workforce/infrastructure/persistence/active_record_employee_repository.rb`
9. `backend/db/migrate/20261126120000_create_workforce_employee_foundation.rb`
10. `backend/spec/domains/workforce/domain/employee_spec.rb`
11. `backend/spec/domains/workforce/infrastructure/employee_persistence_spec.rb`
12. `docs/research/workforce_employee_foundation_implementation.md`

The separate pre-existing untracked readiness report is preserved. This review adds only `docs/research/workforce_employee_foundation_independent_review.md`.

## 3. Schema verification

[`20261126120000_create_workforce_employee_foundation.rb`](../../backend/db/migrate/20261126120000_create_workforce_employee_foundation.rb) lines 3–16 creates exactly one table and only the authorized controls.

| Requirement | Verified evidence |
|---|---|
| UUID primary key with `gen_random_uuid()` | Migration line 3; resulting `structure.sql` lines 608–609 and 1462–1466 |
| `organization_id uuid NOT NULL` | Migration line 4; structure lines 610 and 2371–2372 |
| Explicit restrictive FK | `fk_employees_organization`, migration lines 9–12; structure lines 2368–2372 with `ON DELETE RESTRICT` |
| Explicit non-unique Organization index | `index_employees_on_organization_id`, migration lines 13–14; structure lines 1740–1743 uses `CREATE INDEX`, not `CREATE UNIQUE INDEX` |
| Lock default and named check | Migration lines 5 and 15–16; structure lines 611 and 614 |
| Required timezone-aware timestamps | Migration line 6 under repository convention; structure lines 612–613 show non-null `timestamp(6) with time zone` |

The complete tracked `structure.sql` diff adds only:

- the `employees` table;
- `employees_pkey`;
- `index_employees_on_organization_id`;
- `fk_employees_organization`;
- migration version `20261126120000`.

No pre-existing table, column, constraint, trigger, index, function, or data definition is altered. No seed Employee exists.

## 4. Domain and persistence review

### 4.1 Employee identity and reconstitution

[`employee_id.rb`](../../backend/app/contexts/workforce/domain/value_objects/employee_id.rb) lines 5–15 and [`organization_reference.rb`](../../backend/app/contexts/workforce/domain/value_objects/organization_reference.rb) lines 5–15 accept only lowercase canonical UUID text, duplicate and freeze the supplied string, and freeze the Value Object.

[`employee.rb`](../../backend/app/contexts/workforce/domain/aggregates/employee.rb) lines 8–18 requires new identity version zero. Lines 20–51 require the two context-local Value Object types and a nonnegative integer version during reconstitution, expose no mutation, and freeze the Aggregate. No Employee existence predicate is interpreted as employment, Branch eligibility, or authorization.

[`employee_mapper.rb`](../../backend/app/contexts/workforce/infrastructure/persistence/employee_mapper.rb) lines 5–18 passes persisted values directly through strict Value Object/Aggregate constructors. It does not downcase, cast, default, repair, or invent malformed state. Invalid persistence therefore fails rather than becoming a valid Aggregate.

### 4.2 Repository contract

[`employee_repository.rb`](../../backend/app/contexts/workforce/application/ports/employee_repository.rb) lines 4–13 exposes only `add` and the Organization-scoped `find`.

[`active_record_employee_repository.rb`](../../backend/app/contexts/workforce/infrastructure/persistence/active_record_employee_repository.rb) lines 17–36 requires typed Organization and Employee references and queries on both `organization_id` and `id`. There is no unscoped repository lookup. Wrong-Organization and unknown-Employee lookups both return `nil`, as exercised at `employee_persistence_spec.rb` lines 73–106.

`add` maps once and performs one `save!` at repository lines 11–15. It translates the current duplicate-ID failure to the port error. Mapper failure occurs before persistence; one SQL insert is atomic, so no partial Employee row is created by this path.

### 4.3 Optimistic locking

`lock_version` enables Active Record's Infrastructure locking mechanism. The `touch` calls at `employee_persistence_spec.rb` lines 160–167 are test-only. No repository update method, Domain mutation, Application use case, or production mutation path was introduced.

## 5. Context and identity boundaries

[`employee_record.rb`](../../backend/app/contexts/workforce/infrastructure/persistence/employee_record.rb) lines 4–5 contains only the table mapping and declares no `belongs_to` or other Active Record association. The database FK validates Organization existence without a Ruby dependency on Organization Infrastructure.

Repository-wide production-source searches found:

- no `Identity::` reference under Workforce;
- no Organization Infrastructure or persistence-record reference under Workforce;
- no Workforce dependency other than the root technical package in `package.yml` lines 1–4;
- no User link, Employee Code, lifecycle/status, Branch Assignment, personal-data, role, capability, or authorization field;
- no Membership model, package, constant, migration, or table;
- no controller, job, callback, service, policy, scheduled task, API, or composition-root reference to `EmployeeRecord`, `EmployeeRepository`, or `ActiveRecordEmployeeRepository`.

The only production definitions of these constants are the bounded Workforce Domain/Application/Infrastructure classes themselves. Any Ruby constant can be manually instantiated from a console, but no current production runtime entry point resolves or calls `EmployeeRepository#add`.

## 6. Review of modified existing files

- `structure.sql`: exact schema additions described in section 3; no unrelated dump churn.
- `i1_dependency_spec.rb` lines 64–124: enforces Workforce Domain/Application framework independence, no Identity/Organization-internal dependency, strict root-only package shape, no Membership in Workforce/migrations, and no composition wiring.
- `catalog_concurrency_spec.rb` lines 10–15 and `catalog_isolation_spec.rb` lines 6–11: add `employees` to test cleanup because its restrictive FK references `organizations`; Catalog behavior is unchanged.
- `disposable_migration_database.rb` lines 10–30 and 407–458: adds the new migration to the complete version inventory and excludes the later Workforce schema from Catalog's pre-existing-schema fingerprint, matching the helper's existing treatment of later Identity tables.

No unrelated user change was incorporated or discarded.

## 7. Test evidence actually reproduced

The pure Domain spec was independently rerun under the repository's pinned Ruby 3.4.13 container with `--no-deps`, so no database service was started. Generated RSpec/SimpleCov artifacts were redirected to a temporary directory outside the repository.

Result: `6 examples, 0 failures`.

`git diff --check` also passed.

The PostgreSQL-backed specs, migration up/down, structure load, Packwerk, full RSpec suite, RuboCop, Zeitwerk, Brakeman, and Bundler Audit were **not** rerun in this review. Running the database evidence would conflict with the explicit prohibition on database writes. Their prior reported results were not treated as independently reproduced evidence. The test source was inspected, producing the non-blocking evidence gap in section 1.1.

## 8. Two-axis review

### Standards

No documented-standard violation or actionable code smell was found. Domain rules remain pure Ruby; Application owns the narrow port; Active Record, mapping, and persistence remain in Infrastructure; dependency direction matches ADR-0011 and `AGENTS.md`. Context-local UUID types are intentional and do not justify a shared kernel. The mapper and repository are demonstrated seams required by the approved slice, not speculative abstractions.

Standards result: 0 blockers, 0 non-blocking violations, 2 informational observations (console-level constant availability and the untracked readiness-report baseline limitation).

### Spec

No missing implementation behavior, incorrect behavior, or scope creep was found. The sole non-blocking finding is incomplete direct test evidence for every named schema/rollback contract, as detailed in section 1.1.

Spec result: 0 blockers, 1 non-blocking evidence follow-up, 0 scope-creep findings.

## 9. Critical-question answers and verdict

| Question | Answer |
|---|---|
| Can production runtime code call `EmployeeRepository#add`? | No current production caller or composition wiring exists. The adapter constant itself is public Ruby code but is not exposed as a business entry point. |
| Can Employee retrieval omit Organization scope? | Not through the repository port or adapter; both require a typed `organization_reference`. |
| Can malformed persistence be silently repaired? | No. Strict Value Object and Aggregate construction raises on invalid identifiers/version. |
| Does the FK create runtime cross-context coupling? | No. It enforces physical existence/restrictive deletion while Workforce stores a scalar opaque reference and declares no Organization association. |
| Is Employee existence treated as employment, Branch eligibility, or authority? | No such predicate, state, field, or use case exists. |
| Does optimistic locking create an unauthorized mutation path? | No. Only Infrastructure mechanics and test-only `touch` evidence exist; no production mutation command was added. |
| Does the migration alter an existing database object? | No; static migration and complete structure diff show only the authorized new table and controls. |

`INDEPENDENT_REVIEW_PASS_WITH_FOLLOW_UPS`

The implementation conforms to the approved schema-only slice and ownership boundaries, with no production Employee write path. Before treating database evidence as maximally complete, add direct PostgreSQL assertions for the remaining named schema contracts and a Workforce-specific rollback test under a separately authorized implementation change.
