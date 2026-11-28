# AFTER FOUR POS 2A–2F Autonomous Delivery Evidence

**Prepared:** 2026-11-28 (Asia/Tokyo)
**Integration target:** `development`
**Isolated feature branch:** `feat/pos-2a-2f-delivery`
**Base commit:** `c05b7ed8994e0fd4c39645db43ba6b0c85bdb165`
**Decision authority:** Owner autonomous POS 2A–2F mission
**Acceptance boundary:** Internal implementation and verification evidence only; no deployment, production use, Operational Acceptance, or Owner Control Acceptance is claimed.

## 1. Executive result

The mission produced a PR-oriented, uncommitted change set in an isolated worktree. It preserves the shared `development` worktree and all concurrent Audit Foundation and Commercial work. The safely achievable result is:

| Roadmap phase | Status | Evidence-backed result |
|---|---|---|
| POS-2A — Authorization Foundation | `IN_PROGRESS` | B1 policy core and business-authorization orchestration are implemented and isolated. The proposed Workforce persistence extension has been excluded from this PR pending Owner decisions `POS-2A-B-OD-01` and `POS-2A-B-OD-05`. Production activation remains blocked by Role Assignment/User–Employee persistence, production MFA assurance, Audit prerequisites, and Owner policy decisions. |
| POS-2B — Read APIs | `IN_PROGRESS` | Brand-active Catalog, Orders list/detail, Payment status, and Preparation status Application queries and Infrastructure readers are implemented as source-only modules. No route/controller/composition activation exists because trusted production authorization is incomplete. |
| POS-2C — Order Commercial Foundation | `BLOCKED` | A Catalog-owned effective Variant price contract distinguishes `PRICE_UNAVAILABLE` from `COMMERCIAL_POLICY_UNRESOLVED` without fabricating prices. No production price adapter, Price schema, Order Item schema, sold-price snapshot, or commercial total calculation was created. Approved actual price data and unresolved commercial policies remain prerequisites. |
| POS-2D — Order APIs | `BLOCKED` | Existing Orders use cases were preserved. They were not exposed because current `CreateDraft` accepts a caller-supplied total and the trusted commercial quote/snapshot path is not complete. |
| POS-2E — Payment and Preparation APIs | `BLOCKED` | Existing exact-balance cash settlement and Preparation use cases were preserved. Read status seams are implemented, but mutation endpoints remain blocked by production authorization and commercial Order prerequisites. Bank transfer remains excluded. |
| POS-2F — POS Frontend | `BLOCKED` | No demo or fabricated integration was added. A production POS frontend cannot safely connect until authorized backend APIs and approved commercial data exist. |

## 2. POS-2A delivered implementation

### 2.1 B1 authorization policy core

- Closed `PosCapability` vocabulary with exactly 11 approved values.
- Closed `RoleCode` vocabulary and pure policy outcomes for `ALLOW_IN_POLICY`, `DENY`, and `NOT_IMPLEMENTED`.
- Branch ancestry Application contracts/query/reader in Organization and a source-only Identity adapter.
- Typed, immutable evidence contracts for Branch scope, Employee Branch scope, Role Assignment, User–Employee link, and Session MFA assurance.
- `AuthorizeBusinessOperation` fail-closed orchestration.
- Architecture checks preventing composition, route, controller, or production authorization activation.
- Cross-type regression protection for the existing self-session authorization path.

The protected existing Identity production sources remain byte-identical to their recorded pre-B1 values:

| Source | SHA-256 |
|---|---|
| `capability_identifier.rb` | `85e069e2d59bc95cc608bbbbe054e66f99f7d7705873f191a823aa13fbbbd343` |
| `authorization_request.rb` | `c8ca1dc891d9b11e6e501941111d3a48084f62fc1342cbf1b136af3902da86f8` |
| `authorize.rb` | `e6477ff0c7383a60b468cd9f07ed02ac3a12c93458b5cc60e85beb6c49815e5a` |

