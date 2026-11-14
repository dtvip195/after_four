---
status: accepted
date: 2026-11-14
---

# ADR-0005: Backend repository and directory structure

**Status:** Accepted

## Context

The repository already contains an independently buildable Vite application under `frontend/`. Moving it would add risk without improving the backend foundation.

## Decision

Place the Rails application under `backend/`. Keep `frontend/`, `backend/`, and shared architecture documentation at the repository root. Within Rails, use conventional framework directories plus explicit domain namespaces:

```text
backend/app/
  controllers/api/v1/
  domains/{identity,organization,catalog,sales,billing,preparation,platform}/
  models/
  policies/
  presenters/
  jobs/
```

Feature-specific business rules remain in their owning domain. `platform` is limited to technical facilities such as request context, idempotency, and outbox delivery.

## Alternatives considered

- Put Rails at repository root: rejected because it would blur two runtime roots and disturb the working frontend.
- Separate repositories: rejected because coordinated API/frontend work and documentation currently have one team and release boundary.
- Package each domain as a gem or engine immediately: rejected as premature packaging.

## Trade-offs

A monorepo simplifies coordinated changes and CI but requires commands to run from the correct runtime directory. Namespace boundaries rely on review and tests rather than network isolation.

## Security implications

Frontend code never receives backend secrets. Runtime environment files and credentials remain scoped to `backend/` and excluded from source control.

## Operational implications

CI and deployment explicitly select `frontend/` or `backend/`; generated artifacts and dependency caches stay inside their runtime boundary.

## Consequences

Rails foundation work must not relocate or weaken the current frontend. A repository split requires a later ADR.
