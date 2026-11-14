import { Clock3, Layers3, PackageOpen } from "lucide-react"

import { DeliveryStatusBadge } from "@/features/upstairs-delivery/components/delivery-status-badge"
import { getDeliveryDemoTotalQuantity } from "@/features/upstairs-delivery/data/delivery-demo-data"
import type { DeliveryDemoOrder } from "@/features/upstairs-delivery/types/upstairs-delivery"
import { cn } from "@/lib/utils"

type DeliveryOrderCardProps = {
  isSelected: boolean
  order: DeliveryDemoOrder
  onSelect: (orderId: string) => void
}

function DeliveryOrderCard({ isSelected, order, onSelect }: DeliveryOrderCardProps) {
  const totalQuantity = getDeliveryDemoTotalQuantity(order)

  return (
    <li>
      <button
        type="button"
        aria-label={`Mở chi tiết đơn ${order.code}, bàn ${order.tableCode}`}
        aria-pressed={isSelected}
        className={cn(
          "min-h-target w-full rounded-xl border bg-card p-3 text-left outline-none transition-colors hover:bg-muted/40 focus-visible:border-ring focus-visible:ring-3 focus-visible:ring-ring/50",
          isSelected && "border-primary bg-accent/60 ring-2 ring-ring/20"
        )}
        onClick={() => onSelect(order.id)}
      >
        <span className="flex items-start justify-between gap-3">
          <span className="numeric-data block text-sm font-bold text-brand-coffee">
            {order.code}
          </span>
          <DeliveryStatusBadge status={order.status} />
        </span>
        <span className="mt-2 flex items-center gap-1.5 text-sm font-semibold whitespace-nowrap">
          <Layers3 aria-hidden="true" className="size-4 text-brand-clay" />
          Bàn {order.tableCode}
        </span>

        <span className="mt-3 grid grid-cols-2 gap-2 border-t pt-3 text-xs text-muted-foreground">
          <span className="flex items-center gap-1.5">
            <Clock3 aria-hidden="true" className="size-3.5" />
            Tạo lúc <span className="numeric-data font-medium text-foreground">{order.createdAtLabel}</span>
          </span>
          <span className="flex items-center justify-end gap-1.5">
            <PackageOpen aria-hidden="true" className="size-3.5" />
            <span className="numeric-data font-medium text-foreground">{totalQuantity}</span> món
          </span>
        </span>

        <span className="mt-2 block truncate text-xs text-muted-foreground">
          {order.items.map((item) => `${item.quantity}× ${item.name}`).join(" · ")}
        </span>
      </button>
    </li>
  )
}

export { DeliveryOrderCard }
