# AFTER FOUR — CORE-02 Fresh Review Findings Remediation

**Status:** `AUTHORED_REMEDIATION_COMPLETE — READY_FOR_FRESH_INDEPENDENT_GATE_A_REVIEW — NO_GATE_GRANTED`

**Baseline:** `main` / local `origin/main` at `2df940c935e4618d1dea25837af2c2e60fcad903`

**Historical review evidence:** [CORE-02 Fresh Independent Gate A Design Review](after_four_core_02_fresh_independent_gate_a_review.md), merged by PR #86

**Remediation date:** 2026-11-24 (Asia/Tokyo)

**Gate or implementation authorization created:** `NONE`

## 1. Purpose and disposition

This documentation-only work package addresses the two findings recorded by the historical fresh independent review. It does not alter that review report or turn authored remediation into an independent review result.

| Finding | Review severity | Authored disposition | Independent confirmation |
|---|---|---|---|
| `CORE02-FIR-01` | `BLOCKER` | `REMEDIATED_IN_AUTHORED_LOGICAL_DESIGN` | Required before Owner Gate A presentation. |
| `CORE02-FIR-02` | `MAJOR` | `REMEDIATED_IN_AUTHORED_LOGICAL_DESIGN` | Required before Owner Gate A presentation. |

Readiness after authored remediation is `READY_FOR_FRESH_INDEPENDENT_GATE_A_REVIEW — NO_GATE_GRANTED`. It is not `READY_FOR_OWNER_GATE_A_REVIEW` and grants no Gate A, Gate B or implementation authority.

## 2. `CORE02-FIR-01` — acceptance identity, retry and quarantine

### 2.1 Cause

The acceptance outcome model used stable Dispatch plus acceptance-attempt identity, but later canonical invariants reverted to Dispatch-only idempotency and blanket pending/retryable wording. Candidate Ticket discovery prohibited duplicate creation without explicitly preventing execution before an authoritative accepted binding.

### 2.2 Canonical contract after remediation

- Every acceptance delivery, replay, lookup, reconciliation and recovery is identified by the stable Dispatch identity plus stable acceptance-attempt identity.
- `accepted` and `rejected_terminal` are mutually exclusive immutable terminal outcomes for that attempt.
- `held_unresolved` is non-terminal and fail-closed. Missing, stale, conflicting, ambiguous, mismatched, incomplete or unavailable evidence/result remains held.
- Same-attempt retry means replay or lookup only. It returns the same terminal outcome or held disposition and never creates a new business attempt.
- `rejected_terminal` is not retryable merely because the Dispatch remains pending.
- Timeout, response loss, delivery failure, transport uncertainty or absence of an observed result cannot reject, accept or replace an attempt.
- A new attempt is a separately authorized business action and is allowed only after terminal rejection, preserved rejection evidence, resolution of the rejection basis, revalidation of Order and Dispatch eligibility and issuance of a distinct identity. The prior identity is never reused.
- Held resolution requires corrected authoritative evidence and a separately authorized resolver action for the same Dispatch plus attempt. No automatic resolver authority is created.

### 2.3 Candidate Ticket/Item quarantine

If reconciliation finds a Candidate Ticket or Candidate Ticket Items without an authoritative accepted binding for the exact Dispatch plus attempt:

1. the entire candidate set is quarantined and non-executable;
2. it cannot start, progress, complete or hand over;
3. it is not evidence of acceptance;
4. it and all related conflict evidence are preserved;
5. reconciliation creates no duplicate Ticket or Items and deletes no candidate evidence;
6. release occurs only after corrected authoritative evidence plus separately authorized resolution proves the exact identities and records the accepted binding; and
7. if binding cannot be proved, the set remains quarantined. A terminal rejection preserves the evidence and neither binds nor deletes the candidate.

This separates Ticket-creation prevention, duplicate prevention, candidate discovery, quarantine, authoritative binding and release. Physical uniqueness, persistence, transaction, isolation, locking and concurrency mechanisms remain Gate B concerns.

### 2.4 Before and after

| Before | After |
|---|---|
| Acceptance was described as idempotent by Dispatch identity alone. | Replay/lookup/idempotency use Dispatch plus acceptance-attempt identity. |
| Failure before semantic success generally left the Dispatch pending/retryable. | Behavior depends on the attempt outcome: immutable terminal replay, fail-closed held resolution, or a separately authorized new attempt after terminal rejection. |
| Candidate discovery prevented recreation but did not prohibit execution. | Candidate Ticket/Items are expressly quarantined/non-executable until exact accepted binding is proved. |

## 3. `CORE02-FIR-02` — authoritative customer custody transfer

### 3.1 Cause

The prior command contract had trusted actor, Session, Branch, capability, Ticket, version, completion and audit guards, but it did not distinguish acknowledgement evidence from the business fact that the completed goods were actually released to the customer or customer's recipient.

### 3.2 Distinct logical facts

The remediated design keeps these facts separate:

1. Preparation completion;
2. handover acknowledgement, refusal or disagreement evidence;
3. authoritative customer custody transfer;
4. approval or separately governed resolution authority; and
5. Order closure eligibility.

Acknowledgement records an actor response or observation. It does not prove transfer, grant approval or establish closure eligibility. Invoking a command or confirming that a prompt was read also proves none of those facts.

### 3.3 Custody-transfer evidence contract

