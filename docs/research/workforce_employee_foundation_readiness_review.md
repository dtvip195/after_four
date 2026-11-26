# AFTER FOUR — Workforce Employee Foundation Readiness Review

**Review date:** 2026-11-26

**Repository baseline:** `development` at `17863521259eab1f5e768cce0b4acec70d707785` (`origin/development` matched)

**Review mode:** Read-only assessment; this report is the only repository change

**Final decision:** `READY_FOR_SCHEMA_APPROVAL`

## 1. Baseline and authority

The working tree was clean before this report was created. The baseline includes PR #132, which records the Owner-confirmed Workforce/Identity/Organization ownership boundary. No Workforce package, Employee table, Employee persistence record, Employee runtime workflow, or Membership implementation exists.

The prior `WORKFORCE_EMPLOYEE_FOUNDATION_DESIGN_COMPLETE` design is available as the review input but was not itself a repository file. This review checks that proposal against the merged canonical architecture and current implementation conventions.

Confirmed boundaries remain unchanged:

- Workforce owns Employee identity, employment facts, and Employee Branch Assignment.
- Identity owns User, authentication, Sessions, Role Assignment, trusted authorization context, and authorization resolution.
- Organization owns Organization, Brand, and Branch.
- User and Employee are independent. Either may exist without the other; an Owner User does not require an Employee record.
- No Membership model or context is permitted.
- This review grants no schema, migration, implementation, runtime, Gate, deployment, or production authority.

## 2. Review findings

### 2.1 Domain correctness

The minimal Employee is coherent as a stable Workforce identity owned by exactly one Organization. It is useful as the future identity anchor for separately approved employment, assignment, and history records without embedding those policies now.

Required Domain state:

| Property | Requirement |
|---|---|
| Employee ID | Required canonical UUID, context-local `EmployeeId`, immutable. |
| Organization reference | Required canonical UUID represented as an opaque Workforce-side reference, immutable. It does not copy Organization data or prove existence by itself. |
| Version | Nonnegative integer concurrency token; new identity begins at zero. It grants no lifecycle meaning. |

No optional business field is justified in this foundation. Persistence timestamps are technical metadata, not Employee Domain properties.

Creation must reject a missing or malformed Employee ID or Organization reference and any initial version other than zero. Reconstitution must reject malformed persisted identifiers, an absent Organization reference, and negative or non-integer versions. It must not normalize or repair invalid persistence data.

Employee ID and Organization ownership have no mutation operation. The Aggregate exposes no status, active-employment predicate, Branch eligibility, User link, authorization fact, or personal profile. The existence of an Employee row therefore proves only stable Employee identity within an Organization; it does not prove current employment, Branch eligibility, or authority.

A single-entity `Employee` Aggregate Root is the smallest useful boundary. A larger Aggregate, Domain Service, shared identifier kernel, or generic employment abstraction is unnecessary.

### 2.2 Persistence and schema readiness

The proposed schema is compatible with current PostgreSQL and Rails conventions:

- PostgreSQL UUID primary keys and `gen_random_uuid()` are already used.
- `organizations.id` is UUID.
- Organization references in current tables use restrictive foreign keys.
- Active Record optimistic locking uses a non-null integer `lock_version` defaulting to zero.
- Rails timestamps map to timestamp-with-time-zone columns in the current structure.
- No `employees` or conflicting legacy table exists.
- A new empty table requires no existing-row backfill and need not alter an existing table.

Although the foundation has no mutable business attribute, retaining `lock_version` is reasonable and consistent with the approved design baseline. It prevents a later mutable slice from retrofitting concurrency metadata after Employee references exist. It must not be presented as employment lifecycle state. No repository update method is needed in the foundation.

The Organization index is required for tenant-scoped lookup and foreign-key operations. PostgreSQL does not automatically create an index on the referencing column. No additional uniqueness constraint is justified: the UUID primary key is unique, and Employee Code semantics remain unresolved. A redundant unique index on `(organization_id, id)` is not recommended unless a later approved composite foreign key demonstrates the need.

