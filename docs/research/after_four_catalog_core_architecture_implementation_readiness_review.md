# AFTER FOUR — Catalog Core Architecture & Implementation Readiness Review

**Review date:** 2026-11-15

**Review type:** Read-only architecture and readiness assessment

**Overall verdict:** `NOT_READY`

**Implementation authorization:** Not granted

## A. Executive summary

Catalog Core is not ready for implementation under the Owner-confirmed project-wide Layered DDD architecture.

The Owner decisions `ODB-CAT-01` through `ODB-CAT-41` and `ODB-DATA-01` provide a strong business boundary for a narrow Catalog Core. They settle Brand-global Product identity, flat Categories, same-Brand Code namespaces, Variant persistence, Default cardinality/eligibility, Category and Variant lifecycle policy, Product lifecycle/reassignment exclusions, Archive retention and the no-Purge MVP rule. Pricing direction is confirmed only at the policy level; tax, service charge, rounding, free items, Modifier pricing and publication authority remain unresolved.

No executable Catalog backend exists. The only Catalog backend artifact is an empty marker directory. There are no Category/Product/Variant domain classes, persistence records, migrations, tables, commands, queries, factories, specs, routes or presenters. Frontend Product/Category/Price values are explicitly demo fixtures and are not Catalog contracts.

The current [Catalog Core Technical Design](../architecture/after_four_catalog_core_technical_design.md) predates [ADR-0011](../architecture/adr/0011-project-wide-layered-ddd.md). It contains substantial PostgreSQL and transaction proposals, but it does not yet define a strict Layered DDD Catalog design: aggregate ownership and Value Objects are incomplete, business-rule ownership is not allocated to Domain, persistence records/mapping are not namespaced under Infrastructure, and Application/Presentation dependency rules are not reconciled. This is a new architecture-readiness gap; it does not reopen any Owner business decision.

Main blockers:

1. rebaseline Catalog design under ADR-0011 before any implementation request;
2. accept or amend exact database final-state, lifecycle, no-Purge and error-mapping mechanisms;
3. produce deterministic PostgreSQL concurrency, direct-SQL, migration and database-role evidence after authorization;
4. obtain authoritative A2 Branch mapping before production integration;
5. provide trusted Identity/delegation and Brand-scoped append-only Audit support before lifecycle/runtime commands.

Recommended next step: a documentation-only **Package B Layered DDD technical design closure**. It should define the narrow schema-only package's Domain and Infrastructure contracts and exact validation protocol without creating code or seeking runtime command authority.

## B. Actual implementation inventory

### B.1 Backend

| Area | Repository evidence | Assessment |
|---|---|---|
| Catalog namespace | [`backend/app/domains/catalog/.keep`](../../backend/app/domains/catalog/.keep) only | Empty marker; not implementation. |
| Domain | No Catalog Domain Entities, Value Objects, Aggregates or Domain Services | Not implemented. |
| Application | No Catalog Commands, Queries or Use Cases | Not implemented. |
| Infrastructure | No Catalog persistence records, mappings or external adapters | Not implemented. |
| Presentation | [Routes](../../backend/config/routes.rb) contain health endpoints and the unmatched `/api/v1` fallback only | No Catalog API. |
| Database | No `categories`, `products`, `product_variants`, Price or availability tables in migrations or `structure.sql` | No Catalog schema. |
| Tests/factories | No Catalog specs or factories | No executable Catalog evidence. |

Package A1 is real implementation but belongs to the Organization Bounded Context, not Catalog. Its pure entities and namespaced persistence records demonstrate the required dependency direction; they do not establish a Catalog integration interface. In particular, Catalog must not directly treat `Organization::Infrastructure::Persistence::BrandRecord` as its Domain or Application contract.

Existing Ordering, Payment, Preparation and Audit code predates ADR-0011 and is outside this review's refactoring authority. Existing free-form Branch UUID writers and references do not prove A2 mapping or Catalog production scope.

### B.2 Frontend

