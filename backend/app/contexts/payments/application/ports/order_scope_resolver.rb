module Payments
  module Application
    module Ports
      module OrderScopeResolver
        class Result
          STATUSES = %i[found not_found inconsistent unavailable].freeze
          attr_reader :status, :failure_reference

          class << self
            def found = new(:found)
            def not_found = new(:not_found)
            def inconsistent = new(:inconsistent)
            def unavailable(reference) = new(:unavailable, reference)
          end

          STATUSES.each { |candidate| define_method("#{candidate}?") { status == candidate } }

          private

          def initialize(status, failure_reference = nil)
            @status = status
            @failure_reference = failure_reference
            freeze
          end
        end

        def resolve(**) = raise NotImplementedError
      end
    end
  end
end
