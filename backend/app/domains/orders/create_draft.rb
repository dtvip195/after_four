module Orders
  class CreateDraft
    include CompatibilityErrorTranslation

    Result = Data.define(:order, :payment, :replayed)

    def self.call(actor_id:, branch_id:, channel:, total_amount:, currency_code:, idempotency_key:, now: Time.current)
      new(
        actor_id: actor_id,
        branch_id: branch_id,
        channel: channel,
        total_amount: total_amount,
        currency_code: currency_code,
        idempotency_key: idempotency_key,
        now: now
      ).call
    end

    def initialize(actor_id:, branch_id:, channel:, total_amount:, currency_code:, idempotency_key:, now:)
      @actor_id = actor_id.to_s.downcase
      @branch_id = branch_id
      @channel = channel.to_s
      @total_amount = Integer(total_amount)
      @currency_code = currency_code.to_s.upcase
      @idempotency_key = idempotency_key
      @now = now
    end

    def call
      translate_ordering_errors do
        dependencies = Infrastructure::Composition.dependencies
        application_result = Application::UseCases::CreateDraft.new(
          order_repository: dependencies.order_repository,
          payment_gateway: dependencies.payment_gateway,
          audit_log: dependencies.audit_log,
          unit_of_work: dependencies.unit_of_work,
          id_generator: -> { SecureRandom.uuid },
          order_number_generator: -> { "AF-#{SecureRandom.hex(6).upcase}" }
        ).call(
          actor_id: @actor_id,
          branch_id: @branch_id,
          channel: @channel,
          total_amount: @total_amount,
          currency_code: @currency_code,
          idempotency_key: @idempotency_key,
          now: @now
        )
        Result.new(
          order: dependencies.order_repository.compatibility_record(application_result.order.id.to_s),
          payment: dependencies.payment_gateway.compatibility_record(application_result.payment_reference),
          replayed: application_result.replayed
        )
      end
    end
  end
end
