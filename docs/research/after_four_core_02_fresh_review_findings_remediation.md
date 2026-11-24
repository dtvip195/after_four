# AFTER FOUR — CORE-02 Fresh Review Findings Remediation

**Current status:** `CUSTODY_TRANSFER_CONTRACT_EXPLICIT — OWNER_QUALIFIED_INPUT_BLOCKED — NOT_READY_FOR_OWNER_GATE_A_REVIEW`

**Baseline:** `main` / local `origin/main` at `2df940c935e4618d1dea25837af2c2e60fcad903`

**Historical review evidence:** [CORE-02 Fresh Independent Gate A Design Review](after_four_core_02_fresh_independent_gate_a_review.md), merged by PR #86

**Remediation date:** 2026-11-24 (Asia/Tokyo)

**Gate or implementation authorization created:** `NONE`

## 1. Purpose and disposition

This documentation-only work package addresses the two findings recorded by the historical fresh independent review. It does not alter that review report or turn authored remediation into an independent review result.

| Finding | Review severity | Authored disposition | Independent confirmation |
|---|---|---|---|
| `CORE02-FIR-01` | `BLOCKER` | `REMEDIATED_IN_AUTHORED_LOGICAL_DESIGN` | Required before Owner Gate A presentation. |
| `CORE02-FIR-02` | `MAJOR` | `LOGICAL_CONTRACT_EXPLICIT — OWNER_QUALIFIED_INPUT_BLOCKED` | Acceptable evidence classes, attester policy and recipient-linkage validation must be resolved before independent Gate A review. |

Authored remediation does not constitute independent review. The acceptance/retry blocker is remediated, but the custody-transfer evidence contract exposes unresolved Owner/qualified inputs that materially prevent a coherent Gate A baseline. Current readiness is `NOT_READY_FOR_OWNER_GATE_A_REVIEW`; no Gate A, Gate B or implementation authority is granted.

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

The authoritative custody-transfer fact may be accepted only from evidence that positively establishes that the completed whole Ticket was actually released to the intended customer or the customer's recipient. At the logical level sufficient evidence must:

- contain an explicit actual-release assertion distinguishable from acknowledgement, command invocation, transport success or mere participation;
- come from an approved trusted-source class and be attributable to an accountable attester;
- bind the exact Order, Ticket, Branch and stable handover-command identity;
- establish authoritative event time, authoritative whole-Ticket completion and applicable expected version evidence;
- provide a verifiable logical relationship between the intended customer/recipient context and the receiving person or party; and
- expose the assertion, attribution, bindings, completion/version evidence and recipient linkage for independent examination against the approved acceptance criteria.

Preparation completion; acknowledgement that a prompt was read; command invocation or successful transport; actor identity, Session, capability or timestamp without actual-release evidence; generic acknowledgement; absence of refusal/dispute; and unverified, conflicting or mismatched recipient/release assertions are insufficient alone. An authenticated actor's assertion is not automatically sufficient.

Negative and uncertain outcomes remain distinct and fail closed:

| Evidence outcome | Required logical result |
|---|---|
| Customer or recipient refuses | Preserve refusal evidence; record no custody transfer; block closure eligibility. |
| Actor or recipient disputes the release | Preserve dispute evidence; record no custody transfer; block closure eligibility. |
| Intended-recipient linkage cannot be verified | Preserve recipient-unverified evidence; record no custody transfer; block closure eligibility. |
| Actual release cannot be verified | Preserve release-unverified evidence; record no custody transfer; block closure eligibility. |
| Evidence is missing, stale, conflicting, mismatched or unavailable | Preserve the corresponding evidence state; record no custody transfer; block closure eligibility. |
| Evidence is received but fails an approved acceptance criterion | Preserve the criteria-insufficient result and supplied evidence; record no custody transfer; block closure eligibility. |

An exact replay returns the same evidence outcome and cannot silently upgrade it. Acknowledgement/refusal/disagreement evidence remains independently identifiable and preserved for separately governed resolution. A command may record acknowledgement and transfer together only when the evidence and identities for each fact are independently identifiable and the actual-release evidence satisfies every approved criterion.

The design assigns no person or job title and selects no recipient identity scheme, device, signature, OTP, QR code, photograph, GPS, witness count, API, DTO, database representation or hardware proof mechanism. Those physical choices remain Gate B matters. Identity Milestone 2B remains unauthorized.

Current Owner decisions establish the explicit post-completion event and closure guard, but do not establish acceptable trusted-source/evidence classes, who may attest actual release or how recipient linkage must be validated. Those three matters are explicit Owner/qualified-input blockers and are not presented as settled policy.

### 3.4 Transition and downstream boundaries

- Preparation completion is necessary but does not itself transfer custody.
- Acknowledgement alone never transfers custody.
- Customer custody transfer is not approval.
- Custody transfer does not close a Cash Session, resolve a discrepancy, release reporting, authorize Refund or close an Order by itself.
- `CORE-OD-10C` requires all four conditions: settled Payment, completed Preparation, authoritative customer custody-transfer evidence and no open exception.
- Preparation completion, acknowledgement, refusal, disagreement, missing evidence and disputed or unverifiable recipient/release evidence do not satisfy the transfer condition.
- Even valid custody transfer only satisfies one guard; Ordering owns the separate closure decision. Universal `P1A-OD-07` remains deferred and no automatic Order-close command is authorized.

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

The logical distinction and fail-closed outcomes are explicit, but acceptable actual-release evidence classes, attester policy and recipient-linkage validation remain unresolved. They determine whether evidence satisfies the business acceptance contract and therefore materially block a coherent Gate A baseline. Physical mechanisms, evidence representation, human/capability assignments and resolver workflow also remain unselected and separately governed.

**Readiness classification:** `NOT_READY_FOR_OWNER_GATE_A_REVIEW`

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

**Final status:** `CORE02_FIR_01_REMEDIATED — CUSTODY_TRANSFER_CONTRACT_EXPLICIT — OWNER_QUALIFIED_INPUT_BLOCKED — NOT_READY_FOR_OWNER_GATE_A_REVIEW — NO_GATE_GRANTED — NO_IMPLEMENTATION_AUTHORIZED`
