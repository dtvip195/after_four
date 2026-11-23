# AFTER FOUR — P2B Workforce Domain Discovery Annex

**Workstream:** `P2B-Workforce`

**Status:** `DISCOVERY_PREPARED — OWNER_REVIEW_REQUIRED`

**Authority:** `NW-OR-01` — discovery only

**Implementation authorization:** `NOT_GRANTED`

**Date:** 2026-11-23

## 1. Purpose and ownership

Workforce owns Employee employment identity, Branch Assignment, work duties, scheduling, attendance, timekeeping, leave/overtime input, and work-history provenance. Identity owns User authentication and authorization grants. Organization owns Organization/Brand/Branch reference facts. Cash owns drawer Sessions; a work Shift does not confer Cash authority.

## 2. Existing evidence and policy

| Evidence | Classification | Consequence |
|---|---|---|
| [Glossary](../../GLOSSARY.md) | Canonical vocabulary | Employee is not User; Branch Assignment is not Role Assignment; Staff is an authorization role while cashier/barista/server/cleaning are duties/capabilities. |
| `ODB-PLN-04/06` | Owner-confirmed planning | Initial four Employees and two-to-three shifts are assumptions, not limits or schedule policy. |
| [Business Domain Model §6](../architecture/after_four_business_domain_model.md#6-workforce-and-payroll) | Mixed | Employee/shift/attendance/payroll directions exist; much remains workshop/legal validation. |
| Existing Identity decisions | Owner-confirmed boundaries | Employment, login, Branch assignment, and authorization must remain distinct; Milestone 2B remains unauthorized. |

## 3. Concepts and responsibilities

| Concept | Owner | Meaning / open boundary |
|---|---|---|
| Employee | Workforce | Employment identity and history; may exist without User access. Employment states and rehire policy need review. |
| Branch Assignment | Workforce/Organization contract | Effective-dated eligibility to work at a Branch; does not grant capabilities. Temporary/multi-Branch rules remain open. |
| Shift Plan | Workforce | Scheduled interval, Branch, Employee, and duties. Publication/change/cancellation rules remain open. |
| Duty Assignment | Workforce | Operational work responsibility; never an Identity role by itself. |
| Attendance Record | Workforce | Actual clock-in/out and correction history. Time authority/device policy remains open. |
| Leave/Overtime Input | Workforce | Approved work-time exception feeding Payroll; detailed policy/legal requirements remain open. |

## 4. Operational discovery

- Scheduling must validate employment/Branch eligibility without turning Branch Assignment into authorization.
- Attendance preserves original and corrected facts; exact clock source, grace, rounding, breaks, and missed-punch handling require policy/legal review.
- Shift swaps require affected Employee consent/acknowledgement and Branch accountability; exact approval remains open.
- Offboarding must preserve Employee history and separately coordinate User access; it must not silently delete records.
- Workforce may provide accountable actor/shift context to Cash and operations, but those domains retain operation authority and business state.

## 5. Candidate Owner decisions

Every row below is `OWNER_DECISION_REQUIRED` and `PROPOSED_NOT_APPROVED`. A later selection would decide only the stated Workforce policy; it would not authorize Identity work, schema, API, timekeeping devices, code, tests, deployment, FOA, or production use.

| Ref | Owner | Question | Recommendation | Alternatives / consequence |
|---|---|---|---|---|
| `P2B-WF-OD-01` | Workforce | What Employee lifecycle and rehire semantics apply? | Preserve history with explicit Active/Inactive/Ended meanings; coordinate but do not conflate User access. | Reusing a prior Employee versus new employment episode affects tenure and audit. |
| `P2B-WF-OD-02` | Workforce | Who creates/changes Branch Assignments and what temporary scope is allowed? | Require effective dates, reason, and Organization/Branch-scoped authority. | Informal assignment is flexible but undermines eligibility and payroll provenance. |
| `P2B-WF-OD-03` | Workforce | Who drafts, publishes, changes, and cancels shifts? | Separate draft from publication and preserve post-publication change evidence. | Manager-only is simple; delegated scheduling needs bounded capability. |
| `P2B-WF-OD-04` | Workforce | What shift-swap policy applies? | Require affected Employee acceptance plus authorized Branch decision and audit. | Direct swaps reduce admin but can violate eligibility/accountability. |
| `P2B-WF-OD-05` | Workforce | What clock-in/out authority, device, location, and correction policy applies? | Use trusted time/device evidence and a separate reasoned correction path. | Self-entry is convenient but raises fraud and legal risk. |
| `P2B-WF-OD-06` | Workforce | What breaks, grace, rounding, lateness, and absence rules apply? | Obtain qualified employment/legal input before calculations or enforcement. | Silent defaults risk wage/timekeeping errors. |
| `P2B-WF-OD-07` | Workforce | What leave categories/balances and overtime rules apply? | Preserve confirmed approval roles but separately approve rates, categories, evidence, and exceptions. | One generic policy is simpler but may not satisfy operational/legal needs. |
| `P2B-WF-OD-08` | Workforce | What Workforce facts may Cash and operational domains consume? | Expose only authoritative assignment/shift/attendance facts through explicit contracts; no inferred capabilities. | Direct record access creates cross-context coupling and authority leakage. |

## 6. Risks and exit

Identity/P1, Organization ancestry, payroll/legal policy, device/time authority, privacy/retention, and audit are prerequisites. No role, employment policy, schedule mechanism, API, schema, implementation, or Identity Milestone 2B authority is granted.
