---
plan_id: AF-OWNER-001E
owner_review_id: AF-OWNER-001
document_status: PLANNED_NOT_EXECUTED
benchmark_status: NOT_EXECUTED
implementation_status: NOT_AUTHORIZED
independent_verification: NOT_PERFORMED
legal_review: NOT_PERFORMED
---

# AF-OWNER-001E: Production-Parity Validation Plan

**Plan type:** Owner-led, non-independent evidence plan  
**Prepared:** 2026-11-14  
**Scope:** P64 password-profile comparison, container-scoped HashingAdmission validation, and resource-budget evidence  
**Authority:** Decision Register IDs 29–34; approval is limited to validation direction  
**Related:** [Decision Register](../../after_four_identity_decision_register.md) · [AF-OWNER-001 Assessment](af-owner-001-password-pin-security.md) · [AF-OWNER-001C.2 Compatibility Spike](af-owner-001c2-argon2id-compatibility-spike.md) · [AF-OWNER-001C.3 Capacity Validation](af-owner-001c3-argon2id-capacity-validation.md) · [AF-OWNER-001D Decision Record](af-owner-001d-argon2-owner-decision-proposals.md) · [AF-OWNER-001F Deployment Inputs Discovery](af-owner-001f-production-deployment-inputs-discovery.md) · [Identity Technical Design](../../after_four_identity_technical_design.md) · [Password/PIN Control Specification](../../after_four_identity_password_pin_control_specification.md) · [ADR-0006](../../adr/0006-authentication-session-topology.md) · [ADR-0002](../../adr/0002-ruby-rails-version-baseline.md) · [ADR-0008](../../adr/0008-deployment-environments.md)

This document defines a future validation method. No benchmark, dependency integration, HashingAdmission implementation, production selection, residual-risk acceptance, or Milestone 2B work was performed or authorized. A technical pass under this plan creates an evidence package for a later Owner decision; it never authorizes production use automatically.

## 1. Evidence and governance baseline

### 1.1 Evidence classification

| Classification | Meaning in this plan | Current examples |
|---|---|---|
| `VERIFIED_EVIDENCE` | Executed evidence with a recorded environment, procedure, result, and limitation. | AF-OWNER-001C.2 compatibility on its tested aarch64 Linux and arm64 macOS environments; AF-OWNER-001C.3 isolated capacity results. |
| `BENCHMARK_OBSERVATION` | A measurement valid only for the recorded benchmark envelope. | C.3 latency, throughput, CPU, and memory in an isolated 2-CPU/1.5-GiB/no-swap aarch64 Linux container. |
| `OWNER_CONFIRMED_DIRECTION` | Direction explicitly approved by the Owner, with the Decision Register boundary controlling. | IDs 29–34. |
| `PLANNED_VALIDATION` | A method proposed here but not executed. | The P64 lane matrix, Rails production-parity workload, and cross-worker admission harness. |
| `UNKNOWN` | A required production fact has not been supplied. It is neither inferred nor defaulted. | Production CPU class, resource quotas, Puma topology, traffic, and SLOs. |
| `UNRESOLVED_DECISION` | Evidence and explicit Owner disposition are still required. | Production profile, `p_cost`, Adapter, numeric admission limit, queue/deadline, and monitoring thresholds. |

The plan must not relabel a C.2/C.3 observation as production evidence. Development configuration and accepted foundation versions are context, not proof that the production environment uses those values.

### 1.2 Current evidence ledger

| Record | Baseline identifier | Evidence established | Limitation carried into this plan |
|---|---|---|---|
| [Decision Register](../../after_four_identity_decision_register.md) | `22618047ab50056bf6ee13328101f70651e723ccb1a41bcda245615c9aadc74d` | IDs 29–34 approve the P64-4 validation candidate and validation/admission direction. | No production/PIN profile, number, Adapter, implementation, or production use. |
| [AF-OWNER-001](af-owner-001-password-pin-security.md) | Pre-plan SHA-256 `8214fa6223a5ffac6e0e92894659236141608cebe93dd78706682ab8ad73365c` | Nine open findings and missing-evidence record. | Assessment remains in progress; no finding or risk is closed. |
| [AF-OWNER-001C.2](af-owner-001c2-argon2id-compatibility-spike.md) | `05f793b722c4f85fc50ecc796be327ad52c209baf267dc7b9901bd57d5804f60` | `argon2` 2.3.3 functional compatibility on recorded Ruby 3.4.12 targets; exact Ruby cost semantics. | No production architecture, Rails integration, x86_64 result, or dependency approval. |
| [AF-OWNER-001C.3](af-owner-001c3-argon2id-capacity-validation.md) | `c4b816989e7db6f8f0ac5251cb6246f4ed453478f6c45cc9640491f611861402` | Isolated resource and concurrency observations for selected profiles. | No Rails, HTTP, database/session/logging, authentication-defense, or production hardware load. |
| [AF-OWNER-001D](af-owner-001d-argon2-owner-decision-proposals.md) | Pre-plan SHA-256 `b1556d1b91e114a485635de22a0b26cb7b496320fb839ab28d3fe7bacd99485d` | Owner-approved-with-limitations decision analysis and resource/admission method. | No executed production-parity validation or production approval. |

