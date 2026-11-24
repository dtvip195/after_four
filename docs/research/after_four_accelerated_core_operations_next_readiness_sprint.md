# AFTER FOUR — Accelerated Core Operations Next Readiness Sprint

**Sprint status:** `EVIDENCE_AND_REVIEW_COMPLETE — CORE_01_INPUT_BLOCKED — CORE_02_DESIGN_CORRECTION_REQUIRED — CORE_04_OWNER_INPUT_REQUIRED`

**Repository baseline:** `main` / local `origin/main` at `87437e8153311a1b8c551fafebfb490f733381ed`

**Evidence cutoff:** 2026-11-24 (Asia/Tokyo)

**Scope:** Documentation, evidence preparation and independent design review only

**Gate or implementation authorization created by this sprint:** `NONE`

## 1. Executive result

This sprint ran three independent readiness tracks against the current merged Core Operations baseline:

| Track | Result | Immediate consequence |
|---|---|---|
| CORE-01 exact commercial input | `NOT_READY_FOR_OWNER_GATE_A_REVIEW — INPUT_BLOCKED` | The 28 approved-by-reference Product rows are fully traceable, but exact Product/Variant Prices, final Variant applicability and qualified Tax/Accounting constraints remain absent. |
| CORE-02 Preparation execution | `NOT_READY_FOR_OWNER_GATE_A_REVIEW — DESIGN_CORRECTION_REQUIRED` | The post-remediation design is substantially coherent, but three technical-design gaps remain: fail-closed rejected/uncertain acceptance, trusted handover-command guards and ADR-0011 dependency contracts. |
| CORE-04 Cash and reconciliation | `NOT_READY_FOR_OWNER_GATE_A_REVIEW — OWNER_INPUT_REQUIRED` | Six independently answerable Owner policy areas remain open. Evidence and decision questions are prepared below without selecting policy for the Owner. |

No track is honestly ready for Gate A presentation. The fastest safe next work is parallel: correct and independently re-review CORE-02; obtain the exact CORE-01 commercial and qualified evidence; and conduct the bounded CORE-04 Owner decision session. No application, schema, migration, database, dependency or runtime work is authorized.

This sprint preserves the [Owner Decision Baseline](../architecture/after_four_owner_decision_baseline.md), accepted [ADR-0011](../architecture/adr/0011-project-wide-layered-ddd.md), the [Accelerated Core Operations Design Package](after_four_accelerated_core_operations_design_package.md), its [Design Remediation](after_four_accelerated_core_operations_design_remediation.md), the [Independent Design Review](after_four_core_operations_independent_design_review.md), and the [Development Readiness Assessment](after_four_accelerated_core_operations_readiness_assessment.md).

## 2. Evidence and classification rules

| Label | Meaning |
|---|---|
| `OWNER_CONFIRMED` | Policy recorded in the canonical Owner Decision Baseline. |
| `OWNER_CONFIRMED_BY_REFERENCE` | Owner-approved content identified by an exact repository artifact; missing data or transcription details remain explicit. |
| `REPOSITORY_EVIDENCE` | A fact found in a cited repository source. It is not Owner authority. |
| `PROPOSED_NOT_APPROVED` | A recommendation or design direction requiring the applicable review and approval. |
| `OWNER_INPUT_REQUIRED` | An unresolved business-policy choice reserved for the Owner. |
| `PROFESSIONAL_INPUT_REQUIRED` | Qualified evidence is required before an Owner policy or executable design can be completed. |
| `DESIGN_CORRECTION_REQUIRED` | A technical-design gap must be corrected and independently rechecked; it does not itself require a new business policy. |

Repository presence, existing implementation or a recommendation does not grant a Gate or implementation authority. Approximate price bands are not exact Prices. A recorded exception or acknowledgement is evidence, not approval.

### 2.1 Principal files inspected

