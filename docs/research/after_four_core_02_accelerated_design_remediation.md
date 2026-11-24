# AFTER FOUR — CORE-02 Accelerated Design Remediation

**Status:** `READY_FOR_FRESH_INDEPENDENT_GATE_A_REVIEW — NO_GATE_GRANTED`

**Base commit:** `4c0856b0d9786e7009e9d49ff6889ba006efc474`

**Evidence cutoff:** 2026-11-24 (Asia/Tokyo)

**Scope:** Logical CORE-02 Preparation design remediation only

**Implementation authorization:** `NOT_GRANTED`

## 1. Purpose and authority boundary

This report closes the authored design gaps `CORE02-IR2-01`, `CORE02-IR2-02` and `CORE02-IR2-03` identified in the [Next Readiness Sprint](after_four_accelerated_core_operations_next_readiness_sprint.md). It synchronizes the canonical CORE-02 sections in the [Accelerated Core Operations Design Package](after_four_accelerated_core_operations_design_package.md) and the earlier [Design Remediation](after_four_accelerated_core_operations_design_remediation.md).

The result is ready for a fresh independent review, not Owner Gate A approval. The same workstream authored this remediation and cannot claim independent confirmation. No Gate, implementation, Identity Milestone 2B, FOA or Production Authorization follows.

## 2. Sources inspected

- `AGENTS.md`;
- [Owner Decision Baseline](../architecture/after_four_owner_decision_baseline.md);
- [ADR-0011 Project-wide Layered DDD](../architecture/adr/0011-project-wide-layered-ddd.md);
- [DDD Foundation](../architecture/after_four_ddd_foundation.md);
- [Business Domain Model](../architecture/after_four_business_domain_model.md);
- [Order and Payment Phase 1](../architecture/after_four_order_payment_implementation_phase1.md);
- [Accelerated Core Operations Design Package](after_four_accelerated_core_operations_design_package.md);
- [Accelerated Core Operations Design Remediation](after_four_accelerated_core_operations_design_remediation.md);
- [Independent Core Operations Design Review](after_four_core_operations_independent_design_review.md);
- [Next Readiness Sprint](after_four_accelerated_core_operations_next_readiness_sprint.md);
- [Core Operations Readiness Assessment](after_four_accelerated_core_operations_readiness_assessment.md);
- relevant cited Order, Payment, Preparation and Identity source/spec evidence used by those controlling documents.

No application test, service or database command was run.

## 3. Finding resolution summary

| Finding | Original gap | Authored resolution | Remaining boundary |
|---|---|---|---|
| `CORE02-IR2-01` | Rejected and unresolved acceptance were conflated; later delivery could appear retryable without a durable fail-closed disposition. | Separate immutable terminal `accepted` / `rejected_terminal` outcomes and non-terminal `held_unresolved`; stable attempt identity, replay, lost-result lookup, one-Ticket invariant and separately authorized held resolution are explicit. | Independent review must confirm completeness. Physical enforcement is Gate B. Resolver capability remains separate authorization. |
| `CORE02-IR2-02` | Handover lacked the trusted-command guards applied to other Preparation mutations. | Named handover command now requires trusted actor, authenticated Session evidence, exact Branch/capability, Ticket/version, completion evidence, stable command identity and audit result; replay is idempotent and conflicts fail closed. | Capability holder and Identity implementation remain unauthorized. Physical concurrency/audit mechanisms are Gate B. |
| `CORE02-IR2-03` | No explicit ADR-0011 dependency/contract ownership existed for CORE-02. | Domain, Application, Infrastructure, Presentation and composition responsibilities plus Application-owned ports are explicit for acceptance, upstream evidence, operator checks, Ticket execution/completion and handover. | Exact classes, files, framework, persistence, transport and deployment remain unselected. |

## 4. Logical state axes

The following axes are distinct. A transition on one never proves a transition on another.