The frontend contains explicit POS demonstration data:

- [`pos-demo-data.ts`](../../frontend/src/features/pos/data/pos-demo-data.ts) uses `demo-*` identifiers and describes names and prices as illustrative.
- [`pos.ts`](../../frontend/src/features/pos/types/pos.ts) defines `PosDemoProduct` and `PosDemoCategory`, not canonical Catalog DTOs.
- [`product-detail-dialog.tsx`](../../frontend/src/features/pos/components/product-detail-dialog.tsx) labels the values “Dữ liệu demo” and states that sizes, toppings, Modifiers, recipes, inventory and pricing policy are not approved.

These files are Presentation fixtures. They do not implement Catalog, establish Product/Variant identity, approve prices, or define a future server contract.

### B.3 Implemented versus documented

| Capability | State |
|---|---|
| A1 Organization/Brand/Branch reference foundation | `IMPLEMENTED`, limited to A1 |
| Catalog business policies | `OWNER_CONFIRMED` where identified by ODB decisions |
| Catalog physical/transaction design | `TECHNICAL_PROPOSAL`, incomplete and pre-ADR-0011 |
| Catalog Domain/Application/Infrastructure/Presentation | Not implemented |
| Catalog schema/integrity controls | Not implemented |
| Catalog runtime commands/API/frontend integration | Not implemented and unauthorized |
| Pricing/availability implementation | Not implemented; outside Package B/C |

## C. Layered DDD compliance

### C.1 Domain

Current status: `NOT_READY`.

The canonical model identifies Category, Product, Variant, Price and Branch Availability concepts, but the Catalog Core design does not yet provide an ADR-0011-compliant Domain interface.

Required design closure:

- decide and document aggregate ownership; the strongest current candidate is Category as one aggregate and Product with its Variants as another, because Default and Active completeness span Product/Variant state;
- define a framework-independent Catalog Code Value Object or equivalent Domain behavior for trim, ASCII validation and canonical uppercase representation;
- place Product/Category/Variant relationship, lifecycle, Default eligibility/cardinality and no-Purge business rules in Domain rather than treating commands, Active Record validations or triggers as their owner;
- keep Price and Branch Availability outside the initial schema package while retaining their separate future domain boundary;
- represent Brand identity as a stable cross-context reference without depending on Organization Infrastructure classes.

The aggregate and Value Object recommendations above are `TECHNICAL_PROPOSAL`, not Owner decisions. No generic repository or speculative port is required for schema-only Package B.

### C.2 Application

Current status: no implementation; Package B may legitimately have no Application code.

An empty schema/integrity package needs migrations, records, mapping and database tests, not artificial Commands or Queries. Application becomes necessary only when an authorized business operation exists.

Package C would require named Category/Variant Activate, Deactivate, Archive and Restore Use Cases. Each must coordinate Domain behavior, trusted authorization, deterministic locks, persistence, append-only audit and error mapping in one transaction. Product lifecycle commands and Product Category reassignment remain excluded. Create/read/edit/Default-switch workflows remain separately unresolved and must not be inferred from table existence.

### C.3 Infrastructure

Current status: `NOT_READY`.

The existing proposal identifies plausible PostgreSQL mechanisms:

- repeated immutable `brand_id` with composite same-Brand foreign keys;
- three separate `(brand_id, code)` uniqueness constraints;
- a partial unique index for at-most-one designated Default;
- deferred final-state enforcement for Active Category/Product/Default invariants;
- transition and Product-category immutability guards;
- restrictive foreign keys and no-Purge protection;
- named constraints and SQLSTATE/constraint-name error mapping.

However, none is implemented or proven. The design also requires ADR-0011 placement such as `Catalog::Infrastructure::Persistence::*Record` and explicit Infrastructure-to-Domain projection. Exact names are technical design, not authorization.

The remaining Infrastructure evidence includes direct-SQL negative tests, all required trigger events, deterministic parent locking, deadlock/timeout behavior, schema dump/load, upgrade/rollback or roll-forward behavior, unknown-constraint handling and production-like grants. Local/test use of a PostgreSQL superuser does not establish runtime-role safety.

