---
proposal_package_id: AF-OWNER-001G
owner_review_id: AF-OWNER-001
document_status: DECISION_PROPOSALS_ONLY
owner_approval_status: NOT_APPROVED
candidate_decision_ids: ID-35 through ID-39
production_environment_status: NOT_SELECTED
implementation_status: NOT_AUTHORIZED
independent_verification: NOT_PERFORMED
legal_review: NOT_PERFORMED
---

# AF-OWNER-001G: Owner Deployment Direction Proposals

**Assessment type:** Owner-led, non-independent decision preparation  
**Prepared:** 2026-11-14  
**Decision boundary:** Production deployment direction and planning inputs only  
**Related:** [Decision Register](../../after_four_identity_decision_register.md) · [AF-OWNER-001 Assessment](af-owner-001-password-pin-security.md) · [AF-OWNER-001C.3 Capacity Validation](af-owner-001c3-argon2id-capacity-validation.md) · [AF-OWNER-001D](af-owner-001d-argon2-owner-decision-proposals.md) · [AF-OWNER-001E](af-owner-001e-production-parity-validation-plan.md) · [AF-OWNER-001F](af-owner-001f-production-deployment-inputs-discovery.md) · [Foundation Decisions](../../after_four_foundation_decisions.md) · [ADR-0008](../../adr/0008-deployment-environments.md)

This package prepares five decisions for the Owner. It records no Owner approval. `ID-35` through `ID-39` are the next available identifiers as of preparation and are proposal placeholders only: they are not reserved or canonical Decision Register rows. Recheck the register before recording any later approval.

No provider, production platform, resource value, traffic forecast, service objective, or operational assignee is selected here. Approval of a direction would not prove that a deployed environment has the stated properties and would not authorize Identity implementation, Argon2 production use, or Milestone 2B.

## 1. Evidence boundary

### 1.1 Established evidence

- Accepted foundation decisions establish a Rails modular monolith, Ruby 3.4.12, Rails 8.1.4.1, Bundler 2.6.9, PostgreSQL 18, and the repository structure. They do not establish production hosting.
- Decision Register ID-17 requires one HTTPS origin through a managed edge, a private Rails origin, explicit trusted proxies, Host Authorization, and non-sensitive health output. It does not select a provider, domain, network, or proxy chain.
- [ADR-0008](../../adr/0008-deployment-environments.md) proposes separated environments, immutable promotion, readiness checks, roll-forward, and named operational ownership. It remains Proposed and deliberately does not mandate Kubernetes or a cloud vendor.
- [`backend/compose.yml`](../../../../backend/compose.yml) and [`backend/Dockerfile.development`](../../../../backend/Dockerfile.development) are development facilities. They define no production limits, topology, rollout, edge, managed database, or monitoring service.
- [`backend/config/puma.rb`](../../../../backend/config/puma.rb) contains configurable framework defaults. Those values are not an approved production process topology.
- [AF-OWNER-001C.3](af-owner-001c3-argon2id-capacity-validation.md) measured an isolated aarch64 Linux container with 2 CPUs, 1.5 GiB memory, and no swap. It was not Rails, production, or a provider specification.
- IDs 29–34 approve only a validation candidate and resource/admission/revalidation methodology. They approve no production Argon2 or PIN profile, numeric limit, queue, deadline, reserve, headroom, deployment, or implementation.

### 1.2 Unknowns that recommendations cannot fill

There is no evidence of a production provider, budget, region, CPU class, container limit, database service, image, workload, service objective, staffing model, or support arrangement. Cost observations below are therefore qualitative. No price or current provider capability is asserted.

## 2. Proposal summary

| Candidate ID | Group | Recommended direction | Status |
|---|---|---|---|
| `ID-35` | A — Provider and deployment shape | Managed container platform, managed PostgreSQL, and managed edge/TLS; select the provider separately against evidence-based criteria. | `NOT_APPROVED` |
| `ID-36` | B — Resource and process envelope | Evidence-first sizing with explicit per-container limits, measured Rails baseline, simple initial topology hypotheses, and provider-plus-load-test confirmation. | `NOT_APPROVED` |
| `ID-37` | C — Initial launch demand | One launch forecast and one credible planning upper bound, including time-correlated authentication bursts and a review horizon. | `NOT_APPROVED` |
| `ID-38` | D — Experience and availability objectives | Separate measurable objectives for POS reauthentication, back-office authentication, credential lifecycle flows, and general API availability. | `NOT_APPROVED` |
| `ID-39` | E — Operational ownership | A named Owner/accountable risk approver, Operations Primary, and backup/escalation role with explicit control ownership before production. | `NOT_APPROVED` |

