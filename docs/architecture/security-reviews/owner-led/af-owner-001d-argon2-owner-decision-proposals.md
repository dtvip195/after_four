---
review_preparation_id: AF-OWNER-001D
owner_review_id: AF-OWNER-001
document_status: OWNER_DECISION_RECORD
owner_approval_status: OWNER_APPROVED_WITH_SCOPE_LIMITATIONS
owner_approval_date: 2026-11-14
independent_verification: NOT_PERFORMED
legal_review: NOT_PERFORMED
---

# AF-OWNER-001D: Argon2 Candidate Owner Decision Proposals

**Assessment type:** Owner-led, non-independent decision preparation  
**Prepared:** 2026-11-14  
**Candidate implementation:** `argon2` Ruby gem `2.3.3`  
**Decision boundary:** Candidate password profile, hashing admission, and resource-budget policy only  
**Related evidence:** [AF-OWNER-001 Assessment](af-owner-001-password-pin-security.md) · [AF-OWNER-001B Control Specification](../../after_four_identity_password_pin_control_specification.md) · [AF-OWNER-001C.2 Compatibility Spike](af-owner-001c2-argon2id-compatibility-spike.md) · [AF-OWNER-001C.3 Capacity Validation](af-owner-001c3-argon2id-capacity-validation.md) · [Identity Decision Register](../../after_four_identity_decision_register.md) · [ADR-0006](../../adr/0006-authentication-session-topology.md)  
**Follow-on planning:** [AF-OWNER-001E Production-Parity Validation Plan](af-owner-001e-production-parity-validation-plan.md)  

This document began as decision preparation. On 2026-11-14 the Owner approved all six proposals within their explicit limitations; the canonical approvals are ID-29 through ID-34 in the [Identity Decision Register](../../after_four_identity_decision_register.md). The approval fixes candidate-validation and resource/admission direction only. No Argon2 dependency, production profile, PIN profile, numeric budget/limit, implementation, deployment topology, or residual risk is approved. AF-OWNER-001 findings remain `OPEN`, ADR-0006 remains Proposed, and Milestone 2B remains unauthorized.

## 1. Decision scope and policy trace

The package is constrained by Owner-confirmed IDs 21–28:

- ID-21 confines PIN use to employee authentication or reauthentication on an enrolled POS and forbids general Session, MFA, step-up, recovery, back-office, or administrative use.
- ID-22 fixes PIN input at 6–8 ASCII decimal digits; the short secret therefore depends on device binding, online defenses, and separate PIN-pepper controls.
- ID-23 requires distributed rate limits, progressive delay, temporary locks, monitoring, and no permanent lock caused only by failures. Numeric values remain unapproved.
- ID-24 keeps Argon2id as the preferred candidate while requiring compatibility, maintenance, benchmark, and capacity evidence before production selection.
- ID-25 requires NFC, bounded input, no silent truncation, and common/compromised-password blocking. Exact limits and operations remain open.
- ID-26 permits an MVP password design without a separate password pepper; no residual risk has been accepted.
- ID-27 requires a distinct PIN pepper and separate planned-rotation, compromise, loss, cutoff, reset, revocation, audit, and monitoring procedures. Provider and custody remain open.
- ID-28 requires credential replacement to invalidate the old credential, revoke affected Sessions and recovery material, and create audit evidence atomically. The exact event matrix remains open.

These proposals do not alter IDs 01–28. They address the resource and admission portions of AF-OWNER-001 `FIND-001` and `FIND-005`; they also constrain, but do not close, `FIND-002`, `FIND-003`, `FIND-006`, or `FIND-008`.

### 1.1 Evidence ledger

