# AFTER FOUR — CORE-02 Qualified Custody Evidence — Sprint 1

**Assessment date:** 2026-11-24 (Asia/Tokyo)

**Baseline:** `main` at `ad7e7bf973233e0286c91af2a1b7bbb27d817d25`

**Authority:** documentation and evidence-question preparation only

**Readiness:** `NOT_READY_FOR_FRESH_INDEPENDENT_GATE_A_REVIEW`

> **SUBSEQUENT CURRENT STATUS — 2026-11-25.** The Owner attests that the First Branch has not operated and confirms an ordinary customer-handover `DESIRED_PROCESS`: whole-Ticket readiness, pending handover under stable Order/Ticket identity, intended-customer or authorized-recipient relationship before release, recipient confirmation, attributable handover record, and completion only after approved evidence criteria are met. This supplies no actual event or documentary operational proof and does not select evidence classes, recipient-linkage validation, attester authority/sufficiency/separation, positive threshold, conflict disposition, access, retention or a technical mechanism. The qualified questions below therefore remain open and this package remains not ready for fresh independent review.

> **PUBLIC-SOURCE CLOSURE PASS — 2026-11-25.** Law 91/2025/QH15 and Decree 356/2025/NĐ-CP establish the current personal-data baseline: purpose limitation, data minimization, accountable protection, controlled access, data-subject handling and lifecycle governance must be applied to any custody evidence that contains personal data. Public law does not select an AFTER FOUR evidence class, attester, intended-recipient proof, positive sufficiency threshold, conflict resolver or customer consequence, and no First Branch event exists. `WS-C02-01`–`07` therefore remain primarily `OWNER_DECISION_REQUIRED` and, for later real controls/effectiveness, `ACTUAL_OPERATIONAL_EVIDENCE_REQUIRED`; unresolved applicability questions remain explicit rather than being presented as professional advice. No external professional engagement is planned.

## 1. Confirmed logical boundary

`OWNER_CONFIRMED` — `CORE02-FIR2-02` Model A keeps `transfer_evidence_unresolved` nonterminal within the same stable attempt. Conflicting/disputed evidence remains fail-closed; later evidence cannot silently supersede, erase or upgrade it. `transferred` requires sufficient approved evidence and authorized disposition of every conflict/dispute. Evidence history, provenance, revisions, actors, timestamps and prior outcomes remain auditable.

`OWNER_CONFIRMED` — `CORE-OD-10C` requires settled Payment, completed Preparation, authoritative customer custody-transfer evidence and no open exception for bounded closure eligibility. Handover evidence does not execute Order closure. Acknowledgement, refusal, disagreement, custody transfer, cancellation, Refund, Cash close and Order completion remain distinct.

`NOT_FOUND_IN_REVIEWED_SOURCES` — The [Owner Decision Baseline](../architecture/after_four_owner_decision_baseline.md), [CORE-02 remediation](after_four_core_02_accelerated_design_remediation.md), [Core Operations Design Package](after_four_accelerated_core_operations_design_package.md), and [post-Owner readiness report](after_four_post_owner_decision_readiness_sprint.md) do not select trusted evidence-source classes, attester authority, intended-recipient linkage rules or conflict/dispute disposition authority.

## 2. Decision and evidence matrix

Candidate alternatives are decision shapes, not selected mechanisms. They are all `PROPOSED_NOT_APPROVED`.

