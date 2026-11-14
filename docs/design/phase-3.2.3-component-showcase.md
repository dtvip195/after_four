# AFTER FOUR — Phase 3.2.3 Component Showcase

> Trạng thái: implemented for internal review.
>
> Route: /design-system
>
> Đây là Design System Playground, không phải POS Application Shell hoặc màn hình vận hành thật.

## 1. Mục đích và phạm vi

Showcase giúp owner và frontend team đánh giá trực tiếp:

- Design token đã triển khai ở Phase 3.2.2.
- Be Vietnam Pro với nội dung tiếng Việt.
- Geist Mono với tiền, giờ, mã và dữ liệu dạng bảng.
- Component states gồm default, hover, focus, selected, disabled, loading và error.
- Primitive có khả năng dùng lại cho POS trong tương lai.
- Mật độ giao diện trên mobile, tablet và desktop.

Showcase không có backend, API, database, authentication hoặc business logic. POS Preview chỉ dùng static data để kiểm tra composition. Không có workflow gọi món, thanh toán, chuyển bàn, tồn kho hoặc Upstairs Delivery.

## 2. Cách truy cập

Từ frontend/:

1. Chạy npm run dev.
2. Mở http://localhost:5173/design-system.

Foundation page tại route / có link Open component showcase.

Route được xử lý tối thiểu trong App.tsx, không cài router. Design System Page được lazy-load thành chunk riêng để foundation page không phải tải toàn bộ playground.

## 3. Cấu trúc Showcase

### A. Brand & Design Tokens

- Temporary AFTER FOUR wordmark.
- Brand, semantic và status swatches.
- HEX được resolve trực tiếp từ CSS custom properties lúc runtime, không chép cứng vào Showcase.
- Spacing scale.
- Radius, border và shadow specimens.
- Focus ring thật và focus preview.

### B. Typography

- Be Vietnam Pro Regular 400, Medium 500, Semibold 600 và Bold 700.
- Semantic type scale: meta, label, body, section, page và display.
- Tiếng Việt có dấu và paragraph dài.
- Geist Mono cho doanh thu, thời gian, mã đơn và số liệu.

### C. Buttons

- Primary, secondary, outline, ghost và destructive.
- xs, sm, default và touch size.
- Icon button với accessible name.
- Disabled và loading.

### D. Form Controls

- Input, Textarea, Select, Checkbox, Radio Group và Switch.
- Default, focus preview, disabled và error.
- Visible label, helper text, aria-describedby và aria-invalid.
- Form control dùng touch target 44px trên mobile/tablet và control 40px từ desktop.

### E. Feedback & Status

- Badge variants.
- Success, warning, error và information alerts.
- Tooltip với accessible icon button.
- Progress và loading feedback.
- Status luôn có text/icon; không dùng màu làm tín hiệu duy nhất.

### F. Containers & Navigation Primitives

- Card.
- Tabs.
- Responsive Table với data và empty states.
- Dialog, Sheet, Drawer và Dropdown Menu có interaction thật.
- Command search specimen.

### G. POS UI Preview

- Static table cards.
- Static product cards.
- Static order table.
- Numeric total.
- Selected state được ghi rõ là UI state.
- Không định nghĩa business vocabulary hoặc mapping trạng thái bàn/đơn.

## 4. Component đã cài thêm

Các source component từ shadcn registry:

- Input
- Textarea
- Select
- Checkbox
- Radio Group
- Switch
- Label
- Badge
- Alert
- Tooltip
- Progress
- Card
- Tabs
- Table
- Dialog
- Sheet
- Drawer
- Dropdown Menu
- Command
- Input Group, được Command kéo vào làm dependency nội bộ

Button được shadcn CLI re-emit nhưng API và cách dùng hiện tại được giữ nguyên.

Tất cả component nằm trong frontend/src/components/ui/ và có thể chỉnh sửa trực tiếp. Không cài một UI library thứ hai.

## 5. Dependencies thay đổi

Hai runtime dependency được shadcn registry yêu cầu:

| Package | Version range | Lý do |
| --- | --- | --- |
| cmdk | ^1.1.1 | Command primitive |
| vaul | ^1.1.2 | Drawer primitive |

Các component còn lại dùng radix-ui, Lucide React và utility hiện có.

## 6. Design tokens được sử dụng

- Brand: brand-coffee, brand-warm-white, brand-beige, brand-charcoal, brand-clay.
- Semantic: background, foreground, card, popover, primary, secondary, muted, accent, border, input, ring và destructive.
- Status: success, warning, error và information với foreground pair tương ứng.
- Typography: font-sans, font-mono, text-meta, text-label, text-body, text-section, text-page và text-display.
- Sizing: spacing-control, spacing-target và spacing-touch.
- Radius: sm đến xl.
- Shadow: sm và md.

Không sửa token trong globals.css để phục vụ Showcase. Không có hardcoded HEX trong Showcase source.

## 7. Responsive implementation

Breakpoints giữ nguyên Tailwind CSS 4.

| Viewport mục tiêu | Hành vi trong source | Visual browser status |
| --- | --- | --- |
| Mobile 390px | Single-column sections, wrapped local navigation, stacked POS preview, target 44–48px | Chưa xác minh bằng browser |
| Tablet 768px | Hai cột khi đủ chỗ, form và overlay giữ touch targets, content không ép desktop layout | Chưa xác minh bằng browser |
| Desktop 1440px | Multi-column token grids, split specimens và three-zone POS composition preview | Chưa xác minh bằng browser |