## 3. Candidate ID-35 — provider and deployment shape

**Status:** `NOT_APPROVED`  
**Decision question:** Which vendor-neutral deployment shape should constrain later provider selection and production-parity validation?

### Current evidence and constraints

The application is an internal multi-branch café POS and management system, but its Identity, scale, traffic, and availability needs are not implemented or measured. ID-17 already requires a managed edge and private Rails origin. PostgreSQL 18 is the accepted database major. ADR-0008 requires environment separation, repeatable artifacts, readiness, and operational owners while leaving the hosting mechanism open.

### Alternatives

| Option | Advantages | Disadvantages | Security and operations | Cost and complexity |
|---|---|---|---|---|
| **A1. Managed container platform + managed PostgreSQL + managed edge/TLS** | Explicit image and container boundaries; usually gives a usable path to resource controls, replicas, rollouts, private services, and portable application packaging. Fits ID-17 without requiring cluster administration. | Platform-specific quotas, network behavior, observability, and rollout semantics still require verification. Some lock-in remains around managed services and deployment APIs. | Provider must demonstrate private origin networking, trusted-proxy evidence, secret injection, logs/metrics/alerts, backups/restore, and effective resource-limit behavior. The Owner still owns application controls and response. | Moderate operational burden. Managed services add recurring cost but avoid much database, TLS, and host maintenance. Actual cost cannot be compared without traffic, region, support, and resource inputs. |
| **A2. Managed application platform + managed PostgreSQL + managed edge/TLS** | Lowest deployment burden if the platform directly supports the Rails runtime and managed lifecycle. May simplify builds, certificates, logging, and releases. | May obscure CPU scheduling, memory/OOM behavior, immutable image details, proxy chain, or multi-process topology needed by AF-OWNER-001E. Runtime customization and portability can be narrower. | Accept only if the platform exposes enough evidence to enforce ID-17, ID-30, ID-31, and ID-34. Hidden or shared resource behavior can block production-parity conclusions. | Potentially low initial operational complexity; platform convenience can carry a price premium or scaling surprises. No price conclusion is available. |
| **A3. Self-managed VM/container deployment** | Maximum control over runtime, resource policy, proxy chain, process topology, and observability. Broad hosting portability. | Owner must patch hosts, harden networks, operate TLS/proxies, monitor capacity, secure backups, restore service, and manage failures. This creates a large single-operator burden. | Direct control makes evidence observable but also transfers nearly all infrastructure and incident risk to the Owner. Current repository has no operational system or coverage supporting this burden. | High setup and continuing operations complexity. Infrastructure price alone would omit substantial maintenance and incident cost. |
| **A4. Self-managed container orchestrator** | Strong control over placement, scaling, rollout, and isolation at larger scale. | Adds cluster, network, policy, upgrade, and control-plane complexity unsupported by current evidence. ADR-0008 expressly avoids mandating Kubernetes. | Enlarges attack surface and operational scope before a requirement demonstrates benefit. | Highest complexity among these options; deferred unless later scale or platform requirements justify it. |

### Recommendation and rationale

Recommend **A1** as the deployment-shape direction. It creates a clear container boundary for the ID-30 HashingAdmission authority, permits production-parity image and cgroup evidence, and delegates database/edge lifecycle work without introducing cluster administration. This is a selection criterion, not a provider recommendation.

A provider should be selected later only if evidence shows it can supply:

- PostgreSQL 18 or an explicitly compatible, supportable PostgreSQL 18 service;
- fixed and inspectable CPU/memory limits, scheduling semantics, OOM/restart behavior, and supported CPU architecture;
- private Rails origin networking behind the ID-17 managed edge, with an explicit trusted-proxy chain and Host Authorization support;
- immutable application artifacts, readiness-aware rollout, graceful shutdown, rollback/roll-forward mechanics, and separate environments;
- secret injection and rotation controls, production access control, auditability, and redaction-compatible logging;
- metrics, alerts, log retention controls, backup/restore facilities, support escalation, and exportability; and
- enough evidence to execute AF-OWNER-001E without treating marketing descriptions as measured behavior.

