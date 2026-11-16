# AFTER FOUR Data Dictionary v1.0

**Status:** Logical recommendations for review; not a migration specification  
**Date:** 2026-11-14  
**Sources:** [Owner Decision Baseline](after_four_owner_decision_baseline.md) · [DDD Foundation](after_four_ddd_foundation.md) · [Business Domain Model](after_four_business_domain_model.md) · [Logical ERD](after_four_erd.md) · [Integrity Rules](after_four_data_integrity_rules.md) · [Payment Model](after_four_payment_model.md) · [UUID ADR](adr/0004-uuid-primary-keys.md) · [PostgreSQL ADR](adr/0003-postgresql-version-baseline.md) · [Schema ADR](adr/0010-database-migrations-and-schema.md)

## 1. Reading conventions

Every recommendation in this document is `TECHNICAL_PROPOSAL` unless a row explicitly carries `OWNER_CONFIRMED`, `WORKSHOP_AGREED`, `OPEN_DECISION`, or `LEGAL_VALIDATION`.

- `R` = required; `O` = optional.
- `PK`, `FK`, `UQ` = primary key, foreign key, unique constraint.
- All entities inherit `id uuid R PK` and `created_at timestamptz R default now()` unless noted.
- Mutable aggregate/root records also use `updated_at timestamptz R default now()` and `lock_version integer R default 0`.
- Immutable ledger/event rows omit `updated_at`; corrections create new rows.
- FK deletion defaults to `RESTRICT`. Archival/deactivation is preferred over cascade deletion for referenced business data.

## 2. Logical type and time conventions

| Value | Recommended type | Reason / rule |
|---|---|---|
| Opaque identifier | `uuid` | Safe external identifier and future multi-device creation; exact PK strategy remains engineering review. |
| Money | `bigint` amount + `char(3)` currency | No floating point. For VND, one stored unit is one đồng under current policy. |
| Quantity | `numeric(18,6)` | Supports ingredients and conversions without binary rounding. Sale item counts additionally require integral positive values. |
| Rate/ratio | `numeric(18,8)` | Supports price, payroll, and conversion rates with explicit rounding. |
| Loyalty points | `bigint` | Signed ledger amounts without floating point. |
| Instant | `timestamptz` | Store UTC instants; render in Branch IANA timezone. |
| Operating Day | `date` or stable policy-derived identifier plus timezone/cutoff version | Daily cash, Expense limits, and reporting require one shared boundary. Exact cutoff/timezone remains `OPEN_DECISION`. |
| Local scheduled time | `time` plus date/timezone context, or resolved `timestamptz` | Never store an ambiguous local timestamp alone. |
| Effective interval | `effective_from timestamptz`, `effective_to timestamptz O` | Half-open interval `[from, to)`; non-overlap where required. |
| Status/type | `varchar(40)` + check constraint | Avoid PostgreSQL enum until state-machine review accepts vocabulary. |
| Extensible configuration | `jsonb` | Only for approved policy values; core business facts remain typed columns. |
| Human code | `varchar(50-100)` | Stable business identifier, unique in documented scope; never the PK. |

Branch timezone is `branches.timezone_name varchar(100)` using an IANA identifier. Provider/device timestamps retain both provider reference time when supplied and server `recorded_at`. Payroll periods use local `date`; financial and operational events use `timestamptz`.

## 3. Organization, identity, and configuration

### `organizations` — enterprise root (`OWNER_CONFIRMED`, `ODB-CAT-14`)

Fields: `code varchar(50) R`; `name varchar(200) R`; `legal_name varchar(250) O`; `status varchar(40) R default 'active'`; `default_currency char(3) R`; `archived_at timestamptz O`; mutable common fields.  
Keys/indexes: UQ `code`; index `status`. History: archive/deactivate, never delete after references exist. Initial deployment has one Organization, but the schema permits multiple Organization rows and has no permanent single-row constraint.

### `brands` — customer-facing brand (`OWNER_CONFIRMED`, `ODB-CAT-14`)

Fields: `organization_id uuid R FK`; `code varchar(50) R`; `name varchar(200) R`; `status varchar(40) R default 'active'`; `archived_at timestamptz O`; mutable common fields.  
Keys/indexes: UQ `(organization_id, code)`; index `organization_id`. Organization is immutable after use. Initial deployment has one Brand, but the schema permits multiple Brand rows; maximum Brands per Organization remains unresolved.

### `branches` — physical cafe (`WORKSHOP_AGREED`)

Fields: `brand_id uuid R FK`; `code varchar(50) R`; `name varchar(200) R`; `timezone_name varchar(100) R`; `address_text text O`; `status varchar(40) R default 'active'`; `opened_on date O`; `closed_on date O`; mutable common fields.  
Keys/indexes: UQ `(brand_id, code)`; index `(brand_id, status)`. Historical operational rows retain this Branch.

### `users` — authentication identity (`WORKSHOP_AGREED`)

Approved logical fields: `organization_id uuid R FK`; unique username login identifier; email as contact/recovery data and never a login identifier; `display_name varchar(200) R`; lifecycle status; `deactivated_at timestamptz O`; `last_authenticated_at timestamptz O`; mutable common fields.  
Keys/indexes: `OWNER_CONFIRMED` username is unique and accounts are invitation-only. `TECHNICAL_PROPOSAL`: UQ `(organization_id, normalized_username)`, preserve entered and normalized username separately, and model lifecycle values as `invited`, `active`, `locked`, `suspended`, `deactivated`. Authentication lock is temporary/automated; suspension/reactivation and deactivation are Owner-controlled; reactivation is explicit/audited; deactivation has no automatic return and preserves history. Exact normalization, email verification, physical lifecycle representation, lock release, and initial state require review; no default may bypass invitation acceptance. Credential secrets do not belong on this record.

### Authentication support records (`TECHNICAL_PROPOSAL`, not approved physical schema)

| Logical record | Proposed fields | Security/constraints |
|---|---|---|
| `authentication_credentials` | `user_id uuid R FK`; `kind varchar(30) R` (`password`, optionally `pin`); `secret_digest text R`; `algorithm varchar(50) R`; safe parameters/version; lifecycle status; `changed_at`; `locked_until`; failure metadata; timestamps | UQ one current credential per User/kind; never store plaintext/reversible password or PIN; PIN and password have separate controls. Final hasher/cost requires security review. |
| `sessions` | `user_id uuid R FK`; `device_id uuid O FK`; public lookup ID; `secret_verifier_digest varchar R`; `authentication_method`; assurance level; `authenticated_at`; `last_seen_at`; `idle_expires_at`; `absolute_expires_at`; `revoked_at`; safe revocation reason and client summaries; timestamps | UQ lookup ID; expiry/revocation indexes; raw session secret exists only in host-only secure cookie; rotate after authentication/security changes. MVP has no numeric cap; visibility, notification, anomaly, privacy, and revocation details require review. |
| `account_invitations` | `user_id uuid R FK`; one-time verifier digest; `invited_by_user_id`; `expires_at`; `accepted_at`; `revoked_at`; timestamps | Invitation-only policy is `OWNER_CONFIRMED`. Owner may invite; only an active delegated Branch Manager may invite Staff within assigned Branches. Delegation is separate from Role Assignment, lasts at most 90 days, cannot be self-renewed/onward-delegated, and revocation invalidates unused invitations. This does not define a Delegation table or fields; physical representation, acceptance proof, and race handling require review. Single use; raw token never persisted or logged. |
| `credential_recovery_challenges` | `user_id uuid R FK`; one-time verifier digest; safe channel/purpose; `requested_by_user_id uuid O FK`; `expires_at`; `used_at`; `revoked_at`; timestamps | Only approved recovery authority may issue; generic public response; use revokes affected sessions; raw secret never persisted/logged. Owner recovery requires two independent proofs and dual control; exact design and provider remain unselected. |

MFA scope is `OWNER_CONFIRMED` for Owner and every Branch Manager; sensitive capabilities also require step-up. Factor records remain deferred until method and recovery pass security review. Region/Regional Manager records remain deferred while the role is inactive. See [Identity & Branch Authorization](after_four_identity_authorization.md).

### `employees` — employment identity (`WORKSHOP_AGREED`)

Fields: `organization_id uuid R FK`; `user_id uuid O FK`; `employee_code varchar(50) R`; `display_name varchar(200) R`; `employment_status varchar(40) R`; `hired_on date R`; `ended_on date O`; `contact_phone varchar(50) O`; `archived_at timestamptz O`; mutable common fields.  
Keys/indexes: UQ `(organization_id, employee_code)`; UQ `user_id` when non-null; indexes `(organization_id, employment_status)`. Personal-data fields/retention: `LEGAL_VALIDATION`.

