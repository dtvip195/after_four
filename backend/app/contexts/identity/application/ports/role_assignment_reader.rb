module Identity
  module Application
    module Ports
      module RoleAssignmentReader
        class Result
          STATUSES = %i[found absent inconsistent unavailable].freeze
          attr_reader :status, :evidence, :failure_reference

          class << self
            def found(evidence)
              raise ArgumentError unless evidence.is_a?(Contracts::RoleAssignmentEvidence)
              new(status: :found, evidence: evidence)
            end

            def absent = new(status: :absent)
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
