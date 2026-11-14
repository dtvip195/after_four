# AFTER FOUR — Phase 3.4.5 Payment UI

> Trạng thái: implemented and browser-verified.
>
> Phạm vi: Payment UI prototype tại `/pos`. Không có giao dịch thật, backend, persistence, payment gateway, QR thật, tài khoản ngân hàng thật hoặc order lifecycle chính thức.

## 1. Kết quả

Order Panel mở được Payment UI khi order có ít nhất một sản phẩm. Nhân viên có thể xem lại các line, chọn một phương thức demo, nhập tiền mặt, kiểm tra tiền thừa và đi qua bước xác nhận mô phỏng.

Order rỗng vẫn không thể checkout. Xác nhận demo không gửi request, không xóa order, không giải phóng bàn và không in hóa đơn.

## 2. Payment state architecture

`PosPage` tiếp tục là owner duy nhất của order state qua `useDemoOrder`. Payment UI chỉ nhận `orderLines` hiện tại và sử dụng `getDemoOrderSummary`; không tạo order state thứ hai và không sao chép công thức subtotal.

```text
src/features/pos/
├── components/
│   ├── payment-confirmation-dialog.tsx
│   ├── payment-dialog.tsx
│   ├── payment-method-selector.tsx
│   ├── payment-order-summary.tsx
│   └── order-panel.tsx
├── data/
│   └── payment-demo-data.ts
├── lib/
│   ├── get-demo-order-summary.ts
│   └── payment-calculations.ts
├── pages/
│   └── pos-page.tsx
└── types/
    └── pos.ts
```

- `PaymentDialog`: owner của method, cash input, validation, confirmation-open và success state.
- `PaymentOrderSummary`: resolve product fixture và trình bày quantity, unit price, line subtotal, order subtotal.
- `PaymentMethodSelector`: controlled Radix RadioGroup với selected state rõ ràng.
- `PaymentConfirmationDialog`: lớp xác nhận thứ hai, có cancel quay lại Payment UI.
- `payment-calculations.ts`: parse integer VND, tính change và tạo cash suggestions tập trung.
- `payment-demo-data.ts`: nguồn duy nhất cho label và mô tả ba phương thức demo.

Mỗi lần mở Checkout, `PosPage` tạo một payment session mới bằng component key. Vì vậy method, input, validation và success state cũ không tồn tại khi đóng, sửa order rồi mở lại; order state vẫn giữ nguyên.

## 3. Payment methods demo

| Method | Hành vi prototype |
| --- | --- |
| Tiền mặt | Nhập integer VND, kiểm tra đủ/thiếu và hiển thị tiền thừa dự kiến |
| Chuyển khoản ngân hàng | Hiển thị hướng dẫn mô phỏng; không có tài khoản thật |
| QR Payment | Hiển thị hướng dẫn mô phỏng; không tạo QR hoặc kết nối gateway |

Chuyển method xóa cash input và validation không còn phù hợp. Chưa chọn method thì không thể mở confirmation.

## 4. Payment summary và cash calculation

Payment summary lấy subtotal từ helper đã có:

```text
subtotalVnd = getDemoOrderSummary(orderLines, posDemoProducts).subtotalVnd
```

Tiền mặt dùng số nguyên VND:

```text
changeVnd = receivedAmountVnd - subtotalVnd
```

Change chỉ xuất hiện khi `receivedAmountVnd >= subtotalVnd`. Input rỗng, chứa ký tự không phải chữ số, vượt safe integer hoặc thấp hơn subtotal đều không mở confirmation và có thông báo cụ thể.

Cash suggestions gồm exact subtotal và các mốc làm tròn hợp lý. Tất cả bước gợi ý nằm trong `getCashSuggestionsVnd`, không rải logic trong component.

Không tính VAT, service charge, discount, promotion, tax hoặc rounding policy.

## 5. Confirmation flow

1. Order có line thì Checkout được enable.
2. Payment UI hiển thị summary hiện tại.
3. Người dùng chọn đúng một method.
4. Với cash, input phải là integer VND và không thấp hơn subtotal.
5. `Tiếp tục xác nhận` mở Dialog xác nhận demo.
6. `Quay lại Payment UI` giữ method/input hiện tại để chỉnh sửa.
7. `Xác nhận thanh toán demo` chỉ chuyển local UI sang success state.
8. `Quay lại đơn` đóng Payment UI và giữ order nguyên vẹn.

