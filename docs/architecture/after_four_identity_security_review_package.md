# AFTER FOUR Identity Security & Privacy Review Package

**Status:** Evidence package retained; ID-20 selects Owner-led technical/security review and legal review remains not performed  
**Date:** 2026-11-14  
**Scope:** Evidence and acceptance plan for the ten outstanding Identity Security Review Checklist areas  
**Authority:** Preparation only. ADR-0006 remains Proposed and Milestone 2B remains unauthorized.  
**Related:** [Owner-Led Review Protocol](after_four_identity_owner_led_review_protocol.md) · [Identity Decision Register](after_four_identity_decision_register.md) · [ADR-0006](adr/0006-authentication-session-topology.md) · [Identity & Branch Authorization](after_four_identity_authorization.md) · [Threat Model](after_four_security_threat_model.md) · [Security Review Checklist](after_four_identity_security_review_checklist.md)

## 1. Executive summary

The Owner has confirmed twenty-eight operating/governance policies. IDs 21–28 close password/PIN policy choices while intentionally leaving exact rate limits, delay/lock schedules, Argon2 dependency/profile, secret provider/custody, credential-event matrix, and executed evidence unresolved. No application Identity implementation or professional review evidence exists. [AF-OWNER-001](security-reviews/owner-led/af-owner-001-password-pin-security.md) is an in-progress Owner-led design/repository assessment for password and PIN security; it supplies findings and missing-evidence traceability, not implemented-control evidence or acceptance.

This package turns each checklist row into a reviewable claim, test plan, and evidence manifest. It does not change any checklist status:

| Checklist area | Current status | Principal blocker or missing evidence |
|---|---|---|
| Password hashing | `OPEN` | Algorithm/library selection, production-like benchmark, input policy, upgrade evidence |
| PIN protection | `OPEN` | PIN format/digest/rate-limit decisions and attack-path tests |
| MFA | `BLOCKED` | Capability enumeration, factor/step-up/recovery selection, implementation evidence |
| Cookie and CSRF | `BLOCKED` | Exact deployed topology, browser/middleware design, deployed-path tests |
| Session policy | `OPEN` | Storage/renewal/revocation design and exact boundary/race evidence |
| Login defenses | `OPEN` | Thresholds/windows/signals, distributed limiter design, proxy-derived source evidence |
| Trusted proxy and HTTPS | `BLOCKED` | Hosting/proxy/network choices, staging configuration, direct-origin and header tests |
| Audit security | `BLOCKED` | Physical privilege/integrity design and professional retention/privacy decisions |
| Owner recovery | `BLOCKED` | Proofs, custodians, implementation, emergency runbook, monitoring, and drill evidence |
| Offboarding and suspension | `BLOCKED` | Enforcement design, lock release, Owner-unavailable procedure, and race/failure tests |

The review gate remains the [Identity Security Review Checklist](after_four_identity_security_review_checklist.md). Under ID-20, technical/security evidence is inspected through the [Owner-Led Review Protocol](after_four_identity_owner_led_review_protocol.md). A row may move only when actual executed evidence, findings, remediation/retest, residual risks, production conditions, and explicit Owner disposition are recorded. Every such update must state that independent verification was not performed. Preparation artifacts and policy approval are not execution evidence.

The “External specialist” recommendations in the ten dossiers are retained as the originally prepared professional-review standard. ID-20 declines those engagements under the current approach; it does not transform Owner self-review into independent verification. Legal/privacy review remains not performed and cannot be replaced by technical residual-risk acceptance.

## 2. Review vocabulary and evidence rules

- `OWNER_CONFIRMED` identifies a business or operating policy in the [Decision Register](after_four_identity_decision_register.md).
- `TECHNICAL_PROPOSAL` identifies an engineering candidate that still needs selection, implementation, and review.
- `SECURITY_REVIEW_REQUIRED` means a qualified reviewer must evaluate the actual design, configuration, implementation, and executed evidence.
- `LEGAL_PRIVACY_REVIEW_REQUIRED` means qualified current advice is needed; this package supplies questions, not answers.
- `OPEN` and `BLOCKED` retain the meanings in the checklist. No section below changes those states.

For acceptance, evidence must identify its commit or immutable artifact version, environment, configuration, test command, result, reviewer, review date, residual risk, and production conditions. Screenshots or prose claims without reproducible configuration/test references are supporting context, not sufficient evidence.

Existing testing rules require RSpec, real PostgreSQL records where persistence matters, real request/middleware paths, deterministic time/random inputs, transactional isolation, and mocks only at external infrastructure boundaries. See [Backend Testing Standards](../development/after_four_testing_standards.md). Existing CI runs PostgreSQL 18.7, RSpec, RuboCop, Brakeman, Bundler Audit, and schema-drift verification. It does not currently provide a browser, real edge/proxy chain, multi-process limiter environment, production-like benchmark host, security drill, penetration test, or legal/privacy opinion.

### 2.1 Source basis and preserved boundaries

This package cross-references the canonical [Business Domain Model](after_four_business_domain_model.md), [Data Integrity Rules](after_four_data_integrity_rules.md), [API Contract](after_four_api_contract.md), and [State Machines](after_four_state_machines.md). Their controlling boundaries are preserved: User is not Employee; Role Assignment is not Employee Branch Assignment; Invitation Delegation is not Role Assignment; authentication lock is not suspension or deactivation; Branch Manager authority is limited to assigned Branches; and Owner authority is never implicit.

The executable evidence baseline is the [GitHub quality workflow](../../.github/workflows/quality.yml), [Rails CI definition](../../backend/config/ci.rb), and [RSpec testing standard](../development/after_four_testing_standards.md). These sources prove which checks are available; they do not prove any future Identity control has passed.

## 3. Owner-confirmed policy map

