module Orders
  module Application
    module Ports
      module UnitOfWork
        def call
          raise NotImplementedError
        end
      end
    end
  end
end
