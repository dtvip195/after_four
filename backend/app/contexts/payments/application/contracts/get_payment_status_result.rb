module Payments
  module Application
    module Contracts
      class GetPaymentStatusResult
        STATUSES = %i[found not_found invalid inconsistent unavailable].freeze
        attr_reader :status, :payment, :failure_reference

        class << self
          def found(payment) = new(status: :found, payment: payment)
          def not_found = new(status: :not_found)
          def invalid = new(status: :invalid)
          def inconsistent = new(status: :inconsistent)
          def unavailable(reference) = new(status: :unavailable, failure_reference: reference)
        end

        STATUSES.each { |candidate| define_method("#{candidate}?") { status == candidate } }

        private

        def initialize(status:, payment: nil, failure_reference: nil)
          @status = status
          @payment = payment
          @failure_reference = failure_reference
          freeze
        end
      end
    end
  end
end