| Evidence | SHA-256 / version | What it establishes | What it does not establish |
|---|---|---|---|
| [AF-OWNER-001](af-owner-001-password-pin-security.md) | Owner review remains `OWNER_REVIEW_IN_PROGRESS` | Nine findings, their severity, missing evidence, and no accepted residual risk. | Production safety or finding closure. |
| [AF-OWNER-001B](../../after_four_identity_password_pin_control_specification.md) | `ab56b175b791259936b292157e02936ad841d4ee6e5fa8f7531298eb948a35f9` | Benchmark gates, explicit unit mapping, bounded admission requirement, and no cheaper overload fallback. | Executed controls or approved numbers. |
| [AF-OWNER-001C.2](af-owner-001c2-argon2id-compatibility-spike.md) | `05f793b722c4f85fc50ecc796be327ad52c209baf267dc7b9901bd57d5804f60` | `argon2` 2.3.3 builds and performs required functional operations on the tested Ruby 3.4.12 aarch64 Linux and arm64 macOS environments. | Rails integration, x86_64 compatibility, capacity, maintenance approval, or production approval. |
| [AF-OWNER-001C.3](af-owner-001c3-argon2id-capacity-validation.md) | `c4b816989e7db6f8f0ac5251cb6246f4ed453478f6c45cc9640491f611861402` | Isolated latency, throughput, cgroup memory, and CPU behavior in a 2-CPU, 1.5-GiB, no-swap aarch64 Linux container. | Rails baseline cost, production hardware behavior, HTTP queueing, real traffic, a denial-of-service guarantee, or a production limit. |
| [Identity Decision Register](../../after_four_identity_decision_register.md) | Pre-approval baseline `42d2ebcdba12363cc3f12c929ffd1e90551b1649b3b262c84fae65b5f9ecc318`; synchronized register `22618047ab50056bf6ee13328101f70651e723ccb1a41bcda245615c9aadc74d` | IDs 01–28 remained unchanged; IDs 29–34 now trace the scoped approval of this package. | Production parameters, implementation, executed controls, or finding closure. |

The raw C.3 benchmark artifacts were removed after their recorded SHA-256 values were captured, as specified by that experiment. This package uses only the measurements recorded in C.3 and does not reconstruct or invent samples.

## 2. Verified library semantics

C.2 demonstrated these exact semantics for `argon2` 2.3.3:

```ruby
options = { m_cost: 16, t_cost: 3, p_cost: 4 }
Argon2::Password.create(secret, options)
Argon2::Password.verify_password(secret, encoded_digest)
```

- Ruby `m_cost` is a base-2 exponent. Encoded/native memory is `2^m_cost` KiB; `m_cost: 16` means 65,536 KiB, or 64 MiB, not 16 KiB or 16 MiB.
- `t_cost` is the Argon2 time cost and `p_cost` is the native parallelism/lane count.
- The observed encoded output was Argon2id version 19 with a 16-byte salt and 32-byte output.
- The library generated different salts for repeated hashes and verified the correct secret while rejecting the wrong secret in the compatibility spike.
- Malformed or unsupported encodings either returned false or raised `Argon2::ArgonHashFail`. A future Credential Protection Adapter must translate both outcomes to a generic rejection without revealing parser or account state.

The Interface must use explicit named values and validate the resulting encoded metadata. Library defaults, preset names, and implicit units are not an acceptable configuration contract.

## 3. Candidate profile comparison

### 3.1 Evidence labels

- **Benchmark-tested:** the exact tuple was executed in C.3.
- **Partially benchmark-tested:** single-operation evidence exists, but the controlled concurrency matrix does not.
- **Untested interpolation:** the tuple or deployment behavior was not measured; it is an assumption requiring a new run.
- **Candidate recommendation:** a proposal for Owner consideration, not an approved production profile.

### 3.2 Password-profile options

All latency values below are pooled benchmark measurements. “Peak” is total cgroup memory, not incremental Argon2 memory. The environment was an isolated Ruby process—not Rails—with two CPUs, 1.5 GiB memory, and no swap.

| Option | Exact Ruby tuple | Memory / costs | Single create p50 / p95 / p99 | Single verify p50 / p95 / p99 | Verify throughput / total peak / CPU | Evidence and trade-off | Status |
|---|---:|---:|---:|---:|---:|---|---|
| P16 | `(14,2,1)` | 16 MiB, `t=2`, one lane | 30.4 / 33.8 / 58.3 ms | 30.4 / 33.0 / 34.4 ms | 32.49 ops/s; 55.6 MiB; 50.8% of two-CPU quota | Lowest tested cost and strongest measured throughput. Its 16 MiB is below the 19 MiB minimum comparison point already documented from OWASP guidance, and the exponent-only API cannot express exactly 19 MiB. It must not silently become the password or PIN production profile. | Benchmark-tested comparison; not recommended as the password candidate. |
| P32 | `(15,2,1)` | 32 MiB, `t=2`, one lane | 71.8 / 76.0 / 78.1 ms | 71.4 / 75.1 / 78.5 ms | 13.86 ops/s; 54.6 MiB; 50.9% | First tested power-of-two memory value above the documented 19 MiB starting point. Only single-operation evidence exists; its concurrency and Rails behavior are unknown. | Partially benchmark-tested fallback candidate; new concurrency evidence required. |
| P64-1 | `(16,2,1)` | 64 MiB, `t=2`, one lane | 147.6 / 152.0 / 156.0 ms | 147.4 / 150.1 / 152.1 ms | 6.78 ops/s; 86.8 MiB; 50.9% | Shows the CPU/latency effect of one lane at 64 MiB. It has lower time cost than the RFC-derived P64-4 proposal and no concurrency matrix. | Partially benchmark-tested sensitivity point, not the preferred profile. |
| P64-4 | `(16,3,4)` | 64 MiB, `t=3`, four lanes | 116.9 / 169.3 / 175.2 ms | 116.7 / 169.5 / 171.8 ms | 7.71 ops/s; 86.9 MiB; 100.4% | Matches the existing RFC-derived technical candidate and provides a materially higher work factor than P16. A single operation consumed the full two-CPU quota; additional application concurrency increased contention. | Benchmark-tested; preferred candidate for further password-profile review, not approved. |
| P128-4 | `(17,3,4)` | 128 MiB, `t=3`, four lanes | 278.0 / 288.4 / 292.3 ms | 276.8 / 287.6 / 289.6 ms | 3.78 ops/s; 151.1 MiB; 100.4% | Higher per-operation memory but substantially less throughput and greater memory/latency pressure. The current record provides no project-specific security requirement that justifies choosing it over P64-4. | Benchmark-tested high-cost comparison; not preferred initially. |

