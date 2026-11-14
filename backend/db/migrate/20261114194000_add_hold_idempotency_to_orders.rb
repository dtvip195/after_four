class AddHoldIdempotencyToOrders < ActiveRecord::Migration[8.1]
  def change
    add_column :orders, :hold_idempotency_key, :string
    add_index :orders, [ :branch_id, :hold_idempotency_key ], unique: true,
      where: "hold_idempotency_key IS NOT NULL",
      name: "index_orders_on_branch_and_hold_key"
  end
end
