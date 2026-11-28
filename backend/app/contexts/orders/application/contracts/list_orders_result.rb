module Orders
  module Application
    module Contracts
      class ListOrdersResult
        STATUSES = %i[found invalid inconsistent unavailable].freeze
        attr_reader :status, :page, :failure_reference

        class << self
          def found(page) = new(status: :found, page: page)
          def invalid = new(status: :invalid)
          def inconsistent = new(status: :inconsistent)
          def unavailable(reference) = new(status: :unavailable, failure_reference: reference)
        end

        STATUSES.each { |candidate| define_method("#{candidate}?") { status == candidate } }

        private

        def initialize(status:, page: nil, failure_reference: nil)
          @status = status
          @page = page
          @failure_reference = failure_reference
          freeze
        end
      end
    end
  end
end
