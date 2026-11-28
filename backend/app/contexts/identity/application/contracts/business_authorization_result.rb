module Identity
  module Application
    module Contracts
      class BusinessAuthorizationResult
        STATUSES = %i[allowed denied dependency_unavailable not_implemented].freeze
        REASONS = %i[
          unsupported_capability
          organization_scope_denied
          authority_absent
          workforce_ineligible
          assurance_insufficient
          dependency_unavailable
        ].freeze

        attr_reader :status, :authorization, :reason

        class << self
          def allowed(authorization)
            raise ArgumentError, "allowed requires BusinessAuthorization" unless authorization.is_a?(BusinessAuthorization)

            new(status: :allowed, authorization: authorization)
          end

          def denied(reason)
            validate_reason!(reason)
            new(status: :denied, reason: reason)
          end

          def dependency_unavailable
            new(status: :dependency_unavailable, reason: :dependency_unavailable)
          end

          def not_implemented
            new(status: :not_implemented, reason: :unsupported_capability)
          end

          private

          def validate_reason!(reason)
            raise ArgumentError, "unknown denial reason" unless REASONS.include?(reason)
          end
        end

        STATUSES.each do |candidate|
          define_method("#{candidate}?") { status == candidate }
        end

        private

        def initialize(status:, authorization: nil, reason: nil)
          @status = status
          @authorization = authorization
          @reason = reason
          freeze
        end
      end
    end
  end
end
