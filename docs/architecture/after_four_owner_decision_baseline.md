# AFTER FOUR — Owner Decision Baseline

**Status:** Canonical source of truth for Owner-confirmed business decisions  
**Date recorded:** 2026-11-14  
**Latest decision update:** 2026-11-16
**Scope:** Owner-confirmed business, planning and project-wide architecture decisions that constrain later implementation

This baseline records Owner decisions supplied after the earlier repository consistency audit. It does not claim that these decisions were already present in the repository before this document was created.

**Provenance for decisions with an `ODB-` identifier:** Owner-confirmed project discussion supplied in the Owner Decision Baseline Reconciliation task, except where a later section records a more specific Owner approval source.

**Classification for every `ODB-` row:** `OWNER_CONFIRMED`. Package C0 decisions use their explicit row status: `OWNER_CONFIRMED` or `DEFERRED`. The separate Implementation column records implementation state and must not be read as the approval classification.

Owner approval and implementation are separate dimensions:

- `OWNER_CONFIRMED`: the stated business direction is approved within its explicit boundary.
- `IMPLEMENTED`: executable behavior exists. This does not approve unstated policy or production use.
- `NOT_YET_MIGRATED`: existing source predates a later architecture rule and has no authorized/evidenced migration.
- `UNVERIFIED`: conformance or implementation evidence has not been assessed.
- `DOCUMENTED_PROPOSAL`: an architecture or technical recommendation, not an Owner decision.
- `TECHNICAL_PROPOSAL`: a proposed implementation mechanism, not an approved business rule or implemented control.
- `DEFERRED`: an explicitly identified decision intentionally postponed by the Owner; no option or replacement policy is approved.
- `UNRESOLVED_OWNER_DECISION`: an Owner choice is still required; no technical recommendation may silently decide it.
- `UNRESOLVED`: a decision remains genuinely open.
- `CONTRADICTORY`: current repository sources disagree with the baseline or implementation evidence.
- `HISTORICAL`: a preserved earlier proposal or question that is no longer implementation authority.
- `PROPOSED_CAPABILITY`: a candidate capability or mechanism for satisfying confirmed scope; its detailed behavior is not Owner-approved merely because it is listed.
- `UNDECIDED`: a business rule requiring a future explicit Owner decision.
- `EXISTING_DECISION_PRESERVED`: an earlier Owner-confirmed decision that remains authoritative and is not reopened by later scope confirmation.
- `NOT_AUTHORIZED`: implementation, approval, or production authority has not been granted.

## ODB category and identifier governance

**Source:** Owner's explicit approval of the ODB Category and Identifier Principles on 2026-11-16.

The Owner Decision Baseline is the canonical register for `ODB-*` decisions and category tokens. An ODB category is a governance decision-ownership area only. It does not establish a Bounded Context, module, service, database, runtime dependency, or implementation boundary, and it does not alter the current approval status of the DDD topology.

### Category registry

Category tokens are unique within the ODB namespace. The registry is:

| Category | Decision-ownership scope |
|---|---|
| `ARCH` | Project-wide architecture decisions. |
| `PLN` | Product identity and launch-planning decisions. |
| `OP` | Ordering, Payment, Preparation-dispatch, cancellation, and related operating-policy decisions. |
| `CASH` | Cash handling, float, Cash Session, and handover decisions. |
| `EXP` | Expense authority, limits, approval, and evidence decisions. |
| `RPT` | Reporting direction and accountability decisions. |
| `CAT` | Catalog and Pricing decisions. |
| `DATA` | Global data-retention and deletion principles. |
| `CUST` | Customer Management decisions, including Customer identity, privacy, consent, Profile, and Customer-history policy. |
| `LOY` | Basic Loyalty decisions, including Loyalty ledger, qualification, earning, redemption, adjustment, reversal, and reconciliation policy. |
| `PROMO` | Advanced Promotions & Discount Engine decisions, including Promotion eligibility, rule evaluation, Voucher, stacking, priority, limits, discount application, and Promotion lifecycle policy. |

The `CUST`, `LOY`, and `PROMO` category approvals do not allocate an ID to any current provisional reference or approve any unresolved Customer, Loyalty, or Promotion policy. Customer identity and privacy remain distinct from Loyalty ledger behavior; Loyalty qualification and reward policy remain distinct from Promotion eligibility and discount rules. Catalog/Pricing retains ownership of authoritative base Product/Variant pricing, and Ordering retains responsibility for confirmed Order snapshots.

### Primary Owner classification

A cross-domain decision is recorded once under the category owning its principal business policy, behavior, or data. Other affected domains are recorded through explicit cross-references; those references do not create duplicate canonical decisions. A cross-domain decision is not automatically split. Separate linked decisions are appropriate only when each expresses an independently meaningful policy or business decision. If the Primary Owner cannot be established from approved decision boundaries, ownership remains unresolved until the Owner explicitly determines it.

This is a governance classification rule, not a runtime authorization, DDD topology decision, or implementation design. It does not move or redefine existing Catalog, Pricing, Customer, Loyalty, Promotion, Ordering, Payment, or other domain responsibilities.

### Identifier format and allocation

Canonical IDs use `ODB-<CATEGORY>-<SUFFIX>`. The suffix is a positive decimal integer rendered with a minimum width of two digits: `01` through `99`, followed by `100`, `101`, and so forth. Allocation and comparison are numeric, not lexical. The convention applies consistently across ODB categories, and every existing canonical ID retains its current spelling.

The Owner retains authority to approve category tokens and each canonical ODB ID allocation. Proposing or collision-checking an ID, adding a draft or cross-reference, or editing documentation does not make the ID canonical and does not allocate or reserve it. Allocation requires this controlled procedure:

1. Identify the decision requiring a canonical ID.
2. Confirm that the target category is present in the canonical category registry.
3. Propose the exact full canonical ID, including its numeric suffix under the approved minimum-width convention.
4. Search the complete repository for full-ID collisions and inspect historical governance records to verify that the proposed ID has never previously been allocated or published in that category.
5. Obtain explicit Owner approval of that exact proposed full ID and its allocation to the identified decision.
6. Only after approval, record the canonical decision, its scope and status, Owner approval provenance, allocation date, and required crosswalk information in this baseline.
7. Review every affected canonical and historical reference before completing the documentation change.

No automated allocator, reservation, or implicit next-ID rule is established by this procedure.

### Identity, history, and cross-document integrity

A published canonical ID is immutable and must never be renumbered, reassigned, or reused. Amendment, narrowing, withdrawal, rejection, or supersession preserves the original ID and provenance. A later decision must identify its relationship to the earlier decision; documentation must not silently change the meaning of an approved decision. Historical records are retained and clearly classified rather than deleted or rewritten as if the earlier state never existed.

Before a provisional reference can become canonical, its crosswalk must record the existing provisional reference, approved canonical ID, Owner approval provenance, allocation date, affected canonical documents, and treatment of historical references. Historical documents may retain the provisional reference where provenance requires it, while current canonical documents use the approved ID and preserve a traceable mapping. A blank or proposed canonical field is not an allocation.

Every future allocation or amendment review must verify full-ID uniqueness, category validity, crosswalk consistency, affected canonical references, required historical-reference preservation, and absence of a duplicate canonical decision. The review must report unresolved ownership or reference conflicts rather than choosing a convenient classification.

## Project-wide architecture

**Source for `ODB-ARCH-01`:** Owner's explicit project-wide Layered DDD adoption decision on 2026-11-15.

