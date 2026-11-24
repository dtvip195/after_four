# AFTER FOUR — CORE-02 Blocker Closure — Sprint 3

**Assessment date:** 2026-11-24

**Verified baseline:** `main` at `0423cf3c2f38871f105a82fdce04bfbb7383713b`

**Status:** `NOT_READY_FOR_OWNER_GATE_A_REVIEW — OWNER_QUALIFIED_INPUT_REQUIRED`

**Authority:** logical-design analysis and Owner-decision preparation only

## 1. Scope and controlling evidence

This report narrows the remaining Sprint 2 ambiguity without reopening the accepted Dispatch, acceptance, Ticket quarantine, cancellation or ADR-0011 contracts. Controlling sources are the [Owner Decision Baseline](../architecture/after_four_owner_decision_baseline.md), [Core Operations Design Package §4](after_four_accelerated_core_operations_design_package.md), [CORE-02 Accelerated Design Remediation](after_four_core_02_accelerated_design_remediation.md), [Fresh Review Findings Remediation](after_four_core_02_fresh_review_findings_remediation.md), and [Fresh Independent Gate A Review 2](after_four_core_02_fresh_independent_gate_a_review_2.md).

The current design already establishes two independent axes. Handover acknowledgement may be `acknowledged`, `refused` or `disputed`. Customer custody-transfer evidence may establish `transferred` or remain `transfer_evidence_unresolved`; absence means no transfer fact has been established. Only authoritative `transferred` evidence can satisfy the handover condition in `CORE-OD-10C`.

## 2. Exact unresolved semantic question

The state tables show `absent → transferred` and `absent → transfer_evidence_unresolved`, while the prose allows later new authoritative evidence to establish transfer. The missing policy is:

> When sufficient authoritative actual-release evidence arrives after `transfer_evidence_unresolved`, must it resolve the same stable handover attempt, or may transfer be established only through a separately authorized new handover attempt?

This is not a replay question. Exact replay must always return the same previously recorded evidence result. The question concerns a later, independently identifiable evidence submission or resolution action. Because the choice controls the business identity and audit meaning of a handover attempt, it requires explicit Owner confirmation; it is not safe to infer from a persistence or retry mechanism.

## 3. Logical model comparison

| Dimension | Model A — nonterminal unresolved disposition on the same attempt | Model B — terminally unresolved attempt; separately authorized new attempt |
|---|---|---|
| Attempt identity/lifecycle | One stable handover-attempt identity remains open while unresolved and may later record one authoritative `transferred` outcome. | The first attempt closes as terminally unresolved. A later transfer requires a new attempt identity. |
| Evidence identity/revision | Every observation has its own immutable evidence identity/revision under the same attempt. New evidence advances the current disposition without rewriting prior observations. | Evidence remains immutable under the closed attempt. Later evidence belongs to the new attempt and cross-references the closed attempt. |
| Idempotency/replay | Replay of an existing command/evidence identity returns its recorded result. A distinct authorized evidence submission or resolution action is required to evaluate new evidence. | Replay returns the terminal unresolved outcome. Only the separately authorized new-attempt command can create another identity. |
| Delayed evidence | May be attached to the same attempt if its bindings, provenance, event time and version context prove it concerns that actual release. | Cannot change the closed attempt; it may become evidence for a new attempt or reconciliation case only under separately authorized policy. |
| Duplicate evidence | Same identity returns the prior result; semantically duplicate evidence adds no new transfer fact. | Same identity returns the prior result; duplication cannot open a new attempt. |
| Conflicting or stale evidence | Attempt remains unresolved; preserve all evidence and conflict. No transfer fact. | Closed attempt and evidence remain preserved; a new attempt must not bypass the unresolved conflict. |
| Refusal/disagreement | Independent acknowledgement-axis evidence; not universally terminal. Same attempt remains unresolved unless an authorized policy makes the event terminal. | Does not automatically authorize a new attempt. The policy must state whether it terminally closes that attempt and what permits a later attempt. |
| Recipient verification | Required before `transferred`; exact validation policy remains an Owner/qualified-input blocker. | Same requirement applies to any new attempt; a new identity does not cure missing recipient linkage. |
| Actor/attester authority | The later evidence submission and resolution action require approved authority; current decisions identify no holder. | Closing the first attempt and issuing the new attempt each require explicitly approved authority; current decisions identify no holder. |
| Audit/supersession | Append-only observations show unresolved disposition followed by authoritative resolution on the same attempt. Nothing is erased. | Append-only chain shows terminal unresolved attempt, authorization for supersession, and a distinct new attempt. Nothing is erased. |
| Concurrent observations | Serialize only at the logical outcome boundary: conflicting observations keep the attempt unresolved; exactly one transfer fact may be established. Physical enforcement is Gate B. | Competing new-attempt creation or observations fail closed; the active-attempt and supersession rule must prevent contradictory transfer facts. Physical enforcement is Gate B. |
| Order closure guard | Fails until the same attempt establishes authoritative `transferred`. | Fails until an authorized new attempt establishes authoritative `transferred`. |
| Recovery/reconciliation | Reconcile by stable attempt plus evidence identities and revisions; resolution may remain on the original attempt. | Reconcile the closed attempt separately and prove authorization/binding for the new attempt. |
| Main benefit | Preserves one business attempt for one actual release and supports delayed proof without inventing a second handover. | Strong terminal boundary where unresolved evidence itself is treated as a completed failed attempt. |
| Main trade-off | Requires precise separation between replay and a new evidence revision/resolution action. | Adds supersession/new-attempt authority and risks representing one actual release as multiple business attempts. |

