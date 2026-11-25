# AFTER FOUR — Catalog Core Technical Design Completion Review

**Review date:** 2026-11-15

**Review type:** Documentation-only technical design completion

**Design status:** `TECHNICAL_DESIGN_INCOMPLETE`

**Implementation readiness:** `NOT_READY`

**Implementation authorization:** Not granted

**Readiness reassessment:** 2026-11-15 ([technical readiness reassessment](after_four_catalog_core_technical_readiness_reassessment.md))

## 1. Executive summary

The Catalog Core business predicates and initial scope are closed through `ODB-CAT-41`, but the repository does not yet contain Catalog tables or executable evidence for their integrity and concurrency design. This review completes the remaining technical proposal at design level without treating it as implemented or proven.

The recommended database design uses declarative checks, separate Brand-scoped unique constraints, composite foreign keys, restrictive deletion, transition-guard triggers, and two deferred final-state constraint-trigger families. Application writes go through a small Catalog lifecycle command interface that hides transaction, lock, audit, and PostgreSQL error-mapping details. The shared lock order is Category → Product → UUID-sorted Variants. Direct SQL may enter child-first and deadlock with that order; PostgreSQL aborting one transaction is an expected safe failure, not proof of deadlock freedom.

`ODB-CAT-38` confirms that every Product has at most one Variant with `is_default = true`; Draft, Inactive, and Archived Products permit zero or one. For an Active Product, `ODB-CAT-28` additionally requires exactly one designated Variant and lifecycle status Active; `customer_visible` is excluded. A proposed partial unique index on all designated rows plus a parent-locking deferred trigger reflects these two predicates, but neither mechanism is implemented or proven.

Brand-global Catalog lifecycle events cannot use a fabricated Branch. The preferred audit design extends the append-only AuditEvent representation with an explicit, database-checked scope discriminator and one of Organization, Brand, or Branch identity. Trusted authorization must arrive from an authenticated server boundary and must be revalidated against current delegation state in the same transaction when delegation is used. Identity Milestone 2B remains unauthorized, so lifecycle commands remain blocked even though their technical seam is specified.

The verdict remains `NOT_READY`. Required evidence does not yet exist: no Catalog migrations or tests, no two-connection concurrency proof, no production-role bypass proof, no authoritative target-environment Branch mapping, and no implemented trusted authorization context. This report authorizes none of those changes.

## 2. Sources and evidence

This review inspected [AGENTS.md](../../AGENTS.md), [GLOSSARY.md](../../GLOSSARY.md), the [Owner Decision Baseline](../architecture/after_four_owner_decision_baseline.md), [Catalog Core Technical Design](../architecture/after_four_catalog_core_technical_design.md), [Technical Design Review](after_four_catalog_core_technical_design_review.md), [Implementation Readiness Review](after_four_catalog_core_implementation_readiness_review.md), [DDD Foundation](../architecture/after_four_ddd_foundation.md), [Business Domain Model](../architecture/after_four_business_domain_model.md), [State Machines](../architecture/after_four_state_machines.md), [ERD](../architecture/after_four_erd.md), [Data Dictionary](../architecture/after_four_data_dictionary.md), [Data Integrity Rules](../architecture/after_four_data_integrity_rules.md), and [API Contract](../architecture/after_four_api_contract.md).

Executable repository evidence inspected includes:

- `backend/db/migrate/20261114202000_enforce_payment_aggregate_integrity.rb`, which demonstrates pre-migration audits, named composite keys/FKs, deferred constraint triggers, and common-parent row locking;
- `backend/db/migrate/20261114203000_protect_audit_events_append_only.rb`, which rejects AuditEvent update/delete with SQLSTATE `23514` at database level;
- `backend/app/contexts/orders/application/use_cases/create_draft.rb`, which demonstrates whole-command transactions, atomic audit persistence, idempotency, and constraint-name error discrimination;
- `backend/app/contexts/trusted_actor.rb`, which validates only a server-provided UUID reference and is explicitly not authentication or authorization; and
- existing PostgreSQL integrity and multi-connection concurrency specs, which establish repository test patterns but do not prove the proposed Catalog behavior.