- `AGENTS.md`;
- `docs/architecture/after_four_owner_decision_baseline.md`;
- `docs/architecture/after_four_ddd_foundation.md`;
- `docs/architecture/after_four_business_domain_model.md`;
- `docs/architecture/adr/0011-project-wide-layered-ddd.md`;
- `docs/architecture/after_four_proposed_launch_menu_v3.md`;
- `docs/architecture/after_four_real_menu_pricing_specification.md`;
- `docs/research/after_four_accelerated_core_operations_design_package.md`;
- `docs/research/after_four_accelerated_core_operations_design_remediation.md`;
- `docs/research/after_four_core_operations_independent_design_review.md`;
- `docs/research/after_four_accelerated_core_operations_readiness_assessment.md`;
- relevant cited Order, Payment, Preparation, Catalog and Identity source/spec paths used by those controlling documents.

The only file created by this sprint is this consolidated report.

## 3. CORE-01 — Exact menu, Product, Variant and Price evidence

### 3.1 Authoritative transcription coverage

`CORE-OD-01` approves by reference the 28 named rows, six groupings and presented option labels in [Proposed Launch Menu v3](../architecture/after_four_proposed_launch_menu_v3.md), plus approximate price directions. It does not approve canonical codes, a final persisted Variant set or an exact Price for any Product/Variant ([Owner Decision Baseline — Accelerated Core Operations menu-baseline decision](../architecture/after_four_owner_decision_baseline.md)).

Every transcription row below traces to its named source section; the source supplies the Product wording and presented option labels, while its header supplies the explicit `TBD` exact-Price status.

| Group | Exact source section |
|---|---|
| Cà phê | [Proposed Launch Menu v3 §1](../architecture/after_four_proposed_launch_menu_v3.md) |
| Trà trái cây | [Proposed Launch Menu v3 §2](../architecture/after_four_proposed_launch_menu_v3.md) |
| Nước ép và giải khát | [Proposed Launch Menu v3 §3](../architecture/after_four_proposed_launch_menu_v3.md) |
| Sinh tố và đá xay | [Proposed Launch Menu v3 §4](../architecture/after_four_proposed_launch_menu_v3.md) |
| Thức uống khác | [Proposed Launch Menu v3 §5](../architecture/after_four_proposed_launch_menu_v3.md) |
| Bánh và đồ ăn nhẹ | [Proposed Launch Menu v3 §6](../architecture/after_four_proposed_launch_menu_v3.md) |

