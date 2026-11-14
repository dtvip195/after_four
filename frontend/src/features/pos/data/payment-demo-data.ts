import type { PosDemoPaymentMethodOption } from "@/features/pos/types/pos"

const posDemoPaymentMethods: PosDemoPaymentMethodOption[] = [
  {
    id: "cash",
    label: "Tiền mặt",
    description: "Nhập số tiền khách đưa để xem tiền thừa dự kiến.",
  },
  {
    id: "bank-transfer",
    label: "Chuyển khoản ngân hàng",
    description: "Chỉ hiển thị hướng dẫn mô phỏng; không có tài khoản ngân hàng thật.",
  },
  {
    id: "qr",
    label: "QR Payment",
    description: "Không tạo mã QR hoặc kết nối cổng thanh toán thật.",
  },
]

export { posDemoPaymentMethods }
