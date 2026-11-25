require "spec_helper"
require_relative "../support/application_fakes"

RSpec.describe "Ordering Application port contracts" do
  it "keeps each explicit fake adapter complete against its port" do
    {
      Orders::Application::Ports::OrderRepository => OrderingApplicationSpecSupport::InMemoryOrderRepository,
      Orders::Application::Ports::PaymentGateway => OrderingApplicationSpecSupport::PaymentGatewayFake,
      Orders::Application::Ports::AuditLog => OrderingApplicationSpecSupport::AuditLogFake,
      Orders::Application::Ports::UnitOfWork => OrderingApplicationSpecSupport::UnitOfWorkFake
    }.each do |port, fake|
      expect(fake.instance_methods(false)).to include(*port.instance_methods(false))
      expect(contract_violations(port, fake)).to be_empty
    end
  end

  it "detects a same-name fake operation with an incompatible interface" do
    incompatible = Class.new(OrderingApplicationSpecSupport::PaymentGatewayFake) do
      def create_target(order_id:)
        order_id
      end
    end

    expect(contract_violations(Orders::Application::Ports::PaymentGateway, incompatible))
      .to include(/create_target interface/)
  end

  def contract_violations(port, adapter)
    port.public_instance_methods(false).filter_map do |operation|
      next "#{operation} must be public" unless adapter.public_method_defined?(operation)

      expected = normalized_parameters(port.instance_method(operation))
      actual = normalized_parameters(adapter.instance_method(operation))
      "#{operation} interface expected #{expected.inspect}, got #{actual.inspect}" unless actual == expected
    end
  end

  def normalized_parameters(method)
    method.parameters.map do |kind, name|
      %i[req opt rest keyrest block].include?(kind) ? [ kind ] : [ kind, name ]
    end
  end
end
