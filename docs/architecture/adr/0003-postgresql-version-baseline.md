---
status: accepted
date: 2026-11-14
---

# ADR-0003: PostgreSQL 18 version baseline

**Status:** Accepted

## Context

AFTER FOUR requires strong relational constraints, transactions, row locking, partial indexes, ranges/exclusion constraints, UUIDs, and reliable backup/restore. As of 2026-11-14, PostgreSQL 18.7 is the current production release and major 18 is supported through 2030-11-14. PostgreSQL 19 is still a release candidate. The evidence is recorded in [runtime-version baseline research](../../research/after_four_runtime_version_baseline.md).

## Decision

Use PostgreSQL major `18` and start implementation on the newest tested 18.x minor available at scaffolding time; the evidence-date candidate is `18.7`. Pin major 18 across development, CI, staging, and production. Apply tested PostgreSQL minor/security releases promptly; minor updates do not require a new ADR.

## Alternatives considered

- PostgreSQL 17 or earlier supported majors: viable but provide a shorter remaining support horizon for a new system.
- PostgreSQL 19 RC: rejected because a release candidate is not a production baseline.
- SQLite: rejected because it cannot validate the required PostgreSQL locking, range/exclusion, partial-index, and concurrency behavior.
- Managed versus self-hosted PostgreSQL: left to the deployment ADR; either must provide compatible features, backups, monitoring, and restore access.

## Trade-offs

PostgreSQL-specific integrity makes the application less portable but directly protects the documented invariants. Major 18 may not be available on every hosting platform, which must be checked before platform approval.

## Security implications

Use supported minors, TLS where traffic crosses trust boundaries, least-privilege runtime/migration roles, restricted network access, encrypted backups, and audited production access.

## Operational implications

Monitor connections, locks, replication/backup health, disk, slow queries, and vacuum. Test restore and major-upgrade procedures. Use PostgreSQL 18 for concurrency and schema tests rather than an in-memory substitute.

## Consequences

Hosting must support PostgreSQL 18 and required extensions. A future major upgrade requires a compatibility, backup/restore, migration, and rollback plan and an ADR review.
