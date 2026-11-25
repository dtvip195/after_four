module Identity
  module Application
    module Contracts
      class OrganizationScopeResult
        STATUSES = %i[resolved not_found invalid inconsistent unavailable].freeze

        attr_reader :status, :evidence, :failure_reference

        class << self
          def resolved(evidence)
            raise ArgumentError, "resolved requires OrganizationScopeEvidence" unless evidence.is_a?(OrganizationScopeEvidence)

            new(status: :resolved, evidence: evidence)
          end

          def not_found
            new(status: :not_found)
          end

          def invalid
            new(status: :invalid)
          end

          def inconsistent
            new(status: :inconsistent)
          end

          def unavailable(failure_reference)
            unless failure_reference.is_a?(SafeFailureReference)
              raise ArgumentError, "unavailable requires SafeFailureReference"
            end

            new(status: :unavailable, failure_reference: failure_reference)
          end
        end

        STATUSES.each do |candidate|
          define_method("#{candidate}?") { status == candidate }
        end

        private

        def initialize(status:, evidence: nil, failure_reference: nil)
          @status = status
          @evidence = evidence
          @failure_reference = failure_reference
          freeze
        end
      end
    end
  end
end
