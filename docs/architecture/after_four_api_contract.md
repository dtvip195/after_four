# AFTER FOUR API Contract v1.0

**Status:** Canonical logical HTTP contract for review; no implementation is authorized
**Date:** 2026-11-14
**Sources:** [Owner Decision Baseline](after_four_owner_decision_baseline.md) · [DDD Foundation](after_four_ddd_foundation.md) · [Business Domain Model](after_four_business_domain_model.md) · [ERD](after_four_erd.md) · [Data Dictionary](after_four_data_dictionary.md) · [Integrity Rules](after_four_data_integrity_rules.md) · [State Machines](after_four_state_machines.md) · [Error Catalog](after_four_api_error_catalog.md) · [Payment Model](after_four_payment_model.md) · [API ADR](adr/0009-api-conventions-versioning.md)

## 1. Contract stance and provenance

The interface is a versioned REST/JSON seam over one logical modular monolith. Named command resources hide authorization, validation, pricing, transaction, audit, concurrency, and idempotency behavior behind a small interface. Generic `PATCH status`, GraphQL, microservices, and client-authored totals are excluded.

Labels retain canonical meaning: `OWNER_CONFIRMED`, `WORKSHOP_AGREED`, `TECHNICAL_PROPOSAL`, `OPEN_DECISION`, and `LEGAL_VALIDATION`. Unlabeled HTTP mechanics are `TECHNICAL_PROPOSAL`.

The current React prototype has no API client, persistence, identity, or production state. Its fixture types and UI status labels are not request/response contracts.

**Implementation Phase 1 activation note:** the Order/Payment command and persistence seam is implemented internally, but these planned mutation routes are not activated. Identity/authorization and server-authoritative item pricing do not yet exist, so exposing controller routes would invent a trust boundary. Health/readiness endpoints remain the only public backend routes. See [Phase 1 implementation record](after_four_order_payment_implementation_phase1.md).

## 2. Global conventions

### 2.1 URLs and resources

- Base path: `/api/v1`.
- Plural kebab-case resources; opaque lowercase UUID strings in examples.
- Branch-owned collections are nested once: `/branches/{branch_id}/orders`. Child commands use canonical IDs: `/orders/{order_id}/confirmations`.
- Organization-shared resources use `/customers`, `/employees`, `/suppliers`, with authorization-derived Organization scope.
- Commands are nouns describing business actions: `confirmations`, `cancellations`, `dispatch-retries`, `closures`, `receipts`. No `PATCH {status}`.
- Queries are safe `GET`; creation/commands are `POST`; editable drafts use `PATCH`; no business transaction uses `DELETE` as correction.

### 2.2 Request headers

| Header | Requirement |
|---|---|
| `Content-Type: application/json` | Required for JSON bodies. |
| `Accept: application/json` | Recommended; unsupported media returns `406`. |
| `Idempotency-Key` | Required for every retryable create/command listed below; opaque 16–200 characters. |
| `If-Match: "v{version}"` | Required for commands/editable aggregates subject to concurrent modification. |
| `X-Request-ID` | Optional client correlation ID; server validates/returns or creates one. |
| `X-CSRF-Token` | Required for unsafe cookie-authenticated requests if the session adapter uses cookies. |

The authenticated User, Organization, and effective permissions come from the trusted session, never request headers such as `X-User-ID` or `X-Role`.

### 2.3 Success envelopes

Single resource:

```json
{
  "data": {
    "type": "order",
    "id": "018f...",
    "version": 7,
    "attributes": {},
    "relationships": {}
  },
  "meta": { "request_id": "req_..." }
}
```

Collection:

```json
{
  "data": [],
  "meta": {
    "request_id": "req_...",
    "page": { "next_cursor": null, "has_more": false }
  }
}
```

- `201 Created` includes `Location` for a new addressable resource.
- Commands return the authoritative affected aggregate(s), never only `{success:true}`.
- `202 Accepted` is used only when the business command is durably accepted but external/technical completion remains pending; it includes a status resource URL.
- `204 No Content` is limited to logout or commands with no useful representation.

### 2.4 Errors

All non-2xx responses use the envelope defined in the [Error Catalog](after_four_api_error_catalog.md):

```json
{
  "error": {
    "code": "order_version_conflict",
    "message": "Đơn đã được cập nhật trên thiết bị khác.",
    "request_id": "req_...",
    "retryable": false,
    "details": { "current_version": 8 },
    "field_errors": []
  }
}
```

Messages are safe display text; clients branch only on stable `code`.

### 2.5 Pagination, filtering, sorting, and search

- Cursor parameters: `page[after]`, `page[limit]` (default 25, maximum 100).
- Filters: `filter[status]`, `filter[branch_id]`, and domain allowlists. Unknown filters return `invalid_filter`.
- Sorting: `sort=created_at` or `sort=-created_at`; each endpoint publishes an allowlist and stable ID tiebreaker.
- Search: `q` is normalized free text for explicitly searchable fields; it never bypasses Branch/permission filters.
- Operational queues use stable `(scope, status, time, id)` cursors; page-number pagination is not used for mutable queues.

### 2.6 Serialization

| Value | JSON form | Example |
|---|---|---|
| ID | string | `"018f..."` |
| Money | object with decimal-string integer amount and ISO currency | `{"amount":"58000","currency":"VND"}` |
| Quantity/rate | decimal string plus unit where relevant | `{"value":"1.250000","unit":"kg"}` |
| Instant | ISO 8601 UTC | `"2026-11-14T08:30:00Z"` |
| Local date | `YYYY-MM-DD` | `"2026-11-30"` |
| Timezone | IANA name | `"Asia/Ho_Chi_Minh"` |
| Boolean/null | JSON native | `true`, `null` |

