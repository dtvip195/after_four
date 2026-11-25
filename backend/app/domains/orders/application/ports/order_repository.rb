module Orders
  module Application
    module Ports
      module OrderRepository
        class DuplicateCreationKey < StandardError; end

        def find_by_creation_key(branch_id:, idempotency_key:)
          raise NotImplementedError
        end

        def validate_draft_attributes!(**attributes)
          raise NotImplementedError
        end

        def add(_order)
          raise NotImplementedError
        end

        def lock(_order_id)
          raise NotImplementedError
        end

        def save(_order)
          raise NotImplementedError
        end

        def expiration_candidate_ids(now:)
          raise NotImplementedError
        end
      end
    end
  end
end
