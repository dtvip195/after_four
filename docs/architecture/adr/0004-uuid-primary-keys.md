---
status: accepted
date: 2026-11-14
---

# ADR-0004: UUID primary keys for business records

**Status:** Accepted

## Context

Canonical resources are exposed through an API, may eventually be created across devices, and already use UUID candidate fields. Human identifiers such as order number, SKU, and Branch code have separate business meaning and lifecycle.

## Decision

Use PostgreSQL native `uuid` primary keys for application-owned business and technical records from the first migration. Rails generates UUID keys by default for application tables. Business identifiers remain separately constrained within their documented scope and are never primary keys. Framework-owned schemas such as Solid Queue retain their upstream-supported key types so upgrades remain safe; those internal identifiers are not exposed as AFTER FOUR resource IDs.

## Alternatives considered

- Rails-default bigint keys: smaller and more index-local, but expose predictable identifiers and make future multi-device/import identity coordination harder.
- Mixed UUID/bigint keys: rejected because it complicates associations, tooling, and conventions without a demonstrated benefit.
- Business codes as keys: rejected because codes can have formatting, scoping, or correction rules.

## Trade-offs

UUID indexes and foreign keys are larger and less cache-local than bigint. They provide opaque, independently generatable identifiers and one consistent API/database representation.

## Security implications

Opaque IDs reduce casual enumeration but are not authorization. Every read and command still enforces Organization and Branch scope server-side.

## Operational implications

Monitor index size and write locality. Database dumps, fixtures, logs, and support tools must handle UUIDs consistently.

## Consequences

Changing key strategy after migrations and foreign keys exist would be expensive; all first-slice tables therefore adopt UUID consistently.
