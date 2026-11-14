import { Info, X } from "lucide-react"

import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"
import {
  Dialog,
  DialogClose,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog"
import { ProductVisual } from "@/features/pos/components/product-visual"
import { getPosDemoCategoryLabel } from "@/features/pos/data/pos-demo-data"
import { formatVnd } from "@/features/pos/lib/format-vnd"
import type { PosDemoProduct } from "@/features/pos/types/pos"

type ProductDetailDialogProps = {
  product: PosDemoProduct | undefined
  onAddToOrder: (productId: string) => void
  onOpenChange: (open: boolean) => void
}

function ProductDetailDialog({
  product,
  onAddToOrder,
  onOpenChange,
}: ProductDetailDialogProps) {
  return (
    <Dialog open={Boolean(product)} onOpenChange={onOpenChange}>
      {product && (
        <DialogContent
          showCloseButton={false}
          className="max-h-[calc(100svh-2rem)] gap-0 overflow-y-auto p-0 sm:max-w-lg"
        >
          <DialogClose asChild>
            <Button
              type="button"
              variant="ghost"
              size="icon"
              className="absolute top-3 right-3 z-10 min-h-target min-w-target bg-card/90"
              aria-label="Đóng chi tiết sản phẩm"
            >
              <X aria-hidden="true" />
            </Button>
          </DialogClose>

          <ProductVisual
            categoryId={product.categoryId}
            className="h-40 w-full rounded-b-none rounded-t-xl sm:h-48"
            iconClassName="size-12"
          />

          <div className="p-5">
            <DialogHeader className="pr-10">
              <div className="flex flex-wrap items-center gap-2">
                <Badge variant="outline" className="rounded-lg">
                  {getPosDemoCategoryLabel(product.categoryId)}
                </Badge>
                <Badge variant="secondary" className="rounded-lg">
                  Dữ liệu demo
                </Badge>
              </div>
              <DialogTitle className="mt-2 text-page font-semibold tracking-heading">
                {product.name}
              </DialogTitle>
              <p className="numeric-data text-section font-bold text-brand-coffee">
                {formatVnd(product.unitPriceVnd)}
              </p>
              <DialogDescription className="pt-2 leading-6">
                {product.description}
              </DialogDescription>
            </DialogHeader>

            <div className="mt-5 flex gap-3 border-l-2 border-brand-clay bg-muted/30 p-3">
              <Info aria-hidden="true" className="mt-0.5 size-4 shrink-0 text-brand-clay" />
              <p className="text-xs leading-5 text-muted-foreground">
                Chưa có size, topping, modifier, công thức, tồn kho hoặc chính sách giá được phê duyệt.
              </p>
            </div>

            <Button
              type="button"
              className="mt-5 min-h-touch w-full"
              onClick={() => onAddToOrder(product.id)}
            >
              Thêm vào đơn demo
            </Button>
          </div>
        </DialogContent>
      )}
    </Dialog>
  )
}

export { ProductDetailDialog }