### Unknowns

Provider, region, residency constraints, budget, support level, production domain, database availability/recovery objectives, image registry, edge product, secrets facility, and actual provider capabilities remain unknown.

### Proposed approval wording — not approved

> `ID-35` — The Owner selects a managed container deployment shape with managed PostgreSQL and a managed HTTPS edge terminating one origin in front of a private Rails origin. Provider selection requires documented evidence against the AF-OWNER-001G criteria. This direction does not select a vendor, approve resource values, make ADR-0008 Accepted, or authorize provisioning or implementation.

**Approval scope:** Deployment shape and provider-selection criteria only.  
**Exclusions:** Provider/vendor, account, contract, region, price, resource size, service tier, topology, SLO, production readiness, implementation, or residual-risk acceptance.

### Consequence for AF-OWNER-001E

Approval would narrow the target shape, but AF-OWNER-001E remains blocked until a real candidate platform, immutable image, resource envelope, proxy/network configuration, and deployed evidence exist. A1 does not make any production input verified.

## 4. Candidate ID-36 — resource and process envelope method

**Status:** `NOT_APPROVED`  
**Decision question:** What method should determine container resources, Rails/Puma topology, replicas, database pools, and HashingAdmission budget inputs?

### Alternatives

| Option | Advantages | Disadvantages and failure modes |
|---|---|---|
| **B1. Evidence-first smallest viable topology** | Minimizes unknown interactions; makes Rails baseline, per-hash cost, connection use, and per-container admission authority observable. Supports increasing one dimension at a time. | Needs measurement before a numeric choice. A topology that is too small can have insufficient resilience or burst capacity and must not be treated as approved merely because it is simple. |
| **B2. Provider template/default sizing** | Fast to start and may suit generic Rails workloads. | Defaults are not AFTER FOUR workload evidence, can hide burst/quota semantics, and cannot determine safe HashingAdmission limits. |
| **B3. Large vertically provisioned, multi-worker containers first** | May provide early headroom and fewer replicas. | Multiplies Rails baseline and connection usage; worker-local controls cannot satisfy ID-30; large failure units and CPU contention can obscure the actual constraint. |
| **B4. Many small replicas with aggressive autoscaling first** | Reduces individual failure domains and can spread traffic. | Autoscaling lag does not protect local memory or authentication latency; database connections and minimum capacity can dominate. Local admission remains mandatory. |

### Recommended method

Recommend **B1**, using this order:

1. Freeze a candidate provider, CPU architecture/class, immutable image, dependencies, effective CPU/memory/swap/OOM policy, and colocated processes.
2. Treat one Puma worker per web container and separate web/job containers as **initial measurement hypotheses**, not approved production values. Compare alternatives where resilience, throughput, connection use, or platform behavior requires them.
3. Measure repeated Rails idle and representative non-hashing peaks, including logging, session, database, monitoring, and other colocated runtime cost.
4. Set explicit runtime reserve and safety headroom proposals. Use ID-31 to calculate memory, CPU, latency, and topology constraints; do not infer a concurrency number from nominal RAM alone.
5. Validate P64 at one, two, and four lanes as required by ID-32. The P64-4 candidate remains preferred for validation, not predetermined as production winner.
6. Implement no HashingAdmission here. A future design must use one authoritative limit across every relevant Puma worker within a container and must not depend on worker-local counters.
7. Verify database connection demand as `web replicas × workers × effective thread/pool demand`, plus jobs, migrations, consoles, and operational reserve. The exact formula and limits must be reconciled with the chosen database service.
8. Test fixed replica behavior, restart/rollout overlap, and any proposed autoscaling. Autoscaling may improve aggregate capacity but cannot relax the per-container admission ceiling.
9. Present measured resource values, topology, admission limit, wait/rejection behavior, and headroom as a separate Owner approval. Revalidate under ID-34 after material change.

### Value classification