No application or database command was run for this documentation-only review.

## 3. Previous blockers and current status

| Previous issue | Owner-confirmed policy | Completion-review result | Status |
|---|---|---|---|
| Separate Code namespaces | `ODB-CAT-27` | Three full unique constraints, one per entity, on `(brand_id, code)`; archived rows remain covered. | `DESIGN_SPECIFIED` |
| Default eligibility | `ODB-CAT-23`, `ODB-CAT-28`, `ODB-CAT-38` | All-lifecycle designation uniqueness plus a parent-locking deferred Active final-state trigger. Visibility excluded. | `DESIGN_SPECIFIED_PENDING_PROOF` |
| Product/Category lifecycle dependency | `ODB-CAT-29` | Category-serialized deferred final-state validation covers Product activation and Category Deactivation. | `DESIGN_SPECIFIED_PENDING_PROOF` |
| Category/Variant lifecycle | `ODB-CAT-30`–`ODB-CAT-32` | Named transition commands mirrored by database `BEFORE UPDATE` transition guards. | `DESIGN_SPECIFIED_PENDING_PROOF` |
| Direct SQL integrity | Accepted database ADRs require DB backstops where appropriate. | Declarative constraints plus transition and deferred constraint triggers; database-role bypass remains operational evidence. | `DESIGN_SPECIFIED_PENDING_PROOF` |
| Brand-global audit | State changes require audit, but no fake Branch is allowed. | Extend one append-only AuditEvent model with checked scope identity; do not use polymorphic scope without FKs. | `DESIGN_SPECIFIED_PENDING_SECURITY_REVIEW` |
| Trusted authority/delegation | Owner or explicit Owner delegate for confirmed lifecycle actions. | Trusted immutable authorization context plus same-transaction delegation revalidation; no client actor/capability claims. | `BLOCKED_BY_IDENTITY` |
| Branch migration | Existing UUIDs must not be guessed or rewritten. | Phased inventory/mapping/compatibility/`NOT VALID`/validation sequence and explicit error taxonomy. | `BLOCKED_BY_ENVIRONMENT_EVIDENCE` |

Business clarification closure is not implementation evidence. Every mechanism above remains a `TECHNICAL_PROPOSAL`.

## 4. Detailed technical decisions and trade-offs

### 4.1 Database constraints, triggers, and final-state integrity

**Unresolved question:** Which invariants must survive Rails-validation bypass and which PostgreSQL mechanism checks each one without rejecting valid temporary states inside a transaction?

**Owner-confirmed policy:** same-Brand ancestry (`ODB-CAT-15`); separate Code namespaces (`ODB-CAT-27`); Category/Variant transition matrix (`ODB-CAT-30`–`32`); Active Category dependency (`ODB-CAT-29`); all-lifecycle Default cardinality and Active completeness (`ODB-CAT-23`, `28`, `38`); no Purge (`ODB-CAT-35`–`37`).

**Technical proposal:**

1. Use ordinary named checks for canonical Code, nonblank names, allowed lifecycle values, nonnegative position, and the MVP `sku IS NULL` boundary.
2. Use full unique indexes on `(brand_id, code)` separately for Category, Product, and Variant.
3. Use direct Brand FKs plus composite FKs `(category_id, brand_id) → categories(id, brand_id)` and `(product_id, brand_id) → products(id, brand_id)`.
4. Use `BEFORE UPDATE OF lifecycle_status` transition guards for Category and Variant. Raise SQLSTATE `23514` and set a stable constraint identifier so direct SQL cannot bypass the confirmed transition matrix.
5. Use `DEFERRABLE INITIALLY DEFERRED` row-level constraint triggers for cross-row final-state predicates. Temporary invalid states are allowed within one transaction, but invalid commit state is rejected.
6. Keep restrictive FKs and expose no physical delete command. Database table owners/superusers can still disable triggers, so production-role separation is a required operational control rather than a schema claim.
7. Because `ODB-CAT-37` also prohibits deletion of an unreferenced Catalog row, propose `BEFORE DELETE` guards on all three Catalog tables and deny `DELETE` to the runtime role. This remains unimplemented.

