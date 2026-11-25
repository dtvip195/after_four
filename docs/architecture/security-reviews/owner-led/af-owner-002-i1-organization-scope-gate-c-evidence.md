---
assessment_id: AF-OWNER-002
historical_review_id: null
owner_review_status: OWNER_REVIEW_IN_PROGRESS
independent_verification: NOT_PERFORMED
legal_review: NOT_APPLICABLE_TO_TECHNICAL_SUBSCOPE
assessment_start_date: 2026-11-15
assessment_completion_date: null
---

# AF-OWNER-002: I1 Organization Scope Gate C Evidence

**Record status:** Evidence capture completed; Owner Gate C review pending
**Execution completion recorded:** 2026-11-16T00:02:35+0900 JST
**Assessor identity/role:** Organization Owner/operator (role-based; personal name not supplied)
**Owner is also developer:** Yes
**Independent verification:** `NOT_PERFORMED`
**Legal review:** `NOT_APPLICABLE_TO_TECHNICAL_SUBSCOPE`
**Canonical design and governance:** [I1 Organization Scope Contract Technical Design](../../after_four_i1_organization_scope_contract_design.md)
**Protocol:** [Owner-Led Identity Review Protocol](../../after_four_identity_owner_led_review_protocol.md)

This record retains the bounded evidence authorized by the Owner for the I1 Organization Scope implementation. It is an Owner-led, non-independent evidence record. It does not grant Gate C Control Acceptance, accept residual risk, change ADR-0006 or Identity Security Review Checklist status, grant Final Operational Acceptance, authorize production, or authorize any later Identity or Catalog milestone.

## 1. Scope and baseline

| Field | Actual value |
|---|---|
| Repository | AFTER FOUR |
| Branch | `main` |
| Tested HEAD | `b0994b84dc15417ec225f546ca53842042012f6b` |
| I1 implementation checkpoint | `dd5b3804a1db55fbc05b3f5f33142462ad29de5e` |
| Checkpoint ancestry | Verified as an ancestor of tested HEAD; command exit `0` |
| Initial working tree | Clean |
| Test execution environment | Repository Docker Compose `backend` service; `RAILS_ENV=test` |
| Database service | Existing `postgres:18.7` service reported healthy; no service was started by the evidence commands |
| Database identifier | `sha256:c326ef121217b235` |
| Database adapter | PostgreSQL; Active Record `8.1.4.1`; `pg` `1.7.0` |
| PostgreSQL server | `18.7 (Debian 18.7-1.pgdg13+2)` |
| Transaction isolation | `read committed` |
| Schema guard | Current; zero pending migrations |

The initial Git and database preflight ran before the Owner/operator attestation. The exact initial wall-clock time was not captured; the session date was 2026-11-15 JST. Per-command elapsed durations and the completion timestamp are retained below.

## 2. Disposable-database attestation

On 2026-11-16, after the Group B preflight succeeded and before any RSpec command ran, the Owner/operator supplied this statement verbatim:

> I confirm that the currently configured PostgreSQL database is a disposable local/test database and contains no development data, production data or personal data. I authorize the approved RSpec commands to perform only their existing transaction-scoped synthetic test DML in this database.

The attestation is the authority for test-only synthetic DML. `test_database_guard=true`, the `_test` naming condition, database health, schema-current status, and zero pending migrations are supporting safeguards and are not substitutes for the attestation.

## 3. Requirement and evidence map

| Criterion | Requirement | Evidence | Result | Limitation |
|---|---|---|---|---|
| `I1-GC-01` | Exact bounded I1 specs pass in the approved PostgreSQL test environment | `EVID-I1-005` | `PASS` | Owner-led execution; no independent verification |
| `I1-GC-02` | Relevant existing A1 ancestry constraints execute successfully | `EVID-I1-006` | `PASS` | Five selected examples only; no broader A1 suite |
| `I1-GC-03` | Application eager-loads under Zeitwerk | `EVID-I1-007` | `PASS` | Focused command, not full CI |
| `I1-GC-04` | Exact 21-file manifest has no RuboCop offenses | `EVID-I1-008` | `PASS` | Scoped lint only |
| `I1-GC-05` | Test database, schema, version, and isolation safeguards pass before RSpec | `EVID-I1-002`–`EVID-I1-004` | `PASS` | Operator attestation is role-based; no personal name recorded |
| `I1-GC-06` | Source/spec/configuration/Git state remains unchanged by evidence capture | `EVID-I1-001`, `EVID-I1-009` | `PASS` | Approved evidence document creation occurs after the clean post-command check |

