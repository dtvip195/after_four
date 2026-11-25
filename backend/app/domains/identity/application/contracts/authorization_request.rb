module Identity
  module Application
    module Contracts
      AuthorizationRequest = Data.define(
        :action,
        :organization_id,
        :branch_id,
        :resource_owner_user_id
      )
    end
  end
end
