Devise.setup do |config|
  config.mailer_sender = ENV.fetch("AUTH_MAILER_SENDER", "no-reply@invalid.after-four.local")
  config.parent_controller = "ApplicationController"

  config.authentication_keys = [ :organization_id, :username ]
  config.case_insensitive_keys = [ :username ]
  config.strip_whitespace_keys = [ :username ]
  config.paranoid = true

  config.password_length = 15..128
  config.reset_password_within = 1.hour
  config.sign_in_after_reset_password = false

  config.lock_strategy = :failed_attempts
  config.unlock_strategy = :time
  maximum_attempts = if Rails.env.test?
    ENV.fetch("AUTH_MAXIMUM_ATTEMPTS", "5")
  else
    ENV.fetch("AUTH_MAXIMUM_ATTEMPTS")
  end
  unlock_seconds = if Rails.env.test?
    ENV.fetch("AUTH_UNLOCK_IN_SECONDS", "900")
  else
    ENV.fetch("AUTH_UNLOCK_IN_SECONDS")
  end
  config.maximum_attempts = Integer(maximum_attempts)
  config.unlock_in = Integer(unlock_seconds).seconds
  config.last_attempt_warning = false

  config.timeout_in = 30.minutes
  config.skip_session_storage = [ :http_auth ]
end

require "devise/orm/active_record"
