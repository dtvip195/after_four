# AFTER FOUR — POS Milestone 2A Owner Decision Ballot

**Document version:** 1.0

**Prepared:** 2026-11-27

**Repository branch:** `development`

**Repository HEAD:** `b49a8827be53797b30ea1d7cb47791e7c74e7231`

**Source design:** [POS Milestone 2A Authorization Foundation Technical Design](after_four_pos_milestone_2a_authorization_foundation_design.md)

**Package status:** `GATE_A_APPROVED`

**Implementation status:** `GATE_B_NOT_AUTHORIZED — IMPLEMENTATION_NOT_STARTED`

**Official decision record:** [`POS-2A-GATE-A-OWNER-DECISION-001`](after_four_pos_milestone_2a_gate_a_owner_decision.md)

## 1. Executive summary

Milestone 2A establishes how AFTER FOUR will decide whether an authenticated User may perform one exact POS operation in one trusted Organization/Branch scope. It does not redesign existing authentication or business contexts. It extends the current trusted-session foundation so that:

- Owner authority can operate at Organization scope without requiring an Employee record;
- non-Owner Branch access requires all independent predicates: an applicable code-owned capability, an effective Identity-owned Role Assignment, an effective optional User–Employee link, and a Workforce-owned effective Employee Branch Assignment;
- Organization and Workforce publish narrow Application contracts instead of exposing persistence;
- Pundit remains a thin HTTP adapter over Identity Application authorization;
- missing or uncertain evidence fails closed; and
- new assignment/link mutations and audit producers remain disabled until separately approved.

On 2026-11-27, the Project Owner approved all eleven recommended design options subject to the binding conditions recorded below. Gate A approval accepts the selected design choices only. It does not authorize Ruby, schema, migration, policy, package, endpoint, audit, or runtime changes.

## 2. Decisions already settled and not reopened

The ballot relies on, but does not ask the Owner to reapprove:

- the roles Owner, Branch Manager, and Staff; Regional Manager remains inactive;
- Owner approval for Role Assignment and Employee Branch Assignment changes;
- code-owned, operation-specific capabilities rather than generic role-name checks;
- individual POS PINs, mandatory Branch Manager MFA, and step-up for sensitive operations;
- the two-minute POS inactivity lock and the approved session lifetimes;
- Identity ownership of User, Session, Role Assignment, trusted context, and authorization resolution;
- Workforce ownership of Employee and Employee Branch Assignment;
- Organization ownership of Organization, Brand, and Branch;
- optional User–Employee linkage and Owner operation without an Employee;
- client actor, Organization, Branch, role, and capability values are never authority;
- the initial POS Payment exposure is exact-balance cash only; and
- the Organization-Level Audit Foundation remains an independent, separately gated workstream.

