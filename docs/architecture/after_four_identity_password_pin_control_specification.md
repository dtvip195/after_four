# AFTER FOUR Password/PIN Technical Control Specification

**Record:** AF-OWNER-001B  
**Status:** Design only; IDs 29–34 confirm scoped Argon2 validation/admission direction, with no production or implementation approval  
**Date:** 2026-11-14  
**Authority:** Owner-confirmed policies ID-21 through ID-28 and scoped technical/validation directions ID-29 through ID-34; no implementation authorization  
**Review state:** AF-OWNER-001 remains `OWNER_REVIEW_IN_PROGRESS`; independent verification and legal review are `NOT_PERFORMED`  
**Related:** [AF-OWNER-001](security-reviews/owner-led/af-owner-001-password-pin-security.md) · [Identity Technical Design](after_four_identity_technical_design.md) · [Decision Register](after_four_identity_decision_register.md) · [Identity & Branch Authorization](after_four_identity_authorization.md) · [Threat Model](after_four_security_threat_model.md) · [Owner-Led Review Protocol](after_four_identity_owner_led_review_protocol.md) · [ADR-0006](adr/0006-authentication-session-topology.md) · [Testing Standards](../development/after_four_testing_standards.md)

## 1. Purpose and control status

This specification makes the password and PIN proposals precise enough for later implementation planning. AF-OWNER-001C.2/C.3 now provide isolated compatibility/capacity evidence, and IDs 29–34 approve the bounded candidate-validation and resource/admission direction described below. This document does not select or integrate a production cryptographic dependency, approve a production or PIN profile, approve numeric resource/admission values, add a schema or endpoint, close a finding, accept residual risk, or authorize Milestone 2B.

| Label | Meaning in this specification |
|---|---|
| `OWNER_CONFIRMED` | Exact policy or scoped technical/validation direction in Decision Register ID-21 through ID-34. |
| `TECHNICAL_PROPOSAL` | Reviewable behavior selected here, but not approved or implemented. |
| `CANDIDATE_PARAMETER` | A number or profile that must be benchmarked or usability/capacity reviewed and explicitly accepted. |
| `IMPLEMENTED_CONTROL` | Code/configuration exists and is traceable. No control in this document has this status. |
| `VERIFIED_CONTROL` | Executed evidence satisfies acceptance criteria. No control in this document has this status. |
| `UNRESOLVED_RISK` | Exposure or decision remains open; this is not residual-risk acceptance. |

IDs 01–28 remain unchanged. IDs 29–34 record the scoped approval of `ARGON-PROP-01` through `ARGON-PROP-06` on 2026-11-14. BA-01–BA-08 remain unresolved. The fifteen historical professional-review records remain unexecuted historical records. ADR-0006 remains Proposed.

## 2. Deep Module interfaces and common invariants

Controllers may parse and serialize, but never normalize or compare secrets, compute limits, establish device trust, or coordinate credential lifecycle writes.

| Module | Interface | Implementation hidden behind it | Primary test surface |
|---|---|---|---|
| Credential Protection | `enroll(kind:, subject:, presented_secret:, context:) -> CredentialResult`; `verify(kind:, credential:, presented_secret:, context:) -> VerificationResult`; `replace(command:) -> CredentialResult` | NFC, length/blocklist policy, salt generation, PIN keyed preprocessing, Argon2 profile/version, constant-time comparison, upgrade decision, redaction | Observable result, versioned stored metadata, upgrade/change effects, and absence of raw secrets |
| HashingAdmission | Internal deadline-bound execution Interface owned by Credential Protection; callers cannot acquire permits or invoke Argon2 directly | Container-wide capacity across all relevant Puma workers, bounded wait, permit release, generic capacity-unavailable outcome, and metrics | Exact admission boundary, cross-worker aggregate limit, exception/cancellation release, overload recovery, and no bypass or cheaper fallback |
| Authentication Defense | `evaluate(attempt_context:) -> DefenseDecision`; `record(outcome:)` | Atomic multi-dimensional counters, delays, temporary locks, source classification, global pressure, cleanup | Permit/delay/temporary-deny/outage behavior through a PostgreSQL Adapter and deterministic test Adapter |
| POS Device Trust | `authenticate(presented_proof:, request_context:) -> DeviceContext`; lifecycle commands use the Identity Lifecycle Module | Enrollment proof, key/version/status, Branch binding, challenge/replay protection, revocation | Trusted/rejected context, Branch and device status, replay and revocation outcomes |
| Password Policy | `evaluate(raw_bytes:, purpose:, policy_version:) -> PolicyResult` | UTF-8/NFC, length/resource bounds, blocklist snapshot, stable error reason | Same vectors and outcome for enrollment, change, reset, and upgrade |
| Identity Lifecycle | `execute(command:, actor:, idempotency_key:) -> LifecycleResult` | Authorization, row locks, credential/session/recovery/audit transaction, incident guards | Committed aggregate result or complete rollback/fail-closed guard |

Secret-store access is an external Seam and therefore uses an Adapter. A selected provider must have a production Adapter and a deterministic test Adapter. The application must not expose provider behavior through the Credential Protection interface.

Common invariants:

- Raw passwords, PINs, keyed-preprocessing results, digests, salts, peppers, device private credentials, and recovery/session tokens never enter logs, audit metadata, analytics, jobs, exception text, or client errors.
- Public authentication errors are generic. Internal reason codes are allowlisted and contain no raw identifier or secret.
- A caller cannot supply a salt, algorithm/profile, pepper version, device assurance, source classification, or authorization scope.
- Every stored credential carries kind, algorithm/profile version, normalization version where applicable, pepper version or explicit `none`, lifecycle status, and optimistic version metadata.
- Verification has a uniform result vocabulary: success, generic rejection, delayed, temporarily unavailable, or upgrade required/performed. It never reveals account, credential, lock, or device existence.
- Secret/digest/proof comparisons use maintained-library constant-time operations on fixed-length values. Unknown subjects that pass Authentication Defense receive the current dummy-profile verification; application code must not hand-roll byte comparisons. Statistical timing tests compare correct, wrong, unknown, disabled, wrong-device, and malformed cases without treating noisy equality as proof.
- An input/request bound is enforced before costly normalization, blocklist work, keyed preprocessing, or hashing. No secret is silently truncated.
- Required local state change and audit append share one PostgreSQL transaction. Session and recovery invalidation are local transactional writes under this design.

## 3. Workstream 1 — Argon2id benchmark and dependency protocol

### 3.1 Control record

| Attribute | Specification |
|---|---|
| Source | ID-24; ID-25 input bounds; ID-27 PIN pepper; ID-29–ID-34 scoped Argon2 directions; AF-OWNER-001 findings FIND-001, FIND-005, and FIND-008. |
| Threats | Offline guessing, weak/mis-mapped work factors, native-extension failure, capacity exhaustion, login denial of service, unsafe dependency abandonment. |
| Behavior | Argon2id remains the preferred algorithm candidate. P64-4 (`m_cost: 16`, `t_cost: 3`, `p_cost: 4`) is the Owner-confirmed preferred password candidate for production-parity validation only. Production use remains subject to this protocol, IDs 30–34, and a separate explicit Owner production decision. |
| Alternatives | scrypt is the fallback candidate; bcrypt is operationally familiar but not memory-hard and its input semantics conflict with the proposed long-password policy; PBKDF2 requires a demonstrated project constraint. Fast hashes are forbidden. |
| Failure | Any missing compatibility, correctness, capacity, maintenance, or reproducibility gate leaves the candidate unapproved. Authentication implementation must not silently downgrade. |
| Tests | Clean target-image install, known-answer/round-trip/malformed vectors, cold/warm latency, memory, concurrency, saturation, hostile-input, timing-class, and recovery-after-load runs. |
| Operations | Re-run on Ruby, gem/native library, compiler/image, CPU architecture, container limit, or concurrency changes and after material advisories. |
| Evidence | Locked dependency report, provenance/maintenance review, image build logs, vectors, benchmark artifact, raw samples, capacity analysis, and Owner review record. |
| Status | `OWNER_CONFIRMED`: P64-4 production-parity candidate and the admission/budget/parallelism/overload/revalidation directions in IDs 29–34. `UNRESOLVED_RISK`: production dependency/profile, PIN profile, numeric budgets/limits, Adapter, queue/deadline/retry details, implementation, and production use. |

### 3.2 Dependency and compatibility gate

Evaluate candidate releases without adding them to the application lockfile. Record:

1. Ruby 3.4.12 and Bundler 2.6.9 resolution on every target OS, CPU architecture, libc, and deployment-image variant.
2. Native-extension compile/install output from a clean image, runtime shared-library linkage, non-root execution, and repeatable image build.
3. Upstream known-answer vectors, create/verify round trips, wrong-secret behavior, malformed/oversized encoded hashes, and encoded-profile parsing.
4. Rails 8.1.4.1 process boot, fork/thread behavior, allocator/garbage-collection interaction, and clean shutdown under load.
5. Maintainer/release history, supported Ruby matrix, published security policy, advisory history, source/native-library provenance, signed/reproducible release information where available, transitive dependencies, license, and upgrade procedure.
6. Bundler Audit and other approved dependency scanning against the candidate lock artifact. A clean scan is time-bounded evidence, not proof of safety.

An unmaintained release, unexplained native binary, failed vector, unsupported target, or unavailable security response process rejects the candidate.

### 3.3 Candidate descriptor and unit mapping

Each run must serialize a machine-readable descriptor:

```text
algorithm=argon2id; version=<argon2-version>; library=<name/version>;
memory_kib=<integer>; time_cost=<integer>; parallelism=<integer>;
salt_bytes=<integer>; tag_bytes=<integer>; encoded_length=<integer>;
library_arguments=<exact call>; input_preprocessing=<password|pin-version>
```

The benchmark must prove the library's memory argument unit and rounding behavior from its documentation, encoded digest, and measured allocation. Never infer whether an argument means bytes, KiB, an exponent, or a preset name. Map candidate profiles to the descriptor before execution:

- Password comparison candidates include Owner-confirmed preferred validation candidate P64-4 (`64 MiB / t=3 / p=4`) and at least one lower-memory and one higher-cost alternative. Preferred validation status is not production-parameter approval.
- PIN comparison candidates include the existing OWASP-derived `19 MiB / t=2 / p=1` starting profile and alternatives justified by the separate keyed-preprocessing and short-secret threat.
- All listed profiles are `CANDIDATE_PARAMETER`; none is a production default.

Salts must be library-generated from a cryptographically secure source, at least 128 bits as the current proposal, unique per credential, and encoded with algorithm/profile metadata. Salt and tag sizes remain candidates until the library mapping is verified.

### 3.4 Reproducible benchmark protocol

The report identifies source revision, script digest, UTC time, environment/image digest, host/virtualization, CPU model and logical/physical cores, RAM/swap, OS/kernel/libc, Ruby/Bundler/compiler, gem/native-library versions, allocator, container CPU/memory limits, Rails process/worker/thread configuration, and background load. Production-like cgroup/container limits are mandatory; uncontrolled developer-laptop results are exploratory only.

For every candidate profile measure password and PIN create/verify separately, including correct, wrong, and dummy/unknown-subject verification. Use fixed published synthetic inputs at minimum, typical, and maximum candidate bounds; never use production credentials.

