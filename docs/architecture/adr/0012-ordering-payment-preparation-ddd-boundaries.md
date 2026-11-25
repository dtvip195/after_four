---
status: accepted
date: 2026-11-25
---

# ADR-0012: Ordering, Payment, and Preparation DDD boundaries

**Status:** Accepted
**Owner classification:** `OWNER_CONFIRMED_TECHNICAL_ARCHITECTURE`
**Decision date:** 2026-11-25
**Provenance:** Explicit Owner approval of `OPP-ARCH-06` through `OPP-ARCH-12` on 2026-11-25

## Context

The existing Phase 1 Ordering, Payment, and Preparation implementation predates the project-wide Layered DDD decision in [ADR-0011](0011-project-wide-layered-ddd.md). It already provides tested Order-to-Payment lock ordering, authoritative post-lock decision time, local transaction atomicity, exact-balance settlement, immutable terminal Payment Attempt evidence, late-success containment, unique/idempotent Preparation Dispatch, and rollback when required Outbox persistence fails. Those are existing verified behavior constraints, not newly approved architecture decisions.

ADR-0011 already requires Domain, Application, Infrastructure, and Presentation separation and prohibits one Bounded Context from manipulating another context's Infrastructure records without an approved integration contract. The missing decision was the target context ownership and coordination shape for incremental remediation of the legacy Phase 1 implementation.

## Decision

The Owner approved the following technical architecture decisions:

| ID | Approved decision |
|---|---|
| `OPP-ARCH-06` | Ordering, Payment, and Preparation are the three target Bounded Contexts for this remediation scope. |
| `OPP-ARCH-07` | A Payment Application coordinating use case orchestrates settlement through narrow contracts owned by the participating contexts. |
| `OPP-ARCH-08` | Preparation owns Preparation Dispatch and its integration contract. |
| `OPP-ARCH-09` | The implementation vocabulary remains `Orders`, `Payments`, and `Preparation`; this decision authorizes no namespace, table, or class rename. |
| `OPP-ARCH-10` | Existing commands remain compatibility facades during incremental DDD extraction. |
| `OPP-ARCH-11` | Money and identifier Value Objects are context-local; no shared-kernel implementation is introduced. |
| `OPP-ARCH-12` | Initial DDD remediation requires no database schema change. |

### Context ownership

- **Ordering** owns Order settlement eligibility, commercial intent, authoritative Order total as currently represented, Order lifecycle transitions, hold/expiration eligibility, and future Order Item/sold-snapshot behavior when separately authorized.
- **Payment** owns Payment, Payment Attempt, settlement and funding invariants, replay handling, immutable terminal attempt evidence, and late-success financial truth.
- **Preparation** owns Preparation Dispatch eligibility within the approved settlement inputs, Dispatch identity, unique/idempotent dispatch-intent behavior, and its integration contract. Future Preparation Ticket and Ticket Item boundaries remain unresolved.

`Payments::Application::UseCases::ConfirmSettlement` is the approved orchestration shape, not the owner of Ordering or Preparation business rules. It coordinates context-owned behavior through narrow contracts. It must not reproduce another context's decisions inside Payment Application.

### Transaction and Infrastructure composition

The successful settlement flow retains one local PostgreSQL transaction. Infrastructure composition supplies adapters that participate in that transaction; context adapters must not open independent transactions that break the atomic boundary. Application and Domain do not depend directly on Active Record.

The existing sequence remains a mandatory regression boundary unless separately changed:

1. lock Order, then Payment;
2. sample authoritative decision time after the required locks are held;
3. apply exact-balance Payment Attempt and funding behavior once, including semantic replay validation;
4. re-evaluate locked Order eligibility;
5. for an eligible Order, atomically persist the unique Preparation Dispatch intent, required Outbox delivery record, and Audit evidence;
6. for Held, Expired, deadline-equal, or late success, preserve financial truth and review evidence without Dispatch;
7. commit before external delivery; and
8. retry delivery without recharging or creating another Dispatch/Outbox business identity.

