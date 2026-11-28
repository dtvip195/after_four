module Organization
  module Application
    module Queries
      class ResolveBranchAncestry
        Result = Contracts::ResolveBranchAncestryResult
        Reader = Ports::BranchAncestryReader

        def initialize(reader:)
          @reader = reader
        end

        def call(branch_reference)
          return Result.invalid unless branch_reference.is_a?(Contracts::BranchReference)

          map_reader_result(reader.read(branch_reference), branch_reference)
        rescue StandardError
          raise Errors::UnexpectedFailure, Errors::UnexpectedFailure::MESSAGE, [], cause: nil
        end

        private

        attr_reader :reader

        def map_reader_result(reader_result, requested_branch)
          return Result.inconsistent unless reader_result.is_a?(Reader::Result)
          return map_found(reader_result.fact, requested_branch) if reader_result.found?
          return Result.not_found if reader_result.not_found?
          return Result.inconsistent if reader_result.inconsistent?
          return map_unavailable(reader_result.failure_reference) if reader_result.unavailable?

          Result.inconsistent
        end

        def map_found(fact, requested_branch)
          return Result.inconsistent unless fact.is_a?(Reader::PersistedBranchAncestryFact)
          return Result.inconsistent unless fact.branch_id == requested_branch
          return Result.inconsistent unless fact.brand_id.is_a?(Contracts::BrandReference)
          return Result.inconsistent unless fact.organization_id.is_a?(Contracts::OrganizationReference)

          ancestry = Contracts::BranchAncestry.new(
            branch_id: fact.branch_id,
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