An apparently attractive tuple such as `(16,3,1)` or `(16,3,2)` is an **untested interpolation**. P64-1 does not predict it: both `t_cost` and `p_cost` differ from P64-4. It may be useful in a future CPU-policy benchmark, but this package assigns it no performance result.

### 3.3 Concurrency evidence that constrains the decision

The following are the C.3 concurrent create and verification measurements.

#### Concurrent create

| Profile | Concurrency | p50 / p95 / p99 ms | Median throughput | Total peak | Argon2 memory floor | CPU quota |
|---|---:|---:|---:|---:|---:|---:|
| P16 | 1 | 30.4 / 30.9 / 34.5 | 32.73 ops/s | 54.1 MiB | 16 MiB | 50.9% |
| P16 | 2 | 32.3 / 35.9 / 36.6 | 60.94 ops/s | 84.9 MiB | 32 MiB | 95.2% |
| P16 | 4 | 86.6 / 107.7 / 118.0 | 52.96 ops/s | 117.8 MiB | 64 MiB | 99.9% |
| P16 | 8 | 206.6 / 294.5 / 303.5 | 36.23 ops/s | 182.6 MiB | 128 MiB | 99.6% |
| P64-4 | 1 | 118.2 / 172.5 / 182.7 | 7.64 ops/s | 87.2 MiB | 64 MiB | 100.1% |
| P64-4 | 2 | 313.4 / 387.1 / 390.5 | 6.05 ops/s | 151.2 MiB | 128 MiB | 99.7% |
| P64-4 | 4 | 800.5 / 911.6 / 986.3 | 4.92 ops/s | 280.1 MiB | 256 MiB | 100.2% |
| P64-4 | 8 | 1,717.3 / 2,010.3 / 2,271.7 | 4.72 ops/s | 537.3 MiB | 512 MiB | 100.1% |
| P128-4 | 1 | 280.8 / 288.4 / 292.2 | 3.77 ops/s | 151.2 MiB | 128 MiB | 100.0% |
| P128-4 | 2 | 700.1 / 790.8 / 859.8 | 2.85 ops/s | 279.6 MiB | 256 MiB | 100.1% |
| P128-4 | 4 | 1,703.6 / 1,896.4 / 1,971.7 | 2.34 ops/s | 536.5 MiB | 512 MiB | 100.0% |
| P128-4 | 8 | 3,493.4 / 3,907.9 / 4,095.6 | 2.30 ops/s | 1,050.4 MiB | 1,024 MiB | 100.0% |

#### Concurrent verification

