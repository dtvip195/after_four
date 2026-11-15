# AFTER FOUR — Proposed Launch Menu v3

**Target:** 28 Products (`OWNER_CONFIRMED`, `ODB-CAT-11`)
**Menu status:** `PROPOSED_NOT_APPROVED` — individual Products pending final approval
**Pricing:** `TBD`
**Size policy:** S/M/L only for suitable Products (`OWNER_CONFIRMED`, `ODB-CAT-12`)
**Signature Products:** Bơ xay dừa non, Trà đào cam sả, Cà phê muối (`OWNER_CONFIRMED`, `ODB-CAT-13`)
**Implementation authorization:** Không

> The target scale, selective size policy, and three Signature Product designations are Owner-confirmed only within the boundaries stated above. Every Product row, code, Variant assignment, Modifier, Recipe, Price, and operational rule below remains proposed or `TBD` until separately approved.

## 1. Cà phê — 6 sản phẩm đề xuất

| Code | Product | Proposed Variant |
|---|---|---|
| CF001 | Cà phê đen | Đá / Nóng |
| CF002 | Cà phê sữa | Đá / Nóng |
| CF003 | Bạc xỉu | Đá / Nóng |
| CF004 | Cà phê muối ⭐ | Đá |
| CF005 | Cà phê dừa | Đá |
| CF006 | Latte | Đá / Nóng |

## 2. Trà trái cây — 5 sản phẩm đề xuất

| Code | Product | Proposed Variant |
|---|---|---|
| TR001 | Trà đào cam sả ⭐ | S/M/L — cần xác nhận |
| TR002 | Trà vải | S/M/L — cần xác nhận |
| TR003 | Trà chanh | S/M/L — cần xác nhận |
| TR004 | Trà tắc mật ong | S/M/L — cần xác nhận |
| TR005 | Trà chanh dây | S/M/L — cần xác nhận |

## 3. Nước ép và giải khát — 4 sản phẩm đề xuất

| Code | Product | Proposed Variant |
|---|---|---|
| NG001 | Nước chanh | S/M/L — cần xác nhận |
| NG002 | Chanh dây đá | S/M/L — cần xác nhận |
| NG003 | Cam ép | S/M/L — cần xác nhận |
| NG004 | Soda chanh | S/M/L — cần xác nhận |

## 4. Sinh tố và đá xay — 4 sản phẩm đề xuất

| Code | Product | Proposed Variant |
|---|---|---|
| SM001 | Bơ xay dừa non ⭐ | S/M/L — cần xác nhận |
| SM002 | Sinh tố xoài | S/M/L — cần xác nhận |
| SM003 | Sinh tố dâu | S/M/L — cần xác nhận |
| SM004 | Cà phê dừa đá xay | S/M/L — cần xác nhận |

## 5. Thức uống khác — 3 sản phẩm đề xuất

| Code | Product | Proposed Variant |
|---|---|---|
| KH001 | Matcha latte | Đá / Nóng; size TBD |
| KH002 | Cacao sữa | Đá / Nóng; size TBD |
| KH003 | Sữa chua trái cây | Default; size TBD |

## 6. Bánh ngọt và đồ ăn nhẹ — 6 sản phẩm đề xuất

| Code | Product | Proposed Variant |
|---|---|---|
| BA001 | Bánh croissant | Một phần |
| BA002 | Cheesecake | Một phần |
| BA003 | Brownie chocolate | Một phần |
| BA004 | Muffin | Một cái |
| BA005 | Sandwich jambon phô mai | Một phần |
| BA006 | Khoai tây chiên | Một phần |

## 7. Tổng hợp

| Category | Proposed Products |
|---|---:|
| Cà phê | 6 |
| Trà trái cây | 5 |
| Nước ép và giải khát | 4 |
| Sinh tố và đá xay | 4 |
| Thức uống khác | 3 |
| Bánh ngọt và đồ ăn nhẹ | 6 |
| **Total** | **28** |

The totals satisfy the approved 28-Product target. They do not constitute approval of the six proposed Categories or their individual contents.

## 8. Proposed Modifier Groups

### Đường

- 0%, 30%, 50%, 70%, 100%.
- Chỉ áp dụng cho Product phù hợp.

### Lượng đá