| Group | Artifact label | Approved-by-reference Product | Presented option evidence | Exact Price evidence |
|---|---|---|---|---|
| Cà phê | `CF001` | Cà phê đen | Đá / Nóng | `MISSING` |
| Cà phê | `CF002` | Cà phê sữa | Đá / Nóng | `MISSING` |
| Cà phê | `CF003` | Bạc xỉu | Đá / Nóng | `MISSING` |
| Cà phê | `CF004` | Cà phê muối | Đá | `MISSING` |
| Cà phê | `CF005` | Cà phê dừa | Đá | `MISSING` |
| Cà phê | `CF006` | Latte | Đá / Nóng | `MISSING` |
| Trà trái cây | `TR001` | Trà đào cam sả | S / M / L — actual applicability requires confirmation | `MISSING` |
| Trà trái cây | `TR002` | Trà vải | S / M / L — actual applicability requires confirmation | `MISSING` |
| Trà trái cây | `TR003` | Trà chanh | S / M / L — actual applicability requires confirmation | `MISSING` |
| Trà trái cây | `TR004` | Trà tắc mật ong | S / M / L — actual applicability requires confirmation | `MISSING` |
| Trà trái cây | `TR005` | Trà chanh dây | S / M / L — actual applicability requires confirmation | `MISSING` |
| Nước ép và giải khát | `NG001` | Nước chanh | S / M / L — actual applicability requires confirmation | `MISSING` |
| Nước ép và giải khát | `NG002` | Chanh dây đá | S / M / L — actual applicability requires confirmation | `MISSING` |
| Nước ép và giải khát | `NG003` | Cam ép | S / M / L — actual applicability requires confirmation | `MISSING` |
| Nước ép và giải khát | `NG004` | Soda chanh | S / M / L — actual applicability requires confirmation | `MISSING` |
| Sinh tố và đá xay | `SM001` | Bơ xay dừa non | S / M / L — actual applicability requires confirmation | `MISSING` |
| Sinh tố và đá xay | `SM002` | Sinh tố xoài | S / M / L — actual applicability requires confirmation | `MISSING` |
| Sinh tố và đá xay | `SM003` | Sinh tố dâu | S / M / L — actual applicability requires confirmation | `MISSING` |
| Sinh tố và đá xay | `SM004` | Cà phê dừa đá xay | S / M / L — actual applicability requires confirmation | `MISSING` |
| Thức uống khác | `KH001` | Matcha latte | Đá / Nóng; size unresolved | `MISSING` |
| Thức uống khác | `KH002` | Cacao sữa | Đá / Nóng; size unresolved | `MISSING` |
| Thức uống khác | `KH003` | Sữa chua trái cây | Default; size unresolved | `MISSING` |
| Bánh và đồ ăn nhẹ | `BA001` | Bánh croissant | Một phần | `MISSING` |
| Bánh và đồ ăn nhẹ | `BA002` | Cheesecake | Một phần | `MISSING` |
| Bánh và đồ ăn nhẹ | `BA003` | Brownie chocolate | Một phần | `MISSING` |
| Bánh và đồ ăn nhẹ | `BA004` | Muffin | Một cái | `MISSING` |
| Bánh và đồ ăn nhẹ | `BA005` | Sandwich jambon phô mai | Một phần | `MISSING` |
| Bánh và đồ ăn nhẹ | `BA006` | Khoai tây chiên | Một phần | `MISSING` |

Reconciliation: `6 + 5 + 4 + 4 + 3 + 6 = 28` named Product rows and six groupings. Product transcription coverage is `28/28`. Exact Price coverage is zero. A `0/N Variant` fraction would be misleading because the final applicable and persisted Variant set is not yet established. The artifact labels above are traceability labels, not canonical codes.

The only approved price information is approximate direction: VND 23,000, VND 33,000 and VND 43,000–49,000. No source maps an individual Product or Variant to a band or exact amount. Blank/example rows in the [Real Menu and Pricing Specification](../architecture/after_four_real_menu_pricing_specification.md) and frontend demo fixture values are not authoritative Price evidence.

### 3.2 Missing and discrepancy register

| Finding | Evidence conclusion | Readiness consequence |
|---|---|---|
| `CORE01-E01` | No exact amount exists for any approved sellable Product/Variant. | Blocks executable Pricing and sold-price snapshots. |
| `CORE01-E02` | No Product/Variant-to-approximate-band mapping exists. | Bands cannot be converted into Price rows. |
| `CORE01-E03` | Final Variant applicability, capacities and persisted identities are unresolved. | Exact Price denominator and implementation manifest cannot be frozen. |
| `CORE01-E04` | Menu artifact labels are not canonical codes. | They must not be imported as identifiers without approval. |
| `CORE01-E05` | Approved groupings are business input, not approved Category seed records/order. | No seed manifest follows from the source. |
| `CORE01-E06` | No Price scope, effective-time dataset or Branch override dataset exists. | No immutable effective Price Version can be asserted. |
| `CORE01-E07` | Tax applicability and inclusive/exclusive/display treatment remain deferred under `CORE-OD-03`. | Qualified input and Owner decision remain required. |
| `CORE01-E08` | Precision, rounding mode, rounding boundary and calculation order remain deferred under `CORE-OD-04`. | Deterministic calculation and later allocation remain blocked. |
| `CORE01-E09` | Modifier applicability, cardinality, quantity and Price effects remain unresolved; price-changing Modifiers are outside the initial slice. | Must not be folded into first-slice Price evidence. |
| `CORE01-E10` | Demo values such as Cà phê sữa at 45,000 VND and Matcha latte at 62,000 VND are UI fixtures. | They are non-authoritative examples, not conflicting Owner evidence. |
| `CORE01-E11` | Latte 350/500 ml appears only as an example in an input template. | It is not an approved Variant set. |
| `CORE01-E12` | Option labels are approved by reference while actual applicability/capacity remains unresolved. | This is a bounded distinction, not a policy conflict. |

