require "securerandom"

module Catalog
  module Infrastructure
    module Persistence
      class ActiveRecordBrandActiveCatalogReader
        include Application::Ports::BrandActiveCatalogReader

        Reader = Application::Ports::BrandActiveCatalogReader
        Result = Reader::Result
        ProductFact = Reader::ProductFact
        VariantFact = Reader::VariantFact
        BrandReference = Application::Contracts::BrandReference
        CategoryReference = Application::Contracts::CategoryReference
        SafeFailureReference = Application::Contracts::SafeFailureReference

        def initialize(
          product_record_class: ProductRecord,
          variant_record_class: ProductVariantRecord,
          failure_reference_generator: -> { SecureRandom.uuid }
        )
          @product_record_class = product_record_class
          @variant_record_class = variant_record_class
          @failure_reference_generator = failure_reference_generator
        end

        def read(brand_reference:, category_reference:, offset:, limit:)
          validate_input!(brand_reference, category_reference, offset, limit)
          relation = active_products(brand_reference, category_reference)
          total = relation.count
          product_rows = page_rows(relation, offset, limit)
          variants = variants_by_product(product_rows.map(&:first), brand_reference)

          Result.found(products: map_products(product_rows, variants), total: total)
        rescue ActiveRecord::ConnectionTimeoutError,
          ActiveRecord::ConnectionFailed,
          ActiveRecord::AdapterTimeout,
          ActiveRecord::StatementTimeout
          Result.unavailable(SafeFailureReference.new(failure_reference_generator.call))
        end

        private

        attr_reader :product_record_class, :variant_record_class, :failure_reference_generator

        def validate_input!(brand_reference, category_reference, offset, limit)
          unless brand_reference.instance_of?(BrandReference)
            raise ArgumentError, "brand_reference must be typed"
          end
          unless category_reference.nil? || category_reference.instance_of?(CategoryReference)
            raise ArgumentError, "category_reference must be typed or nil"
          end
          raise ArgumentError, "offset must be nonnegative" unless offset.is_a?(Integer) && offset >= 0
          raise ArgumentError, "limit must be positive" unless limit.is_a?(Integer) && limit.positive?
        end

        def active_products(brand_reference, category_reference)
          relation = product_record_class
            .joins(:category)
            .where(brand_id: brand_reference.value, lifecycle_status: "active")
            .where(categories: { brand_id: brand_reference.value, lifecycle_status: "active" })
          category_reference ? relation.where(category_id: category_reference.value) : relation
        end

        def page_rows(relation, offset, limit)
          relation
            .order("categories.position ASC", "products.name ASC", "products.id ASC")
            .offset(offset)
            .limit(limit)
            .pluck(
              "products.id", "products.brand_id", "products.category_id",
              "categories.code", "categories.name", "categories.position",
              "products.code", "products.name", "products.description"
            )
        end

        def variants_by_product(product_ids, brand_reference)
          return {} if product_ids.empty?

          rows = variant_record_class
            .where(product_id: product_ids, brand_id: brand_reference.value, lifecycle_status: "active")
            .order(:product_id, :position, :id)
            .pluck(:id, :product_id, :brand_id, :code, :name, :position, :is_default, :customer_visible)

          rows.group_by { |row| row.fetch(1) }
        end

        def map_products(product_rows, variants)
          product_rows.map do |row|
            id, brand_id, category_id, category_code, category_name, category_position,
              code, name, description = row
            ProductFact.new(
              id: id,
              brand_id: brand_id,
              category_id: category_id,
              category_code: category_code,
              category_name: category_name,
              category_position: category_position,
              code: code,
              name: name,
              description: description,
              variants: map_variants(variants.fetch(id, []))
            )
          end.freeze
        end

        def map_variants(rows)
          rows.map do |row|
            id, product_id, brand_id, code, name, position, default, customer_visible = row
            VariantFact.new(
              id: id,
              product_id: product_id,
              brand_id: brand_id,
              code: code,
              name: name,
              position: position,
              default: default,
              customer_visible: customer_visible
            )
          end.freeze
        end
      end
    end
  end
end