### 1.3 Existing observations that motivate the plan

C.3 observed P64-4 verification p50/p95/p99 of 116.8/171.0/174.2 ms at application concurrency one in its constrained container, total peak cgroup memory of 87.4 MiB, and approximately the full two-CPU quota. At concurrency eight, throughput fell from 7.71 to 4.66 operations/second while p95 rose to 1,973 ms and total peak memory reached 537.3 MiB. These are `BENCHMARK_OBSERVATION`, not an SLO, admission limit, production capacity, or proof of denial-of-service resistance.

C.3's P64-1 tuple was `(m_cost: 16, t_cost: 2, p_cost: 1)`. The new required P64 one-lane comparison is `(16,3,1)`. The older P64-1 result cannot be reused as measurement of the new tuple because both time cost and execution shape differ.

### 1.4 Foundation and environment facts

- ADR-0001 selects one Rails modular monolith; ADR-0005 locates it under `backend/`.
- ADR-0002 accepts Ruby 3.4.12, Rails 8.1.4.1, and Bundler 2.6.9 as the project foundation. The production image/build remains unprovided.
- The development image is `ruby:3.4.12-bookworm`; Compose supplies no CPU or memory limits. It is not production parity.
- Puma defaults to one worker and three threads unless environment values change; `.env.example` proposes five Rails threads. Neither is an approved production topology.
- No Argon2 dependency is in the application Gemfile or lockfile.
- ADR-0008 is Proposed and no production hosting/runtime/resource topology is selected.

### 1.5 Owner-decision trace

| Decision | Direction carried into this plan | Planned workstream | Limitation preserved |
|---|---|---|---|
| ID-29 / `ARGON-PROP-01` | P64-4 is the preferred password candidate for production-parity validation. | B and E | It is not a production or PIN profile and is not a predetermined benchmark winner. |
| ID-30 / `ARGON-PROP-02` | HashingAdmission is mandatory at container scope across all relevant Puma workers. | C | Adapter, queue/deadline, and numeric admission/resource choices remain unresolved. |
| ID-31 / `ARGON-PROP-03` | Use the approved Rails-baseline/reserve/headroom and memory/CPU/latency/topology resource method. | A, D, and E | Every numeric input, reserve, headroom, and result remains unapproved. |
| ID-32 / `ARGON-PROP-04` | Compare P64 at one, two, and four lanes with explicit versioned `p_cost`. | B | No production `p_cost` or profile is approved. |
| ID-33 / `ARGON-PROP-05` | Validate bounded waiting, generic temporary-unavailable behavior, and no queue/bypass/cheaper fallback. | C and E | Queue size, deadline, response code, retry, rejection, and concurrency values remain unresolved. |
| ID-34 / `ARGON-PROP-06` | Define evidence-based revalidation before first production use and after material change. | F | Revalidation never substitutes for a separate production decision where required. |

## 2. Workstream A — Deployment environment inventory

Benchmark execution is blocked until every mandatory-before-run row has a recorded artifact. `UNKNOWN` and `NOT PROVIDED` are deliberate stop conditions, not invitations to copy development defaults.

