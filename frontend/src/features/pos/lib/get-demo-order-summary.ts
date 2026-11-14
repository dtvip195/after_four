import type { PosDemoOrderLine, PosDemoProduct } from "@/features/pos/types/pos"

type PosDemoOrderSummary = {
  lineCount: number
  subtotalVnd: number
  totalQuantity: number
}

function getDemoOrderSummary(
  orderLines: PosDemoOrderLine[],
  products: PosDemoProduct[]
): PosDemoOrderSummary {
  const productsById = new Map(products.map((product) => [product.id, product]))

  return orderLines.reduce<PosDemoOrderSummary>(
    (summary, line) => {
      const product = productsById.get(line.productId)

      return {
        lineCount: summary.lineCount + 1,
        totalQuantity: summary.totalQuantity + line.quantity,
        subtotalVnd:
          summary.subtotalVnd + (product?.unitPriceVnd ?? 0) * line.quantity,
      }
    },
    { lineCount: 0, subtotalVnd: 0, totalQuantity: 0 }
  )
}

export { getDemoOrderSummary }
export type { PosDemoOrderSummary }
