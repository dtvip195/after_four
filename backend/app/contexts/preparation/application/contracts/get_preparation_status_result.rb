module Preparation
  module Application
    module Contracts
      class GetPreparationStatusResult
        STATUSES = %i[found not_found invalid inconsistent unavailable].freeze
        attr_reader :status, :preparation, :failure_reference

        class << self
          def found(preparation) = new(status: :found, preparation: preparation)
          def not_found = new(status: :not_found)
          def invalid = new(status: :invalid)
          def inconsistent = new(status: :inconsistent)
          def unavailable(reference) = new(status: :unavailable, failure_reference: reference)
        end

        STATUSES.each { |candidate| define_method("#{candidate}?") { status == candidate } }

        private

        def initialize(status:, preparation: nil, failure_reference: nil)
          @status = status
          @preparation = preparation
          @failure_reference = failure_reference
          freeze
        end
      end
    end
  end
end
