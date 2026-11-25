require "securerandom"

module Organization
  module Infrastructure
    module Persistence
      class ActiveRecordBrandAncestryReader
        include Application::Ports::BrandAncestryReader

        Result = Application::Ports::BrandAncestryReader::Result
        Fact = Application::Ports::BrandAncestryReader::PersistedBrandAncestryFact
        BrandReference = Application::Contracts::BrandReference
        OrganizationReference = Application::Contracts::OrganizationReference
        SafeFailureReference = Application::Contracts::SafeFailureReference

        def initialize(
          record_class: BrandRecord,
          failure_reference_generator: -> { SecureRandom.uuid }
        )
          @record_class = record_class
          @failure_reference_generator = failure_reference_generator
        end

        def read(brand_reference)
          raise ArgumentError, "brand_reference must be typed" unless brand_reference.is_a?(BrandReference)

          row = ancestry_row(brand_reference)
          return Result.not_found unless row

          map_row(row, brand_reference)
        rescue ActiveRecord::ConnectionTimeoutError,
          ActiveRecord::ConnectionFailed,
          ActiveRecord::AdapterTimeout,
          ActiveRecord::StatementTimeout
          Result.unavailable(SafeFailureReference.new(failure_reference_generator.call))
        end

        private

        attr_reader :record_class, :failure_reference_generator

        def ancestry_row(brand_reference)
          brands = BrandRecord.arel_table
          organizations = OrganizationRecord.arel_table

          record_class
            .left_outer_joins(:organization)
            .where(brands: { id: brand_reference.value })
            .pick(brands[:id], brands[:organization_id], organizations[:id])
        end

        def map_row(row, requested_brand)
          return Result.inconsistent unless row.is_a?(Array) && row.length == 3

          brand_value, stored_organization_value, joined_organization_value = row
          return Result.inconsistent unless brand_value == requested_brand.value
          return Result.inconsistent unless stored_organization_value == joined_organization_value
          return Result.inconsistent unless BrandReference.valid_value?(brand_value)
          return Result.inconsistent unless OrganizationReference.valid_value?(joined_organization_value)

          fact = Fact.new(
            brand_id: BrandReference.new(brand_value),
            organization_id: OrganizationReference.new(joined_organization_value)
          )
          Result.found(fact)
        end
      end
    end
  end
end
