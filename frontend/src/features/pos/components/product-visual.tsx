import type { LucideIcon } from "lucide-react"
import { Coffee, CupSoda, Leaf, Sparkles } from "lucide-react"

import type { PosDemoCategoryId } from "@/features/pos/types/pos"
import { cn } from "@/lib/utils"

const productIcons: Record<PosDemoCategoryId, LucideIcon> = {
  coffee: Coffee,
  tea: Leaf,
  "non-coffee": CupSoda,
  other: Sparkles,
}

type ProductVisualProps = {
  categoryId: PosDemoCategoryId
  className?: string
  iconClassName?: string
}

function ProductVisual({ categoryId, className, iconClassName }: ProductVisualProps) {
  const ProductIcon = productIcons[categoryId]

  return (
    <span
      aria-hidden="true"
      className={cn(
        "flex items-center justify-center rounded-lg bg-muted text-muted-foreground",
        className
      )}
    >
      <ProductIcon className={cn("size-6", iconClassName)} />
    </span>
  )
}

export { ProductVisual }