### 3.3 Qualified Vietnamese Tax/Accounting input brief

Qualified input must state constraints for the actual seller/entity, Product class, transaction and receipt/invoice context. It must address:

1. applicable tax treatment and effective date;
2. tax-inclusive versus tax-exclusive display/contract treatment;
3. required receipt/invoice presentation of gross, net, rate and tax amount;
4. component, line or Order computation boundary;
5. required VND precision;
6. acceptable rounding modes;
7. component, line, subtotal or Order rounding boundary;
8. calculation sequence and reconciliation to the exact Payment target;
9. any material dine-in/takeaway distinction; and
10. authoritative sources, assumptions, limitations and effective dates.

Professional input supplies constraints; it does not choose Product/Variant Prices, Service Charge, Modifier pricing, schema, numeric types, algorithms, transactions or implementation authority.

### 3.4 Owner inputs after evidence

The Owner must eventually confirm the exact canonical Product/Variant transcription dataset, actual Variant applicability/capacity, one exact Price and scope/effective time for every sellable Variant, and any Branch override. After qualified constraints are available, `CORE-OD-03` and `CORE-OD-04` remain independently answerable Owner policy decisions. The approved 28 names, six groupings, presented option labels, approximate bands and existing first-slice exclusions must not be reopened.

**CORE-01 readiness:** `NOT_READY_FOR_OWNER_GATE_A_REVIEW — INPUT_BLOCKED`.

## 4. CORE-02 — Independent post-remediation design review

### 4.1 Review result

The review assessed implemented-versus-proposed separation, Dispatch/Outbox/Ticket/Item state separation, idempotent acceptance, duplicate delivery, Item-level progress, completion/handover, cancellation, exception evidence, closure, trusted command boundaries, ADR-0011 dependency direction and governance preservation.

| Stable finding | Severity | Result and required correction |
|---|---|---|
| `CORE02-IR2-01` | `BLOCKER` | `Rejected` and held/unresolved acceptance lack separate durable fail-closed logical outcomes. A pending Dispatch with no Ticket is otherwise retryable. Define the distinct accepted, rejected-terminal and held/unresolved semantics in §4.2, including attempt identity, replay, lost-response lookup and separately authorized resolution; do not select persistence, transaction, locking or transport mechanisms. |
| `CORE02-IR2-02` | `MAJOR` | The explicit handover command lacks the trusted actor, exact Branch, operation-specific capability, idempotency identity, expected-version and audit guards applied to other Preparation mutations. Add the fail-closed command contract without assigning a capability holder or authorizing CORE-03. |
| `CORE02-IR2-03` | `MAJOR` | CORE-02 lacks an explicit ADR-0011 dependency contract. Document Preparation Application ownership of acceptance/use-case contracts, Infrastructure adapter implementation, Presentation delegation where applicable and composition-root wiring, without selecting files, framework, transport or persistence. |

### 4.2 Required acceptance outcome model

The correction for `CORE02-IR2-01` must preserve Dispatch business state, Outbox delivery state, Ticket state and Ticket Item state as separate axes. An Outbox delivery result is not an acceptance decision, and repeated delivery does not create a new business attempt.

