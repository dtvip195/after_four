# AFTER FOUR Identity Professional Review Engagement Package

**Status:** Historical/contingency engagement package; ID-20 selects Owner-led review and no external engagement is planned  
**Date:** 2026-11-14  
**Scope:** Qualification, procurement, evidence, governance, and acceptance framework for fifteen pending reviews  
**Authority:** Documentation only. ADR-0006 remains Proposed and Milestone 2B remains unauthorized.  
**Related:** [Owner-Led Review Protocol](after_four_identity_owner_led_review_protocol.md) · [Technical Design](after_four_identity_technical_design.md) · [Security Review Package](after_four_identity_security_review_package.md) · [Review Results](after_four_identity_security_review_results.md) · [Security Checklist](after_four_identity_security_review_checklist.md) · [Decision Register](after_four_identity_decision_register.md)

## 1. Purpose and engagement boundary

This package was prepared to enable the Owner to identify reviewers, request comparable proposals, control evidence, record findings, and evaluate completion. ID-20 now records that no external security, infrastructure, cryptography, or legal/privacy reviewer is planned and that technical/security review will be Owner-led. The package and templates are retained as historical preparation and a contingency if governance changes; they are not the current execution path.

The twenty-eight Owner-confirmed decisions remain the policy baseline. Technical proposals are review inputs, not executed evidence. Owner-led review follows the separate protocol and is explicitly non-independent. No Owner assessment can be described as professional certification or legal advice, and risk acceptance does not waive legal obligations.

Reusable templates:

- [Security Review RFP](security-reviews/engagement/security-review-rfp-template.md)
- [Infrastructure Security Review RFP](security-reviews/engagement/infrastructure-security-review-rfp-template.md)
- [Legal/Privacy Review RFP](security-reviews/engagement/legal-privacy-review-rfp-template.md)
- [Reviewer Qualification Questionnaire](security-reviews/engagement/reviewer-qualification-questionnaire.md)
- [Conflict-of-Interest Declaration](security-reviews/engagement/conflict-of-interest-declaration.md)
- [Confidentiality and Evidence Handling](security-reviews/engagement/confidentiality-evidence-handling-requirements.md)
- [Review Completion and Acceptance Record](security-reviews/engagement/review-completion-acceptance-record.md)

## 2. Reviewer profiles and qualification framework

Qualifications must be evidenced, not inferred from job title, employer brand, certification, or sales material. Equivalent experience is acceptable when the candidate demonstrates it through attributable, permission-to-share work samples or references.

### 2.1 Independent application security reviewer

| Criterion | Objective requirement |
|---|---|
| Required expertise | First-party web/API threat modeling; server-side authorization; IDOR and Branch/tenant scoping; Rails or comparable MVC middleware; cookie sessions, CSRF, Origin/Host controls; lifecycle/revocation races; audit security; PostgreSQL transaction and privilege behavior. |
| Relevant experience | Multiple completed reviews of authenticated business applications with role/scope authorization and evidence-based remediation retest. Experience must include manual design/code review and adversarial testing, not scanner-only assessments. |
| Previous-work evidence | Redacted sample report showing reproducible finding, severity rationale, affected requirement, remediation, and retest disposition; references or engagement list that can be verified with permission. |
| Independence | Must disclose design/implementation authorship, financial/vendor referral interests, close relationships, subcontractors, contingent fees, and other conflicts. Reviewer cannot independently accept work they designed or implemented. |
| Minimum deliverables | Scope/evidence log; threat-model observations; findings with stable IDs and severity; reproduction/evidence; requirement mapping; remediation guidance; limitations; retest results; residual risks; recommendation for each assigned review record. |
| Disqualifying conditions | Refusal to disclose conflicts or subcontractors; scanner-only scope; inability to protect evidence; unverifiable claimed work; willingness to mark unimplemented controls accepted; acceptance contingent on product purchase; inability to separate business policy from technical findings. |
| Selection questions | How will cross-Branch authorization and stale-session races be tested? Which evidence is needed beyond source review? How are false positives and disagreements handled? Show a redacted finding and retest. What work will be subcontracted? How is reviewer independence preserved? |

### 2.2 Authentication and cryptography specialist

