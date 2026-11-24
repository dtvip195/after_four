# AFTER FOUR — Core Operations Consolidated Owner Decision Package — Sprint 3

**Prepared:** 2026-11-24

**Verified baseline:** `main` at `0423cf3c2f38871f105a82fdce04bfbb7383713b`

**Status:** `OWNER_DECISIONS_RECORDED — QUALIFIED_INPUT_DEPENDENCIES_REMAIN — NO_GATE_GRANTED`

## 1. How to use this ballot

This is a self-contained ballot for unresolved CORE-01, CORE-02 and CORE-04 inputs. Supporting sources are the [Owner Decision Baseline](../architecture/after_four_owner_decision_baseline.md) and Sprint 3 [CORE-01](after_four_core_01_blocker_closure_sprint_3.md), [CORE-02](after_four_core_02_blocker_closure_sprint_3.md), and [CORE-04](after_four_core_04_blocker_closure_sprint_3.md) reports, but the Owner does not need to open them to understand the choices below.

The subsequent Consolidated Owner Decision Session recorded `CORE02-FIR2-02` Model A and the `CORE-OD-11B` initial cutoff. Every other item retains its stated unresolved status and qualified-input dependency; approval of this consolidated handling does not select those policies. `RECOMMENDED` and `RECOMMENDATION_NOT_ESTABLISHED` remain proposals, not decisions. Items marked `QUALIFIED_INPUT_FIRST` or `EVIDENCE_FIRST` are not ready for substantive selection; deferral keeps them fail-closed. This package asks for no reapproval of confirmed policy and grants no Gate or implementation authority.

## 2. CORE-01 — Commercial and pricing ballot

The 28 Product names, six groupings and presented option labels remain approved by reference under `CORE-OD-01`. Artifact labels are not canonical codes. Final Variant applicability is `0/28` confirmed and exact Price/effective-period/scope coverage is `0/28`.

### 2.1 Final Product/Variant applicability

- **Reference and exact question:** Factual confirmation — no new decision ID: What exact sellable Variants and capacities apply to each of the 28 Products?
- **Approved constraints:** Every sellable choice uses a persisted Variant; hidden/default represents no visible choice; S/M/L applies only to suitable Products. Presented labels do not prove applicability/capacity.
- **Distinguishable options:** Confirm a complete Owner-supplied 28-Product dataset; return the dataset for correction; or defer and retain no final Variant set. No alternative applicability is inferred.
- **Recommendation and rationale:** Confirm only after the complete dataset is supplied and reconciled. Repository evidence cannot establish it.
- **Operational consequence / deferral:** Confirmation freezes the Price-bearing denominator. Correction returns it for evidence repair. Deferral blocks exact Pricing and CORE-01 Gate A coherence.
- **Required input, dependency and authority:** Owner factual/commercial confirmation. No qualified input is needed merely to state intended Variants; exact canonical representation is later technical design.
- **Session status:** `EVIDENCE_FIRST`.

### 2.2 Exact Price, scope and effective period

- **Reference and exact question:** Factual confirmation — no new decision ID: What exact VND Price, scope and effective period applies to every confirmed sellable Variant?
- **Approved constraints:** Approximate VND 23,000 / 33,000 / 43,000–49,000 bands are direction only. Chain defaults and explicit Branch overrides are supported. Price Versions are immutable and effective-dated.
- **Distinguishable options:** Confirm a complete Price dataset; return it for correction; or defer. Dataset must state exact amount, chain/Branch scope, channel distinction if any, effective start/end and approval/revision evidence.
- **Recommendation and rationale:** Confirm only a complete reconciled dataset; do not convert bands or fixture values into Prices.
- **Operational consequence / deferral:** Confirmation supplies commercial truth for quote resolution. Correction repairs evidence. Deferral leaves Pricing and Payment-target calculation unavailable.
- **Required input, dependency and authority:** Owner commercial confirmation after final Variant set. Tax treatment may affect calculation/display but does not choose the commercial Price.
- **Session status:** `EVIDENCE_FIRST`; depends on final Variant set.

