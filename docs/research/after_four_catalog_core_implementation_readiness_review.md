# AFTER FOUR — Catalog Core Implementation Readiness Review

**Review date:** 2026-11-14

**Owner decision closure update:** 2026-11-15 (`ODB-CAT-22`–`ODB-CAT-41`)

**Technical design reassessment:** 2026-11-15 ([critical review](after_four_catalog_core_technical_design_review.md))

**Technical completion review:** 2026-11-15 ([completion review](after_four_catalog_core_technical_design_completion_review.md))

**Technical readiness reassessment:** 2026-11-15 ([readiness reassessment](after_four_catalog_core_technical_readiness_reassessment.md))

**Retention decision update:** 2026-11-15 (`ODB-DATA-01`; `ODB-CAT-26` narrowed)

**Review type:** Repository-wide readiness assessment; updated documentation-only after Owner decision closure

**Final verdict:** `NOT_READY`

**Implementation authorization:** Not granted

## 1. Executive summary

The Owner-confirmed Catalog decisions establish the intended business boundary through `ODB-CAT-41`: Product lifecycle commands and Product Category reassignment are excluded from initial MVP, while Variant Archive/Restore preserves `is_default` and `customer_visible`. Earlier identity, lifecycle, Default, retention, and no-Purge decisions remain intact. These scope decisions do not authorize implementation.

The first Catalog Core implementation is nevertheless **not ready for authorization**. The [Catalog Core Technical Design](../architecture/after_four_catalog_core_technical_design.md) remains `TECHNICAL_DESIGN_INCOMPLETE`: business clarifications and proposed technical mechanisms are documented, but concurrency/database-role proof, trusted authorization/audit implementation, migration evidence, and target-environment mapping remain absent.

Owner closure resolved CAT-CLAR-01 through CAT-CLAR-09, Default cardinality, and the later initial-scope questions through `ODB-CAT-41`. The remaining blocking issues are technical or implementation prerequisites:

1. **Resolved policy — Code namespace:** `ODB-CAT-27` confirms separate Category/Product/Variant namespaces within each Brand. Three per-entity unique constraints remain a technical proposal.
2. **Resolved policy — Default uniqueness and eligibility:** `ODB-CAT-38` permits at most one designated Default in every Product state; `ODB-CAT-28` requires the Active Product's exactly-one Default to be Active. Visibility is independent. Enforcement remains technical and unimplemented.
3. **Resolved policy — Category/Product lifecycle dependency:** `ODB-CAT-29` requires Active Category for Product activation and blocks Category Deactivation while Active Products remain assigned. Enforcement remains technical and unimplemented.
4. **Resolved policy — lifecycle/authority:** Category/Variant Draft creation and matrix are closed by `ODB-CAT-30`–`ODB-CAT-32`; included commands and enforcement remain technical.
5. **Resolved MVP scope — SKU/retention:** `ODB-CAT-34`–`ODB-CAT-37` defer SKU, select lifecycle/Archive retention, reserve identifiers, and prohibit Purge; future policy questions do not block the MVP business model.
6. **Resolved initial scope:** Product lifecycle/reassignment commands are excluded, and Variant Archive/Restore preserves its flags (`ODB-CAT-39`–`ODB-CAT-41`).
7. **Technical specification — concurrency:** final-state triggers serialize on Category/Product parents and share a defined application lock order; direct-SQL/write-skew/deadlock behavior remains unproved.
8. **Technical specification — authority/audit:** checked Brand scope and a trusted authorization-context seam are proposed, but the current Branch-only AuditEvent and UUID-only actor reference do not implement them.
9. **Migration prerequisite — existing Branch references:** local evidence is non-production; real Branch FKs require target-environment inventory and authoritative mapping.

Rails 8.1, PostgreSQL 18, UUID keys, `structure.sql`, named database constraints, RSpec, and FactoryBot are compatible with the proposed foundation. Platform compatibility is not the blocker; missing domain and technical closure is.

## 2. Sources inspected

