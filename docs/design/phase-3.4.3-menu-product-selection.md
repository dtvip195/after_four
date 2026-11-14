# AFTER FOUR — Phase 3.4.3 Menu & Product Selection UI

> Trạng thái: implemented and browser-verified.
>
> Phạm vi: prototype duyệt, lọc, chọn và xem chi tiết sản phẩm tại `/pos`. Không có order mutation, modifier, pricing engine, inventory, backend, API hoặc persistence.

## 1. Kết quả

Menu Workspace hiện hỗ trợ tìm kiếm, lọc danh mục, selected state và Product Detail Dialog. Chọn sản phẩm chỉ mở thông tin demo; order lines và tổng tiền tĩnh từ Phase 3.4.1 không thay đổi.

Dialog hiển thị rõ `Dữ liệu demo` và action `Thêm vào đơn — phase sau` luôn disabled. Đóng Dialog đồng thời bỏ selected state.

## 2. Component architecture

```text
src/features/pos/
├── components/
│   ├── menu-product-card.tsx
│   ├── menu-workspace.tsx
│   ├── product-detail-dialog.tsx
│   └── product-visual.tsx
├── data/
│   └── pos-demo-data.ts
├── pages/
│   └── pos-page.tsx
└── types/
    └── pos.ts
```

- `PosPage` sở hữu search, category và selected product state.
- `MenuWorkspace` render controls, result count, grid và empty state.
- `MenuProductCard` giữ semantic article, còn native button bên trong xử lý selection và `aria-pressed`.
- `ProductDetailDialog` dùng shadcn/Radix Dialog, focus trap và Escape behavior sẵn có.
- `ProductVisual` tập trung mapping category sang Lucide icon để card và detail không duplicate logic.
- Chỉ có một Dialog tại `PosPage`; hai composition mobile/desktop không tạo portal trùng lặp.

## 3. Fixtures

Tám sản phẩm demo tiếp tục được dùng:

- Coffee: Espresso, Americano, Cappuccino, Latte.
- Tea: Milk Tea, Peach Tea.
- Non-coffee: Cacao.
- Other: Sparkling Water.

Mỗi fixture bổ sung một mô tả ngắn, luôn ghi rõ đây là nội dung minh họa. Giá, tên, danh mục và mô tả chưa phải dữ liệu kinh doanh đã được phê duyệt.

Không thêm fixture size, topping, modifier, recipe, ingredient, inventory hoặc availability.

## 4. Interactions demo

- Search local fixture theo tên sản phẩm.
- Lọc theo Tất cả, Coffee, Tea, Non-coffee và Other.
- Chọn card để đặt selected state và mở Product Detail.
- Đóng Dialog bằng nút close, Escape hoặc overlay behavior của Radix; selection được xóa.
- Empty state khi search/category không có kết quả.
- Disabled action chứng minh chưa có thao tác thêm vào đơn.

Không có thay đổi order items, quantity, total, table state hoặc dữ liệu ngoài local React state.

## 5. Product Detail

Dialog gồm:

- Icon placeholder theo danh mục.
- Category badge và badge `Dữ liệu demo`.
- Tên, giá demo và mô tả minh họa.
- Cảnh báo chưa có size, topping, modifier, công thức, tồn kho hoặc chính sách giá.
- Disabled button `Thêm vào đơn — phase sau`.

Dialog title là accessible name. Close button có accessible name tiếng Việt và touch target tối thiểu 44px.

## 6. Responsive behavior

| Viewport | Behavior | Kết quả |
| --- | --- | --- |
| 390 × 844 | Giữ tab Menu; product grid hai cột; Dialog gần full-width, nội dung scroll nếu cần | Pass, không horizontal overflow |
| 768 × 1024 | Menu/Order composition giữ nguyên; Dialog rộng tối đa 32rem | Pass, không horizontal overflow |
| 1440 × 900 | POS ba vùng giữ nguyên; Dialog centered trên operational canvas | Pass, không horizontal overflow |

Dialog giới hạn chiều cao bằng viewport và tự scroll dọc. Không thay đổi Application Shell, mobile Tabs hoặc Table Management composition.

## 7. Accessibility

- Product card dùng native button với accessible name và `aria-pressed`.
- Selected state kết hợp border, surface, ring, check icon và pressed state.
- Search có visible label; category filter có group name và pressed state.
- Result count dùng `aria-live="polite"`; empty result dùng `role="status"`.
- Dialog lấy accessible name từ product title, có focus trap và restore focus của Radix.
- Disabled order action dùng native disabled state.

Chưa có screen-reader hardware test, touch hardware test, zoom 200% hoặc axe dependency.

## 8. Screenshots

Playwright tạo viewport screenshots tại:

- `frontend/test-results/screenshots-captures-product-detail-at-390px-desktop-chromium/product-detail-390.png`
- `frontend/test-results/screenshots-captures-product-detail-at-768px-desktop-chromium/product-detail-768.png`
- `frontend/test-results/screenshots-captures-product-detail-at-1440px-desktop-chromium/product-detail-1440.png`

Product Detail screenshots tắt animation trong lúc capture để phản ánh trạng thái Dialog ổn định. Artifacts nằm trong test output và không được commit.

## 9. E2E coverage

- Product catalog và result count.
- Search theo tên.
- Category filter.
- Selected state và Product Detail content.
- Disabled add-to-order action.
- Close/deselect behavior.
- Empty state.
- Responsive và document overflow tại 390, 768 và 1440px.
- Table Management vẫn chọn và preview bàn sau Product Detail interaction.
- Screenshots ở cả ba viewport.
- Toàn bộ Application Shell, Design System và các phase POS trước tiếp tục chạy.

Kết quả: `63 passed, 0 failed` trên Desktop Chromium project.

## 10. Quality checks và tools

| Check | Result |
| --- | --- |
| `npm run typecheck` | Pass |
| `npm run lint` | Pass, không warning |
| `npm run build` | Pass |
| `npm run test:e2e` | 63 passed, 0 failed |
| Hardcoded HEX / `any` trong feature | Không có |

Không cài dependency mới và không sửa Design Tokens. shadcn MCP audit checklist đã được đối chiếu. Better Design skill đã được đọc nhưng Better Design MCP không kết nối, vì vậy không có tuyên bố MCP guidance hoặc MCP review.

## 11. Giới hạn và quyết định chờ owner

- Catalog, tên, category, mô tả, hình ảnh và giá chính thức.
- Có cần product availability status hay không và vocabulary chính thức.
- Size, topping, modifier và price adjustment rules.
- Recipe, ingredient và inventory relationship.
- Khi nào selection thực sự thêm sản phẩm vào order.
- Quantity, notes, customization và validation flow.
- Có cần ảnh sản phẩm thật hoặc asset pipeline riêng không.
- Quy tắc permission hoặc staff role khi bán hàng.

Không quyết định hoặc triển khai các mục trên trong Phase 3.4.3.
