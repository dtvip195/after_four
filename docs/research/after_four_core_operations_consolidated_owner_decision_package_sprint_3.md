# AFTER FOUR — Core Operations Consolidated Owner Decision Package — Sprint 3

**Prepared:** 2026-11-24

**Verified baseline:** `main` at `0423cf3c2f38871f105a82fdce04bfbb7383713b`

**Status:** `OWNER_AND_QUALIFIED_INPUT_REQUIRED — NO_DECISION_RECORDED`

## 1. Purpose and authority

This is one consolidated review package for the unresolved CORE-01, CORE-02 and CORE-04 inputs. It uses the [Owner Decision Baseline](../architecture/after_four_owner_decision_baseline.md) and the Sprint 3 [CORE-01](after_four_core_01_blocker_closure_sprint_3.md), [CORE-02](after_four_core_02_blocker_closure_sprint_3.md), and [CORE-04](after_four_core_04_blocker_closure_sprint_3.md) reports. It does not ask the Owner to reapprove confirmed policy. Every recommendation is `PROPOSED_NOT_APPROVED` unless the baseline already records the policy.

## 2. Section A — Commercial and menu inputs

The 28 Product identities, six groupings and presented option labels remain approved by reference under `CORE-OD-01`. Exact applicability and Prices remain absent.

| Owner or qualified-input question | Existing constraint | Required response | Closure effect |
|---|---|---|---|
| Final Product/Variant applicability | Every sellable choice uses a persisted Variant; S/M/L applies only to suitable Products. Presented labels do not establish final applicability/capacity. | For each of the 28 Products, confirm exact sellable Variant choices, capacities and hidden/default treatment where applicable. | Freezes the denominator for exact Price evidence; blocks CORE-01 Gate A baseline until supplied. |
| Exact Price and effective scope | Approximate VND 23,000 / 33,000 / 43,000–49,000 bands are direction only. Chain defaults and explicit Branch overrides are supported; Price Versions are immutable and effective-dated. | Supply exact VND Price for every confirmed sellable Variant, chain/Branch scope, any channel differentiation, effective start/end and approval/revision evidence. | Closes the commercial dataset gap; no artifact label becomes a canonical code automatically. |
| `CORE-OD-03` — tax/display | Deferred pending qualified input. | Qualified Vietnamese Tax/Accounting review must first address actual seller, location, Product classes, channels, rates/bases, inclusive/exclusive display and receipt/invoice requirements; Owner then selects policy within those constraints. | Required for coherent CORE-01 Gate A baseline. |
| `CORE-OD-04` — precision/rounding | Integer VND is preserved; no rounding behavior is inferred. | Qualified review must address acceptable precision, modes, component/line/subtotal/tax/Order boundary, sequence, residuals and reconciliation; Owner then selects policy. | Required for deterministic commercial semantics before Gate A. |

Technical representation—numeric types, effective-interval enforcement, locking, quote tokens, snapshot columns and APIs—remains Gate B work and is not part of these Owner decisions.

## 3. Section B — Preparation custody-transfer policy

### 3.1 Three acceptance-policy inputs

Owner and appropriate qualified stakeholders must define, without selecting physical mechanisms:

1. approved trusted evidence classes that can establish actual release;
2. authority to attest actual release; and
3. validation policy for intended-recipient-to-receiver linkage.

These are the unresolved `CORE02-FIR2-01` blocker. No evidence class, role, device or identity mechanism is proposed as already approved.

### 3.2 `CORE02-FIR2-02` closure question

**Question:** after `transfer_evidence_unresolved`, does later sufficient authoritative evidence resolve the same stable handover attempt, or may transfer be established only through a separately authorized new attempt?

| Choice | Meaning | Consequence |
|---|---|---|
| Option A — same-attempt resolution (`RECOMMENDED`, `PROPOSED_NOT_APPROVED`) | Unresolved is nonterminal. A separately authorized new evidence submission/resolution action may append evidence under the same attempt and establish `transferred` exactly once. Exact replay cannot advance it. | Preserves one handover attempt for one actual release while retaining immutable evidence revisions. Requires explicit resolution authority. |
| Option B — terminal unresolved plus new attempt | The unresolved attempt is terminal. A new attempt requires separate authorization, a new identity, preserved cross-reference, handled prior basis and revalidated eligibility. | Creates a stronger terminal boundary but adds supersession authority and risks representing one release as multiple attempts. |
| Defer | No progression from unresolved is permitted. | Remains fail-closed and blocks `CORE-OD-10C` closure eligibility. |

All choices preserve: acknowledgement/replay/transport/authentication never establishes transfer; evidence is append-only and bound to exact business identities/version context; conflicts fail closed; only authoritative `transferred` satisfies the handover condition; transfer does not close the Order.

## 4. Section C — Cash and Operating Day decisions

