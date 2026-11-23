# AFTER FOUR — Candidate E Consolidated Owner Review Dossier

**Candidate:** Customer Lifecycle and Phone-Admission Semantic Contract

**Dossier status:** `READY_FOR_OWNER_REVIEW — DECISION_REQUIRED`

**Candidate E readiness:** `NOT_READY`

**Gate A:** `NOT_GRANTED`

**Implementation authorization:** `NOT_GRANTED`

**Prepared from main:** `13aab731941d690b5bd764d2744893260d001986`

**Date:** 2026-11-23

## 1. Decision purpose

This dossier condenses the frozen Candidate E evidence into the two governance decisions still required from the Owner. It neither replaces nor modifies the [Frozen Reviewed Baseline Manifest](after_four_candidate_e_frozen_reviewed_baseline_manifest.md), whose immutable reviewed baseline remains `8d406314acbd390d431d75799b1f66499439f117`.

The B01 Owner Decision was approved and recorded afterward in commit `63456b643ad670ffed2fc5e9d9166111fd0c70ee`. B01 is supplementary post-freeze governance evidence: it does not modify WP-T1's semantic design or any blob pinned by the Frozen Manifest, and it must not be represented as evidence included in that immutable manifest.

Current prerequisite state:

| Prerequisite | Current status | Evidence |
|---|---|---|
| B01 curated GitLab Gemfile research | `OWNER_APPROVED — RESEARCH ACCEPTED; DEPENDENCY ADOPTION NOT AUTHORIZED` | [Owner Decision Baseline — Supporting research acceptance decisions](../architecture/after_four_owner_decision_baseline.md#supporting-research-acceptance-decisions) and [research report §20](after_four_gitlab_gemfile_reference_review.md#20-final-recommendations-and-owner-decisions-required). |
| Independent technical review | `COMPLETED — INDEPENDENT_TECHNICAL_REVIEW_CONFIRMED` | [Readiness Package §8](after_four_candidate_e_gate_a_readiness.md#8-findings-and-blockers): `T1-IR-01` through `T1-IR-04` resolved. |
| Frozen evidence baseline | `COMPLETED — FROZEN_REVIEWED_BASELINE_MANIFEST_RECORDED` | [Manifest §§1–5](after_four_candidate_e_frozen_reviewed_baseline_manifest.md#1-purpose-and-identity). |
| Owner semantic-design review | `DECISION_REQUIRED` | [Owner Governance Package §4](after_four_candidate_e_owner_governance_review_package.md#4-owner-review-item-2--bounded-semantic-design-baseline). |
| Gate A | `NOT_GRANTED` | [Owner Governance Package §7.2](after_four_candidate_e_owner_governance_review_package.md#72-candidate-e-gate-a). |

Research completion and independent review are evidence, not Owner design acceptance or a Gate decision.

## 2. Exact bounded scope

The controlling boundary is the [WP-G0 Scope Charter §§2–5](../architecture/after_four_wp_g0_candidate_e_scope_charter.md#2-included-semantic-subject-areas), implemented only as a proposed semantic design in [WP-T1 §§3–8](../architecture/after_four_customer_technical_design.md#3-candidate-e-scope).

### 2.1 Included

Candidate E includes semantic outcomes and invariants for:

1. ordinary verified phone change;
2. phone change while a Customer Profile is Inactive, with the Profile remaining Inactive after success;
3. disputed, exceptional, or cross-scope phone change under an already-approved authority path;
4. consequential or disputed Profile ownership/phone-association decisions requiring Owner approval;
5. routine validation and duplicate rejection with non-disclosing outcomes;
6. Active, Inactive, and terminal-for-ordinary-operations Anonymized Profile meanings;
7. Organization-wide phone admission and the distinction among current association, former-phone restriction, Customer Review Case, and Restricted Identity Evidence;
8. logical completion, failure-certainty, retry-identity, and concurrency-required business outcomes; and
9. Customer-side anonymization completion postconditions after anonymization was validly initiated through a separately authorized process.

The semantic concurrency outcomes cover same-Profile concurrent phone changes, overlapping old/new phone resources, races with applicable lifecycle changes, and races with Customer-side anonymization completion. Gate A may review these outcomes; it does not select physical serialization, transactions, locks, isolation, idempotency, retry, or recovery mechanisms. See [WP-T1 §§5.5–7.4](../architecture/after_four_customer_technical_design.md#55-business-outcome-dimension).

### 2.2 Five authority operations excluded

The following remain outside the approval boundary because approving authority is unresolved:

1. Customer Profile creation.
2. Ordinary Deactivate.
3. Reactivate.
4. Anonymization approval.
5. Ordinary undisputed former-phone release.

Existing Owner-approved policies may constrain relevant lifecycle, phone-association, anonymization, and former-phone-release semantics. This does not constitute approval of the excluded operations' complete use cases, authority assignments, execution flows, or implementation postconditions. Their unresolved authority boundaries remain outside Candidate E. See [WP-G0 §4](../architecture/after_four_wp_g0_candidate_e_scope_charter.md#4-deferred-operations-excluded-from-the-gate-a-approval-boundary).

### 2.3 Context-only decisions

- `SDP-CUST-18` preserves one current Profile association for a shared/family phone; no assisted shared-phone workflow is in Candidate E.
- `SDP-CUST-19` permits Orders without a Customer Profile; no anonymous-Order association or Order-domain design is in Candidate E.

Both are Owner-approved context, not Candidate E implementation scope. See [WP-G0 §2.1](../architecture/after_four_wp_g0_candidate_e_scope_charter.md#21-approved-related-policies--context-only).

### 2.4 Explicitly outside Gate A

Candidate E excludes physical persistence, schema, API/UI, runtime authorization, Identity/Session/MFA implementation, public error contracts, Restricted Identity Evidence topology, exceptional evidence access/export, receiving-context internals, WP4.3, WP-T2, application code, tests, deployment, and production operations. The complete list is in [WP-G0 §5](../architecture/after_four_wp_g0_candidate_e_scope_charter.md#5-explicit-exclusions).

## 3. Policy, proposal, and later-gate classification

| Matter | Classification | Gate A treatment |
|---|---|---|
| `SDP-CUST-01` | Owner-approved Loyalty preserve-and-freeze policy | Constrains the relevant external outcome when Customer anonymization becomes effective: Loyalty balance/ledger and necessary history remain, redemption freezes, and no new Customer-specific Loyalty benefit is issued. It adds no Candidate E Loyalty use case or implementation scope. See [SDP-CUST-01 §§1–4](../architecture/after_four_sdp_cust_01_owner_decision.md#1-decision). |
| `SDP-CUST-02` | Owner-approved pseudonymous downstream-reference policy | Constrains relevant downstream provenance and re-identification boundaries: use purpose-proportionate pseudonymous references where a relationship must remain; do not automatically disclose original identity/mapping; and do not treat the reference as authority to reconstruct identity. It selects no identifier, mapping store, re-identification mechanism, or Candidate E implementation. See [SDP-CUST-02 §§1–5](../architecture/after_four_sdp_cust_02_owner_decision.md#1-decision). |
| `SDP-CUST-03`–`SDP-CUST-17` | Owner-approved policy constraints | Preserve the applicable constraints within each decision's exact boundary; Gate A does not reopen them or authorize their implementation. See [Customer Owner Decisions §§1–3](../architecture/after_four_customer_management_owner_decisions.md#1-purpose-and-provenance). |
| `SDP-CUST-18`–`SDP-CUST-19` | Owner-approved context-only decisions | Excluded from Candidate E's approval boundary. Their existence does not imply that Candidate E reviews, accepts, designs, or implements the shared/family-phone workflow or anonymous-Order behavior. See [WP-G0 §2.1](../architecture/after_four_wp_g0_candidate_e_scope_charter.md#21-approved-related-policies--context-only). |
| `SDP-CUST-20`–`SDP-CUST-22` | Owner-approved policy constraints | Preserve their operation-specific authority principle, material-review-case boundary, and ordinary non-re-identification boundary within their exact scopes. Do not infer additional operation authority, an exceptional-access workflow, or implementation scope. See [Customer Owner Decisions — SDP-CUST-20 through SDP-CUST-22](../architecture/after_four_customer_management_owner_decisions.md#sdp-cust-20). |
| `SDP-CUST-A2` | Owner-approved restricted identity-evidence boundary | Preserve its purpose limitation and separation from ordinary Customer lookup. It does not approve physical storage topology, schema, access workflow, retention period, legal compliance, or implementation. See [Customer Owner Decisions — SDP-CUST-A2](../architecture/after_four_customer_management_owner_decisions.md#sdp-cust-a2). |
| `SDP-SCOPE-01` | Owner-approved deliberate deferral and evolvability direction | Preserve the deliberate deferral of broader multi-Brand Customer identity policy and the no-implicit-cross-Brand boundary. It selects no context topology, persistence relationship, authorization design, or implementation. See [SDP-SCOPE-01](../architecture/after_four_sdp_scope_01_owner_decision.md). |
| Logical aggregates, outcome dimensions, completion boundary, concurrency schedules, and Application contract | Independently reviewed `TECHNICAL_PROPOSAL` | Subject of Owner semantic-design acceptance. See [WP-T1 §§5–8](../architecture/after_four_customer_technical_design.md#5-td-cust-01--domain-model-use-cases-and-invariants). |
| Physical schema, consistency enforcement, transaction boundaries, retry/reconciliation, and operational recovery | Deferred technical design | Gate B or later; Gate A selects none. |
| Runtime Identity/authorization and verification evidence | External prerequisite | Semantic fail-closed requirement is in scope; implementation remains separate. |
| Legal basis, exact retention, legal hold, disposal, and exceptional access | Unresolved governance/legal matters | No compliance conclusion or exceptional workflow is approved. |
| Gate B/C, Control Acceptance, FOA, Production Authorization | Separate later decisions | Remain `NOT_GRANTED`. |

## 4. Owner decisions actually required

No additional Customer business-policy decision is required for the bounded Gate A review while the five authority-dependent operations remain excluded. Their future inclusion requires separate Owner decisions, but they do not block this bounded semantic baseline.

Two governance decisions remain.

`E-OR-01` and `E-OR-02` are local dossier references for the two review questions below. They are not canonical Owner Decision IDs and allocate no `ODB-*` identifier.

### 4.1 Decision E-OR-01 — accept the bounded semantic design baseline

**Business question:** Is the frozen WP-T1 semantic contract an acceptable baseline for the included Customer lifecycle and phone-admission behavior, with all listed exclusions preserved?

| Option | Consequence | Material trade-off |
|---|---|---|
| `ACCEPT_BOUNDED_SEMANTIC_DESIGN_BASELINE` | Records Owner design acceptance without approving implementation. | Enables a stable Gate A decision; later physical design must conform to this contract. |
| `ACCEPT_WITH_EXPLICIT_AMENDMENTS` | Accepts only the baseline plus recorded, bounded amendments. | Efficient if amendments are objective and do not change the approval boundary; otherwise evidence must be re-reviewed. |
| `AMENDMENTS_REQUIRED_BEFORE_ACCEPTANCE` | Keeps design acceptance open. | Avoids accepting ambiguity but delays Gate A and may require another frozen baseline. |
| `DEFER` | Makes no acceptance decision. | Preserves flexibility but blocks Gate A. |
| `REJECT` | Rejects the proposed semantic baseline. | Requires a new bounded design direction and review cycle. |

**Recommendation:** `ACCEPT_BOUNDED_SEMANTIC_DESIGN_BASELINE` without expanding scope. The four independent-review findings are resolved, the exact evidence is frozen, and unresolved physical, authorization, legal/privacy, and five-operation authority matters are visibly excluded. Acceptance would not claim those matters are solved.

Owner selection: ______________________________

Conditions or amendments: ______________________________________________________________

### 4.2 Decision E-OR-02 — Candidate E Gate A

**Governance question:** After E-OR-01, should the Owner grant Gate A for only the frozen bounded semantic design?

| Option | Consequence | Material trade-off |
|---|---|---|
| `APPROVE` | Approves the bounded design baseline and permits preparation of a separate Gate B proposal. | Fastest safe continuation; grants no coding or physical design approval. |
| `APPROVE_WITH_CONDITIONS` | Gate A exists only if current governance permits it and every condition is explicit, bounded, and objectively verifiable. | Can avoid unnecessary rework, but ambiguous or scope-changing conditions must instead be treated as `DEFER`/`NOT_GRANTED`. |
| `AMENDMENTS_REQUIRED` | Gate A remains `NOT_GRANTED`. | Requires correction and review before another decision. |
| `DEFER` | Gate A remains `NOT_GRANTED`. | No downstream authorization. |
| `REJECT` | Gate A remains `NOT_GRANTED`. | Candidate E needs a different approved direction. |

**Recommendation:** `APPROVE` only after E-OR-01 is explicitly accepted. The package has completed B01, independent review, and frozen-baseline prerequisites; remaining gaps are either excluded or assigned to Gate B/later gates. A conditional approval is appropriate only when its conditions satisfy the governance rule above.

Owner selection: ______________________________

Decision date: ________________________________

Owner identity / recorded role: _________________________________________________________

Conditions or rationale: ________________________________________________________________

## 5. Consequences and authorization boundary

If Gate A is granted, it approves only the frozen semantic baseline and permits preparation of a separately reviewed Gate B proposal. It does not authorize schema, migrations, application or test code, dependencies, APIs, runtime wiring, Identity implementation, database operations, deployment, or production use.

Gate B must separately define and obtain authorization for physical persistence and consistency mechanisms, runtime authorization integration, cross-context completion/recovery, verification evidence, and migration/test scope. Gate C, Control Acceptance, FOA, Production Authorization, legal/privacy approval, dependency adoption, and residual-risk acceptance remain separate.

At dossier creation time, Candidate E remains `NOT_READY`, Gate A remains `NOT_GRANTED`, and no option above is selected.

## 6. Owner review checklist

- [ ] Confirm B01 is accepted only as research/guidance and adopts no dependency.
- [ ] Confirm the included semantic scope in §2.1.
- [ ] Confirm the five excluded operations in §2.2 remain excluded.
- [ ] Confirm `SDP-CUST-18` and `SDP-CUST-19` remain context only.
- [ ] Record E-OR-01.
- [ ] Record E-OR-02 separately.
- [ ] Record any conditions explicitly and objectively.
- [ ] Preserve Gate B and all operational/production authorizations as separate decisions.

This checklist records no decision by itself.
