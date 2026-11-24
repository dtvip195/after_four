# AFTER FOUR — CORE-02 Fresh Independent Gate A Review 2

**Reviewed baseline:** `7bf418159565a24bfe7589230eedb281b3804ccf`

**Review date:** 2026-11-24 (Asia/Tokyo)

**Review outcome:** `NOT_READY_FOR_OWNER_GATE_A_REVIEW`

## 1. Independence and scope

This review was performed by a reviewer who did not author the latest CORE-02 remediation or PR #87 correction. The reviewer examined the complete current logical design and relevant canonical and implementation evidence, not only the latest diff. The primary agent transcribed the independent review into this report without changing its outcome or findings.

No application test, build, service, migration or database command was run. This review grants no Gate, implementation, Identity Milestone 2B, FOA or Production Authorization.

## 2. Verified implementation boundary

Current implementation is narrower than the proposed CORE-02 design:

- `PreparationDispatch` implements only `pending` and `dispatched` ([model](../../backend/app/models/preparation_dispatch.rb)).
- `OutboxEvent` implements only `pending` and `published` ([model](../../backend/app/models/outbox_event.rb)).
- [Phase 1](../architecture/after_four_order_payment_implementation_phase1.md) creates durable pending Dispatch and Outbox facts but has no publisher/consumer, Ticket/Item execution or delivery-attempt writer.
- Existing `Payments::Confirm` directly creates Dispatch/Outbox persistence as legacy Phase 1 behavior. The forward design does not represent it as the future ADR-0011 consumer implementation.

Acceptance, Ticket, Item, exception, acknowledgement and custody-transfer protocols remain logical design proposals.

## 3. Findings

| Finding | Severity | Exact evidence | Assessment | Required action / stage |
|---|---|---|---|---|
| `CORE02-FIR2-01` — custody-transfer acceptance policy is not closed | `BLOCKER` | [CORE-02 remediation §§6.1–6.3](after_four_core_02_accelerated_design_remediation.md); [FIR remediation §§3.3–3.5](after_four_core_02_fresh_review_findings_remediation.md); [Design Package §4.3](after_four_accelerated_core_operations_design_package.md) | Logical evidence properties are explicit, but no Owner-approved trusted evidence classes, authorized attester policy or intended-recipient-to-receiver linkage validation policy exists. These determine whether `transferred` may be recorded and are not merely Gate B mechanism choices. | Obtain bounded Owner/qualified input for all three matters, synchronize the design, then perform another independent review. Infer no human, title, device or proof mechanism. |
| `CORE02-FIR2-02` — unresolved-to-transferred transition and handover-attempt identity are ambiguous | `MAJOR` | [Design Package §§4.2–4.3](after_four_accelerated_core_operations_design_package.md); [CORE-02 remediation §4](after_four_core_02_accelerated_design_remediation.md); [FIR remediation §3.2](after_four_core_02_fresh_review_findings_remediation.md) | State tables show `absent → transferred` and `absent → transfer_evidence_unresolved`, while prose permits new authoritative evidence to establish transfer later. The design does not explicitly state whether the same handover command/attempt may progress `transfer_evidence_unresolved → transferred`, or when a distinct attempt/command identity is required. Replay immutability and new-evidence progression could therefore be implemented inconsistently. | Before Gate A presentation, define logical handover-attempt/command identity and the permitted transition after unresolved evidence. Preserve prior evidence and replay immutability. Timeout, transport or authentication alone cannot create a new attempt or transfer. Physical enforcement remains Gate B. |
| `CORE02-FIR2-03` — Dispatch acceptance remediation is coherent | `OBSERVATION` | [Design Package §§4.2–4.4](after_four_accelerated_core_operations_design_package.md); [CORE-02 remediation §5](after_four_core_02_accelerated_design_remediation.md); [FIR remediation §2](after_four_core_02_fresh_review_findings_remediation.md) | Dispatch, Outbox, delivery, attempt, Ticket and Ticket Item identities are distinct. `accepted`/`rejected_terminal` are immutable and mutually exclusive; `held_unresolved` is nonterminal and fail-closed. Timeout, response loss, replay and uncertainty cannot create another attempt. Unbound Candidate Ticket/Items remain quarantined and non-executable. | No policy correction. Gate B must later prove physical uniqueness, transactions, isolation, locking, persistence and concurrency enforcement. |
| `CORE02-FIR2-04` — handover axes are separated subject to FIR2-01/02 | `OBSERVATION` | [Design Package §§4.2–4.3](after_four_accelerated_core_operations_design_package.md); [FIR remediation §§3.2–3.4](after_four_core_02_fresh_review_findings_remediation.md) | `acknowledged`, `refused` and `disputed` do not establish transfer. Command invocation, authentication, transport success and replay do not establish actual release. Only authoritative `transferred` evidence satisfies the handover guard. Fail-closed outcomes preserve evidence. | Preserve these distinctions while resolving FIR2-01/02. |
| `CORE02-FIR2-05` — exception and cancellation boundaries are coherent | `OBSERVATION` | [Design Package §§4.2, 4.5](after_four_accelerated_core_operations_design_package.md); [Owner Baseline accelerated decisions](../architecture/after_four_owner_decision_baseline.md) | Exception identity/status/evidence are explicit; unresolved evidence is preserved. Cancellation matches `CORE-OD-09A`–`09D`, does not authorize Refund and does not automatically close an Order. | Resolver assignment and Refund remain separately governed. |
| `CORE02-FIR2-06` — ADR-0011 forward dependency contract is coherent | `OBSERVATION` | [ADR-0011 §§3–5](../architecture/adr/0011-project-wide-layered-ddd.md); [Design Package §4.4](after_four_accelerated_core_operations_design_package.md); [CORE-02 remediation §7](after_four_core_02_accelerated_design_remediation.md) | Domain remains framework-independent; Application owns use cases and required contracts; Infrastructure implements persistence/audit/cross-context adapters; Presentation delegates; composition wires. No upstream Infrastructure read is authorized. Logical consistency is separate from physical atomicity. | Physical transaction, locking, isolation, uniqueness, persistence, transport and deployment remain Gate B. |
| `CORE02-FIR2-07` — cross-workstream governance is preserved | `OBSERVATION` | [Design Package §§4.3, 4.5, 10, 12](after_four_accelerated_core_operations_design_package.md); [CORE-02 remediation §8](after_four_core_02_accelerated_design_remediation.md) | `CORE-OD-08A`–`10C` remain confirmed. `CORE-OD-10C` requires settled Payment, completed Preparation, authoritative transfer and no open exception; transfer does not close the Order. Universal `P1A-OD-07` remains deferred. Refund/manual-bank remain excluded, Identity Milestone 2B unauthorized, and Inventory deferred. | No change. Maintain separate governance. |

