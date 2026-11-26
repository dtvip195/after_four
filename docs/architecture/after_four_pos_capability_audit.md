# AFTER FOUR — Existing DDD Capability Audit and POS Exposure Design

**Status:** Phase 0 audit complete; Phase 1 exposure design proposed; no implementation authorization implied

**Audit date:** 2026-11-27

**Scope:** Read-only inspection of the existing repository implementation

**Architecture baseline:** [Owner Decision Baseline](after_four_owner_decision_baseline.md), [ADR-0011](adr/0011-project-wide-layered-ddd.md), and [ADR-0012](adr/0012-ordering-payment-preparation-ddd-boundaries.md)

## 1. Executive conclusion

AFTER FOUR already has a substantial Layered DDD backend foundation. Ordering, Payment, and Preparation contain Domain models, Application use cases and ports, Infrastructure adapters and repositories, composition roots, persistence enforcement, and broad automated tests. Identity has a working authentication/session slice exposed through HTTP. Organization, Catalog, and Workforce contain narrower foundations at explicitly different levels of completeness.

The application is not yet an operable POS. The primary missing layer is not a replacement Domain architecture; it is the application exposure around the existing architecture:

1. business HTTP adapters are absent outside Identity;
2. authorization currently recognizes only self-session read, not POS capabilities or Branch scope;
3. read/query use cases required by screens are mostly absent;
4. the frontend is explicitly local demo behavior and sends no business API requests; and
5. the current Order foundation has no Order Items, Catalog/Pricing binding, or server-authoritative quote. ADR-0012 intentionally preserves caller-supplied totals as a known limitation.

Therefore, existing use cases can be exposed incrementally, but a production POS order-creation flow must not expose `CreateDraft` as a client-trusted total endpoint. Order Items, sold-price snapshots, and authoritative quoting/repricing are a genuine Domain/Application capability gap and require separate approved design before implementation.

No existing bounded context, aggregate, use case, namespace, persistence model, or dependency direction should be replaced to address these gaps.

## 2. Audit method and classification

The audit inspected:

- Domain aggregates, entities, value objects, invariants, and errors;
- Application use cases, queries, contracts, and ports;
- Infrastructure adapters, repositories, mappers, Active Record records, migrations, and PostgreSQL structure;
- composition roots and jobs;
- Rails routes, controllers, authentication concerns, and Pundit policies;
- frontend routes, feature modules, fixtures, hooks, and end-to-end tests;
- RSpec behavioral, integration, concurrency, request, and architecture tests; and
- Packwerk package declarations and architecture characterization tests.

This report uses the following per-layer classifications:

| Code | Meaning |
|---|---|
| `I` | Implemented for the stated capability in executable production code. |
| `P` | Partial or foundation-only implementation; not sufficient for the stated end-to-end capability. |
| `N` | No implementation found at this layer. |
| `D` | Demo-only frontend behavior, deliberately disconnected from production business behavior. |
| `N/A` | The layer is not required for this specific capability. |
| `V` | Relevant automated behavior is present and recorded passing in the latest repository test artifact. |
| `T` | Tests exist, but coverage is narrower than the complete capability. |
| `U` | No relevant automated behavior was found. |

The repository test artifact [`backend/spec/examples.txt`](../../backend/spec/examples.txt) records 389 of 389 examples passing at 2026-11-26 11:34:44 +0900. This audit did not rerun application, database, Packwerk, or frontend commands because it is documentation-only. `V` therefore means verified by present tests and the latest recorded artifact, not independently rerun during this audit.

## 3. Phase 0 capability matrix

### 3.1 Organization, Identity, and Workforce