## 4. Evidence manifest

| Evidence ID | Type | Artifact/environment | Result | Retention |
|---|---|---|---|---|
| `EVID-I1-001` | Git baseline | `main` at `b0994b84...`; I1 checkpoint `dd5b3804...` | Clean; correct branch; ancestry verified | Raw output §5.1 |
| `EVID-I1-002` | Database service | Existing Compose PostgreSQL service | Healthy | Raw output §5.2 |
| `EVID-I1-003` | Environment/schema preflight | Docker backend; test database | Passed after one sandbox-permission retry | Raw output §5.3 |
| `EVID-I1-004` | Owner/operator attestation | Role-based Owner/operator statement | Supplied before RSpec | Verbatim statement §2 |
| `EVID-I1-005` | Focused I1 RSpec | Four authorized spec files | 36 examples, 0 failures; seed 47081 | Raw output §5.4 |
| `EVID-I1-006` | Focused A1 RSpec | Five authorized schema examples | 5 examples, 0 failures; seed 8748 | Raw output §5.5 |
| `EVID-I1-007` | Eager load | Zeitwerk | Passed | Raw output §5.6 |
| `EVID-I1-008` | Static analysis | Exact 21-file RuboCop manifest | 21 files, no offenses | Raw output §5.7 |
| `EVID-I1-009` | Final Git check | Repository root | Clean; HEAD unchanged; whitespace check passed | Raw output §5.8 |

## 5. Commands, raw outputs, exit statuses, and durations

### 5.1 Initial Git state — `EVID-I1-001`

Working directory: repository root.

```bash
git status --short
git rev-parse HEAD
git branch --show-current
git merge-base --is-ancestor dd5b3804a1db55fbc05b3f5f33142462ad29de5e HEAD
```

Output:

```text
# git status --short: no output
b0994b84dc15417ec225f546ca53842042012f6b
main
# merge-base ancestry command: no output
```

Exit status: `0`
Elapsed duration: `0.104` seconds

### 5.2 Existing database health — `EVID-I1-002`

Working directory: `backend/`.

```bash
docker compose ps database
```

Output:

```text
NAME                 IMAGE           COMMAND                  SERVICE    CREATED        STATUS                  PORTS
backend-database-1   postgres:18.7   "docker-entrypoint.s…"   database   31 hours ago   Up 12 hours (healthy)   0.0.0.0:55432->5432/tcp, [::]:55432->5432/tcp
```

Exit status: `0`
Elapsed duration: `0.321` seconds

### 5.3 Group B read-only preflight — `EVID-I1-003`

Working directory: `backend/`.

```bash
docker compose run --rm --no-deps -e RAILS_ENV=test backend bin/rails runner '
require "digest"
require "active_record/tasks/database_tasks"

connection = ActiveRecord::Base.connection
configuration = ActiveRecord::Base.connection_db_config
database_name = connection.select_value("SELECT current_database()")
configured_database = configuration.database.to_s

test_guard =
  Rails.env.test? &&
  configuration.env_name == "test" &&
  database_name == configured_database &&
  database_name.end_with?("_test")

abort("refusing evidence capture: database is not the configured test database") unless test_guard

schema_current =
  ActiveRecord::Tasks::DatabaseTasks.schema_up_to_date?(configuration)
pending_migrations =
  connection.pool.migration_context.open.pending_migrations

abort("refusing evidence capture: test schema is not current") unless schema_current
abort("refusing evidence capture: pending migrations exist") unless pending_migrations.empty?

puts "rails_environment=test"
puts "test_database_guard=true"
puts "schema_up_to_date=true"
puts "pending_migrations=0"
puts "database_identifier=sha256:#{Digest::SHA256.hexdigest(database_name)[0, 16]}"
puts "adapter=#{connection.adapter_name}"
puts "active_record_version=#{ActiveRecord::VERSION::STRING}"
puts "pg_gem_version=#{Gem.loaded_specs.fetch("pg").version}"
puts "postgresql_server_version=#{connection.select_value("SHOW server_version")}"
puts "transaction_isolation=#{connection.select_value("SHOW transaction_isolation")}"
'
```

