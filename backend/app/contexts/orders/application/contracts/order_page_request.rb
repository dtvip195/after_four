module Orders
  module Application
    module Contracts
      class OrderPageRequest
        MAX_LIMIT = 100
        attr_reader :page, :limit, :status

        def initialize(page:, limit:, status:)
          raise ArgumentError, "page must be positive" unless page.is_a?(Integer) && page.positive?
          unless limit.is_a?(Integer) && limit.between?(1, MAX_LIMIT)
            raise ArgumentError, "limit must be between 1 and #{MAX_LIMIT}"
          end
          unless status.nil? || Domain::Aggregates::Order::STATUSES.include?(status)
            raise ArgumentError, "status is invalid"
          end

          @page = page
          @limit = limit
          @status = status
          freeze
        end

        def offset = (page - 1) * limit
      end
    end
  end
end