| Required input | Why it matters | Required evidence source/artifact | Required before benchmark? | Re-collect after change? | Current production status |
|---|---|---|---|---|---|
| CPU architecture and model/class | Native Argon2 lanes, memory bandwidth, and latency vary by architecture and CPU generation. | Platform inventory plus runtime capture such as architecture, model/class, core topology, and virtualization. | Yes | Any CPU class/architecture/virtualization change | `UNKNOWN` |
| Container CPU quota and scheduling/burst semantics | Determines lane contention, throttling, and whole-container throughput. | Deployment manifest/platform export and in-container cgroup CPU evidence. | Yes | Quota, scheduler, or platform change | `UNKNOWN` |
| Container memory limit | Sets the hard ceiling used by the admission calculation. | Deployment manifest/platform export and in-container cgroup memory evidence. | Yes | Limit or platform change | `UNKNOWN` |
| Swap and OOM behavior | Swap can create severe latency; OOM policy controls process/container failure. | Runtime configuration, cgroup counters, platform policy, and controlled failure observation. | Yes | Swap, cgroup, kernel, or platform change | `UNKNOWN` |
| Container runtime, OS, kernel, libc, allocator, and base-image digest | Native build/runtime behavior and memory accounting depend on this chain. | Immutable image digest, SBOM/build log, runtime/version capture, and allocator declaration. | Yes | Image/runtime/kernel/libc/allocator change | `UNKNOWN`; development image is not evidence |
| Ruby, Rails, and Bundler versions and build configuration | Interpreter/build/GC behavior, Rails middleware, and dependency resolution affect native integration, baseline use, and reproducibility. | Runtime output, build provenance/flags where applicable, locked dependency manifest, and immutable image manifest. | Yes | Ruby, Rails, Bundler, lock, build, or image change under ID-34 | `OWNER_CONFIRMED` foundation baseline in ADR-0002; production build/runtime capture is `NOT PROVIDED` |
| Argon2 gem/native dependency version and build | Correctness, parameter semantics, native code, and performance are version/build specific. | Isolated production-image lock artifact, gem/native provenance, clean build log, linkage, SBOM, and advisory result. | Yes | Gem, FFI/native library, compiler, flags, or image change | `NOT PROVIDED`; `argon2` 2.3.3 is a validation candidate only |
| Puma worker/thread/process topology | Per-process limits can multiply container demand; threads create contention and queueing. | Deployment configuration, boot logs, process tree, pool settings, and cross-worker request routing evidence. | Yes | Worker/thread/preload/fork/pool change | `UNKNOWN` |
| Rails non-hashing baseline and peak | Required to reserve memory/CPU for normal requests, health, database, logging, and recovery. | Repeated production-parity idle and representative-load samples with Rails booted and hashing disabled. | Yes | Image, middleware, feature, logging, pool, or topology change | `NOT PROVIDED` |
| Database/session/logging/monitoring dependencies | These shape baseline use and authentication latency outside Argon2. | Production-parity dependency inventory and enabled configuration captured with the run. | Yes | Dependency/configuration change | `UNKNOWN` |
| Web/job process colocation | Shared cgroups can invalidate a web-only budget. | Process/deployment inventory and resource-isolation manifest. | Yes | Process placement change | `UNKNOWN` |
| Application container counts | Determines deployment throughput but never relaxes each container's hard ceiling. | Desired/minimum/maximum replica configuration and observed placement. | Yes | Replica policy change | `UNKNOWN` |
| Autoscaling signals, bounds, and lag | Scaling may arrive after a login burst and cannot replace local admission. | Autoscaling policy/export and controlled scale-event evidence. | Yes | Autoscaling policy/platform change | `UNKNOWN` |
| Rollout, restart, and surge behavior | Overlap, cold start, and worker replacement affect load distribution and permit recovery. | Deployment strategy, maximum surge/unavailable policy, graceful-shutdown settings, and restart drill plan. | Yes | Release/restart strategy change | `UNKNOWN` |
| Legitimate authentication traffic | Required to test expected arrival rate, burst, create/reset frequency, and queue pressure. | Privacy-safe forecast from product/operations plus later production telemetry design. | Yes | Material traffic-pattern change | `NOT PROVIDED` |
| Hostile attempts after Authentication Defense | Admission sees traffic remaining after distributed defenses; raw edge traffic is the wrong input. | Threat model, planned limiter behavior, bounded synthetic attack model, and route inventory. | Yes | Threat/defense/route change | `NOT PROVIDED`; Authentication Defense is not implemented |
| Authentication latency SLOs | Technical pass must compare end-to-end and queue/service percentiles with an approved budget. | Owner-approved SLO record for create/reset and verification paths, including p50/p95/p99 and timeout budget. | Yes | SLO/product-flow change | `NOT PROVIDED` |
| Availability/rejection objectives | Needed to assess bounded-wait exhaustion without inventing a retry or rejection budget. | Owner/operations objective and failure contract proposal. | Yes | Availability or public-contract change | `NOT PROVIDED` |
| Rate-limiting/authentication-defense behavior | Must be evaluated before hashing and affects permitted load, enumeration behavior, and overload safety. | Design/configuration snapshot, route inventory, atomicity/outage evidence, and traffic model. | Yes for integrated validation | Defense threshold/store/route/proxy change | `NOT PROVIDED` |
| Monitoring and operational ownership | Determines whether saturation, throttling, OOM risk, and bypass can be detected and handled. | Proposed metrics, dashboards, alerts, runbooks, and named operational owner. | Yes for acceptance package | Monitoring/runbook/owner change | `NOT PROVIDED` |

### 2.1 Inventory gate

Before a benchmark protocol is frozen, the Owner records the immutable environment manifest, confirms that every mandatory row is present, and identifies any remaining mismatch from intended production. A mismatch is either corrected or explicitly carried as a limitation; it cannot be silently called parity. Missing CPU, memory, process-topology, Rails-baseline, traffic, or SLO evidence blocks the run from being decision-grade.

### 2.2 AF-OWNER-001F discovery reconciliation