### `branch_assignments` — effective Employee/Branch relationship (`WORKSHOP_AGREED`)

Fields: `employee_id uuid R FK`; `branch_id uuid R FK`; `assignment_type varchar(40) R` (`primary`, `temporary`); `effective_from timestamptz R`; `effective_to timestamptz O`; `assigned_by_user_id uuid R FK`; `reason text O`; immutable after supersession.  
Keys/indexes: index `(employee_id, effective_from)` and `(branch_id, effective_from)`; exclusion/transaction rule prevents overlapping primary assignments. End by setting `effective_to` through an audited command. `OWNER_CONFIRMED` Every create/change/end requires Owner approval.

### `roles` — small authorization templates (`WORKSHOP_AGREED`, mechanism `TECHNICAL_PROPOSAL`)

Fields: `organization_id uuid R FK`; `key varchar(50) R`; `name varchar(100) R`; `capabilities jsonb R default '[]'`; `status varchar(40) R default 'active'`; mutable common fields.  
Keys/indexes: UQ `(organization_id, key)`. `OWNER_CONFIRMED` Active keys are Owner/Branch Manager/Staff; Regional Manager remains reserved and inactive.

### `role_assignments` — effective User authorization scope (`WORKSHOP_AGREED`)

Fields: `user_id uuid R FK`; `role_id uuid R FK`; `branch_id uuid O FK`; `effective_from timestamptz R`; `effective_to timestamptz O`; `granted_by_user_id uuid R FK`; `reason text O`; immutable interval history.  
Keys/indexes: index `(user_id, effective_from)`; index `(branch_id, effective_from)`. Application validates Organization consistency and whether null Branch is allowed for that role. `OWNER_CONFIRMED` Every create/change/end requires Owner approval.

### `configurations` — stable configuration key and scope (`TECHNICAL_PROPOSAL`)

Fields: `organization_id uuid O FK`; `brand_id uuid O FK`; `branch_id uuid O FK`; `key varchar(100) R`; `value_kind varchar(40) R`; `description text O`; `status varchar(40) R default 'active'`; mutable common fields.  
Keys/indexes: check exactly one scope FK; UQ per `(scope, key)` using partial unique indexes. Core prices, recipes, pay terms, and transactions must not be stored here.

### `configuration_versions` — effective configuration value (`WORKSHOP_AGREED` history; structure `TECHNICAL_PROPOSAL`)

Fields: `configuration_id uuid R FK`; `version integer R`; `value jsonb R`; `effective_from timestamptz R`; `effective_to timestamptz O`; `created_by_user_id uuid R FK`; `reason text O`; immutable.  
Keys/indexes: UQ `(configuration_id, version)`; index `(configuration_id, effective_from)`; non-overlapping effective intervals.

## 4. Workforce and payroll

### `employee_availabilities` — weekly availability (`WORKSHOP_AGREED`)

Fields: `employee_id uuid R FK`; `week_start_date date R`; `available_from timestamptz R`; `available_to timestamptz R`; `preference varchar(40) O`; `note text O`; `submitted_at timestamptz R`; mutable until planning cutoff.  
Keys/indexes: index `(employee_id, week_start_date)`; check `available_to > available_from`.

### `shifts` — planned work assignment (`WORKSHOP_AGREED`)

Fields: `branch_id uuid R FK`; `employee_id uuid R FK`; `starts_at timestamptz R`; `ends_at timestamptz R`; `status varchar(40) R default 'draft'`; `published_at timestamptz O`; `published_by_user_id uuid O FK`; `note text O`; mutable common fields.  
Keys/indexes: indexes `(branch_id, starts_at)`, `(employee_id, starts_at)`; check end after start; overlap policy is `OPEN_DECISION`.

### `shift_duties` — operational role within a Shift (`WORKSHOP_AGREED`)

Fields: `shift_id uuid R FK`; `duty_key varchar(40) R` (`cashier`, `barista`, `server`, `cleaning`); `starts_at timestamptz O`; `ends_at timestamptz O`; `note text O`.  
Keys/indexes: UQ `(shift_id, duty_key, starts_at)` with normalized null handling; index `shift_id`. Duties do not grant authorization.

### `shift_swap_requests` — published-shift change (`WORKSHOP_AGREED`)

Fields: `shift_id uuid R FK`; `requested_by_employee_id uuid R FK`; `replacement_employee_id uuid O FK`; `status varchar(40) R`; `reason text O`; `requested_at timestamptz R`; `decided_by_user_id uuid O FK`; `decided_at timestamptz O`; `decision_reason text O`; mutable until decision.  
Keys/indexes: index `(shift_id, status)` and `(replacement_employee_id, status)`. Exact approval rules: `OPEN_DECISION`.

### `attendance_records` — actual worked time/Branch (`WORKSHOP_AGREED`)

Fields: `employee_id uuid R FK`; `branch_id uuid R FK`; `shift_id uuid O FK`; `clocked_in_at timestamptz R`; `clocked_out_at timestamptz O`; `status varchar(40) R`; `original_values jsonb O`; `corrected_by_user_id uuid O FK`; `correction_reason text O`; `corrected_at timestamptz O`; mutable with audit.  
Keys/indexes: indexes `(employee_id, clocked_in_at)`, `(branch_id, clocked_in_at)`; check clock-out after clock-in. Corrections retain original values and Audit Log.

### `leave_requests` — employee leave (`OWNER_CONFIRMED` approval split; details open)

Fields: `employee_id uuid R FK`; `branch_id uuid R FK`; `leave_type varchar(40) R`; `starts_on date R`; `ends_on date R`; `status varchar(40) R`; `is_exception boolean R default false`; `reason text O`; `decided_by_user_id uuid O FK`; `decided_at timestamptz O`; `decision_reason text O`; mutable until final.  
Keys/indexes: index `(employee_id, starts_on)` and `(branch_id, status)`; check end not before start. Leave types/balances: `OPEN_DECISION`, `LEGAL_VALIDATION`.

### `overtime_requests` — Branch Manager proposal/Owner decision (`OWNER_CONFIRMED`)

Fields: `employee_id uuid R FK`; `branch_id uuid R FK`; `attendance_record_id uuid O FK`; `proposed_minutes integer R`; `proposed_by_user_id uuid R FK`; `status varchar(40) R`; `reason text R`; `decided_by_user_id uuid O FK`; `decided_at timestamptz O`; `decision_reason text O`; immutable after decision except explicit supersession.  
Keys/indexes: index `(employee_id, status)` and `(branch_id, status)`; check positive minutes.

### `compensation_agreements` — effective pay terms (`OWNER_CONFIRMED` methods; `WORKSHOP_AGREED` history)

Fields: `employee_id uuid R FK`; `method varchar(40) R` (`monthly`, `hourly`, `per_shift`); `rate_amount bigint R`; `currency_code char(3) R`; `effective_from date R`; `effective_to date O`; `created_by_user_id uuid R FK`; `reason text O`; immutable.  
Keys/indexes: index `(employee_id, effective_from)`; no overlapping effective intervals; non-negative amount. Statutory composition: `LEGAL_VALIDATION`.

### `payroll_periods` — monthly calculation/close (`OWNER_CONFIRMED`)

Fields: `organization_id uuid R FK`; `period_start date R`; `period_end date R`; `payment_due_date date R`; `status varchar(40) R default 'draft'`; `manager_reviewed_by_user_id uuid O FK`; `manager_reviewed_at timestamptz O`; `owner_closed_by_user_id uuid O FK`; `closed_at timestamptz O`; `lock_version integer R default 0`; `created_at`, `updated_at`.  
Keys/indexes: UQ `(organization_id, period_start, period_end)`; index `(organization_id, status)`; check first/last day and payment date after period. Closed fields immutable.

### `payrolls` — one Employee calculation in a Period (`OWNER_CONFIRMED`)

Fields: `payroll_period_id uuid R FK`; `employee_id uuid R FK`; `currency_code char(3) R`; `base_amount bigint R`; `overtime_amount bigint R default 0`; `allowance_amount bigint R default 0`; `deduction_amount bigint R default 0`; `adjustment_amount bigint R default 0`; `net_amount bigint R`; `calculation_snapshot jsonb R`; `status varchar(40) R`; `lock_version integer R default 0`; timestamps.  
Keys/indexes: UQ `(payroll_period_id, employee_id)`; index `(employee_id, payroll_period_id)`; arithmetic/check rules plus application calculation. Frozen when Period closes.

### `payslips` — detailed downloadable artifact (`OWNER_CONFIRMED`)