| Source | Evidence used |
|---|---|
| [AGENTS.md](../../AGENTS.md) | Canonical-source precedence, modular-monolith boundary, documentation-only verification rules. |
| [GLOSSARY.md](../../GLOSSARY.md) | Organization, Brand, Branch, Category, Product, Variant, Default Variant, Catalog Code, and SKU meanings. |
| [Owner Decision Baseline §5](../architecture/after_four_owner_decision_baseline.md#5-catalogpricing-mvp) | Canonical `ODB-CAT-01`–`ODB-CAT-41` statements, status, implementation boundary, and future-scope items. |
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
| `backend/app/domains/orders/application/use_cases/create_draft.rb:30-79` | Transaction, audit, idempotency, and unique-race recovery convention. |
| `backend/app/domains/orders/infrastructure/persistence/order_record.rb:1-15`, `backend/app/models/payment.rb:1-16` | Persistence-record validation conventions; Ordering no longer exposes a cross-context Active Record association model. |
| `backend/spec/rails_helper.rb:1-29`, `backend/Gemfile:26-47` | RSpec, transactional fixtures, FactoryBot, Shoulda Matchers, Faker, SimpleCov. |
| `backend/db/structure.sql` and current migrations/specs | No Organization/Brand/Branch/Category/Product/Variant tables; existing Branch UUIDs are unconstrained references. |

The initial review predated the technical design. This reassessment inspected both the current design and its [critical review](after_four_catalog_core_technical_design_review.md).

## 3. Owner Decision traceability

`OWNER_CONFIRMED` below describes authority only; it does not mean implementation is authorized or ready.

| ID | Confirmed scope | Readiness classification | Evidence / boundary |
|---|---|---|---|
| `ODB-CAT-01` | Product identity is Brand-global; Branch may vary availability/Price. | `OWNER_CONFIRMED`; Core identity `READY`; availability/Price `OUT_OF_SCOPE` | [Baseline §5](../architecture/after_four_owner_decision_baseline.md#5-catalogpricing-mvp); direct Product `brand_id` remains a `TECHNICAL_PROPOSAL`. |
| `ODB-CAT-02` | Categories are flat for MVP. | `OWNER_CONFIRMED`; `READY` | A Category table without `parent_id` is sufficiently specified. |
| `ODB-CAT-03` | Product states are Draft, Active, Inactive, Archived. | `OWNER_CONFIRMED`; `READY` | `ODB-CAT-24` closes Archived→Inactive restoration outcome; remaining command/authority mechanics are separate. |
| `ODB-CAT-04` | Every sellable selection is a persisted Variant; hidden default may represent no visible choice. | `OWNER_CONFIRMED`; `READY` | `ODB-CAT-23`, `ODB-CAT-28`, and `ODB-CAT-38` close all-lifecycle designation count and Active eligibility while preserving visibility independence. |
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
| `ODB-CAT-15` | Every Product, including Draft, has exactly one Category. | `OWNER_CONFIRMED`; relationship `READY`; activation policy `BLOCKED` | Repeated `brand_id` plus composite FK is a reviewed technical proposal; Category-state effects remain unresolved. |
| `ODB-CAT-16` | Category/Product/Variant Codes are Brand-scoped. | `OWNER_CONFIRMED`; namespace `BUSINESS_DECISION_RESOLVED` | `ODB-CAT-27` closes the interpretation: uniqueness is evaluated separately per entity type within a Brand. |
| `ODB-CAT-27` | Separate Category/Product/Variant Code namespaces within each Brand. | `OWNER_CONFIRMED`; not implemented | Same Code may occur once in each type; same-type/same-Brand duplicates are rejected. Three per-table constraints remain proposed. |
| `ODB-CAT-17` | SKU is optional and Brand-unique when present. | `OWNER_CONFIRMED`; MVP deferred | `ODB-CAT-34` excludes SKU support from MVP; future normalization remains unresolved. |
| `ODB-CAT-18` | Codes/SKUs are never reused after archive. | `OWNER_CONFIRMED`; not implemented | `ODB-CAT-36` extends reservation to any future Soft Delete without authorizing it. |
| `ODB-CAT-19` | Draft Product may have zero Variants and no Default. | `OWNER_CONFIRMED`; `READY` | Product-to-Variant cardinality must be zero-to-many while Draft. |
| `ODB-CAT-20` | Default and customer visibility are independent. | `OWNER_CONFIRMED`; `READY` | `ODB-CAT-28` and `ODB-CAT-38` confirm visibility is not a cardinality or eligibility predicate. Fields/switching/concurrency remain technical. |
| `ODB-CAT-21` | Category/Variant may retire and restore; no physical deletion while referenced. | `OWNER_CONFIRMED`; business resolved | Creation states and matrix are closed by `ODB-CAT-30`–`ODB-CAT-32`; mechanics remain blocked. |
| `ODB-CAT-22` | Catalog Code trim/ASCII character set/uppercase canonicalization. | `OWNER_CONFIRMED`; `READY` | Applies to Category/Product/Variant codes only; exact SKU normalization remains unresolved. |
| `ODB-CAT-23` | Active Product has at least one Variant and exactly one Default designation. | `OWNER_CONFIRMED`; eligibility `BUSINESS_DECISION_RESOLVED` | `ODB-CAT-28` requires the valid Default to be lifecycle-Active and designated; `ODB-CAT-38` extends at-most-one designation to all Product states. Visibility remains independent. |
| `ODB-CAT-24` | Archived Product restores to Inactive; activation is separate. | `OWNER_CONFIRMED`; `READY` | Restoration does not imply sellability; exact authority/command remains open. |
| `ODB-CAT-25` | Category/Variant Deactivate and Archive are distinct Owner/delegate validated/audited actions with dependency guards. | `OWNER_CONFIRMED`; business resolved | `ODB-CAT-28`/`29` provide guards and `ODB-CAT-32` closes transitions; authority enforcement and concurrency remain proposed. |
| `ODB-CAT-26` | Physical deletion prohibitions and former dependency-free Draft minimum test. | `OWNER_CONFIRMED`, narrowed by `ODB-DATA-01`/`ODB-CAT-37` | Purge is prohibited for every Catalog MVP lifecycle state. |
| `ODB-CAT-28` | Active Product's valid Default is an Active Variant with `is_default = true`; visibility is independent. | `OWNER_CONFIRMED`; not implemented | Hidden Active is eligible; Inactive/Archived is not. Cross-row enforcement and concurrency proof remain proposed. |
| `ODB-CAT-38` | Every Product has at most one designated Default; Draft/Inactive/Archived permit zero or one, while Active requires exactly one Active designated Variant. | `OWNER_CONFIRMED`; not implemented | Preserves `ODB-CAT-23`, `ODB-CAT-28`, and `ODB-CAT-31`; index/trigger/locks/tests remain proposed. |
| `ODB-CAT-39` | Product lifecycle commands/APIs are excluded from initial MVP. | `OWNER_CONFIRMED`; `OUT_OF_INITIAL_MVP` | Future lifecycle policy remains unresolved and no full lifecycle may be claimed complete. |
| `ODB-CAT-40` | Variant Archive/Restore preserves `is_default` and `customer_visible`, changes status only, and restores to Inactive. | `OWNER_CONFIRMED`; not implemented | Reactivation is separate; transaction/guard/audit evidence remains absent. |
| `ODB-CAT-41` | Product Category reassignment is unsupported in MVP. | `OWNER_CONFIRMED`; `OUT_OF_INITIAL_MVP` | Proposed database immutability and negative tests remain unimplemented. |
| `ODB-CAT-29` | Product activation requires Active assigned Category; Category Deactivation is blocked while Active Products remain assigned. | `OWNER_CONFIRMED`; not implemented | Deactivation is distinct from Archive and Branch availability. Commands, locks, triggers, races, and authorization enforcement remain open technical work. |
| `ODB-CAT-30`–`ODB-CAT-32` | Category/Variant create Draft and use the confirmed transition matrix with Restore to Inactive. | `OWNER_CONFIRMED`; not implemented | Lifecycle commands, constraints, locks, audit, and concurrency proof remain blocked technically. |
| `ODB-CAT-33` | Product Restore authority is Owner or explicit Owner delegate. | `OWNER_CONFIRMED`; not implemented | Trusted delegation/authorization and Brand-scoped audit remain blocked. |
| `ODB-CAT-34` | SKU support is deferred from Catalog Core MVP. | `OWNER_CONFIRMED`; business resolved | Accept no SKU input; future normalization requires separate scope. |
| `ODB-CAT-35`–`ODB-CAT-37` | Lifecycle/Archive retention, identifier reservation, no Soft Delete, and no Purge in MVP. | `OWNER_CONFIRMED`; not implemented | No `deleted_at`, default scope, deletion command, cleanup job, or Purge. |
| `ODB-DATA-01` | Important operational/financial/historical/audit data is retained; Soft Delete is optional globally. | `OWNER_CONFIRMED`; Catalog application closed by `ODB-CAT-35`–`37` | Unrelated entities remain outside this Catalog-specific decision. |

## 4. Readiness matrix

| Review area | Requirement classification | Readiness | Assessment |
|---|---|---|---|
| Organization persistence | `OWNER_CONFIRMED` | `READY` | Multiple rows and UUID identity are clear. Business codes/lifecycle are omitted from the narrow reference-table proposal rather than invented. |
| Organization → Brand | `TECHNICAL_PROPOSAL` | `READY` | Glossary, Business Domain Model, and ERD consistently make each Brand belong to an Organization and permit multiple Brands. No maximum constraint is proposed. |
| Brand → Branch | `TECHNICAL_PROPOSAL` | `READY` | Glossary, Business Domain Model, ERD, and Data Dictionary consistently make each Branch belong to a Brand. It is not promoted to `OWNER_CONFIRMED`. |
| Category ownership | `OWNER_CONFIRMED` | `BUSINESS_DECISION_RESOLVED` | Draft creation/matrix are closed; enforcement remains technically blocked. |
| Product → Category | `OWNER_CONFIRMED` | `BUSINESS_DECISION_RESOLVED` | Product remains in its original Category; reassignment is unsupported. Composite FK, proposed immutability, locks, and direct-SQL proof remain technical. |
| Product → Variant | `OWNER_CONFIRMED` | `DESIGN_SPECIFIED_EVIDENCE_PENDING` | Variant Draft creation and Active completeness predicate are clear; parent-locking trigger proof remains absent. |
| Multiple Organization/Brand support | `OWNER_CONFIRMED` | `READY` | Ordinary UUID tables/FKs support this; no singleton checks or singleton application assumptions are allowed. |
| Category/Product/Variant Code | `OWNER_CONFIRMED` | `BUSINESS_DECISION_RESOLVED` | Canonical storage and separate entity-type namespaces are closed; three per-table Brand-scoped constraints, names, migrations, and error mapping remain technical work. |
| Optional SKU | `OWNER_CONFIRMED` | `OUT_OF_MVP` | `ODB-CAT-34` accepts no SKU input; future equality/normalization remains undecided. |
| Category/Variant lifecycle | `OWNER_CONFIRMED` | `BUSINESS_DECISION_RESOLVED` | Draft creation, matrix, restore target, and guards are closed; columns, commands, authorization/audit, locks, and races remain technical blockers. |
| Product lifecycle | `OWNER_CONFIRMED` | `OUT_OF_INITIAL_MVP` | `ODB-CAT-39` excludes Activate, Deactivate, Archive, and Restore commands/APIs. Future policy remains unresolved without blocking the excluded scope. |
| Default Variant | `OWNER_CONFIRMED` | `BUSINESS_DECISION_RESOLVED` | All-lifecycle cardinality and Active eligibility are closed by `ODB-CAT-38`/`28`; race-safe enforcement, locking, migration, and concurrency proof remain technical blockers. |
| Database integrity | `TECHNICAL_PROPOSAL` | `DESIGN_SPECIFIED_EVIDENCE_PENDING` | Composite FKs, all-designation uniqueness, transition guards, and parent-locking deferred triggers are specified; implementation and proof are absent. |
| Repository/runtime compatibility | `READY` | `READY` | Rails/PostgreSQL/UUID/SQL-schema/RSpec support the work. Existing free-form Branch UUIDs require migration planning. |
| Factories/test fixtures | `TECHNICAL_PROPOSAL` | `READY` | FactoryBot is configured; no Catalog factories exist yet. Tests must use real DB constraints and concurrency after schema closure. |
| Development sample data | `OUT_OF_SCOPE` | `OUT_OF_SCOPE` | Do not seed the proposed 28 Product rows. Empty seeds or clearly synthetic test factories are sufficient. |

## 5. Confirmed rules versus technical proposals

### `OWNER_CONFIRMED`

- Initial one Organization/Brand without a permanent singleton schema.
- Brand-global Product identity and flat Categories.
- Exactly one Category per Product, including Draft.
- Draft, Inactive, and Archived Products may have zero or one Default Variant; no Product may have multiple designated Defaults.
- Every sellable selection is a persisted Variant.
- Brand scope, archived non-reuse, and separate entity-type namespaces for Category/Product/Variant Code (`ODB-CAT-27`).
- Optional SKU scope and non-reuse.
- Default designation and customer visibility are independent.
- Category/Variant retirement and restoration; referenced records are not physically deleted.
- Catalog Code ASCII input/trim/uppercase canonicalization.
- Active Product has exactly one Active Variant with `is_default = true`; visibility is independent, so hidden Active is eligible and Inactive/Archived is not (`ODB-CAT-28`).
- Archived Product restores to Inactive and requires separate activation.
- Category/Variant Deactivate and Archive are distinct Owner/delegate validated/audited actions with dependency safeguards.
- Catalog Core MVP uses lifecycle/Archive retention, no Soft Delete, and no Purge for Draft/Active/Inactive/Archived (`ODB-CAT-35`–`ODB-CAT-37`).

### `TECHNICAL_PROPOSAL`

- Direct/repeated `brand_id` on Product/Variant.
- Composite unique keys and composite foreign keys for same-Brand ancestry.
- Exact `varchar` lengths and canonical-code storage; three per-entity Code constraints remain proposed. SKU input/index behavior is excluded from MVP.
- Partial unique index `(product_id) WHERE is_default` is proposed for the confirmed all-lifecycle at-most-one designation rule.
- Product-row locking and transaction shape for Default switching.
- Parent-locking deferred database trigger and locked application command for Active completeness after eligibility is confirmed.
- Exact Category/Variant physical fields and transition-trigger implementation; the status vocabulary/matrix itself is Owner-confirmed.
- Restrictive FK actions and restore commands.
- Catalog command/service classes, error mapping, audit events, endpoints, and presenters.

The proposals above must not be cited as Owner decisions. Accepted PostgreSQL and migration ADRs establish that such mechanisms are available and expected where appropriate; they do not select the Catalog schema.

## 6. Database integrity and concurrency assessment

| Mechanism | Invariant protected | Repository status | Implementation readiness / unresolved trade-off |
|---|---|---|---|
| Direct `brand_id` on Category/Product/Variant | Enables Brand-scoped uniqueness and same-Brand FK proof without joins. | `TECHNICAL_PROPOSAL`; repeated scope keys are allowed only deliberately in [ERD §3.2](../architecture/after_four_erd.md#32-direct-scope-reference-policy). | `READY_FOR_TECHNICAL_REVIEW`: repeated keys plus composite FKs are the strongest repository-consistent design; Brand scope must be immutable. |
| Composite unique keys and FKs | Prevent Product→foreign-Brand Category and Variant→foreign-Brand Product. | Established repository capability at `backend/db/migrate/20261114202000_enforce_payment_aggregate_integrity.rb:17-39`; Catalog use remains `TECHNICAL_PROPOSAL`. | `READY` as a mechanism, `BLOCKED` as Catalog design. Recommended candidate: unique `(id, brand_id)` parents plus child composite FKs. |
| Catalog Code uniqueness | Separate Category/Product/Variant Brand namespaces and non-reuse across archived rows. | Canonical uppercase storage plus three per-entity `(brand_id, code)` constraints is supported. | Business rule closed by `ODB-CAT-27`; exact constraint names, migrations, error mapping, and proof remain `TECHNICAL_PROPOSAL`. |
| SKU storage/index | SKU support is deferred; accept no input. | `ODB-CAT-34`; future optional Brand uniqueness preserved. | `OUT_OF_MVP`; do not invent normalization or a production SKU index. |
| Partial unique Default index | At most one designated Default per Product in every lifecycle state. | `TECHNICAL_PROPOSAL`; policy `OWNER_CONFIRMED` by `ODB-CAT-38`. | Proposed predicate is `is_default`; implementation and duplicate-race proof are absent. Active existence/status still require the deferred trigger. |
| Cross-row Active completeness enforcement | Active Product has exactly one Active Variant with `is_default = true`; visibility is excluded. | Eligibility `OWNER_CONFIRMED` (`ODB-CAT-28`); enforcement unimplemented. | `DESIGN_SPECIFIED_EVIDENCE_PENDING`: Product-parent serialization and trigger events are defined; write-skew/deadlock proof remains absent. |
| Category/Product lifecycle dependency | Product activation requires Active Category; Category Deactivation requires zero assigned Active Products. | Policy `OWNER_CONFIRMED` (`ODB-CAT-29`); enforcement unimplemented. | `DESIGN_SPECIFIED_EVIDENCE_PENDING`: Category serialization and deferred final-state protection are defined; direct-SQL and race proof remain absent. Archive and Branch availability stay separate. |
| Retention/Purge safety | Retain via lifecycle/Archive; no Soft Delete; reserve identifiers; prohibit Purge in every MVP state. | `ODB-CAT-35`–`ODB-CAT-37`; `ODB-DATA-01`. | Business scope resolved; implementation must expose no delete/default-scope/cleanup path. |
| Product transaction and row lock | Serialize activation, Default switching, archive/restore, and relevant Variant changes. | Category → Product → UUID-sorted Variant order is proposed in the design and Integrity Rules. | `BLOCKED` for implementation proof: trigger entry through direct child SQL can deadlock; PostgreSQL must abort one transaction while preserving the invariant. |
| Restore collision handling | Prevent restoration from violating reserved identifiers or parent lifecycle rules. | Owner non-reuse means a full unique index normally prevents collision. | `BLOCKED`: specify expected error, parent/child restoration guards, and race test. A collision should fail atomically rather than rename silently. |
| Optimistic locking | Prevent lost updates to mutable master records. | API convention uses `If-Match`; existing Orders have `lock_version`. | `TECHNICAL_PROPOSAL`; decide which Catalog records require `lock_version`. No endpoint is authorized in this milestone. |

### Required database tests after closure

- Direct SQL cannot create cross-Brand Product/Category or Variant/Product links.
- Archived Category/Product/Variant codes remain unique; archived non-null SKU remains unique.
- SKU input is rejected/not exposed in MVP; no normalization behavior is asserted.
- Draft Product with zero Variants persists successfully.
- Competing Product/Variant changes cannot produce two Active Defaults, zero Active Defaults, or Product/Variant write-skew for an Active Product; visible and hidden Active Defaults pass, while Inactive/Archived designated Variants do not satisfy the requirement.
- Product activation fails with an Inactive/Archived assigned Category; Category Deactivation fails with any assigned Active Product; concurrent opposite operations cannot commit an invalid final state.
- Direct SQL insert/update/delete and lifecycle changes exercise every deferred-trigger path and deterministic parent locking.
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
| Audit conventions | `BLOCKED_FOR_LIFECYCLE_COMMANDS` | AuditEvent is append-only but requires Branch scope; it cannot honestly represent Brand-global Catalog lifecycle events without a new approved representation. Persistence-only setup emits no events. |
| RSpec/FactoryBot | `READY` | RSpec is official; FactoryBot syntax and transactional fixtures are configured. No current Catalog factories exist, which is expected before implementation. |
| API routes | `OUT_OF_SCOPE` | Only health/readiness and unmatched `/api/v1` routes exist. Catalog endpoints and authorization remain future work. |
| Existing Branch references | `PARTIALLY_BLOCKED` | Reference tables and synthetic factories are separable; operational FK attachment/validation requires inventory and writer compatibility. A `NOT VALID` FK does not repair legacy orphans. |
| Existing data migration | `BLOCKED` | Local test evidence is not production evidence. No authoritative target-environment mapping exists from Branch UUIDs to Organization/Brand/Branch records. |
| Seed workflow | `READY` | `backend/config/ci.rb:3-11` runs seed replant; `backend/db/seeds.rb` contains no application data. Keep proposed menu rows out of seeds. |

## 8. Owner inputs and future-scope boundaries

No CAT-CLAR-01 through CAT-CLAR-09 MVP business input remains open. `ODB-CAT-39`–`ODB-CAT-41` additionally close the initial Product/Variant scope ambiguity without authorizing implementation.

Future SKU normalization/support, Soft Delete mechanics, Product lifecycle commands, and any Product Category reassignment capability require separate Owner Decisions and scope approval. The initial MVP exclusions must not be interpreted as future behavior.

## 9. Technical blockers not requiring new business policy

1. Review and accept or amend the proposed named constraints, all-designation Default index, transition guards, and two deferred final-state trigger families.
2. Prove repeated `brand_id` composite FKs and immutable Brand scope through direct SQL independently of Rails.
3. Prove two-connection write-skew prevention, multi-change final state, deadlock/timeout behavior, and bounded whole-command retry on PostgreSQL 18.
4. Review and implement Brand-scoped append-only audit before any lifecycle command; do not fabricate Branch scope.
5. Provide a trusted Identity authorization/delegation context before lifecycle commands; Identity Milestone 2B remains unauthorized.
6. Prove the runtime database role cannot disable integrity/audit triggers, truncate protected data, or mutate AuditEvent history.
7. Inventory and authoritatively map target-environment Branch references before operational FK validation; keep table creation, writer compatibility, and validation separate.
8. Preserve the Product lifecycle/reassignment exclusions; resolve their policies only if a future authorized scope includes them.
9. Implement and execute the documented command, direct-SQL, concurrency, migration/schema, and role test layers after authorization.
10. Review the proposed no-Purge `BEFORE DELETE` guards/runtime-role denial and the no-row-update AuditEvent scope migration identified by the readiness reassessment.

## 10. Recommended smallest safe implementation scope

The former six-entity scope is not independently safe. After a separate Owner authorization, only a narrower reference-foundation milestone is technically separable now:

1. Organization, Brand, and Branch tables with UUID PKs, names/timezone, restrictive local FKs, and no invented singleton, business-code, or lifecycle policy.
2. Synthetic Organization → Brand → Branch factories and compatibility tests; no proposed menu or production reference data.
3. Read-only Branch-reference inventory/mapping support and application/test compatibility replacing arbitrary Branch UUIDs with persisted references.
4. Operational Branch FKs may be added `NOT VALID` only after compatible writers exist; validation waits for authoritative target-environment mapping and approved orphan resolution.

Category, Product, and Product Variant business rules are closed, but tables, factories, and creation commands must wait for technical design closure, review, and explicit authorization. Same-Brand composite FKs, lifecycle checks, Default eligibility, Category/Product dependency, audit/authorization seams, and concurrency proof remain technical blockers. Activation, publication, Default switching, lifecycle commands, deletion, API, frontend, audit redesign, authorization, and Identity remain deferred; Catalog deletion is prohibited in MVP.

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

The Owner-confirmed decisions through `ODB-CAT-41` close the initial Catalog scope questions, and the completion review specifies proposed lifecycle/Default enforcement, lock order, direct-SQL protection, Brand-scoped audit, authorization seam, migration/error mapping, and database test strategy. The technical design remains `TECHNICAL_DESIGN_INCOMPLETE` and readiness remains `NOT_READY` because implementation and required evidence do not exist.

The [technical readiness reassessment](after_four_catalog_core_technical_readiness_reassessment.md) confirms this verdict and now records two `BLOCKER` and four `HIGH` findings after `CAT-TRR-002` was resolved for initial scope. Authoritative Branch mapping and trusted Identity/Audit remain blocked; direct-SQL no-Purge, concurrency, database-role, and append-only AuditEvent migration evidence remain incomplete.

Readiness can be reassessed after:

1. the proposed technical mechanisms are accepted or amended in a separate review;
2. the parent-locking triggers and remaining technical items in §9 are implemented only after authorization and then proven with direct-SQL/concurrency/role tests;
3. target-environment Branch inventory/mapping is available for operational FK validation; and
4. a separate Owner task explicitly authorizes a precisely bounded implementation milestone.

Only the narrower Organization/Brand/Branch reference foundation in §10 is currently separable for future Owner consideration. This report does not authorize even that work. No Catalog Core implementation should begin from this report alone.
