class ProtectAuditEventsAppendOnly < ActiveRecord::Migration[8.1]
  def up
    execute <<~SQL
      CREATE FUNCTION prevent_audit_event_mutation()
      RETURNS trigger
      LANGUAGE plpgsql
      AS $$
      BEGIN
        RAISE EXCEPTION 'Audit events are append-only: % is forbidden', TG_OP
          USING ERRCODE = '23514';
      END;
      $$;

      CREATE TRIGGER audit_events_append_only
      BEFORE UPDATE OR DELETE ON audit_events
      FOR EACH ROW
      EXECUTE FUNCTION prevent_audit_event_mutation();
    SQL
  end

  def down
    execute <<~SQL
      DROP TRIGGER IF EXISTS audit_events_append_only ON audit_events;
      DROP FUNCTION IF EXISTS prevent_audit_event_mutation();
    SQL
  end
end
