# AFTER FOUR — Foundation Decisions and Milestone Plan

**Status:** Foundation decision register; Milestone 1 implemented  
**Date:** 2026-11-14  
**Scope:** Decisions and implementation mapping for Rails Milestones 1–2

## 1. Decision register

| ADR | Decision | Status | Implementation effect |
|---|---|---|---|
| [ADR-0001](adr/0001-rails-modular-monolith.md) | Rails API modular monolith with one PostgreSQL database | Accepted | Establishes application shape and module boundaries. |
| [ADR-0002](adr/0002-ruby-rails-version-baseline.md) | Ruby 3.4.13 / Rails 8.1.4.1 baseline | Accepted | Ruby 3.4.13 is the current security-patched runtime; the initial Ruby 3.4.12 Milestone 1 compatibility evidence remains historical evidence. |
| [ADR-0003](adr/0003-postgresql-version-baseline.md) | PostgreSQL 18 | Accepted | All environments and concurrency tests use PostgreSQL 18.x. |
| [ADR-0004](adr/0004-uuid-primary-keys.md) | Native UUID keys | Accepted | Configure UUID defaults before the first application migration. |
| [ADR-0005](adr/0005-backend-repository-structure.md) | Rails under `backend/` | Accepted | Preserves the independently buildable `frontend/`. |
| [ADR-0006](adr/0006-authentication-session-topology.md) | Same-site, cookie-backed, server-side sessions | Proposed | Twenty-eight Owner policies plus six scoped Argon2 validation/admission directions are confirmed; production parameters, implementation, security, legal/privacy, and deployment evidence still block implementation/acceptance. |
| [ADR-0007](adr/0007-background-jobs-and-outbox.md) | Active Job, Solid Queue, transactional outbox | Accepted | Add a worker only with the first durable asynchronous use case. |
| [ADR-0008](adr/0008-deployment-environments.md) | Separated environments and repeatable promotion | Proposed | Local/test foundation may proceed; staging/production require operations approval. |
| [ADR-0009](adr/0009-api-conventions-versioning.md) | REST/JSON under `/api/v1` | Accepted | Request/contract tests define the frontend seam. |
| [ADR-0010](adr/0010-database-migrations-and-schema.md) | Rails migrations plus PostgreSQL `structure.sql` | Accepted | Preserve PostgreSQL-specific constraints and use expand/migrate/contract releases. |
| [ADR-0011](adr/0011-project-wide-layered-ddd.md) | Project-wide Layered DDD | Accepted (`OWNER_CONFIRMED`) | New and modified source follows four logical layers within authorized scope; A1 is the first implemented example and existing contexts are not implicitly migrated. |
| [ADR-0012](adr/0012-ordering-payment-preparation-ddd-boundaries.md) | Ordering, Payment, and Preparation DDD boundaries | Accepted (`OWNER_CONFIRMED_TECHNICAL_ARCHITECTURE`) | Records `OPP-ARCH-06`–`OPP-ARCH-12`; establishes target context ownership and Payment Application coordination while preserving compatibility facades, context-local values, existing atomic behavior, and the no-schema-change boundary. It grants no implementation authorization. |

The supporting [runtime-version research](../research/after_four_runtime_version_baseline.md) is primary-source evidence, not an additional decision. The accepted [Payment model](after_four_payment_model.md) resolves the old aggregate-status ambiguity for MVP.

## 2. Required approvals and remaining blockers

### Before Milestone 1 scaffolding

Resolved on 2026-11-14: official releases were rechecked, the exact dependency set was executed on Ruby 3.4.12 and Ruby 4.0.9, and ADR-0002 selected the Ruby 3.4 / Rails 8.1 baseline. Ruby was subsequently patched to 3.4.13 after the 2026-11-18 Ruby security advisory, as permitted by ADR-0002's patch-maintenance rule. The selected patches remain identical in development and CI and must remain identical in staging and production. No preview runtime is permitted.

### Before production authentication

The Owner confirmed the twenty-eight policies in the [Identity Decision Register](after_four_identity_decision_register.md). ID-20 selects Owner-led technical/security review, IDs 21–28 close password/PIN policy choices, and IDs 29–34 approve only the P64-4 production-parity candidate plus scoped admission, resource-method, parallelism-validation, overload, and revalidation direction. They supply no production-profile approval, numeric limit, implemented-control evidence, residual-risk acceptance, or legal assurance. Before production authentication, the remaining gates are:

- exact hosting, DNS, managed-edge/proxy, private-connectivity, health-monitoring, and operations design consistent with the confirmed one-origin policy;
- production password/PIN dependency and profiles, numeric resource/admission and PIN retry limits, production-parity evidence, and device controls;
- MFA factor/enrollment/recovery, step-up behavior, and explicit ordinary/sensitive capability enumeration;
- Owner-recovery procedure/evidence, delegation race handling, authentication-lock release policy, and Owner-unavailable procedure;
- session/cookie/CSRF enforcement, rate limiting, trusted proxies, session monitoring/notification, audit integrity, legal/privacy retention decisions, and offboarding evidence.

All evidence requirements and current `OPEN`/`BLOCKED` states are in the [Identity Security Review Checklist](after_four_identity_security_review_checklist.md). Owner policy approval does not complete the security review.

### Before staging/production deployment

The Owner/operations reviewer must approve ADR-0008 choices for hosting, TLS/routing, secrets storage, release/migration ownership, worker topology, monitoring and alerts, backup retention, restore testing, RTO/RPO, maintenance windows, and incident escalation.

### Before Package C implementation

The canonical [Package C0 decisions](after_four_owner_decision_baseline.md#package-c0-lifecycle-authority-and-prerequisite-decisions) confirm lifecycle authority, Brand/capability-scoped delegation, self-approval prohibitions, effective/expiry behavior, reason and step-up requirements, cross-Brand default denial, trusted AuthorizationContext, atomic append-only audit, runtime/migration role separation, and a required operation-specific database boundary. `C0-CAT-08` explicitly keeps Default Variant switching out of Package C. These decisions do not authorize implementation.

`C0-R05`, `C0-R08`, and `C0-R11` remain `DEFERRED`. Before Package C may be implemented, separately authorized prerequisite work must provide trusted Identity/delegation integration, a Brand-scoped Catalog AuditEvent design, non-superuser role/privilege evidence, and an approved operation-specific database boundary. ADR-0006 remains Proposed, Identity Milestone 2B remains unauthorized, and CAT-TRR-005 through CAT-TRR-008 retain their current statuses unless separately reviewed and explicitly changed.

### Outside Milestones 1–2

Production electronic payment still requires a provider, signed-event/idempotency/reconciliation contract, credential owner, and operator recovery process. Production cash requires drawer/register topology. Split/partial payment, refunds/cancellations, offline behavior, and tax/accounting obligations remain separately blocked and must not be inferred by foundation code.

## 3. Security baseline

### Production requirements

- Store only adaptive password hashes if local credentials are approved; never log or reversibly encrypt credentials.
- Use opaque revocable sessions, secure cookie attributes, rotation, idle/absolute expiry, logout revocation, and all-session revocation on User deactivation or compromise.
- Require CSRF protection on unsafe cookie-authenticated requests. Do not enable broad credentialed CORS.
- Rate-limit login, recovery, session-sensitive commands, reconciliation, and provider webhooks with trusted-proxy configuration.
- Authorize server-side using effective User, Role Assignment, Branch Assignment, capability, and resource scope. Client routes, hidden controls, IDs, and Branch/role headers are never authority.
- Preserve historical User/Employee identity and deactivate instead of delete. Deactivation prevents new authentication and revokes active sessions without rewriting audit/business history.
- Audit login/session lifecycle, role/assignment changes, deactivation, sensitive reads, payment/reconciliation, and other privileged commands with actor, effective scope, request ID, safe resource IDs, result, reason, and time.
- Keep Rails secrets, database credentials, session secrets, and provider keys outside source control; separate environments and rotate through an approved secrets facility.
- Redact cookies, authorization/CSRF headers, credentials, provider payloads/signatures, payment details, personal contact data, and stack traces from client errors and ordinary logs.

### Development and test conveniences

Local seeded identities, a test authentication adapter, fake payment adapters, and synchronous job execution are allowed only in non-production configurations. Production must fail at boot if a test identity/payment adapter is selected. Test data contains no copied production personal or payment information.

## 4. Milestone 1 — Rails application foundation

### Entry gate

ADR-0002 is accepted with revalidated patch versions. ADRs 0001, 0003, 0004, 0005, 0009, and 0010 remain Accepted. No Owner business decision is encoded.

### Exact implementation steps

1. Generate an API-only Rails application in `backend/` using the accepted Ruby/Rails pair and PostgreSQL; do not alter `frontend/`.
2. Pin Ruby, Rails, Bundler, and PostgreSQL major expectations in repository tooling, lockfile, setup documentation, and CI.
3. Configure UUID as the application-table primary-key default and PostgreSQL SQL schema dumps before the first migration.
4. Configure separate development and test databases through environment-provided credentials; commit only safe examples, never secrets.
5. Establish domain namespaces, thin `/api/v1` controller base, request context, canonical success/error serialization, request IDs, and structured redacted logging.
6. Use RSpec as the only supported backend test framework, with transactional database isolation, FactoryBot, Shoulda Matchers, and SimpleCov. Do not maintain a parallel Minitest suite.
7. Add `/health/live` and `/health/ready`; liveness proves the process responds, while readiness checks PostgreSQL without exposing internals.
8. Define documented setup, database create/migrate/reset, test, lint/security, schema-verification, and server commands.
9. Add CI that creates PostgreSQL 18, applies all migrations from empty, detects schema drift, runs backend checks, and retains the existing frontend typecheck/lint/build checks.
10. Verify a clean checkout can boot, migrate, test, and report not-ready when PostgreSQL is unavailable.

### Acceptance criteria

- No runtime or dependency is unpinned or preview-grade.
- Clean database creation/migration and tests succeed against PostgreSQL 18.
- `/api/v1` errors follow the canonical envelope and include a request ID without secrets.
- Health endpoints distinguish live from ready and reveal no credentials or stack traces.
- `structure.sql` faithfully records reviewed PostgreSQL objects.
- Existing frontend checks remain unchanged and passing.

## 5. Milestone 2 — Identity, Branch scope, and authorization

### Entry gate

ADR-0006 remains **Proposed**. Entry into Identity implementation is governed by four separate gates:

1. **ADR Design Baseline Approval:** the Owner reviews an exact proposed scope for design completeness, exclusions, risks, test strategy, and evidence ownership. This approval does not change ADR-0006 or checklist status, prove any control, authorize implementation, or authorize production.
2. **Bounded Implementation Authorization:** a separate explicit Owner decision must identify the exact milestone and approved design baseline; allowed files and bounded contexts; migrations, dependencies, endpoints, and configuration in scope; required tests and environments; evidence owner and reviewer; and explicit exclusions and prohibited actions. This authorization does not imply Control Acceptance or ADR acceptance.
3. **Control Acceptance:** executed implementation and environment-specific evidence is evaluated against every applicable Identity Security Review Checklist requirement. Design documents and planned tests are not executed evidence. Findings require remediation or an explicitly authorized permissible residual-risk decision. Control Acceptance can support a later ADR-0006 status review only when the canonical acceptance conditions are satisfied.
4. **Final Operational Acceptance:** production deployment, operational readiness, and applicable legal/privacy approval remain separate and are not implied by any preceding gate.

Milestone 2B remains unauthorized until the Owner separately records the applicable ADR Design Baseline Approval and Bounded Implementation Authorization. Owner policy confirmation alone authorizes neither implementation nor production use.

### Exact implementation steps

1. Create the minimum UUID schema for Organization, Brand, Branch, User, Employee, Branch Assignment, Role, Role Assignment, and server Session, with restrictive FKs, effective intervals, deactivation fields, and required indexes/uniqueness.
2. Implement adaptive password hashing only if local passwords are approved. Keep credential handling behind the accepted authentication boundary.
3. Implement login, logout/current-session revocation, `GET /api/v1/me`, `GET /api/v1/sessions`, and explicit session revocation according to the canonical API and approved lifecycle.
4. Rotate session identifiers on authentication and relevant privilege changes; enforce expiry, secure cookie attributes, and CSRF for unsafe requests.
5. Build trusted request context from the session and database. Never accept User, Organization, role, or authoritative Branch scope from headers/body.
6. Implement small policy classes that evaluate capability plus effective Branch/Role Assignments. Keep authorization out of React and out of generic model callbacks.
7. Implement User deactivation as an audited command that blocks new login, revokes all active sessions, and preserves User/Employee/business history.
8. Add rate limiting and generic safe errors for login/recovery-sensitive paths; log safe authentication and scope events.
9. Add request, policy, database, and concurrency tests for effective assignments, temporary Branch access, expired assignments, cross-Branch non-disclosure, deactivation, revocation, CSRF, session rotation/expiry, and audit evidence.
10. Exercise the browser/client boundary with a minimal authenticated `/me` flow only after the server contract passes independently.

### Acceptance criteria

- An authenticated request derives one trusted User and effective Organization/Branch capabilities from server state.
- A Staff member can access an assigned Branch and cannot discover or mutate another Branch's resources.
- Assignment expiry and User deactivation take effect server-side without deleting history.
- Logout, explicit revocation, deactivation, and expiry invalidate sessions as specified.
- Unsafe cookie-authenticated requests fail without valid CSRF evidence.
- Login/recovery attempts are rate-limited and do not disclose whether an account exists beyond the approved response.
- Sensitive actions create redacted audit evidence with actor, scope, request, result, and time.

## 6. Exit state

Completing Milestones 1–2 establishes a production-oriented foundation, not a production launch. Product → Order → Payment → Preparation implementation starts only after the affected domain tables and commands are reviewed against the synchronized canonical documents. Real money movement and deployment remain gated by the approvals above.
