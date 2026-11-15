# AFTER FOUR — Catalog Core Technical Readiness Reassessment

**Review date:** 2026-11-15

**Assessment type:** Documentation-only technical readiness reassessment

**Readiness verdict:** `NOT_READY`

**Implementation authorization:** Not granted

## 1. Executive summary

Owner Decisions `ODB-CAT-01` through `ODB-CAT-41` are internally consistent across the reviewed Catalog documents. `ODB-CAT-39` excludes Product lifecycle commands from initial MVP, `ODB-CAT-40` preserves Variant configuration flags through Archive/Restore, and `ODB-CAT-41` excludes Product Category reassignment. These decisions close the former initial-scope policy gap without implementing any mechanism or authorizing implementation.

The proposed PostgreSQL design is directionally implementable: full Brand-scoped Code indexes, repeated Brand keys with composite foreign keys, a partial unique Default index, lifecycle transition guards, and parent-locking deferred final-state triggers each have a clear responsibility. The Category → Product → UUID-sorted Variant application lock order is coherent. Parent-row locking provides a convincing safety argument against the identified write-skew schedules, while direct child SQL may deadlock and safely abort one participant.

The design is not ready to be presented for a full Catalog Core implementation authorization. Authoritative target-environment Branch mapping does not exist. Included Category/Variant lifecycle commands depend on trusted Identity authorization and Brand-scoped audit support that are not implemented and cannot be included under the current Identity Milestone 2B boundary. No executable Catalog constraint, concurrency, migration, audit, authorization, or database-role evidence exists.

Two additional technical gaps were found. First, restrictive foreign keys and absence of an application delete command do not prevent direct SQL deletion of an otherwise unreferenced Catalog record, contrary to `ODB-CAT-37`; the design now proposes both runtime-role denial of `DELETE` and a database `BEFORE DELETE` guard. Second, the current append-only AuditEvent trigger rejects row updates, so historical scope migration must not rely on an ordinary backfill update; the design now proposes a metadata-only/default-based expansion sequence that preserves existing Branch-scoped rows without mutating them.

The appropriate next step is not an implementation authorization request. The initial-scope Owner policy ambiguity is closed by `ODB-CAT-39`–`ODB-CAT-41`, but the technical/operational evidence owners must still close the blockers in §10. A separately bounded Organization/Brand/Branch reference-foundation request could be considered later, but this reassessment does not authorize it.

## 2. Scope, sources, and evidence boundary

Reviewed sources:

- [AGENTS.md](../../AGENTS.md) and [GLOSSARY.md](../../GLOSSARY.md).
- [Owner Decision Baseline](../architecture/after_four_owner_decision_baseline.md), including `ODB-CAT-01` through `ODB-CAT-41` and `ODB-DATA-01`.
- [Catalog Core Technical Design](../architecture/after_four_catalog_core_technical_design.md).
- [Catalog Core Technical Design Review](after_four_catalog_core_technical_design_review.md).
- [Catalog Core Technical Design Completion Review](after_four_catalog_core_technical_design_completion_review.md).
- [Catalog Core Implementation Readiness Review](after_four_catalog_core_implementation_readiness_review.md).
- [DDD Foundation](../architecture/after_four_ddd_foundation.md), [Business Domain Model](../architecture/after_four_business_domain_model.md), [State Machines](../architecture/after_four_state_machines.md), [ERD](../architecture/after_four_erd.md), [Data Dictionary](../architecture/after_four_data_dictionary.md), [Data Integrity Rules](../architecture/after_four_data_integrity_rules.md), [API Contract](../architecture/after_four_api_contract.md), and [Catalog/Pricing Discovery](../architecture/after_four_catalog_pricing_discovery.md).
- Accepted ADRs `0001`, `0003`, `0004`, `0005`, `0007`, `0009`, and `0010`.
- Existing repository conventions demonstrated by the Order/Payment composite-FK, deferred-trigger, append-only AuditEvent, command transaction, and multi-connection spec implementations.

