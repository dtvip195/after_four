# AFTER FOUR — Project-wide Logical Database Design Inventory

**Document status:** `TECHNICAL_ANALYSIS — LOGICAL_INVENTORY`

**Physical database design approval:** `NOT_GRANTED`

**Implementation authorization:** `NOT_GRANTED`

**Prepared from main:** `13aab731941d690b5bd764d2744893260d001986`

**Date:** 2026-11-23

## 1. Purpose and interpretation

This inventory consolidates existing domain and governance evidence for later database-design work. It is not a physical schema, an implementation baseline, or a substitute for the source documents. The [Business Domain Model](after_four_business_domain_model.md), [Owner Decision Baseline](after_four_owner_decision_baseline.md), accepted ADRs, and domain-specific approved records retain their existing authority.

The inventory uses these classifications:

| Classification | Meaning in this document |
|---|---|
| `OWNER_APPROVED_BUSINESS_INVARIANT` | An Owner-confirmed policy within its recorded scope. It does not select database enforcement. |
| `ACCEPTED_DESIGN_LEVEL_INVARIANT` | An accepted or independently reviewed design contract in its stated governance boundary. It is not necessarily implemented or approved for production. |
| `PROPOSED_TECHNICAL_ENFORCEMENT` | A technical proposal requiring the applicable design and implementation gates. |
| `UNRESOLVED_REQUIREMENT` | A business, legal/privacy, operational, or technical matter without sufficient approved evidence. |
| `BOUNDED_IMPLEMENTED_EVIDENCE` | Repository implementation and test evidence exists in a bounded package; this does not prove production readiness. |

PostgreSQL, UUID identity, migration conventions, and project-wide Layered DDD are governed respectively by [ADR-0003](adr/0003-postgresql-version-baseline.md), [ADR-0004](adr/0004-uuid-primary-keys.md), [ADR-0010](adr/0010-database-migrations-and-schema.md), and [ADR-0011](adr/0011-project-wide-layered-ddd.md). Those decisions do not authorize the physical relationships, columns, indexes, constraints, locks, or migrations discussed as future work here.

### 1.1 Canonical source routing

The detailed claims below use these source sections; a conceptual ERD or dictionary entry alone is never treated as Owner approval.

