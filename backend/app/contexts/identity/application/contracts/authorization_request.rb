module Identity
  module Application
    module Contracts
      AuthorizationRequest = Data.define(
        :capability,
        :organization_id,
        :branch_id,
        :resource_owner_user_id,
        :resource_session_id
      )
    end
  end
end