## 4. Common safe invariants

Both models must preserve all of the following:

1. Acknowledgement, refusal or disagreement never becomes custody transfer through replay.
2. Command invocation, authentication, authorization metadata or transport success creates no transfer fact.
3. Only sufficient authoritative actual-release evidence may establish `transferred`.
4. Evidence retains immutable identity, provenance, authoritative time, exact Order/Ticket/Branch/handover-attempt bindings, completion/version context and recipient-linkage context.
5. New evidence is appended and independently identifiable; it never overwrites or erases earlier evidence or its disposition.
6. Duplicate evidence returns the existing result. Conflicting, stale, mismatched, unavailable or unverifiable evidence remains fail-closed.
7. At most one authoritative custody-transfer fact may govern the bounded whole-Ticket handover. Contradictory observations cannot silently advance it.
8. `CORE-OD-10C` remains unsatisfied without authoritative `transferred` evidence. A valid transfer fact still does not close the Order; Ordering owns the separate closure decision.
9. Refusal/disagreement is not universally terminal unless an authorized policy explicitly makes it terminal for the identified attempt.
10. Neither model selects evidence classes, an attester, recipient identity/linkage mechanism, database transaction, lock, uniqueness constraint, storage shape or concurrency mechanism.

## 5. Recommended bounded direction

**Recommendation:** Model A — treat `transfer_evidence_unresolved` as a fail-closed, nonterminal disposition of one stable handover attempt.

The repository consistently treats uncertainty as fail-closed rather than as an invented terminal business outcome. The existing remediation also states that new authoritative actual-release evidence is required before `transferred` may be recorded and that refusal/dispute is not permanently terminal for every future attempt. Model A therefore introduces fewer unsupported business events: one actual release remains one handover attempt, while immutable evidence revisions preserve the unresolved history.

This recommendation is `PROPOSED_NOT_APPROVED`. Owner confirmation remains required because it determines whether later evidence resolves the same business attempt. Until confirmed, the current state stays unresolved and cannot satisfy closure.

Under Model A, `transfer_evidence_unresolved` may remain nonterminal on the same stable attempt only while valid evidence is missing, incomplete, being obtained or being verified. That progression does not permit later evidence to override a conflict, dispute or challenged prior assertion. Conflicting or disputed custody evidence keeps the attempt held and fail-closed until the conflict is resolved through a separately authorized disposition under policy that remains unresolved. Later evidence is retained and may be evaluated, but it cannot silently supersede, erase or upgrade any conflicting evidence. Recording `transferred` requires both the approved actual-release evidence criteria and authorized resolution of every conflict or dispute. Evidence identities, provenance, revisions, actors, authoritative times and prior outcomes remain auditable. Replay, acknowledgement, transport results and repeated commands resolve no conflict, and no new attempt may be created silently to bypass unresolved evidence. This clarification selects neither a resolver nor Model A itself.