Clients never submit localized money strings or floating-point financial values. Responses include Branch timezone where business-date interpretation matters.

### 2.7 Authentication and session behavior

- `WORKSHOP_AGREED` Every protected endpoint requires an active User and server-side authorization.
- `TECHNICAL_PROPOSAL` Initial browser deployment uses an opaque server session carried only in a host-only `Secure`, `HttpOnly`, `SameSite=Lax` cookie. The server stores a one-way secret verifier and enforces revocation and idle/absolute expiry. A bearer-token adapter requires a superseding review; business contracts never expose stored credentials.
- Rails CSRF and origin verification protect every unsafe cookie-authenticated request. `OWNER_CONFIRMED` Production uses one HTTPS origin, with frontend and `/api/v1` through one managed edge, a private Rails origin, explicit trusted proxies, enabled/configured Host Authorization, no default CORS, and non-sensitive health responses. Exact hosting/proxy/network details require deployment/security review; no vendor is selected.
- Login, recovery, credential changes, MFA changes, and privilege-sensitive changes rotate or revoke affected session identity. Logout invalidates the current session.
- Suspended/deactivated User returns `account_inactive`; locked authentication returns the same generic public credential response unless an already authenticated authorized view may safely expose status. Expired/invalid/revoked session returns `authentication_required`.
- `/me` is authoritative for effective roles, Branch scopes, capabilities, and session expiry. Frontend control visibility is convenience only.
- `OWNER_CONFIRMED` Back-office sessions expire after 30 minutes idle and no later than 12 hours. POS sessions lock after 2 minutes idle and require individual reauthentication. Multiple device sessions are allowed with no numeric MVP cap. Session visibility, appropriate new-device notification, anomaly detection/revocation, and Owner all-session revocation are required; exact contracts remain security-review work.
- `OWNER_CONFIRMED` MFA is mandatory for Owner and every Branch Manager; sensitive Branch Manager capabilities require step-up. Ordinary and sensitive capabilities must be explicitly enumerated rather than inferred; the exact capability/factor/step-up contract remains security-review work.

### 2.8 Authorization, Branch scope, audit, and concurrency

- Scope is evaluated server-side against current User lifecycle, effective Role Assignments, immutable resource ownership, and—except for an approved Owner Organization scope—the linked Employee's effective Branch Assignments.
- Invitation Delegation is not a Role Assignment. Only an active Branch Manager with a current delegation may invite Staff, only for assigned Branches, for at most 90 days; the delegate cannot approve assignments, delegate onward, or self-renew. Owner revocation invalidates outstanding unused invitations. Representation and race handling remain unimplemented and review-dependent.
- Collections are scoped before lookup/serialization. UUIDs, client Branch IDs, role headers, selected UI Branches, Devices, and Shifts never grant authority.
- A caller with no visibility receives `404 resource_not_found` where revealing existence would leak cross-Branch data; explicit attempted Branch switching may return `403 branch_scope_violation`.
- Sensitive commands require `reason` where policy says so and always record actor, request ID, effective role/Branch, approver, and time.
- Aggregate responses include integer `version` and `ETag: "v{version}"`. Required `If-Match` mismatch returns `409 concurrent_modification` with current version, never silent last-write-wins.
- Idempotent replay with the same key/fingerprint returns the original semantic result and `Idempotent-Replayed: true`. Same key/different payload returns `409 idempotency_conflict`.

## 3. Shared representations

### 3.1 Order summary

Required fields: `id`, `version`, `branch_id`, `order_number`, `channel`, `status`, optional `customer_id`/`table_session_id`, `items`, authoritative `totals`, `payment_summary`, `preparation_summary`, timestamps. Each item contains immutable sold snapshots plus optional source IDs.

### 3.2 Payment summary

Fields: `id`, `version`, `order_id`, `funding_status`, `attempt_activity`, `target`, `successful`, `refunded`, `remaining`, `fully_settled_at`, and attempt links. Funding and activity values/combinations follow the [Payment Model](after_four_payment_model.md). Attempt fields retain their independent method/kind/status/amount, safe provider reference, timestamps, and safe failure code; never provider secrets or raw payloads.

### 3.3 Stock quantity

Fields: `ingredient_id`, `warehouse_id`, `on_hand`, `available`, `quarantined`, `in_transit_in`, `in_transit_out`, `weighted_average_cost` when capability permits, `version`, `as_of`.

## 4. Identity contracts

| Method/path | Purpose and main fields | Authorization / controls | Main errors |
|---|---|---|---|
| `POST /sessions` | Login: unique `username`, credential proof, optional `device_id`; email is never accepted as login; returns session metadata and `/me` summary | Public; rate-limited with progressive delay; audited failures without secret data; generic response for unknown/inactive/locked identity | `invalid_credentials`, `rate_limited` |
| `DELETE /session` | Logout current session | Authenticated; CSRF if cookie | `authentication_required` |
| `GET /me` | Current User, Employee link, effective roles/capabilities/Branches, expiry | Authenticated | `authentication_required` |
| `GET /sessions` | List current User sessions/devices | Authenticated self | `authentication_required` |
| `POST /sessions/{id}/revocations` | Revoke session | Self or Owner security capability; `Idempotency-Key` | `resource_not_found`, `forbidden` |
| `GET /users` | Account list with status/search | Owner; Organization scope; paginated | `forbidden` |
| `POST /users` | Proposed invitation command; direct active-account creation is forbidden | Owner, or active delegated Branch Manager inviting Staff within assigned Branches; delegation max 90 days; idempotent/audited; exact representation, acceptance, revocation-race controls require review | `validation_failed`, `duplicate_resource`, `identity_policy_unresolved` |
| `POST /users/{id}/deactivations` | Deactivate, preserving history; `reason`, `If-Match` | Owner; audited | `invalid_state_transition`, `concurrent_modification` |
| `GET /employees/{employee_id}/branch-assignments` | Effective assignment history | Owner; Branch Manager within assigned Branch; employee self read where permitted | `resource_not_found` |
| `POST /employees/{employee_id}/branch-assignments` | `branch_id`, `assignment_type`, effective interval, reason | Requires Owner approval for every change; idempotent/audited | `branch_scope_violation`, `effective_period_overlap`, `approval_required` |
| `POST /branch-assignments/{id}/endings` | End assignment at `effective_to` | Requires Owner approval; `If-Match`; audited | `invalid_state_transition`, `approval_required` |

