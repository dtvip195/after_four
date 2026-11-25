# AFTER FOUR Backend Testing Standards

**Status:** Accepted backend development standard  
**Date:** 2026-11-14  
**Runtime:** Ruby 3.4.13, Rails 8.1.4.1, PostgreSQL 18.7, RSpec Rails 8.1.0

## Official framework

RSpec is the only supported primary testing framework for the Rails backend. New backend tests use RSpec syntax and live under `backend/spec/`. Do not add a parallel Minitest suite, `test_helper`, or `bin/rails test` workflow. Minitest may remain in `Gemfile.lock` as a transitive Rails dependency; it is not an application testing interface.

## Naming and organization

Name files `*_spec.rb` and describe externally meaningful behavior in plain language. Require `rails_helper` except for the narrow pure-Domain exception below. `rails_helper` loads `spec_helper` first so SimpleCov starts before application code.

Pure Domain specs that exercise framework-independent Value Objects, Aggregates, Domain Services, or Domain errors may require `spec_helper` instead. Pure Application specs may also do so when they load only framework-independent Application use cases and owned ports, Domain source, Ruby standard-library dependencies, and explicit in-memory fake adapters. This preserves executable Rails-free Domain/Application paths and catches accidental framework coupling. These specs must not load Rails, Active Record, ApplicationRecord, PostgreSQL adapters, jobs, controllers, or other Infrastructure/Presentation code. Infrastructure, persistence, integration, compatibility-facade, service, request, model, and job specs continue to require `rails_helper`.

- `spec/models/`: persistence behavior, validations, associations, scopes, and model-owned invariants.
- `spec/requests/`: routing, HTTP status, serialization, authentication/authorization, error envelopes, and request boundaries.
- `spec/services/`: commands, calculations, orchestration, and domain/platform services through their public interface.
- `spec/jobs/`: enqueueing contracts, idempotency, retry behavior, and observable job outcomes.
- `spec/integration/`: infrastructure integration that does not belong to an application model, such as the PostgreSQL connection contract.
- `spec/domains/<context>/domain/`: pure Domain behavior and invariants through Domain interfaces.
- `spec/domains/<context>/application/`: Application orchestration through owned ports; use pure fakes where no framework capability is involved.
- `spec/domains/<context>/infrastructure/`: mappings, adapters, database constraints and transaction behavior.
- `spec/factories/`: factories for real application records only.
- `spec/support/`: reusable configuration or helpers only after at least two specs need them; support files must not end in `_spec.rb`.

Do not create empty directories, placeholder factories, artificial models, or tables to satisfy a folder convention.

## Expectations and scenarios

Test business and API outcomes rather than private method calls. Include relevant success, failure, validation, authorization, boundary, concurrency, and edge cases. A regression fix should have a focused example that fails for the defect and passes for the correction.

Request specs exercise real routing, middleware, controllers, and serialization. Service specs call the public service interface. Job specs distinguish enqueueing from execution and make retry/idempotency behavior explicit. Model specs use Shoulda Matchers only for conventional Rails declarations; custom invariants require behavioral examples.

## FactoryBot and Faker

FactoryBot syntax methods are available without the `FactoryBot.` prefix. Prefer persisted records when database behavior, constraints, scopes, or authorization matter; use `build` for behavior that does not require persistence.

Factories contain valid minimal defaults and model relationships, not scenario-specific business decisions. Prefer traits over deeply nested factories. Faker may provide realistic incidental values, but exact values must be supplied for boundaries and assertions. Do not make a deterministic expectation depend on Faker's global random sequence.

## Mock and stub boundaries

Do not mock internal calculations, domain rules, Active Record models under test, or collaborations that can be exercised cheaply in-process. Prefer real database records and real domain objects.

Test doubles are appropriate at explicit infrastructure boundaries such as payment providers, email/SMS gateways, clocks, filesystem/network clients, or a deliberately unavailable database connection. Use verifying doubles and the narrowest possible stub. RSpec restores stubs after each example; any manual subscription or external resource must still be released with `ensure`.

## Database isolation

RSpec uses Rails transactional fixtures. Each database-writing example runs in a transaction that is rolled back after the example. DatabaseCleaner is not installed because the current suite has no behavior that escapes Rails transactions.

If future browser, multi-process, or worker tests cannot share the example transaction, document the demonstrated failure before proposing another cleanup strategy. Specs must not depend on execution order, identifiers created by another example, or residue in the test database.

## Running specs

From `backend/`, using the reproducible Docker environment:

```bash
docker compose up -d database
docker compose run --rm backend bin/rails db:prepare
docker compose run --rm backend bundle exec rspec
docker compose run --rm backend bundle exec rspec spec/requests/health_endpoints_spec.rb
docker compose run --rm backend bundle exec rspec spec/requests/health_endpoints_spec.rb:4
```

With the repository's exact Ruby and PostgreSQL client installed locally, remove the `docker compose run --rm backend` prefix.

RSpec randomizes example order and prints its seed. Re-run a failure with `--seed NUMBER`. Every spec file must pass alone and as part of the complete suite.

## Coverage

SimpleCov starts before Rails application code and writes the HTML report to `backend/coverage/index.html`. A complete suite run prints line and branch coverage. Coverage is diagnostic: there is no arbitrary minimum threshold yet. A percentage must not substitute for meaningful outcome, failure, authorization, or boundary cases.

## Determinism and independence

- Freeze or inject time when exact time affects an outcome.
- Supply explicit random/Faker values when assertions depend on them.
- Never call real third-party services from the suite.
- Keep the PostgreSQL major aligned with production and CI.
- Release notification subscribers and other process-global state even when an expectation fails.
- Ensure examples pass individually, in randomized order, and in the complete suite.

## Milestone 1 migration accounting

The original Minitest suite contained eight tests and reported 31 assertions. RSpec preserves those eight scenarios with 27 explicit expectations and adds one expectation that directly verifies transactional database isolation, for nine examples and 28 expectations in total. No predicate was removed: Minitest counts `assert_empty`, `assert_match`, and each of the two `assert_not_includes` calls as two assertions internally, whereas each equivalent RSpec matcher is one expectation. Adding duplicate expectations solely to preserve a framework-specific counter would reduce clarity without increasing coverage.
