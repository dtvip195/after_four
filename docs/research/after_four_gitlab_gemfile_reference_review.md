# AFTER FOUR — Curated GitLab Gemfile Reference Review

**Document type:** External dependency reference review

**Review status:** `RESEARCH_COMPLETE — OWNER_REVIEW_REQUIRED`

**Dependency adoption:** `NOT_AUTHORIZED`

**Authentication architecture decision:** `NOT_MADE`

**Review date:** 2026-11-23

## 1. Executive summary

The complete GitLab Gemfile was reviewed as an engineering reference, not as a dependency template. The review is pinned to GitLab commit `d7b9a6176ab4e279465ba3ee09922cde2b74de47`; the retrieved Gemfile contains 819 lines and has SHA-256 `23a19fd43f115404d8ba041873caf1226cdd6e6f6cd3a453910a7b262228f9c4`.

No gem warrants unconditional adoption now. AFTER FOUR already covers its database adapter, primary test framework, factories, matchers, coverage, background jobs, and health/readiness needs. GitLab's scale, Rails version, monorepo, Redis/Sidekiq topology, authentication history, and internal forks differ materially from AFTER FOUR.

The highest-value future candidate is **Devise 5 as a conditional authentication foundation**, not GitLab's Devise 4.9 constraint. That recommendation remains subject to an Owner architecture decision and a bounded Ruby 3.4.12/Rails 8.1.4.1 spike covering API-only behavior, the proposed first-party cookie and opaque revocable-session direction in ADR-0006, Argon2id integration, recovery, and mail boundaries. Devise does not solve authorization, authoritative Organization/Brand/Branch scope, delegation, MFA policy, requester verification, or POS PIN design.

Other ranked conditional candidates are Rack::Attack, current Lockbox, one observability approach, WebMock for external adapters, and a minimal on-demand profiling toolset. WebAuthn remains a high-potential **deferred** phishing-resistant factor whose MFA, enrollment, step-up, recovery, freshness, and session-binding policy prerequisites are not yet satisfied. This report changes no dependency, architecture decision, WP-T1 artifact, Candidate E readiness status, or Gate status.

## 2. Source provenance

