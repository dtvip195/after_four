# AFTER FOUR runtime-version baseline research

**As of:** 2026-11-14  
**Scope:** Evidence for the Ruby, Rails, and PostgreSQL foundation ADRs. This note does not install or configure a runtime.

## Recommendation

Use the following candidate baseline for the first Rails foundation build:

| Component | Candidate baseline | Pinning rule | Rationale |
|---|---|---|---|
| Ruby | `3.4.12` | Pin the complete version in the repository and every environment. | Ruby 3.4 is in normal maintenance and 3.4.12 is the current patch release. It is a more conservative ecosystem baseline than the newer Ruby 4.0 series while remaining actively maintained. |
| Rails | `8.1.4.1` | Pin the complete version in `Gemfile.lock`; permit only reviewed patch upgrades. | 8.1.4.1 is the latest stable Rails release and is a security release. Rails 8.1 remains under security support through 2027-10-10, although its general bug-fix window ended on 2026-10-10. Rails 8.2 is still an unreleased alpha and must not be the production baseline. |
| PostgreSQL | `18.7` | Pin major 18 for environment compatibility; apply current 18.x minors promptly after testing. | PostgreSQL 18 is the current supported major, 18.7 is the current minor, and major 18 is supported through 2030-11-14. PostgreSQL 19 is only at RC2 on the review date, with general availability planned for 2026-11-19. |

The exact patch versions must be rechecked against the same official sources immediately before scaffolding. If a newer security patch exists within Ruby 3.4, Rails 8.1, or PostgreSQL 18, start on that patch. Changing a major/minor line requires an ADR review; applying a compatible security patch does not.

## Primary-source findings

### Ruby

- The official [Ruby maintenance branches](https://www.ruby-lang.org/en/downloads/branches/) page lists Ruby 4.0 and Ruby 3.4 in normal maintenance, Ruby 3.3 in security maintenance, and Ruby 3.2 as end-of-life.
- The official [Ruby releases](https://www.ruby-lang.org/en/downloads/releases/) page lists Ruby 3.4.12 and Ruby 4.0.9, both released on 2026-10-23, as the latest releases in their respective stable series.
- The maintained Rails 8.1 [upgrade guide](https://guides.rubyonrails.org/upgrading_ruby_on_rails.html#ruby-versions) states that Rails 8.0 and 8.1 require Ruby 3.2.0 or newer.

Ruby 3.4.12 is therefore compatible with the documented Rails minimum and remains under normal Ruby maintenance. Choosing Ruby 3.4 rather than Ruby 4.0 is an engineering-risk preference, not a claim that Rails cannot run on Ruby 4.0. It should be revisited when the foundation is generated if the selected gem set provides stronger evidence for Ruby 4.0.

### Rails

- The official [Rails 8.1 guides index](https://guides.rubyonrails.org/v8.1/) identifies the published documentation as version 8.1.4.1.
- Rails announced [8.1.4.1 as a security release](https://rubyonrails.org/2026/11/4/Rails-8.0.5.2-and-8.1.4.1-have-been-released) on 2026-11-04 and strongly recommends upgrading.
- The official [Rails maintenance policy](https://rubyonrails.org/maintenance) states that 8.1.x general bug-fix support ended on 2026-10-10 and security support continues until 2027-10-10. Rails 8.0 security support ended on 2026-11-07.
- Rails `main` reports `8.2.0.alpha` in the official [RAILS_VERSION source](https://github.com/rails/rails/blob/main/RAILS_VERSION), and the [8.2 edge release notes](https://edgeguides.rubyonrails.org/8_2_release_notes.html) are work in progress. This is not a stable production release.

Rails 8.1.4.1 is the only evidence-backed stable baseline on the review date. Its elapsed bug-fix window shortens the horizon, so the ADR should require a Rails baseline review before the first production launch and an upgrade plan when the next stable Rails line is released.

### PostgreSQL

- The official [PostgreSQL current documentation](https://www.postgresql.org/docs/current/) identifies PostgreSQL 18.7 as current and lists majors 18, 17, 16, 15, and 14 as supported on 2026-11-12.
- The official [versioning policy](https://www.postgresql.org/support/versioning/) states that a PostgreSQL major is supported for five years and recommends always running the current minor for the chosen major. It lists PostgreSQL 18 support through 2030-11-14.
- The PostgreSQL project announced [18.7 and PostgreSQL 19 RC2](https://www.postgresql.org/about/news/postgresql-187-1712-1616-1520-1425-and-19-rc-2-released-3442/) on 2026-11-12. The announcement says PostgreSQL 19 general availability is planned for 2026-11-19 and describes RC2 as a release candidate.

PostgreSQL 18.7 is therefore the current production-ready baseline. A planned future general-availability date is not evidence that PostgreSQL 19 is available today; the project should not scaffold production against the release candidate.

## Selection and upgrade policy

1. Record the chosen Ruby, Rails, and PostgreSQL series in ADRs and pin exact build inputs in the repository when implementation begins.
2. Recheck official maintenance status and current security patches before generating the Rails application, before every production deployment, and during scheduled dependency review.
3. Apply Ruby/Rails patch releases and PostgreSQL minor releases through tested maintenance changes; they should not require a new architecture decision unless compatibility evidence contradicts the existing ADR.
4. Treat Ruby major/minor, Rails major/minor, and PostgreSQL major changes as planned upgrades with compatibility, migration, rollback, backup/restore, and load/concurrency validation.
5. Do not use preview, alpha, beta, or release-candidate runtimes for production. They may be evaluated only in a disposable compatibility environment.

## Decision confidence

- **PostgreSQL 18:** high confidence and suitable for an Accepted technical ADR.
- **Rails 8.1:** evidence-backed current stable choice, but the short remaining security window warrants Proposed status until implementation timing and the upgrade plan are approved.
- **Ruby 3.4:** maintained, compatible, and conservative; Proposed until the actual Rails/gem dependency resolution is tested during scaffolding.
