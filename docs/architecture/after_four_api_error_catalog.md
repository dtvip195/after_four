# AFTER FOUR API Error Catalog v1.0

**Status:** Stable logical error contract for review; no implementation is authorized  
**Date:** 2026-11-14  
**Sources:** [Owner Decision Baseline](after_four_owner_decision_baseline.md) · [DDD Foundation](after_four_ddd_foundation.md) · [API Contract](after_four_api_contract.md) · [State Machines](after_four_state_machines.md) · [Data Integrity Rules](after_four_data_integrity_rules.md) · [Payment Model](after_four_payment_model.md) · [API ADR](adr/0009-api-conventions-versioning.md)

## 1. Error contract

Clients branch on `error.code`, never message text. Codes remain stable within `/api/v1`; messages may improve without a breaking version change.

Unless a row protects a labeled business invariant, error names, HTTP mappings, retry metadata, and envelope mechanics are `TECHNICAL_PROPOSAL`. The `OWNER_CONFIRMED` full-payment-before-preparation rule is represented by `payment_not_fully_settled`, safe unknown-payment errors, and the separation of dispatch failure from payment failure. Codes ending in `_policy_unresolved` deliberately surface an `OPEN_DECISION`; they do not choose a business default.

```json
{
  "error": {
    "code": "validation_failed",
    "message": "Một số dữ liệu chưa hợp lệ.",
    "request_id": "req_01...",
    "retryable": false,
    "details": {},
    "field_errors": [
      {
        "path": "/items/0/quantity",
        "code": "must_be_positive",
        "message": "Số lượng phải lớn hơn 0."
      }
    ]
  }
}
```

### Required fields

| Field | Rule |
|---|---|
| `code` | Stable snake-case machine code from this catalog. |
| `message` | Safe user-facing Vietnamese message; no branching contract. |
| `request_id` | Server correlation ID returned in headers and body. |
| `retryable` | Whether retrying later without changing business input may be safe. It does not override idempotency/reconciliation rules. |
| `details` | Optional allowlisted structured metadata; no stack/SQL/provider secrets. |
| `field_errors` | Present for field validation; JSON Pointer-like `path`, stable field code, safe message. |

Unknown internal errors use `internal_error` with a generic message and request ID. They never expose exception class, stack trace, SQL, environment, credentials, raw webhook payload, card/bank data, or private staff/customer data.

## 2. HTTP status policy

| HTTP | Meaning in this interface |
|---|---|
| `400` | Malformed JSON/query/header or unsupported command shape. |
| `401` | Missing/expired/invalid authentication. |
| `403` | Authenticated but explicitly forbidden; do not use if it leaks hidden resource existence. |
| `404` | Resource absent or deliberately hidden outside authorized scope. |
| `405` | Method not supported for resource. |
| `406` / `415` | Unsupported response/request media type. |
| `409` | Lifecycle, version, uniqueness, idempotency, overlap, or concurrent business conflict. |
| `412` | Required `If-Match` precondition failed; this contract normally maps to stable `concurrent_modification`. |
| `422` | Well-formed request that violates field/domain validation without concurrency conflict. |
| `423` | Optional for explicitly locked/closed operational period; v1 normally uses `409 closed_period`. |
| `429` | Rate limited. |
| `502` | Invalid/unusable upstream response. |
| `503` | Dependency temporarily unavailable or service not ready. |
| `504` | Upstream timeout; payment outcome may be unknown, not failed. |
| `500` | Unexpected internal failure. |

## 3. Authentication, authorization, and scope

| HTTP | Code | Retryable | Safe message | Notes/details |
|---:|---|:---:|---|---|
| 401 | `authentication_required` | No | Phiên đăng nhập không hợp lệ hoặc đã hết hạn. | Client may reauthenticate; original unsafe command must keep its idempotency key. |
| 401 | `invalid_credentials` | No | Thông tin đăng nhập không đúng. | Never identify which credential failed. |
| 403 | `account_inactive` | No | Tài khoản hiện không hoạt động. | No internal deactivation reason unless authorized. |
| 409 | `identity_policy_unresolved` | No | Chính sách tài khoản chưa hoàn tất. | Blocks a command whose required technical control, reviewed procedure, infrastructure choice, or legal/privacy rule is not ready. Owner decisions ID-01–ID-34 retain the scope recorded in the Identity Decision Register and do not make an unreviewed command ready. |
| 403 | `forbidden` | No | Bạn không có quyền thực hiện thao tác này. | Required capability may be included only if safe. |
| 403 | `branch_scope_violation` | No | Bạn không có quyền truy cập chi nhánh này. | Use only when target Branch is already safe to reveal. |
| 403 | `warehouse_scope_violation` | No | Bạn không có quyền truy cập kho này. | Same information-disclosure rule. |
| 403 | `self_approval_forbidden` | No | Thao tác này cần người phê duyệt khác. | Policy version may be returned. |
| 409 | `assignment_not_effective` | No | Phân công tại chi nhánh không còn hiệu lực. | Effective interval metadata if safe. |
| 429 | `rate_limited` | Yes | Có quá nhiều yêu cầu. Vui lòng thử lại sau. | `Retry-After` required. |

