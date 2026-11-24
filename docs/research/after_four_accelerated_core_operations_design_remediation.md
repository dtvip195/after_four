# AFTER FOUR — Accelerated Core Operations Design Remediation

**Status:** `DOCUMENTATION_AND_LOGICAL_DESIGN_REMEDIATION — NO_GATE_GRANTED`

**Repository baseline:** `main` / `origin/main` at `5d8f489d7e088fd8bded01f759b682454696bc12`

**Evidence cutoff:** 2026-11-24 (Asia/Tokyo)

**Scope:** CORE-01 Core Sale, CORE-02 Preparation, CORE-04 Cash Session and Operating Day

**Implementation authorization:** `NOT_GRANTED`

## 1. Executive summary

This package remediates the logical design findings in the [Independent Core Operations Design Review](after_four_core_operations_independent_design_review.md) without changing Owner policy or selecting physical implementation.

| Workstream | Logical remediation result | Remaining blocker | Gate A readiness |
|---|---|---|---|
| CORE-01 | Payment-target lifecycle, deterministic menu/Price resolution, Application-owned ports, orchestration and trusted-command/audit contracts are now explicit. | Exact Product/Variant Prices do not exist; tax and rounding remain deferred pending qualified input and Owner decisions. | `NOT_READY_FOR_OWNER_GATE_A_REVIEW` |
| CORE-02 | Dispatch/Outbox/acceptance/Ticket/Item/acknowledgement/custody-transfer/Exception axes, terminal/held acceptance outcomes, Candidate Ticket quarantine and ADR-0011 ownership contracts are explicit. | A new independent review is required after FIR remediation; broader universal closure, Identity implementation, transfer-proof mechanism, exception resolver authority, Refund and physical mechanisms remain separate. | `READY_FOR_FRESH_INDEPENDENT_GATE_A_REVIEW — NO_GATE_GRANTED` |
| CORE-04 | Confirmed policy, distinct lifecycle outcomes, durable disagreement hold and initial exact-cash source contract are explicit. | Exact cutoff, capability assignments, post-close correction policy and disposition/release authority remain deferred. | `NOT_READY_FOR_OWNER_GATE_A_REVIEW` |

No logical closure below creates a table, migration, lock, transaction, broker, worker, API, capability assignment or implementation authorization.

## 2. Verified baseline and sources

Controlling sources:

- [Owner Decision Baseline](../architecture/after_four_owner_decision_baseline.md), including 27 confirmed and seven deferred `CORE-OD-*` references;
- [ADR-0011](../architecture/adr/0011-project-wide-layered-ddd.md);
- [Accelerated Core Operations Design Package](after_four_accelerated_core_operations_design_package.md);
- [Accelerated Core Operations Readiness Assessment](after_four_accelerated_core_operations_readiness_assessment.md);
- [Independent Design Review](after_four_core_operations_independent_design_review.md);
- [Proposed Launch Menu v3](../architecture/after_four_proposed_launch_menu_v3.md) and [Real Menu & Pricing Specification](../architecture/after_four_real_menu_pricing_specification.md);
- [Business Domain Model](../architecture/after_four_business_domain_model.md), [State Machines](../architecture/after_four_state_machines.md), [Data Dictionary](../architecture/after_four_data_dictionary.md) and [Data Integrity Rules](../architecture/after_four_data_integrity_rules.md);
- [Order/Payment Phase 1](../architecture/after_four_order_payment_implementation_phase1.md), [Catalog Core Technical Design](../architecture/after_four_catalog_core_technical_design.md), and [Cash Domain Discovery](after_four_p2b_cash_domain_discovery.md); and
- [P1 Trusted Identity/Authorization Design](../architecture/after_four_p1_trusted_identity_authorization_design.md).

Repository source was inspected only as evidence. No application, test, service, migration or database command was run.

## 3. CORE-01 remediation

### 3.1 Exact menu and Price reconciliation

`CORE-OD-01` approves the menu identity by reference. It does not approve canonical artifact codes, exact persisted Variants or exact Prices.

