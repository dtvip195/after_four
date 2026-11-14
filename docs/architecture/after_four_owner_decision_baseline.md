# AFTER FOUR — Owner Decision Baseline

**Status:** Canonical source of truth for Owner-confirmed business decisions  
**Date recorded:** 2026-11-14  
**Scope:** Business and planning decisions that constrain later architecture and implementation

This baseline records Owner decisions supplied after the earlier repository consistency audit. It does not claim that these decisions were already present in the repository before this document was created.

**Provenance for decisions with an `ODB-` identifier:** Owner-confirmed project discussion supplied in the Owner Decision Baseline Reconciliation task, except where a later section records a more specific Owner approval source.

**Classification for every `ODB-` row in §§1–5:** `OWNER_CONFIRMED`. The separate Implementation column records implementation state and must not be read as the approval classification.

Owner approval and implementation are separate dimensions:

- `OWNER_CONFIRMED`: the stated business direction is approved within its explicit boundary.
- `IMPLEMENTED`: executable behavior exists. This does not approve unstated policy or production use.
- `DOCUMENTED_PROPOSAL`: an architecture or technical recommendation, not an Owner decision.
- `UNRESOLVED`: a decision remains genuinely open.
- `CONTRADICTORY`: current repository sources disagree with the baseline or implementation evidence.
- `HISTORICAL`: a preserved earlier proposal or question that is no longer implementation authority.

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
| `ODB-CAT-15` | Every Product must belong to exactly one Category. | `OWNER_CONFIRMED` | Not implemented. | Applies while Draft and in every later Product lifecycle state. Exact same-Brand database enforcement remains technical design. |
| `ODB-CAT-16` | Category, Product, and Variant codes must be unique within their respective Brand. | `OWNER_CONFIRMED` | Not implemented. | `ODB-CAT-22` confirms Catalog Code input/canonical normalization. Code generation, database column sizes, and exact constraint names remain technical design. |
| `ODB-CAT-17` | SKU is optional. When present, SKU must be unique within its Brand. | `OWNER_CONFIRMED` | Not implemented. | Exact SKU normalization remains unresolved; generation and physical nullable uniqueness enforcement remain technical design. |
| `ODB-CAT-18` | Category, Product, and Variant codes and Variant SKUs must not be reused after archival. Archived records retain their identifiers. | `OWNER_CONFIRMED` | Not implemented. | Restoration must retain and revalidate the same identifier. `ODB-CAT-26` separately limits physical deletion to eligible Draft records; identifier reservation after such deletion remains unresolved. |
| `ODB-CAT-19` | A Draft Product may temporarily exist without any Variant or Default Variant. | `OWNER_CONFIRMED` | Not implemented. | This exception is limited to Draft. `ODB-CAT-23` separately requires an Active Product to have at least one Variant and exactly one Default Variant. |
| `ODB-CAT-20` | A Default Variant may also be customer-selectable. Default designation and customer visibility are independent concepts. | `OWNER_CONFIRMED` | Not implemented. | Neither default implies hidden nor hidden implies default. Exact fields and constraints remain technical design. |
| `ODB-CAT-21` | Category and Variant may be archived or deactivated and later restored. Physical deletion is prohibited while referenced by other records. | `OWNER_CONFIRMED` | Not implemented. | `ODB-CAT-25` distinguishes Deactivate from Archive and confirms authority/dependency safeguards. Restoration target states and detailed transitions remain unresolved. |

**Source for `ODB-CAT-22` through `ODB-CAT-26`:** Owner's explicit confirmation in the Catalog Core Owner Decisions (ODB-CAT-22–26) task.

