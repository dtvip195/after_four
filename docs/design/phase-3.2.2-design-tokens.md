# AFTER FOUR — Phase 3.2.2 Design Tokens

> Trạng thái: triển khai nền tảng token ban đầu. Hướng thiết kế, font và vai trò palette đã được duyệt; **các giá trị HEX và kích thước cụ thể vẫn là đề xuất triển khai, chưa phải brand values cuối cùng**.
>
> Phạm vi: token màu, typography, spacing, radius, border, shadow và quy tắc responsive. Không triển khai screen, navigation, Sidebar, Header hoặc business logic.

## 1. Approved design decisions

Các quyết định owner đã duyệt:

- Visual direction: **Modern Specialty personality + Warm Minimal restraint + Contemporary Industrial operational density**.
- Primary UI font: **Be Vietnam Pro**.
- Numeric/tabular font: **Geist Mono**.
- Accent direction: **Clay / Copper**, sử dụng có tiết chế.
- Thiết bị hỗ trợ: desktop, tablet và mobile.
- Wordmark tạm thời: AFTER FOUR.
- Bối cảnh tương lai: quán hai tầng và một khái niệm Upstairs Delivery riêng. Phase này không triển khai chức năng đó.

Các quyết định chưa được xem là đã duyệt:

- Từng mã HEX cụ thể.
- Mapping màu vào trạng thái bàn/đơn nghiệp vụ.
- Dark theme.
- Ngưỡng responsive theo thiết bị thực tế của quán.
- Official logo và wordmark artwork.

## 2. Proposed versus approved color values

Owner đã duyệt **vai trò màu** gồm Coffee Brown, Warm White, Beige, Charcoal và Clay/Copper. Các giá trị dưới đây được đưa vào code để tạo nền tảng có thể kiểm thử, nhưng vẫn là đề xuất:

| Token palette | Giá trị hiện tại | Trạng thái | Vai trò |
| --- | --- | --- | --- |
| brand-coffee | #5B3A29 | Đề xuất | Primary brand/action |
| brand-warm-white | #F7F3EC | Đề xuất | App canvas |
| brand-beige | #E7D9C7 | Đề xuất | Secondary surface |
| brand-charcoal | #25211E | Đề xuất | Main foreground |
| brand-clay | #98542F | Đề xuất | Accent có chủ đích |

Clay không được ánh xạ trực tiếp vào shadcn accent, vì accent được nhiều component dùng cho hover/selected surfaces. Thay vào đó:

- brand-clay là màu nhận diện mạnh, chỉ dùng ở highlight được chủ động thiết kế.
- accent là một clay tint nhẹ để component tương tác không biến toàn bộ giao diện thành màu đồng.

## 3. Color token reference

### 3.1. Brand utilities

Các token palette được expose qua Tailwind CSS 4:

| Tailwind theme token | CSS source | Utility ví dụ |
| --- | --- | --- |
| --color-brand-coffee | --brand-coffee | bg-brand-coffee |
| --color-brand-warm-white | --brand-warm-white | bg-brand-warm-white |
| --color-brand-beige | --brand-beige | bg-brand-beige |
| --color-brand-charcoal | --brand-charcoal | text-brand-charcoal |
| --color-brand-clay | --brand-clay | text-brand-clay |

Ưu tiên semantic utilities như bg-primary và text-foreground. Raw brand utilities chỉ dùng khi ý nghĩa nhận diện là chủ đích.

### 3.2. Semantic tokens

| Semantic token | Giá trị thực tế | Foreground pair | Mục đích |
| --- | --- | --- | --- |
| background | #F7F3EC | foreground #25211E | App canvas |
| card | #FFFDF9 | card-foreground #25211E | Bề mặt nội dung độc lập |
| popover | #FFFDF9 | popover-foreground #25211E | Popover/menu/dialog surface |
| primary | #5B3A29 | primary-foreground #FFFDF9 | Primary action/brand |
| secondary | #E7D9C7 | secondary-foreground #352B25 | Secondary action/surface |
| muted | #EFE8DE | muted-foreground #665D55 | Low-emphasis surface/metadata |
| accent | #F1E0D5 | accent-foreground #5B3A29 | Hover/selected surface nhẹ |
| destructive | #A33A32 | destructive-foreground #FFFDF9 | Destructive action |
| border | #D4C8BA | — | Divider/boundary nhẹ |
| input | #89796E | — | Control boundary cần nhận biết |
| ring | #7A4A32 | — | Focus indication |

