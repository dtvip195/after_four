import { Badge } from "@/components/ui/badge"
import { posDemoProducts } from "@/features/pos/data/pos-demo-data"
import { formatVnd } from "@/features/pos/lib/format-vnd"
import type { PosDemoOrderLine } from "@/features/pos/types/pos"

type PaymentOrderSummaryProps = {
  orderLines: PosDemoOrderLine[]
  subtotalVnd: number
}

function PaymentOrderSummary({
  orderLines,
  subtotalVnd,
}: PaymentOrderSummaryProps) {
  const displayLines = orderLines.flatMap((line) => {
    const product = posDemoProducts.find((item) => item.id === line.productId)
    return product ? [{ line, product }] : []
  })

  return (
    <section aria-labelledby="payment-summary-title" className="rounded-xl border bg-muted/20">
      <header className="flex items-center justify-between gap-3 border-b px-4 py-3">
        <h3 id="payment-summary-title" className="text-sm font-semibold">
          Tóm tắt đơn
        </h3>
        <Badge variant="secondary" className="rounded-lg">
          Giá trị demo
        </Badge>
      </header>

      <ol className="max-h-56 divide-y overflow-y-auto px-4">
        {displayLines.map(({ line, product }) => (
          <li key={line.productId} className="grid grid-cols-[minmax(0,1fr)_auto] gap-3 py-3">
            <div className="min-w-0">
              <p className="truncate text-sm font-medium">{product.name}</p>
              <p className="numeric-data mt-1 text-xs text-muted-foreground">
                {line.quantity} × {formatVnd(product.unitPriceVnd)}
              </p>
            </div>
            <p
              className="numeric-data text-sm font-semibold"
              aria-label={`${product.name}, thành tiền ${formatVnd(product.unitPriceVnd * line.quantity)}`}
            >
              {formatVnd(product.unitPriceVnd * line.quantity)}
            </p>
          </li>
        ))}
      </ol>

      <dl className="border-t px-4 py-3">
        <div className="flex items-end justify-between gap-4">
          <dt className="font-semibold">Tạm tính đơn demo</dt>
          <dd
            className="numeric-data text-lg font-bold text-brand-coffee"
            aria-label={`Tạm tính trong Payment UI: ${formatVnd(subtotalVnd)}`}
          >
            {formatVnd(subtotalVnd)}
          </dd>
        </div>
      </dl>
    </section>
  )
}

export { PaymentOrderSummary }
