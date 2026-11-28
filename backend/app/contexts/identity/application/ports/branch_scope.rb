module Identity
  module Application
    module Ports
      module BranchScope
        def call(_branch_reference)
          raise NotImplementedError
        end
      end
    end
  end
end
