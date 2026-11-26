# AFTER FOUR — POS Milestone 2A Authorization Foundation Technical Design

**Status:** Gate A design baseline approved; Gate B bounded implementation authorization not granted

**Date:** 2026-11-27

**Scope:** POS authentication-to-authorization integration across Identity, Workforce, and Organization

**Runtime changes authorized by this document:** None

## 1. Purpose and verdict

Milestone 2A must let a business adapter establish, without trusting client claims:

1. the authenticated User and Session;
2. the User's Organization;
3. the exact operation capability being requested;
4. the trusted Branch scope of that operation;
5. the effective Identity-owned Role Assignment;
6. for a non-Owner, the linked Workforce Employee and effective Workforce-owned Employee Branch Assignment; and
7. any required MFA or step-up assurance.

The existing Identity authentication/session module is preserved. Its `TrustedAuthorizationContext` remains the proof of authenticated User, Organization, and Session; it must not become a cached bag of roles, Branches, or capabilities. A new business-authorization module should evaluate current state for each protected operation through narrow Application interfaces.

The Project Owner approved this Gate A design baseline on 2026-11-27 in [`POS-2A-GATE-A-OWNER-DECISION-001`](after_four_pos_milestone_2a_gate_a_owner_decision.md). It is not approved for implementation. Security-model changes, schema/migrations, authorization policy, cross-context contracts, package dependency changes, and eventual audit integration remain subject to the recorded conditions and a separate Gate B bounded implementation authorization.

## 2. Governing decisions

This design applies the following decisions without reopening them:

