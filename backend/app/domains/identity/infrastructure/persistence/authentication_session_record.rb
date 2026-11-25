module Identity
  module Infrastructure
    module Persistence
      class AuthenticationSessionRecord < ApplicationRecord
        self.table_name = "authentication_sessions"

        belongs_to :user,
          class_name: "Identity::Infrastructure::Persistence::UserRecord",
          inverse_of: :authentication_sessions

        validates :secret_verifier_digest, :csrf_verifier_digest,
          format: { with: /\A[0-9a-f]{64}\z/ }
        validates :authenticated_at, :last_seen_at, :idle_expires_at, :absolute_expires_at,
          presence: true
      end
    end
  end
end