Invitation-only policy, individual 6–8 digit enrolled-POS-only PIN scope, required PIN online defenses, password/PIN security boundaries, lifecycle authority, delegation boundaries, Branch Manager MFA/scope, and Owner recovery principles are Owner-confirmed, but this table does not authorize new endpoints. Authentication lock is temporary/automated; suspension/reactivation and deactivation are Owner-controlled, with explicit audited reactivation and no automatic return after deactivation. Invitation acceptance, exact limiter/lock behavior, Owner-unavailable escalation, identifier change, credential reset, PIN, MFA, and exact Owner-recovery contracts require the [Identity Security Review Checklist](after_four_identity_security_review_checklist.md). No endpoint may expose stored credential, factor, or raw session/recovery material.

## 5. Product and menu contracts

This section is a future contract, not an active route or implementation authorization. Product is Brand-global; Categories are flat; every Product remains in its original Category and no reassignment command/API is supported in MVP (`ODB-CAT-41`). Category/Variant create Draft and follow `ODB-CAT-30`–`ODB-CAT-32`; Variant Archive/Restore changes status only and preserves `is_default` and `customer_visible` (`ODB-CAT-40`). Product Activate, Deactivate, Archive, and Restore commands/APIs are excluded from initial Catalog Core MVP (`ODB-CAT-39`). Every Product has at most one designated Default; Active requires Active Category and exactly one Active Default independent of visibility (`ODB-CAT-28`, `ODB-CAT-29`, `ODB-CAT-38`). Codes remain separately Brand/type scoped and SKU input is deferred. No implementation is authorized.

| Method/path | Contract | Authorization / controls | Main errors |
|---|---|---|---|
| `GET /branches/{branch_id}/menu` | Effective categories/products/variants, availability, current price, modifiers; filters `category_id`, `available`; search `q` | Any assigned operational role; Branch scope | `branch_scope_violation` |
| `GET /branches/{branch_id}/products/{variant_id}` | Effective detail and modifier cardinality | Assigned Branch | `resource_not_found` |
| `GET /categories` | Brand catalog administration list | Owner/Branch Manager read | `forbidden` |
| `GET /products` / `GET /products/{id}` | Chain catalog/admin detail with variants | Owner/Branch Manager | `resource_not_found` |
| `POST /products` | Proposed Brand-global Product creation with required Category and stable Brand-scoped code; initial Variants are optional while Draft | Authority and exact transaction shape unresolved; idempotent/audited | `duplicate_resource`, `validation_failed` |
| `PATCH /products/{id}` | Proposed editable master fields only; Category reassignment and lifecycle changes are unsupported in MVP | Exact editable fields and authority unresolved; `If-Match`; audit | `concurrent_modification`, `validation_failed` |
| `POST /product-variants/{id}/prices` | New immutable effective Price version: optional `branch_id`, money, interval, approval reference | Publication authority unresolved; idempotent/audited; never overwrite a published version | `effective_period_overlap`, `approval_required` |
| `POST /branches/{branch_id}/product-availabilities` | Explicit Variant availability override, interval, reason; absence means inherit chain default | Publication authority unresolved; idempotent/audited | `effective_period_overlap` |

The effective Price is the explicit Branch version when one exists, otherwise the chain default (`ODB-CAT-07`). Price versions are immutable/effective-dated (`ODB-CAT-08`). Money displayed for a Draft is a provisional authoritative quote: if the effective Price changes, the API must return a revised quote that requires review before confirmation (`ODB-CAT-09`). Confirmation locks the sold Price snapshot (`ODB-CAT-10`). The quote/version-token and acceptance protocol remains technical design. Recipe details/costs require inventory/catalog capabilities and are not included in ordinary menu responses.

No route in this table authorizes Soft Delete or Purge. Catalog Core MVP prohibits both behaviors (`ODB-CAT-35`, `ODB-CAT-37`). Category/Variant state commands require Owner or explicit delegated authority plus validation/audit (`ODB-CAT-25`), while Product lifecycle and Category-reassignment commands are explicitly absent from initial scope (`ODB-CAT-39`, `ODB-CAT-41`). Product Restore policy in `ODB-CAT-24`/`33` is retained for future scope, not exposed here.

## 6. POS and sales contracts

### 6.1 Order commands

The normal POS flow keeps the Order in Draft while staff add, update, and remove items, then confirms it immediately before initiating payment. Once confirmed, sold snapshots are frozen; returning a confirmed unpaid Order to Draft or accepting an amendment is not silently allowed and depends on the unresolved cancellation/correction policy. Confirmed Orders may become Held through an attributed exception or Expired at the configured payment deadline. Neither state is automatically dispatchable or reactivated by a later successful payment; the payment is recorded and routed to an exception review.

