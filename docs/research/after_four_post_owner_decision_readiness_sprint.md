# AFTER FOUR — Post-Owner-Decision Readiness Sprint

**Assessment date:** 2026-11-24 (Asia/Tokyo)

**Repository baseline:** `047cbd127051b12d75d6f89cde4ad9b6bb162189`

**Scope:** Documentation/design-readiness reconciliation only

**Gate or implementation authority created:** `NONE`

## 1. Executive result

The merged Owner session confirms 28 of 34 local `CORE-OD-*` references and defers six: `CORE-OD-03`, `CORE-OD-04`, `CORE-OD-12`, `CORE-OD-13`, `CORE-OD-16B`, and `CORE-OD-16F`. All remain `ID_PENDING_OWNER_GOVERNANCE`. `CORE02-FIR2-02` separately confirms Model A and is not part of the 34-reference count. The [Owner Decision Baseline](../architecture/after_four_owner_decision_baseline.md) remains authoritative.

| CORE | Readiness conclusion | Controlling reason |
|---|---|---|
| CORE-01 | `NOT_READY_FOR_FRESH_INDEPENDENT_GATE_A_REVIEW` | Final sellable Variant applicability and exact Price/effective-period/scope evidence are each absent for all 28 approved Product rows; `CORE-OD-03/04` require qualified input. |
| CORE-02 | `NOT_READY_FOR_FRESH_INDEPENDENT_GATE_A_REVIEW` | Model A is logically synchronized, but trusted evidence-source classes, attester authority, intended-recipient linkage and conflict/dispute disposition authority remain unresolved. |
| CORE-04 | `NOT_READY_FOR_FRESH_INDEPENDENT_GATE_A_REVIEW` | The initial `00:00` Branch-local cutoff is closed, but capability, correction, disagreement-resolution, discrepancy disposition, reporting release, reader and retention boundaries remain material blockers. |

No conclusion above grants Gate A, Gate B, Gate C, implementation, Identity Milestone 2B, FOA, or Production Authorization.

## 2. Owner-decision synchronization

Current documents now preserve these merged facts:

- `CORE-OD-11B`: the initial cutoff is `00:00` local time in each Branch's explicitly configured timezone. The first Hoi An Branch uses `Asia/Ho_Chi_Minh`; there is no MVP inheritance. Future per-Branch configurable cutoff is product direction only, not schema, migration, configuration, or runtime authority.
- `CORE02-FIR2-02`: `transfer_evidence_unresolved` is nonterminal within the same stable attempt. Later evidence may be retained, but cannot silently supersede conflicting/disputed evidence. `transferred` requires sufficient approved evidence and authorized conflict/dispute disposition.
- Historical review reports retain their original as-of findings. Current-state corrections are limited to current design, architecture, remediation and readiness documents.

## 3. CORE-01 commercial evidence

### 3.1 Source-to-Product/Variant/Price matrix