The first sandboxed attempt could not access the local Docker API:

```text
permission denied while trying to connect to the docker API at unix:///Users/tad/.docker/run/docker.sock
```

First-attempt exit status: `1`
First-attempt elapsed duration: `0.343` seconds

The identical authorized command was retried with Docker permission. Output:

```text
 Container backend-backend-run-d33382f229ff Creating
 Container backend-backend-run-d33382f229ff Created
rails_environment=test
test_database_guard=true
schema_up_to_date=true
pending_migrations=0
database_identifier=sha256:c326ef121217b235
adapter=PostgreSQL
active_record_version=8.1.4.1
pg_gem_version=1.7.0
postgresql_server_version=18.7 (Debian 18.7-1.pgdg13+2)
transaction_isolation=read committed
```

Retry exit status: `0`
Retry elapsed duration: `7.821` seconds

The failed first attempt was a tooling sandbox permission condition, not an application, database, schema, or control failure.

### 5.4 Group A focused I1 RSpec — `EVID-I1-005`

Working directory: `backend/`.

```bash
docker compose run --rm --no-deps -e RAILS_ENV=test backend bundle exec rspec \
  spec/domains/organization/application/queries/resolve_brand_ancestry_spec.rb \
  spec/domains/organization/infrastructure/persistence/active_record_brand_ancestry_reader_spec.rb \
  spec/domains/identity/infrastructure/adapters/organization_scope_adapter_spec.rb \
  spec/architecture/i1_dependency_spec.rb
```

Output:

```text
 Container backend-backend-run-a6945ead68d1 Creating
 Container backend-backend-run-a6945ead68d1 Created

Randomized with seed 47081
....................................

Finished in 0.09295 seconds (files took 0.82656 seconds to load)
36 examples, 0 failures

Randomized with seed 47081

Coverage report generated for RSpec to coverage/index.html
Line coverage: 378 / 952 (39.70%)
Branch coverage: 64 / 199 (32.16%)
```

Exit status: `0`
Elapsed duration: `5.210` seconds

### 5.5 Group C selected A1 constraint examples — `EVID-I1-006`

Working directory: `backend/`.

```bash
docker compose run --rm --no-deps -e RAILS_ENV=test backend bundle exec rspec \
  spec/integration/reference_foundation_schema_spec.rb:27 \
  spec/integration/reference_foundation_schema_spec.rb:62 \
  spec/integration/reference_foundation_schema_spec.rb:90 \
  spec/integration/reference_foundation_schema_spec.rb:95 \
  spec/integration/reference_foundation_schema_spec.rb:100
```

Output:

```text
 Container backend-backend-run-5fd27933859f Creating
 Container backend-backend-run-5fd27933859f Created
Run options: include {locations: {"./spec/integration/reference_foundation_schema_spec.rb" => [27, 62, 90, 95, 100]}}

Randomized with seed 8748
.....

Finished in 0.06962 seconds (files took 0.89022 seconds to load)
5 examples, 0 failures

Randomized with seed 8748

Coverage report generated for RSpec to coverage/index.html
Line coverage: 56 / 952 (5.88%)
Branch coverage: 3 / 199 (1.50%)
```

Exit status: `0`
Elapsed duration: `4.782` seconds

No unexpected isolation or cleanup behavior was observed. No manual cleanup was performed.

### 5.6 Zeitwerk — `EVID-I1-007`

Working directory: `backend/`.

```bash
docker compose run --rm --no-deps -e RAILS_ENV=test backend bin/rails zeitwerk:check
```

Output:

```text
 Container backend-backend-run-8efc4effbbea Creating
 Container backend-backend-run-8efc4effbbea Created
Hold on, I am eager loading the application.
All is good!
```

Exit status: `0`
Elapsed duration: `4.172` seconds

### 5.7 Scoped RuboCop — `EVID-I1-008`

Working directory: `backend/`.

