---
discovery_id: AF-OWNER-001F
owner_review_id: AF-OWNER-001
document_status: DISCOVERY_COMPLETE
production_environment_status: NOT_SELECTED
benchmark_status: NOT_EXECUTED
implementation_status: NOT_AUTHORIZED
independent_verification: NOT_PERFORMED
legal_review: NOT_PERFORMED
---

# AF-OWNER-001F: Production Deployment Inputs Discovery

**Discovery type:** Repository-evidence inventory; non-independent and documentation-only  
**Completed:** 2026-11-14  
**Scope:** The 20 production inputs required by [AF-OWNER-001E](af-owner-001e-production-parity-validation-plan.md)  
**Authority:** Decision Register IDs 29–34; no production or implementation approval  
**Related:** [Decision Register](../../after_four_identity_decision_register.md) · [AF-OWNER-001 Assessment](af-owner-001-password-pin-security.md) · [AF-OWNER-001C.2](af-owner-001c2-argon2id-compatibility-spike.md) · [AF-OWNER-001C.3](af-owner-001c3-argon2id-capacity-validation.md) · [AF-OWNER-001D](af-owner-001d-argon2-owner-decision-proposals.md) · [ADR-0006](../../adr/0006-authentication-session-topology.md) · [ADR-0008](../../adr/0008-deployment-environments.md)

No hosting/cloud provider, production container platform, production resource envelope, Puma topology, replica/autoscaling/rollout configuration, traffic model, SLO, or monitoring owner is selected in the repository. Repository Docker/Compose/Puma settings describe development or framework defaults only and are not production configuration.

No secret values were required or retained. Environment-variable names and configuration shape were inspected with sensitive values redacted.

## 1. Executive summary

The repository supplies strong foundation evidence—accepted Ruby/Rails/Bundler versions, a development container, PostgreSQL-backed local/CI workflows, generic production Rails safeguards, health endpoints, and Owner-confirmed one-origin/private-Rails direction. It supplies no deployable production topology or resource inputs suitable for production-parity benchmarking.

None of the 20 inputs is fully verified as a production value. One input has an Owner-confirmed foundation baseline, three have proposals without production approval, five depend on the future provider/platform, four have no supplied operational evidence, and seven require explicit Owner/operations choices.

| Primary current classification | Input count | Meaning here |
|---|---:|---|
| `VERIFIED_REPOSITORY_EVIDENCE` | 0 | No repository artifact proves a complete current production input. |
| `OWNER_CONFIRMED` | 1 | Runtime version baseline is approved, but production capture is still required. |
| `PROPOSED_NOT_APPROVED` | 3 | Design direction exists; production behavior/value is not approved. |
| `PROVIDER_DEPENDENT` | 5 | Cannot be resolved until a production provider/platform is selected. |
| `UNKNOWN` | 0 | More precise unresolved classifications apply to every row. |
| `NOT_PROVIDED` | 4 | Required workload/baseline evidence does not exist in the repository. |
| `OWNER_DECISION_REQUIRED` | 7 | Owner/operations must select the operating objective or topology. |
| **Total** | **20** | Every AF-OWNER-001E input is accounted for exactly once. |

## 2. Repository evidence inspected

