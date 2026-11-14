class EnforcePaymentAggregateIntegrity < ActiveRecord::Migration[8.1]
  def up
    audit_existing_data!

    add_check_constraint :payment_attempts,
      <<~SQL.squish,
        status <> 'succeeded' OR (
          confirmed_by_actor_id IS NOT NULL
          AND confirmed_at IS NOT NULL
          AND confirmed_amount IS NOT NULL
          AND confirmed_amount = requested_amount
          AND failure_code IS NULL
        )
      SQL
      name: "payment_attempts_succeeded_evidence_complete"

    add_index :payments, [ :id, :order_id ], unique: true,
      name: "index_payments_on_id_and_order_id"
    add_index :orders, [ :id, :branch_id ], unique: true,
      name: "index_orders_on_id_and_branch_id"
    add_index :payment_attempts, [ :id, :payment_id ], unique: true,
      name: "index_payment_attempts_on_id_and_payment_id"

    add_foreign_key :preparation_dispatches, :payments,
      column: [ :payment_id, :order_id ],
      primary_key: [ :id, :order_id ],
      name: "fk_dispatches_payment_order"
    add_foreign_key :preparation_dispatches, :orders,
      column: [ :order_id, :branch_id ],
      primary_key: [ :id, :branch_id ],
      name: "fk_dispatches_order_branch"
    add_foreign_key :payment_review_cases, :payments,
      column: [ :payment_id, :order_id ],
      primary_key: [ :id, :order_id ],
      name: "fk_review_cases_payment_order"
    add_foreign_key :payment_review_cases, :payment_attempts,
      column: [ :payment_attempt_id, :payment_id ],
      primary_key: [ :id, :payment_id ],
      name: "fk_review_cases_attempt_payment"

    create_payment_aggregate_triggers!
  end

  def down
    drop_payment_aggregate_triggers!

    remove_foreign_key :payment_review_cases, name: "fk_review_cases_attempt_payment"
    remove_foreign_key :payment_review_cases, name: "fk_review_cases_payment_order"
    remove_foreign_key :preparation_dispatches, name: "fk_dispatches_order_branch"
    remove_foreign_key :preparation_dispatches, name: "fk_dispatches_payment_order"

    remove_index :payment_attempts, name: "index_payment_attempts_on_id_and_payment_id"
    remove_index :orders, name: "index_orders_on_id_and_branch_id"
    remove_index :payments, name: "index_payments_on_id_and_order_id"
    remove_check_constraint :payment_attempts,
      name: "payment_attempts_succeeded_evidence_complete"
  end

  private

  def audit_existing_data!
    audits = {
      "Payment successful totals" => <<~SQL,
        SELECT COUNT(*)
        FROM payments AS payments
        WHERE payments.successful_amount <> COALESCE(
          (
            SELECT SUM(payment_attempts.confirmed_amount)
            FROM payment_attempts
            WHERE payment_attempts.payment_id = payments.id
              AND payment_attempts.status = 'succeeded'
          ),
          0
        )
          OR (
            payments.funding_status = 'fully_paid'
            AND payments.successful_amount <> payments.target_amount
          )
      SQL
      "succeeded Payment Attempt evidence" => <<~SQL,
        SELECT COUNT(*)
        FROM payment_attempts
        WHERE status = 'succeeded'
          AND (
            confirmed_by_actor_id IS NULL
            OR confirmed_at IS NULL
            OR confirmed_amount IS NULL
            OR confirmed_amount <> requested_amount
            OR failure_code IS NOT NULL
          )
      SQL
      "Preparation Dispatch aggregate references" => <<~SQL,
        SELECT COUNT(*)
        FROM preparation_dispatches AS dispatches
        JOIN payments ON payments.id = dispatches.payment_id
        JOIN orders ON orders.id = dispatches.order_id
        WHERE payments.order_id <> dispatches.order_id
          OR orders.branch_id <> dispatches.branch_id
      SQL
      "Payment Review Case aggregate references" => <<~SQL
        SELECT COUNT(*)
        FROM payment_review_cases AS review_cases
        JOIN payments ON payments.id = review_cases.payment_id
        JOIN payment_attempts ON payment_attempts.id = review_cases.payment_attempt_id
        WHERE payments.order_id <> review_cases.order_id
          OR payment_attempts.payment_id <> review_cases.payment_id
      SQL
    }

    violations = audits.filter_map do |name, query|
      count = select_value(query).to_i
      "#{name}: #{count}" if count.positive?
    end

    return if violations.empty?

    raise ActiveRecord::MigrationError,
      "M-02 integrity audit found existing violations; no data was changed: #{violations.join(', ')}"
  end

  def create_payment_aggregate_triggers!
    execute <<~SQL
      CREATE FUNCTION assert_payment_successful_total_consistent(target_payment_id uuid)
      RETURNS void
      LANGUAGE plpgsql
      AS $$
      DECLARE
        payment_record payments%ROWTYPE;
        attempt_total numeric;
      BEGIN
        SELECT *
        INTO payment_record
        FROM payments
        WHERE id = target_payment_id
        FOR UPDATE;

        IF NOT FOUND THEN
          RETURN;
        END IF;

        SELECT COALESCE(SUM(confirmed_amount), 0)
        INTO attempt_total
        FROM payment_attempts
        WHERE payment_id = target_payment_id
          AND status = 'succeeded';

        IF payment_record.successful_amount <> attempt_total THEN
          RAISE EXCEPTION
            'Payment successful_amount must equal its succeeded Payment Attempt total'
            USING ERRCODE = '23514';
        END IF;

        IF payment_record.funding_status = 'fully_paid'
          AND attempt_total <> payment_record.target_amount THEN
          RAISE EXCEPTION
            'A fully paid Payment requires exact successful Payment Attempt funding'
            USING ERRCODE = '23514';
        END IF;
      END;
      $$;

      CREATE FUNCTION enforce_payment_successful_total_from_payment()
      RETURNS trigger
      LANGUAGE plpgsql
      AS $$
      BEGIN
        PERFORM assert_payment_successful_total_consistent(NEW.id);
        RETURN NEW;
      END;
      $$;

      CREATE FUNCTION enforce_payment_successful_total_from_attempt()
      RETURNS trigger
      LANGUAGE plpgsql
      AS $$
      BEGIN
        IF TG_OP = 'DELETE' THEN
          PERFORM assert_payment_successful_total_consistent(OLD.payment_id);
          RETURN OLD;
        END IF;

        IF TG_OP = 'UPDATE' AND OLD.payment_id IS DISTINCT FROM NEW.payment_id THEN
          PERFORM assert_payment_successful_total_consistent(OLD.payment_id);
        END IF;

        PERFORM assert_payment_successful_total_consistent(NEW.payment_id);
        RETURN NEW;
      END;
      $$;

      CREATE CONSTRAINT TRIGGER payments_successful_total_consistent
      AFTER INSERT OR UPDATE ON payments
      DEFERRABLE INITIALLY DEFERRED
      FOR EACH ROW
      EXECUTE FUNCTION enforce_payment_successful_total_from_payment();

      CREATE CONSTRAINT TRIGGER payment_attempts_successful_total_consistent
      AFTER INSERT OR UPDATE OR DELETE ON payment_attempts
      DEFERRABLE INITIALLY DEFERRED
      FOR EACH ROW
      EXECUTE FUNCTION enforce_payment_successful_total_from_attempt();
    SQL
  end

  def drop_payment_aggregate_triggers!
    execute <<~SQL
      DROP TRIGGER IF EXISTS payment_attempts_successful_total_consistent ON payment_attempts;
      DROP TRIGGER IF EXISTS payments_successful_total_consistent ON payments;
      DROP FUNCTION IF EXISTS enforce_payment_successful_total_from_attempt();
      DROP FUNCTION IF EXISTS enforce_payment_successful_total_from_payment();
      DROP FUNCTION IF EXISTS assert_payment_successful_total_consistent(uuid);
    SQL
  end
end