| ID | Owner-confirmed decision | Status | Implementation | Repository evidence / remaining boundary |
|---|---|---|---|---|
| `ODB-CAT-22` | Category, Product, and Variant code input is trimmed and limited to ASCII Latin letters, digits, hyphen, and underscore; the canonical representation is uppercase. Code uniqueness remains Brand-scoped, includes archived records, and codes are not reusable after archive. | `OWNER_CONFIRMED` | Not implemented. | This rule does not apply automatically to SKU. Exact SKU normalization, case, whitespace, Unicode, and allowed-character policy remain `UNRESOLVED`. Exact database/application normalization mechanisms remain `TECHNICAL_PROPOSAL`. |
| `ODB-CAT-23` | An Active Product must have at least one Variant and exactly one Default Variant. A Draft Product may have zero Variants and zero Defaults. Default designation remains independent of customer visibility, and a Default Variant may be customer-selectable. | `OWNER_CONFIRMED` | Not implemented. | Default does not mean hidden. At-most/at-least-one database enforcement, lock order, Default switching, and activation transaction remain `TECHNICAL_PROPOSAL`. |
| `ODB-CAT-24` | An Archived Product may be restored only to Inactive. Reactivation is a separate action; restoration does not make the Product sellable automatically. Identifier uniqueness and historical integrity remain enforced. | `OWNER_CONFIRMED` | Not implemented. | Product restoration authority, approval workflow, exact command, and technical validation remain unresolved unless separately confirmed. |
| `ODB-CAT-25` | Deactivate and Archive are separate Category/Variant actions: Deactivate is a reversible temporary suspension; Archive is long-term retirement with restoration subject to validation. State changes require validation and audit and may be performed only by the Owner or personnel explicitly delegated by the Owner. A Category cannot be archived while Active Products remain assigned; a Variant cannot be archived if that would leave an Active Product without its required valid Default Variant. | `OWNER_CONFIRMED` | Not implemented. | Category/Variant restoration target states, detailed transition matrix and validation behavior, delegated-authority representation/enforcement, and additional approval/audit metadata remain `UNRESOLVED` or `TECHNICAL_PROPOSAL` as applicable. |
| `ODB-CAT-26` | Physical deletion is permitted only for a Draft record with no references, business history, audit dependencies, or other relevant dependencies. Otherwise deletion is prohibited and Archive is used where permitted. Active, Inactive, and Archived records cannot be physically deleted. | `OWNER_CONFIRMED` | Not implemented. | FK absence alone is insufficient proof of safety. Identifier reservation after physical deletion of a Draft remains `UNRESOLVED`; database/application deletion-safety enforcement remains `TECHNICAL_PROPOSAL`. |

See the [Catalog/Pricing Discovery and Decision Closure](after_four_catalog_pricing_discovery.md) for the discovery-to-canonical trace and [Proposed Launch Menu v3](after_four_proposed_launch_menu_v3.md) for the later launch-menu input and its approval boundary.

The following Catalog/Pricing matters remain explicitly `UNRESOLVED`: tax treatment and tax-inclusive/exclusive pricing; service charge policy; monetary rounding; zero-price/free-product policy; Modifier price effects pending actual menu requirements; time-based menu availability; manual price overrides and approval rules; inventory tracking; and media storage/vendor selection.

Catalog Core also retains these explicit unresolved items: exact SKU normalization; Category and Variant restoration target states; identifier reservation after physical deletion of a Draft record; detailed lifecycle transition matrices; technical enforcement of delegated authority; safe physical-deletion enforcement; and Default Variant concurrency mechanisms.

The timing of Payment creation—Draft creation versus Order confirmation—is a separate design question. Nothing in `ODB-CAT-01` through `ODB-CAT-10` approves a change to the implemented Phase 1 timing or guarantees.

## 6. Identity and Authorization

Identity decisions `ID-01` through `ID-34` remain exactly as recorded in the [Identity Decision Register](after_four_identity_decision_register.md#owner-decisions-confirmed). This baseline references them rather than duplicating their complete security boundaries.

- `ID-01`–`ID-28`: `OWNER_CONFIRMED`; security/implementation evidence remains required where stated.
- `ID-29`–`ID-34`: `OWNER_CONFIRMED` only for the stated Argon2 validation/admission direction. They do not approve a production dependency, profile, numeric resource/admission value, implementation, production use, or residual risk.
- [ADR-0006](adr/0006-authentication-session-topology.md) remains **Proposed**.
- Milestone 2B remains **not authorized**.

## 7. Deployment proposals

Proposal placeholders `ID-35` through `ID-39` remain `DOCUMENTED_PROPOSAL` and `NOT_APPROVED`, as recorded in [AF-OWNER-001G](security-reviews/owner-led/af-owner-001g-deployment-direction-proposals.md). They do not become Owner decisions through this baseline.

- `ID-35`: deployment shape/provider criteria;
- `ID-36`: evidence-first resource/process sizing method;
- `ID-37`: launch forecast framework—distinct from the confirmed planning assumptions in §1;
- `ID-38`: experience/availability objective classes;
- `ID-39`: operational ownership model.

[ADR-0008](adr/0008-deployment-environments.md) remains **Proposed**.

## 8. Use and precedence

1. Use this baseline for Owner-confirmed business direction.
2. Use the Business Domain Model, Payment Model, State Machines, Data Dictionary, Integrity Rules, and API Contract for synchronized domain/technical detail.
3. Use the implementation record and executable evidence for implemented behavior; implementation does not silently create a new Owner decision.
4. Treat older workshop, workflow, domain, database, and roadmap documents as historical where their banners say so.
5. When this baseline intentionally leaves a detail unresolved, no downstream document or implementation may invent it.