| Review area | Controlling Owner decisions | Policy boundary |
|---|---|---|
| Password hashing | ID-06, ID-07, ID-11, ID-15, ID-24–ID-26, ID-28 | Owner manages employee recovery; login is username-based; failures use progressive delay without permanent failure-only lock; Argon2id remains an evidence-gated candidate; NFC/blocking/no truncation are required; password pepper is optional for MVP; credential replacement consequences are mandatory. |
| PIN protection | ID-01, ID-04, ID-07, ID-13, ID-21–ID-24, ID-27–ID-28 | Every POS employee has an individual 6–8 digit PIN limited to enrolled-POS authentication/reauthentication; four-digit/shared PINs are forbidden; distributed online defenses and distinct pepper/change/reset consequences are mandatory; PIN never creates general-purpose assurance or implies Branch Manager/Owner authority. |
| MFA | ID-02, ID-13, ID-14, ID-16 | Owner and every Branch Manager use MFA; sensitive Branch Manager actions require step-up; delegation is narrow; Owner recovery uses independent factors and dual control. |
| Cookie and CSRF | ID-03, ID-04, ID-05, ID-17, ID-19 | Server-enforced session limits and revocation operate through one HTTPS origin and one managed edge, with private Rails origin and no default CORS. |
| Session policy | ID-03, ID-04, ID-05, ID-15, ID-19 | Exact back-office/POS time limits, multi-device visibility, anomaly/revocation controls, Owner all-session revocation, and lifecycle invalidation apply; MVP has no numeric cap. |
| Login defenses | ID-07, ID-11, ID-15 | Username is the login identifier; public responses resist enumeration; failures use rate limiting/progressive delay and temporary automated lock, never permanent failure-only lock. |
| Trusted proxy and HTTPS | ID-07, ID-17 | One HTTPS origin, one managed edge, private Rails origin, explicit trusted proxies, configured Host Authorization, safe health output, and trustworthy source derivation are required. |
| Audit security | ID-09, ID-12, ID-13, ID-14, ID-15, ID-18 | Sensitive and assignment actions are attributable; six event classes, explicit readers, append-only integrity, controlled holds/exports/anonymization, and no self-tampering are required. |
| Owner recovery | ID-06, ID-16 | Owner recovery is separate, prevention-first, uses at least two independent factors, offline material, two independent proofs and dual control; Branch Manager cannot independently recover Owner. |
| Offboarding and suspension | ID-05, ID-09, ID-14, ID-15, ID-19 | Owner controls suspension/reactivation/deactivation and assignments; delegation and unused invitations can be revoked; all-session revocation and history preservation are mandatory. |

## 4. Ten security review dossiers

### 4.1 Password hashing

**Current status:** `OPEN` — preserved.  
**Policy:** ID-06, ID-07, ID-11, ID-15, and IDs 24–26/28. Passwords must never be reversibly stored, logged, or truncated; NFC and common/compromised-value blocking are required; Argon2id is the preferred candidate but no dependency/profile is approved; a separate password pepper is not mandatory for MVP; credential replacement consequences are required.

**Unresolved decisions:** maintained library/version; algorithm parameter set and production-like calibration target; salt/library behavior; exact character/byte/request limits; blocklist source/update/privacy/outage behavior; parameter versioning/rehash; exact reset/session/recovery matrix; reset token design; secret filtering; operational response to dependency advisories; any future password-pepper design.

**Threats and abuse cases:** offline cracking after database exposure; common-password reuse; oversized-input resource exhaustion; timing/account enumeration; plaintext/log leakage; stale weak hashes that never upgrade; concurrent login/reset races.

**Required security properties:** only salted adaptive digests persist; inputs are bounded before expensive work; verification uses maintained library behavior; public failure contract is generic; successful authentication can safely upgrade older parameters; reset/recovery invalidates required sessions without exposing the chosen password; secrets never enter logs, audit, jobs, errors, or analytics.

| Test class | Required scenarios |
|---|---|
| Positive | Create and verify a password; authenticate Unicode/space/long permitted values; successful old-parameter login rehashes once; approved reset produces a new digest and revokes required sessions. |
| Negative | Wrong/unknown/inactive identity has generic response; compromised/common value rejected if that control is selected; plaintext/digest absent from responses/logs/audit/jobs; malformed and oversized inputs fail before hashing. |
| Boundary | Exact minimum, maximum, maximum-plus-one, byte-versus-character, Unicode normalization, empty/null, benchmark cost and memory ceilings on production-like hardware. |
| Concurrency | Two successful logins race to rehash safely; reset races with login; credential change races with session use; duplicate reset consumption succeeds once. |

**Evidence required for acceptance:** dependency/version and maintenance record; benchmark raw results and host profile; approved input/parameter/upgrade policy; database inspection proving digest-only storage; request/service specs and log-redaction artifacts; recovery/session invalidation tests; advisory/rotation runbook; named reviewer sign-off and residual risks.

**External specialist:** An independent application-security reviewer is required. A third-party specialist is recommended and becomes required if the team lacks demonstrated password-storage and benchmark expertise.

### 4.2 PIN protection

**Current status:** `OPEN` — preserved.  
**Policy:** ID-01, ID-04, ID-07, ID-13, IDs 21–24, and IDs 27–28. PINs are individual 6–8 digit credentials, never four-digit or store-wide shared, and may authenticate/reauthenticate only the identified employee on an enrolled POS within approved Branch boundaries. They cannot create a general-purpose Session, authorize recovery, replace MFA/step-up, grant roles/assignments, perform Owner/security administration, bypass authorization, or perform other privileged actions. Distributed online defenses and distinct pepper/change/reset consequences are required.

**Unresolved decisions:** exact permitted length within the approved 6–8 digit range; digest dependency/profile/cost separate from passwords; device enrollment/binding; exact account/device/source thresholds and windows; progressive-delay and temporary-lock duration/release; trusted-source derivation; distributed state/capacity/outage behavior; PIN-pepper provider/custody/rotation/compromise/loss procedure; exact change/reset/revocation matrix; observability without secret leakage.

