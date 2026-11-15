---
status: accepted
date: 2026-11-15
---

# ADR-0011: Project-wide Layered DDD

**Status:** Accepted
**Owner classification:** `OWNER_CONFIRMED`
**Decision date:** 2026-11-15

## Context

AFTER FOUR is an API-only Rails modular monolith with multiple Bounded Contexts. ADR-0001 assigns business ownership to in-process modules, Active Record to persistence, named use cases to transaction orchestration, and controllers/presenters to HTTP adaptation. ADR-0005 provides conventional Rails directories plus domain namespaces. Those decisions do not require Domain objects to inherit from Active Record and do not define a complete layer dependency rule.

Package A1 demonstrated strict separation for the Organization reference foundation: framework-independent Domain Entities live under `backend/app/domains/organization/domain/entities/`, while namespaced Active Record records and persistence projection live under `backend/app/domains/organization/infrastructure/persistence/`. No A1 business workflow or HTTP surface exists, so it intentionally has no Application or Presentation implementation.

Existing Ordering, Payment, Preparation, Platform, and other code predates this decision or has not been assessed against it. Project-wide adoption therefore requires a forward rule without silently authorizing wholesale migration.

## Decision

Layered DDD is mandatory for all AFTER FOUR source code created or modified from 2026-11-15 onward. Each Bounded Context uses four logical layers when the corresponding responsibility exists:

| Layer | Owns | Rules |
|---|---|---|
| Domain | Entities, Value Objects, Aggregates, invariants, business rules and genuinely needed Domain Services | Framework-independent. It does not depend on Rails, Active Record, PostgreSQL, HTTP, Application, Infrastructure, or Presentation. |
| Application | Use Cases, Commands, Queries, orchestration, transaction coordination and coordination of Domain behavior with required capabilities | It coordinates business operations but does not own core domain rules or expose persistence records to Presentation. Create Application modules only for real use cases. |
| Infrastructure | Active Record persistence records, PostgreSQL integration and enforcement, persistence projection/mapping, external adapters and implementations of required contracts | Framework and database mechanisms remain here. Add a port, repository, mapper, or other abstraction only when a demonstrated use case requires the seam. |
| Presentation | HTTP controllers/endpoints, request adaptation, presentation-specific validation, serializers and response DTOs | It delegates business workflows to Application and does not manipulate persistence records directly or expose them as public contracts. |

The dependency direction is:

```text
Presentation ──> Application ──> Domain
                       │
                       └──> required contracts

Infrastructure ──> Domain
Infrastructure ──> contracts it implements
Domain ──> no outer layer
```

Composition may connect Infrastructure implementations to Application contracts without creating generic abstractions. This is Layered DDD inside the accepted modular monolith, not a requirement to adopt Clean Architecture, Rails engines, generic repositories, a command bus, microservices, or one directory per empty layer.

Each Bounded Context owns its domain behavior and data responsibilities as defined by the canonical Business Domain Model. A context must not manipulate another context's Infrastructure records without an explicitly approved integration contract. Introduce that contract only when a concrete cross-context interaction requires it; A1 establishes no reusable cross-context interface.

### Forward-compliance rule

1. New source code follows this decision.
2. Modified source code follows it within the explicitly authorized change scope.
3. Existing source code is not automatically authorized for repository-wide refactoring.
4. Relevant existing violations are identified and reported when encountered.
5. Refactoring existing code requires explicit authorization.
6. Architecture compliance never expands a task into unrelated migration or cleanup.

### A1 verified example

The first implemented example is limited to the A1 Organization/Brand/Branch reference foundation:

- Domain Entities: `backend/app/domains/organization/domain/entities/{organization,brand,branch}.rb`.
- Infrastructure records: `backend/app/domains/organization/infrastructure/persistence/{organization_record,brand_record,branch_record}.rb`.
- Domain Entities represent identity, names, parent identifiers, relationships and the Branch timezone value without Rails or persistence dependencies.
- Infrastructure records own table mapping, associations, database-aligned validations, optimistic locking, restrictive dependent deletion and the implemented `to_domain` projection.
- No domain-to-persistence write mapping exists because no provisioning or administration use case is authorized.
- No Application or Presentation class exists because A1 has no authorized workflow or HTTP surface.

This example is `IMPLEMENTED` only for the A1 boundary. It does not prove that the whole Organization context or repository conforms, establish production readiness, or define future cross-context integration.

## Alternatives considered

- Continue pragmatic Active Record models as Domain Entities: rejected for new or modified code because it couples domain behavior to persistence and prevents the Owner-selected separation.
- Retrospectively refactor every context immediately: rejected because architecture adoption does not authorize unrelated source changes and would enlarge risk without bounded acceptance criteria.
- Mandate repositories, ports and mappers for every record: rejected because one implementation does not justify a hypothetical seam and shallow abstractions increase maintenance cost.
- Split contexts into engines or services: rejected; ADR-0001's single Rails application and PostgreSQL database remain accepted.

## Trade-offs

Framework-independent Domain behavior improves dependency clarity and isolated testing. The separation adds namespacing, persistence projection and more explicit composition. Applying it only as code is touched leaves a deliberate transition period in which legacy and Layered DDD structures coexist.

## Security implications

Presentation cannot bypass Application for business workflows, and Infrastructure records are not public request/response contracts. Authentication, authorization, trusted scope and audit remain application-boundary requirements; layer placement alone does not supply those controls.

## Operational implications

Zeitwerk/eager-load checks, layer-focused specs, database integrity tests and dependency review become required evidence for affected backend changes. Production readiness, deployment topology and database roles remain governed by their own decisions.

## Consequences

ADR-0001 and ADR-0005 remain Accepted. This ADR refines their source-code responsibility and dependency rules without changing the modular-monolith deployment boundary, Active Record/PostgreSQL persistence choice, or existing namespace-vocabulary proposal.

Existing contexts remain `NOT_YET_MIGRATED` or `UNVERIFIED` until a scoped review and authorized refactor provides evidence. Empty Application or Presentation directories/classes are not conformance evidence. Business or architecture decisions not settled by this ADR remain explicitly unresolved.