| Value class | Examples | Authority needed |
|---|---|---|
| Initial sizing hypothesis | One web worker; separate web/job container; initial provider size tested first | May guide experiments only; not production approval |
| Provider-confirmed | CPU architecture/class, cgroup quotas, burst/scheduling, memory, swap/OOM, rollout and restart semantics | Provider documentation plus in-container/deployment evidence |
| Load-test measured | Rails baseline, latency distributions, throughput, memory/CPU peaks, DB connections, saturation | Reproducible production-parity run |
| Production-approved | Limits, worker/thread count, replica bounds, pool sizes, admission count, reserve/headroom | Explicit Owner decision after evidence |

### Security, operational, cost, and complexity implications

Explicit isolation reduces the chance that Argon2 memory competes invisibly with jobs or unrelated processes. A simple topology improves diagnosis, but insufficient replicas can harm availability. More workers/replicas increase baseline memory, database connections, deployment cost, and cross-process complexity. Larger containers may reduce orchestration but increase failure impact. No choice can be optimized without Groups C and D.

### Unknowns

All numeric resource values; Puma threads/workers; job placement; database pool; replica minimum/maximum; autoscaling; rollout surge; Rails baseline; provider quota semantics; demand; objectives; and admission Adapter/number/queue/deadline remain open.

### Proposed approval wording — not approved

> `ID-36` — The Owner approves the AF-OWNER-001G evidence-first method for selecting production container resources and process topology. Development defaults and provider templates are hypotheses only. Every numeric resource, Puma, replica, database-pool, reserve/headroom, and HashingAdmission value requires provider evidence, production-parity measurement, and separate explicit approval. HashingAdmission must remain authoritative across all relevant Puma workers within each container.

**Approval scope:** Sizing and validation method only.  
**Exclusions:** Any numeric value, provider size, Puma topology, replica/autoscaling/rollout policy, database pool, admission mechanism, or implementation.

### Consequence for AF-OWNER-001E

Approval defines how inputs 1–14 contribute to the benchmark but supplies none of their production values. It permits planning a comparison after Group A and provider evidence are available; it does not authorize a run or make its result production-approved.

## 5. Candidate ID-37 — initial launch demand framework

**Status:** `NOT_APPROVED`  
**Decision question:** What minimum demand forecast should the Owner approve for sizing and authentication validation?

### Alternatives

- **C1. Single expected forecast:** simplest, but fragile when launch usage or burst timing differs.
- **C2. Expected launch forecast plus credible planning upper bound:** captures ordinary and foreseeable growth without pretending to be a statistical forecast.
- **C3. Broad scenario catalog:** may expose more possibilities, but creates false precision and maintenance burden before product usage exists.

### Recommendation and minimal Owner input

Recommend **C2**. Supply aggregate counts only; no personal data is needed.

| Input | Launch forecast | Planning upper bound / review horizon |
|---|---|---|
| Branches operating | Owner-supplied | Owner-supplied horizon and upper bound |
| Employees and expected active users | Owner-supplied, distinguishing enrolled from active where useful | Owner-supplied |
| Concurrent POS devices | Owner-supplied normal and peak | Owner-supplied |
| Concurrent back-office users | Owner-supplied normal and peak | Owner-supplied |
| Login and reauthentication | Expected normal rate plus the largest credible time-correlated burst | Opening, shift change, closing, restart, and reconnect scenarios |
| Credential creation/reset/recovery | Expected ordinary rate plus a bounded administrative burst | Staff onboarding, forced replacement, and recovery event assumptions |
| Hostile traffic reaching hashing | Not a business forecast | Separately bounded only after Authentication Defense behavior is designed |

Record assumptions, source, date, confidence, and trigger for revision. Do not substitute illustrative ranges for Owner forecasts. Compare later telemetry to the forecast without logging credentials or unnecessary personal data.

### Security, operational, cost, and complexity implications

Underestimating bursts can cause capacity exhaustion exactly when POS access is operationally important. Gross overestimation can cause unnecessary spend and can hide inefficient controls. A bounded upper case allows safe testing while preserving the rule that hostile raw edge traffic is controlled before hashing. Forecast maintenance should be lightweight and tied to branch, device, staffing, or authentication-flow changes.

### Unknowns

Every count, rate, burst duration, timing pattern, growth horizon, forecast confidence, and post-defense hostile arrival model remains unknown.

### Proposed approval wording — not approved

> `ID-37` — The Owner approves maintaining a dated launch demand forecast and credible planning upper bound for branches, active employees, concurrent POS devices, back-office users, authentication lifecycle operations, and time-correlated login/reauthentication bursts. Values and assumptions are recorded separately and reviewed when branch, staffing, device, flow, or observed-demand conditions materially change. This framework approves no forecast value.