| Approved grouping | Approved named Products | Presented option baseline | Exact Price evidence |
|---|---|---|---|
| Cà phê | Cà phê đen; Cà phê sữa; Bạc xỉu; Cà phê muối; Cà phê dừa; Latte | Đá/Nóng as shown; Đá for Cà phê muối and Cà phê dừa | `MISSING` for every Product/Variant |
| Trà trái cây | Trà đào cam sả; Trà vải; Trà chanh; Trà tắc mật ong; Trà chanh dây | S/M/L labels shown; applicability remains unresolved | `MISSING` |
| Nước ép và giải khát | Nước chanh; Chanh dây đá; Cam ép; Soda chanh | S/M/L labels shown; applicability remains unresolved | `MISSING` |
| Sinh tố và đá xay | Bơ xay dừa non; Sinh tố xoài; Sinh tố dâu; Cà phê dừa đá xay | S/M/L labels shown; applicability remains unresolved | `MISSING` |
| Thức uống khác | Matcha latte; Cacao sữa; Sữa chua trái cây | Đá/Nóng or Default as shown; sizes unresolved | `MISSING` |
| Bánh ngọt và đồ ăn nhẹ | Bánh croissant; Cheesecake; Brownie chocolate; Muffin; Sandwich jambon phô mai; Khoai tây chiên | Một phần/Một cái as shown | `MISSING` |

The reconciliation preserves all 28 rows, six groupings, option labels and approved Modifier-option lists. Approximate VND 23,000 / 33,000 / 43,000–49,000 bands cannot be assigned to any row or Variant. Codes such as `CF001` remain artifact labels, not canonical records. No Price Version exists until exact approved data, scope and effective time are supplied.

### 3.2 Tax and rounding decision/evidence package

`CORE-OD-03/04` remain `OWNER_DEFERRED — OWNER_INPUT_REQUIRED`.

Qualified Vietnamese Tax/Accounting input must establish applicable legal/accounting constraints for the actual seller, Product class, transaction and receipt/invoice context. Owner commercial decisions must then address:

1. tax applicability and display;
2. whether menu Price is tax-inclusive or tax-exclusive;
3. receipt presentation of gross, net, rate and tax amount;
4. line, component or Order tax boundary;
5. integer-VND precision;
6. rounding mode;
7. component, line, tax-subtotal or Order-total rounding boundary; and
8. calculation sequence and reconciliation to the exact Payment target.

No alternative is selected here. Technical representation remains a later Gate B concern.

### 3.3 Payment target lifecycle and semantic boundary

The remediated `TECHNICAL_PROPOSAL` does not assume cross-context database atomicity.

Ordering owns the confirmation-attempt lifecycle:

| Attempt state | Meaning and terminality |
|---|---|
| `open` | Nonterminal attempt bound to Order, expected Draft version and stable idempotency identity. |
| `confirmation_in_progress` | Nonterminal validation/confirmation attempt; same-identity retry locates this attempt. |
| `confirmed_terminal` | Immutable terminal evidence binds confirmed Order version, snapshot digest, amount, currency and target reference. |
| `aborted_terminal` | Immutable terminal evidence records reason/time/revision and an Ordering-owned fence rejecting all later confirmation for this attempt. |
| `reconciliation_required` | Nonterminal held observation until reconciliation records exactly one terminal outcome. |

Only Ordering Application may record a terminal outcome, and `confirmed_terminal` and `aborted_terminal` are mutually exclusive. Absence of observed confirmation is not terminal evidence. A terminal attempt cannot be retried. After `aborted_terminal`, a later business retry requires an explicit new attempt identity and current Draft version, and only while the Order remains Draft/eligible; it uses a new provisional target. No new attempt may replace `confirmed_terminal`.

| Payment-owned state | Meaning | Permitted next logical outcome |
|---|---|---|
| `absent` | No target for the confirmation attempt. | Create/locate one matching `provisional` target. |
| `provisional` | Proposed amount/currency and snapshot digest are correlated to the Order confirmation attempt, but are not payable while confirmation is pending, delayed, failed locally, unavailable or ambiguous. | Activate only after matching trusted `confirmed_terminal` evidence. Cancel only after matching trusted `aborted_terminal` evidence and terminal revision prove the Ordering fence. Missing/unavailable/stale/conflicting/mismatched evidence retains or holds the target for reconciliation. |
| `authoritative` | Payment Application verified matching authoritative Order confirmation and activated the single matching target. | Exact-cash settlement may proceed if all other guards pass. |
| `cancelled` | Payment validated trusted Ordering `aborted_terminal` evidence for the same attempt and tombstoned its provisional target. | Terminal for that target; never reused or reactivated. |
| `reconciliation_required` | Duplicate, mismatch, partial observation or context disagreement is held. | Separately authorized reconciliation only; no settlement/Dispatch/completion. |

