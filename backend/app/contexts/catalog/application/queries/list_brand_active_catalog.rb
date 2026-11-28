module Catalog
  module Application
    module Queries
      class ListBrandActiveCatalog
        Contracts = Application::Contracts
        Reader = Application::Ports::BrandActiveCatalogReader
        Result = Contracts::ListBrandActiveCatalogResult

        def initialize(reader:)
          @reader = reader
        end

        def call(brand_reference:, page_request:)
          return Result.invalid unless brand_reference.instance_of?(Contracts::BrandReference)
          return Result.invalid unless page_request.instance_of?(Contracts::BrandActiveCatalogPageRequest)

          reader_result = reader.read(
            brand_reference: brand_reference,
            category_reference: page_request.category_reference,
            offset: page_request.offset,
            limit: page_request.limit
          )
          map_result(reader_result, brand_reference, page_request)
        rescue StandardError, NotImplementedError
          raise Errors::UnexpectedFailure, Errors::UnexpectedFailure::MESSAGE, [], cause: nil
        end

        private

        attr_reader :reader

        def map_result(reader_result, brand_reference, page_request)
          return Result.inconsistent unless reader_result.is_a?(Reader::Result)
          return Result.inconsistent if reader_result.inconsistent?
          return map_unavailable(reader_result.failure_reference) if reader_result.unavailable?
          return map_found(reader_result, brand_reference, page_request) if reader_result.found?

          Result.inconsistent
        end

        def map_found(reader_result, brand_reference, page_request)
          products = reader_result.products
          total = reader_result.total
          return Result.inconsistent unless valid_collection?(products, total, page_request)
          return Result.inconsistent unless unique_product_ids?(products)

          mapped = products.map do |fact|
            return Result.inconsistent unless valid_product?(fact, brand_reference, page_request)

            map_product(fact)
          end
          page = Contracts::BrandActiveCatalogPage.new(
            products: mapped.freeze,
            page: page_request.page,
            limit: page_request.limit,
            total: total,
            total_pages: total.zero? ? 0 : (total.to_f / page_request.limit).ceil
          )
          Result.found(page)
        end

        def valid_collection?(products, total, page_request)
          products.is_a?(Array) && products.length <= page_request.limit &&
            total.is_a?(Integer) && total >= products.length && total >= 0
        end

        def unique_product_ids?(products)
          ids = products.filter_map { |product| product.id if product.is_a?(Reader::ProductFact) }
          ids.length == products.length && ids.uniq.length == ids.length
        end

        def valid_product?(fact, brand_reference, page_request)
          fact.is_a?(Reader::ProductFact) &&
            uuid?(fact.id) && fact.brand_id == brand_reference.value &&
            uuid?(fact.category_id) && category_matches?(fact, page_request) &&
            nonempty_string?(fact.category_code) && nonempty_string?(fact.category_name) &&
            fact.category_position.is_a?(Integer) && fact.category_position >= 0 &&
            nonempty_string?(fact.code) && nonempty_string?(fact.name) &&
            (fact.description.nil? || fact.description.is_a?(String)) &&
            valid_variants?(fact)
        end

        def category_matches?(fact, page_request)
          page_request.category_reference.nil? || fact.category_id == page_request.category_reference.value
        end

        def valid_variants?(fact)
          return false unless fact.variants.is_a?(Array) && !fact.variants.empty?
          return false unless fact.variants.all? { |variant| variant.is_a?(Reader::VariantFact) }
          return false unless fact.variants.count(&:default) == 1

          ids = fact.variants.map(&:id)
          ids.uniq.length == ids.length && fact.variants.all? do |variant|
            uuid?(variant.id) && variant.product_id == fact.id && variant.brand_id == fact.brand_id &&
              nonempty_string?(variant.code) && nonempty_string?(variant.name) &&
              variant.position.is_a?(Integer) && variant.position >= 0 &&
              boolean?(variant.default) && boolean?(variant.customer_visible)
          end
        end

        def map_product(fact)
          variants = fact.variants.sort_by { |variant| [ variant.position, variant.id ] }.map do |variant|
            Contracts::BrandActiveCatalogVariant.new(
              id: variant.id,
              code: variant.code,
              name: variant.name,
              position: variant.position,
              default: variant.default,
              customer_visible: variant.customer_visible
            )
          end.freeze
          Contracts::BrandActiveCatalogProduct.new(
            id: fact.id,
            brand_id: fact.brand_id,
            category_id: fact.category_id,
            category_code: fact.category_code,
            category_name: fact.category_name,
            category_position: fact.category_position,
            code: fact.code,
            name: fact.name,
            description: fact.description,
            variants: variants,
            pricing_status: :price_unavailable
          )
        end

        def map_unavailable(reference)
          return Result.inconsistent unless reference.instance_of?(Contracts::SafeFailureReference)

          Result.unavailable(reference)
        end

        def uuid?(value)
          value.is_a?(String) && Contracts::BrandReference::UUID_PATTERN.match?(value)
        end

        def nonempty_string?(value)
          value.is_a?(String) && !value.empty?
        end

        def boolean?(value)
          true.equal?(value) || false.equal?(value)
        end
      end
    end
  end
end
