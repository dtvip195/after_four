# AFTER FOUR — WP-G0 Candidate E Scope Charter

**Work package:** `WP-G0`

**Charter status:** `OWNER_SELECTED_SCOPE — GATE_A_PREPARATION_ONLY`

**Owner decision date:** 2026-11-23

**Selected candidate:** Candidate E — Customer Lifecycle and Phone-Admission Semantic Contract

**Gate A readiness:** `NOT_READY`

**Gate A approval:** `NOT_GRANTED`

**Technical design approval:** `NOT_GRANTED`

**Implementation authorization:** `NOT_GRANTED`

**Control Acceptance / Final Operational Acceptance / Production Authorization:** `NOT_GRANTED`

## 1. Purpose and authority boundary

The Owner selected Candidate E as the next target for bounded Gate A preparation. This charter fixes the preparation scope so later documentation and technical-design work cannot silently expand into all Customer Management, Identity, Loyalty, Promotions, persistence, API, implementation, or production concerns.

Selection means only that the repository may prepare the named semantic baseline and its evidence package. It does not approve that baseline, start WP4.3, authorize implementation, or grant Gate A/B/C, Control Acceptance, Final Operational Acceptance, Production Authorization, or production use.

## 2. Included semantic subject areas

Candidate E preparation includes:

1. Customer Profile lifecycle meanings: Active, Inactive, and Anonymized; initial Active state after a separately authorized successful creation; terminal ordinary Anonymized semantics; and the approved effects of lifecycle outcomes.
2. Canonical Vietnamese mobile validation as a business precondition, without selecting the allocation source adapter or validation implementation.
3. Organization-wide phone admission under `SDP-CUST-04`: a canonical phone may have at most one current Profile association or one unreleased former-phone restriction within an Organization.
4. The distinction among a current phone association, an unreleased former-phone restriction, and optional Restricted Identity Evidence.
5. Ordinary verified phone change within the authority already confirmed by `SDP-CUST-12A`, including the Inactive outcome confirmed by `SDP-CUST-16`.
6. Disputed, exceptional, or cross-scope phone-change and consequential/disputed Profile-ownership or phone-association outcomes under `SDP-CUST-12A` and `SDP-CUST-13`.
7. Manual-release semantics: release removes only the applicable former-phone restriction and does not create a current association, restore or transfer identity, authorize a new Profile, or transfer history, value, or entitlements.
8. Operation-specific, least-privilege, fail-closed authority principles under `SDP-CUST-20`, without inventing a role-to-operation matrix.
9. Durable Customer Review Case policy under `SDP-CUST-21` for material held, disputed, investigative, or authorized-manual-decision cases; routine validation and ordinary duplicate rejection do not automatically create such a case.
10. Ordinary non-re-identification and exceptional-access boundaries under `SDP-CUST-22`, without designing or authorizing an exceptional access workflow.
11. Approved anonymization postconditions for Customer, Orders, Loyalty, and Promotions, without assuming that all contexts commit in one database transaction or authorizing design of the receiving contexts' internals.
12. Non-disclosing Domain/Application outcomes, explicit exceptional termination behavior, and cross-context responsibilities needed to review the semantic contract.

### 2.1 Approved related policies — context only

`SDP-CUST-18` and `SDP-CUST-19` remain Owner-confirmed repository policies. They constrain the broader system by preserving one current Profile association for a shared/family phone and permitting anonymous/unregistered Orders without inferred Customer identity.

Neither policy is being designed, validated, or submitted for approval through Candidate E. Candidate E includes no shared-phone workflow, anonymous-Order association behavior, or Order-domain design. Their presence in canonical synchronization and traceability does not place them inside Candidate E's design or Gate A approval scope.

## 3. Included operations and authority preconditions

Only operations with sufficiently clear existing authority policy may enter Candidate E's Gate A approval boundary.

| Operation or outcome | Candidate E treatment | Existing authority/policy basis |
|---|---|---|
| Ordinary verified phone change | Included for semantic design and Gate A preparation. | An appropriately scoped Branch Manager may approve under `SDP-CUST-12A`; verification, validation, Organization admission, audit, and non-transfer rules still apply. |
| Inactive Profile phone change | Included as the same controlled phone-change operation; successful completion keeps the Profile Inactive. | `SDP-CUST-12A` and `SDP-CUST-16`. |
| Disputed, exceptional, or cross-scope phone change | Included as an Owner-approved path and held-review outcome. | `SDP-CUST-12A` and `SDP-CUST-13`. |
| Consequential or disputed Profile-ownership/phone-association decision, including an applicable disputed release | Included only with Owner approval and preserved review evidence. | `SDP-CUST-13` and `SDP-CUST-21`. |
| Routine validation or duplicate rejection | Included as a non-disclosing rejection outcome; no durable Customer Review Case is automatic. | `SDP-CUST-04`, `SDP-CUST-05`, and `SDP-CUST-21`. |

