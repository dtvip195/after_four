require "rails_helper"

RSpec.describe Preparation::Application::UseCases::RetryDispatch do
  class RetryPreparationAuditLog < RecordingPreparationAuditLog
    attr_reader :retries

    def initialize(recorded: false)
      super()
      @recorded = recorded
      @retries = []
    end

    def dispatch_retry_recorded?(**)
      @recorded
    end

    def dispatch_retry_requested(**attributes)
      retries << attributes
    end
  end

  class RetryPreparationOutbox < RecordingPreparationOutbox
    attr_reader :requeues

    def initialize
      super
      @requeues = []
    end

    def requeue_dispatch(**attributes)
      requeues << attributes
    end
  end

  let(:now) { Time.utc(2026, 11, 26, 11, 0, 0) }
  let(:actor_id) { SecureRandom.uuid }
  let(:dispatch) do
    Preparation::Domain::Aggregates::Dispatch.pending(
      id: SecureRandom.uuid,
      order_id: SecureRandom.uuid,
      payment_id: SecureRandom.uuid,
      branch_id: SecureRandom.uuid,
      idempotency_key: "payment-settlement:payment",
      requested_at: now - 60
    )
  end

  it "requeues only a pending Dispatch and records retry evidence" do
    repository = InMemoryPreparationDispatchRepository.new([ dispatch ])
    outbox = RetryPreparationOutbox.new
    audit_log = RetryPreparationAuditLog.new
    use_case = described_class.new(
      dispatch_repository: repository,
      outbox: outbox,
      audit_log: audit_log,
      unit_of_work: InMemoryPreparationUnitOfWork.new
    )

    result = use_case.call(
      preparation_dispatch_id: dispatch.id.to_s,
      actor_id: actor_id,
      idempotency_key: "retry-1",
      now: now
    )

    expect(result).to have_attributes(preparation_dispatch: dispatch, replayed: false)
    expect(outbox.requeues).to eq([ { dispatch_id: dispatch.id.to_s, now: now } ])
    expect(audit_log.retries.one?).to be(true)
  end

  it "returns a replay without requeueing when the exact retry evidence exists" do
    outbox = RetryPreparationOutbox.new
    use_case = described_class.new(
      dispatch_repository: InMemoryPreparationDispatchRepository.new([ dispatch ]),
      outbox: outbox,
      audit_log: RetryPreparationAuditLog.new(recorded: true),
      unit_of_work: InMemoryPreparationUnitOfWork.new
    )

    result = use_case.call(
      preparation_dispatch_id: dispatch.id.to_s,
      actor_id: actor_id,
      idempotency_key: "retry-1",
      now: now
    )

    expect(result.replayed).to be(true)
    expect(outbox.requeues).to be_empty
  end

  it "rejects an invalid actor before loading or mutating a Dispatch" do
    repository = InMemoryPreparationDispatchRepository.new([ dispatch ])
    outbox = RetryPreparationOutbox.new
    use_case = described_class.new(
      dispatch_repository: repository,
      outbox: outbox,
      audit_log: RetryPreparationAuditLog.new,
      unit_of_work: InMemoryPreparationUnitOfWork.new
    )

    expect do
      use_case.call(
        preparation_dispatch_id: dispatch.id.to_s,
        actor_id: "invalid",
        idempotency_key: "retry-1",
        now: now
      )
    end.to raise_error(DomainError) { |error|
      expect(error).to have_attributes(code: "trusted_actor_required", details: {})
    }

    expect(outbox.requeues).to be_empty
  end
end