| Logical acceptance outcome | Meaning and terminality | Permitted transition | Prohibited transition |
|---|---|---|---|
| `accepted` | Authoritative acceptance for the identified Dispatch acceptance attempt after every required evidence check and guard passes. Terminal for that attempt. | Idempotently return the same accepted result and the same Ticket identity on duplicate delivery, replay or result lookup. | Must not create another Ticket or duplicate Ticket Items, return to undecided, or accept a different/mismatched Dispatch under the same attempt. |
| `rejected_terminal` | Authoritative decision that the identified acceptance attempt is rejected. Terminal for that attempt; it is not a transient delivery failure. | Idempotently return the same rejection for same-attempt retry, duplicate delivery, replay or result lookup. A new business attempt is permitted only through a separately authorized use case after the rejection basis is resolved, Dispatch eligibility is revalidated and a new attempt identity is issued while retaining the rejected evidence. | The rejected attempt must never become accepted, create a Ticket/Ticket Items, be silently retried as a new attempt, or be overwritten by a later delivery. |
| `held_unresolved` | Acceptance cannot safely be decided because required evidence is missing, stale, conflicting, ambiguous, mismatched or incomplete, or because the authoritative result cannot be established. Not accepted and not rejected; non-terminal as a case, but fail-closed for execution. | Same-attempt delivery or lookup may return the same held result. Resolution may occur only after required evidence is supplied and a separately authorized resolver action validates that evidence for the same Dispatch and attempt; the explicit resolution then records accepted or rejected-terminal outcome. | Must not create a Ticket/Ticket Items, advance Ticket execution, infer rejection, silently become accepted, or create a replacement attempt merely because of timeout, delivery failure or uncertainty. |

Same-attempt retry means replay or result lookup using the same stable Dispatch and acceptance-attempt identity; it never means creating new business facts. A new attempt after `rejected_terminal` is a distinct, separately authorized business action with a new attempt identity. A held case remains the same attempt until an authorized resolution records its explicit outcome; no automatic recovery authority exists.

If a response is lost or the result is unknown, the caller must query/reconcile by the same stable identities. A proven recorded `accepted` or `rejected_terminal` outcome is returned idempotently. Missing, conflicting or unavailable authoritative result evidence yields `held_unresolved`; network success/failure, timeout, Outbox delivery status or caller assertion cannot select an acceptance outcome.

Acceptance requires trusted evidence binding the exact Dispatch, eligible confirmed Order/Payment facts, expected Branch, attempt identity and applicable version/guard facts. Resolving a held case requires the missing or corrected authoritative evidence plus a separately authorized resolver action whose identity, capability, reason and audit evidence are recorded. This requirement does not identify the resolver, grant the capability or choose a recovery workflow.

`held_unresolved` is a fail-closed, non-terminal disposition, not a terminal acceptance outcome. After authoritative evidence and separately authorized resolution, that same attempt may receive exactly one terminal outcome: `accepted` or `rejected_terminal`. The two terminal outcomes are mutually exclusive and immutable; once either is recorded, replay and result lookup return that same outcome, and the attempt can never record the other. A held attempt cannot be replaced by a new attempt merely because of timeout, delivery failure or uncertainty. Ticket creation is allowed only as the consequence of the first proven `accepted` terminal outcome, under a stable one-Dispatch/one-Ticket identity rule; replay returns that Ticket. A rejected-terminal or held disposition creates no Ticket or Ticket Items. A conflicting outcome or identity fails closed into the unresolved-case path rather than advancing any state.

These are logical semantics only. Physical persistence, uniqueness enforcement, transaction/isolation, locks, broker behavior, transport and retry scheduling remain later Gate B design decisions.

### 4.3 Dimensions that remain sound

- Current pending Dispatch/Outbox implementation is separated from proposed Ticket execution.
- Dispatch business state, Outbox delivery state, Ticket state and Ticket Item state are distinct.
- Duplicate semantic delivery is intended to resolve to one Ticket and not duplicate Ticket Items.
- Progress is Item-level; quantity-level progress, partial Ticket completion and partial Ticket handover are excluded.
- Cancellation consequences are stage-specific, do not infer Refund authority and do not automatically close the Order.
- Exception evidence is distinct from resolver authority.
- Bounded first-slice closure remains distinct from deferred universal `P1A-OD-07`.
- Inventory and Refund remain outside the bounded design.
- No Gate or implementation authority is implied.