The current full-suite result supplies fresh evidence for B1 CA-15. Packwerk, architecture, focused Identity, rollback-rehearsal, hash, and isolation evidence exists for the other technical criteria. The durable CA-16 procedure and recorded result are in [POS-2A B1 R2 CA-16 Rollback Verification](pos_2a_b1_r2_rollback_verification.md). This document does not declare the 17 criteria Owner-accepted. Because the feature branch also contains later POS work, B1 CA-01 and CA-17 must continue to be evaluated using B1-specific attribution rather than the aggregate branch status.

### 2.2 Workforce extension exclusion

The 33 Workforce-related paths from the pre-remediation worktree were preserved in an independently hashed external recovery archive, verified through two restoration rehearsals, and then excluded from this PR. Existing Employee Foundation sources remain unchanged. No Employee Branch Assignment migration, persistence model, Application query, Identity Workforce adapter, schema change, or package dependency is present in the proposed PR.

`POS-2A-B-OD-01` and `POS-2A-B-OD-05` remain unresolved. No temporary-assignment duration or cross-context Organization-consistency policy is selected implicitly.

### 2.3 Remaining POS-2A blockers

| Blocker | Why it blocks activation | Recommended decision |
|---|---|---|
| Owner succession/recovery and lockout prevention (`POS-2A-B-OD-02`) | Role Assignment persistence can create or remove ultimate authority. | Approve an explicit break-glass/succession workflow with separation of duties and immutable evidence. |
| Exceptional User–Employee correction/relink (`POS-2A-B-OD-03`) | Relinking changes the human identity behind Workforce authority. | Prohibit ordinary relink; require an exceptional audited correction workflow that preserves prior linkage history. |
| Cross-context workflow owner/state (`POS-2A-B-OD-04`) | Assignment/link mutation cannot safely share a cross-context transaction. | Select an explicit durable orchestration owner with compensating/fail-closed states. |
| Production MFA policy (`POS-2A-B-OD-06`) | Branch Manager policy allows cannot become runtime authorization without trusted assurance. | Approve provider, factor strength, fallback, recovery, invalidation, and numeric limits before an adapter is built. |
| Action-level step-up (`POS-2A-B-OD-07`) | Sensitive operations need action-bound assurance and replay-resistant fingerprints. | Approve the action matrix and canonical request-fingerprint contract before mutation APIs. |
| Audit producer prerequisite | Assignment/link mutations require approved producer provenance and atomic evidence. | Integrate only the separately approved Audit Foundation contract; do not create a POS audit substitute. |

## 3. POS-2B source-only read capability

### 3.1 Brand-active Catalog

- Exact Brand and optional Category scope.
- Active Category, Product, and Variant filtering.
- Deterministic Category/Product/Variant order and bounded pagination/query count.
- Immutable Application DTOs with no Active Record leakage.
- `pricing_status: price_unavailable`; no amount or invented price appears in the result.
- Exact Brand isolation, invalid input rejection, malformed evidence handling, and narrow infrastructure-unavailability classification.

The name is deliberately limited to Brand-active Catalog data. It does not claim Branch assortment, Branch sellability, stock availability, effective price, or authorization to sell.

### 3.2 Orders list and detail

- Exact Branch-scoped list with status filter, pagination, deterministic order, and immutable views.
- Exact Branch-and-Order detail lookup returns not-found for cross-Branch requests.
- No Order mutation, total recalculation, or client authority was added.

### 3.3 Payment status

- Payments owns its status query and persistence reader.
- Canonical Aggregate amount, funding-status, attempt-activity, and optimistic-lock invariants are shared through the Payments Domain `PaymentStatusSnapshot`; the Aggregate delegates to that boundary.
- A Payments Infrastructure adapter resolves Branch/Order scope through the Orders Application query before Payment persistence is read.
- No cross-context Active Record join or shared transaction exists.
- Cross-Branch scope returns not-found and does not invoke the Payment reader.
- Financial evidence is checked for the same amount, funding state, settlement timestamp, currency, and lock-version consistency as before the extraction.

