# AFTER FOUR — CORE-02 Fresh Independent Gate A Design Review

**Review status:** `COMPLETE — NOT_READY_FOR_OWNER_GATE_A_REVIEW`

**Reviewed baseline:** `main` / local `origin/main` at `541cfb677e748f064a24f52a39a6df791f0e4ea4`

**Reviewed remediation commits:** `0eb7d5469d53cdc624eaac24892e6363ab9821d1`, `62f6a9b1c1ea2ec3d1b37e30beeb7c856021f670`, merged by PR #85

**Review date:** 2026-11-24 (Asia/Tokyo)

**Gate or implementation authorization created by this review:** `NONE`

## 1. Executive conclusion

The fresh independent review does not confirm CORE-02 ready for Owner Gate A review. The remediation substantially improves acceptance outcomes, trusted handover guards and ADR-0011 dependency direction, but the canonical design still contains one blocking acceptance contradiction and one major customer-handover ambiguity.

| Prior finding | Independent disposition | Reason |
|---|---|---|
| `CORE02-IR2-01` | `PARTIALLY_RESOLVED` | The new outcome model is coherent in isolation, but stale canonical invariants still use Dispatch-only idempotency and make every pre-success failure generally retryable. |
| `CORE02-IR2-02` | `PARTIALLY_RESOLVED` | Command identity, trusted authorization, version, replay and audit guards are explicit, but the design does not distinguish authoritative customer custody transfer from acknowledgement evidence. |
| `CORE02-IR2-03` | `INDEPENDENTLY_VERIFIED_RESOLVED` | Layer ownership, consumer-owned ports, adapter direction, Presentation delegation, composition wiring and logical-versus-physical boundaries comply with ADR-0011. |

Because `CORE02-FIR-01` is a `BLOCKER`, the final readiness decision is exactly:

`NOT_READY_FOR_OWNER_GATE_A_REVIEW`

This decision is a review result, not a remediation. The canonical design documents are not edited on this branch.

## 2. Repository baseline and review scope

At review start:

- current branch, `main` and local `origin/main` all resolved to `541cfb677e748f064a24f52a39a6df791f0e4ea4`;
- the working tree was clean;
- PR #85 remediation commits were present in `main` history; and
- the fixed review diff was `4c0856b0d9786e7009e9d49ff6889ba006efc474...541cfb677e748f064a24f52a39a6df791f0e4ea4`.

This review covers the bounded logical CORE-02 Preparation design only. It distinguishes current Phase 1 pending Dispatch/Outbox evidence from proposed acceptance, Ticket/Item execution, handover and exception contracts. Repository presence is not implementation authority.

## 3. Sources inspected and evidence limitations

Principal sources inspected:

- `AGENTS.md` and [GLOSSARY](../../GLOSSARY.md);
- [ADR-0011](../architecture/adr/0011-project-wide-layered-ddd.md);
- [Owner Decision Baseline](../architecture/after_four_owner_decision_baseline.md);
- [DDD Foundation](../architecture/after_four_ddd_foundation.md) and [Business Domain Model](../architecture/after_four_business_domain_model.md);
- [Order and Payment Phase 1](../architecture/after_four_order_payment_implementation_phase1.md);
- [Accelerated Core Operations Design Package](after_four_accelerated_core_operations_design_package.md);
- [Accelerated Core Operations Design Remediation](after_four_accelerated_core_operations_design_remediation.md);
- [CORE-02 Accelerated Design Remediation](after_four_core_02_accelerated_design_remediation.md);
- [prior Independent Core Operations Design Review](after_four_core_operations_independent_design_review.md);
- [Next Readiness Sprint](after_four_accelerated_core_operations_next_readiness_sprint.md);
- [Core Operations Readiness Assessment](after_four_accelerated_core_operations_readiness_assessment.md);
- current `PreparationDispatch`, request/retry commands, schema and focused checked-in specs referenced by the controlling documents.

Source inspection confirms the executable repository has pending/dispatched `PreparationDispatch`, pending/published Outbox evidence and request/retry commands, but no implemented acceptance consumer, Preparation Ticket/Item execution or handover command. The logical contracts reviewed here are proposals. Checked-in specs were inspected as evidence references but not executed.

## 4. Standards-axis review

### 4.1 Canonical-contract consistency finding

The repository requires explicit cross-context contracts and ADR-0011 dependency direction. The canonical design's new acceptance table satisfies that direction, but its immediately following invariant list contradicts the table:

- `docs/research/after_four_accelerated_core_operations_design_package.md:332-340` requires stable Dispatch plus acceptance-attempt identity and makes `rejected_terminal` immutable while `held_unresolved` remains fail-closed.
- The same document at lines 349-350 still says acceptance is idempotent “by the existing Dispatch identity” and that any failure before semantic success leaves the Dispatch “pending/retryable.”

This is a hard internal consistency defect rather than a physical implementation concern. It leaves the authoritative logical replay/new-attempt rule ambiguous.

### 4.2 ADR-0011 conformance