| Criterion | Objective requirement |
|---|---|
| Required expertise | Password/PIN storage and calibration; Argon2id/bcrypt/scrypt trade-offs; short-secret throttling; constant-time handling; WebAuthn/passkeys/security keys; TOTP/recovery-code risks; session-token entropy; key/pepper lifecycle; dual-control recovery; authentication abuse defense. |
| Relevant experience | Completed design and implementation reviews for password hashing, MFA enrollment/replacement/recovery, privileged step-up, and account recovery, including benchmark or protocol evidence and remediation retest. |
| Previous-work evidence | Redacted protocol or cryptographic-design review with parameter rationale, threat analysis, operational capacity, key lifecycle, test requirements, and limitations; references verifiable with permission. |
| Independence | Must not be compensated by a proposed authentication/MFA vendor without disclosure; cannot accept their own factor/provider implementation; must declare standards-body/vendor affiliations relevant to recommendations. |
| Minimum deliverables | Algorithm/factor comparison; parameter and benchmark assessment; protocol/state-machine analysis; secret/key custody analysis; abuse/recovery findings; test vectors/scenarios; operational conditions; separate recommendations for each assigned record. |
| Disqualifying conditions | Custom-cryptography proposal without compelling reviewed need; parameter selection without target-hardware evidence; email-only or single-actor Owner recovery; treating MFA as authorization; undisclosed product referral interest; claims of approval before implementation evidence. |
| Selection questions | How will target-hardware parameters be chosen? How are PIN entropy and online abuse handled? How will WebAuthn/TOTP downgrade and factor replacement be assessed? How is Owner recovery dual control tested? What key-loss/rotation failures will be examined? |

### 2.3 Infrastructure and deployment security reviewer

| Criterion | Objective requirement |
|---|---|
| Required expertise | TLS/DNS/certificate lifecycle; managed reverse proxies/CDNs/load balancers; forwarded-header trust and client-IP derivation; Rails Host Authorization and HTTPS assumptions; private network/origin isolation; PostgreSQL access; secret management; health/readiness; monitoring, rollback, and incident access. |
| Relevant experience | Production or production-parity review of multi-hop HTTPS applications, including direct-origin and header-spoof testing, network policy inspection, secrets/identity controls, and remediation validation. |
| Previous-work evidence | Redacted topology review or penetration report with trust-boundary diagram, exact configuration evidence, adversarial real-path tests, operational findings, and retest outcome. |
| Independence | Must disclose hosting/CDN/security-product reseller or referral relationships; cannot accept a topology they sold, operated, or configured without an independent second reviewer. |
| Minimum deliverables | Validated topology/data-flow; asset/trust inventory; configuration/evidence log; TLS/Host/header/origin/network/secrets/health/monitoring findings; real-path test results; rollback/operations limitations; acceptance recommendation. |
| Disqualifying conditions | Vendor marketing review instead of configuration evidence; no production-parity testing; reliance on IP headers without trust-chain validation; undisclosed vendor interest; request for live secrets; willingness to infer private-origin protection without network evidence. |
| Selection questions | How will direct-origin bypass and duplicate forwarding headers be tested? What staging parity is required? How are CIDR/certificate changes assessed? Which secret/network evidence is necessary? How will tests avoid production disruption? |

### 2.4 Vietnamese legal/privacy specialist

| Criterion | Objective requirement |
|---|---|
| Required expertise | Current Vietnamese privacy/data-protection and employment context relevant to employee, candidate, payroll, customer-linked, authentication, monitoring, recovery, audit, export, legal-hold, anonymization, provider, and cross-border data. Must distinguish legal requirement, risk-based recommendation, and Owner-operational choice. |
| Relevant experience | Written advice or assessments for Vietnamese workforce/customer technology and data governance, including retention, access/visibility, processors/transfers, incident obligations, legal holds, exports, and deletion/anonymization. |
| Previous-work evidence | Permission-to-share redacted advisory structure, publication, matter description, or references demonstrating jurisdictional and subject-matter competence. Confidential client content is not required. |
| Independence | Must disclose representation of proposed providers, adverse interests, referral fees, and prior advice that would be self-reviewed. Legal privilege/confidentiality arrangement and use of subcontractors/local counsel must be explicit. |
| Minimum deliverables | Dated scope and facts relied on; applicable legal questions and uncertainty; conclusions separated into mandatory/prohibited/permitted/recommended/uncertain; class/field/access/retention/hold/export/anonymization analysis; required actions; assumptions; re-review triggers; recommendation for each AF-PRIV record. |
| Disqualifying conditions | No demonstrated Vietnamese competence; invented universal retention numbers without source/scope; refusal to state assumptions/uncertainty; product/vendor sales conflict; treating Owner preference as legal conclusion; inability to protect sensitive evidence. |
| Selection questions | Which Vietnamese rules and current versions will be considered? What additional facts are required? How will legal requirements be separated from recommendations? How are employment and customer data treated differently? What provider/transfer facts could change the opinion? |

