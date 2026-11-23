# AFTER FOUR — P2B Cash Domain Discovery Annex

**Workstream:** `P2B-Cash`

**Status:** `DISCOVERY_PREPARED — OWNER_REVIEW_REQUIRED`

**Authority:** `NW-OR-01` — discovery only

**Implementation authorization:** `NOT_GRANTED`

**Date:** 2026-11-23

## 1. Purpose and ownership

Cash owns physical drawer accountability, Cash Sessions, opening/closing counts, cash movements, float/top-up evidence, handover, discrepancy, and cash reconciliation. Payment owns settlement and Payment Attempts; Ordering owns Orders; Refund owns approved correction outcomes. Cash must not treat bank/electronic settlement, top-ups, or Expenses as revenue.

## 2. Existing Owner policy

The [Owner Decision Baseline §3](../architecture/after_four_owner_decision_baseline.md#3-cash-management-and-expenses) confirms:

- one shared physical drawer is planned and every movement retains an actor;
- one configurable 2,000,000 VND float per Operating Day carries across shifts;
- no automatic reset/top-up; Staff may request and Owner authorizes evidenced top-ups;
- opening sufficiency check, closing count/verification, accountable handover, discrepancy notice, and immutable close evidence;
- no approved discrepancy tolerance or fixed top-up frequency;
- delegated Expense limits and evidence, Owner approval above limits, no self-approval, and no limit evasion by splitting.

All are unimplemented. Operating Day cutoff/timezone, correction flow, escalation timing, and many operation authorities remain unresolved.

## 3. Concepts and lifecycle discovery

| Concept | Meaning | Boundary |
|---|---|---|
| Cash Drawer | Physical cash container; initially one shared drawer. | Future multi-drawer topology is not approved. |
| Operating Day Float | Owner-controlled fund for one Operating Day. | Not a Cash Session opening balance or revenue. |
| Cash Session | Accountable drawer operating period with opening/closing evidence. | Distinct from Employee Shift. |
| Cash Transaction | Immutable inflow/outflow/top-up/adjustment/correction fact. | Distinct from Payment Attempt and Expense. |
| Cash Count | Observed amount at opening, handover, or close. | Does not silently alter expected balance. |
| Cash Discrepancy | Difference requiring reason, notification, and resolution evidence. | No tolerance or automatic acceptance is approved. |

Candidate Session states (`Prepared`, `Open`, `Counting`, `DiscrepancyReview`, `Closed`, `Cancelled`) remain technical/workshop proposals. Closed evidence should not be rewritten; exact correction policy requires Owner review.

## 4. Integration discovery

- A cash Payment requires both Payment-owned settlement evidence and Cash-owned movement evidence; neither substitutes for the other.
- Non-cash Payment never creates a drawer movement merely because it is revenue.
- A cash Refund requires an approved Refund outcome plus a Cash outflow; method substitution is unresolved.
- Shift handover retains prior-session accountability and does not allocate a new float.
- Reporting consumes Cash facts but cannot redefine expected/actual balances or classify top-ups as revenue.

## 5. Candidate Owner decisions

Every row below is `OWNER_DECISION_REQUIRED` and `PROPOSED_NOT_APPROVED`. A later selection would decide only the stated Cash policy; it would not authorize schema, transactions, endpoints, code, tests, runtime grants, deployment, FOA, or production use.

| Ref | Owner | Question | Recommendation | Alternatives / consequence |
|---|---|---|---|---|
| `P2B-CASH-OD-01` | Cash | What defines an Operating Day? | Approve Branch timezone and cutoff before daily float/Expense/reporting execution. | Calendar day is simple but may split overnight operations incorrectly. |
| `P2B-CASH-OD-02` | Cash | Who may open, count, hand over, and close a Cash Session? | Use operation-specific Branch-scoped capabilities with individual actor evidence. | Generic Staff authority is simpler but weakens accountability. |
| `P2B-CASH-OD-03` | Cash | How are discrepancies escalated and resolved? | Require reason and Owner notification for every nonzero discrepancy; separately approve correction authority and evidence. | A tolerance reduces noise but none is currently approved. |
| `P2B-CASH-OD-04` | Cash | What post-close correction actions are permitted? | Use linked correction movements; prohibit changing closed totals. | Reopening simplifies UI but weakens immutable accountability. |
| `P2B-CASH-OD-05` | Cash | How do cash Refunds and alternate-method Refunds affect the drawer? | Follow an approved Payment Refund method/allocation policy; never infer a Cash outflow for a non-cash Refund. | Alternate methods aid recovery but add accounting/fraud risk. |
| `P2B-CASH-OD-06` | Cash | What evidence and approval apply to handover? | Record outgoing/incoming actors, count, variance, reason, and acknowledgement; do not conflate handover with Session close automatically. | One shared Session reduces transitions but blurs individual custody. |
| `P2B-CASH-OD-07` | Cash | Who may execute an Owner-approved top-up and from which sources? | Preserve Owner authorization and require executor/source evidence; approve source classifications separately. | Owner execution only is safer but less operationally flexible. |
| `P2B-CASH-OD-08` | Cash | What reconciliation cadence and closure dependencies apply? | Reconcile each Session and Operating Day before authoritative reporting; define unresolved-case handling explicitly. | Deferred reconciliation speeds close but increases drift risk. |

## 6. Risks and exit

Cash depends on P1A Refund/cancellation policy, trusted authorization, Operating Day, Reporting definitions, and qualified accounting input. This annex neither reopens confirmed amounts/authority nor authorizes endpoints, transactions, schema, implementation, FOA, or production use.
