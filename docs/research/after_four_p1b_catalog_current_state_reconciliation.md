# AFTER FOUR — P1B Catalog Current-State Reconciliation

**Work package:** `P1B — Catalog current-state reconciliation`

**Package status:** `OWNER_REVIEW_COMPLETED — 5 APPROVED`

**Authorizing decision:** `NW-OR-01` — documentation/design preparation only

**Evidence mode:** `REPOSITORY_AND_COMMIT_INSPECTION — NO TEST EXECUTION`

**Catalog implementation authorization:** `NOT_GRANTED` for any new work

**Package C implementation:** `NOT_AUTHORIZED`

**Physical database design:** `NOT_GRANTED` by this work package

**Date:** 2026-11-23

## 1. Purpose and authority boundary

This report establishes the current Catalog truth by reconciling Owner decisions, canonical domain documents, the Package B design, merged Package B implementation artifacts, later CAT-TRR evidence, and Package C prerequisites. It does not reinterpret existing implementation as blanket authority and does not close a CAT-TRR finding.

The Owner approved all five §9 policy recommendations on 2026-11-23 with no comments or conditions. The [Owner Decision Baseline](../architecture/after_four_owner_decision_baseline.md#consolidated-p1-owner-decisions) is authoritative for their exact outcomes and boundaries. Every reference remains `ID_PENDING_OWNER_GOVERNANCE`; no Catalog implementation authorization follows.

The [Owner Decision Baseline](../architecture/after_four_owner_decision_baseline.md) remains authoritative for business policy. [ADR-0011](../architecture/adr/0011-project-wide-layered-ddd.md) remains authoritative for source dependency direction. Repository code and tests are evidence of implemented mechanisms only within their authorized package; they do not create business policy, runtime mutation authority, production readiness, or proof that an unexecuted scenario passed.

### 1.1 Classifications

| Classification | Meaning in this report |
|---|---|
| `OWNER_CONFIRMED` | Explicit policy recorded in the Owner Decision Baseline. |
| `IMPLEMENTED_EVIDENCE` | A mechanism exists in the merged repository and was inspected. |
| `TEST_IMPLEMENTED_NOT_EXECUTED_IN_P1B` | A test exists, but P1B did not execute it and does not claim its result. |
| `DOCUMENTATION_RECONCILIATION_REQUIRED` | Current wording materially predates or contradicts merged repository evidence. |
| `TECHNICAL_PROPOSAL` | A reviewable future design direction, not implementation authority. |
| `OWNER_DECISION_REQUIRED` | A precise business/authority choice remains open. |
| `EXTERNAL_PREREQUISITE` | Another bounded package or operational environment must provide evidence. |

## 2. Evidence inspected

### 2.1 Governance and architecture

- [Owner Decision Baseline — Catalog/Pricing](../architecture/after_four_owner_decision_baseline.md#5-catalogpricing-mvp), including `ODB-CAT-01` through `ODB-CAT-41`, `ODB-DATA-01`, `C0-CAT-01` through `C0-CAT-08`, and the applicable `C0-R*` decisions.
- [Glossary](../../GLOSSARY.md), including Catalog Deactivation, Catalog Archive, Catalog Code, SKU, Purge, and Sold Price.
- [Next-Wave Execution Plan — P1B](after_four_next_wave_execution_plan.md#5-p1b--catalog-current-state-reconciliation).
- [ADR-0011 — Project-wide Layered DDD](../architecture/adr/0011-project-wide-layered-ddd.md).
- [DDD Foundation](../architecture/after_four_ddd_foundation.md), [Business Domain Model](../architecture/after_four_business_domain_model.md), [Data Dictionary](../architecture/after_four_data_dictionary.md), [Data Integrity Rules](../architecture/after_four_data_integrity_rules.md), [ERD](../architecture/after_four_erd.md), and [State Machines](../architecture/after_four_state_machines.md).
- [Catalog Core Technical Design](../architecture/after_four_catalog_core_technical_design.md), [Package C Technical Design](../architecture/after_four_package_c_technical_design.md), [P3 Runtime Database Security Design](../architecture/after_four_p3_runtime_database_security_design.md), and [Foundation Decisions](../architecture/after_four_foundation_decisions.md).

### 2.2 Historical/readiness evidence

- [Catalog Core Architecture & Implementation Readiness Review](after_four_catalog_core_architecture_implementation_readiness_review.md).
- [Catalog Core Technical Readiness Reassessment](after_four_catalog_core_technical_readiness_reassessment.md).
- [Catalog Core MVP Scope Closure and Implementation Readiness Plan](after_four_catalog_core_mvp_scope_closure_implementation_readiness_plan.md).
- [Logical Database Design Inventory](../architecture/after_four_logical_database_design_inventory.md).

These reports retain assessment-time value, but statements that no Catalog source, migration, table, or spec exists were superseded by later merged Package B implementation. Historical findings are not silently rewritten into current facts.

### 2.3 Merged implementation and test artifacts

| Evidence | Repository path / commit | P1B assessment |
|---|---|---|
| Package B foundation | Commit `44ee632`; [migration](../../backend/db/migrate/20261115210000_create_catalog_core_foundation.rb) | `IMPLEMENTED_EVIDENCE`: empty Category/Product/Variant schema, integrity functions/triggers, Domain and Infrastructure records. |
| Normalized checked-in schema | Commit `d78fc19`; [structure.sql](../../backend/db/structure.sql) | `IMPLEMENTED_EVIDENCE`: Package B objects are represented in the checked-in PostgreSQL schema dump. |
| Layered DDD Domain | [`Catalog::Domain`](../../backend/app/domains/catalog/domain) | `IMPLEMENTED_EVIDENCE`: Product aggregate, Category/Variant entities, Catalog Code Value Object; no Rails dependency found in inspected Domain files. |
| Infrastructure persistence | [`Catalog::Infrastructure::Persistence`](../../backend/app/domains/catalog/infrastructure/persistence) | `IMPLEMENTED_EVIDENCE`: namespaced Active Record records and projections. |
| Domain/persistence specs | [`catalog_spec.rb`](../../backend/spec/domains/catalog/domain/catalog_spec.rb), [`catalog_records_spec.rb`](../../backend/spec/domains/catalog/infrastructure/persistence/catalog_records_spec.rb) | `TEST_IMPLEMENTED_NOT_EXECUTED_IN_P1B`. |
| Schema/integrity specs | [`catalog_schema_spec.rb`](../../backend/spec/integration/catalog_schema_spec.rb), [`catalog_database_integrity_spec.rb`](../../backend/spec/integration/catalog_database_integrity_spec.rb), [`catalog_isolation_spec.rb`](../../backend/spec/integration/catalog_isolation_spec.rb) | `TEST_IMPLEMENTED_NOT_EXECUTED_IN_P1B`. |
| CAT-TRR-006 concurrency additions | Commit `3db6c71`; [`catalog_concurrency_spec.rb`](../../backend/spec/integration/catalog_concurrency_spec.rb) | Merged deterministic schedules, victim rollback, timeout, stale-snapshot harness, and deferred repair tests exist; not executed in P1B. |
| CAT-TRR-008 lifecycle evidence | Commit `520961f`; [`catalog_migration_lifecycle_spec.rb`](../../backend/spec/integration/catalog_migration_lifecycle_spec.rb) | Fresh-chain, A1 upgrade, empty rollback/reapply, and non-empty rollback-refusal tests exist; not executed in P1B. |
| CAT-TRR-008 failure/equivalence evidence | Commit `cfb133a`; [`catalog_migration_atomicity_spec.rb`](../../backend/spec/integration/catalog_migration_atomicity_spec.rb), [`catalog_schema_equivalence_spec.rb`](../../backend/spec/integration/catalog_schema_equivalence_spec.rb) | Failure atomicity, recovery/rerun, and migration/structure equivalence tests exist; not executed in P1B. |
| Current backend boundary | [Backend README](../../backend/README.md) | Correctly describes an empty Package B Catalog integrity foundation and excludes pricing, availability, menu data, Identity, and runtime mutation endpoints. |

No retained command output or CI artifact was independently authenticated by this work package. Test existence and merge ancestry are not represented as fresh execution results.

## 3. Current-state reconciliation matrix

| Area | Owner-approved / canonical meaning | Observed implementation state | Reconciliation result |
|---|---|---|---|
| Context and layers | Catalog owns Catalog behavior; Organization owns Organization/Brand/Branch; cross-context access requires an approved contract; dependencies point inward. | Catalog Domain is framework-independent; Active Record records are namespaced in Infrastructure; no Application or Presentation Catalog layer exists because Package B exposes no use case. A database FK references Organization-owned `brands`. | `CONSISTENT`. The FK is an Infrastructure integrity dependency, not a Domain/Application contract. |
| Product identity and Category | Product is Brand-global, belongs to exactly one original flat Category, and Category reassignment is unsupported in initial MVP (`ODB-CAT-01`, `02`, `15`, `41`). | `products.brand_id` and `category_id` are required; same-Brand composite FK and scope-immutability guard exist. | `IMPLEMENTED_EVIDENCE` for Package B persisted/direct-SQL protection; no create/edit/reassignment use case exists. |
| Persisted Variant | Every sellable selection is represented by a persisted Variant; Product owns Variant consistency (`ODB-CAT-04`). | `product_variants` exists; Product Domain aggregate validates membership. | `IMPLEMENTED_EVIDENCE` for representation only. No selling/publication API or menu data exists. |
| Catalog Code | Uppercase canonical ASCII Code; separate same-type Brand namespaces; retained after Archive (`ODB-CAT-16`, `18`, `22`, `27`, `36`). | Catalog Code Value Object canonicalizes/validates; each table has an independent Brand/Code unique index and canonical check. | `IMPLEMENTED_EVIDENCE`. The 64-character limit is an implemented technical choice, not Owner policy. |
| SKU | Optional future Brand-unique identifier; support and normalization deferred (`ODB-CAT-17`, `34`). | No SKU column or input exists. | `CONSISTENT_SCOPE_EXCLUSION`. |
| Category/Variant initial state | New Category and Variant begin Draft (`ODB-CAT-30`, `31`). Product universal initial state remains unresolved. | Draft defaults plus insert guards exist for Category/Variant. Product has no default/initial-state guard. | `IMPLEMENTED_EVIDENCE`; preserves the unresolved Product question. |
| Category/Variant lifecycle | Exact matrix, Restore to Inactive, separate activation, and Variant Archive/Restore flag preservation (`ODB-CAT-25`, `30`–`32`, `40`). | Transition triggers exist; same-statement Archive/Restore flag change is rejected. | `IMPLEMENTED_EVIDENCE` backstop. No authorized lifecycle Application operation exists, and multi-statement semantic attribution is not claimed. |
| Product lifecycle | Four values exist, but initial MVP Product lifecycle commands and full transition policy are excluded (`ODB-CAT-03`, `24`, `33`, `39`). | Allowed-value check and cross-row final-state protection exist; no Product transition guard/command/API exists. | `CONSISTENT_SCOPE_EXCLUSION`. Table state support is not a completed Product lifecycle. |
| Default Variant | At most one designated Default in every Product state; Active Product requires exactly one Active Default; visibility is independent (`ODB-CAT-20`, `23`, `28`, `38`). | Partial unique index, Product aggregate validation, and deferred final-state trigger exist. | `IMPLEMENTED_EVIDENCE`; Default switching remains out of Package C under `C0-CAT-08` and has no authorized use case. |
| Active Category dependency | Product activation requires Active Category; non-Active Category cannot retain Active Product (`ODB-CAT-29`). | Deferred Category/Product final-state trigger exists. | `IMPLEMENTED_EVIDENCE` for database final state; Product activation remains excluded. |
| Retention / no Purge | Archive retention, no MVP Soft Delete, and no Purge in any lifecycle state (`ODB-CAT-35`–`37`, `ODB-DATA-01`). | `BEFORE DELETE` guards exist for all three tables; restrictive FKs remain defense-in-depth. | `IMPLEMENTED_EVIDENCE` locally. Runtime-role and privileged-bypass evidence remains open under CAT-TRR-005/007. |
| Branch Availability | Branch override is independent of Brand-global Product (`ODB-CAT-06`). | No availability table, Domain operation, or runtime contract in Package B. | `OWNER_CONFIRMED — NOT_IMPLEMENTED`; correctly outside Package B/C. |
| Price history | Chain default plus explicit Branch override; immutable effective-dated versions; revised Draft quote review; sold snapshot at Order confirmation (`ODB-CAT-07`–`10`). | No Price table or Catalog pricing runtime. Phase 1 has no Catalog-backed Order Items. | `OWNER_CONFIRMED — NOT_IMPLEMENTED`; physical proposals in dictionary/design material are not implementation evidence. |
| Modifier/Recipe/menu data | Modifier cardinality is approved; Recipe detail and real menu/prices remain incomplete or outside Package B. | No Modifier, Recipe, menu seed, or production Catalog row exists. | `NOT_IMPLEMENTED`; no scope expansion. |
| Runtime Catalog operations | Table existence is not read/write authority; Package C requires P1/P2/P3 and operation-specific approval. | No Catalog Application use case, controller, route, public DTO, or frontend integration exists. | `NOT_AUTHORIZED_AND_NOT_IMPLEMENTED`. |
| Audit/authorization | Category/Variant lifecycle requires trusted Brand-scoped capability/delegation, reason, step-up for Archive/Restore, and atomic append-only audit. | Package B intentionally has no AuthorizationContext or Catalog AuditEvent implementation. Existing Branch-scoped Phase 1 AuditEvent is not C0-R07. | `EXTERNAL_PREREQUISITE`; blocks Package C/runtime writers. |

## 4. Canonical terminology and ownership

| Term | Current canonical use | Boundary that must remain explicit |
|---|---|---|
| Product | Brand-global menu identity assigned to its original Category. | Not an unpersisted sellable option; Branch availability and Price are separate. |
| Variant | Persisted Product selection. | `is_default`, lifecycle status, and `customer_visible` are independent; persistence does not itself make it sellable. |
| Default Variant | Product-owned designation with all-state upper bound and stricter Active eligibility. | Not derived from visibility; no implicit transfer/switch. |
| Catalog Deactivation | Temporary reversible Category/Variant suspension. | Distinct from Archive and Branch Availability. |
| Catalog Archive | Long-term Category/Variant retirement with validated Restore to Inactive. | Not Soft Delete or Purge. |
| Catalog Code | Same-type, Brand-scoped stable canonical identifier. | SKU is distinct and deferred; Category/Product/Variant namespaces are separate. |
| Price Version | Immutable effective-dated price at chain-default or Branch-override scope. | Not implemented by Package B and not an editable `current_price`. |
| Sold Price | Ordering-owned confirmed historical commercial evidence. | Catalog supplies current authoritative input; later Catalog changes never rewrite the Order snapshot. |
| Branch Availability | Explicit effective Branch override of chain availability default. | Does not change Product identity or lifecycle. |

No glossary correction is required by the inspected evidence. The mismatch is predominantly document maturity/status, not domain vocabulary.

## 5. Documentation and implementation gap register

| Ref | Severity | Classification | Evidence | Gap / impact | Required correction or next action |
|---|---|---|---|---|---|
| `P1B-GAP-001` | High | `DOCUMENTATION_RECONCILIATION_REQUIRED` | [Catalog Core Technical Design header](../architecture/after_four_catalog_core_technical_design.md) versus commits `44ee632`/`d78fc19` | The design still says `TECHNICAL_PROPOSAL`, `READY_FOR_OWNER_APPROVAL`, and implementation authorization not granted, although the bounded Package B implementation is merged. Readers may mistake a historical pre-implementation status for current truth. | Preserve the design content, add a supersession/current-state notice, and point to merged Package B evidence. Do not change CAT-TRR or runtime authorization. |
| `P1B-GAP-002` | High | `DOCUMENTATION_RECONCILIATION_REQUIRED` | Owner Decision Baseline Catalog rows versus merged migration/Domain/Infrastructure | Many `ODB-CAT-*` implementation columns still say “Not implemented” even where Package B now supplies bounded persistence/direct-SQL enforcement. This obscures the difference between implemented database backstops and still-absent Application operations. | Update only implementation/evidence columns through a separately reviewed documentation task: identify `PARTIALLY_IMPLEMENTED_IN_PACKAGE_B` precisely and keep commands/API/runtime/production not authorized. |
| `P1B-GAP-003` | Medium | `DOCUMENTATION_RECONCILIATION_REQUIRED` | Business Domain Model, Data Dictionary, Data Integrity Rules, ERD, State Machines versus Package B | Several current-looking passages still call Package B fields, constraints, cross-row enforcement, or concurrency “proposed/unimplemented”; the Data Dictionary also describes a proposed raw/canonical Code representation while implementation stores one canonical Code. | Reconcile actual field names and bounded enforcement evidence without turning physical implementation into business policy or revising future Price/Availability proposals. |
| `P1B-GAP-004` | Medium | `HISTORICAL_STATUS_NEEDS_NOTICE` | Pre-Package-B readiness reviews versus current tree | Older reviews truthfully state that no Catalog source/schema/spec existed, but lack an obvious superseded/historical notice. Search-driven readers can treat them as current. | Preserve historical content and add a concise later-evidence notice or canonical-current-state link; do not rewrite assessment-time findings. |
| `P1B-GAP-005` | High | `EXTERNAL_PREREQUISITE` | Package C design §13; P1/P2/P3 designs; `C0-*` decisions | Trusted authorization/delegation, Brand-scoped audit, and runtime DB boundary are designed or proposed but not implemented/operationally evidenced. | Keep all runtime mutation and Package C work blocked. P1B cannot supply these controls. |
| `P1B-GAP-006` | High | `OPERATIONAL_EVIDENCE_REQUIRED` | CAT-TRR-005/007; current local/test role assumptions | A no-Purge trigger does not prove runtime least privilege, table-owner/superuser limitations, or production-like role separation. | Separately authorized non-production/production-like role evidence; no role creation in P1B. |
| `P1B-GAP-007` | Medium | `TEST_EVIDENCE_RECONCILIATION_REQUIRED` | Merged CAT-TRR-006/008 specs; Package C §13 | Test implementations exist and Package C notes merged evidence, but finding statuses remain open and this workstream did not authenticate retained executions. | Preserve statuses. A separate evidence review must map exact executed artifacts/results to each acceptance criterion before any status change. |
| `P1B-GAP-008` | Medium | `OWNER_DECISION_REQUIRED` | Catalog design §13; `ODB-CAT-19`, `C0-CAT-08` | Product universal initial state, create/edit authority, Default designation authority, and non-lifecycle mutation audit remain intentionally unresolved. | Decide only through separate, operation-specific Owner decisions; table columns or Domain constructors do not settle them. |
| `P1B-GAP-009` | High | `BUSINESS_POLICY_BACKLOG` | `ODB-CAT-05`–`10`; Business Domain Model §7 | Tax/service charge/rounding/free items, Modifier price effects, Price publication authority, time-based availability, and related commercial policy remain unresolved. | Keep Pricing/Availability outside any Catalog Core runtime proposal until their own policy package closes them. |

No verified implementation deviation from an Owner-confirmed Package B invariant was found by code inspection. This statement is not an executed-test or production assurance claim.

## 6. CAT-TRR status preservation

This report does not edit or close canonical findings. The current status vocabulary below is copied from the later [Package C Technical Design §13](../architecture/after_four_package_c_technical_design.md#13-cat-trr-005-through-cat-trr-008), which already acknowledges merged Package B evidence while retaining the open findings.

| Finding | Current status — unchanged | Evidence now visible | Remaining gap |
|---|---|---|---|
| `CAT-TRR-005` | `HIGH / TECHNICAL_DESIGN_CHANGE_REQUIRED` | Package B no-Purge triggers and direct-SQL test implementation exist. | Runtime-role DELETE/TRUNCATE denial, privileged bypass limitations, operation boundary, and production-like privilege evidence. |
| `CAT-TRR-006` | `HIGH / VALIDATION_EVIDENCE_REQUIRED` | Merged deterministic Package B concurrency test implementation covers fresh snapshots, waits/deadlocks, victim rollback, timeout, stale-snapshot negative harness, and deferred repair. | Exact retained execution evidence and later Package C authorization/audit concurrency remain separate. |
| `CAT-TRR-007` | `HIGH / OPERATIONAL_EVIDENCE_REQUIRED` | Designs specify separation and restrictions. | Implemented runtime/migration/break-glass topology, grants/default privileges, ownership, safe execution/search path, and production-like negative evidence. |
| `CAT-TRR-008` | `MEDIUM / VALIDATION_EVIDENCE_REQUIRED` | Merged Package B migration lifecycle, failure/recovery, and semantic-equivalence test implementation exists. | Exact executed evidence reconciliation plus later Package C/P2/P3 migration, Brand audit, error translation, role-aware operations, and production-like safeguards. |

`CAT-TRR-001`, `CAT-TRR-003`, and `CAT-TRR-004` remain relevant external blockers for A2/production mapping, trusted Identity/audit, and Brand-scoped AuditEvent expansion. P1B neither changes their status nor expands its scope into those packages.

## 7. Cross-domain responsibility and interface notes

| Interface | Classification | Authoritative owner / confirmed boundary | P1B consequence |
|---|---|---|---|
| Organization Brand → Catalog | Confirmed hierarchy plus implemented Infrastructure FK; future Application contract unresolved | Organization owns Brand/Organization facts; Catalog owns Catalog behavior. | Database FK proves persisted ancestry only. Future operations must not call Organization Infrastructure directly. |
| Catalog definition/Price → Ordering quote and snapshot | Owner-confirmed policy; runtime contract unresolved | Catalog/Pricing owns current authoritative definition and effective Price; Ordering owns Draft quote acceptance and immutable confirmed Order Item snapshot. | P1A must not derive historical sold facts from mutable Catalog state. No Price implementation is authorized here. |
| Catalog → Preparation | Existing documented proposal | Ordering supplies immutable sold configuration; Preparation consumes eligible dispatch/ticket facts. | Preparation must not query mutable Product labels/Price to reconstruct historical work. RecipeVersion integration remains future scope. |
| Catalog → Inventory | Unresolved/proposed | Catalog/Recipe defines product configuration; Inventory owns stock movements and quantities. | No automatic stock movement, shared aggregate, or direct persistence write is approved. |
| Catalog ↔ Promotions/Loyalty | Policy/interface questions remain future owned | Promotions owns eligibility/discount rules; Loyalty owns ledger/benefits; Catalog/Pricing owns base sellable definition and Price. | Do not place Promotion/Loyalty state inside Product/Variant or infer discount authority from Catalog. |
| Catalog → Branch Availability | Owner-confirmed separate concern; unimplemented | Product identity remains Brand-global; Availability owns effective Branch override. | Lifecycle state cannot stand in for a Branch sellability decision. |
| Identity/P1 → Catalog lifecycle | Owner-confirmed security boundary; implementation prerequisite missing | Identity supplies trusted actor/session/capability facts; Catalog Application owns target lookup, business guards, mutation, and revalidation. | P1C prerequisite; role labels and client Brand IDs are not authority. |
| Catalog lifecycle → Audit | Owner-confirmed contract; implementation prerequisite missing | Catalog owns mutation; Brand-scoped append-only audit evidence must commit atomically. | Existing Branch-scoped Phase 1 AuditEvent cannot be reused as proof of C0-R07 without separate design/implementation evidence. |
| Payment/Cash → Catalog | No direct mutation dependency | Payment owns settlement; Cash owns drawer/session evidence. | Catalog must not infer Price correctness from settlement or write Payment/Cash records. |

## 8. Bounded logical proposal for the next Catalog step

### `P1B-PROP-01 — Catalog documentation evidence synchronization`

**Classification:** `TECHNICAL_PROPOSAL — DOCUMENTATION_ONLY`

Prepare one separately reviewed documentation-only synchronization that:

1. adds a current-state/supersession notice to the Package B Technical Design and pre-implementation reviews;
2. updates Owner Decision Baseline implementation/evidence columns only where Package B provides bounded proof;
3. reconciles Business Domain Model, Data Dictionary, Data Integrity Rules, ERD, and State Machines with actual Package B field/enforcement evidence;
4. retains all Product/Category/Variant business meanings and future-scope policies unchanged;
5. records test implementation separately from executed/retained evidence;
6. preserves CAT-TRR-005 through CAT-TRR-008 exactly; and
7. keeps Package C, runtime Catalog DML, Pricing, Availability, menu data, A2 mapping, and production use unauthorized.

**Why this is the preferred next step:** the largest current risk is not a missing new mechanism but contradictory maturity claims. Synchronizing documentation reduces governance error without choosing an operation, physical design, or implementation scope.

**Alternatives:**

- leave historical/current wording mixed: lowest effort but preserves misleading readiness claims;
- prepare Package C or a runtime CRUD package immediately: rejected because P1/P2/P3, CAT-TRR, operation authority, audit, and runtime-role prerequisites remain open;
- close CAT-TRR findings from test-file existence: rejected because code inspection is not execution/operational evidence and status change requires separate authorization.

This proposal is not automatically authorized by appearing here.

## 9. Owner decisions for future operation policy

The references below remain provisional P1B identifiers, not canonical `ODB-*` IDs. The Owner approved each recommendation at its stated policy level; no selection approves the excluded technical or implementation detail.

### `P1B-OD-01 — Initial Product lifecycle state`

**Owner outcome:** `OWNER_DECIDED — OWNER_CONFIRMED`; approve recommendation.

**Question:** Must every successfully created Product begin in Draft?

**Why needed:** `ODB-CAT-19` permits a Draft Product to be incomplete but does not state a universal creation state. Package B deliberately has no Product default or insert guard.

**Recommended option:** require Draft at creation, aligning Product creation with Category/Variant Draft staging while preserving separate activation.

**Alternatives/trade-offs:** permit an explicitly supplied allowed state, which offers operational flexibility but could bypass staging semantics and requires more complex authority/validation; continue deferral, which keeps Product creation out of scope.

**Deferral consequence:** no Product create use case or public contract may be proposed as complete.

**Would authorize:** business meaning only after explicit Owner confirmation.

**Would not authorize:** a column default, trigger, command, API, migration, or implementation.

### `P1B-OD-02 — Catalog master-data creation authority`

**Owner outcome:** `OWNER_DECIDED — OWNER_CONFIRMED`; approve recommendation.

**Question:** Who may create Category, Product, and Variant records within an authoritative Brand scope?

**Recommended option:** Organization/Brand Owner or personnel explicitly granted the exact entity-specific creation capability; no authority from a generic role title or Branch assignment.

**Alternatives/trade-offs:** Owner-only is simpler and stricter but creates an operational bottleneck; a single broad Catalog-editor capability is simpler to administer but weakens least privilege across entity types.

**Deferral consequence:** no create Application use case, delegation grant, or Presentation operation may be treated as authorized.

**Would authorize:** only the selected policy boundary.

**Would not authorize:** P1 implementation, persistence, audit mechanism, endpoint, or runtime operation.

### `P1B-OD-03 — Non-lifecycle Catalog editing authority and field boundary`

**Owner outcome:** `OWNER_DECIDED — OWNER_CONFIRMED`; approve recommendation.

**Question:** Which actors may edit Category/Product/Variant names, descriptions, display positions, visibility, and Codes, and which fields become immutable after activation or use?

**Recommended option:** decide capabilities and editable fields per operation/entity, with Code correction separated from ordinary label/position edits and no implicit reassignment or lifecycle mutation.

**Alternatives/trade-offs:** one general edit capability is easier but overbroad; Owner-only edits reduce overgranting but hinder daily menu administration; immutable Codes simplify historical traceability but require a separate correction policy for mistakes.

**Deferral consequence:** Package B records remain persistence backstops only; no generic CRUD contract is justified.

**Would authorize:** selected business capabilities and field semantics only.

**Would not authorize:** Product reassignment, Product lifecycle commands, pricing, availability, implementation, or public API.

### `P1B-OD-04 — Default Variant designation authority`

**Owner outcome:** `OWNER_DECIDED — OWNER_CONFIRMED`; approve recommendation.

**Question:** Who may designate or replace a Product's Default Variant, and under which Product lifecycle states may that operation occur?

**Recommended option:** a distinct Brand-scoped, capability-specific operation requiring final aggregate validity; do not infer it from lifecycle authority, visibility edits, or a generic Catalog role.

**Alternatives/trade-offs:** Owner-only is strongest but operationally restrictive; delegating with lifecycle authority conflates independent concepts and risks unintended switches; continued exclusion preserves safety but blocks a complete runtime maintenance flow.

**Deferral consequence:** `C0-CAT-08` remains controlling; Package C must reject invalid transitions rather than switch Default automatically.

**Would authorize:** only the selected Default-designation policy.

**Would not authorize:** an index/lock/transaction, Package C expansion, code, or API.

### `P1B-OD-05 — Audit policy for non-lifecycle mutations`

**Owner outcome:** `OWNER_DECIDED — OWNER_CONFIRMED`; approve the recommendation at the policy-principle level only. The consequential-operation list remains dependent on `P1B-OD-02` through `P1B-OD-04` and is not exhaustive.

**Question:** Which create/edit/Default-designation operations require durable audit evidence, mandatory reason, before/after state, approval, or step-up?

**Recommended option:** require append-only Brand-scoped audit for creation, Code correction, Default change, and other consequential edits; separately decide whether routine label/position edits require a reason or step-up.

**Alternatives/trade-offs:** audit every edit maximizes traceability but increases volume/privacy/operational cost; audit only consequential changes reduces noise but requires a precise classification that cannot be guessed from field names.

**Deferral consequence:** non-lifecycle mutation operations remain unauthorized even if lifecycle audit policy is confirmed.

**Would authorize:** the chosen evidence policy only.

**Would not authorize:** an AuditEvent schema, retention/read/export rules, implementation, or legal-compliance conclusion.

Read/disclosure scope, Price publication, Availability administration, tax/service charge/rounding, complimentary items, Modifier pricing, future SKU behavior, and any future Product lifecycle/reassignment capability remain separate decision packages and are not bundled into the proposals above.

## 10. Prerequisites and review criteria

### 10.1 Before any runtime Catalog proposal

- complete the separately required P1 trusted Identity/authorization prerequisite;
- complete Brand-scoped audit and runtime database security prerequisites applicable to the exact operation;
- reconcile CAT-TRR evidence without silently changing statuses;
- record applicable operation authority, editable fields, audit/reason, Default, and Product-initial-state decisions;
- preserve `ODB-CAT-39`, `ODB-CAT-41`, and `C0-CAT-08` exclusions unless separately reopened by the Owner; and
- define a bounded Application contract without exposing persistence records.

### 10.2 P1B exit assessment

| Criterion | Result |
|---|---|
| Current decisions separated from implementation facts | `SATISFIED_FOR_REVIEW` |
| Package B implementation inventory sourced | `SATISFIED_FOR_REVIEW — CODE_INSPECTION_ONLY` |
| Material stale documentation identified | `SATISFIED` |
| CAT-TRR statuses preserved | `SATISFIED` |
| Pricing/Availability/runtime scope not expanded | `SATISFIED` |
| One bounded next proposal identified | `P1B-PROP-01 — OWNER_REVIEW_REQUIRED` |
| Future Owner questions actionable and unapproved | `SATISFIED` |
| New implementation authorization | `NOT_GRANTED` |

## 11. Final status

### `P1B RECONCILIATION PREPARED — OWNER REVIEW REQUIRED`

Package B is implemented and merged only as the empty Catalog schema/integrity foundation evidenced above. No Catalog runtime operation, Package C lifecycle command, Pricing, Availability, menu publication, production mapping, or production readiness follows from that fact.

The immediate recommended follow-up remains the documentation-only `P1B-PROP-01` synchronization. The five policy recommendations are Owner-confirmed within their exact exclusions and remain `ID_PENDING_OWNER_GOVERNANCE`. CAT-TRR-005 through CAT-TRR-008 retain their current statuses. This report creates no canonical ODB ID and grants no physical database, schema, migration, application, test, dependency, runtime, deployment, FOA, or Production Authorization.