### 2.5 Common qualification and independence rules

- Certifications may support competence but never replace relevant work evidence, method, and references.
- The candidate identifies the lead reviewer and every person/subcontractor who will access evidence, with role and qualification.
- The candidate describes professional liability/engagement terms if applicable without this package setting a required policy or price.
- The Owner or an Owner-designated procurement coordinator verifies references and conflicts. No verification is recorded until it actually occurs.
- A conflicted reviewer may provide factual input, but an independent reviewer must own final findings and sign-off.
- Contingent compensation based on “no findings,” acceptance, vendor selection, or implementation sale is disqualifying.

## 3. Review portfolio mapping

### 3.1 Combining and independence rules

The following may share one engagement and evidence room, but each review record retains a separate conclusion:

- AF-SEC-001, 002, 003, 006, and 009: authentication/cryptography engagement led by the authentication specialist, with application-security support.
- AF-SEC-004 and 005: browser/session engagement led by application security, with infrastructure support for real-path behavior.
- AF-SEC-003, 008, and 010: shared capability/Branch/delegation/lifecycle test corpus, with distinct MFA, audit, and offboarding recommendations.
- AF-PRIV-001 through 005: one Vietnamese legal/privacy engagement may cover all topics, but must issue topic-specific conclusions.

The following conclusions must remain independent:

- AF-SEC-007 infrastructure acceptance is signed by an infrastructure reviewer independent of the topology implementer/provider.
- AF-SEC-008 technical audit integrity cannot substitute for AF-PRIV-004/005 legal conclusions, and legal advice cannot certify database controls.
- AF-SEC-009 recovery security and AF-PRIV-003 recovery-evidence privacy require separate competent sign-off.
- AF-SEC-010 access-removal security and AF-PRIV-002 employment/offboarding advice require separate competent sign-off.
- Owner business-authority decisions cannot be supplied by any professional reviewer.

### 3.2 Security review scopes