| Capability | Domain | Application | Infrastructure | Composition | API | Authorization | Frontend | Tests | Finding |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| Organization/Brand/Branch reference model | `P` | `P` | `I` | `N` | `N` | `N` | `D` | `V` | Structural entities and PostgreSQL records exist. No management commands or user-facing query API exists. |
| Resolve Brand ancestry to Organization | `N/A` | `I` | `I` | `N` | `N` | `N` | `N` | `V` | A narrow, framework-independent query and reader port exist and are used through Identity's adapter, but there is no general composition root or endpoint. |
| Username/password sign-in and session issue | `N/A` | `I` | `I` | `I` | `I` | `P` | `N` | `V` | Devise-backed credential verification, lockout handling, opaque cookie session issue, and request endpoint exist. Sign-in is authentication, not POS operation authorization. |
| Authenticate, read, and revoke own session | `N/A` | `I` | `I` | `I` | `I` | `I` | `N` | `V` | Cookie authentication, idle/absolute expiry, CSRF verification for sign-out, self-session authorization, and sign-out are implemented. |
| Authorize POS/Branch business operations | `N` | `N` | `N` | `N` | `N` | `N` | `N` | `V` | Tests explicitly constrain the authorization registry to `identity.session.read_self`; no Order, Payment, Preparation, Catalog, Cashier, or Branch capability is recognized. |
| Employee identity foundation | `P` | `P` | `I` | `N` | `N` | `N` | `N` | `V` | An immutable Employee identity aggregate, repository port, mapper, Organization-scoped repository, and schema exist. No Employee command/query use case or production write entry point exists by design. |
| Workforce assignment, role, capability, or Branch membership | `N` | `N` | `N` | `N` | `N` | `N` | `N` | `V` | Architecture tests explicitly verify the absence of Membership and production Employee entry points. Authentication users are not yet connected to a POS workforce authorization model. |

### 3.2 Catalog and menu selection

| Capability | Domain | Application | Infrastructure | Composition | API | Authorization | Frontend | Tests | Finding |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| Catalog Category/Product/Variant structure | `I` | `N` | `I` | `N` | `N` | `N` | `D` | `V` | Brand membership, code, lifecycle, optimistic-locking, and default-Variant invariants are represented in Domain and PostgreSQL. Persistence records project to Domain objects. |
| Catalog lifecycle and mutation operations | `P` | `N` | `P` | `N` | `N` | `N` | `N` | `T` | Lifecycle states and database enforcement exist, but no Application commands/repositories expose creation, edit, activation, default designation, or archival workflows. |
| POS menu/product read | `P` | `N` | `P` | `N` | `N` | `N` | `D` | `T` | Persisted Catalog data exists, but there is no Application query contract for a Branch/Brand menu and no HTTP endpoint. Frontend products are hard-coded demo fixtures. |
| Authoritative Product/Variant pricing | `N` | `N` | `N` | `N` | `N` | `N` | `D` | `U` | Catalog core has no authoritative price model in production code. Frontend VND prices are explicitly unapproved demo data. |

### 3.3 Ordering

| Capability | Domain | Application | Infrastructure | Composition | API | Authorization | Frontend | Tests | Finding |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| Create idempotent Draft Order and exact-balance Payment target | `I` | `I` | `I` | `I` | `N` | `N` | `D` | `V` | Complete internal command path exists with transactionality, audit evidence, concurrency handling, and semantic replay. It accepts a caller-supplied total and has no item or Catalog binding. |
| Confirm Draft Order and establish payment deadline | `I` | `I` | `I` | `I` | `N` | `N` | `N` | `V` | Aggregate transition, optimistic concurrency, configured Payment Window, audit, and persistence are implemented. |
| Hold a confirmed unpaid Order | `I` | `I` | `I` | `I` | `N` | `N` | `N` | `V` | Domain rule, Payment fact check, reason, idempotency, locking, audit, and transaction behavior are implemented. |
| Expire confirmed unpaid Orders | `I` | `I` | `I` | `I` | `N/A` | `N/A` | `N/A` | `V` | Use case and scheduled job exist; the aggregate rechecks deadline and unpaid status under locks. Runtime schedule/deployment operation was not audited as production-authorized. |
| Read/list/search an Order or active queue | `P` | `N` | `P` | `N` | `N` | `N` | `D` | `U` | Repository operations exist for internal commands, but there is no Application query/read model, composition entry point, or endpoint for screens. |
| Order Items, quantity, notes, sold snapshots, and server pricing | `N` | `N` | `N` | `N` | `N` | `N` | `D` | `U` | Frontend models these only in local React state. ADR-0012 explicitly excludes these capabilities from the current backend foundation. |
| Cancel or close an Order | `P` | `N` | `P` | `N` | `N` | `N` | `N` | `U` | Status vocabulary and columns include `cancelled` and `closed`, but there are no Domain transition methods or Application use cases. Current Owner policy decisions defer consequence/closure matrices. |

