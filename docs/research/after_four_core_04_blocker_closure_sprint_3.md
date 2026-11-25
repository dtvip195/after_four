# AFTER FOUR — CORE-04 Blocker Closure — Sprint 3

**Assessment date:** 2026-11-24

**Verified baseline:** `main` at `0423cf3c2f38871f105a82fdce04bfbb7383713b`

**Status:** `NOT_READY_FOR_OWNER_GATE_A_REVIEW — CONSOLIDATED_OWNER_AND_QUALIFIED_INPUT_REQUIRED`

**Authority:** decision preparation and logical-design reconciliation only

## 1. Evidence boundary

This report reconciles the [Owner Decision Baseline](../architecture/after_four_owner_decision_baseline.md), [Cash Domain Discovery](after_four_p2b_cash_domain_discovery.md), [Core Operations Design Package](after_four_accelerated_core_operations_design_package.md), [Core Operations Design Remediation](after_four_accelerated_core_operations_design_remediation.md), [Next Readiness Sprint](after_four_accelerated_core_operations_next_readiness_sprint.md), and [Sprint 2 CORE-04 closure](after_four_core_04_owner_decision_closure_sprint_2.md). It prepares one decision session; it records no Owner decision.

The following remain controlling:

- `ODB-CASH-12` requires an explicit Branch timezone and cutoff; `CORE-OD-11A/C/D` fixes the first Hoi An Branch timezone as `Asia/Ho_Chi_Minh`, rejects MVP inheritance, and requires explicit exceptional-day evidence.
- `ODB-CASH-13` requires separate Branch-scoped Open, Count, Handover and Close capabilities. Generic Staff status, Employee Shift and Branch Assignment grant none.
- `ODB-CASH-14` requires linked correction facts and prohibits reopening or rewriting closed evidence.
- `ODB-CASH-15` fixes the six handover evidence elements and states that acknowledgement is not approval.
- `CORE-OD-14A/B` escalates refusal/disagreement to Owner and requires a separate Close action; acknowledgement does not close the outgoing Session.
- `CORE-OD-15A/B` requires every nonzero discrepancy to be recorded with reason and Owner notification, prohibits tolerance, and holds unreconciled facts from authoritative reporting.
- `CORE-OD-16A/C/D/E` limits initial source lineage, excludes Excel and automatic external delivery, and makes reporting cutoff and Cash-dependent authority follow approved Operating Day/reconciliation boundaries.

## 2. Consolidated decision register

Every row is independently answerable unless its dependency column says otherwise. Options and recommendations are `PROPOSED_NOT_APPROVED`.