Table là khu vực duy nhất được phép horizontal scroll có chủ đích thông qua wrapper của shadcn Table. Source audit không thấy w-screen, hardcoded viewport width hoặc overflow-x scroll khác trong Showcase.

Vite dev server đã phản hồi HTTP 200 cho cả / và /design-system. Phiên Codex này không có Playwright hoặc browser automation, nên không tuyên bố đã visual-verify 390px, 768px hoặc 1440px.

## 8. Accessibility implementation

Đã triển khai ở source:

- Semantic heading hierarchy và section labels.
- Visible labels cho form controls.
- Helper/error text liên kết bằng aria-describedby.
- Error field dùng aria-invalid và message role alert.
- Icon-only button có aria-label.
- Loading dùng aria-busy hoặc aria-live phù hợp.
- Tabs, Select, Dialog, Sheet, Drawer, Dropdown, Checkbox và Radio dựa trên Radix primitives.
- Status dùng icon và text ngoài màu.
- Touch-oriented actions dùng target 44–48px.
- Focus-visible ring dùng semantic ring token.
- Numeric values dùng Geist Mono và tabular numerals.

Chưa xác minh:

- Screen reader thực tế.
- Manual keyboard traversal trong browser.
- Focus trap runtime của từng overlay.
- Automated axe scan.
- Zoom 200% và OS text scaling.

Các mục này cần browser/manual review trước POS Application Shell.

## 9. Quality checks

| Kiểm tra | Kết quả |
| --- | --- |
| npm run typecheck | Pass |
| npm run lint | Pass, không warning |
| npm run build | Pass |
| Vite route / | HTTP 200 |
| Vite route /design-system | HTTP 200 |
| npm audit --omit=dev | 0 runtime vulnerabilities |
| Hardcoded HEX trong Showcase | Không có |
| Unintended horizontal overflow utility | Không có |
| Main bundle chunk warning | Đã xử lý bằng lazy-load route |

Production output:

- Main application chunk khoảng 315 kB.
- Lazy design-system chunk khoảng 195 kB.
- Không còn cảnh báo chunk lớn hơn 500 kB.

## 10. Better Design và shadcn verification

- Better Design skill đã được kiểm tra.
- Better Design MCP chưa kết nối; không có Better Design MCP guidance hoặc review nào được tuyên bố.
- shadcn MCP đã dùng để kiểm tra item, dependencies, examples và add command.
- shadcn audit checklist đã được đối chiếu: import đúng, dependency được cài, TypeScript và lint pass.
- Playwright MCP không khả dụng trong phiên này.

## 11. Files created / modified

### Application composition

- frontend/src/App.tsx
- frontend/src/main.tsx

### Showcase

- frontend/src/app/design-system/design-system-page.tsx
- frontend/src/app/design-system/showcase-data.ts
- frontend/src/app/design-system/showcase-section.tsx
- frontend/src/app/design-system/color-swatch-grid.tsx
- frontend/src/app/design-system/brand-tokens-section.tsx
- frontend/src/app/design-system/typography-section.tsx
- frontend/src/app/design-system/buttons-section.tsx
- frontend/src/app/design-system/forms-section.tsx
- frontend/src/app/design-system/feedback-section.tsx
- frontend/src/app/design-system/showcase-table.tsx
- frontend/src/app/design-system/overlay-demos.tsx
- frontend/src/app/design-system/primitives-section.tsx
- frontend/src/app/design-system/pos-preview-section.tsx

### shadcn source

Các file UI tương ứng với component ở mục 4 được thêm trong frontend/src/components/ui/. Hai lint suppression comments được thêm vào Badge và Tabs để giữ nguyên exported variant API của registry mà không tạo Fast Refresh warnings.

### Package and generated files

- frontend/package.json
- frontend/package-lock.json
- frontend/node_modules/, local generated
- frontend/dist/, production build output
- docs/design/phase-3.2.3-component-showcase.md

Không thay đổi globals.css, fonts.css, Vite config, backend hoặc database.

## 12. Known issues và điểm cần owner review

1. Cần visual review thật tại 390px, 768px và 1440px.
2. shadcn primitive mặc định khá compact, khoảng 28–32px ở một số Button/Input/Tabs. Showcase override lên 40–48px theo context. Trước POS Shell cần quyết định thay default primitive hay giữ contextual sizing.
3. Badge registry dùng radius rất lớn. Owner cần đánh giá pill appearance có quá mềm so với operational density không.
4. Cần đánh giá Clay có đủ tiết chế và khác biệt với semantic warning hay không.
5. Cần đánh giá Be Vietnam Pro ở paragraph dài và Geist Mono ở tiền Việt.
6. Cần kiểm tra Dialog, Sheet và Drawer bằng touch, keyboard và screen reader thật.
7. Cần duyệt table density, empty state và intentional horizontal scroll trên mobile.
8. POS Preview chỉ đánh giá composition; mọi vocabulary và status mapping vẫn chưa được duyệt.
9. Full npm audit vẫn có advisory trong dev dependency tree của shadcn CLI như đã ghi ở Phase 3.2.2; không dùng force fix hoặc downgrade.

## 13. Component cần điều chỉnh trước POS Application Shell

- Chốt sizing strategy cho Button, Input, Select, Tabs và icon actions.
- Review Badge radius và status variants.
- Review Table row height/density ở tablet.
- Review overlay width, footer action order và touch behavior.
- Xác nhận cách dùng Card để tránh card soup.
- Xác nhận Command có cần nằm trong MVP hay chỉ dành cho owner tools.
- Chỉ sau owner review mới tạo shell, navigation hoặc component nghiệp vụ.
