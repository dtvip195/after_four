module Preparation
  module Infrastructure
    module Persistence
      class ActiveRecordDispatchRepository
        include Application::Ports::DispatchRepository

        def initialize(mapper: DispatchMapper.new)
          @mapper = mapper
          @locked_records = {}
        end

        def find_by_order_id(order_id)
          record = DispatchRecord.find_by(order_id: order_id.to_s)
          record && mapper.to_domain(record)
        end

        def lock(dispatch_id)
          record = DispatchRecord.lock.find(dispatch_id.to_s)
          locked_records[record.id.to_s] = record
          mapper.to_domain(record)
        end

        def add(dispatch)
          DispatchRecord.create!(mapper.attributes(dispatch))
          dispatch
        end

        def save(dispatch)
          record = locked_records.fetch(dispatch.id.to_s) do
            raise Application::Ports::DispatchRepository::DispatchNotLocked,
              "Preparation Dispatch must be locked through this repository before it can be saved"
          end
          mapper.apply(dispatch, record).save!
          dispatch
        end

        private

        attr_reader :mapper, :locked_records
      end
    end
  end
end