**Threats and abuse cases:** online/offline guessing; shoulder surfing; credential sharing; distributed attempts across devices/sources; attacker-triggered denial of service; PIN reuse outside POS; cross-Branch/device replay; log or analytics disclosure.

**Required security properties:** one PIN maps to one accountable User; raw PIN never persists; verification is rate-limited across every path; PIN proof is insufficient for privileged/recovery actions; device and effective Branch/Role/Branch Assignment are revalidated; lock is temporary and separate from employment; response timing/content resists enumeration.

| Test class | Required scenarios |
|---|---|
| Positive | Correct individual PIN unlocks an eligible User on an enrolled POS/assigned Branch; operator switch preserves actor attribution; approved PIN reset invalidates old PIN. |
| Negative | Shared PIN setup rejected; wrong/unknown/inactive responses are generic; PIN fails for recovery/MFA/Owner/assignment operations; unassigned Branch/device and alternate endpoint denied; logs contain no PIN. |
| Boundary | Exact length limits, leading zeros, retry/window/delay edges, two-minute POS lock boundary, clock skew, and maximum-input behavior. |
| Concurrency | Parallel attempts cannot overspend retry budget; attempts distributed across nodes/devices aggregate correctly; reset races with verification; suspension/deactivation wins over in-flight unlock. |

**Evidence required for acceptance:** approved format/digest/limits; production-like benchmark; device/Branch trust design; complete endpoint inventory; distributed limiter results; request/policy/race/redaction tests; operational unlock/reset runbook; monitoring examples; named reviewer decision and residual risks.

**External specialist:** Independent application-security review is required; third-party review is recommended if short-secret and distributed-rate-limit expertise is unavailable internally.

### 4.3 MFA

**Current status:** `BLOCKED` — preserved.  
**Policy:** ID-02 and ID-13 require MFA for Owner and every Branch Manager and step-up for sensitive Branch Manager actions. ID-14 prevents invitation delegation from expanding authority. ID-16 sets Owner recovery principles.

**Unresolved decisions:** explicit ordinary/sensitive capability matrix; factor technology and assurance; phishing-resistant primary method and any fallback; enrollment/activation; step-up freshness; replacement/removal; lost-device and recovery behavior; factor-secret encryption/key management; recovery-code storage; notification; device support; support procedure. No provider is selected.

**Threats and abuse cases:** phishing and replay; MFA fatigue; enrollment by a stolen session; factor replacement as takeover; recovery bypass; downgrade to weaker factor; Branch Manager using MFA to exceed assigned scope; leaked seeds/recovery codes; indefinite lockout.

**Required security properties:** mandatory enforcement cannot be bypassed by route/client; step-up is action- and freshness-bound; enrollment/replacement/removal require stronger proof and audit; factors/recovery material are protected and revocable; recovery cannot silently erase evidence or widen authorization; Branch and capability policy remains authoritative after MFA.

| Test class | Required scenarios |
|---|---|
| Positive | Owner and every Branch Manager enroll and verify approved factors; sensitive capability accepts fresh approved step-up; factor replacement rotates/revokes old material and notifies through an approved channel. |
| Negative | Staff or stale session cannot enroll for another User; missing/stale/wrong/replayed proof denied; PIN cannot satisfy privileged step-up; factor downgrade/removal and recovery cannot bypass dual control or Branch scope. |
| Boundary | Step-up freshness at exact expiry, one-time code replay/window edges if applicable, maximum factors/recovery codes if selected, clock skew, interrupted enrollment, last-factor removal. |
| Concurrency | Simultaneous verification consumes one-time proof safely; replacement races with old-factor use; suspension/deactivation and all-session revocation win; two enrollment completions cannot create an unreviewed bypass. |

**Evidence required for acceptance:** approved capability matrix; factor threat model and selection record; secret/key architecture; enrollment/replacement/recovery runbooks; end-to-end request/policy/race/redaction tests; phishing/replay assessment; device compatibility results; monitoring/notification evidence; named specialist sign-off.

**External specialist:** External or demonstrably independent specialist review is required because privileged authentication, recovery, phishing resistance, and secret custody are high-impact and no method is selected.

### 4.4 Cookie and CSRF

**Current status:** `BLOCKED` — preserved.  
**Policy:** ID-17 fixes one HTTPS origin, one managed edge, a private Rails origin, explicit proxy trust, configured Host Authorization, and no default CORS. IDs 03–05 and 19 define session expiry/revocation outcomes. ADR-0006 proposes opaque host-only cookie sessions and Rails CSRF plus origin checking.

**Unresolved decisions:** final cookie name/flags and `SameSite`; token structure/entropy/verifier lookup; Rails API cookie/session/CSRF middleware; rotation points; cache headers; logout semantics; permitted origins/hosts; error behavior; actual public/edge/origin route; browser support. Exact topology and vendor remain unselected.

**Threats and abuse cases:** session fixation/theft; cross-site mutation; cookie scope leakage; token in URL/local storage/log; cached authenticated response; copied-old-token replay; CORS misconfiguration; logout or rotation race.

**Required security properties:** raw token is high entropy and exists only in the host-only secure cookie/client; only verifier persists; unsafe requests require valid CSRF and same-origin evidence; foreign origins and wildcard credentialed CORS fail; authentication rotates secrets; old/revoked tokens fail; sensitive responses are not shared-cacheable; errors expose no secrets.

