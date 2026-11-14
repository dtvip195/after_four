import { Circle } from "lucide-react"

import { Badge } from "@/components/ui/badge"
import { posDemoTableStatuses } from "@/features/pos/data/pos-demo-data"
import type { PosDemoTableStatus } from "@/features/pos/types/pos"
import { cn } from "@/lib/utils"

const statusClassNames: Record<PosDemoTableStatus, string> = {
  ready: "border-success-foreground/20 bg-success text-success-foreground",
  serving: "border-information-foreground/20 bg-information text-information-foreground",
  attention: "border-warning-foreground/20 bg-warning text-warning-foreground",
}

type TableStatusBadgeProps = {
  status: PosDemoTableStatus
}

function TableStatusBadge({ status }: TableStatusBadgeProps) {
  const label = posDemoTableStatuses.find((item) => item.id === status)?.label ?? status

  return (
    <Badge
      variant="outline"
      className={cn("max-w-full rounded-lg", statusClassNames[status])}
    >
      <Circle aria-hidden="true" className="fill-current" />
      <span className="truncate">{label}</span>
    </Badge>
  )
}

export { TableStatusBadge }