## 4. General request and resource errors

| HTTP | Code | Retryable | Safe message | Details |
|---:|---|:---:|---|---|
| 400 | `malformed_request` | No | Yêu cầu không đúng định dạng. | Safe syntax location only. |
| 400 | `invalid_filter` | No | Bộ lọc không được hỗ trợ. | Allowed filter names. |
| 400 | `invalid_sort` | No | Cách sắp xếp không được hỗ trợ. | Allowed sort names. |
| 400 | `invalid_cursor` | No | Vị trí phân trang không hợp lệ. | No cursor internals. |
| 404 | `resource_not_found` | No | Không tìm thấy dữ liệu yêu cầu. | Also hides cross-scope existence. |
| 409 | `duplicate_resource` | No | Dữ liệu này đã tồn tại. | Safe conflicting field/code. |
| 409 | `duplicate_request` | No | Yêu cầu này đã được xử lý. | Prefer returning original result for identical idempotent replay. |
| 409 | `idempotency_conflict` | No | Mã chống trùng đã được dùng cho nội dung khác. | Existing key/scope, never original sensitive payload. |
| 409 | `concurrent_modification` | Yes | Dữ liệu đã được cập nhật trên thiết bị khác. | `current_version`; client must refetch/reconcile, not blind retry. |
| 409 | `invalid_state_transition` | No | Thao tác không phù hợp với trạng thái hiện tại. | `current_state`, safe `allowed_actions`. |
| 422 | `validation_failed` | No | Một số dữ liệu chưa hợp lệ. | `field_errors` required. |
| 422 | `effective_period_overlap` | No | Khoảng thời gian hiệu lực bị chồng lấn. | Conflicting interval/record if authorized. |
| 409 | `closed_period` | No | Kỳ đã đóng và không thể chỉnh sửa trực tiếp. | Adjustment command link if permitted. |
| 403 | `approval_required` | No | Thao tác này cần được phê duyệt. | Approval Request link/policy key when created. |
| 409 | `approval_policy_unresolved` | No | Chính sách phê duyệt chưa được cấu hình. | Operational configuration issue. |
| 503 | `service_unavailable` | Yes | Dịch vụ tạm thời chưa sẵn sàng. | `Retry-After` when known. |
| 500 | `internal_error` | Maybe | Đã xảy ra lỗi hệ thống. | `retryable` chosen by failure class; request ID only. |

## 5. Catalog, pricing, customer, and promotion

| HTTP | Code | Retryable | Safe message | Meaning |
|---:|---|:---:|---|---|
| 409 | `price_version_conflict` | No | Giá đã thay đổi. Vui lòng kiểm tra lại đơn. | Authoritative Price differs from the Draft quote; return safe revised-quote/version information and require review before confirmation (`ODB-CAT-09`). Exact acceptance protocol remains technical design. |
| 409 | `recipe_version_conflict` | No | Công thức hiệu lực đã thay đổi. | Preparation/config publication conflict. |
| 422 | `product_unavailable` | No | Sản phẩm hiện không khả dụng tại chi nhánh. | Variant/Branch availability. |
| 422 | `modifier_selection_invalid` | No | Lựa chọn tùy chọn sản phẩm chưa hợp lệ. | Min/max/allowed modifier field errors. |
| 422 | `promotion_not_eligible` | No | Đơn hàng không đủ điều kiện áp dụng ưu đãi. | Safe failed rule code, not internal expression. |
| 409 | `promotion_policy_unresolved` | No | Chính sách kết hợp ưu đãi chưa được xác nhận. | Blocks ambiguous stacking. |
| 422 | `customer_consent_required` | No | Cần sự đồng ý của khách hàng trước khi lưu thông tin. | Consent type/policy version. |
| 409 | `customer_merge_required` | No | Hồ sơ khách hàng cần được đối chiếu. | No other customer's private details. |