| Category | Existing confirmed invariant | Candidate policy alternatives | Evidence needed | Qualified input | Owner decision required | Gate B boundary |
|---|---|---|---|---|---|---|
| Trusted evidence-source classes | Only sufficient approved evidence can support `transferred`; transport success or command invocation is insufficient. | A: one explicitly approved authoritative business-evidence class. B: a defined set of corroborating classes whose combination is sufficient. C: scope-specific classes for ordinary and exception handling. | Operational process map; source provenance; error/abuse cases; availability and dispute characteristics; accountable system/process owner. | `QUALIFIED_INPUT_REQUIRED` — Operations plus Identity/Governance/Privacy review. | `OWNER_DECISION_REQUIRED` — approve admissible classes and sufficiency policy. | `GATE_B_DEFERRED` — no signature, OTP, QR, photograph, GPS, device or API is selected. |
| Accountable attester authority | Authentication alone grants no attestation authority. | A: one explicit capability for an accountable attester. B: corroborated attestations with defined separation. C: no attester assertion is sufficient without another approved evidence class. | Candidate operational responsibilities, scope, conflict risks, separation needs and unavailable-actor cases. | `QUALIFIED_INPUT_REQUIRED` — Operations and Identity/Governance. | `OWNER_DECISION_REQUIRED` — approve authority boundary; no person or role is assigned here. | `GATE_B_DEFERRED` — capability representation and enforcement. |
| Intended-recipient linkage | Release must be linked to the intended customer or separately authorized recipient; a generic acknowledgement is insufficient. | A: direct intended-recipient verification under an approved business rule. B: explicitly authorized representative path. C: exception hold when linkage cannot be established. | Recipient scenarios, authorization basis, privacy minimization, mismatch/dispute cases and evidence retention needs. | `QUALIFIED_INPUT_REQUIRED` — Operations, Identity/Governance and Privacy. | `OWNER_DECISION_REQUIRED` — approve eligible recipient relationships and exception boundary. | `GATE_B_DEFERRED` — identity scheme and verification mechanism. |
| Positive actual-release evidence | `transferred` requires positive evidence of actual release after whole-Ticket completion. | A: one approved positive evidence class. B: defined corroborating evidence set. C: higher evidence threshold for specified risk/exception scenarios. | False-positive/negative analysis, operational feasibility, accessibility, provenance and auditability. | `QUALIFIED_INPUT_REQUIRED` — Operations, Governance/Privacy where personal evidence is involved. | `OWNER_DECISION_REQUIRED` — define sufficiency by scenario. | `GATE_B_DEFERRED` — capture channel, storage and validation. |
| Negative and ambiguous outcomes | Refusal, disputed identity, unavailable recipient, conflict or unverifiable release cannot become `transferred`. | A: remain `transfer_evidence_unresolved` pending valid evidence. B: remain held and escalate under a separately approved exception policy. C: terminate only under a separately approved outcome that does not assert transfer. | Complete scenario catalogue, customer-service consequences, accountability and downstream Order implications. | `QUALIFIED_INPUT_REQUIRED` — Operations, Governance and Privacy. | `OWNER_DECISION_REQUIRED` — approve dispositions; no automatic recovery is authorized. | `GATE_B_DEFERRED` — workflow/state persistence and notifications. |
| Conflict/dispute disposition | Conflict remains held; replay or later evidence cannot silently resolve it. | A: Owner-only disposition. B: explicitly delegated, scope-bounded disposition with separation and escalation. C: defined cases remain unresolved until external/qualified evidence exists. | Conflict taxonomy, materiality, abuse/fraud risk, evidence standards, separation requirements and consequences of no resolution. | `QUALIFIED_INPUT_REQUIRED` — Operations, Identity/Governance, Privacy and any applicable legal input. | `OWNER_DECISION_REQUIRED` — select disposition authority and admissible outcomes. | `GATE_B_DEFERRED` — case workflow, locking, concurrency and enforcement. |
| Provenance, history and audit | Evidence and all prior outcomes remain immutable and auditable. | A: one common minimum evidence envelope. B: common minimum plus source-specific fields. C: enhanced evidence for disputes/exceptions. | Required facts, purpose, access, correction model, retention constraints and legal/privacy limitations. | `QUALIFIED_INPUT_REQUIRED` — Governance/Privacy/Legal and Operations. | `OWNER_DECISION_REQUIRED` where policy choices remain after qualified constraints. | `GATE_B_DEFERRED` — schema, storage, encryption, indexes and retention jobs. |

## 3. Scenario questions for qualified review

| Scenario | Confirmed behavior | Required input before an Owner decision |
|---|---|---|
| Ordinary intended customer available | `transferred` still requires approved positive evidence. | Candidate evidence classes, accountable attester boundary and recipient-linkage rule. |
| Authorized representative | No representative authority is inferred. | Business/legal basis, scope, verification and evidence requirements. |
| Recipient unavailable | Remain fail-closed; no silent transfer. | Operational hold/escalation choices and customer-service consequence. |
| Identity disputed or mismatched | Remain held; later assertion cannot erase conflict. | Conflict taxonomy, privacy-safe evidence and disposition authority. |
| Refusal | Refusal is evidence, not transfer or terminal Order closure. | Permitted operational consequences and escalation. |
| Conflicting evidence revisions | Preserve every revision and prior outcome. | Authorized evaluator/disposition, sufficiency standard and audit requirements. |
| Lost response or replay | Same stable attempt returns known evidence/outcome or remains unresolved. | No new policy needed for replay; physical lookup/idempotency is Gate B. |

## 4. Closure evidence and boundary

`OWNER_DECISION_REQUIRED` — CORE-02 can enter a fresh independent Gate A review only when recorded decisions, supported by the identified qualified inputs, establish admissible evidence classes, attester authority, intended-recipient linkage, positive-release sufficiency, negative/ambiguous dispositions, conflict authority and provenance requirements without changing Model A or `CORE-OD-10C`.

`GATE_B_DEFERRED` — Physical evidence capture, identity scheme, persistence, encryption, transaction/isolation, locking, transport, API, device and concurrency mechanisms remain outside this sprint. `VERIFIED_REPOSITORY_EVIDENCE` — no professional input was obtained and no attester, resolver, person or role was selected.