| Method/path | Request / response | Authorization / controls | Main errors |
|---|---|---|---|
| `POST /branches/{branch_id}/orders` | `channel`, optional `table_session_id`, `customer_id`; returns Draft Order; dine-in/takeaway selection requires no reason | Staff/Branch Manager/Owner in Branch; `Idempotency-Key`; audit create | `branch_scope_violation`, `invalid_table_session` |
| `GET /orders/{id}` | Authoritative Order with independent payment/preparation summaries | Branch-scoped read | `resource_not_found` |
| `GET /branches/{branch_id}/orders` | Cursor list; filters status/channel/date/customer/table | Branch-scoped read | `invalid_filter` |
| `POST /orders/{id}/items` | Variant, quantity, modifier IDs, note; returns recalculated Order | Draft only; `Idempotency-Key`, `If-Match` | `order_not_editable`, `price_version_conflict`, `product_unavailable` |
| `PATCH /order-items/{id}` | Draft quantity/modifiers/note; returns Order | Draft only; `If-Match` Order version | same plus `concurrent_modification` |
| `DELETE /order-items/{id}` | **Not supported.** | — | Use `POST /order-items/{id}/removals` while Draft. |
| `POST /order-items/{id}/removals` | Removes Draft item; reason optional; returns Order | Draft only; idempotent, `If-Match` | `order_not_editable` |
| `POST /orders/{id}/pricing` | Recalculate/revalidate Draft without confirmation; optional promotion/customer inputs | Branch-scoped; `If-Match`; no client totals | `price_version_conflict`, `promotion_not_eligible` |
| `POST /orders/{id}/customer-associations` | `SUPERSEDED_PROPOSAL`: the earlier `customer_id`/consented phone-profile illustration is not an approved contract | No endpoint, payload, authorization, consent, or error contract is approved; replacement awaits Customer technical design | Earlier `customer_consent_required` and `customer_merge_required` examples are superseded; no replacement code is approved |
| `POST /orders/{id}/promotion-applications` | `promotion_code`; server determines eligibility/stacking | Draft; `Idempotency-Key`, `If-Match` | `promotion_not_eligible`, `promotion_policy_unresolved` |
| `POST /orders/{id}/confirmations` | No client totals; server snapshots sold prices/options and confirms Order only after any revised quote was reviewed | Branch operator; `Idempotency-Key`, `If-Match`; audit | `empty_order`, `price_version_conflict`, `product_unavailable` |
| `POST /orders/{id}/cancellation-requests` | `reason`, affected scope and observed preparation state | Before preparation starts: Staff may request and complete with reason/audit. After preparation starts: Owner approval is required. Completed Orders use a separate unresolved exception process. Idempotent/audited; implementation needs an atomic preparation-state fence. | `approval_required`, `invalid_state_transition`, `cancellation_policy_unresolved` |

### 6.2 Payment commands

| Method/path | Request / response | Authorization / controls | Main errors |
|---|---|---|---|
| `POST /orders/{id}/payment-attempts` | `method`, requested amount, method-specific safe input; returns Payment + Attempt | Confirmed Order; Staff/Branch Manager/Owner; `Idempotency-Key`; server balance; audit | `order_not_payable`, `payment_amount_invalid`, `payment_provider_unavailable` |
| `GET /orders/{id}/payment` | Settlement and attempt history safe for operator | Branch-scoped read | `resource_not_found` |
| `GET /payment-attempts/{id}` | Authoritative status; never infer from client timeout | Branch-scoped read | `resource_not_found` |
| `POST /payment-attempts/{id}/reconciliations` | Query/apply authoritative evidence for unknown/pending result | Staff with payment capability/Branch Manager/Owner; `Idempotency-Key`; audited | `payment_reconciliation_unavailable`, `payment_result_unknown` |
| `POST /payment-attempts/{id}/retry-assessments` | Returns whether a new attempt is safe; does not charge | Branch operator | `payment_result_unknown` when unsafe |
| `POST /payment-provider-events/{provider}` | Signed provider event adapter endpoint | Provider authentication/signature; replay idempotency | `provider_signature_invalid`, `duplicate_request` |
| `POST /payments/{id}/refund-requests` | amount/reason; may create Approval Request, not provider refund yet | Policy unresolved; `Idempotency-Key`; audited | `approval_required`, `refund_policy_unresolved`, `refund_amount_exceeds_available` |
| `POST /refunds/{id}/executions` | Execute approved refund; returns pending/final Refund | Authorized role; `Idempotency-Key`, `If-Match`; audited | `refund_not_approved`, `payment_provider_unavailable` |
| `GET /refunds/{id}` | Refund status/history | Authorized Branch read | `resource_not_found` |

`OWNER_CONFIRMED` A successful individual attempt does not dispatch preparation unless authoritative successful allocation makes the Order fully settled **and** the locked Order remains Confirmed before its payment deadline. The local transaction records eligible settlement with the unique pending Preparation Dispatch. A late success for a Held/Expired Order instead records full financial truth and a review case with no Dispatch. External provider communication occurs before/after, never inside that database transaction.

Partial/split tender is `OPEN_DECISION`. Until approved, the implemented Phase 1 contract accepts only the exact remaining balance per successful settlement. An observed excess is not revenue: it requires evidence and refund under `OWNER_CONFIRMED` ODB-OP-11, but the refund method, allocation, lifecycle, and future excess-evidence representation remain `UNRESOLVED` and are not activated by this contract. The endpoint shape preserves future multiple attempts, but no item/check `payment_allocations` fields are exposed.

For the MVP manual bank-transfer path, the displayed QR belongs to the Owner. The speaker is only an amount alert and is never payment proof. A Staff member with payment capability manually compares the received amount with the pending Order and confirms only matching authoritative evidence in POS. There is no automatic bank API matching. Mismatch or excess remains unresolved and audited; no default confirmation or preparation dispatch occurs.

### 6.3 Preparation status and cancellation