| Profile | Concurrency | p50 / p95 / p99 ms | Median throughput | Total peak | Argon2 memory floor | CPU quota |
|---|---:|---:|---:|---:|---:|---:|
| P16 | 1 | 30.4 / 33.8 / 64.0 | 32.23 ops/s | 55.2 MiB | 16 MiB | 51.0% |
| P16 | 2 | 32.3 / 36.0 / 45.0 | 60.05 ops/s | 87.5 MiB | 32 MiB | 97.2% |
| P16 | 4 | 85.5 / 96.9 / 99.9 | 54.55 ops/s | 122.2 MiB | 64 MiB | 102.0% |
| P16 | 8 | 204.0 / 295.7 / 306.2 | 37.74 ops/s | 190.2 MiB | 128 MiB | 101.2% |
| P64-4 | 1 | 116.8 / 171.0 / 174.2 | 7.71 ops/s | 87.4 MiB | 64 MiB | 99.9% |
| P64-4 | 2 | 312.0 / 385.3 / 394.4 | 6.07 ops/s | 151.4 MiB | 128 MiB | 100.1% |
| P64-4 | 4 | 804.9 / 991.1 / 1,076.3 | 4.85 ops/s | 280.0 MiB | 256 MiB | 100.0% |
| P64-4 | 8 | 1,700.0 / 1,973.0 / 2,095.0 | 4.66 ops/s | 537.3 MiB | 512 MiB | 100.1% |
| P128-4 | 1 | 276.6 / 292.9 / 320.5 | 3.77 ops/s | 151.3 MiB | 128 MiB | 99.7% |
| P128-4 | 2 | 701.9 / 785.1 / 807.8 | 2.83 ops/s | 279.7 MiB | 256 MiB | 100.2% |
| P128-4 | 4 | 1,699.4 / 1,882.2 / 1,926.6 | 2.34 ops/s | 536.8 MiB | 512 MiB | 100.2% |
| P128-4 | 8 | 3,409.3 / 3,799.5 / 4,105.1 | 2.34 ops/s | 1,050.7 MiB | 1,024 MiB | 100.0% |

P16 reached its measured throughput maximum at concurrency two and degraded at four and eight. P64-4 and P128-4 saturated the two-CPU quota at concurrency one; adding application concurrency reduced throughput while sharply increasing latency and memory. Eight P128-4 verifications used 1,050.7 MiB, but absence of OOM at that bounded load does not establish a safe ceiling. Argon2 memory alone would equal the 1.5-GiB container limit at 12 P128, 24 P64, or 96 P16 operations before Rails, native runtime, allocator, and operating overhead.

### 3.4 Preferred profile candidate

P64-4 is the preferred **password profile candidate for production-parity validation** because it matches the existing RFC-derived technical proposal, was functionally demonstrated, and has complete single/concurrency evidence in the isolated envelope. Its disadvantage is decisive: four lanes saturate the two-CPU quota during one operation. It is not eligible for production approval until the deployment envelope, latency budget, Rails baseline, local admission behavior, and production architecture are known and a production-parity run passes.

This recommendation does not select a PIN profile. ID-21–ID-23 and ID-27 make PIN security depend on enrolled-device proof, distinct keyed preprocessing, distributed online defenses, and a separately reviewed resource profile. C.3 did not benchmark the full PIN preprocessing or Authentication Defense path. P16 is not a safe automatic substitute merely because it is faster, and P32 lacks concurrency evidence.

## 4. Hashing admission-control options

### 4.1 Required Module and Interface

Hashing admission belongs inside the Credential Protection Module as an internal `HashingAdmission` Module. Its narrow Interface should execute an admitted operation within a deadline and return only an admitted result or generic capacity-unavailable result. It must own permit release even on exceptions, so callers cannot leak capacity permits. The Credential Protection Interface remains `enroll`, `verify`, and `replace`; controllers and domain callers must not acquire permits or invoke the Argon2 Adapter directly.

Authentication Defense must run before expensive credential work. It limits attacker budgets across account, device, trusted-source, route, and system dimensions. HashingAdmission then protects the local runtime from the traffic that is allowed to reach hashing. Neither Module replaces the other.

The alternatives and recommendation below are technical design inferences, not executed admission-control evidence. AF-OWNER-001B requires a bounded admission limit, while C.3 demonstrates the per-operation memory multiplication and CPU saturation that make the limit necessary. C.3 did not implement or compare semaphores, coordinators, queues, fairness, or failure recovery.

### 4.2 Architecture alternatives

| Option | Memory and CPU protection | Multiple Puma workers / instances | Failure and availability behavior | Complexity / enforcement scope | Assessment |
|---|---|---|---|---|---|
| A. Independent in-process bounds | Limits each Ruby process and is simple to fail closed. | Each worker receives its own limit; aggregate demand is `workers × local limit`. Across instances it is only local. | Process restart clears waiters; leaked permits must be prevented by the Module. A badly configured worker count can exceed the container budget. | Low; only process-local. | Acceptable only for a proved single-worker topology or when per-worker allocations are statically partitioned so their sum cannot exceed the container budget. |
| B. Authoritative per-container bound | Protects the actual cgroup memory/CPU ceiling shared by all web processes in one container. | Requires either one in-process authority for a single worker, a container-local coordinator for multiple workers, or deterministic per-worker partitions. Every instance independently protects its own hard ceiling. | Coordinator loss must fail closed for new hash work. Local failure does not make other instances unavailable. | Moderate; container-local, not deployment-global. | **Recommended protection scope.** The final Adapter depends on the approved Puma topology. |
| C. Deployment-wide distributed admission | Can impose one global operation count and coordinate all processes/instances. | Global by design if its state and atomicity are correct. | Adds a network/state dependency to login. Partition, latency, stale leases, and coordinator outage can deny authentication or oversubscribe capacity. It still needs local protection because one container can receive a skewed share. | High; global. | Not recommended as the primary memory guard. Distributed Authentication Defense remains necessary, but global hash permits have no current requirement. |
| D. No explicit admission; rely on Puma threads or rate limits | Does not bind Argon2 memory and confuses request concurrency with hashing capacity. | Worker/instance scaling multiplies unbounded demand. | CPU contention, long queues, OOM kill, and health-check starvation are plausible. | Superficially low; no reliable limit. | Rejected. C.3 demonstrates saturation before Puma's theoretical request capacity. |