No Catalog implementation exists. No application test, database command, migration, concurrency experiment, target-environment inventory, or role-permission test was executed in this reassessment. Every runtime result below is therefore a required future evidence item, not a passed check.

## 3. Readiness verdict and rationale

### `NOT_READY`

The design is not sufficiently closed for a full Catalog Core Owner implementation authorization review because:

1. target-environment Organization/Brand/Branch mapping and orphan disposition are absent;
2. trusted Identity authorization/delegation and Brand-scoped audit are unavailable for lifecycle commands;
3. included Category/Variant lifecycle commands still lack trusted authorization and audit providers;
4. no executable proof exists for deferred final-state triggers, direct-SQL protection, write-skew prevention, deadlock handling, audit atomicity, migration safety, or runtime-role restrictions; and
5. the newly identified no-Purge and AuditEvent migration mechanisms require review and later validation.

This verdict does not reject the proposed architecture. It distinguishes a reviewable design direction from authorization-ready scope and evidence.

## 4. ODB-CAT-01 through ODB-CAT-41 consistency

| Decision group | Consistency result | Technical consequence / boundary |
|---|---|---|
| `ODB-CAT-01`–`13` identity, pricing, availability, menu boundary | `CONSISTENT` | Product remains Brand-global. Branch availability and Price are separate future concerns; no proposed menu rows become approved data. |
| `ODB-CAT-14`–`18`, `22`, `27`, `34`, `36` hierarchy and identifiers | `CONSISTENT` | Multiple Organization/Brand rows, separate same-type Brand Code namespaces, canonical Code storage, retained identifiers, and no MVP SKU input. |
| `ODB-CAT-19`, `23`, `28`, `31`, `38` Product/Variant completeness | `CONSISTENT` | Every Product has at most one designation; Draft/Inactive/Archived allow zero or one; Active requires exactly one Active designated Variant; visibility is independent. |
| `ODB-CAT-21`, `25`, `29`–`32` Category/Variant lifecycle | `CONSISTENT` | Draft creation and exact transitions are closed; Active Category and dependency guards remain separate from Branch availability. |
| `ODB-CAT-03`, `24`, `33`, `39` Product lifecycle | `CONSISTENT_SCOPE_EXCLUSION` | Lifecycle values/future Restore policy remain documented, but every Product lifecycle command/API is excluded from initial MVP. Future policy remains unresolved without blocking the excluded scope. |
| `ODB-CAT-40` Variant Archive/Restore flags | `CONSISTENT` | Archive/Restore changes status only, preserves `is_default` and `customer_visible`, restores to Inactive, and requires separate activation. |
| `ODB-CAT-41` Product Category assignment | `CONSISTENT` | Product stays with its original Category in MVP; reassignment is unsupported and proposed database immutability remains unimplemented. |
| `ODB-CAT-35`–`37`, `ODB-DATA-01` retention | `CONSISTENT_WITH_TECHNICAL_GAP` | Lifecycle/Archive retention and no MVP Purge are clear; direct-SQL deletion denial was not fully specified before this reassessment. |

No reviewed technical proposal contradicts an Owner-confirmed decision after synchronization through `ODB-CAT-41`. Technical mechanisms remain proposals and are not promoted to Owner policy.

## 5. Invariant-to-enforcement matrix

