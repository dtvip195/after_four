module Organization
  module Application
    module Ports
      module BrandAncestryReader
        class PersistedBrandAncestryFact
          attr_reader :brand_id, :organization_id

          def initialize(brand_id:, organization_id:)
            @brand_id = brand_id
            @organization_id = organization_id
            freeze
          end
        end

        class Result
          STATUSES = %i[found not_found inconsistent unavailable].freeze

          attr_reader :status, :fact, :failure_reference

          class << self
            def found(fact)
              new(status: :found, fact: fact)
            end

            def not_found
              new(status: :not_found)
            end

            def inconsistent
              new(status: :inconsistent)
            end

            def unavailable(failure_reference)
              new(status: :unavailable, failure_reference: failure_reference)
            end
          end

          STATUSES.each do |candidate|
            define_method("#{candidate}?") { status == candidate }
          end

          private

          def initialize(status:, fact: nil, failure_reference: nil)
            @status = status
            @fact = fact
            @failure_reference = failure_reference
            freeze
          end
        end

        def read(_brand_reference)
          raise NotImplementedError
        end
      end
    end
  end
end
