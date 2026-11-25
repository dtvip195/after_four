# AFTER FOUR — Real Menu & Pricing Specification

**Document status:** `OWNER_CONFIRMED_COSTING_BASELINE_V1 — COST_INPUT_COLLECTION_OPEN`
**Purpose:** Thu thập menu và quy tắc kinh doanh thực tế làm đầu vào cho Catalog/Pricing MVP.
**Implementation authorization:** Không

> Nguyên tắc: Ghi nhận đúng cách AFTER FOUR dự định kinh doanh. Không tự giả định sản phẩm, giá, thuế, phí hoặc quy tắc vận hành. Giá trị trống hoặc `TBD` không phải là quyết định đã được phê duyệt.

Tài liệu này áp dụng các quyết định Catalog/Pricing và Catalog Core `ODB-CAT-01` đến `ODB-CAT-26` theo đúng phạm vi riêng của từng quyết định trong [Owner Decision Baseline §5](after_four_owner_decision_baseline.md#5-catalogpricing-mvp). Nó thu thập dữ liệu còn thiếu cho menu baseline đã được Owner xác nhận theo reference; không biến tên/option baseline thành canonical record, code, Variant applicability hoặc Price chưa được duyệt.

[Proposed Launch Menu v3](after_four_proposed_launch_menu_v3.md) supplies the draft launch-menu baseline approved by reference under `CORE-OD-01`. Commercial Baseline V1 subsequently resolves the costing combinations and exact proposed VND selling-price inputs listed in §4 under `CORE-OD-18`. Exact canonical Product/Category/Variant records and codes, physical capacities, Recipes, costs, margins, publication and implementation remain missing, unresolved or separately governed. `ODB-CAT-11` through `ODB-CAT-13` continue to govern target scale, selective size policy and Signature designations within their exact scopes.

## 1. Branch và phạm vi menu

| Thông tin | Giá trị |
|---|---|
| Thương hiệu | AFTER FOUR |
| Branch khai trương | Main Branch |
| Số Branch ban đầu | 1 |
| Product identity dùng chung toàn Brand? | Có — `ODB-CAT-01` |
| Effective menu có giống nhau giữa mọi Branch? | Chờ Owner xác nhận khi có thêm Branch; Branch availability override đã được hỗ trợ theo `ODB-CAT-06` |
| Phạm vi Commercial Baseline V1 | First Branch; first Price Version; dine-in và takeaway dùng cùng proposed price |
| Chain default / Branch override trong V1 | Không áp dụng; Owner xác nhận Commercial V1 không dùng chain default hoặc Branch override |

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
| TBD |  |  |  | Draft |
| TBD |  |  |  | Draft |
| TBD |  |  |  | Draft |

Trạng thái hợp lệ theo `ODB-CAT-03`: Draft / Active / Inactive / Archived.

## 4. Commercial Baseline V1 for cost calculation

Owner confirmed this costing baseline on 2026-11-24 under `CORE-OD-18`. Prices are VND. `Một cỡ` is one priced costing Variant; any hot/iced preparation choice for that Product is not a separate priced Variant. All rows apply to both dine-in and takeaway at the same proposed price and to the first Branch's first Price Version.

`Product code` and `Variant code` are business identifiers, not UUID primary keys. No canonical V1 business-code values have been assigned. `TBD` therefore preserves the required fields without inventing codes. For S/M/L rows, the three Variant-code positions map in order to S, M and L and remain independently `TBD`.

| Product code | Product | Variant code | Approved costing Variant | Proposed V1 selling price (VND) |
|---|---|---|---|---:|
| TBD | Cà phê đen | TBD | Một cỡ | 23,000 |
| TBD | Cà phê sữa | TBD | Một cỡ | 29,000 |
| TBD | Bạc xỉu | TBD | Một cỡ | 33,000 |
| TBD | Cà phê muối | TBD | Một cỡ | 43,000 |
| TBD | Cà phê dừa | TBD | Một cỡ | 43,000 |
| TBD | Latte | TBD | Một cỡ | 43,000 |
| TBD | Trà đào cam sả | TBD / TBD / TBD | S / M / L | 33,000 / 39,000 / 45,000 |
| TBD | Trà vải | TBD / TBD / TBD | S / M / L | 33,000 / 39,000 / 45,000 |
| TBD | Trà chanh | TBD / TBD / TBD | S / M / L | 29,000 / 35,000 / 39,000 |
| TBD | Trà tắc mật ong | TBD / TBD / TBD | S / M / L | 29,000 / 35,000 / 39,000 |
| TBD | Trà chanh dây | TBD / TBD / TBD | S / M / L | 33,000 / 39,000 / 45,000 |
| TBD | Nước chanh | TBD / TBD / TBD | S / M / L | 29,000 / 35,000 / 39,000 |
| TBD | Chanh dây đá | TBD / TBD / TBD | S / M / L | 33,000 / 39,000 / 45,000 |
| TBD | Cam ép | TBD / TBD / TBD | S / M / L | 39,000 / 45,000 / 49,000 |
| TBD | Soda chanh | TBD / TBD / TBD | S / M / L | 29,000 / 35,000 / 39,000 |
| TBD | Bơ xay dừa non | TBD / TBD / TBD | S / M / L | 43,000 / 46,000 / 49,000 |
| TBD | Sinh tố xoài | TBD / TBD / TBD | S / M / L | 39,000 / 45,000 / 49,000 |
| TBD | Sinh tố dâu | TBD / TBD / TBD | S / M / L | 43,000 / 46,000 / 49,000 |
| TBD | Cà phê dừa đá xay | TBD | Một cỡ | 49,000 |
| TBD | Matcha latte | TBD | Một cỡ | 43,000 |
| TBD | Cacao sữa | TBD | Một cỡ | 39,000 |
| TBD | Sữa chua trái cây | TBD | Một cỡ | 43,000 |
| TBD | Bánh croissant | TBD | Một phần | 33,000 |
| TBD | Cheesecake | TBD | Một phần | 43,000 |
| TBD | Brownie chocolate | TBD | Một phần | 33,000 |
| TBD | Muffin | TBD | Một cái | 29,000 |
| TBD | Sandwich jambon phô mai | TBD | Một phần | 43,000 |
| TBD | Khoai tây chiên | TBD | Một phần | 33,000 |

This approval permits further cost calculation only. It does not publish a Price, authorize implementation, establish tax treatment or rounding, or prove any Recipe, supplier cost, unit cost or gross margin. Cost evidence must be collected in [`after_four_commercial_v1_costing_input.csv`](after_four_commercial_v1_costing_input.csv); repeat a Product/Variant row for each distinct ingredient or direct-cost line rather than combining inputs.

**Owner-confirmed scope reconciliation:** Commercial V1 applies exclusively to the First Branch, and its first Price Version applies directly to that Branch without a chain-default Price or Branch override. `ODB-CAT-07` remains preserved as a long-term product direction, not active Commercial V1 behavior. Applying chain-default pricing or Branch overrides in a future scope requires a separate explicit Owner decision. This reconciliation does not authorize Price publication, implementation, tax/accounting policy, Recipe/BOM approval, cost/margin approval, or any Gate.

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

## 7. Future chain/Branch pricing scope — not applied to V1

`ODB-CAT-07` records the preserved long-term direction for chain-default Prices and explicit Branch overrides. The Owner-confirmed reconciliation keeps both mechanisms outside Commercial V1, which is scoped directly to the First Branch's first Price Version. This future table may be used only after a separate explicit Owner decision activates that future direction and defines its scope.

| Product/Variant | Giá mặc định chuỗi | Main Branch override | Lý do |
|---|---:|---:|---|
|  |  |  |  |
|  |  |  |  |

This table is retained only for a future `ODB-CAT-07` scope; it is not a V1 costing input and its retention grants no publication or implementation authority. Any future approved Price scope must still use immutable, effective-dated Price Versions under `ODB-CAT-08`.

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
| Pricing direction | `OWNER_CONFIRMED_BY_REFERENCE` — approximately VND 23,000 / 33,000 / 43,000–49,000 under `CORE-OD-01` |
| Commercial Baseline V1 | `OWNER_CONFIRMED` — exact costing combinations and proposed VND selling-price inputs in §4 under `CORE-OD-18`; same price for dine-in/takeaway; first Branch and first Price Version only; no chain-default or Branch override |
| Price publication / implementation | `NOT_AUTHORIZED` — V1 approval permits cost calculation only |
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
- [Commercial V1 costing input — 52 priced combinations](after_four_commercial_v1_costing_input.csv)
- [Commercial V1 MAKE Recipe/BOM input — 24 Products / 48 combinations](after_four_commercial_v1_make_recipe_bom_input.csv)
- [Commercial V1 BUY finished-product procurement input — four Products / four combinations](after_four_commercial_v1_buy_finished_procurement_input.csv)
- [Comprehensive Evidence Register](../research/after_four_comprehensive_evidence_register.csv)
- [Commercial V1 Signature Product Practical Test Protocol](../research/after_four_commercial_v1_signature_practical_test_protocol.md)
- [Commercial V1 Cost Evidence Collection Gaps](../research/after_four_commercial_v1_cost_evidence_collection_gaps.md)