### 3.4 Preparation status

- Exact Branch-and-Order lookup from Preparation-owned persistence.
- Pending/dispatched timestamp consistency validation.
- Cross-Branch requests return not-found without disclosing foreign existence.

All POS-2B modules are source-only. They are not registered in composition roots, controllers, routes, jobs, callbacks, middleware, or Pundit policies.

## 4. POS-2C safe commercial seam

`Catalog::Application::Queries::ResolveEffectiveVariantPrice` defines a typed contract for:

- exact Branch and persisted Variant identity;
- immutable Price Version identity;
- nonnegative integer amount and three-letter currency, with positive values eligible for `found`;
- effective and resolution instants; and
- closed `found`, `not_found`, `price_unavailable`, `commercial_policy_unresolved`, `invalid`, `inconsistent`, and `unavailable` outcomes.

There is intentionally no production reader. The contract can represent missing approved price data without manufacturing a value. A zero amount returns `commercial_policy_unresolved` and no price DTO; it is neither accepted as a sellable free item nor rejected by an invented positive-price policy. The contract does not choose tax, service charge, rounding, zero/free item, Modifier pricing, Order calculation order, or sold-snapshot component policy.

## 5. Verification evidence

The authoritative final remediation database was PostgreSQL 18.7 in task-owned container `af-pos-remediation-20261128-r2-db` (ID `fbf15034d5723932100b0331da5c5be557e807f1202264884e76c3b828283ab6`), volume `af-pos-remediation-20261128-r2-pgdata`, bound only to `127.0.0.1:55434`. Rails and RSpec used process-local PostgreSQL 18.7 client resolution from `/opt/homebrew/opt/postgresql@18/bin`. After verification, only that container and volume were removed; port `55434` was released. Every pre-existing container and volume retained its observed identity and state. No existing database, container, or volume was reused or modified by the authoritative run.

| Check | Result |
|---|---|
| Focused Catalog/Payments remediation suite | 32 examples, 0 failures; seed `62228` |
| Focused B1/Identity/Organization/architecture suite | 91 examples, 0 failures; seed `53013` |
| Final focused Payments extraction suite | 19 examples, 0 failures; seed `11998` |
| Complete backend RSpec | 497 examples, 0 failures; seed `52628`; exit 0 |
| SimpleCov | 95.99% line (`4074/4244`); 76.31% branch (`699/916`) |
| RuboCop | 360 files, 0 offenses |
| Zeitwerk | Eager-load check passed |
| Packwerk validate | Passed |
| Packwerk check | 357 files; no offenses or stale violations |
| `git diff --check` | Passed |
| Brakeman 8.1.1 | 80 checks; 0 errors; 0 security warnings |
| CA-16 disposable rollback | 4 restored self-session examples and 436 complete-backend examples; 0 failures; non-B1 paths/hashes unchanged; task resources removed |

Brakeman emitted non-fatal Ruby 3.4 Ractor/native-extension loading and generated-forwardable parser diagnostics while still completing all 80 checks and reporting zero scanner errors/warnings. This is a tooling limitation, not evidence that an external security review occurred.

## 6. Safety and PR boundary

- No route, controller, production authorization composition, or frontend integration was added.
- No production Role Assignment, User–Employee link, Session MFA, or Audit producer adapter was added.
- No Audit Foundation or Commercial Workstream file was modified.
- No actual selling price, menu item, supplier fact, recipe, cost, margin, or physical-trial evidence was fabricated.
- No existing Orders, Payments, or Preparation business rule was moved into Presentation or duplicated.
- No staging, commit, push, merge, rebase, deployment, or production database action occurred.
- The shared `development` worktree and all pre-existing containers/volumes remained outside the task's write set.

The change set is technically PR-oriented but not ready for production activation. Review should preserve the source-only boundary until the blockers in §§2.3 and 4 are closed and a separate activation review demonstrates complete trusted authorization, Audit prerequisites, and commercial authority.