### 3.4 Payment

| Capability | Domain | Application | Infrastructure | Composition | API | Authorization | Frontend | Tests | Finding |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| Exact-balance cash settlement | `I` | `I` | `I` | `I` | `N` | `N` | `D` | `V` | Full command flow exists with Order eligibility, immutable attempt evidence, semantic replay, audit, atomic Preparation Dispatch, and rollback guarantees. |
| Exact-balance bank-transfer confirmation | `I` | `I` | `I` | `I` | `N` | `N` | `D` | `V` | Uses the same settlement orchestration and method-specific composition facade. No external bank verification provider is present. `CORE-OD-07` excludes manual bank from the initial POS slice pending separate Branch capability and evidence prerequisites. |
| Amount-mismatch containment | `I` | `I` | `I` | `I` | `N` | `N` | `N` | `V` | Failed immutable attempt and audit evidence are persisted, while the Application result raises the bounded error after the transaction. |
| Late-success containment and review case | `I` | `I` | `I` | `I` | `N` | `N` | `N` | `V` | Financial truth is retained, dispatch is withheld, and an open Payment Review Case is recorded. No review-resolution use case or operator API exists. |
| Payment/read attempt/review queries | `P` | `N` | `P` | `N` | `N` | `N` | `N` | `U` | Persistence supports command reconstruction and internal lookups, but no screen-oriented Application query contract exists. |
| Partial/split tender | `P` | `N` | `P` | `N` | `N` | `N` | `N` | `U` | Status vocabulary anticipates partial funding, but no reachable Domain behavior or use case exists. Owner policy explicitly defers activation. |
| Refund/reversal | `P` | `N` | `P` | `N` | `N` | `N` | `N` | `U` | Refund-related state vocabulary exists, but no executable refund aggregate behavior, use case, persistence workflow, endpoint, or UI exists. Policy principle alone is not implementation authority. |

### 3.5 Preparation and delivery

| Capability | Domain | Application | Infrastructure | Composition | API | Authorization | Frontend | Tests | Finding |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| Create idempotent Preparation Dispatch after verified settlement | `I` | `I` | `I` | `I` | `N` | `N` | `N` | `V` | Settlement and recovery paths create a unique pending Dispatch, Outbox intent, and audit evidence inside the required transaction boundary. |
| Manually request/recover a missing Dispatch | `I` | `I` | `I` | `I` | `N` | `N` | `N` | `V` | Rechecks locked Order and Payment eligibility before creating missing dispatch intent. |
| Retry pending Dispatch delivery | `I` | `I` | `I` | `I` | `N` | `N` | `N` | `V` | Requeues the stable Outbox identity with audit/idempotency and concurrency coverage. |
| Publish/consume Dispatch event and mark dispatched | `P` | `N` | `P` | `N` | `N` | `N` | `N` | `T` | Outbox records and `pending`/`dispatched` persistence vocabulary exist, but no publisher/consumer or Domain transition that marks Dispatch dispatched was found. Tests manipulate publication state as fixtures. |
| Preparation Ticket, Ticket Items, kitchen progress | `N` | `N` | `N` | `N` | `N` | `N` | `N` | `U` | ADR-0012 leaves the future Ticket/Ticket Item aggregate boundary unresolved. Dispatch intent is not a kitchen production workflow. |
| Upstairs delivery workflow | `N` | `N` | `N` | `N` | `N` | `N` | `D` | `T` | A polished, tested frontend demo exists, but its queue and status changes are session-local fixtures and do not represent backend business capability. |

### 3.6 Cashier, Branch operations, reporting, Sales, Billing, and POS frontend