- [ADR-0011](adr/0011-project-wide-layered-ddd.md): Presentation calls Application; Infrastructure implements inward-owned ports; Domain remains framework-independent.
- [ADR-0009](adr/0009-api-conventions-versioning.md): clients never supply trusted User, role, Organization, Branch scope, status, or totals.
- [Owner Decision Baseline](after_four_owner_decision_baseline.md#project-wide-architecture): Workforce owns Employee and Employee Branch Assignment; Identity owns User, Session, Role Assignment, trusted authorization context, and authorization resolution; Organization owns Organization, Brand, and Branch.
- Non-Owner Branch authorization requires an applicable capability, effective Role Assignment, and effective Employee Branch Assignment. Missing, stale, invalid, mismatched, or unavailable evidence fails closed.
- User and Employee are independent identities with an optional relationship. Owner operation does not require an Employee record. Membership is prohibited.
- [Identity decisions ID-02, ID-09, ID-10, and ID-13](after_four_identity_decision_register.md#owner-decisions-confirmed): active roles are Owner, Branch Manager, and Staff; assignment changes require Owner approval; Branch Manager capabilities are code-owned and Branch-scoped; MFA and step-up apply as confirmed.
- [Identity decisions ID-01 and ID-21 through ID-23](after_four_identity_decision_register.md#owner-decisions-confirmed): individual POS PINs are required, are limited to enrolled POS devices, and cannot replace a general Session, MFA, step-up, or authorization.

These decisions establish ownership and safety rules. They do not authorize the missing persistence, capability identifiers, assignment administration, MFA implementation, audit producers, endpoints, or runtime integration.

## 3. Context ownership and module seams

```text
Presentation / Pundit adapter
        |
        v
Identity Application: AuthorizeBusinessOperation
        |
        +--> Identity-owned RoleAssignmentReader port
        +--> Identity-owned UserEmployeeLinkReader port
        +--> Identity-owned BranchScope port
        |       |
        |       +-- Identity Infrastructure adapter
        |              -> Organization Application published query
        |
        +--> Identity-owned EmployeeBranchScope port
        |       |
        |       +-- Identity Infrastructure adapter
        |              -> Workforce Application published query
        |
        +--> Identity-owned SessionAssurance port
        |
        +--> code-owned POS Capability Policy
```

This is a deep business-authorization module: callers learn one operation interface while current role, employee linkage, Workforce eligibility, Branch ancestry, capability mapping, assurance, and fail-closed behavior remain internal.

### 3.1 Identity owns

- User authentication identity and Session trust;
- optional User-to-Employee authorization link;
- Role Assignment and its effective interval;
- exact capability identifiers and the fixed role-to-capability matrix;
- authorization evaluation and immutable allow evidence;
- session assurance and step-up evidence; and
- future assignment/authorization audit ports, after separate audit authorization.

Identity does not own Employee, Employee Branch Assignment, Branch, or business-resource state.

### 3.2 Workforce owns

- Employee identity and Organization ownership;
- Employee Branch Assignment history, type, effective interval, and reason;
- the query that answers whether a specific Employee has effective work eligibility for a specific Organization/Branch at an authoritative time; and
- future assignment mutation commands after their authority and audit dependencies are approved.

Workforce does not own Role Assignment, capability mapping, User authentication, or the final authorization decision.

### 3.3 Organization owns

- Organization, Brand, and Branch identity and ancestry; and
- a published query resolving a Branch to its authoritative Brand and Organization without exposing Active Record.

Organization does not authorize the actor.

### 3.4 Business contexts own

Orders, Payments, Preparation, Catalog, and later contexts own resource existence, resource Branch ownership, and their business approval rules. Identity saying that an actor may perform a capability in Branch X does not prove that Order Y belongs to Branch X or that its Domain transition is valid.

## 4. Proposed business-authorization interface

### 4.1 Request

`AuthorizeBusinessOperation` accepts:

- the existing trusted Identity context issued from a verified Session;
- one code-owned `CapabilityIdentifier` constant;
- an untrusted requested Branch identifier to be resolved through Organization;
- an optional trusted resource-scope fact produced by the owning Application module after controlled lookup;
- server-controlled request/correlation evidence; and
- authoritative decision time supplied behind an Application seam.

It rejects free-form capability strings and client-supplied actor, Organization, role, Employee, assignment, assurance, or authority claims.

### 4.2 Result

An allow result is an immutable, non-client-constructible `BusinessAuthorization` containing only:

- User/actor reference;
- Session reference;
- Organization reference;
- trusted Branch reference;
- exact capability identifier;
- authority kind (`owner` or `assigned_employee`);
- safe Role Assignment evidence reference;
- safe User–Employee link and Employee Branch Assignment evidence references when applicable;
- evaluated time;
- assurance evidence reference when applicable; and
- correlation reference.

It contains no Active Record objects, raw cookie, PIN, password, MFA response, unrestricted role list, or mutable permissions cache.

A denial returns a safe semantic category for internal policy handling. HTTP responses use the canonical non-disclosing error contract; they do not reveal whether a foreign Branch, resource, link, Role Assignment, or Workforce Assignment exists.

### 4.3 Evaluation algorithm

For every business operation:

1. require a genuine `TrustedAuthorizationContext`;
2. resolve the requested Branch through the Organization Application contract;
3. require the resolved Organization to equal the trusted Session Organization;
4. load current effective Identity Role Assignments for the User and scope;
5. resolve the exact capability through the code-owned matrix;
6. if the effective role is Owner, allow Organization-wide scope without an Employee link, subject to capability and assurance;
7. otherwise require one effective User–Employee link in the same Organization;
8. ask Workforce whether the linked Employee has an effective assignment to the exact Branch at the decision time;
9. fail closed on absent, expired, inconsistent, unavailable, or mismatched evidence;
10. enforce the role's MFA requirement and the capability's step-up requirement;
11. issue one operation-scoped allow result; and
12. require the owning business Application module to match the loaded resource's Branch to that result and enforce its Domain rules.

No positive authorization is stored in the browser or reused as a later request's authority.

## 5. Proposed capability model

Capability identifiers are exact, code-owned constants. Prefix checks, wildcards, client strings, and generic `is_manager?` decisions are prohibited.

### 5.1 Initial POS capability candidates

| Candidate identifier | Purpose | Proposed minimum role | Proposed assurance |
|---|---|---|---|
| `pos.catalog.menu.read` | Read the active Branch menu | Staff | Ordinary authenticated POS Session |
| `pos.orders.read` | Read/search Branch Orders | Staff | Ordinary authenticated POS Session |
| `pos.orders.create` | Create a priced Branch Draft after Milestone 2C | Staff | Ordinary authenticated POS Session |
| `pos.orders.confirm` | Confirm an eligible Draft | Staff | Ordinary authenticated POS Session |
| `pos.orders.hold` | Hold a confirmed unpaid Order | Staff | Ordinary authenticated POS Session |
| `pos.payments.read` | Read Payment status/history | Staff | Ordinary authenticated POS Session |
| `pos.payments.cash.confirm` | Record exact-balance cash settlement | Staff | Ordinary authenticated POS Session |
| `pos.payments.review.read` | Read Branch Payment Review Cases | Branch Manager | MFA-authenticated Branch Manager Session |
| `pos.preparation.dispatch.read` | Read Branch Dispatch queue/status | Staff | Ordinary authenticated POS Session |
| `pos.preparation.dispatch.recover` | Request a missing eligible Dispatch | Branch Manager | MFA-authenticated Branch Manager Session |
| `pos.preparation.dispatch.retry` | Retry pending Dispatch delivery | Branch Manager | MFA-authenticated Branch Manager Session |

Owner receives the approved capability set at Organization scope through an effective Owner Role Assignment, without needing an Employee link. Branch Manager receives the Staff set plus the three manager candidates above, only for Branches supported by both assignments. Staff receives only the Staff rows above and only for supported Branches.

This matrix is a recommendation, not an approved policy. Manual bank-transfer confirmation is also excluded from the initial slice under `CORE-OD-07`, despite the existing internal command; a future `pos.payments.bank_transfer.confirm` capability requires its separate Branch-scoped capability and evidence prerequisites. Cancellation, review resolution, Refund, cash-session, assignment administration, Catalog administration, audit read/export, and other high-impact capabilities remain excluded until their domain policies and assurance requirements are approved.

### 5.2 Sensitive capability rule

The capability catalog records an assurance requirement; role names do not dynamically decide sensitivity. A sensitive operation requires both the capability and current step-up evidence. If exact MFA factor, freshness, Session binding, or action binding is unresolved, the operation is unavailable rather than downgraded.

The initial candidates above deliberately avoid declaring action-level step-up where Owner policy has not selected it. Branch Manager MFA remains mandatory. Future sensitive operations such as assignment changes, review resolution, refunds, cash close/discrepancy approval, post-preparation cancellation, or Catalog archive/restore require their separately approved step-up contract.

## 6. Proposed persistence model

All records preserve history and use UUID identity, timestamps with time zone, optimistic locking where mutated, restrictive foreign keys where authorized, and effective intervals. Exact migrations require separate approval.

### 6.1 Identity-owned User–Employee link

Recommended shape: a dedicated append-preserving `user_employee_links` relation rather than a nullable mutable `users.employee_id` column.

Minimum facts:

- link ID;
- Organization ID;
- User ID;
- Workforce Employee ID as an opaque reference;
- effective start and optional end;
- reason and approval evidence reference;
- created/ended actor references;
- lock version and timestamps.

At most one effective Employee link per User and at most one effective User link per Employee within an Organization. Owner Users may have no link. The dedicated record preserves linkage history and avoids making User or Employee existence depend on the other.

Whether relinking to a different preserved Employee is ever permitted is unresolved and must be explicitly decided; the safe default is no ordinary relink.

### 6.2 Identity-owned Role Assignment

Minimum facts:

- assignment ID;
- Organization ID;
- User ID;
- role code (`owner`, `branch_manager`, or `staff`);
- optional Branch ID (`NULL` only for Organization-wide Owner scope);
- effective start and optional end;
- reason and Owner approval evidence reference;
- created/ended actor references;
- lock version and timestamps.

The recommended invariant is one effective Owner assignment per Organization and no Branch-scoped Owner assignment. Non-Owner Role Assignments are Branch-scoped. A Role Assignment never creates Workforce eligibility.

The one-Owner cardinality, Owner succession/recovery behavior, and whether multiple concurrent non-Owner role assignments are permitted require explicit Owner confirmation before schema design is frozen.

### 6.3 Workforce-owned Employee Branch Assignment

Minimum facts:

- assignment ID;
- Organization ID;
- Employee ID;
- Branch ID;
- assignment kind (`primary` or `temporary`);
- effective start and optional end;
- reason and Owner approval evidence reference;
- created/ended actor references;
- lock version and timestamps.

Recommended multi-Branch rule: at most one effective primary assignment per Employee, with overlapping temporary assignments permitted when explicitly approved. Any effective primary or temporary assignment satisfies work eligibility for its exact Branch; neither supplies a Role or capability.

The overlap rule, temporary duration, correction behavior, and exact multi-Branch semantics are unresolved Owner policy and block final physical constraints.

## 7. Published cross-context contracts

### 7.1 Organization Application contract

`ResolveBranchAncestry` takes an Organization-owned Branch reference and returns one of:

- resolved immutable Branch/Brand/Organization ancestry;
- not found;
- inconsistent; or
- unavailable with a safe reference.

It follows the existing `ResolveBrandAncestry` contract style. Identity Infrastructure maps this contract into its own `BranchScope` port values. Identity never accesses Organization records.

### 7.2 Workforce Application contract

`ResolveEffectiveEmployeeBranchAccess` takes typed Workforce-owned Employee, Organization, and Branch references plus authoritative evaluation time. It returns one of:

- effective, with safe assignment evidence references and effective interval;
- not effective;
- inconsistent; or
- unavailable with a safe reference.

It does not accept User, role, capability, or Session values and does not authorize the operation. Identity Infrastructure maps it into Identity's required `EmployeeBranchScope` port. Identity never accesses Workforce records.

### 7.3 Business-context authorization port

Where a business Application use case needs authorization inside its orchestration, that context owns a narrow consumer port such as `OperationAuthorization`. A composition adapter invokes Identity Application and maps only the allow evidence needed by the use case. The context does not import Identity Infrastructure or reconstruct Identity policy.

For simple HTTP reads, Pundit may remain a thin Presentation adapter invoking the same Identity Application interface. Existing-resource operations must still verify the loaded resource's trusted Branch within the owning Application module.

## 8. MFA, step-up, PIN, and Session design dependency

Current server Sessions prove authenticated User, Organization, and Session but do not carry reviewed MFA, step-up, enrolled-device, or POS-lock evidence. Milestone 2A therefore needs an approved Session-assurance extension before Branch Manager or production POS authorization is complete.

The required interface must be able to answer:

- authentication methods used for the current Session;
- whether mandatory Branch Manager MFA is satisfied;
- last reviewed MFA verification time;
- whether an action-bound step-up exists for the exact capability and request fingerprint;
- whether the POS device is enrolled when PIN proof is used;
- whether the two-minute POS inactivity lock requires reauthentication; and
- whether relevant credential, factor, assignment, or Session changes invalidate the evidence.

Exact factor, freshness, challenge, device enrollment, rate limits, PIN verifier, and invalidation matrices remain security decisions. Until approved and implemented, the authorization module must deny operations requiring that evidence.

## 9. Audit integration boundary

The Organization-Level Audit Foundation is independent and currently grants no implementation or producer authority. Milestone 2A must not modify its documents, contracts, schema, roles, functions, or failure semantics and must not register a POS producer.

Future Identity and Workforce assignment mutation modules will each own a narrow audit port describing their own required evidence. Composition may later adapt those ports to an approved Audit Application append interface. The business mutation and required append must follow the approved failure/transaction contract. Until the first-producer decisions and producer activation are approved:

- no production User–Employee link mutation is enabled;
- no production Role Assignment mutation is enabled;
- no production Employee Branch Assignment mutation is enabled;
- no new authorization/audit event is emitted; and
- audit absence is not silently treated as success.

Read-only evaluation can be designed independently, but Milestone 2A is not operationally complete until approved assignment provisioning and security evidence exist.

## 10. Error and security behavior

- Missing or malformed Session: `authentication_required`.
- Unsupported capability, missing assignment, wrong Organization/Branch, resource mismatch, expired evidence, insufficient assurance, or foreign resource: non-disclosing authorization denial.
- Required Organization/Workforce evidence unavailable or inconsistent: fail closed with a safe dependency-unavailable/internal classification; never fall back to role alone.
- Assignment and assurance data are evaluated at authoritative server time.
- Actor and scope identifiers in command bodies/headers are ignored or rejected as untrusted input.
- Logs and client errors contain no cookie, PIN, password, MFA material, raw assignment record, or unrestricted request body.
- Positive decisions are request/operation scoped and are not browser tokens or permission caches.
- Assignment reduction and Session/credential revocation must take effect on the next protected operation.

## 11. Concurrency and transaction rules

- Authorization evaluation is read-only and issues no durable grant.
- A mutation use case revalidates authorization after acquiring the locks that protect its target when the decision could become stale before commit.
- Assignment create/end operations lock affected User/Employee and overlapping assignment records in a stable documented order.
- Effective interval constraints have PostgreSQL backstops once the overlap policy is approved.
- Idempotency keys are scoped to the exact assignment command and semantic payload.
- Privilege reduction cannot depend only on eventual cache expiry.
- Cross-context assignment administration is not assumed atomic. A future composition workflow coordinates context-owned commands with explicit failure/recovery semantics; neither context mutates the other's records.

## 12. Proposed file-level implementation manifest

The exact manifest must be frozen in the bounded implementation authorization. The current proposal is:

### Proposed exact paths

| Path | Proposed change |
|---|---|
| `backend/app/contexts/organization/application/contracts/branch_reference.rb` | Add typed Branch input. |
| `backend/app/contexts/organization/application/contracts/branch_ancestry.rb` | Add immutable Branch/Brand/Organization result value. |
| `backend/app/contexts/organization/application/contracts/resolve_branch_ancestry_result.rb` | Add resolved/not-found/inconsistent/unavailable result. |
| `backend/app/contexts/organization/application/ports/branch_ancestry_reader.rb` | Add Organization-owned persistence seam. |
| `backend/app/contexts/organization/application/queries/resolve_branch_ancestry.rb` | Add published Application query. |
| `backend/app/contexts/organization/infrastructure/persistence/active_record_branch_ancestry_reader.rb` | Implement the Organization reader without Identity knowledge. |
| `backend/app/contexts/workforce/domain/aggregates/employee_branch_assignment.rb` | Add effective-dated Workforce aggregate and invariants. |
| `backend/app/contexts/workforce/domain/value_objects/employee_branch_assignment_id.rb` | Add typed assignment identity. |
| `backend/app/contexts/workforce/domain/value_objects/branch_reference.rb` | Add Workforce-owned Branch reference value. |
| `backend/app/contexts/workforce/application/contracts/effective_employee_branch_access.rb` | Add immutable effective-access evidence. |
| `backend/app/contexts/workforce/application/contracts/resolve_effective_employee_branch_access_result.rb` | Add semantic result states. |
| `backend/app/contexts/workforce/application/ports/employee_branch_assignment_reader.rb` | Add Workforce-owned read seam. |
| `backend/app/contexts/workforce/application/queries/resolve_effective_employee_branch_access.rb` | Add published eligibility query. |
| `backend/app/contexts/workforce/infrastructure/persistence/employee_branch_assignment_record.rb` | Add namespaced persistence record after schema approval. |
| `backend/app/contexts/workforce/infrastructure/persistence/employee_branch_assignment_mapper.rb` | Add Domain/persistence mapping. |
| `backend/app/contexts/workforce/infrastructure/persistence/active_record_employee_branch_assignment_reader.rb` | Implement effective-time query. |
| `backend/app/contexts/identity/domain/entities/role_assignment.rb` | Add Identity-owned effective Role Assignment rules. |
| `backend/app/contexts/identity/domain/entities/user_employee_link.rb` | Add optional effective link and cardinality rules. |
| `backend/app/contexts/identity/domain/value_objects/role_code.rb` | Add the fixed role vocabulary. |
| `backend/app/contexts/identity/domain/policies/pos_capability_policy.rb` | Add the approved fixed role-to-capability matrix. |
| `backend/app/contexts/identity/application/contracts/business_authorization_request.rb` | Add exact capability and requested-scope input. |
| `backend/app/contexts/identity/application/contracts/business_authorization.rb` | Add non-client-constructible operation evidence. |
| `backend/app/contexts/identity/application/contracts/capability_identifier.rb` | Add only Owner-approved POS identifiers. |
| `backend/app/contexts/identity/application/ports/role_assignment_reader.rb` | Add current Identity role-fact seam. |
| `backend/app/contexts/identity/application/ports/user_employee_link_reader.rb` | Add current optional-link seam. |
| `backend/app/contexts/identity/application/ports/branch_scope.rb` | Add Identity-required Organization ancestry seam. |
| `backend/app/contexts/identity/application/ports/employee_branch_scope.rb` | Add Identity-required Workforce eligibility seam. |
| `backend/app/contexts/identity/application/ports/session_assurance.rb` | Add reviewed MFA/step-up/device assurance seam. |
| `backend/app/contexts/identity/application/use_cases/authorize_business_operation.rb` | Add the deep fail-closed authorization module. |
| `backend/app/contexts/identity/infrastructure/adapters/organization_branch_scope_adapter.rb` | Map the Organization published contract into Identity values. |
| `backend/app/contexts/identity/infrastructure/adapters/workforce_employee_branch_scope_adapter.rb` | Map the Workforce published contract into Identity values. |
| `backend/app/contexts/identity/infrastructure/persistence/role_assignment_record.rb` | Add Identity persistence after schema approval. |
| `backend/app/contexts/identity/infrastructure/persistence/user_employee_link_record.rb` | Add Identity persistence after schema approval. |
| `backend/app/contexts/identity/infrastructure/persistence/active_record_role_assignment_reader.rb` | Implement effective role reads. |
| `backend/app/contexts/identity/infrastructure/persistence/active_record_user_employee_link_reader.rb` | Implement effective link reads. |
| `backend/app/composition/identity_composition.rb` | Wire the approved module and adapters. |
| `backend/app/policies/identity/business_operation_policy.rb` | Add a thin Pundit adapter only if Presentation is included. |
| `backend/app/contexts/identity/package.yml` | Declare only demonstrated Organization/Workforce Application dependencies. |
| `backend/db/migrate/<timestamp>_create_pos_authorization_foundation.rb` | Proposed Identity schema migration; exact name/content requires approval. |
| `backend/db/migrate/<timestamp>_create_employee_branch_assignments.rb` | Proposed Workforce schema migration; exact name/content requires approval. |
| `backend/db/structure.sql` | Regenerate only from authorized migrations. |
| `backend/spec/domains/{identity,workforce,organization}/**/*_spec.rb` | Add Domain, Application, contract, persistence, temporal, and concurrency coverage. |
| `backend/spec/architecture/pos_authorization_dependency_spec.rb` | Add cross-context and layer dependency guards. |
| `backend/spec/policies/identity/business_operation_policy_spec.rb` | Prove Pundit delegates without role logic, if in scope. |

Assignment mutation use cases, audit ports/adapters, business routes, and controllers are intentionally absent from this first manifest. They require later explicit paths after audit and Presentation scope are approved.

### Organization

- add Branch ancestry contracts, reader port, query, and Active Record reader under `backend/app/contexts/organization/{application,infrastructure}/`;
- add query and persistence contract specs; and
- keep `Organization` independent of Identity and Workforce.

### Workforce

- add an Employee Branch Assignment Aggregate/Entity and typed references under `domain/`;
- add the effective-access query, contracts, and reader/repository ports under `application/`;
- add mapper, namespaced records, and Active Record readers/repository under `infrastructure/`;
- later add separately authorized create/end commands only with approved audit integration; and
- add Domain, Application, persistence, concurrency, and architecture specs.

### Identity

- preserve the existing Session use cases and self-session authorization;
- extend the code-owned capability registry with only approved identifiers;
- add Role Assignment and User–Employee link Domain concepts;
- add business-authorization request/result contracts and `AuthorizeBusinessOperation`;
- add inward-owned ports for Role Assignment, User–Employee link, Organization Branch scope, Workforce Employee Branch scope, Session assurance, and authoritative clock where required;
- add Identity Infrastructure persistence/adapters implementing those ports;
- extend `IdentityComposition` to construct the business-authorization module;
- later add assignment mutation use cases only with approved audit integration; and
- add policy, Application, Infrastructure, request-boundary, security, concurrency, and architecture specs.

### Composition, Presentation, and packages

- add an Identity business-operation Pundit adapter without business rules;
- add business-context consumer adapters only where a real authorized use case needs them;
- update `identity/package.yml` only for actual Organization/Workforce Application references;
- update other package dependencies only when real source requires them;
- add migrations and `structure.sql` changes only after exact schema approval; and
- add no business routes/controllers during the Milestone 2A foundation slice unless separately named in authorization.

### Explicitly excluded

- Membership;
- direct Identity access to Workforce/Organization Active Record;
- audit foundation changes or new producers;
- generic role-name authorization;
- client authority fields;
- business-context redesign;
- frontend integration;
- production configuration; and
- commit, push, merge, or deployment.

## 13. Test and verification plan

### 13.1 Domain and Application

- exact capability identity and no wildcard/prefix behavior;
- Owner Organization scope without Employee linkage;
- non-Owner allow only when Role Assignment, User–Employee link, and exact Branch Assignment are all effective;
- missing/expired/future/ended/mismatched assignments deny;
- wrong Organization and wrong Branch deny without disclosure;
- unavailable/inconsistent Organization or Workforce evidence fails closed;
- Staff and Branch Manager capability matrix cases;
- Branch Manager MFA and sensitive step-up requirements;
- forged or reflectively allocated contexts reject;
- assignment reduction takes effect on the next evaluation; and
- decision evidence cannot be client-constructed or reused as a universal grant.

### 13.2 Infrastructure and database

- Organization and Branch isolation;
- effective interval boundaries at exact instants;
- approved overlap/cardinality constraints;
- restrictive foreign keys and deletion behavior;
- optimistic locking and concurrent assignment create/end races;
- no unscoped User, Employee, Role Assignment, or Branch Assignment reads;
- mapper rejection of malformed persisted state;
- transaction rollback for future mutation/audit failures; and
- migration up/down, empty database, `structure.sql`, and schema equivalence.

### 13.3 Request and security

- cookie authentication and CSRF on unsafe endpoints;
- actor/Organization/Branch/role/capability spoofing ignored or rejected;
- IDOR and cross-Branch non-disclosure;
- missing MFA/step-up/device evidence denied;
- Session expiry, revocation, password/PIN/factor change invalidation;
- two-minute POS lock and reauthentication after its design is approved;
- safe error envelope and redacted logs; and
- no CORS expansion from the approved one-origin topology.

### 13.4 Architecture and regression

- Identity Domain/Application remain framework-independent;
- Identity has no Workforce/Organization Infrastructure reference;
- Workforce has no Identity dependency and does not authorize capabilities;
- Organization has no Identity/Workforce dependency;
- Pundit remains a thin adapter;
- Packwerk validation/check and custom architecture specs;
- full backend RSpec, Brakeman, dependency audit, and relevant concurrency suites; and
- frontend checks only when a later frontend slice is authorized.

## 14. Acceptance criteria

Milestone 2A is complete only when:

1. the exact capability matrix and sensitive-operation classification are approved;
2. a trusted Session can be resolved without client identity claims;
3. Owner scope works without an Employee record;
4. non-Owner access requires and proves all three independent predicates: capability/effective Role Assignment, optional-link resolution, and effective Employee Branch Assignment;
5. Organization and Branch ancestry are authoritative and cross-Organization access fails closed;
6. Branch Manager MFA and approved step-up rules are enforced;
7. assignment provisioning/change/end workflows have approved authority, history, audit, and failure behavior;
8. no context accesses another context's Infrastructure;
9. request, security, concurrency, database, and architecture tests pass; and
10. the Owner separately accepts executed evidence. Production authorization remains separate.

## 15. Recorded Gate A decision and remaining authorization conditions

The Project Owner approved all recommended options in this section on 2026-11-27, subject to the binding conditions in the [official Gate A decision record](after_four_pos_milestone_2a_gate_a_owner_decision.md). The approved design baseline establishes:

1. the initial cash-only capability matrix as a design catalog whose entries cannot activate without an approved owning Application use case, mapping, tests, and Gate B authority;
2. Identity ownership and the history-preserving effective-dated shape of the optional User–Employee link, with ordinary relinking prohibited;
3. deterministic Role Assignment scope/cardinality, while succession, recovery, emergency replacement, and Organization-lockout prevention remain to be specified;
4. primary and temporary Employee Branch Assignment semantics, while Gate B must specify exact interval, overlap, duration, correction, termination, and concurrency rules;
5. separate Identity and Workforce commands coordinated through an Application-level composition workflow, with partial state remaining non-authorizing;
6. the MFA/step-up assurance architecture as design direction, while numeric and fallback parameters remain security-evidence-gated;
7. the Organization and Workforce published Application contracts and Identity-owned adapter direction, without direct foreign persistence access;
8. mandatory database integrity as a design requirement, without authorizing exact SQL or migrations;
9. disabled assignment/link mutation entry points until the independent Audit producer contract is separately approved; and
10. mandatory Gate A/Gate B separation, with no blanket implementation authority.

### 15.1 Approved Gate A ballot source

The following table preserves the exact recommended options, alternatives, and tradeoffs reviewed by the Owner. The recorded values and binding conditions are in the [Owner Decision Ballot](after_four_pos_milestone_2a_owner_decision_ballot.md) and the [official decision record](after_four_pos_milestone_2a_gate_a_owner_decision.md). Approval does not authorize implementation.

| Decision | Recommended option | Alternative | Tradeoff/consequence |
|---|---|---|---|
| `POS-2A-01` Initial capability matrix | Approve the §5 cash-only candidate matrix; Owner receives all approved capabilities, Branch Manager receives Staff capabilities plus review-read/Dispatch recover/retry, and Staff receives only the listed ordinary capabilities. | Approve a narrower Staff read/create/confirm/cash set and defer hold, review, recover, and retry. | Narrower scope reduces early authority risk but delays operational recovery and review visibility. Manual bank remains excluded under either option. |
| `POS-2A-02` Sensitive classification | Require Branch Manager MFA for every manager Session; keep all action-level step-up operations unavailable until their exact future matrix is approved. | Approve action-level step-up for selected 2A candidates now. | The recommendation avoids inventing freshness/factor rules but provides no sensitive action until later review. |
| `POS-2A-03` User–Employee link | Identity owns a dedicated effective-dated, history-preserving optional one-to-one link; Owner may remain unlinked; ordinary relink is prohibited pending exception policy. | Store one nullable Employee reference directly on User. | A dedicated record adds schema and mapping but preserves history and avoids destructive reassignment; the nullable column is simpler but loses linkage history and complicates correction/rehire. |
| `POS-2A-04` Role Assignment scope/cardinality | One effective Organization-wide Owner assignment; non-Owner assignments are Branch-scoped; at most one effective role per User/Branch; roles on different Branches may differ; Owner does not coexist with Branch roles. | Allow multiple concurrent roles in one Branch or multiple effective Owners. | The recommendation makes authority deterministic. Alternatives require precedence, separation-of-duty, succession, and recovery rules not currently approved. |
| `POS-2A-05` Employee Branch Assignment | At most one effective primary assignment per Employee; explicitly approved temporary assignments may overlap and grant eligibility only for their exact Branch/effective interval. | Launch with primary-only assignments and defer temporary access. | Primary-only is simpler but conflicts with the confirmed direction that temporary assignments are supported; the recommendation needs overlap constraints and correction policy. |
| `POS-2A-06` Cross-context assignment workflow | Identity and Workforce keep separate commands. Activation is fail-closed until both required assignments are effective; no shared cross-context database transaction is introduced. Partial failure remains visible and recoverable through an approved composition workflow. | One coordinator directly writes both contexts in one transaction. | The recommendation preserves ownership and interfaces but needs explicit recovery states. The alternative creates cross-context persistence coupling and is not recommended. |
| `POS-2A-07` MFA/step-up implementation | Use a phishing-resistant factor as preferred Branch Manager MFA, permit a separately reviewed fallback, bind step-up to Session + exact action + request fingerprint, and approve numeric freshness/rate/device values only after the required security evidence. | Defer Branch Manager operation and ship a Staff-only authorized slice. | Full manager support needs more security work. Staff-only can reduce first-slice scope but does not complete Milestone 2A. PIN never satisfies MFA or step-up. |
| `POS-2A-08` Cross-context interfaces | Approve the Organization Branch-ancestry and Workforce effective-eligibility Application contracts in §7, with Identity-owned adapter ports and the exact dependency direction shown in §3. | Let Identity query Organization/Workforce persistence. | The alternative violates ADR-0011 and the confirmed ownership decision. |
| `POS-2A-09` Audit staging | Keep all assignment/link mutation entry points disabled until the Audit workstream separately approves the exact human producer contract; implement no interim POS producer. | Approve a separately reviewed bounded interim producer against existing audit facilities. | The recommendation prevents collision with the active Audit design but leaves provisioning non-operational. Any interim approach needs its own exact transaction, evidence, and retirement plan. |
| `POS-2A-10` Physical schema | After decisions 03–06, approve the two migrations and constraints represented in §12, with exact SQL/index/FK/exclusion details reviewed before execution. | Authorize Application code without database enforcement. | Application-only enforcement is insufficient for identity/assignment concurrency and is not recommended. |
| `POS-2A-11` Implementation gate | After the above decisions and security/Audit prerequisites, issue a bounded authorization naming the frozen file manifest, migrations, commands, tests, reviewers, and exclusions. | Treat this design mandate as blanket implementation authority. | Blanket authority conflicts with the explicit approval gates and is invalid. |

Gate A is `APPROVED`. Gate B remains `NOT_AUTHORIZED`, and implementation remains `NOT_STARTED`.