| Axis | Logical states/outcomes | Boundary |
|---|---|---|
| Dispatch business state | `pending → dispatched` | Only proven `accepted` outcome establishing/locating the one Ticket permits `dispatched`. |
| Outbox delivery state | `pending → published` | Publication/delivery acknowledgement is not business acceptance. |
| Acceptance attempt | `absent → held_unresolved → accepted / rejected_terminal`; or direct terminal outcome | Held is non-terminal and fail-closed. One immutable terminal outcome per attempt. |
| Ticket execution | `queued → in_progress → completed`; `queued → cancelled` | Whole-Ticket completion; no rewind/delete after work starts. |
| Ticket Item | `queued → in_progress → completed` | Item-level progress only; quantity progress is excluded. |
| Handover evidence | `absent → recorded` | Explicit command only after whole-Ticket completion; no partial handover. |
| Exception | `open → escalated / resolved` | Open/escalated blocks bounded closure; resolution authority is separate. |

Preparation completion, handover, Order closure, Cash Session closure, discrepancy resolution and Refund remain different business facts.

## 5. Dispatch acceptance contract

### 5.1 Identity and preconditions

An acceptance request carries stable Dispatch identity and stable acceptance-attempt identity. Preparation Application validates trusted evidence for:

- the exact eligible pending Dispatch;
- the confirmed Order and immutable sold Item references/quantities;
- authoritative eligible settled Payment without reinterpreting Payment truth;
- exact Branch binding;
- applicable evidence versions and guards; and
- absence of a blocking exception.

Delivery acknowledgement, Outbox publication, network success/failure, timeout and caller/adapter assertion are not acceptance evidence.

### 5.2 Outcomes and transitions

| Disposition/outcome | Meaning | Permitted behavior | Prohibited behavior |
|---|---|---|---|
| `accepted` | Immutable terminal outcome after every guard passes. | Establish or locate exactly one Ticket and required Ticket Items. Duplicate/replay/lookup returns the same outcome and Ticket identity. | No second Ticket/Items, no return to undecided, no later rejection. |
| `rejected_terminal` | Immutable authoritative terminal rejection with safe reason and linked exception evidence. | Same-attempt duplicate/replay/lookup returns the same rejection. A new attempt requires a separately authorized use case, resolved basis, revalidated eligibility, retained evidence and new attempt identity. | Same attempt cannot accept, create Ticket facts or silently become a new attempt. |
| `held_unresolved` | Non-terminal fail-closed disposition for missing, stale, conflicting, ambiguous, mismatched, incomplete or unavailable evidence/result. | Same-attempt duplicate/lookup remains held. Corrected authoritative evidence plus separately authorized resolution may record exactly one terminal outcome for the same attempt. | No Ticket/Items, silent acceptance/rejection, lifecycle advancement or replacement attempt caused by timeout/delivery uncertainty. |

The terminal outcomes are mutually exclusive and immutable. If a response is lost, lookup by the same identities returns a proven terminal outcome; otherwise the attempt is held. Conflicting outcome or Ticket identity is held and escalated, never guessed.

### 5.3 Exactly-one-Ticket and replay

Ticket creation is allowed only at the first proven `accepted` semantic boundary. The accepted result binds one Dispatch to one Ticket and one deterministic required Item set. Exact duplicate, out-of-order delivery and response replay return that same binding. Held or rejected attempts create no new Ticket facts. If held reconciliation locates a candidate Ticket without a proven acceptance result, it creates nothing and never recreates Ticket Items; separately authorized resolution must prove and bind that exact Ticket to `accepted` or record `rejected_terminal` while preserving the conflicting evidence. This is a logical invariant; index, transaction, lock and storage enforcement remain Gate B.

### 5.4 Held resolution and new attempt

Resolving held requires the missing/corrected authoritative evidence and a separately authorized resolver action bound to the same Dispatch and attempt. Resolution records resolver identity, trusted capability evidence, reason, corrected evidence references, authoritative time and resulting terminal outcome. The design neither assigns that resolver nor creates automatic recovery authority.

A rejected attempt is permanently terminal. Any new attempt is a different business action with new identity, preserved rejection history, resolved basis and revalidated eligibility. Timeout, transport failure, absent response or uncertainty can never create it.

## 6. Trusted handover command

### 6.1 Preconditions and command evidence

