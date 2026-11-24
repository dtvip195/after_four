# AFTER FOUR — Accelerated Core Operations Development Readiness Assessment

**Assessment date:** 2026-11-24 (Asia/Tokyo)

**Repository baseline:** `main` / `origin/main` at `d1d8807faa1234fc7924bd522fa26363d1e3a414`

**Scope:** Assessment and planning only

**Implementation authorization created by this assessment:** `NONE`

## 1. Executive readiness summary

AFTER FOUR is **not ready to begin an end-to-end Core Café Operations implementation without a new bounded design baseline and implementation authorization**. It does have useful, tested-in-source foundations:

- Order draft/confirm/hold/expiry commands and exact-balance cash/manual-bank settlement exist as Phase 1 evidence, with idempotency, database integrity and late-success containment; the bounded implementation scope below remains cash-only while manual-bank prerequisites are open ([Order/Payment Phase 1](../architecture/after_four_order_payment_implementation_phase1.md#2-implemented-records-and-states); `backend/app/domains/orders/create_draft.rb:30-79`; `backend/app/domains/payments/confirm.rb:34-101`).
- Successful eligible settlement creates one durable pending Preparation Dispatch plus an Outbox Event; retry requeues that same event (`backend/app/domains/payments/confirm.rb:167-234`; `backend/app/domains/preparation/retry_dispatch.rb:9-45`). It does not create or execute a kitchen ticket.
- Organization/Brand/Branch reference records, the bounded I1 Brand-to-Organization ancestry contract, and the empty Catalog integrity foundation are merged (`backend/app/domains/organization/`; `backend/app/domains/identity/infrastructure/adapters/organization_scope_adapter.rb`; `backend/app/domains/catalog/`; [I1 Gate C decision §4](../architecture/security-reviews/owner-led/af-owner-002-i1-organization-scope-gate-c-decision.md#4-governance-consequences)).
- Catalog schema/integrity tests exist for Category/Product/Variant constraints and migration/concurrency behavior, but no runtime Catalog operation, Pricing, Availability, menu publication or production mapping follows from them ([P1B §11](after_four_p1b_catalog_current_state_reconciliation.md#11-final-status)).

The operational slice is still broken at both ends:

- Rails exposes only health endpoints and an unmatched API error route; it exposes no Catalog, Order, Payment, Preparation or Cash business endpoint (`backend/config/routes.rb:1-9`).
- The POS and upstairs-delivery screens are demos backed by local fixtures/state, not server contracts (`frontend/src/features/pos/data/pos-demo-data.ts:9-73`; `frontend/src/features/pos/hooks/use-demo-order.ts:5-70`; `frontend/src/features/upstairs-delivery/hooks/use-demo-delivery-queue.ts:9-20`). Demo prices are explicitly non-authoritative and do not match the Owner-supplied approximate pricing direction consistently.
- Orders store only an aggregate `total_amount`; there are no Order Item, sold Price snapshot, Price Version, Modifier, Refund, Cash Session, Preparation Ticket/Item, Promotion, Loyalty or operational-reporting records in `backend/db/structure.sql`.
- Trusted authentication/authorization needed for real operators is absent. Only I1 ancestry has Gate A/B/C approval; Identity Milestone 2B remains unauthorized ([Foundation Decisions §5](../architecture/after_four_foundation_decisions.md#5-milestone-2--identity-branch-scope-and-authorization); [AF-OWNER-002 §4](../architecture/security-reviews/owner-led/af-owner-002-i1-organization-scope-gate-c-decision.md#4-governance-consequences)).

The fastest safe path is a **bounded Core Sale Slice** covering authoritative menu/Price reads, Order Items and sold snapshots, Draft/Confirm, exact-balance cash confirmation, and creation of the existing pending Preparation Dispatch. Manual-bank confirmation remains implemented Phase 1 evidence but is conditionally excluded from the initial scope until `CORE-OD-07` and the separately governed trusted operator/capability prerequisite close. This is a bounded scope condition, not permanent policy. The slice must first receive its own Gate A design-baseline approval and Gate B implementation authorization with an exact manifest. Inventory is not a prerequisite.

The Owner has now confirmed `CORE-OD-01` by reference: dine-in plus takeaway, the 28 named Product rows and presented options in [Proposed Launch Menu v3](../architecture/after_four_proposed_launch_menu_v3.md), and approximate price directions of 23,000 / 33,000 / 43,000–49,000 VND. This is recorded with `ID_PENDING_OWNER_GOVERNANCE`; no canonical `ODB-*` ID was allocated. The repository still lacks an exact Product/Variant-to-Price mapping, so the approximate bands are not executable Price rows.

## 2. Evidence and authorization method

This assessment keeps four states separate:

1. **Owner policy:** a bounded business direction in the Owner Decision Baseline.
2. **Design/Gate acceptance:** approval of a named design baseline; it does not authorize implementation.
3. **Implementation authorization:** an explicit bounded Gate B or equivalent decision identifying allowed implementation scope.
4. **Implementation evidence:** code/specs or retained execution evidence; repository presence does not create authority or prove current execution.

No application or database command was run for this assessment. Specs listed below are inspected test artifacts, not newly executed evidence.

## 3. Domain implementation matrix

| Domain | Verified implemented capability and test evidence | Design/policy only or missing | Authorization and Gate state | Can new implementation begin now? |
|---|---|---|---|---|
| Catalog and Pricing | Empty Category/Product/Variant persistence foundation, Domain objects, PostgreSQL invariants and Catalog integration/concurrency/migration specs (`backend/app/domains/catalog/`; `backend/db/migrate/20261115210000_create_catalog_core_foundation.rb`; `backend/spec/integration/catalog_*_spec.rb`). | No runtime create/read/edit/publication API; no Price, Price Version, Branch override, Modifier or Availability runtime. The named menu baseline is approved by reference, but exact persisted records/codes, Variant applicability and individual Prices remain absent. Package C lifecycle is design-review-required and blocked by P1/P2/P3 ([Package C §15](../architecture/after_four_package_c_technical_design.md#15-design-closure-verdict)). | Package B evidence is merged, but P1B grants no new implementation authorization and no runtime Catalog authority ([P1B §10.2](after_four_p1b_catalog_current_state_reconciliation.md#102-p1b-exit-assessment)). No applicable Core Operations Gate A/B/C is recorded. | **No.** CORE-01 is ready for independent Gate A review, not Gate A approval or implementation. |
| Ordering / POS | `Orders::CreateDraft`, `Confirm`, `Hold`, `ExpirePending`; aggregate amount/currency; dine-in/takeaway channel validation (`backend/app/domains/orders/`; `backend/app/models/order.rb:1-16`). Specs cover draft idempotency/concurrency, confirmation, hold and expiry (`backend/spec/services/orders/`). | No Order Items, table assignment contract, server calculation, sold Product/Variant/Price snapshots, cancellation command, close command or business endpoints. POS is demo-only. Closure and cancellation consequences remain partly deferred (`P1A-OD-04`, `05`, `07` in the Owner baseline). | Phase 1 implementation is historical merged evidence, not authority to extend it. P1A explicitly says new implementation authorization is not granted ([P1A header/§1](after_four_p1a_order_payment_policy_closure.md#1-purpose-and-authority-boundary)). | **No new work.** Existing behavior may be used as the reviewed baseline for a new bounded Gate A/B request. |
| Payment / Refund | Exact-balance cash and cashier-confirmed manual bank transfer; immutable attempt evidence; mismatch rejection; late-success review; transaction/concurrency/recovery specs (`backend/app/domains/payments/`; `backend/spec/services/payments/`; `backend/spec/integration/payment_database_integrity*_spec.rb`). | No provider adapter/webhook/query/signature flow; no Refund record/command; no split tender; no excess workflow. Phase 1 only records local operator confirmation ([Order/Payment Phase 1 §§3–4](../architecture/after_four_order_payment_implementation_phase1.md#3-command-seams)). | Existing Phase 1 is merged. P1A-OD-03/06 approve bounded principles, not Refund/provider implementation; Foundation Decisions keep production electronic payment, refunds and reconciliation separately blocked (§2). | **Exact-cash integration only after Core Sale Gate B.** Manual-bank inclusion additionally requires `CORE-OD-07` and separately authorized trusted operator/capability support. Refund/provider work remains blocked. |
| Preparation | Durable unique pending dispatch and outbox identity; explicit dispatch request/retry (`backend/app/domains/preparation/`; `backend/spec/services/preparation/`). | No outbox delivery worker, Preparation Ticket/Item, queue API/UI, start/complete/handover lifecycle, attempt outcome writer or order-close integration. `preparation_dispatch_attempts` is unused scaffolding ([Order/Payment Phase 1 §§2,7](../architecture/after_four_order_payment_implementation_phase1.md#2-implemented-records-and-states)). | No Preparation Gate A/B/C or bounded implementation authorization located. Order closure waits on Preparation/Delivery policy inputs. | **No.** A bounded Preparation execution design and Gate B are required. |
| Cash and reconciliation | Payment cash method exists only as settlement evidence. | No drawer/register topology, Cash Session, Operating Day, movements, count, handover, close or reconciliation runtime. `ODB-CASH-12`–`15` approve limited policy only; authority assignments, transitions and reconciliation consequences remain open ([Owner baseline §Wave 2 Cash](../architecture/after_four_owner_decision_baseline.md#wave-2-cash-owner-decisions)). | Owner policy approved for four bounded directions; no Gate or implementation authorization (§Wave 2 Cash explicitly denies all). CASH-03 clarification, CASH-05 dependency, CASH-07/08 conditions remain. | **No.** Gate A requires remaining Cash policy/technical closure; Gate B then required. |
| Promotions | None. | Advanced Promotions is MVP `MUST`, but formulas, types, eligibility, stacking, priority, allocation, refund interaction and much authority remain unresolved ([Owner baseline §5A](../architecture/after_four_owner_decision_baseline.md#5a-production-mvp-customer-loyalty-and-promotions-scope)). Some lifecycle/capability directions are confirmed, still without executable design. | No Promotion Gate A/B/C and implementation is `NOT_AUTHORIZED`. | **No.** Keep off the initial Core Sale critical path; prepare policy closure in parallel. |
| Loyalty | None. | Basic Loyalty is MVP `MUST`; ledger scope is confirmed, but earning/redemption formulas, allocation, adjustment authority and reversals remain unresolved ([Owner baseline §5A](../architecture/after_four_owner_decision_baseline.md#5a-production-mvp-customer-loyalty-and-promotions-scope)). | No Loyalty Gate A/B/C and implementation is `NOT_AUTHORIZED`. | **No.** Keep off initial transaction critical path; prepare policy closure in parallel. |
| Workforce / Authorization | Organization ancestry contract only; no authenticated User/Session/capability runtime (`backend/app/domains/organization/`; `backend/app/domains/identity/application/ports/organization_scope.rb`). | Workforce policies are discovery/Owner-direction material; User, Employee, Branch Assignment, Session and operation capabilities are not implemented. ADR-0006 remains Proposed. | I1: Gate A `APPROVED`, Gate B `APPROVED`, implementation merged, Gate C `APPROVED`; FOA/production not granted. All broader Identity/Workforce work and Milestone 2B remain unauthorized ([AF-OWNER-002 §4](../architecture/security-reviews/owner-led/af-owner-002-i1-organization-scope-gate-c-decision.md#4-governance-consequences)). | **Only I1’s existing bounded contract.** Core operator authorization cannot begin without separate Gate A/B. |
| Reporting | Audit Event, Payment Attempt, Payment Review Case and outbox evidence exist. | No report projections/API/UI, Cash reconciliation report, sales-by-item/Branch report, tax/accounting report or reporting access/retention policy. Aggregate Orders lack authoritative component provenance. | NW-OR-01 permits governance/discovery preparation only; no reporting implementation Gate or authorization ([Owner baseline `NW-OR-01`](../architecture/after_four_owner_decision_baseline.md#wave-1-semantic-design-gate-and-portfolio-decisions)). | **No.** A read-model/reporting design can be prepared in parallel; implementation requires Gate B and authoritative upstream facts. |

## 4. End-to-end operational flow gaps

### A. Select Product → create Order → calculate amount → pay → confirm Payment

**Current evidence:** demo Product selection and local calculation exist only in React; backend can create an aggregate-total Draft, confirm it, and settle exact-balance cash or locally confirmed manual bank. There is no API joining them and no authoritative Product/Variant/Price/Order Item path. This historical manual-bank behavior is preserved, but it is not included in the bounded first-slice implementation scope while its policy and trusted-operator prerequisites remain open.

**Missing critical links:** exact transcription of Product/Variant records and individual Prices from the approved-by-reference baseline; Catalog read contract; effective Price resolution; Order Items and sold snapshots; server calculation; table/takeaway context; Presentation endpoints; trusted operator context; frontend API integration. A Draft line must bind one Price version, unrelated Draft edits must not silently reprice it, and any changed authoritative Price requires explicit re-quote/revalidation and review before confirmation under `ODB-CAT-09`. The exact concurrency mechanism remains a Gate B proposal. The existing `Orders::CreateDraft` accepts client-provided `total_amount` (`backend/app/domains/orders/create_draft.rb:7-27`), which is unsuitable as the final authoritative sales calculation boundary.

**Readiness:** `READY_FOR_INDEPENDENT_GATE_A_REVIEW — NOT_READY_FOR_GATE_A_APPROVAL`. Calculation policy and exact Price transcription remain blockers; implementation then needs Gate B.

### B. Confirm Order → dispatch → prepare → complete → hand over

**Current:** full eligible payment creates a pending dispatch and outbox event atomically. No consumer turns it into a kitchen ticket. Frontend delivery status changes are local demo state and explicitly do not update Order/Payment/kitchen data (`frontend/src/features/upstairs-delivery/components/delivery-detail-content.tsx:85-118`).

**Missing critical links:** outbox consumer contract; Preparation Ticket/Item aggregate; queue/read API; started/completed/handover transitions; actor/capability rules; failure/retry evidence; idempotent Order/Preparation linkage; fulfillment-to-Order closure rule. PreparationDispatch business state, Outbox delivery state and Ticket execution state must remain separate; duplicate delivery must resolve to one Ticket and never duplicate Ticket Items. Progress granularity, partial completion and partial handover are separate Owner questions.

**Readiness:** `DESIGN_AND_AUTHORIZATION_REQUIRED`.

### C. Open Cash Session → movements → count → handover → close → Operating Day reconciliation

**Current:** no executable Cash lifecycle exists. Payment cash confirmation is not a Cash Session or drawer ledger.

**Missing critical links:** actual Branch timezone and explicit cutoff; configuration/inheritance and exceptional-day behavior; capability assignees and separation; discrepancy classification/authority; movement taxonomy; session transition matrix; handover acknowledgement versus approval/disagreement; correction operations; discrepancy resolution, unresolved-case disposition and report-release authority; physical register/device scope. Reconciliation already precedes authoritative reporting under `P2B-CASH-OD-08`. No chain-wide timezone may substitute for the Branch timezone required by `ODB-CASH-12`.

**Readiness:** `OWNER_AND_TECHNICAL_CLOSURE_REQUIRED`, followed by Gate A/B.

### D. Apply Promotion / Loyalty

**Current:** no runtime or schema. Owner-approved directions are incomplete and explicitly non-authorizing.

**Missing critical links:** eligible value/components, formulas, deterministic order/rounding, stacking, entitlement/ledger facts, allocation and Refund/reversal behavior, capability matrix, Customer linkage and audit.

**Readiness:** `NOT_ON_INITIAL_CORE_SLICE`; policy work can proceed in parallel, but neither domain can be represented as usable.

### E. Produce operational reports

**Current:** raw Order/Payment/Audit records could support narrow engineering diagnostics, not authoritative operational reporting.

**Missing critical links:** item and component provenance; Preparation completion; Refund; Cash reconciliation; report definitions; source-of-truth and correction semantics; access control; retention/export governance; read models and APIs.

**Readiness:** `UPSTREAM_FACTS_AND_AUTHORIZATION_REQUIRED`.

## 5. Authorization matrix

| Workstream | Gate A | Gate B / implementation authorization | Gate C / control acceptance | Actual evidence | Current consequence |
|---|---|---|---|---|---|
| I1 Brand → Organization ancestry | `APPROVED` | `APPROVED`, exact bounded manifest | `APPROVED` under `AF-OWNER-002`; independent verification not performed | Merged implementation/specs | Reusable only for its ancestry contract; no broader authorization. |
| Candidate E Customer semantic design | `DEFER_GATE_A — NOT_GRANTED` | `NOT_AUTHORIZED` | Not applicable | Design only | Cannot implement Customer scope. |
| Catalog Package B foundation | No A/B/C record found; separate historical bounded implementation produced merged code | No new/runtime authorization | None | Merged schema/domain/spec artifacts; retained execution evidence not re-run here | Foundation only; no runtime operation/Pricing. |
| Order/Payment Phase 1 | No A/B/C vocabulary record found for this historical phase | Historical implementation is merged; P1A grants no extension | None | Commands, migrations and specs exist; not executed here | May be baseline evidence, not authorization for new APIs/features. |
| Preparation execution | `NOT_GRANTED / no record found` | `NOT_GRANTED / no record found` | None | Pending dispatch only | No ticket or fulfillment implementation. |
| Cash | `NOT_GRANTED / no record found` | `NOT_GRANTED` | None | Policy documents only | Cannot implement. |
| Promotions | `NOT_GRANTED / no record found` | `NOT_AUTHORIZED` | None | Policy/discovery only | Cannot implement. |
| Loyalty | `NOT_GRANTED / no record found` | `NOT_AUTHORIZED` | None | Policy/discovery only | Cannot implement. |
| Workforce/Identity beyond I1 | Design work exists; ADR-0006 Proposed | Milestone 2B `NOT_AUTHORIZED` | None | No runtime identity/session/capability implementation | Blocks real operator authorization. |
| Reporting | `NOT_GRANTED / no record found` | `NOT_GRANTED / no record found` | None | Source evidence only | Cannot implement reports. |

“No record found” is an assessment result, not a new status assignment.

## 6. Critical path

1. **Freeze the bounded Core Sale business input:** transcribe the approved-by-reference menu into exact Product/Variant records and authoritative Price versions within the approximate directions; preserve dine-in/takeaway and exclude Inventory, Promotions and Loyalty from this first slice.
2. **Gate A — Core Sale Slice design baseline:** Catalog read/effective Price → Order Items/snapshots → Draft/Confirm → exact-balance cash → pending Preparation Dispatch; specify errors, idempotency, transactions, authorization ports and test evidence without selecting unauthorized Identity behavior. Manual bank remains conditional and outside the initial implementation scope.
3. **Gate B — exact implementation manifest:** migrations/files/endpoints/configuration/tests allowed; safe data/bootstrap approach; explicit non-goals; test environment and evidence owner.
4. **Implement Core Sale Slice:** replace client totals with server-authoritative calculation; expose bounded APIs; connect POS to real contracts; preserve Phase 1 settlement/dispatch invariants.
5. **Preparation execution Gate A/B:** implement tickets and preparation/handover lifecycle, then close the Order only under approved guards.
6. **Core operator Identity/Authorization Gate A/B:** required before operational use by real Staff; I1 alone is insufficient.
7. **Cash Session Gate A/B:** complete Cash policy dependencies and implement reconciliation before calling the system operationally complete.
8. **Operational Reporting Gate A/B:** build only from the authoritative facts produced above.

FOA, production authorization, deployment, production database roles and production data remain separate after all implementation packages.

## 7. Largest safe parallel work-package plan

| Package | Objective and deliverables | Exact repository scope candidate | Dependencies / existing authority | Tests and acceptance evidence | Start now? |
|---|---|---|---|---|---|
| `CORE-01` Core Sale Gate A package | Approved-by-reference commercial baseline; API/Application/Domain contracts; Draft Price-version binding and explicit re-quote/review; Order Item/snapshot/calculation model; dine-in/takeaway rules; exact-cash baseline; Inventory/Promo/Loyalty exclusions; Gate B candidate manifest. | Documentation only; no source/schema. | `CORE-OD-01`, `ODB-CAT-01`–`13`, Phase 1 evidence and ADR-0011; exact Price transcription and calculation policy still needed. Manual bank additionally depends on `CORE-OD-07` and trusted operator/capability authorization. | Traceability, no-silent-repricing, deactivation/Branch/race/failure cases, cash-only boundary and independent design review. | **Independent Gate A review can start for the cash-only scope.** Approval remains blocked; Gate B required. |
| `CORE-02` Preparation execution design | Separate Dispatch/Outbox/Ticket lifecycles; idempotent acceptance and duplicate delivery; progress granularity; partial completion/handover; queue contract, retries and Order closure dependency. | Documentation only; future candidate paths under `backend/app/domains/preparation/` and specs must not be created yet. | Existing pending dispatch; P1A-OD-07 deferred closure guards. Needs Owner decisions for completion/handover/closure where absent. | State/sequence tests, duplicate/out-of-order delivery, one-Ticket invariant, crash/retry, cross-Branch isolation and closure races. | **Yes, design/policy preparation only.** Implementation Gate B required. |
| `CORE-03` Core operator Identity/Authorization | Preserve the existing operator/session/Branch/capability dependency without expanding it in this closure. | No new repository scope in this task. | I1 approved only for ancestry; ADR-0006 Proposed; Milestone 2B unauthorized. | Future separately authorized threat/fail-closed and security evidence. | **No new work in this closure.** Separate authorization and Gate A/B mandatory. |
| `CORE-04` Cash closure | Resolve remaining Cash decisions and prepare Cash Session/Operating Day design with immutable linked corrections and reconciliation. | Cash research/design documents only. | `ODB-CASH-12`–`15`; CASH-03/05/07/08 unresolved/conditional. | Lifecycle, capability, discrepancy, handover, close/reconcile and reporting-hold acceptance matrix. | **Policy/design preparation yes; implementation no.** |
| `CORE-05` Reporting contract | Define minimum operational reports and source-evidence lineage without building projections. | Reporting design/research only. | Requires item, Preparation, Refund/Cash facts; NW-OR-01 governance/discovery only. | Field/source lineage, correction/reconciliation semantics, access and retention review. | **Partial design can start; implementation blocked.** |
| `CORE-06` Promotion/Loyalty policy closure | Resolve calculation, eligibility, sequencing, allocation/reversal and authority needed for a later optional slice. | Existing P2A research/governance documents only. | Numerous conditional/dependency-blocked Owner candidates; no implementation authority. | Candidate-by-candidate policy acceptance and future Gate A prerequisites. | **Yes in parallel as policy work; not on Core Sale implementation path.** |

After Gate B, the largest safe implementation parallelism is narrower than the design parallelism: Catalog/Pricing + Order snapshot/calculation must establish the contract before frontend integration; Preparation can implement behind the stable dispatch contract; operator Identity must be integrated before any operational acceptance; Reporting can build only after source facts stabilize.

## 8. Inventory deferral

Immediate Core Operations explicitly excludes:

- stock management;
- purchasing and suppliers;
- stock transfers;
- Recipe-based automatic stock deduction;
- stocktake and waste management; and
- batch, lot and expiry tracking.

Order creation, exact server pricing, settlement and Preparation completion must not require Inventory availability or posting. Preserve future integration by:

- keeping Order sold snapshots owned by Ordering and Product/Price truth owned by Catalog/Pricing;
- keeping Preparation progress owned by Preparation;
- publishing stable, idempotent facts only after separately approved integration design;
- avoiding stock columns, Recipe logic or Inventory callbacks in Ordering/Payment/Preparation; and
- treating future consumption/deviation posting as a downstream consumer that cannot roll back already-authoritative Payment truth.

This deferral does not reverse existing Inventory Owner decisions; it removes Inventory implementation from the immediate critical path only.

## 9. Immediate next actions and Owner decisions required

### Immediate actions

1. Do not reopen the approved `CORE-OD-01` menu. Freeze a traceable transcription into exact Product/Variant records and individual Prices; the approximate bands alone remain insufficient executable pricing facts.
2. Submit the cohesive `CORE-01` package for independent Gate A review; resolve review findings and blocking calculation inputs before requesting Owner Gate A approval.
3. In parallel, close the `CORE-02` and `CORE-04` Owner ballots and keep `CORE-05` limited to source lineage. Do not expand `CORE-03`; Identity Milestone 2B remains unauthorized. Keep `CORE-06` outside the first transaction slice.
4. Request explicit Gate A decisions separately for Core Sale, Preparation execution and Cash after their prerequisites close. Operator Identity/Authorization remains a separately governed prerequisite, not part of this closure.
5. Only after each Gate A approval, submit an exact Gate B manifest. No source/schema work should begin from this assessment.

### Owner decisions and evidence still required for the immediate path

- **Evidence/data gap, not a renewed menu decision:** exact transcription of Product/Variant records and individual Prices from the approved-by-reference baseline, including price-per-size mapping and effective date/time.
- Minimum dine-in table/service context and takeaway identification required at Order creation.
- Core Sale calculation components: tax display/treatment, rounding, Service Charge existence or explicit exclusion, Modifier price effects, complimentary/zero-price behavior and manual sold-price override exclusion/policy.
- Preparation progress granularity, partial completion, partial handover, stage-specific cancellation consequences, completion evidence, handover evidence and independently governed Order closure guards.
- Bounded operator capabilities/assignees for Order, Payment and Preparation pending the separately governed Identity design. Until `CORE-OD-07` and trusted operator/capability prerequisites close, manual bank remains outside the cash-only first slice.
- Cash Session discrepancy investigation/resolution, correction authority, handover acknowledgement versus approval, Session transition, close/reconciliation and separately governed reporting hold/release details.
- Reporting metrics/source scope, read and Branch scope, export, recipients/delivery, cutoff and retention as independent decisions; none grants another authority implicitly.

Refund/provider reconciliation, Promotions, Loyalty and full Reporting remain follow-on decision sets and must not be silently pulled into the first Core Sale package.

## 10. Unverified assumptions and assessment limits

- No tests, Rails commands, database commands or services were run; current pass/fail status is unverified.
- No remote fetch was performed. `main`, HEAD and local `origin/main` were identical at assessment start; this proves local synchronization only.
- The Owner-approved pricing direction is recorded under provisional `CORE-OD-01` with `ID_PENDING_OWNER_GOVERNANCE`; it is not a canonical ODB allocation or authoritative individual Price dataset.
- No production/staging environment, deployed service, runtime role, operational data or external provider was inspected.
- “Can start” means documentation/design preparation under an existing authorization boundary, never implementation authority.

**Final assessment:** `CORE_OPERATIONS_NOT_IMPLEMENTATION_READY — CORE_01_READY_FOR_INDEPENDENT_GATE_A_REVIEW — GATE_A_APPROVAL_NOT_GRANTED — INVENTORY_DEFERRED_FROM_CRITICAL_PATH — NO_NEW_AUTHORIZATION`.