### C.4 Presentation

Current status: no Catalog Presentation implementation, which is correct for the present scope.

No endpoint is required for Package B. Future controllers must invoke Application and must not query or mutate Catalog persistence records directly. Public DTOs must not expose persistence records. Existing demo TypeScript types and prices must be replaced by an explicitly authorized server contract rather than promoted into it.

### C.5 Dependency direction and cross-context ownership

No executable Catalog dependency-direction violation exists because no Catalog source exists.

The current design has a readiness mismatch rather than an implemented violation: it describes conventional models and commands without allocating them to ADR-0011 layers. It must also distinguish a database FK to the Organization-owned `brands` table from an Application/Domain dependency on Organization Infrastructure. The former can be an Infrastructure integrity mechanism; the latter would violate ADR-0011 without an approved integration contract.

Catalog owns Catalog behavior. Organization owns Organization/Brand/Branch behavior; Ordering owns sold snapshots and quote acceptance; Payment owns settlement; Identity owns trusted actor/scope; Audit evidence remains a separate prerequisite. Catalog must not mutate those contexts' persistence records directly.

## D. Owner Decision reconciliation

### D.1 Catalog identity, ownership and identifiers

| Decisions | Result | Remaining specification |
|---|---|---|
| `ODB-CAT-01`, `02`, `14`, `15` | Design is consistent: Brand-global Product, flat Category, required Product Category and no singleton schema. | Cross-context Brand reference and same-Brand Infrastructure enforcement need ADR-0011 rebaseline. |
| `ODB-CAT-16`, `18`, `22`, `27` | Design correctly uses separate Brand-scoped namespaces and canonical uppercase ASCII Codes retained after Archive. | Domain Code behavior, exact lengths, constraints and error mapping remain proposed. |
| `ODB-CAT-17`, `34`, `36` | SKU is correctly excluded from MVP and does not inherit Code normalization. | Future SKU semantics remain outside scope. |

### D.2 Product and Variant

| Decisions | Result | Remaining specification |
|---|---|---|
| `ODB-CAT-03`, `04`, `19`, `23`, `28`, `38` | Lifecycle vocabulary, persisted Variant rule and Default predicates are consistent. | Product aggregate behavior, database final-state enforcement and concurrency proof are missing. |
| `ODB-CAT-20`, `28`, `31`, `40` | Design preserves independence of status, `is_default` and `customer_visible`. | Exact Domain behavior and persistence projection are missing. |
| `ODB-CAT-39` | Product lifecycle commands remain excluded. | Do not infer a Product transition Use Case. |
| `ODB-CAT-41` | Product Category reassignment remains excluded. | Proposed direct-SQL immutability guard is unimplemented. |

### D.3 Category and Variant lifecycle

The documented matrix agrees with `ODB-CAT-21`, `25`, and `29`–`32`: Draft creation, prohibited Draft→Inactive and Archived→Active transitions, validated Restore to Inactive, separate Deactivate/Archive actions, Category Active-Product guards and Variant valid-Default guards.

Missing evidence/specification:

- Domain transition behavior and error vocabulary;
- Category/Product/Variant aggregate transaction boundaries under ADR-0011;
- trusted Owner/delegate authorization and revocation recheck;
- Brand-scoped append-only audit representation;
- trigger coverage, lock ordering and deterministic concurrent outcomes.

No lifecycle authority may be inferred from a role label, actor UUID or client scope.

### D.4 Pricing and availability

`ODB-CAT-06` through `ODB-CAT-10` are preserved:

- chain defaults with explicit Branch overrides;
- immutable effective-dated Price versions;
- revised Draft quotes require review;
- sold Price is locked in Ordering at confirmation;
- client amounts are never authoritative.