The protocol is:

1. Draft calculation/re-quote evidence is Ordering-owned and creates no authoritative target.
2. Ordering Application owns `ConfirmOrder` and a stable confirmation-attempt/idempotency identity.
3. Ordering validates the Draft/re-quote version and constructs the complete proposed sold-snapshot digest, total and currency.
4. Through an Ordering Application-owned outbound port, its Infrastructure adapter asks the Payment Application public contract to create/locate a matching `provisional` target keyed by Order and attempt. Same identity/input returns the same target; changed input conflicts.
5. Ordering records `confirmed_terminal`, authoritative confirmation and complete sold snapshots with the attempt and target references.
6. Payment Application obtains evidence from a trusted Ordering Application public contract. The evidence binds Order, attempt, terminal outcome/revision, confirmed version, snapshot digest, total and currency; client input, caller assertions and Infrastructure adapter claims are never substitutes.
7. Missing, unavailable, stale, conflicting or mismatched Ordering evidence fails closed and keeps the target provisional/held.
8. Payment Application alone may activate the target after all `confirmed_terminal` evidence matches.
9. Activation yields the single `authoritative` target. Provisional creation cannot authorize activation.

Failure and retry outcomes:

- Provisional creation followed by pending, delayed, locally failed, unavailable or ambiguous Ordering outcome leaves non-payable evidence. Absence, timeout, transport failure and caller/adapter assertions never permit cancellation. Payment independently obtains matching `aborted_terminal` evidence and terminal revision from the trusted Ordering Application contract and validates its Ordering-owned fence before cancelling; missing, stale, conflicting or mismatched evidence retains/holds the target for reconciliation.
- Ordering confirmation followed by failed/unknown activation holds payment eligibility. Retry/reconciliation uses the same attempt and activates the matching target or records `reconciliation_required`; it never creates another payable target.
- Activation followed by response loss is replayed by the same identity and returns the prior authoritative result.
- Multiple targets, multiple authoritative candidates, mismatched digest/amount/currency/version or context disagreement enter `reconciliation_required`; automatic selection, merge or rewrite is prohibited.
- Ordinary retry/delayed confirmation after `aborted_terminal` is rejected. A new eligible business attempt requires a new identity and target.
- Unexpected confirmed evidence after target cancellation preserves both the authoritative Order/snapshots and cancelled target, enters `reconciliation_required`, prohibits settlement/Dispatch/completion and requires separately authorized recovery. The cancelled target is never reactivated.
- A provisional, cancelled, held or mismatched target—or an authoritative target lacking matching confirmed Order evidence—cannot support cash settlement, Preparation Dispatch or Order-completion eligibility.

An orphan target can therefore exist only as non-payable provisional evidence. Physical transactions, storage, locks, isolation, outbox/saga, broker, transport and reconciliation execution remain Gate B concerns.

### 3.4 Deterministic menu and Price resolution

The Catalog/Pricing Application contract must:

1. receive untrusted selection identifiers only with trusted Brand/Branch context, explicit channel and one server-controlled decision instant;
2. prove persisted Product→Variant identity and eligible Category/Product/Variant lifecycle;
3. resolve effective Branch availability, with an explicit effective Branch override taking precedence over chain default;
4. resolve exactly one published Price effective in the half-open interval containing the instant, preferring applicable Branch Price over chain default;
5. return immutable identities, amount, ISO currency, scope, interval and evidence version; and
6. fail closed without substitution or cross-scope disclosure for missing, unsellable, unavailable, overlapping or ambiguous configuration.

Overlap is an error, not a tie-break opportunity. Dine-in/takeaway does not imply channel pricing. Confirmation revalidates every binding; changed Price requires explicit revised-quote review under `ODB-CAT-09`.

### 3.5 Trusted command and audit contract

Draft mutation, re-quote acceptance, confirmation and exact-cash confirmation require server-resolved actor, current non-secret Session reference/validity, persisted target Branch, exact capability, command/idempotency and correlation identity, expected aggregate/quote version and authoritative decision time. Client actor, Branch, capability, Price and total claims are never authority.

Audit evidence preserves actor, non-secret Session/evidence reference, Branch, target, operation, correlation/idempotency identity, before/result versions, relevant Price/revised-quote references, outcome category and event time. Invalid, stale, revoked or cross-Branch context fails closed before mutation. Identity Milestone 2B, capability assignment and runtime enforcement remain separately unauthorized.