Fields: `payroll_id uuid R FK`; `version integer R default 1`; `storage_key text R`; `content_hash varchar(128) R`; `generated_at timestamptz R`; `generated_by_user_id uuid O FK`; immutable.  
Keys/indexes: UQ `(payroll_id, version)`; UQ `content_hash` optional by storage policy. PDF retention/security: `LEGAL_VALIDATION`.

### `payroll_adjustments` — post-close correction (`WORKSHOP_AGREED`)

Fields: `payroll_id uuid R FK`; `adjustment_type varchar(40) R`; `amount bigint R`; `currency_code char(3) R`; `reason text R`; `created_by_user_id uuid R FK`; `approved_by_user_id uuid O FK`; `effective_payment_date date O`; `reverses_adjustment_id uuid O FK`; immutable.  
Keys/indexes: index `(payroll_id, created_at)`; check nonzero amount and currency consistency. Approval/reopening policy: `OPEN_DECISION`.

### `payroll_payments` — payment history independent of close (`WORKSHOP_AGREED`)

Fields: `payroll_id uuid R FK`; `amount bigint R`; `currency_code char(3) R`; `method varchar(40) R`; `status varchar(40) R`; `reference varchar(200) O`; `idempotency_key varchar(200) R`; `paid_at timestamptz O`; `recorded_by_user_id uuid R FK`; immutable outcome rows.  
Keys/indexes: UQ `(payroll_id, idempotency_key)`; index `(payroll_id, status)`; check positive amount. Legal/accounting fields: `LEGAL_VALIDATION`.

## 5. Catalog and recipes

### `categories`, `products`, `product_variants`

| Table / purpose | Specific fields | Constraints, indexes, history |
|---|---|---|
| `categories` — flat Brand grouping (`ODB-CAT-02`, `ODB-CAT-16`, `ODB-CAT-18`, `ODB-CAT-21`, `ODB-CAT-22`, `ODB-CAT-25`, `ODB-CAT-27`, `ODB-CAT-29`, `ODB-CAT-30`, `ODB-CAT-32`) | `brand_id uuid R FK`; proposed raw/canonical `code` representation; `name varchar(150) R`; `position integer R default 0`; proposed `status` supporting Draft/Active/Inactive/Archived; mutable common | Created Draft. Follows the exact `ODB-CAT-32` matrix; Restore targets Inactive. Separate Code namespace includes Archived rows. Deactivation/Archive retain their distinct Active-Product guards; no Archive rule for only Inactive Products is inferred. Fields, commands, locking, authorization/audit enforcement, and concurrency remain technical. |
| `products` — Brand-global stable identity (`ODB-CAT-01`, `ODB-CAT-03`, `ODB-CAT-15`, `ODB-CAT-16`, `ODB-CAT-18`, `ODB-CAT-22`–`ODB-CAT-24`, `ODB-CAT-27`–`ODB-CAT-29`, `ODB-CAT-33`, `ODB-CAT-38`, `ODB-CAT-39`, `ODB-CAT-41`) | `category_id uuid R FK`; proposed raw/canonical `code` representation; `name varchar(200) R`; `description text O`; `status varchar(40) R`; mutable common | Every Product belongs to its original Category and has at most one designated Default in every lifecycle state. Active requires Active Category and exactly one Active Default independent of visibility. Initial MVP exposes no Product lifecycle or Category-reassignment command/API. Composite FK, proposed assignment immutability, cross-row enforcement, locks, and any future lifecycle commands remain unimplemented technical work. |
| `product_variants` — persisted sellable selection (`ODB-CAT-04`, `ODB-CAT-16`–`ODB-CAT-23`, `ODB-CAT-25`, `ODB-CAT-27`, `ODB-CAT-28`, `ODB-CAT-31`, `ODB-CAT-32`, `ODB-CAT-34`, `ODB-CAT-38`, `ODB-CAT-40`) | `product_id uuid R FK`; proposed raw/canonical `code`; no accepted SKU input in MVP; `name varchar(150) R`; proposed independent default, visibility, and Draft/Active/Inactive/Archived lifecycle fields; mutable common | Created Draft and follows `ODB-CAT-32`; Restore targets Inactive. Archive/Restore changes lifecycle status only and preserves `is_default` and `customer_visible`; reactivation is separate and Default is never silently transferred. A Product permits zero or one Default except Active requires exactly one Active Default. Exact fields/indexes, commands, locking, authorization/audit, and concurrency remain proposed. |

`OWNER_CONFIRMED` Catalog Core MVP retains Category/Product/Variant through lifecycle/Archive, introduces no Soft Delete or `deleted_at`, reserves Code/SKU after Archive or any future Soft Delete, and prohibits Purge for Draft, Active, Inactive, and Archived records (`ODB-CAT-35`–`ODB-CAT-37`, `ODB-DATA-01`). No deletion command/job is approved. Future Soft Delete mechanics and reuse after hypothetical physical Draft deletion require separate decisions.

### `branch_product_availabilities` — effective Branch override (`OWNER_CONFIRMED`, `ODB-CAT-06`)

Fields: `branch_id uuid R FK`; `product_variant_id uuid R FK`; `is_available boolean R`; `effective_from timestamptz R`; `effective_to timestamptz O`; `reason text O`; `changed_by_user_id uuid R FK`; immutable versions.  
Keys/indexes: index `(branch_id, product_variant_id, effective_from)`; non-overlap per Branch/Variant. An effective row is an explicit available/unavailable override; no effective row means inherit the chain default. Time-based menu policy and publishing authority remain unresolved.

### `product_prices` — immutable chain default/Branch override versions (`OWNER_CONFIRMED`, `ODB-CAT-07`, `ODB-CAT-08`)

Fields: `product_variant_id uuid R FK`; `branch_id uuid O FK`; `amount bigint R`; `currency_code char(3) R`; `effective_from timestamptz R`; `effective_to timestamptz O`; `created_by_user_id uuid R FK`; `approval_request_id uuid O FK`; immutable.  
Keys/indexes: index `(product_variant_id, branch_id, effective_from)`; non-overlap per nullable Branch scope; check amount non-negative. Null Branch means chain default; an effective Branch row explicitly overrides it. Price versions are immutable. Zero/free pricing, Price composition, publication authority, and manual sold-price overrides remain unresolved, so `amount >= 0` is a structural proposal rather than an approved free-item policy.

### `modifier_groups`, `modifiers`, `product_modifier_groups`

| Table / purpose | Specific fields | Constraints, indexes, history |
|---|---|---|
| `modifier_groups` — choice group (`ODB-CAT-05`) | `brand_id uuid R FK`; `code varchar(50) R`; `name varchar(150) R`; `minimum_selections integer R default 0`; `maximum_selections integer R`; `archived_at timestamptz O`; mutable common | UQ `(brand_id, code)`; checks `0 <= min <= max`; minimum zero means optional, positive means required; maximum one means single choice, greater than one means multiple choice. |
| `modifiers` — selectable option | `modifier_group_id uuid R FK`; `code varchar(50) R`; `name varchar(150) R`; `price_delta_amount bigint O`; `currency_code char(3) O`; `archived_at timestamptz O`; mutable common | UQ `(modifier_group_id, code)`; Modifier pricing fields are conditional proposals because whether/how selections affect Price remains unresolved. |
| `product_modifier_groups` — Variant allowance | `product_variant_id uuid R FK`; `modifier_group_id uuid R FK`; `position integer R default 0`; `minimum_override integer O`; `maximum_override integer O`; timestamps | UQ pair; index Variant/position; validate override bounds. |

### `units`, `ingredients`, `recipes`, `recipe_versions`, `recipe_items`

| Table / purpose | Specific fields | Constraints, indexes, history |
|---|---|---|
| `units` | `organization_id uuid R FK`; `code varchar(30) R`; `name varchar(100) R`; `dimension varchar(40) R`; `factor_to_base numeric(18,8) R`; `precision_scale integer R`; `archived_at timestamptz O` | UQ `(organization_id, code)`; positive factor; conversions only within dimension. |
| `ingredients` | `brand_id uuid R FK`; `code varchar(50) R`; `name varchar(150) R`; `base_unit_id uuid R FK`; `archived_at timestamptz O`; mutable common | UQ `(brand_id, code)`; index base unit; archive preserves movement history. |
| `recipes` | `product_variant_id uuid R FK`; `code varchar(50) R`; `status varchar(40) R`; mutable common | UQ `product_variant_id` for one version family per Variant; archive/status only. |
| `recipe_versions` | `recipe_id uuid R FK`; `version integer R`; `yield_quantity numeric(18,6) R`; `effective_from timestamptz R`; `effective_to timestamptz O`; `status varchar(40) R`; `approved_by_user_id uuid O FK`; immutable after effective | UQ `(recipe_id, version)`; non-overlap effective interval; positive yield. |
| `recipe_items` | `recipe_version_id uuid R FK`; `ingredient_id uuid R FK`; `quantity numeric(18,6) R`; `unit_id uuid R FK`; `waste_factor numeric(18,8) O`; timestamps | UQ `(recipe_version_id, ingredient_id)` unless repeats need line number; positive quantity; unit dimension matches Ingredient. |

