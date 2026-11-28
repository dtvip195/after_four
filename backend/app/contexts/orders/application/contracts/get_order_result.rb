module Orders
  module Application
    module Contracts
      class GetOrderResult
        STATUSES = %i[found not_found invalid inconsistent unavailable].freeze
        attr_reader :status, :order, :failure_reference

        class << self
          def found(order) = new(status: :found, order: order)
          def not_found = new(status: :not_found)
          def invalid = new(status: :invalid)
          def inconsistent = new(status: :inconsistent)
          def unavailable(reference) = new(status: :unavailable, failure_reference: reference)
        end

        STATUSES.each { |candidate| define_method("#{candidate}?") { status == candidate } }

        private

        def initialize(status:, order: nil, failure_reference: nil)
          @status = status
          @order = order
          @failure_reference = failure_reference
          freeze
        end
      end
    end
  end
end
