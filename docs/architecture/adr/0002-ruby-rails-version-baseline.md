---
status: accepted
date: 2026-11-14
---

# ADR-0002: Ruby 3.4 and Rails 8.1 version baseline

**Status:** Accepted

## Context

As of 2026-11-14, official sources identify Ruby 3.4.12 and Ruby 4.0.9 as normally maintained, Rails 8.1.4.1 as the stable security-patched Rails release, and Rails 8.2 as an alpha. Rails 8.1 security support continues to 2027-10-10, but its general bug-fix window ended on 2026-10-10. The primary-source and dependency evidence is recorded in the [runtime baseline](../../research/after_four_runtime_version_baseline.md) and [Milestone 1 compatibility verification](../../research/after_four_milestone1_runtime_compatibility.md).

## Decision

Use Ruby `3.4.13`, Rails `8.1.4.1`, and Bundler `2.6.9` as the accepted foundation baseline. Pin these inputs in `.ruby-version`, `Gemfile`, `Gemfile.lock`, development images, and CI. Use PostgreSQL 18 with `pg 1.7.x`; lock the resolved dependency set and deployment platforms. Ruby 3.4.13 supersedes the initial 3.4.12 patch after the Ruby security advisory published on 2026-11-18; this is routine patch maintenance within the accepted Ruby 3.4 series, not a major/minor baseline change.

Exact official Ruby 3.4.12 and Ruby 4.0.9 container checks both resolved, installed, and loaded the Rails 8.1.4.1 stack, including `pg 1.7.0`, Puma 8.0.3, Bootsnap 1.26.1, Solid Queue 1.7.2, test, lint, and security tooling. The selected Ruby 3.4.12 application then booted, migrated, dumped and loaded `structure.sql`, connected to PostgreSQL 18.7, passed tests and static checks, and served live/ready endpoints. Ruby 4.0.9 is therefore deferred for maintainability rather than rejected as incompatible: combining a new Ruby major with a Rails line already in security-only maintenance adds change risk without a project requirement.

Do not use preview, alpha, beta, or release-candidate runtimes in production. Review the Rails series again before production launch and define the upgrade to the next stable supported Rails line because 8.1 has a short remaining security horizon.

## Alternatives considered

- Ruby 4.0.9: technically compatible in the executed dependency check and offers a longer language horizon, but adds a new interpreter major to a security-only Rails line without a present benefit. Reconsider with the next stable Rails line or a dedicated compatibility lane.
- Older Ruby/Rails lines: rejected because they shorten or have ended maintenance windows.
- Rails 8.2 alpha: rejected because it is not a stable production release on the decision date.
- Floating version ranges: rejected because environments and CI could resolve different foundations.

## Trade-offs

The pair is supported, executed against the real dependency graph, and lower-risk than adopting a new Ruby major or preview Rails line. Rails 8.1's elapsed bug-fix window creates near-term upgrade work, while remaining on Ruby 3.4 forgoes Ruby 4's longer horizon until that review.

## Security implications

Use the latest compatible security patches, run dependency/security checks in CI, subscribe to Ruby/Rails security notices, and treat patching as routine maintenance. Revalidate official support and the advisory database before production releases. Never retain a vulnerable patch solely because this ADR names it.

## Operational implications

All development, CI, staging, and production environments must use the same pinned Ruby and locked gems. PostgreSQL schema commands must use a PostgreSQL 18 client. Upgrades require application boot, native-extension, test, migration, schema dump/load, worker, and rollback validation.

## Consequences

ADR-0002 is Accepted because exact-version dependency installation and Milestone 1 execution supplied the required compatibility evidence. Rails 8.1 must be reviewed before the first production launch and upgraded before security support ends on 2027-10-10. Patch-level updates within the accepted series do not require a new ADR; changing Ruby or Rails major/minor does.