| Decision | Exact Owner question | Evidence-supported direction | Dependency / effect |
|---|---|---|---|
| `CORE-OD-11B` | What fixed local `HH:MM` cutoff applies to the first Hoi An Branch? | `RECOMMENDATION_NOT_ESTABLISHED`; first obtain operating hours, after-midnight activity and Accounting/Reporting boundary examples. | Independent; blocks Operating Day baseline. |
| `CORE-OD-12` capability source | What accountable source/holder rule applies separately to Open, Count, Handover, Close, reconciliation and discrepancy disposition? | Preserve operation-specific, Branch-scoped, fail-closed authority; actual assignees remain unselected. | Constrains later authority assignments. |
| `CORE-OD-12` delegation/emergency | Which operations are delegable, by whom, within what bounds, with what revocation and emergency policy? | Default to no delegated/emergency authority until exact rules are approved. | Depends on capability-source policy. |
| `CORE-OD-12` separation | Which actor/requester/counter/reviewer/approver/resolver combinations are prohibited per operation? | `RECOMMENDATION_NOT_ESTABLISHED`; obtain qualified Accounting/control input. | Constrains correction, disagreement and discrepancy authority. |
| `CORE-OD-13` | Which linked post-close correction operations are permitted, and who requests, approves and executes them with what evidence/consequences? | Exclude correction from the first slice unless a bounded operation/evidence/authority matrix is approved. | Depends on applicable `CORE-OD-12` rules; physical workflow is Gate B. |
| Handover disagreement/refusal | Who resolves it, what completes escalation and what explicit consequences may resolution authorize? | Bounded Owner resolution is supportable initially but remains `PROPOSED_NOT_APPROVED`; no automatic consequence. | Delegated resolver depends on `CORE-OD-12`. |
| `CORE-OD-15A` | What classes, investigation, escalation, resolver/disposition authority and consequences apply to each nonzero discrepancy? | `RECOMMENDATION_NOT_ESTABLISHED`; require Cash/Accounting/Reporting options. No tolerance. | Linked correction remains a separate `CORE-OD-13` decision. |
| `CORE-OD-15B` | What constitutes authoritative reconciliation, is exception release allowed, and who reviews/releases with what evidence/limits? | No exception release in the first slice unless qualified evidence establishes need and Owner approves it. | Follows reconciliation truth but is independent of Cash capability assignment. |
| `CORE-OD-16B` | Who may read which approved report for which Branch scope and purpose? | Default to no reader pending Identity/governance input. | Separate Reporting decision; does not grant export/delivery. |
| `CORE-OD-16F` | What retention, disposal triggers, legal holds and authorities apply? | `RECOMMENDATION_NOT_ESTABLISHED`; require qualified legal/privacy/Accounting records input. | Separate governance decision; implementation is later. |

## 5. Section D — Authority classification

| Input class | Questions | Authority boundary |
|---|---|---|
| Owner business decision/input | Exact Variant applicability and Prices; `CORE-OD-03/04` after qualified input; custody-transfer model and policy; all CORE-04 decision rows. | Records business policy only; no Gate or implementation authority. |
| Qualified Tax/Accounting input | Tax/display; precision/rounding; Cash controls, discrepancy/reconciliation/reporting evidence. | Supplies constraints and source-supported options; does not decide policy. |
| Other qualified professional input | Custody-transfer evidence acceptability, attestation and recipient linkage as applicable; reporting privacy/legal retention. | Must be scoped to actual facts and qualifications; no role or result is invented here. |
| Technical design | Logical contracts after policy selection, consistent cross-context ports, evidence envelopes and state semantics. | Later design review; cannot substitute for policy. |
| Gate B implementation authorization | Physical storage, transactions, locks, constraints, APIs, Identity integration, concurrency and runtime enforcement. | Not granted by this package. |

## 6. Section E — Dependencies and deferral effect

- CORE-01 exact commercial data and qualified review can proceed independently of CORE-02/04.
- CORE-02 evidence classes, attester policy, recipient linkage and attempt-model selection may be prepared in parallel, but all must close before a coherent CORE-02 Gate A baseline.
- `CORE-OD-11B` is independent after evidence collection. The three `CORE-OD-12` dimensions should precede dependent authority assignments in `CORE-OD-13`, disagreement resolution and `CORE-OD-15A`.
- `CORE-OD-15B` depends on reconciliation/disposition evidence but remains a separate release decision. `CORE-OD-16B/F` remain separate Reporting/governance decisions.
- Deferring any item leaves its related operation fail-closed. Deferral creates no default authority, tolerance, Price, transfer fact or report release.

No decision in this package is preselected. The consolidated register remains 27 confirmed / 7 deferred; all applicable references remain `ID_PENDING_OWNER_GOVERNANCE`.