### 4.3 Queueing alternatives

| Behavior | Benefit | Disadvantage | Assessment |
|---|---|---|---|
| Unbounded wait | Avoids immediate rejection during short bursts. | Converts overload into memory/latency growth, request timeouts, and possible enumeration differences. | Rejected. |
| Immediate generic rejection | Strong overload containment and predictable resource use. | Rejects legitimate short bursts that could have completed within the latency budget. | Valid fail-safe, but not preferred as the only behavior. |
| Bounded FIFO/fair wait, then generic rejection | Absorbs a small, measured burst while enforcing a hard deadline and hard queue bound. | Adds queue latency and needs fairness, cancellation, metrics, and timeout discipline. | **Recommended candidate**, with no numeric queue length or deadline selected. |
| Substitute a cheaper profile | Preserves throughput under pressure. | Weakens credential protection exactly during attack pressure and creates digest-policy ambiguity. | Prohibited. |

The recommended architecture is a mandatory per-container admission ceiling with a bounded, deadline-limited wait. If capacity is not obtained, the Interface returns a generic temporary-unavailable outcome that does not disclose account, credential, device, or limiter state. No request bypasses the ceiling, and no overload path selects a cheaper profile. A distributed Authentication Defense decision must precede admission. A deployment-global hashing semaphore is not required by current evidence and would not replace the local ceiling.

## 5. Production resource-budget requirements

### 5.1 Missing production inputs

No numeric concurrency policy can be approved until all of these are recorded:

1. hard CPU and memory quotas per Rails web container, CPU architecture/model, quota/burst semantics, swap/OOM policy, allocator, and whether jobs share the container;
2. desired/minimum/maximum instance count, autoscaling signals and lag, load-balancing behavior, and rolling-release surge/restart behavior;
3. Puma worker and thread counts, database pool relationship, worker preload/fork behavior, and whether an admission authority is shared across workers;
4. Rails non-hashing baseline and peak memory/CPU under representative middleware, sessions, authorization, database, logging, monitoring, health, and error traffic;
5. expected password versus POS-PIN arrival rates, legitimate peaks, hostile attempts remaining after Authentication Defense, and create/replace traffic;
6. end-to-end authentication p50/p95/p99 budgets, maximum queue wait, request timeout, permitted generic-rejection rate, and recovery objectives;
7. production secret manager and PIN keyed-preprocessing cost where PIN hashing is evaluated; and
8. alert thresholds and operational response for queue saturation, hash latency, CPU throttling, cgroup memory, rejects, OOM events, and bypass attempts.

The C.3 two-CPU/1.5-GiB/no-swap envelope is experiment metadata, not a production deployment specification.

### 5.2 Transparent memory and CPU calculation

For each production container and candidate profile, measure or approve:

```text
M_limit          = hard container memory limit
M_rails_peak     = representative peak with Rails booted, without active Argon2 work
M_runtime_reserve = allocator, native-library, operating-system/cgroup, health/recovery, and measurement variance reserve
M_safety_headroom = explicit Owner-approved operational headroom
M_hash_increment = conservative measured incremental peak per admitted operation

M_hash_budget = M_limit - M_rails_peak - M_runtime_reserve - M_safety_headroom
N_memory      = floor(M_hash_budget / M_hash_increment)
N_admit       <= min(N_memory, N_cpu, N_latency, N_process_topology)
```

`M_hash_increment` must come from a production-parity concurrent run and include allocator/high-water behavior; the configured Argon2 memory alone is only a lower bound. `N_cpu` is the largest admitted level that stays within CPU-throttling and throughput budgets. `N_latency` is the largest admitted level whose service plus bounded queue time satisfies the approved end-to-end budget. `N_process_topology` ensures the sum of all worker-local allocations cannot exceed the container authority.

