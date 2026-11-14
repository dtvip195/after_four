---
evidence_id: AF-OWNER-001C.3
owner_review_id: AF-OWNER-001
evidence_status: COMPLETED
capacity_status: SUFFICIENT_FOR_OWNER_CANDIDATE_REVIEW
independent_verification: NOT_PERFORMED
legal_review: NOT_PERFORMED
---

# AF-OWNER-001C.3: Argon2id Capacity Validation

**Assessment type:** Isolated Owner-led, non-independent capacity experiment  
**Protocol frozen:** 2026-11-14, before benchmark execution  
**Execution completed:** 2026-11-14  
**Candidate:** `argon2` Ruby gem `2.3.3`  
**Scope:** Bounded resource and concurrency evidence only; no application integration or production parameter selection  
**Related:** [AF-OWNER-001C.2 Compatibility Spike](af-owner-001c2-argon2id-compatibility-spike.md) · [AF-OWNER-001 Assessment](af-owner-001-password-pin-security.md) · [Password/PIN Control Specification](../../after_four_identity_password_pin_control_specification.md) · [Identity Technical Design](../../after_four_identity_technical_design.md) · [ADR-0006](../../adr/0006-authentication-session-topology.md)

This experiment does not approve a gem, profile, resource budget, concurrency limit, deployment topology, or denial-of-service claim. It changes no Owner decision or finding, accepts no residual risk, leaves ADR-0006 Proposed, and does not authorize Milestone 2B.

## 1. Question and evidence boundary

The experiment asks how `argon2` 2.3.3 behaves under bounded create and verification load in AFTER FOUR's demonstrated Ruby 3.4.12 aarch64 Linux development image. It measures latency, throughput, cgroup memory, and cgroup CPU use under a declared resource quota.

It does not model HTTP parsing, Rails middleware, Active Record, PostgreSQL, logging, rate limiting, queueing, session work, background jobs, multi-container deployment, hostile distributed traffic, or production hardware. Results are local evidence, not universal capacity.

## 2. Protocol fixed before execution

### 2.1 Runtime and safety envelope

The benchmark uses local image `backend-backend:latest`, built from `ruby:3.4.12-bookworm`. Each run uses a fresh container with:

- `--cpus=2` (two-CPU CFS quota);
- `--memory=1536m` and `--memory-swap=1536m` (1.5 GiB hard memory limit with no additional swap allowance);
- `--pids-limit=256`;
- `--network=none` during measurement;
- only the isolated spike directory mounted; no application source or database connection;
- no more than eight concurrent Argon2 operations.

Docker Desktop exposes 8 CPUs and 16,746,086,400 bytes to its Linux VM. The host is an Apple M1 with 8 logical/physical cores and 17,179,869,184 bytes RAM. These host facts contextualize the result; the per-container limits are the benchmark boundary.

Stop a run and do not increase load if any operation errors, the cgroup reports an OOM event, the process exits nonzero, or peak cgroup memory reaches 90% of the 1.5 GiB limit. Eight concurrent operations is the planned ceiling even if no stop condition occurs.

### 2.2 Parameter matrix

`argon2` uses a base-2 exponent for its Ruby `m_cost`; encoded/native memory is `2^m_cost` KiB. Every number below is an unapproved experimental input.

| ID | Ruby options `(m_cost,t_cost,p_cost)` | Encoded memory | Purpose |
|---|---:|---:|---|
| P08 | `(13,1,1)` | 8 MiB | Low-cost measurement control; explicitly not a security recommendation |
| P16 | `(14,2,1)` | 16 MiB | Lower-memory comparison |
| P32 | `(15,2,1)` | 32 MiB | Mid-range comparison |
| P64-1 | `(16,2,1)` | 64 MiB | Isolate memory increase at one lane |
| P64-4 | `(16,3,4)` | 64 MiB | Gem's RFC-derived low-memory named-profile values; candidate only |
| P128-4 | `(17,3,4)` | 128 MiB | Higher-memory saturation comparison |

Single-operation measurements cover `create` and correct-password `verify` for all six profiles. Concurrency measurements cover both operations for P16, P64-4, and P128-4 at concurrency 1, 2, 4, and 8.

### 2.3 Sampling, warm-up, and repetition