### 3.6 CORE-01 finding disposition

| Finding | Result |
|---|---|
| `CORE01-B01` | `UNRESOLVED — EVIDENCE/DATA_REQUIRED`: exact Prices remain absent. |
| `CORE01-B02` | `UNRESOLVED — QUALIFIED_INPUT_AND_OWNER_DECISION_REQUIRED`: tax/rounding remain deferred. |
| `CORE01-B03` | `RESOLVED_AT_LOGICAL_DESIGN_LEVEL`: Payment target lifecycle and semantic boundary defined. |
| `CORE01-B04` | `RESOLVED_AT_LOGICAL_DESIGN_LEVEL`: deterministic fail-closed resolution defined. |
| `CORE01-M01` | `RESOLVED_AT_LOGICAL_DESIGN_LEVEL`: port, orchestration and context ownership defined. |
| `CORE01-M02` | `RESOLVED_LOGICALLY — SEPARATE_AUTHORIZATION_REMAINS`: trusted evidence defined; Identity implementation remains unauthorized. |

## 4. CORE-02 remediation

### 4.1 Synchronized logical state model

| Axis | Logical states/outcomes | Governing rule |
|---|---|---|
| Dispatch | `pending → dispatched` | Only durable acceptance establishing/locating the one Ticket permits `dispatched`. |
| Outbox | `pending → published` | Publication proves neither acceptance nor Ticket progress. |
| Acceptance attempt | `absent → held_unresolved → accepted / rejected_terminal`; or direct `absent → accepted / rejected_terminal` | Held is non-terminal and fail-closed. Exactly one immutable terminal outcome may be recorded per attempt. |
| Ticket | `queued → in_progress → completed`; `queued → cancelled` | Whole-Ticket completion only; no rewind/delete after work starts. |
| Item | `queued → in_progress → completed` | Item-level progress; no quantity progress initially. |
| Handover | `absent → recorded` | Only after whole-Ticket completion; no partial handover. |
| Exception | `open → escalated / resolved` | Open/escalated blocks closure; only separately authorized resolution may close it. |

Historical `partially_ready`, quantity progress and generic `ready` proposals are excluded from this bounded slice. Preparation completion, handover and terminal Order closure are distinct facts.

### 4.2 Dispatch acceptance, replay and reconciliation

`AcceptDispatch` binds stable Dispatch and acceptance-attempt identity to trusted eligible pending Dispatch, confirmed Order/sold Items, eligible settled Payment, exact Branch and applicable evidence versions. Delivery acknowledgement, Outbox publication, timeout, transport result and caller assertion do not decide business acceptance.

- `accepted` is an immutable terminal outcome. It establishes or locates exactly one Ticket and Ticket Item set; duplicate delivery, replay and lookup return the same result.
- `rejected_terminal` is an immutable terminal rejection. Same-attempt replay returns the rejection; the attempt can never accept. A new attempt requires a separately authorized use case, resolved basis, revalidated eligibility, retained evidence and new identity.
- `held_unresolved` is a non-terminal, fail-closed disposition for missing, stale, conflicting, ambiguous, mismatched, incomplete or unavailable evidence/result. It creates no Ticket. The same attempt may reach one terminal outcome only after corrected authoritative evidence and a separately authorized resolver action.

The two terminal outcomes are mutually exclusive. Response loss or unknown result reconciles by the same Dispatch plus acceptance-attempt identities: return the proven terminal outcome or remain held. Timeout, delivery failure and uncertainty cannot create a replacement attempt. If held reconciliation locates a candidate Ticket or Candidate Ticket Items without a proven accepted binding for those exact identities, the candidate set is quarantined/non-executable: it cannot start, progress, complete or hand over and cannot serve as acceptance evidence. Resolution preserves all candidate/conflict evidence, creates no duplicates and releases the candidate only after corrected authoritative evidence plus separately authorized resolution proves the identity and accepted binding. Otherwise it remains quarantined; a terminal rejection preserves rather than deletes or silently binds the candidate. Physical broker, worker, persistence, transaction/isolation, locks and retry scheduling remain Gate B.

### 4.3 Exception contract