The calculation must be repeated for create, correct verification, wrong verification, and dummy unknown-subject verification. The smallest safe result controls. Deployment capacity may be estimated as replicas multiplied by measured per-container capacity only after load distribution and autoscaling behavior are validated; that estimate does not relax any individual container ceiling. A shared host also needs a host-level budget for colocated containers and rollout surge.

## 6. Owner decision proposals

The records below preserve their proposal analysis and original approval wording. Each now carries the Owner's 2026-11-14 disposition and canonical Decision Register ID. Approval applies only within the stated limitations.

<a id="argon-prop-01"></a>

### ARGON-PROP-01 — Preferred password-profile candidate

**Owner disposition:** `OWNER_CONFIRMED` as ID-29 on 2026-11-14. P64-4 is approved only as the preferred password candidate for production-parity validation. No production Argon2 profile, PIN profile, implementation, or production use is approved.

**Recommendation:** Advance P64-4 to production-parity validation as the preferred password candidate. Keep P16, P32, P64-1, and P128-4 as comparison evidence. Do not designate a PIN profile in this decision.

**Alternatives:** P16 offers the best throughput but falls below the documented 19-MiB comparison floor; P32 is the next power-of-two value above that floor but lacks concurrency data; P64-1 has one-lane single-operation evidence but a lower time cost; P128-4 imposes materially higher memory and latency without a documented project need.

**Benefits / disadvantages:** P64-4 follows the existing RFC-derived proposal and has the fullest evidence. It consumes all of a two-CPU quota at one operation and therefore creates significant availability and latency pressure.

**Security consequences:** Advancing a candidate preserves an evidence-based memory-hard design; treating it as approved prematurely could cause denial of service or force an unsafe later downgrade. This decision does not address online PIN guessing or pepper compromise.

**Operational consequences:** Production-parity staging must reserve CPU/memory, enforce admission, and measure Rails plus Argon2. Four native lanes may be unsuitable for the eventual quota.

**Evidence required before implementation:** Approved deployment envelope and SLOs; production-parity Rails/Puma benchmark; correct/wrong/dummy equivalence; encoded-metadata/floor validation; target-architecture builds; maintenance/advisory review; and approval of the resulting resource budget. Implementation remains separately unauthorized.

**Exact approval wording:**

> I approve P64-4—`argon2` 2.3.3 Argon2id v19 with Ruby options `m_cost: 16`, `t_cost: 3`, and `p_cost: 4`, encoding 65,536 KiB of memory—as AFTER FOUR's preferred password-profile candidate for production-parity validation only. I do not approve it as a production parameter, do not approve a PIN profile, and do not authorize implementation.

<a id="argon-prop-02"></a>

### ARGON-PROP-02 — Hashing admission architecture

**Owner disposition:** `OWNER_CONFIRMED` as ID-30 on 2026-11-14. Mandatory container-scoped HashingAdmission, bounded deadline-limited waiting, and generic capacity-unavailable behavior are approved. No Adapter, queue/deadline number, concurrency/admission limit, or resource budget is approved.

**Recommendation:** Require a deep HashingAdmission Module inside Credential Protection, with an authoritative per-container ceiling and bounded wait. For one Puma worker the Adapter may be in-process; multiple workers require a container-shared authority or deterministic worker partitions whose sum cannot exceed the container budget. Retain distributed Authentication Defense before hashing; do not require a deployment-global hash semaphore.

**Alternatives:** Independent per-process limits, global distributed admission, or no admission. The first can multiply demand, the second adds a fragile network dependency and still needs local protection, and the third is unsafe.

**Benefits / disadvantages:** The proposal aligns enforcement with the container resource ceiling and scales independently by instance. It requires careful multi-worker configuration and a fail-closed Adapter.

**Security consequences:** It reduces OOM/CPU-exhaustion exposure without weakening the hash under load. It is not a denial-of-service proof and does not replace account/device/source limits.

**Operational consequences:** Permit use, wait time, rejection, leaks, CPU throttling, and memory must be observable. Coordinator loss rejects new hashing generically while unrelated health/operations retain reserved capacity.

**Evidence required before implementation:** Approved Puma topology; selected Adapter design; concurrency/failure tests across workers; cancellation/exception permit-release tests; overload recovery; fairness and queue bounds; and proof that direct Argon2 calls cannot bypass the Module.

**Exact approval wording:**

> I approve a mandatory per-container HashingAdmission Module within Credential Protection. It must enforce the container-wide hashing budget across all Puma workers, allow only bounded deadline-limited waiting, fail new hashing generically when capacity is unavailable, and never substitute a cheaper profile. Distributed Authentication Defense must run before hashing. I do not yet approve an Adapter, queue size, deadline, or concurrency number.