| Test class | Required scenarios |
|---|---|
| Positive | Same-origin login sets exact cookie attributes; valid CSRF permits every unsafe verb; rotation yields a new token; logout revokes current session. |
| Negative | Missing/invalid token, foreign/missing Origin under approved policy, state-changing GET, wildcard credentialed CORS, copied old token, foreign Host, and token in URL/header/log are rejected or absent. |
| Boundary | Cookie path/domain/host-only behavior, `SameSite` browser cases, token entropy/length, expiry edge, cache directives, subdomain and alternate-port behavior. |
| Concurrency | Two requests during rotation cannot resurrect old token; logout/revocation wins over in-flight unsafe request according to documented transaction boundary; simultaneous login sessions remain independent. |

**Evidence required for acceptance:** deployed topology diagram; middleware/config snapshot; entropy/verifier design; browser matrix and automated browser/request evidence through the real edge; cookie/CSRF/CORS/cache tests; raw storage/log inspection; rotation/revocation race results; reviewer sign-off.

**External specialist:** Independent web-application security review is required. External penetration testing is required before production if equivalent browser and deployed-edge expertise is not independent within the delivery team.

### 4.5 Session policy

**Current status:** `OPEN` — preserved.  
**Policy:** ID-03 sets 30-minute idle and 12-hour absolute back-office limits; ID-04 sets a two-minute POS idle lock; IDs 05 and 19 allow multiple sessions without a numeric MVP cap and require visibility/Owner all-session revocation; ID-15 makes lifecycle restrictions authoritative.

**Unresolved decisions:** persistence and token lookup; server clock source; idle touch/renewal cadence; POS reauthentication proof; session inventory fields/privacy; individual self-revocation; new-device detection/notification; anomaly signals; cleanup under retention; distributed cache/database behavior; transaction boundary for mass revocation.

**Threats and abuse cases:** sessions outlive limits; unattended POS; stolen-session persistence; stale role/Branch access; revocation race; forced logout/denial; unsafe device metadata exposure; unlimited expired-row growth; invented numeric cap.

**Required security properties:** server time governs expiry; absolute lifetime never extends; idle activity has one documented definition; POS lock does not change employment; each session is independently visible/revocable without secret; Owner all-session and lifecycle revocation fail closed; current authorization is reevaluated; no hard-coded cap exists.

| Test class | Required scenarios |
|---|---|
| Positive | Independent multi-device sessions; valid activity before idle edge; safe inventory; single-session and Owner all-session revocation; approved POS reauthentication restores use without widening scope. |
| Negative | Expired/revoked/suspended/deactivated session rejected; idle POS cannot mutate; raw token absent from inventory; revoked assignment/Branch scope takes effect; no implicit three-session cap. |
| Boundary | 29:59/30:00 idle, 11:59:59/12:00 absolute, 1:59/2:00 POS lock, clock skew, daylight/timezone independence, renewal exactly at boundaries. |
| Concurrency | Last-seen updates are monotonic; parallel requests at expiry are deterministic; all-session revocation wins over in-flight/new issuance; logout of one session does not revoke others; cleanup cannot remove active session. |

**Evidence required for acceptance:** state/transaction design; exact activity/renewal rules; deterministic clock-based specs; multi-process/race tests against PostgreSQL; inventory/privacy review; notification/anomaly design; cleanup/retention evidence; operational revocation drill; named reviewer approval.

**External specialist:** Independent security review is required; external review is recommended for distributed race and privacy design if internal expertise is insufficient.

### 4.6 Login defenses

**Current status:** `OPEN` — preserved.  
**Policy:** ID-07 requires rate limiting and progressive delay and forbids permanent lock from failures alone. ID-11 makes username the only login identifier and email recovery-only. ID-15 separates temporary automated lock from Owner-controlled lifecycle actions.

**Unresolved decisions:** account/source/device keys; thresholds, windows, delay curve, temporary lock and reset conditions; distributed storage/atomicity; trusted client-IP derivation; generic status/body/timing; `Retry-After`; recovery/PIN/MFA endpoint coverage; monitoring/escalation; handling of IPv6/NAT/proxy rotation.

**Threats and abuse cases:** credential stuffing; username/account-state enumeration; source rotation and distributed guessing; alternate-endpoint bypass; malicious lockout/denial; proxy spoofing; limiter exhaustion; monitoring blind spots.

**Required security properties:** every authentication/recovery path shares approved defenses; known/unknown/inactive/locked outcomes are publicly equivalent where required; counters update atomically across processes; progressive delay is bounded and temporary; client source uses only trusted proxy data; successful reset/unlock follows approved policy and audit.

| Test class | Required scenarios |
|---|---|
| Positive | Valid login within budget; counters/delay reset only under approved conditions; response includes accurate `Retry-After`; security events/metrics are emitted without raw credentials. |
| Negative | Unknown/inactive/locked/wrong-password responses resist enumeration; distributed source/account/device attacks are constrained; alternate login/recovery/PIN routes cannot bypass; spoofed headers do not change limiter key. |
| Boundary | Exact threshold/window/delay/reset edges, server clock changes, IPv4/IPv6 and NAT cases, username normalization, maximum identifier/input lengths. |
| Concurrency | Parallel failures cannot lose increments; success racing threshold does not bypass policy; distributed processes share state; unlock/reset racing requests produce one deterministic outcome. |

**Evidence required for acceptance:** approved threat-based limits and keys; distributed storage/atomicity design; trusted-proxy dependency; equivalence/timing measurements; endpoint inventory; concurrency and source-rotation tests; monitoring/alert examples; operations runbook; specialist approval.

**External specialist:** Independent application-security review is required. External adversarial testing is recommended for enumeration and distributed-bypass resistance.

### 4.7 Trusted proxy and HTTPS

**Current status:** `BLOCKED` — preserved.  
**Policy:** ID-17 requires one HTTPS origin, one managed edge, private Rails origin, explicit trusted proxies, enabled/configured Host Authorization, no default CORS, and safe health output. ID-07 depends on trustworthy source derivation. No provider is selected.

