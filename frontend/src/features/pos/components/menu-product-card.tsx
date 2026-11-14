import { Check } from "lucide-react"

import { ProductVisual } from "@/features/pos/components/product-visual"
import { getPosDemoCategoryLabel } from "@/features/pos/data/pos-demo-data"
import { formatVnd } from "@/features/pos/lib/format-vnd"
import type { PosDemoProduct } from "@/features/pos/types/pos"
import { cn } from "@/lib/utils"

type MenuProductCardProps = {
  isSelected: boolean
  product: PosDemoProduct
  onSelect: (productId: string) => void
}

function MenuProductCard({ isSelected, product, onSelect }: MenuProductCardProps) {
  const priceLabel = formatVnd(product.unitPriceVnd)

  return (
    <article
      aria-label={`${product.name}, giá minh họa ${priceLabel}`}
      className={cn(
        "relative min-h-40 min-w-0 overflow-hidden rounded-xl border bg-background transition-colors",
        isSelected && "border-primary bg-accent/70 ring-2 ring-ring/30"
      )}
    >
      <button
        type="button"
        aria-label={`Xem chi tiết ${product.name}`}
        aria-pressed={isSelected}
        className="flex h-full min-h-40 w-full min-w-0 flex-col p-3 text-left outline-none hover:bg-muted/50 focus-visible:ring-3 focus-visible:ring-ring/50"
        onClick={() => onSelect(product.id)}
      >
        <ProductVisual categoryId={product.categoryId} className="h-16 w-full" />
        {isSelected && (
          <span className="absolute top-5 right-5 flex size-7 items-center justify-center rounded-lg bg-primary text-primary-foreground">
            <Check aria-hidden="true" className="size-4" />
          </span>
        )}
        <span className="mt-3 flex min-h-0 w-full flex-1 flex-col">
          <span className="text-meta font-medium uppercase tracking-label text-muted-foreground">
            {getPosDemoCategoryLabel(product.categoryId)}
          </span>
          <span className="mt-1 block w-full truncate text-sm font-semibold">{product.name}</span>
          <span className="numeric-data mt-auto pt-3 text-sm font-semibold text-brand-coffee">
            {priceLabel}
          </span>
        </span>
      </button>
    </article>
  )
}

export { MenuProductCard }