The explicit Preparation handover command requires:

1. trusted actor identity;
2. valid authenticated Session evidence;
3. exact Branch binding;
4. exact operation-specific handover capability;
5. exact Ticket identity and expected Ticket version;
6. authoritative whole-Ticket completion evidence and no prior handover;
7. stable command/idempotency identity; and
8. reason where the applicable policy requires it.

Missing, expired, stale, conflicting or mismatched identity, scope, capability, version or completion evidence fails closed without handover.

### 6.2 Result, replay and conflict

Successful handover records actor, non-secret Session reference, Branch, Ticket, command identity, authoritative timestamp, reason where required, prior/resulting version and resulting state. An exact duplicate returns the same result. A stale expected version, different payload under the same command identity, concurrent conflicting command or already-recorded different handover fails closed and creates no second fact.

Completion is not handover. Handover acknowledgement is not approval. Handover does not close a Cash Session, resolve a discrepancy, authorize Refund or close an Order by itself. The contract assigns no human holder and does not authorize Identity Milestone 2B.

## 7. ADR-0011 dependency contract

### 7.1 Layer responsibilities

- Preparation Domain owns framework-independent acceptance, Ticket, Item, exception, completion and handover concepts, invariants and state-transition rules.
- Preparation Application owns acceptance and named mutation use cases, orchestration, transaction coordination at the logical boundary and every contract it requires.
- Infrastructure implements persistence, audit, delivery and cross-context adapters behind Application-owned contracts.
- Presentation authenticates/adapts inputs and invokes Application use cases; it owns no business transition and accesses no persistence record directly.
- Composition root wires implementations to Application-owned abstractions only.

Domain/Application do not depend on Active Record, provider SDK, transport or another context's Infrastructure.

### 7.2 Interaction map

| Interaction | Contract owner | Caller and direction | Adapter responsibility | Protected invariant / failure |
|---|---|---|---|---|
| Dispatch acceptance | Preparation Application | Delivery/composition adapter → Preparation Application | Translate delivery and invoke use case; implement required evidence ports. | One terminal outcome per attempt and one Ticket per accepted Dispatch; missing/conflict is held. |
| Ordering/Payment evidence | Preparation Application owns required consumer ports; upstream Applications own published contracts | Preparation Application → owned ports → adapter → Ordering/Payment Application | Map published evidence without reading upstream Infrastructure. | Preparation cannot rewrite or infer commercial/settlement truth; unavailable/stale evidence fails closed. |
| Ticket execution/completion | Preparation Application use cases; Preparation Domain invariants | Presentation → Application → Domain | Persist/map behind required contracts. | Invalid/stale transition causes no mutation. |
| Trusted authorization evidence | Preparation Application | Preparation Application → owned port → adapter → approved Identity Application contract | Obtain trusted actor/Session/Branch/exact capability evidence. | Invalid/missing evidence fails closed and non-disclosing. |
| Handover | Preparation Application command; Preparation Domain eligibility | Presentation → Application → Domain | Implement persistence/audit ports and return stable result. | Completion/version/no-prior-handover required; replay idempotent, conflict closed. |

No new framework, source layout, transport, database technology, transaction boundary, service or deployment topology is selected.

## 8. Cross-context consistency

| Context/boundary | Preserved rule |
|---|---|
| Ordering | Supplies confirmed Order/sold Item facts; Preparation does not close or rewrite the Order. Bounded closure eligibility remains distinct from deferred universal `P1A-OD-07`. |
| Payment | Supplies authoritative eligible settlement; Preparation failure/rejection/hold never changes Payment truth or authorizes Refund. |
| Cash | Preparation handover does not close Cash Session, resolve discrepancy or release reporting. |
| Identity/Authorization | Supplies trusted evidence through an Application contract. Preparation owns the evidence it requires; no dependency on Identity Infrastructure and no Milestone 2B authorization. |
| Inventory | Deferred and absent from the completion critical path; future integration consumes separately approved facts. |

Manual bank, Refund, Promotions, Loyalty and Inventory remain excluded or separately governed exactly as before.

## 9. Unresolved concerns by governance stage