Sources: [Identity Decision Register](after_four_identity_decision_register.md#owner-decisions-confirmed), [Owner Decision Baseline](after_four_owner_decision_baseline.md#project-wide-architecture), [ADR-0009](adr/0009-api-conventions-versioning.md), and [ADR-0011](adr/0011-project-wide-layered-ddd.md).

## 3. How to complete this ballot

The recorded Owner decision values use this vocabulary:

- `APPROVE`
- `APPROVE_WITH_CONDITION`
- `REJECT`
- `DEFER`
- `NEEDS_CLARIFICATION`

Recommendations remain visible as the advice reviewed by the Owner and remain separate from the recorded Owner decision. The official decision and its binding conditions are permanent in [`POS-2A-GATE-A-OWNER-DECISION-001`](after_four_pos_milestone_2a_gate_a_owner_decision.md). Gate A does not authorize implementation; a later Gate B package must be explicitly approved.

The source design expresses each “question” as a decision-topic label rather than a separate interrogative sentence. This ballot reproduces that label exactly as the original decision question and reproduces both option texts verbatim; the explanatory analysis below does not alter either option.

## 4. Decision items

### POS-2A-01 — Initial capability matrix

**Original decision question:** Initial capability matrix

**Original recommended option:** Approve the §5 cash-only candidate matrix; Owner receives all approved capabilities, Branch Manager receives Staff capabilities plus review-read/Dispatch recover/retry, and Staff receives only the listed ordinary capabilities.

**Original alternative:** Approve a narrower Staff read/create/confirm/cash set and defer hold, review, recover, and retry.

**Plain-language meaning:** Adopt a fixed first POS permission catalog. Staff can perform ordinary sale work; Branch Managers receive that set plus bounded review and Dispatch-recovery operations; Owner receives every capability that is separately approved. Existing bank-transfer code remains unavailable in the initial POS.

**Why this fits:** Exact capability constants implement the confirmed code-owned authorization direction and avoid generic `is_manager?` checks. Cash-only scope preserves `CORE-OD-07`. The existing Identity registry currently contains only self-session read, so the proposal extends rather than duplicates it ([capability registry](../../backend/app/contexts/identity/application/contracts/capability_identifier.rb)).

**Consequences:**

- Security/authorization: least privilege is explicit; no role silently gains future capabilities.
- Data ownership: Identity owns capability resolution; business contexts still own resource scope and business eligibility.
- Concurrency: capability changes must be evaluated from current server state, not cached client state.
- Operations: the broader option enables hold, review visibility, and Dispatch recovery sooner; it increases the matrix that must be tested.

**Dependencies and conditions:** Depends on POS-2A-02, 04, 05, 07, and 08. Each capability may activate only after its owning Application capability and business policy are approved. Manual bank remains excluded.

**Conflicts/evidence:** No ADR conflict. The capability identifiers and role mapping do not yet exist. Payment bank-transfer implementation exists internally but does not override cash-only exposure ([Owner Decision Baseline, `CORE-OD-07`](after_four_owner_decision_baseline.md)).

**If the alternative is chosen:** Review visibility and Dispatch recovery move to later milestones; operational exceptions require Owner/manual intervention until separately exposed.

**Recommendation:** `RECOMMEND_APPROVE_WITH_CONDITION`

**Recommended condition:** Approve the matrix as a catalog only; activate each entry only with its owning authorized use case, tests, and Gate B scope.

**Owner decision:** `APPROVE_WITH_CONDITION`

**Decision status:** `OWNER_DECIDED`

**Binding conditions:** This is an initial design catalog only. Activation requires an approved owning Application use case, explicit authorization mapping, relevant tests, and separate Gate B authorization. Catalog presence alone does not make a capability executable. Initial POS Payment remains exact-balance cash only, and existing bank-transfer implementation remains unexposed.

**Owner notes:** See the official decision record.

### POS-2A-02 — Sensitive classification

**Original decision question:** Sensitive classification

**Original recommended option:** Require Branch Manager MFA for every manager Session; keep all action-level step-up operations unavailable until their exact future matrix is approved.

**Original alternative:** Approve action-level step-up for selected 2A candidates now.

**Plain-language meaning:** Enforce the already approved Branch Manager MFA rule, but do not guess which first-slice commands require a fresh action-level step-up. Any operation that truly needs step-up stays unavailable until its exact evidence contract is approved.

**Why this fits:** It preserves ID-02 and ID-13 without inventing MFA freshness, factor, or binding values that remain security-review work ([Identity Decision Register](after_four_identity_decision_register.md#owner-decisions-confirmed)). PIN cannot satisfy MFA or step-up under ID-21.

**Consequences:**

- Security/authorization: no sensitive operation is downgraded because assurance is missing.
- Data ownership: Session assurance remains Identity-owned.
- Concurrency: assurance invalidation must be checked against current Session/credential state.
- Operations: managers cannot perform a future sensitive action until its step-up design is approved.

**Dependencies and conditions:** Depends on POS-2A-07. The capability catalog in POS-2A-01 must mark unavailable sensitive operations explicitly.

**Conflicts/evidence:** No policy conflict. Current authentication Sessions have no reviewed MFA/step-up/device assurance fields, so selecting action-level step-up now would still not authorize implementation ([session record](../../backend/app/contexts/identity/infrastructure/persistence/authentication_session_record.rb)).

**If the alternative is chosen:** The Owner must immediately decide factor, freshness, Session/action/request binding, invalidation, recovery, and failure behavior for every selected action, expanding the security review and Gate B scope.

**Recommendation:** `RECOMMEND_APPROVE`

**Owner decision:** `APPROVE`

**Decision status:** `OWNER_DECIDED`

**Binding conditions:** Branch Manager MFA is required for every manager Session. Action-level step-up remains unavailable until its exact action matrix, assurance requirements, freshness, binding, invalidation, and recovery behavior are separately reviewed and approved. PIN cannot substitute for MFA or step-up.

**Owner notes:** See the official decision record.

### POS-2A-03 — User–Employee link

**Original decision question:** User–Employee link

**Original recommended option:** Identity owns a dedicated effective-dated, history-preserving optional one-to-one link; Owner may remain unlinked; ordinary relink is prohibited pending exception policy.

**Original alternative:** Store one nullable Employee reference directly on User.

**Plain-language meaning:** Keep User and Employee independent and represent their optional relationship as its own historical Identity record. Ending or correcting a link does not overwrite who was previously linked.

**Why this fits:** The link exists to resolve authorization from an Identity User to a Workforce Employee, so Identity is the appropriate owner. A dedicated record preserves optionality and history while Workforce remains authoritative for Employee facts. Current User and Employee records are separate and have no link ([User record](../../backend/app/contexts/identity/infrastructure/persistence/user_record.rb), [Employee record](../../backend/app/contexts/workforce/infrastructure/persistence/employee_record.rb)).

**Consequences:**

- Security/authorization: non-Owner access fails when the effective link is absent or ambiguous; Owner remains valid without Employee.
- Data ownership: the link stores an opaque Employee reference, not Workforce employment facts.
- Concurrency: effective one-to-one cardinality needs transactional locks and database enforcement.
- Operations: historical linkage supports investigation, correction, offboarding, and later rehire design.

**Dependencies and conditions:** Depends on POS-2A-06, 09, and 10. Link mutation remains disabled until audit and Owner-approved mutation workflow exist.

**Conflicts/evidence:** No ADR conflict. The 2026-11-26 ownership decision leaves physical linkage unresolved, so Gate A must explicitly accept this ownership choice ([Owner Decision Baseline](after_four_owner_decision_baseline.md#project-wide-architecture)).

**If the alternative is chosen:** The schema is smaller, but link history, correction, concurrent reassignment, and rehire investigation move into ad hoc User mutation rules. Recovering prior linkage becomes difficult or impossible without separate history.

**Recommendation:** `RECOMMEND_APPROVE_WITH_CONDITION`

**Recommended condition:** Preserve history, prohibit ordinary relink, and require separately approved exception/audit behavior before any change command.

**Owner decision:** `APPROVE_WITH_CONDITION`

**Decision status:** `OWNER_DECIDED`

**Binding conditions:** The link is dedicated, optional, effective-dated, history-preserving, and Identity-owned. Enforce one effective User–Employee relationship in both directions at any evaluation instant. Owner may remain unlinked. Ordinary relinking is prohibited. Correction, replacement, and exceptional relinking require separately approved workflow and audit evidence.

**Owner notes:** See the official decision record.

### POS-2A-04 — Role Assignment scope/cardinality

**Original decision question:** Role Assignment scope/cardinality

**Original recommended option:** One effective Organization-wide Owner assignment; non-Owner assignments are Branch-scoped; at most one effective role per User/Branch; roles on different Branches may differ; Owner does not coexist with Branch roles.

**Original alternative:** Allow multiple concurrent roles in one Branch or multiple effective Owners.

**Plain-language meaning:** Make current authority deterministic: one Owner governs the Organization, and each non-Owner has one clear role in each assigned Branch. A User may have different non-Owner roles in different Branches.

**Why this fits:** It implements the confirmed Organization-wide Owner and Branch-scoped non-Owner model while avoiding precedence rules absent from current policy. Role Assignment remains Identity-owned and separate from Workforce eligibility.

**Consequences:**

- Security/authorization: no privilege union or role-precedence ambiguity within one Branch.
- Data ownership: Identity owns the assignment; Organization supplies scope facts.
- Concurrency: overlapping effective intervals require database backstops and serialized changes.
- Operations: Owner succession cannot be implemented as two simultaneously effective Owners under this option.

**Dependencies and conditions:** Depends on POS-2A-06, 09, and 10. Owner recovery and succession remain separate reviewed procedures.

**Conflicts/evidence:** No current implementation conflict because Role Assignment persistence is absent. Multiple Owners or same-Branch multi-role behavior is not approved by the Identity register.

**If the alternative is chosen:** The Owner must define capability union/precedence, self-approval and separation-of-duty rules, multiple-Owner conflict resolution, recovery, and revocation semantics before authorization can be deterministic.

**Recommendation:** `RECOMMEND_APPROVE_WITH_CONDITION`

**Recommended condition:** Treat succession/recovery as a separate process that never silently creates concurrent ordinary Owner authority.

**Owner decision:** `APPROVE_WITH_CONDITION`

**Decision status:** `OWNER_DECIDED`

**Binding conditions:** There is one effective Organization-wide Owner assignment, at most one effective non-Owner role per User/Branch, and different Branches may have different non-Owner roles. Owner succession, recovery, emergency replacement, and prevention of Organization lockout must be separately specified. No ordinary concurrent Owner assignments or implicit role precedence are permitted.

**Owner notes:** See the official decision record.

### POS-2A-05 — Employee Branch Assignment

**Original decision question:** Employee Branch Assignment

**Original recommended option:** At most one effective primary assignment per Employee; explicitly approved temporary assignments may overlap and grant eligibility only for their exact Branch/effective interval.

**Original alternative:** Launch with primary-only assignments and defer temporary access.

**Plain-language meaning:** Every Employee has at most one home Branch at a time, but an Owner-approved temporary assignment can add work eligibility in another Branch for a defined period.

**Why this fits:** The confirmed Workforce direction supports effective-dated primary and temporary assignment while keeping it separate from Role Assignment and capability ([Identity Decision Register, existing boundaries](after_four_identity_decision_register.md#existing-approved-boundaries); [Owner Decision Baseline, `P2B-WF-OD-02`](after_four_owner_decision_baseline.md#wave-2-consolidated-owner-decisions)).

**Consequences:**

- Security/authorization: temporary work eligibility grants no capability by itself.
- Data ownership: Workforce owns assignment kind, interval, reason, and history.
- Concurrency: primary overlap and same-Branch duplicate intervals need database exclusion/uniqueness enforcement.
- Operations: multi-Branch rotation is possible without changing the Employee's primary Branch.

**Dependencies and conditions:** Depends on POS-2A-06, 08, 09, and 10. Temporary duration, correction, and approval evidence must be frozen before mutation commands.

**Conflicts/evidence:** No implementation conflict; the current Employee foundation intentionally has no Branch Assignment ([Workforce Employee foundation](../research/workforce_employee_foundation_implementation.md)).

**If the alternative is chosen:** Initial schema and operation are simpler, but temporary Branch access cannot be represented truthfully; staff rotation would require changing the primary assignment or remain unsupported.

**Recommendation:** `RECOMMEND_APPROVE_WITH_CONDITION`

**Recommended condition:** Gate B must specify interval boundaries, maximum temporary duration or explicitly no fixed maximum, correction semantics, and concurrency constraints.

**Owner decision:** `APPROVE_WITH_CONDITION`

**Decision status:** `OWNER_DECIDED`

**Binding conditions:** At most one effective primary Branch assignment exists per Employee. Explicitly approved temporary assignments may overlap and grant eligibility only for their exact Branch and effective interval. Eligibility alone does not grant authorization. Gate B must specify interval boundaries, overlap constraints, maximum temporary duration policy, correction, early termination, and concurrency enforcement.

**Owner notes:** See the official decision record.

### POS-2A-06 — Cross-context assignment workflow

**Original decision question:** Cross-context assignment workflow

**Original recommended option:** Identity and Workforce keep separate commands. Activation is fail-closed until both required assignments are effective; no shared cross-context database transaction is introduced. Partial failure remains visible and recoverable through an approved composition workflow.

**Original alternative:** One coordinator directly writes both contexts in one transaction.

**Plain-language meaning:** Each context changes only the records it owns. A higher-level workflow can coordinate the two changes, but neither Identity nor Workforce writes the other's tables, and access does not activate until all required facts exist.

**Why this fits:** It directly follows ADR-0011 and the confirmed ownership decision. Composition wires interfaces; it does not become a generic persistence module or bypass context ownership.

**Consequences:**

- Security/authorization: partial completion never grants partial access.
- Data ownership: Identity and Workforce preserve independent histories and invariants.
- Concurrency: each command owns its transaction and locking; cross-context recovery is explicit rather than falsely atomic.
- Operations: administrators may see a pending/incomplete assignment workflow requiring safe retry or compensation.

**Dependencies and conditions:** Depends on POS-2A-03, 04, 05, 08, and 09. Recovery states, attempt identity, idempotency, and operator visibility must be approved before mutation.

**Conflicts/evidence:** The alternative conflicts with ADR-0011 if it directly manipulates both contexts' Infrastructure. Existing OPP local transaction behavior does not establish a generic cross-context write pattern ([ADR-0012](adr/0012-ordering-payment-preparation-ddd-boundaries.md)).

**If the alternative is chosen:** A shared coordinator would need an explicitly approved cross-context transaction architecture, broader Packwerk access, and rules for which context owns invariants and failures. It risks turning composition into a shallow bypass.

**Recommendation:** `RECOMMEND_APPROVE_WITH_CONDITION`

**Recommended condition:** Gate B must define pending/failed/retry/recovery semantics without enabling access from partial state.

**Owner decision:** `APPROVE_WITH_CONDITION`

**Decision status:** `OWNER_DECIDED`

**Binding conditions:** Identity and Workforce use separate commands coordinated through an explicit Application-level composition workflow. Direct cross-context persistence and a shared cross-context database transaction are prohibited. Partial completion remains non-authorizing. Gate B must define durable workflow state, idempotency, retry, recovery, cancellation/compensation where applicable, and operator visibility.

**Owner notes:** See the official decision record.

### POS-2A-07 — MFA/step-up implementation

**Original decision question:** MFA/step-up implementation

**Original recommended option:** Use a phishing-resistant factor as preferred Branch Manager MFA, permit a separately reviewed fallback, bind step-up to Session + exact action + request fingerprint, and approve numeric freshness/rate/device values only after the required security evidence.

**Original alternative:** Defer Branch Manager operation and ship a Staff-only authorized slice.

**Plain-language meaning:** Build toward strong manager authentication, with step-up proof usable only for the same Session and exact action. Do not invent numeric expiry, retry, or device parameters before evidence supports them.

**Why this fits:** It implements the approved MFA and step-up principles while respecting their security-review boundary. The current technical design prefers WebAuthn/passkeys/security keys and treats other factors as reviewed fallback, not automatic equivalence ([Identity Technical Design](after_four_identity_technical_design.md#5-authentication-mfa-step-up-and-recovery)).

**Consequences:**

- Security/authorization: stolen ordinary Session or PIN proof cannot authorize sensitive actions.
- Data ownership: Identity owns factors, assurance, challenges, and invalidation.
- Concurrency: a changed body, target, Session, factor, or authorization state invalidates the proof.
- Operations: full Branch Manager support depends on factor enrollment, recovery, device, and support procedures.

**Dependencies and conditions:** Depends on POS-2A-02. Requires Owner-led security review and numeric parameter evidence. Audit producer work remains separately gated.

**Conflicts/evidence:** No approved-decision conflict. Current implementation has password authentication and Session expiry but no MFA/step-up/enrolled-POS-device implementation. Production authentication acceptance remains separate.

**If the alternative is chosen:** A Staff-only slice can proceed sooner, but Milestone 2A remains incomplete and manager-only review/recovery operations remain unavailable.

**Recommendation:** `RECOMMEND_APPROVE_WITH_CONDITION`

**Recommended condition:** Gate A approves the assurance shape, not a factor provider or numeric values; Gate B waits for the required security evidence.

**Owner decision:** `APPROVE_WITH_CONDITION`

**Decision status:** `OWNER_DECIDED`

**Binding conditions:** The assurance architecture is approved as a design direction only. Phishing-resistant MFA is preferred; any fallback requires separate review. Step-up proof binds to the authenticated Session, exact action, and canonical request fingerprint, with replay prevention and invalidation on relevant Session, credential, target, or authorization changes. Numeric freshness, retry, rate, device, and recovery parameters remain unapproved pending security evidence. PIN cannot substitute for MFA or step-up.

**Owner notes:** See the official decision record.

### POS-2A-08 — Cross-context interfaces

**Original decision question:** Cross-context interfaces

**Original recommended option:** Approve the Organization Branch-ancestry and Workforce effective-eligibility Application contracts in §7, with Identity-owned adapter ports and the exact dependency direction shown in §3.

**Original alternative:** Let Identity query Organization/Workforce persistence.

**Plain-language meaning:** Identity asks Organization and Workforce through small published Application interfaces. Identity never loads their Active Record records or depends on their Infrastructure.

**Why this fits:** It is the only option consistent with ADR-0011 and the explicit 2026-11-26 ownership decision. It follows the existing Organization-to-Identity ancestry adapter pattern ([Organization scope adapter](../../backend/app/contexts/identity/infrastructure/adapters/organization_scope_adapter.rb)).

**Consequences:**

- Security/authorization: authoritative facts are mapped into Identity-owned values and uncertainty fails closed.
- Data ownership: each context controls the meaning and persistence of its facts.
- Concurrency: interfaces must return evaluation-time/evidence sufficient to detect stale or mismatched facts.
- Operations: failures can be classified safely without leaking cross-Organization existence.

**Dependencies and conditions:** Depends on POS-2A-05 and 06. Packwerk dependencies change only when approved source is added.

**Conflicts/evidence:** The alternative directly conflicts with ADR-0011 and current architecture specs that prohibit Identity from accessing Workforce/Organization internals ([I1 dependency spec](../../backend/spec/architecture/i1_dependency_spec.rb)).

**If the alternative is chosen:** The project would require an Owner-approved ADR change, weaken context ownership, couple authorization to foreign schemas, and make later implementation changes harder to localize.

**Recommendation:** `RECOMMEND_APPROVE`

**Owner decision:** `APPROVE`

**Decision status:** `OWNER_DECIDED`

**Binding conditions:** Identity may consume only the approved Organization Branch-ancestry and Workforce effective-eligibility published Application contracts through Identity-owned adapter ports. Direct Active Record, Infrastructure, or foreign persistence access is prohibited. Unknown, stale, ambiguous, or unavailable evidence fails closed.

**Owner notes:** See the official decision record.

### POS-2A-09 — Audit staging

**Original decision question:** Audit staging

**Original recommended option:** Keep all assignment/link mutation entry points disabled until the Audit workstream separately approves the exact human producer contract; implement no interim POS producer.

**Original alternative:** Approve a separately reviewed bounded interim producer against existing audit facilities.

**Plain-language meaning:** Do not create production assignment-changing commands until they can record the required trusted evidence through the independently approved Audit design. Read-only authorization design may continue, but provisioning is not operational.

**Why this fits:** Sensitive assignment history is already an approved requirement, while the active Audit workstream explicitly has no production producer authority. Existing OPP audit adapters remain unchanged and are not a general authorization-audit contract ([Audit Foundation Assessment](../research/organization_level_audit_foundation_assessment.md)).

**Consequences:**

- Security/authorization: no untracked privilege change is enabled.
- Data ownership: Identity/Workforce will later own narrow producer ports; Audit owns append validation/persistence.
- Concurrency: mutation and required audit append must use the separately approved transaction/failure contract.
- Operations: no production assignment/link provisioning is available until the Audit dependency closes.

**Dependencies and conditions:** Blocks mutation portions of POS-2A-03 through 06 and the executable schema workflow. Independent Audit review and producer decisions remain prerequisites.

**Conflicts/evidence:** No source conflict. The alternative would need an exact interim event envelope, transaction semantics, failure mode, database privileges, migration/retirement plan, and Owner authorization; none currently exists.

**If the alternative is chosen:** Gate A expands into a second audit design. The project must prove the interim producer cannot weaken or collide with the active Audit workstream and must define its later migration.

**Recommendation:** `RECOMMEND_APPROVE`

**Owner decision:** `APPROVE`

**Decision status:** `OWNER_DECIDED`

**Binding conditions:** Assignment and link mutation entry points remain disabled until the independent Audit workstream separately approves the exact producer contract, event types, provenance, persistence, failure semantics, and authorization requirements. No interim POS audit producer is authorized. This decision does not modify, replace, or authorize the Organization-Level Audit Foundation.

**Owner notes:** See the official decision record.

### POS-2A-10 — Physical schema

**Original decision question:** Physical schema

**Original recommended option:** After decisions 03–06, approve the two migrations and constraints represented in §12, with exact SQL/index/FK/exclusion details reviewed before execution.

**Original alternative:** Authorize Application code without database enforcement.

**Plain-language meaning:** Authorization records need PostgreSQL backstops for identity, scope, effective intervals, and cardinality. Application validation alone is insufficient under concurrent requests. No migration runs until Gate B names and approves its exact content.

**Why this fits:** ADR-0010 retains migrations plus `structure.sql`, while ADR-0011 places PostgreSQL enforcement in Infrastructure. Existing Order/Payment/Workforce foundations use database constraints for the same concurrency/integrity reason ([ADR-0010](adr/0010-database-migrations-and-schema.md)).

**Consequences:**

- Security/authorization: direct or racing writes cannot create invalid simultaneous authority merely by bypassing Application validation.
- Data ownership: migrations create context-owned relations; physical FKs do not authorize cross-context record access.
- Concurrency: exclusion/unique constraints and stable locking enforce the approved interval/cardinality policy.
- Operations: schema rollout, rollback, structure-load parity, and constraint validation become Gate B obligations.

**Dependencies and conditions:** Depends on final Gate A choices for POS-2A-03 through 06 and on POS-2A-09 for mutation activation.

**Conflicts/evidence:** No conflict with ADR-0010. The exact SQL, indexes, FK delete behavior, exclusion ranges, migration ordering, and rollback have not been reviewed and therefore cannot be authorized by Gate A alone.

**If the alternative is chosen:** Concurrent or direct database writes can violate one-to-one linkage, role cardinality, or assignment overlap. The system could grant ambiguous authority even while Application tests pass.

**Recommendation:** `RECOMMEND_APPROVE_WITH_CONDITION`

**Recommended condition:** Gate A approves mandatory database enforcement and the proposed relation ownership only. Gate B must review and explicitly authorize the exact migrations and rollback plan.

**Owner decision:** `APPROVE_WITH_CONDITION`

**Decision status:** `OWNER_DECIDED`

**Binding conditions:** Database-level integrity enforcement and context-owned relation boundaries are design requirements only. Exact SQL, indexes, foreign keys, exclusion constraints, migration ordering, rollback, and `structure.sql` parity require a separately reviewed Gate B manifest. No migration is authorized.

**Owner notes:** See the official decision record.

### POS-2A-11 — Implementation gate

**Original decision question:** Implementation gate

**Original recommended option:** After the above decisions and security/Audit prerequisites, issue a bounded authorization naming the frozen file manifest, migrations, commands, tests, reviewers, and exclusions.

**Original alternative:** Treat this design mandate as blanket implementation authority.

**Plain-language meaning:** First decide the design. Then review a separate, exact implementation package. No source work begins merely because this ballot or the master roadmap exists.

**Why this fits:** It applies the repository's established Identity entry gates and prevents documentation readiness from being mistaken for code, security, or production acceptance ([Foundation Decisions §5](after_four_foundation_decisions.md#5-milestone-2--identity-branch-scope-and-authorization)).

**Consequences:**

- Security/authorization: reviewers know exactly which controls and evidence are in scope.
- Data ownership: file/package/migration manifests prevent incidental context expansion.
- Concurrency/operations: required test environments, rollback, failure handling, and prohibited changes are explicit before execution.
- Delivery: implementation starts later, but review and acceptance remain auditable and bounded.

**Dependencies and conditions:** Depends on dispositions for POS-2A-01 through 10 and satisfaction of applicable security/Audit prerequisites.

**Conflicts/evidence:** The blanket alternative contradicts the explicit Gate A/Gate B separation and the mandate's approval rules.

**If the alternative is chosen:** Scope becomes ambiguous, schema/security changes could proceed without exact approval, and later test success could be mistaken for acceptance. The alternative is invalid under current governance.

**Recommendation:** `RECOMMEND_APPROVE`

**Owner decision:** `APPROVE`

**Decision status:** `OWNER_DECIDED`

**Binding conditions:** Approve mandatory separation between Gate A design approval and Gate B bounded implementation authorization. Gate B must identify exact files, packages, contracts, migrations, tests, reviewers, exclusions, and rollback requirements. This decision grants no blanket implementation authority.

**Owner notes:** See the official decision record.

## 5. Gate meanings and authorization status

### Gate A — Design Baseline Approval

The Owner records a decision for POS-2A-01 through POS-2A-11. The selected options for POS-2A-01 through POS-2A-10 form the design baseline; POS-2A-11 governs the separate implementation-authorization step. Gate A:

- does not authorize source, schema, migration, package, endpoint, audit, dependency, or runtime changes;
- does not close security/Audit prerequisites;
- does not constitute Control Acceptance; and
- does not authorize production.

Current status: `GATE_A_APPROVED` under [`POS-2A-GATE-A-OWNER-DECISION-001`](after_four_pos_milestone_2a_gate_a_owner_decision.md).

### Gate B — Bounded Implementation Authorization

After Gate A, a separate package must state:

- exact files and packages permitted to change;
- exact schema and migration scope;
- exact Application contracts and use cases;
- exact HTTP scope, if any;
- authorization/security invariants;
- required tests, environments, and validation commands;
- prohibited changes and explicit exclusions;
- external dependencies and approval prerequisites; and
- rollback, concurrency, partial-failure, and recovery considerations.

Current status: `GATE_B_NOT_AUTHORIZED`.

### Control Acceptance

After authorized implementation, actual test, security-review, architecture, database, concurrency, and integration evidence is evaluated against the approved controls. Passing tests alone do not prove design correctness, security acceptance, or production readiness.

Current status: `CONTROL_ACCEPTANCE_NOT_STARTED`.

### Operational Acceptance

Deployment topology, secrets, monitoring, backup/restore, incident ownership, operational procedures, legal/privacy blockers, performance, and production evidence are assessed separately after Control Acceptance.

Current status: `OPERATIONAL_ACCEPTANCE_NOT_STARTED`.

## 6. Final decision summary

| Decision | Topic | Recommendation | Owner decision | Decision status |
|---|---|---|---|---|
| `POS-2A-01` | Initial capability matrix | `RECOMMEND_APPROVE_WITH_CONDITION` | `APPROVE_WITH_CONDITION` | `OWNER_DECIDED` |
| `POS-2A-02` | Sensitive classification | `RECOMMEND_APPROVE` | `APPROVE` | `OWNER_DECIDED` |
| `POS-2A-03` | User–Employee link | `RECOMMEND_APPROVE_WITH_CONDITION` | `APPROVE_WITH_CONDITION` | `OWNER_DECIDED` |
| `POS-2A-04` | Role Assignment scope/cardinality | `RECOMMEND_APPROVE_WITH_CONDITION` | `APPROVE_WITH_CONDITION` | `OWNER_DECIDED` |
| `POS-2A-05` | Employee Branch Assignment | `RECOMMEND_APPROVE_WITH_CONDITION` | `APPROVE_WITH_CONDITION` | `OWNER_DECIDED` |
| `POS-2A-06` | Cross-context assignment workflow | `RECOMMEND_APPROVE_WITH_CONDITION` | `APPROVE_WITH_CONDITION` | `OWNER_DECIDED` |
| `POS-2A-07` | MFA/step-up implementation | `RECOMMEND_APPROVE_WITH_CONDITION` | `APPROVE_WITH_CONDITION` | `OWNER_DECIDED` |
| `POS-2A-08` | Cross-context interfaces | `RECOMMEND_APPROVE` | `APPROVE` | `OWNER_DECIDED` |
| `POS-2A-09` | Audit staging | `RECOMMEND_APPROVE` | `APPROVE` | `OWNER_DECIDED` |
| `POS-2A-10` | Physical schema | `RECOMMEND_APPROVE_WITH_CONDITION` | `APPROVE_WITH_CONDITION` | `OWNER_DECIDED` |
| `POS-2A-11` | Implementation gate | `RECOMMEND_APPROVE` | `APPROVE` | `OWNER_DECIDED` |

## 7. Package verdict

`GATE_A_APPROVED`

`GATE_B_NOT_AUTHORIZED`

`CONTROL_ACCEPTANCE_NOT_STARTED`

`OPERATIONAL_ACCEPTANCE_NOT_STARTED`

`IMPLEMENTATION_NOT_STARTED`

No decision in this document modifies source, schema, migration, package dependencies, audit infrastructure, or runtime behavior.