### 2.3 `CORE-OD-03` — tax treatment and display

- **Reference and exact question:** `CORE-OD-03`. What tax treatment and tax-inclusive/exclusive customer-display policy applies to the actual seller, Product classes and dine-in/takeaway transactions?
- **Approved constraints:** Decision remains deferred. No generic legal source or implementation example establishes applicability.
- **Distinguishable options:** Evidence-supported options must be supplied by qualified Vietnamese Tax/Accounting review; the ballot does not invent them. Owner may decide within those constraints or defer.
- **Recommendation and rationale:** `RECOMMENDATION_NOT_ESTABLISHED` until qualified input identifies applicable rules, effective dates, invoice/receipt treatment and assumptions.
- **Operational consequence / deferral:** A supported decision completes tax/display policy. Deferral keeps totals and presentation fail-closed and blocks CORE-01 Gate A coherence.
- **Required input, dependency and authority:** Qualified Vietnamese Tax/Accounting input first; then Owner business decision. Numeric/storage design is later Gate B.
- **Session status:** `QUALIFIED_INPUT_FIRST`.

### 2.4 `CORE-OD-04` — precision and rounding

- **Reference and exact question:** `CORE-OD-04`. What VND precision, rounding mode, boundary and calculation sequence apply?
- **Approved constraints:** Integer VND is preserved; no rounding behavior is inferred. Service Charge, price-changing Modifiers and complimentary/zero-price Items are excluded from the first slice.
- **Distinguishable options:** Evidence-supported modes/boundaries must come from qualified review; Owner may select within those constraints or defer.
- **Recommendation and rationale:** `RECOMMENDATION_NOT_ESTABLISHED` until acceptable precision, modes, component/line/subtotal/tax/Order boundaries, sequence, residuals and reconciliation are evidenced.
- **Operational consequence / deferral:** A supported decision enables deterministic calculation semantics. Deferral blocks coherent total/Payment-target rules.
- **Required input, dependency and authority:** Qualified Vietnamese Tax/Accounting input first; then Owner business decision. Numeric type, algorithm, locks and persistence remain Gate B.
- **Session status:** `QUALIFIED_INPUT_FIRST`.

## 3. CORE-02 — Custody-transfer and attempt-model ballot

Already confirmed and not reopened: acknowledgement, refusal and dispute are not customer custody transfer; replay, authentication, command invocation and transport success create no transfer fact; only authoritative `transferred` evidence satisfies the handover guard in `CORE-OD-10C`; transfer does not close the Order.

### 3.1 `CORE02-FIR2-01` — trusted evidence classes

- **Reference and exact question:** `CORE02-FIR2-01` input 1. Which trusted evidence classes may establish actual release?
- **Approved constraints:** Evidence must retain immutable identity, provenance, authoritative time, exact Order/Ticket/Branch/attempt bindings, completion/version context and recipient-linkage context. No class is currently approved.
- **Distinguishable options:** Qualified stakeholders supply a bounded class set for Owner approval; or defer with no transfer fact. The package invents no class/device.
- **Recommendation and rationale:** `RECOMMENDATION_NOT_ESTABLISHED`.
- **Operational consequence / deferral:** Approval defines eligible evidence classes but no physical capture mechanism. Deferral keeps custody transfer and Order closure eligibility blocked.
- **Required input, dependency and authority:** Appropriate qualified evidence/privacy/operations input, then Owner policy. Physical capture/storage is Gate B.
- **Session status:** `QUALIFIED_INPUT_FIRST`.

### 3.2 `CORE02-FIR2-01` — attester authority

- **Reference and exact question:** `CORE02-FIR2-01` input 2. Who may attest actual release, under what scope and evidence?
- **Approved constraints:** Actor authentication or generic role title alone is insufficient. No attester authority is approved.
- **Distinguishable options:** Source-supported operation-specific attester policy for Owner approval; or defer with no attestation authority.
- **Recommendation and rationale:** `RECOMMENDATION_NOT_ESTABLISHED`; do not infer a person, role or delegation.
- **Operational consequence / deferral:** Approval supplies the authority boundary. Deferral permits no accepted attestation.
- **Required input, dependency and authority:** Qualified operations/control and Identity-governance input, then Owner policy. Human assignment and Identity implementation remain separate.
- **Session status:** `QUALIFIED_INPUT_FIRST`.