border chỉ là divider nhẹ và không được dùng làm affordance duy nhất cho control. input có độ tương phản cao hơn để tạo biên control rõ.

### 3.3. Status tokens

Theo convention của shadcn, base token là surface và -foreground là text/icon đặt trên surface:

| Status | Surface | Foreground | Ý nghĩa hệ thống |
| --- | --- | --- | --- |
| success | #E3F0E8 | #24543E | Thành công/hoàn tất |
| warning | #FAEDD1 | #6F4708 | Cần chú ý |
| error | #F8E2DF | #812E29 | Lỗi/trạng thái nghiêm trọng |
| information | #E0EDF3 | #274F65 | Thông tin hệ thống |

Các token này cố ý khác Clay/Copper. Chưa được phép suy ra trạng thái bàn hoặc đơn chỉ từ bốn tên status trên; vocabulary nghiệp vụ cần được owner duyệt ở phase workflow.

## 4. Tailwind and shadcn integration

Implementation giữ nguyên kiến trúc Tailwind CSS 4 hiện có:

- @tailwindcss/vite tiếp tục là Vite plugin.
- Không tạo tailwind.config.js hoặc cấu hình Tailwind v3.
- components.json tiếp tục dùng cssVariables: true và trỏ đến src/styles/globals.css.
- Semantic CSS variables ở :root được expose trong @theme inline, tạo utilities như bg-background, text-primary-foreground, border-input và ring-ring.
- Button shadcn hiện có không bị sửa. Các variant của Button tự nhận primary, secondary, destructive, border, ring và radius mới qua semantic variables.
- Các sidebar token scaffold được giữ và ánh xạ vào cùng palette, nhưng không có Sidebar nào được xây ở phase này.