**Alternatives:** application-only validation is simpler but cannot protect direct SQL; an immutable event-sourced Catalog would change the repository architecture without evidence; immediate cross-row triggers reject legitimate multi-step transactions.

**Failure modes:** missing trigger events, trigger recursion, inconsistent OLD/NEW parent handling, superuser bypass, long parent-lock waits, and migration installation over invalid data.

**New Owner decision:** none for the confirmed predicates. Remaining Product transition policies still require Owner input before corresponding commands can be exposed.

**Validation:** direct SQL tests for every insert/update/delete event, multi-row changes in one transaction, `SET CONSTRAINTS ALL IMMEDIATE`, migration preflight audits, structure dump/load, and runtime-role attempts to mutate/disable protected objects.

### 4.2 Default Variant integrity and concurrent changes

**Unresolved question:** How can PostgreSQL guarantee the Active Product final state without conflating `is_default`, lifecycle status, and customer visibility?

**Owner-confirmed policy:** every Product has at most one Variant with `is_default = true`; Draft, Inactive, and Archived Products permit zero or one. An Active Product has exactly one and that Variant is Active. A hidden Active Variant is eligible (`ODB-CAT-23`, `ODB-CAT-28`, `ODB-CAT-38`).

**Technical proposal:**

- Propose `uq_product_variants_one_default` on `(product_id)` where `is_default`, implementing the confirmed at-most-one designation across every Product lifecycle state.
- Add deferred constraint trigger `catalog_active_product_default_valid` on Product insert/status change and Variant insert/delete/change of `product_id`, `lifecycle_status`, or `is_default`.
- The trigger collects OLD and NEW Product IDs, sorts them by UUID, locks each Product `FOR UPDATE`, and asserts exactly one eligible row only when that Product's final status is Active.
- A named switch command locks Product first, then current/proposed Variants in UUID order, validates Product/Brand ownership, and requires the proposed Variant to be Active only when the Product is Active. It clears the prior designation, sets the new designation, appends one audit event, and commits once. No additional Variant-status rule is inferred for non-Active Products.

This partial index is the proposed database consequence of `ODB-CAT-38`. It enforces only at-most-one designation; the deferred trigger remains necessary to enforce existence and Active status when the Product is Active.

**Failure modes:** an Active Product with zero eligible Defaults; duplicate designation in any Product state; Product activation racing Variant deactivation/archive; moving a Variant between Products; and retry duplicating an AuditEvent.

**New Owner decision:** none for Default cardinality; `ODB-CAT-38` closes it. Remaining Product lifecycle operations and authorization outcomes must still not be inferred.

**Validation:** deterministic two-connection races for activation versus invalidation and two Default switches; hidden Default success; inactive/archived designated failure; direct SQL zero/two eligible rows; multi-change commit success; and single audit identity across whole-command retry.

### 4.3 Lock ordering, write-skew, deadlocks, and concurrency proof

**Unresolved question:** Which common rows serialize dependent state changes, and what behavior is safe when direct SQL has already locked a child first?

**Technical proposal:** every application command uses Category → Product → affected Variants sorted by UUID. A Product/Variant final-state trigger locks affected Products sorted by UUID. A Category/Product trigger locks the Category, then affected Products sorted by UUID before evaluating final state.

The Category row is the common serialization point for Product activation versus Category Deactivation. The Product row is the common serialization point for Active completeness and Default switching. The narrow Catalog lifecycle command module is the only application write interface; it hides lock helpers and PostgreSQL retry details rather than exposing a generic repository API.

Direct child SQL necessarily starts child-first. If it later requests the parent while an application transaction holds parent-first and requests the child, PostgreSQL can detect a deadlock and abort one transaction. The invariant is preserved. Only a bounded whole-command retry may follow SQLSTATE `40P01` or `40001`; code must not rescue and continue inside the aborted transaction. Lock/statement timeout behavior is mapped to a stable concurrency/timeout result and is not silently retried forever.

