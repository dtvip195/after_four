# AFTER FOUR — Phase 3.3 Frontend Application Shell

> Trạng thái: implemented and browser-verified.
>
> Phạm vi: application shell, routing, navigation, floor context và placeholder pages. Không có POS workflow, dữ liệu nghiệp vụ, backend, authentication hoặc API.

## 1. Kết quả

AFTER FOUR hiện có application shell dùng chung cho toàn bộ destination sản phẩm. Shell giữ hướng Modern Specialty — Warm Minimalism đã duyệt: nền warm white, sidebar surface sáng, Coffee Brown cho primary, Clay làm accent có kiểm soát, divider thay cho nhiều card và không thêm màu/token mới.

Route `/` chuyển hướng sang `/dashboard`. Route `/design-system` tiếp tục hoạt động độc lập và có link trở lại Application Shell.

## 2. Kiến trúc

```text
src/app/
├── components/
│   ├── floor-options.ts
│   └── floor-selector.tsx
├── layout/
│   ├── app-header.tsx
│   ├── app-shell.tsx
│   ├── app-sidebar.tsx
│   └── mobile-navigation.tsx
├── navigation/
│   ├── application-navigation.tsx
│   ├── navigation-config.ts
│   └── navigation-item.tsx
└── pages/
    ├── not-found-page.tsx
    └── placeholder-page.tsx
```

- `AppShell` sở hữu state tầng và composition sidebar/header/main content.
- Navigation config tách metadata destination khỏi rendering.
- `NavigationItem` dùng `NavLink` để lấy active state và `aria-current="page"`.
- Placeholder dùng cùng một component, chỉ nhận metadata route; không chứa mock business logic.
- Not-found page nằm trong shell để người dùng vẫn giữ global navigation và có đường về Dashboard.

## 3. Navigation và routing

React Router declarative mode được thêm vì pathname switch thủ công trước đây không hỗ trợ client-side navigation, nested shell, active state hoặc not-found route. Dependency runtime duy nhất được thêm là `react-router@8.5.1`, tương thích với React 19.3.1 và Node.js 24.

| Group | Destinations |
| --- | --- |
| Overview | Dashboard |
| Operations | POS, Orders, Tables, Kitchen |
| Catalog | Menu, Categories |
| Management | Inventory, Recipes, Staff, Reports, Settings |

Routes:

- `/` → redirect `/dashboard`
- `/dashboard`, `/pos`, `/orders`, `/tables`, `/kitchen`
- `/menu`, `/categories`
- `/inventory`, `/recipes`, `/staff`, `/reports`, `/settings`
- `/design-system`
- Mọi route khác → “Không tìm thấy trang”

Mỗi destination nghiệp vụ chỉ hiển thị placeholder nêu rõ chức năng sẽ được triển khai trong phase riêng.

## 4. Sidebar và mobile navigation

### Desktop — từ 1024px

- Sidebar sticky rộng 240px.
- Hiển thị temporary wordmark, group labels, icon và destination labels.
- Active state kết hợp accent surface, Clay indicator, text và `aria-current`.
- Design System là developer destination riêng ở footer, không trộn vào IA sản phẩm.

### Tablet — 768–1023px

- Sidebar trở thành rail rộng 72px.
- Icon giữ touch target 44px; accessible name và tooltip cung cấp tên destination.
- Group divider giữ cấu trúc mà không làm workspace bị nén bởi label dài.

### Mobile — dưới 768px

- Sidebar không chiếm content width.
- Button “Mở điều hướng” mở shadcn Sheet từ bên trái.
- Sheet có đầy đủ group và label; tự đóng sau khi chọn destination.
- Focus management và Escape behavior do Radix Sheet quản lý.

## 5. Header

Header sticky gồm:

- Mobile navigation trigger ở viewport nhỏ.
- Current page title.
- Reusable Floor Selector.
- Notification icon ở trạng thái disabled placeholder; không giả lập notification logic.
- User dropdown placeholder; không giả lập authentication.

Ở mobile, floor selector chuyển xuống hàng thứ hai để tránh title và actions chồng lấn. Tablet/desktop giữ selector cùng hàng với actions.

## 6. Floor Selector

`FloorSelector` tái sử dụng shadcn Select với hai lựa chọn:

- Tầng 1
- Tầng 2

State nằm trong `AppShell`, vì vậy selection được giữ khi chuyển destination trong shell. Trigger có accessible name “Chọn tầng”, hỗ trợ keyboard theo Radix Select. Page header phản ánh `Phạm vi hiện tại` để selected context không chỉ tồn tại trong control.

Không có persistence, filtering, database hoặc business rule theo tầng.

## 7. Main content

- Main content dùng `min-width: 0`, responsive padding và max-width 96rem.
- Page heading, description và floor context có hierarchy nhất quán.
- Placeholder dùng divider và một accent boundary thay vì dashboard card grid.
- Có skip link “Chuyển đến nội dung chính” cho keyboard navigation.
- Không có metric, chart hoặc operational data giả.

## 8. Component tái sử dụng

- shadcn/ui: Button, Select, Sheet, Dropdown Menu, Tooltip.
- Lucide React: icon family duy nhất.
- Existing semantic tokens: background, foreground, sidebar, primary, accent, border, ring, Brand Clay.
- Be Vietnam Pro cho UI; không thay đổi typography hoặc `globals.css`.

shadcn Sidebar không được thêm: shell chỉ cần breakpoint-driven rail/sidebar, còn provider/collapse behavior của registry component sẽ làm tăng complexity mà không tạo thêm giá trị trong phase này.

## 9. Responsive browser verification

| Viewport | Navigation | Header/Floor selector | Document overflow | Kết quả |
| --- | --- | --- | --- | --- |
| 390 × 844 | Mobile Sheet trigger | Hai hàng, không overlap | Không | Pass |
| 768 × 1024 | 72px icon rail | Một hàng, selector dùng được | Không | Pass |
| 1440 × 900 | 240px full sidebar | Một hàng, labels đọc rõ | Không | Pass |

Full-page Application Shell screenshots được tạo trong `frontend/test-results/` ở cả ba viewport. Đây là generated test artifacts và được Git ignore.

## 10. Playwright coverage

- Root redirect và Dashboard rendering.
- Tất cả 12 destinations điều hướng đúng.
- Active destination có `aria-current="page"`.
- Unknown route hiển thị not-found page.
- Design System vẫn truy cập được và link trở lại shell.
- Chuyển Tầng 1/Tầng 2 cập nhật UI state.
- Mobile Sheet mở, chọn route và tự đóng.
- Shell không horizontal overflow ở 390, 768 và 1440px.
- Sidebar không overlap main content.
- Header, user menu trigger và floor selector vẫn accessible.
- Design System regression tests cũ tiếp tục chạy.

Kết quả: `27 passed, 0 failed` trên Desktop Chromium project với viewport override theo từng test.

## 11. Quality checks

| Check | Result |
| --- | --- |
| `npm run typecheck` | Pass |
| `npm run lint` | Pass, không warning |
| `npm run build` | Pass |
| `npm run test:e2e` | 27 passed, 0 failed |
| `npm audit --omit=dev` | 0 runtime vulnerabilities |

Full `npm audit` vẫn báo 2 low và 4 moderate trong dev-only dependency tree của shadcn CLI, giống phase trước. Không chạy force fix vì đề xuất hiện tại sẽ downgrade shadcn bằng breaking change. React Router không tạo advisory runtime mới.

## 12. Tool verification

- Better Design skill đã được đọc.
- Better Design MCP không kết nối trong phiên này; không tuyên bố đã tải guidance hoặc chạy MCP review.
- shadcn MCP đã được dùng để kiểm tra Sidebar registry metadata và audit checklist.
- Visual review thực hiện bằng Playwright screenshots tại 390, 768 và 1440px.

## 13. Giới hạn còn lại

- Tất cả destination nghiệp vụ vẫn là placeholder.
- Floor selection chỉ là local React state.
- Notification và user menu chưa có backend behavior.
- Không có authentication, permission hoặc role-aware navigation.
- Chưa test screen reader thật, touch hardware, zoom 200% hoặc OS text scaling.
- Chromium là browser E2E duy nhất; chưa có axe hoặc visual-regression baseline.
- Navigation chưa có user-controlled collapse; tablet rail và desktop sidebar chuyển theo breakpoint cố định.
