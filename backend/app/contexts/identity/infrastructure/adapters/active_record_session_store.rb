require "digest"

module Identity
  module Infrastructure
    module Adapters
      class ActiveRecordSessionStore
        include Application::Ports::SessionStore

        IDLE_LIFETIME = 30.minutes
        ABSOLUTE_LIFETIME = 12.hours

        def issue(identity:, now:)
          session_id = SecureRandom.uuid
          secret = SecureRandom.urlsafe_base64(32, padding: false)
          csrf_token = SecureRandom.urlsafe_base64(32, padding: false)
          absolute_expires_at = now + ABSOLUTE_LIFETIME
          idle_expires_at = [ now + IDLE_LIFETIME, absolute_expires_at ].min

          Persistence::AuthenticationSessionRecord.create!(
            id: session_id,
            user_id: identity.user_id,
            secret_verifier_digest: digest(secret),
            csrf_verifier_digest: digest(csrf_token),
            authenticated_at: now,
            last_seen_at: now,
            idle_expires_at: idle_expires_at,
            absolute_expires_at: absolute_expires_at
          )

          actor = Application::Contracts::AuthenticatedActor.new(
            user_id: identity.user_id,
            organization_id: identity.organization_id,
            session_id: session_id
          )
          Application::Contracts::IssuedSession.new(
            actor: actor,
            cookie_value: "#{session_id}.#{secret}",
            csrf_token: csrf_token,
            idle_expires_at: idle_expires_at,
            absolute_expires_at: absolute_expires_at
          )
        end

        def authenticate(cookie_value:, now:)
          session_id, secret = split_cookie(cookie_value)
          return nil unless session_id && secret

          session = Persistence::AuthenticationSessionRecord.find_by(id: session_id)
          return nil unless session

          session.with_lock do
            return nil unless valid_secret?(session, secret)
            return nil if session.revoked_at || now >= session.idle_expires_at || now >= session.absolute_expires_at
            return nil unless session.user.active_for_authentication?

            idle_expires_at = [ now + IDLE_LIFETIME, session.absolute_expires_at ].min
            session.update!(last_seen_at: now, idle_expires_at: idle_expires_at)
            Application::Contracts::AuthenticatedActor.new(
              user_id: session.user.id,
              organization_id: session.user.organization_id,
              session_id: session.id
            )
          end
        end

        def verify_csrf(actor:, token:)
          return false unless actor.is_a?(Application::Contracts::AuthenticatedActor)
          return false if token.to_s.empty?

          session = Persistence::AuthenticationSessionRecord.find_by(id: actor.session_id, user_id: actor.user_id)
          session.present? && secure_compare(session.csrf_verifier_digest, digest(token))
        end

        def revoke(cookie_value:, now:, reason:)
          session_id, secret = split_cookie(cookie_value)
          return false unless session_id && secret

          session = Persistence::AuthenticationSessionRecord.find_by(id: session_id)
          return false unless session

          session.with_lock do
            return false unless valid_secret?(session, secret)
            return true if session.revoked_at

            session.update!(revoked_at: now, revocation_reason: reason)
          end
          true
        end

        private

        def split_cookie(value)
          session_id, secret, extra = value.to_s.split(".", 3)
          return [ nil, nil ] if extra || secret.to_s.empty?
          return [ nil, nil ] unless session_id.to_s.match?(Application::Contracts::IdentityOrganizationReference::UUID_PATTERN)

          [ session_id, secret ]
        end

        def valid_secret?(session, secret)
          secure_compare(session.secret_verifier_digest, digest(secret))
        end

        def digest(value)
          Digest::SHA256.hexdigest(value)
        end

        def secure_compare(left, right)
          ActiveSupport::SecurityUtils.secure_compare(left, right)
        end
      end
    end
  end
end