`ON DELETE RESTRICT` is required for the Organization FK. It protects Employee ownership but does not decide Employee deletion, archival, or employment termination policy.

### 2.3 Context boundaries

The Employee Domain and Application code must not depend on Rails, Active Record, Devise, Pundit, Identity, or Organization Infrastructure. Workforce may represent Organization identity as an opaque local reference without copying an Organization entity.

`EmployeeRecord` must store the scalar `organization_id` and must not declare an Active Record association to `Organization::Infrastructure::Persistence::OrganizationRecord`. The database FK is permitted physical referential integrity; it is not a Ruby dependency or authorization to access Organization persistence.

For a schema-only foundation, Workforce requires only the root package dependency needed by `ApplicationRecord`. It does not yet require a Packwerk dependency on Organization. If production Employee creation is later authorized, a Workforce-owned Application port may use a Workforce Infrastructure adapter to call a narrow Organization Application query. At that point—and only when real source exists—the Workforce package may declare `app/contexts/organization`.

Workforce must not depend on Identity. A future Identity-to-Workforce Application read dependency belongs to a separate authorization-integration approval.

When the package is implemented, architecture guards should verify:

- Workforce Domain/Application framework independence;
- Workforce references Organization only through `Organization::Application`;
- no `Identity::` reference from Workforce;
- Identity references only `Workforce::Application`, when separately authorized;
- no cross-context Infrastructure, record, or Active Record association;
- no Membership constant, table, migration, or package.

### 2.4 Application surface

The foundation needs no runtime Employee administration use case, controller, job, public API, or composition-root entry point.

A minimal `EmployeeRepository` port may support internal persistence verification with only:

- `add(employee)`;
- `find(organization_reference:, employee_id:)`.

Every lookup is Organization-scoped. Wrong-Organization and absent-Employee outcomes must be indistinguishable. No unscoped find, list, search, update, delete, archive, User link, status, or assignment operation belongs in this slice.

The repository is not a grant of Employee creation authority. It must remain unreachable from production Presentation or scheduled work until a separately approved, audited Application use case exists.

### 2.5 Audit and production-write safety

The current `audit_events` table requires `branch_id` and has no Organization scope. It cannot faithfully represent an Organization-scoped Employee creation event. A fabricated Branch would create false audit evidence and is prohibited.

Consequently:

- a separately authorized schema-only foundation and rollback-isolated persistence tests can proceed without Employee audit rows;
- no production Employee creation or mutation may proceed using the current audit shape;
- any runtime Employee write requires approved creation authority and an Organization-level append-only audit mechanism first;
- this review does not select an audit schema, reader, retention period, export mechanism, redaction rule, legal hold, or database-role model.

## 3. Recommended minimal schema

The exact schema recommended for Owner schema approval is:

| Element | Required definition | Status |
|---|---|---|
| Table | `employees` | `TECHNICAL_RECOMMENDATION` |
| Primary key | `id uuid PRIMARY KEY DEFAULT gen_random_uuid()` | Required |
| Organization ownership | `organization_id uuid NOT NULL` | Required |
| Foreign key | `employees.organization_id → organizations.id ON DELETE RESTRICT`, explicitly named | Required |
| Organization index | Non-unique index on `organization_id`, explicitly named | Required |
| Optimistic lock | `lock_version integer NOT NULL DEFAULT 0` | Required by design baseline |
| Lock check | `lock_version >= 0`, explicitly named | Required |
| Technical timestamps | `created_at` and `updated_at`, non-null Rails timestamps | Required by repository convention |

No other column, index, association, trigger, or constraint is approved by this recommendation.

Explicitly deferred:

- Employee Code and its normalization/uniqueness/history;
- User linkage;
- employment status, dates, Employment Period, rehire, suspension, termination, and archival;
- Branch Assignment;
- Role or capability data;
- personal, contact, payroll, or legal identity data;
- business-key uniqueness;
- Employee deletion behavior;
- runtime audit and production database-role separation.

