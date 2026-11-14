module AuditEventCleanup
  def delete_audit_events_as_database_owner(relation)
    connection = ActiveRecord::Base.connection
    connection.execute("ALTER TABLE audit_events DISABLE TRIGGER audit_events_append_only")
    relation.delete_all
  ensure
    connection&.execute("ALTER TABLE audit_events ENABLE TRIGGER audit_events_append_only")
  end
end
