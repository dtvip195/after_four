# AFTER FOUR — Phase 3.4.6 Upstairs Delivery UI

> Trạng thái: implemented and browser-verified.
>
> Phạm vi: UI prototype tại `/upstairs-delivery`, dùng local state và fixture độc lập. Không có delivery workflow, order lifecycle, backend, realtime hoặc persistence.

## 1. Mục tiêu và kết quả

Upstairs Delivery cung cấp một workspace vận hành demo để nhận biết nhanh các đơn cần đưa bằng thang máy lên tầng 2. Queue nhóm đơn theo ba trạng thái minh họa, cho phép tìm kiếm, lọc, xem chi tiết, đổi trạng thái và xác nhận đã giao ở local UI.

Feature không dùng hoặc thay đổi `useDemoOrder`, Payment state, Table state, Kitchen placeholder hay dữ liệu ngoài trang. Reload đưa toàn bộ queue về fixture ban đầu.

## 2. Component architecture

```text
src/features/upstairs-delivery/
├── components/
│   ├── delivery-detail-content.tsx
│   ├── delivery-detail.tsx
│   ├── delivery-filters.tsx
│   ├── delivery-order-card.tsx
│   ├── delivery-queue-group.tsx
│   └── delivery-status-badge.tsx
├── data/
│   └── delivery-demo-data.ts
├── hooks/
│   ├── use-demo-delivery-queue.ts
│   └── use-media-query.ts
├── pages/
│   └── upstairs-delivery-page.tsx
└── types/
    └── upstairs-delivery.ts
```

- `UpstairsDeliveryPage`: owner của search, filter, selection, responsive detail state và status announcement.
- `useDemoDeliveryQueue`: nguồn local state duy nhất cho sáu delivery snapshots và status mutation.
- `DeliveryQueueGroup`: một nhóm status, count và empty state riêng.
- `DeliveryOrderCard`: summary có order code, table, time, quantity, items và selected state.
- `DeliveryDetail`: desktop aside hoặc mobile/tablet Sheet.
- `DeliveryDetailContent`: destination, items, note và demo actions dùng chung giữa hai presentation.
- `DeliveryStatusBadge`: mapping text/icon/semantic token tập trung.
- `delivery-demo-data.ts`: fixture, vocabulary label và total-quantity helper.

Không thêm dependency và không sửa Design Tokens hoặc shared shadcn source.

## 3. Demo fixtures

Sáu snapshot độc lập được tạo để kiểm thử UI:

- Ba đơn `Chờ chuẩn bị`.
- Một đơn `Đang giao`.
- Hai đơn `Đã giao`.
- Nhiều bàn tầng 2, từ `T2-01` đến `T2-06`.
- Có đơn một sản phẩm, nhiều sản phẩm, có ghi chú và không có ghi chú.
- Mã đơn `AF-D201` đến `AF-D206` và thời gian đều là dữ liệu giả lập.

Item name/quantity trong Delivery là snapshot phục vụ prototype, không phải Product database hoặc Order database thứ hai. Chưa có quan hệ chính thức giữa Delivery, POS Order, Table hoặc Kitchen.

## 4. Delivery Queue

Queue dùng ba nhóm trạng thái demo:

| Internal value | Label | Semantic presentation |
| --- | --- | --- |
| `waiting` | Chờ chuẩn bị | Warning + clock icon |
| `delivering` | Đang giao | Information + upward-delivery icon |
| `delivered` | Đã giao | Success + check icon |

Mỗi nhóm có count, text label, icon và empty state; trạng thái không dựa riêng vào màu. Thứ tự fixture được giữ nguyên, không có priority algorithm, SLA hoặc timer.

Search lọc theo order code hoặc table code. Status filter có thể chỉ hiển thị một nhóm. Reset đưa search/filter về mặc định nhưng không reset local status mutations trong cùng phiên.

Status vocabulary này chỉ dùng để đánh giá UI và cần owner phê duyệt.

## 5. Delivery Detail

Chi tiết hiển thị:

- Order code demo.
- Bàn và tầng nhận.
- Thời điểm tạo demo.
- Danh sách item và quantity.
- Tổng quantity.
- Ghi chú hoặc explicit empty-note copy.
- Trạng thái hiện tại.

Desktop từ 1280px hiển thị Queue và Detail side-by-side. Mobile/tablet mở Detail bằng Sheet có focus management, close action và internal vertical scroll.

## 6. Demo interactions

- Chọn card mở chi tiết và đặt selected state.
- Đóng chi tiết xóa selection.
- Chọn trực tiếp một trong ba status demo.
- `Xác nhận đã giao — demo` chuyển local status sang `Đã giao`.
- Card chuyển sang nhóm tương ứng ngay sau mutation.
- Live status announcement mô tả thay đổi.
- Reload route khôi phục fixture gốc.

Không có transition rule. Prototype cho phép chọn trực tiếp mọi status chỉ để kiểm thử presentation. Không gửi fetch/XHR, không tạo/xóa delivery record và không thay đổi POS Order, Payment, Table hoặc Kitchen.

## 7. Navigation integration

Feature được lazy-load tại route review-only `/upstairs-delivery` bên trong Application Shell.

