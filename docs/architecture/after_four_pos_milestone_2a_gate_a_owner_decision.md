# AFTER FOUR — POS Milestone 2A Gate A Owner Decision

**Decision ID:** `POS-2A-GATE-A-OWNER-DECISION-001`

**Decision date:** 2026-11-27

**Decision authority:** Project Owner

**Repository branch:** `development`

**Repository HEAD:** `b49a8827be53797b30ea1d7cb47791e7c74e7231`

**Official decision:** `GATE_A_APPROVED — GATE_B_NOT_AUTHORIZED`

**Implementation status:** `IMPLEMENTATION_NOT_STARTED`

## 1. Decision

The Project Owner approves all recommended options for `POS-2A-01` through `POS-2A-11`, subject to every binding condition recorded below. This approval establishes the Milestone 2A Design Baseline only.

This decision does not authorize implementation. Gate B requires a separate, explicit, bounded implementation authorization.

The reviewed questions, original options, rationale, and consequences remain recorded in the [Owner Decision Ballot](after_four_pos_milestone_2a_owner_decision_ballot.md). The accepted design is documented in the [Milestone 2A Authorization Foundation Technical Design](after_four_pos_milestone_2a_authorization_foundation_design.md).

## 2. Recorded Owner decisions and binding conditions

### POS-2A-01 — Initial capability matrix

**Owner decision:** `APPROVE_WITH_CONDITION`

Approve the proposed capability matrix as an initial design catalog only.

Capability activation requires:

- an approved owning Application use case;
- explicit authorization mapping;
- relevant tests; and
- separate Gate B authorization.

A capability must not become executable merely because it exists in the catalog.

Initial POS Payment remains exact-balance cash only. Existing bank-transfer implementation must not be exposed in the initial POS.

### POS-2A-02 — Sensitive classification

**Owner decision:** `APPROVE`

Require Branch Manager MFA for every manager Session.

Action-level step-up remains unavailable until its exact action matrix, assurance requirements, freshness, binding, invalidation, and recovery behavior have been separately reviewed and approved.

PIN must not substitute for MFA or step-up.

### POS-2A-03 — User–Employee link

**Owner decision:** `APPROVE_WITH_CONDITION`

Approve a dedicated, optional, effective-dated, history-preserving Identity-owned link.

Enforce one effective User–Employee relationship in both directions at any evaluation instant.

Owner may remain unlinked. Ordinary relinking is prohibited.

Correction, replacement, and exceptional relinking require separately approved workflow and audit evidence.

### POS-2A-04 — Role Assignment scope/cardinality

**Owner decision:** `APPROVE_WITH_CONDITION`

Approve:

- one effective Organization-wide Owner assignment;
- at most one effective non-Owner role per User/Branch; and
- different Branches may have different non-Owner roles.

Owner succession, recovery, emergency replacement, and prevention of Organization lockout must be separately specified.

No ordinary concurrent Owner assignments or implicit role precedence.

### POS-2A-05 — Employee Branch Assignment

**Owner decision:** `APPROVE_WITH_CONDITION`

Approve at most one effective primary Branch assignment per Employee.

Explicitly approved temporary assignments may overlap and grant eligibility only for their exact Branch and effective interval.

Assignment eligibility alone does not grant authorization.

Gate B must specify:

- interval boundaries;
- overlap constraints;
- maximum temporary duration policy;
- correction;
- early termination; and
- concurrency enforcement.

### POS-2A-06 — Cross-context assignment workflow

**Owner decision:** `APPROVE_WITH_CONDITION`

Approve separate Identity and Workforce commands coordinated through an explicit Application-level composition workflow.

No direct cross-context persistence. No shared cross-context database transaction. Partial completion must remain non-authorizing.

Gate B must define:

- durable workflow state;
- idempotency;
- retry;
- recovery;
- cancellation/compensation where applicable; and
- operator visibility.

### POS-2A-07 — MFA/step-up implementation

**Owner decision:** `APPROVE_WITH_CONDITION`

Approve the proposed assurance architecture as a design direction only.

Prefer phishing-resistant MFA. Any fallback requires separate review.

Step-up proof must be bound to:

- the authenticated Session;
- the exact action; and
- the canonical request fingerprint.

It must include replay prevention and invalidation on relevant Session, credential, target, or authorization changes.

Numeric freshness, retry, rate, device, and recovery parameters remain unapproved pending security evidence.

PIN cannot substitute for MFA or step-up.

### POS-2A-08 — Cross-context interfaces

**Owner decision:** `APPROVE`

Approve the proposed Organization Branch-ancestry and Workforce effective-eligibility Application contracts.

Identity may consume only published Application contracts and Identity-owned adapter ports.

No direct Active Record, Infrastructure, or foreign persistence access.

Unknown, stale, ambiguous, or unavailable evidence must fail closed.

### POS-2A-09 — Audit staging

**Owner decision:** `APPROVE`

Keep assignment and link mutation entry points disabled until the independent Audit workstream separately approves the exact producer contract, event types, provenance, persistence, failure semantics, and authorization requirements.

No interim POS audit producer is authorized.

This decision does not modify, replace, or authorize implementation of the independent Organization-Level Audit Foundation.

### POS-2A-10 — Physical schema

**Owner decision:** `APPROVE_WITH_CONDITION`

Approve mandatory database-level integrity enforcement and context-owned relation boundaries as design requirements only.

Exact SQL, indexes, foreign keys, exclusion constraints, migration ordering, rollback, and `structure.sql` parity require a separate reviewed Gate B manifest.

No migration is authorized by this decision.

### POS-2A-11 — Implementation gate

**Owner decision:** `APPROVE`

Approve mandatory separation between Gate A design approval and Gate B bounded implementation authorization.

Gate B must identify:

- exact files;
- packages;
- contracts;
- migrations;
- tests;
- reviewers;
- exclusions; and
- rollback requirements.

This decision grants no blanket implementation authority.

## 3. Preserved architecture constraints

All previously approved project decisions remain in force:

- Organization owns Organization, Brand, and Branch.
- Workforce owns Employee and Employee Branch Assignment.
- Identity owns User, authentication, Sessions, Role Assignment, Trusted Authorization Context, and authorization resolution.
- User and Employee remain independent identities with an optional relationship.
- Owner does not require an Employee record.
- No Membership model is introduced.
- Client-supplied actor, Organization, Branch, role, or capability values are never trusted as authority.
- Cross-context access uses published Application contracts.
- Layered DDD and Packwerk boundaries remain mandatory.
- Pundit remains a thin HTTP adapter.
- Initial POS Payment exposure remains exact-balance cash only.
- Existing bank-transfer implementation remains unexposed in the initial POS.
- Organization-Level Audit Foundation remains an independent and separately gated workstream.
- `development` remains the default integration branch; feature branches target `development`, not `main`.

## 4. Gate and acceptance status

| Area | Status |
|---|---|
| POS Milestone 2A Gate A | `APPROVED` |
| POS Milestone 2A Gate B | `NOT_AUTHORIZED` |
| Control Acceptance | `NOT_STARTED` |
| Operational Acceptance | `NOT_STARTED` |
| Implementation | `NOT_STARTED` |

Gate A approval establishes the design baseline. It does not authorize source, schema, migration, package, endpoint, audit-producer, dependency, or runtime changes.

No Gate B package is approved by this record. Preparation of that package requires a separate explicit Owner request.