| Capability | Domain | Application | Infrastructure | Composition | API | Authorization | Frontend | Tests | Finding |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| Cashier operation authorization | `N` | `N` | `N` | `N` | `N` | `N` | `N` | `U` | Payment commands accept actor identity internally, but no cashier role/capability or Branch assignment is enforced. |
| Cash session, float, drawer, handover | `N` | `N` | `N` | `N` | `N` | `N` | `N` | `U` | No executable Cash bounded capability was found. Owner decisions do not imply code. |
| Table/floor and Branch operations | `P` | `N` | `P` | `N` | `N` | `N` | `D` | `U` | Branch references persist; frontend floors/tables/statuses are demo-only. No table/floor domain or operational workflow exists. |
| Sales reporting | `N` | `N` | `N` | `N` | `N` | `N` | `N` | `U` | The Sales package is an empty strict boundary and the Reports screen is a placeholder. No reporting read model/API exists. |
| Billing business capability | `N` | `N` | `N` | `N` | `N` | `N` | `N` | `U` | Billing is an empty strict package boundary only. |
| POS UI shell, menu/order/payment interaction design | `N/A` | `N/A` | `N/A` | `N/A` | `N` | `N` | `D` | `T` | Responsive UI and Playwright scenarios exist, but code and copy explicitly state that all data and mutations are demo-only. The payment test verifies that confirmation sends no API request. |

## 4. Architecture and boundary audit

### 4.1 Preserved dependency direction

The implemented Ordering, Payment, and Preparation source follows the intended direction:

```text
Presentation (currently absent for business capabilities)
    -> Composition Roots
        -> Application Use Cases / context-owned ports
            -> Domain
        <- Infrastructure adapters implement those ports
```

Cross-context settlement does not directly load another context's Active Record model. Payment Application coordinates through Ordering- and Preparation-owned contracts, with Infrastructure adapters supplied at composition. Architecture tests scan for direct cross-context persistence access and keep the current violation allowlist empty.

Organization and Identity similarly use a narrow Organization Application query through an Identity Infrastructure adapter. Workforce Domain/Application are framework-independent and do not depend on Identity or Organization internals.

### 4.2 Packwerk status

All context packages declare `enforce_dependencies: strict`. Their declared dependencies reflect the current adapters and composition shape. The root package does not enforce dependencies, and no context package declares `enforce_privacy`. Consequently, the strongest currently evidenced safeguards are:

- strict context dependency declarations;
- focused architecture specs for OPP and I1 boundaries; and
- explicit composition-root contracts.

No Packwerk command was rerun during this documentation audit. Phase 1 implementation must preserve current package declarations and architecture specs, then run `bin/packwerk validate` and `bin/packwerk check` as part of its backend verification.

### 4.3 Presentation and security boundary

The only business HTTP controller is Identity session management. It is thin and routes through Identity Application use cases. It implements same-origin checks for sign-in/sign-out, cookie authentication, CSRF verification for sign-out, Pundit at the HTTP boundary, and authorization through the Identity Application service for session read.

No business endpoint currently derives an actor from the trusted session and invokes Ordering, Payment, Preparation, Catalog, Organization, or Workforce. Internal command parameters named `actor_id`, `branch_id`, `amount`, and `total_amount` are not proof that an HTTP caller is entitled to supply those values. A future controller must derive actor and allowed scope from trusted authorization context and must never accept client actor identity as authority.

## 5. Missing capability at the correct layer