<a id="argon-prop-03"></a>

### ARGON-PROP-03 — Memory budget and concurrency policy

**Owner disposition:** `OWNER_CONFIRMED` as ID-31 on 2026-11-14. The resource-budget methodology is approved. No numeric budget, reserve, headroom, concurrency, or admission value is approved.

**Recommendation:** Approve the calculation in section 5.2 as the required policy and defer all numbers until the missing production inputs and production-parity measurements exist.

**Alternatives:** Derive a limit from Argon2 memory alone, reuse the C.3 1.5-GiB container, or equate the limit with Puma threads. Each omits Rails/runtime demand and can oversubscribe memory.

**Benefits / disadvantages:** The transparent formula makes reserve and risk choices visible. It delays a numeric answer until deployment and traffic data exist.

**Security consequences:** Conservative budgeting helps preserve authentication and health availability during attack pressure. An excessive limit risks OOM; an overly small one creates avoidable denial of service.

**Operational consequences:** Each image/runtime/topology needs baseline measurement and an explicit safety headroom approved by the Owner. Worker allocations must sum to the per-container limit.

**Evidence required before implementation:** Every input in section 5.1; measured incremental peaks under concurrent Rails load; create/verify/wrong/dummy results; rollout and restart tests; and an alert/runbook review.

**Exact approval wording:**

> I approve the AF-OWNER-001D resource-budget method: admitted hashing concurrency must be no greater than the smallest memory-, CPU-, latency-, and process-topology limit after measured Rails baseline, runtime reserve, and explicit safety headroom are deducted. I do not approve a numeric memory reserve, headroom, or concurrency limit until production-parity evidence supplies every required input.

<a id="argon-prop-04"></a>

### ARGON-PROP-04 — CPU parallelism policy

**Owner disposition:** `OWNER_CONFIRMED` as ID-32 on 2026-11-14. Explicit versioned `p_cost` and production-parity comparison of one, two, and four lanes are approved. No production `p_cost` or production profile is approved.

**Recommendation:** Configure `p_cost` explicitly and select it only after comparing the preferred candidate with measured one- and two-lane alternatives at the same memory and time cost on the production CPU quota. Retain P64-4 as the current candidate, not the production answer.

**Alternatives:** Keep four lanes without revalidation, use one lane based on P64-1, or accept the library default. P64-1 changes both time and parallelism, so it cannot prove `(16,3,1)` behavior; implicit defaults can drift.

**Benefits / disadvantages:** Explicit production-parity comparison can balance per-operation latency against whole-container throughput. It requires additional benchmark combinations and may change the preferred tuple.

**Security consequences:** Lowering parallelism without holding and validating the remaining work factors could silently change cost; excessive parallelism can make CPU exhaustion easier. The encoded profile must remain versioned and subject to the approved floor.

**Operational consequences:** CPU quotas, throttling, architecture, worker count, and authentication SLO drive the decision. Rehash-on-success must handle a later profile version without a thundering herd.

**Evidence required before implementation:** P64 `(16,3,1)`, `(16,3,2)`, and `(16,3,4)` production-parity comparisons; per-operation CPU time; whole-container throughput; p50/p95/p99; throttling; memory; and mixed normal/hostile traffic.

**Exact approval wording:**

> I approve an explicit, versioned Argon2 `p_cost` policy and reject implicit library defaults. Before production parameter approval, AFTER FOUR must compare one-, two-, and four-lane variants at the same candidate memory and time cost under the intended CPU quota and Rails/Puma topology. No CPU parallelism value is approved by this decision.

<a id="argon-prop-05"></a>

### ARGON-PROP-05 — Behavior when hashing capacity is exhausted

**Owner disposition:** `OWNER_CONFIRMED` as ID-33 on 2026-11-14. Bounded deadline-limited waiting followed by generic temporary-unavailable behavior is approved; unbounded queues, admission bypass, and cheaper-profile fallback are prohibited. No queue/deadline/retry/response-code/rejection-budget number is approved.

**Recommendation:** Permit only a bounded, fair wait within an approved request deadline; after that, return a generic temporary-unavailable result. Apply Authentication Defense before admission, preserve indistinguishable public behavior, and never downgrade the hash or create an unbounded queue.

**Alternatives:** Immediate rejection, unbounded waiting, or cheaper fallback. Immediate rejection remains a valid fail-safe but loses manageable bursts; the other two are rejected.

**Benefits / disadvantages:** Bounded waiting improves short-burst availability while preserving hard resource bounds. It adds queue time, cancellation handling, and monitoring requirements.

