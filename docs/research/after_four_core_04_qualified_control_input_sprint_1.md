# AFTER FOUR — CORE-04 Qualified Control Input — Sprint 1

**Assessment date:** 2026-11-24 (Asia/Tokyo)

**Baseline:** `main` at `ad7e7bf973233e0286c91af2a1b7bbb27d817d25`

**Authority:** documentation and qualified-input specification only

**Readiness:** `NOT_READY_FOR_FRESH_INDEPENDENT_GATE_A_REVIEW`

> **PUBLIC-SOURCE CLOSURE PASS — 2026-11-25.** Current official Accounting Law, accounting-regime, tax/e-invoice and personal-data sources establish minimum attributable voucher content, authorization/signature evidence, non-destructive records, safe retrieval, statutory accounting-record retention classes and purpose-bounded access constraints. They do not appoint an AFTER FOUR capability holder, decide operation sharing/separation, authorize a linked-correction operation, select Refund eligibility/method/execution/accounting treatment, set reconciliation/report-release sufficiency or allocate cross-midnight facts. `WS-REFUND-01` separately confirms that an otherwise eligible request remains evidence-preserving, pending and unexecuted while the Owner is unreachable; it creates no emergency authority. The remaining dimensions stay `OWNER_DECISION_REQUIRED`; real First Branch control operation/effectiveness remains `ACTUAL_OPERATIONAL_EVIDENCE_REQUIRED`. The external-provider path is dormant under the current Owner direction.

## 1. Preserved confirmed policy

| Policy | Classification | Preserved boundary |
|---|---|---|
| Operating Day | `OWNER_CONFIRMED` | Initial cutoff is `00:00` local in each explicitly configured Branch timezone; first Hoi An Branch is `Asia/Ho_Chi_Minh`; no MVP inheritance; future configurable cutoff is product direction only. |
| Handover disagreement | `OWNER_CONFIRMED` | `CORE-OD-14A`: disagreement/refusal remains unresolved and escalates to Owner; acknowledgement is not approval. Resolution workflow/consequences beyond that escalation remain open. |
| Session transition | `OWNER_CONFIRMED` | `CORE-OD-14B`: acknowledgement does not close the outgoing Cash Session; Close is separate and requires the applicable capability. |
| Discrepancy | `OWNER_CONFIRMED` | Every nonzero discrepancy is recorded with reason and Owner notification; there is no tolerance. |
| Reporting hold | `OWNER_CONFIRMED` | Unreconciled data is withheld from authoritative reporting; discrepancy resolution does not itself grant report-release authority. |
| Cash capability boundary | `OWNER_DECISION_REQUIRED` | `CORE-OD-12` remains deferred. Whether Open, Count and Handover each require separate capabilities, whether any operations may share a capability, and all assignment/delegation/revocation/emergency/separation rules remain unapproved. |