## 4. Verified invariants

- Dispatch, Outbox, delivery, acceptance attempt, Ticket and Ticket Items are distinct.
- Exactly one immutable terminal acceptance outcome may exist per attempt; `held_unresolved` is nonterminal.
- Uncertainty never creates a replacement attempt, and replay cannot create duplicate Ticket/Items.
- A new acceptance attempt requires terminal rejection, preserved evidence, resolved rejection basis, revalidated eligibility, separate authorization and a new identity.
- Handover acknowledgement and customer custody transfer are independent evidence axes.
- Acknowledgement, refusal, dispute, authentication, command invocation and transport success are not custody transfer.
- Only authoritative `transferred` evidence can satisfy `CORE-OD-10C`; Ordering owns the separate closure decision.
- Cancellation does not authorize Refund.
- Logical business consistency does not imply physical database atomicity.

## 5. Governance reconciliation

Verified unchanged: 27 confirmed / 7 deferred consolidated CORE references; `CORE-OD-08A`–`CORE-OD-10C` within their recorded bounds; deferred `P1A-OD-07`; no new canonical `ODB-*` ID; Identity Milestone 2B unauthorized; ADR-0006 Proposed; Inventory deferred; and Refund, manual-bank, Promotions and Loyalty outside CORE-02.

## 6. Final outcome

`NOT_READY_FOR_OWNER_GATE_A_REVIEW`

The acceptance/retry/quarantine and ADR-0011 contracts are logically coherent. CORE-02 remains unready because the three custody-transfer policy inputs are unresolved and the logical transition from unresolved transfer evidence to later authoritative transfer lacks an explicit attempt/identity rule.

Recommended sequence: obtain the three Owner/qualified inputs; clarify handover attempt identity and `transfer_evidence_unresolved → transferred` without selecting physical mechanisms; synchronize affected documents; then run another fresh independent review.
