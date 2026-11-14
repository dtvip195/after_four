# AFTER FOUR — Phase 3.2.1 Design Direction Research

> Trạng thái: đề xuất nghiên cứu, chưa phải đặc tả đã phê duyệt. Mọi mã màu, kích thước và token trong tài liệu này đều là **đề xuất** và chưa phải giá trị thương hiệu chính thức.
>
> Phạm vi: định hướng thị giác, nền tảng design system và application shell. Không định nghĩa chi tiết luồng nghiệp vụ, không triển khai UI.
>
> Công cụ: Better Design skill đã được đọc, nhưng Better Design MCP **không kết nối**, nên tài liệu không tuyên bố đã tải hoặc review bằng Better Design MCP. shadcn MCP chỉ được dùng để nghiên cứu registry/component hiện có; không component nào được cài thêm trong phase này.

## 1. Kết luận điều hành

Hướng đề xuất cho AFTER FOUR là **Modern Specialty Coffee — Warm Minimalism**: lấy cá tính “Modern Specialty” làm lớp nhận diện và dùng kỷ luật “Warm Minimal” cho toàn bộ bề mặt vận hành.

Lý do:

- Những thương hiệu specialty coffee tốt không cần nhiều hiệu ứng để tạo cảm giác premium. Blue Bottle mô tả thiết kế của họ bằng “essential design”, sự tiết chế, tinh tế, có chất liệu và vững chãi; % Arabica gắn coffee với design nhưng nhấn mạnh một đời sống đơn giản, thực tế; Onyx đặt đường nét sạch, minimalism, texture và công năng trong cùng một hệ quy chiếu. Đây là bằng chứng tốt cho một giao diện ấm, có chất liệu nhưng rất có kỷ luật. [Blue Bottle — Our Story](https://cdn.bluebottlecoffee.com/us/eng/our-story), [% Arabica — Philosophy](https://arabica.com/en/philosophy/), [Onyx — Consulting](https://onyxcoffeelab.com/en-int/pages/consulting)
- POS phải được đọc trong vài giây. Square xem floor plan là bản đồ để quản lý dòng khách và hóa đơn; Lightspeed hiển thị bàn trống/đang dùng, người phụ trách, thời gian, số khách và trạng thái đơn ngay trên floor plan. Vì vậy màu thương hiệu phải nhường ưu tiên cho tín hiệu vận hành. [Square — Create a floor plan](https://squareup.com/help/us/en/article/6427-building-your-floor-plan), [Lightspeed — Tables screen](https://k-series-support.lightspeedhq.com/hc/en-us/articles/360050328494-Understanding-the-Tables-screen)
- Cửa hàng hai tầng cần một lớp điều phối rõ ràng cho tầng và giao đồ lên tầng hai. Đây là suy luận thiết kế từ bối cảnh AFTER FOUR, không phải sao chép một POS cụ thể: floor switcher, số lượng bàn/đơn chờ theo tầng và “upstairs delivery lane” phải luôn nhìn thấy khi có việc cần xử lý.

Không chọn thuần “Contemporary Industrial”: hướng này mạnh về mật độ và tốc độ, nhưng dễ lạnh, nặng và làm AFTER FOUR giống một công cụ nhà hàng phổ thông. Không chọn thuần “Warm Minimal”: dễ chịu nhưng thiếu dấu ấn specialty nếu không có một lớp typography, hình ảnh và accent được kiểm soát.

## 2. Research summary

### 2.1. Bài học từ thương hiệu specialty coffee

| Nguồn chính thức | Quan sát có thể chuyển thành nguyên tắc | Cách áp dụng cho AFTER FOUR |
| --- | --- | --- |
| [Blue Bottle — Our Story](https://cdn.bluebottlecoffee.com/us/eng/our-story) | “Essential design”, tiết chế và tinh tế; mỗi touchpoint có mục đích; kết quả có tính thủ công, chất liệu và vững chãi. | Ít màu, ít shadow, hierarchy rõ; khoảng trắng và chất lượng typography tạo cảm giác premium thay vì trang trí. |
| [% Arabica — Philosophy](https://arabica.com/en/philosophy/) | Thương hiệu đặt coffee, design và trải nghiệm thế giới cạnh nhau, đồng thời theo đuổi sự đơn giản và thực tế. | Nhận diện có thể sắc nét, hiện đại nhưng không phô trương; UI vận hành vẫn phải trực tiếp và dễ học. |
| [Onyx — Consulting](https://onyxcoffeelab.com/en-int/pages/consulting) | Clean lines, minimalism và textures phải phục vụ công năng trong hospitality. | Dùng texture như cảm hứng vật liệu/màu nền, không dùng texture ảnh gây nhiễu trong POS; ưu tiên grid và đường phân chia rõ. |
| [Stumptown SW Washington Cafe](https://www.stumptowncoffee.com/pages/location/sw-washington) | Không gian Japandi kết hợp thiết kế Nhật có cân nhắc với độ ấm Scandinavian. | Cơ sở tốt cho warm white, gỗ/cà phê, hình khối đơn giản và nhịp spacing thoáng vừa đủ. |

Kết luận: “premium” nên đến từ độ chính xác, nhịp điệu, vật liệu và sự nhất quán; không đến từ gradient, glass effect, bo tròn mọi khối hoặc shadow dày.

### 2.2. Bài học từ POS hiện đại

- Floor plan là mô hình vận hành, không chỉ là minh họa. Square cho phép chia khu vực, dùng nhiều floor plan, thay đổi vị trí/kích thước/hình dạng bàn và đánh dấu bàn occupied ngay khi có cover count. [Square — Create a floor plan](https://squareup.com/help/us/en/article/6427-building-your-floor-plan)
- Trạng thái bàn phải quan sát nhanh. Square cung cấp chỉ báo màu và thời gian; Lightspeed cho phép xem bàn trống/đang sử dụng, nhân viên phụ trách, covers, tổng tiền, thời gian mở đơn và coursing status. [Square — Table management settings](https://squareup.com/help/us/en/article/8146-customize-table-management-settings), [Lightspeed — Tables screen](https://k-series-support.lightspeedhq.com/hc/en-us/articles/360050328494-Understanding-the-Tables-screen)
- Nhiều khu vực/tầng nên chuyển đổi trực tiếp trong cùng ngữ cảnh. Lightspeed hỗ trợ đổi giữa nhiều floor plan và mô tả floor plan như cách phản ánh layout hoặc nhóm bàn để dễ sử dụng. [Lightspeed — Tables screen](https://k-series-support.lightspeedhq.com/hc/en-us/articles/360050328494-Understanding-the-Tables-screen), [Lightspeed — Floor plans and tables](https://k-series-support.lightspeedhq.com/hc/en-us/articles/1260804656689-About-floor-plans-and-tables)
- Tốc độ và độ bền của luồng thao tác quan trọng trong giờ cao điểm. Toast mô tả terminal front-of-house ưu tiên speed/durability, order-entry cho high-volume rushes, và cho phép đổi display mode/layout/light-dark để phục vụ nhanh, thoải mái hơn. [Toast — Point of Sale](https://pos.toasttab.com/products/point-of-sale)

Hệ quả thiết kế: tránh dashboard toàn card; ưu tiên mặt phẳng làm việc, divider, table/floor map, trạng thái rõ và action gần đối tượng nó tác động.

### 2.3. Desktop-first và tablet

- Desktop là không gian điều phối: có thể đồng thời giữ global navigation, floor context, workspace và inspector.
- Tablet là không gian thực hiện: chỉ một task chính tại một thời điểm; thông tin phụ mở bằng sheet/drawer; action chính đặt gần ngón tay và không bị che.
- Layout nên thích nghi theo **không gian thật có sẵn**, không dựa vào tên thiết bị hay orientation. Apple khuyến nghị progressive disclosure và có thể chuyển giữa sidebar/tab bar theo không gian; Tailwind v4 cung cấp các breakpoint mặc định `md` 768px và `lg` 1024px phù hợp để định nghĩa tablet/desktop ở phase đầu. [Apple — Layout](https://developer.apple.com/design/human-interface-guidelines/layout), [Tailwind CSS — Responsive design](https://tailwindcss.com/docs/responsive-design)

## 3. Ba hướng thị giác

### A. Warm Minimal

**Ý tưởng:** yên tĩnh, dễ chịu, ít lớp trang trí; cảm giác như một quầy cafe sáng, vật liệu tự nhiên và được chăm chút.

**Palette đề xuất — chưa phê duyệt**

| Vai trò | HEX đề xuất | Mục đích |
| --- | --- | --- |
| Warm canvas | `#F7F3EC` | Nền chính ấm hơn white, giảm chói khi dùng lâu. |
| Surface | `#FFFDF9` | Tách khu vực làm việc mà không cần shadow. |
| Coffee | `#5B3A29` | Primary/action và dấu ấn cafe. |
| Beige | `#E7D9C7` | Secondary surface, selected nhẹ. |
| Charcoal | `#25211E` | Text chính, mềm hơn black tuyệt đối. |
| Muted text | `#665D55` | Metadata vẫn đủ tương phản trên nền ấm. |

Mỗi màu có vai trò rõ: coffee cho hành động/brand, beige cho lớp nền thứ cấp, charcoal cho nội dung. Không dùng beige hoặc brown làm mã trạng thái nghiệp vụ.

**Typography:** Geist Variable cho UI vận hành; sentence case; heading weight 600–700, body 400–500. Be Vietnam Pro là lựa chọn thay thế cần owner phê duyệt nếu muốn một giọng Việt rõ hơn; chính tác giả font mô tả letterform/diacritic tiếng Việt đã được tinh chỉnh cho readability. [Geist — Vercel Font](https://vercel.com/font), [Be Vietnam Pro — official repository](https://github.com/bettergui/BeVietnamPro)

**Layout:** grid đều, khoảng trắng vừa phải, divider thay card; các nhóm chức năng phẳng và liền mạch. Operational canvas không đặt trong một “card lớn” dư thừa.

**Component:** radius 6–8px; border 1px; shadow hầu như không có; button primary coffee đặc; input/select surface sáng; status badge có nhãn + icon, không chỉ màu.

**Ưu điểm**

- Dễ chịu trong ca làm dài, premium nhưng gần gũi.
- Phù hợp với warm white/coffee brown đã định hướng.
- Ít hiệu ứng nên dễ giữ UI nhất quán và nhanh.

**Nhược điểm**

- Có nguy cơ thành “neutral SaaS” nếu typography, iconography và microcopy không có cá tính.
- Quá nhiều beige sẽ làm tín hiệu cảnh báo mất nổi bật.
- Khoảng trắng quá rộng sẽ làm giảm mật độ POS.

**Mức phù hợp POS:** cao, nếu mật độ được kiểm soát theo workspace và màu semantic được tách khỏi màu thương hiệu.

**Visual references:** [Blue Bottle design ethos](https://cdn.bluebottlecoffee.com/us/eng/our-story) cho restraint/subtlety; [Stumptown Japandi cafe](https://www.stumptowncoffee.com/pages/location/sw-washington) cho sự cân bằng giữa tính cân nhắc và độ ấm.

### B. Modern Specialty

**Ý tưởng:** hiện đại, có tính biên tập và thể hiện nguồn gốc/craft của specialty coffee; rõ ràng hơn Warm Minimal về cá tính.

**Palette đề xuất — chưa phê duyệt**

| Vai trò | HEX đề xuất | Mục đích |
| --- | --- | --- |
| Parchment canvas | `#F3F0EA` | Nền editorial trung tính ấm. |
| Porcelain surface | `#FFFEFA` | Bề mặt nội dung sạch. |
| Espresso | `#3F2A20` | Brand/primary đậm, gợi rang xay. |
| Ink | `#202421` | Text và data có độ sắc nét cao. |
| Moss | `#55624A` | Accent tự nhiên cho nội dung thương hiệu, không dùng mặc định cho status. |
| Clay | `#B86F45` | Accent có năng lượng cho highlight có kiểm soát. |
| Parchment border | `#D8CCBC` | Chia lớp nhẹ, giữ chất ấm. |

Moss và clay chỉ là accent nhận diện. Nếu cả hai cùng xuất hiện thường xuyên, hệ màu sẽ bị tạp; khuyến nghị owner chọn tối đa **một** accent phụ.

**Typography:** Geist cho dữ liệu và control; có thể dùng Be Vietnam Pro 600–700 cho heading/empty state nếu sau test dấu tiếng Việt cho kết quả tốt. Dùng tabular numerals cho tiền, giờ, mã đơn và số bàn.

**Layout:** hierarchy kiểu editorial ở vùng ít rủi ro như page heading, empty state, menu story; strict grid ở POS/table/order. Có thể dùng nhãn nhỏ uppercase cho metadata ngắn, nhưng nội dung và action vẫn sentence case.

**Component:** bề mặt phẳng, border rõ; selected state dùng fill nhẹ + border 2px + label/icon; badge vuông mềm; hình ảnh sản phẩm có crop nhất quán; accent chỉ ở active/brand moments.

**Ưu điểm**

- Khác biệt hơn và kể được câu chuyện specialty coffee.
- Premium nhưng không xa cách nếu nền vẫn ấm.
- Có đủ “signature” để tránh generic SaaS.

**Nhược điểm**

- Dễ quá tay với accent, label uppercase hoặc layout bất đối xứng.
- Typography mang tính editorial nếu đi vào bảng/đơn hàng sẽ làm giảm tốc độ đọc.
- Cần governance token chặt hơn Warm Minimal.

**Mức phù hợp POS:** rất cao khi kết hợp kỷ luật của A; chỉ trung bình nếu áp dụng editorial styling vào mọi màn hình.

**Visual references:** [% Arabica philosophy](https://arabica.com/en/philosophy/) cho coffee + design + simplicity; [Onyx Consulting](https://onyxcoffeelab.com/en-int/pages/consulting) cho minimalism/texture đi cùng function; [Blue Bottle Our Coffee](https://bluebottlecoffee.com/us/eng/our-coffee) cho craft, precision và sự tập trung vào bản chất sản phẩm.

### C. Contemporary Industrial

**Ý tưởng:** gọn, mạnh, hiệu suất cao; lấy cảm hứng từ quầy bar, thiết bị rang và nhịp vận hành nhà hàng.

**Palette đề xuất — chưa phê duyệt**

| Vai trò | HEX đề xuất | Mục đích |
| --- | --- | --- |
| Concrete canvas | `#EDEBE6` | Nền trung tính, ít “kem” hơn A/B. |
| Work surface | `#F8F7F4` | Bề mặt thao tác. |
| Iron | `#272A28` | Text/header/action đậm. |
| Espresso | `#4A352A` | Giữ liên hệ cafe. |
| Steel | `#68706B` | Metadata/secondary. |
| Amber | `#B56A2D` | Accent công nghiệp, chỉ cho highlight có chủ đích. |
| Hard border | `#BEBAB2` | Cấu trúc và phân vùng rõ. |

**Typography:** Geist Variable hoặc Inter; weight 500–700; size/line-height gọn hơn nhưng không dưới 14/20 cho nội dung vận hành chính. Geist nhấn mạnh simplicity, clarity và functionality, phù hợp với hướng này. [Geist — Vercel Font](https://vercel.com/font)

**Layout:** density cao, rail/toolbars rõ, nhiều divider; ít khoảng trắng hơn; bảng và queue là cấu trúc chính. Không dùng nền charcoal cho toàn ứng dụng trong light theme vì dễ nặng khi làm việc lâu.

**Component:** radius 4–6px; border tương phản hơn; button chắc; toolbar compact; hầu như không shadow; status có cạnh/marker mạnh.

**Ưu điểm**

- Đọc nhanh, chịu được mật độ dữ liệu cao.
- Tạo cảm giác công cụ đáng tin cậy, phù hợp giờ cao điểm.
- Giảm nguy cơ “card soup”.

**Nhược điểm**

- Lạnh và ít hospitality hơn mục tiêu thương hiệu.
- Density/border quá cao có thể gây mệt thị giác.
- Dễ giống phần mềm nhà hàng generic.

**Mức phù hợp POS:** cao về vận hành, trung bình về thương hiệu. Có thể mượn density và border discipline, không nên chọn làm ngôn ngữ chính.

**Visual references:** [Toast POS](https://pos.toasttab.com/products/point-of-sale) cho speed/durability/layout tùy chỉnh; [Lightspeed Tables screen](https://k-series-support.lightspeedhq.com/hc/en-us/articles/360050328494-Understanding-the-Tables-screen) cho mật độ thông tin trạng thái; [Stumptown Our Story](https://www.stumptowncoffee.com/pages/our-story) cho tinh thần craft thực dụng.

## 4. So sánh và khuyến nghị

| Tiêu chí | A. Warm Minimal | B. Modern Specialty | C. Contemporary Industrial |
| --- | --- | --- | --- |
| Ấm áp / hospitality | Rất cao | Cao | Trung bình |
| Cá tính specialty coffee | Trung bình | Rất cao | Trung bình |
| Tốc độ quét POS | Cao | Cao nếu giữ strict grid | Rất cao |
| Dùng lâu ít mỏi | Rất cao | Cao | Trung bình |
| Nguy cơ generic | Trung bình | Thấp | Cao |
| Nguy cơ trang trí quá mức | Thấp | Trung bình | Thấp |
| Governance cần thiết | Thấp–trung bình | Cao | Trung bình |
| Phù hợp tổng thể | Cao | **Cao nhất** | Trung bình–cao |

**Khuyến nghị:** duyệt B làm hướng thương hiệu, nhưng triển khai với nền, spacing, radius và restraint của A. C chỉ đóng góp mật độ và border discipline cho bảng/queue. Công thức ngắn:

> **B personality + A restraint + C operational density**

Nguyên tắc quyết định: nếu một lựa chọn làm giao diện “đẹp hơn” nhưng làm trạng thái bàn, action hoặc số tiền chậm đọc hơn, chọn phương án vận hành rõ hơn.

## 5. Design tokens đề xuất

### 5.1. Brand và neutral colors

Tất cả giá trị dưới đây là **đề xuất chưa phê duyệt** cho hướng được khuyến nghị.

| Token khái niệm | HEX đề xuất | Vai trò | Contrast dự kiến |
| --- | --- | --- | --- |
| `background` | `#F7F3EC` | App canvas | — |
| `surface` | `#FFFDF9` | Panel/control surface | — |
| `foreground` | `#25211E` | Text chính | 14.44:1 trên `background` |
| `muted-foreground` | `#665D55` | Text phụ | 5.82:1 trên `background` |
| `primary` | `#5B3A29` | Action chính/brand | 9.12:1 so với `background` |
| `primary-foreground` | `#FFFDF9` | Text/icon trên primary | 9.93:1 trên `primary` |
| `secondary` | `#E7D9C7` | Selected nhẹ/secondary | — |
| `secondary-foreground` | `#352B25` | Text trên secondary | 9.94:1 trên `secondary` |
| `accent` | `#98542F` | Highlight có kiểm soát | 5.21:1 so với `background` |
| `focus` | `#7A4A32` | Focus ring | 6.65:1 so với `background` |
| `border-subtle` | `#D4C8BA` | Divider/decorative boundary | Không dùng làm ranh giới duy nhất của control |
| `border-control` | `#89796E` | Ranh giới input/control | Cần xác nhận trên từng surface |

Các ratio là phép tính sơ bộ trên cặp màu phẳng. Chúng không thay thế kiểm tra contrast trên trạng thái render thật, anti-aliasing, overlay, disabled state hoặc ảnh nền.

### 5.2. Semantic colors

Màu semantic không được thay bằng brown/beige thương hiệu. Mỗi trạng thái luôn có text/icon/label cùng màu.

| Trạng thái | Foreground đề xuất | Background đề xuất | Contrast dự kiến | Ví dụ |
| --- | --- | --- | --- | --- |
| Success | `#24543E` | `#E3F0E8` | 7.42:1 | Đã thanh toán, hoàn tất |
| Warning | `#6F4708` | `#FAEDD1` | 7.01:1 | Sắp quá thời gian, cần chú ý |
| Danger | `#812E29` | `#F8E2DF` | 7.19:1 | Lỗi, hủy, quá hạn nghiêm trọng |
| Info | `#274F65` | `#E0EDF3` | 7.35:1 | Đồng bộ, thông tin hệ thống |

Không phê duyệt mapping “màu ↔ trạng thái bàn” ở phase này. Owner phải xác nhận vocabulary trước, ví dụ: trống, đang phục vụ, chờ món, cần giao tầng hai, chờ thanh toán, cần dọn.

### 5.3. Typography

**Đề xuất primary:** Geist Variable vì đã phù hợp nền tảng hiện tại và được thiết kế quanh simplicity, clarity, functionality. Phải test đầy đủ tiếng Việt thực tế trước khi khóa. **Đề xuất thay thế cần phê duyệt:** Be Vietnam Pro, được thiết kế riêng với letterform/diacritic tiếng Việt và readability là mục tiêu. [Geist — Vercel Font](https://vercel.com/font), [Be Vietnam Pro — official repository](https://github.com/bettergui/BeVietnamPro)

| Token | Size / line-height | Weight | Dùng cho |
| --- | --- | --- | --- |
| `text-xs` | 12 / 16px | 500–600 | Metadata phụ, không dùng cho action chính |
| `text-sm` | 14 / 20px | 400–600 | Bảng, label, secondary action |
| `text-base` | 16 / 24px | 400–600 | Body/control mặc định |
| `text-lg` | 18 / 26px | 600 | Section title, tổng tiền phụ |
| `text-xl` | 24 / 32px | 600–700 | Page title, total quan trọng |
| `text-2xl` | 32 / 40px | 700 | Display/empty state có kiểm soát |

Quy tắc:

- Không dùng weight dưới 400 trong ứng dụng vận hành.
- Dùng `font-variant-numeric: tabular-nums` cho tiền, timer, mã đơn, covers và số bàn.
- Không dùng all caps cho câu hoặc action; chỉ dùng cho metadata rất ngắn nếu test tiếng Việt vẫn dễ đọc.
- Không dùng font serif trong POS core. Nếu sau này cần editorial/marketing, tách token và phạm vi riêng.

### 5.4. Spacing, sizing và density

Scale 4px đề xuất: `0, 4, 8, 12, 16, 20, 24, 32, 40, 48, 64`.

- Control desktop mặc định: cao 40px.
- Control/table row cần thao tác thường xuyên: tối thiểu 44px.
- Primary touch action trên tablet: 48–56px.
- Khoảng cách giữa các touch target: ít nhất 8px khi có thể.
- Nội dung POS dùng density “comfortable”; trang cấu hình/bảng có thể có tùy chọn compact sau này, không mặc định.

WCAG 2.2 AA yêu cầu target tối thiểu 24×24 CSS px hoặc đủ khoảng cách; ngưỡng enhanced là 44×44. Apple cũng khuyến nghị hit target ít nhất 44×44pt. Với POS cảm ứng, AFTER FOUR nên chủ động chọn 44–48px thay vì chỉ đạt mức tối thiểu. [W3C — Target Size Minimum](https://www.w3.org/WAI/WCAG22/Understanding/target-size-minimum), [Apple — UI Design Tips](https://developer.apple.com/design/tips/)

### 5.5. Radius, shadows và borders

**Radius đề xuất**

| Token | Giá trị | Dùng cho |
| --- | --- | --- |
| `radius-xs` | 4px | Badge nhỏ, cell marker |
| `radius-sm` | 6px | Input, button, table item |
| `radius-md` | 8px | Section/panel |
| `radius-lg` | 12px | Dialog/sheet surface |
| `radius-full` | 999px | Avatar, status dot, pill thật sự |

Không bo tròn mọi section. Các vùng liên tục nên dùng divider và alignment thay vì nhiều card rời.

**Shadow đề xuất**

| Token | Giá trị | Dùng cho |
| --- | --- | --- |
| `shadow-none` | `none` | Mặc định |
| `shadow-xs` | `0 1px 2px rgb(37 33 30 / 0.06)` | Elevation rất nhẹ |
| `shadow-md` | `0 8px 24px rgb(37 33 30 / 0.10)` | Popover/dialog |
| `shadow-lg` | `0 16px 40px rgb(37 33 30 / 0.14)` | Overlay tạm thời |

Border mặc định 1px; selected/drag target có thể 2px. Shadow chỉ biểu thị elevation, không dùng để thay border hoặc hierarchy.

### 5.6. Focus và interaction states

- Keyboard focus: ring 2px `#7A4A32`, offset 2px. Trên nền primary dùng ring sáng/two-tone để vẫn phân biệt.
- Hover: thay đổi fill hoặc border nhẹ 4–8%; không làm layout dịch chuyển.
- Pressed: state rõ hơn hover; không dựa duy nhất vào scale/animation.
- Selected: phối hợp background + border + icon/text; không dùng màu đơn độc.
- Disabled: giảm emphasis nhưng giữ label đọc được; thêm semantic disabled/cursor, không chỉ opacity thấp.
- Loading: giữ chiều rộng control, khóa double submit và mô tả trạng thái bằng text/accessible name khi cần.
- Motion: 120–180ms cho micro-interaction; tôn trọng `prefers-reduced-motion`; không animate timer/status liên tục.

W3C nêu focus indicator dễ đạt nhất bằng perimeter 2px và yêu cầu mức thay đổi tương phản 3:1 trong tiêu chí **Focus Appearance cấp AAA**; đây là mục tiêu chất lượng đề xuất, không được ghi nhầm thành yêu cầu AA. Control/state có ý nghĩa vẫn cần non-text contrast phù hợp ở cấp AA. [W3C — Focus Appearance](https://www.w3.org/WAI/WCAG22/Understanding/focus-appearance), [W3C — Non-text Contrast](https://www.w3.org/WAI/WCAG22/Understanding/non-text-contrast.html)

### 5.7. Responsive breakpoints

Giữ breakpoint mặc định Tailwind v4 để tránh cấu hình sớm không cần thiết: `sm 640`, `md 768`, `lg 1024`, `xl 1280`, `2xl 1536`. [Tailwind CSS — Responsive design](https://tailwindcss.com/docs/responsive-design)

| Khoảng | Vai trò đề xuất | Hành vi shell |
| --- | --- | --- |
| `<768px` | Compact/fallback, chưa phải mục tiêu POS chính | Một pane; navigation overlay; không cam kết đầy đủ POS cho đến khi owner yêu cầu mobile. |
| `768–1023px` | Tablet operational | Nav rail 64–72px; secondary context trong sheet/drawer; action chạm 48px+. |
| `1024–1279px` | Desktop chuẩn | Sidebar 216–240px; workspace chính; inspector mở theo nhu cầu. |
| `1280–1535px` | Desktop rộng | Split view ổn định; inspector 320–360px nếu có ích. |
| `≥1536px` | Wide operations | Hiển thị thêm context, không kéo line length vô hạn. |

Breakpoint chỉ là điểm khởi đầu. Component phức tạp nên dùng container query theo không gian thật; Apple cũng khuyến nghị quyết định layout theo available space thay vì device/orientation. [Apple — Layout](https://developer.apple.com/design/human-interface-guidelines/layout), [Tailwind CSS — Responsive design](https://tailwindcss.com/docs/responsive-design)

## 6. POS application shell concept

### 6.1. Information architecture cấp cao

Global destinations đề xuất:

1. POS
2. Bàn
3. Đơn hàng
4. Menu
5. Báo cáo / Quản lý (tùy quyền)
6. Cài đặt (secondary)

Đây là IA đề xuất, chưa khóa. Với đội đầu tiên khoảng ba nhân viên và owner trực tiếp vận hành, shell phải cho phép di chuyển nhanh nhưng không đưa mọi công cụ quản trị vào luồng bán hàng. Phân quyền là phase nghiệp vụ sau; ở phase này chỉ cần chừa cấu trúc cho role-aware navigation.

### 6.2. Desktop shell

```text
┌──────────────┬────────────────────────────────────────────────────┐
│ Global nav   │ Top operations bar: ca làm · sync · user · alerts │
│ 216–240px    ├────────────────────────────────────────────────────┤
│              │ Context bar: Tầng 1 | Tầng 2 · search · actions   │
│ POS          ├───────────────────────────────────┬────────────────┤
│ Bàn          │                                   │ Context rail   │
│ Đơn hàng     │ Main workspace                    │ 320–360px      │
│ Menu         │ floor map / order queue / table  │ selection /   │
│ Quản lý      │                                   │ order summary │
└──────────────┴───────────────────────────────────┴────────────────┘
```

**Global nav:** persistent ở desktop, có chế độ icon collapse. Giữ destination ổn định, không trộn status filter vào global nav.

**Top operations bar (56–64px):** tên cửa hàng/ca, connectivity/sync, nhân viên hiện tại, thông báo có ưu tiên. Không lặp page title.

**Context bar (48–56px):** floor switcher `Tầng 1` / `Tầng 2`, số bàn đang phục vụ và số việc chờ theo tầng; search/filter; page actions. Floor switcher phải giữ vị trí ổn định giữa view Bàn và POS nếu tầng là context chung.

**Main workspace:**

- View Bàn: floor map/grid là nội dung chính, không bị nhốt trong card.
- View Đơn: queue/list bên trái, detail bên phải; timer và trạng thái luôn ở vị trí cố định.
- View POS: catalog/search và current order dùng split view; tổng tiền/action thanh toán không cuộn khỏi vùng nhìn thấy.

**Context rail:** chỉ xuất hiện khi có selection hoặc ở desktop rộng; chứa chi tiết bàn/đơn và action gần đối tượng. Ở 1024px có thể chuyển thành sheet để bảo toàn diện tích.

### 6.3. Hai tầng và giao đồ lên tầng hai

Đề xuất một **Upstairs delivery lane** — vùng điều phối cố định trong context bar hoặc rail khi có đồ cần giao. Mỗi item tối thiểu có: số bàn, thời gian chờ, số món/tóm tắt, trạng thái và người nhận việc nếu có. Đây là đề xuất suy luận từ bối cảnh AFTER FOUR và cần kiểm chứng với owner/staff.

Quy tắc:

- Badge trên `Tầng 2` hiển thị số việc cần chú ý, nhưng không là tín hiệu duy nhất.
- Việc giao tầng hai không chỉ tồn tại dưới dạng toast vì toast biến mất và dễ bỏ sót.
- Trạng thái bàn kết hợp fill/border + icon/label. Timer chỉ chuyển warning/danger theo ngưỡng đã được owner phê duyệt.
- Khi chuyển tầng, giữ filter/search hợp lý và hiển thị rõ tên tầng; không để người dùng thao tác nhầm trên floor khác.
- Có “All floors overview” cho owner nếu sau nghiên cứu workflow chứng minh cần; staff mặc định làm việc theo một tầng để giảm tải.

Square và Lightspeed đều cho thấy giá trị của floor plan, area grouping, real-time table status, elapsed time và người phụ trách; đề xuất trên mở rộng các pattern đó cho bài toán giao đồ giữa hai tầng. [Square — Floor plan](https://squareup.com/help/us/en/article/6427-building-your-floor-plan), [Square — Table management](https://squareup.com/gb/en/point-of-sale/restaurants/features/table-management-system), [Lightspeed — Tables screen](https://k-series-support.lightspeedhq.com/hc/en-us/articles/360050328494-Understanding-the-Tables-screen)

### 6.4. Tablet shell

- Nav rail 64–72px ở landscape; nếu không gian không đủ, dùng off-canvas. Floor switcher vẫn visible trong context bar.
- Một workspace chính mỗi viewport. Chi tiết bàn/đơn mở bằng right Sheet ở landscape hoặc bottom Drawer ở portrait.
- Primary action đặt sticky ở đáy sheet/workspace, cao 48–56px; tránh đặt destructive action sát primary.
- Table map cho phép pan có kiểm soát, nhưng status/legend và tầng hiện tại không cuộn mất.
- Không dựa vào hover/tooltip. Icon-only action phải có accessible name và, nếu tần suất thấp, nên có label.
- Keyboard workflow vẫn được hỗ trợ khi tablet gắn bàn phím; touch target 44–48px.

Official shadcn docs xác nhận Sidebar hỗ trợ `icon`/`offcanvas` collapse và mobile state, còn Sheet hỗ trợ mở từ mọi cạnh; đây là các primitive phù hợp để triển khai shell sau khi direction được duyệt. [shadcn/ui — Sidebar](https://ui.shadcn.com/docs/components/sidebar), [shadcn/ui — Sheet](https://ui.shadcn.com/docs/components/sheet)

## 7. Component recommendations

shadcn MCP đã được dùng để kiểm tra registry/pattern; các primitive liên quan hiện có gồm Sidebar, Tabs, Table/Data Table, Badge, Sheet, Drawer, Dialog, Dropdown Menu, Command và Tooltip. Không có component nào được thêm trong phase nghiên cứu.

| Nhu cầu | Primitive/approach đề xuất | Guardrail |
| --- | --- | --- |
| Global navigation | `SidebarProvider`, `Sidebar`, `SidebarInset`, `SidebarTrigger` | Không sao chép nguyên aesthetic dashboard mẫu; map vào token AFTER FOUR. |
| Floor switcher | Tabs hoặc segmented control | Luôn hiển thị tên tầng + count; attention không chỉ qua màu badge. |
| Order/menu administration | Table/Data Table | Table cho dữ liệu dạng hàng; không dùng để giả floor map. |
| Status | Badge + icon/text | Badge là tín hiệu bổ sung, không thay accessible label. |
| Tablet detail | Sheet/Drawer | Preserve context; primary action sticky; focus management đúng. |
| Confirm destructive | Alert Dialog/Dialog | Chỉ dùng cho quyết định cần dừng luồng; không xác nhận mọi thao tác. |
| Secondary actions | Dropdown Menu | Action thường dùng phải lộ diện, không giấu hết trong menu. |
| Quick find | Command | Tìm bàn/đơn/món; cần labels và empty state rõ. |
| Icon explanation | Tooltip | Chỉ bổ sung ở desktop; không là nguồn label duy nhất trên touch. |
| Content grouping | Flat section + divider trước, Card sau | Card chỉ khi một khối thật sự có boundary/behavior độc lập. |
| Actions | Button variants: primary, secondary, outline, ghost, destructive | Mỗi view chỉ một primary emphasis rõ. |
| Form | Field/Label/Input/Select/Textarea + inline message | Label không thay bằng placeholder; lỗi gần field và có summary khi dài. |

Lucide React tiếp tục là icon family duy nhất theo quy ước dự án. Icon stroke/size phải đồng nhất; không trộn emoji hoặc text glyph làm icon chức năng.

## 8. Accessibility considerations

- **Text contrast:** tối thiểu 4.5:1 cho text thường và 3:1 cho large text theo WCAG 2.2 AA. [W3C — Contrast Minimum](https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum)
- **Non-text contrast:** ranh giới control, focus và state có ý nghĩa phải đạt yêu cầu 3:1 phù hợp; `border-subtle` không được dùng làm affordance duy nhất. [W3C — Non-text Contrast](https://www.w3.org/WAI/WCAG22/Understanding/non-text-contrast.html)
- **Touch/pointer:** WCAG AA là 24×24 CSS px hoặc đủ spacing, nhưng POS tablet nên theo mục tiêu 44–48px để giảm chạm nhầm. [W3C — Target Size Minimum](https://www.w3.org/WAI/WCAG22/Understanding/target-size-minimum), [Apple — UI Design Tips](https://developer.apple.com/design/tips/)
- **Keyboard:** mọi action chính, tabs, menu, dialog và table selection phải đi được bằng keyboard; focus không bị sticky header/sheet che; focus ring 2px rõ.
- **Không dùng màu đơn độc:** trạng thái bàn/đơn kết hợp label, icon, border/fill và khi cần pattern. Legend luôn có text.
- **Typography:** không dùng text chính nhỏ hơn 14px; tránh uppercase dài; test dấu tiếng Việt (`ă â ê ô ơ ư đ` và đầy đủ thanh) ở mọi weight.
- **Live updates:** timer, đơn mới, sync/offline và giao tầng hai dùng live-region có mức ưu tiên phù hợp; không để screen reader đọc lại timer từng giây.
- **Motion:** hỗ trợ reduced motion; không dùng pulse liên tục cho trạng thái thường; animation không thay feedback tĩnh.
- **Error/recovery:** lỗi nói rõ điều gì xảy ra, dữ liệu có được giữ không và action tiếp theo; network/offline phải có persistent state thay vì toast duy nhất.
- **Zoom/reflow:** test 200% zoom trên desktop và text scaling; action quan trọng không bị cắt. Layout chuyển sang một pane thay vì horizontal scroll cho toàn trang.
- **Ngôn ngữ:** microcopy tiếng Việt ngắn, động từ rõ; tránh viết tắt nội bộ nếu chưa có glossary và training.

## 9. Quyết định cần owner phê duyệt

1. Chấp thuận hướng **Modern Specialty Coffee — Warm Minimalism**, hay chọn A/B/C thuần?
2. Giữ Geist Variable làm font chính hay đánh giá Be Vietnam Pro làm primary? Nếu dùng cả hai, phạm vi chính xác là gì?
3. Duyệt coffee brown `#5B3A29` và warm background `#F7F3EC`, hay cung cấp màu/logo thương hiệu có sẵn?
4. Chọn tối đa một accent phụ: clay/copper, moss, hoặc không dùng accent ngoài coffee brown?
5. Tên và định nghĩa chính thức cho từng trạng thái bàn/đơn; ngưỡng thời gian warning/danger?
6. “Giao tầng hai” vận hành thế nào: ai nhận việc, khi nào bắt đầu/kết thúc, có cần xác nhận giao, và có cần âm thanh?
7. Thiết bị mục tiêu thực tế: độ phân giải desktop, kích thước tablet, landscape/portrait, có keyboard/mouse hay không?
8. Tablet là POS đầy đủ hay companion cho bàn/giao món?
9. IA global: POS và Bàn là hai destination riêng hay cùng một workspace có mode switch?
10. Owner và staff thấy những destination nào trong ca làm; có cần “owner overview” đa tầng ngay ở MVP?
11. Mobile `<768px` chỉ là fallback hay cần hỗ trợ nghiệp vụ đầy đủ?
12. Light theme là phạm vi MVP hay cần dự trù dark theme ngay từ token phase?
13. Cách viết thương hiệu chính thức: `AFTER FOUR`, `After Four`, logo/wordmark và tone tiếng Việt?

## 10. Đề xuất bước kế tiếp sau phê duyệt

Phase 3.2.2 nên khóa một direction và tạo một token sheet nhỏ có thể kiểm thử, trước khi xây màn hình:

1. Chốt các quyết định owner ở mục 9.
2. Ánh xạ token đề xuất vào semantic shadcn variables ở dạng draft.
3. Tạo typography/color/spacing specimen và kiểm contrast render thật.
4. Prototype application shell desktop + tablet bằng layout không có business logic.
5. Test với 3 tình huống: giờ cao điểm, nhiều bàn tầng hai cần giao, và mất kết nối.
6. Chỉ sau review mới mở rộng thành screen/component implementation.

## 11. Nguồn chính

### Brand và visual identity

- [Blue Bottle — Our Story / Design Ethos](https://cdn.bluebottlecoffee.com/us/eng/our-story)
- [% Arabica — Philosophy](https://arabica.com/en/philosophy/)
- [Onyx Coffee Lab — Consulting](https://onyxcoffeelab.com/en-int/pages/consulting)
- [Stumptown — SW Washington Cafe](https://www.stumptowncoffee.com/pages/location/sw-washington)
- [Stumptown — Our Story](https://www.stumptowncoffee.com/pages/our-story)

### POS và restaurant operations

- [Square — Create a floor plan](https://squareup.com/help/us/en/article/6427-building-your-floor-plan)
- [Square — Customize table management settings](https://squareup.com/help/us/en/article/8146-customize-table-management-settings)
- [Square — Table Management System](https://squareup.com/gb/en/point-of-sale/restaurants/features/table-management-system)
- [Lightspeed — Understanding the Tables screen](https://k-series-support.lightspeedhq.com/hc/en-us/articles/360050328494-Understanding-the-Tables-screen)
- [Lightspeed — About floor plans and tables](https://k-series-support.lightspeedhq.com/hc/en-us/articles/1260804656689-About-floor-plans-and-tables)
- [Toast — Point of Sale](https://pos.toasttab.com/products/point-of-sale)

### Accessibility, responsive và typography

- [W3C — WCAG 2.2 Contrast Minimum](https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum)
- [W3C — WCAG 2.2 Non-text Contrast](https://www.w3.org/WAI/WCAG22/Understanding/non-text-contrast.html)
- [W3C — WCAG 2.2 Target Size Minimum](https://www.w3.org/WAI/WCAG22/Understanding/target-size-minimum)
- [W3C — Focus Appearance](https://www.w3.org/WAI/WCAG22/Understanding/focus-appearance)
- [Apple — Layout](https://developer.apple.com/design/human-interface-guidelines/layout)
- [Apple — UI Design Tips](https://developer.apple.com/design/tips/)
- [Tailwind CSS — Responsive Design](https://tailwindcss.com/docs/responsive-design)
- [Geist — Vercel Font](https://vercel.com/font)
- [Be Vietnam Pro — official repository](https://github.com/bettergui/BeVietnamPro)
- [shadcn/ui — Sidebar](https://ui.shadcn.com/docs/components/sidebar)
- [shadcn/ui — Sheet](https://ui.shadcn.com/docs/components/sheet)