**Unresolved decisions:** hosting/domain/DNS/edge/CDN/WAF; exact hop order, protocols, ports, CIDRs and header ownership; private connectivity and origin access; TLS versions/ciphers/certificates/HSTS; Rails `force_ssl`/`assume_ssl`; Host allowlist; client-IP derivation; proxy-change ownership; health exposure/monitoring; staging parity.

**Threats and abuse cases:** forged forwarding headers; direct-origin bypass; HTTP downgrade; Host-header/DNS rebinding; rate-limit/audit source spoofing; stale proxy CIDR after provider change; overly detailed health output; certificate/route failure.

**Required security properties:** only managed edge is public; only explicit hops are trusted; edge replaces untrusted forwarding data; Rails accepts approved hosts and HTTPS context; direct origin/HTTP fails; derived source is stable enough for limiter/audit; health reveals only liveness/readiness contract; topology changes are controlled and tested.

| Test class | Required scenarios |
|---|---|
| Positive | Real staging path derives expected scheme/host/client source; approved Host succeeds; TLS/HSTS and health monitoring operate through every intended hop. |
| Negative | Direct origin, HTTP, foreign Host, spoofed/duplicate forwarding headers, untrusted proxy, unexpected path/CORS, and infrastructure-detail probing fail safely. |
| Boundary | First/last trusted hop, multi-hop header order, IPv4/IPv6 CIDRs, certificate renewal, proxy CIDR rotation, health timeout/retry thresholds. |
| Concurrency | Rolling edge/origin configuration never creates a mixed trust window; concurrent traffic during certificate/CIDR change remains fail-closed; all application instances derive the same source. |

**Evidence required for acceptance:** approved topology and data-flow diagram; infrastructure/config exports; DNS/TLS/Host/CIDR inventory; staging parity statement; direct-origin firewall evidence; executed header/source/TLS/health tests through real path; rollback/change runbook; monitoring evidence; independent review.

**External specialist:** External infrastructure/application-security review is required before production because acceptance depends on vendor/network configuration outside Rails and adversarial testing of the real path.

### 4.8 Audit security

**Current status:** `BLOCKED` — preserved.  
**Policy:** ID-12 requires restricted append-only audit. ID-18 defines Security, Account lifecycle, Authorization and assignment, Financial, HR/payroll, and Operational classes, explicit reader authorization, no self-tampering, controlled holds/exports/anonymization, integrity, and accountability. It approves no retention duration.

**Unresolved decisions:** event catalog and required fields; safe failure subject correlation; database roles/privileges; same-transaction or fail-closed delivery; integrity verification; reader roles/scope/self-investigation; redaction; backup/export encryption; external administrator evidence; class-specific retention after legal review; holds/anonymization jobs; monitoring/reconciliation.

**Threats and abuse cases:** actor edits/deletes own evidence; missing event on rollback/partial failure; secret/PII leakage; unauthorized read/export; insider self-investigation; premature deletion or indefinite retention; hold bypass; database administrator suppresses evidence.

**Required security properties:** required events are attributable without secrets; sensitive state and audit commit atomically or fail closed; application runtime cannot update/delete or generally read; reader/export/break-glass access is explicitly authorized and audited; integrity gaps are detectable; retention/anonymization respects approved holds and preserves domain ledgers.

| Test class | Required scenarios |
|---|---|
| Positive | Each required event class records safe actor/target/scope/outcome/request/time; authorized scoped read/export is audited; approved hold prevents scheduled disposition. |
| Negative | Runtime and actor cannot update/delete own records; unauthorized/cross-Branch/self-investigation read denied; secrets/raw tokens/unrestricted bodies absent; export/hold bypass rejected. |
| Boundary | Null actor for unauthenticated failure, maximum safe metadata, exact class/retention transition after future approval, hold start/release, anonymization versus immutable ledger references. |
| Concurrency | Sensitive mutation and event commit/rollback together; concurrent events preserve uniqueness/order evidence; hold races with cleanup; export races with authorization revocation; retry does not duplicate semantic event. |

**Evidence required for acceptance:** approved event/class/data dictionary; database privilege output; atomicity/rollback/immutability/redaction tests; reader/export/hold/anonymization policy tests; integrity/reconciliation and backup/restore evidence; access logs; legal/privacy opinion and approved retention schedule; named security reviewer acceptance.

**External specialist:** Independent database/application-security review is required. Qualified external legal/privacy review is mandatory for retention and handling questions; technical acceptance cannot substitute for it.

### 4.9 Owner recovery

**Current status:** `BLOCKED` — preserved.  
**Policy:** ID-06 separates Owner recovery from employee recovery. ID-16 requires at least two independent factors enrolled in advance, preference for passkeys/hardware keys where appropriate, offline material, two independent proofs, dual control, no independent Branch Manager recovery, and an Owner-unavailable emergency procedure.

**Unresolved decisions:** exact proof types and assurance; authentication architecture/provider; custodians and independence; offline storage/rotation; cooling-off and escalation; lost-all-factor and Owner-unavailable flows; notification channels; operator access; session/factor/recovery-material revocation; monitoring/audit; rehearsal frequency and ownership; evidence retention after legal/privacy review.

**Threats and abuse cases:** mailbox/support social engineering; malicious or colluding custodian; Branch Manager takeover; stolen offline material; lost-all-factor permanent lockout; manual database bypass; notification suppression; parallel recovery race; recovery evidence overcollection.

**Required security properties:** no single mailbox, code, employee, Branch Manager, database operator, or unavailable Owner session can recover the account alone; proofs are independent; dual control is attributable; old sessions/factors/material are revoked; all contacts are notified through approved channels; recovery creates immutable evidence; partial failure fails closed and is recoverable operationally.