No inward dependency violation was found. The Design Package §§4.3-4.4 and CORE-02 remediation §§7.1-7.2 consistently establish:

- framework-independent Preparation Domain invariants;
- Preparation Application-owned use cases and required contracts;
- Infrastructure implementations/adapters behind those contracts;
- Presentation delegation without direct persistence access;
- composition-root wiring; and
- consumer-owned ports calling published Ordering, Payment and Identity Application contracts without direct Infrastructure-record access.

The phrase “logical business consistency boundary” expressly disclaims physical database transaction guarantees. Physical atomicity, isolation, locking, uniqueness, persistence and concurrency remain Gate B matters.

Duplicated contract summaries across the design package, remediation and readiness documents resemble documentation duplication, but here they serve the repository's synchronization/governance convention and are not independently a standards violation.

## 5. Spec-axis review of `CORE02-IR2-01`

### 5.1 Independently verified strengths

The design now explicitly separates Dispatch business state, Outbox delivery, acceptance attempt, Ticket, Ticket Item, handover and exception axes. It defines `accepted` and `rejected_terminal` as mutually exclusive immutable terminal outcomes and `held_unresolved` as non-terminal and fail-closed. It also states:

- stable Dispatch and attempt identities;
- no Ticket creation from held or rejected disposition;
- same-result replay and lost-response lookup;
- no replacement attempt due to timeout or transport uncertainty;
- separately authorized held resolution with corrected evidence;
- preserved rejection evidence and a new identity for any authorized new attempt;
- trusted pending Dispatch, Order/sold Items, settled Payment, Branch, versions and no-blocking-exception evidence; and
- delivery acknowledgement, Outbox publication, timeout and caller assertions are not acceptance evidence.

Evidence: Design Package lines 322-342 and CORE-02 remediation §§4-5.

### 5.2 Remaining blocker — `CORE02-FIR-01`

**Severity:** `BLOCKER`

**Evidence:**

- Design Package lines 332-340 define attempt-scoped terminal/held outcomes.
- Design Package lines 349-350 revert to Dispatch-only idempotency and blanket pending/retryable behavior.
- Earlier Design Remediation lines 188-190 likewise describes concurrent delivery by Dispatch identity and every pre-success failure as pending/retryable without excluding `rejected_terminal` or unresolved held cases.
- CORE-02 remediation §12 claims state terminology is consistent, which the conflicting canonical statements do not support.

**Affected invariant:** Same-attempt replay must be distinct from a separately authorized new business attempt. A terminally rejected attempt cannot become retryable merely because the Dispatch remains pending, and held evidence cannot silently advance.

The candidate-Ticket recovery text also says reconciliation may locate a Ticket without proven acceptance, but does not explicitly state that this Ticket and its Items are non-executable while the attempt is held. “Creates nothing” and “never recreates” prevent duplication, but do not fully prohibit start/complete/handover from acting on the located candidate before the exact accepted binding is proven.

**Required correction:**

1. Make every acceptance idempotency, replay and lookup rule use the stable Dispatch plus acceptance-attempt identity.
2. Replace blanket “failure before success is pending/retryable” wording with outcome-specific behavior:
   - same-attempt replay/lookup for existing terminal or held results;
   - no same-attempt retry from `rejected_terminal`;
   - held resolution only through corrected evidence and separately authorized action; and
   - separately authorized new attempt with new identity only under the already documented conditions.
3. State that a candidate Ticket/Item set found while acceptance is held is quarantined/non-executable and cannot start, complete or hand over until authoritative evidence binds that exact set to `accepted`.

**Governance stage:** Logical Gate A design. This is not deferred to Gate B because the allowed transitions and retry authority are themselves ambiguous.

**Prior-finding disposition:** `CORE02-IR2-01 — PARTIALLY_RESOLVED`.

## 6. Spec-axis review of `CORE02-IR2-02`

### 6.1 Independently verified strengths

The named handover command is separate from completion and requires trusted actor, authenticated Session evidence, exact Branch, operation-specific handover capability, Ticket identity, expected version, authoritative whole-Ticket completion, no prior handover and stable command identity. Missing, stale, expired, conflicting or mismatched evidence fails closed. Audit evidence and exact replay/conflicting replay behavior are explicit. No holder, delegation, emergency authority or Identity Milestone 2B implementation is inferred.

Evidence: Design Package lines 354-356 and CORE-02 remediation §§6.1-6.2.

### 6.2 Remaining major ambiguity — `CORE02-FIR-02`

**Severity:** `MAJOR`

**Evidence:**

- `CORE-OD-10B` defines customer handover as an explicit post-completion event (Design Package lines 397 and 569; Owner Decision Baseline line 344).
- The handover command records actor, Session, Branch, Ticket, command, time, optional reason and versions (Design Package lines 354-356; remediation lines 99-116).
- The documents say “handover acknowledgement is not approval,” but do not define whether the command proves actual customer custody transfer, records acknowledgement evidence only, or combines both.

**Affected invariant:** Preparation completion, acknowledgement, approval and actual customer custody transfer must not collapse into one another. A command must not make the Order appear handed over merely because an actor acknowledged a prompt or invoked the command without trusted evidence of actual transfer.