Pricing and availability are outside Package B/C and must remain separate. Tax treatment, service charge, rounding, complimentary/zero-price policy, Modifier price effects, time-based availability, manual override authority and Price publication authority remain unresolved. The POS demo price is not server-authoritative evidence.

### D.5 Retention

The design is consistent with `ODB-CAT-35`–`37` and `ODB-DATA-01`: Catalog uses lifecycle/Archive retention, has no MVP Soft Delete, permits no Purge in any Catalog lifecycle state and retains archived identifiers in uniqueness enforcement.

Restrictive foreign keys alone do not protect an unreferenced row. Database no-Purge guards, runtime-role denial and privileged operational procedure remain technical proposals and evidence gaps.

### D.6 Decisions that must not be inferred

- universal Product creation state or a Product create command from `ODB-CAT-19`;
- who may read/create/edit Catalog records or change Default designation;
- editable-field and Code-correction policy;
- non-lifecycle mutation audit requirements;
- future Product lifecycle or reassignment behavior;
- future SKU normalization;
- unresolved Price/tax/rounding/Modifier/availability policy;
- any public endpoint or frontend contract.

## E. CAT-TRR reassessment

This review does not edit or close the historical finding records.

| Finding | Current recorded status | Current evidence | Satisfied? | Remaining gap and impact |
|---|---|---|---|---|
| `CAT-TRR-001` | `BLOCKER` | A1 creates empty reference tables, but no target-environment inventory, approved mapping or operational FK exists. | No | Blocks A2 and production/runtime Catalog scope. Does not block an empty B schema. Requires operational evidence, Owner-approved mapping/orphan disposition and separate authorization. |
| `CAT-TRR-003` | `BLOCKER` | ADR-0006 remains Proposed; Identity Milestone 2B is unauthorized; actor UUID validation is not authorization; no Brand-scoped Catalog audit provider exists. | No | Blocks Package C and all Catalog runtime writers. Requires trusted Identity/delegation plus audit design/implementation and authorization. |
| `CAT-TRR-004` | `HIGH` | AuditEvent remains Branch-required and append-only at Rails and PostgreSQL levels. No Brand-scope migration has executed. | No | Blocks Package C/runtime audit. Requires reviewed no-row-update migration evidence preserving append-only protection. |
| `CAT-TRR-005` | `HIGH` | No Catalog tables or no-Purge triggers exist. Restrictive FK design alone cannot prevent deletion of an unreferenced row. | No | Blocks Package B completion and C defense in depth. Requires exact guards, runtime grant denial and direct-SQL tests. |
| `CAT-TRR-006` | `HIGH` | Parent-lock/deferred-trigger protocol is documented but unimplemented and untested. | No | Blocks B final-state integrity and C lifecycle. Requires deterministic multi-connection PostgreSQL evidence for write-skew, deadlock and rollback outcomes. |
| `CAT-TRR-007` | `HIGH` | Development/test use the `postgres` principal; no production-like runtime/migration/break-glass grants exist. A1 completion does not supply them. | No | Blocks production-like A2/B/C completion. Requires infrastructure/operator evidence and negative privilege tests. |
| `CAT-TRR-008` | `MEDIUM` | A1 migration/schema evidence exists for A1 only. There is no Catalog migration, constraint-error mapping or unknown-error proof. | Partially for A1; no for Catalog | Blocks B/C and relevant A2 migration completion. Requires fresh/upgrade/roll-forward, `structure.sql`, named-constraint and SQLSTATE evidence after authorization. |
| `CAT-TRR-009` | `LOW`, `RESOLVED` | ODB-CAT-01–41 remain internally consistent; no new business-policy contradiction was found. | Yes for decision reconciliation | Keep resolved. ADR-0011 design rebaseline is a separate architecture gap, not a reason to rewrite Owner decisions. |

### New review finding — `CAT-ARCH-001`

**Severity:** High

**Status:** Open in this report only; no canonical finding record changed.

