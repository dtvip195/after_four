# AFTER_FOUR_POS_MASTER_EXECUTION_READINESS_REPORT

**Prepared:** 2026-11-27

**Verdict:** `DOCUMENTATION_READY — IMPLEMENTATION_GATED`

**Current milestone:** Milestone 2A — Gate A approved; Gate B not authorized

**Scope:** Repository evidence, dependency analysis, design readiness, and approval identification only

**Runtime changes authorized by this report:** None

## 1. Repository baseline

| Item | Observed value |
|---|---|
| Repository | `/Users/tad/project/after_four` |
| Branch | `development` |
| HEAD | `b49a8827be53797b30ea1d7cb47791e7c74e7231` |
| Current tracked modifications | None observed before this report |
| Existing untracked POS document | `docs/architecture/after_four_pos_capability_audit.md` |
| Existing untracked Audit workstream documents | Five `docs/research/organization_level_audit_*.md` files |
| Default integration branch | `development` |
| Commit/push/merge authorization | Not granted |

The current DDD implementation baseline is governed by the [Owner Decision Baseline](after_four_owner_decision_baseline.md), [ADR-0009](adr/0009-api-conventions-versioning.md), [ADR-0011](adr/0011-project-wide-layered-ddd.md), and [ADR-0012](adr/0012-ordering-payment-preparation-ddd-boundaries.md). The completed [POS capability audit](after_four_pos_capability_audit.md) is current at the observed HEAD; no new runtime evidence invalidates it.

The worktree is not clean because Owner/parallel-workstream documents are untracked. They must not be reset, cleaned, stashed, overwritten, committed, or silently incorporated into a feature branch. A later implementation milestone must re-check branch, HEAD, status, and parallel changes before editing.

## 2. Current DDD capability status

| Context/package | Current executable capability | Exposure status | Readiness consequence |
|---|---|---|---|
| Organization | Organization/Brand/Branch reference persistence and Brand-to-Organization ancestry query | Internal foundation only | Reuse the existing Organization Application seam; add Branch ancestry only if the approved POS authorization interface demonstrates the need. |
| Identity | Password authentication, opaque sessions, authentication context, self-session read authorization | Session HTTP only | Deepen the existing authorization module rather than create a second authorization mechanism. |
| Workforce | Organization-scoped Employee identity and repository foundation | No workflow or HTTP | Employee Branch Assignment and eligibility query are missing and gated. |
| Catalog | Category/Product/Variant domain and persistence foundations | Demo frontend only | Application menu queries and authoritative Pricing remain missing. |
| Orders | Draft creation, confirmation, hold, expiration, concurrency, idempotency, persistence, audit adapter | No business HTTP | Preserve and later expose existing use cases; current caller-supplied total is not safe POS authority. |
| Payments | Exact-balance cash/bank confirmation, attempt evidence, mismatch/late-success containment, review case | No business HTTP | Reuse settlement orchestration. Initial approved commercial slice remains cash-only even though bank-transfer code exists. |
| Preparation | Dispatch creation, recovery, retry, outbox intent | No business HTTP/consumer | Preserve Dispatch intent and transaction boundaries; Ticket execution remains a separate missing domain capability. |
| Sales | Strict empty package | None | Reporting must use explicit projections/contracts later. |
| Billing | Strict empty package | None | No current POS capability. |
| Platform | Database/readiness and shared technical facilities | Internal | The separate Audit Evidence proposal may later add a Platform module, but it is not authorized or implemented. |
| Frontend | Responsive POS/payment/delivery demonstrations | Explicit demo-only behavior | No production business mutation may be connected until server authority and authorization exist. |

The audit's most important constraint remains: the missing POS surface is not permission to replace the existing DDD implementation. Presentation must call composition roots, which call context-owned Application interfaces; Infrastructure remains behind those seams. This is required by [ADR-0011](adr/0011-project-wide-layered-ddd.md) and the implemented OPP design in [ADR-0012](adr/0012-ordering-payment-preparation-ddd-boundaries.md).

## 3. Parallel Organization-Level Audit workstream conflict assessment

