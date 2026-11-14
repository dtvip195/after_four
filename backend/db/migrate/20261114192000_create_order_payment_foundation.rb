class CreateOrderPaymentFoundation < ActiveRecord::Migration[8.1]
  def change
    create_table :orders, id: :uuid do |t|
      t.uuid :branch_id, null: false
      t.uuid :created_by_actor_id, null: false
      t.string :order_number, null: false
      t.string :channel, null: false
      t.string :status, null: false, default: "draft"
      t.bigint :total_amount, null: false
      t.string :currency_code, null: false, limit: 3
      t.string :creation_idempotency_key, null: false
      t.string :confirmation_idempotency_key
      t.datetime :confirmed_at
      t.datetime :payment_expires_at
      t.datetime :expired_at
      t.datetime :held_at
      t.text :hold_reason
      t.integer :lock_version, null: false, default: 0
      t.timestamps
    end

    add_index :orders, [ :branch_id, :order_number ], unique: true
    add_index :orders, [ :branch_id, :creation_idempotency_key ], unique: true,
      name: "index_orders_on_branch_and_creation_key"
    add_index :orders, [ :status, :payment_expires_at ]
    add_check_constraint :orders,
      "channel IN ('dine_in', 'takeaway')",
      name: "orders_channel_allowed"
    add_check_constraint :orders,
      "status IN ('draft', 'confirmed', 'held', 'expired', 'cancelled', 'closed')",
      name: "orders_status_allowed"
    add_check_constraint :orders, "total_amount > 0", name: "orders_total_positive"
    add_check_constraint :orders,
      "currency_code = upper(currency_code) AND char_length(currency_code) = 3",
      name: "orders_currency_code_format"

    create_table :payments, id: :uuid do |t|
      t.references :order, null: false, foreign_key: true, type: :uuid, index: { unique: true }
      t.string :funding_status, null: false, default: "unpaid"
      t.string :attempt_activity, null: false, default: "idle"
      t.bigint :target_amount, null: false
      t.bigint :successful_amount, null: false, default: 0
      t.bigint :refunded_amount, null: false, default: 0
      t.string :currency_code, null: false, limit: 3
      t.datetime :fully_settled_at
      t.integer :lock_version, null: false, default: 0
      t.timestamps
    end

    add_check_constraint :payments,
      "funding_status IN ('unpaid', 'partially_paid', 'fully_paid', 'partially_refunded', 'fully_refunded')",
      name: "payments_funding_status_allowed"
    add_check_constraint :payments,
      "attempt_activity IN ('idle', 'processing', 'reconciliation_required')",
      name: "payments_attempt_activity_allowed"
    add_check_constraint :payments,
      <<~SQL.squish,
        (
          funding_status IN ('unpaid', 'partially_paid')
          AND attempt_activity IN ('idle', 'processing', 'reconciliation_required')
        ) OR (
          funding_status IN ('fully_paid', 'partially_refunded', 'fully_refunded')
          AND attempt_activity = 'idle'
        )
      SQL
      name: "payments_valid_state_combination"
    add_check_constraint :payments,
      "target_amount > 0 AND successful_amount >= 0 AND refunded_amount >= 0 AND successful_amount <= target_amount AND refunded_amount <= successful_amount",
      name: "payments_amounts_valid"
    add_check_constraint :payments,
      "currency_code = upper(currency_code) AND char_length(currency_code) = 3",
      name: "payments_currency_code_format"

    create_table :audit_events, id: :uuid do |t|
      t.uuid :branch_id, null: false
      t.string :actor_type, null: false
      t.uuid :actor_id
      t.string :event_type, null: false
      t.string :subject_type, null: false
      t.uuid :subject_id, null: false
      t.string :idempotency_key, null: false
      t.string :request_id
      t.jsonb :metadata, null: false, default: {}
      t.datetime :occurred_at, null: false
      t.datetime :created_at, null: false
    end

    add_index :audit_events, [ :subject_type, :subject_id, :occurred_at ]
    add_index :audit_events, [ :branch_id, :idempotency_key ], unique: true,
      name: "index_audit_events_on_branch_and_key"
    add_check_constraint :audit_events,
      "actor_type IN ('user', 'system') AND ((actor_type = 'user' AND actor_id IS NOT NULL) OR (actor_type = 'system' AND actor_id IS NULL))",
      name: "audit_events_actor_valid"
  end
end