**Security consequences:** Generic handling limits account/state enumeration and protects hash strength under load. Attackers may still consume allowed queue/admission capacity, so distributed defenses and operational cutoff remain essential.

**Operational consequences:** Queue depth, wait distribution, expiry, rejection, cancellation, and recovery require metrics and alerts. The response contract and optional retry guidance must not reveal subject state.

**Evidence required before implementation:** Approved end-to-end timeout and wait budget; fairness/cancellation tests; exact-boundary concurrency tests; unknown/wrong/disabled equivalence; sustained-overload recovery; and proof that health/readiness and existing Sessions retain required capacity.

**Exact approval wording:**

> I approve bounded, deadline-limited waiting for hashing admission followed by a generic temporary-unavailable outcome when capacity remains exhausted. Unbounded queues, admission bypass, and cheaper hash fallback are prohibited. I do not yet approve a queue length, wait duration, response code, retry interval, or rejection budget.

<a id="argon-prop-06"></a>

### ARGON-PROP-06 — Mandatory production revalidation

**Owner disposition:** `OWNER_CONFIRMED` as ID-34 on 2026-11-14. Evidence-based revalidation before first production use and after material change is approved. Revalidation does not itself approve production use; a separate explicit Owner production decision remains required where applicable.

**Recommendation:** Require revalidation before first production approval and whenever a material dependency, runtime, resource, topology, traffic, SLO, or security condition changes.

**Alternatives:** One-time validation or alert-only review. Both allow evidence to become stale after changes that directly affect native execution or capacity.

**Benefits / disadvantages:** Keeps the decision tied to the operating environment. It adds release gates and benchmark maintenance.

**Security consequences:** Reduces silent weakening, native incompatibility, and capacity regressions. It cannot provide independent verification because the Owner remains the reviewer.

**Operational consequences:** Benchmark artifacts, immutable environment descriptors, results, approvals, and rollback criteria become release evidence. Emergency security updates need a bounded expedited path followed by full revalidation.

**Evidence required before implementation:** A reproducible production-parity protocol, stored raw artifacts, comparison thresholds, named Owner approval, rollback/runbook criteria, and CI/release integration design—without implementing them in this milestone.

**Exact approval wording:**

> I approve mandatory Argon2 production revalidation before first use and after any material change to Ruby, the `argon2`/FFI/native dependency chain, OS/libc/compiler/image, CPU architecture or quota, memory/swap/OOM policy, Argon2 profile, Rails/Puma topology, instance/autoscaling or rollout behavior, Rails baseline, authentication traffic or SLO, admission design, or relevant security guidance/advisory. Material observed latency, throttling, memory, error, or saturation regressions also trigger revalidation. This decision does not approve production use.

## 7. Required next evidence sequence

1. Preserve IDs 29–34 as scoped direction; do not infer production or implementation approval from them.
2. Use [AF-OWNER-001E](af-owner-001e-production-parity-validation-plan.md) to record the production deployment inputs without treating the C.3 container as production; the plan itself executes no benchmark.
3. Extend the isolated benchmark matrix with P32 concurrency and P64 `(16,3,1)` / `(16,3,2)` sensitivity profiles if they remain candidates.
4. Run the shortlisted profiles with Rails booted in the intended image, architecture, cgroup quotas, Puma topology, database/session/logging path, and representative non-hashing load.
5. Calculate the budget using the smallest measured create/verify/wrong/dummy capacity and explicitly proposed headroom.
6. Prepare a separate Owner production-parameter review. Do not infer production approval from these scoped decisions or from successful staging results.

Implementation, dependency changes, database/schema changes, endpoints, and Milestone 2B remain outside this sequence until separately authorized.

## 8. Open findings and governance confirmation

- AF-OWNER-001 `FIND-001` through `FIND-009` remain `OPEN`; none is resolved or accepted as residual risk.
- Compatibility is demonstrated only for C.2's tested environments. Capacity evidence is sufficient only for this candidate review.
- The production deployment envelope, Rails baseline, traffic model, SLOs, queue deadline, reserve, numeric concurrency, PIN profile, and PIN-preprocessing capacity remain unknown.
- Independent verification remains `NOT_PERFORMED`; legal review remains `NOT_PERFORMED`.
- IDs 01–28 are unchanged. IDs 29–34 record only the six scoped approvals in this document. BA-01–BA-08 are unaffected and unresolved.
- ADR-0006 remains Proposed. Milestone 2B remains unauthorized.
- This document makes no claim that AFTER FOUR is secure, denial-of-service resistant, production-ready, or legally compliant.