| Repository evidence | Observed fact | Production limitation |
|---|---|---|
| [`backend/README.md`](../../../../backend/README.md) | Documents Ruby/Rails/PostgreSQL foundation, local Docker/host workflows, health endpoints, and explicitly calls Compose development-only. | Provides no production provider, image, topology, resources, ownership, or SLO. |
| [`backend/compose.yml`](../../../../backend/compose.yml) | Development backend/database services, source mount, local ports, health dependency, and persistent local database volume. | Defines no CPU/memory limits, production image, replicas, autoscaling, rollout, managed database, edge, or monitoring. Local credential values are not production evidence and were not retained here. |
| [`backend/Dockerfile.development`](../../../../backend/Dockerfile.development) | Development image derives from Ruby 3.4.12 Bookworm, installs PostgreSQL 18 client, installs the locked bundle, and starts Rails. | Explicitly a development build; no production hardening, immutable production digest, target architecture, resource policy, or Argon2 dependency. |
| [`backend/.ruby-version`](../../../../backend/.ruby-version), [`Gemfile`](../../../../backend/Gemfile), and [`Gemfile.lock`](../../../../backend/Gemfile.lock) | Pin Ruby 3.4.12, Rails 8.1.4.1, Bundler 2.6.9, Puma 8.0.3, and the current application dependency graph. No Argon2 gem is declared or locked. | Proves repository baseline, not the eventual production image/build/platform or approved Argon2 integration. |
| [`backend/config/puma.rb`](../../../../backend/config/puma.rb) | Framework configuration defaults to one worker and three threads unless environment configuration changes them. | Defaults and sample environment values are not a selected production topology. No cross-worker admission design exists. |
| [`backend/.env.example`](../../../../backend/.env.example) | Lists local database and Rails-thread environment names. | Sample values are development convenience only; no production values were copied into this report. |
| [`backend/config/application.rb`](../../../../backend/config/application.rb) | API-only Rails, UTC, SQL schema, Solid Queue, structured logging, and request tags. | No Identity, credential, session, Authentication Defense, Argon2, or HashingAdmission implementation. |
| [`backend/config/environments/production.rb`](../../../../backend/config/environments/production.rb) | Eager loading, non-local errors, assumed/forced SSL, structured stdout logs, configurable log level, health-log suppression, and production database URL shape. | Host Authorization values, trusted proxies, cache, secrets source, edge, monitoring, resources, and topology are unconfigured or external. Configuration intent is not deployed evidence. |
| [`.github/workflows/quality.yml`](../../../../.github/workflows/quality.yml) | CI runs Ruby 3.4.12/Bundler 2.6.9, PostgreSQL 18.7, schema verification, RSpec, RuboCop, Brakeman, and Bundler Audit on a hosted runner. | CI is quality evidence, not a deployment workflow or production hardware/resource profile. Sensitive CI values were not retained. |
| [ADR-0002](../../adr/0002-ruby-rails-version-baseline.md) | Accepts the Ruby 3.4.12/Rails 8.1.4.1/Bundler 2.6.9 foundation. | Requires same pinned runtime in production but does not provide the production image/build/platform. |
| [ADR-0008](../../adr/0008-deployment-environments.md) | Proposes separated environments, immutable promotion, readiness checks, roll-forward, production secret controls, and named operational ownership. | Remains Proposed; explicitly states hosting, secrets, worker topology, monitoring, backups, RTO/RPO, maintenance, and incident ownership are unapproved. |
| [Decision Register ID-17](../../after_four_identity_decision_register.md) | Owner confirms one HTTPS origin, managed edge, private Rails origin, no default CORS, explicit trusted proxies, Host Authorization, and safe health output. | No vendor, domain, DNS, exact proxy chain, network design, or operational owner is selected. |
| [Decision Register IDs 29–34](../../after_four_identity_decision_register.md) | Confirms the P64-4 validation candidate and admission/resource/revalidation direction. | No production profile, dependency, number, Adapter, implementation, or production use. |
| [AF-OWNER-001C.2](af-owner-001c2-argon2id-compatibility-spike.md) | Demonstrates `argon2` 2.3.3 on recorded aarch64 Linux and arm64 macOS environments. | Isolated compatibility is not production dependency or target-platform evidence. |
| [AF-OWNER-001C.3](af-owner-001c3-argon2id-capacity-validation.md) | Records isolated 2-CPU/1.5-GiB/no-swap aarch64 capacity observations. | Experimental limits and results are not production specifications. |

## 3. Production deployment architecture status

