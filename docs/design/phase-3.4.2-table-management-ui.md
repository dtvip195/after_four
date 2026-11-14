# AFTER FOUR — Phase 3.4.2 Table Management UI

> Trạng thái: implemented and browser-verified.
>
> Phạm vi: prototype giao diện bàn trong POS. Không có table lifecycle, order linkage, reservation, payment, backend, API hoặc persistence.

## 1. Mục tiêu và kết quả

Khu vực `Không gian bàn` tại `/pos` đã được phát triển thành workspace có thể tìm, lọc, chọn và xem preview bàn minh họa. Workspace dùng trực tiếp floor state từ Application Shell; không tạo Floor Selector thứ hai.

Mọi tên, mã, số lượng và trạng thái bàn đều là fixture phục vụ đánh giá UI. Workspace luôn hiển thị nhãn `Trạng thái đề xuất` và không có thao tác nghiệp vụ thật.

## 2. Component architecture

```text
src/features/pos/
├── components/
│   ├── floor-workspace.tsx
│   ├── table-card.tsx
│   ├── table-filters.tsx
│   ├── table-preview.tsx
│   └── table-status-badge.tsx
├── data/
│   └── pos-demo-data.ts
└── types/
    └── pos.ts
```

- `FloorWorkspace`: điều phối local search, status filter, selection và responsive composition.
- `TableFilters`: search, shadcn Select và reset action.
- `TableCard`: touch-friendly selection target với `aria-pressed`.
- `TablePreview`: empty state hoặc thông tin bàn đang chọn; chỉ có action bỏ chọn.
- `TableStatusBadge`: mapping tập trung từ status type sang semantic status token.
- Fixture và type tách khỏi presentation; không có `any` hoặc hardcoded HEX.

## 3. Fixture theo tầng

`posDemoTablesByFloor` dùng `Record<FloorId, PosDemoTable[]>`, vì vậy `floor-1` và `floor-2` dùng cùng type từ Application Shell và không lặp logic nhận diện tầng trong component.

- Tầng 1: 6 bàn minh họa, mã `T1-01` đến `T1-06`.
- Tầng 2: 5 bàn minh họa, mã `T2-01` đến `T2-05`.
- Chuyển tầng remount riêng Table Workspace bằng React `key`, tự reset search, filter và selected table mà không cần effect đồng bộ state.
- Số lượng và mã chỉ là fixture; không đại diện sơ đồ hoặc inventory bàn cuối cùng.

## 4. Trạng thái minh họa

Ba trạng thái dùng để đánh giá scanability và semantic color:

| Internal value | Nhãn UI | Token |
| --- | --- | --- |
| `ready` | Sẵn sàng | success |
| `serving` | Đang phục vụ | information |
| `attention` | Cần chú ý | warning |

Đây không phải trạng thái nghiệp vụ đã được phê duyệt. Chọn bàn không đổi trạng thái; không có transition, timer, reservation, order hoặc payment mapping. Text và icon/dot luôn đi kèm màu.

## 5. Interactions

- Tìm bàn theo mã hoặc tên trong fixture của tầng hiện tại.
- Lọc theo trạng thái demo hoặc xem tất cả.
- Reset search và filter.
- Chọn bàn; chọn lại cùng card để bỏ chọn.
- Bỏ chọn từ preview.
- Chuyển tầng bằng Floor Selector của Application Shell.
- Empty state khi không có kết quả.

Không có thao tác tạo đơn, đặt bàn, check-in/out, chuyển, gộp, tách hoặc thanh toán.

## 6. Responsive behavior

| Viewport | Behavior | Kết quả |
| --- | --- | --- |
| 390 × 844 | Tab `Bàn`, grid hai cột, preview phía dưới | Pass, không horizontal overflow |
| 768 × 1024 | Table Workspace full-width; grid và preview song song | Pass, không horizontal overflow |
| 1440 × 900 | Giữ POS ba vùng; cột bàn 19rem, selected preview đặt trước grid trong vùng cuộn | Pass, không horizontal overflow |

Desktop không làm mất Menu/Order workspace. Tablet dành nhiều không gian nhất cho table grid. Mobile giữ control tối thiểu 44px và không ép desktop composition.

## 7. Accessibility

- Workspace có region name `Không gian bàn`.
- Card là native button, có accessible name, keyboard interaction và `aria-pressed`.
- Search có visible-purpose accessible label.
- Status filter dùng Radix Select với accessible name.
- Preview dùng complementary landmark `Thông tin bàn được chọn`.
- Kết quả filter dùng `aria-live="polite"`; empty result dùng `role="status"`.
- Selected state kết hợp border, surface, icon và pressed state, không phụ thuộc riêng màu.

Chưa có screen-reader hardware test, touch hardware test, zoom 200% hoặc axe dependency.

## 8. Screenshots

Playwright tạo full-page artifacts tại:

- `frontend/test-results/screenshots-captures-table-management-at-390px-desktop-chromium/table-management-390.png`
- `frontend/test-results/screenshots-captures-table-management-at-768px-desktop-chromium/table-management-768.png`
- `frontend/test-results/screenshots-captures-table-management-at-1440px-desktop-chromium/table-management-1440.png`

Artifacts nằm trong test output và không được commit.

## 9. E2E coverage

- Workspace và table count theo tầng.
- Đổi tầng thay fixture và reset local state.
- Chọn, preview và bỏ chọn bàn.
- Search theo code/tên.
- Status filter.
- Empty state và reset.
- Responsive layout tại 390, 768 và 1440px.
- `documentElement` và `body` không horizontal overflow.
- Screenshots ở cả ba viewport.
- Toàn bộ Application Shell, POS Phase 3.4.1 và Design System regression tests tiếp tục chạy.

Kết quả: `51 passed, 0 failed` trên Desktop Chromium project.

## 10. Quality checks và tools

| Check | Result |
| --- | --- |
| `npm run typecheck` | Pass |
| `npm run lint` | Pass, không warning |
| `npm run build` | Pass |
| `npm run test:e2e` | 51 passed, 0 failed |
| Hardcoded HEX / `any` trong feature | Không có |

Không cài dependency mới. shadcn MCP audit checklist đã được đối chiếu. Better Design skill đã được đọc, nhưng Better Design MCP không kết nối trong phiên nên không có tuyên bố MCP guidance hoặc MCP review.

## 11. Quyết định nghiệp vụ chờ owner

- Số lượng, mã, tên và sơ đồ bàn chính thức của từng tầng.
- Danh sách trạng thái bàn chính thức và ý nghĩa của từng trạng thái.
- Quy tắc chuyển trạng thái, quyền thao tác và audit history.
- Metadata cần hiển thị trong table preview.
- Reservation/hold/check-in/check-out có thuộc phạm vi sản phẩm hay không.
- Quan hệ giữa bàn, order, payment và kitchen workflow.
- Hành vi chuyển/gộp/tách bàn.
- Quy trình Upstairs Delivery.

Không quyết định hoặc triển khai các mục trên trong Phase 3.4.2.