| ID | Owner-confirmed decision | Implementation | Repository evidence / remaining boundary |
|---|---|---|---|
| `ODB-ARCH-01` | Layered DDD is mandatory for all AFTER FOUR source code created or modified from 2026-11-15 onward. Domain, Application, Infrastructure and Presentation responsibilities and dependencies follow [ADR-0011](adr/0011-project-wide-layered-ddd.md). Existing code is not automatically authorized for wholesale refactoring; relevant migration requires an explicitly authorized scope. | `IMPLEMENTED` for the A1 Organization/Brand/Branch reference foundation only. Other existing contexts are `NOT_YET_MIGRATED` or `UNVERIFIED`. | This is a forward-compliance architecture decision, not proof of repository-wide conformance, production readiness, a cross-context interface, or authorization to refactor unrelated code. |

## 1. Product and launch planning

Planning assumptions guide scenario design and later validation. They are not capacity guarantees, concurrency limits, service objectives, or production topology approvals.

| ID | Owner-confirmed decision | Implementation | Repository evidence / remaining boundary |
|---|---|---|---|
| `ODB-PLN-01` | The Brand is AFTER FOUR. | Present in repository naming. | Product identity only. |
| `ODB-PLN-02` | AFTER FOUR is an internal chain-first cafe management product, not SaaS. | Documented. | [Business Domain Model §1.2](after_four_business_domain_model.md#12-product-boundary). |
| `ODB-PLN-03` | Initial launch planning assumes one main Branch. | Not implemented as a production limit. | Future design retains multi-Branch meaning. |
| `ODB-PLN-04` | Initial launch planning assumes four Employees. | Not implemented as a limit. | Does not limit Users, shifts, or future staffing. |
| `ODB-PLN-05` | Initial launch planning assumes one POS Device. | Frontend prototype only. | Does not approve device enrollment or production topology. |
| `ODB-PLN-06` | Expected operation uses two to three shifts per operating day with Employee rotation. | Not implemented. | Shift and handover design must preserve individual accountability. |
| `ODB-PLN-07` | Planning peak is 40–60 Orders per hour. | Not load-tested. | Forecast input only; no concurrency/SLO conclusion follows. |
| `ODB-PLN-08` | Planning Order mix is approximately 80% dine-in and 20% takeaway. | Channels exist in Phase 1. | Mix is not a quota or validation rule. |
| `ODB-PLN-09` | Planning Payment mix is approximately 70% bank transfer and 30% cash. | Methods exist in Phase 1. | Mix is not provider or capacity approval. |

## 2. Ordering and Payment

| ID | Owner-confirmed decision | Implementation | Repository evidence / remaining boundary |
|---|---|---|---|
| `ODB-OP-01` | A customer chooses dine-in or takeaway without providing a reason. | Implemented channel vocabulary. | No reason field is required for channel selection. |
| `ODB-OP-02` | Full verified Payment must be persisted before Preparation Dispatch for dine-in and takeaway. | Implemented in Phase 1. | [Phase 1 §4](after_four_order_payment_implementation_phase1.md#4-atomic-safety-boundary). |
| `ODB-OP-03` | Pending, unknown, failed, or unverified Payment cannot dispatch Preparation. | Implemented in Phase 1. | Payment and Dispatch guards remain independent of client display state. |
| `ODB-OP-04` | Late successful Payment for a Held or Expired Order is recorded and reconciled but never automatically dispatches or reactivates the Order. | Implemented in Phase 1. | Opens an attributed review case. |
| `ODB-OP-05` | A paid Order whose Preparation Dispatch fails is retryable without another charge or duplicate Dispatch. | Dispatch intent/requeue implemented; delivery deferred. | Retry reuses Dispatch and Outbox identities. |
| `ODB-OP-06` | Pending Orders use a configurable expiration timeout with a five-minute default. | Implemented. | The default is not an immutable permanent policy. |
| `ODB-OP-07` | MVP bank transfer uses the Owner's bank QR. | Not implemented. | Account/QR material and secure operational handling remain outside current code. |
| `ODB-OP-08` | A bank notification speaker announces an amount as an alert only; it is not proof of Payment. | Not implemented. | No speaker integration or authority is approved. |
| `ODB-OP-09` | The cashier manually compares the announced/observed amount with the pending Order and explicitly confirms it in POS. No automatic bank API matching is approved for MVP. | Manual confirmation command exists; UI/integration is not active. | Actor authentication and Branch authorization remain prerequisites. |
| `ODB-OP-10` | An amount mismatch is not confirmed by default. It must be resolved or appropriately refunded; any exception requires Owner or explicitly authorized approval, reason, and audit. | Default mismatch rejection implemented. | Exception roles, resolution transaction, and refund method remain `UNRESOLVED`. |
| `ODB-OP-11` | Overpayment must be evidenced and the excess refunded through an appropriate method. Excess is not revenue. Evidence includes amount, method, reason, actor/approver, time, and linked Payment/Order. | Not implemented. | Evidence model, refund method, allocation, and provider behavior require separate design. Phase 1 remains exact-balance-only. |
| `ODB-OP-12` | Staff may cancel a paid Order with reason and audit before Preparation starts. | Not implemented. | Requires an atomic Preparation-state fence and refund/compensation coordination. |
| `ODB-OP-13` | Once Preparation has started, cancellation requires Owner approval. | Not implemented. | Prepared-item, refund, stock, and compensation outcomes remain to be designed. |
| `ODB-OP-14` | Completed Orders use a separate exception process. | Not implemented. | Exact authority and outcomes remain `UNRESOLVED`. |
| `ODB-OP-15` | Payment and Payment Attempt are distinct concepts. | Implemented. | [Glossary](../../GLOSSARY.md) and [Payment Model](after_four_payment_model.md). |
| `ODB-OP-16` | Unknown Payment Attempts require authoritative reconciliation; they must not be blindly retried or replaced with another charge. | State model documented; provider reconciliation not implemented. | Provider/method contract remains `UNRESOLVED`. |

## 3. Cash Management and Expenses

The **Operating Day** boundary used for daily limits and reporting is not yet defined. That missing boundary does not change the approved amounts or authority below.

| ID | Owner-confirmed decision | Implementation | Repository evidence / remaining boundary |
|---|---|---|---|
| `ODB-CASH-01` | One shared physical cash drawer is planned. | Not implemented. | Every movement still retains its individual actor. |
| `ODB-CASH-02` | The shared float is 2,000,000 VND per Operating Day. | Not implemented. | Configurable policy value; not a per-shift grant. |
| `ODB-CASH-03` | The daily float carries across shifts. A new Cash Session may record a new opening count without creating a new daily float allocation. | Not implemented. | Handover must retain prior-session accountability. |
| `ODB-CASH-04` | The system must not automatically reset or top up cash to 2,000,000 VND during the day. | Not implemented. | No implicit Cash Transaction is allowed. |
| `ODB-CASH-05` | Opening shift checks cash sufficiency and notifies the Owner when short. | Not implemented. | No discrepancy tolerance is approved. |
| `ODB-CASH-06` | Shift closing includes cash count and verification. | Not implemented. | Close evidence is immutable; corrections are linked entries. |
| `ODB-CASH-07` | Shift handover preserves accountability and notifies the Owner of shortages or discrepancies. | Not implemented. | Exact escalation timing and correction flow remain `UNRESOLVED`; no discrepancy tolerance is approved. |
| `ODB-CASH-08` | The Owner authorizes float top-ups; Staff may request one. | Not implemented. | No additional approver role is approved. |
| `ODB-CASH-09` | A top-up records amount, source, executor, approver, and time. | Not implemented. | Evidence is required independently of payment/reporting projections. |
| `ODB-CASH-10` | A float top-up is not revenue. | Not implemented. | Reporting must classify it as a cash movement/funding source. |
| `ODB-CASH-11` | No fixed top-up frequency limit is approved. | Not implemented. | Do not invent a frequency cap. |
| `ODB-EXP-01` | Delegated expense limit is at most 200,000 VND per Expense. | Not implemented. | Configurable value, not a hard-coded constant. |
| `ODB-EXP-02` | Delegated expenses are capped at 500,000 VND cumulatively per Operating Day. | Not implemented. | Atomic cumulative enforcement requires the Operating Day boundary. |
| `ODB-EXP-03` | Exceeding either delegated limit requires Owner approval. | Not implemented. | Exceeding one threshold is sufficient to require approval. |
| `ODB-EXP-04` | Expense self-approval is forbidden. | Not implemented. | Requester/executor cannot approve their own Expense. |
| `ODB-EXP-05` | Splitting Expenses to evade a limit is prohibited. | Not implemented. | Detection and review details remain technical design. |
| `ODB-EXP-06` | Expense evidence records purpose, recipient, executor, approver, and receipt or explanation. | Not implemented. | Accounting/tax classification remains subject to validation. |
| `ODB-EXP-07` | Expense limits are configurable and must not be hard-coded. | Not implemented. | Configuration history and effective timing require design. |

## 4. Reporting

| ID | Owner-confirmed decision | Implementation | Repository evidence / remaining boundary |
|---|---|---|---|
| `ODB-RPT-01` | AFTER FOUR will provide an Owner Dashboard and automatic daily report delivery through Telegram. | Not implemented. | Direction is approved; delivery details below remain open. |
| `ODB-RPT-02` | Dashboard views support daily, weekly, monthly, custom date ranges, and period comparison. | Not implemented. | Business-day and formula definitions remain `UNRESOLVED`. |
| `ODB-RPT-03` | Excel export is deferred. | Not implemented. | It is not part of the current reporting scope. |
| `ODB-RPT-04` | Reporting distinguishes revenue from cash flow. Daily reporting includes relevant gross/net sales, Order count, cash/bank-transfer split, Refunds, operating Expenses, float/top-ups, cancellations, and exceptions. | Not implemented. | Exact metric formulas remain `UNRESOLVED`. |
| `ODB-RPT-05` | Telegram delivery retains history, retries idempotently, and avoids sensitive information in messages. | Not implemented. | Message retention/privacy and failure escalation remain `UNRESOLVED`. |

The following reporting details are explicitly `UNRESOLVED`: exact delivery time (including the unconfirmed 22:15 proposal), recipients, Operating Day cutoff, metric formulas, Branch scope, privacy details, and failure escalation.

## 5. Catalog/Pricing MVP

**Source for `ODB-CAT-01` through `ODB-CAT-10`:** Owner's explicit approval in the conversation following the Catalog/Pricing Discovery report.

**Scope:** Catalog/Pricing MVP. These decisions constrain later design but do not authorize implementation.

| ID | Owner-confirmed decision | Status | Implementation | Repository evidence / remaining boundary |
|---|---|---|---|---|
| `ODB-CAT-01` | Product identity is brand-global. Branch-specific availability and pricing are supported. | `OWNER_CONFIRMED` | Not implemented. | A Branch may vary sellability and price without creating a second Product identity. Product ownership below Brand and publication authority remain design concerns. |
| `ODB-CAT-02` | Use flat categories for MVP. | `OWNER_CONFIRMED` | Not implemented. | No nested Category hierarchy is approved for MVP. Display ordering and later hierarchy migration remain technical design; Category lifecycle is confirmed separately by `ODB-CAT-21` and `ODB-CAT-25`. |
| `ODB-CAT-03` | Product lifecycle states are Draft, Active, Inactive, and Archived. | `OWNER_CONFIRMED` | Not implemented. | Product restoration is confirmed separately by `ODB-CAT-24`; other transition authority and publication workflow remain unresolved unless another decision states otherwise. |
| `ODB-CAT-04` | Every sellable selection has a persisted Variant. Use an implicit/default hidden Variant when customers do not need to select a Variant. | `OWNER_CONFIRMED` | Not implemented. | Orders reference a persisted Variant even when the customer sees no Variant choice. Hidden/default naming, SKU generation, and migration rules remain technical design. |
| `ODB-CAT-05` | Modifier Groups support required or optional selection, single or multiple selection, and minimum and maximum selection limits. | `OWNER_CONFIRMED` | Not implemented. | Cardinality is approved; whether and how Modifier selections affect price remains unresolved pending actual menu and pricing requirements. |
| `ODB-CAT-06` | Branch availability may explicitly override the chain default. | `OWNER_CONFIRMED` | Not implemented. | Absence of an effective Branch override inherits the chain default. Time-based menu availability and override authority remain unresolved. |
| `ODB-CAT-07` | Use chain-level default prices with explicit Branch-level price overrides. | `OWNER_CONFIRMED` | Not implemented. | Price scope is approved; manual sold-price overrides and approval rules remain unresolved. Authority to publish Branch price versions requires later authorization design. |
| `ODB-CAT-08` | Price versions are immutable and effective-dated. | `OWNER_CONFIRMED` | Not implemented. | Corrections create a new version rather than rewriting effective history. Interval publication, overlap prevention, tax, service charge, rounding, and zero-price policy remain unresolved/design work. |
| `ODB-CAT-09` | If the authoritative price changes while an Order is Draft, require review of the revised quote before confirmation. | `OWNER_CONFIRMED` | Not implemented. | Confirmation must not silently accept changed commercial terms. Review UX, quote/version token, and concurrency protocol remain technical design. |
| `ODB-CAT-10` | Lock the sold price at Order confirmation. | `OWNER_CONFIRMED` | Phase 1 has no Order Items or server-side Catalog pricing. | Confirmed Order Item snapshots are historical and are never rewritten by later price changes. Exact snapshot components depend on unresolved tax, service-charge, rounding, Modifier-pricing, and free-item policy. |

**Source for `ODB-CAT-11` through `ODB-CAT-13`:** Owner's explicit approval boundary in Proposed Launch Menu v3.

| ID | Owner-confirmed decision | Status | Implementation | Repository evidence / remaining boundary |
|---|---|---|---|---|
| `ODB-CAT-11` | Target the proposed launch menu at 28 Products. | `OWNER_CONFIRMED` | Not implemented. | This approves menu scale only. It does not approve any individual proposed Product, code, Variant, Modifier, Recipe, or Price. |
| `ODB-CAT-12` | Use S/M/L sizes only for suitable Products. | `OWNER_CONFIRMED` | Not implemented. | Product applicability, actual capacities, Variant codes, and per-size Prices remain unresolved. Products that do not need a visible size still use the confirmed hidden-default Variant policy. |
| `ODB-CAT-13` | The selected signature products are Bơ xay dừa non, Trà đào cam sả, and Cà phê muối. | `OWNER_CONFIRMED` | Not implemented. | The signature designation is approved; it does not approve Product records/codes, Variants, Recipes, quantities, presentation, availability, or Prices. |

**Source for `ODB-CAT-14` through `ODB-CAT-21`:** Owner's explicit confirmation in the Catalog Core Owner Decisions task.

| ID | Owner-confirmed decision | Status | Implementation | Repository evidence / remaining boundary |
|---|---|---|---|---|
| `ODB-CAT-14` | Initial deployment starts with one Organization and one Brand. The schema must support multiple Organizations and multiple Brands and must not impose permanent single-row constraints. | `OWNER_CONFIRMED` | Not implemented. | This establishes initial row counts and future multiplicity, not a maximum Brands-per-Organization rule or additional Branch cardinality. |
| `ODB-CAT-15` | Every Product must belong to exactly one Category. | `OWNER_CONFIRMED` | Not implemented. | Applies while Draft and in every later Product lifecycle state. `ODB-CAT-29` adds the Active-Category activation prerequisite without defining Product reassignment. Exact same-Brand database enforcement remains technical design. |
| `ODB-CAT-16` | Category, Product, and Variant codes must be unique within their respective Brand. | `OWNER_CONFIRMED` | Not implemented. | `ODB-CAT-27` resolves the namespace: uniqueness is enforced separately within each entity type and Brand. `ODB-CAT-22` confirms input/canonical normalization. Code generation, database column sizes, and exact constraint names remain technical design. |
| `ODB-CAT-17` | SKU is optional. When present, SKU must be unique within its Brand. | `OWNER_CONFIRMED` | Not implemented; SKU is deferred from Catalog Core MVP by `ODB-CAT-34`. | Exact SKU normalization remains unresolved for a future scope; generation and physical nullable uniqueness enforcement remain future technical design. |
| `ODB-CAT-18` | Category, Product, and Variant codes and Variant SKUs must not be reused after archival. Archived records retain their identifiers. | `OWNER_CONFIRMED` | Not implemented. | Restoration must retain and revalidate the same identifier. `ODB-CAT-36` extends reservation to any future Soft Delete without authorizing Soft Delete; reuse after a hypothetical physical deletion remains unresolved. |
| `ODB-CAT-19` | A Draft Product may temporarily exist without any Variant or Default Variant. | `OWNER_CONFIRMED` | Not implemented. | This exception is limited to Draft. `ODB-CAT-23` separately requires an Active Product to have at least one Variant and exactly one Default Variant. |
| `ODB-CAT-20` | A Default Variant may also be customer-selectable. Default designation and customer visibility are independent concepts. | `OWNER_CONFIRMED` | Not implemented. | `ODB-CAT-28` additionally confirms that visibility is not an eligibility predicate: a hidden Active Variant may be Default. Exact fields and constraints remain technical design. |
| `ODB-CAT-21` | Category and Variant may be archived or deactivated and later restored. Physical deletion is prohibited while referenced by other records. | `OWNER_CONFIRMED` | Not implemented. | `ODB-CAT-25` distinguishes Deactivate from Archive; `ODB-CAT-29` supplies the Category Deactivation guard; `ODB-CAT-32` defines the allowed transition matrix and Inactive restore target. |

**Source for `ODB-CAT-22` through `ODB-CAT-26`:** Owner's explicit confirmation in the Catalog Core Owner Decisions (ODB-CAT-22–26) task.

| ID | Owner-confirmed decision | Status | Implementation | Repository evidence / remaining boundary |
|---|---|---|---|---|
| `ODB-CAT-22` | Category, Product, and Variant code input is trimmed and limited to ASCII Latin letters, digits, hyphen, and underscore; the canonical representation is uppercase. Code uniqueness remains Brand-scoped, includes archived records, and codes are not reusable after archive. | `OWNER_CONFIRMED` | Not implemented. | `ODB-CAT-27` confirms that Brand scope is evaluated separately for Category, Product, and Variant. This rule does not apply automatically to SKU. Exact SKU normalization, case, whitespace, Unicode, and allowed-character policy remain `UNRESOLVED`. Exact database/application normalization mechanisms remain `TECHNICAL_PROPOSAL`. |
| `ODB-CAT-23` | An Active Product must have at least one Variant and exactly one Default Variant. A Draft Product may have zero Variants and zero Defaults. Default designation remains independent of customer visibility, and a Default Variant may be customer-selectable. | `OWNER_CONFIRMED` | Not implemented. | `ODB-CAT-28` defines a valid Default for an Active Product as `is_default = true` and Variant status Active. `ODB-CAT-38` adds at-most-one Default designation for every Product lifecycle state without weakening this Active exactly-one rule. Database enforcement, lock order, Default switching, and activation transaction remain `TECHNICAL_PROPOSAL`. |
| `ODB-CAT-24` | An Archived Product may be restored only to Inactive. Reactivation is a separate action; restoration does not make the Product sellable automatically. Identifier uniqueness and historical integrity remain enforced. | `OWNER_CONFIRMED` | Not implemented. | `ODB-CAT-33` confirms Restore authority as Owner or explicit Owner delegate. Delegation representation, exact command, and technical validation remain unresolved/proposed. |
| `ODB-CAT-25` | Deactivate and Archive are separate Category/Variant actions: Deactivate is a reversible temporary suspension; Archive is long-term retirement with restoration subject to validation. State changes require validation and audit and may be performed only by the Owner or personnel explicitly delegated by the Owner. A Category cannot be archived while Active Products remain assigned; a Variant cannot be archived if that would leave an Active Product without its required valid Default Variant. | `OWNER_CONFIRMED` | Not implemented. | `ODB-CAT-28` defines “valid Default,” `ODB-CAT-29` supplies the separate Category Deactivation guard, and `ODB-CAT-32` defines the transition matrix. No additional archive guard, Product reassignment behavior, authorization mechanism, or audit mechanism is inferred. |
| `ODB-CAT-26` | The former Draft-deletion rule remains a necessary safety boundary only: Active, Inactive, Archived, referenced, historical, audit-dependent, or otherwise dependent Catalog records cannot be physically deleted. A dependency-free Draft is not thereby approved for physical deletion; `ODB-DATA-01` additionally requires entity-specific retention classification and an approved deletion mechanism before any Purge may be permitted. | `OWNER_CONFIRMED`, narrowed by `ODB-DATA-01` and `ODB-CAT-37` | Not implemented. | Historical wording permitted physical deletion only for a dependency-free Draft. Catalog Core MVP now prohibits Purge for every Catalog lifecycle state, including Draft. Future policy changes require a separate Owner Decision. |

**Source for `ODB-CAT-27`:** Owner's explicit selection of Option A in the Record Owner Decision CAT-CLAR-01 task.

| ID | Owner-confirmed decision | Status | Implementation | Repository evidence / remaining boundary |
|---|---|---|---|---|
| `ODB-CAT-27` | Within each Brand, Category Codes, Product Codes, and Variant Codes use separate uniqueness namespaces. A Code is unique among records of the same entity type in that Brand. The same Code may be used once by a Category, once by a Product, and once by a Variant in the same Brand; a second record of the same entity type with that Code in that Brand is rejected. | `OWNER_CONFIRMED` | Not implemented. | This resolves `CAT-CLAR-01`. It does not approve indexes or implementation, does not change archived-Code reservation, and does not define SKU or Organization/Brand/Branch Code rules. Three Brand-scoped per-entity unique constraints are the resulting `TECHNICAL_PROPOSAL`. |

**Source for `ODB-CAT-28`:** Owner's explicit selection of the Active-status eligibility policy in the Record Owner Decision CAT-CLAR-02 task.

| ID | Owner-confirmed decision | Status | Implementation | Repository evidence / remaining boundary |
|---|---|---|---|---|
| `ODB-CAT-28` | For an Active Product, exactly one Variant must satisfy both `is_default = true` and lifecycle status Active. `customer_visible` is independent and is not an eligibility predicate: an Active Variant with `customer_visible = false` may be the valid Default. An Inactive or Archived Variant cannot satisfy the Default requirement. Default designation, Variant lifecycle status, and customer visibility remain three independent concepts. | `OWNER_CONFIRMED` | Not implemented. | Resolves the Active-eligibility portion of `CAT-CLAR-02`; `ODB-CAT-38` later closes Default designation cardinality across every Product lifecycle state. Neither decision approves an index, trigger, lock protocol, lifecycle command, or implementation. Race-safe cross-row enforcement and concurrency proof remain `TECHNICAL_PROPOSAL`. |

**Source for `ODB-CAT-29`:** Owner's explicit selection of Option A for both Category/Product lifecycle questions in the Record CAT-CLAR-03 task.

| ID | Owner-confirmed decision | Status | Implementation | Repository evidence / remaining boundary |
|---|---|---|---|---|
| `ODB-CAT-29` | **Product activation:** a Product may transition to Active only when its assigned Category is Active. **Category deactivation:** a Category may not transition to Inactive while any Active Products remain assigned to it. These are separate lifecycle policies. | `OWNER_CONFIRMED` | Not implemented. | Resolves `CAT-CLAR-03`. Category Deactivation remains distinct from Category Archive under `ODB-CAT-25` and from Branch availability under `ODB-CAT-06`. This does not approve commands, triggers, locks, indexes, concurrency handling, Product reassignment, Category archive behavior with Inactive Products, authorization details, or implementation. |

**Source for `ODB-CAT-30` through `ODB-CAT-37`:** Owner's explicit confirmation of CAT-CLAR-04 through CAT-CLAR-09 in the Complete Catalog Core Owner Clarifications task.

| ID | Owner-confirmed decision | Status | Implementation | Repository evidence / remaining boundary |
|---|---|---|---|---|
| `ODB-CAT-30` | New Categories are created in Draft. Activation is a separate lifecycle action and must satisfy applicable validation and authorization rules. | `OWNER_CONFIRMED` | Not implemented. | Resolves `CAT-CLAR-04`. It does not approve a database default, create/activate command, validation implementation, authorization mechanism, or implementation milestone. |
| `ODB-CAT-31` | New Variants are created in Draft. Activation is a separate lifecycle action subject to applicable validation and authorization. Default designation, lifecycle status, and customer visibility remain independent; `ODB-CAT-28` remains unchanged. | `OWNER_CONFIRMED` | Not implemented. | Resolves `CAT-CLAR-05`. Creation does not make a Variant Active, Default, visible, or sellable. `ODB-CAT-38` limits every Product to at most one designated Default without deriving designation from lifecycle or visibility. No field default, command, constraint, or implementation is approved. |
| `ODB-CAT-32` | Category and Variant share this lifecycle matrix: Draft→Active is allowed after validation; Draft→Inactive is prohibited; Draft→Archived is allowed subject to applicable archive guards; Active→Inactive is allowed subject to applicable business guards; Inactive→Active is allowed after validation; Active→Archived and Inactive→Archived are allowed subject to applicable archive guards; Archived→Inactive is allowed only through Restore and validation; Archived→Active is prohibited directly. Archived Category and Archived Variant both restore to Inactive, and later activation is separate. | `OWNER_CONFIRMED` | Not implemented. | Resolves `CAT-CLAR-06`. Existing guards in `ODB-CAT-25`, `ODB-CAT-28`, and `ODB-CAT-29` remain; no additional guard, transition, command, generic status mutation, or implementation is approved. |
| `ODB-CAT-33` | Product Restore authority belongs to the Owner or personnel explicitly delegated by the Owner. Archived Product still restores only to Inactive, and activation remains separate. | `OWNER_CONFIRMED` | Not implemented. | Resolves `CAT-CLAR-07` while preserving `ODB-CAT-24`. Delegation representation, permission schema, Identity implementation, command, and audit mechanics remain unresolved/proposed. |
| `ODB-CAT-34` | Catalog Core MVP defers SKU support. It accepts no SKU input and implements no SKU normalization, canonicalization, or validation. SKU remains optional and Brand-unique when present under earlier decisions, but exact normalization remains unresolved for a future scope and does not inherit Catalog Code rules. | `OWNER_CONFIRMED` | Not implemented. | Resolves the MVP boundary in `CAT-CLAR-08`; it does not remove or rewrite `ODB-CAT-17` or `ODB-CAT-18`, select future SKU semantics, or authorize schema/application work. |
| `ODB-CAT-35` | Catalog Core MVP retains Category, Product, and Variant through lifecycle states, including Archive, for business retirement. Soft Delete is not the MVP retention mechanism; no `deleted_at` or universal Soft Delete behavior is introduced. Business, financial, historical, and audit records remain preserved. | `OWNER_CONFIRMED` | Not implemented. | Resolves `CAT-CLAR-09A` only for Catalog Core MVP. It does not impose a retention mechanism on unrelated entities or prevent a separately authorized future Catalog policy change. |
| `ODB-CAT-36` | Catalog Codes and SKUs are not reused after Archive or after any future Soft Delete. This reservation rule does not authorize Soft Delete in Catalog Core MVP and does not define identifier reuse after physical deletion of a Draft record. | `OWNER_CONFIRMED` | Not implemented. | Resolves `CAT-CLAR-09B`. Existing Code namespace/normalization and SKU scope decisions remain; future Soft Delete uniqueness mechanics and reuse after hypothetical physical deletion remain future-scope questions. |
| `ODB-CAT-37` | Physical Purge of Category, Product, and Variant records is prohibited in Catalog Core MVP for Draft, Active, Inactive, and Archived states. A Draft record with no known dependencies does not authorize deletion. Any future Catalog retention or Purge policy change requires a separate Owner Decision. | `OWNER_CONFIRMED` | Not implemented. | Resolves `CAT-CLAR-09C`, narrows historical `ODB-CAT-26` with `ODB-DATA-01`, and authorizes no purge/cleanup job, deletion command, or implementation. |

**Source for `ODB-CAT-38`:** Owner's explicit confirmation in the Default Variant Uniqueness Across Product Lifecycle task.

| ID | Owner-confirmed decision | Status | Implementation | Repository evidence / remaining boundary |
|---|---|---|---|---|
| `ODB-CAT-38` | Every Product may have at most one Variant with `is_default = true`, regardless of Product lifecycle state. Draft, Inactive, and Archived Products may have zero or one designated Default. An Active Product must have exactly one designated Default, and that Variant must have lifecycle status Active. `is_default`, Variant lifecycle status, and `customer_visible` remain independent; visibility does not affect eligibility, and a hidden Active Variant may be the valid Default. Multiple designated Defaults are prohibited in every Product lifecycle state. | `OWNER_CONFIRMED` | Not implemented. | Completes the all-lifecycle cardinality portion of `CAT-CLAR-02` while preserving `ODB-CAT-23`, `ODB-CAT-28`, and `ODB-CAT-31`. It approves no unique index, constraint trigger, lock protocol, lifecycle command, migration, test, or implementation. Race-safe enforcement and direct-SQL/concurrency proof remain `TECHNICAL_PROPOSAL`. |

**Source for `ODB-CAT-39` through `ODB-CAT-41`:** Owner's explicit Catalog Core scope confirmation on 2026-11-15.

| ID | Owner-confirmed decision | Status | Implementation | Repository evidence / remaining boundary |
|---|---|---|---|---|
| `ODB-CAT-39` | Product lifecycle transition and Restore commands are excluded from the initial Catalog Core MVP. This scope provides no Product Activate, Deactivate, Archive, or Restore command or API. Missing Product lifecycle transitions and authorization rules remain unresolved for a future separately approved scope. | `OWNER_CONFIRMED` | Not implemented. | This is a scope exclusion, not a replacement for `ODB-CAT-03`, `ODB-CAT-24`, `ODB-CAT-29`, or `ODB-CAT-33`. It does not describe Product lifecycle as implemented or complete and grants no implementation authorization. |
| `ODB-CAT-40` | Variant Archive and Restore change only Variant lifecycle status. They preserve `is_default` and `customer_visible`; Archive/Restore never silently transfers or modifies Default designation. Restore transitions Archived→Inactive, and reactivation is a separate validated action. | `OWNER_CONFIRMED` | Not implemented. | Preserves `ODB-CAT-28`, `ODB-CAT-31`, `ODB-CAT-32`, and `ODB-CAT-38`. Commands, authorization, audit, locking, constraints, and concurrency enforcement remain `TECHNICAL_PROPOSAL`; no implementation is authorized. |
| `ODB-CAT-41` | Product Category reassignment is unsupported in the initial Catalog Core MVP. A Product remains assigned to its original Category after creation, and no Product Category reassignment command or API is provided. Any future reassignment capability requires a separate Owner Decision and scope approval. | `OWNER_CONFIRMED` | Not implemented. | This closes MVP reassignment scope without defining future reassignment behavior, creation/edit permissions, or Category/Variant authorization. Proposed database immutability enforcement remains technical and unimplemented. |

### Package C0 lifecycle authority and prerequisite decisions

**Source:** Owner's explicit Package C0 reviews through 2026-11-15. `C0-CAT-01` through `C0-CAT-08` and `C0-R01` through `C0-R04`, `C0-R06`, `C0-R07`, `C0-R09`, and `C0-R10` are confirmed only within the boundaries below. `C0-R05`, `C0-R08`, and `C0-R11` are intentionally deferred and are not approved policies. None of these rows authorizes P1, P2, P3, Package C implementation, Identity Milestone 2B, a public API, or production use.

| ID | Decision | Status | Implementation | Repository evidence / remaining boundary |
|---|---|---|---|---|
| `C0-CAT-01` | Category lifecycle operation authority belongs to Organization/Brand Owners and personnel explicitly delegated for the applicable Category operation. | `OWNER_CONFIRMED` | Not implemented. | Applies to Package C Category lifecycle operations only. It does not approve create/read/edit, Product lifecycle, Default switching, or a role-title-based capability. |
| `C0-CAT-02` | Variant lifecycle operation authority belongs to Organization/Brand Owners and personnel explicitly delegated for the applicable Variant operation. | `OWNER_CONFIRMED` | Not implemented. | Applies to Package C Variant lifecycle operations only. It does not approve create/read/edit, Product lifecycle, Default switching, or a role-title-based capability. |
| `C0-CAT-03` | Catalog lifecycle delegation is capability-specific and Brand-scoped. A grant for one Brand or capability supplies no authority for another Brand or capability. | `OWNER_CONFIRMED` | Not implemented. | The persistence representation and enforcement mechanism remain technical design. This is distinct from the Staff-invitation delegation in Identity decision `ID-14`. |
| `C0-CAT-04` | A reason is mandatory for Category or Variant Deactivate, Archive, and Restore. | `OWNER_CONFIRMED` | Not implemented. | Activate has no reason requirement from this decision. Validation details, including the confirmed 500-character maximum, are recorded separately in `C0-R06`. |
| `C0-CAT-05` | Category or Variant Archive and Restore require successful step-up MFA. | `OWNER_CONFIRMED` | Not implemented. | MFA freshness, assurance level, session binding, and invalidation details remain deferred under `C0-R05`. |
| `C0-CAT-06` | Catalog lifecycle access is default-deny across Brands. Authority for one Brand never grants access to another Brand. | `OWNER_CONFIRMED` | Not implemented. | Trusted Brand scope must be derived server-side; client-supplied actor, Brand, role, or delegation claims are not authority. |
| `C0-CAT-07` | Audit persistence failure rolls back the complete Category or Variant lifecycle mutation. | `OWNER_CONFIRMED` | Not implemented. | Failure-injection and committed-state evidence are required. The Brand-scoped append-only and atomic AuditEvent contract is recorded in `C0-R07`. |
| `C0-CAT-08` | Default Variant switching is out of scope for Package C. Package C lifecycle operations may reject a transition that would violate Default invariants but must not silently designate, transfer, or replace the Default Variant. | `OWNER_CONFIRMED` | Not implemented. | Preserves `ODB-CAT-28`, `ODB-CAT-38`, and `ODB-CAT-40`; future Default authority requires a separate decision and scope. |
| `C0-R01` | Package C role and capability assignment follows the confirmed Organization/Brand ownership scopes. | `OWNER_CONFIRMED` | Not implemented. | Exact assignment representation and trusted evaluation require separately authorized Identity/Application work; no additional assignment authority is inferred. |
| `C0-R02` | The Organization Owner administers Catalog delegation within the Organization ownership scope. A Brand Owner administers Catalog delegation only within their own Brand. Delegated personnel cannot delegate onward unless they have been separately granted delegation-management authority. A generic role title does not grant delegation-management capability. Self-delegation and self-approval remain prohibited under `C0-R03`, and grant, change, and revoke events remain audited under `C0-R04`. | `OWNER_CONFIRMED` | Not implemented. | Exact administration use cases, delegation-management assignment representation, and trusted ownership resolution require separately authorized Identity/Application work; no additional authority is inferred. |
| `C0-R03` | Self-delegation and self-approval of Catalog lifecycle delegation are prohibited. | `OWNER_CONFIRMED` | Not implemented. | Concurrency-safe enforcement and evidence remain required. |
| `C0-R04` | Catalog lifecycle delegation has `effective_at` and `expires_at`. A future-effective grant supplies no authority before `effective_at`. Reaching `expires_at` automatically invalidates the grant, and early revocation is effective for all subsequent authorization checks. Expired or revoked grants cannot be reactivated; any replacement is a new grant. Grant, change, and revoke events are audited. Retroactive grants are not permitted. | `OWNER_CONFIRMED` | Not implemented. | Clock handling, authorization/revocation races, storage, and audit evidence remain technical/security work. |
| `C0-R05` | Exact MFA freshness, assurance level, session binding, and invalidation details for Package C. | `DEFERRED` | Not implemented. | No replacement values or implicit policy are approved. This deferral does not waive the step-up requirement in `C0-CAT-05`. |
| `C0-R06` | A reason is mandatory for Category or Variant Deactivate, Archive, and Restore. The reason has a maximum of 500 characters; blank or whitespace-only reasons are rejected; secrets must not be included. | `OWNER_CONFIRMED` | Not implemented. | These validation rules are confirmed, not unresolved technical choices. Exact normalization, storage, redaction enforcement, and error mapping remain implementation design. |
| `C0-R07` | The Brand-scoped Catalog AuditEvent contract records: actor, trusted identity and Session; Organization and Brand scope; capability, authorization, and delegation evidence; entity and operation; before and after state; reason; an MFA evidence reference when applicable; Event ID and correlation ID; timestamp; and schema version. The payload must contain no credentials or secrets. Persistence is append-only. The lifecycle mutation and required AuditEvent append occur in the same transaction; audit persistence failure rolls back the entire lifecycle mutation. | `OWNER_CONFIRMED` | Not implemented for Brand-scoped Catalog lifecycle events. | Database-role protection against UPDATE, DELETE, and TRUNCATE, the event representation/redaction contract, and mutation-plus-audit transaction evidence still require design and execution. `C0-R07` defines the contract and atomic append; `C0-CAT-07` independently requires full lifecycle-mutation rollback on audit persistence failure. |
| `C0-R08` | Audit retention, legal hold, reader authorization, and export governance. | `DEFERRED` | Not implemented. | No duration, reader/export entitlement, hold procedure, anonymization rule, or legal conclusion is approved. |
| `C0-R09` | Package C requires a trusted server-side AuthorizationContext. Missing, invalid, expired, or revoked identity/delegation fails closed; client-supplied authority claims are never trusted. | `OWNER_CONFIRMED` | Not implemented. | Identity Milestone 2B remains unauthorized. Exact contract and integration require separate authorization. |
| `C0-R10` | Runtime database security separates runtime authority from migration ownership. The runtime role must not own Catalog/Audit schema objects and must not have unrestricted authority to `ALTER` or `DROP` schema objects, `TRUNCATE`, disable triggers, modify `session_replication_role`, directly `DELETE`, replace functions, or grant roles. Package C requires an operation-specific database boundary that prevents unrestricted runtime Catalog DML, but the exact mechanism remains a technical design decision; stored procedures or any other mechanism are not selected or implied. | `OWNER_CONFIRMED` | Not implemented as operational role or boundary evidence. | CAT-TRR-005 and CAT-TRR-007 remain open. Alternatives require review against authorization, audit atomicity, Layered DDD, least privilege, and direct-SQL bypass risk. |
| `C0-R11` | Advanced concurrency retry and idempotency policy for Package C. | `DEFERRED` | Not implemented. | No retry count, backoff, automatic retry class, command idempotency contract, or production policy is approved. Existing database invariants and evidence are unchanged. |

See the [Catalog/Pricing Discovery and Decision Closure](after_four_catalog_pricing_discovery.md) for the discovery-to-canonical trace and [Proposed Launch Menu v3](after_four_proposed_launch_menu_v3.md) for the later launch-menu input and its approval boundary.

The following Catalog/Pricing matters remain explicitly `UNRESOLVED`: tax treatment and tax-inclusive/exclusive pricing; service charge policy; monetary rounding; zero-price/free-product policy; Modifier price effects pending actual menu requirements; time-based menu availability; manual price overrides and approval rules; inventory tracking; and media storage/vendor selection.

Catalog Core also retains these explicit unresolved or future-scope items: future SKU normalization and support; identifier reuse after a hypothetical physical deletion of a Draft record; uniqueness mechanics for any separately authorized future Soft Delete; future Product lifecycle transitions/authority; any future Product reassignment capability; technical representation/enforcement of the confirmed Package C delegation policy; exact command/validation/audit/locking/constraint mechanisms; and the deferred details in `C0-R05`, `C0-R08`, and `C0-R11`. Initial MVP excludes Product lifecycle/Restore commands and Product Category reassignment under `ODB-CAT-39` and `ODB-CAT-41`; Package C excludes Default switching under `C0-CAT-08`; Catalog Core MVP itself has no Soft Delete and no Purge.

The timing of Payment creation—Draft creation versus Order confirmation—is a separate design question. Nothing in `ODB-CAT-01` through `ODB-CAT-10` approves a change to the implemented Phase 1 timing or guarantees.

## 5A. Production MVP Customer, Loyalty, and Promotions scope

**Source:** Owner confirmation in conversation on 2026-11-16.

The references in this section are provisional governance references, not canonical `ODB-*` identifiers. The approved category registry now includes `CUST`, `LOY`, and `PROMO`, but category approval does not allocate a canonical ID. No explicit Owner allocation decision or completed provisional-to-canonical crosswalk exists for these references, so they remain `ID_PENDING_OWNER_GOVERNANCE`. The absence of a numbered ID does not downgrade the explicit Owner confirmation recorded here.

These decisions confirm Production MVP business scope only. They approve no architecture, schema, migration, API, dependency, source code, test, database operation, P1/P2/P3/Package C work, Identity Milestone 2B work, Gate A/B/C decision, Final Operational Acceptance, Production Authorization, or production use.

| Provisional reference | MVP classification | Owner-confirmed decision | Classification | Implementation | Preserved boundary / unresolved detail |
|---|---|---|---|---|---|
| `MVP-CUST-SCOPE` | `MUST` | Production MVP includes Customer Profile, phone-based Customer lookup, duplicate prevention through a unique phone constraint, Customer Purchase History, Customer privacy, and anonymization. Customer Profile is shared across Branches; each transaction retains its originating Branch. The Owner has permitted system-wide Customer visibility, Manager visibility is restricted to managed Branches, and Staff visibility requires an explicit approved capability. A phone change requires Customer verification and Manager or Owner confirmation, and the new phone must pass the uniqueness check. Automatic Customer Profile merging is prohibited. Anonymization preserves transaction history required by applicable legal and operational rules while making the Profile nonidentifying and ineligible for Customer-specific benefits. | `OWNER_CONFIRMED` | `NOT_AUTHORIZED`; no executing Customer implementation or production data operation is approved. | Phone normalization/country rules, uniqueness namespace, shared/family phones, verification mechanism, anonymous Orders, export, anonymization trigger/field treatment, retention, and legal/privacy conclusions remain `UNDECIDED`. Existing Owner-confirmed Identity authorization boundaries and previously confirmed data-retention decisions remain `EXISTING_DECISION_PRESERVED`; unresolved authorization, privacy, and retention matters remain subject to their existing governance status. |
| `MVP-LOY-SCOPE` | `MUST` | Basic Loyalty is required in Production MVP. It includes a persistent points ledger; accrual, redemption, and adjustment history; Customer and relevant transaction linkage; authorized manual adjustment; auditability; reconciliation and reversal evidence; and the shared-across-Branches Customer/Loyalty direction. | `OWNER_CONFIRMED` | `NOT_AUTHORIZED`; no Loyalty schema, calculation, workflow, or production use is approved. | Earning/redemption formulas, minimums, expiration, tiers, birthday benefits, negative-balance behavior, refund allocation, cross-Branch redemption details, and manual-adjustment requester/approver policy remain `UNDECIDED`. |
| `MVP-PROMO-SCOPE` | `MUST` | Advanced Promotions & Discount Engine is required in Production MVP. The capability may not be downgraded to `SHOULD`, deferred in its entirety, or classified `OUT_OF_SCOPE`. | `OWNER_CONFIRMED` | `NOT_AUTHORIZED`; no Promotion architecture, rule engine, schema, workflow, or production use is approved. | The candidate areas below are `PROPOSED_CAPABILITY`, not individually approved Promotion policies. Ownership/applicability scope, formulas, eligibility, stacking/exclusion, priority, Voucher issuance/reuse, usage limits, effective-period timezone, allocation, tax/service-charge/rounding interaction, refund/cancellation treatment, administration authority, approval, and audit detail remain `UNDECIDED`. |

### Customer anonymization and existing Loyalty balance

| Local review reference | Decision date | Authority | Decision status | Selected option | Canonical ODB ID | Implementation |
|---|---|---|---|---|---|---|
| [`SDP-CUST-01`](after_four_sdp_cust_01_owner_decision.md) | 2026-11-16 | Owner | `OWNER_DECIDED` (`OWNER_CONFIRMED` business policy) | `A — Preserve & Freeze` | `ID_PENDING_OWNER_GOVERNANCE` | `NOT_AUTHORIZED` |

`SDP-CUST-01` requires preserving the existing Loyalty balance, ledger, and necessary transaction/audit history when Customer anonymization becomes effective, while freezing redemption and issuing no new Customer-specific Loyalty benefits. The balance is not automatically deleted, transferred, extinguished, reassigned, or made redeemable again through a later phone number or Customer Profile. Exceptional adjustment or other treatment requires separately approved policy and appropriate authority.

The decision preserves Customer Management ownership of Customer Profile and anonymization state; Loyalty ownership of Loyalty Account, balance, ledger, and redemption eligibility; Ordering ownership of Order and historical commercial records; and Promotions ownership of Promotion eligibility and usage policy. It selects no integration mechanism or context topology, allocates no canonical `ODB-*` ID, grants no implementation or legal/privacy approval, and resolves no other `SDP-*` decision.

### Proposed Promotion capability areas

The following areas are required inputs to later design assessment because the confirmed MVP scope calls for an advanced engine. Their listing does not approve a rule vocabulary, calculation, default, workflow, or implementation:

- `PROPOSED_CAPABILITY`: percentage and fixed-amount discounts;
- `PROPOSED_CAPABILITY`: Product-, Variant-, Category-, and Order-level Promotions;
- `PROPOSED_CAPABILITY`: conditional and time-based Promotions;
- `PROPOSED_CAPABILITY`: Voucher/Coupon support;
- `PROPOSED_CAPABILITY`: stacking, exclusion, priority, eligibility, and usage-limit evaluation;
- `PROPOSED_CAPABILITY`: Promotion administration and lifecycle;
- `PROPOSED_CAPABILITY`: server-authoritative evaluation integrated with authoritative Pricing;
- `PROPOSED_CAPABILITY`: immutable Promotion/discount evidence in confirmed Order snapshots;
- `PROPOSED_CAPABILITY`: sensitive Promotion administration authorization and audit; and
- `PROPOSED_CAPABILITY`: basic Promotion performance and discount reporting.

### Unresolved Production MVP rules

| Area | `UNDECIDED` rules requiring Owner decision |
|---|---|
| Customer | Phone normalization and country-code rules; uniqueness namespace; shared/family phone handling; verification mechanism; anonymous Order permission; export policy; anonymization trigger and retained fields; legal retention/deletion obligations. |
| Loyalty | Earning and redemption formulas; minimums; expiration; negative balance; partial-refund reversal; detailed cross-Branch redemption; manual-adjustment requester/approver policy. |
| Promotions | Ownership and applicability scope; enabled rule semantics and formulas; stacking, exclusion, priority, tie-breaking, eligibility, Voucher issuance/reuse, usage limits, effective-period timezone, allocation, tax/service-charge/rounding interaction, refund/cancellation treatment, administration and approval authority. |
| Pricing and Payment | Tax treatment, service charge, monetary rounding, zero/free items, Modifier pricing, manual Price override, Refund method/authority, partial Refunds, and detailed overpayment/late-payment resolution remain unresolved except where an earlier `ODB-*` row already fixes a boundary. |

`EXISTING_DECISION_PRESERVED`: `ODB-OP-02` and `ODB-OP-03` continue to require persisted full verified Payment before Preparation Dispatch and prohibit pending, unknown, failed, or unverified Payment from dispatching. `ODB-OP-04`, `ODB-OP-10`, `ODB-OP-11`, and `ODB-OP-16` continue to govern late success, mismatch, overpayment, and unknown attempts within their recorded limits. The unresolved timing question is when the Payment aggregate is created relative to Draft/confirmation, not whether unpaid work may dispatch.

Customer/Loyalty and Promotions remain distinct capabilities even if a later approved design retains them within the existing logical Customers, Loyalty & Promotions context. Loyalty rewards are not Promotion definitions, and neither may rewrite authoritative base Prices or confirmed historical Order snapshots. Exact integration remains design work subject to Layered DDD and separate authorization.

**Final Operational Acceptance:** `NOT_GRANTED`.

**Production Authorization:** `NOT_GRANTED`.

**Customer/Loyalty/Promotion implementation authorization:** `NOT_GRANTED`.

## 6. Global data retention and deletion

**Source for `ODB-DATA-01`:** Owner's explicit selection of the importance-based retention principle in the Record Owner Data Retention Decision task.

| ID | Owner-confirmed decision | Status | Implementation | Repository evidence / remaining boundary |
|---|---|---|---|---|
| `ODB-DATA-01` | Data affecting business operations, finance, historical records, or audit must be retained and must not be casually physically deleted. Temporary or transient data may be physically deleted when no longer needed under an appropriate, separately defined cleanup policy. Soft Delete is one possible retention mechanism, not a universal requirement; immutable retention and lifecycle/status-based retention are valid alternatives where appropriate. | `OWNER_CONFIRMED` | Not implemented as a global mechanism. | Entity-by-entity importance classification and mechanism remain unresolved. Retention periods, purge eligibility, purge authority, cleanup schedules, restoration, uniqueness participation, FK behavior, and legal/regulatory obligations are not decided here. |

The Owner's earlier broad statement that all data should use Soft Delete only is `HISTORICAL_SUPERSEDED`. It is not an active policy and must not be implemented alongside `ODB-DATA-01`. This decision does not require a global `deleted_at` column and does not itself permit any specific record to be purged.

## 7. Identity and Authorization

Identity decisions `ID-01` through `ID-34` remain exactly as recorded in the [Identity Decision Register](after_four_identity_decision_register.md#owner-decisions-confirmed). This baseline references them rather than duplicating their complete security boundaries.

- `ID-01`–`ID-28`: `OWNER_CONFIRMED`; security/implementation evidence remains required where stated.
- `ID-29`–`ID-34`: `OWNER_CONFIRMED` only for the stated Argon2 validation/admission direction. They do not approve a production dependency, profile, numeric resource/admission value, implementation, production use, or residual risk.
- [ADR-0006](adr/0006-authentication-session-topology.md) remains **Proposed**.
- Milestone 2B remains **not authorized**.

## 8. Deployment proposals

Proposal placeholders `ID-35` through `ID-39` remain `DOCUMENTED_PROPOSAL` and `NOT_APPROVED`, as recorded in [AF-OWNER-001G](security-reviews/owner-led/af-owner-001g-deployment-direction-proposals.md). They do not become Owner decisions through this baseline.

- `ID-35`: deployment shape/provider criteria;
- `ID-36`: evidence-first resource/process sizing method;
- `ID-37`: launch forecast framework—distinct from the confirmed planning assumptions in §1;
- `ID-38`: experience/availability objective classes;
- `ID-39`: operational ownership model.

[ADR-0008](adr/0008-deployment-environments.md) remains **Proposed**.

## 9. Use and precedence

1. Use this baseline for Owner-confirmed business, planning and project-wide architecture direction.
2. Use the Business Domain Model, Payment Model, State Machines, Data Dictionary, Integrity Rules, and API Contract for synchronized domain/technical detail.
3. Use the implementation record and executable evidence for implemented behavior; implementation does not silently create a new Owner decision.
4. Treat older workshop, workflow, domain, database, and roadmap documents as historical where their banners say so.
5. When this baseline intentionally leaves a detail unresolved, no downstream document or implementation may invent it.