- Không đá, ít đá, bình thường.
- Không áp dụng cho đồ uống nóng hoặc Product không phù hợp.

### Topping

- Đào, vải, thạch, trân châu, dừa non, kem muối.
- Chỉ gắn với Product tương ứng.

### Thêm nguyên liệu

- Extra espresso shot, sữa, kem béo, dừa non.
- Chỉ gắn với Product tương ứng.

Modifier pricing: `TBD`. Modifier Group applicability, cardinality for each Product/Variant, individual options, quantity limits, and Price effects remain unapproved.

## 9. Variant rules

The following rules apply from the existing Owner-confirmed Catalog/Pricing baseline:

- Mỗi lựa chọn bán được phải có persisted Variant (`ODB-CAT-04`).
- Sử dụng implicit/default hidden Variant nếu không cần lựa chọn hiển thị cho khách (`ODB-CAT-04`).
- Draft Product có thể tạm thời chưa có Variant hoặc Default Variant (`ODB-CAT-19`). Với Active Product, Default hợp lệ phải có `is_default = true` và status Active; `customer_visible` độc lập nên hidden Active vẫn hợp lệ, còn Inactive/Archived thì không (`ODB-CAT-20`, `ODB-CAT-28`).
- Category/Product/Variant dùng ba Brand-scoped Code namespace riêng; cùng một Code có thể xuất hiện một lần ở mỗi entity type nhưng không được trùng trong cùng type/Brand (`ODB-CAT-16`, `ODB-CAT-27`). SKU là optional và Brand-unique khi có; các identifier này không được tái sử dụng sau archive (`ODB-CAT-17`, `ODB-CAT-18`). Các code trong bảng đề xuất vẫn chưa được duyệt thành dữ liệu thực tế.
- S/M/L chỉ áp dụng cho Product phù hợp (`ODB-CAT-12`).
- Nóng/Đá là proposed Variant choice khi cần phân biệt cấu hình bán hàng; applicability per Product remains unapproved.
- Không tạo Modifier trùng nghĩa với Variant choice.
- Dung tích thực tế của S/M/L: `TBD`.
- Giá từng Variant: `TBD`.

## 10. Signature Products

The Owner-confirmed Signature Product designations are:

1. Bơ xay dừa non.
2. Trà đào cam sả.
3. Cà phê muối.

Công thức, định lượng, cách trình bày, Product codes, Variants, availability, và Prices: `TBD` hoặc pending final Product approval. The designation does not approve those details.

## 11. Unresolved — TBD

- Final approval of each proposed Product and Product code.
- Final Category names, codes, ordering, and Product membership.
- Giá bán từng Product/Variant.
- Dung tích S/M/L và Product applicability.
- Nóng/Đá applicability per Product.
- Công thức và định lượng nguyên liệu.
- Modifier applicability và cardinality chi tiết.
- Giá phát sinh và Price history của Modifier.
- Branch Price overrides và giá thực tế của Main Branch.
- Tax, Service Charge, và Rounding.
- Chính sách Product miễn phí.
- Inventory và availability theo tồn kho.

## 12. Approval boundary

`OWNER_CONFIRMED`:

- target launch-menu scale of 28 Products (`ODB-CAT-11`);
- selective S/M/L policy for suitable Products (`ODB-CAT-12`);
- Signature Product designations: Bơ xay dừa non, Trà đào cam sả, and Cà phê muối (`ODB-CAT-13`).

`PROPOSED_NOT_APPROVED`:

- the individual 28 Product rows and codes;
- the six Category groupings;
- Variant applicability, including Nóng/Đá and S/M/L per Product;
- all proposed Modifier Groups and options.

`OPEN` / `TBD`:

- Recipes, quantities, presentation, prices, tax, service charge, rounding, free-item policy, inventory, and detailed availability.

No part of this document authorizes implementation, schema, API, frontend, Payment lifecycle, or Identity changes.

## 13. Canonical references

- [Owner Decision Baseline §5](after_four_owner_decision_baseline.md#5-catalogpricing-mvp)
- [Real Menu & Pricing Specification](after_four_real_menu_pricing_specification.md)
- [Catalog/Pricing Discovery and Decision Closure](after_four_catalog_pricing_discovery.md)
