# AFTER FOUR — Real Menu & Pricing Specification

**Document status:** `OWNER_INPUT_DRAFT`
**Purpose:** Thu thập menu và quy tắc kinh doanh thực tế làm đầu vào cho Catalog/Pricing MVP.
**Implementation authorization:** Không

> Nguyên tắc: Ghi nhận đúng cách AFTER FOUR dự định kinh doanh. Không tự giả định sản phẩm, giá, thuế, phí hoặc quy tắc vận hành. Giá trị trống hoặc `TBD` không phải là quyết định đã được phê duyệt.

Tài liệu này áp dụng các quyết định Catalog/Pricing và Catalog Core `ODB-CAT-01` đến `ODB-CAT-26` theo đúng phạm vi riêng của từng quyết định trong [Owner Decision Baseline §5](after_four_owner_decision_baseline.md#5-catalogpricing-mvp). Nó thu thập dữ liệu còn thiếu cho menu baseline đã được Owner xác nhận theo reference; không biến tên/option baseline thành canonical record, code, Variant applicability hoặc Price chưa được duyệt.

[Proposed Launch Menu v3](after_four_proposed_launch_menu_v3.md) supplies the draft launch-menu baseline approved by reference under `CORE-OD-01`. Its 28 named Product rows, six menu groupings and presented option lists are accepted as baseline input; exact Product/Category/Variant records and codes, final Variant applicability/capacity, and exact individual Prices remain missing or unresolved. `ODB-CAT-11` through `ODB-CAT-13` continue to govern target scale, selective size policy and Signature designations within their exact scopes.

## 1. Branch và phạm vi menu

| Thông tin | Giá trị |
|---|---|
| Thương hiệu | AFTER FOUR |
| Branch khai trương | Main Branch |
| Số Branch ban đầu | 1 |
| Product identity dùng chung toàn Brand? | Có — `ODB-CAT-01` |
| Effective menu có giống nhau giữa mọi Branch? | Chờ Owner xác nhận khi có thêm Branch; Branch availability override đã được hỗ trợ theo `ODB-CAT-06` |
| Có hỗ trợ giá riêng theo Branch? | Có — `ODB-CAT-07`; chưa cần tạo Main Branch override nếu không sử dụng |

“Effective menu” ở đây là tập Variant thực tế có thể bán tại một Branch. Nó không tạo Product identity riêng cho Branch.

## 2. Danh sách Category

Điền danh sách nhóm sản phẩm dự kiến. Category là phẳng trong MVP theo `ODB-CAT-02`.

| Category code | Tên Category | Mô tả | Thứ tự hiển thị |
|---|---|---|---:|
| CAT-001 |  |  | 1 |
| CAT-002 |  |  | 2 |
| CAT-003 |  |  | 3 |
| CAT-004 |  |  | 4 |
| CAT-005 |  |  | 5 |

## 3. Danh sách Product

Mỗi Product là một sản phẩm kinh doanh Brand-global, không phải từng size hoặc lựa chọn thêm.

| Product code | Tên sản phẩm | Category | Mô tả | Trạng thái |
|---|---|---|---|---|
| PRD-001 |  |  |  | Draft |
| PRD-002 |  |  |  | Draft |
| PRD-003 |  |  |  | Draft |

Trạng thái hợp lệ theo `ODB-CAT-03`: Draft / Active / Inactive / Archived.

## 4. Variant và giá cơ bản

Mỗi sản phẩm cần ít nhất một Variant có thể bán. Nếu khách không cần chọn Variant, sử dụng Variant mặc định ẩn theo `ODB-CAT-04`.

| Product code | Variant code | Tên hiển thị | SKU | Variant mặc định ẩn? | Giá mặc định chuỗi (VND) |
|---|---|---|---|---|---:|
| PRD-001 | VAR-001 |  |  |  |  |
| PRD-001 | VAR-002 |  |  |  |  |
| PRD-002 | VAR-003 |  |  |  |  |

Ví dụ minh họa: Latte có Variant 350 ml và 500 ml. Đây chỉ là ví dụ, không phải menu đã được Owner xác nhận.

## 5. Modifier Groups

Ghi nhận các nhóm lựa chọn khách có thể chọn khi gọi món. Cấu trúc required/optional, single/multiple và giới hạn Min/Max đã được xác nhận bởi `ODB-CAT-05`; các Group thực tế vẫn chờ dữ liệu menu.

| Group code | Product/Variant áp dụng | Tên nhóm | Bắt buộc? | Min | Max |
|---|---|---|---|---:|---:|
| MOD-G01 |  |  |  |  |  |
| MOD-G02 |  |  |  |  |  |

Ví dụ chưa được Owner xác nhận:

- Chọn loại sữa.
- Chọn lượng đường.
- Chọn lượng đá.
- Topping.

## 6. Modifier Options và giá phát sinh

| Group code | Option code | Tên lựa chọn | Giá phát sinh (VND) | Giới hạn số lượng |
|---|---|---|---:|---:|
| MOD-G01 | MOD-001 |  |  |  |
| MOD-G01 | MOD-002 |  |  |  |
| MOD-G02 | MOD-003 |  |  |  |

Nếu chưa biết giá, ghi `TBD`, không tự điền `0`. Việc Modifier có ảnh hưởng đến giá hay không vẫn là quyết định chưa được xác nhận, đang chờ menu và yêu cầu pricing thực tế.

## 7. Quy tắc giá theo Branch

Hiện tại chỉ có Main Branch trong kế hoạch khai trương. Giá mặc định chuỗi và khả năng Branch override đã được xác nhận bởi `ODB-CAT-07`; bảng này chỉ thu thập giá thực tế.

| Product/Variant | Giá mặc định chuỗi | Main Branch override | Lý do |
|---|---:|---:|---|
|  |  |  |  |
|  |  |  |  |

Nếu giá Main Branch giống giá mặc định, để trống override. Mỗi giá được xuất bản sau này phải là một Price Version bất biến, có thời gian hiệu lực theo `ODB-CAT-08`.

## 8. Availability và tình trạng bán

| Product/Variant | Chain default | Main Branch override | Có thể tạm ngừng bán? | Có lịch bán theo khung giờ? |
|---|---|---|---|---|
|  | Available / Unavailable | Inherit / Available / Unavailable |  |  |
|  | Available / Unavailable | Inherit / Available / Unavailable |  |  |

Main Branch chỉ cần override khi khác chain default (`ODB-CAT-06`). Cần Owner input cho các câu hỏi còn mở:

- Hết nguyên liệu thì ai quyết định tạm ngừng bán?
- Ai có quyền bật lại sản phẩm?
- Có sản phẩm chỉ bán theo mùa hoặc theo khung giờ không?

## 9. Quy tắc vận hành đặc biệt

| Chủ đề | Owner input |
|---|---|
| Có sản phẩm miễn phí không? | TBD |
| Có giảm giá thủ công không? | TBD |
| Có cho phép nhân viên sửa giá không? | TBD |
| Có sản phẩm bán theo combo không? | TBD |
| Có sản phẩm bán theo số lượng giới hạn không? | TBD |
| Có sản phẩm thay đổi giá theo thời điểm không? | TBD |

## 10. Các quyết định tài chính còn mở

Không điền theo suy đoán kỹ thuật. Cần Owner quyết định và xác minh nghiệp vụ/pháp lý/kế toán phù hợp.

| Chủ đề | Trạng thái |
|---|---|
| Giá đã bao gồm thuế hay chưa | TBD |
| Tax treatment | TBD |
| Service charge | TBD |
| Monetary rounding | TBD |
| Complimentary / zero-price items | TBD |
| Modifier price history | TBD |

## 11. Quy tắc xác nhận

- Giá được xác thực từ server, không tin giá do Frontend gửi lên.
- Nếu giá Draft thay đổi trước khi xác nhận, nhân viên phải xem lại báo giá mới (`ODB-CAT-09`).
- Sold Price được khóa khi Order được xác nhận (`ODB-CAT-10`).
- Thay đổi Catalog không làm thay đổi Order đã xác nhận.
- Payment target phải dựa trên confirmed authoritative Order total.
- Việc thay đổi thời điểm tạo Payment vẫn cần thiết kế và phê duyệt riêng.

## 12. Owner approval log

| Nội dung | Trạng thái |
|---|---|
| Real menu | `OWNER_CONFIRMED_BY_REFERENCE` — Proposed Launch Menu v3 supplies the 28 named Product rows and presented options under `CORE-OD-01`; exact persisted records/codes and individual Price mapping remain unresolved |
| Launch menu target | `OWNER_CONFIRMED` — 28 Products (`ODB-CAT-11`) |
| Size policy | `OWNER_CONFIRMED` — S/M/L chỉ cho Product phù hợp (`ODB-CAT-12`) |
| Signature Products | `OWNER_CONFIRMED` — Bơ xay dừa non, Trà đào cam sả, Cà phê muối (`ODB-CAT-13`) |
| Variant policy | `OWNER_CONFIRMED` — `ODB-CAT-04` |
| Variant data thực tế | Baseline option labels đã được xác nhận theo reference; exact persisted Variant records, applicability/capacity và codes còn thiếu |
| Modifier Group policy | `OWNER_CONFIRMED` — `ODB-CAT-05` |
| Modifier data thực tế | Baseline option lists đã được xác nhận theo reference; applicability, cardinality, quantity limits và pricing còn thiếu |
| Pricing direction | `OWNER_CONFIRMED_BY_REFERENCE` — approximately VND 23,000 / 33,000 / 43,000–49,000; no individual Product/Variant mapping is recorded |
| Exact base Prices | Evidence gap — no exact Product/Variant Price dataset is present in the repository |
| Modifier prices / price effect | Chờ Owner quyết định và cung cấp |
| Main Branch price overrides thực tế | Chờ Owner xác nhận nếu sử dụng |
| Tax / Service Charge / Rounding | Chưa quyết định |

**Lưu ý:** Hoàn thành tài liệu này không đồng nghĩa với việc cho phép triển khai Catalog/Pricing. Mọi implementation vẫn cần bước review và authorization riêng.

## 13. Canonical references

- [Owner Decision Baseline §5](after_four_owner_decision_baseline.md#5-catalogpricing-mvp)
- [Catalog/Pricing Discovery and Decision Closure](after_four_catalog_pricing_discovery.md)
- [DDD Foundation §3.2](after_four_ddd_foundation.md#32-catalogpricing)
- [Business Domain Model §7](after_four_business_domain_model.md#7-catalog-prices-recipes-and-historical-snapshots)
- [Proposed Launch Menu v3](after_four_proposed_launch_menu_v3.md)
