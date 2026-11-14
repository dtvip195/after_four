require "digest"

class AddCreationRequestFingerprintToOrders < ActiveRecord::Migration[8.1]
  def up
    add_column :orders, :creation_request_fingerprint, :string, limit: 64

    select_all(<<~SQL).each do |order|
      SELECT id, created_by_actor_id, channel, total_amount, currency_code
      FROM orders
    SQL
      fingerprint = fingerprint_for(order)
      execute <<~SQL
        UPDATE orders
        SET creation_request_fingerprint = #{connection.quote(fingerprint)}
        WHERE id = #{connection.quote(order.fetch("id"))}
      SQL
    end

    change_column_null :orders, :creation_request_fingerprint, false
    add_check_constraint :orders,
      "creation_request_fingerprint ~ '^[0-9a-f]{64}$'",
      name: "orders_creation_request_fingerprint_format"
  end

  def down
    remove_check_constraint :orders, name: "orders_creation_request_fingerprint_format"
    remove_column :orders, :creation_request_fingerprint
  end

  private

  def fingerprint_for(order)
    canonical_input = [
      "after_four.order.create.v1",
      order.fetch("created_by_actor_id").to_s.downcase,
      order.fetch("channel"),
      order.fetch("total_amount").to_i.to_s,
      order.fetch("currency_code").upcase
    ].join("\n")

    Digest::SHA256.hexdigest(canonical_input)
  end
end