The full 28-row identity audit is retained in [CORE-01 Commercial Evidence Closure Sprint 2 §2](after_four_core_01_commercial_evidence_closure_sprint_2.md#2-complete-product-and-option-reconciliation). Rechecking the approved menu against repository evidence produces the following non-duplicative matrix. The applicability figures count Product rows with authoritative final-Variant evidence; they do not assert a Variant denominator, which cannot yet be stated responsibly.

| Approved grouping | Product rows | Identity/grouping | Final sellable Variant applicability | Exact VND Price by Variant | Scope/effective period |
|---|---:|---|---|---|---|
| Cà phê | 6 | 6/6 Owner-approved by reference | 0/6 authoritative rows | 0/6 authoritative rows | 0/6 authoritative rows |
| Trà trái cây | 5 | 5/5 Owner-approved by reference | 0/5 | 0/5 | 0/5 |
| Nước ép và giải khát | 4 | 4/4 Owner-approved by reference | 0/4 | 0/4 | 0/4 |
| Sinh tố và đá xay | 4 | 4/4 Owner-approved by reference | 0/4 | 0/4 | 0/4 |
| Thức uống khác | 3 | 3/3 Owner-approved by reference | 0/3 | 0/3 | 0/3 |
| Bánh và đồ ăn nhẹ | 6 | 6/6 Owner-approved by reference | 0/6 | 0/6 | 0/6 |
| **Total** | **28** | **28/28** | **0/28** | **0/28** | **0/28** |

The approved approximate bands and displayed option labels are not executable Price rows or final Variant mappings. Demo fixtures, synthetic specs and illustrative Latte values are non-authoritative. Required closure evidence is an Owner-controlled complete Product→sellable-Variant→Price dataset with chain/Branch/channel scope and effective periods, plus qualified Vietnamese Tax/Accounting input for tax display/treatment and monetary rounding boundaries under deferred `CORE-OD-03/04`.

### 3.2 Logical contracts already closed

Catalog owns Product/Variant/Price truth; Ordering binds each Draft line to one Price version, does not silently reprice unrelated mutations, and requires explicit re-quote/revalidation plus review when authoritative Price changes. Confirmed Orders retain sold snapshots, and Payment receives the confirmed authoritative total. Physical concurrency, locking, persistence and uniqueness enforcement remain later Gate B concerns.

## 4. CORE-02 Model A closure

| Invariant | Current logical contract | Remaining authority/evidence |
|---|---|---|
| Attempt identity | Dispatch and acceptance/handover attempts have stable identities; same-attempt retry is replay/lookup. | Conditions and authority for a genuinely new attempt remain separately governed. |
| Acceptance outcomes | `held_unresolved` is nonterminal; exactly one immutable `accepted` or `rejected_terminal` outcome may follow. | Physical persistence/concurrency is Gate B. |
| Ticket uniqueness | Candidate Ticket/Items remain quarantined until exact accepted binding is proven; one accepted Dispatch produces one valid Ticket and Item set. | Physical uniqueness/enforcement is Gate B. |
| Custody evidence | `transfer_evidence_unresolved` may progress to `transferred` within the same stable attempt only after sufficient approved evidence and authorized disposition of every conflict/dispute. | Trusted evidence classes, attester authority, intended-recipient linkage and resolver authority are unresolved. |
| Closure | Settled Payment, completed Preparation, authoritative custody transfer and no open exception are all required; transfer evidence never executes Order closure by itself. | Ordering closure action remains separate; Refund, cancellation, Cash close and discrepancy disposition remain separate workflows. |

Acknowledgement, refusal, disagreement and customer custody transfer remain distinct. Replay, transport acknowledgement, authentication or repeated command cannot resolve conflicting evidence or create a bypass attempt.

## 5. CORE-04 control readiness

| Area | Confirmed policy | Unresolved boundary |
|---|---|---|
| Operating Day | Hoi An uses `Asia/Ho_Chi_Minh`; each Branch is explicit; initial cutoff `00:00` local; no MVP inheritance; exceptional evidence cannot rewrite a closed day. | Physical configuration, effective-time and enforcement design are Gate B concerns. |
| Cash capability | Operations remain distinct: Open, Count, Handover and Close. | `CORE-OD-12`: assignees, delegation, revocation, emergency paths and separation of duties. |
| Post-close correction | Closed evidence is immutable; correction, if authorized, is a linked fact. | `CORE-OD-13`: permitted operations, initiator/approver, evidence and consequences. |
| Handover | Acknowledgement/refusal/disagreement is evidence, not approval, custody transfer or Session closure; Close remains separate. | Detailed disagreement resolver/escalation and consequences; delegation depends on `CORE-OD-12`. |
| Discrepancy | Every nonzero discrepancy requires reason and Owner notification; no tolerance. | Classes, investigation, escalation, resolver/disposition and linked-correction details. |
| Reporting release | Unreconciled data is withheld; discrepancy resolution does not grant release authority. | Authoritative reconciliation and release authority; `CORE-OD-16B` readers/scope; `CORE-OD-16F` retention/disposal/legal hold. |

## 6. Consolidated blockers

| Stable blocker | CORE | Affected invariant | Responsible input | Closure condition |
|---|---|---|---|---|
| `CORE01-BLK-PRICE` | 01 | Deterministic Variant/Price resolution | Owner-controlled commercial evidence | Complete 28-row Variant/Price/scope/effective-period dataset reconciles without ambiguity. |
| `CORE-OD-03` | 01 | Tax treatment/display and sold snapshots | Qualified Vietnamese Tax/Accounting input, then Owner | Exact applicable treatment and display policy recorded. |
| `CORE-OD-04` | 01 | Monetary precision and rounding | Qualified Accounting/commercial input, then Owner | Precision, rounding method and boundary recorded. |
| `CORE02-BLK-EVIDENCE` | 02 | Authoritative custody transfer | Owner/qualified operational and Identity/Governance input | Evidence classes, attester authority and recipient-linkage rules recorded. |
| `CORE02-BLK-DISPOSITION` | 02 | Fail-closed Model A progression | Owner-authorized resolver policy | Conflict/dispute disposition authority and admissible outcome recorded. |
| `CORE-OD-12` | 04 | Cash command authority | Cash/Accounting control evidence, then Owner | Operation-specific capability, delegation/revocation/emergency and separation policy recorded. |
| `CORE-OD-13` | 04 | Immutable-close correction | Cash/Accounting/Reporting input, then Owner | Linked correction operations, authority, evidence and consequences recorded. |
| `CORE04-BLK-DISCREPANCY` | 04 | Reconciliation outcome | Qualified Cash/Accounting/Reporting input, then Owner | Investigation classes, escalation and resolver/disposition policy recorded. |
| `CORE04-BLK-RELEASE` | 04 | Authoritative reporting | Qualified Accounting/Reporting input, then Owner | Reconciliation and report-release authority recorded separately. |
| `CORE-OD-16B` | 04/05 | Report access | Identity/Governance/Privacy input, then Owner | Reader capability, Branch scope and purpose recorded. |
| `CORE-OD-16F` | 04/05 | Retention/legal hold | Legal/Privacy/Accounting-records input, then Owner | Retention, disposal and legal-hold policy recorded. |

## 7. Parallel plan and critical path

- **Lane A — commercial evidence:** transcribe and Owner-validate the 28-row dataset while qualified Tax/Accounting input addresses `CORE-OD-03/04`.
- **Lane B — Preparation evidence policy:** define evidence-source, attester and recipient-linkage candidates while the Owner separately resolves conflict/dispute disposition. No physical mechanism is selected.
- **Lane C — Cash controls:** obtain Cash/Accounting/Reporting inputs for `CORE-OD-12/13`, discrepancy disposition and report release; obtain Governance/Privacy/Legal inputs for `CORE-OD-16B/F` in parallel.
- **Gate-dependent work:** physical persistence, transactions, locking, indexes, workers, APIs, capabilities and runtime enforcement wait for an approved Gate A baseline and an exact Gate B authorization.

The shortest governed path is: close Lane A inputs → fresh independent CORE-01 Gate A review; close Lane B evidence/authority inputs → fresh independent CORE-02 Gate A review; close Lane C authority/control inputs → fresh independent CORE-04 Gate A review. The reviews may proceed independently once each lane's blockers close. Inventory remains deferred and is not a prerequisite for Order creation, Payment or Preparation completion.

## 8. Final boundary

This sprint closes only current-document contradictions about the 28/6 decision count, the confirmed `00:00` Branch-local cutoff, the same-attempt Model A progression, and CORE-01 readiness. It obtains no professional advice, changes no Owner decision, allocates no ODB ID, and authorizes no external contact, schema, migration, database operation, code, test, service, Gate, implementation, FOA or Production operation.

**Final status:** `POST_OWNER_DECISION_SYNCHRONIZED — CORE_01_02_04_NOT_READY_FOR_FRESH_INDEPENDENT_GATE_A_REVIEW — NO_GATE_OR_IMPLEMENTATION_AUTHORIZED`
