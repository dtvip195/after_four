import { Armchair, Check } from "lucide-react"

import { TableStatusBadge } from "@/features/pos/components/table-status-badge"
import type { PosDemoTable } from "@/features/pos/types/pos"
import { cn } from "@/lib/utils"

type TableCardProps = {
  isSelected: boolean
  table: PosDemoTable
  onSelect: (tableId: string) => void
}

function TableCard({ isSelected, table, onSelect }: TableCardProps) {
  return (
    <button
      type="button"
      aria-label={`${table.code}, ${table.label}, trạng thái đề xuất`}
      aria-pressed={isSelected}
      className={cn(
        "group flex min-h-32 min-w-0 flex-col items-stretch rounded-xl border bg-background p-3 text-left outline-none transition-colors hover:border-primary/50 hover:bg-muted/60 focus-visible:border-ring focus-visible:ring-3 focus-visible:ring-ring/50",
        isSelected && "border-primary bg-accent/70 ring-2 ring-ring/30"
      )}
      onClick={() => onSelect(table.id)}
    >
      <span className="flex items-start justify-between gap-2">
        <span
          className={cn(
            "flex size-9 shrink-0 items-center justify-center rounded-lg bg-muted text-muted-foreground",
            isSelected && "bg-primary text-primary-foreground"
          )}
        >
          {isSelected ? (
            <Check aria-hidden="true" className="size-4" />
          ) : (
            <Armchair aria-hidden="true" className="size-4" />
          )}
        </span>
        <span className="numeric-data text-xs font-semibold text-muted-foreground">
          {table.code}
        </span>
      </span>
      <span className="mt-3 block truncate text-sm font-semibold">{table.label}</span>
      <span className="mt-auto pt-2">
        <TableStatusBadge status={table.status} />
      </span>
    </button>
  )
}

export { TableCard }
