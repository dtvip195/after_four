class ProtectTerminalPaymentAttemptEvidence < ActiveRecord::Migration[8.1]
  def up
    execute <<~SQL
      CREATE FUNCTION protect_terminal_payment_attempt_evidence()
      RETURNS trigger
      LANGUAGE plpgsql
      AS $$
      BEGIN
        IF OLD.status IN ('succeeded', 'failed', 'cancelled') AND (
          NEW.payment_id IS DISTINCT FROM OLD.payment_id OR
          NEW.status IS DISTINCT FROM OLD.status OR
          NEW.requested_amount IS DISTINCT FROM OLD.requested_amount OR
          NEW.confirmed_amount IS DISTINCT FROM OLD.confirmed_amount OR
          NEW.method IS DISTINCT FROM OLD.method OR
          NEW.currency_code IS DISTINCT FROM OLD.currency_code OR
          NEW.idempotency_key IS DISTINCT FROM OLD.idempotency_key OR
          NEW.confirmed_by_actor_id IS DISTINCT FROM OLD.confirmed_by_actor_id OR
          NEW.confirmed_at IS DISTINCT FROM OLD.confirmed_at OR
          NEW.failure_code IS DISTINCT FROM OLD.failure_code
        ) THEN
          RAISE EXCEPTION 'Terminal payment attempt evidence is immutable'
            USING ERRCODE = '23514';
        END IF;

        RETURN NEW;
      END;
      $$;

      CREATE TRIGGER payment_attempts_terminal_evidence_immutable
      BEFORE UPDATE ON payment_attempts
      FOR EACH ROW
      EXECUTE FUNCTION protect_terminal_payment_attempt_evidence();
    SQL
  end

  def down
    execute <<~SQL
      DROP TRIGGER IF EXISTS payment_attempts_terminal_evidence_immutable ON payment_attempts;
      DROP FUNCTION IF EXISTS protect_terminal_payment_attempt_evidence();
    SQL
  end
end