| Test class | Required scenarios |
|---|---|
| Positive | Approved two-proof/two-actor recovery completes, revokes sessions/factors/material, requires new MFA enrollment, notifies contacts, and emits complete audit evidence. |
| Negative | One proof/actor, Branch Manager alone, unregistered custodian, stale/replayed material, mailbox-only request, manual database edit, or suppressed notification cannot complete recovery. |
| Boundary | One custodian unavailable, one factor still available versus lost-all-factor, cooling-off exact edge if selected, expired/rotated material, disputed request, Owner unavailable. |
| Concurrency | Two recovery attempts cannot both succeed; factor use races with recovery; revocation wins over active sessions; custodian approval withdrawal/expiry races completion; partial notification/audit failure remains fail-closed. |

**Evidence required for acceptance:** approved assurance/proof/custodian design; threat model; custody and rotation records; written normal/emergency runbooks; implementation/config evidence; executed tabletop plus controlled drill; complete race/failure/security tests; notification/audit artifacts; legal/privacy treatment of proof evidence; named independent reviewers and residual risks.

**External specialist:** External identity-security specialist review is required. Qualified legal/privacy review is also required for recovery evidence collection, access, retention, and disclosure.

### 4.10 Offboarding and suspension

**Current status:** `BLOCKED` — preserved.  
**Policy:** ID-15 separates automated authentication lock from Owner-controlled suspension/reactivation/deactivation; reactivation is explicit and audited; deactivation has no automatic return; rehire/reactivation is Owner-controlled; history remains. ID-09 reserves assignment changes to Owner approval. ID-14 governs delegation revocation and unused invitations. IDs 05 and 19 require all-session revocation.

**Unresolved decisions:** command/transaction boundary; whether suspension preserves assignments; exact ending of current/future Role and Branch Assignments on deactivation; lock-release policy; recovery/PIN/MFA/device revocation; delegation/invitation invalidation; failure/retry/outbox behavior; Owner-unavailable escalation; HR/security coordination and notification; rehire identity linking; operational response time.

**Threats and abuse cases:** former/suspended worker retains session/PIN/future grant; partial revocation reopens access; Branch Manager exercises Owner lifecycle power; history deletion; accidental deactivation; unauthorized reactivation; race between privileged command and offboarding; unused delegate invitation survives revocation.

**Required security properties:** non-active User cannot create/use sessions; Owner authority and audit are mandatory; deactivation/revocation is atomic where possible and otherwise fail-closed; all access paths and future grants are covered; reactivation never silently restores expired/excess scope; Employee/business/audit history remains; Owner-unavailable procedure grants no implicit Branch Manager power.

| Test class | Required scenarios |
|---|---|
| Positive | Owner suspension/deactivation revokes all required access; explicit Owner reactivation records reason/audit and revalidates factors/assignments; explicit rehire links preserved history correctly. |
| Negative | Branch Manager/self cannot suspend/reactivate/deactivate; non-active User cannot login/PIN/use existing session; revoked delegation's unused invitations fail; direct status edit cannot restore access; history cannot be deleted. |
| Boundary | Effective-time and future-assignment edges, lock versus suspension, already expired session, scheduled shift, last request before transition, repeated idempotent offboarding/reactivation. |
| Concurrency | Offboarding wins over in-flight privileged mutation and new session; simultaneous reactivation/deactivation serializes; session/recovery/invitation use races revocation; partial subsystem/database failure remains observable and closed. |

**Evidence required for acceptance:** approved lifecycle and Owner-unavailable runbooks; transaction/failure design; complete credential/session/grant/delegation inventory; policy/request/model/concurrency tests; failure-injection evidence; history-preservation/database constraints; monitoring/alert evidence; HR/legal/privacy review where records or notices require it; security reviewer sign-off.

**External specialist:** Independent application-security review is required. External review is recommended for the Owner-unavailable and incident-response procedure; qualified HR/legal/privacy advice is required for employment-record and notice questions.

## 5. Threat and abuse-case matrix

| Threat or abuse case | Primary review areas | Required proof theme |
|---|---|---|
| Offline credential cracking | Password hashing, PIN protection | Adaptive digest calibration, safe storage, upgrade path |
| Credential/PIN stuffing and source rotation | PIN protection, Login defenses, Trusted proxy | Atomic distributed limits, trustworthy source, alternate-path coverage |
| Account or state enumeration | Password hashing, PIN protection, Login defenses, Owner recovery | Generic contract, bounded timing, safe monitoring |
| Session theft, fixation, or stale privilege | Cookie/CSRF, Session policy, MFA, Offboarding | Entropy, rotation, current authorization, immediate revocation |
| CSRF or cross-origin mutation | Cookie/CSRF, Trusted proxy | Browser evidence, origin/CSRF enforcement, no broad credentialed CORS |
| Cross-Branch/vertical privilege escalation | MFA, Audit security, Offboarding | Explicit capability/Branch intersection, step-up, Owner approval, immutable evidence |
| Delegation abuse or stale invitation | MFA, Audit security, Offboarding | Active delegate revalidation, 90-day maximum, revocation race tests |
| Owner recovery takeover or permanent lockout | MFA, Owner recovery, Audit security | Independent proofs/factors, dual control, drills, complete audit |
| Audit tampering or privacy overcollection | Audit security, Owner recovery | DB privilege denial, redaction, controlled readers/exports/holds, legal review |
| Proxy/header/Host/TLS bypass | Trusted proxy/HTTPS, Login defenses, Cookie/CSRF | Real-path staging tests, direct-origin denial, exact trust configuration |
| Attacker-triggered denial through lockout | Login defenses, PIN protection, Offboarding | Bounded temporary lock, source/account/device signals, approved unlock |
| Revocation or lifecycle race | Session policy, Owner recovery, Offboarding, Audit | Locked/serialized transitions, fail-closed partial failure, concurrency evidence |

## 6. Required evidence manifest and acceptance record

Each area must produce, where applicable:

1. versioned design and data-flow/threat model;
2. exact configuration and dependency versions with secret values redacted;
3. decision record for unresolved parameters and operational ownership;
4. automated positive, negative, boundary, and concurrency tests with command/output and seed;
5. production-like benchmark or staging-path evidence where local CI is not representative;
6. database privilege/schema/constraint evidence;
7. browser, proxy, multi-process, or failure-injection evidence outside ordinary unit tests;
8. logging/audit/redaction samples containing no live secrets or production personal data;
9. operating, incident, recovery, rotation, rollback, and drill runbooks;
10. named reviewer, competency/independence, date, findings, residual risks, compensating controls, and production conditions;
11. legal/privacy opinion and Owner-approved operational policy where the area processes regulated or employment/customer data;
12. immutable artifact locations and expiry/re-review triggers.

Use this acceptance record without changing checklist state until it is complete:

| Field | Required entry |
|---|---|
| Checklist area and prior status | Exact row and current `OPEN`/`BLOCKED` state |
| Design/config version | Commit or immutable artifact identifier; environment |
| Evidence executed | Commands, test reports, benchmark/staging/drill results |
| Acceptance-criterion result | One result per checklist criterion; pass/fail/not applicable with reason |
| Reviewer | Name, role, qualification, independence, date |
| Legal/privacy input | Opinion/reference and scope, or explicit not applicable rationale |
| Findings and remediation | Severity, owner, due date, retest evidence |
| Residual risk | Accepted by authorized risk owner; compensating controls |
| Production conditions | Configuration, monitoring, runbook, and re-review triggers that must remain true |
| Final checklist action | Proposed status change; performed only in the canonical checklist after evidence review |

## 7. Legal and privacy review preparation

### 7.1 Data-purpose-access map

No row below asserts a legal basis or retention period. It identifies product purpose and the access boundary that must be validated by qualified review.

| Data category | Examples | Business/security purpose | Intended access boundary | Unresolved legal/privacy topics |
|---|---|---|---|---|
| Identity and contact | Username, display name, email, phone | Authentication identity, contact, recovery, accountability | User self where appropriate; explicitly authorized Owner/support functions | Collection/minimization, verification, correction, pre-employment use, offboarding, disclosure |
| Credential material | Password/PIN digests, algorithm/parameter metadata | Authenticate an individual without recoverable secret storage | Authentication subsystem only; no general reader | Storage/compromise handling, deletion versus retained history, breach response |
| MFA and recovery | Factor metadata, encrypted seed if selected, recovery-code digests, proof/custodian evidence | Privileged authentication and account recovery | User and narrowly authorized recovery actors; secrets never generally readable | Proof collection, custodian data, retention, access, notification, cross-provider transfer |
| Session/device/network | Session verifier, device summary, timestamps, IP/source/User-Agent summaries, anomaly signals | Session control, visibility, fraud/security detection | User self and explicitly authorized Owner/security readers; minimized views | Proportionality, notice, precision, retention, employee monitoring, new-device notification |
| Employment and authorization | Employee link, status, Role/Branch Assignments, delegation, approvals | Work eligibility, server authorization, accountability | Owner; assigned-scope managers only where explicitly allowed; employee self where appropriate | Pre-employment, suspension/offboarding, access/correction, record separation, retention |
| Security audit | Login/recovery/MFA/session/denial events | Incident detection, accountability, investigation | Explicit audit readers; actor cannot alter own evidence | Retention by class, self-investigation, source metadata, integrity evidence, access logs |
| HR and payroll audit | Payroll access/approval/change evidence | Payroll integrity and dispute/accountability support | Owner and explicitly authorized HR/payroll readers; no inferred Branch Manager access | Employee visibility, export, retention, correction, holds, sensitive field minimization |
| Financial/operational audit | Payments, cash, inventory, order/approval event references | Fraud control, reconciliation, operational accountability | Explicit role/Branch/business-purpose scope | Customer/staff linkage, accounting overlap, retention, export, investigation scope |
| Customer-linked data in audit | Customer/resource identifiers, safe change summaries | Attribute authorized operational actions | Minimized, purpose-bound authorized readers | Customer visibility, minimization/anonymization, subject requests, legal holds |
| Invitation/pre-employment | Candidate contact, proposed Branch, inviter/delegation evidence | Invitation-only onboarding and anti-abuse evidence | Owner and current delegated manager within assigned scope | Consent/notice, unsuccessful candidate retention, revocation, export/deletion |
| Legal hold/export/anonymization metadata | Hold reason/authority, export recipient/purpose, disposition record | Controlled preservation/disclosure/disposition | Separately authorized and audited custodians | Authority, notification, scope, release, recipient controls, anonymization standard/timing |

### 7.2 Questions for qualified legal/privacy review

1. Which current Vietnamese employment, privacy, accounting/tax, dispute, and security-incident obligations apply to each audit/data class, and which entity is accountable?
2. What lawful purposes and notices are required for employee login, device/network, anomaly, session-visibility, and new-device-notification data?
3. What minimum and maximum retention bounds apply separately to Security, Account lifecycle, Authorization/assignment, Financial, HR/payroll, and Operational events?
4. Which records must remain identifiable, which may be irreversibly anonymized, and what standard demonstrates effective anonymization?
5. How should retention and access differ for candidates who never become Employees, active Employees, suspended/offboarded Employees, and rehired Employees?
6. What access, correction, export, objection, deletion, or restriction rights apply, and which immutable audit/ledger records are exempt or handled differently?
7. What payroll and customer-linked fields may Branch Managers, Owner, audit readers, operations staff, and external advisers see? Is second review required for self-investigation?
8. What Owner-recovery proof and custodian evidence may be collected, who may inspect it, where may it be stored, and when must it be destroyed or anonymized?
9. Who may authorize a legal/investigation hold, what scope and notice are required, how is release approved, and how are conflicting deletion requests handled?
10. Who may approve audit/data exports, for which recipients and purposes, with what minimization, encryption, expiry, onward-disclosure, and destruction controls?
11. What breach/incident notification and evidence-preservation duties apply to credentials, factors, recovery evidence, sessions, HR/payroll, customer-linked audit, and exports?
12. Do hosting, authentication, notification, monitoring, backup, or edge providers create cross-border transfer, processor, contract, or data-location requirements?
13. What documentation is required to demonstrate periodic review of retention, reader authorization, holds, exports, and anonymization?
14. Which conclusions require Owner approval after legal advice, and which cannot be varied by Owner policy?