### 3.3 `CORE02-FIR2-01` — intended-recipient linkage

- **Reference and exact question:** `CORE02-FIR2-01` input 3. How is intended-recipient-to-receiver linkage validated?
- **Approved constraints:** Exact recipient linkage must be verifiable before `transferred`; acknowledgement is insufficient. No identity mechanism is selected.
- **Distinguishable options:** Qualified stakeholders provide bounded validation alternatives for Owner approval; or defer with no transfer fact.
- **Recommendation and rationale:** `RECOMMENDATION_NOT_ESTABLISHED`.
- **Operational consequence / deferral:** Approval closes linkage policy only. Deferral blocks transfer and closure eligibility.
- **Required input, dependency and authority:** Qualified operations/privacy/identity input, then Owner policy. Technical verification mechanism is later Gate B/separate Identity authorization.
- **Session status:** `QUALIFIED_INPUT_FIRST`.

### 3.4 `CORE02-FIR2-02` — unresolved evidence progression

- **Reference and exact question:** `CORE02-FIR2-02`. After `transfer_evidence_unresolved`, does sufficient later evidence resolve the same attempt or require a separately authorized new attempt?
- **Approved constraints:** Evidence is append-only; exact replay returns the prior result; no acknowledgement/replay/transport/authentication establishes transfer; conflicts fail closed; no silent new attempt; only `transferred` satisfies `CORE-OD-10C`.
- **Distinguishable options:** **A — same-attempt resolution:** unresolved is nonterminal; independently identifiable new evidence/resolution action may establish one transfer under the same attempt. **B — terminal unresolved/new attempt:** prior attempt is terminal; a separately authorized, cross-referenced new attempt requires handled prior basis and revalidated eligibility. **Defer:** no progression.
- **Owner decision and rationale:** **Model A is `OWNER_DECIDED — OWNER_CONFIRMED`**. One actual release remains one attempt, and delayed proof does not invent a second business event.
- **Operational consequence / deferral:** A requires precise replay-versus-new-evidence and resolution authority. B adds supersession/new-attempt authority and audit complexity. Deferral keeps the attempt held and closure blocked.
- **Required input, dependency and authority:** Owner business-policy decision. Evidence criteria, attester authority and recipient linkage remain separate dependencies. Physical uniqueness/concurrency is Gate B.
- **Session status:** `OWNER_DECIDED`, subject to the conflict boundary below. Evidence classes, attester authority, recipient linkage and conflict-resolution authority remain unresolved.

#### Mandatory Model A conflict/dispute boundary

If Option A is selected, `transfer_evidence_unresolved` may remain nonterminal only while evidence is missing, incomplete, being obtained or being verified. Later evidence does not override a conflict, dispute or challenged assertion merely because it arrived later. Conflicting or disputed custody evidence keeps the attempt held and fail-closed until a separately authorized disposition resolves the conflict. Later evidence is retained and may be evaluated, but cannot silently supersede, erase or upgrade prior evidence. `transferred` requires both approved evidence criteria and authorized resolution of every conflict/dispute. History, provenance, revisions, actor, time and prior outcomes remain auditable. Replay, acknowledgement, transport results and repeated commands resolve no conflict; no new attempt may be silently created to bypass one. Resolver identity and dispute-resolution policy remain unresolved Owner/qualified-input dependencies.

## 4. CORE-04 — Operating Day, Cash control and reconciliation ballot

Confirmed and not reopened: explicit Branch timezone/cutoff direction; first Hoi An Branch timezone `Asia/Ho_Chi_Minh`; no MVP inheritance; separate Branch-scoped Open/Count/Handover/Close capabilities; immutable closed evidence with linked corrections; required handover evidence; acknowledgement is not approval; every nonzero discrepancy is recorded with reason and Owner notification; no tolerance; unreconciled facts stay out of authoritative reporting.