**Trade-off:** parent serialization limits concurrency for changes to one aggregate but avoids Serializable isolation for unrelated Brands/Products. Serializable isolation remains a viable alternative for selected commands but adds retry frequency and does not replace declarative integrity.

**New Owner decision:** none. Retry bounds and operational timeouts are technical configuration subject to deployment validation.

**Validation:** real PostgreSQL connections, transactional fixtures disabled, deterministic barriers, bounded timeouts, captured SQLSTATEs, repeated randomized runs, and explicit proof that every committed final state is valid even when one transaction aborts.

### 4.4 Direct SQL integrity protection

**Unresolved question:** What remains true when callbacks, model validations, and named commands are bypassed?

**Technical proposal:** direct SQL is constrained by allowed-value/canonical checks, full/partial uniqueness, direct/composite FKs, transition guards, deferred final-state triggers, restrictive deletes, and AuditEvent append-only protection. `lock_version`, authorization, reason text, semantic idempotency, and friendly error messages remain command responsibilities and must not be misrepresented as database guarantees.

PostgreSQL cannot protect against its table owner, superuser, disabled triggers, or uncontrolled migration role. Production must separate migration ownership from the least-privilege runtime role and test that the runtime role cannot alter/disable triggers, truncate protected tables, or mutate AuditEvent history.

**New Owner decision:** none. Production role topology remains an operational/security review dependency.

**Validation:** a constraint-by-constraint direct SQL matrix plus a deployment-role privilege test in a production-like environment.

### 4.5 Brand-scoped AuditEvent representation

**Unresolved question:** How should a Brand-global Catalog event be recorded without inventing a Branch scope or weakening referential integrity?

**Technical proposal:** retain one append-only `audit_events` table and add explicit scope identity:

- `scope_kind` constrained to `organization`, `brand`, or `branch`;
- nullable `organization_id`, `brand_id`, and existing `branch_id` with a check requiring exactly the column matching `scope_kind`;
- restrictive FKs for every populated scope column;
- event actor, subject, target Brand, capability key, delegation identity when available, reason, correlation/request ID, command identity, redacted prior/next state, outcome, and occurrence time; and
- the existing database update/delete rejection trigger retained.

Existing rows remain `branch` scoped through their existing non-null `branch_id` and the temporary constant scope default; they are not updated and no Brand is inferred until the Branch mapping is authoritative. Catalog lifecycle events use Brand scope. Organization/Brand/Branch hierarchy may be derived through FKs rather than redundantly storing every ancestor.

The existing append-only trigger forbids an ordinary update-based backfill. The safe proposal adds `scope_kind` with a temporary constant `branch` default, validates the scope shape without changing historical rows, removes the default for new explicit writers, and changes `branch_id` nullability only after compatibility. This sequence remains unexecuted.

**Alternatives:** a separate `catalog_audit_events` table provides stronger local typing but duplicates access, export, retention, and integrity machinery; generic `scope_type/scope_id` is flexible but loses FKs and is not recommended.

**Failure modes:** scope-column mismatch, fake Branch use, sensitive before/after payloads, mutable audit history, orphan delegation references, and changing scope semantics during migration.

**New Owner decision:** none for Brand-scoped recording because Brand-global ownership and required audit already exist. Audit reader access, retention/export/legal hold, and privacy remain separately unresolved governance/security matters.

**Validation:** scope-check/FK direct SQL tests, append-only tests after schema expansion, rollback when audit insert fails, redaction tests, access-control tests after Identity implementation, and historical-row migration audit.

### 4.6 Trusted authorization and Owner delegation representation

**Unresolved question:** What may the Catalog command trust, and how is delegation revocation prevented from racing a state change?

**Technical proposal:** the future authenticated server boundary constructs an immutable `Catalog::AuthorizationContext`; clients cannot submit actor, capability, Brand scope, or delegation claims as authoritative fields. Minimum content is actor user ID, Organization ID, target Brand scope, effective capability key, optional delegation ID, correlation/request ID, and authentication time/strength where step-up is required.