- Run isolated cold-process samples and warmed-process samples. Record warm-up count and exclude warm-up only by a predefined rule.
- Run enough repetitions to publish count, min/max, mean, median, p50/p95/p99 wall time, CPU time, peak resident memory, incremental resident memory, allocations/GC, errors, and operating-system kills.
- Test concurrency 1, 2, 4, and successively higher values until saturation or the container safety limit. At each level record throughput, queue time, service time, memory peak, CPU, swap/page pressure, errors, and recovery after load.
- Test mixed valid/invalid/unknown traffic and a bounded hostile-input workload. The Authentication Defense decision must occur before expensive hashing, while permitted unknown-subject requests still perform a maintained dummy verification.
- Repeat on every target architecture/image and at least three fresh processes. Preserve raw sample data and exact commands.

Under IDs 30–33, safe hashing concurrency is an explicit container-wide admission-control limit covering all relevant Puma workers and derived from the smallest memory, CPU, latency, and process-topology constraint after measured Rails baseline, runtime reserve, explicit safety headroom, PostgreSQL connections, health handling, and operational overhead. It is not the Puma thread count. Excess work queues only within a bounded deadline; beyond it, fail with a generic temporary-unavailable response. Never bypass admission or substitute a cheaper profile under load. The Adapter, queue size, deadline, response code, retry policy, resource numbers, and concurrency value remain unapproved.

### 3.5 Acceptance and reporting

A candidate is eligible for Owner review only when:

- all compatibility/correctness gates pass on every deployment target;
- encoded metadata round-trips and malformed/over-floor hashes are safely rejected;
- correct, wrong, and dummy paths use the intended profile without a material explainable timing-class leak;
- p95/p99 latency, peak memory, throughput, and safe concurrency fit explicit Owner-approved service/capacity budgets with documented reserve;
- saturation produces bounded queuing or safe rejection, no OOM/swap storm/crash, and timely recovery;
- denial-of-service modeling includes source/account/device/global defenses and admission control;
- the complete run is reproducible from committed future tooling and immutable environment/dependency manifests.

The numeric latency, capacity, reserve, headroom, admission, and traffic-model budgets are unresolved. ID-34 requires evidence-based revalidation before first production use and after material change. Until production-parity evidence and a separate explicit Owner production decision exist, production dependency/profile selection remains blocked.

## 4. Workstream 2 — Distributed PIN rate limiting

### 4.1 Control record

| Attribute | Specification |
|---|---|
| Source | ID-21–ID-23 and ID-27; FIND-002 and FIND-006. |
| Threats | Online guessing, low-entropy PIN spray, distributed/source rotation, device rotation, alternate-route bypass, enumeration, deliberate lockout, limiter race. |
| Behavior | Authentication Defense evaluates all applicable buckets atomically before hashing and records the generic outcome after verification. |
| Alternatives | Process memory is inconsistent across nodes; edge-only limiting lacks account/device semantics; permanent account lock enables denial of service and violates ID-23. PostgreSQL is the initial proposed authoritative store; a future store requires equivalent atomic/evidence behavior. |
| Failure | If authoritative account/device enforcement is unavailable or ambiguous, new PIN authentication fails closed with a generic temporary-unavailable result. Existing sessions remain governed by their own expiry/lock state. |
| Tests | Exact threshold edges, concurrent/multi-node updates, alternate routes, key rotation, source spoofing, lock release, outage/recovery, enumeration timing, capacity, and legitimate-user denial. |
| Operations | Bucket cleanup, capacity, latency, hot-key pressure, clock, replica/primary health, lock counts, and rejection anomalies are monitored. |
| Evidence | Multi-connection/multi-process race tests, capacity/failure injection, alternate-route inventory, real proxy-chain tests, dashboards/alerts, and audit samples. |
| Status | Control types are `OWNER_CONFIRMED`; all numbers and store sizing are `CANDIDATE_PARAMETER`. |

### 4.2 Dimensions and atomic decision

| Dimension | Key material | Purpose |
|---|---|---|
| Account + enrolled device | HMAC of internal User and Device UUIDs with a versioned limiter key | Primary PIN guessing/lock policy without exposing raw identifiers |
| Account | HMAC of internal User UUID | Detect rotation across enrolled devices |
| Device | HMAC of Device UUID | Detect account spray from one POS |
| Trusted source | HMAC of proxy-derived address/prefix classification | Detect distributed route abuse; never an identity proof |
| Route family | Canonical PIN-auth operation family | Prevent unlock/operator-switch/fallback aliases from escaping shared buckets |
| Global/system | Operation and environment | Admission pressure and incident cutoff; never replaces subject/device limits |

Unknown accounts use a stable, keyed synthetic account bucket derived from the normalized presented identifier without storing it. Key rotation supports bounded dual lookup for buckets without weakening decisions.

One primary-transaction operation uses database server time, locks/upserts every required bucket in deterministic order, removes expired window state, computes the maximum delay/lock, and reserves the attempt. Recording the result is idempotent by attempt ID. Counters never decrease because of a retry, concurrent request, node restart, or client clock. Temporary lock expiry is monotonic. A failed verification-record write emits an operational alert and keeps the conservative reserved failure.

### 4.3 Candidate launch schedules

These values are proposals for capacity/usability testing, not approved policy:

| Bucket | `CANDIDATE_PARAMETER` behavior |
|---|---|
| Account + device | Rolling 15-minute observation; progressive delay from failure 3; temporary 5-minute lock at failure 5 |
| Account across devices | Temporary 15-minute lock at 10 failures in 15 minutes |
| Device across accounts | Throttle at 20 failures in 5 minutes; incident signal at continued spray |
| Trusted source | Throttle at 30 failures in 5 minutes; proxy/NAT usability must be measured |
| Global | No fixed number until benchmark capacity and legitimate peak traffic are modeled; shed before hashing admission is exhausted |

