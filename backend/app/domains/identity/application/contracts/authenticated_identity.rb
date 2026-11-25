module Identity
  module Application
    module Contracts
      AuthenticatedIdentity = Data.define(:user_id, :organization_id)
    end
  end
end