The three findings are technical-design corrections. They do not require reopening Owner business policy. Because a blocker and two major gaps remain, no Owner Gate A brief is produced in this sprint.

**CORE-02 readiness:** `NOT_READY_FOR_OWNER_GATE_A_REVIEW — DESIGN_CORRECTION_REQUIRED`.

## 5. CORE-04 — Consolidated Owner decision session package

Every item below is independently answerable. Recommendations are `PROPOSED_NOT_APPROVED`. An approval, deferral or written condition on one item does not decide another.

### 5.1 `CORE-OD-11B` — exact first-Branch cutoff

**Owner question:** What fixed local `HH:MM` cutoff applies to the first Hoi An Branch using `Asia/Ho_Chi_Minh`?

Already fixed: each Branch uses an explicit timezone and cutoff; there is no MVP inheritance; exceptional days require explicit effective evidence; closed Operating Days are not rewritten. Chain-wide timezone substitution and a moving “when close” cutoff are not valid options.

| Source-supported direction | Benefit | Trade-off |
|---|---|---|
| Local midnight | Simple and calendar-aligned. | May split late service and reconciliation work. |
| A fixed post-midnight/early-morning time supported by operational evidence | Can group late service into one Operating Day. | Delays close/report and complicates boundary transactions. |
| Another explicit fixed local time supported by evidence | Can match actual operating practice. | Requires disciplined configuration and exceptional-day control. |

**Recommendation:** `RECOMMENDATION_NOT_ESTABLISHED`. Obtain hours, after-midnight traffic, close/count/handover duration, boundary examples and Accounting/Reporting expectations first.

### 5.2 `CORE-OD-12` — capability, delegation and separation policy

The Owner questions remain separate:

- `12A`: which accountable capability source/holder model applies to each explicitly defined Cash operation, including Open, Count, Handover, Close, Cash reconciliation and discrepancy disposition?
- `12B`: what delegation, revocation and emergency boundaries apply?
- `12C`: what separation-of-duties and conflict rules apply?

Already fixed: Open, Count, Handover and Close are separate Branch-scoped capabilities. Generic Staff status, Employee Shift or Branch Assignment grants none. `CORE-OD-12` governs Cash operations only; it does not grant authoritative-report release, report reading, export, recipient or delivery authority.

| Policy model for Owner consideration | Benefit | Trade-off |
|---|---|---|
| Strict distinct actors | Strong separation. | May be operationally infeasible in a small Branch. |
| Risk-tiered separation | Separates higher-risk Cash correction and discrepancy disposition while permitting bounded Cash operations. | Needs precise risk and exception rules. |
| Same actor only for explicitly enumerated operations under explicit authority/evidence | More operable with small staffing. | Greater abuse/conflict risk; requires tighter evidence and escalation. |

**Recommendation:** confirm only operation-specific, Branch-scoped, fail-closed Cash capability principles now. `RECOMMENDATION_NOT_ESTABLISHED` for actual assignees, delegation and separation until Cash operations plus Accounting control evidence exists. No human appointment, reporting authority or technical enforcement is in this ballot.

### 5.3 `CORE-OD-13` — linked post-close correction operations and authority

The Owner must independently decide permitted operations, initiator/requester, approver, executor, mandatory reason/evidence and reconciliation/reporting consequences. Closed evidence remains immutable; a correction is a new attributable linked fact.

