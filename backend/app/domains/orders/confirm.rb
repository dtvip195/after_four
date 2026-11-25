module Orders
  class Confirm
    extend CompatibilityErrorTranslation

    Result = Data.define(:order, :replayed)
    IMPLICIT_NOW = Object.new.freeze

    def self.call(order_id:, actor_id:, idempotency_key:, expected_version:, now: IMPLICIT_NOW)
      translate_ordering_errors do
        dependencies = Infrastructure::Composition.dependencies
        clock = now.equal?(IMPLICIT_NOW) ? -> { Time.current } : -> { now }
        application_result = Application::UseCases::Confirm.new(
          order_repository: dependencies.order_repository,
          audit_log: dependencies.audit_log,
          unit_of_work: dependencies.unit_of_work,
          payment_window: Domain::ValueObjects::PaymentWindow.new(
            Rails.configuration.x.orders.payment_window_seconds
          ),
          clock: clock
        ).call(
          order_id: order_id,
          actor_id: actor_id,
          idempotency_key: idempotency_key,
          expected_version: expected_version
        )
        Result.new(
          order: dependencies.order_repository.compatibility_record(application_result.order.id.to_s),
          replayed: application_result.replayed
        )
      end
    end
  end
end
