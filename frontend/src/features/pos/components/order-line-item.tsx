import { Minus, Plus, Trash2 } from "lucide-react"

import { Button } from "@/components/ui/button"
import { Textarea } from "@/components/ui/textarea"
import { formatVnd } from "@/features/pos/lib/format-vnd"
import type { PosDemoOrderLine, PosDemoProduct } from "@/features/pos/types/pos"

type OrderLineItemProps = {
  idPrefix: string
  line: PosDemoOrderLine
  product: PosDemoProduct
  onDecrease: (productId: string) => void
  onIncrease: (productId: string) => void
  onNoteChange: (productId: string, note: string) => void
  onRemove: (productId: string) => void
}

function OrderLineItem({
  idPrefix,
  line,
  product,
  onDecrease,
  onIncrease,
  onNoteChange,
  onRemove,
}: OrderLineItemProps) {
  const noteId = `${idPrefix}-${product.id}-note`
  const lineTotalVnd = product.unitPriceVnd * line.quantity

  return (
    <li aria-label={`Dòng đơn ${product.name}`} className="py-4 first:pt-0 last:pb-0">
      <div className="flex min-w-0 items-start justify-between gap-3">
        <div className="min-w-0">
          <h3 className="truncate text-sm font-semibold">{product.name}</h3>
          <p className="numeric-data mt-1 text-xs text-muted-foreground">
            {formatVnd(product.unitPriceVnd)} / sản phẩm
          </p>
        </div>
        <p className="numeric-data shrink-0 text-sm font-bold text-brand-coffee">
          {formatVnd(lineTotalVnd)}
        </p>
      </div>

      <div className="mt-3 flex items-center justify-between gap-3">
        <div
          role="group"
          aria-label={`Số lượng ${product.name}`}
          className="flex items-center rounded-lg border bg-background"
        >
          <Button
            type="button"
            variant="ghost"
            size="icon"
            className="min-h-target min-w-target rounded-r-none"
            aria-label={`Giảm số lượng ${product.name}`}
            disabled={line.quantity === 1}
            onClick={() => onDecrease(product.id)}
          >
            <Minus aria-hidden="true" />
          </Button>
          <span
            className="numeric-data min-w-9 text-center text-sm font-semibold"
            aria-label={`Số lượng ${product.name}: ${line.quantity}`}
          >
            {line.quantity}
          </span>
          <Button
            type="button"
            variant="ghost"
            size="icon"
            className="min-h-target min-w-target rounded-l-none"
            aria-label={`Tăng số lượng ${product.name}`}
            onClick={() => onIncrease(product.id)}
          >
            <Plus aria-hidden="true" />
          </Button>
        </div>

        <Button
          type="button"
          variant="ghost"
          size="icon"
          className="min-h-target min-w-target text-destructive hover:bg-destructive/10 hover:text-destructive"
          aria-label={`Xóa ${product.name} khỏi đơn`}
          onClick={() => onRemove(product.id)}
        >
          <Trash2 aria-hidden="true" />
        </Button>
      </div>

      <div className="mt-3">
        <label htmlFor={noteId} className="text-xs font-medium text-muted-foreground">
          Ghi chú cho {product.name}
        </label>
        <Textarea
          id={noteId}
          value={line.note}
          className="mt-1 min-h-14 resize-none bg-background text-sm"
          placeholder="Ghi chú minh họa"
          onChange={(event) => onNoteChange(product.id, event.currentTarget.value)}
        />
      </div>
    </li>
  )
}

export { OrderLineItem }
