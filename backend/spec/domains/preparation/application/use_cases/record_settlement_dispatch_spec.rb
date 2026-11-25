require "rails_helper"

RSpec.describe Preparation::Application::UseCases::RecordSettlementDispatch do
  it "records one pending Dispatch and one Outbox intent without opening a transaction" do
    repository = InMemoryPreparationDispatchRepository.new
    outbox = RecordingPreparationOutbox.new
    now = Time.utc(2026, 11, 26, 10, 0, 0)
    attributes = {
      order_id: SecureRandom.uuid,
      payment_id: SecureRandom.uuid,
      branch_id: SecureRandom.uuid,
      now: now
    }
    use_case = described_class.new(
      dispatch_repository: repository,
      outbox: outbox,
      id_generator: -> { "00000000-0000-4000-8000-000000000002" }
    )

    first = use_case.call(**attributes)
    replay = use_case.call(**attributes)

    expect(first.replayed).to be(false)
    expect(replay).to have_attributes(dispatch: first.dispatch, replayed: true)
    expect(repository.dispatches).to eq([ first.dispatch ])
    expect(outbox.requested_dispatches).to eq([ first.dispatch ])
  end
end