[AF-OWNER-001F](af-owner-001f-production-deployment-inputs-discovery.md) inspected repository evidence without accessing production systems or secrets. It found no complete verified production input and did not replace any production unknown with a development default.

| Discovered repository evidence | Traceable source | Effect on this plan |
|---|---|---|
| Accepted Ruby 3.4.12, Rails 8.1.4.1, and Bundler 2.6.9 foundation | [ADR-0002](../../adr/0002-ruby-rails-version-baseline.md), [`Gemfile`](../../../../backend/Gemfile), lockfile | Confirms required version direction only; immutable production build/runtime capture remains mandatory. |
| Development Ruby Bookworm image and PostgreSQL 18 client | [`Dockerfile.development`](../../../../backend/Dockerfile.development) | Development evidence only; production runtime/image/architecture remain provider-dependent. |
| Development Compose has no CPU/memory limits | [`compose.yml`](../../../../backend/compose.yml) | Supplies no resource-budget term; production limits remain unknown. |
| Puma framework defaults and environment configurability exist | [`puma.rb`](../../../../backend/config/puma.rb) | Supplies no production worker/thread/process choice; ID-30 cross-worker validation remains blocked. |
| Production Rails configuration expresses SSL/logging/health intent | [`production.rb`](../../../../backend/config/environments/production.rb) | Configuration intent only; deployed edge/proxy/Host/monitoring/topology evidence remains absent. |
| CI runs the pinned foundation and quality checks | [Quality workflow](../../../../.github/workflows/quality.yml) | Quality evidence only; it is not a production deployment workflow or capacity environment. |
| No Argon2 dependency is declared in the application | [`Gemfile`](../../../../backend/Gemfile) and lockfile | Production dependency integration remains unresolved; C.2 remains isolated evidence. |
| Deployment/provider/operations choices remain open | [ADR-0008](../../adr/0008-deployment-environments.md) | Benchmarking cannot be production-parity until provider, topology, resources, SLOs, traffic, and ownership are supplied. |

AF-OWNER-001F classifies the 20 inputs as: 0 fully verified production inputs, 1 `OWNER_CONFIRMED` foundation baseline, 3 `PROPOSED_NOT_APPROVED`, 5 `PROVIDER_DEPENDENT`, 4 `NOT_PROVIDED`, and 7 `OWNER_DECISION_REQUIRED`. These classifications describe current discoverability; they do not approve values.

## 3. Workstream B — Argon2 profile benchmark matrix

### 3.1 Planned profile matrix

| Plan ID | Exact Ruby options | Encoded memory | Evidence status | Role in comparison |
|---|---:|---:|---|---|
| `PP-P64-1` | `(m_cost: 16, t_cost: 3, p_cost: 1)` | 65,536 KiB | `PLANNED_NOT_EXECUTED` | Same memory/time with one native lane. |
| `PP-P64-2` | `(m_cost: 16, t_cost: 3, p_cost: 2)` | 65,536 KiB | `PLANNED_NOT_EXECUTED` | Same memory/time with two native lanes. |
| `PP-P64-4` | `(m_cost: 16, t_cost: 3, p_cost: 4)` | 65,536 KiB | `PLANNED_NOT_EXECUTED`; preferred validation candidate under ID-29 | Same memory/time with four native lanes; not predetermined winner. |

All calls must record the exact `argon2` Ruby Interface and validate that encoded output reports Argon2id v19, `m=65536`, `t=3`, and the intended `p`. Library defaults and named presets are forbidden in the harness. This is validation metadata, not production-profile approval.

### 3.2 Workload matrix

Every planned profile covers:

| Workload | Required paths | Measurements |
|---|---|---|
| Credential creation | Enrollment/create and replacement/rehash-shaped create with synthetic secrets. | Queue time, service time, end-to-end time, throughput, CPU, incremental/total memory, errors, timeouts, OOM/throttling. |
| Correct verification | Existing synthetic digest and correct presented password. | Same measurements plus public/internal outcome class. |
| Incorrect verification | Existing synthetic digest and wrong presented password. | Same measurements; rejection must use the encoded profile and must not become a cheaper path. |
| Unknown-subject/dummy verification | Planned maintained dummy digest after Authentication Defense permits the attempt. | Same measurements and comparison with known-wrong behavior; no account/state leak. |
| Mixed representative traffic | Approved create/verify/wrong/dummy proportions derived from the traffic inventory. | End-to-end distribution, queue fairness, throughput, resource peaks, rejection, and recovery. |
| Bounded hostile traffic | Traffic remaining after the planned Authentication Defense model, including bursts. | Admission saturation, generic outcome, bounded resources, health preservation, and recovery. |

The plan does not cover PIN hashing or PIN keyed preprocessing. Those require a separate profile and validation decision.

### 3.3 Planned load and repetition protocol

The exact protocol must be frozen and hashed before execution. The initial planned structure is:

1. Use immutable production-parity image and deployment manifests from the inventory gate.
2. Use synthetic published inputs at the approved minimum, representative, and maximum byte/character bounds; never use production credentials or personal data.
3. Execute isolated Argon2 runs first to diagnose native behavior, then repeat with Rails booted and the complete intended Puma/dependency topology. Only the Rails-integrated run can support production consideration.
4. Warm each profile/path before measurement using a predeclared count. Warm-up samples are retained and labeled but excluded from reported percentiles by the frozen rule.
5. Use at least three fresh container repetitions per scenario. The frozen protocol must define operation count or duration sufficient for meaningful p50/p95/p99 reporting and must publish sample counts and percentile method.
6. Cover application concurrency 1, 2, 4, and 8 as experimental load points, then only bounded additional steps allowed by predeclared safety stops. These are test inputs, not production admission candidates.
7. Run create, correct verify, wrong verify, dummy verify, mixed legitimate load, and bounded hostile-after-defense load separately so one workload cannot hide another.
8. Sample cgroup and process memory/CPU at a fixed documented interval; record baseline, peak, peak-minus-baseline, CPU throttling, swap, OOM events/kills, process exits, timeouts, and completed/error counts.
9. Separate admission queue time from Argon2 service time and full request time. Report throughput and p50/p95/p99 for all three where applicable.
10. Allow the container to return to a predeclared recovery condition between scenarios; record failure to recover rather than masking it with a restart.

### 3.4 Safety stops

Before execution, the protocol must define stop conditions tied to the actual container limit and request timeout without treating them as production policy. Stop load escalation on any OOM event/kill, unexpected process exit, corrupted or accepted-wrong result, sustained health/readiness failure, timeout/error outside the frozen allowance, or predeclared memory/CPU safety threshold. A safety stop produces evidence of failure or an incomplete scenario; it is not discarded.

### 3.5 Reproducibility package

Retain and hash:

- benchmark and aggregation source;
- isolated validation Gemfile/lockfile or equivalent dependency manifest, separate from the application until integration is authorized;
- image digest, build log, SBOM, compiler/native linkage, and environment manifest;
- Rails/Puma/dependency configuration and deployment manifest;
- exact commands, UTC timestamps, warm-up/repetition/sample rules, and synthetic input corpus;
- raw per-operation samples and cgroup/process samples;
- unedited stdout/stderr, exit status, errors, OOM/throttling counters, and health observations;
- aggregate calculations and the tool/version that produced them; and
- a manifest mapping every artifact to SHA-256.

## 4. Workstream C — HashingAdmission validation design

### 4.1 Intended architecture

ID-30 establishes one authoritative admission boundary per application container, covering all relevant Puma workers in that container. ID-33 establishes bounded deadline-limited waiting, a generic capacity-unavailable result after the deadline, and prohibitions on unbounded queues, bypass, and cheaper-profile fallback.

HashingAdmission is a deep Module inside the Credential Protection implementation. Its Interface owns admission, bounded waiting, execution, and permit release; callers do not receive raw permits. Credential Protection callers continue to use `enroll`, `verify`, and `replace`, and cannot invoke the Argon2 Adapter directly. Authentication Defense evaluates an attempt before expensive hashing. This placement gives callers Leverage and keeps capacity, failure, and recovery knowledge local to one implementation.

The exact HashingAdmission Adapter remains unselected. An in-process Adapter is valid only if the approved topology has one worker; deterministic per-worker partitions or a container-shared coordinator are possible multi-worker options. This plan validates the approved properties independent of option and does not select queue technology, process coordination, lease mechanism, storage, or operating-system primitive.

### 4.2 Observable validation properties