The Catalog lifecycle command interface accepts this context and a reason/idempotency identity, then validates the exact capability and target Brand. When delegation is used, the same database transaction locks or version-checks the authoritative delegation row and verifies current scope, expiry, revocation, and non-self-approval rules before state change and audit append. A UUID-format actor check such as current `TrustedActor` is only a reference check and cannot satisfy this seam.

**Alternatives:** role-name checks inside Catalog couple the module to an unapproved hierarchy; a signed authorization snapshot avoids a lookup but requires expiry/revocation/version semantics and is not justified before Identity design exists.

**Failure modes:** stale context after revocation, confused deputy across Brands, client-supplied actor UUID, delegate self-approval, audit actor mismatch, and authorization succeeding outside the state-change transaction.

**New Owner decision:** no new Catalog policy decision. Existing Identity/delegation decisions and unresolved authority policies remain controlling. Identity Milestone 2B is not authorized.

**Validation:** positive and negative capability tests, cross-Brand denial, revoked/expired delegation races, actor/audit equality, self-approval denial, and rollback of both state and audit on any authorization failure.

### 4.7 Migration ordering, existing Branch mapping, and error mapping

**Unresolved question:** How can reference identities and constraints be introduced without guessing historical Branch ownership or returning unstable database errors?

**Technical proposal:**

1. Inventory each target environment and produce a reviewed mapping artifact for every distinct Branch UUID and orphan reference.
2. Create Organization, Brand, and Branch reference tables and local constraints.
3. Insert only approved mappings, preserving valid existing Branch UUIDs as primary keys.
4. Update writers/tests to use persisted Branches.
5. Expand AuditEvent scope without inferring Brand for historical rows.
6. Add operational Branch FKs `NOT VALID`, then validate them separately after approved orphan resolution.
7. Create empty Catalog tables with declarative local constraints/composite FKs.
8. Install transition and final-state triggers only after preflight queries pass; new empty Catalog tables avoid legacy Catalog backfill ambiguity.
9. Dump and reload `structure.sql`; deploy application behavior only in a later authorized change.

Constraint names form the error contract. Proposed mapping is: `23505` plus known name → duplicate Code or Default conflict; `23503` → invalid parent/reference or referenced-resource protection; `23514` plus known name → validation/state-transition/final-state violation; `40P01`/`40001` → bounded whole-command retry then stable concurrency error; `55P03` → busy/concurrent modification; `57014` → operation timeout. Unknown constraint names and SQLSTATEs are re-raised and logged with request correlation, never collapsed into a misleading validation result.

**Failure modes:** mapping Main Branch by assumption, merging UUIDs, deleting orphan audit history, long FK validation locks, deploying new FK before compatible writers, and swallowing an unrelated unique violation.

**New Owner decision:** authoritative Branch mapping/remediation is required where repository evidence cannot identify ownership. This is environment-specific Owner/operational input, not a new Catalog business rule.

**Validation:** read-only inventories, approved mapping checksum, pre/post row counts, `NOT VALID` behavior test, separate `VALIDATE CONSTRAINT`, migration rollback on empty environments, roll-forward plan after data exists, and constraint-name error specs.

### 4.8 Database-level test strategy

**Unresolved question:** What evidence is sufficient to distinguish model behavior from PostgreSQL protection and concurrency safety?

**Technical proposal:** use four layers:

1. command specs through the small Catalog lifecycle interface with real records and whole-transaction audit rollback;
2. PostgreSQL integration specs that use direct SQL/`update_all` to bypass Rails validation and force deferred checks immediate;
3. non-transactional multi-connection specs with deterministic barriers for write-skew/deadlock schedules; and
4. migration/schema/role tests covering preflight, `structure.sql` round-trip, runtime privileges, and fresh/upgrade paths.

Factories create explicit Organization → Brand → Branch → Category → Product relationships and default to Draft/nonpublished states. They do not seed the proposed menu. Concurrency examples own and clean their records without disabling append-only protection through the runtime role.

**Failure modes:** transactional fixtures hiding commit-time errors, thread scheduling flakiness, tests asserting Rails validation rather than constraint identity, cleanup requiring forbidden AuditEvent deletion, and a fresh database passing while an upgrade path fails.