| Review | Lead/support | Scope and exclusions | Required evidence and demonstrations | Findings/remediation/acceptance | Sign-off |
|---|---|---|---|---|---|
| [AF-SEC-001](security-reviews/af-sec-001-password-hashing.md) | Authentication/cryptography; AppSec support | Password algorithm, dependency, parameters, input, upgrade/reset, storage/redaction. Excludes business recovery authority. | TD §4; dependency/version; production-like benchmark/load; digest/storage/log inspection; positive/negative/boundary/rehash/reset-race tests. | Finding IDs use shared technical severity; remediation includes design/config/code/test evidence and specialist retest. Accept only when checklist criteria and target-hardware evidence pass. | Authentication specialist; AppSec concurrence for request/reset handling. |
| [AF-SEC-002](security-reviews/af-sec-002-pin-protection.md) | Authentication/cryptography; AppSec support | PIN digest/pepper/format, device/Branch boundary, throttling/reset. Excludes granting POS/domain capabilities. | TD §§4/7; benchmark; device trust; endpoint inventory; guessing/source-rotation/alternate-path/concurrency/redaction demonstrations. | Remediation must cover short-secret and denial risks; retest exact thresholds and privilege denials. | Authentication specialist with AppSec concurrence. |
| [AF-SEC-003](security-reviews/af-sec-003-mfa.md) | Authentication/cryptography; AppSec support | Factor selection, enrollment, step-up, replacement/removal/recovery, secret custody, capability/Branch enforcement. Excludes approving unresolved business capabilities. | TD §§3/5; complete Owner-approved capability decisions where required; factor threat model; working ceremonies; replay/downgrade/replacement/recovery/Branch/delegation tests. | Separate protocol and authorization findings; acceptance requires phishing/replay assessment, secret custody, capability denial, and remediation retest. | Authentication specialist plus independent AppSec sign-off. |
| [AF-SEC-004](security-reviews/af-sec-004-cookie-csrf.md) | AppSec; infrastructure support | Cookie/token/CSRF/Origin/Host/CORS/cache/rotation/logout. Excludes accepting unselected deployment topology. | TD §§6/10; middleware/config; supported-browser automation; real-edge tests; fixation/copied-token/all-unsafe-verb/origin/cache/race evidence. | Findings use shared severity and reproducible HTTP/browser evidence; fixes retested through real path. | AppSec sign-off; infrastructure concurrence on topology-dependent evidence. |
| [AF-SEC-005](security-reviews/af-sec-005-session-policy.md) | AppSec; authentication support | Expiry, POS lock, assurance, visibility, notifications/anomaly, single/all/lifecycle revocation, cleanup/races. Excludes imposing numeric cap. | TD §6; state/transaction design; deterministic clock tests; independent connections/processes; privacy-reviewed summaries; operational revocation drill. | Acceptance requires exact boundary/race evidence and no secret/inventory leakage; unresolved privacy items remain blocking. | AppSec sign-off; legal/privacy input for metadata. |
| [AF-SEC-006](security-reviews/af-sec-006-login-defenses.md) | AppSec; authentication and infrastructure support | Distributed limiter, progressive delay, generic timing/contracts, alternate routes, trusted source, outage. Excludes selecting edge vendor. | TD §7; numeric rationale; multi-process/store tests; timing measurements; source rotation/spoofing; backend-outage and monitoring demonstrations. | Remediation retests enumeration, atomic counters, bypass, collateral denial, and fail-closed behavior. | AppSec sign-off; infrastructure concurrence for source derivation. |
| [AF-SEC-007](security-reviews/af-sec-007-trusted-proxy-https.md) | Independent infrastructure reviewer; AppSec support | TLS/DNS/edge/origin/trusted proxies/Host/network/secrets/health/monitoring/change. Excludes vendor selection and legal transfer conclusions. | TD §10; Owner-approved topology; exact configs/CIDRs; production-parity staging; direct-origin/header/TLS/Host/network/secret/health/rolling-change tests. | Findings include affected hop/config and safe reproduction; remediation requires configuration diff and independent real-path retest. | Independent infrastructure sign-off; AppSec concurrence for browser/source effects. |
| [AF-SEC-008](security-reviews/af-sec-008-audit-security.md) | AppSec/database security; legal support | Event coverage, append-only privileges, atomicity, redaction, readers, integrity/checkpoints, backup, hold/export enforcement. Excludes legal retention conclusions. | TD §9; event catalog; DB grants; transaction/immutability/redaction tests; checkpoint/sink/reconciliation; backup/restore; AF-PRIV opinions. | Technical findings remain separate from legal gaps; acceptance needs DB privilege and integrity evidence plus completed applicable legal records. | AppSec/database specialist; independent legal sign-off for privacy portions. |
| [AF-SEC-009](security-reviews/af-sec-009-owner-recovery.md) | Authentication specialist; AppSec and legal support | Proofs/assurance, custodians, dual control, offline custody, normal/emergency paths, revocation, notification/audit, drill. Excludes naming custodians or provider for Owner. | TD §5.6; Owner-approved actors/timing; protocol/config; attack/race/failure tests; tabletop and controlled drill; AF-PRIV-003 opinion. | Findings must distinguish protocol, operational, and privacy issues; acceptance needs resolved findings and successful drill/retest. | External authentication specialist plus independent legal/privacy sign-off. |
| [AF-SEC-010](security-reviews/af-sec-010-offboarding-suspension.md) | AppSec; database/operations and legal support | Lock/suspend/reactivate/deactivate/rehire authority, full access revocation, history, failures/races, Owner-unavailable procedure. Excludes deciding employment law. | TD §8; approved procedures; complete access inventory; policy/request/transaction tests; failure injection; revocation/offboarding drill; AF-PRIV-002 opinion. | Acceptance requires fail-closed race/failure evidence, explicit restoration, history preservation, and legal/HR issues separately resolved. | AppSec sign-off plus independent legal/privacy input. |

### 3.3 Legal/privacy review scopes

Legal findings use the reviewer's professional classification—mandatory, prohibited, permitted with conditions, recommended, or uncertain—plus urgency and source/assumption. They are not converted to technical CVSS scores.