- Không thêm navigation item.
- Không đổi tên navigation hiện có.
- `/kitchen` vẫn là placeholder.
- `/pos` không có link hoặc composition mới.
- App Shell chỉ bổ sung page title cho standalone route.
- Global Floor Selector được ẩn trên route này vì nó không điều khiển Delivery fixtures; mọi destination khác giữ nguyên selector.

Cách tích hợp này giữ feature độc lập trong lúc owner chưa quyết định Upstairs Delivery thuộc POS, Kitchen hay một destination riêng. Route hiện phải được mở trực tiếp.

## 8. Responsive behavior

| Viewport | Behavior | Kết quả |
| --- | --- | --- |
| 390 × 844 | Queue ưu tiên; Detail Sheet gần full-width, actions 44–48px | Pass, không document overflow |
| 768 × 1024 | Queue theo luồng dọc; Detail Sheet tối đa 28rem | Pass, không document overflow |
| 1440 × 900 | Ba queue groups và Detail panel hiển thị đồng thời | Pass, không document overflow |

Desktop card tách order/status và table row để code bàn không gãy. Mobile Sheet dùng width theo `data-side` để override đúng primitive specificity mà không sửa shared component.

## 9. Accessibility

- Queue và từng group có accessible region name.
- Card là native button với accessible order/table name và `aria-pressed`.
- Search có visible label; status filters dùng Radix Select.
- Status luôn kết hợp label, icon và semantic surface.
- Detail desktop dùng complementary landmark; Sheet có accessible title/description.
- Close button có accessible name và touch target tối thiểu.
- Item quantities và group counts có accessible labels.
- Status mutation được công bố qua live region.
- Focus-visible sử dụng token/ring hiện có.

Chưa có screen-reader hardware test, touch hardware test, zoom 200% hoặc axe dependency.

## 10. Screenshots

Playwright tạo artifacts tại:

- `frontend/test-results/screenshots-captures-upstairs-delivery-at-390px-desktop-chromium/upstairs-delivery-390.png`
- `frontend/test-results/screenshots-captures-upstairs-delivery-at-768px-desktop-chromium/upstairs-delivery-768.png`
- `frontend/test-results/screenshots-captures-upstairs-delivery-at-1440px-desktop-chromium/upstairs-delivery-1440.png`

Artifacts nằm trong test output và không được commit.

## 11. Testing và quality checks

E2E coverage gồm:

- Route smoke, runtime/page/resource errors.
- Queue groups, counts và order context.
- Search order code và table code.
- Status filter và per-group empty state.
- Detail open/close, destination, items, quantities và note.
- Status mutation và card movement giữa groups.
- Confirm-delivered demo không gửi fetch/XHR.
- Reload khôi phục local fixture.
- Navigation không đổi và Kitchen tiếp tục là placeholder.
- Delivery mutations không ảnh hưởng POS Order, Payment hoặc Table state.
- Responsive Detail và document overflow tại 390, 768 và 1440px.
- Screenshot ở ba viewport.
- Toàn bộ Application Shell, Design System và POS regression suite tiếp tục chạy.

Trong full-suite verification, test keyboard form cũ từng gặp race do Radix Select chưa đóng listbox trước khi focus checkbox. Test được đồng bộ bằng cách chờ option ẩn; không bỏ hoặc làm yếu assertion. Test này pass 10/10 lần lặp và full suite cuối pass sạch.

| Check | Result |
| --- | --- |
| `npm run typecheck` | Pass |
| `npm run lint` | Pass, không warning |
| `npm run build` | Pass |
| `npm run test:e2e` | 112 passed, 0 failed |
| Hardcoded HEX / `any` trong feature mới | Không có |
| Dependency mới | Không có |

Better Design skill đã được đọc nhưng Better Design MCP không kết nối, vì vậy không có tuyên bố MCP guidance hoặc MCP review. Visual review được thực hiện trên screenshot Chromium ở cả ba viewport bằng Design System hiện có.

## 12. Giới hạn

- Fixture không liên kết với POS order thật.
- Không có backend, API, database hoặc persistence.
- Không có realtime sync, push notification hoặc multi-device state.
- Không có kitchen ticket, printer hoặc elevator integration.
- Không có staff assignment, permission hoặc audit log.
- Không có delivery timing, elapsed timer, priority hoặc SLA.
- Không có failed-delivery path.
- Chỉ kiểm thử tự động trên Desktop Chromium project với viewport thay đổi.

## 13. Quyết định nghiệp vụ chờ owner

1. Upstairs Delivery thuộc POS, Kitchen hay navigation destination riêng.
2. Status vocabulary chính thức và transition rules.
3. Khi nào order đủ điều kiện xuất hiện trong queue.
4. Ai chịu trách nhiệm giao và có cần staff assignment không.
5. Khi nào được coi là `Đang giao` hoặc `Đã giao`.
6. Có cần xác nhận người nhận, thời điểm giao hoặc proof-of-delivery không.
7. Cách xử lý giao thất bại, quay lại quầy hoặc làm lại món.
8. Có priority/SLA không và nếu có thì nguồn thời gian nào là authoritative.
9. Quan hệ giữa Delivery, POS Order, Table, Kitchen ticket và Payment.
10. Có cần realtime, notification, printer hoặc elevator hardware integration không.

Không quyết định hoặc triển khai các mục trên trong Phase 3.4.6.