**Approval scope:** Forecast structure and revision triggers only.  
**Exclusions:** Counts, rates, growth claims, hostile traffic, capacity, or resource approval.

### Consequence for AF-OWNER-001E

Owner-supplied values would resolve the planning assumptions for legitimate demand, while hostile-after-defense demand remains dependent on the later defense design. Both still require executable load models and measured results.

## 6. Candidate ID-38 — experience and availability objective framework

**Status:** `NOT_APPROVED`  
**Decision question:** What measurable objective structure should govern authentication and general API behavior without inventing numeric SLOs?

### Alternatives

- **D1. One application-wide latency/availability objective:** easy to communicate, but conceals the different operational impact of POS reauthentication, back-office login, credential lifecycle flows, and ordinary API requests.
- **D2. Small flow-class objective set:** measurable and tied to user impact while remaining manageable.
- **D3. Per-endpoint objectives:** precise but premature and costly to operate before routes and usage stabilize.

### Recommendation

Recommend **D2** with four classes:

| Flow class | Objective dimensions to approve later | Reason |
|---|---|---|
| POS authentication/reauthentication | End-to-end p50/p95/p99, bounded wait/timeout, temporary-unavailable rate, recovery time, and operational fallback expectations | A delay can block an employee on a shared POS and has the highest immediate café impact. |
| Back-office authentication and step-up | End-to-end percentiles, timeout, temporary-unavailable rate, and recovery | Important but generally less time-critical than active POS operation. |
| Enrollment, password reset, PIN replacement, and recovery | Completion latency/availability, failure atomicity, and recovery expectations | These flows may perform hashing and lifecycle changes but differ from routine verification. |
| General authenticated API | Availability, latency, and error-budget measures excluding planned maintenance where explicitly defined | Establishes the non-authentication operating baseline needed to interpret incidents. |

For each class, later Owner approval should define the measurement boundary, percentile window, target, availability denominator, planned-maintenance treatment, maximum bounded wait, generic exhaustion outcome, detection interval, and recovery objective. Server-side service time and admission wait must be measured separately as diagnostic components while the user objective remains end-to-end.

Capacity exhaustion must preserve ID-33: bounded deadline-limited waiting followed by a generic temporary-unavailable outcome, with no unbounded queue, admission bypass, or cheaper Argon2 fallback. Exact HTTP status, response body, retry behavior, deadline, queue size, concurrency, and alert threshold remain unapproved. Client behavior must not reveal whether an account or credential exists.

### Incident-severity direction

A later runbook should use impact-based tiers rather than infrastructure-only thresholds:

- highest urgency for widespread inability to authenticate/reauthenticate on operating POS devices, credential-control bypass, or credible credential compromise;
- elevated urgency for sustained authentication degradation, repeated capacity exhaustion, or significant back-office access loss; and
- routine investigation for contained, transient degradation within approved objectives.

This is a qualitative proposal. Names, numeric thresholds, paging windows, and response times require Owner/operations approval.

### Security, operational, cost, and complexity implications

Separate classes protect the POS experience from being averaged away and constrain admission behavior with business impact. More stringent objectives require more minimum capacity, monitoring, testing, and operational response. Overly loose objectives harm café operations; unjustifiably tight objectives increase cost and on-call load. Metrics must avoid usernames, credential material, secrets, or unnecessary personal data.

### Unknowns

All numeric latency, availability, rejection, wait, timeout, detection, incident, and recovery targets; maintenance treatment; client behavior; status/retry contract; and monitoring implementation remain open.

### Proposed approval wording — not approved

> `ID-38` — The Owner approves separate measurable experience and availability objective classes for POS authentication, back-office authentication, credential lifecycle/recovery, and the general authenticated API. Each class requires later explicit numeric objectives and measurement definitions. Capacity exhaustion remains bounded and generic under ID-33; no HTTP status, retry behavior, deadline, queue, threshold, or objective value is approved by this direction.

**Approval scope:** Objective classes, measures to define, and qualitative incident-impact ordering only.  
**Exclusions:** Any SLO/SLA value, HTTP contract, retry policy, incident response time, monitoring tool, production configuration, or residual-risk acceptance.

