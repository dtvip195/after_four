# AFTER FOUR RSpec testing compatibility

**Evidence date:** 2026-11-14  
**Target runtime:** Ruby 3.4.12, Rails 8.1.4.1, PostgreSQL 18.7

## Recommendation

Use the current stable lines below and commit the exact resolution from Bundler:

| Direct dependency | Recommended Gemfile constraint | Current stable release | Compatibility evidence |
|---|---|---:|---|
| `rspec-rails` | `~> 8.1.0` | 8.1.0 | Requires Ruby >= 3.0 and Rails components >= 7.2; upstream explicitly assigns RSpec Rails 8.x to Rails 8.1, 8.0, and 7.2. |
| `factory_bot_rails` | `~> 6.5.1` | 6.5.1 | Requires Ruby >= 3.1 and Railties >= 6.1; resolves Factory Bot 6.6.x through its `~> 6.5` dependency. |
| `faker` | `~> 3.8.0` | 3.8.0 | Requires Ruby >= 3.2. |
| `shoulda-matchers` | `~> 8.0.1` | 8.0.1 | Requires Ruby >= 3.3 and Active Support >= 7.2; upstream supports Rails 7.2+, Ruby 3.3+, and RSpec 3.x. |
| `simplecov` | `~> 1.2.0` | 1.2.0 | Requires Ruby >= 3.2 and has no Rails coupling. |

Ruby 3.4.12 and Rails 8.1.4.1 satisfy every declared constraint. The final compatibility decision must still be based on an actual Bundler resolution and an executed suite under the project's pinned container, not metadata alone.

## Primary-source evidence

### RSpec Rails

The upstream [RSpec Rails compatibility and installation guide](https://github.com/rspec/rspec-rails) assigns RSpec Rails 8.x to Rails 8.1/8.0/7.2 and instructs Rails projects to install the gem in both development and test so generators and Rake tasks work without an environment prefix. RubyGems publishes [RSpec Rails 8.1.0](https://rubygems.org/gems/rspec-rails/versions/8.1.0) with Ruby >= 3.0. Its [published dependency metadata](https://rubygems.org/gems/rspec-rails/versions/8.1.0/dependencies) accepts Action Pack, Active Support, and Railties >= 7.2. Upstream CI includes Ruby 3.4 against Rails 8.1 in the [RSpec Rails build matrix](https://github.com/rspec/rspec-rails/blob/main/.github/workflows/ci.yml).

Use `rails generate rspec:install`, then keep transactional examples enabled through `config.use_transactional_fixtures = true`. That setting delegates to Rails' transactional-test machinery; a second database-cleaning framework is unnecessary for this request/Active Record suite.

### Factory Bot Rails

RubyGems publishes [factory_bot_rails 6.5.1](https://rubygems.org/gems/factory_bot_rails/versions/6.5.1) for Ruby >= 3.1 and Rails 6.1+. Its [dependency metadata](https://rubygems.org/gems/factory_bot_rails/versions/6.5.1/dependencies) requires Railties >= 6.1 and Factory Bot `~> 6.5`, which currently admits Factory Bot 6.6.0. The official [Factory Bot setup guide](https://github.com/thoughtbot/factory_bot/blob/main/GETTING_STARTED.md) configures RSpec with `FactoryBot::Syntax::Methods` and automatically discovers definitions under `spec/factories` in Rails.

The project has no business records or factories in Milestone 1.1. Installing and configuring Factory Bot is appropriate, but creating placeholder factories would add artificial domain concepts and should be avoided.

### Faker

RubyGems publishes [Faker 3.8.0](https://rubygems.org/gems/faker/versions/3.8.0) with Ruby >= 3.2. Faker should be test-only. Generated values should be overridden when an exact boundary or assertion matters, and deterministic examples should not depend on Faker's global random sequence.

### Shoulda Matchers

RubyGems publishes [Shoulda Matchers 8.0.1](https://rubygems.org/gems/shoulda-matchers) with Ruby >= 3.3 and an [Active Support >= 7.2 dependency](https://rubygems.org/gems/shoulda-matchers/versions/8.0.1/dependencies). The upstream [Rails/RSpec setup](https://github.com/thoughtbot/shoulda-matchers) requires explicit integration with test framework `:rspec` and library `:rails`. Upstream recommends these matchers for framework configuration such as associations and validations, while testing unique business logic through behavior and outcomes.

No Shoulda examples are needed until a real application model or applicable Rails configuration exists. Installing and configuring the integration does not justify an artificial model or table.

### SimpleCov

RubyGems publishes [SimpleCov 1.2.0](https://rubygems.org/gems/simplecov/versions/1.2.0) with Ruby >= 3.2. The official [SimpleCov setup guide](https://github.com/simplecov-ruby/simplecov) requires starting SimpleCov before application code loads and provides a Rails profile. Put the `require "simplecov"` and `SimpleCov.start "rails"` lines at the top of `spec/spec_helper.rb`, which `rails_helper.rb` must require before the Rails environment. Do not set a minimum percentage yet; report the observed coverage instead.

## Minitest removal boundary

Making RSpec the only supported application test framework means:

- remove `require "rails/test_unit/railtie"` from the application boot list;
- remove the `test/` suite and `test/test_helper.rb` only after equivalent specs pass;
- replace `bin/rails test` in local documentation, CI, and `bin/ci` with `bin/rspec`;
- configure Rails generators for RSpec and disable fixture generation in favor of Factory Bot;
- avoid adding DatabaseCleaner while Rails transactions provide isolation.

The `minitest` gem can remain as a transitive dependency of Rails/Active Support. "RSpec only" concerns the repository's supported suite, helpers, generators, and commands; attempting to remove a framework's transitive runtime dependency is neither necessary nor generally possible through the application Gemfile.

## Risks and verification gates

- RSpec Rails 8.1.0 was released recently. Its constraints and upstream Rails 8.1/Ruby 3.4 matrix are positive evidence, but this repository must execute every migrated spec individually and together.
- A SQL-notification test and the database-unavailable request test require careful RSpec `around`/notification cleanup so state cannot leak after failures.
- Request specs should use the real Rails routing and response stack. Stubbing is appropriate only at the database-readiness boundary for the explicit unavailable response; it must be restored automatically after the example.
- Run `db:prepare`, the entire randomized suite, RuboCop, Brakeman, the dependency audit, and CI-equivalent commands using the pinned Ruby/PostgreSQL environment before calling the migration complete.
