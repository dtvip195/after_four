---
status: accepted
date: 2026-11-14
---

# ADR-0009: Versioned REST/JSON API conventions

**Status:** Accepted

## Context

The React frontend needs a stable server contract that keeps business state, authorization, totals, idempotency, and concurrency authoritative on the backend. The canonical API contract already defines the required seam.

## Decision

Expose REST/JSON under `/api/v1`. Use plural kebab-case resources, opaque UUIDs, named command resources, canonical success/error envelopes, cursor pagination, `Idempotency-Key` for retryable commands, and `If-Match`/ETag for mutable aggregate concurrency. Clients never set arbitrary status, totals, User, role, Organization, or trusted Branch scope.

Breaking representation or semantic changes require a new major URL version or an explicitly documented compatibility plan. Additive optional fields and endpoints may remain within v1. Controllers remain HTTP adapters and presenters define explicit DTOs rather than serializing Active Record graphs.

## Alternatives considered

- GraphQL: rejected because current commands, authorization, and recovery flows map cleanly to explicit resources and do not need client-shaped graphs.
- Unversioned endpoints: rejected because frontend/backend deployment can drift.
- Header-only versioning: rejected for the initial API because URL versioning is more visible in routes, logs, tests, and support tooling.
- Generic `PATCH status`: rejected because it bypasses named guards and audit semantics.

## Trade-offs

Explicit resources and presenters add DTO code, but make authority, compatibility, audit, and testing clear. URL versions can duplicate routes during a future transition.

## Security implications

The contract centralizes authentication, CSRF where applicable, Branch non-disclosure, request limits, allowlisted filters, redacted errors, and provider webhook verification. IDs do not grant access.

## Operational implications

Logs and metrics include API version, route template, request ID, stable error code, and duration. Deprecation and compatibility windows require explicit release communication.

## Consequences

Frontend fixture types are not API contracts. Contract/request tests guard v1 before frontend DTO adapters consume it.