### Consequence for AF-OWNER-001E

Approval supplies the structure for inputs 17–18 but not the numeric gates required for a decision-grade benchmark. Those values must be chosen before the protocol is frozen.

## 7. Candidate ID-39 — operational ownership

**Status:** `NOT_APPROVED`  
**Decision question:** What is the minimum viable responsibility model for production operation under current Owner-led governance?

### Alternatives

| Option | Advantages | Disadvantages and risk |
|---|---|---|
| **E1. Owner alone for all duties** | Clear authority and minimal coordination. | Single point of failure, no guaranteed absence coverage, weak separation of duties, and high incident/maintenance burden. Owner-led security review is not professional operations coverage. |
| **E2. Named Owner/accountable approver + Operations Primary + backup/escalation role** | Maintains clear Owner authority while ensuring operational tasks and absence/escalation paths are explicitly assigned. One person may initially hold more than one role if the concentration risk is recorded. | Still requires schedules, runbooks, access control, drills, and provider support; independence is not created merely by assigning names. |
| **E3. External managed operations/security service** | Could add coverage and specialized capability. | No service is selected, budgeted, or approved; outsourcing does not transfer Owner accountability or automatically provide independent verification. |

### Recommendation

Recommend **E2** as the minimum before production. Record a named human or contracted function for every responsibility and a backup/escalation path for high-impact duties.

| Responsibility | Accountable minimum | Required evidence before production |
|---|---|---|
| Risk and production approval | Owner | Signed decision scope, unresolved-risk record, and go/no-go authority |
| Deploy, migration, rollback/roll-forward | Operations Primary; Owner accountable | Release runbook, access control, rehearsal, migration/rollback boundary, and audit trail |
| Monitoring and alert response | Operations Primary with backup/escalation | Dashboards, actionable alerts, notification test, triage runbook, and coverage expectation |
| Incident command and communications | Named incident lead; Owner accountable | Severity model, contact/escalation tree, containment/recovery procedure, and drill |
| Database backup and restore | Named database/operations role plus provider escalation | Backup configuration evidence, access control, restore test, and approved recovery objectives |
| Secrets custody and rotation | Owner-approved custodian with backup/recovery path | Inventory, least privilege, rotation/compromise/loss procedures, audit evidence, and recovery test |
| Security incident response | Owner plus named technical responder | Credential/session containment, evidence preservation, notification decision path, and retest procedure |
| Provider support escalation | Operations Primary and backup | Support entitlement, contacts, severity path, account recovery, and outage procedure |
| Capacity change and ID-34 revalidation | Owner accountable; Operations Primary executes evidence collection | Change triggers, benchmark/revalidation runbook, approval record, and monitored post-change check |

If one person holds Owner, Operations Primary, and incident roles, record the concentration, absence, credential-recovery, and fatigue risks. Provider automation/support may reduce effort but is not a substitute for a named accountable person. Independent verification and legal review remain `NOT_PERFORMED`.

### Security, operational, cost, and complexity implications

Named roles reduce unowned failures and make privileged access reviewable. Backup coverage and drills require time or paid support. External coverage could improve availability but adds procurement, access, privacy, and vendor-management complexity. A single-person model is cheaper administratively but has a material continuity risk that cannot be described as professional coverage.

### Unknowns

Assignees, availability windows, support contract, access model, escalation contacts, recovery objectives, backup/restore owner, monitoring tools, incident communications, and workload remain open.

### Proposed approval wording — not approved

> `ID-39` — Before production, the Owner will record a named Owner/accountable risk approver, Operations Primary, and backup/escalation role, and will assign deployment, database recovery, monitoring, incident, secrets, provider-escalation, capacity, and ID-34 revalidation duties. One person may hold multiple roles only when concentration and absence risks and an escalation/recovery path are documented. This direction does not claim independent verification or professional operations coverage.

**Approval scope:** Minimum responsibility model and assignment gate only.  
**Exclusions:** Named assignees, staffing/service purchase, coverage hours, support vendor, access grants, runbook acceptance, legal compliance, independent verification, or residual-risk acceptance.

### Consequence for AF-OWNER-001E

Approval would define who must own evidence and decisions, but the input remains unresolved until roles are actually assigned and the monitoring, incident, and revalidation artifacts exist and are tested.

## 8. Cross-decision dependencies and recommended sequence

