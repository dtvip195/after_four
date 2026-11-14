---
status: accepted
date: 2026-11-14
---

# ADR-0010: PostgreSQL migrations and SQL schema management

**Status:** Accepted

## Context

AFTER FOUR depends on PostgreSQL-specific check, partial unique, range/exclusion, and concurrency controls. Rails' portable schema representation cannot faithfully preserve every required database object.

## Decision

Use Rails migrations as the ordered change mechanism and PostgreSQL SQL schema dumps (`config.active_record.schema_format = :sql`, producing `structure.sql`) as the reviewable database snapshot. Migrations use explicit foreign keys, named checks, deliberate indexes, and reversible operations where safe. Enable extensions through reviewed migrations only.

Production changes follow expand/migrate/contract sequencing: add compatible structures, deploy code that tolerates old/new forms, backfill in bounded/restartable work, validate constraints, switch reads/writes, and remove old structures in a later release. Large locks, table rewrites, and index builds require PostgreSQL-specific review. Never edit production schema manually or rely on application validations alone.

## Alternatives considered

- Rails `schema.rb`: simpler, but cannot faithfully represent all PostgreSQL-specific constraints and objects required here.
- Hand-maintained SQL without Rails migrations: rejected because application/release ordering and test database setup would fragment.
- Automatic destructive rollback: rejected for data-bearing production migrations; roll-forward is safer after irreversible data changes.

## Trade-offs

`structure.sql` creates noisier PostgreSQL-specific diffs and requires compatible database tooling. It preserves the actual integrity design and exposes drift.

## Security implications

Migration credentials are more privileged than runtime credentials and should be separated where practical. Dumps and migration logs must not contain secrets or production data.

## Operational implications

CI creates a clean database, applies migrations, verifies the SQL dump, and runs constraint/concurrency tests. Releases designate a migration owner, statement/lock timeouts, backup criteria, monitoring, and a roll-forward procedure.

## Consequences

The application is intentionally PostgreSQL-specific. SQLite is not an implementation or concurrency-test substitute.