**Required correction:** Define the authoritative customer custody-transfer fact and its minimum trusted evidence at the logical level. State whether the handover command records that transfer or only acknowledgement; if both exist, keep their identities and transitions distinct. Acknowledgement alone must not create custody transfer, approval or downstream closure eligibility. Exact persistence/evidence representation remains Gate B.

**Governance stage:** Logical Gate A design. No human assignment or new Owner policy is required to state the distinction.

**Prior-finding disposition:** `CORE02-IR2-02 — PARTIALLY_RESOLVED`.

## 7. Spec-axis review of `CORE02-IR2-03`

**Disposition:** `INDEPENDENTLY_VERIFIED_RESOLVED`

The interaction map identifies contract owner, caller/direction, adapter responsibility and protected invariant/failure for Dispatch acceptance, upstream eligibility evidence, Ticket execution, authorization evidence and handover. Domain/Application do not depend on Active Record, provider SDK, transport or another context's Infrastructure. The composition root only wires implementations.

Application ownership of the logical business consistency outcome does not imply cross-context atomicity or a physical database transaction. The remediation explicitly leaves transaction/isolation, locks, uniqueness, persistence and concurrency to Gate B.

No correction is required for this finding.

## 8. Cross-context and Owner-policy consistency

Except for the two findings above, the review verified:

- `CORE-OD-08A`-`CORE-OD-08C`: Item-level progress, no quantity progress, no partial Ticket completion or handover;
- `CORE-OD-09A`-`CORE-OD-09D`: stage-specific cancellation authority/consequences, no automatic cancellation and no inferred Refund;
- `CORE-OD-10A`-`CORE-OD-10C`: completion, customer handover and bounded closure remain distinct;
- Payment settlement remains authoritative under Preparation failure, hold or rejection;
- Preparation does not rewrite or close the Order automatically; universal `P1A-OD-07` remains deferred;
- exception resolution remains separately authorized;
- Preparation handover does not close Cash Session, disposition discrepancies or release reporting;
- Inventory remains deferred and is not a completion prerequisite;
- manual bank, Refund, Promotions and Loyalty remain excluded or separately governed; and
- ADR-0006 remains Proposed and Identity Milestone 2B remains unauthorized.

No Owner policy, canonical ODB ID or 27-confirmed / seven-deferred consolidated decision reference changed.

## 9. Finding register

| Finding | Severity | Prior finding | Required stage | Readiness effect |
|---|---|---|---|---|
| `CORE02-FIR-01` — attempt identity and retry contradiction | `BLOCKER` | `CORE02-IR2-01` partially resolved | Gate A logical design | Prevents Owner Gate A review readiness. |
| `CORE02-FIR-02` — customer custody transfer versus acknowledgement | `MAJOR` | `CORE02-IR2-02` partially resolved | Gate A logical design | Must be corrected before Gate A approval; review remains not ready because a blocker also exists. |
| No new dependency-direction finding | — | `CORE02-IR2-03` resolved | Gate B mechanisms remain deferred | No negative readiness effect. |

No physical Gate B concern was elevated merely because its mechanism is unselected.

## 10. Gate and authorization boundary

### Gate A design corrections still required

- remove the attempt/retry contradiction and quarantine any candidate Ticket under held acceptance;
- distinguish authoritative customer custody transfer from acknowledgement evidence; and
- obtain a fresh independent re-review after correction.

### Gate B-only concerns

Physical schema, constraints, indexes, transaction/isolation, locking, uniqueness, persistence, broker/worker/transport, retry scheduling, crash recovery, API/DTO/error contracts, exact source manifest, tests and deployment evidence remain unselected and unauthorized.

### Separate authorization

Runtime Identity/capability implementation, capability-holder assignment, held-case resolver authority, Refund execution, universal Order closure, Gate B, Gate C, FOA and Production Authorization remain separate and ungranted.

## 11. Final readiness decision and next action

`NOT_READY_FOR_OWNER_GATE_A_REVIEW`

Rationale: `CORE02-FIR-01` is a material logical contradiction affecting terminality, retry authority and exactly-one-Ticket recovery. Under the review rules, any remaining blocker requires this classification. `CORE02-FIR-02` is also a material Gate A ambiguity.

Next action: correct only the two documented logical gaps in the canonical CORE-02 design, synchronize affected readiness statements, and run another fresh independent review. Do not prepare an Owner Gate A ballot until that re-review confirms closure.

This report grants no Gate, implementation authorization, Identity Milestone 2B authorization, Gate C, FOA or Production Authorization.

## 12. Validation record

- whitespace validation passes;
- Markdown table column counts and fenced-block balance pass;
- every local Markdown link target introduced by this report exists;
- both material findings contain evidence, affected invariant, required correction and governance stage;
- final readiness agrees with the `BLOCKER` finding;
- the canonical consolidated decision register remains 27 confirmed / seven deferred references;
- the change set contains only this independent review report; and
- no application test, build, service or database command was run.