```text
Group C demand forecast ─┐
                        ├──> Group D measurable objectives
Owner risk tolerance ───┘                 │
                                          ├──> Group A provider/platform selection
Group E operating capacity ───────────────┘                 │
                                                            ├──> Group B resource/process experiments
Provider facts ──────────────────────────────────────────────┘                 │
                                                                              └──> AF-OWNER-001E execution
```

Recommended sequence:

1. Approve or revise the Group C forecast framework and supply the initial aggregate forecast. In parallel, approve or revise the Group D objective framework and provide its numeric targets.
2. Approve or revise Group E and assign at least the people/functions responsible for provider evaluation, testing, deployment, monitoring, and incident response.
3. Approve or revise Group A's vendor-neutral shape; evaluate real providers against C, D, E, ID-17, ADR-0008, and the evidence criteria. Record provider selection as a separate decision.
4. After provider facts are available, use Group B to propose and measure resource/process alternatives. Approve production values separately after AF-OWNER-001E evidence.
5. Finalize operational tooling, access, runbooks, recovery objectives, and revalidation ownership before production acceptance.

The proposal frameworks may be decided before a provider. Actual provider, resource/process values, numeric objectives, forecasts, and assignees cannot remain open for a decision-grade production-parity run. ADR-0008 cannot be made Accepted by this package because its provider, secrets, release, worker, monitoring, backup, recovery, maintenance, and escalation gates are not satisfied.

## 9. Mapping of all 20 AF-OWNER-001E inputs

Owner approval resolves a policy choice only where shown; it never changes an input to verified without the listed evidence.

| # | AF-OWNER-001E production input | Decision group(s) / candidate ID(s) | Owner direction needed | Provider/deployment evidence | Measurement and finalization point |
|---:|---|---|---|---|---|
| 1 | CPU architecture and model/class | A / `ID-35`; B / `ID-36` | Select candidate platform/architecture policy | Actual exposed CPU/model/topology | Capture inside candidate container; freeze before run |
| 2 | Container CPU quota and scheduling/burst semantics | A / `ID-35`; B / `ID-36` | Select resource policy | Effective cgroup quota plus provider scheduling/burst behavior | Verify under load; approve limit after comparison |
| 3 | Container memory limit | A / `ID-35`; B / `ID-36` | Select candidate limit using ID-31 | Manifest and effective cgroup limit | Measure baseline/peak/OOM margin; approve after evidence |
| 4 | Swap and OOM behavior | A / `ID-35`; B / `ID-36`; E / `ID-39` | Select acceptable failure/restart behavior and owner | Effective swap/OOM/restart policy | Controlled non-production observation and runbook validation |
| 5 | Runtime, OS, kernel, libc, allocator, base-image digest | A / `ID-35`; B / `ID-36` | Select packaging/runtime policy | Immutable image and platform/runtime evidence | Capture manifest/SBOM/runtime; revalidate on change |
| 6 | Ruby, Rails, Bundler versions and build | B / `ID-36` | Preserve accepted ADR-0002 baseline; approve material change separately | Immutable build provenance | Runtime/build capture; ID-34 revalidation on change |
| 7 | Argon2 gem/native dependency and build | B / `ID-36` | Separate integration/production decision; none granted here | Target-image dependency/linkage evidence | Compatibility and production-parity tests; separate approval |
| 8 | Puma worker/thread/process topology | B / `ID-36`; C / `ID-37`; D / `ID-38` | Approve topology after demand/objective evidence | Deployed process/env/boot evidence | Compare topology; prove container-wide admission; separately approve |
| 9 | Rails non-hashing baseline and peak | B / `ID-36`; C / `ID-37` | Approve representative workload definition | Candidate resources and colocated process inventory | Repeated idle/representative peaks; use in ID-31 calculation |
| 10 | Database/session/logging/monitoring dependencies | A / `ID-35`; B / `ID-36`; E / `ID-39` | Select dependency topology and owners | Enabled configuration, service limits, private network | Measure latency/resource/connection effect; freeze for run |
| 11 | Web/job process colocation | B / `ID-36`; E / `ID-39` | Approve isolation/placement | Deployment/process manifests and cgroups | Include all colocated processes in baseline and failure tests |
| 12 | Application container counts | B / `ID-36`; C / `ID-37`; D / `ID-38` | Approve minimum/desired/maximum after demand/objectives | Deployment and observed placement | Load/availability tests; separately approve replica policy |
| 13 | Autoscaling signals, bounds, and lag | A / `ID-35`; B / `ID-36`; C / `ID-37`; D / `ID-38`; E / `ID-39` | Decide whether to autoscale and who responds | Platform policy/capability and actual configuration | Controlled scale-event test; do not relax local admission |
| 14 | Rollout, restart, and surge behavior | A / `ID-35`; B / `ID-36`; D / `ID-38`; E / `ID-39` | Approve release strategy and owner | Readiness, graceful shutdown, surge/unavailable, restart evidence | Rehearse release/restart; ADR-0008 remains Proposed meanwhile |
| 15 | Legitimate authentication traffic | C / `ID-37` | Supply launch forecast and upper bound | None beyond platform capacity interface | Convert to privacy-safe reproducible workload; revise from telemetry |
| 16 | Hostile attempts after Authentication Defense | C / `ID-37`; D / `ID-38` | Approve bounded post-defense threat model later | Edge/proxy/limiter topology and trustworthy client-address path | Integrated defense/load tests after implementation; cannot finalize now |
| 17 | Authentication latency SLOs | C / `ID-37`; D / `ID-38` | Approve numeric flow-class objectives | Monitoring clock/metric capability | Measure end-to-end and wait/service p50/p95/p99; gate result |
| 18 | Availability/rejection objectives | D / `ID-38`; E / `ID-39` | Approve numeric objective and recovery ownership | Platform failure/restart behavior | Exhaustion and recovery tests; HTTP/retry contract remains separate |
| 19 | Rate-limiting/authentication-defense behavior | A / `ID-35`; D / `ID-38`; E / `ID-39` | Separate technical/numeric approvals still required | Trusted proxy, edge, distributed store/outage topology | Positive/negative/concurrency/outage tests after implementation |
| 20 | Monitoring and operational ownership | A / `ID-35`; E / `ID-39` | Assign roles, objectives, escalation, and revalidation owner | Provider telemetry/support/access evidence | Alert/notification/runbook/incident/restore tests before acceptance |

