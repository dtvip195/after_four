# AFTER FOUR — Phase 3.4.1 POS Screen Layout

> Trạng thái: implemented and browser-verified.
>
> Phạm vi: bố cục và hierarchy trực quan cho POS. Không có order lifecycle, table management, payment, inventory, backend, API hoặc persistence.

## 1. Kết quả

Route `/pos` hiện cung cấp workspace POS đầu tiên theo định hướng Modern Specialty và Warm Minimal: mật độ vận hành vừa phải, Coffee Brown/Clay có kiểm soát, divider thay cho nhiều card nổi, Be Vietnam Pro cho UI và Geist Mono cho giá trị tiền.

Màn hình luôn ghi rõ đây là bản xem trước. Bàn, sản phẩm, giá và dòng đơn đều là dữ liệu minh họa; nút thanh toán bị vô hiệu hóa và không thể kích hoạt checkout.

## 2. Cấu trúc màn hình

### A. Không gian bàn

- Hiển thị tầng đang chọn từ Application Shell.
- Bốn bàn mẫu chỉ dùng để đánh giá mật độ và hierarchy.
- Không gán trạng thái nghiệp vụ, vị trí thật, thao tác chuyển hoặc gộp bàn.

### B. Chọn món

- Search theo tên sản phẩm minh họa.
- Bộ lọc danh mục: Tất cả, Coffee, Tea, Non-coffee và Other.
- Product card có category, tên, giá mẫu và icon placeholder từ Lucide.
- Không có ảnh sản phẩm thật, recipe, modifier, inventory hoặc thao tác thêm vào đơn.

### C. Đơn minh họa

- Hai dòng tĩnh dùng để đánh giá hierarchy của tên, số lượng và giá.
- Tạm tính và tổng là fixture tĩnh, không phải kết quả của calculation engine.
- Nút `Thanh toán — phase sau` luôn disabled.
- Không có thuế, giảm giá, payment method, persistence hoặc trạng thái đơn.

## 3. Kiến trúc component

```text
src/features/pos/
├── components/
│   ├── floor-workspace.tsx
│   ├── menu-product-card.tsx
│   ├── menu-workspace.tsx
│   ├── order-panel.tsx
│   └── table-preview.tsx
├── data/
│   └── pos-demo-data.ts
├── pages/
│   └── pos-page.tsx
└── types/
    └── pos.ts
```

- `PosPage` quản lý local search/category state và responsive composition.
- Dữ liệu minh họa tách khỏi rendering và có TypeScript types riêng.
- `FloorWorkspace`, `MenuWorkspace` và `OrderPanel` là ba vùng có accessible landmark/name.
- `TablePreview` và `MenuProductCard` giữ rendering item nhỏ, không chứa business logic.
- Route `/pos` được lazy-load trong router hiện có; các placeholder route khác không thay đổi.

## 4. Responsive decisions

| Viewport | Composition | Kết quả |
| --- | --- | --- |
| 390 × 844 | Tabs `Bàn / Menu / Đơn`; mặc định Menu; mỗi lần chỉ hiển thị một workspace | Pass, không horizontal overflow |
| 768 × 1024 | Không gian bàn full-width phía trên; Menu và Đơn chia hai cột phía dưới | Pass, không horizontal overflow |
| 1440 × 900 | Ba vùng trái / giữa / phải trong một operational canvas | Pass, không horizontal overflow |

Mobile không nén ba vùng thành cột nhỏ. Touch controls dùng target hiện có của Design System. Tablet dành toàn bộ hàng đầu cho context bàn và giữ Menu/Đơn song song. Desktop ưu tiên chiều rộng cho Menu, còn Floor và Order giữ độ rộng ổn định.

Screenshot dùng đúng ba viewport trên và chụp full page, vì vậy chiều cao artifact có thể lớn hơn viewport khi nội dung dọc dài. Artifacts nằm trong `frontend/test-results/` và đã được ignore.

## 5. Dữ liệu minh họa

- Categories: Coffee, Tea, Non-coffee, Other.
- Products: Espresso, Americano, Cappuccino, Latte, Milk Tea, Peach Tea, Cacao và Sparkling Water.
- Giá chỉ là fixture để kiểm tra cách trình bày số; chưa được owner phê duyệt.
- Bốn bàn mẫu không đại diện số lượng, tên hoặc sơ đồ bàn cuối cùng.
- Hai order line và tổng `151.000 ₫` là fixture tĩnh; không có calculation logic.

## 6. Interactions đã triển khai

- Search lọc local product fixture theo tên, không gọi API.
- Category selection lọc local product fixture và công bố pressed state.
- Floor selector dùng state chung của Application Shell và cập nhật context hiển thị.
- Mobile Tabs chuyển giữa ba workspace.
- Disabled checkout action chứng minh không có luồng thanh toán thật.

## 7. Components và design system

- Tái sử dụng shadcn/ui: `Badge`, `Button`, `Input`, `Tabs`.
- Tái sử dụng Lucide React cho search, floor, table, product và order icons.
- Chỉ dùng semantic/design tokens hiện có; không thêm HEX, brand color, font, shadow hoặc dark theme.
- shadcn MCP audit checklist đã được gọi sau khi hoàn thiện; imports, dependencies, TypeScript, lint và Playwright đều được kiểm tra.
- Better Design skill được áp dụng cho hierarchy, responsive composition và accessibility review. Better Design MCP không kết nối trong phiên nên không có tuyên bố MCP review.

## 8. Accessibility

- Các workspace có landmark và accessible name rõ ràng.
- Search, category group, floor selector, Tabs và checkout dùng role/name thay vì selector phụ thuộc CSS.
- Kết quả filter có `aria-live="polite"`.
- Mobile và desktop composition dùng ID riêng để tránh trùng `aria-labelledby` trong DOM.
- Checkout giữ native disabled state.

Chưa có screen-reader hardware test, touch-device test, zoom 200% hoặc OS text scaling audit.

## 9. Playwright coverage

- `/pos` load thành công và không có page/resource error quan trọng.
- Ba workspace xuất hiện đúng theo breakpoint.
- Search và category filter cập nhật sản phẩm minh họa.
- Floor selector vẫn dùng được.
- Order preview hiển thị fixture và checkout bị disabled.
- Responsive layout được kiểm tra tại 390 × 844, 768 × 1024 và 1440 × 900.
- `documentElement` và `body` không có horizontal overflow.
- Existing Design System và Application Shell coverage tiếp tục chạy.
- Screenshot POS được tạo ở cả ba viewport.

Kết quả đầy đủ: `39 passed, 0 failed` trên Desktop Chromium project.

## 10. Quality checks

| Check | Result |
| --- | --- |
| `npm run typecheck` | Pass |
| `npm run lint` | Pass, không warning |
| `npm run build` | Pass |
| `npm run test:e2e` | 39 passed, 0 failed |

Không cài dependency mới trong phase này.

## 11. Giới hạn và quyết định còn mở

- Table names, counts, positions và statuses chưa được phê duyệt.
- Product catalog, prices, images và categories chưa phải dữ liệu thật.
- Chưa quyết định behavior thêm món, quantity, modifier, notes hoặc stock state.
- Chưa có subtotal/tax/discount/payment rules.
- Chưa có order persistence, kitchen flow hoặc Upstairs Delivery workflow.
- Chromium là browser E2E duy nhất; chưa có visual-regression baseline hoặc axe dependency.
- Cần owner review bố cục ba vùng và chiến lược mobile Tabs trước Phase 3.4.2.