The authoritative custody-transfer fact requires trusted evidence that the completed whole Ticket was actually released to the customer or the customer's recipient. At the logical level it binds:

- the exact Order, Ticket and Branch;
- the stable handover command identity;
- the trusted transfer-recording actor and valid authenticated Session evidence;
- the exact operation-specific capability and applicable scope;
- authoritative whole-Ticket completion and applicable expected version evidence;
- authoritative transfer time; and
- trusted evidence of actual release to the customer or customer's recipient.

Missing, expired, stale, conflicting, mismatched, refused, disputed or unverifiable transfer evidence fails closed without custody transfer. Acknowledgement/refusal/disagreement evidence remains preserved for separately governed resolution. A command may record acknowledgement and transfer together only when the evidence and identities for each fact remain independently identifiable.

The design assigns no person or job title and selects no recipient identity scheme, device, signature, API, DTO, database representation or hardware proof mechanism. Those physical choices remain Gate B matters. Identity Milestone 2B remains unauthorized.

### 3.4 Transition and downstream boundaries

- Preparation completion is necessary but does not itself transfer custody.
- Acknowledgement alone never transfers custody.
- Customer custody transfer is not approval.
- Custody transfer does not close a Cash Session, resolve a discrepancy, release reporting, authorize Refund or close an Order by itself.
- `CORE-OD-10C` remains only the bounded closure-eligibility guard; universal `P1A-OD-07` remains deferred and no automatic Order-close command is authorized.

## 4. Canonical sections synchronized

- [Accelerated Core Operations Design Package](after_four_accelerated_core_operations_design_package.md) §§4.2–4.5 and §10 readiness matrix.
- [Accelerated Core Operations Design Remediation](after_four_accelerated_core_operations_design_remediation.md) §§1 and 4 plus readiness checklist.
- [CORE-02 Accelerated Design Remediation](after_four_core_02_accelerated_design_remediation.md) §§4–6 and §§10–12.
- [Accelerated Core Operations Readiness Assessment](after_four_accelerated_core_operations_readiness_assessment.md) CORE-02 flow/readiness and parallel-package matrix.
- [Accelerated Core Operations Next Readiness Sprint](after_four_accelerated_core_operations_next_readiness_sprint.md) CORE-02 result and §§4.1–4.3.

The [historical PR #86 review](after_four_core_02_fresh_independent_gate_a_review.md) is unchanged and continues to document the `NOT_READY_FOR_OWNER_GATE_A_REVIEW` result for its reviewed baseline.

## 5. Gate A and Gate B boundary

This remediation defines logical identities, outcomes, allowed transitions, evidence contracts and fail-closed behavior needed for independent Gate A review. It does not select or guarantee:

- database schema or persistence representation;
- physical atomicity, transaction coordination, isolation or locks;
- uniqueness or concurrency mechanism;
- broker, transport, worker, retry schedule or deployment topology;
- API, DTO, device, signature or recipient-identification mechanism; or
- any capability holder, delegation, emergency authority or resolver.

Those matters require later evidence and, where applicable, separate Owner decisions and Gate B authorization.

## 6. Preserved governance boundaries

- `CORE-OD-08A`–`CORE-OD-08C`, `CORE-OD-09A`–`CORE-OD-09D` and `CORE-OD-10A`–`CORE-OD-10C` are unchanged.
- The consolidated register remains 27 confirmed / seven deferred references.
- Payment settlement remains authoritative; Preparation neither rewrites Payment truth nor independently closes the Order.
- Universal `P1A-OD-07` remains deferred.
- Cancellation is not Refund; exception resolution requires separate authority.
- Handover does not close Cash Session, disposition discrepancy or release reporting.
- Identity Milestone 2B remains unauthorized; ADR-0006 remains Proposed.
- Inventory remains deferred. Manual bank, Refund, Promotions and Loyalty are outside this remediation.
- No canonical `ODB-*` ID or Owner decision is created.

## 7. Remaining assumptions and readiness

No logical ambiguity is intentionally retained for the two findings. Independent review must verify that the synchronized documents consistently implement the stated logical contract. Physical mechanisms, evidence representation, human/capability assignments and resolver workflow remain unresolved by design and do not prevent fresh independent Gate A review because they are explicitly separated into later governance/Gate B concerns.

**Readiness classification:** `READY_FOR_FRESH_INDEPENDENT_GATE_A_REVIEW — NO_GATE_GRANTED`

## 8. Validation record

The final checkpoint validates:

- removal of Dispatch-only acceptance idempotency and blanket pending/retryable wording;
- Dispatch-plus-attempt identity across replay, lookup, reconciliation and new-attempt rules;
- Candidate Ticket/Item quarantine and non-executable behavior before accepted binding;
- separation of acknowledgement from customer custody transfer, approval and Order closure eligibility;
- consistent readiness statements and 27 confirmed / seven deferred references;
- Markdown tables, fences, local links and anchors;
- `git diff --check` and `git show --check`; and
- documentation-only changed paths.

No application tests, builds, services, migrations or database commands are required or authorized for this work package.

**Final status:** `CORE02_FIR_01_REMEDIATED — CORE02_FIR_02_REMEDIATED — FRESH_INDEPENDENT_REVIEW_REQUIRED — NO_GATE_GRANTED — NO_IMPLEMENTATION_AUTHORIZED`
