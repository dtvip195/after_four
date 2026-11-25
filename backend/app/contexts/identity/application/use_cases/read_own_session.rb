module Identity
  module Application
    module UseCases
      class ReadOwnSession
        def call(context:, request:)
          return unless Authorize.new.call(context: context, request: request)

          Contracts::SessionDetails.new(
            user_id: context.user_id,
            organization_id: context.organization_id
          )
        end
      end
    end
  end
end
