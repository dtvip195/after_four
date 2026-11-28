require "securerandom"

module Organization
  module Infrastructure
    module Persistence
      class ActiveRecordBranchAncestryReader
        include Application::Ports::BranchAncestryReader

        Result = Application::Ports::BranchAncestryReader::Result
        Fact = Application::Ports::BranchAncestryReader::PersistedBranchAncestryFact
        BranchReference = Application::Contracts::BranchReference
        BrandReference = Application::Contracts::BrandReference
        OrganizationReference = Application::Contracts::OrganizationReference
        SafeFailureReference = Application::Contracts::SafeFailureReference

        def initialize(
          record_class: BranchRecord,
          failure_reference_generator: -> { SecureRandom.uuid }
        )
          @record_class = record_class
          @failure_reference_generator = failure_reference_generator
        end

        def read(branch_reference)
          raise ArgumentError, "branch_reference must be typed" unless branch_reference.is_a?(BranchReference)

          row = ancestry_row(branch_reference)
          return Result.not_found unless row

          map_row(row, branch_reference)
        rescue ActiveRecord::ConnectionTimeoutError,
          ActiveRecord::ConnectionFailed,
          ActiveRecord::AdapterTimeout,
          ActiveRecord::StatementTimeout
          Result.unavailable(SafeFailureReference.new(failure_reference_generator.call))
        end

        private

        attr_reader :record_class, :failure_reference_generator

        def ancestry_row(branch_reference)
          branches = BranchRecord.arel_table
          brands = BrandRecord.arel_table
          organizations = OrganizationRecord.arel_table

          record_class
            .left_outer_joins(brand: :organization)
            .where(branches: { id: branch_reference.value })
            .pick(
              branches[:id],
              branches[:brand_id],
              brands[:id],
              brands[:organization_id],
              organizations[:id]
            )
        end

        def map_row(row, requested_branch)
          return Result.inconsistent unless row.is_a?(Array) && row.length == 5

          branch_value, stored_brand_value, joined_brand_value,
            stored_organization_value, joined_organization_value = row
          return Result.inconsistent unless branch_value == requested_branch.value
          return Result.inconsistent unless stored_brand_value == joined_brand_value
          return Result.inconsistent unless stored_organization_value == joined_organization_value
          return Result.inconsistent unless BranchReference.valid_value?(branch_value)
          return Result.inconsistent unless BrandReference.valid_value?(joined_brand_value)
          return Result.inconsistent unless OrganizationReference.valid_value?(joined_organization_value)

          fact = Fact.new(
            branch_id: BranchReference.new(branch_value),
            brand_id: BrandReference.new(joined_brand_value),
            organization_id: OrganizationReference.new(joined_organization_value)
          )
          Result.found(fact)
        end
      end
    end
  end
end