Candidate progressive delays are 1 second at failure 3, 2 seconds at 4, then 4/8/16 seconds, capped at 30 seconds with server-selected jitter. The client cannot choose or bypass the delay. Successful verification may decay account+device failure state only under an approved rule; it never erases security evidence or unrelated spray buckets. Failed attempts alone never cause a permanent lock.

Lock release is automatic on expiry or through a separately authorized, audited security procedure. An administrator cannot mark an attempt successful, bypass the limiter, clear audit history, disclose whether an account exists, or unlock their own privileged account outside approved policy. Recovery and reset initiation/completion have separate limits and do not reset PIN-defense history merely because a reset was requested.

Every operation capable of verifying a PIN—including POS sign-in, operator switch, idle unlock, fallback, and any legacy alias—must call the same Module before verification. Route-inventory tests fail if any direct Credential Protection call is reachable without Authentication Defense.

Public delay/lock errors remain generic and response classes are indistinguishable for unknown, disabled, wrong-PIN, wrong-device, or out-of-scope subjects. Audit captures safe bucket dimension/version, outcome, delay class, request/correlation ID, Device/Branch when trusted, and source classification—not PIN, raw username, raw IP beyond approved privacy policy, or derived credential material.

Capacity trade-off: tighter buckets reduce guessing but increase deliberate lockout and shared-NAT false positives; looser buckets preserve operations but expose the 6–8 digit space. Benchmark-derived global admission, source as a signal rather than identity, layered buckets, short temporary locks, monitoring, and an audited recovery path are all required before numeric acceptance.

## 5. Workstream 3 — Enrolled POS device binding

### 5.1 Control record

| Attribute | Specification |
|---|---|
| Source | ID-04, ID-21–ID-23, ID-28; FIND-002 and FIND-006. |
| Threats | Device-ID spoofing, stolen PIN replay, cross-Branch use, cloned device secret, challenge replay, lost POS, proxy/source spoofing. |
| Behavior | A PIN is evaluated only inside a cryptographically authenticated, active enrolled-device context bound to one Organization and current Branch assignment. Device ID alone is a selector, never proof. |
| Alternatives | Bearer device secrets are simpler but replayable if copied; asymmetric proof limits server secret exposure but browser/platform support must be proven; hardware attestation may improve provenance but no vendor/mechanism is selected. |
| Failure | Missing/expired/replayed proof, revoked/replaced device, Branch mismatch, unavailable verifier, or ambiguous proxy chain rejects PIN authentication generically before hashing. |
| Tests | Enrollment/replacement/reassignment, proof mutation/replay/race, key-storage inspection, wrong scope, revocation/loss, proxy spoofing, Session binding, and PIN route denial. |
| Operations | Inventory, last safe activity, key age/version, Branch assignment, enrollment/revocation actor, compromise state, and anomalous proof failures are monitored. |
| Evidence | Platform compatibility, key-storage inspection, challenge/replay races, loss/revoke drill, Branch tests, proxy tests, and audit evidence. |
| Status | PIN scope is `OWNER_CONFIRMED`; proof mechanism, platform support, enrollment ceremony, and device record are `TECHNICAL_PROPOSAL` / unresolved. |

### 5.2 Lifecycle and verification contract

Proposed lifecycle: `pending_enrollment -> active -> suspended | revoked | replaced | retired`. Revoked/replaced/retired are terminal; re-enrollment creates a new identity and key. Branch reassignment is an authorized lifecycle command that revokes active device-bound sessions, changes assignment, rotates device proof, and audits old/new scope. It never silently rewrites historical Branch evidence.

Enrollment requires an active Owner using a recent approved step-up administrative ceremony, a one-use short-lived enrollment challenge, server-generated enrollment ID, and a key generated on the target device. No Branch Manager or delegate receives this security-administration authority. The preferred candidate is a non-exportable asymmetric private key with only its public key stored server-side. This remains unselected until actual POS platforms demonstrate secure persistence, backup/restore behavior, algorithm support, and proof APIs. A random bearer-secret design is an alternative only after its theft/replay/storage risks are explicitly reviewed. No hardware attestation is assumed.

For each PIN operation, POS Device Trust receives a device selector and proof over a server-issued one-use nonce plus protocol version, request method, canonical route family, body digest, Origin/Host, and device identity. The server verifies signature, challenge expiry/single use, active status, expected Organization/Branch, and request binding before returning `DeviceContext`. A transaction/unique constraint ensures only one concurrent challenge consumer succeeds. TLS remains mandatory; proof does not replace CSRF/session/origin controls.

Only after trusted DeviceContext exists may Authentication Defense and Credential Protection process a PIN. Successful PIN verification binds the employee User, Device, Branch, authentication method, and time to a POS operator context within the already trusted device session. It cannot create a general/back-office Session, satisfy MFA/step-up/recovery, widen Branch/capability scope, or outlive device/session revocation. The two-minute idle lock clears the employee operator context and requires a new device-bound PIN proof.

PIN input accepts exactly 6, 7, or 8 ASCII decimal digits. Leading zeroes are significant; Unicode digits, signs, separators, spaces, trimming, and silent padding/truncation are rejected. PIN values need not be unique, and neither uniqueness nor value-derived hints may be exposed.

Device loss or confirmed compromise immediately marks it revoked, rejects new proofs, revokes device-bound Sessions/operator contexts, invalidates unused challenges/enrollment material, alerts operations, and audits the action. Suspected compromise may suspend pending investigation. Replacement does not copy private credentials. Employee PIN reset does not restore a revoked device; device replacement does not preserve employee authentication.

