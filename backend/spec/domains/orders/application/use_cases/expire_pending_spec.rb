require "spec_helper"
require_relative "../support/application_fakes"

RSpec.describe Orders::Application::UseCases::ExpirePending do
  include OrderingApplicationSpecSupport

  let(:repository) { OrderingApplicationSpecSupport::InMemoryOrderRepository.new }
  let(:payments) { OrderingApplicationSpecSupport::PaymentGatewayFake.new }
  let(:audit_log) { OrderingApplicationSpecSupport::AuditLogFake.new }
  let(:unit_of_work) { OrderingApplicationSpecSupport::UnitOfWorkFake.new }
  let(:use_case) do
    described_class.new(
      order_repository: repository,
      payment_gateway: payments,
      audit_log: audit_log,
      unit_of_work: unit_of_work
    )
  end

  it "expires eligible candidates in repository order and filters paid Orders" do
    first = confirmed_order
    paid = confirmed_order(id: "1e7d54a0-9a21-4bec-978f-032df0eb8bb9")
    repository.seed(first)
    repository.seed(paid)
    repository.candidates = [ first.id.to_s, paid.id.to_s ]
    payments.statuses[paid.id.to_s] = "fully_paid"

    result = use_case.call(now: OrderingApplicationSpecSupport::NOW + 300)

    expect(result.expired_order_ids).to eq([ first.id.to_s ])
    expect(first.status).to eq("expired")
    expect(paid.status).to eq("confirmed")
    expect(audit_log.events.map(&:first)).to eq([ :expired ])
    expect(unit_of_work.calls).to eq(2)
  end

  it "rechecks eligibility after locking each candidate" do
    future = confirmed_order
    repository.seed(future)
    repository.candidates = [ future.id.to_s ]

    result = use_case.call(now: OrderingApplicationSpecSupport::NOW + 299)

    expect(result.expired_order_ids).to be_empty
    expect(future.status).to eq("confirmed")
    expect(audit_log.events).to be_empty
  end

  it "preserves repository candidate ordering" do
    later = confirmed_order
    same_deadline_a = confirmed_order(id: "1e7d54a0-9a21-4bec-978f-032df0eb8bb9")
    same_deadline_b = confirmed_order(id: "2f8e65b1-ab32-4cfd-889a-143ef1fc9cca")
    [ later, same_deadline_a, same_deadline_b ].each { |order| repository.seed(order) }
    repository.candidates = [ same_deadline_a.id.to_s, same_deadline_b.id.to_s, later.id.to_s ]

    result = use_case.call(now: OrderingApplicationSpecSupport::NOW + 300)

    expect(result.expired_order_ids).to eq(repository.candidates)
  end
end