### 5.1 Exact Owner question

Choose one:

- **Option A — same-attempt resolution (recommended):** `transfer_evidence_unresolved` is nonterminal. A separately authorized resolution/evidence-submission action may evaluate new authoritative evidence under the same stable handover-attempt identity and record `transferred` exactly once. Replay alone cannot advance it.
- **Option B — terminal unresolved plus new attempt:** the unresolved attempt is immutable and terminal. A distinct attempt may be issued only through a separately authorized business action that preserves and cross-references the prior attempt, proves the prior basis has been handled, revalidates eligibility, and uses a new identity.
- **Defer:** retain `transfer_evidence_unresolved`, permit no transfer progression, and keep Order closure eligibility blocked.

The choice authorizes only the logical lifecycle direction. It does not approve trusted evidence classes, attester authority, recipient-linkage validation, resolver assignment, Identity implementation or a physical mechanism.

### 5.2 Design that may proceed before the choice

The common invariants, immutable evidence-envelope requirements, exact business bindings, replay-versus-new-evidence distinction, fail-closed conflict behavior and `CORE-OD-10C` guard can remain in the logical baseline. The selected transition, attempt terminality and authorization for resolution/new-attempt issuance cannot be finalized before Owner input.

## 6. Sprint 2 finding disposition

| Finding | Sprint 3 disposition | Remaining closure condition |
|---|---|---|
| `CORE02-FIR2-01` — custody-transfer acceptance policy | `UNRESOLVED — BLOCKER` | Owner/qualified input must approve trusted evidence classes, actual-release attester authority and intended-recipient-to-receiver linkage validation. No class, role or mechanism is inferred here. |
| `CORE02-FIR2-02` — unresolved-to-transferred transition and attempt identity | `PARTIALLY_CLOSED — OWNER_DECISION_REQUIRED` | Both models, common invariants and a bounded recommendation are explicit. Owner must select same-attempt resolution, terminal-new-attempt semantics or deferral before the transition contract can be finalized. |

Dispatch acceptance/retry/quarantine, exception/cancellation and ADR-0011 findings remain closed at the logical-review level; this sprint found no contradictory evidence requiring them to be reopened. Physical atomicity and concurrency proof remain Gate B concerns.

## 7. Future independent-review checklist

A reviewer who did not author the remediation must verify:

- the selected model is recorded as an explicit Owner decision and is represented consistently in every CORE-02 state table and protocol;
- handover-attempt, command, evidence identity and evidence-revision semantics are unambiguous;
- exact replay cannot advance an unresolved disposition, while any permitted new evidence is independently identifiable and append-only;
- delayed, duplicate, stale, conflicting and concurrent evidence remains fail-closed unless the approved contract is satisfied;
- refusal/disagreement terminality is not inferred beyond the selected policy;
- the three `CORE02-FIR2-01` policy inputs are actually closed with authoritative evidence;
- acknowledgement and customer custody transfer remain independent axes;
- only `transferred` satisfies the handover guard in `CORE-OD-10C`, and transfer does not itself close the Order;
- no physical transaction, lock, persistence, transport, retry or Identity implementation choice has leaked into Gate A design; and
- the 27 confirmed / 7 deferred Core Operations references and every existing authorization boundary remain unchanged.

## 8. Readiness conclusion

**Outcome:** `NOT_READY_FOR_OWNER_GATE_A_REVIEW`.

`CORE02-FIR2-02` is now decision-ready but not decided. `CORE02-FIR2-01` remains a material policy blocker. CORE-02 may return to fresh independent review only after the Owner/qualified inputs close all three custody-transfer acceptance questions, the Owner selects the unresolved-attempt model, the logical design is synchronized, and the resulting evidence is independently verifiable.