| Review | Lead/support | Scope and exclusions | Required documents/evidence | Findings/remediation/acceptance | Sign-off |
|---|---|---|---|---|---|
| [AF-PRIV-001](security-reviews/af-priv-001-payroll-customer-visibility.md) | Vietnamese legal/privacy; security/domain support | Payroll/customer field purposes and visibility, reader scope, self-investigation, notices/rights/exports. Excludes security-control certification. | TD §§3/9; Business Domain Model; proposed field/reader matrix; data flows; purpose/notice/rights facts; provider facts if relevant. | Topic-specific written conclusions, assumptions, required actions, and Owner choices within legal bounds; acceptance only with dated qualified sign-off. | Vietnamese legal/privacy specialist. |
| [AF-PRIV-002](security-reviews/af-priv-002-preemployment-offboarding.md) | Vietnamese legal/privacy; HR/domain support | Candidate/invitation, suspension/offboarding, preserved history, rehire, access/correction, retention/notice. Excludes lifecycle transaction security. | TD §8; invitation/lifecycle flows; data inventory; proposed notices/procedures; employment facts. | Remediation supplies revised procedures/notices/data handling; reviewer confirms topic resolution or limitations. | Vietnamese legal/privacy specialist. |
| [AF-PRIV-003](security-reviews/af-priv-003-recovery-evidence.md) | Vietnamese legal/privacy; authentication support | Recovery proof/custodian data, access, storage, disclosure/transfer, incident, retention/disposition. Excludes protocol-security acceptance. | TD §5.6; proposed proof/custodian flow; data/location/recipient inventory; notification and incident procedures. | Findings remain distinct from AF-SEC-009; acceptance needs dated conclusions tied to final recovery design. | Vietnamese legal/privacy specialist independent of authentication sign-off. |
| [AF-PRIV-004](security-reviews/af-priv-004-audit-retention-legal-holds.md) | Vietnamese legal/privacy; finance/HR/domain support | Six audit classes, purpose/legal basis, retention bounds, holds/releases, backups/cross-system conflicts. Excludes database immutability certification. | TD §9; event/data map; proposed schedule with blanks; accounting/employment/dispute/incident facts; backup/system inventory. | Reviewer separates required bounds from Owner choices; no duration accepted without source/scope and written sign-off. | Vietnamese legal/privacy specialist. |
| [AF-PRIV-005](security-reviews/af-priv-005-exports-anonymization.md) | Vietnamese legal/privacy; security/data support | Export authority/recipients/purpose/protection/disposition, anonymization/re-identification, holds/ledger exceptions/transfers. Excludes encryption/control testing. | TD §9.4; proposed workflows; field/recipient/provider inventory; anonymization method proposal; hold/export facts. | Acceptance requires written constraints, findings resolution, re-identification/transfer treatment, assumptions, and re-review triggers. | Vietnamese legal/privacy specialist. |

## 4. Findings and severity model

Technical reviewers use this common model unless their proposal supplies an equally explicit model mapped to it:

| Severity | Decision rule |
|---|---|
| Critical | Credible path to broad/Owner compromise, cross-Organization exposure, unrecoverable integrity loss, or systematic bypass with severe impact and no effective compensating control. Immediate containment; cannot accept affected review while open. |
| High | Credible compromise of privileged identity, cross-Branch data/action, recovery, session, audit integrity, or production trust with material impact. Must remediate and retest before acceptance unless an authorized risk owner records exceptional residual acceptance and reviewer disposition. |
| Medium | Meaningful weakness requiring pre-production correction or a documented, time-bounded compensating control and retest. |
| Low | Limited-impact weakness or hardening gap with clear remediation and tracked completion condition. |
| Observation | No demonstrated vulnerability, but design/operations/evidence improvement or uncertainty that must be acknowledged. It cannot be used to hide an untested acceptance criterion. |

Every technical finding includes: stable ID; affected review/requirement/Owner decision; title; severity and rationale; preconditions; evidence/reproduction; impact; affected artifacts; remediation; validation steps; owner; status; reviewer disposition; and residual risk. A severity disagreement never deletes the finding.

## 5. Evidence readiness matrix

“Available” below means design/context documentation exists. It is not executed control evidence.