## 6. Order and preparation

| HTTP | Code | Retryable | Safe message | Meaning |
|---:|---|:---:|---|---|
| 409 | `order_not_editable` | No | Đơn không còn ở trạng thái có thể chỉnh sửa. | Only Draft items are directly editable. |
| 422 | `empty_order` | No | Đơn cần có ít nhất một sản phẩm. | Confirmation guard. |
| 409 | `order_not_payable` | No | Đơn chưa sẵn sàng để thanh toán. | Not Confirmed/cancelled/closed/etc. |
| 409 | `order_not_dispatchable` | No | Đơn đã hết hạn, bị tạm giữ hoặc không thể chuyển sang pha chế. | Dispatch requires a Confirmed Order strictly inside its payment window. |
| 409 | `invalid_table_session` | No | Phiên bàn không hợp lệ cho đơn này. | Branch/session guard. |
| 409 | `cancellation_policy_unresolved` | No | Quy trình ngoại lệ hủy cho trường hợp này chưa hoàn tất. | Used only for completed-Order or compensation details that remain unresolved. Before preparation starts Staff may cancel with reason/audit; after preparation starts Owner approval is required. |
| 404 | `preparation_not_dispatched` | No | Đơn chưa được chuyển sang khu vực pha chế. | No Dispatch exists. |
| 409 | `payment_not_fully_settled` | No | Đơn chưa được thanh toán đầy đủ. | Dispatch requires `funding_status=fully_paid` and `attempt_activity=idle` (`OWNER_CONFIRMED` boundary). |
| 409 | `dispatch_already_completed` | No | Đơn đã được chuyển sang pha chế. | Idempotent replay should return original ticket instead where same key. |
| 503 | `preparation_dispatch_failed` | Yes | Đã thanh toán nhưng chưa chuyển được sang pha chế. Hệ thống sẽ cho phép thử lại. | Payment remains successful; Dispatch link/state required. |
| 409 | `preparation_items_incomplete` | No | Vẫn còn sản phẩm chưa hoàn tất. | Ticket completion guard. |
| 422 | `quantity_exceeds_available` | No | Số lượng thao tác vượt quá số lượng còn lại. | Preparation allocation guard. |
| 409 | `remake_policy_unresolved` | No | Chính sách làm lại món chưa được xác nhận. | Blocks ambiguous cost/refund effects. |

## 7. Payment and refund

| HTTP | Code | Retryable | Safe message | Meaning / client action |
|---:|---|:---:|---|---|
| 422 | `payment_amount_invalid` | No | Số tiền thanh toán không khớp số tiền cần thu. | The implemented Phase 1 settlement path requires the exact unpaid target; mismatch or excess cannot dispatch. Observed excess requires evidence and refund but its future representation/lifecycle remains unresolved. `partially_paid` cannot be reached by command until split policy is approved. |
| 402 | `payment_failed` | No | Thanh toán không thành công. | Authoritative failure; new attempt may be allowed with new key. |
| 409 | `payment_result_unknown` | No | Chưa xác định được kết quả thanh toán. Không thanh toán lại lúc này. | Reconcile before retry; deliberately not marked retryable. |
| 503 | `payment_reconciliation_unavailable` | Yes | Chưa thể đối chiếu kết quả thanh toán. | Retry reconciliation with same key, not a new charge. |
| 503 | `payment_provider_unavailable` | Yes | Dịch vụ thanh toán tạm thời không khả dụng. | If request may have reached provider, Attempt becomes Unknown. |
| 504 | `payment_provider_timeout` | No | Chưa nhận được kết quả thanh toán. | Maps to Unknown; retryable=false for charge command. |
| 502 | `payment_provider_invalid_response` | No | Không thể xác nhận kết quả thanh toán. | Maps to Unknown until reconciliation. |
| 401 | `provider_signature_invalid` | No | Không thể xác thực thông báo thanh toán. | Provider endpoint only; no sensitive detail. |
| 409 | `payment_already_fully_settled` | No | Đơn đã được thanh toán đầy đủ. | Prevent duplicate charge. |
| 409 | `refund_not_approved` | No | Hoàn tiền chưa được phê duyệt. | Approval guard. |
| 422 | `refund_amount_exceeds_available` | No | Số tiền hoàn vượt quá số tiền có thể hoàn. | Under-lock cumulative guard. |
| 409 | `refund_policy_unresolved` | No | Chính sách hoàn tiền chưa được xác nhận. | Blocks ambiguous refund. |
| 503 | `external_provider_unavailable` | Yes | Dịch vụ bên ngoài tạm thời không khả dụng. | Generic non-payment provider only. |

