# AFTER FOUR — Candidate E Owner Governance Review Package

**Candidate:** Customer Lifecycle and Phone-Admission Semantic Contract

**Package status:** `HISTORICAL_REVIEW_PACKAGE — OWNER_DECISIONS_RECORDED`

**Candidate E readiness:** `NOT_READY`

**Gate A approval:** `DEFER_GATE_A — NOT_GRANTED`

**Implementation authorization:** `NOT_GRANTED`

**Package date:** 2026-11-23

## 1. Purpose and decision boundary

This package presented the frozen Candidate E evidence for explicit Owner governance review. It did not make or preselect an Owner decision. The Owner later recorded `E-OR-01` as `ACCEPT_BOUNDED_SEMANTIC_DESIGN_BASELINE` and `E-OR-02` as `DEFER_GATE_A` on 2026-11-23; see the [Owner Decision Baseline — Wave 1 decisions](../architecture/after_four_owner_decision_baseline.md#wave-1-semantic-design-gate-and-portfolio-decisions). Historical options below are retained as review provenance and do not override the recorded outcomes.

The following milestones are distinct:

| Milestone | Current state | Meaning |
|---|---|---|
| Documentation and research preparation | Complete for the frozen package | Required records exist; this is not Owner acceptance. |
| Independent technical review | Complete | `T1-IR-01` through `T1-IR-04` are resolved and independently re-reviewed. This does not approve a physical mechanism. |
| Owner review of supporting research and semantic design | B01 research accepted; semantic baseline accepted through `E-OR-01` | Both decisions retain their exact no-adoption/no-implementation boundaries. |
| Gate A | `DEFER_GATE_A — NOT_GRANTED` | `E-OR-02` deferred Gate A; Candidate E Gate B proposal preparation is unauthorized. |
| Gate B / implementation | `NOT_GRANTED` | Requires later, separately bounded design and authorization. Gate A would not authorize coding. |

## 2. Frozen evidence baseline

The authoritative evidence index is the [Candidate E Frozen Reviewed Baseline Manifest](after_four_candidate_e_frozen_reviewed_baseline_manifest.md).

| Evidence identity | Commit | Governance meaning |
|---|---|---|
| Frozen reviewed baseline | `8d406314acbd390d431d75799b1f66499439f117` | Immutable reviewed policy, scope, design, review, and readiness snapshot. |
| Manifest creation | `f9902535bbfc203180b323de7ef899f091139c8b` | Adds the reproducible manifest; it is not part of, and does not replace, the frozen baseline. |
| B01 terminology correction | `5a8b9750d4b2ba50ea0be2130285bd30d9895e03` | Corrects only the readiness label to “Curated GitLab Gemfile reference review.” It changes no frozen evidence, dependency decision, or authorization. |
| Current `main` integration point observed during package preflight | `3ae3ca69cd36d2cb437009bcf6726591b1d4ed69` | Merge commit for PR #36; all three commits above are ancestors. It does not replace the frozen baseline identity. |

The [Candidate E Gate A Readiness Package](after_four_candidate_e_gate_a_readiness.md) remains `NOT_READY`, with Gate A `DEFER_GATE_A — NOT_GRANTED` and implementation authorization `NOT_GRANTED`.

## 3. Owner review item 1 — B01 supporting research

The [Curated GitLab Gemfile Reference Review](after_four_gitlab_gemfile_reference_review.md) was introduced at `a3cb0363386bf7c82d4193712f6bb702b67e6cdb` and corrected at `7f47579ce0bb2d981a42ba74777ed384422704e9`.

Its current status is `OWNER_APPROVED — RESEARCH ACCEPTED; DEPENDENCY ADOPTION NOT AUTHORIZED`.

- The reviewed source was the curated external GitLab Gemfile reference supplied for research.
- The local project `.gem` file was not inspected and is not represented as reviewed.
- No dependency was selected, adopted, installed, or authorized.
- Recommendations remain conditional research inputs. They do not decide authentication architecture, dependency versions, or implementation.

### Recorded Owner decision — B01

**Decision date:** 2026-11-23

**Decision reference / canonical ID:** `CAND-E-B01` / `ID_PENDING_OWNER_GOVERNANCE`

The Owner accepted the report as completed technical research and accepted its §15 dependency-management principles as guidance for future dependency proposals. Each future proposal must be evaluated selectively against AFTER FOUR architecture, requirements, compatibility, security, maintenance, and operational needs.

The decision adopts no gem, does not select Devise 5 as the authentication foundation, and does not treat GitLab as an authoritative dependency baseline. It changes no ADR or dependency file. Devise 5 remains a candidate for further evaluation, and a Devise-versus-custom authentication spike requires a separate decision after review of ADR-0006 and relevant authentication requirements. This decision grants neither Candidate E Gate A nor implementation authorization.

## 4. Owner review item 2 — bounded semantic design baseline

The controlling scope is the [WP-G0 Candidate E Scope Charter](../architecture/after_four_wp_g0_candidate_e_scope_charter.md). The reviewed proposal is [WP-T1 Customer Technical Design](../architecture/after_four_customer_technical_design.md), interpreted through the frozen manifest rather than a moving branch.

### 4.1 Design summarized

The proposal defines logical Customer Profile lifecycle and phone-admission semantics, including:

- Active, Inactive, and terminal-for-ordinary-operations Anonymized Profile meanings;
- Vietnamese mobile validation as a business precondition and Organization-wide phone admission;
- separation of current phone association, former-phone admission restriction, Restricted Identity Evidence, and Customer Review Case;
- complete-or-confirmed-preserve semantics for authorized ordinary phone change, including Inactive Profile behavior;
- non-disclosing conflict, denial, held-review, dependency-unavailable, and incomplete outcomes;
- required business outcomes for concurrency without selecting locks, transactions, storage, or isolation mechanisms;
- Customer-side anonymization completion postconditions across Customer, Ordering, Loyalty, and Promotions without claiming one cross-context transaction; and
- Layered DDD ownership, fail-closed authority dependencies, purpose limitation, and ordinary non-re-identification boundaries.

### 4.2 Review result

| Finding | Final evidence status | What remains unapproved |
|---|---|---|
| `T1-IR-01` | `RESOLVED — INDEPENDENT_RE_REVIEW_CONFIRMED` | Physical serialization and anonymization approval authority. |
| `T1-IR-02` | `RESOLVED — INDEPENDENT_RE_REVIEW_CONFIRMED` | Physical fact representation and integration. |
| `T1-IR-03` | `RESOLVED — INDEPENDENT_RE_REVIEW_CONFIRMED` | Physical completion, retry, and recovery mechanisms. |
| `T1-IR-04` | `RESOLVED — INDEPENDENT_RE_REVIEW_CONFIRMED` | Runtime hold/review persistence and authorization implementation. |

Independent review confirmed that the proposal was coherent enough for governance consideration. `E-OR-01` later accepted the frozen bounded semantic baseline; it remains unimplemented, legally unapproved, operationally unproven, and not production-ready.

### Owner semantic-baseline decision

Owner selection: `ACCEPT_BOUNDED_SEMANTIC_DESIGN_BASELINE`

- [x] `ACCEPT_BOUNDED_SEMANTIC_DESIGN_BASELINE`
- [ ] `ACCEPT_WITH_EXPLICIT_AMENDMENTS`
- [ ] `AMENDMENTS_REQUIRED_BEFORE_ACCEPTANCE`
- [ ] `DEFER`
- [ ] `REJECT`

Required amendments, conditions, or rationale, if any: None.

An acceptance here records Owner design acceptance only. Gate A remains a separate explicit decision below.

## 5. Scope and exclusions presented for Owner confirmation

### 5.1 Included approval boundary

The bounded approval subject is the semantic contract described in §4 for these included operation semantics:

1. Ordinary verified phone change.
2. Phone change while the Customer Profile is Inactive, with the Profile remaining Inactive after success.
3. Disputed, exceptional, or cross-scope phone change under the applicable already-approved authority path.
4. Consequential or disputed Customer Profile ownership or phone-association decisions requiring Owner approval.
5. Routine validation and duplicate rejection with non-disclosing outcomes.

Candidate E may also define Customer-side anonymization completion postconditions after anonymization has been validly initiated through a separately authorized process. It neither authorizes nor assigns authority to approve or initiate anonymization.

These are operation semantics, not runtime authorization implementation. Every included operation still depends on a current trusted, operation-specific, scope-bound, fail-closed authority decision. Candidate E does not claim that this runtime contract exists.

### 5.2 Five authority-dependent operations excluded

The following operations remain outside Candidate E because approving authority is unresolved:

1. Customer Profile creation.
2. Ordinary Deactivate.
3. Reactivate.
4. Anonymization approval.
5. Ordinary undisputed former-phone release.

Their already-approved meanings, invariants, or postconditions may constrain the semantic baseline; their executable use cases and authority assignments are not approved.

### 5.3 Related approved policies kept as context only

- `SDP-CUST-18` preserves the one-current-association rule for a shared/family phone. Candidate E does not design an assisted shared-phone workflow.
- `SDP-CUST-19` permits Orders without a Customer Profile. Candidate E does not design anonymous-Order association behavior or Order internals.

Candidate E also excludes physical persistence, public API/UI, runtime authorization, Identity/MFA/Session implementation, Restricted Identity Evidence topology, exceptional access/export, receiving-context internals, WP4.3, WP-T2, application changes, deployment, and production operations.

## 6. Residual concerns and correct decision gate

| Concern | Current classification | Gate A treatment | Later requirement |
|---|---|---|---|
| Owner sufficiency review of B01 | `OWNER_APPROVED — RESEARCH ACCEPTED; DEPENDENCY ADOPTION NOT AUTHORIZED` | B01 research review is complete and no longer a Gate A evidence blocker. | Any dependency choice or authentication spike requires a separate decision and evidence. |
| Owner acceptance of the bounded semantic design | `ACCEPTED — E-OR-01` | The Owner accepted the frozen bounded semantic baseline without outstanding conditions. | Gate A remains separately deferred; no Candidate E Gate B proposal preparation is authorized. |
| Authority for the five excluded operations | Known deferred matter | Not a blocker while all five remain excluded. | Explicit Owner policy before adding any operation to a future approval boundary. |
| Semantic concurrency outcomes versus physical/runtime mechanisms | The semantic outcomes already proposed for same-Profile concurrent phone changes, overlapping phone resources, phone change racing with lifecycle changes, and phone change racing with anonymization completion are part of the bounded Candidate E design baseline. Physical schema and persistence, serialization and consistency mechanisms, database locking/transactions/isolation, idempotency implementation, retry/reconciliation/recovery mechanisms, and executable physical proof remain later-gate technical work. | Gate A reviews and may accept the proposed semantic concurrency outcomes without selecting a physical mechanism. | The physical/runtime mechanisms must be designed, separately authorized, implemented, and verified at the appropriate later stage. |
| Runtime identity, verification, and authorization integration | Later-gate technical and operational work | Semantic fail-closed dependency is reviewable; implementation is excluded. | Separately approved Identity/P1/runtime design and controls. |
| Receiving-context anonymization integration | Later-gate cross-context work | Only approved postconditions are in scope. | Context-owned contracts, physical completion/recovery design, and evidence. |
| Privacy, lawful basis, retention, legal hold, disposal, and exceptional evidence access | Known deferred legal/privacy and governance matters | Do not infer legal compliance or approve exceptional workflows. | Qualified review and explicit decisions before affected production processing. |
| Operational and production readiness | Later-gate evidence | Not assessed or granted by Gate A. | Control Acceptance, FOA, and Production Authorization remain separate. |

## 7. Owner governance decision record

The Owner outcomes are recorded below. The option lists preserve the review presentation; they are not current open selections.

### 7.1 Remaining semantic-design package review

Decision: `ACCEPT_BOUNDED_SEMANTIC_DESIGN_BASELINE`

Decision date: 2026-11-23

Owner identity / recorded role: Owner

Conditions or required amendments: None.

### 7.2 Candidate E Gate A

- [ ] `APPROVE` — accept only the frozen bounded semantic design baseline and authorize preparation of a separately reviewed Gate B proposal.
- [ ] `APPROVE_WITH_CONDITIONS` — state exact conditions; no coding begins until a later bounded Gate B authorization.
- [ ] `AMENDMENTS_REQUIRED` — Gate A remains `NOT_GRANTED`.
- [x] `DEFER` — Gate A remains `NOT_GRANTED`.
- [ ] `REJECT` — Gate A remains `NOT_GRANTED`.

Conditional acceptance constitutes Gate A approval only if the existing governance process permits it and the Owner's conditions are explicit, bounded, and objectively verifiable. Otherwise, the outcome must be recorded as `DEFER` or `NOT_GRANTED` until the conditions are resolved and an explicit Gate A decision is made. Conditional approval cannot silently authorize coding or implementation; every condition affecting the approval boundary must be recorded explicitly, and Gate B remains a separate authorization.

Gate A decision: `DEFER_GATE_A`

Decision date: 2026-11-23

Owner identity / recorded role: Owner

Conditions, amendments, or rationale: Gate A deferred; future reconsideration requires a separate Owner review.

## 8. Consequences of the recorded Owner decisions

`E-OR-01` accepts the frozen Candidate E semantic baseline. `E-OR-02` defers Gate A, so no Candidate E Gate B proposal preparation is authorized. Neither decision authorizes application or test code, schema, migration, database mutation, dependencies, API/UI, runtime wiring, WP4.3, WP-T2, deployment, or production use.

Candidate E remains `NOT_READY`, and Gate A remains `NOT_GRANTED`, while the deferral is in effect. A future change requires a separate explicit Owner review.

Under every option, Gate B, Gate C, Control Acceptance, Final Operational Acceptance, Production Authorization, legal/privacy approval, residual-risk acceptance, and dependency adoption remain `NOT_GRANTED` unless separately and explicitly decided.

## 9. Package conclusion

This historical package now cross-references all recorded outcomes:

- B01 is `OWNER_APPROVED — RESEARCH ACCEPTED; DEPENDENCY ADOPTION NOT AUTHORIZED`;
- B02 is `COMPLETED — INDEPENDENT_TECHNICAL_REVIEW_CONFIRMED`;
- B03 is `COMPLETED — FROZEN_REVIEWED_BASELINE_MANIFEST_RECORDED`;
- E-OR-01 is `ACCEPT_BOUNDED_SEMANTIC_DESIGN_BASELINE`;
- E-OR-02 is `DEFER_GATE_A`;
- Candidate E is `NOT_READY`;
- Gate A is `NOT_GRANTED`, and Candidate E Gate B proposal preparation is unauthorized; and
- implementation and all later operational/production gates are `NOT_GRANTED`.
