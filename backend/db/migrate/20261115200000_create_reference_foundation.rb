class CreateReferenceFoundation < ActiveRecord::Migration[8.1]
  ASCII_WHITESPACE_SQL = "chr(32) || chr(9) || chr(10) || chr(13) || chr(12) || chr(11)"
  NAME_NONBLANK_SQL = "length(translate(name, #{ASCII_WHITESPACE_SQL}, '')) > 0"
  TIMEZONE_NONBLANK_SQL = "length(translate(timezone_name, #{ASCII_WHITESPACE_SQL}, '')) > 0"

  def up
    create_organizations!
    create_brands!
    create_branches!
  end

  def down
    ensure_reference_tables_empty!

    drop_table :branches
    drop_table :brands
    drop_table :organizations
  end

  private

  def create_organizations!
    create_table :organizations, id: false do |t|
      t.uuid :id, null: false, default: -> { "gen_random_uuid()" }
      t.string :name, null: false, limit: 200
      t.integer :lock_version, null: false, default: 0
      t.timestamps
    end

    execute "ALTER TABLE organizations ADD CONSTRAINT organizations_pkey PRIMARY KEY (id)"
    add_check_constraint :organizations, NAME_NONBLANK_SQL,
      name: "organizations_name_nonblank"
  end

  def create_brands!
    create_table :brands, id: false do |t|
      t.uuid :id, null: false, default: -> { "gen_random_uuid()" }
      t.uuid :organization_id, null: false
      t.string :name, null: false, limit: 200
      t.integer :lock_version, null: false, default: 0
      t.timestamps
    end

    execute "ALTER TABLE brands ADD CONSTRAINT brands_pkey PRIMARY KEY (id)"
    add_check_constraint :brands, NAME_NONBLANK_SQL, name: "brands_name_nonblank"
    add_index :brands, :organization_id, name: "index_brands_on_organization_id"
    add_foreign_key :brands, :organizations,
      column: :organization_id,
      name: "fk_brands_organization",
      on_delete: :restrict
  end

  def create_branches!
    create_table :branches, id: false do |t|
      t.uuid :id, null: false, default: -> { "gen_random_uuid()" }
      t.uuid :brand_id, null: false
      t.string :name, null: false, limit: 200
      t.string :timezone_name, null: false, limit: 100
      t.integer :lock_version, null: false, default: 0
      t.timestamps
    end

    execute "ALTER TABLE branches ADD CONSTRAINT branches_pkey PRIMARY KEY (id)"
    add_check_constraint :branches, NAME_NONBLANK_SQL, name: "branches_name_nonblank"
    add_check_constraint :branches, TIMEZONE_NONBLANK_SQL,
      name: "branches_timezone_name_nonblank"
    add_index :branches, :brand_id, name: "index_branches_on_brand_id"
    add_foreign_key :branches, :brands,
      column: :brand_id,
      name: "fk_branches_brand",
      on_delete: :restrict
  end

  def ensure_reference_tables_empty!
    %i[branches brands organizations].each do |table|
      next unless table_exists?(table)
      next if select_value("SELECT COUNT(*) FROM #{quote_table_name(table)}").to_i.zero?

      raise ActiveRecord::MigrationError,
        "Package A1 rollback refused because #{table} contains data"
    end
  end
end