**New Owner decision:** none.

**Validation:** every invariant has a positive, negative, boundary, direct-SQL, and where applicable concurrent case; individual and randomized full-suite runs produce the same result.

## 5. Remaining Owner decisions

The completion review does not reopen `ODB-CAT-01` through `ODB-CAT-41`. These items remain future or beyond the closed initial MVP rules:

1. Product lifecycle transitions and authority only if a future separately approved scope includes them; initial commands are excluded by `ODB-CAT-39`.
2. Any future Product Category reassignment capability; MVP expressly provides none under `ODB-CAT-41`.
3. Future SKU normalization/equality and any future Soft Delete or Purge policy.
4. Authoritative target-environment Organization/Brand/Branch mapping and explicit disposition of unmapped UUIDs.

Audit retention, privacy, export, legal hold, reader access, and legal compliance remain security/legal governance questions. Owner risk acceptance cannot manufacture legal compliance.

## 6. Migration and Branch mapping risks

The repository has unconstrained Branch UUIDs and local test residue, not authoritative production ownership data. A local UUID is not evidence that it represents Main Branch. `NOT VALID` protects new writes but intentionally leaves old violations until validation; it is a migration tool, not remediation.

The highest-risk sequence errors are attaching FKs before compatible writers, merging historical UUIDs without authority, making existing AuditEvents Brand scoped by guess, installing triggers over invalid rows, and using destructive rollback after reference rows exist. Once data exists, remediation is roll-forward and audited. Migration lock and statement timeouts must be explicit and FK validation separated from table creation.

## 7. Database integrity and concurrency validation strategy

| Invariant | Database evidence | Concurrency evidence | Required outcome |
|---|---|---|---|
| Same-Brand ancestry | Direct SQL composite-FK violations | Competing parent/scope mutation | No cross-Brand commit. |
| Separate Code namespaces | Constraint-name tests for all three tables | Same Brand/type duplicate race | One winner; cross-type and cross-Brand reuse allowed. |
| Category/Variant transitions | Every allowed/prohibited OLD→NEW pair via direct SQL | Archive/restore versus dependent command | Only confirmed transitions commit. |
| Active Category dependency | Deferred final-state checks | Product activation versus Category Deactivation | Never Active Product under Inactive Category. |
| Default designation and Active completeness | All-designation partial index and deferred trigger | Duplicate designation, activation/invalidation, and competing switch schedules | Every Product has at most one designation; Active commits with exactly one Active designated Default. |
| Audit atomicity | Failing audit insert | Whole-command retry/deadlock | State and audit commit together; one semantic event. |
| Append-only audit | Direct update/delete rejection | Concurrent reader/writer where relevant | No runtime mutation/deletion. |
| No physical deletion | Restrictive FKs/no delete interface | Reference creation versus attempted delete | No Catalog row purged. |

Passing application specs alone is insufficient. The evidence package must record PostgreSQL version, migration version, runtime role, connection/isolation settings, timeouts, repetitions, observed SQLSTATE/constraint names, and final database state.

## 8. Explicit implementation readiness verdict

### `NOT_READY`

The technical mechanisms are now specified sufficiently for a future implementation proposal and focused review, but they are not implemented, authorized, or validated. Readiness remains blocked by:

1. absent Catalog migrations and database test evidence;
2. absent two-connection proof for write-skew, deadlock, timeout, and retry behavior;
3. absent Brand-scoped AuditEvent implementation/security review;
4. absent trusted Identity authorization/delegation context, with Milestone 2B still unauthorized;
5. absent authoritative target-environment Branch mapping and orphan disposition; and
6. absent production-like runtime-role and migration-path evidence.

The [technical readiness reassessment](after_four_catalog_core_technical_readiness_reassessment.md) additionally records the no-Purge and AuditEvent migration gaps and assigns owners/resolution criteria. Its verdict remains `NOT_READY`.

No Catalog implementation, Identity work, schema/database change, or authorization follows from this review.
