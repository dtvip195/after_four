SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: assert_payment_successful_total_consistent(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.assert_payment_successful_total_consistent(target_payment_id uuid) RETURNS void
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


--
-- Name: catalog_enforce_category_initial_status(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.catalog_enforce_category_initial_status() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'pg_catalog', 'public'
    AS $$
BEGIN
  IF NEW.lifecycle_status <> 'draft' THEN
    RAISE EXCEPTION 'Category must be created in Draft'
      USING ERRCODE = '23514', CONSTRAINT = 'categories_initial_lifecycle_draft';
  END IF;
  RETURN NEW;
END;
$$;


--
-- Name: catalog_enforce_category_transition(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.catalog_enforce_category_transition() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'pg_catalog', 'public'
    AS $$
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
$$;


--
-- Name: catalog_enforce_variant_initial_status(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.catalog_enforce_variant_initial_status() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'pg_catalog', 'public'
    AS $$
BEGIN
  IF NEW.lifecycle_status <> 'draft' THEN
    RAISE EXCEPTION 'Variant must be created in Draft'
      USING ERRCODE = '23514', CONSTRAINT = 'product_variants_initial_lifecycle_draft';
  END IF;
  RETURN NEW;
END;
$$;


--
-- Name: catalog_enforce_variant_transition(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.catalog_enforce_variant_transition() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'pg_catalog', 'public'
    AS $$
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
$$;


--
-- Name: catalog_reject_category_scope_change(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.catalog_reject_category_scope_change() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'pg_catalog', 'public'
    AS $$
BEGIN
  IF NEW.brand_id IS DISTINCT FROM OLD.brand_id THEN
    RAISE EXCEPTION 'Category Brand is immutable'
      USING ERRCODE = '23514', CONSTRAINT = 'categories_scope_immutable';
  END IF;
  RETURN NEW;
END;
$$;


--
-- Name: catalog_reject_product_scope_change(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.catalog_reject_product_scope_change() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'pg_catalog', 'public'
    AS $$
BEGIN
  IF NEW.brand_id IS DISTINCT FROM OLD.brand_id
    OR NEW.category_id IS DISTINCT FROM OLD.category_id THEN
    RAISE EXCEPTION 'Product Brand and Category are immutable'
      USING ERRCODE = '23514', CONSTRAINT = 'products_scope_immutable';
  END IF;
  RETURN NEW;
END;
$$;


--
-- Name: catalog_reject_purge(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.catalog_reject_purge() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'pg_catalog', 'public'
    AS $$
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
$$;


--
-- Name: catalog_reject_variant_scope_change(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.catalog_reject_variant_scope_change() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'pg_catalog', 'public'
    AS $$
BEGIN
  IF NEW.brand_id IS DISTINCT FROM OLD.brand_id
    OR NEW.product_id IS DISTINCT FROM OLD.product_id THEN
    RAISE EXCEPTION 'Variant Brand and Product are immutable'
      USING ERRCODE = '23514', CONSTRAINT = 'product_variants_scope_immutable';
  END IF;
  RETURN NEW;
END;
$$;


--
-- Name: catalog_validate_active_product_category(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.catalog_validate_active_product_category() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'pg_catalog', 'public'
    AS $$
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
$$;


--
-- Name: catalog_validate_active_product_default(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.catalog_validate_active_product_default() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'pg_catalog', 'public'
    AS $$
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
$$;


--
-- Name: enforce_payment_successful_total_from_attempt(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.enforce_payment_successful_total_from_attempt() RETURNS trigger
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


--
-- Name: enforce_payment_successful_total_from_payment(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.enforce_payment_successful_total_from_payment() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  PERFORM assert_payment_successful_total_consistent(NEW.id);
  RETURN NEW;
END;
$$;


--
-- Name: prevent_audit_event_mutation(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.prevent_audit_event_mutation() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  RAISE EXCEPTION 'Audit events are append-only: % is forbidden', TG_OP
    USING ERRCODE = '23514';
END;
$$;


--
-- Name: protect_terminal_payment_attempt_evidence(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.protect_terminal_payment_attempt_evidence() RETURNS trigger
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


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: audit_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.audit_events (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    branch_id uuid NOT NULL,
    actor_type character varying NOT NULL,
    actor_id uuid,
    event_type character varying NOT NULL,
    subject_type character varying NOT NULL,
    subject_id uuid NOT NULL,
    idempotency_key character varying NOT NULL,
    request_id character varying,
    metadata jsonb DEFAULT '{}'::jsonb NOT NULL,
    occurred_at timestamp(6) with time zone NOT NULL,
    created_at timestamp(6) with time zone NOT NULL,
    CONSTRAINT audit_events_actor_valid CHECK ((((actor_type)::text = ANY (ARRAY[('user'::character varying)::text, ('system'::character varying)::text])) AND ((((actor_type)::text = 'user'::text) AND (actor_id IS NOT NULL)) OR (((actor_type)::text = 'system'::text) AND (actor_id IS NULL)))))
);


--
-- Name: branches; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.branches (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    brand_id uuid NOT NULL,
    name character varying(200) NOT NULL,
    timezone_name character varying(100) NOT NULL,
    lock_version integer DEFAULT 0 NOT NULL,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL,
    CONSTRAINT branches_name_nonblank CHECK ((length(translate((name)::text, (((((chr(32) || chr(9)) || chr(10)) || chr(13)) || chr(12)) || chr(11)), ''::text)) > 0)),
    CONSTRAINT branches_timezone_name_nonblank CHECK ((length(translate((timezone_name)::text, (((((chr(32) || chr(9)) || chr(10)) || chr(13)) || chr(12)) || chr(11)), ''::text)) > 0))
);


--
-- Name: brands; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.brands (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    organization_id uuid NOT NULL,
    name character varying(200) NOT NULL,
    lock_version integer DEFAULT 0 NOT NULL,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL,
    CONSTRAINT brands_name_nonblank CHECK ((length(translate((name)::text, (((((chr(32) || chr(9)) || chr(10)) || chr(13)) || chr(12)) || chr(11)), ''::text)) > 0))
);


--
-- Name: categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.categories (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    brand_id uuid NOT NULL,
    code character varying(64) NOT NULL,
    name character varying(150) NOT NULL,
    "position" integer DEFAULT 0 NOT NULL,
    lifecycle_status character varying(16) DEFAULT 'draft'::character varying NOT NULL,
    lock_version integer DEFAULT 0 NOT NULL,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL,
    CONSTRAINT categories_code_canonical CHECK (((code)::text ~ '^[A-Z0-9_-]+$'::text)),
    CONSTRAINT categories_lifecycle_allowed CHECK (((lifecycle_status)::text = ANY (ARRAY[('draft'::character varying)::text, ('active'::character varying)::text, ('inactive'::character varying)::text, ('archived'::character varying)::text]))),
    CONSTRAINT categories_lock_version_nonnegative CHECK ((lock_version >= 0)),
    CONSTRAINT categories_name_nonblank CHECK ((length(translate((name)::text, (((((chr(32) || chr(9)) || chr(10)) || chr(13)) || chr(12)) || chr(11)), ''::text)) > 0)),
    CONSTRAINT categories_position_nonnegative CHECK (("position" >= 0))
);


--
-- Name: orders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.orders (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    branch_id uuid NOT NULL,
    created_by_actor_id uuid NOT NULL,
    order_number character varying NOT NULL,
    channel character varying NOT NULL,
    status character varying DEFAULT 'draft'::character varying NOT NULL,
    total_amount bigint NOT NULL,
    currency_code character varying(3) NOT NULL,
    creation_idempotency_key character varying NOT NULL,
    confirmation_idempotency_key character varying,
    confirmed_at timestamp(6) with time zone,
    payment_expires_at timestamp(6) with time zone,
    expired_at timestamp(6) with time zone,
    held_at timestamp(6) with time zone,
    hold_reason text,
    lock_version integer DEFAULT 0 NOT NULL,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL,
    hold_idempotency_key character varying,
    creation_request_fingerprint character varying(64) NOT NULL,
    CONSTRAINT orders_channel_allowed CHECK (((channel)::text = ANY (ARRAY[('dine_in'::character varying)::text, ('takeaway'::character varying)::text]))),
    CONSTRAINT orders_creation_request_fingerprint_format CHECK (((creation_request_fingerprint)::text ~ '^[0-9a-f]{64}$'::text)),
    CONSTRAINT orders_currency_code_format CHECK ((((currency_code)::text = upper((currency_code)::text)) AND (char_length((currency_code)::text) = 3))),
    CONSTRAINT orders_status_allowed CHECK (((status)::text = ANY (ARRAY[('draft'::character varying)::text, ('confirmed'::character varying)::text, ('held'::character varying)::text, ('expired'::character varying)::text, ('cancelled'::character varying)::text, ('closed'::character varying)::text]))),
    CONSTRAINT orders_total_positive CHECK ((total_amount > 0))
);


--
-- Name: organizations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.organizations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(200) NOT NULL,
    lock_version integer DEFAULT 0 NOT NULL,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL,
    CONSTRAINT organizations_name_nonblank CHECK ((length(translate((name)::text, (((((chr(32) || chr(9)) || chr(10)) || chr(13)) || chr(12)) || chr(11)), ''::text)) > 0))
);


--
-- Name: outbox_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.outbox_events (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    event_key character varying NOT NULL,
    event_type character varying NOT NULL,
    aggregate_type character varying NOT NULL,
    aggregate_id uuid NOT NULL,
    payload jsonb DEFAULT '{}'::jsonb NOT NULL,
    status character varying DEFAULT 'pending'::character varying NOT NULL,
    delivery_attempts integer DEFAULT 0 NOT NULL,
    occurred_at timestamp(6) with time zone NOT NULL,
    available_at timestamp(6) with time zone NOT NULL,
    published_at timestamp(6) with time zone,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL,
    CONSTRAINT outbox_events_status_allowed CHECK (((status)::text = ANY (ARRAY[('pending'::character varying)::text, ('published'::character varying)::text])))
);


--
-- Name: payment_attempts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.payment_attempts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    payment_id uuid NOT NULL,
    method character varying NOT NULL,
    status character varying NOT NULL,
    requested_amount bigint NOT NULL,
    confirmed_amount bigint,
    currency_code character varying(3) NOT NULL,
    idempotency_key character varying NOT NULL,
    confirmed_by_actor_id uuid,
    confirmed_at timestamp(6) with time zone,
    failure_code character varying,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL,
    CONSTRAINT payment_attempts_amounts_positive CHECK (((requested_amount > 0) AND ((confirmed_amount IS NULL) OR (confirmed_amount > 0)))),
    CONSTRAINT payment_attempts_currency_code_format CHECK ((((currency_code)::text = upper((currency_code)::text)) AND (char_length((currency_code)::text) = 3))),
    CONSTRAINT payment_attempts_method_allowed CHECK (((method)::text = ANY (ARRAY[('cash'::character varying)::text, ('bank_transfer'::character varying)::text]))),
    CONSTRAINT payment_attempts_status_allowed CHECK (((status)::text = ANY (ARRAY[('initiated'::character varying)::text, ('pending'::character varying)::text, ('unknown'::character varying)::text, ('succeeded'::character varying)::text, ('failed'::character varying)::text, ('cancelled'::character varying)::text]))),
    CONSTRAINT payment_attempts_succeeded_evidence_complete CHECK ((((status)::text <> 'succeeded'::text) OR ((confirmed_by_actor_id IS NOT NULL) AND (confirmed_at IS NOT NULL) AND (confirmed_amount IS NOT NULL) AND (confirmed_amount = requested_amount) AND (failure_code IS NULL))))
);


--
-- Name: payment_review_cases; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.payment_review_cases (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    order_id uuid NOT NULL,
    payment_id uuid NOT NULL,
    payment_attempt_id uuid NOT NULL,
    kind character varying NOT NULL,
    status character varying DEFAULT 'open'::character varying NOT NULL,
    recorded_by_actor_id uuid NOT NULL,
    opened_at timestamp(6) with time zone NOT NULL,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL,
    CONSTRAINT payment_review_cases_kind_allowed CHECK (((kind)::text = 'late_success'::text)),
    CONSTRAINT payment_review_cases_status_allowed CHECK (((status)::text = ANY (ARRAY[('open'::character varying)::text, ('resolved'::character varying)::text])))
);


--
-- Name: payments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.payments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    order_id uuid NOT NULL,
    funding_status character varying DEFAULT 'unpaid'::character varying NOT NULL,
    attempt_activity character varying DEFAULT 'idle'::character varying NOT NULL,
    target_amount bigint NOT NULL,
    successful_amount bigint DEFAULT 0 NOT NULL,
    refunded_amount bigint DEFAULT 0 NOT NULL,
    currency_code character varying(3) NOT NULL,
    fully_settled_at timestamp(6) with time zone,
    lock_version integer DEFAULT 0 NOT NULL,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL,
    CONSTRAINT payments_amounts_valid CHECK (((target_amount > 0) AND (successful_amount >= 0) AND (refunded_amount >= 0) AND (successful_amount <= target_amount) AND (refunded_amount <= successful_amount))),
    CONSTRAINT payments_attempt_activity_allowed CHECK (((attempt_activity)::text = ANY (ARRAY[('idle'::character varying)::text, ('processing'::character varying)::text, ('reconciliation_required'::character varying)::text]))),
    CONSTRAINT payments_currency_code_format CHECK ((((currency_code)::text = upper((currency_code)::text)) AND (char_length((currency_code)::text) = 3))),
    CONSTRAINT payments_funding_status_allowed CHECK (((funding_status)::text = ANY (ARRAY[('unpaid'::character varying)::text, ('partially_paid'::character varying)::text, ('fully_paid'::character varying)::text, ('partially_refunded'::character varying)::text, ('fully_refunded'::character varying)::text]))),
    CONSTRAINT payments_valid_state_combination CHECK (((((funding_status)::text = ANY (ARRAY[('unpaid'::character varying)::text, ('partially_paid'::character varying)::text])) AND ((attempt_activity)::text = ANY (ARRAY[('idle'::character varying)::text, ('processing'::character varying)::text, ('reconciliation_required'::character varying)::text]))) OR (((funding_status)::text = ANY (ARRAY[('fully_paid'::character varying)::text, ('partially_refunded'::character varying)::text, ('fully_refunded'::character varying)::text])) AND ((attempt_activity)::text = 'idle'::text))))
);


--
-- Name: preparation_dispatch_attempts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.preparation_dispatch_attempts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    preparation_dispatch_id uuid NOT NULL,
    attempt_number integer NOT NULL,
    status character varying NOT NULL,
    idempotency_key character varying NOT NULL,
    actor_id uuid NOT NULL,
    started_at timestamp(6) with time zone NOT NULL,
    completed_at timestamp(6) with time zone,
    error_code character varying,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL,
    CONSTRAINT preparation_dispatch_attempts_status_allowed CHECK (((status)::text = ANY (ARRAY[('started'::character varying)::text, ('succeeded'::character varying)::text, ('failed'::character varying)::text])))
);


--
-- Name: preparation_dispatches; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.preparation_dispatches (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    order_id uuid NOT NULL,
    payment_id uuid NOT NULL,
    branch_id uuid NOT NULL,
    status character varying DEFAULT 'pending'::character varying NOT NULL,
    idempotency_key character varying NOT NULL,
    requested_at timestamp(6) with time zone NOT NULL,
    dispatched_at timestamp(6) with time zone,
    lock_version integer DEFAULT 0 NOT NULL,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL,
    CONSTRAINT preparation_dispatches_status_allowed CHECK (((status)::text = ANY (ARRAY[('pending'::character varying)::text, ('dispatched'::character varying)::text])))
);


--
-- Name: product_variants; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_variants (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    brand_id uuid NOT NULL,
    product_id uuid NOT NULL,
    code character varying(64) NOT NULL,
    name character varying(150) NOT NULL,
    "position" integer DEFAULT 0 NOT NULL,
    lifecycle_status character varying(16) DEFAULT 'draft'::character varying NOT NULL,
    is_default boolean DEFAULT false NOT NULL,
    customer_visible boolean DEFAULT false NOT NULL,
    lock_version integer DEFAULT 0 NOT NULL,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL,
    CONSTRAINT product_variants_code_canonical CHECK (((code)::text ~ '^[A-Z0-9_-]+$'::text)),
    CONSTRAINT product_variants_lifecycle_allowed CHECK (((lifecycle_status)::text = ANY (ARRAY[('draft'::character varying)::text, ('active'::character varying)::text, ('inactive'::character varying)::text, ('archived'::character varying)::text]))),
    CONSTRAINT product_variants_lock_version_nonnegative CHECK ((lock_version >= 0)),
    CONSTRAINT product_variants_name_nonblank CHECK ((length(translate((name)::text, (((((chr(32) || chr(9)) || chr(10)) || chr(13)) || chr(12)) || chr(11)), ''::text)) > 0)),
    CONSTRAINT product_variants_position_nonnegative CHECK (("position" >= 0))
);


--
-- Name: products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.products (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    brand_id uuid NOT NULL,
    category_id uuid NOT NULL,
    code character varying(64) NOT NULL,
    name character varying(200) NOT NULL,
    description text,
    lifecycle_status character varying(16) NOT NULL,
    lock_version integer DEFAULT 0 NOT NULL,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL,
    CONSTRAINT products_code_canonical CHECK (((code)::text ~ '^[A-Z0-9_-]+$'::text)),
    CONSTRAINT products_lifecycle_allowed CHECK (((lifecycle_status)::text = ANY (ARRAY[('draft'::character varying)::text, ('active'::character varying)::text, ('inactive'::character varying)::text, ('archived'::character varying)::text]))),
    CONSTRAINT products_lock_version_nonnegative CHECK ((lock_version >= 0)),
    CONSTRAINT products_name_nonblank CHECK ((length(translate((name)::text, (((((chr(32) || chr(9)) || chr(10)) || chr(13)) || chr(12)) || chr(11)), ''::text)) > 0))
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: solid_queue_batch_executions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solid_queue_batch_executions (
    id bigint NOT NULL,
    job_id bigint NOT NULL,
    batch_id bigint NOT NULL,
    created_at timestamp(6) with time zone NOT NULL
);


--
-- Name: solid_queue_batch_executions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.solid_queue_batch_executions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: solid_queue_batch_executions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.solid_queue_batch_executions_id_seq OWNED BY public.solid_queue_batch_executions.id;


--
-- Name: solid_queue_batches; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solid_queue_batches (
    id bigint NOT NULL,
    active_job_batch_id character varying,
    description character varying,
    on_finish text,
    on_success text,
    on_failure text,
    metadata text,
    total_jobs integer DEFAULT 0 NOT NULL,
    completed_jobs integer DEFAULT 0 NOT NULL,
    failed_jobs integer DEFAULT 0 NOT NULL,
    enqueued_at timestamp(6) with time zone,
    finished_at timestamp(6) with time zone,
    failed_at timestamp(6) with time zone,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: solid_queue_batches_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.solid_queue_batches_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: solid_queue_batches_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.solid_queue_batches_id_seq OWNED BY public.solid_queue_batches.id;


--
-- Name: solid_queue_blocked_executions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solid_queue_blocked_executions (
    id bigint NOT NULL,
    job_id bigint NOT NULL,
    queue_name character varying NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    concurrency_key character varying NOT NULL,
    expires_at timestamp(6) with time zone NOT NULL,
    created_at timestamp(6) with time zone NOT NULL
);


--
-- Name: solid_queue_blocked_executions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.solid_queue_blocked_executions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: solid_queue_blocked_executions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.solid_queue_blocked_executions_id_seq OWNED BY public.solid_queue_blocked_executions.id;


--
-- Name: solid_queue_claimed_executions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solid_queue_claimed_executions (
    id bigint NOT NULL,
    job_id bigint NOT NULL,
    process_id bigint,
    created_at timestamp(6) with time zone NOT NULL
);


--
-- Name: solid_queue_claimed_executions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.solid_queue_claimed_executions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: solid_queue_claimed_executions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.solid_queue_claimed_executions_id_seq OWNED BY public.solid_queue_claimed_executions.id;


--
-- Name: solid_queue_failed_executions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solid_queue_failed_executions (
    id bigint NOT NULL,
    job_id bigint NOT NULL,
    error text,
    created_at timestamp(6) with time zone NOT NULL
);


--
-- Name: solid_queue_failed_executions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.solid_queue_failed_executions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: solid_queue_failed_executions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.solid_queue_failed_executions_id_seq OWNED BY public.solid_queue_failed_executions.id;


--
-- Name: solid_queue_jobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solid_queue_jobs (
    id bigint NOT NULL,
    queue_name character varying NOT NULL,
    class_name character varying NOT NULL,
    arguments text,
    priority integer DEFAULT 0 NOT NULL,
    active_job_id character varying,
    scheduled_at timestamp(6) with time zone,
    finished_at timestamp(6) with time zone,
    concurrency_key character varying,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL,
    batch_id bigint
);


--
-- Name: solid_queue_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.solid_queue_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: solid_queue_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.solid_queue_jobs_id_seq OWNED BY public.solid_queue_jobs.id;


--
-- Name: solid_queue_pauses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solid_queue_pauses (
    id bigint NOT NULL,
    queue_name character varying NOT NULL,
    created_at timestamp(6) with time zone NOT NULL
);


--
-- Name: solid_queue_pauses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.solid_queue_pauses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: solid_queue_pauses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.solid_queue_pauses_id_seq OWNED BY public.solid_queue_pauses.id;


--
-- Name: solid_queue_processes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solid_queue_processes (
    id bigint NOT NULL,
    kind character varying NOT NULL,
    last_heartbeat_at timestamp(6) with time zone NOT NULL,
    supervisor_id bigint,
    pid integer NOT NULL,
    hostname character varying,
    metadata text,
    created_at timestamp(6) with time zone NOT NULL,
    name character varying NOT NULL
);


--
-- Name: solid_queue_processes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.solid_queue_processes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: solid_queue_processes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.solid_queue_processes_id_seq OWNED BY public.solid_queue_processes.id;


--
-- Name: solid_queue_ready_executions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solid_queue_ready_executions (
    id bigint NOT NULL,
    job_id bigint NOT NULL,
    queue_name character varying NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    created_at timestamp(6) with time zone NOT NULL
);


--
-- Name: solid_queue_ready_executions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.solid_queue_ready_executions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: solid_queue_ready_executions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.solid_queue_ready_executions_id_seq OWNED BY public.solid_queue_ready_executions.id;


--
-- Name: solid_queue_recurring_executions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solid_queue_recurring_executions (
    id bigint NOT NULL,
    job_id bigint NOT NULL,
    task_key character varying NOT NULL,
    run_at timestamp(6) with time zone NOT NULL,
    created_at timestamp(6) with time zone NOT NULL
);


--
-- Name: solid_queue_recurring_executions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.solid_queue_recurring_executions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: solid_queue_recurring_executions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.solid_queue_recurring_executions_id_seq OWNED BY public.solid_queue_recurring_executions.id;


--
-- Name: solid_queue_recurring_tasks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solid_queue_recurring_tasks (
    id bigint NOT NULL,
    key character varying NOT NULL,
    schedule character varying NOT NULL,
    command character varying(2048),
    class_name character varying,
    arguments text,
    queue_name character varying,
    priority integer DEFAULT 0,
    static boolean DEFAULT true NOT NULL,
    description text,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: solid_queue_recurring_tasks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.solid_queue_recurring_tasks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: solid_queue_recurring_tasks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.solid_queue_recurring_tasks_id_seq OWNED BY public.solid_queue_recurring_tasks.id;


--
-- Name: solid_queue_scheduled_executions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solid_queue_scheduled_executions (
    id bigint NOT NULL,
    job_id bigint NOT NULL,
    queue_name character varying NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    scheduled_at timestamp(6) with time zone NOT NULL,
    created_at timestamp(6) with time zone NOT NULL
);


--
-- Name: solid_queue_scheduled_executions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.solid_queue_scheduled_executions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: solid_queue_scheduled_executions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.solid_queue_scheduled_executions_id_seq OWNED BY public.solid_queue_scheduled_executions.id;


--
-- Name: solid_queue_semaphores; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solid_queue_semaphores (
    id bigint NOT NULL,
    key character varying NOT NULL,
    value integer DEFAULT 1 NOT NULL,
    expires_at timestamp(6) with time zone NOT NULL,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: solid_queue_semaphores_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.solid_queue_semaphores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: solid_queue_semaphores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.solid_queue_semaphores_id_seq OWNED BY public.solid_queue_semaphores.id;


--
-- Name: solid_queue_batch_executions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solid_queue_batch_executions ALTER COLUMN id SET DEFAULT nextval('public.solid_queue_batch_executions_id_seq'::regclass);


--
-- Name: solid_queue_batches id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solid_queue_batches ALTER COLUMN id SET DEFAULT nextval('public.solid_queue_batches_id_seq'::regclass);


--
-- Name: solid_queue_blocked_executions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solid_queue_blocked_executions ALTER COLUMN id SET DEFAULT nextval('public.solid_queue_blocked_executions_id_seq'::regclass);


--
-- Name: solid_queue_claimed_executions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solid_queue_claimed_executions ALTER COLUMN id SET DEFAULT nextval('public.solid_queue_claimed_executions_id_seq'::regclass);


--
-- Name: solid_queue_failed_executions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solid_queue_failed_executions ALTER COLUMN id SET DEFAULT nextval('public.solid_queue_failed_executions_id_seq'::regclass);


--
-- Name: solid_queue_jobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solid_queue_jobs ALTER COLUMN id SET DEFAULT nextval('public.solid_queue_jobs_id_seq'::regclass);


--
-- Name: solid_queue_pauses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solid_queue_pauses ALTER COLUMN id SET DEFAULT nextval('public.solid_queue_pauses_id_seq'::regclass);


--
-- Name: solid_queue_processes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solid_queue_processes ALTER COLUMN id SET DEFAULT nextval('public.solid_queue_processes_id_seq'::regclass);


--
-- Name: solid_queue_ready_executions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solid_queue_ready_executions ALTER COLUMN id SET DEFAULT nextval('public.solid_queue_ready_executions_id_seq'::regclass);


--
-- Name: solid_queue_recurring_executions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solid_queue_recurring_executions ALTER COLUMN id SET DEFAULT nextval('public.solid_queue_recurring_executions_id_seq'::regclass);


--
-- Name: solid_queue_recurring_tasks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solid_queue_recurring_tasks ALTER COLUMN id SET DEFAULT nextval('public.solid_queue_recurring_tasks_id_seq'::regclass);


--
-- Name: solid_queue_scheduled_executions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solid_queue_scheduled_executions ALTER COLUMN id SET DEFAULT nextval('public.solid_queue_scheduled_executions_id_seq'::regclass);


--
-- Name: solid_queue_semaphores id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solid_queue_semaphores ALTER COLUMN id SET DEFAULT nextval('public.solid_queue_semaphores_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: audit_events audit_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_events
    ADD CONSTRAINT audit_events_pkey PRIMARY KEY (id);


--
-- Name: branches branches_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.branches
    ADD CONSTRAINT branches_pkey PRIMARY KEY (id);


--
-- Name: brands brands_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.brands
    ADD CONSTRAINT brands_pkey PRIMARY KEY (id);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- Name: organizations organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT organizations_pkey PRIMARY KEY (id);


--
-- Name: outbox_events outbox_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.outbox_events
    ADD CONSTRAINT outbox_events_pkey PRIMARY KEY (id);


--
-- Name: payment_attempts payment_attempts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment_attempts
    ADD CONSTRAINT payment_attempts_pkey PRIMARY KEY (id);


--
-- Name: payment_review_cases payment_review_cases_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment_review_cases
    ADD CONSTRAINT payment_review_cases_pkey PRIMARY KEY (id);


--
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


--
-- Name: preparation_dispatch_attempts preparation_dispatch_attempts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.preparation_dispatch_attempts
    ADD CONSTRAINT preparation_dispatch_attempts_pkey PRIMARY KEY (id);


--
-- Name: preparation_dispatches preparation_dispatches_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.preparation_dispatches
    ADD CONSTRAINT preparation_dispatches_pkey PRIMARY KEY (id);


--
-- Name: product_variants product_variants_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_variants
    ADD CONSTRAINT product_variants_pkey PRIMARY KEY (id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: solid_queue_batch_executions solid_queue_batch_executions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solid_queue_batch_executions
    ADD CONSTRAINT solid_queue_batch_executions_pkey PRIMARY KEY (id);


--
-- Name: solid_queue_batches solid_queue_batches_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solid_queue_batches
    ADD CONSTRAINT solid_queue_batches_pkey PRIMARY KEY (id);


--
-- Name: solid_queue_blocked_executions solid_queue_blocked_executions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solid_queue_blocked_executions
    ADD CONSTRAINT solid_queue_blocked_executions_pkey PRIMARY KEY (id);


--
-- Name: solid_queue_claimed_executions solid_queue_claimed_executions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solid_queue_claimed_executions
    ADD CONSTRAINT solid_queue_claimed_executions_pkey PRIMARY KEY (id);


--
-- Name: solid_queue_failed_executions solid_queue_failed_executions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solid_queue_failed_executions
    ADD CONSTRAINT solid_queue_failed_executions_pkey PRIMARY KEY (id);


--
-- Name: solid_queue_jobs solid_queue_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solid_queue_jobs
    ADD CONSTRAINT solid_queue_jobs_pkey PRIMARY KEY (id);


--
-- Name: solid_queue_pauses solid_queue_pauses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solid_queue_pauses
    ADD CONSTRAINT solid_queue_pauses_pkey PRIMARY KEY (id);


--
-- Name: solid_queue_processes solid_queue_processes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solid_queue_processes
    ADD CONSTRAINT solid_queue_processes_pkey PRIMARY KEY (id);


--
-- Name: solid_queue_ready_executions solid_queue_ready_executions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solid_queue_ready_executions
    ADD CONSTRAINT solid_queue_ready_executions_pkey PRIMARY KEY (id);


--
-- Name: solid_queue_recurring_executions solid_queue_recurring_executions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solid_queue_recurring_executions
    ADD CONSTRAINT solid_queue_recurring_executions_pkey PRIMARY KEY (id);


--
-- Name: solid_queue_recurring_tasks solid_queue_recurring_tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solid_queue_recurring_tasks
    ADD CONSTRAINT solid_queue_recurring_tasks_pkey PRIMARY KEY (id);


--
-- Name: solid_queue_scheduled_executions solid_queue_scheduled_executions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solid_queue_scheduled_executions
    ADD CONSTRAINT solid_queue_scheduled_executions_pkey PRIMARY KEY (id);


--
-- Name: solid_queue_semaphores solid_queue_semaphores_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solid_queue_semaphores
    ADD CONSTRAINT solid_queue_semaphores_pkey PRIMARY KEY (id);


--
-- Name: idx_on_subject_type_subject_id_occurred_at_92d4f006a6; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_on_subject_type_subject_id_occurred_at_92d4f006a6 ON public.audit_events USING btree (subject_type, subject_id, occurred_at);


--
-- Name: index_audit_events_on_branch_and_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_audit_events_on_branch_and_key ON public.audit_events USING btree (branch_id, idempotency_key);


--
-- Name: index_branches_on_brand_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_branches_on_brand_id ON public.branches USING btree (brand_id);


--
-- Name: index_brands_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_brands_on_organization_id ON public.brands USING btree (organization_id);


--
-- Name: index_categories_on_brand_status_position; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_categories_on_brand_status_position ON public.categories USING btree (brand_id, lifecycle_status, "position", id);


--
-- Name: index_dispatch_attempts_on_dispatch_and_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_dispatch_attempts_on_dispatch_and_key ON public.preparation_dispatch_attempts USING btree (preparation_dispatch_id, idempotency_key);


--
-- Name: index_dispatch_attempts_on_dispatch_and_number; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_dispatch_attempts_on_dispatch_and_number ON public.preparation_dispatch_attempts USING btree (preparation_dispatch_id, attempt_number);


--
-- Name: index_orders_on_branch_and_creation_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_orders_on_branch_and_creation_key ON public.orders USING btree (branch_id, creation_idempotency_key);


--
-- Name: index_orders_on_branch_and_hold_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_orders_on_branch_and_hold_key ON public.orders USING btree (branch_id, hold_idempotency_key) WHERE (hold_idempotency_key IS NOT NULL);


--
-- Name: index_orders_on_branch_id_and_order_number; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_orders_on_branch_id_and_order_number ON public.orders USING btree (branch_id, order_number);


--
-- Name: index_orders_on_id_and_branch_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_orders_on_id_and_branch_id ON public.orders USING btree (id, branch_id);


--
-- Name: index_orders_on_status_and_payment_expires_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_orders_on_status_and_payment_expires_at ON public.orders USING btree (status, payment_expires_at);


--
-- Name: index_outbox_events_on_event_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_outbox_events_on_event_key ON public.outbox_events USING btree (event_key);


--
-- Name: index_outbox_events_on_status_and_available_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_outbox_events_on_status_and_available_at ON public.outbox_events USING btree (status, available_at);


--
-- Name: index_payment_attempts_on_id_and_payment_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_payment_attempts_on_id_and_payment_id ON public.payment_attempts USING btree (id, payment_id);


--
-- Name: index_payment_attempts_on_payment_and_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_payment_attempts_on_payment_and_key ON public.payment_attempts USING btree (payment_id, idempotency_key);


--
-- Name: index_payment_attempts_on_payment_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_payment_attempts_on_payment_id ON public.payment_attempts USING btree (payment_id);


--
-- Name: index_payment_attempts_on_payment_id_and_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_payment_attempts_on_payment_id_and_status ON public.payment_attempts USING btree (payment_id, status);


--
-- Name: index_payment_review_cases_on_order_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_payment_review_cases_on_order_id ON public.payment_review_cases USING btree (order_id);


--
-- Name: index_payment_review_cases_on_payment_attempt_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_payment_review_cases_on_payment_attempt_id ON public.payment_review_cases USING btree (payment_attempt_id);


--
-- Name: index_payment_review_cases_on_payment_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_payment_review_cases_on_payment_id ON public.payment_review_cases USING btree (payment_id);


--
-- Name: index_payment_review_cases_on_status_and_opened_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_payment_review_cases_on_status_and_opened_at ON public.payment_review_cases USING btree (status, opened_at);


--
-- Name: index_payments_on_id_and_order_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_payments_on_id_and_order_id ON public.payments USING btree (id, order_id);


--
-- Name: index_payments_on_order_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_payments_on_order_id ON public.payments USING btree (order_id);


--
-- Name: index_preparation_dispatch_attempts_on_preparation_dispatch_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_preparation_dispatch_attempts_on_preparation_dispatch_id ON public.preparation_dispatch_attempts USING btree (preparation_dispatch_id);


--
-- Name: index_preparation_dispatches_on_branch_and_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_preparation_dispatches_on_branch_and_key ON public.preparation_dispatches USING btree (branch_id, idempotency_key);


--
-- Name: index_preparation_dispatches_on_order_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_preparation_dispatches_on_order_id ON public.preparation_dispatches USING btree (order_id);


--
-- Name: index_preparation_dispatches_on_payment_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_preparation_dispatches_on_payment_id ON public.preparation_dispatches USING btree (payment_id);


--
-- Name: index_preparation_dispatches_on_status_and_requested_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_preparation_dispatches_on_status_and_requested_at ON public.preparation_dispatches USING btree (status, requested_at);


--
-- Name: index_product_variants_on_product_status_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_product_variants_on_product_status_id ON public.product_variants USING btree (product_id, lifecycle_status, id);


--
-- Name: index_products_on_category_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_products_on_category_status ON public.products USING btree (category_id, lifecycle_status, id);


--
-- Name: index_solid_queue_batch_executions_on_batch_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solid_queue_batch_executions_on_batch_id ON public.solid_queue_batch_executions USING btree (batch_id);


--
-- Name: index_solid_queue_batch_executions_on_job_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_solid_queue_batch_executions_on_job_id ON public.solid_queue_batch_executions USING btree (job_id);


--
-- Name: index_solid_queue_batches_on_active_job_batch_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_solid_queue_batches_on_active_job_batch_id ON public.solid_queue_batches USING btree (active_job_batch_id);


--
-- Name: index_solid_queue_batches_on_finished_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solid_queue_batches_on_finished_at ON public.solid_queue_batches USING btree (finished_at);


--
-- Name: index_solid_queue_blocked_executions_for_maintenance; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solid_queue_blocked_executions_for_maintenance ON public.solid_queue_blocked_executions USING btree (expires_at, concurrency_key);


--
-- Name: index_solid_queue_blocked_executions_for_release; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solid_queue_blocked_executions_for_release ON public.solid_queue_blocked_executions USING btree (concurrency_key, priority, job_id);


--
-- Name: index_solid_queue_blocked_executions_on_job_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_solid_queue_blocked_executions_on_job_id ON public.solid_queue_blocked_executions USING btree (job_id);


--
-- Name: index_solid_queue_claimed_executions_on_job_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_solid_queue_claimed_executions_on_job_id ON public.solid_queue_claimed_executions USING btree (job_id);


--
-- Name: index_solid_queue_claimed_executions_on_process_id_and_job_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solid_queue_claimed_executions_on_process_id_and_job_id ON public.solid_queue_claimed_executions USING btree (process_id, job_id);


--
-- Name: index_solid_queue_dispatch_all; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solid_queue_dispatch_all ON public.solid_queue_scheduled_executions USING btree (scheduled_at, priority, job_id);


--
-- Name: index_solid_queue_failed_executions_on_job_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_solid_queue_failed_executions_on_job_id ON public.solid_queue_failed_executions USING btree (job_id);


--
-- Name: index_solid_queue_jobs_for_alerting; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solid_queue_jobs_for_alerting ON public.solid_queue_jobs USING btree (scheduled_at, finished_at);


--
-- Name: index_solid_queue_jobs_for_filtering; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solid_queue_jobs_for_filtering ON public.solid_queue_jobs USING btree (queue_name, finished_at);


--
-- Name: index_solid_queue_jobs_on_active_job_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solid_queue_jobs_on_active_job_id ON public.solid_queue_jobs USING btree (active_job_id);


--
-- Name: index_solid_queue_jobs_on_batch_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solid_queue_jobs_on_batch_id ON public.solid_queue_jobs USING btree (batch_id);


--
-- Name: index_solid_queue_jobs_on_class_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solid_queue_jobs_on_class_name ON public.solid_queue_jobs USING btree (class_name);


--
-- Name: index_solid_queue_jobs_on_finished_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solid_queue_jobs_on_finished_at ON public.solid_queue_jobs USING btree (finished_at);


--
-- Name: index_solid_queue_pauses_on_queue_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_solid_queue_pauses_on_queue_name ON public.solid_queue_pauses USING btree (queue_name);


--
-- Name: index_solid_queue_poll_all; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solid_queue_poll_all ON public.solid_queue_ready_executions USING btree (priority, job_id);


--
-- Name: index_solid_queue_poll_by_queue; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solid_queue_poll_by_queue ON public.solid_queue_ready_executions USING btree (queue_name, priority, job_id);


--
-- Name: index_solid_queue_processes_on_last_heartbeat_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solid_queue_processes_on_last_heartbeat_at ON public.solid_queue_processes USING btree (last_heartbeat_at);


--
-- Name: index_solid_queue_processes_on_name_and_supervisor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_solid_queue_processes_on_name_and_supervisor_id ON public.solid_queue_processes USING btree (name, supervisor_id);


--
-- Name: index_solid_queue_processes_on_supervisor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solid_queue_processes_on_supervisor_id ON public.solid_queue_processes USING btree (supervisor_id);


--
-- Name: index_solid_queue_ready_executions_on_job_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_solid_queue_ready_executions_on_job_id ON public.solid_queue_ready_executions USING btree (job_id);


--
-- Name: index_solid_queue_recurring_executions_on_job_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_solid_queue_recurring_executions_on_job_id ON public.solid_queue_recurring_executions USING btree (job_id);


--
-- Name: index_solid_queue_recurring_executions_on_task_key_and_run_at; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_solid_queue_recurring_executions_on_task_key_and_run_at ON public.solid_queue_recurring_executions USING btree (task_key, run_at);


--
-- Name: index_solid_queue_recurring_tasks_on_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_solid_queue_recurring_tasks_on_key ON public.solid_queue_recurring_tasks USING btree (key);


--
-- Name: index_solid_queue_recurring_tasks_on_static; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solid_queue_recurring_tasks_on_static ON public.solid_queue_recurring_tasks USING btree (static);


--
-- Name: index_solid_queue_scheduled_executions_on_job_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_solid_queue_scheduled_executions_on_job_id ON public.solid_queue_scheduled_executions USING btree (job_id);


--
-- Name: index_solid_queue_semaphores_on_expires_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solid_queue_semaphores_on_expires_at ON public.solid_queue_semaphores USING btree (expires_at);


--
-- Name: index_solid_queue_semaphores_on_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_solid_queue_semaphores_on_key ON public.solid_queue_semaphores USING btree (key);


--
-- Name: index_solid_queue_semaphores_on_key_and_value; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solid_queue_semaphores_on_key_and_value ON public.solid_queue_semaphores USING btree (key, value);


--
-- Name: uq_categories_brand_code; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uq_categories_brand_code ON public.categories USING btree (brand_id, code);


--
-- Name: uq_categories_id_brand; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uq_categories_id_brand ON public.categories USING btree (id, brand_id);


--
-- Name: uq_product_variants_brand_code; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uq_product_variants_brand_code ON public.product_variants USING btree (brand_id, code);


--
-- Name: uq_product_variants_one_default; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uq_product_variants_one_default ON public.product_variants USING btree (product_id) WHERE is_default;


--
-- Name: uq_products_brand_code; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uq_products_brand_code ON public.products USING btree (brand_id, code);


--
-- Name: uq_products_id_brand; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uq_products_id_brand ON public.products USING btree (id, brand_id);


--
-- Name: audit_events audit_events_append_only; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER audit_events_append_only BEFORE DELETE OR UPDATE ON public.audit_events FOR EACH ROW EXECUTE FUNCTION public.prevent_audit_event_mutation();


--
-- Name: categories catalog_categories_product_final_state; Type: TRIGGER; Schema: public; Owner: -
--

CREATE CONSTRAINT TRIGGER catalog_categories_product_final_state AFTER INSERT OR UPDATE ON public.categories DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION public.catalog_validate_active_product_category();


--
-- Name: product_variants catalog_product_variants_default_final_state; Type: TRIGGER; Schema: public; Owner: -
--

CREATE CONSTRAINT TRIGGER catalog_product_variants_default_final_state AFTER INSERT OR DELETE OR UPDATE ON public.product_variants DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION public.catalog_validate_active_product_default();


--
-- Name: products catalog_products_category_final_state; Type: TRIGGER; Schema: public; Owner: -
--

CREATE CONSTRAINT TRIGGER catalog_products_category_final_state AFTER INSERT OR UPDATE ON public.products DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION public.catalog_validate_active_product_category();


--
-- Name: products catalog_products_default_final_state; Type: TRIGGER; Schema: public; Owner: -
--

CREATE CONSTRAINT TRIGGER catalog_products_default_final_state AFTER INSERT OR UPDATE ON public.products DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION public.catalog_validate_active_product_default();


--
-- Name: categories categories_initial_lifecycle_draft; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER categories_initial_lifecycle_draft BEFORE INSERT ON public.categories FOR EACH ROW EXECUTE FUNCTION public.catalog_enforce_category_initial_status();


--
-- Name: categories categories_lifecycle_transition_allowed; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER categories_lifecycle_transition_allowed BEFORE UPDATE OF lifecycle_status ON public.categories FOR EACH ROW EXECUTE FUNCTION public.catalog_enforce_category_transition();


--
-- Name: categories categories_purge_forbidden; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER categories_purge_forbidden BEFORE DELETE ON public.categories FOR EACH ROW EXECUTE FUNCTION public.catalog_reject_purge();


--
-- Name: categories categories_scope_immutable; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER categories_scope_immutable BEFORE UPDATE OF brand_id ON public.categories FOR EACH ROW EXECUTE FUNCTION public.catalog_reject_category_scope_change();


--
-- Name: payment_attempts payment_attempts_successful_total_consistent; Type: TRIGGER; Schema: public; Owner: -
--

CREATE CONSTRAINT TRIGGER payment_attempts_successful_total_consistent AFTER INSERT OR DELETE OR UPDATE ON public.payment_attempts DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION public.enforce_payment_successful_total_from_attempt();


--
-- Name: payment_attempts payment_attempts_terminal_evidence_immutable; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER payment_attempts_terminal_evidence_immutable BEFORE UPDATE ON public.payment_attempts FOR EACH ROW EXECUTE FUNCTION public.protect_terminal_payment_attempt_evidence();


--
-- Name: payments payments_successful_total_consistent; Type: TRIGGER; Schema: public; Owner: -
--

CREATE CONSTRAINT TRIGGER payments_successful_total_consistent AFTER INSERT OR UPDATE ON public.payments DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION public.enforce_payment_successful_total_from_payment();


--
-- Name: product_variants product_variants_initial_lifecycle_draft; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER product_variants_initial_lifecycle_draft BEFORE INSERT ON public.product_variants FOR EACH ROW EXECUTE FUNCTION public.catalog_enforce_variant_initial_status();


--
-- Name: product_variants product_variants_lifecycle_transition_allowed; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER product_variants_lifecycle_transition_allowed BEFORE UPDATE OF lifecycle_status ON public.product_variants FOR EACH ROW EXECUTE FUNCTION public.catalog_enforce_variant_transition();


--
-- Name: product_variants product_variants_purge_forbidden; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER product_variants_purge_forbidden BEFORE DELETE ON public.product_variants FOR EACH ROW EXECUTE FUNCTION public.catalog_reject_purge();


--
-- Name: product_variants product_variants_scope_immutable; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER product_variants_scope_immutable BEFORE UPDATE OF brand_id, product_id ON public.product_variants FOR EACH ROW EXECUTE FUNCTION public.catalog_reject_variant_scope_change();


--
-- Name: products products_purge_forbidden; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER products_purge_forbidden BEFORE DELETE ON public.products FOR EACH ROW EXECUTE FUNCTION public.catalog_reject_purge();


--
-- Name: products products_scope_immutable; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER products_scope_immutable BEFORE UPDATE OF brand_id, category_id ON public.products FOR EACH ROW EXECUTE FUNCTION public.catalog_reject_product_scope_change();


--
-- Name: branches fk_branches_brand; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.branches
    ADD CONSTRAINT fk_branches_brand FOREIGN KEY (brand_id) REFERENCES public.brands(id) ON DELETE RESTRICT;


--
-- Name: brands fk_brands_organization; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.brands
    ADD CONSTRAINT fk_brands_organization FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE RESTRICT;


--
-- Name: categories fk_categories_brand; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT fk_categories_brand FOREIGN KEY (brand_id) REFERENCES public.brands(id) ON DELETE RESTRICT;


--
-- Name: preparation_dispatches fk_dispatches_order_branch; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.preparation_dispatches
    ADD CONSTRAINT fk_dispatches_order_branch FOREIGN KEY (order_id, branch_id) REFERENCES public.orders(id, branch_id);


--
-- Name: preparation_dispatches fk_dispatches_payment_order; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.preparation_dispatches
    ADD CONSTRAINT fk_dispatches_payment_order FOREIGN KEY (payment_id, order_id) REFERENCES public.payments(id, order_id);


--
-- Name: product_variants fk_product_variants_brand; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_variants
    ADD CONSTRAINT fk_product_variants_brand FOREIGN KEY (brand_id) REFERENCES public.brands(id) ON DELETE RESTRICT;


--
-- Name: product_variants fk_product_variants_product_brand; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_variants
    ADD CONSTRAINT fk_product_variants_product_brand FOREIGN KEY (product_id, brand_id) REFERENCES public.products(id, brand_id) ON DELETE RESTRICT;


--
-- Name: products fk_products_brand; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT fk_products_brand FOREIGN KEY (brand_id) REFERENCES public.brands(id) ON DELETE RESTRICT;


--
-- Name: products fk_products_category_brand; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT fk_products_category_brand FOREIGN KEY (category_id, brand_id) REFERENCES public.categories(id, brand_id) ON DELETE RESTRICT;


--
-- Name: preparation_dispatch_attempts fk_rails_27bdb573b1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.preparation_dispatch_attempts
    ADD CONSTRAINT fk_rails_27bdb573b1 FOREIGN KEY (preparation_dispatch_id) REFERENCES public.preparation_dispatches(id);


--
-- Name: solid_queue_recurring_executions fk_rails_318a5533ed; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solid_queue_recurring_executions
    ADD CONSTRAINT fk_rails_318a5533ed FOREIGN KEY (job_id) REFERENCES public.solid_queue_jobs(id) ON DELETE CASCADE;


--
-- Name: payment_review_cases fk_rails_33755b5180; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment_review_cases
    ADD CONSTRAINT fk_rails_33755b5180 FOREIGN KEY (payment_attempt_id) REFERENCES public.payment_attempts(id);


--
-- Name: solid_queue_failed_executions fk_rails_39bbc7a631; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solid_queue_failed_executions
    ADD CONSTRAINT fk_rails_39bbc7a631 FOREIGN KEY (job_id) REFERENCES public.solid_queue_jobs(id) ON DELETE CASCADE;


--
-- Name: solid_queue_blocked_executions fk_rails_4cd34e2228; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solid_queue_blocked_executions
    ADD CONSTRAINT fk_rails_4cd34e2228 FOREIGN KEY (job_id) REFERENCES public.solid_queue_jobs(id) ON DELETE CASCADE;


--
-- Name: payment_review_cases fk_rails_65694b8bc2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment_review_cases
    ADD CONSTRAINT fk_rails_65694b8bc2 FOREIGN KEY (order_id) REFERENCES public.orders(id);


--
-- Name: payments fk_rails_6af949464b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT fk_rails_6af949464b FOREIGN KEY (order_id) REFERENCES public.orders(id);


--
-- Name: preparation_dispatches fk_rails_6f77de6a4b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.preparation_dispatches
    ADD CONSTRAINT fk_rails_6f77de6a4b FOREIGN KEY (payment_id) REFERENCES public.payments(id);


--
-- Name: payment_review_cases fk_rails_785a2135a3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment_review_cases
    ADD CONSTRAINT fk_rails_785a2135a3 FOREIGN KEY (payment_id) REFERENCES public.payments(id);


--
-- Name: solid_queue_batch_executions fk_rails_7c5e073422; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solid_queue_batch_executions
    ADD CONSTRAINT fk_rails_7c5e073422 FOREIGN KEY (batch_id) REFERENCES public.solid_queue_batches(id) ON DELETE CASCADE;


--
-- Name: solid_queue_ready_executions fk_rails_81fcbd66af; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solid_queue_ready_executions
    ADD CONSTRAINT fk_rails_81fcbd66af FOREIGN KEY (job_id) REFERENCES public.solid_queue_jobs(id) ON DELETE CASCADE;


--
-- Name: solid_queue_claimed_executions fk_rails_9cfe4d4944; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solid_queue_claimed_executions
    ADD CONSTRAINT fk_rails_9cfe4d4944 FOREIGN KEY (job_id) REFERENCES public.solid_queue_jobs(id) ON DELETE CASCADE;


--
-- Name: payment_attempts fk_rails_b75e38e353; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment_attempts
    ADD CONSTRAINT fk_rails_b75e38e353 FOREIGN KEY (payment_id) REFERENCES public.payments(id);


--
-- Name: solid_queue_batch_executions fk_rails_bc9f981155; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solid_queue_batch_executions
    ADD CONSTRAINT fk_rails_bc9f981155 FOREIGN KEY (job_id) REFERENCES public.solid_queue_jobs(id) ON DELETE CASCADE;


--
-- Name: solid_queue_scheduled_executions fk_rails_c4316f352d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solid_queue_scheduled_executions
    ADD CONSTRAINT fk_rails_c4316f352d FOREIGN KEY (job_id) REFERENCES public.solid_queue_jobs(id) ON DELETE CASCADE;


--
-- Name: preparation_dispatches fk_rails_f784b3fb57; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.preparation_dispatches
    ADD CONSTRAINT fk_rails_f784b3fb57 FOREIGN KEY (order_id) REFERENCES public.orders(id);


--
-- Name: payment_review_cases fk_review_cases_attempt_payment; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment_review_cases
    ADD CONSTRAINT fk_review_cases_attempt_payment FOREIGN KEY (payment_attempt_id, payment_id) REFERENCES public.payment_attempts(id, payment_id);


--
-- Name: payment_review_cases fk_review_cases_payment_order; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment_review_cases
    ADD CONSTRAINT fk_review_cases_payment_order FOREIGN KEY (payment_id, order_id) REFERENCES public.payments(id, order_id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20261115210000'),
('20261115200000'),
('20261114203000'),
('20261114202000'),
('20261114201000'),
('20261114200000'),
('20261114194000'),
('20261114193000'),
('20261114192000'),
('20261114044646');