## 10. Decisions and information still required from the Owner

The Owner must explicitly:

1. approve, revise, or reject each proposed direction `ID-35` through `ID-39`;
2. provide Group C's aggregate launch forecast and credible upper bound;
3. provide Group D's numeric objectives and measurement definitions;
4. assign Group E roles/functions and decide acceptable coverage and escalation;
5. authorize a later provider evaluation and separately select a provider/platform; and
6. after provider evidence and AF-OWNER-001E measurements, approve or reject the numeric Group B production envelope and any Argon2/admission parameters.

No credentials, secret values, employee identities, or customer data belong in these decisions.

## 11. Governance and unchanged boundaries

- Decision Register IDs 01–34 are unchanged. `ID-35` through `ID-39` are unapproved placeholders only.
- AF-OWNER-001D remains `OWNER_APPROVED_WITH_SCOPE_LIMITATIONS`.
- AF-OWNER-001 remains `OWNER_REVIEW_IN_PROGRESS`; `FIND-001` through `FIND-009` remain `OPEN`.
- Independent verification and legal/privacy review remain `NOT_PERFORMED`.
- ADR-0006 and ADR-0008 remain Proposed.
- Milestone 2B remains `NOT AUTHORIZED`.
- P64-4 remains only the preferred password candidate for production-parity validation. No production Argon2 profile, PIN profile, or `p_cost` is approved.
- No queue size, deadline, concurrency/admission limit, resource reserve, safety headroom, HTTP status, retry behavior, provider, forecast value, SLO, or operational assignee is approved.
- Production revalidation under ID-34 remains mandatory and cannot substitute for separate production approval.
- Owner-led review is non-independent. Nothing here claims security, professional operations coverage, legal compliance, or production readiness, and no residual risk is accepted.

## 12. Package conclusion

The repository supports a vendor-neutral recommendation toward managed containers, managed PostgreSQL, and a managed edge, coupled with evidence-first sizing and explicit operational ownership. It does not support choosing a provider or numeric production configuration. The next valid action is explicit Owner review of the five proposals and provision of the Group C–E inputs—not provisioning, implementation, or production benchmarking.
