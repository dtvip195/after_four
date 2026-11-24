# AFTER FOUR — Qualified-Input Closure Sprint 1 Index

**Assessment date:** 2026-11-24 (Asia/Tokyo)

**Baseline:** `main` at `ad7e7bf973233e0286c91af2a1b7bbb27d817d25`

**Scope:** concise evidence and dependency index; no Gate or implementation authority

## 1. Package index

| CORE | Package | Current readiness |
|---|---|---|
| CORE-01 | [Qualified Commercial Input](after_four_core_01_qualified_commercial_input_sprint_1.md) | `NOT_READY_FOR_FRESH_INDEPENDENT_GATE_A_REVIEW` |
| CORE-02 | [Qualified Custody Evidence](after_four_core_02_qualified_custody_evidence_sprint_1.md) | `NOT_READY_FOR_FRESH_INDEPENDENT_GATE_A_REVIEW` |
| CORE-04 | [Qualified Control Input](after_four_core_04_qualified_control_input_sprint_1.md) | `NOT_READY_FOR_FRESH_INDEPENDENT_GATE_A_REVIEW` |

## 2. Evidence and closure index

| Stable reference | Current confirmed policy | Missing evidence/input | Responsible input source | Owner decision required | CORE | Exact closure evidence | Closure class |
|---|---|---|---|---|---|---|---|
| `CORE01-BLK-PRICE` | `OWNER_CONFIRMED`: 28 Product identities, six groupings and presented option labels are approved by reference. | Final sellable Variant applicability, exact VND Price, channel/Branch scope and effective period for every row. | Owner-controlled commercial artifact. | Validate the complete commercial dataset; this is evidence closure, not a renewed menu choice. | 01 | One complete, dated, internally reconciled 28-row Product→Variant→Price→scope→effective-period artifact. | `OWNER_DECISION_REQUIRED` / logical commercial baseline |
| `CORE-OD-03` | Integer VND representation is preserved; tax treatment/display is deferred. | Applicable Vietnamese tax treatment and display constraints for seller, items and channels. | Qualified Vietnamese Tax/Accounting professional input. | Select policy within qualified constraints. | 01 | Qualified memorandum plus recorded Owner decision. | `QUALIFIED_INPUT_REQUIRED` |
| `CORE-OD-04` | No rounding behavior is inferred. | Precision, rounding mode, boundary and sequence. | Qualified Accounting/commercial input. | Select policy within qualified constraints. | 01 | Qualified analysis plus recorded Owner decision. | `QUALIFIED_INPUT_REQUIRED` |
| `CORE02-BLK-EVIDENCE` | Model A is fail-closed; only sufficient approved evidence supports `transferred`. | Evidence-source classes, attester authority, recipient linkage and positive-release sufficiency. | Operations, Identity/Governance and Privacy input. | Approve admissibility, sufficiency and authority boundaries. | 02 | Decision record covering every evidence category and negative scenario. | `QUALIFIED_INPUT_REQUIRED` / `OWNER_DECISION_REQUIRED` |
| `CORE02-BLK-DISPOSITION` | Conflicting/disputed evidence cannot be silently replaced or upgraded. | Conflict taxonomy, evaluator/disposition authority and admissible outcomes. | Operations, Identity/Governance, Privacy and applicable legal input. | Approve disposition authority and outcomes. | 02 | Recorded fail-closed conflict policy consistent with Model A. | `OWNER_DECISION_REQUIRED` |
| `CORE-OD-12` | `OWNER_DECISION_REQUIRED`: acknowledgement and Close are separate under confirmed `CORE-OD-14B`; `CORE-OD-12` does not yet establish distinct Open, Count or Handover capabilities or decide whether Cash operations may share a capability. | Capability boundaries, assignment, Branch scope, delegation, revocation, emergencies and separation. | Cash/Accounting controls plus Identity/Governance. | Decide the capability-sharing/separation matrix; no person is appointed by this package. | 04 | Recorded authority matrix identifying which operations require distinct or shared capabilities, with assignment and control boundaries. | `QUALIFIED_INPUT_REQUIRED` / `OWNER_DECISION_REQUIRED`; operation-specific separation is `PROPOSED_NOT_APPROVED` |
| `CORE-OD-13` | Closed evidence is immutable; any correction is a linked fact. | Permitted operations, initiator/approver/executor, reason/evidence and consequences. | Cash/Accounting/Reporting input. | Approve bounded correction policy. | 04 | Recorded operation catalogue and authority/evidence matrix. | `QUALIFIED_INPUT_REQUIRED` / `OWNER_DECISION_REQUIRED` |
| `CORE04-BLK-DISCREPANCY` | Every nonzero discrepancy has reason and Owner notification; no tolerance. | Investigation categories/evidence, escalation and disposition authority. | Cash/Accounting/Reporting input. | Approve investigation/disposition policy without tolerance. | 04 | Recorded policy preserving unresolved-case hold and linked-correction dependency. | `QUALIFIED_INPUT_REQUIRED` / `OWNER_DECISION_REQUIRED` |
| `CORE04-BLK-RELEASE` | Unreconciled data is withheld; discrepancy disposition does not grant release. | Reconciliation sufficiency and separate report-release authority. | Accounting/Reporting controls. | Approve release boundary. | 04/05 | Recorded reconciliation and release matrix. | `QUALIFIED_INPUT_REQUIRED` / `OWNER_DECISION_REQUIRED` |
| `CORE-OD-16B` | Source-lineage approval grants no read authority. | Reader capability, Branch scope and purpose. | Identity/Governance/Privacy input. | Approve reader matrix. | 04/05 | Recorded least-privilege read policy. | `QUALIFIED_INPUT_REQUIRED` / `OWNER_DECISION_REQUIRED` |
| `CORE-OD-16F` | No retention period or legal-hold behavior is approved. | Retention, disposal and legal-hold requirements. | Qualified Legal/Privacy/Accounting-records input. | Approve remaining policy choices. | 04/05 | Qualified memorandum plus recorded Owner decision. | `QUALIFIED_INPUT_REQUIRED` |

