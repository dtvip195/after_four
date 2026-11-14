# AFTER FOUR — Catalog Core Implementation Readiness Review

**Review date:** 2026-11-14

**Owner decision closure update:** 2026-11-15 (`ODB-CAT-22`–`ODB-CAT-26`)

**Review type:** Repository-wide readiness assessment; updated documentation-only after Owner decision closure

**Final verdict:** `NOT_READY`

**Implementation authorization:** Not granted

## 1. Executive summary

The Owner-confirmed Catalog decisions establish the intended business boundary through `ODB-CAT-26`: Brand-global Products, flat Categories, canonical uppercase Catalog Codes, optional Brand-scoped SKU, Draft incompleteness, Active Product Default completeness, independent Default/visibility concepts, distinct Deactivate/Archive actions, validated restoration, and Draft-only physical deletion eligibility. The canonical source is [Owner Decision Baseline §5](../architecture/after_four_owner_decision_baseline.md#5-catalogpricing-mvp).

The first Catalog Core implementation is nevertheless **not ready for authorization**. The repository has no Catalog Core technical design document and the canonical documents deliberately leave the exact aggregate, schema, lifecycle representation, identifier normalization, same-Brand enforcement, Default Variant enforcement, locking, and migration strategy as `TECHNICAL_PROPOSAL` or unresolved. See [DDD Foundation §3.2](../architecture/after_four_ddd_foundation.md#32-catalogpricing) and [Catalog/Pricing Discovery §4](../architecture/after_four_catalog_pricing_discovery.md#4-unresolved-decisions-preserved).

Owner closure after the initial review resolved code normalization, Active Default completeness, Product restoration outcome, Category/Variant lifecycle distinction/authority, and Draft-only deletion eligibility (`ODB-CAT-22`–`ODB-CAT-26`). The remaining blocking issues are:

1. **Unresolved policy — SKU:** Catalog Code normalization is confirmed, but SKU case, whitespace, Unicode, and allowed-character rules remain unresolved.
2. **Unresolved lifecycle details:** Category/Variant restoration target states, detailed transition matrix, Product restoration authority, and identifier reservation after Draft deletion remain open.
3. **Technical closure — integrity:** repeated `brand_id`, composite FKs, canonical-code storage, safe-deletion proof, and lifecycle constraint design have not been selected.
4. **Technical closure — concurrency:** no accepted transaction/lock specification exists for Default switching, activation, archive/restore, or identifier collision races.
5. **Technical closure — delegated authority:** Owner/delegate policy is confirmed, but representation and server-side enforcement are not designed.
6. **Migration prerequisite — existing Branch references:** `orders.branch_id`, `audit_events.branch_id`, and related specs currently use UUIDs without a `branches` table or FK. A real Branch hierarchy needs a deliberate migration/backfill/test-fixture plan.

Rails 8.1, PostgreSQL 18, UUID keys, `structure.sql`, named database constraints, RSpec, and FactoryBot are compatible with the proposed foundation. Platform compatibility is not the blocker; missing domain and technical closure is.

## 2. Sources inspected

| Source | Evidence used |
|---|---|
| [AGENTS.md](../../AGENTS.md) | Canonical-source precedence, modular-monolith boundary, documentation-only verification rules. |
| [GLOSSARY.md](../../GLOSSARY.md) | Organization, Brand, Branch, Category, Product, Variant, Default Variant, Catalog Code, and SKU meanings. |
| [Owner Decision Baseline §5](../architecture/after_four_owner_decision_baseline.md#5-catalogpricing-mvp) | Canonical `ODB-CAT-01`–`ODB-CAT-26` statements, status, implementation boundary, and unresolved items. |
| [DDD Foundation §3.2](../architecture/after_four_ddd_foundation.md#32-catalogpricing) | Catalog responsibility, dependencies, deferred aggregate shape, and proposed enforcement mechanisms. |
| [Business Domain Model §4](../architecture/after_four_business_domain_model.md#4-core-entity-catalog-and-relationships), [§7](../architecture/after_four_business_domain_model.md#7-catalog-prices-recipes-and-historical-snapshots) | Entity ownership, lifecycle facts, snapshots, and unresolved policy. |
| [ERD §§3–6](../architecture/after_four_erd.md#3-ownership-and-data-isolation), [§13](../architecture/after_four_erd.md#13-cardinality-and-uniqueness-summary) | Logical cardinalities, proposed repeated scope keys, Catalog relationships, uniqueness proposals. |
| [Data Dictionary §§2–5](../architecture/after_four_data_dictionary.md#2-logical-type-and-time-conventions), [§12](../architecture/after_four_data_dictionary.md#12-index-and-historical-summary) | Candidate columns/types, lifecycle fields, indexes, and history treatment. |
| [Data Integrity Rules §§3–5](../architecture/after_four_data_integrity_rules.md#3-unique-business-identifiers), [§12](../architecture/after_four_data_integrity_rules.md#12-concurrency-and-lock-order), [§13](../architecture/after_four_data_integrity_rules.md#13-soft-deletion-deactivation-and-retention) | Identifier, same-scope, lifecycle, locking, deletion, and constraint expectations. |
| [State Machines §2.3](../architecture/after_four_state_machines.md#23-product-lifecycle-and-price-history) | Product restoration, confirmed Active Default invariant, and unresolved transition/concurrency details. |
| [API Contract §5](../architecture/after_four_api_contract.md#5-product-and-menu-contracts) | Future-only Catalog routes, unresolved authority, concurrency/error conventions. |
| [Catalog/Pricing Discovery](../architecture/after_four_catalog_pricing_discovery.md) | Decision closure and preserved technical/business gaps. |
| [Real Menu & Pricing Specification](../architecture/after_four_real_menu_pricing_specification.md) | Owner-input draft and explicit no-implementation boundary. |
| [Proposed Launch Menu v3](../architecture/after_four_proposed_launch_menu_v3.md) | `PROPOSED_NOT_APPROVED` Product, Category, Variant, Modifier, and Price data. |
| [ADR-0001](../architecture/adr/0001-rails-modular-monolith.md), [ADR-0003](../architecture/adr/0003-postgresql-version-baseline.md), [ADR-0004](../architecture/adr/0004-uuid-primary-keys.md), [ADR-0005](../architecture/adr/0005-backend-repository-structure.md), [ADR-0009](../architecture/adr/0009-api-conventions-versioning.md), [ADR-0010](../architecture/adr/0010-database-migrations-and-schema.md) | Accepted Rails/PostgreSQL/module/API/migration conventions. |
| [Backend Testing Standards](../development/after_four_testing_standards.md) | RSpec-only testing, FactoryBot, real PostgreSQL records, transactional isolation, boundary/concurrency expectations. |
| `backend/config/application.rb:22-61` | Rails 8.1 defaults, UTC, `structure.sql`, UUID generator, RSpec/FactoryBot generators, API-only mode. |
| `backend/db/migrate/20261114192000_create_order_payment_foundation.rb:1-94` | Existing UUID, named check/index, status, lock-version, and audit patterns. |
| `backend/db/migrate/20261114202000_enforce_payment_aggregate_integrity.rb:1-57` | Existing composite unique keys and composite FK convention. |
| `backend/app/domains/orders/create_draft.rb:30-79` | Transaction, audit, idempotency, and unique-race recovery convention. |
| `backend/app/models/order.rb:1-16`, `backend/app/models/payment.rb:1-16` | Model validation and restrictive association conventions. |
| `backend/spec/rails_helper.rb:1-29`, `backend/Gemfile:26-47` | RSpec, transactional fixtures, FactoryBot, Shoulda Matchers, Faker, SimpleCov. |
| `backend/db/structure.sql` and current migrations/specs | No Organization/Brand/Branch/Category/Product/Variant tables; existing Branch UUIDs are unconstrained references. |

No Catalog Core technical design report was found under `docs/`.

## 3. Owner Decision traceability

`OWNER_CONFIRMED` below describes authority only; it does not mean implementation is authorized or ready.

| ID | Confirmed scope | Readiness classification | Evidence / boundary |
|---|---|---|---|
| `ODB-CAT-01` | Product identity is Brand-global; Branch may vary availability/Price. | `OWNER_CONFIRMED`; Core identity `READY`; availability/Price `OUT_OF_SCOPE` | [Baseline §5](../architecture/after_four_owner_decision_baseline.md#5-catalogpricing-mvp); direct Product `brand_id` remains a `TECHNICAL_PROPOSAL`. |
| `ODB-CAT-02` | Categories are flat for MVP. | `OWNER_CONFIRMED`; `READY` | A Category table without `parent_id` is sufficiently specified. |
| `ODB-CAT-03` | Product states are Draft, Active, Inactive, Archived. | `OWNER_CONFIRMED`; `READY` | `ODB-CAT-24` closes Archived→Inactive restoration outcome; remaining command/authority mechanics are separate. |
| `ODB-CAT-04` | Every sellable selection is a persisted Variant; hidden default may represent no visible choice. | `OWNER_CONFIRMED`; `READY` | `ODB-CAT-23` closes Active completeness while preserving Default/visibility independence. |
| `ODB-CAT-05` | Modifier cardinality. | `OWNER_CONFIRMED`; `OUT_OF_SCOPE` | Modifier implementation is excluded from this milestone. |
| `ODB-CAT-06` | Explicit Branch availability override. | `OWNER_CONFIRMED`; `OUT_OF_SCOPE` | Availability implementation and publication authority are excluded. |
| `ODB-CAT-07` | Chain default and Branch Price override. | `OWNER_CONFIRMED`; `OUT_OF_SCOPE` | Price persistence/resolution is excluded. |
| `ODB-CAT-08` | Price versions are immutable/effective-dated. | `OWNER_CONFIRMED`; `OUT_OF_SCOPE` | No Price table belongs in Catalog Core Foundation. |
| `ODB-CAT-09` | Draft repricing requires revised-quote review. | `OWNER_CONFIRMED`; `OUT_OF_SCOPE` | Order repricing and confirmation changes are excluded. |
| `ODB-CAT-10` | Sold Price locks at Order confirmation. | `OWNER_CONFIRMED`; `OUT_OF_SCOPE` | Order Items and sold snapshots are excluded. |
| `ODB-CAT-11` | Launch target is 28 Products. | `OWNER_CONFIRMED`; `OUT_OF_SCOPE` | Scale only; individual rows remain `PROPOSED_NOT_APPROVED`. |
| `ODB-CAT-12` | S/M/L only for suitable Products. | `OWNER_CONFIRMED`; `OUT_OF_SCOPE` | Per-Product applicability and capacities are unapproved. |
| `ODB-CAT-13` | Three Signature Product designations. | `OWNER_CONFIRMED`; `OUT_OF_SCOPE` | Does not approve Product records, codes, Variants, Recipes, or Prices. |
| `ODB-CAT-14` | Initial one Organization/Brand; schema supports multiples; no singleton constraint. | `OWNER_CONFIRMED`; `READY` | The canonical Glossary/ERD consistently place Brand under Organization and Branch under Brand. No maximum-cardinality constraint is needed for the foundation; do not invent one. |
| `ODB-CAT-15` | Every Product, including Draft, has exactly one Category. | `OWNER_CONFIRMED`; business rule `READY`; DB enforcement `BLOCKED` | Same-Brand composite enforcement is not selected. |
| `ODB-CAT-16` | Category/Product/Variant codes are Brand-unique. | `OWNER_CONFIRMED`; `READY` | `ODB-CAT-22` closes input/canonical normalization; exact storage/index remains technical. |
| `ODB-CAT-17` | SKU is optional and Brand-unique when present. | `OWNER_CONFIRMED`; `BLOCKED` | Nullable uniqueness is clear; exact SKU normalization remains unresolved. |
| `ODB-CAT-18` | Codes/SKUs are never reused after archive. | `OWNER_CONFIRMED`; `READY` only if full unique indexes retain archived rows | SKU normalization and identifier reservation after permitted Draft deletion remain unresolved. |
| `ODB-CAT-19` | Draft Product may have zero Variants and no Default. | `OWNER_CONFIRMED`; `READY` | Product-to-Variant cardinality must be zero-to-many while Draft. |
| `ODB-CAT-20` | Default and customer visibility are independent. | `OWNER_CONFIRMED`; `READY` | Fields/switching/concurrency remain technical, not business blockers. |
| `ODB-CAT-21` | Category/Variant may retire and restore; no physical deletion while referenced. | `OWNER_CONFIRMED`; `READY` | `ODB-CAT-25`–`ODB-CAT-26` close lifecycle distinction, authority, safeguards, and deletion eligibility; restoration targets and technical enforcement remain open. |
| `ODB-CAT-22` | Catalog Code trim/ASCII character set/uppercase canonicalization. | `OWNER_CONFIRMED`; `READY` | Applies to Category/Product/Variant codes only; exact SKU normalization remains unresolved. |
| `ODB-CAT-23` | Active Product has at least one Variant and exactly one Default. | `OWNER_CONFIRMED`; `READY` | Draft zero-Variant rule and Default/visibility independence remain intact; concurrency enforcement is technical. |
| `ODB-CAT-24` | Archived Product restores to Inactive; activation is separate. | `OWNER_CONFIRMED`; `READY` | Restoration does not imply sellability; exact authority/command remains open. |
| `ODB-CAT-25` | Category/Variant Deactivate and Archive are distinct Owner/delegate validated/audited actions with dependency guards. | `OWNER_CONFIRMED`; `READY` | Restoration targets, detailed matrix, delegation representation, and extra metadata remain unresolved/technical. |
| `ODB-CAT-26` | Only dependency-free Draft records may be physically deleted. | `OWNER_CONFIRMED`; `READY` | Identifier reservation after deletion and technical proof remain unresolved. |

## 4. Readiness matrix

| Review area | Requirement classification | Readiness | Assessment |
|---|---|---|---|
| Organization persistence | `OWNER_CONFIRMED` | `READY` | Multiple rows and UUID identity are clear; code normalization/lifecycle fields still need technical closure. |
| Organization → Brand | `TECHNICAL_PROPOSAL` | `READY` | Glossary, Business Domain Model, and ERD consistently make each Brand belong to an Organization and permit multiple Brands. No maximum constraint is proposed. |
| Brand → Branch | `TECHNICAL_PROPOSAL` | `READY` | Glossary, Business Domain Model, ERD, and Data Dictionary consistently make each Branch belong to a Brand. It is not promoted to `OWNER_CONFIRMED`. |
| Category ownership | `OWNER_CONFIRMED` | `BLOCKED` | Brand ownership and lifecycle semantics are clear, but direct `brand_id`, restoration target, and exact columns are unresolved. |
| Product → Category | `OWNER_CONFIRMED` | `BLOCKED` | Required FK is clear, but same-Brand enforcement design is not selected. |
| Product → Variant | `OWNER_CONFIRMED` | `BLOCKED` | Draft and Active cardinalities are confirmed; cross-row database enforcement and locking remain unresolved. |
| Multiple Organization/Brand support | `OWNER_CONFIRMED` | `READY` | Ordinary UUID tables/FKs support this; no singleton checks or singleton application assumptions are allowed. |
| Category/Product/Variant code | `OWNER_CONFIRMED` | `BLOCKED` | Business normalization is `READY`; canonical storage, constraint shape, and error mapping remain technical blockers. |
| Optional SKU | `OWNER_CONFIRMED` | `BLOCKED` | Nullability is clear; equality/normalization and empty-string handling are not. |
| Category/Variant lifecycle | `OWNER_CONFIRMED` | `BLOCKED` | Distinction, authority, audit, and dependency guards are confirmed; restoration targets, detailed transitions, columns, commands, and races are not closed. |
| Product lifecycle | `OWNER_CONFIRMED` | `BLOCKED` | Restoration target and Active Default precondition are confirmed; restoration authority and exact commands remain unresolved. |
| Default Variant | `OWNER_CONFIRMED` | `BLOCKED` | Active exactly-one is confirmed; at-most/at-least-one database enforcement, switching, and concurrency remain proposed. |
| Database integrity | `TECHNICAL_PROPOSAL` | `BLOCKED` | Accepted database conventions support the mechanisms, but the Catalog constraint design has not been selected. |
| Repository/runtime compatibility | `READY` | `READY` | Rails/PostgreSQL/UUID/SQL-schema/RSpec support the work. Existing free-form Branch UUIDs require migration planning. |
| Factories/test fixtures | `TECHNICAL_PROPOSAL` | `READY` | FactoryBot is configured; no Catalog factories exist yet. Tests must use real DB constraints and concurrency after schema closure. |
| Development sample data | `OUT_OF_SCOPE` | `OUT_OF_SCOPE` | Do not seed the proposed 28 Product rows. Empty seeds or clearly synthetic test factories are sufficient. |

## 5. Confirmed rules versus technical proposals

### `OWNER_CONFIRMED`

- Initial one Organization/Brand without a permanent singleton schema.
- Brand-global Product identity and flat Categories.
- Exactly one Category per Product, including Draft.
- Draft Product may temporarily have no Variant or Default Variant.
- Every sellable selection is a persisted Variant.
- Category/Product/Variant code scope and non-reuse.
- Optional SKU scope and non-reuse.
- Default designation and customer visibility are independent.
- Category/Variant retirement and restoration; referenced records are not physically deleted.
- Catalog Code ASCII input/trim/uppercase canonicalization.
- Active Product has at least one Variant and exactly one Default.
- Archived Product restores to Inactive and requires separate activation.
- Category/Variant Deactivate and Archive are distinct Owner/delegate validated/audited actions with dependency safeguards.
- Physical deletion is limited to dependency-free Draft records.

### `TECHNICAL_PROPOSAL`

- Direct/repeated `brand_id` on Product/Variant.
- Composite unique keys and composite foreign keys for same-Brand ancestry.
- Exact `varchar` lengths and canonical-code storage/constraint implementation; SKU normalization remains unresolved policy.
- Partial unique index for at-most-one Default Variant.
- Product-row locking and transaction shape for Default switching.
- Database trigger and/or application command for Active at-least-one/exactly-one Default enforcement.
- Exact Category/Variant lifecycle fields and status vocabulary.
- Restrictive FK actions and restore commands.
- Catalog command/service classes, error mapping, audit events, endpoints, and presenters.

The proposals above must not be cited as Owner decisions. Accepted PostgreSQL and migration ADRs establish that such mechanisms are available and expected where appropriate; they do not select the Catalog schema.

## 6. Database integrity and concurrency assessment

| Mechanism | Invariant protected | Repository status | Implementation readiness / unresolved trade-off |
|---|---|---|---|
| Direct `brand_id` on Category/Product/Variant | Enables Brand-scoped uniqueness and same-Brand FK proof without joins. | `TECHNICAL_PROPOSAL`; repeated scope keys are allowed only deliberately in [ERD §3.2](../architecture/after_four_erd.md#32-direct-scope-reference-policy). | `BLOCKED`: choose denormalization versus trigger/application-only ancestry. Repeated keys improve DB proof but require composite FKs to prevent drift. |
| Composite unique keys and FKs | Prevent Product→foreign-Brand Category and Variant→foreign-Brand Product. | Established repository capability at `backend/db/migrate/20261114202000_enforce_payment_aggregate_integrity.rb:17-39`; Catalog use remains `TECHNICAL_PROPOSAL`. | `READY` as a mechanism, `BLOCKED` as Catalog design. Recommended candidate: unique `(id, brand_id)` parents plus child composite FKs. |
| Full unique `(brand_id, canonical_code)` | Brand uniqueness and non-reuse across archived rows. | Canonical uppercase code policy is `OWNER_CONFIRMED`; physical key is proposed. | `BLOCKED` only on storage/constraint design. The index must not exclude archived rows. |
| Partial unique `(brand_id, normalized_sku)` where SKU present | Optional SKU uniqueness and non-reuse. | Owner invariant; partial-index mechanism proposed. | `BLOCKED` until null/blank and normalization semantics are decided. Archived rows remain in the index. |
| Partial unique Default index | At most one Default Variant per Product. | `TECHNICAL_PROPOSAL`; PostgreSQL/ADR support partial indexes. | `READY` after exact field/lifecycle predicate is chosen. It cannot ensure at least one Default. |
| Cross-row Active completeness enforcement | Active Product has at least one Variant and exactly one Default. | Requirement `OWNER_CONFIRMED` (`ODB-CAT-23`). | `BLOCKED` on technical design: Rails validation alone is race-prone; options include a locked activation command plus deferred constraint trigger. |
| FK/deletion safety | Prevent forbidden deletion and preserve history/audit dependencies. | Draft-only dependency-free deletion is `OWNER_CONFIRMED` (`ODB-CAT-26`); exact enforcement proposed. | `BLOCKED`: select database restrictions plus non-FK dependency proof. Identifier reservation after Draft deletion remains unresolved. |
| Product transaction and row lock | Serialize activation, Default switching, archive/restore, and relevant Variant changes. | Transaction/locking pattern is established, but Catalog lock order is absent from [Integrity Rules §12](../architecture/after_four_data_integrity_rules.md#12-concurrency-and-lock-order). | `BLOCKED`: define Product-first lock order, retry behavior, and whether Variant rows are locked in stable ID order. |
| Restore collision handling | Prevent restoration from violating reserved identifiers or parent lifecycle rules. | Owner non-reuse means a full unique index normally prevents collision. | `BLOCKED`: specify expected error, parent/child restoration guards, and race test. A collision should fail atomically rather than rename silently. |
| Optimistic locking | Prevent lost updates to mutable master records. | API convention uses `If-Match`; existing Orders have `lock_version`. | `TECHNICAL_PROPOSAL`; decide which Catalog records require `lock_version`. No endpoint is authorized in this milestone. |

### Required database tests after closure

- Direct SQL cannot create cross-Brand Product/Category or Variant/Product links.
- Archived Category/Product/Variant codes remain unique; archived non-null SKU remains unique.
- Null SKU is accepted; duplicate normalized non-null SKU is rejected.
- Draft Product with zero Variants persists successfully.
- Competing Default changes cannot produce two Defaults or zero Defaults where the approved lifecycle requires one.
- Archive/restore races are deterministic and preserve identifiers.
- Referenced Category/Variant deletion is rejected by PostgreSQL independently of Rails validation.
- Failed constraint/audit writes roll back the entire command transaction.

## 7. Existing repository compatibility

| Area | Classification | Evidence and impact |
|---|---|---|
| Rails modular monolith | `READY` | [ADR-0001](../architecture/adr/0001-rails-modular-monolith.md) assigns Catalog to an in-process module; `backend/app/domains/catalog/.keep` already reserves the namespace. |
| PostgreSQL 18 | `READY` | [ADR-0003](../architecture/adr/0003-postgresql-version-baseline.md) explicitly supports partial indexes, transactions, and row locking. |
| UUID keys | `READY` | [ADR-0004](../architecture/adr/0004-uuid-primary-keys.md) and `backend/config/application.rb:38-42` require UUID business keys. |
| SQL schema and migrations | `READY` | [ADR-0010](../architecture/adr/0010-database-migrations-and-schema.md) requires Rails migrations, named constraints, explicit FKs, reversible operations where safe, and `structure.sql`. |
| Models/domain commands | `READY` | Models hold conventional validations/associations; named use cases own transactions and DomainError mapping. No generic repository layer is expected. |
| Audit conventions | `READY` | `AuditEvent` is append-only at application and database levels. Persistence-only setup emits no events; future Catalog commands need an approved event taxonomy and actor/scope. |
| RSpec/FactoryBot | `READY` | RSpec is official; FactoryBot syntax and transactional fixtures are configured. No current Catalog factories exist, which is expected before implementation. |
| API routes | `OUT_OF_SCOPE` | Only health/readiness and unmatched `/api/v1` routes exist. Catalog endpoints and authorization remain future work. |
| Existing Branch references | `BLOCKED` | `orders.branch_id` and `audit_events.branch_id` are UUIDs without a Branch FK; many specs generate arbitrary Branch UUIDs. Adding `branches` and immediate FKs would require data audit/backfill and widespread fixture changes. |
| Existing data migration | `BLOCKED` | No mapping exists from current distinct Branch UUIDs to Organization/Brand/Branch records. A migration must not invent production ownership. |
| Seed workflow | `READY` | `backend/config/ci.rb:3-11` runs seed replant; `backend/db/seeds.rb` contains no application data. Keep proposed menu rows out of seeds. |

## 8. Remaining unresolved Owner inputs

| Owner decision needed | Why implementation cannot infer it |
|---|---|
| Define exact SKU normalization. | Code normalization does not automatically apply to SKU. SKU case, whitespace, Unicode, and allowed-character rules remain explicitly unresolved. |
| Set Category and Variant restoration target states. | Restoration is confirmed, but the destination state for each is explicitly unresolved. |
| Decide identifier reservation after physical deletion of a Draft record. | `ODB-CAT-26` authorizes eligibility for safe deletion but explicitly does not decide whether a former code/SKU may later be reused. |
| Close the detailed lifecycle transition matrix where business outcomes remain material. | High-level Deactivate/Archive semantics and guards are confirmed; exact remaining transitions must not be invented. |
| Define Product restoration authority if a restoration command enters scope. | `ODB-CAT-24` confirms the outcome but deliberately does not invent additional authority or approval workflow. |

These inputs may be deferred only by narrowing implementation so the affected SKU, restoration, deletion, and lifecycle commands cannot be exercised. Catalog Code normalization and Active Default completeness are no longer Owner blockers.

## 9. Technical blockers not requiring new business policy

1. Write and approve a Catalog Core technical design selecting the physical columns, nullability, lifecycle representation, indexes, constraint names, and migration order.
2. Select same-Brand enforcement. The strongest repository-consistent candidate is repeated `brand_id` plus composite FKs, explicitly labeled `TECHNICAL_PROPOSAL` until adopted.
3. Define canonical Catalog Code storage and constraint behavior; defer SKU normalization-dependent enforcement until its policy is confirmed, including blank handling and conflict mapping.
4. Define Default switching and activation transactions, lock order, bounded retry behavior, and direct-SQL protection.
5. Define archive/restore transaction guards, parent/child lifecycle compatibility, and unique-collision behavior.
6. Decide FK deletion actions and verify them with database-level specs independent of Rails associations.
7. Plan Organization/Brand/Branch migration relative to current unconstrained `orders.branch_id`, `audit_events.branch_id`, and test data. Audit existing rows before adding any FK.
8. Define whether the first migration merely creates Branch reference data or also backfills/connects existing Order/Payment Phase 1 records. The latter must be explicit scope, not incidental cleanup.
9. Define Catalog error codes only if commands are included; no endpoint or authorization behavior should be introduced in the foundation.
10. Add focused model, migration-integrity, transaction, restore, and concurrency specs using PostgreSQL 18 and real records.

## 10. Recommended smallest safe implementation scope

After the blockers above are closed and the Owner separately authorizes implementation, the smallest safe foundation is:

1. **Reference persistence:** Organization, Brand, and Branch tables with UUID PKs and only the confirmed/approved hierarchy, codes, names, lifecycle fields, FKs, and indexes.
2. **Catalog persistence:** Category, Product, and Product Variant tables. Product is created as Draft and must reference one same-Brand Category. Draft may have zero Variants.
3. **Identifier integrity:** database-enforced Brand-scoped Category/Product/Variant code uniqueness using the approved Catalog Code normalization. Optional SKU uniqueness may be added only after its separate normalization semantics are approved; archived rows remain inside uniqueness scope.
4. **Relationship integrity:** database-enforced same-Brand Product/Category and Variant/Product ancestry; restrictive deletion for referenced records.
5. **Default independence:** persist separate Default designation and customer visibility. Enforce the confirmed Active exactly-one invariant only through an accepted race-safe transaction/database design.
6. **Lifecycle boundary:** store approved states and implement no publication, activation, archive, restore, or deletion command until its remaining transition details, authority, and technical guards are closed.
7. **Rails layer:** conventional Active Record models and Catalog-domain use cases only where a transaction is necessary. No controllers, routes, presenters, policies, or frontend changes.
8. **Tests:** factories for the six real entities; model and direct-database constraint specs; cross-Brand negative tests; archived identifier tests; optional SKU tests; transaction/concurrency tests for any included lifecycle/default command.
9. **Seeds:** no real or proposed menu import. Keep production seeds empty unless separately approved reference records are supplied. Development examples, if later desired, must be clearly synthetic and isolated from production seeds.
10. **Existing transaction records:** do not attach or backfill existing Order/Audit Branch UUIDs until a reviewed migration plan identifies the corresponding Branch rows and rollback/roll-forward behavior.

This scope intentionally produces persistence and integrity primitives, not a sellable menu or public Catalog API.

## 11. Explicitly out of scope

- Modifier Group, Modifier Option, applicability, and Modifier pricing.
- Branch availability and time-based sellability.
- Price tables, resolution, publication, tax, service charge, rounding, and free-item policy.
- The 28 proposed Product rows, Product codes, Variants, sizes, Recipes, or Prices.
- Recipe, Ingredient, inventory, media, and stock integration.
- Order Items, repricing, quote acceptance, confirmation, or historical snapshots.
- Payment creation/lifecycle/provider behavior and preparation dispatch.
- Catalog endpoints, presenters, public routes, frontend, authentication, authorization, PIN, or Identity Milestone 2B.
- Deployment, production data provisioning, and vendor selection.

The launch menu remains `PROPOSED_NOT_APPROVED` in [Proposed Launch Menu v3](../architecture/after_four_proposed_launch_menu_v3.md#12-approval-boundary).

## 12. Final verdict

### `NOT_READY`

The Owner-confirmed decisions now close Catalog Code normalization, Active Default completeness, Product restoration outcome, Category/Variant lifecycle distinction/authority, and Draft-only deletion eligibility. The repository still lacks a safe, accepted Catalog Core technical design and retains unresolved SKU normalization, Category/Variant restoration targets, Draft-deletion identifier reservation, detailed transitions, delegation enforcement, Default concurrency, safe-deletion proof, and Branch migration planning.

Readiness can be reassessed after:

1. the remaining Owner inputs in §8 are explicitly closed or deliberately excluded by a narrower authorized scope;
2. the technical design items in §9 are selected and reviewed;
3. the existing free-form Branch UUID migration is planned; and
4. a separate Owner task explicitly authorizes implementation.

No implementation should begin from this report alone.