| Invariant | Owner authority | Proposed PostgreSQL responsibility | Transaction/application responsibility | Failure behavior | Concurrency assessment | Evidence required |
|---|---|---|---|---|---|---|
| Same-type Catalog Code unique within Brand | `ODB-CAT-16`, `22`, `27` | Full unique `(brand_id, code)` on each entity; canonical-format check | Canonicalize before persistence; map known constraint name | `23505` for duplicate; `23514` for noncanonical direct write | Unique index serializes duplicate races | Direct SQL and two-writer duplicate specs for all three tables |
| Product/Category and Variant/Product same Brand | `ODB-CAT-15` plus Brand-global ownership | Repeated `brand_id`, unique parent `(id, brand_id)`, composite FKs | Resolve trusted Brand scope; prohibit cross-Brand moves | `23503`; whole transaction aborts | FK protects concurrent parent/child writes; scope immutability still needs proof | Direct SQL cross-Brand insert/update and concurrent parent-scope attempts |
| At most one designated Default in every Product state | `ODB-CAT-38` | Partial unique `(product_id) WHERE is_default` | Clear prior designation before setting another; map named conflict | `23505`; one concurrent writer loses | Covers Draft, Inactive, Archived, and Active; no write-skew gap for duplicate designation | Four-state direct SQL matrix and concurrent competing designation spec |
| Active Product has exactly one Active designated Variant | `ODB-CAT-23`, `28`, `38` | Deferred Product/Variant constraint triggers; lock Product; count final Active designated row; visibility excluded | Product-first locks; activation/default/lifecycle command validates same predicate | `23514` at constraint check/commit; entire command rolls back | Common Product lock closes activation/invalidation write-skew; child-first direct SQL may deadlock and abort safely | All trigger events, multi-change transactions, forced-immediate checks, activation/deactivation and switch races |
| Active Product references Active Category | `ODB-CAT-29` | Deferred Product/Category final-state trigger | Category → Product lock order | `23514`; transaction rolls back | Common Category lock serializes Category/Product race | Product activation versus Category deactivation/archive schedules |
| Category Deactivation/Archive guard | `ODB-CAT-25`, `29`, `32` | Same Category/Product trigger evaluates final state after any relevant Category status change | Lock Category then assigned Products in UUID order | Invalid final state rejected at commit | Direct Product-first SQL can deadlock; one abort must preserve invariant | Deactivate/archive versus Product activation, including multi-product final state |
| Variant Deactivation/Archive guard | `ODB-CAT-25`, `28`, `32`, `38` | Active-completeness trigger plus all-state unique index | Lock Product then affected Variants | Invalid Active Product final state rejected | Product lock closes write-skew | Default Variant deactivate/archive versus replacement/activation schedules |
| Category/Variant transition matrix | `ODB-CAT-30`–`32` | Allowed-value checks plus `BEFORE UPDATE` transition guards | Named commands only | `23514` for prohibited transition | Per-row update serialization; aggregate guards still separate | Every OLD→NEW pair through direct SQL and command boundary |
| No Catalog Purge | `ODB-CAT-35`–`37` | Proposed `BEFORE DELETE` guard on Category/Product/Variant plus runtime role without `DELETE`; restrictive FKs remain defense-in-depth | Expose no delete command/job/default scope | `23514` or privilege denial | Direct concurrent delete is rejected before dependency races matter | Direct SQL delete for every state, runtime-role privilege test, migration-owner exception procedure |
| Append-only lifecycle audit | `ODB-CAT-25`, `33`; audit governance | Existing update/delete rejection; proposed checked Brand scope | State mutation and audit insert in one transaction | Audit failure rolls back state; mutation denied | Command retry must retain one semantic audit identity | Forced audit insert failure, idempotent retry, direct update/delete, role tests |

The partial unique Default index is immediate and deliberately covers every Product state. The deferred trigger is separate: it enforces required existence and Active eligibility only for Active Products. This separation exactly preserves `ODB-CAT-38` and `ODB-CAT-28`.

## 6. Locking and concurrency analysis

### 6.1 Application lock order

The proposed order is coherent:

1. Category when Category/Product compatibility is relevant.
2. Product.
3. Affected Variants sorted by UUID.

Default-only work does not acquire an unnecessary Category lock. Commands must centralize this protocol rather than expose independent lock helpers.

### 6.2 Required transaction scenarios

