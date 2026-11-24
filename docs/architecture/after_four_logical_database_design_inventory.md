# AFTER FOUR — Project-wide Logical Database Design Inventory

**Document status:** `TECHNICAL_ANALYSIS — LOGICAL_INVENTORY`

**Physical database design approval:** `NOT_GRANTED`

**Implementation authorization:** `NOT_GRANTED`

**Consolidated against main:** `985ceab1accb9c2101bc24db9d8341d40f1bfff8`

**Date:** 2026-11-24

## 1. Purpose and interpretation

This inventory consolidates existing domain and governance evidence for later database-design work. It is not a physical schema, an implementation baseline, or a substitute for the source documents. The [Business Domain Model](after_four_business_domain_model.md), [Owner Decision Baseline](after_four_owner_decision_baseline.md), accepted ADRs, and domain-specific approved records retain their existing authority.

The inventory uses these classifications:

| Classification | Meaning in this document |
|---|---|
| `OWNER_APPROVED_BUSINESS_INVARIANT` | An Owner-confirmed policy within its recorded scope. It does not select database enforcement. |
| `ACCEPTED_DESIGN_LEVEL_INVARIANT` | A design contract whose applicable acceptance has been recorded within its stated governance boundary. It is not necessarily implemented or approved for production. |
| `INDEPENDENTLY_REVIEWED_TECHNICAL_PROPOSAL` | A technical proposal has completed its recorded independent review but still requires the applicable Owner acceptance and Gate decisions. Review completion is not design acceptance or implementation authority. |
| `PROPOSED_TECHNICAL_ENFORCEMENT` | A technical proposal requiring the applicable design and implementation gates. |
| `UNRESOLVED_REQUIREMENT` | A business, legal/privacy, operational, or technical matter without sufficient approved evidence. |
| `BOUNDED_IMPLEMENTED_EVIDENCE` | Repository implementation and test evidence exists in a bounded package; this does not prove production readiness. |

The following project-wide foundations are already decided: PostgreSQL as the database technology baseline under [ADR-0003](adr/0003-postgresql-version-baseline.md), the UUID primary-key strategy under [ADR-0004](adr/0004-uuid-primary-keys.md), migration and schema-source conventions under [ADR-0010](adr/0010-database-migrations-and-schema.md), and project-wide Layered DDD under [ADR-0011](adr/0011-project-wide-layered-ddd.md). ADR-0003 selects the database platform, ADR-0004 selects the primary-key format, ADR-0010 governs how an authorized migration and schema source are managed, and ADR-0011 governs responsibility placement and inward dependency direction.

Those decisions do not approve domain-specific physical tables or columns, foreign-key topology or cross-context persistence relationships, indexes or physical constraints, transaction boundaries, locking, isolation, concurrency enforcement, domain-specific migrations, or database-object creation. Each later physical design still requires its applicable bounded design review and implementation authorization; Gate B preparation is not merely a migration-execution checkpoint.

### 1.1 Canonical source routing

The detailed claims below use these source sections; a conceptual ERD or dictionary entry alone is never treated as Owner approval.

