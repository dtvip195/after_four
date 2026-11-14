module Platform
  class PaymentWindowConfiguration
    DEFAULT_SECONDS = 300
    ENVIRONMENT_VARIABLE = "ORDER_PAYMENT_WINDOW_SECONDS"
    ERROR_MESSAGE = "#{ENVIRONMENT_VARIABLE} must be a positive integer whose deadline fits PostgreSQL timestamptz"
    POSTGRESQL_MAX_TIMESTAMP = Time.utc(294_276, 12, 31, 23, 59, 59, 999_999)

    InvalidValue = Class.new(ArgumentError)

    def self.load(environment: ENV, now: Time.now.utc)
      raw_value = environment.fetch(ENVIRONMENT_VARIABLE, DEFAULT_SECONDS.to_s)
      seconds = begin
        Integer(raw_value, 10)
      rescue ArgumentError, TypeError
        raise InvalidValue, ERROR_MESSAGE
      end
      raise InvalidValue, ERROR_MESSAGE unless seconds.positive?
      raise InvalidValue, ERROR_MESSAGE if now + seconds > POSTGRESQL_MAX_TIMESTAMP

      seconds
    rescue RangeError
      raise InvalidValue, ERROR_MESSAGE
    end
  end
end
