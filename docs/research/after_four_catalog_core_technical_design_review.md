# AFTER FOUR — Catalog Core Technical Design Review

**Review date:** 2026-11-15

**Decision synchronization:** 2026-11-15 (`ODB-DATA-01`; `ODB-CAT-26` narrowed; Catalog decisions synchronized through `ODB-CAT-41`)

**Technical completion reassessment:** 2026-11-15 ([completion review](after_four_catalog_core_technical_design_completion_review.md))

**Technical readiness reassessment:** 2026-11-15 ([readiness reassessment](after_four_catalog_core_technical_readiness_reassessment.md))

**Review type:** Critical documentation and architecture review

**Overall verdict:** `NOT_READY`

**Implementation authorization:** Not granted

## 1. Scope and evidence

This review evaluates the Catalog Core technical design against the Owner-confirmed baseline and repository conventions. This synchronization incorporates decisions through `ODB-CAT-41` without changing the verdict or authorizing implementation.

Evidence inspected:

- Owner Decision Baseline [§5](../architecture/after_four_owner_decision_baseline.md#5-catalogpricing-mvp), especially `ODB-CAT-01` through `ODB-CAT-41`, and [§6](../architecture/after_four_owner_decision_baseline.md#6-global-data-retention-and-deletion), including `ODB-DATA-01`.
- [Catalog Core Technical Design](../architecture/after_four_catalog_core_technical_design.md).
- [Catalog Core Implementation Readiness Review](after_four_catalog_core_implementation_readiness_review.md).
- [DDD Foundation §3.2](../architecture/after_four_ddd_foundation.md#32-catalogpricing), [Business Domain Model](../architecture/after_four_business_domain_model.md), [ERD](../architecture/after_four_erd.md), [Data Dictionary](../architecture/after_four_data_dictionary.md), and [Data Integrity Rules](../architecture/after_four_data_integrity_rules.md).
- [State Machines §2.3](../architecture/after_four_state_machines.md#23-product-lifecycle-and-price-history), [API Contract §5](../architecture/after_four_api_contract.md#5-product-and-menu-contracts), and relevant accepted ADRs `0001`, `0003`, `0004`, `0005`, `0007`, `0009`, and `0010`.
- Existing Order/Payment migrations, domain commands, models, and PostgreSQL integration/concurrency specs, including `backend/db/migrate/20261114202000_enforce_payment_aggregate_integrity.rb`.
- Read-only local test-database inventory on 2026-11-15: zero Orders and one orphan AuditEvent referencing Branch UUID `4a52651d-7f73-412e-8e13-c3b342fc779d`. The development database has no `orders` relation. No production database was accessed.

The working tree was inspected before review. `docs/architecture/after_four_catalog_core_technical_design.md` was already an untracked, pre-existing deliverable; no unrelated changes were present.

## 2. Overall assessment

The design contains sound technical directions for UUID keys, same-Brand composite foreign keys, restrictive deletion, temporary SKU deferral, and an expand/migrate/contract Branch transition. The completion review now specifies the remaining mechanisms, but no executable evidence exists and the design is not ready to authorize Category/Product/Variant persistence.

CAT-CLAR-01 through CAT-CLAR-09, all-lifecycle Default cardinality, and the later initial-scope questions are closed through `ODB-CAT-41`. Product lifecycle commands and Category reassignment are excluded; Variant Archive/Restore preserves its flags. The technical design remains `TECHNICAL_DESIGN_INCOMPLETE`; trusted authorization, concurrency/database-role proof, migration evidence, and target-environment Branch mapping remain blockers.

`CAT-REV-001` is resolved by Owner-confirmed `ODB-CAT-27`: Category, Product, and Variant use separate Code namespaces within each Brand. The resulting three per-entity unique constraints remain a technical proposal and are not implemented.

`CAT-REV-002` is resolved by Owner-confirmed `ODB-CAT-28` and `ODB-CAT-38`: every Product permits at most one designated Default, while an Active Product requires exactly one and it must be Active; `customer_visible` is independent. Database enforcement and concurrency proof remain technical work.

`CAT-REV-004` is resolved by Owner-confirmed `ODB-CAT-29`: Product activation requires an Active assigned Category, and Category Deactivation is blocked while Active Products remain assigned. Category Archive and Branch availability remain separate concerns; technical serialization and concurrency proof remain open.

The prior deferred-trigger proposal also lacked a common parent-row lock and was therefore vulnerable to cross-transaction write-skew. `ODB-CAT-28` closes the business predicate, but the corrected parent-serialization mechanism remains a `TECHNICAL_PROPOSAL` requiring concurrency proof.

## 3. Findings summary

| ID | Severity | Finding | Resolution type |
|---|---|---|---|
| `CAT-REV-001` | `RESOLVED` | `ODB-CAT-27` confirms separate Category/Product/Variant Code namespaces within each Brand. | Business ambiguity closed; technical constraints still proposed. |
| `CAT-REV-002` | `RESOLVED` | `ODB-CAT-28` defines Active eligibility and `ODB-CAT-38` defines at-most-one designation across every Product lifecycle state, independent of visibility. | Business ambiguity closed; enforcement still proposed. |
| `CAT-REV-003` | `DESIGN_REMEDIATED_EVIDENCE_PENDING` | Deferred final-state queries without a common Product lock do not prevent Product/Variant write-skew. | Parent-locking design specified; PostgreSQL concurrency proof still required. |
| `CAT-REV-004` | `RESOLVED` | `ODB-CAT-29` confirms Active-Category activation eligibility and blocks Category Deactivation while Active Products remain assigned. | Business ambiguity closed; enforcement still proposed. |
| `CAT-REV-005` | `RESOLVED_BUSINESS_POLICY` | `ODB-CAT-30`–`ODB-CAT-32` confirm Draft creation, exact transition matrix, and Restore to Inactive for Category/Variant. | Business ambiguity closed; technical commands, enforcement, audit, and concurrency still blocked. |
| `CAT-REV-006` | `MEDIUM` | Branch migration evidence is environment-specific and cannot establish production readiness. | Target-environment inventory and authoritative mapping. |

No finding was manufactured to populate an unused severity category.

## 4. Detailed findings

### CAT-REV-001 — Catalog Code namespace resolved by `ODB-CAT-27`

**Status:** `RESOLVED_OWNER_CONFIRMED`

**Affected evidence:** `ODB-CAT-16`, `ODB-CAT-18`, `ODB-CAT-22`, `ODB-CAT-27`; Technical Design §§3, 5.1, 12, and 15

**Classification:** `OWNER_CONFIRMED`

The Owner selected the separate-namespace interpretation. Within one Brand, the same Code may be used once by a Category, once by a Product, and once by a Variant. A second Category, Product, or Variant with the same Code in that Brand is rejected only within its own entity type. This resolution does not define SKU or Organization/Brand/Branch Code rules.

The technical consequence is three separate unique constraints on `(brand_id, code)`, one per entity table, including archived rows. Exact constraint names, migrations, concurrency proof, and error mapping remain `TECHNICAL_PROPOSAL`; no migration or implementation is authorized by the decision.

### CAT-REV-002 — Default cardinality and eligibility resolved by `ODB-CAT-28` and `ODB-CAT-38`

**Status:** `RESOLVED_OWNER_CONFIRMED`

**Affected evidence:** `ODB-CAT-04`, `ODB-CAT-19`, `ODB-CAT-20`, `ODB-CAT-23`, `ODB-CAT-25`, `ODB-CAT-28`, `ODB-CAT-31`, `ODB-CAT-38`; Technical Design §§3, 6–8, and 15

**Classification:** `OWNER_CONFIRMED`

Every Product permits at most one Variant with `is_default = true`. Draft, Inactive, and Archived Products permit zero or one; an Active Product requires exactly one, and it must have lifecycle status Active. An Active Variant remains eligible when `customer_visible = false`; visibility, lifecycle status, and designation remain independent concepts.

A partial unique index on `(product_id) WHERE is_default` is the proposed database consequence of the all-lifecycle at-most-one rule, but cannot establish the Active Product's required existence or Active eligibility. The reviewed design therefore pairs it with a parent-locking deferred cross-row check using Active status and `is_default = true`, explicitly excluding visibility. These mechanisms, their migrations, and their concurrency behavior are not implemented or approved by the Owner decisions.

### CAT-REV-003 — The former deferred-trigger proposal allowed write-skew

**Severity:** `HIGH`

**Affected evidence:** `ODB-CAT-23`; Technical Design §§7.2, 8, 12.1, and 13.3; Data Integrity Rules §12

**Classification:** `TECHNICAL_PROPOSAL` correction

A deferred constraint trigger that only queries final state is insufficient. Consider an initially Inactive Product with one Active Default Variant:

1. transaction A activates the Product and observes the Variant as eligible;
2. transaction B deactivates that Variant and observes the Product as Inactive;
3. without a shared locked row, both observations can be individually valid and both transactions can commit an invalid combined state.

Deferred execution does not itself serialize these transactions. The trigger must cover relevant Product status changes and Variant insert/delete/update paths, lock every affected Product row `FOR UPDATE` in deterministic UUID order, and only then evaluate the final state. Application commands should continue Category → Product → UUID-sorted Variant locking.

Direct SQL Variant DML can obtain a child lock before its deferred trigger obtains the Product lock, which may deadlock with an application transaction already holding Product then Variant. PostgreSQL aborting one participant preserves integrity; the design must not claim deadlock freedom. A real two-connection test must prove both write-skew prevention and bounded failure behavior.

**Required action:** The design records the common-parent lock requirement and the now-confirmed predicate. Before any implementation authorization, prove insert/update/delete, multi-change, direct-SQL, lifecycle-change, and concurrent invalidation schedules against PostgreSQL 18.

### CAT-REV-004 — Category/Product lifecycle dependency resolved by `ODB-CAT-29`

**Status:** `RESOLVED_OWNER_CONFIRMED`

**Affected evidence:** `ODB-CAT-15`, `ODB-CAT-21`, `ODB-CAT-25`, `ODB-CAT-29`; Technical Design §§6–8 and 15

**Classification:** `OWNER_CONFIRMED`

The Owner confirmed two separate policies: a Product may transition to Active only when its assigned Category is Active, and a Category may not transition to Inactive while any Active Products remain assigned. Category Archive behavior with only Inactive Products remains separate. Product reassignment is unsupported in MVP under `ODB-CAT-41`; Category/Variant creation and transitions are closed by `ODB-CAT-30`–`ODB-CAT-32`.

Category Deactivation remains distinct from Category Archive under `ODB-CAT-25`, and both remain distinct from Branch-level Product availability under `ODB-CAT-06`. The technical design must serialize Product activation against Category Deactivation and preserve the separate Archive guard. Trigger shape, lock ordering, migration, commands, authorization enforcement, and concurrency tests remain `TECHNICAL_PROPOSAL` or unresolved technical work.

### CAT-REV-005 — Lifecycle creation and transition semantics resolved by `ODB-CAT-30`–`ODB-CAT-32`

**Severity:** `RESOLVED_BUSINESS_POLICY`

**Affected evidence:** `ODB-CAT-21`, `ODB-CAT-25`, `ODB-CAT-28`–`ODB-CAT-32`; Technical Design §§6, 12, and 15

**Classification:** `OWNER_CONFIRMED` business matrix; implementation remains `TECHNICAL_PROPOSAL`

Category and Variant are created Draft and share the exact Draft/Active/Inactive/Archived matrix in `ODB-CAT-32`. Both restore Archived→Inactive; direct Archived→Active and Draft→Inactive are prohibited. Existing guards from `ODB-CAT-25`, `ODB-CAT-28`, and `ODB-CAT-29` remain unchanged and no additional guards are inferred.

An Active Variant under a Draft or Inactive Product does not by itself make that Product sellable. Under `ODB-CAT-40`, Variant Archive/Restore changes status only and preserves `is_default` and `customer_visible`; the resulting Product invariant must be evaluated atomically. Product lifecycle commands are excluded from initial MVP under `ODB-CAT-39`.

**Required action:** revise the technical design to implement no more than the confirmed matrix, then prove command validation, authorization/audit, locking, direct-SQL protection, and concurrency behavior before implementation authorization.

### CAT-REV-006 — Branch evidence does not establish production readiness

**Severity:** `MEDIUM`

**Affected evidence:** Technical Design §§2.3, 11, 16, and 17

**Classification:** environment/data prerequisite

The local test evidence proves only that one disposable environment contains one orphan AuditEvent and no Orders. The development database is unprepared. No production data was inspected. Neither observation can identify real Organization/Brand/Branch ownership.

Adding a foreign key `NOT VALID` enforces future inserts/updates but preserves existing orphan rows until validation; it does not eliminate or repair them. Creating the Organization/Brand/Branch tables and synthetic test factories is separable from production mapping. Attaching and validating operational Branch FKs is not.

**Required action:** before target-environment FK validation, inventory distinct Branch UUIDs and all references, obtain authoritative Organization/Brand/Branch mapping, resolve every orphan explicitly, and separately validate constraints. Never infer Main Branch or rewrite history from local test evidence.

## 5. Lifecycle transition matrix

| Entity / action | Confirmed result or proposed behavior | Classification | Required closure |
|---|---|---|---|
| Product creation | Product may be Draft with zero Variants and zero Default. | `OWNER_CONFIRMED` (`ODB-CAT-19`) | None for the business state; command/audit remains technical. |
| Product Draft → Active | Assigned Category must be Active; Product has exactly one Active Variant with `is_default = true`; visibility is irrelevant to Default eligibility. | `OWNER_CONFIRMED` preconditions (`ODB-CAT-23`, `ODB-CAT-28`, `ODB-CAT-29`) | Technical locking/concurrency proof remains. |
| Product Archived → Inactive | Restore never auto-activates; Owner or explicit Owner delegate has authority. | `OWNER_CONFIRMED` (`ODB-CAT-24`, `ODB-CAT-33`) | Delegation/authorization mechanism remains technical. |
| Other Product transitions | Candidate command matrix only. | `UNRESOLVED_OWNER_DECISION` where business outcome/authority matters | Confirm or exclude. |
| Category creation | Draft. | `OWNER_CONFIRMED` (`ODB-CAT-30`) | Technical default/create command remains. |
| Category Deactivate | Blocked while any Active Products remain assigned; distinct from Archive and Branch availability. | `OWNER_CONFIRMED` (`ODB-CAT-25`, `ODB-CAT-29`) | Source-state matrix and technical locking/concurrency remain unresolved/proposed. |
| Category Archive | Draft/Active/Inactive→Archived allowed with existing guards; Active Products block Archive. | `OWNER_CONFIRMED` (`ODB-CAT-25`, `ODB-CAT-32`) | Technical enforcement remains. |
| Category restore | Archived→Inactive through Restore; later activation is separate. | `OWNER_CONFIRMED` (`ODB-CAT-32`) | Technical validation/command remains. |
| Variant creation | Draft; status/default/visibility remain independent. | `OWNER_CONFIRMED` (`ODB-CAT-31`) | Technical default/create command remains. |
| Variant Deactivate | Distinct Owner/delegate action; final state cannot leave an Active Product without exactly one Active Default. | Eligibility consequence `OWNER_CONFIRMED` (`ODB-CAT-28`) | Exact transition matrix, authority enforcement, audit, and concurrency mechanism remain unresolved/proposed. |
| Variant Archive | Draft/Active/Inactive→Archived allowed; blocked if final state would invalidate an Active Product Default. | `OWNER_CONFIRMED` (`ODB-CAT-25`, `ODB-CAT-28`, `ODB-CAT-32`) | Technical concurrency mechanism remains proposed. |
| Variant restore | Archived→Inactive through Restore; later activation separate. | `OWNER_CONFIRMED` (`ODB-CAT-32`) | Retained flags must be technically validated atomically. |
| Active Variant under non-Active Product | Does not independently make Product sellable. | `TECHNICAL_PROPOSAL` consistent with separate Product state | Confirm through lifecycle review if commands enter scope. |

## 6. Additional technical conclusions

### 6.1 Same-Brand enforcement

Repeated `brand_id` with composite foreign keys is repository-compatible and correctly prevents cross-Brand ancestry:

- `categories` supplies candidate key `(id, brand_id)`;
- `products(category_id, brand_id)` references `categories(id, brand_id)` and supplies `(id, brand_id)`; and
- `product_variants(product_id, brand_id)` references `products(id, brand_id)`.

Direct Brand foreign keys remain required. Column order must match the candidate keys. Rails may use ordinary single-column associations while PostgreSQL provides the composite backstop. Brand scope must be immutable through application commands; any direct attempted drift is rejected by the composite constraints. Rails 8.1/PostgreSQL 18 support the demonstrated migration pattern.

### 6.2 Lock ordering

Category → Product → UUID-sorted Variants is achievable for application commands and no existing Catalog operation contradicts it because no Catalog implementation exists. It can serialize Category lifecycle against Product activation when policy later requires that relationship. Database triggers can still enter through child-first direct SQL and must use deterministic parent locking; deadlock victim selection is a safety mechanism, not a correctness defect. Application-level locks alone do not protect direct SQL.

### 6.3 SKU interim boundary

`ODB-CAT-34` defers SKU support from Catalog Core MVP. Accepting no SKU input and, if a column exists, enforcing null is an MVP technical boundary; it must not choose future case, whitespace, Unicode, blank, or canonical equality semantics. Future SKU support requires a separate decision/design and reviewed migration.

### 6.4 Audit and authorization

Current AuditEvent persistence requires a non-null Branch and cannot honestly record Brand-global Catalog lifecycle actions without fabricating scope. Identity/Milestone 2B remains unauthorized. Brand-scoped audit representation, trusted authorization context, delegation expiry/revocation, and event taxonomy must be approved before lifecycle commands; persistence-only reference tables do not imply those commands.

### 6.5 Physical deletion

`ODB-CAT-35` selects lifecycle/Archive retention with no Soft Delete for Catalog Core MVP. `ODB-CAT-36` reserves Code/SKU after Archive or any future Soft Delete without authorizing Soft Delete. `ODB-CAT-37` prohibits Purge for Draft, Active, Inactive, and Archived Catalog records. Future policy changes require a separate Owner Decision; identifier reuse after hypothetical physical Draft deletion remains unspecified and irrelevant to the current no-Purge boundary.

## 7. Corrected implementation boundary

The six-entity foundation is not one safely separable unit. Subject to a future readiness review and explicit Owner authorization, only this narrower work can currently be considered independently:

1. Organization, Brand, and Branch persistence with UUID PKs, restrictive local FKs, names/timezone, and synthetic factories.
2. Read-only Branch-reference inventory/mapping support and tests; no mapping is inferred.
3. Application/test compatibility work replacing arbitrary Branch UUIDs with persisted Branch references.

Operational Branch FK validation requires authoritative target-environment mapping. Category/Product/Variant business predicates are closed, but persistence still waits for technical closure and explicit authorization. Activation, publication, Default switching, lifecycle commands, physical deletion, API, frontend, authorization, and Identity remain excluded; physical deletion is prohibited in MVP.

## 8. Review conclusions and required decisions

### Owner input status

No CAT-CLAR-01 through CAT-CLAR-09 MVP business answer remains open. Product lifecycle and reassignment are explicitly excluded from initial MVP by `ODB-CAT-39`/`41`; future capability requires separate decisions. Future SKU support, Soft Delete, or Purge likewise remains future scope.

### Technical revision or proof required

1. Implement only after authorization, then verify the named per-entity Code constraints and same-Brand composite FKs.
2. Prove the specified parent-locking deferred triggers for Active Default completeness and Category/Product final state; do not include `customer_visible`.
3. Prove final-state, direct-SQL, write-skew, deadlock, timeout, and whole-command retry behavior with PostgreSQL concurrency specs.
4. Review the proposed Brand-scoped AuditEvent expansion and trusted authorization context before lifecycle commands.
5. Prove runtime-role inability to bypass transition/final-state and append-only protections.
6. Inventory and map Branch references before validating operational FKs.
7. Preserve `ODB-CAT-39`–`ODB-CAT-41`; obtain new Owner input only if future scope proposes Product lifecycle commands or Category reassignment.

The original technical review created no Owner Decision. Later tasks recorded decisions through `ODB-CAT-41`; this document merely synchronizes them. Recommendations and enforcement mechanisms remain technical proposals.

## 9. Completion reassessment

The [Catalog Core Technical Design Completion Review](after_four_catalog_core_technical_design_completion_review.md) closes the documentation gap for all eight requested review areas:

| Area | Design result | Remaining evidence/blocker |
|---|---|---|
| Constraints/triggers/final state | Declarative constraints, transition guards, and two deferred final-state trigger families are specified. | Migration and direct-SQL proof absent. |
| Default concurrency | All-lifecycle designation uniqueness and Product serialization are specified. | Unique-index implementation and two-connection proof absent. |
| Locking/write-skew/deadlocks | Category → Product → UUID-sorted Variant order and safe deadlock-abort behavior are specified. | PostgreSQL 18 schedule/retry evidence absent. |
| Direct SQL | Constraint coverage and runtime-role boundary are explicit. | Production-like privilege evidence absent. |
| Brand audit | Checked Organization/Brand/Branch scope on one append-only AuditEvent representation is preferred. | Schema/security review and implementation absent. |
| Trusted authority | Immutable server-created context plus transactional delegation revalidation is specified. | Identity Milestone 2B remains unauthorized and unavailable. |
| Migration/error mapping | Phased Branch mapping and SQLSTATE/constraint-name taxonomy are specified. | Authoritative environment mapping absent. |
| Database tests | Command, direct-SQL, concurrency, migration/schema, and role layers are specified. | No Catalog test execution can exist before authorized implementation. |

The earlier `CAT-REV-003` design defect is remediated on paper, not closed by evidence. `CAT-REV-006` remains open. Overall verdict remains `NOT_READY`; no implementation authorization is implied.

## 10. Technical readiness reassessment addendum

The readiness reassessment preserves the prior findings and adds two concrete design corrections:

1. `ODB-CAT-37` requires a direct-SQL no-Purge backstop. Restrictive FKs and absence of an application delete command do not prevent deleting an otherwise unreferenced Catalog row. Proposed `BEFORE DELETE` guards plus runtime-role denial of `DELETE` remain unimplemented.
2. Existing AuditEvents cannot be updated during scope migration because the append-only database trigger rejects every update. The proposed scope migration must use a temporary constant `scope_kind = 'branch'` default and schema/check evolution without historical row updates.

The reassessment also confirms that `ODB-CAT-38` enforcement remains proposed. `ODB-CAT-39`–`ODB-CAT-41` resolve `CAT-TRR-002` for initial scope; future Product lifecycle/reassignment policy remains outside scope, while Variant flag preservation is confirmed.

See findings `CAT-TRR-001` through `CAT-TRR-009` in the [reassessment](after_four_catalog_core_technical_readiness_reassessment.md#10-findings-and-blockers). The review verdict remains `NOT_READY`.
