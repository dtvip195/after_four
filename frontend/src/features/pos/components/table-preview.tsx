import { Armchair, Layers3, X } from "lucide-react"

import { Button } from "@/components/ui/button"
import { TableStatusBadge } from "@/features/pos/components/table-status-badge"
import type { PosDemoTable } from "@/features/pos/types/pos"

type TablePreviewProps = {
  floorLabel: string
  table: PosDemoTable | undefined
  onClear: () => void
}

function TablePreview({ floorLabel, table, onClear }: TablePreviewProps) {
  if (!table) {
    return (
      <aside
        aria-label="Thông tin bàn được chọn"
        className="flex min-h-44 flex-col items-center justify-center rounded-xl border border-dashed bg-muted/30 p-4 text-center"
      >
        <span className="flex size-10 items-center justify-center rounded-lg bg-muted text-muted-foreground">
          <Armchair aria-hidden="true" className="size-5" />
        </span>
        <h3 className="mt-3 text-sm font-semibold">Chưa chọn bàn</h3>
        <p className="mt-1 max-w-48 text-xs leading-5 text-muted-foreground">
          Chọn một bàn minh họa để xem thông tin preview.
        </p>
      </aside>
    )
  }

  return (
    <aside
      aria-label="Thông tin bàn được chọn"
      className="min-w-0 rounded-xl border bg-background p-4"
    >
      <div className="flex items-start justify-between gap-3">
        <div className="min-w-0">
          <p className="text-meta font-semibold tracking-label text-brand-clay">BÀN ĐANG CHỌN</p>
          <h3 className="mt-1 truncate text-section font-semibold">{table.label}</h3>
          <p className="numeric-data mt-1 text-xs font-semibold text-muted-foreground">
            {table.code}
          </p>
        </div>
        <Button
          type="button"
          variant="ghost"
          size="icon"
          className="min-h-target min-w-target"
          aria-label="Bỏ chọn bàn"
          onClick={onClear}
        >
          <X aria-hidden="true" />
        </Button>
      </div>

      <dl className="mt-4 space-y-3 border-t pt-3 text-sm">
        <div className="flex items-center justify-between gap-3">
          <dt className="flex items-center gap-2 text-muted-foreground">
            <Layers3 aria-hidden="true" className="size-4" />
            Tầng
          </dt>
          <dd className="font-medium">{floorLabel}</dd>
        </div>
        <div className="flex items-center justify-between gap-3">
          <dt className="text-muted-foreground">Trạng thái</dt>
          <dd className="min-w-0">
            <TableStatusBadge status={table.status} />
          </dd>
        </div>
      </dl>

      <div className="mt-4 border-l-2 border-brand-clay pl-3">
        <p className="text-xs leading-5 text-muted-foreground">
          Preview minh họa; không có thao tác đặt, chuyển, gộp bàn hoặc tạo đơn.
        </p>
      </div>
    </aside>
  )
}

export { TablePreview }
