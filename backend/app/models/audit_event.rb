class AuditEvent < ApplicationRecord
  before_update :prevent_mutation
  before_destroy :prevent_mutation

  validates :branch_id, :actor_type, :event_type, :subject_type, :subject_id,
    :idempotency_key, :occurred_at, presence: true

  private

  def prevent_mutation
    errors.add(:base, "Audit events are append-only")
    throw(:abort)
  end
end