| Method/path | Contract | Authorization / controls | Main errors |
|---|---|---|---|
| `GET /orders/{id}/preparation` | Dispatch state, tickets/items, status, retry visibility | Branch-scoped read | `preparation_not_dispatched` |
| `POST /orders/{id}/preparation-dispatch-retries` | Retry pending paid dispatch; returns Dispatch/ticket | Branch Manager/authorized operator; `Idempotency-Key`; audit | `payment_not_fully_settled`, `dispatch_already_completed` |
| `POST /orders/{id}/cancellations` | Final cancellation only after required approval | Authorized role; `Idempotency-Key`, `If-Match`; audited | `approval_required`, `invalid_state_transition` |

Post-payment or post-dispatch cancellation does not delete Payment/Preparation. Before preparation starts, Staff may cancel a paid Order with a reason and audit record. Once preparation has started, Owner approval is required. The decision and state read must be protected by an atomic preparation-state fence. Completed-Order exception outcomes and the exact Refund, Preparation deviation, loyalty, and stock orchestration remain `UNRESOLVED`.

## 7. Preparation contracts

| Method/path | Contract | Authorization / controls | Main errors |
|---|---|---|---|
| `GET /branches/{branch_id}/preparation-tickets` | Cursor queue; filters station/status; stable queued-time sort | Staff with preparation capability/Branch Manager/Owner in Branch | `branch_scope_violation` |
| `GET /preparation-tickets/{id}` | Ticket/items and immutable Order snapshots | Branch-scoped preparation read | `resource_not_found` |
| `POST /preparation-items/{id}/starts` | Start requested quantity; returns item/ticket | Staff with preparation capability; `Idempotency-Key`, `If-Match`; audit | `invalid_state_transition`, `quantity_exceeds_available` |
| `POST /preparation-items/{id}/ready-confirmations` | Mark quantity ready | Staff with preparation capability; idempotent/versioned | same |
| `POST /preparation-items/{id}/completions` | Complete handoff quantity | Staff with preparation/service capability; idempotent/versioned | same |
| `POST /preparation-tickets/{id}/completions` | Complete only if item guards pass | Staff with preparation capability; `Idempotency-Key`, `If-Match` | `preparation_items_incomplete` |
| `POST /preparation-items/{id}/remakes` | quantity, reason; creates deviation and new work | Authorized role; idempotent/audited | `approval_required`, `remake_policy_unresolved` |
| `POST /preparation-items/{id}/cancellations` | quantity, reason; never edits original quantities silently | Authorized policy; idempotent/audited | `approval_required`, `cancellation_policy_unresolved` |
| `POST /preparation-dispatches/{id}/retries` | Same logical operation as Order retry route; one canonical implementation | Authorized operator; idempotent | `dispatch_already_completed` |

Only paid Orders can have a Dispatch. Retrying creates/locates the same logical ticket; it cannot create duplicate work. Printer routes are separate.

## 8. Inventory and procurement contracts

| Method/path | Contract | Authorization / controls | Main errors |
|---|---|---|---|
| `GET /warehouses/{id}/stock` | Positions/lots; filters ingredient/disposition; cost visibility capability | Assigned Branch or organization inventory role | `warehouse_scope_violation` |
| `GET /inventory-positions/{id}/movements` | Cursor immutable ledger | Same scope; sensitive cost fields capability-gated | `resource_not_found` |
| `POST /warehouses/{id}/receipts` | Approved source, items/lot/expiry/cost; returns Goods Receipt + movements | Inventory role; `Idempotency-Key`; audited | `purchase_order_mismatch`, `quantity_invalid` |
| `POST /warehouses/{id}/issues` | ingredient/lot/quantity/reason/source | Inventory role; idempotent; locks stock | `insufficient_stock`, `lot_not_available` |
| `POST /warehouses/{id}/waste-records` | lot/quantity/reason/evidence | Authorized role; idempotent/audited | `insufficient_stock`, `approval_required` |
| `POST /stock-transfers` | source/destination/items/reason; Draft | Inventory role in source; idempotent | `warehouse_scope_violation` |
| `POST /stock-transfers/{id}/approval-requests` | Create approval under configurable policy | Authorized requester; idempotent/audited | `approval_policy_unresolved` |
| `POST /stock-transfers/{id}/dispatches` | Confirm lots/quantities; posts source movements/in transit | Authorized source role; `Idempotency-Key`, `If-Match`; audited | `insufficient_stock`, `transfer_not_approved` |
| `POST /stock-transfers/{id}/receipts` | accepted/quarantine/rejected per item; partial allowed | Authorized destination role; idempotent/versioned/audited | `transfer_over_receipt`, `invalid_state_transition` |
| `GET /stock-transfers/{id}` | Header/items/receipt history/in-transit remainder | Source/destination authorized scope | `resource_not_found` |
| `POST /warehouses/{id}/stocktakes` | Create Draft count | Inventory role; idempotent | `stocktake_already_open` |
| `PATCH /stocktake-items/{id}` | Count quantity/evidence while Draft/Counting | Assigned counter; `If-Match` Stocktake | `stocktake_closed` |
| `POST /stocktakes/{id}/completions` | Approve/post variance movements | Approved role; idempotent/versioned/audited | `approval_required`, `concurrent_modification` |
| `POST /purchase-requests` | Branch need + lines | Branch Manager/inventory role; idempotent | `approval_policy_unresolved` when threshold blocks |
| `POST /purchase-orders` | Supplier/lines/source request | Authorized procurement; idempotent/audited | `approval_required`, `supplier_inactive` |
| `POST /purchase-orders/{id}/sendings` | Commit approved PO as sent | Authorized procurement; idempotent/versioned | `purchase_order_not_approved` |
| `GET /purchase-orders/{id}` | PO, receipts, remaining qty, payable summary | Authorized procurement scope | `resource_not_found` |

Receipt/issue/dispatch/transfer-receipt/stocktake completion commit Stock Movement and Position/Lot/weighted-average updates together. External documents or physical movement are outside the transaction.