Every included operation requires a current decision from an external trusted authorization contract. This is a semantic dependency and precondition only. It does not assert that such a contract or runtime integration already exists, nor does Candidate E approve its interface, protocol, implementation, infrastructure, or operational behavior. Missing, invalid, unavailable, revoked, ambiguous, or out-of-scope authorization fails closed. Phone possession, Customer identifier possession, or a generic role name is never authority. Requester verification and operator authorization remain distinct.

## 4. Deferred operations excluded from the Gate A approval boundary

The following operations remain outside Candidate E's Gate A approval boundary because no existing Owner decision assigns a sufficiently clear approving authority:

| Deferred operation | What may remain in the semantic baseline | Required prerequisite before inclusion |
|---|---|---|
| Customer Profile creation | Validation/admission invariants and the `SDP-CUST-15` postcondition that a successfully created Profile starts Active. | Explicit creation authority policy and reviewable authorization precondition. |
| Ordinary Deactivate | Meaning of Inactive and prohibited side effects. | Explicit approving authority and operation-specific policy. |
| Reactivate | Approved outcome that Inactive may return to Active after authorized review. | Explicit reviewer/approver authority and review standard. |
| Anonymization approval | Controlled-anonymization preconditions and approved postconditions. | Explicit approving authority; requester-verification and legal/privacy prerequisites remain separately reviewable. |
| Ordinary undisputed former-phone release | Release-only outcome and independent later-admission checks. | Explicit approving authority. A Branch Manager's investigation/proposal authority must not be converted into approval authority by inference. |

Exclusion does not prohibit these operations throughout the future product. It means their policy/design is not approved through this Candidate E Gate A package. No role assignment may be inferred from Owner, Branch Manager, Staff, or another title.

## 5. Explicit exclusions

Candidate E does not include:

- authentication, Session, MFA, Identity Milestone 2B, P1 implementation, or physical authorization infrastructure;
- verification-evidence storage, cryptography, provider selection, or a complete runtime role/capability mapping;
- future multi-Brand Customer participation, discovery, visibility, Loyalty sharing, or Promotion applicability;
- Restricted Identity Evidence storage topology, schema, cryptography, retention period, lawful basis, legal hold, disposal mechanism, or compliance conclusion;
- an exceptional identity-evidence access, disclosure, export, or re-identification workflow;
- Loyalty ledger/rule implementation or Promotion rule-engine implementation;
- public API, controller, DTO, endpoint, frontend, error catalog, persistence schema, index, lock, isolation level, transaction, queue, outbox, saga, retry, or reconciliation mechanism;
- application code, database changes, tests, deployment, runtime wiring, or production operations; or
- Gate A/B/C, Control Acceptance, Final Operational Acceptance, Production Authorization, or production use.

## 6. Required deliverables before a Gate A request

1. Canonical synchronization of `SDP-CUST-15` through `SDP-CUST-22` and this charter without rewriting historical provenance.
2. Accepted, implementation-free Customer vocabulary in the repository glossary.
3. A bounded Customer semantic design defining concepts, invariants, included use cases, excluded operations, typed inputs/outcomes, failure semantics, concurrency-required business outcomes, and cross-context responsibilities.
4. A traceability matrix from every included rule to its Owner decision and from every deferred operation to its missing authority prerequisite.
5. Non-disclosure, privacy, purpose-limitation, review-case, and ordinary non-re-identification boundaries.
6. A technical-design gap register that keeps persistence, concurrency mechanism, cross-context completion, recovery, and operational security unresolved until separately reviewed.
7. Synchronization of only the conceptual domain/data/state/Application documents materially required by the selected scope.
8. The separately scheduled `.gem` principles review after documentation/design closure and before final Gate A/B preparation or coding.
9. A frozen commit and exact document/evidence manifest for Owner review.
10. A Gate A decision template stating that design-baseline approval would not grant Gate B, implementation, operational acceptance, or production authorization.

## 7. Gate A readiness conditions

Candidate E remains `NOT_READY` until all of the following hold:

- every operation inside the proposed approval boundary has a sufficiently clear Owner-confirmed business outcome and authority precondition;
- every unresolved-authority operation is visibly excluded and linked to a deferred prerequisite;
- Customer concepts, invariants, lifecycle/phone transitions, review-case thresholds, failure outcomes, and non-disclosure behavior are internally consistent;
- controlled phone change has complete-or-preserve semantics without claiming an implementation mechanism;
- concurrent requests have required business outcomes or are retained as explicit design blockers rather than inheriting database timing;
- anonymization preserves approved external outcomes without claiming one cross-context database transaction;
- technical proposals, legal/privacy questions, operational evidence, and implementation remain truthfully classified;
- the `.gem` review occurs in the approved sequence; and
- the Owner reviews one exact immutable baseline and explicitly decides Gate A.

## 8. Governance restrictions

This charter:

- records scope selection, not Gate A approval;
- changes no ADR status, Identity security checklist status, CAT-TRR status, or prior Owner decision;
- allocates no canonical `ODB-*` identifier;
- starts neither WP4.3 nor implementation;
- authorizes no schema, migration, API, test, database, infrastructure, deployment, or production work; and
- grants no Gate B/C, Control Acceptance, Final Operational Acceptance, Production Authorization, or residual-risk acceptance.