- Three fresh-container benchmark runs execute sequentially to avoid cross-run contention.
- Each profile/mode is warmed once before measurement in each fresh process.
- Single-operation scenarios collect 20 operations per mode/profile/run.
- Concurrent scenarios collect `max(32, concurrency × 8)` operations per mode/profile/run through exactly `concurrency` worker threads.
- Per-operation latency uses `Process::CLOCK_MONOTONIC` around the native create/verify call. It measures service time after a worker begins, not external request-queue delay.
- p50, p95, and p99 use nearest-rank percentiles over the pooled three-run samples. p99 is reported but remains a coarse tail estimate at this sample size.
- Throughput is completed operations divided by scenario wall time.

### 2.4 Resource measurement

Before every scenario the script completes warm-up, runs garbage collection, records cgroup baseline memory/CPU counters, and resets cgroup-v2 `memory.peak` where permitted. It then records:

- cgroup `memory.current`, `memory.peak`, `memory.max`, `memory.events`, `cpu.stat`, and `cpu.max`;
- process `VmRSS`/`VmHWM` as supporting observations;
- elapsed wall time, operation errors, and completed count;
- CPU usage delta divided by wall time, expressed as average CPU cores used and percentage of the two-CPU quota;
- peak cgroup memory and peak-minus-baseline delta.

Argon2's configured memory is per active operation. Total process/container demand may approach `concurrency × per-operation memory` plus Ruby, FFI, allocator, threads, shared libraries, and measurement overhead. The experiment compares measured peak deltas with this theoretical floor; it does not assume exact linearity.

### 2.5 Reproducibility artifacts

The isolated directory will contain a Gemfile pinned to `argon2` 2.3.3, an isolated lockfile, benchmark script, three raw JSON runs, and an aggregate JSON summary. The final report records their SHA-256 values before the directory is removed. The application Gemfile and lockfile remain untouched.

## 3. Executed environment

| Item | Executed value |
|---|---|
| Backend image | `backend-backend:latest`, image `sha256:d96eecc9a5c077669a1dbea0bcd2f751ba57009bdbf35ecf5f4205309ff474f8` |
| Runtime | `ruby 3.4.12 (2026-10-23 revision 366f5fdc00) +PRISM [aarch64-linux]`; Bundler 2.6.9 |
| Candidate | `argon2` 2.3.3 source gem; `ffi` 1.17.4 `aarch64-linux-gnu`; `ffi-compiler` 1.4.3; `rake` 13.4.2 |
| Container OS | Debian Bookworm/glibc 2.36 on LinuxKit 7.0.12, aarch64 |
| Benchmark quota | cgroup v2 `cpu.max=200000 100000` (2 CPUs); `memory.max=1610612736` (1.5 GiB); `memory.swap.max=0`; `pids.max=256` |
| Docker VM | Docker Desktop, 8 aarch64 CPUs, 16,746,086,400 bytes RAM |
| Host | Apple M1, 8 cores, 17,179,869,184 bytes RAM, Darwin 25.0.0 arm64 |
| Isolation | Fresh container for each of three repetitions; network disabled during measurements; no Rails source mount, HTTP traffic, PostgreSQL, or production data |

All 36 planned scenarios completed in each repetition. The benchmark produced 3,600 measured operations in total, with zero operation errors, zero scenario timeouts, zero OOM events, zero OOM kills, and no safety abort.

Artifact digests recorded before temporary cleanup:

| Artifact | SHA-256 |
|---|---|
| Isolated Gemfile | `3b6846061700f4ba1bb785354b8894dff40babe434c2f778f4e6773c1d316c71` |
| Isolated lockfile | `8db308f29ebdba49d56480474852693cd2f39e725434ad948f47d76d63dfdd5b` |
| Benchmark script | `62b5ed00bbb84e8bcb1305c673b41e40fe4f89249e542074d6c9e5a659b878f2` |
| Aggregation script | `00b3a3d6481ea348fbf5cbedd5ebf314925f906bbf45c8441ff3266118df8e55` |
| Raw run 1 | `084095907d60167aacbe8f6804a031ca160ecc8302b81c0efb972a20c5b47ec9` |
| Raw run 2 | `2333b4bd9658e8e4db0ce5b009ee5f74226d01ef72b5c72ac3afd685a1b1de2e` |
| Raw run 3 | `5cc97d733ba344e0ef8458bfd02aadeeda09e52124557c2137b2492d28683221` |
| Aggregate | `18e1ac8f8bae46787892306800ed01e7dd8c8b1c75f292646ff3382566ab7af1` |