HTTP `402` is used only for an authoritative business payment decline/failure. Transport/provider unavailability remains `503/504`; unknown result remains a `409` domain conflict on subsequent unsafe action.

## 8. Inventory and procurement

| HTTP | Code | Retryable | Safe message | Meaning |
|---:|---|:---:|---|---|
| 409 | `insufficient_stock` | No | Số lượng tồn khả dụng không đủ. | Includes safe available/requested quantities. |
| 409 | `lot_not_available` | No | Lô hàng không khả dụng để xuất. | Quarantined/rejected/expired/depleted. |
| 409 | `stock_version_conflict` | Yes | Tồn kho vừa thay đổi. Vui lòng tải lại. | Concurrency; refetch before retry. |
| 409 | `transfer_not_approved` | No | Phiếu chuyển kho chưa được phê duyệt. | Dispatch guard. |
| 409 | `transfer_over_receipt` | No | Số lượng nhận vượt quá số lượng đang vận chuyển. | Cumulative receipt guard. |
| 409 | `transfer_cost_policy_unresolved` | No | Chính sách giá vốn chuyển kho chưa được xác nhận. | Production valuation blocker. |
| 409 | `stocktake_already_open` | No | Kho đang có đợt kiểm kê chưa hoàn tất. | Scope policy. |
| 409 | `stocktake_closed` | No | Đợt kiểm kê đã đóng. | Use adjustment flow. |
| 422 | `purchase_order_mismatch` | No | Dữ liệu nhận hàng không khớp đơn mua. | Quantity/item/supplier/currency. |
| 409 | `purchase_order_not_approved` | No | Đơn mua chưa được phê duyệt. | Sending/receiving guard. |
| 409 | `supplier_inactive` | No | Nhà cung cấp hiện không hoạt động. | Master-data guard. |

## 9. Cash, HR, and payroll

| HTTP | Code | Retryable | Safe message | Meaning |
|---:|---|:---:|---|---|
| 409 | `cash_session_already_open` | No | Ngăn kéo tiền đã có phiên đang mở. | Drawer uniqueness. |
| 409 | `cash_session_not_open` | No | Phiên tiền mặt không ở trạng thái mở. | Ordinary transaction guard. |
| 422 | `cash_opening_insufficient` | No | Số tiền mở ca không đủ so với tiền mặt phải bàn giao. | Opening-count/sufficiency evidence; does not automatically replenish the daily float. Exact calculation awaits Cash design. |
| 422 | `cash_discrepancy_reason_required` | No | Cần ghi rõ lý do chênh lệch tiền mặt. | Close guard. |
| 409 | `cash_session_unresolved_discrepancy` | No | Chênh lệch tiền mặt chưa được xử lý đầy đủ. | Notification/reason/approval guard. |
| 409 | `closed_session_direct_edit` | No | Phiên tiền mặt đã đóng; hãy dùng giao dịch điều chỉnh. | Immutable close. |
| 409 | `employee_not_assigned` | No | Nhân viên không có phân công hiệu lực tại chi nhánh. | Branch/shift/attendance guard. |
| 409 | `shift_overlap` | No | Ca làm việc bị trùng thời gian. | Exact overlap policy open. |
| 409 | `shift_swap_policy_unresolved` | No | Chính sách đổi ca chưa được xác nhận. | Blocks execution. |
| 409 | `attendance_already_open` | No | Nhân viên đang có lượt chấm công chưa kết thúc. | Clock-in guard. |
| 409 | `attendance_not_open` | No | Không có lượt chấm công đang mở. | Clock-out guard. |
| 409 | `leave_policy_unresolved` | No | Chính sách nghỉ phép chưa được xác nhận đầy đủ. | Leave calculation blocker. |
| 409 | `payroll_period_overlap` | No | Kỳ lương bị trùng với kỳ hiện có. | Organization/date uniqueness. |
| 422 | `payroll_inputs_incomplete` | No | Dữ liệu tính lương chưa đầy đủ hoặc chưa được duyệt. | Safe missing category list. |
| 409 | `payroll_review_incomplete` | No | Bước rà soát bảng lương chưa hoàn tất. | Transition guard. |
| 409 | `payroll_not_closed` | No | Bảng lương chưa được chốt. | Payment/payslip guard. |
| 404 | `payslip_not_ready` | Yes | Phiếu lương chưa sẵn sàng. | PDF generation may be pending; `Retry-After` optional. |

