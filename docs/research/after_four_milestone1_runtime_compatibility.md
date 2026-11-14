# AFTER FOUR — Milestone 1 runtime compatibility verification

**Evidence date:** 2026-11-14  
**Scope:** Ruby 3.4.12 versus Ruby 4.0.9 for Rails 8.1.4.1, PostgreSQL adapter/native gems, Bundler, tests, lint/security tools, and CI/deployment inputs. No application was scaffolded by this research.

## Decision recommendation

Select:

- Ruby `3.4.12`;
- Rails `8.1.4.1`;
- Bundler `2.6.9` for the initial lockfile;
- PostgreSQL major `18`, with `pg 1.7.0` as resolved by Rails' `~> 1.1` constraint.

This combination is sufficiently supported for Milestone 1. Ruby 4.0.9 is not rejected as incompatible: the complete resolved dependency set declares support for it, and an exact official Ruby 4.0.9 container installed and loaded the same stack successfully. It is deferred because Rails 8.1 predates Ruby 4.0's stable release and is already in security-only maintenance. Ruby 3.4 remains in normal maintenance, and the final application checks succeeded on exact Ruby 3.4.12 with PostgreSQL 18.7.

## Official lifecycle and compatibility evidence

### Ruby

- The official [Ruby releases page](https://www.ruby-lang.org/en/downloads/releases/) lists Ruby 4.0.9 and 3.4.12, both released on 2026-10-23. The [Ruby download page](https://www.ruby-lang.org/en/downloads/) lists 4.0.9 as current stable and 3.4.12 as a maintained stable release.
- The official [maintenance branches page](https://www.ruby-lang.org/en/downloads/branches/) places both Ruby 4.0 and 3.4 in normal maintenance on the evidence date.
- Rails' official [upgrade guide](https://guides.rubyonrails.org/upgrading_ruby_on_rails.html#ruby-versions) says Rails 8.0 and 8.1 require Ruby 3.2.0 or newer. The installed Rails 8.1.4.1 gemspec independently declares `required_ruby_version >= 3.2.0`.

Both candidates therefore meet Rails' declared minimum. The choice of 3.4 is a compatibility-risk decision, not an assertion that Rails cannot run on Ruby 4.0.

### Rails

- Rails announced [8.1.4.1 as a security release](https://rubyonrails.org/2026/11/4/Rails-8.0.5.2-and-8.1.4.1-have-been-released) on 2026-11-04 and strongly recommends it because it addresses multiple security issues.
- The official [Rails maintenance policy](https://rubyonrails.org/maintenance) and support announcement identify Rails 8.1 bug-fix support through 2026-10-10 and security support through 2027-10-10. General bug-fix support has therefore ended; production launch needs an explicit upgrade checkpoint.
- Rails 8.2 is not used because it remains an alpha on the evidence date.

Rails 8.1.4.1 is the only evidence-backed stable Rails 8.1 patch for this review, but its support horizon is a known limitation rather than a reason to choose an untested preview.

### PostgreSQL and `pg`

- The accepted database baseline remains PostgreSQL 18. Official [PostgreSQL versioning policy](https://www.postgresql.org/support/versioning/) recommends the current minor for a supported major.
- The upstream [`pg` README](https://github.com/ged/ruby-pg) requires Ruby 3.1+ and PostgreSQL 10+. RubyGems lists [`pg 1.7.0`](https://rubygems.org/gems/pg/) with Ruby `>= 3.1`, and publishes precompiled arm64/x86_64 macOS and glibc/musl Linux packages.
- The actually resolved `pg 1.7.0` gem declares Ruby `>= 3.1, < 4.1.dev`, so it admits both 3.4.12 and 4.0.9. Its arm64-darwin binary installed and loaded successfully in the local check; it reported embedded libpq `18.6`.

The local `psql`/`pg_config` is PostgreSQL 17.12, so a PostgreSQL 18 server connection was not proven by the research task. Milestone 1 must provision PostgreSQL 18 and run the connection, schema dump/load, and readiness tests against it.

## Actual dependency-resolution evidence

### Method

A temporary Gemfile reproduced the Rails 8.1.4.1 API/PostgreSQL generator family without creating application files:

- `rails = 8.1.4.1`;
- `pg ~> 1.1` and `puma >= 5.0`, matching the installed Rails generator;
- `solid_cache`, `solid_queue`, and `bootsnap`;
- development/test `debug`, `bundler-audit`, `brakeman`, and `rubocop-rails-omakase`.

Bundler 2.6.9 resolved and installed 93 gems on CRuby 3.4.8/arm64 macOS. Native or platform-sensitive components installed and loaded: `pg`, Puma, Bootsnap/Msgpack, Nokogiri, JSON, BigDecimal, Racc, Nio4r, WebSocket Driver, debug, Date, IO Console, and RBS.

Key resolved versions:

| Component | Resolved | Declared Ruby requirement | Ruby 4.0.9 admitted? | Verification |
|---|---:|---|---:|---|
| Rails / Railties | 8.1.4.1 | `>= 3.2.0` | Yes | Loaded; Rails reports 8.1.4.1 |
| pg | 1.7.0 | `>= 3.1, < 4.1.dev` | Yes | Binary installed/loaded |
| Puma | 8.0.3 | `>= 3.0` | Yes | Native extension installed/loaded |
| Bootsnap | 1.26.1 | `>= 2.7.0` | Yes | Native extension installed/loaded |
| Solid Queue | 1.7.2 | `>= 3.2` | Yes | Resolved with Rails 8.1 |
| Solid Cache | 1.0.10 | no restrictive minimum | Yes | Resolved with Rails 8.1 |
| Minitest | 6.1.0 | `>= 3.2` | Yes | Resolved as Rails test dependency |
| RuboCop Rails Omakase | 1.1.0 | no restrictive minimum | Yes | RuboCop command ran |
| Brakeman | 8.1.0 | `>= 3.2.0` | Yes | Version command ran |
| bundler-audit | 0.9.3 | `>= 2.0.0` | Yes | Version command ran |
| Nokogiri | 1.19.7 | `>= 3.2, < 4.1.dev` | Yes | Platform binary installed/loaded by Rails dependencies |
| Msgpack | 1.8.7 | `>= 2.5` | Yes | Native extension installed |

The upstream [Solid Queue gemspec](https://github.com/rails/solid_queue/blob/main/solid_queue.gemspec) requires Ruby 3.2+ and Rails 7.1+, and its releases test Rails 8.1. The [Bootsnap project](https://github.com/rails/bootsnap) supports macOS/Linux and documents Ruby 4 cache keys, but its writable cache directory remains an operational requirement.

Direct `require "solid_queue"` before Active Model is initialized raises because Solid Queue is a Rails engine, not a standalone library. Loading it after `active_model`/`active_record`, as a Rails application does, succeeded; this is not a runtime incompatibility.

## Bundler, test, lint, and security tooling

- RubyGems' official [Bundler compatibility guide](https://bundler.io/compatibility.html) says Bundler 2.6 supports Ruby 3.1+ and RubyGems 3.3.3+. Bundler 2.6.9 is installed locally, resolved the dependency graph, and installed it successfully. Pin it in `Gemfile.lock` initially; review upgrades through normal dependency maintenance.
- Rails' generated test stack resolved Minitest 6.1.0, which declares Ruby 3.2+ and accepts Ruby 4.0.9. The older locally global Minitest 5.25.4 had `< 4.0`, demonstrating why the lockfile—not global gems—must determine compatibility.
- RuboCop 1.92.2 with RuboCop Rails Omakase 1.1.0 ran under Ruby 3.4.8 and analyzed as Ruby 3.4.
- Brakeman 8.1.0 and bundler-audit 0.9.3 loaded and reported versions under the resolved bundle. The foundation should run both in CI, while recognizing that bundler-audit's advisory database refresh requires network access.

## Ruby 4.0.9 comparison

Ruby 4.0.9 has the longer language-line future and is officially stable. Every resolved direct/native-sensitive gem above declares a Ruby range that includes 4.0.9, including the explicit `< 4.1.dev` bounds from pg and Nokogiri. Minitest 6 removes the older `< 4.0` ceiling.

The exact Ruby 4.0.9 container check resolved, compiled, installed, and loaded Rails, `pg`, Puma, Bootsnap, Solid Queue, RuboCop, Brakeman, and bundler-audit. This proves current installation compatibility, not the same maturity as operating the project on that interpreter over time. Selecting Ruby 4 now would combine a new interpreter major with a security-only Rails line and make any interpreter/framework edge case harder to remediate. Reconsider Ruby 4 with a stable Rails line tested against it, or in a dedicated compatibility CI job after Milestone 1.

## CI and deployment compatibility

- Pin `.ruby-version` to 3.4.12, Rails in `Gemfile.lock`, and Bundler in the lockfile's `BUNDLED WITH` section. CI must fail on drift.
- Test on PostgreSQL 18, not the local PostgreSQL 17 service and not SQLite. Add lockfile platforms for the actual deployment CPU/libc (for example `x86_64-linux` or `aarch64-linux`) so Bundler resolves platform gems before deployment.
- The official Ruby image/selected platform must provide Ruby 3.4.12. Source-built native gems require a compiler and headers; the resolved pg and Nokogiri platform binaries reduce that burden but should not be assumed for an unlisted deployment platform.
- Bootsnap requires a writable cache directory. Web and Solid Queue worker processes must use the same application/lockfile version, while their database pool sizes are configured independently.
- No hosting target is approved by ADR-0008, so this review cannot certify a specific provider image, CPU architecture, TLS boundary, or worker supervisor. That is not a Milestone 1 local-development blocker.

## Maintenance policy

1. Recheck official Ruby/Rails security and maintenance pages before scaffolding, each production release, and scheduled dependency review.
2. Keep exact Ruby 3.4.12 and Rails 8.1.4.1 pinned and rerun dependency install, application boot, native gem load, tests, RuboCop, Brakeman, and bundler-audit on dependency changes. Do not rely on globally installed gems.
3. Apply compatible Ruby/Rails patch and PostgreSQL minor/security updates after CI and staging validation. Commit the lockfile; never float production resolution.
4. Create an upgrade checkpoint before production because Rails 8.1 security support ends in 2027. Evaluate the next stable Rails line and Ruby 4 together rather than postponing until support expiry.
5. Treat Ruby or Rails major/minor changes as ADR reviews. Patch updates within the accepted lines remain maintenance changes unless compatibility evidence contradicts the decision.

## Conclusion

There is no critical dependency incompatibility on Ruby 3.4.12 + Rails 8.1.4.1. Exact Ruby 3.4.12 and Ruby 4.0.9 container checks installed and loaded the dependency/native stack. The selected Ruby 3.4.12 application also booted, prepared and round-tripped its SQL schema, connected to PostgreSQL 18.7, passed its test/lint/security checks, and served liveness/readiness responses. Ruby 4.0.9 remains a viable future compatibility target but is not the most maintainable initial production baseline for this Rails 8.1 foundation.