Each exception has a stable identity and correlations to Order, Dispatch, Ticket and optional Item; Branch; actor; reason; observed stage/version; correlation/idempotency identity; event time; logical status; and immutable resolution evidence. Rejected resolution remains recorded and leaves the case open/escalated. Exception handling never authorizes Refund, changes Payment truth or deletes Preparation history. Resolver authority and business dispositions beyond confirmed policy remain Owner dependencies.

### 4.4 Transition and acceptance matrix

| Scenario/command | Preconditions | Required outcome |
|---|---|---|
| Accept Dispatch | Trusted eligible pending Dispatch, Order/sold Item, eligible settled Payment, Branch, attempt and version evidence | Record `accepted` and one Ticket/Item set, or `rejected_terminal`, or fail closed as `held_unresolved`; replay returns the same proven result. |
| Concurrent/duplicate/out-of-order delivery | Same Dispatch plus acceptance-attempt identity | Return the same proven terminal outcome or held disposition; accepted replay locates the same Ticket/Items and creates no duplicate. |
| Terminal rejection | Authoritative `rejected_terminal` for the attempt | Return the same immutable rejection; the attempt is not retryable. A separately authorized new attempt requires resolved basis, revalidated eligibility and a new identity. |
| Missing/ambiguous evidence or result | No proven terminal outcome | Record/retain `held_unresolved`; permit same-attempt replay/lookup or separately authorized held resolution only. Timeout, delivery failure or uncertainty does not authorize a new attempt. |
| Response lost after success | Prior result exists | Locate/replay existing result. |
| Candidate Ticket/Items found while held | No authoritative accepted binding for exact Dispatch plus attempt | Preserve and quarantine the candidate as non-executable; do not start/progress/complete/handover, infer acceptance, delete evidence or create duplicates. Release only after authoritative binding is proved through separately authorized resolution. |
| Start Item | Queued Item/Ticket, trusted actor/Branch/capability/version, no blocking case | Item becomes in progress; Ticket derives in progress. |
| Complete Item | Item in progress plus actor/time/version evidence | Item completes; Ticket completes only when every required Item completes. |
| Partial Item progress across Items | Some Items complete | Ticket remains in progress; partial Ticket completion is prohibited. |
| Quantity progress or partial handover attempt | Any | Reject as outside approved initial policy. |
| Record Customer Custody Transfer | Trusted actor, valid Session evidence, exact Order/Ticket/Branch, exact handover capability, expected Ticket version, stable command identity, authoritative whole-Ticket completion, no prior transfer and trusted evidence of actual release to the customer or customer's recipient | Record acknowledgement evidence, when present, separately from one authoritative custody-transfer fact. Acknowledgement alone does not transfer custody. Exact replay returns the same facts; missing/stale/conflicting transfer evidence fails closed and preserves dispute evidence. |
| Cancel before Dispatch | Same-decision-point proof of no start | Preserve paid facts and block Dispatch; no Refund authority. |
| Cancel queued Ticket | Same-decision-point proof no Item started | Record Ticket cancellation and evidence. |
| Cancel in-progress/completed/handed-over work | Confirmed authority for observed stage | Preserve work/evidence and create/link exception; never infer Refund or closure. |
| Evaluate bounded closure eligibility | Settled Payment, completed Ticket, handover, no open exception | Eligible under `CORE-OD-10C`; no automatic closure command follows. |

`CORE-OD-10C` is the bounded minimum for this exact-cash dine-in/takeaway slice. It does not resolve universal/final `P1A-OD-07`, Delivery, Refund/review settlement, completed-service exceptions or automatic closure.

### 4.5 Trusted handover command

The explicit handover command is Application-owned and distinct from completion. Before mutation it validates trusted actor identity, authenticated Session evidence, exact Order/Ticket/Branch binding, operation-specific handover capability, expected Ticket version, stable command/idempotency identity, authoritative whole-Ticket completion and trusted evidence of actual release to the customer or customer's recipient. Missing, stale, conflicting or mismatched evidence fails closed without custody transfer.

Acknowledgement evidence and authoritative customer custody transfer are separate logical facts and identities even when one command proposes both. Acknowledgement records an actor response/observation and never proves transfer or approval. The custody-transfer fact binds the exact Order, Ticket, Branch and command to the transfer-recording actor, authoritative time, applicable completion/version evidence and trusted evidence that the completed Ticket was actually released. The contract selects no recipient identity scheme, device, signature, API or physical proof mechanism.