The edge must remove client-supplied forwarding headers and provide the approved proxy chain. Rails derives source only from exact trusted hops. Source/IP is a defense/monitoring signal, never device proof or Branch authority.

Required negative tests include guessed/valid device ID without proof; copied proof; replayed/expired/concurrently consumed challenge; method/route/body/Origin/Host mutation; wrong Branch/Organization; revoked/replaced/lost device; stale session after reassignment; stolen PIN on unenrolled device; employee without effective Branch assignment; PIN attempts at back-office/MFA/recovery/administration routes; spoofed forwarding headers; secret/private-key logging; and verifier/outage behavior.

## 6. Workstream 4 — Password normalization and blocklist operations

### 6.1 Control record

| Attribute | Specification |
|---|---|
| Source | ID-24–ID-26 and ID-28; FIND-004, FIND-005, FIND-008, and FIND-009. |
| Threats | Unicode ambiguity, silent truncation, oversized-input denial, common/compromised password choice, blocklist privacy leak/outage, incompatible legacy upgrade. |
| Behavior | One versioned Password Policy pipeline applies to enrollment, authenticated change, reset completion, and credential upgrade. Login uses the stored credential's normalization version. |
| Alternatives | Raw-byte treatment avoids normalization migration but conflicts with ID-25; live third-party lookup may be fresher but creates privacy/availability leakage; local snapshots favor privacy/availability but require controlled updates. |
| Failure | Invalid UTF-8, oversized input, unavailable required initial snapshot, or policy rejection fails safely without hashing/persistence. Existing login is not blocked merely because a blocklist update source is unavailable. |
| Tests | Enrollment/change/reset/upgrade parity, Unicode and byte/code-point boundaries, no truncation, resource limits, blocklist match/update/signature/outage/privacy, errors, and legacy-version migration. |
| Operations | Signed/versioned snapshot acquisition, verification, staged rollout, freshness alerts, rollback to last valid snapshot, and update audit. |
| Evidence | Unicode vectors, boundary/resource tests, snapshot provenance/signature/update/outage tests, privacy inspection, and legacy migration tests. |
| Status | NFC/blocklist/no-truncation are `OWNER_CONFIRMED`; numeric bounds, blocklist source/cadence, and migration policy are `CANDIDATE_PARAMETER` / unresolved. |

### 6.2 Normative pipeline and candidates

1. Reject a request beyond a candidate 4 KiB credential-field/body allocation bound before parsing copies or normalization. This number is a `CANDIDATE_PARAMETER`.
2. Decode strict UTF-8; reject malformed sequences and forbidden transport null/control behavior without echoing input.
3. Normalize the complete password to Unicode NFC using a pinned Unicode/runtime behavior version.
4. Measure normalized Unicode scalar/code-point count for policy, plus encoded byte count for resource bounds. Grapheme count is not the security length unit.
5. Apply candidate minimum 15 code points for a sole-factor password; support at least 64; candidate maximum 1,024 UTF-8 bytes after NFC. These remain unapproved usability/benchmark parameters.
6. Never trim, case-fold, collapse spaces, remove characters, or truncate. Leading/trailing spaces are significant.
7. Compare the normalized complete value to the selected common/compromised blocklist using a local privacy-preserving lookup. Optional context-derived variants must be explicitly versioned and must not expose username/contact data.
8. Pass the exact normalized bytes to Credential Protection; store policy/normalization version, never the password.

The proposed operational choice is a signed, versioned local snapshot staged outside request handling. Alternatives are a locally built dataset or a privacy-preserving remote range query; no source is selected. Candidate cadence is daily retrieval with a freshness alert and reviewed emergency update, but cadence remains unapproved. Raw or hashed full passwords must never be sent to a provider. If update retrieval fails, continue with the last signature-valid, non-revoked snapshot and alert. If no valid snapshot has ever been installed, enrollment/change/reset fails closed; ordinary verification continues against stored credentials. Rollback may use only a previously valid non-revoked snapshot and is audited.

Enrollment/change/reset may state that a password is not permitted without saying whether it appeared in a particular breach or dataset. Login, recovery initiation, and public errors remain generic. Logs contain only policy version and safe reason class.

Legacy credentials record their original normalization version. Verification reproduces that exact legacy pipeline after the same resource bound. On success, migration to NFC cannot silently change the memorized secret: if legacy bytes differ from NFC, require an authenticated credential replacement; otherwise a normal rehash may write the new version atomically. Failed verification never upgrades.

Required vectors include composed/decomposed equivalents, multiple combining marks, compatibility characters that NFC does not fold, emoji and supplementary characters, non-Latin scripts, leading/trailing/interior spaces, empty input, invalid UTF-8, embedded null/control transport cases, exact min/max ±1 in both code points and bytes, normalization expansion near limits, blocklisted mixed Unicode, snapshot update/outage/signature failure, legacy equivalent/non-equivalent forms, and proof of no truncation.

## 7. Workstream 5 — PIN pepper lifecycle and incident runbooks

### 7.1 Control record