| Decision area | Existing confirmed policy | Exact unresolved question | Genuinely supported options | Recommended direction and rationale | Deferral consequence | Qualified input | Governance stage / dependencies |
|---|---|---|---|---|---|---|---|
| `CORE-OD-11B` — first-Branch cutoff | First Branch uses `Asia/Ho_Chi_Minh`; every Branch has an explicit cutoff; no MVP inheritance; exceptional days never rewrite closed days. | What fixed local `HH:MM` cutoff applies to the first Branch? | Local midnight; a fixed post-midnight/early-morning cutoff supported by operating evidence; another fixed local time supported by evidence. Moving “when close” and chain-wide substitution are excluded. | `RECOMMENDATION_NOT_ESTABLISHED`. First obtain operating hours, after-midnight transactions, count/handover duration and Accounting/Reporting boundary examples. | Operating Day, daily limits and authoritative reporting cutoff remain incomplete. | Branch operations plus Accounting/Reporting evidence. | Independent Owner decision; blocks coherent CORE-04 Gate A baseline. |
| `CORE-OD-12` — capability source/assignment | Open, Count, Handover and Close are distinct Branch-scoped capabilities; generic status/assignment grants none. | What accountable capability-holder/source rule applies separately to Open, Count, Handover, Close, reconciliation and discrepancy disposition? | Strict distinct actors; risk-tiered separation; same actor only for explicitly enumerated operations under explicit authority/evidence. These are policy models, not assignments. | Retain operation-specific, Branch-scoped, fail-closed authority. `RECOMMENDATION_NOT_ESTABLISHED` for assignees until the operation/control matrix exists. | Runtime commands lack a complete authority baseline; generic actors remain unauthorized. | Cash operations and Accounting control evidence; later Identity design. | Owner policy before Gate A; technical representation and enforcement require separate Gate B/Identity authorization. |
| `CORE-OD-12` — delegation/revocation/emergency | No delegation model or emergency authority is approved. | Which operations are delegable; by whom; within what Branch/time bounds; how are grants revoked; does any emergency path exist? | No delegation/emergency path; bounded operation-specific delegation with explicit revocation; emergency handling only if separately enumerated and evidenced. | Default to no delegated or emergency authority until the Owner approves exact bounded rules. | Delegated/emergency execution stays fail-closed; Owner bottleneck may remain. | Cash operational need and control-risk evidence. | Depends on capability-source decision; policy before Gate A, mechanics later. |
| `CORE-OD-12` — separation of duties | Expense self-approval prohibition does not automatically decide every Cash conflict. | For each Cash operation, which requester, actor, counter, reviewer, approver or resolver combinations are prohibited? | Strict separation; risk-tiered separation; same actor only for enumerated low-risk operations with independent evidence. | `RECOMMENDATION_NOT_ESTABLISHED`; decide per operation after Accounting control input rather than importing a generic rule. | Correction, disagreement and discrepancy authority cannot be safely assigned. | Qualified Accounting/control input. | Can be prepared in parallel; constrains `CORE-OD-13`, disagreement resolution and `CORE-OD-15A`. |
| `CORE-OD-13` — post-close correction | Closed evidence is immutable; corrections are new separately attributable linked facts. | Which correction operations are permitted, and who may request, approve and execute each with what reason/evidence and reconciliation/reporting consequence? | No post-close correction in the initial slice; bounded enumerated linked corrections; broad linked adjustment. Broad adjustment lacks a supported preferred direction and carries the highest control risk. | Exclude post-close correction from the initial slice unless Cash, Accounting and Reporting supply a bounded operation/evidence/authority model. | Errors remain held and can block reconciliation/reporting. | Cash, Accounting and Reporting operation/evidence/control input. | Owner policy before Gate A; authority portions depend on `CORE-OD-12`; workflow and persistence are Gate B. |
| `CORE-OD-14A/B` — detailed handover refusal/disagreement disposition | Required handover evidence is preserved; acknowledgement is not approval; refusal/disagreement escalates to Owner; separate Close is mandatory. These confirmed constraints are not reopened. | Who resolves the case, what evidence completes escalation, and which explicit consequences may resolution authorize? | Owner resolves initially; separately delegated operation-specific resolver with Owner escalation; case remains held pending separate decision. | Bounded Owner resolution is a supportable initial direction, but remains `PROPOSED_NOT_APPROVED`; every consequence must be separately authorized. | Custody/accountability and the related Session remain held; reports may be delayed. | Operating escalation examples and control input; no invented role. | Resolver delegation depends on `CORE-OD-12`; resolution must not silently close, correct, disposition or release. |
| `CORE-OD-15A` — discrepancy investigation/disposition | Every nonzero discrepancy is recorded with reason and Owner notification; no tolerance or threshold exemption exists. | What classes, investigation steps, escalation, resolver/disposition authority and consequences apply, and when may a separately approved linked correction be requested? | Repository evidence does not establish a defensible class/authority option set. | `RECOMMENDATION_NOT_ESTABLISHED`. Cash, Accounting and Reporting must supply candidate classes, responsibilities, separation/escalation evidence and consequences. | The discrepancy remains explicitly unresolved and blocks dependent authoritative use. | Qualified Accounting/Reporting and Cash evidence. | Owner policy before Gate A; linked correction remains separate under `CORE-OD-13`. |
| `CORE-OD-15B` — report hold/release | Reconcile every Session and Operating Day; unreconciled facts are held; discrepancy resolution does not grant release. | What constitutes authoritative reconciliation, is any exception release allowed, who reviews/releases it, and what annotation/evidence/limits apply? | No exception release; bounded annotated release after separately authorized independent review; Owner-only exception release. | No exception release for the first slice unless qualified evidence establishes a need and the Owner approves the review/release boundary. | Cash-dependent authoritative reporting is delayed or incomplete rather than silently released. | Qualified Accounting/Reporting evidence. | Separate Owner policy; follows reconciliation/disposition evidence but is independent of Cash capability assignment. |
| `CORE-OD-16B` — report reader capability/scope | No report-read authority is granted; release does not grant read/export/delivery authority. | Who may read which approved reports for which Branch scope and purpose? | No reader until policy closure; Owner-only bounded access; separately delegated purpose/Branch-scoped reader capability after Identity/governance input. | Default to no reader until the Owner selects purpose- and Branch-scoped policy after required input. | No report reader is authorized. | Identity/governance input; privacy input where report content requires it. | Separate Reporting Owner decision; does not block Cash fact integrity but blocks report-access baseline. |
| `CORE-OD-16F` — retention/disposal/legal hold | No retention period or disposal/legal-hold authority is approved. | What purpose-specific retention, disposal triggers, legal-hold conditions and authorities apply to Cash/reporting evidence? | Repository evidence establishes no defensible periods or holder assignments. | `RECOMMENDATION_NOT_ESTABLISHED`; obtain qualified legal/privacy/Accounting records input before Owner selection. | Retention design and operational disposal remain unavailable. | Qualified legal/privacy and Accounting records input. | Separate Owner governance decision; physical retention implementation is later Gate B/operational authorization. |