| Area | Primary sections used |
|---|---|
| Organization/Brand/Branch | [Business Domain Model §§3–5](after_four_business_domain_model.md#3-bounded-context-overview), [DDD Foundation §§2–4](after_four_ddd_foundation.md#2-context-map), and [I1 Design §§1–8](after_four_i1_organization_scope_contract_design.md#1-context-purpose-and-decision-discipline). |
| Identity/access | [Owner Decision Baseline §7](after_four_owner_decision_baseline.md#7-identity-and-authorization), [P1 §§3–15](after_four_p1_trusted_identity_authorization_design.md#3-current-state-evidence), and proposed [ADR-0006](adr/0006-authentication-session-topology.md). |
| Catalog | [Owner Decision Baseline §5](after_four_owner_decision_baseline.md#5-catalogpricing-mvp), [Catalog Core Design §§1–15](after_four_catalog_core_technical_design.md#1-authority-evidence-and-classifications), and [Package C §§1–15](after_four_package_c_technical_design.md#1-purpose-and-authority-boundary). |
| Commercial V1 costing evidence | [Real Menu & Pricing Specification §4](after_four_real_menu_pricing_specification.md#4-commercial-baseline-v1-for-cost-calculation), [52-combination costing input](after_four_commercial_v1_costing_input.csv), [24-Product MAKE input](after_four_commercial_v1_make_recipe_bom_input.csv), [four-Product BUY input](after_four_commercial_v1_buy_finished_procurement_input.csv), and [external research](../research/after_four_commercial_v1_external_ingredient_supplier_research.md). These are costing/evidence inputs, not approved Recipes, procurement facts, published Prices, or implementation authority. |
| Customer | [Customer Owner Decisions §§1–3](after_four_customer_management_owner_decisions.md#1-purpose-and-provenance), [WP4.1 §§4–12](after_four_customer_domain_boundary_design.md#4-customer-domain-mission), [WP4.2 §§4–16](after_four_customer_lifecycle_phone_consistency_design.md#4-domain-concepts-and-lifecycle-separation), and [WP-T1 §§3–11](after_four_customer_technical_design.md#3-candidate-e-scope). |
| Ordering/Payment/Preparation | [Business Domain Model §8](after_four_business_domain_model.md#8-sales-payment-preparation-printing-and-delivery), [Payment Model §§2–8](after_four_payment_model.md#2-state-vocabularies), [State Machines §§3–10](after_four_state_machines.md#3-mandatory-payment-to-preparation-flow), and [Phase 1 Record §§1–8](after_four_order_payment_implementation_phase1.md#1-scope-decision). |
| Inventory/procurement | [Business Domain Model §9](after_four_business_domain_model.md#9-inventory-and-procurement), [Data Dictionary §8](after_four_data_dictionary.md#8-inventory-and-procurement), and [Data Integrity Rules §9](after_four_data_integrity_rules.md#9-inventory-and-weighted-average-integrity). |
| Cash/expenses | [Owner Decision Baseline §3](after_four_owner_decision_baseline.md#3-cash-management-and-expenses), [Business Domain Model §10](after_four_business_domain_model.md#10-cash-and-finance), [Data Dictionary §9](after_four_data_dictionary.md#9-cash-and-finance), and [State Machines §§13–14](after_four_state_machines.md#13-cash-session-state-machine). |
| Workforce/payroll | [Business Domain Model §6](after_four_business_domain_model.md#6-workforce-and-payroll), [Data Dictionary §4](after_four_data_dictionary.md#4-workforce-and-payroll), and [State Machines §§14–17](after_four_state_machines.md#14-payroll-state-machine). |
| Loyalty/promotions | [Business Domain Model §11](after_four_business_domain_model.md#11-customers-loyalty-and-promotions), [SDP-CUST-01 §§1–4](after_four_sdp_cust_01_owner_decision.md#1-decision), [SDP-CUST-02 §§1–5](after_four_sdp_cust_02_owner_decision.md#1-decision), [Customer Owner Decisions — SDP-CUST-17](after_four_customer_management_owner_decisions.md#sdp-cust-17), and [WP4.2 §§10, 15–16](after_four_customer_lifecycle_phone_consistency_design.md#10-anonymization-interactions). |
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
| Concepts and ownership | Brand-owned Category, Product, and Variant; later Catalog concepts include modifier groups/options, availability, recipes, and price definitions. Catalog owns sellable definitions; Ordering owns quoted/confirmed snapshots. Recipe/BOM definition and finished-product procurement evidence require explicit seams without transferring Catalog identity ownership to Inventory/procurement. |
| Aggregate/lifecycle evidence | Category, Product, and Variant boundaries and lifecycle policies are documented. Product lifecycle commands are excluded from the initial MVP; Package C Category/Variant operations remain unauthorized. |
| Relationships and invariants | Brand-scoped, entity-type-specific code namespaces; Product belongs to Category; Variant belongs to Product; active/default/category consistency; no purge; Variant Archive/Restore preserves configuration flags. Package B uses database backstops, but CAT-TRR operational findings remain governed separately. |
| Provenance and sensitive data | Catalog lifecycle reason and actor/capability evidence are required by C0 decisions. P2 Brand-scoped Catalog AuditEvent is design-only. Catalog data is generally commercial rather than personal, but actor/session evidence is security-sensitive. |
| Commercial V1 evidence | The approved costing baseline contains 28 Products and 52 priced Product/Variant combinations: 24 MAKE Products/48 combinations and four BUY_FINISHED Products. No approved Ingredient/BOM quantity, conversion, yield, waste, packaging allocation, finished-product specification, supplier quotation, or actual purchase price exists; unit cost remains calculable for 0/52. External source IDs are candidate evidence only. |
| Gaps | `CORE-OD-18` first-Branch/no-default costing scope conflicts with `ODB-CAT-07` chain-default/Branch-override publication policy and requires explicit Owner reconciliation before publication or implementation. Runtime authorization, price history, availability, Recipes, procurement evidence, tax, precision/rounding, and cost lineage remain unresolved. |

### 2.4 Customer Management

| Aspect | Inventory |
|---|---|
| Canonical sources and maturity | [SDP-CUST-01](after_four_sdp_cust_01_owner_decision.md), [SDP-CUST-02](after_four_sdp_cust_02_owner_decision.md), [Customer Domain Boundary](after_four_customer_domain_boundary_design.md), [Customer Lifecycle and Phone Consistency Design](after_four_customer_lifecycle_phone_consistency_design.md), [WP-T1 Customer Technical Design](after_four_customer_technical_design.md), [WP-G0 Scope Charter](after_four_wp_g0_candidate_e_scope_charter.md), and [Customer Owner Decisions](after_four_customer_management_owner_decisions.md). `E-OR-01` accepts Candidate E's frozen, independently reviewed bounded semantic baseline; `E-OR-02` defers Gate A, which remains `NOT_GRANTED`. |
| Concepts and ownership | Customer Profile, current phone association, Organization Phone Admission, former-phone restriction, Customer Review Case, and optional Restricted Identity Evidence are distinct concepts. Customer owns Profile lifecycle; Organization-level admission owns phone availability decisions. Phone equality is not identity. |
| Aggregate/lifecycle evidence | Active, Inactive, and Anonymized meanings are approved; Anonymized is terminal for ordinary Profile operations. Candidate aggregates and completion protocols are reviewed proposals, not physical ownership decisions. |
| Relationships and invariants | At most one current Profile association for a normalized phone within an Organization; successful change replaces the current association and restricts the former phone; failed or uncertain completion cannot expose a partial accepted outcome; Customer Profile visibility and Purchase History scope remain distinct. |
| Provenance and sensitive data | Phone and Profile data are personal data. Where downstream relationships must remain after anonymization, `SDP-CUST-02` requires purpose-proportionate pseudonymous references rather than unnecessary direct PII and does not itself authorize ordinary or automatic identity reconstruction; `SDP-CUST-22` separately prohibits an ordinary re-identification route. Neither decision selects an identifier, mapping store, access mechanism, or physical topology. Review evidence, purpose limitation, anonymization evidence, retained provenance, Restricted Identity Evidence, access, retention, legal hold, export, and disposal require strict separation. No legal-compliance conclusion is recorded. |
| Candidate E scope boundary | `SDP-CUST-18` and `SDP-CUST-19` are Owner-approved context only and do not add assisted shared/family-phone workflows, anonymous-Order association, or Order-domain implementation to Candidate E. Restricted Identity Evidence remains a separate optional, purpose-dependent boundary under `SDP-CUST-A2`; no physical store or topology is selected. `SDP-SCOPE-01` deliberately defers future multi-Brand participation and visibility semantics, so no cross-Brand model may be inferred. |
| Gaps | Candidate E Gate A is deferred; Candidate E Gate B proposal preparation, physical receiving-context representation, retention/legal rules, runtime authorization, schema, concurrency/recovery mechanisms, and APIs remain unapproved. The five authority-dependent operations excluded from Candidate E remain Customer Profile creation, ordinary Deactivate, Reactivate, anonymization approval/initiation, and ordinary undisputed former-phone release. |

### 2.5 Loyalty

| Aspect | Inventory |
|---|---|
| Canonical sources and maturity | [Business Domain Model §11](after_four_business_domain_model.md#11-customers-loyalty-and-promotions), [SDP-CUST-01](after_four_sdp_cust_01_owner_decision.md), [SDP-CUST-02](after_four_sdp_cust_02_owner_decision.md), and synchronized lifecycle documents provide partial policy evidence. No dedicated implementation-ready Loyalty technical design exists. |
| Concepts and ownership | Customer-linked loyalty account/balance and immutable earning/redemption provenance are candidate Loyalty-owned concepts; Ordering/Payment facts are inputs, not Loyalty-owned transactions. |
| Lifecycle and invariants | `SDP-CUST-01` preserves the existing Loyalty balance, ledger, and necessary transaction/audit history when anonymization becomes effective, freezes redemption, and issues no new Customer-specific benefit. Exact earning, redemption, expiry, reversal, adjustment, transfer, and cross-Brand rules are not established here. |
| Provenance and sensitive data | Under `SDP-CUST-02`, necessary Loyalty history may retain a purpose-proportionate pseudonymous relationship without automatically receiving original identity or mapping access. The reference does not restore redemption eligibility or authorize identity reconstruction. Purpose, access, retention, and audit requirements remain prerequisites. |
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
| Lifecycle and invariants | Draft/confirmation/payment-window/held/expired and preparation-dispatch gating are implemented in a narrow foundation. Confirmed snapshots must not change because Catalog changes. Dine-in/takeaway channel is explicit; Table Session is optional. No initial Service Charge, price-changing Modifier, complimentary/zero-price item, direct sold-price override, or automatic cancellation is permitted. Payment success alone never closes an Order. Anonymous Orders are allowed by `SDP-CUST-19`; optional later association is unresolved. |
| Provenance and sensitive data | Actor/Branch UUIDs in Phase 1 are trusted server-provided references, not authentication. Order history may be personal data only when associated with Customer; actor-level accountability must not become employee revenue scoring. |
| Gaps | Catalog-backed item construction, pricing/discount/tax/rounding, tables/additional items, cancellation/refund outcomes, split/partial payment, Customer association, public API, runtime authorization, and operational reporting require later work. |

### 2.8 Payment and refund

| Aspect | Inventory |
|---|---|
| Canonical sources and maturity | [Payment Model](after_four_payment_model.md), [State Machines](after_four_state_machines.md), and [Phase 1 Implementation Record](after_four_order_payment_implementation_phase1.md). Payment/PaymentAttempt safety is bounded implementation evidence; refund and broader settlement are not complete. |
| Concepts and ownership | Payment aggregate, immutable Payment Attempt evidence, provider reference, settlement state, review case, and future refund/allocation concepts. Payment owns settlement truth; Ordering consumes verified settlement outcomes. |
| Lifecycle and invariants | Pending, failed, unknown, mismatched, held, or expired payment cannot dispatch preparation. Late success does not automatically dispatch expired/held Orders. The initial implementation path is exact-balance cash only; partial/split remains deferred and manual bank is excluded pending separate prerequisites. Cancellation does not authorize Refund, and settlement alone does not close an Order. |
| Provenance and sensitive data | Provider payload references and reconciliation evidence need redaction and restricted access; no raw payment credential storage is authorized. Audit/outbox writes participate in bounded transactions where implemented. |
| Gaps | Refund/cancellation authority, partial/split payments, overpayment/mismatch outcomes, chargeback/reconciliation, provider integration, retention, and production idempotency/operations remain open. |

### 2.9 Preparation and fulfillment

| Aspect | Inventory |
|---|---|
| Canonical sources and maturity | [Business Domain Model](after_four_business_domain_model.md), [State Machines](after_four_state_machines.md), and [Phase 1 Implementation Record](after_four_order_payment_implementation_phase1.md). PreparationDispatch/outbox foundation exists; KDS publishing and complete fulfillment operations do not. |
| Concepts and ownership | Preparation Dispatch, technical delivery attempt, semantic acceptance attempt, Outbox delivery state, Ticket, Ticket Item, item-level progress, completion evidence, customer custody-transfer attempt/evidence, and retry intent are distinct. Preparation owns execution after an authorized paid Order outcome; Ordering owns Order closure eligibility. |
| Lifecycle and invariants | Dispatch identity is reused across delivery retry, but `PREPARATION_DISPATCH_ATTEMPTS` do not substitute for semantic acceptance identity. Candidate Ticket state remains quarantined until authoritative acceptance. Progress is Item-level; quantity-level progress, partial Ticket completion, and partial Ticket handover are excluded. Completion and customer custody transfer are separate. Model A keeps `transfer_evidence_unresolved` nonterminal and fail-closed in the same custody-transfer attempt; acknowledgement alone is not transfer and conflicts require authorized disposition. Order closure requires settled Payment, completed Preparation, custody-transfer evidence, and no open exception. |
| Provenance and sensitive data | Dispatch/outbox/audit evidence supports operational traceability. Customer data should be minimized at the preparation boundary. |
| Gaps | Publisher/consumer delivery, KDS/ticket lifecycle, retry policy, acceptance evidence/guards, custody-transfer evidence classes, intended-recipient linkage, attester/conflict authority, cancellation after dispatch, inventory consumption, and production monitoring remain later work. |

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
| Concepts and ownership | Cash Session, Operating Day, float, cash movement, Cash handover evidence, counted/expected balance, discrepancy, linked correction, and report-release boundary. Cash facts remain distinct from Payment settlement, customer custody transfer, and Reporting projections. |
| Lifecycle and invariants | Explicit Branch timezone and initial `00:00` local cutoff govern Operating Day. Cash handover records outgoing/incoming actors, count, variance, reason, and acknowledgement or disagreement. Unresolved disagreement/refusal escalates to Owner; acknowledgement is not approval or Session Close. Every nonzero discrepancy requires reason and Owner notification; unreconciled facts are withheld from authoritative reporting. Customer custody-transfer Model A does not govern this lifecycle. |
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
| Concepts and ownership | Domain event evidence, append-only audit, outbox delivery intent, reporting projections, Owner Dashboard, deferred external-delivery proposals, and export/legal-hold boundaries. Audit evidence does not transfer ownership of source-domain facts. `SDP-CUST-02` permits a purpose-proportionate pseudonymous Customer reference where downstream provenance must remain; it does not transfer Customer identity or approve access to a reference-to-identity mapping. |
| Lifecycle and invariants | Append-only and atomic audit requirements are bounded by their source decisions. Initial report lineage is limited to authoritative Order, Payment, and pending Preparation Dispatch facts. Cash-dependent facts remain withheld until reconciliation and separately authorized release. Excel export and automatic Telegram/external delivery are deferred. |
| Provenance and sensitive data | Actor/target/correlation/reason/before-after evidence needs redaction and reader authorization. Deferred `C0-R08` leaves retention, legal hold, reader, and export governance unresolved. |
| Gaps | Product/Variant sales, Preparation progress/handover, Cash, Refund/net sales, Expenses/float/top-ups, Promotions, and Loyalty are not initial authoritative report sources. Metric formulas, reader scope, release authority, recipients/schedule, retention/legal hold, event taxonomy, projection freshness, and production operations remain unresolved. |

### 2.15 Core operational-flow consolidation

This cross-domain view is the current logical-design checkpoint. It records consistency, not Gate acceptance or physical design authority.

| Flow boundary | Consolidated logical outcome | Missing decision/evidence and consequence |
|---|---|---|
| Catalog → Order | Order Item keeps Product/Variant identity, source Price Version where applicable, channel, labels, quantity, currency, and immutable sold-price evidence. A changed Draft quote fails closed for explicit review. | `CORE-OD-18` and `ODB-CAT-07` conflict on first publication scope; no Price publication or physical scope constraint is final until Owner reconciliation. Tax and rounding remain deferred. |
| MAKE costing | 24 Products/48 combinations require versioned Recipe/BOM evidence and reproducible source-price lineage; the current matrix is collection evidence only. | No approved Recipe, Ingredient, quantity, conversion, yield, waste, substitute, or packaging allocation exists; 0/48 MAKE costs are calculable. Recipe ownership/scope and sharing remain unresolved. |
| BUY costing | Four Products require finished specification, supplier/offer/quotation/purchase distinctions and mapping to sellable identity. | No finished specification, supplier selection, accepted quotation, actual purchase price, delivery/tax/storage/shelf-life/waste evidence exists; 0/4 BUY costs are calculable. |
| Order → Payment | One Order has a settlement aggregate and immutable attempts. Initial path is exact-balance cash; late/ambiguous results fail closed. | Partial/split, Refund authority/allocation, overpayment evidence and manual-bank prerequisites remain unresolved; Payment success cannot imply Order closure. |
| Payment → Preparation | Eligible full settlement creates one durable Dispatch identity; delivery retry never creates a charge or duplicate business Dispatch. | Physical delivery mechanism remains Gate B work. Acceptance evidence must remain separate from Outbox delivery and Ticket execution state. |
| Preparation → Handover → Order closure | Item-level progress only; all Items complete before whole-Ticket completion; handover is separate; closure additionally requires settled Payment and no open exception. | Recipe Version is optional until an approved Recipe exists. Exception/Refund outcomes and physical evidence mechanisms remain unresolved. |
| Cash → Reporting | Operating Day uses explicit Branch timezone and initial local `00:00` cutoff. Stable handover attempts preserve disputed evidence; nonzero discrepancies require reason/Owner notification and block authoritative reporting. | Cash capability assignment, corrections, conflict/discrepancy disposition, report release, metrics, reader scope, and retention remain unresolved. |
| Reporting lineage | Initial source set is Order, Payment, and pending Preparation Dispatch only. Reporting may project committed facts but never rewrite source domains. | Other sources and external delivery/export remain deferred; including them now would create unsupported authority and irreproducible reports. |

Across every row, ADR-0011 applies: the source Bounded Context owns its business fact and Application contract; downstream contexts consume explicit contracts or committed evidence. This inventory does not select shared aggregates, cross-context database transactions, foreign keys, locks, isolation, persistence technology usage, or deployment topology.

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
| Brand belongs to one Organization; Branch belongs to one Brand | `OWNER_APPROVED_BUSINESS_INVARIANT` | Organization/Brand/Branch decisions and domain model. | Administration, lifecycle, production mapping, and operational evidence. |
| A1 reference relationships and I1 Brand-to-Organization ancestry resolution exist in the bounded authorized scope | `BOUNDED_IMPLEMENTED_EVIDENCE` | A1/I1 implementation and focused evidence. | Does not prove unrestricted Organization administration or production mapping. |
| Category/Product/Variant codes use separate Brand-scoped namespaces | `OWNER_APPROVED_BUSINESS_INVARIANT` | Catalog Owner decisions. | Runtime error contract and operation authority remain separate. |
| Package B enforces the approved Catalog code namespaces in its bounded persistence scope | `BOUNDED_IMPLEMENTED_EVIDENCE` | Package B constraints and specs. | Production-like role and migration evidence remain separately governed. |
| Product/Category/Variant Brand consistency and active/default final-state rules | `OWNER_APPROVED_BUSINESS_INVARIANT` | Catalog Owner decisions. | Authorized lifecycle operations and error behavior remain separate. |
| Package B supplies database backstops for the approved Catalog final-state rules | `BOUNDED_IMPLEMENTED_EVIDENCE` | Package B constraints, triggers, and specs. | CAT-TRR evidence and production-like roles remain open. |
| Catalog no-purge and independent lifecycle/default/visibility meanings | `OWNER_APPROVED_BUSINESS_INVARIANT` | Catalog Owner decisions. | Applicable retention obligations and privileged-operation governance remain. |
| Package B supplies bounded no-purge and lifecycle integrity enforcement | `BOUNDED_IMPLEMENTED_EVIDENCE` | Package B migration and integrity specs. | Does not authorize Package C or runtime lifecycle DML. |
| Phone uniqueness/admission is Organization-scoped and phone equality is not Customer identity | `OWNER_APPROVED_BUSINESS_INVARIANT` | `SDP-CUST-04`, `SDP-CUST-05`, and Customer boundary decisions. | Physical representation and authorized Application workflow remain later work. |
| Candidate E completion, failure-certainty, retry-identity, and multi-resource consistency protocol | `ACCEPTED_DESIGN_LEVEL_INVARIANT` | Independently reviewed frozen WP-T1 baseline accepted through `E-OR-01`, with no outstanding conditions. | Gate A remains deferred; physical design and implementation require separate later authorization. |
| Physical representation and enforcement of the Candidate E Customer phone/admission protocol | `UNRESOLVED_REQUIREMENT` | No Candidate E schema, migration, command, or runtime evidence is authorized. | Do not infer bounded implementation evidence from review completion. |
| Anonymized is terminal for ordinary Profile operations and ordinary identity reconstruction is prohibited | `OWNER_APPROVED_BUSINESS_INVARIANT` | `SDP-CUST-10`, `SDP-CUST-11`, and `SDP-CUST-22`. | Exceptional legal/governance paths, if any, remain separate. |
| Existing Loyalty balance/ledger/history is preserved and applicable value freezes after effective anonymization | `OWNER_APPROVED_BUSINESS_INVARIANT` | `SDP-CUST-01`, preserved by `SDP-CUST-02`. | Loyalty aggregate and receiving-context integration remain undesigned. |
| Redeemed Promotion history remains; unredeemed Customer-specific benefits freeze and do not transfer | `OWNER_APPROVED_BUSINESS_INVARIANT` | `SDP-CUST-17`, constrained by `SDP-CUST-02` purpose limitation. | Promotion entitlement/rule engine and receiving-context integration remain undesigned. |
| Downstream anonymization completion, acknowledgement, reconciliation, and recovery across receiving contexts | `ACCEPTED_DESIGN_LEVEL_INVARIANT` | `E-OR-01` accepts the bounded WP-T1 semantic outcomes; no physical design or downstream implementation proof exists. | Gate A remains deferred; any future physical contracts and mechanisms require separate authorization and must not restore identity. |
| Only verified successful payment may dispatch preparation; pending, failed, unknown, mismatched, held, or expired outcomes do not | `OWNER_APPROVED_BUSINESS_INVARIANT` | Owner baseline and canonical Payment/Preparation rules. | Remaining settlement/refund policies and provider operations remain separate. |
| Phase 1 enforces payment-gated dispatch in its exact bounded command flow | `BOUNDED_IMPLEMENTED_EVIDENCE` | Phase 1 commands, constraints, and focused specs. | Does not prove every provider, refund, reconciliation, or production path. |
| Payment Attempt outcomes are append-preserving/immutable and command evidence is idempotent within the canonical bounded flow | `ACCEPTED_DESIGN_LEVEL_INVARIANT` | Accepted MVP Payment Model and Phase 1 design correction. | Provider-wide, refund, and production reconciliation semantics remain open. |
| Phase 1 implements immutable/idempotent Payment Attempt behavior for its cash/manual-bank exact-balance commands | `BOUNDED_IMPLEMENTED_EVIDENCE` | Phase 1 implementation record and tests. | Evidence must not be generalized beyond the implemented commands. |
| Exact-balance-only settlement is enforced by current Phase 1 commands and constraints | `BOUNDED_IMPLEMENTED_EVIDENCE` | Phase 1 implementation record. | This is not a permanent Owner policy; split, partial, overpayment, and mismatch policy remains unresolved. |
| Permanent allocation policy for split, partial, overpayment, and mismatch outcomes | `UNRESOLVED_REQUIREMENT` | Canonical Payment Model explicitly defers these decisions. | Owner policy and bounded design are required before expansion. |
| Confirmed Order preserves authoritative commercial snapshots | `OWNER_APPROVED_BUSINESS_INVARIANT` | Data Integrity Rules and Business Domain Model. | Catalog/pricing integration, item construction, and adjustment/cancellation policy. |
| Inventory movements require durable provenance and must not be silently rewritten | `PROPOSED_TECHNICAL_ENFORCEMENT` | Conceptual support in the Business Domain Model and Data Integrity Rules. | Owner policy for negative stock, corrections, units, costing, and concurrency. |
| Cash/expense operations preserve confirmed actor, reason, approval, and scope limits | `OWNER_APPROVED_BUSINESS_INVARIANT` | Owner baseline Cash/Expense decisions. | Exact policies retain their recorded limits. |
| Physical Cash/Expense ledger integrity, correction, retention, and reconciliation | `UNRESOLVED_REQUIREMENT` | Conceptual state/data documents only. | Aggregate, exception, accounting, and legal design are required. |
| Payroll/attendance data preserves actor/source and closed-period correction provenance | `UNRESOLVED_REQUIREMENT` | Domain/data documents contain partial policy evidence only. | Legal/payroll review, lifecycle, access, retention, and calculation authority. |
| Required Catalog lifecycle audit is append-only and atomic with its governed mutation | `OWNER_APPROVED_BUSINESS_INVARIANT` | Catalog `C0-R07` and `C0-CAT-07` within their exact scope. | No universal AuditEvent schema or project-wide atomicity guarantee is inferred. |
| Phase 1 audit append/rollback behavior within its command boundary | `ACCEPTED_DESIGN_LEVEL_INVARIANT` | Phase 1 design and implementation record. | It does not establish a project-wide audit contract. |
| Phase 1 persists bounded Branch-scoped AuditEvent evidence atomically in its implemented commands | `BOUNDED_IMPLEMENTED_EVIDENCE` | Phase 1 implementation record and focused specs. | Evidence applies only to those commands and their existing audit shape. |
| P2 Brand-scoped Catalog AuditEvent and P3 runtime database-security controls | `PROPOSED_TECHNICAL_ENFORCEMENT` | P2/P3 design documents; implementation is not authorized. | Separate review, implementation authorization, and operational proof. |
| Project-wide audit retention, legal hold, reader authorization, and export governance | `UNRESOLVED_REQUIREMENT` | Deferred `C0-R08` and domain-specific privacy/legal gaps. | Qualified review and explicit governance before affected production use. |
| Secrets and credentials are excluded/redacted from audit and ordinary domain storage | `PROPOSED_TECHNICAL_ENFORCEMENT` | Identity/security and P1/P2/P3 designs with unimplemented portions. | Runtime controls, verification, incident/rotation, and operational evidence. |
| Personal/restricted data is retained only for an approved and proportionate purpose | `OWNER_APPROVED_BUSINESS_INVARIANT` | `SDP-CUST-02`, `SDP-CUST-08`, and `SDP-CUST-14` within their exact scopes. | Does not decide duration, legal basis, hold, export, or disposal. |
| Exact personal-data retention durations, legal basis, legal hold, reader/export authority, and disposal | `UNRESOLVED_REQUIREMENT` | Customer and audit governance explicitly leave these matters open. | Qualified legal/privacy review and explicit decisions are required. |

## 5. Database design readiness and dependency matrix

`Gate B preparation status` assesses only whether evidence is sufficient to prepare a future bounded proposal. It is not Gate B approval, physical design approval, implementation authorization, or permission to extend an existing implementation. Organization/A1-I1 readiness is limited to bounded extension design rather than unrestricted Organization administration; Catalog Core readiness authorizes neither new runtime lifecycle operations nor Package C implementation; Ordering/Payment/Preparation partial readiness does not expand Phase 1 automatically; and Candidate E's `E-OR-02` outcome explicitly defers Gate A and authorizes no Gate B proposal preparation. Every other domain retains its own policy, domain-design, and authorization prerequisites.

| Domain | Source of truth | Design maturity | Logical model readiness | Open decisions | Gate B preparation status |
|---|---|---|---|---|---|
| Organization/Brand/Branch | Business Domain Model, A1/I1 design | Bounded foundation implemented | `READY_FOR_BOUNDED_EXTENSION_DESIGN` | Administration, lifecycle, production mapping | `PARTIAL — DEFINE EXTENSION SCOPE` |
| Identity/access | Owner baseline, Identity design, P1, ADR-0006 | Partial design; I1 only implemented | `NOT_READY` | P1 decisions, deferred session/MFA/retry, runtime/operational controls | `BLOCKED` |
| Catalog Core | Catalog design, Owner decisions, Package B evidence | Bounded schema/integrity foundation implemented | `READY_FOR_OPERATION-SPECIFIC_LOGICAL_DESIGN` | P1/P2/P3, runtime operations, open CAT-TRR evidence | `PARTIAL — NO RUNTIME AUTHORIZATION` |
| Catalog pricing/menu/availability | Domain/catalog documents | Conceptual/Owner input incomplete | `NOT_READY` | Real prices/menu applicability, tax/charge/rounding, history, availability | `BLOCKED` |
| Customer | Customer decisions, WP4.1/WP4.2, WP-G0/WP-T1, E-OR-01/E-OR-02 | Frozen bounded semantic baseline Owner-accepted | `SEMANTIC_BASELINE_ACCEPTED — GATE_A_DEFERRED` | Future Gate A reconsideration; five authority operations excluded | `BLOCKED — GATE_A_DEFERRED` |
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

Every work package below is documentation, decision preparation, or bounded design analysis only. Its presence in this parallel plan does not approve a Gate, physical model, extension to an existing implementation, or implementation work.

| Parallel work package | Deliverable | True dependency |
|---|---|---|
| Approved Next-Wave documentation/design preparation | Prepare only the P1A/P1B/P1C, P2A/P2B, demand-triggered P2C, and P3 governance/discovery portfolio authorized by `NW-OR-01`. | [Next-Wave Execution Plan](../research/after_four_next_wave_execution_plan.md); Candidate E Gate B proposal preparation is excluded. |
| Catalog current-state reconciliation | Reconcile pre-implementation design headers with Package B evidence without changing CAT-TRR or runtime authorization. | Existing repository evidence only. |
| Order/Payment policy closure | Prepare decision briefs for refund/cancellation, split/partial/overpayment, mismatch, and late-payment review authority. | Preserve current Phase 1 behavior while decisions remain open. |
| Loyalty/Promotion discovery | Separate approved anonymization outcomes from missing core policies and prepare Owner decision briefs. | Can run in parallel; physical design waits for those policies. |
| Inventory/Cash/Workforce discovery | Refine aggregate ownership, lifecycles, provenance, sensitive-data boundaries, and unresolved policy lists. | Can run in parallel by domain; legal/accounting/payroll conclusions require qualified review or explicit governance. |
| Identity/P1 governance review | Resolve bounded P1 Owner questions and operational prerequisites without implementing Identity. | ADR-0006 stays Proposed and Milestone 2B stays unauthorized. |
| Logical relationship refinement | Maintain conceptual cross-context references and ownership map. | May proceed without choosing foreign keys or colocating persistence. |

### 7.2 Work that must wait

- Candidate E physical/implementation design and Gate B proposal preparation wait because `E-OR-02` is `DEFER_GATE_A`; any future continuation requires separate explicit Owner review and authorization.
- Loyalty and Promotion physical design wait for their core business policies and domain designs, not merely anonymization outcomes.
- Inventory, Cash, Workforce/Payroll, and Operations physical design wait for aggregate/lifecycle and authority closure.
- Runtime authorization/API work waits for its applicable Identity/P1 and operation-specific authorization gates.
- Physical schema, primary/foreign keys, indexes, constraints, isolation/locking, migrations, seeds, database creation, and application code wait for explicit bounded authorization.
- Production readiness waits for operational role/security evidence, legal/privacy requirements where applicable, deployment, monitoring/recovery, Control Acceptance, FOA, and Production Authorization.

These are true dependencies; unrelated domain discovery and decision preparation need not be serialized behind Candidate E.

## 8. Conclusion

Organization/A1-I1, Catalog Package B, and Order/Payment/Preparation Phase 1 provide useful bounded implementation evidence. Candidate E's semantic baseline is Owner-accepted, but Gate A is deferred and no Gate B proposal preparation or physical implementation is authorized. The `NW-OR-01` portfolio may proceed only as documentation/design preparation; every domain retains its recorded blockers and separate exit gates.

This inventory authorizes no database schema, database object, migration, dependency, runtime contract, application code, gate, deployment, or production operation.
