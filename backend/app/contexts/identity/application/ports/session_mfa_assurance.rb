module Identity
  module Application
    module Ports
      module SessionMfaAssurance
        class Result
          STATUSES = %i[satisfied insufficient unavailable].freeze
          attr_reader :status, :evidence, :failure_reference

          class << self
            def satisfied(evidence)
              raise ArgumentError unless evidence.is_a?(Contracts::SessionMfaAssuranceEvidence)
              new(status: :satisfied, evidence: evidence)
            end

            def insufficient = new(status: :insufficient)

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