## 3. Lifecycle and authority consistency

The consolidated session must preserve these independent facts and authorities:

1. Handover evidence capture records outgoing actor, incoming actor, count, variance, reason and acknowledgement. It neither approves handover nor resolves refusal/disagreement.
2. Acknowledgement does not transfer customer custody, approve Cash custody, close a Cash Session, disposition a discrepancy or release reporting.
3. Refusal/disagreement escalation preserves evidence and outgoing accountability. Escalation is not resolution.
4. The outgoing Cash Session closes only through the separate Close operation with its own capability; no handover observation silently advances closure.
5. Every nonzero discrepancy retains amount/evidence, reason and Owner notification. Classification may guide investigation but cannot create tolerance or omit recording/notification.
6. Discrepancy investigation, disposition, linked correction and authoritative-report release remain independent.
7. Reconciliation does not grant report reading, export, recipient selection, schedule, delivery or publication authority.

## 4. Reporting boundary reconciliation

`CORE-OD-16A` limits initial source lineage to authoritative Order, Payment and pending Preparation Dispatch facts. Product/Variant sales, Preparation progress/handover, Cash balance/discrepancy/reconciliation, Refund/net sales, Expenses/float/top-ups, Promotions and Loyalty remain excluded from that initial lineage. `CORE-OD-16C` keeps Excel excluded. `CORE-OD-16D` defers Telegram and other automatic external delivery. `CORE-OD-16E` makes reporting cutoff follow the approved Operating Day and admits Cash-dependent facts only after reconciliation.

Nothing in this report adds metrics, readers, export, recipients, schedules, delivery, retention periods or legal-hold authority.

## 5. Decision independence and sequencing