Success copy ghi rõ không có giao dịch tài chính thật. Không có network request, persistence, receipt printing hoặc table release.

## 6. Responsive behavior

| Viewport | Payment UI behavior | Kết quả |
| --- | --- | --- |
| 390 × 844 | Dialog một cột, nội dung cuộn dọc trong viewport, methods xếp dọc | Pass, không document overflow |
| 768 × 1024 | Dialog một cột rộng hơn, ba methods nằm ngang, summary và cash form theo luồng dọc | Pass, không document overflow |
| 1440 × 900 | Summary và payment controls chia hai cột; methods xếp dọc trong cột controls để tránh nhãn bị ép | Pass, không document overflow |

Các action chính và cash suggestions có touch target theo Design System. Application Shell và bố cục POS phía sau không bị thay đổi.

## 7. Accessibility

- Checkout dùng native disabled state khi order rỗng.
- Dialog và Confirmation Dialog có accessible title/description và focus management của Radix.
- Payment methods dùng RadioGroup có accessible label và native checked state.
- Cash input có visible label, `inputMode="numeric"`, help text và `aria-invalid`.
- Validation dùng alert semantics; change dùng live region.
- Summary có semantic list/dl và accessible labels cho line subtotal/order subtotal.
- Icon là decorative và dùng `aria-hidden`.

Chưa có kiểm thử screen-reader hardware, touch hardware, zoom 200% hoặc axe dependency.

## 8. Screenshots

Playwright tạo artifacts tại:

- `frontend/test-results/screenshots-captures-payment-UI-at-390px-desktop-chromium/payment-ui-390.png`
- `frontend/test-results/screenshots-captures-payment-UI-at-768px-desktop-chromium/payment-ui-768.png`
- `frontend/test-results/screenshots-captures-payment-UI-at-1440px-desktop-chromium/payment-ui-1440.png`

Artifacts nằm trong test output và không được commit.

## 9. E2E coverage

- Order rỗng không thể checkout; order có sản phẩm mở Payment UI.
- Summary khớp product, quantity, unit price, line subtotal và order subtotal.
- Selected state cho cash, bank transfer và QR; chuyển method xóa validation không phù hợp.
- Chặn khi chưa chọn method.
- Cash exact, excess, change calculation, empty, invalid và insufficient.
- Confirmation open/cancel/success.
- Không gửi fetch/XHR khi xác nhận demo.
- Không reset order sau success.
- Đóng, sửa order và mở lại tạo payment session sạch với subtotal mới.
- Mobile tabs giữ order state.
- Responsive và document overflow tại 390, 768 và 1440px.
- Existing Table Management, Product Detail, Order Management, Application Shell và Design System tests tiếp tục chạy.

Kết quả: `95 passed, 0 failed` trên Desktop Chromium project.

## 10. Quality checks và tools

| Check | Result |
| --- | --- |
| `npm run typecheck` | Pass |
| `npm run lint` | Pass, không warning |
| `npm run build` | Pass |
| `npm run test:e2e` | 95 passed, 0 failed |
| Hardcoded HEX / `any` trong feature mới | Không có |
| Dependency mới | Không có |

Better Design skill được dùng để giữ hierarchy, operational clarity, touch targets và responsive density nhất quán. Better Design MCP chưa kết nối, vì vậy không có tuyên bố MCP guidance hoặc MCP review. UI chỉ tái sử dụng shared shadcn/Radix components và Lucide đã có.

## 11. Giới hạn và quyết định chờ owner

- Payment methods chính thức và method nào khả dụng theo từng thiết bị/cửa hàng.
- Thông tin tài khoản ngân hàng, QR provider và payment gateway.
- Payment lifecycle, transaction identifier, retry, timeout và reconciliation.
- Order được đánh dấu paid, reset hoặc giữ lại vào thời điểm nào.
- Khi nào bàn được giải phóng và ai có quyền thực hiện.
- Receipt printing và hóa đơn điện tử.
- VAT, service charge, discount, promotion và rounding policy.
- Partial payment, split payment và multiple methods.
- Refund, void, permission và audit log.
- Cash denomination policy và cash drawer workflow.

Không quyết định hoặc triển khai các mục trên trong Phase 3.4.5.