### 9.1 Fresh independent review / Gate A concerns

- An independent reviewer must verify all three finding closures against the canonical design.
- The reviewer must confirm no new Owner policy was inferred and that `CORE-OD-08A`–`CORE-OD-10C` remain within their recorded bounds.
- Detailed exception resolver identity/authority and broader universal closure remain separate; the bounded design must not pretend otherwise.

### 9.2 Gate B-only concerns

- exact files, classes, DTOs, errors and source manifest;
- persistence objects and constraints for attempts, outcomes, Ticket/Items, audit and handover;
- transaction/isolation, lock, uniqueness and concurrent-command enforcement;
- broker/worker/transport, retry schedule, leases and crash recovery;
- reconciliation execution, monitoring and operational runbooks;
- focused tests, failure injection, rollback and deployment evidence.

### 9.3 Separate authorization

- Identity Milestone 2B and runtime capability implementation;
- actual capability-holder assignment, delegation and emergency policy;
- held-case resolver authority beyond already confirmed policy;
- Refund execution and universal Order closure;
- any implementation, Gate B, Gate C, FOA or Production Authorization.

## 10. Independent-review entry criteria

| Requirement | Satisfying section | Remaining ambiguity | Classification |
|---|---|---|---|
| Distinct acceptance outcomes, replay and lost result | Canonical Design Package §§4.2–4.3; this report §§4–5 | Physical enforcement unselected. | Gate B only after independent design acceptance. |
| Same/new attempt and held resolution | This report §§5.2–5.4 | Resolver holder/implementation unassigned. | Separate authorization. |
| Trusted handover guards and audit | Canonical Design Package §4.3; this report §6 | Physical concurrency/audit mechanism unselected. | Gate B; Identity implementation separately authorized. |
| ADR-0011 contract ownership/direction | Canonical Design Package §4.4; this report §7 | Exact source layout unselected. | Gate B. |
| Owner-policy and cross-context preservation | This report §§8–9 | Universal closure, Refund and resolver details remain separate. | Outside bounded Gate A or separately governed. |

All authored logical requirements are present. Therefore the remediation may be classified `READY_FOR_FRESH_INDEPENDENT_GATE_A_REVIEW — NO_GATE_GRANTED`. This is not evidence that independent review passed.

## 11. Before/after readiness

| Point | Classification | Reason |
|---|---|---|
| Before this remediation | `NOT_READY_FOR_OWNER_GATE_A_REVIEW — DESIGN_CORRECTION_REQUIRED` | One blocker and two major logical-design findings remained. |
| After authored remediation | `READY_FOR_FRESH_INDEPENDENT_GATE_A_REVIEW — NO_GATE_GRANTED` | All three logical contracts are explicit; fresh independent verification is the next mandatory step. |

CORE-01 remains `NOT_READY_FOR_OWNER_GATE_A_REVIEW — INPUT_BLOCKED`. CORE-04 remains `NOT_READY_FOR_OWNER_GATE_A_REVIEW — OWNER_INPUT_REQUIRED`.

## 12. Validation and final boundary

The documentation change must preserve 27 confirmed and seven deferred consolidated CORE references, add no canonical `ODB-*` ID, change no Owner decision and modify no application, test, schema, migration, database, dependency, configuration or runtime artifact.

Validation completed for this authored remediation:

- state-axis and acceptance terminology is consistent across the canonical design, prior remediation, sprint and readiness assessment;
- `accepted`, `rejected_terminal` and `held_unresolved` semantics, handover guards and ADR-0011 contracts are present;
- Markdown tables and fenced blocks are structurally valid;
- all local Markdown link targets in the changed documents exist;
- whitespace validation passes;
- the canonical decision register remains 27 confirmed / seven deferred references;
- changed paths are limited to the five intended `docs/research/` documents; and
- no application test, build, service or database command was run.

**Final status:** `CORE_02_LOGICAL_REMEDIATION_COMPLETE — READY_FOR_FRESH_INDEPENDENT_GATE_A_REVIEW — NO_GATE_GRANTED — NO_IMPLEMENTATION_AUTHORIZED`