| Property | Planned evidence | Required result |
|---|---|---|
| One container authority | Instrumented multi-worker harness records admitted/running/waiting work across every worker under one container. | Aggregate admitted work never exceeds the configured experimental ceiling, regardless of routing. |
| No worker multiplication | Send concurrent work to each worker and compare container aggregate with the experimental ceiling. | Adding workers does not multiply admitted Argon2 work. |
| Exact accounting | Correlate request, waiter, admission, start, completion/cancellation, and release events without secrets. | Every admission has one terminal release; counts reconcile after each scenario. |
| Bounded waiting | Saturate admission and measure queue time against the experimental deadline. | No waiter remains beyond the deadline plus documented scheduling tolerance. |
| Fairness | Interleave workers and workload classes under contention; retain arrival/admission order evidence. | Behavior satisfies the frozen fairness rule without starvation; no fairness algorithm is selected by this plan. |
| Generic exhaustion | Compare full public responses and safe timing distributions for known, wrong, unknown, disabled, and saturated cases. | Capacity exhaustion reveals no account, credential, device, profile, worker, or queue state. |
| Cancellation/timeout safety | Cancel queued and running requests at controlled points. | Queued work never starts after terminal cancellation; running work releases capacity exactly once; resource use remains bounded. |
| Worker failure | Terminate a worker while queued, admitted-before-start, and hashing. | No permanent capacity leak or double admission; outcome is generic; recovery matches the selected future Adapter's documented guarantee. |
| Graceful worker restart | Cycle workers during mixed load. | New/old workers share the one container budget; draining work is bounded and observable. |
| Abrupt container restart | Restart the container with waiters and active work. | Ephemeral queue/admission state does not claim successful authentication; the new container starts from a safe empty state and no stale client result becomes success. |
| No unbounded queue | Sustain arrivals beyond capacity. | Waiting count and memory stay within the experimental bound; excess receives generic capacity-unavailable behavior. |
| No bypass | Inventory every password create/verify/upgrade/reset path and attempt direct/internal invocation. | Every Argon2 operation crosses HashingAdmission; direct Adapter use is inaccessible outside Credential Protection. |
| No cheaper fallback | Inspect encoded metadata and exercised configuration during saturation. | The selected experimental tuple remains unchanged under load and errors. |
| Rejected/timed-out resource bound | Measure CPU/memory for excess arrivals that never receive admission. | Rejection/timeout work does not trigger Argon2 and does not cause unbounded memory, thread, or process growth. |
| Health and recovery | Exercise live/readiness and ordinary non-hashing requests during and after saturation. | Behavior meets the later approved availability budget and returns to the frozen recovery condition. |

The experimental ceiling and deadline used to execute this harness are test inputs derived only after the inventory/resource calculation. They are not production values and must be labeled as such in every artifact.

## 5. Workstream D — Resource-budget calculation

### 5.1 Memory method

```text
M_hash_budget = M_limit - M_rails_peak - M_runtime_reserve - M_safety_headroom
N_memory      = floor(M_hash_budget / M_hash_increment_conservative)
```

| Term | Evidence required | Uncertainty treatment |
|---|---|---|
| `M_limit` | Effective in-container hard limit verified from deployment and cgroup state. | Missing or ambiguous limit blocks calculation; do not use host RAM. |
| `M_rails_peak` | Highest representative non-hashing production-parity peak across repeated idle, legitimate, health, error, and dependency workloads for the intended worker topology. | Use a conservative upper observation plus documented sampling limits; rerun when baseline-affecting inputs change. |
| `M_runtime_reserve` | Measured variance and explicit allowance for allocator/native libraries, thread stacks, database/logging/monitoring clients, health/recovery operations, kernel/cgroup accounting, and restart behavior. | Unknown categories are not zero; insufficient evidence blocks approval or increases a separately proposed reserve. |
| `M_safety_headroom` | Explicit Owner/operations proposal justified by failure model, measurement variance, and OOM policy. | No default percentage is inferred; value requires separate Owner approval. |
| `M_hash_increment_conservative` | Production-parity peak incremental memory per admitted operation under create/correct/wrong/dummy and concurrent workloads for each profile. | Use the controlling conservative result, not configured 64 MiB alone or an average. |

If `M_hash_budget` is non-positive or any mandatory term is unknown, no numeric admission ceiling can be proposed.

### 5.2 Controlling constraints

Memory alone cannot select admission:

```text
N_admit <= min(N_memory, N_cpu, N_latency, N_process_topology, N_traffic_safety)
```

- `N_cpu` is the largest experimental admitted level that remains within the later approved CPU-throttling and throughput budget for the controlling profile/path.
- `N_latency` is the largest level whose queue plus service plus request latency remains within the later approved SLO for create, correct verify, wrong verify, and dummy verify.
- `N_process_topology` proves all worker-local allocations sum to no more than the container authority and remain safe across restart/rollout behavior.
- `N_traffic_safety` accounts for legitimate peak arrival and bounded hostile attempts remaining after Authentication Defense; it does not permit an unsafe memory/CPU/latency result.

Calculate each profile and workload separately. The smallest safe result controls the candidate proposal. Replica count can estimate deployment throughput only after load distribution/autoscaling evidence exists and never increases an individual container's `N_admit`.

### 5.3 Decision output

The calculation report shows every input, source artifact, timestamp, uncertainty, formula step, controlling constraint, sensitivity analysis, and rejected alternative. It proposes—but does not approve—a production profile, `p_cost`, numeric admission ceiling, reserve/headroom, queue/deadline, and overload contract for separate Owner review.

## 6. Workstream E — Production-parity acceptance evidence

### 6.1 Required evidence package

