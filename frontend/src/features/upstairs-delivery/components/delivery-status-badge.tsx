import { ArrowUpFromLine, CheckCircle2, Clock3 } from "lucide-react"

import { Badge } from "@/components/ui/badge"
import { getDeliveryDemoStatusLabel } from "@/features/upstairs-delivery/data/delivery-demo-data"
import type { DeliveryDemoStatus } from "@/features/upstairs-delivery/types/upstairs-delivery"
import { cn } from "@/lib/utils"

const statusPresentation = {
  waiting: {
    icon: Clock3,
    className: "border-warning-foreground/20 bg-warning text-warning-foreground",
  },
  delivering: {
    icon: ArrowUpFromLine,
    className: "border-information-foreground/20 bg-information text-information-foreground",
  },
  delivered: {
    icon: CheckCircle2,
    className: "border-success-foreground/20 bg-success text-success-foreground",
  },
} satisfies Record<DeliveryDemoStatus, { icon: typeof Clock3; className: string }>

type DeliveryStatusBadgeProps = {
  status: DeliveryDemoStatus
}

function DeliveryStatusBadge({ status }: DeliveryStatusBadgeProps) {
  const presentation = statusPresentation[status]
  const Icon = presentation.icon

  return (
    <Badge
      variant="outline"
      className={cn("max-w-full rounded-lg", presentation.className)}
    >
      <Icon aria-hidden="true" />
      <span className="truncate">{getDeliveryDemoStatusLabel(status)}</span>
    </Badge>
  )
}

export { DeliveryStatusBadge }
