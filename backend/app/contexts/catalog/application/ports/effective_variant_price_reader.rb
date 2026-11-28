module Catalog
  module Application
    module Ports
      module EffectiveVariantPriceReader
        Fact = Data.define(
          :variant_id, :branch_id, :price_version_id, :amount, :currency_code,
          :effective_from, :resolved_at
        )

        class Result
          STATUSES = %i[found not_found price_unavailable inconsistent unavailable].freeze
          attr_reader :status, :fact, :failure_reference

          class << self
            def found(fact) = new(status: :found, fact: fact)
            def not_found = new(status: :not_found)
            def price_unavailable = new(status: :price_unavailable)
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

        def resolve(**) = raise NotImplementedError
      end
    end
  end
end