Outbox insertion remains inside the transaction where required by this atomicity contract. Failure rolls back the related settlement, Attempt, Dispatch, Audit, and Outbox writes. Outbox publication and retry occur only after commit. An asynchronous event chain must not replace atomic Dispatch-intent creation.

### Compatibility and persistence boundary

Existing commands remain entry-point facades while Domain behavior, Application orchestration, and Infrastructure persistence are extracted incrementally. Existing tables, columns, indexes, triggers, constraints, commands, jobs, and characterization tests remain available to the initial remediation. This decision neither requires nor authorizes a migration.

Cross-context database references may remain as physical integrity mechanisms, but one context must not load or mutate another context's Active Record records directly. Adapters expose only the operation-specific contracts required by the coordinating use case.

### Explicit scope exclusion

Initial remediation preserves the current caller-supplied total behavior as a known limitation. It does not introduce Order Items, Product/Variant sold-price snapshots, Price-version binding, authoritative server quoting/repricing, or another Pricing/Commercial capability. Those require separate business/design work and authorization.

## Existing behavior versus architecture approval

The regression constraints above remain verified Phase 1 behavior. ADR-0001 and ADR-0011 remain the sources for the modular-monolith and Layered DDD rules. `OPP-ARCH-06` through `OPP-ARCH-12` are the newly approved target architecture. None of these classifications converts legacy implementation behavior into a new business-policy decision.

## Unresolved decisions

| ID | Unresolved topic |
|---|---|
| `OPP-ARCH-13` | Exact Integration Event version encoding. |
| `OPP-ARCH-14` | Whether Payment Review Case is an entity within Payment or an independent Aggregate Root. |
| `OPP-ARCH-15` | Long-term timing of Payment-target creation relative to Draft and confirmation. |
| `OPP-ARCH-16` | Future Preparation Ticket and Ticket Item aggregate boundary. |

Initial remediation may proceed only where these unresolved decisions are not prerequisites. Current behavior is preserved rather than using remediation to resolve them implicitly.

## Alternatives considered

- A neutral coordinator with direct access to generic repositories was rejected as the target because it would centralize context rules and reproduce the existing ownership ambiguity behind shallow wrappers.
- An uncoordinated asynchronous settlement-to-dispatch chain was rejected because it would change the approved local atomicity and rollback behavior.
- A shared-kernel Money/identifier implementation was rejected for this scope because context-local values preserve ownership without introducing a new shared dependency.
- A big-bang namespace or persistence rewrite was rejected because compatibility facades and unchanged physical structures allow lower-risk incremental extraction.

## Consequences

The target architecture is explicit enough to prepare a bounded remediation manifest, but this ADR does not authorize that remediation. A future authorization must name the exact source/test scope and preserve the verified behavior constraints. Any future schema change, new business capability, event-version encoding, Payment Review Case aggregate decision, Payment-target timing change, or Ticket aggregate design requires its applicable decision and authorization.

**Implementation note (2026-11-26):** separately authorized Ordering Phase 1, Payment Phase 2, and Preparation Phase 3 work now implement these boundaries for the current backend command foundation. Payment confirmation enters through `PaymentComposition` and `Payments::Application::UseCases::ConfirmSettlement`; pure Domain objects own Payment and Preparation Dispatch rules; namespaced Infrastructure records retain the unchanged schema; and obsolete command facades plus redundant top-level Active Record models have been removed. Preparation settlement Dispatch creation, recovery request, and Outbox retry now enter through Preparation Application use cases and context-owned ports. No Ticket/Ticket Item production workflow exists, so Phase 3 neither migrates nor designs that unresolved aggregate boundary. `OPP-ARCH-13` through `OPP-ARCH-16` remain unresolved exactly as recorded above, and this implementation note grants no public API, Gate, deployment, or Production Authorization.

## Authorization boundary

This ADR records technical architecture only. It grants no code change, refactor, business API, business capability, schema, migration, Identity work, Pricing work, Order Item work, Ticket work, Gate A/B/C, FOA, deployment, or Production Authorization.
