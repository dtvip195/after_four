module Identity
  module Infrastructure
    module Adapters
      class DeviseCredentialAuthenticator
        include Application::Ports::CredentialAuthenticator

        DUMMY_PASSWORD_DIGEST = Devise::Encryptor.digest(
          Persistence::UserRecord,
          "not-a-real-after-four-password"
        ).freeze

        def call(organization_id:, username:, password:)
          user = find_user(organization_id, username)
          return unknown_user(password) unless user
          return nil unless user.active_for_authentication?
          return nil if user.access_locked?

          normalized_password = password.to_s.unicode_normalize(:nfc)
          return successful_authentication(user) if user.valid_password?(normalized_password)

          failed_authentication(user)
          nil
        end

        private

        def find_user(organization_id, username)
          return nil unless organization_id.to_s.match?(Application::Contracts::IdentityOrganizationReference::UUID_PATTERN)
          return nil if username.to_s.empty?

          Persistence::UserRecord
            .where(organization_id: organization_id)
            .find_by("LOWER(username) = ?", username.to_s.strip.downcase)
        end

        def unknown_user(password)
          BCrypt::Password.new(DUMMY_PASSWORD_DIGEST).is_password?(password.to_s.unicode_normalize(:nfc))
          nil
        end

        def successful_authentication(user)
          user.unlock_access! if user.locked_at
          user.update_columns(failed_attempts: 0, updated_at: Time.current) if user.failed_attempts.positive?
          Application::Contracts::AuthenticatedIdentity.new(
            user_id: user.id,
            organization_id: user.organization_id
          )
        end

        def failed_authentication(user)
          user.with_lock do
            user.increment!(:failed_attempts)
            user.lock_access!(send_instructions: false) if user.failed_attempts >= Devise.maximum_attempts
          end
        end
      end
    end
  end
end
