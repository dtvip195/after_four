module Catalog
  module Application
    module Contracts
      class ResolveEffectiveVariantPriceResult
        STATUSES = %i[
          found
          not_found
          price_unavailable
          commercial_policy_unresolved
          invalid
          inconsistent
          unavailable
        ].freeze
        attr_reader :status, :price, :failure_reference

        class << self
          def found(price) = new(status: :found, price: price)
          def not_found = new(status: :not_found)
          def price_unavailable = new(status: :price_unavailable)
          def commercial_policy_unresolved = new(status: :commercial_policy_unresolved)
          def invalid = new(status: :invalid)
          def inconsistent = new(status: :inconsistent)
          def unavailable(reference) = new(status: :unavailable, failure_reference: reference)
        end

        STATUSES.each { |candidate| define_method("#{candidate}?") { status == candidate } }

        private

        def initialize(status:, price: nil, failure_reference: nil)
          @status = status
          @price = price
          @failure_reference = failure_reference
          freeze
        end
      end
    end
  end
end