```bash
docker compose run --rm --no-deps backend bin/rubocop \
  app/contexts/identity/application/contracts/identity_brand_reference.rb \
  app/contexts/identity/application/contracts/identity_organization_reference.rb \
  app/contexts/identity/application/contracts/organization_scope_evidence.rb \
  app/contexts/identity/application/contracts/organization_scope_result.rb \
  app/contexts/identity/application/contracts/safe_failure_reference.rb \
  app/contexts/identity/application/errors/unexpected_failure.rb \
  app/contexts/identity/application/ports/organization_scope.rb \
  app/contexts/identity/infrastructure/adapters/organization_scope_adapter.rb \
  app/contexts/organization/application/contracts/brand_ancestry.rb \
  app/contexts/organization/application/contracts/brand_reference.rb \
  app/contexts/organization/application/contracts/organization_reference.rb \
  app/contexts/organization/application/contracts/resolve_brand_ancestry_result.rb \
  app/contexts/organization/application/contracts/safe_failure_reference.rb \
  app/contexts/organization/application/errors/unexpected_failure.rb \
  app/contexts/organization/application/ports/brand_ancestry_reader.rb \
  app/contexts/organization/application/queries/resolve_brand_ancestry.rb \
  app/contexts/organization/infrastructure/persistence/active_record_brand_ancestry_reader.rb \
  spec/architecture/i1_dependency_spec.rb \
  spec/domains/identity/infrastructure/adapters/organization_scope_adapter_spec.rb \
  spec/domains/organization/application/queries/resolve_brand_ancestry_spec.rb \
  spec/domains/organization/infrastructure/persistence/active_record_brand_ancestry_reader_spec.rb
```

Output:

```text
 Container backend-backend-run-04f3e509ba40 Creating
 Container backend-backend-run-04f3e509ba40 Created
Inspecting 21 files
.....................

21 files inspected, no offenses detected
```

Exit status: `0`
Elapsed duration: `3.507` seconds

### 5.8 Final Git checks before evidence-record creation — `EVID-I1-009`

Working directory: repository root.

```bash
git diff --check
git status --short
git rev-parse HEAD
```

Output:

```text
# git diff --check: no output
# git status --short: no output
b0994b84dc15417ec225f546ca53842042012f6b
```

Exit status: `0`
Elapsed duration: `0.106` seconds

HEAD remained unchanged and the working tree remained clean after every executable evidence command. Creation of this single authorized evidence record necessarily makes this path untracked until separately reviewed and committed; it does not modify implementation, specs, schema, configuration, dependencies, or Git history.

## 6. Findings, limitations, and remediation status

| ID | Classification | Observation | Disposition |
|---|---|---|---|
| `OBS-I1-001` | Tooling observation | Initial Group B attempt was blocked by the local execution sandbox's Docker socket permission. | The identical authorized command was retried with Docker permission and passed. No remediation or control finding. |
| `OBS-I1-002` | Evidence limitation | Evidence is Owner-led and non-independent. | Preserve `independent_verification: NOT_PERFORMED`; Owner decides Gate C separately. |
| `OBS-I1-003` | Evidence artifact | Existing SimpleCov configuration generated ignored `backend/coverage/` output during both approved RSpec runs. | No tracked file changed; no cleanup was attempted. Coverage percentages are scoped-run observations, not project coverage conclusions. |
| `OBS-I1-004` | Timing limitation | Exact initial wall-clock timestamp was not captured. | Per-command elapsed durations, session start date, and completion timestamp are retained. |

No test failure, lint offense, schema guard failure, pending migration, unexpected isolation behavior, tracked source change, or I1 control defect was observed. No remediation was performed or authorized.

## 7. Completion and governance boundary

- Evidence results: 6 criteria `PASS`; 0 `FAIL`; 0 `NOT_TESTED` within the authorized capture scope.
- Owner review status: `OWNER_REVIEW_IN_PROGRESS` pending explicit Gate C evaluation.
- Independent verification: `NOT_PERFORMED`.
- Legal review: `NOT_APPLICABLE_TO_TECHNICAL_SUBSCOPE`.
- Residual-risk acceptance: `NOT GRANTED`.
- Gate C Control Acceptance: `NOT GRANTED`.
- Final Operational Acceptance: `NOT GRANTED`.
- Production authorization: `NOT GRANTED`.
- ADR-0006 remains `Proposed`.
- Identity Security Review Checklist statuses remain unchanged.
- I2, Identity Milestone 2B, P1–P3, Package C, and C1–C3 remain unauthorized.

**EVIDENCE CAPTURE ONLY — GATE C ACCEPTANCE NOT GRANTED**