| Option | Benefit | Trade-off |
|---|---|---|
| No post-close correction operations in the initial slice; unresolved facts remain held | Avoids inventing authority and unsafe mutation. | Operational errors may remain unresolved and block reports. |
| Bounded enumerated linked corrections with separately approved requester/approver/executor | Enables controlled recovery. | Requires Accounting controls, audit evidence and separation policy. |
| Broad linked-adjustment capability | Flexible. | Highest abuse/control risk and not supported as a preferred source direction. |

**Recommendation:** no post-close correction operation in the initial slice unless Cash, Accounting and Reporting first supply an operation/evidence/authority model; then consider bounded enumerated operations separately.

### 5.4 Detailed handover disagreement resolution

**Owner question:** After acknowledgement, refusal or disagreement evidence is recorded and escalation reaches the Owner, who resolves it and which controlled consequences may that resolution authorize?

Already fixed: recording actor, timestamp, reason and handover/session references preserves evidence only. It does not approve or resolve the handover, transfer custody, complete or close a Session, disposition a discrepancy or release reporting. Acknowledgement is not approval.

| Option | Benefit | Trade-off |
|---|---|---|
| Owner resolves each disagreement initially | Strong authority trace for the first slice. | Owner bottleneck. |
| Separately delegated operation-specific resolver with Owner escalation | Scales operations. | Requires the unresolved capability/delegation/separation policy. |
| Remain held pending a separate case decision | Safest default where authority is unclear. | Sessions and reports may stall. |

**Recommendation:** Owner resolution for the bounded first slice, with no automatic lifecycle consequence. Every consequence must be explicit and separately authorized. This recommendation remains `PROPOSED_NOT_APPROVED`.

### 5.5 Discrepancy investigation and disposition

`CORE-OD-15A` must keep classification/investigation, escalation, resolver/disposition authority and any linked correction separate. Every nonzero discrepancy remains recorded with reason and Owner notification; no tolerance or threshold may exempt those requirements.

**Recommendation:** `RECOMMENDATION_NOT_ESTABLISHED`. Cash, Accounting and Reporting must provide candidate classes, initiator/approver/resolver responsibilities, separation/escalation evidence and consequences. Until then, an unresolved discrepancy remains held. Do not invent amount thresholds, tolerance or correction authority.

### 5.6 Authoritative-report hold and release

`CORE-OD-15B` remains independent from Cash capability assignment and discrepancy resolution. The Owner must decide what constitutes reconciled/authoritative evidence, who dispositions unresolved cases, whether any exception release exists, who may release it and with what evidence/limitations. Neither Cash reconciliation authority nor discrepancy disposition grants report-release authority. Reporting reader capability and scope remain separately deferred under `CORE-OD-16B`; release never grants read, export, recipient or delivery authority.

| Option | Benefit | Trade-off |
|---|---|---|
| No exception release; only fully reconciled facts are authoritative | Strongest integrity and simplest authority boundary. | Authoritative reporting may be delayed or incomplete. |
| Bounded annotated exception release after separately authorized independent review | Supports exceptional operational need with visible qualification. | Requires evidence, reviewer/releaser authority and misuse controls. |
| Owner-only exception release | Clear interim authority. | Owner bottleneck and still requires explicit evidence/limits. |

**Recommendation:** no exception release in the first slice. Consider another option only if qualified Accounting/Reporting evidence establishes a need and the Owner separately approves it. This grants no report-read, export, recipient or delivery authority.

### 5.7 Sequencing

`CORE-OD-11B` can be decided independently after Branch-operations and Accounting evidence. `CORE-OD-12` Cash-capability principles affect the Cash-authority portions of `CORE-OD-13`, handover resolution and `CORE-OD-15A`, but review can proceed in parallel where the dependency is explicit. `CORE-OD-13` and `CORE-OD-15A` should be reviewed together while remaining separate decisions. Handover resolution is independent unless it dispositions a discrepancy. `CORE-OD-15B` follows reconciliation/disposition evidence but remains a separate report-hold/release policy decision; `CORE-OD-16B` separately governs report-reader capability and scope.

