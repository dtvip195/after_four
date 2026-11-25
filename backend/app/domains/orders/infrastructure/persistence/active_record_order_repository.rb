module Orders
  module Infrastructure
    module Persistence
      class ActiveRecordOrderRepository
        include Application::Ports::OrderRepository

        CREATION_KEY_CONSTRAINT = "index_orders_on_branch_and_creation_key"

        def initialize(mapper: OrderMapper.new)
          @mapper = mapper
          @locked_records = {}
        end

        def find_by_creation_key(branch_id:, idempotency_key:)
          record = OrderRecord.find_by(
            branch_id: branch_id,
            creation_idempotency_key: idempotency_key
          )
          record && mapper.to_domain(record)
        end

        def validate_draft_attributes!(**attributes)
          now = attributes.fetch(:now)
          ::Order.new(
            attributes.except(:now).merge(
              status: "draft",
              created_at: now,
              updated_at: now
            )
          ).validate!
        end

        def add(order)
          mapper.build_record(order).save!
        rescue ActiveRecord::RecordNotUnique => error
          raise unless constraint_name(error) == CREATION_KEY_CONSTRAINT

          raise Application::Ports::OrderRepository::DuplicateCreationKey
        end

        def lock(order_id)
          record = OrderRecord.lock.find(order_id)
          locked_records[order_id.to_s] = record
          mapper.to_domain(record)
        end

        def save(order)
          record = locked_records.fetch(order.id.to_s) { OrderRecord.find(order.id.to_s) }
          mapper.apply(order, record).save!
        end

        def expiration_candidate_ids(now:)
          OrderRecord.where(status: "confirmed", payment_expires_at: ..now)
            .order(:payment_expires_at, :id)
            .pluck(:id)
        end

        def compatibility_record(order_id)
          ::Order.find(order_id)
        end

        private

        attr_reader :mapper, :locked_records

        def constraint_name(error)
          error.cause&.result&.error_field(PG::Result::PG_DIAG_CONSTRAINT_NAME)
        end
      end
    end
  end
end