## 6. Customers, loyalty, and promotions

### `customers` — Organization-shared profile (scope `OWNER_CONFIRMED`; physical design `TECHNICAL_PROPOSAL`; privacy `LEGAL_VALIDATION`)

Fields: `organization_id uuid R FK`; `display_name varchar(200) O`; `phone_normalized varchar(50) O`; `phone_lookup_hash varchar(128) O`; `status varchar(40) R default 'active'`; `merged_into_customer_id uuid O FK`; `archived_at timestamptz O`; mutable common.  
Keys/indexes: partial UQ `(organization_id, phone_lookup_hash)` after uniqueness design approval; index status. Anonymous-Order permission remains `UNDECIDED`; if later approved, its physical representation requires separate design.

### `customer_consents`

Fields: `customer_id uuid R FK`; `consent_type varchar(50) R`; `status varchar(40) R`; `policy_version varchar(50) R`; `captured_at timestamptz R`; `withdrawn_at timestamptz O`; `capture_source varchar(50) R`; `evidence_reference text O`; immutable events.  
Keys/indexes: index `(customer_id, consent_type, captured_at)`; current consent derived from latest valid event. `LEGAL_VALIDATION`.

### `loyalty_accounts`, `loyalty_transactions`

| Table / purpose | Specific fields | Constraints, indexes, history |
|---|---|---|
| `loyalty_accounts` | `customer_id uuid R FK`; `status varchar(40) R`; `cached_balance bigint R default 0`; `lock_version integer R default 0`; timestamps | UQ `customer_id`; balance equals ledger sum; nonnegative available balance unless policy says otherwise. |
| `loyalty_transactions` | `loyalty_account_id uuid R FK`; `branch_id uuid O FK`; `type varchar(40) R`; `points_delta bigint R`; `payment_id uuid O FK`; `refund_id uuid O FK`; `promotion_usage_id uuid O FK`; `reverses_transaction_id uuid O FK`; `idempotency_key varchar(200) R`; `occurred_at timestamptz R`; `created_by_user_id uuid O FK`; immutable | UQ `(loyalty_account_id, idempotency_key)`; index account/time and source; nonzero delta; reversal source unique where required. |

### `promotions`, `promotion_rules`, `promotion_usages`

| Table / purpose | Specific fields | Constraints, indexes, history |
|---|---|---|
| `promotions` | `brand_id uuid R FK`; `code varchar(50) R`; `name varchar(200) R`; `status varchar(40) R`; `effective_from timestamptz R`; `effective_to timestamptz O`; `stacking_group varchar(50) O`; `approved_by_user_id uuid O FK`; mutable before publication | UQ `(brand_id, code)`; index effective/status. Exact types/stacking `OPEN_DECISION`. |
| `promotion_rules` | `promotion_id uuid R FK`; `rule_type varchar(50) R`; `parameters jsonb R`; `position integer R default 0`; immutable after publication | UQ `(promotion_id, position)`; application validates typed schema per rule type. |
| `promotion_usages` | `promotion_id uuid R FK`; `order_id uuid R FK`; `customer_id uuid O FK`; `branch_id uuid R FK`; `rule_snapshot jsonb R`; `discount_amount bigint R`; `currency_code char(3) R`; `used_at timestamptz R`; immutable | UQ `(promotion_id, order_id)` unless multiple applications approved; indexes customer/time and Branch/time; nonnegative discount. |

## 7. Sales, payment, preparation, and delivery

### `orders` — commercial aggregate (`WORKSHOP_AGREED`)

Fields: `branch_id uuid R FK`; `order_number varchar(50) R`; `channel varchar(40) R`; `customer_id uuid O FK`; `table_session_id uuid O FK`; `created_by_user_id uuid R FK`; `status varchar(40) R default 'draft'`; `currency_code char(3) R`; `subtotal_amount bigint R default 0`; `discount_amount bigint R default 0`; `tax_amount bigint R default 0`; `service_charge_amount bigint R default 0`; `total_amount bigint R default 0`; `creation_idempotency_key varchar(200) R`; `creation_request_fingerprint varchar(64) R`; `confirmed_at timestamptz O`; `payment_expires_at timestamptz O`; `expired_at timestamptz O`; `held_at timestamptz O`; `hold_reason text O`; `closed_at timestamptz O`; `cancelled_at timestamptz O`; `cancellation_reason text O`; mutable common.  
Keys/indexes: UQ `(branch_id, order_number)`; UQ `(branch_id, creation_idempotency_key)`; indexes `(branch_id, status, created_at)`, customer/time, table session. Creation fingerprint is lowercase SHA-256 over normalized actor/channel/total/currency and supports replay/conflict decisions without retaining the raw request. Checks nonnegative components and approved total formula. Number namespace/formula: `OPEN_DECISION`.

### `order_items`, `order_item_modifiers` — immutable sale snapshots after confirmation

| Table | Specific fields | Constraints, indexes, history |
|---|---|---|
| `order_items` | `order_id uuid R FK`; `product_id uuid O FK`; `product_variant_id uuid O FK`; `product_code_snapshot varchar(100) R`; `product_name_snapshot varchar(200) R`; `variant_name_snapshot varchar(150) O`; `quantity integer R`; `unit_price_amount bigint R`; `discount_amount bigint R default 0`; `tax_amount bigint R default 0`; `line_total_amount bigint R`; `currency_code char(3) R`; `note text O`; `status varchar(40) R`; `cancelled_quantity integer R default 0`; timestamps | Index Order; positive quantity; cancellation within quantity; snapshot/currency totals immutable after confirmation. |
| `order_item_modifiers` | `order_item_id uuid R FK`; `modifier_group_id uuid O FK`; `modifier_id uuid O FK`; `group_name_snapshot varchar(150) R`; `modifier_name_snapshot varchar(150) R`; `quantity integer R`; `unit_price_delta_amount bigint R`; `currency_code char(3) R`; timestamps | Index Order Item; positive quantity; immutable snapshot. |

### `payments` — Order settlement aggregate (`WORKSHOP_AGREED`)

Fields: `order_id uuid R FK`; `currency_code char(3) R`; `target_amount bigint R`; `successful_amount bigint R default 0`; `refunded_amount bigint R default 0`; `funding_status varchar(40) R default 'unpaid'`; `attempt_activity varchar(40) R default 'idle'`; `fully_settled_at timestamptz O`; mutable common.  
Keys/indexes: UQ `order_id`; Phase 1 also has UQ `(id, order_id)` as the referenced key for aggregate-consistency FKs; queue index `(attempt_activity, updated_at)`; amounts nonnegative; refunded ≤ successful; currency equals Order. Checks allow funding values `unpaid`, `partially_paid`, `fully_paid`, `partially_refunded`, `fully_refunded`; activity values `idle`, `processing`, `reconciliation_required`; `fully_paid` and refunded funding states require `idle`, while `unpaid`/`partially_paid` may use any activity value. Deferred PostgreSQL constraint triggers require `successful_amount` to equal the sum of succeeded Phase 1 Attempt confirmed amounts at commit and require exact `target_amount` equality for `fully_paid`; they lock the Payment row to serialize concurrent checks. Arithmetic mapping and transitions follow the [Payment Model](after_four_payment_model.md). MVP commands accept exact balance only; `partially_paid` is reserved/unreachable and future allocation remains `OPEN_DECISION`.

### `payment_attempts` — attempts with immutable terminal outcome (Phase 1 implemented)

Fields: `payment_id uuid R FK`; `method varchar(40) R`; `status varchar(40) R`; `requested_amount bigint R`; `confirmed_amount bigint O`; `currency_code char(3) R`; `idempotency_key varchar(200) R`; `confirmed_by_actor_id uuid O`; `confirmed_at timestamptz O`; `failure_code varchar(100) O`; timestamps. Pending/unknown may move only through verified reconciliation. After a stored Payment Attempt is terminal (`succeeded`, `failed`, `cancelled`), its payment identity, status, amounts, method, currency, idempotency identity, confirming actor/time, and failure evidence are immutable through both the Rails model and PostgreSQL trigger; deliberate superuser/owner bypass remains outside that guarantee.  
Keys/indexes: UQ `(payment_id, idempotency_key)`; UQ `(id, payment_id)` as the referenced key for review-case consistency; indexes `(payment_id, status)` and Payment FK. Requested amount is positive; confirmed amount is null or positive. In Phase 1, `status='succeeded'` requires non-null confirming actor/time/amount, `confirmed_amount=requested_amount`, and null `failure_code` at the database layer.