## 8. Test execution and CI evidence plan

| Evidence type | Current repository support | Additional environment required before acceptance |
|---|---|---|
| RSpec model/service/request/integration tests | Supported; randomized RSpec with PostgreSQL transactional isolation | Identity implementation and review-approved policy fixtures; no Milestone 2B work is authorized by this package |
| PostgreSQL constraints/transactions | PostgreSQL 18.7 service and `db:prepare`; structure drift check | Concurrency/failure tests using independent connections/processes; privilege-separated roles where required |
| Static and dependency analysis | RuboCop, Brakeman, Bundler Audit | Findings triage and identity-specific manual review; scanners do not prove policy correctness |
| Coverage | SimpleCov diagnostic output under testing standards | Security-property traceability; no arbitrary percentage substitutes for scenario evidence |
| Browser cookie/CSRF behavior | Not present in current CI | Supported-browser automation through actual middleware and staging edge |
| Distributed rate limiting/session races | Not present in current CI | Multi-process/shared-store test environment, deterministic clocks, load/concurrency harness |
| Password/PIN calibration | Not represented by ordinary CI host | Production-like hardware benchmark with recorded resource/latency results |
| Proxy/TLS/Host/direct-origin controls | Not present in current CI | Production-parity staging topology and external network tests |
| Operational recovery/offboarding | Not present in current CI | Tabletop and controlled drill with named actors, runbooks, injected failures, audit/notification evidence |
| Legal/privacy conclusions | Cannot be produced by CI | Qualified professional opinion and Owner-approved policy within legal bounds |

Security specs must be independently runnable, deterministic, and safe for CI. They must use synthetic data, never real credentials or production personal information. Timing tests must report environment/noise and cannot claim constant-time behavior from a single CI sample. Concurrency evidence must use genuinely independent database connections or processes where the asserted race cannot occur inside one transactional example.

## 9. Dependencies and blockers

1. The ordinary and sensitive Branch Manager capability matrix is not enumerated.
2. IDs 21–28 fix password/PIN policy boundaries, but the hashing dependency/profile, exact password and PIN limits within approved bounds, online-control values, device/source mechanisms, pepper operations, credential-event matrix, and benchmarks remain unselected or unverified.
3. MFA factors, step-up freshness, enrollment, replacement, recovery, and secret custody are not selected.
4. Session/cookie/CSRF middleware, storage, token, renewal, inventory, notification, anomaly, and revocation designs are not implemented or reviewed.
5. Rate-limit keys, numeric thresholds/windows, distributed state, and trusted client-source derivation are undecided.
6. Hosting, domain/DNS, edge/CDN, proxy chain, CIDRs, private connectivity, health monitoring, and operational ownership are unselected.
7. Audit event catalog, database privilege design, integrity verification, readers, exports, holds, disposition, and external evidence are incomplete.
8. Owner-recovery proofs, custodians, provider/implementation, storage/rotation, delay/escalation, monitoring, runbooks, and drills are undefined.
9. Authentication-lock release and Owner-unavailable/offboarding failure procedures are not approved or exercised.
10. Qualified legal/privacy advice has not supplied retention, visibility, recovery-evidence, hold/export, anonymization, transfer, or data-subject handling requirements.
11. No Identity implementation exists from which executed application evidence could be collected; this milestone does not authorize creating it.

## 10. Proposed review sequence

1. **Freeze policy traceability:** confirm the twenty-eight decisions and enumerate the Branch Manager capability matrix without adding business capabilities.
2. **Obtain legal/privacy scoping advice early:** classify data, likely providers/transfers, retention inputs, and employment/customer boundaries before physical audit/recovery design.
3. **Select technical designs on paper:** password/PIN, MFA, sessions/cookies/CSRF, login defenses, audit privileges, recovery, lifecycle transactions, and operational ownership.
4. **Select deployment facts:** domain, edge/proxy chain, private connectivity, trusted CIDRs, TLS/Host/health behavior; update deployment evidence without selecting a vendor in this package.
5. **Conduct Owner-led architecture threat review:** follow ID-20 and the Owner-led protocol, preserve the self-review limitation, and record evidence/findings without claiming independent closure.
6. **Seek separate Milestone 2B authorization:** only after prerequisites are decision-ready. This package grants no authorization.
7. **Implement test-first if authorized:** capture deterministic positive, negative, boundary, and concurrency evidence in RSpec plus required browser/multi-process/staging harnesses.
8. **Run operational evidence:** proxy tests, calibration, tabletop/drills, failure injection, monitoring, backup/integrity, and privacy procedures.
9. **Owner-led review and remediation:** the Owner records actual artifacts, findings, remediation, retesting, and any explicit residual-risk acceptance under the Owner-led protocol. This is not independent or legal review.
10. **Update canonical checklist last:** only evidence-backed row changes are made; ADR-0006 remains Proposed until every applicable gate is accepted.

## 11. Completion boundary

This package covers all ten checklist areas and prepares the evidence needed for review. It does not select a hosting, CDN, authentication, MFA, recovery, or monitoring vendor; set a retention period; complete a security/legal/privacy review; change checklist status; accept ADR-0006; or authorize/implement Milestone 2B.