| Architecture item | Approved decision | Existing implementation/configuration evidence | Proposal only | Current conclusion |
|---|---|---|---|---|
| Hosting/cloud provider | None | None | ADR-0008 requires later selection | `OWNER_DECISION_REQUIRED`; no provider selected |
| Production container platform | None | Development Docker/Compose only | Containers/Kubernetes explicitly not mandated by ADR-0008 | `OWNER_DECISION_REQUIRED`; containerized production is not established |
| Production CPU/memory limits | ID-31 approves calculation method only | No deployment limits; C.3 limits are experimental | AF-OWNER-001E requires effective cgroup evidence | `PROVIDER_DEPENDENT`; no values |
| Production base image/architecture | ADR-0002 fixes runtime versions, not image/architecture | Development Bookworm image; C.2/C.3 aarch64 evidence | Immutable production artifact required | `PROVIDER_DEPENDENT`; no production image or architecture |
| Application instances | None | Development has one backend service | Deployment capacity must model replicas | `OWNER_DECISION_REQUIRED`; no count |
| Autoscaling/rollout | None | No autoscaling or deployment workflow | ADR-0008 proposes repeatable promotion/roll-forward | `OWNER_DECISION_REQUIRED`; no policy/configuration |
| Puma worker/thread topology | None | Framework defaults and a development sample only | ID-30 requires all workers share container authority | `OWNER_DECISION_REQUIRED`; no production topology |
| PostgreSQL production topology | ADR-0003 fixes PostgreSQL 18 major; ADR-0010 fixes migration/schema method | Local/CI single PostgreSQL 18.7 service | Managed/self-hosted, HA, backups, pools, and network remain open | `PROVIDER_DEPENDENT`; no production database topology |
| Network/trusted proxies | ID-17 fixes one managed edge, private Rails origin, and explicit trusted proxies | `assume_ssl`/`force_ssl` intent; no real hops/CIDRs | Technical design supplies vendor-neutral topology | `OWNER_CONFIRMED` direction; exact network is undecided |
| HTTPS termination/managed edge | ID-17 requires it | No edge/domain/TLS deployment | Vendor-neutral design only | `PROVIDER_DEPENDENT`; no vendor or termination path |
| Monitoring/alert ownership | ID-17 requires safe monitoring; ID-34 requires revalidation | Structured logs and health endpoints only | ADR-0008 and technical design list requirements | `OWNER_DECISION_REQUIRED`; no owner/tool/threshold/runbook |

## 4. Inventory of the 20 AF-OWNER-001E inputs

The classification in this table is the primary current production-input status. A row may also cite repository evidence without treating local evidence as a production value.