### 4.1 `CORE-OD-11B` — Operating Day cutoff

- **Reference and decision:** `CORE-OD-11B`. The initial cutoff is `00:00` local time per Branch. The first Hoi An Branch therefore uses `00:00 Asia/Ho_Chi_Minh` under `CORE-OD-11A`.
- **Approved constraints:** `Asia/Ho_Chi_Minh`; explicit Branch cutoff; no inheritance; exceptional-day evidence never rewrites closed days.
- **Owner direction:** `00:00` is the initial policy, not a permanent restriction. Future per-Branch configurable cutoff is an approved product direction; it does not authorize implementation now.
- **Operational consequence:** The initial Operating Day boundary is closed at policy level. Future configuration behavior, storage and exceptional-day mechanisms remain technical design.
- **Required input, dependency and authority:** No further Owner choice is required for the initial cutoff. Future changes remain separately governed; scheduling/storage is Gate B.
- **Session status:** `OWNER_DECIDED — OWNER_CONFIRMED`.

### 4.2 `CORE-OD-12` — capability source

- **Reference and exact question:** `CORE-OD-12` capability source. What accountable source/holder policy applies separately to Open, Count, Handover, Close, reconciliation and discrepancy disposition?
- **Approved constraints:** Generic Staff, Shift and Branch Assignment grant none; operations are Branch-scoped.
- **Distinguishable options:** Strict distinct actors; risk-tiered separation; same actor only for enumerated operations with explicit authority/evidence; or defer. These are policy models, not assignments.
- **Recommendation and rationale:** Preserve operation-specific, Branch-scoped, fail-closed authority; `RECOMMENDATION_NOT_ESTABLISHED` for actual holder rules until the operation/control matrix exists.
- **Operational consequence / deferral:** Selection constrains authority. Deferral authorizes no generic actor and blocks runtime command policy.
- **Required input, dependency and authority:** Cash/Accounting operation-control evidence, then Owner. Identity representation/assignment is separate.
- **Session status:** `EVIDENCE_FIRST`.

### 4.3 `CORE-OD-12` — delegation, revocation and emergency handling

- **Reference and exact question:** `CORE-OD-12`. Which operations are delegable, by whom, within what Branch/time bounds, with what revocation and emergency path?
- **Approved constraints:** No delegation or emergency authority is approved.
- **Distinguishable options:** No delegation/emergency path; bounded operation-specific delegation with explicit revocation; separately enumerated emergency path; or defer.
- **Recommendation and rationale:** Default to no delegated/emergency authority until exact rules are approved.
- **Operational consequence / deferral:** A selected bounded model enables later authority design. Deferral remains fail-closed and may retain Owner bottlenecks.
- **Required input, dependency and authority:** Cash operational/control evidence and Owner policy; depends on capability-source policy. Mechanics are later.
- **Session status:** `DECIDABLE_NOW` as exclusion/deferral; positive delegation needs evidence.

### 4.4 `CORE-OD-12` — separation of duties

- **Reference and exact question:** `CORE-OD-12`. Which requester, actor, counter, reviewer, approver or resolver combinations are prohibited per operation?
- **Approved constraints:** Expense self-approval policy does not automatically decide Cash conflicts.
- **Distinguishable options:** Strict separation; risk-tiered separation; same actor only for enumerated low-risk operations with independent evidence; or defer.
- **Recommendation and rationale:** `RECOMMENDATION_NOT_ESTABLISHED`; decide per operation after Accounting control input.
- **Operational consequence / deferral:** Selection constrains correction/disagreement/discrepancy authority. Deferral leaves those assignments unavailable.
- **Required input, dependency and authority:** Qualified Accounting/control input, then Owner.
- **Session status:** `QUALIFIED_INPUT_FIRST`.

### 4.5 `CORE-OD-13` — post-close corrections

