module Identity
  module Application
    module Contracts
      IssuedSession = Data.define(
        :actor,
        :cookie_value,
        :csrf_token,
        :idle_expires_at,
        :absolute_expires_at
      )
    end
  end
end