| Attribute | Specification |
|---|---|
| Source | ID-22, ID-24, ID-27, ID-28; FIND-003 and FIND-008. |
| Threats | Database-only offline PIN search, combined database/key compromise, lost key mass lockout, unsafe dual-read, secret-store outage, rollback to compromised key. |
| Behavior | PINs use a distinct versioned keyed preprocessing secret at an external Secret Store Seam before the separately tuned adaptive digest. Password pepper remains optional and absent unless separately reviewed. |
| Alternatives | No PIN pepper leaves the 6–8 digit space exposed after database theft; reversible PIN storage is forbidden; planned dual-read supports migration but is forbidden as the sole confirmed-compromise response. |
| Failure | Unknown key version, unavailable key, compromised/cut-off version, or metadata mismatch fails closed. No fallback omits keyed preprocessing or uses another environment's key. |
| Tests | Construction vectors, mixed versions, planned rotation, suspicion/compromise/loss, store outage/recovery, cutoff, reset/re-enrollment, Session revocation, rollback denial, audit, and reconciliation. |
| Operations | Key inventory, state, generation evidence, access audit, rotation/incident commands, credential population, reset progress, session revocation, and alerts. Provider/custodians remain unselected. |
| Evidence | Secret-store access/control evidence, mixed-version tests, outage/cutoff drills, reset/re-enrollment and revocation evidence, audit/alert samples, and post-incident record. |
| Status | Separation and distinct procedures are `OWNER_CONFIRMED`; provider, custody, exact cryptographic construction/key sizes, overlap, and cutoff SLO are unresolved proposals. |

### 7.2 Key states and credential metadata

Key metadata contains an opaque version, purpose `pos_pin_preprocessing`, environment, state, creation/activation/retirement timestamps, algorithm/construction version, and external secret reference. Key bytes never enter the database. Proposed states are `staged`, `current`, `verify_only`, `suspected`, `compromised`, `disabled`, and `destroyed`. A credential records pepper version and construction version; it cannot infer “current.”

The proposed construction is domain-separated HMAC over an unambiguous encoding of purpose/version, User UUID, and exact PIN, followed by Argon2id with its own random salt. Exact HMAC algorithm/key length and ordering require cryptographic implementation review and vectors; no provider is selected. Constant-time maintained-library operations are required.

### 7.3 Runbooks

| Event | Required proposed procedure and failure-safe behavior |
|---|---|
| Planned rotation | Owner authorizes change ticket and evidence baseline. Generate `staged` key in Secret Store, verify injection/health without logging, activate new `current`, move old to `verify_only`, write new credentials only with current. Successful old-version verification rehashes under lock to current. Inventory progress; after an explicitly approved overlap and zero/reconciled old population, disable then destroy old key. Rollback may return to the non-compromised old key only before irreversible migration/cutoff and with audit. |
| Confirmed compromise | Owner activates incident procedure. Mark version `compromised`, enable a global affected-version cutoff before relying on per-row migration, reject its verification, revoke affected POS/operator sessions, invalidate affected reset/enrollment material, issue authorized PIN resets/re-enrollment, monitor and audit. Never dual-read or roll back to the compromised key. Preserve forensic metadata, not key bytes. |
| Suspected compromise | Mark `suspected`, restrict access, preserve evidence, alert, inventory affected credentials/sessions, prepare new key and reset plan. Default is fail closed for affected PIN verification unless the Owner records a time-bounded incident decision under the review protocol; this document does not accept that risk. Escalate to confirmed or clear suspicion with evidence and audit. |
| Pepper loss | Mark unavailable/lost; do not reconstruct from database or substitute another key. Cut off affected version, revoke affected POS/operator sessions, require authorized PIN reset/re-enrollment under a new key, reconcile population, and document restoration evidence. |
| Secret-manager outage | New PIN verification/enrollment/change fails closed with generic temporary-unavailable. No indefinite process cache, environment fallback, or plaintext recovery file. Any bounded cache design requires separate threat/availability approval. Alert on access failures and recovery; verify version/integrity after restoration. |
| Emergency cutoff | An Owner-authorized, strongly authenticated/idempotent command disables one key version or all PIN verification, revokes relevant active contexts, creates mandatory audit and alert evidence, and is tested before production. Restoration cannot re-enable compromised material. |
| Reset/re-enrollment | Verify authorized reset state without old PIN, create a new credential only with current key, supersede old credential, invalidate reset material, revoke relevant sessions/contexts, and audit atomically. Owner never chooses or sees the employee PIN. |
| Session revocation | Revoke device/operator contexts authenticated with affected credential/version plus any pre-auth state. General sessions are revoked when the incident risk or credential matrix requires it; the exact proposal is in Section 8. Failure keeps global cutoff active. |
| Review | Record timeline, authorization, evidence, affected versions/population, access logs, findings, containment, reset/revocation completion, alerts, tests, unresolved exposure, and post-incident actions. Do not claim recovery until reconciliation passes. |

## 8. Workstream 6 — Credential change/reset transaction matrix

### 8.1 Control record

| Attribute | Specification |
|---|---|
| Source | ID-21, ID-27, and ID-28; ID-04/ID-15 lifecycle guards; FIND-003 and FIND-007. |
| Threats | Stale credential/recovery reuse, partial commit, concurrent replacement, reset race, privilege bypass, incomplete revocation, missing audit, unsafe incident batches. |
| Behavior | Identity Lifecycle serializes each User/credential change and commits credential, Session, recovery, and audit state atomically; global cutoff protects cross-User incident remediation. |
| Alternatives | Independent best-effort writes create stale access; distributed transactions add complexity without a current external Session store; deleting history destroys evidence. |
| Failure | Required local write/audit failure rolls back. Incident cutoff remains fail closed. External notification retries from outbox and never restores access. |
| Tests | Every matrix row needs success, denial, boundary, independent-connection race, injected failure/rollback, idempotent retry, stale-artifact denial, redaction, and audit-cardinality examples. |
| Operations | Reconciliation reports credential/session/recovery populations, stuck outbox, incident cutoff, retry result, and safe audit linkage. |
| Evidence | Transaction traces, second-connection visibility, failure injection, route/session inventory, audit/outbox samples, reconciliation, and Owner review of proposed effects. |
| Status | ID-28 outcomes are `OWNER_CONFIRMED`; exact effects below are `TECHNICAL_PROPOSAL`, unimplemented and unverified. |

### 8.2 Shared transaction rules

