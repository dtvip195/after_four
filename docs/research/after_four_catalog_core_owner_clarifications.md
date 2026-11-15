# AFTER FOUR — Catalog Core Owner Clarifications

**Document date:** 2026-11-15

**Status:** `OWNER_CLARIFICATIONS_RECORDED`

**Readiness verdict:** `NOT_READY`

**Implementation authorization:** Not granted

## 1. Purpose and approval boundary

This document preserves all nine resolved Catalog Core clarifications. It is based on the current [Catalog Core Technical Design](../architecture/after_four_catalog_core_technical_design.md), [Technical Design Review](after_four_catalog_core_technical_design_review.md), [Implementation Readiness Review](after_four_catalog_core_implementation_readiness_review.md), and Owner Decision Baseline [§5](../architecture/after_four_owner_decision_baseline.md#5-catalogpricing-mvp) and [§6](../architecture/after_four_owner_decision_baseline.md#6-global-data-retention-and-deletion).

This document creates no decision by itself. Explicit Owner tasks recorded `ODB-DATA-01` and `ODB-CAT-27` through `ODB-CAT-41`. `ODB-CAT-39`–`ODB-CAT-41` close the later initial-scope questions without reopening CAT-CLAR-01–09. Historical alternatives remain context only; business closure does not authorize implementation.

Nothing in this document authorizes Identity or Milestone 2B work, production database access or modification, or any Category/Product/Variant schema, migration, model, command, service, factory, seed, API, test, or frontend work.

Synthetic examples use Brand `BRAND-A` and codes such as `DRINKS`, `LATTE`, and `LARGE`. They are not proposed launch-menu records and do not approve real business data.

## 2. Priority 1 — Schema and core integrity

### CAT-CLAR-01 — Catalog Code namespace

**Status:** `RESOLVED_OWNER_CONFIRMED`

**Recorded decision:** `ODB-CAT-27`

1. **Resolved question:** Within one Brand, do Category, Product, and Product Variant use separate Code namespaces, or one shared namespace across all three entity types?
2. **Related decisions:** `ODB-CAT-16`, `ODB-CAT-18`, `ODB-CAT-22`, `ODB-CAT-27`.
3. **Current confirmed policy:** Codes are Brand-scoped, use canonical uppercase ASCII input rules, remain reserved while archived, and are not reused after archive.
4. **Owner-confirmed answer:** Option A. Category, Product, and Variant use separate namespaces within each Brand. The same Code may occur once in each type; same-type/same-Brand duplicates are rejected.
5. **Technical consequence:** Three per-entity Brand-scoped unique constraints are proposed. This is an implementation detail, not part of the Owner authorization.

**Synthetic example:** In `BRAND-A`, a Category already has Code `LATTE`. May a Product or Variant in the same Brand also use `LATTE`?

| Option | Meaning | Advantages | Disadvantages |
|---|---|---|---|
| A — Separate namespaces | Category `LATTE`, Product `LATTE`, and Variant `LATTE` may coexist in the same Brand; duplicates are prohibited only within the same entity type. | Simple three-table unique indexes; matches current logical ERD/Data Dictionary proposals; no identifier registry. | Operators and support tools must always include entity type; cross-type ambiguity is possible. |
| B — One shared namespace | Only one Category, Product, or Variant in a Brand may own `LATTE`. | Globally unambiguous Catalog reference within a Brand; one durable reservation policy. | Requires a registry/supertype or equivalent shared unique relation; more transaction and deletion-reservation complexity. |

**Resolution note:** Option A was selected by the Owner and recorded as `ODB-CAT-27`. Option B is retained only as historical preparation and is not the selected policy. Exact indexes, constraint names, migrations, and error mapping remain `TECHNICAL_PROPOSAL` and unimplemented.

**Downstream effects:** Catalog table/index design, uniqueness conflicts, archive/retention reservation, restore, import/export identifiers, and error mapping.

**What the answer does not authorize:** It does not authorize tables, indexes, migrations, menu data, APIs, or identifier-deletion behavior.

### CAT-CLAR-02 — Valid Default Variant eligibility

**Status:** `RESOLVED_OWNER_CONFIRMED`

**Recorded decisions:** `ODB-CAT-28`, `ODB-CAT-38`

1. **Resolved question:** For an Active Product, which Variant lifecycle states qualify for the required Default Variant?
2. **Related decisions:** `ODB-CAT-04`, `ODB-CAT-19`, `ODB-CAT-20`, `ODB-CAT-23`, `ODB-CAT-25`, `ODB-CAT-28`, `ODB-CAT-31`, `ODB-CAT-38`.
3. **Current confirmed policy:** Every Product has at most one Variant with `is_default = true`. Draft, Inactive, and Archived Products may have zero or one. An Active Product has exactly one, and that Variant must be Active. Default designation, lifecycle status, and customer visibility are independent.
4. **Owner-confirmed answer:** Option A. The valid Default must have `is_default = true` and lifecycle status Active. Visibility is independent; hidden Active is valid, while Inactive or Archived is not.
5. **Technical consequence:** `ODB-CAT-38` confirms the all-lifecycle at-most-one predicate; `ODB-CAT-28` supplies the additional Active-status eligibility predicate for Active Products. Visibility enters neither predicate. Enforcement remains unimplemented.

The three concepts must remain distinct:

- `is_default`: at most one designation for every Product; exactly one when the Product is Active.
- Variant lifecycle: whether the Variant is Active, Inactive, or Archived.
- `customer_visible`: whether the customer must see/select the Variant; hidden does not mean inactive.

| Option | Valid Default rule | Advantages | Disadvantages |
|---|---|---|---|
| A — Active required | The Default designation qualifies only when its Variant is lifecycle-Active. Hidden Active Defaults are allowed. | Active Product always resolves to an operational Variant; clear activation and archive guard; simplest integrity predicate. | Deactivating the Default requires an atomic switch or Product deactivation first. |
| B — Active or Inactive allowed | Archived is invalid, but an Inactive Variant may remain the Default. | Preserves designation during temporary Variant suspension. | Active Product can point to a Variant declared unavailable; “valid Default” becomes operationally confusing. |
| C — Any persisted state allowed | Default designation alone satisfies completeness, including Archived. | Minimal coupling between lifecycle and designation. | Conflicts with long-term retirement semantics and permits an Active Product to default to an Archived Variant. |

**Resolution note:** Option A was selected by the Owner and recorded as `ODB-CAT-28`. `ODB-CAT-38` later confirmed zero-or-one designation for Draft, Inactive, and Archived Products and preserved exactly one Active designated Variant for Active Products. Options B and C are retained only as historical preparation. Neither decision approves a trigger, index, lock protocol, lifecycle command, creation state, transition matrix, restoration target, or Category policy.

**Consequences to confirm:**

- Inactive Default under an Active Product: invalid under Option A; valid under Option B.
- Archived Default under an Active Product: invalid under Options A and B.
- Hidden Active Default: valid under all options unless the Owner separately changes visibility policy.
- Active non-Default Variant: valid and does not affect the exactly-one Default count.

**Downstream effects:** Default partial index shape, deferred trigger predicate, Product activation, Default switching, Variant deactivate/archive/restore, lock ordering, and concurrency tests.

**What the answer does not authorize:** It does not authorize the trigger, activation, Default switching, lifecycle commands, or customer publication.

### CAT-CLAR-03 — Category eligibility and guards

**Status:** `RESOLVED_OWNER_CONFIRMED`

**Recorded decision:** `ODB-CAT-29`

1. **Resolved questions:** Must an Active Product belong to an Active Category, and what happens when a Category with assigned Products is deactivated?
2. **Related decisions:** `ODB-CAT-02`, `ODB-CAT-03`, `ODB-CAT-15`, `ODB-CAT-21`, `ODB-CAT-25`, `ODB-CAT-29`.
3. **Current confirmed policy:** Categories are flat; every Product always has one Category; Category Deactivate and Archive are distinct; archive is blocked while Active Products remain assigned.
4. **Owner-confirmed answers:** Product activation requires its assigned Category to be Active. Category Deactivation is blocked while any Active Products remain assigned.
5. **Technical consequence:** Product activation and Category Deactivation must eventually be enforced atomically under a reviewed lock/constraint design; no mechanism is implemented.

| Option | Activation and deactivation rule | Advantages | Disadvantages |
|---|---|---|---|
| A — Active Category required | Product activation requires Active Category; Category deactivation is blocked while Active Products remain assigned. The option does not itself define reassignment or rules for other Product states. | Coherent active hierarchy; no Active Product under an unavailable Category; clear database/application guard. | Operators must address Active Products before temporarily suspending a Category. |
| B — Activation requires Active Category, but later Category deactivation may coexist with Active Products | Activation starts consistently; Category suspension can hide/group Products without changing Product state. | Flexible temporary Category control. | Creates an Active Product under an Inactive Category after the fact; effective sellability semantics require another rule. |
| C — Category state does not constrain Product state | Draft, Inactive, and Active Products may remain under Inactive Category; only confirmed archive guard applies. | Maximum independence; fewer cross-row lifecycle locks. | Category lifecycle meaning becomes weak and consumers must separately interpret Category and Product state. |

**Resolution note:** Option A was selected and recorded as `ODB-CAT-29`. Category Deactivation remains separate from Category Archive under `ODB-CAT-25` and Branch availability under `ODB-CAT-06`. The decision does not approve Product reassignment, Category Archive behavior with Inactive Products, lifecycle commands, locks, triggers, or authorization implementation.

**Synthetic example:** Category `SEASONAL` is Active and contains Active Product `P-100`. It cannot be deactivated while `P-100` remains Active. No Product-reassignment workflow is implied.

**Downstream effects:** Product activation predicate, Category deactivate/archive commands, same-transaction locking, deferred database integrity scope, and race tests.

**What the answer does not authorize:** It does not authorize Product activation, Category commands, reclassification, publication, or audit/authorization implementation.

## 3. Priority 2 — Lifecycle creation and transitions

### CAT-CLAR-04 — Category creation state

**Status:** `RESOLVED_OWNER_CONFIRMED`

**Recorded decision:** `ODB-CAT-30`

1. **Resolved question:** What lifecycle state does a new Category enter?
2. **Related decisions:** `ODB-CAT-21`, `ODB-CAT-25`, `ODB-CAT-30`, `ODB-CAT-32`.
3. **Owner-confirmed answer:** A new Category is Draft. Activation is a separate validated and authorized action.
4. **Technical boundary:** Database defaults, commands, validation, authorization, audit, and concurrency remain unimplemented technical work.

| Option | Consequence | Advantages | Disadvantages |
|---|---|---|---|
| A — Create Active | Category can immediately participate wherever Active Category is required. | Fewer operational steps. | Accidental or incomplete Categories may become usable immediately; creation itself becomes a lifecycle activation. |
| B — Create Inactive | Category requires a later explicit Activate action before active use. | Safer staged setup; clear review boundary. | Adds an activation step and its authority/audit requirements. |

**Historical alternatives:** The earlier Active/Inactive options did not include Draft. `ODB-CAT-30` supersedes them with the Owner-confirmed Draft creation state.

**Downstream effects:** Category status default/nullability, create/activate commands, factories, Product activation, audit taxonomy, and tests.

**What the answer does not authorize:** It does not authorize Category creation, activation, schema defaults, factories, or audit events.

### CAT-CLAR-05 — Variant creation state

**Status:** `RESOLVED_OWNER_CONFIRMED`

**Recorded decision:** `ODB-CAT-31`

1. **Resolved question:** What lifecycle state does a new Variant enter?
2. **Related decisions:** `ODB-CAT-04`, `ODB-CAT-19`, `ODB-CAT-20`, `ODB-CAT-23`, `ODB-CAT-25`, `ODB-CAT-28`, `ODB-CAT-31`, `ODB-CAT-32`.
3. **Owner-confirmed answer:** A new Variant is Draft. Activation is separate and subject to validation and authorization.
4. **Independence rule:** `is_default`, lifecycle `status`, and `customer_visible` remain independent; `ODB-CAT-28` is unchanged.
5. **Technical boundary:** Field defaults, commands, validation, audit, constraints, and concurrency remain unimplemented.

| Option | Consequence | Advantages | Disadvantages |
|---|---|---|---|
| A — Create Active | Variant is immediately eligible if `CAT-CLAR-02` requires Active status. | Fewer steps when building a Product for activation. | Creation may unintentionally make the Variant operational; harder staged review. |
| B — Create Inactive | Variant must be explicitly activated before becoming eligible. | Safe staging; separates persistence from operational readiness. | Requires an activation transition and atomic coordination when activating a Product. |

**Historical alternatives:** The earlier Active/Inactive options did not include Draft. `ODB-CAT-31` supersedes them with the Owner-confirmed Draft creation state.

**Synthetic example:** Draft Product `P-100` receives Draft Variant `LARGE`. Visibility and Default designation do not make it Active or eligible to satisfy `ODB-CAT-28`.

**Downstream effects:** Variant status default, Product activation transaction, Default selection, create/activate audit, factories, and lifecycle tests.

**What the answer does not authorize:** It does not authorize Variant creation, activation, Default assignment, customer visibility, schema, or factories.

### CAT-CLAR-06 — Category and Variant transition matrix

**Status:** `RESOLVED_OWNER_CONFIRMED`

**Recorded decision:** `ODB-CAT-32`

1. **Resolved question:** Which Category/Variant transitions and restore targets are permitted?
2. **Related decisions:** `ODB-CAT-21`, `ODB-CAT-25`, `ODB-CAT-28`–`ODB-CAT-32`.
3. **Owner-confirmed answer:** Category and Variant share the following matrix. No other transition is inferred.

| From | To | Policy |
|---|---|---|
| Draft | Active | Allowed after validation. |
| Draft | Inactive | Not allowed. |
| Draft | Archived | Allowed, subject to applicable archive guards. |
| Active | Inactive | Allowed, subject to applicable business guards. |
| Inactive | Active | Allowed after validation. |
| Active | Archived | Allowed, subject to applicable archive guards. |
| Inactive | Archived | Allowed, subject to applicable archive guards. |
| Archived | Inactive | Allowed through Restore and validation. |
| Archived | Active | Not allowed directly. |

Archived Category and Variant restore to Inactive. Activation after Restore is separate. Existing Category/Product and Default Variant guards in `ODB-CAT-25`, `ODB-CAT-28`, and `ODB-CAT-29` remain unchanged. No additional guard is inferred, including no new rule for Category Archive when only Inactive Products remain assigned.

**Authority and audit:** All Category/Variant state changes retain the already-confirmed Owner/explicit-delegate authority and audit requirement. This question does not reopen that decision.

**Downstream effects:** State checks, command set, restoration validation, audit taxonomy, authorization capability, locks, and transition/concurrency specs.

**What the answer does not authorize:** It does not authorize lifecycle commands, Identity, delegation implementation, audit schema changes, or generic status mutation.

### CAT-CLAR-07 — Product restoration authority

**Status:** `RESOLVED_OWNER_CONFIRMED`

**Recorded decision:** `ODB-CAT-33`

1. **Resolved question:** Who may restore an Archived Product to Inactive?
2. **Related decisions:** `ODB-CAT-03`, `ODB-CAT-24`, `ODB-CAT-33`.
3. **Owner-confirmed answer:** The Owner or personnel explicitly delegated by the Owner.
4. **Preserved outcome:** Archived Product restores to Inactive; activation is separate.
5. **Technical boundary:** Delegation representation, permission schema, trusted authorization, command, audit, and validation implementation remain unresolved/proposed.

| Option | Authority | Advantages | Disadvantages |
|---|---|---|---|
| A — Owner only | Only Owner may restore Product. | Strongest control; simple policy. | Operational bottleneck. |
| B — Owner or explicit delegate capability | Owner may grant a narrowly scoped Product-restore capability with expiry/revocation. | Operational flexibility without job-title inference. | Depends on trusted authorization/delegation design and audit evidence. |
| C — Defer Product restoration | No restoration command in the current milestone. | Avoids premature authority/Identity coupling. | Archived Product remains unavailable until later work. |

**Resolution note:** The Owner selected Owner-or-explicit-delegate authority. The historical recommendation to defer the command remains an implementation-scope recommendation, not a business-policy limitation.

**Downstream effects:** Product restore command, trusted authorization context, delegation, Brand-scoped audit, validation, error catalog, and tests.

**What the answer does not authorize:** It does not authorize Product restoration, delegation, Identity/Milestone 2B, or audit redesign.

## 4. Priority 3 — Future identifier and deletion policy

### CAT-CLAR-08 — SKU normalization

**Status:** `RESOLVED_OWNER_CONFIRMED` (MVP; future SKU semantics remain separate)

**Recorded decision:** `ODB-CAT-34`

1. **Resolved MVP question:** Is SKU supported in Catalog Core MVP?
2. **Related decisions:** `ODB-CAT-17`, `ODB-CAT-18`, `ODB-CAT-22`, `ODB-CAT-34`.
3. **Owner-confirmed answer:** No SKU input, normalization, canonicalization, or validation is included in Catalog Core MVP.
4. **Preserved future policy:** SKU remains optional and Brand-unique when present, but exact normalization remains unresolved for a future scope and does not inherit Catalog Code rules.
5. **Technical boundary:** No SKU schema/input work is authorized.

| Option | Proposed semantics | Advantages | Disadvantages |
|---|---|---|---|
| A — Strict ASCII canonical SKU | Trim; blank becomes null/rejected as input; uppercase; restricted ASCII character set chosen explicitly; store canonical value. | Predictable scanning/imports; simple unique index; avoids Unicode lookalikes. | May reject supplier or external SKUs containing other characters. |
| B — Unicode-aware, case-insensitive SKU | Trim; normalize Unicode to an approved form; case-fold; store raw plus canonical projection. | Supports broad external identifiers. | More complex Ruby/PostgreSQL equivalence, migration, debugging, and dependency maintenance. |
| C — Trimmed case-sensitive opaque SKU | Trim; preserve case/characters; exact stored bytes determine uniqueness. | Simple storage; preserves external form. | `abc` and `ABC` differ; Unicode-equivalent strings and lookalikes can collide operationally. |
| D — Defer SKU support | Require `sku IS NULL` and accept no SKU input. | No invented equality; smallest safe foundation. | SKU-dependent integrations cannot start. |

**Resolution note:** Option D was selected for Catalog Core MVP. Options A–C remain historical future-scope alternatives only; none is approved.

**Future-scope questions:** case sensitivity, trim/blank behavior, Unicode policy, allowed characters, canonical storage, and database equality must be separately decided before SKU support.

**Downstream effects:** Variant column/check/index, input errors, imports, scanning, archive reservation, restoration, and collision migration.

**What the answer does not authorize:** It does not authorize non-null SKU storage, dependencies, scanner integration, migrations, or production data cleanup.

### CAT-CLAR-09 — Catalog retention mechanism and identifier reservation

**Status:** `RESOLVED_OWNER_CONFIRMED` (MVP; future policy changes require a separate decision)

**Recorded decisions:** `ODB-CAT-35`, `ODB-CAT-36`, `ODB-CAT-37`

1. **Resolved MVP question:** How are Category, Product, and Variant retired and retained in Catalog Core MVP?
2. **Related decisions:** `ODB-CAT-18`, narrowed `ODB-CAT-26`, `ODB-CAT-35`–`ODB-CAT-37`, and global `ODB-DATA-01`.
3. **Owner-confirmed MVP mechanism:** Retain rows through lifecycle states, including Archive. Do not introduce Soft Delete, `deleted_at`, a universal default scope, or Purge.
4. **Owner-confirmed identifier reservation:** Catalog Codes and SKUs are never reused after Archive or after any separately authorized future Soft Delete. Soft Delete is not authorized now.
5. **Owner-confirmed Purge boundary:** Physical Purge is prohibited for Draft, Active, Inactive, and Archived Catalog records in MVP. Missing dependencies do not grant permission.

| Option | Behavior | Advantages | Disadvantages |
|---|---|---|---|
| A — Lifecycle/Archive retention only | Preserve Catalog rows through Draft/Active/Inactive/Archived lifecycle; expose no Soft Delete or Purge. Archived identifiers remain reserved under `ODB-CAT-18`. | Smallest and clearest first foundation; no hidden default scope; preserves history and identifiers. | Does not provide a separate “deleted Draft” state or removal mechanism. |
| B — Entity-specific Soft Delete | Retain selected Catalog rows with an explicit deleted marker; separately decide restoration and whether deleted rows remain in Code/SKU uniqueness. | Can distinguish withdrawn setup data without physical removal. | Adds another lifecycle dimension, default-scope risks, restoration rules, and uniqueness complexity. |
| C — Future Purge after classification | Permit Purge only for a separately classified transient/non-important Catalog record under approved eligibility, authority, schedule, and dependency proof. | Supports eventual cleanup where justified. | No Catalog class is currently confirmed transient; creates audit/support, identifier-reuse, concurrency, and legal/privacy questions. |

**Resolution note:** Option A was selected for Catalog Core MVP. Future Soft Delete or Purge requires a separate Owner Decision; neither can be inferred from this document.

**Future-scope questions deliberately open:** technical uniqueness participation/mechanism for a future Soft Delete, restoration behavior for such a future state, and identifier reuse after a hypothetical physical deletion of a Draft record. No physical deletion is permitted in the current MVP.

**Downstream effects:** lifecycle design, default scopes, unique indexes/identifier registry, restore commands, audit/support history, privacy/retention review, and any future cleanup design.

**What the answer does not authorize:** It does not authorize Soft Delete fields, default scopes, Purge, tombstones, identifier reuse, cleanup jobs, dependency cleanup, or legal/privacy conclusions.

## 5. Dependency and prioritization summary

| Capability or design step | Required clarification | Can remain open when |
|---|---|---|
| Choose Catalog Code constraints | `CAT-CLAR-01` resolved by `ODB-CAT-27` | Business namespace is closed; three per-entity Brand-scoped constraints remain proposed and unimplemented. Organization/Brand/Branch Code rules are unaffected. |
| Implement full Category/Product/Variant persistence | Business creation/lifecycle predicates are closed by `ODB-CAT-30`–`ODB-CAT-32`; technical design/review and authorization remain | No implementation is authorized. |
| Implement Active Product Default integrity trigger | Eligibility and relevant lifecycle transitions are resolved; technical concurrency proof remains | No Product activation/completeness trigger is implemented. |
| Implement Product activation | Excluded from initial MVP by `ODB-CAT-39`; future policy requires separate scope | Product activation remains unavailable. |
| Implement Category/Variant lifecycle commands | Business matrix is resolved by `ODB-CAT-32`; trusted authority/audit design and technical concurrency remain | Lifecycle commands remain unavailable. |
| Implement Product restoration | Excluded from initial MVP by `ODB-CAT-39`; `ODB-CAT-24`/`33` remain future-policy context | Restore command remains unavailable and unauthorized. |
| Reassign Product Category | Unsupported in MVP by `ODB-CAT-41` | No command/API; any future capability requires separate Owner Decision and scope. |
| Implement non-null SKU support | Future SKU semantics require a new decision after `ODB-CAT-34` deferral | SKU is out of Catalog Core MVP and no input is accepted. |
| Catalog retention/Soft Delete behavior | MVP lifecycle/Archive retention is resolved by `ODB-CAT-35`; future policy changes require a new decision | No Soft Delete or Purge exists. |
| Implement Catalog Purge | Prohibited in MVP by `ODB-CAT-37`; future change requires a separate Owner Decision | Purge remains prohibited/unavailable for every lifecycle state. |

### 5.1 Dependency order

1. `CAT-CLAR-01` through `CAT-CLAR-09` are closed by `ODB-CAT-27` through `ODB-CAT-37`; `ODB-CAT-38` additionally closes all-lifecycle Default designation cardinality under `CAT-CLAR-02`.
2. Translate the closed business predicates into reviewed technical constraints, commands, locking, authorization, audit, and concurrency evidence.
3. Keep SKU input, Soft Delete, and Purge outside Catalog Core MVP.
4. Obtain separate implementation authorization only after the technical readiness blockers are closed and reassessed.
5. Preserve Product lifecycle/reassignment exclusions and Variant Archive/Restore flag preservation from `ODB-CAT-39`–`ODB-CAT-41`.

The Organization/Brand/Branch reference foundation identified by the Readiness Review does not depend on the six remaining Catalog questions. It still requires separate implementation authorization, and operational Branch FK validation still requires target-environment inventory and authoritative mapping.

## 6. Existing policy already answered and not reopened

`CAT-CLAR-01` through `CAT-CLAR-09` are answered by `ODB-CAT-27` through `ODB-CAT-37`, with `ODB-CAT-38` completing Default designation cardinality, and must not be asked again for the confirmed MVP scope. The following portions are already answered and must not be reopened:

- Codes are canonical uppercase ASCII under `ODB-CAT-22`; separate Category/Product/Variant namespaces are confirmed by `ODB-CAT-27`.
- Archived records retain identifiers under `ODB-CAT-18`; `ODB-CAT-36` also reserves Code/SKU after any future Soft Delete without authorizing Soft Delete. Reuse after hypothetical physical Draft deletion remains unspecified.
- Every Product has at most one designated Default. Draft, Inactive, and Archived permit zero or one; Active requires exactly one and it must be Active. Default designation, lifecycle status, and customer visibility remain independent; hidden Active is valid (`ODB-CAT-20`, `ODB-CAT-23`, `ODB-CAT-28`, `ODB-CAT-31`, `ODB-CAT-38`).
- Product activation requires an Active assigned Category, and Category Deactivation is blocked while Active Products remain assigned (`ODB-CAT-29`). Deactivation remains distinct from Archive and Branch availability.
- Draft Product may have zero Variants and zero Defaults under `ODB-CAT-19`.
- Category and Variant are created Draft and follow the exact matrix in `ODB-CAT-30`–`ODB-CAT-32`.
- Product restore target is Inactive under `ODB-CAT-24`; Owner-or-explicit-delegate authority is confirmed by `ODB-CAT-33`.
- SKU is deferred from MVP by `ODB-CAT-34`; future normalization remains undecided.
- Catalog Core MVP uses lifecycle/Archive retention, no Soft Delete, and no Purge in any lifecycle state (`ODB-CAT-35`–`ODB-CAT-37`).
- Product Activate, Deactivate, Archive, and Restore commands/APIs are excluded from initial MVP (`ODB-CAT-39`).
- Variant Archive/Restore changes status only and preserves `is_default` and `customer_visible`; reactivation is separate (`ODB-CAT-40`).
- Product Category reassignment is unsupported in MVP (`ODB-CAT-41`).

## 7. Future-scope decision boundary

Future SKU semantics, future Soft Delete mechanics/restoration/uniqueness, Product lifecycle commands, Product Category reassignment, identifier reuse after hypothetical physical Draft deletion, and any future Catalog Purge policy require separate Owner Decisions. They are not unfinished CAT-CLAR-04 through CAT-CLAR-09 answers.

## 8. Final boundary

The readiness verdict remains `NOT_READY`. Clarifications and initial scope are synchronized through `ODB-CAT-41`, but no decision authorizes implementation. `ODB-DATA-01` remains the global retention principle; all implementation mechanisms remain `TECHNICAL_PROPOSAL` or unimplemented.

No Identity/Milestone 2B, production access, schema, migration, model, command, factory, seed, API, frontend, deployment, commit, push, or merge is authorized or performed by this preparation.