Sources: [Owner Decision Baseline](../architecture/after_four_owner_decision_baseline.md), [Core Operations Design Package §5](after_four_accelerated_core_operations_design_package.md#5-core-04--cash-and-operating-day-closure-assessment), and [post-Owner readiness §5](after_four_post_owner_decision_readiness_sprint.md#5-core-04-control-readiness).

## 2. Package A — `CORE-OD-12` Cash capabilities

| Input dimension | Confirmed constraint | Qualified evidence required | Owner decision required | Classification |
|---|---|---|---|---|
| Open | An operation-specific Open capability is a candidate direction, not approved policy. Generic Staff/Shift/Assignment supplies no authority by this package. | Operational responsibility, evidence checked before Open, unavailable-actor and emergency scenarios. | Whether Open has a distinct or shared capability, eligible holder boundary and Branch scope. | `PROPOSED_NOT_APPROVED`; `QUALIFIED_INPUT_REQUIRED`; `OWNER_DECISION_REQUIRED` |
| Count | A distinct Count capability and separation from other operations are candidate controls, not approved policy. | Independence, recount/dispute scenarios, evidence and separation needs. | Whether Count has a distinct or shared capability, eligible holder and any separation from other operations. | `PROPOSED_NOT_APPROVED`; `QUALIFIED_INPUT_REQUIRED`; `OWNER_DECISION_REQUIRED` |
| Handover | Evidence capture is not approval; confirmed `CORE-OD-14A` sends unresolved disagreement/refusal to Owner. Whether Handover has a distinct capability is unapproved. | Operational participants, evidence responsibility, unavailable party and escalation timing. | Whether Handover has a distinct or shared capability and its eligible holder; no new resolver is selected. | `PROPOSED_NOT_APPROVED`; `QUALIFIED_INPUT_REQUIRED`; `OWNER_DECISION_REQUIRED` |
| Close | Confirmed `CORE-OD-14B` makes Close a separate action from acknowledgement and requires the applicable capability; it does not decide whether that capability is shared with another Cash operation. | Preconditions, accountability, conflict cases and separation risks. | Eligible holder and whether/how Close authority is separated from Open, Count or Handover. | `QUALIFIED_INPUT_REQUIRED`; `OWNER_DECISION_REQUIRED` |
| Assignment/delegation | No person, title or role is inferred. | Candidate accountability model, scope, duration, evidence and conflict controls. | Whether delegation exists and its exact scope. | `PROPOSED_NOT_APPROVED` |
| Revocation | Revocation must fail closed without rewriting prior evidence. | Effective-time, in-flight command and emergency evidence requirements. | Revocation authority and consequences. | `QUALIFIED_INPUT_REQUIRED`; `OWNER_DECISION_REQUIRED` |
| Emergency handling | Emergency does not create default authority. `WS-REFUND-01` confirms pending/no execution with Owner escalation and customer pending-status communication for an otherwise eligible Refund request while the Owner is unreachable. | Owner-unavailable scenarios, business continuity needs, risks and audit requirements for every other operation and any proposed future exception. | Whether any future emergency path exists and its limits; none is approved now. | `OWNER_CONFIRMED` only for the `WS-REFUND-01` fail-closed Refund disposition; otherwise `PROPOSED_NOT_APPROVED` |
| Separation of duties | No capability-sharing or separation matrix is approved. Operation-specific separation is a candidate control only. | Cash/Accounting control analysis of incompatible responsibilities and review needs. | Decide which operations, if any, require distinct capabilities or actors. | `PROPOSED_NOT_APPROVED`; `QUALIFIED_INPUT_REQUIRED`; `OWNER_DECISION_REQUIRED` |

`GATE_B_DEFERRED` — Capability representation, session enforcement, revocation races, authentication and persistence are not selected.

## 3. Package B — `CORE-OD-13` post-close correction

| Input dimension | Confirmed constraint | Required evidence/input | Owner decision required |
|---|---|---|---|
| Permitted operations | Closed evidence is immutable; any correction is a separately attributable linked fact. | Candidate correction catalogue tied to real operational/accounting scenarios; effect on expected/actual/variance and source evidence. | Approve the bounded operation list or defer it. |
| Initiator | Initiation does not imply approval or execution. | Responsibility, Branch scope, conflict/self-interest and evidence-submission requirements. | Approve initiator capability boundary. |
| Approver | No approver is inferred. | Accounting/Cash control analysis, materiality and separation requirements. | Approve authority and escalation; no person is appointed here. |
| Executor | Execution cannot rewrite the close record. | Operational responsibility, approved-instruction linkage and replay/conflict behavior. | Approve executor boundary and separation. |
| Reason/evidence | Original and correction provenance must remain auditable. | Minimum business reason, source reference, actors, times, decision and supporting evidence. | Approve required evidence envelope after qualified constraints. |
| Reconciliation/reporting | Correction and reporting consequences are separate. | Accounting treatment, period attribution, reconciliation recalculation and report lineage requirements. | Approve business consequences; report release remains separately governed. |

All rows are `QUALIFIED_INPUT_REQUIRED` plus `OWNER_DECISION_REQUIRED`. `GATE_B_DEFERRED` covers linked-record persistence, transaction boundaries, indexes and concurrency.

## 4. Package C — discrepancy investigation and disposition

| Question | Preserved policy | Candidate shape | Required input / decision |
|---|---|---|---|
| Investigation categories | Every nonzero discrepancy remains recorded, reasoned and Owner-notified. | `PROPOSED_NOT_APPROVED`: categories may guide investigation but may never create tolerance or exemption. | Cash/Accounting/Reporting evidence, then Owner category policy. |
| Investigation evidence | No evidence minimum is currently selected. | `PROPOSED_NOT_APPROVED`: common minimum plus category-specific evidence. | Qualified control input and Owner approval. |
| Escalation | Owner notification is mandatory; handover disagreement separately escalates to Owner. | `PROPOSED_NOT_APPROVED`: timing and intermediate review path without changing final policy. | Owner decision; no delegate is inferred. |
| Disposition | `OWNER_CONFIRMED` on 2026-11-25: only the Owner dispositions a Cash discrepancy. No accepted outcome is inferred. | Owner-only disposition is fixed; investigation evidence, handling while awaiting the Owner, consequences and linked-correction eligibility remain unresolved. | Qualified Accounting/Cash/Reporting control input; no delegate or automatic outcome. |
| Linked correction | Correction never rewrites closed facts. | Use only an operation approved under `CORE-OD-13`; otherwise remain unresolved. | Dependency on `CORE-OD-13`. |
| Unresolved hold | Unresolved case remains explicit and is withheld from authoritative reporting. | No alternative that silently treats it as zero/success is admissible. | Reporting consequences and release authority remain separate. |

`OWNER_CONFIRMED` — no tolerance, reason plus Owner notification, Owner-only discrepancy disposition, and authoritative-report hold remain fixed. Investigation evidence, handling while awaiting the Owner, consequences and linked-correction eligibility remain `QUALIFIED_INPUT_REQUIRED` and `OWNER_DECISION_REQUIRED`.

## 5. Package D — reporting release and access

| Reference | Input question | Required qualified evidence | Owner-controlled decision | Boundary |
|---|---|---|---|---|
| Reconciliation prerequisite | What exact authoritative evidence makes a Session and Operating Day reconciled? | Accounting/Reporting lineage, correction treatment and unresolved-case consequences. | Approve the reconciliation sufficiency policy. | Does not grant release. |
| Official report issuance | What reconciliation, annotation, evidence, waiting-case and exception preconditions must hold before the Owner issues an official report? | Accounting/Reporting control, separation, escalation and audit needs. | `OWNER_CONFIRMED` on 2026-11-25: only the Owner issues official reports; remaining preconditions still require Owner policy after qualified input. | Discrepancy disposition does not itself issue a report; no read/export/delivery/recipient authority follows. |
| `CORE-OD-16B` | Who may read each report, for which Branch and purpose? | Identity/Governance/Privacy analysis of least privilege, scope, sensitive fields and use purpose. | Approve reader capability matrix and Branch scope. | Generic role names confer nothing. |
| `CORE-OD-16F` | What retention, disposal and legal-hold policy applies? | Qualified Legal/Privacy/Accounting-records analysis with authoritative sources, effective dates, data categories and limitations. | Approve policy choices left by qualified constraints. | No retention period is invented. |

`QUALIFIED_INPUT_REQUIRED` / `OWNER_DECISION_REQUIRED` — Each row needs qualified evidence followed by the applicable Owner choice. `GATE_B_DEFERRED` covers read models, access enforcement, export/delivery, retention jobs, storage and audit implementation.

## 6. Closure and exclusions

`NOT_FOUND_IN_REVIEWED_SOURCES` — Reviewed sources establish no complete capability assignment, linked correction catalogue, discrepancy resolver, report releaser, reader matrix or retention period. This does not prove no external organizational or professional artifact exists.

`OWNER_DECISION_REQUIRED` — CORE-04 remains not ready until the identified inputs and Owner decisions close without weakening `CORE-OD-11B`, `CORE-OD-14A/B`, no-tolerance discrepancy policy or reporting hold. `VERIFIED_REPOSITORY_EVIDENCE` — no professional advice was obtained; no person, role, delegate, approver, resolver, tolerance, retention period or reporting authority was selected.