## 9. Cash contracts

| Method/path | Contract | Authorization / controls | Main errors |
|---|---|---|---|
| `GET /branches/{branch_id}/cash-drawers` | Shared-drawer/open-session and operating-day float summary | Staff with cash capability/Branch Manager/Owner in Branch | `branch_scope_violation` |
| `POST /cash-drawers/{id}/cash-sessions` | opening count/currency and operating-day reference; Prepared Session | Staff with cash capability; `Idempotency-Key`; audit | `cash_session_already_open` |
| `POST /cash-sessions/{id}/openings` | Verify opening cash sufficiency and open; a new shift session does not allocate a new daily float | Staff with cash capability; idempotent/versioned/audited | `invalid_state_transition`, `cash_opening_insufficient` |
| `POST /cash-sessions/{id}/transactions` | type, signed amount, reason/source; top-ups and expenses remain distinct from revenue | Staff with cash capability; idempotent/versioned/audited | `cash_session_not_open`, `approval_required` |
| `POST /cash-sessions/{id}/countings` | Start counting and submit actual amount | Authorized closing actor; idempotent/versioned | `cash_session_not_open` |
| `POST /cash-sessions/{id}/discrepancy-reasons` | reason; Owner escalation is a durable downstream effect | Closing actor; idempotent/audited | `cash_discrepancy_reason_required` |
| `POST /cash-sessions/{id}/closures` | Close immutable totals | Cashier/Branch Manager per open policy; idempotent/versioned/audited | `cash_session_unresolved_discrepancy` |
| `POST /cash-sessions/{id}/adjustments` | Post-close correction transaction, never overwrite | Authorized policy; approval may be required; audited | `approval_required`, `closed_session_direct_edit` |
| `GET /cash-sessions/{id}` | Expected/actual/variance/transactions | Branch cashier self context, Branch Manager/Owner review | `resource_not_found` |

Cash payment confirmation and its Cash Transaction share one future local transaction. Bank/electronic methods never create drawer Cash Transactions. The one shared drawer has one 2,000,000 VND float per operating day; it carries across shifts and is not automatically reset or replenished mid-day. Staff may request top-ups, but Owner authorization and evidence of amount, source, executor, approver, and time are required. Top-ups are not revenue. Exact operating-day boundary and endpoint representation remain unresolved.

Delegated expenses are limited to 200,000 VND per expense and 500,000 VND cumulative per operating day; either excess requires Owner approval. Self-approval and splitting to evade limits are forbidden. Purpose, recipient, executor, approver, and receipt or explanation evidence are required. Values are configurable policy, not hardcoded API constants. Exact enforcement representation remains a design task.

## 10. HR and payroll contracts

### 10.1 Employee, scheduling, and attendance

| Method/path | Contract | Authorization / controls | Main errors |
|---|---|---|---|
| `GET /employees` / `GET /employees/{id}` | Organization list/detail; Branch filter | Owner; Branch Manager assigned scope; Employee self detail | `forbidden`, `resource_not_found` |
| `GET /branches/{id}/shifts` | Cursor/calendar schedule | Branch Manager/Owner Branch; Staff own schedule | `branch_scope_violation` |
| `POST /branches/{id}/shifts` | employee, interval, duties; Draft | Branch Manager/Owner Branch; idempotent/audited | `shift_overlap`, `employee_not_assigned` |
| `POST /shifts/{id}/publications` | Publish schedule | Branch Manager/Owner; idempotent/versioned | `invalid_state_transition` |
| `POST /shift-swap-requests` | shift/replacement/reason | Affected Staff; idempotent/audited | `shift_swap_policy_unresolved` |
| `POST /shift-swap-requests/{id}/decisions` | approve/reject | Branch Manager/Owner in Branch; versioned/audited | `approval_required`, `invalid_state_transition` |
| `POST /branches/{id}/attendance/clock-ins` | employee/device/time authority | Staff self or Branch Manager correction path; idempotent | `employee_not_assigned`, `attendance_already_open` |
| `POST /attendance-records/{id}/clock-outs` | Close actual attendance | Staff self/Branch Manager; idempotent/versioned | `attendance_not_open` |
| `POST /attendance-records/{id}/corrections` | corrected values/reason, preserving original | Branch Manager; approval as policy; audited | `approval_required`, `closed_period` |

### 10.2 Leave and overtime

| Method/path | Contract | Authorization / controls | Main errors |
|---|---|---|---|
| `POST /leave-requests` | interval/type/reason/Branch | Employee self; idempotent | `leave_policy_unresolved`, `validation_failed` |
| `POST /leave-requests/{id}/decisions` | approve/reject/reason | Branch Manager normal; Owner exception (`OWNER_CONFIRMED`); versioned/audited | `approval_required`, `invalid_state_transition` |
| `POST /overtime-requests` | employee, minutes, attendance, reason | Branch Manager proposes (`OWNER_CONFIRMED`); idempotent/audited | `branch_scope_violation` |
| `POST /overtime-requests/{id}/decisions` | Owner approve/reject | Owner only (`OWNER_CONFIRMED`); versioned/audited | `forbidden`, `closed_period` |

### 10.3 Payroll

