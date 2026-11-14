# AFTER FOUR — Owner Decision Baseline

**Status:** Canonical source of truth for Owner-confirmed business decisions  
**Date recorded:** 2026-11-14  
**Scope:** Business and planning decisions that constrain later architecture and implementation

This baseline records Owner decisions supplied after the earlier repository consistency audit. It does not claim that these decisions were already present in the repository before this document was created.

**Provenance for decisions with an `ODB-` identifier:** Owner-confirmed project discussion supplied in the Owner Decision Baseline Reconciliation task.

**Classification for every `ODB-` row in §§1–4:** `OWNER_CONFIRMED`. The separate Implementation column records implementation state and must not be read as the approval classification.

Owner approval and implementation are separate dimensions:

- `OWNER_CONFIRMED`: the stated business direction is approved within its explicit boundary.
- `IMPLEMENTED`: executable behavior exists. This does not approve unstated policy or production use.
- `DOCUMENTED_PROPOSAL`: an architecture or technical recommendation, not an Owner decision.
- `UNRESOLVED`: a decision remains genuinely open.
- `CONTRADICTORY`: current repository sources disagree with the baseline or implementation evidence.
- `HISTORICAL`: a preserved earlier proposal or question that is no longer implementation authority.

## 1. Product and launch planning

Planning assumptions guide scenario design and later validation. They are not capacity guarantees, concurrency limits, service objectives, or production topology approvals.

