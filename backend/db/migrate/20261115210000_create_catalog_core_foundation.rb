class CreateCatalogCoreFoundation < ActiveRecord::Migration[8.1]
  ASCII_WHITESPACE_SQL = "chr(32) || chr(9) || chr(10) || chr(13) || chr(12) || chr(11)"
  LIFECYCLE_SQL = "lifecycle_status IN ('draft', 'active', 'inactive', 'archived')"

  def up
    create_categories!
    create_products!
    create_product_variants!
    create_catalog_trigger_functions!
    create_catalog_triggers!
    verify_catalog_objects!
  end

  def down
    ensure_catalog_tables_empty!
    drop_catalog_triggers_and_functions!

    drop_table :product_variants
    drop_table :products
    drop_table :categories
  end

  private

  def create_categories!
    create_table :categories, id: false do |table|
      table.uuid :id, null: false, default: -> { "gen_random_uuid()" }
      table.uuid :brand_id, null: false
      table.string :code, null: false, limit: 64
      table.string :name, null: false, limit: 150
      table.integer :position, null: false, default: 0
      table.string :lifecycle_status, null: false, limit: 16, default: "draft"
      table.integer :lock_version, null: false, default: 0
      table.timestamps
    end

    execute "ALTER TABLE categories ADD CONSTRAINT categories_pkey PRIMARY KEY (id)"
    add_check_constraint :categories, "code ~ '^[A-Z0-9_-]+$'",
      name: "categories_code_canonical"
    add_check_constraint :categories,
      "length(translate(name, #{ASCII_WHITESPACE_SQL}, '')) > 0",
      name: "categories_name_nonblank"
    add_check_constraint :categories, "position >= 0",
      name: "categories_position_nonnegative"
    add_check_constraint :categories, LIFECYCLE_SQL,
      name: "categories_lifecycle_allowed"
    add_check_constraint :categories, "lock_version >= 0",
      name: "categories_lock_version_nonnegative"
    add_index :categories, [ :id, :brand_id ], unique: true,
      name: "uq_categories_id_brand"
    add_index :categories, [ :brand_id, :code ], unique: true,
      name: "uq_categories_brand_code"
    add_index :categories, [ :brand_id, :lifecycle_status, :position, :id ],
      name: "index_categories_on_brand_status_position"
    add_foreign_key :categories, :brands,
      column: :brand_id,
      name: "fk_categories_brand",
      on_delete: :restrict
  end

  def create_products!
    create_table :products, id: false do |table|
      table.uuid :id, null: false, default: -> { "gen_random_uuid()" }
      table.uuid :brand_id, null: false
      table.uuid :category_id, null: false
      table.string :code, null: false, limit: 64
      table.string :name, null: false, limit: 200
      table.text :description
      table.string :lifecycle_status, null: false, limit: 16
      table.integer :lock_version, null: false, default: 0
      table.timestamps
    end

    execute "ALTER TABLE products ADD CONSTRAINT products_pkey PRIMARY KEY (id)"
    add_check_constraint :products, "code ~ '^[A-Z0-9_-]+$'",
      name: "products_code_canonical"
    add_check_constraint :products,
      "length(translate(name, #{ASCII_WHITESPACE_SQL}, '')) > 0",
      name: "products_name_nonblank"
    add_check_constraint :products, LIFECYCLE_SQL,
      name: "products_lifecycle_allowed"
    add_check_constraint :products, "lock_version >= 0",
      name: "products_lock_version_nonnegative"
    add_index :products, [ :id, :brand_id ], unique: true,
      name: "uq_products_id_brand"
    add_index :products, [ :brand_id, :code ], unique: true,
      name: "uq_products_brand_code"
    add_index :products, [ :category_id, :lifecycle_status, :id ],
      name: "index_products_on_category_status"
    add_foreign_key :products, :brands,
      column: :brand_id,
      name: "fk_products_brand",
      on_delete: :restrict
    add_foreign_key :products, :categories,
      column: [ :category_id, :brand_id ],
      primary_key: [ :id, :brand_id ],
      name: "fk_products_category_brand",
      on_delete: :restrict
  end

  def create_product_variants!
    create_table :product_variants, id: false do |table|
      table.uuid :id, null: false, default: -> { "gen_random_uuid()" }
      table.uuid :brand_id, null: false
      table.uuid :product_id, null: false
      table.string :code, null: false, limit: 64
      table.string :name, null: false, limit: 150
      table.integer :position, null: false, default: 0
      table.string :lifecycle_status, null: false, limit: 16, default: "draft"
      table.boolean :is_default, null: false, default: false
      table.boolean :customer_visible, null: false, default: false
      table.integer :lock_version, null: false, default: 0
      table.timestamps
    end

    execute "ALTER TABLE product_variants ADD CONSTRAINT product_variants_pkey PRIMARY KEY (id)"
    add_check_constraint :product_variants, "code ~ '^[A-Z0-9_-]+$'",
      name: "product_variants_code_canonical"
    add_check_constraint :product_variants,
      "length(translate(name, #{ASCII_WHITESPACE_SQL}, '')) > 0",
      name: "product_variants_name_nonblank"
    add_check_constraint :product_variants, "position >= 0",
      name: "product_variants_position_nonnegative"
    add_check_constraint :product_variants, LIFECYCLE_SQL,
      name: "product_variants_lifecycle_allowed"
    add_check_constraint :product_variants, "lock_version >= 0",
      name: "product_variants_lock_version_nonnegative"
    add_index :product_variants, [ :brand_id, :code ], unique: true,
      name: "uq_product_variants_brand_code"
    add_index :product_variants, :product_id, unique: true, where: "is_default",
      name: "uq_product_variants_one_default"
    add_index :product_variants, [ :product_id, :lifecycle_status, :id ],
      name: "index_product_variants_on_product_status_id"
    add_foreign_key :product_variants, :brands,
      column: :brand_id,
      name: "fk_product_variants_brand",
      on_delete: :restrict
    add_foreign_key :product_variants, :products,
      column: [ :product_id, :brand_id ],
      primary_key: [ :id, :brand_id ],
      name: "fk_product_variants_product_brand",
      on_delete: :restrict
  end

  def ensure_catalog_tables_empty!
    %i[product_variants products categories].each do |table|
      next unless table_exists?(table)
      next if select_value("SELECT COUNT(*) FROM #{quote_table_name(table)}").to_i.zero?

      raise ActiveRecord::MigrationError,
        "Package B rollback refused because #{table} contains data"
    end
  end

  def create_catalog_trigger_functions!
    execute <<~SQL
      CREATE FUNCTION public.catalog_enforce_category_initial_status()
      RETURNS trigger
      LANGUAGE plpgsql
      VOLATILE
      SET search_path = pg_catalog, public
      AS $function$
      BEGIN
        IF NEW.lifecycle_status <> 'draft' THEN
          RAISE EXCEPTION 'Category must be created in Draft'
            USING ERRCODE = '23514', CONSTRAINT = 'categories_initial_lifecycle_draft';
        END IF;
        RETURN NEW;
      END;
      $function$;

      CREATE FUNCTION public.catalog_enforce_variant_initial_status()
      RETURNS trigger
      LANGUAGE plpgsql
      VOLATILE
      SET search_path = pg_catalog, public
      AS $function$
      BEGIN
        IF NEW.lifecycle_status <> 'draft' THEN
          RAISE EXCEPTION 'Variant must be created in Draft'
            USING ERRCODE = '23514', CONSTRAINT = 'product_variants_initial_lifecycle_draft';
        END IF;
        RETURN NEW;
      END;
      $function$;

      CREATE FUNCTION public.catalog_reject_category_scope_change()
      RETURNS trigger
      LANGUAGE plpgsql
      VOLATILE
      SET search_path = pg_catalog, public
      AS $function$
      BEGIN
        IF NEW.brand_id IS DISTINCT FROM OLD.brand_id THEN
          RAISE EXCEPTION 'Category Brand is immutable'
            USING ERRCODE = '23514', CONSTRAINT = 'categories_scope_immutable';
        END IF;
        RETURN NEW;
      END;
      $function$;

      CREATE FUNCTION public.catalog_reject_product_scope_change()
      RETURNS trigger
      LANGUAGE plpgsql
      VOLATILE
      SET search_path = pg_catalog, public
      AS $function$
      BEGIN
        IF NEW.brand_id IS DISTINCT FROM OLD.brand_id
          OR NEW.category_id IS DISTINCT FROM OLD.category_id THEN
          RAISE EXCEPTION 'Product Brand and Category are immutable'
            USING ERRCODE = '23514', CONSTRAINT = 'products_scope_immutable';
        END IF;
        RETURN NEW;
      END;
      $function$;

      CREATE FUNCTION public.catalog_reject_variant_scope_change()
      RETURNS trigger
      LANGUAGE plpgsql
      VOLATILE
      SET search_path = pg_catalog, public
      AS $function$
      BEGIN
        IF NEW.brand_id IS DISTINCT FROM OLD.brand_id
          OR NEW.product_id IS DISTINCT FROM OLD.product_id THEN
          RAISE EXCEPTION 'Variant Brand and Product are immutable'
            USING ERRCODE = '23514', CONSTRAINT = 'product_variants_scope_immutable';
        END IF;
        RETURN NEW;
      END;
      $function$;

      CREATE FUNCTION public.catalog_enforce_category_transition()
      RETURNS trigger
      LANGUAGE plpgsql
      VOLATILE
      SET search_path = pg_catalog, public
      AS $function$
      BEGIN
        IF NEW.lifecycle_status IS NOT DISTINCT FROM OLD.lifecycle_status THEN
          RETURN NEW;
        END IF;

        IF NOT (
          (OLD.lifecycle_status = 'draft' AND NEW.lifecycle_status IN ('active', 'archived'))
          OR (OLD.lifecycle_status = 'active' AND NEW.lifecycle_status IN ('inactive', 'archived'))
          OR (OLD.lifecycle_status = 'inactive' AND NEW.lifecycle_status IN ('active', 'archived'))
          OR (OLD.lifecycle_status = 'archived' AND NEW.lifecycle_status = 'inactive')
        ) THEN
          RAISE EXCEPTION 'Category lifecycle transition is prohibited'
            USING ERRCODE = '23514', CONSTRAINT = 'categories_lifecycle_transition_allowed';
        END IF;

        RETURN NEW;
      END;
      $function$;

      CREATE FUNCTION public.catalog_enforce_variant_transition()
      RETURNS trigger
      LANGUAGE plpgsql
      VOLATILE
      SET search_path = pg_catalog, public
      AS $function$
      BEGIN
        IF NEW.lifecycle_status IS NOT DISTINCT FROM OLD.lifecycle_status THEN
          RETURN NEW;
        END IF;

        IF NOT (
          (OLD.lifecycle_status = 'draft' AND NEW.lifecycle_status IN ('active', 'archived'))
          OR (OLD.lifecycle_status = 'active' AND NEW.lifecycle_status IN ('inactive', 'archived'))
          OR (OLD.lifecycle_status = 'inactive' AND NEW.lifecycle_status IN ('active', 'archived'))
          OR (OLD.lifecycle_status = 'archived' AND NEW.lifecycle_status = 'inactive')
        ) THEN
          RAISE EXCEPTION 'Variant lifecycle transition is prohibited'
            USING ERRCODE = '23514', CONSTRAINT = 'product_variants_lifecycle_transition_allowed';
        END IF;

        IF (NEW.lifecycle_status = 'archived' OR
            (OLD.lifecycle_status = 'archived' AND NEW.lifecycle_status = 'inactive'))
          AND (NEW.is_default IS DISTINCT FROM OLD.is_default
            OR NEW.customer_visible IS DISTINCT FROM OLD.customer_visible) THEN
          RAISE EXCEPTION 'Variant Archive or Restore must preserve flags'
            USING ERRCODE = '23514', CONSTRAINT = 'product_variants_lifecycle_transition_allowed';
        END IF;

        RETURN NEW;
      END;
      $function$;

      CREATE FUNCTION public.catalog_reject_purge()
      RETURNS trigger
      LANGUAGE plpgsql
      VOLATILE
      SET search_path = pg_catalog, public
      AS $function$
      DECLARE
        failure_identity text;
      BEGIN
        failure_identity := CASE TG_TABLE_NAME
          WHEN 'categories' THEN 'categories_purge_forbidden'
          WHEN 'products' THEN 'products_purge_forbidden'
          WHEN 'product_variants' THEN 'product_variants_purge_forbidden'
        END;

        RAISE EXCEPTION 'Catalog Purge is prohibited'
          USING ERRCODE = '23514', CONSTRAINT = failure_identity;
      END;
      $function$;

      CREATE FUNCTION public.catalog_validate_active_product_default()
      RETURNS trigger
      LANGUAGE plpgsql
      VOLATILE
      SET search_path = pg_catalog, public
      AS $function$
      DECLARE
        affected_product_ids uuid[];
      BEGIN
        IF TG_OP = 'UPDATE' THEN
          IF TG_TABLE_NAME = 'products' THEN
            IF NEW.lifecycle_status IS NOT DISTINCT FROM OLD.lifecycle_status THEN
              RETURN NEW;
            END IF;
          ELSIF TG_TABLE_NAME = 'product_variants' THEN
            IF NEW.product_id IS NOT DISTINCT FROM OLD.product_id
              AND NEW.brand_id IS NOT DISTINCT FROM OLD.brand_id
              AND NEW.lifecycle_status IS NOT DISTINCT FROM OLD.lifecycle_status
              AND NEW.is_default IS NOT DISTINCT FROM OLD.is_default THEN
              RETURN NEW;
            END IF;
          END IF;
        END IF;

        IF current_setting('transaction_isolation') <> 'read committed' THEN
          RAISE EXCEPTION 'Catalog final-state validation requires READ COMMITTED'
            USING ERRCODE = '23514', CONSTRAINT = 'catalog_integrity_requires_read_committed';
        END IF;

        IF TG_TABLE_NAME = 'products' THEN
          IF TG_OP = 'INSERT' THEN
            affected_product_ids := ARRAY[NEW.id];
          ELSE
            affected_product_ids := ARRAY[OLD.id, NEW.id];
          END IF;
        ELSIF TG_OP = 'INSERT' THEN
          affected_product_ids := ARRAY[NEW.product_id];
        ELSIF TG_OP = 'DELETE' THEN
          affected_product_ids := ARRAY[OLD.product_id];
        ELSE
          affected_product_ids := ARRAY[OLD.product_id, NEW.product_id];
        END IF;

        SELECT array_agg(DISTINCT product_id ORDER BY product_id)
        INTO affected_product_ids
        FROM unnest(affected_product_ids) AS ids(product_id)
        WHERE product_id IS NOT NULL;

        PERFORM products.id
        FROM public.products AS products
        WHERE products.id = ANY(affected_product_ids)
        ORDER BY products.id
        FOR UPDATE;

        IF EXISTS (
          SELECT 1
          FROM public.products AS products
          WHERE products.id = ANY(affected_product_ids)
            AND products.lifecycle_status = 'active'
            AND (
              SELECT COUNT(*)
              FROM public.product_variants AS variants
              WHERE variants.product_id = products.id
                AND variants.is_default
                AND variants.lifecycle_status = 'active'
            ) <> 1
        ) THEN
          RAISE EXCEPTION 'Active Product requires exactly one Active Default Variant'
            USING ERRCODE = '23514', CONSTRAINT = 'catalog_active_product_default_valid';
        END IF;

        IF TG_OP = 'DELETE' THEN
          RETURN OLD;
        END IF;
        RETURN NEW;
      END;
      $function$;

      CREATE FUNCTION public.catalog_validate_active_product_category()
      RETURNS trigger
      LANGUAGE plpgsql
      VOLATILE
      SET search_path = pg_catalog, public
      AS $function$
      DECLARE
        affected_category_ids uuid[];
        affected_product_ids uuid[];
      BEGIN
        IF TG_OP = 'UPDATE' THEN
          IF TG_TABLE_NAME = 'products' THEN
            IF NEW.category_id IS NOT DISTINCT FROM OLD.category_id
              AND NEW.brand_id IS NOT DISTINCT FROM OLD.brand_id
              AND NEW.lifecycle_status IS NOT DISTINCT FROM OLD.lifecycle_status THEN
              RETURN NEW;
            END IF;
          ELSIF TG_TABLE_NAME = 'categories' THEN
            IF NEW.lifecycle_status IS NOT DISTINCT FROM OLD.lifecycle_status THEN
              RETURN NEW;
            END IF;
          END IF;
        END IF;

        IF current_setting('transaction_isolation') <> 'read committed' THEN
          RAISE EXCEPTION 'Catalog final-state validation requires READ COMMITTED'
            USING ERRCODE = '23514', CONSTRAINT = 'catalog_integrity_requires_read_committed';
        END IF;

        IF TG_TABLE_NAME = 'products' THEN
          IF TG_OP = 'INSERT' THEN
            affected_category_ids := ARRAY[NEW.category_id];
            affected_product_ids := ARRAY[NEW.id];
          ELSE
            affected_category_ids := ARRAY[OLD.category_id, NEW.category_id];
            affected_product_ids := ARRAY[OLD.id, NEW.id];
          END IF;
        ELSIF TG_OP = 'INSERT' THEN
          affected_category_ids := ARRAY[NEW.id];
        ELSE
          affected_category_ids := ARRAY[OLD.id, NEW.id];
        END IF;

        SELECT array_agg(DISTINCT category_id ORDER BY category_id)
        INTO affected_category_ids
        FROM unnest(affected_category_ids) AS ids(category_id)
        WHERE category_id IS NOT NULL;

        PERFORM categories.id
        FROM public.categories AS categories
        WHERE categories.id = ANY(affected_category_ids)
        ORDER BY categories.id
        FOR UPDATE;

        IF TG_TABLE_NAME = 'products' THEN
          SELECT array_agg(DISTINCT product_id ORDER BY product_id)
          INTO affected_product_ids
          FROM unnest(affected_product_ids) AS ids(product_id)
          WHERE product_id IS NOT NULL;

          PERFORM products.id
          FROM public.products AS products
          WHERE products.id = ANY(affected_product_ids)
          ORDER BY products.id
          FOR UPDATE;
        ELSE
          PERFORM products.id
          FROM public.products AS products
          WHERE products.category_id = ANY(affected_category_ids)
          ORDER BY products.id
          FOR UPDATE;
        END IF;

        IF EXISTS (
          SELECT 1
          FROM public.products AS products
          JOIN public.categories AS categories ON categories.id = products.category_id
          WHERE products.category_id = ANY(affected_category_ids)
            AND products.lifecycle_status = 'active'
            AND categories.lifecycle_status <> 'active'
        ) THEN
          RAISE EXCEPTION 'Active Product requires an Active Category'
            USING ERRCODE = '23514', CONSTRAINT = 'catalog_active_product_category_valid';
        END IF;

        RETURN NEW;
      END;
      $function$;
    SQL
  end

  def create_catalog_triggers!
    execute <<~SQL
      CREATE TRIGGER categories_initial_lifecycle_draft
      BEFORE INSERT ON public.categories
      FOR EACH ROW EXECUTE FUNCTION public.catalog_enforce_category_initial_status();

      CREATE TRIGGER product_variants_initial_lifecycle_draft
      BEFORE INSERT ON public.product_variants
      FOR EACH ROW EXECUTE FUNCTION public.catalog_enforce_variant_initial_status();

      CREATE TRIGGER categories_scope_immutable
      BEFORE UPDATE OF brand_id ON public.categories
      FOR EACH ROW EXECUTE FUNCTION public.catalog_reject_category_scope_change();

      CREATE TRIGGER products_scope_immutable
      BEFORE UPDATE OF brand_id, category_id ON public.products
      FOR EACH ROW EXECUTE FUNCTION public.catalog_reject_product_scope_change();

      CREATE TRIGGER product_variants_scope_immutable
      BEFORE UPDATE OF brand_id, product_id ON public.product_variants
      FOR EACH ROW EXECUTE FUNCTION public.catalog_reject_variant_scope_change();

      CREATE TRIGGER categories_lifecycle_transition_allowed
      BEFORE UPDATE OF lifecycle_status ON public.categories
      FOR EACH ROW EXECUTE FUNCTION public.catalog_enforce_category_transition();

      CREATE TRIGGER product_variants_lifecycle_transition_allowed
      BEFORE UPDATE OF lifecycle_status ON public.product_variants
      FOR EACH ROW EXECUTE FUNCTION public.catalog_enforce_variant_transition();

      CREATE TRIGGER categories_purge_forbidden
      BEFORE DELETE ON public.categories
      FOR EACH ROW EXECUTE FUNCTION public.catalog_reject_purge();

      CREATE TRIGGER products_purge_forbidden
      BEFORE DELETE ON public.products
      FOR EACH ROW EXECUTE FUNCTION public.catalog_reject_purge();

      CREATE TRIGGER product_variants_purge_forbidden
      BEFORE DELETE ON public.product_variants
      FOR EACH ROW EXECUTE FUNCTION public.catalog_reject_purge();

      CREATE CONSTRAINT TRIGGER catalog_products_default_final_state
      AFTER INSERT OR UPDATE ON public.products
      DEFERRABLE INITIALLY DEFERRED
      FOR EACH ROW EXECUTE FUNCTION public.catalog_validate_active_product_default();

      CREATE CONSTRAINT TRIGGER catalog_product_variants_default_final_state
      AFTER INSERT OR UPDATE OR DELETE ON public.product_variants
      DEFERRABLE INITIALLY DEFERRED
      FOR EACH ROW EXECUTE FUNCTION public.catalog_validate_active_product_default();

      CREATE CONSTRAINT TRIGGER catalog_categories_product_final_state
      AFTER INSERT OR UPDATE ON public.categories
      DEFERRABLE INITIALLY DEFERRED
      FOR EACH ROW EXECUTE FUNCTION public.catalog_validate_active_product_category();

      CREATE CONSTRAINT TRIGGER catalog_products_category_final_state
      AFTER INSERT OR UPDATE ON public.products
      DEFERRABLE INITIALLY DEFERRED
      FOR EACH ROW EXECUTE FUNCTION public.catalog_validate_active_product_category();
    SQL
  end

  def drop_catalog_triggers_and_functions!
    execute <<~SQL
      DROP TRIGGER IF EXISTS catalog_products_category_final_state ON public.products;
      DROP TRIGGER IF EXISTS catalog_categories_product_final_state ON public.categories;
      DROP TRIGGER IF EXISTS catalog_product_variants_default_final_state ON public.product_variants;
      DROP TRIGGER IF EXISTS catalog_products_default_final_state ON public.products;
      DROP TRIGGER IF EXISTS product_variants_purge_forbidden ON public.product_variants;
      DROP TRIGGER IF EXISTS products_purge_forbidden ON public.products;
      DROP TRIGGER IF EXISTS categories_purge_forbidden ON public.categories;
      DROP TRIGGER IF EXISTS product_variants_lifecycle_transition_allowed ON public.product_variants;
      DROP TRIGGER IF EXISTS categories_lifecycle_transition_allowed ON public.categories;
      DROP TRIGGER IF EXISTS product_variants_scope_immutable ON public.product_variants;
      DROP TRIGGER IF EXISTS products_scope_immutable ON public.products;
      DROP TRIGGER IF EXISTS categories_scope_immutable ON public.categories;
      DROP TRIGGER IF EXISTS product_variants_initial_lifecycle_draft ON public.product_variants;
      DROP TRIGGER IF EXISTS categories_initial_lifecycle_draft ON public.categories;

      DROP FUNCTION IF EXISTS public.catalog_validate_active_product_category();
      DROP FUNCTION IF EXISTS public.catalog_validate_active_product_default();
      DROP FUNCTION IF EXISTS public.catalog_reject_purge();
      DROP FUNCTION IF EXISTS public.catalog_enforce_variant_transition();
      DROP FUNCTION IF EXISTS public.catalog_enforce_category_transition();
      DROP FUNCTION IF EXISTS public.catalog_reject_variant_scope_change();
      DROP FUNCTION IF EXISTS public.catalog_reject_product_scope_change();
      DROP FUNCTION IF EXISTS public.catalog_reject_category_scope_change();
      DROP FUNCTION IF EXISTS public.catalog_enforce_variant_initial_status();
      DROP FUNCTION IF EXISTS public.catalog_enforce_category_initial_status();
    SQL
  end

  def verify_catalog_objects!
    expected_functions = %w[
      catalog_enforce_category_initial_status
      catalog_enforce_variant_initial_status
      catalog_reject_category_scope_change
      catalog_reject_product_scope_change
      catalog_reject_variant_scope_change
      catalog_enforce_category_transition
      catalog_enforce_variant_transition
      catalog_reject_purge
      catalog_validate_active_product_default
      catalog_validate_active_product_category
    ]
    installed_functions = select_values(<<~SQL)
      SELECT proname
      FROM pg_proc
      WHERE proname IN (#{expected_functions.map { |name| quote(name) }.join(', ')})
        AND provolatile = 'v'
        AND proconfig @> ARRAY['search_path=pg_catalog, public']::text[]
    SQL

    expected_triggers = %w[
      categories_initial_lifecycle_draft
      product_variants_initial_lifecycle_draft
      categories_scope_immutable
      products_scope_immutable
      product_variants_scope_immutable
      categories_lifecycle_transition_allowed
      product_variants_lifecycle_transition_allowed
      categories_purge_forbidden
      products_purge_forbidden
      product_variants_purge_forbidden
      catalog_products_default_final_state
      catalog_product_variants_default_final_state
      catalog_categories_product_final_state
      catalog_products_category_final_state
    ]
    installed_triggers = select_values(<<~SQL)
      SELECT tgname
      FROM pg_trigger
      WHERE tgname IN (#{expected_triggers.map { |name| quote(name) }.join(', ')})
        AND NOT tgisinternal
    SQL

    missing_functions = expected_functions - installed_functions
    missing_triggers = expected_triggers - installed_triggers
    return if missing_functions.empty? && missing_triggers.empty?

    raise ActiveRecord::MigrationError,
      "Package B object verification failed: " \
      "functions=#{missing_functions.join(',')} triggers=#{missing_triggers.join(',')}"
  end
end