Historical terminology/enrichment: older logical proposals named this record `payment_transactions` and proposed additional `kind`, request fingerprint, provider/reference, cash tender/change, initiating User, and provider timing fields. No `PaymentTransaction` model or `payment_transactions` physical table exists. Those additions remain deferred provider/cash-design proposals; they do not define a second implemented entity and must not be read as Phase 1 columns.

Owner-confirmed manual bank-transfer boundary: the Owner bank QR identifies the transfer destination; a speaker amount announcement is an alert only and not Payment proof. Cashier comparison/confirmation is manual and no automatic bank API matching is approved for MVP. A mismatch/excess does not become a succeeded exact-balance Attempt by default.

### `payment_provider_events` — provider replay evidence (`TECHNICAL_PROPOSAL`)

Fields: `payment_attempt_id uuid O FK`; `provider varchar(80) R`; `provider_event_id varchar(200) R`; `event_type varchar(100) R`; `signature_verified boolean R`; `payload_digest varchar(128) R`; `provider_occurred_at timestamptz O`; `received_at timestamptz R`; `applied_at timestamptz O`; `application_status varchar(40) R`; `safe_metadata jsonb O`; immutable.  
Keys/indexes: UQ `(provider, provider_event_id)`; index `(application_status, received_at)`. Do not retain unsafe raw secrets/card data.

### `payment_review_cases` — late/exception settlement review (`OWNER_CONFIRMED`)

Fields: `order_id uuid R FK`; `payment_id uuid R FK`; `payment_attempt_id uuid R FK`; `kind varchar(40) R`; `status varchar(40) R default 'open'`; `recorded_by_actor_id uuid R`; `opened_at timestamptz R`; timestamps. Proposed resolution fields remain deferred.  
Keys/indexes: UQ `payment_attempt_id` for the late-success case; indexes status/opened time and Order. Phase 1 composite FKs require `(payment_id, order_id)` to identify the Payment for that Order and `(payment_attempt_id, payment_id)` to identify an Attempt of that Payment. A case records financial truth that arrived after the dispatch window or while the Order was held. It never creates Dispatch or automatically changes the Order back to Confirmed. Resolution authority and outcomes remain outside Implementation Phase 1.

### `refunds` — linked financial adjustment (`WORKSHOP_AGREED`)

Fields: `payment_attempt_id uuid R FK`; `order_id uuid R FK`; `amount bigint R`; `currency_code char(3) R`; `status varchar(40) R`; `reason text R`; `requested_by_user_id uuid R FK`; `approved_by_user_id uuid O FK`; `idempotency_key varchar(200) R`; `provider_reference varchar(200) O`; `completed_at timestamptz O`. Pending may move only through verified result handling; terminal outcome is immutable.  
Keys/indexes: UQ `(payment_attempt_id, idempotency_key)`; indexes Order/time and status; positive amount; locked cumulative refund rule. Refund remains unimplemented; authority/partial allocation is `OPEN_DECISION`.

`OWNER_CONFIRMED` Excess received above the target requires evidence and Refund and is not revenue. This dictionary does not select whether that evidence extends Payment Attempt/Refund or uses a separate exception record. Required information includes received/excess amount, method, reason, actor/approver, time, and linked Payment/Order. Physical keys, allocation, original-tender/provider behavior, and lifecycle remain deferred; implemented Phase 1 columns and exact-balance constraints are unchanged.

### `preparation_dispatches` — paid-order durable handoff (`OWNER_CONFIRMED`)

Fields: `order_id uuid R FK`; `payment_id uuid R FK`; `branch_id uuid R FK`; `status varchar(40) R default 'pending'`; `idempotency_key varchar(200) R`; `requested_at timestamptz R`; `dispatched_at timestamptz O`; mutable business state.  
Keys/indexes: UQ `order_id`; UQ `(branch_id, idempotency_key)`; index `(status, requested_at)`. Phase 1 composite FKs require `(payment_id, order_id)` to identify the Payment belonging to that Order and `(order_id, branch_id)` to identify the Branch already recorded by that Order. This enforces relational consistency without defining Branch ownership or authorization. Application proves Payment fully settled and deadline eligibility before insert; same transaction as settlement intent.

### `preparation_dispatch_attempts` — technical delivery/retry history (`TECHNICAL_PROPOSAL`)

Fields: `preparation_dispatch_id uuid R FK`; `attempt_number integer R`; `status varchar(40) R`; `started_at timestamptz R`; `completed_at timestamptz O`; `error_code varchar(100) O`; `safe_error_detail text O`; immutable.  
Keys/indexes: UQ `(preparation_dispatch_id, attempt_number)`; index `(status, started_at)`. Attempt failure never changes Payment or creates a new Dispatch.

Implementation note: Phase 1 contains the physical table and `PreparationDispatchAttempt` model, but contains no writer for this record. The reserved physical subset adds `idempotency_key` and `actor_id` plus uniqueness support and does not yet implement the proposed `safe_error_detail` field above. `Preparation::RetryDispatch` only resets the existing Outbox Event and appends an Audit Event. Numbered delivery-attempt creation is deferred with the outbox consumer/Preparation Ticket implementation; the schema's presence is not evidence that retry attempts are currently recorded.

### `preparation_stations`, `preparation_tickets`, `preparation_items`

| Table | Specific fields | Constraints, indexes, history |
|---|---|---|
| `preparation_stations` | `branch_id uuid R FK`; `code varchar(50) R`; `name varchar(150) R`; `status varchar(40) R`; `archived_at timestamptz O`; mutable common | UQ `(branch_id, code)`; active index. |
| `preparation_tickets` | `preparation_dispatch_id uuid R FK`; `preparation_station_id uuid R FK`; `branch_id uuid R FK`; `ticket_number varchar(50) R`; `sequence integer R`; `status varchar(40) R`; `queued_at timestamptz R`; `started_at timestamptz O`; `ready_at timestamptz O`; `completed_at timestamptz O`; mutable common | UQ `(preparation_dispatch_id, preparation_station_id, sequence)`; UQ `(branch_id, ticket_number)`; queue index. Same Branch enforced. |
| `preparation_items` | `preparation_ticket_id uuid R FK`; `order_item_id uuid R FK`; `recipe_version_id uuid O FK`; `name_snapshot varchar(200) R`; `requested_quantity integer R`; `started_quantity integer R default 0`; `ready_quantity integer R default 0`; `completed_quantity integer R default 0`; `cancelled_quantity integer R default 0`; `status varchar(40) R`; timestamps | UQ allocation key `(preparation_ticket_id, order_item_id)` unless split stations approved; quantity bounds; index Order Item. |

### `preparation_deviations` — remake/waste/cancellation record (`WORKSHOP_AGREED`)

Fields: `preparation_item_id uuid R FK`; `type varchar(40) R`; `quantity integer R`; `reason text R`; `recorded_by_user_id uuid R FK`; `related_stock_movement_id uuid O FK`; `occurred_at timestamptz R`; `reverses_deviation_id uuid O FK`; immutable.  
Keys/indexes: index `(preparation_item_id, occurred_at)`; positive quantity; application enforces allowed effect and authorization.

### `deliveries`, `delivery_items`, `delivery_events` — internal fulfillment (`WORKSHOP_AGREED`)

| Table | Specific fields | Constraints, indexes, history |
|---|---|---|
| `deliveries` | `branch_id uuid R FK`; `order_id uuid R FK`; `table_session_id uuid O FK`; `delivery_number varchar(50) R`; `destination_snapshot text R`; `status varchar(40) R`; `assigned_employee_id uuid O FK`; `created_at`; `claimed_at timestamptz O`; `in_transit_at timestamptz O`; `delivered_at timestamptz O`; `failed_at timestamptz O`; `failure_reason text O`; `lock_version integer R default 0`; `updated_at` | UQ `(branch_id, delivery_number)`; queue indexes `(branch_id, status, created_at)`. |
| `delivery_items` | `delivery_id uuid R FK`; `preparation_item_id uuid R FK`; `quantity integer R`; timestamps | UQ pair; positive quantity; cumulative delivered allocation ≤ ready quantity. |
| `delivery_events` | `delivery_id uuid R FK`; `event_type varchar(40) R`; `from_status varchar(40) O`; `to_status varchar(40) O`; `actor_user_id uuid R FK`; `reason text O`; `occurred_at timestamptz R`; `idempotency_key varchar(200) R`; immutable | UQ `(delivery_id, idempotency_key)`; index delivery/time. |