Exact duplicate replay returns the same acknowledgement and/or transfer results. Conflicting replay, stale version, missing transfer evidence, refusal, disagreement or unverifiable recipient/transfer evidence creates no custody-transfer fact and preserves the evidence for separately governed resolution. Completion, acknowledgement, approval, custody transfer and Order closure eligibility remain distinct. Custody transfer does not close a Cash Session, resolve discrepancy, authorize Refund or close an Order by itself. This contract assigns no holder and does not authorize Identity Milestone 2B.

### 4.6 ADR-0011 dependency contract

| Interaction | Ownership and direction | Logical failure boundary |
|---|---|---|
| Dispatch acceptance | Preparation Application owns the use case and its required contracts. A delivery adapter calls it; Infrastructure implements upstream evidence/delivery adapters; composition root wires them. | Missing/mismatched eligibility evidence returns held and creates no Ticket. |
| Ordering/Payment evidence | Preparation Application calls published Ordering/Payment Application contracts through Preparation-owned consumer ports. No direct Infrastructure-record access. | Preparation never reinterprets commercial/settlement truth; unavailable/stale/conflicting facts fail closed. |
| Ticket execution/completion | Preparation Domain owns transitions/invariants; Preparation Application orchestrates named commands. Presentation delegates; Infrastructure maps/persists behind contracts. | Invalid or stale transition fails without mutation. |
| Trusted operator evidence | Preparation Application owns the required authorization-evidence contract; an adapter calls the approved Identity Application contract. | Missing actor, Session, Branch or exact capability fails closed and non-disclosing. |
| Handover | Preparation Application owns command/audit orchestration and invokes Domain eligibility. Infrastructure implements required persistence/audit ports. | Incomplete Ticket, prior handover, stale version or conflicting command fails closed. |

Domain remains framework-independent. Application owns orchestration and required contracts. Infrastructure depends on Domain/Application contracts it implements. Presentation does not own transitions. Composition root only wires implementations. No transport, persistence technology, service, class or source path is selected.

### 4.7 CORE-02 finding disposition

| Finding | Result |
|---|---|
| `CORE02-B01` | `RESOLVED_BY_DOCUMENTARY_CORRECTION`: confirmed policy no longer described as open. |
| `CORE02-B02` | `RESOLVED_AT_LOGICAL_DESIGN_LEVEL`: one bounded state/transition model recorded. |
| `CORE02-B03` | `RESOLVED_FOR_BOUNDED_INITIAL_SLICE`: broader `P1A-OD-07` remains deferred. |
| `CORE02-M01` | `RESOLVED_AT_LOGICAL_CONTRACT_LEVEL`: resolver authority/dispositions remain separate. |
| `CORE02-M02` | `RESOLVED_AT_LOGICAL_CONTRACT_LEVEL`: physical delivery/recovery remains Gate B. |
| `CORE02-D01` | `SEPARATE_AUTHORIZATION_DEPENDENCY`: Identity/capability implementation remains unauthorized. |
| `CORE02-IR2-01` | `RESOLVED_AT_LOGICAL_DESIGN_LEVEL`: accepted/rejected terminal outcomes and held non-terminal disposition, replay, lost-result and new-attempt boundaries are explicit. |
| `CORE02-IR2-02` | `RESOLVED_AT_LOGICAL_DESIGN_LEVEL`: handover has trusted command, version, idempotency, audit and fail-closed guards. |
| `CORE02-IR2-03` | `RESOLVED_AT_LOGICAL_DESIGN_LEVEL`: ADR-0011 ownership, ports, adapters, Presentation delegation and composition wiring are explicit. |

## 5. CORE-04 remediation

### 5.1 Operating Day decision package

Confirmed policy remains: first Hoi An Branch `Asia/Ho_Chi_Minh`; explicit per-Branch values; no MVP inheritance; explicit effective exceptional-day evidence; no silent rewrite of a closed Day. `CORE-OD-11B` remains deferred.

Owner question: **What exact local `HH:MM` cutoff applies to the first Hoi An Branch?** Evidence required: actual trading hours, after-midnight activity, count/handover duration, accounting/report expectations, exceptional days and boundary-time transactions. Viable categories are midnight, an evidence-supported fixed post-midnight/early-morning time, or another explicit fixed local time. No option is recommended or selected.

Once selected, the logical Day is `[D at cutoff, D+1 at cutoff)` in the Branch IANA timezone; the boundary event belongs to the new Day. Future DST-observing Branches need explicit invalid/ambiguous local-time treatment.

### 5.2 Capability and correction package

