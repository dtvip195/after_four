import { ReceiptText, ShoppingBasket } from "lucide-react"

import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"
import { ClearOrderDialog } from "@/features/pos/components/clear-order-dialog"
import { OrderLineItem } from "@/features/pos/components/order-line-item"
import { posDemoProducts } from "@/features/pos/data/pos-demo-data"
import { formatVnd } from "@/features/pos/lib/format-vnd"
import { getDemoOrderSummary } from "@/features/pos/lib/get-demo-order-summary"
import type { PosDemoOrderLine } from "@/features/pos/types/pos"

type OrderPanelProps = {
  idPrefix: string
  orderLines: PosDemoOrderLine[]
  onClear: () => void
  onDecrease: (productId: string) => void
  onIncrease: (productId: string) => void
  onNoteChange: (productId: string, note: string) => void
  onRemove: (productId: string) => void
  onCheckout: () => void
}

function OrderPanel({
  idPrefix,
  orderLines,
  onClear,
  onDecrease,
  onIncrease,
  onNoteChange,
  onRemove,
  onCheckout,
}: OrderPanelProps) {
  const titleId = `${idPrefix}-order-panel-title`
  const checkoutNoteId = `${idPrefix}-checkout-note`
  const summary = getDemoOrderSummary(orderLines, posDemoProducts)
  const displayLines = orderLines.flatMap((line) => {
    const product = posDemoProducts.find((item) => item.id === line.productId)
    return product ? [{ line, product }] : []
  })

  return (
    <aside aria-labelledby={titleId} className="flex h-full min-h-0 flex-col bg-card">
      <header className="border-b p-4">
        <div className="flex items-start justify-between gap-3">
          <div>
            <p className="text-meta font-semibold tracking-label text-brand-clay">ORDER WORKSPACE</p>
            <h2 id={titleId} className="mt-1 text-section font-semibold">
              Đơn minh họa
            </h2>
          </div>
          <Badge variant="secondary" className="rounded-lg">
            Chỉ local
          </Badge>
        </div>
        <p className="mt-2 text-xs leading-5 text-muted-foreground">
          Đơn demo chỉ tồn tại trong phiên giao diện này và không được lưu.
        </p>
      </header>

      <div className="min-h-0 flex-1 overflow-y-auto p-4">
        {displayLines.length === 0 ? (
          <div
            role="status"
            className="flex min-h-52 flex-col items-center justify-center rounded-xl border border-dashed bg-muted/30 p-5 text-center"
          >
            <span className="flex size-11 items-center justify-center rounded-lg bg-muted text-muted-foreground">
              <ShoppingBasket aria-hidden="true" className="size-5" />
            </span>
            <h3 className="mt-3 text-sm font-semibold">Đơn đang trống</h3>
            <p className="mt-1 max-w-52 text-xs leading-5 text-muted-foreground">
              Chọn một sản phẩm trong Menu rồi nhấn “Thêm vào đơn demo”.
            </p>
          </div>
        ) : (
          <div>
            <div className="flex items-center justify-between gap-3 border-b pb-3">
              <div className="flex items-center gap-2">
                <ReceiptText aria-hidden="true" className="size-4 text-brand-clay" />
                <p className="text-sm font-semibold">Sản phẩm trong đơn</p>
              </div>
              <ClearOrderDialog onClear={onClear} />
            </div>
            <ol className="divide-y pt-4">
              {displayLines.map(({ line, product }) => (
                <OrderLineItem
                  key={line.productId}
                  idPrefix={idPrefix}
                  line={line}
                  product={product}
                  onDecrease={onDecrease}
                  onIncrease={onIncrease}
                  onNoteChange={onNoteChange}
                  onRemove={onRemove}
                />
              ))}
            </ol>
          </div>
        )}
      </div>

      <footer className="border-t bg-muted/30 p-4">
        <dl className="grid gap-2 text-sm" aria-live="polite">
          <div className="flex items-center justify-between gap-4 text-muted-foreground">
            <dt>Loại sản phẩm</dt>
            <dd
              className="numeric-data font-medium text-foreground"
              aria-label={`Loại sản phẩm: ${summary.lineCount}`}
            >
              {summary.lineCount}
            </dd>
          </div>
          <div className="flex items-center justify-between gap-4 text-muted-foreground">
            <dt>Tổng số lượng</dt>
            <dd
              className="numeric-data font-medium text-foreground"
              aria-label={`Tổng số lượng: ${summary.totalQuantity}`}
            >
              {summary.totalQuantity}
            </dd>
          </div>
          <div className="flex items-end justify-between gap-4 border-t pt-3">
            <dt className="font-semibold">Tạm tính demo</dt>
            <dd
              className="numeric-data text-lg font-bold text-brand-coffee"
              aria-label={`Tạm tính demo: ${formatVnd(summary.subtotalVnd)}`}
            >
              {formatVnd(summary.subtotalVnd)}
            </dd>
          </div>
        </dl>
        <p id={checkoutNoteId} className="mt-3 text-xs leading-5 text-muted-foreground">
          Chưa áp dụng VAT, phí dịch vụ, giảm giá, khuyến mãi hoặc quy tắc thanh toán.
        </p>
        <Button
          type="button"
          className="mt-4 min-h-touch w-full"
          aria-describedby={checkoutNoteId}
          disabled={orderLines.length === 0}
          onClick={onCheckout}
        >
          Thanh toán demo
        </Button>
      </footer>
    </aside>
  )
}

export { OrderPanel }