## 8. Inventory and procurement

### `warehouses`, `inventory_positions`, `inventory_lots`

| Table | Specific fields | Constraints, indexes, history |
|---|---|---|
| `warehouses` | `organization_id uuid R FK`; `branch_id uuid O FK`; `code varchar(50) R`; `name varchar(150) R`; `kind varchar(40) R` (`central`, `branch`); `status varchar(40) R`; mutable common | UQ `(organization_id, code)`; check central has null Branch and branch kind has Branch. |
| `inventory_positions` | `warehouse_id uuid R FK`; `ingredient_id uuid R FK`; `on_hand_quantity numeric(18,6) R default 0`; `available_quantity numeric(18,6) R default 0`; `weighted_average_cost_amount numeric(24,8) R default 0`; `currency_code char(3) R`; `lock_version integer R default 0`; timestamps | UQ `(warehouse_id, ingredient_id)`; nonnegative available; cache must reconcile to movements/lots. |
| `inventory_lots` | `inventory_position_id uuid R FK`; `goods_receipt_item_id uuid O FK`; `lot_code varchar(100) R`; `received_at timestamptz R`; `expiry_date date O`; `disposition varchar(40) R`; `on_hand_quantity numeric(18,6) R`; `available_quantity numeric(18,6) R`; `unit_cost_amount numeric(24,8) R`; `currency_code char(3) R`; `lock_version integer R default 0`; timestamps | UQ `(inventory_position_id, lot_code)`; FEFO index `(inventory_position_id, disposition, expiry_date)`; quantities nonnegative. |

### `stock_movements` — immutable stock/cost ledger (`WORKSHOP_AGREED`)

Fields: `inventory_position_id uuid R FK`; `inventory_lot_id uuid O FK`; `movement_type varchar(40) R`; `quantity_delta numeric(18,6) R`; `unit_cost_amount numeric(24,8) R`; `total_cost_amount numeric(24,8) R`; `currency_code char(3) R`; `source_type varchar(50) R`; `source_id uuid R`; `idempotency_key varchar(200) R`; `occurred_at timestamptz R`; `recorded_at timestamptz R`; `actor_user_id uuid R FK`; `reason text O`; `reverses_movement_id uuid O FK`; `resulting_on_hand_quantity numeric(18,6) R`; `resulting_average_cost_amount numeric(24,8) R`; immutable.  
Keys/indexes: UQ `(inventory_position_id, idempotency_key)`; indexes position/time, lot/time, `(source_type, source_id)`; nonzero delta; reversal uniqueness as policy requires.

### `stock_transfers`, items, receipts

| Table | Specific fields | Constraints, indexes, history |
|---|---|---|
| `stock_transfers` | `organization_id uuid R FK`; `transfer_number varchar(50) R`; `source_warehouse_id uuid R FK`; `destination_warehouse_id uuid R FK`; `status varchar(40) R`; `requested_by_user_id uuid R FK`; `approved_by_user_id uuid O FK`; `dispatched_by_user_id uuid O FK`; `dispatched_at timestamptz O`; `completed_at timestamptz O`; `lock_version integer R default 0`; timestamps | UQ `(organization_id, transfer_number)`; source ≠ destination; indexes both endpoints/status. |
| `stock_transfer_items` | `stock_transfer_id uuid R FK`; `ingredient_id uuid R FK`; `requested_quantity numeric(18,6) R`; `dispatched_quantity numeric(18,6) R default 0`; `received_quantity numeric(18,6) R default 0`; `rejected_quantity numeric(18,6) R default 0`; `unit_id uuid R FK`; `dispatch_unit_cost_amount numeric(24,8) O`; `currency_code char(3) O`; timestamps | UQ `(stock_transfer_id, ingredient_id)` unless lots require multiple lines; quantity bounds. |
| `stock_transfer_receipts` | `stock_transfer_id uuid R FK`; `receipt_number integer R`; `received_by_user_id uuid R FK`; `received_at timestamptz R`; `status varchar(40) R`; `note text O`; `idempotency_key varchar(200) R`; immutable | UQ `(stock_transfer_id, receipt_number)` and idempotency key; index received time. |
| `stock_transfer_receipt_items` | `stock_transfer_receipt_id uuid R FK`; `stock_transfer_item_id uuid R FK`; `accepted_quantity numeric(18,6) R default 0`; `quarantined_quantity numeric(18,6) R default 0`; `rejected_quantity numeric(18,6) R default 0`; `destination_lot_id uuid O FK`; `discrepancy_reason text O`; immutable | UQ pair; nonnegative quantities; totals cannot exceed remaining dispatched quantity. |

### `stocktakes`, `stocktake_items`

| Table | Specific fields | Constraints, indexes, history |
|---|---|---|
| `stocktakes` | `warehouse_id uuid R FK`; `stocktake_number varchar(50) R`; `status varchar(40) R`; `started_at timestamptz R`; `completed_at timestamptz O`; `created_by_user_id uuid R FK`; `approved_by_user_id uuid O FK`; `lock_version integer R default 0`; timestamps | UQ `(warehouse_id, stocktake_number)`; index status/time. |
| `stocktake_items` | `stocktake_id uuid R FK`; `inventory_position_id uuid R FK`; `inventory_lot_id uuid O FK`; `system_quantity numeric(18,6) R`; `counted_quantity numeric(18,6) O`; `variance_quantity numeric(18,6) O`; `counted_by_user_id uuid O FK`; `counted_at timestamptz O`; `adjustment_movement_id uuid O FK`; timestamps | Unique position/lot within stocktake; adjustment posted only after approval. |

### Procurement tables

| Table | Specific fields | Constraints, indexes, history |
|---|---|---|
| `suppliers` | `organization_id uuid R FK`; `code varchar(50) R`; `name varchar(200) R`; `tax_identifier varchar(100) O`; `status varchar(40) R`; `contact_details jsonb O`; `archived_at timestamptz O`; mutable common | UQ `(organization_id, code)`; tax/privacy `LEGAL_VALIDATION`. |
| `purchase_requests` | `branch_id uuid R FK`; `request_number varchar(50) R`; `status varchar(40) R`; `requested_by_user_id uuid R FK`; `needed_by date O`; `reason text O`; `approval_request_id uuid O FK`; mutable common | UQ `(branch_id, request_number)`; status/time index. |
| `purchase_request_items` | `purchase_request_id uuid R FK`; `ingredient_id uuid R FK`; `quantity numeric(18,6) R`; `unit_id uuid R FK`; `note text O`; timestamps | UQ request/ingredient unless repeated rationale; positive quantity. |
| `purchase_orders` | `organization_id uuid R FK`; `branch_id uuid O FK`; `supplier_id uuid R FK`; `purchase_order_number varchar(50) R`; `status varchar(40) R`; `currency_code char(3) R`; `ordered_at timestamptz O`; `expected_on date O`; `approval_request_id uuid O FK`; `created_by_user_id uuid R FK`; mutable common | UQ `(organization_id, purchase_order_number)`; supplier/status indexes. |
| `purchase_order_items` | `purchase_order_id uuid R FK`; `purchase_request_item_id uuid O FK`; `ingredient_id uuid R FK`; `ordered_quantity numeric(18,6) R`; `unit_id uuid R FK`; `unit_price_amount numeric(24,8) R`; `tax_amount bigint R default 0`; `received_quantity numeric(18,6) R default 0`; timestamps | Index PO/ingredient; quantity/cost nonnegative; received ≤ ordered except approved tolerance. |
| `goods_receipts` | `purchase_order_id uuid R FK`; `warehouse_id uuid R FK`; `receipt_number varchar(50) R`; `status varchar(40) R`; `received_by_user_id uuid R FK`; `received_at timestamptz R`; `supplier_document_reference varchar(100) O`; `idempotency_key varchar(200) R`; immutable after posting | UQ `(warehouse_id, receipt_number)` and idempotency scope; indexes PO/time. |
| `goods_receipt_items` | `goods_receipt_id uuid R FK`; `purchase_order_item_id uuid R FK`; `accepted_quantity numeric(18,6) R default 0`; `quarantined_quantity numeric(18,6) R default 0`; `rejected_quantity numeric(18,6) R default 0`; `unit_cost_amount numeric(24,8) R`; `currency_code char(3) R`; `lot_code varchar(100) R`; `expiry_date date O`; `rejection_reason text O`; immutable | UQ receipt/PO line/lot; quantities nonnegative; creates Lot and movements atomically. |
| `supplier_payables` | `purchase_order_id uuid R FK`; `supplier_id uuid R FK`; `invoice_reference varchar(100) R`; `amount_due bigint R`; `amount_paid bigint R default 0`; `currency_code char(3) R`; `due_date date O`; `status varchar(40) R`; `evidence_reference text O`; mutable with payment history policy | UQ `(supplier_id, invoice_reference)`; status/due index; accounting/tax `LEGAL_VALIDATION`. |