| Missing capability | Correct owning layer | Why it belongs there |
|---|---|---|
| POS capability identifiers and Branch-scoped authorization decisions | Identity Application contracts/use cases, backed by approved Workforce/Organization contracts where required | Controllers may adapt requests but must not invent role, capability, or scope rules. |
| Menu/product read model | Catalog Application query/port plus Infrastructure projection | A controller must not query Catalog Active Record directly. |
| Order, Payment, Dispatch, and review-case screen reads | Each owning context's Application query/contract and Infrastructure adapter | Existing command repositories are not an HTTP read API and must not be bypassed. |
| Thin business HTTP endpoints and response presenters | Presentation | Request parsing, trusted-context extraction, status mapping, serialization, and error rendering are adapter concerns. |
| Composition wiring for new queries | Composition root | Controllers should receive complete Application capabilities without constructing Infrastructure dependencies. |
| Order Items and sold snapshots | Ordering Domain, then Application and Infrastructure | Item identity, quantity, snapshots, totals, and mutation invariants are business rules, not controller or React convenience logic. |
| Authoritative price/quote/reprice capability | Approved owning Domain/Application boundary, coordinated with Catalog/Pricing and Ordering | The current caller-supplied total cannot safely become production POS authority. Ownership and integration contract require approved design. |
| Cashier/Branch entitlement source | Workforce/Identity/Organization Application contracts following approved policy | Authentication alone does not establish operational authority. |
| Dispatch publication and kitchen execution | Preparation Application/Infrastructure; future Ticket Domain only after decision | Creating durable dispatch intent is implemented; consuming it and managing production state are separate capabilities. |
| Cash session and handover | Future approved Cash domain/application design | Payment settlement is not a cash-drawer ledger. |
| Sales reporting | Sales/reporting Application read model and projections | Reports should consume explicit contracts/projections rather than query foreign context tables from controllers. |
| POS API client and server-state hooks | Frontend POS feature | The frontend should call HTTP contracts and display server truth; it must not duplicate Domain decisions. |

## 6. Phase 1 POS exposure design

### 6.1 Mandatory adapter shape

Every business endpoint must retain this flow:

```text
HTTP controller
  -> authenticate cookie and establish trusted authorization context
  -> authorize an operation-specific capability and Organization/Branch scope
  -> validate/adapt HTTP input
  -> invoke an existing or newly approved Application use case/query through composition
  -> serialize an Application result
```

Controllers must not:

- load or mutate context Infrastructure records;
- accept `actor_id` as client authority;
- calculate authoritative totals or payment eligibility;
- reproduce Order, Payment, or Preparation state transitions;
- create Dispatch or Outbox records directly; or
- translate demo-only frontend behavior into business rules.

### 6.2 Recommended delivery sequence

#### Stage 1 — Trusted POS session and authorization foundation

Extend the existing Identity Application authorization registry with operation-specific capabilities only after the matching Owner-approved policy and scope are identified. Add the minimum Workforce/Organization Application contracts needed to establish Organization and Branch entitlement. Keep Pundit as the Presentation adapter, delegating decisions to Identity Application as the session policy already does.

Required outcome: a controller can derive the trusted actor and Branch scope without trusting client-supplied identity or generic role names.

#### Stage 2 — Read-only POS APIs

Add context-owned Application queries and Infrastructure projections for:

1. active Branch/Brand menu data;
2. Order detail/list state;
3. Payment settlement/attempt/review state; and
4. Preparation Dispatch queue state.

Expose these through thin authenticated, authorized controllers. This stage is additive and does not redesign existing aggregates. Catalog pricing cannot be represented as authoritative until its missing production capability is approved and implemented; the API must not publish demo prices as server truth.

#### Stage 3 — Expose already-implemented commands where their input model is safe

Add endpoints around existing composition roots for:

- Order confirmation;
- Order hold;
- exact-balance cash confirmation;
- Preparation Dispatch recovery request; and
- Preparation Dispatch retry.

Each endpoint needs an operation-specific authorization capability, Branch/Organization scope verification, idempotency contract, error mapping, and request tests. Payment and Preparation endpoints must reuse `PaymentComposition` and `PreparationComposition`; they must not recreate settlement or dispatch orchestration.

The existing bank-transfer confirmation command remains preserved but is not part of the initial exposure slice. `CORE-OD-07` requires separate Branch-scoped capability and evidence prerequisites before a future HTTP adapter may be approved.

Order confirmation should not be made user-operable until the Draft it confirms was created through a trustworthy server-authoritative item/price flow.

#### Stage 4 — Close the production Order-creation gap through separate approved design

Prepare an Owner-reviewable technical design for:

- Order Item and sold-snapshot ownership;
- Product/Variant identifiers and availability facts;
- authoritative price selection, quote lifetime, and repricing behavior;
- totals, discounts/tax/service-charge boundaries if applicable;
- item notes/modifiers and quantity invariants;
- idempotency fingerprint changes;
- Draft mutation semantics; and
- Catalog/Pricing-to-Ordering integration contracts.

