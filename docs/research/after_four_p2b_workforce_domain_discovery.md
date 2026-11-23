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
| `P2B-WF-OD-06A` | Workforce | What break entitlement and recording policy applies? | Obtain qualified employment/legal input; separately approve entitlement, timing, evidence, missed/interrupted-break treatment, and accountable correction. | Informal breaks are flexible but weaken time/payroll evidence. |
| `P2B-WF-OD-06B` | Workforce | Are grace periods allowed, and for which attendance events? | Keep disabled until purpose, duration, scope, and consequences are approved with qualified employment/legal input. | Grace reduces operational noise but can obscure actual attendance facts. |
| `P2B-WF-OD-06C` | Workforce | What time-rounding policy, if any, applies? | Preserve raw attendance facts and obtain qualified employment/legal input before approving any calculation rule. | Rounding simplifies calculation but can create systematic wage/time distortion. |
| `P2B-WF-OD-06D` | Workforce | How are lateness and its consequences classified? | Separately approve thresholds, excused outcomes, evidence, review, and payroll/reporting consequences. | One automatic threshold is simple but may ignore legitimate exceptions. |
| `P2B-WF-OD-06E` | Workforce | How are absence and its consequences classified? | Separately approve absence categories, evidence, review, correction, and payroll/reporting consequences. | Treating every missed Shift identically can misclassify leave or operational exceptions. |
| `P2B-WF-OD-07A` | Workforce | What leave categories, entitlement/balance, request/approval, cancellation/correction, evidence, and effective-date policy applies? | Obtain qualified employment/legal input and approve leave policy independently from overtime. | A single generic leave balance is simple but may not reflect different purposes and obligations. |
| `P2B-WF-OD-07B` | Workforce | What overtime eligibility, prior authorization, recording/validation, rate/calculation, exception, and correction policy applies? | Obtain qualified employment/legal and payroll input before approving calculations or enforcement. | Unrestricted overtime is flexible but creates cost, compliance, and evidence risk. |
| `P2B-WF-OD-08A` | Workforce | Which Workforce facts may Cash or other operational domains consume, for which legitimate purposes, scope, accountability, exclusions, and review/audit expectations? | Permit only explicitly approved minimum facts and purposes; exclude inferred capabilities, unrelated employment data, and unrestricted history. | Broad sharing simplifies operations but creates privacy, coupling, and authority leakage. |

`P2B-WF-OD-06`, `P2B-WF-OD-07`, and `P2B-WF-OD-08` are superseded and are not active ballot items. Their replacements remain independently `OWNER_DECISION_REQUIRED`. Each timekeeping/leave/overtime decision requires its own qualified legal/employment-policy review and may depend on Shift, attendance, Payroll, or Reporting facts without transferring accountability.

| Active ref | Existing evidence | Required dependencies and consultation |
|---|---|---|
| `06A` | Attendance must preserve original/corrected facts; no break policy is approved. | Shift and attendance facts; qualified employment/legal and Payroll input. |
| `06B` | Grace remains explicitly open in the Business Domain Model/workshop evidence. | Attendance event definitions; qualified employment/legal and Reporting input. |
| `06C` | Rounding remains explicitly open; raw/corrected attendance provenance is the controlling discovery constraint. | Trusted time facts; qualified employment/legal and Payroll input. |
| `06D` | Lateness consequences are not established by planning assumptions or role names. | Shift expectation, attendance evidence, exception review, qualified employment/legal and Payroll/Reporting input. |
| `06E` | Absence consequences are not established; leave and missed attendance must not be conflated. | Shift, attendance, leave outcome, qualified employment/legal and Payroll/Reporting input. |
| `07A` | Leave/Overtime input is only a candidate Workforce concept; categories, balances, and workflow are open. | Effective-dated employment/assignment, qualified employment/legal and Payroll input. |
| `07B` | No overtime eligibility, rate, or approval policy is Owner-approved. | Shift/attendance facts, qualified employment/legal, accounting, and Payroll input. |
| `08A` | Workforce may supply accountability context, while Cash/operations retain authority and state. | Privacy/retention, consuming-domain purpose, Identity boundary, and audit review. |

Events, APIs, DTOs, integration contracts, delivery semantics, and adapter placement for `P2B-WF-OD-08A` are a later `TECHNICAL_DESIGN_FOLLOW_UP`, excluded from the Owner policy ballot. The Owner decision covers only permitted facts, purposes, business scope, exclusions, accountability, and review expectations.

## 6. Risks and exit

Identity/P1, Organization ancestry, payroll/legal policy, device/time authority, privacy/retention, and audit are prerequisites. No role, employment policy, schedule mechanism, API, schema, implementation, or Identity Milestone 2B authority is granted.
