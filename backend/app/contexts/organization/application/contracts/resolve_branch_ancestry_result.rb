module Organization
  module Application
    module Contracts
      class ResolveBranchAncestryResult
        STATUSES = %i[resolved not_found invalid inconsistent unavailable].freeze

        attr_reader :status, :ancestry, :failure_reference

        class << self
          def resolved(ancestry)
            raise ArgumentError, "resolved requires BranchAncestry" unless ancestry.is_a?(BranchAncestry)

            new(status: :resolved, ancestry: ancestry)
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

        def initialize(status:, ancestry: nil, failure_reference: nil)
          @status = status
          @ancestry = ancestry
          @failure_reference = failure_reference
          freeze
        end
      end
    end
  end
end