| # | Exact AF-OWNER-001E input | Current value/status | Evidence source | Primary classification | Confidence and limitation | Mandatory before benchmarking? | Required resolution action | Owner approval needed? |
|---:|---|---|---|---|---|---|---|---|
| 1 | CPU architecture and model/class | No production value | Development/C.2/C.3 are aarch64-specific; ADR-0008 has no platform | `PROVIDER_DEPENDENT` | High confidence that production is unset; local architecture is non-production | Yes | Select provider/platform and capture actual in-container CPU/model/topology | Yes, as part of provider/topology |
| 2 | Container CPU quota and scheduling/burst semantics | No production value; Compose has no limit | [`compose.yml`](../../../../backend/compose.yml); C.3 quota is experimental only | `PROVIDER_DEPENDENT` | High; no deployment manifest exists | Yes | Select platform/instance policy and verify effective cgroup quota/burst behavior | Yes |
| 3 | Container memory limit | No production value; Compose has no limit | [`compose.yml`](../../../../backend/compose.yml); ID-31 method | `PROVIDER_DEPENDENT` | High; host memory and C.3 limit cannot substitute | Yes | Select limit and capture deployment plus cgroup evidence | Yes |
| 4 | Swap and OOM behavior | No production policy/evidence | C.3 no-swap behavior is isolated; ADR-0008 leaves platform open | `PROVIDER_DEPENDENT` | High | Yes | Select platform and document/verify swap, OOM kill/restart, and health impact | Yes |
| 5 | Container runtime, OS, kernel, libc, allocator, and base-image digest | Development image only | [`Dockerfile.development`](../../../../backend/Dockerfile.development); C.2/C.3 environment records | `PROVIDER_DEPENDENT` | High; development Bookworm image is not a production selection | Yes | Decide production packaging/platform and produce immutable image/runtime/SBOM evidence | Yes |
| 6 | Ruby, Rails, and Bundler versions and build configuration | Ruby 3.4.12, Rails 8.1.4.1, Bundler 2.6.9 baseline approved; production build capture absent | [ADR-0002](../../adr/0002-ruby-rails-version-baseline.md), [Gemfile](../../../../backend/Gemfile), lockfile | `OWNER_CONFIRMED` | High for required versions; no confidence about future production build flags/image until captured | Yes | Carry exact baseline into immutable candidate image and record runtime/build evidence | Patch updates follow ADR policy; platform/build still needs approval |
| 7 | Argon2 gem/native dependency version and build | `argon2` 2.3.3 is isolated validation candidate; absent from application lock | [C.2](af-owner-001c2-argon2id-compatibility-spike.md), [Gemfile](../../../../backend/Gemfile), lockfile | `PROPOSED_NOT_APPROVED` | High; candidate evidence exists, production integration does not | Yes | Prepare separately authorized target-image dependency/provenance/linkage/maintenance evidence | Yes |
| 8 | Puma worker/thread/process topology | Framework default exists; production topology unset | [`puma.rb`](../../../../backend/config/puma.rb), sample environment names, ID-30 | `OWNER_DECISION_REQUIRED` | High; defaults/sample values are not production choices | Yes | Decide worker/thread/preload/fork/pool topology and capture boot/process evidence | Yes |
| 9 | Rails non-hashing baseline and peak | No measurement | AF-OWNER-001E requirement; current app has no Identity workload | `NOT_PROVIDED` | High; no production-parity run exists | Yes | Measure repeated idle and representative Rails load after environment/topology freeze | Owner must approve resulting budget, not raw observation |
| 10 | Database/session/logging/monitoring dependencies | Foundation has PostgreSQL, health, and structured logging; production dependency topology/session/monitoring absent | Rails config, ADR-0003/0010, [production config](../../../../backend/config/environments/production.rb) | `NOT_PROVIDED` | Medium-high; repository proves facilities, not enabled production topology | Yes | Inventory intended production dependencies/configuration and capture them with the run | Yes where provider/topology/control choices apply |
| 11 | Web/job process colocation | No production choice | Development README can run jobs separately; ADR-0008 worker topology open | `OWNER_DECISION_REQUIRED` | High | Yes | Decide cgroup/process placement and include every colocated process in baseline | Yes |
| 12 | Application container counts | No production minimum/desired/maximum | No deployment manifest; ADR-0008 Proposed | `OWNER_DECISION_REQUIRED` | High | Yes | Define replica policy and capture actual intended placement | Yes |
| 13 | Autoscaling signals, bounds, and lag | No policy/configuration | No deployment workflow; ADR-0008 Proposed | `OWNER_DECISION_REQUIRED` | High | Yes | Decide whether autoscaling exists and, if so, its signals/bounds/lag behavior | Yes |
| 14 | Rollout, restart, and surge behavior | Immutable promotion/readiness/roll-forward proposed; exact mechanics absent | [ADR-0008](../../adr/0008-deployment-environments.md) | `PROPOSED_NOT_APPROVED` | High for proposal, none for actual platform behavior | Yes | Approve deployment strategy and capture graceful shutdown, surge/unavailable, and restart evidence | Yes |
| 15 | Legitimate authentication traffic | No estimate | No Identity implementation or product traffic forecast in repository | `NOT_PROVIDED` | High | Yes | Supply launch forecast: branches/users, normal and peak login/reset/create patterns | Yes for planning assumptions |
| 16 | Hostile attempts after Authentication Defense | No executable model or observed traffic | Identity technical design and threat model are proposals; defense unimplemented | `NOT_PROVIDED` | High | Yes | Approve bounded threat/route model after Authentication Defense design and route inventory | Yes |
| 17 | Authentication latency SLOs | No p50/p95/p99 or timeout objectives | C.3 percentiles are observations, not SLOs | `OWNER_DECISION_REQUIRED` | High | Yes | Set end-to-end objectives separately for create/reset and verification flows | Yes |
| 18 | Availability/rejection objectives | Generic overload direction only; no availability/rejection budget | IDs 30/33 and AF-OWNER-001D/E | `OWNER_DECISION_REQUIRED` | High | Yes | Define acceptable temporary-unavailable/recovery objectives without selecting HTTP/retry details prematurely | Yes |
| 19 | Rate-limiting/authentication-defense behavior | Required by policy and technically proposed; not implemented or numerically approved | IDs 07/23/30, technical design, control specification | `PROPOSED_NOT_APPROVED` | High | Yes for integrated validation | Resolve store/keys/routes/outage behavior and separately approve/test numeric controls | Yes |
| 20 | Monitoring and operational ownership | Structured logs and health exist; production metrics/alerts/owner/runbooks absent | Production Rails config, ADR-0008, technical design | `OWNER_DECISION_REQUIRED` | High | Yes for acceptance package | Name operations/incident owner and define metrics, dashboards, alerts, and runbooks | Yes |

