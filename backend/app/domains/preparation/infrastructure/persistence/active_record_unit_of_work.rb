module Preparation
  module Infrastructure
    module Persistence
      class ActiveRecordUnitOfWork
        include Application::Ports::UnitOfWork

        def call(&)
          ApplicationRecord.transaction(&)
        end
      end
    end
  end
end
