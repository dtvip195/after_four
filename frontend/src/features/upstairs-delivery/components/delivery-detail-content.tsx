import { Clock3, Info, Layers3, PackageOpen, StickyNote } from "lucide-react"

import { Alert, AlertDescription, AlertTitle } from "@/components/ui/alert"
import { Button } from "@/components/ui/button"
import { Label } from "@/components/ui/label"
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select"
import { DeliveryStatusBadge } from "@/features/upstairs-delivery/components/delivery-status-badge"
import {
  deliveryDemoStatuses,
  getDeliveryDemoTotalQuantity,
} from "@/features/upstairs-delivery/data/delivery-demo-data"
import type {
  DeliveryDemoOrder,
  DeliveryDemoStatus,
} from "@/features/upstairs-delivery/types/upstairs-delivery"

type DeliveryDetailContentProps = {
  order: DeliveryDemoOrder
  onConfirmDelivered: () => void
  onStatusChange: (status: DeliveryDemoStatus) => void
}

function DeliveryDetailContent({
  order,
  onConfirmDelivered,
  onStatusChange,
}: DeliveryDetailContentProps) {
  const totalQuantity = getDeliveryDemoTotalQuantity(order)

  return (
    <div className="min-w-0">
      <div className="flex flex-wrap items-start justify-between gap-3">
        <div>
          <p className="text-meta font-semibold tracking-label text-brand-clay">ĐƠN DELIVERY DEMO</p>
          <p className="numeric-data mt-1 text-section font-bold text-brand-coffee">{order.code}</p>
        </div>
        <DeliveryStatusBadge status={order.status} />
      </div>

      <dl className="mt-4 grid grid-cols-2 gap-3 border-y py-4 text-sm">
        <div>
          <dt className="flex items-center gap-1.5 text-xs text-muted-foreground"><Layers3 aria-hidden="true" className="size-3.5" />Bàn nhận</dt>
          <dd className="numeric-data mt-1 font-semibold">{order.tableCode}</dd>
        </div>
        <div>
          <dt className="flex items-center gap-1.5 text-xs text-muted-foreground"><Layers3 aria-hidden="true" className="size-3.5" />Tầng nhận</dt>
          <dd className="mt-1 font-semibold">{order.floorLabel}</dd>
        </div>
        <div>
          <dt className="flex items-center gap-1.5 text-xs text-muted-foreground"><Clock3 aria-hidden="true" className="size-3.5" />Tạo lúc</dt>
          <dd className="numeric-data mt-1 font-semibold">{order.createdAtLabel}</dd>
        </div>
        <div>
          <dt className="flex items-center gap-1.5 text-xs text-muted-foreground"><PackageOpen aria-hidden="true" className="size-3.5" />Tổng số lượng</dt>
          <dd className="numeric-data mt-1 font-semibold">{totalQuantity}</dd>
        </div>
      </dl>

      <section aria-labelledby="delivery-items-title" className="mt-5">
        <h3 id="delivery-items-title" className="text-sm font-semibold">Sản phẩm minh họa</h3>
        <ol className="mt-2 divide-y rounded-xl border px-3">
          {order.items.map((item) => (
            <li key={item.id} className="flex items-center justify-between gap-4 py-3 text-sm">
              <span className="min-w-0 font-medium">{item.name}</span>
              <span className="numeric-data shrink-0 font-bold" aria-label={`${item.name}, số lượng ${item.quantity}`}>× {item.quantity}</span>
            </li>
          ))}
        </ol>
      </section>

      <section aria-labelledby="delivery-note-title" className="mt-5 rounded-xl border bg-muted/20 p-3">
        <h3 id="delivery-note-title" className="flex items-center gap-2 text-sm font-semibold">
          <StickyNote aria-hidden="true" className="size-4 text-brand-clay" />
          Ghi chú giao hàng demo
        </h3>
        <p className="mt-2 text-sm leading-6 text-muted-foreground">
          {order.note || "Không có ghi chú giao hàng trong fixture này."}
        </p>
      </section>

      <div className="mt-5">
        <Label htmlFor="delivery-detail-status">Trạng thái minh họa</Label>
        <Select value={order.status} onValueChange={(value) => onStatusChange(value as DeliveryDemoStatus)}>
          <SelectTrigger id="delivery-detail-status" className="mt-2 min-h-target w-full" aria-label={`Trạng thái demo của ${order.code}`}>
            <SelectValue />
          </SelectTrigger>
          <SelectContent>
            {deliveryDemoStatuses.map((status) => (
              <SelectItem key={status.id} value={status.id}>{status.label}</SelectItem>
            ))}
          </SelectContent>
        </Select>
        <p className="mt-2 text-xs leading-5 text-muted-foreground">
          Có thể chọn trực tiếp mọi trạng thái để đánh giá UI; chưa có transition rule chính thức.
        </p>
      </div>

      <Button
        type="button"
        className="mt-4 min-h-touch w-full"
        disabled={order.status === "delivered"}
        onClick={onConfirmDelivered}
      >
        Xác nhận đã giao — demo
      </Button>

      <Alert className="mt-4">
        <Info aria-hidden="true" />
        <AlertTitle>Chỉ thay đổi local fixture</AlertTitle>
        <AlertDescription>
          Không cập nhật order, payment, bàn, kitchen ticket hoặc dữ liệu bên ngoài trang này.
        </AlertDescription>
      </Alert>
    </div>
  )
}

export { DeliveryDetailContent }
