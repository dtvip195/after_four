module Identity
  module Application
    module Contracts
      AuthenticatedActor = Data.define(:user_id, :organization_id, :session_id)
    end
  end
end