| Review | Available design evidence — not executed | Missing evidence | Requires implementation | Requires staging/production-like test | Specialist judgment | Responsible party before review | Blocking state |
|---|---|---|:---:|:---:|---|---|---|
| AF-SEC-001 | TD §4; package §4.1; threat/checklist/record | Dependency selection, benchmark, storage/log/test/runbook artifacts | Yes | Production-like hashing/load host | Crypto parameters, input/upgrade policy | Future implementation lead + evidence coordinator | `OPEN`; evidence absent |
| AF-SEC-002 | TD §§4/7; package §4.2 | PIN/device/limiter implementation, benchmark, alternate-path/race evidence | Yes | Production-like POS/load and multi-process limiter | Short-secret parameters, pepper/device controls | Future implementation/operations leads | `OPEN`; evidence absent |
| AF-SEC-003 | TD §§3/5; package §4.3 | Final capability decisions, factor design, key custody, ceremonies/tests | Yes | Supported browsers/devices and recovery environment | Factor/step-up/recovery assurance | Owner for business gaps; future implementation lead | `BLOCKED`; design/Owner/evidence gaps |
| AF-SEC-004 | TD §6; package §4.4 | Middleware/config, browser tests, token/storage/race evidence | Yes | Real managed-edge path and browser matrix | CSRF/origin/token design | Future implementation + deployment owners | `BLOCKED`; topology/implementation absent |
| AF-SEC-005 | TD §6; package §4.5 | Session implementation, exact clock/race/privacy/drill evidence | Yes | Multi-process/database and notification environment | Expiry/activity/revocation/privacy design | Future implementation + operations owners | `OPEN`; evidence absent |
| AF-SEC-006 | TD §7; package §4.6 | Limits rationale, distributed store, timing/source/outage evidence | Yes | Multi-process plus real proxy path | Enumeration/DoS trade-offs | Future implementation + deployment owners | `OPEN`; evidence absent |
| AF-SEC-007 | TD §10; package §4.7 | Owner-approved vendor/domain/hops/CIDRs/config/network/monitoring | Yes | Required real production-parity topology | Trust chain, TLS/network/operations risk | Owner + future deployment owner | `BLOCKED`; deployment unselected |
| AF-SEC-008 | TD §9; package §4.8 | Event catalog, DB grants, checkpoint/sink, tests, backup/restore, legal opinions | Yes | Privilege-separated database and independent sink | Integrity/read/export/privacy adequacy | Future implementation/DB/operations owners + legal | `BLOCKED`; technical/legal evidence absent |
| AF-SEC-009 | TD §5.6; package §4.9 | Owner-selected proofs/custodians/timing, implementation, runbooks/drill/privacy | Yes | Controlled recovery environment and drill | Assurance, separation, emergency recovery | Owner + future security operations owner | `BLOCKED`; Owner/reviewer/evidence gaps |
| AF-SEC-010 | TD §8; package §4.10 | Approved procedures, full access inventory, implementation, failure tests/drill/legal input | Yes | Multi-process/failure-injection and operational drill | Atomicity/fail-closed/Owner-unavailable risk | Owner + future implementation/HR/operations owners | `BLOCKED`; procedure/evidence gaps |
| AF-PRIV-001 | TD §§3/9; package §7 data map | Final field/reader/purpose/provider facts and qualified opinion | No, but final data model/API facts needed | No; demonstrations may clarify actual visibility | Vietnamese legal/privacy interpretation | Owner + domain/evidence coordinator | `NOT_STARTED`; reviewer absent |
| AF-PRIV-002 | TD §8; package §7 | Candidate/offboarding flows, notices, facts, qualified opinion | No, but final procedures needed | No; controlled walkthrough useful | Employment/privacy interpretation | Owner + HR/domain coordinator | `NOT_STARTED`; reviewer absent |
| AF-PRIV-003 | TD §5.6; package §7 | Proof/custodian/provider/data-flow facts and qualified opinion | No, but recovery design must stabilize | No; drill artifacts may later validate handling | Recovery-evidence privacy/transfer interpretation | Owner + security/evidence coordinator | `NOT_STARTED`; reviewer/design absent |
| AF-PRIV-004 | TD §9; package §7 | Legal sources/opinion, system/backup facts, class schedule, hold authorities | No | No; system inventory required | Retention/hold obligations and conflicts | Owner + finance/HR/legal coordinator | `NOT_STARTED`; reviewer absent |
| AF-PRIV-005 | TD §9.4; package §7 | Export/recipient/provider/anonymization facts, method, qualified opinion | No, but workflow design needed | Re-identification evaluation may need representative synthetic data | Export/transfer/anonymization sufficiency | Owner + data/evidence coordinator | `NOT_STARTED`; reviewer absent |

## 6. Review execution governance

### 6.1 Functional roles

| Functional role | Authority and responsibility |
|---|---|
| Owner | Sole authority to authorize an engagement, approve reviewer selection and evidence access, make business-authority/vendor choices, accept project residual risk where lawful, and grant or withhold later implementation authorization. Reviewer recommendation does not replace this authority. |
| Evidence Coordinator — Owner-designated, not yet assigned | Maintains evidence index/data room, verifies artifact origin/version, grants approved least-privilege access, records reviewer receipt, and prevents design proposals being labeled executed evidence. Cannot approve findings or reviews. |
| Artifact Owner — future implementation/domain/operations/HR function | Produces and attests accurate design/config/test/runbook evidence in their scope; responds to findings; cannot independently accept their own work. No person is assigned by this document. |
| Independent Reviewer | Controls professional method and findings, records evidence examined/limitations/conflicts, evaluates remediation, and recommends accept/reject/conditional outcome for assigned records. Cannot authorize implementation or Owner business policy. |
| Remediation Owner — assigned per finding | Plans corrective action, links changed artifacts and executed retest evidence, and requests reviewer retest. Cannot close their own finding. |

