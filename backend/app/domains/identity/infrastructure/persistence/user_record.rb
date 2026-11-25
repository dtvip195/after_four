module Identity
  module Infrastructure
    module Persistence
      class UserRecord < ApplicationRecord
        self.table_name = "users"

        devise :database_authenticatable, :recoverable, :lockable, :timeoutable

        has_many :authentication_sessions,
          class_name: "Identity::Infrastructure::Persistence::AuthenticationSessionRecord",
          foreign_key: :user_id,
          inverse_of: :user,
          dependent: :restrict_with_exception

        validates :organization_id, :username, :status, presence: true
        validates :username, length: { maximum: 100 }
        validates :email, length: { maximum: 254 }, allow_nil: true
        validates :status, inclusion: { in: %w[invited active suspended deactivated] }

        after_update :revoke_sessions_after_password_change, if: :saved_change_to_encrypted_password?

        def password=(new_password)
          super(normalize_password(new_password))
        end

        def password_confirmation=(new_password)
          @password_confirmation = normalize_password(new_password)
        end

        def active_for_authentication?
          super && status == "active"
        end

        def inactive_message
          :invalid
        end

        private

        def normalize_password(value)
          value.is_a?(String) ? value.unicode_normalize(:nfc) : value
        end

        def revoke_sessions_after_password_change
          authentication_sessions.where(revoked_at: nil).update_all(
            revoked_at: Time.current,
            revocation_reason: "credential_changed",
            updated_at: Time.current
          )
        end
      end
    end
  end
end