| Method/path | Contract | Authorization / controls | Main errors |
|---|---|---|---|
| `POST /payroll-periods` | month and following-month payment date | Owner; idempotent/audited | `payroll_period_overlap` |
| `POST /payroll-periods/{id}/calculations` | Recalculate Draft from approved inputs | Payroll capability; idempotent/versioned/audited | `payroll_inputs_incomplete`, `closed_period` |
| `GET /payroll-periods/{id}` | Period status/summary | Owner; Branch Manager limited review | `forbidden` |
| `GET /payroll-periods/{id}/payrolls` | Employee calculations/exceptions | Owner; Branch Manager review scope | `forbidden` |
| `POST /payroll-periods/{id}/branch-manager-reviews` | Complete preliminary review | Branch Manager/Owner; idempotent/versioned/audited | `payroll_review_incomplete` |
| `POST /payroll-periods/{id}/owner-reviews` | Move to Owner Review | Owner; idempotent/versioned/audited | `forbidden` |
| `POST /payroll-periods/{id}/closures` | Freeze period/payroll snapshots | Owner only (`OWNER_CONFIRMED`); idempotent/versioned/audited | `payroll_inputs_incomplete`, `closed_period` |
| `POST /payrolls/{id}/payments` | Record payment outcome/reference | Owner/payroll role; idempotent/audited | `payroll_not_closed` |
| `POST /payrolls/{id}/adjustment-requests` | Post-close amount/reason | Authorized requester; approval policy open | `approval_required` |
| `GET /payrolls/{id}/payslip` | Versioned PDF metadata/download URL | Employee self; Branch Manager policy; Owner | `payslip_not_ready`, `forbidden` |

## 11. Supporting domain contracts

| Domain | Representative endpoints | Status |
|---|---|---|
| Approvals | `GET /approval-requests`, `POST /approval-requests/{id}/decisions` | Contract stable; threshold/self-approval policies `OPEN_DECISION` |
| Reservations/tables | `POST /branches/{id}/reservations`, `POST /reservations/{id}/confirmations`, `/arrivals`, `/cancellations`; `POST /table-sessions`, `/table-assignments` | Resource shape stable; deposits/move/merge/split `OPEN_DECISION` |
| Customer/loyalty | `POST /customers`, `POST /customers/{id}/consents`, `GET /customers/{id}/loyalty`, `POST /loyalty-adjustment-requests` | `SUPERSEDED_OR_UNAPPROVED_ILLUSTRATIONS`: Production MVP scope and [`SDP-CUST-03` through `SDP-CUST-22` and `SDP-CUST-A2`](after_four_customer_management_owner_decisions.md) are `OWNER_CONFIRMED`, but no endpoint, payload, response, error, or authorization contract is approved. `SDP-CUST-19` permits anonymous Orders without inferred Customer identity; later optional association, exact verification/capabilities, consent/legal details, and Loyalty rules remain unresolved. |
| Feedback | `POST /branches/{id}/customer-feedback`, `POST /customer-feedback/{id}/triage`, `/resolutions`, `/reopenings` | State machine stable; retention `LEGAL_VALIDATION` |
| Printing | `POST /print-jobs`, `GET /print-jobs/{id}`, `POST /print-jobs/{id}/retries` | Stable and independent from Payment/Preparation; hardware `OPEN_DECISION` |
| Reporting | Owner Dashboard read models for daily/weekly/monthly/custom ranges and comparisons; daily Telegram delivery history/retries | Direction `OWNER_CONFIRMED`; exact metrics, cutoff, Branch scope, schedule, recipients, privacy, and failure escalation `UNRESOLVED`; no endpoint or Telegram implementation authorized |

## 12. Authorization and audit matrix

This matrix summarizes the endpoint tables; exact capability keys are `TECHNICAL_PROPOSAL`, while role/approval policy retains canonical provenance.

| Endpoint family | Owner | Branch Manager | Staff | Scope | Action | Owner approval | Audit |
|---|---|---|---|---|---|---|---|
| Sessions/self | Yes | Yes | Yes | Self/Organization | Read/create/revoke | No | Login/revoke yes |
| User invitations/role grants | Yes | No by default | No | Organization | Invite/deactivate/grant | Owner approval required; delegate may invite only | Yes |
| Branch assignments | Yes | Assigned Branch read/proposal only | No | Organization/Branch | Create/end | Owner approval required | Yes |
| Menu read | Yes | Yes | Yes | Effective Branch | Read | No | No ordinary read; sensitive access logs as needed |
| Catalog/price write | Yes | Policy-dependent | No | Brand/Branch | Create/update/publish | Price policy open | Yes |
| Draft Order/item | Yes | Yes | Authorized Staff | Branch | Create/update | No | Confirmation/cancel sensitive |
| Payment attempt/settlement | Yes | Yes | Payment capability | Branch | Create/read/reconcile | No ordinary payment; unknown reconciliation audited | Yes |
| Refund/cancel | Yes | Before preparation: Staff cancellation with reason; after start: Owner approval | Before preparation only | Branch | Request/approve/reverse | Owner after preparation starts; completed exception details unresolved | Always |
| Preparation | Yes | Yes | Preparation/service capability | Branch | Read/transition/remake | Remake details open | Deviations yes |
| Inventory movement/transfer | Yes | Threshold/scope | Capability-limited | Warehouse/Branch | Create/approve/dispatch/receive | Threshold open | Always |
| Cash Session/expense | Yes | Assigned-scope operational review; no invented approval authority | Cash capability/request within delegated limits | Drawer/Branch/operating day | Open/post/count/close/request | Owner for top-up and expense over delegated limits; no self-approval | Always |
| Scheduling/attendance | Yes | Assigned Branch | Own/read/clock | Branch | Create/publish/record/correct | Overtime Owner only | Corrections/decisions yes |
| Leave | Exception approval | Normal approval | Own request | Branch | Request/decide | Exceptions | Always decision |
| Payroll | Final review/close | Preliminary review | Own payslip | Organization/self | Calculate/review/close/pay | Close Owner only | Always |
| Approval decisions | Yes | Scope/policy | Request only unless policy | Subject scope | Approve/reject | Policy-specific | Always |
| Printing | Yes | Yes | Operational capability | Branch | Create/read/retry | No | Retry/outcome trace |