**CORE-04 readiness:** `NOT_READY_FOR_OWNER_GATE_A_REVIEW — OWNER_INPUT_REQUIRED`.

## 6. Cross-workstream consistency and critical path

| Dependency | Consistent boundary |
|---|---|
| CORE-01 → CORE-02 | Preparation receives only a confirmed, settled and eligible Dispatch. CORE-02 does not calculate Prices or reinterpret Payment truth. |
| CORE-01 → CORE-04 | Exact cash settlement is not a Cash Session movement model. Cash requires its own authoritative movement and reconciliation facts. |
| CORE-02 → CORE-04/05 | Preparation execution facts may become later reconciliation/reporting inputs only after their own accepted design and implementation. |
| CORE-03 → all operator mutations | Trusted actor, Session, exact Branch and operation-specific capability remain a prerequisite; this sprint does not authorize Identity Milestone 2B. |
| CORE-04 → CORE-05 | Unreconciled Cash facts remain held from authoritative reporting. Cash reconciliation or discrepancy-disposition authority does not imply report release; `CORE-OD-15B` governs hold/release policy and deferred `CORE-OD-16B` separately governs report-reader capability/scope. Neither grants export, recipient or delivery authority. |
| Inventory | Inventory implementation remains deferred and is not required to create, pay, prepare or hand over an Order. No stock logic is embedded in Ordering, Payment or Preparation. |

Recommended parallel next actions:

1. Correct the three CORE-02 design findings and run a fresh independent review.
2. Freeze the 28-row CORE-01 transcription without turning artifact labels into canonical codes; obtain final Variant applicability and exact Price/scope/effective-time input.
3. Commission qualified Vietnamese Tax/Accounting input for `CORE-OD-03/04` without treating professional advice as the Owner decision.
4. Present the six CORE-04 decision areas to the Owner, preserving their independent answerability and evidence prerequisites.
5. Keep CORE-03, CORE-05, Inventory, Promotions and Loyalty outside implementation until their own prerequisites and Gates are satisfied.

## 7. Decision and governance reconciliation

- The consolidated Core Operations record remains 34 unique local references: 27 Owner-confirmed and seven deferred (`CORE-OD-03`, `CORE-OD-04`, `CORE-OD-11B`, `CORE-OD-12`, `CORE-OD-13`, `CORE-OD-16B`, `CORE-OD-16F`).
- All local references retain `ID_PENDING_OWNER_GOVERNANCE`; no canonical `ODB-*` ID is allocated here.
- `CORE-OD-01` remains approved by reference; its 28 rows, six groupings and option labels are not reopened.
- Identity Milestone 2B and broader P1/P2/P3, Package C, Gate A/B/C, Control Acceptance, FOA and Production Authorization remain unchanged and ungranted where previously ungranted.
- No external contact, disclosure, professional engagement, dependency adoption or expenditure is authorized.
- No application source, test, schema, migration, database, configuration, runtime or deployment change is authorized or performed.

## 8. Validation record

- The transcription contains exactly 28 unique artifact-labelled Product rows and reconciles to six source groupings; no exact Price is asserted.
- The canonical consolidated review table reconciles to 27 confirmed and seven deferred local decision references; `CORE-OD-01` remains the separately recorded approved-by-reference menu decision and `CORE-OD-02` remains retired.
- Markdown table column counts and fenced-block balance pass.
- Every local Markdown link target in this report exists.
- Whitespace validation passes for the new document.
- The complete change set contains this documentation file only; no application, test, schema, migration, dependency, configuration or runtime file is changed.
- No application test, service or database command was run.

## 9. Sprint completion status

`READINESS_SPRINT_COMPLETE — CORE_01_INPUT_BLOCKED — CORE_02_DESIGN_CORRECTION_REQUIRED — CORE_04_OWNER_INPUT_REQUIRED — ZERO_GATES_GRANTED — ZERO_IMPLEMENTATION_AUTHORIZED`