## 4. Results

Percentiles pool all three runs. Throughput shows the median run followed by the three-run range. “Peak MiB” is maximum sampled total cgroup memory, not Argon2 memory alone. CPU quota values near 100% mean the full two-CPU quota was consumed; small values above 100% are measurement/accounting noise around the quota boundary.

### 4.1 Single-operation measurements

| Profile | Mode | n | p50 ms | p95 ms | p99 ms | ops/s median (range) | Peak MiB | CPU quota % |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| P08 | create | 60 | 7.4 | 7.6 | 9.2 | 132.41 (132.20–132.55) | 39.1 | 50.9 |
| P08 | verify | 60 | 7.4 | 7.9 | 9.3 | 132.42 (131.98–132.75) | 36.1 | 50.9 |
| P16 | create | 60 | 30.4 | 33.8 | 58.3 | 32.64 (31.04–32.71) | 53.8 | 51.0 |
| P16 | verify | 60 | 30.4 | 33.0 | 34.4 | 32.49 (32.48–32.69) | 55.6 | 50.8 |
| P32 | create | 60 | 71.8 | 76.0 | 78.1 | 13.74 (13.69–14.04) | 54.5 | 50.9 |
| P32 | verify | 60 | 71.4 | 75.1 | 78.5 | 13.86 (13.80–14.04) | 54.6 | 50.9 |
| P64-1 | create | 60 | 147.6 | 152.0 | 156.0 | 6.77 (6.73–6.81) | 86.9 | 50.9 |
| P64-1 | verify | 60 | 147.4 | 150.1 | 152.1 | 6.78 (6.74–6.78) | 86.8 | 50.9 |
| P64-4 | create | 60 | 116.9 | 169.3 | 175.2 | 7.71 (7.70–7.72) | 87.3 | 101.0 |
| P64-4 | verify | 60 | 116.7 | 169.5 | 171.8 | 7.71 (7.70–7.72) | 86.9 | 100.4 |
| P128-4 | create | 60 | 278.0 | 288.4 | 292.3 | 3.78 (3.78–3.84) | 151.1 | 100.2 |
| P128-4 | verify | 60 | 276.8 | 287.6 | 289.6 | 3.78 (3.77–3.79) | 151.1 | 100.4 |

P08 is a low-cost measurement control only. No row is an approved password or PIN profile. P64-4 used all of the two-CPU quota even with one application operation because its native `p_cost=4` work creates internal parallelism. P64-1 used about one CPU but had higher median latency, showing that parallelism and deployment CPU quota materially affect calibration.

### 4.2 Concurrent create measurements

| Profile | C | n | p50 ms | p95 ms | p99 ms | ops/s median (range) | Peak MiB | Theoretical Argon2 MiB | CPU quota % |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| P16 | 1 | 96 | 30.4 | 30.9 | 34.5 | 32.73 (32.71–32.79) | 54.1 | 16 | 50.9 |
| P16 | 2 | 96 | 32.3 | 35.9 | 36.6 | 60.94 (60.89–61.00) | 84.9 | 32 | 95.2 |
| P16 | 4 | 96 | 86.6 | 107.7 | 118.0 | 52.96 (51.64–56.29) | 117.8 | 64 | 99.9 |
| P16 | 8 | 192 | 206.6 | 294.5 | 303.5 | 36.23 (35.67–37.55) | 182.6 | 128 | 99.6 |
| P64-4 | 1 | 96 | 118.2 | 172.5 | 182.7 | 7.64 (7.60–7.77) | 87.2 | 64 | 100.1 |
| P64-4 | 2 | 96 | 313.4 | 387.1 | 390.5 | 6.05 (5.93–6.08) | 151.2 | 128 | 99.7 |
| P64-4 | 4 | 96 | 800.5 | 911.6 | 986.3 | 4.92 (4.84–5.00) | 280.1 | 256 | 100.2 |
| P64-4 | 8 | 192 | 1717.3 | 2010.3 | 2271.7 | 4.72 (4.32–4.74) | 537.3 | 512 | 100.1 |
| P128-4 | 1 | 96 | 280.8 | 288.4 | 292.2 | 3.77 (3.77–3.78) | 151.2 | 128 | 100.0 |
| P128-4 | 2 | 96 | 700.1 | 790.8 | 859.8 | 2.85 (2.81–2.85) | 279.6 | 256 | 100.1 |
| P128-4 | 4 | 96 | 1703.6 | 1896.4 | 1971.7 | 2.34 (2.28–2.35) | 536.5 | 512 | 100.0 |
| P128-4 | 8 | 192 | 3493.4 | 3907.9 | 4095.6 | 2.30 (2.24–2.31) | 1050.4 | 1024 | 100.0 |

