# AFTER FOUR — Phase 3.4.4 Order Management UI

> Trạng thái: implemented and browser-verified.
>
> Phạm vi: local demo order tại `/pos`. Không có backend, persistence, payment, tax, discount, kitchen, inventory hoặc order lifecycle.

## 1. Kết quả

Order Workspace hiện bắt đầu ở trạng thái rỗng và cho phép thêm sản phẩm từ Product Detail, tăng/giảm quantity, xóa line, chỉnh ghi chú và clear toàn bộ order sau xác nhận.

Subtotal được tính từ integer VND. Checkout tiếp tục disabled và UI ghi rõ đây không phải số tiền thanh toán cuối cùng.

## 2. Order state architecture

`PosPage` là owner duy nhất của order state thông qua `useDemoOrder`. Cả mobile và desktop `OrderPanel` nhận cùng state/callbacks; không có nguồn order thứ hai.

```text
src/features/pos/
├── components/
│   ├── clear-order-dialog.tsx
│   ├── order-line-item.tsx
│   ├── order-panel.tsx
│   └── product-detail-dialog.tsx
├── hooks/
│   └── use-demo-order.ts
├── lib/
│   ├── format-vnd.ts
│   └── get-demo-order-summary.ts
├── pages/
│   └── pos-page.tsx
└── types/
    └── pos.ts
```

- `useDemoOrder`: toàn bộ local mutations cho add, increment, decrement, remove, note và clear.
- `OrderPanel`: composition, empty state, list và summary.
- `OrderLineItem`: line presentation và touch-friendly controls.
- `ClearOrderDialog`: xác nhận trước khi clear.
- `getDemoOrderSummary`: pure calculation cho line count, total quantity và subtotal.
- `formatVnd`: format integer VND nhất quán.

Không cài dependency mới và không sửa shared Design Tokens.

## 3. OrderLine data structure

```ts
type PosDemoOrderLine = {
  productId: string
  quantity: number
  note: string
}
```

Order line không sao chép tên hoặc giá. `productId` luôn resolve tới `posDemoProducts`, là nguồn duy nhất cho product name và `unitPriceVnd`.

Product fixture chuyển từ formatted price string sang integer VND:

```ts
unitPriceVnd: 58000
```

Formatted label như `58.000 ₫` chỉ được tạo tại presentation layer.

## 4. Tương tác demo

- Mở Product Detail không tự thêm sản phẩm.
- `Thêm vào đơn demo` thêm line mới và đóng Dialog.
- Thêm lại cùng sản phẩm tăng quantity trên line hiện có.
- Increment tăng quantity từng đơn vị.
- Decrement dừng ở 1 và bị disabled tại minimum.
- Remove là action riêng, không gắn với decrement.
- Ghi chú được chỉnh trực tiếp trên từng line.
- Clear toàn bộ mở Dialog xác nhận; không ảnh hưởng Menu hoặc Table Management.
- Mobile Tabs giữ nguyên order state khi chuyển Menu ↔ Đơn.

Mọi thay đổi chỉ tồn tại trong local React state và mất khi reload trang.

## 5. Subtotal demo

Công thức:

```text
subtotalVnd = sum(product.unitPriceVnd × line.quantity)
```

Summary hiển thị:

- Số loại sản phẩm, tương ứng số line.
- Tổng quantity.
- Tạm tính demo.

Không tính VAT, service charge, discount, promotion, rounding policy hoặc payment total. Checkout vẫn disabled.

## 6. Empty state

Order ban đầu không chứa line fixture. Empty state hiển thị:

- `Đơn đang trống`.
- Hướng dẫn chọn sản phẩm trong Menu.
- Loại sản phẩm: 0.
- Tổng số lượng: 0.
- Tạm tính demo: `0 ₫`.

Không còn static Cappuccino/Peach Tea order từ layout preview Phase 3.4.1.

## 7. Responsive behavior

| Viewport | Behavior | Kết quả |
| --- | --- | --- |
| 390 × 844 | Giữ tab Đơn; line, quantity, remove, note và summary xếp dọc | Pass, không horizontal overflow |
| 768 × 1024 | Menu và Order song song; Order dùng cột 18rem với internal vertical scroll | Pass, không horizontal overflow |
| 1440 × 900 | Giữ bố cục Bàn / Menu / Đơn ba vùng; Order rộng 20rem | Pass, không horizontal overflow |

Quantity và delete controls có touch target tối thiểu 44px. Footer summary tách khỏi vùng line scroll để luôn có context subtotal.

## 8. Accessibility

- Order Panel giữ complementary landmark `Đơn minh họa`.
- Mỗi line có accessible name theo product.
- Quantity controls nằm trong named group; increment/decrement/remove có accessible name cụ thể.
- Quantity và summary values có accessible labels.
- Textarea có visible label theo product.
- Decrement dùng native disabled state tại quantity 1.
- Clear confirmation dùng Radix Dialog với focus trap và named actions.
- Empty order dùng `role="status"`; summary dùng `aria-live="polite"`.

Chưa có screen-reader hardware test, touch hardware test, zoom 200% hoặc axe dependency.

## 9. Screenshots

Playwright tạo viewport artifacts tại:

- `frontend/test-results/screenshots-captures-order-management-at-390px-desktop-chromium/order-management-390.png`
- `frontend/test-results/screenshots-captures-order-management-at-768px-desktop-chromium/order-management-768.png`
- `frontend/test-results/screenshots-captures-order-management-at-1440px-desktop-chromium/order-management-1440.png`

Artifacts nằm trong test output và không được commit.

## 10. E2E coverage

- Empty Order và subtotal 0 ₫.
- Thêm sản phẩm từ Product Detail.
- Thêm cùng sản phẩm lần hai.
- Increment/decrement và minimum quantity 1.
- Xóa một line.
- Chỉnh ghi chú.
- Integer-VND subtotal với nhiều line.
- Clear Order có xác nhận.
- Mobile tab state persistence.
- Table Management hoạt động khi order đã có dữ liệu.
- Responsive và document overflow tại 390, 768 và 1440px.
- Screenshots ở cả ba viewport.
- Tất cả Application Shell, Design System và POS regression tests tiếp tục chạy.

Kết quả: `79 passed, 0 failed` trên Desktop Chromium project.

## 11. Quality checks và tools

| Check | Result |
| --- | --- |
| `npm run typecheck` | Pass |
| `npm run lint` | Pass, không warning |
| `npm run build` | Pass |
| `npm run test:e2e` | 79 passed, 0 failed |
| Hardcoded HEX / `any` trong feature | Không có |

shadcn MCP audit checklist đã được đối chiếu. Better Design skill đã được đọc nhưng Better Design MCP không kết nối, vì vậy không có tuyên bố MCP guidance hoặc MCP review.

## 12. Giới hạn và quyết định chờ owner

- Khi nào order được tạo/lưu thật và vòng đời order chính thức.
- Quantity maximum, validation và behavior khi product không còn khả dụng.
- Nội dung, độ dài tối đa và sanitization cho line note.
- VAT, service charge, discount, promotion và rounding policy.
- Payment total và payment methods.
- Quan hệ giữa order, table, floor, staff và permission.
- Modifier/size/topping và cách ảnh hưởng unit price.
- Kitchen ticket, inventory deduction và recipe calculation.
- Clear order có cần permission, reason hoặc audit log không.
- Quy trình Upstairs Delivery.

Không quyết định hoặc triển khai các mục trên trong Phase 3.4.4.