Cách ánh xạ này tuân theo [shadcn theming convention](https://ui.shadcn.com/docs/theming) và [Tailwind CSS theme variables](https://tailwindcss.com/docs/theme).

Light theme là phạm vi được triển khai. Neutral .dark scaffold cũ không được giữ vì nó chưa được owner duyệt và sẽ tạo một theme không cùng hệ AFTER FOUR. dark custom variant vẫn tồn tại để source component shadcn tiếp tục compile; dark theme thực tế chỉ được thêm khi có palette và yêu cầu riêng.

## 5. Typography system

### 5.1. Font families

| Token | Font stack | Dùng cho |
| --- | --- | --- |
| font-sans | Be Vietnam Pro, system sans-serif fallback | UI, heading, label, body |
| font-heading | alias của font-sans | Heading; không tạo thêm font family |
| font-mono | Geist Mono Variable, system monospace fallback | Tiền, thời gian, mã đơn, số bàn, số liệu tabular |

Utility numeric-data kết hợp Geist Mono với font-variant-numeric: tabular-nums.

### 5.2. Type scale

| Token | Font size / line-height | Trọng lượng dự kiến | Dùng cho |
| --- | --- | --- | --- |
| text-meta | 12 / 16px | 500–600 | Metadata không quan trọng |
| text-label | 14 / 20px | 500–600 | Label, table text, secondary action |
| text-body | 16 / 24px | 400–600 | Body/control mặc định |
| text-section | 18 / 26px | 600 | Section heading |
| text-page | 24 / 32px | 600–700 | Page title, important total |
| text-display | 32 / 40px | 700 | Display/empty state có kiểm soát |

Weight tokens: regular 400, medium 500, semibold 600, bold 700.

Tracking tokens:

- tracking-heading: -0.015em.
- tracking-label: 0.01em.
- text-meta có letter spacing 0.01em.

Không dùng text nhỏ hơn 14px cho action hoặc nội dung vận hành chính. text-meta chỉ dùng cho nội dung phụ.

## 6. Font loading strategy

Font được self-host từ npm packages, không gọi Google Fonts hoặc CDN runtime:

- @fontsource/be-vietnam-pro 5.3.0
- @fontsource-variable/geist-mono 5.3.0

Chiến lược:

- Be Vietnam Pro chỉ bundle weight 400, 500, 600, 700.
- Geist Mono bundle một variable font cho trục weight 100–900.
- Chỉ bundle subset Latin và Vietnamese.
- Chỉ dùng WOFF2.
- Mỗi font-face dùng font-display: swap và unicode-range.
- font-synthesis: none tránh trình duyệt tự tạo weight/style không có.
- CSS font-face nằm riêng trong src/styles/fonts.css; token và semantic mapping nằm trong globals.css.

Build production xác nhận có 10 font assets: 8 Be Vietnam Pro WOFF2 và 2 Geist Mono WOFF2. Cách này nhỏ hơn việc import toàn bộ weight, subset, WOFF và WOFF2 do package cung cấp.

Nguồn: [Be Vietnam Pro official repository](https://github.com/bettergui/BeVietnamPro), [Fontsource Be Vietnam Pro](https://fontsource.org/fonts/be-vietnam-pro/about), [Fontsource Geist Mono](https://fontsource.org/fonts/geist-mono/install).

## 7. Spacing and layout scale

Base spacing là 4px (0.25rem), tương thích scale mặc định của Tailwind:

| Step | Giá trị | Use case thường gặp |
| --- | --- | --- |
| 0 | 0 | Reset |
| 1 | 4px | Icon/internal micro gap |
| 2 | 8px | Touch target separation, compact gap |
| 3 | 12px | Control internal gap |
| 4 | 16px | Default group spacing |
| 5 | 20px | Dense section padding |
| 6 | 24px | Card/dialog padding |
| 8 | 32px | Section gap |
| 10 | 40px | Dense control height |
| 12 | 48px | Touch control/large spacing |
| 16 | 64px | Major structural spacing |

Named sizing tokens:

| Token | Giá trị | Mục đích |
| --- | --- | --- |
| spacing-control | 40px | Desktop control/dense POS row |
| spacing-target | 44px | Minimum preferred interactive target |
| spacing-touch | 48px | Tablet/mobile primary touch control |

Không tạo spacing riêng cho từng component. Component phải chọn từ scale hoặc named sizing token trên.

## 8. Radius, borders and shadows

### Radius

| Tailwind token | Giá trị | Guidance |
| --- | --- | --- |
| radius-xs / radius-sm | 4px | Badge/marker nhỏ |
| radius-md | 6px | Compact control |
| radius-lg | 8px | Button/input/default panel |
| radius-xl | 12px | Dialog/sheet surface |
| radius-2xl | 16px | Chỉ khi boundary lớn thực sự cần |
| radius-3xl / radius-4xl | 20 / 24px | Hiếm dùng |
| radius-full | 9999px | Avatar, dot, pill thực sự |

Base shadcn --radius là 8px. Button hiện dùng rounded-lg, do đó render ở 8px thay vì bo tròn quá mức.

### Borders and focus

| Token | Giá trị |
| --- | --- |
| border-width-default | 1px |
| border-width-emphasis | 2px |
| focus-ring-width | 2px |
| focus-ring-offset | 2px |

Button shadcn hiện dùng focus ring của component với màu ring; không sửa source component trong phase token. Width/offset 2px là token chuẩn cho component được xây hoặc hiệu chỉnh ở phase sau.

### Shadows

| Token | Giá trị | Dùng cho |
| --- | --- | --- |
| shadow-xs | 0 1px 2px rgb(37 33 30 / 0.04) | Elevation rất nhẹ |
| shadow-sm | 0 1px 2px rgb(37 33 30 / 0.06) | Subtle elevation |
| shadow-md | 0 8px 24px rgb(37 33 30 / 0.10) | Popover/dialog |
| shadow-lg | 0 16px 40px rgb(37 33 30 / 0.14) | Overlay cao, dùng hiếm |

Border và spacing là công cụ nhóm nội dung mặc định. Shadow chỉ thể hiện elevation.

## 9. Responsive breakpoints

Không override breakpoint của Tailwind CSS 4:

| Variant | Min width | Vai trò |
| --- | --- | --- |
| Base | dưới 640px | Mobile, một task/pane chính |
| sm | 640px | Mobile rộng/small tablet |
| md | 768px | Tablet operational |
| lg | 1024px | Desktop POS baseline |
| xl | 1280px | Desktop rộng/split context |
| 2xl | 1536px | Wide operations |

Quy tắc:

- Mobile-first; không ép layout desktop xuống màn hình nhỏ.
- Mobile/tablet dùng target 44–48px và không phụ thuộc hover.
- Desktop có thể dùng control 40px và density cao hơn, nhưng text chính vẫn tối thiểu 14px.
- Responsive component phức tạp nên dựa thêm vào available container space.
- Phase này chỉ định nghĩa token/rule; không triển khai navigation hoặc application layout.

Nguồn breakpoint: [Tailwind CSS responsive design](https://tailwindcss.com/docs/responsive-design).

## 10. Accessibility and contrast results

Tỷ lệ được tính theo công thức relative luminance của WCAG cho cặp màu phẳng:

| Pair | Contrast | Kết quả |
| --- | ---: | --- |
| foreground / background | 14.44:1 | AAA text |
| card-foreground / card | 15.72:1 | AAA text |
| primary-foreground / primary | 9.93:1 | AAA text |
| secondary-foreground / secondary | 9.94:1 | AAA text |
| muted-foreground / muted | 5.29:1 | AA text |
| accent-foreground / accent | 7.86:1 | AAA text |
| Warm white / Clay | 5.67:1 | AA text |
| Clay / background | 5.21:1 | AA text |
| destructive-foreground / destructive | 6.44:1 | AA text |
| input / background | 3.78:1 | Pass non-text boundary |
| input / card | 4.11:1 | Pass non-text boundary |
| ring / background | 6.65:1 | Pass focus contrast |
| success-foreground / success | 7.42:1 | AAA text |
| warning-foreground / warning | 7.01:1 | AAA text |
| error-foreground / error | 7.19:1 | AAA text |
| information-foreground / information | 7.35:1 | AAA text |

border chỉ đạt 1.49:1 trên background và 1.62:1 trên card. Đây là divider trang trí; không dùng nó làm ranh giới duy nhất của input, selected state hoặc focus.

Các ratio này không thay thế kiểm tra UI render thật, transparency, disabled state, ảnh nền hoặc trạng thái tương tác. Trạng thái vận hành luôn cần label/icon, không truyền đạt bằng màu đơn độc.

## 11. Files changed

| File | Thay đổi |
| --- | --- |
| frontend/src/styles/globals.css | Brand, semantic, status, typography, spacing, radius, shadow và shadcn/Tailwind mappings |
| frontend/src/styles/fonts.css | Self-hosted Be Vietnam Pro và Geist Mono font-face definitions |
| frontend/package.json | Thay Geist Sans bằng hai package font đã duyệt |
| frontend/package-lock.json | Lockfile cho font dependencies |
| docs/design/phase-3.2.2-design-tokens.md | Tài liệu phase này |

Không sửa App.tsx, main.tsx, Button, components.json, Vite config hoặc bất kỳ screen/business module nào.

Hai thư mục generated/local cũng được cập nhật bởi các lệnh bắt buộc: frontend/node_modules/ sau npm install và frontend/dist/ sau production build. Chúng không phải source implementation mới.

## 12. Remaining owner decisions

1. Phê duyệt hoặc điều chỉnh từng HEX sau khi xem specimen trên thiết bị quán.
2. Xác nhận Clay #98542F và clay tint #F1E0D5.
3. Xác nhận muted surface #EFE8DE và input border #89796E.
4. Xác nhận status vocabulary nghiệp vụ và mapping trạng thái bàn/đơn.
5. Xác định có cần dark theme hay không; hiện chỉ có light theme.
6. Cung cấp device matrix thực tế để kiểm tra breakpoint và touch target.
7. Xác nhận có cần italic Be Vietnam Pro; hiện chỉ load normal 400–700.
8. Phê duyệt chart palette trước khi xây báo cáo trực quan.
9. Cung cấp logo/wordmark chính thức khi sẵn sàng.

## 13. Verification

Kết quả kiểm tra từ frontend/:

| Kiểm tra | Kết quả |
| --- | --- |
| npm run typecheck | Pass |
| npm run lint | Pass |
| npm run build | Pass |
| npm ls --depth=0 | Pass, không có dependency conflict |
| npm audit --omit=dev | 0 runtime vulnerabilities |
| Duplicate custom properties | Không có |
| External font URL trong source | Không có |
| Production font assets | 10 WOFF2 files đúng kế hoạch |

Build xác nhận CSS Tailwind compile thành công và Button hiện tại tiếp tục lấy semantic primary, foreground, radius và focus color từ token mới. Be Vietnam Pro Latin/Vietnamese và Geist Mono Latin/Vietnamese được bundle nội bộ. Không có component hoặc screen mới.

Full npm audit còn 6 advisory ở dev dependency tree của shadcn CLI: 2 low và 4 moderate liên quan deepmerge/minimatch. Runtime audit không có lỗ hổng. Không chạy npm audit fix --force vì npm đề xuất downgrade shadcn về 1.0.0, là breaking change ngoài phạm vi phase này.