### 4.3 Concurrent verification measurements

| Profile | C | n | p50 ms | p95 ms | p99 ms | ops/s median (range) | Peak MiB | Theoretical Argon2 MiB | CPU quota % |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| P16 | 1 | 96 | 30.4 | 33.8 | 64.0 | 32.23 (31.56–32.63) | 55.2 | 16 | 51.0 |
| P16 | 2 | 96 | 32.3 | 36.0 | 45.0 | 60.05 (59.78–60.73) | 87.5 | 32 | 97.2 |
| P16 | 4 | 96 | 85.5 | 96.9 | 99.9 | 54.55 (52.76–54.76) | 122.2 | 64 | 102.0 |
| P16 | 8 | 192 | 204.0 | 295.7 | 306.2 | 37.74 (37.68–38.07) | 190.2 | 128 | 101.2 |
| P64-4 | 1 | 96 | 116.8 | 171.0 | 174.2 | 7.71 (7.69–7.80) | 87.4 | 64 | 99.9 |
| P64-4 | 2 | 96 | 312.0 | 385.3 | 394.4 | 6.07 (6.04–6.08) | 151.4 | 128 | 100.1 |
| P64-4 | 4 | 96 | 804.9 | 991.1 | 1076.3 | 4.85 (4.73–4.91) | 280.0 | 256 | 100.0 |
| P64-4 | 8 | 192 | 1700.0 | 1973.0 | 2095.0 | 4.66 (4.61–4.68) | 537.3 | 512 | 100.1 |
| P128-4 | 1 | 96 | 276.6 | 292.9 | 320.5 | 3.77 (3.73–3.77) | 151.3 | 128 | 99.7 |
| P128-4 | 2 | 96 | 701.9 | 785.1 | 807.8 | 2.83 (2.79–2.86) | 279.7 | 256 | 100.2 |
| P128-4 | 4 | 96 | 1699.4 | 1882.2 | 1926.6 | 2.34 (2.32–2.36) | 536.8 | 512 | 100.2 |
| P128-4 | 8 | 192 | 3409.3 | 3799.5 | 4105.1 | 2.34 (2.28–2.34) | 1050.7 | 1024 | 100.0 |

Create and verification had materially similar resource shapes. No wrong-password verification was accepted. p99 is a nearest-rank statistic over 60 single-operation samples or 96/192 concurrency samples and should not be treated as a production tail-latency SLO.

## 5. Saturation and memory interpretation

### 5.1 CPU saturation

- P16 with `p_cost=1` used about one of the two CPUs at concurrency 1. Throughput nearly doubled at concurrency 2, then fell at concurrency 4 and 8 while p95 latency rose. Its measured throughput optimum in this envelope was concurrency 2.
- P64-4 and P128-4 with `p_cost=4` consumed the full two-CPU quota at concurrency 1. Increasing application concurrency did not add CPU capacity: median throughput declined and latency expanded sharply.
- At P64-4 verification, concurrency 8 reduced throughput from 7.71 to 4.66 operations/second and raised p95 from 171 ms to 1,973 ms.
- At P128-4 verification, concurrency 8 reduced throughput from 3.77 to 2.34 operations/second and raised p95 from 293 ms to 3,800 ms.
- Cgroup CPU-throttling counters rose once work attempted to exceed the two-CPU quota. Additional Puma/request threads would therefore queue through CPU contention even before memory exhaustion.

### 5.2 Per-operation versus total memory

| Profile | Single-operation total peak | Eight-operation total peak | Eight-operation Argon2 floor | Highest measured peak delta |
|---|---:|---:|---:|---:|
| P16 | 55.2 MiB | 190.2 MiB | 128 MiB | 160.8 MiB |
| P64-4 | 87.4 MiB | 537.3 MiB | 512 MiB | 515.4 MiB |
| P128-4 | 151.3 MiB | 1,050.7 MiB | 1,024 MiB | 1,028.4 MiB |