- **Reference and exact question:** `CORE-OD-13`. Which linked post-close correction operations are permitted, and who requests, approves and executes them with what evidence/consequences?
- **Approved constraints:** Closed evidence is immutable; correction is a new attributable linked fact. No operation or authority is approved.
- **Distinguishable options:** Exclude all post-close correction from the first slice; approve bounded enumerated operations after an evidence/authority matrix; broad linked adjustment; or defer.
- **Recommendation and rationale:** **Exclude from first slice unless a bounded matrix exists (`PROPOSED_NOT_APPROVED`)**; broad adjustment has highest control risk and no preferred source support.
- **Operational consequence / deferral:** Exclusion/deferral leaves errors held and may block reporting. Bounded approval enables later workflow design.
- **Required input, dependency and authority:** Owner policy. Positive operation/authority requires Cash/Accounting/Reporting input and applicable `CORE-OD-12` rules.
- **Session status:** `DECIDABLE_NOW` for exclusion/deferral; positive scope needs input.

### 4.6 `CORE-OD-14A/B` — detailed handover resolution

- **Reference and exact question:** `CORE-OD-14A/B`. Who resolves handover refusal/disagreement, what completes escalation, and what explicit consequences may resolution authorize?
- **Approved constraints:** Refusal/disagreement already escalates to Owner. Acknowledgement is not approval or customer transfer. Separate Close is mandatory and has its own capability. Resolution grants no correction, discrepancy disposition or report release automatically.
- **Distinguishable options:** Owner resolves initially; separately delegated operation-specific resolver with Owner escalation; remain held pending a separate case decision; or defer.
- **Recommendation and rationale:** **Bounded Owner resolution is supportable initially (`PROPOSED_NOT_APPROVED`)**, but every consequence must be explicit.
- **Operational consequence / deferral:** Selection defines resolver direction only. Held/deferral preserves evidence and prior accountability and may delay Session/report completion.
- **Required input, dependency and authority:** Owner decision; delegated resolver depends on `CORE-OD-12`. Operating escalation/control evidence supports positive consequences.
- **Session status:** `DECIDABLE_NOW` for Owner/held direction.

### 4.7 `CORE-OD-15A` — discrepancy investigation and disposition

- **Reference and exact question:** `CORE-OD-15A`. What discrepancy classes, investigation, escalation, resolver/disposition authority and consequences apply?
- **Approved constraints:** Every nonzero discrepancy is recorded with reason and Owner notification; no tolerance/threshold exemption. Linked correction is separate.
- **Distinguishable options:** No defensible class/authority option set exists yet; qualified stakeholders must propose bounded options. Owner may then select or defer held.
- **Recommendation and rationale:** `RECOMMENDATION_NOT_ESTABLISHED`.
- **Operational consequence / deferral:** Selection enables controlled disposition policy. Deferral keeps discrepancy unresolved and dependent facts held.
- **Required input, dependency and authority:** Qualified Cash/Accounting/Reporting input, then Owner; linked corrections remain under `CORE-OD-13`.
- **Session status:** `QUALIFIED_INPUT_FIRST`.

### 4.8 `CORE-OD-15B` — authoritative-report hold and release

- **Reference and exact question:** `CORE-OD-15B`. What constitutes authoritative reconciliation, is exception release allowed, and who reviews/releases with what evidence/limits?
- **Approved constraints:** Unreconciled facts are held; discrepancy resolution does not grant report release; release grants no read/export/delivery authority.
- **Distinguishable options:** No exception release; bounded annotated release after separately authorized independent review; Owner-only exception release; or defer.
- **Recommendation and rationale:** **No exception release for first slice (`PROPOSED_NOT_APPROVED`)** unless qualified evidence proves a need.
- **Operational consequence / deferral:** No-release/deferral delays or omits Cash-dependent authoritative reporting safely. Positive release adds evidence and authority obligations.
- **Required input, dependency and authority:** Owner policy; positive release requires qualified Accounting/Reporting evidence. Independent of Cash capability assignment.
- **Session status:** `DECIDABLE_NOW` for no-release/deferral.

