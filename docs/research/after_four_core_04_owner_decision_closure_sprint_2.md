# AFTER FOUR — CORE-04 Owner Decision Closure — Sprint 2

**Assessment date:** 2026-11-24

**Baseline:** `main` at `7bf418159565a24bfe7589230eedb281b3804ccf`

**Status:** `NOT_READY_FOR_OWNER_GATE_A_REVIEW — OWNER_INPUT_REQUIRED`

**Authority:** consolidated Owner-session preparation only

## 1. Controlling baseline

This package reconciles, but does not replace, the [Owner Decision Baseline](../architecture/after_four_owner_decision_baseline.md), [Cash Domain Discovery](after_four_p2b_cash_domain_discovery.md), [Core Operations Design Package](after_four_accelerated_core_operations_design_package.md), [Core Operations Design Remediation](after_four_accelerated_core_operations_design_remediation.md), and [Next Readiness Sprint](after_four_accelerated_core_operations_next_readiness_sprint.md).

Already approved constraints remain controlling: explicit Branch timezone/cutoff direction (`ODB-CASH-12`), operation-specific Branch-scoped Open/Count/Handover/Close capabilities (`ODB-CASH-13`), immutable closed evidence with linked corrections (`ODB-CASH-14`), required handover evidence and acknowledgement-not-approval (`ODB-CASH-15`), and the consolidated `CORE-OD-11A/C/D`, `CORE-OD-14A/B`, and `CORE-OD-15A/B` policies. Recommendations below are `PROPOSED_NOT_APPROVED`.

## 2. Consolidated decision register

| Decision area | Approved policy and constraints | Exact unresolved Owner decision | Evidence-supported direction | Consequence if unresolved | Input / stage |
|---|---|---|---|---|---|
| `CORE-OD-11B` — Branch cutoff | First Hoi An Branch timezone is `Asia/Ho_Chi_Minh`; each Branch is configured independently; exceptional days use explicit effective evidence and never rewrite a closed Operating Day. | Select the first Branch fixed local `HH:MM` cutoff. | `RECOMMENDATION_NOT_ESTABLISHED`; obtain hours, after-midnight activity, close/count/handover duration and Accounting/Reporting boundary examples. | Operating Day, daily limits and authoritative reporting boundary remain incomplete. | Branch operations plus Accounting/Reporting evidence; blocks coherent Gate A baseline. |
| `CORE-OD-12` subquestion A — operation capability source | Open, Count, Handover and Close are distinct Branch-scoped capabilities. Generic Staff, Shift or Branch Assignment grants none. | Select accountable capability-holder/source rules for each defined Cash operation, reconciliation and discrepancy disposition. | Confirm operation-specific, Branch-scoped, fail-closed principles only; actual assignments remain `RECOMMENDATION_NOT_ESTABLISHED`. | Commands cannot have a complete authorization policy. | Owner policy before Gate A; identity representation/enforcement is later Gate B and separately authorized Identity work. |
| `CORE-OD-12` subquestion B — delegation | No generic delegation is approved. | Define delegation, revocation, expiry and emergency boundaries per operation. | `RECOMMENDATION_NOT_ESTABLISHED` pending operating and control evidence. | Delegated operation paths remain prohibited/fail-closed. | Owner policy before Gate A; no human appointment. |
| `CORE-OD-12` subquestion C — separation | Expense self-approval prohibition does not automatically define every Cash operation. | Define requester/actor/counter/approver conflicts and separation per operation. | Risk-tiered separation may be reviewed, but no model is selected. | Correction, disagreement and discrepancy authority remain incomplete. | Cash/Accounting evidence; Gate A policy input. |
| `CORE-OD-13` — linked correction | Closed evidence is immutable; any correction is a new attributable linked fact. | Enumerate permitted correction operations, requester, approver, executor, required reason/evidence and reconciliation/reporting consequences. | No post-close correction operation in the initial slice unless a bounded operation/evidence/authority model is approved. | Errors remain held and may block authoritative reporting. | Cash, Accounting and Reporting input; Gate A policy, then Gate B workflow/mechanism design. |
| Handover refusal/dispute resolution | Evidence records actor, timestamp, reason and references; acknowledgement is not approval; disagreement escalates to Owner; separate Close action is required. | Select resolver, permitted consequences, refusal path and escalation completion evidence. | Bounded Owner resolution may be considered initially, but remains `PROPOSED_NOT_APPROVED`; no automatic consequence. | Handover and related Session remain held. | Owner decision; capability consequences depend on `CORE-OD-12`. |
| `CORE-OD-15A` — discrepancy disposition | Every nonzero discrepancy is recorded with reason and Owner notification; no tolerance applies. | Define classes, investigation, escalation, resolver/disposition authority, linked-correction relationship and consequences. | `RECOMMENDATION_NOT_ESTABLISHED`; Cash, Accounting and Reporting must supply source-supported options. | Discrepancy stays explicitly unresolved and blocks dependent authority. | Qualified Accounting/Reporting plus Owner policy; Gate A input. |
| `CORE-OD-15B` — authoritative-report release | Unreconciled Cash facts are held; discrepancy resolution does not grant report release. | Define authoritative/reconciled evidence, whether exception release exists, releaser authority, review evidence and limitations. | No exception release for the first slice unless qualified evidence proves a need and Owner separately approves it. | Cash-dependent authoritative reporting remains held. | Accounting/Reporting evidence and Owner policy; independent from `CORE-OD-12`. |
| `CORE-OD-16B` — report reader | Reporting reader authority is deferred. | Define reader capability and Branch scope. | No recommendation without Identity/governance inputs. | No report-read authority. | Later Owner/Gate work; not a Cash capability. |
| `CORE-OD-16F` — retention | Retention, disposal and legal hold remain deferred. | Define purpose-specific retention/disposal/legal-hold policy. | `RECOMMENDATION_NOT_ESTABLISHED`; qualified governance/privacy/legal input required. | Reporting retention baseline remains incomplete. | Qualified input and later governance; no inferred period. |

## 3. Required semantic separations

- Evidence capture is not approval.
- Acknowledgement is not customer custody transfer and is not Cash handover approval.
- Escalation is not resolution.
- Cash Session handover acknowledgement is distinct from the separate Close action.
- Discrepancy investigation, disposition, linked correction and authoritative-report release are independent authorities.
- Reconciliation does not grant report read, export, recipient, schedule, delivery or publication authority.
- No decision here authorizes a human appointment, Identity implementation, correction workflow, schema or runtime grant.

## 4. Review order and parallelism

`CORE-OD-11B` can be reviewed independently after operating-boundary evidence. The three `CORE-OD-12` subquestions can be prepared in parallel, then constrain authority portions of `CORE-OD-13`, disagreement resolution and `CORE-OD-15A`. `CORE-OD-13` and `CORE-OD-15A` should be reviewed together but answered independently. `CORE-OD-15B` depends on reconciliation/disposition evidence, not on assignment of Cash capabilities. `CORE-OD-16B` and `CORE-OD-16F` remain separate Reporting/governance decisions.

## 5. Readiness conclusion

**Outcome:** `NOT_READY_FOR_OWNER_GATE_A_REVIEW — OWNER_INPUT_REQUIRED`.

The logical boundaries are sufficiently explicit to conduct one consolidated Owner session, but cutoff, Cash authority, linked-correction authority, disagreement resolution, discrepancy disposition, report release, report-reader scope and retention inputs are not closed. This report grants no decision, Gate, appointment or implementation authority.