### 6.2 Authorization and evidence flow

1. Owner approves scope, reviewer, conflicts, confidentiality/evidence rules, and permitted access in writing.
2. Evidence Coordinator creates an immutable manifest: artifact ID, description, version/hash, environment, classification, source owner, and access list.
3. Artifact Owners provide evidence through the coordinator. Live secrets, production credentials, unrestricted personal data, and unnecessary customer/payroll content are never shared.
4. Reviewer acknowledges evidence received and records what was actually examined. Missing evidence stays missing.
5. Reviewer records findings directly against stable review/finding IDs. The coordinator may correct clerical metadata but cannot edit reviewer conclusions.
6. Remediation Owner supplies response, artifact diff, test result, and residual-risk statement. Reviewer records retest/disposition.
7. Completion record is prepared only when every criterion has an evidence link and every finding has reviewer disposition.
8. Canonical checklist changes occur afterward and link the completed record. `IN_REVIEW` requires a real started review; `ACCEPTED` requires actual evidence and recommendation.

### 6.3 Disagreement and risk handling

- Project response and reviewer disposition are both preserved. Findings are never silently deleted or downgraded.
- Technical disagreement proceeds through evidence exchange, reviewer reconsideration, then a second independent opinion if unresolved and material.
- The Owner may accept residual technical/operational risk only with documented rationale, scope, duration/conditions, and reviewer acknowledgment; this does not turn a failed acceptance criterion into a pass.
- The Owner cannot replace qualified legal/privacy conclusions with project preference. Legal uncertainty remains recorded and may require additional counsel.
- Reviewer recommendation, checklist acceptance, Owner risk acceptance, and implementation authorization are four distinct decisions.

### 6.4 Independence controls

- Conflict declaration is completed before evidence access and refreshed when scope, subcontractors, vendors, or financial interests change.
- Reviewer does not own remediation implementation for work they will accept unless a separate independent reviewer performs closure.
- Vendor/provider recommendations disclose commercial relationships; provider selection remains Owner-controlled and outside review acceptance.
- Evidence access and communications are logged. Private channels do not replace the canonical finding record.

### 6.5 Confidential evidence handling

- Classify evidence as public, internal, confidential, restricted personal data, or secret. Reviewers receive the minimum category needed.
- Prefer synthetic/reduced data and redacted configuration. Never send raw passwords, PINs, Session/recovery/MFA secrets, private keys, production credentials, unrestricted database dumps, or unnecessary personal data.
- Use an Owner-approved encrypted evidence room with named accounts, MFA, access expiry, download controls where feasible, and access logs. No platform is selected here.
- Record permitted storage location, subcontractors, incident notification, return/destruction, backups, legal hold, and retention in the engagement. This package sets no duration.
- Reviewer artifacts inherit the highest sensitivity of their contents. Findings use safe identifiers and sanitized reproduction evidence.

### 6.6 Closure authority

- The assigned independent technical reviewer alone supplies the professional recommendation and finding/retest disposition for an AF-SEC record; a project author or remediation owner cannot substitute for that recommendation.
- The qualified legal/privacy reviewer alone supplies the professional conclusion for an AF-PRIV record; the Owner cannot relabel project preference as legal acceptance.
- The Owner decides whether to accept the engagement result for project governance, accept a properly documented residual technical risk where lawful, and authorize any later project phase. The Owner does not make an untested acceptance criterion pass.
- The canonical document custodian may record a checklist/status change only after the completed acceptance record links actual evidence and the required reviewer recommendation. This is an administrative recording action, not independent approval.
- Evidence Coordinator, Artifact Owner, Remediation Owner, vendor, and reviewer sales contact have no closure authority.
- Professional closure, canonical status update, Owner project approval, and implementation authorization remain separate recorded actions.

## 7. Outstanding Owner business-authority decisions

These are not security findings. Professional reviewers may explain risk and controls, but only the Owner can approve business authority after any required legal input. Until then, the capability catalog defaults to deny.

