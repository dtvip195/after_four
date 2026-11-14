---
assessment_id: AF-OWNER-001
historical_review_ids:
  - AF-SEC-001
  - AF-SEC-002
owner_review_status: OWNER_REVIEW_IN_PROGRESS
independent_verification: NOT_PERFORMED
legal_review: NOT_PERFORMED
assessment_start_date: 2026-11-14
assessment_completion_date: null
owner_decision_closure: AF-OWNER-001A
argon_decision_closure: AF-OWNER-001D
---

# AF-OWNER-001: Password and PIN Security Assessment

**Assessment type:** Owner-led, non-independent technical/security assessment  
**Owner/reviewer identity:** AFTER FOUR Owner in the project role; also the backend developer  
**Historical professional records:** [AF-SEC-001 Password Hashing](../af-sec-001-password-hashing.md) and [AF-SEC-002 PIN Protection](../af-sec-002-pin-protection.md)  
**Protocol:** [Owner-Led Identity Review Protocol](../../after_four_identity_owner_led_review_protocol.md)  
**Technical control specification:** [AF-OWNER-001B](../../after_four_identity_password_pin_control_specification.md)  
**Argon2 evidence, scoped Owner decisions, and validation planning:** [AF-OWNER-001C.2 Compatibility Spike](af-owner-001c2-argon2id-compatibility-spike.md) · [AF-OWNER-001C.3 Capacity Validation](af-owner-001c3-argon2id-capacity-validation.md) · [AF-OWNER-001D Decision Record](af-owner-001d-argon2-owner-decision-proposals.md) · [AF-OWNER-001E Production-Parity Validation Plan](af-owner-001e-production-parity-validation-plan.md) · [AF-OWNER-001F Deployment Inputs Discovery](af-owner-001f-production-deployment-inputs-discovery.md) · Decision Register IDs 29–34  
**Status:** `OWNER_REVIEW_IN_PROGRESS`  
**Independent verification:** `NOT_PERFORMED`  
**Legal review:** `NOT_PERFORMED`

This assessment is self-review. It is not independent verification, professional certification, legal advice, a claim that the system is secure, or authorization to implement Milestone 2B. The historical professional records remain unchanged and `OPEN`.

## 1. Scope and exclusions

### In scope

- Password algorithm, parameters, salts, optional pepper, verification, rehash, reset/replacement, timing, error behavior, dependency compatibility, logging, and redaction.
- Individual employee PIN format, entropy, digest/pepper design, POS/device/Branch boundary, online defenses, reset/replacement, operator binding, and permitted authentication role.
- Design-to-policy traceability and comparison with the primary guidance already referenced by the technical design.
- Read-only inspection of the Rails foundation, dependency lock, configuration, schema dump, tests, and CI definition.

### Excluded or unavailable

- No Identity implementation, credential model/table, authentication endpoint, rate limiter, enrolled-device model, POS session implementation, reset flow, secret manager, or credential runbook exists.
- No dependency was added and no Argon2/bcrypt/scrypt implementation was installed or executed.
- No production-like benchmark, load test, distributed guessing test, credential storage inspection, log-capture test, recovery race test, or POS manual test could be executed.
- MFA, Owner recovery, session/cookie implementation, deployment topology, and legal/privacy conclusions remain in their separate review scopes except where they constrain password/PIN behavior.
- BA-01 through BA-08 are unaffected and unresolved. ADR-0006 remains Proposed. Milestone 2B remains unauthorized.

## 2. Baseline and sources inspected

The assessment baseline is the repository state inspected on 2026-11-14. The workspace does not expose Git metadata, so file SHA-256 values identify the inspected artifacts.

