---
status: accepted
date: 2026-11-14
---

# ADR-0001: Rails API modular monolith

**Status:** Accepted

## Context

AFTER FOUR has one React/Vite frontend and no backend. Its confirmed invariants span catalog, orders, payment, authorization, preparation, audit, and reliable post-commit work. The current team and workload provide no evidence that independently deployed services would offset their distributed transactions, deployment, observability, and support cost.

## Decision

Build one API-only Rails application backed by one PostgreSQL database. Keep business ownership explicit in in-process modules for Identity, Organization, Catalog, Sales, Billing, Preparation, and Platform facilities. Controllers adapt HTTP to named use cases; use cases own authorization-aware transaction boundaries; Active Record owns persistence; presenters own `/api/v1` DTOs.

The modular boundaries are code and ownership boundaries, not deployment boundaries. Payment providers and printers are external seams behind application-owned adapters. Do not introduce microservices, a service mesh, Kubernetes, an event-streaming platform, a generic repository layer, or a command bus without measured requirements.

## Alternatives considered

- Microservices: rejected for MVP because they add remote failure and cross-service consistency without independent scaling or ownership evidence.
- Serverless functions: rejected as the primary shape because the domain depends on cohesive transactions, locks, migrations, workers, and long-lived operational ownership.
- A custom Rack/API stack: rejected because it would recreate Rails facilities for persistence, migrations, security, request handling, and jobs.

## Trade-offs

The monolith is easier to transact, test, deploy, and observe. It requires discipline to prevent cross-module coupling and can eventually need extraction if ownership or scaling materially diverges.

## Security implications

One trusted server boundary centralizes authentication, authorization, redaction, audit, and Branch scoping. Internal module calls are not an authorization bypass; every external request enters through the authenticated policy boundary.

## Operational implications

Operate one web application, one PostgreSQL database, and a worker process only when durable jobs begin. Monitor module-specific failures and queue/outbox health inside the shared deployment.

## Consequences

The first backend can protect full-payment-before-preparation in one local transaction. Future extraction requires evidence and an explicit superseding ADR.
