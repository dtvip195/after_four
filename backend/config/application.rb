require_relative "boot"
require_relative "../lib/platform/structured_log_formatter"
require_relative "../lib/platform/payment_window_configuration"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
# require "action_cable/engine"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Backend
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Persist instants in UTC. Branch-local rendering uses the Branch's IANA
    # timezone at the application boundary.
    config.time_zone = "UTC"
    config.active_record.default_timezone = :utc
    config.active_record.schema_format = :sql

    config.generators do |generators|
      generators.orm :active_record, primary_key_type: :uuid
      generators.test_framework :rspec, fixture: false
      generators.fixture_replacement :factory_bot, dir: "spec/factories"
      generators.system_tests = nil
    end

    config.active_job.queue_adapter = :solid_queue
    config.log_tags = [ :request_id ]
    config.log_formatter = Platform::StructuredLogFormatter.new
    config.x.orders.payment_window_seconds = Platform::PaymentWindowConfiguration.load

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true
    config.middleware.use ActionDispatch::Cookies

    config.x.identity.browser_origin = if Rails.env.production?
      ENV.fetch("BROWSER_ORIGIN")
    else
      ENV.fetch("BROWSER_ORIGIN", "http://localhost:5173")
    end
    config.x.identity.session_cookie_name = if Rails.env.production?
      "__Host-after_four_session"
    else
      "after_four_session"
    end
  end
end
