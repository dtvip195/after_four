module Catalog
  module Application
    module Ports
      module BrandActiveCatalogReader
        VariantFact = Data.define(
          :id, :product_id, :brand_id, :code, :name, :position, :default, :customer_visible
        )
        ProductFact = Data.define(
          :id, :brand_id, :category_id, :category_code, :category_name, :category_position,
          :code, :name, :description, :variants
        )

        class Result
          STATUSES = %i[found inconsistent unavailable].freeze
          attr_reader :status, :products, :total, :failure_reference

          class << self
            def found(products:, total:)
              new(status: :found, products: products, total: total)
            end

            def inconsistent = new(status: :inconsistent)

            def unavailable(reference)
              new(status: :unavailable, failure_reference: reference)
            end
          end

          STATUSES.each { |candidate| define_method("#{candidate}?") { status == candidate } }

          private

          def initialize(status:, products: nil, total: nil, failure_reference: nil)
            @status = status
            @products = products&.dup&.freeze
            @total = total
            @failure_reference = failure_reference
            freeze
          end
        end

        def read(**) = raise NotImplementedError
      end
    end
  end
end