| Evidence item | Minimum content |
|---|---|
| Environment parity report | Every inventory row; immutable image/deployment hashes; production mismatch list and impact. |
| Dependency/native compatibility | Clean build/linkage, runtime load, vectors/round trips, wrong/malformed behavior, target platforms, advisories/maintenance, fork/thread/restart behavior. |
| Benchmark raw package | Frozen protocol, scripts, inputs, raw samples, cgroup/process observations, errors, safety stops, aggregate tool, and artifact manifest. |
| Benchmark summary | Create/correct/wrong/dummy and mixed/hostile results for P64-1/2/4; queue/service/request p50/p95/p99, throughput, CPU, memory, errors/timeouts/OOM, and recovery. |
| Resource-budget calculation | All formula inputs, uncertainty, constraints, sensitivity, controlling workload/profile, and proposed—not approved—numbers. |
| HashingAdmission correctness | Cross-worker authority, accounting, fairness, bounded wait, generic exhaustion, cancellation, restart/failure, no queue/bypass/fallback, resource bounds, and recovery evidence. |
| Security/failure behavior | Encoded tuple checks, no accepted-wrong result, dummy/wrong behavior, generic errors, no secret logging, fail-closed dependency/configuration/admission outcomes. |
| Monitoring/operations proposal | Metrics, labels/redaction, dashboards, alerts, runbooks, owners, restart/rollout observation, and capacity-review cadence; numeric thresholds remain separate decisions. |
| Revalidation record | Trigger mapping from section 7 to repeatable artifacts, release gate, evidence owner, and last validated environment manifest. |
| Limitations/residual-risk register | Unmodeled traffic/platform behavior, self-review limitation, measurement uncertainty, open findings, and risks proposed for remediation or explicit later acceptance. |

### 6.2 Technical pass criteria versus Owner approval

Technical pass is possible only when:

1. every mandatory environment input is supplied and parity mismatches are explicit;
2. the dependency/native checks pass on every intended production target;
3. raw artifacts reproduce the summary and all planned workload/profile cells are complete or explicitly failed;
4. the candidate stays within the Owner-supplied resource, latency, availability, and safety budgets for every controlling workload;
5. HashingAdmission satisfies all section 4 properties across the intended Puma topology;
6. overload remains bounded, generic, observable, and recoverable without cheaper fallback or bypass;
7. monitoring/runbook and revalidation evidence are reviewable; and
8. no open finding is hidden or silently converted into accepted residual risk.

A technical failure blocks profile approval. A technical pass only makes the package eligible for Owner review. Production use still requires separate explicit decisions for the dependency, profile/`p_cost`, resource/admission numbers, overload/public contract, operational thresholds, implementation authorization, and any permissible residual-risk acceptance. ADR-0006 and Milestone 2B do not change automatically.

## 7. Workstream F — Revalidation triggers

| Material change under ID-34 | Evidence that must be repeated |
|---|---|
| Ruby/runtime/build/GC change | Dependency/native checks; isolated and Rails-integrated profile matrix; Rails baseline; resource calculation; restart behavior. |
| Argon2/FFI/native dependency, compiler, flags, or linkage change | Clean build/provenance/SBOM/advisory review; vectors and malformed behavior; complete profile matrix; memory/CPU/resource calculation. |
| Base image, OS, kernel, libc, allocator, container runtime, platform, or CPU architecture/class change | Environment parity capture; compatibility; Rails baseline; complete performance/resource/admission/restart evidence. |
| CPU quota/burst/scheduling or memory/swap/OOM limit change | Cgroup verification; Rails baseline if affected; concurrent matrix; safety stops; budget calculation; admission ceiling and overload/recovery evidence. |
| Puma workers/threads/preload/fork/pools or process colocation change | Rails baseline; cross-worker authority/accounting; process failure/restart; concurrent matrix; topology and budget constraints. |
| Container count/load balancing/autoscaling/rollout change | Traffic distribution, scale/restart/surge tests, deployment throughput estimate, monitoring/runbook; retain per-container admission validation. |
| Authentication traffic, route inventory, or threat pattern change | Legitimate/hostile-after-defense model; mixed/burst workloads; queue/rejection behavior; monitoring and capacity review. |
| Authentication Defense design/configuration/store/proxy change | Pre-hash enforcement, outage/atomicity/route coverage, permitted hostile traffic model, dummy behavior, and integrated overload test. |
| SLO, timeout, availability, or public failure-contract change | Latency/queue acceptance analysis, overload behavior, resource controlling constraint, monitoring/alert proposal, and Owner decision. |
| HashingAdmission Interface, Adapter, fairness, queueing, deadline, accounting, or failure semantics change | All section 4 properties; integrated load; budget; monitoring; restart/recovery; no-bypass/fallback inspection. |
| Credential profile/input/dummy/upgrade behavior change | Exact tuple/encoding, create/correct/wrong/dummy/rehash workloads, compatibility, budget, timing/security behavior, and migration/revalidation decision. |
| Relevant security guidance/advisory or observed saturation/error/OOM incident | Impact assessment; affected compatibility/security/performance scenarios; resource budget; remediation/retest; separate Owner disposition. |