## 5. Inputs not discoverable from repository evidence

The repository cannot establish:

- whether the Owner has selected a provider outside the repository;
- the provider's CPU class, architecture, quota/burst, memory, swap/OOM, runtime, database, edge, or scaling behavior;
- production Puma/process/replica placement and rollout mechanics;
- launch usage, legitimate/hostile arrival patterns, or authentication SLOs;
- operational availability/rejection objectives; or
- who owns production monitoring, releases, incidents, capacity, and revalidation.

These are missing facts or decisions, not defects that local development defaults can fill.

## 6. Minimum information required from the Owner

No credentials or secret values are requested.

1. **Provider and deployment shape:** Has a production provider already been selected? Will Rails run in containers, and will PostgreSQL/edge services be managed or self-operated? This unlocks architecture, quotas, network, and image evidence.
2. **Resource and process envelope:** Intended instance/container class, CPU/memory policy, Puma workers/threads, web/job placement, replica range, autoscaling, and rollout/restart shape. This is required for the container-wide admission budget.
3. **Launch demand:** Expected initial branches/users and normal/peak password login, reset, enrollment, and hostile-after-defense patterns. Exact personal data is unnecessary; bounded aggregate estimates are sufficient.
4. **Experience and availability objectives:** End-to-end p50/p95/p99/timeout goals, acceptable bounded waiting and temporary-unavailable behavior, and recovery expectations. These control the CPU/latency side of admission.
5. **Operational ownership:** Named role responsible for deployment, monitoring/alerts, incident response, capacity changes, and ID-34 revalidation. Vendor selection is not requested by this question.

## 7. Minimum prerequisites before production-parity benchmarking

Benchmarking is not decision-grade until:

1. provider/platform and intended production architecture are selected;
2. an immutable candidate image/runtime/dependency manifest is available for every intended CPU architecture;
3. effective CPU, memory, swap/OOM, process-colocation, and Puma topology are recorded;
4. replica/autoscaling/rollout/restart behavior is documented;
5. Rails non-hashing baseline can be measured with intended database/session/logging/monitoring dependencies;
6. legitimate and hostile-after-defense traffic models and route inventory are approved;
7. authentication SLO and availability/rejection objectives are supplied; and
8. operational monitoring/revalidation ownership is named.

Until then, AF-OWNER-001E remains a valid plan but cannot produce production-selection evidence.

## 8. Governance and limitations

- IDs 29–34 remain `OWNER_CONFIRMED`, `SECURITY_REVIEW_REQUIRED` within their exact scope.
- AF-OWNER-001D remains `OWNER_APPROVED_WITH_SCOPE_LIMITATIONS`.
- AF-OWNER-001 remains `OWNER_REVIEW_IN_PROGRESS`.
- FIND-001 through FIND-009 remain `OPEN`.
- Independent verification remains `NOT_PERFORMED`; legal/privacy review remains `NOT_PERFORMED`.
- ADR-0006 remains Proposed; ADR-0008 remains Proposed.
- Milestone 2B remains `NOT AUTHORIZED`.
- No residual risk is accepted.
- This discovery inspected repository configuration only. It did not access production accounts, provider consoles, external infrastructure, or secrets.
- No benchmark, dependency change, application/deployment modification, profile selection, HashingAdmission implementation, or production approval occurred.

AF-OWNER-001F stops at discovery. AF-OWNER-001G and implementation are not authorized by this record.
