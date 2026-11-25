module Orders
  module Infrastructure
    module Composition
      Dependencies = Data.define(:order_repository, :payment_gateway, :audit_log, :unit_of_work)

      module_function

      def dependencies
        Dependencies.new(
          order_repository: Persistence::ActiveRecordOrderRepository.new,
          payment_gateway: Payments::Infrastructure::Adapters::OrderingPaymentGateway.new,
          audit_log: Adapters::ActiveRecordAuditLog.new,
          unit_of_work: Persistence::ActiveRecordUnitOfWork.new
        )
      end
    end
  end
end