This is the only stage in this plan that necessarily reaches Domain design. It must be separately approved because ADR-0012 explicitly excludes it and because exposing caller-supplied totals would create a security and financial-integrity defect.

#### Stage 5 — Connect the POS frontend

Replace feature-local demo fixtures incrementally with typed API adapters and server-state hooks inside `frontend/src/features/pos/`. Preserve presentational components where useful. Keep temporary demo data isolated and visibly non-production until each vertical slice is connected.

Recommended first real vertical slice after Stage 4:

```text
authenticated Branch session
  -> load authoritative menu
  -> create priced Draft with items
  -> confirm Order
  -> record exact-balance cash settlement
  -> observe Preparation Dispatch
```

Do not connect the current payment-success modal to a fake success response, and do not clear or mutate server Orders based solely on local React state.

#### Stage 6 — Later operational capabilities

Preparation Ticket execution, upstairs delivery, cashier/cash sessions, Branch table/floor operations, refunds, partial/split tender, cancellation/closure consequences, and Sales reporting remain separate capabilities. They should proceed only after their unresolved Owner policy and Domain ownership questions are closed. Their absence must not be used to downgrade the already-implemented settlement and dispatch-intent foundations.

## 7. Proposed API surface for design review only

The following is a responsibility map, not an approved contract or implementation authorization:

| Intent | Presentation adapter | Application capability |
|---|---|---|
| Read current session | Existing `GET /api/v1/auth/session` | Existing `Identity::Application::UseCases::ReadOwnSession` |
| Read active menu | New Catalog controller | New Catalog Application query; no direct Active Record access |
| Read/list Orders | New Orders controller | New Ordering Application queries |
| Confirm Order | New Order action | Existing `OrderingComposition.confirm_use_case` |
| Hold Order | New Order action | Existing `OrderingComposition.hold_use_case` |
| Confirm cash settlement | New Payment action | Existing `PaymentComposition.confirm_cash` |
| Confirm bank transfer | Deferred under `CORE-OD-07` | Existing `PaymentComposition.confirm_bank_transfer` is preserved but not exposed in the initial slice |
| Read Payment/review state | New Payment controller | New Payment Application queries |
| Read Dispatch queue | New Preparation controller | New Preparation Application query |
| Request missing Dispatch | New Preparation action | Existing `PreparationComposition.request_dispatch` |
| Retry Dispatch delivery | New Preparation action | Existing `PreparationComposition.retry_dispatch` |
| Create production POS Draft | Deferred endpoint design | New approved Ordering item/price capability; do not expose caller-supplied total as authority |

Exact paths, verbs, payloads, error codes, concurrency headers, and capability identifiers require a separate API contract review against [ADR-0009](adr/0009-api-conventions-versioning.md) and the canonical [API Contract](after_four_api_contract.md).

## 8. Required verification for later implementation

For each authorized vertical slice, verification should include:

- Domain/Application unit coverage for any newly approved behavior;
- request specs for authentication, CSRF where applicable, authorization, scope, idempotency, error mapping, and response contracts;
- integration and concurrency regression coverage around existing transaction and lock ordering;
- architecture specs proving controllers do not access Infrastructure and contexts do not bypass ports;
- `bin/packwerk validate` and `bin/packwerk check`;
- backend RSpec suite and security checks appropriate to the change;
- frontend `npm run typecheck`, `npm run lint`, and `npm run build`;
- Playwright coverage against real API behavior for connected screens; and
- explicit confirmation that demo fixtures cannot enter production paths.

## 9. Authorization boundary and next decision

This report changes no source, schema, route, controller, policy, package declaration, dependency, or runtime behavior. It does not authorize Milestone 2B or any other implementation.

The lowest-risk next implementation package is the trusted POS authorization foundation plus read-only Application queries and HTTP adapters. Before that package is implemented, its exact capability identifiers, Organization/Branch scope rules, files, and tests should be submitted for Owner approval.

Production Order creation remains separately blocked on an approved Order Item and authoritative Pricing/quote technical design. Existing Ordering, Payment, and Preparation internals should be reused unchanged unless that design demonstrates a specific confirmed requirement they cannot support.