| Evidence ID | Evidence actually inspected | SHA-256 or version | Result and limitation |
|---|---|---|---|
| `EVID-001` | [Identity Technical Design](../../after_four_identity_technical_design.md) | `04bece354d88056ad2937d4c9e87ad3c345a313c60adf768486e0653a1484b1d` | Defines Argon2id, password, PIN, pepper, reset, timing, and abuse-defense proposals; design evidence only. |
| `EVID-002` | [Security Review Package](../../after_four_identity_security_review_package.md) | `9d10abdb1d1b73b5be0f4e0b82447f46847e79295377700530a48e772daefea9` | Defines AF-SEC-001/002 threats, tests, and acceptance evidence; design evidence only. |
| `EVID-003` | [Owner-Led Review Protocol](../../after_four_identity_owner_led_review_protocol.md) and [Review Results](../../after_four_identity_security_review_results.md) | Protocol `e05054d4ad1da9fadd573fae109ce66ba6fd0e16c0f4d1bf772ea8ff53dd708d`; results `059ec5ade84bb233894990943526f6b64b5cf8cdca03784d81d2e83f0ed6988b` | Governance and historical state inspected before this record was created. |
| `EVID-004` | [Decision Register](../../after_four_identity_decision_register.md) | `e8bb82627569dd96a4d4db0bdefbeab04425ebdc4487a0b04e168b58c72843e0` | Twenty decisions inspected; none changed. |
| `EVID-005` | [AF-SEC-001](../af-sec-001-password-hashing.md), [AF-SEC-002](../af-sec-002-pin-protection.md), and [Owner template](owner-led-assessment-template.md) | AF-SEC-001 `bbc247d97754305f3f8a01e98b67042e6ed05610620847f2f201f06f9869f56a`; AF-SEC-002 `995a57a0be1f674562949af8eb4d3305cd94df73481e75f5ab0d90907391f7e6`; template `9e5154b8b159a6ea846e1fcec22ffa395580847afadeb137290678a1cbcee26e` | Exact historical IDs confirmed; professional records were not repurposed. |
| `EVID-006` | `backend/Gemfile`, `backend/Gemfile.lock`, `.ruby-version`, and Bundler platform output | Gemfile `cacba06b464d52fe7491b61a57964992b322bdf30a372980e119b38a1e470155`; lock `f32c8085db27cf2bb0478b609d1ff5ba02a19ad9b3ffa8f6f4ea5002dc5ad8f0`; Ruby 3.4.12; Rails 8.1.4.1; Bundler 2.6.9 | Dependencies resolve for `arm64-darwin-25`; no Argon2, bcrypt, or scrypt gem is declared or locked. |
| `EVID-007` | `backend/app`, `backend/spec`, and `backend/db/structure.sql` | Structure `e64e389a55a97ccfc07492dc50688d2697bfd1494fe20325193261cf08cdd9d8` | No User, credential, password/PIN, authentication, device, limiter, or Identity persistence/behavior exists. |
| `EVID-008` | `backend/config/initializers/filter_parameter_logging.rb`, structured formatter, API error renderer, and production/test configuration | Filter initializer `d73ca34a07211a123f4a165a4a7fc6fe9771db30f60d966c743dc6d758517961` | `:passw`, tokens, secrets, OTP, cookies, and authorization are filtered. `pin` is not explicit, and arbitrary application log strings are not sanitized by the formatter. No Identity logging path exists yet. |
| `EVID-009` | `.github/workflows/quality.yml`, `backend/config/ci.rb`, and testing standards | Ruby 3.4.12/PostgreSQL 18.7 RSpec, RuboCop, Brakeman, Bundler Audit, and schema checks are configured | CI can host future tests but contains no credential-specific evidence or production-like hashing benchmark. |
| `EVID-010` | [OWASP Password Storage Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html), [RFC 9106](https://www.rfc-editor.org/rfc/rfc9106.html), and [NIST SP 800-63B-4](https://pages.nist.gov/800-63-4/sp800-63b.html) | Primary guidance retrieved 2026-11-14 | Supports Argon2id, unique salts, cost calibration, password input policy, generic/rate-limited verification, and explicit pepper custody/compromise handling. It does not validate this repository's implementation. |
| `EVID-011` | [RubyGems argon2 versions](https://rubygems.org/gems/argon2/versions), [ruby-argon2 repository](https://github.com/technion/ruby-argon2), gemspec, and Rails SecurePassword documentation | Latest observed `argon2` 2.3.3; gem metadata requires Ruby >=2.6; repository documentation only asserts testing on MRI 2.7/3.0; Rails SecurePassword is bcrypt-based | Metadata does not establish Ruby 3.4.12, Rails 8.1.4.1, target-image, or production compatibility. Rails `has_secure_password` is not an Argon2 integration. |
| `EVID-012` | AF-OWNER-001A Owner instruction and [Decision Register](../../after_four_identity_decision_register.md), IDs 21–28 | Owner approval recorded 2026-11-14; Decision Register SHA-256 `42d2ebcdba12363cc3f12c929ffd1e90551b1649b3b262c84fae65b5f9ecc318` | Closes eight policy choices only. It supplies no dependency, benchmark, implementation, test, operational, independent-review, legal-review, or residual-risk-acceptance evidence. |
| `EVID-013` | [AF-OWNER-001B Password/PIN Technical Control Specification](../../after_four_identity_password_pin_control_specification.md) | SHA-256 `ab56b175b791259936b292157e02936ad841d4ee6e5fa8f7531298eb948a35f9` | Makes benchmark, limiter, device, normalization/blocklist, pepper, and transaction proposals implementation-ready for later review. Design evidence only; it executes no control and closes no finding. |
| `EVID-014` | [AF-OWNER-001C.2 Argon2id Compatibility Spike](af-owner-001c2-argon2id-compatibility-spike.md) | SHA-256 `05f793b722c4f85fc50ecc796be327ad52c209baf267dc7b9901bd57d5804f60` | Demonstrates `argon2` 2.3.3 build and functional behavior on the recorded Ruby 3.4.12 aarch64 Linux and arm64 macOS environments. It does not approve a dependency, profile, integration, or finding closure. |
| `EVID-015` | [AF-OWNER-001C.3 Argon2id Capacity Validation](af-owner-001c3-argon2id-capacity-validation.md) | SHA-256 `c4b816989e7db6f8f0ac5251cb6246f4ed453478f6c45cc9640491f611861402` | Records isolated latency, throughput, memory, CPU, and saturation evidence under a 2-CPU/1.5-GiB/no-swap container limit. It is not Rails or production capacity evidence and closes no finding. |
| `EVID-016` | [AF-OWNER-001D Argon2 Candidate Owner Decision Record](af-owner-001d-argon2-owner-decision-proposals.md) | Owner approval dated 2026-11-14 | Records scoped approval of `ARGON-PROP-01` through `ARGON-PROP-06`; it approves candidate-validation and resource/admission direction, not production parameters, implementation, finding closure, or residual risk. |
| `EVID-017` | [Decision Register](../../after_four_identity_decision_register.md), IDs 29–34 | SHA-256 `22618047ab50056bf6ee13328101f70651e723ccb1a41bcda245615c9aadc74d` | Canonical trace from each proposal to its scoped Owner approval and explicit exclusions. IDs 01–28 remain unchanged. |
| `EVID-018` | [AF-OWNER-001E Production-Parity Validation Plan](af-owner-001e-production-parity-validation-plan.md) | SHA-256 `e209085b6cde6825c0b3989eba248e321f50e6f5b2be21a23d20f548309c4dd5` | Defines future environment, P64 lane, HashingAdmission, resource-budget, evidence-package, and revalidation methods. Planning evidence only; no benchmark, implementation, production approval, finding closure, or risk acceptance. |
| `EVID-019` | [AF-OWNER-001F Production Deployment Inputs Discovery](af-owner-001f-production-deployment-inputs-discovery.md) | SHA-256 `ebf641624d26384103cd1c7cb7d729af9178a2c7b18d5f6834cf535b5d2b0409` | Finds no complete verified production input; distinguishes local evidence, confirmed foundation direction, proposals, provider dependencies, missing information, and Owner decisions. Discovery only; no infrastructure access, benchmark, implementation, or approval. |

## 3. Requirement traceability and assessment

| Criterion | Source | Requirement | Evidence/result | Assessment |
|---|---|---|---|---|
| `CRIT-001` | ID-01 | Every employee has an individual PIN; shared store PINs are forbidden. | `EVID-004`, `EVID-001` | `PASS` for policy/design trace only; implementation `NOT_TESTED`. |
| `CRIT-002` | ID-04 | POS locks after two idle minutes and requires individual authentication again. | `EVID-004`, `EVID-001` | Design traces PIN reauthentication but the device/session boundary is absent; `NOT_TESTED`. |
| `CRIT-003` | ID-07 | Rate limiting and progressive delay apply; failures alone never permanently lock an account. | `EVID-004`, `EVID-001` | Candidate thresholds exist but are unapproved and unimplemented; `NOT_TESTED`, production blocker. |
| `CRIT-004` | ID-11 | Username, not email, is the login identifier. | `EVID-004`, `EVID-001` | Login flow reflects this; implementation `NOT_TESTED`. |
| `CRIT-005` | IDs 06/15 | Recovery and lifecycle states remain distinct and under approved authority. | `EVID-004`, `EVID-001` | Reset proposal is incomplete about session disposition and races; `NOT_TESTED`. |
| `CRIT-006` | ID-13 | PIN cannot imply Branch Manager/Owner authority or bypass Branch scope/MFA/step-up. | `EVID-004`, `EVID-001` | Explicitly denied by design; enforcement `NOT_TESTED`. |
| `CRIT-007` | SEC-03 / TD-CRYPTO-01 | Use a maintained adaptive salted password/PIN design with versioned parameters and upgrade. | `EVID-001`, `EVID-006`, `EVID-011` | Argon2id is a reasonable proposal, but no compatible dependency is selected or validated; `NOT_TESTED`. |
| `CRIT-008` | SEC-04 / NIST SP 800-63B-4 | Password minimum/maximum, spaces/Unicode, no composition/periodic rotation, and blocklist behavior. | `EVID-001`, `EVID-010` | Proposed 15-character minimum and at least 64 characters align; NFC and blocklist implementation/privacy remain unresolved; `NOT_TESTED`. |
| `CRIT-009` | RFC 9106 / OWASP | Unique library-generated salt, encoded algorithm/parameters, and calibrated work factors. | `EVID-001`, `EVID-010` | Proposed 128-bit salt and encoded metadata align. Actual library behavior, parameter units, tag, and randomness are `NOT_TESTED`. |
| `CRIT-010` | TD-CRYPTO-01 | Candidate password baseline `m=64 MiB`, `t=3`, `p=4`; PIN starts at `19 MiB`, `t=2`, `p=1`. | `EVID-001`, `EVID-010`, `EVID-011` | Both are guidance-supported candidates, not approved values. Target latency, memory concurrency, and denial resistance are unknown. |
| `CRIT-011` | TD §4.4 / OWASP pepper guidance | PIN uses versioned HMAC pepper stored separately, with safe rotation and compromise response. | `EVID-001`, `EVID-010` | Planned rotation is described; compromise response, custody, injection, key deletion, and forced reset procedure are incomplete; `NOT_TESTED`. |
| `CRIT-012` | TD §4.5 / review package | Verification and unknown-user handling resist timing/state enumeration. | `EVID-001`, `EVID-002` | Maintained hasher plus dummy verification and generic errors are proposed. Equivalent-work behavior and timing distributions are `NOT_TESTED`. |
| `CRIT-013` | TD §4.3 / §5.5 | Rehash and reset/replacement are atomic, revoke required sessions, and preserve audit. | `EVID-001` | Rehash locking is proposed; “required sessions,” reset token design, one-use race, and failure behavior remain unresolved; `NOT_TESTED`. |
| `CRIT-014` | Review package / protocol | Passwords, PINs, derived values, and digests do not leak through logs, audit, jobs, errors, or analytics. | `EVID-008` | Existing partial parameter filtering is helpful but insufficient for PIN and arbitrary string logs; `NOT_TESTED`. |
| `CRIT-015` | AF-SEC-002 / NIST terminology | A short PIN has a narrowly defined authentication role and cannot be mislabeled as a local activation secret or convenience-only value. | `EVID-001`, `EVID-010` | The server verifies the PIN, so it is a centrally verified authentication/reauthentication secret. Its exact ability to establish a Session is ambiguous; unresolved. |

## 4. Guidance comparison

- **Argon2id:** The preferred algorithm is supported by OWASP and RFC 9106. RFC 9106's second recommended option is the proposed `64 MiB`, `t=3`, `p=4`; OWASP's minimum includes the proposed PIN starting point `19 MiB`, `t=2`, `p=1`. Neither source removes the requirement to benchmark the exact library and concurrency profile.
- **Salts:** A unique 128-bit library-generated salt per credential is consistent with RFC 9106 and stronger than NIST's minimum salt-length requirement. The application should not accept caller-supplied salts.
- **Passwords:** The proposed 15-character single-factor minimum, support for at least 64 characters, no composition rule, no routine periodic change, spaces/Unicode support, rate limiting, and common/compromised-value blocklist align with NIST SP 800-63B-4. NFC must be selected and stable from first persistence if Unicode is accepted.
- **Pepper:** OWASP treats peppering as defense in depth and requires separate secret storage; compromise normally requires credential reset because the old pepper cannot safely remain trusted. NIST recommends an additional keyed operation with a key stored separately, preferably hardware-protected. This is guidance, not evidence that AFTER FOUR has a secret manager or approved key custody.
- **PIN terminology:** NIST distinguishes a centrally verified numeric password from a local activation secret. AFTER FOUR proposes server verification on a POS, so this PIN is a narrowly scoped authentication/reauthentication factor, not merely a convenience value and not a local activation secret. Six to eight decimal digits provide only about 20 to 27 bits of theoretical search space and require strict device/Branch binding and online throttling; offline resistance collapses if both database and pepper are compromised.
- **Alternatives:** scrypt remains a reasonable fallback if Argon2id cannot be supported. Bcrypt is operationally familiar in Rails but is not memory-hard and Rails documents a 72-byte limit; it conflicts with the proposed 1,024-byte maximum unless the password policy and migration design change. PBKDF2 has no demonstrated project requirement. Fast SHA-2 alone is unacceptable for password/PIN storage.

## 5. Threat and abuse-case assessment

| Threat ID | Abuse path and impact | Proposed control | Evidence and residual exposure |
|---|---|---|---|
| `THREAT-001` | Database theft enables offline password guessing. | Argon2id, unique salts, strong password policy, blocklist, rehash. | Design only; dependency and cost unverified. |
| `THREAT-002` | Database theft enables exhaustive guessing of short numeric PINs. | HMAC pepper before Argon2id, unique salt, separate key custody. | Database-only resistance is plausible; database-plus-pepper compromise exposes the small PIN space. |
| `THREAT-003` | Online PIN guessing across devices, sources, nodes, or alternate endpoints. | Account+device/source distributed limits, progressive delay, temporary lock. | No limiter, trusted source, device identity, endpoint inventory, thresholds, or tests exist. |
| `THREAT-004` | Stolen/shared PIN or shoulder surfing causes employee impersonation and false attribution. | Individual PIN, operator switch, POS lock, current User/Branch/device checks. | No POS/device implementation or monitoring exists; users can still voluntarily share memorized PINs. |
| `THREAT-005` | PIN is replayed for back-office, recovery, step-up, Owner, or cross-Branch actions. | Explicit scope denial and authorization intersection. | Design is clear, but no endpoint/policy enforcement exists. |
| `THREAT-006` | Unknown/disabled/wrong-secret timing or message differences enumerate accounts/state. | Generic public result, dummy Argon2 verification, equivalent rate limits. | No implementation or statistical timing evidence; exact dummy digest lifecycle is undefined. |
| `THREAT-007` | Oversized/Unicode-variant input causes denial or credential ambiguity. | 1,024-byte pre-hash limit; candidate NFC; ASCII-only PIN. | Input enforcement and stable normalization are unresolved and untested. |
| `THREAT-008` | Concurrent rehash/reset/login accepts a superseded credential or loses an upgrade. | Credential row lock, one-use reset verifier, atomic session revocation/audit. | No transaction implementation or independent-connection test exists. |
| `THREAT-009` | Password/PIN/digest enters request, structured log, audit, job, exception, or analytics. | Rails parameter filtering and explicit allowlists/redaction. | `pin` is not explicitly filtered; arbitrary log strings remain unsanitized; no Identity redaction corpus exists. |
| `THREAT-010` | Argon2 cost or parameter-unit error exhausts memory/CPU or silently weakens hashing. | Explicit profiles/units, minimum floor, production-like benchmark and capacity limits. | Library/API is unselected; no benchmark or concurrency budget exists. |
| `THREAT-011` | Pepper compromise or loss causes offline PIN cracking or mass lockout. | Versioned keys, planned overlap, forced reset on loss. | Compromise-specific invalidation/reset and incident procedure are absent. |

## 6. Findings and required remediation

| Finding ID | Severity | Finding and rationale | Required remediation and retest | Status / residual risk |
|---|---|---|---|---|
| `FIND-001` | Medium | **Argon2 dependency compatibility is unproven.** No Argon2 dependency is locked. Current `argon2` metadata permits Ruby >=2.6, but the maintained repository documentation only asserts testing on MRI 2.7/3.0. Native FFI/compiler and deployment-image behavior on Ruby 3.4.12 is unknown. | After separate authorization, select/pin a maintained version; build and run upstream vectors, round trips, malformed hashes, Bundler Audit, target OS/architecture images, Ruby 3.4.12/Rails 8.1.4.1, CI, and upgrade/advisory procedure. | `OPEN`; no residual risk accepted. |
| `FIND-002` | High | **The PIN trust role is ambiguous.** A server-verified 6–8 digit PIN is an authentication secret, not merely a convenience factor or local activation secret. The design does not state unambiguously whether it can create a new POS Session or only unlock/select an operator inside an already enrolled, authenticated terminal context. Standalone PIN authentication would expose a small search space. | Define PIN as POS-only operator authentication/reauthentication bound to an enrolled terminal and current Branch context; prohibit it from establishing a general/back-office Session or satisfying MFA/step-up/recovery. Specify the stronger device/bootstrap proof and fail-closed behavior. If standalone PIN login is retained, redesign secret strength and assurance. Execute route-inventory and replay tests. | `OPEN`; production blocker; no residual risk accepted. |
| `FIND-003` | High | **Planned pepper rotation and compromise response are conflated.** Keeping the prior PIN pepper for a bounded login-time migration is reasonable for planned rotation, but unsafe as the sole response to a known compromise. With database and pepper, the numeric PIN space is exhaustible. | Define separate planned-rotation and compromise procedures. Compromise must disable the affected key/version as soon as safely possible, revoke affected PIN authentication/sessions, force authorized PIN reset, notify/audit/monitor, and prohibit recovery of PINs from the database. Test mixed key versions, key loss, compromised-key cutoff, reset, and rollback. | `OPEN`; production blocker; no residual risk accepted. |
| `FIND-004` | Medium | **Current redaction is insufficient for future PIN handling.** Rails filters password-like names and several secrets but not explicit `pin`/PIN confirmation fields. The structured formatter emits arbitrary String messages unchanged. No current Identity route leaks a PIN because none exists, but the foundation would not prevent a future raw PIN log call. | Before any credential endpoint, extend explicit sensitive-key filtering, prohibit raw secret interpolation, use allowlisted audit/log fields, and add request/job/error/exception/structured-log redaction tests for password, PIN, HMAC input/output, digests, reset tokens, cookies, and headers. | `OPEN`; no current credential exposure observed; no residual risk accepted. |
| `FIND-005` | Medium | **Parameter units and resource budget are not bound to a selected library.** The proposal names RFC/OWASP values, while Ruby libraries may expose memory as exponents/profiles rather than KiB. A unit/profile error can weaken hashing or exhaust memory. `64 MiB` per verification also requires a concurrency budget. | Create a credential adapter with explicit algorithm/version and normalized `memory_kib`, iterations, parallelism, salt/tag lengths; verify encoded output. Benchmark latency/RSS/throughput and concurrent login/PIN attack load on production-like hardware; define admission control and minimum floor. | `OPEN`; no residual risk accepted. |
| `FIND-006` | High | **Short-PIN online defenses are only candidates.** No authoritative distributed limiter, enrolled-device identity, trusted source, endpoint inventory, progressive delay, temporary lock, or approved numeric thresholds exist. Hashing alone cannot protect 6–8 digit PINs from online guessing. | Owner must approve the format and numeric launch configuration after POS usability/DoS testing. Implement only after authorization; test exact edges, parallel attempts, multiple nodes/devices/sources, alternate paths, backend outage, temporary release, enumeration equivalence, and suspension/deactivation races. | `OPEN`; production blocker; no residual risk accepted. |
| `FIND-007` | Medium | **Credential replacement and reset session consequences are underspecified.** “Revokes required sessions” does not identify whether all sessions, other sessions, pre-auth transactions, POS unlock state, and recovery material are revoked for password/PIN change versus recovery reset. | Define a matrix for authenticated change, Owner-managed employee reset, suspected compromise, planned pepper rotation, and emergency recovery. Specify session rotation/revocation, old-credential cutoff, reset-token one-use semantics, audit/notification, atomicity, and race outcomes. | `OPEN`; no residual risk accepted. |
| `FIND-008` | Observation | **Password pepper is not selected.** The design peppers PINs but not passwords. OWASP treats peppering as optional defense in depth; NIST recommends a separately stored keyed operation. Adding it without mature secret custody can create mass lockout and operational risk. | Owner must explicitly select either salted Argon2id without password pepper, or a reviewed password-pepper design with generation, hardware/vault custody, versioning, rotation, compromise reset, backup/recovery, and availability behavior. Do not reuse the PIN pepper. | `OPEN`; decision pending; no residual risk accepted. |
| `FIND-009` | Medium | **Password normalization and blocklist behavior are unresolved.** NFC is optional in the proposal, and no private/offline blocklist source, update process, outage behavior, or context-specific matching policy is selected. Changing normalization after credentials exist creates migration ambiguity. | Select NFC or an explicitly justified alternative before first credential persistence; document character/byte counting and user guidance. Select a privacy-preserving blocklist/update design and test exact boundaries, Unicode variants, spaces, long input, context values, outage, and reset/change paths. | `OPEN`; no residual risk accepted. |

### 6.1 AF-OWNER-001A policy closure and finding traceability

IDs 21–28 close the eight requested policy choices. They do not close any finding because the required design detail, implementation, benchmark, and executed evidence remain absent. The original finding text and severity above remain the assessment record.

| Finding | Owner decision | Required design update | Required implementation evidence | Required test or benchmark | Remaining risk / current disposition |
|---|---|---|---|---|---|
| `FIND-001` Medium | ID-24 | Bind a selected maintained Argon2id dependency/version to Ruby 3.4.12, Rails 8.1.4.1, target images, advisory handling, and fallback/upgrade behavior. | Locked dependency, native build artifacts, target-platform CI, maintenance/advisory record, upgrade/runbook evidence. | Upstream vectors, round trips, malformed hashes, all target platforms, dependency audit, upgrade test. | Compatibility/native-code failure remains; `OPEN`. Policy gate is closed, dependency approval is not. |
| `FIND-002` High | IDs 21–22 | Define enrolled-POS bootstrap/device binding and make PIN proof incapable of creating a general-purpose Session or raising MFA/step-up/recovery/administrative assurance. | Route/policy/session implementation, enrolled-device records, Branch/User binding, audit evidence, complete endpoint inventory. | Positive POS authentication; general-session, back-office, MFA, step-up, recovery, privilege, device, and cross-Branch negative/replay tests. | Short-secret impersonation and scope bypass remain production blockers; `OPEN`. |
| `FIND-003` High | ID-27 | Separate planned rotation, confirmed compromise, loss/unavailability, emergency cutoff, reset, Session revocation, audit, and monitoring state transitions. | Secret-manager integration, version inventory, compromise/loss runbooks, cutoff/reset/revocation transaction and monitoring evidence. | Mixed-version rotation, compromised-key cutoff, unavailable/lost key, mass reset, concurrent verification/reset, rollback/failure injection. | Database-plus-pepper compromise and mass lockout remain production blockers; `OPEN`. |
| `FIND-004` Medium | Existing ID-12 plus IDs 21, 27, and 28 | Add explicit credential/PIN sensitive-field taxonomy, parameter filtering, allowlisted audit/log schemas, and prohibition on raw secret interpolation. | Filter/config snapshot and request, job, exception, audit, trace, analytics, and support-tool samples with synthetic secrets. | Automated redaction corpus for passwords, PINs, HMAC material, digests, reset tokens, cookies, and headers. | Future secret leakage remains possible until implemented and tested; `OPEN`. |
| `FIND-005` Medium | ID-24 | Define normalized parameter units/profile mapping, salt/tag lengths, minimum floor, admission/concurrency budget, and fail-closed configuration behavior. | Credential adapter/configuration and encoded-digest inspection tied to the selected library and production resource budget. | Representative latency/RSS/throughput benchmark plus concurrent attack/load and unit/profile misconfiguration tests. | Silent weakening or resource exhaustion remains; `OPEN`. |
| `FIND-006` High | IDs 22–23 | Specify exact account/device/source/global keys, thresholds, delay schedule, temporary-lock release, trusted source, alternate routes, distributed state, outage behavior, and monitoring. | Authoritative distributed limiter, device binding, route inventory, proxy/source configuration, capacity and operational runbook evidence. | Exact boundary, multi-process atomicity, device/source rotation, alternate-route, NAT/collateral DoS, outage, enumeration, and lifecycle-race tests. | Online guessing and attacker-triggered denial remain production blockers; `OPEN`. |
| `FIND-007` Medium | ID-28 | Define credential-event matrix for password change/reset, PIN change/reset, and pepper compromise, including Sessions, POS unlock, pre-auth, recovery material, audit/notification, transaction, rollback, and races. | Lifecycle transaction/state implementation, idempotency, failure handling, audit/outbox, session/recovery invalidation evidence. | Stale-credential, reset-token single-use, concurrent login/reset/change, partial failure, rollback, and notification/audit tests. | Stale access or recovery artifacts may survive until implemented; `OPEN`. |
| `FIND-008` Observation | ID-26 | Record salted Argon2id without password pepper as the MVP policy, its database-compromise trade-off, and the gate for any later independent pepper design. | Configuration/source inspection proving no accidental/shared password pepper and operational documentation of the chosen boundary. | Digest/storage/config inspection and future regression test preventing PIN-pepper reuse; later pepper tests only if separately approved. | Loss of pepper defense-in-depth remains documented but is not accepted as residual risk here; `OPEN` pending final design/evidence. |
| `FIND-009` Medium | ID-25 | Make NFC mandatory and consistent; define character/byte/request limits, blocklist source/update/privacy/outage behavior, migration rule, and Unicode guidance. | Shared normalization/validation service, blocklist integration/configuration, migration/version metadata, safe failure behavior. | Enrollment/login/reset parity; Unicode canonical equivalents/edge cases; exact limits; no truncation; blocklist update/outage/privacy tests. | Credential ambiguity, denial, or blocklist privacy/availability failure remains; `OPEN`. |

## 7. Tests and checks executed now

| Test ID | Command or inspection | Actual result | Security meaning and limitation |
|---|---|---|---|
| `TEST-001` | `RBENV_VERSION=3.4.12 rbenv exec ruby -v`; Bundler version/check/platform | Ruby 3.4.12 and Bundler 2.6.9 available through rbenv; locked dependencies satisfied; current platform supported by lock | Confirms foundation runtime only; does not prove Argon2 compatibility because Argon2 is absent. |
| `TEST-002` | Repository search for `argon2`, `bcrypt`, `scrypt`, credential/PIN/authentication code and schema | Only commented bcrypt scaffold text; no selected hasher or Identity implementation/table/spec | Confirms implementation evidence is absent. |
| `TEST-003` | `RBENV_VERSION=3.4.12 rbenv exec bundle exec rubocop` | 36 files inspected, 0 offenses; cache unavailable but scan completed | General style only; not credential security evidence. |
| `TEST-004` | `RBENV_VERSION=3.4.12 rbenv exec bundle exec brakeman --quiet --no-pager --exit-on-warn --exit-on-error` | Rails 8.1.4.1, Brakeman 8.1.0, 0 errors, 0 warnings | Static foundation scan only; no credential feature exists to analyze. |
| `TEST-005` | `RBENV_VERSION=3.4.12 rbenv exec bundle exec rspec` | Not executed successfully: PostgreSQL at `127.0.0.1:55432` refused connection; 0 examples, 6 load errors | Baseline suite result is unavailable in this assessment. No credential specs exist regardless. |
| `TEST-006` | `RBENV_VERSION=3.4.12 rbenv exec bundle exec bundler-audit check` | Not completed: advisory database could not be created under the sandboxed user data directory | No current advisory conclusion recorded. CI is configured to run `check --update`; this attempt is not a pass. |

No password/PIN positive, negative, boundary, concurrency, timing, benchmark, storage, or redaction test was executed because the relevant dependency and implementation do not exist.

## 8. Required future tests and expected outcomes

### Password

1. **Library compatibility/vectors:** selected pinned gem builds on every target image with Ruby 3.4.12; Argon2id vectors and encoded round trips pass; malformed/wrong-algorithm/version hashes fail closed.
2. **Calibration:** production-like host records latency, RSS, throughput, and concurrent attack load for candidate and floor profiles; selected values stay inside an approved resource budget without falling below the approved floor.
3. **Salt/storage:** repeated hashing of the same password produces different unique salts/digests; only encoded digest plus non-secret metadata persists; plaintext never reaches database, jobs, audit, logs, errors, or analytics.
4. **Input:** exact 15-character minimum, supported 64+ characters, 1,024-byte maximum and maximum-plus-one, spaces, paste, Unicode/NFC, null/empty, and blocklist cases behave according to the approved policy before expensive hashing.
5. **Verification/enumeration:** known-wrong, unknown, locked, suspended, deactivated, malformed-digest, and dependency-error paths use the approved generic contract and comparable work. Timing evidence uses repeated noisy-environment analysis, not a single CI assertion.
6. **Upgrade:** old parameters/algorithm verify then upgrade exactly once; concurrent successful logins do not lose or corrupt the stronger digest; failed verification never upgrades.
7. **Reset/replacement:** token is high entropy, purpose-bound, expiring, single-use under concurrency; old password fails immediately; approved sessions/pre-auth/recovery material are revoked atomically; audit/notification contains no secret.

### PIN

1. **Format/entropy:** only approved ASCII digits and exact length are accepted; leading zeros are preserved; oversized/non-ASCII/whitespace/null input fails before hashing.
2. **Individual accountability:** shared PIN setup is rejected; two employees with the same presented PIN receive distinct salted digests and remain separately attributable.
3. **Scope:** PIN succeeds only on an enrolled terminal for an active User with current effective Branch scope; it cannot create a general/back-office Session or satisfy MFA, step-up, recovery, assignment, delegation, or Owner operations.
4. **Hash/pepper:** HMAC domain separation and selected Argon2id profile are verified without persisting the HMAC result; wrong/missing/unknown pepper versions fail closed; planned rotation and compromise cutoff follow different approved flows.
5. **Online abuse:** exact account+device/source/global limits, progressive delay, `Retry-After`, temporary release, unknown/inactive equivalence, multiple nodes/devices/source rotation, and alternate routes cannot overspend the budget. Limiter outage issues no authentication proof.
6. **POS behavior:** exact two-minute lock, operator switch, stale Session, device/Branch replay, current assignment revalidation, and suspension/deactivation races produce the safe expected state and correct actor audit.
7. **Reset/compromise:** authorized reset invalidates the old PIN and affected sessions/unlock state; concurrent old-PIN verification loses; compromised pepper forces the approved population reset and key cutoff; no database recovery is possible.
8. **Redaction/manual negative:** synthetic PIN values are absent from request logs, structured messages, exceptions, audit, jobs, metrics, traces, and support tooling.

## 9. Missing evidence and blockers

- Selected and pinned Argon2 dependency; Ruby 3.4.12 and target-image build/test evidence.
- Explicit library parameter mapping, algorithm variant, salt/tag behavior, benchmark host profile, raw results, and concurrency/admission budget.
- Credential schema, constraints, digest metadata, transaction/locking implementation, and database inspection.
- Password NFC/input/blocklist decision and privacy-preserving blocklist implementation.
- Password-pepper decision; PIN pepper generation, custody, injection, versioning, planned rotation, compromise, backup/loss, and incident runbook.
- Exact PIN authentication role, length/format, enrolled-terminal bootstrap, device trust, Branch/session binding, and endpoint inventory.
- Approved password/PIN limiter thresholds, distributed state, trusted source, outage behavior, monitoring, and unlock/reset procedures.
- Generic response and dummy-work implementation; timing evidence.
- Credential change/reset session matrix, one-use recovery verifier, audit/notification transaction, and concurrency evidence.
- Explicit PIN/filter redaction configuration and complete log/audit/job/error/analytics tests.
- Running RSpec baseline with PostgreSQL available and all future credential-specific tests.

These blockers prevent `OWNER_REVIEW_COMPLETED`. AF-SEC-001 and AF-SEC-002 remain `OPEN`; no canonical checklist status changes are justified.

## 10. Owner decision closure and remaining approvals

AF-OWNER-001A closes all eight policy-level requests:

1. ID-21 closes the PIN role boundary.
2. ID-22 closes the 6–8 decimal-digit range and forbids four-digit PINs.
3. ID-23 mandates distributed online protections while leaving numeric/configuration values open.
4. ID-24 preserves Argon2id as preferred candidate and makes compatibility/maintenance/benchmark/capacity evidence a prerequisite to production selection.
5. ID-25 selects NFC, bounded input, no truncation, and common/compromised-password blocking while leaving exact limits and blocklist operations open.
6. ID-26 makes a separate password pepper optional for MVP and requires its trade-off to remain documented.
7. ID-27 separates PIN peppering and its planned-rotation, compromise, loss, cutoff, reset, revocation, audit, and monitoring procedures while leaving provider/custody open.
8. ID-28 fixes credential-change/reset consequences at policy level while leaving the exact event matrix and transaction design open.

AF-OWNER-001D records six additional scoped technical/validation directions:

1. ID-29 makes P64-4 the preferred password candidate for production-parity validation, not an approved production or PIN profile.
2. ID-30 requires container-scoped HashingAdmission, bounded waiting, and generic capacity-unavailable behavior without approving any number or Adapter.
3. ID-31 approves the resource-budget methodology without approving any numeric budget, reserve, headroom, or limit.
4. ID-32 requires explicit versioned `p_cost` and production-parity one/two/four-lane comparison without selecting production parallelism.
5. ID-33 approves bounded exhaustion behavior and prohibits unbounded queues, bypass, and cheaper-profile fallback without approving response or retry numbers.
6. ID-34 requires evidence-based revalidation before first production use and after material change; production use still requires a separate explicit Owner decision where applicable.

Still requiring explicit technical approval after evidence: exact rate-limit thresholds/delays/lock durations; enrolled-device and trusted-source mechanisms; production Argon2 dependency/profile/resource budget and numeric admission policy; password character/byte/request limits and blocklist source/update/outage behavior; PIN profile and PIN-pepper provider/custody/generation/overlap/runbooks; and the exact password/PIN change/reset/compromise Session and recovery-material matrix. No production dependency, parameter, provider, custodian, deployment configuration, implementation, or residual risk is approved.

## 11. Residual risks and assessment status

No residual risk is accepted in this record. Current residual exposure includes self-review bias, unapproved production dependency/native integration, unknown production cost, low PIN entropy, absence of online defenses/device binding, pepper compromise/loss, enumeration/timing differences, reset/rehash races, and secret leakage through future logging paths.

- Owner review status: `OWNER_REVIEW_IN_PROGRESS`
- Policy closure: 8 of 8 requested policies recorded as IDs 21–28
- Scoped Argon2 direction: 6 of 6 AF-OWNER-001D proposals recorded as IDs 29–34; no production parameter or implementation approval
- Finding disposition: 9 `OPEN`, including 3 High-severity production blockers; 0 resolved and 0 accepted as residual risk
- Acceptance criteria: policy and scoped decision trace are established; production-parity, implementation, operational, and adversarial criteria remain `NOT_TESTED`
- Independent verification: `NOT_PERFORMED`
- Legal review: `NOT_PERFORMED`; credential, device/source monitoring, and employment-related data questions remain outside this technical conclusion
- Production condition: password/PIN authentication must not enter production until the High findings and other production blockers are remediated and retested
- Completion date: `null`

This assessment does not authorize implementation, dependency installation, schema/API changes, ADR acceptance, or Milestone 2B.
