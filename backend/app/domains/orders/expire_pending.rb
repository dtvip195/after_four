module Orders
  class ExpirePending
    extend CompatibilityErrorTranslation

    Result = Data.define(:expired_order_ids)

    def self.call(now: Time.current)
      translate_ordering_errors do
        dependencies = Infrastructure::Composition.dependencies
        application_result = Application::UseCases::ExpirePending.new(
          order_repository: dependencies.order_repository,
          payment_gateway: dependencies.payment_gateway,
          audit_log: dependencies.audit_log,
          unit_of_work: dependencies.unit_of_work
        ).call(now: now)
        Result.new(expired_order_ids: application_result.expired_order_ids)
      end
    end
  end
end