Owner input remains required for eligible holders, Branch scope, delegation/revocation, requester/executor/reviewer separation, emergency behavior and audit evidence across Open, operate, Count, Handover, Close, reconcile, discrepancy disposition and report release. `CORE-OD-13` additionally requires exact permitted linked corrections, requester/approver/executor, reason/evidence and reconciliation/report-hold effects. No generic role, human or default authority is selected.

### 5.3 Distinct lifecycle outcomes

The logical order preserves separate facts: Operating Day assignment; Session Open; append-only movement; Count; handover evidence; disagreement hold; Session Close; Operating Day close; reconciliation result; discrepancy disposition; and authoritative-report eligibility/release.

Invalid implications are explicit: acknowledgement is not approval or Close; Session Close is not reconciliation; discrepancy resolution is not report release; linked correction is not rewrite; new Session opening is not a new daily float; Payment success is not a mutable drawer balance.

### 5.4 Disagreement hold (`CORE04-M01`)

One idempotent case records Branch, Day, outgoing Session, handover evidence, outgoing/proposed incoming actors, count, variance, acknowledgement/refusal/disagreement/observation actor, timestamp, reason and relevant handover/Session references, status, Owner escalation and linked resolution evidence. Recording and preserving an acknowledgement, refusal, disagreement or observation is evidence capture needed to create and investigate the unresolved case. It does not approve, resolve or complete the handover; transfer custody; close either Session; disposition a discrepancy; or release a report. Acknowledgement/refusal evidence cannot silently advance the disputed handover lifecycle. Replay locates the same case; conflicting replay fails closed. While unresolved it preserves outgoing custody/accountability and remains held/escalated under the approved Owner direction. Resolution and every consequential authority remain subject to the existing separately governed Owner/capability decisions and cannot be inferred from the evidence recorder or captured evidence.

### 5.5 Initial exact-cash source (`CORE04-M02`)

`ExactCashPaymentSettled` carries stable source/idempotency identity; Order, Payment and successful Payment Attempt references; Branch; amount and ISO currency; confirmed actor/time; and correlation evidence. Cash resolves an eligible same-Branch Session from Cash-owned state and creates/locates one `cash_sale_inflow` bound to Branch, Day and Session. Identical replay returns the same result; conflicting replay fails closed. Missing/ambiguous/ineligible Session creates or returns an unresolved exception and never changes Payment truth. Correction/reversal requires a separately authorized linked fact.

Cash Refund, Expense, float/top-up, post-close correction and manual bank are excluded from this initial contract.

### 5.6 CORE-04 finding disposition

| Finding | Result |
|---|---|
| `CORE04-B01` | `UNRESOLVED — DEFERRED_OWNER_DECISION`: cutoff package prepared; value not selected. |
| `CORE04-B02` | `UNRESOLVED — DEFERRED_OWNER_DECISIONS`: capability/correction package prepared. |
| `CORE04-B03` | `RESOLVED_BY_DOCUMENTARY_CORRECTION`: summary synchronized to confirmed policy. |
| `CORE04-B04` | `RESOLVED_AT_LOGICAL_DESIGN_LEVEL`: Close/reconciliation/disposition/release separated. |
| `CORE04-M01` | `PARTIALLY_RESOLVED`: logical hold/accountability closed; resolver authority remains deferred. |
| `CORE04-M02` | `RESOLVED_FOR_INITIAL_SCOPE`: exact-cash source defined; future sources excluded. |
| `CORE04-D01` | `SEPARATE_AUTHORIZATION_DEPENDENCY`: Identity and Reporting authority remain unauthorized. |

## 6. Cross-workstream consistency matrix

| Relationship | Consistent contract | Remaining dependency |
|---|---|---|
| CORE-01 → CORE-02 | Only eligible settled Payment creates the existing Dispatch; Ticket uses immutable sold-item facts and cannot rewrite Payment. | Ticket implementation requires Gate A/B and trusted capability implementation. |
| CORE-02 → Ordering closure | Completion, handover and no-open-exception are separate evidence under bounded `CORE-OD-10C`. | Broader `P1A-OD-07` remains deferred. |
| CORE-01 → CORE-04 | Exact-cash source uses the same authoritative Order, Payment target and successful Attempt; Cash failure cannot rewrite Payment. | Cash Session implementation and capability assignment remain unauthorized. |
| CORE-04 → Reporting | Reconciled Cash facts only; disposition and release remain separate. | Cutoff, release authority and Reporting read/retention decisions remain open. |
| CORE-03/P1 → all | Logical commands require actor/session/Branch/exact capability evidence and fail closed. | Identity Milestone 2B and assignments remain unauthorized. |
| Excluded domains | Inventory, Promotions, Loyalty, Refund and future Cash movements cannot gate or rewrite the initial flows. | Each requires separate policy/design/Gates. |