## 4. Minimum test plan

| Layer | Minimum evidence required |
|---|---|
| Pure Domain | Valid creation; invalid/missing Employee UUID; invalid/missing Organization reference; creation version fixed at zero; valid reconstitution; negative/non-integer version rejected; ID and Organization immutable; no Rails or persistence dependency. |
| Mapper | Exact record-to-Aggregate and Aggregate-to-new-record mapping; malformed persisted UUID/version rejected rather than normalized; persistence timestamps do not become business state. |
| Repository | Add and Organization-scoped retrieval; wrong Organization returns the same absence result as unknown Employee; duplicate UUID fails; no unscoped retrieval; mapper failure produces no partial write. |
| PostgreSQL | UUID default and PK; Organization FK with unknown Organization rejection; `ON DELETE RESTRICT`; Organization index; lock-version default/check; transaction rollback; schema load from the canonical structure. |
| Isolation | Two Organizations cannot retrieve each other's Employee through the repository contract, even when an Employee UUID is known. |
| Concurrency | Verify the persistence lock-version mechanism and stale-write rejection. Because no business mutation is authorized, do not invent a mutable Employee command merely to exercise it; full mutation-level concurrency evidence belongs to the first approved mutable slice. |
| Architecture | No Rails/Active Record in Domain/Application; no Workforce-to-Identity dependency; no cross-context Infrastructure/records; Organization Application-only rule when applicable; strict Packwerk package; no Membership; no production composition wiring. |
| Migration accounting | Fresh PostgreSQL 18.7 migration and structure load; exact schema diff contains only `employees` and its approved controls; no existing table/data changes. |

Pure Domain/Application specs use `spec_helper`. Persistence, migration, FK, isolation, and optimistic-lock tests use `rails_helper` with real PostgreSQL 18.7. Mock persistence cannot establish schema correctness.

## 5. Prerequisites and blockers

No unresolved business decision blocks approval of the exact minimal schema above. The excluded decisions are not needed to represent stable Employee identity.

The following are hard gates for later work, not reasons to enlarge the foundation schema:

| Gate | Concrete issue | Minimum resolution | Owner |
|---|---|---|---|
| Schema implementation authorization | The current Owner approval explicitly authorizes architecture only. | Explicitly authorize the exact table, columns, constraints, index, migration, package, Domain, mapper, record, repository, and tests. | Owner |
| Production Employee creation | Initiator, approver, evidence, idempotency, duplicate handling, and visibility are unresolved. | Owner-approved creation policy and bounded Application-use-case scope. | Owner; technical design after policy |
| Organization-level audit | Existing audit requires Branch and cannot record Organization-only Employee events. | Approve an Organization-scoped append-only audit design before any runtime Employee write. | Owner plus security/privacy/legal input where applicable |
| Production database writes | Database-role separation and runtime write path remain unapproved. | Separately approve the runtime principal, grants, operational evidence, and production use. | Owner; security/database review |

Employee Code, lifecycle, User linkage, personal data, Branch Assignment, read/search permissions, deletion/archive behavior, and audit retention/export/legal-hold policy remain `OWNER_DECISION_REQUIRED` or `DEFERRED`. None should be pulled into the foundation migration.

## 6. Final readiness decision

`READY_FOR_SCHEMA_APPROVAL`

The minimal Employee identity and exact physical shape are sufficiently specified for the Owner to approve or reject a bounded schema-only implementation slice. After explicit authorization, that slice can add the Workforce package, pure Employee Domain, Employee persistence mapping/repository, the exact `employees` table, and internal tests without exposing a production write path.

This decision is not implementation authorization. Production Employee creation remains blocked until creation authority and Organization-level append-only audit are separately approved.

No existing source, test, documentation, configuration, dependency, schema, migration, API, database state, or Git state was modified. This report is the only file created by the review.
