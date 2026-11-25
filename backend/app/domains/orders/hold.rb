module Orders
  class Hold
    extend CompatibilityErrorTranslation

    Result = Data.define(:order, :replayed)

    def self.call(order_id:, actor_id:, reason:, idempotency_key:, expected_version:, now: Time.current)
      translate_ordering_errors do
        dependencies = Infrastructure::Composition.dependencies
        application_result = Application::UseCases::Hold.new(
          order_repository: dependencies.order_repository,
          payment_gateway: dependencies.payment_gateway,
          audit_log: dependencies.audit_log,
          unit_of_work: dependencies.unit_of_work
        ).call(
          order_id: order_id,
          actor_id: actor_id,
          reason: reason,
          idempotency_key: idempotency_key,
          expected_version: expected_version,
          now: now
        )
        Result.new(
          order: dependencies.order_repository.compatibility_record(application_result.order.id.to_s),
          replayed: application_result.replayed
        )
      end
    end
  end
end