## 9. Cash and finance

### `cash_drawers`, `cash_sessions`, `cash_transactions`

| Table | Specific fields | Constraints, indexes, history |
|---|---|---|
| `cash_drawers` | `branch_id uuid R FK`; `code varchar(50) R`; `name varchar(100) R`; `status varchar(40) R`; `device_id uuid O FK`; mutable common | UQ `(branch_id, code)`; initial operation uses one shared drawer (`OWNER_CONFIRMED`); exact hardware mapping and any future multi-drawer expansion remain unresolved. |
| `cash_sessions` | `cash_drawer_id uuid R FK`; `branch_id uuid R FK`; `operating_day date/policy-derived identifier R`; `session_number varchar(50) R`; `status varchar(40) R`; `opened_by_user_id uuid R FK`; `opening_amount bigint R`; `currency_code char(3) R`; `opened_at timestamptz O`; `counting_started_at timestamptz O`; `expected_close_amount bigint O`; `actual_close_amount bigint O`; `variance_amount bigint O`; `variance_reason text O`; `closed_by_user_id uuid O FK`; `closed_at timestamptz O`; `lock_version integer R default 0`; timestamps | UQ `(branch_id, session_number)`; one open/counting session per drawer; immutable close values. A new opening count does not allocate a new daily float. Exact Operating Day representation is deferred. |
| `cash_transactions` | `cash_session_id uuid R FK`; `transaction_type varchar(40) R`; `amount_delta bigint R`; `currency_code char(3) R`; `payment_attempt_id uuid O FK`; `expense_id uuid O FK`; `actor_user_id uuid R FK`; `approved_by_user_id uuid O FK`; `source_reference text O`; `reason text O`; `occurred_at timestamptz R`; `idempotency_key varchar(200) R`; `reverses_cash_transaction_id uuid O FK`; immutable | UQ `(cash_session_id, idempotency_key)`; session/time and source indexes; nonzero delta. A top-up records source, executor, approver, and time and is not revenue. Cash ledger remains unimplemented. |

`OWNER_CONFIRMED` One shared drawer uses a configurable 2,000,000 VND float per Operating Day, carried across shift Cash Sessions. There is no automatic mid-day reset/top-up and no fixed top-up frequency limit. Exact configuration/effective-date and Operating Day schema remain proposals.

### `expense_categories`, `expenses`, `budgets`

| Table | Specific fields | Constraints, indexes, history |
|---|---|---|
| `expense_categories` | `organization_id uuid R FK`; `code varchar(50) R`; `name varchar(150) R`; `accounting_classification varchar(80) O`; `status varchar(40) R`; mutable common | UQ `(organization_id, code)`; classification `LEGAL_VALIDATION`. |
| `expenses` | `organization_id uuid R FK`; `branch_id uuid O FK`; `expense_category_id uuid R FK`; `expense_number varchar(50) R`; `operating_day date/policy-derived identifier R`; `amount bigint R`; `currency_code char(3) R`; `incurred_on date R`; `status varchar(40) R`; `purpose text R`; `recipient text R`; `payment_source varchar(40) O`; `requested_by_user_id uuid R FK`; `executed_by_user_id uuid R FK`; `approved_by_user_id uuid O FK`; `approval_request_id uuid O FK`; `receipt_reference text O`; `evidence_explanation text O`; `paid_at timestamptz O`; `reverses_expense_id uuid O FK`; mutable until confirmed, then immutable | UQ `(organization_id, expense_number)`; Branch/Operating Day/category indexes; positive amount; receipt or explanation required. Delegated ≤200,000 VND each and cumulative ≤500,000 VND/Operating Day, otherwise Owner approval; no self-approval or splitting to evade limits. Values configurable; enforcement design deferred. |
| `budgets` | `organization_id uuid R FK`; `branch_id uuid O FK`; `expense_category_id uuid R FK`; `period_start date R`; `period_end date R`; `amount bigint R`; `currency_code char(3) R`; `status varchar(40) R`; `approved_by_user_id uuid O FK`; timestamps | UQ scope/category/period; positive amount; budget does not authorize Expense. |

## 10. Service and operations

### Tables and reservations

| Table | Specific fields | Constraints, indexes, history |
|---|---|---|
| `dining_tables` | `branch_id uuid R FK`; `floor_code varchar(50) R`; `code varchar(50) R`; `name varchar(100) R`; `capacity integer O`; `status varchar(40) R`; `archived_at timestamptz O`; mutable common | UQ `(branch_id, code)`; floor/status index; positive capacity. |
| `reservations` | `branch_id uuid R FK`; `customer_id uuid O FK`; `reservation_number varchar(50) R`; `guest_name_snapshot varchar(200) R`; `contact_snapshot varchar(100) O`; `party_size integer R`; `starts_at timestamptz R`; `ends_at timestamptz O`; `status varchar(40) R`; `note text O`; mutable common | UQ `(branch_id, reservation_number)`; branch/time/status index; policy `OPEN_DECISION`. |
| `table_sessions` | `branch_id uuid R FK`; `reservation_id uuid O FK`; `opened_by_user_id uuid R FK`; `guest_count integer O`; `status varchar(40) R`; `opened_at timestamptz R`; `closed_by_user_id uuid O FK`; `closed_at timestamptz O`; `lock_version integer R default 0`; timestamps | Branch/status index; close rules `OPEN_DECISION`; positive guest count. |
| `table_assignments` | `table_session_id uuid R FK`; `dining_table_id uuid R FK`; `assigned_at timestamptz R`; `released_at timestamptz O`; `assigned_by_user_id uuid R FK`; `release_reason text O`; immutable interval | Partial UQ active Dining Table; indexes session/time and table/time. |

### Assets, checklists, feedback, and food safety

| Table | Specific fields | Constraints, indexes, history |
|---|---|---|
| `assets` | `branch_id uuid R FK`; `asset_code varchar(50) R`; `name varchar(150) R`; `asset_type varchar(50) R`; `status varchar(40) R`; `acquired_on date O`; `retired_on date O`; `location_text varchar(200) O`; mutable common | UQ `(branch_id, asset_code)`; status/type indexes. |
| `maintenance_records` | `asset_id uuid R FK`; `type varchar(40) R`; `status varchar(40) R`; `reported_at timestamptz R`; `scheduled_for timestamptz O`; `completed_at timestamptz O`; `reported_by_user_id uuid R FK`; `performed_by text O`; `cost_amount bigint O`; `currency_code char(3) O`; `details text O`; mutable until completion | Asset/status/time indexes; completed history immutable. |
| `checklists` | `branch_id uuid R FK`; `code varchar(50) R`; `name varchar(150) R`; `kind varchar(40) R`; `version integer R`; `status varchar(40) R`; `effective_from timestamptz R`; `effective_to timestamptz O`; immutable after publication | UQ `(branch_id, code, version)`; non-overlap active version. |
| `checklist_tasks` | `checklist_id uuid R FK`; `task_code varchar(50) R`; `label text R`; `position integer R`; `is_required boolean R default true`; `evidence_kind varchar(40) O`; immutable with template version | UQ `(checklist_id, task_code)` and position. |
| `checklist_runs` | `checklist_id uuid R FK`; `branch_id uuid R FK`; `scheduled_for timestamptz O`; `status varchar(40) R`; `started_by_user_id uuid O FK`; `started_at timestamptz O`; `completed_at timestamptz O`; timestamps | Branch/status/time index; retains template version FK. |
| `checklist_completions` | `checklist_run_id uuid R FK`; `checklist_task_id uuid R FK`; `status varchar(40) R`; `completed_by_user_id uuid O FK`; `completed_at timestamptz O`; `note text O`; `evidence_reference text O`; immutable after run close | UQ `(checklist_run_id, checklist_task_id)`; incomplete required tasks block close by policy. |
| `customer_feedback` | `branch_id uuid R FK`; `customer_id uuid O FK`; `order_id uuid O FK`; `feedback_number varchar(50) R`; `channel varchar(40) R`; `severity varchar(40) R`; `status varchar(40) R`; `summary text R`; `details text O`; `assigned_to_user_id uuid O FK`; `resolved_at timestamptz O`; `resolution text O`; mutable common | UQ `(branch_id, feedback_number)`; branch/status/severity index; privacy retention `LEGAL_VALIDATION`. |
| `temperature_records` | `branch_id uuid R FK`; `warehouse_id uuid O FK`; `asset_id uuid O FK`; `measurement_type varchar(40) R`; `measured_value numeric(18,6) R`; `unit_code varchar(20) R`; `measured_at timestamptz R`; `recorded_by_user_id uuid R FK`; `within_limit boolean R`; `corrective_action text O`; immutable | Index Branch/time and out-of-limit; thresholds/retention `LEGAL_VALIDATION`. |