### 3.1 Current state

The five untracked Organization-Level Audit documents are active design work dated 2026-11-26/27. Their current verdict is not implementation-ready: external/focused review and later executable evidence remain outstanding. The package explicitly grants no schema, migration, runtime, API, producer, catalog registration, deployment, Gate, FOA, or Production Authorization ([assessment](../research/organization_level_audit_foundation_assessment.md), [decision package](../research/organization_level_audit_foundation_decision_package.md), [logical contract](../research/organization_level_audit_logical_contract_design.md), [PostgreSQL design](../research/organization_level_audit_postgresql_design.md), [security closure](../research/organization_level_audit_security_design_closure.md)).

The proposed Audit Evidence module is intentionally independent. Its empty first slice has no production producer. New POS authorization, assignment, pricing, order, cash, or reporting events cannot be registered or emitted merely because Identity policy requires eventual audit evidence.

### 3.2 Conflict decision

| Area | Conflict level | Required treatment |
|---|---|---|
| Documentation paths | Low | Do not edit the five Audit documents. POS status/design documents may link to them. |
| `Platform::AuditEvidence` future namespace | Medium | Treat as reserved by the active workstream; do not invent a parallel audit module. |
| Existing `AuditEvent` model and OPP adapters | High if touched | Leave unchanged. The Audit package explicitly requires separately authorized incremental producer migration. |
| New POS authorization/assignment audit producers | Blocking | Document required events and an interface point only. Do not create a producer, registration, payload, append call, or failure semantic. |
| Transaction semantics | High | Do not weaken existing OPP atomic audit behavior or assume the proposed Audit transaction protocol is implemented. |
| Shared source/schema files | Blocking if later plans overlap | Re-inspect immediately before implementation and coordinate a reviewed manifest. |

**Assessment:** documentation preparation can proceed without conflict. Milestone 2A implementation cannot include audit production. If the Owner requires authorization/assignment mutations in the first executable slice, that slice is blocked until the Audit workstream separately approves the applicable producer contract or the Owner explicitly approves a bounded interim approach that preserves existing audit requirements without changing the active Audit design.

## 4. Milestone dependency graph

```text
2A POS Authorization Foundation
 ├──> 2B Read Application/API
 ├──> 2C Order Commercial Foundation
 │      └──> 2D POS Order Operations
 │              ├──> 2E Payment Operations
 │              │      └──> 2F Preparation Operations
 │              └────────────> 2F Preparation Operations
 ├──> 2H Cashier/Cash Management
 ├──> 2I Branch/Table Operations
 └──> 2J Sales/Reporting authorization

2B ──> 2G read-only frontend integration
2C + 2D ──> 2G order/cart integration
2E ──> 2G payment integration
2F ──> 2G preparation integration

2D + 2E + 2F + 2H + 2I ──> 2J reliable reporting facts
2A through every approved operational milestone ──> 2K Production Readiness

Independent gated dependency:
Organization-Level Audit Foundation/producer approval
 └──> every new POS event producer or audited mutation
```

### 4.1 Dependency detail

