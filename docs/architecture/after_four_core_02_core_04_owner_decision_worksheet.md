# AFTER FOUR — CORE-02 / CORE-04 Owner Decision Worksheet

**Prepared:** 2026-11-24 (Asia/Tokyo)

**Status:** `OWNER_INPUT_REQUIRED — NO ANSWERS RECORDED`

**Authority:** Business-policy worksheet only; local `WS-*` references are not canonical `ODB-*` identifiers.

## 1. How to use this worksheet

For every question, the Owner may select one listed alternative, write an Owner-defined alternative, or select `DEFER`. Blank answer fields are intentional. Listed alternatives are `PROPOSED_NOT_APPROVED`; none is a recommendation already approved. Technical capture, identity scheme, API, storage, transactions, locking, enforcement, and runtime authorization remain later Gate work.

## 2. Confirmed boundaries that are not reopened

- CORE-02: Item-level progress; no quantity-level progress, partial Ticket completion, or partial handover. Preparation completion, acknowledgement, customer custody transfer, Order closure, Payment settlement, and Refund authority are distinct. Model A keeps `transfer_evidence_unresolved` nonterminal and fail-closed in the same stable attempt. Acknowledgement, authentication, command invocation, transport success, or absence of refusal does not prove transfer. Candidate Ticket/Items without exact accepted binding remain quarantined. See [Owner Decision Baseline](after_four_owner_decision_baseline.md) and [CORE-02 qualified evidence §§1–2](../research/after_four_core_02_qualified_custody_evidence_sprint_1.md#1-confirmed-logical-boundary).
- CORE-04: Cash Session handover records the approved evidence; acknowledgement is not approval or Close. Refusal/disagreement escalates to Owner. Close is separate. Closed evidence is immutable and correction is a linked fact, never reopening or rewriting. Every nonzero discrepancy requires reason and Owner notification; there is no tolerance. Unreconciled Cash facts remain held from authoritative reporting, and discrepancy disposition does not grant report release. See [Owner Decision Baseline](after_four_owner_decision_baseline.md) and [CORE-04 qualified input §1](../research/after_four_core_04_qualified_control_input_sprint_1.md#1-preserved-confirmed-policy).

## 3. CORE-02 — customer acceptance and custody transfer

All seven questions require operational evidence and the stated governance/privacy input before a defensible final selection. No OTP, QR, photograph, GPS, device, signature, job title, or named person is selected.

| ID | Owner question | Supported choices | Consequence of choice or deferral | Dependencies and source |
|---|---|---|---|---|
| `WS-C02-01` | Những lớp bằng chứng kinh doanh nào được chấp nhận để chứng minh giao thực tế? | A: one authoritative class; B: predefined corroborating set; C: scenario-specific ordinary/exception classes; Owner-defined; `DEFER`. | Must define provenance, error/abuse and availability. Deferral keeps custody transfer and closure fail-closed. | Operations plus Identity/Governance/Privacy input; [qualified matrix](../research/after_four_core_02_qualified_custody_evidence_sprint_1.md#2-decision-and-evidence-matrix). |
| `WS-C02-02` | Ranh giới attestation policy là gì? Decide each dimension independently: **authority** — explicit scoped capability, another Owner-defined authority, or `DEFER`; **sufficiency** — one authorized attestation is sufficient, corroborating evidence is required, attestation is never sufficient alone, Owner-defined, or `DEFER`; **separation** — delivery actor and attester must be independent, may coincide only in explicitly approved cases, no separation requirement, Owner-defined, or `DEFER`. | One selection is required per dimension; every listed selection is `PROPOSED_NOT_APPROVED`. Dimensions are not mutually substitutable: authority does not decide sufficiency or separation. | Authentication grants no authority. Deferring any dimension leaves that part of the attestation policy unresolved and fail-closed. | Operational responsibility/conflict evidence; `WS-C02-01`; [qualified matrix](../research/after_four_core_02_qualified_custody_evidence_sprint_1.md#2-decision-and-evidence-matrix). |
| `WS-C02-03` | Liên kết người nhận thực tế với khách dự kiến hoặc người nhận được ủy quyền như thế nào? | A: direct intended-customer rule; B: explicit authorized-representative path; C: fail-closed hold when linkage is absent; Owner-defined; `DEFER`. | No choice selects identity technology. Deferral blocks `transferred` when linkage is unproved. | Operations, Identity/Governance, Privacy; recipient scenarios and authorization basis. |
| `WS-C02-04` | Mức bằng chứng dương tối thiểu nào đủ để ghi `transferred`? | A: one approved positive class; B: defined corroborating set; C: higher threshold for specified risks; Owner-defined; `DEFER`. | Applies only after whole-Ticket completion. Deferral creates no transfer fact. | Depends on `WS-C02-01`–`03`; false-positive/negative and operational evidence. |
| `WS-C02-05` | Mỗi refusal/absence/evidence-unavailable/ambiguous-or-unverifiable/mismatch/conflict scenario nhận handling nào theo scenario matrix dưới đây? | For each scenario: retain the confirmed nonterminal handling; select an escalation policy only where supported; Owner-defined; or `DEFER`. A new terminal non-transfer outcome is not selectable without separate governance review and reconciliation with Model A. | No handling may silently transfer, close Order, authorize Refund, create automatic recovery, or erase/upgrade conflicting evidence. | Complete scenario catalogue and downstream consequences; [scenario questions](../research/after_four_core_02_qualified_custody_evidence_sprint_1.md#3-scenario-questions-for-qualified-review). |
| `WS-C02-06` | Ai hoặc authority boundary nào được disposition conflict/dispute? | A: Owner-only; B: explicit scope-bounded delegation with separation/escalation; C: defined cases remain unresolved pending qualified evidence; Owner-defined; `DEFER`. | Model A already requires authorized disposition; deferral keeps the attempt held. No role is inferred. | Conflict taxonomy, materiality, abuse/fraud and separation evidence; coordinate with `WS-C02-05/07`. |
| `WS-C02-07` | Minimum provenance, revision, and history envelope nào bắt buộc? | A: common minimum; B: common minimum plus source-specific facts; C: enhanced envelope for disputes/exceptions; Owner-defined; `DEFER`. | Immutable/auditable history is fixed; access, correction, retention and privacy details remain open. | Governance/Privacy/Legal and Operations input; physical schema/encryption/jobs remain Gate B. |

### `WS-C02-05` scenario and disposition matrix

| Scenario | Current confirmed boundary | Permitted nonterminal handling | Escalation status | Prohibited consequence | Input still required |
|---|---|---|---|---|---|
| Customer refusal | Refusal is evidence, not custody transfer. | Keep the same stable attempt at `transfer_evidence_unresolved` while valid evidence or authorized disposition remains pending. | Exact escalation/consequence remains unresolved. | No `transferred`, Order close, Refund authority, or evidence deletion. | Operations scenario and customer consequence; Owner policy. |
| Recipient absent or unavailable | Absence establishes no transfer fact. | Retain nonterminal unresolved state; preserve attempt/evidence. | Escalation timing/path remains unresolved. | No invented acknowledgement, transfer, new attempt, or automatic recovery. | Operations availability/escalation evidence; Owner policy. |
| Required evidence unavailable | Missing evidence fails closed. | Retain nonterminal unresolved state pending admissible evidence. | Whether/when to escalate remains unresolved. | Timeout or transport result cannot create transfer or replace the attempt. | Evidence availability and operating-continuity input. |
| Ambiguous or unverifiable release | Unverifiable release is not `transferred`. | Retain reason and supplied evidence as unresolved. | Exception/escalation policy remains unresolved. | No silent upgrade, Order close, or Refund authority. | Evidence criteria, false-positive/negative analysis, Owner policy. |
| Intended-recipient mismatch | Mismatch fails closed and proves no valid recipient linkage. | Hold the same attempt unresolved. | Escalation and customer-service consequence remain unresolved. | No substitution of a generic acknowledgement for recipient linkage. | Identity/Governance/Privacy and Operations input. |
| Conflicting or disputed evidence | Model A requires append-only preservation and authorized conflict disposition. | Keep the same attempt held and unresolved; later evidence may be evaluated but cannot overwrite history. | Disposition authority is `WS-C02-06`; no authority is inferred. | No erase, supersede, upgrade, replay-based resolution, new bypass attempt, or automatic `transferred`. | Conflict taxonomy, evidence standards, separation and Owner decision. |

Any proposed terminal non-transfer outcome remains `PROPOSED_NOT_APPROVED` and cannot be offered for immediate selection until governance review reconciles its terminality with Owner-confirmed Model A.

### Dispatch/acceptance lifecycle — confirmed, not a new ballot

Acceptance uses stable Dispatch plus acceptance-attempt identity. `accepted` and `rejected_terminal` are mutually exclusive immutable terminal outcomes; `held_unresolved` is nonterminal. A candidate Ticket/Item set without proven exact accepted binding cannot start, progress, complete, or hand over.

- **`accepted`:** Candidate Ticket/Items may leave quarantine only when authoritative evidence proves the exact accepted binding under the confirmed acceptance policy. An arbitrary disposition cannot substitute for that binding.
- **`held_unresolved`:** Candidate Ticket/Items remain quarantined. Release may be considered only after authoritative evidence and the applicable separately authorized resolution/disposition establish the exact accepted binding. Retry, transport success, or late evidence alone does not turn the attempt into `accepted`.
- **`rejected_terminal`:** Candidate Ticket/Items remain quarantined for that attempt. New evidence cannot release them by reopening, rewriting, superseding, or silently replacing the terminal outcome. Any new business request requires a separately Owner/governance-approved policy; this worksheet creates no retry or bypass mechanism.

Resolver authority remains `RECOMMENDATION_NOT_ESTABLISHED`. See [CORE-02 remediation §5](../research/after_four_core_02_accelerated_design_remediation.md#5-dispatch-acceptance-contract).

### Customer custody-transfer lifecycle — confirmed, not a new ballot

Customer custody transfer has its own stable attempt/evidence history and the distinct dispositions `transfer_evidence_unresolved` and `transferred`. Acknowledgement is not transfer, and an accepted Dispatch does not prove that the customer or authorized recipient received the Ticket. Acceptance retry never edits or overwrites custody-transfer history. Custody-transfer retry/evidence progression never changes the immutable acceptance terminal outcome. Neither lifecycle may substitute as evidence for the other.

## 4. CORE-04 — Cash control, reconciliation, and reporting

`Reopen` is not an option: immutable-close policy permits only separately attributable linked correction facts. The worksheet assigns no human, generic role, delegate, resolver, or report authority.

| ID | Owner question | Supported choices | Consequence of choice or deferral | Dependencies and source |
|---|---|---|---|---|
| `WS-C04-01` | Với từng operation Open, Count, Handover, Close, reconciliation và discrepancy disposition, authority source nào cấp quyền và holder boundary nào đủ điều kiện? | Per-operation explicit authority source/holder boundary; one governing authority source with separately enumerated holder rules per operation; Owner-defined; `DEFER`. All are `PROPOSED_NOT_APPROVED`. | This question identifies where authority comes from and who may hold it; it does not decide incompatible-role combinations. Deferral keeps affected commands unauthorized/fail-closed. | Cash/Accounting responsibility evidence; Identity enforcement is later; [CORE-04 qualified control input](../research/after_four_core_04_qualified_control_input_sprint_1.md). |
| `WS-C04-02` | Operation nào có thể được delegation; ai delegates; Branch/time scope, expiry, revocation và emergency boundary là gì? | No delegation/emergency path; bounded operation-specific delegation; separately enumerated emergency path; Owner-defined; `DEFER`. | No default delegation or emergency authority. | Depends on `WS-C04-01` and control evidence. |
| `WS-C04-03` | Sau khi authority source/holder boundary được xác định, những requester/actor/counter/reviewer/approver/resolver combinations nào bị cấm hoặc bắt buộc độc lập? | Strict separation; risk-tiered separation; same actor only for enumerated low-risk cases with independent evidence; Owner-defined; `DEFER`. All are `PROPOSED_NOT_APPROVED`. | This question decides incompatible combinations only; it does not assign the authority source or holder. Expense self-approval policy cannot be generalized. | Depends on the authority boundaries from `WS-C04-01/02` and Accounting/control input. |
| `WS-C04-04` | Những linked post-close correction operations nào được phép, và ai initiates/approves/executes với evidence/consequence nào? | No correction operation in initial slice; bounded enumerated linked corrections; Owner-defined; `DEFER`. | Closed facts never reopen/rewrite. Deferral holds errors and may block authoritative reports. | `CORE-OD-13`; depends on `WS-C04-01/03` plus Cash/Accounting/Reporting input; [CORE-04 qualified control input](../research/after_four_core_04_qualified_control_input_sprint_1.md). |
| `WS-C04-05` | Evidence nào hoàn tất escalation-to-Owner cho handover refusal/disagreement, authority nào có thể disposition sau escalation, và consequence nào được phép? | `PROPOSED_NOT_APPROVED`: Owner disposition for this handover case; explicitly delegated operation-specific disposition with Owner escalation retained; remain held; Owner-defined; `DEFER`. | Escalation destination is confirmed, but it does not make Owner the default resolver for every discrepancy or resolution type. Acknowledgement is not approval/Close; resolution does not silently Close, correct, disposition another discrepancy, or release reports. | Any delegated authority depends on `WS-C04-01/02`; preserve `CORE-OD-14A/B`. |
| `WS-C04-06` | Discrepancy classes, investigation evidence, escalation, resolver/disposition authority và consequences là gì? | `RECOMMENDATION_NOT_ESTABLISHED`; Owner-defined after qualified input; `DEFER`. | Every nonzero discrepancy still requires recording/reason/Owner notification and no tolerance. | Cash/Accounting/Reporting input; linked correction depends on `WS-C04-04`; [CORE-04 qualified control input](../research/after_four_core_04_qualified_control_input_sprint_1.md). |
| `WS-C04-07` | Evidence authoritative nào làm Cash Session/Operating Day được coi là reconciled? | `RECOMMENDATION_NOT_ESTABLISHED`; Owner-defined after qualified input; `DEFER`. | Must preserve unresolved cases and correction lineage. Reconciliation does not grant report release. | Accounting/Reporting lineage input; precedes `WS-C04-08`. |
| `WS-C04-08` | Có exception release không; ai independently reviews/releases Cash-dependent authoritative reporting, với annotation/evidence/limits nào? | No exception release; bounded annotated release after separate review; Owner-only exception; Owner-defined; `DEFER`. | Discrepancy resolution grants no release. Release grants no read/export/delivery authority. | Depends on reconciliation/disposition evidence, not generic Cash capability; [CORE-04 qualified control input](../research/after_four_core_04_qualified_control_input_sprint_1.md). |
| `WS-C04-09` | Ai được đọc report nào, cho Branch và purpose nào? | No reader; Owner-only bounded reader; delegated purpose/Branch capability after governance input; Owner-defined; `DEFER`. | Deferral grants no report-read authority. | `CORE-OD-16B`; Identity/Governance/Privacy input. |
| `WS-C04-10` | Retention period, disposal trigger, legal hold condition và authority nào áp dụng? | `RECOMMENDATION_NOT_ESTABLISHED`; Owner-defined after qualified input; `DEFER`. | No duration or holder may be inferred. | `CORE-OD-16F`; qualified Legal/Privacy/Accounting-records input. |

## 5. Decision record — Owner fills this section

| Worksheet ID | Owner answer / Owner-defined alternative | Decision date | Rationale / notes | Follow-up evidence required |
|---|---|---|---|---|
| `WS-C02-01` |  |  |  |  |
| `WS-C02-02` |  |  |  |  |
| `WS-C02-03` |  |  |  |  |
| `WS-C02-04` |  |  |  |  |
| `WS-C02-05` |  |  |  |  |
| `WS-C02-06` |  |  |  |  |
| `WS-C02-07` |  |  |  |  |
| `WS-C04-01` |  |  |  |  |
| `WS-C04-02` |  |  |  |  |
| `WS-C04-03` |  |  |  |  |
| `WS-C04-04` |  |  |  |  |
| `WS-C04-05` |  |  |  |  |
| `WS-C04-06` |  |  |  |  |
| `WS-C04-07` |  |  |  |  |
| `WS-C04-08` |  |  |  |  |
| `WS-C04-09` |  |  |  |  |
| `WS-C04-10` |  |  |  |  |

## 6. Session ordering and authority boundary

Review `WS-C02-01/02/03/07` in parallel, then `04`, then coordinate `05/06`. Review `WS-C04-01/02/03` first; `04` and `06` can then be answered independently but together; `07` precedes `08`; `09/10` remain separate governance questions. Deferral creates no default authority or business outcome. Completing this worksheet records policy input only and grants no canonical ODB allocation, Gate A/B/C, implementation, Identity Milestone 2B, FOA, or Production Authorization.