| Item | Verified value |
|---|---|
| Repository | `gitlabhq/gitlabhq` |
| Branch observed | `master` |
| Commit | `d7b9a6176ab4e279465ba3ee09922cde2b74de47` |
| Path | `Gemfile` |
| Retrieval date | 2026-11-23 |
| Commit-pinned source | [GitLab Gemfile at reviewed commit](https://github.com/gitlabhq/gitlabhq/blob/d7b9a6176ab4e279465ba3ee09922cde2b74de47/Gemfile) |
| Raw source | [Raw reviewed Gemfile](https://raw.githubusercontent.com/gitlabhq/gitlabhq/d7b9a6176ab4e279465ba3ee09922cde2b74de47/Gemfile) |
| Retrieved length | 819 lines |
| Retrieved SHA-256 | `23a19fd43f115404d8ba041873caf1226cdd6e6f6cd3a453910a7b262228f9c4` |

The commit was resolved from the remote `master` reference before retrieval. The immutable URL, rather than mutable `master`, controls this review. GitLab's reviewed file selects Rails `~> 7.2.3`; its `Gemfile.next` path selects `~> 8.0.0`. Neither selection proves compatibility with AFTER FOUR's Rails 8.1.4.1.

## 3. AFTER FOUR baseline inspected

Repository evidence inspected includes:

- `backend/Gemfile` and `backend/Gemfile.lock`: Ruby 3.4.12, Rails 8.1.4.1, PostgreSQL adapter `pg` 1.7.0, Puma 8.0.3, Solid Queue 1.7.2, RSpec Rails 8.1.0, FactoryBot Rails 6.5.1, Faker 3.8, Shoulda Matchers 8.0.1, SimpleCov 1.2, Bundler Audit, Brakeman, and RuboCop Rails Omakase. Bundler is 2.6.9.
- `docs/development/after_four_testing_standards.md`: RSpec is the sole primary backend test framework; transactional fixtures are the normal isolation mechanism; DatabaseCleaner is not justified without contrary evidence.
- `docs/architecture/adr/0006-authentication-session-topology.md`: `Proposed`; first-party same-site browser topology, opaque server-side sessions, secure cookie/CSRF/session requirements, and unresolved authentication implementation choices.
- `docs/architecture/adr/0007-background-jobs-and-transactional-outbox.md`: Active Job with Solid Queue and the transactional outbox are accepted; changing to Redis/Sidekiq requires measured evidence and architecture review.
- `docs/architecture/adr/0011-project-wide-layered-ddd.md`: dependencies point inward; provider and persistence integrations belong at Infrastructure boundaries.
- P1, P2, and P3 design documents: trusted identity/authorization, brand-scoped AuditEvent, and runtime database security remain separately governed; a gem cannot collapse these contracts.
- Password/PIN control and Argon2 evidence: `argon2` 2.3.3 compatibility was demonstrated in an isolated spike, but production integration and parameter safeguards are not authorized.
- Backend configuration: Action Mailer is not currently loaded; Solid Queue is configured; the test queue adapter is `:test`.

## 4. Method and limitations

The complete pinned Gemfile was inspected for declarations, version constraints, groups, `require` behavior, comments, path/vendor sources, and capability clusters. Relevant candidates were then compared with the actual AFTER FOUR dependency lock, ADRs, security designs, testing standards, and Layered DDD boundaries. Upstream compatibility claims were checked against primary project repositories or gem metadata where a recommendation depends on them.

Limitations:

- A Gemfile proves declared dependency intent, not active production usage, configuration quality, or fitness for another system.
- GitLab's constraints are not recommended AFTER FOUR versions.
- No gem was installed, resolved, benchmarked, or executed. Compatibility still requires lock-resolution and a bounded local spike after approval.
- Maintenance, license, native build, transitive dependency, advisory, and container implications must be rechecked at the time of any adoption proposal.
- This review does not approve authentication architecture, a vendor, an external identity provider, Redis, telemetry export, encryption keys, retention, or production operations.

## 5. Classification summary

The matrix contains 49 relevant candidate rows. Each row has exactly one primary classification.

| Classification | Count |
|---|---:|
| `ADOPT_CANDIDATE` | 0 |
| `CONDITIONAL_CANDIDATE` | 12 |
| `ALREADY_COVERED` | 6 |
| `ENGINEERING_PRACTICE` | 1 |
| `REJECT` | 14 |
| `DEFER` | 16 |
| **Total** | **49** |

## 6. Dependency classification matrix

`Runtime` means an ungrouped declaration unless the source specifies another group. An omitted `require` uses Bundler's normal require behavior.

| Candidate | GitLab constraint; group/load | Capability and AFTER FOUR comparison | Compatibility / impact / prerequisite | Class | Priority and recommendation |
|---|---|---|---|---|---|
| `devise` | `~> 4.9.3`; runtime | Account authentication; no current equivalent | GitLab's constraint is not the proposed version; evaluate Devise 5.0.4 on Ruby 3.4/Rails 8.1 and the proposed ADR-0006 session direction, subject to an eventual Owner decision | `CONDITIONAL_CANDIDATE` | P1: preferred future foundation, subject to §7 spike and Owner decision |
| `bcrypt` | GitLab: `~> 3.1`, `>= 3.1.14`; Devise 5.0.4: direct runtime dependency `~> 3.0` | Stock Devise database-authenticatable password hashing | Reject as AFTER FOUR password-policy recommendation; selecting stock Devise still installs bcrypt and uses it by default unless a complete alternative path is proven | `REJECT` | Review dependency presence and prove the eventual Owner-approved Argon2id path has no unintended bcrypt fallback |
| `devise-two-factor` | `~> 6.4.0`; runtime | TOTP MFA | MFA freshness/recovery/session binding remain deferred; misuse can create bypass paths | `DEFER` | Reassess only after MFA factor and recovery policy |
| `webauthn` | `~> 3.0`; runtime | WebAuthn/passkeys | Plausible phishing-resistant factor; still needs RP, enrollment, recovery, step-up, browser, and origin design | `DEFER` | Preferred factor to investigate after MFA policy, not now |
| OmniAuth/provider family | `omniauth ~> 2.1.0`; numerous SAML/OIDC/OAuth providers, some vendored | External identity federation | No provider/federation decision; provider gems expand attack and maintenance surface | `DEFER` | Select only one approved provider path when required |
| Doorkeeper family | `doorkeeper ~> 5.8, >= 5.8.1`; OIDC/device extensions | Operate an OAuth/OIDC authorization server | AFTER FOUR has no approved authorization-server requirement | `REJECT` | Do not introduce OAuth server complexity |
| Anti-bot family | `recaptcha ~> 5.12`, `akismet ~> 3.0`, `invisible_captcha ~> 2.3.0`; runtime | Public-form abuse defense | AFTER FOUR is internal and has no approved public registration/content surface; external services also add privacy/vendor concerns | `DEFER` | Reassess only for a concrete public abuse case; not a substitute for authentication rate limits |
| `rack-attack` | `~> 6.8.0`; runtime | Request throttling and blocking | Needs trusted-proxy semantics, shared/distributed cache, enumeration behavior, failure mode, and operational limits | `CONDITIONAL_CANDIDATE` | P2: strong building block after abuse-defense design approval |
| `declarative_policy` | `~> 2.2.0`; runtime | Authorization DSL/policy caching | GitLab-shaped framework risks obscuring exact capability, target, and fail-closed Application contracts | `REJECT` | Keep explicit P1/domain contracts unless measured complexity proves otherwise |
| Sidekiq family | vendored `sidekiq`; `sidekiq-cron ~> 2.4.0`; runtime | Redis-backed jobs/schedules | Solid Queue and outbox are accepted; Redis adds persistence, supervision, retry, and operations burden | `REJECT` | Current architecture already chose a fitting alternative |
| `pg` | `~> 1.6.1`; runtime | PostgreSQL adapter | AFTER FOUR locks 1.7.0; GitLab's older constraint is not a downgrade recommendation | `ALREADY_COVERED` | No action |
| `pg_query` | `~> 6.2.0`; runtime | PostgreSQL SQL parsing | No approved SQL-AST use case; native dependency/compatibility surface | `DEFER` | Add only for a concrete SQL analysis feature |
| `database_cleaner-active_record` | `~> 2.2.0`; `development,test` | Test cleanup | Transactional RSpec isolation is established; added strategies can mask transaction defects | `REJECT` | Keep current strategy unless evidence demonstrates a gap |
| `rspec-rails` | `~> 7.1.0`; `development,test` | Rails specs | AFTER FOUR uses 8.1.0 as sole primary framework | `ALREADY_COVERED` | No action; do not copy older constraint |
| `factory_bot_rails` | `~> 6.5.0`; `development,test` | Test data factories | AFTER FOUR uses 6.5.1 | `ALREADY_COVERED` | No action |
| `shoulda-matchers` | `~> 6.4.0`; `test`, `require: false` | Declarative matchers | AFTER FOUR uses 8.0.1 | `ALREADY_COVERED` | No action |
| `simplecov` | `~> 1.3`; `development,test`, `require: false` | Coverage | AFTER FOUR uses 1.2 without a threshold | `ALREADY_COVERED` | Review upgrades normally; no GitLab-driven change |
| `ffaker` | `~> 2.24`; runtime | Fake data | Faker 3.8 already covers test data; runtime declaration is inappropriate here | `REJECT` | Avoid duplicate fake-data libraries |
| `bullet` | `~> 8.0.0`; `development,test` | N+1/query warnings | Useful only once representative query paths exist; can create noise/config cost | `DEFER` | Reassess with demonstrated query-heavy workload |
| `test-prof` | `~> 1.6.0`; `test` | Suite profiling/optimization | No measured suite-performance bottleneck | `DEFER` | Add only from profiling evidence |
| `rspec-benchmark` | `~> 0.6.0`; `test` | Performance expectations | Benchmark assertions are environment-sensitive and do not replace protocols | `DEFER` | Use bounded benchmark artifacts first |
| `webmock` | `~> 3.26.0`; `test` | HTTP boundary tests | Appropriate only for authorized external adapters; must not mock internal domain behavior | `CONDITIONAL_CANDIDATE` | P2: adopt with first real HTTP integration |
| Capybara/Selenium family | `capybara ~> 3.40`; `selenium-webdriver ~> 4.21, >= 4.21.1`; `test` | Browser/system tests | Backend is API-only and frontend has its own stack; duplicates browser ownership | `REJECT` | Keep browser E2E strategy with the frontend unless separately designed |
| `benchmark-ips` | `~> 2.15.0`; `development,test`, `require: false` | Throughput microbenchmarks | Compatible purpose, but results are local and workload-specific | `CONDITIONAL_CANDIDATE` | P3: temporary/bounded performance investigation only |
| `benchmark-memory` | `~> 0.1`; `development,test`, `require: false` | Allocation/memory benchmarks | Same bounded-evidence constraint | `CONDITIONAL_CANDIDATE` | P3: add only for an approved investigation |
| `stackprof` | `~> 0.2.26`; runtime declaration, `require: false` | CPU profiling | Native/runtime implications require current-version check; should not auto-load | `CONDITIONAL_CANDIDATE` | P3: minimal CPU profiler when a real regression exists |
| `memory_profiler` | `~> 1.0`; runtime declaration, `require: false` | Ruby memory profiling | Development diagnostic, not an always-on production feature | `CONDITIONAL_CANDIDATE` | P3: pair with StackProf only when evidence warrants it |
| `derailed_benchmarks` | unpinned; `test`, `require: false` | Boot/memory investigation | No present boot/memory problem; environment-sensitive | `DEFER` | Reassess after measured baseline regression |
| `peek` | `~> 1.1`; runtime | In-page performance panels | GitLab UI pattern does not fit API-only Rails + separate React; adds runtime surface | `DEFER` | Prefer neutral telemetry/profiling if later needed |
| `lockbox` | `~> 1.4.0`; runtime | Application field encryption | Current upstream, not GitLab's old constraint, must be checked; needs classification, keys, rotation, search, redaction, and recovery design | `CONDITIONAL_CANDIDATE` | P2: best field-encryption candidate after security/privacy design |
| `attr_encrypted` | `~> 4.2`; runtime | Legacy field encryption | Overlaps Lockbox/Active Record encryption and increases migration/key risk | `REJECT` | Do not start a second encryption scheme |
| `paper_trail` | `~> 16.0`; runtime | Model version history/reification | Not append-only security evidence; GitLab constraint does not support Rails 8.1 per current upstream matrix | `REJECT` | Never substitute for explicit AuditEvent contracts |
| `sentry-rails` | `~> 5.23.0`; runtime | Error reporting | Requires vendor, data export, redaction, sampling, retention, residency, and failure policy | `CONDITIONAL_CANDIDATE` | P2: consider only after observability/privacy decision |
| `sentry-sidekiq` | `~> 5.23.0`; runtime | Sidekiq error integration | No Sidekiq architecture | `REJECT` | Not applicable to Solid Queue |
| OpenTelemetry family | unpinned; `:opentelemetry` group | Traces/metrics/log correlation | Broad adapter set and exporter backend are unselected; possible overlap with Sentry | `DEFER` | Choose one initial observability direction, not both |
| `prometheus-client-mmap` | `~> 1.6.0`; runtime, `require: 'prometheus/client'` | GitLab multiprocess metrics | Deployment-specific choice without approved monitoring topology | `REJECT` | Use a later vendor-neutral metrics design |
| `lograge` | `~> 0.5`; runtime | Compact structured request logs | Potential value, but Rails 8.1 support, semantic fields, correlation, and secret/PII redaction require proof | `CONDITIONAL_CANDIDATE` | P2: consider after logging contract |
| Flipper family | `~> 1.3.6`; runtime with AR/cache adapters | Feature flags | No approved staged-rollout or multi-environment operating model | `DEFER` | Reassess when deployment strategy demonstrates need |
| `faraday` | `~> 2`; runtime; `faraday-retry ~> 2.4` | HTTP client and retries | Useful at an external Infrastructure boundary; retries require operation-specific idempotency | `CONDITIONAL_CANDIDATE` | P2: select one client only with first external adapter |
| `sanitize` / `loofah` | `~> 7.0.0` / `~> 2.25.0`; runtime | Rich HTML sanitization | No approved rich-text/HTML input; sanitization remains context-specific | `DEFER` | Add only with an actual untrusted rich-content contract |
| CarrierWave/MiniMagick | `~> 1.3` / `~> 4.12`; runtime | Uploads/images | No approved workflow; evaluate Rails-native Active Storage first | `REJECT` | Do not import GitLab's older file stack by default |
| Prawn family | unpinned; runtime | PDF generation | No approved PDF report/receipt contract | `DEFER` | Reassess with exact layout, font, locale, and archival needs |
| `health_check` | `~> 3.0`; runtime | Health endpoint framework | Existing health/readiness endpoints cover the capability | `ALREADY_COVERED` | Do not duplicate |
| `state_machines-activerecord` | `~> 0.100.0`; runtime | AR-coupled lifecycle state machine | Conflicts with Domain-owned lifecycle rules and Infrastructure dependency direction | `REJECT` | Keep state rules in Domain and DB invariants in Infrastructure |
| `re2` | `~> 2.15`; runtime | Bounded-time regular expressions | No approved user-defined-regex feature; native dependency | `DEFER` | Reassess only if untrusted regex becomes necessary |
| `json_schemer` | `~> 2.4.0`; runtime | JSON Schema validation | Useful for a real external schema contract, not internal DTO validation by default | `CONDITIONAL_CANDIDATE` | P3: adopt only at a demonstrated integration seam |
| Mail/provider family | `mail = 2.9.0`; path/provider adapters | Mail delivery | Action Mailer is currently disabled; identity email/recovery and provider are unresolved | `DEFER` | Decide business flow and provider before dependencies |
| GitLab internal/path/fork family | many local `gems/` and `vendor/gems/` declarations | GitLab monorepo/services/tooling | Source ownership, private APIs, forks, and deployment assumptions are GitLab-specific | `REJECT` | Exclude wholesale; see §14 |
| Dependency declaration discipline | groups, `require: false`, compatibility comments, feature metadata | Engineering practice, no single gem | Adapt purpose/owner/reason records without copying GitLab-specific lints | `ENGINEERING_PRACTICE` | P1: adopt in future dependency proposals |

## 7. Authentication Recommendation — Devise

### 7.1 What Devise can own

Devise is a Warden-based Rails authentication framework. Its modules can provide database-backed credential authentication, recovery/reset tokens, confirmation, lockable account behavior, timeout behavior, remember-me behavior, controller integration, parameter handling, and mail hooks. It can substantially reduce bespoke handling of common credential lifecycle edges.

For AFTER FOUR, a future Owner-approved Devise integration could own the narrow mechanics of web-account credential authentication and selected recovery/account modules. The stock Devise 5.0.4 database-authenticatable path uses bcrypt, so an Argon2id design cannot be assumed merely by choosing Devise. Any integration must sit behind Identity Application contracts and Infrastructure adapters under ADR-0011. Domain and Application code must not depend on Devise, Warden, controllers, or Active Record.

### 7.2 Compatibility evidence

GitLab declares Devise `~> 4.9.3` while running its reviewed Rails 7.2 line. AFTER FOUR must not copy that constraint. The reproducible compatibility reference inspected here is **Devise 5.0.4**, annotated tag object `3a5e5b7c9a0cfb77f734a8bd4797f2fd7928d589`, peeled source commit `9ea459de9aec5f1217ad738c58e0d23fb9f5beaa`. The pinned [version source](https://github.com/heartcombo/devise/blob/9ea459de9aec5f1217ad738c58e0d23fb9f5beaa/lib/devise/version.rb), [gemspec](https://github.com/heartcombo/devise/blob/9ea459de9aec5f1217ad738c58e0d23fb9f5beaa/devise.gemspec), and [changelog](https://github.com/heartcombo/devise/blob/9ea459de9aec5f1217ad738c58e0d23fb9f5beaa/CHANGELOG.md) show Ruby `>= 2.7.0`, Railties `>= 7.0`, and the Devise 5 line's explicit Rails 8 and Ruby 3.4 support work.

This is upstream metadata evidence, not project compatibility proof and not an authentication architecture decision. This correction performed no local dependency resolution, installation, application boot, or runtime spike. A separately authorized bounded spike must resolve Devise 5.0.4 or a later specifically reviewed version with the exact Ruby 3.4.12/Rails 8.1.4.1 lock, boot the API-only application, and test the selected modules. GitLab's use of Devise 4.9 and Devise's upstream compatibility metadata are not such execution proof.

### 7.3 API-only Rails and React implications

AFTER FOUR's proposed browser topology is same-origin/first-party and cookie-based. Devise can participate in cookie authentication, but its API-only support is qualified and many defaults assume Rails controller, redirect, flash, route, view, and mail behavior. The spike must prove JSON failure/success semantics, CSRF behavior, cookie attributes, route exposure, no HTML/redirect leakage, and compatibility with the separate React frontend.

Token/JWT authentication is not implied. Adding a JWT companion merely to make an API “stateless” would conflict with the proposed revocable opaque-session direction and make immediate revocation harder. The choice remains an Owner-reviewed architecture decision.

### 7.4 Password, recovery, confirmation, and lockout

- Devise 5.0.4's gemspec declares `bcrypt ~> 3.0` as an unconditional direct runtime dependency. Standard dependency resolution therefore includes bcrypt even if AFTER FOUR eventually selects another active hashing algorithm. Removing that declared dependency would require altered package metadata or a fork; this review found no supported removal mechanism.
- The pinned [Devise encryptor](https://github.com/heartcombo/devise/blob/9ea459de9aec5f1217ad738c58e0d23fb9f5beaa/lib/devise/encryptor.rb) executes `require 'bcrypt'` when loaded and implements digest and comparison with BCrypt. The pinned [database-authenticatable module](https://github.com/heartcombo/devise/blob/9ea459de9aec5f1217ad738c58e0d23fb9f5beaa/lib/devise/models/database_authenticatable.rb) delegates stock password creation and verification to that encryptor. Dependency presence and the application-selected algorithm are distinct, but the stock path makes bcrypt active by default.
- AFTER FOUR must not select bcrypt as its password-hashing policy from GitLab or Devise precedent. Its documented Argon2id direction still requires an eventually Owner-approved encryptor/integration, credential creation and verification behavior, upgrade/rehash strategy, admission control, malformed-hash handling, and compatibility evidence. No safe Devise/Argon2id integration or absence of fallback has been proven.
- Recoverable can supply token mechanics, but it does not define the separate Owner recovery protocol, custodians, evidence, separation of duties, or emergency state transitions.
- Confirmable is relevant only if email identity and delivery are approved. Action Mailer is currently disabled, and no mail provider is selected.
- Lockable provides account-state mechanics, not distributed username/IP abuse defense, enumeration resistance, progressive delay, trusted-proxy handling, or rate-limit backend failure behavior.
- Devise does not design or hash employee POS PINs.

### 7.5 Session lifecycle and revocation

Devise/Warden can establish a browser-authenticated session, but Devise alone does not implement AFTER FOUR's proposed opaque session record and verifier lifecycle, immediate single/all-session revocation, session rotation, idle and absolute expiration evidence, concurrent-session monitoring, POS idle lock, or lifecycle-triggered revocation. If the Owner later approves that ADR-0006 direction, an integration would have to preserve the resulting session contract rather than silently replacing it with framework defaults.

### 7.6 MFA, WebAuthn, and federation boundaries

- `devise-two-factor` is a TOTP implementation, not the policy for enrollment, step-up, freshness, recovery, session binding, or invalidation. Its upstream documentation warns that an incorrect combination of authentication modules can permit MFA bypass. It remains `DEFER`.
- [WebAuthn Ruby](https://github.com/cedarcode/webauthn-ruby) is a plausible phishing-resistant factor, but RP/origin, enrollment, device loss, recovery, step-up, freshness, session binding, attestation, and user-verification choices remain open. It remains `DEFER`.
- OmniAuth and its providers handle external federation strategies. They do not authorize a provider, map Organization/Brand scope, or replace local authorization.
- Doorkeeper makes the application an OAuth authorization server. That is a different responsibility and is rejected for current scope.

### 7.7 Responsibilities Devise does not solve

Devise does not establish:

- operation-specific authorization or exact capabilities;
- authoritative Organization/Brand/Branch ancestry and target binding;
- ownership and delegation semantics;
- cross-Brand default deny or non-disclosure;
- requester identity verification for sensitive customer operations;
- trusted `AuthorizationContext` construction;
- audit evidence or retention/legal governance;
- MFA policy and step-up acceptance;
- employee PIN design; or
- production proxy, rate-limit, secrets, and monitoring topology.

These remain explicit Domain/Application/security contracts. Generic role names must never become implicit authority merely because a framework exposes them.

### 7.8 Testing and customization cost

Adoption would require focused request/integration tests for JSON and cookies, CSRF, session fixation/rotation, revocation, recovery tokens, account lifecycle, enumeration-resistant errors, mail boundaries, MFA bypass attempts, and authorization separation. The credential suite must prove which encryptor is used for creation and verification, the eventual approved Argon2id upgrade/rehash behavior, malformed/unsupported-hash handling, and that no unintended bcrypt fallback occurs. Framework upgrades and bcrypt's continued dependency-tree presence would require security-advisory and behavioral review. Heavy overrides of Devise controllers/models could erase its maintenance advantage.

### 7.9 Recommendation and decision condition

**Recommendation:** classify **Devise 5 as `CONDITIONAL_CANDIDATE` and the preferred authentication foundation for future Owner consideration**, rather than starting with a wholly custom credential stack.

This is optimal only if the bounded spike shows that Devise modules can remain behind Identity boundaries while remaining compatible with the proposed ADR-0006 opaque-session and first-party-cookie direction, and with an eventually Owner-approved Argon2id, recovery, and failure contract, using limited overrides. The spike must account for bcrypt as a direct dependency and default implementation. It offers mature credential/recovery mechanics and a larger security review surface than bespoke implementations.

Choose a smaller custom Rails authentication implementation instead if the eventual session topology, Argon2 admission control, Owner recovery, and JSON behavior demand pervasive Devise overrides or parallel state machines. Because the stock Devise package declares bcrypt directly, removing bcrypt from the resolved dependency tree would require altered packaging or a fork and its associated ownership/security maintenance; that trade-off requires explicit Owner consideration rather than an unsupported workaround. The Owner must decide the architecture after the spike; this report does not make that decision.

## 8. Authorization and permission management

GitLab's `declarative_policy` is designed around GitLab's policy graph, subject classes, conditions, caching, and large authorization surface. AFTER FOUR's P1 direction requires trusted identity, authoritative target binding, exact Brand and capability, authority source, delegation interval, revalidation, and fail-closed/non-disclosing outcomes. An extra policy DSL would risk turning those explicit contracts into hidden framework convention.

The recommendation is to retain small operation-specific Application ports and Domain authorization semantics. If future policy volume creates measurable repetition or inconsistent evaluation, compare alternatives against P1 using representative operations. Authentication libraries must remain separate from this authorization decision.

## 9. Background jobs and database integrity

ADR-0007 already selects Active Job, Solid Queue, and transactional outbox semantics. GitLab's vendored Sidekiq and `sidekiq-cron` reflect Redis-backed operations at GitLab scale. [Sidekiq upstream](https://github.com/sidekiq/sidekiq) requires a Redis-compatible durable job store and introduces separate persistence, supervision, retry, observability, and failure modes. It offers no current advantage sufficient to supersede ADR-0007.

PostgreSQL remains the authoritative database and `pg` is already locked. `pg_query` is not needed for constraints, transactions, locks, or ordinary SQL; PostgreSQL and Rails already provide those mechanisms. DatabaseCleaner is specifically unjustified while transactional fixtures preserve isolation. Direct PostgreSQL concurrency evidence should continue to use real independent connections and explicit cleanup rather than a global cleanup gem.

## 10. Testing, profiling, and quality

RSpec Rails, FactoryBot Rails, Shoulda Matchers, SimpleCov, and Faker are already present. GitLab's older constraints do not motivate downgrades. `ffaker` would duplicate Faker. Capybara/Selenium would blur backend/frontend test ownership.

WebMock is the only near-term testing gap with a clear future seam: external HTTP adapters should be tested without reaching providers, while internal business behavior remains real. It should arrive with the first authorized HTTP integration, not before.

For performance investigations, the minimum reasonable set is StackProf for CPU and MemoryProfiler for Ruby memory, added only for a concrete investigation and `require: false`. `benchmark-ips` or `benchmark-memory` may be temporary tools for a reproducible spike. Bullet, TestProf, RSpec Benchmark, and Derailed Benchmarks remain premature without measured problems.

## 11. Security, privacy, encryption, and audit

Rack::Attack is a useful HTTP-layer mechanism, but [upstream Rack::Attack](https://github.com/rack/rack-attack) defines no application policy by itself and relies on a cache with correct increment/write semantics. A per-process memory store cannot enforce a global distributed limit. AFTER FOUR must first approve trusted proxy handling, username/IP keys, a shared store, progressive response behavior, fail-open/fail-closed behavior, and capacity safeguards.

Lockbox is preferable to `attr_encrypted` if application-level field encryption is later approved. [Current Lockbox](https://github.com/ankane/lockbox) supports authenticated encryption and rotation patterns, but a gem does not decide key custody, KMS, associated data, searchable fields/blind indexes, backups, breach response, access logging, retention, or legal compliance. GitLab's old `~> 1.4.0` constraint is not recommended.

PaperTrail captures model versions and supports history/reification. [PaperTrail upstream](https://github.com/paper-trail-gem/paper_trail) distinguishes versioned model changes; this is not AFTER FOUR's append-only, actor/target/capability/scope/correlation security and business AuditEvent contract. Its GitLab-pinned major line also does not establish Rails 8.1 support. It is rejected as an audit solution.

Encryption, error reporting, logs, and traces may themselves expose secrets or personal data. Every proposal must include allowlisted fields, redaction tests, least-privilege access, retention/disposal, export behavior, incident response, and provider/subprocessor review. No library creates legal compliance.

## 12. Observability and operations

Sentry Rails and OpenTelemetry solve overlapping but different layers. Sentry can provide high-value exception aggregation; OpenTelemetry offers vendor-neutral tracing/instrumentation. Adopting both initially would create duplicate instrumentation, context propagation, sampling, storage, and privacy work. Select one direction after deployment topology and operations ownership exist.

If managed error reporting is approved, Sentry Rails is the narrower first candidate, with strict PII/secret filtering and sampling. If vendor-neutral distributed traces become a requirement, prefer a minimal OpenTelemetry SDK/exporter/instrumentation set rather than GitLab's broad group. `sentry-sidekiq` is inapplicable. GitLab's mmap Prometheus client is tied to its process topology and is rejected.

Structured logging is valuable, but Lograge adoption depends on Rails 8.1 verification and an approved event schema including correlation IDs, trusted actor handling, redaction, and separation from audit events. Logs are operational telemetry, not authoritative audit records.

## 13. Feature flags and other capabilities

Flipper is mature, but AFTER FOUR has no approved progressive rollout, kill-switch ownership, environment promotion, flag lifecycle, or authorization model. Flags also create hidden state and test combinations. Defer until deployment strategy demonstrates the need.

Faraday is a reasonable Infrastructure HTTP client once a concrete provider exists. Retry middleware must be enabled only where idempotency and deadlines are explicit. Use one HTTP stack rather than copying GitLab's many adapters.

Sanitization, file/image processing, PDF generation, mail, JSON Schema, and safe-regex support each require an actual capability contract. Rails-native Active Storage should be assessed before CarrierWave. JSON Schema is valuable at a real external contract, not as a replacement for typed Domain values. Mail dependencies wait for approved recovery/notification workflows and provider selection.

## 14. GitLab-specific dependencies to reject

The following families must not be copied as ordinary gems:

- local monorepo gems such as `gitlab-utils`, `gitlab-configs`, `gitlab-banzai`, `gitlab-mfe`, `gitlab-safe_request_store`, and `gitlab-safe_string_conversion`;
- vendored/forked authentication providers and `devise-pbkdf2-encryptable`;
- vendored Sidekiq and GitLab reliable-fetch behavior;
- `activerecord-gitlab`, database isolation/data gems, GitLab schema validation, and GitLab HTTP wrappers;
- Gitaly, KAS, Orbit, IAM, Duo, cloud connector, import, topology, license, policy-store, and query-language clients;
- GitLab RSpec, flaky-test, balancing, quality, Danger, CI export, and housekeeper integrations; and
- deployment, backup, Pages, source-code, artifact, and mail-room components coupled to GitLab services.

These declarations are local source or specialized integrations whose APIs, forks, services, release process, threat model, and operational ownership belong to GitLab. A fork/path declaration must be reviewed like maintained source code, not treated as a normal upstream dependency. GitLab's Rails 7.2/Rack compatibility pins likewise must not be copied into Rails 8.1.

## 15. Engineering practices worth adopting

1. Pin external reference reviews to an immutable commit and retain a checksum.
2. Group dependencies by actual runtime, development, test, profiling, or optional-provider need.
3. Use `require: false` for CLI, profiling, build, and manually loaded tools.
4. Explain exact pins with the upstream issue, risk, owner, and removal condition.
5. Record the capability/context that owns each dependency and the seam it implements.
6. Separate technical compatibility evidence from Owner/business approval.
7. Review native/system packages, supported platforms, Docker effects, and failure modes.
8. Avoid redundant libraries for HTTP, JSON, fake data, authorization, encryption, and observability.
9. Treat forks and path gems as owned source with security and maintenance obligations.
10. Review lockfile changes, transitive dependencies, licenses, advisories, maintainers, and release cadence before adoption.
11. Keep provider SDKs, persistence libraries, and instrumentation behind Infrastructure boundaries.
12. Never infer suitability or security from adoption by GitLab alone.

GitLab's `feature_category:` metadata and custom Gemfile lint rules are GitLab-specific. AFTER FOUR should capture purpose and ownership in its own dependency proposal/review convention rather than reproduce those extensions.

## 16. Dependencies already covered

| Capability | AFTER FOUR baseline | Conclusion |
|---|---|---|
| PostgreSQL adapter | `pg` 1.7.0 | Covered; do not adopt GitLab's older constraint |
| Rails specifications | `rspec-rails` 8.1.0 | Covered |
| Factories | `factory_bot_rails` 6.5.1 | Covered |
| Matchers | `shoulda-matchers` 8.0.1 | Covered |
| Coverage | `simplecov` 1.2 | Covered; thresholds remain separately governed |
| Fake data | `faker` 3.8 | Covered; reject FFaker duplication |
| Background jobs | Active Job + Solid Queue 1.7.2 | Covered by accepted ADR-0007; reject Sidekiq substitution now |
| Health/readiness | Existing endpoints | Covered; no `health_check` gem required |
| Static/security checks | RuboCop, Brakeman, Bundler Audit | Covered for their respective purposes; none replaces runtime controls |

## 17. Recommended minimal shortlist

No item is approved for installation. Ranked by potential value:

1. **Devise 5 — `CONDITIONAL_CANDIDATE`.** Highest leverage for future account credential/recovery mechanics. Prefer it to bespoke authentication only if the bounded spike is compatible with the proposed ADR-0006 direction and the eventual Owner-reviewed architecture without pervasive overrides, and explicitly resolves bcrypt/Argon2id behavior.
2. **Rack::Attack 6.8 line — `CONDITIONAL_CANDIDATE`.** Useful request-abuse enforcement point after trusted proxy, shared counter store, policy keys, failure behavior, and capacity are approved.
3. **WebAuthn — `DEFER`.** Strong phishing-resistant factor to evaluate once MFA/recovery/step-up policy is settled; it is not a complete MFA system.
4. **Current Lockbox — `CONDITIONAL_CANDIDATE`.** Best reviewed field-encryption option only after data classification and key/search/rotation design.
5. **Sentry Rails or a minimal OpenTelemetry stack — conditional/deferred alternatives.** Select one initial direction after operations, provider, privacy, sampling, and retention decisions.
6. **WebMock — `CONDITIONAL_CANDIDATE`.** Add with the first external HTTP adapter and keep mocks at Infrastructure boundaries.
7. **StackProf and MemoryProfiler — `CONDITIONAL_CANDIDATE`.** Add on demand for concrete CPU/memory investigations, not as general runtime surface.

## 18. Deferred candidates and prerequisites

| Candidate | Minimum prerequisite before reconsideration |
|---|---|
| Devise two-factor / WebAuthn | A future Owner-approved MFA factor, enrollment, step-up, recovery, freshness, and session-binding policy |
| OmniAuth/provider gems | Approved federation requirement and named provider/trust mapping |
| OpenTelemetry | Deployment topology, telemetry backend, propagation, sampling, privacy, and operations owner |
| Flipper | Release/rollback strategy, flag ownership, persistence, lifecycle cleanup, and authorization |
| Bullet/TestProf/benchmark tools | Reproducible query/suite/performance evidence |
| Rich-text sanitizers | Approved untrusted HTML/SVG input contract |
| Prawn | Approved PDF/report/receipt format and archival requirements |
| Mail/provider adapters | Approved email identity/notification/recovery workflow and provider |
| `pg_query` / RE2 | Concrete SQL parsing or user-controlled regex requirement |

## 19. Security, licensing, compatibility, and maintenance gates

Every future dependency proposal must provide:

- exact version and lock-resolution evidence on Ruby 3.4.12/Rails 8.1.4.1;
- primary-source supported Ruby/Rails/platform matrix and maintenance/release activity;
- SPDX/license and distribution obligations, including transitive dependencies;
- advisory scan and review of unresolved security issues relevant to enabled features;
- native compiler/system library and Linux/macOS/Docker implications;
- data flows, outbound network behavior, telemetry, PII/secret redaction, and retention;
- configuration defaults versus explicitly enabled modules;
- Layered DDD placement, cross-context contract, and failure containment;
- upgrade/removal/migration plan, operational owner, and rollback evidence; and
- focused tests showing the intended capability without broad framework coupling.

GitLab's constraint or use is supporting context only. Version selection must use current upstream evidence at the time of proposal.

## 20. Final recommendations and Owner decisions required

### Verified facts

- The pinned GitLab Gemfile and checksum in §2 were inspected completely.
- AFTER FOUR already has the capabilities listed in §16.
- GitLab's reviewed Rails line differs from AFTER FOUR's Rails 8.1.4.1.
- Devise 5.0.4 directly depends on `bcrypt ~> 3.0`, and its stock database-authenticatable path uses BCrypt; no AFTER FOUR resolution, installation, boot, or runtime compatibility test has been performed.
- No AFTER FOUR dependency or architecture document was changed by this review.

### Engineering recommendations

- Use the practices in §15 for future dependency proposals.
- Do not adopt a broad “GitLab stack.” Evaluate the minimal candidate that serves one approved seam.
- Treat Devise 5.0.4 as the pinned reference for the first authentication-foundation spike, with a smaller custom Rails design as the fallback if bcrypt/Argon2id integration or other customization overwhelms the benefit.
- Keep authorization, scope resolution, audit, privacy, and operational controls explicit regardless of framework choice.

### Decisions still requiring Owner approval

1. Whether to authorize the bounded Devise-versus-custom authentication compatibility/design spike, including explicit bcrypt dependency and Argon2id behavior evidence.
2. Whether Devise becomes the authentication foundation after that evidence and whether bcrypt's unavoidable declared dependency is an acceptable maintenance/security trade-off or warrants a separately reviewed alternative; ADR-0006 remains `Proposed` until separately decided.
3. MFA factor/recovery/step-up policy before Devise two-factor or WebAuthn selection.
4. Abuse-defense architecture and shared counter backend before Rack::Attack adoption.
5. Data classification/key governance before field encryption.
6. Observability objective, provider/export, privacy, retention, and operator ownership.
7. Each dependency addition, version, license, and implementation scope through a separate change authorization.

This report grants no dependency adoption, implementation authorization, Gate A approval, Control Acceptance, Final Operational Acceptance, or Production Authorization.