| Milestone | Hard prerequisites | Can proceed in parallel | Blocking unresolved matters |
|---|---|---|---|
| 2A Authorization | Confirmed Identity/Workforce/Organization ownership; existing session trust; I1 Organization seam | Detailed 2B query inventory and 2C policy preparation | Exact capability/role matrix, step-up implementation, physical linkage/assignment design, security model approval, schema authorization, Audit producer dependency |
| 2B Read Application/API | 2A trusted operation/Branch authorization for exposed endpoints; ADR-0009 | Context query designs can be prepared while 2A is reviewed | Read capability identifiers/scopes; pagination/filter contracts; Catalog availability/pricing truth |
| 2C Commercial Foundation | 2A; Catalog/Pricing ownership; approved commercial policies | Preparation Ticket design discovery | Tax treatment and monetary precision/rounding remain deferred; Modifier pricing and exact quote protocol remain unresolved; schema/ADR amendment approval required |
| 2D Order Operations | 2C authoritative items/pricing; 2A | Read-only Order queries may precede mutations | Resume policy; complete cancellation consequences; closure depends on Preparation/handover and open exceptions |
| 2E Payment Operations | 2A; 2B Payment reads; trustworthy Order total from 2C/2D for production checkout | Exact-balance cash exposure design | Initial slice excludes manual bank; review resolution, refunds, reversals, partial/split tender remain gated |
| 2F Preparation Operations | 2A; existing Dispatch; 2B queue reads; 2E settlement facts | Outbox publication design may be reviewed separately | `OPP-ARCH-13` event version; `OPP-ARCH-16` Ticket/Ticket Item boundary; cancellation/execution policies; audit producer approval |
| 2G Frontend | Incremental: 2A auth, 2B reads, 2C/2D order, 2E payment, 2F preparation | Presentational refactoring that does not claim business behavior | No fake success; server-state/dependency choice needs approval if it adds a runtime package |
| 2H Cash | 2A; approved Cash domain ownership/design; Operating Day facts | Documentation/design only | Capability assignments/separation of duties and post-close corrections remain deferred; schema and Audit integration gated |
| 2I Branch/Table | 2A; Organization scope; Catalog availability for menu effects | Minimal table discovery can run separately | Table/session/transfer/merge rules; Branch override activation beyond Commercial V1; domain ownership and schema |
| 2J Reporting | 2A read authorization; reliable facts from in-scope operational milestones | Initial projection design limited to approved source lineage | Report-read capability/scope and retention/legal hold remain deferred; gross/net/refund/cash definitions depend on implemented facts |
| 2K Production Readiness | Every feature claimed in the release, executed evidence, Audit compatibility, deployment decisions | Review preparation throughout delivery | Production configuration, deployment, FOA, security/legal blockers, unresolved operations |

## 5. Owner decisions already available

### 5.1 Authorization and context ownership

The following do not need to be re-asked:

- User and Employee remain distinct; their link is optional one-to-one. Workforce owns Employee and Employee Branch Assignment. Identity owns User, Role Assignment, Sessions, trusted authorization context, and authorization resolution. Organization owns Organization, Brand, and Branch ([Identity authorization](after_four_identity_authorization.md#21-separation-of-concerns)).
- Non-Owner Branch authorization requires both an effective Identity Role Assignment and effective Workforce Employee Branch Assignment. Missing, stale, unavailable, invalid, or Organization-mismatched evidence fails closed; Role Assignment alone is insufficient ([authorization calculation](after_four_identity_authorization.md#33-authorization-calculation)).
- Owner scope is Organization-wide. Branch Manager and Staff are Branch-scoped. Regional Manager is reserved and inactive. No Region model is authorized ([Identity decisions ID-09, ID-10, ID-13](after_four_identity_decision_register.md#owner-decisions-confirmed)).
- Role/Branch Assignment changes require Owner approval. Branch Managers cannot self-elevate or approve their own assignments ([ID-09 and ID-13](after_four_identity_decision_register.md#owner-decisions-confirmed)).
- Capabilities are fixed and code-owned, not arbitrary per-User permission expressions. Operation-specific checks replace generic role-name authorization ([Identity authorization §3.1](after_four_identity_authorization.md#31-fixed-roles-plus-capabilities)).
- MFA is mandatory for Owner and Branch Manager; sensitive capabilities require step-up. PIN cannot satisfy step-up ([ID-02, ID-13, ID-21](after_four_identity_decision_register.md#owner-decisions-confirmed)).
- Client-supplied User, role, Organization, Branch scope, capability, status, and total are never authority ([ADR-0009](adr/0009-api-conventions-versioning.md)).
- Workforce Branch Assignment is work eligibility, not authorization. The confirmed Workforce policy requires effective dating and reasoned, scoped assignment authority ([Owner baseline P2B-WF-OD-02](after_four_owner_decision_baseline.md#wave-2-consolidated-owner-decisions)).

### 5.2 Commercial and operations decisions

- Dine-in and takeaway are in scope; initial Order creation requires an explicit channel and does not require a Table Session (`CORE-OD-06` in the [Owner baseline](after_four_owner_decision_baseline.md)).
- Every sellable selection uses a persisted Variant; Modifier cardinality is approved; price-changing Modifiers are excluded from the initial Core Sale slice ([Catalog decisions](after_four_owner_decision_baseline.md#5-catalogpricing-mvp)).
- Commercial V1 applies to the first Branch and has approved exact pricing inputs for costing, but final Price publication and implementation are not authorized (`CORE-OD-18`).
- Price Versions are immutable/effective-dated; changed Draft pricing requires review; sold prices lock at confirmation (`ODB-CAT-08` through `ODB-CAT-10`).
- Initial implementation payment is exact-balance cash only. Existing bank-transfer code does not authorize initial POS exposure (`CORE-OD-07`).
- Full verified Payment is required before Preparation Dispatch. Existing late-success/mismatch containment remains authoritative ([ADR-0012](adr/0012-ordering-payment-preparation-ddd-boundaries.md)).
- Preparation progress is item-level, not quantity-level; partial Ticket completion/handover are prohibited; handover is explicit and separate (`CORE-OD-08A` through `10C`).
- Partial/split tender is deferred. Refund policy principles exist, but no executable refund policy is approved (`P1A-OD-01` through `03`).
- Cash Session Branch capability governance, Operating Day timezone/cutoff, immutable close/correction principle, and handover evidence are confirmed; exact capability assignment and several correction/disposition rules remain unresolved (`ODB-CASH-12` through `15`, `CORE-OD-12` through `15B`).
- Initial reporting lineage is limited to authoritative Order, Payment, and pending Preparation Dispatch facts. Product sales, kitchen progress, Cash, Refund, and other facts remain excluded until implemented (`CORE-OD-16A`).

## 6. Gate A decisions recorded; remaining Gate B prerequisites

### 6.1 Required before Milestone 2A implementation

The Owner recorded all eleven Gate A decisions in [`POS-2A-GATE-A-OWNER-DECISION-001`](after_four_pos_milestone_2a_gate_a_owner_decision.md). Before implementation can be authorized, the binding conditions still require:

1. an exact Gate B manifest for capability activation, owning Application use cases, authorization mappings, and tests;
2. exact step-up action, assurance, freshness, binding, invalidation, recovery, and security-evidence parameters;
3. exact physical schema, interval, overlap, correction, termination, concurrency, migration, and rollback details;
4. exact Owner succession, recovery, emergency replacement, and Organization-lockout prevention behavior;
5. durable cross-context workflow state, idempotency, retry, recovery, applicable cancellation/compensation, and operator visibility;
6. an independently approved Audit producer contract before assignment/link mutation entry points may activate; and
7. a separate explicit Gate B bounded implementation authorization naming the permitted files, packages, contracts, migrations, tests, reviewers, exclusions, and rollback requirements.

### 6.2 Later milestone decisions; do not pull into 2A

- Tax treatment and display, monetary precision and rounding (`CORE-OD-03/04`).
- Modifier pricing/applicability details, Price publication authority, quote lifetime, and exact repricing protocol.
- `OPP-ARCH-13` integration-event version encoding, `OPP-ARCH-14` Payment Review Case aggregate status, `OPP-ARCH-15` Payment-target creation timing, and `OPP-ARCH-16` Ticket/Ticket Item boundary.
- Resume behavior; complete cancellation consequence matrix; completed-Order exceptions; closure guard implementation.
- Manual bank confirmation exposure prerequisites; refund execution; review-case resolution; reversals; partial/split tender.
- Cash capability assignment/delegation/separation of duties and post-close corrections (`CORE-OD-12/13`).
- Report-read capability/scope and retention/disposal/legal hold (`CORE-OD-16B/16F`).
- Table/floor/session operational rules and any future activation of chain-default/Branch override pricing.
- Production deployment, exact runtime configuration, FOA, and Production Authorization.

## 7. Milestone 2A technical-design direction

This section summarizes the readiness design. The exact interfaces, invariants, proposed file manifest, acceptance criteria, and consolidated approval request are in the [Milestone 2A Authorization Foundation Design](after_four_pos_milestone_2a_authorization_foundation_design.md).

### 7.1 Deep-module shape

Identity Authorization should remain one deep module with a small caller interface:

```text
authorize(trusted_session_context, operation_request) -> authorized_operation | denied
```

The interface includes its invariants and failure modes:

- trusted session context is issued only by the existing verified Session path;
- the request names one code-owned capability and typed target scope; raw actor/role/capability authority is never accepted;
- Identity resolves current Role Assignment itself;
- for non-Owner Branch operations, Identity calls a narrow Workforce Application eligibility interface;
- Identity calls Organization Application scope interfaces where ancestry must be proved;
- every missing, expired, revoked, inconsistent, unavailable, or mismatched fact fails closed;
- step-up is evaluated inside the authorization module, not in Pundit/controllers;
- success returns immutable operation evidence for one downstream call; denial returns a safe reason classification not suitable for resource enumeration;
- Pundit is a Presentation adapter over this interface, not a second policy engine.

This interface provides leverage by hiding role mapping, effective dating, linkage, dual-assignment checks, scope ancestry, and assurance evaluation. Callers and tests use the same seam. Do not expose a shallow collection of `owner?`, `manager?`, `assigned?`, and `mfa?` helpers that would force controllers and use cases to reconstruct policy.

### 7.2 Context responsibilities

| Context/layer | Responsibility |
|---|---|
| Identity Domain/Application | Code-owned capability values; Role Assignment meaning; effective-role resolution; authorization orchestration; step-up policy evaluation; immutable authorized-operation result. |
| Identity Infrastructure | User–Employee linkage and Role Assignment persistence adapters after approved schema; assurance/session evidence adapters. |
| Workforce Domain/Application | Employee Branch Assignment invariants and one eligibility query returning typed, current evidence without Identity concepts. |
| Workforce Infrastructure | Assignment persistence/queries after approved schema. |
| Organization Application | Typed Organization/Brand/Branch ancestry evidence; no roles or authorization decisions. |
| Organization Infrastructure | Persisted ancestry projection. |
| Composition | Supply concrete adapters to Identity Authorization; no generic service locator. |
| Presentation | Authenticate session, construct typed operation request from route/resource context, call Pundit adapter, map safe denial/not-found behavior. |
| Audit integration point | Record required event family/attempt identity only after separate producer approval; no Milestone 2A implementation by implication. |

### 7.3 Security invariants

1. A User may authorize as Owner without Employee linkage only under approved, server-resolved Owner evidence.
2. A non-Owner Branch operation requires an active User, effective Role Assignment, linked active Employee, effective Employee Branch Assignment, matching Organization/Branch ancestry, required capability, and required assurance.
3. Role and Employee Branch Assignment are independent facts; neither substitutes for the other.
4. A Branch target selected by the frontend is untrusted input until server scope resolution succeeds.
5. Assignment and capability changes are evaluated at server time; stale Session claims do not remain authority.
6. Unknown resource and out-of-scope resource handling follows ADR-0009 non-disclosure; collections are scoped before projection.
7. Owner/Branch Manager MFA and sensitive step-up cannot be silently waived because implementation is absent.
8. PIN knowledge is never Branch authority and never satisfies step-up.
9. Authorization evidence is immutable, bounded to one operation/scope, and not reusable as a general bearer credential.
10. No new audit success is claimed until the independent Audit contract is authorized and known committed under its approved semantics.

## 8. File-level implementation plan for later approval

The exact manifest must be frozen in the dedicated Milestone 2A design. Expected affected areas are:

| Area | Expected files/modules | Change type |
|---|---|---|
| Identity contracts | `backend/app/contexts/identity/application/contracts/` | Add operation request/result, scope and evidence values; extend the code-owned capability catalog only with approved values. |
| Identity authorization | `backend/app/contexts/identity/application/use_cases/authorize.rb` and focused collaborators under `application/` | Deepen existing authorization orchestration; preserve self-session behavior and fail-closed contracts. |
| Identity ports | `backend/app/contexts/identity/application/ports/` | Add only demonstrated seams for Role facts, Workforce eligibility, Organization scope, and assurance evidence. |
| Identity persistence | `backend/app/contexts/identity/infrastructure/persistence/` and adapters | Approved User–Employee link and Role Assignment implementation. |
| Workforce Domain/Application | `backend/app/contexts/workforce/domain/`, `application/contracts/`, `application/queries/`, `application/ports/` | Employee Branch Assignment and typed eligibility interface. |
| Workforce persistence | `backend/app/contexts/workforce/infrastructure/persistence/` | Approved Assignment record/repository/mapper. |
| Organization Application | Existing ancestry module, plus Branch ancestry query only if required | Reuse current seam; no authorization logic. |
| Composition | `backend/app/composition/identity_composition.rb` and narrowly needed composition modules | Wire adapters; do not instantiate Infrastructure in controllers. |
| Policies | `backend/app/policies/` | Later thin operation-specific adapters; no role-name checks. No route/controller work in a pure 2A foundation slice unless explicitly included. |
| Packages | Context `package.yml` files | Only dependency additions proven necessary and separately approved. Preserve strict checks. |
| Database | New migrations and `structure.sql` | Required for linkage/Role/Branch Assignment only after explicit schema/migration authorization. |
| Tests | `backend/spec/domains/{identity,workforce,organization}/`, `spec/architecture/`, later `spec/policies/` and request specs | Unit, contract, persistence, temporal, isolation, non-disclosure, assurance, and dependency coverage. |
| Audit | No production file in initial plan | Document dependency; do not edit `AuditEvent`, OPP audit adapters, or proposed Audit workstream files. |

No source file is authorized by this plan. A final approval manifest must name exact paths and explicitly resolve whether Presentation is part of 2A or begins in 2B.

## 9. Recommended implementation sequence

1. **Approve and implement a bounded 2A core:** server-resolved Owner path, optional User–Employee link, effective Role Assignment, effective Employee Branch Assignment eligibility, operation-specific capability catalog, trusted authorization result, and tests. Prefer a slice with no mutation endpoints and no new Audit producer.
2. **2B read-only vertical slice:** authenticated/authorized active first-Branch menu shell plus Order/Payment/Dispatch reads that already have reliable facts. Do not expose demo prices as authority.
3. **2C commercial design and approval:** close tax/rounding prerequisites or explicitly scope them out under qualified approval; implement Variant-based items, immutable Price Versions, authoritative quote/reprice, server totals, and sold snapshots.
4. **2D production Order slice:** create/mutate/confirm Draft with server pricing, concurrency and idempotency; reuse existing confirm/hold/expire paths. Defer cancellation/closure pieces whose consequences remain unresolved.
5. **2E exact-balance cash slice:** expose existing cash settlement only, then add Payment reads/review visibility. Keep bank exposure, refunds, split tender, and review resolution gated.
6. **2F Dispatch visibility and delivery:** publish/consume existing intent only under approved event contract; design/approve Ticket aggregate before kitchen execution.
7. **2G frontend integration by completed vertical slice:** session UI, read menu, authoritative cart/order, cash settlement, Dispatch visibility. Remove demo fixtures from production paths only as replacements become real.
8. **2H Cash design/implementation:** after capability/separation-of-duty decisions and Audit integration authorization.
9. **2I minimal Branch/Table operations:** first-Branch settings and only operationally confirmed table behavior; do not introduce mandatory Table Session.
10. **2J reporting:** begin with approved Order/Payment/pending-Dispatch lineage, expanding only after source facts and read authorization exist.
11. **2K production readiness:** execute the complete security, integrity, isolation, performance, recovery, deployment, frontend, and architecture evidence matrix; obtain separate FOA/Production Authorization.

## 10. Test and verification plan

### Milestone 2A executable evidence

- Identity Application tests for every approved capability/role/scope/assurance combination and every fail-closed input.
- Owner-without-Employee success within Organization scope; non-Owner-without-Employee denial.
- Effective-time boundaries for Role and Employee Branch Assignments, including exact start/end instants, revocation, and concurrent change.
- Organization mismatch, Branch mismatch, stale/missing linkage, unavailable Workforce/Organization adapters, and malformed typed evidence.
- Step-up freshness/session binding/invalidation after the implementation is approved; no placeholder success.
- Persistence constraints, optimistic concurrency, Organization/Branch foreign keys, uniqueness/overlap rules, and transaction rollback.
- Architecture tests proving Identity Application does not access Workforce/Organization Infrastructure and Workforce does not import Identity.
- Pundit adapter tests proving delegation to Identity Application and default denial.
- Request tests only when Presentation is authorized: authentication, CSRF for state change, non-disclosure, safe error envelope, and no client authority.
- Packwerk validate/check, Zeitwerk eager load, full RSpec, RuboCop, Brakeman, and dependency audit as applicable.

### Later milestone evidence

- Domain/Application/Infrastructure/request/concurrency/idempotency/rollback coverage per context.
- API contract tests for ADR-0009 envelopes, cursor pagination, ETag/`If-Match`, and `Idempotency-Key`.
- Frontend typecheck, lint, production build, integration tests, and Playwright against real backend workflows.
- Explicit distinction between commands executed now, historical artifacts, and commands not executed.
- Audit producer/transaction evidence only after the separate Audit workstream authorizes the exact producer.

No application, database, Packwerk, security, or frontend command was executed for this documentation-only readiness report.

## 11. Risks and blockers

| Risk/blocker | Severity | Current disposition |
|---|---:|---|
| Identity Milestone 2B explicitly unauthorized | Blocking | Submit one consolidated 2A design and implementation authorization request. |
| Exact POS capability/step-up matrix unresolved | Blocking | Owner/security decision required before policy code. |
| User–Employee, Role Assignment, Employee Branch Assignment physical design absent | Blocking | Dedicated reviewed schema/contract design and migration approval required. |
| Parallel Audit workstream uncommitted and not implementation-ready | Blocking for new producers | Preserve documents; leave explicit seam; coordinate later producer approval. |
| Caller-supplied Order total | Critical for POS checkout | Do not expose production Draft creation until 2C server pricing/items exist. |
| Tax/rounding unresolved | Blocking for authoritative commercial implementation unless explicitly scoped/resolved | Obtain qualified input/Owner decision. |
| Existing bank-transfer code exceeds initial approved commercial slice | High | Do not expose it in the first operational slice. |
| Ticket aggregate/event version unresolved | Blocking for kitchen execution | Separate 2F design/ADR decision. |
| Cash/report authorization deferred | Blocking for 2H/2J | Do not infer from role names. |
| Untracked Owner/parallel files | High process risk | Never clean/reset/stash; re-check before every milestone. |
| Development branch currently checked out | High for implementation | Create an Owner-approved feature branch before authorized source work; target `development`, never `main`. |

## 12. Current authorization status

| Activity | Status |
|---|---|
| Repository inspection and documentation preparation | Authorized by the master execution mandate and existing documentation-preparation direction |
| Milestone dependency analysis | Complete in this report |
| Milestone 2A technical design preparation | Complete; Gate A approved under `POS-2A-GATE-A-OWNER-DECISION-001` |
| Source/runtime/controller/policy/package changes | Not authorized |
| Security/authorization model changes | Design direction approved with conditions; implementation not authorized |
| Schema/migration/database changes | Database enforcement approved as a design requirement; exact schema and implementation not authorized |
| New Audit producer/integration | Not authorized; independent workstream gates apply |
| Commit/push/merge | Not authorized |
| Milestones 2B–2K implementation | Not authorized as a blanket scope; each bounded milestone requires satisfied dependencies and explicit gates |
| Production use/FOA | Not authorized |

**Readiness decision:** Gate A is approved. Do not prepare or begin Gate B automatically. A separate explicit Owner request is required before preparing the bounded implementation-authorization package. No source implementation may begin unless that later package is explicitly approved.
