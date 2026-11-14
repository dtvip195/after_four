# AFTER FOUR Security Review Request for Proposal Template

**Template status:** Reusable; complete bracketed fields before issue  
**Governing package:** [Professional Review Engagement](../../after_four_identity_professional_review_engagement.md)

## 1. Request identity

- Request ID: `[OWNER-ASSIGNED]`
- Requested review records: `[LIST AF-SEC IDS]`
- Proposal contact: `[OWNER-DESIGNATED CONTACT]`
- Proposal submission method: `[OWNER-APPROVED METHOD]`
- Reviewer-proposed schedule and fees: `[TO BE PROVIDED BY RESPONDENT; NO VALUE SET BY TEMPLATE]`

Issuing this request does not engage a reviewer, authorize evidence access, accept a proposal, or authorize implementation.

## 2. Project and policy context

AFTER FOUR is a cafe POS and management system with a Rails API backend and a React frontend foundation. Identity implementation is not authorized. Twenty-eight Owner policies are fixed in the [Decision Register](../../after_four_identity_decision_register.md); ID-20 currently selects Owner-led review, so this RFP is contingency material unless governance changes. A future reviewer could assess design/control evidence but could not expand business permissions or authorize Milestone 2B.

Provide the selected respondent with:

- [Identity Technical Design](../../after_four_identity_technical_design.md)
- [Security Review Package](../../after_four_identity_security_review_package.md)
- [Review Results](../../after_four_identity_security_review_results.md)
- [Security Checklist](../../after_four_identity_security_review_checklist.md)
- [ADR-0006](../../adr/0006-authentication-session-topology.md)
- only the review records listed in this request;
- the approved evidence manifest after conflict/confidentiality checks.

## 3. Requested scope

For each review ID, complete before issue:

| Review ID | In-scope requirements and interfaces | Explicit exclusions | Required supporting reviewer profile |
|---|---|---|---|
| `[AF-SEC-NNN]` | `[COPY CONTROLLED SCOPE FROM ENGAGEMENT PACKAGE/RECORD]` | `[BUSINESS POLICY, VENDOR, OR OTHER EXCLUSION]` | `[APPSEC / AUTH-CRYPTO / INFRA SUPPORT]` |

Required methods, as applicable:

- architecture, threat-model, and module-interface review;
- manual authorization/protocol/configuration review;
- source/configuration review only when separately authorized and available;
- positive, negative, boundary, concurrency, and failure-path test evaluation;
- adversarial testing in an approved non-production or controlled environment;
- evidence traceability to Owner decision, requirement, and acceptance criterion;
- remediation retest and residual-risk assessment.

## 4. Evidence and demonstrations

The respondent must identify evidence required to begin, evidence required only after implementation, and any safe staging/production-parity demonstrations. Design documents must not be represented as executed control evidence.

| Evidence or demonstration | Available at issue | Expected later | Access/classification | Reviewer need/rationale |
|---|:---:|:---:|---|---|
| `[ARTIFACT/TEST]` | `[YES/NO]` | `[YES/NO]` | `[CLASSIFICATION]` | `[RATIONALE]` |

The reviewer records every artifact actually examined by ID/version/hash/environment and all limitations caused by missing evidence.

## 5. Required deliverables

1. Confirmed scope, exclusions, assumptions, reviewer team, qualifications, conflicts, and method.
2. Evidence-examined and testing log.
3. Findings report using stable IDs and the package severity model or a supplied mapping.
4. Each finding: affected review/requirement/decision, evidence, reproduction, impact, severity rationale, remediation, and validation steps.
5. Acceptance-criterion matrix with pass/fail/not-tested/not-applicable and rationale.
6. Remediation consultation limited to clarification unless separately contracted; reviewer independence must be preserved.
7. Retest report with finding disposition and new evidence examined.
8. Per-review recommendation: accept, accept with explicitly recorded residual conditions where criteria permit, or do not accept.
9. Executive summary that does not omit unresolved findings or limitations.

## 6. Finding and remediation rules

- Use Critical/High/Medium/Low/Observation as defined in the engagement package, or provide an explicit mapping.
- A disagreement preserves both project response and reviewer disposition.
- A finding is closed only by reviewer retest or a recorded authorized residual-risk decision that does not falsely mark a failed criterion passed.
- Missing implementation evidence is “not tested,” not “passed.”
- Business-authority gaps are referred to the Owner inventory, not resolved as technical findings.

## 7. Qualification, independence, and evidence protection

Submit the [Qualification Questionnaire](reviewer-qualification-questionnaire.md) and [Conflict Declaration](conflict-of-interest-declaration.md) for the lead and relevant team members. Accept the [Confidentiality and Evidence Handling Requirements](confidentiality-evidence-handling-requirements.md) or identify requested changes.

Disclose subcontractors, vendor/product relationships, referral interests, prior design/implementation involvement, proposed tools, data transfers, evidence locations, and retention/destruction approach.

## 8. Proposal response

The respondent provides:

- legal entity/individual and proposed reviewer team;
- relevant experience and permission-to-verify references;
- work samples or equivalent evidence;
- scope interpretation and exclusions;
- method, evidence request, environments, tools, and safety controls;
- deliverables and finding/retest workflow;
- reviewer-proposed schedule, dependencies, and fees without assuming acceptance;
- conflicts, independence controls, confidentiality terms, subcontractors, and data locations;
- limitations and conditions that could prevent a recommendation.

## 9. Selection and completion

The Owner selects and authorizes any engagement in writing. Selection is based on competence, method, evidence discipline, independence, deliverables, and protection—not a promise of no findings. Use the [Completion and Acceptance Record](review-completion-acceptance-record.md) after actual review and retest. Reviewer recommendation does not authorize implementation.