### 4.9 `CORE-OD-16B` — report reader capability and scope

- **Reference and exact question:** `CORE-OD-16B`. Who may read which approved reports for which Branch scope and purpose?
- **Approved constraints:** No report-read authority exists; release does not grant read/export/delivery.
- **Distinguishable options:** No reader; Owner-only bounded reader; separately delegated purpose/Branch-scoped reader after input; or defer.
- **Recommendation and rationale:** Default to no reader until Identity/governance input supports a bounded policy.
- **Operational consequence / deferral:** No-reader/deferral authorizes no access. Positive selection defines policy only, not runtime grants.
- **Required input, dependency and authority:** Identity/governance/privacy input, then Owner. Identity implementation remains separately unauthorized.
- **Session status:** `QUALIFIED_INPUT_FIRST` for positive access; no-reader is decidable.

### 4.10 `CORE-OD-16F` — retention, disposal and legal hold

- **Reference and exact question:** `CORE-OD-16F`. What retention periods, disposal triggers, legal holds and authorities apply to Cash/reporting evidence?
- **Approved constraints:** No period, disposal trigger or holder authority is approved.
- **Distinguishable options:** No defensible options/periods exist until qualified input; Owner may later select or defer.
- **Recommendation and rationale:** `RECOMMENDATION_NOT_ESTABLISHED`.
- **Operational consequence / deferral:** Deferral permits no disposal implementation and preserves evidence under existing boundaries. Selection enables later retention design only.
- **Required input, dependency and authority:** Qualified legal/privacy/Accounting-records input, then Owner. Physical retention is later Gate/operations work.
- **Session status:** `QUALIFIED_INPUT_FIRST`.

## 5. Authority and dependency summary

| Category | Items | Boundary |
|---|---|---|
| Owner factual/commercial confirmation | Final Variant dataset; exact Price/scope/effective-time dataset. | Confirms intended business data; creates no schema or implementation authority. |
| Owner business decisions | `CORE-OD-03/04` after qualified input; `CORE02-FIR2-01/02`; all CORE-04 ballot items. | Records policy only; does not grant Gate A or implementation. |
| Qualified professional input | Tax/rounding; custody evidence/attestation/linkage/conflict; Accounting controls; Reporting release; reader/privacy; retention/legal hold. | Supplies constraints/options, not Owner decisions. No engagement is authorized here. |
| Evidence retrieval/confirmation | Product/Variant/Price datasets; Operating Day examples; Cash operation/control matrix. | Factual prerequisite; no policy inferred from absence. |
| Later technical design/Gate | Numeric/storage design, transactions, locks, APIs, Identity enforcement, evidence capture, concurrency, retention mechanisms. | Must wait for policy and separate Gate review/authorization. |

CORE-01 commercial evidence, CORE-02 qualified policy inputs and CORE-04 operational/control evidence can be collected in parallel. `CORE-OD-12` constrains dependent authority assignments in `CORE-OD-13`, `CORE-OD-14A/B` detailed resolution and `CORE-OD-15A`. `CORE-OD-15B` depends on reconciliation truth but is a separate release decision. Deferral creates no default Price, applicability, transfer fact, Cash authority, tolerance, correction, report release, reader or implementation authorization.

The consolidated CORE-OD register is now 28 confirmed / 6 deferred. The remaining deferred references are `CORE-OD-03`, `CORE-OD-04`, `CORE-OD-12`, `CORE-OD-13`, `CORE-OD-16B` and `CORE-OD-16F`. `CORE02-FIR2-02` is separately Owner-confirmed under its stable finding reference and is not counted as a CORE-OD reference. All applicable references remain `ID_PENDING_OWNER_GOVERNANCE`; no canonical `ODB-*` ID is allocated or reserved. CORE-03/Identity Milestone 2B remains unauthorized, Inventory remains deferred, and Refund, Promotions, Loyalty and manual bank remain outside the bounded initial scope.