| Decision ID | Unresolved business authority | Required Owner decision | Why capability completion is blocked | Professional input, not decision authority |
|---|---|---|---|---|
| BA-01 | Inventory operations | Enumerate allowed actions by Owner/Branch Manager/Staff, assigned-Branch limits, quantity/value thresholds, approvals, reasons, self-approval, and emergency correction. | `inventory.operate` cannot safely authorize an umbrella write; technical design leaves Branch Manager/Staff blocked. | Security reviews segregation/IDOR/audit; legal/accounting may inform records. |
| BA-02 | Procurement | Enumerate requisition/order/receipt/vendor actions, Branch scope, spending/quantity thresholds, approval levels, self-approval, and central versus Branch authority. | `procurement.operate` remains blocked for Branch Manager/Staff; approval workflow cannot be tested. | Security reviews approval bypass; finance/legal advises obligations. |
| BA-03 | Refund and void authority | Decide eligible roles, amount/time thresholds, reasons/evidence, original-tender rules, self-approval/second approval, post-dispatch behavior, and exceptional recovery. | Every role, including Owner execution, remains policy-blocked; no identity reviewer may invent authority. | Security/fraud/accounting/legal input informs risk and records. |
| BA-04 | Cash authority | Decide ordinary tender versus drawer adjustment/expense/discrepancy actions, limits, dual control, evidence, close/reopen authority, and correction process. | `cash.adjust` remains blocked and Staff/Manager cash capabilities cannot be enumerated safely. | Security reviews fraud/segregation; finance/accounting/legal informs controls. |
| BA-05 | Catalog administration | Decide who may create/change/archive products, prices, recipes, availability, modifiers, and Branch-local overrides; define effective dating, approval, and emergency rollback. | `catalog.change` is denied because no role/scope matrix exists. | Security reviews scope/change audit; business operations owns authority. |
| BA-06 | Audit-reader permissions | Name eligible reader functions, event classes/fields, Organization/Branch scope, purpose, duration, self-investigation and second-review rules, and break-glass access. | ID-18 requires explicit authorization; `audit.read` remains blocked for all role templates. | Legal/privacy constrains visibility; security reviews reader enforcement. |
| BA-07 | Audit export authority | Decide who may request/approve, allowed purposes/recipients/scope, segregation, format, expiry/destruction evidence, and emergency/legal-hold interaction. | `audit.export` remains blocked; technical export workflow and tests cannot be finalized. | Legal/privacy defines constraints; security reviews protection/audit. |
| BA-08 | Payroll/customer field visibility | Within qualified legal/privacy bounds, decide exact fields/purposes available to Owner, assigned Branch Manager, Staff self, and any audit reader. | Preliminary payroll review and customer operational-read capabilities cannot expose a safe final representation. | AF-PRIV-001 provides independent legal/privacy input. |

Each approved business decision must be recorded through the established Owner decision process, synchronized into canonical domain/API documents, versioned in the capability catalog, and covered by authorization/audit tests. It must not be recorded as a reviewer finding or inferred from a proposal.

## 8. Contingency engagement assembly and evaluation process

The steps below are inactive under ID-20. Use them only if the Owner explicitly changes the current no-external-engagement approach.

1. Owner selects which combined engagement groups to procure and confirms the business decisions needed before their scope can complete.
2. Send the relevant RFP template, qualification questionnaire, conflict declaration, confidentiality requirements, technical design, review package/results, and only the mapped review records.
3. Evaluate proposals against qualification evidence, method, independence, assigned people, deliverables, evidence needs, limitations, and ability to preserve separate conclusions. Do not score on promised absence of findings.
4. Record selection rationale and Owner authorization; negotiate price/schedule/contract outside these templates without backfilling invented values.
5. Create controlled evidence manifest and kickoff record. Only then add real reviewer identity, qualification, scope, and start date to a review record and consider `IN_REVIEW`.
6. Execute review, finding/remediation/retest governance, then use the completion template per record.
7. Update the canonical checklist only when evidence supports the exact status change. A completed review still does not authorize Milestone 2B.

## 9. Historical engagement gaps and current limitations

- No reviewer candidates, qualification responses, conflict declarations, references, proposals, prices, schedules, or contracts exist because external engagement is not planned under ID-20.
- No Owner authorization to engage a reviewer or disclose evidence is recorded; this is consistent with the current approach, not evidence of independent review.
- BA-01 through BA-08 remain unresolved and block portions of the authorization/audit scopes.
- Required implementation, staging, benchmark, browser, multi-process, proxy, privilege, backup, drill, and legal evidence does not yet exist.
- Hosting/authentication/MFA/notification/monitoring providers and exact production topology remain unselected.
- No review record may advance until a real reviewer starts with recorded identity, qualification, date, scope, and examined evidence.

## 10. Completion boundary

This historical/contingency package created no reviewer identity, engagement, finding, date, evidence, legal conclusion, checklist change, business permission, vendor choice, implementation authorization, or residual-risk acceptance. Owner-led assessments must use the [Owner-Led Review Protocol](after_four_identity_owner_led_review_protocol.md). ADR-0006 remains Proposed and Milestone 2B remains unauthorized.