## 13. Critical transaction and integration boundaries

| Operation | Local transaction | External seam / retry / reconciliation |
|---|---|---|
| Initiate electronic payment | Validate balance; insert pending Attempt/idempotency intent; commit | Payment-provider port called after commit; timeout → unknown, not failure |
| Apply provider result | Verify unique signed event; lock Payment; record outcome; if fully settled insert unique Dispatch + outbox; commit | Replay returns original result; unknown reconciled through provider query adapter |
| Cash payment (future coordination) | Lock Payment and applicable open Cash Session under documented ordering; record successful Attempt, Cash Transaction, settlement, unique Dispatch/outbox/audit atomically | No external provider; printing after commit; ledger details require separate design |
| Preparation dispatch | Lock unique Dispatch; create/locate tickets/items; mark dispatched; commit | Outbox delivery/worker retries; attempt failure leaves Dispatch pending |
| Refund | Persist/validate approved intent; provider I/O outside transaction; apply verified result under Payment lock with revenue/loyalty/cash outbox | Provider query/replay; never edit charge |
| Stock post | Lock Position/Lots; insert Movement and update quantity/cost atomically | Physical movement outside; command retry uses source/idempotency key |
| Transfer dispatch/receipt | Separate locked transactions posting movements/in-transit/valuation | Physical transport between; partial receipt idempotent |
| Print | Commit Print Job | Printer adapter creates append-only Attempt; retry never repeats business action |
| Payroll close | Lock Period/Payrolls; freeze snapshots/Owner decision/outbox | PDF generation and payment tracking after commit |

External adapters are injected behind internal ports only where production and test adapters genuinely vary: payment provider and printer/PDF renderer. HTTP controllers do not contain provider-specific rules.

## 14. Open decisions and implementation impact

| Decision | Affected contracts/state | Owner decision required | Can implementation proceed? |
|---|---|---|---|
| Split/partial payment/check allocation | Payment attempts, settlement, refund, preparation eligibility | Whether allowed; amount/item/check allocation and rounding | Foundation yes; production payment endpoint only exact balance until approved |
| Completed-Order cancellation/refund/remake details | Refund requests, completed Order exceptions, Preparation deviations, inventory/loyalty | Outcomes, allocation, compensation, and completed exception process | Read/foundation yes; unresolved execution blocked |
| Cash drawer topology | Cash Session URLs and one-open-session rule | Number/identity of physical drawers/registers | Foundation model yes; production uniqueness blocked |
| Remaining approval thresholds/self-approval | Approval routes across price, stock, purchase, refund, and other unconfirmed domains | Threshold matrix and segregation outside confirmed cash/expense/cancellation rules | Generic request/decision yes; policy-specific execution blocked |
| Operating-day definition and cash representation | Cash Session, daily float, delegated-expense accumulation, reports | Cutoff/timezone boundary and physical/API representation | Documentation/model design only; implementation blocked |
| Reporting details | Owner Dashboard and daily Telegram report | Schedule, recipients, cutoff, formulas, Branch scope, privacy, and failure escalation | Read-model design can proceed; production delivery blocked |
| Transfer cost timing | Transfer receipt valuation | Cost snapshot at dispatch or receipt and rounding | Quantity flow yes; production valuation blocked |
| Customer Profile and association | Customer association/search/create | Approved policy requires Vietnam-only mobile validation, Organization-wide phone admission control, scoped non-disclosing visibility, controlled changes/anonymization, and no automatic merge; API and authorization contracts remain undesigned | SDP-CUST-19 permits Orders to be created and completed without a Customer Profile. Optional later Customer association, exact verification/capabilities, consent/legal detail, and replacement endpoint/error contracts remain unresolved; no Customer API implementation is authorized. |
| Payment provider | Attempt fields, webhook/reconciliation adapter | Provider/methods and authoritative result contract | Cash slice yes; electronic integration blocked |
| Offline operations | Idempotency lifetime, device auth, queued commands | Which commands may work offline | Online-authoritative API yes; offline queue blocked |
| Tax/accounting | Totals, invoices, payroll, payable/expense/report contracts | Current legal/accounting/provider obligations | Non-tax prototype/foundation only; production finance acceptance blocked |

## 15. Consistency validation

### Verified alignment

- One Order has one Payment settlement aggregate with many attempts/tenders.
- Full settlement creates one unique pending Preparation Dispatch; attempt failure does not change Payment.
- Order/Payment/Preparation/Print/Delivery states remain independent.
- Branch ownership and authorization derive from immutable root scope.
- Snapshot and effective-version fields required by the data model appear in resource representations/commands.
- Retryable commands expose idempotency and mutable aggregates expose optimistic versions.
- External providers/printers are explicitly outside local database transactions.

### Gaps carried forward, not silently solved

- `payment_allocations` and its contract remain absent until split/check policy is approved.
- Completed-Order exception outcomes and refund/remake orchestration remain policy-blocked; stage-specific cancellation authority is confirmed.
- Tax invoice endpoints are absent pending `LEGAL_VALIDATION`.
- Regional Manager and offline command APIs are absent pending explicit scope.
- Authentication credential method, identity policies, and deployment topology require Owner/security review; proposed session behavior is defined in [ADR-0006](adr/0006-authentication-session-topology.md).

### Prototype compatibility

The existing `/pos` interaction areas map to Menu queries, Draft Order commands, server pricing, Payment attempts, and status resources through future DTO/view-model adapters. `/upstairs-delivery` maps to the independent Delivery resource. No fixture status or client subtotal becomes authoritative.

## 16. Review gate

This contract is documentation only. Any future implementation requires explicit milestone authorization, accepted security/authorization prerequisites, resolution of the selected vertical slice's blockers, and contract/request tests. Identity Milestone 2B remains unauthorized.

