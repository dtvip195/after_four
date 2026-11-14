require "rails_helper"

RSpec.describe "Audit Event database append-only protection" do
  it "keeps application-level protection for instance updates" do
    event = create_audit_event

    expect { event.update!(event_type: "test.rewritten") }
      .to raise_error(ActiveRecord::RecordNotSaved)
    expect(event.errors[:base]).to include("Audit events are append-only")
    expect(event.reload).to have_attributes(event_type: "test.recorded")
  end

  it "rejects update_columns at the database layer" do
    event = create_audit_event

    expect_database_rejection { event.update_columns(event_type: "test.rewritten") }

    expect(event.reload).to have_attributes(event_type: "test.recorded")
  end

  it "rejects update_all at the database layer" do
    event = create_audit_event

    expect_database_rejection do
      AuditEvent.where(id: event.id).update_all(event_type: "test.rewritten")
    end

    expect(event.reload).to have_attributes(event_type: "test.recorded")
  end

  it "keeps application-level protection for instance destruction" do
    event = create_audit_event

    expect { event.destroy! }
      .to raise_error(ActiveRecord::RecordNotDestroyed)
    expect(event.errors[:base]).to include("Audit events are append-only")
    expect(AuditEvent.exists?(event.id)).to be(true)
  end

  it "rejects delete_all at the database layer" do
    event = create_audit_event

    expect_database_rejection { AuditEvent.where(id: event.id).delete_all }

    expect(AuditEvent.exists?(event.id)).to be(true)
  end

  it "rejects a direct SQL update" do
    event = create_audit_event
    connection = ActiveRecord::Base.connection

    expect_database_rejection do
      connection.execute(<<~SQL)
        UPDATE audit_events
        SET event_type = 'test.rewritten'
        WHERE id = #{connection.quote(event.id)}
      SQL
    end

    expect(event.reload).to have_attributes(event_type: "test.recorded")
  end

  it "rejects a direct SQL delete" do
    event = create_audit_event
    connection = ActiveRecord::Base.connection

    expect_database_rejection do
      connection.execute(<<~SQL)
        DELETE FROM audit_events
        WHERE id = #{connection.quote(event.id)}
      SQL
    end

    expect(AuditEvent.exists?(event.id)).to be(true)
  end

  it "permits inserts and selects" do
    event = create_audit_event

    expect(event).to be_persisted
    expect(AuditEvent.find(event.id)).to have_attributes(
      event_type: "test.recorded",
      subject_type: "Order"
    )
  end

  it "permits multiple inserts in one transaction" do
    ids = []

    AuditEvent.transaction(requires_new: true) do
      ids << create_audit_event.id
      ids << create_audit_event.id
    end

    expect(AuditEvent.where(id: ids).count).to eq(2)
  end

  it "rolls back an insert with its parent transaction" do
    event_id = SecureRandom.uuid

    AuditEvent.transaction(requires_new: true) do
      create_audit_event(id: event_id)
      raise ActiveRecord::Rollback
    end

    expect(AuditEvent.exists?(event_id)).to be(false)
  end

  def expect_database_rejection(&)
    expect do
      AuditEvent.transaction(requires_new: true) do
        yield
      end
    end.to raise_error(ActiveRecord::StatementInvalid, /Audit events are append-only/)
  end

  def create_audit_event(**overrides)
    AuditEvent.create!({
      branch_id: SecureRandom.uuid,
      actor_type: "system",
      event_type: "test.recorded",
      subject_type: "Order",
      subject_id: SecureRandom.uuid,
      idempotency_key: "audit-database-protection-#{SecureRandom.uuid}",
      metadata: {},
      occurred_at: Time.utc(2026, 11, 14, 10, 0, 0),
      created_at: Time.utc(2026, 11, 14, 10, 0, 0)
    }.merge(overrides))
  end
end
