module Payments
  module Application
    module Ports
      module PaymentStatusReader
        Fact = Data.define(:id, :order_id, :snapshot, :fully_settled_at, :updated_at)

        class Result
          STATUSES = %i[found not_found inconsistent unavailable].freeze
          attr_reader :status, :fact, :failure_reference

          class << self
            def found(fact) = new(status: :found, fact: fact)
            def not_found = new(status: :not_found)
            def inconsistent = new(status: :inconsistent)
            def unavailable(reference) = new(status: :unavailable, failure_reference: reference)
          end

          STATUSES.each { |candidate| define_method("#{candidate}?") { status == candidate } }

          private

          def initialize(status:, fact: nil, failure_reference: nil)
            @status = status
            @fact = fact
            @failure_reference = failure_reference
            freeze
          end
        end

        def find(**) = raise NotImplementedError
      end
    end
  end
end
