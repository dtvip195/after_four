module Catalog
  module Application
    module Queries
      class ResolveEffectiveVariantPrice
        Contracts = Application::Contracts
        Port = Application::Ports::EffectiveVariantPriceReader
        Result = Contracts::ResolveEffectiveVariantPriceResult

        def initialize(reader:)
          @reader = reader
        end

        def call(branch_reference:, variant_reference:, at:)
          return Result.invalid unless branch_reference.instance_of?(Contracts::BranchReference)
          return Result.invalid unless variant_reference.instance_of?(Contracts::VariantReference)
          return Result.invalid unless at.instance_of?(Time)

          map_result(
            reader.resolve(
              branch_reference: branch_reference,
              variant_reference: variant_reference,
              at: at
            ),
            branch_reference,
            variant_reference,
            at
          )
        rescue StandardError, NotImplementedError
          raise Errors::UnexpectedFailure, Errors::UnexpectedFailure::MESSAGE, [], cause: nil
        end

        private

        attr_reader :reader

        def map_result(read_result, branch_reference, variant_reference, at)
          return Result.inconsistent unless read_result.is_a?(Port::Result)
          return Result.not_found if read_result.not_found?
          return Result.price_unavailable if read_result.price_unavailable?
          return Result.inconsistent if read_result.inconsistent?
          return unavailable(read_result.failure_reference) if read_result.unavailable?
          return Result.inconsistent unless read_result.found?
          return Result.inconsistent unless valid_fact?(read_result.fact, branch_reference, variant_reference, at)
          return Result.commercial_policy_unresolved if read_result.fact.amount.zero?

          Result.found(Contracts::EffectiveVariantPrice.new(**read_result.fact.to_h))
        end

        def unavailable(reference)
          return Result.inconsistent unless reference.instance_of?(Contracts::SafeFailureReference)
          Result.unavailable(reference)
        end

        def valid_fact?(fact, branch_reference, variant_reference, at)
          fact.is_a?(Port::Fact) && fact.variant_id == variant_reference.value &&
            fact.branch_id == branch_reference.value && uuid?(fact.price_version_id) &&
            fact.amount.is_a?(Integer) && fact.amount >= 0 &&
            fact.currency_code.is_a?(String) && fact.currency_code.match?(/\A[A-Z]{3}\z/) &&
            fact.effective_from.instance_of?(Time) && fact.resolved_at == at &&
            fact.effective_from <= fact.resolved_at
        end

        def uuid?(value)
          value.is_a?(String) && Contracts::BrandReference::UUID_PATTERN.match?(value)
        end
      end
    end
  end
end