| Scenario | Safety argument | Expected result | Evidence status |
|---|---|---|---|
| Two Default designations on Draft/Inactive/Archived/Active Product | Immediate partial unique index serializes the same `product_id` key | One commits; one receives named unique violation | Proposed only |
| Product activation versus Default Variant deactivation/archive | Both deferred checks lock the Product before final count | One valid final state commits; invalid participant aborts | Proposed only |
| Product activation versus Category Deactivation/Archive | Category is common lock; application path is Category-first | Active Product never commits under non-Active Category | Proposed only |
| Two multi-Variant Default switches | Product lock serializes final-state change; index prevents duplicate designation | One ordering wins; no committed zero/two state for Active Product | Proposed only |
| Direct Variant SQL versus Product-first command | Direct SQL may hold child then request Product | PostgreSQL may report `40P01`; one whole transaction aborts, invariant survives | Proposed only |
| Direct Product SQL versus Category-first command | Direct SQL may hold Product then request Category | Deadlock victim abort is acceptable; retry begins a new transaction | Proposed only |
| Same-Brand Product reassignment | `ODB-CAT-41` makes it unsupported in MVP | No command/API; direct SQL must meet the proposed immutability guard | Owner policy closed; enforcement unimplemented |

A lock-order statement is not proof. Future tests must use separate PostgreSQL connections, deterministic barriers, bounded lock/statement timeouts, captured SQLSTATEs, and final-state assertions. `40P01` and `40001` may be retried only around the entire idempotent command. An aborted PostgreSQL transaction cannot be continued.

## 7. Audit and authorization analysis

The proposed Brand-scoped AuditEvent representation is appropriate for Brand-global Catalog actions and avoids fake Branch scope. One checked scope discriminator with restrictive Organization/Brand/Branch FKs is preferable to an unconstrained polymorphic scope.

The existing AuditEvent database trigger rejects every row `UPDATE` and `DELETE`. Therefore an ordinary data-backfill update setting historical `scope_kind = 'branch'` would fail. The safe proposed sequence is:

1. add nullable Organization/Brand scope columns;
2. add `scope_kind` with a temporary constant database default of `branch`, so existing rows read as Branch scoped without an AuditEvent update;
3. add and validate the scope-shape check while every existing row retains its current non-null `branch_id`;
4. remove the temporary default so new writers must provide explicit scope;
5. relax `branch_id` nullability only after Brand-scoped writers are compatible; and
6. add/validate scope FKs according to the authoritative mapping sequence, without mutating historical AuditEvents.

This remains a proposal and requires PostgreSQL migration proof. Migration owners retain exceptional DDL authority, but the runtime role must not disable the append-only trigger.

Catalog commands cannot trust client-supplied actor, Brand, capability, or delegation values. The proposed immutable server-created authorization context is sound, but no authenticated producer exists because Identity Milestone 2B remains unauthorized. When delegation is used, current scope, expiry, revocation, and non-self-approval must be revalidated against authoritative state in the same transaction before mutation and audit insertion. Authorization or audit failure rolls back the entire command.

Direct SQL by the least-privilege runtime role must be unable to bypass required state/audit commands. Privileged migration/table-owner access cannot be made cryptographically impossible inside the same database; it must be restricted, logged, and operationally controlled. No such role evidence exists yet.

## 8. Migration and operational evidence gaps

The safe sequence remains expand/migrate/validate/contract:

1. read-only inventory of every Branch-bearing table in each target environment;
2. authoritative Organization/Brand/Branch mapping for every distinct UUID and explicit orphan disposition;
3. reference-table creation and approved rows preserving valid Branch UUIDs;
4. compatible application/test writers using persisted Branches;
5. AuditEvent scope expansion using the no-row-update sequence in §7;
6. operational Branch FKs added `NOT VALID` and validated separately;
7. empty Catalog tables and declarative constraints;
8. transition/no-delete/final-state triggers only after preflight and separate authorization;
9. `structure.sql` dump/load and migration-path validation; and
10. application behavior deployed only in a later authorized step.

Missing operational evidence:

- target-environment row counts, distinct Branch UUIDs, and orphan lists;
- approved mapping and checksum/review record;
- production CPU/memory/process topology where lock/timeout settings will operate;
- runtime, migration-owner, and break-glass database role grants;
- deployment ordering, lock/statement timeout values, monitoring, and rollback/roll-forward runbook; and
- observability for constraint names, SQLSTATEs, deadlocks, lock timeouts, trigger failures, audit failures, and migration validation duration.

No production database access is assumed. The local test residue described in earlier reviews is not production evidence.

## 9. Test and validation evidence matrix

| Evidence area | Proposed method | Acceptance evidence | Current state |
|---|---|---|---|
| Declarative constraints | Direct SQL bypassing Active Record | Named constraint and expected SQLSTATE for positive/negative/boundary cases | `NOT_EXECUTED` |
| Deferred final-state enforcement | Multi-change transaction plus `SET CONSTRAINTS ALL IMMEDIATE` and commit checks | Valid temporary states commit only when final state is valid | `NOT_EXECUTED` |
| ODB-CAT-38 all-state uniqueness | Direct and concurrent duplicate designation for all four Product states | One designation maximum for Draft/Inactive/Archived/Active | `NOT_EXECUTED` |
| Write-skew prevention | Two connections with deterministic barriers | No invalid combined state commits | `NOT_EXECUTED` |
| Deadlock/retry | Forced parent/child reverse-lock schedule | One `40P01`; bounded whole-command retry; no duplicate audit event | `NOT_EXECUTED` |
| Audit atomicity | Force audit insert failure inside state command | Neither state nor audit persists | `NOT_EXECUTED` |
| Authorization/delegation | Real trusted context and concurrent revocation | Cross-Brand/self/stale/revoked/expired attempts denied atomically | `BLOCKED_BY_IDENTITY` |
| No Purge | Direct DELETE and runtime-role attempts in every state | Trigger or privilege denial; no row removed | `NOT_EXECUTED` |
| Audit scope migration | Upgrade fixture containing existing append-only AuditEvents | No historical row update; correct scope check; append-only protection retained | `NOT_EXECUTED` |
| Branch migration | Representative approved mapping/orphan fixtures | UUID preservation, correct `NOT VALID` behavior, successful later validation | `BLOCKED_BY_MAPPING` |
| Role restrictions | Production-like runtime and migration roles | Runtime cannot disable triggers, truncate, delete Catalog, or mutate AuditEvents | `NOT_EXECUTED` |
| Schema reproducibility | Fresh and upgrade migration plus `structure.sql` load | Identical named objects and passing integrity suite | `NOT_EXECUTED` |

Proposed tests are not executed evidence. Application tests are intentionally outside this documentation-only task.

## 10. Findings and blockers