## 11. Reporting, devices, printing, approvals, audit, and reliable processing

### Reporting runs and deliveries (`TECHNICAL_PROPOSAL`)

Future reporting records retain one idempotent report generation identity for report kind, scope, period, and definition version, plus separate delivery history/attempts for Dashboard/Telegram outputs. Reporting reads committed business facts/projections and never mutates Orders, Payments, Refunds, Cash Transactions, Expenses, or source audit evidence. Telegram payloads exclude sensitive information.

`OWNER_CONFIRMED` Dashboard views support daily, weekly, monthly, custom ranges, and comparisons; automatic daily Telegram delivery is required; Excel export is deferred. Exact delivery time, recipients, Operating Day cutoff, metric formulas, Branch scope, privacy details, retention, and failure escalation remain `OPEN_DECISION`. No physical table shape is selected here.

### `devices`, `printers`, `print_jobs`, `print_attempts`

| Table | Specific fields | Constraints, indexes, history |
|---|---|---|
| `devices` | `branch_id uuid R FK`; `device_code varchar(50) R`; `name varchar(100) R`; `device_type varchar(40) R`; `status varchar(40) R`; `last_seen_at timestamptz O`; `archived_at timestamptz O`; mutable common | UQ `(branch_id, device_code)`; status/last-seen index. Hardware `OPEN_DECISION`. |
| `printers` | `branch_id uuid R FK`; `device_id uuid O FK`; `printer_code varchar(50) R`; `name varchar(100) R`; `purpose varchar(40) R`; `status varchar(40) R`; `configuration jsonb O`; `last_seen_at timestamptz O`; mutable common | UQ `(branch_id, printer_code)`; purpose/status index. |
| `print_jobs` | `branch_id uuid R FK`; `printer_id uuid O FK`; `document_type varchar(50) R`; `document_id uuid R`; `status varchar(40) R`; `idempotency_key varchar(200) R`; `requested_by_user_id uuid R FK`; `requested_at timestamptz R`; `completed_at timestamptz O`; `content_hash varchar(128) R`; mutable technical state | UQ `(branch_id, idempotency_key)`; status/requested queue index. Never changes Payment/Preparation. |
| `print_attempts` | `print_job_id uuid R FK`; `attempt_number integer R`; `printer_id uuid O FK`; `status varchar(40) R`; `started_at timestamptz R`; `completed_at timestamptz O`; `error_code varchar(100) O`; `safe_error_detail text O`; immutable | UQ `(print_job_id, attempt_number)`; status/time index. |

### `approval_requests`, `approval_decisions`

| Table | Specific fields | Constraints, indexes, history |
|---|---|---|
| `approval_requests` | `organization_id uuid R FK`; `branch_id uuid O FK`; `subject_type varchar(60) R`; `subject_id uuid R`; `policy_key varchar(100) R`; `policy_version varchar(50) R`; `status varchar(40) R`; `requested_by_user_id uuid R FK`; `requested_at timestamptz R`; `reason text O`; `expires_at timestamptz O`; mutable until final | Index subject, status/time, requester; UQ active request per policy/subject where appropriate. Generic subject validated by application. |
| `approval_decisions` | `approval_request_id uuid R FK`; `decision varchar(40) R`; `decided_by_user_id uuid R FK`; `decided_at timestamptz R`; `reason text O`; `effective_role_key varchar(50) R`; `effective_branch_id uuid O FK`; immutable | Index request/time; final-decision cardinality per policy. Self-approval policy `OPEN_DECISION`. |

### `audit_logs` — sensitive-action evidence (`OWNER_CONFIRMED`)

Fields: `organization_id uuid R FK`; `branch_id uuid O FK`; `actor_user_id uuid O FK`; `action_code varchar(100) R`; `outcome varchar(30) R`; `subject_type varchar(60) R`; `subject_id uuid O`; `reason_code varchar(100) O`; `reason text O`; `effective_role_key varchar(50) O`; `effective_capability varchar(100) O`; `before_summary jsonb O`; `after_summary jsonb O`; `request_id varchar(100) O`; `occurred_at timestamptz R`; `schema_version integer R`; `safe_metadata jsonb O`; immutable. `TECHNICAL_PROPOSAL`: unauthenticated events keep actor null and may use a keyed identifier digest only if retention/security review approves it.  
Keys/indexes: indexes `(subject_type, subject_id, occurred_at)`, actor/time, action/time, Branch/time. Audit data is append-only and read access is restricted (`OWNER_CONFIRMED`). The implemented Phase 1 `audit_events` subset permits INSERT/SELECT and rejects UPDATE/DELETE through both Rails callbacks and a PostgreSQL row trigger, including bulk and direct SQL mutation. Inserts remain part of their parent transaction and roll back with it. This enforcement does not prevent a table owner or superuser from deliberately disabling/dropping the trigger, changing privileges/ownership, or truncating the table. Development/test currently uses one privileged `postgres` role; production runtime/schema-owner separation and least-privilege grants are not yet implemented. Exact reader roles, integrity verification, retention, export, privacy, and redaction require security/deployment/legal review.

Passwords, PINs, raw session/invitation/recovery tokens, MFA seeds/codes, CSRF values, cookies/authorization headers, and unrestricted request bodies are forbidden in all audit fields.

### `idempotency_records` — command deduplication (`TECHNICAL_PROPOSAL`)

Fields: `organization_id uuid R FK`; `scope varchar(100) R`; `idempotency_key varchar(200) R`; `request_fingerprint varchar(128) R`; `status varchar(40) R`; `actor_user_id uuid O FK`; `device_id uuid O FK`; `resource_type varchar(60) O`; `resource_id uuid O`; `response_status integer O`; `started_at timestamptz R`; `completed_at timestamptz O`; `expires_at timestamptz O`; mutable technical state.  
Keys/indexes: UQ `(organization_id, scope, idempotency_key)`; status/started index; same key/different fingerprint is conflict. Financial/domain unique keys remain too.

### `outbox_events` — reliable post-commit delivery (`TECHNICAL_PROPOSAL`)

Fields: `organization_id uuid R FK`; `aggregate_type varchar(60) R`; `aggregate_id uuid R`; `event_type varchar(100) R`; `event_version integer R`; `payload jsonb R`; `occurred_at timestamptz R`; `published_at timestamptz O`; `attempt_count integer R default 0`; `next_attempt_at timestamptz O`; `last_error_code varchar(100) O`; mutable technical delivery state.  
Keys/indexes: UQ `(aggregate_type, aggregate_id, event_type, event_version)`; queue index `(published_at, next_attempt_at)`. Payload excludes secrets and unnecessary PII.

## 12. Index and historical summary

- Every FK used for joins or authorization receives an index unless covered by a leading-column composite index.
- Queue indexes begin with scope/status then time: Preparation, Delivery, Print, Approval, and Outbox.
- Effective-dated tables index owner/source plus `effective_from` and use exclusion constraints or serialized application validation for non-overlap.
- Transactional ledgers index source identity and occurred time; no blanket index on low-cardinality status alone.
- Snapshot/source FKs may become null only if legal retention and deletion policy permits; default policy is archive sources and retain FKs.
- Closed/confirmed records are not soft-deleted. Master/config data uses status/`archived_at`; personal-data anonymization requires legal policy and must preserve financial/audit referential integrity.

## 13. Deferred dictionary items

These are not silently omitted:

- `payment_allocations`: deferred until partial/split semantics are approved (`OPEN_DECISION`).
- tax-invoice entities/fields: deferred pending `LEGAL_VALIDATION` and provider selection.
- Region/Regional Manager scope tables: deferred until future role policy is approved.
- MFA factors and recovery codes: MFA scope is Owner-confirmed; records are deferred until a security review selects enrollment, storage, verification, and recovery controls.
- detailed supplier-payment ledger: `supplier_payables` is logical only until accounting workflow is validated.
- reservation deposits, customer addresses, external delivery marketplace, and SaaS tenancy: outside current approved scope.
- excess-received/refund evidence records: required by Owner policy but deferred until allocation, Refund method, authority, and lifecycle are designed.
- reporting run/delivery tables: deferred until report scope, cutoff, formulas, recipients, privacy, retention, and escalation are approved.