| Area | Primary sections used |
|---|---|
| Organization/Brand/Branch | [Business Domain Model §§3–5](after_four_business_domain_model.md#3-bounded-context-overview), [DDD Foundation §§2–4](after_four_ddd_foundation.md#2-context-map), and [I1 Design §§1–8](after_four_i1_organization_scope_contract_design.md#1-context-purpose-and-decision-discipline). |
| Identity/access | [Owner Decision Baseline §7](after_four_owner_decision_baseline.md#7-identity-and-authorization), [P1 §§3–15](after_four_p1_trusted_identity_authorization_design.md#3-current-state-evidence), and proposed [ADR-0006](adr/0006-authentication-session-topology.md). |
| Catalog | [Owner Decision Baseline §5](after_four_owner_decision_baseline.md#5-catalogpricing-mvp), [Catalog Core Design §§1–15](after_four_catalog_core_technical_design.md#1-authority-evidence-and-classifications), and [Package C §§1–15](after_four_package_c_technical_design.md#1-purpose-and-authority-boundary). |
| Customer | [Customer Owner Decisions §§1–3](after_four_customer_management_owner_decisions.md#1-purpose-and-provenance), [WP4.1 §§4–12](after_four_customer_domain_boundary_design.md#4-customer-domain-mission), [WP4.2 §§4–16](after_four_customer_lifecycle_phone_consistency_design.md#4-domain-concepts-and-lifecycle-separation), and [WP-T1 §§3–11](after_four_customer_technical_design.md#3-candidate-e-scope). |
| Ordering/Payment/Preparation | [Business Domain Model §8](after_four_business_domain_model.md#8-sales-payment-preparation-printing-and-delivery), [Payment Model §§2–8](after_four_payment_model.md#2-state-vocabularies), [State Machines §§3–10](after_four_state_machines.md#3-mandatory-payment-to-preparation-flow), and [Phase 1 Record §§1–8](after_four_order_payment_implementation_phase1.md#1-scope-decision). |
| Inventory/procurement | [Business Domain Model §9](after_four_business_domain_model.md#9-inventory-and-procurement), [Data Dictionary §8](after_four_data_dictionary.md#8-inventory-and-procurement), and [Data Integrity Rules §9](after_four_data_integrity_rules.md#9-inventory-and-weighted-average-integrity). |
| Cash/expenses | [Owner Decision Baseline §3](after_four_owner_decision_baseline.md#3-cash-management-and-expenses), [Business Domain Model §10](after_four_business_domain_model.md#10-cash-and-finance), [Data Dictionary §9](after_four_data_dictionary.md#9-cash-and-finance), and [State Machines §§13–14](after_four_state_machines.md#13-cash-session-state-machine). |
| Workforce/payroll | [Business Domain Model §6](after_four_business_domain_model.md#6-workforce-and-payroll), [Data Dictionary §4](after_four_data_dictionary.md#4-workforce-and-payroll), and [State Machines §§14–17](after_four_state_machines.md#14-payroll-state-machine). |
| Loyalty/promotions | [Business Domain Model §11](after_four_business_domain_model.md#11-customers-loyalty-and-promotions), [Customer Owner Decisions — SDP-CUST-01, SDP-CUST-02, and SDP-CUST-17](after_four_customer_management_owner_decisions.md), and [WP4.2 §§10, 15–16](after_four_customer_lifecycle_phone_consistency_design.md#10-anonymization-interactions). |
| Operations/reporting/audit | [Business Domain Model §12 and §§15–16](after_four_business_domain_model.md#12-other-operational-domains), [Data Dictionary §§10–11](after_four_data_dictionary.md#10-service-and-operations), [Data Integrity Rules §15](after_four_data_integrity_rules.md#15-audit-approval-and-retention-requirements), and [P2 §§4–13](after_four_p2_brand_scoped_catalog_audit_event_design.md#4-layered-ddd-ownership-and-dependency-direction). |

## 2. Domain inventory

### 2.1 Organization, Brand, and Branch

| Aspect | Inventory |
|---|---|
| Canonical sources and maturity | [Business Domain Model §4.1](after_four_business_domain_model.md), [DDD Foundation — Organization and Branch Management](after_four_ddd_foundation.md), [ERD](after_four_erd.md), and the bounded I1 design in [I1 Organization Scope Contract](after_four_i1_organization_scope_contract_design.md). A1 reference persistence and I1 Brand-to-Organization ancestry resolution have bounded implementation evidence; administration and production mapping are not authorized. |
| Concepts and ownership | Organization is the chain-level authority boundary; Brand belongs to Organization; Branch belongs to Brand. The Organization context owns authoritative ancestry, not Identity or Catalog. |
| Aggregate/lifecycle evidence | Reference identities and ancestry are established. A complete Organization/Brand/Branch administration aggregate, lifecycle, provisioning, and remapping policy is not established. |
| Relationships and invariants | Organization → Brand → Branch is the authoritative hierarchy. I1 resolves Brand ID to authoritative Organization ID and grants no ownership or authorization conclusion. |
| Provenance and sensitive data | Provisioning and mapping provenance remain operational prerequisites. Reference records are not Customer identity evidence; administrative actor evidence would require separately authorized audit integration. |
| Gaps | Production records/mapping, administration authority, lifecycle, cross-Organization operations, and broader consumers require separate design and authorization. |

### 2.2 Identity and access control

| Aspect | Inventory |
|---|---|
| Canonical sources and maturity | [Owner Decision Baseline — Identity](after_four_owner_decision_baseline.md), [Identity Technical Design](after_four_identity_technical_design.md), [P1 Trusted Identity / Authorization Design](after_four_p1_trusted_identity_authorization_design.md), and proposed [ADR-0006](adr/0006-authentication-session-topology.md). I1 ancestry support is implemented; authentication, Session, AuthorizationContext, roles/capabilities, and delegation runtime are not. |
| Concepts and ownership | Person/User identity, Employee relationship, credential, Session, role/capability assignment, Brand-scoped delegation, trusted Actor, authority source, Subject, and AuthorizationContext. Identity owns authentication and authorization facts; it does not own Organization ancestry or Catalog targets. |
| Aggregate/lifecycle evidence | Credential, Session, account, assignment, invitation, delegation, recovery, and revocation lifecycles are designed at differing maturity. ADR-0006 remains `Proposed`; Identity Milestone 2B remains unauthorized. |
| Relationships and invariants | Client-supplied actor, Brand, role, or capability values are not authority. Authorization is capability- and persisted-scope-based, fail-closed, and cross-Brand default-deny within confirmed boundaries. Effective delegation state alone is not authorization. |
| Provenance and sensitive data | Credentials, password/PIN verifiers, MFA/recovery secrets, Session material, and authorization evidence are restricted. Audit must redact secrets. Independent verification and legal review have not been performed where records say so. |
| Gaps | P1 open decisions, MFA/session details under deferred `C0-R05`, advanced retry/idempotency under deferred `C0-R11`, runtime integration, operational roles, and production evidence block physical/runtime design. |

### 2.3 Catalog and pricing

| Aspect | Inventory |
|---|---|
| Canonical sources and maturity | [Catalog Core Technical Design](after_four_catalog_core_technical_design.md), [Package C Design](after_four_package_c_technical_design.md), [Data Dictionary](after_four_data_dictionary.md), and [Data Integrity Rules](after_four_data_integrity_rules.md). Package B supplies bounded Category/Product/Variant persistence and integrity evidence. Runtime Catalog lifecycle operations, P1/P2/P3 integration, pricing, availability, modifiers, recipes, and menu publication are not implemented by that foundation. |
| Concepts and ownership | Brand-owned Category, Product, and Variant; later Catalog concepts include modifier groups/options, availability, recipes, and price definitions. Catalog owns sellable definitions; Ordering owns quoted/confirmed snapshots. |
| Aggregate/lifecycle evidence | Category, Product, and Variant boundaries and lifecycle policies are documented. Product lifecycle commands are excluded from the initial MVP; Package C Category/Variant operations remain unauthorized. |
| Relationships and invariants | Brand-scoped, entity-type-specific code namespaces; Product belongs to Category; Variant belongs to Product; active/default/category consistency; no purge; Variant Archive/Restore preserves configuration flags. Package B uses database backstops, but CAT-TRR operational findings remain governed separately. |
| Provenance and sensitive data | Catalog lifecycle reason and actor/capability evidence are required by C0 decisions. P2 Brand-scoped Catalog AuditEvent is design-only. Catalog data is generally commercial rather than personal, but actor/session evidence is security-sensitive. |
| Gaps | Runtime authorization, database-role boundary, audit implementation, operation-specific error mapping, lifecycle commands, price history, availability, modifiers, recipes, tax/charge/rounding, and real menu data need later decisions/design. |

### 2.4 Customer Management

| Aspect | Inventory |
|---|---|
| Canonical sources and maturity | [Customer Domain Boundary](after_four_customer_domain_boundary_design.md), [Customer Lifecycle and Phone Consistency Design](after_four_customer_lifecycle_phone_consistency_design.md), [WP-T1 Customer Technical Design](after_four_customer_technical_design.md), [WP-G0 Scope Charter](after_four_wp_g0_candidate_e_scope_charter.md), and [Customer Owner Decisions](after_four_customer_management_owner_decisions.md). Candidate E is a frozen, independently reviewed semantic proposal awaiting Owner design acceptance and Gate A. |
| Concepts and ownership | Customer Profile, current phone association, Organization Phone Admission, former-phone restriction, Customer Review Case, and optional Restricted Identity Evidence are distinct concepts. Customer owns Profile lifecycle; Organization-level admission owns phone availability decisions. Phone equality is not identity. |
| Aggregate/lifecycle evidence | Active, Inactive, and Anonymized meanings are approved; Anonymized is terminal for ordinary Profile operations. Candidate aggregates and completion protocols are reviewed proposals, not physical ownership decisions. |
| Relationships and invariants | At most one current Profile association for a normalized phone within an Organization; successful change replaces the current association and restricts the former phone; failed or uncertain completion cannot expose a partial accepted outcome; Customer Profile visibility and Purchase History scope remain distinct. |
| Provenance and sensitive data | Phone and Profile data are personal data. Review evidence, purpose limitation, anonymization evidence, retained provenance, Restricted Identity Evidence, access, retention, legal hold, export, and disposal require strict separation. No legal-compliance conclusion is recorded. |
| Gaps | Candidate E Gate A, physical receiving-context representation, retention/legal rules, authority for five excluded operations, runtime authorization, schema, concurrency/recovery mechanisms, and APIs remain unapproved. |

### 2.5 Loyalty

| Aspect | Inventory |
|---|---|
| Canonical sources and maturity | [Business Domain Model](after_four_business_domain_model.md), [Customer Owner Decisions](after_four_customer_management_owner_decisions.md), and synchronized lifecycle documents provide partial policy evidence. No dedicated implementation-ready Loyalty technical design exists. |
| Concepts and ownership | Customer-linked loyalty account/balance and immutable earning/redemption provenance are candidate Loyalty-owned concepts; Ordering/Payment facts are inputs, not Loyalty-owned transactions. |
| Lifecycle and invariants | Owner policy preserves historical activity and freezes applicable value after anonymization. Exact earning, redemption, expiry, reversal, adjustment, transfer, and cross-Brand rules are not established here. |
| Provenance and sensitive data | Loyalty history may indirectly identify behavior and must not reconstruct anonymized identity. Purpose, access, retention, and audit requirements remain prerequisites. |
| Gaps | Aggregate model, calculation authority, ledger semantics, idempotency, correction rules, Brand/Organization scope, and Customer integration contract require business and technical design before Gate B preparation. |

### 2.6 Promotions and discounts

| Aspect | Inventory |
|---|---|
| Canonical sources and maturity | [Customer Owner Decisions — SDP-CUST-17](after_four_customer_management_owner_decisions.md) and [Customer Lifecycle Design](after_four_customer_lifecycle_phone_consistency_design.md) establish only the anonymization outcome. Advanced Promotions remain a Production MVP scope direction without an implementation-ready domain design. |
| Concepts and ownership | Promotion definition, eligibility/rule evaluation, Customer-specific benefit/entitlement, redemption, and historical provenance are candidate Promotion-owned concepts. Catalog price and Order pricing snapshots remain external facts. |
| Lifecycle and invariants | Successful redemptions remain history; unused Customer-specific benefits freeze at effective anonymization and cannot transfer or be redeemed; public/non-Customer-specific promotion rules remain independently governed. |
| Provenance and sensitive data | Eligibility and redemption evidence may contain Customer behavioral data. Identity restoration through Promotion history is prohibited; purpose and retention constraints remain. |
| Gaps | Eligibility, stacking, calculation, allocation, cancellation/refund effects, cross-Brand rules, entitlement lifecycle, and physical representation are unresolved. |

### 2.7 Ordering and sales

| Aspect | Inventory |
|---|---|
| Canonical sources and maturity | [Business Domain Model — Order Management](after_four_business_domain_model.md), [State Machines](after_four_state_machines.md), [Data Integrity Rules](after_four_data_integrity_rules.md), and [Phase 1 Implementation Record](after_four_order_payment_implementation_phase1.md). Phase 1 has bounded backend implementation; public API activation and full business workflow remain deferred. |
| Concepts and ownership | Order, Order Item, price/product snapshot, fulfillment type, table/session references, Order status, and authoritative total. Ordering owns commercial intent and snapshots; it references Catalog definitions and optional Customer association without owning either domain. |
| Lifecycle and invariants | Draft/confirmation/payment-window/held/expired and preparation-dispatch gating are implemented in a narrow foundation. Confirmed snapshots must not change because Catalog changes. Anonymous Orders are allowed by `SDP-CUST-19`; optional later association is unresolved. |
| Provenance and sensitive data | Actor/Branch UUIDs in Phase 1 are trusted server-provided references, not authentication. Order history may be personal data only when associated with Customer; actor-level accountability must not become employee revenue scoring. |
| Gaps | Catalog-backed item construction, pricing/discount/tax/rounding, tables/additional items, cancellation/refund outcomes, split/partial payment, Customer association, public API, runtime authorization, and operational reporting require later work. |

### 2.8 Payment and refund

| Aspect | Inventory |
|---|---|
| Canonical sources and maturity | [Payment Model](after_four_payment_model.md), [State Machines](after_four_state_machines.md), and [Phase 1 Implementation Record](after_four_order_payment_implementation_phase1.md). Payment/PaymentAttempt safety is bounded implementation evidence; refund and broader settlement are not complete. |
| Concepts and ownership | Payment aggregate, immutable Payment Attempt evidence, provider reference, settlement state, review case, and future refund/allocation concepts. Payment owns settlement truth; Ordering consumes verified settlement outcomes. |
| Lifecycle and invariants | Pending, failed, unknown, mismatched, held, or expired payment cannot dispatch preparation. Late success does not automatically dispatch expired/held Orders. Current exact-balance settlement is an implementation limitation, not a permanent Owner policy. |
| Provenance and sensitive data | Provider payload references and reconciliation evidence need redaction and restricted access; no raw payment credential storage is authorized. Audit/outbox writes participate in bounded transactions where implemented. |
| Gaps | Refund/cancellation authority, partial/split payments, overpayment/mismatch outcomes, chargeback/reconciliation, provider integration, retention, and production idempotency/operations remain open. |

### 2.9 Preparation and fulfillment

| Aspect | Inventory |
|---|---|
| Canonical sources and maturity | [Business Domain Model](after_four_business_domain_model.md), [State Machines](after_four_state_machines.md), and [Phase 1 Implementation Record](after_four_order_payment_implementation_phase1.md). PreparationDispatch/outbox foundation exists; KDS publishing and complete fulfillment operations do not. |
| Concepts and ownership | Preparation Dispatch, dispatch evidence, kitchen ticket/queue concepts, retry intent, and fulfillment status. Preparation owns execution after an authorized paid Order outcome. |
| Lifecycle and invariants | Dispatch identity is reused across retry; retry updates OutboxEvent and appends AuditEvent in the implemented scope. Documentation does not claim a PreparationDispatchAttempt is created when it is not. |
| Provenance and sensitive data | Dispatch/outbox/audit evidence supports operational traceability. Customer data should be minimized at the preparation boundary. |
| Gaps | Publisher/consumer delivery, KDS/ticket lifecycle, retry policy, cancellation after dispatch, handoff, inventory consumption, and production monitoring remain later work. |

### 2.10 Inventory and procurement

| Aspect | Inventory |
|---|---|
| Canonical sources and maturity | [Business Domain Model — Inventory](after_four_business_domain_model.md), [Data Dictionary](after_four_data_dictionary.md), [ERD](after_four_erd.md), and [Data Integrity Rules](after_four_data_integrity_rules.md) describe conceptual entities and invariants. No dedicated reviewed implementation-ready design exists. |
| Concepts and ownership | Ingredient/stock item, Unit of Measure, Stock Movement, Stock Transfer, Purchase Order, receipt, supplier, and recipe-consumption relationship. Inventory owns stock facts; Catalog owns sellable definitions and recipes require an explicit seam. |
| Lifecycle and invariants | Immutable movement-ledger and non-negative/authorized adjustment ideas are documented, but exact source authority, negative-stock policy, reservation, costing, and correction semantics are not fully approved. |
| Provenance and sensitive data | Movement actor, reason, source document, Branch, quantity, unit, and timestamps require provenance. Supplier/commercial data may need restricted access. |
| Gaps | Aggregate boundaries, units/conversion, costing, stocktake, transfer/receipt workflow, concurrency, recipe integration, spoilage, procurement authority, and retention need further domain design. |

### 2.11 Cash, expenses, and shift finance

| Aspect | Inventory |
|---|---|
| Canonical sources and maturity | [Owner Decision Baseline](after_four_owner_decision_baseline.md), [Business Domain Model](after_four_business_domain_model.md), [Data Dictionary](after_four_data_dictionary.md), and [State Machines](after_four_state_machines.md) contain confirmed policies and conceptual records. No bounded implementation-ready technical design is established. |
| Concepts and ownership | Cash Session, float, cash movement, expense, approval, shift handover, counted/expected balance, discrepancy, and evidence attachments. Cash/Expense facts must remain distinct from Payment settlement facts. |
| Lifecycle and invariants | Confirmed float, expense approval, cash handling, handover, and accountability limits must retain exact scope. Physical ledger, correction, close/reopen, and discrepancy resolution mechanisms are unresolved. |
| Provenance and sensitive data | Actor-level cash/expense evidence and approval provenance are sensitive operational records. Reader/export/retention governance is not fully established. |
| Gaps | Aggregate split, relation to shift and Payment, denomination/counting model, exception authority, immutable corrections, Branch/day boundaries, and accounting/legal review remain. |

### 2.12 Workforce and payroll

| Aspect | Inventory |
|---|---|
| Canonical sources and maturity | [Business Domain Model](after_four_business_domain_model.md), [Owner Decision Baseline](after_four_owner_decision_baseline.md), [Data Dictionary](after_four_data_dictionary.md), and [State Machines](after_four_state_machines.md) provide conceptual and policy evidence. No dedicated implementation-ready design exists. |
| Concepts and ownership | Employee, Branch Assignment, shift/schedule, attendance, payroll period/run, pay component, payslip, and adjustment. Workforce facts are not Identity authentication/authorization facts. |
| Lifecycle and invariants | Branch assignments and employment/account lifecycle interact with Identity but require explicit contracts. Payroll closure, adjustment, and employee report accountability need exact approved semantics. |
| Provenance and sensitive data | Employment, attendance, compensation, tax/payroll, and performance-related data are highly sensitive. Actor accountability must not treat Order revenue as an individual performance score. |
| Gaps | Employment/assignment authority, scheduling, time capture, pay calculation, correction, retention, legal/payroll review, and access/export controls block physical design. |

### 2.13 Operations, assets, and table service

| Aspect | Inventory |
|---|---|
| Canonical sources and maturity | [Business Domain Model](after_four_business_domain_model.md), [ERD](after_four_erd.md), and [Data Dictionary](after_four_data_dictionary.md) provide conceptual coverage. Domain ownership and operational workflows are not implementation-ready. |
| Concepts and ownership | Table, dine-in Table Session, asset/equipment, maintenance event, operational checklist, and Branch-scoped configuration. Ordering may reference a table/session but does not thereby own Operations records. |
| Lifecycle and invariants | Table occupancy/session, asset maintenance, and operational task lifecycles need confirmed boundaries and exception policies. |
| Provenance and sensitive data | Operational actor/time/Branch evidence is required; customer or employee data should not be copied without purpose. |
| Gaps | Context ownership, state machines, authority, concurrency, retention, Ordering integration, and physical boundaries remain unresolved. |

### 2.14 Reporting, audit, and reliable processing

| Aspect | Inventory |
|---|---|
| Canonical sources and maturity | [Business Domain Model](after_four_business_domain_model.md), [Phase 1 Implementation Record](after_four_order_payment_implementation_phase1.md), [P2 Catalog AuditEvent Design](after_four_p2_brand_scoped_catalog_audit_event_design.md), and [Package C Design](after_four_package_c_technical_design.md). Phase 1 has bounded Branch-scoped AuditEvent/OutboxEvent evidence; P2 is design-only. |
| Concepts and ownership | Domain event evidence, append-only audit, outbox delivery intent, reporting projections, daily Telegram report, Owner Dashboard, and export/legal-hold boundaries. Audit evidence does not transfer ownership of source-domain facts. |
| Lifecycle and invariants | Append-only and atomic audit requirements are bounded by their source decisions. Daily Telegram reporting and Owner Dashboard requirements are distinct; unapproved report details remain recommendations. |
| Provenance and sensitive data | Actor/target/correlation/reason/before-after evidence needs redaction and reader authorization. Deferred `C0-R08` leaves retention, legal hold, reader, and export governance unresolved. |
| Gaps | Project-wide event taxonomy, P2/P3 implementation, integrity verification, delivery/replay, projection freshness, legal/privacy rules, reader/export authority, and production operations remain. |

## 3. Conceptual relationship inventory

These are logical relationships, not inferred foreign keys or instructions to colocate data.

| Relationship | Classification | Ownership and boundary | Source evidence / remaining issue |
|---|---|---|---|
| Organization → Brand → Branch | Confirmed business relationship; bounded implementation evidence | Organization context owns ancestry. Consumers use an explicit contract. | [Business Domain Model §4.1](after_four_business_domain_model.md) and [I1 Design](after_four_i1_organization_scope_contract_design.md). Administration remains separate. |
| Brand → Category → Product → Variant | Confirmed business relationship; bounded Package B persistence evidence | Catalog owns these definitions and Brand consistency. | [Catalog Core Technical Design](after_four_catalog_core_technical_design.md). Runtime lifecycle is not authorized. |
| Catalog definition → Order snapshot | Confirmed ownership separation; detailed construction remains proposed | Catalog owns current definitions; Ordering owns confirmed historical snapshots. | [Business Domain Model](after_four_business_domain_model.md) and [Data Integrity Rules](after_four_data_integrity_rules.md). Pricing flow is incomplete. |
| Order → Payment | Confirmed business interaction; bounded implementation evidence | Ordering owns payable intent/total; Payment owns attempts and settlement truth. | [Payment Model](after_four_payment_model.md) and [Phase 1 Record](after_four_order_payment_implementation_phase1.md). |
| Verified Payment → Preparation Dispatch | Owner-approved invariant; bounded implementation evidence | Payment result gates a Preparation-owned dispatch identity. | [Phase 1 Record](after_four_order_payment_implementation_phase1.md). Later provider/KDS operations remain deferred. |
| Preparation outcome → Inventory consumption | Contextual association only | Preparation facts may authorize Inventory movement; neither context's ownership transfers. | [Business Domain Model](after_four_business_domain_model.md); integration contract unresolved. |
| Customer Profile ↔ Order | Contextual optional association | Ordering owns Order; Customer owns Profile. Orders may exist without a Profile. | `SDP-CUST-19` in [Customer Owner Decisions](after_four_customer_management_owner_decisions.md); later association remains unresolved. |
| Profile ↔ current phone association ↔ Organization Phone Admission | Reviewed design relationship | Customer Profile, current association, and Organization-level admission remain conceptually distinct. | [WP-T1](after_four_customer_technical_design.md) and [WP4.2](after_four_customer_lifecycle_phone_consistency_design.md); physical representation unresolved. |
| Phone Admission ↔ Customer Review Case ↔ Restricted Identity Evidence | Contextual association only | Admission status is not identity evidence; Review Case and optional restricted evidence retain separate purposes/access. | [Customer Domain Boundary](after_four_customer_domain_boundary_design.md); topology/legal rules unresolved. |
| Effective anonymization → Order/Loyalty/Promotion outcomes | Confirmed business postconditions; coordination proposed | Source contexts preserve lawful provenance without restoring identity. | [Customer Owner Decisions](after_four_customer_management_owner_decisions.md); cross-context completion design remains later work. |
| Identity authorization → Organization/Catalog/Customer targets | Proposed cross-context contract | Owning Application resolves persisted target; Identity evaluates trusted Actor/session/capability evidence. | [P1 Design](after_four_p1_trusted_identity_authorization_design.md); runtime contract is not implemented. |
| Employee ↔ Branch Assignment | Conceptual relationship | Workforce owns assignment; Identity may consume authorization-relevant facts through a contract. | [Business Domain Model](after_four_business_domain_model.md); assignment/authorization boundary needs design. |
| Payment settlement ↔ Cash Session | Contextual association only | Payment owns settlement; cash operations own drawer/session evidence. | [Business Domain Model](after_four_business_domain_model.md); reconciliation and exception contract unresolved. |
| Source-domain facts → Reporting/Audit | Proposed read/evidence relationships | Source contexts retain authority; reports/audit preserve references and provenance, not mutable copies of authority. | [Business Domain Model](after_four_business_domain_model.md) and [P2 Design](after_four_p2_brand_scoped_catalog_audit_event_design.md). |

## 4. Candidate data-integrity requirements

| Logical requirement | Classification | Current evidence | Future design need |
|---|---|---|---|
| Brand belongs to exactly one Organization; Branch belongs to exactly one Brand | `OWNER_APPROVED_BUSINESS_INVARIANT` plus `BOUNDED_IMPLEMENTED_EVIDENCE` | A1/I1 reference foundation and ancestry contract. | Provisioning, lifecycle, mapping, and operational evidence. |
| Category/Product/Variant codes use separate Brand-scoped namespaces | `OWNER_APPROVED_BUSINESS_INVARIANT` plus `BOUNDED_IMPLEMENTED_EVIDENCE` | Catalog decisions and Package B constraints/specs. | Runtime error mapping and role/operation boundary. |
| Product/Category/Variant Brand consistency and active/default final-state rules | `OWNER_APPROVED_BUSINESS_INVARIANT` plus `BOUNDED_IMPLEMENTED_EVIDENCE` | Catalog decisions and Package B database backstops. | Production-like concurrency/role evidence and authorized Application operations. |
| Catalog records are no-purge; lifecycle flags retain their independent meanings | `OWNER_APPROVED_BUSINESS_INVARIANT` plus bounded Catalog enforcement | Owner decisions, Catalog design, Package B. | Privileged-role operational proof; retention remains subject to applicable obligations. |
| Customer phone admission is Organization-scoped and separate from identity | `OWNER_APPROVED_BUSINESS_INVARIANT`; Candidate E design reviewed | Customer decisions and WP-T1/WP4.2. | Physical representation, canonicalization, authority, consistency, and recovery gates. |
| A Profile has no more than one accepted current phone association; successful change restricts the former phone | `OWNER_APPROVED_BUSINESS_INVARIANT`; completion protocol is `ACCEPTED_DESIGN_LEVEL_INVARIANT` pending Owner Gate A | Customer decisions and frozen Candidate E design. | Gate A, then bounded Gate B physical design. |
| Anonymized is terminal for ordinary Customer operations; no identity reconstruction from retained history | `OWNER_APPROVED_BUSINESS_INVARIANT` | Customer decisions and boundary/lifecycle designs. | Retention/legal basis, restricted evidence topology, and receiving-context completion. |
| Only verified successful payment may dispatch preparation | `OWNER_APPROVED_BUSINESS_INVARIANT` plus `BOUNDED_IMPLEMENTED_EVIDENCE` | Order/Payment Phase 1 commands, constraints, and specs. | Provider/production operations and remaining payment policies. |
| Payment Attempt evidence is immutable/idempotent within the implemented flow | `ACCEPTED_DESIGN_LEVEL_INVARIANT` plus bounded implementation | Payment Model and Phase 1. | Provider contract, retention, reconciliation, and production verification. |
| Exact-balance-only settlement | Current implementation limitation, not an Owner-approved permanent invariant | Phase 1 review/record. | Owner policy for split, partial, overpayment, and mismatches. |
| Confirmed Order preserves authoritative commercial snapshots | `OWNER_APPROVED_BUSINESS_INVARIANT`; broader enforcement incomplete | Data Integrity Rules and domain model. | Catalog/pricing integration, item construction, adjustment/cancellation policy. |
| Loyalty history remains while applicable value is frozen after anonymization | `OWNER_APPROVED_BUSINESS_INVARIANT` | Customer decisions. | Loyalty aggregate/ledger and cross-context completion design. |
| Redeemed Promotion history remains; unredeemed Customer-specific benefits freeze and do not transfer after anonymization | `OWNER_APPROVED_BUSINESS_INVARIANT` | `SDP-CUST-17`. | Promotion entitlement/rule engine and cross-context completion design. |
| Inventory movements require durable provenance and must not be silently rewritten | `PROPOSED_TECHNICAL_ENFORCEMENT` supported by conceptual domain rules | Business Domain Model/Data Integrity Rules. | Owner policy for negative stock, corrections, units, costing, and concurrency. |
| Cash/expense changes preserve actor, reason, approval, and shift/Branch provenance | Owner policies exist; physical integrity is `UNRESOLVED_REQUIREMENT` | Owner baseline and conceptual state/data documents. | Aggregate, exception, correction, retention, and accounting design. |
| Payroll/attendance data preserves actor/source and closed-period correction provenance | `UNRESOLVED_REQUIREMENT` with partial policy evidence | Domain/data documents. | Legal/payroll review, lifecycle, access, retention, and calculation authority. |
| Audit is append-only and required mutations fail atomically when their required audit append fails | Bounded Owner-approved/implemented contracts vary by context | Phase 1 evidence; Catalog C0 decisions/P2 design. | Do not generalize one physical AuditEvent schema across contexts; P2/P3 and retention governance remain. |
| Secrets and credentials are excluded/redacted from audit and ordinary domain storage | Owner/security requirement with unimplemented portions | Identity/security and P1/P2/P3 designs. | Runtime controls, verification, incident/rotation, and operational evidence. |
| Personal/restricted data is retained only for an approved purpose and governed access | `UNRESOLVED_REQUIREMENT` beyond confirmed purpose limitations | Customer decisions and deferred governance. | Legal/privacy determination, durations, hold/export/disposal, and reviewer evidence. |

## 5. Database design readiness and dependency matrix

`Gate B preparation status` means readiness to prepare a later bounded proposal, not implementation authorization.

| Domain | Source of truth | Design maturity | Logical model readiness | Open decisions | Gate B preparation status |
|---|---|---|---|---|---|
| Organization/Brand/Branch | Business Domain Model, A1/I1 design | Bounded foundation implemented | `READY_FOR_BOUNDED_EXTENSION_DESIGN` | Administration, lifecycle, production mapping | `PARTIAL — DEFINE EXTENSION SCOPE` |
| Identity/access | Owner baseline, Identity design, P1, ADR-0006 | Partial design; I1 only implemented | `NOT_READY` | P1 decisions, deferred session/MFA/retry, runtime/operational controls | `BLOCKED` |
| Catalog Core | Catalog design, Owner decisions, Package B evidence | Bounded schema/integrity foundation implemented | `READY_FOR_OPERATION-SPECIFIC_LOGICAL_DESIGN` | P1/P2/P3, runtime operations, open CAT-TRR evidence | `PARTIAL — NO RUNTIME AUTHORIZATION` |
| Catalog pricing/menu/availability | Domain/catalog documents | Conceptual/Owner input incomplete | `NOT_READY` | Real prices/menu applicability, tax/charge/rounding, history, availability | `BLOCKED` |
| Customer | Customer decisions, WP4.1/WP4.2, WP-G0/WP-T1 | Frozen independently reviewed semantic proposal | `READY_FOR_OWNER_GATE_A_REVIEW` | Owner semantic acceptance and Gate A; five authority operations excluded | `BLOCKED UNTIL GATE A` |
| Loyalty | Customer decisions and domain model | Partial Owner outcome only | `NOT_READY` | Core policy, aggregate/ledger, scope, corrections, integration | `BLOCKED` |
| Promotions | Customer decisions and domain model | Partial anonymization outcome only | `NOT_READY` | Eligibility, stacking, entitlements, calculation, cancellation/refund | `BLOCKED` |
| Ordering/sales | Domain/state/integrity docs and Phase 1 | Bounded foundation implemented | `PARTIAL` | Catalog/pricing, tables, Customer association, lifecycle exceptions | `PARTIAL — NEW BOUNDED SCOPE REQUIRED` |
| Payment/refund | Payment model and Phase 1 | Bounded settlement safety implemented | `PARTIAL` | Refunds, split/partial/overpayment, mismatch/reconciliation | `BLOCKED FOR BROADER SCOPE` |
| Preparation/fulfillment | Phase 1 and domain/state docs | Dispatch/outbox foundation implemented | `PARTIAL` | KDS/publisher, ticket workflow, retry/monitoring, cancellation | `BLOCKED FOR BROADER SCOPE` |
| Inventory/procurement | Domain model, ERD, dictionary, integrity rules | Conceptual | `NOT_READY` | Aggregate/lifecycle, units, costing, negative stock, authority | `BLOCKED` |
| Cash/expenses | Owner baseline and conceptual domain docs | Confirmed policies; no technical baseline | `NOT_READY` | Aggregate, ledger, exceptions, reconciliation, retention | `BLOCKED` |
| Workforce/payroll | Owner baseline and conceptual domain docs | Conceptual/partial policy | `NOT_READY` | Employment/assignment, time, payroll/legal, retention/access | `BLOCKED` |
| Operations/assets/tables | Domain/ERD/dictionary | Conceptual | `NOT_READY` | Ownership, lifecycle, authority, integrations | `BLOCKED` |
| Reporting/audit/outbox | Domain docs, Phase 1, P2/P3 | Bounded Phase 1 evidence; broader design-only | `PARTIAL` | P2/P3, retention/legal hold/read/export, projections/delivery | `BLOCKED FOR CROSS-CONTEXT BASELINE` |

## 6. Cross-domain dependency map

| Upstream authority | Consumer / interaction | Consistency or sensitive-data concern | Later contract/design required |
|---|---|---|---|
| Organization ancestry | Identity, Catalog, Customer authorization scope | Persisted scope must not be replaced by client input. | Organization Application contract and composition wiring for each authorized consumer. |
| Identity trusted Actor/session/capability | Catalog and Customer use cases | Fail closed; cross-Brand default-deny; no provider/framework leakage inward. | P1 implementation and operation-specific consumer ports. |
| Catalog definitions/prices | Ordering quote/confirmation | Current definitions versus immutable confirmed snapshots. | Versioned quote/snapshot contract and error/requote behavior. |
| Ordering authoritative total/status | Payment | Duplicate/concurrent commands and expiry boundary. | Broader settlement/refund/allocation contract. |
| Payment verified outcome | Ordering/Preparation | No unverified dispatch; late success requires explicit review outcome. | Provider/reconciliation and review-resolution contract. |
| Preparation consumption facts | Inventory | Delivery duplication and unit/recipe version provenance. | Idempotent domain integration contract after Inventory/Recipe design. |
| Customer effective anonymization | Order, Loyalty, Promotions | Preserve purpose-limited history without identity restoration; completion certainty. | Receiving-context contracts and operational recovery after Gate A/B decisions. |
| Customer/Profile association | Ordering and reporting | Association is optional; history visibility remains scoped and sensitive. | Optional association authority/consent/error contract. |
| Workforce assignment | Identity and operational domains | Employment fact is not automatically an authorization grant. | Explicit assignment-to-capability policy/contract. |
| Payment/cash facts | Cash, reporting, reconciliation | Avoid double ownership and mutable duplicate financial truth. | Settlement-to-cash/reconciliation contract. |
| Source-domain events | Audit/outbox/reporting | Redaction, ordering, replay, retention, reader/export boundaries. | Context-specific audit/event contracts; no universal schema inferred. |

## 7. Acceleration strategy

### 7.1 Work that can proceed now

| Parallel work package | Deliverable | True dependency |
|---|---|---|
| Candidate E Owner Review | Record Owner decisions for bounded semantic acceptance and Gate A from the frozen baseline. | Owner review of the [consolidated dossier](../research/after_four_candidate_e_owner_review_dossier.md). |
| Catalog current-state reconciliation | Reconcile pre-implementation design headers with Package B evidence without changing CAT-TRR or runtime authorization. | Existing repository evidence only. |
| Order/Payment policy closure | Prepare decision briefs for refund/cancellation, split/partial/overpayment, mismatch, and late-payment review authority. | Preserve current Phase 1 behavior while decisions remain open. |
| Loyalty/Promotion discovery | Separate approved anonymization outcomes from missing core policies and prepare Owner decision briefs. | Can run in parallel; physical design waits for those policies. |
| Inventory/Cash/Workforce discovery | Refine aggregate ownership, lifecycles, provenance, sensitive-data boundaries, and unresolved policy lists. | Can run in parallel by domain; legal/accounting/payroll conclusions require qualified review or explicit governance. |
| Identity/P1 governance review | Resolve bounded P1 Owner questions and operational prerequisites without implementing Identity. | ADR-0006 stays Proposed and Milestone 2B stays unauthorized. |
| Logical relationship refinement | Maintain conceptual cross-context references and ownership map. | May proceed without choosing foreign keys or colocating persistence. |

### 7.2 Work that must wait

- Candidate E physical/implementation design waits for explicit semantic acceptance and Gate A, followed by a separately authorized Gate B preparation.
- Loyalty and Promotion physical design wait for their core business policies and domain designs, not merely anonymization outcomes.
- Inventory, Cash, Workforce/Payroll, and Operations physical design wait for aggregate/lifecycle and authority closure.
- Runtime authorization/API work waits for its applicable Identity/P1 and operation-specific authorization gates.
- Physical schema, primary/foreign keys, indexes, constraints, isolation/locking, migrations, seeds, database creation, and application code wait for explicit bounded authorization.
- Production readiness waits for operational role/security evidence, legal/privacy requirements where applicable, deployment, monitoring/recovery, Control Acceptance, FOA, and Production Authorization.

These are true dependencies; unrelated domain discovery and decision preparation need not be serialized behind Candidate E.

## 8. Conclusion

Organization/A1-I1, Catalog Package B, and Order/Payment/Preparation Phase 1 provide useful bounded implementation evidence. Candidate E is ready for an Owner semantic-design and Gate A decision, not physical implementation. Every other domain is either partially designed or conceptual and must retain its recorded blockers.

This inventory authorizes no database schema, database object, migration, dependency, runtime contract, application code, gate, deployment, or production operation.
