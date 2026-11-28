module Orders
  module Application
    module Ports
      module OrderReadModel
        Fact = Data.define(
          :id, :branch_id, :order_number, :channel, :status, :total_amount, :currency_code,
          :lock_version, :created_at, :updated_at
        )

        class ListResult
          STATUSES = %i[found inconsistent unavailable].freeze
          attr_reader :status, :facts, :total, :failure_reference

          class << self
            def found(facts:, total:) = new(status: :found, facts: facts, total: total)
            def inconsistent = new(status: :inconsistent)
            def unavailable(reference) = new(status: :unavailable, failure_reference: reference)
          end

          STATUSES.each { |candidate| define_method("#{candidate}?") { status == candidate } }

          private

          def initialize(status:, facts: nil, total: nil, failure_reference: nil)
            @status = status
            @facts = facts&.dup&.freeze
            @total = total
            @failure_reference = failure_reference
            freeze
          end
        end

        class FindResult
          STATUSES = %i[found not_found inconsistent unavailable].freeze
          attr_reader :status, :fact, :failure_reference

          class << self
            def found(fact) = new(status: :found, fact: fact)
            def not_found = new(status: :not_found)
            def inconsistent = new(status: :inconsistent)
            def unavailable(reference) = new(status: :unavailable, failure_reference: reference)
          end

          STATUSES.each { |candidate| define_method("#{candidate}?") { status == candidate } }

          private

          def initialize(status:, fact: nil, failure_reference: nil)
            @status = status
            @fact = fact
            @failure_reference = failure_reference
            freeze
          end
        end

        def list(**) = raise NotImplementedError
        def find(**) = raise NotImplementedError
      end
    end
  end
end
