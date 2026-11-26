class CreateWorkforceEmployeeFoundation < ActiveRecord::Migration[8.1]
  def change
    create_table :employees, id: :uuid do |table|
      table.uuid :organization_id, null: false
      table.integer :lock_version, null: false, default: 0
      table.timestamps
    end

    add_foreign_key :employees, :organizations,
      column: :organization_id,
      name: "fk_employees_organization",
      on_delete: :restrict
    add_index :employees, :organization_id,
      name: "index_employees_on_organization_id"
    add_check_constraint :employees, "lock_version >= 0",
      name: "employees_lock_version_nonnegative"
  end
end
