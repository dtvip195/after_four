import { Building2 } from "lucide-react"

import type { FloorId } from "@/app/components/floor-options"
import { floorOptions, isFloorId } from "@/app/components/floor-options"
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select"
import { cn } from "@/lib/utils"

type FloorSelectorProps = {
  value: FloorId
  onValueChange: (value: FloorId) => void
  className?: string
}

function FloorSelector({ value, onValueChange, className }: FloorSelectorProps) {
  return (
    <div className={cn("flex min-w-0 items-center gap-2", className)}>
      <Building2 aria-hidden="true" className="hidden size-4 shrink-0 text-muted-foreground sm:block" />
      <Select
        value={value}
        onValueChange={(nextValue) => {
          if (isFloorId(nextValue)) {
            onValueChange(nextValue)
          }
        }}
      >
        <SelectTrigger
          aria-label="Chọn tầng"
          className="min-h-target w-full min-w-0 bg-card sm:w-32"
        >
          <SelectValue />
        </SelectTrigger>
        <SelectContent>
          {floorOptions.map((floor) => (
            <SelectItem key={floor.value} value={floor.value} className="min-h-target">
              {floor.label}
            </SelectItem>
          ))}
        </SelectContent>
      </Select>
    </div>
  )
}

export { FloorSelector }