The Catalog Core Technical Design and package plan predate ADR-0011. They do not define the Catalog Domain interface, Application ownership, namespaced Infrastructure records/mapping, Presentation boundary or permitted cross-context contract shape. Existing text that assigns normalization primarily to “commands” and describes conventional Active Record models must be reclassified under strict Layered DDD.

Impact: blocks a Package B implementation-authorization proposal. Resolution is documentation/technical design work, not a new business decision and not implementation.

## F. Package readiness

| Package | Verdict | Evidence and prerequisites |
|---|---|---|
| Package A overall | `BLOCKED` | A1 is implemented, but A2 remains blocked; Package A cannot be represented as complete production integration. |
| A1 — empty Organization/Brand/Branch reference foundation | `IMPLEMENTED` (terminal state outside the pre-implementation verdict scale) | A1 remains limited to empty reference schema and synthetic verification. It does not establish production records, A2 mapping or Catalog authority. |
| A2 — mapping and operational Branch integration | `BLOCKED` | `CAT-TRR-001`, production-like roles and A2 migration evidence remain absent. Requires separate operational/data authorization. |
| B — Catalog schema and integrity foundation | `NOT_READY` | Business rules are sufficiently bounded, and A1 supplies reference tables. However ADR-0011 rebaseline, exact Domain/Infrastructure contracts, final-state/no-Purge mechanism review and executable evidence plan remain incomplete. No runtime CRUD/API is included. |
| C — Category/Variant lifecycle commands | `BLOCKED` | Depends on B, trusted Identity/delegation, Brand-scoped append-only audit, AuditEvent migration proof, direct-SQL integrity and concurrency evidence. Product lifecycle and reassignment remain excluded. |

Package B should not be classified `READY_FOR_OWNER_APPROVAL` merely because a schema proposal exists. Package C is not merely incomplete: external prerequisites that this Catalog package cannot supply are unavailable and unauthorized.

No additional Catalog implementation package is currently closed. Pricing/availability and B runtime CRUD are future scopes with unresolved Owner/technical decisions rather than hidden parts of B or C.

## G. Recommended next steps

### Work possible without implementation authorization

1. **Package B Layered DDD design closure:** revise the technical proposal to allocate Category/Product/Variant responsibilities to Domain and Infrastructure under ADR-0011; define candidate aggregates, Catalog Code behavior, persistence-record names/paths, one-way projection and cross-context Brand reference. Keep Application and Presentation absent for schema-only B.
2. **Database mechanism review:** freeze exact B tables, columns, named constraints, trigger events, lock order, no-Purge protection, constraint-error mapping and rollback/roll-forward protocol as proposals.
3. **Executable evidence protocol:** specify deterministic direct-SQL, multi-connection, role/grant, schema-reproduction and failure tests without executing migrations or creating schema.
4. **Readiness reassessment:** reassess `CAT-ARCH-001` and the B portions of `CAT-TRR-005`–`008`; prepare an authorization proposal only if the design is complete.

### Work requiring explicit Owner or operational authorization

5. Execute target-environment A2 inventory/mapping and approve every orphan disposition.
6. If B becomes design-complete, request a separate schema-only implementation authorization limited to empty tables, Infrastructure records/mapping, synthetic factories and integrity tests.
7. Decide future runtime Catalog authority, editable fields, Product creation behavior and non-lifecycle audit only when a runtime package is proposed.

### Work blocked by prerequisites

8. Keep Package C blocked until trusted Identity/delegation and Brand-scoped append-only Audit are implemented and evidenced under separately authorized scopes.
9. Keep public Catalog API/frontend integration blocked until Application Use Cases and response contracts are authorized.
10. Keep Price, availability, Modifier, menu seed/data and Ordering integration outside Catalog Core until their unresolved business and technical inputs are closed.

## Review boundary and working tree

This report creates no implementation authority. It changes no Owner decision, ADR status, CAT-TRR record, application source, test, migration, schema, dependency, frontend fixture, database or environment.

The working tree was already dirty before review, including A1 source/schema work and extensive Catalog documentation changes. Those files were preserved. The only intended file created by this review is this report.