| ID | Owner-confirmed decision | Implementation | Repository evidence / remaining boundary |
|---|---|---|---|
| `ODB-PLN-01` | The Brand is AFTER FOUR. | Present in repository naming. | Product identity only. |
| `ODB-PLN-02` | AFTER FOUR is an internal chain-first cafe management product, not SaaS. | Documented. | [Business Domain Model §1.2](after_four_business_domain_model.md#12-product-boundary). |
| `ODB-PLN-03` | Initial launch planning assumes one main Branch. | Not implemented as a production limit. | Future design retains multi-Branch meaning. |
| `ODB-PLN-04` | Initial launch planning assumes four Employees. | Not implemented as a limit. | Does not limit Users, shifts, or future staffing. |
| `ODB-PLN-05` | Initial launch planning assumes one POS Device. | Frontend prototype only. | Does not approve device enrollment or production topology. |
| `ODB-PLN-06` | Expected operation uses two to three shifts per operating day with Employee rotation. | Not implemented. | Shift and handover design must preserve individual accountability. |
| `ODB-PLN-07` | Planning peak is 40–60 Orders per hour. | Not load-tested. | Forecast input only; no concurrency/SLO conclusion follows. |
| `ODB-PLN-08` | Planning Order mix is approximately 80% dine-in and 20% takeaway. | Channels exist in Phase 1. | Mix is not a quota or validation rule. |
| `ODB-PLN-09` | Planning Payment mix is approximately 70% bank transfer and 30% cash. | Methods exist in Phase 1. | Mix is not provider or capacity approval. |

## 2. Ordering and Payment

| ID | Owner-confirmed decision | Implementation | Repository evidence / remaining boundary |
|---|---|---|---|
| `ODB-OP-01` | A customer chooses dine-in or takeaway without providing a reason. | Implemented channel vocabulary. | No reason field is required for channel selection. |
| `ODB-OP-02` | Full verified Payment must be persisted before Preparation Dispatch for dine-in and takeaway. | Implemented in Phase 1. | [Phase 1 §4](after_four_order_payment_implementation_phase1.md#4-atomic-safety-boundary). |
| `ODB-OP-03` | Pending, unknown, failed, or unverified Payment cannot dispatch Preparation. | Implemented in Phase 1. | Payment and Dispatch guards remain independent of client display state. |
| `ODB-OP-04` | Late successful Payment for a Held or Expired Order is recorded and reconciled but never automatically dispatches or reactivates the Order. | Implemented in Phase 1. | Opens an attributed review case. |
| `ODB-OP-05` | A paid Order whose Preparation Dispatch fails is retryable without another charge or duplicate Dispatch. | Dispatch intent/requeue implemented; delivery deferred. | Retry reuses Dispatch and Outbox identities. |
| `ODB-OP-06` | Pending Orders use a configurable expiration timeout with a five-minute default. | Implemented. | The default is not an immutable permanent policy. |
| `ODB-OP-07` | MVP bank transfer uses the Owner's bank QR. | Not implemented. | Account/QR material and secure operational handling remain outside current code. |
| `ODB-OP-08` | A bank notification speaker announces an amount as an alert only; it is not proof of Payment. | Not implemented. | No speaker integration or authority is approved. |
| `ODB-OP-09` | The cashier manually compares the announced/observed amount with the pending Order and explicitly confirms it in POS. No automatic bank API matching is approved for MVP. | Manual confirmation command exists; UI/integration is not active. | Actor authentication and Branch authorization remain prerequisites. |
| `ODB-OP-10` | An amount mismatch is not confirmed by default. It must be resolved or appropriately refunded; any exception requires Owner or explicitly authorized approval, reason, and audit. | Default mismatch rejection implemented. | Exception roles, resolution transaction, and refund method remain `UNRESOLVED`. |
| `ODB-OP-11` | Overpayment must be evidenced and the excess refunded through an appropriate method. Excess is not revenue. Evidence includes amount, method, reason, actor/approver, time, and linked Payment/Order. | Not implemented. | Evidence model, refund method, allocation, and provider behavior require separate design. Phase 1 remains exact-balance-only. |
| `ODB-OP-12` | Staff may cancel a paid Order with reason and audit before Preparation starts. | Not implemented. | Requires an atomic Preparation-state fence and refund/compensation coordination. |
| `ODB-OP-13` | Once Preparation has started, cancellation requires Owner approval. | Not implemented. | Prepared-item, refund, stock, and compensation outcomes remain to be designed. |
| `ODB-OP-14` | Completed Orders use a separate exception process. | Not implemented. | Exact authority and outcomes remain `UNRESOLVED`. |
| `ODB-OP-15` | Payment and Payment Attempt are distinct concepts. | Implemented. | [Glossary](../../GLOSSARY.md) and [Payment Model](after_four_payment_model.md). |
| `ODB-OP-16` | Unknown Payment Attempts require authoritative reconciliation; they must not be blindly retried or replaced with another charge. | State model documented; provider reconciliation not implemented. | Provider/method contract remains `UNRESOLVED`. |

## 3. Cash Management and Expenses

The **Operating Day** boundary used for daily limits and reporting is not yet defined. That missing boundary does not change the approved amounts or authority below.

| ID | Owner-confirmed decision | Implementation | Repository evidence / remaining boundary |
|---|---|---|---|
| `ODB-CASH-01` | One shared physical cash drawer is planned. | Not implemented. | Every movement still retains its individual actor. |
| `ODB-CASH-02` | The shared float is 2,000,000 VND per Operating Day. | Not implemented. | Configurable policy value; not a per-shift grant. |
| `ODB-CASH-03` | The daily float carries across shifts. A new Cash Session may record a new opening count without creating a new daily float allocation. | Not implemented. | Handover must retain prior-session accountability. |
| `ODB-CASH-04` | The system must not automatically reset or top up cash to 2,000,000 VND during the day. | Not implemented. | No implicit Cash Transaction is allowed. |
| `ODB-CASH-05` | Opening shift checks cash sufficiency and notifies the Owner when short. | Not implemented. | No discrepancy tolerance is approved. |
| `ODB-CASH-06` | Shift closing includes cash count and verification. | Not implemented. | Close evidence is immutable; corrections are linked entries. |
| `ODB-CASH-07` | Shift handover preserves accountability and notifies the Owner of shortages or discrepancies. | Not implemented. | Exact escalation timing and correction flow remain `UNRESOLVED`; no discrepancy tolerance is approved. |
| `ODB-CASH-08` | The Owner authorizes float top-ups; Staff may request one. | Not implemented. | No additional approver role is approved. |
| `ODB-CASH-09` | A top-up records amount, source, executor, approver, and time. | Not implemented. | Evidence is required independently of payment/reporting projections. |
| `ODB-CASH-10` | A float top-up is not revenue. | Not implemented. | Reporting must classify it as a cash movement/funding source. |
| `ODB-CASH-11` | No fixed top-up frequency limit is approved. | Not implemented. | Do not invent a frequency cap. |
| `ODB-EXP-01` | Delegated expense limit is at most 200,000 VND per Expense. | Not implemented. | Configurable value, not a hard-coded constant. |
| `ODB-EXP-02` | Delegated expenses are capped at 500,000 VND cumulatively per Operating Day. | Not implemented. | Atomic cumulative enforcement requires the Operating Day boundary. |
| `ODB-EXP-03` | Exceeding either delegated limit requires Owner approval. | Not implemented. | Exceeding one threshold is sufficient to require approval. |
| `ODB-EXP-04` | Expense self-approval is forbidden. | Not implemented. | Requester/executor cannot approve their own Expense. |
| `ODB-EXP-05` | Splitting Expenses to evade a limit is prohibited. | Not implemented. | Detection and review details remain technical design. |
| `ODB-EXP-06` | Expense evidence records purpose, recipient, executor, approver, and receipt or explanation. | Not implemented. | Accounting/tax classification remains subject to validation. |
| `ODB-EXP-07` | Expense limits are configurable and must not be hard-coded. | Not implemented. | Configuration history and effective timing require design. |

## 4. Reporting

| ID | Owner-confirmed decision | Implementation | Repository evidence / remaining boundary |
|---|---|---|---|
| `ODB-RPT-01` | AFTER FOUR will provide an Owner Dashboard and automatic daily report delivery through Telegram. | Not implemented. | Direction is approved; delivery details below remain open. |
| `ODB-RPT-02` | Dashboard views support daily, weekly, monthly, custom date ranges, and period comparison. | Not implemented. | Business-day and formula definitions remain `UNRESOLVED`. |
| `ODB-RPT-03` | Excel export is deferred. | Not implemented. | It is not part of the current reporting scope. |
| `ODB-RPT-04` | Reporting distinguishes revenue from cash flow. Daily reporting includes relevant gross/net sales, Order count, cash/bank-transfer split, Refunds, operating Expenses, float/top-ups, cancellations, and exceptions. | Not implemented. | Exact metric formulas remain `UNRESOLVED`. |
| `ODB-RPT-05` | Telegram delivery retains history, retries idempotently, and avoids sensitive information in messages. | Not implemented. | Message retention/privacy and failure escalation remain `UNRESOLVED`. |

The following reporting details are explicitly `UNRESOLVED`: exact delivery time (including the unconfirmed 22:15 proposal), recipients, Operating Day cutoff, metric formulas, Branch scope, privacy details, and failure escalation.

## 5. Identity and Authorization

Identity decisions `ID-01` through `ID-34` remain exactly as recorded in the [Identity Decision Register](after_four_identity_decision_register.md#owner-decisions-confirmed). This baseline references them rather than duplicating their complete security boundaries.

- `ID-01`–`ID-28`: `OWNER_CONFIRMED`; security/implementation evidence remains required where stated.
- `ID-29`–`ID-34`: `OWNER_CONFIRMED` only for the stated Argon2 validation/admission direction. They do not approve a production dependency, profile, numeric resource/admission value, implementation, production use, or residual risk.
- [ADR-0006](adr/0006-authentication-session-topology.md) remains **Proposed**.
- Milestone 2B remains **not authorized**.

## 6. Deployment proposals

Proposal placeholders `ID-35` through `ID-39` remain `DOCUMENTED_PROPOSAL` and `NOT_APPROVED`, as recorded in [AF-OWNER-001G](security-reviews/owner-led/af-owner-001g-deployment-direction-proposals.md). They do not become Owner decisions through this baseline.

- `ID-35`: deployment shape/provider criteria;
- `ID-36`: evidence-first resource/process sizing method;
- `ID-37`: launch forecast framework—distinct from the confirmed planning assumptions in §1;
- `ID-38`: experience/availability objective classes;
- `ID-39`: operational ownership model.

[ADR-0008](adr/0008-deployment-environments.md) remains **Proposed**.

## 7. Use and precedence

1. Use this baseline for Owner-confirmed business direction.
2. Use the Business Domain Model, Payment Model, State Machines, Data Dictionary, Integrity Rules, and API Contract for synchronized domain/technical detail.
3. Use the implementation record and executable evidence for implemented behavior; implementation does not silently create a new Owner decision.
4. Treat older workshop, workflow, domain, database, and roadmap documents as historical where their banners say so.
5. When this baseline intentionally leaves a detail unresolved, no downstream document or implementation may invent it.
