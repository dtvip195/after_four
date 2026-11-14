import { PackageSearch, X } from "lucide-react"

import { Button } from "@/components/ui/button"
import {
  Sheet,
  SheetClose,
  SheetContent,
  SheetDescription,
  SheetHeader,
  SheetTitle,
} from "@/components/ui/sheet"
import { DeliveryDetailContent } from "@/features/upstairs-delivery/components/delivery-detail-content"
import type {
  DeliveryDemoOrder,
  DeliveryDemoStatus,
} from "@/features/upstairs-delivery/types/upstairs-delivery"

type DeliveryDetailProps = {
  isDesktop: boolean
  open: boolean
  order: DeliveryDemoOrder | undefined
  onClose: () => void
  onConfirmDelivered: () => void
  onOpenChange: (open: boolean) => void
  onStatusChange: (status: DeliveryDemoStatus) => void
}

function DeliveryDetail({
  isDesktop,
  open,
  order,
  onClose,
  onConfirmDelivered,
  onOpenChange,
  onStatusChange,
}: DeliveryDetailProps) {
  if (isDesktop) {
    return (
      <aside aria-label="Chi tiết delivery demo" className="min-w-0 rounded-xl border bg-card p-4">
        {order ? (
          <>
            <div className="mb-3 flex justify-end">
              <Button type="button" variant="ghost" size="icon" className="min-h-target min-w-target" aria-label="Đóng chi tiết delivery" onClick={onClose}>
                <X aria-hidden="true" />
              </Button>
            </div>
            <DeliveryDetailContent order={order} onConfirmDelivered={onConfirmDelivered} onStatusChange={onStatusChange} />
          </>
        ) : (
          <div className="flex min-h-80 flex-col items-center justify-center text-center">
            <span className="flex size-11 items-center justify-center rounded-lg bg-muted text-muted-foreground">
              <PackageSearch aria-hidden="true" className="size-5" />
            </span>
            <h2 className="mt-3 text-sm font-semibold">Chọn một đơn demo</h2>
            <p className="mt-1 max-w-56 text-xs leading-5 text-muted-foreground">
              Chi tiết bàn nhận, sản phẩm và trạng thái sẽ xuất hiện tại đây.
            </p>
          </div>
        )}
      </aside>
    )
  }

  return (
    <Sheet open={open && Boolean(order)} onOpenChange={onOpenChange}>
      {order && (
        <SheetContent side="right" showCloseButton={false} className="gap-0 overflow-y-auto p-0 data-[side=right]:w-[calc(100%-1rem)] data-[side=right]:sm:max-w-md">
          <SheetHeader className="border-b p-4 pr-14 text-left">
            <SheetTitle>Chi tiết đơn {order.code}</SheetTitle>
            <SheetDescription>Dữ liệu Upstairs Delivery minh họa tại {order.floorLabel}.</SheetDescription>
          </SheetHeader>
          <SheetClose asChild>
            <Button type="button" variant="ghost" size="icon" className="absolute top-3 right-3 min-h-target min-w-target" aria-label="Đóng chi tiết delivery">
              <X aria-hidden="true" />
            </Button>
          </SheetClose>
          <div className="p-4">
            <DeliveryDetailContent order={order} onConfirmDelivered={onConfirmDelivered} onStatusChange={onStatusChange} />
          </div>
        </SheetContent>
      )}
    </Sheet>
  )
}

export { DeliveryDetail }
