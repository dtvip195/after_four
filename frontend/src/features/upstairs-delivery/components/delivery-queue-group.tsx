import { Inbox } from "lucide-react"

import { DeliveryOrderCard } from "@/features/upstairs-delivery/components/delivery-order-card"
import { DeliveryStatusBadge } from "@/features/upstairs-delivery/components/delivery-status-badge"
import { getDeliveryDemoStatusLabel } from "@/features/upstairs-delivery/data/delivery-demo-data"
import type {
  DeliveryDemoOrder,
  DeliveryDemoStatus,
} from "@/features/upstairs-delivery/types/upstairs-delivery"

type DeliveryQueueGroupProps = {
  orders: DeliveryDemoOrder[]
  selectedOrderId: string | undefined
  status: DeliveryDemoStatus
  onSelect: (orderId: string) => void
}

function DeliveryQueueGroup({
  orders,
  selectedOrderId,
  status,
  onSelect,
}: DeliveryQueueGroupProps) {
  return (
    <section
      aria-label={`Nhóm ${getDeliveryDemoStatusLabel(status)}`}
      className="min-w-0 rounded-xl border bg-muted/20"
    >
      <header className="flex items-center justify-between gap-3 border-b bg-card px-3 py-3">
        <DeliveryStatusBadge status={status} />
        <span className="numeric-data text-sm font-bold" aria-label={`${orders.length} đơn demo`}>
          {orders.length}
        </span>
      </header>

      {orders.length > 0 ? (
        <ol className="grid gap-2 p-2">
          {orders.map((order) => (
            <DeliveryOrderCard
              key={order.id}
              isSelected={selectedOrderId === order.id}
              order={order}
              onSelect={onSelect}
            />
          ))}
        </ol>
      ) : (
        <div role="status" className="flex min-h-36 flex-col items-center justify-center p-4 text-center">
          <Inbox aria-hidden="true" className="size-5 text-muted-foreground" />
          <p className="mt-2 text-sm font-semibold">Không có đơn phù hợp</p>
          <p className="mt-1 text-xs leading-5 text-muted-foreground">
            Nhóm này đang rỗng theo tìm kiếm và bộ lọc demo.
          </p>
        </div>
      )}
    </section>
  )
}

export { DeliveryQueueGroup }
