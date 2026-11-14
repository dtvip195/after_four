require "json"
require "logger"
require "time"

module Platform
  class StructuredLogFormatter < Logger::Formatter
    SERVICE_NAME = "after-four-backend".freeze

    def call(severity, timestamp, program_name, message)
      JSON.generate(
        timestamp: timestamp.utc.iso8601(6),
        severity: severity,
        service: SERVICE_NAME,
        program: program_name,
        message: normalize(message)
      ) << "\n"
    end

    private

    def normalize(message)
      case message
      when String
        message
      when Exception
        message.class.name
      else
        message.inspect
      end
    end
  end
end