## 3. Dependency and parallelism

- `VERIFIED_REPOSITORY_EVIDENCE` — CORE-01 commercial evidence, CORE-02 custody policy, and CORE-04 controls can be prepared in parallel; none is blocked merely by another CORE remaining open.
- `OWNER_DECISION_REQUIRED` — CORE-01 depends internally on commercial evidence plus `CORE-OD-03/04`; CORE-02 depends internally on evidence/admissibility and conflict disposition; CORE-04 depends internally on control and authority closure.
- `QUALIFIED_INPUT_REQUIRED` — Tax/Accounting, Identity/Governance/Privacy, Cash/Accounting/Reporting, and Legal/Privacy inputs are separate disciplines and must not be represented as already obtained.
- `GATE_B_DEFERRED` — Physical schema, migrations, indexes, constraints, locks, transactions, APIs, workers, identity mechanisms, evidence devices, retention jobs and runtime enforcement wait for a reviewed Gate A baseline and exact Gate B authorization.

## 4. Sources reviewed

`VERIFIED_REPOSITORY_EVIDENCE` — Review covered `AGENTS.md`; `GLOSSARY.md`; ADR-0011; the [Owner Decision Baseline](../architecture/after_four_owner_decision_baseline.md); Proposed Launch Menu v3; Real Menu and Pricing Specification; Catalog/Pricing discovery; the current Core Operations Design Package and remediation; CORE-01 Sprint 2 evidence; CORE-02 accelerated remediation; the merged post-Owner readiness sprint; and relevant Cash, Reporting and Identity governance sections referenced by those documents.

## 5. Governance boundary

`VERIFIED_REPOSITORY_EVIDENCE` — The register remains 28 confirmed / 6 deferred. Deferred references remain `CORE-OD-03`, `CORE-OD-04`, `CORE-OD-12`, `CORE-OD-13`, `CORE-OD-16B`, and `CORE-OD-16F`. `CORE-OD-11B`, `CORE-OD-14A/B`, and `CORE02-FIR2-02` remain confirmed. All three COREs remain not ready for fresh independent Gate A review.

`VERIFIED_REPOSITORY_EVIDENCE` — No external professional advice was obtained. No ODB ID, Owner decision, authority assignment, Gate, schema, migration, database, code, API, UI, service, Identity Milestone 2B, FOA or Production Authorization is created by these packages. Inventory remains deferred.

**Final status:** `QUALIFIED_INPUT_PACKAGES_PREPARED — INPUTS_NOT_OBTAINED — CORE_01_02_04_NOT_READY — NO_GATE_OR_IMPLEMENTATION_AUTHORIZED`
