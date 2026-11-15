module Identity
  module Application
    module Ports
      module OrganizationScope
        def call(_brand_reference)
          raise NotImplementedError
        end
      end
    end
  end
end