The revalidation record must identify unchanged evidence that remains applicable and justify it. It must not claim blanket reuse based only on a prior pass.

## 8. Explicit unresolved-decision register

| Unresolved item | Current status | Evidence required | Decision owner | Separate Owner approval required? |
|---|---|---|---|---|
| Production Argon2 profile | `UNRESOLVED`; P64-4 is preferred validation candidate only | Complete section 6 package and comparison with P64-1/2 | Owner | Yes |
| Production `p_cost` | `UNRESOLVED` | Same-memory/time P64 lane comparison under production parity | Owner | Yes |
| Production Argon2 dependency integration | `UNRESOLVED`; `argon2` 2.3.3 tested only in isolated spike | Production-target compatibility, maintenance/advisory, provenance, Rails fork/thread/restart, and integration plan | Owner | Yes |
| HashingAdmission Adapter/implementation | `UNRESOLVED` | Intended Puma topology, option comparison, section 4 correctness/failure evidence, and operational ownership | Owner | Yes |
| Numeric queue size | `UNRESOLVED` | Traffic/SLO/resource model, fairness, memory, saturation, and recovery evidence | Owner | Yes |
| Numeric waiting deadline | `UNRESOLVED` | End-to-end timeout/SLO, queue/service distributions, cancellation, and user-impact evidence | Owner | Yes |
| Numeric concurrency/admission limit | `UNRESOLVED` | Completed section 5 calculation and section 4 cross-worker evidence | Owner | Yes |
| Runtime reserve and safety headroom | `UNRESOLVED` | Repeated Rails/runtime variance, failure/restart observations, OOM policy, measurement uncertainty, incident/recovery model, and sensitivity analysis | Owner with operations input | Yes |
| Retry policy and interval | `UNRESOLVED` | Abuse/availability/enumeration analysis, client behavior, SLO, and overload evidence | Owner | Yes |
| HTTP response contract/code | `UNRESOLVED` | API error review, generic-state proof, retry semantics, monitoring, and client behavior | Owner | Yes |
| PIN hashing profile and validation | `OUT_OF_SCOPE` for AF-OWNER-001E and `UNRESOLVED` | PIN pepper/device/defense design plus separate profile, POS latency/capacity, and attack evidence | Owner | Yes |
| Production monitoring metrics/thresholds | `UNRESOLVED` | Metrics/redaction design, baseline distributions, alert simulation, runbooks, and named owner | Owner with operations input | Yes |
| Production resource quotas and Puma topology | `UNKNOWN` and unapproved | Deployment selection, capacity/SLO evidence, rollout/restart design | Owner with operations input | Yes |
| Production use and implementation authorization | `NOT_AUTHORIZED` | Required security evidence, resolved/remediated findings or explicit permissible risk decisions, ADR gates, and separate milestone authorization | Owner | Yes |

No row is resolved by creation of this plan.

## 9. Planned execution and review sequence

1. Supply and approve the deployment/traffic/SLO inventory needed to freeze the protocol.
2. Prepare isolated, non-application validation artifacts and the immutable production-parity environment manifest; dependency integration remains separately unauthorized.
3. Freeze and hash the benchmark, sampling, safety-stop, and aggregation protocol before execution.
4. Execute the isolated diagnostic matrix, then the Rails/Puma production-parity matrix only under separate authorization.
5. Validate HashingAdmission properties using the future selected experimental harness without treating its values as production policy.
6. Assemble the evidence package and independently reproduce aggregates from raw artifacts where practical; the review remains Owner-led and non-independent.
7. Apply the resource method, record limitations, and prepare separate production-decision proposals.
8. Owner explicitly approves, rejects, or requests more evidence for each unresolved production/implementation decision. A benchmark pass is not approval.

## 10. Governance and completion boundary

- IDs 29–34 remain `OWNER_CONFIRMED`, `SECURITY_REVIEW_REQUIRED` within their recorded scope.
- AF-OWNER-001D remains `OWNER_APPROVED_WITH_SCOPE_LIMITATIONS`.
- AF-OWNER-001 remains `OWNER_REVIEW_IN_PROGRESS`.
- FIND-001 through FIND-009 remain `OPEN`; this plan supplies no remediation/retest evidence.
- Independent verification remains `NOT_PERFORMED`; legal/privacy review remains `NOT_PERFORMED`.
- No residual risk is accepted.
- ADR-0006 remains Proposed; ADR-0008 remains Proposed.
- Milestone 2B remains `NOT AUTHORIZED`.
- No benchmark was executed and no production value, profile, dependency, Adapter, queue behavior detail, implementation, or production use was approved.

AF-OWNER-001E is complete when this plan and its links/structure are validated. Execution of the plan is a future, separately authorized milestone.
