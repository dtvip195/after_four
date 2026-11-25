module Organization
  module Application
    module Queries
      class ResolveBrandAncestry
        Result = Contracts::ResolveBrandAncestryResult
        Reader = Ports::BrandAncestryReader

        def initialize(reader:)
          @reader = reader
        end

        def call(brand_reference)
          return Result.invalid unless brand_reference.is_a?(Contracts::BrandReference)

          map_reader_result(reader.read(brand_reference), brand_reference)
        rescue StandardError
          raise Errors::UnexpectedFailure, Errors::UnexpectedFailure::MESSAGE, [], cause: nil
        end

        private

        attr_reader :reader

        def map_reader_result(reader_result, requested_brand)
          return Result.inconsistent unless reader_result.is_a?(Reader::Result)
          return map_found(reader_result.fact, requested_brand) if reader_result.found?
          return Result.not_found if reader_result.not_found?
          return Result.inconsistent if reader_result.inconsistent?
          return map_unavailable(reader_result.failure_reference) if reader_result.unavailable?

          Result.inconsistent
        end

        def map_found(fact, requested_brand)
          return Result.inconsistent unless fact.is_a?(Reader::PersistedBrandAncestryFact)
          return Result.inconsistent unless fact.brand_id == requested_brand
          return Result.inconsistent unless fact.organization_id.is_a?(Contracts::OrganizationReference)

          ancestry = Contracts::BrandAncestry.new(
            brand_id: fact.brand_id,
            organization_id: fact.organization_id
          )
          Result.resolved(ancestry)
        end

        def map_unavailable(failure_reference)
          return Result.inconsistent unless failure_reference.is_a?(Contracts::SafeFailureReference)

          Result.unavailable(failure_reference)
        end
      end
    end
  end
end