## 10. Printing, reservation, and feedback

| HTTP | Code | Retryable | Safe message | Meaning |
|---:|---|:---:|---|---|
| 503 | `printer_unavailable` | Yes | Máy in tạm thời không khả dụng. | Payment/Preparation remain unchanged. |
| 503 | `print_failed` | Yes | Chưa in được tài liệu. Có thể thử lại. | Existing Print Job retained. |
| 409 | `print_job_already_completed` | No | Tài liệu đã được in. | Same-key replay should return original Job. |
| 409 | `reservation_conflict` | No | Thời gian hoặc bàn đã có xung đột. | Capacity policy may be open. |
| 409 | `reservation_policy_unresolved` | No | Chính sách đặt bàn chưa được xác nhận. | Deposits/overbooking/etc. |
| 422 | `feedback_resolution_required` | No | Cần ghi rõ nội dung xử lý phản hồi. | Resolve guard. |

## 11. Validation field-code catalog

Field error codes are reusable, stable, and narrower than top-level `validation_failed`:

| Code | Meaning |
|---|---|
| `required` | Missing required field. |
| `invalid_format` | Wrong syntax/format. |
| `invalid_value` | Value outside allowed vocabulary. |
| `must_be_positive` | Numeric value must be greater than zero. |
| `must_be_nonnegative` | Numeric value cannot be negative. |
| `out_of_range` | Outside permitted range. |
| `too_long` | Exceeds maximum length. |
| `invalid_currency` | Currency unsupported or inconsistent. |
| `invalid_quantity_precision` | Too many decimal places for Unit. |
| `invalid_time_range` | End not after start or invalid effective interval. |
| `not_unique` | Business identifier already used. |
| `not_allowed_for_state` | Field cannot change in current state. |
| `inconsistent_scope` | Related IDs do not share required Organization/Branch. |

## 12. Retry and operator guidance

| Error class | Client behavior |
|---|---|
| Validation/forbidden/not found | Correct input/authority; do not automatic retry. |
| Concurrent modification | Refetch current aggregate; reconcile operator intent; submit with new version/key if still valid. |
| Identical idempotent replay | Accept returned original result. |
| Provider unavailable before accepted intent | Retry command with same key when advised. |
| Payment timeout/unknown | Do not create another charge; poll/reconcile existing Attempt. |
| Dispatch/print failure | Keep successful Payment; retry same Dispatch/Print Job identity. |
| Serialization/deadlock hidden by server | Server may bounded-retry whole local transaction; client receives retryable conflict only if exhausted. |
| Rate limit/service unavailable | Honor `Retry-After`; preserve idempotency key for same intent. |

## 13. Logging and redaction

Log error code, request ID, authenticated User ID, Device/session ID, safe resource IDs, Branch scope, HTTP status, duration, and safe dependency category. Never log credentials, session cookies/tokens, CSRF secrets, raw payment-provider payloads/signatures, full bank/payment details, payslip contents, unnecessary phone numbers, or stack traces to clients.

Provider-facing errors may use a minimal provider-required status body while internal logs retain the mapped stable code. Audit Logs contain business actions/reasons, not debugging payload dumps.

## 14. Consistency and versioning

- Every state-machine forbidden transition maps to `invalid_state_transition` or a more specific stable code above.
- Full-payment dispatch guards map to `payment_not_fully_settled`; dispatch transport failure maps to `preparation_dispatch_failed`, never `payment_failed`.
- Unknown payment is deliberately non-retryable for a new charge and directs reconciliation.
- Closed Cash/Payroll direct mutation maps to `closed_session_direct_edit`/`closed_period`.
- Adding a new code is backward-compatible. Removing/renaming a code or changing its semantic class requires a versioned compatibility plan.
- HTTP status may only change without versioning if clients are documented to rely solely on code and the semantic retry/security class remains identical; otherwise treat it as breaking.

## 15. Review gate

Before activating any related endpoint, create request/contract tests asserting envelope shape, status/code mapping, redaction, idempotent replay, cross-Branch non-disclosure, optimistic-lock conflict, payment unknown reconciliation, paid-but-undispatched recovery, and external failure isolation. This document does not authorize implementation; Identity Milestone 2B remains unauthorized.

