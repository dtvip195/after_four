module Orders
  module Infrastructure
    module Persistence
      class ActiveRecordUnitOfWork
        include Application::Ports::UnitOfWork

        def call(&block)
          ApplicationRecord.transaction(&block)
        end
      end
    end
  end
end
