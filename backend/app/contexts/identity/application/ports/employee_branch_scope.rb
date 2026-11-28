module Identity
  module Application
    module Ports
      module EmployeeBranchScope
        class Result
          STATUSES = %i[effective not_effective inconsistent unavailable].freeze
          attr_reader :status, :evidence, :failure_reference

          class << self
            def effective(evidence)
              raise ArgumentError unless evidence.is_a?(Contracts::EmployeeBranchScopeEvidence)
              new(status: :effective, evidence: evidence)
            end

            def not_effective = new(status: :not_effective)
            def inconsistent = new(status: :inconsistent)

            def unavailable(reference)
              raise ArgumentError unless reference.is_a?(Contracts::SafeFailureReference)
              new(status: :unavailable, failure_reference: reference)
            end
          end

          STATUSES.each { |candidate| define_method("#{candidate}?") { status == candidate } }

          private

          def initialize(status:, evidence: nil, failure_reference: nil)
            @status = status
            @evidence = evidence
            @failure_reference = failure_reference
            freeze
          end
        end

        def call(**) = raise NotImplementedError
      end
    end
  end
end
