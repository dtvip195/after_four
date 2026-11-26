# AFTER FOUR — Workforce Employee Foundation PostgreSQL Schema Test Hardening

**Date:** 2026-11-26

**Status:** `SCHEMA_TEST_HARDENING_COMPLETE`

**Branch:** `feat/workforce-employee-foundation`

**Base/current HEAD:** `17863521259eab1f5e768cce0b4acec70d707785`

## 1. Scope and files

This test-only follow-up addresses the non-blocking evidence gap recorded in
[`workforce_employee_foundation_independent_review.md`](workforce_employee_foundation_independent_review.md).

Files added by this hardening task:

- `backend/spec/domains/workforce/infrastructure/employee_schema_spec.rb`
- `backend/spec/integration/workforce_employee_migration_lifecycle_spec.rb`
- `docs/research/workforce_employee_foundation_schema_test_hardening.md`

No migration, `structure.sql`, Domain, Application, Infrastructure, production source, dependency, configuration, readiness report, independent-review report, or other existing file was modified by this task.

## 2. PostgreSQL catalog and behavior assertions

`employee_schema_spec.rb` queries PostgreSQL catalogs directly through the real test connection. It does not infer the physical contract solely from Active Record model metadata.

The five focused examples prove:

1. `employees.id` is PostgreSQL `uuid`, is `NOT NULL`, has default `gen_random_uuid()`, and is the sole key of the `employees_pkey` primary-key constraint. A direct SQL insert that omits `id` returns a database-generated canonical UUID.
2. `created_at` and `updated_at` are `NOT NULL`, have no database default, and use `timestamp(6) with time zone`.
3. `organization_id` is `uuid NOT NULL`; `fk_employees_organization` uses `organization_id`, references `organizations.id`, and has PostgreSQL delete action `r` (`RESTRICT`).
4. `lock_version` is `integer NOT NULL DEFAULT 0`; `employees_lock_version_nonnegative` is the named CHECK for `lock_version >= 0`; a direct negative insert is rejected with `PG::CheckViolation` reporting that exact constraint name.
5. `index_employees_on_organization_id` is non-primary, non-unique, and has exactly `organization_id` as its key column.

The first run exposed only a test-representation mismatch: PostgreSQL 18.7's `pg_get_constraintdef` returns `CHECK (lock_version >= 0)`, while `pg_dump` renders the equivalent expression with an additional pair of parentheses. The expected catalog representation was corrected; no production or schema source changed.

## 3. Migration rollback and reapply evidence

`workforce_employee_migration_lifecycle_spec.rb` uses `DisposableMigrationDatabase`, which creates a uniquely named temporary database, runs the repository migration chain, and force-drops that isolated database in `ensure` cleanup.

The test:

1. migrates an empty isolated database through `20261126120000`;
2. records the full semantic schema and the Employee-specific table, column, constraint, index, and trigger rows;
3. rolls down exactly migration `20261126120000`;
4. proves every Employee-specific semantic-schema row is absent;
5. proves the complete unrelated semantic schema remains byte-for-byte equal to its pre-rollback representation;
6. proves the Workforce migration version is removed while rolled back;
7. reapplies exactly migration `20261126120000`;
8. proves the full semantic schema equals the original migrated schema and the migration version is restored.

This comparison is specific to Employee table-owned objects and does not hard-code unrelated global object lists.

## 4. Environment and actual results

PostgreSQL server queried from the isolated local Docker environment:

`18.7 (Debian 18.7-1.pgdg13+2)`

Commands and results:

| Command | Actual result |
|---|---|
| `bundle exec rspec spec/domains/workforce/infrastructure/employee_schema_spec.rb spec/integration/workforce_employee_migration_lifecycle_spec.rb --format progress` | First run: 6 examples, 1 test-formatting failure; final run: 6 examples, 0 failures. |
| `bundle exec rspec spec/domains/workforce --format progress` | 23 examples, 0 failures. |
| `bundle exec rspec spec/integration/workforce_employee_migration_lifecycle_spec.rb --format progress` | 1 example, 0 failures; independently runnable rollback/reapply evidence. |
| `bin/rubocop spec/domains/workforce/infrastructure/employee_schema_spec.rb spec/integration/workforce_employee_migration_lifecycle_spec.rb` | 2 files inspected, no offenses. |
| `git diff --check` | Passed. |

The full backend suite was not rerun and is not claimed by this task.

## 5. Git and preservation evidence

Initial state:

- branch `feat/workforce-employee-foundation`;
- HEAD `17863521259eab1f5e768cce0b4acec70d707785`;
- intentional uncommitted Employee Foundation implementation and reports present;
- readiness-report SHA-256 `afaf6050209cd78cc6f810ba5e95a6870a02d553a08e573cda0e50fba2f48609`;
- independent-review SHA-256 `458f847687bf8aec961f1a622321e4c24c13cb739cb7c0af8c5a8bb80622843e`.

Final state retains the same branch and HEAD. The two preserved report hashes are unchanged. The working tree remains intentionally dirty for Owner review, now with only the two new test files and this report added to the pre-existing implementation state.

No checkout, branch switch, stash, reset, clean, commit, push, merge, or pull request operation occurred.

## 6. Boundary confirmation

The approved Employee schema and implementation are unchanged. This task adds no mutable Employee command, runtime workflow, production write path, column, index, constraint, association, trigger, database object, gem, or dependency. It grants no Gate, deployment, or production authority.

`SCHEMA_TEST_HARDENING_COMPLETE`