| ID | Severity | Affected document / area | Owner decisions | Current design and concrete gap | Required resolution | Classification | Owner |
|---|---|---|---|---|---|---|---|
| `CAT-TRR-001` | `BLOCKER` | Technical Design §§11–12; migration readiness | `ODB-CAT-14`–`16` | No authoritative target-environment Branch inventory/mapping exists. Guessing Main Branch or merging UUIDs can corrupt historical scope; operational FKs cannot be safely validated. | Inventory every target, approve mapping/orphan disposition, and record migration evidence before operational FK validation. | `OPERATIONAL_EVIDENCE_REQUIRED` | Owner + deployment/data operator |
| `CAT-TRR-002` | `LOW` | Product lifecycle, Variant Restore flags, and reassignment scope | `ODB-CAT-39`–`41` | Initial MVP now excludes Product lifecycle and reassignment commands; Variant Archive/Restore preserves both flags. Future Product lifecycle/reassignment policy remains visible outside this scope. | Preserve the exclusions and do not claim the full Product lifecycle is complete. | `RESOLVED_FOR_INITIAL_SCOPE` | Documentation owner |
| `CAT-TRR-003` | `BLOCKER` | Technical Design §10; lifecycle commands | `ODB-CAT-25`, `33` | Trusted authorization/delegation and Brand-scoped audit have no implementation provider. UUID-format actor validation is not authorization; Identity Milestone 2B is unauthorized. | Exclude lifecycle commands or separately authorize and complete the required Identity/Audit prerequisite design and implementation. | `TECHNICAL_DESIGN_CHANGE_REQUIRED` | Owner + Identity/security design owner |
| `CAT-TRR-004` | `HIGH` | AuditEvent scope migration | `ODB-CAT-25`, `33` | Existing append-only trigger rejects ordinary backfill updates, while earlier scope design said existing rows would be backfilled. | Review/prove the no-row-update expansion sequence in §7 and preserve append-only enforcement throughout. | `TECHNICAL_DESIGN_CHANGE_REQUIRED` | Backend/database design owner |
| `CAT-TRR-005` | `HIGH` | No-Purge direct-SQL protection | `ODB-CAT-35`–`37` | Restrictive FKs do not stop deletion of an unreferenced Catalog row; absence of an application command does not protect direct SQL. | Review proposed `BEFORE DELETE` guards and runtime-role denial of `DELETE`; validate every lifecycle state and privileged-role procedure. | `TECHNICAL_DESIGN_CHANGE_REQUIRED` | Backend/database design owner |
| `CAT-TRR-006` | `HIGH` | Default, Category/Product, and Variant concurrency | `ODB-CAT-23`, `25`, `28`, `29`, `38` | Parent-locking argument is plausible but unexecuted. Missing trigger events or snapshot/lock behavior could allow invalid final state or unstable deadlock handling. | Produce deterministic multi-connection PostgreSQL evidence for every schedule in §6. | `VALIDATION_EVIDENCE_REQUIRED` | Backend/database test owner |
| `CAT-TRR-007` | `HIGH` | Database roles and privileged bypass | `ODB-CAT-35`–`37`; audit requirements | No production-like grants prove the runtime role cannot delete, truncate, disable triggers, or mutate AuditEvents. | Define roles and verify grants/negative operations; document monitored migration/break-glass access. | `OPERATIONAL_EVIDENCE_REQUIRED` | Infrastructure/database operator |
| `CAT-TRR-008` | `MEDIUM` | Migration and error mapping | All database-backed Catalog decisions | Constraint names and SQLSTATE mapping are proposed, but fresh/upgrade/rollback and unknown-constraint behavior have not been validated. | Run authorized migration-path, `structure.sql`, and error-contract evidence later. | `VALIDATION_EVIDENCE_REQUIRED` | Backend/database test owner |
| `CAT-TRR-009` | `LOW` | Owner decision reconciliation | `ODB-CAT-01`–`41` | No contradiction found after `ODB-CAT-39`–`41`; Price/availability/SKU/retention boundaries remain correctly separated. | Preserve classifications and rerun documentation consistency when design changes. | `RESOLVED` | Documentation owner |

## 11. Remaining Owner decisions and scope choices

No Owner decision is needed for index, FK, trigger, lock, SQLSTATE, or database-role mechanics.

No additional Owner decision is required to preserve the current initial-MVP exclusions. Future Owner input is required only if a later scope proposes Product lifecycle commands, Product Category reassignment, or different scope boundaries. `ODB-CAT-39` does not resolve the future Product transition/authorization matrix; `ODB-CAT-41` does not approve future reassignment behavior.

## 12. Is an Owner implementation authorization request appropriate?

### Full Catalog Core: no

A full request still contains unavailable Identity/Audit prerequisites, missing target-environment mapping, and no executable database evidence. The former initial-scope Owner behavior gap is resolved by exclusion, but that is not sufficient for readiness.

### Narrow reference foundation: potentially, after a separate scope package

An Organization/Brand/Branch reference-only package could be prepared after authoritative mapping and migration-role evidence exist. It must exclude Category/Product/Variant lifecycle commands, audit redesign, Identity, API/frontend, pricing, availability, menu data, and operational FK validation that lacks approved mapping.

This reassessment does not authorize either scope.
