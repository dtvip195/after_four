---
status: proposed
date: 2026-11-14
applied: false
---

# ADR-0001/ADR-0005 context vocabulary amendment proposal

**Status:** Proposed amendment only; awaiting explicit Owner approval  
**Applied:** No

## Context

[ADR-0001](../0001-rails-modular-monolith.md) and [ADR-0005](../0005-backend-repository-structure.md) are Accepted and name `Sales` and `Billing` modules. Phase 1 implementation instead uses `Orders`, `Payments`, and `Preparation`, while empty `sales` and `billing` marker directories remain. The canonical business language uses Order, Payment, Payment Attempt, and Preparation Dispatch.

## Proposed amendment

Use the logical context vocabulary defined in [DDD Foundation](../../after_four_ddd_foundation.md): Ordering, Payment, Preparation, Catalog/Pricing, Table/Service, Cash Management, Workforce/Shift, Reporting, and Identity/Authorization. A later implementation plan would map these logical names to Rails namespaces deliberately; approval would not itself rename a folder or authorize code changes.

Retain one Rails API modular monolith, one PostgreSQL database, Active Record persistence, explicit application transaction boundaries, and no generic repository or command bus by default.

## Alternatives

- Retain `Sales`/`Billing` as broad umbrella names and map Order/Payment under them.
- Adopt implemented `Orders`/`Payments` namespace names as the architecture vocabulary.
- Package contexts as Rails engines immediately; rejected as premature.

## Trade-offs

The proposed vocabulary makes ownership and cross-context coordination clearer and aligns documentation with current business language. It adds a deliberate mapping step between logical context names, Accepted ADR text, and current Rails namespaces until a separately authorized migration exists.

## Security implications

Identity/Authorization remains the trusted actor and scope provider, while each business context retains its own approval rules. Vocabulary approval must not be used to bypass server-side authorization or to treat a namespace as a security boundary.

## Operational implications

The proposal changes no deployable, database, job, monitoring, or incident boundary. A future namespace/folder migration would require its own compatibility, rollout, and ownership plan.

## Consequences

Approval would require a controlled ADR amendment/supersession and a separate code/documentation migration plan. Until that approval exists, ADR-0001 and ADR-0005 remain unchanged and Accepted, and no namespace/folder rename is authorized.