Identity Lifecycle accepts an idempotency key and request fingerprint, obtains the User and credential locks in deterministic order, rechecks actor/lifecycle/assurance/device/Branch guards under lock, and uses database server time. The credential replacement, version increment, recovery invalidation, local Session/operator-context revocation, and required Audit Append commit in one PostgreSQL transaction. Same key/same fingerprint returns the original result; same key/different fingerprint conflicts. Optimistic version mismatch returns a generic conflict and never retries with stale authorization.

External notification is a transactional outbox effect. Secret creation/activation happens before a command only through an explicit staged state; database commit never claims a key state that was not verified. Audit or required local invalidation failure rolls back. A security incident global cutoff is an independent fail-closed guard that remains active even if per-User remediation rolls back.

The session scopes below are `TECHNICAL_PROPOSAL` under ID-28 and require Owner/security evidence; they are not accepted policy.

### 8.3 Scenario matrix

| Scenario | Preconditions and authorization | Atomic state, session/recovery/audit effects | Concurrency, failure, retry, and required tests |
|---|---|---|---|
| Authenticated employee password change | Active User; current password plus required recent MFA/step-up; Password Policy passes. | Create new password credential and supersede old; invalidate password-reset/recovery challenges; rotate current general Session and revoke other general Sessions; revoke step-up grants; audit success. | User/credential lock; one concurrent change wins. Any digest, invalidation, revocation, or audit failure rolls back. Test wrong current secret, policy boundaries, stale version, two connections, rollback, old/new login, session scope, idempotency. |
| Password reset by Owner | Active authorized Owner with required MFA/step-up; target lifecycle allows recovery; Owner cannot set/see final password. | Initiation stores only one-use verifier and audit/outbox. Completion under lock creates password, consumes all relevant challenges, revokes all target Sessions and step-up/recovery material, audits. | Concurrent completion/expiry/suspension has one winner. No partial reset; duplicate completion returns prior result only for same command. Test generic initiation, token race/expiry, Owner self-target rules, rollback, notification, old credential rejection. |
| PIN change by employee | Active enrolled POS DeviceContext; active employee/User and Branch assignment; current PIN verified through limiter; no incident cutoff. | New current-key PIN credential supersedes old; invalidate PIN-reset/re-enrollment material; revoke all employee POS operator contexts/device-bound PIN pre-auth state, then require fresh PIN; general back-office Sessions remain unless risk signal requires incident response; audit. | Credential lock; concurrent change/reset one winner. Test device/Branch/PIN scope, limiter, key outage, revocation/audit rollback, stale contexts, no general-session authority. |
| PIN reset by Owner | Authorized Owner MFA/step-up; target eligible; Owner cannot choose/see PIN. | Create one-use PIN enrollment challenge; revoke existing POS operator contexts and PIN pre-auth state. Completion on enrolled device creates new PIN/current key, supersedes old, consumes challenges, repeats revocation, audits. | Reset vs employee change/suspension/key cutoff serialized. Test challenge race/expiry/device binding, old PIN denial, current-key metadata, rollback/idempotency. |
| Suspected credential compromise | Authenticated report or authorized security action with safe target evidence; no assumption that reporter is correct. | Mark affected credential restricted/suspected, revoke relevant Sessions/contexts and recovery material, require reset according to credential type, alert/audit. For suspected pepper, global version rule in Section 7 applies. | Repeat reports are idempotent. Revocation/audit failure keeps/sets fail-closed guard. Test false/duplicate report handling, active races, notification privacy, restriction before reset. |
| Confirmed pepper compromise | Owner-authorized incident; affected version identified. | Global cutoff first; mark version compromised; revoke affected POS/operator contexts and reset material; batch affected credentials to reset-required without deleting evidence; audit each batch and incident. | Cross-User atomicity is impossible: cutoff supplies immediate safety, idempotent bounded batches reconcile later. Test crash/restart, concurrent PIN attempt/reset, population reconciliation, no compromised-key rollback. |
| Pepper loss | Evidence key cannot be recovered; Owner incident authorization. | Same cutoff/revocation/reset-required population as compromise, but reason remains loss; new key staged for re-enrollment; audit/alert. | Never regenerate under the same version. Test outage-to-loss transition, restart, incomplete population, re-enrollment, old-version denial. |
| Suspension/deactivation during reset | Owner lifecycle action wins under User lock. | Suspension/deactivation revokes Sessions/contexts and every pending credential/recovery challenge. Reset completion cannot activate User or credential access; deactivation preserves history. | Reset completion and lifecycle command serialize; lifecycle state rechecked at commit. Test both lock orders and post-state; no stale token succeeds. |
| Concurrent credential changes | Both commands initially authorized against same version. | Exactly one replacement/version increment commits; loser observes conflict and cannot revoke/overwrite winner effects. | Deterministic locks and expected version. Test independent DB connections, same/different idempotency keys, retry with refreshed proof, audit cardinality. |
| Session revocation failure | Credential command requires listed revocations. | Because Session state is local, any required revocation write failure rolls back credential/recovery/audit transaction. During incident, independent cutoff remains active. | Retry same idempotency key only after dependency recovery. Test injected constraint/DB failure and prove old credential/state unchanged or cutoff denies. |
| Audit write failure | Every sensitive credential command requires Audit Append. | Whole local transaction rolls back; no credential, reset, recovery, or revocation partial state commits. Incident cutoff remains conservative. | Test insert failure and transaction visibility from second connection; alert without secrets; safe retry/idempotency. |
| Recovery-material invalidation failure | Change/reset has identified all affected challenge/factor material before commit. | Any required invalidation failure rolls back the replacement and revocations; no stale artifact may coexist with a committed change. | Lock relevant challenge rows/range and use restrictive state predicates. Test concurrently issued/consumed challenge, missing row, duplicate command, post-commit stale-token denial. |

