---
status: accepted
date: 2026-11-14
---

# ADR-0007: Active Job, Solid Queue, and transactional outbox

**Status:** Accepted

## Context

Payment reconciliation, paid-order dispatch, and later external effects must survive process failure without holding database transactions open across network calls. Current scale does not justify Redis, Sidekiq, or a message broker.

## Decision

Use Active Job with Solid Queue, the database-backed queue for the candidate Rails baseline, when durable asynchronous work begins. If ADR-0002 changes the Rails series before scaffolding, revalidate Solid Queue compatibility without changing the application-owned Active Job interface. Use a transactional `outbox_events` record whenever committed business state requires retryable post-commit work. The business update and outbox insert commit together; workers claim safely, retry with bounded backoff, publish idempotently, and expose backlog/failure metrics.

Preparation Dispatch remains a business record; an outbox event and job are delivery mechanisms, not substitutes for it. External provider, printer, and notification I/O occurs outside open business transactions.

## Alternatives considered

- Inline callbacks: simpler but unsafe across commit/process failure and can extend request latency.
- Sidekiq/Redis: capable but adds another datastore and operating surface without measured throughput need.
- Event-streaming platform: rejected; no independent consumer or replay-scale requirement exists.
- Database polling without Active Job: possible but duplicates scheduling, retries, and instrumentation conventions.

## Trade-offs

Database-backed jobs reuse PostgreSQL and simplify initial operations, but queue load shares database capacity and requires worker supervision and cleanup. The outbox adds rows, retries, and reconciliation responsibilities.

## Security implications

Job arguments and outbox payloads contain only required identifiers and allowlisted metadata, never secrets or raw payment payloads. Workers run with least privilege and preserve actor/request correlation where needed.

## Operational implications

Run a separately supervised worker once asynchronous work is enabled. Monitor queue age, failure count, outbox backlog, reconciliation-required payments, and pending dispatches. Establish retry/dead-letter or operator-recovery procedures before production.

## Consequences

No Redis or broker is added initially. A different queue backend requires measured evidence and a superseding ADR.
