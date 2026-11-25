module Orders
  module CompatibilityErrorTranslation
    private

    def translate_ordering_errors
      yield
    rescue Domain::Errors::RuleViolation => error
      raise DomainError.new(error.code, error.message, details: error.details)
    end
  end
end