## 7. Gate A submission checklists

### CORE-01

- [ ] Exact Product/Variant Price dataset, scope and effective time supplied without inferring from bands.
- [ ] Qualified tax/accounting constraints and Owner `CORE-OD-03/04` decisions recorded.
- [x] Payment-target lifecycle and semantic boundary defined.
- [x] Deterministic fail-closed Catalog/Price resolution defined.
- [x] Port/orchestration and trusted-command contracts defined.
- [ ] Fresh independent review confirms closure.

Result: `NOT_READY_FOR_OWNER_GATE_A_REVIEW`.

### CORE-02

- [x] Confirmed policy synchronized.
- [x] Dispatch/Outbox/Ticket/Item/Handover/Exception axes defined.
- [x] Acceptance/replay/reconciliation contract defined.
- [x] Accepted/rejected terminal outcomes and held non-terminal disposition defined.
- [x] Dispatch-plus-attempt replay/new-attempt rules and Candidate Ticket quarantine defined.
- [x] Acknowledgement and authoritative customer custody-transfer evidence defined separately.
- [x] ADR-0011 ownership, port/adapter direction and composition boundary defined.
- [x] Bounded closure reconciled with deferred `P1A-OD-07`.
- [x] Logical acceptance matrix defined.
- [ ] Fresh independent re-review confirms `CORE02-FIR-01` and `CORE02-FIR-02` closure.

Result: `READY_FOR_FRESH_INDEPENDENT_GATE_A_REVIEW — NO_GATE_GRANTED`.

### CORE-04

- [ ] Exact cutoff decided (`CORE-OD-11B`).
- [ ] Capability/separation policy decided (`CORE-OD-12`).
- [ ] Post-close correction policy decided (`CORE-OD-13`).
- [x] Confirmed policy synchronized.
- [x] Distinct lifecycle and report-hold model defined.
- [~] Disagreement hold defined; resolver authority remains open.
- [x] Initial exact-cash source defined; future sources excluded.
- [ ] Disposition/report-release authority closed and fresh independent review completed.

Result: `NOT_READY_FOR_OWNER_GATE_A_REVIEW`.

## 8. Later Gate B concerns and exclusions

Gate B must separately review exact files, schema/migrations, constraints, indexes, transaction/isolation/lock strategy, recovery, broker/worker/transport, API/DTO/errors, authentication integration, tests and rollback. None is selected here.

Explicit exclusions remain: manual bank; Refund execution; Service Charge; price-changing Modifiers; complimentary/zero-price Items; direct sold-price override; Promotions; Loyalty; Inventory; future Cash Refund/Expense/float/top-up/correction sources; report read/export/recipient/schedule/external delivery; and production operations.

## 9. Critical path and next steps

1. In parallel, obtain exact Price transcription and qualified tax/rounding input; conduct a fresh independent CORE-02 review; and obtain CORE-04 cutoff/capability/correction inputs.
2. Update CORE-01 only from supplied evidence and recorded Owner decisions, then independently re-review.
3. Update CORE-04 authority/disposition boundaries only from explicit Owner input, then independently re-review.
4. Submit separate exact Gate A requests only for workstreams that satisfy their checklist.
5. Prepare no Gate B manifest or implementation until the applicable Gate A is explicitly approved.

## 10. Authorization statement

This remediation preserves `CORE-OD-01`, retired `CORE-OD-02`, all 27 confirmed and seven deferred decisions, all `ID_PENDING_OWNER_GOVERNANCE` references, Refund separation, Inventory deferral, manual-bank exclusion, CORE-03/Identity Milestone 2B non-authorization, Reporting restrictions and all Gate boundaries.

**Final status:** `CORE_01_INPUT_BLOCKED — CORE_02_READY_FOR_FRESH_INDEPENDENT_REVIEW_ONLY — CORE_04_OWNER_INPUT_BLOCKED — ZERO_GATES_GRANTED — ZERO_IMPLEMENTATION_AUTHORIZED`.
