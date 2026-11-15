# AFTER FOUR — Catalog Core Technical Design

**Document date:** 2026-11-15

**Design scope:** Package B — Catalog schema and integrity foundation

**Status:** `TECHNICAL_PROPOSAL`

**Package B verdict:** `READY_FOR_OWNER_APPROVAL`

**Implementation authorization:** Not granted

Package B is an empty-schema and integrity package. This document is complete enough to submit a separate, narrowly scoped implementation-authorization request; it does not authorize implementation, runtime Catalog operations, data creation, or production use. Package C remains `BLOCKED`.

## 1. Authority, evidence, and classifications

This design follows:

- [ADR-0011 — Project-wide Layered DDD](adr/0011-project-wide-layered-ddd.md) and `ODB-ARCH-01`;
- [Owner Decision Baseline §5](after_four_owner_decision_baseline.md#5-catalogpricing-mvp), `ODB-CAT-01` through `ODB-CAT-41`;
- [Owner Decision Baseline §6](after_four_owner_decision_baseline.md#6-global-data-retention-and-deletion), `ODB-DATA-01`;
- [DDD Foundation §3.2](after_four_ddd_foundation.md#32-catalogpricing);
- [Business Domain Model §7](after_four_business_domain_model.md#7-catalog-prices-recipes-and-historical-snapshots);
- [Data Dictionary §5](after_four_data_dictionary.md#5-catalog-and-recipes), [Data Integrity Rules §5](after_four_data_integrity_rules.md#50-catalogpricing-mvp-rules), [ERD](after_four_erd.md), and [State Machines](after_four_state_machines.md);
- accepted ADRs [0001](adr/0001-rails-modular-monolith.md), [0003](adr/0003-postgresql-version-baseline.md), [0004](adr/0004-uuid-primary-keys.md), [0005](adr/0005-backend-repository-structure.md), [0009](adr/0009-api-conventions-versioning.md), and [0010](adr/0010-database-migrations-and-schema.md); and
- the 2026-11-15 [Architecture & Implementation Readiness Review](../research/after_four_catalog_core_architecture_implementation_readiness_review.md).

Classification meanings:

| Label | Meaning in this document |
|---|---|
| `OWNER_CONFIRMED` | Business or project direction explicitly recorded in the Owner Decision Baseline. |
| `TECHNICAL_PROPOSAL` | Reviewable mechanism selected by this design; not implemented or approved merely by appearing here. |
| `UNRESOLVED_OWNER_DECISION` | A business/authority choice still requires explicit Owner confirmation. |
| `EXTERNAL_PREREQUISITE` | Evidence or another authorized capability must be supplied outside Package B. |

Writing a proposed constraint, trigger, role, or test does not close a CAT-TRR finding. Closure requires separately authorized implementation and evidence.

### 1.1 Owner-decision coverage

| Decisions | Package B consequence |
|---|---|
| `ODB-CAT-01`–`ODB-CAT-04` | Brand-global Product, flat Category, four Product status values, and persisted Variant are represented. Branch identity is absent. |
| `ODB-CAT-05` | Modifier cardinality is preserved as future scope; no Modifier table is introduced. |
| `ODB-CAT-06`–`ODB-CAT-10` | Availability, Price versioning, quote review, and sold-price snapshots remain separate contexts/future packages. No pricing field is added. |
| `ODB-CAT-11`–`ODB-CAT-13` | Menu scale, selective sizes, and signature designation create no schema field, seed, or row. |
| `ODB-CAT-14`–`ODB-CAT-18` | Multiple Brand support, required Category, separate Brand/type Code namespaces, and archived identifier reservation shape the schema. SKU remains deferred. |
| `ODB-CAT-19`–`ODB-CAT-25` | Draft incompleteness, independent Default/visibility, lifecycle vocabulary, Active completeness, Restore boundaries, and Category/Variant guards shape Domain and database invariants. |
| `ODB-CAT-26`–`ODB-CAT-38` | Canonical Code, lifecycle matrices, Category/Product dependency, Draft creation for Category/Variant, SKU deferral, Archive retention, no Soft Delete/Purge, and all-lifecycle Default cardinality are preserved. |
| `ODB-CAT-39`–`ODB-CAT-41` | Product lifecycle commands and Category reassignment are excluded; Variant Archive/Restore preserves flags. |
| `ODB-DATA-01` | Important Catalog records are retained; no physical deletion mechanism is introduced. |

No conflict was found among these decisions. Product creation state, runtime authority, editable fields, non-lifecycle audit, and future pricing/availability matters remain explicit rather than inferred.

## 2. Package boundary

### 2.1 Included

Package B designs only:

- framework-independent Category, Product, Variant, and Catalog Code concepts;
- empty `categories`, `products`, and `product_variants` tables;
- Brand-scoped Codes and same-Brand relationships;
- lifecycle-value, transition, relationship, Default Variant, and final-state integrity;
- Product Category and aggregate-scope immutability;
- no-Purge database protection;
- namespaced Active Record persistence records and one-way persistence projection rules;
- deterministic locking, transaction, database-error, migration, role, and future verification protocols; and
- synthetic test data only after separate implementation authorization.

### 2.2 Explicitly excluded

Package B does not include:

- Product lifecycle commands, Product Category reassignment, Product creation, Catalog CRUD, Default-switching, or publication workflows;
- Category or Variant lifecycle commands, which belong to Package C;
- Application Commands, Queries, Use Cases, controllers, serializers, routes, public contracts, or frontend integration;
- Price, Branch availability, Modifier, Recipe, media, Inventory, menu seeds, or real menu data;
- SKU storage or input;
- A2 production mapping or operational Branch foreign keys;
- Identity Milestone 2B, trusted authorization, delegation implementation, or Brand-scoped AuditEvent redesign;
- changes to Ordering, Payment, Preparation, existing writers, or existing operational tables; and
- any production provisioning, migration execution, database operation, or deployment.

Table existence is not read/write authority. No Package B persistence record is a public interface.

## 3. Layered DDD architecture

### 3.1 Proposed namespace and paths

The path and namespace proposal follows the implemented A1 convention without treating Organization Infrastructure as a Catalog contract:

```text
backend/app/domains/catalog/
  domain/
    aggregates/product.rb
    entities/category.rb
    entities/variant.rb
    value_objects/catalog_code.rb
  infrastructure/
    persistence/category_record.rb
    persistence/product_record.rb
    persistence/product_variant_record.rb
```

No `application/` or `presentation/` directory is proposed for Package B. No generic repository, command bus, port, mapper hierarchy, or Rails engine is justified by an empty schema package.

### 3.2 Dependency rule

```text
future Presentation ──> future Application ──> Catalog Domain
                                      │
                                      └──> demonstrated contracts only

Catalog Infrastructure ──> Catalog Domain
Catalog Domain ──> no Rails, Active Record, PostgreSQL, Organization Infrastructure,
                   Application, Infrastructure, or Presentation
```

The database may have a foreign key to the Organization-owned `brands` table. That is an Infrastructure integrity dependency inside the accepted shared PostgreSQL deployment; it is not permission for Catalog Domain or future Application code to use `Organization::Infrastructure::Persistence::BrandRecord`.

### 3.3 Domain layer

The Domain owns business meaning and in-memory invariants:

- Catalog Code parsing and canonical representation;
- Category, Product, and Variant identity, Brand ownership, lifecycle vocabulary, and relationships;
- Category and Variant transition rules confirmed by `ODB-CAT-32`;
- Default designation, eligibility, visibility independence, and Product final-state rules;
- required original Category membership and no-Purge meaning; and
- future behavior methods only when an authorized use case requires them.

The Domain does not call persistence, lock rows, inspect SQLSTATEs, or use callbacks/triggers. Database protections mirror Domain rules for persisted/direct-SQL safety; they do not replace Domain behavior.

### 3.4 Application layer

Package B has no Application responsibility because it exposes no use case. Future authorized operations would require Application orchestration for authorization, aggregate loading, transaction scope, lock order, audit, idempotency, persistence, and error translation. Likely future operations include Category/Variant lifecycle actions, Product creation, Default designation, and master-data editing, but none is authorized or designed as a public interface here.

### 3.5 Infrastructure layer

Infrastructure owns:

- the three namespaced Active Record records and their table/association definitions;
- Rails migrations and `structure.sql` representation;
- PostgreSQL checks, indexes, foreign keys, triggers, row locks, grants, and constraint identity;
- projection from persistence rows into Domain values; and
- future translation of PostgreSQL failures at the transaction boundary.

For Package B, focused `to_domain` projection may mirror A1 for Category and Variant. Product aggregate reconstruction needs Product plus its Variant rows; a dedicated loader/mapper is not introduced until an authorized caller demonstrates that seam. The mapping contract is one-way and explicit: Infrastructure creates Domain objects from scalar values and never returns Active Record records to Domain, Application, or Presentation.

### 3.6 Presentation layer

Package B has no Presentation implementation or contract. Future Presentation must call Application, use explicit DTOs, and never serialize persistence records. Existing POS demo types, names, and prices remain fixtures, not a Catalog contract.

## 4. Domain model and aggregate design

### 4.1 Category aggregate candidate

Category is a separate aggregate root identified by `category_id` and owned by one Brand. Its proposed Domain state is:

- `id`;
- opaque `brand_id` reference;
- Catalog Code;
- name and display position;
- lifecycle status: Draft, Active, Inactive, or Archived; and
- optimistic version when reconstructed from persistence.

Category owns its own transition matrix. It does not contain Product objects. The rule “Category cannot become Inactive or Archived while Active Products remain” crosses aggregates: a future Application use case must obtain the authoritative dependent-state fact under the database locking protocol and pass it to Category behavior. PostgreSQL independently protects the committed final state.

Why separate: Category has an independent identity and lifecycle, and loading every Product to rename or inspect a Category would create an oversized aggregate. The cross-aggregate guard is explicit rather than hidden.

### 4.2 Product aggregate candidate

Product is an aggregate root; Variants are entities inside its consistency boundary. Proposed state:

- Product identity, Brand identity, original Category identity, Catalog Code, name, optional description, lifecycle status, and version;
- zero or more Variant entities, each with identity, Brand/Product identity, Catalog Code, name, position, lifecycle status, `is_default`, `customer_visible`, and version.

Product owns Variant membership and these consistency rules:

1. every Product belongs to exactly one original Category;
2. every Variant belongs to exactly one Product and the same Brand;
3. at most one Variant is designated Default in every Product lifecycle state;
4. an Active Product has exactly one designated Default and that Variant is Active;
5. `customer_visible` never determines Default eligibility;
6. a hidden Active Variant may be Default;
7. Variant Archive/Restore preserves `is_default` and `customer_visible`; and
8. an operation may not commit a final aggregate state that violates these rules.

The Active-Category prerequisite is a cross-aggregate rule. Future Product activation must receive an authoritative locked Category status from Application/Infrastructure. Product activation itself remains excluded by `ODB-CAT-39`.

### 4.3 Catalog Code value object

`Catalog::Domain::ValueObjects::CatalogCode` is a proposed immutable, framework-independent Value Object. Construction:

1. accepts a string-like input at a future trusted use-case boundary;
2. trims leading/trailing ASCII whitespace;
3. rejects empty output;
4. accepts only ASCII Latin letters, digits, hyphen, and underscore;
5. canonicalizes ASCII letters to uppercase; and
6. compares/hashes by canonical value.

It rejects Unicode letters, accents, internal whitespace, punctuation other than `-`/`_`, control characters, and invalid types. PostgreSQL stores only the canonical representation and independently checks `^[A-Z0-9_-]+$`.

No accepted source sets a Code length. This design proposes `varchar(64)` and a Domain maximum of 64 characters as a bounded technical choice for the separate implementation-authorization review. It is not an Owner business decision. Alternatives are `varchar(50)` to match some historical code proposals or unbounded `text`; 64 is preferred because it comfortably supports readable menu identifiers while bounding indexes and requests. Changing this value before implementation changes no business policy. Minimum length is one canonical character.

Category, Product, and Variant have separate `(brand_id, code)` namespaces. SKU is absent from Package B and does not inherit Catalog Code behavior.

### 4.4 Brand reference and cross-context seam

The Domain represents Brand as an opaque immutable identifier, not an Organization object and not `BrandRecord`. Catalog does not inspect Brand behavior. Infrastructure uses `brand_id` for ownership, uniqueness, foreign keys, and same-Brand proof.

A1 establishes the `brands` table but no cross-context Application interface. Package B's empty schema may reference `brands(id)` because both contexts share the accepted database; any future operation that needs Brand policy, lookup, administration, or production mapping requires a concrete integration contract and A2 evidence. No speculative port is added now.

## 5. Lifecycle and invariant matrix

### 5.1 Lifecycle transitions

| Concept | From | To | Policy and guard | Classification / Package |
|---|---|---|---|---|
| Category | creation | Draft | New Category starts Draft. | `OWNER_CONFIRMED`; runtime create excluded from B. |
| Category | Draft | Active | Validation required. | `OWNER_CONFIRMED`; Package C. |
| Category | Draft | Inactive | Prohibited. | `OWNER_CONFIRMED`; DB transition guard in B. |
| Category | Draft | Archived | Allowed subject to applicable archive guards. | `OWNER_CONFIRMED`; Package C. |
| Category | Active | Inactive | No Active Product may remain assigned. | `OWNER_CONFIRMED`; Package C plus B final-state backstop. |
| Category | Inactive | Active | Validation required. | `OWNER_CONFIRMED`; Package C. |
| Category | Active/Inactive | Archived | No Active Product may remain assigned; Archive is distinct from Deactivate. | `OWNER_CONFIRMED`; Package C plus B final-state backstop. |
| Category | Archived | Inactive | Restore with validation. | `OWNER_CONFIRMED`; Package C. |
| Category | Archived | Active | Direct transition prohibited. | `OWNER_CONFIRMED`; DB transition guard in B. |
| Variant | creation | Draft | New Variant starts Draft; it is not implicitly Active, Default, or visible. | `OWNER_CONFIRMED`; runtime create excluded from B. |
| Variant | Draft | Active | Validation required. | `OWNER_CONFIRMED`; Package C. |
| Variant | Draft | Inactive | Prohibited. | `OWNER_CONFIRMED`; DB transition guard in B. |
| Variant | Draft | Archived | Allowed subject to applicable archive guards. | `OWNER_CONFIRMED`; Package C. |
| Variant | Active | Inactive | Final Product state must remain valid. | `OWNER_CONFIRMED` consequence; Package C plus B final-state backstop. |
| Variant | Inactive | Active | Validation required. | `OWNER_CONFIRMED`; Package C. |
| Variant | Active/Inactive | Archived | Final Product state must remain valid. Flags are preserved. | `OWNER_CONFIRMED`; Package C plus B final-state backstop. |
| Variant | Archived | Inactive | Restore; preserve `is_default` and `customer_visible`. | `OWNER_CONFIRMED`; Package C. |
| Variant | Archived | Active | Direct transition prohibited. | `OWNER_CONFIRMED`; DB transition guard in B. |
| Product | any | any | Product has four allowed persisted values, but lifecycle commands and the unconfirmed transition matrix are excluded. | Values `OWNER_CONFIRMED`; commands excluded by `ODB-CAT-39`. |

### 5.2 Persisted-state invariants

| Invariant | Domain owner | Future Application coordination | Infrastructure/database protection | Direct-SQL/concurrency evidence |
|---|---|---|---|---|
| Canonical valid Code | Catalog Code Value Object | Parse before persistence | Regex check and length | Invalid/canonical boundary writes; duplicate race |
| Separate Brand/type Code namespace | Category/Product aggregate identity | Map known conflict | Three full unique constraints | Same/cross-type, same/cross-Brand, Archived reuse |
| Product has original Category | Product aggregate | No reassignment use case | Non-null composite FK plus immutable-scope trigger | Orphan/cross-Brand/reassignment rejection |
| Variant belongs to Product/Brand | Product aggregate | Mutate through Product only | Non-null composite FK plus immutable-scope trigger | Orphan/cross-Brand/move rejection |
| Category/Variant matrix | Respective aggregate | Named future lifecycle use case | `BEFORE UPDATE` transition guards | Every allowed/forbidden pair |
| At most one designated Default | Product aggregate | Lock Product for future designation operation | Partial unique index | Concurrent/direct duplicate designation |
| Active Product has one Active Default | Product aggregate | Lock Category, Product, Variants; validate final state | Deferred parent-locking constraint trigger | Zero/inactive/multiple/racing cases |
| Active Product Category is Active | Product plus Category fact | Lock Category before Product | Deferred Category/Product constraint trigger | Activation/deactivation/archive write-skew |
| No Purge | Category/Product retention behavior | No delete use case | Delete guards plus role denial | Every lifecycle state; DELETE/TRUNCATE privilege tests |

Product creation state remains `UNRESOLVED_OWNER_DECISION`: `ODB-CAT-19` permits a Draft Product but does not establish that every newly created Product is Draft. Therefore `products.lifecycle_status` has no database default and Package B exposes no creation path.

## 6. Proposed PostgreSQL schema

All objects below are `TECHNICAL_PROPOSAL`. UUID defaults, timestamp precision, UTC persistence, explicit constraint names, and `structure.sql` follow accepted repository conventions. Package B creates no rows.

### 6.1 `categories`

| Column | Type | Null/default | Purpose |
|---|---|---|---|
| `id` | `uuid` | not null; `gen_random_uuid()` | Primary identity. |
| `brand_id` | `uuid` | not null | Organization-context Brand reference. |
| `code` | `varchar(64)` | not null | Canonical Catalog Code. |
| `name` | `varchar(150)` | not null | Display/business name; matches canonical Data Dictionary proposal. |
| `position` | `integer` | not null; `0` | Flat-category display order; technical, not hierarchy. |
| `lifecycle_status` | `varchar(16)` | not null; `draft` | Category lifecycle. |
| `lock_version` | `integer` | not null; `0` | Optimistic version for future authorized mutations. |
| `created_at`, `updated_at` | `timestamptz(6)` | not null | UTC persistence timestamps, following the repository application-table convention confirmed by the Owner. |

Keys and objects:

- PK `categories_pkey (id)`;
- FK `fk_categories_brand (brand_id) → brands(id) ON DELETE RESTRICT`;
- UQ `uq_categories_id_brand (id, brand_id)` for same-Brand child FKs;
- UQ `uq_categories_brand_code (brand_id, code)`; no status predicate, so Archive reserves Code;
- checks `categories_code_canonical`, `categories_name_nonblank`, `categories_position_nonnegative`, `categories_lifecycle_allowed`, and `categories_lock_version_nonnegative`;
- index `index_categories_on_brand_status_position (brand_id, lifecycle_status, position, id)`; and
- initial-state, transition, immutable-scope, final-state, and no-Purge triggers described below.

### 6.2 `products`

| Column | Type | Null/default | Purpose |
|---|---|---|---|
| `id` | `uuid` | not null; `gen_random_uuid()` | Aggregate identity. |
| `brand_id` | `uuid` | not null | Repeated ownership key for Code scope and same-Brand proof. |
| `category_id` | `uuid` | not null | Original Category. |
| `code` | `varchar(64)` | not null | Canonical Product Code. |
| `name` | `varchar(200)` | not null | Product name. |
| `description` | `text` | nullable | Optional description. |
| `lifecycle_status` | `varchar(16)` | not null; **no default** | Allowed vocabulary only; creation policy unresolved. |
| `lock_version` | `integer` | not null; `0` | Optimistic version. |
| `created_at`, `updated_at` | `timestamptz(6)` | not null | UTC persistence timestamps, following the repository application-table convention confirmed by the Owner. |

Keys and objects:

- PK `products_pkey (id)`;
- FK `fk_products_brand (brand_id) → brands(id) ON DELETE RESTRICT`;
- composite FK `fk_products_category_brand (category_id, brand_id) → categories(id, brand_id) ON DELETE RESTRICT`;
- UQ `uq_products_id_brand (id, brand_id)` for Variant ancestry;
- UQ `uq_products_brand_code (brand_id, code)` including Archived rows;
- checks `products_code_canonical`, `products_name_nonblank`, `products_lifecycle_allowed`, and `products_lock_version_nonnegative`;
- index `index_products_on_category_status (category_id, lifecycle_status, id)`; and
- immutable-scope, final-state, and no-Purge triggers.

### 6.3 `product_variants`

| Column | Type | Null/default | Purpose |
|---|---|---|---|
| `id` | `uuid` | not null; `gen_random_uuid()` | Variant entity identity. |
| `brand_id` | `uuid` | not null | Repeated key for Code scope and Product ancestry. |
| `product_id` | `uuid` | not null | Owning Product. |
| `code` | `varchar(64)` | not null | Canonical Variant Code. |
| `name` | `varchar(150)` | not null | Variant display name, including hidden/default variants. |
| `position` | `integer` | not null; `0` | Display order within Product. |
| `lifecycle_status` | `varchar(16)` | not null; `draft` | Variant lifecycle. |
| `is_default` | `boolean` | not null; `false` | Independent Default designation. |
| `customer_visible` | `boolean` | not null; `false` | Independent customer exposure. |
| `lock_version` | `integer` | not null; `0` | Optimistic version. |
| `created_at`, `updated_at` | `timestamptz(6)` | not null | UTC persistence timestamps, following the repository application-table convention confirmed by the Owner. |

Keys and objects:

- PK `product_variants_pkey (id)`;
- FK `fk_product_variants_brand (brand_id) → brands(id) ON DELETE RESTRICT`;
- composite FK `fk_product_variants_product_brand (product_id, brand_id) → products(id, brand_id) ON DELETE RESTRICT`;
- UQ `uq_product_variants_brand_code (brand_id, code)` including Archived rows;
- partial UQ index `uq_product_variants_one_default (product_id) WHERE is_default`;
- checks `product_variants_code_canonical`, `product_variants_name_nonblank`, `product_variants_position_nonnegative`, `product_variants_lifecycle_allowed`, and `product_variants_lock_version_nonnegative`;
- index `index_product_variants_on_product_status_id (product_id, lifecycle_status, id)`; and
- initial-state, transition, immutable-scope, final-state, and no-Purge triggers.

There is no `sku`, `deleted_at`, Price, availability, Modifier, or Branch column.

### 6.4 Same-Brand design

Repeated `brand_id` is justified by two persisted invariants: each Catalog entity owns a Brand-scoped Code, and child ancestry must be provably same-Brand without trusting Rails. Product's composite FK proves its Category has the same Brand; Variant's composite FK proves its Product has the same Brand. Unique `(id, brand_id)` parent keys are the PostgreSQL target required by those FKs.

Direct Brand FKs are retained because Category, Product, and Variant are each Brand-owned records and because they produce explicit ownership failures rather than relying on a transitive parent chain. The composite FKs—not the direct FKs—prove same-Brand association.

Proposed `BEFORE UPDATE` immutable-scope triggers reject:

- Category `brand_id` changes;
- Product `brand_id` or `category_id` changes; and
- Variant `brand_id` or `product_id` changes.

Product Category immutability implements `ODB-CAT-41`. Category Brand and Variant Product membership immutability are technical aggregate-identity proposals for authorization review, not new Owner business decisions. Codes are not made immutable by Package B because editable-field/Code-correction policy is unresolved and no runtime update path exists.

### 6.5 Default and final-state enforcement

An ordinary partial unique index can prevent two designated Defaults but cannot require one to exist or require it to be Active. Package B therefore proposes both:

1. `uq_product_variants_one_default` for all-lifecycle at-most-one designation; and
2. `catalog_active_product_default_valid`, a row-level `DEFERRABLE INITIALLY DEFERRED` constraint-trigger family.

The trigger fires for:

- Product insert and Product `lifecycle_status` change;
- Variant insert and delete; and
- Variant change to `product_id`, `brand_id`, `lifecycle_status`, or `is_default`.

At deferred execution it resolves every affected Product ID from OLD/NEW rows, sorts IDs, locks each Product `FOR UPDATE`, and evaluates final transaction state. An Active Product must have exactly one Variant where `is_default = true AND lifecycle_status = 'active'`. `customer_visible` is absent from the predicate. Draft, Inactive, and Archived Products permit zero or one designation, with the partial index enforcing the upper bound.

The trigger raises SQLSTATE `23514` with constraint identity `catalog_active_product_default_valid`. Temporary zero-Default states are allowed inside a transaction; invalid commit state is not.

### 6.6 Category/Product final-state enforcement

`catalog_active_product_category_valid` is a second row-level deferred constraint-trigger family covering:

- Product insert and change to `category_id`, `brand_id`, or `lifecycle_status`; and
- Category change to `lifecycle_status`.

It uses event-specific locking before a separate final-state query. A Category event can lock the affected Categories before discovering and locking their assigned Products. A Product event is different: the triggering Product `INSERT` or `UPDATE` has already acquired its Product row lock before the deferred trigger executes. The trigger then requests the affected Category locks and confirms/acquires the affected Product locks; it cannot retroactively establish Category-before-Product physical lock acquisition for that event.

The trigger family therefore protects final-state integrity but does not independently provide a deadlock-free parent-first protocol for arbitrary Product DML. Predictable Category→Product acquisition belongs to the future authorized Application protocol in [Section 7.2](#72-authorized-application-lock-order), which locks parents before issuing child writes. Final state must satisfy: every Active Product references an Active Category. This single predicate also prevents Category Deactivate or Archive while Active Products remain, while preserving Deactivate and Archive as distinct Domain operations.

It raises SQLSTATE `23514` with constraint identity `catalog_active_product_category_valid`. It does not invent a Product lifecycle transition matrix or authorize a Product lifecycle command.

### 6.7 Category/Variant initial-state and transition guards

The four-value lifecycle checks validate vocabulary but cannot enforce creation state. Separate `BEFORE INSERT FOR EACH ROW` guards therefore require `NEW.lifecycle_status = 'draft'` for Category and Variant even when direct SQL explicitly supplies another allowed value:

- `catalog_enforce_category_initial_status()` raises SQLSTATE `23514` with constraint identity `categories_initial_lifecycle_draft`; and
- `catalog_enforce_variant_initial_status()` raises SQLSTATE `23514` with constraint identity `product_variants_initial_lifecycle_draft`.

The column default remains `draft` as a safe convenience, while the insert guard is the direct-write guarantee. Product deliberately has neither a lifecycle default nor an initial-state trigger because its creation state remains unresolved.

`BEFORE UPDATE OF lifecycle_status` triggers compare OLD/NEW values and allow only the `ODB-CAT-32` matrix for Category and Variant. Stable identities are:

- `categories_lifecycle_transition_allowed`; and
- `product_variants_lifecycle_transition_allowed`.

They raise SQLSTATE `23514`. An UPDATE that leaves `lifecycle_status` unchanged is not a lifecycle transition and is not rejected by the matrix guard.

#### 6.7.1 Variant Archive/Restore flag-preservation boundary

The three guarantees are deliberately distinct:

1. **Domain semantic guarantee:** an Archive or Restore operation changes Variant lifecycle status only. It preserves the pre-operation values of `is_default` and `customer_visible` for the whole semantic operation.
2. **Database statement-level protection:** when one SQL statement performs an Archive transition or Archived→Inactive Restore, `catalog_enforce_variant_transition()` requires both flags in NEW to equal OLD. A simultaneous status-and-flag change fails with `product_variants_lifecycle_transition_allowed`.
3. **Database limitation across statements:** PostgreSQL cannot infer that an independent flag UPDATE immediately before or after a status UPDATE belongs to the same semantic Archive/Restore intent. Both statements can individually satisfy the proposed constraints. The transition trigger therefore does **not** guarantee operation-level preservation across arbitrary privileged multi-statement SQL.

Package B closes that gap operationally, not by inventing a command: the runtime role has no Catalog `INSERT` or `UPDATE`, and no Archive/Restore operation exists. A future authorized Application operation must use this sequence:

1. begin one transaction and acquire the required parent/aggregate locks in the [documented order](#72-authorized-application-lock-order);
2. load or reload the Variant Domain entity only after every required lock has been acquired;
3. apply the Domain's status-only Archive or Restore behavior to that locked state;
4. persist the resulting state within the same transaction; and
5. verify before commit that `is_default` and `customer_visible` still equal the values loaded under lock.

Loading the Domain entity before lock acquisition is insufficient because either flag could change while the operation waits. The sequence above is a future interface requirement, not an Application implementation or authorization. Until such an operation exists, arbitrary runtime DML remains unauthorized. Product receives only an allowed-values check because its transition matrix and initial state remain unresolved.

### 6.8 No-Purge protection

Restrictive FKs do not protect an unreferenced row. Each Catalog table therefore receives a `BEFORE DELETE FOR EACH ROW` guard that raises SQLSTATE `23514` with one of:

- `categories_purge_forbidden`;
- `products_purge_forbidden`; or
- `product_variants_purge_forbidden`.

The runtime role has no `DELETE` or `TRUNCATE` privilege and does not own these tables. No delete method, dependent cascade, cleanup job, or Soft Delete scope is proposed. Migration/table-owner and superuser bypass remains possible by definition, so break-glass governance and role evidence are mandatory operational controls rather than a false database guarantee.

### 6.9 Constraint and trigger object catalog

The proposed checks use these exact predicates, adapted per table/column:

| Check family | Predicate |
|---|---|
| Canonical Code | `code ~ '^[A-Z0-9_-]+$'` (column type supplies the 64-character upper bound) |
| Nonblank name | `length(translate(name, chr(32) || chr(9) || chr(10) || chr(13) || chr(12) || chr(11), '')) > 0` |
| Lifecycle vocabulary | `lifecycle_status IN ('draft', 'active', 'inactive', 'archived')` |
| Position | `position >= 0` |
| Optimistic version | `lock_version >= 0` |

Stable procedural object names are:

| Function | Trigger(s) / constraint identity | Responsibility |
|---|---|---|
| `catalog_enforce_category_initial_status()` | `categories_initial_lifecycle_draft` | Reject non-Draft Category insert, including direct SQL. |
| `catalog_enforce_variant_initial_status()` | `product_variants_initial_lifecycle_draft` | Reject non-Draft Variant insert, including direct SQL. |
| `catalog_reject_category_scope_change()` | `categories_scope_immutable` | Reject Category Brand movement. |
| `catalog_reject_product_scope_change()` | `products_scope_immutable` | Reject Product Brand or Category movement. |
| `catalog_reject_variant_scope_change()` | `product_variants_scope_immutable` | Reject Variant Brand or Product movement. |
| `catalog_enforce_category_transition()` | `categories_lifecycle_transition_allowed` | Enforce Category matrix before status update. |
| `catalog_enforce_variant_transition()` | `product_variants_lifecycle_transition_allowed` | Enforce Variant matrix before status update. |
| `catalog_validate_active_product_default()` | `catalog_products_default_final_state`, `catalog_product_variants_default_final_state`; failure identities `catalog_active_product_default_valid` / `catalog_integrity_requires_read_committed` | As a `VOLATILE` function, lock affected Products and then separately query Active Default final state under `READ COMMITTED`. |
| `catalog_validate_active_product_category()` | `catalog_categories_product_final_state`, `catalog_products_category_final_state`; failure identities `catalog_active_product_category_valid` / `catalog_integrity_requires_read_committed` | As a `VOLATILE` function, apply the event-specific Category/Product lock protocol and then separately query Active ancestry under `READ COMMITTED`; a Product event begins after its DML has already locked the Product row. |
| `catalog_reject_purge()` | per-table `*_purge_forbidden` trigger and failure identity | Reject every Catalog row delete. |

All functions set an explicit safe SQLSTATE/constraint identity, have a fixed `search_path` or fully qualified object references, and expose no user-controlled dynamic SQL. Migrations verify every function and trigger definition through PostgreSQL catalogs after creation.

## 7. Transaction and concurrency protocol

All mechanisms here are `TECHNICAL_PROPOSAL`; Package B installs integrity but exposes no business transaction.

### 7.1 PostgreSQL isolation and snapshot assumptions

The proposed trigger protocol supports PostgreSQL `READ COMMITTED` only. That is PostgreSQL's default, but the implementation must configure and verify it rather than assume it.

The design relies on four PostgreSQL-specific behaviors:

1. At `READ COMMITTED`, each SQL command obtains a new snapshot containing transactions committed before that command begins. Successive commands in one transaction can therefore see newly committed work ([PostgreSQL 18 transaction isolation](https://www.postgresql.org/docs/18/transaction-iso.html)).
2. `SELECT ... FOR UPDATE` that encounters a conflicting row lock waits. If the locker commits, PostgreSQL locks/returns the current row version, but that locking command can still have an inconsistent view of other rows because its snapshot began before the wait.
3. PL/pgSQL trigger functions must be explicitly `VOLATILE`. Their SPI commands run read-write; at `READ COMMITTED`, each separate SPI command computes a new snapshot and can see newly committed transactions ([SPI execution and snapshots](https://www.postgresql.org/docs/18/spi-spi-execute.html), [trigger data visibility](https://www.postgresql.org/docs/18/trigger-datachanges.html)).
4. PostgreSQL resolves a deadlock by aborting one complete transaction; the design cannot choose the victim ([explicit locking and deadlocks](https://www.postgresql.org/docs/18/explicit-locking.html#LOCKING-DEADLOCKS)).

Consequently, each deferred final-state trigger function must separate lock acquisition/lock-set discovery from invariant validation in distinct PL/pgSQL SQL statements:

1. lock the directly known parent rows in deterministic UUID order with `FOR UPDATE`;
2. where the complete dependent lock set is not known until that parent is current, discover and lock it in another statement issued only after the parent lock returns; and
3. after every required lock request has returned, execute a separate invariant query.

The invariant query's later `READ COMMITTED` snapshot sees any competitor that committed while the lock statement waited, plus the current transaction's own writes. A single statement that both locks the parent and reads/counts children is rejected: after waiting, it may use the command's earlier snapshot for non-target child rows and miss the competitor's committed child change.

At `REPEATABLE READ`, later statements retain the transaction snapshot and can remain stale after the parent lock wait. This protocol therefore does not claim correctness at `REPEATABLE READ`; it also does not rely on Serializable Snapshot Isolation to repair a trigger design that was specified for another level. Both final-state trigger functions must check `current_setting('transaction_isolation') = 'read committed'` before validation and otherwise fail closed with SQLSTATE `23514` and constraint identity `catalog_integrity_requires_read_committed`. Supporting another isolation level requires a separately reviewed protocol and deterministic proof.

### 7.2 Authorized Application lock order

Future authorized Application operations acquire:

1. affected Category rows in ascending UUID order;
2. affected Product rows in ascending UUID order; and
3. affected Variant rows in ascending UUID order.

Default-only changes with no Category-state dependency begin at Product. No operation locks Variant then Product. All checks and writes occur in one database transaction.

This is an **Application pre-write protocol**, not a description of deferred-trigger execution. Parent locks must be acquired before the Application issues Product or Variant writes. This makes concurrent authorized operations serialize before either has changed Variant/Product children, avoids the known parent/child lock inversion among conforming operations, and lets the Domain validate against the current locked aggregate. Deferred triggers remain the direct-SQL/final-commit backstop rather than the primary Application lock mechanism.

A Product-event deferred trigger cannot supply that physical ordering after the fact: its triggering `INSERT` or `UPDATE` has already acquired the Product row lock before the trigger runs. The trigger can subsequently request Category locks and re-request or confirm Product locks, but it cannot transform that sequence into Category→Product acquisition.

An authorized operation may precompute directly named root IDs, but it must not precompute a dependent set across a lock wait and then treat that set as current. Before issuing a Product write, a Product operation derives the relevant Category/Product IDs, locks Category then Product, and discovers/locks its Variant set only after those parent locks. A Category operation locks the Category first, then uses a separate fresh command to discover and lock every currently assigned Product in UUID order. Only then may it load Domain state or write children. A row-level deferred constraint trigger can sort only the OLD/NEW parent IDs visible to that firing; PostgreSQL does not promise a global order for separate row-trigger firings from arbitrary multi-row direct SQL. Such direct SQL may therefore deadlock and lose one whole transaction, but it must not commit invalid state.

### 7.3 Deterministic protocols

| Scenario | Locks and validation | Commit outcome |
|---|---|---|
| Competing Default designation | Lock Product, then involved Variants by UUID; validate membership; write flags | One valid designation. Partial UQ rejects any duplicate race. |
| Variant activate/deactivate/archive | Lock Product then affected Variants; apply Domain transition; validate Product final state | Commit only if an Active Product retains exactly one Active designated Default. |
| Product final-state validation | Lock Category, Product, then Variants | Active final state requires Active Category and one Active designated Default. No Product command is authorized. |
| Category deactivate/archive | Lock Category, then assigned Products by UUID, then relevant Variants if needed | Commit only when no Active Products remain. |
| Product/Variant relationship creation | Lock/reference parent before child insert | Composite FK and deferred checks reject invalid final state. Runtime creation remains excluded. |

### 7.4 Final-state trigger algorithms

#### Product/Variant completeness

For `catalog_active_product_default_valid`, the volatile deferred trigger:

1. derives the affected Product IDs from OLD/NEW trigger rows;
2. rejects non-`READ COMMITTED` isolation;
3. locks all existing affected Product rows `FOR UPDATE` in UUID order in one statement;
4. runs a separate query using the next `READ COMMITTED` snapshot; and
5. raises `23514` unless every Active Product has exactly one Active Variant with `is_default = true`.

Two transactions may update different Variants of one Product without initially conflicting. At deferred execution, the Product lock serializes them. The first checker may ignore the still-uncommitted second transaction and commit if its own final state is valid. The second checker obtains the Product lock only afterward; its separate validation query receives a new snapshot that includes the first commit and must accept or reject the combined final state. This prevents Default/Active-completeness write skew at the supported isolation level.

#### Category/Product consistency

`catalog_active_product_category_valid` has two event-specific lock-set algorithms. Both reject non-`READ COMMITTED` isolation before claiming validity.

**Product event:**

1. derive the affected Product ID(s) and relevant Category ID(s) from both OLD and NEW; the current immutability guard normally makes the Category IDs equal, but the trigger must not assume that while deriving its safety set;
2. recognize that the triggering Product `INSERT` or `UPDATE` statement has already acquired the affected Product row lock before deferred execution begins;
3. request every derived Category row `FOR UPDATE` in deterministic UUID order;
4. after the Category lock requests return, explicitly confirm/acquire every existing affected Product row `FOR UPDATE` in deterministic UUID order, recognizing that the current transaction may already own the triggering row locks; and
5. execute a separate final-state validation command using the next `READ COMMITTED` snapshot.

This event-specific sequence protects the committed final state but does not make the trigger a Category→Product lock-order mechanism. For direct child-first SQL, the physical sequence can be Product→Category because the Product DML precedes deferred execution. That sequence can invert the Category→Product order used by a concurrent Category operation and can therefore deadlock. Only the authorized Application pre-write protocol in Section 7.2 predictably acquires Category before Product for conforming Product operations.

**Category event:**

1. derive the Category ID(s) from OLD and NEW;
2. lock those Category rows `FOR UPDATE` in deterministic UUID order;
3. only after the Category lock statement returns, execute a separate SQL command that discovers **all** Product rows currently assigned to those Categories and locks them `FOR UPDATE ORDER BY id`;
4. do not use a Product ID set queried before waiting for the Category lock; that set and its snapshot may be stale; and
5. after the Product-discovery/lock command returns, execute another separate SQL command that validates final state using a refreshed `READ COMMITTED` snapshot.

Lock-set discovery and invariant validation are different phases. The discovery command establishes the complete current Product lock set after Category serialization. The later validation command must examine every Active Product assigned to each affected Category—not merely the Product or Category row that originally queued one trigger firing—and require every such Product to reference an Active Category.

The separate post-lock commands matter because a command snapshot taken before waiting cannot be treated as a current view of other rows. Under the documented volatile `READ COMMITTED` protocol, each later SPI command receives a new snapshot and can see a competing transaction that committed while lock acquisition waited. Deterministic ordering reduces avoidable conflicts among conforming operations; it does not eliminate deadlocks involving child-first direct SQL or already-held row locks.

### 7.5 Arbitrary direct SQL, deadlock, and rollback

The Category row is the common serialization point for Category/Product validity. The Product row is the common serialization point for Product/Variant validity. Deferred checks must lock the common parent before counting children; a deferred query without that lock permits write skew.

For Product DML specifically, the `INSERT` or `UPDATE` statement acquires its Product row lock before its deferred Product-event trigger executes. The trigger may subsequently request the Category lock. A concurrent Category operation may already hold that Category row and, through its deferred Category-event trigger, request the Product row. This Product→Category versus Category→Product inversion is a parent/child lock cycle.

PostgreSQL may report `40P01` and abort one complete transaction; the design does not choose or predict the victim. Every write by the aborted transaction rolls back. The survivor resumes only after the conflicting locks are resolved and must still pass the deferred final-state validation using the documented separate `READ COMMITTED` command. This is an accepted fail-safe outcome, not a deadlock-free guarantee.

Two child-first direct transactions changing different children normally serialize later on the common parent without a deadlock. The second final-state checker must use its separate refreshed snapshot to observe the first commit. Direct SQL that uses an unsupported isolation level fails closed at deferred validation rather than risking stale-snapshot acceptance.

The difference is intentional:

- **Authorized Application operation:** parent-first locks, Domain behavior, one transaction, future authorization/audit, predictable contention, and Infrastructure error translation.
- **Arbitrary direct SQL:** immediate constraints and deferred triggers protect committed state, but child-first ordering may deadlock, no Domain semantic operation is inferred, and role grants continue to deny this path to runtime.

For a Product activation racing Category Deactivate/Archive, two materially different schedules must remain visible:

- If the Product transaction's deferred checker obtains the Category lock first, the Category transaction blocks at its `UPDATE categories` statement; it does not necessarily reach its deferred trigger before waiting. After the Product transaction validates and commits, the Category UPDATE resumes, and its later deferred validation must use fresh post-lock discovery/validation snapshots and reject the now-invalid Category state.
- If the Category UPDATE holds the Category row while the Product transaction already holds the Product row, the Product deferred checker waits for Category and the Category deferred checker can wait for Product. PostgreSQL detects that cycle and aborts one complete transaction. The survivor re-establishes its required locks, evaluates final state through its deferred checker, and commits only if the invariant holds.

### 7.6 Timeouts and retries

- SQLSTATE `40P01` (deadlock) and `40001` (serialization failure) may be retried only as a whole future Application command under a bounded, deployment-validated policy.
- `55P03` (lock unavailable) and `57014` (statement/lock timeout cancellation) produce stable busy/timeout outcomes; they are not silently retried forever.
- A statement failure aborts the PostgreSQL transaction; code never rescues and continues inside it.
- Package B selects no retry count or timeout value. Those are technical deployment settings requiring capacity evidence.

### 7.7 Constraint timing

Initial-state guards, local checks, FKs, transition guards, immutable-scope guards, and unique indexes are immediate. Cross-row final-state constraint triggers are initially deferred and may be forced with `SET CONSTRAINTS ALL IMMEDIATE` in tests. Commit succeeds only after both final-state families pass. Trigger functions are `VOLATILE`, use separate lock and validation statements, and reject unsupported isolation before claiming final-state validity.

## 8. Infrastructure error translation

Package B has no public or Application error contract. A future Infrastructure transaction adapter must inspect both SQLSTATE and `PG_DIAG_CONSTRAINT_NAME`, then translate only known combinations into stable internal categories:

| Database outcome | Known identity examples | Internal category |
|---|---|---|
| `23505` unique violation | `uq_*_brand_code` | `duplicate_catalog_code` |
| `23505` unique violation | `uq_product_variants_one_default` | `default_designation_conflict` |
| `23503` FK violation | named Brand/composite parent FKs | `invalid_catalog_reference` or `referenced_resource` by operation |
| `23514` check/trigger | code/name/status/transition/final-state names | `catalog_validation_or_state_conflict` with a safe specific reason |
| `23514` delete guard | `*_purge_forbidden` | `catalog_retention_conflict` |
| `23514` isolation guard | `catalog_integrity_requires_read_committed` | `catalog_unsupported_transaction_isolation` |
| `40P01`, `40001` | n/a | `catalog_concurrency_conflict` after bounded whole-command handling |
| `55P03`, `57014` | n/a | `catalog_busy_or_timeout` |

Deferred failures occur at `COMMIT`, so translation wraps the whole transaction, not only `save!`. Unknown constraint names, unknown SQLSTATEs, connection failures, and unexpected database errors are re-raised, correlated, redacted, and treated as unexpected failures. They are never called success or mislabeled as a known business error. Presentation mapping is outside Package B.

## 9. Migration, rollback, and reproducibility protocol

### 9.1 Proposed migration order

1. Assert PostgreSQL 18 and that A1 `brands` exists with the expected UUID primary key; do not insert or infer a Brand.
2. Create `categories` with local constraints, indexes, FK, Draft-only insert guard, transition/immutability/no-Purge guards.
3. Create `products` with local constraints, direct/composite FKs, candidate key, immutability/no-Purge guard.
4. Create `product_variants` with local constraints, composite FK, partial unique index, Draft-only insert guard, transition/immutability/no-Purge guards.
5. Install Product/Variant deferred final-state function and triggers.
6. Install Category/Product deferred final-state function and triggers.
7. Verify named objects from PostgreSQL catalogs, then regenerate `structure.sql` through the documented command.

One reviewed migration may install the empty schema atomically, but functions/triggers must have explicit reversible removal order. No A2 mapping, operational FK, data backfill, seed, AuditEvent change, or writer change is bundled.

### 9.2 Fresh and upgrade paths

- **Fresh:** apply all migrations to an empty database; verify A1 parents precede Package B; dump and load `structure.sql`; compare named objects.
- **Upgrade:** apply Package B to the approved current schema; preflight object-name collisions and Brand-table contract; prove all unrelated row counts and definitions are unchanged.
- **Failure atomicity:** inject a failure during trigger installation and prove no partial schema remains.
- **Reproducibility:** migration-built and `structure.sql`-loaded schemas expose identical columns, defaults, constraints, indexes, functions, triggers, and grants.

### 9.3 Rollback and roll-forward

Down migration first refuses rollback if any Catalog table contains rows. When empty, remove deferred triggers, transition/immutability/delete triggers, functions, child table, Product table, then Category table. It never drops or changes A1 tables.

After data exists, destructive rollback is unsafe and prohibited by the no-Purge policy. Operational recovery is roll-forward: disable unavailable entry points, correct functions/constraints through a reviewed migration, preserve data, and revalidate. Release plans set bounded lock/statement timeouts and monitor migration locks.

## 10. Database roles and operational safety

Exact role names are environment configuration; required capabilities are:

| Role | Proposed privileges | Prohibited / controlled behavior |
|---|---|---|
| Runtime application | `CONNECT`, schema `USAGE`; no Package B DML while no runtime operation is authorized. Later grants are operation-specific. | Never owns tables/functions; no `DELETE`, `TRUNCATE`, DDL, trigger disablement, function replacement, role grant, or bypass. |
| Migration | Owns or can alter approved schema objects for a bounded release. | Not used by web/worker runtime; credentials separated; migrations reviewed and logged. |
| Break-glass maintenance | No standing runtime membership; time-bound controlled elevation after explicit authorization. | Every use requires reason, approver, commands/evidence, post-check, and revocation. It does not convert prohibited Purge into policy. |

Future runtime `INSERT`/`UPDATE` grants require separately authorized use cases. Immutable-scope and final-state triggers remain defense in depth even then. Local/test use of a PostgreSQL superuser proves neither least privilege nor production readiness.

Required production-like evidence includes `has_table_privilege`, `has_function_privilege`, ownership inspection, negative DELETE/TRUNCATE/ALTER/DISABLE TRIGGER attempts, migration success under the migration role, and proof that break-glass access is not available to the normal application principal.

## 11. Future verification matrix

Tests in this section are required after separate implementation authorization. They are not executed by this documentation task.

### 11.1 Domain tests

| Setup | Action | Expected result | Evidence |
|---|---|---|---|
| Valid mixed-case/trimmed Code | Construct Catalog Code | Canonical uppercase value | Pure spec with exact input/output |
| Empty, whitespace, Unicode/accent, punctuation, control input | Construct Catalog Code | Typed Domain rejection | Case table; no Rails loaded |
| 64/65-character valid Codes | Construct | 64 accepted, 65 rejected | Boundary spec tied to proposed length |
| Product aggregate in each lifecycle state | Designate zero/one/two Defaults | At most one always; Active requires one Active | Aggregate state-result specs |
| Hidden Active Variant | Validate Active Product | Accepted as Default | Visibility-independence spec |
| Inactive/Archived designated Variant | Validate Active Product | Rejected | Eligibility specs |
| Category/Variant state matrix | Attempt every transition | Only confirmed transitions accepted | Complete transition table spec |
| Variant Archive/Restore | Apply transition | Flags unchanged; Restore ends Inactive | Before/after value assertions |

### 11.2 Infrastructure/database tests

| Setup | Action | Expected result | Evidence |
|---|---|---|---|
| Valid parents | Insert each row through record and direct SQL | Accepted | Row plus constraint catalog |
| Missing/cross-Brand parents | Direct Product/Variant insert | Named FK rejection | SQLSTATE `23503` and exact name |
| Same Code same type/Brand | Concurrent/direct duplicate insert | One commit, one named UQ failure | `23505`; final count one |
| Same Code cross type or Brand | Insert records | Accepted | Persisted rows |
| Archived Code | Insert duplicate after Archive | Rejected | Same UQ identity |
| Invalid/noncanonical Code and names | Direct insert/update | Rejected | Named check identity |
| Category initial lifecycle | Directly insert one Category as Active, Inactive, and Archived in separate cases | Every non-Draft insert rejected; explicit/default Draft accepted | `23514`, `categories_initial_lifecycle_draft`, unchanged row count |
| Variant initial lifecycle | Directly insert one Variant as Active, Inactive, and Archived in separate cases | Every non-Draft insert rejected; explicit/default Draft accepted | `23514`, `product_variants_initial_lifecycle_draft`, unchanged row count |
| Product initial lifecycle | Directly insert Product with each allowed value and otherwise valid final state | No initial-state trigger decides policy; allowed-value/final-state rules alone apply | Confirms Product remains separate and no default exists |
| Category/Variant transition matrix | Direct update every pair | Only confirmed pairs commit | `23514` for prohibited pairs |
| Variant Archive/Restore flag preservation | Change status and either flag in one direct statement | Rejected; status-only transition preserves both flags | Transition-trigger identity and unchanged row |
| Privileged multi-statement Variant mutation | Change a flag in one statement and Archive/Restore status in another | Documents that statement-level trigger cannot attribute one semantic operation; not accepted as a runtime path | Final rows plus explicit limitation record |
| Runtime role multi-statement attempt | Attempt either flag/status UPDATE | Permission denied before semantic bypass is possible | Runtime role and privilege SQLSTATE |
| Product Category/Brand or Variant Product/Brand move | Direct update | Rejected | Immutable-scope trigger identity |
| Two Default flags | Direct insert/update | Rejected in every Product state | Partial UQ identity |
| Active Product with zero/non-Active Default | Force constraints/commit | Rejected | `catalog_active_product_default_valid` |
| Active Product under non-Active Category | Force constraints/commit | Rejected | `catalog_active_product_category_valid` |
| Delete any Catalog row in each status | Direct `DELETE` | Rejected even unreferenced | Named no-Purge identity |
| Unknown constraint failure fixture | Pass through translator | Re-raised as unexpected | Translator spec; no misclassification |

### 11.3 Concurrency tests

Use separate real PostgreSQL 18 connections, explicit `READ COMMITTED`, deterministic barriers or lock observation, transactional fixtures disabled, bounded timeouts, and explicit final-state queries. Thread timing or mocks are not evidence.

| Scenario | Connection A | Connection B | Expected result | Distinguishing evidence |
|---|---|---|---|---|
| Same Brand/type Code | Insert Code; hold before commit | Insert same Code and commit | Exactly one commit | `23505`, exact UQ, final count one |
| Correct Product-parent serialization | Change an Inactive Product to Active while its designated Variant is initially Active; pause after Product lock in deferred check | Change that designated Variant from Active to Inactive and attempt deferred check/commit | One checker waits; after the first commit, the second checker uses a separate validation snapshot and rejects the combined invalid state | `pg_locks`/barrier trace, connection outcomes, `catalog_active_product_default_valid`, valid final Product |
| Category UPDATE waits before its deferred checker | Change Product Inactive→Active; force A's deferred checker to obtain Category lock | Attempt Category Active→Inactive/Archived | B blocks at `UPDATE categories`; after A commits, B resumes and its deferred checker rejects using fresh Product discovery/validation snapshots | Statement/lock trace, `catalog_active_product_category_valid`, valid final joined state |
| Expected parent/child deadlock | Authorized-style path locks Product then requests Variant held by B | Direct child-first path updates Variant then deferred checker requests Product held by A | PostgreSQL aborts exactly one whole transaction; survivor passes final-state trigger | `40P01`, both transaction outcomes, victim writes absent, valid final state; do not assert victim identity |
| Reverse Category/Product deadlock | Update Category first and hold Category row; deferred checker later requests Product held by A | Update Product and hold Product row; deferred checker requests Category held by B | One whole transaction aborts; survivor rechecks final state | `40P01`, rollback proof, valid final join; victim identity not asserted |
| Stale-snapshot detector: combined lock/check (negative harness) | Hold parent and commit a child change while B's intentionally defective single-statement checker is waiting | Begin checker before A commits using one statement/snapshot | Harness demonstrates that the old snapshot can miss A's child commit; this implementation shape must never be accepted | Snapshot/XID trace and observed invalid read in isolated spike; no production mechanism installed |
| Unsupported isolation fail-closed | At `REPEATABLE READ`, perform an integrity-sensitive Product/Variant change | Optionally commit a competing change | Deferred validation rejects instead of claiming fresh visibility | `23514`, `catalog_integrity_requires_read_committed`, full rollback |
| Lock timeout | Hold required parent beyond configured test timeout | Attempt integrity-sensitive operation | Timed-out transaction fully rolls back | `55P03` or `57014`, no partial changes |
| Temporary invalid state repaired | Clear/set Default within one transaction, then force constraints | No competitor | Repaired final state commits; unrepaired variant rejects | Immediate/deferred outcomes and final rows |

The stale-snapshot detector is a negative experimental test of the rejected one-statement algorithm. Acceptance requires the actual two-statement volatile trigger to pass the serialization cases and the isolation guard to pass the fail-closed case; a stale-snapshot/write-skew observation in the actual mechanism makes Package B `NOT_READY` until redesigned.

#### 11.3.1 Required Category/Product schedule A — UPDATE waits

The deterministic test must orchestrate and record this exact sequence:

1. Transaction A updates a Product from Inactive to Active; that DML acquires A's Product row lock before deferred trigger execution.
2. A forces or reaches its deferred Product-event constraint trigger, which then obtains the relevant Category row lock while A continues to own the Product row lock.
3. Transaction B attempts to Deactivate or Archive that Category.
4. B blocks at its `UPDATE categories` statement because A already holds the Category row lock; B has not yet queued/reached the deferred validation for a completed Category UPDATE.
5. A locks its required Product set, validates the final invariant, and commits.
6. B's Category UPDATE resumes against the current row version.
7. B reaches its deferred trigger; after Category locking, it executes a fresh SQL command to discover and lock all currently assigned Products, then a separate fresh-snapshot validation query sees A's committed Active Product.
8. B is rejected because a Category with an assigned Active Product cannot become Inactive or Archived; B's entire transaction rolls back.

Evidence must include the point at which B waits, both transaction outcomes, relevant SQLSTATE/constraint identity, and the final Category/Product join. A test that merely observes B waiting somewhere is insufficient.

#### 11.3.2 Required Category/Product schedule B — reverse-order deadlock

The deterministic test must orchestrate and record this exact sequence:

1. Transaction B updates the Category first and holds the Category row lock.
2. Transaction A updates a Product and therefore holds the Product row lock before its deferred trigger executes.
3. A reaches its deferred Product-event constraint trigger, attempts to lock the Category, and waits for B.
4. B reaches its deferred constraint trigger, completes Category lock ownership, discovers the assigned Product set, attempts to lock A's Product, and waits for A.
5. PostgreSQL detects the deadlock and aborts one complete transaction with `40P01`; the test must not assume which transaction is selected.
6. The survivor resumes, acquires the required locks, validates using the documented fresh-snapshot protocol, and may commit only if the final invariant holds.

Evidence must prove that every write by the deadlock victim rolled back and that the surviving committed state contains no Active Product under a non-Active Category. Deadlock detection is an integrity-preserving failure outcome, not evidence that the lock order prevents all deadlocks.

### 11.4 Migration and role tests

| Setup/action | Expected result | Evidence |
|---|---|---|
| Fresh migration | All objects installed | Migration log plus catalog snapshot |
| Upgrade approved current schema | Unrelated objects/data unchanged | Before/after checksums/counts |
| `structure.sql` dump/load | Identical Package B objects | Normalized catalog comparison |
| Empty rollback | Only Package B removed | Down log and A1 verification |
| Nonempty rollback attempt | Refused without deletion | Exact migration error and preserved rows |
| Injected migration failure | Atomic rollback | No partial objects |
| Runtime role DELETE/TRUNCATE/DDL/disable attempt | Permission denied | Role identity and SQLSTATE |
| Migration role apply | Succeeds only for approved migration | Role/ownership evidence |

## 12. CAT-TRR dependency matrix

This design does not edit or close canonical findings.

| Finding | Package B can address | Package B cannot address | Evidence still required | Blocks |
|---|---|---|---|---|
| `CAT-TRR-001` `BLOCKER` | Empty Catalog FKs may reference empty A1 Brand table. | Authoritative target mapping, A2, operational Branch integration. | Per-environment inventory and approved mapping/orphan disposition. | A2 and production/runtime Catalog; not empty B schema. |
| `CAT-TRR-003` `BLOCKER` | Keep runtime commands out of B. | Trusted Identity/delegation and Brand-scoped audit. | Authorized implementation and security evidence. | B runtime operations and Package C; not empty B schema. |
| `CAT-TRR-004` `HIGH` | Avoid AuditEvent changes in B. | Brand-scope AuditEvent migration. | No-row-update migration and append-only proof. | Audited runtime/C; not empty B schema. |
| `CAT-TRR-005` `HIGH` | Specify no-Purge guards, no cascades, and role denial. | Prove installed behavior. | Direct-SQL all-state tests and privileged procedure evidence. | B implementation completion and C until evidenced. |
| `CAT-TRR-006` `HIGH` | Specify parent serialization, deferred checks, lock order, and races. | Supply executable concurrency proof. | Deterministic multi-connection results. | B implementation completion and C until evidenced. |
| `CAT-TRR-007` `HIGH` | Specify runtime/migration/break-glass privilege requirements. | Supply production-like grants/topology. | Role catalog and negative privilege tests. | Production-like B/C completion; not design submission. |
| `CAT-TRR-008` `MEDIUM` | Specify named objects, error translation, migration and dump/load protocol. | Supply executed fresh/upgrade evidence. | Migration, schema, rollback/roll-forward, unknown-error results. | B implementation completion and C until evidenced. |
| `CAT-TRR-009` `LOW`, `RESOLVED` | Preserve ODB-CAT consistency. | No change required. | Reopen only on contradictory evidence. | Nothing currently. |

The report-only `CAT-ARCH-001` gap is addressed at design level by §§3–4: the Domain interface, aggregate candidates, layer ownership, Infrastructure namespace, mapping rule, Presentation absence, and cross-context restriction are now explicit. No canonical finding status is changed.

## 13. Unresolved and external matters

| Item | Classification | Package B effect |
|---|---|---|
| Category separate aggregate and Product-with-Variants aggregate | `TECHNICAL_PROPOSAL` | Proposed for approval with this design; no new business decision required. |
| Code maximum of 64 | `TECHNICAL_PROPOSAL` | Exact bounded value is proposed for implementation authorization; Owner business policy unchanged. |
| Product creation and universal initial status | `UNRESOLVED_OWNER_DECISION` | No Product default and no create operation; does not block empty schema. |
| Product lifecycle commands | `OWNER_CONFIRMED` exclusion | Not in B or initial Catalog Core MVP. |
| Product Category reassignment | `OWNER_CONFIRMED` exclusion | No operation; immutable assignment backstop proposed. |
| Create/read/edit authority and editable fields | `UNRESOLVED_OWNER_DECISION` | Blocks runtime operations, not empty schema. |
| Default designation authority | `UNRESOLVED_OWNER_DECISION` | Blocks switching operation, not integrity index/trigger. |
| Non-lifecycle mutation audit requirements | `UNRESOLVED_OWNER_DECISION` | Blocks create/edit/Default operations. |
| Trusted Identity/delegation | `EXTERNAL_PREREQUISITE` | Blocks runtime operations and C; Identity Milestone 2B remains unauthorized. |
| Brand-scoped append-only AuditEvent | `EXTERNAL_PREREQUISITE` | Blocks audited runtime operations and C; excluded from B. |
| Cross-context Brand Application contract | `EXTERNAL_PREREQUISITE` when a real operation requires it | Database FK is sufficient for empty schema; A1 is not an Application contract. |
| Isolation levels other than `READ COMMITTED` | `TECHNICAL_PROPOSAL` limitation | Final-state triggers fail closed with `catalog_integrity_requires_read_committed`; broader support requires a new PostgreSQL-specific proof. |
| Multi-statement privileged Archive/Restore flag changes | `TECHNICAL_PROPOSAL` limitation | Database statement guard cannot infer semantic grouping; runtime DML denial is required until an authorized Application operation exists. |
| Executed deferred-trigger snapshot/concurrency proof | `EXTERNAL_PREREQUISITE` after implementation authorization | Design remains reviewable, but CAT-TRR-006 stays open until deterministic PostgreSQL evidence exists. |
| Exact deployment role names/grants and break-glass operator process | `EXTERNAL_PREREQUISITE` | Role capabilities are designed; production-like evidence remains required. |
| A2 target mapping | `EXTERNAL_PREREQUISITE` | Blocks production integration, not empty schema. |
| SKU semantics/support | `UNRESOLVED_OWNER_DECISION` for future scope | No SKU column in B. |
| Price tax, service charge, rounding, free items, Modifier effects, publication authority | `UNRESOLVED_OWNER_DECISION` | Entirely outside B. |
| Branch availability scheduling/authority | `UNRESOLVED_OWNER_DECISION` | Entirely outside B. |
| Future Soft Delete or Purge policy | `OWNER_CONFIRMED` exclusion for MVP | No such mechanism in B. |

None of these items reopens `ODB-CAT-01` through `ODB-CAT-41`. The unresolved runtime items must not be inferred from schema fields or persistence records.

## 14. Alternatives and failure modes

| Decision | Selected proposal | Alternative | Reason / failure avoided |
|---|---|---|---|
| Aggregate shape | Category separate; Product owns Variants | One Brand-sized aggregate or three independent roots | Keeps consistency local without loading the whole menu or losing Default integrity. |
| Same-Brand proof | Repeated `brand_id` plus composite FKs | Rails-only or trigger-only validation | Declarative direct-SQL integrity and race safety. |
| Catalog Code | Pure Value Object plus canonical DB check | DB normalization trigger or raw/canonical pair | One authoritative value; avoids divergent normalization. |
| SKU | No column | Nullable/forced-null column | Avoids carrying an unresolved field and accidental semantics. |
| Default upper bound | Partial unique index | Rails validation | Race-safe all-state cardinality. |
| Active completeness | Deferred parent-locking constraint trigger | Application-only or immediate trigger | Protects direct SQL and permits valid multi-step transactions. |
| Cross-aggregate Category rule | Deferred Category/Product trigger | Query without parent lock | Prevents activation/deactivation write skew. |
| No-Purge | Delete guards plus privileges | Restrictive FKs only | Protects unreferenced rows and TRUNCATE path through grants. |
| Persistence seam | Namespaced records; focused projection only | Generic repositories/mappers now | Avoids shallow speculative abstractions before a use case exists. |

Known failure modes to test include missing insert/transition trigger events, OLD/NEW parent mistakes, transition-trigger recursion, combining parent lock and child validation under a stale command snapshot, unsupported transaction isolation, deadlock from direct child-first SQL, transaction continuation after failure, multi-statement privileged Archive/Restore flag changes, superuser/table-owner bypass, long locks, migration object-name collision, partial installation, incorrect constraint-name translation, and accidental exposure of records as public DTOs.

## 15. Readiness verdict

### `READY_FOR_OWNER_APPROVAL`

Package B's schema-only design is internally consistent, traceable to ADR-0011 and Owner decisions, bounded away from runtime operations, and testable. It now specifies:

- strict Layered DDD ownership and proposed Catalog namespace;
- Category and Product/Variant aggregate candidates plus Catalog Code behavior;
- exact tables, columns, keys, checks, indexes, trigger responsibilities, and no-Purge controls;
- same-Brand, Default, lifecycle, direct-SQL, transaction, concurrency, error, migration, role, and verification protocols; and
- the unresolved/external matters that do not block an empty-schema authorization request.

The three review findings have coherent proposed resolutions: Draft-only insert guards close the Category/Variant initial-state gap; Archive/Restore semantics are separated honestly from statement-level database protection and mitigated by zero runtime DML; and deferred checks are restricted to a two-statement, `VOLATILE`, `READ COMMITTED` protocol with an explicit fail-closed isolation guard and deterministic proof plan.

This verdict means only that a separate Package B implementation-authorization proposal may now be prepared for Owner review. It does not approve the `varchar(64)` length, aggregate proposal, constraints, migrations, code, tests, roles, or implementation. The authorization request must explicitly accept or amend these technical proposals and retain the empty-schema boundary.

Executable evidence for `CAT-TRR-005` through `CAT-TRR-008` cannot exist before authorized implementation; those findings remain open and must be satisfied before Package B is called complete or production-ready. A2 remains blocked by `CAT-TRR-001`. Runtime Catalog operations and Package C remain blocked by trusted Identity/delegation, Brand-scoped append-only Audit, operation-level Owner decisions, and Package B implementation evidence.

No implementation authorization is implied.