Notifications are retried from the outbox after a safe commit and must not contain the credential, PIN, token, digest, or precise blocklist/incident secret. Notification delivery failure does not restore access; it alerts after the approved retry policy.

## 9. Cross-control test and evidence plan

Future implementation must start with failing RSpec examples at Module interfaces, use real PostgreSQL for persistence and concurrency, and use deterministic Adapters only at external Seams. Required suites include:

- unit/contract vectors for NFC, blocklist snapshot, digest encoding, keyed preprocessing, device proof, generic results, and redaction;
- request tests proving every PIN-capable route passes Device Trust and Authentication Defense and cannot satisfy general Session/MFA/step-up/recovery/administration;
- independent-connection tests for counters, locks, challenge consumption, change/reset races, cutoff, revocation, recovery invalidation, and audit rollback;
- multi-process load/failure tests for limiter capacity, hot buckets, server clock, database restart, hashing admission, secret-store outage, and recovery;
- deployment-image compatibility and benchmark artifacts from Section 3;
- manual lost-device, pepper rotation/compromise/loss, emergency cutoff, reset, alert, and reconciliation drills with evidence timestamps and reviewer identity.

No test may log a real secret or use production personal data. SimpleCov percentage does not replace negative, boundary, concurrency, or failure evidence.

## 10. Traceability and open findings

### 10.1 Owner-policy map

| Owner decision | Implemented by specification sections | Remaining evidence/decision |
|---|---|---|
| ID-21 | §§5, 8 | Device proof/platform, enrollment authority implementation, route/session negative evidence |
| ID-22 | §§4–5, 7–8 | Exact within-range UX policy and executed input/guessing evidence |
| ID-23 | §4 and §§5, 9 | Numeric thresholds/delays/locks, capacity, proxy, outage and alternate-route evidence |
| ID-24 | §3 and §§6–7 | Gem/profile, target-image compatibility, maintenance review, benchmarks and budgets |
| ID-25 | §6 | Numeric bounds, blocklist source/cadence/privacy and legacy migration evidence |
| ID-26 | §§3, 7 | MVP no-password-pepper trade-off remains an unresolved risk; no risk is accepted here |
| ID-27 | §7 and §8 | Provider/custody/construction, overlap/cutoff targets, executed runbooks |
| ID-28 | §8 | Owner acceptance of proposed session/recovery scopes and executed transaction/race evidence |
| ID-29 | §3 | P64-4 is the preferred production-parity password candidate; production and PIN profiles remain unapproved |
| ID-30 | §§2–3 | HashingAdmission is mandatory at container scope; Adapter and multi-worker evidence remain required |
| ID-31 | §3 | Resource-budget method is approved; every numeric input and result remains unapproved |
| ID-32 | §3 | Explicit versioned `p_cost` and P64 one/two/four-lane comparison are required; production parallelism remains unapproved |
| ID-33 | §§2–3 | Bounded wait and generic capacity-unavailable behavior are required; queue/deadline/retry/response numbers remain unapproved |
| ID-34 | §3 | Production revalidation is mandatory before first use and material change; production use requires separate Owner decision where applicable |

### 10.2 AF-OWNER-001 finding traceability

| Finding | Specification response | Status |
|---|---|---|
| FIND-001 | §3 dependency/compatibility gate and AF-OWNER-001C.2 | `OPEN`; isolated compatibility is demonstrated for recorded targets, but no production dependency/integration is selected or approved |
| FIND-002 | §5 enrolled-device proof and strict PIN scope | `OPEN`; no platform/control evidence |
| FIND-003 | §7 separates rotation, suspicion, compromise, loss, outage, and cutoff | `OPEN`; no provider/runbook execution |
| FIND-004 | §2 redaction invariant and §§4, 6, 7 safe evidence | `OPEN`; no implementation/redaction corpus |
| FIND-005 | §3 explicit unit descriptor/resource protocol and AF-OWNER-001C.3 | `OPEN`; isolated units/capacity are measured, but no Rails production-parity budget, numeric limit, or production profile is approved |
| FIND-006 | §4 distributed controls and candidates | `OPEN`; no thresholds/capacity evidence |
| FIND-007 | §8 exact proposed change/reset matrix | `OPEN`; no Owner acceptance or transaction tests |
| FIND-008 | §§3, 7 preserve optional password pepper and distinct PIN pepper | `OPEN`; no residual risk accepted |
| FIND-009 | §6 versioned NFC/blocklist pipeline | `OPEN`; bounds/source/outage/migration unverified |

## 11. Approval and completion boundary

Before implementation can be proposed, the Owner must explicitly review—but must not silently be deemed to have accepted—the following: candidate numeric password bounds; blocklist source/cadence; device proof and supported POS platforms; production Argon2 dependency/profile and every numeric resource/admission value; limiter thresholds/delays/lock periods/global admission; PIN profile and keyed-preprocessing construction/key operations; incident cutoff targets; and the Section 8 Session/recovery effects. IDs 29–34 settle only the direction recorded in their Decision Register boundaries.

Future evidence must demonstrate dependency and deployment compatibility, benchmarks/capacity, platform key storage and replay resistance, real proxy derivation, distributed limiter atomicity/outages, Unicode/blocklist privacy and migration, pepper runbook drills, transaction/race rollback, complete redaction, alerts/audit, and operational reconciliation.

This synchronization records IDs 29–34 but changes no application, schema, dependency, endpoint, frontend, CI, BA decision, review status, professional record, ADR status, or authorization. All nine AF-OWNER-001 findings remain open; no residual risk is accepted. Independent verification and legal review remain `NOT_PERFORMED`. Milestone 2B remains unauthorized.
