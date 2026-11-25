module Identity
  module Application
    module Ports
      module CredentialAuthenticator
        def call(organization_id:, username:, password:)
          raise NotImplementedError
        end
      end
    end
  end
end
