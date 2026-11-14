---
status: proposed
date: 2026-11-14
---

# ADR-0008: Deployment process and environment separation

**Status:** Proposed

## Context

The repository has no backend deployment, hosting target, CI workflow, secrets source, backup schedule, restore procedure, or production ownership. Environment separation is required before real credentials or payment behavior exist.

## Decision

Maintain distinct development, test, staging, and production environments with separate databases, credentials, secrets, hostnames, queues, and external-provider modes. Build immutable application artifacts from reviewed source; run automated checks before promotion; apply backward-compatible migrations through a designated release step; deploy web and worker processes from the same version; verify readiness; and support roll-forward as the default recovery method.

Development may use local PostgreSQL, seeded non-sensitive data, test identity, synchronous jobs where a test requires it, and fake external adapters. Staging mirrors production topology sufficiently for migrations, workers, security, provider sandboxing, backups, and restore drills. Production forbids test adapters, default credentials, debug responses, and source-controlled secrets.

## Alternatives considered

- One shared non-production environment: rejected because tests and credentials would interfere and production behavior would remain unrehearsed.
- Manual server mutation: rejected because releases and rollback evidence would not be repeatable.
- Containers/Kubernetes as a mandatory baseline: not selected; packaging and hosting should follow the approved platform without adding orchestration by default.
- Blue/green or canary delivery: deferred until availability and traffic requirements justify it.

## Trade-offs

Separate environments and immutable promotion cost hosting, CI time, and operational ownership. They reduce accidental data/credential crossover and make migrations and recovery testable.

## Security implications

Use least-privilege runtime and migration credentials where practical, TLS outside local development, an approved secrets manager/environment injection, dependency scanning, audit of production access, log redaction, and isolated production data. Never copy production personal/payment data into development.

## Operational implications

Production needs named owners for releases, migrations, alerts, incidents, backups, restores, and secrets rotation; documented RTO/RPO; readiness/liveness probes; and restore rehearsal.

## Consequences

Status remains Proposed until the Owner/operations reviewer approves the hosting platform, same-site routing/TLS boundary, secrets facility, release and migration owner, worker topology, monitoring/alert ownership, backup retention, RTO/RPO, maintenance window, and incident escalation. Local foundation work may proceed without choosing Kubernetes or a cloud vendor.