The configured Argon2 memory is per active operation. The container also needs Ruby, FFI/native extension, libraries, thread stacks, allocator state, salts/digests, and benchmark monitoring. The higher-memory results tracked the theoretical Argon2 floor closely plus roughly 22–27 MiB of resident runtime at peak; lower-memory create cases showed proportionally larger allocator/creation overhead.

Eight concurrent P128-4 operations used about 68.4% of the 1.5 GiB limit and did not OOM. That does **not** establish safety for unbounded concurrency. Twelve simultaneous 128 MiB operations, 24 simultaneous 64 MiB operations, or 96 simultaneous 16 MiB operations would consume the entire 1.5 GiB limit in Argon2 memory alone before Rails/runtime overhead. The real safe ceiling must be lower and must reserve capacity for normal request handling, health checks, database clients, sessions, logging, and allocator variance.

### 5.3 Need for bounded application concurrency

A bounded application-level hashing admission mechanism is necessary for any selected profile in a finite-memory deployment. This evidence does not select its size or implementation. The limit must be calculated per container from:

1. the selected profile's actual memory and CPU shape;
2. container memory/CPU quotas and measured non-hashing Rails baseline;
3. Puma workers, threads, replicas, and rolling-deployment overlap;
4. reserved capacity and failure/recovery margin;
5. authentication-defense limits applied before expensive work;
6. a bounded wait/timeout and generic temporary-unavailable response when admission is full.

The limit is not equivalent to `RAILS_MAX_THREADS` or Puma thread count. With multiple Puma workers, each process-local limit must also respect one container-wide budget; independent per-worker limits can multiply memory beyond the cgroup capacity.

## 6. Deployment assumptions and unknowns

The current repository supplies a development image and Compose topology, not a production deployment. The development Compose file has no CPU or memory limits; this experiment added explicit limits solely for measurement. Puma currently defaults to one worker and three threads unless `WEB_CONCURRENCY` or `RAILS_MAX_THREADS` changes them, but these are foundation defaults rather than approved authentication capacity.

Production facts still unknown:

- hosting platform, CPU model/architecture, CPU quota/burst behavior, memory quota, swap/OOM policy, and allocator;
- Rails web container count, Puma worker/thread counts, replica count, autoscaling, rolling-release surge, and whether web shares resources with jobs;
- non-hashing Rails resident baseline and peak under real middleware, sessions, authorization, database pools, logging, monitoring, and health traffic;
- password/PIN traffic distribution, legitimate burst rate, hostile-attempt rate after edge/account/device controls, and acceptable queue/rejection behavior;
- login/POS latency SLOs, timeout budget, reserve percentage, and operational alert thresholds;
- x86_64 or other production architecture performance; this evidence is aarch64 only;
- whether the selected profile uses one or multiple native lanes, which materially changes CPU saturation;
- admission coordination across multiple workers and the safe behavior during limiter/database/secret-manager degradation.

Before parameter approval, repeat the shortlisted matrix in a production-parity staging container with Rails booted, realistic Puma topology, normal database/session/logging dependencies, measured non-hashing baseline, and the intended resource limits. Model deployment-wide capacity as `replicas × per-container admitted operations`, while treating each container's memory as an independent hard ceiling.

## 7. Recommendation and final status

**Final capacity-evidence status: sufficient to proceed to a separate Owner review of candidate parameters and operational safeguards.**

The evidence is not sufficient to approve a production profile or concurrency number. The Owner review should first establish a provisional deployment envelope and latency/resource budgets, then shortlist profiles from this matrix for production-parity validation. It should explicitly decide:

- maximum allowed single-operation p95/p99 latency for password and POS flows;
- per-container CPU/memory quota and mandatory reserve;
- Puma process/thread/replica topology;
- bounded hashing admission behavior, queue timeout, and generic overload response;
- monitoring/alerts for admission saturation, hash latency, cgroup memory, CPU throttling, and authentication-defense bypass;
- whether four-lane profiles are operationally appropriate when one operation already saturates a two-CPU container.

No tested profile is selected or approved here. No result demonstrates denial-of-service resistance. AF-OWNER-001 findings remain open pending separate review, implementation, production-parity evidence, and explicit closure.

## 8. Status discipline

- AF-OWNER-001 FIND-001 through FIND-009 remain `OPEN`.
- No residual risk is accepted.
- Independent verification and legal review remain `NOT_PERFORMED`.
- ADR-0006 remains Proposed.
- Milestone 2B remains unauthorized.
