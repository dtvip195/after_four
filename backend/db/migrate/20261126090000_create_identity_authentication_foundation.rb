class CreateIdentityAuthenticationFoundation < ActiveRecord::Migration[8.1]
  def change
    create_table :users, id: :uuid do |t|
      t.uuid :organization_id, null: false
      t.string :username, null: false, limit: 100
      t.string :email, limit: 254
      t.string :status, null: false, default: "invited", limit: 24

      t.string :encrypted_password, null: false, default: ""
      t.string :reset_password_token
      t.datetime :reset_password_sent_at
      t.integer :failed_attempts, null: false, default: 0
      t.string :unlock_token
      t.datetime :locked_at

      t.integer :lock_version, null: false, default: 0
      t.timestamps
    end

    add_foreign_key :users, :organizations, on_delete: :restrict
    add_index :users, "organization_id, lower(username)", unique: true,
      name: "index_users_on_organization_and_normalized_username"
    add_index :users, :reset_password_token, unique: true
    add_index :users, :unlock_token, unique: true
    add_check_constraint :users,
      "status IN ('invited', 'active', 'suspended', 'deactivated')",
      name: "users_status_allowed"
    add_check_constraint :users, "failed_attempts >= 0", name: "users_failed_attempts_nonnegative"
    add_check_constraint :users, "lock_version >= 0", name: "users_lock_version_nonnegative"

    create_table :authentication_sessions, id: :uuid do |t|
      t.uuid :user_id, null: false
      t.string :secret_verifier_digest, null: false, limit: 64
      t.string :csrf_verifier_digest, null: false, limit: 64
      t.datetime :authenticated_at, null: false
      t.datetime :last_seen_at, null: false
      t.datetime :idle_expires_at, null: false
      t.datetime :absolute_expires_at, null: false
      t.datetime :revoked_at
      t.string :revocation_reason, limit: 100
      t.integer :lock_version, null: false, default: 0
      t.timestamps
    end

    add_foreign_key :authentication_sessions, :users, on_delete: :restrict
    add_index :authentication_sessions, [ :user_id, :revoked_at ],
      name: "index_authentication_sessions_on_user_and_revocation"
    add_index :authentication_sessions, :idle_expires_at
    add_index :authentication_sessions, :absolute_expires_at
    add_check_constraint :authentication_sessions,
      "secret_verifier_digest ~ '^[0-9a-f]{64}$'",
      name: "authentication_sessions_secret_digest_format"
    add_check_constraint :authentication_sessions,
      "csrf_verifier_digest ~ '^[0-9a-f]{64}$'",
      name: "authentication_sessions_csrf_digest_format"
    add_check_constraint :authentication_sessions,
      "idle_expires_at <= absolute_expires_at",
      name: "authentication_sessions_expiry_order"
    add_check_constraint :authentication_sessions,
      "lock_version >= 0",
      name: "authentication_sessions_lock_version_nonnegative"
  end
end