| Sequence | Decision work | Dependency type |
|---|---|---|
| Parallel evidence | Collect Operating Day examples for `CORE-OD-11B`; Cash/Accounting operation-control evidence for `CORE-OD-12/13/15A`; Accounting/Reporting release evidence for `CORE-OD-15B`; Identity/governance and retention input for `CORE-OD-16B/F`. | Evidence / qualified-input dependencies; no policy is selected. |
| First Owner layer | Decide `CORE-OD-11B`; decide `CORE-OD-12` capability source, delegation and separation as independently answerable subquestions. | Cutoff is independent. Capability policy constrains later authority assignments. |
| Second Owner layer | Decide bounded `CORE-OD-13` operations/authority, detailed `CORE-OD-14A/B` handover disagreement disposition, and `CORE-OD-15A` discrepancy disposition independently but with the capability model visible. | Owner-decision dependency on the applicable `CORE-OD-12` authority rules. |
| Reporting layer | Decide `CORE-OD-15B` hold/release after reconciliation/disposition evidence; decide `CORE-OD-16B/F` separately. | Report release depends on evidence truth, not on Cash capability assignment; read and retention remain separate. |
| Later design | Translate approved policies into logical commands/contracts and later physical mechanisms. | Gate A design coherence, then separate Gate B implementation authorization. |

## 6. Blocker closure conditions

| Blocker | Closure condition | Responsible authority category |
|---|---|---|
| Operating Day boundary | Owner selects exact first-Branch cutoff from actual operating/Accounting/Reporting evidence. | Owner after Branch operations and Accounting/Reporting input. |
| Cash capabilities | Owner decides operation-specific holder/source, delegation/revocation/emergency and separation policies. | Owner after Cash/Accounting control input. |
| Post-close correction | Owner approves enumerated linked operations and authority/evidence/consequence matrix, or explicitly excludes them from the bounded slice. | Owner after Cash/Accounting/Reporting input. |
| `CORE-OD-14A/B` detailed handover disagreement | Owner selects resolver/escalation completion and explicit allowable consequences without reopening confirmed Owner escalation or the separate Close action. | Owner; any delegation depends on capability policy. |
| Discrepancy disposition | Source-supported classes, responsibilities and consequences exist and Owner selects policy without tolerance. | Qualified Accounting/Reporting plus Owner. |
| Report release | Reconciliation truth and exception need are evidenced; Owner selects hold/release policy and authority. | Qualified Accounting/Reporting plus Owner. |
| Report read | Owner selects purpose- and Branch-scoped reader policy after Identity/governance input. | Owner plus Identity/governance input. |
| Retention | Qualified input supplies purpose-specific requirements and Owner selects retention/disposal/legal-hold policy. | Qualified legal/privacy/Accounting input plus Owner. |

## 7. Readiness conclusion

**Outcome:** `NOT_READY_FOR_OWNER_GATE_A_REVIEW — CONSOLIDATED_OWNER_AND_QUALIFIED_INPUT_REQUIRED`.

The decision dimensions and dependency order are explicit enough for one consolidated Owner session after the identified evidence is supplied. They are not closed enough for a coherent Gate A baseline. No recommendation above is an Owner decision, and no Gate, human appointment, Identity implementation, correction operation, report authority or runtime behavior is authorized.

## 8. Subsequent Owner decision status

The Consolidated Owner Decision Session on 2026-11-24 subsequently confirmed `CORE-OD-11B`: the initial cutoff is `00:00` local time per Branch, with the first Hoi An Branch using `Asia/Ho_Chi_Minh` under `CORE-OD-11A`. Future per-Branch configurable cutoff is an approved product direction only; it grants no implementation, configuration, schema or migration authority and does not alter `CORE-OD-11C/D`.

The historical ballot and closure criteria above remain evidence of the pre-decision review. Subsequent Owner decisions on 2026-11-25 make Cash discrepancy disposition Owner-only and official-report issuance Owner-only; they also confirm mandatory Owner approval for every Operating Expense with no emergency pre-approval exception. They do not resolve investigation/waiting consequences, reconciliation/issuance preconditions, `CORE-OD-12`, `CORE-OD-13`, detailed `CORE-OD-14A/B` resolution, `CORE-OD-16B`, or `CORE-OD-16F`. CORE-04 remains `NOT_READY_FOR_OWNER_GATE_A_REVIEW — OWNER_AND_QUALIFIED_INPUT_REQUIRED`; no Gate or implementation authorization follows.
