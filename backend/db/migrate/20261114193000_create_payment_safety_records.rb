class CreatePaymentSafetyRecords < ActiveRecord::Migration[8.1]
  def change
    create_table :payment_attempts, id: :uuid do |t|
      t.references :payment, null: false, foreign_key: true, type: :uuid
      t.string :method, null: false
      t.string :status, null: false
      t.bigint :requested_amount, null: false
      t.bigint :confirmed_amount
      t.string :currency_code, null: false, limit: 3
      t.string :idempotency_key, null: false
      t.uuid :confirmed_by_actor_id
      t.datetime :confirmed_at
      t.string :failure_code
      t.timestamps
    end

    add_index :payment_attempts, [ :payment_id, :idempotency_key ], unique: true,
      name: "index_payment_attempts_on_payment_and_key"
    add_index :payment_attempts, [ :payment_id, :status ]
    add_check_constraint :payment_attempts,
      "method IN ('cash', 'bank_transfer')",
      name: "payment_attempts_method_allowed"
    add_check_constraint :payment_attempts,
      "status IN ('initiated', 'pending', 'unknown', 'succeeded', 'failed', 'cancelled')",
      name: "payment_attempts_status_allowed"
    add_check_constraint :payment_attempts,
      "requested_amount > 0 AND (confirmed_amount IS NULL OR confirmed_amount > 0)",
      name: "payment_attempts_amounts_positive"
    add_check_constraint :payment_attempts,
      "currency_code = upper(currency_code) AND char_length(currency_code) = 3",
      name: "payment_attempts_currency_code_format"

    create_table :preparation_dispatches, id: :uuid do |t|
      t.references :order, null: false, foreign_key: true, type: :uuid, index: { unique: true }
      t.references :payment, null: false, foreign_key: true, type: :uuid
      t.uuid :branch_id, null: false
      t.string :status, null: false, default: "pending"
      t.string :idempotency_key, null: false
      t.datetime :requested_at, null: false
      t.datetime :dispatched_at
      t.integer :lock_version, null: false, default: 0
      t.timestamps
    end

    add_index :preparation_dispatches, [ :branch_id, :idempotency_key ], unique: true,
      name: "index_preparation_dispatches_on_branch_and_key"
    add_index :preparation_dispatches, [ :status, :requested_at ]
    add_check_constraint :preparation_dispatches,
      "status IN ('pending', 'dispatched')",
      name: "preparation_dispatches_status_allowed"

    create_table :preparation_dispatch_attempts, id: :uuid do |t|
      t.references :preparation_dispatch, null: false, foreign_key: true, type: :uuid
      t.integer :attempt_number, null: false
      t.string :status, null: false
      t.string :idempotency_key, null: false
      t.uuid :actor_id, null: false
      t.datetime :started_at, null: false
      t.datetime :completed_at
      t.string :error_code
      t.timestamps
    end

    add_index :preparation_dispatch_attempts,
      [ :preparation_dispatch_id, :attempt_number ], unique: true,
      name: "index_dispatch_attempts_on_dispatch_and_number"
    add_index :preparation_dispatch_attempts,
      [ :preparation_dispatch_id, :idempotency_key ], unique: true,
      name: "index_dispatch_attempts_on_dispatch_and_key"
    add_check_constraint :preparation_dispatch_attempts,
      "status IN ('started', 'succeeded', 'failed')",
      name: "preparation_dispatch_attempts_status_allowed"

    create_table :payment_review_cases, id: :uuid do |t|
      t.references :order, null: false, foreign_key: true, type: :uuid
      t.references :payment, null: false, foreign_key: true, type: :uuid
      t.references :payment_attempt, null: false, foreign_key: true, type: :uuid,
        index: { unique: true }
      t.string :kind, null: false
      t.string :status, null: false, default: "open"
      t.uuid :recorded_by_actor_id, null: false
      t.datetime :opened_at, null: false
      t.timestamps
    end

    add_index :payment_review_cases, [ :status, :opened_at ]
    add_check_constraint :payment_review_cases,
      "kind IN ('late_success')",
      name: "payment_review_cases_kind_allowed"
    add_check_constraint :payment_review_cases,
      "status IN ('open', 'resolved')",
      name: "payment_review_cases_status_allowed"

    create_table :outbox_events, id: :uuid do |t|
      t.string :event_key, null: false
      t.string :event_type, null: false
      t.string :aggregate_type, null: false
      t.uuid :aggregate_id, null: false
      t.jsonb :payload, null: false, default: {}
      t.string :status, null: false, default: "pending"
      t.integer :delivery_attempts, null: false, default: 0
      t.datetime :occurred_at, null: false
      t.datetime :available_at, null: false
      t.datetime :published_at
      t.timestamps
    end

    add_index :outbox_events, :event_key, unique: true
    add_index :outbox_events, [ :status, :available_at ]
    add_check_constraint :outbox_events,
      "status IN ('pending', 'published')",
      name: "outbox_events_status_allowed"
  end
end
